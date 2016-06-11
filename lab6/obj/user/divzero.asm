
obj/__user_divzero.out:     file format elf32-i386


Disassembly of section .text:

00800020 <_start>:
.text
.globl _start
_start:
    # set ebp for backtrace
    movl $0x0, %ebp
  800020:	bd 00 00 00 00       	mov    $0x0,%ebp

    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp
  800025:	83 ec 20             	sub    $0x20,%esp

    # call user-program function
    call umain
  800028:	e8 7f 03 00 00       	call   8003ac <umain>
1:  jmp 1b
  80002d:	eb fe                	jmp    80002d <_start+0xd>
	...

00800030 <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  800030:	55                   	push   %ebp
  800031:	89 e5                	mov    %esp,%ebp
  800033:	83 ec 28             	sub    $0x28,%esp
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  800036:	8d 55 14             	lea    0x14(%ebp),%edx
  800039:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80003c:	89 10                	mov    %edx,(%eax)
    cprintf("user panic at %s:%d:\n    ", file, line);
  80003e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800041:	89 44 24 08          	mov    %eax,0x8(%esp)
  800045:	8b 45 08             	mov    0x8(%ebp),%eax
  800048:	89 44 24 04          	mov    %eax,0x4(%esp)
  80004c:	c7 04 24 20 11 80 00 	movl   $0x801120,(%esp)
  800053:	e8 c7 00 00 00       	call   80011f <cprintf>
    vcprintf(fmt, ap);
  800058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80005b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005f:	8b 45 10             	mov    0x10(%ebp),%eax
  800062:	89 04 24             	mov    %eax,(%esp)
  800065:	e8 82 00 00 00       	call   8000ec <vcprintf>
    cprintf("\n");
  80006a:	c7 04 24 3a 11 80 00 	movl   $0x80113a,(%esp)
  800071:	e8 a9 00 00 00       	call   80011f <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800076:	c7 04 24 f6 ff ff ff 	movl   $0xfffffff6,(%esp)
  80007d:	e8 6e 02 00 00       	call   8002f0 <exit>

00800082 <__warn>:
}

void
__warn(const char *file, int line, const char *fmt, ...) {
  800082:	55                   	push   %ebp
  800083:	89 e5                	mov    %esp,%ebp
  800085:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  800088:	8d 55 14             	lea    0x14(%ebp),%edx
  80008b:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80008e:	89 10                	mov    %edx,(%eax)
    cprintf("user warning at %s:%d:\n    ", file, line);
  800090:	8b 45 0c             	mov    0xc(%ebp),%eax
  800093:	89 44 24 08          	mov    %eax,0x8(%esp)
  800097:	8b 45 08             	mov    0x8(%ebp),%eax
  80009a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80009e:	c7 04 24 3c 11 80 00 	movl   $0x80113c,(%esp)
  8000a5:	e8 75 00 00 00       	call   80011f <cprintf>
    vcprintf(fmt, ap);
  8000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8000b4:	89 04 24             	mov    %eax,(%esp)
  8000b7:	e8 30 00 00 00       	call   8000ec <vcprintf>
    cprintf("\n");
  8000bc:	c7 04 24 3a 11 80 00 	movl   $0x80113a,(%esp)
  8000c3:	e8 57 00 00 00       	call   80011f <cprintf>
    va_end(ap);
}
  8000c8:	c9                   	leave  
  8000c9:	c3                   	ret    
	...

008000cc <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  8000cc:	55                   	push   %ebp
  8000cd:	89 e5                	mov    %esp,%ebp
  8000cf:	83 ec 18             	sub    $0x18,%esp
    sys_putc(c);
  8000d2:	8b 45 08             	mov    0x8(%ebp),%eax
  8000d5:	89 04 24             	mov    %eax,(%esp)
  8000d8:	e8 b3 01 00 00       	call   800290 <sys_putc>
    (*cnt) ++;
  8000dd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e0:	8b 00                	mov    (%eax),%eax
  8000e2:	8d 50 01             	lea    0x1(%eax),%edx
  8000e5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e8:	89 10                	mov    %edx,(%eax)
}
  8000ea:	c9                   	leave  
  8000eb:	c3                   	ret    

008000ec <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  8000ec:	55                   	push   %ebp
  8000ed:	89 e5                	mov    %esp,%ebp
  8000ef:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  8000f2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  8000f9:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000fc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800100:	8b 45 08             	mov    0x8(%ebp),%eax
  800103:	89 44 24 08          	mov    %eax,0x8(%esp)
  800107:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80010a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80010e:	c7 04 24 cc 00 80 00 	movl   $0x8000cc,(%esp)
  800115:	e8 e0 04 00 00       	call   8005fa <vprintfmt>
    return cnt;
  80011a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80011d:	c9                   	leave  
  80011e:	c3                   	ret    

0080011f <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  80011f:	55                   	push   %ebp
  800120:	89 e5                	mov    %esp,%ebp
  800122:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  800125:	8d 55 0c             	lea    0xc(%ebp),%edx
  800128:	8d 45 f0             	lea    -0x10(%ebp),%eax
  80012b:	89 10                	mov    %edx,(%eax)
    int cnt = vcprintf(fmt, ap);
  80012d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800130:	89 44 24 04          	mov    %eax,0x4(%esp)
  800134:	8b 45 08             	mov    0x8(%ebp),%eax
  800137:	89 04 24             	mov    %eax,(%esp)
  80013a:	e8 ad ff ff ff       	call   8000ec <vcprintf>
  80013f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);

    return cnt;
  800142:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800145:	c9                   	leave  
  800146:	c3                   	ret    

00800147 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  800147:	55                   	push   %ebp
  800148:	89 e5                	mov    %esp,%ebp
  80014a:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  80014d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  800154:	eb 13                	jmp    800169 <cputs+0x22>
        cputch(c, &cnt);
  800156:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80015a:	8d 55 f0             	lea    -0x10(%ebp),%edx
  80015d:	89 54 24 04          	mov    %edx,0x4(%esp)
  800161:	89 04 24             	mov    %eax,(%esp)
  800164:	e8 63 ff ff ff       	call   8000cc <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  800169:	8b 45 08             	mov    0x8(%ebp),%eax
  80016c:	0f b6 00             	movzbl (%eax),%eax
  80016f:	88 45 f7             	mov    %al,-0x9(%ebp)
  800172:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  800176:	0f 95 c0             	setne  %al
  800179:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  80017d:	84 c0                	test   %al,%al
  80017f:	75 d5                	jne    800156 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  800181:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800184:	89 44 24 04          	mov    %eax,0x4(%esp)
  800188:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80018f:	e8 38 ff ff ff       	call   8000cc <cputch>
    return cnt;
  800194:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  800197:	c9                   	leave  
  800198:	c3                   	ret    
  800199:	00 00                	add    %al,(%eax)
	...

0080019c <syscall>:
#include <syscall.h>

#define MAX_ARGS            5

static inline int
syscall(int num, ...) {
  80019c:	55                   	push   %ebp
  80019d:	89 e5                	mov    %esp,%ebp
  80019f:	57                   	push   %edi
  8001a0:	56                   	push   %esi
  8001a1:	53                   	push   %ebx
  8001a2:	83 ec 24             	sub    $0x24,%esp
    va_list ap;
    va_start(ap, num);
  8001a5:	8d 55 0c             	lea    0xc(%ebp),%edx
  8001a8:	8d 45 e8             	lea    -0x18(%ebp),%eax
  8001ab:	89 10                	mov    %edx,(%eax)
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  8001ad:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  8001b4:	eb 16                	jmp    8001cc <syscall+0x30>
        a[i] = va_arg(ap, uint32_t);
  8001b6:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8001b9:	8d 50 04             	lea    0x4(%eax),%edx
  8001bc:	89 55 e8             	mov    %edx,-0x18(%ebp)
  8001bf:	8b 10                	mov    (%eax),%edx
  8001c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8001c4:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
syscall(int num, ...) {
    va_list ap;
    va_start(ap, num);
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  8001c8:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  8001cc:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  8001d0:	7e e4                	jle    8001b6 <syscall+0x1a>
    asm volatile (
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL),
          "a" (num),
          "d" (a[0]),
  8001d2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
          "c" (a[1]),
  8001d5:	8b 4d d8             	mov    -0x28(%ebp),%ecx
          "b" (a[2]),
  8001d8:	8b 5d dc             	mov    -0x24(%ebp),%ebx
          "D" (a[3]),
  8001db:	8b 7d e0             	mov    -0x20(%ebp),%edi
          "S" (a[4])
  8001de:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint32_t);
    }
    va_end(ap);

    asm volatile (
  8001e1:	8b 45 08             	mov    0x8(%ebp),%eax
  8001e4:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8001e7:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8001ea:	cd 80                	int    $0x80
  8001ec:	89 c3                	mov    %eax,%ebx
  8001ee:	89 5d ec             	mov    %ebx,-0x14(%ebp)
          "c" (a[1]),
          "b" (a[2]),
          "D" (a[3]),
          "S" (a[4])
        : "cc", "memory");
    return ret;
  8001f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  8001f4:	83 c4 24             	add    $0x24,%esp
  8001f7:	5b                   	pop    %ebx
  8001f8:	5e                   	pop    %esi
  8001f9:	5f                   	pop    %edi
  8001fa:	5d                   	pop    %ebp
  8001fb:	c3                   	ret    

