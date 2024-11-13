#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <unistd.h>
#include <arpa/inet.h>
#include <sqlite3.h>
#include <openssl/evp.h>
#include <stdbool.h>

#define PORT 8080
#define BUFFER_SIZE 1024
#define MAX_USERS 100

sqlite3 *db;
bool logged_in_users[MAX_USERS] = {false}; // Array to track logged-in users by ID

void hash_password(const char *password, char *hashed_password)
{
	unsigned char hash[EVP_MAX_MD_SIZE];
	unsigned int hash_len;
	EVP_MD_CTX *mdctx;

	if ((mdctx = EVP_MD_CTX_new()) == NULL)
	{
		perror("EVP_MD_CTX_new failed");
		exit(EXIT_FAILURE);
	}

	if (1 != EVP_DigestInit_ex(mdctx, EVP_sha256(), NULL))
	{
		perror("EVP_DigestInit_ex failed");
		exit(EXIT_FAILURE);
	}

	if (1 != EVP_DigestUpdate(mdctx, password, strlen(password)))
	{
		perror("EVP_DigestUpdate failed");
		exit(EXIT_FAILURE);
	}

	if (1 != EVP_DigestFinal_ex(mdctx, hash, &hash_len))
	{
		perror("EVP_DigestFinal_ex failed");
		exit(EXIT_FAILURE);
	}

	EVP_MD_CTX_free(mdctx);

	for (unsigned int i = 0; i < hash_len; i++)
	{
		sprintf(hashed_password + (i * 2), "%02x", hash[i]);
	}
	hashed_password[hash_len * 2] = 0; // Null-terminate the string
}

int get_user_id(const char *username)
{
	sqlite3_stmt *stmt;
	const char *sql = "SELECT id FROM users WHERE username = ?";

	int rc = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
	if (rc != SQLITE_OK)
	{
		fprintf(stderr, "Failed to prepare statement: %s\n", sqlite3_errmsg(db));
		return -1;
	}

	sqlite3_bind_text(stmt, 1, username, -1, SQLITE_STATIC);

	int user_id = -1;
	rc = sqlite3_step(stmt);
	if (rc == SQLITE_ROW)
	{
		user_id = sqlite3_column_int(stmt, 0);
	}
	else
	{
		fprintf(stderr, "Failed to execute query: %s\n", sqlite3_errmsg(db));
	}

	sqlite3_finalize(stmt);
	return user_id;
}

int authenticate_user(const char *username, const char *password)
{
	char hashed_password[65];
	printf("Password before hashing: %s\n", password);
	hash_password(password, hashed_password);

	printf("Authenticating user: %s\n", username);
	printf("Hashed password: %s\n", hashed_password);

	sqlite3_stmt *stmt;
	const char *sql = "SELECT id FROM users WHERE username = ? AND password = ?";

	int rc = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
	if (rc != SQLITE_OK)
	{
		fprintf(stderr, "Failed to prepare statement: %s\n", sqlite3_errmsg(db));
		return -1;
	}

	sqlite3_bind_text(stmt, 1, username, -1, SQLITE_STATIC);
	sqlite3_bind_text(stmt, 2, hashed_password, -1, SQLITE_STATIC);

	int user_id = -1;
	rc = sqlite3_step(stmt);
	if (rc == SQLITE_ROW)
	{
		user_id = sqlite3_column_int(stmt, 0);
	}
	else
	{
		fprintf(stderr, "Failed to execute query: %s\n", sqlite3_errmsg(db));
	}

	sqlite3_finalize(stmt);

	return user_id;
}

void register_user(const char *username, const char *password)
{
	char hashed_password[65];
	printf("Password before hashing: %s\n", password);
	hash_password(password, hashed_password);

	printf("Registering user: %s\n", username);
	printf("Hashed password: %s\n", hashed_password);

	char *err_msg = 0;
	char sql[256];
	snprintf(sql, sizeof(sql), "INSERT INTO users (username, password) VALUES ('%s', '%s');", username, hashed_password);

	printf("SQL query: %s\n", sql);

	int rc = sqlite3_exec(db, sql, 0, 0, &err_msg);
	if (rc != SQLITE_OK)
	{
		fprintf(stderr, "SQL error: %s\n", err_msg);
		sqlite3_free(err_msg);
	}
	else
	{
		fprintf(stderr, "User registered successfully\n");
	}
}

