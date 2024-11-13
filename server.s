	.file	"http.c"
	.text
	.globl	db
	.bss
	.align 8
	.type	db, @object
	.size	db, 8
db:
	.zero	8
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
	.globl	count_callback
	.type	count_callback, @function
count_callback:
.LFB320:
	.cfi_startproc
	pushq	%rbp
	.cfi_def_cfa_offset 16
	.cfi_offset 6, -16
	movq	%rsp, %rbp
	.cfi_def_cfa_register 6
	subq	$48, %rsp
	movq	%rdi, -24(%rbp)
	movl	%esi, -28(%rbp)
	movq	%rdx, -40(%rbp)
	movq	%rcx, -48(%rbp)
	movq	-24(%rbp), %rax
	movq	%rax, -8(%rbp)
	movq	-40(%rbp), %rax
	movq	(%rax), %rax
	movq	%rax, %rdi
	call	atoi
	movq	-8(%rbp), %rdx
	movl	%eax, (%rdx)
	movl	$0, %eax
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE320:
	.size	count_callback, .-count_callback
	.section	.rodata
.LC5:
	.string	"Password before hashing: %s\n"
.LC6:
	.string	"Authenticating user: %s\n"
.LC7:
	.string	"Hashed password: %s\n"
	.align 8
.LC8:
	.string	"SELECT COUNT(*) FROM users WHERE username = ? AND password = ?"
	.align 8
.LC9:
	.string	"Failed to prepare statement: %s\n"
