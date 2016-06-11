
obj/__user_testbss.out:     file format elf32-i386


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
  800028:	e8 2f 03 00 00       	call   80035c <umain>
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
  80004c:	c7 04 24 80 11 80 00 	movl   $0x801180,(%esp)
  800053:	e8 c7 00 00 00       	call   80011f <cprintf>
    vcprintf(fmt, ap);
  800058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80005b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005f:	8b 45 10             	mov    0x10(%ebp),%eax
  800062:	89 04 24             	mov    %eax,(%esp)
  800065:	e8 82 00 00 00       	call   8000ec <vcprintf>
    cprintf("\n");
  80006a:	c7 04 24 9a 11 80 00 	movl   $0x80119a,(%esp)
  800071:	e8 a9 00 00 00       	call   80011f <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800076:	c7 04 24 f6 ff ff ff 	movl   $0xfffffff6,(%esp)
  80007d:	e8 3e 02 00 00       	call   8002c0 <exit>

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
  80009e:	c7 04 24 9c 11 80 00 	movl   $0x80119c,(%esp)
  8000a5:	e8 75 00 00 00       	call   80011f <cprintf>
    vcprintf(fmt, ap);
  8000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8000b4:	89 04 24             	mov    %eax,(%esp)
  8000b7:	e8 30 00 00 00       	call   8000ec <vcprintf>
    cprintf("\n");
  8000bc:	c7 04 24 9a 11 80 00 	movl   $0x80119a,(%esp)
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
  800115:	e8 90 04 00 00       	call   8005aa <vprintfmt>
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
	...

008002c0 <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  8002c0:	55                   	push   %ebp
  8002c1:	89 e5                	mov    %esp,%ebp
  8002c3:	83 ec 18             	sub    $0x18,%esp
    sys_exit(error_code);
  8002c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8002c9:	89 04 24             	mov    %eax,(%esp)
  8002cc:	e8 2b ff ff ff       	call   8001fc <sys_exit>
    cprintf("BUG: exit failed.\n");
  8002d1:	c7 04 24 b8 11 80 00 	movl   $0x8011b8,(%esp)
  8002d8:	e8 42 fe ff ff       	call   80011f <cprintf>
    while (1);
  8002dd:	eb fe                	jmp    8002dd <exit+0x1d>

008002df <fork>:
}

int
fork(void) {
  8002df:	55                   	push   %ebp
  8002e0:	89 e5                	mov    %esp,%ebp
  8002e2:	83 ec 08             	sub    $0x8,%esp
    return sys_fork();
  8002e5:	e8 2d ff ff ff       	call   800217 <sys_fork>
}
  8002ea:	c9                   	leave  
  8002eb:	c3                   	ret    

008002ec <wait>:

int
wait(void) {
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(0, NULL);
  8002f2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  8002f9:	00 
  8002fa:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800301:	e8 25 ff ff ff       	call   80022b <sys_wait>
}
  800306:	c9                   	leave  
  800307:	c3                   	ret    

00800308 <waitpid>:

int
waitpid(int pid, int *store) {
  800308:	55                   	push   %ebp
  800309:	89 e5                	mov    %esp,%ebp
  80030b:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(pid, store);
  80030e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800311:	89 44 24 04          	mov    %eax,0x4(%esp)
  800315:	8b 45 08             	mov    0x8(%ebp),%eax
  800318:	89 04 24             	mov    %eax,(%esp)
  80031b:	e8 0b ff ff ff       	call   80022b <sys_wait>
}
  800320:	c9                   	leave  
  800321:	c3                   	ret    

00800322 <yield>:

void
yield(void) {
  800322:	55                   	push   %ebp
  800323:	89 e5                	mov    %esp,%ebp
  800325:	83 ec 08             	sub    $0x8,%esp
    sys_yield();
  800328:	e8 20 ff ff ff       	call   80024d <sys_yield>
}
  80032d:	c9                   	leave  
  80032e:	c3                   	ret    

0080032f <kill>:

int
kill(int pid) {
  80032f:	55                   	push   %ebp
  800330:	89 e5                	mov    %esp,%ebp
  800332:	83 ec 18             	sub    $0x18,%esp
    return sys_kill(pid);
  800335:	8b 45 08             	mov    0x8(%ebp),%eax
  800338:	89 04 24             	mov    %eax,(%esp)
  80033b:	e8 21 ff ff ff       	call   800261 <sys_kill>
}
  800340:	c9                   	leave  
  800341:	c3                   	ret    

00800342 <getpid>:

int
getpid(void) {
  800342:	55                   	push   %ebp
  800343:	89 e5                	mov    %esp,%ebp
  800345:	83 ec 08             	sub    $0x8,%esp
    return sys_getpid();
  800348:	e8 2f ff ff ff       	call   80027c <sys_getpid>
}
  80034d:	c9                   	leave  
  80034e:	c3                   	ret    

0080034f <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  80034f:	55                   	push   %ebp
  800350:	89 e5                	mov    %esp,%ebp
  800352:	83 ec 08             	sub    $0x8,%esp
    sys_pgdir();
  800355:	e8 51 ff ff ff       	call   8002ab <sys_pgdir>
}
  80035a:	c9                   	leave  
  80035b:	c3                   	ret    

0080035c <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  80035c:	55                   	push   %ebp
  80035d:	89 e5                	mov    %esp,%ebp
  80035f:	83 ec 28             	sub    $0x28,%esp
    int ret = main();
  800362:	e8 fd 0c 00 00       	call   801064 <main>
  800367:	89 45 f4             	mov    %eax,-0xc(%ebp)
    exit(ret);
  80036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80036d:	89 04 24             	mov    %eax,(%esp)
  800370:	e8 4b ff ff ff       	call   8002c0 <exit>
  800375:	00 00                	add    %al,(%eax)
	...

00800378 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  800378:	55                   	push   %ebp
  800379:	89 e5                	mov    %esp,%ebp
  80037b:	53                   	push   %ebx
  80037c:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  80037f:	8b 45 08             	mov    0x8(%ebp),%eax
  800382:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
  800388:	89 45 f8             	mov    %eax,-0x8(%ebp)
    return (hash >> (32 - bits));
  80038b:	b8 20 00 00 00       	mov    $0x20,%eax
  800390:	2b 45 0c             	sub    0xc(%ebp),%eax
  800393:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800396:	89 d3                	mov    %edx,%ebx
  800398:	89 c1                	mov    %eax,%ecx
  80039a:	d3 eb                	shr    %cl,%ebx
  80039c:	89 d8                	mov    %ebx,%eax
}
  80039e:	83 c4 10             	add    $0x10,%esp
  8003a1:	5b                   	pop    %ebx
  8003a2:	5d                   	pop    %ebp
  8003a3:	c3                   	ret    