008001fc <sys_exit>:

int
sys_exit(int error_code) {
  8001fc:	55                   	push   %ebp
  8001fd:	89 e5                	mov    %esp,%ebp
  8001ff:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_exit, error_code);
  800202:	8b 45 08             	mov    0x8(%ebp),%eax
  800205:	89 44 24 04          	mov    %eax,0x4(%esp)
  800209:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800210:	e8 87 ff ff ff       	call   80019c <syscall>
}
  800215:	c9                   	leave  
  800216:	c3                   	ret    

00800217 <sys_fork>:

int
sys_fork(void) {
  800217:	55                   	push   %ebp
  800218:	89 e5                	mov    %esp,%ebp
  80021a:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_fork);
  80021d:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800224:	e8 73 ff ff ff       	call   80019c <syscall>
}
  800229:	c9                   	leave  
  80022a:	c3                   	ret    

0080022b <sys_wait>:

int
sys_wait(int pid, int *store) {
  80022b:	55                   	push   %ebp
  80022c:	89 e5                	mov    %esp,%ebp
  80022e:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_wait, pid, store);
  800231:	8b 45 0c             	mov    0xc(%ebp),%eax
  800234:	89 44 24 08          	mov    %eax,0x8(%esp)
  800238:	8b 45 08             	mov    0x8(%ebp),%eax
  80023b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80023f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  800246:	e8 51 ff ff ff       	call   80019c <syscall>
}
  80024b:	c9                   	leave  
  80024c:	c3                   	ret    

0080024d <sys_yield>:

int
sys_yield(void) {
  80024d:	55                   	push   %ebp
  80024e:	89 e5                	mov    %esp,%ebp
  800250:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_yield);
  800253:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  80025a:	e8 3d ff ff ff       	call   80019c <syscall>
}
  80025f:	c9                   	leave  
  800260:	c3                   	ret    

00800261 <sys_kill>:

int
sys_kill(int pid) {
  800261:	55                   	push   %ebp
  800262:	89 e5                	mov    %esp,%ebp
  800264:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_kill, pid);
  800267:	8b 45 08             	mov    0x8(%ebp),%eax
  80026a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80026e:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  800275:	e8 22 ff ff ff       	call   80019c <syscall>
}
  80027a:	c9                   	leave  
  80027b:	c3                   	ret    

0080027c <sys_getpid>:

int
sys_getpid(void) {
  80027c:	55                   	push   %ebp
  80027d:	89 e5                	mov    %esp,%ebp
  80027f:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_getpid);
  800282:	c7 04 24 12 00 00 00 	movl   $0x12,(%esp)
  800289:	e8 0e ff ff ff       	call   80019c <syscall>
}
  80028e:	c9                   	leave  
  80028f:	c3                   	ret    

00800290 <sys_putc>:

int
sys_putc(int c) {
  800290:	55                   	push   %ebp
  800291:	89 e5                	mov    %esp,%ebp
  800293:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_putc, c);
  800296:	8b 45 08             	mov    0x8(%ebp),%eax
  800299:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029d:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
  8002a4:	e8 f3 fe ff ff       	call   80019c <syscall>
}
  8002a9:	c9                   	leave  
  8002aa:	c3                   	ret    

008002ab <sys_pgdir>:

int
sys_pgdir(void) {
  8002ab:	55                   	push   %ebp
  8002ac:	89 e5                	mov    %esp,%ebp
  8002ae:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_pgdir);
  8002b1:	c7 04 24 1f 00 00 00 	movl   $0x1f,(%esp)
  8002b8:	e8 df fe ff ff       	call   80019c <syscall>
}
  8002bd:	c9                   	leave  
  8002be:	c3                   	ret    

008002bf <sys_gettime>:

int
sys_gettime(void) {
  8002bf:	55                   	push   %ebp
  8002c0:	89 e5                	mov    %esp,%ebp
  8002c2:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_gettime);
  8002c5:	c7 04 24 11 00 00 00 	movl   $0x11,(%esp)
  8002cc:	e8 cb fe ff ff       	call   80019c <syscall>
}
  8002d1:	c9                   	leave  
  8002d2:	c3                   	ret    

008002d3 <sys_lab6_set_priority>:

void
sys_lab6_set_priority(uint32_t priority)
{
  8002d3:	55                   	push   %ebp
  8002d4:	89 e5                	mov    %esp,%ebp
  8002d6:	83 ec 08             	sub    $0x8,%esp
    syscall(SYS_lab6_set_priority, priority);
  8002d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8002dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002e0:	c7 04 24 ff 00 00 00 	movl   $0xff,(%esp)
  8002e7:	e8 b0 fe ff ff       	call   80019c <syscall>
}
  8002ec:	c9                   	leave  
  8002ed:	c3                   	ret    
	...

008002f0 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8002f0:	55                   	push   %ebp
  8002f1:	89 e5                	mov    %esp,%ebp
  8002f3:	83 ec 18             	sub    $0x18,%esp
    sys_exit(error_code);
  8002f6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f9:	89 04 24             	mov    %eax,(%esp)
  8002fc:	e8 fb fe ff ff       	call   8001fc <sys_exit>
    cprintf("BUG: exit failed.\n");
  800301:	c7 04 24 58 11 80 00 	movl   $0x801158,(%esp)
  800308:	e8 12 fe ff ff       	call   80011f <cprintf>
    while (1);
  80030d:	eb fe                	jmp    80030d <exit+0x1d>

0080030f <fork>:
}

int
fork(void) {
  80030f:	55                   	push   %ebp
  800310:	89 e5                	mov    %esp,%ebp
  800312:	83 ec 08             	sub    $0x8,%esp
    return sys_fork();
  800315:	e8 fd fe ff ff       	call   800217 <sys_fork>
}
  80031a:	c9                   	leave  
  80031b:	c3                   	ret    

0080031c <wait>:

int
wait(void) {
  80031c:	55                   	push   %ebp
  80031d:	89 e5                	mov    %esp,%ebp
  80031f:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(0, NULL);
  800322:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800329:	00 
  80032a:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800331:	e8 f5 fe ff ff       	call   80022b <sys_wait>
}
  800336:	c9                   	leave  
  800337:	c3                   	ret    

00800338 <waitpid>:

int
waitpid(int pid, int *store) {
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(pid, store);
  80033e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800341:	89 44 24 04          	mov    %eax,0x4(%esp)
  800345:	8b 45 08             	mov    0x8(%ebp),%eax
  800348:	89 04 24             	mov    %eax,(%esp)
  80034b:	e8 db fe ff ff       	call   80022b <sys_wait>
}
  800350:	c9                   	leave  
  800351:	c3                   	ret    

00800352 <yield>:

void
yield(void) {
  800352:	55                   	push   %ebp
  800353:	89 e5                	mov    %esp,%ebp
  800355:	83 ec 08             	sub    $0x8,%esp
    sys_yield();
  800358:	e8 f0 fe ff ff       	call   80024d <sys_yield>
}
  80035d:	c9                   	leave  
  80035e:	c3                   	ret    

0080035f <kill>:

int
kill(int pid) {
  80035f:	55                   	push   %ebp
  800360:	89 e5                	mov    %esp,%ebp
  800362:	83 ec 18             	sub    $0x18,%esp
    return sys_kill(pid);
  800365:	8b 45 08             	mov    0x8(%ebp),%eax
  800368:	89 04 24             	mov    %eax,(%esp)
  80036b:	e8 f1 fe ff ff       	call   800261 <sys_kill>
}
  800370:	c9                   	leave  
  800371:	c3                   	ret    

00800372 <getpid>:

int
getpid(void) {
  800372:	55                   	push   %ebp
  800373:	89 e5                	mov    %esp,%ebp
  800375:	83 ec 08             	sub    $0x8,%esp
    return sys_getpid();
  800378:	e8 ff fe ff ff       	call   80027c <sys_getpid>
}
  80037d:	c9                   	leave  
  80037e:	c3                   	ret    

0080037f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  80037f:	55                   	push   %ebp
  800380:	89 e5                	mov    %esp,%ebp
  800382:	83 ec 08             	sub    $0x8,%esp
    sys_pgdir();
  800385:	e8 21 ff ff ff       	call   8002ab <sys_pgdir>
}
  80038a:	c9                   	leave  
  80038b:	c3                   	ret    

0080038c <gettime_msec>:

unsigned int
gettime_msec(void) {
  80038c:	55                   	push   %ebp
  80038d:	89 e5                	mov    %esp,%ebp
  80038f:	83 ec 08             	sub    $0x8,%esp
    return (unsigned int)sys_gettime();
  800392:	e8 28 ff ff ff       	call   8002bf <sys_gettime>
}
  800397:	c9                   	leave  
  800398:	c3                   	ret    

