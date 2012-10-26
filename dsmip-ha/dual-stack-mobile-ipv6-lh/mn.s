	.file	"mn.c"
	.text
.globl inet6_opt_find
	.type	inet6_opt_find, @function
inet6_opt_find:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	20(%ebp), %eax
	movb	%al, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	cmpl	$1, 12(%ebp)
	jbe	.L2
	movl	16(%ebp), %eax
	cmpl	12(%ebp), %eax
	jae	.L2
	movl	-8(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	$1, %eax
	sall	$3, %eax
	cmpl	12(%ebp), %eax
	jbe	.L3
.L2:
	movl	$-1, -24(%ebp)
	jmp	.L4
.L3:
	movl	12(%ebp), %edx
	movl	-8(%ebp), %eax
	addl	%edx, %eax
	movl	%eax, -4(%ebp)
	movl	16(%ebp), %eax
	addl	$2, %eax
	addl	%eax, -8(%ebp)
	jmp	.L5
.L9:
	movl	-8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L6
	addl	$1, -8(%ebp)
	jmp	.L5
.L6:
	movl	-8(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	$2, %eax
	addl	-8(%ebp), %eax
	cmpl	-4(%ebp), %eax
	jbe	.L7
	movl	$-1, -24(%ebp)
	jmp	.L4
.L7:
	movl	-8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	-20(%ebp), %al
	jne	.L8
	movl	-8(%ebp), %eax
	leal	2(%eax), %edx
	movl	28(%ebp), %eax
	movl	%edx, (%eax)
	movl	-8(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %edx
	movl	24(%ebp), %eax
	movl	%edx, (%eax)
	movl	24(%ebp), %eax
	movl	(%eax), %eax
	addl	-8(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, -24(%ebp)
	jmp	.L4
.L8:
	movl	-8(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	$2, %eax
	addl	%eax, -8(%ebp)
.L5:
	movl	-8(%ebp), %eax
	cmpl	-4(%ebp), %eax
	jbe	.L9
	movl	28(%ebp), %eax
	movl	$0, (%eax)
	movl	$-1, -24(%ebp)
.L4:
	movl	-24(%ebp), %eax
	leave
	ret
	.size	inet6_opt_find, .-inet6_opt_find
.globl inet6_rth_add
	.type	inet6_rth_add, @function
inet6_rth_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movzbl	3(%eax), %eax
	movzbl	%al, %eax
	addl	%eax, %eax
	addl	$1, %eax
	sall	$3, %eax
	movl	%eax, %edx
	addl	8(%ebp), %edx
	movl	$16, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	-4(%ebp), %eax
	movzbl	3(%eax), %eax
	leal	1(%eax), %edx
	movl	-4(%ebp), %eax
	movb	%dl, 3(%eax)
	movl	$0, %eax
	leave
	ret
	.size	inet6_rth_add, .-inet6_rth_add
.globl inet6_rth_getaddr
	.type	inet6_rth_getaddr, @function
inet6_rth_getaddr:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	$0, -4(%ebp)
	movl	-8(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L14
	movl	$0, -20(%ebp)
	jmp	.L15
.L14:
	cmpl	$0, 12(%ebp)
	js	.L16
	movl	-8(%ebp), %eax
	addl	$3, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	cmpl	12(%ebp), %eax
	jge	.L17
.L16:
	movl	$0, -20(%ebp)
	jmp	.L15
.L17:
	movl	12(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	sall	$3, %eax
	addl	-8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	%eax, -20(%ebp)
.L15:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	inet6_rth_getaddr, .-inet6_rth_getaddr
.globl inet6_rth_gettype
	.type	inet6_rth_gettype, @function
inet6_rth_gettype:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	addl	$2, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	leave
	ret
	.size	inet6_rth_gettype, .-inet6_rth_gettype
.globl inet6_rth_init
	.type	inet6_rth_init, @function
inet6_rth_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movb	$0, -1(%ebp)
	cmpl	$0, 16(%ebp)
	jne	.L22
	movb	$8, -1(%ebp)
	movl	-8(%ebp), %eax
	addl	$4, %eax
	movl	$0, (%eax)
	jmp	.L23
.L22:
	cmpl	$2, 16(%ebp)
	jne	.L24
	movb	$8, -1(%ebp)
	movl	-8(%ebp), %eax
	addl	$4, %eax
	movl	$0, (%eax)
	jmp	.L23
.L24:
	movl	$0, -20(%ebp)
	jmp	.L25
.L23:
	movzbl	-1(%ebp), %edx
	movl	20(%ebp), %eax
	sall	$4, %eax
	leal	(%edx,%eax), %eax
	cmpl	12(%ebp), %eax
	jbe	.L26
	movl	$0, -20(%ebp)
	jmp	.L25
.L26:
	movl	-8(%ebp), %eax
	movb	$0, (%eax)
	movl	20(%ebp), %eax
	leal	(%eax,%eax), %edx
	movl	-8(%ebp), %eax
	movb	%dl, 1(%eax)
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 2(%eax)
	movl	-8(%ebp), %eax
	movb	$0, 3(%eax)
	movl	8(%ebp), %eax
	movl	%eax, -20(%ebp)
.L25:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	inet6_rth_init, .-inet6_rth_init
.globl inet6_rth_space
	.type	inet6_rth_space, @function
inet6_rth_space:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	cmpl	$0, 8(%ebp)
	jne	.L29
	cmpl	$128, 12(%ebp)
	jle	.L30
	movl	$0, -4(%ebp)
	jmp	.L31
.L30:
	movl	12(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	sall	$3, %eax
	movl	%eax, -4(%ebp)
	jmp	.L31
.L29:
	cmpl	$2, 8(%ebp)
	jne	.L32
	cmpl	$1, 12(%ebp)
	je	.L33
	movl	$0, -4(%ebp)
	jmp	.L31
.L33:
	movl	$24, -4(%ebp)
	jmp	.L31
.L32:
	movl	$0, -4(%ebp)
.L31:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	inet6_rth_space, .-inet6_rth_space
.globl ipv6_unmap_addr
	.type	ipv6_unmap_addr, @function
ipv6_unmap_addr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$20, %esp
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L36
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L36
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %ebx
	movl	$65535, (%esp)
	call	htonl
	cmpl	%eax, %ebx
	je	.L37
.L36:
	movl	$0, -8(%ebp)
	jmp	.L38
.L37:
	movl	12(%ebp), %eax
	movl	$0, (%eax)
	movl	8(%ebp), %eax
	addl	$12, %eax
	movl	(%eax), %edx
	movl	12(%ebp), %eax
	movl	%edx, (%eax)
	movl	$1, -8(%ebp)
.L38:
	movl	-8(%ebp), %eax
	addl	$20, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	ipv6_unmap_addr, .-ipv6_unmap_addr
.globl ipv6_map_addr
	.type	ipv6_map_addr, @function
ipv6_map_addr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$20, %esp
	movl	$16, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$65535, (%esp)
	call	htonl
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 12(%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L41
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L41
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %ebx
	movl	$65535, (%esp)
	call	htonl
	cmpl	%eax, %ebx
	je	.L42
.L41:
	movl	$0, -8(%ebp)
	jmp	.L43
.L42:
	movl	$1, -8(%ebp)
.L43:
	movl	-8(%ebp), %eax
	addl	$20, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	ipv6_map_addr, .-ipv6_map_addr
.globl rtnl_close
	.type	rtnl_close, @function
rtnl_close:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	js	.L47
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	close
	movl	8(%ebp), %eax
	movl	$-1, (%eax)
.L47:
	leave
	ret
	.size	rtnl_close, .-rtnl_close
	.section	.rodata
.LC0:
	.string	"Cannot open netlink socket"
.LC1:
	.string	"SO_SNDBUF"
.LC2:
	.string	"SO_RCVBUF"
.LC3:
	.string	"Cannot bind netlink socket"
.LC4:
	.string	"Cannot getsockname"
.LC5:
	.string	"Wrong address length %d\n"
.LC6:
	.string	"Wrong address family %d\n"
	.text
.globl rtnl_open_byproto
	.type	rtnl_open_byproto, @function
rtnl_open_byproto:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$32768, -8(%ebp)
	movl	$32768, -12(%ebp)
	movl	$4, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$3, 4(%esp)
	movl	$16, (%esp)
	call	socket
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jns	.L49
	movl	$.LC0, (%esp)
	call	perror
	movl	$-1, -20(%ebp)
	jmp	.L50
.L49:
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	$4, 16(%esp)
	leal	-8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$7, 8(%esp)
	movl	$1, 4(%esp)
	movl	%edx, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L51
	movl	$.LC1, (%esp)
	call	perror
	movl	$-1, -20(%ebp)
	jmp	.L50
.L51:
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	$4, 16(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$8, 8(%esp)
	movl	$1, 4(%esp)
	movl	%edx, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L52
	movl	$.LC2, (%esp)
	call	perror
	movl	$-1, -20(%ebp)
	jmp	.L50
.L52:
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	$12, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	memset
	movl	8(%ebp), %eax
	movw	$16, 4(%eax)
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movl	%eax, 12(%edx)
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	$12, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	bind
	testl	%eax, %eax
	jns	.L53
	movl	$.LC3, (%esp)
	call	perror
	movl	$-1, -20(%ebp)
	jmp	.L50
.L53:
	movl	$12, -4(%ebp)
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	(%eax), %ecx
	leal	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%ecx, (%esp)
	call	getsockname
	testl	%eax, %eax
	jns	.L54
	movl	$.LC4, (%esp)
	call	perror
	movl	$-1, -20(%ebp)
	jmp	.L50
.L54:
	movl	-4(%ebp), %eax
	cmpl	$12, %eax
	je	.L55
	movl	-4(%ebp), %eax
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC5, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -20(%ebp)
	jmp	.L50
.L55:
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	cmpw	$16, %ax
	je	.L56
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC6, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -20(%ebp)
	jmp	.L50
.L56:
	movl	$0, (%esp)
	call	time
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 28(%eax)
	movl	$0, -20(%ebp)
.L50:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	rtnl_open_byproto, .-rtnl_open_byproto
.globl rtnl_open
	.type	rtnl_open, @function
rtnl_open:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_open_byproto
	leave
	ret
	.size	rtnl_open, .-rtnl_open
.globl rtnl_wilddump_request
	.type	rtnl_wilddump_request, @function
rtnl_wilddump_request:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$12, 8(%esp)
	movl	$0, 4(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movw	$16, -32(%ebp)
	movl	$20, 8(%esp)
	movl	$0, 4(%esp)
	leal	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$20, -20(%ebp)
	movl	16(%ebp), %eax
	movw	%ax, -16(%ebp)
	movw	$769, -14(%ebp)
	movl	$0, -8(%ebp)
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 28(%eax)
	movl	8(%ebp), %eax
	movl	28(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 32(%eax)
	movl	8(%ebp), %eax
	movl	32(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	12(%ebp), %eax
	movb	%al, -4(%ebp)
	leal	-32(%ebp), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %ecx
	movl	$12, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$0, 12(%esp)
	movl	$20, 8(%esp)
	leal	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	sendto
	leave
	ret
	.size	rtnl_wilddump_request, .-rtnl_wilddump_request
.globl rtnl_dump_request
	.type	rtnl_dump_request, @function
rtnl_dump_request:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$120, %esp
	movl	20(%ebp), %edx
	leal	-16(%ebp), %eax
	movl	%eax, -44(%ebp)
	movl	$16, -40(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	%edx, -32(%ebp)
	leal	-72(%ebp), %eax
	movl	%eax, -84(%ebp)
	movl	$0, -88(%ebp)
	movl	$28, %eax
	cmpl	$4, %eax
	jb	.L63
	movl	$28, %eax
	movl	%eax, %edx
	andl	$-4, %edx
	movl	%edx, -96(%ebp)
	movl	$0, -92(%ebp)
.L64:
	movl	-88(%ebp), %edx
	movl	-84(%ebp), %eax
	movl	-92(%ebp), %ecx
	movl	%edx, (%eax,%ecx)
	addl	$4, -92(%ebp)
	movl	-96(%ebp), %ecx
	cmpl	%ecx, -92(%ebp)
	jb	.L64
	movl	-92(%ebp), %eax
	addl	%eax, -84(%ebp)
.L63:
	leal	-28(%ebp), %eax
	movl	%eax, -72(%ebp)
	movl	$12, -68(%ebp)
	leal	-44(%ebp), %eax
	movl	%eax, -64(%ebp)
	movl	$2, -60(%ebp)
	movl	$12, 8(%esp)
	movl	$0, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movw	$16, -28(%ebp)
	movl	20(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -16(%ebp)
	movl	12(%ebp), %eax
	movw	%ax, -12(%ebp)
	movw	$769, -10(%ebp)
	movl	$0, -4(%ebp)
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 28(%eax)
	movl	8(%ebp), %eax
	movl	28(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 32(%eax)
	movl	8(%ebp), %eax
	movl	32(%eax), %eax
	movl	%eax, -8(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	$0, 8(%esp)
	leal	-72(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	sendmsg
	leave
	ret
	.size	rtnl_dump_request, .-rtnl_dump_request
	.section	.rodata
.LC7:
	.string	"OVERRUN"
.LC8:
	.string	"EOF on netlink\n"
.LC9:
	.string	"ERROR truncated\n"
.LC10:
	.string	"RTNETLINK answers"
.LC11:
	.string	"Message truncated\n"
.LC12:
	.string	"!!!Remnant of size %d\n"
	.text
.globl rtnl_dump_filter
	.type	rtnl_dump_filter, @function
rtnl_dump_filter:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16488, %esp
	leal	-64(%ebp), %eax
	movl	%eax, -16456(%ebp)
	movl	$0, -16460(%ebp)
	movl	$28, %eax
	cmpl	$4, %eax
	jb	.L68
	movl	$28, %eax
	movl	%eax, %edx
	andl	$-4, %edx
	movl	%edx, -16468(%ebp)
	movl	$0, -16464(%ebp)
.L69:
	movl	-16460(%ebp), %edx
	movl	-16456(%ebp), %eax
	movl	-16464(%ebp), %ecx
	movl	%edx, (%eax,%ecx)
	addl	$4, -16464(%ebp)
	movl	-16468(%ebp), %ecx
	cmpl	%ecx, -16464(%ebp)
	jb	.L69
	movl	-16464(%ebp), %eax
	addl	%eax, -16456(%ebp)
.L68:
	leal	-28(%ebp), %eax
	movl	%eax, -64(%ebp)
	movl	$12, -60(%ebp)
	leal	-36(%ebp), %eax
	movl	%eax, -56(%ebp)
	movl	$1, -52(%ebp)
	leal	-16448(%ebp), %eax
	movl	%eax, -36(%ebp)
.L87:
	movl	$16384, -32(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	$0, 8(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	recvmsg
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jns	.L71
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L87
	movl	$.LC7, (%esp)
	call	perror
	jmp	.L87
.L71:
	cmpl	$0, -16(%ebp)
	jne	.L73
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$15, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC8, (%esp)
	call	fwrite
	movl	$-1, -16452(%ebp)
	jmp	.L74
.L73:
	leal	-16448(%ebp), %eax
	movl	%eax, -12(%ebp)
	jmp	.L75
.L85:
	movl	-24(%ebp), %eax
	testl	%eax, %eax
	jne	.L76
	movl	-12(%ebp), %eax
	movl	12(%eax), %edx
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	%eax, %edx
	jne	.L76
	movl	-12(%ebp), %eax
	movl	8(%eax), %edx
	movl	8(%ebp), %eax
	movl	32(%eax), %eax
	cmpl	%eax, %edx
	je	.L77
.L76:
	cmpl	$0, 20(%ebp)
	je	.L79
	movl	24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	movl	20(%ebp), %eax
	call	*%eax
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L79
	movl	-8(%ebp), %eax
	movl	%eax, -16452(%ebp)
	jmp	.L74
.L77:
	movl	-12(%ebp), %eax
	movzwl	4(%eax), %eax
	cmpw	$3, %ax
	jne	.L80
	movl	$0, -16452(%ebp)
	jmp	.L74
.L80:
	movl	-12(%ebp), %eax
	movzwl	4(%eax), %eax
	cmpw	$2, %ax
	jne	.L81
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -4(%ebp)
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$35, %eax
	ja	.L82
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$16, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC9, (%esp)
	call	fwrite
	jmp	.L83
.L82:
	call	__errno_location
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	negl	%eax
	movl	%eax, (%edx)
	movl	$.LC10, (%esp)
	call	perror
.L83:
	movl	$-1, -16452(%ebp)
	jmp	.L74
.L81:
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	movl	12(%ebp), %eax
	call	*%eax
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L79
	movl	-8(%ebp), %edx
	movl	%edx, -16452(%ebp)
	jmp	.L74
.L79:
	movl	-16(%ebp), %edx
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	addl	$3, %eax
	andl	$-4, %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, -16(%ebp)
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	addl	$3, %eax
	andl	$-4, %eax
	addl	%eax, -12(%ebp)
.L75:
	cmpl	$15, -16(%ebp)
	jle	.L84
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$15, %eax
	jbe	.L84
	movl	-12(%ebp), %eax
	movl	(%eax), %edx
	movl	-16(%ebp), %eax
	cmpl	%eax, %edx
	jbe	.L85
.L84:
	movl	-40(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L86
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$18, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC11, (%esp)
	call	fwrite
	jmp	.L87
.L86:
	cmpl	$0, -16(%ebp)
	je	.L87
	movl	stderr, %edx
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC12, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-2, -16452(%ebp)
.L74:
	movl	-16452(%ebp), %eax
	leave
	ret
	.size	rtnl_dump_filter, .-rtnl_dump_filter
	.section	.rodata
.LC13:
	.string	"Cannot talk to rtnetlink"
.LC14:
	.string	"sender address length == %d\n"
.LC15:
	.string	"Truncated message\n"
.LC16:
	.string	"!!!malformed message: len=%d\n"
.LC17:
	.string	"Unexpected reply!!!\n"
	.text
.globl rtnl_talk
	.type	rtnl_talk, @function
rtnl_talk:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16504, %esp
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	12(%ebp), %eax
	movl	%eax, -48(%ebp)
	movl	%edx, -44(%ebp)
	leal	-76(%ebp), %eax
	movl	%eax, -16472(%ebp)
	movl	$0, -16476(%ebp)
	movl	$28, %eax
	cmpl	$4, %eax
	jb	.L90
	movl	$28, %eax
	movl	%eax, %edx
	andl	$-4, %edx
	movl	%edx, -16484(%ebp)
	movl	$0, -16480(%ebp)
.L91:
	movl	-16476(%ebp), %edx
	movl	-16472(%ebp), %eax
	movl	-16480(%ebp), %ecx
	movl	%edx, (%eax,%ecx)
	addl	$4, -16480(%ebp)
	movl	-16484(%ebp), %ecx
	cmpl	%ecx, -16480(%ebp)
	jb	.L91
	movl	-16480(%ebp), %eax
	addl	%eax, -16472(%ebp)
.L90:
	leal	-40(%ebp), %eax
	movl	%eax, -76(%ebp)
	movl	$12, -72(%ebp)
	leal	-48(%ebp), %eax
	movl	%eax, -68(%ebp)
	movl	$1, -64(%ebp)
	movl	$12, 8(%esp)
	movl	$0, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movw	$16, -40(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	leal	1(%eax), %edx
	movl	8(%ebp), %eax
	movl	%edx, 28(%eax)
	movl	8(%ebp), %eax
	movl	28(%eax), %eax
	movl	%eax, -24(%ebp)
	movl	12(%ebp), %edx
	movl	-24(%ebp), %eax
	movl	%eax, 8(%edx)
	cmpl	$0, 24(%ebp)
	jne	.L93
	movl	12(%ebp), %eax
	movzwl	6(%eax), %eax
	movl	%eax, %edx
	orl	$4, %edx
	movl	12(%ebp), %eax
	movw	%dx, 6(%eax)
.L93:
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	$0, 8(%esp)
	leal	-76(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	sendmsg
	movl	%eax, -28(%ebp)
	cmpl	$0, -28(%ebp)
	jns	.L94
	movl	$.LC13, (%esp)
	call	perror
	movl	$-1, -16468(%ebp)
	jmp	.L95
.L94:
	movl	$16384, 8(%esp)
	movl	$0, 4(%esp)
	leal	-16460(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-16460(%ebp), %eax
	movl	%eax, -48(%ebp)
.L115:
	movl	$16384, -44(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	$0, 8(%esp)
	leal	-76(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	recvmsg
	movl	%eax, -28(%ebp)
	cmpl	$0, -28(%ebp)
	jns	.L96
	call	__errno_location
	movl	(%eax), %eax
	cmpl	$4, %eax
	je	.L115
	movl	$.LC7, (%esp)
	call	perror
	jmp	.L115
.L96:
	cmpl	$0, -28(%ebp)
	jne	.L98
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$15, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC8, (%esp)
	call	fwrite
	movl	$-1, -16468(%ebp)
	jmp	.L95
.L98:
	movl	-72(%ebp), %eax
	cmpl	$12, %eax
	je	.L99
	movl	-72(%ebp), %eax
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC14, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-2, -16468(%ebp)
	jmp	.L95
.L99:
	leal	-16460(%ebp), %eax
	movl	%eax, -20(%ebp)
	jmp	.L100
.L113:
	movl	-20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	subl	$16, %eax
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	js	.L101
	movl	-12(%ebp), %eax
	cmpl	-28(%ebp), %eax
	jle	.L102
.L101:
	movl	-52(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L103
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$18, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC15, (%esp)
	call	fwrite
	movl	$-1, -16468(%ebp)
	jmp	.L95
.L103:
	movl	stderr, %edx
	movl	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC16, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-2, -16468(%ebp)
	jmp	.L95
.L102:
	movl	-36(%ebp), %edx
	movl	16(%ebp), %eax
	cmpl	%eax, %edx
	jne	.L104
	movl	-20(%ebp), %eax
	movl	12(%eax), %edx
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	%eax, %edx
	jne	.L104
	movl	-20(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	-24(%ebp), %eax
	je	.L105
.L104:
	cmpl	$0, 28(%ebp)
	je	.L106
	movl	32(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	movl	28(%ebp), %eax
	call	*%eax
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jns	.L106
	movl	-16(%ebp), %eax
	movl	%eax, -16468(%ebp)
	jmp	.L95
.L106:
	movl	-12(%ebp), %eax
	addl	$3, %eax
	andl	$-4, %eax
	subl	%eax, -28(%ebp)
	movl	-12(%ebp), %eax
	addl	$3, %eax
	andl	$-4, %eax
	addl	%eax, -20(%ebp)
	jmp	.L100
.L105:
	movl	-20(%ebp), %eax
	movzwl	4(%eax), %eax
	cmpw	$2, %ax
	jne	.L107
	movl	-20(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -4(%ebp)
	movl	-8(%ebp), %eax
	cmpl	$19, %eax
	ja	.L108
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$16, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC9, (%esp)
	call	fwrite
	jmp	.L109
.L108:
	call	__errno_location
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	(%eax), %eax
	negl	%eax
	movl	%eax, (%edx)
	call	__errno_location
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L110
	cmpl	$0, 24(%ebp)
	je	.L111
	movl	-20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 8(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	24(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
.L111:
	movl	$0, -16468(%ebp)
	jmp	.L95
.L110:
	movl	$.LC10, (%esp)
	call	perror
.L109:
	movl	$-1, -16468(%ebp)
	jmp	.L95
.L107:
	cmpl	$0, 24(%ebp)
	je	.L112
	movl	-20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 8(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	24(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	$0, -16468(%ebp)
	jmp	.L95
.L112:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$20, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC17, (%esp)
	call	fwrite
	movl	-12(%ebp), %eax
	addl	$3, %eax
	andl	$-4, %eax
	subl	%eax, -28(%ebp)
	movl	-12(%ebp), %eax
	addl	$3, %eax
	andl	$-4, %eax
	addl	%eax, -20(%ebp)
.L100:
	movl	-28(%ebp), %eax
	cmpl	$15, %eax
	ja	.L113
	movl	-52(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L114
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$18, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC11, (%esp)
	call	fwrite
	jmp	.L115
.L114:
	cmpl	$0, -28(%ebp)
	je	.L115
	movl	stderr, %edx
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC12, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-2, -16468(%ebp)
.L95:
	movl	-16468(%ebp), %eax
	leave
	ret
	.size	rtnl_talk, .-rtnl_talk
	.section	.rodata
.LC18:
	.string	"Sender address length == %d\n"
	.text
.globl rtnl_listen
	.type	rtnl_listen, @function
rtnl_listen:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8312, %esp
	leal	-68(%ebp), %eax
	movl	%eax, -8280(%ebp)
	movl	$0, -8284(%ebp)
	movl	$28, %eax
	cmpl	$4, %eax
	jb	.L118
	movl	$28, %eax
	movl	%eax, %edx
	andl	$-4, %edx
	movl	%edx, -8292(%ebp)
	movl	$0, -8288(%ebp)
.L119:
	movl	-8284(%ebp), %edx
	movl	-8280(%ebp), %eax
	movl	-8288(%ebp), %ecx
	movl	%edx, (%eax,%ecx)
	addl	$4, -8288(%ebp)
	movl	-8292(%ebp), %ecx
	cmpl	%ecx, -8288(%ebp)
	jb	.L119
	movl	-8288(%ebp), %eax
	addl	%eax, -8280(%ebp)
.L118:
	leal	-32(%ebp), %eax
	movl	%eax, -68(%ebp)
	movl	$12, -64(%ebp)
	leal	-40(%ebp), %eax
	movl	%eax, -60(%ebp)
	movl	$1, -56(%ebp)
	movl	$12, 8(%esp)
	movl	$0, 4(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movw	$16, -32(%ebp)
	movl	$0, -28(%ebp)
	movl	$0, -24(%ebp)
	leal	-8260(%ebp), %eax
	movl	%eax, -40(%ebp)
	movl	$8192, -36(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	$0, 8(%esp)
	leal	-68(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	recvmsg
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jle	.L121
	movl	-64(%ebp), %eax
	cmpl	$12, %eax
	je	.L122
	movl	-64(%ebp), %eax
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC18, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-2, -8276(%ebp)
	jmp	.L123
.L122:
	leal	-8260(%ebp), %eax
	movl	%eax, -16(%ebp)
	jmp	.L124
.L129:
	movl	-16(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	subl	$16, %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	js	.L125
	movl	-8(%ebp), %eax
	cmpl	-20(%ebp), %eax
	jle	.L126
.L125:
	movl	-44(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L127
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$18, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC15, (%esp)
	call	fwrite
	movl	$-1, -8276(%ebp)
	jmp	.L123
.L127:
	movl	stderr, %edx
	movl	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC16, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-2, -8276(%ebp)
	jmp	.L123
.L126:
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, (%esp)
	movl	12(%ebp), %eax
	call	*%eax
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jns	.L128
	movl	-12(%ebp), %eax
	movl	%eax, -8276(%ebp)
	jmp	.L123
.L128:
	movl	-8(%ebp), %eax
	addl	$3, %eax
	andl	$-4, %eax
	subl	%eax, -20(%ebp)
	movl	-8(%ebp), %eax
	addl	$3, %eax
	andl	$-4, %eax
	addl	%eax, -16(%ebp)
.L124:
	movl	-20(%ebp), %eax
	cmpl	$15, %eax
	ja	.L129
	movl	-44(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L130
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$18, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC11, (%esp)
	call	fwrite
	movl	$0, -8276(%ebp)
	jmp	.L123
.L130:
	cmpl	$0, -20(%ebp)
	je	.L131
	movl	stderr, %edx
	movl	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC12, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-2, -8276(%ebp)
	jmp	.L123
.L131:
	movl	$0, -8276(%ebp)
	jmp	.L123
.L121:
	movl	$-1, -8276(%ebp)
.L123:
	movl	-8276(%ebp), %eax
	leave
	ret
	.size	rtnl_listen, .-rtnl_listen
.globl addr_do
	.type	addr_do, @function
addr_do:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$584, %esp
	movl	$256, 8(%esp)
	movl	$0, 4(%esp)
	leal	-272(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-272(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	$24, (%eax)
	movl	-16(%ebp), %eax
	movw	$1, 6(%eax)
	movl	-16(%ebp), %eax
	movw	$22, 4(%eax)
	movl	-16(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movb	$10, (%eax)
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 1(%eax)
	movl	-8(%ebp), %eax
	movb	$0, 3(%eax)
	movl	16(%ebp), %edx
	movl	-8(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	$16, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$256, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movl	$256, 8(%esp)
	movl	$0, 4(%esp)
	leal	-528(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-528(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_route_do
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L134
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	jmp	.L135
.L134:
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	movl	-12(%ebp), %eax
	movzwl	4(%eax), %eax
	cmpw	$20, %ax
	jne	.L136
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$23, %eax
	jbe	.L136
	movl	-8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	je	.L135
.L136:
	movl	$-22, -564(%ebp)
	jmp	.L137
.L135:
	movl	$32, 8(%esp)
	movl	$0, 4(%esp)
	leal	-560(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	-12(%ebp), %eax
	movl	(%eax), %eax
	subl	$24, %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	addl	$8, %eax
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$7, 4(%esp)
	leal	-560(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_rtattr
	movl	-556(%ebp), %eax
	testl	%eax, %eax
	jne	.L138
	movl	-552(%ebp), %eax
	movl	%eax, -556(%ebp)
.L138:
	movl	-556(%ebp), %eax
	testl	%eax, %eax
	je	.L139
	movl	-556(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	.L139
	movl	-556(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	.L139
	movl	-556(%ebp), %eax
	addl	$12, %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	.L139
	movl	-556(%ebp), %eax
	addl	$16, %eax
	movl	(%eax), %edx
	movl	8(%ebp), %eax
	addl	$12, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	je	.L140
.L139:
	movl	$-22, -564(%ebp)
	jmp	.L137
.L140:
	cmpl	$0, 24(%ebp)
	je	.L141
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-560(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	movl	24(%ebp), %eax
	call	*%eax
	movl	%eax, -4(%ebp)
.L141:
	movl	-4(%ebp), %eax
	movl	%eax, -564(%ebp)
.L137:
	movl	-564(%ebp), %eax
	leave
	ret
	.size	addr_do, .-addr_do
	.section	.rodata
	.align 4
.LC19:
	.string	"addattr_l ERROR: message exceeded bound of %d\n"
	.text
	.type	addattr_l, @function
addattr_l:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	24(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -8(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	addl	$3, %eax
	movl	%eax, %edx
	andl	$-4, %edx
	movl	-8(%ebp), %eax
	addl	$3, %eax
	andl	$-4, %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	cmpl	%eax, %edx
	jbe	.L144
	movl	stderr, %edx
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC19, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -20(%ebp)
	jmp	.L145
.L144:
	movl	8(%ebp), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	addl	$3, %eax
	andl	$-4, %eax
	leal	(%edx,%eax), %eax
	movl	%eax, -4(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movw	%dx, 2(%eax)
	movl	-8(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movw	%dx, (%eax)
	movl	24(%ebp), %edx
	movl	-4(%ebp), %eax
	leal	4(%eax), %ecx
	movl	%edx, 8(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	memcpy
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	addl	$3, %eax
	movl	%eax, %edx
	andl	$-4, %edx
	movl	-8(%ebp), %eax
	addl	$3, %eax
	andl	$-4, %eax
	addl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	$0, -20(%ebp)
.L145:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	addattr_l, .-addattr_l
	.type	rtnl_route_do, @function
rtnl_route_do:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$0, (%esp)
	call	rtnl_do
	leave
	ret
	.size	rtnl_route_do, .-rtnl_route_do
	.section	.rodata
	.align 4
.LC20:
	.string	"rtnl: rtnl_open_byproto failed\n"
	.text
	.type	rtnl_do, @function
rtnl_do:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$88, %esp
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_open_byproto
	testl	%eax, %eax
	jns	.L150
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$31, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC20, (%esp)
	call	fwrite
	movl	$-1, -52(%ebp)
	jmp	.L151
.L150:
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_talk
	movl	%eax, -4(%ebp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_close
	movl	-4(%ebp), %eax
	movl	%eax, -52(%ebp)
.L151:
	movl	-52(%ebp), %eax
	leave
	ret
	.size	rtnl_do, .-rtnl_do
	.section	.rodata
.LC21:
	.string	"!!!Deficit %d, rta_len=%d\n"
	.text
	.type	parse_rtattr, @function
parse_rtattr:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	addl	$1, %eax
	sall	$2, %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	jmp	.L154
.L157:
	movl	16(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	cmpl	12(%ebp), %eax
	jg	.L155
	movl	16(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	sall	$2, %eax
	movl	%eax, %edx
	addl	8(%ebp), %edx
	movl	16(%ebp), %eax
	movl	%eax, (%edx)
.L155:
	movl	16(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	addl	$3, %eax
	andl	$-4, %eax
	subl	%eax, 20(%ebp)
	movl	16(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	addl	$3, %eax
	andl	$-4, %eax
	addl	%eax, 16(%ebp)
.L154:
	cmpl	$3, 20(%ebp)
	jle	.L156
	movl	16(%ebp), %eax
	movzwl	(%eax), %eax
	cmpw	$3, %ax
	jbe	.L156
	movl	16(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	cmpl	20(%ebp), %eax
	jle	.L157
.L156:
	cmpl	$0, 20(%ebp)
	je	.L158
	movl	16(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%eax, 12(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC21, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
.L158:
	movl	$0, %eax
	leave
	ret
	.size	parse_rtattr, .-parse_rtattr
.globl addr4_do
	.type	addr4_do, @function
addr4_do:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$552, %esp
	movl	$256, 8(%esp)
	movl	$0, 4(%esp)
	leal	-272(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-272(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	$24, (%eax)
	movl	-16(%ebp), %eax
	movw	$1, 6(%eax)
	movl	-16(%ebp), %eax
	movw	$22, 4(%eax)
	movl	-16(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movb	$2, (%eax)
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 1(%eax)
	movl	-8(%ebp), %eax
	movb	$0, 3(%eax)
	movl	16(%ebp), %edx
	movl	-8(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	$4, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$256, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movl	$256, 8(%esp)
	movl	$0, 4(%esp)
	leal	-528(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-528(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_route_do
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L161
	movl	-16(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	jmp	.L162
.L161:
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
.L162:
	cmpl	$0, 24(%ebp)
	je	.L163
	movl	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	movl	24(%ebp), %eax
	call	*%eax
	movl	%eax, -4(%ebp)
.L163:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	addr4_do, .-addr4_do
	.type	addr_mod, @function
addr_mod:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$324, %esp
	movl	12(%ebp), %eax
	movl	20(%ebp), %edx
	movl	24(%ebp), %ecx
	movl	28(%ebp), %ebx
	movw	%ax, -296(%ebp)
	movb	%dl, -300(%ebp)
	movb	%cl, -304(%ebp)
	movb	%bl, -308(%ebp)
	movl	$256, 8(%esp)
	movl	$0, 4(%esp)
	leal	-268(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-268(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$24, (%eax)
	movzwl	-296(%ebp), %eax
	movl	%eax, %edx
	orl	$1, %edx
	movl	-12(%ebp), %eax
	movw	%dx, 6(%eax)
	movl	8(%ebp), %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movw	%dx, 4(%eax)
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movb	$10, (%eax)
	movl	-8(%ebp), %edx
	movzbl	-300(%ebp), %eax
	movb	%al, 1(%edx)
	movl	-8(%ebp), %edx
	movzbl	-304(%ebp), %eax
	movb	%al, 2(%edx)
	movl	-8(%ebp), %edx
	movzbl	-308(%ebp), %eax
	movb	%al, 3(%edx)
	movl	32(%ebp), %edx
	movl	-8(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	$16, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$256, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	cmpl	$0, 36(%ebp)
	jne	.L166
	cmpl	$0, 40(%ebp)
	je	.L167
.L166:
	movl	36(%ebp), %eax
	movl	%eax, -284(%ebp)
	movl	40(%ebp), %eax
	movl	%eax, -280(%ebp)
	movl	$0, -276(%ebp)
	movl	$0, -272(%ebp)
	movl	$16, 16(%esp)
	leal	-284(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$6, 8(%esp)
	movl	$256, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L167:
	movl	$0, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_route_do
	addl	$324, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	addr_mod, .-addr_mod
	.section	.rodata
.LC22:
	.string	"Failed to modify address"
	.text
	.type	addr4_mod, @function
addr4_mod:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$360, %esp
	movl	$280, 8(%esp)
	movl	$0, 4(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$24, -320(%ebp)
	movw	$1, -314(%ebp)
	movl	20(%ebp), %eax
	movw	%ax, -316(%ebp)
	movb	$2, -304(%ebp)
	movl	12(%ebp), %eax
	movb	%al, -303(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -300(%ebp)
	movl	$4, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$280, 4(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movl	$0, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_open
	testl	%eax, %eax
	je	.L170
	movl	$-1, -324(%ebp)
	jmp	.L171
.L170:
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_talk
	testl	%eax, %eax
	jns	.L172
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$24, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC22, (%esp)
	call	fwrite
	movl	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-1, -324(%ebp)
	jmp	.L171
.L172:
	movl	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$0, -324(%ebp)
.L171:
	movl	-324(%ebp), %eax
	leave
	ret
	.size	addr4_mod, .-addr4_mod
.globl addr_add
	.type	addr_add, @function
addr_add:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$52, %esp
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
	movl	20(%ebp), %ecx
	movb	%al, -8(%ebp)
	movb	%dl, -12(%ebp)
	movb	%cl, -16(%ebp)
	movzbl	-16(%ebp), %edx
	movzbl	-12(%ebp), %ecx
	movzbl	-8(%ebp), %ebx
	movl	32(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	%edx, 20(%esp)
	movl	%ecx, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1280, 4(%esp)
	movl	$20, (%esp)
	call	addr_mod
	addl	$52, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	addr_add, .-addr_add
.globl addr_del
	.type	addr_del, @function
addr_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	12(%ebp), %eax
	movb	%al, -4(%ebp)
	movzbl	-4(%ebp), %edx
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	$21, (%esp)
	call	addr_mod
	leave
	ret
	.size	addr_del, .-addr_del
.globl addr4_add
	.type	addr4_add, @function
addr4_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movb	%al, -4(%ebp)
	movzbl	-4(%ebp), %edx
	movl	$20, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	addr4_mod
	leave
	ret
	.size	addr4_add, .-addr4_add
.globl addr4_del
	.type	addr4_del, @function
addr4_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movb	%al, -4(%ebp)
	movzbl	-4(%ebp), %edx
	movl	$21, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	addr4_mod
	leave
	ret
	.size	addr4_del, .-addr4_del
	.type	route_mod, @function
route_mod:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$568, %esp
	movl	16(%ebp), %eax
	movl	20(%ebp), %edx
	movb	%al, -532(%ebp)
	movb	%dl, -536(%ebp)
	cmpl	$24, 8(%ebp)
	jne	.L183
	cmpl	$0, 12(%ebp)
	jne	.L183
	movl	$-1, -540(%ebp)
	jmp	.L184
.L183:
	movl	$512, 8(%esp)
	movl	$0, 4(%esp)
	leal	-520(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-520(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	$28, (%eax)
	movl	-8(%ebp), %eax
	movw	$1, 6(%eax)
	cmpl	$24, 8(%ebp)
	jne	.L185
	movl	-8(%ebp), %eax
	movzwl	6(%eax), %eax
	movl	%eax, %edx
	orb	$6, %dh
	movl	-8(%ebp), %eax
	movw	%dx, 6(%eax)
.L185:
	movl	8(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movw	%dx, 4(%eax)
	movl	-8(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movb	$10, (%eax)
	movl	44(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movb	%dl, 1(%eax)
	movl	36(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movb	%dl, 2(%eax)
	movl	-4(%ebp), %edx
	movzbl	-532(%ebp), %eax
	movb	%al, 4(%edx)
	movl	-4(%ebp), %edx
	movzbl	-536(%ebp), %eax
	movb	%al, 5(%edx)
	movl	-4(%ebp), %eax
	movb	$0, 6(%eax)
	movl	-4(%ebp), %eax
	movb	$1, 7(%eax)
	movl	-4(%ebp), %edx
	movl	24(%ebp), %eax
	movl	%eax, 8(%edx)
	movl	$16, 16(%esp)
	movl	40(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1, 8(%esp)
	movl	$512, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	cmpl	$0, 32(%ebp)
	je	.L186
	movl	$16, 16(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$512, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L186:
	movl	12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$4, 8(%esp)
	movl	$512, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr32
	cmpl	$0, 48(%ebp)
	je	.L187
	movl	$16, 16(%esp)
	movl	48(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$5, 8(%esp)
	movl	$512, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L187:
	cmpl	$0, 28(%ebp)
	je	.L188
	movl	28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$6, 8(%esp)
	movl	$512, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr32
.L188:
	movl	$0, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_route_do
	movl	%eax, -540(%ebp)
.L184:
	movl	-540(%ebp), %eax
	leave
	ret
	.size	route_mod, .-route_mod
	.section	.rodata
	.align 4
.LC23:
	.string	"addattr32: Error! max allowed bound %d exceeded\n"
	.text
	.type	addattr32, @function
addattr32:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$8, -8(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	addl	$3, %eax
	movl	%eax, %edx
	andl	$-4, %edx
	movl	-8(%ebp), %eax
	addl	%eax, %edx
	movl	12(%ebp), %eax
	cmpl	%eax, %edx
	jbe	.L191
	movl	stderr, %edx
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC23, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -20(%ebp)
	jmp	.L192
.L191:
	movl	8(%ebp), %edx
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	addl	$3, %eax
	andl	$-4, %eax
	leal	(%edx,%eax), %eax
	movl	%eax, -4(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movw	%dx, 2(%eax)
	movl	-8(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movw	%dx, (%eax)
	movl	-4(%ebp), %eax
	leal	4(%eax), %edx
	movl	$4, 8(%esp)
	leal	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	addl	$3, %eax
	movl	%eax, %edx
	andl	$-4, %edx
	movl	-8(%ebp), %eax
	addl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax)
	movl	$0, -20(%ebp)
.L192:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	addattr32, .-addattr32
.globl route_add
	.type	route_add, @function
route_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
	movb	%al, -4(%ebp)
	movb	%dl, -8(%ebp)
	movzbl	-8(%ebp), %edx
	movzbl	-4(%ebp), %ecx
	movl	44(%ebp), %eax
	movl	%eax, 40(%esp)
	movl	40(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$24, (%esp)
	call	route_mod
	leave
	ret
	.size	route_add, .-route_add
.globl route_del
	.type	route_del, @function
route_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	12(%ebp), %eax
	movb	%al, -4(%ebp)
	movzbl	-4(%ebp), %edx
	movl	36(%ebp), %eax
	movl	%eax, 40(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	%edx, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$25, (%esp)
	call	route_mod
	leave
	ret
	.size	route_del, .-route_del
	.type	rule_mod, @function
rule_mod:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$568, %esp
	movl	16(%ebp), %eax
	movl	24(%ebp), %edx
	movb	%al, -532(%ebp)
	movb	%dl, -536(%ebp)
	movl	$512, 8(%esp)
	movl	$0, 4(%esp)
	leal	-520(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-520(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	$28, (%eax)
	movl	-8(%ebp), %eax
	movw	$1, 6(%eax)
	cmpl	$32, 12(%ebp)
	jne	.L199
	movl	-8(%ebp), %eax
	movzwl	6(%eax), %eax
	movl	%eax, %edx
	orb	$4, %dh
	movl	-8(%ebp), %eax
	movw	%dx, 6(%eax)
.L199:
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movw	%dx, 4(%eax)
	movl	-8(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movb	$10, (%eax)
	movl	40(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movb	%dl, 1(%eax)
	movl	32(%ebp), %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movb	%dl, 2(%eax)
	movl	-4(%ebp), %edx
	movzbl	-532(%ebp), %eax
	movb	%al, 4(%edx)
	movl	-4(%ebp), %eax
	movb	$0, 6(%eax)
	movl	-4(%ebp), %edx
	movzbl	-536(%ebp), %eax
	movb	%al, 7(%edx)
	movl	44(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	$16, 16(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1, 8(%esp)
	movl	$512, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	cmpl	$0, 28(%ebp)
	je	.L200
	movl	$16, 16(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$512, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L200:
	cmpl	$0, 20(%ebp)
	je	.L201
	movl	20(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$6, 8(%esp)
	movl	$512, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr32
.L201:
	cmpl	$0, 8(%ebp)
	je	.L202
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	addl	$1, %eax
	movl	%eax, 16(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$3, 8(%esp)
	movl	$512, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L202:
	movl	$0, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_route_do
	leave
	ret
	.size	rule_mod, .-rule_mod
.globl rule_add
	.type	rule_add, @function
rule_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	12(%ebp), %eax
	movl	20(%ebp), %edx
	movb	%al, -4(%ebp)
	movb	%dl, -8(%ebp)
	movzbl	-8(%ebp), %edx
	movzbl	-4(%ebp), %ecx
	movl	40(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	%edx, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	$32, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	rule_mod
	leave
	ret
	.size	rule_add, .-rule_add
.globl rule_del
	.type	rule_del, @function
rule_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	12(%ebp), %eax
	movl	20(%ebp), %edx
	movb	%al, -4(%ebp)
	movb	%dl, -8(%ebp)
	movzbl	-8(%ebp), %edx
	movzbl	-4(%ebp), %ecx
	movl	40(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	%edx, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	$33, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	rule_mod
	leave
	ret
	.size	rule_del, .-rule_del
	.section	.rodata
	.align 4
.LC24:
	.string	"change_iprule: invalid table id %i\n"
	.align 4
.LC25:
	.string	"change_iprule: rtnl_talk failed\n"
	.text
	.type	change_iprule, @function
change_iprule:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$1128, %esp
	movl	$1052, 8(%esp)
	movl	$0, 4(%esp)
	leal	-1088(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	8(%ebp), %eax
	movw	%ax, -1084(%ebp)
	movl	$28, -1088(%ebp)
	movw	$1, -1082(%ebp)
	movb	$2, -1072(%ebp)
	movb	$3, -1067(%ebp)
	movb	$0, -1066(%ebp)
	movb	$0, -1068(%ebp)
	movl	12(%ebp), %eax
	movb	%al, -1065(%ebp)
	movl	44(%ebp), %eax
	movl	%eax, -1064(%ebp)
	cmpl	$32, 8(%ebp)
	jne	.L209
	movzwl	-1082(%ebp), %eax
	orb	$6, %ah
	movw	%ax, -1082(%ebp)
.L209:
	cmpl	$0, 16(%ebp)
	je	.L210
	movl	20(%ebp), %eax
	movb	%al, -1070(%ebp)
	movl	$4, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$1052, 4(%esp)
	leal	-1088(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L210:
	cmpl	$0, 24(%ebp)
	je	.L211
	movl	28(%ebp), %eax
	movb	%al, -1071(%ebp)
	movl	$4, 16(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1, 8(%esp)
	movl	$1052, 4(%esp)
	leal	-1088(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L211:
	cmpl	$0, 32(%ebp)
	js	.L212
	cmpl	$255, 32(%ebp)
	jle	.L213
.L212:
	movl	stderr, %edx
	movl	32(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC24, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -1092(%ebp)
	jmp	.L214
.L213:
	movl	32(%ebp), %eax
	movb	%al, -1068(%ebp)
	cmpl	$0, 40(%ebp)
	js	.L215
	movl	40(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$6, 8(%esp)
	movl	$1052, 4(%esp)
	leal	-1088(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr32
.L215:
	cmpl	$0, 36(%ebp)
	je	.L216
	movl	36(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	addl	$1, %eax
	movl	%eax, 16(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$3, 8(%esp)
	movl	$1052, 4(%esp)
	leal	-1088(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L216:
	movl	$0, 4(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_open
	testl	%eax, %eax
	je	.L217
	movl	$-1, -1092(%ebp)
	jmp	.L214
.L217:
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	leal	-1088(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_talk
	testl	%eax, %eax
	jns	.L218
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$32, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC25, (%esp)
	call	fwrite
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-1, -1092(%ebp)
	jmp	.L214
.L218:
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$0, -1092(%ebp)
.L214:
	movl	-1092(%ebp), %eax
	leave
	ret
	.size	change_iprule, .-change_iprule
.globl rule4_add
	.type	rule4_add, @function
rule4_add:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$52, %esp
	movl	12(%ebp), %eax
	movl	20(%ebp), %edx
	movb	%al, -8(%ebp)
	movb	%dl, -12(%ebp)
	movl	16(%ebp), %edx
	movzbl	-8(%ebp), %ecx
	movzbl	-12(%ebp), %ebx
	movl	40(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	%edx, 32(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	%ecx, 24(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	$32, (%esp)
	call	change_iprule
	addl	$52, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	rule4_add, .-rule4_add
.globl rule4_del
	.type	rule4_del, @function
rule4_del:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$52, %esp
	movl	12(%ebp), %eax
	movl	20(%ebp), %edx
	movb	%al, -8(%ebp)
	movb	%dl, -12(%ebp)
	movl	16(%ebp), %edx
	movzbl	-8(%ebp), %ecx
	movzbl	-12(%ebp), %ebx
	movl	40(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	%edx, 32(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	%ecx, 24(%esp)
	movl	36(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	$33, (%esp)
	call	change_iprule
	addl	$52, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	rule4_del, .-rule4_del
	.section	.rodata
.LC26:
	.string	"add route failed!"
	.text
	.type	route4_mod, @function
route4_mod:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$360, %esp
	movl	16(%ebp), %eax
	movb	%al, -324(%ebp)
	movl	$284, 8(%esp)
	movl	$0, 4(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	cmpl	$24, 8(%ebp)
	jne	.L225
	cmpl	$0, 12(%ebp)
	jne	.L225
	movl	$-1, -328(%ebp)
	jmp	.L226
.L225:
	movl	$0, 4(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_open
	testl	%eax, %eax
	je	.L227
	movl	$-1, -328(%ebp)
	jmp	.L226
.L227:
	movl	$28, -320(%ebp)
	movw	$1, -314(%ebp)
	movl	8(%ebp), %eax
	movw	%ax, -316(%ebp)
	cmpl	$24, 8(%ebp)
	jne	.L228
	movzwl	-314(%ebp), %eax
	orb	$6, %ah
	movw	%ax, -314(%ebp)
.L228:
	cmpl	$0, 40(%ebp)
	je	.L229
	movw	$1025, -314(%ebp)
.L229:
	movb	$2, -304(%ebp)
	movzbl	-324(%ebp), %eax
	movb	%al, -300(%ebp)
	cmpl	$25, 8(%ebp)
	jne	.L230
	movb	$0, -299(%ebp)
	movb	$-1, -298(%ebp)
	movb	$0, -297(%ebp)
	jmp	.L231
.L230:
	movb	$3, -299(%ebp)
	movb	$-3, -298(%ebp)
	movb	$1, -297(%ebp)
.L231:
	cmpl	$0, 32(%ebp)
	je	.L232
	movl	$4, 16(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1, 8(%esp)
	movl	$284, 4(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movl	36(%ebp), %eax
	movb	%al, -303(%ebp)
.L232:
	movl	12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$4, 8(%esp)
	movl	$284, 4(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr32
	cmpl	$0, 24(%ebp)
	je	.L233
	movl	$4, 16(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$284, 4(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movl	28(%ebp), %eax
	movb	%al, -302(%ebp)
.L233:
	movl	12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$4, 8(%esp)
	movl	$284, 4(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr32
	cmpl	$0, 40(%ebp)
	je	.L234
	movl	$4, 16(%esp)
	movl	40(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$5, 8(%esp)
	movl	$284, 4(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movb	$0, -298(%ebp)
.L234:
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	leal	-320(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_talk
	testl	%eax, %eax
	jns	.L235
	movl	$.LC26, (%esp)
	call	perror
.L235:
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$0, -328(%ebp)
.L226:
	movl	-328(%ebp), %eax
	leave
	ret
	.size	route4_mod, .-route4_mod
.globl route4_add
	.type	route4_add, @function
route4_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	12(%ebp), %eax
	movb	%al, -4(%ebp)
	movzbl	-4(%ebp), %edx
	movl	36(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$24, (%esp)
	call	route4_mod
	leave
	ret
	.size	route4_add, .-route4_add
.globl route4_del
	.type	route4_del, @function
route4_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	12(%ebp), %eax
	movb	%al, -4(%ebp)
	movzbl	-4(%ebp), %edx
	movl	32(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	%edx, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$25, (%esp)
	call	route4_mod
	leave
	ret
	.size	route4_del, .-route4_del
	.section	.rodata
	.align 4
.LC27:
	.string	"sel.daddr %x:%x:%x:%x:%x:%x:%x:%x\nsel.saddr %x:%x:%x:%x:%x:%x:%x:%x\nsel.dport %x\nsel.dport_mask %x\nsel.sport %x\nsel.sport_mask %x\nsel.prefixlen_d %d\nsel.prefixlen_s %d\nsel.proto %d\nsel.ifindex %d\n"
	.text
	.type	xfrm_sel_dump, @function
xfrm_sel_dump:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$188, %esp
	movl	8(%ebp), %eax
	movl	48(%eax), %ebx
	movl	8(%ebp), %eax
	movzbl	44(%eax), %eax
	movzbl	%al, %esi
	movl	8(%ebp), %eax
	movzbl	43(%eax), %eax
	movzbl	%al, %edi
	movl	8(%ebp), %eax
	movzbl	42(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -92(%ebp)
	movl	8(%ebp), %eax
	movzwl	38(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, -88(%ebp)
	movl	8(%ebp), %eax
	movzwl	36(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, -84(%ebp)
	movl	8(%ebp), %eax
	movzwl	34(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, -80(%ebp)
	movl	8(%ebp), %eax
	movzwl	32(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, -76(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -72(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -68(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -64(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -60(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -56(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -52(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -48(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -44(%ebp)
	movl	8(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -40(%ebp)
	movl	8(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -36(%ebp)
	movl	8(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -32(%ebp)
	movl	8(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -28(%ebp)
	movl	8(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -24(%ebp)
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%ebx, 100(%esp)
	movl	%esi, 96(%esp)
	movl	%edi, 92(%esp)
	movl	-92(%ebp), %ecx
	movl	%ecx, 88(%esp)
	movl	-88(%ebp), %ecx
	movl	%ecx, 84(%esp)
	movl	-84(%ebp), %ecx
	movl	%ecx, 80(%esp)
	movl	-80(%ebp), %ecx
	movl	%ecx, 76(%esp)
	movl	-76(%ebp), %ecx
	movl	%ecx, 72(%esp)
	movl	-72(%ebp), %ecx
	movl	%ecx, 68(%esp)
	movl	-68(%ebp), %ecx
	movl	%ecx, 64(%esp)
	movl	-64(%ebp), %ecx
	movl	%ecx, 60(%esp)
	movl	-60(%ebp), %ecx
	movl	%ecx, 56(%esp)
	movl	-56(%ebp), %ecx
	movl	%ecx, 52(%esp)
	movl	-52(%ebp), %ecx
	movl	%ecx, 48(%esp)
	movl	-48(%ebp), %ecx
	movl	%ecx, 44(%esp)
	movl	-44(%ebp), %ecx
	movl	%ecx, 40(%esp)
	movl	-40(%ebp), %ecx
	movl	%ecx, 36(%esp)
	movl	-36(%ebp), %ecx
	movl	%ecx, 32(%esp)
	movl	-32(%ebp), %ecx
	movl	%ecx, 28(%esp)
	movl	-28(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-24(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-20(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-16(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC27, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	addl	$188, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	xfrm_sel_dump, .-xfrm_sel_dump
	.section	.rodata
	.align 4
.LC28:
	.string	"sel.daddr %d.%d.%d.%d\nsel.saddr %d.%d.%d.%d\nsel.dport %x\nsel.dport_mask %x\nsel.sport %x\nsel.sport_mask %x\nsel.prefixlen_d %d\nsel.prefixlen_s %d\nsel.proto %d\nsel.ifindex %d\n"
	.text
	.type	xfrm_sel4_dump, @function
xfrm_sel4_dump:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$124, %esp
	movl	8(%ebp), %eax
	movl	48(%eax), %edx
	movl	8(%ebp), %eax
	movzbl	44(%eax), %eax
	movzbl	%al, %ecx
	movl	8(%ebp), %eax
	movzbl	43(%eax), %eax
	movzbl	%al, %ebx
	movl	8(%ebp), %eax
	movzbl	42(%eax), %eax
	movzbl	%al, %esi
	movl	8(%ebp), %eax
	movzwl	38(%eax), %eax
	movzwl	%ax, %edi
	movl	8(%ebp), %eax
	movzwl	36(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, -56(%ebp)
	movl	8(%ebp), %eax
	movzwl	34(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, -52(%ebp)
	movl	8(%ebp), %eax
	movzwl	32(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, -48(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	(%eax), %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, -44(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	(%eax), %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	shrl	$16, %eax
	movl	%eax, -40(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	(%eax), %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	shrl	$8, %eax
	movl	%eax, -36(%ebp)
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	(%eax), %eax
	andl	$255, %eax
	movl	%eax, -32(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, -28(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	shrl	$16, %eax
	movl	%eax, -24(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -60(%ebp)
	movl	-60(%ebp), %eax
	shrl	$8, %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	andl	$255, %eax
	movl	%eax, -60(%ebp)
	movl	stderr, %eax
	movl	%eax, -16(%ebp)
	movl	%edx, 68(%esp)
	movl	%ecx, 64(%esp)
	movl	%ebx, 60(%esp)
	movl	%esi, 56(%esp)
	movl	%edi, 52(%esp)
	movl	-56(%ebp), %eax
	movl	%eax, 48(%esp)
	movl	-52(%ebp), %eax
	movl	%eax, 44(%esp)
	movl	-48(%ebp), %eax
	movl	%eax, 40(%esp)
	movl	-44(%ebp), %eax
	movl	%eax, 36(%esp)
	movl	-40(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	-60(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC28, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	fprintf
	addl	$124, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	xfrm_sel4_dump, .-xfrm_sel4_dump
	.section	.rodata
.LC29:
	.string	"nlmsg_flags %x\nnlmsg_type %d\n"
	.text
	.type	nlmsg_dump, @function
nlmsg_dump:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	stderr, %eax
	movl	12(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	8(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$.LC29, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	leave
	ret
	.size	nlmsg_dump, .-nlmsg_dump
	.section	.rodata
	.align 4
.LC30:
	.string	"xfrma_tmpl.id.daddr %x:%x:%x:%x:%x:%x:%x:%x\nxfrma_tmpl.id.spi %x\nxfrma_tmpl.id.proto %d\nxfrma_tmpl.saddr %x:%x:%x:%x:%x:%x:%x:%x\nxfrma_tmpl.reqid %d\nxfrma_tmpl.mode %d\nxfmra_tmpl.optional %d\nxfrma_tmpl.aalgos %x\nxfrma_tmpl.ealgos %d\nxfrma_tmpl.calgos %d\n"
	.text
	.type	xfrm_tmpl_dump, @function
xfrm_tmpl_dump:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$188, %esp
	movl	8(%ebp), %eax
	movl	60(%eax), %ebx
	movl	8(%ebp), %eax
	movl	56(%eax), %esi
	movl	8(%ebp), %eax
	movl	52(%eax), %edi
	movl	8(%ebp), %eax
	movzbl	48(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -88(%ebp)
	movl	8(%ebp), %eax
	movl	44(%eax), %eax
	movl	%eax, -84(%ebp)
	movl	8(%ebp), %eax
	addl	$28, %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -80(%ebp)
	movl	8(%ebp), %eax
	addl	$28, %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -76(%ebp)
	movl	8(%ebp), %eax
	addl	$28, %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -72(%ebp)
	movl	8(%ebp), %eax
	addl	$28, %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -68(%ebp)
	movl	8(%ebp), %eax
	addl	$28, %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -64(%ebp)
	movl	8(%ebp), %eax
	addl	$28, %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -60(%ebp)
	movl	8(%ebp), %eax
	addl	$28, %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -56(%ebp)
	movl	8(%ebp), %eax
	addl	$28, %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -52(%ebp)
	movl	8(%ebp), %eax
	movzbl	20(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -48(%ebp)
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	movl	%eax, -44(%ebp)
	movl	8(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -40(%ebp)
	movl	8(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -36(%ebp)
	movl	8(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -32(%ebp)
	movl	8(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -28(%ebp)
	movl	8(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -24(%ebp)
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -20(%ebp)
	movl	8(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%ebx, 96(%esp)
	movl	%esi, 92(%esp)
	movl	%edi, 88(%esp)
	movl	-88(%ebp), %ecx
	movl	%ecx, 84(%esp)
	movl	-84(%ebp), %ecx
	movl	%ecx, 80(%esp)
	movl	-80(%ebp), %ecx
	movl	%ecx, 76(%esp)
	movl	-76(%ebp), %ecx
	movl	%ecx, 72(%esp)
	movl	-72(%ebp), %ecx
	movl	%ecx, 68(%esp)
	movl	-68(%ebp), %ecx
	movl	%ecx, 64(%esp)
	movl	-64(%ebp), %ecx
	movl	%ecx, 60(%esp)
	movl	-60(%ebp), %ecx
	movl	%ecx, 56(%esp)
	movl	-56(%ebp), %ecx
	movl	%ecx, 52(%esp)
	movl	-52(%ebp), %ecx
	movl	%ecx, 48(%esp)
	movl	-48(%ebp), %ecx
	movl	%ecx, 44(%esp)
	movl	-44(%ebp), %ecx
	movl	%ecx, 40(%esp)
	movl	-40(%ebp), %ecx
	movl	%ecx, 36(%esp)
	movl	-36(%ebp), %ecx
	movl	%ecx, 32(%esp)
	movl	-32(%ebp), %ecx
	movl	%ecx, 28(%esp)
	movl	-28(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-24(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-20(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-16(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC30, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	addl	$188, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	xfrm_tmpl_dump, .-xfrm_tmpl_dump
	.section	.rodata
.LC31:
	.string	"%u"
	.align 4
.LC32:
	.string	"priority %d\ndir %d\naction %d\ntype %s\n"
	.text
	.type	xfrm_policy_dump, @function
xfrm_policy_dump:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$112, %esp
	movl	24(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, 8(%esp)
	movl	$.LC31, 4(%esp)
	leal	-76(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	movl	stderr, %edx
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	nlmsg_dump
	movl	20(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_sel_dump
	movl	20(%ebp), %eax
	movzbl	161(%eax), %eax
	movzbl	%al, %edx
	movl	20(%ebp), %eax
	movzbl	160(%eax), %eax
	movzbl	%al, %ecx
	movl	20(%ebp), %eax
	movl	152(%eax), %ebx
	movl	stderr, %esi
	leal	-76(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	%edx, 16(%esp)
	movl	%ecx, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	$.LC32, 4(%esp)
	movl	%esi, (%esp)
	call	fprintf
	movl	$0, -12(%ebp)
	jmp	.L250
.L251:
	movl	-12(%ebp), %eax
	sall	$6, %eax
	addl	28(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_tmpl_dump
	addl	$1, -12(%ebp)
.L250:
	movl	-12(%ebp), %eax
	cmpl	32(%ebp), %eax
	jl	.L251
	addl	$112, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	xfrm_policy_dump, .-xfrm_policy_dump
	.section	.rodata
.LC33:
	.string	"dir %d\ntype %s\n"
	.text
	.type	xfrm_policy_id_dump, @function
xfrm_policy_id_dump:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$88, %esp
	movl	16(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, 8(%esp)
	movl	$.LC31, 4(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	movl	stderr, %edx
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_sel_dump
	movl	12(%ebp), %eax
	movzbl	60(%eax), %eax
	movzbl	%al, %edx
	movl	stderr, %ecx
	leal	-64(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC33, 4(%esp)
	movl	%ecx, (%esp)
	call	fprintf
	leave
	ret
	.size	xfrm_policy_id_dump, .-xfrm_policy_id_dump
	.section	.rodata
	.align 4
.LC34:
	.string	"id.daddr %x:%x:%x:%x:%x:%x:%x:%x\nid.spi %x\nid.proto %d\nsaddr %x:%x:%x:%x:%x:%x:%x:%x\nreqid %d\nmode %d\nflags %x\nxfrma_addr %x:%x:%x:%x:%x:%x:%x:%x\n"
	.text
	.type	xfrm_state_dump, @function
xfrm_state_dump:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$236, %esp
	movl	stderr, %edx
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	nlmsg_dump
	movl	20(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_sel_dump
	movl	24(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %ebx
	movl	24(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %esi
	movl	24(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edi
	movl	24(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -112(%ebp)
	movl	24(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -108(%ebp)
	movl	24(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -104(%ebp)
	movl	24(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -100(%ebp)
	movl	24(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -96(%ebp)
	movl	20(%ebp), %eax
	movzbl	216(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -92(%ebp)
	movl	20(%ebp), %eax
	movzbl	214(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -88(%ebp)
	movl	20(%ebp), %eax
	movl	208(%eax), %eax
	movl	%eax, -84(%ebp)
	movl	20(%ebp), %eax
	addl	$80, %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -80(%ebp)
	movl	20(%ebp), %eax
	addl	$80, %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -76(%ebp)
	movl	20(%ebp), %eax
	addl	$80, %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -72(%ebp)
	movl	20(%ebp), %eax
	addl	$80, %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -68(%ebp)
	movl	20(%ebp), %eax
	addl	$80, %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -64(%ebp)
	movl	20(%ebp), %eax
	addl	$80, %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -60(%ebp)
	movl	20(%ebp), %eax
	addl	$80, %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -56(%ebp)
	movl	20(%ebp), %eax
	addl	$80, %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -52(%ebp)
	movl	20(%ebp), %eax
	movzbl	76(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -48(%ebp)
	movl	20(%ebp), %eax
	movl	72(%eax), %eax
	movl	%eax, -44(%ebp)
	movl	20(%ebp), %eax
	addl	$56, %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -40(%ebp)
	movl	20(%ebp), %eax
	addl	$56, %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -36(%ebp)
	movl	20(%ebp), %eax
	addl	$56, %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -32(%ebp)
	movl	20(%ebp), %eax
	addl	$56, %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -28(%ebp)
	movl	20(%ebp), %eax
	addl	$56, %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -24(%ebp)
	movl	20(%ebp), %eax
	addl	$56, %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -20(%ebp)
	movl	20(%ebp), %eax
	addl	$56, %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -16(%ebp)
	movl	20(%ebp), %eax
	addl	$56, %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%ebx, 120(%esp)
	movl	%esi, 116(%esp)
	movl	%edi, 112(%esp)
	movl	-112(%ebp), %ecx
	movl	%ecx, 108(%esp)
	movl	-108(%ebp), %ecx
	movl	%ecx, 104(%esp)
	movl	-104(%ebp), %ecx
	movl	%ecx, 100(%esp)
	movl	-100(%ebp), %ecx
	movl	%ecx, 96(%esp)
	movl	-96(%ebp), %ecx
	movl	%ecx, 92(%esp)
	movl	-92(%ebp), %ecx
	movl	%ecx, 88(%esp)
	movl	-88(%ebp), %ecx
	movl	%ecx, 84(%esp)
	movl	-84(%ebp), %ecx
	movl	%ecx, 80(%esp)
	movl	-80(%ebp), %ecx
	movl	%ecx, 76(%esp)
	movl	-76(%ebp), %ecx
	movl	%ecx, 72(%esp)
	movl	-72(%ebp), %ecx
	movl	%ecx, 68(%esp)
	movl	-68(%ebp), %ecx
	movl	%ecx, 64(%esp)
	movl	-64(%ebp), %ecx
	movl	%ecx, 60(%esp)
	movl	-60(%ebp), %ecx
	movl	%ecx, 56(%esp)
	movl	-56(%ebp), %ecx
	movl	%ecx, 52(%esp)
	movl	-52(%ebp), %ecx
	movl	%ecx, 48(%esp)
	movl	-48(%ebp), %ecx
	movl	%ecx, 44(%esp)
	movl	-44(%ebp), %ecx
	movl	%ecx, 40(%esp)
	movl	-40(%ebp), %ecx
	movl	%ecx, 36(%esp)
	movl	-36(%ebp), %ecx
	movl	%ecx, 32(%esp)
	movl	-32(%ebp), %ecx
	movl	%ecx, 28(%esp)
	movl	-28(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-24(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-20(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-16(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC34, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	addl	$236, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	xfrm_state_dump, .-xfrm_state_dump
	.section	.rodata
	.align 4
.LC35:
	.string	"daddr %x:%x:%x:%x:%x:%x:%x:%x\nspi %x\nproto %d\nsaddr %x:%x:%x:%x:%x:%x:%x:%x\n"
	.text
	.type	xfrm_state_id_dump, @function
xfrm_state_id_dump:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$140, %esp
	movl	stderr, %edx
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	16(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %ebx
	movl	16(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %esi
	movl	16(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edi
	movl	16(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -68(%ebp)
	movl	16(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -64(%ebp)
	movl	16(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -60(%ebp)
	movl	16(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -56(%ebp)
	movl	16(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -52(%ebp)
	movl	12(%ebp), %eax
	movzbl	22(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -48(%ebp)
	movl	12(%ebp), %eax
	movl	16(%eax), %eax
	movl	%eax, -44(%ebp)
	movl	12(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -40(%ebp)
	movl	12(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -36(%ebp)
	movl	12(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -32(%ebp)
	movl	12(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -28(%ebp)
	movl	12(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -24(%ebp)
	movl	12(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -20(%ebp)
	movl	12(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -16(%ebp)
	movl	12(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%ebx, 76(%esp)
	movl	%esi, 72(%esp)
	movl	%edi, 68(%esp)
	movl	-68(%ebp), %ecx
	movl	%ecx, 64(%esp)
	movl	-64(%ebp), %ecx
	movl	%ecx, 60(%esp)
	movl	-60(%ebp), %ecx
	movl	%ecx, 56(%esp)
	movl	-56(%ebp), %ecx
	movl	%ecx, 52(%esp)
	movl	-52(%ebp), %ecx
	movl	%ecx, 48(%esp)
	movl	-48(%ebp), %ecx
	movl	%ecx, 44(%esp)
	movl	-44(%ebp), %ecx
	movl	%ecx, 40(%esp)
	movl	-40(%ebp), %ecx
	movl	%ecx, 36(%esp)
	movl	-36(%ebp), %ecx
	movl	%ecx, 32(%esp)
	movl	-32(%ebp), %ecx
	movl	%ecx, 28(%esp)
	movl	-28(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-24(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-20(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-16(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC35, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	addl	$140, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	xfrm_state_id_dump, .-xfrm_state_id_dump
	.type	set_selector, @function
set_selector:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$56, 8(%esp)
	movl	$0, 4(%esp)
	movl	32(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	32(%ebp), %eax
	movw	$10, 40(%eax)
	call	getuid
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movl	%edx, 52(%eax)
	movl	32(%ebp), %eax
	movl	$0, 48(%eax)
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movb	%dl, 44(%eax)
	movl	16(%ebp), %eax
	movl	%eax, -4(%ebp)
	cmpl	$58, -4(%ebp)
	je	.L262
	cmpl	$135, -4(%ebp)
	je	.L263
	cmpl	$0, -4(%ebp)
	je	.L264
	jmp	.L275
.L262:
	movl	20(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movw	%dx, 36(%eax)
	cmpl	$0, 20(%ebp)
	je	.L265
	movl	32(%ebp), %eax
	movw	$-1, 38(%eax)
.L265:
	movl	24(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movw	%dx, 32(%eax)
	cmpl	$0, 24(%ebp)
	je	.L264
	movl	32(%ebp), %eax
	movw	$-1, 34(%eax)
	jmp	.L264
.L263:
	movl	20(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movw	%dx, 36(%eax)
	cmpl	$0, 20(%ebp)
	je	.L267
	movl	32(%ebp), %eax
	movw	$-1, 38(%eax)
.L267:
	movl	24(%ebp), %eax
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movw	%dx, 32(%eax)
	cmpl	$0, 24(%ebp)
	je	.L264
	movl	24(%ebp), %eax
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movw	%dx, 34(%eax)
	jmp	.L264
.L275:
	movl	20(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movw	%dx, 36(%eax)
	cmpl	$0, 20(%ebp)
	je	.L269
	movl	32(%ebp), %eax
	movw	$-1, 38(%eax)
.L269:
	movl	24(%ebp), %eax
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movw	%dx, 32(%eax)
	cmpl	$0, 24(%ebp)
	je	.L264
	movl	32(%ebp), %eax
	movw	$-1, 34(%eax)
.L264:
	movl	32(%ebp), %eax
	leal	16(%eax), %edx
	movl	$16, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	32(%ebp), %edx
	movl	$16, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	8(%ebp), %eax
	movl	(%eax), %edx
	movl	$in6addr_any, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	.L270
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %edx
	movl	$in6addr_any+4, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	.L270
	movl	8(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %edx
	movl	$in6addr_any+8, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	.L270
	movl	8(%ebp), %eax
	addl	$12, %eax
	movl	(%eax), %edx
	movl	$in6addr_any+12, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	je	.L271
.L270:
	movl	32(%ebp), %eax
	movb	$-128, 42(%eax)
.L271:
	movl	12(%ebp), %eax
	movl	(%eax), %edx
	movl	$in6addr_any, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	.L272
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %edx
	movl	$in6addr_any+4, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	.L272
	movl	12(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %edx
	movl	$in6addr_any+8, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	jne	.L272
	movl	12(%ebp), %eax
	addl	$12, %eax
	movl	(%eax), %edx
	movl	$in6addr_any+12, %eax
	movl	(%eax), %eax
	cmpl	%eax, %edx
	je	.L274
.L272:
	movl	32(%ebp), %eax
	movb	$-128, 43(%eax)
.L274:
	leave
	ret
	.size	set_selector, .-set_selector
.globl set_v4selector
	.type	set_v4selector, @function
set_v4selector:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$56, 8(%esp)
	movl	$0, 4(%esp)
	movl	32(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	32(%ebp), %eax
	movw	$2, 40(%eax)
	call	getuid
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movl	%edx, 52(%eax)
	movl	32(%ebp), %edx
	movl	28(%ebp), %eax
	movl	%eax, 48(%edx)
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	32(%ebp), %eax
	movb	%dl, 44(%eax)
	movl	32(%ebp), %eax
	leal	16(%eax), %edx
	movl	$4, 8(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	32(%ebp), %eax
	movl	$4, 8(%esp)
	leal	8(%ebp), %edx
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	8(%ebp), %eax
	testl	%eax, %eax
	je	.L277
	movl	32(%ebp), %eax
	movb	$32, 42(%eax)
.L277:
	movl	12(%ebp), %eax
	testl	%eax, %eax
	je	.L279
	movl	32(%ebp), %eax
	movb	$32, 43(%eax)
.L279:
	leave
	ret
	.size	set_v4selector, .-set_v4selector
	.section	.rodata
.LC36:
	.string	"Failed to add policy:\n"
	.text
	.type	xfrm_policy_add, @function
xfrm_policy_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$456, %esp
	movl	8(%ebp), %eax
	movb	%al, -420(%ebp)
	movl	$388, 8(%esp)
	movl	$0, 4(%esp)
	leal	-400(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-400(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$180, (%eax)
	cmpl	$0, 16(%ebp)
	je	.L281
	movl	-12(%ebp), %eax
	movw	$257, 6(%eax)
	movl	-12(%ebp), %eax
	movw	$25, 4(%eax)
	jmp	.L282
.L281:
	movl	-12(%ebp), %eax
	movw	$1025, 6(%eax)
	movl	-12(%ebp), %eax
	movw	$19, 4(%eax)
.L282:
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %edx
	movl	$56, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	-8(%ebp), %eax
	addl	$56, %eax
	movl	%eax, (%esp)
	call	xfrm_lft
	movl	28(%ebp), %edx
	movl	-8(%ebp), %eax
	movl	%edx, 152(%eax)
	movl	20(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 160(%eax)
	movl	24(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 161(%eax)
	movl	-8(%ebp), %eax
	movb	$0, 163(%eax)
	movl	$6, 8(%esp)
	movl	$0, 4(%esp)
	leal	-406(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movzbl	-420(%ebp), %eax
	movb	%al, -406(%ebp)
	movl	$6, 16(%esp)
	leal	-406(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$16, 8(%esp)
	movl	$388, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	cmpl	$0, 36(%ebp)
	jle	.L283
	movl	36(%ebp), %eax
	sall	$6, %eax
	movl	%eax, 16(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$5, 8(%esp)
	movl	$388, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L283:
	movl	$0, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_xfrm_do
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L284
	movl	-12(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %ecx
	movl	-12(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %edx
	movl	36(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 20(%esp)
	leal	-406(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	$.LC36, (%esp)
	call	xfrm_policy_dump
.L284:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	xfrm_policy_add, .-xfrm_policy_add
	.type	xfrm_lft, @function
xfrm_lft:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %eax
	movl	$-1, (%eax)
	movl	$-1, 4(%eax)
	movl	8(%ebp), %eax
	movl	$-1, 16(%eax)
	movl	$-1, 20(%eax)
	movl	8(%ebp), %eax
	movl	$-1, 8(%eax)
	movl	$-1, 12(%eax)
	movl	8(%ebp), %eax
	movl	$-1, 24(%eax)
	movl	$-1, 28(%eax)
	popl	%ebp
	ret
	.size	xfrm_lft, .-xfrm_lft
	.type	rtnl_xfrm_do, @function
rtnl_xfrm_do:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$6, (%esp)
	call	rtnl_do
	leave
	ret
	.size	rtnl_xfrm_do, .-rtnl_xfrm_do
.globl xfrm_mip_policy_add
	.type	xfrm_mip_policy_add, @function
xfrm_mip_policy_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	32(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	xfrm_policy_add
	leave
	ret
	.size	xfrm_mip_policy_add, .-xfrm_mip_policy_add
	.section	.rodata
.LC37:
	.string	"Failed to del policy:\n"
	.text
	.type	xfrm_policy_del, @function
xfrm_policy_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$136, %esp
	movl	8(%ebp), %eax
	movb	%al, -116(%ebp)
	movl	$92, 8(%esp)
	movl	$0, 4(%esp)
	leal	-104(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-104(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$80, (%eax)
	movl	-12(%ebp), %eax
	movw	$1, 6(%eax)
	movl	-12(%ebp), %eax
	movw	$20, 4(%eax)
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %edx
	movl	$56, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 60(%eax)
	movl	$6, 8(%esp)
	movl	$0, 4(%esp)
	leal	-110(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movzbl	-116(%ebp), %eax
	movb	%al, -110(%ebp)
	movl	$6, 16(%esp)
	leal	-110(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$16, 8(%esp)
	movl	$92, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movl	$0, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_xfrm_do
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L293
	leal	-110(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC37, (%esp)
	call	xfrm_policy_id_dump
.L293:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	xfrm_policy_del, .-xfrm_policy_del
.globl xfrm_mip_policy_del
	.type	xfrm_mip_policy_del, @function
xfrm_mip_policy_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$1, (%esp)
	call	xfrm_policy_del
	leave
	ret
	.size	xfrm_mip_policy_del, .-xfrm_mip_policy_del
	.section	.rodata
.LC38:
	.string	"Failed to add state:\n"
	.text
.globl xfrm_state_add
	.type	xfrm_state_add, @function
xfrm_state_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$296, %esp
	movl	24(%ebp), %eax
	movb	%al, -276(%ebp)
	movl	$256, 8(%esp)
	movl	$0, 4(%esp)
	leal	-268(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-268(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$236, (%eax)
	cmpl	$0, 20(%ebp)
	je	.L298
	movl	-12(%ebp), %eax
	movw	$257, 6(%eax)
	movl	-12(%ebp), %eax
	movw	$26, 4(%eax)
	jmp	.L299
.L298:
	movl	-12(%ebp), %eax
	movw	$1025, 6(%eax)
	movl	-12(%ebp), %eax
	movw	$16, 4(%eax)
.L299:
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %edx
	movl	$56, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	8(%ebp), %edx
	movl	-8(%ebp), %eax
	addl	$56, %eax
	movl	$16, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 76(%eax)
	movl	8(%ebp), %eax
	leal	16(%eax), %edx
	movl	-8(%ebp), %eax
	addl	$80, %eax
	movl	$16, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	-8(%ebp), %eax
	addl	$96, %eax
	movl	%eax, (%esp)
	call	xfrm_lft
	movl	-8(%ebp), %eax
	movw	$10, 212(%eax)
	movl	-8(%ebp), %eax
	movb	$2, 214(%eax)
	movl	-8(%ebp), %edx
	movzbl	-276(%ebp), %eax
	movb	%al, 216(%edx)
	movl	$16, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$14, 8(%esp)
	movl	$256, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movl	$0, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_xfrm_do
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L300
	movl	-12(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %edx
	movl	-12(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %ecx
	movl	16(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	$.LC38, (%esp)
	call	xfrm_state_dump
.L300:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	xfrm_state_add, .-xfrm_state_add
	.section	.rodata
.LC39:
	.string	"Failed to del state:\n"
	.text
.globl xfrm_state_del
	.type	xfrm_state_del, @function
xfrm_state_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$104, %esp
	movl	$60, 8(%esp)
	movl	$0, 4(%esp)
	leal	-72(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-72(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$40, (%eax)
	movl	-12(%ebp), %eax
	movw	$1, 6(%eax)
	movl	-12(%ebp), %eax
	movw	$17, 4(%eax)
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	movl	12(%ebp), %eax
	movl	-8(%ebp), %edx
	movl	$16, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	12(%ebp), %eax
	movzwl	40(%eax), %edx
	movl	-8(%ebp), %eax
	movw	%dx, 20(%eax)
	movl	8(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 22(%eax)
	movl	12(%ebp), %eax
	addl	$16, %eax
	movl	$16, 16(%esp)
	movl	%eax, 12(%esp)
	movl	$13, 8(%esp)
	movl	$60, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movl	$0, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_xfrm_do
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L303
	movl	12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, 8(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC39, (%esp)
	call	xfrm_state_id_dump
.L303:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	xfrm_state_del, .-xfrm_state_del
	.section	.rodata
.LC40:
	.string	"rtnl_xfrm_do:\n"
	.align 4
.LC41:
	.string	"Failed (%d) to add state for UDP encapsulation\n"
	.align 4
.LC42:
	.string	"adding xfrm state encap succeed \n"
	.text
.globl xfrm_state_encap_add
	.type	xfrm_state_encap_add, @function
xfrm_state_encap_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4136, %esp
	movl	24(%ebp), %eax
	movb	%al, -4116(%ebp)
	movl	$4096, 8(%esp)
	movl	$0, 4(%esp)
	leal	-4108(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-4108(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	-12(%ebp), %eax
	movl	$236, (%eax)
	cmpl	$0, 20(%ebp)
	je	.L306
	movl	-12(%ebp), %eax
	movw	$257, 6(%eax)
	movl	-12(%ebp), %eax
	movw	$26, 4(%eax)
	jmp	.L307
.L306:
	movl	-12(%ebp), %eax
	movw	$1025, 6(%eax)
	movl	-12(%ebp), %eax
	movw	$16, 4(%eax)
.L307:
	movl	-12(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %edx
	movl	$56, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	28(%ebp), %edx
	movl	-8(%ebp), %eax
	addl	$56, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 76(%eax)
	movl	28(%ebp), %eax
	leal	16(%eax), %edx
	movl	-8(%ebp), %eax
	addl	$80, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	-8(%ebp), %eax
	addl	$96, %eax
	movl	%eax, (%esp)
	call	xfrm_lft
	movl	-8(%ebp), %eax
	movw	$2, 212(%eax)
	movl	-8(%ebp), %eax
	movb	$1, 214(%eax)
	movl	-8(%ebp), %edx
	movzbl	-4116(%ebp), %eax
	movb	%al, 216(%edx)
	movl	$24, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$4, 8(%esp)
	movl	$4096, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	movl	$0, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_xfrm_do
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L308
	movl	$.LC40, (%esp)
	call	perror
	movl	stderr, %edx
	movl	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC41, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_sel_dump
	movl	28(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_sel4_dump
.L308:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$33, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC42, (%esp)
	call	fwrite
	movl	-4(%ebp), %eax
	leave
	ret
	.size	xfrm_state_encap_add, .-xfrm_state_encap_add
	.type	_create_dstopt_tmpl, @function
_create_dstopt_tmpl:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$64, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	8(%ebp), %eax
	movw	$10, 24(%eax)
	movl	8(%ebp), %eax
	movb	$60, 20(%eax)
	movl	20(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 48(%eax)
	movl	8(%ebp), %eax
	movb	$1, 50(%eax)
	movl	8(%ebp), %eax
	movl	$0, 44(%eax)
	cmpl	$0, 12(%ebp)
	je	.L311
	movl	8(%ebp), %edx
	movl	$16, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
.L311:
	cmpl	$0, 16(%ebp)
	je	.L313
	movl	8(%ebp), %eax
	leal	28(%eax), %edx
	movl	$16, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
.L313:
	leave
	ret
	.size	_create_dstopt_tmpl, .-_create_dstopt_tmpl
	.type	_create_rh_tmpl, @function
_create_rh_tmpl:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$64, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	8(%ebp), %eax
	movw	$10, 24(%eax)
	movl	8(%ebp), %eax
	movb	$43, 20(%eax)
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 48(%eax)
	movl	8(%ebp), %eax
	movb	$1, 50(%eax)
	movl	8(%ebp), %eax
	movl	$0, 44(%eax)
	leave
	ret
	.size	_create_rh_tmpl, .-_create_rh_tmpl
	.type	create_rh_tmpl, @function
create_rh_tmpl:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	$2, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_create_rh_tmpl
	leave
	ret
	.size	create_rh_tmpl, .-create_rh_tmpl
	.type	create_udpencaps_tmpl, @function
create_udpencaps_tmpl:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$64, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	8(%ebp), %eax
	movw	$2, 24(%eax)
	movl	8(%ebp), %eax
	movb	$-90, 20(%eax)
	movl	8(%ebp), %eax
	movb	$1, 48(%eax)
	movl	8(%ebp), %eax
	movb	$1, 50(%eax)
	movl	8(%ebp), %eax
	movl	$0, 44(%eax)
	movl	16(%ebp), %eax
	testl	%eax, %eax
	je	.L319
	movl	8(%ebp), %edx
	movl	$4, 8(%esp)
	leal	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
.L319:
	movl	20(%ebp), %eax
	testl	%eax, %eax
	je	.L320
	movl	8(%ebp), %eax
	leal	28(%eax), %edx
	movl	$4, 8(%esp)
	leal	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
.L320:
	movl	$24, 8(%esp)
	movl	$0, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	12(%ebp), %eax
	movw	$4, (%eax)
	movl	$666, (%esp)
	call	htons
	movl	%eax, %edx
	movl	12(%ebp), %eax
	movw	%dx, 2(%eax)
	movl	$666, (%esp)
	call	htons
	movl	%eax, %edx
	movl	12(%ebp), %eax
	movw	%dx, 4(%eax)
	leave
	ret
	.size	create_udpencaps_tmpl, .-create_udpencaps_tmpl
	.section	.rodata
	.align 32
	.type	protolistv6, @object
	.size	protolistv6, 40
protolistv6:
	.long	135
	.long	0
	.long	58
	.long	128
	.long	58
	.long	129
	.long	6
	.long	0
	.long	17
	.long	0
	.align 4
	.type	protolistv4, @object
	.size	protolistv4, 24
protolistv4:
	.long	1
	.long	0
	.long	17
	.long	0
	.long	6
	.long	0
	.align 4
.LC43:
	.string	"--------start---udp---encap-------------\n"
	.align 4
.LC44:
	.string	"adding udp encap state for traffic  failed.\n"
	.align 4
.LC45:
	.string	"adding udp encap policy for v6 traffic failed.\n"
	.align 4
.LC46:
	.string	"adding udp encap policy for v4 traffic failed.\n"
	.text
.globl start_udp_encap
	.type	start_udp_encap, @function
start_udp_encap:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$264, %esp
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$41, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC43, (%esp)
	call	fwrite
	movl	$0, -8(%ebp)
	movl	$0, -212(%ebp)
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 12(%esp)
	movl	20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 8(%esp)
	leal	-208(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-184(%ebp), %eax
	movl	%eax, (%esp)
	call	create_udpencaps_tmpl
	movl	24(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movw	%ax, -206(%ebp)
	movl	28(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movw	%ax, -204(%ebp)
	movl	20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -200(%ebp)
	movl	$56, 8(%esp)
	movl	$0, 4(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-64(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	$in6addr_any, 4(%esp)
	movl	$in6addr_any, (%esp)
	call	set_selector
	leal	-120(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	$166, 8(%esp)
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	set_v4selector
	leal	-120(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	leal	-208(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$166, 4(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_state_encap_add
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L323
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$44, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC44, (%esp)
	call	fwrite
	movl	-8(%ebp), %eax
	movl	%eax, -228(%ebp)
	jmp	.L324
.L323:
	movl	$0, -4(%ebp)
	jmp	.L325
.L328:
	cmpl	$0, 8(%ebp)
	jne	.L326
	movl	-4(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	movl	protolistv6(,%eax,4), %edx
	movl	-4(%ebp), %eax
	movl	protolistv6(,%eax,8), %ecx
	leal	-64(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	$in6addr_any, 4(%esp)
	movl	$in6addr_any, (%esp)
	call	set_selector
	movb	$0, -22(%ebp)
	movb	$0, -21(%ebp)
	jmp	.L327
.L326:
	movl	-4(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	movl	protolistv6(,%eax,4), %edx
	movl	-4(%ebp), %eax
	movl	protolistv6(,%eax,8), %ecx
	leal	-64(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$in6addr_any, (%esp)
	call	set_selector
	movb	$0, -22(%ebp)
	movb	$-128, -21(%ebp)
.L327:
	movl	$1, 24(%esp)
	leal	-184(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$1, 8(%esp)
	movl	$0, 4(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_mip_policy_add
	addl	%eax, -8(%ebp)
	addl	$1, -4(%ebp)
.L325:
	cmpl	$4, -4(%ebp)
	jle	.L328
	cmpl	$0, -8(%ebp)
	jns	.L329
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$47, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC45, (%esp)
	call	fwrite
	jmp	.L330
.L329:
	movl	$0, -4(%ebp)
	jmp	.L331
.L334:
	cmpl	$0, 12(%ebp)
	jne	.L332
	movl	-4(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	movl	protolistv4(,%eax,4), %edx
	movl	-4(%ebp), %eax
	movl	protolistv4(,%eax,8), %ecx
	leal	-64(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	$in6addr_any, 4(%esp)
	movl	$in6addr_any, (%esp)
	call	set_selector
	movw	$2, -24(%ebp)
	movb	$0, -22(%ebp)
	movb	$0, -21(%ebp)
	jmp	.L333
.L332:
	movl	-4(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	movl	protolistv4(,%eax,4), %edx
	movl	-4(%ebp), %eax
	movl	protolistv4(,%eax,8), %ecx
	leal	-64(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	set_v4selector
	movw	$2, -24(%ebp)
	movb	$0, -22(%ebp)
	movb	$32, -21(%ebp)
.L333:
	movl	$1, 24(%esp)
	leal	-184(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$1, 8(%esp)
	movl	$0, 4(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_mip_policy_add
	addl	%eax, -8(%ebp)
	addl	$1, -4(%ebp)
.L331:
	cmpl	$2, -4(%ebp)
	jle	.L334
	cmpl	$0, -8(%ebp)
	jns	.L335
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$47, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC46, (%esp)
	call	fwrite
	jmp	.L330
.L335:
	movl	$0, -228(%ebp)
	jmp	.L324
.L330:
	movl	32(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	stop_udp_encap
	movl	$-1, -228(%ebp)
.L324:
	movl	-228(%ebp), %eax
	leave
	ret
	.size	start_udp_encap, .-start_udp_encap
	.section	.rodata
	.align 4
.LC47:
	.string	"deleting udp traffic encap policy v6 failed.\n"
	.align 4
.LC48:
	.string	"deleting udp traffic encap policy v4 failed.\n"
	.align 4
.LC49:
	.string	"deleting udp encap traffic state failed.\n"
	.text
.globl stop_udp_encap
	.type	stop_udp_encap, @function
stop_udp_encap:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$168, %esp
	movl	$0, -8(%ebp)
	leal	-120(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	$166, 8(%esp)
	movl	16(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	set_v4selector
	movl	$0, -4(%ebp)
	jmp	.L338
.L341:
	cmpl	$0, 8(%ebp)
	jne	.L339
	movl	-4(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	movl	protolistv6(,%eax,4), %edx
	movl	-4(%ebp), %eax
	movl	protolistv6(,%eax,8), %ecx
	leal	-64(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	$in6addr_any, 4(%esp)
	movl	$in6addr_any, (%esp)
	call	set_selector
	movb	$0, -22(%ebp)
	movb	$0, -21(%ebp)
	jmp	.L340
.L339:
	movl	-4(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	movl	protolistv6(,%eax,4), %edx
	movl	-4(%ebp), %eax
	movl	protolistv6(,%eax,8), %ecx
	leal	-64(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$in6addr_any, (%esp)
	call	set_selector
	movb	$0, -22(%ebp)
	movb	$-128, -21(%ebp)
.L340:
	movl	$1, 4(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_mip_policy_del
	addl	%eax, -8(%ebp)
	addl	$1, -4(%ebp)
.L338:
	cmpl	$4, -4(%ebp)
	jle	.L341
	cmpl	$0, -8(%ebp)
	jns	.L342
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$45, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC47, (%esp)
	call	fwrite
.L342:
	movl	$0, -4(%ebp)
	jmp	.L343
.L346:
	cmpl	$0, 12(%ebp)
	jne	.L344
	movl	-4(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	movl	protolistv4(,%eax,4), %edx
	movl	-4(%ebp), %eax
	movl	protolistv4(,%eax,8), %ecx
	leal	-64(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	$in6addr_any, 4(%esp)
	movl	$in6addr_any, (%esp)
	call	set_selector
	movw	$2, -24(%ebp)
	movb	$0, -22(%ebp)
	movb	$0, -21(%ebp)
	jmp	.L345
.L344:
	movl	$0, -124(%ebp)
	movl	-4(%ebp), %eax
	addl	%eax, %eax
	addl	$1, %eax
	movl	protolistv4(,%eax,4), %edx
	movl	-4(%ebp), %eax
	movl	protolistv4(,%eax,8), %ecx
	leal	-64(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, 4(%esp)
	movl	-124(%ebp), %eax
	movl	%eax, (%esp)
	call	set_v4selector
	movw	$2, -24(%ebp)
	movb	$0, -22(%ebp)
	movb	$32, -21(%ebp)
.L345:
	movl	$1, 4(%esp)
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_mip_policy_del
	addl	%eax, -8(%ebp)
	addl	$1, -4(%ebp)
.L343:
	cmpl	$2, -4(%ebp)
	jle	.L346
	cmpl	$0, -8(%ebp)
	jns	.L347
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$45, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC48, (%esp)
	call	fwrite
.L347:
	leal	-120(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$166, (%esp)
	call	xfrm_state_del
	testl	%eax, %eax
	je	.L348
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$41, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC49, (%esp)
	call	fwrite
.L348:
	movl	-8(%ebp), %eax
	leave
	ret
	.size	stop_udp_encap, .-stop_udp_encap
.globl get_ifi
	.type	get_ifi, @function
get_ifi:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$72, %esp
	movl	$0, 8(%esp)
	movl	$2, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, -8(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35111, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	ioctl
	testl	%eax, %eax
	je	.L351
	movl	$1, -52(%ebp)
	jmp	.L352
.L351:
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-40(%ebp), %eax
	addl	$18, %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35093, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	ioctl
	testl	%eax, %eax
	je	.L353
	movl	$1, -52(%ebp)
	jmp	.L352
.L353:
	movl	24(%ebp), %edx
	leal	-40(%ebp), %eax
	addl	$16, %eax
	addl	$4, %eax
	movl	%edx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	20(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	$0, -52(%ebp)
.L352:
	movl	-52(%ebp), %eax
	leave
	ret
	.size	get_ifi, .-get_ifi
	.section	.rodata
	.align 4
.LC50:
	.string	"Peer MAC is: %02x:%02x:%02x:%02x:%02x:%02x\n"
	.text
.globl prmac
	.type	prmac, @function
prmac:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$44, %esp
	movl	8(%ebp), %eax
	addl	$5, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %ebx
	movl	8(%ebp), %eax
	addl	$4, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %esi
	movl	8(%ebp), %eax
	addl	$3, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %edi
	movl	8(%ebp), %eax
	addl	$2, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -16(%ebp)
	movl	8(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %edx
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	stderr, %ecx
	movl	%ebx, 28(%esp)
	movl	%esi, 24(%esp)
	movl	%edi, 20(%esp)
	movl	-16(%ebp), %ebx
	movl	%ebx, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC50, 4(%esp)
	movl	%ecx, (%esp)
	call	fprintf
	addl	$44, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	prmac, .-prmac
	.section	.rodata
.LC51:
	.string	"Socket error"
	.align 4
.LC52:
	.string	"Error: Get host's information failed\n"
.LC53:
	.string	"\377\377\377\377\377\377"
.LC54:
	.string	"Sendto error"
.LC55:
	.string	"Recvfrom error"
.LC56:
	.string	"Peer IP is: %s\n"
	.text
.globl get_mac_by_ip
	.type	get_mac_by_ip, @function
get_mac_by_ip:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$548, %esp
	movl	$20, 4(%esp)
	leal	-196(%ebp), %eax
	movl	%eax, (%esp)
	call	bzero
	movw	$17, -196(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -192(%ebp)
	movl	8(%ebp), %edx
	leal	-376(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	if_indextoname
	movl	$32821, (%esp)
	call	htons
	movzwl	%ax, %eax
	movl	%eax, 8(%esp)
	movl	$3, 4(%esp)
	movl	$17, (%esp)
	call	socket
	movl	%eax, -28(%ebp)
	cmpl	$0, -28(%ebp)
	jns	.L358
	movl	$.LC51, (%esp)
	call	perror
	movl	$1, (%esp)
	call	exit
.L358:
	movl	$60, 4(%esp)
	leal	-276(%ebp), %eax
	movl	%eax, (%esp)
	call	bzero
	movl	$4, 16(%esp)
	leal	-172(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$6, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-376(%ebp), %eax
	movl	%eax, (%esp)
	call	get_ifi
	testl	%eax, %eax
	je	.L359
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$37, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC52, (%esp)
	call	fwrite
	movl	$-1, -520(%ebp)
	jmp	.L360
.L359:
	movl	$6, 8(%esp)
	movl	$.LC53, 4(%esp)
	leal	-276(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	$6, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-276(%ebp), %eax
	addl	$6, %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	$2054, (%esp)
	call	htons
	movw	%ax, -264(%ebp)
	movl	$1, (%esp)
	call	htons
	movw	%ax, -262(%ebp)
	movl	$2048, (%esp)
	call	htons
	movw	%ax, -260(%ebp)
	movb	$6, -258(%ebp)
	movb	$4, -257(%ebp)
	movl	$1, (%esp)
	call	htons
	movw	%ax, -256(%ebp)
	movl	$6, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-276(%ebp), %eax
	addl	$22, %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	$4, 8(%esp)
	leal	-172(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-276(%ebp), %eax
	addl	$28, %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	$4, 8(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-276(%ebp), %eax
	addl	$38, %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	$2054, (%esp)
	call	htons
	movzwl	%ax, %eax
	movl	%eax, 8(%esp)
	movl	$3, 4(%esp)
	movl	$17, (%esp)
	call	socket
	movl	%eax, -24(%ebp)
	leal	-196(%ebp), %eax
	movl	$20, 20(%esp)
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$60, 8(%esp)
	leal	-276(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	sendto
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jg	.L361
	movl	$.LC54, (%esp)
	call	perror
	movl	$-1, -520(%ebp)
	jmp	.L360
.L361:
	movl	$120, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	bzero
	movl	$20, 4(%esp)
	leal	-216(%ebp), %eax
	movl	%eax, (%esp)
	call	bzero
	movl	$20, -32(%ebp)
	leal	-504(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L362
.L363:
	movl	-12(%ebp), %edx
	movl	-8(%ebp), %eax
	movl	$0, (%eax,%edx,4)
	addl	$1, -12(%ebp)
.L362:
	cmpl	$31, -12(%ebp)
	jbe	.L363
	movl	-24(%ebp), %eax
	shrl	$5, %eax
	movl	%eax, %ebx
	movl	-504(%ebp,%eax,4), %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	movl	$1, %eax
	sall	%cl, %eax
	orl	%edx, %eax
	movl	%eax, -504(%ebp,%ebx,4)
	movl	$1, -512(%ebp)
	movl	$0, -508(%ebp)
	movl	$0, -16(%ebp)
.L367:
	movl	-24(%ebp), %eax
	leal	1(%eax), %edx
	leal	-512(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	leal	-504(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	select
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jg	.L364
	movl	$-1, -520(%ebp)
	jmp	.L360
.L364:
	leal	-32(%ebp), %eax
	leal	-216(%ebp), %edx
	movl	%eax, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$0, 12(%esp)
	movl	$60, 8(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	recvfrom
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jg	.L365
	movl	$.LC55, (%esp)
	call	perror
	movl	$-1, -520(%ebp)
	jmp	.L360
.L365:
	leal	-152(%ebp), %eax
	addl	$20, %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	cmpw	$2, %ax
	jne	.L367
	movl	$4, 8(%esp)
	leal	-152(%ebp), %eax
	addl	$28, %eax
	movl	%eax, 4(%esp)
	leal	-276(%ebp), %eax
	addl	$38, %eax
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L367
	movl	$1024, 12(%esp)
	leal	-168(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-152(%ebp), %eax
	addl	$28, %eax
	movl	%eax, 4(%esp)
	movl	$2, (%esp)
	call	inet_ntop
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC56, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$6, 8(%esp)
	leal	-152(%ebp), %eax
	addl	$22, %eax
	movl	%eax, 4(%esp)
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	prmac
	jmp	.L357
.L360:
	movl	-520(%ebp), %eax
	movl	%eax, -524(%ebp)
.L357:
	movl	-524(%ebp), %eax
	addl	$548, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	get_mac_by_ip, .-get_mac_by_ip
.globl dhcp_options
	.data
	.align 32
	.type	dhcp_options, @object
	.size	dhcp_options, 324
dhcp_options:
	.string	"subnet"
	.zero	3
	.byte	17
	.byte	1
	.string	"timezone"
	.zero	1
	.byte	9
	.byte	2
	.string	"router"
	.zero	3
	.byte	49
	.byte	3
	.string	"timesvr"
	.zero	2
	.byte	33
	.byte	4
	.string	"namesvr"
	.zero	2
	.byte	33
	.byte	5
	.string	"dns"
	.zero	6
	.byte	49
	.byte	6
	.string	"logsvr"
	.zero	3
	.byte	33
	.byte	7
	.string	"cookiesvr"
	.byte	33
	.byte	8
	.string	"lprsvr"
	.zero	3
	.byte	33
	.byte	9
	.string	"hostname"
	.zero	1
	.byte	19
	.byte	12
	.string	"bootsize"
	.zero	1
	.byte	6
	.byte	13
	.string	"domain"
	.zero	3
	.byte	19
	.byte	15
	.string	"swapsvr"
	.zero	2
	.byte	1
	.byte	16
	.string	"rootpath"
	.zero	1
	.byte	3
	.byte	17
	.string	"ipttl"
	.zero	4
	.byte	5
	.byte	23
	.string	"mtu"
	.zero	6
	.byte	6
	.byte	26
	.string	"broadcast"
	.byte	17
	.byte	28
	.string	"ntpsrv"
	.zero	3
	.byte	33
	.byte	42
	.string	"wins"
	.zero	5
	.byte	33
	.byte	44
	.string	"requestip"
	.byte	1
	.byte	50
	.string	"lease"
	.zero	4
	.byte	8
	.byte	51
	.string	"dhcptype"
	.zero	1
	.byte	5
	.byte	53
	.string	"serverid"
	.zero	1
	.byte	1
	.byte	54
	.string	"message"
	.zero	2
	.byte	3
	.byte	56
	.string	"tftp"
	.zero	5
	.byte	3
	.byte	66
	.string	"bootfile"
	.zero	1
	.byte	3
	.byte	67
	.string	""
	.zero	9
	.byte	0
	.byte	0
.globl dhcp_option_lengths
	.align 32
	.type	dhcp_option_lengths, @object
	.size	dhcp_option_lengths, 40
dhcp_option_lengths:
	.zero	4
	.long	4
	.long	8
	.long	1
	.long	1
	.long	1
	.long	2
	.long	2
	.long	4
	.long	4
	.text
.globl checksum
	.type	checksum, @function
checksum:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	$0, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -4(%ebp)
	jmp	.L370
.L371:
	movl	-4(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	addl	%eax, -20(%ebp)
	addl	$2, -4(%ebp)
	subl	$2, 12(%ebp)
.L370:
	cmpl	$1, 12(%ebp)
	jg	.L371
	cmpl	$0, 12(%ebp)
	jle	.L373
	movw	$0, -6(%ebp)
	leal	-6(%ebp), %edx
	movl	-4(%ebp), %eax
	movzbl	(%eax), %eax
	movb	%al, (%edx)
	movzwl	-6(%ebp), %eax
	movzwl	%ax, %eax
	addl	%eax, -20(%ebp)
	jmp	.L373
.L374:
	movzwl	-20(%ebp),%edx
	movl	-20(%ebp), %eax
	sarl	$16, %eax
	addl	%eax, %edx
	movl	%edx, -20(%ebp)
.L373:
	movl	-20(%ebp), %eax
	sarl	$16, %eax
	testl	%eax, %eax
	jne	.L374
	movzwl	-20(%ebp), %eax
	notl	%eax
	leave
	ret
	.size	checksum, .-checksum
	.section	.rodata
	.align 4
.LC57:
	.string	"dhcp_dna: socket call failed: %s\n"
	.align 4
.LC58:
	.string	"dhcp_dna: bind call failed: %s\n"
	.align 4
.LC59:
	.string	"dhcp_dna: write on socket failed: %s\n"
	.text
.globl raw_packet
	.type	raw_packet, @function
raw_packet:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$648, %esp
	movl	$2048, (%esp)
	call	htons
	movzwl	%ax, %eax
	movl	%eax, 8(%esp)
	movl	$2, 4(%esp)
	movl	$17, (%esp)
	call	socket
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L377
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC57, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -612(%ebp)
	jmp	.L378
.L377:
	movl	$20, 8(%esp)
	movl	$0, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$576, 8(%esp)
	movl	$0, 4(%esp)
	leal	-604(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movw	$17, -28(%ebp)
	movl	$2048, (%esp)
	call	htons
	movw	%ax, -26(%ebp)
	movl	32(%ebp), %eax
	movl	%eax, -24(%ebp)
	movb	$6, -17(%ebp)
	movl	$6, 8(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-28(%ebp), %eax
	addl	$12, %eax
	movl	%eax, (%esp)
	call	memcpy
	leal	-28(%ebp), %eax
	movl	$20, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	bind
	testl	%eax, %eax
	jns	.L379
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC58, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-1, -612(%ebp)
	jmp	.L378
.L379:
	movb	$17, -595(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -592(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -588(%ebp)
	movl	16(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movw	%ax, -584(%ebp)
	movl	24(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movw	%ax, -582(%ebp)
	movl	$556, (%esp)
	call	htons
	movw	%ax, -580(%ebp)
	movzwl	-580(%ebp), %eax
	movw	%ax, -602(%ebp)
	movl	$548, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-604(%ebp), %eax
	addl	$28, %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	$576, 4(%esp)
	leal	-604(%ebp), %eax
	movl	%eax, (%esp)
	call	checksum
	movw	%ax, -578(%ebp)
	movl	$576, (%esp)
	call	htons
	movw	%ax, -602(%ebp)
	movzbl	-604(%ebp), %eax
	andl	$-16, %eax
	orl	$5, %eax
	movb	%al, -604(%ebp)
	movzbl	-604(%ebp), %eax
	andl	$15, %eax
	orl	$64, %eax
	movb	%al, -604(%ebp)
	movb	$64, -596(%ebp)
	movl	$20, 4(%esp)
	leal	-604(%ebp), %eax
	movl	%eax, (%esp)
	call	checksum
	movw	%ax, -594(%ebp)
	leal	-28(%ebp), %eax
	movl	$20, 20(%esp)
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$576, 8(%esp)
	leal	-604(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	sendto
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jg	.L380
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC59, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
.L380:
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-4(%ebp), %eax
	movl	%eax, -612(%ebp)
.L378:
	movl	-612(%ebp), %eax
	leave
	ret
	.size	raw_packet, .-raw_packet
.globl kernel_packet
	.type	kernel_packet, @function
kernel_packet:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$1, -12(%ebp)
	movl	$17, 8(%esp)
	movl	$2, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L383
	movl	$-1, -36(%ebp)
	jmp	.L384
.L383:
	movl	$4, 16(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$1, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	cmpl	$-1, %eax
	jne	.L385
	movl	$-1, -36(%ebp)
	jmp	.L384
.L385:
	movl	$16, 8(%esp)
	movl	$0, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movw	$2, -28(%ebp)
	movl	16(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movw	%ax, -26(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -24(%ebp)
	leal	-28(%ebp), %eax
	movl	$16, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	bind
	cmpl	$-1, %eax
	jne	.L386
	movl	$-1, -36(%ebp)
	jmp	.L384
.L386:
	movl	$16, 8(%esp)
	movl	$0, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movw	$2, -28(%ebp)
	movl	24(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movw	%ax, -26(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -24(%ebp)
	leal	-28(%ebp), %eax
	movl	$16, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	connect
	cmpl	$-1, %eax
	jne	.L387
	movl	$-1, -36(%ebp)
	jmp	.L384
.L387:
	movl	$548, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	write
	movl	%eax, -4(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-4(%ebp), %eax
	movl	%eax, -36(%ebp)
.L384:
	movl	-36(%ebp), %eax
	leave
	ret
	.size	kernel_packet, .-kernel_packet
	.local	initialized.8044
	.comm	initialized.8044,4,4
	.section	.rodata
.LC60:
	.string	"/dev/urandom"
	.align 4
.LC61:
	.string	"dhcp_dna: could not load seed from /dev/urandom: %s\n"
	.text
.globl random_xid
	.type	random_xid, @function
random_xid:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	initialized.8044, %eax
	testl	%eax, %eax
	jne	.L390
	movl	$0, 4(%esp)
	movl	$.LC60, (%esp)
	call	open
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	js	.L391
	movl	$4, 8(%esp)
	leal	-8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	read
	testl	%eax, %eax
	jns	.L392
.L391:
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC61, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$0, (%esp)
	call	time
	movl	%eax, -8(%ebp)
.L392:
	cmpl	$0, -4(%ebp)
	js	.L393
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	close
.L393:
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	srand
	movl	initialized.8044, %eax
	addl	$1, %eax
	movl	%eax, initialized.8044
.L390:
	call	rand
	leave
	ret
	.size	random_xid, .-random_xid
	.section	.rodata
	.align 4
.LC62:
	.string	"dhcp_dna: bogus packet, option fields too long.\n"
	.text
.globl get_option
	.type	get_option, @function
get_option:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$0, -12(%ebp)
	movl	$0, -8(%ebp)
	movl	$0, -4(%ebp)
	movl	8(%ebp), %eax
	addl	$240, %eax
	movl	%eax, -16(%ebp)
	movl	$0, -24(%ebp)
	movl	$308, -20(%ebp)
	jmp	.L396
.L409:
	movl	-24(%ebp), %eax
	cmpl	-20(%ebp), %eax
	jl	.L397
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$48, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC62, (%esp)
	call	fwrite
	movl	$0, -40(%ebp)
	jmp	.L398
.L397:
	movl	-24(%ebp), %eax
	addl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	cmpl	12(%ebp), %eax
	jne	.L399
	movl	-24(%ebp), %eax
	leal	1(%eax), %edx
	movl	-24(%ebp), %eax
	addl	$1, %eax
	addl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	leal	(%edx,%eax), %eax
	cmpl	-20(%ebp), %eax
	jl	.L400
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$48, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC62, (%esp)
	call	fwrite
	movl	$0, -40(%ebp)
	jmp	.L398
.L400:
	movl	-24(%ebp), %eax
	addl	$2, %eax
	movl	-16(%ebp), %edx
	addl	%eax, %edx
	movl	%edx, -40(%ebp)
	jmp	.L398
.L399:
	movl	-24(%ebp), %eax
	addl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -36(%ebp)
	cmpl	$52, -36(%ebp)
	je	.L403
	cmpl	$255, -36(%ebp)
	je	.L404
	cmpl	$0, -36(%ebp)
	jne	.L411
.L402:
	addl	$1, -24(%ebp)
	jmp	.L396
.L403:
	movl	-24(%ebp), %eax
	leal	1(%eax), %edx
	movl	-24(%ebp), %eax
	addl	$1, %eax
	addl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	leal	(%edx,%eax), %eax
	cmpl	-20(%ebp), %eax
	jl	.L405
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$48, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC62, (%esp)
	call	fwrite
	movl	$0, -40(%ebp)
	jmp	.L398
.L405:
	movl	-24(%ebp), %eax
	addl	$3, %eax
	addl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -12(%ebp)
	movl	-16(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	$2, %eax
	addl	%eax, -24(%ebp)
	jmp	.L396
.L404:
	cmpl	$0, -4(%ebp)
	jne	.L406
	movl	-12(%ebp), %eax
	andl	$1, %eax
	xorl	$1, %eax
	testb	%al, %al
	jne	.L406
	movl	8(%ebp), %eax
	addl	$108, %eax
	movl	%eax, -16(%ebp)
	movl	$0, -24(%ebp)
	movl	$128, -20(%ebp)
	movl	$1, -4(%ebp)
	jmp	.L396
.L406:
	cmpl	$1, -4(%ebp)
	jne	.L408
	movl	-12(%ebp), %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L408
	movl	8(%ebp), %eax
	addl	$44, %eax
	movl	%eax, -16(%ebp)
	movl	$0, -24(%ebp)
	movl	$64, -20(%ebp)
	movl	$2, -4(%ebp)
	jmp	.L396
.L408:
	movl	$1, -8(%ebp)
	jmp	.L396
.L411:
	movl	-24(%ebp), %eax
	addl	$1, %eax
	addl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	$2, %eax
	addl	%eax, -24(%ebp)
.L396:
	cmpl	$0, -8(%ebp)
	je	.L409
	movl	$0, -40(%ebp)
.L398:
	movl	-40(%ebp), %eax
	leave
	ret
	.size	get_option, .-get_option
.globl end_option
	.type	end_option, @function
end_option:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$16, %esp
	movl	$0, -4(%ebp)
	jmp	.L413
.L415:
	movl	-4(%ebp), %eax
	addl	8(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	jne	.L414
	addl	$1, -4(%ebp)
	jmp	.L413
.L414:
	movl	-4(%ebp), %eax
	addl	$1, %eax
	addl	8(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	$2, %eax
	addl	%eax, -4(%ebp)
.L413:
	movl	-4(%ebp), %eax
	addl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$-1, %al
	jne	.L415
	movl	-4(%ebp), %eax
	leave
	ret
	.size	end_option, .-end_option
	.section	.rodata
	.align 4
.LC63:
	.string	"dhcp_dna: Option 0x%02x did not fit into the packet!\n"
	.text
.globl add_option_string
	.type	add_option_string, @function
add_option_string:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	end_option
	movl	%eax, -4(%ebp)
	movl	12(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	-4(%ebp), %eax
	addl	$3, %eax
	cmpl	$307, %eax
	jle	.L418
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC63, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$0, -20(%ebp)
	jmp	.L419
.L418:
	movl	12(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	$2, %eax
	movl	%eax, %edx
	movl	-4(%ebp), %eax
	movl	%eax, %ecx
	addl	8(%ebp), %ecx
	movl	%edx, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	memcpy
	movl	12(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	-4(%ebp), %eax
	addl	$2, %eax
	addl	8(%ebp), %eax
	movb	$-1, (%eax)
	movl	12(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	addl	$2, %eax
	movl	%eax, -20(%ebp)
.L419:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	add_option_string, .-add_option_string
	.section	.rodata
	.align 4
.LC64:
	.string	"dhcp_dna: could not add option 0x%02x\n"
	.text
.globl add_simple_option
	.type	add_simple_option, @function
add_simple_option:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	12(%ebp), %eax
	movb	%al, -36(%ebp)
	movb	$0, -17(%ebp)
	leal	-28(%ebp), %eax
	movl	%eax, -12(%ebp)
	leal	-28(%ebp), %eax
	movl	%eax, -8(%ebp)
	leal	-28(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	$0, -16(%ebp)
	jmp	.L422
.L424:
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movzbl	dhcp_options+11(%eax), %eax
	cmpb	-36(%ebp), %al
	jne	.L423
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movzbl	dhcp_options+10(%eax), %eax
	movsbl	%al,%eax
	andl	$15, %eax
	movl	dhcp_option_lengths(,%eax,4), %eax
	movb	%al, -17(%ebp)
.L423:
	addl	$1, -16(%ebp)
.L422:
	movl	-16(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movzbl	dhcp_options+11(%eax), %eax
	testb	%al, %al
	jne	.L424
	cmpb	$0, -17(%ebp)
	jne	.L425
	movzbl	-36(%ebp), %eax
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC64, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$0, -44(%ebp)
	jmp	.L426
.L425:
	movzbl	-36(%ebp), %eax
	movb	%al, -23(%ebp)
	movzbl	-17(%ebp), %eax
	movb	%al, -22(%ebp)
	movsbl	-17(%ebp),%eax
	movl	%eax, -40(%ebp)
	cmpl	$2, -40(%ebp)
	je	.L429
	cmpl	$4, -40(%ebp)
	je	.L430
	cmpl	$1, -40(%ebp)
	jne	.L427
.L428:
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	-12(%ebp), %eax
	movb	%dl, (%eax)
	jmp	.L427
.L429:
	movl	16(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movw	%dx, (%eax)
	jmp	.L427
.L430:
	movl	-4(%ebp), %edx
	movl	16(%ebp), %eax
	movl	%eax, (%edx)
.L427:
	movsbl	-17(%ebp),%eax
	movl	%eax, 8(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-23(%ebp), %eax
	addl	$2, %eax
	movl	%eax, (%esp)
	call	memcpy
	leal	-23(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	add_option_string
	movl	%eax, -44(%ebp)
.L426:
	movl	-44(%ebp), %eax
	leave
	ret
	.size	add_simple_option, .-add_simple_option
.globl init_header
	.type	init_header, @function
init_header:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movb	%al, -4(%ebp)
	movl	$548, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movsbl	-4(%ebp),%eax
	movl	%eax, -8(%ebp)
	cmpl	$8, -8(%ebp)
	ja	.L433
	movl	$1, %eax
	movl	%eax, %edx
	movzbl	-8(%ebp), %ecx
	sall	%cl, %edx
	movl	%edx, -12(%ebp)
	movl	-12(%ebp), %eax
	andl	$394, %eax
	testl	%eax, %eax
	jne	.L434
	movl	-12(%ebp), %eax
	andl	$100, %eax
	testl	%eax, %eax
	jne	.L435
	jmp	.L433
.L434:
	movl	8(%ebp), %eax
	movb	$1, (%eax)
	jmp	.L433
.L435:
	movl	8(%ebp), %eax
	movb	$2, (%eax)
.L433:
	movl	8(%ebp), %eax
	movb	$1, 1(%eax)
	movl	8(%ebp), %eax
	movb	$6, 2(%eax)
	movl	$1669485411, (%esp)
	call	htonl
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 236(%eax)
	movl	8(%ebp), %eax
	movb	$-1, 240(%eax)
	movsbl	-4(%ebp),%edx
	movl	8(%ebp), %eax
	addl	$240, %eax
	movl	%edx, 8(%esp)
	movl	$53, 4(%esp)
	movl	%eax, (%esp)
	call	add_simple_option
	leave
	ret
	.size	init_header, .-init_header
	.type	add_requests, @function
add_requests:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	8(%ebp), %eax
	addl	$240, %eax
	movl	%eax, (%esp)
	call	end_option
	movl	%eax, -12(%ebp)
	movl	$0, -4(%ebp)
	movl	-12(%ebp), %edx
	movl	8(%ebp), %eax
	movb	$55, 240(%eax,%edx)
	movl	$0, -8(%ebp)
	jmp	.L438
.L440:
	movl	-8(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movzbl	dhcp_options+10(%eax), %eax
	movsbl	%al,%eax
	andl	$16, %eax
	testl	%eax, %eax
	je	.L439
	movl	-12(%ebp), %eax
	addl	$2, %eax
	movl	%eax, %ecx
	addl	-4(%ebp), %ecx
	movl	-8(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movzbl	dhcp_options+11(%eax), %edx
	movl	8(%ebp), %eax
	movb	%dl, 240(%eax,%ecx)
	addl	$1, -4(%ebp)
.L439:
	addl	$1, -8(%ebp)
.L438:
	movl	-8(%ebp), %edx
	movl	%edx, %eax
	addl	%eax, %eax
	addl	%edx, %eax
	sall	$2, %eax
	movzbl	dhcp_options+11(%eax), %eax
	testb	%al, %al
	jne	.L440
	movl	-12(%ebp), %eax
	leal	1(%eax), %ecx
	movl	-4(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movb	%dl, 240(%eax,%ecx)
	movl	-12(%ebp), %eax
	addl	$2, %eax
	movl	%eax, %edx
	addl	-4(%ebp), %edx
	movl	8(%ebp), %eax
	movb	$-1, 240(%eax,%edx)
	leave
	ret
	.size	add_requests, .-add_requests
	.type	init_packet, @function
init_packet:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	16(%ebp), %eax
	movb	%al, -36(%ebp)
	movb	$60, -11(%ebp)
	movb	$8, -10(%ebp)
	movl	$1885957493, -9(%ebp)
	movl	$875442208, -5(%ebp)
	movb	$0, -1(%ebp)
	movb	$61, -20(%ebp)
	movb	$7, -19(%ebp)
	movb	$1, -18(%ebp)
	movl	$6, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-20(%ebp), %eax
	addl	$3, %eax
	movl	%eax, (%esp)
	call	memcpy
	movsbl	-36(%ebp),%eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	init_header
	movl	12(%ebp), %eax
	leal	28(%eax), %edx
	movl	$6, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	leal	-20(%ebp), %edx
	movl	12(%ebp), %eax
	addl	$240, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	add_option_string
	leal	-11(%ebp), %edx
	movl	12(%ebp), %eax
	addl	$240, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	add_option_string
	leave
	ret
	.size	init_packet, .-init_packet
	.section	.rodata
.LC65:
	.string	"dhcp_dna: raw_socket called\n"
	.align 4
.LC66:
	.string	"dhcp_dna: socket call failed: %s"
	.align 4
.LC67:
	.string	"dhcp_dna: bind call failed: %s"
	.text
.globl raw_socket
	.type	raw_socket, @function
raw_socket:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$28, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC65, (%esp)
	call	fwrite
	movl	$2048, (%esp)
	call	htons
	movzwl	%ax, %eax
	movl	%eax, 8(%esp)
	movl	$2, 4(%esp)
	movl	$17, (%esp)
	call	socket
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L445
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC66, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -36(%ebp)
	jmp	.L446
.L445:
	movw	$17, -24(%ebp)
	movl	$2048, (%esp)
	call	htons
	movw	%ax, -22(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -20(%ebp)
	leal	-24(%ebp), %eax
	movl	$20, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	bind
	testl	%eax, %eax
	jns	.L447
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC67, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-1, -36(%ebp)
	jmp	.L446
.L447:
	movl	-4(%ebp), %eax
	movl	%eax, -36(%ebp)
.L446:
	movl	-36(%ebp), %eax
	leave
	ret
	.size	raw_socket, .-raw_socket
	.section	.rodata
	.align 4
.LC68:
	.string	"dhcp_dna: kernel_socket called\n"
	.align 4
.LC69:
	.string	"dhcp_dna: Opening listen socket on 0x%08x:%d %s\n"
	.text
.globl kernel_socket
	.type	kernel_socket, @function
kernel_socket:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$88, %esp
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$31, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC68, (%esp)
	call	fwrite
	movl	$1, -56(%ebp)
	movl	stderr, %edx
	movl	16(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC69, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$17, 8(%esp)
	movl	$2, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L450
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC66, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -68(%ebp)
	jmp	.L451
.L450:
	movl	$16, 8(%esp)
	movl	$0, 4(%esp)
	leal	-52(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movw	$2, -52(%ebp)
	movl	12(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movw	%ax, -50(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -48(%ebp)
	movl	$4, 16(%esp)
	leal	-56(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$1, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	cmpl	$-1, %eax
	jne	.L452
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-1, -68(%ebp)
	jmp	.L451
.L452:
	movl	$4, 16(%esp)
	leal	-56(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$6, 8(%esp)
	movl	$1, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	cmpl	$-1, %eax
	jne	.L453
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-1, -68(%ebp)
	jmp	.L451
.L453:
	movl	$16, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	strncpy
	movl	$32, 16(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$25, 8(%esp)
	movl	$1, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L454
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-1, -68(%ebp)
	jmp	.L451
.L454:
	leal	-52(%ebp), %eax
	movl	$16, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	bind
	cmpl	$-1, %eax
	jne	.L455
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-1, -68(%ebp)
	jmp	.L451
.L455:
	movl	-4(%ebp), %eax
	movl	%eax, -68(%ebp)
.L451:
	movl	-68(%ebp), %eax
	leave
	ret
	.size	kernel_socket, .-kernel_socket
	.section	.rodata
	.align 4
.LC70:
	.string	"dhcp_dna: SIOCGIFINDEX failed!: %s"
	.align 4
.LC71:
	.string	"dhcp_dna: adapter hardware address %02x:%02x:%02x:%02x:%02x:%02x\n"
.LC72:
	.string	"SIOCGIFHWADDR failed!: %s"
.LC73:
	.string	"dhcp_dna: socket failed!: %s"
	.text
.globl read_interface_hwaddr
	.type	read_interface_hwaddr, @function
read_interface_hwaddr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$92, %esp
	movl	$32, 8(%esp)
	movl	$0, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$255, 8(%esp)
	movl	$3, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	js	.L458
	movw	$2, -32(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	leal	-48(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35123, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	ioctl
	testl	%eax, %eax
	je	.L459
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC70, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -68(%ebp)
	jmp	.L460
.L459:
	leal	-48(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35111, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	ioctl
	testl	%eax, %eax
	jne	.L461
	movl	$6, 8(%esp)
	leal	-48(%ebp), %eax
	addl	$18, %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	12(%ebp), %eax
	addl	$5, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %ebx
	movl	12(%ebp), %eax
	addl	$4, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %esi
	movl	12(%ebp), %eax
	addl	$3, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %edi
	movl	12(%ebp), %eax
	addl	$2, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	%eax, -64(%ebp)
	movl	12(%ebp), %eax
	addl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %edx
	movl	12(%ebp), %eax
	movzbl	(%eax), %eax
	movzbl	%al, %eax
	movl	stderr, %ecx
	movl	%ebx, 28(%esp)
	movl	%esi, 24(%esp)
	movl	%edi, 20(%esp)
	movl	-64(%ebp), %ebx
	movl	%ebx, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC71, 4(%esp)
	movl	%ecx, (%esp)
	call	fprintf
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$0, -68(%ebp)
	jmp	.L460
.L461:
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC72, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -68(%ebp)
	jmp	.L460
.L458:
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC73, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -68(%ebp)
.L460:
	movl	-68(%ebp), %eax
	addl	$92, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	read_interface_hwaddr, .-read_interface_hwaddr
	.section	.rodata
	.align 4
.LC74:
	.string	"dhcp_dna: couldn't read on raw listening socket, ignoring\n"
	.align 4
.LC75:
	.string	"dhcp_dna: message too short, ignoring\n"
.LC76:
	.string	"dhcp_dna: truncated packet\n"
	.align 4
.LC77:
	.string	"dhcp_dna: DHCP packet received\n"
	.text
.globl get_raw_packet
	.type	get_raw_packet, @function
get_raw_packet:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$612, %esp
	movl	$576, 8(%esp)
	movl	$0, 4(%esp)
	leal	-596(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$576, 8(%esp)
	leal	-596(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	read
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jns	.L464
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$58, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC74, (%esp)
	call	fwrite
	movl	$500000, (%esp)
	call	usleep
	movl	$-1, -600(%ebp)
	jmp	.L465
.L464:
	cmpl	$27, -20(%ebp)
	jg	.L466
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$38, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC75, (%esp)
	call	fwrite
	movl	$-2, -600(%ebp)
	jmp	.L465
.L466:
	movzwl	-594(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	cmpl	-20(%ebp), %eax
	jle	.L467
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$27, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC76, (%esp)
	call	fwrite
	movl	$-2, -600(%ebp)
	jmp	.L465
.L467:
	movzwl	-594(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -20(%ebp)
	movzbl	-587(%ebp), %eax
	cmpb	$17, %al
	jne	.L468
	movzbl	-596(%ebp), %eax
	andl	$-16, %eax
	cmpb	$64, %al
	jne	.L468
	movzbl	-596(%ebp), %eax
	andl	$15, %eax
	cmpb	$5, %al
	jne	.L468
	movzwl	-574(%ebp), %ebx
	movl	$68, (%esp)
	call	htons
	cmpw	%ax, %bx
	jne	.L468
	cmpl	$576, -20(%ebp)
	jg	.L468
	movzwl	-572(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edx
	movl	-20(%ebp), %eax
	subl	$20, %eax
	cwtl
	cmpl	%eax, %edx
	je	.L469
.L468:
	movl	$-2, -600(%ebp)
	jmp	.L465
.L469:
	movzwl	-586(%ebp), %eax
	movw	%ax, -6(%ebp)
	movw	$0, -586(%ebp)
	movl	$20, 4(%esp)
	leal	-596(%ebp), %eax
	movl	%eax, (%esp)
	call	checksum
	cmpw	-6(%ebp), %ax
	je	.L470
	movl	$-1, -600(%ebp)
	jmp	.L465
.L470:
	movl	-584(%ebp), %eax
	movl	%eax, -16(%ebp)
	movl	-580(%ebp), %eax
	movl	%eax, -12(%ebp)
	movzwl	-570(%ebp), %eax
	movw	%ax, -6(%ebp)
	movw	$0, -570(%ebp)
	movl	$20, 8(%esp)
	movl	$0, 4(%esp)
	leal	-596(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movb	$17, -587(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, -584(%ebp)
	movl	-12(%ebp), %eax
	movl	%eax, -580(%ebp)
	movzwl	-572(%ebp), %eax
	movw	%ax, -594(%ebp)
	cmpw	$0, -6(%ebp)
	je	.L471
	movl	-20(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-596(%ebp), %eax
	movl	%eax, (%esp)
	call	checksum
	cmpw	-6(%ebp), %ax
	je	.L471
	movl	$-2, -600(%ebp)
	jmp	.L465
.L471:
	movl	-20(%ebp), %eax
	subl	$28, %eax
	movl	%eax, 8(%esp)
	leal	-596(%ebp), %eax
	addl	$28, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	8(%ebp), %eax
	movl	236(%eax), %eax
	movl	%eax, (%esp)
	call	ntohl
	cmpl	$1669485411, %eax
	je	.L472
	movl	$-2, -600(%ebp)
	jmp	.L465
.L472:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$31, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC77, (%esp)
	call	fwrite
	movl	-20(%ebp), %eax
	subl	$28, %eax
	movl	%eax, -600(%ebp)
.L465:
	movl	-600(%ebp), %eax
	addl	$612, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	get_raw_packet, .-get_raw_packet
	.section	.rodata
	.type	broken_vendors.8499, @object
	.size	broken_vendors.8499, 16
broken_vendors.8499:
	.string	"MSFT 98"
	.string	""
	.zero	7
.LC78:
	.string	"get_packet called\n"
	.align 4
.LC79:
	.string	"dhcp_dna: couldn't read on listening socket, ignoring\n"
	.align 4
.LC80:
	.string	"dhcp_dna: broken client (%s), forcing broadcast\n"
	.text
.globl get_packet
	.type	get_packet, @function
get_packet:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$36, %esp
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$18, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC78, (%esp)
	call	fwrite
	movl	$548, 8(%esp)
	movl	$0, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$548, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	read
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jns	.L475
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$54, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC79, (%esp)
	call	fwrite
	movl	$-1, -24(%ebp)
	jmp	.L476
.L475:
	movl	8(%ebp), %eax
	movl	236(%eax), %eax
	movl	%eax, (%esp)
	call	ntohl
	cmpl	$1669485411, %eax
	je	.L477
	movl	$-2, -24(%ebp)
	jmp	.L476
.L477:
	movl	8(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$1, %al
	jne	.L478
	movl	$60, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	je	.L478
	movl	$0, -12(%ebp)
	jmp	.L479
.L481:
	movl	-8(%ebp), %eax
	subl	$1, %eax
	movzbl	(%eax), %ebx
	movl	$broken_vendors.8499, %edx
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	(%edx,%eax), %eax
	movl	%eax, (%esp)
	call	strlen
	cmpb	%al, %bl
	jne	.L480
	movl	-8(%ebp), %eax
	subl	$1, %eax
	movzbl	(%eax), %eax
	movzbl	%al, %ecx
	movl	$broken_vendors.8499, %edx
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	(%edx,%eax), %eax
	movl	-8(%ebp), %edx
	movl	%ecx, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	strncmp
	testl	%eax, %eax
	jne	.L480
	movl	$broken_vendors.8499, %edx
	movl	-12(%ebp), %eax
	sall	$3, %eax
	leal	(%edx,%eax), %eax
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC80, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	8(%ebp), %eax
	movzwl	10(%eax), %ebx
	movl	$32768, (%esp)
	call	htons
	movl	%ebx, %edx
	orl	%eax, %edx
	movl	8(%ebp), %eax
	movw	%dx, 10(%eax)
.L480:
	addl	$1, -12(%ebp)
.L479:
	movl	-12(%ebp), %eax
	movzbl	broken_vendors.8499(,%eax,8), %eax
	testb	%al, %al
	jne	.L481
.L478:
	movl	-16(%ebp), %eax
	movl	%eax, -24(%ebp)
.L476:
	movl	-24(%ebp), %eax
	addl	$36, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	get_packet, .-get_packet
	.section	.rodata
	.align 4
.LC81:
	.string	"dhcp_dna(send_discover): read_interface_hwaddr error\n"
	.align 4
.LC82:
	.string	"dhcp_dna: sending discover...\n"
	.text
.globl send_discover
	.type	send_discover, @function
send_discover:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$616, %esp
	leal	-10(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	read_interface_hwaddr
	testl	%eax, %eax
	jns	.L484
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$53, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC81, (%esp)
	call	fwrite
	movl	$-1, -580(%ebp)
	jmp	.L485
.L484:
	movl	$0, -16(%ebp)
	movl	$1, 8(%esp)
	leal	-564(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-10(%ebp), %eax
	movl	%eax, (%esp)
	call	init_packet
	movl	16(%ebp), %eax
	movl	%eax, -560(%ebp)
	cmpl	$0, 20(%ebp)
	je	.L486
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$50, 4(%esp)
	leal	-564(%ebp), %eax
	addl	$240, %eax
	movl	%eax, (%esp)
	call	add_simple_option
.L486:
	leal	-564(%ebp), %eax
	movl	%eax, (%esp)
	call	add_requests
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$30, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC82, (%esp)
	call	fwrite
	movl	$.LC53, %edx
	movl	8(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	%edx, 20(%esp)
	movl	$67, 16(%esp)
	movl	$-1, 12(%esp)
	movl	$68, 8(%esp)
	movl	$0, 4(%esp)
	leal	-564(%ebp), %eax
	movl	%eax, (%esp)
	call	raw_packet
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	%eax, -580(%ebp)
.L485:
	movl	-580(%ebp), %eax
	leave
	ret
	.size	send_discover, .-send_discover
	.section	.rodata
	.align 4
.LC83:
	.string	"dhcp_dna(send_discover): read_interface_hwaddr error\n "
	.text
.globl send_renew
	.type	send_renew, @function
send_renew:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$600, %esp
	movl	$0, -4(%ebp)
	leal	-558(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	read_interface_hwaddr
	testl	%eax, %eax
	jns	.L489
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$54, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC83, (%esp)
	call	fwrite
	movl	$-1, -564(%ebp)
	jmp	.L490
.L489:
	movl	$3, 8(%esp)
	leal	-552(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-558(%ebp), %eax
	movl	%eax, (%esp)
	call	init_packet
	movl	16(%ebp), %eax
	movl	%eax, -548(%ebp)
	movl	24(%ebp), %eax
	movl	%eax, -540(%ebp)
	leal	-552(%ebp), %eax
	movl	%eax, (%esp)
	call	add_requests
	cmpl	$0, 20(%ebp)
	je	.L491
	movl	$67, 16(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$68, 8(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-552(%ebp), %eax
	movl	%eax, (%esp)
	call	kernel_packet
	movl	%eax, -4(%ebp)
	jmp	.L492
.L491:
	movl	$.LC53, %edx
	movl	8(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	%edx, 20(%esp)
	movl	$67, 16(%esp)
	movl	$-1, 12(%esp)
	movl	$68, 8(%esp)
	movl	$0, 4(%esp)
	leal	-552(%ebp), %eax
	movl	%eax, (%esp)
	call	raw_packet
	movl	%eax, -4(%ebp)
.L492:
	movl	-4(%ebp), %eax
	movl	%eax, -564(%ebp)
.L490:
	movl	-564(%ebp), %eax
	leave
	ret
	.size	send_renew, .-send_renew
	.section	.rodata
	.align 4
.LC84:
	.string	"dhcp_dna: Sending select for %s...\n"
	.text
.globl send_selecting
	.type	send_selecting, @function
send_selecting:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$664, %esp
	leal	-562(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	read_interface_hwaddr
	testl	%eax, %eax
	jns	.L495
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$54, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC83, (%esp)
	call	fwrite
	movl	$-1, -628(%ebp)
	jmp	.L496
.L495:
	movl	$3, 8(%esp)
	leal	-552(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-562(%ebp), %eax
	movl	%eax, (%esp)
	call	init_packet
	movl	16(%ebp), %eax
	movl	%eax, -548(%ebp)
	movl	24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$50, 4(%esp)
	leal	-552(%ebp), %eax
	addl	$240, %eax
	movl	%eax, (%esp)
	call	add_simple_option
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$54, 4(%esp)
	leal	-552(%ebp), %eax
	addl	$240, %eax
	movl	%eax, (%esp)
	call	add_simple_option
	leal	-552(%ebp), %eax
	movl	%eax, (%esp)
	call	add_requests
	movl	24(%ebp), %eax
	movl	%eax, -556(%ebp)
	movl	-556(%ebp), %eax
	movl	%eax, (%esp)
	call	inet_ntoa
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC84, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	20(%ebp), %eax
	testl	%eax, %eax
	je	.L497
	movl	24(%ebp), %eax
	testl	%eax, %eax
	jne	.L498
.L497:
	movl	$.LC53, %edx
	movl	8(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	%edx, 20(%esp)
	movl	$67, 16(%esp)
	movl	$-1, 12(%esp)
	movl	$68, 8(%esp)
	movl	$0, 4(%esp)
	leal	-552(%ebp), %eax
	movl	%eax, (%esp)
	call	raw_packet
	movl	%eax, -628(%ebp)
	jmp	.L496
.L498:
	movl	$0, -568(%ebp)
	leal	20(%ebp), %eax
	leal	20(%ebp), %edx
	leal	24(%ebp), %ecx
	movl	%eax, 28(%esp)
	movl	$32, 24(%esp)
	movl	%edx, 20(%esp)
	movl	$32, 16(%esp)
	movl	%ecx, 12(%esp)
	movl	$0, 8(%esp)
	movl	$251, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_add
	leal	20(%ebp), %eax
	leal	24(%ebp), %edx
	movl	$0, 32(%esp)
	movl	$32, 28(%esp)
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule4_add
	leal	24(%ebp), %edx
	leal	20(%ebp), %ecx
	leal	-624(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	$17, 8(%esp)
	movl	(%edx), %eax
	movl	%eax, 4(%esp)
	movl	(%ecx), %eax
	movl	%eax, (%esp)
	call	set_v4selector
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	movl	$2, 16(%esp)
	movl	$0, 12(%esp)
	movl	$1, 8(%esp)
	movl	$0, 4(%esp)
	leal	-624(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_mip_policy_add
	movl	20(%ebp), %eax
	movl	24(%ebp), %edx
	movl	$67, 16(%esp)
	movl	%eax, 12(%esp)
	movl	$68, 8(%esp)
	movl	%edx, 4(%esp)
	leal	-552(%ebp), %eax
	movl	%eax, (%esp)
	call	kernel_packet
	movl	%eax, -4(%ebp)
	leal	20(%ebp), %eax
	leal	20(%ebp), %edx
	leal	24(%ebp), %ecx
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$32, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	$251, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_del
	leal	20(%ebp), %eax
	leal	24(%ebp), %edx
	movl	$0, 32(%esp)
	movl	$32, 28(%esp)
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
	movl	$1, 4(%esp)
	leal	-624(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_mip_policy_del
	movl	-4(%ebp), %eax
	movl	%eax, -628(%ebp)
.L496:
	movl	-628(%ebp), %eax
	leave
	ret
	.size	send_selecting, .-send_selecting
.globl uptime
	.type	uptime, @function
uptime:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$72, %esp
	leal	-64(%ebp), %eax
	movl	%eax, (%esp)
	call	sysinfo
	movl	-64(%ebp), %eax
	leave
	ret
	.size	uptime, .-uptime
	.local	__xid__.8664
	.comm	__xid__.8664,4,4
	.section	.rodata
	.align 4
.LC85:
	.string	"dhcp_dna: fatal error! cannot listen on socket!\n"
.LC86:
	.string	"no packet now \n"
.LC87:
	.string	"kernel"
.LC88:
	.string	"raw"
.LC89:
	.string	"listen(%s) return error!\n"
	.align 4
.LC90:
	.string	"packet got, but packet.xid(%d) do not eq data_dhcp->xid(%d), ignore it!\n"
.LC91:
	.string	"dhcp_dna: message is NULL\n"
.LC92:
	.string	"packet got, DHCPOFFER!!\n"
	.align 4
.LC93:
	.string	"------DHCP_OFFER-----------------\n[ip = %d.%d.%d.%d,\ndhcp_server = %d.%d.%d.%d,\ngateway = %d.%d.%d.%d,\ndns server = %d.%d.%d.%d,\nsubnet = %d.%d.%d.%d\n]---------------------------------\n"
	.align 4
.LC94:
	.string	"requested_ip changed? wierd???\n"
.LC95:
	.string	"DHCPACK"
.LC96:
	.string	"UNKNOWN"
	.align 4
.LC97:
	.string	"dhcp_dna: message got mismatch :%s\n"
	.align 4
.LC98:
	.string	"dhcp_dna: requested ip(%d.%d.%d.%d) not equal yiaddr(%d.%d.%d.%d)\n"
.LC99:
	.string	"dhcp_dna: DHCPACK received!\n"
	.align 4
.LC100:
	.string	"------DHCP_ACK-------------------\nip = %d.%d.%d.%d,\ndhcp_server = %d.%d.%d.%d,\ngateway = %d.%d.%d.%d,\ndns server = %d.%d.%d.%d,\nsubnet = %d.%d.%d.%d\n---------------------------------\n"
	.text
.globl dhcp_request
	.type	dhcp_request, @function
dhcp_request:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$1004, %esp
	movl	$0, -56(%ebp)
	movl	$-1, -52(%ebp)
	movl	$2, -48(%ebp)
	movl	$0, -44(%ebp)
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	$-1, %eax
	je	.L503
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L503
	movl	$1, -904(%ebp)
	jmp	.L504
.L503:
	movl	$0, -904(%ebp)
.L504:
	movl	-904(%ebp), %eax
	movl	%eax, -40(%ebp)
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	$-1, %eax
	jne	.L505
	movl	__xid__.8664, %eax
	movl	8(%ebp), %edx
	movl	%eax, 12(%edx)
	addl	$1, %eax
	movl	%eax, __xid__.8664
.L505:
	call	uptime
	movl	-56(%ebp), %edx
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, -64(%ebp)
	movl	$0, -60(%ebp)
	cmpl	$0, -52(%ebp)
	jns	.L506
	cmpl	$1, -48(%ebp)
	jne	.L507
	movl	8(%ebp), %eax
	addl	$20, %eax
	movl	%eax, 8(%esp)
	movl	$68, 4(%esp)
	movl	$0, (%esp)
	call	kernel_socket
	movl	%eax, -52(%ebp)
	jmp	.L508
.L507:
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	movl	%eax, (%esp)
	call	raw_socket
	movl	%eax, -52(%ebp)
.L508:
	cmpl	$0, -52(%ebp)
	jns	.L506
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$48, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC85, (%esp)
	call	fwrite
	movl	$-1, -900(%ebp)
	jmp	.L509
.L506:
	leal	-740(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	$0, -28(%ebp)
	jmp	.L510
.L511:
	movl	-28(%ebp), %edx
	movl	-24(%ebp), %eax
	movl	$0, (%eax,%edx,4)
	addl	$1, -28(%ebp)
.L510:
	cmpl	$31, -28(%ebp)
	jbe	.L511
	movl	-52(%ebp), %eax
	shrl	$5, %eax
	movl	%eax, %ebx
	movl	-740(%ebp,%eax,4), %eax
	movl	%eax, %edx
	movl	-52(%ebp), %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	movl	$1, %eax
	sall	%cl, %eax
	orl	%edx, %eax
	movl	%eax, -740(%ebp,%ebx,4)
	movl	-64(%ebp), %eax
	testl	%eax, %eax
	jle	.L512
	movl	-52(%ebp), %eax
	leal	1(%eax), %edx
	leal	-64(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	leal	-740(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	select
	movl	%eax, -36(%ebp)
	jmp	.L513
.L512:
	movl	$0, -36(%ebp)
.L513:
	cmpl	$0, -36(%ebp)
	jne	.L514
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$15, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC86, (%esp)
	call	fwrite
.L514:
	call	uptime
	movl	%eax, -32(%ebp)
	cmpl	$0, -36(%ebp)
	jne	.L515
	movl	-40(%ebp), %eax
	movl	%eax, -908(%ebp)
	cmpl	$0, -908(%ebp)
	je	.L517
	cmpl	$1, -908(%ebp)
	je	.L518
	jmp	.L505
.L517:
	cmpl	$2, -44(%ebp)
	jg	.L519
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	movl	%eax, %ecx
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, %ebx
	movl	8(%ebp), %eax
	leal	20(%eax), %edx
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	movl	%ecx, 12(%esp)
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	send_discover
	cmpl	$1, -44(%ebp)
	jle	.L520
	movl	$4, -896(%ebp)
	jmp	.L521
.L520:
	movl	$2, -896(%ebp)
.L521:
	movl	-896(%ebp), %eax
	addl	-32(%ebp), %eax
	movl	%eax, -56(%ebp)
	addl	$1, -44(%ebp)
	jmp	.L505
.L519:
	movl	$0, -44(%ebp)
	movl	-32(%ebp), %eax
	addl	$60, %eax
	movl	%eax, -56(%ebp)
	jmp	.L505
.L518:
	cmpl	$2, -44(%ebp)
	jg	.L523
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	movl	%eax, %esi
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	%eax, %ecx
	movl	8(%ebp), %eax
	leal	20(%eax), %ebx
	movl	8(%ebp), %eax
	movl	16(%eax), %eax
	movl	%esi, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%ebx, 4(%esp)
	movl	%eax, (%esp)
	call	send_selecting
	addl	$1, -44(%ebp)
	cmpl	$1, -44(%ebp)
	jle	.L524
	movl	$4, -892(%ebp)
	jmp	.L525
.L524:
	movl	$2, -892(%ebp)
.L525:
	movl	-892(%ebp), %eax
	addl	-32(%ebp), %eax
	movl	%eax, -56(%ebp)
	jmp	.L505
.L523:
	movl	$0, -40(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, -56(%ebp)
	cmpl	$0, -52(%ebp)
	js	.L526
	movl	-52(%ebp), %eax
	movl	%eax, (%esp)
	call	close
.L526:
	movl	$-1, -52(%ebp)
	movl	$2, -48(%ebp)
	movl	$0, -44(%ebp)
	jmp	.L505
.L515:
	cmpl	$0, -36(%ebp)
	jle	.L505
	movl	-52(%ebp), %eax
	shrl	$5, %eax
	movl	-740(%ebp,%eax,4), %eax
	movl	%eax, %edx
	movl	-52(%ebp), %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	movl	%edx, %eax
	shrl	%cl, %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L505
	cmpl	$1, -48(%ebp)
	jne	.L528
	movl	-52(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_packet
	movl	%eax, -20(%ebp)
	jmp	.L529
.L528:
	movl	-52(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_raw_packet
	movl	%eax, -20(%ebp)
.L529:
	cmpl	$0, -20(%ebp)
	jns	.L530
	cmpl	$1, -48(%ebp)
	jne	.L531
	movl	$.LC87, -888(%ebp)
	jmp	.L532
.L531:
	movl	$.LC88, -888(%ebp)
.L532:
	movl	stderr, %eax
	movl	-888(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$.LC89, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	jmp	.L505
.L530:
	movl	-608(%ebp), %edx
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	cmpl	%eax, %edx
	je	.L533
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	-608(%ebp), %edx
	movl	stderr, %ecx
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC90, 4(%esp)
	movl	%ecx, (%esp)
	call	fprintf
	jmp	.L505
.L533:
	movl	$53, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jne	.L534
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$26, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC91, (%esp)
	call	fwrite
	jmp	.L505
.L534:
	movl	-40(%ebp), %ecx
	movl	%ecx, -912(%ebp)
	cmpl	$0, -912(%ebp)
	je	.L536
	cmpl	$1, -912(%ebp)
	je	.L537
	jmp	.L535
.L536:
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$2, %al
	jne	.L538
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$24, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC92, (%esp)
	call	fwrite
	movl	-596(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	$54, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	8(%ebp), %edx
	movl	$4, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	$3, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	$6, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	8(%ebp), %eax
	addl	$56, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	$1, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	8(%ebp), %eax
	addl	$52, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, %edx
	shrl	$24, %edx
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	andl	$16711680, %eax
	movl	%eax, %ecx
	sarl	$16, %ecx
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	andl	$65280, %eax
	movl	%eax, %ebx
	sarl	$8, %ebx
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movzbl	%al,%esi
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, %edi
	shrl	$24, %edi
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$16, %eax
	movl	%eax, -884(%ebp)
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$8, %eax
	movl	%eax, -880(%ebp)
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	andl	$255, %eax
	movl	%eax, -876(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, -872(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$16, %eax
	movl	%eax, -868(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$8, %eax
	movl	%eax, -864(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	andl	$255, %eax
	movl	%eax, -860(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, -856(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$16, %eax
	movl	%eax, -852(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$8, %eax
	movl	%eax, -848(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	andl	$255, %eax
	movl	%eax, -844(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, -840(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$16, %eax
	movl	%eax, -836(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$8, %eax
	movl	%eax, -832(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	andl	$255, %eax
	movl	%eax, -916(%ebp)
	movl	stderr, %eax
	movl	%eax, -828(%ebp)
	movl	%edx, 84(%esp)
	movl	%ecx, 80(%esp)
	movl	%ebx, 76(%esp)
	movl	%esi, 72(%esp)
	movl	%edi, 68(%esp)
	movl	-884(%ebp), %edx
	movl	%edx, 64(%esp)
	movl	-880(%ebp), %ecx
	movl	%ecx, 60(%esp)
	movl	-876(%ebp), %eax
	movl	%eax, 56(%esp)
	movl	-872(%ebp), %edx
	movl	%edx, 52(%esp)
	movl	-868(%ebp), %ecx
	movl	%ecx, 48(%esp)
	movl	-864(%ebp), %eax
	movl	%eax, 44(%esp)
	movl	-860(%ebp), %edx
	movl	%edx, 40(%esp)
	movl	-856(%ebp), %ecx
	movl	%ecx, 36(%esp)
	movl	-852(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	-848(%ebp), %edx
	movl	%edx, 28(%esp)
	movl	-844(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-840(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	-836(%ebp), %edx
	movl	%edx, 16(%esp)
	movl	-832(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	-916(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC93, 4(%esp)
	movl	-828(%ebp), %edx
	movl	%edx, (%esp)
	call	fprintf
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	testl	%eax, %eax
	je	.L539
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	movl	%eax, %edx
	movl	-596(%ebp), %eax
	cmpl	%eax, %edx
	je	.L539
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$31, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC94, (%esp)
	call	fwrite
.L539:
	movl	$1, -40(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, -56(%ebp)
	movl	$1, -900(%ebp)
	jmp	.L509
.L538:
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$5, %al
	jne	.L540
	movl	$.LC95, -824(%ebp)
	jmp	.L541
.L540:
	movl	$.LC96, -824(%ebp)
.L541:
	movl	stderr, %eax
	movl	-824(%ebp), %ecx
	movl	%ecx, 8(%esp)
	movl	$.LC97, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	jmp	.L535
.L537:
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$5, %al
	jne	.L535
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	movl	%eax, %edx
	movl	-596(%ebp), %eax
	cmpl	%eax, %edx
	je	.L542
	movl	-596(%ebp), %eax
	movl	%eax, %ecx
	shrl	$24, %ecx
	movl	-596(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, %ebx
	shrl	$16, %ebx
	movl	-596(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, %esi
	shrl	$8, %esi
	movl	-596(%ebp), %eax
	movzbl	%al,%edi
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	movl	%eax, %edx
	shrl	$24, %edx
	movl	%edx, -820(%ebp)
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	andl	$16711680, %eax
	movl	%eax, %edx
	sarl	$16, %edx
	movl	%edx, -816(%ebp)
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	andl	$65280, %eax
	movl	%eax, %edx
	sarl	$8, %edx
	movl	%edx, -812(%ebp)
	movl	8(%ebp), %eax
	movl	60(%eax), %eax
	andl	$255, %eax
	movl	stderr, %edx
	movl	%ecx, 36(%esp)
	movl	%ebx, 32(%esp)
	movl	%esi, 28(%esp)
	movl	%edi, 24(%esp)
	movl	-820(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-816(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-812(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC98, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
.L542:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$28, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC99, (%esp)
	call	fwrite
	movl	-596(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 8(%eax)
	movl	$54, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	8(%ebp), %edx
	movl	$4, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	$3, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	8(%ebp), %eax
	addl	$4, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	$6, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	8(%ebp), %eax
	addl	$56, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	$1, 4(%esp)
	leal	-612(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	8(%ebp), %eax
	addl	$52, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movl	%eax, %edx
	shrl	$24, %edx
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	andl	$16711680, %eax
	movl	%eax, %ecx
	sarl	$16, %ecx
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	andl	$65280, %eax
	movl	%eax, %ebx
	sarl	$8, %ebx
	movl	8(%ebp), %eax
	movl	52(%eax), %eax
	movzbl	%al,%esi
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, %edi
	shrl	$24, %edi
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$16, %eax
	movl	%eax, -808(%ebp)
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$8, %eax
	movl	%eax, -804(%ebp)
	movl	8(%ebp), %eax
	movl	56(%eax), %eax
	andl	$255, %eax
	movl	%eax, -800(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, -796(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$16, %eax
	movl	%eax, -792(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$8, %eax
	movl	%eax, -788(%ebp)
	movl	8(%ebp), %eax
	movl	4(%eax), %eax
	andl	$255, %eax
	movl	%eax, -784(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, -780(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$16, %eax
	movl	%eax, -776(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$8, %eax
	movl	%eax, -772(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	andl	$255, %eax
	movl	%eax, -768(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	shrl	$24, %eax
	movl	%eax, -764(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$16711680, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$16, %eax
	movl	%eax, -760(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	andl	$65280, %eax
	movl	%eax, -916(%ebp)
	movl	-916(%ebp), %eax
	sarl	$8, %eax
	movl	%eax, -756(%ebp)
	movl	8(%ebp), %eax
	movl	8(%eax), %eax
	andl	$255, %eax
	movl	%eax, -916(%ebp)
	movl	stderr, %eax
	movl	%eax, -752(%ebp)
	movl	%edx, 84(%esp)
	movl	%ecx, 80(%esp)
	movl	%ebx, 76(%esp)
	movl	%esi, 72(%esp)
	movl	%edi, 68(%esp)
	movl	-808(%ebp), %edx
	movl	%edx, 64(%esp)
	movl	-804(%ebp), %ecx
	movl	%ecx, 60(%esp)
	movl	-800(%ebp), %eax
	movl	%eax, 56(%esp)
	movl	-796(%ebp), %edx
	movl	%edx, 52(%esp)
	movl	-792(%ebp), %ecx
	movl	%ecx, 48(%esp)
	movl	-788(%ebp), %eax
	movl	%eax, 44(%esp)
	movl	-784(%ebp), %edx
	movl	%edx, 40(%esp)
	movl	-780(%ebp), %ecx
	movl	%ecx, 36(%esp)
	movl	-776(%ebp), %eax
	movl	%eax, 32(%esp)
	movl	-772(%ebp), %edx
	movl	%edx, 28(%esp)
	movl	-768(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-764(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	-760(%ebp), %edx
	movl	%edx, 16(%esp)
	movl	-756(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	-916(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC100, 4(%esp)
	movl	-752(%ebp), %edx
	movl	%edx, (%esp)
	call	fprintf
	movl	$1, -900(%ebp)
	jmp	.L509
.L535:
	movl	$0, -900(%ebp)
.L509:
	movl	-900(%ebp), %eax
	addl	$1004, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	dhcp_request, .-dhcp_request
.globl tnl44_fd
	.bss
	.align 4
	.type	tnl44_fd, @object
	.size	tnl44_fd, 4
tnl44_fd:
	.zero	4
.globl tnl66_fd
	.align 4
	.type	tnl66_fd, @object
	.size	tnl66_fd, 4
tnl66_fd:
	.zero	4
.globl tnl64_fd
	.align 4
	.type	tnl64_fd, @object
	.size	tnl64_fd, 4
tnl64_fd:
	.zero	4
	.text
.globl tnl_init
	.type	tnl_init, @function
tnl_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, 8(%esp)
	movl	$2, 4(%esp)
	movl	$10, (%esp)
	call	socket
	movl	%eax, tnl66_fd
	movl	tnl66_fd, %eax
	testl	%eax, %eax
	jns	.L545
	movl	$-1, -4(%ebp)
	jmp	.L546
.L545:
	movl	$0, 8(%esp)
	movl	$2, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, tnl64_fd
	movl	tnl64_fd, %eax
	testl	%eax, %eax
	jns	.L547
	movl	$-1, -4(%ebp)
	jmp	.L546
.L547:
	movl	$0, 8(%esp)
	movl	$2, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, tnl44_fd
	movl	tnl44_fd, %eax
	testl	%eax, %eax
	jns	.L548
	movl	$-1, -4(%ebp)
	jmp	.L546
.L548:
	movl	$0, -4(%ebp)
.L546:
	movl	-4(%ebp), %eax
	leave
	ret
	.size	tnl_init, .-tnl_init
.globl tnl_cleanup
	.type	tnl_cleanup, @function
tnl_cleanup:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	tnl66_fd, %eax
	movl	%eax, (%esp)
	call	close
	movl	tnl64_fd, %eax
	movl	%eax, (%esp)
	call	close
	movl	tnl44_fd, %eax
	movl	%eax, (%esp)
	call	close
	movl	$0, %eax
	leave
	ret
	.size	tnl_cleanup, .-tnl_cleanup
	.section	.rodata
	.align 4
.LC101:
	.string	"adding 66 tnl %x:%x:%x:%x:%x:%x:%x:%x to %x:%x:%x:%x:%x:%x:%x:%x\n"
.LC102:
	.string	"ip6tnl0"
	.align 4
.LC103:
	.string	"tunnel66_add: SIOCADDTUNNEL failed status %d %s\n"
	.align 4
.LC104:
	.string	"tunnel66_add: tunnel exists,but isn't used for MIPv6\n"
	.align 4
.LC105:
	.string	"tunnel66_add: SIOCGIFFLAGS failed status %d %s\n"
	.align 4
.LC106:
	.string	"SIOCSIFFLAGS failed status %d %s\n"
.LC107:
	.string	"no device called %s\n"
	.text
.globl tunnel66_add
	.type	tunnel66_add, @function
tunnel66_add:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$236, %esp
	movl	12(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %ebx
	movl	12(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %esi
	movl	12(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edi
	movl	12(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -176(%ebp)
	movl	12(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -172(%ebp)
	movl	12(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -168(%ebp)
	movl	12(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -164(%ebp)
	movl	12(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -160(%ebp)
	movl	8(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -156(%ebp)
	movl	8(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -152(%ebp)
	movl	8(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -148(%ebp)
	movl	8(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -144(%ebp)
	movl	8(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -140(%ebp)
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -136(%ebp)
	movl	8(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -132(%ebp)
	movl	8(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%ebx, 68(%esp)
	movl	%esi, 64(%esp)
	movl	%edi, 60(%esp)
	movl	-176(%ebp), %ecx
	movl	%ecx, 56(%esp)
	movl	-172(%ebp), %ecx
	movl	%ecx, 52(%esp)
	movl	-168(%ebp), %ecx
	movl	%ecx, 48(%esp)
	movl	-164(%ebp), %ecx
	movl	%ecx, 44(%esp)
	movl	-160(%ebp), %ecx
	movl	%ecx, 40(%esp)
	movl	-156(%ebp), %ecx
	movl	%ecx, 36(%esp)
	movl	-152(%ebp), %ecx
	movl	%ecx, 32(%esp)
	movl	-148(%ebp), %ecx
	movl	%ecx, 28(%esp)
	movl	-144(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-140(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-136(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-132(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC101, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$64, 8(%esp)
	movl	$0, 4(%esp)
	leal	-112(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movb	$0, -92(%ebp)
	movl	$9, -84(%ebp)
	movb	$64, -90(%ebp)
	movl	8(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -80(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -76(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -72(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -68(%ebp)
	movl	12(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -64(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -60(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -56(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -52(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -96(%ebp)
	movl	$8, 8(%esp)
	movl	$.LC102, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	leal	-112(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	tnl66_fd, %edx
	leal	-48(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35313, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L553
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC103, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L554
.L553:
	movl	-84(%ebp), %eax
	andl	$8, %eax
	testl	%eax, %eax
	jne	.L555
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$53, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC104, (%esp)
	call	fwrite
	jmp	.L554
.L555:
	leal	-112(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-48(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	movl	tnl66_fd, %edx
	leal	-48(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35091, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L556
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC105, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L554
.L556:
	movzwl	-32(%ebp), %eax
	orl	$65, %eax
	movw	%ax, -32(%ebp)
	movl	tnl66_fd, %edx
	leal	-48(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35092, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L557
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC106, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L554
.L557:
	leal	-112(%ebp), %eax
	movl	%eax, (%esp)
	call	if_nametoindex
	movl	%eax, -16(%ebp)
	cmpl	$0, -16(%ebp)
	jne	.L558
	movl	stderr, %edx
	leal	-112(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC107, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L554
.L558:
	movl	-16(%ebp), %eax
	movl	%eax, -128(%ebp)
	jmp	.L559
.L554:
	movl	$-1, -128(%ebp)
.L559:
	movl	-128(%ebp), %eax
	addl	$236, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	tunnel66_add, .-tunnel66_add
	.section	.rodata
	.align 4
.LC108:
	.string	"SIOCDELTUNNEL failed status %d %s\n"
.LC109:
	.string	"tunnel deleted\n"
	.text
.globl tunnel66_del
	.type	tunnel66_del, @function
tunnel66_del:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$164, %esp
	movl	$0, -8(%ebp)
	movl	8(%ebp), %edx
	leal	-140(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	if_indextoname
	leal	-140(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	movl	tnl66_fd, %edx
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35314, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L562
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC108, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -152(%ebp)
	jmp	.L563
.L562:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$15, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC109, (%esp)
	call	fwrite
	movl	$0, -152(%ebp)
.L563:
	movl	-152(%ebp), %eax
	addl	$164, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	tunnel66_del, .-tunnel66_del
	.section	.rodata
.LC110:
	.string	"sit0"
	.align 4
.LC111:
	.string	"tunnel64_add: SIOCADDTUNNEL failed status %d %s\n"
	.align 4
.LC112:
	.string	"tunnel64_add: SIOCGIFFLAGS failed status %d %s\n"
	.align 4
.LC113:
	.string	"tunnel64_add: SIOCSIFFLAGS failed status %d %s\n"
	.text
.globl tunnel64_add
	.type	tunnel64_add, @function
tunnel64_add:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$116, %esp
	movl	$52, 8(%esp)
	movl	$0, 4(%esp)
	leal	-92(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movzbl	-60(%ebp), %eax
	andl	$15, %eax
	orl	$64, %eax
	movb	%al, -60(%ebp)
	movzbl	-60(%ebp), %eax
	andl	$-16, %eax
	orl	$5, %eax
	movb	%al, -60(%ebp)
	movl	$16384, (%esp)
	call	htons
	movw	%ax, -54(%ebp)
	movb	$41, -51(%ebp)
	movb	$64, -52(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -76(%ebp)
	leal	-92(%ebp), %eax
	addl	$44, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_unmap_addr
	leal	-92(%ebp), %eax
	addl	$48, %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_unmap_addr
	movl	$5, 8(%esp)
	movl	$.LC110, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	leal	-92(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	tnl64_fd, %edx
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35313, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L566
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC111, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L567
.L566:
	leal	-92(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	movl	tnl64_fd, %edx
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35091, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L568
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC112, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L567
.L568:
	movzwl	-24(%ebp), %eax
	orl	$65, %eax
	movw	%ax, -24(%ebp)
	movl	tnl64_fd, %edx
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35092, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L569
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC113, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L567
.L569:
	leal	-92(%ebp), %eax
	movl	%eax, (%esp)
	call	if_nametoindex
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L570
	movl	stderr, %edx
	leal	-92(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC107, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -104(%ebp)
	jmp	.L571
.L570:
	movl	-8(%ebp), %eax
	movl	%eax, -104(%ebp)
	jmp	.L571
.L567:
	movl	$-1, -104(%ebp)
.L571:
	movl	-104(%ebp), %eax
	addl	$116, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	tunnel64_add, .-tunnel64_add
.globl tunnel64_del
	.type	tunnel64_del, @function
tunnel64_del:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$164, %esp
	movl	$0, -8(%ebp)
	movl	8(%ebp), %edx
	leal	-140(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	if_indextoname
	leal	-140(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	movl	tnl64_fd, %edx
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35314, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L574
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC108, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -152(%ebp)
	jmp	.L575
.L574:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$15, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC109, (%esp)
	call	fwrite
	movl	$0, -152(%ebp)
.L575:
	movl	-152(%ebp), %eax
	addl	$164, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	tunnel64_del, .-tunnel64_del
	.section	.rodata
.LC114:
	.string	"tunl0"
	.align 4
.LC115:
	.string	"tunnel44_add: SIOCADDTUNNEL failed status %d %s\n"
	.align 4
.LC116:
	.string	"tunnel44_add: SIOCGIFFLAGS failed status %d %s\n"
	.align 4
.LC117:
	.string	"tunnel44_add: SIOCSIFFLAGS failed status %d %s\n"
	.text
.globl tunnel44_add
	.type	tunnel44_add, @function
tunnel44_add:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$116, %esp
	movl	$52, 8(%esp)
	movl	$0, 4(%esp)
	leal	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movzbl	-28(%ebp), %eax
	andl	$15, %eax
	orl	$64, %eax
	movb	%al, -28(%ebp)
	movzbl	-28(%ebp), %eax
	andl	$-16, %eax
	orl	$5, %eax
	movb	%al, -28(%ebp)
	movl	$16384, (%esp)
	call	htons
	movw	%ax, -22(%ebp)
	movb	$4, -19(%ebp)
	movb	$64, -20(%ebp)
	movl	16(%ebp), %eax
	movl	%eax, -44(%ebp)
	leal	-60(%ebp), %eax
	addl	$44, %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_unmap_addr
	leal	-60(%ebp), %eax
	addl	$48, %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_unmap_addr
	movl	$6, 8(%esp)
	movl	$.LC114, 4(%esp)
	leal	-92(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	leal	-60(%ebp), %eax
	movl	%eax, -76(%ebp)
	movl	tnl44_fd, %edx
	leal	-92(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35313, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L578
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC115, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L579
.L578:
	leal	-60(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-92(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	movl	tnl44_fd, %edx
	leal	-92(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35091, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L580
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC116, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L579
.L580:
	movzwl	-76(%ebp), %eax
	orl	$65, %eax
	movw	%ax, -76(%ebp)
	movl	tnl44_fd, %edx
	leal	-92(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35092, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L581
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC117, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L579
.L581:
	leal	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	if_nametoindex
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L582
	movl	stderr, %edx
	leal	-60(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC107, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L579
.L582:
	movl	-8(%ebp), %eax
	movl	%eax, -104(%ebp)
	jmp	.L583
.L579:
	movl	$-1, -104(%ebp)
.L583:
	movl	-104(%ebp), %eax
	addl	$116, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	tunnel44_add, .-tunnel44_add
.globl tunnel44_del
	.type	tunnel44_del, @function
tunnel44_del:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$164, %esp
	movl	$0, -8(%ebp)
	movl	8(%ebp), %edx
	leal	-140(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	if_indextoname
	leal	-140(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	strcpy
	movl	tnl44_fd, %edx
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35314, 4(%esp)
	movl	%edx, (%esp)
	call	ioctl
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L586
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, %ebx
	call	__errno_location
	movl	(%eax), %eax
	movl	stderr, %edx
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC108, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -152(%ebp)
	jmp	.L587
.L586:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$15, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC109, (%esp)
	call	fwrite
	movl	$0, -152(%ebp)
.L587:
	movl	-152(%ebp), %eax
	addl	$164, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	tunnel44_del, .-tunnel44_del
.globl in6addr_all_nodes_mc
	.section	.rodata
	.align 4
	.type	in6addr_all_nodes_mc, @object
	.size	in6addr_all_nodes_mc, 16
in6addr_all_nodes_mc:
	.byte	-1
	.byte	2
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	1
.globl in6addr_all_routers_mc
	.align 4
	.type	in6addr_all_routers_mc, @object
	.size	in6addr_all_routers_mc, 16
in6addr_all_routers_mc:
	.byte	-1
	.byte	2
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	0
	.byte	2
	.local	chdr.9395
	.comm	chdr.9395,128,32
	.text
.globl icmp6_recv
	.type	icmp6_recv, @function
icmp6_recv:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$72, %esp
	movl	16(%ebp), %eax
	movl	%eax, -40(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -44(%ebp)
	movl	20(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	$28, -32(%ebp)
	leal	-44(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	$1, -24(%ebp)
	movl	$chdr.9395, -20(%ebp)
	movl	$128, -16(%ebp)
	movl	$0, 8(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	recvmsg
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L590
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, %edx
	negl	%edx
	movl	%edx, -60(%ebp)
	jmp	.L591
.L590:
	movl	-16(%ebp), %eax
	cmpl	$11, %eax
	jbe	.L592
	movl	-20(%ebp), %eax
	movl	%eax, -56(%ebp)
	jmp	.L593
.L592:
	movl	$0, -56(%ebp)
.L593:
	movl	-56(%ebp), %eax
	movl	%eax, -8(%ebp)
	jmp	.L594
.L598:
	movl	-8(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	$41, %eax
	jne	.L595
	movl	-8(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, -52(%ebp)
	cmpl	$50, -52(%ebp)
	je	.L596
	cmpl	$52, -52(%ebp)
	jne	.L595
.L597:
	movl	-8(%ebp), %eax
	addl	$12, %eax
	movl	(%eax), %edx
	movl	28(%ebp), %eax
	movl	%edx, (%eax)
	jmp	.L595
.L596:
	movl	-8(%ebp), %eax
	addl	$12, %eax
	movl	$20, 8(%esp)
	movl	%eax, 4(%esp)
	movl	24(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
.L595:
	movl	-8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	__cmsg_nxthdr
	movl	%eax, -8(%ebp)
.L594:
	cmpl	$0, -8(%ebp)
	jne	.L598
	movl	-4(%ebp), %edx
	movl	%edx, -60(%ebp)
.L591:
	movl	-60(%ebp), %eax
	leave
	ret
	.size	icmp6_recv, .-icmp6_recv
	.section	.rodata
	.align 4
.LC118:
	.string	"ROUTER_ADVERT received from %x:%x:%x:%x:%x:%x:%x:%x on iface %d\n"
	.text
.globl recvra
	.type	recvra, @function
recvra:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$1692, %esp
	movl	icmp6_sock+24, %edx
	leal	-1628(%ebp), %eax
	movl	%eax, 20(%esp)
	leal	-1624(%ebp), %eax
	movl	%eax, 16(%esp)
	leal	-1604(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1540, 8(%esp)
	leal	-1576(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	icmp6_recv
	movl	%eax, -20(%ebp)
	cmpl	$-9, -20(%ebp)
	jne	.L601
	movl	$-1, -1648(%ebp)
	jmp	.L602
.L601:
	movl	-20(%ebp), %eax
	cmpl	$7, %eax
	ja	.L603
	movl	$-1, -1648(%ebp)
	jmp	.L602
.L603:
	leal	-1604(%ebp), %eax
	addl	$8, %eax
	movl	%eax, -36(%ebp)
	leal	-1624(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	-1608(%ebp), %eax
	movl	%eax, -24(%ebp)
	leal	-1576(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	-28(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$-122, %al
	jne	.L604
	movl	-36(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %ebx
	movl	-36(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %esi
	movl	-36(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edi
	movl	-36(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1644(%ebp)
	movl	-36(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1640(%ebp)
	movl	-36(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1636(%ebp)
	movl	-36(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1632(%ebp)
	movl	-36(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edx
	movl	stderr, %ecx
	movl	-24(%ebp), %eax
	movl	%eax, 40(%esp)
	movl	%ebx, 36(%esp)
	movl	%esi, 32(%esp)
	movl	%edi, 28(%esp)
	movl	-1644(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	-1640(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	-1636(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	-1632(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$.LC118, 4(%esp)
	movl	%ecx, (%esp)
	call	fprintf
	movl	$16, 8(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	movl	-24(%ebp), %eax
	movl	%eax, -1648(%ebp)
	jmp	.L602
.L604:
	movl	$-1, -1648(%ebp)
.L602:
	movl	-1648(%ebp), %eax
	addl	$1692, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	recvra, .-recvra
	.section	.rodata
	.align 4
.LC119:
	.string	"Unable to open ICMPv6 socket! Do you have root permissions?"
	.text
.globl icmp6_init
	.type	icmp6_init, @function
icmp6_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$72, %esp
	movl	8(%ebp), %eax
	movl	%eax, is_mn
	movl	$58, 8(%esp)
	movl	$3, 4(%esp)
	movl	$10, (%esp)
	call	socket
	movl	%eax, icmp6_sock+24
	movl	icmp6_sock+24, %eax
	testl	%eax, %eax
	jns	.L607
	movl	$.LC119, 4(%esp)
	movl	$3, (%esp)
	call	syslog
	movl	icmp6_sock+24, %eax
	movl	%eax, -52(%ebp)
	jmp	.L608
.L607:
	movl	$1, -36(%ebp)
	movl	icmp6_sock+24, %eax
	movl	$4, 16(%esp)
	leal	-36(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$49, 8(%esp)
	movl	$41, 4(%esp)
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L609
	movl	$-1, -52(%ebp)
	jmp	.L608
.L609:
	movl	icmp6_sock+24, %eax
	movl	$4, 16(%esp)
	leal	-36(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$51, 8(%esp)
	movl	$41, 4(%esp)
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L610
	movl	$-1, -52(%ebp)
	jmp	.L608
.L610:
	movl	$32, 8(%esp)
	movl	$255, 4(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	cmpl	$0, 8(%ebp)
	je	.L611
	movl	-16(%ebp), %eax
	andl	$-65, %eax
	movl	%eax, -16(%ebp)
.L611:
	movl	icmp6_sock+24, %eax
	movl	$32, 16(%esp)
	leal	-32(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$1, 8(%esp)
	movl	$58, 4(%esp)
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L612
	movl	$-1, -52(%ebp)
	jmp	.L608
.L612:
	movl	$2, -36(%ebp)
	movl	icmp6_sock+24, %eax
	movl	$4, 16(%esp)
	leal	-36(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$7, 8(%esp)
	movl	$255, 4(%esp)
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L613
	movl	$-1, -52(%ebp)
	jmp	.L608
.L613:
	movl	$0, -52(%ebp)
.L608:
	movl	-52(%ebp), %eax
	leave
	ret
	.size	icmp6_init, .-icmp6_init
.globl icmp6_cleanup
	.type	icmp6_cleanup, @function
icmp6_cleanup:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	icmp6_sock+24, %eax
	movl	%eax, (%esp)
	call	close
	movl	$0, %eax
	leave
	ret
	.size	icmp6_cleanup, .-icmp6_cleanup
	.type	neigh_mod, @function
neigh_mod:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$312, %esp
	movl	20(%ebp), %eax
	movl	24(%ebp), %edx
	movw	%ax, -276(%ebp)
	movb	%dl, -280(%ebp)
	movl	$256, 8(%esp)
	movl	$0, 4(%esp)
	leal	-264(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-264(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	$28, (%eax)
	movl	8(%ebp), %eax
	orl	$1, %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movw	%dx, 6(%eax)
	movl	12(%ebp), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movw	%dx, 4(%eax)
	movl	-8(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -4(%ebp)
	movl	-4(%ebp), %eax
	movb	$10, (%eax)
	movl	-4(%ebp), %edx
	movl	16(%ebp), %eax
	movl	%eax, 4(%edx)
	movl	-4(%ebp), %edx
	movzwl	-276(%ebp), %eax
	movw	%ax, 8(%edx)
	movl	-4(%ebp), %edx
	movzbl	-280(%ebp), %eax
	movb	%al, 10(%edx)
	movl	28(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$-1, %al
	jne	.L618
	movb	$5, -281(%ebp)
	jmp	.L619
.L618:
	movb	$1, -281(%ebp)
.L619:
	movl	-4(%ebp), %eax
	movzbl	-281(%ebp), %edx
	movb	%dl, 11(%eax)
	movl	$16, 16(%esp)
	movl	28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$1, 8(%esp)
	movl	$256, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
	cmpl	$0, 32(%ebp)
	je	.L620
	movl	36(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	32(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$256, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	addattr_l
.L620:
	movl	$0, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_route_do
	leave
	ret
	.size	neigh_mod, .-neigh_mod
.globl neigh_add
	.type	neigh_add, @function
neigh_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
	movw	%ax, -4(%ebp)
	movb	%dl, -8(%ebp)
	movzbl	-8(%ebp), %eax
	movl	%eax, -20(%ebp)
	movzwl	-4(%ebp), %eax
	movl	%eax, -16(%ebp)
	cmpl	$0, 32(%ebp)
	je	.L623
	movl	$1280, -12(%ebp)
	jmp	.L624
.L623:
	movl	$1024, -12(%ebp)
.L624:
	movl	28(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	-20(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$28, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	neigh_mod
	leave
	ret
	.size	neigh_add, .-neigh_add
.globl neigh_del
	.type	neigh_del, @function
neigh_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$29, 4(%esp)
	movl	$0, (%esp)
	call	neigh_mod
	leave
	ret
	.size	neigh_del, .-neigh_del
.globl pneigh_add
	.type	pneigh_add, @function
pneigh_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	12(%ebp), %eax
	movb	%al, -4(%ebp)
	movzbl	-4(%ebp), %eax
	orl	$8, %eax
	movzbl	%al, %edx
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$128, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$28, 4(%esp)
	movl	$1280, (%esp)
	call	neigh_mod
	leave
	ret
	.size	pneigh_add, .-pneigh_add
.globl pneigh_del
	.type	pneigh_del, @function
pneigh_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$8, 16(%esp)
	movl	$0, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$29, 4(%esp)
	movl	$0, (%esp)
	call	neigh_mod
	leave
	ret
	.size	pneigh_del, .-pneigh_del
	.type	csum, @function
csum:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	$0, -20(%ebp)
	movl	8(%ebp), %eax
	movl	%eax, -8(%ebp)
	movl	$0, -4(%ebp)
	jmp	.L633
.L634:
	movl	-8(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	addl	%eax, -20(%ebp)
	addl	$2, -8(%ebp)
	addl	$1, -4(%ebp)
.L633:
	cmpl	$19, -4(%ebp)
	jle	.L634
	movl	16(%ebp), %eax
	movl	%eax, -12(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -8(%ebp)
	jmp	.L635
.L636:
	movl	-8(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	addl	%eax, -20(%ebp)
	addl	$2, -8(%ebp)
	subl	$2, -12(%ebp)
.L635:
	cmpl	$1, -12(%ebp)
	ja	.L636
	jmp	.L637
.L638:
	movzwl	-20(%ebp),%edx
	movl	-20(%ebp), %eax
	shrl	$16, %eax
	addl	%eax, %edx
	movl	%edx, -20(%ebp)
.L637:
	movl	-20(%ebp), %eax
	shrl	$16, %eax
	testl	%eax, %eax
	jne	.L638
	movzwl	-20(%ebp), %eax
	notl	%eax
	leave
	ret
	.size	csum, .-csum
.globl icmp6_create
	.type	icmp6_create, @function
icmp6_create:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
	movb	%al, -20(%ebp)
	movb	%dl, -24(%ebp)
	movzbl	-20(%ebp), %eax
	movl	%eax, -32(%ebp)
	cmpl	$134, -32(%ebp)
	je	.L644
	cmpl	$134, -32(%ebp)
	jg	.L648
	cmpl	$1, -32(%ebp)
	jl	.L641
	cmpl	$4, -32(%ebp)
	jle	.L642
	cmpl	$133, -32(%ebp)
	je	.L643
	jmp	.L641
.L648:
	cmpl	$136, -32(%ebp)
	je	.L646
	cmpl	$136, -32(%ebp)
	jl	.L645
	cmpl	$137, -32(%ebp)
	je	.L647
	jmp	.L641
.L642:
	movl	$8, -4(%ebp)
	jmp	.L649
.L643:
	movl	$8, -4(%ebp)
	jmp	.L649
.L644:
	movl	$16, -4(%ebp)
	jmp	.L649
.L645:
	movl	$24, -4(%ebp)
	jmp	.L649
.L646:
	movl	$24, -4(%ebp)
	jmp	.L649
.L647:
	movl	$40, -4(%ebp)
	jmp	.L649
.L641:
	movl	$8, -4(%ebp)
.L649:
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L650
	movl	$0, -28(%ebp)
	jmp	.L651
.L650:
	movl	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	-8(%ebp), %edx
	movzbl	-20(%ebp), %eax
	movb	%al, (%edx)
	movl	-8(%ebp), %edx
	movzbl	-24(%ebp), %eax
	movb	%al, 1(%edx)
	movl	8(%ebp), %edx
	movl	-8(%ebp), %eax
	movl	%eax, (%edx)
	movl	-4(%ebp), %edx
	movl	8(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	-8(%ebp), %eax
	movl	%eax, -28(%ebp)
.L651:
	movl	-28(%ebp), %eax
	leave
	ret
	.size	icmp6_create, .-icmp6_create
	.section	.rodata
.LC120:
	.string	"out of memory\n"
.LC121:
	.string	"sendmsg: %s\n"
	.text
.globl icmp6_send
	.type	icmp6_send, @function
icmp6_send:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$136, %esp
	movl	12(%ebp), %eax
	movb	%al, -100(%ebp)
	movl	$0, -4(%ebp)
	movl	$1, -92(%ebp)
	cmpb	$0, -100(%ebp)
	je	.L654
	movzbl	-100(%ebp), %eax
	movl	%eax, -108(%ebp)
	jmp	.L655
.L654:
	movl	$64, -108(%ebp)
.L655:
	movl	-108(%ebp), %eax
	movl	%eax, -96(%ebp)
	movl	$28, 8(%esp)
	movl	$0, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movw	$10, -40(%ebp)
	movl	20(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -32(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -28(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -24(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -20(%ebp)
	movl	$58, (%esp)
	call	htons
	movw	%ax, -38(%ebp)
	movl	$20, 8(%esp)
	movl	$0, 4(%esp)
	leal	-88(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	16(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -88(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -84(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -80(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -76(%ebp)
	cmpl	$0, 8(%ebp)
	jle	.L656
	movl	8(%ebp), %eax
	movl	%eax, -72(%ebp)
.L656:
	movl	$32, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L657
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$14, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC120, (%esp)
	call	fwrite
	movl	$-12, -104(%ebp)
	jmp	.L658
.L657:
	movl	-12(%ebp), %eax
	movl	$32, (%eax)
	movl	-12(%ebp), %eax
	movl	$41, 4(%eax)
	movl	-12(%ebp), %eax
	movl	$50, 8(%eax)
	movl	-12(%ebp), %eax
	leal	12(%eax), %edx
	movl	$20, 8(%esp)
	leal	-88(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	-12(%ebp), %eax
	movl	%eax, -52(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, -48(%ebp)
	movl	24(%ebp), %eax
	movl	%eax, -60(%ebp)
	movl	28(%ebp), %eax
	movl	%eax, -56(%ebp)
	leal	-40(%ebp), %eax
	movl	%eax, -68(%ebp)
	movl	$32, -64(%ebp)
	movl	icmp6_sock+24, %edx
	movl	$4, 16(%esp)
	leal	-92(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$50, 8(%esp)
	movl	$41, 4(%esp)
	movl	%edx, (%esp)
	call	setsockopt
	movl	icmp6_sock+24, %edx
	movl	$4, 16(%esp)
	leal	-96(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$16, 8(%esp)
	movl	$41, 4(%esp)
	movl	%edx, (%esp)
	call	setsockopt
	movl	icmp6_sock+24, %edx
	movl	$4, 16(%esp)
	leal	-96(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$18, 8(%esp)
	movl	$41, 4(%esp)
	movl	%edx, (%esp)
	call	setsockopt
	movl	icmp6_sock+24, %edx
	movl	$0, 8(%esp)
	leal	-68(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	sendmsg
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L659
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC121, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
.L659:
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	free
	movl	-4(%ebp), %eax
	movl	%eax, -104(%ebp)
.L658:
	movl	-104(%ebp), %eax
	leave
	ret
	.size	icmp6_send, .-icmp6_send
	.section	.rodata
.LC122:
	.string	"cannot set IP_HDRINCL: %s\n"
.LC123:
	.string	"start sending ... \n"
.LC124:
	.string	"sending end. %d returned.\n"
	.text
	.type	ndisc_send_unspec, @function
ndisc_send_unspec:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$248, %esp
	movl	$1, -224(%ebp)
	movl	$255, 8(%esp)
	movl	$3, 4(%esp)
	movl	$10, (%esp)
	call	socket
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jns	.L662
	movl	$-1, -228(%ebp)
	jmp	.L663
.L662:
	movl	$4, 16(%esp)
	leal	-224(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$3, 8(%esp)
	movl	$41, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L664
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC122, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, %edx
	negl	%edx
	movl	%edx, -228(%ebp)
	jmp	.L663
.L664:
	movl	$64, 8(%esp)
	movl	$0, 4(%esp)
	leal	-124(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$28, 8(%esp)
	movl	$0, 4(%esp)
	leal	-180(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	cmpl	$135, 8(%ebp)
	jne	.L665
	movl	$24, -8(%ebp)
	movl	16(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -76(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -72(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -68(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -64(%ebp)
	leal	-180(%ebp), %eax
	addl	$8, %eax
	movl	%eax, 4(%esp)
	movl	16(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_addr_solict_mult
	jmp	.L666
.L665:
	cmpl	$133, 8(%ebp)
	jne	.L667
	movl	$8, -8(%ebp)
	movl	16(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -172(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -168(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -164(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -160(%ebp)
	jmp	.L666
.L667:
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-22, -228(%ebp)
	jmp	.L663
.L666:
	movb	$96, -124(%ebp)
	movl	-8(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movw	%ax, -120(%ebp)
	movb	$58, -118(%ebp)
	movb	$-1, -117(%ebp)
	movl	-172(%ebp), %eax
	movl	%eax, -100(%ebp)
	movl	-168(%ebp), %eax
	movl	%eax, -96(%ebp)
	movl	-164(%ebp), %eax
	movl	%eax, -92(%ebp)
	movl	-160(%ebp), %eax
	movl	%eax, -88(%ebp)
	movl	$40, 8(%esp)
	movl	$0, 4(%esp)
	leal	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	-172(%ebp), %eax
	movl	%eax, -44(%ebp)
	movl	-168(%ebp), %eax
	movl	%eax, -40(%ebp)
	movl	-164(%ebp), %eax
	movl	%eax, -36(%ebp)
	movl	-160(%ebp), %eax
	movl	%eax, -32(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	htonl
	movl	%eax, -28(%ebp)
	movb	$58, -21(%ebp)
	movl	8(%ebp), %eax
	movb	%al, -84(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-124(%ebp), %eax
	addl	$40, %eax
	movl	%eax, 4(%esp)
	leal	-60(%ebp), %eax
	movl	%eax, (%esp)
	call	csum
	movw	%ax, -82(%ebp)
	leal	-124(%ebp), %eax
	movl	%eax, -220(%ebp)
	movl	-8(%ebp), %eax
	addl	$40, %eax
	movl	%eax, -216(%ebp)
	movw	$10, -180(%ebp)
	leal	-180(%ebp), %eax
	movl	%eax, -152(%ebp)
	movl	$28, -148(%ebp)
	leal	-220(%ebp), %eax
	movl	%eax, -144(%ebp)
	movl	$1, -140(%ebp)
	movl	$0, -128(%ebp)
	movl	$32, 8(%esp)
	movl	$0, 4(%esp)
	leal	-212(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-212(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	-20(%ebp), %eax
	addl	$12, %eax
	movl	%eax, -16(%ebp)
	movl	12(%ebp), %edx
	movl	-16(%ebp), %eax
	movl	%edx, 16(%eax)
	movl	-20(%ebp), %eax
	movl	$32, (%eax)
	movl	-20(%ebp), %eax
	movl	$41, 4(%eax)
	movl	-20(%ebp), %eax
	movl	$50, 8(%eax)
	movl	-20(%ebp), %eax
	movl	%eax, -136(%ebp)
	movl	-20(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, -132(%ebp)
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$19, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC123, (%esp)
	call	fwrite
	movl	$0, 8(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	sendmsg
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L668
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC121, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
.L668:
	movl	stderr, %eax
	movl	-4(%ebp), %edx
	movl	%edx, 8(%esp)
	movl	$.LC124, 4(%esp)
	movl	%eax, (%esp)
	call	fprintf
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-4(%ebp), %eax
	movl	%eax, -228(%ebp)
.L663:
	movl	-228(%ebp), %eax
	leave
	ret
	.size	ndisc_send_unspec, .-ndisc_send_unspec
	.type	ipv6_addr_solict_mult, @function
ipv6_addr_solict_mult:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$32, %esp
	movl	$-16777216, (%esp)
	call	htonl
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	12(%eax), %eax
	movl	%edx, %esi
	orl	%eax, %esi
	movl	$1, (%esp)
	call	htonl
	movl	%eax, %ebx
	movl	$-16646144, (%esp)
	call	htonl
	movl	%esi, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	$0, 8(%esp)
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_addr_set
	addl	$32, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	ipv6_addr_solict_mult, .-ipv6_addr_solict_mult
	.type	ipv6_addr_set, @function
ipv6_addr_set:
	pushl	%ebp
	movl	%esp, %ebp
	movl	8(%ebp), %edx
	movl	12(%ebp), %eax
	movl	%eax, (%edx)
	movl	8(%ebp), %edx
	movl	16(%ebp), %eax
	movl	%eax, 4(%edx)
	movl	8(%ebp), %edx
	movl	20(%ebp), %eax
	movl	%eax, 8(%edx)
	movl	8(%ebp), %edx
	movl	24(%ebp), %eax
	movl	%eax, 12(%edx)
	popl	%ebp
	ret
	.size	ipv6_addr_set, .-ipv6_addr_set
	.type	nd_opt_create, @function
nd_opt_create:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	12(%ebp), %eax
	movl	16(%ebp), %edx
	movb	%al, -20(%ebp)
	movw	%dx, -24(%ebp)
	movl	$2, -4(%ebp)
	movzwl	-24(%ebp), %eax
	addl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L675
	movl	$0, -28(%ebp)
	jmp	.L676
.L675:
	movl	-8(%ebp), %edx
	movzbl	-20(%ebp), %eax
	movb	%al, (%edx)
	movzwl	-24(%ebp), %eax
	addl	-4(%ebp), %eax
	sarl	$3, %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	movb	%dl, 1(%eax)
	movzwl	-24(%ebp), %edx
	movl	-8(%ebp), %eax
	leal	2(%eax), %ecx
	movl	%edx, 8(%esp)
	movl	20(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	memcpy
	movl	8(%ebp), %edx
	movl	-8(%ebp), %eax
	movl	%eax, (%edx)
	movzwl	-24(%ebp), %eax
	addl	-4(%ebp), %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, 4(%eax)
	movl	-8(%ebp), %eax
	movl	%eax, -28(%ebp)
.L676:
	movl	-28(%ebp), %eax
	leave
	ret
	.size	nd_opt_create, .-nd_opt_create
	.section	.rodata
.LC125:
	.string	"nd_get_l2addr(SIOCGIFHWADDR)"
.LC126:
	.string	"Unsupported sa_family %d.\n"
	.text
	.type	nd_get_l2addr, @function
nd_get_l2addr:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$72, %esp
	movl	$0, 8(%esp)
	movl	$2, 4(%esp)
	movl	$17, (%esp)
	call	socket
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L679
	movl	$-1, -52(%ebp)
	jmp	.L680
.L679:
	movl	$32, 8(%esp)
	movl	$0, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	8(%ebp), %edx
	leal	-40(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	if_indextoname
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$35111, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	ioctl
	testl	%eax, %eax
	jns	.L681
	movl	$.LC125, (%esp)
	call	perror
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	$-1, -52(%ebp)
	jmp	.L680
.L681:
	movzwl	-24(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	nd_get_l2addr_len
	cwtl
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L682
	movzwl	-24(%ebp), %eax
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC126, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L683
.L682:
	cmpl	$0, -4(%ebp)
	jle	.L683
	movl	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-40(%ebp), %eax
	addl	$18, %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
.L683:
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-4(%ebp), %eax
	movl	%eax, -52(%ebp)
.L680:
	movl	-52(%ebp), %eax
	leave
	ret
	.size	nd_get_l2addr, .-nd_get_l2addr
	.type	nd_get_l2addr_len, @function
nd_get_l2addr_len:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$12, %esp
	movl	8(%ebp), %eax
	movw	%ax, -4(%ebp)
	movzwl	-4(%ebp), %eax
	movl	%eax, -12(%ebp)
	cmpl	$769, -12(%ebp)
	jg	.L690
	cmpl	$768, -12(%ebp)
	jge	.L689
	cmpl	$6, -12(%ebp)
	je	.L687
	cmpl	$6, -12(%ebp)
	jg	.L691
	cmpl	$1, -12(%ebp)
	je	.L687
	jmp	.L686
.L691:
	cmpl	$7, -12(%ebp)
	je	.L688
	cmpl	$512, -12(%ebp)
	je	.L689
	jmp	.L686
.L690:
	cmpl	$778, -12(%ebp)
	je	.L689
	cmpl	$778, -12(%ebp)
	jg	.L692
	cmpl	$774, -12(%ebp)
	je	.L687
	cmpl	$776, -12(%ebp)
	je	.L689
	jmp	.L686
.L692:
	movl	-12(%ebp), %eax
	subl	$800, %eax
	cmpl	$1, %eax
	ja	.L686
.L687:
	movw	$6, -6(%ebp)
	jmp	.L693
.L688:
	movw	$1, -6(%ebp)
	jmp	.L693
.L689:
	movw	$0, -6(%ebp)
	jmp	.L693
.L686:
	movw	$-1, -6(%ebp)
.L693:
	movzwl	-6(%ebp), %eax
	leave
	ret
	.size	nd_get_l2addr_len, .-nd_get_l2addr_len
.globl ndisc_send_ns
	.type	ndisc_send_ns, @function
ndisc_send_ns:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$104, %esp
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L696
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L696
	movl	12(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L696
	movl	12(%ebp), %eax
	addl	$12, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L696
	movl	20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$135, (%esp)
	call	ndisc_send_unspec
	movl	%eax, -68(%ebp)
	jmp	.L697
.L696:
	leal	-60(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	nd_get_l2addr
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L698
	movl	$-22, -68(%ebp)
	jmp	.L697
.L698:
	movl	$0, 8(%esp)
	movl	$135, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	icmp6_create
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L699
	movl	$-12, -68(%ebp)
	jmp	.L697
.L699:
	movl	-12(%ebp), %ecx
	movl	20(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, 8(%ecx)
	movl	4(%edx), %eax
	movl	%eax, 12(%ecx)
	movl	8(%edx), %eax
	movl	%eax, 16(%ecx)
	movl	12(%edx), %eax
	movl	%eax, 20(%ecx)
	cmpl	$0, -8(%ebp)
	jle	.L700
	movl	-8(%ebp), %eax
	movzwl	%ax, %edx
	leal	-60(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$1, 4(%esp)
	leal	-28(%ebp), %eax
	addl	$8, %eax
	movl	%eax, (%esp)
	call	nd_opt_create
	testl	%eax, %eax
	jne	.L700
	movl	$-12, -68(%ebp)
	jmp	.L697
.L700:
	movl	$2, 20(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$255, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	icmp6_send
	movl	%eax, -4(%ebp)
	movl	$2, 4(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	free_iov_data
	movl	-4(%ebp), %eax
	movl	%eax, -68(%ebp)
.L697:
	movl	-68(%ebp), %eax
	leave
	ret
	.size	ndisc_send_ns, .-ndisc_send_ns
	.type	free_iov_data, @function
free_iov_data:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movl	%eax, -4(%ebp)
	cmpl	$0, 8(%ebp)
	je	.L706
	jmp	.L704
.L705:
	movl	-4(%ebp), %eax
	sall	$3, %eax
	addl	8(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	je	.L704
	movl	-4(%ebp), %eax
	sall	$3, %eax
	addl	8(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	free
.L704:
	cmpl	$0, -4(%ebp)
	setne	%al
	subl	$1, -4(%ebp)
	testb	%al, %al
	jne	.L705
.L706:
	leave
	ret
	.size	free_iov_data, .-free_iov_data
.globl ndisc_send_rs
	.type	ndisc_send_rs, @function
ndisc_send_rs:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$104, %esp
	movl	12(%ebp), %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L708
	movl	12(%ebp), %eax
	addl	$4, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L708
	movl	12(%ebp), %eax
	addl	$8, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L708
	movl	12(%ebp), %eax
	addl	$12, %eax
	movl	(%eax), %eax
	testl	%eax, %eax
	jne	.L708
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$133, (%esp)
	call	ndisc_send_unspec
	movl	%eax, -68(%ebp)
	jmp	.L709
.L708:
	leal	-56(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	nd_get_l2addr
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L710
	movl	$-22, -68(%ebp)
	jmp	.L709
.L710:
	movl	$0, 8(%esp)
	movl	$133, 4(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	icmp6_create
	testl	%eax, %eax
	jne	.L711
	movl	$-12, -68(%ebp)
	jmp	.L709
.L711:
	cmpl	$0, -8(%ebp)
	jle	.L712
	movl	-8(%ebp), %eax
	movzwl	%ax, %edx
	leal	-56(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$1, 4(%esp)
	leal	-24(%ebp), %eax
	addl	$8, %eax
	movl	%eax, (%esp)
	call	nd_opt_create
	testl	%eax, %eax
	jne	.L712
	movl	$1, 4(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	free_iov_data
	movl	$-12, -68(%ebp)
	jmp	.L709
.L712:
	movl	$2, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$255, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	icmp6_send
	movl	%eax, -4(%ebp)
	movl	$2, 4(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	free_iov_data
	movl	-4(%ebp), %eax
	movl	%eax, -68(%ebp)
.L709:
	movl	-68(%ebp), %eax
	leave
	ret
	.size	ndisc_send_rs, .-ndisc_send_rs
.globl ndisc_send_na
	.type	ndisc_send_na, @function
ndisc_send_na:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$104, %esp
	movl	$16, 8(%esp)
	movl	$0, 4(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	leal	-56(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	nd_get_l2addr
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L715
	movl	$-22, -68(%ebp)
	jmp	.L716
.L715:
	movl	$0, 8(%esp)
	movl	$136, 4(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	icmp6_create
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L717
	movl	$-12, -68(%ebp)
	jmp	.L716
.L717:
	cmpl	$0, -4(%ebp)
	jle	.L718
	movl	-4(%ebp), %eax
	movzwl	%ax, %edx
	leal	-56(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	%edx, 8(%esp)
	movl	$2, 4(%esp)
	leal	-24(%ebp), %eax
	addl	$8, %eax
	movl	%eax, (%esp)
	call	nd_opt_create
	testl	%eax, %eax
	jne	.L718
	movl	$1, 4(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	free_iov_data
	movl	$-12, -68(%ebp)
	jmp	.L716
.L718:
	movl	-8(%ebp), %ecx
	movl	20(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, 8(%ecx)
	movl	4(%edx), %eax
	movl	%eax, 12(%ecx)
	movl	8(%edx), %eax
	movl	%eax, 16(%ecx)
	movl	12(%edx), %eax
	movl	%eax, 20(%ecx)
	movl	-8(%ebp), %edx
	movl	24(%ebp), %eax
	movl	%eax, 4(%edx)
	movl	$2, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$255, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	icmp6_send
	movl	$2, 4(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	free_iov_data
	movl	$0, -68(%ebp)
.L716:
	movl	-68(%ebp), %eax
	leave
	ret
	.size	ndisc_send_na, .-ndisc_send_na
.globl proxy_nd_start
	.type	proxy_nd_start, @function
proxy_nd_start:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$0, -8(%ebp)
	movl	-8(%ebp), %eax
	movzbl	%al, %edx
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	pneigh_add
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jne	.L721
	movl	20(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L721
	leal	-28(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_addr_llocal
	movl	-8(%ebp), %eax
	movzbl	%al, %edx
	leal	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	%edx, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	pneigh_add
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	.L721
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	pneigh_del
.L721:
	cmpl	$0, -12(%ebp)
	jne	.L722
	movl	$32, -4(%ebp)
	movl	-4(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$in6addr_all_nodes_mc, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ndisc_send_na
	movl	20(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L722
	movl	-4(%ebp), %eax
	movl	%eax, 16(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$in6addr_all_nodes_mc, 8(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	ndisc_send_na
.L722:
	movl	-12(%ebp), %eax
	leave
	ret
	.size	proxy_nd_start, .-proxy_nd_start
	.type	ipv6_addr_llocal, @function
ipv6_addr_llocal:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$32, %esp
	movl	8(%ebp), %eax
	movl	12(%eax), %esi
	movl	8(%ebp), %eax
	movl	8(%eax), %ebx
	movl	$-25165824, (%esp)
	call	htonl
	movl	%esi, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	$0, 8(%esp)
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_addr_set
	addl	$32, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	ipv6_addr_llocal, .-ipv6_addr_llocal
.globl proxy_nd_stop
	.type	proxy_nd_stop, @function
proxy_nd_stop:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	16(%ebp), %eax
	andl	$32, %eax
	testl	%eax, %eax
	je	.L727
	leal	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_addr_llocal
	leal	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	pneigh_del
	leal	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	neigh_del
.L727:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	pneigh_del
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	neigh_del
	leave
	ret
	.size	proxy_nd_stop, .-proxy_nd_stop
.globl mh_sock
	.bss
	.align 4
	.type	mh_sock, @object
	.size	mh_sock, 4
mh_sock:
	.zero	4
	.local	default_ifindex
	.comm	default_ifindex,2,2
	.local	mn_rule_mobile
	.comm	mn_rule_mobile,4,4
	.local	preferred_ifindex
	.comm	preferred_ifindex,2,2
	.local	current_ifindex
	.comm	current_ifindex,2,2
	.local	current_coa_type
	.comm	current_coa_type,1,1
	.data
	.align 4
	.type	__BU_SEQ__, @object
	.size	__BU_SEQ__, 4
__BU_SEQ__:
	.long	1
	.local	tnl44_ifindex
	.comm	tnl44_ifindex,2,2
	.local	tnl64_ifindex
	.comm	tnl64_ifindex,2,2
	.local	tnl66_ifindex
	.comm	tnl66_ifindex,2,2
	.type	_pad2.10358, @object
	.size	_pad2.10358, 2
_pad2.10358:
	.byte	1
	.byte	0
	.section	.rodata
.LC127:
	.string	"send bu failed!"
.LC128:
	.string	"[%02d:%02d:%02d] send bu.\n"
	.text
.globl sendbu
	.type	sendbu, @function
sendbu:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$164, %esp
	movl	$12, -84(%ebp)
	movl	-84(%ebp), %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -88(%ebp)
	movl	-88(%ebp), %eax
	movl	%eax, -28(%ebp)
	movl	-88(%ebp), %eax
	movl	%eax, -24(%ebp)
	movl	-28(%ebp), %eax
	movb	$59, (%eax)
	movl	-28(%ebp), %eax
	movb	$5, 2(%eax)
	movl	-28(%ebp), %eax
	movb	$0, 3(%eax)
	movl	-28(%ebp), %eax
	movw	$0, 4(%eax)
	movl	-28(%ebp), %eax
	movb	$3, 1(%eax)
	movl	20(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	htons
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movw	%dx, 6(%eax)
	movl	$192, (%esp)
	call	htons
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movw	%dx, 8(%eax)
	movl	$2500, (%esp)
	call	htons
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	movw	%dx, 10(%eax)
	movl	$2, -76(%ebp)
	movl	$_pad2.10358, -80(%ebp)
	movl	$18, -68(%ebp)
	movl	-68(%ebp), %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -72(%ebp)
	movl	-72(%ebp), %eax
	movl	%eax, -20(%ebp)
	movl	-20(%ebp), %eax
	movb	$3, (%eax)
	movl	-20(%ebp), %eax
	movb	$16, 1(%eax)
	movl	-20(%ebp), %ecx
	movl	16(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, 2(%ecx)
	movl	4(%edx), %eax
	movl	%eax, 6(%ecx)
	movl	8(%edx), %eax
	movl	%eax, 10(%ecx)
	movl	12(%edx), %eax
	movl	%eax, 14(%ecx)
	movw	$10, -64(%ebp)
	movl	8(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -56(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -52(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -48(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -44(%ebp)
	movl	$135, (%esp)
	call	htons
	movw	%ax, -62(%ebp)
	movl	12(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, -136(%ebp)
	movl	4(%edx), %eax
	movl	%eax, -132(%ebp)
	movl	8(%edx), %eax
	movl	%eax, -128(%ebp)
	movl	12(%edx), %eax
	movl	%eax, -124(%ebp)
	movl	$2, -120(%ebp)
	movl	$32, -32(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	malloc
	movl	%eax, -36(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$28, 8(%esp)
	movl	$0, 4(%esp)
	leal	-116(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	-36(%ebp), %eax
	movl	%eax, -100(%ebp)
	movl	-32(%ebp), %eax
	movl	%eax, -96(%ebp)
	leal	-88(%ebp), %eax
	movl	%eax, -108(%ebp)
	movl	$3, -104(%ebp)
	leal	-64(%ebp), %eax
	movl	%eax, -116(%ebp)
	movl	$28, -112(%ebp)
	movl	-32(%ebp), %edx
	movl	-36(%ebp), %eax
	movl	%edx, (%eax)
	movl	-36(%ebp), %eax
	movl	$41, 4(%eax)
	movl	-36(%ebp), %eax
	movl	$50, 8(%eax)
	movl	-36(%ebp), %eax
	leal	12(%eax), %edx
	movl	$20, 8(%esp)
	leal	-136(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	$135, 8(%esp)
	movl	$3, 4(%esp)
	movl	$10, (%esp)
	call	socket
	movl	%eax, -16(%ebp)
	movl	$4, -140(%ebp)
	movl	$4, 16(%esp)
	leal	-140(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$7, 8(%esp)
	movl	$255, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	je	.L730
	movl	$.LC127, (%esp)
	call	perror
.L730:
	call	__errno_location
	movl	$0, (%eax)
	call	tzset
	movl	$0, (%esp)
	call	time
	movl	%eax, -144(%ebp)
	leal	-144(%ebp), %eax
	movl	%eax, (%esp)
	call	localtime
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	(%eax), %ebx
	movl	-8(%ebp), %eax
	movl	4(%eax), %edx
	movl	-8(%ebp), %eax
	movl	8(%eax), %eax
	movl	stderr, %ecx
	movl	%ebx, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC128, 4(%esp)
	movl	%ecx, (%esp)
	call	fprintf
	movl	$0, 8(%esp)
	leal	-116(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	sendmsg
	movl	%eax, -12(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-12(%ebp), %eax
	addl	$164, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	sendbu, .-sendbu
.globl mh_cleanup
	.type	mh_cleanup, @function
mh_cleanup:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	mh_sock, %eax
	movl	%eax, (%esp)
	call	close
	leave
	ret
	.size	mh_cleanup, .-mh_cleanup
	.section	.rodata
.LC129:
	.string	"%d %s\n"
	.text
.globl mh_init
	.type	mh_init, @function
mh_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$1, -12(%ebp)
	movl	$135, 8(%esp)
	movl	$3, 4(%esp)
	movl	$10, (%esp)
	call	socket
	movl	%eax, -8(%ebp)
	movl	$4, 16(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$49, 8(%esp)
	movl	$41, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	movl	%eax, -4(%ebp)
	movl	$4, 16(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$58, 8(%esp)
	movl	$41, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	movl	%eax, -4(%ebp)
	movl	$4, 16(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$56, 8(%esp)
	movl	$41, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	movl	%eax, -4(%ebp)
	movl	$4, -12(%ebp)
	movl	$4, 16(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$7, 8(%esp)
	movl	$255, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	je	.L735
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	%eax, 8(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC129, (%esp)
	call	printf
.L735:
	movl	$1, -12(%ebp)
	movl	$4, 16(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$50, 8(%esp)
	movl	$41, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	movl	%eax, -4(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, mh_sock
	movl	-8(%ebp), %eax
	leave
	ret
	.size	mh_init, .-mh_init
	.section	.rodata
.LC130:
	.string	"w"
.LC131:
	.string	"%d"
	.text
.globl set_iface_proc_entry
	.type	set_iface_proc_entry, @function
set_iface_proc_entry:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$120, %esp
	movl	$-1, -4(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-88(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	movl	$.LC130, 4(%esp)
	leal	-88(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L738
	movl	-4(%ebp), %eax
	movl	%eax, -100(%ebp)
	jmp	.L739
.L738:
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC131, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	fprintf
	movl	%eax, -4(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
	movl	-4(%ebp), %eax
	movl	%eax, -100(%ebp)
.L739:
	movl	-100(%ebp), %eax
	leave
	ret
	.size	set_iface_proc_entry, .-set_iface_proc_entry
	.section	.rodata
	.align 4
.LC132:
	.string	"/proc/sys/net/ipv6/conf/%s/autoconf"
	.align 4
.LC133:
	.string	"/proc/sys/net/ipv6/conf/%s/accept_ra"
	.align 4
.LC134:
	.string	"/proc/sys/net/ipv6/conf/%s/router_solicitations"
	.align 4
.LC135:
	.string	"/proc/sys/net/ipv6/conf/%s/router_solicitation_interval"
	.text
	.type	iface_proc_entries_init, @function
iface_proc_entries_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$1, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC132, (%esp)
	call	set_iface_proc_entry
	movl	$1, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC133, (%esp)
	call	set_iface_proc_entry
	movl	$1, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC134, (%esp)
	call	set_iface_proc_entry
	movl	$1, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$.LC135, (%esp)
	call	set_iface_proc_entry
	leave
	ret
	.size	iface_proc_entries_init, .-iface_proc_entries_init
	.section	.rodata
	.align 4
.LC136:
	.string	"updating mobile route table ... \n"
	.align 4
.LC137:
	.string	"updating mobile route end ... \n"
	.text
.globl mobile_route_update
	.type	mobile_route_update, @function
mobile_route_update:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$0, -4(%ebp)
	movzwl	default_ifindex, %eax
	movzwl	%ax, %eax
	cmpl	8(%ebp), %eax
	jne	.L744
	movl	$4, 8(%esp)
	movl	$default_gateway, 4(%esp)
	leal	12(%ebp), %eax
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	je	.L745
.L744:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$33, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC136, (%esp)
	call	fwrite
	movzwl	default_ifindex, %eax
	testw	%ax, %ax
	je	.L746
	movzwl	default_ifindex, %eax
	movzwl	%ax, %edx
	movl	$default_gateway, 24(%esp)
	movl	$0, 20(%esp)
	leal	-4(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$250, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	default_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$32, 20(%esp)
	movl	$default_gateway, 16(%esp)
	movl	$0, 12(%esp)
	leal	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$250, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
.L746:
	movl	$0, 28(%esp)
	movl	$32, 24(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$0, 16(%esp)
	leal	-4(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	$250, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_add
	leal	12(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	$0, 24(%esp)
	leal	-4(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$0, 16(%esp)
	leal	-4(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	$250, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_add
	movl	$4, 8(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$default_gateway, (%esp)
	call	memcpy
	movl	8(%ebp), %eax
	movw	%ax, default_ifindex
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$31, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC137, (%esp)
	call	fwrite
.L745:
	movl	$0, %eax
	leave
	ret
	.size	mobile_route_update, .-mobile_route_update
.globl mobile_route_cleanup
	.type	mobile_route_cleanup, @function
mobile_route_cleanup:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$0, -4(%ebp)
	movzwl	default_ifindex, %eax
	testw	%ax, %ax
	je	.L749
	movl	default_gateway, %eax
	testl	%eax, %eax
	je	.L749
	movzwl	default_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$32, 20(%esp)
	movl	$default_gateway, 16(%esp)
	movl	$0, 12(%esp)
	leal	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$250, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	default_ifindex, %eax
	movzwl	%ax, %edx
	movl	$default_gateway, 24(%esp)
	movl	$0, 20(%esp)
	leal	-4(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-4(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$250, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
.L749:
	movw	$0, default_ifindex
	movl	$0, default_gateway
	movl	$0, %eax
	leave
	ret
	.size	mobile_route_cleanup, .-mobile_route_cleanup
	.section	.rodata
.LC138:
	.string	"add dstopt policy failed\n"
.LC139:
	.string	"add state failed\n"
	.text
.globl mn_dstopt_policies_add
	.type	mn_dstopt_policies_add, @function
mn_dstopt_policies_add:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$168, %esp
	movl	$hoav6, 8(%esp)
	movl	$hav6, 4(%esp)
	leal	-72(%ebp), %eax
	movl	%eax, (%esp)
	call	create_dstopt_tmpl
	leal	-128(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$5, 12(%esp)
	movl	$135, 8(%esp)
	movl	$hoav6, 4(%esp)
	movl	$hav6, (%esp)
	call	set_selector
	movl	$1, 24(%esp)
	leal	-72(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$3, 16(%esp)
	movl	$0, 12(%esp)
	movl	$1, 8(%esp)
	movl	$0, 4(%esp)
	leal	-128(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_mip_policy_add
	movl	%eax, -8(%ebp)
	cmpl	$0, -8(%ebp)
	jns	.L752
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$25, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC138, (%esp)
	call	fwrite
.L752:
	movl	$0, 16(%esp)
	movl	$0, 12(%esp)
	leal	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$60, 4(%esp)
	leal	-128(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_state_add
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L753
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$17, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC139, (%esp)
	call	fwrite
.L753:
	movl	-8(%ebp), %eax
	cmpl	-4(%ebp), %eax
	jne	.L754
	cmpl	$0, -4(%ebp)
	jne	.L754
	movl	$0, -132(%ebp)
	jmp	.L755
.L754:
	movl	$-1, -132(%ebp)
.L755:
	movl	-132(%ebp), %eax
	leave
	ret
	.size	mn_dstopt_policies_add, .-mn_dstopt_policies_add
	.type	create_dstopt_tmpl, @function
create_dstopt_tmpl:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$2, 12(%esp)
	movl	16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	_create_dstopt_tmpl
	leave
	ret
	.size	create_dstopt_tmpl, .-create_dstopt_tmpl
.globl mn_dstopt_policies_del
	.type	mn_dstopt_policies_del, @function
mn_dstopt_policies_del:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$168, %esp
	movl	$hoav6, 8(%esp)
	movl	$hav6, 4(%esp)
	leal	-72(%ebp), %eax
	movl	%eax, (%esp)
	call	create_dstopt_tmpl
	leal	-128(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	movl	$0, 16(%esp)
	movl	$5, 12(%esp)
	movl	$135, 8(%esp)
	movl	$hoav6, 4(%esp)
	movl	$hav6, (%esp)
	call	set_selector
	movl	$1, 4(%esp)
	leal	-128(%ebp), %eax
	movl	%eax, (%esp)
	call	xfrm_mip_policy_del
	movl	%eax, -8(%ebp)
	leal	-128(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$60, (%esp)
	call	xfrm_state_del
	movl	%eax, -4(%ebp)
	cmpl	$0, -8(%ebp)
	jne	.L760
	cmpl	$0, -4(%ebp)
	jne	.L760
	movl	$0, -132(%ebp)
	jmp	.L761
.L760:
	movl	$-1, -132(%ebp)
.L761:
	movl	-132(%ebp), %eax
	leave
	ret
	.size	mn_dstopt_policies_del, .-mn_dstopt_policies_del
	.section	.rodata
	.align 4
.LC140:
	.string	"not at home, start creating tunnels and handoff...\n"
.LC141:
	.string	"creating bypass rules .... \n"
.LC142:
	.string	"eth1"
	.text
.globl do_handoff
	.type	do_handoff, @function
do_handoff:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$232, %esp
	movl	16(%ebp), %eax
	movl	20(%ebp), %edx
	movw	%ax, -180(%ebp)
	movb	%dl, -184(%ebp)
	movl	$0, -20(%ebp)
	jmp	.L764
.L766:
	addl	$1, -20(%ebp)
.L764:
	cmpl	$2, -20(%ebp)
	jg	.L765
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	cmpw	-180(%ebp), %ax
	jne	.L766
.L765:
	cmpl	$3, -20(%ebp)
	jne	.L767
	movl	$-1, -188(%ebp)
	jmp	.L768
.L767:
	cmpb	$-1, -184(%ebp)
	jne	.L769
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$112, %eax
	addl	$ifaces, %eax
	leal	4(%eax), %edx
	movl	$16, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	jmp	.L770
.L769:
	cmpb	$1, -184(%ebp)
	jne	.L770
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	leal	8(%eax), %edx
	movl	$4, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
.L770:
	movzwl	preferred_ifindex, %eax
	cmpw	%ax, -180(%ebp)
	je	.L771
	movl	$0, -188(%ebp)
	jmp	.L768
.L771:
	cmpb	$-1, -184(%ebp)
	jne	.L772
	movzbl	current_coa_type, %eax
	cmpb	$-1, %al
	jne	.L772
	movl	$16, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$current_coav6, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L772
	movl	$0, -188(%ebp)
	jmp	.L768
.L772:
	movzbl	current_coa_type, %eax
	testb	%al, %al
	jne	.L773
	movl	$16, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$hoav6, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L773
	movl	$0, -188(%ebp)
	jmp	.L768
.L773:
	cmpb	$1, -184(%ebp)
	je	.L774
	cmpb	$2, -184(%ebp)
	jne	.L775
.L774:
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	je	.L776
	movzbl	current_coa_type, %eax
	cmpb	$2, %al
	jne	.L775
.L776:
	movl	$4, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$current_coav4, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L775
	movl	$0, -188(%ebp)
	jmp	.L768
.L775:
	movzwl	-180(%ebp), %eax
	movw	%ax, current_ifindex
	movl	$0, -24(%ebp)
	cmpb	$-1, -184(%ebp)
	jne	.L777
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$128, 20(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule_add
	movl	__BU_SEQ__, %eax
	movl	%eax, %edx
	addl	$1, %eax
	movl	%eax, __BU_SEQ__
	movl	%edx, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$hoav6, 4(%esp)
	movl	$hav6, (%esp)
	call	sendbu
	movl	$16, 8(%esp)
	movl	$hoav6, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L778
	movzbl	current_coa_type, %eax
	cmpb	$-1, %al
	jne	.L779
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movl	current_coav6, %eax
	movl	%eax, (%esp)
	movl	current_coav6+4, %eax
	movl	%eax, 4(%esp)
	movl	current_coav6+8, %eax
	movl	%eax, 8(%esp)
	movl	current_coav6+12, %eax
	movl	%eax, 12(%esp)
	call	mn_dstopt_policies_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel66_del
	movw	$0, tnl66_ifindex
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$128, 20(%esp)
	movl	$current_coav6, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule_del
	jmp	.L780
.L779:
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	je	.L781
	movzbl	current_coa_type, %eax
	cmpb	$2, %al
	jne	.L780
.L781:
	movl	mn_rule_mobile, %eax
	testl	%eax, %eax
	je	.L782
	movl	mn_rule_mobile, %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L783
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	$current_coav4, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$250, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
.L783:
	movl	mn_rule_mobile, %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L784
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	$current_coav4, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
.L784:
	movl	$0, mn_rule_mobile
.L782:
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	jne	.L785
	movl	$5, 24(%esp)
	movl	$666, 20(%esp)
	movl	$666, 16(%esp)
	movl	$hav4, 12(%esp)
	movl	$current_coav4, 8(%esp)
	movl	$hoav4, 4(%esp)
	movl	$hoav6, (%esp)
	call	stop_udp_encap
.L785:
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel64_del
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel44_del
	movw	$0, tnl44_ifindex
	movzwl	tnl44_ifindex, %eax
	movw	%ax, tnl64_ifindex
.L780:
	movb	$0, current_coa_type
	movl	$16, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$current_coav6, (%esp)
	call	memcpy
	movl	__BU_SEQ__, %eax
	movl	%eax, %edx
	addl	$1, %eax
	movl	%eax, __BU_SEQ__
	movl	%edx, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$hoav6, 4(%esp)
	movl	$hav6, (%esp)
	call	sendbu
	jmp	.L793
.L778:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$51, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC140, (%esp)
	call	fwrite
	movzwl	-180(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$hav6, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	tunnel66_add
	movl	%eax, -16(%ebp)
	movl	$100000, 24(%esp)
	movl	$100000, 20(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	$128, 4(%esp)
	movl	$hoav6, (%esp)
	call	addr_add
	movl	-16(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$32, 4(%esp)
	movl	$hoav4, (%esp)
	call	addr4_add
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$0, 16(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	$251, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_add
	movl	$0, 36(%esp)
	movl	$0, 32(%esp)
	movl	$in6addr_any, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$192, 16(%esp)
	movl	$0, 12(%esp)
	movl	$16, 8(%esp)
	movl	$251, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	route_add
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule4_add
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$0, 20(%esp)
	movl	$in6addr_any, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule_add
	movzbl	current_coa_type, %eax
	testb	%al, %al
	je	.L787
	movzbl	current_coa_type, %eax
	cmpb	$-1, %al
	jne	.L788
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movl	current_coav6, %eax
	movl	%eax, (%esp)
	movl	current_coav6+4, %eax
	movl	%eax, 4(%esp)
	movl	current_coav6+8, %eax
	movl	%eax, 8(%esp)
	movl	current_coav6+12, %eax
	movl	%eax, 12(%esp)
	call	mn_dstopt_policies_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel66_del
	movw	$0, tnl66_ifindex
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$128, 20(%esp)
	movl	$current_coav6, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule_del
	jmp	.L787
.L788:
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	je	.L789
	movzbl	current_coa_type, %eax
	cmpb	$2, %al
	jne	.L787
.L789:
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	jne	.L790
	movl	$5, 24(%esp)
	movl	$666, 20(%esp)
	movl	$666, 16(%esp)
	movl	$hav4, 12(%esp)
	movl	$current_coav4, 8(%esp)
	movl	$hoav4, 4(%esp)
	movl	$hoav6, (%esp)
	call	stop_udp_encap
.L790:
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel64_del
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel44_del
	movw	$0, tnl44_ifindex
	movzwl	tnl44_ifindex, %eax
	movw	%ax, tnl64_ifindex
	movl	mn_rule_mobile, %eax
	testl	%eax, %eax
	je	.L787
	movl	mn_rule_mobile, %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L791
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	$current_coav4, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$250, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
.L791:
	movl	mn_rule_mobile, %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L792
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	$current_coav4, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
.L792:
	movl	$0, mn_rule_mobile
.L787:
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$0, 16(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	$252, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_add
	movl	$0, 36(%esp)
	movl	$0, 32(%esp)
	movl	$in6addr_any, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$192, 16(%esp)
	movl	$0, 12(%esp)
	movl	$16, 8(%esp)
	movl	$252, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	route_add
	movl	8(%ebp), %edx
	movl	(%edx), %eax
	movl	%eax, (%esp)
	movl	4(%edx), %eax
	movl	%eax, 4(%esp)
	movl	8(%edx), %eax
	movl	%eax, 8(%esp)
	movl	12(%edx), %eax
	movl	%eax, 12(%esp)
	call	mn_dstopt_policies_add
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$251, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_del
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$251, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	route_del
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$0, 20(%esp)
	movl	$in6addr_any, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule_del
	movl	-16(%ebp), %eax
	movw	%ax, tnl66_ifindex
	movb	$-1, current_coa_type
	movl	$16, 8(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$current_coav6, (%esp)
	call	memcpy
	movl	__BU_SEQ__, %eax
	movl	%eax, %edx
	addl	$1, %eax
	movl	%eax, __BU_SEQ__
	movl	%edx, 12(%esp)
	movl	8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$hoav6, 4(%esp)
	movl	$hav6, (%esp)
	call	sendbu
	jmp	.L793
.L777:
	cmpb	$1, -184(%ebp)
	je	.L794
	cmpb	$2, -184(%ebp)
	jne	.L793
.L794:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_map_addr
	movl	$4, 8(%esp)
	movl	$hoav4, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L795
	movl	$-1, -188(%ebp)
	jmp	.L768
.L795:
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-56(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_map_addr
	movl	$hav4, 4(%esp)
	leal	-72(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_map_addr
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$28, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC141, (%esp)
	call	fwrite
	movl	$0, -4(%ebp)
	movzwl	-180(%ebp), %edx
	leal	-172(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	if_indextoname
	movl	$4, 8(%esp)
	movl	$.LC142, 4(%esp)
	leal	-172(%ebp), %eax
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L796
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$250, 4(%esp)
	movl	$0, (%esp)
	call	rule4_add
	movl	$4, -4(%ebp)
	jmp	.L797
.L796:
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule4_add
	movl	$8, -4(%ebp)
.L797:
	movl	mn_rule_mobile, %eax
	testl	%eax, %eax
	je	.L798
	movl	mn_rule_mobile, %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L799
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	$current_coav4, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$250, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
.L799:
	movl	mn_rule_mobile, %eax
	andl	$8, %eax
	testl	%eax, %eax
	je	.L798
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	$current_coav4, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
.L798:
	movl	-4(%ebp), %eax
	orl	$2, %eax
	movl	%eax, mn_rule_mobile
	movzwl	-180(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-72(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-56(%ebp), %eax
	movl	%eax, (%esp)
	call	tunnel64_add
	movl	%eax, -12(%ebp)
	movl	$100000, 24(%esp)
	movl	$100000, 20(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	movl	$128, 4(%esp)
	movl	$hoav6, (%esp)
	call	addr_add
	movzwl	-180(%ebp), %eax
	movl	%eax, 8(%esp)
	leal	-72(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-56(%ebp), %eax
	movl	%eax, (%esp)
	call	tunnel44_add
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$32, 4(%esp)
	movl	$hoav4, (%esp)
	call	addr4_add
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$0, 16(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	$251, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_add
	movl	$0, 36(%esp)
	movl	$0, 32(%esp)
	movl	$in6addr_any, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$192, 16(%esp)
	movl	$0, 12(%esp)
	movl	$16, 8(%esp)
	movl	$251, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	route_add
	cmpb	$1, -184(%ebp)
	jne	.L800
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	jne	.L801
	movl	$5, 24(%esp)
	movl	$666, 20(%esp)
	movl	$666, 16(%esp)
	movl	$hav4, 12(%esp)
	movl	$current_coav4, 8(%esp)
	movl	$hoav4, 4(%esp)
	movl	$hoav6, (%esp)
	call	stop_udp_encap
.L801:
	movl	$5, 24(%esp)
	movl	$666, 20(%esp)
	movl	$666, 16(%esp)
	movl	$hav4, 12(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$hoav4, 4(%esp)
	movl	$hoav6, (%esp)
	call	start_udp_encap
.L800:
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule4_add
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$0, 20(%esp)
	movl	$in6addr_any, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule_add
	movzbl	current_coa_type, %eax
	cmpb	$-1, %al
	jne	.L802
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movl	current_coav6, %eax
	movl	%eax, (%esp)
	movl	current_coav6+4, %eax
	movl	%eax, 4(%esp)
	movl	current_coav6+8, %eax
	movl	%eax, 8(%esp)
	movl	current_coav6+12, %eax
	movl	%eax, 12(%esp)
	call	mn_dstopt_policies_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel66_del
	movw	$0, tnl66_ifindex
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$128, 20(%esp)
	movl	$current_coav6, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule_del
	jmp	.L803
.L802:
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	je	.L804
	movzbl	current_coa_type, %eax
	cmpb	$2, %al
	jne	.L803
.L804:
	cmpb	$2, -184(%ebp)
	jne	.L805
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	jne	.L805
	movl	$5, 24(%esp)
	movl	$666, 20(%esp)
	movl	$666, 16(%esp)
	movl	$hav4, 12(%esp)
	movl	$current_coav4, 8(%esp)
	movl	$hoav4, 4(%esp)
	movl	$hoav6, (%esp)
	call	stop_udp_encap
.L805:
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel64_del
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel44_del
	movw	$0, tnl44_ifindex
	movzwl	tnl44_ifindex, %eax
	movw	%ax, tnl64_ifindex
.L803:
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$0, 16(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	$252, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_add
	movl	$0, 36(%esp)
	movl	$0, 32(%esp)
	movl	$in6addr_any, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$192, 16(%esp)
	movl	$0, 12(%esp)
	movl	$16, 8(%esp)
	movl	$252, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	route_add
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$251, 4(%esp)
	movl	-8(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_del
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$251, 4(%esp)
	movl	-12(%ebp), %eax
	movl	%eax, (%esp)
	call	route_del
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$0, 20(%esp)
	movl	$in6addr_any, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule_del
	movzbl	-184(%ebp), %eax
	movb	%al, current_coa_type
	movl	$4, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$current_coav4, (%esp)
	call	memcpy
	movl	-12(%ebp), %eax
	movw	%ax, tnl64_ifindex
	movl	-8(%ebp), %eax
	movw	%ax, tnl44_ifindex
	movl	__BU_SEQ__, %eax
	movl	%eax, %edx
	addl	$1, %eax
	movl	%eax, __BU_SEQ__
	movl	%edx, 12(%esp)
	leal	-40(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$hoav6, 4(%esp)
	movl	$hav6, (%esp)
	call	sendbu
.L793:
	movl	$0, -188(%ebp)
.L768:
	movl	-188(%ebp), %eax
	leave
	ret
	.size	do_handoff, .-do_handoff
.globl ap_off
	.type	ap_off, @function
ap_off:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	leave
	ret
	.size	ap_off, .-ap_off
.globl ap_move
	.type	ap_move, @function
ap_move:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	leave
	ret
	.size	ap_move, .-ap_move
	.section	.rodata
.LC143:
	.string	"IFF_RUNNING"
.LC144:
	.string	"IFF_NOT_RUNNING"
.LC145:
	.string	"IFF_UP"
.LC146:
	.string	"IFF_DOWN"
.LC147:
	.string	"LINK %d is up FLAG: %s %s\n"
.LC148:
	.string	"%s is up: "
.LC149:
	.string	"wlan card\n"
.LC150:
	.string	"eth0"
.LC151:
	.string	"gprs card\n"
.LC152:
	.string	"LINK %d is down \n"
	.text
	.type	process_link, @function
process_link:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$228, %esp
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$31, %eax
	ja	.L812
	movl	$-1, -208(%ebp)
	jmp	.L813
.L812:
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L814
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	je	.L814
	movl	$0, -208(%ebp)
	jmp	.L813
.L814:
	movl	-16(%ebp), %eax
	movzwl	2(%eax), %eax
	cmpw	$772, %ax
	je	.L815
	movl	-16(%ebp), %eax
	movzwl	2(%eax), %eax
	cmpw	$769, %ax
	je	.L815
	movl	-16(%ebp), %eax
	movzwl	2(%eax), %eax
	cmpw	$768, %ax
	je	.L815
	movl	-16(%ebp), %eax
	movzwl	2(%eax), %eax
	cmpw	$776, %ax
	jne	.L816
.L815:
	movl	$0, -208(%ebp)
	jmp	.L813
.L816:
	movl	$80, 8(%esp)
	movl	$0, 4(%esp)
	leal	-96(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	subl	$32, %eax
	movl	%eax, %edx
	movl	-16(%ebp), %eax
	addl	$16, %eax
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$19, 4(%esp)
	leal	-96(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_rtattr
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	cmpw	$16, %ax
	jne	.L817
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	andl	$64, %eax
	testl	%eax, %eax
	je	.L818
	movl	$.LC143, -204(%ebp)
	jmp	.L819
.L818:
	movl	$.LC144, -204(%ebp)
.L819:
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L820
	movl	$.LC145, -200(%ebp)
	jmp	.L821
.L820:
	movl	$.LC146, -200(%ebp)
.L821:
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	movl	stderr, %edx
	movl	-204(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-200(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC147, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, %edx
	leal	-196(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	if_indextoname
	movl	stderr, %edx
	leal	-196(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC148, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$4, 8(%esp)
	movl	$.LC142, 4(%esp)
	leal	-196(%ebp), %eax
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L822
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$10, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC149, (%esp)
	call	fwrite
	movl	$0, -12(%ebp)
	jmp	.L823
.L825:
	addl	$1, -12(%ebp)
.L823:
	cmpl	$2, -12(%ebp)
	jg	.L824
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jne	.L825
.L824:
	cmpl	$3, -12(%ebp)
	jne	.L826
	movl	$0, -12(%ebp)
	jmp	.L827
.L828:
	addl	$1, -12(%ebp)
.L827:
	cmpl	$2, -12(%ebp)
	jg	.L826
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	testw	%ax, %ax
	jne	.L828
.L826:
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jne	.L829
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+104(%eax), %edx
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	$65, %eax
	setne	%al
	movzbl	%al, %eax
	andl	%edx, %eax
	andl	$65, %eax
	testl	%eax, %eax
	je	.L841
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L841
	movzwl	preferred_ifindex, %eax
	testw	%ax, %ax
	jne	.L841
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	movw	%ax, preferred_ifindex
	jmp	.L841
.L829:
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	andl	$64, %eax
	testl	%eax, %eax
	je	.L841
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L841
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	movl	$172, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	memset
	movl	-12(%ebp), %ecx
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, %edx
	imull	$172, %ecx, %eax
	movw	%dx, ifaces(%eax)
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	leal	2(%eax), %edx
	leal	-196(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	strcpy
	movl	-12(%ebp), %ecx
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, %edx
	imull	$172, %ecx, %eax
	movl	%edx, ifaces+104(%eax)
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$1, ifaces+160(%eax)
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$0, ifaces+161(%eax)
	movl	-12(%ebp), %ebx
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, (%esp)
	call	raw_socket
	movl	%eax, %edx
	imull	$172, %ebx, %eax
	movw	%dx, ifaces+162(%eax)
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$1, ifaces+132(%eax)
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$1, ifaces+108(%eax)
	jmp	.L841
.L822:
	movl	$4, 8(%esp)
	movl	$.LC150, 4(%esp)
	leal	-196(%ebp), %eax
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L841
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$10, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC151, (%esp)
	call	fwrite
	movl	$0, -8(%ebp)
	jmp	.L833
.L835:
	addl	$1, -8(%ebp)
.L833:
	cmpl	$2, -8(%ebp)
	jg	.L834
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jne	.L835
.L834:
	cmpl	$3, -8(%ebp)
	jne	.L836
	movl	$0, -8(%ebp)
	jmp	.L837
.L838:
	addl	$1, -8(%ebp)
.L837:
	cmpl	$2, -8(%ebp)
	jg	.L836
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	testw	%ax, %ax
	jne	.L838
.L836:
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jne	.L839
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+104(%eax), %edx
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	cmpl	$65, %eax
	setne	%al
	movzbl	%al, %eax
	andl	%edx, %eax
	andl	$65, %eax
	testl	%eax, %eax
	jmp	.L841
.L839:
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	andl	$65, %eax
	cmpl	$65, %eax
	jne	.L841
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	movl	$172, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	memset
	movl	-8(%ebp), %ecx
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, %edx
	imull	$172, %ecx, %eax
	movw	%dx, ifaces(%eax)
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	leal	2(%eax), %edx
	leal	-196(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	strcpy
	movl	-8(%ebp), %ecx
	movl	-16(%ebp), %eax
	movl	8(%eax), %eax
	movl	%eax, %edx
	imull	$172, %ecx, %eax
	movl	%edx, ifaces+104(%eax)
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$1, ifaces+132(%eax)
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$1, ifaces+108(%eax)
	jmp	.L841
.L817:
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	cmpw	$17, %ax
	jne	.L841
	movl	-16(%ebp), %eax
	movl	4(%eax), %eax
	movl	stderr, %edx
	movl	%eax, 8(%esp)
	movl	$.LC152, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
.L841:
	movl	$0, -208(%ebp)
.L813:
	movl	-208(%ebp), %eax
	addl	$228, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	process_link, .-process_link
	.section	.rodata
	.align 4
.LC153:
	.string	"NEW ADDR %x:%x:%x:%x:%x:%x:%x:%x\n"
.LC154:
	.string	"IPv4 ADDR addeded:"
.LC155:
	.string	"rta_tb[IFA_ADDRESS] is NULL\n"
.LC156:
	.string	"%d.%d.%d.%d\n"
.LC157:
	.string	"check complete\n"
.LC158:
	.string	"adding rules\n"
	.align 4
.LC159:
	.string	"DEL ADDR %x:%x%x:%x:%x:%x:%x:%x\n"
.LC160:
	.string	"IPv4 ADDR deleted:"
.LC161:
	.string	"%d.%d.%d.%d(%d)\n"
	.text
	.type	process_addr, @function
process_addr:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$140, %esp
	movl	$0, -44(%ebp)
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	cmpl	$23, %eax
	ja	.L844
	movl	$-1, -112(%ebp)
	jmp	.L845
.L844:
	movl	8(%ebp), %eax
	addl	$16, %eax
	movl	%eax, -40(%ebp)
	movl	$32, 8(%esp)
	movl	$0, 4(%esp)
	leal	-76(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	8(%ebp), %eax
	movl	(%eax), %eax
	subl	$24, %eax
	movl	%eax, %edx
	movl	-40(%ebp), %eax
	addl	$8, %eax
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$7, 4(%esp)
	leal	-76(%ebp), %eax
	movl	%eax, (%esp)
	call	parse_rtattr
	movl	-72(%ebp), %eax
	testl	%eax, %eax
	jne	.L846
	movl	$-1, -112(%ebp)
	jmp	.L845
.L846:
	movl	-52(%ebp), %eax
	testl	%eax, %eax
	jne	.L847
	movl	-40(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$2, %al
	je	.L847
	movl	$-1, -112(%ebp)
	jmp	.L845
.L847:
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	cmpw	$20, %ax
	jne	.L848
	movl	-40(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	jne	.L849
	movl	-72(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -36(%ebp)
	movl	-36(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %ebx
	movl	-36(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %esi
	movl	-36(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edi
	movl	-36(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -108(%ebp)
	movl	-36(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -104(%ebp)
	movl	-36(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -100(%ebp)
	movl	-36(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -96(%ebp)
	movl	-36(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%ebx, 36(%esp)
	movl	%esi, 32(%esp)
	movl	%edi, 28(%esp)
	movl	-108(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-104(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-100(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-96(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC153, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	-40(%ebp), %eax
	movzbl	3(%eax), %eax
	testb	%al, %al
	jne	.L873
	movl	$0, -28(%ebp)
	jmp	.L851
.L853:
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	-40(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	je	.L852
	addl	$1, -28(%ebp)
.L851:
	cmpl	$2, -28(%ebp)
	jle	.L853
.L852:
	cmpl	$3, -28(%ebp)
	jne	.L854
	movl	$0, -28(%ebp)
	jmp	.L855
.L856:
	addl	$1, -28(%ebp)
.L855:
	cmpl	$2, -28(%ebp)
	jg	.L854
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	testw	%ax, %ax
	jne	.L856
.L854:
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	testw	%ax, %ax
	jne	.L857
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	movl	$172, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	memset
	movl	-28(%ebp), %ecx
	movl	-40(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, %edx
	imull	$172, %ecx, %eax
	movw	%dx, ifaces(%eax)
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	movl	$65, ifaces+104(%eax)
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	leal	2(%eax), %edx
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	if_indextoname
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	addl	$2, %eax
	movl	$4, 8(%esp)
	movl	$.LC150, 4(%esp)
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	je	.L858
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	addl	$2, %eax
	movl	$4, 8(%esp)
	movl	$.LC142, 4(%esp)
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	je	.L858
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	movl	$172, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	memset
	movl	$0, -112(%ebp)
	jmp	.L845
.L858:
	movl	-28(%ebp), %ecx
	movl	-28(%ebp), %edx
	imull	$172, %edx, %eax
	movb	$1, ifaces+132(%eax)
	imull	$172, %edx, %eax
	movzbl	ifaces+132(%eax), %edx
	imull	$172, %ecx, %eax
	movb	%dl, ifaces+108(%eax)
	movl	-28(%ebp), %ebx
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	addl	$2, %eax
	movl	$5, 8(%esp)
	movl	$.LC142, 4(%esp)
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	sete	%dl
	imull	$172, %ebx, %eax
	movb	%dl, ifaces+160(%eax)
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+160(%eax), %eax
	testb	%al, %al
	je	.L857
	movl	-28(%ebp), %ebx
	movl	-40(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, (%esp)
	call	raw_socket
	movl	%eax, %edx
	imull	$172, %ebx, %eax
	movw	%dx, ifaces+162(%eax)
.L857:
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$0, ifaces+108(%eax)
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$112, %eax
	addl	$ifaces, %eax
	leal	4(%eax), %edx
	movl	$16, 8(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movzwl	preferred_ifindex, %eax
	testw	%ax, %ax
	jne	.L859
	movl	-28(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	addl	$2, %eax
	movl	$5, 8(%esp)
	movl	$.LC142, 4(%esp)
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L859
	movl	-40(%ebp), %eax
	movl	4(%eax), %eax
	movw	%ax, preferred_ifindex
.L859:
	movl	-40(%ebp), %eax
	movl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	$255, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$0, 4(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, (%esp)
	call	do_handoff
	movl	%eax, -24(%ebp)
	jmp	.L873
.L849:
	movl	-40(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$2, %al
	jne	.L873
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$18, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC154, (%esp)
	call	fwrite
	movl	-72(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -32(%ebp)
	cmpl	$0, -32(%ebp)
	jne	.L861
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$28, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC155, (%esp)
	call	fwrite
	movl	$0, -112(%ebp)
	jmp	.L845
.L861:
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, %esi
	shrl	$24, %esi
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	andl	$16711680, %eax
	movl	%eax, %edx
	shrl	$16, %edx
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	andl	$65280, %eax
	movl	%eax, %ecx
	shrl	$8, %ecx
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	andl	$255, %eax
	movl	stderr, %ebx
	movl	%esi, 20(%esp)
	movl	%edx, 16(%esp)
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC156, 4(%esp)
	movl	%ebx, (%esp)
	call	fprintf
	movl	$0, -20(%ebp)
	jmp	.L862
.L864:
	addl	$1, -20(%ebp)
.L862:
	cmpl	$2, -20(%ebp)
	jg	.L863
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	-40(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jne	.L864
.L863:
	cmpl	$3, -20(%ebp)
	jne	.L865
	movl	$0, -20(%ebp)
	jmp	.L866
.L868:
	addl	$1, -20(%ebp)
.L866:
	cmpl	$2, -20(%ebp)
	jg	.L867
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	testw	%ax, %ax
	jne	.L868
.L867:
	cmpl	$3, -20(%ebp)
	jne	.L869
	movl	$-1, -112(%ebp)
	jmp	.L845
.L869:
	movl	-20(%ebp), %ecx
	movl	-40(%ebp), %eax
	movl	4(%eax), %eax
	movl	%eax, %edx
	imull	$172, %ecx, %eax
	movw	%dx, ifaces(%eax)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	leal	2(%eax), %edx
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %eax
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	if_indextoname
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	addl	$2, %eax
	movl	$4, 8(%esp)
	movl	$.LC150, 4(%esp)
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	je	.L870
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	addl	$2, %eax
	movl	$4, 8(%esp)
	movl	$.LC142, 4(%esp)
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	je	.L870
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	movl	$172, 8(%esp)
	movl	$0, 4(%esp)
	movl	%eax, (%esp)
	call	memset
	movl	$0, -112(%ebp)
	jmp	.L845
.L870:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$15, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC157, (%esp)
	call	fwrite
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$1, ifaces+108(%eax)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$0, ifaces+132(%eax)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movl	$65, ifaces+104(%eax)
	movl	-20(%ebp), %ebx
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	addl	$2, %eax
	movl	$4, 8(%esp)
	movl	$.LC150, 4(%esp)
	movl	%eax, (%esp)
	call	memcmp
	testl	%eax, %eax
	setne	%dl
	imull	$172, %ebx, %eax
	movb	%dl, ifaces+160(%eax)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+160(%eax), %eax
	testb	%al, %al
	je	.L871
	movl	-20(%ebp), %ebx
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	raw_socket
	movl	%eax, %edx
	imull	$172, %ebx, %eax
	movw	%dx, ifaces+162(%eax)
.L871:
	movl	-20(%ebp), %ecx
	movl	-32(%ebp), %eax
	movl	(%eax), %edx
	imull	$172, %ecx, %eax
	movl	%edx, ifaces+152(%eax)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$10, ifaces+161(%eax)
	movzwl	preferred_ifindex, %eax
	testw	%ax, %ax
	jne	.L865
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movw	%ax, preferred_ifindex
.L865:
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$13, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC158, (%esp)
	call	fwrite
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$0, ifaces+132(%eax)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	leal	8(%eax), %edx
	movl	$4, 8(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcmp
	testl	%eax, %eax
	je	.L872
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	testl	%eax, %eax
	je	.L872
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %ebx
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+148(%eax), %eax
	movl	%eax, (%esp)
	call	subnet_len
	movzbl	%al, %edx
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	addl	$8, %eax
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	addr4_del
.L872:
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	leal	8(%eax), %edx
	movl	$4, 8(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcpy
	movl	-40(%ebp), %eax
	movl	4(%eax), %edx
	movzwl	preferred_ifindex, %eax
	movzwl	%ax, %eax
	cmpl	%eax, %edx
	jne	.L873
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+108(%eax), %eax
	testb	%al, %al
	je	.L873
	movl	-40(%ebp), %eax
	movl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	$1, 12(%esp)
	movl	%eax, 8(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$0, (%esp)
	call	do_handoff
	jmp	.L873
.L848:
	movl	8(%ebp), %eax
	movzwl	4(%eax), %eax
	cmpw	$21, %ax
	jne	.L873
	movl	-40(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	jne	.L874
	movl	-72(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -36(%ebp)
	movl	-36(%ebp), %eax
	movzwl	14(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %ebx
	movl	-36(%ebp), %eax
	movzwl	12(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %esi
	movl	-36(%ebp), %eax
	movzwl	10(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edi
	movl	-36(%ebp), %eax
	movzwl	8(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -92(%ebp)
	movl	-36(%ebp), %eax
	movzwl	6(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -88(%ebp)
	movl	-36(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -84(%ebp)
	movl	-36(%ebp), %eax
	movzwl	2(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -80(%ebp)
	movl	-36(%ebp), %eax
	movzwl	(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%ebx, 36(%esp)
	movl	%esi, 32(%esp)
	movl	%edi, 28(%esp)
	movl	-92(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-88(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-84(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-80(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC159, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movzbl	current_coa_type, %eax
	cmpb	$-1, %al
	jne	.L873
	movl	-40(%ebp), %eax
	movl	4(%eax), %edx
	movzwl	current_ifindex, %eax
	movzwl	%ax, %eax
	cmpl	%eax, %edx
	jne	.L873
	movl	$16, 8(%esp)
	movl	-36(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$current_coav6, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L873
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-44(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-44(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movl	current_coav6, %eax
	movl	%eax, (%esp)
	movl	current_coav6+4, %eax
	movl	%eax, 4(%esp)
	movl	current_coav6+8, %eax
	movl	%eax, 8(%esp)
	movl	current_coav6+12, %eax
	movl	%eax, 12(%esp)
	call	mn_dstopt_policies_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel66_del
	movw	$0, tnl66_ifindex
	movb	$0, current_coa_type
	jmp	.L873
.L874:
	movl	-40(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$2, %al
	jne	.L873
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$18, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC160, (%esp)
	call	fwrite
	movl	-72(%ebp), %eax
	addl	$4, %eax
	movl	%eax, -32(%ebp)
	movl	-40(%ebp), %eax
	movl	4(%eax), %ebx
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	movl	%eax, %esi
	shrl	$24, %esi
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	andl	$16711680, %eax
	movl	%eax, %edi
	shrl	$16, %edi
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	andl	$65280, %eax
	movl	%eax, %edx
	shrl	$8, %edx
	movl	-32(%ebp), %eax
	movl	(%eax), %eax
	andl	$255, %eax
	movl	stderr, %ecx
	movl	%ebx, 24(%esp)
	movl	%esi, 20(%esp)
	movl	%edi, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC161, 4(%esp)
	movl	%ecx, (%esp)
	call	fprintf
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	je	.L876
	movzbl	current_coa_type, %eax
	cmpb	$2, %al
	jne	.L877
.L876:
	movl	-40(%ebp), %eax
	movl	4(%eax), %edx
	movzwl	current_ifindex, %eax
	movzwl	%ax, %eax
	cmpl	%eax, %edx
	jne	.L877
	movl	$4, 8(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$current_coav4, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L877
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	jne	.L878
	movl	$5, 24(%esp)
	movl	$666, 20(%esp)
	movl	$666, 16(%esp)
	movl	$hav4, 12(%esp)
	movl	$current_coav4, 8(%esp)
	movl	$hoav4, 4(%esp)
	movl	$hoav6, (%esp)
	call	stop_udp_encap
.L878:
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-44(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-44(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel64_del
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel44_del
	movw	$0, tnl44_ifindex
	movzwl	tnl44_ifindex, %eax
	movw	%ax, tnl64_ifindex
	movb	$0, current_coa_type
.L877:
	movl	$0, -16(%ebp)
	jmp	.L879
.L881:
	addl	$1, -16(%ebp)
.L879:
	cmpl	$2, -16(%ebp)
	jg	.L880
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	-40(%ebp), %eax
	movl	4(%eax), %eax
	cmpl	%eax, %edx
	jne	.L881
.L880:
	cmpl	$3, -16(%ebp)
	jne	.L882
	movl	$-1, -112(%ebp)
	jmp	.L845
.L882:
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	leal	8(%eax), %edx
	movl	$4, 8(%esp)
	movl	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L873
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movl	$0, ifaces+152(%eax)
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$1, ifaces+132(%eax)
.L873:
	movl	$0, -112(%ebp)
.L845:
	movl	-112(%ebp), %eax
	addl	$140, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	process_addr, .-process_addr
	.type	process_nlmsg, @function
process_nlmsg:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	12(%ebp), %eax
	movzwl	4(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, -4(%ebp)
	cmpl	$16, -4(%ebp)
	jl	.L885
	cmpl	$17, -4(%ebp)
	jle	.L886
	movl	-4(%ebp), %eax
	subl	$20, %eax
	cmpl	$1, %eax
	ja	.L885
	jmp	.L889
.L886:
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	process_link
	jmp	.L885
.L889:
	movl	16(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	12(%ebp), %eax
	movl	%eax, (%esp)
	call	process_addr
.L885:
	movl	$0, %eax
	leave
	ret
	.size	process_nlmsg, .-process_nlmsg
.globl md_init
	.type	md_init, @function
md_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$0, 4(%esp)
	movl	$md_rth, (%esp)
	call	rtnl_route_open
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L891
	movl	-4(%ebp), %eax
	movl	%eax, -20(%ebp)
	jmp	.L892
.L891:
	movl	$1, -8(%ebp)
	movl	md_rth, %eax
	movl	$4, 16(%esp)
	leal	-8(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$1, 8(%esp)
	movl	$270, 4(%esp)
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L893
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 12(%esp)
	movl	$1108, 8(%esp)
	movl	$.LC129, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -20(%ebp)
	jmp	.L892
.L893:
	movl	$9, -8(%ebp)
	movl	md_rth, %eax
	movl	$4, 16(%esp)
	leal	-8(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$1, 8(%esp)
	movl	$270, 4(%esp)
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L894
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 12(%esp)
	movl	$1114, 8(%esp)
	movl	$.LC129, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -20(%ebp)
	jmp	.L892
.L894:
	movl	$5, -8(%ebp)
	movl	md_rth, %eax
	movl	$4, 16(%esp)
	leal	-8(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$1, 8(%esp)
	movl	$270, 4(%esp)
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L895
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 12(%esp)
	movl	$1120, 8(%esp)
	movl	$.LC129, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -20(%ebp)
	jmp	.L892
.L895:
	movl	$12, -8(%ebp)
	movl	md_rth, %eax
	movl	$4, 16(%esp)
	leal	-8(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	$1, 8(%esp)
	movl	$270, 4(%esp)
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L896
	call	__errno_location
	movl	(%eax), %eax
	movl	%eax, (%esp)
	call	strerror
	movl	stderr, %edx
	movl	%eax, 12(%esp)
	movl	$1126, 8(%esp)
	movl	$.LC129, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	$-1, -20(%ebp)
	jmp	.L892
.L896:
	movl	$0, -20(%ebp)
.L892:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	md_init, .-md_init
	.type	rtnl_route_open, @function
rtnl_route_open:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	$0, 8(%esp)
	movl	12(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	rtnl_open_byproto
	leave
	ret
	.size	rtnl_route_open, .-rtnl_route_open
.globl md_cleanup
	.type	md_cleanup, @function
md_cleanup:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	md_rth, %eax
	movl	%eax, (%esp)
	call	close
	leave
	ret
	.size	md_cleanup, .-md_cleanup
.globl keepworking
	.data
	.align 4
	.type	keepworking, @object
	.size	keepworking, 4
keepworking:
	.long	1
	.text
.globl _sigint_handler
	.type	_sigint_handler, @function
_sigint_handler:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$0, keepworking
	popl	%ebp
	ret
	.size	_sigint_handler, .-_sigint_handler
	.section	.rodata
.LC162:
	.string	"socket"
	.align 4
.LC163:
	.string	"UDP encap. reception will be disabled\n"
.LC164:
	.string	"cannot resue\n"
.LC165:
	.string	"bind"
.LC166:
	.string	"setsockopt"
	.text
.globl listen_udpencap_init
	.type	listen_udpencap_init, @function
listen_udpencap_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$4, -8(%ebp)
	movl	$17, 8(%esp)
	movl	$2, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, -4(%ebp)
	cmpl	$0, -4(%ebp)
	jns	.L905
	movl	$.LC162, (%esp)
	call	perror
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$38, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC163, (%esp)
	call	fwrite
	jmp	.L909
.L905:
	movl	$16, 8(%esp)
	movl	$0, 4(%esp)
	leal	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$666, (%esp)
	call	htons
	movw	%ax, -22(%ebp)
	movl	$0, -20(%ebp)
	movl	$1, -28(%ebp)
	movl	$4, 16(%esp)
	leal	-28(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$1, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L907
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$13, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC164, (%esp)
	call	fwrite
.L907:
	leal	-24(%ebp), %eax
	movl	$16, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	bind
	testl	%eax, %eax
	je	.L908
	movl	$.LC165, (%esp)
	call	perror
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$38, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC163, (%esp)
	call	fwrite
	jmp	.L909
.L908:
	movl	$4, 16(%esp)
	leal	-8(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$100, 8(%esp)
	movl	$17, 4(%esp)
	movl	-4(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	je	.L909
	movl	$.LC166, (%esp)
	call	perror
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$38, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC163, (%esp)
	call	fwrite
.L909:
	leave
	ret
	.size	listen_udpencap_init, .-listen_udpencap_init
	.section	.rodata
.LC167:
	.string	"default"
	.text
.globl mn_init
	.type	mn_init, @function
mn_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	movl	$0, -8(%ebp)
	movl	$.LC167, (%esp)
	call	iface_proc_entries_init
	movl	$_sigint_handler, %eax
	movl	%eax, 4(%esp)
	movl	$2, (%esp)
	call	signal
	movl	$0, -4(%ebp)
	movl	$516, 8(%esp)
	movl	$0, 4(%esp)
	movl	$ifaces, (%esp)
	call	memset
	movl	$16, 8(%esp)
	movl	$0, 4(%esp)
	movl	$current_coav6, (%esp)
	call	memset
	movl	$4, 8(%esp)
	movl	$0, 4(%esp)
	movl	$current_coav4, (%esp)
	call	memset
	movb	$0, current_coa_type
	movw	$0, current_ifindex
	movw	$0, preferred_ifindex
	movw	$0, tnl66_ifindex
	movw	$0, tnl64_ifindex
	movw	$0, tnl44_ifindex
	movw	$0, default_ifindex
	movl	$0, default_gateway
	call	mh_init
	call	md_init
	call	tnl_init
	call	ctrl_init
	call	listen_udpencap_init
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-8(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	leal	-8(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$888, 8(%esp)
	movl	$252, 4(%esp)
	movl	$0, (%esp)
	call	rule4_add
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$0, 20(%esp)
	movl	$in6addr_any, 16(%esp)
	movl	$1, 12(%esp)
	movl	$888, 8(%esp)
	movl	$252, 4(%esp)
	movl	$0, (%esp)
	call	rule_add
	leave
	ret
	.size	mn_init, .-mn_init
.globl mn_cleanup
	.type	mn_cleanup, @function
mn_cleanup:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$68, %esp
	movl	$0, -12(%ebp)
	call	mh_cleanup
	call	md_cleanup
	movl	mn_rule_mobile, %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L913
	movl	mn_rule_mobile, %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L914
	movl	$250, -28(%ebp)
	jmp	.L915
.L914:
	movl	$254, -28(%ebp)
.L915:
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	$current_coav4, 16(%esp)
	movl	$1, 12(%esp)
	movl	$898, 8(%esp)
	movl	-28(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
.L913:
	movl	mn_rule_mobile, %eax
	andl	$2, %eax
	testl	%eax, %eax
	je	.L916
	movl	mn_rule_mobile, %eax
	andl	$4, %eax
	testl	%eax, %eax
	je	.L917
	movl	$250, -24(%ebp)
	jmp	.L918
.L917:
	movl	$254, -24(%ebp)
.L918:
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	movl	$current_coav4, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
.L916:
	movl	$0, mn_rule_mobile
	movzwl	tnl66_ifindex, %eax
	testw	%ax, %ax
	je	.L919
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movl	current_coav6, %eax
	movl	%eax, (%esp)
	movl	current_coav6+4, %eax
	movl	%eax, 4(%esp)
	movl	current_coav6+8, %eax
	movl	%eax, 8(%esp)
	movl	current_coav6+12, %eax
	movl	%eax, 12(%esp)
	call	mn_dstopt_policies_del
	movzwl	tnl66_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel66_del
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$128, 20(%esp)
	movl	$current_coav6, 16(%esp)
	movl	$1, 12(%esp)
	movl	$878, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule_del
.L919:
	movzwl	tnl64_ifindex, %eax
	testw	%ax, %ax
	je	.L920
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	$0, 28(%esp)
	movl	$0, 24(%esp)
	movl	$in6addr_any, 20(%esp)
	movl	$0, 16(%esp)
	movl	$in6addr_any, 12(%esp)
	movl	$192, 8(%esp)
	movl	$252, 4(%esp)
	movl	%eax, (%esp)
	call	route_del
	movzwl	tnl64_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel64_del
.L920:
	movzwl	tnl44_ifindex, %eax
	testw	%ax, %ax
	je	.L921
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %edx
	movl	$0, 24(%esp)
	movl	$0, 20(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$252, 4(%esp)
	movl	%edx, (%esp)
	call	route4_del
	movzwl	tnl44_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	tunnel44_del
.L921:
	movw	$0, tnl66_ifindex
	movw	$0, tnl44_ifindex
	movw	$0, tnl64_ifindex
	call	mobile_route_cleanup
	call	tnl_cleanup
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	leal	-12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$888, 8(%esp)
	movl	$252, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	movl	$in6addr_any, 24(%esp)
	movl	$0, 20(%esp)
	movl	$in6addr_any, 16(%esp)
	movl	$1, 12(%esp)
	movl	$888, 8(%esp)
	movl	$252, 4(%esp)
	movl	$0, (%esp)
	call	rule_del
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	jne	.L922
	movl	$5, 24(%esp)
	movl	$666, 20(%esp)
	movl	$666, 16(%esp)
	movl	$hav4, 12(%esp)
	movl	$current_coav4, 8(%esp)
	movl	$hoav4, 4(%esp)
	movl	$hoav6, (%esp)
	call	stop_udp_encap
.L922:
	movl	$0, -8(%ebp)
	jmp	.L923
.L925:
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	testw	%ax, %ax
	je	.L924
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	testl	%eax, %eax
	je	.L924
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %ebx
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+148(%eax), %eax
	movl	%eax, (%esp)
	call	subnet_len
	movzbl	%al, %edx
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	addl	$8, %eax
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	addr4_del
.L924:
	addl	$1, -8(%ebp)
.L923:
	cmpl	$2, -8(%ebp)
	jle	.L925
	addl	$68, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	mn_cleanup, .-mn_cleanup
.globl nat_probe_init
	.type	nat_probe_init, @function
nat_probe_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$4, %esp
	movl	$0, nat_fd
	leave
	ret
	.size	nat_probe_init, .-nat_probe_init
.globl nat_probe_cleanup
	.type	nat_probe_cleanup, @function
nat_probe_cleanup:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	nat_fd, %eax
	testl	%eax, %eax
	je	.L932
	movl	nat_fd, %eax
	movl	%eax, (%esp)
	call	close
.L932:
	leave
	ret
	.size	nat_probe_cleanup, .-nat_probe_cleanup
.globl nat_probe_fd_set
	.type	nat_probe_fd_set, @function
nat_probe_fd_set:
	pushl	%ebp
	movl	%esp, %ebp
	movl	12(%ebp), %eax
	popl	%ebp
	ret
	.size	nat_probe_fd_set, .-nat_probe_fd_set
.globl nat_probe_fd_check
	.type	nat_probe_fd_check, @function
nat_probe_fd_check:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$0, %eax
	popl	%ebp
	ret
	.size	nat_probe_fd_check, .-nat_probe_fd_check
	.section	.rodata
.LC168:
	.string	"udp rebind error\n"
.LC169:
	.string	"nat_probe sender bind"
.LC170:
	.string	"send nat probe error\n"
	.align 4
.LC171:
	.string	"[%02d:%02d:%02d] send nat probe.\n"
	.text
.globl nat_probe_send
	.type	nat_probe_send, @function
nat_probe_send:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$148, %esp
	movl	$1, -52(%ebp)
	movl	$16, 4(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, (%esp)
	call	bzero
	movw	$2, -32(%ebp)
	movl	hav4, %eax
	movl	%eax, -28(%ebp)
	movl	$667, (%esp)
	call	htons
	movw	%ax, -30(%ebp)
	movl	$17, 8(%esp)
	movl	$2, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, -16(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -44(%ebp)
	movl	$666, (%esp)
	call	htons
	movw	%ax, -46(%ebp)
	movl	$4, 16(%esp)
	leal	-52(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$2, 8(%esp)
	movl	$1, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	setsockopt
	testl	%eax, %eax
	jns	.L938
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$17, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC168, (%esp)
	call	fwrite
.L938:
	leal	-48(%ebp), %eax
	movl	$16, 8(%esp)
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	bind
	testl	%eax, %eax
	je	.L939
	movl	$.LC169, (%esp)
	call	perror
	movl	$0, -104(%ebp)
	jmp	.L940
.L939:
	movl	hoav6, %eax
	movl	%eax, -80(%ebp)
	movl	hoav6+4, %eax
	movl	%eax, -76(%ebp)
	movl	hoav6+8, %eax
	movl	%eax, -72(%ebp)
	movl	hoav6+12, %eax
	movl	%eax, -68(%ebp)
	movw	$666, -56(%ebp)
	movw	$12345, -54(%ebp)
	movl	8(%ebp), %eax
	movw	%ax, -60(%ebp)
	movl	12(%ebp), %eax
	movl	%eax, -64(%ebp)
	movzwl	-54(%ebp), %edx
	movzwl	-60(%ebp), %eax
	xorl	%eax, %edx
	movzwl	-56(%ebp), %eax
	xorl	%edx, %eax
	movw	%ax, -58(%ebp)
	movl	$0, -84(%ebp)
	cmpl	$0, 16(%ebp)
	je	.L941
	movl	16(%ebp), %eax
	movl	%eax, 28(%esp)
	movl	$0, 24(%esp)
	leal	-84(%ebp), %eax
	movl	%eax, 20(%esp)
	movl	$32, 16(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 12(%esp)
	movl	$0, 8(%esp)
	movl	$251, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_add
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-84(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule4_add
	jmp	.L942
.L941:
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-84(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule4_add
.L942:
	leal	-32(%ebp), %eax
	movl	$16, 20(%esp)
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$28, 8(%esp)
	leal	-80(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	sendto
	movl	%eax, -12(%ebp)
	cmpl	$-1, -12(%ebp)
	jne	.L943
	movl	$.LC170, (%esp)
	call	perror
	jmp	.L944
.L943:
	movl	$0, (%esp)
	call	time
	movl	%eax, -88(%ebp)
	leal	-88(%ebp), %eax
	movl	%eax, (%esp)
	call	localtime
	movl	%eax, -8(%ebp)
	movl	-8(%ebp), %eax
	movl	(%eax), %ecx
	movl	-8(%ebp), %eax
	movl	4(%eax), %ebx
	movl	-8(%ebp), %eax
	movl	8(%eax), %eax
	subl	$4, %eax
	movl	stderr, %edx
	movl	%ecx, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC171, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
.L944:
	cmpl	$0, 16(%ebp)
	je	.L945
	movl	16(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$0, 20(%esp)
	leal	-84(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$32, 12(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$251, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	route4_del
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-84(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$251, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
	jmp	.L946
.L945:
	movl	$0, 32(%esp)
	movl	$0, 28(%esp)
	leal	-84(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	$32, 20(%esp)
	leal	12(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$1, 12(%esp)
	movl	$887, 8(%esp)
	movl	$254, 4(%esp)
	movl	$0, (%esp)
	call	rule4_del
.L946:
	movl	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	close
	movl	-12(%ebp), %eax
	movl	%eax, -104(%ebp)
.L940:
	movl	-104(%ebp), %eax
	addl	$148, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	nat_probe_send, .-nat_probe_send
.globl nat_probe_worker
	.type	nat_probe_worker, @function
nat_probe_worker:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	call	uptime
	movl	%eax, -8(%ebp)
	movl	$0, -4(%ebp)
	movl	$0, -4(%ebp)
	jmp	.L949
.L953:
	movl	-4(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	testw	%ax, %ax
	je	.L950
	movl	-4(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+104(%eax), %eax
	andl	$65, %eax
	cmpl	$65, %eax
	jne	.L950
	movl	-4(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+132(%eax), %eax
	testb	%al, %al
	jne	.L950
	movl	-4(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+168(%eax), %edx
	movl	-8(%ebp), %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, %edx
	sarl	$31, %edx
	xorl	%edx, %eax
	subl	%edx, %eax
	cmpl	$60, %eax
	jle	.L950
	movl	-4(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+136(%eax), %eax
	testl	%eax, %eax
	je	.L951
	movl	-4(%ebp), %eax
	imull	$172, %eax, %eax
	subl	$-128, %eax
	addl	$ifaces, %eax
	addl	$8, %eax
	movl	%eax, -20(%ebp)
	jmp	.L952
.L951:
	movl	$0, -20(%ebp)
.L952:
	movl	-4(%ebp), %ecx
	movl	-4(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	imull	$172, %ecx, %eax
	movl	ifaces+152(%eax), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	nat_probe_send
	movl	-4(%ebp), %eax
	movl	-8(%ebp), %edx
	imull	$172, %eax, %eax
	movl	%edx, ifaces+168(%eax)
.L950:
	addl	$1, -4(%ebp)
.L949:
	cmpl	$2, -4(%ebp)
	jle	.L953
	leave
	ret
	.size	nat_probe_worker, .-nat_probe_worker
.globl ba_fd_init
	.type	ba_fd_init, @function
ba_fd_init:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$0, %eax
	popl	%ebp
	ret
	.size	ba_fd_init, .-ba_fd_init
.globl ba_fd_cleanup
	.type	ba_fd_cleanup, @function
ba_fd_cleanup:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$0, %eax
	popl	%ebp
	ret
	.size	ba_fd_cleanup, .-ba_fd_cleanup
.globl ba_fd_set
	.type	ba_fd_set, @function
ba_fd_set:
	pushl	%ebp
	movl	%esp, %ebp
	movl	12(%ebp), %eax
	popl	%ebp
	ret
	.size	ba_fd_set, .-ba_fd_set
.globl ba_fd_checker
	.type	ba_fd_checker, @function
ba_fd_checker:
	pushl	%ebp
	movl	%esp, %ebp
	movl	$0, %eax
	popl	%ebp
	ret
	.size	ba_fd_checker, .-ba_fd_checker
.globl bu_worker
	.type	bu_worker, @function
bu_worker:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$56, %esp
	call	uptime
	movl	%eax, -4(%ebp)
	movl	last_bu_t, %edx
	movl	-4(%ebp), %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	movl	%eax, %edx
	sarl	$31, %edx
	xorl	%edx, %eax
	subl	%edx, %eax
	cmpl	$10, %eax
	jle	.L964
	movzbl	current_coa_type, %eax
	cmpb	$-1, %al
	jne	.L965
	movl	__BU_SEQ__, %eax
	movl	%eax, %edx
	addl	$1, %eax
	movl	%eax, __BU_SEQ__
	movl	%edx, 12(%esp)
	movl	$current_coav6, 8(%esp)
	movl	$hoav6, 4(%esp)
	movl	$hav6, (%esp)
	call	sendbu
	jmp	.L966
.L965:
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	je	.L967
	movzbl	current_coa_type, %eax
	cmpb	$2, %al
	jne	.L966
.L967:
	movl	$current_coav4, 4(%esp)
	leal	-20(%ebp), %eax
	movl	%eax, (%esp)
	call	ipv6_map_addr
	movl	__BU_SEQ__, %eax
	movl	%eax, %edx
	addl	$1, %eax
	movl	%eax, __BU_SEQ__
	movl	%edx, 12(%esp)
	leal	-20(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$hoav6, 4(%esp)
	movl	$hav6, (%esp)
	call	sendbu
.L966:
	movl	-4(%ebp), %eax
	movl	%eax, last_bu_t
.L964:
	movl	$0, %eax
	leave
	ret
	.size	bu_worker, .-bu_worker
.globl ctrl_fd
	.bss
	.align 4
	.type	ctrl_fd, @object
	.size	ctrl_fd, 4
ctrl_fd:
	.zero	4
	.text
.globl ctrl_init
	.type	ctrl_init, @function
ctrl_init:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$40, %esp
	movl	$17, 8(%esp)
	movl	$2, 4(%esp)
	movl	$2, (%esp)
	call	socket
	movl	%eax, ctrl_fd
	movl	ctrl_fd, %eax
	testl	%eax, %eax
	jns	.L970
	movl	$.LC162, (%esp)
	call	perror
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$38, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC163, (%esp)
	call	fwrite
	movl	$-1, -20(%ebp)
	jmp	.L971
.L970:
	movl	$16, 8(%esp)
	movl	$0, 4(%esp)
	leal	-16(%ebp), %eax
	movl	%eax, (%esp)
	call	memset
	movl	$7777, (%esp)
	call	htons
	movw	%ax, -14(%ebp)
	movl	$0, -12(%ebp)
	leal	-16(%ebp), %eax
	movl	ctrl_fd, %edx
	movl	$16, 8(%esp)
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	bind
	testl	%eax, %eax
	je	.L972
	movl	$.LC165, (%esp)
	call	perror
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$38, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC163, (%esp)
	call	fwrite
	movl	$-1, -20(%ebp)
	jmp	.L971
.L972:
	movl	ctrl_fd, %eax
	movl	%eax, -20(%ebp)
.L971:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	ctrl_init, .-ctrl_init
.globl ctrl_fd_set
	.type	ctrl_fd_set, @function
ctrl_fd_set:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	ctrl_fd, %eax
	cmpl	%eax, 12(%ebp)
	jge	.L975
	movl	ctrl_fd, %eax
	movl	%eax, 12(%ebp)
.L975:
	movl	ctrl_fd, %eax
	shrl	$5, %eax
	movl	%eax, %ebx
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	ctrl_fd, %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	movl	$1, %eax
	sall	%cl, %eax
	orl	%edx, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax,%ebx,4)
	movl	12(%ebp), %eax
	popl	%ebx
	popl	%ebp
	ret
	.size	ctrl_fd_set, .-ctrl_fd_set
	.section	.rodata
.LC172:
	.string	"iface %d(%s):\n"
	.align 4
.LC173:
	.string	"[%c]IPV6 COA: %x:%x:%x:%x:%x:%x:%x:%x\n"
.LC174:
	.string	"[%c]IPV4 COA: %d.%d.%d.%d\n"
	.align 4
.LC175:
	.string	"system is already running on interface %d\n"
.LC176:
	.string	"moving to interface %d...\n"
.LC177:
	.string	"failed! no such interface!\n"
	.align 4
.LC178:
	.string	"have ipv6 address %x:%x:%x:%x:%x:%x:%x:%x, using it!\n"
	.align 4
.LC179:
	.string	"have ipv4 address %d.%d.%d.%d, using it!\n"
	.align 4
.LC180:
	.string	"interface found but the addresses there are not valid!I will wait to handoff to interface %d when the addresses areavailable!"
	.text
.globl ctrl_fd_check
	.type	ctrl_fd_check, @function
ctrl_fd_check:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$892, %esp
	cld
	movl	ctrl_fd, %eax
	movl	%eax, %edx
	shrl	$5, %edx
	movl	8(%ebp), %eax
	movl	(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	ctrl_fd, %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	movl	%edx, %eax
	shrl	%cl, %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L1000
	movl	$16, -52(%ebp)
	leal	-52(%ebp), %eax
	leal	-48(%ebp), %edx
	movl	ctrl_fd, %ecx
	movl	%eax, 20(%esp)
	movl	%edx, 16(%esp)
	movl	$0, 12(%esp)
	movl	$8, 8(%esp)
	leal	-32(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	recvfrom
	movl	%eax, -24(%ebp)
	leal	-452(%ebp), %eax
	movl	%eax, -848(%ebp)
	movl	$0, -852(%ebp)
	movl	$300, %eax
	cmpl	$4, %eax
	jb	.L979
	movl	$75, -856(%ebp)
	movl	-848(%ebp), %edi
	movl	-856(%ebp), %ecx
	movl	-852(%ebp), %eax
	rep stosl
.L979:
	movl	$0, -20(%ebp)
	movzwl	-28(%ebp), %eax
	movw	%ax, -758(%ebp)
	movzwl	-26(%ebp), %eax
	movw	%ax, -756(%ebp)
	movzwl	-32(%ebp), %eax
	movzwl	%ax, %eax
	movl	%eax, -840(%ebp)
	cmpl	$1, -840(%ebp)
	je	.L980
	cmpl	$2, -840(%ebp)
	je	.L981
	jmp	.L1000
.L980:
	movl	$0, -20(%ebp)
	jmp	.L982
.L990:
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	testw	%ax, %ax
	je	.L983
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	leal	2(%eax), %edx
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %eax
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC172, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+108(%eax), %eax
	testb	%al, %al
	jne	.L984
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+130(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -836(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+128(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -832(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+126(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -828(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+124(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -824(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+122(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -820(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+120(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -816(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+118(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -812(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+116(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -808(%ebp)
	movzbl	current_coa_type, %eax
	cmpb	$-1, %al
	jne	.L985
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$112, %eax
	addl	$ifaces, %eax
	addl	$4, %eax
	movl	$16, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$current_coav6, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L985
	movl	$120, -804(%ebp)
	jmp	.L986
.L985:
	movl	$111, -804(%ebp)
.L986:
	movl	-836(%ebp), %eax
	movl	%eax, 40(%esp)
	movl	-832(%ebp), %edx
	movl	%edx, 36(%esp)
	movl	-828(%ebp), %ecx
	movl	%ecx, 32(%esp)
	movl	-824(%ebp), %edi
	movl	%edi, 28(%esp)
	movl	-820(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	-816(%ebp), %edx
	movl	%edx, 20(%esp)
	movl	-812(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-808(%ebp), %edi
	movl	%edi, 12(%esp)
	movl	-804(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC173, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
.L984:
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+132(%eax), %eax
	testb	%al, %al
	jne	.L983
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	movl	%eax, %edx
	shrl	$24, %edx
	movl	%edx, -800(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	andl	$16711680, %eax
	movl	%eax, %ecx
	shrl	$16, %ecx
	movl	%ecx, -796(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	andl	$65280, %eax
	movl	%eax, %edi
	shrl	$8, %edi
	movl	%edi, -792(%ebp)
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	andl	$255, %eax
	movl	%eax, -788(%ebp)
	movzbl	current_coa_type, %eax
	cmpb	$1, %al
	je	.L987
	movzbl	current_coa_type, %eax
	cmpb	$2, %al
	jne	.L988
.L987:
	movl	-20(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	addl	$8, %eax
	movl	$4, 8(%esp)
	movl	%eax, 4(%esp)
	movl	$current_coav4, (%esp)
	call	memcmp
	testl	%eax, %eax
	jne	.L988
	movl	$120, -784(%ebp)
	jmp	.L989
.L988:
	movl	$111, -784(%ebp)
.L989:
	movl	-800(%ebp), %eax
	movl	%eax, 24(%esp)
	movl	-796(%ebp), %edx
	movl	%edx, 20(%esp)
	movl	-792(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-788(%ebp), %edi
	movl	%edi, 12(%esp)
	movl	-784(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC174, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
.L983:
	addl	$1, -20(%ebp)
.L982:
	cmpl	$2, -20(%ebp)
	jle	.L990
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movw	%ax, -754(%ebp)
	movl	$300, 8(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-758(%ebp), %eax
	addl	$6, %eax
	movl	%eax, (%esp)
	call	memcpy
	leal	-48(%ebp), %eax
	movl	ctrl_fd, %edx
	movl	$16, 20(%esp)
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$306, 8(%esp)
	leal	-758(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	sendto
	jmp	.L1000
.L981:
	movb	$0, -452(%ebp)
	movzwl	-30(%ebp), %eax
	movw	%ax, preferred_ifindex
	movzwl	current_ifindex, %edx
	movzwl	preferred_ifindex, %eax
	cmpw	%ax, %dx
	jne	.L991
	movzwl	preferred_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, 8(%esp)
	movl	$.LC175, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
	jmp	.L992
.L991:
	movzwl	preferred_ifindex, %eax
	movzwl	%ax, %eax
	movl	%eax, 8(%esp)
	movl	$.LC176, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
	movl	$0, -16(%ebp)
	movl	$0, -16(%ebp)
	jmp	.L993
.L995:
	addl	$1, -16(%ebp)
.L993:
	cmpl	$2, -16(%ebp)
	jg	.L994
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %edx
	movzwl	preferred_ifindex, %eax
	cmpw	%ax, %dx
	jne	.L995
.L994:
	cmpl	$3, -16(%ebp)
	jne	.L996
	movl	$28, 8(%esp)
	movl	$.LC177, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	memcpy
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
	jmp	.L992
.L996:
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+108(%eax), %eax
	testb	%al, %al
	jne	.L997
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+130(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %ebx
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+128(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %esi
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+126(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edi
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+124(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -780(%ebp)
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+122(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -776(%ebp)
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+120(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -772(%ebp)
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+118(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -768(%ebp)
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+116(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%ebx, 36(%esp)
	movl	%esi, 32(%esp)
	movl	%edi, 28(%esp)
	movl	-780(%ebp), %edx
	movl	%edx, 24(%esp)
	movl	-776(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-772(%ebp), %edi
	movl	%edi, 16(%esp)
	movl	-768(%ebp), %edx
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC178, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %ecx
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	leal	8(%eax), %edx
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$112, %eax
	addl	$ifaces, %eax
	addl	$4, %eax
	movl	$255, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	do_handoff
	jmp	.L992
.L997:
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+132(%eax), %eax
	testb	%al, %al
	jne	.L998
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	movl	%eax, %ecx
	shrl	$24, %ecx
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	andl	$16711680, %eax
	movl	%eax, %ebx
	shrl	$16, %ebx
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	andl	$65280, %eax
	movl	%eax, %edx
	shrl	$8, %edx
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	andl	$255, %eax
	movl	%ecx, 20(%esp)
	movl	%ebx, 16(%esp)
	movl	%edx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC179, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %ecx
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	leal	8(%eax), %edx
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$112, %eax
	addl	$ifaces, %eax
	addl	$4, %eax
	movl	$1, 12(%esp)
	movl	%ecx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	do_handoff
	jmp	.L992
.L998:
	movl	-16(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, 8(%esp)
	movl	$.LC180, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	sprintf
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strcat
.L992:
	leal	-452(%ebp), %eax
	movl	%eax, (%esp)
	call	strlen
	movw	%ax, -754(%ebp)
	movl	$300, 8(%esp)
	leal	-452(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-758(%ebp), %eax
	addl	$6, %eax
	movl	%eax, (%esp)
	call	memcpy
	leal	-48(%ebp), %eax
	movl	ctrl_fd, %edx
	movl	$16, 20(%esp)
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$306, 8(%esp)
	leal	-758(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	sendto
.L1000:
	addl	$892, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	ctrl_fd_check, .-ctrl_fd_check
.globl ctrl_cleanup
	.type	ctrl_cleanup, @function
ctrl_cleanup:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$8, %esp
	movl	ctrl_fd, %eax
	movl	%eax, (%esp)
	call	close
	leave
	ret
	.size	ctrl_cleanup, .-ctrl_cleanup
.globl dhcp_fd_set
	.type	dhcp_fd_set, @function
dhcp_fd_set:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$16, %esp
	movl	$0, -8(%ebp)
	jmp	.L1004
.L1006:
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+104(%eax), %eax
	andl	$65, %eax
	cmpl	$65, %eax
	jne	.L1005
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+160(%eax), %eax
	testb	%al, %al
	je	.L1005
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+162(%eax), %eax
	testw	%ax, %ax
	je	.L1005
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+162(%eax), %eax
	shrw	$5, %ax
	movzwl	%ax, %ebx
	movzwl	%ax, %edx
	movl	8(%ebp), %eax
	movl	(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+162(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	movl	$1, %eax
	sall	%cl, %eax
	orl	%edx, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax,%ebx,4)
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+162(%eax), %eax
	movzwl	%ax, %eax
	cmpl	12(%ebp), %eax
	jle	.L1005
	movl	-8(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+162(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, 12(%ebp)
.L1005:
	addl	$1, -8(%ebp)
.L1004:
	cmpl	$2, -8(%ebp)
	jle	.L1006
	movl	12(%ebp), %eax
	addl	$16, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	dhcp_fd_set, .-dhcp_fd_set
.globl subnet_len
	.type	subnet_len, @function
subnet_len:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$20, %esp
	movl	8(%ebp), %eax
	testl	%eax, %eax
	jne	.L1009
	movl	$0, -20(%ebp)
	jmp	.L1010
.L1009:
	movl	$0, -4(%ebp)
	jmp	.L1011
.L1012:
	addl	$1, -4(%ebp)
.L1011:
	movl	8(%ebp), %edx
	movl	-4(%ebp), %ecx
	movl	$1, %eax
	sall	%cl, %eax
	testl	%eax, %eax
	sete	%al
	movzbl	%al, %eax
	andl	%edx, %eax
	testl	%eax, %eax
	jne	.L1012
	movl	$32, %eax
	movl	%eax, %edx
	subl	-4(%ebp), %edx
	movl	%edx, -20(%ebp)
.L1010:
	movl	-20(%ebp), %eax
	leave
	ret
	.size	subnet_len, .-subnet_len
	.section	.rodata
	.align 4
.LC181:
	.string	"coav4 changed, deleting the old ones and add new one\n"
	.text
.globl dhcp_fd_check
	.type	dhcp_fd_check, @function
dhcp_fd_check:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	subl	$596, %esp
	movl	$0, -24(%ebp)
	jmp	.L1015
.L1023:
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+104(%eax), %eax
	andl	$65, %eax
	cmpl	$65, %eax
	jne	.L1016
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+160(%eax), %eax
	testb	%al, %al
	je	.L1016
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+162(%eax), %eax
	shrw	$5, %ax
	movzwl	%ax, %edx
	movl	8(%ebp), %eax
	movl	(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+162(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	movl	%edx, %eax
	shrl	%cl, %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L1016
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces+162(%eax), %eax
	movzwl	%ax, %eax
	movl	%eax, 4(%esp)
	leal	-572(%ebp), %eax
	movl	%eax, (%esp)
	call	get_raw_packet
	movl	%eax, -20(%ebp)
	cmpl	$0, -20(%ebp)
	jle	.L1016
	movl	-568(%ebp), %edx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+164(%eax), %eax
	cmpl	%eax, %edx
	jne	.L1016
	movl	$53, 4(%esp)
	leal	-572(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$2, %al
	je	.L1017
	movl	-16(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$5, %al
	jne	.L1016
.L1017:
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$0, ifaces+161(%eax)
	movl	$3, 4(%esp)
	leal	-572(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	subl	$-128, %eax
	addl	$ifaces, %eax
	addl	$8, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	$54, 4(%esp)
	leal	-572(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+148(%eax), %eax
	movl	%eax, (%esp)
	call	subnet_len
	movl	%eax, -12(%ebp)
	movl	$1, 4(%esp)
	leal	-572(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	addl	$4, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	$6, 4(%esp)
	leal	-572(%ebp), %eax
	movl	%eax, (%esp)
	call	get_option
	movl	%eax, %edx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	subl	$-128, %eax
	addl	$ifaces, %eax
	addl	$12, %eax
	movl	$4, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	memcpy
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %edx
	movl	-556(%ebp), %eax
	cmpl	%eax, %edx
	je	.L1018
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	testl	%eax, %eax
	je	.L1019
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$53, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC181, (%esp)
	call	fwrite
.L1019:
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %ebx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+148(%eax), %eax
	movl	%eax, (%esp)
	call	subnet_len
	movzbl	%al, %edx
	leal	-572(%ebp), %eax
	addl	$16, %eax
	movl	%ebx, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	addr4_add
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %eax
	testl	%eax, %eax
	je	.L1020
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	-12(%ebp), %eax
	movzbl	%al, %ecx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$144, %eax
	addl	$ifaces, %eax
	addl	$8, %eax
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	addr4_del
.L1020:
	movl	-24(%ebp), %eax
	movl	-556(%ebp), %edx
	imull	$172, %eax, %eax
	movl	%edx, ifaces+152(%eax)
.L1018:
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %edx
	movzwl	default_ifindex, %eax
	cmpw	%ax, %dx
	je	.L1021
	movzwl	default_ifindex, %eax
	testw	%ax, %ax
	jne	.L1022
.L1021:
	movl	-24(%ebp), %edx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %ecx
	imull	$172, %edx, %eax
	movl	ifaces+136(%eax), %eax
	movl	%eax, 4(%esp)
	movl	%ecx, (%esp)
	call	mobile_route_update
.L1022:
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movb	$0, ifaces+132(%eax)
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	subl	$-128, %eax
	addl	$ifaces, %eax
	leal	8(%eax), %ecx
	movl	-24(%ebp), %ebx
	movl	-24(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %edx
	movl	%ecx, 8(%esp)
	imull	$172, %ebx, %eax
	movl	ifaces+152(%eax), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	nat_probe_send
	call	uptime
	movl	%eax, -8(%ebp)
	movl	-24(%ebp), %eax
	movl	-8(%ebp), %edx
	imull	$172, %eax, %eax
	movl	%edx, ifaces+168(%eax)
.L1016:
	addl	$1, -24(%ebp)
.L1015:
	cmpl	$2, -24(%ebp)
	jle	.L1023
	movl	$0, %eax
	addl	$596, %esp
	popl	%ebx
	popl	%ebp
	ret
	.size	dhcp_fd_check, .-dhcp_fd_check
.globl dhcp_worker
	.type	dhcp_worker, @function
dhcp_worker:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%esi
	pushl	%ebx
	subl	$48, %esp
	call	uptime
	movl	%eax, -16(%ebp)
	movl	$0, -12(%ebp)
	jmp	.L1026
.L1032:
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+104(%eax), %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L1027
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+160(%eax), %eax
	testb	%al, %al
	je	.L1027
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+108(%eax), %eax
	testb	%al, %al
	je	.L1027
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+132(%eax), %eax
	testb	%al, %al
	jne	.L1028
	movl	-16(%ebp), %edx
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+156(%eax), %eax
	movl	%edx, %ecx
	subl	%eax, %ecx
	movl	%ecx, %eax
	cmpl	$29, %eax
	jbe	.L1027
	jmp	.L1029
.L1028:
	movl	-16(%ebp), %edx
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+156(%eax), %eax
	cmpl	%eax, %edx
	je	.L1027
.L1029:
	movl	-12(%ebp), %eax
	movl	-16(%ebp), %edx
	imull	$172, %eax, %eax
	movl	%edx, ifaces+156(%eax)
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+132(%eax), %eax
	testb	%al, %al
	jne	.L1030
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzbl	ifaces+161(%eax), %eax
	cmpb	$3, %al
	jbe	.L1031
.L1030:
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	$887617890, ifaces+164(%eax)
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %ebx
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+164(%eax), %edx
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	leal	2(%eax), %ecx
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %eax
	movl	%ebx, 12(%esp)
	movl	%edx, 8(%esp)
	movl	%ecx, 4(%esp)
	movl	%eax, (%esp)
	call	send_discover
	jmp	.L1027
.L1031:
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+152(%eax), %ecx
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+144(%eax), %ebx
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movl	ifaces+164(%eax), %esi
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	addl	$ifaces, %eax
	leal	2(%eax), %edx
	movl	-12(%ebp), %eax
	imull	$172, %eax, %eax
	movzwl	ifaces(%eax), %eax
	movzwl	%ax, %eax
	movl	%ecx, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	%esi, 8(%esp)
	movl	%edx, 4(%esp)
	movl	%eax, (%esp)
	call	send_selecting
	movl	-12(%ebp), %ecx
	imull	$172, %ecx, %eax
	movzbl	ifaces+161(%eax), %eax
	leal	1(%eax), %edx
	imull	$172, %ecx, %eax
	movb	%dl, ifaces+161(%eax)
.L1027:
	addl	$1, -12(%ebp)
.L1026:
	cmpl	$2, -12(%ebp)
	jle	.L1032
	movl	$0, %eax
	addl	$48, %esp
	popl	%ebx
	popl	%esi
	popl	%ebp
	ret
	.size	dhcp_worker, .-dhcp_worker
.globl link_event_fd_set
	.type	link_event_fd_set, @function
link_event_fd_set:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ebx
	movl	md_rth, %eax
	cmpl	12(%ebp), %eax
	jle	.L1035
	movl	md_rth, %eax
	movl	%eax, 12(%ebp)
.L1035:
	movl	md_rth, %eax
	shrl	$5, %eax
	movl	%eax, %ebx
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	md_rth, %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	movl	$1, %eax
	sall	%cl, %eax
	orl	%edx, %eax
	movl	%eax, %edx
	movl	8(%ebp), %eax
	movl	%edx, (%eax,%ebx,4)
	movl	12(%ebp), %eax
	popl	%ebx
	popl	%ebp
	ret
	.size	link_event_fd_set, .-link_event_fd_set
.globl link_event_fd_check
	.type	link_event_fd_check, @function
link_event_fd_check:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$24, %esp
	movl	md_rth, %eax
	movl	%eax, %edx
	shrl	$5, %edx
	movl	8(%ebp), %eax
	movl	(%eax,%edx,4), %eax
	movl	%eax, %edx
	movl	md_rth, %eax
	movl	%eax, %ecx
	andl	$31, %ecx
	movl	%edx, %eax
	shrl	%cl, %eax
	andl	$1, %eax
	testb	%al, %al
	je	.L1038
	movl	$0, 8(%esp)
	movl	$process_nlmsg, 4(%esp)
	movl	$md_rth, (%esp)
	call	rtnl_listen
.L1038:
	movl	$0, %eax
	leave
	ret
	.size	link_event_fd_check, .-link_event_fd_check
	.section	.rodata
.LC182:
	.string	"existing from mn_worker ... \n"
	.text
.globl mn_worker
	.type	mn_worker, @function
mn_worker:
	pushl	%ebp
	movl	%esp, %ebp
	subl	$184, %esp
	jmp	.L1041
.L1045:
	movl	$0, -16(%ebp)
	leal	-152(%ebp), %eax
	movl	%eax, -4(%ebp)
	movl	$0, -8(%ebp)
	jmp	.L1042
.L1043:
	movl	-8(%ebp), %edx
	movl	-4(%ebp), %eax
	movl	$0, (%eax,%edx,4)
	addl	$1, -8(%ebp)
.L1042:
	cmpl	$31, -8(%ebp)
	jbe	.L1043
	movl	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	link_event_fd_set
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	dhcp_fd_set
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	nat_probe_fd_set
	movl	%eax, -16(%ebp)
	movl	-16(%ebp), %eax
	movl	%eax, 4(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	ctrl_fd_set
	movl	%eax, -16(%ebp)
	movl	$1, -24(%ebp)
	movl	$0, -20(%ebp)
	movl	-16(%ebp), %eax
	leal	1(%eax), %edx
	leal	-24(%ebp), %eax
	movl	%eax, 16(%esp)
	movl	$0, 12(%esp)
	movl	$0, 8(%esp)
	leal	-152(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	%edx, (%esp)
	call	select
	movl	%eax, -12(%ebp)
	cmpl	$0, -12(%ebp)
	jle	.L1044
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	link_event_fd_check
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	dhcp_fd_check
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	nat_probe_fd_check
	leal	-152(%ebp), %eax
	movl	%eax, (%esp)
	call	ctrl_fd_check
.L1044:
	call	bu_worker
	call	dhcp_worker
	call	nat_probe_worker
.L1041:
	movl	keepworking, %eax
	testl	%eax, %eax
	jne	.L1045
	movl	stderr, %eax
	movl	%eax, 12(%esp)
	movl	$29, 8(%esp)
	movl	$1, 4(%esp)
	movl	$.LC182, (%esp)
	call	fwrite
	movl	$0, %eax
	leave
	ret
	.size	mn_worker, .-mn_worker
	.section	.rodata
.LC183:
	.string	"r"
.LC184:
	.string	"HOAV6"
.LC185:
	.string	"HOAV4"
.LC186:
	.string	"HAV6"
.LC187:
	.string	"HAV4"
.LC188:
	.string	"%s: "
.LC189:
	.string	"%x:%x:%x:%x:%x:%x:%x:%x\n"
	.text
.globl mn_conf
	.type	mn_conf, @function
mn_conf:
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%edi
	pushl	%esi
	pushl	%ebx
	subl	$1132, %esp
	movl	$.LC183, 4(%esp)
	movl	8(%ebp), %eax
	movl	%eax, (%esp)
	call	fopen
	movl	%eax, -28(%ebp)
	movl	$0, -32(%ebp)
	cmpl	$0, -28(%ebp)
	jne	.L1050
	movl	$-1, -1104(%ebp)
	jmp	.L1049
.L1072:
	leal	-1056(%ebp), %eax
	movl	%eax, -24(%ebp)
	jmp	.L1051
.L1053:
	addl	$1, -24(%ebp)
.L1051:
	movl	-24(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L1052
	movl	-24(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	je	.L1053
.L1052:
	movl	-24(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$35, %al
	je	.L1050
	movl	-24(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -20(%ebp)
	jmp	.L1054
.L1056:
	addl	$1, -20(%ebp)
.L1054:
	movl	-20(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	je	.L1055
	movl	-20(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	je	.L1055
	movl	-20(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L1055
	movl	-20(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$13, %al
	jne	.L1056
.L1055:
	movl	-20(%ebp), %eax
	movb	$0, (%eax)
	movl	$-1, -16(%ebp)
	movl	$.LC184, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L1057
	movl	$0, -16(%ebp)
	jmp	.L1058
.L1057:
	movl	$.LC185, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L1059
	movl	$1, -16(%ebp)
	jmp	.L1058
.L1059:
	movl	$.LC186, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L1060
	movl	$2, -16(%ebp)
	jmp	.L1058
.L1060:
	movl	$.LC187, 4(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, (%esp)
	call	strcmp
	testl	%eax, %eax
	jne	.L1058
	movl	$3, -16(%ebp)
.L1058:
	movl	stderr, %edx
	movl	-24(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$.LC188, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	movl	-20(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -24(%ebp)
	jmp	.L1061
.L1063:
	addl	$1, -24(%ebp)
.L1061:
	movl	-24(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L1062
	movl	-24(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	je	.L1063
.L1062:
	movl	-24(%ebp), %eax
	addl	$1, %eax
	movl	%eax, -20(%ebp)
	jmp	.L1064
.L1066:
	addl	$1, -20(%ebp)
.L1064:
	movl	-20(%ebp), %eax
	movzbl	(%eax), %eax
	testb	%al, %al
	je	.L1065
	movl	-20(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$32, %al
	je	.L1065
	movl	-20(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$10, %al
	je	.L1065
	movl	-20(%ebp), %eax
	movzbl	(%eax), %eax
	cmpb	$13, %al
	jne	.L1066
.L1065:
	movl	-20(%ebp), %eax
	movb	$0, (%eax)
	cmpl	$0, -16(%ebp)
	jne	.L1067
	movl	$hoav6, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$10, (%esp)
	call	inet_pton
	movzwl	hoav6+14, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %ebx
	movzwl	hoav6+12, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %esi
	movzwl	hoav6+10, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edi
	movzwl	hoav6+8, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1100(%ebp)
	movzwl	hoav6+6, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1096(%ebp)
	movzwl	hoav6+4, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1092(%ebp)
	movzwl	hoav6+2, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1088(%ebp)
	movzwl	hoav6, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%ebx, 36(%esp)
	movl	%esi, 32(%esp)
	movl	%edi, 28(%esp)
	movl	-1100(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-1096(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-1092(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-1088(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC189, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L1068
.L1067:
	cmpl	$1, -16(%ebp)
	jne	.L1069
	movl	$hoav4, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$2, (%esp)
	call	inet_pton
	movl	hoav4, %eax
	movl	%eax, %edx
	shrl	$24, %edx
	movl	hoav4, %eax
	andl	$16711680, %eax
	movl	%eax, %ecx
	shrl	$16, %ecx
	movl	hoav4, %eax
	andl	$65280, %eax
	movl	%eax, %ebx
	shrl	$8, %ebx
	movl	hoav4, %eax
	andl	$255, %eax
	movl	stderr, %esi
	movl	%edx, 20(%esp)
	movl	%ecx, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC156, 4(%esp)
	movl	%esi, (%esp)
	call	fprintf
	jmp	.L1068
.L1069:
	cmpl	$2, -16(%ebp)
	jne	.L1070
	movl	$hav6, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$10, (%esp)
	call	inet_pton
	movzwl	hav6+14, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %ebx
	movzwl	hav6+12, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %esi
	movzwl	hav6+10, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %edi
	movzwl	hav6+8, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1084(%ebp)
	movzwl	hav6+6, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1080(%ebp)
	movzwl	hav6+4, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1076(%ebp)
	movzwl	hav6+2, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	%eax, -1072(%ebp)
	movzwl	hav6, %eax
	movzwl	%ax, %eax
	movl	%eax, (%esp)
	call	ntohs
	movzwl	%ax, %eax
	movl	stderr, %edx
	movl	%ebx, 36(%esp)
	movl	%esi, 32(%esp)
	movl	%edi, 28(%esp)
	movl	-1084(%ebp), %ecx
	movl	%ecx, 24(%esp)
	movl	-1080(%ebp), %ecx
	movl	%ecx, 20(%esp)
	movl	-1076(%ebp), %ecx
	movl	%ecx, 16(%esp)
	movl	-1072(%ebp), %ecx
	movl	%ecx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC189, 4(%esp)
	movl	%edx, (%esp)
	call	fprintf
	jmp	.L1068
.L1070:
	cmpl	$3, -16(%ebp)
	jne	.L1068
	movl	$hav4, 8(%esp)
	movl	-24(%ebp), %eax
	movl	%eax, 4(%esp)
	movl	$2, (%esp)
	call	inet_pton
	movl	hav4, %eax
	movl	%eax, %edx
	shrl	$24, %edx
	movl	hav4, %eax
	andl	$16711680, %eax
	movl	%eax, %ecx
	shrl	$16, %ecx
	movl	hav4, %eax
	andl	$65280, %eax
	movl	%eax, %ebx
	shrl	$8, %ebx
	movl	hav4, %eax
	andl	$255, %eax
	movl	stderr, %esi
	movl	%edx, 20(%esp)
	movl	%ecx, 16(%esp)
	movl	%ebx, 12(%esp)
	movl	%eax, 8(%esp)
	movl	$.LC156, 4(%esp)
	movl	%esi, (%esp)
	call	fprintf
.L1068:
	movl	-16(%ebp), %eax
	movzbl	-32(%ebp,%eax), %eax
	testb	%al, %al
	je	.L1071
	movl	$-1, -1104(%ebp)
	jmp	.L1049
.L1071:
	movl	-16(%ebp), %eax
	movb	$1, -32(%ebp,%eax)
.L1050:
	movl	-28(%ebp), %eax
	movl	%eax, 8(%esp)
	movl	$1024, 4(%esp)
	leal	-1056(%ebp), %eax
	movl	%eax, (%esp)
	call	fgets
	testl	%eax, %eax
	jne	.L1072
	movl	-28(%ebp), %eax
	movl	%eax, (%esp)
	call	fclose
	movzbl	-32(%ebp), %eax
	testb	%al, %al
	je	.L1073
	movzbl	-31(%ebp), %eax
	testb	%al, %al
	je	.L1073
	movzbl	-30(%ebp), %eax
	testb	%al, %al
	je	.L1073
	movzbl	-29(%ebp), %eax
	testb	%al, %al
	jne	.L1074
.L1073:
	movl	$-1, -1104(%ebp)
	jmp	.L1049
.L1074:
	movl	$0, -1104(%ebp)
.L1049:
	movl	-1104(%ebp), %eax
	addl	$1132, %esp
	popl	%ebx
	popl	%esi
	popl	%edi
	popl	%ebp
	ret
	.size	mn_conf, .-mn_conf
	.section	.rodata
.LC190:
	.string	"conf/mn.conf"
.LC191:
	.string	"192.168.0.1"
.LC192:
	.string	"10.21.5.53"
.LC193:
	.string	"3ffe:ffff:501:100::1"
	.text
.globl main
	.type	main, @function
main:
	leal	4(%esp), %ecx
	andl	$-16, %esp
	pushl	-4(%ecx)
	pushl	%ebp
	movl	%esp, %ebp
	pushl	%ecx
	subl	$20, %esp
	movl	$.LC190, (%esp)
	call	mn_conf
	cmpl	$-1, %eax
	jne	.L1077
	movl	$hoav4, 8(%esp)
	movl	$.LC191, 4(%esp)
	movl	$2, (%esp)
	call	inet_pton
	movl	$hav4, 8(%esp)
	movl	$.LC192, 4(%esp)
	movl	$2, (%esp)
	call	inet_pton
	movl	$hoav6, 8(%esp)
	movl	$.LC193, 4(%esp)
	movl	$10, (%esp)
	call	inet_pton
	movl	$hoav4, 8(%esp)
	movl	$.LC191, 4(%esp)
	movl	$2, (%esp)
	call	inet_pton
.L1077:
	call	mn_init
	call	mn_worker
	call	mn_cleanup
	call	ctrl_cleanup
	movl	$0, %eax
	addl	$20, %esp
	popl	%ecx
	popl	%ebp
	leal	-4(%ecx), %esp
	ret
	.size	main, .-main
	.local	icmp6_sock
	.comm	icmp6_sock,28,4
	.local	icmp6_listener
	.comm	icmp6_listener,4,4
	.local	is_mn
	.comm	is_mn,4,4
	.local	default_gateway
	.comm	default_gateway,4,4
	.local	current_coav6
	.comm	current_coav6,16,4
	.local	current_coav4
	.comm	current_coav4,4,4
	.local	hoav6
	.comm	hoav6,16,4
	.local	hoav4
	.comm	hoav4,4,4
	.local	hav6
	.comm	hav6,16,4
	.local	hav4
	.comm	hav4,4,4
	.local	ifaces
	.comm	ifaces,516,32
	.comm	last_bu_t,4,4
	.comm	md_rth,36,32
	.comm	nat_fd,4,4
	.ident	"GCC: (Debian 4.3.2-1.1) 4.3.2"
	.section	.note.GNU-stack,"",@progbits