008003a4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  8003a4:	55                   	push   %ebp
  8003a5:	89 e5                	mov    %esp,%ebp
  8003a7:	56                   	push   %esi
  8003a8:	53                   	push   %ebx
  8003a9:	83 ec 60             	sub    $0x60,%esp
  8003ac:	8b 45 10             	mov    0x10(%ebp),%eax
  8003af:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8003b2:	8b 45 14             	mov    0x14(%ebp),%eax
  8003b5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  8003b8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8003bb:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  8003be:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8003c1:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  8003c4:	8b 45 18             	mov    0x18(%ebp),%eax
  8003c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  8003ca:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8003cd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  8003d0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8003d3:	89 55 cc             	mov    %edx,-0x34(%ebp)
  8003d6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8003d9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  8003dc:	89 d3                	mov    %edx,%ebx
  8003de:	89 c6                	mov    %eax,%esi
  8003e0:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8003e3:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  8003e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
  8003ec:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  8003f0:	74 1c                	je     80040e <printnum+0x6a>
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	ba 00 00 00 00       	mov    $0x0,%edx
  8003fa:	f7 75 e4             	divl   -0x1c(%ebp)
  8003fd:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800400:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800403:	ba 00 00 00 00       	mov    $0x0,%edx
  800408:	f7 75 e4             	divl   -0x1c(%ebp)
  80040b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80040e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800411:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800414:	89 d6                	mov    %edx,%esi
  800416:	89 c3                	mov    %eax,%ebx
  800418:	89 f0                	mov    %esi,%eax
  80041a:	89 da                	mov    %ebx,%edx
  80041c:	f7 75 e4             	divl   -0x1c(%ebp)
  80041f:	89 d3                	mov    %edx,%ebx
  800421:	89 c6                	mov    %eax,%esi
  800423:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800426:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  800429:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80042c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  80042f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800432:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800435:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800438:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  80043b:	89 c3                	mov    %eax,%ebx
  80043d:	89 d6                	mov    %edx,%esi
  80043f:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  800442:	89 75 ec             	mov    %esi,-0x14(%ebp)
  800445:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800448:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  80044b:	8b 45 18             	mov    0x18(%ebp),%eax
  80044e:	ba 00 00 00 00       	mov    $0x0,%edx
  800453:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  800456:	77 56                	ja     8004ae <printnum+0x10a>
  800458:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  80045b:	72 05                	jb     800462 <printnum+0xbe>
  80045d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800460:	77 4c                	ja     8004ae <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
  800462:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800465:	8d 50 ff             	lea    -0x1(%eax),%edx
  800468:	8b 45 20             	mov    0x20(%ebp),%eax
  80046b:	89 44 24 18          	mov    %eax,0x18(%esp)
  80046f:	89 54 24 14          	mov    %edx,0x14(%esp)
  800473:	8b 45 18             	mov    0x18(%ebp),%eax
  800476:	89 44 24 10          	mov    %eax,0x10(%esp)
  80047a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80047d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800480:	89 44 24 08          	mov    %eax,0x8(%esp)
  800484:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800488:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80048f:	8b 45 08             	mov    0x8(%ebp),%eax
  800492:	89 04 24             	mov    %eax,(%esp)
  800495:	e8 0a ff ff ff       	call   8003a4 <printnum>
  80049a:	eb 1c                	jmp    8004b8 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  80049c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80049f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004a3:	8b 45 20             	mov    0x20(%ebp),%eax
  8004a6:	89 04 24             	mov    %eax,(%esp)
  8004a9:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ac:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  8004ae:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  8004b2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  8004b6:	7f e4                	jg     80049c <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  8004b8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  8004bb:	05 e4 12 80 00       	add    $0x8012e4,%eax
  8004c0:	0f b6 00             	movzbl (%eax),%eax
  8004c3:	0f be c0             	movsbl %al,%eax
  8004c6:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004c9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004cd:	89 04 24             	mov    %eax,(%esp)
  8004d0:	8b 45 08             	mov    0x8(%ebp),%eax
  8004d3:	ff d0                	call   *%eax
}
  8004d5:	83 c4 60             	add    $0x60,%esp
  8004d8:	5b                   	pop    %ebx
  8004d9:	5e                   	pop    %esi
  8004da:	5d                   	pop    %ebp
  8004db:	c3                   	ret    

008004dc <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  8004dc:	55                   	push   %ebp
  8004dd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  8004df:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8004e3:	7e 14                	jle    8004f9 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  8004e5:	8b 45 08             	mov    0x8(%ebp),%eax
  8004e8:	8b 00                	mov    (%eax),%eax
  8004ea:	8d 48 08             	lea    0x8(%eax),%ecx
  8004ed:	8b 55 08             	mov    0x8(%ebp),%edx
  8004f0:	89 0a                	mov    %ecx,(%edx)
  8004f2:	8b 50 04             	mov    0x4(%eax),%edx
  8004f5:	8b 00                	mov    (%eax),%eax
  8004f7:	eb 30                	jmp    800529 <getuint+0x4d>
    }
    else if (lflag) {
  8004f9:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8004fd:	74 16                	je     800515 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  8004ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800502:	8b 00                	mov    (%eax),%eax
  800504:	8d 48 04             	lea    0x4(%eax),%ecx
  800507:	8b 55 08             	mov    0x8(%ebp),%edx
  80050a:	89 0a                	mov    %ecx,(%edx)
  80050c:	8b 00                	mov    (%eax),%eax
  80050e:	ba 00 00 00 00       	mov    $0x0,%edx
  800513:	eb 14                	jmp    800529 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  800515:	8b 45 08             	mov    0x8(%ebp),%eax
  800518:	8b 00                	mov    (%eax),%eax
  80051a:	8d 48 04             	lea    0x4(%eax),%ecx
  80051d:	8b 55 08             	mov    0x8(%ebp),%edx
  800520:	89 0a                	mov    %ecx,(%edx)
  800522:	8b 00                	mov    (%eax),%eax
  800524:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  800529:	5d                   	pop    %ebp
  80052a:	c3                   	ret    

0080052b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  80052b:	55                   	push   %ebp
  80052c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  80052e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800532:	7e 14                	jle    800548 <getint+0x1d>
        return va_arg(*ap, long long);
  800534:	8b 45 08             	mov    0x8(%ebp),%eax
  800537:	8b 00                	mov    (%eax),%eax
  800539:	8d 48 08             	lea    0x8(%eax),%ecx
  80053c:	8b 55 08             	mov    0x8(%ebp),%edx
  80053f:	89 0a                	mov    %ecx,(%edx)
  800541:	8b 50 04             	mov    0x4(%eax),%edx
  800544:	8b 00                	mov    (%eax),%eax
  800546:	eb 30                	jmp    800578 <getint+0x4d>
    }
    else if (lflag) {
  800548:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80054c:	74 16                	je     800564 <getint+0x39>
        return va_arg(*ap, long);
  80054e:	8b 45 08             	mov    0x8(%ebp),%eax
  800551:	8b 00                	mov    (%eax),%eax
  800553:	8d 48 04             	lea    0x4(%eax),%ecx
  800556:	8b 55 08             	mov    0x8(%ebp),%edx
  800559:	89 0a                	mov    %ecx,(%edx)
  80055b:	8b 00                	mov    (%eax),%eax
  80055d:	89 c2                	mov    %eax,%edx
  80055f:	c1 fa 1f             	sar    $0x1f,%edx
  800562:	eb 14                	jmp    800578 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  800564:	8b 45 08             	mov    0x8(%ebp),%eax
  800567:	8b 00                	mov    (%eax),%eax
  800569:	8d 48 04             	lea    0x4(%eax),%ecx
  80056c:	8b 55 08             	mov    0x8(%ebp),%edx
  80056f:	89 0a                	mov    %ecx,(%edx)
  800571:	8b 00                	mov    (%eax),%eax
  800573:	89 c2                	mov    %eax,%edx
  800575:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  800578:	5d                   	pop    %ebp
  800579:	c3                   	ret    

0080057a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  80057a:	55                   	push   %ebp
  80057b:	89 e5                	mov    %esp,%ebp
  80057d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  800580:	8d 55 14             	lea    0x14(%ebp),%edx
  800583:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800586:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
  800588:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80058b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80058f:	8b 45 10             	mov    0x10(%ebp),%eax
  800592:	89 44 24 08          	mov    %eax,0x8(%esp)
  800596:	8b 45 0c             	mov    0xc(%ebp),%eax
  800599:	89 44 24 04          	mov    %eax,0x4(%esp)
  80059d:	8b 45 08             	mov    0x8(%ebp),%eax
  8005a0:	89 04 24             	mov    %eax,(%esp)
  8005a3:	e8 02 00 00 00       	call   8005aa <vprintfmt>
    va_end(ap);
}
  8005a8:	c9                   	leave  
  8005a9:	c3                   	ret    

