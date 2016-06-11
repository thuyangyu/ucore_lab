
obj/__user_forktree.out:     file format elf32-i386


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
  800028:	e8 af 03 00 00       	call   8003dc <umain>
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
  80004c:	c7 04 24 c0 11 80 00 	movl   $0x8011c0,(%esp)
  800053:	e8 c7 00 00 00       	call   80011f <cprintf>
    vcprintf(fmt, ap);
  800058:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80005b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80005f:	8b 45 10             	mov    0x10(%ebp),%eax
  800062:	89 04 24             	mov    %eax,(%esp)
  800065:	e8 82 00 00 00       	call   8000ec <vcprintf>
    cprintf("\n");
  80006a:	c7 04 24 da 11 80 00 	movl   $0x8011da,(%esp)
  800071:	e8 a9 00 00 00       	call   80011f <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800076:	c7 04 24 f6 ff ff ff 	movl   $0xfffffff6,(%esp)
  80007d:	e8 8a 02 00 00       	call   80030c <exit>

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
  80009e:	c7 04 24 dc 11 80 00 	movl   $0x8011dc,(%esp)
  8000a5:	e8 75 00 00 00       	call   80011f <cprintf>
    vcprintf(fmt, ap);
  8000aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8000ad:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000b1:	8b 45 10             	mov    0x10(%ebp),%eax
  8000b4:	89 04 24             	mov    %eax,(%esp)
  8000b7:	e8 30 00 00 00       	call   8000ec <vcprintf>
    cprintf("\n");
  8000bc:	c7 04 24 da 11 80 00 	movl   $0x8011da,(%esp)
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
  800115:	e8 10 05 00 00       	call   80062a <vprintfmt>
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

008002ee <sys_sleep>:

int
sys_sleep(unsigned int time) {
  8002ee:	55                   	push   %ebp
  8002ef:	89 e5                	mov    %esp,%ebp
  8002f1:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_sleep, time);
  8002f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8002f7:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002fb:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  800302:	e8 95 fe ff ff       	call   80019c <syscall>
}
  800307:	c9                   	leave  
  800308:	c3                   	ret    
  800309:	00 00                	add    %al,(%eax)
	...

0080030c <exit>:
#include <syscall.h>
#include <stdio.h>
#include <ulib.h>

void
exit(int error_code) {
  80030c:	55                   	push   %ebp
  80030d:	89 e5                	mov    %esp,%ebp
  80030f:	83 ec 18             	sub    $0x18,%esp
    sys_exit(error_code);
  800312:	8b 45 08             	mov    0x8(%ebp),%eax
  800315:	89 04 24             	mov    %eax,(%esp)
  800318:	e8 df fe ff ff       	call   8001fc <sys_exit>
    cprintf("BUG: exit failed.\n");
  80031d:	c7 04 24 f8 11 80 00 	movl   $0x8011f8,(%esp)
  800324:	e8 f6 fd ff ff       	call   80011f <cprintf>
    while (1);
  800329:	eb fe                	jmp    800329 <exit+0x1d>

0080032b <fork>:
}

int
fork(void) {
  80032b:	55                   	push   %ebp
  80032c:	89 e5                	mov    %esp,%ebp
  80032e:	83 ec 08             	sub    $0x8,%esp
    return sys_fork();
  800331:	e8 e1 fe ff ff       	call   800217 <sys_fork>
}
  800336:	c9                   	leave  
  800337:	c3                   	ret    

00800338 <wait>:

int
wait(void) {
  800338:	55                   	push   %ebp
  800339:	89 e5                	mov    %esp,%ebp
  80033b:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(0, NULL);
  80033e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800345:	00 
  800346:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80034d:	e8 d9 fe ff ff       	call   80022b <sys_wait>
}
  800352:	c9                   	leave  
  800353:	c3                   	ret    

00800354 <waitpid>:

int
waitpid(int pid, int *store) {
  800354:	55                   	push   %ebp
  800355:	89 e5                	mov    %esp,%ebp
  800357:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(pid, store);
  80035a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80035d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800361:	8b 45 08             	mov    0x8(%ebp),%eax
  800364:	89 04 24             	mov    %eax,(%esp)
  800367:	e8 bf fe ff ff       	call   80022b <sys_wait>
}
  80036c:	c9                   	leave  
  80036d:	c3                   	ret    

0080036e <yield>:

void
yield(void) {
  80036e:	55                   	push   %ebp
  80036f:	89 e5                	mov    %esp,%ebp
  800371:	83 ec 08             	sub    $0x8,%esp
    sys_yield();
  800374:	e8 d4 fe ff ff       	call   80024d <sys_yield>
}
  800379:	c9                   	leave  
  80037a:	c3                   	ret    

0080037b <kill>:

int
kill(int pid) {
  80037b:	55                   	push   %ebp
  80037c:	89 e5                	mov    %esp,%ebp
  80037e:	83 ec 18             	sub    $0x18,%esp
    return sys_kill(pid);
  800381:	8b 45 08             	mov    0x8(%ebp),%eax
  800384:	89 04 24             	mov    %eax,(%esp)
  800387:	e8 d5 fe ff ff       	call   800261 <sys_kill>
}
  80038c:	c9                   	leave  
  80038d:	c3                   	ret    

0080038e <getpid>:

int
getpid(void) {
  80038e:	55                   	push   %ebp
  80038f:	89 e5                	mov    %esp,%ebp
  800391:	83 ec 08             	sub    $0x8,%esp
    return sys_getpid();
  800394:	e8 e3 fe ff ff       	call   80027c <sys_getpid>
}
  800399:	c9                   	leave  
  80039a:	c3                   	ret    

0080039b <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  80039b:	55                   	push   %ebp
  80039c:	89 e5                	mov    %esp,%ebp
  80039e:	83 ec 08             	sub    $0x8,%esp
    sys_pgdir();
  8003a1:	e8 05 ff ff ff       	call   8002ab <sys_pgdir>
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <gettime_msec>:

unsigned int
gettime_msec(void) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 08             	sub    $0x8,%esp
    return (unsigned int)sys_gettime();
  8003ae:	e8 0c ff ff ff       	call   8002bf <sys_gettime>
}
  8003b3:	c9                   	leave  
  8003b4:	c3                   	ret    

008003b5 <lab6_set_priority>:

void
lab6_set_priority(uint32_t priority)
{
  8003b5:	55                   	push   %ebp
  8003b6:	89 e5                	mov    %esp,%ebp
  8003b8:	83 ec 18             	sub    $0x18,%esp
    sys_lab6_set_priority(priority);
  8003bb:	8b 45 08             	mov    0x8(%ebp),%eax
  8003be:	89 04 24             	mov    %eax,(%esp)
  8003c1:	e8 0d ff ff ff       	call   8002d3 <sys_lab6_set_priority>
}
  8003c6:	c9                   	leave  
  8003c7:	c3                   	ret    

008003c8 <sleep>:

int
sleep(unsigned int time) {
  8003c8:	55                   	push   %ebp
  8003c9:	89 e5                	mov    %esp,%ebp
  8003cb:	83 ec 18             	sub    $0x18,%esp
    return sys_sleep(time);
  8003ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8003d1:	89 04 24             	mov    %eax,(%esp)
  8003d4:	e8 15 ff ff ff       	call   8002ee <sys_sleep>
}
  8003d9:	c9                   	leave  
  8003da:	c3                   	ret    
	...

008003dc <umain>:
#include <ulib.h>

int main(void);

void
umain(void) {
  8003dc:	55                   	push   %ebp
  8003dd:	89 e5                	mov    %esp,%ebp
  8003df:	83 ec 28             	sub    $0x28,%esp
    int ret = main();
  8003e2:	e8 b5 0d 00 00       	call   80119c <main>
  8003e7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    exit(ret);
  8003ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8003ed:	89 04 24             	mov    %eax,(%esp)
  8003f0:	e8 17 ff ff ff       	call   80030c <exit>
  8003f5:	00 00                	add    %al,(%eax)
	...

008003f8 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  8003f8:	55                   	push   %ebp
  8003f9:	89 e5                	mov    %esp,%ebp
  8003fb:	53                   	push   %ebx
  8003fc:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  8003ff:	8b 45 08             	mov    0x8(%ebp),%eax
  800402:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
  800408:	89 45 f8             	mov    %eax,-0x8(%ebp)
    return (hash >> (32 - bits));
  80040b:	b8 20 00 00 00       	mov    $0x20,%eax
  800410:	2b 45 0c             	sub    0xc(%ebp),%eax
  800413:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800416:	89 d3                	mov    %edx,%ebx
  800418:	89 c1                	mov    %eax,%ecx
  80041a:	d3 eb                	shr    %cl,%ebx
  80041c:	89 d8                	mov    %ebx,%eax
}
  80041e:	83 c4 10             	add    $0x10,%esp
  800421:	5b                   	pop    %ebx
  800422:	5d                   	pop    %ebp
  800423:	c3                   	ret    

