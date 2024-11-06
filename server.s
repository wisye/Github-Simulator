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
	.string	"Authenticating user: %s\n"
.LC6:
	.string	"Hashed password: %s\n"
	.align 8
.LC7:
	.string	"SELECT COUNT(*) FROM users WHERE username = ? AND password = ?"
	.align 8
.LC8:
	.string	"Failed to prepare statement: %s\n"
.LC9:
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
	leaq	-96(%rbp), %rdx
	movq	-128(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hash_password
	movq	-120(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC5, %edi
	movl	$0, %eax
	call	printf
	leaq	-96(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC6, %edi
	movl	$0, %eax
	call	printf
	movq	$.LC7, -16(%rbp)
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
	movl	$.LC8, %esi
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
	movl	$.LC9, %esi
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
.LC10:
	.string	"Registering user: %s\n"
	.align 8
.LC11:
	.string	"INSERT INTO users (username, password) VALUES ('%s', '%s');"
.LC12:
	.string	"SQL query: %s\n"
.LC13:
	.string	"SQL error: %s\n"
.LC14:
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
	leaq	-80(%rbp), %rdx
	movq	-368(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	hash_password
	movq	-360(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC10, %edi
	movl	$0, %eax
	call	printf
	leaq	-80(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC6, %edi
	movl	$0, %eax
	call	printf
	movq	$0, -88(%rbp)
	leaq	-80(%rbp), %rcx
	movq	-360(%rbp), %rdx
	leaq	-352(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC11, %edx
	movl	$256, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-352(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC12, %edi
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
	movl	$.LC13, %esi
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
	movl	$.LC14, %edi
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
.LC15:
	.string	"Received request:\n%s\n"
.LC16:
	.string	"POST /register"
.LC17:
	.string	"\r\n\r\n"
	.align 8
.LC18:
	.string	"username=%49[^&]&password=%49s"
.LC19:
	.string	"Extracted username: %s\n"
.LC20:
	.string	"Extracted password: %s\n"
.LC21:
	.string	"User registered"
	.align 8
.LC22:
	.string	"HTTP/1.1 200 OK\nContent-Type: text/plain\nContent-Length: %zu\n\n%s"
.LC23:
	.string	"POST /login"
.LC24:
	.string	"Login successful"
.LC25:
	.string	"Invalid username or password"
.LC26:
	.string	"Hello world"
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
	subq	$2240, %rsp
	movl	%edi, -2228(%rbp)
	leaq	-1072(%rbp), %rcx
	movl	-2228(%rbp), %eax
	movl	$1024, %edx
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	read
	leaq	-1072(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC15, %edi
	movl	$0, %eax
	call	printf
	leaq	-1072(%rbp), %rax
	movl	$.LC16, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L21
	leaq	-1072(%rbp), %rax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -40(%rbp)
	cmpq	$0, -40(%rbp)
	je	.L22
	addq	$4, -40(%rbp)
	movq	$0, -2224(%rbp)
	movq	$0, -2216(%rbp)
	movq	$0, -2208(%rbp)
	movq	$0, -2200(%rbp)
	movq	$0, -2192(%rbp)
	movq	$0, -2184(%rbp)
	movw	$0, -2176(%rbp)
	movq	$0, -2160(%rbp)
	movq	$0, -2152(%rbp)
	movq	$0, -2144(%rbp)
	movq	$0, -2136(%rbp)
	movq	$0, -2128(%rbp)
	movq	$0, -2120(%rbp)
	movw	$0, -2112(%rbp)
	leaq	-2160(%rbp), %rcx
	leaq	-2224(%rbp), %rdx
	movq	-40(%rbp), %rax
	movl	$.LC18, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	leaq	-2224(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC19, %edi
	movl	$0, %eax
	call	printf
	leaq	-2160(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC20, %edi
	movl	$0, %eax
	call	printf
	leaq	-2160(%rbp), %rdx
	leaq	-2224(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	register_user
	movq	$.LC21, -48(%rbp)
	movq	-48(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-48(%rbp), %rcx
	leaq	-2096(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC22, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2096(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2096(%rbp), %rcx
	movl	-2228(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L22
.L21:
	leaq	-1072(%rbp), %rax
	movl	$.LC23, %esi
	movq	%rax, %rdi
	call	strstr
	testq	%rax, %rax
	je	.L23
	leaq	-1072(%rbp), %rax
	movl	$.LC17, %esi
	movq	%rax, %rdi
	call	strstr
	movq	%rax, -16(%rbp)
	cmpq	$0, -16(%rbp)
	je	.L22
	addq	$4, -16(%rbp)
	movq	$0, -2224(%rbp)
	movq	$0, -2216(%rbp)
	movq	$0, -2208(%rbp)
	movq	$0, -2200(%rbp)
	movq	$0, -2192(%rbp)
	movq	$0, -2184(%rbp)
	movw	$0, -2176(%rbp)
	movq	$0, -2160(%rbp)
	movq	$0, -2152(%rbp)
	movq	$0, -2144(%rbp)
	movq	$0, -2136(%rbp)
	movq	$0, -2128(%rbp)
	movq	$0, -2120(%rbp)
	movw	$0, -2112(%rbp)
	leaq	-2160(%rbp), %rcx
	leaq	-2224(%rbp), %rdx
	movq	-16(%rbp), %rax
	movl	$.LC18, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	__isoc99_sscanf
	leaq	-2224(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC19, %edi
	movl	$0, %eax
	call	printf
	leaq	-2160(%rbp), %rax
	movq	%rax, %rsi
	movl	$.LC20, %edi
	movl	$0, %eax
	call	printf
	leaq	-2160(%rbp), %rdx
	leaq	-2224(%rbp), %rax
	movq	%rdx, %rsi
	movq	%rax, %rdi
	call	authenticate_user
	movl	%eax, -20(%rbp)
	cmpl	$0, -20(%rbp)
	je	.L24
	movl	$.LC24, %eax
	jmp	.L25
.L24:
	movl	$.LC25, %eax
.L25:
	movq	%rax, -32(%rbp)
	movq	-32(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-32(%rbp), %rcx
	leaq	-2096(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC22, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2096(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2096(%rbp), %rcx
	movl	-2228(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
	jmp	.L22
.L23:
	movq	$.LC26, -8(%rbp)
	movq	-8(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	movq	-8(%rbp), %rcx
	leaq	-2096(%rbp), %rax
	movq	%rcx, %r8
	movq	%rdx, %rcx
	movl	$.LC22, %edx
	movl	$1024, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	snprintf
	leaq	-2096(%rbp), %rax
	movq	%rax, %rdi
	call	strlen
	movq	%rax, %rdx
	leaq	-2096(%rbp), %rcx
	movl	-2228(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	write
.L22:
	movl	-2228(%rbp), %eax
	movl	%eax, %edi
	call	close
	nop
	leave
	.cfi_def_cfa 7, 8
	ret
	.cfi_endproc
.LFE323:
	.size	handle_client, .-handle_client
	.section	.rodata
.LC27:
	.string	"virtual_lab.db"
.LC28:
	.string	"Can't open database: %s\n"
.LC29:
	.string	"Opened database successfully\n"
	.align 8
.LC30:
	.string	"CREATE TABLE IF NOT EXISTS users (id INTEGER PRIMARY KEY AUTOINCREMENT,username TEXT NOT NULL,password TEXT NOT NULL);"
.LC31:
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
	movl	$.LC27, %edi
	call	sqlite3_open
	movl	%eax, -4(%rbp)
	cmpl	$0, -4(%rbp)
	je	.L27
	movq	db(%rip), %rax
	movq	%rax, %rdi
	call	sqlite3_errmsg
	movq	%rax, %rdx
	movq	stderr(%rip), %rax
	movl	$.LC28, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movl	$1, %edi
	call	exit
.L27:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$29, %edx
	movl	$1, %esi
	movl	$.LC29, %edi
	call	fwrite
	movq	$.LC30, -16(%rbp)
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
	je	.L28
	movq	-24(%rbp), %rdx
	movq	stderr(%rip), %rax
	movl	$.LC13, %esi
	movq	%rax, %rdi
	movl	$0, %eax
	call	fprintf
	movq	-24(%rbp), %rax
	movq	%rax, %rdi
	call	sqlite3_free
	movl	$1, %edi
	call	exit
.L28:
	movq	stderr(%rip), %rax
	movq	%rax, %rcx
	movl	$27, %edx
	movl	$1, %esi
	movl	$.LC31, %edi
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
.LC32:
	.string	"Socket creation failed"
.LC33:
	.string	"Bind failed"
.LC34:
	.string	"Listen failed"
	.align 8
.LC35:
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
	jne	.L31
	movl	$.LC32, %edi
	call	perror
	movl	$1, %edi
	call	exit
.L31:
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
	jne	.L32
	movl	$.LC33, %edi
	call	perror
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$1, %edi
	call	exit
.L32:
	movl	-4(%rbp), %eax
	movl	$10, %esi
	movl	%eax, %edi
	call	listen
	cmpl	$-1, %eax
	jne	.L33
	movl	$.LC34, %edi
	call	perror
	movl	-4(%rbp), %eax
	movl	%eax, %edi
	call	close
	movl	$1, %edi
	call	exit
.L33:
	movl	$8080, %esi
	movl	$.LC35, %edi
	movl	$0, %eax
	call	printf
	jmp	.L34
.L35:
	movl	-8(%rbp), %eax
	movl	%eax, %edi
	call	handle_client
.L34:
	leaq	-52(%rbp), %rdx
	leaq	-48(%rbp), %rcx
	movl	-4(%rbp), %eax
	movq	%rcx, %rsi
	movl	%eax, %edi
	call	accept
	movl	%eax, -8(%rbp)
	cmpl	$-1, -8(%rbp)
	jne	.L35
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