void handle_client(int client_socket)
{
	char buffer[BUFFER_SIZE];
	int bytes_read = read(client_socket, buffer, BUFFER_SIZE - 1);
	if (bytes_read < 0)
	{
		perror("Failed to read from socket");
		close(client_socket);
		return;
	}
	buffer[bytes_read] = '\0'; // Null-terminate the buffer
	printf("Received request:\n%s\n", buffer);

	// Parse HTTP request (simplified)
	if (strstr(buffer, "POST /register") != NULL)
	{
		// Extract username and password from the request body
		char *body = strstr(buffer, "\r\n\r\n");
		if (body)
		{
			body += 4; // Skip the "\r\n\r\n"
			char username[50] = {0}, password[50] = {0};

			char *token = strtok(body, "&");
			while (token != NULL)
			{
				if (strncmp(token, "username=", 9) == 0)
				{
					strncpy(username, token + 9, sizeof(username) - 1);
				}
				else if (strncmp(token, "password=", 9) == 0)
				{
					strncpy(password, token + 9, sizeof(password) - 1);
				}
				token = strtok(NULL, "&");
			}

			printf("Extracted username: %s\n", username);
			printf("Extracted password: %s\n", password);

			// Register the user
			register_user(username, password);

			// Send response
			const char *response_body = "User registered";
			char response[BUFFER_SIZE];
			snprintf(response, sizeof(response),
				 "HTTP/1.1 200 OK\n"
				 "Content-Type: text/plain\n"
				 "Content-Length: %zu\n\n"
				 "%s",
				 strlen(response_body), response_body);
			write(client_socket, response, strlen(response));
		}
	}
	else if (strstr(buffer, "POST /login") != NULL)
	{
		// Extract username and password from the request body
		char *body = strstr(buffer, "\r\n\r\n");
		if (body)
		{
			body += 4; // Skip the "\r\n\r\n"
			char username[50] = {0}, password[50] = {0};

			char *token = strtok(body, "&");
			while (token != NULL)
			{
				if (strncmp(token, "username=", 9) == 0)
				{
					strncpy(username, token + 9, sizeof(username) - 1);
				}
				else if (strncmp(token, "password=", 9) == 0)
				{
					strncpy(password, token + 9, sizeof(password) - 1);
				}
				token = strtok(NULL, "&");
			}

			printf("Extracted username: %s\n", username);
			printf("Extracted password: %s\n", password);

			// Authenticate the user
			int user_id = authenticate_user(username, password);

			// Check if the user is already logged in
			if (user_id >= 0 && user_id < MAX_USERS)
			{
				if (logged_in_users[user_id])
				{
					// Send response
					const char *response_body = "User already logged in";
					char response[BUFFER_SIZE];
					snprintf(response, sizeof(response),
						 "HTTP/1.1 200 OK\n"
						 "Content-Type: text/plain\n"
						 "Content-Length: %zu\n\n"
						 "%s",
						 strlen(response_body), response_body);
					write(client_socket, response, strlen(response));
				}
				else
				{
					logged_in_users[user_id] = true; // Mark the user as logged in

					// Send response
					const char *response_body = "Login successful";
					char response[BUFFER_SIZE];
					snprintf(response, sizeof(response),
						 "HTTP/1.1 200 OK\n"
						 "Content-Type: text/plain\n"
						 "Content-Length: %zu\n\n"
						 "%s",
						 strlen(response_body), response_body);
					write(client_socket, response, strlen(response));
				}
			}
			else
			{
				// Send response
				const char *response_body = "Invalid username or password";
				char response[BUFFER_SIZE];
				snprintf(response, sizeof(response),
					 "HTTP/1.1 200 OK\n"
					 "Content-Type: text/plain\n"
					 "Content-Length: %zu\n\n"
					 "%s",
					 strlen(response_body), response_body);
				write(client_socket, response, strlen(response));
			}
		}
	}
	else if (strstr(buffer, "POST /save") != NULL)
	{
		// Extract user ID and data from the request body
		char *body = strstr(buffer, "\r\n\r\n");
		if (body)
		{
			body += 4; // Skip the "\r\n\r\n"
			int user_id;
			char data[BUFFER_SIZE] = {0};

			sscanf(body, "id=%d&data=%s", &user_id, data);

			if (user_id >= 0 && user_id < MAX_USERS && logged_in_users[user_id])
			{
				// Save data for the user
				char *err_msg = 0;
				char sql[BUFFER_SIZE];
				snprintf(sql, sizeof(sql), "UPDATE users SET data = '%s' WHERE id = %d;", data, user_id);

				printf("SQL query: %s\n", sql);

				int rc = sqlite3_exec(db, sql, 0, 0, &err_msg);
				if (rc != SQLITE_OK)
				{
					fprintf(stderr, "SQL error: %s\n", err_msg);
					sqlite3_free(err_msg);
				}
				else
				{
					fprintf(stderr, "Data saved successfully\n");
				}

				// Send response
				const char *response_body = "Data saved";
				char response[BUFFER_SIZE];
				snprintf(response, sizeof(response),
					 "HTTP/1.1 200 OK\n"
					 "Content-Type: text/plain\n"
					 "Content-Length: %zu\n\n"
					 "%s",
					 strlen(response_body), response_body);
				write(client_socket, response, strlen(response));
			}
			else
			{
				// Send response
				const char *response_body = "Invalid user ID or not logged in";
				char response[BUFFER_SIZE];
				snprintf(response, sizeof(response),
					 "HTTP/1.1 200 OK\n"
					 "Content-Type: text/plain\n"
					 "Content-Length: %zu\n\n"
					 "%s",
					 strlen(response_body), response_body);
				write(client_socket, response, strlen(response));
			}
		}
	}
	else if (strstr(buffer, "GET /load") != NULL)
	{
		// Extract user ID from the query parameters
		char *query = strstr(buffer, "GET /load?");
		if (query)
		{
			query += 10; // Skip the "GET /load?" part
			int user_id;
			sscanf(query, "id=%d", &user_id);
			printf("Extracted user ID: %d\n", user_id);

			// Debug print login status
			printf("User %d login status: %d\n", user_id, logged_in_users[user_id]);

			if (user_id >= 0 && user_id < MAX_USERS)
			{
				// Load data for the user
				sqlite3_stmt *stmt;
				const char *sql = "SELECT data FROM users WHERE id = ?";

				int rc = sqlite3_prepare_v2(db, sql, -1, &stmt, NULL);
				if (rc != SQLITE_OK)
				{
					fprintf(stderr, "Failed to prepare statement: %s\n", sqlite3_errmsg(db));
					const char *response_body = "Database error";
					char response[BUFFER_SIZE];
					snprintf(response, sizeof(response),
						 "HTTP/1.1 500 Internal Server Error\r\n"
						 "Content-Type: text/plain\r\n"
						 "Content-Length: %zu\r\n"
						 "\r\n"
						 "%s",
						 strlen(response_body), response_body);
					write(client_socket, response, strlen(response));
					sqlite3_finalize(stmt);
					return;
				}

				sqlite3_bind_int(stmt, 1, user_id);

				rc = sqlite3_step(stmt);
				if (rc == SQLITE_ROW)
				{
					const char *data = (const char *)sqlite3_column_text(stmt, 0);
					if (data)
					{
						printf("Loading data for user ID %d: %s\n", user_id, data);
						char response[BUFFER_SIZE];
						snprintf(response, sizeof(response),
							 "HTTP/1.1 200 OK\r\n"
							 "Content-Type: text/plain\r\n"
							 "Content-Length: %zu\r\n"
							 "\r\n"
							 "%s",
							 strlen(data), data);
						write(client_socket, response, strlen(response));
					}
					else
					{
						const char *response_body = "No data found";
						char response[BUFFER_SIZE];
						snprintf(response, sizeof(response),
							 "HTTP/1.1 200 OK\r\n"
							 "Content-Type: text/plain\r\n"
							 "Content-Length: %zu\r\n"
							 "\r\n"
							 "%s",
							 strlen(response_body), response_body);
						write(client_socket, response, strlen(response));
					}
				}
				else
				{
					const char *response_body = "User not found";
					char response[BUFFER_SIZE];
					snprintf(response, sizeof(response),
						 "HTTP/1.1 404 Not Found\r\n"
						 "Content-Type: text/plain\r\n"
						 "Content-Length: %zu\r\n"
						 "\r\n"
						 "%s",
						 strlen(response_body), response_body);
					write(client_socket, response, strlen(response));
				}
				sqlite3_finalize(stmt);
			}
			else
			{
				const char *response_body = "Invalid user ID";
				char response[BUFFER_SIZE];
				snprintf(response, sizeof(response),
					 "HTTP/1.1 400 Bad Request\r\n"
					 "Content-Type: text/plain\r\n"
					 "Content-Length: %zu\r\n"
					 "\r\n"
					 "%s",
					 strlen(response_body), response_body);
				write(client_socket, response, strlen(response));
			}
		}
	}
	else
	{
		// Simple HTTP response for other requests
		const char *response_body = "i love furina so much fr fr";
		char response[BUFFER_SIZE];
		snprintf(response, sizeof(response),
			 "HTTP/1.1 200 OK\n"
			 "Content-Type: text/plain\n"
			 "Content-Length: %zu\n\n"
			 "%s",
			 strlen(response_body), response_body);
		write(client_socket, response, strlen(response));
	}

	close(client_socket);
}

