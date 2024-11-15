	.file	"http.c"
	.text
	.globl	db
	.bss
	.align 8
	.type	db, @object
	.size	db, 8
db:
	.zero	8
	.globl	logged_in_users
	.align 32
	.type	logged_in_users, @object
	.size	logged_in_users, 100
logged_in_users:
	.zero	100
	.section	.rodata
.LC0:
	.string	"EVP_MD_CTX_new failed"
.LC1:
	.string	"EVP_DigestInit_ex failed"
.LC2:
	.string	"EVP_DigestUpdate failed"
.LC3:
	.string	"EVP_DigestFinal_ex failed"
.LC4:
	.string	"%02x"
	.text
	.globl	hash_password
	.type	hash_password, @function
hash_password:
.LFB319:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$112, %rsp
	movq	%rdi, -104(%rbp)
	movq	%rsi, -112(%rbp)
	call	EVP_MD_CTX_new
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	jne	.L2
	movl	$.LC0, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L2:
	call	EVP_sha256
	movq	%rax, %rcx
	movq	-16(%rbp), %rax
	movl	$0, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	EVP_DigestInit_ex
	cmpl	$1, %eax
	je	.L3
	movl	$.LC1, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L3:
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-104(%rbp), %rcx
	movq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	EVP_DigestUpdate
	cmpl	$1, %eax
	je	.L4
	movl	$.LC2, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L4:
	leaq	-84(%rbp), %rdx
	leaq	-80(%rbp), %rcx
	movq	-16(%rbp), %rax
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	EVP_DigestFinal_ex
	cmpl	$1, %eax
	je	.L5
	movl	$.LC3, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L5:
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	EVP_MD_CTX_free
	movl	$0, -4(%rbp)
	jmp	.L6
.L7:
	movl	-4(%rbp), %eax
	movzbl	-80(%rbp,%rax), %eax
	movzbl	%al, %eax
	movl	-4(%rbp), %edx
	addl	%edx, %edx
	movl	%edx, %ecx
	movq	-112(%rbp), %rdx
	addq	%rdx, %rcx
	movl	%eax, %edx
	movl	$.LC4, %esi
	movq	%rcx, %rdi
	movl	$0, %eax
	call	sprintf
	addl	$1, -4(%rbp)
.L6:
	movl	-84(%rbp), %eax
	cmpl	%eax, -4(%rbp)
	jb	.L7
	movl	-84(%rbp), %eax
	addl	%eax, %eax
	movl	%eax, %edx
	movq	-112(%rbp), %rax
	addq	%rdx, %rax
	movb	$0, (%rax)
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE319:
	.size	hash_password, .-hash_password
	.section	.rodata
	.align 8
.LC5:
	.string	"SELECT id FROM users WHERE username = ?"
	.align 8
.LC6:
	.string	"Failed to prepare statement: %s\n"
	.text
	.globl	username_exists
	.type	username_exists, @function
username_exists:
.LFB320:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	$.LC5, -16(%rbp)
	movb	$0, -1(%rbp)
	movq	db(%rip), %rax
	leaq	-32(%rbp), %rdx
	movq	-16(%rbp), %rsi
	movl	$0, %r8d
	movq	%rdx, %rcx
	movl	$-1, %edx
	movq	%rax, %rdi
	call	sqlite3_prepare_v2
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	je	.L9
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC6, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %eax
	jmp	.L12
.L9:
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rdx
	movl	$0, %r8d
	movl	$-1, %ecx
	movl	$1, %esi
	movq	%rax, %rdi
	call	sqlite3_bind_text
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_step
	movl	%eax, -20(%rbp)
	cmpl	$100, -20(%rbp)
	jne	.L11
	movb	$1, -1(%rbp)
.L11:
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	movzbl	-1(%rbp), %eax
.L12:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE320:
	.size	username_exists, .-username_exists
	.section	.rodata
.LC7:
	.string	"text/plain"
.LC8:
	.string	".html"
.LC9:
	.string	"text/html"
.LC10:
	.string	".css"
.LC11:
	.string	"text/css"
.LC12:
	.string	".js"
.LC13:
	.string	"application/javascript"
	.text
	.globl	get_content_type
	.type	get_content_type, @function