00800424 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  800424:	55                   	push   %ebp
  800425:	89 e5                	mov    %esp,%ebp
  800427:	56                   	push   %esi
  800428:	53                   	push   %ebx
  800429:	83 ec 60             	sub    $0x60,%esp
  80042c:	8b 45 10             	mov    0x10(%ebp),%eax
  80042f:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800432:	8b 45 14             	mov    0x14(%ebp),%eax
  800435:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  800438:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80043b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  80043e:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800441:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  800444:	8b 45 18             	mov    0x18(%ebp),%eax
  800447:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  80044a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80044d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800450:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800453:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800456:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800459:	8b 55 cc             	mov    -0x34(%ebp),%edx
  80045c:	89 d3                	mov    %edx,%ebx
  80045e:	89 c6                	mov    %eax,%esi
  800460:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800463:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  800466:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800469:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80046c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800470:	74 1c                	je     80048e <printnum+0x6a>
  800472:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800475:	ba 00 00 00 00       	mov    $0x0,%edx
  80047a:	f7 75 e4             	divl   -0x1c(%ebp)
  80047d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800480:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800483:	ba 00 00 00 00       	mov    $0x0,%edx
  800488:	f7 75 e4             	divl   -0x1c(%ebp)
  80048b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80048e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800491:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800494:	89 d6                	mov    %edx,%esi
  800496:	89 c3                	mov    %eax,%ebx
  800498:	89 f0                	mov    %esi,%eax
  80049a:	89 da                	mov    %ebx,%edx
  80049c:	f7 75 e4             	divl   -0x1c(%ebp)
  80049f:	89 d3                	mov    %edx,%ebx
  8004a1:	89 c6                	mov    %eax,%esi
  8004a3:	89 75 e0             	mov    %esi,-0x20(%ebp)
  8004a6:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  8004a9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8004ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8004af:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8004b2:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  8004b5:	8b 45 c8             	mov    -0x38(%ebp),%eax
  8004b8:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  8004bb:	89 c3                	mov    %eax,%ebx
  8004bd:	89 d6                	mov    %edx,%esi
  8004bf:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  8004c2:	89 75 ec             	mov    %esi,-0x14(%ebp)
  8004c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  8004c8:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  8004cb:	8b 45 18             	mov    0x18(%ebp),%eax
  8004ce:	ba 00 00 00 00       	mov    $0x0,%edx
  8004d3:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  8004d6:	77 56                	ja     80052e <printnum+0x10a>
  8004d8:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  8004db:	72 05                	jb     8004e2 <printnum+0xbe>
  8004dd:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  8004e0:	77 4c                	ja     80052e <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
  8004e2:	8b 45 1c             	mov    0x1c(%ebp),%eax
  8004e5:	8d 50 ff             	lea    -0x1(%eax),%edx
  8004e8:	8b 45 20             	mov    0x20(%ebp),%eax
  8004eb:	89 44 24 18          	mov    %eax,0x18(%esp)
  8004ef:	89 54 24 14          	mov    %edx,0x14(%esp)
  8004f3:	8b 45 18             	mov    0x18(%ebp),%eax
  8004f6:	89 44 24 10          	mov    %eax,0x10(%esp)
  8004fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8004fd:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800500:	89 44 24 08          	mov    %eax,0x8(%esp)
  800504:	89 54 24 0c          	mov    %edx,0xc(%esp)
  800508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80050b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80050f:	8b 45 08             	mov    0x8(%ebp),%eax
  800512:	89 04 24             	mov    %eax,(%esp)
  800515:	e8 0a ff ff ff       	call   800424 <printnum>
  80051a:	eb 1c                	jmp    800538 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  80051c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80051f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800523:	8b 45 20             	mov    0x20(%ebp),%eax
  800526:	89 04 24             	mov    %eax,(%esp)
  800529:	8b 45 08             	mov    0x8(%ebp),%eax
  80052c:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  80052e:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  800532:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  800536:	7f e4                	jg     80051c <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  800538:	8b 45 d8             	mov    -0x28(%ebp),%eax
  80053b:	05 24 13 80 00       	add    $0x801324,%eax
  800540:	0f b6 00             	movzbl (%eax),%eax
  800543:	0f be c0             	movsbl %al,%eax
  800546:	8b 55 0c             	mov    0xc(%ebp),%edx
  800549:	89 54 24 04          	mov    %edx,0x4(%esp)
  80054d:	89 04 24             	mov    %eax,(%esp)
  800550:	8b 45 08             	mov    0x8(%ebp),%eax
  800553:	ff d0                	call   *%eax
}
  800555:	83 c4 60             	add    $0x60,%esp
  800558:	5b                   	pop    %ebx
  800559:	5e                   	pop    %esi
  80055a:	5d                   	pop    %ebp
  80055b:	c3                   	ret    

0080055c <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  80055c:	55                   	push   %ebp
  80055d:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  80055f:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800563:	7e 14                	jle    800579 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  800565:	8b 45 08             	mov    0x8(%ebp),%eax
  800568:	8b 00                	mov    (%eax),%eax
  80056a:	8d 48 08             	lea    0x8(%eax),%ecx
  80056d:	8b 55 08             	mov    0x8(%ebp),%edx
  800570:	89 0a                	mov    %ecx,(%edx)
  800572:	8b 50 04             	mov    0x4(%eax),%edx
  800575:	8b 00                	mov    (%eax),%eax
  800577:	eb 30                	jmp    8005a9 <getuint+0x4d>
    }
    else if (lflag) {
  800579:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  80057d:	74 16                	je     800595 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  80057f:	8b 45 08             	mov    0x8(%ebp),%eax
  800582:	8b 00                	mov    (%eax),%eax
  800584:	8d 48 04             	lea    0x4(%eax),%ecx
  800587:	8b 55 08             	mov    0x8(%ebp),%edx
  80058a:	89 0a                	mov    %ecx,(%edx)
  80058c:	8b 00                	mov    (%eax),%eax
  80058e:	ba 00 00 00 00       	mov    $0x0,%edx
  800593:	eb 14                	jmp    8005a9 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  800595:	8b 45 08             	mov    0x8(%ebp),%eax
  800598:	8b 00                	mov    (%eax),%eax
  80059a:	8d 48 04             	lea    0x4(%eax),%ecx
  80059d:	8b 55 08             	mov    0x8(%ebp),%edx
  8005a0:	89 0a                	mov    %ecx,(%edx)
  8005a2:	8b 00                	mov    (%eax),%eax
  8005a4:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  8005a9:	5d                   	pop    %ebp
  8005aa:	c3                   	ret    

008005ab <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  8005ab:	55                   	push   %ebp
  8005ac:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  8005ae:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  8005b2:	7e 14                	jle    8005c8 <getint+0x1d>
        return va_arg(*ap, long long);
  8005b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005b7:	8b 00                	mov    (%eax),%eax
  8005b9:	8d 48 08             	lea    0x8(%eax),%ecx
  8005bc:	8b 55 08             	mov    0x8(%ebp),%edx
  8005bf:	89 0a                	mov    %ecx,(%edx)
  8005c1:	8b 50 04             	mov    0x4(%eax),%edx
  8005c4:	8b 00                	mov    (%eax),%eax
  8005c6:	eb 30                	jmp    8005f8 <getint+0x4d>
    }
    else if (lflag) {
  8005c8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8005cc:	74 16                	je     8005e4 <getint+0x39>
        return va_arg(*ap, long);
  8005ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8005d1:	8b 00                	mov    (%eax),%eax
  8005d3:	8d 48 04             	lea    0x4(%eax),%ecx
  8005d6:	8b 55 08             	mov    0x8(%ebp),%edx
  8005d9:	89 0a                	mov    %ecx,(%edx)
  8005db:	8b 00                	mov    (%eax),%eax
  8005dd:	89 c2                	mov    %eax,%edx
  8005df:	c1 fa 1f             	sar    $0x1f,%edx
  8005e2:	eb 14                	jmp    8005f8 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  8005e4:	8b 45 08             	mov    0x8(%ebp),%eax
  8005e7:	8b 00                	mov    (%eax),%eax
  8005e9:	8d 48 04             	lea    0x4(%eax),%ecx
  8005ec:	8b 55 08             	mov    0x8(%ebp),%edx
  8005ef:	89 0a                	mov    %ecx,(%edx)
  8005f1:	8b 00                	mov    (%eax),%eax
  8005f3:	89 c2                	mov    %eax,%edx
  8005f5:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  8005f8:	5d                   	pop    %ebp
  8005f9:	c3                   	ret    

008005fa <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  8005fa:	55                   	push   %ebp
  8005fb:	89 e5                	mov    %esp,%ebp
  8005fd:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  800600:	8d 55 14             	lea    0x14(%ebp),%edx
  800603:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800606:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
  800608:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80060b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80060f:	8b 45 10             	mov    0x10(%ebp),%eax
  800612:	89 44 24 08          	mov    %eax,0x8(%esp)
  800616:	8b 45 0c             	mov    0xc(%ebp),%eax
  800619:	89 44 24 04          	mov    %eax,0x4(%esp)
  80061d:	8b 45 08             	mov    0x8(%ebp),%eax
  800620:	89 04 24             	mov    %eax,(%esp)
  800623:	e8 02 00 00 00       	call   80062a <vprintfmt>
    va_end(ap);
}
  800628:	c9                   	leave  
  800629:	c3                   	ret    