00800399 <lab6_set_priority>:

void
lab6_set_priority(uint32_t priority)
{
  800399:	55                   	push   %ebp
  80039a:	89 e5                	mov    %esp,%ebp
  80039c:	83 ec 18             	sub    $0x18,%esp
    sys_lab6_set_priority(priority);
  80039f:	8b 45 08             	mov    0x8(%ebp),%eax
  8003a2:	89 04 24             	mov    %eax,(%esp)
  8003a5:	e8 29 ff ff ff       	call   8002d3 <sys_lab6_set_priority>
}
  8003aa:	c9                   	leave  
  8003ab:	c3                   	ret    

008003ac <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8003ac:	55                   	push   %ebp
  8003ad:	89 e5                	mov    %esp,%ebp
  8003af:	83 ec 28             	sub    $0x28,%esp
    int ret = main();
  8003b2:	e8 fd 0c 00 00       	call   8010b4 <main>
  8003b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    exit(ret);
  8003ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003bd:	89 04 24             	mov    %eax,(%esp)
  8003c0:	e8 2b ff ff ff       	call   8002f0 <exit>
  8003c5:	00 00                	add    %al,(%eax)
	...

008003c8 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	53                   	push   %ebx
  8003cc:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  8003cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d2:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
  8003d8:	89 45 f8             	mov    %eax,-0x8(%ebp)
    return (hash >> (32 - bits));
  8003db:	b8 20 00 00 00       	mov    $0x20,%eax
  8003e0:	2b 45 0c             	sub    0xc(%ebp),%eax
  8003e3:	8b 55 f8             	mov    -0x8(%ebp),%edx
  8003e6:	89 d3                	mov    %edx,%ebx
  8003e8:	89 c1                	mov    %eax,%ecx
  8003ea:	d3 eb                	shr    %cl,%ebx
  8003ec:	89 d8                	mov    %ebx,%eax
}
  8003ee:	83 c4 10             	add    $0x10,%esp
  8003f1:	5b                   	pop    %ebx
  8003f2:	5d                   	pop    %ebp
  8003f3:	c3                   	ret    

008003f4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  8003f4:	55                   	push   %ebp
  8003f5:	89 e5                	mov    %esp,%ebp
  8003f7:	56                   	push   %esi
  8003f8:	53                   	push   %ebx
  8003f9:	83 ec 60             	sub    $0x60,%esp
  8003fc:	8b 45 10             	mov    0x10(%ebp),%eax
  8003ff:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800402:	8b 45 14             	mov    0x14(%ebp),%eax
  800405:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  800408:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80040b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80040e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800411:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  800414:	8b 45 18             	mov    0x18(%ebp),%eax
  800417:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80041a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80041d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800420:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800423:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800426:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800429:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80042c:	89 d3                	mov    %edx,%ebx
  80042e:	89 c6                	mov    %eax,%esi
  800430:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800433:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  800436:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800439:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80043c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800440:	74 1c                	je     80045e <printnum+0x6a>
  800442:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800445:	ba 00 00 00 00       	mov    $0x0,%edx
  80044a:	f7 75 e4             	divl   -0x1c(%ebp)
  80044d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800450:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800453:	ba 00 00 00 00       	mov    $0x0,%edx
  800458:	f7 75 e4             	divl   -0x1c(%ebp)
  80045b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80045e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800461:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800464:	89 d6                	mov    %edx,%esi
  800466:	89 c3                	mov    %eax,%ebx
  800468:	89 f0                	mov    %esi,%eax
  80046a:	89 da                	mov    %ebx,%edx
  80046c:	f7 75 e4             	divl   -0x1c(%ebp)
  80046f:	89 d3                	mov    %edx,%ebx
  800471:	89 c6                	mov    %eax,%esi
  800473:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800476:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  800479:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80047c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80047f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800482:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800485:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800488:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80048b:	89 c3                	mov    %eax,%ebx
  80048d:	89 d6                	mov    %edx,%esi
  80048f:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  800492:	89 75 ec             	mov    %esi,-0x14(%ebp)
  800495:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800498:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  80049b:	8b 45 18             	mov    0x18(%ebp),%eax
  80049e:	ba 00 00 00 00       	mov    $0x0,%edx
  8004a3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  8004a6:	77 56                	ja     8004fe <printnum+0x10a>
  8004a8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  8004ab:	72 05                	jb     8004b2 <printnum+0xbe>
  8004ad:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004b0:	77 4c                	ja     8004fe <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
  8004b2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004b5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004b8:	8b 45 20             	mov    0x20(%ebp),%eax
  8004bb:	89 44 24 18          	mov    %eax,0x18(%esp)
  8004bf:	89 54 24 14          	mov    %edx,0x14(%esp)
  8004c3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004c6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8004d0:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004d4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004d8:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004db:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004df:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e2:	89 04 24             	mov    %eax,(%esp)
  8004e5:	e8 0a ff ff ff       	call   8003f4 <printnum>
  8004ea:	eb 1c                	jmp    800508 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  8004ec:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004ef:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004f3:	8b 45 20             	mov    0x20(%ebp),%eax
  8004f6:	89 04 24             	mov    %eax,(%esp)
  8004f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004fc:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  8004fe:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800502:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800506:	7f e4                	jg     8004ec <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800508:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80050b:	05 84 12 80 00       	add    $0x801284,%eax
  800510:	0f b6 00             	movzbl (%eax),%eax
  800513:	0f be c0             	movsbl %al,%eax
  800516:	8b 55 0c             	mov    0xc(%ebp),%edx
  800519:	89 54 24 04          	mov    %edx,0x4(%esp)
  80051d:	89 04 24             	mov    %eax,(%esp)
  800520:	8b 45 08             	mov    0x8(%ebp),%eax
  800523:	ff d0                	call   *%eax
}
  800525:	83 c4 60             	add    $0x60,%esp
  800528:	5b                   	pop    %ebx
  800529:	5e                   	pop    %esi
  80052a:	5d                   	pop    %ebp
  80052b:	c3                   	ret    

0080052c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  80052c:	55                   	push   %ebp
  80052d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  80052f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800533:	7e 14                	jle    800549 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  800535:	8b 45 08             	mov    0x8(%ebp),%eax
  800538:	8b 00                	mov    (%eax),%eax
  80053a:	8d 48 08             	lea    0x8(%eax),%ecx
  80053d:	8b 55 08             	mov    0x8(%ebp),%edx
  800540:	89 0a                	mov    %ecx,(%edx)
  800542:	8b 50 04             	mov    0x4(%eax),%edx
  800545:	8b 00                	mov    (%eax),%eax
  800547:	eb 30                	jmp    800579 <getuint+0x4d>
    }
    else if (lflag) {
  800549:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80054d:	74 16                	je     800565 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  80054f:	8b 45 08             	mov    0x8(%ebp),%eax
  800552:	8b 00                	mov    (%eax),%eax
  800554:	8d 48 04             	lea    0x4(%eax),%ecx
  800557:	8b 55 08             	mov    0x8(%ebp),%edx
  80055a:	89 0a                	mov    %ecx,(%edx)
  80055c:	8b 00                	mov    (%eax),%eax
  80055e:	ba 00 00 00 00       	mov    $0x0,%edx
  800563:	eb 14                	jmp    800579 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	8d 48 04             	lea    0x4(%eax),%ecx
  80056d:	8b 55 08             	mov    0x8(%ebp),%edx
  800570:	89 0a                	mov    %ecx,(%edx)
  800572:	8b 00                	mov    (%eax),%eax
  800574:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  800579:	5d                   	pop    %ebp
  80057a:	c3                   	ret    

0080057b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  80057b:	55                   	push   %ebp
  80057c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  80057e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800582:	7e 14                	jle    800598 <getint+0x1d>
        return va_arg(*ap, long long);
  800584:	8b 45 08             	mov    0x8(%ebp),%eax
  800587:	8b 00                	mov    (%eax),%eax
  800589:	8d 48 08             	lea    0x8(%eax),%ecx
  80058c:	8b 55 08             	mov    0x8(%ebp),%edx
  80058f:	89 0a                	mov    %ecx,(%edx)
  800591:	8b 50 04             	mov    0x4(%eax),%edx
  800594:	8b 00                	mov    (%eax),%eax
  800596:	eb 30                	jmp    8005c8 <getint+0x4d>
    }
    else if (lflag) {
  800598:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80059c:	74 16                	je     8005b4 <getint+0x39>
        return va_arg(*ap, long);
  80059e:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a1:	8b 00                	mov    (%eax),%eax
  8005a3:	8d 48 04             	lea    0x4(%eax),%ecx
  8005a6:	8b 55 08             	mov    0x8(%ebp),%edx
  8005a9:	89 0a                	mov    %ecx,(%edx)
  8005ab:	8b 00                	mov    (%eax),%eax
  8005ad:	89 c2                	mov    %eax,%edx
  8005af:	c1 fa 1f             	sar    $0x1f,%edx
  8005b2:	eb 14                	jmp    8005c8 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	8d 48 04             	lea    0x4(%eax),%ecx
  8005bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8005bf:	89 0a                	mov    %ecx,(%edx)
  8005c1:	8b 00                	mov    (%eax),%eax
  8005c3:	89 c2                	mov    %eax,%edx
  8005c5:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  8005c8:	5d                   	pop    %ebp
  8005c9:	c3                   	ret    

008005ca <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8005ca:	55                   	push   %ebp
  8005cb:	89 e5                	mov    %esp,%ebp
  8005cd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  8005d0:	8d 55 14             	lea    0x14(%ebp),%edx
  8005d3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8005d6:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
  8005d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8005db:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8005df:	8b 45 10             	mov    0x10(%ebp),%eax
  8005e2:	89 44 24 08          	mov    %eax,0x8(%esp)
  8005e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005ed:	8b 45 08             	mov    0x8(%ebp),%eax
  8005f0:	89 04 24             	mov    %eax,(%esp)
  8005f3:	e8 02 00 00 00       	call   8005fa <vprintfmt>
    va_end(ap);
}
  8005f8:	c9                   	leave  
  8005f9:	c3                   	ret    