008005aa <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  8005aa:	55                   	push   %ebp
  8005ab:	89 e5                	mov    %esp,%ebp
  8005ad:	56                   	push   %esi
  8005ae:	53                   	push   %ebx
  8005af:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8005b2:	eb 17                	jmp    8005cb <vprintfmt+0x21>
            if (ch == '\0') {
  8005b4:	85 db                	test   %ebx,%ebx
  8005b6:	0f 84 db 03 00 00    	je     800997 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
  8005bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8005bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005c3:	89 1c 24             	mov    %ebx,(%esp)
  8005c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8005c9:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8005cb:	8b 45 10             	mov    0x10(%ebp),%eax
  8005ce:	0f b6 00             	movzbl (%eax),%eax
  8005d1:	0f b6 d8             	movzbl %al,%ebx
  8005d4:	83 fb 25             	cmp    $0x25,%ebx
  8005d7:	0f 95 c0             	setne  %al
  8005da:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  8005de:	84 c0                	test   %al,%al
  8005e0:	75 d2                	jne    8005b4 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  8005e2:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  8005e6:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  8005ed:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8005f0:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  8005f3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  8005fa:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8005fd:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800600:	eb 04                	jmp    800606 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  800602:	90                   	nop
  800603:	eb 01                	jmp    800606 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  800605:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800606:	8b 45 10             	mov    0x10(%ebp),%eax
  800609:	0f b6 00             	movzbl (%eax),%eax
  80060c:	0f b6 d8             	movzbl %al,%ebx
  80060f:	89 d8                	mov    %ebx,%eax
  800611:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800615:	83 e8 23             	sub    $0x23,%eax
  800618:	83 f8 55             	cmp    $0x55,%eax
  80061b:	0f 87 45 03 00 00    	ja     800966 <vprintfmt+0x3bc>
  800621:	8b 04 85 08 13 80 00 	mov    0x801308(,%eax,4),%eax
  800628:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  80062a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  80062e:	eb d6                	jmp    800606 <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  800630:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  800634:	eb d0                	jmp    800606 <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  800636:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  80063d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800640:	89 d0                	mov    %edx,%eax
  800642:	c1 e0 02             	shl    $0x2,%eax
  800645:	01 d0                	add    %edx,%eax
  800647:	01 c0                	add    %eax,%eax
  800649:	01 d8                	add    %ebx,%eax
  80064b:	83 e8 30             	sub    $0x30,%eax
  80064e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  800651:	8b 45 10             	mov    0x10(%ebp),%eax
  800654:	0f b6 00             	movzbl (%eax),%eax
  800657:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  80065a:	83 fb 2f             	cmp    $0x2f,%ebx
  80065d:	7e 39                	jle    800698 <vprintfmt+0xee>
  80065f:	83 fb 39             	cmp    $0x39,%ebx
  800662:	7f 34                	jg     800698 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  800664:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  800668:	eb d3                	jmp    80063d <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  80066a:	8b 45 14             	mov    0x14(%ebp),%eax
  80066d:	8d 50 04             	lea    0x4(%eax),%edx
  800670:	89 55 14             	mov    %edx,0x14(%ebp)
  800673:	8b 00                	mov    (%eax),%eax
  800675:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  800678:	eb 1f                	jmp    800699 <vprintfmt+0xef>

        case '.':
            if (width < 0)
  80067a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80067e:	79 82                	jns    800602 <vprintfmt+0x58>
                width = 0;
  800680:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  800687:	e9 76 ff ff ff       	jmp    800602 <vprintfmt+0x58>

        case '#':
            altflag = 1;
  80068c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  800693:	e9 6e ff ff ff       	jmp    800606 <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  800698:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  800699:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80069d:	0f 89 62 ff ff ff    	jns    800605 <vprintfmt+0x5b>
                width = precision, precision = -1;
  8006a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8006a6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8006a9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  8006b0:	e9 50 ff ff ff       	jmp    800605 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  8006b5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  8006b9:	e9 48 ff ff ff       	jmp    800606 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  8006be:	8b 45 14             	mov    0x14(%ebp),%eax
  8006c1:	8d 50 04             	lea    0x4(%eax),%edx
  8006c4:	89 55 14             	mov    %edx,0x14(%ebp)
  8006c7:	8b 00                	mov    (%eax),%eax
  8006c9:	8b 55 0c             	mov    0xc(%ebp),%edx
  8006cc:	89 54 24 04          	mov    %edx,0x4(%esp)
  8006d0:	89 04 24             	mov    %eax,(%esp)
  8006d3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006d6:	ff d0                	call   *%eax
            break;
  8006d8:	e9 b4 02 00 00       	jmp    800991 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
  8006dd:	8b 45 14             	mov    0x14(%ebp),%eax
  8006e0:	8d 50 04             	lea    0x4(%eax),%edx
  8006e3:	89 55 14             	mov    %edx,0x14(%ebp)
  8006e6:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  8006e8:	85 db                	test   %ebx,%ebx
  8006ea:	79 02                	jns    8006ee <vprintfmt+0x144>
                err = -err;
  8006ec:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  8006ee:	83 fb 18             	cmp    $0x18,%ebx
  8006f1:	7f 0b                	jg     8006fe <vprintfmt+0x154>
  8006f3:	8b 34 9d 80 12 80 00 	mov    0x801280(,%ebx,4),%esi
  8006fa:	85 f6                	test   %esi,%esi
  8006fc:	75 23                	jne    800721 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
  8006fe:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800702:	c7 44 24 08 f5 12 80 	movl   $0x8012f5,0x8(%esp)
  800709:	00 
  80070a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800711:	8b 45 08             	mov    0x8(%ebp),%eax
  800714:	89 04 24             	mov    %eax,(%esp)
  800717:	e8 5e fe ff ff       	call   80057a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  80071c:	e9 70 02 00 00       	jmp    800991 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  800721:	89 74 24 0c          	mov    %esi,0xc(%esp)
  800725:	c7 44 24 08 fe 12 80 	movl   $0x8012fe,0x8(%esp)
  80072c:	00 
  80072d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800730:	89 44 24 04          	mov    %eax,0x4(%esp)
  800734:	8b 45 08             	mov    0x8(%ebp),%eax
  800737:	89 04 24             	mov    %eax,(%esp)
  80073a:	e8 3b fe ff ff       	call   80057a <printfmt>
            }
            break;
  80073f:	e9 4d 02 00 00       	jmp    800991 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  800744:	8b 45 14             	mov    0x14(%ebp),%eax
  800747:	8d 50 04             	lea    0x4(%eax),%edx
  80074a:	89 55 14             	mov    %edx,0x14(%ebp)
  80074d:	8b 30                	mov    (%eax),%esi
  80074f:	85 f6                	test   %esi,%esi
  800751:	75 05                	jne    800758 <vprintfmt+0x1ae>
                p = "(null)";
  800753:	be 01 13 80 00       	mov    $0x801301,%esi
            }
            if (width > 0 && padc != '-') {
  800758:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80075c:	7e 7c                	jle    8007da <vprintfmt+0x230>
  80075e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800762:	74 76                	je     8007da <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800764:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800767:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  80076a:	89 44 24 04          	mov    %eax,0x4(%esp)
  80076e:	89 34 24             	mov    %esi,(%esp)
  800771:	e8 25 04 00 00       	call   800b9b <strnlen>
  800776:	89 da                	mov    %ebx,%edx
  800778:	29 c2                	sub    %eax,%edx
  80077a:	89 d0                	mov    %edx,%eax
  80077c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  80077f:	eb 17                	jmp    800798 <vprintfmt+0x1ee>
                    putch(padc, putdat);
  800781:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800785:	8b 55 0c             	mov    0xc(%ebp),%edx
  800788:	89 54 24 04          	mov    %edx,0x4(%esp)
  80078c:	89 04 24             	mov    %eax,(%esp)
  80078f:	8b 45 08             	mov    0x8(%ebp),%eax
  800792:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  800794:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800798:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80079c:	7f e3                	jg     800781 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80079e:	eb 3a                	jmp    8007da <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
  8007a0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  8007a4:	74 1f                	je     8007c5 <vprintfmt+0x21b>
  8007a6:	83 fb 1f             	cmp    $0x1f,%ebx
  8007a9:	7e 05                	jle    8007b0 <vprintfmt+0x206>
  8007ab:	83 fb 7e             	cmp    $0x7e,%ebx
  8007ae:	7e 15                	jle    8007c5 <vprintfmt+0x21b>
                    putch('?', putdat);
  8007b0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b7:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  8007be:	8b 45 08             	mov    0x8(%ebp),%eax
  8007c1:	ff d0                	call   *%eax
  8007c3:	eb 0f                	jmp    8007d4 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
  8007c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007c8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007cc:	89 1c 24             	mov    %ebx,(%esp)
  8007cf:	8b 45 08             	mov    0x8(%ebp),%eax
  8007d2:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  8007d4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  8007d8:	eb 01                	jmp    8007db <vprintfmt+0x231>
  8007da:	90                   	nop
  8007db:	0f b6 06             	movzbl (%esi),%eax
  8007de:	0f be d8             	movsbl %al,%ebx
  8007e1:	85 db                	test   %ebx,%ebx
  8007e3:	0f 95 c0             	setne  %al
  8007e6:	83 c6 01             	add    $0x1,%esi
  8007e9:	84 c0                	test   %al,%al
  8007eb:	74 29                	je     800816 <vprintfmt+0x26c>
  8007ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007f1:	78 ad                	js     8007a0 <vprintfmt+0x1f6>
  8007f3:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  8007f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  8007fb:	79 a3                	jns    8007a0 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  8007fd:	eb 17                	jmp    800816 <vprintfmt+0x26c>
                putch(' ', putdat);
  8007ff:	8b 45 0c             	mov    0xc(%ebp),%eax
  800802:	89 44 24 04          	mov    %eax,0x4(%esp)
  800806:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80080d:	8b 45 08             	mov    0x8(%ebp),%eax
  800810:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  800812:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800816:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80081a:	7f e3                	jg     8007ff <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
  80081c:	e9 70 01 00 00       	jmp    800991 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  800821:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800824:	89 44 24 04          	mov    %eax,0x4(%esp)
  800828:	8d 45 14             	lea    0x14(%ebp),%eax
  80082b:	89 04 24             	mov    %eax,(%esp)
  80082e:	e8 f8 fc ff ff       	call   80052b <getint>
  800833:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800836:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  800839:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80083c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80083f:	85 d2                	test   %edx,%edx
  800841:	79 26                	jns    800869 <vprintfmt+0x2bf>
                putch('-', putdat);
  800843:	8b 45 0c             	mov    0xc(%ebp),%eax
  800846:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  800851:	8b 45 08             	mov    0x8(%ebp),%eax
  800854:	ff d0                	call   *%eax
                num = -(long long)num;
  800856:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800859:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80085c:	f7 d8                	neg    %eax
  80085e:	83 d2 00             	adc    $0x0,%edx
  800861:	f7 da                	neg    %edx
  800863:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800866:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  800869:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  800870:	e9 a8 00 00 00       	jmp    80091d <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  800875:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800878:	89 44 24 04          	mov    %eax,0x4(%esp)
  80087c:	8d 45 14             	lea    0x14(%ebp),%eax
  80087f:	89 04 24             	mov    %eax,(%esp)
  800882:	e8 55 fc ff ff       	call   8004dc <getuint>
  800887:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80088a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  80088d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  800894:	e9 84 00 00 00       	jmp    80091d <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  800899:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80089c:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a0:	8d 45 14             	lea    0x14(%ebp),%eax
  8008a3:	89 04 24             	mov    %eax,(%esp)
  8008a6:	e8 31 fc ff ff       	call   8004dc <getuint>
  8008ab:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ae:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  8008b1:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  8008b8:	eb 63                	jmp    80091d <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
  8008ba:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008c1:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8008c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8008cb:	ff d0                	call   *%eax
            putch('x', putdat);
  8008cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008d4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8008db:	8b 45 08             	mov    0x8(%ebp),%eax
  8008de:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8008e0:	8b 45 14             	mov    0x14(%ebp),%eax
  8008e3:	8d 50 04             	lea    0x4(%eax),%edx
  8008e6:	89 55 14             	mov    %edx,0x14(%ebp)
  8008e9:	8b 00                	mov    (%eax),%eax
  8008eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008ee:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  8008f5:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  8008fc:	eb 1f                	jmp    80091d <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  8008fe:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800901:	89 44 24 04          	mov    %eax,0x4(%esp)
  800905:	8d 45 14             	lea    0x14(%ebp),%eax
  800908:	89 04 24             	mov    %eax,(%esp)
  80090b:	e8 cc fb ff ff       	call   8004dc <getuint>
  800910:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800913:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  800916:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  80091d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  800921:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800924:	89 54 24 18          	mov    %edx,0x18(%esp)
  800928:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80092b:	89 54 24 14          	mov    %edx,0x14(%esp)
  80092f:	89 44 24 10          	mov    %eax,0x10(%esp)
  800933:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800936:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800939:	89 44 24 08          	mov    %eax,0x8(%esp)
  80093d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800941:	8b 45 0c             	mov    0xc(%ebp),%eax
  800944:	89 44 24 04          	mov    %eax,0x4(%esp)
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	89 04 24             	mov    %eax,(%esp)
  80094e:	e8 51 fa ff ff       	call   8003a4 <printnum>
            break;
  800953:	eb 3c                	jmp    800991 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  800955:	8b 45 0c             	mov    0xc(%ebp),%eax
  800958:	89 44 24 04          	mov    %eax,0x4(%esp)
  80095c:	89 1c 24             	mov    %ebx,(%esp)
  80095f:	8b 45 08             	mov    0x8(%ebp),%eax
  800962:	ff d0                	call   *%eax
            break;
  800964:	eb 2b                	jmp    800991 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  800966:	8b 45 0c             	mov    0xc(%ebp),%eax
  800969:	89 44 24 04          	mov    %eax,0x4(%esp)
  80096d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  800974:	8b 45 08             	mov    0x8(%ebp),%eax
  800977:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  800979:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  80097d:	eb 04                	jmp    800983 <vprintfmt+0x3d9>
  80097f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800983:	8b 45 10             	mov    0x10(%ebp),%eax
  800986:	83 e8 01             	sub    $0x1,%eax
  800989:	0f b6 00             	movzbl (%eax),%eax
  80098c:	3c 25                	cmp    $0x25,%al
  80098e:	75 ef                	jne    80097f <vprintfmt+0x3d5>
                /* do nothing */;
            break;
  800990:	90                   	nop
        }
    }
  800991:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800992:	e9 34 fc ff ff       	jmp    8005cb <vprintfmt+0x21>
            if (ch == '\0') {
                return;
  800997:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  800998:	83 c4 40             	add    $0x40,%esp
  80099b:	5b                   	pop    %ebx
  80099c:	5e                   	pop    %esi
  80099d:	5d                   	pop    %ebp
  80099e:	c3                   	ret    

0080099f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  80099f:	55                   	push   %ebp
  8009a0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  8009a2:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009a5:	8b 40 08             	mov    0x8(%eax),%eax
  8009a8:	8d 50 01             	lea    0x1(%eax),%edx
  8009ab:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009ae:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  8009b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b4:	8b 10                	mov    (%eax),%edx
  8009b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009b9:	8b 40 04             	mov    0x4(%eax),%eax
  8009bc:	39 c2                	cmp    %eax,%edx
  8009be:	73 12                	jae    8009d2 <sprintputch+0x33>
        *b->buf ++ = ch;
  8009c0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c3:	8b 00                	mov    (%eax),%eax
  8009c5:	8b 55 08             	mov    0x8(%ebp),%edx
  8009c8:	88 10                	mov    %dl,(%eax)
  8009ca:	8d 50 01             	lea    0x1(%eax),%edx
  8009cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d0:	89 10                	mov    %edx,(%eax)
    }
}
  8009d2:	5d                   	pop    %ebp
  8009d3:	c3                   	ret    

