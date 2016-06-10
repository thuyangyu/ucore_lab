
bin/kernel_nopage:     file format elf32-i386


Disassembly of section .text:

00100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
  100000:	0f 01 15 18 80 11 40 	lgdtl  0x40118018
    movl $KERNEL_DS, %eax
  100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  10000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  10000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
  100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
  100012:	ea 19 00 10 00 08 00 	ljmp   $0x8,$0x100019

00100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
  100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
  10001e:	bc 00 80 11 00       	mov    $0x118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
  100023:	e8 04 00 00 00       	call   10002c <kern_init>

00100028 <spin>:

# should never get here
spin:
    jmp spin
  100028:	eb fe                	jmp    100028 <spin>
	...

0010002c <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
  10002c:	55                   	push   %ebp
  10002d:	89 e5                	mov    %esp,%ebp
  10002f:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
  100032:	ba 68 99 11 00       	mov    $0x119968,%edx
  100037:	b8 38 8a 11 00       	mov    $0x118a38,%eax
  10003c:	89 d1                	mov    %edx,%ecx
  10003e:	29 c1                	sub    %eax,%ecx
  100040:	89 c8                	mov    %ecx,%eax
  100042:	89 44 24 08          	mov    %eax,0x8(%esp)
  100046:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  10004d:	00 
  10004e:	c7 04 24 38 8a 11 00 	movl   $0x118a38,(%esp)
  100055:	e8 6d 60 00 00       	call   1060c7 <memset>

    cons_init();                // init the console
  10005a:	e8 fd 15 00 00       	call   10165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
  10005f:	c7 45 f4 80 62 10 00 	movl   $0x106280,-0xc(%ebp)
    cprintf("%s\n\n", message);
  100066:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100069:	89 44 24 04          	mov    %eax,0x4(%esp)
  10006d:	c7 04 24 9c 62 10 00 	movl   $0x10629c,(%esp)
  100074:	e8 ce 02 00 00       	call   100347 <cprintf>

    print_kerninfo();
  100079:	e8 d8 07 00 00       	call   100856 <print_kerninfo>

    grade_backtrace();
  10007e:	e8 86 00 00 00       	call   100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
  100083:	e8 f4 44 00 00       	call   10457c <pmm_init>

    pic_init();                 // init interrupt controller
  100088:	e8 40 17 00 00       	call   1017cd <pic_init>
    idt_init();                 // init interrupt descriptor table
  10008d:	e8 92 18 00 00       	call   101924 <idt_init>

    clock_init();               // init clock interrupt
  100092:	e8 d5 0c 00 00       	call   100d6c <clock_init>
    intr_enable();              // enable irq interrupt
  100097:	e8 98 16 00 00       	call   101734 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
  10009c:	eb fe                	jmp    10009c <kern_init+0x70>

0010009e <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
  10009e:	55                   	push   %ebp
  10009f:	89 e5                	mov    %esp,%ebp
  1000a1:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
  1000a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1000ab:	00 
  1000ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1000b3:	00 
  1000b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  1000bb:	e8 d6 0b 00 00       	call   100c96 <mon_backtrace>
}
  1000c0:	c9                   	leave  
  1000c1:	c3                   	ret    

001000c2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
  1000c2:	55                   	push   %ebp
  1000c3:	89 e5                	mov    %esp,%ebp
  1000c5:	53                   	push   %ebx
  1000c6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
  1000c9:	8d 5d 0c             	lea    0xc(%ebp),%ebx
  1000cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
  1000cf:	8d 55 08             	lea    0x8(%ebp),%edx
  1000d2:	8b 45 08             	mov    0x8(%ebp),%eax
  1000d5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1000d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1000dd:	89 54 24 04          	mov    %edx,0x4(%esp)
  1000e1:	89 04 24             	mov    %eax,(%esp)
  1000e4:	e8 b5 ff ff ff       	call   10009e <grade_backtrace2>
}
  1000e9:	83 c4 14             	add    $0x14,%esp
  1000ec:	5b                   	pop    %ebx
  1000ed:	5d                   	pop    %ebp
  1000ee:	c3                   	ret    

001000ef <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
  1000ef:	55                   	push   %ebp
  1000f0:	89 e5                	mov    %esp,%ebp
  1000f2:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
  1000f5:	8b 45 10             	mov    0x10(%ebp),%eax
  1000f8:	89 44 24 04          	mov    %eax,0x4(%esp)
  1000fc:	8b 45 08             	mov    0x8(%ebp),%eax
  1000ff:	89 04 24             	mov    %eax,(%esp)
  100102:	e8 bb ff ff ff       	call   1000c2 <grade_backtrace1>
}
  100107:	c9                   	leave  
  100108:	c3                   	ret    

00100109 <grade_backtrace>:

void
grade_backtrace(void) {
  100109:	55                   	push   %ebp
  10010a:	89 e5                	mov    %esp,%ebp
  10010c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
  10010f:	b8 2c 00 10 00       	mov    $0x10002c,%eax
  100114:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
  10011b:	ff 
  10011c:	89 44 24 04          	mov    %eax,0x4(%esp)
  100120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100127:	e8 c3 ff ff ff       	call   1000ef <grade_backtrace0>
}
  10012c:	c9                   	leave  
  10012d:	c3                   	ret    

0010012e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
  10012e:	55                   	push   %ebp
  10012f:	89 e5                	mov    %esp,%ebp
  100131:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
  100134:	8c 4d f6             	mov    %cs,-0xa(%ebp)
  100137:	8c 5d f4             	mov    %ds,-0xc(%ebp)
  10013a:	8c 45 f2             	mov    %es,-0xe(%ebp)
  10013d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
  100140:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100144:	0f b7 c0             	movzwl %ax,%eax
  100147:	89 c2                	mov    %eax,%edx
  100149:	83 e2 03             	and    $0x3,%edx
  10014c:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100151:	89 54 24 08          	mov    %edx,0x8(%esp)
  100155:	89 44 24 04          	mov    %eax,0x4(%esp)
  100159:	c7 04 24 a1 62 10 00 	movl   $0x1062a1,(%esp)
  100160:	e8 e2 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
  100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
  100169:	0f b7 d0             	movzwl %ax,%edx
  10016c:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100171:	89 54 24 08          	mov    %edx,0x8(%esp)
  100175:	89 44 24 04          	mov    %eax,0x4(%esp)
  100179:	c7 04 24 af 62 10 00 	movl   $0x1062af,(%esp)
  100180:	e8 c2 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
  100185:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
  100189:	0f b7 d0             	movzwl %ax,%edx
  10018c:	a1 40 8a 11 00       	mov    0x118a40,%eax
  100191:	89 54 24 08          	mov    %edx,0x8(%esp)
  100195:	89 44 24 04          	mov    %eax,0x4(%esp)
  100199:	c7 04 24 bd 62 10 00 	movl   $0x1062bd,(%esp)
  1001a0:	e8 a2 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
  1001a5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
  1001a9:	0f b7 d0             	movzwl %ax,%edx
  1001ac:	a1 40 8a 11 00       	mov    0x118a40,%eax
  1001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001b9:	c7 04 24 cb 62 10 00 	movl   $0x1062cb,(%esp)
  1001c0:	e8 82 01 00 00       	call   100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
  1001c5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
  1001c9:	0f b7 d0             	movzwl %ax,%edx
  1001cc:	a1 40 8a 11 00       	mov    0x118a40,%eax
  1001d1:	89 54 24 08          	mov    %edx,0x8(%esp)
  1001d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  1001d9:	c7 04 24 d9 62 10 00 	movl   $0x1062d9,(%esp)
  1001e0:	e8 62 01 00 00       	call   100347 <cprintf>
    round ++;
  1001e5:	a1 40 8a 11 00       	mov    0x118a40,%eax
  1001ea:	83 c0 01             	add    $0x1,%eax
  1001ed:	a3 40 8a 11 00       	mov    %eax,0x118a40
}
  1001f2:	c9                   	leave  
  1001f3:	c3                   	ret    

001001f4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
  1001f4:	55                   	push   %ebp
  1001f5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
  1001f7:	5d                   	pop    %ebp
  1001f8:	c3                   	ret    

001001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
  1001f9:	55                   	push   %ebp
  1001fa:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
  1001fc:	5d                   	pop    %ebp
  1001fd:	c3                   	ret    

001001fe <lab1_switch_test>:

static void
lab1_switch_test(void) {
  1001fe:	55                   	push   %ebp
  1001ff:	89 e5                	mov    %esp,%ebp
  100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
  100204:	e8 25 ff ff ff       	call   10012e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
  100209:	c7 04 24 e8 62 10 00 	movl   $0x1062e8,(%esp)
  100210:	e8 32 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_user();
  100215:	e8 da ff ff ff       	call   1001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
  10021a:	e8 0f ff ff ff       	call   10012e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
  10021f:	c7 04 24 08 63 10 00 	movl   $0x106308,(%esp)
  100226:	e8 1c 01 00 00       	call   100347 <cprintf>
    lab1_switch_to_kernel();
  10022b:	e8 c9 ff ff ff       	call   1001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
  100230:	e8 f9 fe ff ff       	call   10012e <lab1_print_cur_status>
}
  100235:	c9                   	leave  
  100236:	c3                   	ret    
	...

00100238 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
  100238:	55                   	push   %ebp
  100239:	89 e5                	mov    %esp,%ebp
  10023b:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
  10023e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100242:	74 13                	je     100257 <readline+0x1f>
        cprintf("%s", prompt);
  100244:	8b 45 08             	mov    0x8(%ebp),%eax
  100247:	89 44 24 04          	mov    %eax,0x4(%esp)
  10024b:	c7 04 24 27 63 10 00 	movl   $0x106327,(%esp)
  100252:	e8 f0 00 00 00       	call   100347 <cprintf>
    }
    int i = 0, c;
  100257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  10025e:	eb 01                	jmp    100261 <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
  100260:	90                   	nop
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
  100261:	e8 6e 01 00 00       	call   1003d4 <getchar>
  100266:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
  100269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10026d:	79 07                	jns    100276 <readline+0x3e>
            return NULL;
  10026f:	b8 00 00 00 00       	mov    $0x0,%eax
  100274:	eb 79                	jmp    1002ef <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
  100276:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
  10027a:	7e 28                	jle    1002a4 <readline+0x6c>
  10027c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
  100283:	7f 1f                	jg     1002a4 <readline+0x6c>
            cputchar(c);
  100285:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100288:	89 04 24             	mov    %eax,(%esp)
  10028b:	e8 df 00 00 00       	call   10036f <cputchar>
            buf[i ++] = c;
  100290:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100293:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100296:	81 c2 60 8a 11 00    	add    $0x118a60,%edx
  10029c:	88 02                	mov    %al,(%edx)
  10029e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  1002a2:	eb 46                	jmp    1002ea <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
  1002a4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
  1002a8:	75 17                	jne    1002c1 <readline+0x89>
  1002aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1002ae:	7e 11                	jle    1002c1 <readline+0x89>
            cputchar(c);
  1002b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002b3:	89 04 24             	mov    %eax,(%esp)
  1002b6:	e8 b4 00 00 00       	call   10036f <cputchar>
            i --;
  1002bb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  1002bf:	eb 29                	jmp    1002ea <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
  1002c1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
  1002c5:	74 06                	je     1002cd <readline+0x95>
  1002c7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
  1002cb:	75 93                	jne    100260 <readline+0x28>
            cputchar(c);
  1002cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1002d0:	89 04 24             	mov    %eax,(%esp)
  1002d3:	e8 97 00 00 00       	call   10036f <cputchar>
            buf[i] = '\0';
  1002d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1002db:	05 60 8a 11 00       	add    $0x118a60,%eax
  1002e0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
  1002e3:	b8 60 8a 11 00       	mov    $0x118a60,%eax
  1002e8:	eb 05                	jmp    1002ef <readline+0xb7>
        }
    }
  1002ea:	e9 71 ff ff ff       	jmp    100260 <readline+0x28>
}
  1002ef:	c9                   	leave  
  1002f0:	c3                   	ret    
  1002f1:	00 00                	add    %al,(%eax)
	...

001002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  1002f4:	55                   	push   %ebp
  1002f5:	89 e5                	mov    %esp,%ebp
  1002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  1002fa:	8b 45 08             	mov    0x8(%ebp),%eax
  1002fd:	89 04 24             	mov    %eax,(%esp)
  100300:	e8 83 13 00 00       	call   101688 <cons_putc>
    (*cnt) ++;
  100305:	8b 45 0c             	mov    0xc(%ebp),%eax
  100308:	8b 00                	mov    (%eax),%eax
  10030a:	8d 50 01             	lea    0x1(%eax),%edx
  10030d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100310:	89 10                	mov    %edx,(%eax)
}
  100312:	c9                   	leave  
  100313:	c3                   	ret    

00100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  100314:	55                   	push   %ebp
  100315:	89 e5                	mov    %esp,%ebp
  100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  10031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
  100321:	8b 45 0c             	mov    0xc(%ebp),%eax
  100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
  100328:	8b 45 08             	mov    0x8(%ebp),%eax
  10032b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100332:	89 44 24 04          	mov    %eax,0x4(%esp)
  100336:	c7 04 24 f4 02 10 00 	movl   $0x1002f4,(%esp)
  10033d:	e8 88 55 00 00       	call   1058ca <vprintfmt>
    return cnt;
  100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100345:	c9                   	leave  
  100346:	c3                   	ret    

00100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  100347:	55                   	push   %ebp
  100348:	89 e5                	mov    %esp,%ebp
  10034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  10034d:	8d 55 0c             	lea    0xc(%ebp),%edx
  100350:	8d 45 f0             	lea    -0x10(%ebp),%eax
  100353:	89 10                	mov    %edx,(%eax)
    cnt = vcprintf(fmt, ap);
  100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100358:	89 44 24 04          	mov    %eax,0x4(%esp)
  10035c:	8b 45 08             	mov    0x8(%ebp),%eax
  10035f:	89 04 24             	mov    %eax,(%esp)
  100362:	e8 ad ff ff ff       	call   100314 <vcprintf>
  100367:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  10036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  10036d:	c9                   	leave  
  10036e:	c3                   	ret    

0010036f <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
  10036f:	55                   	push   %ebp
  100370:	89 e5                	mov    %esp,%ebp
  100372:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
  100375:	8b 45 08             	mov    0x8(%ebp),%eax
  100378:	89 04 24             	mov    %eax,(%esp)
  10037b:	e8 08 13 00 00       	call   101688 <cons_putc>
}
  100380:	c9                   	leave  
  100381:	c3                   	ret    

00100382 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  100382:	55                   	push   %ebp
  100383:	89 e5                	mov    %esp,%ebp
  100385:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  100388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  10038f:	eb 13                	jmp    1003a4 <cputs+0x22>
        cputch(c, &cnt);
  100391:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  100395:	8d 55 f0             	lea    -0x10(%ebp),%edx
  100398:	89 54 24 04          	mov    %edx,0x4(%esp)
  10039c:	89 04 24             	mov    %eax,(%esp)
  10039f:	e8 50 ff ff ff       	call   1002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  1003a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1003a7:	0f b6 00             	movzbl (%eax),%eax
  1003aa:	88 45 f7             	mov    %al,-0x9(%ebp)
  1003ad:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  1003b1:	0f 95 c0             	setne  %al
  1003b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  1003b8:	84 c0                	test   %al,%al
  1003ba:	75 d5                	jne    100391 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  1003bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
  1003bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1003c3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  1003ca:	e8 25 ff ff ff       	call   1002f4 <cputch>
    return cnt;
  1003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  1003d2:	c9                   	leave  
  1003d3:	c3                   	ret    

001003d4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
  1003d4:	55                   	push   %ebp
  1003d5:	89 e5                	mov    %esp,%ebp
  1003d7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
  1003da:	e8 e5 12 00 00       	call   1016c4 <cons_getc>
  1003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1003e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1003e6:	74 f2                	je     1003da <getchar+0x6>
        /* do nothing */;
    return c;
  1003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  1003eb:	c9                   	leave  
  1003ec:	c3                   	ret    
  1003ed:	00 00                	add    %al,(%eax)
	...

001003f0 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
  1003f0:	55                   	push   %ebp
  1003f1:	89 e5                	mov    %esp,%ebp
  1003f3:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
  1003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1003f9:	8b 00                	mov    (%eax),%eax
  1003fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1003fe:	8b 45 10             	mov    0x10(%ebp),%eax
  100401:	8b 00                	mov    (%eax),%eax
  100403:	89 45 f8             	mov    %eax,-0x8(%ebp)
  100406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
  10040d:	e9 c6 00 00 00       	jmp    1004d8 <stab_binsearch+0xe8>
        int true_m = (l + r) / 2, m = true_m;
  100412:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100415:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100418:	01 d0                	add    %edx,%eax
  10041a:	89 c2                	mov    %eax,%edx
  10041c:	c1 ea 1f             	shr    $0x1f,%edx
  10041f:	01 d0                	add    %edx,%eax
  100421:	d1 f8                	sar    %eax
  100423:	89 45 ec             	mov    %eax,-0x14(%ebp)
  100426:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100429:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  10042c:	eb 04                	jmp    100432 <stab_binsearch+0x42>
            m --;
  10042e:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
  100432:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100435:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  100438:	7c 1b                	jl     100455 <stab_binsearch+0x65>
  10043a:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10043d:	89 d0                	mov    %edx,%eax
  10043f:	01 c0                	add    %eax,%eax
  100441:	01 d0                	add    %edx,%eax
  100443:	c1 e0 02             	shl    $0x2,%eax
  100446:	03 45 08             	add    0x8(%ebp),%eax
  100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10044d:	0f b6 c0             	movzbl %al,%eax
  100450:	3b 45 14             	cmp    0x14(%ebp),%eax
  100453:	75 d9                	jne    10042e <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
  100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10045b:	7d 0b                	jge    100468 <stab_binsearch+0x78>
            l = true_m + 1;
  10045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100460:	83 c0 01             	add    $0x1,%eax
  100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
  100466:	eb 70                	jmp    1004d8 <stab_binsearch+0xe8>
        }

        // actual binary search
        any_matches = 1;
  100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
  10046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  100472:	89 d0                	mov    %edx,%eax
  100474:	01 c0                	add    %eax,%eax
  100476:	01 d0                	add    %edx,%eax
  100478:	c1 e0 02             	shl    $0x2,%eax
  10047b:	03 45 08             	add    0x8(%ebp),%eax
  10047e:	8b 40 08             	mov    0x8(%eax),%eax
  100481:	3b 45 18             	cmp    0x18(%ebp),%eax
  100484:	73 13                	jae    100499 <stab_binsearch+0xa9>
            *region_left = m;
  100486:	8b 45 0c             	mov    0xc(%ebp),%eax
  100489:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10048c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
  10048e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100491:	83 c0 01             	add    $0x1,%eax
  100494:	89 45 fc             	mov    %eax,-0x4(%ebp)
  100497:	eb 3f                	jmp    1004d8 <stab_binsearch+0xe8>
        } else if (stabs[m].n_value > addr) {
  100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
  10049c:	89 d0                	mov    %edx,%eax
  10049e:	01 c0                	add    %eax,%eax
  1004a0:	01 d0                	add    %edx,%eax
  1004a2:	c1 e0 02             	shl    $0x2,%eax
  1004a5:	03 45 08             	add    0x8(%ebp),%eax
  1004a8:	8b 40 08             	mov    0x8(%eax),%eax
  1004ab:	3b 45 18             	cmp    0x18(%ebp),%eax
  1004ae:	76 16                	jbe    1004c6 <stab_binsearch+0xd6>
            *region_right = m - 1;
  1004b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004b3:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004b6:	8b 45 10             	mov    0x10(%ebp),%eax
  1004b9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
  1004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004be:	83 e8 01             	sub    $0x1,%eax
  1004c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
  1004c4:	eb 12                	jmp    1004d8 <stab_binsearch+0xe8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
  1004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1004cc:	89 10                	mov    %edx,(%eax)
            l = m;
  1004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1004d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
  1004d4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
  1004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1004db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
  1004de:	0f 8e 2e ff ff ff    	jle    100412 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
  1004e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1004e8:	75 0f                	jne    1004f9 <stab_binsearch+0x109>
        *region_right = *region_left - 1;
  1004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1004ed:	8b 00                	mov    (%eax),%eax
  1004ef:	8d 50 ff             	lea    -0x1(%eax),%edx
  1004f2:	8b 45 10             	mov    0x10(%ebp),%eax
  1004f5:	89 10                	mov    %edx,(%eax)
  1004f7:	eb 3b                	jmp    100534 <stab_binsearch+0x144>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
  1004f9:	8b 45 10             	mov    0x10(%ebp),%eax
  1004fc:	8b 00                	mov    (%eax),%eax
  1004fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
  100501:	eb 04                	jmp    100507 <stab_binsearch+0x117>
  100503:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
  100507:	8b 45 0c             	mov    0xc(%ebp),%eax
  10050a:	8b 00                	mov    (%eax),%eax
  10050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
  10050f:	7d 1b                	jge    10052c <stab_binsearch+0x13c>
  100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100514:	89 d0                	mov    %edx,%eax
  100516:	01 c0                	add    %eax,%eax
  100518:	01 d0                	add    %edx,%eax
  10051a:	c1 e0 02             	shl    $0x2,%eax
  10051d:	03 45 08             	add    0x8(%ebp),%eax
  100520:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100524:	0f b6 c0             	movzbl %al,%eax
  100527:	3b 45 14             	cmp    0x14(%ebp),%eax
  10052a:	75 d7                	jne    100503 <stab_binsearch+0x113>
            /* do nothing */;
        *region_left = l;
  10052c:	8b 45 0c             	mov    0xc(%ebp),%eax
  10052f:	8b 55 fc             	mov    -0x4(%ebp),%edx
  100532:	89 10                	mov    %edx,(%eax)
    }
}
  100534:	c9                   	leave  
  100535:	c3                   	ret    

00100536 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
  100536:	55                   	push   %ebp
  100537:	89 e5                	mov    %esp,%ebp
  100539:	53                   	push   %ebx
  10053a:	83 ec 54             	sub    $0x54,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
  10053d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100540:	c7 00 2c 63 10 00    	movl   $0x10632c,(%eax)
    info->eip_line = 0;
  100546:	8b 45 0c             	mov    0xc(%ebp),%eax
  100549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
  100550:	8b 45 0c             	mov    0xc(%ebp),%eax
  100553:	c7 40 08 2c 63 10 00 	movl   $0x10632c,0x8(%eax)
    info->eip_fn_namelen = 9;
  10055a:	8b 45 0c             	mov    0xc(%ebp),%eax
  10055d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
  100564:	8b 45 0c             	mov    0xc(%ebp),%eax
  100567:	8b 55 08             	mov    0x8(%ebp),%edx
  10056a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
  10056d:	8b 45 0c             	mov    0xc(%ebp),%eax
  100570:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
  100577:	c7 45 f4 70 75 10 00 	movl   $0x107570,-0xc(%ebp)
    stab_end = __STAB_END__;
  10057e:	c7 45 f0 1c 26 11 00 	movl   $0x11261c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
  100585:	c7 45 ec 1d 26 11 00 	movl   $0x11261d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
  10058c:	c7 45 e8 53 50 11 00 	movl   $0x115053,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
  100593:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100596:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  100599:	76 0d                	jbe    1005a8 <debuginfo_eip+0x72>
  10059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10059e:	83 e8 01             	sub    $0x1,%eax
  1005a1:	0f b6 00             	movzbl (%eax),%eax
  1005a4:	84 c0                	test   %al,%al
  1005a6:	74 0a                	je     1005b2 <debuginfo_eip+0x7c>
        return -1;
  1005a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1005ad:	e9 9e 02 00 00       	jmp    100850 <debuginfo_eip+0x31a>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
  1005b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  1005b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1005bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005bf:	89 d1                	mov    %edx,%ecx
  1005c1:	29 c1                	sub    %eax,%ecx
  1005c3:	89 c8                	mov    %ecx,%eax
  1005c5:	c1 f8 02             	sar    $0x2,%eax
  1005c8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
  1005ce:	83 e8 01             	sub    $0x1,%eax
  1005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
  1005d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1005d7:	89 44 24 10          	mov    %eax,0x10(%esp)
  1005db:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
  1005e2:	00 
  1005e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
  1005e6:	89 44 24 08          	mov    %eax,0x8(%esp)
  1005ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  1005ed:	89 44 24 04          	mov    %eax,0x4(%esp)
  1005f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1005f4:	89 04 24             	mov    %eax,(%esp)
  1005f7:	e8 f4 fd ff ff       	call   1003f0 <stab_binsearch>
    if (lfile == 0)
  1005fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1005ff:	85 c0                	test   %eax,%eax
  100601:	75 0a                	jne    10060d <debuginfo_eip+0xd7>
        return -1;
  100603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  100608:	e9 43 02 00 00       	jmp    100850 <debuginfo_eip+0x31a>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
  10060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100610:	89 45 dc             	mov    %eax,-0x24(%ebp)
  100613:	8b 45 e0             	mov    -0x20(%ebp),%eax
  100616:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
  100619:	8b 45 08             	mov    0x8(%ebp),%eax
  10061c:	89 44 24 10          	mov    %eax,0x10(%esp)
  100620:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
  100627:	00 
  100628:	8d 45 d8             	lea    -0x28(%ebp),%eax
  10062b:	89 44 24 08          	mov    %eax,0x8(%esp)
  10062f:	8d 45 dc             	lea    -0x24(%ebp),%eax
  100632:	89 44 24 04          	mov    %eax,0x4(%esp)
  100636:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100639:	89 04 24             	mov    %eax,(%esp)
  10063c:	e8 af fd ff ff       	call   1003f0 <stab_binsearch>

    if (lfun <= rfun) {
  100641:	8b 55 dc             	mov    -0x24(%ebp),%edx
  100644:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100647:	39 c2                	cmp    %eax,%edx
  100649:	7f 72                	jg     1006bd <debuginfo_eip+0x187>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
  10064b:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10064e:	89 c2                	mov    %eax,%edx
  100650:	89 d0                	mov    %edx,%eax
  100652:	01 c0                	add    %eax,%eax
  100654:	01 d0                	add    %edx,%eax
  100656:	c1 e0 02             	shl    $0x2,%eax
  100659:	03 45 f4             	add    -0xc(%ebp),%eax
  10065c:	8b 10                	mov    (%eax),%edx
  10065e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  100661:	8b 45 ec             	mov    -0x14(%ebp),%eax
  100664:	89 cb                	mov    %ecx,%ebx
  100666:	29 c3                	sub    %eax,%ebx
  100668:	89 d8                	mov    %ebx,%eax
  10066a:	39 c2                	cmp    %eax,%edx
  10066c:	73 1e                	jae    10068c <debuginfo_eip+0x156>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
  10066e:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100671:	89 c2                	mov    %eax,%edx
  100673:	89 d0                	mov    %edx,%eax
  100675:	01 c0                	add    %eax,%eax
  100677:	01 d0                	add    %edx,%eax
  100679:	c1 e0 02             	shl    $0x2,%eax
  10067c:	03 45 f4             	add    -0xc(%ebp),%eax
  10067f:	8b 00                	mov    (%eax),%eax
  100681:	89 c2                	mov    %eax,%edx
  100683:	03 55 ec             	add    -0x14(%ebp),%edx
  100686:	8b 45 0c             	mov    0xc(%ebp),%eax
  100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
  10068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10068f:	89 c2                	mov    %eax,%edx
  100691:	89 d0                	mov    %edx,%eax
  100693:	01 c0                	add    %eax,%eax
  100695:	01 d0                	add    %edx,%eax
  100697:	c1 e0 02             	shl    $0x2,%eax
  10069a:	03 45 f4             	add    -0xc(%ebp),%eax
  10069d:	8b 50 08             	mov    0x8(%eax),%edx
  1006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
  1006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006a9:	8b 40 10             	mov    0x10(%eax),%eax
  1006ac:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
  1006af:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1006b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
  1006b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1006b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1006bb:	eb 15                	jmp    1006d2 <debuginfo_eip+0x19c>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
  1006bd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006c0:	8b 55 08             	mov    0x8(%ebp),%edx
  1006c3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
  1006c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1006c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
  1006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1006cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
  1006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006d5:	8b 40 08             	mov    0x8(%eax),%eax
  1006d8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
  1006df:	00 
  1006e0:	89 04 24             	mov    %eax,(%esp)
  1006e3:	e8 57 58 00 00       	call   105f3f <strfind>
  1006e8:	89 c2                	mov    %eax,%edx
  1006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006ed:	8b 40 08             	mov    0x8(%eax),%eax
  1006f0:	29 c2                	sub    %eax,%edx
  1006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
  1006f5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
  1006f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1006fb:	89 44 24 10          	mov    %eax,0x10(%esp)
  1006ff:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
  100706:	00 
  100707:	8d 45 d0             	lea    -0x30(%ebp),%eax
  10070a:	89 44 24 08          	mov    %eax,0x8(%esp)
  10070e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
  100711:	89 44 24 04          	mov    %eax,0x4(%esp)
  100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100718:	89 04 24             	mov    %eax,(%esp)
  10071b:	e8 d0 fc ff ff       	call   1003f0 <stab_binsearch>
    if (lline <= rline) {
  100720:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100723:	8b 45 d0             	mov    -0x30(%ebp),%eax
  100726:	39 c2                	cmp    %eax,%edx
  100728:	7f 20                	jg     10074a <debuginfo_eip+0x214>
        info->eip_line = stabs[rline].n_desc;
  10072a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10072d:	89 c2                	mov    %eax,%edx
  10072f:	89 d0                	mov    %edx,%eax
  100731:	01 c0                	add    %eax,%eax
  100733:	01 d0                	add    %edx,%eax
  100735:	c1 e0 02             	shl    $0x2,%eax
  100738:	03 45 f4             	add    -0xc(%ebp),%eax
  10073b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
  10073f:	0f b7 d0             	movzwl %ax,%edx
  100742:	8b 45 0c             	mov    0xc(%ebp),%eax
  100745:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  100748:	eb 13                	jmp    10075d <debuginfo_eip+0x227>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
  10074a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10074f:	e9 fc 00 00 00       	jmp    100850 <debuginfo_eip+0x31a>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
  100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100757:	83 e8 01             	sub    $0x1,%eax
  10075a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
  10075d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  100760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  100763:	39 c2                	cmp    %eax,%edx
  100765:	7c 4a                	jl     1007b1 <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
  100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10076a:	89 c2                	mov    %eax,%edx
  10076c:	89 d0                	mov    %edx,%eax
  10076e:	01 c0                	add    %eax,%eax
  100770:	01 d0                	add    %edx,%eax
  100772:	c1 e0 02             	shl    $0x2,%eax
  100775:	03 45 f4             	add    -0xc(%ebp),%eax
  100778:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  10077c:	3c 84                	cmp    $0x84,%al
  10077e:	74 31                	je     1007b1 <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
  100780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100783:	89 c2                	mov    %eax,%edx
  100785:	89 d0                	mov    %edx,%eax
  100787:	01 c0                	add    %eax,%eax
  100789:	01 d0                	add    %edx,%eax
  10078b:	c1 e0 02             	shl    $0x2,%eax
  10078e:	03 45 f4             	add    -0xc(%ebp),%eax
  100791:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100795:	3c 64                	cmp    $0x64,%al
  100797:	75 bb                	jne    100754 <debuginfo_eip+0x21e>
  100799:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10079c:	89 c2                	mov    %eax,%edx
  10079e:	89 d0                	mov    %edx,%eax
  1007a0:	01 c0                	add    %eax,%eax
  1007a2:	01 d0                	add    %edx,%eax
  1007a4:	c1 e0 02             	shl    $0x2,%eax
  1007a7:	03 45 f4             	add    -0xc(%ebp),%eax
  1007aa:	8b 40 08             	mov    0x8(%eax),%eax
  1007ad:	85 c0                	test   %eax,%eax
  1007af:	74 a3                	je     100754 <debuginfo_eip+0x21e>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
  1007b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1007b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1007b7:	39 c2                	cmp    %eax,%edx
  1007b9:	7c 40                	jl     1007fb <debuginfo_eip+0x2c5>
  1007bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007be:	89 c2                	mov    %eax,%edx
  1007c0:	89 d0                	mov    %edx,%eax
  1007c2:	01 c0                	add    %eax,%eax
  1007c4:	01 d0                	add    %edx,%eax
  1007c6:	c1 e0 02             	shl    $0x2,%eax
  1007c9:	03 45 f4             	add    -0xc(%ebp),%eax
  1007cc:	8b 10                	mov    (%eax),%edx
  1007ce:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1007d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1007d4:	89 cb                	mov    %ecx,%ebx
  1007d6:	29 c3                	sub    %eax,%ebx
  1007d8:	89 d8                	mov    %ebx,%eax
  1007da:	39 c2                	cmp    %eax,%edx
  1007dc:	73 1d                	jae    1007fb <debuginfo_eip+0x2c5>
        info->eip_file = stabstr + stabs[lline].n_strx;
  1007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  1007e1:	89 c2                	mov    %eax,%edx
  1007e3:	89 d0                	mov    %edx,%eax
  1007e5:	01 c0                	add    %eax,%eax
  1007e7:	01 d0                	add    %edx,%eax
  1007e9:	c1 e0 02             	shl    $0x2,%eax
  1007ec:	03 45 f4             	add    -0xc(%ebp),%eax
  1007ef:	8b 00                	mov    (%eax),%eax
  1007f1:	89 c2                	mov    %eax,%edx
  1007f3:	03 55 ec             	add    -0x14(%ebp),%edx
  1007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1007f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
  1007fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  100801:	39 c2                	cmp    %eax,%edx
  100803:	7d 46                	jge    10084b <debuginfo_eip+0x315>
        for (lline = lfun + 1;
  100805:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100808:	83 c0 01             	add    $0x1,%eax
  10080b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  10080e:	eb 18                	jmp    100828 <debuginfo_eip+0x2f2>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
  100810:	8b 45 0c             	mov    0xc(%ebp),%eax
  100813:	8b 40 14             	mov    0x14(%eax),%eax
  100816:	8d 50 01             	lea    0x1(%eax),%edx
  100819:	8b 45 0c             	mov    0xc(%ebp),%eax
  10081c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
  10081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100822:	83 c0 01             	add    $0x1,%eax
  100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100828:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
  10082e:	39 c2                	cmp    %eax,%edx
  100830:	7d 19                	jge    10084b <debuginfo_eip+0x315>
             lline < rfun && stabs[lline].n_type == N_PSYM;
  100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  100835:	89 c2                	mov    %eax,%edx
  100837:	89 d0                	mov    %edx,%eax
  100839:	01 c0                	add    %eax,%eax
  10083b:	01 d0                	add    %edx,%eax
  10083d:	c1 e0 02             	shl    $0x2,%eax
  100840:	03 45 f4             	add    -0xc(%ebp),%eax
  100843:	0f b6 40 04          	movzbl 0x4(%eax),%eax
  100847:	3c a0                	cmp    $0xa0,%al
  100849:	74 c5                	je     100810 <debuginfo_eip+0x2da>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
  10084b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100850:	83 c4 54             	add    $0x54,%esp
  100853:	5b                   	pop    %ebx
  100854:	5d                   	pop    %ebp
  100855:	c3                   	ret    

00100856 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
  100856:	55                   	push   %ebp
  100857:	89 e5                	mov    %esp,%ebp
  100859:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
  10085c:	c7 04 24 36 63 10 00 	movl   $0x106336,(%esp)
  100863:	e8 df fa ff ff       	call   100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
  100868:	c7 44 24 04 2c 00 10 	movl   $0x10002c,0x4(%esp)
  10086f:	00 
  100870:	c7 04 24 4f 63 10 00 	movl   $0x10634f,(%esp)
  100877:	e8 cb fa ff ff       	call   100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
  10087c:	c7 44 24 04 7f 62 10 	movl   $0x10627f,0x4(%esp)
  100883:	00 
  100884:	c7 04 24 67 63 10 00 	movl   $0x106367,(%esp)
  10088b:	e8 b7 fa ff ff       	call   100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
  100890:	c7 44 24 04 38 8a 11 	movl   $0x118a38,0x4(%esp)
  100897:	00 
  100898:	c7 04 24 7f 63 10 00 	movl   $0x10637f,(%esp)
  10089f:	e8 a3 fa ff ff       	call   100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
  1008a4:	c7 44 24 04 68 99 11 	movl   $0x119968,0x4(%esp)
  1008ab:	00 
  1008ac:	c7 04 24 97 63 10 00 	movl   $0x106397,(%esp)
  1008b3:	e8 8f fa ff ff       	call   100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
  1008b8:	b8 68 99 11 00       	mov    $0x119968,%eax
  1008bd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008c3:	b8 2c 00 10 00       	mov    $0x10002c,%eax
  1008c8:	89 d1                	mov    %edx,%ecx
  1008ca:	29 c1                	sub    %eax,%ecx
  1008cc:	89 c8                	mov    %ecx,%eax
  1008ce:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
  1008d4:	85 c0                	test   %eax,%eax
  1008d6:	0f 48 c2             	cmovs  %edx,%eax
  1008d9:	c1 f8 0a             	sar    $0xa,%eax
  1008dc:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008e0:	c7 04 24 b0 63 10 00 	movl   $0x1063b0,(%esp)
  1008e7:	e8 5b fa ff ff       	call   100347 <cprintf>
}
  1008ec:	c9                   	leave  
  1008ed:	c3                   	ret    

001008ee <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
  1008ee:	55                   	push   %ebp
  1008ef:	89 e5                	mov    %esp,%ebp
  1008f1:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
  1008f7:	8d 45 dc             	lea    -0x24(%ebp),%eax
  1008fa:	89 44 24 04          	mov    %eax,0x4(%esp)
  1008fe:	8b 45 08             	mov    0x8(%ebp),%eax
  100901:	89 04 24             	mov    %eax,(%esp)
  100904:	e8 2d fc ff ff       	call   100536 <debuginfo_eip>
  100909:	85 c0                	test   %eax,%eax
  10090b:	74 15                	je     100922 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
  10090d:	8b 45 08             	mov    0x8(%ebp),%eax
  100910:	89 44 24 04          	mov    %eax,0x4(%esp)
  100914:	c7 04 24 da 63 10 00 	movl   $0x1063da,(%esp)
  10091b:	e8 27 fa ff ff       	call   100347 <cprintf>
  100920:	eb 69                	jmp    10098b <print_debuginfo+0x9d>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100929:	eb 1a                	jmp    100945 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
  10092b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100931:	01 d0                	add    %edx,%eax
  100933:	0f b6 10             	movzbl (%eax),%edx
  100936:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  10093c:	03 45 f4             	add    -0xc(%ebp),%eax
  10093f:	88 10                	mov    %dl,(%eax)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
  100941:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100945:	8b 45 e8             	mov    -0x18(%ebp),%eax
  100948:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10094b:	7f de                	jg     10092b <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
  10094d:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
  100953:	03 45 f4             	add    -0xc(%ebp),%eax
  100956:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
  100959:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  10095c:	8b 55 08             	mov    0x8(%ebp),%edx
  10095f:	89 d1                	mov    %edx,%ecx
  100961:	29 c1                	sub    %eax,%ecx
  100963:	8b 55 e0             	mov    -0x20(%ebp),%edx
  100966:	8b 45 dc             	mov    -0x24(%ebp),%eax
  100969:	89 4c 24 10          	mov    %ecx,0x10(%esp)
                fnname, eip - info.eip_fn_addr);
  10096d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
  100973:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
  100977:	89 54 24 08          	mov    %edx,0x8(%esp)
  10097b:	89 44 24 04          	mov    %eax,0x4(%esp)
  10097f:	c7 04 24 f6 63 10 00 	movl   $0x1063f6,(%esp)
  100986:	e8 bc f9 ff ff       	call   100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
  10098b:	c9                   	leave  
  10098c:	c3                   	ret    

0010098d <read_eip>:

static __noinline uint32_t
read_eip(void) {
  10098d:	55                   	push   %ebp
  10098e:	89 e5                	mov    %esp,%ebp
  100990:	53                   	push   %ebx
  100991:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
  100994:	8b 5d 04             	mov    0x4(%ebp),%ebx
  100997:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return eip;
  10099a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10099d:	83 c4 10             	add    $0x10,%esp
  1009a0:	5b                   	pop    %ebx
  1009a1:	5d                   	pop    %ebp
  1009a2:	c3                   	ret    

001009a3 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
  1009a3:	55                   	push   %ebp
  1009a4:	89 e5                	mov    %esp,%ebp
  1009a6:	53                   	push   %ebx
  1009a7:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
  1009aa:	89 eb                	mov    %ebp,%ebx
  1009ac:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    return ebp;
  1009af:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
  1009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1009b5:	e8 d3 ff ff ff       	call   10098d <read_eip>
  1009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  1009bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
  1009c4:	e9 82 00 00 00       	jmp    100a4b <print_stackframe+0xa8>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
  1009c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1009cc:	89 44 24 08          	mov    %eax,0x8(%esp)
  1009d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009d3:	89 44 24 04          	mov    %eax,0x4(%esp)
  1009d7:	c7 04 24 08 64 10 00 	movl   $0x106408,(%esp)
  1009de:	e8 64 f9 ff ff       	call   100347 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
  1009e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1009e6:	83 c0 08             	add    $0x8,%eax
  1009e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
  1009ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
  1009f3:	eb 1f                	jmp    100a14 <print_stackframe+0x71>
            cprintf("0x%08x ", args[j]);
  1009f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1009f8:	c1 e0 02             	shl    $0x2,%eax
  1009fb:	03 45 e4             	add    -0x1c(%ebp),%eax
  1009fe:	8b 00                	mov    (%eax),%eax
  100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a04:	c7 04 24 24 64 10 00 	movl   $0x106424,(%esp)
  100a0b:	e8 37 f9 ff ff       	call   100347 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
  100a10:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
  100a14:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
  100a18:	7e db                	jle    1009f5 <print_stackframe+0x52>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
  100a1a:	c7 04 24 2c 64 10 00 	movl   $0x10642c,(%esp)
  100a21:	e8 21 f9 ff ff       	call   100347 <cprintf>
        print_debuginfo(eip - 1);
  100a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100a29:	83 e8 01             	sub    $0x1,%eax
  100a2c:	89 04 24             	mov    %eax,(%esp)
  100a2f:	e8 ba fe ff ff       	call   1008ee <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
  100a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a37:	83 c0 04             	add    $0x4,%eax
  100a3a:	8b 00                	mov    (%eax),%eax
  100a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
  100a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100a42:	8b 00                	mov    (%eax),%eax
  100a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
  100a47:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
  100a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100a4f:	74 0a                	je     100a5b <print_stackframe+0xb8>
  100a51:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
  100a55:	0f 8e 6e ff ff ff    	jle    1009c9 <print_stackframe+0x26>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
  100a5b:	83 c4 34             	add    $0x34,%esp
  100a5e:	5b                   	pop    %ebx
  100a5f:	5d                   	pop    %ebp
  100a60:	c3                   	ret    
  100a61:	00 00                	add    %al,(%eax)
	...

00100a64 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
  100a64:	55                   	push   %ebp
  100a65:	89 e5                	mov    %esp,%ebp
  100a67:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  100a6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a71:	eb 0d                	jmp    100a80 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
  100a73:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a74:	eb 0a                	jmp    100a80 <parse+0x1c>
            *buf ++ = '\0';
  100a76:	8b 45 08             	mov    0x8(%ebp),%eax
  100a79:	c6 00 00             	movb   $0x0,(%eax)
  100a7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
  100a80:	8b 45 08             	mov    0x8(%ebp),%eax
  100a83:	0f b6 00             	movzbl (%eax),%eax
  100a86:	84 c0                	test   %al,%al
  100a88:	74 1d                	je     100aa7 <parse+0x43>
  100a8a:	8b 45 08             	mov    0x8(%ebp),%eax
  100a8d:	0f b6 00             	movzbl (%eax),%eax
  100a90:	0f be c0             	movsbl %al,%eax
  100a93:	89 44 24 04          	mov    %eax,0x4(%esp)
  100a97:	c7 04 24 b0 64 10 00 	movl   $0x1064b0,(%esp)
  100a9e:	e8 69 54 00 00       	call   105f0c <strchr>
  100aa3:	85 c0                	test   %eax,%eax
  100aa5:	75 cf                	jne    100a76 <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
  100aa7:	8b 45 08             	mov    0x8(%ebp),%eax
  100aaa:	0f b6 00             	movzbl (%eax),%eax
  100aad:	84 c0                	test   %al,%al
  100aaf:	74 5e                	je     100b0f <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
  100ab1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
  100ab5:	75 14                	jne    100acb <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
  100ab7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
  100abe:	00 
  100abf:	c7 04 24 b5 64 10 00 	movl   $0x1064b5,(%esp)
  100ac6:	e8 7c f8 ff ff       	call   100347 <cprintf>
        }
        argv[argc ++] = buf;
  100acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ace:	c1 e0 02             	shl    $0x2,%eax
  100ad1:	03 45 0c             	add    0xc(%ebp),%eax
  100ad4:	8b 55 08             	mov    0x8(%ebp),%edx
  100ad7:	89 10                	mov    %edx,(%eax)
  100ad9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100add:	eb 04                	jmp    100ae3 <parse+0x7f>
            buf ++;
  100adf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
  100ae3:	8b 45 08             	mov    0x8(%ebp),%eax
  100ae6:	0f b6 00             	movzbl (%eax),%eax
  100ae9:	84 c0                	test   %al,%al
  100aeb:	74 86                	je     100a73 <parse+0xf>
  100aed:	8b 45 08             	mov    0x8(%ebp),%eax
  100af0:	0f b6 00             	movzbl (%eax),%eax
  100af3:	0f be c0             	movsbl %al,%eax
  100af6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100afa:	c7 04 24 b0 64 10 00 	movl   $0x1064b0,(%esp)
  100b01:	e8 06 54 00 00       	call   105f0c <strchr>
  100b06:	85 c0                	test   %eax,%eax
  100b08:	74 d5                	je     100adf <parse+0x7b>
            buf ++;
        }
    }
  100b0a:	e9 64 ff ff ff       	jmp    100a73 <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
  100b0f:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
  100b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  100b13:	c9                   	leave  
  100b14:	c3                   	ret    

00100b15 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
  100b15:	55                   	push   %ebp
  100b16:	89 e5                	mov    %esp,%ebp
  100b18:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
  100b1b:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b22:	8b 45 08             	mov    0x8(%ebp),%eax
  100b25:	89 04 24             	mov    %eax,(%esp)
  100b28:	e8 37 ff ff ff       	call   100a64 <parse>
  100b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
  100b30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  100b34:	75 0a                	jne    100b40 <runcmd+0x2b>
        return 0;
  100b36:	b8 00 00 00 00       	mov    $0x0,%eax
  100b3b:	e9 85 00 00 00       	jmp    100bc5 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100b47:	eb 5c                	jmp    100ba5 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
  100b49:	8b 4d b0             	mov    -0x50(%ebp),%ecx
  100b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b4f:	89 d0                	mov    %edx,%eax
  100b51:	01 c0                	add    %eax,%eax
  100b53:	01 d0                	add    %edx,%eax
  100b55:	c1 e0 02             	shl    $0x2,%eax
  100b58:	05 20 80 11 00       	add    $0x118020,%eax
  100b5d:	8b 00                	mov    (%eax),%eax
  100b5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  100b63:	89 04 24             	mov    %eax,(%esp)
  100b66:	e8 fc 52 00 00       	call   105e67 <strcmp>
  100b6b:	85 c0                	test   %eax,%eax
  100b6d:	75 32                	jne    100ba1 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
  100b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100b72:	89 d0                	mov    %edx,%eax
  100b74:	01 c0                	add    %eax,%eax
  100b76:	01 d0                	add    %edx,%eax
  100b78:	c1 e0 02             	shl    $0x2,%eax
  100b7b:	05 20 80 11 00       	add    $0x118020,%eax
  100b80:	8b 50 08             	mov    0x8(%eax),%edx
  100b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100b86:	8d 48 ff             	lea    -0x1(%eax),%ecx
  100b89:	8b 45 0c             	mov    0xc(%ebp),%eax
  100b8c:	89 44 24 08          	mov    %eax,0x8(%esp)
  100b90:	8d 45 b0             	lea    -0x50(%ebp),%eax
  100b93:	83 c0 04             	add    $0x4,%eax
  100b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  100b9a:	89 0c 24             	mov    %ecx,(%esp)
  100b9d:	ff d2                	call   *%edx
  100b9f:	eb 24                	jmp    100bc5 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100ba1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ba8:	83 f8 02             	cmp    $0x2,%eax
  100bab:	76 9c                	jbe    100b49 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
  100bad:	8b 45 b0             	mov    -0x50(%ebp),%eax
  100bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
  100bb4:	c7 04 24 d3 64 10 00 	movl   $0x1064d3,(%esp)
  100bbb:	e8 87 f7 ff ff       	call   100347 <cprintf>
    return 0;
  100bc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100bc5:	c9                   	leave  
  100bc6:	c3                   	ret    

00100bc7 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
  100bc7:	55                   	push   %ebp
  100bc8:	89 e5                	mov    %esp,%ebp
  100bca:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
  100bcd:	c7 04 24 ec 64 10 00 	movl   $0x1064ec,(%esp)
  100bd4:	e8 6e f7 ff ff       	call   100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
  100bd9:	c7 04 24 14 65 10 00 	movl   $0x106514,(%esp)
  100be0:	e8 62 f7 ff ff       	call   100347 <cprintf>

    if (tf != NULL) {
  100be5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100be9:	74 0e                	je     100bf9 <kmonitor+0x32>
        print_trapframe(tf);
  100beb:	8b 45 08             	mov    0x8(%ebp),%eax
  100bee:	89 04 24             	mov    %eax,(%esp)
  100bf1:	e8 e6 0e 00 00       	call   101adc <print_trapframe>
  100bf6:	eb 01                	jmp    100bf9 <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
  100bf8:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
  100bf9:	c7 04 24 39 65 10 00 	movl   $0x106539,(%esp)
  100c00:	e8 33 f6 ff ff       	call   100238 <readline>
  100c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
  100c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  100c0c:	74 ea                	je     100bf8 <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
  100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
  100c11:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c18:	89 04 24             	mov    %eax,(%esp)
  100c1b:	e8 f5 fe ff ff       	call   100b15 <runcmd>
  100c20:	85 c0                	test   %eax,%eax
  100c22:	79 d4                	jns    100bf8 <kmonitor+0x31>
                break;
  100c24:	90                   	nop
            }
        }
    }
}
  100c25:	c9                   	leave  
  100c26:	c3                   	ret    

00100c27 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
  100c27:	55                   	push   %ebp
  100c28:	89 e5                	mov    %esp,%ebp
  100c2a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  100c34:	eb 3f                	jmp    100c75 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
  100c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c39:	89 d0                	mov    %edx,%eax
  100c3b:	01 c0                	add    %eax,%eax
  100c3d:	01 d0                	add    %edx,%eax
  100c3f:	c1 e0 02             	shl    $0x2,%eax
  100c42:	05 20 80 11 00       	add    $0x118020,%eax
  100c47:	8b 48 04             	mov    0x4(%eax),%ecx
  100c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
  100c4d:	89 d0                	mov    %edx,%eax
  100c4f:	01 c0                	add    %eax,%eax
  100c51:	01 d0                	add    %edx,%eax
  100c53:	c1 e0 02             	shl    $0x2,%eax
  100c56:	05 20 80 11 00       	add    $0x118020,%eax
  100c5b:	8b 00                	mov    (%eax),%eax
  100c5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  100c61:	89 44 24 04          	mov    %eax,0x4(%esp)
  100c65:	c7 04 24 3d 65 10 00 	movl   $0x10653d,(%esp)
  100c6c:	e8 d6 f6 ff ff       	call   100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
  100c71:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  100c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100c78:	83 f8 02             	cmp    $0x2,%eax
  100c7b:	76 b9                	jbe    100c36 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
  100c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c82:	c9                   	leave  
  100c83:	c3                   	ret    

00100c84 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
  100c84:	55                   	push   %ebp
  100c85:	89 e5                	mov    %esp,%ebp
  100c87:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
  100c8a:	e8 c7 fb ff ff       	call   100856 <print_kerninfo>
    return 0;
  100c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100c94:	c9                   	leave  
  100c95:	c3                   	ret    

00100c96 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
  100c96:	55                   	push   %ebp
  100c97:	89 e5                	mov    %esp,%ebp
  100c99:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
  100c9c:	e8 02 fd ff ff       	call   1009a3 <print_stackframe>
    return 0;
  100ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100ca6:	c9                   	leave  
  100ca7:	c3                   	ret    

00100ca8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
  100ca8:	55                   	push   %ebp
  100ca9:	89 e5                	mov    %esp,%ebp
  100cab:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
  100cae:	a1 60 8e 11 00       	mov    0x118e60,%eax
  100cb3:	85 c0                	test   %eax,%eax
  100cb5:	75 4c                	jne    100d03 <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
  100cb7:	c7 05 60 8e 11 00 01 	movl   $0x1,0x118e60
  100cbe:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  100cc1:	8d 55 14             	lea    0x14(%ebp),%edx
  100cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100cc7:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
  100cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
  100ccc:	89 44 24 08          	mov    %eax,0x8(%esp)
  100cd0:	8b 45 08             	mov    0x8(%ebp),%eax
  100cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cd7:	c7 04 24 46 65 10 00 	movl   $0x106546,(%esp)
  100cde:	e8 64 f6 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
  100cea:	8b 45 10             	mov    0x10(%ebp),%eax
  100ced:	89 04 24             	mov    %eax,(%esp)
  100cf0:	e8 1f f6 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100cf5:	c7 04 24 62 65 10 00 	movl   $0x106562,(%esp)
  100cfc:	e8 46 f6 ff ff       	call   100347 <cprintf>
  100d01:	eb 01                	jmp    100d04 <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
  100d03:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
  100d04:	e8 31 0a 00 00       	call   10173a <intr_disable>
    while (1) {
        kmonitor(NULL);
  100d09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100d10:	e8 b2 fe ff ff       	call   100bc7 <kmonitor>
    }
  100d15:	eb f2                	jmp    100d09 <__panic+0x61>

00100d17 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
  100d17:	55                   	push   %ebp
  100d18:	89 e5                	mov    %esp,%ebp
  100d1a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  100d1d:	8d 55 14             	lea    0x14(%ebp),%edx
  100d20:	8d 45 f4             	lea    -0xc(%ebp),%eax
  100d23:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
  100d25:	8b 45 0c             	mov    0xc(%ebp),%eax
  100d28:	89 44 24 08          	mov    %eax,0x8(%esp)
  100d2c:	8b 45 08             	mov    0x8(%ebp),%eax
  100d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d33:	c7 04 24 64 65 10 00 	movl   $0x106564,(%esp)
  100d3a:	e8 08 f6 ff ff       	call   100347 <cprintf>
    vcprintf(fmt, ap);
  100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  100d42:	89 44 24 04          	mov    %eax,0x4(%esp)
  100d46:	8b 45 10             	mov    0x10(%ebp),%eax
  100d49:	89 04 24             	mov    %eax,(%esp)
  100d4c:	e8 c3 f5 ff ff       	call   100314 <vcprintf>
    cprintf("\n");
  100d51:	c7 04 24 62 65 10 00 	movl   $0x106562,(%esp)
  100d58:	e8 ea f5 ff ff       	call   100347 <cprintf>
    va_end(ap);
}
  100d5d:	c9                   	leave  
  100d5e:	c3                   	ret    

00100d5f <is_kernel_panic>:

bool
is_kernel_panic(void) {
  100d5f:	55                   	push   %ebp
  100d60:	89 e5                	mov    %esp,%ebp
    return is_panic;
  100d62:	a1 60 8e 11 00       	mov    0x118e60,%eax
}
  100d67:	5d                   	pop    %ebp
  100d68:	c3                   	ret    
  100d69:	00 00                	add    %al,(%eax)
	...

00100d6c <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
  100d6c:	55                   	push   %ebp
  100d6d:	89 e5                	mov    %esp,%ebp
  100d6f:	83 ec 28             	sub    $0x28,%esp
  100d72:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
  100d78:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100d7c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100d80:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100d84:	ee                   	out    %al,(%dx)
  100d85:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
  100d8b:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
  100d8f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100d93:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100d97:	ee                   	out    %al,(%dx)
  100d98:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
  100d9e:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
  100da2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100da6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100daa:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
  100dab:	c7 05 4c 99 11 00 00 	movl   $0x0,0x11994c
  100db2:	00 00 00 

    cprintf("++ setup timer interrupts\n");
  100db5:	c7 04 24 82 65 10 00 	movl   $0x106582,(%esp)
  100dbc:	e8 86 f5 ff ff       	call   100347 <cprintf>
    pic_enable(IRQ_TIMER);
  100dc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  100dc8:	e8 cb 09 00 00       	call   101798 <pic_enable>
}
  100dcd:	c9                   	leave  
  100dce:	c3                   	ret    
	...

00100dd0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  100dd0:	55                   	push   %ebp
  100dd1:	89 e5                	mov    %esp,%ebp
  100dd3:	53                   	push   %ebx
  100dd4:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  100dd7:	9c                   	pushf  
  100dd8:	5b                   	pop    %ebx
  100dd9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
  100ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  100ddf:	25 00 02 00 00       	and    $0x200,%eax
  100de4:	85 c0                	test   %eax,%eax
  100de6:	74 0c                	je     100df4 <__intr_save+0x24>
        intr_disable();
  100de8:	e8 4d 09 00 00       	call   10173a <intr_disable>
        return 1;
  100ded:	b8 01 00 00 00       	mov    $0x1,%eax
  100df2:	eb 05                	jmp    100df9 <__intr_save+0x29>
    }
    return 0;
  100df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
  100df9:	83 c4 14             	add    $0x14,%esp
  100dfc:	5b                   	pop    %ebx
  100dfd:	5d                   	pop    %ebp
  100dfe:	c3                   	ret    

00100dff <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  100dff:	55                   	push   %ebp
  100e00:	89 e5                	mov    %esp,%ebp
  100e02:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  100e05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  100e09:	74 05                	je     100e10 <__intr_restore+0x11>
        intr_enable();
  100e0b:	e8 24 09 00 00       	call   101734 <intr_enable>
    }
}
  100e10:	c9                   	leave  
  100e11:	c3                   	ret    

00100e12 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
  100e12:	55                   	push   %ebp
  100e13:	89 e5                	mov    %esp,%ebp
  100e15:	53                   	push   %ebx
  100e16:	83 ec 14             	sub    $0x14,%esp
  100e19:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e1f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  100e23:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e27:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e2b:	ec                   	in     (%dx),%al
  100e2c:	89 c3                	mov    %eax,%ebx
  100e2e:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
  100e31:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e37:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100e3b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e3f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e43:	ec                   	in     (%dx),%al
  100e44:	89 c3                	mov    %eax,%ebx
  100e46:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  100e49:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e4f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100e53:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e57:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e5b:	ec                   	in     (%dx),%al
  100e5c:	89 c3                	mov    %eax,%ebx
  100e5e:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
  100e61:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100e67:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100e6b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  100e6f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100e73:	ec                   	in     (%dx),%al
  100e74:	89 c3                	mov    %eax,%ebx
  100e76:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
  100e79:	83 c4 14             	add    $0x14,%esp
  100e7c:	5b                   	pop    %ebx
  100e7d:	5d                   	pop    %ebp
  100e7e:	c3                   	ret    

00100e7f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
  100e7f:	55                   	push   %ebp
  100e80:	89 e5                	mov    %esp,%ebp
  100e82:	53                   	push   %ebx
  100e83:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
  100e86:	c7 45 f8 00 80 0b c0 	movl   $0xc00b8000,-0x8(%ebp)
    uint16_t was = *cp;
  100e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e90:	0f b7 00             	movzwl (%eax),%eax
  100e93:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
  100e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100e9a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
  100e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100ea2:	0f b7 00             	movzwl (%eax),%eax
  100ea5:	66 3d 5a a5          	cmp    $0xa55a,%ax
  100ea9:	74 12                	je     100ebd <cga_init+0x3e>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
  100eab:	c7 45 f8 00 00 0b c0 	movl   $0xc00b0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
  100eb2:	66 c7 05 86 8e 11 00 	movw   $0x3b4,0x118e86
  100eb9:	b4 03 
  100ebb:	eb 13                	jmp    100ed0 <cga_init+0x51>
    } else {
        *cp = was;
  100ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100ec0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100ec4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
  100ec7:	66 c7 05 86 8e 11 00 	movw   $0x3d4,0x118e86
  100ece:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
  100ed0:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100ed7:	0f b7 c0             	movzwl %ax,%eax
  100eda:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
  100ede:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100ee2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100ee6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100eea:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
  100eeb:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100ef2:	83 c0 01             	add    $0x1,%eax
  100ef5:	0f b7 c0             	movzwl %ax,%eax
  100ef8:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100efc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100f00:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100f04:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f08:	ec                   	in     (%dx),%al
  100f09:	89 c3                	mov    %eax,%ebx
  100f0b:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
  100f0e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100f12:	0f b6 c0             	movzbl %al,%eax
  100f15:	c1 e0 08             	shl    $0x8,%eax
  100f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
  100f1b:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100f22:	0f b7 c0             	movzwl %ax,%eax
  100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
  100f29:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f2d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100f31:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100f35:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
  100f36:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  100f3d:	83 c0 01             	add    $0x1,%eax
  100f40:	0f b7 c0             	movzwl %ax,%eax
  100f43:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  100f47:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100f4b:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  100f4f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  100f53:	ec                   	in     (%dx),%al
  100f54:	89 c3                	mov    %eax,%ebx
  100f56:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
  100f59:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100f5d:	0f b6 c0             	movzbl %al,%eax
  100f60:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
  100f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
  100f66:	a3 80 8e 11 00       	mov    %eax,0x118e80
    crt_pos = pos;
  100f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  100f6e:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
}
  100f74:	83 c4 24             	add    $0x24,%esp
  100f77:	5b                   	pop    %ebx
  100f78:	5d                   	pop    %ebp
  100f79:	c3                   	ret    

00100f7a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
  100f7a:	55                   	push   %ebp
  100f7b:	89 e5                	mov    %esp,%ebp
  100f7d:	53                   	push   %ebx
  100f7e:	83 ec 54             	sub    $0x54,%esp
  100f81:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
  100f87:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  100f8b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  100f8f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  100f93:	ee                   	out    %al,(%dx)
  100f94:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
  100f9a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
  100f9e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  100fa2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  100fa6:	ee                   	out    %al,(%dx)
  100fa7:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
  100fad:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
  100fb1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  100fb5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  100fb9:	ee                   	out    %al,(%dx)
  100fba:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
  100fc0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
  100fc4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  100fc8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  100fcc:	ee                   	out    %al,(%dx)
  100fcd:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
  100fd3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
  100fd7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  100fdb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  100fdf:	ee                   	out    %al,(%dx)
  100fe0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
  100fe6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
  100fea:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  100fee:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  100ff2:	ee                   	out    %al,(%dx)
  100ff3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
  100ff9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
  100ffd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101001:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101005:	ee                   	out    %al,(%dx)
  101006:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10100c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  101010:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  101014:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  101018:	ec                   	in     (%dx),%al
  101019:	89 c3                	mov    %eax,%ebx
  10101b:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
  10101e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
  101022:	3c ff                	cmp    $0xff,%al
  101024:	0f 95 c0             	setne  %al
  101027:	0f b6 c0             	movzbl %al,%eax
  10102a:	a3 88 8e 11 00       	mov    %eax,0x118e88
  10102f:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101035:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  101039:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  10103d:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  101041:	ec                   	in     (%dx),%al
  101042:	89 c3                	mov    %eax,%ebx
  101044:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
  101047:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10104d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  101051:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
  101055:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
  101059:	ec                   	in     (%dx),%al
  10105a:	89 c3                	mov    %eax,%ebx
  10105c:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
  10105f:	a1 88 8e 11 00       	mov    0x118e88,%eax
  101064:	85 c0                	test   %eax,%eax
  101066:	74 0c                	je     101074 <serial_init+0xfa>
        pic_enable(IRQ_COM1);
  101068:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  10106f:	e8 24 07 00 00       	call   101798 <pic_enable>
    }
}
  101074:	83 c4 54             	add    $0x54,%esp
  101077:	5b                   	pop    %ebx
  101078:	5d                   	pop    %ebp
  101079:	c3                   	ret    

0010107a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
  10107a:	55                   	push   %ebp
  10107b:	89 e5                	mov    %esp,%ebp
  10107d:	53                   	push   %ebx
  10107e:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  101081:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  101088:	eb 09                	jmp    101093 <lpt_putc_sub+0x19>
        delay();
  10108a:	e8 83 fd ff ff       	call   100e12 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
  10108f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101093:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
  101099:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10109d:	66 89 55 da          	mov    %dx,-0x26(%ebp)
  1010a1:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  1010a5:	ec                   	in     (%dx),%al
  1010a6:	89 c3                	mov    %eax,%ebx
  1010a8:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  1010ab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  1010af:	84 c0                	test   %al,%al
  1010b1:	78 09                	js     1010bc <lpt_putc_sub+0x42>
  1010b3:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  1010ba:	7e ce                	jle    10108a <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
  1010bc:	8b 45 08             	mov    0x8(%ebp),%eax
  1010bf:	0f b6 c0             	movzbl %al,%eax
  1010c2:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
  1010c8:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  1010cb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1010cf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1010d3:	ee                   	out    %al,(%dx)
  1010d4:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
  1010da:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
  1010de:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1010e2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1010e6:	ee                   	out    %al,(%dx)
  1010e7:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
  1010ed:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
  1010f1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1010f5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1010f9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
  1010fa:	83 c4 24             	add    $0x24,%esp
  1010fd:	5b                   	pop    %ebx
  1010fe:	5d                   	pop    %ebp
  1010ff:	c3                   	ret    

00101100 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
  101100:	55                   	push   %ebp
  101101:	89 e5                	mov    %esp,%ebp
  101103:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101106:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  10110a:	74 0d                	je     101119 <lpt_putc+0x19>
        lpt_putc_sub(c);
  10110c:	8b 45 08             	mov    0x8(%ebp),%eax
  10110f:	89 04 24             	mov    %eax,(%esp)
  101112:	e8 63 ff ff ff       	call   10107a <lpt_putc_sub>
  101117:	eb 24                	jmp    10113d <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
  101119:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101120:	e8 55 ff ff ff       	call   10107a <lpt_putc_sub>
        lpt_putc_sub(' ');
  101125:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  10112c:	e8 49 ff ff ff       	call   10107a <lpt_putc_sub>
        lpt_putc_sub('\b');
  101131:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  101138:	e8 3d ff ff ff       	call   10107a <lpt_putc_sub>
    }
}
  10113d:	c9                   	leave  
  10113e:	c3                   	ret    

0010113f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
  10113f:	55                   	push   %ebp
  101140:	89 e5                	mov    %esp,%ebp
  101142:	53                   	push   %ebx
  101143:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
  101146:	8b 45 08             	mov    0x8(%ebp),%eax
  101149:	b0 00                	mov    $0x0,%al
  10114b:	85 c0                	test   %eax,%eax
  10114d:	75 07                	jne    101156 <cga_putc+0x17>
        c |= 0x0700;
  10114f:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
  101156:	8b 45 08             	mov    0x8(%ebp),%eax
  101159:	25 ff 00 00 00       	and    $0xff,%eax
  10115e:	83 f8 0a             	cmp    $0xa,%eax
  101161:	74 4e                	je     1011b1 <cga_putc+0x72>
  101163:	83 f8 0d             	cmp    $0xd,%eax
  101166:	74 59                	je     1011c1 <cga_putc+0x82>
  101168:	83 f8 08             	cmp    $0x8,%eax
  10116b:	0f 85 8c 00 00 00    	jne    1011fd <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
  101171:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101178:	66 85 c0             	test   %ax,%ax
  10117b:	0f 84 a1 00 00 00    	je     101222 <cga_putc+0xe3>
            crt_pos --;
  101181:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101188:	83 e8 01             	sub    $0x1,%eax
  10118b:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
  101191:	a1 80 8e 11 00       	mov    0x118e80,%eax
  101196:	0f b7 15 84 8e 11 00 	movzwl 0x118e84,%edx
  10119d:	0f b7 d2             	movzwl %dx,%edx
  1011a0:	01 d2                	add    %edx,%edx
  1011a2:	01 c2                	add    %eax,%edx
  1011a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1011a7:	b0 00                	mov    $0x0,%al
  1011a9:	83 c8 20             	or     $0x20,%eax
  1011ac:	66 89 02             	mov    %ax,(%edx)
        }
        break;
  1011af:	eb 71                	jmp    101222 <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
  1011b1:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  1011b8:	83 c0 50             	add    $0x50,%eax
  1011bb:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
  1011c1:	0f b7 1d 84 8e 11 00 	movzwl 0x118e84,%ebx
  1011c8:	0f b7 0d 84 8e 11 00 	movzwl 0x118e84,%ecx
  1011cf:	0f b7 c1             	movzwl %cx,%eax
  1011d2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
  1011d8:	c1 e8 10             	shr    $0x10,%eax
  1011db:	89 c2                	mov    %eax,%edx
  1011dd:	66 c1 ea 06          	shr    $0x6,%dx
  1011e1:	89 d0                	mov    %edx,%eax
  1011e3:	c1 e0 02             	shl    $0x2,%eax
  1011e6:	01 d0                	add    %edx,%eax
  1011e8:	c1 e0 04             	shl    $0x4,%eax
  1011eb:	89 ca                	mov    %ecx,%edx
  1011ed:	66 29 c2             	sub    %ax,%dx
  1011f0:	89 d8                	mov    %ebx,%eax
  1011f2:	66 29 d0             	sub    %dx,%ax
  1011f5:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
        break;
  1011fb:	eb 26                	jmp    101223 <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
  1011fd:	8b 15 80 8e 11 00    	mov    0x118e80,%edx
  101203:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  10120a:	0f b7 c8             	movzwl %ax,%ecx
  10120d:	01 c9                	add    %ecx,%ecx
  10120f:	01 d1                	add    %edx,%ecx
  101211:	8b 55 08             	mov    0x8(%ebp),%edx
  101214:	66 89 11             	mov    %dx,(%ecx)
  101217:	83 c0 01             	add    $0x1,%eax
  10121a:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
        break;
  101220:	eb 01                	jmp    101223 <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
  101222:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
  101223:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  10122a:	66 3d cf 07          	cmp    $0x7cf,%ax
  10122e:	76 5b                	jbe    10128b <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
  101230:	a1 80 8e 11 00       	mov    0x118e80,%eax
  101235:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
  10123b:	a1 80 8e 11 00       	mov    0x118e80,%eax
  101240:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
  101247:	00 
  101248:	89 54 24 04          	mov    %edx,0x4(%esp)
  10124c:	89 04 24             	mov    %eax,(%esp)
  10124f:	e8 be 4e 00 00       	call   106112 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  101254:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
  10125b:	eb 15                	jmp    101272 <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
  10125d:	a1 80 8e 11 00       	mov    0x118e80,%eax
  101262:	8b 55 f4             	mov    -0xc(%ebp),%edx
  101265:	01 d2                	add    %edx,%edx
  101267:	01 d0                	add    %edx,%eax
  101269:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
  10126e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101272:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
  101279:	7e e2                	jle    10125d <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
  10127b:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  101282:	83 e8 50             	sub    $0x50,%eax
  101285:	66 a3 84 8e 11 00    	mov    %ax,0x118e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
  10128b:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  101292:	0f b7 c0             	movzwl %ax,%eax
  101295:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
  101299:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
  10129d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  1012a1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  1012a5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
  1012a6:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  1012ad:	66 c1 e8 08          	shr    $0x8,%ax
  1012b1:	0f b6 c0             	movzbl %al,%eax
  1012b4:	0f b7 15 86 8e 11 00 	movzwl 0x118e86,%edx
  1012bb:	83 c2 01             	add    $0x1,%edx
  1012be:	0f b7 d2             	movzwl %dx,%edx
  1012c1:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
  1012c5:	88 45 ed             	mov    %al,-0x13(%ebp)
  1012c8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  1012cc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  1012d0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
  1012d1:	0f b7 05 86 8e 11 00 	movzwl 0x118e86,%eax
  1012d8:	0f b7 c0             	movzwl %ax,%eax
  1012db:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
  1012df:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
  1012e3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  1012e7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  1012eb:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
  1012ec:	0f b7 05 84 8e 11 00 	movzwl 0x118e84,%eax
  1012f3:	0f b6 c0             	movzbl %al,%eax
  1012f6:	0f b7 15 86 8e 11 00 	movzwl 0x118e86,%edx
  1012fd:	83 c2 01             	add    $0x1,%edx
  101300:	0f b7 d2             	movzwl %dx,%edx
  101303:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
  101307:	88 45 e5             	mov    %al,-0x1b(%ebp)
  10130a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10130e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101312:	ee                   	out    %al,(%dx)
}
  101313:	83 c4 34             	add    $0x34,%esp
  101316:	5b                   	pop    %ebx
  101317:	5d                   	pop    %ebp
  101318:	c3                   	ret    

00101319 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
  101319:	55                   	push   %ebp
  10131a:	89 e5                	mov    %esp,%ebp
  10131c:	53                   	push   %ebx
  10131d:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  101320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
  101327:	eb 09                	jmp    101332 <serial_putc_sub+0x19>
        delay();
  101329:	e8 e4 fa ff ff       	call   100e12 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
  10132e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
  101332:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101338:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  10133c:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  101340:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101344:	ec                   	in     (%dx),%al
  101345:	89 c3                	mov    %eax,%ebx
  101347:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  10134a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  10134e:	0f b6 c0             	movzbl %al,%eax
  101351:	83 e0 20             	and    $0x20,%eax
  101354:	85 c0                	test   %eax,%eax
  101356:	75 09                	jne    101361 <serial_putc_sub+0x48>
  101358:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
  10135f:	7e c8                	jle    101329 <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
  101361:	8b 45 08             	mov    0x8(%ebp),%eax
  101364:	0f b6 c0             	movzbl %al,%eax
  101367:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
  10136d:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101370:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101374:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101378:	ee                   	out    %al,(%dx)
}
  101379:	83 c4 14             	add    $0x14,%esp
  10137c:	5b                   	pop    %ebx
  10137d:	5d                   	pop    %ebp
  10137e:	c3                   	ret    

0010137f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
  10137f:	55                   	push   %ebp
  101380:	89 e5                	mov    %esp,%ebp
  101382:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
  101385:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
  101389:	74 0d                	je     101398 <serial_putc+0x19>
        serial_putc_sub(c);
  10138b:	8b 45 08             	mov    0x8(%ebp),%eax
  10138e:	89 04 24             	mov    %eax,(%esp)
  101391:	e8 83 ff ff ff       	call   101319 <serial_putc_sub>
  101396:	eb 24                	jmp    1013bc <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
  101398:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  10139f:	e8 75 ff ff ff       	call   101319 <serial_putc_sub>
        serial_putc_sub(' ');
  1013a4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  1013ab:	e8 69 ff ff ff       	call   101319 <serial_putc_sub>
        serial_putc_sub('\b');
  1013b0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
  1013b7:	e8 5d ff ff ff       	call   101319 <serial_putc_sub>
    }
}
  1013bc:	c9                   	leave  
  1013bd:	c3                   	ret    

001013be <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
  1013be:	55                   	push   %ebp
  1013bf:	89 e5                	mov    %esp,%ebp
  1013c1:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
  1013c4:	eb 32                	jmp    1013f8 <cons_intr+0x3a>
        if (c != 0) {
  1013c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1013ca:	74 2c                	je     1013f8 <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
  1013cc:	a1 a4 90 11 00       	mov    0x1190a4,%eax
  1013d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1013d4:	88 90 a0 8e 11 00    	mov    %dl,0x118ea0(%eax)
  1013da:	83 c0 01             	add    $0x1,%eax
  1013dd:	a3 a4 90 11 00       	mov    %eax,0x1190a4
            if (cons.wpos == CONSBUFSIZE) {
  1013e2:	a1 a4 90 11 00       	mov    0x1190a4,%eax
  1013e7:	3d 00 02 00 00       	cmp    $0x200,%eax
  1013ec:	75 0a                	jne    1013f8 <cons_intr+0x3a>
                cons.wpos = 0;
  1013ee:	c7 05 a4 90 11 00 00 	movl   $0x0,0x1190a4
  1013f5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
  1013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  1013fb:	ff d0                	call   *%eax
  1013fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  101400:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
  101404:	75 c0                	jne    1013c6 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
  101406:	c9                   	leave  
  101407:	c3                   	ret    

00101408 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
  101408:	55                   	push   %ebp
  101409:	89 e5                	mov    %esp,%ebp
  10140b:	53                   	push   %ebx
  10140c:	83 ec 14             	sub    $0x14,%esp
  10140f:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101415:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101419:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10141d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  101421:	ec                   	in     (%dx),%al
  101422:	89 c3                	mov    %eax,%ebx
  101424:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
  101427:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
  10142b:	0f b6 c0             	movzbl %al,%eax
  10142e:	83 e0 01             	and    $0x1,%eax
  101431:	85 c0                	test   %eax,%eax
  101433:	75 07                	jne    10143c <serial_proc_data+0x34>
        return -1;
  101435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  10143a:	eb 32                	jmp    10146e <serial_proc_data+0x66>
  10143c:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  101442:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101446:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
  10144a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10144e:	ec                   	in     (%dx),%al
  10144f:	89 c3                	mov    %eax,%ebx
  101451:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
  101454:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
  101458:	0f b6 c0             	movzbl %al,%eax
  10145b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
  10145e:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
  101462:	75 07                	jne    10146b <serial_proc_data+0x63>
        c = '\b';
  101464:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
  10146b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  10146e:	83 c4 14             	add    $0x14,%esp
  101471:	5b                   	pop    %ebx
  101472:	5d                   	pop    %ebp
  101473:	c3                   	ret    

00101474 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
  101474:	55                   	push   %ebp
  101475:	89 e5                	mov    %esp,%ebp
  101477:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
  10147a:	a1 88 8e 11 00       	mov    0x118e88,%eax
  10147f:	85 c0                	test   %eax,%eax
  101481:	74 0c                	je     10148f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
  101483:	c7 04 24 08 14 10 00 	movl   $0x101408,(%esp)
  10148a:	e8 2f ff ff ff       	call   1013be <cons_intr>
    }
}
  10148f:	c9                   	leave  
  101490:	c3                   	ret    

00101491 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
  101491:	55                   	push   %ebp
  101492:	89 e5                	mov    %esp,%ebp
  101494:	53                   	push   %ebx
  101495:	83 ec 44             	sub    $0x44,%esp
  101498:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  10149e:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
  1014a2:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  1014a6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1014aa:	ec                   	in     (%dx),%al
  1014ab:	89 c3                	mov    %eax,%ebx
  1014ad:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
  1014b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
  1014b4:	0f b6 c0             	movzbl %al,%eax
  1014b7:	83 e0 01             	and    $0x1,%eax
  1014ba:	85 c0                	test   %eax,%eax
  1014bc:	75 0a                	jne    1014c8 <kbd_proc_data+0x37>
        return -1;
  1014be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
  1014c3:	e9 61 01 00 00       	jmp    101629 <kbd_proc_data+0x198>
  1014c8:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
  1014ce:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
  1014d2:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
  1014d6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1014da:	ec                   	in     (%dx),%al
  1014db:	89 c3                	mov    %eax,%ebx
  1014dd:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
  1014e0:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
  1014e4:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
  1014e7:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
  1014eb:	75 17                	jne    101504 <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
  1014ed:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1014f2:	83 c8 40             	or     $0x40,%eax
  1014f5:	a3 a8 90 11 00       	mov    %eax,0x1190a8
        return 0;
  1014fa:	b8 00 00 00 00       	mov    $0x0,%eax
  1014ff:	e9 25 01 00 00       	jmp    101629 <kbd_proc_data+0x198>
    } else if (data & 0x80) {
  101504:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101508:	84 c0                	test   %al,%al
  10150a:	79 47                	jns    101553 <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
  10150c:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101511:	83 e0 40             	and    $0x40,%eax
  101514:	85 c0                	test   %eax,%eax
  101516:	75 09                	jne    101521 <kbd_proc_data+0x90>
  101518:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10151c:	83 e0 7f             	and    $0x7f,%eax
  10151f:	eb 04                	jmp    101525 <kbd_proc_data+0x94>
  101521:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101525:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
  101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10152c:	0f b6 80 60 80 11 00 	movzbl 0x118060(%eax),%eax
  101533:	83 c8 40             	or     $0x40,%eax
  101536:	0f b6 c0             	movzbl %al,%eax
  101539:	f7 d0                	not    %eax
  10153b:	89 c2                	mov    %eax,%edx
  10153d:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101542:	21 d0                	and    %edx,%eax
  101544:	a3 a8 90 11 00       	mov    %eax,0x1190a8
        return 0;
  101549:	b8 00 00 00 00       	mov    $0x0,%eax
  10154e:	e9 d6 00 00 00       	jmp    101629 <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
  101553:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101558:	83 e0 40             	and    $0x40,%eax
  10155b:	85 c0                	test   %eax,%eax
  10155d:	74 11                	je     101570 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
  10155f:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
  101563:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101568:	83 e0 bf             	and    $0xffffffbf,%eax
  10156b:	a3 a8 90 11 00       	mov    %eax,0x1190a8
    }

    shift |= shiftcode[data];
  101570:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  101574:	0f b6 80 60 80 11 00 	movzbl 0x118060(%eax),%eax
  10157b:	0f b6 d0             	movzbl %al,%edx
  10157e:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  101583:	09 d0                	or     %edx,%eax
  101585:	a3 a8 90 11 00       	mov    %eax,0x1190a8
    shift ^= togglecode[data];
  10158a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  10158e:	0f b6 80 60 81 11 00 	movzbl 0x118160(%eax),%eax
  101595:	0f b6 d0             	movzbl %al,%edx
  101598:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  10159d:	31 d0                	xor    %edx,%eax
  10159f:	a3 a8 90 11 00       	mov    %eax,0x1190a8

    c = charcode[shift & (CTL | SHIFT)][data];
  1015a4:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1015a9:	83 e0 03             	and    $0x3,%eax
  1015ac:	8b 14 85 60 85 11 00 	mov    0x118560(,%eax,4),%edx
  1015b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
  1015b7:	01 d0                	add    %edx,%eax
  1015b9:	0f b6 00             	movzbl (%eax),%eax
  1015bc:	0f b6 c0             	movzbl %al,%eax
  1015bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
  1015c2:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1015c7:	83 e0 08             	and    $0x8,%eax
  1015ca:	85 c0                	test   %eax,%eax
  1015cc:	74 22                	je     1015f0 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
  1015ce:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
  1015d2:	7e 0c                	jle    1015e0 <kbd_proc_data+0x14f>
  1015d4:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
  1015d8:	7f 06                	jg     1015e0 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
  1015da:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
  1015de:	eb 10                	jmp    1015f0 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
  1015e0:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
  1015e4:	7e 0a                	jle    1015f0 <kbd_proc_data+0x15f>
  1015e6:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
  1015ea:	7f 04                	jg     1015f0 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
  1015ec:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
  1015f0:	a1 a8 90 11 00       	mov    0x1190a8,%eax
  1015f5:	f7 d0                	not    %eax
  1015f7:	83 e0 06             	and    $0x6,%eax
  1015fa:	85 c0                	test   %eax,%eax
  1015fc:	75 28                	jne    101626 <kbd_proc_data+0x195>
  1015fe:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
  101605:	75 1f                	jne    101626 <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
  101607:	c7 04 24 9d 65 10 00 	movl   $0x10659d,(%esp)
  10160e:	e8 34 ed ff ff       	call   100347 <cprintf>
  101613:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
  101619:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  10161d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
  101621:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
  101625:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
  101626:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101629:	83 c4 44             	add    $0x44,%esp
  10162c:	5b                   	pop    %ebx
  10162d:	5d                   	pop    %ebp
  10162e:	c3                   	ret    

0010162f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
  10162f:	55                   	push   %ebp
  101630:	89 e5                	mov    %esp,%ebp
  101632:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
  101635:	c7 04 24 91 14 10 00 	movl   $0x101491,(%esp)
  10163c:	e8 7d fd ff ff       	call   1013be <cons_intr>
}
  101641:	c9                   	leave  
  101642:	c3                   	ret    

00101643 <kbd_init>:

static void
kbd_init(void) {
  101643:	55                   	push   %ebp
  101644:	89 e5                	mov    %esp,%ebp
  101646:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
  101649:	e8 e1 ff ff ff       	call   10162f <kbd_intr>
    pic_enable(IRQ_KBD);
  10164e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  101655:	e8 3e 01 00 00       	call   101798 <pic_enable>
}
  10165a:	c9                   	leave  
  10165b:	c3                   	ret    

0010165c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
  10165c:	55                   	push   %ebp
  10165d:	89 e5                	mov    %esp,%ebp
  10165f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
  101662:	e8 18 f8 ff ff       	call   100e7f <cga_init>
    serial_init();
  101667:	e8 0e f9 ff ff       	call   100f7a <serial_init>
    kbd_init();
  10166c:	e8 d2 ff ff ff       	call   101643 <kbd_init>
    if (!serial_exists) {
  101671:	a1 88 8e 11 00       	mov    0x118e88,%eax
  101676:	85 c0                	test   %eax,%eax
  101678:	75 0c                	jne    101686 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
  10167a:	c7 04 24 a9 65 10 00 	movl   $0x1065a9,(%esp)
  101681:	e8 c1 ec ff ff       	call   100347 <cprintf>
    }
}
  101686:	c9                   	leave  
  101687:	c3                   	ret    

00101688 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
  101688:	55                   	push   %ebp
  101689:	89 e5                	mov    %esp,%ebp
  10168b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  10168e:	e8 3d f7 ff ff       	call   100dd0 <__intr_save>
  101693:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
  101696:	8b 45 08             	mov    0x8(%ebp),%eax
  101699:	89 04 24             	mov    %eax,(%esp)
  10169c:	e8 5f fa ff ff       	call   101100 <lpt_putc>
        cga_putc(c);
  1016a1:	8b 45 08             	mov    0x8(%ebp),%eax
  1016a4:	89 04 24             	mov    %eax,(%esp)
  1016a7:	e8 93 fa ff ff       	call   10113f <cga_putc>
        serial_putc(c);
  1016ac:	8b 45 08             	mov    0x8(%ebp),%eax
  1016af:	89 04 24             	mov    %eax,(%esp)
  1016b2:	e8 c8 fc ff ff       	call   10137f <serial_putc>
    }
    local_intr_restore(intr_flag);
  1016b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1016ba:	89 04 24             	mov    %eax,(%esp)
  1016bd:	e8 3d f7 ff ff       	call   100dff <__intr_restore>
}
  1016c2:	c9                   	leave  
  1016c3:	c3                   	ret    

001016c4 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
  1016c4:	55                   	push   %ebp
  1016c5:	89 e5                	mov    %esp,%ebp
  1016c7:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
  1016ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  1016d1:	e8 fa f6 ff ff       	call   100dd0 <__intr_save>
  1016d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
  1016d9:	e8 96 fd ff ff       	call   101474 <serial_intr>
        kbd_intr();
  1016de:	e8 4c ff ff ff       	call   10162f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
  1016e3:	8b 15 a0 90 11 00    	mov    0x1190a0,%edx
  1016e9:	a1 a4 90 11 00       	mov    0x1190a4,%eax
  1016ee:	39 c2                	cmp    %eax,%edx
  1016f0:	74 30                	je     101722 <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
  1016f2:	a1 a0 90 11 00       	mov    0x1190a0,%eax
  1016f7:	0f b6 90 a0 8e 11 00 	movzbl 0x118ea0(%eax),%edx
  1016fe:	0f b6 d2             	movzbl %dl,%edx
  101701:	89 55 f4             	mov    %edx,-0xc(%ebp)
  101704:	83 c0 01             	add    $0x1,%eax
  101707:	a3 a0 90 11 00       	mov    %eax,0x1190a0
            if (cons.rpos == CONSBUFSIZE) {
  10170c:	a1 a0 90 11 00       	mov    0x1190a0,%eax
  101711:	3d 00 02 00 00       	cmp    $0x200,%eax
  101716:	75 0a                	jne    101722 <cons_getc+0x5e>
                cons.rpos = 0;
  101718:	c7 05 a0 90 11 00 00 	movl   $0x0,0x1190a0
  10171f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
  101722:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101725:	89 04 24             	mov    %eax,(%esp)
  101728:	e8 d2 f6 ff ff       	call   100dff <__intr_restore>
    return c;
  10172d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  101730:	c9                   	leave  
  101731:	c3                   	ret    
	...

00101734 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
  101734:	55                   	push   %ebp
  101735:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
  101737:	fb                   	sti    
    sti();
}
  101738:	5d                   	pop    %ebp
  101739:	c3                   	ret    

0010173a <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
  10173a:	55                   	push   %ebp
  10173b:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
  10173d:	fa                   	cli    
    cli();
}
  10173e:	5d                   	pop    %ebp
  10173f:	c3                   	ret    

00101740 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
  101740:	55                   	push   %ebp
  101741:	89 e5                	mov    %esp,%ebp
  101743:	83 ec 14             	sub    $0x14,%esp
  101746:	8b 45 08             	mov    0x8(%ebp),%eax
  101749:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
  10174d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101751:	66 a3 70 85 11 00    	mov    %ax,0x118570
    if (did_init) {
  101757:	a1 ac 90 11 00       	mov    0x1190ac,%eax
  10175c:	85 c0                	test   %eax,%eax
  10175e:	74 36                	je     101796 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
  101760:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  101764:	0f b6 c0             	movzbl %al,%eax
  101767:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  10176d:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
  101770:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  101774:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  101778:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
  101779:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
  10177d:	66 c1 e8 08          	shr    $0x8,%ax
  101781:	0f b6 c0             	movzbl %al,%eax
  101784:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  10178a:	88 45 f9             	mov    %al,-0x7(%ebp)
  10178d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  101791:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101795:	ee                   	out    %al,(%dx)
    }
}
  101796:	c9                   	leave  
  101797:	c3                   	ret    

00101798 <pic_enable>:

void
pic_enable(unsigned int irq) {
  101798:	55                   	push   %ebp
  101799:	89 e5                	mov    %esp,%ebp
  10179b:	53                   	push   %ebx
  10179c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
  10179f:	8b 45 08             	mov    0x8(%ebp),%eax
  1017a2:	ba 01 00 00 00       	mov    $0x1,%edx
  1017a7:	89 d3                	mov    %edx,%ebx
  1017a9:	89 c1                	mov    %eax,%ecx
  1017ab:	d3 e3                	shl    %cl,%ebx
  1017ad:	89 d8                	mov    %ebx,%eax
  1017af:	89 c2                	mov    %eax,%edx
  1017b1:	f7 d2                	not    %edx
  1017b3:	0f b7 05 70 85 11 00 	movzwl 0x118570,%eax
  1017ba:	21 d0                	and    %edx,%eax
  1017bc:	0f b7 c0             	movzwl %ax,%eax
  1017bf:	89 04 24             	mov    %eax,(%esp)
  1017c2:	e8 79 ff ff ff       	call   101740 <pic_setmask>
}
  1017c7:	83 c4 04             	add    $0x4,%esp
  1017ca:	5b                   	pop    %ebx
  1017cb:	5d                   	pop    %ebp
  1017cc:	c3                   	ret    

001017cd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
  1017cd:	55                   	push   %ebp
  1017ce:	89 e5                	mov    %esp,%ebp
  1017d0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
  1017d3:	c7 05 ac 90 11 00 01 	movl   $0x1,0x1190ac
  1017da:	00 00 00 
  1017dd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
  1017e3:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
  1017e7:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
  1017eb:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
  1017ef:	ee                   	out    %al,(%dx)
  1017f0:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
  1017f6:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
  1017fa:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
  1017fe:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
  101802:	ee                   	out    %al,(%dx)
  101803:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
  101809:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
  10180d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
  101811:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
  101815:	ee                   	out    %al,(%dx)
  101816:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
  10181c:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
  101820:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
  101824:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
  101828:	ee                   	out    %al,(%dx)
  101829:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
  10182f:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
  101833:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
  101837:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
  10183b:	ee                   	out    %al,(%dx)
  10183c:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
  101842:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
  101846:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
  10184a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
  10184e:	ee                   	out    %al,(%dx)
  10184f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
  101855:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
  101859:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
  10185d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
  101861:	ee                   	out    %al,(%dx)
  101862:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
  101868:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
  10186c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
  101870:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
  101874:	ee                   	out    %al,(%dx)
  101875:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
  10187b:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
  10187f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
  101883:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
  101887:	ee                   	out    %al,(%dx)
  101888:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
  10188e:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
  101892:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
  101896:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
  10189a:	ee                   	out    %al,(%dx)
  10189b:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
  1018a1:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
  1018a5:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
  1018a9:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
  1018ad:	ee                   	out    %al,(%dx)
  1018ae:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
  1018b4:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
  1018b8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
  1018bc:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
  1018c0:	ee                   	out    %al,(%dx)
  1018c1:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
  1018c7:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
  1018cb:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
  1018cf:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
  1018d3:	ee                   	out    %al,(%dx)
  1018d4:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
  1018da:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
  1018de:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
  1018e2:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
  1018e6:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
  1018e7:	0f b7 05 70 85 11 00 	movzwl 0x118570,%eax
  1018ee:	66 83 f8 ff          	cmp    $0xffff,%ax
  1018f2:	74 12                	je     101906 <pic_init+0x139>
        pic_setmask(irq_mask);
  1018f4:	0f b7 05 70 85 11 00 	movzwl 0x118570,%eax
  1018fb:	0f b7 c0             	movzwl %ax,%eax
  1018fe:	89 04 24             	mov    %eax,(%esp)
  101901:	e8 3a fe ff ff       	call   101740 <pic_setmask>
    }
}
  101906:	c9                   	leave  
  101907:	c3                   	ret    

00101908 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
  101908:	55                   	push   %ebp
  101909:	89 e5                	mov    %esp,%ebp
  10190b:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
  10190e:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
  101915:	00 
  101916:	c7 04 24 e0 65 10 00 	movl   $0x1065e0,(%esp)
  10191d:	e8 25 ea ff ff       	call   100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
  101922:	c9                   	leave  
  101923:	c3                   	ret    

00101924 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
  101924:	55                   	push   %ebp
  101925:	89 e5                	mov    %esp,%ebp
  101927:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  10192a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
  101931:	e9 c3 00 00 00       	jmp    1019f9 <idt_init+0xd5>
        SETGATE(idt[i], 0,  GD_KTEXT, __vectors[i], DPL_KERNEL);
  101936:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101939:	8b 04 85 00 86 11 00 	mov    0x118600(,%eax,4),%eax
  101940:	89 c2                	mov    %eax,%edx
  101942:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101945:	66 89 14 c5 c0 90 11 	mov    %dx,0x1190c0(,%eax,8)
  10194c:	00 
  10194d:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101950:	66 c7 04 c5 c2 90 11 	movw   $0x8,0x1190c2(,%eax,8)
  101957:	00 08 00 
  10195a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10195d:	0f b6 14 c5 c4 90 11 	movzbl 0x1190c4(,%eax,8),%edx
  101964:	00 
  101965:	83 e2 e0             	and    $0xffffffe0,%edx
  101968:	88 14 c5 c4 90 11 00 	mov    %dl,0x1190c4(,%eax,8)
  10196f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101972:	0f b6 14 c5 c4 90 11 	movzbl 0x1190c4(,%eax,8),%edx
  101979:	00 
  10197a:	83 e2 1f             	and    $0x1f,%edx
  10197d:	88 14 c5 c4 90 11 00 	mov    %dl,0x1190c4(,%eax,8)
  101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
  101987:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  10198e:	00 
  10198f:	83 e2 f0             	and    $0xfffffff0,%edx
  101992:	83 ca 0e             	or     $0xe,%edx
  101995:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  10199c:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10199f:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  1019a6:	00 
  1019a7:	83 e2 ef             	and    $0xffffffef,%edx
  1019aa:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  1019b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019b4:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  1019bb:	00 
  1019bc:	83 e2 9f             	and    $0xffffff9f,%edx
  1019bf:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  1019c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019c9:	0f b6 14 c5 c5 90 11 	movzbl 0x1190c5(,%eax,8),%edx
  1019d0:	00 
  1019d1:	83 ca 80             	or     $0xffffff80,%edx
  1019d4:	88 14 c5 c5 90 11 00 	mov    %dl,0x1190c5(,%eax,8)
  1019db:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019de:	8b 04 85 00 86 11 00 	mov    0x118600(,%eax,4),%eax
  1019e5:	c1 e8 10             	shr    $0x10,%eax
  1019e8:	89 c2                	mov    %eax,%edx
  1019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019ed:	66 89 14 c5 c6 90 11 	mov    %dx,0x1190c6(,%eax,8)
  1019f4:	00 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
  1019f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  1019f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
  1019fc:	3d ff 00 00 00       	cmp    $0xff,%eax
  101a01:	0f 86 2f ff ff ff    	jbe    101936 <idt_init+0x12>
        SETGATE(idt[i], 0,  GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
  101a07:	a1 e4 87 11 00       	mov    0x1187e4,%eax
  101a0c:	66 a3 88 94 11 00    	mov    %ax,0x119488
  101a12:	66 c7 05 8a 94 11 00 	movw   $0x8,0x11948a
  101a19:	08 00 
  101a1b:	0f b6 05 8c 94 11 00 	movzbl 0x11948c,%eax
  101a22:	83 e0 e0             	and    $0xffffffe0,%eax
  101a25:	a2 8c 94 11 00       	mov    %al,0x11948c
  101a2a:	0f b6 05 8c 94 11 00 	movzbl 0x11948c,%eax
  101a31:	83 e0 1f             	and    $0x1f,%eax
  101a34:	a2 8c 94 11 00       	mov    %al,0x11948c
  101a39:	0f b6 05 8d 94 11 00 	movzbl 0x11948d,%eax
  101a40:	83 e0 f0             	and    $0xfffffff0,%eax
  101a43:	83 c8 0e             	or     $0xe,%eax
  101a46:	a2 8d 94 11 00       	mov    %al,0x11948d
  101a4b:	0f b6 05 8d 94 11 00 	movzbl 0x11948d,%eax
  101a52:	83 e0 ef             	and    $0xffffffef,%eax
  101a55:	a2 8d 94 11 00       	mov    %al,0x11948d
  101a5a:	0f b6 05 8d 94 11 00 	movzbl 0x11948d,%eax
  101a61:	83 c8 60             	or     $0x60,%eax
  101a64:	a2 8d 94 11 00       	mov    %al,0x11948d
  101a69:	0f b6 05 8d 94 11 00 	movzbl 0x11948d,%eax
  101a70:	83 c8 80             	or     $0xffffff80,%eax
  101a73:	a2 8d 94 11 00       	mov    %al,0x11948d
  101a78:	a1 e4 87 11 00       	mov    0x1187e4,%eax
  101a7d:	c1 e8 10             	shr    $0x10,%eax
  101a80:	66 a3 8e 94 11 00    	mov    %ax,0x11948e
  101a86:	c7 45 f8 80 85 11 00 	movl   $0x118580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
  101a8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  101a90:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd); // load the IDT
      
}
  101a93:	c9                   	leave  
  101a94:	c3                   	ret    

00101a95 <trapname>:

static const char *
trapname(int trapno) {
  101a95:	55                   	push   %ebp
  101a96:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
  101a98:	8b 45 08             	mov    0x8(%ebp),%eax
  101a9b:	83 f8 13             	cmp    $0x13,%eax
  101a9e:	77 0c                	ja     101aac <trapname+0x17>
        return excnames[trapno];
  101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
  101aa3:	8b 04 85 40 69 10 00 	mov    0x106940(,%eax,4),%eax
  101aaa:	eb 18                	jmp    101ac4 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
  101aac:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
  101ab0:	7e 0d                	jle    101abf <trapname+0x2a>
  101ab2:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
  101ab6:	7f 07                	jg     101abf <trapname+0x2a>
        return "Hardware Interrupt";
  101ab8:	b8 ea 65 10 00       	mov    $0x1065ea,%eax
  101abd:	eb 05                	jmp    101ac4 <trapname+0x2f>
    }
    return "(unknown trap)";
  101abf:	b8 fd 65 10 00       	mov    $0x1065fd,%eax
}
  101ac4:	5d                   	pop    %ebp
  101ac5:	c3                   	ret    

00101ac6 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
  101ac6:	55                   	push   %ebp
  101ac7:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
  101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
  101acc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101ad0:	66 83 f8 08          	cmp    $0x8,%ax
  101ad4:	0f 94 c0             	sete   %al
  101ad7:	0f b6 c0             	movzbl %al,%eax
}
  101ada:	5d                   	pop    %ebp
  101adb:	c3                   	ret    

00101adc <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
  101adc:	55                   	push   %ebp
  101add:	89 e5                	mov    %esp,%ebp
  101adf:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
  101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
  101ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
  101ae9:	c7 04 24 3e 66 10 00 	movl   $0x10663e,(%esp)
  101af0:	e8 52 e8 ff ff       	call   100347 <cprintf>
    print_regs(&tf->tf_regs);
  101af5:	8b 45 08             	mov    0x8(%ebp),%eax
  101af8:	89 04 24             	mov    %eax,(%esp)
  101afb:	e8 a1 01 00 00       	call   101ca1 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
  101b00:	8b 45 08             	mov    0x8(%ebp),%eax
  101b03:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
  101b07:	0f b7 c0             	movzwl %ax,%eax
  101b0a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b0e:	c7 04 24 4f 66 10 00 	movl   $0x10664f,(%esp)
  101b15:	e8 2d e8 ff ff       	call   100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
  101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
  101b1d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
  101b21:	0f b7 c0             	movzwl %ax,%eax
  101b24:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b28:	c7 04 24 62 66 10 00 	movl   $0x106662,(%esp)
  101b2f:	e8 13 e8 ff ff       	call   100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
  101b34:	8b 45 08             	mov    0x8(%ebp),%eax
  101b37:	0f b7 40 24          	movzwl 0x24(%eax),%eax
  101b3b:	0f b7 c0             	movzwl %ax,%eax
  101b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b42:	c7 04 24 75 66 10 00 	movl   $0x106675,(%esp)
  101b49:	e8 f9 e7 ff ff       	call   100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
  101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
  101b51:	0f b7 40 20          	movzwl 0x20(%eax),%eax
  101b55:	0f b7 c0             	movzwl %ax,%eax
  101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b5c:	c7 04 24 88 66 10 00 	movl   $0x106688,(%esp)
  101b63:	e8 df e7 ff ff       	call   100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
  101b68:	8b 45 08             	mov    0x8(%ebp),%eax
  101b6b:	8b 40 30             	mov    0x30(%eax),%eax
  101b6e:	89 04 24             	mov    %eax,(%esp)
  101b71:	e8 1f ff ff ff       	call   101a95 <trapname>
  101b76:	8b 55 08             	mov    0x8(%ebp),%edx
  101b79:	8b 52 30             	mov    0x30(%edx),%edx
  101b7c:	89 44 24 08          	mov    %eax,0x8(%esp)
  101b80:	89 54 24 04          	mov    %edx,0x4(%esp)
  101b84:	c7 04 24 9b 66 10 00 	movl   $0x10669b,(%esp)
  101b8b:	e8 b7 e7 ff ff       	call   100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
  101b90:	8b 45 08             	mov    0x8(%ebp),%eax
  101b93:	8b 40 34             	mov    0x34(%eax),%eax
  101b96:	89 44 24 04          	mov    %eax,0x4(%esp)
  101b9a:	c7 04 24 ad 66 10 00 	movl   $0x1066ad,(%esp)
  101ba1:	e8 a1 e7 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
  101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
  101ba9:	8b 40 38             	mov    0x38(%eax),%eax
  101bac:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bb0:	c7 04 24 bc 66 10 00 	movl   $0x1066bc,(%esp)
  101bb7:	e8 8b e7 ff ff       	call   100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
  101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bbf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101bc3:	0f b7 c0             	movzwl %ax,%eax
  101bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
  101bca:	c7 04 24 cb 66 10 00 	movl   $0x1066cb,(%esp)
  101bd1:	e8 71 e7 ff ff       	call   100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
  101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
  101bd9:	8b 40 40             	mov    0x40(%eax),%eax
  101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
  101be0:	c7 04 24 de 66 10 00 	movl   $0x1066de,(%esp)
  101be7:	e8 5b e7 ff ff       	call   100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101bec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  101bf3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
  101bfa:	eb 3e                	jmp    101c3a <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
  101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
  101bff:	8b 50 40             	mov    0x40(%eax),%edx
  101c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  101c05:	21 d0                	and    %edx,%eax
  101c07:	85 c0                	test   %eax,%eax
  101c09:	74 28                	je     101c33 <print_trapframe+0x157>
  101c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c0e:	8b 04 85 a0 85 11 00 	mov    0x1185a0(,%eax,4),%eax
  101c15:	85 c0                	test   %eax,%eax
  101c17:	74 1a                	je     101c33 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
  101c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c1c:	8b 04 85 a0 85 11 00 	mov    0x1185a0(,%eax,4),%eax
  101c23:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c27:	c7 04 24 ed 66 10 00 	movl   $0x1066ed,(%esp)
  101c2e:	e8 14 e7 ff ff       	call   100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
  101c33:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  101c37:	d1 65 f0             	shll   -0x10(%ebp)
  101c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  101c3d:	83 f8 17             	cmp    $0x17,%eax
  101c40:	76 ba                	jbe    101bfc <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
  101c42:	8b 45 08             	mov    0x8(%ebp),%eax
  101c45:	8b 40 40             	mov    0x40(%eax),%eax
  101c48:	25 00 30 00 00       	and    $0x3000,%eax
  101c4d:	c1 e8 0c             	shr    $0xc,%eax
  101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c54:	c7 04 24 f1 66 10 00 	movl   $0x1066f1,(%esp)
  101c5b:	e8 e7 e6 ff ff       	call   100347 <cprintf>

    if (!trap_in_kernel(tf)) {
  101c60:	8b 45 08             	mov    0x8(%ebp),%eax
  101c63:	89 04 24             	mov    %eax,(%esp)
  101c66:	e8 5b fe ff ff       	call   101ac6 <trap_in_kernel>
  101c6b:	85 c0                	test   %eax,%eax
  101c6d:	75 30                	jne    101c9f <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
  101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
  101c72:	8b 40 44             	mov    0x44(%eax),%eax
  101c75:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c79:	c7 04 24 fa 66 10 00 	movl   $0x1066fa,(%esp)
  101c80:	e8 c2 e6 ff ff       	call   100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
  101c85:	8b 45 08             	mov    0x8(%ebp),%eax
  101c88:	0f b7 40 48          	movzwl 0x48(%eax),%eax
  101c8c:	0f b7 c0             	movzwl %ax,%eax
  101c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
  101c93:	c7 04 24 09 67 10 00 	movl   $0x106709,(%esp)
  101c9a:	e8 a8 e6 ff ff       	call   100347 <cprintf>
    }
}
  101c9f:	c9                   	leave  
  101ca0:	c3                   	ret    

00101ca1 <print_regs>:

void
print_regs(struct pushregs *regs) {
  101ca1:	55                   	push   %ebp
  101ca2:	89 e5                	mov    %esp,%ebp
  101ca4:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
  101ca7:	8b 45 08             	mov    0x8(%ebp),%eax
  101caa:	8b 00                	mov    (%eax),%eax
  101cac:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cb0:	c7 04 24 1c 67 10 00 	movl   $0x10671c,(%esp)
  101cb7:	e8 8b e6 ff ff       	call   100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
  101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
  101cbf:	8b 40 04             	mov    0x4(%eax),%eax
  101cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cc6:	c7 04 24 2b 67 10 00 	movl   $0x10672b,(%esp)
  101ccd:	e8 75 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
  101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
  101cd5:	8b 40 08             	mov    0x8(%eax),%eax
  101cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cdc:	c7 04 24 3a 67 10 00 	movl   $0x10673a,(%esp)
  101ce3:	e8 5f e6 ff ff       	call   100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
  101ce8:	8b 45 08             	mov    0x8(%ebp),%eax
  101ceb:	8b 40 0c             	mov    0xc(%eax),%eax
  101cee:	89 44 24 04          	mov    %eax,0x4(%esp)
  101cf2:	c7 04 24 49 67 10 00 	movl   $0x106749,(%esp)
  101cf9:	e8 49 e6 ff ff       	call   100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
  101cfe:	8b 45 08             	mov    0x8(%ebp),%eax
  101d01:	8b 40 10             	mov    0x10(%eax),%eax
  101d04:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d08:	c7 04 24 58 67 10 00 	movl   $0x106758,(%esp)
  101d0f:	e8 33 e6 ff ff       	call   100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
  101d14:	8b 45 08             	mov    0x8(%ebp),%eax
  101d17:	8b 40 14             	mov    0x14(%eax),%eax
  101d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d1e:	c7 04 24 67 67 10 00 	movl   $0x106767,(%esp)
  101d25:	e8 1d e6 ff ff       	call   100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
  101d2a:	8b 45 08             	mov    0x8(%ebp),%eax
  101d2d:	8b 40 18             	mov    0x18(%eax),%eax
  101d30:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d34:	c7 04 24 76 67 10 00 	movl   $0x106776,(%esp)
  101d3b:	e8 07 e6 ff ff       	call   100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
  101d40:	8b 45 08             	mov    0x8(%ebp),%eax
  101d43:	8b 40 1c             	mov    0x1c(%eax),%eax
  101d46:	89 44 24 04          	mov    %eax,0x4(%esp)
  101d4a:	c7 04 24 85 67 10 00 	movl   $0x106785,(%esp)
  101d51:	e8 f1 e5 ff ff       	call   100347 <cprintf>
}
  101d56:	c9                   	leave  
  101d57:	c3                   	ret    

00101d58 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
  101d58:	55                   	push   %ebp
  101d59:	89 e5                	mov    %esp,%ebp
  101d5b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
  101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
  101d61:	8b 40 30             	mov    0x30(%eax),%eax
  101d64:	83 f8 2f             	cmp    $0x2f,%eax
  101d67:	77 21                	ja     101d8a <trap_dispatch+0x32>
  101d69:	83 f8 2e             	cmp    $0x2e,%eax
  101d6c:	0f 83 05 01 00 00    	jae    101e77 <trap_dispatch+0x11f>
  101d72:	83 f8 21             	cmp    $0x21,%eax
  101d75:	0f 84 82 00 00 00    	je     101dfd <trap_dispatch+0xa5>
  101d7b:	83 f8 24             	cmp    $0x24,%eax
  101d7e:	74 57                	je     101dd7 <trap_dispatch+0x7f>
  101d80:	83 f8 20             	cmp    $0x20,%eax
  101d83:	74 16                	je     101d9b <trap_dispatch+0x43>
  101d85:	e9 b5 00 00 00       	jmp    101e3f <trap_dispatch+0xe7>
  101d8a:	83 e8 78             	sub    $0x78,%eax
  101d8d:	83 f8 01             	cmp    $0x1,%eax
  101d90:	0f 87 a9 00 00 00    	ja     101e3f <trap_dispatch+0xe7>
  101d96:	e9 88 00 00 00       	jmp    101e23 <trap_dispatch+0xcb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
  101d9b:	a1 4c 99 11 00       	mov    0x11994c,%eax
  101da0:	83 c0 01             	add    $0x1,%eax
  101da3:	a3 4c 99 11 00       	mov    %eax,0x11994c
        if (ticks % TICK_NUM == 0) {
  101da8:	8b 0d 4c 99 11 00    	mov    0x11994c,%ecx
  101dae:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
  101db3:	89 c8                	mov    %ecx,%eax
  101db5:	f7 e2                	mul    %edx
  101db7:	89 d0                	mov    %edx,%eax
  101db9:	c1 e8 05             	shr    $0x5,%eax
  101dbc:	6b c0 64             	imul   $0x64,%eax,%eax
  101dbf:	89 ca                	mov    %ecx,%edx
  101dc1:	29 c2                	sub    %eax,%edx
  101dc3:	89 d0                	mov    %edx,%eax
  101dc5:	85 c0                	test   %eax,%eax
  101dc7:	0f 85 ad 00 00 00    	jne    101e7a <trap_dispatch+0x122>
            print_ticks();
  101dcd:	e8 36 fb ff ff       	call   101908 <print_ticks>
        }
        break;
  101dd2:	e9 a3 00 00 00       	jmp    101e7a <trap_dispatch+0x122>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
  101dd7:	e8 e8 f8 ff ff       	call   1016c4 <cons_getc>
  101ddc:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
  101ddf:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101de3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101de7:	89 54 24 08          	mov    %edx,0x8(%esp)
  101deb:	89 44 24 04          	mov    %eax,0x4(%esp)
  101def:	c7 04 24 94 67 10 00 	movl   $0x106794,(%esp)
  101df6:	e8 4c e5 ff ff       	call   100347 <cprintf>
        break;
  101dfb:	eb 7e                	jmp    101e7b <trap_dispatch+0x123>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
  101dfd:	e8 c2 f8 ff ff       	call   1016c4 <cons_getc>
  101e02:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
  101e05:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
  101e09:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  101e0d:	89 54 24 08          	mov    %edx,0x8(%esp)
  101e11:	89 44 24 04          	mov    %eax,0x4(%esp)
  101e15:	c7 04 24 a6 67 10 00 	movl   $0x1067a6,(%esp)
  101e1c:	e8 26 e5 ff ff       	call   100347 <cprintf>
        break;
  101e21:	eb 58                	jmp    101e7b <trap_dispatch+0x123>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
  101e23:	c7 44 24 08 b5 67 10 	movl   $0x1067b5,0x8(%esp)
  101e2a:	00 
  101e2b:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
  101e32:	00 
  101e33:	c7 04 24 c5 67 10 00 	movl   $0x1067c5,(%esp)
  101e3a:	e8 69 ee ff ff       	call   100ca8 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
  101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
  101e42:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
  101e46:	0f b7 c0             	movzwl %ax,%eax
  101e49:	83 e0 03             	and    $0x3,%eax
  101e4c:	85 c0                	test   %eax,%eax
  101e4e:	75 2b                	jne    101e7b <trap_dispatch+0x123>
            print_trapframe(tf);
  101e50:	8b 45 08             	mov    0x8(%ebp),%eax
  101e53:	89 04 24             	mov    %eax,(%esp)
  101e56:	e8 81 fc ff ff       	call   101adc <print_trapframe>
            panic("unexpected trap in kernel.\n");
  101e5b:	c7 44 24 08 d6 67 10 	movl   $0x1067d6,0x8(%esp)
  101e62:	00 
  101e63:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
  101e6a:	00 
  101e6b:	c7 04 24 c5 67 10 00 	movl   $0x1067c5,(%esp)
  101e72:	e8 31 ee ff ff       	call   100ca8 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
  101e77:	90                   	nop
  101e78:	eb 01                	jmp    101e7b <trap_dispatch+0x123>
         */
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
  101e7a:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
  101e7b:	c9                   	leave  
  101e7c:	c3                   	ret    

00101e7d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
  101e7d:	55                   	push   %ebp
  101e7e:	89 e5                	mov    %esp,%ebp
  101e80:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
  101e83:	8b 45 08             	mov    0x8(%ebp),%eax
  101e86:	89 04 24             	mov    %eax,(%esp)
  101e89:	e8 ca fe ff ff       	call   101d58 <trap_dispatch>
}
  101e8e:	c9                   	leave  
  101e8f:	c3                   	ret    

00101e90 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
  101e90:	1e                   	push   %ds
    pushl %es
  101e91:	06                   	push   %es
    pushl %fs
  101e92:	0f a0                	push   %fs
    pushl %gs
  101e94:	0f a8                	push   %gs
    pushal
  101e96:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
  101e97:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
  101e9c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
  101e9e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
  101ea0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
  101ea1:	e8 d7 ff ff ff       	call   101e7d <trap>

    # pop the pushed stack pointer
    popl %esp
  101ea6:	5c                   	pop    %esp

00101ea7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
  101ea7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
  101ea8:	0f a9                	pop    %gs
    popl %fs
  101eaa:	0f a1                	pop    %fs
    popl %es
  101eac:	07                   	pop    %es
    popl %ds
  101ead:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
  101eae:	83 c4 08             	add    $0x8,%esp
    iret
  101eb1:	cf                   	iret   
	...

00101eb4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
  101eb4:	6a 00                	push   $0x0
  pushl $0
  101eb6:	6a 00                	push   $0x0
  jmp __alltraps
  101eb8:	e9 d3 ff ff ff       	jmp    101e90 <__alltraps>

00101ebd <vector1>:
.globl vector1
vector1:
  pushl $0
  101ebd:	6a 00                	push   $0x0
  pushl $1
  101ebf:	6a 01                	push   $0x1
  jmp __alltraps
  101ec1:	e9 ca ff ff ff       	jmp    101e90 <__alltraps>

00101ec6 <vector2>:
.globl vector2
vector2:
  pushl $0
  101ec6:	6a 00                	push   $0x0
  pushl $2
  101ec8:	6a 02                	push   $0x2
  jmp __alltraps
  101eca:	e9 c1 ff ff ff       	jmp    101e90 <__alltraps>

00101ecf <vector3>:
.globl vector3
vector3:
  pushl $0
  101ecf:	6a 00                	push   $0x0
  pushl $3
  101ed1:	6a 03                	push   $0x3
  jmp __alltraps
  101ed3:	e9 b8 ff ff ff       	jmp    101e90 <__alltraps>

00101ed8 <vector4>:
.globl vector4
vector4:
  pushl $0
  101ed8:	6a 00                	push   $0x0
  pushl $4
  101eda:	6a 04                	push   $0x4
  jmp __alltraps
  101edc:	e9 af ff ff ff       	jmp    101e90 <__alltraps>

00101ee1 <vector5>:
.globl vector5
vector5:
  pushl $0
  101ee1:	6a 00                	push   $0x0
  pushl $5
  101ee3:	6a 05                	push   $0x5
  jmp __alltraps
  101ee5:	e9 a6 ff ff ff       	jmp    101e90 <__alltraps>

00101eea <vector6>:
.globl vector6
vector6:
  pushl $0
  101eea:	6a 00                	push   $0x0
  pushl $6
  101eec:	6a 06                	push   $0x6
  jmp __alltraps
  101eee:	e9 9d ff ff ff       	jmp    101e90 <__alltraps>

00101ef3 <vector7>:
.globl vector7
vector7:
  pushl $0
  101ef3:	6a 00                	push   $0x0
  pushl $7
  101ef5:	6a 07                	push   $0x7
  jmp __alltraps
  101ef7:	e9 94 ff ff ff       	jmp    101e90 <__alltraps>

00101efc <vector8>:
.globl vector8
vector8:
  pushl $8
  101efc:	6a 08                	push   $0x8
  jmp __alltraps
  101efe:	e9 8d ff ff ff       	jmp    101e90 <__alltraps>

00101f03 <vector9>:
.globl vector9
vector9:
  pushl $9
  101f03:	6a 09                	push   $0x9
  jmp __alltraps
  101f05:	e9 86 ff ff ff       	jmp    101e90 <__alltraps>

00101f0a <vector10>:
.globl vector10
vector10:
  pushl $10
  101f0a:	6a 0a                	push   $0xa
  jmp __alltraps
  101f0c:	e9 7f ff ff ff       	jmp    101e90 <__alltraps>

00101f11 <vector11>:
.globl vector11
vector11:
  pushl $11
  101f11:	6a 0b                	push   $0xb
  jmp __alltraps
  101f13:	e9 78 ff ff ff       	jmp    101e90 <__alltraps>

00101f18 <vector12>:
.globl vector12
vector12:
  pushl $12
  101f18:	6a 0c                	push   $0xc
  jmp __alltraps
  101f1a:	e9 71 ff ff ff       	jmp    101e90 <__alltraps>

00101f1f <vector13>:
.globl vector13
vector13:
  pushl $13
  101f1f:	6a 0d                	push   $0xd
  jmp __alltraps
  101f21:	e9 6a ff ff ff       	jmp    101e90 <__alltraps>

00101f26 <vector14>:
.globl vector14
vector14:
  pushl $14
  101f26:	6a 0e                	push   $0xe
  jmp __alltraps
  101f28:	e9 63 ff ff ff       	jmp    101e90 <__alltraps>

00101f2d <vector15>:
.globl vector15
vector15:
  pushl $0
  101f2d:	6a 00                	push   $0x0
  pushl $15
  101f2f:	6a 0f                	push   $0xf
  jmp __alltraps
  101f31:	e9 5a ff ff ff       	jmp    101e90 <__alltraps>

00101f36 <vector16>:
.globl vector16
vector16:
  pushl $0
  101f36:	6a 00                	push   $0x0
  pushl $16
  101f38:	6a 10                	push   $0x10
  jmp __alltraps
  101f3a:	e9 51 ff ff ff       	jmp    101e90 <__alltraps>

00101f3f <vector17>:
.globl vector17
vector17:
  pushl $17
  101f3f:	6a 11                	push   $0x11
  jmp __alltraps
  101f41:	e9 4a ff ff ff       	jmp    101e90 <__alltraps>

00101f46 <vector18>:
.globl vector18
vector18:
  pushl $0
  101f46:	6a 00                	push   $0x0
  pushl $18
  101f48:	6a 12                	push   $0x12
  jmp __alltraps
  101f4a:	e9 41 ff ff ff       	jmp    101e90 <__alltraps>

00101f4f <vector19>:
.globl vector19
vector19:
  pushl $0
  101f4f:	6a 00                	push   $0x0
  pushl $19
  101f51:	6a 13                	push   $0x13
  jmp __alltraps
  101f53:	e9 38 ff ff ff       	jmp    101e90 <__alltraps>

00101f58 <vector20>:
.globl vector20
vector20:
  pushl $0
  101f58:	6a 00                	push   $0x0
  pushl $20
  101f5a:	6a 14                	push   $0x14
  jmp __alltraps
  101f5c:	e9 2f ff ff ff       	jmp    101e90 <__alltraps>

00101f61 <vector21>:
.globl vector21
vector21:
  pushl $0
  101f61:	6a 00                	push   $0x0
  pushl $21
  101f63:	6a 15                	push   $0x15
  jmp __alltraps
  101f65:	e9 26 ff ff ff       	jmp    101e90 <__alltraps>

00101f6a <vector22>:
.globl vector22
vector22:
  pushl $0
  101f6a:	6a 00                	push   $0x0
  pushl $22
  101f6c:	6a 16                	push   $0x16
  jmp __alltraps
  101f6e:	e9 1d ff ff ff       	jmp    101e90 <__alltraps>

00101f73 <vector23>:
.globl vector23
vector23:
  pushl $0
  101f73:	6a 00                	push   $0x0
  pushl $23
  101f75:	6a 17                	push   $0x17
  jmp __alltraps
  101f77:	e9 14 ff ff ff       	jmp    101e90 <__alltraps>

00101f7c <vector24>:
.globl vector24
vector24:
  pushl $0
  101f7c:	6a 00                	push   $0x0
  pushl $24
  101f7e:	6a 18                	push   $0x18
  jmp __alltraps
  101f80:	e9 0b ff ff ff       	jmp    101e90 <__alltraps>

00101f85 <vector25>:
.globl vector25
vector25:
  pushl $0
  101f85:	6a 00                	push   $0x0
  pushl $25
  101f87:	6a 19                	push   $0x19
  jmp __alltraps
  101f89:	e9 02 ff ff ff       	jmp    101e90 <__alltraps>

00101f8e <vector26>:
.globl vector26
vector26:
  pushl $0
  101f8e:	6a 00                	push   $0x0
  pushl $26
  101f90:	6a 1a                	push   $0x1a
  jmp __alltraps
  101f92:	e9 f9 fe ff ff       	jmp    101e90 <__alltraps>

00101f97 <vector27>:
.globl vector27
vector27:
  pushl $0
  101f97:	6a 00                	push   $0x0
  pushl $27
  101f99:	6a 1b                	push   $0x1b
  jmp __alltraps
  101f9b:	e9 f0 fe ff ff       	jmp    101e90 <__alltraps>

00101fa0 <vector28>:
.globl vector28
vector28:
  pushl $0
  101fa0:	6a 00                	push   $0x0
  pushl $28
  101fa2:	6a 1c                	push   $0x1c
  jmp __alltraps
  101fa4:	e9 e7 fe ff ff       	jmp    101e90 <__alltraps>

00101fa9 <vector29>:
.globl vector29
vector29:
  pushl $0
  101fa9:	6a 00                	push   $0x0
  pushl $29
  101fab:	6a 1d                	push   $0x1d
  jmp __alltraps
  101fad:	e9 de fe ff ff       	jmp    101e90 <__alltraps>

00101fb2 <vector30>:
.globl vector30
vector30:
  pushl $0
  101fb2:	6a 00                	push   $0x0
  pushl $30
  101fb4:	6a 1e                	push   $0x1e
  jmp __alltraps
  101fb6:	e9 d5 fe ff ff       	jmp    101e90 <__alltraps>

00101fbb <vector31>:
.globl vector31
vector31:
  pushl $0
  101fbb:	6a 00                	push   $0x0
  pushl $31
  101fbd:	6a 1f                	push   $0x1f
  jmp __alltraps
  101fbf:	e9 cc fe ff ff       	jmp    101e90 <__alltraps>

00101fc4 <vector32>:
.globl vector32
vector32:
  pushl $0
  101fc4:	6a 00                	push   $0x0
  pushl $32
  101fc6:	6a 20                	push   $0x20
  jmp __alltraps
  101fc8:	e9 c3 fe ff ff       	jmp    101e90 <__alltraps>

00101fcd <vector33>:
.globl vector33
vector33:
  pushl $0
  101fcd:	6a 00                	push   $0x0
  pushl $33
  101fcf:	6a 21                	push   $0x21
  jmp __alltraps
  101fd1:	e9 ba fe ff ff       	jmp    101e90 <__alltraps>

00101fd6 <vector34>:
.globl vector34
vector34:
  pushl $0
  101fd6:	6a 00                	push   $0x0
  pushl $34
  101fd8:	6a 22                	push   $0x22
  jmp __alltraps
  101fda:	e9 b1 fe ff ff       	jmp    101e90 <__alltraps>

00101fdf <vector35>:
.globl vector35
vector35:
  pushl $0
  101fdf:	6a 00                	push   $0x0
  pushl $35
  101fe1:	6a 23                	push   $0x23
  jmp __alltraps
  101fe3:	e9 a8 fe ff ff       	jmp    101e90 <__alltraps>

00101fe8 <vector36>:
.globl vector36
vector36:
  pushl $0
  101fe8:	6a 00                	push   $0x0
  pushl $36
  101fea:	6a 24                	push   $0x24
  jmp __alltraps
  101fec:	e9 9f fe ff ff       	jmp    101e90 <__alltraps>

00101ff1 <vector37>:
.globl vector37
vector37:
  pushl $0
  101ff1:	6a 00                	push   $0x0
  pushl $37
  101ff3:	6a 25                	push   $0x25
  jmp __alltraps
  101ff5:	e9 96 fe ff ff       	jmp    101e90 <__alltraps>

00101ffa <vector38>:
.globl vector38
vector38:
  pushl $0
  101ffa:	6a 00                	push   $0x0
  pushl $38
  101ffc:	6a 26                	push   $0x26
  jmp __alltraps
  101ffe:	e9 8d fe ff ff       	jmp    101e90 <__alltraps>

00102003 <vector39>:
.globl vector39
vector39:
  pushl $0
  102003:	6a 00                	push   $0x0
  pushl $39
  102005:	6a 27                	push   $0x27
  jmp __alltraps
  102007:	e9 84 fe ff ff       	jmp    101e90 <__alltraps>

0010200c <vector40>:
.globl vector40
vector40:
  pushl $0
  10200c:	6a 00                	push   $0x0
  pushl $40
  10200e:	6a 28                	push   $0x28
  jmp __alltraps
  102010:	e9 7b fe ff ff       	jmp    101e90 <__alltraps>

00102015 <vector41>:
.globl vector41
vector41:
  pushl $0
  102015:	6a 00                	push   $0x0
  pushl $41
  102017:	6a 29                	push   $0x29
  jmp __alltraps
  102019:	e9 72 fe ff ff       	jmp    101e90 <__alltraps>

0010201e <vector42>:
.globl vector42
vector42:
  pushl $0
  10201e:	6a 00                	push   $0x0
  pushl $42
  102020:	6a 2a                	push   $0x2a
  jmp __alltraps
  102022:	e9 69 fe ff ff       	jmp    101e90 <__alltraps>

00102027 <vector43>:
.globl vector43
vector43:
  pushl $0
  102027:	6a 00                	push   $0x0
  pushl $43
  102029:	6a 2b                	push   $0x2b
  jmp __alltraps
  10202b:	e9 60 fe ff ff       	jmp    101e90 <__alltraps>

00102030 <vector44>:
.globl vector44
vector44:
  pushl $0
  102030:	6a 00                	push   $0x0
  pushl $44
  102032:	6a 2c                	push   $0x2c
  jmp __alltraps
  102034:	e9 57 fe ff ff       	jmp    101e90 <__alltraps>

00102039 <vector45>:
.globl vector45
vector45:
  pushl $0
  102039:	6a 00                	push   $0x0
  pushl $45
  10203b:	6a 2d                	push   $0x2d
  jmp __alltraps
  10203d:	e9 4e fe ff ff       	jmp    101e90 <__alltraps>

00102042 <vector46>:
.globl vector46
vector46:
  pushl $0
  102042:	6a 00                	push   $0x0
  pushl $46
  102044:	6a 2e                	push   $0x2e
  jmp __alltraps
  102046:	e9 45 fe ff ff       	jmp    101e90 <__alltraps>

0010204b <vector47>:
.globl vector47
vector47:
  pushl $0
  10204b:	6a 00                	push   $0x0
  pushl $47
  10204d:	6a 2f                	push   $0x2f
  jmp __alltraps
  10204f:	e9 3c fe ff ff       	jmp    101e90 <__alltraps>

00102054 <vector48>:
.globl vector48
vector48:
  pushl $0
  102054:	6a 00                	push   $0x0
  pushl $48
  102056:	6a 30                	push   $0x30
  jmp __alltraps
  102058:	e9 33 fe ff ff       	jmp    101e90 <__alltraps>

0010205d <vector49>:
.globl vector49
vector49:
  pushl $0
  10205d:	6a 00                	push   $0x0
  pushl $49
  10205f:	6a 31                	push   $0x31
  jmp __alltraps
  102061:	e9 2a fe ff ff       	jmp    101e90 <__alltraps>

00102066 <vector50>:
.globl vector50
vector50:
  pushl $0
  102066:	6a 00                	push   $0x0
  pushl $50
  102068:	6a 32                	push   $0x32
  jmp __alltraps
  10206a:	e9 21 fe ff ff       	jmp    101e90 <__alltraps>

0010206f <vector51>:
.globl vector51
vector51:
  pushl $0
  10206f:	6a 00                	push   $0x0
  pushl $51
  102071:	6a 33                	push   $0x33
  jmp __alltraps
  102073:	e9 18 fe ff ff       	jmp    101e90 <__alltraps>

00102078 <vector52>:
.globl vector52
vector52:
  pushl $0
  102078:	6a 00                	push   $0x0
  pushl $52
  10207a:	6a 34                	push   $0x34
  jmp __alltraps
  10207c:	e9 0f fe ff ff       	jmp    101e90 <__alltraps>

00102081 <vector53>:
.globl vector53
vector53:
  pushl $0
  102081:	6a 00                	push   $0x0
  pushl $53
  102083:	6a 35                	push   $0x35
  jmp __alltraps
  102085:	e9 06 fe ff ff       	jmp    101e90 <__alltraps>

0010208a <vector54>:
.globl vector54
vector54:
  pushl $0
  10208a:	6a 00                	push   $0x0
  pushl $54
  10208c:	6a 36                	push   $0x36
  jmp __alltraps
  10208e:	e9 fd fd ff ff       	jmp    101e90 <__alltraps>

00102093 <vector55>:
.globl vector55
vector55:
  pushl $0
  102093:	6a 00                	push   $0x0
  pushl $55
  102095:	6a 37                	push   $0x37
  jmp __alltraps
  102097:	e9 f4 fd ff ff       	jmp    101e90 <__alltraps>

0010209c <vector56>:
.globl vector56
vector56:
  pushl $0
  10209c:	6a 00                	push   $0x0
  pushl $56
  10209e:	6a 38                	push   $0x38
  jmp __alltraps
  1020a0:	e9 eb fd ff ff       	jmp    101e90 <__alltraps>

001020a5 <vector57>:
.globl vector57
vector57:
  pushl $0
  1020a5:	6a 00                	push   $0x0
  pushl $57
  1020a7:	6a 39                	push   $0x39
  jmp __alltraps
  1020a9:	e9 e2 fd ff ff       	jmp    101e90 <__alltraps>

001020ae <vector58>:
.globl vector58
vector58:
  pushl $0
  1020ae:	6a 00                	push   $0x0
  pushl $58
  1020b0:	6a 3a                	push   $0x3a
  jmp __alltraps
  1020b2:	e9 d9 fd ff ff       	jmp    101e90 <__alltraps>

001020b7 <vector59>:
.globl vector59
vector59:
  pushl $0
  1020b7:	6a 00                	push   $0x0
  pushl $59
  1020b9:	6a 3b                	push   $0x3b
  jmp __alltraps
  1020bb:	e9 d0 fd ff ff       	jmp    101e90 <__alltraps>

001020c0 <vector60>:
.globl vector60
vector60:
  pushl $0
  1020c0:	6a 00                	push   $0x0
  pushl $60
  1020c2:	6a 3c                	push   $0x3c
  jmp __alltraps
  1020c4:	e9 c7 fd ff ff       	jmp    101e90 <__alltraps>

001020c9 <vector61>:
.globl vector61
vector61:
  pushl $0
  1020c9:	6a 00                	push   $0x0
  pushl $61
  1020cb:	6a 3d                	push   $0x3d
  jmp __alltraps
  1020cd:	e9 be fd ff ff       	jmp    101e90 <__alltraps>

001020d2 <vector62>:
.globl vector62
vector62:
  pushl $0
  1020d2:	6a 00                	push   $0x0
  pushl $62
  1020d4:	6a 3e                	push   $0x3e
  jmp __alltraps
  1020d6:	e9 b5 fd ff ff       	jmp    101e90 <__alltraps>

001020db <vector63>:
.globl vector63
vector63:
  pushl $0
  1020db:	6a 00                	push   $0x0
  pushl $63
  1020dd:	6a 3f                	push   $0x3f
  jmp __alltraps
  1020df:	e9 ac fd ff ff       	jmp    101e90 <__alltraps>

001020e4 <vector64>:
.globl vector64
vector64:
  pushl $0
  1020e4:	6a 00                	push   $0x0
  pushl $64
  1020e6:	6a 40                	push   $0x40
  jmp __alltraps
  1020e8:	e9 a3 fd ff ff       	jmp    101e90 <__alltraps>

001020ed <vector65>:
.globl vector65
vector65:
  pushl $0
  1020ed:	6a 00                	push   $0x0
  pushl $65
  1020ef:	6a 41                	push   $0x41
  jmp __alltraps
  1020f1:	e9 9a fd ff ff       	jmp    101e90 <__alltraps>

001020f6 <vector66>:
.globl vector66
vector66:
  pushl $0
  1020f6:	6a 00                	push   $0x0
  pushl $66
  1020f8:	6a 42                	push   $0x42
  jmp __alltraps
  1020fa:	e9 91 fd ff ff       	jmp    101e90 <__alltraps>

001020ff <vector67>:
.globl vector67
vector67:
  pushl $0
  1020ff:	6a 00                	push   $0x0
  pushl $67
  102101:	6a 43                	push   $0x43
  jmp __alltraps
  102103:	e9 88 fd ff ff       	jmp    101e90 <__alltraps>

00102108 <vector68>:
.globl vector68
vector68:
  pushl $0
  102108:	6a 00                	push   $0x0
  pushl $68
  10210a:	6a 44                	push   $0x44
  jmp __alltraps
  10210c:	e9 7f fd ff ff       	jmp    101e90 <__alltraps>

00102111 <vector69>:
.globl vector69
vector69:
  pushl $0
  102111:	6a 00                	push   $0x0
  pushl $69
  102113:	6a 45                	push   $0x45
  jmp __alltraps
  102115:	e9 76 fd ff ff       	jmp    101e90 <__alltraps>

0010211a <vector70>:
.globl vector70
vector70:
  pushl $0
  10211a:	6a 00                	push   $0x0
  pushl $70
  10211c:	6a 46                	push   $0x46
  jmp __alltraps
  10211e:	e9 6d fd ff ff       	jmp    101e90 <__alltraps>

00102123 <vector71>:
.globl vector71
vector71:
  pushl $0
  102123:	6a 00                	push   $0x0
  pushl $71
  102125:	6a 47                	push   $0x47
  jmp __alltraps
  102127:	e9 64 fd ff ff       	jmp    101e90 <__alltraps>

0010212c <vector72>:
.globl vector72
vector72:
  pushl $0
  10212c:	6a 00                	push   $0x0
  pushl $72
  10212e:	6a 48                	push   $0x48
  jmp __alltraps
  102130:	e9 5b fd ff ff       	jmp    101e90 <__alltraps>

00102135 <vector73>:
.globl vector73
vector73:
  pushl $0
  102135:	6a 00                	push   $0x0
  pushl $73
  102137:	6a 49                	push   $0x49
  jmp __alltraps
  102139:	e9 52 fd ff ff       	jmp    101e90 <__alltraps>

0010213e <vector74>:
.globl vector74
vector74:
  pushl $0
  10213e:	6a 00                	push   $0x0
  pushl $74
  102140:	6a 4a                	push   $0x4a
  jmp __alltraps
  102142:	e9 49 fd ff ff       	jmp    101e90 <__alltraps>

00102147 <vector75>:
.globl vector75
vector75:
  pushl $0
  102147:	6a 00                	push   $0x0
  pushl $75
  102149:	6a 4b                	push   $0x4b
  jmp __alltraps
  10214b:	e9 40 fd ff ff       	jmp    101e90 <__alltraps>

00102150 <vector76>:
.globl vector76
vector76:
  pushl $0
  102150:	6a 00                	push   $0x0
  pushl $76
  102152:	6a 4c                	push   $0x4c
  jmp __alltraps
  102154:	e9 37 fd ff ff       	jmp    101e90 <__alltraps>

00102159 <vector77>:
.globl vector77
vector77:
  pushl $0
  102159:	6a 00                	push   $0x0
  pushl $77
  10215b:	6a 4d                	push   $0x4d
  jmp __alltraps
  10215d:	e9 2e fd ff ff       	jmp    101e90 <__alltraps>

00102162 <vector78>:
.globl vector78
vector78:
  pushl $0
  102162:	6a 00                	push   $0x0
  pushl $78
  102164:	6a 4e                	push   $0x4e
  jmp __alltraps
  102166:	e9 25 fd ff ff       	jmp    101e90 <__alltraps>

0010216b <vector79>:
.globl vector79
vector79:
  pushl $0
  10216b:	6a 00                	push   $0x0
  pushl $79
  10216d:	6a 4f                	push   $0x4f
  jmp __alltraps
  10216f:	e9 1c fd ff ff       	jmp    101e90 <__alltraps>

00102174 <vector80>:
.globl vector80
vector80:
  pushl $0
  102174:	6a 00                	push   $0x0
  pushl $80
  102176:	6a 50                	push   $0x50
  jmp __alltraps
  102178:	e9 13 fd ff ff       	jmp    101e90 <__alltraps>

0010217d <vector81>:
.globl vector81
vector81:
  pushl $0
  10217d:	6a 00                	push   $0x0
  pushl $81
  10217f:	6a 51                	push   $0x51
  jmp __alltraps
  102181:	e9 0a fd ff ff       	jmp    101e90 <__alltraps>

00102186 <vector82>:
.globl vector82
vector82:
  pushl $0
  102186:	6a 00                	push   $0x0
  pushl $82
  102188:	6a 52                	push   $0x52
  jmp __alltraps
  10218a:	e9 01 fd ff ff       	jmp    101e90 <__alltraps>

0010218f <vector83>:
.globl vector83
vector83:
  pushl $0
  10218f:	6a 00                	push   $0x0
  pushl $83
  102191:	6a 53                	push   $0x53
  jmp __alltraps
  102193:	e9 f8 fc ff ff       	jmp    101e90 <__alltraps>

00102198 <vector84>:
.globl vector84
vector84:
  pushl $0
  102198:	6a 00                	push   $0x0
  pushl $84
  10219a:	6a 54                	push   $0x54
  jmp __alltraps
  10219c:	e9 ef fc ff ff       	jmp    101e90 <__alltraps>

001021a1 <vector85>:
.globl vector85
vector85:
  pushl $0
  1021a1:	6a 00                	push   $0x0
  pushl $85
  1021a3:	6a 55                	push   $0x55
  jmp __alltraps
  1021a5:	e9 e6 fc ff ff       	jmp    101e90 <__alltraps>

001021aa <vector86>:
.globl vector86
vector86:
  pushl $0
  1021aa:	6a 00                	push   $0x0
  pushl $86
  1021ac:	6a 56                	push   $0x56
  jmp __alltraps
  1021ae:	e9 dd fc ff ff       	jmp    101e90 <__alltraps>

001021b3 <vector87>:
.globl vector87
vector87:
  pushl $0
  1021b3:	6a 00                	push   $0x0
  pushl $87
  1021b5:	6a 57                	push   $0x57
  jmp __alltraps
  1021b7:	e9 d4 fc ff ff       	jmp    101e90 <__alltraps>

001021bc <vector88>:
.globl vector88
vector88:
  pushl $0
  1021bc:	6a 00                	push   $0x0
  pushl $88
  1021be:	6a 58                	push   $0x58
  jmp __alltraps
  1021c0:	e9 cb fc ff ff       	jmp    101e90 <__alltraps>

001021c5 <vector89>:
.globl vector89
vector89:
  pushl $0
  1021c5:	6a 00                	push   $0x0
  pushl $89
  1021c7:	6a 59                	push   $0x59
  jmp __alltraps
  1021c9:	e9 c2 fc ff ff       	jmp    101e90 <__alltraps>

001021ce <vector90>:
.globl vector90
vector90:
  pushl $0
  1021ce:	6a 00                	push   $0x0
  pushl $90
  1021d0:	6a 5a                	push   $0x5a
  jmp __alltraps
  1021d2:	e9 b9 fc ff ff       	jmp    101e90 <__alltraps>

001021d7 <vector91>:
.globl vector91
vector91:
  pushl $0
  1021d7:	6a 00                	push   $0x0
  pushl $91
  1021d9:	6a 5b                	push   $0x5b
  jmp __alltraps
  1021db:	e9 b0 fc ff ff       	jmp    101e90 <__alltraps>

001021e0 <vector92>:
.globl vector92
vector92:
  pushl $0
  1021e0:	6a 00                	push   $0x0
  pushl $92
  1021e2:	6a 5c                	push   $0x5c
  jmp __alltraps
  1021e4:	e9 a7 fc ff ff       	jmp    101e90 <__alltraps>

001021e9 <vector93>:
.globl vector93
vector93:
  pushl $0
  1021e9:	6a 00                	push   $0x0
  pushl $93
  1021eb:	6a 5d                	push   $0x5d
  jmp __alltraps
  1021ed:	e9 9e fc ff ff       	jmp    101e90 <__alltraps>

001021f2 <vector94>:
.globl vector94
vector94:
  pushl $0
  1021f2:	6a 00                	push   $0x0
  pushl $94
  1021f4:	6a 5e                	push   $0x5e
  jmp __alltraps
  1021f6:	e9 95 fc ff ff       	jmp    101e90 <__alltraps>

001021fb <vector95>:
.globl vector95
vector95:
  pushl $0
  1021fb:	6a 00                	push   $0x0
  pushl $95
  1021fd:	6a 5f                	push   $0x5f
  jmp __alltraps
  1021ff:	e9 8c fc ff ff       	jmp    101e90 <__alltraps>

00102204 <vector96>:
.globl vector96
vector96:
  pushl $0
  102204:	6a 00                	push   $0x0
  pushl $96
  102206:	6a 60                	push   $0x60
  jmp __alltraps
  102208:	e9 83 fc ff ff       	jmp    101e90 <__alltraps>

0010220d <vector97>:
.globl vector97
vector97:
  pushl $0
  10220d:	6a 00                	push   $0x0
  pushl $97
  10220f:	6a 61                	push   $0x61
  jmp __alltraps
  102211:	e9 7a fc ff ff       	jmp    101e90 <__alltraps>

00102216 <vector98>:
.globl vector98
vector98:
  pushl $0
  102216:	6a 00                	push   $0x0
  pushl $98
  102218:	6a 62                	push   $0x62
  jmp __alltraps
  10221a:	e9 71 fc ff ff       	jmp    101e90 <__alltraps>

0010221f <vector99>:
.globl vector99
vector99:
  pushl $0
  10221f:	6a 00                	push   $0x0
  pushl $99
  102221:	6a 63                	push   $0x63
  jmp __alltraps
  102223:	e9 68 fc ff ff       	jmp    101e90 <__alltraps>

00102228 <vector100>:
.globl vector100
vector100:
  pushl $0
  102228:	6a 00                	push   $0x0
  pushl $100
  10222a:	6a 64                	push   $0x64
  jmp __alltraps
  10222c:	e9 5f fc ff ff       	jmp    101e90 <__alltraps>

00102231 <vector101>:
.globl vector101
vector101:
  pushl $0
  102231:	6a 00                	push   $0x0
  pushl $101
  102233:	6a 65                	push   $0x65
  jmp __alltraps
  102235:	e9 56 fc ff ff       	jmp    101e90 <__alltraps>

0010223a <vector102>:
.globl vector102
vector102:
  pushl $0
  10223a:	6a 00                	push   $0x0
  pushl $102
  10223c:	6a 66                	push   $0x66
  jmp __alltraps
  10223e:	e9 4d fc ff ff       	jmp    101e90 <__alltraps>

00102243 <vector103>:
.globl vector103
vector103:
  pushl $0
  102243:	6a 00                	push   $0x0
  pushl $103
  102245:	6a 67                	push   $0x67
  jmp __alltraps
  102247:	e9 44 fc ff ff       	jmp    101e90 <__alltraps>

0010224c <vector104>:
.globl vector104
vector104:
  pushl $0
  10224c:	6a 00                	push   $0x0
  pushl $104
  10224e:	6a 68                	push   $0x68
  jmp __alltraps
  102250:	e9 3b fc ff ff       	jmp    101e90 <__alltraps>

00102255 <vector105>:
.globl vector105
vector105:
  pushl $0
  102255:	6a 00                	push   $0x0
  pushl $105
  102257:	6a 69                	push   $0x69
  jmp __alltraps
  102259:	e9 32 fc ff ff       	jmp    101e90 <__alltraps>

0010225e <vector106>:
.globl vector106
vector106:
  pushl $0
  10225e:	6a 00                	push   $0x0
  pushl $106
  102260:	6a 6a                	push   $0x6a
  jmp __alltraps
  102262:	e9 29 fc ff ff       	jmp    101e90 <__alltraps>

00102267 <vector107>:
.globl vector107
vector107:
  pushl $0
  102267:	6a 00                	push   $0x0
  pushl $107
  102269:	6a 6b                	push   $0x6b
  jmp __alltraps
  10226b:	e9 20 fc ff ff       	jmp    101e90 <__alltraps>

00102270 <vector108>:
.globl vector108
vector108:
  pushl $0
  102270:	6a 00                	push   $0x0
  pushl $108
  102272:	6a 6c                	push   $0x6c
  jmp __alltraps
  102274:	e9 17 fc ff ff       	jmp    101e90 <__alltraps>

00102279 <vector109>:
.globl vector109
vector109:
  pushl $0
  102279:	6a 00                	push   $0x0
  pushl $109
  10227b:	6a 6d                	push   $0x6d
  jmp __alltraps
  10227d:	e9 0e fc ff ff       	jmp    101e90 <__alltraps>

00102282 <vector110>:
.globl vector110
vector110:
  pushl $0
  102282:	6a 00                	push   $0x0
  pushl $110
  102284:	6a 6e                	push   $0x6e
  jmp __alltraps
  102286:	e9 05 fc ff ff       	jmp    101e90 <__alltraps>

0010228b <vector111>:
.globl vector111
vector111:
  pushl $0
  10228b:	6a 00                	push   $0x0
  pushl $111
  10228d:	6a 6f                	push   $0x6f
  jmp __alltraps
  10228f:	e9 fc fb ff ff       	jmp    101e90 <__alltraps>

00102294 <vector112>:
.globl vector112
vector112:
  pushl $0
  102294:	6a 00                	push   $0x0
  pushl $112
  102296:	6a 70                	push   $0x70
  jmp __alltraps
  102298:	e9 f3 fb ff ff       	jmp    101e90 <__alltraps>

0010229d <vector113>:
.globl vector113
vector113:
  pushl $0
  10229d:	6a 00                	push   $0x0
  pushl $113
  10229f:	6a 71                	push   $0x71
  jmp __alltraps
  1022a1:	e9 ea fb ff ff       	jmp    101e90 <__alltraps>

001022a6 <vector114>:
.globl vector114
vector114:
  pushl $0
  1022a6:	6a 00                	push   $0x0
  pushl $114
  1022a8:	6a 72                	push   $0x72
  jmp __alltraps
  1022aa:	e9 e1 fb ff ff       	jmp    101e90 <__alltraps>

001022af <vector115>:
.globl vector115
vector115:
  pushl $0
  1022af:	6a 00                	push   $0x0
  pushl $115
  1022b1:	6a 73                	push   $0x73
  jmp __alltraps
  1022b3:	e9 d8 fb ff ff       	jmp    101e90 <__alltraps>

001022b8 <vector116>:
.globl vector116
vector116:
  pushl $0
  1022b8:	6a 00                	push   $0x0
  pushl $116
  1022ba:	6a 74                	push   $0x74
  jmp __alltraps
  1022bc:	e9 cf fb ff ff       	jmp    101e90 <__alltraps>

001022c1 <vector117>:
.globl vector117
vector117:
  pushl $0
  1022c1:	6a 00                	push   $0x0
  pushl $117
  1022c3:	6a 75                	push   $0x75
  jmp __alltraps
  1022c5:	e9 c6 fb ff ff       	jmp    101e90 <__alltraps>

001022ca <vector118>:
.globl vector118
vector118:
  pushl $0
  1022ca:	6a 00                	push   $0x0
  pushl $118
  1022cc:	6a 76                	push   $0x76
  jmp __alltraps
  1022ce:	e9 bd fb ff ff       	jmp    101e90 <__alltraps>

001022d3 <vector119>:
.globl vector119
vector119:
  pushl $0
  1022d3:	6a 00                	push   $0x0
  pushl $119
  1022d5:	6a 77                	push   $0x77
  jmp __alltraps
  1022d7:	e9 b4 fb ff ff       	jmp    101e90 <__alltraps>

001022dc <vector120>:
.globl vector120
vector120:
  pushl $0
  1022dc:	6a 00                	push   $0x0
  pushl $120
  1022de:	6a 78                	push   $0x78
  jmp __alltraps
  1022e0:	e9 ab fb ff ff       	jmp    101e90 <__alltraps>

001022e5 <vector121>:
.globl vector121
vector121:
  pushl $0
  1022e5:	6a 00                	push   $0x0
  pushl $121
  1022e7:	6a 79                	push   $0x79
  jmp __alltraps
  1022e9:	e9 a2 fb ff ff       	jmp    101e90 <__alltraps>

001022ee <vector122>:
.globl vector122
vector122:
  pushl $0
  1022ee:	6a 00                	push   $0x0
  pushl $122
  1022f0:	6a 7a                	push   $0x7a
  jmp __alltraps
  1022f2:	e9 99 fb ff ff       	jmp    101e90 <__alltraps>

001022f7 <vector123>:
.globl vector123
vector123:
  pushl $0
  1022f7:	6a 00                	push   $0x0
  pushl $123
  1022f9:	6a 7b                	push   $0x7b
  jmp __alltraps
  1022fb:	e9 90 fb ff ff       	jmp    101e90 <__alltraps>

00102300 <vector124>:
.globl vector124
vector124:
  pushl $0
  102300:	6a 00                	push   $0x0
  pushl $124
  102302:	6a 7c                	push   $0x7c
  jmp __alltraps
  102304:	e9 87 fb ff ff       	jmp    101e90 <__alltraps>

00102309 <vector125>:
.globl vector125
vector125:
  pushl $0
  102309:	6a 00                	push   $0x0
  pushl $125
  10230b:	6a 7d                	push   $0x7d
  jmp __alltraps
  10230d:	e9 7e fb ff ff       	jmp    101e90 <__alltraps>

00102312 <vector126>:
.globl vector126
vector126:
  pushl $0
  102312:	6a 00                	push   $0x0
  pushl $126
  102314:	6a 7e                	push   $0x7e
  jmp __alltraps
  102316:	e9 75 fb ff ff       	jmp    101e90 <__alltraps>

0010231b <vector127>:
.globl vector127
vector127:
  pushl $0
  10231b:	6a 00                	push   $0x0
  pushl $127
  10231d:	6a 7f                	push   $0x7f
  jmp __alltraps
  10231f:	e9 6c fb ff ff       	jmp    101e90 <__alltraps>

00102324 <vector128>:
.globl vector128
vector128:
  pushl $0
  102324:	6a 00                	push   $0x0
  pushl $128
  102326:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
  10232b:	e9 60 fb ff ff       	jmp    101e90 <__alltraps>

00102330 <vector129>:
.globl vector129
vector129:
  pushl $0
  102330:	6a 00                	push   $0x0
  pushl $129
  102332:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
  102337:	e9 54 fb ff ff       	jmp    101e90 <__alltraps>

0010233c <vector130>:
.globl vector130
vector130:
  pushl $0
  10233c:	6a 00                	push   $0x0
  pushl $130
  10233e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
  102343:	e9 48 fb ff ff       	jmp    101e90 <__alltraps>

00102348 <vector131>:
.globl vector131
vector131:
  pushl $0
  102348:	6a 00                	push   $0x0
  pushl $131
  10234a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
  10234f:	e9 3c fb ff ff       	jmp    101e90 <__alltraps>

00102354 <vector132>:
.globl vector132
vector132:
  pushl $0
  102354:	6a 00                	push   $0x0
  pushl $132
  102356:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
  10235b:	e9 30 fb ff ff       	jmp    101e90 <__alltraps>

00102360 <vector133>:
.globl vector133
vector133:
  pushl $0
  102360:	6a 00                	push   $0x0
  pushl $133
  102362:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
  102367:	e9 24 fb ff ff       	jmp    101e90 <__alltraps>

0010236c <vector134>:
.globl vector134
vector134:
  pushl $0
  10236c:	6a 00                	push   $0x0
  pushl $134
  10236e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
  102373:	e9 18 fb ff ff       	jmp    101e90 <__alltraps>

00102378 <vector135>:
.globl vector135
vector135:
  pushl $0
  102378:	6a 00                	push   $0x0
  pushl $135
  10237a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
  10237f:	e9 0c fb ff ff       	jmp    101e90 <__alltraps>

00102384 <vector136>:
.globl vector136
vector136:
  pushl $0
  102384:	6a 00                	push   $0x0
  pushl $136
  102386:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
  10238b:	e9 00 fb ff ff       	jmp    101e90 <__alltraps>

00102390 <vector137>:
.globl vector137
vector137:
  pushl $0
  102390:	6a 00                	push   $0x0
  pushl $137
  102392:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
  102397:	e9 f4 fa ff ff       	jmp    101e90 <__alltraps>

0010239c <vector138>:
.globl vector138
vector138:
  pushl $0
  10239c:	6a 00                	push   $0x0
  pushl $138
  10239e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
  1023a3:	e9 e8 fa ff ff       	jmp    101e90 <__alltraps>

001023a8 <vector139>:
.globl vector139
vector139:
  pushl $0
  1023a8:	6a 00                	push   $0x0
  pushl $139
  1023aa:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
  1023af:	e9 dc fa ff ff       	jmp    101e90 <__alltraps>

001023b4 <vector140>:
.globl vector140
vector140:
  pushl $0
  1023b4:	6a 00                	push   $0x0
  pushl $140
  1023b6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
  1023bb:	e9 d0 fa ff ff       	jmp    101e90 <__alltraps>

001023c0 <vector141>:
.globl vector141
vector141:
  pushl $0
  1023c0:	6a 00                	push   $0x0
  pushl $141
  1023c2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
  1023c7:	e9 c4 fa ff ff       	jmp    101e90 <__alltraps>

001023cc <vector142>:
.globl vector142
vector142:
  pushl $0
  1023cc:	6a 00                	push   $0x0
  pushl $142
  1023ce:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
  1023d3:	e9 b8 fa ff ff       	jmp    101e90 <__alltraps>

001023d8 <vector143>:
.globl vector143
vector143:
  pushl $0
  1023d8:	6a 00                	push   $0x0
  pushl $143
  1023da:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
  1023df:	e9 ac fa ff ff       	jmp    101e90 <__alltraps>

001023e4 <vector144>:
.globl vector144
vector144:
  pushl $0
  1023e4:	6a 00                	push   $0x0
  pushl $144
  1023e6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
  1023eb:	e9 a0 fa ff ff       	jmp    101e90 <__alltraps>

001023f0 <vector145>:
.globl vector145
vector145:
  pushl $0
  1023f0:	6a 00                	push   $0x0
  pushl $145
  1023f2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
  1023f7:	e9 94 fa ff ff       	jmp    101e90 <__alltraps>

001023fc <vector146>:
.globl vector146
vector146:
  pushl $0
  1023fc:	6a 00                	push   $0x0
  pushl $146
  1023fe:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
  102403:	e9 88 fa ff ff       	jmp    101e90 <__alltraps>

00102408 <vector147>:
.globl vector147
vector147:
  pushl $0
  102408:	6a 00                	push   $0x0
  pushl $147
  10240a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
  10240f:	e9 7c fa ff ff       	jmp    101e90 <__alltraps>

00102414 <vector148>:
.globl vector148
vector148:
  pushl $0
  102414:	6a 00                	push   $0x0
  pushl $148
  102416:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
  10241b:	e9 70 fa ff ff       	jmp    101e90 <__alltraps>

00102420 <vector149>:
.globl vector149
vector149:
  pushl $0
  102420:	6a 00                	push   $0x0
  pushl $149
  102422:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
  102427:	e9 64 fa ff ff       	jmp    101e90 <__alltraps>

0010242c <vector150>:
.globl vector150
vector150:
  pushl $0
  10242c:	6a 00                	push   $0x0
  pushl $150
  10242e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
  102433:	e9 58 fa ff ff       	jmp    101e90 <__alltraps>

00102438 <vector151>:
.globl vector151
vector151:
  pushl $0
  102438:	6a 00                	push   $0x0
  pushl $151
  10243a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
  10243f:	e9 4c fa ff ff       	jmp    101e90 <__alltraps>

00102444 <vector152>:
.globl vector152
vector152:
  pushl $0
  102444:	6a 00                	push   $0x0
  pushl $152
  102446:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
  10244b:	e9 40 fa ff ff       	jmp    101e90 <__alltraps>

00102450 <vector153>:
.globl vector153
vector153:
  pushl $0
  102450:	6a 00                	push   $0x0
  pushl $153
  102452:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
  102457:	e9 34 fa ff ff       	jmp    101e90 <__alltraps>

0010245c <vector154>:
.globl vector154
vector154:
  pushl $0
  10245c:	6a 00                	push   $0x0
  pushl $154
  10245e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
  102463:	e9 28 fa ff ff       	jmp    101e90 <__alltraps>

00102468 <vector155>:
.globl vector155
vector155:
  pushl $0
  102468:	6a 00                	push   $0x0
  pushl $155
  10246a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
  10246f:	e9 1c fa ff ff       	jmp    101e90 <__alltraps>

00102474 <vector156>:
.globl vector156
vector156:
  pushl $0
  102474:	6a 00                	push   $0x0
  pushl $156
  102476:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
  10247b:	e9 10 fa ff ff       	jmp    101e90 <__alltraps>

00102480 <vector157>:
.globl vector157
vector157:
  pushl $0
  102480:	6a 00                	push   $0x0
  pushl $157
  102482:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
  102487:	e9 04 fa ff ff       	jmp    101e90 <__alltraps>

0010248c <vector158>:
.globl vector158
vector158:
  pushl $0
  10248c:	6a 00                	push   $0x0
  pushl $158
  10248e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
  102493:	e9 f8 f9 ff ff       	jmp    101e90 <__alltraps>

00102498 <vector159>:
.globl vector159
vector159:
  pushl $0
  102498:	6a 00                	push   $0x0
  pushl $159
  10249a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
  10249f:	e9 ec f9 ff ff       	jmp    101e90 <__alltraps>

001024a4 <vector160>:
.globl vector160
vector160:
  pushl $0
  1024a4:	6a 00                	push   $0x0
  pushl $160
  1024a6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
  1024ab:	e9 e0 f9 ff ff       	jmp    101e90 <__alltraps>

001024b0 <vector161>:
.globl vector161
vector161:
  pushl $0
  1024b0:	6a 00                	push   $0x0
  pushl $161
  1024b2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
  1024b7:	e9 d4 f9 ff ff       	jmp    101e90 <__alltraps>

001024bc <vector162>:
.globl vector162
vector162:
  pushl $0
  1024bc:	6a 00                	push   $0x0
  pushl $162
  1024be:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
  1024c3:	e9 c8 f9 ff ff       	jmp    101e90 <__alltraps>

001024c8 <vector163>:
.globl vector163
vector163:
  pushl $0
  1024c8:	6a 00                	push   $0x0
  pushl $163
  1024ca:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
  1024cf:	e9 bc f9 ff ff       	jmp    101e90 <__alltraps>

001024d4 <vector164>:
.globl vector164
vector164:
  pushl $0
  1024d4:	6a 00                	push   $0x0
  pushl $164
  1024d6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
  1024db:	e9 b0 f9 ff ff       	jmp    101e90 <__alltraps>

001024e0 <vector165>:
.globl vector165
vector165:
  pushl $0
  1024e0:	6a 00                	push   $0x0
  pushl $165
  1024e2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
  1024e7:	e9 a4 f9 ff ff       	jmp    101e90 <__alltraps>

001024ec <vector166>:
.globl vector166
vector166:
  pushl $0
  1024ec:	6a 00                	push   $0x0
  pushl $166
  1024ee:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
  1024f3:	e9 98 f9 ff ff       	jmp    101e90 <__alltraps>

001024f8 <vector167>:
.globl vector167
vector167:
  pushl $0
  1024f8:	6a 00                	push   $0x0
  pushl $167
  1024fa:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
  1024ff:	e9 8c f9 ff ff       	jmp    101e90 <__alltraps>

00102504 <vector168>:
.globl vector168
vector168:
  pushl $0
  102504:	6a 00                	push   $0x0
  pushl $168
  102506:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
  10250b:	e9 80 f9 ff ff       	jmp    101e90 <__alltraps>

00102510 <vector169>:
.globl vector169
vector169:
  pushl $0
  102510:	6a 00                	push   $0x0
  pushl $169
  102512:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
  102517:	e9 74 f9 ff ff       	jmp    101e90 <__alltraps>

0010251c <vector170>:
.globl vector170
vector170:
  pushl $0
  10251c:	6a 00                	push   $0x0
  pushl $170
  10251e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
  102523:	e9 68 f9 ff ff       	jmp    101e90 <__alltraps>

00102528 <vector171>:
.globl vector171
vector171:
  pushl $0
  102528:	6a 00                	push   $0x0
  pushl $171
  10252a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
  10252f:	e9 5c f9 ff ff       	jmp    101e90 <__alltraps>

00102534 <vector172>:
.globl vector172
vector172:
  pushl $0
  102534:	6a 00                	push   $0x0
  pushl $172
  102536:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
  10253b:	e9 50 f9 ff ff       	jmp    101e90 <__alltraps>

00102540 <vector173>:
.globl vector173
vector173:
  pushl $0
  102540:	6a 00                	push   $0x0
  pushl $173
  102542:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
  102547:	e9 44 f9 ff ff       	jmp    101e90 <__alltraps>

0010254c <vector174>:
.globl vector174
vector174:
  pushl $0
  10254c:	6a 00                	push   $0x0
  pushl $174
  10254e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
  102553:	e9 38 f9 ff ff       	jmp    101e90 <__alltraps>

00102558 <vector175>:
.globl vector175
vector175:
  pushl $0
  102558:	6a 00                	push   $0x0
  pushl $175
  10255a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
  10255f:	e9 2c f9 ff ff       	jmp    101e90 <__alltraps>

00102564 <vector176>:
.globl vector176
vector176:
  pushl $0
  102564:	6a 00                	push   $0x0
  pushl $176
  102566:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
  10256b:	e9 20 f9 ff ff       	jmp    101e90 <__alltraps>

00102570 <vector177>:
.globl vector177
vector177:
  pushl $0
  102570:	6a 00                	push   $0x0
  pushl $177
  102572:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
  102577:	e9 14 f9 ff ff       	jmp    101e90 <__alltraps>

0010257c <vector178>:
.globl vector178
vector178:
  pushl $0
  10257c:	6a 00                	push   $0x0
  pushl $178
  10257e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
  102583:	e9 08 f9 ff ff       	jmp    101e90 <__alltraps>

00102588 <vector179>:
.globl vector179
vector179:
  pushl $0
  102588:	6a 00                	push   $0x0
  pushl $179
  10258a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
  10258f:	e9 fc f8 ff ff       	jmp    101e90 <__alltraps>

00102594 <vector180>:
.globl vector180
vector180:
  pushl $0
  102594:	6a 00                	push   $0x0
  pushl $180
  102596:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
  10259b:	e9 f0 f8 ff ff       	jmp    101e90 <__alltraps>

001025a0 <vector181>:
.globl vector181
vector181:
  pushl $0
  1025a0:	6a 00                	push   $0x0
  pushl $181
  1025a2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
  1025a7:	e9 e4 f8 ff ff       	jmp    101e90 <__alltraps>

001025ac <vector182>:
.globl vector182
vector182:
  pushl $0
  1025ac:	6a 00                	push   $0x0
  pushl $182
  1025ae:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
  1025b3:	e9 d8 f8 ff ff       	jmp    101e90 <__alltraps>

001025b8 <vector183>:
.globl vector183
vector183:
  pushl $0
  1025b8:	6a 00                	push   $0x0
  pushl $183
  1025ba:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
  1025bf:	e9 cc f8 ff ff       	jmp    101e90 <__alltraps>

001025c4 <vector184>:
.globl vector184
vector184:
  pushl $0
  1025c4:	6a 00                	push   $0x0
  pushl $184
  1025c6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
  1025cb:	e9 c0 f8 ff ff       	jmp    101e90 <__alltraps>

001025d0 <vector185>:
.globl vector185
vector185:
  pushl $0
  1025d0:	6a 00                	push   $0x0
  pushl $185
  1025d2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
  1025d7:	e9 b4 f8 ff ff       	jmp    101e90 <__alltraps>

001025dc <vector186>:
.globl vector186
vector186:
  pushl $0
  1025dc:	6a 00                	push   $0x0
  pushl $186
  1025de:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
  1025e3:	e9 a8 f8 ff ff       	jmp    101e90 <__alltraps>

001025e8 <vector187>:
.globl vector187
vector187:
  pushl $0
  1025e8:	6a 00                	push   $0x0
  pushl $187
  1025ea:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
  1025ef:	e9 9c f8 ff ff       	jmp    101e90 <__alltraps>

001025f4 <vector188>:
.globl vector188
vector188:
  pushl $0
  1025f4:	6a 00                	push   $0x0
  pushl $188
  1025f6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
  1025fb:	e9 90 f8 ff ff       	jmp    101e90 <__alltraps>

00102600 <vector189>:
.globl vector189
vector189:
  pushl $0
  102600:	6a 00                	push   $0x0
  pushl $189
  102602:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
  102607:	e9 84 f8 ff ff       	jmp    101e90 <__alltraps>

0010260c <vector190>:
.globl vector190
vector190:
  pushl $0
  10260c:	6a 00                	push   $0x0
  pushl $190
  10260e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
  102613:	e9 78 f8 ff ff       	jmp    101e90 <__alltraps>

00102618 <vector191>:
.globl vector191
vector191:
  pushl $0
  102618:	6a 00                	push   $0x0
  pushl $191
  10261a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
  10261f:	e9 6c f8 ff ff       	jmp    101e90 <__alltraps>

00102624 <vector192>:
.globl vector192
vector192:
  pushl $0
  102624:	6a 00                	push   $0x0
  pushl $192
  102626:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
  10262b:	e9 60 f8 ff ff       	jmp    101e90 <__alltraps>

00102630 <vector193>:
.globl vector193
vector193:
  pushl $0
  102630:	6a 00                	push   $0x0
  pushl $193
  102632:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
  102637:	e9 54 f8 ff ff       	jmp    101e90 <__alltraps>

0010263c <vector194>:
.globl vector194
vector194:
  pushl $0
  10263c:	6a 00                	push   $0x0
  pushl $194
  10263e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
  102643:	e9 48 f8 ff ff       	jmp    101e90 <__alltraps>

00102648 <vector195>:
.globl vector195
vector195:
  pushl $0
  102648:	6a 00                	push   $0x0
  pushl $195
  10264a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
  10264f:	e9 3c f8 ff ff       	jmp    101e90 <__alltraps>

00102654 <vector196>:
.globl vector196
vector196:
  pushl $0
  102654:	6a 00                	push   $0x0
  pushl $196
  102656:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
  10265b:	e9 30 f8 ff ff       	jmp    101e90 <__alltraps>

00102660 <vector197>:
.globl vector197
vector197:
  pushl $0
  102660:	6a 00                	push   $0x0
  pushl $197
  102662:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
  102667:	e9 24 f8 ff ff       	jmp    101e90 <__alltraps>

0010266c <vector198>:
.globl vector198
vector198:
  pushl $0
  10266c:	6a 00                	push   $0x0
  pushl $198
  10266e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
  102673:	e9 18 f8 ff ff       	jmp    101e90 <__alltraps>

00102678 <vector199>:
.globl vector199
vector199:
  pushl $0
  102678:	6a 00                	push   $0x0
  pushl $199
  10267a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
  10267f:	e9 0c f8 ff ff       	jmp    101e90 <__alltraps>

00102684 <vector200>:
.globl vector200
vector200:
  pushl $0
  102684:	6a 00                	push   $0x0
  pushl $200
  102686:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
  10268b:	e9 00 f8 ff ff       	jmp    101e90 <__alltraps>

00102690 <vector201>:
.globl vector201
vector201:
  pushl $0
  102690:	6a 00                	push   $0x0
  pushl $201
  102692:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
  102697:	e9 f4 f7 ff ff       	jmp    101e90 <__alltraps>

0010269c <vector202>:
.globl vector202
vector202:
  pushl $0
  10269c:	6a 00                	push   $0x0
  pushl $202
  10269e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
  1026a3:	e9 e8 f7 ff ff       	jmp    101e90 <__alltraps>

001026a8 <vector203>:
.globl vector203
vector203:
  pushl $0
  1026a8:	6a 00                	push   $0x0
  pushl $203
  1026aa:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
  1026af:	e9 dc f7 ff ff       	jmp    101e90 <__alltraps>

001026b4 <vector204>:
.globl vector204
vector204:
  pushl $0
  1026b4:	6a 00                	push   $0x0
  pushl $204
  1026b6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
  1026bb:	e9 d0 f7 ff ff       	jmp    101e90 <__alltraps>

001026c0 <vector205>:
.globl vector205
vector205:
  pushl $0
  1026c0:	6a 00                	push   $0x0
  pushl $205
  1026c2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
  1026c7:	e9 c4 f7 ff ff       	jmp    101e90 <__alltraps>

001026cc <vector206>:
.globl vector206
vector206:
  pushl $0
  1026cc:	6a 00                	push   $0x0
  pushl $206
  1026ce:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
  1026d3:	e9 b8 f7 ff ff       	jmp    101e90 <__alltraps>

001026d8 <vector207>:
.globl vector207
vector207:
  pushl $0
  1026d8:	6a 00                	push   $0x0
  pushl $207
  1026da:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
  1026df:	e9 ac f7 ff ff       	jmp    101e90 <__alltraps>

001026e4 <vector208>:
.globl vector208
vector208:
  pushl $0
  1026e4:	6a 00                	push   $0x0
  pushl $208
  1026e6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
  1026eb:	e9 a0 f7 ff ff       	jmp    101e90 <__alltraps>

001026f0 <vector209>:
.globl vector209
vector209:
  pushl $0
  1026f0:	6a 00                	push   $0x0
  pushl $209
  1026f2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
  1026f7:	e9 94 f7 ff ff       	jmp    101e90 <__alltraps>

001026fc <vector210>:
.globl vector210
vector210:
  pushl $0
  1026fc:	6a 00                	push   $0x0
  pushl $210
  1026fe:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
  102703:	e9 88 f7 ff ff       	jmp    101e90 <__alltraps>

00102708 <vector211>:
.globl vector211
vector211:
  pushl $0
  102708:	6a 00                	push   $0x0
  pushl $211
  10270a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
  10270f:	e9 7c f7 ff ff       	jmp    101e90 <__alltraps>

00102714 <vector212>:
.globl vector212
vector212:
  pushl $0
  102714:	6a 00                	push   $0x0
  pushl $212
  102716:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
  10271b:	e9 70 f7 ff ff       	jmp    101e90 <__alltraps>

00102720 <vector213>:
.globl vector213
vector213:
  pushl $0
  102720:	6a 00                	push   $0x0
  pushl $213
  102722:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
  102727:	e9 64 f7 ff ff       	jmp    101e90 <__alltraps>

0010272c <vector214>:
.globl vector214
vector214:
  pushl $0
  10272c:	6a 00                	push   $0x0
  pushl $214
  10272e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
  102733:	e9 58 f7 ff ff       	jmp    101e90 <__alltraps>

00102738 <vector215>:
.globl vector215
vector215:
  pushl $0
  102738:	6a 00                	push   $0x0
  pushl $215
  10273a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
  10273f:	e9 4c f7 ff ff       	jmp    101e90 <__alltraps>

00102744 <vector216>:
.globl vector216
vector216:
  pushl $0
  102744:	6a 00                	push   $0x0
  pushl $216
  102746:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
  10274b:	e9 40 f7 ff ff       	jmp    101e90 <__alltraps>

00102750 <vector217>:
.globl vector217
vector217:
  pushl $0
  102750:	6a 00                	push   $0x0
  pushl $217
  102752:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
  102757:	e9 34 f7 ff ff       	jmp    101e90 <__alltraps>

0010275c <vector218>:
.globl vector218
vector218:
  pushl $0
  10275c:	6a 00                	push   $0x0
  pushl $218
  10275e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
  102763:	e9 28 f7 ff ff       	jmp    101e90 <__alltraps>

00102768 <vector219>:
.globl vector219
vector219:
  pushl $0
  102768:	6a 00                	push   $0x0
  pushl $219
  10276a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
  10276f:	e9 1c f7 ff ff       	jmp    101e90 <__alltraps>

00102774 <vector220>:
.globl vector220
vector220:
  pushl $0
  102774:	6a 00                	push   $0x0
  pushl $220
  102776:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
  10277b:	e9 10 f7 ff ff       	jmp    101e90 <__alltraps>

00102780 <vector221>:
.globl vector221
vector221:
  pushl $0
  102780:	6a 00                	push   $0x0
  pushl $221
  102782:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
  102787:	e9 04 f7 ff ff       	jmp    101e90 <__alltraps>

0010278c <vector222>:
.globl vector222
vector222:
  pushl $0
  10278c:	6a 00                	push   $0x0
  pushl $222
  10278e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
  102793:	e9 f8 f6 ff ff       	jmp    101e90 <__alltraps>

00102798 <vector223>:
.globl vector223
vector223:
  pushl $0
  102798:	6a 00                	push   $0x0
  pushl $223
  10279a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
  10279f:	e9 ec f6 ff ff       	jmp    101e90 <__alltraps>

001027a4 <vector224>:
.globl vector224
vector224:
  pushl $0
  1027a4:	6a 00                	push   $0x0
  pushl $224
  1027a6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
  1027ab:	e9 e0 f6 ff ff       	jmp    101e90 <__alltraps>

001027b0 <vector225>:
.globl vector225
vector225:
  pushl $0
  1027b0:	6a 00                	push   $0x0
  pushl $225
  1027b2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
  1027b7:	e9 d4 f6 ff ff       	jmp    101e90 <__alltraps>

001027bc <vector226>:
.globl vector226
vector226:
  pushl $0
  1027bc:	6a 00                	push   $0x0
  pushl $226
  1027be:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
  1027c3:	e9 c8 f6 ff ff       	jmp    101e90 <__alltraps>

001027c8 <vector227>:
.globl vector227
vector227:
  pushl $0
  1027c8:	6a 00                	push   $0x0
  pushl $227
  1027ca:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
  1027cf:	e9 bc f6 ff ff       	jmp    101e90 <__alltraps>

001027d4 <vector228>:
.globl vector228
vector228:
  pushl $0
  1027d4:	6a 00                	push   $0x0
  pushl $228
  1027d6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
  1027db:	e9 b0 f6 ff ff       	jmp    101e90 <__alltraps>

001027e0 <vector229>:
.globl vector229
vector229:
  pushl $0
  1027e0:	6a 00                	push   $0x0
  pushl $229
  1027e2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
  1027e7:	e9 a4 f6 ff ff       	jmp    101e90 <__alltraps>

001027ec <vector230>:
.globl vector230
vector230:
  pushl $0
  1027ec:	6a 00                	push   $0x0
  pushl $230
  1027ee:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
  1027f3:	e9 98 f6 ff ff       	jmp    101e90 <__alltraps>

001027f8 <vector231>:
.globl vector231
vector231:
  pushl $0
  1027f8:	6a 00                	push   $0x0
  pushl $231
  1027fa:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
  1027ff:	e9 8c f6 ff ff       	jmp    101e90 <__alltraps>

00102804 <vector232>:
.globl vector232
vector232:
  pushl $0
  102804:	6a 00                	push   $0x0
  pushl $232
  102806:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
  10280b:	e9 80 f6 ff ff       	jmp    101e90 <__alltraps>

00102810 <vector233>:
.globl vector233
vector233:
  pushl $0
  102810:	6a 00                	push   $0x0
  pushl $233
  102812:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
  102817:	e9 74 f6 ff ff       	jmp    101e90 <__alltraps>

0010281c <vector234>:
.globl vector234
vector234:
  pushl $0
  10281c:	6a 00                	push   $0x0
  pushl $234
  10281e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
  102823:	e9 68 f6 ff ff       	jmp    101e90 <__alltraps>

00102828 <vector235>:
.globl vector235
vector235:
  pushl $0
  102828:	6a 00                	push   $0x0
  pushl $235
  10282a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
  10282f:	e9 5c f6 ff ff       	jmp    101e90 <__alltraps>

00102834 <vector236>:
.globl vector236
vector236:
  pushl $0
  102834:	6a 00                	push   $0x0
  pushl $236
  102836:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
  10283b:	e9 50 f6 ff ff       	jmp    101e90 <__alltraps>

00102840 <vector237>:
.globl vector237
vector237:
  pushl $0
  102840:	6a 00                	push   $0x0
  pushl $237
  102842:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
  102847:	e9 44 f6 ff ff       	jmp    101e90 <__alltraps>

0010284c <vector238>:
.globl vector238
vector238:
  pushl $0
  10284c:	6a 00                	push   $0x0
  pushl $238
  10284e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
  102853:	e9 38 f6 ff ff       	jmp    101e90 <__alltraps>

00102858 <vector239>:
.globl vector239
vector239:
  pushl $0
  102858:	6a 00                	push   $0x0
  pushl $239
  10285a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
  10285f:	e9 2c f6 ff ff       	jmp    101e90 <__alltraps>

00102864 <vector240>:
.globl vector240
vector240:
  pushl $0
  102864:	6a 00                	push   $0x0
  pushl $240
  102866:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
  10286b:	e9 20 f6 ff ff       	jmp    101e90 <__alltraps>

00102870 <vector241>:
.globl vector241
vector241:
  pushl $0
  102870:	6a 00                	push   $0x0
  pushl $241
  102872:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
  102877:	e9 14 f6 ff ff       	jmp    101e90 <__alltraps>

0010287c <vector242>:
.globl vector242
vector242:
  pushl $0
  10287c:	6a 00                	push   $0x0
  pushl $242
  10287e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
  102883:	e9 08 f6 ff ff       	jmp    101e90 <__alltraps>

00102888 <vector243>:
.globl vector243
vector243:
  pushl $0
  102888:	6a 00                	push   $0x0
  pushl $243
  10288a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
  10288f:	e9 fc f5 ff ff       	jmp    101e90 <__alltraps>

00102894 <vector244>:
.globl vector244
vector244:
  pushl $0
  102894:	6a 00                	push   $0x0
  pushl $244
  102896:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
  10289b:	e9 f0 f5 ff ff       	jmp    101e90 <__alltraps>

001028a0 <vector245>:
.globl vector245
vector245:
  pushl $0
  1028a0:	6a 00                	push   $0x0
  pushl $245
  1028a2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
  1028a7:	e9 e4 f5 ff ff       	jmp    101e90 <__alltraps>

001028ac <vector246>:
.globl vector246
vector246:
  pushl $0
  1028ac:	6a 00                	push   $0x0
  pushl $246
  1028ae:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
  1028b3:	e9 d8 f5 ff ff       	jmp    101e90 <__alltraps>

001028b8 <vector247>:
.globl vector247
vector247:
  pushl $0
  1028b8:	6a 00                	push   $0x0
  pushl $247
  1028ba:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
  1028bf:	e9 cc f5 ff ff       	jmp    101e90 <__alltraps>

001028c4 <vector248>:
.globl vector248
vector248:
  pushl $0
  1028c4:	6a 00                	push   $0x0
  pushl $248
  1028c6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
  1028cb:	e9 c0 f5 ff ff       	jmp    101e90 <__alltraps>

001028d0 <vector249>:
.globl vector249
vector249:
  pushl $0
  1028d0:	6a 00                	push   $0x0
  pushl $249
  1028d2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
  1028d7:	e9 b4 f5 ff ff       	jmp    101e90 <__alltraps>

001028dc <vector250>:
.globl vector250
vector250:
  pushl $0
  1028dc:	6a 00                	push   $0x0
  pushl $250
  1028de:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
  1028e3:	e9 a8 f5 ff ff       	jmp    101e90 <__alltraps>

001028e8 <vector251>:
.globl vector251
vector251:
  pushl $0
  1028e8:	6a 00                	push   $0x0
  pushl $251
  1028ea:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
  1028ef:	e9 9c f5 ff ff       	jmp    101e90 <__alltraps>

001028f4 <vector252>:
.globl vector252
vector252:
  pushl $0
  1028f4:	6a 00                	push   $0x0
  pushl $252
  1028f6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
  1028fb:	e9 90 f5 ff ff       	jmp    101e90 <__alltraps>

00102900 <vector253>:
.globl vector253
vector253:
  pushl $0
  102900:	6a 00                	push   $0x0
  pushl $253
  102902:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
  102907:	e9 84 f5 ff ff       	jmp    101e90 <__alltraps>

0010290c <vector254>:
.globl vector254
vector254:
  pushl $0
  10290c:	6a 00                	push   $0x0
  pushl $254
  10290e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
  102913:	e9 78 f5 ff ff       	jmp    101e90 <__alltraps>

00102918 <vector255>:
.globl vector255
vector255:
  pushl $0
  102918:	6a 00                	push   $0x0
  pushl $255
  10291a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
  10291f:	e9 6c f5 ff ff       	jmp    101e90 <__alltraps>

00102924 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  102924:	55                   	push   %ebp
  102925:	89 e5                	mov    %esp,%ebp
    return page - pages;
  102927:	8b 55 08             	mov    0x8(%ebp),%edx
  10292a:	a1 64 99 11 00       	mov    0x119964,%eax
  10292f:	89 d1                	mov    %edx,%ecx
  102931:	29 c1                	sub    %eax,%ecx
  102933:	89 c8                	mov    %ecx,%eax
  102935:	c1 f8 02             	sar    $0x2,%eax
  102938:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  10293e:	5d                   	pop    %ebp
  10293f:	c3                   	ret    

00102940 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  102940:	55                   	push   %ebp
  102941:	89 e5                	mov    %esp,%ebp
  102943:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  102946:	8b 45 08             	mov    0x8(%ebp),%eax
  102949:	89 04 24             	mov    %eax,(%esp)
  10294c:	e8 d3 ff ff ff       	call   102924 <page2ppn>
  102951:	c1 e0 0c             	shl    $0xc,%eax
}
  102954:	c9                   	leave  
  102955:	c3                   	ret    

00102956 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
  102956:	55                   	push   %ebp
  102957:	89 e5                	mov    %esp,%ebp
    return page->ref;
  102959:	8b 45 08             	mov    0x8(%ebp),%eax
  10295c:	8b 00                	mov    (%eax),%eax
}
  10295e:	5d                   	pop    %ebp
  10295f:	c3                   	ret    

00102960 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  102960:	55                   	push   %ebp
  102961:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  102963:	8b 45 08             	mov    0x8(%ebp),%eax
  102966:	8b 55 0c             	mov    0xc(%ebp),%edx
  102969:	89 10                	mov    %edx,(%eax)
}
  10296b:	5d                   	pop    %ebp
  10296c:	c3                   	ret    

0010296d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
  10296d:	55                   	push   %ebp
  10296e:	89 e5                	mov    %esp,%ebp
  102970:	83 ec 10             	sub    $0x10,%esp
  102973:	c7 45 fc 50 99 11 00 	movl   $0x119950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10297a:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10297d:	8b 55 fc             	mov    -0x4(%ebp),%edx
  102980:	89 50 04             	mov    %edx,0x4(%eax)
  102983:	8b 45 fc             	mov    -0x4(%ebp),%eax
  102986:	8b 50 04             	mov    0x4(%eax),%edx
  102989:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10298c:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
  10298e:	c7 05 58 99 11 00 00 	movl   $0x0,0x119958
  102995:	00 00 00 
}
  102998:	c9                   	leave  
  102999:	c3                   	ret    

0010299a <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
  10299a:	55                   	push   %ebp
  10299b:	89 e5                	mov    %esp,%ebp
  10299d:	53                   	push   %ebx
  10299e:	83 ec 74             	sub    $0x74,%esp
    assert(n > 0);
  1029a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1029a5:	75 24                	jne    1029cb <default_init_memmap+0x31>
  1029a7:	c7 44 24 0c 90 69 10 	movl   $0x106990,0xc(%esp)
  1029ae:	00 
  1029af:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1029b6:	00 
  1029b7:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
  1029be:	00 
  1029bf:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1029c6:	e8 dd e2 ff ff       	call   100ca8 <__panic>
    struct Page *p = base +1;
  1029cb:	8b 45 08             	mov    0x8(%ebp),%eax
  1029ce:	83 c0 14             	add    $0x14,%eax
  1029d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p < base + n; ++ p) {
  1029d4:	e9 c0 00 00 00       	jmp    102a99 <default_init_memmap+0xff>
        assert(PageReserved(p));
  1029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1029dc:	83 c0 04             	add    $0x4,%eax
  1029df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  1029e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1029e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1029ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1029ef:	0f a3 10             	bt     %edx,(%eax)
  1029f2:	19 db                	sbb    %ebx,%ebx
  1029f4:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    return oldbit != 0;
  1029f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1029fb:	0f 95 c0             	setne  %al
  1029fe:	0f b6 c0             	movzbl %al,%eax
  102a01:	85 c0                	test   %eax,%eax
  102a03:	75 24                	jne    102a29 <default_init_memmap+0x8f>
  102a05:	c7 44 24 0c c1 69 10 	movl   $0x1069c1,0xc(%esp)
  102a0c:	00 
  102a0d:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  102a14:	00 
  102a15:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
  102a1c:	00 
  102a1d:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  102a24:	e8 7f e2 ff ff       	call   100ca8 <__panic>
        ClearPageReserved(p);
  102a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a2c:	83 c0 04             	add    $0x4,%eax
  102a2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
  102a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102a3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  102a3f:	0f b3 10             	btr    %edx,(%eax)
        ClearPageProperty(p);        
  102a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a45:	83 c0 04             	add    $0x4,%eax
  102a48:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
  102a4f:	89 45 d8             	mov    %eax,-0x28(%ebp)
  102a52:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102a55:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102a58:	0f b3 10             	btr    %edx,(%eax)
	p->property = 0;
  102a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
  102a65:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102a6c:	00 
  102a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a70:	89 04 24             	mov    %eax,(%esp)
  102a73:	e8 e8 fe ff ff       	call   102960 <set_page_ref>
	list_init(&(p->page_link));
  102a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102a7b:	83 c0 0c             	add    $0xc,%eax
  102a7e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
  102a81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102a87:	89 50 04             	mov    %edx,0x4(%eax)
  102a8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a8d:	8b 50 04             	mov    0x4(%eax),%edx
  102a90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102a93:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base +1;
    for (; p < base + n; ++ p) {
  102a95:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
  102a99:	8b 55 0c             	mov    0xc(%ebp),%edx
  102a9c:	89 d0                	mov    %edx,%eax
  102a9e:	c1 e0 02             	shl    $0x2,%eax
  102aa1:	01 d0                	add    %edx,%eax
  102aa3:	c1 e0 02             	shl    $0x2,%eax
  102aa6:	03 45 08             	add    0x8(%ebp),%eax
  102aa9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  102aac:	0f 87 27 ff ff ff    	ja     1029d9 <default_init_memmap+0x3f>
        ClearPageProperty(p);        
	p->property = 0;
        set_page_ref(p, 0);
	list_init(&(p->page_link));
    }
    assert(PageReserved(base));
  102ab2:	8b 45 08             	mov    0x8(%ebp),%eax
  102ab5:	83 c0 04             	add    $0x4,%eax
  102ab8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
  102abf:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102ac2:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102ac5:	8b 55 d0             	mov    -0x30(%ebp),%edx
  102ac8:	0f a3 10             	bt     %edx,(%eax)
  102acb:	19 db                	sbb    %ebx,%ebx
  102acd:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    return oldbit != 0;
  102ad0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  102ad4:	0f 95 c0             	setne  %al
  102ad7:	0f b6 c0             	movzbl %al,%eax
  102ada:	85 c0                	test   %eax,%eax
  102adc:	75 24                	jne    102b02 <default_init_memmap+0x168>
  102ade:	c7 44 24 0c d1 69 10 	movl   $0x1069d1,0xc(%esp)
  102ae5:	00 
  102ae6:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  102aed:	00 
  102aee:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
  102af5:	00 
  102af6:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  102afd:	e8 a6 e1 ff ff       	call   100ca8 <__panic>
    ClearPageReserved(base);
  102b02:	8b 45 08             	mov    0x8(%ebp),%eax
  102b05:	83 c0 04             	add    $0x4,%eax
  102b08:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
  102b0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b12:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102b15:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102b18:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  102b1b:	8b 45 08             	mov    0x8(%ebp),%eax
  102b1e:	83 c0 04             	add    $0x4,%eax
  102b21:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
  102b28:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102b2b:	8b 45 b8             	mov    -0x48(%ebp),%eax
  102b2e:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102b31:	0f ab 10             	bts    %edx,(%eax)

    base->property = n;
  102b34:	8b 45 08             	mov    0x8(%ebp),%eax
  102b37:	8b 55 0c             	mov    0xc(%ebp),%edx
  102b3a:	89 50 08             	mov    %edx,0x8(%eax)

    set_page_ref(base, 0);
  102b3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  102b44:	00 
  102b45:	8b 45 08             	mov    0x8(%ebp),%eax
  102b48:	89 04 24             	mov    %eax,(%esp)
  102b4b:	e8 10 fe ff ff       	call   102960 <set_page_ref>

    list_add_before(&free_list, &(base -> page_link)); 
  102b50:	8b 45 08             	mov    0x8(%ebp),%eax
  102b53:	83 c0 0c             	add    $0xc,%eax
  102b56:	c7 45 b4 50 99 11 00 	movl   $0x119950,-0x4c(%ebp)
  102b5d:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
  102b60:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b63:	8b 00                	mov    (%eax),%eax
  102b65:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102b68:	89 55 ac             	mov    %edx,-0x54(%ebp)
  102b6b:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102b6e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102b71:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102b74:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102b77:	8b 55 ac             	mov    -0x54(%ebp),%edx
  102b7a:	89 10                	mov    %edx,(%eax)
  102b7c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102b7f:	8b 10                	mov    (%eax),%edx
  102b81:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102b84:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102b87:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102b8a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  102b8d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102b90:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102b93:	8b 55 a8             	mov    -0x58(%ebp),%edx
  102b96:	89 10                	mov    %edx,(%eax)
    nr_free += n;
  102b98:	a1 58 99 11 00       	mov    0x119958,%eax
  102b9d:	03 45 0c             	add    0xc(%ebp),%eax
  102ba0:	a3 58 99 11 00       	mov    %eax,0x119958

}
  102ba5:	83 c4 74             	add    $0x74,%esp
  102ba8:	5b                   	pop    %ebx
  102ba9:	5d                   	pop    %ebp
  102baa:	c3                   	ret    

00102bab <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
  102bab:	55                   	push   %ebp
  102bac:	89 e5                	mov    %esp,%ebp
  102bae:	53                   	push   %ebx
  102baf:	81 ec 94 00 00 00    	sub    $0x94,%esp
    assert(n > 0);
  102bb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  102bb9:	75 24                	jne    102bdf <default_alloc_pages+0x34>
  102bbb:	c7 44 24 0c 90 69 10 	movl   $0x106990,0xc(%esp)
  102bc2:	00 
  102bc3:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  102bca:	00 
  102bcb:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
  102bd2:	00 
  102bd3:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  102bda:	e8 c9 e0 ff ff       	call   100ca8 <__panic>
    if (n > nr_free) {
  102bdf:	a1 58 99 11 00       	mov    0x119958,%eax
  102be4:	3b 45 08             	cmp    0x8(%ebp),%eax
  102be7:	73 0a                	jae    102bf3 <default_alloc_pages+0x48>
        return NULL;
  102be9:	b8 00 00 00 00       	mov    $0x0,%eax
  102bee:	e9 34 02 00 00       	jmp    102e27 <default_alloc_pages+0x27c>
    }
    struct Page *page = NULL;
  102bf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
  102bfa:	c7 45 f0 50 99 11 00 	movl   $0x119950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
  102c01:	eb 74                	jmp    102c77 <default_alloc_pages+0xcc>
        struct Page *p = le2page(le, page_link);
  102c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c06:	83 e8 0c             	sub    $0xc,%eax
  102c09:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (PageProperty(p) && !PageReserved(p) && p->property >= n) {
  102c0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c0f:	83 c0 04             	add    $0x4,%eax
  102c12:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
  102c19:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102c1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
  102c22:	0f a3 10             	bt     %edx,(%eax)
  102c25:	19 db                	sbb    %ebx,%ebx
  102c27:	89 5d d8             	mov    %ebx,-0x28(%ebp)
    return oldbit != 0;
  102c2a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
  102c2e:	0f 95 c0             	setne  %al
  102c31:	0f b6 c0             	movzbl %al,%eax
  102c34:	85 c0                	test   %eax,%eax
  102c36:	74 3f                	je     102c77 <default_alloc_pages+0xcc>
  102c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c3b:	83 c0 04             	add    $0x4,%eax
  102c3e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
  102c45:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  102c48:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102c4b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102c4e:	0f a3 10             	bt     %edx,(%eax)
  102c51:	19 db                	sbb    %ebx,%ebx
  102c53:	89 5d cc             	mov    %ebx,-0x34(%ebp)
    return oldbit != 0;
  102c56:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  102c5a:	0f 95 c0             	setne  %al
  102c5d:	0f b6 c0             	movzbl %al,%eax
  102c60:	85 c0                	test   %eax,%eax
  102c62:	75 13                	jne    102c77 <default_alloc_pages+0xcc>
  102c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c67:	8b 40 08             	mov    0x8(%eax),%eax
  102c6a:	3b 45 08             	cmp    0x8(%ebp),%eax
  102c6d:	72 08                	jb     102c77 <default_alloc_pages+0xcc>
            page = p;
  102c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
  102c75:	eb 1c                	jmp    102c93 <default_alloc_pages+0xe8>
  102c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102c7a:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102c7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102c80:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  102c83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  102c86:	81 7d f0 50 99 11 00 	cmpl   $0x119950,-0x10(%ebp)
  102c8d:	0f 85 70 ff ff ff    	jne    102c03 <default_alloc_pages+0x58>
        if (PageProperty(p) && !PageReserved(p) && p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
  102c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  102c97:	0f 84 87 01 00 00    	je     102e24 <default_alloc_pages+0x279>
	le = page->page_link.prev;        
  102c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ca0:	8b 40 0c             	mov    0xc(%eax),%eax
  102ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	list_del(&(page->page_link));
  102ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ca9:	83 c0 0c             	add    $0xc,%eax
  102cac:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102caf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102cb2:	8b 40 04             	mov    0x4(%eax),%eax
  102cb5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102cb8:	8b 12                	mov    (%edx),%edx
  102cba:	89 55 c0             	mov    %edx,-0x40(%ebp)
  102cbd:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102cc0:	8b 45 c0             	mov    -0x40(%ebp),%eax
  102cc3:	8b 55 bc             	mov    -0x44(%ebp),%edx
  102cc6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102cc9:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102ccc:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102ccf:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
  102cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102cd4:	8b 40 08             	mov    0x8(%eax),%eax
  102cd7:	3b 45 08             	cmp    0x8(%ebp),%eax
  102cda:	0f 86 aa 00 00 00    	jbe    102d8a <default_alloc_pages+0x1df>
            struct Page *p = page + n;
  102ce0:	8b 55 08             	mov    0x8(%ebp),%edx
  102ce3:	89 d0                	mov    %edx,%eax
  102ce5:	c1 e0 02             	shl    $0x2,%eax
  102ce8:	01 d0                	add    %edx,%eax
  102cea:	c1 e0 02             	shl    $0x2,%eax
  102ced:	03 45 f4             	add    -0xc(%ebp),%eax
  102cf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    ClearPageReserved(p);
  102cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102cf6:	83 c0 04             	add    $0x4,%eax
  102cf9:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
  102d00:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102d06:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102d09:	0f b3 10             	btr    %edx,(%eax)
            SetPageProperty(p);            p->property = page->property - n;
  102d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d0f:	83 c0 04             	add    $0x4,%eax
  102d12:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
  102d19:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102d1c:	8b 45 ac             	mov    -0x54(%ebp),%eax
  102d1f:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102d22:	0f ab 10             	bts    %edx,(%eax)
  102d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d28:	8b 40 08             	mov    0x8(%eax),%eax
  102d2b:	89 c2                	mov    %eax,%edx
  102d2d:	2b 55 08             	sub    0x8(%ebp),%edx
  102d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d33:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(le, &(p->page_link));
  102d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102d39:	8d 50 0c             	lea    0xc(%eax),%edx
  102d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102d3f:	89 45 a8             	mov    %eax,-0x58(%ebp)
  102d42:	89 55 a4             	mov    %edx,-0x5c(%ebp)
  102d45:	8b 45 a8             	mov    -0x58(%ebp),%eax
  102d48:	89 45 a0             	mov    %eax,-0x60(%ebp)
  102d4b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  102d4e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  102d51:	8b 45 a0             	mov    -0x60(%ebp),%eax
  102d54:	8b 40 04             	mov    0x4(%eax),%eax
  102d57:	8b 55 9c             	mov    -0x64(%ebp),%edx
  102d5a:	89 55 98             	mov    %edx,-0x68(%ebp)
  102d5d:	8b 55 a0             	mov    -0x60(%ebp),%edx
  102d60:	89 55 94             	mov    %edx,-0x6c(%ebp)
  102d63:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  102d66:	8b 45 90             	mov    -0x70(%ebp),%eax
  102d69:	8b 55 98             	mov    -0x68(%ebp),%edx
  102d6c:	89 10                	mov    %edx,(%eax)
  102d6e:	8b 45 90             	mov    -0x70(%ebp),%eax
  102d71:	8b 10                	mov    (%eax),%edx
  102d73:	8b 45 94             	mov    -0x6c(%ebp),%eax
  102d76:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  102d79:	8b 45 98             	mov    -0x68(%ebp),%eax
  102d7c:	8b 55 90             	mov    -0x70(%ebp),%edx
  102d7f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  102d82:	8b 45 98             	mov    -0x68(%ebp),%eax
  102d85:	8b 55 94             	mov    -0x6c(%ebp),%edx
  102d88:	89 10                	mov    %edx,(%eax)
    }
        struct Page *p = page;
  102d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102d8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        for (; p < page + n; ++p) {
  102d90:	eb 6c                	jmp    102dfe <default_alloc_pages+0x253>

            SetPageReserved(p);
  102d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102d95:	83 c0 04             	add    $0x4,%eax
  102d98:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
  102d9f:	89 45 88             	mov    %eax,-0x78(%ebp)
  102da2:	8b 45 88             	mov    -0x78(%ebp),%eax
  102da5:	8b 55 8c             	mov    -0x74(%ebp),%edx
  102da8:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(p);
  102dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dae:	83 c0 04             	add    $0x4,%eax
  102db1:	c7 45 84 01 00 00 00 	movl   $0x1,-0x7c(%ebp)
  102db8:	89 45 80             	mov    %eax,-0x80(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  102dbb:	8b 45 80             	mov    -0x80(%ebp),%eax
  102dbe:	8b 55 84             	mov    -0x7c(%ebp),%edx
  102dc1:	0f b3 10             	btr    %edx,(%eax)
            p->property = 0;
  102dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

            list_init(&(p->page_link));
  102dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102dd1:	83 c0 0c             	add    $0xc,%eax
  102dd4:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102dda:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102de0:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  102de6:	89 50 04             	mov    %edx,0x4(%eax)
  102de9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102def:	8b 50 04             	mov    0x4(%eax),%edx
  102df2:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
  102df8:	89 10                	mov    %edx,(%eax)
	    ClearPageReserved(p);
            SetPageProperty(p);            p->property = page->property - n;
            list_add(le, &(p->page_link));
    }
        struct Page *p = page;
        for (; p < page + n; ++p) {
  102dfa:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  102dfe:	8b 55 08             	mov    0x8(%ebp),%edx
  102e01:	89 d0                	mov    %edx,%eax
  102e03:	c1 e0 02             	shl    $0x2,%eax
  102e06:	01 d0                	add    %edx,%eax
  102e08:	c1 e0 02             	shl    $0x2,%eax
  102e0b:	03 45 f4             	add    -0xc(%ebp),%eax
  102e0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102e11:	0f 87 7b ff ff ff    	ja     102d92 <default_alloc_pages+0x1e7>
            ClearPageProperty(p);
            p->property = 0;

            list_init(&(p->page_link));
        }        
	nr_free -= n;
  102e17:	a1 58 99 11 00       	mov    0x119958,%eax
  102e1c:	2b 45 08             	sub    0x8(%ebp),%eax
  102e1f:	a3 58 99 11 00       	mov    %eax,0x119958
        
    }
    return page;
  102e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  102e27:	81 c4 94 00 00 00    	add    $0x94,%esp
  102e2d:	5b                   	pop    %ebx
  102e2e:	5d                   	pop    %ebp
  102e2f:	c3                   	ret    

00102e30 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
  102e30:	55                   	push   %ebp
  102e31:	89 e5                	mov    %esp,%ebp
  102e33:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
  102e39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  102e3d:	75 24                	jne    102e63 <default_free_pages+0x33>
  102e3f:	c7 44 24 0c 90 69 10 	movl   $0x106990,0xc(%esp)
  102e46:	00 
  102e47:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  102e4e:	00 
  102e4f:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
  102e56:	00 
  102e57:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  102e5e:	e8 45 de ff ff       	call   100ca8 <__panic>
    struct Page *p;
    list_entry_t *le = &free_list;
  102e63:	c7 45 f4 50 99 11 00 	movl   $0x119950,-0xc(%ebp)
    while((le = list_next(le)) != &free_list) {
  102e6a:	eb 11                	jmp    102e7d <default_free_pages+0x4d>
        p = le2page(le, page_link);
  102e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e6f:	83 e8 0c             	sub    $0xc,%eax
  102e72:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(p > base)
  102e75:	8b 45 e8             	mov    -0x18(%ebp),%eax
  102e78:	3b 45 08             	cmp    0x8(%ebp),%eax
  102e7b:	77 1a                	ja     102e97 <default_free_pages+0x67>
            break;
  102e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102e80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  102e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  102e86:	8b 40 04             	mov    0x4(%eax),%eax
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p;
    list_entry_t *le = &free_list;
    while((le = list_next(le)) != &free_list) {
  102e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
  102e8c:	81 7d f4 50 99 11 00 	cmpl   $0x119950,-0xc(%ebp)
  102e93:	75 d7                	jne    102e6c <default_free_pages+0x3c>
  102e95:	eb 01                	jmp    102e98 <default_free_pages+0x68>
        p = le2page(le, page_link);
        if(p > base)
            break;
  102e97:	90                   	nop
    }
    base->property = n;
  102e98:	8b 45 08             	mov    0x8(%ebp),%eax
  102e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
  102e9e:	89 50 08             	mov    %edx,0x8(%eax)
  102ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102ea4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  102eaa:	8b 00                	mov    (%eax),%eax

    list_entry_t *tle = list_prev(le);
  102eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *tp;

    tp = le2page(le, page_link);
  102eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  102eb2:	83 e8 0c             	sub    $0xc,%eax
  102eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (base + base->property == tp) {
  102eb8:	8b 45 08             	mov    0x8(%ebp),%eax
  102ebb:	8b 50 08             	mov    0x8(%eax),%edx
  102ebe:	89 d0                	mov    %edx,%eax
  102ec0:	c1 e0 02             	shl    $0x2,%eax
  102ec3:	01 d0                	add    %edx,%eax
  102ec5:	c1 e0 02             	shl    $0x2,%eax
  102ec8:	03 45 08             	add    0x8(%ebp),%eax
  102ecb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  102ece:	75 3f                	jne    102f0f <default_free_pages+0xdf>
        base->property += tp->property;
  102ed0:	8b 45 08             	mov    0x8(%ebp),%eax
  102ed3:	8b 50 08             	mov    0x8(%eax),%edx
  102ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ed9:	8b 40 08             	mov    0x8(%eax),%eax
  102edc:	01 c2                	add    %eax,%edx
  102ede:	8b 45 08             	mov    0x8(%ebp),%eax
  102ee1:	89 50 08             	mov    %edx,0x8(%eax)
        list_del(&(tp->page_link));
  102ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102ee7:	83 c0 0c             	add    $0xc,%eax
  102eea:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102eed:	8b 45 dc             	mov    -0x24(%ebp),%eax
  102ef0:	8b 40 04             	mov    0x4(%eax),%eax
  102ef3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  102ef6:	8b 12                	mov    (%edx),%edx
  102ef8:	89 55 d8             	mov    %edx,-0x28(%ebp)
  102efb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102efe:	8b 45 d8             	mov    -0x28(%ebp),%eax
  102f01:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  102f04:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  102f0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
  102f0d:	89 10                	mov    %edx,(%eax)
    }

    tp = le2page(tle, page_link);
  102f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f12:	83 e8 0c             	sub    $0xc,%eax
  102f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (tp + tp->property == base) {
  102f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f1b:	8b 50 08             	mov    0x8(%eax),%edx
  102f1e:	89 d0                	mov    %edx,%eax
  102f20:	c1 e0 02             	shl    $0x2,%eax
  102f23:	01 d0                	add    %edx,%eax
  102f25:	c1 e0 02             	shl    $0x2,%eax
  102f28:	03 45 ec             	add    -0x14(%ebp),%eax
  102f2b:	3b 45 08             	cmp    0x8(%ebp),%eax
  102f2e:	75 53                	jne    102f83 <default_free_pages+0x153>
        tp->property += base->property;
  102f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f33:	8b 50 08             	mov    0x8(%eax),%edx
  102f36:	8b 45 08             	mov    0x8(%ebp),%eax
  102f39:	8b 40 08             	mov    0x8(%eax),%eax
  102f3c:	01 c2                	add    %eax,%edx
  102f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f41:	89 50 08             	mov    %edx,0x8(%eax)
  102f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
  102f47:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
  102f4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  102f4d:	8b 00                	mov    (%eax),%eax
        tle = list_prev(tle);
  102f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        list_del(&(tp->page_link));
  102f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f55:	83 c0 0c             	add    $0xc,%eax
  102f58:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
  102f5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
  102f5e:	8b 40 04             	mov    0x4(%eax),%eax
  102f61:	8b 55 cc             	mov    -0x34(%ebp),%edx
  102f64:	8b 12                	mov    (%edx),%edx
  102f66:	89 55 c8             	mov    %edx,-0x38(%ebp)
  102f69:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
  102f6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
  102f6f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  102f72:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
  102f75:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  102f78:	8b 55 c8             	mov    -0x38(%ebp),%edx
  102f7b:	89 10                	mov    %edx,(%eax)

        base = tp;
  102f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f80:	89 45 08             	mov    %eax,0x8(%ebp)
    }

    for (tp = base + 1; tp < base + base->property; ++tp) {
  102f83:	8b 45 08             	mov    0x8(%ebp),%eax
  102f86:	83 c0 14             	add    $0x14,%eax
  102f89:	89 45 ec             	mov    %eax,-0x14(%ebp)
  102f8c:	eb 5d                	jmp    102feb <default_free_pages+0x1bb>
        ClearPageReserved(tp);
  102f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102f91:	83 c0 04             	add    $0x4,%eax
  102f94:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
  102f9b:	89 45 bc             	mov    %eax,-0x44(%ebp)
  102f9e:	8b 45 bc             	mov    -0x44(%ebp),%eax
  102fa1:	8b 55 c0             	mov    -0x40(%ebp),%edx
  102fa4:	0f b3 10             	btr    %edx,(%eax)
        ClearPageProperty(tp);
  102fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102faa:	83 c0 04             	add    $0x4,%eax
  102fad:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
  102fb4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
  102fb7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  102fba:	8b 55 b8             	mov    -0x48(%ebp),%edx
  102fbd:	0f b3 10             	btr    %edx,(%eax)
        tp->property = 0;
  102fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fc3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        list_init(&(tp->page_link));
  102fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
  102fcd:	83 c0 0c             	add    $0xc,%eax
  102fd0:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  102fd3:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102fd6:	8b 55 b0             	mov    -0x50(%ebp),%edx
  102fd9:	89 50 04             	mov    %edx,0x4(%eax)
  102fdc:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102fdf:	8b 50 04             	mov    0x4(%eax),%edx
  102fe2:	8b 45 b0             	mov    -0x50(%ebp),%eax
  102fe5:	89 10                	mov    %edx,(%eax)
        list_del(&(tp->page_link));

        base = tp;
    }

    for (tp = base + 1; tp < base + base->property; ++tp) {
  102fe7:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
  102feb:	8b 45 08             	mov    0x8(%ebp),%eax
  102fee:	8b 50 08             	mov    0x8(%eax),%edx
  102ff1:	89 d0                	mov    %edx,%eax
  102ff3:	c1 e0 02             	shl    $0x2,%eax
  102ff6:	01 d0                	add    %edx,%eax
  102ff8:	c1 e0 02             	shl    $0x2,%eax
  102ffb:	03 45 08             	add    0x8(%ebp),%eax
  102ffe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103001:	77 8b                	ja     102f8e <default_free_pages+0x15e>
        ClearPageReserved(tp);
        ClearPageProperty(tp);
        tp->property = 0;
        list_init(&(tp->page_link));
    }
    ClearPageReserved(base);
  103003:	8b 45 08             	mov    0x8(%ebp),%eax
  103006:	83 c0 04             	add    $0x4,%eax
  103009:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
  103010:	89 45 a8             	mov    %eax,-0x58(%ebp)
  103013:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103016:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103019:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
  10301c:	8b 45 08             	mov    0x8(%ebp),%eax
  10301f:	83 c0 04             	add    $0x4,%eax
  103022:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
  103029:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  10302c:	8b 45 a0             	mov    -0x60(%ebp),%eax
  10302f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
  103032:	0f ab 10             	bts    %edx,(%eax)
    list_add(tle, &(base->page_link));
  103035:	8b 45 08             	mov    0x8(%ebp),%eax
  103038:	8d 50 0c             	lea    0xc(%eax),%edx
  10303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10303e:	89 45 9c             	mov    %eax,-0x64(%ebp)
  103041:	89 55 98             	mov    %edx,-0x68(%ebp)
  103044:	8b 45 9c             	mov    -0x64(%ebp),%eax
  103047:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10304a:	8b 45 98             	mov    -0x68(%ebp),%eax
  10304d:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
  103050:	8b 45 94             	mov    -0x6c(%ebp),%eax
  103053:	8b 40 04             	mov    0x4(%eax),%eax
  103056:	8b 55 90             	mov    -0x70(%ebp),%edx
  103059:	89 55 8c             	mov    %edx,-0x74(%ebp)
  10305c:	8b 55 94             	mov    -0x6c(%ebp),%edx
  10305f:	89 55 88             	mov    %edx,-0x78(%ebp)
  103062:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
  103065:	8b 45 84             	mov    -0x7c(%ebp),%eax
  103068:	8b 55 8c             	mov    -0x74(%ebp),%edx
  10306b:	89 10                	mov    %edx,(%eax)
  10306d:	8b 45 84             	mov    -0x7c(%ebp),%eax
  103070:	8b 10                	mov    (%eax),%edx
  103072:	8b 45 88             	mov    -0x78(%ebp),%eax
  103075:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
  103078:	8b 45 8c             	mov    -0x74(%ebp),%eax
  10307b:	8b 55 84             	mov    -0x7c(%ebp),%edx
  10307e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
  103081:	8b 45 8c             	mov    -0x74(%ebp),%eax
  103084:	8b 55 88             	mov    -0x78(%ebp),%edx
  103087:	89 10                	mov    %edx,(%eax)

    nr_free += n;
  103089:	a1 58 99 11 00       	mov    0x119958,%eax
  10308e:	03 45 0c             	add    0xc(%ebp),%eax
  103091:	a3 58 99 11 00       	mov    %eax,0x119958
}
  103096:	c9                   	leave  
  103097:	c3                   	ret    

00103098 <default_nr_free_pages>:


static size_t
default_nr_free_pages(void) {
  103098:	55                   	push   %ebp
  103099:	89 e5                	mov    %esp,%ebp
    return nr_free;
  10309b:	a1 58 99 11 00       	mov    0x119958,%eax
}
  1030a0:	5d                   	pop    %ebp
  1030a1:	c3                   	ret    

001030a2 <basic_check>:

static void
basic_check(void) {
  1030a2:	55                   	push   %ebp
  1030a3:	89 e5                	mov    %esp,%ebp
  1030a5:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
  1030a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1030b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1030b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1030b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
  1030bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030c2:	e8 a6 0e 00 00       	call   103f6d <alloc_pages>
  1030c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1030ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1030ce:	75 24                	jne    1030f4 <basic_check+0x52>
  1030d0:	c7 44 24 0c e4 69 10 	movl   $0x1069e4,0xc(%esp)
  1030d7:	00 
  1030d8:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1030df:	00 
  1030e0:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
  1030e7:	00 
  1030e8:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1030ef:	e8 b4 db ff ff       	call   100ca8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1030f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1030fb:	e8 6d 0e 00 00       	call   103f6d <alloc_pages>
  103100:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103103:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103107:	75 24                	jne    10312d <basic_check+0x8b>
  103109:	c7 44 24 0c 00 6a 10 	movl   $0x106a00,0xc(%esp)
  103110:	00 
  103111:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103118:	00 
  103119:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
  103120:	00 
  103121:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103128:	e8 7b db ff ff       	call   100ca8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  10312d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103134:	e8 34 0e 00 00       	call   103f6d <alloc_pages>
  103139:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10313c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103140:	75 24                	jne    103166 <basic_check+0xc4>
  103142:	c7 44 24 0c 1c 6a 10 	movl   $0x106a1c,0xc(%esp)
  103149:	00 
  10314a:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103151:	00 
  103152:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
  103159:	00 
  10315a:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103161:	e8 42 db ff ff       	call   100ca8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
  103166:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103169:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  10316c:	74 10                	je     10317e <basic_check+0xdc>
  10316e:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103171:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  103174:	74 08                	je     10317e <basic_check+0xdc>
  103176:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103179:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  10317c:	75 24                	jne    1031a2 <basic_check+0x100>
  10317e:	c7 44 24 0c 38 6a 10 	movl   $0x106a38,0xc(%esp)
  103185:	00 
  103186:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  10318d:	00 
  10318e:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
  103195:	00 
  103196:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  10319d:	e8 06 db ff ff       	call   100ca8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
  1031a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031a5:	89 04 24             	mov    %eax,(%esp)
  1031a8:	e8 a9 f7 ff ff       	call   102956 <page_ref>
  1031ad:	85 c0                	test   %eax,%eax
  1031af:	75 1e                	jne    1031cf <basic_check+0x12d>
  1031b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1031b4:	89 04 24             	mov    %eax,(%esp)
  1031b7:	e8 9a f7 ff ff       	call   102956 <page_ref>
  1031bc:	85 c0                	test   %eax,%eax
  1031be:	75 0f                	jne    1031cf <basic_check+0x12d>
  1031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1031c3:	89 04 24             	mov    %eax,(%esp)
  1031c6:	e8 8b f7 ff ff       	call   102956 <page_ref>
  1031cb:	85 c0                	test   %eax,%eax
  1031cd:	74 24                	je     1031f3 <basic_check+0x151>
  1031cf:	c7 44 24 0c 5c 6a 10 	movl   $0x106a5c,0xc(%esp)
  1031d6:	00 
  1031d7:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1031de:	00 
  1031df:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
  1031e6:	00 
  1031e7:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1031ee:	e8 b5 da ff ff       	call   100ca8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
  1031f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1031f6:	89 04 24             	mov    %eax,(%esp)
  1031f9:	e8 42 f7 ff ff       	call   102940 <page2pa>
  1031fe:	8b 15 c0 98 11 00    	mov    0x1198c0,%edx
  103204:	c1 e2 0c             	shl    $0xc,%edx
  103207:	39 d0                	cmp    %edx,%eax
  103209:	72 24                	jb     10322f <basic_check+0x18d>
  10320b:	c7 44 24 0c 98 6a 10 	movl   $0x106a98,0xc(%esp)
  103212:	00 
  103213:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  10321a:	00 
  10321b:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
  103222:	00 
  103223:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  10322a:	e8 79 da ff ff       	call   100ca8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
  10322f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103232:	89 04 24             	mov    %eax,(%esp)
  103235:	e8 06 f7 ff ff       	call   102940 <page2pa>
  10323a:	8b 15 c0 98 11 00    	mov    0x1198c0,%edx
  103240:	c1 e2 0c             	shl    $0xc,%edx
  103243:	39 d0                	cmp    %edx,%eax
  103245:	72 24                	jb     10326b <basic_check+0x1c9>
  103247:	c7 44 24 0c b5 6a 10 	movl   $0x106ab5,0xc(%esp)
  10324e:	00 
  10324f:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103256:	00 
  103257:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
  10325e:	00 
  10325f:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103266:	e8 3d da ff ff       	call   100ca8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
  10326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10326e:	89 04 24             	mov    %eax,(%esp)
  103271:	e8 ca f6 ff ff       	call   102940 <page2pa>
  103276:	8b 15 c0 98 11 00    	mov    0x1198c0,%edx
  10327c:	c1 e2 0c             	shl    $0xc,%edx
  10327f:	39 d0                	cmp    %edx,%eax
  103281:	72 24                	jb     1032a7 <basic_check+0x205>
  103283:	c7 44 24 0c d2 6a 10 	movl   $0x106ad2,0xc(%esp)
  10328a:	00 
  10328b:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103292:	00 
  103293:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
  10329a:	00 
  10329b:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1032a2:	e8 01 da ff ff       	call   100ca8 <__panic>

    list_entry_t free_list_store = free_list;
  1032a7:	a1 50 99 11 00       	mov    0x119950,%eax
  1032ac:	8b 15 54 99 11 00    	mov    0x119954,%edx
  1032b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1032b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  1032b8:	c7 45 e0 50 99 11 00 	movl   $0x119950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  1032bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  1032c5:	89 50 04             	mov    %edx,0x4(%eax)
  1032c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032cb:	8b 50 04             	mov    0x4(%eax),%edx
  1032ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1032d1:	89 10                	mov    %edx,(%eax)
  1032d3:	c7 45 dc 50 99 11 00 	movl   $0x119950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  1032da:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1032dd:	8b 40 04             	mov    0x4(%eax),%eax
  1032e0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1032e3:	0f 94 c0             	sete   %al
  1032e6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  1032e9:	85 c0                	test   %eax,%eax
  1032eb:	75 24                	jne    103311 <basic_check+0x26f>
  1032ed:	c7 44 24 0c ef 6a 10 	movl   $0x106aef,0xc(%esp)
  1032f4:	00 
  1032f5:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1032fc:	00 
  1032fd:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
  103304:	00 
  103305:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  10330c:	e8 97 d9 ff ff       	call   100ca8 <__panic>

    unsigned int nr_free_store = nr_free;
  103311:	a1 58 99 11 00       	mov    0x119958,%eax
  103316:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
  103319:	c7 05 58 99 11 00 00 	movl   $0x0,0x119958
  103320:	00 00 00 

    assert(alloc_page() == NULL);
  103323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  10332a:	e8 3e 0c 00 00       	call   103f6d <alloc_pages>
  10332f:	85 c0                	test   %eax,%eax
  103331:	74 24                	je     103357 <basic_check+0x2b5>
  103333:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  10333a:	00 
  10333b:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103342:	00 
  103343:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
  10334a:	00 
  10334b:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103352:	e8 51 d9 ff ff       	call   100ca8 <__panic>

    free_page(p0);
  103357:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10335e:	00 
  10335f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103362:	89 04 24             	mov    %eax,(%esp)
  103365:	e8 3b 0c 00 00       	call   103fa5 <free_pages>
    free_page(p1);
  10336a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103371:	00 
  103372:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103375:	89 04 24             	mov    %eax,(%esp)
  103378:	e8 28 0c 00 00       	call   103fa5 <free_pages>
    free_page(p2);
  10337d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103384:	00 
  103385:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103388:	89 04 24             	mov    %eax,(%esp)
  10338b:	e8 15 0c 00 00       	call   103fa5 <free_pages>
    assert(nr_free == 3);
  103390:	a1 58 99 11 00       	mov    0x119958,%eax
  103395:	83 f8 03             	cmp    $0x3,%eax
  103398:	74 24                	je     1033be <basic_check+0x31c>
  10339a:	c7 44 24 0c 1b 6b 10 	movl   $0x106b1b,0xc(%esp)
  1033a1:	00 
  1033a2:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1033a9:	00 
  1033aa:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
  1033b1:	00 
  1033b2:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1033b9:	e8 ea d8 ff ff       	call   100ca8 <__panic>

    assert((p0 = alloc_page()) != NULL);
  1033be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033c5:	e8 a3 0b 00 00       	call   103f6d <alloc_pages>
  1033ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1033cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
  1033d1:	75 24                	jne    1033f7 <basic_check+0x355>
  1033d3:	c7 44 24 0c e4 69 10 	movl   $0x1069e4,0xc(%esp)
  1033da:	00 
  1033db:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1033e2:	00 
  1033e3:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
  1033ea:	00 
  1033eb:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1033f2:	e8 b1 d8 ff ff       	call   100ca8 <__panic>
    assert((p1 = alloc_page()) != NULL);
  1033f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1033fe:	e8 6a 0b 00 00       	call   103f6d <alloc_pages>
  103403:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103406:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  10340a:	75 24                	jne    103430 <basic_check+0x38e>
  10340c:	c7 44 24 0c 00 6a 10 	movl   $0x106a00,0xc(%esp)
  103413:	00 
  103414:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  10341b:	00 
  10341c:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
  103423:	00 
  103424:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  10342b:	e8 78 d8 ff ff       	call   100ca8 <__panic>
    assert((p2 = alloc_page()) != NULL);
  103430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103437:	e8 31 0b 00 00       	call   103f6d <alloc_pages>
  10343c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10343f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103443:	75 24                	jne    103469 <basic_check+0x3c7>
  103445:	c7 44 24 0c 1c 6a 10 	movl   $0x106a1c,0xc(%esp)
  10344c:	00 
  10344d:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103454:	00 
  103455:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
  10345c:	00 
  10345d:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103464:	e8 3f d8 ff ff       	call   100ca8 <__panic>

    assert(alloc_page() == NULL);
  103469:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103470:	e8 f8 0a 00 00       	call   103f6d <alloc_pages>
  103475:	85 c0                	test   %eax,%eax
  103477:	74 24                	je     10349d <basic_check+0x3fb>
  103479:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  103480:	00 
  103481:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103488:	00 
  103489:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
  103490:	00 
  103491:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103498:	e8 0b d8 ff ff       	call   100ca8 <__panic>

    free_page(p0);
  10349d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1034a4:	00 
  1034a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1034a8:	89 04 24             	mov    %eax,(%esp)
  1034ab:	e8 f5 0a 00 00       	call   103fa5 <free_pages>
  1034b0:	c7 45 d8 50 99 11 00 	movl   $0x119950,-0x28(%ebp)
  1034b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1034ba:	8b 40 04             	mov    0x4(%eax),%eax
  1034bd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
  1034c0:	0f 94 c0             	sete   %al
  1034c3:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
  1034c6:	85 c0                	test   %eax,%eax
  1034c8:	74 24                	je     1034ee <basic_check+0x44c>
  1034ca:	c7 44 24 0c 28 6b 10 	movl   $0x106b28,0xc(%esp)
  1034d1:	00 
  1034d2:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1034d9:	00 
  1034da:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
  1034e1:	00 
  1034e2:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1034e9:	e8 ba d7 ff ff       	call   100ca8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
  1034ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1034f5:	e8 73 0a 00 00       	call   103f6d <alloc_pages>
  1034fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1034fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103500:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  103503:	74 24                	je     103529 <basic_check+0x487>
  103505:	c7 44 24 0c 40 6b 10 	movl   $0x106b40,0xc(%esp)
  10350c:	00 
  10350d:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103514:	00 
  103515:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
  10351c:	00 
  10351d:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103524:	e8 7f d7 ff ff       	call   100ca8 <__panic>
    assert(alloc_page() == NULL);
  103529:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103530:	e8 38 0a 00 00       	call   103f6d <alloc_pages>
  103535:	85 c0                	test   %eax,%eax
  103537:	74 24                	je     10355d <basic_check+0x4bb>
  103539:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  103540:	00 
  103541:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103548:	00 
  103549:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
  103550:	00 
  103551:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103558:	e8 4b d7 ff ff       	call   100ca8 <__panic>

    assert(nr_free == 0);
  10355d:	a1 58 99 11 00       	mov    0x119958,%eax
  103562:	85 c0                	test   %eax,%eax
  103564:	74 24                	je     10358a <basic_check+0x4e8>
  103566:	c7 44 24 0c 59 6b 10 	movl   $0x106b59,0xc(%esp)
  10356d:	00 
  10356e:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103575:	00 
  103576:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
  10357d:	00 
  10357e:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103585:	e8 1e d7 ff ff       	call   100ca8 <__panic>
    free_list = free_list_store;
  10358a:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10358d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  103590:	a3 50 99 11 00       	mov    %eax,0x119950
  103595:	89 15 54 99 11 00    	mov    %edx,0x119954
    nr_free = nr_free_store;
  10359b:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10359e:	a3 58 99 11 00       	mov    %eax,0x119958

    free_page(p);
  1035a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035aa:	00 
  1035ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1035ae:	89 04 24             	mov    %eax,(%esp)
  1035b1:	e8 ef 09 00 00       	call   103fa5 <free_pages>
    free_page(p1);
  1035b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035bd:	00 
  1035be:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1035c1:	89 04 24             	mov    %eax,(%esp)
  1035c4:	e8 dc 09 00 00       	call   103fa5 <free_pages>
    free_page(p2);
  1035c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1035d0:	00 
  1035d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1035d4:	89 04 24             	mov    %eax,(%esp)
  1035d7:	e8 c9 09 00 00       	call   103fa5 <free_pages>
}
  1035dc:	c9                   	leave  
  1035dd:	c3                   	ret    

001035de <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
  1035de:	55                   	push   %ebp
  1035df:	89 e5                	mov    %esp,%ebp
  1035e1:	53                   	push   %ebx
  1035e2:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
  1035e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1035ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
  1035f6:	c7 45 ec 50 99 11 00 	movl   $0x119950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  1035fd:	eb 6b                	jmp    10366a <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
  1035ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103602:	83 e8 0c             	sub    $0xc,%eax
  103605:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
  103608:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10360b:	83 c0 04             	add    $0x4,%eax
  10360e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
  103615:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103618:	8b 45 cc             	mov    -0x34(%ebp),%eax
  10361b:	8b 55 d0             	mov    -0x30(%ebp),%edx
  10361e:	0f a3 10             	bt     %edx,(%eax)
  103621:	19 db                	sbb    %ebx,%ebx
  103623:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    return oldbit != 0;
  103626:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
  10362a:	0f 95 c0             	setne  %al
  10362d:	0f b6 c0             	movzbl %al,%eax
  103630:	85 c0                	test   %eax,%eax
  103632:	75 24                	jne    103658 <default_check+0x7a>
  103634:	c7 44 24 0c 66 6b 10 	movl   $0x106b66,0xc(%esp)
  10363b:	00 
  10363c:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103643:	00 
  103644:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
  10364b:	00 
  10364c:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103653:	e8 50 d6 ff ff       	call   100ca8 <__panic>
        count ++, total += p->property;
  103658:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  10365c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10365f:	8b 50 08             	mov    0x8(%eax),%edx
  103662:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103665:	01 d0                	add    %edx,%eax
  103667:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10366a:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10366d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103670:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  103673:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103676:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103679:	81 7d ec 50 99 11 00 	cmpl   $0x119950,-0x14(%ebp)
  103680:	0f 85 79 ff ff ff    	jne    1035ff <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
  103686:	8b 5d f0             	mov    -0x10(%ebp),%ebx
  103689:	e8 49 09 00 00       	call   103fd7 <nr_free_pages>
  10368e:	39 c3                	cmp    %eax,%ebx
  103690:	74 24                	je     1036b6 <default_check+0xd8>
  103692:	c7 44 24 0c 76 6b 10 	movl   $0x106b76,0xc(%esp)
  103699:	00 
  10369a:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1036a1:	00 
  1036a2:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
  1036a9:	00 
  1036aa:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1036b1:	e8 f2 d5 ff ff       	call   100ca8 <__panic>

    basic_check();
  1036b6:	e8 e7 f9 ff ff       	call   1030a2 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
  1036bb:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  1036c2:	e8 a6 08 00 00       	call   103f6d <alloc_pages>
  1036c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
  1036ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1036ce:	75 24                	jne    1036f4 <default_check+0x116>
  1036d0:	c7 44 24 0c 8f 6b 10 	movl   $0x106b8f,0xc(%esp)
  1036d7:	00 
  1036d8:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1036df:	00 
  1036e0:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
  1036e7:	00 
  1036e8:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1036ef:	e8 b4 d5 ff ff       	call   100ca8 <__panic>
    assert(!PageProperty(p0));
  1036f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1036f7:	83 c0 04             	add    $0x4,%eax
  1036fa:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
  103701:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103704:	8b 45 bc             	mov    -0x44(%ebp),%eax
  103707:	8b 55 c0             	mov    -0x40(%ebp),%edx
  10370a:	0f a3 10             	bt     %edx,(%eax)
  10370d:	19 db                	sbb    %ebx,%ebx
  10370f:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    return oldbit != 0;
  103712:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
  103716:	0f 95 c0             	setne  %al
  103719:	0f b6 c0             	movzbl %al,%eax
  10371c:	85 c0                	test   %eax,%eax
  10371e:	74 24                	je     103744 <default_check+0x166>
  103720:	c7 44 24 0c 9a 6b 10 	movl   $0x106b9a,0xc(%esp)
  103727:	00 
  103728:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  10372f:	00 
  103730:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
  103737:	00 
  103738:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  10373f:	e8 64 d5 ff ff       	call   100ca8 <__panic>

    list_entry_t free_list_store = free_list;
  103744:	a1 50 99 11 00       	mov    0x119950,%eax
  103749:	8b 15 54 99 11 00    	mov    0x119954,%edx
  10374f:	89 45 80             	mov    %eax,-0x80(%ebp)
  103752:	89 55 84             	mov    %edx,-0x7c(%ebp)
  103755:	c7 45 b4 50 99 11 00 	movl   $0x119950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
  10375c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10375f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  103762:	89 50 04             	mov    %edx,0x4(%eax)
  103765:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  103768:	8b 50 04             	mov    0x4(%eax),%edx
  10376b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
  10376e:	89 10                	mov    %edx,(%eax)
  103770:	c7 45 b0 50 99 11 00 	movl   $0x119950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
  103777:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10377a:	8b 40 04             	mov    0x4(%eax),%eax
  10377d:	39 45 b0             	cmp    %eax,-0x50(%ebp)
  103780:	0f 94 c0             	sete   %al
  103783:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
  103786:	85 c0                	test   %eax,%eax
  103788:	75 24                	jne    1037ae <default_check+0x1d0>
  10378a:	c7 44 24 0c ef 6a 10 	movl   $0x106aef,0xc(%esp)
  103791:	00 
  103792:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103799:	00 
  10379a:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
  1037a1:	00 
  1037a2:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1037a9:	e8 fa d4 ff ff       	call   100ca8 <__panic>
    assert(alloc_page() == NULL);
  1037ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1037b5:	e8 b3 07 00 00       	call   103f6d <alloc_pages>
  1037ba:	85 c0                	test   %eax,%eax
  1037bc:	74 24                	je     1037e2 <default_check+0x204>
  1037be:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  1037c5:	00 
  1037c6:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1037cd:	00 
  1037ce:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
  1037d5:	00 
  1037d6:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1037dd:	e8 c6 d4 ff ff       	call   100ca8 <__panic>

    unsigned int nr_free_store = nr_free;
  1037e2:	a1 58 99 11 00       	mov    0x119958,%eax
  1037e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
  1037ea:	c7 05 58 99 11 00 00 	movl   $0x0,0x119958
  1037f1:	00 00 00 

    free_pages(p0 + 2, 3);
  1037f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1037f7:	83 c0 28             	add    $0x28,%eax
  1037fa:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  103801:	00 
  103802:	89 04 24             	mov    %eax,(%esp)
  103805:	e8 9b 07 00 00       	call   103fa5 <free_pages>
    assert(alloc_pages(4) == NULL);
  10380a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  103811:	e8 57 07 00 00       	call   103f6d <alloc_pages>
  103816:	85 c0                	test   %eax,%eax
  103818:	74 24                	je     10383e <default_check+0x260>
  10381a:	c7 44 24 0c ac 6b 10 	movl   $0x106bac,0xc(%esp)
  103821:	00 
  103822:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103829:	00 
  10382a:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  103831:	00 
  103832:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103839:	e8 6a d4 ff ff       	call   100ca8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
  10383e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103841:	83 c0 28             	add    $0x28,%eax
  103844:	83 c0 04             	add    $0x4,%eax
  103847:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
  10384e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  103851:	8b 45 a8             	mov    -0x58(%ebp),%eax
  103854:	8b 55 ac             	mov    -0x54(%ebp),%edx
  103857:	0f a3 10             	bt     %edx,(%eax)
  10385a:	19 db                	sbb    %ebx,%ebx
  10385c:	89 5d a4             	mov    %ebx,-0x5c(%ebp)
    return oldbit != 0;
  10385f:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
  103863:	0f 95 c0             	setne  %al
  103866:	0f b6 c0             	movzbl %al,%eax
  103869:	85 c0                	test   %eax,%eax
  10386b:	74 0e                	je     10387b <default_check+0x29d>
  10386d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103870:	83 c0 28             	add    $0x28,%eax
  103873:	8b 40 08             	mov    0x8(%eax),%eax
  103876:	83 f8 03             	cmp    $0x3,%eax
  103879:	74 24                	je     10389f <default_check+0x2c1>
  10387b:	c7 44 24 0c c4 6b 10 	movl   $0x106bc4,0xc(%esp)
  103882:	00 
  103883:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  10388a:	00 
  10388b:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
  103892:	00 
  103893:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  10389a:	e8 09 d4 ff ff       	call   100ca8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
  10389f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  1038a6:	e8 c2 06 00 00       	call   103f6d <alloc_pages>
  1038ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1038ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  1038b2:	75 24                	jne    1038d8 <default_check+0x2fa>
  1038b4:	c7 44 24 0c f0 6b 10 	movl   $0x106bf0,0xc(%esp)
  1038bb:	00 
  1038bc:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1038c3:	00 
  1038c4:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
  1038cb:	00 
  1038cc:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1038d3:	e8 d0 d3 ff ff       	call   100ca8 <__panic>
    assert(alloc_page() == NULL);
  1038d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1038df:	e8 89 06 00 00       	call   103f6d <alloc_pages>
  1038e4:	85 c0                	test   %eax,%eax
  1038e6:	74 24                	je     10390c <default_check+0x32e>
  1038e8:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  1038ef:	00 
  1038f0:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1038f7:	00 
  1038f8:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
  1038ff:	00 
  103900:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103907:	e8 9c d3 ff ff       	call   100ca8 <__panic>
    assert(p0 + 2 == p1);
  10390c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10390f:	83 c0 28             	add    $0x28,%eax
  103912:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  103915:	74 24                	je     10393b <default_check+0x35d>
  103917:	c7 44 24 0c 0e 6c 10 	movl   $0x106c0e,0xc(%esp)
  10391e:	00 
  10391f:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103926:	00 
  103927:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
  10392e:	00 
  10392f:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103936:	e8 6d d3 ff ff       	call   100ca8 <__panic>

    p2 = p0 + 1;
  10393b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10393e:	83 c0 14             	add    $0x14,%eax
  103941:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
  103944:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10394b:	00 
  10394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10394f:	89 04 24             	mov    %eax,(%esp)
  103952:	e8 4e 06 00 00       	call   103fa5 <free_pages>
    free_pages(p1, 3);
  103957:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
  10395e:	00 
  10395f:	8b 45 dc             	mov    -0x24(%ebp),%eax
  103962:	89 04 24             	mov    %eax,(%esp)
  103965:	e8 3b 06 00 00       	call   103fa5 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
  10396a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  10396d:	83 c0 04             	add    $0x4,%eax
  103970:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
  103977:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  10397a:	8b 45 9c             	mov    -0x64(%ebp),%eax
  10397d:	8b 55 a0             	mov    -0x60(%ebp),%edx
  103980:	0f a3 10             	bt     %edx,(%eax)
  103983:	19 db                	sbb    %ebx,%ebx
  103985:	89 5d 98             	mov    %ebx,-0x68(%ebp)
    return oldbit != 0;
  103988:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
  10398c:	0f 95 c0             	setne  %al
  10398f:	0f b6 c0             	movzbl %al,%eax
  103992:	85 c0                	test   %eax,%eax
  103994:	74 0b                	je     1039a1 <default_check+0x3c3>
  103996:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103999:	8b 40 08             	mov    0x8(%eax),%eax
  10399c:	83 f8 01             	cmp    $0x1,%eax
  10399f:	74 24                	je     1039c5 <default_check+0x3e7>
  1039a1:	c7 44 24 0c 1c 6c 10 	movl   $0x106c1c,0xc(%esp)
  1039a8:	00 
  1039a9:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  1039b0:	00 
  1039b1:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
  1039b8:	00 
  1039b9:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  1039c0:	e8 e3 d2 ff ff       	call   100ca8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
  1039c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039c8:	83 c0 04             	add    $0x4,%eax
  1039cb:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
  1039d2:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
  1039d5:	8b 45 90             	mov    -0x70(%ebp),%eax
  1039d8:	8b 55 94             	mov    -0x6c(%ebp),%edx
  1039db:	0f a3 10             	bt     %edx,(%eax)
  1039de:	19 db                	sbb    %ebx,%ebx
  1039e0:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
    return oldbit != 0;
  1039e3:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
  1039e7:	0f 95 c0             	setne  %al
  1039ea:	0f b6 c0             	movzbl %al,%eax
  1039ed:	85 c0                	test   %eax,%eax
  1039ef:	74 0b                	je     1039fc <default_check+0x41e>
  1039f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  1039f4:	8b 40 08             	mov    0x8(%eax),%eax
  1039f7:	83 f8 03             	cmp    $0x3,%eax
  1039fa:	74 24                	je     103a20 <default_check+0x442>
  1039fc:	c7 44 24 0c 44 6c 10 	movl   $0x106c44,0xc(%esp)
  103a03:	00 
  103a04:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103a0b:	00 
  103a0c:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
  103a13:	00 
  103a14:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103a1b:	e8 88 d2 ff ff       	call   100ca8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
  103a20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103a27:	e8 41 05 00 00       	call   103f6d <alloc_pages>
  103a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a32:	83 e8 14             	sub    $0x14,%eax
  103a35:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103a38:	74 24                	je     103a5e <default_check+0x480>
  103a3a:	c7 44 24 0c 6a 6c 10 	movl   $0x106c6a,0xc(%esp)
  103a41:	00 
  103a42:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103a49:	00 
  103a4a:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
  103a51:	00 
  103a52:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103a59:	e8 4a d2 ff ff       	call   100ca8 <__panic>
    free_page(p0);
  103a5e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103a65:	00 
  103a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103a69:	89 04 24             	mov    %eax,(%esp)
  103a6c:	e8 34 05 00 00       	call   103fa5 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
  103a71:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  103a78:	e8 f0 04 00 00       	call   103f6d <alloc_pages>
  103a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103a80:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103a83:	83 c0 14             	add    $0x14,%eax
  103a86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  103a89:	74 24                	je     103aaf <default_check+0x4d1>
  103a8b:	c7 44 24 0c 88 6c 10 	movl   $0x106c88,0xc(%esp)
  103a92:	00 
  103a93:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103a9a:	00 
  103a9b:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
  103aa2:	00 
  103aa3:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103aaa:	e8 f9 d1 ff ff       	call   100ca8 <__panic>

    free_pages(p0, 2);
  103aaf:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
  103ab6:	00 
  103ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103aba:	89 04 24             	mov    %eax,(%esp)
  103abd:	e8 e3 04 00 00       	call   103fa5 <free_pages>
    free_page(p2);
  103ac2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  103ac9:	00 
  103aca:	8b 45 d8             	mov    -0x28(%ebp),%eax
  103acd:	89 04 24             	mov    %eax,(%esp)
  103ad0:	e8 d0 04 00 00       	call   103fa5 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
  103ad5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
  103adc:	e8 8c 04 00 00       	call   103f6d <alloc_pages>
  103ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  103ae4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  103ae8:	75 24                	jne    103b0e <default_check+0x530>
  103aea:	c7 44 24 0c a8 6c 10 	movl   $0x106ca8,0xc(%esp)
  103af1:	00 
  103af2:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103af9:	00 
  103afa:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
  103b01:	00 
  103b02:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103b09:	e8 9a d1 ff ff       	call   100ca8 <__panic>
    assert(alloc_page() == NULL);
  103b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  103b15:	e8 53 04 00 00       	call   103f6d <alloc_pages>
  103b1a:	85 c0                	test   %eax,%eax
  103b1c:	74 24                	je     103b42 <default_check+0x564>
  103b1e:	c7 44 24 0c 06 6b 10 	movl   $0x106b06,0xc(%esp)
  103b25:	00 
  103b26:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103b2d:	00 
  103b2e:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
  103b35:	00 
  103b36:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103b3d:	e8 66 d1 ff ff       	call   100ca8 <__panic>

    assert(nr_free == 0);
  103b42:	a1 58 99 11 00       	mov    0x119958,%eax
  103b47:	85 c0                	test   %eax,%eax
  103b49:	74 24                	je     103b6f <default_check+0x591>
  103b4b:	c7 44 24 0c 59 6b 10 	movl   $0x106b59,0xc(%esp)
  103b52:	00 
  103b53:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103b5a:	00 
  103b5b:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
  103b62:	00 
  103b63:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103b6a:	e8 39 d1 ff ff       	call   100ca8 <__panic>
    nr_free = nr_free_store;
  103b6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  103b72:	a3 58 99 11 00       	mov    %eax,0x119958

    free_list = free_list_store;
  103b77:	8b 45 80             	mov    -0x80(%ebp),%eax
  103b7a:	8b 55 84             	mov    -0x7c(%ebp),%edx
  103b7d:	a3 50 99 11 00       	mov    %eax,0x119950
  103b82:	89 15 54 99 11 00    	mov    %edx,0x119954
    free_pages(p0, 5);
  103b88:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
  103b8f:	00 
  103b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  103b93:	89 04 24             	mov    %eax,(%esp)
  103b96:	e8 0a 04 00 00       	call   103fa5 <free_pages>

    le = &free_list;
  103b9b:	c7 45 ec 50 99 11 00 	movl   $0x119950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
  103ba2:	eb 1f                	jmp    103bc3 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
  103ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103ba7:	83 e8 0c             	sub    $0xc,%eax
  103baa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
  103bad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  103bb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
  103bb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  103bb7:	8b 40 08             	mov    0x8(%eax),%eax
  103bba:	89 d1                	mov    %edx,%ecx
  103bbc:	29 c1                	sub    %eax,%ecx
  103bbe:	89 c8                	mov    %ecx,%eax
  103bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
  103bc6:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
  103bc9:	8b 45 88             	mov    -0x78(%ebp),%eax
  103bcc:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
  103bcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
  103bd2:	81 7d ec 50 99 11 00 	cmpl   $0x119950,-0x14(%ebp)
  103bd9:	75 c9                	jne    103ba4 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
  103bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  103bdf:	74 24                	je     103c05 <default_check+0x627>
  103be1:	c7 44 24 0c c6 6c 10 	movl   $0x106cc6,0xc(%esp)
  103be8:	00 
  103be9:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103bf0:	00 
  103bf1:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
  103bf8:	00 
  103bf9:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103c00:	e8 a3 d0 ff ff       	call   100ca8 <__panic>
    assert(total == 0);
  103c05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  103c09:	74 24                	je     103c2f <default_check+0x651>
  103c0b:	c7 44 24 0c d1 6c 10 	movl   $0x106cd1,0xc(%esp)
  103c12:	00 
  103c13:	c7 44 24 08 96 69 10 	movl   $0x106996,0x8(%esp)
  103c1a:	00 
  103c1b:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
  103c22:	00 
  103c23:	c7 04 24 ab 69 10 00 	movl   $0x1069ab,(%esp)
  103c2a:	e8 79 d0 ff ff       	call   100ca8 <__panic>
}
  103c2f:	81 c4 94 00 00 00    	add    $0x94,%esp
  103c35:	5b                   	pop    %ebx
  103c36:	5d                   	pop    %ebp
  103c37:	c3                   	ret    

00103c38 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
  103c38:	55                   	push   %ebp
  103c39:	89 e5                	mov    %esp,%ebp
    return page - pages;
  103c3b:	8b 55 08             	mov    0x8(%ebp),%edx
  103c3e:	a1 64 99 11 00       	mov    0x119964,%eax
  103c43:	89 d1                	mov    %edx,%ecx
  103c45:	29 c1                	sub    %eax,%ecx
  103c47:	89 c8                	mov    %ecx,%eax
  103c49:	c1 f8 02             	sar    $0x2,%eax
  103c4c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
  103c52:	5d                   	pop    %ebp
  103c53:	c3                   	ret    

00103c54 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
  103c54:	55                   	push   %ebp
  103c55:	89 e5                	mov    %esp,%ebp
  103c57:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
  103c5a:	8b 45 08             	mov    0x8(%ebp),%eax
  103c5d:	89 04 24             	mov    %eax,(%esp)
  103c60:	e8 d3 ff ff ff       	call   103c38 <page2ppn>
  103c65:	c1 e0 0c             	shl    $0xc,%eax
}
  103c68:	c9                   	leave  
  103c69:	c3                   	ret    

00103c6a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
  103c6a:	55                   	push   %ebp
  103c6b:	89 e5                	mov    %esp,%ebp
  103c6d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
  103c70:	8b 45 08             	mov    0x8(%ebp),%eax
  103c73:	89 c2                	mov    %eax,%edx
  103c75:	c1 ea 0c             	shr    $0xc,%edx
  103c78:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  103c7d:	39 c2                	cmp    %eax,%edx
  103c7f:	72 1c                	jb     103c9d <pa2page+0x33>
        panic("pa2page called with invalid pa");
  103c81:	c7 44 24 08 0c 6d 10 	movl   $0x106d0c,0x8(%esp)
  103c88:	00 
  103c89:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
  103c90:	00 
  103c91:	c7 04 24 2b 6d 10 00 	movl   $0x106d2b,(%esp)
  103c98:	e8 0b d0 ff ff       	call   100ca8 <__panic>
    }
    return &pages[PPN(pa)];
  103c9d:	8b 0d 64 99 11 00    	mov    0x119964,%ecx
  103ca3:	8b 45 08             	mov    0x8(%ebp),%eax
  103ca6:	89 c2                	mov    %eax,%edx
  103ca8:	c1 ea 0c             	shr    $0xc,%edx
  103cab:	89 d0                	mov    %edx,%eax
  103cad:	c1 e0 02             	shl    $0x2,%eax
  103cb0:	01 d0                	add    %edx,%eax
  103cb2:	c1 e0 02             	shl    $0x2,%eax
  103cb5:	01 c8                	add    %ecx,%eax
}
  103cb7:	c9                   	leave  
  103cb8:	c3                   	ret    

00103cb9 <page2kva>:

static inline void *
page2kva(struct Page *page) {
  103cb9:	55                   	push   %ebp
  103cba:	89 e5                	mov    %esp,%ebp
  103cbc:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
  103cbf:	8b 45 08             	mov    0x8(%ebp),%eax
  103cc2:	89 04 24             	mov    %eax,(%esp)
  103cc5:	e8 8a ff ff ff       	call   103c54 <page2pa>
  103cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
  103ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103cd0:	c1 e8 0c             	shr    $0xc,%eax
  103cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
  103cd6:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  103cdb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
  103cde:	72 23                	jb     103d03 <page2kva+0x4a>
  103ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ce3:	89 44 24 0c          	mov    %eax,0xc(%esp)
  103ce7:	c7 44 24 08 3c 6d 10 	movl   $0x106d3c,0x8(%esp)
  103cee:	00 
  103cef:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
  103cf6:	00 
  103cf7:	c7 04 24 2b 6d 10 00 	movl   $0x106d2b,(%esp)
  103cfe:	e8 a5 cf ff ff       	call   100ca8 <__panic>
  103d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103d06:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
  103d0b:	c9                   	leave  
  103d0c:	c3                   	ret    

00103d0d <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
  103d0d:	55                   	push   %ebp
  103d0e:	89 e5                	mov    %esp,%ebp
  103d10:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
  103d13:	8b 45 08             	mov    0x8(%ebp),%eax
  103d16:	83 e0 01             	and    $0x1,%eax
  103d19:	85 c0                	test   %eax,%eax
  103d1b:	75 1c                	jne    103d39 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
  103d1d:	c7 44 24 08 60 6d 10 	movl   $0x106d60,0x8(%esp)
  103d24:	00 
  103d25:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
  103d2c:	00 
  103d2d:	c7 04 24 2b 6d 10 00 	movl   $0x106d2b,(%esp)
  103d34:	e8 6f cf ff ff       	call   100ca8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
  103d39:	8b 45 08             	mov    0x8(%ebp),%eax
  103d3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d41:	89 04 24             	mov    %eax,(%esp)
  103d44:	e8 21 ff ff ff       	call   103c6a <pa2page>
}
  103d49:	c9                   	leave  
  103d4a:	c3                   	ret    

00103d4b <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
  103d4b:	55                   	push   %ebp
  103d4c:	89 e5                	mov    %esp,%ebp
  103d4e:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
  103d51:	8b 45 08             	mov    0x8(%ebp),%eax
  103d54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  103d59:	89 04 24             	mov    %eax,(%esp)
  103d5c:	e8 09 ff ff ff       	call   103c6a <pa2page>
}
  103d61:	c9                   	leave  
  103d62:	c3                   	ret    

00103d63 <page_ref>:

static inline int
page_ref(struct Page *page) {
  103d63:	55                   	push   %ebp
  103d64:	89 e5                	mov    %esp,%ebp
    return page->ref;
  103d66:	8b 45 08             	mov    0x8(%ebp),%eax
  103d69:	8b 00                	mov    (%eax),%eax
}
  103d6b:	5d                   	pop    %ebp
  103d6c:	c3                   	ret    

00103d6d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
  103d6d:	55                   	push   %ebp
  103d6e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
  103d70:	8b 45 08             	mov    0x8(%ebp),%eax
  103d73:	8b 55 0c             	mov    0xc(%ebp),%edx
  103d76:	89 10                	mov    %edx,(%eax)
}
  103d78:	5d                   	pop    %ebp
  103d79:	c3                   	ret    

00103d7a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
  103d7a:	55                   	push   %ebp
  103d7b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
  103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  103d80:	8b 00                	mov    (%eax),%eax
  103d82:	8d 50 01             	lea    0x1(%eax),%edx
  103d85:	8b 45 08             	mov    0x8(%ebp),%eax
  103d88:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103d8a:	8b 45 08             	mov    0x8(%ebp),%eax
  103d8d:	8b 00                	mov    (%eax),%eax
}
  103d8f:	5d                   	pop    %ebp
  103d90:	c3                   	ret    

00103d91 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
  103d91:	55                   	push   %ebp
  103d92:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
  103d94:	8b 45 08             	mov    0x8(%ebp),%eax
  103d97:	8b 00                	mov    (%eax),%eax
  103d99:	8d 50 ff             	lea    -0x1(%eax),%edx
  103d9c:	8b 45 08             	mov    0x8(%ebp),%eax
  103d9f:	89 10                	mov    %edx,(%eax)
    return page->ref;
  103da1:	8b 45 08             	mov    0x8(%ebp),%eax
  103da4:	8b 00                	mov    (%eax),%eax
}
  103da6:	5d                   	pop    %ebp
  103da7:	c3                   	ret    

00103da8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
  103da8:	55                   	push   %ebp
  103da9:	89 e5                	mov    %esp,%ebp
  103dab:	53                   	push   %ebx
  103dac:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
  103daf:	9c                   	pushf  
  103db0:	5b                   	pop    %ebx
  103db1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
  103db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
  103db7:	25 00 02 00 00       	and    $0x200,%eax
  103dbc:	85 c0                	test   %eax,%eax
  103dbe:	74 0c                	je     103dcc <__intr_save+0x24>
        intr_disable();
  103dc0:	e8 75 d9 ff ff       	call   10173a <intr_disable>
        return 1;
  103dc5:	b8 01 00 00 00       	mov    $0x1,%eax
  103dca:	eb 05                	jmp    103dd1 <__intr_save+0x29>
    }
    return 0;
  103dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
  103dd1:	83 c4 14             	add    $0x14,%esp
  103dd4:	5b                   	pop    %ebx
  103dd5:	5d                   	pop    %ebp
  103dd6:	c3                   	ret    

00103dd7 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
  103dd7:	55                   	push   %ebp
  103dd8:	89 e5                	mov    %esp,%ebp
  103dda:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
  103ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  103de1:	74 05                	je     103de8 <__intr_restore+0x11>
        intr_enable();
  103de3:	e8 4c d9 ff ff       	call   101734 <intr_enable>
    }
}
  103de8:	c9                   	leave  
  103de9:	c3                   	ret    

00103dea <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
  103dea:	55                   	push   %ebp
  103deb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
  103ded:	8b 45 08             	mov    0x8(%ebp),%eax
  103df0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
  103df3:	b8 23 00 00 00       	mov    $0x23,%eax
  103df8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
  103dfa:	b8 23 00 00 00       	mov    $0x23,%eax
  103dff:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
  103e01:	b8 10 00 00 00       	mov    $0x10,%eax
  103e06:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
  103e08:	b8 10 00 00 00       	mov    $0x10,%eax
  103e0d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
  103e0f:	b8 10 00 00 00       	mov    $0x10,%eax
  103e14:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
  103e16:	ea 1d 3e 10 00 08 00 	ljmp   $0x8,$0x103e1d
}
  103e1d:	5d                   	pop    %ebp
  103e1e:	c3                   	ret    

00103e1f <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
  103e1f:	55                   	push   %ebp
  103e20:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
  103e22:	8b 45 08             	mov    0x8(%ebp),%eax
  103e25:	a3 e4 98 11 00       	mov    %eax,0x1198e4
}
  103e2a:	5d                   	pop    %ebp
  103e2b:	c3                   	ret    

00103e2c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
  103e2c:	55                   	push   %ebp
  103e2d:	89 e5                	mov    %esp,%ebp
  103e2f:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
  103e32:	b8 00 80 11 00       	mov    $0x118000,%eax
  103e37:	89 04 24             	mov    %eax,(%esp)
  103e3a:	e8 e0 ff ff ff       	call   103e1f <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
  103e3f:	66 c7 05 e8 98 11 00 	movw   $0x10,0x1198e8
  103e46:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
  103e48:	66 c7 05 28 8a 11 00 	movw   $0x68,0x118a28
  103e4f:	68 00 
  103e51:	b8 e0 98 11 00       	mov    $0x1198e0,%eax
  103e56:	66 a3 2a 8a 11 00    	mov    %ax,0x118a2a
  103e5c:	b8 e0 98 11 00       	mov    $0x1198e0,%eax
  103e61:	c1 e8 10             	shr    $0x10,%eax
  103e64:	a2 2c 8a 11 00       	mov    %al,0x118a2c
  103e69:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e70:	83 e0 f0             	and    $0xfffffff0,%eax
  103e73:	83 c8 09             	or     $0x9,%eax
  103e76:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e7b:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e82:	83 e0 ef             	and    $0xffffffef,%eax
  103e85:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e8a:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103e91:	83 e0 9f             	and    $0xffffff9f,%eax
  103e94:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103e99:	0f b6 05 2d 8a 11 00 	movzbl 0x118a2d,%eax
  103ea0:	83 c8 80             	or     $0xffffff80,%eax
  103ea3:	a2 2d 8a 11 00       	mov    %al,0x118a2d
  103ea8:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103eaf:	83 e0 f0             	and    $0xfffffff0,%eax
  103eb2:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103eb7:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103ebe:	83 e0 ef             	and    $0xffffffef,%eax
  103ec1:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ec6:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103ecd:	83 e0 df             	and    $0xffffffdf,%eax
  103ed0:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ed5:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103edc:	83 c8 40             	or     $0x40,%eax
  103edf:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ee4:	0f b6 05 2e 8a 11 00 	movzbl 0x118a2e,%eax
  103eeb:	83 e0 7f             	and    $0x7f,%eax
  103eee:	a2 2e 8a 11 00       	mov    %al,0x118a2e
  103ef3:	b8 e0 98 11 00       	mov    $0x1198e0,%eax
  103ef8:	c1 e8 18             	shr    $0x18,%eax
  103efb:	a2 2f 8a 11 00       	mov    %al,0x118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
  103f00:	c7 04 24 30 8a 11 00 	movl   $0x118a30,(%esp)
  103f07:	e8 de fe ff ff       	call   103dea <lgdt>
  103f0c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
  103f12:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
  103f16:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
  103f19:	c9                   	leave  
  103f1a:	c3                   	ret    

00103f1b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
  103f1b:	55                   	push   %ebp
  103f1c:	89 e5                	mov    %esp,%ebp
  103f1e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
  103f21:	c7 05 5c 99 11 00 f0 	movl   $0x106cf0,0x11995c
  103f28:	6c 10 00 
    cprintf("memory management: %s\n", pmm_manager->name);
  103f2b:	a1 5c 99 11 00       	mov    0x11995c,%eax
  103f30:	8b 00                	mov    (%eax),%eax
  103f32:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f36:	c7 04 24 8c 6d 10 00 	movl   $0x106d8c,(%esp)
  103f3d:	e8 05 c4 ff ff       	call   100347 <cprintf>
    pmm_manager->init();
  103f42:	a1 5c 99 11 00       	mov    0x11995c,%eax
  103f47:	8b 40 04             	mov    0x4(%eax),%eax
  103f4a:	ff d0                	call   *%eax
}
  103f4c:	c9                   	leave  
  103f4d:	c3                   	ret    

00103f4e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
  103f4e:	55                   	push   %ebp
  103f4f:	89 e5                	mov    %esp,%ebp
  103f51:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
  103f54:	a1 5c 99 11 00       	mov    0x11995c,%eax
  103f59:	8b 50 08             	mov    0x8(%eax),%edx
  103f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
  103f5f:	89 44 24 04          	mov    %eax,0x4(%esp)
  103f63:	8b 45 08             	mov    0x8(%ebp),%eax
  103f66:	89 04 24             	mov    %eax,(%esp)
  103f69:	ff d2                	call   *%edx
}
  103f6b:	c9                   	leave  
  103f6c:	c3                   	ret    

00103f6d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
  103f6d:	55                   	push   %ebp
  103f6e:	89 e5                	mov    %esp,%ebp
  103f70:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
  103f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
  103f7a:	e8 29 fe ff ff       	call   103da8 <__intr_save>
  103f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
  103f82:	a1 5c 99 11 00       	mov    0x11995c,%eax
  103f87:	8b 50 0c             	mov    0xc(%eax),%edx
  103f8a:	8b 45 08             	mov    0x8(%ebp),%eax
  103f8d:	89 04 24             	mov    %eax,(%esp)
  103f90:	ff d2                	call   *%edx
  103f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
  103f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
  103f98:	89 04 24             	mov    %eax,(%esp)
  103f9b:	e8 37 fe ff ff       	call   103dd7 <__intr_restore>
    return page;
  103fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  103fa3:	c9                   	leave  
  103fa4:	c3                   	ret    

00103fa5 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
  103fa5:	55                   	push   %ebp
  103fa6:	89 e5                	mov    %esp,%ebp
  103fa8:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
  103fab:	e8 f8 fd ff ff       	call   103da8 <__intr_save>
  103fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
  103fb3:	a1 5c 99 11 00       	mov    0x11995c,%eax
  103fb8:	8b 50 10             	mov    0x10(%eax),%edx
  103fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
  103fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
  103fc2:	8b 45 08             	mov    0x8(%ebp),%eax
  103fc5:	89 04 24             	mov    %eax,(%esp)
  103fc8:	ff d2                	call   *%edx
    }
    local_intr_restore(intr_flag);
  103fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103fcd:	89 04 24             	mov    %eax,(%esp)
  103fd0:	e8 02 fe ff ff       	call   103dd7 <__intr_restore>
}
  103fd5:	c9                   	leave  
  103fd6:	c3                   	ret    

00103fd7 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
  103fd7:	55                   	push   %ebp
  103fd8:	89 e5                	mov    %esp,%ebp
  103fda:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
  103fdd:	e8 c6 fd ff ff       	call   103da8 <__intr_save>
  103fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
  103fe5:	a1 5c 99 11 00       	mov    0x11995c,%eax
  103fea:	8b 40 14             	mov    0x14(%eax),%eax
  103fed:	ff d0                	call   *%eax
  103fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
  103ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  103ff5:	89 04 24             	mov    %eax,(%esp)
  103ff8:	e8 da fd ff ff       	call   103dd7 <__intr_restore>
    return ret;
  103ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  104000:	c9                   	leave  
  104001:	c3                   	ret    

00104002 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
  104002:	55                   	push   %ebp
  104003:	89 e5                	mov    %esp,%ebp
  104005:	57                   	push   %edi
  104006:	56                   	push   %esi
  104007:	53                   	push   %ebx
  104008:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
  10400e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
  104015:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
  10401c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
  104023:	c7 04 24 a3 6d 10 00 	movl   $0x106da3,(%esp)
  10402a:	e8 18 c3 ff ff       	call   100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  10402f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104036:	e9 0b 01 00 00       	jmp    104146 <page_init+0x144>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10403b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10403e:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104041:	89 d0                	mov    %edx,%eax
  104043:	c1 e0 02             	shl    $0x2,%eax
  104046:	01 d0                	add    %edx,%eax
  104048:	c1 e0 02             	shl    $0x2,%eax
  10404b:	01 c8                	add    %ecx,%eax
  10404d:	8b 50 08             	mov    0x8(%eax),%edx
  104050:	8b 40 04             	mov    0x4(%eax),%eax
  104053:	89 45 b8             	mov    %eax,-0x48(%ebp)
  104056:	89 55 bc             	mov    %edx,-0x44(%ebp)
  104059:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10405c:	8b 55 dc             	mov    -0x24(%ebp),%edx
  10405f:	89 d0                	mov    %edx,%eax
  104061:	c1 e0 02             	shl    $0x2,%eax
  104064:	01 d0                	add    %edx,%eax
  104066:	c1 e0 02             	shl    $0x2,%eax
  104069:	01 c8                	add    %ecx,%eax
  10406b:	8b 50 10             	mov    0x10(%eax),%edx
  10406e:	8b 40 0c             	mov    0xc(%eax),%eax
  104071:	03 45 b8             	add    -0x48(%ebp),%eax
  104074:	13 55 bc             	adc    -0x44(%ebp),%edx
  104077:	89 45 b0             	mov    %eax,-0x50(%ebp)
  10407a:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
  10407d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  104080:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104083:	89 d0                	mov    %edx,%eax
  104085:	c1 e0 02             	shl    $0x2,%eax
  104088:	01 d0                	add    %edx,%eax
  10408a:	c1 e0 02             	shl    $0x2,%eax
  10408d:	01 c8                	add    %ecx,%eax
  10408f:	83 c0 14             	add    $0x14,%eax
  104092:	8b 00                	mov    (%eax),%eax
  104094:	89 45 84             	mov    %eax,-0x7c(%ebp)
  104097:	8b 45 b0             	mov    -0x50(%ebp),%eax
  10409a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10409d:	89 c6                	mov    %eax,%esi
  10409f:	89 d7                	mov    %edx,%edi
  1040a1:	83 c6 ff             	add    $0xffffffff,%esi
  1040a4:	83 d7 ff             	adc    $0xffffffff,%edi
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
  1040a7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
  1040aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040ad:	89 d0                	mov    %edx,%eax
  1040af:	c1 e0 02             	shl    $0x2,%eax
  1040b2:	01 d0                	add    %edx,%eax
  1040b4:	c1 e0 02             	shl    $0x2,%eax
  1040b7:	01 c8                	add    %ecx,%eax
  1040b9:	8b 48 0c             	mov    0xc(%eax),%ecx
  1040bc:	8b 58 10             	mov    0x10(%eax),%ebx
  1040bf:	8b 45 84             	mov    -0x7c(%ebp),%eax
  1040c2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  1040c6:	89 74 24 14          	mov    %esi,0x14(%esp)
  1040ca:	89 7c 24 18          	mov    %edi,0x18(%esp)
  1040ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
  1040d1:	8b 55 bc             	mov    -0x44(%ebp),%edx
  1040d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1040d8:	89 54 24 10          	mov    %edx,0x10(%esp)
  1040dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
  1040e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
  1040e4:	c7 04 24 b0 6d 10 00 	movl   $0x106db0,(%esp)
  1040eb:	e8 57 c2 ff ff       	call   100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
  1040f0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1040f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1040f6:	89 d0                	mov    %edx,%eax
  1040f8:	c1 e0 02             	shl    $0x2,%eax
  1040fb:	01 d0                	add    %edx,%eax
  1040fd:	c1 e0 02             	shl    $0x2,%eax
  104100:	01 c8                	add    %ecx,%eax
  104102:	83 c0 14             	add    $0x14,%eax
  104105:	8b 00                	mov    (%eax),%eax
  104107:	83 f8 01             	cmp    $0x1,%eax
  10410a:	75 36                	jne    104142 <page_init+0x140>
            if (maxpa < end && begin < KMEMSIZE) {
  10410c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10410f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104112:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  104115:	77 2b                	ja     104142 <page_init+0x140>
  104117:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
  10411a:	72 05                	jb     104121 <page_init+0x11f>
  10411c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
  10411f:	73 21                	jae    104142 <page_init+0x140>
  104121:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  104125:	77 1b                	ja     104142 <page_init+0x140>
  104127:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
  10412b:	72 09                	jb     104136 <page_init+0x134>
  10412d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
  104134:	77 0c                	ja     104142 <page_init+0x140>
                maxpa = end;
  104136:	8b 45 b0             	mov    -0x50(%ebp),%eax
  104139:	8b 55 b4             	mov    -0x4c(%ebp),%edx
  10413c:	89 45 e0             	mov    %eax,-0x20(%ebp)
  10413f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
  104142:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  104146:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  104149:	8b 00                	mov    (%eax),%eax
  10414b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  10414e:	0f 8f e7 fe ff ff    	jg     10403b <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
  104154:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  104158:	72 1d                	jb     104177 <page_init+0x175>
  10415a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  10415e:	77 09                	ja     104169 <page_init+0x167>
  104160:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
  104167:	76 0e                	jbe    104177 <page_init+0x175>
        maxpa = KMEMSIZE;
  104169:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
  104170:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
  104177:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10417a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  10417d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  104181:	c1 ea 0c             	shr    $0xc,%edx
  104184:	a3 c0 98 11 00       	mov    %eax,0x1198c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
  104189:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
  104190:	b8 68 99 11 00       	mov    $0x119968,%eax
  104195:	83 e8 01             	sub    $0x1,%eax
  104198:	03 45 ac             	add    -0x54(%ebp),%eax
  10419b:	89 45 a8             	mov    %eax,-0x58(%ebp)
  10419e:	8b 45 a8             	mov    -0x58(%ebp),%eax
  1041a1:	ba 00 00 00 00       	mov    $0x0,%edx
  1041a6:	f7 75 ac             	divl   -0x54(%ebp)
  1041a9:	89 d0                	mov    %edx,%eax
  1041ab:	8b 55 a8             	mov    -0x58(%ebp),%edx
  1041ae:	89 d1                	mov    %edx,%ecx
  1041b0:	29 c1                	sub    %eax,%ecx
  1041b2:	89 c8                	mov    %ecx,%eax
  1041b4:	a3 64 99 11 00       	mov    %eax,0x119964

    for (i = 0; i < npage; i ++) {
  1041b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  1041c0:	eb 2f                	jmp    1041f1 <page_init+0x1ef>
        SetPageReserved(pages + i);
  1041c2:	8b 0d 64 99 11 00    	mov    0x119964,%ecx
  1041c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041cb:	89 d0                	mov    %edx,%eax
  1041cd:	c1 e0 02             	shl    $0x2,%eax
  1041d0:	01 d0                	add    %edx,%eax
  1041d2:	c1 e0 02             	shl    $0x2,%eax
  1041d5:	01 c8                	add    %ecx,%eax
  1041d7:	83 c0 04             	add    $0x4,%eax
  1041da:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
  1041e1:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
  1041e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
  1041e7:	8b 55 90             	mov    -0x70(%ebp),%edx
  1041ea:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
  1041ed:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1041f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1041f4:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  1041f9:	39 c2                	cmp    %eax,%edx
  1041fb:	72 c5                	jb     1041c2 <page_init+0x1c0>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
  1041fd:	8b 15 c0 98 11 00    	mov    0x1198c0,%edx
  104203:	89 d0                	mov    %edx,%eax
  104205:	c1 e0 02             	shl    $0x2,%eax
  104208:	01 d0                	add    %edx,%eax
  10420a:	c1 e0 02             	shl    $0x2,%eax
  10420d:	89 c2                	mov    %eax,%edx
  10420f:	a1 64 99 11 00       	mov    0x119964,%eax
  104214:	01 d0                	add    %edx,%eax
  104216:	89 45 a4             	mov    %eax,-0x5c(%ebp)
  104219:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
  104220:	77 23                	ja     104245 <page_init+0x243>
  104222:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104225:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104229:	c7 44 24 08 e0 6d 10 	movl   $0x106de0,0x8(%esp)
  104230:	00 
  104231:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
  104238:	00 
  104239:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104240:	e8 63 ca ff ff       	call   100ca8 <__panic>
  104245:	8b 45 a4             	mov    -0x5c(%ebp),%eax
  104248:	05 00 00 00 40       	add    $0x40000000,%eax
  10424d:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
  104250:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  104257:	e9 7c 01 00 00       	jmp    1043d8 <page_init+0x3d6>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
  10425c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10425f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104262:	89 d0                	mov    %edx,%eax
  104264:	c1 e0 02             	shl    $0x2,%eax
  104267:	01 d0                	add    %edx,%eax
  104269:	c1 e0 02             	shl    $0x2,%eax
  10426c:	01 c8                	add    %ecx,%eax
  10426e:	8b 50 08             	mov    0x8(%eax),%edx
  104271:	8b 40 04             	mov    0x4(%eax),%eax
  104274:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104277:	89 55 d4             	mov    %edx,-0x2c(%ebp)
  10427a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  10427d:	8b 55 dc             	mov    -0x24(%ebp),%edx
  104280:	89 d0                	mov    %edx,%eax
  104282:	c1 e0 02             	shl    $0x2,%eax
  104285:	01 d0                	add    %edx,%eax
  104287:	c1 e0 02             	shl    $0x2,%eax
  10428a:	01 c8                	add    %ecx,%eax
  10428c:	8b 50 10             	mov    0x10(%eax),%edx
  10428f:	8b 40 0c             	mov    0xc(%eax),%eax
  104292:	03 45 d0             	add    -0x30(%ebp),%eax
  104295:	13 55 d4             	adc    -0x2c(%ebp),%edx
  104298:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10429b:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
  10429e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
  1042a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
  1042a4:	89 d0                	mov    %edx,%eax
  1042a6:	c1 e0 02             	shl    $0x2,%eax
  1042a9:	01 d0                	add    %edx,%eax
  1042ab:	c1 e0 02             	shl    $0x2,%eax
  1042ae:	01 c8                	add    %ecx,%eax
  1042b0:	83 c0 14             	add    $0x14,%eax
  1042b3:	8b 00                	mov    (%eax),%eax
  1042b5:	83 f8 01             	cmp    $0x1,%eax
  1042b8:	0f 85 16 01 00 00    	jne    1043d4 <page_init+0x3d2>
            if (begin < freemem) {
  1042be:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1042c1:	ba 00 00 00 00       	mov    $0x0,%edx
  1042c6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1042c9:	72 17                	jb     1042e2 <page_init+0x2e0>
  1042cb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  1042ce:	77 05                	ja     1042d5 <page_init+0x2d3>
  1042d0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  1042d3:	76 0d                	jbe    1042e2 <page_init+0x2e0>
                begin = freemem;
  1042d5:	8b 45 a0             	mov    -0x60(%ebp),%eax
  1042d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1042db:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
  1042e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1042e6:	72 1d                	jb     104305 <page_init+0x303>
  1042e8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
  1042ec:	77 09                	ja     1042f7 <page_init+0x2f5>
  1042ee:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
  1042f5:	76 0e                	jbe    104305 <page_init+0x303>
                end = KMEMSIZE;
  1042f7:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
  1042fe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
  104305:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104308:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  10430b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10430e:	0f 87 c0 00 00 00    	ja     1043d4 <page_init+0x3d2>
  104314:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104317:	72 09                	jb     104322 <page_init+0x320>
  104319:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  10431c:	0f 83 b2 00 00 00    	jae    1043d4 <page_init+0x3d2>
                begin = ROUNDUP(begin, PGSIZE);
  104322:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
  104329:	8b 45 d0             	mov    -0x30(%ebp),%eax
  10432c:	03 45 9c             	add    -0x64(%ebp),%eax
  10432f:	83 e8 01             	sub    $0x1,%eax
  104332:	89 45 98             	mov    %eax,-0x68(%ebp)
  104335:	8b 45 98             	mov    -0x68(%ebp),%eax
  104338:	ba 00 00 00 00       	mov    $0x0,%edx
  10433d:	f7 75 9c             	divl   -0x64(%ebp)
  104340:	89 d0                	mov    %edx,%eax
  104342:	8b 55 98             	mov    -0x68(%ebp),%edx
  104345:	89 d1                	mov    %edx,%ecx
  104347:	29 c1                	sub    %eax,%ecx
  104349:	89 c8                	mov    %ecx,%eax
  10434b:	ba 00 00 00 00       	mov    $0x0,%edx
  104350:	89 45 d0             	mov    %eax,-0x30(%ebp)
  104353:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
  104356:	8b 45 c8             	mov    -0x38(%ebp),%eax
  104359:	89 45 94             	mov    %eax,-0x6c(%ebp)
  10435c:	8b 45 94             	mov    -0x6c(%ebp),%eax
  10435f:	ba 00 00 00 00       	mov    $0x0,%edx
  104364:	89 c1                	mov    %eax,%ecx
  104366:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
  10436c:	89 8d 78 ff ff ff    	mov    %ecx,-0x88(%ebp)
  104372:	89 d1                	mov    %edx,%ecx
  104374:	83 e1 00             	and    $0x0,%ecx
  104377:	89 8d 7c ff ff ff    	mov    %ecx,-0x84(%ebp)
  10437d:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
  104383:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
  104389:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10438c:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
  10438f:	8b 45 d0             	mov    -0x30(%ebp),%eax
  104392:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  104395:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  104398:	77 3a                	ja     1043d4 <page_init+0x3d2>
  10439a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
  10439d:	72 05                	jb     1043a4 <page_init+0x3a2>
  10439f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
  1043a2:	73 30                	jae    1043d4 <page_init+0x3d2>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
  1043a4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1043a7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
  1043aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1043ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1043b0:	29 c8                	sub    %ecx,%eax
  1043b2:	19 da                	sbb    %ebx,%edx
  1043b4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  1043b8:	c1 ea 0c             	shr    $0xc,%edx
  1043bb:	89 c3                	mov    %eax,%ebx
  1043bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1043c0:	89 04 24             	mov    %eax,(%esp)
  1043c3:	e8 a2 f8 ff ff       	call   103c6a <pa2page>
  1043c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
  1043cc:	89 04 24             	mov    %eax,(%esp)
  1043cf:	e8 7a fb ff ff       	call   103f4e <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
  1043d4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
  1043d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
  1043db:	8b 00                	mov    (%eax),%eax
  1043dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
  1043e0:	0f 8f 76 fe ff ff    	jg     10425c <page_init+0x25a>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
  1043e6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
  1043ec:	5b                   	pop    %ebx
  1043ed:	5e                   	pop    %esi
  1043ee:	5f                   	pop    %edi
  1043ef:	5d                   	pop    %ebp
  1043f0:	c3                   	ret    

001043f1 <enable_paging>:

static void
enable_paging(void) {
  1043f1:	55                   	push   %ebp
  1043f2:	89 e5                	mov    %esp,%ebp
  1043f4:	53                   	push   %ebx
  1043f5:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
  1043f8:	a1 60 99 11 00       	mov    0x119960,%eax
  1043fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
  104400:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104403:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
  104406:	0f 20 c3             	mov    %cr0,%ebx
  104409:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr0;
  10440c:	8b 45 f0             	mov    -0x10(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
  10440f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
  104412:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
  104419:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
  10441d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  104420:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
  104423:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104426:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
  104429:	83 c4 10             	add    $0x10,%esp
  10442c:	5b                   	pop    %ebx
  10442d:	5d                   	pop    %ebp
  10442e:	c3                   	ret    

0010442f <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
  10442f:	55                   	push   %ebp
  104430:	89 e5                	mov    %esp,%ebp
  104432:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
  104435:	8b 45 14             	mov    0x14(%ebp),%eax
  104438:	8b 55 0c             	mov    0xc(%ebp),%edx
  10443b:	31 d0                	xor    %edx,%eax
  10443d:	25 ff 0f 00 00       	and    $0xfff,%eax
  104442:	85 c0                	test   %eax,%eax
  104444:	74 24                	je     10446a <boot_map_segment+0x3b>
  104446:	c7 44 24 0c 12 6e 10 	movl   $0x106e12,0xc(%esp)
  10444d:	00 
  10444e:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104455:	00 
  104456:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
  10445d:	00 
  10445e:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104465:	e8 3e c8 ff ff       	call   100ca8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
  10446a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
  104471:	8b 45 0c             	mov    0xc(%ebp),%eax
  104474:	25 ff 0f 00 00       	and    $0xfff,%eax
  104479:	03 45 10             	add    0x10(%ebp),%eax
  10447c:	03 45 f0             	add    -0x10(%ebp),%eax
  10447f:	83 e8 01             	sub    $0x1,%eax
  104482:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104485:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104488:	ba 00 00 00 00       	mov    $0x0,%edx
  10448d:	f7 75 f0             	divl   -0x10(%ebp)
  104490:	89 d0                	mov    %edx,%eax
  104492:	8b 55 ec             	mov    -0x14(%ebp),%edx
  104495:	89 d1                	mov    %edx,%ecx
  104497:	29 c1                	sub    %eax,%ecx
  104499:	89 c8                	mov    %ecx,%eax
  10449b:	c1 e8 0c             	shr    $0xc,%eax
  10449e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
  1044a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1044a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1044aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1044af:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
  1044b2:	8b 45 14             	mov    0x14(%ebp),%eax
  1044b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1044b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1044bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  1044c0:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  1044c3:	eb 6b                	jmp    104530 <boot_map_segment+0x101>
        pte_t *ptep = get_pte(pgdir, la, 1);
  1044c5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  1044cc:	00 
  1044cd:	8b 45 0c             	mov    0xc(%ebp),%eax
  1044d0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1044d4:	8b 45 08             	mov    0x8(%ebp),%eax
  1044d7:	89 04 24             	mov    %eax,(%esp)
  1044da:	e8 cc 01 00 00       	call   1046ab <get_pte>
  1044df:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
  1044e2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
  1044e6:	75 24                	jne    10450c <boot_map_segment+0xdd>
  1044e8:	c7 44 24 0c 3e 6e 10 	movl   $0x106e3e,0xc(%esp)
  1044ef:	00 
  1044f0:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  1044f7:	00 
  1044f8:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
  1044ff:	00 
  104500:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104507:	e8 9c c7 ff ff       	call   100ca8 <__panic>
        *ptep = pa | PTE_P | perm;
  10450c:	8b 45 18             	mov    0x18(%ebp),%eax
  10450f:	8b 55 14             	mov    0x14(%ebp),%edx
  104512:	09 d0                	or     %edx,%eax
  104514:	89 c2                	mov    %eax,%edx
  104516:	83 ca 01             	or     $0x1,%edx
  104519:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10451c:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
  10451e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
  104522:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
  104529:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
  104530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104534:	75 8f                	jne    1044c5 <boot_map_segment+0x96>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
  104536:	c9                   	leave  
  104537:	c3                   	ret    

00104538 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
  104538:	55                   	push   %ebp
  104539:	89 e5                	mov    %esp,%ebp
  10453b:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
  10453e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104545:	e8 23 fa ff ff       	call   103f6d <alloc_pages>
  10454a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
  10454d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104551:	75 1c                	jne    10456f <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
  104553:	c7 44 24 08 4b 6e 10 	movl   $0x106e4b,0x8(%esp)
  10455a:	00 
  10455b:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
  104562:	00 
  104563:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  10456a:	e8 39 c7 ff ff       	call   100ca8 <__panic>
    }
    return page2kva(p);
  10456f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104572:	89 04 24             	mov    %eax,(%esp)
  104575:	e8 3f f7 ff ff       	call   103cb9 <page2kva>
}
  10457a:	c9                   	leave  
  10457b:	c3                   	ret    

0010457c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
  10457c:	55                   	push   %ebp
  10457d:	89 e5                	mov    %esp,%ebp
  10457f:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
  104582:	e8 94 f9 ff ff       	call   103f1b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
  104587:	e8 76 fa ff ff       	call   104002 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
  10458c:	e8 7f 04 00 00       	call   104a10 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
  104591:	e8 a2 ff ff ff       	call   104538 <boot_alloc_page>
  104596:	a3 c4 98 11 00       	mov    %eax,0x1198c4
    memset(boot_pgdir, 0, PGSIZE);
  10459b:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1045a0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  1045a7:	00 
  1045a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  1045af:	00 
  1045b0:	89 04 24             	mov    %eax,(%esp)
  1045b3:	e8 0f 1b 00 00       	call   1060c7 <memset>
    boot_cr3 = PADDR(boot_pgdir);
  1045b8:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1045bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1045c0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1045c7:	77 23                	ja     1045ec <pmm_init+0x70>
  1045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1045d0:	c7 44 24 08 e0 6d 10 	movl   $0x106de0,0x8(%esp)
  1045d7:	00 
  1045d8:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
  1045df:	00 
  1045e0:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  1045e7:	e8 bc c6 ff ff       	call   100ca8 <__panic>
  1045ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1045ef:	05 00 00 00 40       	add    $0x40000000,%eax
  1045f4:	a3 60 99 11 00       	mov    %eax,0x119960

    check_pgdir();
  1045f9:	e8 30 04 00 00       	call   104a2e <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
  1045fe:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104603:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
  104609:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  10460e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104611:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
  104618:	77 23                	ja     10463d <pmm_init+0xc1>
  10461a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10461d:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104621:	c7 44 24 08 e0 6d 10 	movl   $0x106de0,0x8(%esp)
  104628:	00 
  104629:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
  104630:	00 
  104631:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104638:	e8 6b c6 ff ff       	call   100ca8 <__panic>
  10463d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104640:	05 00 00 00 40       	add    $0x40000000,%eax
  104645:	83 c8 03             	or     $0x3,%eax
  104648:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
  10464a:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  10464f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
  104656:	00 
  104657:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  10465e:	00 
  10465f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
  104666:	38 
  104667:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
  10466e:	c0 
  10466f:	89 04 24             	mov    %eax,(%esp)
  104672:	e8 b8 fd ff ff       	call   10442f <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
  104677:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  10467c:	8b 15 c4 98 11 00    	mov    0x1198c4,%edx
  104682:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
  104688:	89 10                	mov    %edx,(%eax)

    enable_paging();
  10468a:	e8 62 fd ff ff       	call   1043f1 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
  10468f:	e8 98 f7 ff ff       	call   103e2c <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
  104694:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104699:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
  10469f:	e8 25 0a 00 00       	call   1050c9 <check_boot_pgdir>

    print_pgdir();
  1046a4:	e8 99 0e 00 00       	call   105542 <print_pgdir>

}
  1046a9:	c9                   	leave  
  1046aa:	c3                   	ret    

001046ab <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
  1046ab:	55                   	push   %ebp
  1046ac:	89 e5                	mov    %esp,%ebp
  1046ae:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
  1046b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1046b4:	c1 e8 16             	shr    $0x16,%eax
  1046b7:	c1 e0 02             	shl    $0x2,%eax
  1046ba:	03 45 08             	add    0x8(%ebp),%eax
  1046bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!(*pdep & PTE_P)) {
  1046c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1046c3:	8b 00                	mov    (%eax),%eax
  1046c5:	83 e0 01             	and    $0x1,%eax
  1046c8:	85 c0                	test   %eax,%eax
  1046ca:	0f 85 c4 00 00 00    	jne    104794 <get_pte+0xe9>
        if (!create)
  1046d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1046d4:	75 0a                	jne    1046e0 <get_pte+0x35>
            return NULL;
  1046d6:	b8 00 00 00 00       	mov    $0x0,%eax
  1046db:	e9 10 01 00 00       	jmp    1047f0 <get_pte+0x145>
        struct Page* page;
        if (create && (page = alloc_pages(1)) == NULL)
  1046e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  1046e4:	74 1f                	je     104705 <get_pte+0x5a>
  1046e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  1046ed:	e8 7b f8 ff ff       	call   103f6d <alloc_pages>
  1046f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1046f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1046f9:	75 0a                	jne    104705 <get_pte+0x5a>
            return NULL;
  1046fb:	b8 00 00 00 00       	mov    $0x0,%eax
  104700:	e9 eb 00 00 00       	jmp    1047f0 <get_pte+0x145>
        set_page_ref(page, 1);
  104705:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  10470c:	00 
  10470d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104710:	89 04 24             	mov    %eax,(%esp)
  104713:	e8 55 f6 ff ff       	call   103d6d <set_page_ref>
        uintptr_t phia = page2pa(page);
  104718:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10471b:	89 04 24             	mov    %eax,(%esp)
  10471e:	e8 31 f5 ff ff       	call   103c54 <page2pa>
  104723:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(phia), 0, PGSIZE);
  104726:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104729:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10472c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10472f:	c1 e8 0c             	shr    $0xc,%eax
  104732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  104735:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  10473a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
  10473d:	72 23                	jb     104762 <get_pte+0xb7>
  10473f:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104742:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104746:	c7 44 24 08 3c 6d 10 	movl   $0x106d3c,0x8(%esp)
  10474d:	00 
  10474e:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
  104755:	00 
  104756:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  10475d:	e8 46 c5 ff ff       	call   100ca8 <__panic>
  104762:	8b 45 e8             	mov    -0x18(%ebp),%eax
  104765:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10476a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104771:	00 
  104772:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104779:	00 
  10477a:	89 04 24             	mov    %eax,(%esp)
  10477d:	e8 45 19 00 00       	call   1060c7 <memset>
        *pdep = PDE_ADDR(phia) | PTE_U | PTE_W | PTE_P;
  104782:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104785:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10478a:	89 c2                	mov    %eax,%edx
  10478c:	83 ca 07             	or     $0x7,%edx
  10478f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104792:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];}
  104794:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104797:	8b 00                	mov    (%eax),%eax
  104799:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  10479e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  1047a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1047a4:	c1 e8 0c             	shr    $0xc,%eax
  1047a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
  1047aa:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  1047af:	39 45 dc             	cmp    %eax,-0x24(%ebp)
  1047b2:	72 23                	jb     1047d7 <get_pte+0x12c>
  1047b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1047b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1047bb:	c7 44 24 08 3c 6d 10 	movl   $0x106d3c,0x8(%esp)
  1047c2:	00 
  1047c3:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
  1047ca:	00 
  1047cb:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  1047d2:	e8 d1 c4 ff ff       	call   100ca8 <__panic>
  1047d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1047da:	2d 00 00 00 40       	sub    $0x40000000,%eax
  1047df:	8b 55 0c             	mov    0xc(%ebp),%edx
  1047e2:	c1 ea 0c             	shr    $0xc,%edx
  1047e5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
  1047eb:	c1 e2 02             	shl    $0x2,%edx
  1047ee:	01 d0                	add    %edx,%eax
  1047f0:	c9                   	leave  
  1047f1:	c3                   	ret    

001047f2 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
  1047f2:	55                   	push   %ebp
  1047f3:	89 e5                	mov    %esp,%ebp
  1047f5:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1047f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1047ff:	00 
  104800:	8b 45 0c             	mov    0xc(%ebp),%eax
  104803:	89 44 24 04          	mov    %eax,0x4(%esp)
  104807:	8b 45 08             	mov    0x8(%ebp),%eax
  10480a:	89 04 24             	mov    %eax,(%esp)
  10480d:	e8 99 fe ff ff       	call   1046ab <get_pte>
  104812:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
  104815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  104819:	74 08                	je     104823 <get_page+0x31>
        *ptep_store = ptep;
  10481b:	8b 45 10             	mov    0x10(%ebp),%eax
  10481e:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104821:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
  104823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  104827:	74 1b                	je     104844 <get_page+0x52>
  104829:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10482c:	8b 00                	mov    (%eax),%eax
  10482e:	83 e0 01             	and    $0x1,%eax
  104831:	84 c0                	test   %al,%al
  104833:	74 0f                	je     104844 <get_page+0x52>
        return pte2page(*ptep);
  104835:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104838:	8b 00                	mov    (%eax),%eax
  10483a:	89 04 24             	mov    %eax,(%esp)
  10483d:	e8 cb f4 ff ff       	call   103d0d <pte2page>
  104842:	eb 05                	jmp    104849 <get_page+0x57>
    }
    return NULL;
  104844:	b8 00 00 00 00       	mov    $0x0,%eax
}
  104849:	c9                   	leave  
  10484a:	c3                   	ret    

0010484b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
  10484b:	55                   	push   %ebp
  10484c:	89 e5                	mov    %esp,%ebp
  10484e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P){
  104851:	8b 45 10             	mov    0x10(%ebp),%eax
  104854:	8b 00                	mov    (%eax),%eax
  104856:	83 e0 01             	and    $0x1,%eax
  104859:	84 c0                	test   %al,%al
  10485b:	74 52                	je     1048af <page_remove_pte+0x64>
        struct Page *page = pte2page(*ptep);
  10485d:	8b 45 10             	mov    0x10(%ebp),%eax
  104860:	8b 00                	mov    (%eax),%eax
  104862:	89 04 24             	mov    %eax,(%esp)
  104865:	e8 a3 f4 ff ff       	call   103d0d <pte2page>
  10486a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
  10486d:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104870:	89 04 24             	mov    %eax,(%esp)
  104873:	e8 19 f5 ff ff       	call   103d91 <page_ref_dec>
        if(page->ref == 0) {
  104878:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10487b:	8b 00                	mov    (%eax),%eax
  10487d:	85 c0                	test   %eax,%eax
  10487f:	75 13                	jne    104894 <page_remove_pte+0x49>
            free_page(page);
  104881:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  104888:	00 
  104889:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10488c:	89 04 24             	mov    %eax,(%esp)
  10488f:	e8 11 f7 ff ff       	call   103fa5 <free_pages>
        }
        *ptep = 0;
  104894:	8b 45 10             	mov    0x10(%ebp),%eax
  104897:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);
  10489d:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048a0:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048a4:	8b 45 08             	mov    0x8(%ebp),%eax
  1048a7:	89 04 24             	mov    %eax,(%esp)
  1048aa:	e8 ff 00 00 00       	call   1049ae <tlb_invalidate>
    }}
  1048af:	c9                   	leave  
  1048b0:	c3                   	ret    

001048b1 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
  1048b1:	55                   	push   %ebp
  1048b2:	89 e5                	mov    %esp,%ebp
  1048b4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
  1048b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  1048be:	00 
  1048bf:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048c6:	8b 45 08             	mov    0x8(%ebp),%eax
  1048c9:	89 04 24             	mov    %eax,(%esp)
  1048cc:	e8 da fd ff ff       	call   1046ab <get_pte>
  1048d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
  1048d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  1048d8:	74 19                	je     1048f3 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
  1048da:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1048dd:	89 44 24 08          	mov    %eax,0x8(%esp)
  1048e1:	8b 45 0c             	mov    0xc(%ebp),%eax
  1048e4:	89 44 24 04          	mov    %eax,0x4(%esp)
  1048e8:	8b 45 08             	mov    0x8(%ebp),%eax
  1048eb:	89 04 24             	mov    %eax,(%esp)
  1048ee:	e8 58 ff ff ff       	call   10484b <page_remove_pte>
    }
}
  1048f3:	c9                   	leave  
  1048f4:	c3                   	ret    

001048f5 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
  1048f5:	55                   	push   %ebp
  1048f6:	89 e5                	mov    %esp,%ebp
  1048f8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
  1048fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  104902:	00 
  104903:	8b 45 10             	mov    0x10(%ebp),%eax
  104906:	89 44 24 04          	mov    %eax,0x4(%esp)
  10490a:	8b 45 08             	mov    0x8(%ebp),%eax
  10490d:	89 04 24             	mov    %eax,(%esp)
  104910:	e8 96 fd ff ff       	call   1046ab <get_pte>
  104915:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
  104918:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  10491c:	75 0a                	jne    104928 <page_insert+0x33>
        return -E_NO_MEM;
  10491e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
  104923:	e9 84 00 00 00       	jmp    1049ac <page_insert+0xb7>
    }
    page_ref_inc(page);
  104928:	8b 45 0c             	mov    0xc(%ebp),%eax
  10492b:	89 04 24             	mov    %eax,(%esp)
  10492e:	e8 47 f4 ff ff       	call   103d7a <page_ref_inc>
    if (*ptep & PTE_P) {
  104933:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104936:	8b 00                	mov    (%eax),%eax
  104938:	83 e0 01             	and    $0x1,%eax
  10493b:	84 c0                	test   %al,%al
  10493d:	74 3e                	je     10497d <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
  10493f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104942:	8b 00                	mov    (%eax),%eax
  104944:	89 04 24             	mov    %eax,(%esp)
  104947:	e8 c1 f3 ff ff       	call   103d0d <pte2page>
  10494c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
  10494f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104952:	3b 45 0c             	cmp    0xc(%ebp),%eax
  104955:	75 0d                	jne    104964 <page_insert+0x6f>
            page_ref_dec(page);
  104957:	8b 45 0c             	mov    0xc(%ebp),%eax
  10495a:	89 04 24             	mov    %eax,(%esp)
  10495d:	e8 2f f4 ff ff       	call   103d91 <page_ref_dec>
  104962:	eb 19                	jmp    10497d <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
  104964:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104967:	89 44 24 08          	mov    %eax,0x8(%esp)
  10496b:	8b 45 10             	mov    0x10(%ebp),%eax
  10496e:	89 44 24 04          	mov    %eax,0x4(%esp)
  104972:	8b 45 08             	mov    0x8(%ebp),%eax
  104975:	89 04 24             	mov    %eax,(%esp)
  104978:	e8 ce fe ff ff       	call   10484b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
  10497d:	8b 45 0c             	mov    0xc(%ebp),%eax
  104980:	89 04 24             	mov    %eax,(%esp)
  104983:	e8 cc f2 ff ff       	call   103c54 <page2pa>
  104988:	0b 45 14             	or     0x14(%ebp),%eax
  10498b:	89 c2                	mov    %eax,%edx
  10498d:	83 ca 01             	or     $0x1,%edx
  104990:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104993:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
  104995:	8b 45 10             	mov    0x10(%ebp),%eax
  104998:	89 44 24 04          	mov    %eax,0x4(%esp)
  10499c:	8b 45 08             	mov    0x8(%ebp),%eax
  10499f:	89 04 24             	mov    %eax,(%esp)
  1049a2:	e8 07 00 00 00       	call   1049ae <tlb_invalidate>
    return 0;
  1049a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
  1049ac:	c9                   	leave  
  1049ad:	c3                   	ret    

001049ae <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
  1049ae:	55                   	push   %ebp
  1049af:	89 e5                	mov    %esp,%ebp
  1049b1:	53                   	push   %ebx
  1049b2:	83 ec 24             	sub    $0x24,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
  1049b5:	0f 20 db             	mov    %cr3,%ebx
  1049b8:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr3;
  1049bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
  1049be:	89 c2                	mov    %eax,%edx
  1049c0:	8b 45 08             	mov    0x8(%ebp),%eax
  1049c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
  1049c6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
  1049cd:	77 23                	ja     1049f2 <tlb_invalidate+0x44>
  1049cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1049d6:	c7 44 24 08 e0 6d 10 	movl   $0x106de0,0x8(%esp)
  1049dd:	00 
  1049de:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
  1049e5:	00 
  1049e6:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  1049ed:	e8 b6 c2 ff ff       	call   100ca8 <__panic>
  1049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1049f5:	05 00 00 00 40       	add    $0x40000000,%eax
  1049fa:	39 c2                	cmp    %eax,%edx
  1049fc:	75 0c                	jne    104a0a <tlb_invalidate+0x5c>
        invlpg((void *)la);
  1049fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  104a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
  104a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104a07:	0f 01 38             	invlpg (%eax)
    }
}
  104a0a:	83 c4 24             	add    $0x24,%esp
  104a0d:	5b                   	pop    %ebx
  104a0e:	5d                   	pop    %ebp
  104a0f:	c3                   	ret    

00104a10 <check_alloc_page>:

static void
check_alloc_page(void) {
  104a10:	55                   	push   %ebp
  104a11:	89 e5                	mov    %esp,%ebp
  104a13:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
  104a16:	a1 5c 99 11 00       	mov    0x11995c,%eax
  104a1b:	8b 40 18             	mov    0x18(%eax),%eax
  104a1e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
  104a20:	c7 04 24 64 6e 10 00 	movl   $0x106e64,(%esp)
  104a27:	e8 1b b9 ff ff       	call   100347 <cprintf>
}
  104a2c:	c9                   	leave  
  104a2d:	c3                   	ret    

00104a2e <check_pgdir>:

static void
check_pgdir(void) {
  104a2e:	55                   	push   %ebp
  104a2f:	89 e5                	mov    %esp,%ebp
  104a31:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
  104a34:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  104a39:	3d 00 80 03 00       	cmp    $0x38000,%eax
  104a3e:	76 24                	jbe    104a64 <check_pgdir+0x36>
  104a40:	c7 44 24 0c 83 6e 10 	movl   $0x106e83,0xc(%esp)
  104a47:	00 
  104a48:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104a4f:	00 
  104a50:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
  104a57:	00 
  104a58:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104a5f:	e8 44 c2 ff ff       	call   100ca8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
  104a64:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104a69:	85 c0                	test   %eax,%eax
  104a6b:	74 0e                	je     104a7b <check_pgdir+0x4d>
  104a6d:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104a72:	25 ff 0f 00 00       	and    $0xfff,%eax
  104a77:	85 c0                	test   %eax,%eax
  104a79:	74 24                	je     104a9f <check_pgdir+0x71>
  104a7b:	c7 44 24 0c a0 6e 10 	movl   $0x106ea0,0xc(%esp)
  104a82:	00 
  104a83:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104a8a:	00 
  104a8b:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
  104a92:	00 
  104a93:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104a9a:	e8 09 c2 ff ff       	call   100ca8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
  104a9f:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104aa4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104aab:	00 
  104aac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104ab3:	00 
  104ab4:	89 04 24             	mov    %eax,(%esp)
  104ab7:	e8 36 fd ff ff       	call   1047f2 <get_page>
  104abc:	85 c0                	test   %eax,%eax
  104abe:	74 24                	je     104ae4 <check_pgdir+0xb6>
  104ac0:	c7 44 24 0c d8 6e 10 	movl   $0x106ed8,0xc(%esp)
  104ac7:	00 
  104ac8:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104acf:	00 
  104ad0:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
  104ad7:	00 
  104ad8:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104adf:	e8 c4 c1 ff ff       	call   100ca8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
  104ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104aeb:	e8 7d f4 ff ff       	call   103f6d <alloc_pages>
  104af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
  104af3:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104af8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104aff:	00 
  104b00:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b07:	00 
  104b08:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104b0b:	89 54 24 04          	mov    %edx,0x4(%esp)
  104b0f:	89 04 24             	mov    %eax,(%esp)
  104b12:	e8 de fd ff ff       	call   1048f5 <page_insert>
  104b17:	85 c0                	test   %eax,%eax
  104b19:	74 24                	je     104b3f <check_pgdir+0x111>
  104b1b:	c7 44 24 0c 00 6f 10 	movl   $0x106f00,0xc(%esp)
  104b22:	00 
  104b23:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104b2a:	00 
  104b2b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
  104b32:	00 
  104b33:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104b3a:	e8 69 c1 ff ff       	call   100ca8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
  104b3f:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104b44:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104b4b:	00 
  104b4c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104b53:	00 
  104b54:	89 04 24             	mov    %eax,(%esp)
  104b57:	e8 4f fb ff ff       	call   1046ab <get_pte>
  104b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104b5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104b63:	75 24                	jne    104b89 <check_pgdir+0x15b>
  104b65:	c7 44 24 0c 2c 6f 10 	movl   $0x106f2c,0xc(%esp)
  104b6c:	00 
  104b6d:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104b74:	00 
  104b75:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
  104b7c:	00 
  104b7d:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104b84:	e8 1f c1 ff ff       	call   100ca8 <__panic>
    assert(pte2page(*ptep) == p1);
  104b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104b8c:	8b 00                	mov    (%eax),%eax
  104b8e:	89 04 24             	mov    %eax,(%esp)
  104b91:	e8 77 f1 ff ff       	call   103d0d <pte2page>
  104b96:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104b99:	74 24                	je     104bbf <check_pgdir+0x191>
  104b9b:	c7 44 24 0c 59 6f 10 	movl   $0x106f59,0xc(%esp)
  104ba2:	00 
  104ba3:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104baa:	00 
  104bab:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
  104bb2:	00 
  104bb3:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104bba:	e8 e9 c0 ff ff       	call   100ca8 <__panic>
    assert(page_ref(p1) == 1);
  104bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104bc2:	89 04 24             	mov    %eax,(%esp)
  104bc5:	e8 99 f1 ff ff       	call   103d63 <page_ref>
  104bca:	83 f8 01             	cmp    $0x1,%eax
  104bcd:	74 24                	je     104bf3 <check_pgdir+0x1c5>
  104bcf:	c7 44 24 0c 6f 6f 10 	movl   $0x106f6f,0xc(%esp)
  104bd6:	00 
  104bd7:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104bde:	00 
  104bdf:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
  104be6:	00 
  104be7:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104bee:	e8 b5 c0 ff ff       	call   100ca8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
  104bf3:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104bf8:	8b 00                	mov    (%eax),%eax
  104bfa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
  104bff:	89 45 ec             	mov    %eax,-0x14(%ebp)
  104c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c05:	c1 e8 0c             	shr    $0xc,%eax
  104c08:	89 45 e8             	mov    %eax,-0x18(%ebp)
  104c0b:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  104c10:	39 45 e8             	cmp    %eax,-0x18(%ebp)
  104c13:	72 23                	jb     104c38 <check_pgdir+0x20a>
  104c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c18:	89 44 24 0c          	mov    %eax,0xc(%esp)
  104c1c:	c7 44 24 08 3c 6d 10 	movl   $0x106d3c,0x8(%esp)
  104c23:	00 
  104c24:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
  104c2b:	00 
  104c2c:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104c33:	e8 70 c0 ff ff       	call   100ca8 <__panic>
  104c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
  104c3b:	2d 00 00 00 40       	sub    $0x40000000,%eax
  104c40:	83 c0 04             	add    $0x4,%eax
  104c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
  104c46:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104c4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104c52:	00 
  104c53:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104c5a:	00 
  104c5b:	89 04 24             	mov    %eax,(%esp)
  104c5e:	e8 48 fa ff ff       	call   1046ab <get_pte>
  104c63:	3b 45 f0             	cmp    -0x10(%ebp),%eax
  104c66:	74 24                	je     104c8c <check_pgdir+0x25e>
  104c68:	c7 44 24 0c 84 6f 10 	movl   $0x106f84,0xc(%esp)
  104c6f:	00 
  104c70:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104c77:	00 
  104c78:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
  104c7f:	00 
  104c80:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104c87:	e8 1c c0 ff ff       	call   100ca8 <__panic>

    p2 = alloc_page();
  104c8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  104c93:	e8 d5 f2 ff ff       	call   103f6d <alloc_pages>
  104c98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
  104c9b:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104ca0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
  104ca7:	00 
  104ca8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104caf:	00 
  104cb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  104cb3:	89 54 24 04          	mov    %edx,0x4(%esp)
  104cb7:	89 04 24             	mov    %eax,(%esp)
  104cba:	e8 36 fc ff ff       	call   1048f5 <page_insert>
  104cbf:	85 c0                	test   %eax,%eax
  104cc1:	74 24                	je     104ce7 <check_pgdir+0x2b9>
  104cc3:	c7 44 24 0c ac 6f 10 	movl   $0x106fac,0xc(%esp)
  104cca:	00 
  104ccb:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104cd2:	00 
  104cd3:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
  104cda:	00 
  104cdb:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104ce2:	e8 c1 bf ff ff       	call   100ca8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104ce7:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104cec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104cf3:	00 
  104cf4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104cfb:	00 
  104cfc:	89 04 24             	mov    %eax,(%esp)
  104cff:	e8 a7 f9 ff ff       	call   1046ab <get_pte>
  104d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104d07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104d0b:	75 24                	jne    104d31 <check_pgdir+0x303>
  104d0d:	c7 44 24 0c e4 6f 10 	movl   $0x106fe4,0xc(%esp)
  104d14:	00 
  104d15:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104d1c:	00 
  104d1d:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
  104d24:	00 
  104d25:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104d2c:	e8 77 bf ff ff       	call   100ca8 <__panic>
    assert(*ptep & PTE_U);
  104d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d34:	8b 00                	mov    (%eax),%eax
  104d36:	83 e0 04             	and    $0x4,%eax
  104d39:	85 c0                	test   %eax,%eax
  104d3b:	75 24                	jne    104d61 <check_pgdir+0x333>
  104d3d:	c7 44 24 0c 14 70 10 	movl   $0x107014,0xc(%esp)
  104d44:	00 
  104d45:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104d4c:	00 
  104d4d:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
  104d54:	00 
  104d55:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104d5c:	e8 47 bf ff ff       	call   100ca8 <__panic>
    assert(*ptep & PTE_W);
  104d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104d64:	8b 00                	mov    (%eax),%eax
  104d66:	83 e0 02             	and    $0x2,%eax
  104d69:	85 c0                	test   %eax,%eax
  104d6b:	75 24                	jne    104d91 <check_pgdir+0x363>
  104d6d:	c7 44 24 0c 22 70 10 	movl   $0x107022,0xc(%esp)
  104d74:	00 
  104d75:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104d7c:	00 
  104d7d:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
  104d84:	00 
  104d85:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104d8c:	e8 17 bf ff ff       	call   100ca8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
  104d91:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104d96:	8b 00                	mov    (%eax),%eax
  104d98:	83 e0 04             	and    $0x4,%eax
  104d9b:	85 c0                	test   %eax,%eax
  104d9d:	75 24                	jne    104dc3 <check_pgdir+0x395>
  104d9f:	c7 44 24 0c 30 70 10 	movl   $0x107030,0xc(%esp)
  104da6:	00 
  104da7:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104dae:	00 
  104daf:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
  104db6:	00 
  104db7:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104dbe:	e8 e5 be ff ff       	call   100ca8 <__panic>
    assert(page_ref(p2) == 1);
  104dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104dc6:	89 04 24             	mov    %eax,(%esp)
  104dc9:	e8 95 ef ff ff       	call   103d63 <page_ref>
  104dce:	83 f8 01             	cmp    $0x1,%eax
  104dd1:	74 24                	je     104df7 <check_pgdir+0x3c9>
  104dd3:	c7 44 24 0c 46 70 10 	movl   $0x107046,0xc(%esp)
  104dda:	00 
  104ddb:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104de2:	00 
  104de3:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
  104dea:	00 
  104deb:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104df2:	e8 b1 be ff ff       	call   100ca8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
  104df7:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104dfc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
  104e03:	00 
  104e04:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
  104e0b:	00 
  104e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  104e0f:	89 54 24 04          	mov    %edx,0x4(%esp)
  104e13:	89 04 24             	mov    %eax,(%esp)
  104e16:	e8 da fa ff ff       	call   1048f5 <page_insert>
  104e1b:	85 c0                	test   %eax,%eax
  104e1d:	74 24                	je     104e43 <check_pgdir+0x415>
  104e1f:	c7 44 24 0c 58 70 10 	movl   $0x107058,0xc(%esp)
  104e26:	00 
  104e27:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104e2e:	00 
  104e2f:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
  104e36:	00 
  104e37:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104e3e:	e8 65 be ff ff       	call   100ca8 <__panic>
    assert(page_ref(p1) == 2);
  104e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104e46:	89 04 24             	mov    %eax,(%esp)
  104e49:	e8 15 ef ff ff       	call   103d63 <page_ref>
  104e4e:	83 f8 02             	cmp    $0x2,%eax
  104e51:	74 24                	je     104e77 <check_pgdir+0x449>
  104e53:	c7 44 24 0c 84 70 10 	movl   $0x107084,0xc(%esp)
  104e5a:	00 
  104e5b:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104e62:	00 
  104e63:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
  104e6a:	00 
  104e6b:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104e72:	e8 31 be ff ff       	call   100ca8 <__panic>
    assert(page_ref(p2) == 0);
  104e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104e7a:	89 04 24             	mov    %eax,(%esp)
  104e7d:	e8 e1 ee ff ff       	call   103d63 <page_ref>
  104e82:	85 c0                	test   %eax,%eax
  104e84:	74 24                	je     104eaa <check_pgdir+0x47c>
  104e86:	c7 44 24 0c 96 70 10 	movl   $0x107096,0xc(%esp)
  104e8d:	00 
  104e8e:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104e95:	00 
  104e96:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
  104e9d:	00 
  104e9e:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104ea5:	e8 fe bd ff ff       	call   100ca8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
  104eaa:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104eaf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  104eb6:	00 
  104eb7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104ebe:	00 
  104ebf:	89 04 24             	mov    %eax,(%esp)
  104ec2:	e8 e4 f7 ff ff       	call   1046ab <get_pte>
  104ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  104eca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  104ece:	75 24                	jne    104ef4 <check_pgdir+0x4c6>
  104ed0:	c7 44 24 0c e4 6f 10 	movl   $0x106fe4,0xc(%esp)
  104ed7:	00 
  104ed8:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104edf:	00 
  104ee0:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
  104ee7:	00 
  104ee8:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104eef:	e8 b4 bd ff ff       	call   100ca8 <__panic>
    assert(pte2page(*ptep) == p1);
  104ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104ef7:	8b 00                	mov    (%eax),%eax
  104ef9:	89 04 24             	mov    %eax,(%esp)
  104efc:	e8 0c ee ff ff       	call   103d0d <pte2page>
  104f01:	3b 45 f4             	cmp    -0xc(%ebp),%eax
  104f04:	74 24                	je     104f2a <check_pgdir+0x4fc>
  104f06:	c7 44 24 0c 59 6f 10 	movl   $0x106f59,0xc(%esp)
  104f0d:	00 
  104f0e:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104f15:	00 
  104f16:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
  104f1d:	00 
  104f1e:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104f25:	e8 7e bd ff ff       	call   100ca8 <__panic>
    assert((*ptep & PTE_U) == 0);
  104f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  104f2d:	8b 00                	mov    (%eax),%eax
  104f2f:	83 e0 04             	and    $0x4,%eax
  104f32:	85 c0                	test   %eax,%eax
  104f34:	74 24                	je     104f5a <check_pgdir+0x52c>
  104f36:	c7 44 24 0c a8 70 10 	movl   $0x1070a8,0xc(%esp)
  104f3d:	00 
  104f3e:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104f45:	00 
  104f46:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
  104f4d:	00 
  104f4e:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104f55:	e8 4e bd ff ff       	call   100ca8 <__panic>

    page_remove(boot_pgdir, 0x0);
  104f5a:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104f5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  104f66:	00 
  104f67:	89 04 24             	mov    %eax,(%esp)
  104f6a:	e8 42 f9 ff ff       	call   1048b1 <page_remove>
    assert(page_ref(p1) == 1);
  104f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104f72:	89 04 24             	mov    %eax,(%esp)
  104f75:	e8 e9 ed ff ff       	call   103d63 <page_ref>
  104f7a:	83 f8 01             	cmp    $0x1,%eax
  104f7d:	74 24                	je     104fa3 <check_pgdir+0x575>
  104f7f:	c7 44 24 0c 6f 6f 10 	movl   $0x106f6f,0xc(%esp)
  104f86:	00 
  104f87:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104f8e:	00 
  104f8f:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
  104f96:	00 
  104f97:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104f9e:	e8 05 bd ff ff       	call   100ca8 <__panic>
    assert(page_ref(p2) == 0);
  104fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  104fa6:	89 04 24             	mov    %eax,(%esp)
  104fa9:	e8 b5 ed ff ff       	call   103d63 <page_ref>
  104fae:	85 c0                	test   %eax,%eax
  104fb0:	74 24                	je     104fd6 <check_pgdir+0x5a8>
  104fb2:	c7 44 24 0c 96 70 10 	movl   $0x107096,0xc(%esp)
  104fb9:	00 
  104fba:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  104fc1:	00 
  104fc2:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
  104fc9:	00 
  104fca:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  104fd1:	e8 d2 bc ff ff       	call   100ca8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
  104fd6:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  104fdb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
  104fe2:	00 
  104fe3:	89 04 24             	mov    %eax,(%esp)
  104fe6:	e8 c6 f8 ff ff       	call   1048b1 <page_remove>
    assert(page_ref(p1) == 0);
  104feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
  104fee:	89 04 24             	mov    %eax,(%esp)
  104ff1:	e8 6d ed ff ff       	call   103d63 <page_ref>
  104ff6:	85 c0                	test   %eax,%eax
  104ff8:	74 24                	je     10501e <check_pgdir+0x5f0>
  104ffa:	c7 44 24 0c bd 70 10 	movl   $0x1070bd,0xc(%esp)
  105001:	00 
  105002:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  105009:	00 
  10500a:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
  105011:	00 
  105012:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  105019:	e8 8a bc ff ff       	call   100ca8 <__panic>
    assert(page_ref(p2) == 0);
  10501e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105021:	89 04 24             	mov    %eax,(%esp)
  105024:	e8 3a ed ff ff       	call   103d63 <page_ref>
  105029:	85 c0                	test   %eax,%eax
  10502b:	74 24                	je     105051 <check_pgdir+0x623>
  10502d:	c7 44 24 0c 96 70 10 	movl   $0x107096,0xc(%esp)
  105034:	00 
  105035:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  10503c:	00 
  10503d:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
  105044:	00 
  105045:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  10504c:	e8 57 bc ff ff       	call   100ca8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
  105051:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  105056:	8b 00                	mov    (%eax),%eax
  105058:	89 04 24             	mov    %eax,(%esp)
  10505b:	e8 eb ec ff ff       	call   103d4b <pde2page>
  105060:	89 04 24             	mov    %eax,(%esp)
  105063:	e8 fb ec ff ff       	call   103d63 <page_ref>
  105068:	83 f8 01             	cmp    $0x1,%eax
  10506b:	74 24                	je     105091 <check_pgdir+0x663>
  10506d:	c7 44 24 0c d0 70 10 	movl   $0x1070d0,0xc(%esp)
  105074:	00 
  105075:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  10507c:	00 
  10507d:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
  105084:	00 
  105085:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  10508c:	e8 17 bc ff ff       	call   100ca8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
  105091:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  105096:	8b 00                	mov    (%eax),%eax
  105098:	89 04 24             	mov    %eax,(%esp)
  10509b:	e8 ab ec ff ff       	call   103d4b <pde2page>
  1050a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  1050a7:	00 
  1050a8:	89 04 24             	mov    %eax,(%esp)
  1050ab:	e8 f5 ee ff ff       	call   103fa5 <free_pages>
    boot_pgdir[0] = 0;
  1050b0:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1050b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
  1050bb:	c7 04 24 f7 70 10 00 	movl   $0x1070f7,(%esp)
  1050c2:	e8 80 b2 ff ff       	call   100347 <cprintf>
}
  1050c7:	c9                   	leave  
  1050c8:	c3                   	ret    

001050c9 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
  1050c9:	55                   	push   %ebp
  1050ca:	89 e5                	mov    %esp,%ebp
  1050cc:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  1050cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
  1050d6:	e9 cb 00 00 00       	jmp    1051a6 <check_boot_pgdir+0xdd>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
  1050db:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1050de:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1050e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050e4:	c1 e8 0c             	shr    $0xc,%eax
  1050e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1050ea:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  1050ef:	39 45 ec             	cmp    %eax,-0x14(%ebp)
  1050f2:	72 23                	jb     105117 <check_boot_pgdir+0x4e>
  1050f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
  1050f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1050fb:	c7 44 24 08 3c 6d 10 	movl   $0x106d3c,0x8(%esp)
  105102:	00 
  105103:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  10510a:	00 
  10510b:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  105112:	e8 91 bb ff ff       	call   100ca8 <__panic>
  105117:	8b 45 f0             	mov    -0x10(%ebp),%eax
  10511a:	2d 00 00 00 40       	sub    $0x40000000,%eax
  10511f:	89 c2                	mov    %eax,%edx
  105121:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  105126:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  10512d:	00 
  10512e:	89 54 24 04          	mov    %edx,0x4(%esp)
  105132:	89 04 24             	mov    %eax,(%esp)
  105135:	e8 71 f5 ff ff       	call   1046ab <get_pte>
  10513a:	89 45 e8             	mov    %eax,-0x18(%ebp)
  10513d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105141:	75 24                	jne    105167 <check_boot_pgdir+0x9e>
  105143:	c7 44 24 0c 14 71 10 	movl   $0x107114,0xc(%esp)
  10514a:	00 
  10514b:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  105152:	00 
  105153:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
  10515a:	00 
  10515b:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  105162:	e8 41 bb ff ff       	call   100ca8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
  105167:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10516a:	8b 00                	mov    (%eax),%eax
  10516c:	89 c2                	mov    %eax,%edx
  10516e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  105174:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105177:	39 c2                	cmp    %eax,%edx
  105179:	74 24                	je     10519f <check_boot_pgdir+0xd6>
  10517b:	c7 44 24 0c 51 71 10 	movl   $0x107151,0xc(%esp)
  105182:	00 
  105183:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  10518a:	00 
  10518b:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
  105192:	00 
  105193:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  10519a:	e8 09 bb ff ff       	call   100ca8 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
  10519f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
  1051a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
  1051a9:	a1 c0 98 11 00       	mov    0x1198c0,%eax
  1051ae:	39 c2                	cmp    %eax,%edx
  1051b0:	0f 82 25 ff ff ff    	jb     1050db <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
  1051b6:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1051bb:	05 ac 0f 00 00       	add    $0xfac,%eax
  1051c0:	8b 00                	mov    (%eax),%eax
  1051c2:	89 c2                	mov    %eax,%edx
  1051c4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
  1051ca:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1051cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1051d2:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
  1051d9:	77 23                	ja     1051fe <check_boot_pgdir+0x135>
  1051db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1051de:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1051e2:	c7 44 24 08 e0 6d 10 	movl   $0x106de0,0x8(%esp)
  1051e9:	00 
  1051ea:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  1051f1:	00 
  1051f2:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  1051f9:	e8 aa ba ff ff       	call   100ca8 <__panic>
  1051fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105201:	05 00 00 00 40       	add    $0x40000000,%eax
  105206:	39 c2                	cmp    %eax,%edx
  105208:	74 24                	je     10522e <check_boot_pgdir+0x165>
  10520a:	c7 44 24 0c 68 71 10 	movl   $0x107168,0xc(%esp)
  105211:	00 
  105212:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  105219:	00 
  10521a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
  105221:	00 
  105222:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  105229:	e8 7a ba ff ff       	call   100ca8 <__panic>

    assert(boot_pgdir[0] == 0);
  10522e:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  105233:	8b 00                	mov    (%eax),%eax
  105235:	85 c0                	test   %eax,%eax
  105237:	74 24                	je     10525d <check_boot_pgdir+0x194>
  105239:	c7 44 24 0c 9c 71 10 	movl   $0x10719c,0xc(%esp)
  105240:	00 
  105241:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  105248:	00 
  105249:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
  105250:	00 
  105251:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  105258:	e8 4b ba ff ff       	call   100ca8 <__panic>

    struct Page *p;
    p = alloc_page();
  10525d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  105264:	e8 04 ed ff ff       	call   103f6d <alloc_pages>
  105269:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
  10526c:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  105271:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  105278:	00 
  105279:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
  105280:	00 
  105281:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105284:	89 54 24 04          	mov    %edx,0x4(%esp)
  105288:	89 04 24             	mov    %eax,(%esp)
  10528b:	e8 65 f6 ff ff       	call   1048f5 <page_insert>
  105290:	85 c0                	test   %eax,%eax
  105292:	74 24                	je     1052b8 <check_boot_pgdir+0x1ef>
  105294:	c7 44 24 0c b0 71 10 	movl   $0x1071b0,0xc(%esp)
  10529b:	00 
  10529c:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  1052a3:	00 
  1052a4:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
  1052ab:	00 
  1052ac:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  1052b3:	e8 f0 b9 ff ff       	call   100ca8 <__panic>
    assert(page_ref(p) == 1);
  1052b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1052bb:	89 04 24             	mov    %eax,(%esp)
  1052be:	e8 a0 ea ff ff       	call   103d63 <page_ref>
  1052c3:	83 f8 01             	cmp    $0x1,%eax
  1052c6:	74 24                	je     1052ec <check_boot_pgdir+0x223>
  1052c8:	c7 44 24 0c de 71 10 	movl   $0x1071de,0xc(%esp)
  1052cf:	00 
  1052d0:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  1052d7:	00 
  1052d8:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
  1052df:	00 
  1052e0:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  1052e7:	e8 bc b9 ff ff       	call   100ca8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
  1052ec:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  1052f1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
  1052f8:	00 
  1052f9:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
  105300:	00 
  105301:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105304:	89 54 24 04          	mov    %edx,0x4(%esp)
  105308:	89 04 24             	mov    %eax,(%esp)
  10530b:	e8 e5 f5 ff ff       	call   1048f5 <page_insert>
  105310:	85 c0                	test   %eax,%eax
  105312:	74 24                	je     105338 <check_boot_pgdir+0x26f>
  105314:	c7 44 24 0c f0 71 10 	movl   $0x1071f0,0xc(%esp)
  10531b:	00 
  10531c:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  105323:	00 
  105324:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
  10532b:	00 
  10532c:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  105333:	e8 70 b9 ff ff       	call   100ca8 <__panic>
    assert(page_ref(p) == 2);
  105338:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10533b:	89 04 24             	mov    %eax,(%esp)
  10533e:	e8 20 ea ff ff       	call   103d63 <page_ref>
  105343:	83 f8 02             	cmp    $0x2,%eax
  105346:	74 24                	je     10536c <check_boot_pgdir+0x2a3>
  105348:	c7 44 24 0c 27 72 10 	movl   $0x107227,0xc(%esp)
  10534f:	00 
  105350:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  105357:	00 
  105358:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
  10535f:	00 
  105360:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  105367:	e8 3c b9 ff ff       	call   100ca8 <__panic>

    const char *str = "ucore: Hello world!!";
  10536c:	c7 45 dc 38 72 10 00 	movl   $0x107238,-0x24(%ebp)
    strcpy((void *)0x100, str);
  105373:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105376:	89 44 24 04          	mov    %eax,0x4(%esp)
  10537a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105381:	e8 64 0a 00 00       	call   105dea <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
  105386:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
  10538d:	00 
  10538e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  105395:	e8 cd 0a 00 00       	call   105e67 <strcmp>
  10539a:	85 c0                	test   %eax,%eax
  10539c:	74 24                	je     1053c2 <check_boot_pgdir+0x2f9>
  10539e:	c7 44 24 0c 50 72 10 	movl   $0x107250,0xc(%esp)
  1053a5:	00 
  1053a6:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  1053ad:	00 
  1053ae:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
  1053b5:	00 
  1053b6:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  1053bd:	e8 e6 b8 ff ff       	call   100ca8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
  1053c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1053c5:	89 04 24             	mov    %eax,(%esp)
  1053c8:	e8 ec e8 ff ff       	call   103cb9 <page2kva>
  1053cd:	05 00 01 00 00       	add    $0x100,%eax
  1053d2:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
  1053d5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
  1053dc:	e8 ab 09 00 00       	call   105d8c <strlen>
  1053e1:	85 c0                	test   %eax,%eax
  1053e3:	74 24                	je     105409 <check_boot_pgdir+0x340>
  1053e5:	c7 44 24 0c 88 72 10 	movl   $0x107288,0xc(%esp)
  1053ec:	00 
  1053ed:	c7 44 24 08 29 6e 10 	movl   $0x106e29,0x8(%esp)
  1053f4:	00 
  1053f5:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
  1053fc:	00 
  1053fd:	c7 04 24 04 6e 10 00 	movl   $0x106e04,(%esp)
  105404:	e8 9f b8 ff ff       	call   100ca8 <__panic>

    free_page(p);
  105409:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105410:	00 
  105411:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105414:	89 04 24             	mov    %eax,(%esp)
  105417:	e8 89 eb ff ff       	call   103fa5 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
  10541c:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  105421:	8b 00                	mov    (%eax),%eax
  105423:	89 04 24             	mov    %eax,(%esp)
  105426:	e8 20 e9 ff ff       	call   103d4b <pde2page>
  10542b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
  105432:	00 
  105433:	89 04 24             	mov    %eax,(%esp)
  105436:	e8 6a eb ff ff       	call   103fa5 <free_pages>
    boot_pgdir[0] = 0;
  10543b:	a1 c4 98 11 00       	mov    0x1198c4,%eax
  105440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
  105446:	c7 04 24 ac 72 10 00 	movl   $0x1072ac,(%esp)
  10544d:	e8 f5 ae ff ff       	call   100347 <cprintf>
}
  105452:	c9                   	leave  
  105453:	c3                   	ret    

00105454 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
  105454:	55                   	push   %ebp
  105455:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
  105457:	8b 45 08             	mov    0x8(%ebp),%eax
  10545a:	83 e0 04             	and    $0x4,%eax
  10545d:	85 c0                	test   %eax,%eax
  10545f:	74 07                	je     105468 <perm2str+0x14>
  105461:	b8 75 00 00 00       	mov    $0x75,%eax
  105466:	eb 05                	jmp    10546d <perm2str+0x19>
  105468:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10546d:	a2 48 99 11 00       	mov    %al,0x119948
    str[1] = 'r';
  105472:	c6 05 49 99 11 00 72 	movb   $0x72,0x119949
    str[2] = (perm & PTE_W) ? 'w' : '-';
  105479:	8b 45 08             	mov    0x8(%ebp),%eax
  10547c:	83 e0 02             	and    $0x2,%eax
  10547f:	85 c0                	test   %eax,%eax
  105481:	74 07                	je     10548a <perm2str+0x36>
  105483:	b8 77 00 00 00       	mov    $0x77,%eax
  105488:	eb 05                	jmp    10548f <perm2str+0x3b>
  10548a:	b8 2d 00 00 00       	mov    $0x2d,%eax
  10548f:	a2 4a 99 11 00       	mov    %al,0x11994a
    str[3] = '\0';
  105494:	c6 05 4b 99 11 00 00 	movb   $0x0,0x11994b
    return str;
  10549b:	b8 48 99 11 00       	mov    $0x119948,%eax
}
  1054a0:	5d                   	pop    %ebp
  1054a1:	c3                   	ret    

001054a2 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
  1054a2:	55                   	push   %ebp
  1054a3:	89 e5                	mov    %esp,%ebp
  1054a5:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
  1054a8:	8b 45 10             	mov    0x10(%ebp),%eax
  1054ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054ae:	72 0e                	jb     1054be <get_pgtable_items+0x1c>
        return 0;
  1054b0:	b8 00 00 00 00       	mov    $0x0,%eax
  1054b5:	e9 86 00 00 00       	jmp    105540 <get_pgtable_items+0x9e>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
  1054ba:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
  1054be:	8b 45 10             	mov    0x10(%ebp),%eax
  1054c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054c4:	73 12                	jae    1054d8 <get_pgtable_items+0x36>
  1054c6:	8b 45 10             	mov    0x10(%ebp),%eax
  1054c9:	c1 e0 02             	shl    $0x2,%eax
  1054cc:	03 45 14             	add    0x14(%ebp),%eax
  1054cf:	8b 00                	mov    (%eax),%eax
  1054d1:	83 e0 01             	and    $0x1,%eax
  1054d4:	85 c0                	test   %eax,%eax
  1054d6:	74 e2                	je     1054ba <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
  1054d8:	8b 45 10             	mov    0x10(%ebp),%eax
  1054db:	3b 45 0c             	cmp    0xc(%ebp),%eax
  1054de:	73 5b                	jae    10553b <get_pgtable_items+0x99>
        if (left_store != NULL) {
  1054e0:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
  1054e4:	74 08                	je     1054ee <get_pgtable_items+0x4c>
            *left_store = start;
  1054e6:	8b 45 18             	mov    0x18(%ebp),%eax
  1054e9:	8b 55 10             	mov    0x10(%ebp),%edx
  1054ec:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
  1054ee:	8b 45 10             	mov    0x10(%ebp),%eax
  1054f1:	c1 e0 02             	shl    $0x2,%eax
  1054f4:	03 45 14             	add    0x14(%ebp),%eax
  1054f7:	8b 00                	mov    (%eax),%eax
  1054f9:	83 e0 07             	and    $0x7,%eax
  1054fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
  1054ff:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
  105503:	eb 04                	jmp    105509 <get_pgtable_items+0x67>
            start ++;
  105505:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
  105509:	8b 45 10             	mov    0x10(%ebp),%eax
  10550c:	3b 45 0c             	cmp    0xc(%ebp),%eax
  10550f:	73 17                	jae    105528 <get_pgtable_items+0x86>
  105511:	8b 45 10             	mov    0x10(%ebp),%eax
  105514:	c1 e0 02             	shl    $0x2,%eax
  105517:	03 45 14             	add    0x14(%ebp),%eax
  10551a:	8b 00                	mov    (%eax),%eax
  10551c:	89 c2                	mov    %eax,%edx
  10551e:	83 e2 07             	and    $0x7,%edx
  105521:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105524:	39 c2                	cmp    %eax,%edx
  105526:	74 dd                	je     105505 <get_pgtable_items+0x63>
            start ++;
        }
        if (right_store != NULL) {
  105528:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  10552c:	74 08                	je     105536 <get_pgtable_items+0x94>
            *right_store = start;
  10552e:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105531:	8b 55 10             	mov    0x10(%ebp),%edx
  105534:	89 10                	mov    %edx,(%eax)
        }
        return perm;
  105536:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105539:	eb 05                	jmp    105540 <get_pgtable_items+0x9e>
    }
    return 0;
  10553b:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105540:	c9                   	leave  
  105541:	c3                   	ret    

00105542 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  105542:	55                   	push   %ebp
  105543:	89 e5                	mov    %esp,%ebp
  105545:	57                   	push   %edi
  105546:	56                   	push   %esi
  105547:	53                   	push   %ebx
  105548:	83 ec 5c             	sub    $0x5c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
  10554b:	c7 04 24 cc 72 10 00 	movl   $0x1072cc,(%esp)
  105552:	e8 f0 ad ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
  105557:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10555e:	e9 0b 01 00 00       	jmp    10566e <print_pgdir+0x12c>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  105563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105566:	89 04 24             	mov    %eax,(%esp)
  105569:	e8 e6 fe ff ff       	call   105454 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
  10556e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105571:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105574:	89 cb                	mov    %ecx,%ebx
  105576:	29 d3                	sub    %edx,%ebx
  105578:	89 da                	mov    %ebx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
  10557a:	89 d6                	mov    %edx,%esi
  10557c:	c1 e6 16             	shl    $0x16,%esi
  10557f:	8b 55 dc             	mov    -0x24(%ebp),%edx
  105582:	89 d3                	mov    %edx,%ebx
  105584:	c1 e3 16             	shl    $0x16,%ebx
  105587:	8b 55 e0             	mov    -0x20(%ebp),%edx
  10558a:	89 d1                	mov    %edx,%ecx
  10558c:	c1 e1 16             	shl    $0x16,%ecx
  10558f:	8b 7d dc             	mov    -0x24(%ebp),%edi
  105592:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  105595:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105598:	8b 7d c4             	mov    -0x3c(%ebp),%edi
  10559b:	29 d7                	sub    %edx,%edi
  10559d:	89 fa                	mov    %edi,%edx
  10559f:	89 44 24 14          	mov    %eax,0x14(%esp)
  1055a3:	89 74 24 10          	mov    %esi,0x10(%esp)
  1055a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  1055ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  1055af:	89 54 24 04          	mov    %edx,0x4(%esp)
  1055b3:	c7 04 24 fd 72 10 00 	movl   $0x1072fd,(%esp)
  1055ba:	e8 88 ad ff ff       	call   100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
  1055bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
  1055c2:	c1 e0 0a             	shl    $0xa,%eax
  1055c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  1055c8:	eb 5c                	jmp    105626 <print_pgdir+0xe4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1055ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1055cd:	89 04 24             	mov    %eax,(%esp)
  1055d0:	e8 7f fe ff ff       	call   105454 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
  1055d5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
  1055d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1055db:	89 cb                	mov    %ecx,%ebx
  1055dd:	29 d3                	sub    %edx,%ebx
  1055df:	89 da                	mov    %ebx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
  1055e1:	89 d6                	mov    %edx,%esi
  1055e3:	c1 e6 0c             	shl    $0xc,%esi
  1055e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1055e9:	89 d3                	mov    %edx,%ebx
  1055eb:	c1 e3 0c             	shl    $0xc,%ebx
  1055ee:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1055f1:	89 d1                	mov    %edx,%ecx
  1055f3:	c1 e1 0c             	shl    $0xc,%ecx
  1055f6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
  1055f9:	89 7d c4             	mov    %edi,-0x3c(%ebp)
  1055fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
  1055ff:	8b 7d c4             	mov    -0x3c(%ebp),%edi
  105602:	29 d7                	sub    %edx,%edi
  105604:	89 fa                	mov    %edi,%edx
  105606:	89 44 24 14          	mov    %eax,0x14(%esp)
  10560a:	89 74 24 10          	mov    %esi,0x10(%esp)
  10560e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105612:	89 4c 24 08          	mov    %ecx,0x8(%esp)
  105616:	89 54 24 04          	mov    %edx,0x4(%esp)
  10561a:	c7 04 24 1c 73 10 00 	movl   $0x10731c,(%esp)
  105621:	e8 21 ad ff ff       	call   100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
  105626:	8b 15 84 6d 10 00    	mov    0x106d84,%edx
  10562c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
  10562f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  105632:	89 ce                	mov    %ecx,%esi
  105634:	c1 e6 0a             	shl    $0xa,%esi
  105637:	8b 4d e0             	mov    -0x20(%ebp),%ecx
  10563a:	89 cb                	mov    %ecx,%ebx
  10563c:	c1 e3 0a             	shl    $0xa,%ebx
  10563f:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
  105642:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  105646:	8d 4d d8             	lea    -0x28(%ebp),%ecx
  105649:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  10564d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105651:	89 44 24 08          	mov    %eax,0x8(%esp)
  105655:	89 74 24 04          	mov    %esi,0x4(%esp)
  105659:	89 1c 24             	mov    %ebx,(%esp)
  10565c:	e8 41 fe ff ff       	call   1054a2 <get_pgtable_items>
  105661:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  105664:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105668:	0f 85 5c ff ff ff    	jne    1055ca <print_pgdir+0x88>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
  10566e:	8b 15 88 6d 10 00    	mov    0x106d88,%edx
  105674:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105677:	8d 4d dc             	lea    -0x24(%ebp),%ecx
  10567a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
  10567e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
  105681:	89 4c 24 10          	mov    %ecx,0x10(%esp)
  105685:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105689:	89 44 24 08          	mov    %eax,0x8(%esp)
  10568d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
  105694:	00 
  105695:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  10569c:	e8 01 fe ff ff       	call   1054a2 <get_pgtable_items>
  1056a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1056a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  1056a8:	0f 85 b5 fe ff ff    	jne    105563 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
  1056ae:	c7 04 24 40 73 10 00 	movl   $0x107340,(%esp)
  1056b5:	e8 8d ac ff ff       	call   100347 <cprintf>
}
  1056ba:	83 c4 5c             	add    $0x5c,%esp
  1056bd:	5b                   	pop    %ebx
  1056be:	5e                   	pop    %esi
  1056bf:	5f                   	pop    %edi
  1056c0:	5d                   	pop    %ebp
  1056c1:	c3                   	ret    
	...

001056c4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  1056c4:	55                   	push   %ebp
  1056c5:	89 e5                	mov    %esp,%ebp
  1056c7:	56                   	push   %esi
  1056c8:	53                   	push   %ebx
  1056c9:	83 ec 60             	sub    $0x60,%esp
  1056cc:	8b 45 10             	mov    0x10(%ebp),%eax
  1056cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
  1056d2:	8b 45 14             	mov    0x14(%ebp),%eax
  1056d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  1056d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
  1056db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  1056de:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1056e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  1056e4:	8b 45 18             	mov    0x18(%ebp),%eax
  1056e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  1056ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1056ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1056f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  1056f3:	89 55 cc             	mov    %edx,-0x34(%ebp)
  1056f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
  1056f9:	8b 55 cc             	mov    -0x34(%ebp),%edx
  1056fc:	89 d3                	mov    %edx,%ebx
  1056fe:	89 c6                	mov    %eax,%esi
  105700:	89 75 e0             	mov    %esi,-0x20(%ebp)
  105703:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  105706:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105709:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10570c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  105710:	74 1c                	je     10572e <printnum+0x6a>
  105712:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105715:	ba 00 00 00 00       	mov    $0x0,%edx
  10571a:	f7 75 e4             	divl   -0x1c(%ebp)
  10571d:	89 55 f4             	mov    %edx,-0xc(%ebp)
  105720:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105723:	ba 00 00 00 00       	mov    $0x0,%edx
  105728:	f7 75 e4             	divl   -0x1c(%ebp)
  10572b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  10572e:	8b 55 e0             	mov    -0x20(%ebp),%edx
  105731:	8b 45 f4             	mov    -0xc(%ebp),%eax
  105734:	89 d6                	mov    %edx,%esi
  105736:	89 c3                	mov    %eax,%ebx
  105738:	89 f0                	mov    %esi,%eax
  10573a:	89 da                	mov    %ebx,%edx
  10573c:	f7 75 e4             	divl   -0x1c(%ebp)
  10573f:	89 d3                	mov    %edx,%ebx
  105741:	89 c6                	mov    %eax,%esi
  105743:	89 75 e0             	mov    %esi,-0x20(%ebp)
  105746:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  105749:	8b 45 e0             	mov    -0x20(%ebp),%eax
  10574c:	89 45 c8             	mov    %eax,-0x38(%ebp)
  10574f:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105752:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  105755:	8b 45 c8             	mov    -0x38(%ebp),%eax
  105758:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  10575b:	89 c3                	mov    %eax,%ebx
  10575d:	89 d6                	mov    %edx,%esi
  10575f:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  105762:	89 75 ec             	mov    %esi,-0x14(%ebp)
  105765:	8b 45 dc             	mov    -0x24(%ebp),%eax
  105768:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  10576b:	8b 45 18             	mov    0x18(%ebp),%eax
  10576e:	ba 00 00 00 00       	mov    $0x0,%edx
  105773:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  105776:	77 56                	ja     1057ce <printnum+0x10a>
  105778:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  10577b:	72 05                	jb     105782 <printnum+0xbe>
  10577d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  105780:	77 4c                	ja     1057ce <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
  105782:	8b 45 1c             	mov    0x1c(%ebp),%eax
  105785:	8d 50 ff             	lea    -0x1(%eax),%edx
  105788:	8b 45 20             	mov    0x20(%ebp),%eax
  10578b:	89 44 24 18          	mov    %eax,0x18(%esp)
  10578f:	89 54 24 14          	mov    %edx,0x14(%esp)
  105793:	8b 45 18             	mov    0x18(%ebp),%eax
  105796:	89 44 24 10          	mov    %eax,0x10(%esp)
  10579a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  10579d:	8b 55 ec             	mov    -0x14(%ebp),%edx
  1057a0:	89 44 24 08          	mov    %eax,0x8(%esp)
  1057a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  1057a8:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057ab:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057af:	8b 45 08             	mov    0x8(%ebp),%eax
  1057b2:	89 04 24             	mov    %eax,(%esp)
  1057b5:	e8 0a ff ff ff       	call   1056c4 <printnum>
  1057ba:	eb 1c                	jmp    1057d8 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
  1057bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1057bf:	89 44 24 04          	mov    %eax,0x4(%esp)
  1057c3:	8b 45 20             	mov    0x20(%ebp),%eax
  1057c6:	89 04 24             	mov    %eax,(%esp)
  1057c9:	8b 45 08             	mov    0x8(%ebp),%eax
  1057cc:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  1057ce:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
  1057d2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
  1057d6:	7f e4                	jg     1057bc <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
  1057d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
  1057db:	05 f4 73 10 00       	add    $0x1073f4,%eax
  1057e0:	0f b6 00             	movzbl (%eax),%eax
  1057e3:	0f be c0             	movsbl %al,%eax
  1057e6:	8b 55 0c             	mov    0xc(%ebp),%edx
  1057e9:	89 54 24 04          	mov    %edx,0x4(%esp)
  1057ed:	89 04 24             	mov    %eax,(%esp)
  1057f0:	8b 45 08             	mov    0x8(%ebp),%eax
  1057f3:	ff d0                	call   *%eax
}
  1057f5:	83 c4 60             	add    $0x60,%esp
  1057f8:	5b                   	pop    %ebx
  1057f9:	5e                   	pop    %esi
  1057fa:	5d                   	pop    %ebp
  1057fb:	c3                   	ret    

001057fc <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  1057fc:	55                   	push   %ebp
  1057fd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  1057ff:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105803:	7e 14                	jle    105819 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  105805:	8b 45 08             	mov    0x8(%ebp),%eax
  105808:	8b 00                	mov    (%eax),%eax
  10580a:	8d 48 08             	lea    0x8(%eax),%ecx
  10580d:	8b 55 08             	mov    0x8(%ebp),%edx
  105810:	89 0a                	mov    %ecx,(%edx)
  105812:	8b 50 04             	mov    0x4(%eax),%edx
  105815:	8b 00                	mov    (%eax),%eax
  105817:	eb 30                	jmp    105849 <getuint+0x4d>
    }
    else if (lflag) {
  105819:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10581d:	74 16                	je     105835 <getuint+0x39>
        return va_arg(*ap, unsigned long);
  10581f:	8b 45 08             	mov    0x8(%ebp),%eax
  105822:	8b 00                	mov    (%eax),%eax
  105824:	8d 48 04             	lea    0x4(%eax),%ecx
  105827:	8b 55 08             	mov    0x8(%ebp),%edx
  10582a:	89 0a                	mov    %ecx,(%edx)
  10582c:	8b 00                	mov    (%eax),%eax
  10582e:	ba 00 00 00 00       	mov    $0x0,%edx
  105833:	eb 14                	jmp    105849 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  105835:	8b 45 08             	mov    0x8(%ebp),%eax
  105838:	8b 00                	mov    (%eax),%eax
  10583a:	8d 48 04             	lea    0x4(%eax),%ecx
  10583d:	8b 55 08             	mov    0x8(%ebp),%edx
  105840:	89 0a                	mov    %ecx,(%edx)
  105842:	8b 00                	mov    (%eax),%eax
  105844:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  105849:	5d                   	pop    %ebp
  10584a:	c3                   	ret    

0010584b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  10584b:	55                   	push   %ebp
  10584c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  10584e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  105852:	7e 14                	jle    105868 <getint+0x1d>
        return va_arg(*ap, long long);
  105854:	8b 45 08             	mov    0x8(%ebp),%eax
  105857:	8b 00                	mov    (%eax),%eax
  105859:	8d 48 08             	lea    0x8(%eax),%ecx
  10585c:	8b 55 08             	mov    0x8(%ebp),%edx
  10585f:	89 0a                	mov    %ecx,(%edx)
  105861:	8b 50 04             	mov    0x4(%eax),%edx
  105864:	8b 00                	mov    (%eax),%eax
  105866:	eb 30                	jmp    105898 <getint+0x4d>
    }
    else if (lflag) {
  105868:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  10586c:	74 16                	je     105884 <getint+0x39>
        return va_arg(*ap, long);
  10586e:	8b 45 08             	mov    0x8(%ebp),%eax
  105871:	8b 00                	mov    (%eax),%eax
  105873:	8d 48 04             	lea    0x4(%eax),%ecx
  105876:	8b 55 08             	mov    0x8(%ebp),%edx
  105879:	89 0a                	mov    %ecx,(%edx)
  10587b:	8b 00                	mov    (%eax),%eax
  10587d:	89 c2                	mov    %eax,%edx
  10587f:	c1 fa 1f             	sar    $0x1f,%edx
  105882:	eb 14                	jmp    105898 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  105884:	8b 45 08             	mov    0x8(%ebp),%eax
  105887:	8b 00                	mov    (%eax),%eax
  105889:	8d 48 04             	lea    0x4(%eax),%ecx
  10588c:	8b 55 08             	mov    0x8(%ebp),%edx
  10588f:	89 0a                	mov    %ecx,(%edx)
  105891:	8b 00                	mov    (%eax),%eax
  105893:	89 c2                	mov    %eax,%edx
  105895:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  105898:	5d                   	pop    %ebp
  105899:	c3                   	ret    

0010589a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
  10589a:	55                   	push   %ebp
  10589b:	89 e5                	mov    %esp,%ebp
  10589d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  1058a0:	8d 55 14             	lea    0x14(%ebp),%edx
  1058a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
  1058a6:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
  1058a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
  1058ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
  1058af:	8b 45 10             	mov    0x10(%ebp),%eax
  1058b2:	89 44 24 08          	mov    %eax,0x8(%esp)
  1058b6:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058b9:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058bd:	8b 45 08             	mov    0x8(%ebp),%eax
  1058c0:	89 04 24             	mov    %eax,(%esp)
  1058c3:	e8 02 00 00 00       	call   1058ca <vprintfmt>
    va_end(ap);
}
  1058c8:	c9                   	leave  
  1058c9:	c3                   	ret    

001058ca <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
  1058ca:	55                   	push   %ebp
  1058cb:	89 e5                	mov    %esp,%ebp
  1058cd:	56                   	push   %esi
  1058ce:	53                   	push   %ebx
  1058cf:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1058d2:	eb 17                	jmp    1058eb <vprintfmt+0x21>
            if (ch == '\0') {
  1058d4:	85 db                	test   %ebx,%ebx
  1058d6:	0f 84 db 03 00 00    	je     105cb7 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
  1058dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  1058df:	89 44 24 04          	mov    %eax,0x4(%esp)
  1058e3:	89 1c 24             	mov    %ebx,(%esp)
  1058e6:	8b 45 08             	mov    0x8(%ebp),%eax
  1058e9:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  1058eb:	8b 45 10             	mov    0x10(%ebp),%eax
  1058ee:	0f b6 00             	movzbl (%eax),%eax
  1058f1:	0f b6 d8             	movzbl %al,%ebx
  1058f4:	83 fb 25             	cmp    $0x25,%ebx
  1058f7:	0f 95 c0             	setne  %al
  1058fa:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  1058fe:	84 c0                	test   %al,%al
  105900:	75 d2                	jne    1058d4 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
  105902:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  105906:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  10590d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105910:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  105913:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  10591a:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10591d:	89 45 e0             	mov    %eax,-0x20(%ebp)
  105920:	eb 04                	jmp    105926 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  105922:	90                   	nop
  105923:	eb 01                	jmp    105926 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  105925:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  105926:	8b 45 10             	mov    0x10(%ebp),%eax
  105929:	0f b6 00             	movzbl (%eax),%eax
  10592c:	0f b6 d8             	movzbl %al,%ebx
  10592f:	89 d8                	mov    %ebx,%eax
  105931:	83 45 10 01          	addl   $0x1,0x10(%ebp)
  105935:	83 e8 23             	sub    $0x23,%eax
  105938:	83 f8 55             	cmp    $0x55,%eax
  10593b:	0f 87 45 03 00 00    	ja     105c86 <vprintfmt+0x3bc>
  105941:	8b 04 85 18 74 10 00 	mov    0x107418(,%eax,4),%eax
  105948:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  10594a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  10594e:	eb d6                	jmp    105926 <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  105950:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  105954:	eb d0                	jmp    105926 <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105956:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  10595d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  105960:	89 d0                	mov    %edx,%eax
  105962:	c1 e0 02             	shl    $0x2,%eax
  105965:	01 d0                	add    %edx,%eax
  105967:	01 c0                	add    %eax,%eax
  105969:	01 d8                	add    %ebx,%eax
  10596b:	83 e8 30             	sub    $0x30,%eax
  10596e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  105971:	8b 45 10             	mov    0x10(%ebp),%eax
  105974:	0f b6 00             	movzbl (%eax),%eax
  105977:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  10597a:	83 fb 2f             	cmp    $0x2f,%ebx
  10597d:	7e 39                	jle    1059b8 <vprintfmt+0xee>
  10597f:	83 fb 39             	cmp    $0x39,%ebx
  105982:	7f 34                	jg     1059b8 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  105984:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  105988:	eb d3                	jmp    10595d <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  10598a:	8b 45 14             	mov    0x14(%ebp),%eax
  10598d:	8d 50 04             	lea    0x4(%eax),%edx
  105990:	89 55 14             	mov    %edx,0x14(%ebp)
  105993:	8b 00                	mov    (%eax),%eax
  105995:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  105998:	eb 1f                	jmp    1059b9 <vprintfmt+0xef>

        case '.':
            if (width < 0)
  10599a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  10599e:	79 82                	jns    105922 <vprintfmt+0x58>
                width = 0;
  1059a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  1059a7:	e9 76 ff ff ff       	jmp    105922 <vprintfmt+0x58>

        case '#':
            altflag = 1;
  1059ac:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  1059b3:	e9 6e ff ff ff       	jmp    105926 <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  1059b8:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  1059b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  1059bd:	0f 89 62 ff ff ff    	jns    105925 <vprintfmt+0x5b>
                width = precision, precision = -1;
  1059c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  1059c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
  1059c9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  1059d0:	e9 50 ff ff ff       	jmp    105925 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  1059d5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  1059d9:	e9 48 ff ff ff       	jmp    105926 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
  1059de:	8b 45 14             	mov    0x14(%ebp),%eax
  1059e1:	8d 50 04             	lea    0x4(%eax),%edx
  1059e4:	89 55 14             	mov    %edx,0x14(%ebp)
  1059e7:	8b 00                	mov    (%eax),%eax
  1059e9:	8b 55 0c             	mov    0xc(%ebp),%edx
  1059ec:	89 54 24 04          	mov    %edx,0x4(%esp)
  1059f0:	89 04 24             	mov    %eax,(%esp)
  1059f3:	8b 45 08             	mov    0x8(%ebp),%eax
  1059f6:	ff d0                	call   *%eax
            break;
  1059f8:	e9 b4 02 00 00       	jmp    105cb1 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
  1059fd:	8b 45 14             	mov    0x14(%ebp),%eax
  105a00:	8d 50 04             	lea    0x4(%eax),%edx
  105a03:	89 55 14             	mov    %edx,0x14(%ebp)
  105a06:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  105a08:	85 db                	test   %ebx,%ebx
  105a0a:	79 02                	jns    105a0e <vprintfmt+0x144>
                err = -err;
  105a0c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  105a0e:	83 fb 06             	cmp    $0x6,%ebx
  105a11:	7f 0b                	jg     105a1e <vprintfmt+0x154>
  105a13:	8b 34 9d d8 73 10 00 	mov    0x1073d8(,%ebx,4),%esi
  105a1a:	85 f6                	test   %esi,%esi
  105a1c:	75 23                	jne    105a41 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
  105a1e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
  105a22:	c7 44 24 08 05 74 10 	movl   $0x107405,0x8(%esp)
  105a29:	00 
  105a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a31:	8b 45 08             	mov    0x8(%ebp),%eax
  105a34:	89 04 24             	mov    %eax,(%esp)
  105a37:	e8 5e fe ff ff       	call   10589a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
  105a3c:	e9 70 02 00 00       	jmp    105cb1 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
  105a41:	89 74 24 0c          	mov    %esi,0xc(%esp)
  105a45:	c7 44 24 08 0e 74 10 	movl   $0x10740e,0x8(%esp)
  105a4c:	00 
  105a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
  105a50:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a54:	8b 45 08             	mov    0x8(%ebp),%eax
  105a57:	89 04 24             	mov    %eax,(%esp)
  105a5a:	e8 3b fe ff ff       	call   10589a <printfmt>
            }
            break;
  105a5f:	e9 4d 02 00 00       	jmp    105cb1 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  105a64:	8b 45 14             	mov    0x14(%ebp),%eax
  105a67:	8d 50 04             	lea    0x4(%eax),%edx
  105a6a:	89 55 14             	mov    %edx,0x14(%ebp)
  105a6d:	8b 30                	mov    (%eax),%esi
  105a6f:	85 f6                	test   %esi,%esi
  105a71:	75 05                	jne    105a78 <vprintfmt+0x1ae>
                p = "(null)";
  105a73:	be 11 74 10 00       	mov    $0x107411,%esi
            }
            if (width > 0 && padc != '-') {
  105a78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105a7c:	7e 7c                	jle    105afa <vprintfmt+0x230>
  105a7e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  105a82:	74 76                	je     105afa <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
  105a84:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  105a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  105a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
  105a8e:	89 34 24             	mov    %esi,(%esp)
  105a91:	e8 21 03 00 00       	call   105db7 <strnlen>
  105a96:	89 da                	mov    %ebx,%edx
  105a98:	29 c2                	sub    %eax,%edx
  105a9a:	89 d0                	mov    %edx,%eax
  105a9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105a9f:	eb 17                	jmp    105ab8 <vprintfmt+0x1ee>
                    putch(padc, putdat);
  105aa1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  105aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
  105aa8:	89 54 24 04          	mov    %edx,0x4(%esp)
  105aac:	89 04 24             	mov    %eax,(%esp)
  105aaf:	8b 45 08             	mov    0x8(%ebp),%eax
  105ab2:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  105ab4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105ab8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105abc:	7f e3                	jg     105aa1 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105abe:	eb 3a                	jmp    105afa <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
  105ac0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  105ac4:	74 1f                	je     105ae5 <vprintfmt+0x21b>
  105ac6:	83 fb 1f             	cmp    $0x1f,%ebx
  105ac9:	7e 05                	jle    105ad0 <vprintfmt+0x206>
  105acb:	83 fb 7e             	cmp    $0x7e,%ebx
  105ace:	7e 15                	jle    105ae5 <vprintfmt+0x21b>
                    putch('?', putdat);
  105ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
  105ad7:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  105ade:	8b 45 08             	mov    0x8(%ebp),%eax
  105ae1:	ff d0                	call   *%eax
  105ae3:	eb 0f                	jmp    105af4 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
  105ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
  105aec:	89 1c 24             	mov    %ebx,(%esp)
  105aef:	8b 45 08             	mov    0x8(%ebp),%eax
  105af2:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  105af4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105af8:	eb 01                	jmp    105afb <vprintfmt+0x231>
  105afa:	90                   	nop
  105afb:	0f b6 06             	movzbl (%esi),%eax
  105afe:	0f be d8             	movsbl %al,%ebx
  105b01:	85 db                	test   %ebx,%ebx
  105b03:	0f 95 c0             	setne  %al
  105b06:	83 c6 01             	add    $0x1,%esi
  105b09:	84 c0                	test   %al,%al
  105b0b:	74 29                	je     105b36 <vprintfmt+0x26c>
  105b0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105b11:	78 ad                	js     105ac0 <vprintfmt+0x1f6>
  105b13:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  105b17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  105b1b:	79 a3                	jns    105ac0 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105b1d:	eb 17                	jmp    105b36 <vprintfmt+0x26c>
                putch(' ', putdat);
  105b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b22:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b26:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  105b2d:	8b 45 08             	mov    0x8(%ebp),%eax
  105b30:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
  105b32:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  105b36:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  105b3a:	7f e3                	jg     105b1f <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
  105b3c:	e9 70 01 00 00       	jmp    105cb1 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  105b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b48:	8d 45 14             	lea    0x14(%ebp),%eax
  105b4b:	89 04 24             	mov    %eax,(%esp)
  105b4e:	e8 f8 fc ff ff       	call   10584b <getint>
  105b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b56:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  105b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b5f:	85 d2                	test   %edx,%edx
  105b61:	79 26                	jns    105b89 <vprintfmt+0x2bf>
                putch('-', putdat);
  105b63:	8b 45 0c             	mov    0xc(%ebp),%eax
  105b66:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b6a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  105b71:	8b 45 08             	mov    0x8(%ebp),%eax
  105b74:	ff d0                	call   *%eax
                num = -(long long)num;
  105b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105b7c:	f7 d8                	neg    %eax
  105b7e:	83 d2 00             	adc    $0x0,%edx
  105b81:	f7 da                	neg    %edx
  105b83:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105b86:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  105b89:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105b90:	e9 a8 00 00 00       	jmp    105c3d <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  105b95:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105b98:	89 44 24 04          	mov    %eax,0x4(%esp)
  105b9c:	8d 45 14             	lea    0x14(%ebp),%eax
  105b9f:	89 04 24             	mov    %eax,(%esp)
  105ba2:	e8 55 fc ff ff       	call   1057fc <getuint>
  105ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105baa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  105bad:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  105bb4:	e9 84 00 00 00       	jmp    105c3d <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  105bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bc0:	8d 45 14             	lea    0x14(%ebp),%eax
  105bc3:	89 04 24             	mov    %eax,(%esp)
  105bc6:	e8 31 fc ff ff       	call   1057fc <getuint>
  105bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105bce:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  105bd1:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  105bd8:	eb 63                	jmp    105c3d <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
  105bda:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
  105be1:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  105be8:	8b 45 08             	mov    0x8(%ebp),%eax
  105beb:	ff d0                	call   *%eax
            putch('x', putdat);
  105bed:	8b 45 0c             	mov    0xc(%ebp),%eax
  105bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
  105bf4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  105bfb:	8b 45 08             	mov    0x8(%ebp),%eax
  105bfe:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  105c00:	8b 45 14             	mov    0x14(%ebp),%eax
  105c03:	8d 50 04             	lea    0x4(%eax),%edx
  105c06:	89 55 14             	mov    %edx,0x14(%ebp)
  105c09:	8b 00                	mov    (%eax),%eax
  105c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  105c15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  105c1c:	eb 1f                	jmp    105c3d <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  105c1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
  105c21:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c25:	8d 45 14             	lea    0x14(%ebp),%eax
  105c28:	89 04 24             	mov    %eax,(%esp)
  105c2b:	e8 cc fb ff ff       	call   1057fc <getuint>
  105c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105c33:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  105c36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
  105c3d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  105c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105c44:	89 54 24 18          	mov    %edx,0x18(%esp)
  105c48:	8b 55 e8             	mov    -0x18(%ebp),%edx
  105c4b:	89 54 24 14          	mov    %edx,0x14(%esp)
  105c4f:	89 44 24 10          	mov    %eax,0x10(%esp)
  105c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105c56:	8b 55 f4             	mov    -0xc(%ebp),%edx
  105c59:	89 44 24 08          	mov    %eax,0x8(%esp)
  105c5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
  105c61:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c64:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c68:	8b 45 08             	mov    0x8(%ebp),%eax
  105c6b:	89 04 24             	mov    %eax,(%esp)
  105c6e:	e8 51 fa ff ff       	call   1056c4 <printnum>
            break;
  105c73:	eb 3c                	jmp    105cb1 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
  105c75:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c78:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c7c:	89 1c 24             	mov    %ebx,(%esp)
  105c7f:	8b 45 08             	mov    0x8(%ebp),%eax
  105c82:	ff d0                	call   *%eax
            break;
  105c84:	eb 2b                	jmp    105cb1 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
  105c86:	8b 45 0c             	mov    0xc(%ebp),%eax
  105c89:	89 44 24 04          	mov    %eax,0x4(%esp)
  105c8d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  105c94:	8b 45 08             	mov    0x8(%ebp),%eax
  105c97:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  105c99:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105c9d:	eb 04                	jmp    105ca3 <vprintfmt+0x3d9>
  105c9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ca3:	8b 45 10             	mov    0x10(%ebp),%eax
  105ca6:	83 e8 01             	sub    $0x1,%eax
  105ca9:	0f b6 00             	movzbl (%eax),%eax
  105cac:	3c 25                	cmp    $0x25,%al
  105cae:	75 ef                	jne    105c9f <vprintfmt+0x3d5>
                /* do nothing */;
            break;
  105cb0:	90                   	nop
        }
    }
  105cb1:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  105cb2:	e9 34 fc ff ff       	jmp    1058eb <vprintfmt+0x21>
            if (ch == '\0') {
                return;
  105cb7:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  105cb8:	83 c4 40             	add    $0x40,%esp
  105cbb:	5b                   	pop    %ebx
  105cbc:	5e                   	pop    %esi
  105cbd:	5d                   	pop    %ebp
  105cbe:	c3                   	ret    

00105cbf <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  105cbf:	55                   	push   %ebp
  105cc0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  105cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cc5:	8b 40 08             	mov    0x8(%eax),%eax
  105cc8:	8d 50 01             	lea    0x1(%eax),%edx
  105ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cce:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  105cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cd4:	8b 10                	mov    (%eax),%edx
  105cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cd9:	8b 40 04             	mov    0x4(%eax),%eax
  105cdc:	39 c2                	cmp    %eax,%edx
  105cde:	73 12                	jae    105cf2 <sprintputch+0x33>
        *b->buf ++ = ch;
  105ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ce3:	8b 00                	mov    (%eax),%eax
  105ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  105ce8:	88 10                	mov    %dl,(%eax)
  105cea:	8d 50 01             	lea    0x1(%eax),%edx
  105ced:	8b 45 0c             	mov    0xc(%ebp),%eax
  105cf0:	89 10                	mov    %edx,(%eax)
    }
}
  105cf2:	5d                   	pop    %ebp
  105cf3:	c3                   	ret    

00105cf4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  105cf4:	55                   	push   %ebp
  105cf5:	89 e5                	mov    %esp,%ebp
  105cf7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  105cfa:	8d 55 14             	lea    0x14(%ebp),%edx
  105cfd:	8d 45 f0             	lea    -0x10(%ebp),%eax
  105d00:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
  105d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d05:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105d09:	8b 45 10             	mov    0x10(%ebp),%eax
  105d0c:	89 44 24 08          	mov    %eax,0x8(%esp)
  105d10:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d13:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d17:	8b 45 08             	mov    0x8(%ebp),%eax
  105d1a:	89 04 24             	mov    %eax,(%esp)
  105d1d:	e8 08 00 00 00       	call   105d2a <vsnprintf>
  105d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  105d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105d28:	c9                   	leave  
  105d29:	c3                   	ret    

00105d2a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  105d2a:	55                   	push   %ebp
  105d2b:	89 e5                	mov    %esp,%ebp
  105d2d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  105d30:	8b 45 08             	mov    0x8(%ebp),%eax
  105d33:	89 45 ec             	mov    %eax,-0x14(%ebp)
  105d36:	8b 45 0c             	mov    0xc(%ebp),%eax
  105d39:	83 e8 01             	sub    $0x1,%eax
  105d3c:	03 45 08             	add    0x8(%ebp),%eax
  105d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105d42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  105d49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  105d4d:	74 0a                	je     105d59 <vsnprintf+0x2f>
  105d4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105d55:	39 c2                	cmp    %eax,%edx
  105d57:	76 07                	jbe    105d60 <vsnprintf+0x36>
        return -E_INVAL;
  105d59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  105d5e:	eb 2a                	jmp    105d8a <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
  105d60:	8b 45 14             	mov    0x14(%ebp),%eax
  105d63:	89 44 24 0c          	mov    %eax,0xc(%esp)
  105d67:	8b 45 10             	mov    0x10(%ebp),%eax
  105d6a:	89 44 24 08          	mov    %eax,0x8(%esp)
  105d6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
  105d71:	89 44 24 04          	mov    %eax,0x4(%esp)
  105d75:	c7 04 24 bf 5c 10 00 	movl   $0x105cbf,(%esp)
  105d7c:	e8 49 fb ff ff       	call   1058ca <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  105d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105d84:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  105d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  105d8a:	c9                   	leave  
  105d8b:	c3                   	ret    

00105d8c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  105d8c:	55                   	push   %ebp
  105d8d:	89 e5                	mov    %esp,%ebp
  105d8f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105d92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  105d99:	eb 04                	jmp    105d9f <strlen+0x13>
        cnt ++;
  105d9b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  105d9f:	8b 45 08             	mov    0x8(%ebp),%eax
  105da2:	0f b6 00             	movzbl (%eax),%eax
  105da5:	84 c0                	test   %al,%al
  105da7:	0f 95 c0             	setne  %al
  105daa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105dae:	84 c0                	test   %al,%al
  105db0:	75 e9                	jne    105d9b <strlen+0xf>
        cnt ++;
    }
    return cnt;
  105db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105db5:	c9                   	leave  
  105db6:	c3                   	ret    

00105db7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  105db7:	55                   	push   %ebp
  105db8:	89 e5                	mov    %esp,%ebp
  105dba:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  105dbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  105dc4:	eb 04                	jmp    105dca <strnlen+0x13>
        cnt ++;
  105dc6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  105dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105dcd:	3b 45 0c             	cmp    0xc(%ebp),%eax
  105dd0:	73 13                	jae    105de5 <strnlen+0x2e>
  105dd2:	8b 45 08             	mov    0x8(%ebp),%eax
  105dd5:	0f b6 00             	movzbl (%eax),%eax
  105dd8:	84 c0                	test   %al,%al
  105dda:	0f 95 c0             	setne  %al
  105ddd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105de1:	84 c0                	test   %al,%al
  105de3:	75 e1                	jne    105dc6 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  105de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  105de8:	c9                   	leave  
  105de9:	c3                   	ret    

00105dea <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  105dea:	55                   	push   %ebp
  105deb:	89 e5                	mov    %esp,%ebp
  105ded:	57                   	push   %edi
  105dee:	56                   	push   %esi
  105def:	53                   	push   %ebx
  105df0:	83 ec 24             	sub    $0x24,%esp
  105df3:	8b 45 08             	mov    0x8(%ebp),%eax
  105df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105df9:	8b 45 0c             	mov    0xc(%ebp),%eax
  105dfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  105dff:	8b 55 ec             	mov    -0x14(%ebp),%edx
  105e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
  105e05:	89 d6                	mov    %edx,%esi
  105e07:	89 c3                	mov    %eax,%ebx
  105e09:	89 df                	mov    %ebx,%edi
  105e0b:	ac                   	lods   %ds:(%esi),%al
  105e0c:	aa                   	stos   %al,%es:(%edi)
  105e0d:	84 c0                	test   %al,%al
  105e0f:	75 fa                	jne    105e0b <strcpy+0x21>
  105e11:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105e14:	89 fb                	mov    %edi,%ebx
  105e16:	89 75 e8             	mov    %esi,-0x18(%ebp)
  105e19:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  105e1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105e1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  105e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  105e25:	83 c4 24             	add    $0x24,%esp
  105e28:	5b                   	pop    %ebx
  105e29:	5e                   	pop    %esi
  105e2a:	5f                   	pop    %edi
  105e2b:	5d                   	pop    %ebp
  105e2c:	c3                   	ret    

00105e2d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  105e2d:	55                   	push   %ebp
  105e2e:	89 e5                	mov    %esp,%ebp
  105e30:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  105e33:	8b 45 08             	mov    0x8(%ebp),%eax
  105e36:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  105e39:	eb 21                	jmp    105e5c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  105e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e3e:	0f b6 10             	movzbl (%eax),%edx
  105e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e44:	88 10                	mov    %dl,(%eax)
  105e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
  105e49:	0f b6 00             	movzbl (%eax),%eax
  105e4c:	84 c0                	test   %al,%al
  105e4e:	74 04                	je     105e54 <strncpy+0x27>
            src ++;
  105e50:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  105e54:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  105e58:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  105e5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105e60:	75 d9                	jne    105e3b <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  105e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105e65:	c9                   	leave  
  105e66:	c3                   	ret    

00105e67 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  105e67:	55                   	push   %ebp
  105e68:	89 e5                	mov    %esp,%ebp
  105e6a:	57                   	push   %edi
  105e6b:	56                   	push   %esi
  105e6c:	53                   	push   %ebx
  105e6d:	83 ec 24             	sub    $0x24,%esp
  105e70:	8b 45 08             	mov    0x8(%ebp),%eax
  105e73:	89 45 f0             	mov    %eax,-0x10(%ebp)
  105e76:	8b 45 0c             	mov    0xc(%ebp),%eax
  105e79:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  105e7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
  105e7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
  105e82:	89 d6                	mov    %edx,%esi
  105e84:	89 c3                	mov    %eax,%ebx
  105e86:	89 df                	mov    %ebx,%edi
  105e88:	ac                   	lods   %ds:(%esi),%al
  105e89:	ae                   	scas   %es:(%edi),%al
  105e8a:	75 08                	jne    105e94 <strcmp+0x2d>
  105e8c:	84 c0                	test   %al,%al
  105e8e:	75 f8                	jne    105e88 <strcmp+0x21>
  105e90:	31 c0                	xor    %eax,%eax
  105e92:	eb 04                	jmp    105e98 <strcmp+0x31>
  105e94:	19 c0                	sbb    %eax,%eax
  105e96:	0c 01                	or     $0x1,%al
  105e98:	89 fb                	mov    %edi,%ebx
  105e9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
  105e9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
  105ea0:	89 45 e8             	mov    %eax,-0x18(%ebp)
  105ea3:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  105ea6:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  105ea9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  105eac:	83 c4 24             	add    $0x24,%esp
  105eaf:	5b                   	pop    %ebx
  105eb0:	5e                   	pop    %esi
  105eb1:	5f                   	pop    %edi
  105eb2:	5d                   	pop    %ebp
  105eb3:	c3                   	ret    

00105eb4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  105eb4:	55                   	push   %ebp
  105eb5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105eb7:	eb 0c                	jmp    105ec5 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  105eb9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  105ebd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105ec1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  105ec5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ec9:	74 1a                	je     105ee5 <strncmp+0x31>
  105ecb:	8b 45 08             	mov    0x8(%ebp),%eax
  105ece:	0f b6 00             	movzbl (%eax),%eax
  105ed1:	84 c0                	test   %al,%al
  105ed3:	74 10                	je     105ee5 <strncmp+0x31>
  105ed5:	8b 45 08             	mov    0x8(%ebp),%eax
  105ed8:	0f b6 10             	movzbl (%eax),%edx
  105edb:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ede:	0f b6 00             	movzbl (%eax),%eax
  105ee1:	38 c2                	cmp    %al,%dl
  105ee3:	74 d4                	je     105eb9 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  105ee5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ee9:	74 1a                	je     105f05 <strncmp+0x51>
  105eeb:	8b 45 08             	mov    0x8(%ebp),%eax
  105eee:	0f b6 00             	movzbl (%eax),%eax
  105ef1:	0f b6 d0             	movzbl %al,%edx
  105ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
  105ef7:	0f b6 00             	movzbl (%eax),%eax
  105efa:	0f b6 c0             	movzbl %al,%eax
  105efd:	89 d1                	mov    %edx,%ecx
  105eff:	29 c1                	sub    %eax,%ecx
  105f01:	89 c8                	mov    %ecx,%eax
  105f03:	eb 05                	jmp    105f0a <strncmp+0x56>
  105f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f0a:	5d                   	pop    %ebp
  105f0b:	c3                   	ret    

00105f0c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  105f0c:	55                   	push   %ebp
  105f0d:	89 e5                	mov    %esp,%ebp
  105f0f:	83 ec 04             	sub    $0x4,%esp
  105f12:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f15:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105f18:	eb 14                	jmp    105f2e <strchr+0x22>
        if (*s == c) {
  105f1a:	8b 45 08             	mov    0x8(%ebp),%eax
  105f1d:	0f b6 00             	movzbl (%eax),%eax
  105f20:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105f23:	75 05                	jne    105f2a <strchr+0x1e>
            return (char *)s;
  105f25:	8b 45 08             	mov    0x8(%ebp),%eax
  105f28:	eb 13                	jmp    105f3d <strchr+0x31>
        }
        s ++;
  105f2a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  105f2e:	8b 45 08             	mov    0x8(%ebp),%eax
  105f31:	0f b6 00             	movzbl (%eax),%eax
  105f34:	84 c0                	test   %al,%al
  105f36:	75 e2                	jne    105f1a <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  105f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
  105f3d:	c9                   	leave  
  105f3e:	c3                   	ret    

00105f3f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  105f3f:	55                   	push   %ebp
  105f40:	89 e5                	mov    %esp,%ebp
  105f42:	83 ec 04             	sub    $0x4,%esp
  105f45:	8b 45 0c             	mov    0xc(%ebp),%eax
  105f48:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  105f4b:	eb 0f                	jmp    105f5c <strfind+0x1d>
        if (*s == c) {
  105f4d:	8b 45 08             	mov    0x8(%ebp),%eax
  105f50:	0f b6 00             	movzbl (%eax),%eax
  105f53:	3a 45 fc             	cmp    -0x4(%ebp),%al
  105f56:	74 10                	je     105f68 <strfind+0x29>
            break;
        }
        s ++;
  105f58:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  105f5c:	8b 45 08             	mov    0x8(%ebp),%eax
  105f5f:	0f b6 00             	movzbl (%eax),%eax
  105f62:	84 c0                	test   %al,%al
  105f64:	75 e7                	jne    105f4d <strfind+0xe>
  105f66:	eb 01                	jmp    105f69 <strfind+0x2a>
        if (*s == c) {
            break;
  105f68:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  105f69:	8b 45 08             	mov    0x8(%ebp),%eax
}
  105f6c:	c9                   	leave  
  105f6d:	c3                   	ret    

00105f6e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  105f6e:	55                   	push   %ebp
  105f6f:	89 e5                	mov    %esp,%ebp
  105f71:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  105f74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  105f7b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105f82:	eb 04                	jmp    105f88 <strtol+0x1a>
        s ++;
  105f84:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  105f88:	8b 45 08             	mov    0x8(%ebp),%eax
  105f8b:	0f b6 00             	movzbl (%eax),%eax
  105f8e:	3c 20                	cmp    $0x20,%al
  105f90:	74 f2                	je     105f84 <strtol+0x16>
  105f92:	8b 45 08             	mov    0x8(%ebp),%eax
  105f95:	0f b6 00             	movzbl (%eax),%eax
  105f98:	3c 09                	cmp    $0x9,%al
  105f9a:	74 e8                	je     105f84 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  105f9c:	8b 45 08             	mov    0x8(%ebp),%eax
  105f9f:	0f b6 00             	movzbl (%eax),%eax
  105fa2:	3c 2b                	cmp    $0x2b,%al
  105fa4:	75 06                	jne    105fac <strtol+0x3e>
        s ++;
  105fa6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105faa:	eb 15                	jmp    105fc1 <strtol+0x53>
    }
    else if (*s == '-') {
  105fac:	8b 45 08             	mov    0x8(%ebp),%eax
  105faf:	0f b6 00             	movzbl (%eax),%eax
  105fb2:	3c 2d                	cmp    $0x2d,%al
  105fb4:	75 0b                	jne    105fc1 <strtol+0x53>
        s ++, neg = 1;
  105fb6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  105fba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  105fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105fc5:	74 06                	je     105fcd <strtol+0x5f>
  105fc7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  105fcb:	75 24                	jne    105ff1 <strtol+0x83>
  105fcd:	8b 45 08             	mov    0x8(%ebp),%eax
  105fd0:	0f b6 00             	movzbl (%eax),%eax
  105fd3:	3c 30                	cmp    $0x30,%al
  105fd5:	75 1a                	jne    105ff1 <strtol+0x83>
  105fd7:	8b 45 08             	mov    0x8(%ebp),%eax
  105fda:	83 c0 01             	add    $0x1,%eax
  105fdd:	0f b6 00             	movzbl (%eax),%eax
  105fe0:	3c 78                	cmp    $0x78,%al
  105fe2:	75 0d                	jne    105ff1 <strtol+0x83>
        s += 2, base = 16;
  105fe4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  105fe8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  105fef:	eb 2a                	jmp    10601b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  105ff1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  105ff5:	75 17                	jne    10600e <strtol+0xa0>
  105ff7:	8b 45 08             	mov    0x8(%ebp),%eax
  105ffa:	0f b6 00             	movzbl (%eax),%eax
  105ffd:	3c 30                	cmp    $0x30,%al
  105fff:	75 0d                	jne    10600e <strtol+0xa0>
        s ++, base = 8;
  106001:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  106005:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  10600c:	eb 0d                	jmp    10601b <strtol+0xad>
    }
    else if (base == 0) {
  10600e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  106012:	75 07                	jne    10601b <strtol+0xad>
        base = 10;
  106014:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  10601b:	8b 45 08             	mov    0x8(%ebp),%eax
  10601e:	0f b6 00             	movzbl (%eax),%eax
  106021:	3c 2f                	cmp    $0x2f,%al
  106023:	7e 1b                	jle    106040 <strtol+0xd2>
  106025:	8b 45 08             	mov    0x8(%ebp),%eax
  106028:	0f b6 00             	movzbl (%eax),%eax
  10602b:	3c 39                	cmp    $0x39,%al
  10602d:	7f 11                	jg     106040 <strtol+0xd2>
            dig = *s - '0';
  10602f:	8b 45 08             	mov    0x8(%ebp),%eax
  106032:	0f b6 00             	movzbl (%eax),%eax
  106035:	0f be c0             	movsbl %al,%eax
  106038:	83 e8 30             	sub    $0x30,%eax
  10603b:	89 45 f4             	mov    %eax,-0xc(%ebp)
  10603e:	eb 48                	jmp    106088 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  106040:	8b 45 08             	mov    0x8(%ebp),%eax
  106043:	0f b6 00             	movzbl (%eax),%eax
  106046:	3c 60                	cmp    $0x60,%al
  106048:	7e 1b                	jle    106065 <strtol+0xf7>
  10604a:	8b 45 08             	mov    0x8(%ebp),%eax
  10604d:	0f b6 00             	movzbl (%eax),%eax
  106050:	3c 7a                	cmp    $0x7a,%al
  106052:	7f 11                	jg     106065 <strtol+0xf7>
            dig = *s - 'a' + 10;
  106054:	8b 45 08             	mov    0x8(%ebp),%eax
  106057:	0f b6 00             	movzbl (%eax),%eax
  10605a:	0f be c0             	movsbl %al,%eax
  10605d:	83 e8 57             	sub    $0x57,%eax
  106060:	89 45 f4             	mov    %eax,-0xc(%ebp)
  106063:	eb 23                	jmp    106088 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  106065:	8b 45 08             	mov    0x8(%ebp),%eax
  106068:	0f b6 00             	movzbl (%eax),%eax
  10606b:	3c 40                	cmp    $0x40,%al
  10606d:	7e 38                	jle    1060a7 <strtol+0x139>
  10606f:	8b 45 08             	mov    0x8(%ebp),%eax
  106072:	0f b6 00             	movzbl (%eax),%eax
  106075:	3c 5a                	cmp    $0x5a,%al
  106077:	7f 2e                	jg     1060a7 <strtol+0x139>
            dig = *s - 'A' + 10;
  106079:	8b 45 08             	mov    0x8(%ebp),%eax
  10607c:	0f b6 00             	movzbl (%eax),%eax
  10607f:	0f be c0             	movsbl %al,%eax
  106082:	83 e8 37             	sub    $0x37,%eax
  106085:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  106088:	8b 45 f4             	mov    -0xc(%ebp),%eax
  10608b:	3b 45 10             	cmp    0x10(%ebp),%eax
  10608e:	7d 16                	jge    1060a6 <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
  106090:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  106094:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106097:	0f af 45 10          	imul   0x10(%ebp),%eax
  10609b:	03 45 f4             	add    -0xc(%ebp),%eax
  10609e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  1060a1:	e9 75 ff ff ff       	jmp    10601b <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  1060a6:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  1060a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  1060ab:	74 08                	je     1060b5 <strtol+0x147>
        *endptr = (char *) s;
  1060ad:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060b0:	8b 55 08             	mov    0x8(%ebp),%edx
  1060b3:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  1060b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  1060b9:	74 07                	je     1060c2 <strtol+0x154>
  1060bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
  1060be:	f7 d8                	neg    %eax
  1060c0:	eb 03                	jmp    1060c5 <strtol+0x157>
  1060c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  1060c5:	c9                   	leave  
  1060c6:	c3                   	ret    

001060c7 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  1060c7:	55                   	push   %ebp
  1060c8:	89 e5                	mov    %esp,%ebp
  1060ca:	57                   	push   %edi
  1060cb:	56                   	push   %esi
  1060cc:	53                   	push   %ebx
  1060cd:	83 ec 24             	sub    $0x24,%esp
  1060d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  1060d3:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  1060d6:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  1060da:	8b 55 08             	mov    0x8(%ebp),%edx
  1060dd:	89 55 f0             	mov    %edx,-0x10(%ebp)
  1060e0:	88 45 ef             	mov    %al,-0x11(%ebp)
  1060e3:	8b 45 10             	mov    0x10(%ebp),%eax
  1060e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  1060e9:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  1060ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  1060f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1060f3:	89 ce                	mov    %ecx,%esi
  1060f5:	89 d3                	mov    %edx,%ebx
  1060f7:	89 f1                	mov    %esi,%ecx
  1060f9:	89 df                	mov    %ebx,%edi
  1060fb:	f3 aa                	rep stos %al,%es:(%edi)
  1060fd:	89 fb                	mov    %edi,%ebx
  1060ff:	89 ce                	mov    %ecx,%esi
  106101:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  106104:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  106107:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  10610a:	83 c4 24             	add    $0x24,%esp
  10610d:	5b                   	pop    %ebx
  10610e:	5e                   	pop    %esi
  10610f:	5f                   	pop    %edi
  106110:	5d                   	pop    %ebp
  106111:	c3                   	ret    

00106112 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  106112:	55                   	push   %ebp
  106113:	89 e5                	mov    %esp,%ebp
  106115:	57                   	push   %edi
  106116:	56                   	push   %esi
  106117:	53                   	push   %ebx
  106118:	83 ec 38             	sub    $0x38,%esp
  10611b:	8b 45 08             	mov    0x8(%ebp),%eax
  10611e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  106121:	8b 45 0c             	mov    0xc(%ebp),%eax
  106124:	89 45 ec             	mov    %eax,-0x14(%ebp)
  106127:	8b 45 10             	mov    0x10(%ebp),%eax
  10612a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  10612d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106130:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  106133:	73 4e                	jae    106183 <memmove+0x71>
  106135:	8b 45 f0             	mov    -0x10(%ebp),%eax
  106138:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  10613b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  10613e:	89 45 e0             	mov    %eax,-0x20(%ebp)
  106141:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106144:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  106147:	8b 45 dc             	mov    -0x24(%ebp),%eax
  10614a:	89 c1                	mov    %eax,%ecx
  10614c:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  10614f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  106152:	8b 45 e0             	mov    -0x20(%ebp),%eax
  106155:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  106158:	89 d7                	mov    %edx,%edi
  10615a:	89 c3                	mov    %eax,%ebx
  10615c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  10615f:	89 de                	mov    %ebx,%esi
  106161:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  106163:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  106166:	83 e1 03             	and    $0x3,%ecx
  106169:	74 02                	je     10616d <memmove+0x5b>
  10616b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  10616d:	89 f3                	mov    %esi,%ebx
  10616f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  106172:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  106175:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  106178:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  10617b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  10617e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  106181:	eb 3b                	jmp    1061be <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  106183:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106186:	83 e8 01             	sub    $0x1,%eax
  106189:	89 c2                	mov    %eax,%edx
  10618b:	03 55 ec             	add    -0x14(%ebp),%edx
  10618e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  106191:	83 e8 01             	sub    $0x1,%eax
  106194:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  106197:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  10619a:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  10619d:	89 d6                	mov    %edx,%esi
  10619f:	89 c3                	mov    %eax,%ebx
  1061a1:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  1061a4:	89 df                	mov    %ebx,%edi
  1061a6:	fd                   	std    
  1061a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  1061a9:	fc                   	cld    
  1061aa:	89 fb                	mov    %edi,%ebx
  1061ac:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  1061af:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  1061b2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  1061b5:	89 75 c8             	mov    %esi,-0x38(%ebp)
  1061b8:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  1061bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  1061be:	83 c4 38             	add    $0x38,%esp
  1061c1:	5b                   	pop    %ebx
  1061c2:	5e                   	pop    %esi
  1061c3:	5f                   	pop    %edi
  1061c4:	5d                   	pop    %ebp
  1061c5:	c3                   	ret    

001061c6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  1061c6:	55                   	push   %ebp
  1061c7:	89 e5                	mov    %esp,%ebp
  1061c9:	57                   	push   %edi
  1061ca:	56                   	push   %esi
  1061cb:	53                   	push   %ebx
  1061cc:	83 ec 24             	sub    $0x24,%esp
  1061cf:	8b 45 08             	mov    0x8(%ebp),%eax
  1061d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  1061d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  1061d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
  1061db:	8b 45 10             	mov    0x10(%ebp),%eax
  1061de:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  1061e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
  1061e4:	89 c1                	mov    %eax,%ecx
  1061e6:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  1061e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  1061ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
  1061ef:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  1061f2:	89 d7                	mov    %edx,%edi
  1061f4:	89 c3                	mov    %eax,%ebx
  1061f6:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  1061f9:	89 de                	mov    %ebx,%esi
  1061fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  1061fd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  106200:	83 e1 03             	and    $0x3,%ecx
  106203:	74 02                	je     106207 <memcpy+0x41>
  106205:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  106207:	89 f3                	mov    %esi,%ebx
  106209:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  10620c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  10620f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  106212:	89 7d e0             	mov    %edi,-0x20(%ebp)
  106215:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  106218:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  10621b:	83 c4 24             	add    $0x24,%esp
  10621e:	5b                   	pop    %ebx
  10621f:	5e                   	pop    %esi
  106220:	5f                   	pop    %edi
  106221:	5d                   	pop    %ebp
  106222:	c3                   	ret    

00106223 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  106223:	55                   	push   %ebp
  106224:	89 e5                	mov    %esp,%ebp
  106226:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  106229:	8b 45 08             	mov    0x8(%ebp),%eax
  10622c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  10622f:	8b 45 0c             	mov    0xc(%ebp),%eax
  106232:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  106235:	eb 32                	jmp    106269 <memcmp+0x46>
        if (*s1 != *s2) {
  106237:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10623a:	0f b6 10             	movzbl (%eax),%edx
  10623d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106240:	0f b6 00             	movzbl (%eax),%eax
  106243:	38 c2                	cmp    %al,%dl
  106245:	74 1a                	je     106261 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  106247:	8b 45 fc             	mov    -0x4(%ebp),%eax
  10624a:	0f b6 00             	movzbl (%eax),%eax
  10624d:	0f b6 d0             	movzbl %al,%edx
  106250:	8b 45 f8             	mov    -0x8(%ebp),%eax
  106253:	0f b6 00             	movzbl (%eax),%eax
  106256:	0f b6 c0             	movzbl %al,%eax
  106259:	89 d1                	mov    %edx,%ecx
  10625b:	29 c1                	sub    %eax,%ecx
  10625d:	89 c8                	mov    %ecx,%eax
  10625f:	eb 1c                	jmp    10627d <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  106261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  106265:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  106269:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  10626d:	0f 95 c0             	setne  %al
  106270:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  106274:	84 c0                	test   %al,%al
  106276:	75 bf                	jne    106237 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  106278:	b8 00 00 00 00       	mov    $0x0,%eax
}
  10627d:	c9                   	leave  
  10627e:	c3                   	ret    