void init_db()
{
	int rc = sqlite3_open("virtual_lab.db", &db);
	if (rc)
	{
		fprintf(stderr, "Can't open database: %s\n", sqlite3_errmsg(db));
		exit(EXIT_FAILURE);
	}
	else
	{
		fprintf(stderr, "Opened database successfully\n");
	}

	char *sql = "CREATE TABLE IF NOT EXISTS users ("
		    "id INTEGER PRIMARY KEY AUTOINCREMENT,"
		    "username TEXT NOT NULL,"
		    "password TEXT NOT NULL,"
		    "data TEXT);";

	char *err_msg = 0;
	rc = sqlite3_exec(db, sql, 0, 0, &err_msg);
	if (rc != SQLITE_OK)
	{
		fprintf(stderr, "SQL error: %s\n", err_msg);
		sqlite3_free(err_msg);
		exit(EXIT_FAILURE);
	}
	else
	{
		fprintf(stderr, "Tables created successfully\n");
	}
}

void close_db()
{
	sqlite3_close(db);
}

int main()
{
	int server_socket, client_socket;
	struct sockaddr_in server_addr, client_addr;
	socklen_t addr_len = sizeof(client_addr);

	// Initialize database
	init_db();

	// Create socket
	server_socket = socket(AF_INET, SOCK_STREAM, 0);
	if (server_socket == -1)
	{
		perror("Socket creation failed");
		exit(EXIT_FAILURE);
	}

	// Bind socket to port
	server_addr.sin_family = AF_INET;
	server_addr.sin_addr.s_addr = INADDR_ANY;
	server_addr.sin_port = htons(PORT);
	if (bind(server_socket, (struct sockaddr *)&server_addr, sizeof(server_addr)) == -1)
	{
		perror("Bind failed");
		close(server_socket);
		exit(EXIT_FAILURE);
	}

	// Listen for connections
	if (listen(server_socket, 10) == -1)
	{
		perror("Listen failed");
		close(server_socket);
		exit(EXIT_FAILURE);
	}

	printf("Server is listening on port %d\n", PORT);

	// Accept and handle client connections
	while ((client_socket = accept(server_socket, (struct sockaddr *)&client_addr, &addr_len)) != -1)
	{
		handle_client(client_socket);
	}

	close(server_socket);
	close_db();
}