008009d4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  8009d4:	55                   	push   %ebp
  8009d5:	89 e5                	mov    %esp,%ebp
  8009d7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  8009da:	8d 55 14             	lea    0x14(%ebp),%edx
  8009dd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8009e0:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
  8009e2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009e5:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8009e9:	8b 45 10             	mov    0x10(%ebp),%eax
  8009ec:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009f0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009f3:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009f7:	8b 45 08             	mov    0x8(%ebp),%eax
  8009fa:	89 04 24             	mov    %eax,(%esp)
  8009fd:	e8 08 00 00 00       	call   800a0a <vsnprintf>
  800a02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  800a05:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a08:	c9                   	leave  
  800a09:	c3                   	ret    

00800a0a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  800a0a:	55                   	push   %ebp
  800a0b:	89 e5                	mov    %esp,%ebp
  800a0d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  800a10:	8b 45 08             	mov    0x8(%ebp),%eax
  800a13:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a16:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a19:	83 e8 01             	sub    $0x1,%eax
  800a1c:	03 45 08             	add    0x8(%ebp),%eax
  800a1f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a22:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  800a29:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800a2d:	74 0a                	je     800a39 <vsnprintf+0x2f>
  800a2f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800a32:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a35:	39 c2                	cmp    %eax,%edx
  800a37:	76 07                	jbe    800a40 <vsnprintf+0x36>
        return -E_INVAL;
  800a39:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800a3e:	eb 2a                	jmp    800a6a <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  800a40:	8b 45 14             	mov    0x14(%ebp),%eax
  800a43:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a47:	8b 45 10             	mov    0x10(%ebp),%eax
  800a4a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a4e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800a51:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a55:	c7 04 24 9f 09 80 00 	movl   $0x80099f,(%esp)
  800a5c:	e8 49 fb ff ff       	call   8005aa <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  800a61:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800a64:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  800a67:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a6a:	c9                   	leave  
  800a6b:	c3                   	ret    