.LC10:
	.string	"Failed to execute query: %s\n"
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
	movl	$.LC5, %edi
	movl	$0, %eax
	call	printf
	leaq	-96(%rbp), %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hash_password
	movq	-120(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC6, %edi
	movl	$0, %eax
	call	printf
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC7, %edi
	movl	$0, %eax
	call	printf
	movq	$.LC8, -16(%rbp)
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
	je	.L11
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC9, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$0, %eax
	jmp	.L15
.L11:
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
	movl	$0, -4(%rbp)
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_step
	movl	%eax, -20(%rbp)
	cmpl	$100, -20(%rbp)
	jne	.L13
	movq	-104(%rbp), %rax
	movl	$0, %esi
	movq	%rax, %rdi
	call	sqlite3_column_int
	movl	%eax, -4(%rbp)
	jmp	.L14
.L13:
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC10, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
.L14:
	movq	-104(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_finalize
	cmpl	$0, -4(%rbp)
	setg	%al
	movzbl	%al, %eax
.L15:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE321:
	.size	authenticate_user, .-authenticate_user
	.section	.rodata
.LC11:
	.string	"Registering user: %s\n"
	.align 8
.LC12:
	.string	"INSERT INTO users (username, password) VALUES ('%s', '%s');"
.LC13:
	.string	"SQL query: %s\n"
.LC14:
	.string	"SQL error: %s\n"
.LC15:
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
	movl	$.LC5, %edi
	movl	$0, %eax
	call	printf
	leaq	-80(%rbp), %rdx
	movq	-368(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hash_password
	movq	-360(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC11, %edi
	movl	$0, %eax
	call	printf
	leaq	-80(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC7, %edi
	movl	$0, %eax
	call	printf
	movq	$0, -88(%rbp)
	leaq	-80(%rbp), %rcx
	movq	-360(%rbp), %rdx
	leaq	-352(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC12, %edx
	movl	$256, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC13, %edi
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
	je	.L17
	movq	-88(%rbp), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC14, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-88(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_free
	jmp	.L19
.L17:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$29, %edx
	movl	$1, %esi
	movl	$.LC15, %edi
	call	fwrite
.L19:
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE322:
	.size	register_user, .-register_user
	.section	.rodata
.LC16:
	.string	"Failed to read from socket"
.LC17:
	.string	"Received request:\n%s\n"
.LC18:
	.string	"POST /register"
.LC19:
	.string	"\r\n\r\n"
.LC20:
	.string	"&"
.LC21:
	.string	"username="
.LC22:
	.string	"password="
.LC23:
	.string	"Extracted username: %s\n"
.LC24:
	.string	"Extracted password: %s\n"
.LC25:
	.string	"User registered"
	.align 8
.LC26:
	.string	"HTTP/1.1 200 OK\nContent-Type: text/plain\nContent-Length: %zu\n\n%s"
.LC27:
	.string	"POST /login"
.LC28:
	.string	"Login successful"
.LC29:
	.string	"Invalid username or password"
.LC30:
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
	subq	$2272, %rsp
	movl	%edi, -2260(%rbp)
	leaq	-1104(%rbp), %rcx
	movl	-2260(%rbp), %eax
	movl	$1023, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	jns	.L21
	movl	$.LC16, %edi
	call	perror
	movl	-2260(%rbp), %eax
	movl	%eax, %edi
	call	close
	jmp	.L20
.L21:
	movl	-20(%rbp), %eax
	cltq
	movb	$0, -1104(%rbp,%rax)
	leaq	-1104(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC17, %edi
	movl	$0, %eax
	call	printf
	leaq	-1104(%rbp), %rax
	movl	$.LC18, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L23
	leaq	-1104(%rbp), %rax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -64(%rbp)
	cmpq	$0, -64(%rbp)
	je	.L24
	addq	$4, -64(%rbp)
	movq	$0, -2256(%rbp)
	movq	$0, -2248(%rbp)
	movq	$0, -2240(%rbp)
	movq	$0, -2232(%rbp)
	movq	$0, -2224(%rbp)
	movq	$0, -2216(%rbp)
	movw	$0, -2208(%rbp)
	movq	$0, -2192(%rbp)
	movq	$0, -2184(%rbp)
	movq	$0, -2176(%rbp)
	movq	$0, -2168(%rbp)
	movq	$0, -2160(%rbp)
	movq	$0, -2152(%rbp)
	movw	$0, -2144(%rbp)
	movq	-64(%rbp), %rax
	movl	$.LC20, %esi
	movq	%rax, %rdi
	call	strtok
	movq	%rax, -8(%rbp)
	jmp	.L25
.L28:
	movq	-8(%rbp), %rax
	movl	$9, %edx
	movl	$.LC21, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L26
	movq	-8(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-2256(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
	jmp	.L27
.L26:
	movq	-8(%rbp), %rax
	movl	$9, %edx
	movl	$.LC22, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L27
	movq	-8(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-2192(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
.L27:
	movl	$.LC20, %esi
	movl	$0, %edi
	call	strtok
	movq	%rax, -8(%rbp)
.L25:
	cmpq	$0, -8(%rbp)
	jne	.L28
	leaq	-2256(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC23, %edi
	movl	$0, %eax
	call	printf
	leaq	-2192(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC24, %edi
	movl	$0, %eax
	call	printf
	leaq	-2192(%rbp), %rdx
	leaq	-2256(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	register_user
	movq	$.LC25, -72(%rbp)
	movq	-72(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-72(%rbp), %rcx
	leaq	-2128(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC26, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2128(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2128(%rbp), %rcx
	movl	-2260(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L24
.L23:
	leaq	-1104(%rbp), %rax
	movl	$.LC27, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L29
	leaq	-1104(%rbp), %rax
	movl	$.LC19, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	je	.L24
	addq	$4, -40(%rbp)
	movq	$0, -2256(%rbp)
	movq	$0, -2248(%rbp)
	movq	$0, -2240(%rbp)
	movq	$0, -2232(%rbp)
	movq	$0, -2224(%rbp)
	movq	$0, -2216(%rbp)
	movw	$0, -2208(%rbp)
	movq	$0, -2192(%rbp)
	movq	$0, -2184(%rbp)
	movq	$0, -2176(%rbp)
	movq	$0, -2168(%rbp)
	movq	$0, -2160(%rbp)
	movq	$0, -2152(%rbp)
	movw	$0, -2144(%rbp)
	movq	-40(%rbp), %rax
	movl	$.LC20, %esi
	movq	%rax, %rdi
	call	strtok
	movq	%rax, -16(%rbp)
	jmp	.L30
.L33:
	movq	-16(%rbp), %rax
	movl	$9, %edx
	movl	$.LC21, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L31
	movq	-16(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-2256(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
	jmp	.L32
.L31:
	movq	-16(%rbp), %rax
	movl	$9, %edx
	movl	$.LC22, %esi
	movq	%rax, %rdi
	call	strncmp
	testl	%eax, %eax
	jne	.L32
	movq	-16(%rbp), %rax
	leaq	9(%rax), %rcx
	leaq	-2192(%rbp), %rax
	movl	$49, %edx
	movq	%rcx, %rsi
	movq	%rax, %rdi
	call	strncpy
.L32:
	movl	$.LC20, %esi
	movl	$0, %edi
	call	strtok
	movq	%rax, -16(%rbp)
.L30:
	cmpq	$0, -16(%rbp)
	jne	.L33
	leaq	-2256(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC23, %edi
	movl	$0, %eax
	call	printf
	leaq	-2192(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC24, %edi
	movl	$0, %eax
	call	printf
	leaq	-2192(%rbp), %rdx
	leaq	-2256(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	authenticate_user
	movl	%eax, -44(%rbp)
	cmpl	$0, -44(%rbp)
	je	.L34
	movl	$.LC28, %eax
	jmp	.L35
.L34:
	movl	$.LC29, %eax
.L35:
	movq	%rax, -56(%rbp)
	movq	-56(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-56(%rbp), %rcx
	leaq	-2128(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC26, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2128(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2128(%rbp), %rcx
	movl	-2260(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L24
.L29:
	movq	$.LC30, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-32(%rbp), %rcx
	leaq	-2128(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC26, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2128(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2128(%rbp), %rcx
	movl	-2260(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
.L24:
	movl	-2260(%rbp), %eax
	movl	%eax, %edi
	call	close
.L20:
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE323:
	.size	handle_client, .-handle_client
	.section	.rodata
.LC31:
	.string	"virtual_lab.db"
.LC32:
	.string	"Can't open database: %s\n"
.LC33:
	.string	"Opened database successfully\n"
	.align 8
.LC34:
	.string	"CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT NOT NULL,password TEXT NOT NULL);"
.LC35:
	.string	"Table created successfully\n"
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
	movl	$.LC31, %edi
	call	sqlite3_open
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	je	.L37
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC32, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L37:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$29, %edx
	movl	$1, %esi
	movl	$.LC33, %edi
	call	fwrite
	movq	$.LC34, -16(%rbp)
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
	je	.L38
	movq	-24(%rbp), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC14, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_free
	movl	$1, %edi
	call	exit
.L38:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$27, %edx
	movl	$1, %esi
	movl	$.LC35, %edi
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
.LC36:
	.string	"Socket creation failed"
.LC37:
	.string	"Bind failed"
.LC38:
	.string	"Listen failed"
	.align 8
.LC39:
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
	jne	.L41
	movl	$.LC36, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L41:
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
	jne	.L42
	movl	$.LC37, %edi
	call	perror
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$1, %edi
	call	exit
.L42:
	movl	-4(%rbp), %eax
	movl	$10, %esi
	movl	%eax, %edi
	call	listen
	cmpl	$-1, %eax
	jne	.L43
	movl	$.LC38, %edi
	call	perror
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$1, %edi
	call	exit
.L43:
	movl	$8080, %esi
	movl	$.LC39, %edi
	movl	$0, %eax
	call	printf
	jmp	.L44
.L45:
	movl	-8(%rbp), %eax
	movl	%eax, %edi
	call	handle_client
.L44:
	leaq	-52(%rbp), %rdx
	leaq	-48(%rbp), %rcx
	movl	-4(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	accept
	movl	%eax, -8(%rbp)
	cmpl	$-1, -8(%rbp)
	jne	.L45
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
.LFE326:
	.size	main, .-main
	.ident	"GCC: (GNU) 14.2.1 20240912 (Red Hat 14.2.1-3)"
	.section	.note.GNU-stack,"",@progbits