0080062a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  80062a:	55                   	push   %ebp
  80062b:	89 e5                	mov    %esp,%ebp
  80062d:	56                   	push   %esi
  80062e:	53                   	push   %ebx
  80062f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800632:	eb 17                	jmp    80064b <vprintfmt+0x21>
            if (ch == '\0') {
  800634:	85 db                	test   %ebx,%ebx
  800636:	0f 84 db 03 00 00    	je     800a17 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
  80063c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80063f:	89 44 24 04          	mov    %eax,0x4(%esp)
  800643:	89 1c 24             	mov    %ebx,(%esp)
  800646:	8b 45 08             	mov    0x8(%ebp),%eax
  800649:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  80064b:	8b 45 10             	mov    0x10(%ebp),%eax
  80064e:	0f b6 00             	movzbl (%eax),%eax
  800651:	0f b6 d8             	movzbl %al,%ebx
  800654:	83 fb 25             	cmp    $0x25,%ebx
  800657:	0f 95 c0             	setne  %al
  80065a:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  80065e:	84 c0                	test   %al,%al
  800660:	75 d2                	jne    800634 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  800662:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  800666:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  80066d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800670:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  800673:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  80067a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  80067d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800680:	eb 04                	jmp    800686 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  800682:	90                   	nop
  800683:	eb 01                	jmp    800686 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  800685:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800686:	8b 45 10             	mov    0x10(%ebp),%eax
  800689:	0f b6 00             	movzbl (%eax),%eax
  80068c:	0f b6 d8             	movzbl %al,%ebx
  80068f:	89 d8                	mov    %ebx,%eax
  800691:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  800695:	83 e8 23             	sub    $0x23,%eax
  800698:	83 f8 55             	cmp    $0x55,%eax
  80069b:	0f 87 45 03 00 00    	ja     8009e6 <vprintfmt+0x3bc>
  8006a1:	8b 04 85 48 13 80 00 	mov    0x801348(,%eax,4),%eax
  8006a8:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  8006aa:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  8006ae:	eb d6                	jmp    800686 <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  8006b0:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  8006b4:	eb d0                	jmp    800686 <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  8006b6:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  8006bd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8006c0:	89 d0                	mov    %edx,%eax
  8006c2:	c1 e0 02             	shl    $0x2,%eax
  8006c5:	01 d0                	add    %edx,%eax
  8006c7:	01 c0                	add    %eax,%eax
  8006c9:	01 d8                	add    %ebx,%eax
  8006cb:	83 e8 30             	sub    $0x30,%eax
  8006ce:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  8006d1:	8b 45 10             	mov    0x10(%ebp),%eax
  8006d4:	0f b6 00             	movzbl (%eax),%eax
  8006d7:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  8006da:	83 fb 2f             	cmp    $0x2f,%ebx
  8006dd:	7e 39                	jle    800718 <vprintfmt+0xee>
  8006df:	83 fb 39             	cmp    $0x39,%ebx
  8006e2:	7f 34                	jg     800718 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  8006e4:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  8006e8:	eb d3                	jmp    8006bd <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  8006ea:	8b 45 14             	mov    0x14(%ebp),%eax
  8006ed:	8d 50 04             	lea    0x4(%eax),%edx
  8006f0:	89 55 14             	mov    %edx,0x14(%ebp)
  8006f3:	8b 00                	mov    (%eax),%eax
  8006f5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  8006f8:	eb 1f                	jmp    800719 <vprintfmt+0xef>

        case '.':
            if (width < 0)
  8006fa:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8006fe:	79 82                	jns    800682 <vprintfmt+0x58>
                width = 0;
  800700:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  800707:	e9 76 ff ff ff       	jmp    800682 <vprintfmt+0x58>

        case '#':
            altflag = 1;
  80070c:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  800713:	e9 6e ff ff ff       	jmp    800686 <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  800718:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  800719:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80071d:	0f 89 62 ff ff ff    	jns    800685 <vprintfmt+0x5b>
                width = precision, precision = -1;
  800723:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800726:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800729:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  800730:	e9 50 ff ff ff       	jmp    800685 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  800735:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  800739:	e9 48 ff ff ff       	jmp    800686 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  80073e:	8b 45 14             	mov    0x14(%ebp),%eax
  800741:	8d 50 04             	lea    0x4(%eax),%edx
  800744:	89 55 14             	mov    %edx,0x14(%ebp)
  800747:	8b 00                	mov    (%eax),%eax
  800749:	8b 55 0c             	mov    0xc(%ebp),%edx
  80074c:	89 54 24 04          	mov    %edx,0x4(%esp)
  800750:	89 04 24             	mov    %eax,(%esp)
  800753:	8b 45 08             	mov    0x8(%ebp),%eax
  800756:	ff d0                	call   *%eax
            break;
  800758:	e9 b4 02 00 00       	jmp    800a11 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
  80075d:	8b 45 14             	mov    0x14(%ebp),%eax
  800760:	8d 50 04             	lea    0x4(%eax),%edx
  800763:	89 55 14             	mov    %edx,0x14(%ebp)
  800766:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  800768:	85 db                	test   %ebx,%ebx
  80076a:	79 02                	jns    80076e <vprintfmt+0x144>
                err = -err;
  80076c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  80076e:	83 fb 18             	cmp    $0x18,%ebx
  800771:	7f 0b                	jg     80077e <vprintfmt+0x154>
  800773:	8b 34 9d c0 12 80 00 	mov    0x8012c0(,%ebx,4),%esi
  80077a:	85 f6                	test   %esi,%esi
  80077c:	75 23                	jne    8007a1 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
  80077e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  800782:	c7 44 24 08 35 13 80 	movl   $0x801335,0x8(%esp)
  800789:	00 
  80078a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80078d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800791:	8b 45 08             	mov    0x8(%ebp),%eax
  800794:	89 04 24             	mov    %eax,(%esp)
  800797:	e8 5e fe ff ff       	call   8005fa <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  80079c:	e9 70 02 00 00       	jmp    800a11 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  8007a1:	89 74 24 0c          	mov    %esi,0xc(%esp)
  8007a5:	c7 44 24 08 3e 13 80 	movl   $0x80133e,0x8(%esp)
  8007ac:	00 
  8007ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b0:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007b4:	8b 45 08             	mov    0x8(%ebp),%eax
  8007b7:	89 04 24             	mov    %eax,(%esp)
  8007ba:	e8 3b fe ff ff       	call   8005fa <printfmt>
            }
            break;
  8007bf:	e9 4d 02 00 00       	jmp    800a11 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  8007c4:	8b 45 14             	mov    0x14(%ebp),%eax
  8007c7:	8d 50 04             	lea    0x4(%eax),%edx
  8007ca:	89 55 14             	mov    %edx,0x14(%ebp)
  8007cd:	8b 30                	mov    (%eax),%esi
  8007cf:	85 f6                	test   %esi,%esi
  8007d1:	75 05                	jne    8007d8 <vprintfmt+0x1ae>
                p = "(null)";
  8007d3:	be 41 13 80 00       	mov    $0x801341,%esi
            }
            if (width > 0 && padc != '-') {
  8007d8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  8007dc:	7e 7c                	jle    80085a <vprintfmt+0x230>
  8007de:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  8007e2:	74 76                	je     80085a <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
  8007e4:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  8007e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8007ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007ee:	89 34 24             	mov    %esi,(%esp)
  8007f1:	e8 25 04 00 00       	call   800c1b <strnlen>
  8007f6:	89 da                	mov    %ebx,%edx
  8007f8:	29 c2                	sub    %eax,%edx
  8007fa:	89 d0                	mov    %edx,%eax
  8007fc:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8007ff:	eb 17                	jmp    800818 <vprintfmt+0x1ee>
                    putch(padc, putdat);
  800801:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800805:	8b 55 0c             	mov    0xc(%ebp),%edx
  800808:	89 54 24 04          	mov    %edx,0x4(%esp)
  80080c:	89 04 24             	mov    %eax,(%esp)
  80080f:	8b 45 08             	mov    0x8(%ebp),%eax
  800812:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  800814:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800818:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80081c:	7f e3                	jg     800801 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  80081e:	eb 3a                	jmp    80085a <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
  800820:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800824:	74 1f                	je     800845 <vprintfmt+0x21b>
  800826:	83 fb 1f             	cmp    $0x1f,%ebx
  800829:	7e 05                	jle    800830 <vprintfmt+0x206>
  80082b:	83 fb 7e             	cmp    $0x7e,%ebx
  80082e:	7e 15                	jle    800845 <vprintfmt+0x21b>
                    putch('?', putdat);
  800830:	8b 45 0c             	mov    0xc(%ebp),%eax
  800833:	89 44 24 04          	mov    %eax,0x4(%esp)
  800837:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  80083e:	8b 45 08             	mov    0x8(%ebp),%eax
  800841:	ff d0                	call   *%eax
  800843:	eb 0f                	jmp    800854 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
  800845:	8b 45 0c             	mov    0xc(%ebp),%eax
  800848:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084c:	89 1c 24             	mov    %ebx,(%esp)
  80084f:	8b 45 08             	mov    0x8(%ebp),%eax
  800852:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800854:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800858:	eb 01                	jmp    80085b <vprintfmt+0x231>
  80085a:	90                   	nop
  80085b:	0f b6 06             	movzbl (%esi),%eax
  80085e:	0f be d8             	movsbl %al,%ebx
  800861:	85 db                	test   %ebx,%ebx
  800863:	0f 95 c0             	setne  %al
  800866:	83 c6 01             	add    $0x1,%esi
  800869:	84 c0                	test   %al,%al
  80086b:	74 29                	je     800896 <vprintfmt+0x26c>
  80086d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800871:	78 ad                	js     800820 <vprintfmt+0x1f6>
  800873:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800877:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  80087b:	79 a3                	jns    800820 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  80087d:	eb 17                	jmp    800896 <vprintfmt+0x26c>
                putch(' ', putdat);
  80087f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800882:	89 44 24 04          	mov    %eax,0x4(%esp)
  800886:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  80088d:	8b 45 08             	mov    0x8(%ebp),%eax
  800890:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  800892:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800896:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80089a:	7f e3                	jg     80087f <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
  80089c:	e9 70 01 00 00       	jmp    800a11 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  8008a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008a4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008a8:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ab:	89 04 24             	mov    %eax,(%esp)
  8008ae:	e8 f8 fc ff ff       	call   8005ab <getint>
  8008b3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008b6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  8008b9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008bc:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008bf:	85 d2                	test   %edx,%edx
  8008c1:	79 26                	jns    8008e9 <vprintfmt+0x2bf>
                putch('-', putdat);
  8008c3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8008c6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008ca:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  8008d1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008d4:	ff d0                	call   *%eax
                num = -(long long)num;
  8008d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8008d9:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8008dc:	f7 d8                	neg    %eax
  8008de:	83 d2 00             	adc    $0x0,%edx
  8008e1:	f7 da                	neg    %edx
  8008e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8008e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  8008e9:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  8008f0:	e9 a8 00 00 00       	jmp    80099d <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  8008f5:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8008f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008fc:	8d 45 14             	lea    0x14(%ebp),%eax
  8008ff:	89 04 24             	mov    %eax,(%esp)
  800902:	e8 55 fc ff ff       	call   80055c <getuint>
  800907:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80090a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  80090d:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  800914:	e9 84 00 00 00       	jmp    80099d <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  800919:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80091c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800920:	8d 45 14             	lea    0x14(%ebp),%eax
  800923:	89 04 24             	mov    %eax,(%esp)
  800926:	e8 31 fc ff ff       	call   80055c <getuint>
  80092b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80092e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  800931:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  800938:	eb 63                	jmp    80099d <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
  80093a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093d:	89 44 24 04          	mov    %eax,0x4(%esp)
  800941:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  800948:	8b 45 08             	mov    0x8(%ebp),%eax
  80094b:	ff d0                	call   *%eax
            putch('x', putdat);
  80094d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800950:	89 44 24 04          	mov    %eax,0x4(%esp)
  800954:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  80095b:	8b 45 08             	mov    0x8(%ebp),%eax
  80095e:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  800960:	8b 45 14             	mov    0x14(%ebp),%eax
  800963:	8d 50 04             	lea    0x4(%eax),%edx
  800966:	89 55 14             	mov    %edx,0x14(%ebp)
  800969:	8b 00                	mov    (%eax),%eax
  80096b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80096e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  800975:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  80097c:	eb 1f                	jmp    80099d <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  80097e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800981:	89 44 24 04          	mov    %eax,0x4(%esp)
  800985:	8d 45 14             	lea    0x14(%ebp),%eax
  800988:	89 04 24             	mov    %eax,(%esp)
  80098b:	e8 cc fb ff ff       	call   80055c <getuint>
  800990:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800993:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  800996:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  80099d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  8009a1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8009a4:	89 54 24 18          	mov    %edx,0x18(%esp)
  8009a8:	8b 55 e8             	mov    -0x18(%ebp),%edx
  8009ab:	89 54 24 14          	mov    %edx,0x14(%esp)
  8009af:	89 44 24 10          	mov    %eax,0x10(%esp)
  8009b3:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8009b6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  8009b9:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009bd:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8009c1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009c4:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009c8:	8b 45 08             	mov    0x8(%ebp),%eax
  8009cb:	89 04 24             	mov    %eax,(%esp)
  8009ce:	e8 51 fa ff ff       	call   800424 <printnum>
            break;
  8009d3:	eb 3c                	jmp    800a11 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  8009d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009d8:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009dc:	89 1c 24             	mov    %ebx,(%esp)
  8009df:	8b 45 08             	mov    0x8(%ebp),%eax
  8009e2:	ff d0                	call   *%eax
            break;
  8009e4:	eb 2b                	jmp    800a11 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  8009e6:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009e9:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ed:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  8009f4:	8b 45 08             	mov    0x8(%ebp),%eax
  8009f7:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  8009f9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8009fd:	eb 04                	jmp    800a03 <vprintfmt+0x3d9>
  8009ff:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800a03:	8b 45 10             	mov    0x10(%ebp),%eax
  800a06:	83 e8 01             	sub    $0x1,%eax
  800a09:	0f b6 00             	movzbl (%eax),%eax
  800a0c:	3c 25                	cmp    $0x25,%al
  800a0e:	75 ef                	jne    8009ff <vprintfmt+0x3d5>
                /* do nothing */;
            break;
  800a10:	90                   	nop
        }
    }
  800a11:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800a12:	e9 34 fc ff ff       	jmp    80064b <vprintfmt+0x21>
            if (ch == '\0') {
                return;
  800a17:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  800a18:	83 c4 40             	add    $0x40,%esp
  800a1b:	5b                   	pop    %ebx
  800a1c:	5e                   	pop    %esi
  800a1d:	5d                   	pop    %ebp
  800a1e:	c3                   	ret    

00800a1f <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  800a1f:	55                   	push   %ebp
  800a20:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  800a22:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a25:	8b 40 08             	mov    0x8(%eax),%eax
  800a28:	8d 50 01             	lea    0x1(%eax),%edx
  800a2b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a2e:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  800a31:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a34:	8b 10                	mov    (%eax),%edx
  800a36:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a39:	8b 40 04             	mov    0x4(%eax),%eax
  800a3c:	39 c2                	cmp    %eax,%edx
  800a3e:	73 12                	jae    800a52 <sprintputch+0x33>
        *b->buf ++ = ch;
  800a40:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a43:	8b 00                	mov    (%eax),%eax
  800a45:	8b 55 08             	mov    0x8(%ebp),%edx
  800a48:	88 10                	mov    %dl,(%eax)
  800a4a:	8d 50 01             	lea    0x1(%eax),%edx
  800a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a50:	89 10                	mov    %edx,(%eax)
    }
}
  800a52:	5d                   	pop    %ebp
  800a53:	c3                   	ret    