00800a6c <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  800a6c:	55                   	push   %ebp
  800a6d:	89 e5                	mov    %esp,%ebp
  800a6f:	57                   	push   %edi
  800a70:	56                   	push   %esi
  800a71:	53                   	push   %ebx
  800a72:	83 ec 34             	sub    $0x34,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  800a75:	a1 00 20 80 00       	mov    0x802000,%eax
  800a7a:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800a80:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
  800a86:	6b c8 05             	imul   $0x5,%eax,%ecx
  800a89:	01 cf                	add    %ecx,%edi
  800a8b:	b9 6d e6 ec de       	mov    $0xdeece66d,%ecx
  800a90:	f7 e1                	mul    %ecx
  800a92:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  800a95:	89 ca                	mov    %ecx,%edx
  800a97:	83 c0 0b             	add    $0xb,%eax
  800a9a:	83 d2 00             	adc    $0x0,%edx
  800a9d:	89 c3                	mov    %eax,%ebx
  800a9f:	80 e7 ff             	and    $0xff,%bh
  800aa2:	0f b7 f2             	movzwl %dx,%esi
  800aa5:	89 1d 00 20 80 00    	mov    %ebx,0x802000
  800aab:	89 35 04 20 80 00    	mov    %esi,0x802004
    unsigned long long result = (next >> 12);
  800ab1:	a1 00 20 80 00       	mov    0x802000,%eax
  800ab6:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800abc:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  800ac0:	c1 ea 0c             	shr    $0xc,%edx
  800ac3:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800ac6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
  800ac9:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  800ad0:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800ad3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800ad6:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800ad9:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800adc:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800adf:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800ae2:	89 d3                	mov    %edx,%ebx
  800ae4:	89 c6                	mov    %eax,%esi
  800ae6:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800ae9:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  800aec:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800aef:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800af2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800af6:	74 1c                	je     800b14 <rand+0xa8>
  800af8:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800afb:	ba 00 00 00 00       	mov    $0x0,%edx
  800b00:	f7 75 dc             	divl   -0x24(%ebp)
  800b03:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800b06:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b09:	ba 00 00 00 00       	mov    $0x0,%edx
  800b0e:	f7 75 dc             	divl   -0x24(%ebp)
  800b11:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800b14:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b17:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b1a:	89 d6                	mov    %edx,%esi
  800b1c:	89 c3                	mov    %eax,%ebx
  800b1e:	89 f0                	mov    %esi,%eax
  800b20:	89 da                	mov    %ebx,%edx
  800b22:	f7 75 dc             	divl   -0x24(%ebp)
  800b25:	89 d3                	mov    %edx,%ebx
  800b27:	89 c6                	mov    %eax,%esi
  800b29:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800b2c:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800b2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800b32:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800b35:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800b38:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800b3b:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b3e:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800b41:	89 c3                	mov    %eax,%ebx
  800b43:	89 d6                	mov    %edx,%esi
  800b45:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800b48:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800b4b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800b4e:	83 c4 34             	add    $0x34,%esp
  800b51:	5b                   	pop    %ebx
  800b52:	5e                   	pop    %esi
  800b53:	5f                   	pop    %edi
  800b54:	5d                   	pop    %ebp
  800b55:	c3                   	ret    

00800b56 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  800b56:	55                   	push   %ebp
  800b57:	89 e5                	mov    %esp,%ebp
    next = seed;
  800b59:	8b 45 08             	mov    0x8(%ebp),%eax
  800b5c:	ba 00 00 00 00       	mov    $0x0,%edx
  800b61:	a3 00 20 80 00       	mov    %eax,0x802000
  800b66:	89 15 04 20 80 00    	mov    %edx,0x802004
}
  800b6c:	5d                   	pop    %ebp
  800b6d:	c3                   	ret    
	...

00800b70 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  800b70:	55                   	push   %ebp
  800b71:	89 e5                	mov    %esp,%ebp
  800b73:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800b76:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  800b7d:	eb 04                	jmp    800b83 <strlen+0x13>
        cnt ++;
  800b7f:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  800b83:	8b 45 08             	mov    0x8(%ebp),%eax
  800b86:	0f b6 00             	movzbl (%eax),%eax
  800b89:	84 c0                	test   %al,%al
  800b8b:	0f 95 c0             	setne  %al
  800b8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800b92:	84 c0                	test   %al,%al
  800b94:	75 e9                	jne    800b7f <strlen+0xf>
        cnt ++;
    }
    return cnt;
  800b96:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800b99:	c9                   	leave  
  800b9a:	c3                   	ret    

00800b9b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  800b9b:	55                   	push   %ebp
  800b9c:	89 e5                	mov    %esp,%ebp
  800b9e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800ba1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  800ba8:	eb 04                	jmp    800bae <strnlen+0x13>
        cnt ++;
  800baa:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  800bae:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800bb1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800bb4:	73 13                	jae    800bc9 <strnlen+0x2e>
  800bb6:	8b 45 08             	mov    0x8(%ebp),%eax
  800bb9:	0f b6 00             	movzbl (%eax),%eax
  800bbc:	84 c0                	test   %al,%al
  800bbe:	0f 95 c0             	setne  %al
  800bc1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800bc5:	84 c0                	test   %al,%al
  800bc7:	75 e1                	jne    800baa <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  800bc9:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800bcc:	c9                   	leave  
  800bcd:	c3                   	ret    

00800bce <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  800bce:	55                   	push   %ebp
  800bcf:	89 e5                	mov    %esp,%ebp
  800bd1:	57                   	push   %edi
  800bd2:	56                   	push   %esi
  800bd3:	53                   	push   %ebx
  800bd4:	83 ec 24             	sub    $0x24,%esp
  800bd7:	8b 45 08             	mov    0x8(%ebp),%eax
  800bda:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800bdd:	8b 45 0c             	mov    0xc(%ebp),%eax
  800be0:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  800be3:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800be6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800be9:	89 d6                	mov    %edx,%esi
  800beb:	89 c3                	mov    %eax,%ebx
  800bed:	89 df                	mov    %ebx,%edi
  800bef:	ac                   	lods   %ds:(%esi),%al
  800bf0:	aa                   	stos   %al,%es:(%edi)
  800bf1:	84 c0                	test   %al,%al
  800bf3:	75 fa                	jne    800bef <strcpy+0x21>
  800bf5:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800bf8:	89 fb                	mov    %edi,%ebx
  800bfa:	89 75 e8             	mov    %esi,-0x18(%ebp)
  800bfd:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800c00:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c03:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  800c06:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  800c09:	83 c4 24             	add    $0x24,%esp
  800c0c:	5b                   	pop    %ebx
  800c0d:	5e                   	pop    %esi
  800c0e:	5f                   	pop    %edi
  800c0f:	5d                   	pop    %ebp
  800c10:	c3                   	ret    

00800c11 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  800c11:	55                   	push   %ebp
  800c12:	89 e5                	mov    %esp,%ebp
  800c14:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  800c17:	8b 45 08             	mov    0x8(%ebp),%eax
  800c1a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  800c1d:	eb 21                	jmp    800c40 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  800c1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c22:	0f b6 10             	movzbl (%eax),%edx
  800c25:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c28:	88 10                	mov    %dl,(%eax)
  800c2a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c2d:	0f b6 00             	movzbl (%eax),%eax
  800c30:	84 c0                	test   %al,%al
  800c32:	74 04                	je     800c38 <strncpy+0x27>
            src ++;
  800c34:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  800c38:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800c3c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  800c40:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800c44:	75 d9                	jne    800c1f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  800c46:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800c49:	c9                   	leave  
  800c4a:	c3                   	ret    

