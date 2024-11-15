# Use an official GCC image to build your C application
FROM gcc:10 AS builder

# Set working directory
WORKDIR /app

# Copy all files from the current directory into the container
COPY . .

# Install necessary libraries
RUN apt-get update && apt-get install -y \
    libsqlite3-dev \
    libssl-dev

# Compile the C server code
# If you have a Makefile, ensure it's configured correctly
RUN make

# Use a lightweight image for the final container
FROM debian:buster-slim

# Set working directory
WORKDIR /app

# Install necessary libraries for runtime
RUN apt-get update && apt-get install -y \
    libsqlite3-0 \
    libssl1.1 && \
    rm -rf /var/lib/apt/lists/*

# Copy the compiled binary from the builder stage
COPY --from=builder /app/server ./

# Copy frontend files from the builder stage
COPY --from=builder /app/index.html ./
COPY --from=builder /app/styles.css ./
COPY --from=builder /app/script.js ./

# Expose the port your server listens on
EXPOSE 8080

# Command to run your server
CMD ["./server"]