00800a54 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  800a54:	55                   	push   %ebp
  800a55:	89 e5                	mov    %esp,%ebp
  800a57:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  800a5a:	8d 55 14             	lea    0x14(%ebp),%edx
  800a5d:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800a60:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
  800a62:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a65:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a69:	8b 45 10             	mov    0x10(%ebp),%eax
  800a6c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800a70:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a73:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a77:	8b 45 08             	mov    0x8(%ebp),%eax
  800a7a:	89 04 24             	mov    %eax,(%esp)
  800a7d:	e8 08 00 00 00       	call   800a8a <vsnprintf>
  800a82:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  800a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a88:	c9                   	leave  
  800a89:	c3                   	ret    

00800a8a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  800a8a:	55                   	push   %ebp
  800a8b:	89 e5                	mov    %esp,%ebp
  800a8d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  800a90:	8b 45 08             	mov    0x8(%ebp),%eax
  800a93:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800a96:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a99:	83 e8 01             	sub    $0x1,%eax
  800a9c:	03 45 08             	add    0x8(%ebp),%eax
  800a9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800aa2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  800aa9:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  800aad:	74 0a                	je     800ab9 <vsnprintf+0x2f>
  800aaf:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800ab2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800ab5:	39 c2                	cmp    %eax,%edx
  800ab7:	76 07                	jbe    800ac0 <vsnprintf+0x36>
        return -E_INVAL;
  800ab9:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  800abe:	eb 2a                	jmp    800aea <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  800ac0:	8b 45 14             	mov    0x14(%ebp),%eax
  800ac3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ac7:	8b 45 10             	mov    0x10(%ebp),%eax
  800aca:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ace:	8d 45 ec             	lea    -0x14(%ebp),%eax
  800ad1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ad5:	c7 04 24 1f 0a 80 00 	movl   $0x800a1f,(%esp)
  800adc:	e8 49 fb ff ff       	call   80062a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  800ae1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ae4:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  800ae7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800aea:	c9                   	leave  
  800aeb:	c3                   	ret    