00800c4b <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  800c4b:	55                   	push   %ebp
  800c4c:	89 e5                	mov    %esp,%ebp
  800c4e:	57                   	push   %edi
  800c4f:	56                   	push   %esi
  800c50:	53                   	push   %ebx
  800c51:	83 ec 24             	sub    $0x24,%esp
  800c54:	8b 45 08             	mov    0x8(%ebp),%eax
  800c57:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5a:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c5d:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  800c60:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800c63:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800c66:	89 d6                	mov    %edx,%esi
  800c68:	89 c3                	mov    %eax,%ebx
  800c6a:	89 df                	mov    %ebx,%edi
  800c6c:	ac                   	lods   %ds:(%esi),%al
  800c6d:	ae                   	scas   %es:(%edi),%al
  800c6e:	75 08                	jne    800c78 <strcmp+0x2d>
  800c70:	84 c0                	test   %al,%al
  800c72:	75 f8                	jne    800c6c <strcmp+0x21>
  800c74:	31 c0                	xor    %eax,%eax
  800c76:	eb 04                	jmp    800c7c <strcmp+0x31>
  800c78:	19 c0                	sbb    %eax,%eax
  800c7a:	0c 01                	or     $0x1,%al
  800c7c:	89 fb                	mov    %edi,%ebx
  800c7e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c81:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c84:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800c87:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800c8a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  800c8d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  800c90:	83 c4 24             	add    $0x24,%esp
  800c93:	5b                   	pop    %ebx
  800c94:	5e                   	pop    %esi
  800c95:	5f                   	pop    %edi
  800c96:	5d                   	pop    %ebp
  800c97:	c3                   	ret    

00800c98 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  800c98:	55                   	push   %ebp
  800c99:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800c9b:	eb 0c                	jmp    800ca9 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  800c9d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800ca1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ca5:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800ca9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cad:	74 1a                	je     800cc9 <strncmp+0x31>
  800caf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cb2:	0f b6 00             	movzbl (%eax),%eax
  800cb5:	84 c0                	test   %al,%al
  800cb7:	74 10                	je     800cc9 <strncmp+0x31>
  800cb9:	8b 45 08             	mov    0x8(%ebp),%eax
  800cbc:	0f b6 10             	movzbl (%eax),%edx
  800cbf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cc2:	0f b6 00             	movzbl (%eax),%eax
  800cc5:	38 c2                	cmp    %al,%dl
  800cc7:	74 d4                	je     800c9d <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  800cc9:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800ccd:	74 1a                	je     800ce9 <strncmp+0x51>
  800ccf:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd2:	0f b6 00             	movzbl (%eax),%eax
  800cd5:	0f b6 d0             	movzbl %al,%edx
  800cd8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdb:	0f b6 00             	movzbl (%eax),%eax
  800cde:	0f b6 c0             	movzbl %al,%eax
  800ce1:	89 d1                	mov    %edx,%ecx
  800ce3:	29 c1                	sub    %eax,%ecx
  800ce5:	89 c8                	mov    %ecx,%eax
  800ce7:	eb 05                	jmp    800cee <strncmp+0x56>
  800ce9:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800cee:	5d                   	pop    %ebp
  800cef:	c3                   	ret    

00800cf0 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  800cf0:	55                   	push   %ebp
  800cf1:	89 e5                	mov    %esp,%ebp
  800cf3:	83 ec 04             	sub    $0x4,%esp
  800cf6:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cf9:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800cfc:	eb 14                	jmp    800d12 <strchr+0x22>
        if (*s == c) {
  800cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  800d01:	0f b6 00             	movzbl (%eax),%eax
  800d04:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d07:	75 05                	jne    800d0e <strchr+0x1e>
            return (char *)s;
  800d09:	8b 45 08             	mov    0x8(%ebp),%eax
  800d0c:	eb 13                	jmp    800d21 <strchr+0x31>
        }
        s ++;
  800d0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  800d12:	8b 45 08             	mov    0x8(%ebp),%eax
  800d15:	0f b6 00             	movzbl (%eax),%eax
  800d18:	84 c0                	test   %al,%al
  800d1a:	75 e2                	jne    800cfe <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  800d1c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d21:	c9                   	leave  
  800d22:	c3                   	ret    