008005fa <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	56                   	push   %esi
  8005fe:	53                   	push   %ebx
  8005ff:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800602:	eb 17                	jmp    80061b <vprintfmt+0x21>
            if (ch == '\0') {
  800604:	85 db                	test   %ebx,%ebx
  800606:	0f 84 db 03 00 00    	je     8009e7 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
  80060c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80060f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800613:	89 1c 24             	mov    %ebx,(%esp)
  800616:	8b 45 08             	mov    0x8(%ebp),%eax
  800619:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80061b:	8b 45 10             	mov    0x10(%ebp),%eax
  80061e:	0f b6 00             	movzbl (%eax),%eax
  800621:	0f b6 d8             	movzbl %al,%ebx
  800624:	83 fb 25             	cmp    $0x25,%ebx
  800627:	0f 95 c0             	setne  %al
  80062a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  80062e:	84 c0                	test   %al,%al
  800630:	75 d2                	jne    800604 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  800632:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  800636:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80063d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800640:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  800643:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80064a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80064d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800650:	eb 04                	jmp    800656 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  800652:	90                   	nop
  800653:	eb 01                	jmp    800656 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  800655:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800656:	8b 45 10             	mov    0x10(%ebp),%eax
  800659:	0f b6 00             	movzbl (%eax),%eax
  80065c:	0f b6 d8             	movzbl %al,%ebx
  80065f:	89 d8                	mov    %ebx,%eax
  800661:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800665:	83 e8 23             	sub    $0x23,%eax
  800668:	83 f8 55             	cmp    $0x55,%eax
  80066b:	0f 87 45 03 00 00    	ja     8009b6 <vprintfmt+0x3bc>
  800671:	8b 04 85 a8 12 80 00 	mov    0x8012a8(,%eax,4),%eax
  800678:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  80067a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  80067e:	eb d6                	jmp    800656 <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  800680:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  800684:	eb d0                	jmp    800656 <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  800686:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  80068d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800690:	89 d0                	mov    %edx,%eax
  800692:	c1 e0 02             	shl    $0x2,%eax
  800695:	01 d0                	add    %edx,%eax
  800697:	01 c0                	add    %eax,%eax
  800699:	01 d8                	add    %ebx,%eax
  80069b:	83 e8 30             	sub    $0x30,%eax
  80069e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  8006a1:	8b 45 10             	mov    0x10(%ebp),%eax
  8006a4:	0f b6 00             	movzbl (%eax),%eax
  8006a7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  8006aa:	83 fb 2f             	cmp    $0x2f,%ebx
  8006ad:	7e 39                	jle    8006e8 <vprintfmt+0xee>
  8006af:	83 fb 39             	cmp    $0x39,%ebx
  8006b2:	7f 34                	jg     8006e8 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  8006b4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  8006b8:	eb d3                	jmp    80068d <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  8006ba:	8b 45 14             	mov    0x14(%ebp),%eax
  8006bd:	8d 50 04             	lea    0x4(%eax),%edx
  8006c0:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c3:	8b 00                	mov    (%eax),%eax
  8006c5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  8006c8:	eb 1f                	jmp    8006e9 <vprintfmt+0xef>

        case '.':
            if (width < 0)
  8006ca:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8006ce:	79 82                	jns    800652 <vprintfmt+0x58>
                width = 0;
  8006d0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  8006d7:	e9 76 ff ff ff       	jmp    800652 <vprintfmt+0x58>

        case '#':
            altflag = 1;
  8006dc:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  8006e3:	e9 6e ff ff ff       	jmp    800656 <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  8006e8:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  8006e9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8006ed:	0f 89 62 ff ff ff    	jns    800655 <vprintfmt+0x5b>
                width = precision, precision = -1;
  8006f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8006f9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  800700:	e9 50 ff ff ff       	jmp    800655 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  800705:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  800709:	e9 48 ff ff ff       	jmp    800656 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  80070e:	8b 45 14             	mov    0x14(%ebp),%eax
  800711:	8d 50 04             	lea    0x4(%eax),%edx
  800714:	89 55 14             	mov    %edx,0x14(%ebp)
  800717:	8b 00                	mov    (%eax),%eax
  800719:	8b 55 0c             	mov    0xc(%ebp),%edx
  80071c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800720:	89 04 24             	mov    %eax,(%esp)
  800723:	8b 45 08             	mov    0x8(%ebp),%eax
  800726:	ff d0                	call   *%eax
            break;
  800728:	e9 b4 02 00 00       	jmp    8009e1 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
  80072d:	8b 45 14             	mov    0x14(%ebp),%eax
  800730:	8d 50 04             	lea    0x4(%eax),%edx
  800733:	89 55 14             	mov    %edx,0x14(%ebp)
  800736:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  800738:	85 db                	test   %ebx,%ebx
  80073a:	79 02                	jns    80073e <vprintfmt+0x144>
                err = -err;
  80073c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80073e:	83 fb 18             	cmp    $0x18,%ebx
  800741:	7f 0b                	jg     80074e <vprintfmt+0x154>
  800743:	8b 34 9d 20 12 80 00 	mov    0x801220(,%ebx,4),%esi
  80074a:	85 f6                	test   %esi,%esi
  80074c:	75 23                	jne    800771 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
  80074e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800752:	c7 44 24 08 95 12 80 	movl   $0x801295,0x8(%esp)
  800759:	00 
  80075a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80075d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800761:	8b 45 08             	mov    0x8(%ebp),%eax
  800764:	89 04 24             	mov    %eax,(%esp)
  800767:	e8 5e fe ff ff       	call   8005ca <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  80076c:	e9 70 02 00 00       	jmp    8009e1 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  800771:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800775:	c7 44 24 08 9e 12 80 	movl   $0x80129e,0x8(%esp)
  80077c:	00 
  80077d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800780:	89 44 24 04          	mov    %eax,0x4(%esp)
  800784:	8b 45 08             	mov    0x8(%ebp),%eax
  800787:	89 04 24             	mov    %eax,(%esp)
  80078a:	e8 3b fe ff ff       	call   8005ca <printfmt>
            }
            break;
  80078f:	e9 4d 02 00 00       	jmp    8009e1 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  800794:	8b 45 14             	mov    0x14(%ebp),%eax
  800797:	8d 50 04             	lea    0x4(%eax),%edx
  80079a:	89 55 14             	mov    %edx,0x14(%ebp)
  80079d:	8b 30                	mov    (%eax),%esi
  80079f:	85 f6                	test   %esi,%esi
  8007a1:	75 05                	jne    8007a8 <vprintfmt+0x1ae>
                p = "(null)";
  8007a3:	be a1 12 80 00       	mov    $0x8012a1,%esi
            }
            if (width > 0 && padc != '-') {
  8007a8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8007ac:	7e 7c                	jle    80082a <vprintfmt+0x230>
  8007ae:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007b2:	74 76                	je     80082a <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8007b4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8007b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007be:	89 34 24             	mov    %esi,(%esp)
  8007c1:	e8 25 04 00 00       	call   800beb <strnlen>
  8007c6:	89 da                	mov    %ebx,%edx
  8007c8:	29 c2                	sub    %eax,%edx
  8007ca:	89 d0                	mov    %edx,%eax
  8007cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8007cf:	eb 17                	jmp    8007e8 <vprintfmt+0x1ee>
                    putch(padc, putdat);
  8007d1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  8007d5:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007d8:	89 54 24 04          	mov    %edx,0x4(%esp)
  8007dc:	89 04 24             	mov    %eax,(%esp)
  8007df:	8b 45 08             	mov    0x8(%ebp),%eax
  8007e2:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  8007e4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  8007e8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8007ec:	7f e3                	jg     8007d1 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8007ee:	eb 3a                	jmp    80082a <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
  8007f0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007f4:	74 1f                	je     800815 <vprintfmt+0x21b>
  8007f6:	83 fb 1f             	cmp    $0x1f,%ebx
  8007f9:	7e 05                	jle    800800 <vprintfmt+0x206>
  8007fb:	83 fb 7e             	cmp    $0x7e,%ebx
  8007fe:	7e 15                	jle    800815 <vprintfmt+0x21b>
                    putch('?', putdat);
  800800:	8b 45 0c             	mov    0xc(%ebp),%eax
  800803:	89 44 24 04          	mov    %eax,0x4(%esp)
  800807:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80080e:	8b 45 08             	mov    0x8(%ebp),%eax
  800811:	ff d0                	call   *%eax
  800813:	eb 0f                	jmp    800824 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
  800815:	8b 45 0c             	mov    0xc(%ebp),%eax
  800818:	89 44 24 04          	mov    %eax,0x4(%esp)
  80081c:	89 1c 24             	mov    %ebx,(%esp)
  80081f:	8b 45 08             	mov    0x8(%ebp),%eax
  800822:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800824:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800828:	eb 01                	jmp    80082b <vprintfmt+0x231>
  80082a:	90                   	nop
  80082b:	0f b6 06             	movzbl (%esi),%eax
  80082e:	0f be d8             	movsbl %al,%ebx
  800831:	85 db                	test   %ebx,%ebx
  800833:	0f 95 c0             	setne  %al
  800836:	83 c6 01             	add    $0x1,%esi
  800839:	84 c0                	test   %al,%al
  80083b:	74 29                	je     800866 <vprintfmt+0x26c>
  80083d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800841:	78 ad                	js     8007f0 <vprintfmt+0x1f6>
  800843:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800847:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80084b:	79 a3                	jns    8007f0 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  80084d:	eb 17                	jmp    800866 <vprintfmt+0x26c>
                putch(' ', putdat);
  80084f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800852:	89 44 24 04          	mov    %eax,0x4(%esp)
  800856:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80085d:	8b 45 08             	mov    0x8(%ebp),%eax
  800860:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  800862:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800866:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80086a:	7f e3                	jg     80084f <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
  80086c:	e9 70 01 00 00       	jmp    8009e1 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  800871:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800874:	89 44 24 04          	mov    %eax,0x4(%esp)
  800878:	8d 45 14             	lea    0x14(%ebp),%eax
  80087b:	89 04 24             	mov    %eax,(%esp)
  80087e:	e8 f8 fc ff ff       	call   80057b <getint>
  800883:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800886:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  800889:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80088c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80088f:	85 d2                	test   %edx,%edx
  800891:	79 26                	jns    8008b9 <vprintfmt+0x2bf>
                putch('-', putdat);
  800893:	8b 45 0c             	mov    0xc(%ebp),%eax
  800896:	89 44 24 04          	mov    %eax,0x4(%esp)
  80089a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008a1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008a4:	ff d0                	call   *%eax
                num = -(long long)num;
  8008a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008a9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008ac:	f7 d8                	neg    %eax
  8008ae:	83 d2 00             	adc    $0x0,%edx
  8008b1:	f7 da                	neg    %edx
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  8008b9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  8008c0:	e9 a8 00 00 00       	jmp    80096d <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  8008c5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008cc:	8d 45 14             	lea    0x14(%ebp),%eax
  8008cf:	89 04 24             	mov    %eax,(%esp)
  8008d2:	e8 55 fc ff ff       	call   80052c <getuint>
  8008d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008da:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  8008dd:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  8008e4:	e9 84 00 00 00       	jmp    80096d <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  8008e9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008ec:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008f0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008f3:	89 04 24             	mov    %eax,(%esp)
  8008f6:	e8 31 fc ff ff       	call   80052c <getuint>
  8008fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008fe:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  800901:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  800908:	eb 63                	jmp    80096d <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
  80090a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80090d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800911:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800918:	8b 45 08             	mov    0x8(%ebp),%eax
  80091b:	ff d0                	call   *%eax
            putch('x', putdat);
  80091d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800920:	89 44 24 04          	mov    %eax,0x4(%esp)
  800924:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80092b:	8b 45 08             	mov    0x8(%ebp),%eax
  80092e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800930:	8b 45 14             	mov    0x14(%ebp),%eax
  800933:	8d 50 04             	lea    0x4(%eax),%edx
  800936:	89 55 14             	mov    %edx,0x14(%ebp)
  800939:	8b 00                	mov    (%eax),%eax
  80093b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80093e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  800945:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  80094c:	eb 1f                	jmp    80096d <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  80094e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800951:	89 44 24 04          	mov    %eax,0x4(%esp)
  800955:	8d 45 14             	lea    0x14(%ebp),%eax
  800958:	89 04 24             	mov    %eax,(%esp)
  80095b:	e8 cc fb ff ff       	call   80052c <getuint>
  800960:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800963:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  800966:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  80096d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800971:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800974:	89 54 24 18          	mov    %edx,0x18(%esp)
  800978:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80097b:	89 54 24 14          	mov    %edx,0x14(%esp)
  80097f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800983:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800986:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800989:	89 44 24 08          	mov    %eax,0x8(%esp)
  80098d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800991:	8b 45 0c             	mov    0xc(%ebp),%eax
  800994:	89 44 24 04          	mov    %eax,0x4(%esp)
  800998:	8b 45 08             	mov    0x8(%ebp),%eax
  80099b:	89 04 24             	mov    %eax,(%esp)
  80099e:	e8 51 fa ff ff       	call   8003f4 <printnum>
            break;
  8009a3:	eb 3c                	jmp    8009e1 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  8009a5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ac:	89 1c 24             	mov    %ebx,(%esp)
  8009af:	8b 45 08             	mov    0x8(%ebp),%eax
  8009b2:	ff d0                	call   *%eax
            break;
  8009b4:	eb 2b                	jmp    8009e1 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009bd:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009c4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009c7:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  8009c9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009cd:	eb 04                	jmp    8009d3 <vprintfmt+0x3d9>
  8009cf:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009d3:	8b 45 10             	mov    0x10(%ebp),%eax
  8009d6:	83 e8 01             	sub    $0x1,%eax
  8009d9:	0f b6 00             	movzbl (%eax),%eax
  8009dc:	3c 25                	cmp    $0x25,%al
  8009de:	75 ef                	jne    8009cf <vprintfmt+0x3d5>
                /* do nothing */;
            break;
  8009e0:	90                   	nop
        }
    }
  8009e1:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8009e2:	e9 34 fc ff ff       	jmp    80061b <vprintfmt+0x21>
            if (ch == '\0') {
                return;
  8009e7:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8009e8:	83 c4 40             	add    $0x40,%esp
  8009eb:	5b                   	pop    %ebx
  8009ec:	5e                   	pop    %esi
  8009ed:	5d                   	pop    %ebp
  8009ee:	c3                   	ret    

008009ef <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  8009ef:	55                   	push   %ebp
  8009f0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  8009f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f5:	8b 40 08             	mov    0x8(%eax),%eax
  8009f8:	8d 50 01             	lea    0x1(%eax),%edx
  8009fb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009fe:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  800a01:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a04:	8b 10                	mov    (%eax),%edx
  800a06:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a09:	8b 40 04             	mov    0x4(%eax),%eax
  800a0c:	39 c2                	cmp    %eax,%edx
  800a0e:	73 12                	jae    800a22 <sprintputch+0x33>
        *b->buf ++ = ch;
  800a10:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a13:	8b 00                	mov    (%eax),%eax
  800a15:	8b 55 08             	mov    0x8(%ebp),%edx
  800a18:	88 10                	mov    %dl,(%eax)
  800a1a:	8d 50 01             	lea    0x1(%eax),%edx
  800a1d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a20:	89 10                	mov    %edx,(%eax)
    }
}
  800a22:	5d                   	pop    %ebp
  800a23:	c3                   	ret    