00800aec <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  800aec:	55                   	push   %ebp
  800aed:	89 e5                	mov    %esp,%ebp
  800aef:	57                   	push   %edi
  800af0:	56                   	push   %esi
  800af1:	53                   	push   %ebx
  800af2:	83 ec 34             	sub    $0x34,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  800af5:	a1 00 20 80 00       	mov    0x802000,%eax
  800afa:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800b00:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
  800b06:	6b c8 05             	imul   $0x5,%eax,%ecx
  800b09:	01 cf                	add    %ecx,%edi
  800b0b:	b9 6d e6 ec de       	mov    $0xdeece66d,%ecx
  800b10:	f7 e1                	mul    %ecx
  800b12:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  800b15:	89 ca                	mov    %ecx,%edx
  800b17:	83 c0 0b             	add    $0xb,%eax
  800b1a:	83 d2 00             	adc    $0x0,%edx
  800b1d:	89 c3                	mov    %eax,%ebx
  800b1f:	80 e7 ff             	and    $0xff,%bh
  800b22:	0f b7 f2             	movzwl %dx,%esi
  800b25:	89 1d 00 20 80 00    	mov    %ebx,0x802000
  800b2b:	89 35 04 20 80 00    	mov    %esi,0x802004
    unsigned long long result = (next >> 12);
  800b31:	a1 00 20 80 00       	mov    0x802000,%eax
  800b36:	8b 15 04 20 80 00    	mov    0x802004,%edx
  800b3c:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  800b40:	c1 ea 0c             	shr    $0xc,%edx
  800b43:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800b46:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
  800b49:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  800b50:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800b53:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800b56:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800b59:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800b5c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b5f:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800b62:	89 d3                	mov    %edx,%ebx
  800b64:	89 c6                	mov    %eax,%esi
  800b66:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800b69:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  800b6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b6f:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800b72:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800b76:	74 1c                	je     800b94 <rand+0xa8>
  800b78:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b7b:	ba 00 00 00 00       	mov    $0x0,%edx
  800b80:	f7 75 dc             	divl   -0x24(%ebp)
  800b83:	89 55 ec             	mov    %edx,-0x14(%ebp)
  800b86:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b89:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8e:	f7 75 dc             	divl   -0x24(%ebp)
  800b91:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800b94:	8b 55 d8             	mov    -0x28(%ebp),%edx
  800b97:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800b9a:	89 d6                	mov    %edx,%esi
  800b9c:	89 c3                	mov    %eax,%ebx
  800b9e:	89 f0                	mov    %esi,%eax
  800ba0:	89 da                	mov    %ebx,%edx
  800ba2:	f7 75 dc             	divl   -0x24(%ebp)
  800ba5:	89 d3                	mov    %edx,%ebx
  800ba7:	89 c6                	mov    %eax,%esi
  800ba9:	89 75 d8             	mov    %esi,-0x28(%ebp)
  800bac:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  800baf:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800bb2:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800bb5:	8b 55 e8             	mov    -0x18(%ebp),%edx
  800bb8:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800bbb:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800bbe:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800bc1:	89 c3                	mov    %eax,%ebx
  800bc3:	89 d6                	mov    %edx,%esi
  800bc5:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  800bc8:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800bcb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  800bce:	83 c4 34             	add    $0x34,%esp
  800bd1:	5b                   	pop    %ebx
  800bd2:	5e                   	pop    %esi
  800bd3:	5f                   	pop    %edi
  800bd4:	5d                   	pop    %ebp
  800bd5:	c3                   	ret    

00800bd6 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  800bd6:	55                   	push   %ebp
  800bd7:	89 e5                	mov    %esp,%ebp
    next = seed;
  800bd9:	8b 45 08             	mov    0x8(%ebp),%eax
  800bdc:	ba 00 00 00 00       	mov    $0x0,%edx
  800be1:	a3 00 20 80 00       	mov    %eax,0x802000
  800be6:	89 15 04 20 80 00    	mov    %edx,0x802004
}
  800bec:	5d                   	pop    %ebp
  800bed:	c3                   	ret    
	...

00800bf0 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  800bf0:	55                   	push   %ebp
  800bf1:	89 e5                	mov    %esp,%ebp
  800bf3:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800bf6:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  800bfd:	eb 04                	jmp    800c03 <strlen+0x13>
        cnt ++;
  800bff:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  800c03:	8b 45 08             	mov    0x8(%ebp),%eax
  800c06:	0f b6 00             	movzbl (%eax),%eax
  800c09:	84 c0                	test   %al,%al
  800c0b:	0f 95 c0             	setne  %al
  800c0e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c12:	84 c0                	test   %al,%al
  800c14:	75 e9                	jne    800bff <strlen+0xf>
        cnt ++;
    }
    return cnt;
  800c16:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c19:	c9                   	leave  
  800c1a:	c3                   	ret    

00800c1b <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  800c1b:	55                   	push   %ebp
  800c1c:	89 e5                	mov    %esp,%ebp
  800c1e:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  800c21:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  800c28:	eb 04                	jmp    800c2e <strnlen+0x13>
        cnt ++;
  800c2a:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  800c2e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800c31:	3b 45 0c             	cmp    0xc(%ebp),%eax
  800c34:	73 13                	jae    800c49 <strnlen+0x2e>
  800c36:	8b 45 08             	mov    0x8(%ebp),%eax
  800c39:	0f b6 00             	movzbl (%eax),%eax
  800c3c:	84 c0                	test   %al,%al
  800c3e:	0f 95 c0             	setne  %al
  800c41:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800c45:	84 c0                	test   %al,%al
  800c47:	75 e1                	jne    800c2a <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  800c49:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  800c4c:	c9                   	leave  
  800c4d:	c3                   	ret    