00800d23 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 04             	sub    $0x4,%esp
  800d29:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d2c:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800d2f:	eb 0f                	jmp    800d40 <strfind+0x1d>
        if (*s == c) {
  800d31:	8b 45 08             	mov    0x8(%ebp),%eax
  800d34:	0f b6 00             	movzbl (%eax),%eax
  800d37:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d3a:	74 10                	je     800d4c <strfind+0x29>
            break;
        }
        s ++;
  800d3c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  800d40:	8b 45 08             	mov    0x8(%ebp),%eax
  800d43:	0f b6 00             	movzbl (%eax),%eax
  800d46:	84 c0                	test   %al,%al
  800d48:	75 e7                	jne    800d31 <strfind+0xe>
  800d4a:	eb 01                	jmp    800d4d <strfind+0x2a>
        if (*s == c) {
            break;
  800d4c:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800d50:	c9                   	leave  
  800d51:	c3                   	ret    

00800d52 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  800d52:	55                   	push   %ebp
  800d53:	89 e5                	mov    %esp,%ebp
  800d55:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  800d58:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  800d5f:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800d66:	eb 04                	jmp    800d6c <strtol+0x1a>
        s ++;
  800d68:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800d6c:	8b 45 08             	mov    0x8(%ebp),%eax
  800d6f:	0f b6 00             	movzbl (%eax),%eax
  800d72:	3c 20                	cmp    $0x20,%al
  800d74:	74 f2                	je     800d68 <strtol+0x16>
  800d76:	8b 45 08             	mov    0x8(%ebp),%eax
  800d79:	0f b6 00             	movzbl (%eax),%eax
  800d7c:	3c 09                	cmp    $0x9,%al
  800d7e:	74 e8                	je     800d68 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  800d80:	8b 45 08             	mov    0x8(%ebp),%eax
  800d83:	0f b6 00             	movzbl (%eax),%eax
  800d86:	3c 2b                	cmp    $0x2b,%al
  800d88:	75 06                	jne    800d90 <strtol+0x3e>
        s ++;
  800d8a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d8e:	eb 15                	jmp    800da5 <strtol+0x53>
    }
    else if (*s == '-') {
  800d90:	8b 45 08             	mov    0x8(%ebp),%eax
  800d93:	0f b6 00             	movzbl (%eax),%eax
  800d96:	3c 2d                	cmp    $0x2d,%al
  800d98:	75 0b                	jne    800da5 <strtol+0x53>
        s ++, neg = 1;
  800d9a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d9e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800da5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800da9:	74 06                	je     800db1 <strtol+0x5f>
  800dab:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800daf:	75 24                	jne    800dd5 <strtol+0x83>
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	0f b6 00             	movzbl (%eax),%eax
  800db7:	3c 30                	cmp    $0x30,%al
  800db9:	75 1a                	jne    800dd5 <strtol+0x83>
  800dbb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dbe:	83 c0 01             	add    $0x1,%eax
  800dc1:	0f b6 00             	movzbl (%eax),%eax
  800dc4:	3c 78                	cmp    $0x78,%al
  800dc6:	75 0d                	jne    800dd5 <strtol+0x83>
        s += 2, base = 16;
  800dc8:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800dcc:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800dd3:	eb 2a                	jmp    800dff <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  800dd5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800dd9:	75 17                	jne    800df2 <strtol+0xa0>
  800ddb:	8b 45 08             	mov    0x8(%ebp),%eax
  800dde:	0f b6 00             	movzbl (%eax),%eax
  800de1:	3c 30                	cmp    $0x30,%al
  800de3:	75 0d                	jne    800df2 <strtol+0xa0>
        s ++, base = 8;
  800de5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800de9:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800df0:	eb 0d                	jmp    800dff <strtol+0xad>
    }
    else if (base == 0) {
  800df2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800df6:	75 07                	jne    800dff <strtol+0xad>
        base = 10;
  800df8:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  800dff:	8b 45 08             	mov    0x8(%ebp),%eax
  800e02:	0f b6 00             	movzbl (%eax),%eax
  800e05:	3c 2f                	cmp    $0x2f,%al
  800e07:	7e 1b                	jle    800e24 <strtol+0xd2>
  800e09:	8b 45 08             	mov    0x8(%ebp),%eax
  800e0c:	0f b6 00             	movzbl (%eax),%eax
  800e0f:	3c 39                	cmp    $0x39,%al
  800e11:	7f 11                	jg     800e24 <strtol+0xd2>
            dig = *s - '0';
  800e13:	8b 45 08             	mov    0x8(%ebp),%eax
  800e16:	0f b6 00             	movzbl (%eax),%eax
  800e19:	0f be c0             	movsbl %al,%eax
  800e1c:	83 e8 30             	sub    $0x30,%eax
  800e1f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e22:	eb 48                	jmp    800e6c <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  800e24:	8b 45 08             	mov    0x8(%ebp),%eax
  800e27:	0f b6 00             	movzbl (%eax),%eax
  800e2a:	3c 60                	cmp    $0x60,%al
  800e2c:	7e 1b                	jle    800e49 <strtol+0xf7>
  800e2e:	8b 45 08             	mov    0x8(%ebp),%eax
  800e31:	0f b6 00             	movzbl (%eax),%eax
  800e34:	3c 7a                	cmp    $0x7a,%al
  800e36:	7f 11                	jg     800e49 <strtol+0xf7>
            dig = *s - 'a' + 10;
  800e38:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3b:	0f b6 00             	movzbl (%eax),%eax
  800e3e:	0f be c0             	movsbl %al,%eax
  800e41:	83 e8 57             	sub    $0x57,%eax
  800e44:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800e47:	eb 23                	jmp    800e6c <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  800e49:	8b 45 08             	mov    0x8(%ebp),%eax
  800e4c:	0f b6 00             	movzbl (%eax),%eax
  800e4f:	3c 40                	cmp    $0x40,%al
  800e51:	7e 38                	jle    800e8b <strtol+0x139>
  800e53:	8b 45 08             	mov    0x8(%ebp),%eax
  800e56:	0f b6 00             	movzbl (%eax),%eax
  800e59:	3c 5a                	cmp    $0x5a,%al
  800e5b:	7f 2e                	jg     800e8b <strtol+0x139>
            dig = *s - 'A' + 10;
  800e5d:	8b 45 08             	mov    0x8(%ebp),%eax
  800e60:	0f b6 00             	movzbl (%eax),%eax
  800e63:	0f be c0             	movsbl %al,%eax
  800e66:	83 e8 37             	sub    $0x37,%eax
  800e69:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  800e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800e6f:	3b 45 10             	cmp    0x10(%ebp),%eax
  800e72:	7d 16                	jge    800e8a <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
  800e74:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e78:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800e7b:	0f af 45 10          	imul   0x10(%ebp),%eax
  800e7f:	03 45 f4             	add    -0xc(%ebp),%eax
  800e82:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  800e85:	e9 75 ff ff ff       	jmp    800dff <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  800e8a:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  800e8b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800e8f:	74 08                	je     800e99 <strtol+0x147>
        *endptr = (char *) s;
  800e91:	8b 45 0c             	mov    0xc(%ebp),%eax
  800e94:	8b 55 08             	mov    0x8(%ebp),%edx
  800e97:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  800e99:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800e9d:	74 07                	je     800ea6 <strtol+0x154>
  800e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800ea2:	f7 d8                	neg    %eax
  800ea4:	eb 03                	jmp    800ea9 <strtol+0x157>
  800ea6:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800ea9:	c9                   	leave  
  800eaa:	c3                   	ret    

00800eab <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  800eab:	55                   	push   %ebp
  800eac:	89 e5                	mov    %esp,%ebp
  800eae:	57                   	push   %edi
  800eaf:	56                   	push   %esi
  800eb0:	53                   	push   %ebx
  800eb1:	83 ec 24             	sub    $0x24,%esp
  800eb4:	8b 45 0c             	mov    0xc(%ebp),%eax
  800eb7:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  800eba:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  800ebe:	8b 55 08             	mov    0x8(%ebp),%edx
  800ec1:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800ec4:	88 45 ef             	mov    %al,-0x11(%ebp)
  800ec7:	8b 45 10             	mov    0x10(%ebp),%eax
  800eca:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  800ecd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  800ed0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  800ed4:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ed7:	89 ce                	mov    %ecx,%esi
  800ed9:	89 d3                	mov    %edx,%ebx
  800edb:	89 f1                	mov    %esi,%ecx
  800edd:	89 df                	mov    %ebx,%edi
  800edf:	f3 aa                	rep stos %al,%es:(%edi)
  800ee1:	89 fb                	mov    %edi,%ebx
  800ee3:	89 ce                	mov    %ecx,%esi
  800ee5:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800ee8:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  800eeb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800eee:	83 c4 24             	add    $0x24,%esp
  800ef1:	5b                   	pop    %ebx
  800ef2:	5e                   	pop    %esi
  800ef3:	5f                   	pop    %edi
  800ef4:	5d                   	pop    %ebp
  800ef5:	c3                   	ret    

00800ef6 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  800ef6:	55                   	push   %ebp
  800ef7:	89 e5                	mov    %esp,%ebp
  800ef9:	57                   	push   %edi
  800efa:	56                   	push   %esi
  800efb:	53                   	push   %ebx
  800efc:	83 ec 38             	sub    $0x38,%esp
  800eff:	8b 45 08             	mov    0x8(%ebp),%eax
  800f02:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f08:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f0b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f0e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  800f11:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f14:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800f17:	73 4e                	jae    800f67 <memmove+0x71>
  800f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f1c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f1f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800f22:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800f25:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f28:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800f2b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800f2e:	89 c1                	mov    %eax,%ecx
  800f30:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800f33:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800f36:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800f39:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800f3c:	89 d7                	mov    %edx,%edi
  800f3e:	89 c3                	mov    %eax,%ebx
  800f40:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800f43:	89 de                	mov    %ebx,%esi
  800f45:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800f47:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800f4a:	83 e1 03             	and    $0x3,%ecx
  800f4d:	74 02                	je     800f51 <memmove+0x5b>
  800f4f:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800f51:	89 f3                	mov    %esi,%ebx
  800f53:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800f56:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800f59:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800f5c:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800f5f:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800f62:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f65:	eb 3b                	jmp    800fa2 <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  800f67:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f6a:	83 e8 01             	sub    $0x1,%eax
  800f6d:	89 c2                	mov    %eax,%edx
  800f6f:	03 55 ec             	add    -0x14(%ebp),%edx
  800f72:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800f75:	83 e8 01             	sub    $0x1,%eax
  800f78:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  800f7b:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  800f7e:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  800f81:	89 d6                	mov    %edx,%esi
  800f83:	89 c3                	mov    %eax,%ebx
  800f85:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  800f88:	89 df                	mov    %ebx,%edi
  800f8a:	fd                   	std    
  800f8b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800f8d:	fc                   	cld    
  800f8e:	89 fb                	mov    %edi,%ebx
  800f90:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  800f93:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  800f96:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  800f99:	89 75 c8             	mov    %esi,-0x38(%ebp)
  800f9c:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  800f9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  800fa2:	83 c4 38             	add    $0x38,%esp
  800fa5:	5b                   	pop    %ebx
  800fa6:	5e                   	pop    %esi
  800fa7:	5f                   	pop    %edi
  800fa8:	5d                   	pop    %ebp
  800fa9:	c3                   	ret    

00800faa <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  800faa:	55                   	push   %ebp
  800fab:	89 e5                	mov    %esp,%ebp
  800fad:	57                   	push   %edi
  800fae:	56                   	push   %esi
  800faf:	53                   	push   %ebx
  800fb0:	83 ec 24             	sub    $0x24,%esp
  800fb3:	8b 45 08             	mov    0x8(%ebp),%eax
  800fb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800fb9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800fbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800fbf:	8b 45 10             	mov    0x10(%ebp),%eax
  800fc2:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800fc5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fc8:	89 c1                	mov    %eax,%ecx
  800fca:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800fcd:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800fd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fd3:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800fd6:	89 d7                	mov    %edx,%edi
  800fd8:	89 c3                	mov    %eax,%ebx
  800fda:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800fdd:	89 de                	mov    %ebx,%esi
  800fdf:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fe1:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  800fe4:	83 e1 03             	and    $0x3,%ecx
  800fe7:	74 02                	je     800feb <memcpy+0x41>
  800fe9:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800feb:	89 f3                	mov    %esi,%ebx
  800fed:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  800ff0:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  800ff3:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  800ff6:	89 7d e0             	mov    %edi,-0x20(%ebp)
  800ff9:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800ffc:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  800fff:	83 c4 24             	add    $0x24,%esp
  801002:	5b                   	pop    %ebx
  801003:	5e                   	pop    %esi
  801004:	5f                   	pop    %edi
  801005:	5d                   	pop    %ebp
  801006:	c3                   	ret    

00801007 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  801007:	55                   	push   %ebp
  801008:	89 e5                	mov    %esp,%ebp
  80100a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  80100d:	8b 45 08             	mov    0x8(%ebp),%eax
  801010:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  801013:	8b 45 0c             	mov    0xc(%ebp),%eax
  801016:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  801019:	eb 32                	jmp    80104d <memcmp+0x46>
        if (*s1 != *s2) {
  80101b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80101e:	0f b6 10             	movzbl (%eax),%edx
  801021:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801024:	0f b6 00             	movzbl (%eax),%eax
  801027:	38 c2                	cmp    %al,%dl
  801029:	74 1a                	je     801045 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  80102b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80102e:	0f b6 00             	movzbl (%eax),%eax
  801031:	0f b6 d0             	movzbl %al,%edx
  801034:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801037:	0f b6 00             	movzbl (%eax),%eax
  80103a:	0f b6 c0             	movzbl %al,%eax
  80103d:	89 d1                	mov    %edx,%ecx
  80103f:	29 c1                	sub    %eax,%ecx
  801041:	89 c8                	mov    %ecx,%eax
  801043:	eb 1c                	jmp    801061 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  801045:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801049:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  80104d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801051:	0f 95 c0             	setne  %al
  801054:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  801058:	84 c0                	test   %al,%al
  80105a:	75 bf                	jne    80101b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  80105c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801061:	c9                   	leave  
  801062:	c3                   	ret    
	...

00801064 <main>:
#define ARRAYSIZE (1024*1024)

uint32_t bigarray[ARRAYSIZE];

int
main(void) {
  801064:	55                   	push   %ebp
  801065:	89 e5                	mov    %esp,%ebp
  801067:	83 e4 f0             	and    $0xfffffff0,%esp
  80106a:	83 ec 20             	sub    $0x20,%esp
    cprintf("Making sure bss works right...\n");
  80106d:	c7 04 24 60 14 80 00 	movl   $0x801460,(%esp)
  801074:	e8 a6 f0 ff ff       	call   80011f <cprintf>
    int i;
    for (i = 0; i < ARRAYSIZE; i ++) {
  801079:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  801080:	00 
  801081:	eb 38                	jmp    8010bb <main+0x57>
        if (bigarray[i] != 0) {
  801083:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  801087:	8b 04 85 20 20 80 00 	mov    0x802020(,%eax,4),%eax
  80108e:	85 c0                	test   %eax,%eax
  801090:	74 24                	je     8010b6 <main+0x52>
            panic("bigarray[%d] isn't cleared!\n", i);
  801092:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  801096:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80109a:	c7 44 24 08 80 14 80 	movl   $0x801480,0x8(%esp)
  8010a1:	00 
  8010a2:	c7 44 24 04 0e 00 00 	movl   $0xe,0x4(%esp)
  8010a9:	00 
  8010aa:	c7 04 24 9d 14 80 00 	movl   $0x80149d,(%esp)
  8010b1:	e8 7a ef ff ff       	call   800030 <__panic>

int
main(void) {
    cprintf("Making sure bss works right...\n");
    int i;
    for (i = 0; i < ARRAYSIZE; i ++) {
  8010b6:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  8010bb:	81 7c 24 1c ff ff 0f 	cmpl   $0xfffff,0x1c(%esp)
  8010c2:	00 
  8010c3:	7e be                	jle    801083 <main+0x1f>
        if (bigarray[i] != 0) {
            panic("bigarray[%d] isn't cleared!\n", i);
        }
    }
    for (i = 0; i < ARRAYSIZE; i ++) {
  8010c5:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  8010cc:	00 
  8010cd:	eb 14                	jmp    8010e3 <main+0x7f>
        bigarray[i] = i;
  8010cf:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  8010d3:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  8010d7:	89 14 85 20 20 80 00 	mov    %edx,0x802020(,%eax,4)
    for (i = 0; i < ARRAYSIZE; i ++) {
        if (bigarray[i] != 0) {
            panic("bigarray[%d] isn't cleared!\n", i);
        }
    }
    for (i = 0; i < ARRAYSIZE; i ++) {
  8010de:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  8010e3:	81 7c 24 1c ff ff 0f 	cmpl   $0xfffff,0x1c(%esp)
  8010ea:	00 
  8010eb:	7e e2                	jle    8010cf <main+0x6b>
        bigarray[i] = i;
    }
    for (i = 0; i < ARRAYSIZE; i ++) {
  8010ed:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  8010f4:	00 
  8010f5:	eb 3c                	jmp    801133 <main+0xcf>
        if (bigarray[i] != i) {
  8010f7:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  8010fb:	8b 14 85 20 20 80 00 	mov    0x802020(,%eax,4),%edx
  801102:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  801106:	39 c2                	cmp    %eax,%edx
  801108:	74 24                	je     80112e <main+0xca>
            panic("bigarray[%d] didn't hold its value!\n", i);
  80110a:	8b 44 24 1c          	mov    0x1c(%esp),%eax
  80110e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801112:	c7 44 24 08 ac 14 80 	movl   $0x8014ac,0x8(%esp)
  801119:	00 
  80111a:	c7 44 24 04 16 00 00 	movl   $0x16,0x4(%esp)
  801121:	00 
  801122:	c7 04 24 9d 14 80 00 	movl   $0x80149d,(%esp)
  801129:	e8 02 ef ff ff       	call   800030 <__panic>
        }
    }
    for (i = 0; i < ARRAYSIZE; i ++) {
        bigarray[i] = i;
    }
    for (i = 0; i < ARRAYSIZE; i ++) {
  80112e:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  801133:	81 7c 24 1c ff ff 0f 	cmpl   $0xfffff,0x1c(%esp)
  80113a:	00 
  80113b:	7e ba                	jle    8010f7 <main+0x93>
        if (bigarray[i] != i) {
            panic("bigarray[%d] didn't hold its value!\n", i);
        }
    }

    cprintf("Yes, good.  Now doing a wild write off the end...\n");
  80113d:	c7 04 24 d4 14 80 00 	movl   $0x8014d4,(%esp)
  801144:	e8 d6 ef ff ff       	call   80011f <cprintf>
    cprintf("testbss may pass.\n");
  801149:	c7 04 24 07 15 80 00 	movl   $0x801507,(%esp)
  801150:	e8 ca ef ff ff       	call   80011f <cprintf>

    bigarray[ARRAYSIZE + 1024] = 0;
  801155:	c7 05 20 30 c0 00 00 	movl   $0x0,0xc03020
  80115c:	00 00 00 
    asm volatile ("int $0x14");
  80115f:	cd 14                	int    $0x14
    panic("FAIL: T.T\n");
  801161:	c7 44 24 08 1a 15 80 	movl   $0x80151a,0x8(%esp)
  801168:	00 
  801169:	c7 44 24 04 1f 00 00 	movl   $0x1f,0x4(%esp)
  801170:	00 
  801171:	c7 04 24 9d 14 80 00 	movl   $0x80149d,(%esp)
  801178:	e8 b3 ee ff ff       	call   800030 <__panic>