00800a24 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  800a24:	55                   	push   %ebp
  800a25:	89 e5                	mov    %esp,%ebp
  800a27:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  800a2a:	8d 55 14             	lea    0x14(%ebp),%edx
  800a2d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a30:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a35:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a39:	8b 45 10             	mov    0x10(%ebp),%eax
  800a3c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a43:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a47:	8b 45 08             	mov    0x8(%ebp),%eax
  800a4a:	89 04 24             	mov    %eax,(%esp)
  800a4d:	e8 08 00 00 00       	call   800a5a <vsnprintf>
  800a52:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  800a55:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a58:	c9                   	leave  
  800a59:	c3                   	ret    

00800a5a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  800a5a:	55                   	push   %ebp
  800a5b:	89 e5                	mov    %esp,%ebp
  800a5d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  800a60:	8b 45 08             	mov    0x8(%ebp),%eax
  800a63:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a66:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a69:	83 e8 01             	sub    $0x1,%eax
  800a6c:	03 45 08             	add    0x8(%ebp),%eax
  800a6f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a72:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  800a79:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a7d:	74 0a                	je     800a89 <vsnprintf+0x2f>
  800a7f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a82:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a85:	39 c2                	cmp    %eax,%edx
  800a87:	76 07                	jbe    800a90 <vsnprintf+0x36>
        return -E_INVAL;
  800a89:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a8e:	eb 2a                	jmp    800aba <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a90:	8b 45 14             	mov    0x14(%ebp),%eax
  800a93:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a97:	8b 45 10             	mov    0x10(%ebp),%eax
  800a9a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a9e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800aa1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800aa5:	c7 04 24 ef 09 80 00 	movl   $0x8009ef,(%esp)
  800aac:	e8 49 fb ff ff       	call   8005fa <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  800ab1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ab4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  800ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aba:	c9                   	leave  
  800abb:	c3                   	ret    