00800c4e <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  800c4e:	55                   	push   %ebp
  800c4f:	89 e5                	mov    %esp,%ebp
  800c51:	57                   	push   %edi
  800c52:	56                   	push   %esi
  800c53:	53                   	push   %ebx
  800c54:	83 ec 24             	sub    $0x24,%esp
  800c57:	8b 45 08             	mov    0x8(%ebp),%eax
  800c5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800c5d:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c60:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  800c63:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c66:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800c69:	89 d6                	mov    %edx,%esi
  800c6b:	89 c3                	mov    %eax,%ebx
  800c6d:	89 df                	mov    %ebx,%edi
  800c6f:	ac                   	lods   %ds:(%esi),%al
  800c70:	aa                   	stos   %al,%es:(%edi)
  800c71:	84 c0                	test   %al,%al
  800c73:	75 fa                	jne    800c6f <strcpy+0x21>
  800c75:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800c78:	89 fb                	mov    %edi,%ebx
  800c7a:	89 75 e8             	mov    %esi,-0x18(%ebp)
  800c7d:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  800c80:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800c83:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  800c86:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  800c89:	83 c4 24             	add    $0x24,%esp
  800c8c:	5b                   	pop    %ebx
  800c8d:	5e                   	pop    %esi
  800c8e:	5f                   	pop    %edi
  800c8f:	5d                   	pop    %ebp
  800c90:	c3                   	ret    

00800c91 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  800c91:	55                   	push   %ebp
  800c92:	89 e5                	mov    %esp,%ebp
  800c94:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  800c97:	8b 45 08             	mov    0x8(%ebp),%eax
  800c9a:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  800c9d:	eb 21                	jmp    800cc0 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  800c9f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ca2:	0f b6 10             	movzbl (%eax),%edx
  800ca5:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800ca8:	88 10                	mov    %dl,(%eax)
  800caa:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800cad:	0f b6 00             	movzbl (%eax),%eax
  800cb0:	84 c0                	test   %al,%al
  800cb2:	74 04                	je     800cb8 <strncpy+0x27>
            src ++;
  800cb4:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  800cb8:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  800cbc:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  800cc0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800cc4:	75 d9                	jne    800c9f <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  800cc6:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800cc9:	c9                   	leave  
  800cca:	c3                   	ret    

00800ccb <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  800ccb:	55                   	push   %ebp
  800ccc:	89 e5                	mov    %esp,%ebp
  800cce:	57                   	push   %edi
  800ccf:	56                   	push   %esi
  800cd0:	53                   	push   %ebx
  800cd1:	83 ec 24             	sub    $0x24,%esp
  800cd4:	8b 45 08             	mov    0x8(%ebp),%eax
  800cd7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800cda:	8b 45 0c             	mov    0xc(%ebp),%eax
  800cdd:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  800ce0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800ce3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800ce6:	89 d6                	mov    %edx,%esi
  800ce8:	89 c3                	mov    %eax,%ebx
  800cea:	89 df                	mov    %ebx,%edi
  800cec:	ac                   	lods   %ds:(%esi),%al
  800ced:	ae                   	scas   %es:(%edi),%al
  800cee:	75 08                	jne    800cf8 <strcmp+0x2d>
  800cf0:	84 c0                	test   %al,%al
  800cf2:	75 f8                	jne    800cec <strcmp+0x21>
  800cf4:	31 c0                	xor    %eax,%eax
  800cf6:	eb 04                	jmp    800cfc <strcmp+0x31>
  800cf8:	19 c0                	sbb    %eax,%eax
  800cfa:	0c 01                	or     $0x1,%al
  800cfc:	89 fb                	mov    %edi,%ebx
  800cfe:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800d01:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800d04:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800d07:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800d0a:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  800d0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  800d10:	83 c4 24             	add    $0x24,%esp
  800d13:	5b                   	pop    %ebx
  800d14:	5e                   	pop    %esi
  800d15:	5f                   	pop    %edi
  800d16:	5d                   	pop    %ebp
  800d17:	c3                   	ret    

00800d18 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  800d18:	55                   	push   %ebp
  800d19:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800d1b:	eb 0c                	jmp    800d29 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  800d1d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  800d21:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800d25:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  800d29:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d2d:	74 1a                	je     800d49 <strncmp+0x31>
  800d2f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d32:	0f b6 00             	movzbl (%eax),%eax
  800d35:	84 c0                	test   %al,%al
  800d37:	74 10                	je     800d49 <strncmp+0x31>
  800d39:	8b 45 08             	mov    0x8(%ebp),%eax
  800d3c:	0f b6 10             	movzbl (%eax),%edx
  800d3f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d42:	0f b6 00             	movzbl (%eax),%eax
  800d45:	38 c2                	cmp    %al,%dl
  800d47:	74 d4                	je     800d1d <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  800d49:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800d4d:	74 1a                	je     800d69 <strncmp+0x51>
  800d4f:	8b 45 08             	mov    0x8(%ebp),%eax
  800d52:	0f b6 00             	movzbl (%eax),%eax
  800d55:	0f b6 d0             	movzbl %al,%edx
  800d58:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d5b:	0f b6 00             	movzbl (%eax),%eax
  800d5e:	0f b6 c0             	movzbl %al,%eax
  800d61:	89 d1                	mov    %edx,%ecx
  800d63:	29 c1                	sub    %eax,%ecx
  800d65:	89 c8                	mov    %ecx,%eax
  800d67:	eb 05                	jmp    800d6e <strncmp+0x56>
  800d69:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800d6e:	5d                   	pop    %ebp
  800d6f:	c3                   	ret    

00800d70 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  800d70:	55                   	push   %ebp
  800d71:	89 e5                	mov    %esp,%ebp
  800d73:	83 ec 04             	sub    $0x4,%esp
  800d76:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d79:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800d7c:	eb 14                	jmp    800d92 <strchr+0x22>
        if (*s == c) {
  800d7e:	8b 45 08             	mov    0x8(%ebp),%eax
  800d81:	0f b6 00             	movzbl (%eax),%eax
  800d84:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800d87:	75 05                	jne    800d8e <strchr+0x1e>
            return (char *)s;
  800d89:	8b 45 08             	mov    0x8(%ebp),%eax
  800d8c:	eb 13                	jmp    800da1 <strchr+0x31>
        }
        s ++;
  800d8e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  800d92:	8b 45 08             	mov    0x8(%ebp),%eax
  800d95:	0f b6 00             	movzbl (%eax),%eax
  800d98:	84 c0                	test   %al,%al
  800d9a:	75 e2                	jne    800d7e <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  800d9c:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800da1:	c9                   	leave  
  800da2:	c3                   	ret    

00800da3 <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  800da3:	55                   	push   %ebp
  800da4:	89 e5                	mov    %esp,%ebp
  800da6:	83 ec 04             	sub    $0x4,%esp
  800da9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800dac:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  800daf:	eb 0f                	jmp    800dc0 <strfind+0x1d>
        if (*s == c) {
  800db1:	8b 45 08             	mov    0x8(%ebp),%eax
  800db4:	0f b6 00             	movzbl (%eax),%eax
  800db7:	3a 45 fc             	cmp    -0x4(%ebp),%al
  800dba:	74 10                	je     800dcc <strfind+0x29>
            break;
        }
        s ++;
  800dbc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  800dc0:	8b 45 08             	mov    0x8(%ebp),%eax
  800dc3:	0f b6 00             	movzbl (%eax),%eax
  800dc6:	84 c0                	test   %al,%al
  800dc8:	75 e7                	jne    800db1 <strfind+0xe>
  800dca:	eb 01                	jmp    800dcd <strfind+0x2a>
        if (*s == c) {
            break;
  800dcc:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  800dcd:	8b 45 08             	mov    0x8(%ebp),%eax
}
  800dd0:	c9                   	leave  
  800dd1:	c3                   	ret    

