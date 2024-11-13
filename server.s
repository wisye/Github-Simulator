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
.LC7:
	.string	"Failed to execute query: %s\n"
	.text
	.globl	get_user_id
	.type	get_user_id, @function
get_user_id:
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
	movl	$-1, %eax
	jmp	.L13
.L9:
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
	jne	.L11
	movq	-32(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	sqlite3_column_int
	movl	%eax, -4(%rbp)
	jmp	.L12
.L11:
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC7, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
.L12:
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	movl	-4(%rbp), %eax
.L13:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE320:
	.size	get_user_id, .-get_user_id
	.section	.rodata
.LC8:
	.string	"Password before hashing: %s\n"
.LC9:
	.string	"Authenticating user: %s\n"
.LC10:
	.string	"Hashed password: %s\n"
	.align 8
.LC11:
	.string	"SELECT id FROM users WHERE username = ? AND password = ?"
	.text
	.globl	authenticate_user
	.type	authenticate_user, @function
authenticate_user:
.LFB321:
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
	movl	$.LC8, %edi
	movl	$0, %eax
	call	printf
	leaq	-96(%rbp), %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hash_password
	movq	-120(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC9, %edi
	movl	$0, %eax
	call	printf
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC10, %edi
	movl	$0, %eax
	call	printf
	movq	$.LC11, -16(%rbp)
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
	je	.L15
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
	jmp	.L19
.L15:
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
	jne	.L17
	movq	-104(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	sqlite3_column_int
	movl	%eax, -4(%rbp)
	jmp	.L18
.L17:
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC7, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
.L18:
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	movl	-4(%rbp), %eax
.L19:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE321:
	.size	authenticate_user, .-authenticate_user
	.section	.rodata
.LC12:
	.string	"Registering user: %s\n"
	.align 8
.LC13:
	.string	"INSERT INTO users (username, password) VALUES ('%s', '%s');"
.LC14:
	.string	"SQL query: %s\n"
.LC15:
	.string	"SQL error: %s\n"
.LC16:
	.string	"User registered successfully\n"
	.text
	.globl	register_user
	.type	register_user, @function
register_user:
.LFB322:
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
	movl	$.LC8, %edi
	movl	$0, %eax
	call	printf
	leaq	-80(%rbp), %rdx
	movq	-368(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hash_password
	movq	-360(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC12, %edi
	movl	$0, %eax
	call	printf
	leaq	-80(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC10, %edi
	movl	$0, %eax
	call	printf
	movq	$0, -88(%rbp)
	leaq	-80(%rbp), %rcx
	movq	-360(%rbp), %rdx
	leaq	-352(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC13, %edx
	movl	$256, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC14, %edi
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
	je	.L21
	movq	-88(%rbp), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC15, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_free
	jmp	.L23
.L21:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$29, %edx
	movl	$1, %esi
	movl	$.LC16, %edi
	call	fwrite
.L23:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE322:
	.size	register_user, .-register_user
	.section	.rodata
.LC17:
	.string	"Failed to read from socket"
.LC18:
	.string	"Received request:\n%s\n"
.LC19:
	.string	"POST /register"
.LC20:
	.string	"\r\n\r\n"
.LC21:
	.string	"&"
.LC22:
	.string	"username="
.LC23:
	.string	"password="
.LC24:
	.string	"Extracted username: %s\n"
.LC25:
	.string	"Extracted password: %s\n"
.LC26:
	.string	"User registered"
	.align 8
.LC27:
	.string	"HTTP/1.1 200 OK\nContent-Type: text/plain\nContent-Length: %zu\n\n%s"
.LC28:
	.string	"POST /login"
.LC29:
	.string	"User already logged in"
.LC30:
	.string	"Login successful"
.LC31:
	.string	"Invalid username or password"
.LC32:
	.string	"POST /save"
.LC33:
	.string	"id=%d&data=%s"
	.align 8
.LC34:
	.string	"UPDATE users SET data = '%s' WHERE id = %d;"
.LC35:
	.string	"Data saved successfully\n"
.LC36:
	.string	"Data saved"
	.align 8
.LC37:
	.string	"Invalid user ID or not logged in"
.LC38:
	.string	"GET /load"
.LC39:
	.string	"GET /load?"
.LC40:
	.string	"id=%d"
.LC41:
	.string	"Extracted user ID: %d\n"
.LC42:
	.string	"User %d login status: %d\n"
	.align 8
.LC43:
	.string	"SELECT data FROM users WHERE id = ?"
.LC44:
	.string	"Database error"
	.align 8
.LC45:
	.string	"HTTP/1.1 500 Internal Server Error\r\nContent-Type: text/plain\r\nContent-Length: %zu\r\n\r\n%s"
	.align 8
.LC46:
	.string	"Loading data for user ID %d: %s\n"
	.align 8
.LC47:
	.string	"HTTP/1.1 200 OK\r\nContent-Type: text/plain\r\nContent-Length: %zu\r\n\r\n%s"
.LC48:
	.string	"No data found"
.LC49:
	.string	"User not found"
	.align 8
.LC50:
	.string	"HTTP/1.1 404 Not Found\r\nContent-Type: text/plain\r\nContent-Length: %zu\r\n\r\n%s"
.LC51:
	.string	"Invalid user ID"
	.align 8
.LC52:
	.string	"HTTP/1.1 400 Bad Request\r\nContent-Type: text/plain\r\nContent-Length: %zu\r\n\r\n%s"
.LC53:
	.string	"i love furina so much fr fr"
	.text
	.globl	handle_client
	.type	handle_client, @function
handle_client:
.LFB323:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$4336, %rsp
	movl	%edi, -4324(%rbp)
	leaq	-1216(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movl	$1023, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jns	.L25
	movl	$.LC17, %edi
	call	perror
	movl	-4324(%rbp), %eax
	movl	%eax, %edi
	call	close
	jmp	.L24
.L25:
	movl	-20(%rbp), %eax
	cltq
	movb	$0, -1216(%rbp,%rax)
	leaq	-1216(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC18, %edi
	movl	$0, %eax
	call	printf
	leaq	-1216(%rbp), %rax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L27
	leaq	-1216(%rbp), %rax
	movl	$.LC20, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -176(%rbp)
	cmpq	$0, -176(%rbp)
	je	.L28
	addq	$4, -176(%rbp)
	movq	$0, -4320(%rbp)
	movq	$0, -4312(%rbp)
	movq	$0, -4304(%rbp)
	movq	$0, -4296(%rbp)
	movq	$0, -4288(%rbp)
	movq	$0, -4280(%rbp)
	movw	$0, -4272(%rbp)
	movq	$0, -3296(%rbp)
	movq	$0, -3288(%rbp)
	movq	$0, -3280(%rbp)
	movq	$0, -3272(%rbp)
	movq	$0, -3264(%rbp)
	movq	$0, -3256(%rbp)
	movw	$0, -3248(%rbp)
	movq	-176(%rbp), %rax
	movl	$.LC21, %esi
	movq	%rax, %rdi
	call	strtok
	movq	%rax, -8(%rbp)
	jmp	.L29
.L32:
	movq	-8(%rbp), %rax
	movl	$9, %edx
	movl	$.LC22, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L30
	movq	-8(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-4320(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
	jmp	.L31
.L30:
	movq	-8(%rbp), %rax
	movl	$9, %edx
	movl	$.LC23, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L31
	movq	-8(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-3296(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
.L31:
	movl	$.LC21, %esi
	movl	$0, %edi
	call	strtok
	movq	%rax, -8(%rbp)
.L29:
	cmpq	$0, -8(%rbp)
	jne	.L32
	leaq	-4320(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC24, %edi
	movl	$0, %eax
	call	printf
	leaq	-3296(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC25, %edi
	movl	$0, %eax
	call	printf
	leaq	-3296(%rbp), %rdx
	leaq	-4320(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	register_user
	movq	$.LC26, -184(%rbp)
	movq	-184(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-184(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC27, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L28
.L27:
	leaq	-1216(%rbp), %rax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L33
	leaq	-1216(%rbp), %rax
	movl	$.LC20, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -136(%rbp)
	cmpq	$0, -136(%rbp)
	je	.L28
	addq	$4, -136(%rbp)
	movq	$0, -4320(%rbp)
	movq	$0, -4312(%rbp)
	movq	$0, -4304(%rbp)
	movq	$0, -4296(%rbp)
	movq	$0, -4288(%rbp)
	movq	$0, -4280(%rbp)
	movw	$0, -4272(%rbp)
	movq	$0, -3296(%rbp)
	movq	$0, -3288(%rbp)
	movq	$0, -3280(%rbp)
	movq	$0, -3272(%rbp)
	movq	$0, -3264(%rbp)
	movq	$0, -3256(%rbp)
	movw	$0, -3248(%rbp)
	movq	-136(%rbp), %rax
	movl	$.LC21, %esi
	movq	%rax, %rdi
	call	strtok
	movq	%rax, -16(%rbp)
	jmp	.L34
.L37:
	movq	-16(%rbp), %rax
	movl	$9, %edx
	movl	$.LC22, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L35
	movq	-16(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-4320(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
	jmp	.L36
.L35:
	movq	-16(%rbp), %rax
	movl	$9, %edx
	movl	$.LC23, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L36
	movq	-16(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-3296(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
.L36:
	movl	$.LC21, %esi
	movl	$0, %edi
	call	strtok
	movq	%rax, -16(%rbp)
.L34:
	cmpq	$0, -16(%rbp)
	jne	.L37
	leaq	-4320(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC24, %edi
	movl	$0, %eax
	call	printf
	leaq	-3296(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC25, %edi
	movl	$0, %eax
	call	printf
	leaq	-3296(%rbp), %rdx
	leaq	-4320(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	authenticate_user
	movl	%eax, -140(%rbp)
	cmpl	$0, -140(%rbp)
	js	.L38
	cmpl	$99, -140(%rbp)
	jg	.L38
	movl	-140(%rbp), %eax
	cltq
	movzbl	logged_in_users(%rax), %eax
	testb	%al, %al
	je	.L39
	movq	$.LC29, -160(%rbp)
	movq	-160(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-160(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC27, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L28
.L39:
	movl	-140(%rbp), %eax
	cltq
	movb	$1, logged_in_users(%rax)
	movq	$.LC30, -152(%rbp)
	movq	-152(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-152(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC27, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L28
.L38:
	movq	$.LC31, -168(%rbp)
	movq	-168(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-168(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC27, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L28
.L33:
	leaq	-1216(%rbp), %rax
	movl	$.LC32, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L42
	leaq	-1216(%rbp), %rax
	movl	$.LC20, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -104(%rbp)
	cmpq	$0, -104(%rbp)
	je	.L28
	addq	$4, -104(%rbp)
	leaq	-4320(%rbp), %rdx
	movl	$0, %eax
	movl	$128, %ecx
	movq	%rdx, %rdi
	rep stosq
	leaq	-4320(%rbp), %rcx
	leaq	-1220(%rbp), %rdx
	movq	-104(%rbp), %rax
	movl	$.LC33, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	movl	-1220(%rbp), %eax
	testl	%eax, %eax
	js	.L43
	movl	-1220(%rbp), %eax
	cmpl	$99, %eax
	jg	.L43
	movl	-1220(%rbp), %eax
	cltq
	movzbl	logged_in_users(%rax), %eax
	testb	%al, %al
	je	.L43
	movq	$0, -1232(%rbp)
	movl	-1220(%rbp), %ecx
	leaq	-4320(%rbp), %rdx
	leaq	-3296(%rbp), %rax
	movl	%ecx, %r8d
	movq	%rdx, %rcx
	movl	$.LC34, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-3296(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC14, %edi
	movl	$0, %eax
	call	printf
	movq	db(%rip), %rax
	leaq	-1232(%rbp), %rdx
	leaq	-3296(%rbp), %rsi
	movq	%rdx, %r8
	movl	$0, %ecx
	movl	$0, %edx
	movq	%rax, %rdi
	call	sqlite3_exec
	movl	%eax, -108(%rbp)
	cmpl	$0, -108(%rbp)
	je	.L44
	movq	-1232(%rbp), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC15, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-1232(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_free
	jmp	.L45
.L44:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$24, %edx
	movl	$1, %esi
	movl	$.LC35, %edi
	call	fwrite
.L45:
	movq	$.LC36, -120(%rbp)
	movq	-120(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-120(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC27, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L28
.L43:
	movq	$.LC37, -128(%rbp)
	movq	-128(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-128(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC27, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L28
.L42:
	leaq	-1216(%rbp), %rax
	movl	$.LC38, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L47
	leaq	-1216(%rbp), %rax
	movl	$.LC39, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	je	.L28
	addq	$10, -40(%rbp)
	leaq	-1236(%rbp), %rdx
	movq	-40(%rbp), %rax
	movl	$.LC40, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	movl	-1236(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC41, %edi
	movl	$0, %eax
	call	printf
	movl	-1236(%rbp), %eax
	cltq
	movzbl	logged_in_users(%rax), %eax
	movzbl	%al, %edx
	movl	-1236(%rbp), %eax
	movl	%eax, %esi
	movl	$.LC42, %edi
	movl	$0, %eax
	call	printf
	movl	-1236(%rbp), %eax
	testl	%eax, %eax
	js	.L48
	movl	-1236(%rbp), %eax
	cmpl	$99, %eax
	jg	.L48
	movq	$.LC43, -48(%rbp)
	movq	db(%rip), %rax
	leaq	-1248(%rbp), %rdx
	movq	-48(%rbp), %rsi
	movl	$0, %r8d
	movq	%rdx, %rcx
	movl	$-1, %edx
	movq	%rax, %rdi
	call	sqlite3_prepare_v2
	movl	%eax, -52(%rbp)
	cmpl	$0, -52(%rbp)
	je	.L49
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC6, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	$.LC44, -88(%rbp)
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-88(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC45, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	movq	-1248(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	jmp	.L24
.L49:
	movl	-1236(%rbp), %edx
	movq	-1248(%rbp), %rax
	movl	$1, %esi
	movq	%rax, %rdi
	call	sqlite3_bind_int
	movq	-1248(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_step
	movl	%eax, -52(%rbp)
	cmpl	$100, -52(%rbp)
	jne	.L50
	movq	-1248(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	sqlite3_column_text
	movq	%rax, -72(%rbp)
	cmpq	$0, -72(%rbp)
	je	.L51
	movl	-1236(%rbp), %eax
	movq	-72(%rbp), %rdx
	movl	%eax, %esi
	movl	$.LC46, %edi
	movl	$0, %eax
	call	printf
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-72(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC47, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L52
.L51:
	movq	$.LC48, -80(%rbp)
	movq	-80(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-80(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC47, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L52
.L50:
	movq	$.LC49, -64(%rbp)
	movq	-64(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-64(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC50, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
.L52:
	movq	-1248(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	jmp	.L28
.L48:
	movq	$.LC51, -96(%rbp)
	movq	-96(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-96(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC52, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L28
.L47:
	movq	$.LC53, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-32(%rbp), %rcx
	leaq	-2272(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC27, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2272(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2272(%rbp), %rcx
	movl	-4324(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
.L28:
	movl	-4324(%rbp), %eax
	movl	%eax, %edi
	call	close
.L24:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE323:
	.size	handle_client, .-handle_client
	.section	.rodata
.LC54:
	.string	"virtual_lab.db"
.LC55:
	.string	"Can't open database: %s\n"
.LC56:
	.string	"Opened database successfully\n"
	.align 8
.LC57:
	.string	"CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT NOT NULL,password TEXT NOT NULL,data TEXT);"
.LC58:
	.string	"Tables created successfully\n"
	.text
	.globl	init_db
	.type	init_db, @function
init_db:
.LFB324:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$32, %rsp
	movl	$db, %esi
	movl	$.LC54, %edi
	call	sqlite3_open
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	je	.L56
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC55, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L56:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$29, %edx
	movl	$1, %esi
	movl	$.LC56, %edi
	call	fwrite
	movq	$.LC57, -16(%rbp)
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
	je	.L57
	movq	-24(%rbp), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC15, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_free
	movl	$1, %edi
	call	exit
.L57:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$28, %edx
	movl	$1, %esi
	movl	$.LC58, %edi
	call	fwrite
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE324:
	.size	init_db, .-init_db
	.globl	close_db
	.type	close_db, @function
close_db:
.LFB325:
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
.LFE325:
	.size	close_db, .-close_db
	.section	.rodata
.LC59:
	.string	"Socket creation failed"
.LC60:
	.string	"Bind failed"
.LC61:
	.string	"Listen failed"
	.align 8
.LC62:
	.string	"Server is listening on port %d\n"
	.text
	.globl	main
	.type	main, @function
main:
.LFB326:
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
	jne	.L60
	movl	$.LC59, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L60:
	movw	$2, -32(%rbp)
	movl	$0, -28(%rbp)
	movl	$8080, %edi
	call	htons
	movw	%ax, -30(%rbp)
	leaq	-32(%rbp), %rcx
	movl	-4(%rbp), %eax
	movl	$16, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	bind
	cmpl	$-1, %eax
	jne	.L61
	movl	$.LC60, %edi
	call	perror
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$1, %edi
	call	exit
.L61:
	movl	-4(%rbp), %eax
	movl	$10, %esi
	movl	%eax, %edi
	call	listen
	cmpl	$-1, %eax
	jne	.L62
	movl	$.LC61, %edi
	call	perror
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$1, %edi
	call	exit
.L62:
	movl	$8080, %esi
	movl	$.LC62, %edi
	movl	$0, %eax
	call	printf
	jmp	.L63
.L64:
	movl	-8(%rbp), %eax
	movl	%eax, %edi
	call	handle_client
.L63:
	leaq	-52(%rbp), %rdx
	leaq	-48(%rbp), %rcx
	movl	-4(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	accept
	movl	%eax, -8(%rbp)
	cmpl	$-1, -8(%rbp)
	jne	.L64
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