00800abc <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  800abc:	55                   	push   %ebp
  800abd:	89 e5                	mov    %esp,%ebp
  800abf:	57                   	push   %edi
  800ac0:	56                   	push   %esi
  800ac1:	53                   	push   %ebx
  800ac2:	83 ec 34             	sub    $0x34,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  800ac5:	a1 00 20 80 00       	mov    0x802000,%eax
  800aca:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800ad0:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
  800ad6:	6b c8 05             	imul   $0x5,%eax,%ecx
  800ad9:	01 cf                	add    %ecx,%edi
  800adb:	b9 6d e6 ec de       	mov    $0xdeece66d,%ecx
  800ae0:	f7 e1                	mul    %ecx
  800ae2:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  800ae5:	89 ca                	mov    %ecx,%edx
  800ae7:	83 c0 0b             	add    $0xb,%eax
  800aea:	83 d2 00             	adc    $0x0,%edx
  800aed:	89 c3                	mov    %eax,%ebx
  800aef:	80 e7 ff             	and    $0xff,%bh
  800af2:	0f b7 f2             	movzwl %dx,%esi
  800af5:	89 1d 00 20 80 00    	mov    %ebx,0x802000
  800afb:	89 35 04 20 80 00    	mov    %esi,0x802004
    unsigned long long result = (next >> 12);
  800b01:	a1 00 20 80 00       	mov    0x802000,%eax
  800b06:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800b0c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  800b10:	c1 ea 0c             	shr    $0xc,%edx
  800b13:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b16:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
  800b19:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  800b20:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b23:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b26:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800b29:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800b2c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b2f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800b32:	89 d3                	mov    %edx,%ebx
  800b34:	89 c6                	mov    %eax,%esi
  800b36:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800b39:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  800b3c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b3f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b42:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800b46:	74 1c                	je     800b64 <rand+0xa8>
  800b48:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b4b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b50:	f7 75 dc             	divl   -0x24(%ebp)
  800b53:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800b56:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b59:	ba 00 00 00 00       	mov    $0x0,%edx
  800b5e:	f7 75 dc             	divl   -0x24(%ebp)
  800b61:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800b64:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b67:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b6a:	89 d6                	mov    %edx,%esi
  800b6c:	89 c3                	mov    %eax,%ebx
  800b6e:	89 f0                	mov    %esi,%eax
  800b70:	89 da                	mov    %ebx,%edx
  800b72:	f7 75 dc             	divl   -0x24(%ebp)
  800b75:	89 d3                	mov    %edx,%ebx
  800b77:	89 c6                	mov    %eax,%esi
  800b79:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800b7c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800b7f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b82:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800b85:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b88:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800b8b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b8e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800b91:	89 c3                	mov    %eax,%ebx
  800b93:	89 d6                	mov    %edx,%esi
  800b95:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800b98:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800b9b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800b9e:	83 c4 34             	add    $0x34,%esp
  800ba1:	5b                   	pop    %ebx
  800ba2:	5e                   	pop    %esi
  800ba3:	5f                   	pop    %edi
  800ba4:	5d                   	pop    %ebp
  800ba5:	c3                   	ret    

00800ba6 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  800ba6:	55                   	push   %ebp
  800ba7:	89 e5                	mov    %esp,%ebp
    next = seed;
  800ba9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bac:	ba 00 00 00 00       	mov    $0x0,%edx
  800bb1:	a3 00 20 80 00       	mov    %eax,0x802000
  800bb6:	89 15 04 20 80 00    	mov    %edx,0x802004
}
  800bbc:	5d                   	pop    %ebp
  800bbd:	c3                   	ret    
	...

00800bc0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  800bc0:	55                   	push   %ebp
  800bc1:	89 e5                	mov    %esp,%ebp
  800bc3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800bc6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  800bcd:	eb 04                	jmp    800bd3 <strlen+0x13>
        cnt ++;
  800bcf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  800bd3:	8b 45 08             	mov    0x8(%ebp),%eax
  800bd6:	0f b6 00             	movzbl (%eax),%eax
  800bd9:	84 c0                	test   %al,%al
  800bdb:	0f 95 c0             	setne  %al
  800bde:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800be2:	84 c0                	test   %al,%al
  800be4:	75 e9                	jne    800bcf <strlen+0xf>
        cnt ++;
    }
    return cnt;
  800be6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800be9:	c9                   	leave  
  800bea:	c3                   	ret    

00800beb <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  800beb:	55                   	push   %ebp
  800bec:	89 e5                	mov    %esp,%ebp
  800bee:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800bf1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  800bf8:	eb 04                	jmp    800bfe <strnlen+0x13>
        cnt ++;
  800bfa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  800bfe:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c01:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c04:	73 13                	jae    800c19 <strnlen+0x2e>
  800c06:	8b 45 08             	mov    0x8(%ebp),%eax
  800c09:	0f b6 00             	movzbl (%eax),%eax
  800c0c:	84 c0                	test   %al,%al
  800c0e:	0f 95 c0             	setne  %al
  800c11:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c15:	84 c0                	test   %al,%al
  800c17:	75 e1                	jne    800bfa <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  800c19:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c1c:	c9                   	leave  
  800c1d:	c3                   	ret    

00800c1e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  800c1e:	55                   	push   %ebp
  800c1f:	89 e5                	mov    %esp,%ebp
  800c21:	57                   	push   %edi
  800c22:	56                   	push   %esi
  800c23:	53                   	push   %ebx
  800c24:	83 ec 24             	sub    $0x24,%esp
  800c27:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c2d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c30:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  800c33:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c36:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c39:	89 d6                	mov    %edx,%esi
  800c3b:	89 c3                	mov    %eax,%ebx
  800c3d:	89 df                	mov    %ebx,%edi
  800c3f:	ac                   	lods   %ds:(%esi),%al
  800c40:	aa                   	stos   %al,%es:(%edi)
  800c41:	84 c0                	test   %al,%al
  800c43:	75 fa                	jne    800c3f <strcpy+0x21>
  800c45:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c48:	89 fb                	mov    %edi,%ebx
  800c4a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  800c4d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800c50:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c53:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  800c56:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  800c59:	83 c4 24             	add    $0x24,%esp
  800c5c:	5b                   	pop    %ebx
  800c5d:	5e                   	pop    %esi
  800c5e:	5f                   	pop    %edi
  800c5f:	5d                   	pop    %ebp
  800c60:	c3                   	ret    

00800c61 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  800c61:	55                   	push   %ebp
  800c62:	89 e5                	mov    %esp,%ebp
  800c64:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  800c67:	8b 45 08             	mov    0x8(%ebp),%eax
  800c6a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  800c6d:	eb 21                	jmp    800c90 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  800c6f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c72:	0f b6 10             	movzbl (%eax),%edx
  800c75:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c78:	88 10                	mov    %dl,(%eax)
  800c7a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c7d:	0f b6 00             	movzbl (%eax),%eax
  800c80:	84 c0                	test   %al,%al
  800c82:	74 04                	je     800c88 <strncpy+0x27>
            src ++;
  800c84:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  800c88:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800c8c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  800c90:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c94:	75 d9                	jne    800c6f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  800c96:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c99:	c9                   	leave  
  800c9a:	c3                   	ret    

00800c9b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  800c9b:	55                   	push   %ebp
  800c9c:	89 e5                	mov    %esp,%ebp
  800c9e:	57                   	push   %edi
  800c9f:	56                   	push   %esi
  800ca0:	53                   	push   %ebx
  800ca1:	83 ec 24             	sub    $0x24,%esp
  800ca4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ca7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800caa:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cad:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  800cb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800cb3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800cb6:	89 d6                	mov    %edx,%esi
  800cb8:	89 c3                	mov    %eax,%ebx
  800cba:	89 df                	mov    %ebx,%edi
  800cbc:	ac                   	lods   %ds:(%esi),%al
  800cbd:	ae                   	scas   %es:(%edi),%al
  800cbe:	75 08                	jne    800cc8 <strcmp+0x2d>
  800cc0:	84 c0                	test   %al,%al
  800cc2:	75 f8                	jne    800cbc <strcmp+0x21>
  800cc4:	31 c0                	xor    %eax,%eax
  800cc6:	eb 04                	jmp    800ccc <strcmp+0x31>
  800cc8:	19 c0                	sbb    %eax,%eax
  800cca:	0c 01                	or     $0x1,%al
  800ccc:	89 fb                	mov    %edi,%ebx
  800cce:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800cd1:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800cd4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800cd7:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800cda:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  800cdd:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  800ce0:	83 c4 24             	add    $0x24,%esp
  800ce3:	5b                   	pop    %ebx
  800ce4:	5e                   	pop    %esi
  800ce5:	5f                   	pop    %edi
  800ce6:	5d                   	pop    %ebp
  800ce7:	c3                   	ret    