00800dd2 <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  800dd2:	55                   	push   %ebp
  800dd3:	89 e5                	mov    %esp,%ebp
  800dd5:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  800dd8:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  800ddf:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800de6:	eb 04                	jmp    800dec <strtol+0x1a>
        s ++;
  800de8:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  800dec:	8b 45 08             	mov    0x8(%ebp),%eax
  800def:	0f b6 00             	movzbl (%eax),%eax
  800df2:	3c 20                	cmp    $0x20,%al
  800df4:	74 f2                	je     800de8 <strtol+0x16>
  800df6:	8b 45 08             	mov    0x8(%ebp),%eax
  800df9:	0f b6 00             	movzbl (%eax),%eax
  800dfc:	3c 09                	cmp    $0x9,%al
  800dfe:	74 e8                	je     800de8 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  800e00:	8b 45 08             	mov    0x8(%ebp),%eax
  800e03:	0f b6 00             	movzbl (%eax),%eax
  800e06:	3c 2b                	cmp    $0x2b,%al
  800e08:	75 06                	jne    800e10 <strtol+0x3e>
        s ++;
  800e0a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e0e:	eb 15                	jmp    800e25 <strtol+0x53>
    }
    else if (*s == '-') {
  800e10:	8b 45 08             	mov    0x8(%ebp),%eax
  800e13:	0f b6 00             	movzbl (%eax),%eax
  800e16:	3c 2d                	cmp    $0x2d,%al
  800e18:	75 0b                	jne    800e25 <strtol+0x53>
        s ++, neg = 1;
  800e1a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e1e:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  800e25:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e29:	74 06                	je     800e31 <strtol+0x5f>
  800e2b:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  800e2f:	75 24                	jne    800e55 <strtol+0x83>
  800e31:	8b 45 08             	mov    0x8(%ebp),%eax
  800e34:	0f b6 00             	movzbl (%eax),%eax
  800e37:	3c 30                	cmp    $0x30,%al
  800e39:	75 1a                	jne    800e55 <strtol+0x83>
  800e3b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e3e:	83 c0 01             	add    $0x1,%eax
  800e41:	0f b6 00             	movzbl (%eax),%eax
  800e44:	3c 78                	cmp    $0x78,%al
  800e46:	75 0d                	jne    800e55 <strtol+0x83>
        s += 2, base = 16;
  800e48:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  800e4c:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  800e53:	eb 2a                	jmp    800e7f <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  800e55:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e59:	75 17                	jne    800e72 <strtol+0xa0>
  800e5b:	8b 45 08             	mov    0x8(%ebp),%eax
  800e5e:	0f b6 00             	movzbl (%eax),%eax
  800e61:	3c 30                	cmp    $0x30,%al
  800e63:	75 0d                	jne    800e72 <strtol+0xa0>
        s ++, base = 8;
  800e65:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800e69:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  800e70:	eb 0d                	jmp    800e7f <strtol+0xad>
    }
    else if (base == 0) {
  800e72:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  800e76:	75 07                	jne    800e7f <strtol+0xad>
        base = 10;
  800e78:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  800e7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800e82:	0f b6 00             	movzbl (%eax),%eax
  800e85:	3c 2f                	cmp    $0x2f,%al
  800e87:	7e 1b                	jle    800ea4 <strtol+0xd2>
  800e89:	8b 45 08             	mov    0x8(%ebp),%eax
  800e8c:	0f b6 00             	movzbl (%eax),%eax
  800e8f:	3c 39                	cmp    $0x39,%al
  800e91:	7f 11                	jg     800ea4 <strtol+0xd2>
            dig = *s - '0';
  800e93:	8b 45 08             	mov    0x8(%ebp),%eax
  800e96:	0f b6 00             	movzbl (%eax),%eax
  800e99:	0f be c0             	movsbl %al,%eax
  800e9c:	83 e8 30             	sub    $0x30,%eax
  800e9f:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ea2:	eb 48                	jmp    800eec <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  800ea4:	8b 45 08             	mov    0x8(%ebp),%eax
  800ea7:	0f b6 00             	movzbl (%eax),%eax
  800eaa:	3c 60                	cmp    $0x60,%al
  800eac:	7e 1b                	jle    800ec9 <strtol+0xf7>
  800eae:	8b 45 08             	mov    0x8(%ebp),%eax
  800eb1:	0f b6 00             	movzbl (%eax),%eax
  800eb4:	3c 7a                	cmp    $0x7a,%al
  800eb6:	7f 11                	jg     800ec9 <strtol+0xf7>
            dig = *s - 'a' + 10;
  800eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800ebb:	0f b6 00             	movzbl (%eax),%eax
  800ebe:	0f be c0             	movsbl %al,%eax
  800ec1:	83 e8 57             	sub    $0x57,%eax
  800ec4:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ec7:	eb 23                	jmp    800eec <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  800ec9:	8b 45 08             	mov    0x8(%ebp),%eax
  800ecc:	0f b6 00             	movzbl (%eax),%eax
  800ecf:	3c 40                	cmp    $0x40,%al
  800ed1:	7e 38                	jle    800f0b <strtol+0x139>
  800ed3:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed6:	0f b6 00             	movzbl (%eax),%eax
  800ed9:	3c 5a                	cmp    $0x5a,%al
  800edb:	7f 2e                	jg     800f0b <strtol+0x139>
            dig = *s - 'A' + 10;
  800edd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ee0:	0f b6 00             	movzbl (%eax),%eax
  800ee3:	0f be c0             	movsbl %al,%eax
  800ee6:	83 e8 37             	sub    $0x37,%eax
  800ee9:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  800eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800eef:	3b 45 10             	cmp    0x10(%ebp),%eax
  800ef2:	7d 16                	jge    800f0a <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
  800ef4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800ef8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800efb:	0f af 45 10          	imul   0x10(%ebp),%eax
  800eff:	03 45 f4             	add    -0xc(%ebp),%eax
  800f02:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  800f05:	e9 75 ff ff ff       	jmp    800e7f <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  800f0a:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  800f0b:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800f0f:	74 08                	je     800f19 <strtol+0x147>
        *endptr = (char *) s;
  800f11:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f14:	8b 55 08             	mov    0x8(%ebp),%edx
  800f17:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  800f19:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  800f1d:	74 07                	je     800f26 <strtol+0x154>
  800f1f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  800f22:	f7 d8                	neg    %eax
  800f24:	eb 03                	jmp    800f29 <strtol+0x157>
  800f26:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  800f29:	c9                   	leave  
  800f2a:	c3                   	ret    

00800f2b <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  800f2b:	55                   	push   %ebp
  800f2c:	89 e5                	mov    %esp,%ebp
  800f2e:	57                   	push   %edi
  800f2f:	56                   	push   %esi
  800f30:	53                   	push   %ebx
  800f31:	83 ec 24             	sub    $0x24,%esp
  800f34:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f37:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  800f3a:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  800f3e:	8b 55 08             	mov    0x8(%ebp),%edx
  800f41:	89 55 f0             	mov    %edx,-0x10(%ebp)
  800f44:	88 45 ef             	mov    %al,-0x11(%ebp)
  800f47:	8b 45 10             	mov    0x10(%ebp),%eax
  800f4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  800f4d:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  800f50:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  800f54:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800f57:	89 ce                	mov    %ecx,%esi
  800f59:	89 d3                	mov    %edx,%ebx
  800f5b:	89 f1                	mov    %esi,%ecx
  800f5d:	89 df                	mov    %ebx,%edi
  800f5f:	f3 aa                	rep stos %al,%es:(%edi)
  800f61:	89 fb                	mov    %edi,%ebx
  800f63:	89 ce                	mov    %ecx,%esi
  800f65:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  800f68:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  800f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  800f6e:	83 c4 24             	add    $0x24,%esp
  800f71:	5b                   	pop    %ebx
  800f72:	5e                   	pop    %esi
  800f73:	5f                   	pop    %edi
  800f74:	5d                   	pop    %ebp
  800f75:	c3                   	ret    

00800f76 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  800f76:	55                   	push   %ebp
  800f77:	89 e5                	mov    %esp,%ebp
  800f79:	57                   	push   %edi
  800f7a:	56                   	push   %esi
  800f7b:	53                   	push   %ebx
  800f7c:	83 ec 38             	sub    $0x38,%esp
  800f7f:	8b 45 08             	mov    0x8(%ebp),%eax
  800f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800f85:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f88:	89 45 ec             	mov    %eax,-0x14(%ebp)
  800f8b:	8b 45 10             	mov    0x10(%ebp),%eax
  800f8e:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  800f91:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f94:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  800f97:	73 4e                	jae    800fe7 <memmove+0x71>
  800f99:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800f9c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800f9f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  800fa2:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800fa5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fa8:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  800fab:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800fae:	89 c1                	mov    %eax,%ecx
  800fb0:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  800fb3:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800fb6:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800fb9:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800fbc:	89 d7                	mov    %edx,%edi
  800fbe:	89 c3                	mov    %eax,%ebx
  800fc0:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800fc3:	89 de                	mov    %ebx,%esi
  800fc5:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  800fc7:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  800fca:	83 e1 03             	and    $0x3,%ecx
  800fcd:	74 02                	je     800fd1 <memmove+0x5b>
  800fcf:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  800fd1:	89 f3                	mov    %esi,%ebx
  800fd3:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  800fd6:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  800fd9:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  800fdc:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  800fdf:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  800fe2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800fe5:	eb 3b                	jmp    801022 <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  800fe7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800fea:	83 e8 01             	sub    $0x1,%eax
  800fed:	89 c2                	mov    %eax,%edx
  800fef:	03 55 ec             	add    -0x14(%ebp),%edx
  800ff2:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800ff5:	83 e8 01             	sub    $0x1,%eax
  800ff8:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  800ffb:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  800ffe:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  801001:	89 d6                	mov    %edx,%esi
  801003:	89 c3                	mov    %eax,%ebx
  801005:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801008:	89 df                	mov    %ebx,%edi
  80100a:	fd                   	std    
  80100b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80100d:	fc                   	cld    
  80100e:	89 fb                	mov    %edi,%ebx
  801010:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  801013:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  801016:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  801019:	89 75 c8             	mov    %esi,-0x38(%ebp)
  80101c:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  80101f:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  801022:	83 c4 38             	add    $0x38,%esp
  801025:	5b                   	pop    %ebx
  801026:	5e                   	pop    %esi
  801027:	5f                   	pop    %edi
  801028:	5d                   	pop    %ebp
  801029:	c3                   	ret    

0080102a <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  80102a:	55                   	push   %ebp
  80102b:	89 e5                	mov    %esp,%ebp
  80102d:	57                   	push   %edi
  80102e:	56                   	push   %esi
  80102f:	53                   	push   %ebx
  801030:	83 ec 24             	sub    $0x24,%esp
  801033:	8b 45 08             	mov    0x8(%ebp),%eax
  801036:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801039:	8b 45 0c             	mov    0xc(%ebp),%eax
  80103c:	89 45 ec             	mov    %eax,-0x14(%ebp)
  80103f:	8b 45 10             	mov    0x10(%ebp),%eax
  801042:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  801045:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801048:	89 c1                	mov    %eax,%ecx
  80104a:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  80104d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801050:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801053:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801056:	89 d7                	mov    %edx,%edi
  801058:	89 c3                	mov    %eax,%ebx
  80105a:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80105d:	89 de                	mov    %ebx,%esi
  80105f:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801061:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801064:	83 e1 03             	and    $0x3,%ecx
  801067:	74 02                	je     80106b <memcpy+0x41>
  801069:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80106b:	89 f3                	mov    %esi,%ebx
  80106d:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801070:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801073:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  801076:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801079:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  80107c:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  80107f:	83 c4 24             	add    $0x24,%esp
  801082:	5b                   	pop    %ebx
  801083:	5e                   	pop    %esi
  801084:	5f                   	pop    %edi
  801085:	5d                   	pop    %ebp
  801086:	c3                   	ret    

00801087 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  801087:	55                   	push   %ebp
  801088:	89 e5                	mov    %esp,%ebp
  80108a:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  80108d:	8b 45 08             	mov    0x8(%ebp),%eax
  801090:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  801093:	8b 45 0c             	mov    0xc(%ebp),%eax
  801096:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  801099:	eb 32                	jmp    8010cd <memcmp+0x46>
        if (*s1 != *s2) {
  80109b:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80109e:	0f b6 10             	movzbl (%eax),%edx
  8010a1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010a4:	0f b6 00             	movzbl (%eax),%eax
  8010a7:	38 c2                	cmp    %al,%dl
  8010a9:	74 1a                	je     8010c5 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  8010ab:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8010ae:	0f b6 00             	movzbl (%eax),%eax
  8010b1:	0f b6 d0             	movzbl %al,%edx
  8010b4:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8010b7:	0f b6 00             	movzbl (%eax),%eax
  8010ba:	0f b6 c0             	movzbl %al,%eax
  8010bd:	89 d1                	mov    %edx,%ecx
  8010bf:	29 c1                	sub    %eax,%ecx
  8010c1:	89 c8                	mov    %ecx,%eax
  8010c3:	eb 1c                	jmp    8010e1 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  8010c5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  8010c9:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  8010cd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8010d1:	0f 95 c0             	setne  %al
  8010d4:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8010d8:	84 c0                	test   %al,%al
  8010da:	75 bf                	jne    80109b <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  8010dc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8010e1:	c9                   	leave  
  8010e2:	c3                   	ret    
	...

008010e4 <forkchild>:
#define DEPTH 4

void forktree(const char *cur);

void
forkchild(const char *cur, char branch) {
  8010e4:	55                   	push   %ebp
  8010e5:	89 e5                	mov    %esp,%ebp
  8010e7:	83 ec 48             	sub    $0x48,%esp
  8010ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ed:	88 45 e4             	mov    %al,-0x1c(%ebp)
    char nxt[DEPTH + 1];

    if (strlen(cur) >= DEPTH)
  8010f0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010f3:	89 04 24             	mov    %eax,(%esp)
  8010f6:	e8 f5 fa ff ff       	call   800bf0 <strlen>
  8010fb:	83 f8 03             	cmp    $0x3,%eax
  8010fe:	77 4f                	ja     80114f <forkchild+0x6b>
        return;

    snprintf(nxt, DEPTH + 1, "%s%c", cur, branch);
  801100:	0f be 45 e4          	movsbl -0x1c(%ebp),%eax
  801104:	89 44 24 10          	mov    %eax,0x10(%esp)
  801108:	8b 45 08             	mov    0x8(%ebp),%eax
  80110b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80110f:	c7 44 24 08 a0 14 80 	movl   $0x8014a0,0x8(%esp)
  801116:	00 
  801117:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  80111e:	00 
  80111f:	8d 45 f3             	lea    -0xd(%ebp),%eax
  801122:	89 04 24             	mov    %eax,(%esp)
  801125:	e8 2a f9 ff ff       	call   800a54 <snprintf>
    if (fork() == 0) {
  80112a:	e8 fc f1 ff ff       	call   80032b <fork>
  80112f:	85 c0                	test   %eax,%eax
  801131:	75 1d                	jne    801150 <forkchild+0x6c>
        forktree(nxt);
  801133:	8d 45 f3             	lea    -0xd(%ebp),%eax
  801136:	89 04 24             	mov    %eax,(%esp)
  801139:	e8 14 00 00 00       	call   801152 <forktree>
        yield();
  80113e:	e8 2b f2 ff ff       	call   80036e <yield>
        exit(0);
  801143:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80114a:	e8 bd f1 ff ff       	call   80030c <exit>
void
forkchild(const char *cur, char branch) {
    char nxt[DEPTH + 1];

    if (strlen(cur) >= DEPTH)
        return;
  80114f:	90                   	nop
    if (fork() == 0) {
        forktree(nxt);
        yield();
        exit(0);
    }
}
  801150:	c9                   	leave  
  801151:	c3                   	ret    

00801152 <forktree>:

void
forktree(const char *cur) {
  801152:	55                   	push   %ebp
  801153:	89 e5                	mov    %esp,%ebp
  801155:	83 ec 18             	sub    $0x18,%esp
    cprintf("%04x: I am '%s'\n", getpid(), cur);
  801158:	e8 31 f2 ff ff       	call   80038e <getpid>
  80115d:	8b 55 08             	mov    0x8(%ebp),%edx
  801160:	89 54 24 08          	mov    %edx,0x8(%esp)
  801164:	89 44 24 04          	mov    %eax,0x4(%esp)
  801168:	c7 04 24 a5 14 80 00 	movl   $0x8014a5,(%esp)
  80116f:	e8 ab ef ff ff       	call   80011f <cprintf>

    forkchild(cur, '0');
  801174:	c7 44 24 04 30 00 00 	movl   $0x30,0x4(%esp)
  80117b:	00 
  80117c:	8b 45 08             	mov    0x8(%ebp),%eax
  80117f:	89 04 24             	mov    %eax,(%esp)
  801182:	e8 5d ff ff ff       	call   8010e4 <forkchild>
    forkchild(cur, '1');
  801187:	c7 44 24 04 31 00 00 	movl   $0x31,0x4(%esp)
  80118e:	00 
  80118f:	8b 45 08             	mov    0x8(%ebp),%eax
  801192:	89 04 24             	mov    %eax,(%esp)
  801195:	e8 4a ff ff ff       	call   8010e4 <forkchild>
}
  80119a:	c9                   	leave  
  80119b:	c3                   	ret    

0080119c <main>:

int
main(void) {
  80119c:	55                   	push   %ebp
  80119d:	89 e5                	mov    %esp,%ebp
  80119f:	83 e4 f0             	and    $0xfffffff0,%esp
  8011a2:	83 ec 10             	sub    $0x10,%esp
    forktree("");
  8011a5:	c7 04 24 b6 14 80 00 	movl   $0x8014b6,(%esp)
  8011ac:	e8 a1 ff ff ff       	call   801152 <forktree>
    return 0;
  8011b1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8011b6:	c9                   	leave  
  8011b7:	c3                   	ret    