get_content_type:
.LFB321:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movq	%rdi, -24(%rbp)
	movq	-24(%rbp), %rax
	movl	$46, %esi
	movq	%rax, %rdi
	call	strrchr
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L14
	movl	$.LC7, %eax
	jmp	.L15
.L14:
	movq	-8(%rbp), %rax
	movl	$.LC8, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L16
	movl	$.LC9, %eax
	jmp	.L15
.L16:
	movq	-8(%rbp), %rax
	movl	$.LC10, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L17
	movl	$.LC11, %eax
	jmp	.L15
.L17:
	movq	-8(%rbp), %rax
	movl	$.LC12, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L18
	movl	$.LC13, %eax
	jmp	.L15
.L18:
	movl	$.LC7, %eax
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE321:
	.size	get_content_type, .-get_content_type
	.section	.rodata
.LC14:
	.string	"rb"
	.align 8
.LC15:
	.string	"HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\n\r\nFile not found"
	.align 8
.LC16:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: %s\r\nContent-Length: %ld\r\nAccess-Control-Allow-Origin: *\r\n\r\n"
	.text
	.globl	serve_file
	.type	serve_file, @function
serve_file:
.LFB322:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$1072, %rsp
	movl	%edi, -1060(%rbp)
	movq	%rsi, -1072(%rbp)
	movq	-1072(%rbp), %rax
	movl	$.LC14, %esi
	movq	%rax, %rdi
	call	fopen
	movq	%rax, -8(%rbp)
	cmpq	$0, -8(%rbp)
	jne	.L20
	movq	$.LC15, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-32(%rbp), %rcx
	movl	-1060(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L19
.L20:
	movq	-8(%rbp), %rax
	movl	$2, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	ftell
	movq	%rax, -16(%rbp)
	movq	-8(%rbp), %rax
	movl	$0, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	fseek
	movq	-16(%rbp), %rax
	movq	%rax, %rdi
	call	malloc
	movq	%rax, -24(%rbp)
	movq	-16(%rbp), %rdx
	movq	-8(%rbp), %rcx
	movq	-24(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	fread
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	fclose
	movq	-1072(%rbp), %rax
	movq	%rax, %rdi
	call	get_content_type
	movq	%rax, %rdx
	movq	-16(%rbp), %rcx
	leaq	-1056(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC16, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-1056(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-1056(%rbp), %rcx
	movl	-1060(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	movq	-16(%rbp), %rdx
	movq	-24(%rbp), %rcx
	movl	-1060(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	free
.L19:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE322:
	.size	serve_file, .-serve_file
	.section	.rodata
.LC17:
	.string	"Failed to execute query: %s\n"
	.text
	.globl	get_user_id
	.type	get_user_id, @function
get_user_id:
.LFB323:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -40(%rbp)
	movq	$.LC5, -16(%rbp)
	movq	db(%rip), %rax
	leaq	-32(%rbp), %rdx
	movq	-16(%rbp), %rsi
	movl	$0, %r8d
	movq	%rdx, %rcx
	movl	$-1, %edx
	movq	%rax, %rdi
	call	sqlite3_prepare_v2
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	je	.L23
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC6, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$-1, %eax
	jmp	.L27
.L23:
	movq	-32(%rbp), %rax
	movq	-40(%rbp), %rdx
	movl	$0, %r8d
	movl	$-1, %ecx
	movl	$1, %esi
	movq	%rax, %rdi
	call	sqlite3_bind_text
	movl	$-1, -4(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_step
	movl	%eax, -20(%rbp)
	cmpl	$100, -20(%rbp)
	jne	.L25
	movq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	sqlite3_column_int
	movl	%eax, -4(%rbp)
	jmp	.L26
.L25:
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
.L26:
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	movl	-4(%rbp), %eax
.L27:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE323:
	.size	get_user_id, .-get_user_id
	.section	.rodata
.LC18:
	.string	"Password before hashing: %s\n"
.LC19:
	.string	"Authenticating user: %s\n"
.LC20:
	.string	"Hashed password: %s\n"
	.align 8
.LC21:
	.string	"SELECT id FROM users WHERE username = ? AND password = ?"
	.text
	.globl	authenticate_user
	.type	authenticate_user, @function
authenticate_user:
.LFB324:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	addq	$-128, %rsp
	movq	%rdi, -120(%rbp)
	movq	%rsi, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC18, %edi
	movl	$0, %eax
	call	printf
	leaq	-96(%rbp), %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hash_password
	movq	-120(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC19, %edi
	movl	$0, %eax
	call	printf
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC20, %edi
	movl	$0, %eax
	call	printf
	movq	$.LC21, -16(%rbp)
	movq	db(%rip), %rax
	leaq	-104(%rbp), %rdx
	movq	-16(%rbp), %rsi
	movl	$0, %r8d
	movq	%rdx, %rcx
	movl	$-1, %edx
	movq	%rax, %rdi
	call	sqlite3_prepare_v2
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	je	.L29
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC6, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$-1, %eax
	jmp	.L33
.L29:
	movq	-104(%rbp), %rax
	movq	-120(%rbp), %rdx
	movl	$0, %r8d
	movl	$-1, %ecx
	movl	$1, %esi
	movq	%rax, %rdi
	call	sqlite3_bind_text
	movq	-104(%rbp), %rax
	leaq	-96(%rbp), %rdx
	movl	$0, %r8d
	movl	$-1, %ecx
	movl	$2, %esi
	movq	%rax, %rdi
	call	sqlite3_bind_text
	movl	$-1, -4(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_step
	movl	%eax, -20(%rbp)
	cmpl	$100, -20(%rbp)
	jne	.L31
	movq	-104(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	sqlite3_column_int
	movl	%eax, -4(%rbp)
	jmp	.L32
.L31:
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
.L32:
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	movl	-4(%rbp), %eax
.L33:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE324:
	.size	authenticate_user, .-authenticate_user
	.section	.rodata
.LC22:
	.string	"Registering user: %s\n"
	.align 8
.LC23:
	.string	"INSERT INTO users (username, password) VALUES ('%s', '%s');"
.LC24:
	.string	"SQL query: %s\n"
.LC25:
	.string	"SQL error: %s\n"
.LC26:
	.string	"User registered successfully\n"
	.text
	.globl	register_user
	.type	register_user, @function
register_user:
.LFB325:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$368, %rsp
	movq	%rdi, -360(%rbp)
	movq	%rsi, -368(%rbp)
	movq	-368(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC18, %edi
	movl	$0, %eax
	call	printf
	leaq	-80(%rbp), %rdx
	movq	-368(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hash_password
	movq	-360(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC22, %edi
	movl	$0, %eax
	call	printf
	leaq	-80(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC20, %edi
	movl	$0, %eax
	call	printf
	movq	$0, -88(%rbp)
	leaq	-80(%rbp), %rcx
	movq	-360(%rbp), %rdx
	leaq	-352(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC23, %edx
	movl	$256, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC24, %edi
	movl	$0, %eax
	call	printf
	movq	db(%rip), %rax
	leaq	-88(%rbp), %rdx
	leaq	-352(%rbp), %rsi
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	sqlite3_exec
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	je	.L35
	movq	-88(%rbp), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC25, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_free
	jmp	.L37
.L35:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$29, %edx
	movl	$1, %esi
	movl	$.LC26, %edi
	call	fwrite
.L37:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE325:
	.size	register_user, .-register_user
	.section	.rodata
.LC27:
	.string	"Failed to read from socket"
.LC28:
	.string	"Received request:\n%s\n"
.LC29:
	.string	"POST /register"
.LC30:
	.string	"\r\n\r\n"
.LC31:
	.string	"&"
.LC32:
	.string	"username="
.LC33:
	.string	"password="
.LC34:
	.string	"Extracted username: %s\n"
.LC35:
	.string	"Extracted password: %s\n"
.LC36:
	.string	"Username already registered"
	.align 8
.LC37:
	.string	"HTTP/1.1 409 Conflict\r\nContent-Type: text/plain\r\nContent-Length: %zu\r\n\r\n%s"
.LC38:
	.string	"User registered"
	.align 8
.LC39:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: %zu\r\n\r\n%s"
.LC40:
	.string	"POST /login"
.LC41:
	.string	"User already logged in"
	.align 8
.LC42:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nAccess-Control-Allow-Origin: *\r\nContent-Length: %zu\r\n\r\n%s"
.LC43:
	.string	"Login successful"
.LC44:
	.string	"Invalid username or password"
	.align 8
.LC45:
	.string	"HTTP/1.1 200 OK\nContent-Type: text/plain\nContent-Length: %zu\n\n%s"
.LC46:
	.string	"POST /save"
.LC47:
	.string	"id=%d&data=%s"
	.align 8
.LC48:
	.string	"UPDATE users SET data = '%s' WHERE id = %d;"
.LC49:
	.string	"Failed to save state"
	.align 8
.LC50:
	.string	"HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/plain\r\nContent-Length: %zu\r\n\r\n%s"
.LC51:
	.string	"State saved"
	.align 8
.LC52:
	.string	"Invalid user ID or not logged in"
.LC53:
	.string	"GET /load"
.LC54:
	.string	"GET /load?"
.LC55:
	.string	"id=%d"
.LC56:
	.string	"Extracted user ID: %d\n"
.LC57:
	.string	"User %d login status: %d\n"
	.align 8
.LC58:
	.string	"SELECT data FROM users WHERE id = ?"
.LC59:
	.string	"Database error"
	.align 8
.LC60:
	.string	"Loading data for user ID %d: %s\n"
.LC61:
	.string	"No data found"
.LC62:
	.string	"User not found"
	.align 8
.LC63:
	.string	"HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: %zu\r\n\r\n%s"
.LC64:
	.string	"Invalid user ID"
	.align 8
.LC65:
	.string	"HTTP/1.1 400 Bad Request\r\nContent-Type: text/plain\r\nContent-Length: %zu\r\n\r\n%s"
.LC66:
	.string	"POST /logout"
.LC67:
	.string	"Logout successful"
.LC68:
	.string	"GET /getUserId"
.LC69:
	.string	"GET /getUserId?name="
.LC70:
	.string	" &"
	.align 8
.LC71:
	.string	"Looking up user ID for username: %s\n"
.LC72:
	.string	"Found user_id: %d\n"
.LC73:
	.string	"%d"
	.align 8
.LC74:
	.string	"HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nAccess-Control-Allow-Origin: *\r\nContent-Length: %zu\r\n\r\n%s"
.LC75:
	.string	"%s %s %s"
.LC76:
	.string	"GET"
.LC77:
	.string	"/"
.LC78:
	.string	"/index.html"
.LC79:
	.string	"index.html"
	.align 8
.LC80:
	.string	"HTTP/1.1 404 Not Found\r\n\r\nEndpoint not found"
	.text
	.globl	handle_client
	.type	handle_client, @function
handle_client:
.LFB326:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$4448, %rsp
	movl	%edi, -4436(%rbp)
	leaq	-1296(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movl	$1023, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	movl	%eax, -36(%rbp)
	cmpl	$0, -36(%rbp)
	jns	.L39
	movl	$.LC27, %edi
	call	perror
	movl	-4436(%rbp), %eax
	movl	%eax, %edi
	call	close
	jmp	.L38
.L39:
	movl	-36(%rbp), %eax
	cltq
	movb	$0, -1296(%rbp,%rax)
	leaq	-1296(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC28, %edi
	movl	$0, %eax
	call	printf
	leaq	-1296(%rbp), %rax
	movl	$.LC29, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L41
	leaq	-1296(%rbp), %rax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -256(%rbp)
	cmpq	$0, -256(%rbp)
	je	.L42
	addq	$4, -256(%rbp)
	movq	$0, -4432(%rbp)
	movq	$0, -4424(%rbp)
	movq	$0, -4416(%rbp)
	movq	$0, -4408(%rbp)
	movq	$0, -4400(%rbp)
	movq	$0, -4392(%rbp)
	movw	$0, -4384(%rbp)
	movq	$0, -3408(%rbp)
	movq	$0, -3400(%rbp)
	movq	$0, -3392(%rbp)
	movq	$0, -3384(%rbp)
	movq	$0, -3376(%rbp)
	movq	$0, -3368(%rbp)
	movw	$0, -3360(%rbp)
	movq	-256(%rbp), %rax
	movl	$.LC31, %esi
	movq	%rax, %rdi
	call	strtok
	movq	%rax, -8(%rbp)
	jmp	.L43
.L46:
	movq	-8(%rbp), %rax
	movl	$9, %edx
	movl	$.LC32, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L44
	movq	-8(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-4432(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
	jmp	.L45
.L44:
	movq	-8(%rbp), %rax
	movl	$9, %edx
	movl	$.LC33, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L45
	movq	-8(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-3408(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
.L45:
	movl	$.LC31, %esi
	movl	$0, %edi
	call	strtok
	movq	%rax, -8(%rbp)
.L43:
	cmpq	$0, -8(%rbp)
	jne	.L46
	leaq	-4432(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC34, %edi
	movl	$0, %eax
	call	printf
	leaq	-3408(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC35, %edi
	movl	$0, %eax
	call	printf
	leaq	-4432(%rbp), %rax
	movq	%rax, %rdi
	call	username_exists
	testb	%al, %al
	je	.L47
	movq	$.LC36, -272(%rbp)
	movq	-272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-272(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC37, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L47:
	leaq	-3408(%rbp), %rdx
	leaq	-4432(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	register_user
	movq	$.LC38, -264(%rbp)
	movq	-264(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-264(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC39, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L41:
	leaq	-1296(%rbp), %rax
	movl	$.LC40, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L49
	leaq	-1296(%rbp), %rax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -216(%rbp)
	cmpq	$0, -216(%rbp)
	je	.L42
	addq	$4, -216(%rbp)
	movq	$0, -4432(%rbp)
	movq	$0, -4424(%rbp)
	movq	$0, -4416(%rbp)
	movq	$0, -4408(%rbp)
	movq	$0, -4400(%rbp)
	movq	$0, -4392(%rbp)
	movw	$0, -4384(%rbp)
	movq	$0, -3408(%rbp)
	movq	$0, -3400(%rbp)
	movq	$0, -3392(%rbp)
	movq	$0, -3384(%rbp)
	movq	$0, -3376(%rbp)
	movq	$0, -3368(%rbp)
	movw	$0, -3360(%rbp)
	movq	-216(%rbp), %rax
	movl	$.LC31, %esi
	movq	%rax, %rdi
	call	strtok
	movq	%rax, -16(%rbp)
	jmp	.L50
.L53:
	movq	-16(%rbp), %rax
	movl	$9, %edx
	movl	$.LC32, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L51
	movq	-16(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-4432(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
	jmp	.L52
.L51:
	movq	-16(%rbp), %rax
	movl	$9, %edx
	movl	$.LC33, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L52
	movq	-16(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-3408(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
.L52:
	movl	$.LC31, %esi
	movl	$0, %edi
	call	strtok
	movq	%rax, -16(%rbp)
.L50:
	cmpq	$0, -16(%rbp)
	jne	.L53
	leaq	-4432(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC34, %edi
	movl	$0, %eax
	call	printf
	leaq	-3408(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC35, %edi
	movl	$0, %eax
	call	printf
	leaq	-3408(%rbp), %rdx
	leaq	-4432(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	authenticate_user
	movl	%eax, -220(%rbp)
	cmpl	$0, -220(%rbp)
	js	.L54
	cmpl	$99, -220(%rbp)
	jg	.L54
	movl	-220(%rbp), %eax
	cltq
	movzbl	logged_in_users(%rax), %eax
	testb	%al, %al
	je	.L55
	movq	$.LC41, -240(%rbp)
	movq	-240(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-240(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC42, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L55:
	movl	-220(%rbp), %eax
	cltq
	movb	$1, logged_in_users(%rax)
	movq	$.LC43, -232(%rbp)
	movq	-232(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-232(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC42, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L54:
	movq	$.LC44, -248(%rbp)
	movq	-248(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-248(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC45, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L49:
	leaq	-1296(%rbp), %rax
	movl	$.LC46, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L58
	leaq	-1296(%rbp), %rax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -176(%rbp)
	cmpq	$0, -176(%rbp)
	je	.L42
	addq	$4, -176(%rbp)
	leaq	-4432(%rbp), %rdx
	movl	$0, %eax
	movl	$128, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	-4432(%rbp), %rcx
	leaq	-1300(%rbp), %rdx
	movq	-176(%rbp), %rax
	movl	$.LC47, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	movl	-1300(%rbp), %eax
	testl	%eax, %eax
	js	.L59
	movl	-1300(%rbp), %eax
	cmpl	$99, %eax
	jg	.L59
	movl	-1300(%rbp), %eax
	cltq
	movzbl	logged_in_users(%rax), %eax
	testb	%al, %al
	je	.L59
	movq	$0, -1312(%rbp)
	movl	-1300(%rbp), %ecx
	leaq	-4432(%rbp), %rdx
	leaq	-3408(%rbp), %rax
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movl	$.LC48, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-3408(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC24, %edi
	movl	$0, %eax
	call	printf
	movq	db(%rip), %rax
	leaq	-1312(%rbp), %rdx
	leaq	-3408(%rbp), %rsi
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	sqlite3_exec
	movl	%eax, -180(%rbp)
	cmpl	$0, -180(%rbp)
	je	.L60
	movq	-1312(%rbp), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC25, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-1312(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_free
	movq	$.LC49, -200(%rbp)
	movq	-200(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-200(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC50, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L60:
	movq	$.LC51, -192(%rbp)
	movq	-192(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-192(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC39, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L59:
	movq	$.LC52, -208(%rbp)
	movq	-208(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-208(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC45, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L58:
	leaq	-1296(%rbp), %rax
	movl	$.LC53, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L63
	leaq	-1296(%rbp), %rax
	movl	$.LC54, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -112(%rbp)
	cmpq	$0, -112(%rbp)
	je	.L42
	addq	$10, -112(%rbp)
	leaq	-1316(%rbp), %rdx
	movq	-112(%rbp), %rax
	movl	$.LC55, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	movl	-1316(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC56, %edi
	movl	$0, %eax
	call	printf
	movl	-1316(%rbp), %eax
	cltq
	movzbl	logged_in_users(%rax), %eax
	movzbl	%al, %edx
	movl	-1316(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC57, %edi
	movl	$0, %eax
	call	printf
	movl	-1316(%rbp), %eax
	testl	%eax, %eax
	js	.L64
	movl	-1316(%rbp), %eax
	cmpl	$99, %eax
	jg	.L64
	movq	$.LC58, -120(%rbp)
	movq	db(%rip), %rax
	leaq	-1328(%rbp), %rdx
	movq	-120(%rbp), %rsi
	movl	$0, %r8d
	movq	%rdx, %rcx
	movl	$-1, %edx
	movq	%rax, %rdi
	call	sqlite3_prepare_v2
	movl	%eax, -124(%rbp)
	cmpl	$0, -124(%rbp)
	je	.L65
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC6, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	$.LC59, -160(%rbp)
	movq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-160(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC50, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	movq	-1328(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	jmp	.L38
.L65:
	movl	-1316(%rbp), %edx
	movq	-1328(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	sqlite3_bind_int
	movq	-1328(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_step
	movl	%eax, -124(%rbp)
	cmpl	$100, -124(%rbp)
	jne	.L66
	movq	-1328(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	sqlite3_column_text
	movq	%rax, -144(%rbp)
	cmpq	$0, -144(%rbp)
	je	.L67
	movl	-1316(%rbp), %eax
	movq	-144(%rbp), %rdx
	movl	%eax, %esi
	movl	$.LC60, %edi
	movl	$0, %eax
	call	printf
	movq	-144(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-144(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC39, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L68
.L67:
	movq	$.LC61, -152(%rbp)
	movq	-152(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-152(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC39, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L68
.L66:
	movq	$.LC62, -136(%rbp)
	movq	-136(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-136(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC63, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
.L68:
	movq	-1328(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	jmp	.L42
.L64:
	movq	$.LC64, -168(%rbp)
	movq	-168(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-168(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC65, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L63:
	leaq	-1296(%rbp), %rax
	movl	$.LC66, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L70
	leaq	-1296(%rbp), %rax
	movl	$.LC30, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -88(%rbp)
	cmpq	$0, -88(%rbp)
	je	.L42
	addq	$4, -88(%rbp)
	leaq	-1332(%rbp), %rdx
	movq	-88(%rbp), %rax
	movl	$.LC55, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	movl	-1332(%rbp), %eax
	testl	%eax, %eax
	js	.L71
	movl	-1332(%rbp), %eax
	cmpl	$99, %eax
	jg	.L71
	movl	-1332(%rbp), %eax
	cltq
	movb	$0, logged_in_users(%rax)
	movq	$.LC67, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-96(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC39, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L71:
	movq	$.LC64, -104(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-104(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC65, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L70:
	leaq	-1296(%rbp), %rax
	movl	$.LC68, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L73
	leaq	-1296(%rbp), %rax
	movl	$.LC69, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -56(%rbp)
	cmpq	$0, -56(%rbp)
	je	.L42
	addq	$20, -56(%rbp)
	movq	$0, -3408(%rbp)
	movq	$0, -3400(%rbp)
	movq	$0, -3392(%rbp)
	movq	$0, -3384(%rbp)
	movq	$0, -3376(%rbp)
	movq	$0, -3368(%rbp)
	movw	$0, -3360(%rbp)
	movq	-56(%rbp), %rax
	movl	$.LC70, %esi
	movq	%rax, %rdi
	call	strpbrk
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	je	.L74
	movq	-64(%rbp), %rax
	movb	$0, (%rax)
.L74:
	movq	-56(%rbp), %rax
	movq	%rax, -24(%rbp)
	leaq	-3408(%rbp), %rax
	movq	%rax, -32(%rbp)
	jmp	.L75
.L80:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$37, %al
	jne	.L76
	movq	-24(%rbp), %rax
	addq	$1, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L77
	movq	-24(%rbp), %rax
	addq	$2, %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L77
	movq	-24(%rbp), %rax
	movzbl	1(%rax), %eax
	movb	%al, -1335(%rbp)
	movq	-24(%rbp), %rax
	movzbl	2(%rax), %eax
	movb	%al, -1334(%rbp)
	movb	$0, -1333(%rbp)
	leaq	-1335(%rbp), %rax
	movl	$16, %edx
	movl	$0, %esi
	movq	%rax, %rdi
	call	strtol
	movl	%eax, %edx
	movq	-32(%rbp), %rax
	movb	%dl, (%rax)
	addq	$3, -24(%rbp)
	jmp	.L77
.L76:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	cmpb	$43, %al
	jne	.L78
	movq	-32(%rbp), %rax
	movb	$32, (%rax)
	addq	$1, -24(%rbp)
	jmp	.L77
.L78:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %edx
	movq	-32(%rbp), %rax
	movb	%dl, (%rax)
	addq	$1, -24(%rbp)
.L77:
	addq	$1, -32(%rbp)
.L75:
	movq	-24(%rbp), %rax
	movzbl	(%rax), %eax
	testb	%al, %al
	je	.L79
	leaq	-3408(%rbp), %rax
	movq	-32(%rbp), %rdx
	subq	%rax, %rdx
	movq	%rdx, %rax
	cmpq	$48, %rax
	jbe	.L80
.L79:
	movq	-32(%rbp), %rax
	movb	$0, (%rax)
	leaq	-3408(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC71, %edi
	movl	$0, %eax
	call	printf
	leaq	-3408(%rbp), %rax
	movq	%rax, %rdi
	call	get_user_id
	movl	%eax, -68(%rbp)
	movl	-68(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC72, %edi
	movl	$0, %eax
	call	printf
	cmpl	$0, -68(%rbp)
	js	.L81
	cmpl	$99, -68(%rbp)
	jg	.L81
	movl	-68(%rbp), %edx
	leaq	-4432(%rbp), %rax
	movl	%edx, %ecx
	movl	$.LC73, %edx
	movl	$32, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-4432(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-4432(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC42, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L81:
	movq	$.LC62, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-80(%rbp), %rcx
	leaq	-2384(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC74, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2384(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2384(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L42
.L73:
	leaq	-1355(%rbp), %rsi
	leaq	-2384(%rbp), %rcx
	leaq	-1345(%rbp), %rdx
	leaq	-1296(%rbp), %rax
	movq	%rsi, %r8
	movl	$.LC75, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	leaq	-1345(%rbp), %rax
	movl	$.LC76, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L42
	leaq	-2384(%rbp), %rax
	movl	$.LC77, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	je	.L84
	leaq	-2384(%rbp), %rax
	movl	$.LC78, %esi
	movq	%rax, %rdi
	call	strcmp
	testl	%eax, %eax
	jne	.L85
.L84:
	movl	-4436(%rbp), %eax
	movl	$.LC79, %esi
	movl	%eax, %edi
	call	serve_file
	jmp	.L42
.L85:
	leaq	-2384(%rbp), %rax
	movl	$.LC10, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L86
	leaq	-2384(%rbp), %rax
	addq	$1, %rax
	movl	-4436(%rbp), %edx
	movq	%rax, %rsi
	movl	%edx, %edi
	call	serve_file
	jmp	.L42
.L86:
	leaq	-2384(%rbp), %rax
	movl	$.LC12, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L87
	leaq	-2384(%rbp), %rax
	addq	$1, %rax
	movl	-4436(%rbp), %edx
	movq	%rax, %rsi
	movl	%edx, %edi
	call	serve_file
	jmp	.L42
.L87:
	movq	$.LC80, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-48(%rbp), %rcx
	movl	-4436(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
.L42:
	movl	-4436(%rbp), %eax
	movl	%eax, %edi
	call	close
.L38:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE326:
	.size	handle_client, .-handle_client
	.section	.rodata
.LC81:
	.string	"virtual_lab.db"
.LC82:
	.string	"Can't open database: %s\n"
.LC83:
	.string	"Opened database successfully\n"
	.align 8
.LC84:
	.string	"CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT NOT NULL,password TEXT NOT NULL,data TEXT);"
.LC85:
	.string	"Tables created successfully\n"
	.text
	.globl	init_db
	.type	init_db, @function
init_db:
.LFB327:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	$db, %esi
	movl	$.LC81, %edi
	call	sqlite3_open
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	je	.L90
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC82, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L90:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$29, %edx
	movl	$1, %esi
	movl	$.LC83, %edi
	call	fwrite
	movq	$.LC84, -16(%rbp)
	movq	$0, -24(%rbp)
	movq	db(%rip), %rax
	leaq	-24(%rbp), %rdx
	movq	-16(%rbp), %rsi
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	sqlite3_exec
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	je	.L91
	movq	-24(%rbp), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC25, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_free
	movl	$1, %edi
	call	exit
.L91:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$28, %edx
	movl	$1, %esi
	movl	$.LC85, %edi
	call	fwrite
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE327:
	.size	init_db, .-init_db
	.globl	close_db
	.type	close_db, @function
close_db:
.LFB328:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_close
	nop
	popq	%rbp
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE328:
	.size	close_db, .-close_db
	.section	.rodata
.LC86:
	.string	"Socket creation failed"
.LC87:
	.string	"Bind failed"
.LC88:
	.string	"Listen failed"
	.align 8
.LC89:
	.string	"Server is listening on port %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB329:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$64, %rsp
	movl	$16, -52(%rbp)
	movl	$0, %eax
	call	init_db
	movl	$0, %edx
	movl	$1, %esi
	movl	$2, %edi
	call	socket
	movl	%eax, -4(%rbp)
	cmpl	$-1, -4(%rbp)
	jne	.L94
	movl	$.LC86, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L94:
	movw	$2, -32(%rbp)
	movl	$0, -28(%rbp)
	movl	$8069, %edi
	call	htons
	movw	%ax, -30(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-4(%rbp), %eax
	movl	$16, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	bind
	cmpl	$-1, %eax
	jne	.L95
	movl	$.LC87, %edi
	call	perror
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$1, %edi
	call	exit
.L95:
	movl	-4(%rbp), %eax
	movl	$10, %esi
	movl	%eax, %edi
	call	listen
	cmpl	$-1, %eax
	jne	.L96
	movl	$.LC88, %edi
	call	perror
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$1, %edi
	call	exit
.L96:
	movl	$8069, %esi
	movl	$.LC89, %edi
	movl	$0, %eax
	call	printf
	jmp	.L97
.L98:
	movl	-8(%rbp), %eax
	movl	%eax, %edi
	call	handle_client
.L97:
	leaq	-52(%rbp), %rdx
	leaq	-48(%rbp), %rcx
	movl	-4(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	accept
	movl	%eax, -8(%rbp)
	cmpl	$-1, -8(%rbp)
	jne	.L98
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$0, %eax
	call	close_db
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE329:
	.size	main, .-main
	.ident	"GCC: (GNU) 14.2.1 20240912 (Red Hat 14.2.1-3)"
	.section	.note.GNU-stack,"",@progbits