00800ce8 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  800ce8:	55                   	push   %ebp
  800ce9:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800ceb:	eb 0c                	jmp    800cf9 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  800ced:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800cf1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800cf5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800cf9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cfd:	74 1a                	je     800d19 <strncmp+0x31>
  800cff:	8b 45 08             	mov    0x8(%ebp),%eax
  800d02:	0f b6 00             	movzbl (%eax),%eax
  800d05:	84 c0                	test   %al,%al
  800d07:	74 10                	je     800d19 <strncmp+0x31>
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	0f b6 10             	movzbl (%eax),%edx
  800d0f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d12:	0f b6 00             	movzbl (%eax),%eax
  800d15:	38 c2                	cmp    %al,%dl
  800d17:	74 d4                	je     800ced <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  800d19:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d1d:	74 1a                	je     800d39 <strncmp+0x51>
  800d1f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d22:	0f b6 00             	movzbl (%eax),%eax
  800d25:	0f b6 d0             	movzbl %al,%edx
  800d28:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2b:	0f b6 00             	movzbl (%eax),%eax
  800d2e:	0f b6 c0             	movzbl %al,%eax
  800d31:	89 d1                	mov    %edx,%ecx
  800d33:	29 c1                	sub    %eax,%ecx
  800d35:	89 c8                	mov    %ecx,%eax
  800d37:	eb 05                	jmp    800d3e <strncmp+0x56>
  800d39:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d3e:	5d                   	pop    %ebp
  800d3f:	c3                   	ret    

00800d40 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  800d40:	55                   	push   %ebp
  800d41:	89 e5                	mov    %esp,%ebp
  800d43:	83 ec 04             	sub    $0x4,%esp
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800d4c:	eb 14                	jmp    800d62 <strchr+0x22>
        if (*s == c) {
  800d4e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d51:	0f b6 00             	movzbl (%eax),%eax
  800d54:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d57:	75 05                	jne    800d5e <strchr+0x1e>
            return (char *)s;
  800d59:	8b 45 08             	mov    0x8(%ebp),%eax
  800d5c:	eb 13                	jmp    800d71 <strchr+0x31>
        }
        s ++;
  800d5e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  800d62:	8b 45 08             	mov    0x8(%ebp),%eax
  800d65:	0f b6 00             	movzbl (%eax),%eax
  800d68:	84 c0                	test   %al,%al
  800d6a:	75 e2                	jne    800d4e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  800d6c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d71:	c9                   	leave  
  800d72:	c3                   	ret    

00800d73 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  800d73:	55                   	push   %ebp
  800d74:	89 e5                	mov    %esp,%ebp
  800d76:	83 ec 04             	sub    $0x4,%esp
  800d79:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d7c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800d7f:	eb 0f                	jmp    800d90 <strfind+0x1d>
        if (*s == c) {
  800d81:	8b 45 08             	mov    0x8(%ebp),%eax
  800d84:	0f b6 00             	movzbl (%eax),%eax
  800d87:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d8a:	74 10                	je     800d9c <strfind+0x29>
            break;
        }
        s ++;
  800d8c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	0f b6 00             	movzbl (%eax),%eax
  800d96:	84 c0                	test   %al,%al
  800d98:	75 e7                	jne    800d81 <strfind+0xe>
  800d9a:	eb 01                	jmp    800d9d <strfind+0x2a>
        if (*s == c) {
            break;
  800d9c:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  800d9d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800da0:	c9                   	leave  
  800da1:	c3                   	ret    

00800da2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  800da2:	55                   	push   %ebp
  800da3:	89 e5                	mov    %esp,%ebp
  800da5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  800da8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  800daf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800db6:	eb 04                	jmp    800dbc <strtol+0x1a>
        s ++;
  800db8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800dbc:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbf:	0f b6 00             	movzbl (%eax),%eax
  800dc2:	3c 20                	cmp    $0x20,%al
  800dc4:	74 f2                	je     800db8 <strtol+0x16>
  800dc6:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc9:	0f b6 00             	movzbl (%eax),%eax
  800dcc:	3c 09                	cmp    $0x9,%al
  800dce:	74 e8                	je     800db8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  800dd0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dd3:	0f b6 00             	movzbl (%eax),%eax
  800dd6:	3c 2b                	cmp    $0x2b,%al
  800dd8:	75 06                	jne    800de0 <strtol+0x3e>
        s ++;
  800dda:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dde:	eb 15                	jmp    800df5 <strtol+0x53>
    }
    else if (*s == '-') {
  800de0:	8b 45 08             	mov    0x8(%ebp),%eax
  800de3:	0f b6 00             	movzbl (%eax),%eax
  800de6:	3c 2d                	cmp    $0x2d,%al
  800de8:	75 0b                	jne    800df5 <strtol+0x53>
        s ++, neg = 1;
  800dea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800dee:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800df5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df9:	74 06                	je     800e01 <strtol+0x5f>
  800dfb:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800dff:	75 24                	jne    800e25 <strtol+0x83>
  800e01:	8b 45 08             	mov    0x8(%ebp),%eax
  800e04:	0f b6 00             	movzbl (%eax),%eax
  800e07:	3c 30                	cmp    $0x30,%al
  800e09:	75 1a                	jne    800e25 <strtol+0x83>
  800e0b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0e:	83 c0 01             	add    $0x1,%eax
  800e11:	0f b6 00             	movzbl (%eax),%eax
  800e14:	3c 78                	cmp    $0x78,%al
  800e16:	75 0d                	jne    800e25 <strtol+0x83>
        s += 2, base = 16;
  800e18:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e1c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e23:	eb 2a                	jmp    800e4f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	75 17                	jne    800e42 <strtol+0xa0>
  800e2b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e2e:	0f b6 00             	movzbl (%eax),%eax
  800e31:	3c 30                	cmp    $0x30,%al
  800e33:	75 0d                	jne    800e42 <strtol+0xa0>
        s ++, base = 8;
  800e35:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e39:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e40:	eb 0d                	jmp    800e4f <strtol+0xad>
    }
    else if (base == 0) {
  800e42:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e46:	75 07                	jne    800e4f <strtol+0xad>
        base = 10;
  800e48:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  800e4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e52:	0f b6 00             	movzbl (%eax),%eax
  800e55:	3c 2f                	cmp    $0x2f,%al
  800e57:	7e 1b                	jle    800e74 <strtol+0xd2>
  800e59:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5c:	0f b6 00             	movzbl (%eax),%eax
  800e5f:	3c 39                	cmp    $0x39,%al
  800e61:	7f 11                	jg     800e74 <strtol+0xd2>
            dig = *s - '0';
  800e63:	8b 45 08             	mov    0x8(%ebp),%eax
  800e66:	0f b6 00             	movzbl (%eax),%eax
  800e69:	0f be c0             	movsbl %al,%eax
  800e6c:	83 e8 30             	sub    $0x30,%eax
  800e6f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e72:	eb 48                	jmp    800ebc <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  800e74:	8b 45 08             	mov    0x8(%ebp),%eax
  800e77:	0f b6 00             	movzbl (%eax),%eax
  800e7a:	3c 60                	cmp    $0x60,%al
  800e7c:	7e 1b                	jle    800e99 <strtol+0xf7>
  800e7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e81:	0f b6 00             	movzbl (%eax),%eax
  800e84:	3c 7a                	cmp    $0x7a,%al
  800e86:	7f 11                	jg     800e99 <strtol+0xf7>
            dig = *s - 'a' + 10;
  800e88:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8b:	0f b6 00             	movzbl (%eax),%eax
  800e8e:	0f be c0             	movsbl %al,%eax
  800e91:	83 e8 57             	sub    $0x57,%eax
  800e94:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e97:	eb 23                	jmp    800ebc <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  800e99:	8b 45 08             	mov    0x8(%ebp),%eax
  800e9c:	0f b6 00             	movzbl (%eax),%eax
  800e9f:	3c 40                	cmp    $0x40,%al
  800ea1:	7e 38                	jle    800edb <strtol+0x139>
  800ea3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea6:	0f b6 00             	movzbl (%eax),%eax
  800ea9:	3c 5a                	cmp    $0x5a,%al
  800eab:	7f 2e                	jg     800edb <strtol+0x139>
            dig = *s - 'A' + 10;
  800ead:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb0:	0f b6 00             	movzbl (%eax),%eax
  800eb3:	0f be c0             	movsbl %al,%eax
  800eb6:	83 e8 37             	sub    $0x37,%eax
  800eb9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  800ebc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ebf:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ec2:	7d 16                	jge    800eda <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
  800ec4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ec8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ecb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800ecf:	03 45 f4             	add    -0xc(%ebp),%eax
  800ed2:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  800ed5:	e9 75 ff ff ff       	jmp    800e4f <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  800eda:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  800edb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800edf:	74 08                	je     800ee9 <strtol+0x147>
        *endptr = (char *) s;
  800ee1:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ee4:	8b 55 08             	mov    0x8(%ebp),%edx
  800ee7:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  800ee9:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800eed:	74 07                	je     800ef6 <strtol+0x154>
  800eef:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ef2:	f7 d8                	neg    %eax
  800ef4:	eb 03                	jmp    800ef9 <strtol+0x157>
  800ef6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ef9:	c9                   	leave  
  800efa:	c3                   	ret    

00800efb <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  800efb:	55                   	push   %ebp
  800efc:	89 e5                	mov    %esp,%ebp
  800efe:	57                   	push   %edi
  800eff:	56                   	push   %esi
  800f00:	53                   	push   %ebx
  800f01:	83 ec 24             	sub    $0x24,%esp
  800f04:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f07:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  800f0a:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  800f0e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f11:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f14:	88 45 ef             	mov    %al,-0x11(%ebp)
  800f17:	8b 45 10             	mov    0x10(%ebp),%eax
  800f1a:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  800f1d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  800f20:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  800f24:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f27:	89 ce                	mov    %ecx,%esi
  800f29:	89 d3                	mov    %edx,%ebx
  800f2b:	89 f1                	mov    %esi,%ecx
  800f2d:	89 df                	mov    %ebx,%edi
  800f2f:	f3 aa                	rep stos %al,%es:(%edi)
  800f31:	89 fb                	mov    %edi,%ebx
  800f33:	89 ce                	mov    %ecx,%esi
  800f35:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800f38:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  800f3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800f3e:	83 c4 24             	add    $0x24,%esp
  800f41:	5b                   	pop    %ebx
  800f42:	5e                   	pop    %esi
  800f43:	5f                   	pop    %edi
  800f44:	5d                   	pop    %ebp
  800f45:	c3                   	ret    

00800f46 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  800f46:	55                   	push   %ebp
  800f47:	89 e5                	mov    %esp,%ebp
  800f49:	57                   	push   %edi
  800f4a:	56                   	push   %esi
  800f4b:	53                   	push   %ebx
  800f4c:	83 ec 38             	sub    $0x38,%esp
  800f4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f52:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f55:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f58:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f5b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f5e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  800f61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f64:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800f67:	73 4e                	jae    800fb7 <memmove+0x71>
  800f69:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f6c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f72:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f78:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800f7b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f7e:	89 c1                	mov    %eax,%ecx
  800f80:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800f83:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f86:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f89:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800f8c:	89 d7                	mov    %edx,%edi
  800f8e:	89 c3                	mov    %eax,%ebx
  800f90:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800f93:	89 de                	mov    %ebx,%esi
  800f95:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f97:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800f9a:	83 e1 03             	and    $0x3,%ecx
  800f9d:	74 02                	je     800fa1 <memmove+0x5b>
  800f9f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800fa1:	89 f3                	mov    %esi,%ebx
  800fa3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800fa6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800fa9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800fac:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800faf:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800fb2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fb5:	eb 3b                	jmp    800ff2 <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  800fb7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fba:	83 e8 01             	sub    $0x1,%eax
  800fbd:	89 c2                	mov    %eax,%edx
  800fbf:	03 55 ec             	add    -0x14(%ebp),%edx
  800fc2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fc5:	83 e8 01             	sub    $0x1,%eax
  800fc8:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  800fcb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  800fce:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  800fd1:	89 d6                	mov    %edx,%esi
  800fd3:	89 c3                	mov    %eax,%ebx
  800fd5:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  800fd8:	89 df                	mov    %ebx,%edi
  800fda:	fd                   	std    
  800fdb:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800fdd:	fc                   	cld    
  800fde:	89 fb                	mov    %edi,%ebx
  800fe0:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  800fe3:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  800fe6:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800fe9:	89 75 c8             	mov    %esi,-0x38(%ebp)
  800fec:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  800fef:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  800ff2:	83 c4 38             	add    $0x38,%esp
  800ff5:	5b                   	pop    %ebx
  800ff6:	5e                   	pop    %esi
  800ff7:	5f                   	pop    %edi
  800ff8:	5d                   	pop    %ebp
  800ff9:	c3                   	ret    

00800ffa <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  800ffa:	55                   	push   %ebp
  800ffb:	89 e5                	mov    %esp,%ebp
  800ffd:	57                   	push   %edi
  800ffe:	56                   	push   %esi
  800fff:	53                   	push   %ebx
  801000:	83 ec 24             	sub    $0x24,%esp
  801003:	8b 45 08             	mov    0x8(%ebp),%eax
  801006:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801009:	8b 45 0c             	mov    0xc(%ebp),%eax
  80100c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80100f:	8b 45 10             	mov    0x10(%ebp),%eax
  801012:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  801015:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801018:	89 c1                	mov    %eax,%ecx
  80101a:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  80101d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801020:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801023:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801026:	89 d7                	mov    %edx,%edi
  801028:	89 c3                	mov    %eax,%ebx
  80102a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80102d:	89 de                	mov    %ebx,%esi
  80102f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801031:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801034:	83 e1 03             	and    $0x3,%ecx
  801037:	74 02                	je     80103b <memcpy+0x41>
  801039:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80103b:	89 f3                	mov    %esi,%ebx
  80103d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801040:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801043:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  801046:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801049:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  80104c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  80104f:	83 c4 24             	add    $0x24,%esp
  801052:	5b                   	pop    %ebx
  801053:	5e                   	pop    %esi
  801054:	5f                   	pop    %edi
  801055:	5d                   	pop    %ebp
  801056:	c3                   	ret    

00801057 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  801057:	55                   	push   %ebp
  801058:	89 e5                	mov    %esp,%ebp
  80105a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  80105d:	8b 45 08             	mov    0x8(%ebp),%eax
  801060:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  801063:	8b 45 0c             	mov    0xc(%ebp),%eax
  801066:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  801069:	eb 32                	jmp    80109d <memcmp+0x46>
        if (*s1 != *s2) {
  80106b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80106e:	0f b6 10             	movzbl (%eax),%edx
  801071:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801074:	0f b6 00             	movzbl (%eax),%eax
  801077:	38 c2                	cmp    %al,%dl
  801079:	74 1a                	je     801095 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  80107b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80107e:	0f b6 00             	movzbl (%eax),%eax
  801081:	0f b6 d0             	movzbl %al,%edx
  801084:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801087:	0f b6 00             	movzbl (%eax),%eax
  80108a:	0f b6 c0             	movzbl %al,%eax
  80108d:	89 d1                	mov    %edx,%ecx
  80108f:	29 c1                	sub    %eax,%ecx
  801091:	89 c8                	mov    %ecx,%eax
  801093:	eb 1c                	jmp    8010b1 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  801095:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801099:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  80109d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010a1:	0f 95 c0             	setne  %al
  8010a4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8010a8:	84 c0                	test   %al,%al
  8010aa:	75 bf                	jne    80106b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  8010ac:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010b1:	c9                   	leave  
  8010b2:	c3                   	ret    
	...

008010b4 <main>:
#include <ulib.h>

int zero;

int
main(void) {
  8010b4:	55                   	push   %ebp
  8010b5:	89 e5                	mov    %esp,%ebp
  8010b7:	83 e4 f0             	and    $0xfffffff0,%esp
  8010ba:	83 ec 20             	sub    $0x20,%esp
    cprintf("value is %d.\n", 1 / zero);
  8010bd:	8b 15 08 20 80 00    	mov    0x802008,%edx
  8010c3:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  8010c7:	b8 01 00 00 00       	mov    $0x1,%eax
  8010cc:	89 c2                	mov    %eax,%edx
  8010ce:	c1 fa 1f             	sar    $0x1f,%edx
  8010d1:	f7 7c 24 1c          	idivl  0x1c(%esp)
  8010d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010d9:	c7 04 24 00 14 80 00 	movl   $0x801400,(%esp)
  8010e0:	e8 3a f0 ff ff       	call   80011f <cprintf>
    panic("FAIL: T.T\n");
  8010e5:	c7 44 24 08 0e 14 80 	movl   $0x80140e,0x8(%esp)
  8010ec:	00 
  8010ed:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
  8010f4:	00 
  8010f5:	c7 04 24 19 14 80 00 	movl   $0x801419,(%esp)
  8010fc:	e8 2f ef ff ff       	call   800030 <__panic>
