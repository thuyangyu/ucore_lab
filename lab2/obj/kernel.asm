
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 80 11 00 	lgdtl  0x118018
    movl $KERNEL_DS, %eax
c0100007:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c010000c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c010000e:	8e c0                	mov    %eax,%es
    movw %ax, %ss
c0100010:	8e d0                	mov    %eax,%ss

    ljmp $KERNEL_CS, $relocated
c0100012:	ea 19 00 10 c0 08 00 	ljmp   $0x8,$0xc0100019

c0100019 <relocated>:

relocated:

    # set ebp, esp
    movl $0x0, %ebp
c0100019:	bd 00 00 00 00       	mov    $0x0,%ebp
    # the kernel stack region is from bootstack -- bootstacktop,
    # the kernel stack size is KSTACKSIZE (8KB)defined in memlayout.h
    movl $bootstacktop, %esp
c010001e:	bc 00 80 11 c0       	mov    $0xc0118000,%esp
    # now kernel stack is ready , call the first C function
    call kern_init
c0100023:	e8 04 00 00 00       	call   c010002c <kern_init>

c0100028 <spin>:

# should never get here
spin:
    jmp spin
c0100028:	eb fe                	jmp    c0100028 <spin>
	...

c010002c <kern_init>:
int kern_init(void) __attribute__((noreturn));
void grade_backtrace(void);
static void lab1_switch_test(void);

int
kern_init(void) {
c010002c:	55                   	push   %ebp
c010002d:	89 e5                	mov    %esp,%ebp
c010002f:	83 ec 28             	sub    $0x28,%esp
    extern char edata[], end[];
    memset(edata, 0, end - edata);
c0100032:	ba 68 99 11 c0       	mov    $0xc0119968,%edx
c0100037:	b8 38 8a 11 c0       	mov    $0xc0118a38,%eax
c010003c:	89 d1                	mov    %edx,%ecx
c010003e:	29 c1                	sub    %eax,%ecx
c0100040:	89 c8                	mov    %ecx,%eax
c0100042:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100046:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010004d:	00 
c010004e:	c7 04 24 38 8a 11 c0 	movl   $0xc0118a38,(%esp)
c0100055:	e8 6d 60 00 00       	call   c01060c7 <memset>

    cons_init();                // init the console
c010005a:	e8 fd 15 00 00       	call   c010165c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005f:	c7 45 f4 80 62 10 c0 	movl   $0xc0106280,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100066:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100069:	89 44 24 04          	mov    %eax,0x4(%esp)
c010006d:	c7 04 24 9c 62 10 c0 	movl   $0xc010629c,(%esp)
c0100074:	e8 ce 02 00 00       	call   c0100347 <cprintf>

    print_kerninfo();
c0100079:	e8 d8 07 00 00       	call   c0100856 <print_kerninfo>

    grade_backtrace();
c010007e:	e8 86 00 00 00       	call   c0100109 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100083:	e8 f4 44 00 00       	call   c010457c <pmm_init>

    pic_init();                 // init interrupt controller
c0100088:	e8 40 17 00 00       	call   c01017cd <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008d:	e8 92 18 00 00       	call   c0101924 <idt_init>

    clock_init();               // init clock interrupt
c0100092:	e8 d5 0c 00 00       	call   c0100d6c <clock_init>
    intr_enable();              // enable irq interrupt
c0100097:	e8 98 16 00 00       	call   c0101734 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c010009c:	eb fe                	jmp    c010009c <kern_init+0x70>

c010009e <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c010009e:	55                   	push   %ebp
c010009f:	89 e5                	mov    %esp,%ebp
c01000a1:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000a4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000ab:	00 
c01000ac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000b3:	00 
c01000b4:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000bb:	e8 d6 0b 00 00       	call   c0100c96 <mon_backtrace>
}
c01000c0:	c9                   	leave  
c01000c1:	c3                   	ret    

c01000c2 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000c2:	55                   	push   %ebp
c01000c3:	89 e5                	mov    %esp,%ebp
c01000c5:	53                   	push   %ebx
c01000c6:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000c9:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000cc:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000cf:	8d 55 08             	lea    0x8(%ebp),%edx
c01000d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01000d5:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000d9:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000dd:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000e1:	89 04 24             	mov    %eax,(%esp)
c01000e4:	e8 b5 ff ff ff       	call   c010009e <grade_backtrace2>
}
c01000e9:	83 c4 14             	add    $0x14,%esp
c01000ec:	5b                   	pop    %ebx
c01000ed:	5d                   	pop    %ebp
c01000ee:	c3                   	ret    

c01000ef <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000ef:	55                   	push   %ebp
c01000f0:	89 e5                	mov    %esp,%ebp
c01000f2:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c01000f5:	8b 45 10             	mov    0x10(%ebp),%eax
c01000f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01000fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ff:	89 04 24             	mov    %eax,(%esp)
c0100102:	e8 bb ff ff ff       	call   c01000c2 <grade_backtrace1>
}
c0100107:	c9                   	leave  
c0100108:	c3                   	ret    

c0100109 <grade_backtrace>:

void
grade_backtrace(void) {
c0100109:	55                   	push   %ebp
c010010a:	89 e5                	mov    %esp,%ebp
c010010c:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010010f:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c0100114:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010011b:	ff 
c010011c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100120:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100127:	e8 c3 ff ff ff       	call   c01000ef <grade_backtrace0>
}
c010012c:	c9                   	leave  
c010012d:	c3                   	ret    

c010012e <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010012e:	55                   	push   %ebp
c010012f:	89 e5                	mov    %esp,%ebp
c0100131:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100134:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100137:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c010013a:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010013d:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100140:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100144:	0f b7 c0             	movzwl %ax,%eax
c0100147:	89 c2                	mov    %eax,%edx
c0100149:	83 e2 03             	and    $0x3,%edx
c010014c:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100151:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100155:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100159:	c7 04 24 a1 62 10 c0 	movl   $0xc01062a1,(%esp)
c0100160:	e8 e2 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100165:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100169:	0f b7 d0             	movzwl %ax,%edx
c010016c:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100171:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100175:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100179:	c7 04 24 af 62 10 c0 	movl   $0xc01062af,(%esp)
c0100180:	e8 c2 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100185:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100189:	0f b7 d0             	movzwl %ax,%edx
c010018c:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c0100191:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100195:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100199:	c7 04 24 bd 62 10 c0 	movl   $0xc01062bd,(%esp)
c01001a0:	e8 a2 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001a5:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001a9:	0f b7 d0             	movzwl %ax,%edx
c01001ac:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c01001b1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b9:	c7 04 24 cb 62 10 c0 	movl   $0xc01062cb,(%esp)
c01001c0:	e8 82 01 00 00       	call   c0100347 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001c5:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001c9:	0f b7 d0             	movzwl %ax,%edx
c01001cc:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c01001d1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d9:	c7 04 24 d9 62 10 c0 	movl   $0xc01062d9,(%esp)
c01001e0:	e8 62 01 00 00       	call   c0100347 <cprintf>
    round ++;
c01001e5:	a1 40 8a 11 c0       	mov    0xc0118a40,%eax
c01001ea:	83 c0 01             	add    $0x1,%eax
c01001ed:	a3 40 8a 11 c0       	mov    %eax,0xc0118a40
}
c01001f2:	c9                   	leave  
c01001f3:	c3                   	ret    

c01001f4 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c01001f4:	55                   	push   %ebp
c01001f5:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c01001f7:	5d                   	pop    %ebp
c01001f8:	c3                   	ret    

c01001f9 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c01001f9:	55                   	push   %ebp
c01001fa:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c01001fc:	5d                   	pop    %ebp
c01001fd:	c3                   	ret    

c01001fe <lab1_switch_test>:

static void
lab1_switch_test(void) {
c01001fe:	55                   	push   %ebp
c01001ff:	89 e5                	mov    %esp,%ebp
c0100201:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100204:	e8 25 ff ff ff       	call   c010012e <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100209:	c7 04 24 e8 62 10 c0 	movl   $0xc01062e8,(%esp)
c0100210:	e8 32 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_user();
c0100215:	e8 da ff ff ff       	call   c01001f4 <lab1_switch_to_user>
    lab1_print_cur_status();
c010021a:	e8 0f ff ff ff       	call   c010012e <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010021f:	c7 04 24 08 63 10 c0 	movl   $0xc0106308,(%esp)
c0100226:	e8 1c 01 00 00       	call   c0100347 <cprintf>
    lab1_switch_to_kernel();
c010022b:	e8 c9 ff ff ff       	call   c01001f9 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100230:	e8 f9 fe ff ff       	call   c010012e <lab1_print_cur_status>
}
c0100235:	c9                   	leave  
c0100236:	c3                   	ret    
	...

c0100238 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100238:	55                   	push   %ebp
c0100239:	89 e5                	mov    %esp,%ebp
c010023b:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010023e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100242:	74 13                	je     c0100257 <readline+0x1f>
        cprintf("%s", prompt);
c0100244:	8b 45 08             	mov    0x8(%ebp),%eax
c0100247:	89 44 24 04          	mov    %eax,0x4(%esp)
c010024b:	c7 04 24 27 63 10 c0 	movl   $0xc0106327,(%esp)
c0100252:	e8 f0 00 00 00       	call   c0100347 <cprintf>
    }
    int i = 0, c;
c0100257:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010025e:	eb 01                	jmp    c0100261 <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
c0100260:	90                   	nop
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
c0100261:	e8 6e 01 00 00       	call   c01003d4 <getchar>
c0100266:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100269:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010026d:	79 07                	jns    c0100276 <readline+0x3e>
            return NULL;
c010026f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100274:	eb 79                	jmp    c01002ef <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100276:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010027a:	7e 28                	jle    c01002a4 <readline+0x6c>
c010027c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100283:	7f 1f                	jg     c01002a4 <readline+0x6c>
            cputchar(c);
c0100285:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100288:	89 04 24             	mov    %eax,(%esp)
c010028b:	e8 df 00 00 00       	call   c010036f <cputchar>
            buf[i ++] = c;
c0100290:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100293:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100296:	81 c2 60 8a 11 c0    	add    $0xc0118a60,%edx
c010029c:	88 02                	mov    %al,(%edx)
c010029e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01002a2:	eb 46                	jmp    c01002ea <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01002a4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002a8:	75 17                	jne    c01002c1 <readline+0x89>
c01002aa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002ae:	7e 11                	jle    c01002c1 <readline+0x89>
            cputchar(c);
c01002b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002b3:	89 04 24             	mov    %eax,(%esp)
c01002b6:	e8 b4 00 00 00       	call   c010036f <cputchar>
            i --;
c01002bb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002bf:	eb 29                	jmp    c01002ea <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c01002c1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002c5:	74 06                	je     c01002cd <readline+0x95>
c01002c7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002cb:	75 93                	jne    c0100260 <readline+0x28>
            cputchar(c);
c01002cd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002d0:	89 04 24             	mov    %eax,(%esp)
c01002d3:	e8 97 00 00 00       	call   c010036f <cputchar>
            buf[i] = '\0';
c01002d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002db:	05 60 8a 11 c0       	add    $0xc0118a60,%eax
c01002e0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002e3:	b8 60 8a 11 c0       	mov    $0xc0118a60,%eax
c01002e8:	eb 05                	jmp    c01002ef <readline+0xb7>
        }
    }
c01002ea:	e9 71 ff ff ff       	jmp    c0100260 <readline+0x28>
}
c01002ef:	c9                   	leave  
c01002f0:	c3                   	ret    
c01002f1:	00 00                	add    %al,(%eax)
	...

c01002f4 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c01002f4:	55                   	push   %ebp
c01002f5:	89 e5                	mov    %esp,%ebp
c01002f7:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c01002fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01002fd:	89 04 24             	mov    %eax,(%esp)
c0100300:	e8 83 13 00 00       	call   c0101688 <cons_putc>
    (*cnt) ++;
c0100305:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100308:	8b 00                	mov    (%eax),%eax
c010030a:	8d 50 01             	lea    0x1(%eax),%edx
c010030d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100310:	89 10                	mov    %edx,(%eax)
}
c0100312:	c9                   	leave  
c0100313:	c3                   	ret    

c0100314 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100314:	55                   	push   %ebp
c0100315:	89 e5                	mov    %esp,%ebp
c0100317:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010031a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100321:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100324:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100328:	8b 45 08             	mov    0x8(%ebp),%eax
c010032b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010032f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100332:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100336:	c7 04 24 f4 02 10 c0 	movl   $0xc01002f4,(%esp)
c010033d:	e8 88 55 00 00       	call   c01058ca <vprintfmt>
    return cnt;
c0100342:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100345:	c9                   	leave  
c0100346:	c3                   	ret    

c0100347 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100347:	55                   	push   %ebp
c0100348:	89 e5                	mov    %esp,%ebp
c010034a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010034d:	8d 55 0c             	lea    0xc(%ebp),%edx
c0100350:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100353:	89 10                	mov    %edx,(%eax)
    cnt = vcprintf(fmt, ap);
c0100355:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100358:	89 44 24 04          	mov    %eax,0x4(%esp)
c010035c:	8b 45 08             	mov    0x8(%ebp),%eax
c010035f:	89 04 24             	mov    %eax,(%esp)
c0100362:	e8 ad ff ff ff       	call   c0100314 <vcprintf>
c0100367:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010036a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010036d:	c9                   	leave  
c010036e:	c3                   	ret    

c010036f <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010036f:	55                   	push   %ebp
c0100370:	89 e5                	mov    %esp,%ebp
c0100372:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100375:	8b 45 08             	mov    0x8(%ebp),%eax
c0100378:	89 04 24             	mov    %eax,(%esp)
c010037b:	e8 08 13 00 00       	call   c0101688 <cons_putc>
}
c0100380:	c9                   	leave  
c0100381:	c3                   	ret    

c0100382 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100382:	55                   	push   %ebp
c0100383:	89 e5                	mov    %esp,%ebp
c0100385:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100388:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010038f:	eb 13                	jmp    c01003a4 <cputs+0x22>
        cputch(c, &cnt);
c0100391:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0100395:	8d 55 f0             	lea    -0x10(%ebp),%edx
c0100398:	89 54 24 04          	mov    %edx,0x4(%esp)
c010039c:	89 04 24             	mov    %eax,(%esp)
c010039f:	e8 50 ff ff ff       	call   c01002f4 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01003a7:	0f b6 00             	movzbl (%eax),%eax
c01003aa:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003ad:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003b1:	0f 95 c0             	setne  %al
c01003b4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01003b8:	84 c0                	test   %al,%al
c01003ba:	75 d5                	jne    c0100391 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003bc:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003c3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003ca:	e8 25 ff ff ff       	call   c01002f4 <cputch>
    return cnt;
c01003cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003d2:	c9                   	leave  
c01003d3:	c3                   	ret    

c01003d4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003d4:	55                   	push   %ebp
c01003d5:	89 e5                	mov    %esp,%ebp
c01003d7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003da:	e8 e5 12 00 00       	call   c01016c4 <cons_getc>
c01003df:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003e6:	74 f2                	je     c01003da <getchar+0x6>
        /* do nothing */;
    return c;
c01003e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003eb:	c9                   	leave  
c01003ec:	c3                   	ret    
c01003ed:	00 00                	add    %al,(%eax)
	...

c01003f0 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c01003f0:	55                   	push   %ebp
c01003f1:	89 e5                	mov    %esp,%ebp
c01003f3:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c01003f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01003f9:	8b 00                	mov    (%eax),%eax
c01003fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01003fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0100401:	8b 00                	mov    (%eax),%eax
c0100403:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100406:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010040d:	e9 c6 00 00 00       	jmp    c01004d8 <stab_binsearch+0xe8>
        int true_m = (l + r) / 2, m = true_m;
c0100412:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100415:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100418:	01 d0                	add    %edx,%eax
c010041a:	89 c2                	mov    %eax,%edx
c010041c:	c1 ea 1f             	shr    $0x1f,%edx
c010041f:	01 d0                	add    %edx,%eax
c0100421:	d1 f8                	sar    %eax
c0100423:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100426:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100429:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010042c:	eb 04                	jmp    c0100432 <stab_binsearch+0x42>
            m --;
c010042e:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100432:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100435:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100438:	7c 1b                	jl     c0100455 <stab_binsearch+0x65>
c010043a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010043d:	89 d0                	mov    %edx,%eax
c010043f:	01 c0                	add    %eax,%eax
c0100441:	01 d0                	add    %edx,%eax
c0100443:	c1 e0 02             	shl    $0x2,%eax
c0100446:	03 45 08             	add    0x8(%ebp),%eax
c0100449:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010044d:	0f b6 c0             	movzbl %al,%eax
c0100450:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100453:	75 d9                	jne    c010042e <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100455:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100458:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010045b:	7d 0b                	jge    c0100468 <stab_binsearch+0x78>
            l = true_m + 1;
c010045d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100460:	83 c0 01             	add    $0x1,%eax
c0100463:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100466:	eb 70                	jmp    c01004d8 <stab_binsearch+0xe8>
        }

        // actual binary search
        any_matches = 1;
c0100468:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010046f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100472:	89 d0                	mov    %edx,%eax
c0100474:	01 c0                	add    %eax,%eax
c0100476:	01 d0                	add    %edx,%eax
c0100478:	c1 e0 02             	shl    $0x2,%eax
c010047b:	03 45 08             	add    0x8(%ebp),%eax
c010047e:	8b 40 08             	mov    0x8(%eax),%eax
c0100481:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100484:	73 13                	jae    c0100499 <stab_binsearch+0xa9>
            *region_left = m;
c0100486:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100489:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010048e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100491:	83 c0 01             	add    $0x1,%eax
c0100494:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100497:	eb 3f                	jmp    c01004d8 <stab_binsearch+0xe8>
        } else if (stabs[m].n_value > addr) {
c0100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049c:	89 d0                	mov    %edx,%eax
c010049e:	01 c0                	add    %eax,%eax
c01004a0:	01 d0                	add    %edx,%eax
c01004a2:	c1 e0 02             	shl    $0x2,%eax
c01004a5:	03 45 08             	add    0x8(%ebp),%eax
c01004a8:	8b 40 08             	mov    0x8(%eax),%eax
c01004ab:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004ae:	76 16                	jbe    c01004c6 <stab_binsearch+0xd6>
            *region_right = m - 1;
c01004b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004b3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004b6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004b9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004be:	83 e8 01             	sub    $0x1,%eax
c01004c1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004c4:	eb 12                	jmp    c01004d8 <stab_binsearch+0xe8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004c6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004cc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004d4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004d8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004db:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004de:	0f 8e 2e ff ff ff    	jle    c0100412 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004e4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004e8:	75 0f                	jne    c01004f9 <stab_binsearch+0x109>
        *region_right = *region_left - 1;
c01004ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004ed:	8b 00                	mov    (%eax),%eax
c01004ef:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01004f5:	89 10                	mov    %edx,(%eax)
c01004f7:	eb 3b                	jmp    c0100534 <stab_binsearch+0x144>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c01004f9:	8b 45 10             	mov    0x10(%ebp),%eax
c01004fc:	8b 00                	mov    (%eax),%eax
c01004fe:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100501:	eb 04                	jmp    c0100507 <stab_binsearch+0x117>
c0100503:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100507:	8b 45 0c             	mov    0xc(%ebp),%eax
c010050a:	8b 00                	mov    (%eax),%eax
c010050c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010050f:	7d 1b                	jge    c010052c <stab_binsearch+0x13c>
c0100511:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100514:	89 d0                	mov    %edx,%eax
c0100516:	01 c0                	add    %eax,%eax
c0100518:	01 d0                	add    %edx,%eax
c010051a:	c1 e0 02             	shl    $0x2,%eax
c010051d:	03 45 08             	add    0x8(%ebp),%eax
c0100520:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100524:	0f b6 c0             	movzbl %al,%eax
c0100527:	3b 45 14             	cmp    0x14(%ebp),%eax
c010052a:	75 d7                	jne    c0100503 <stab_binsearch+0x113>
            /* do nothing */;
        *region_left = l;
c010052c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010052f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100532:	89 10                	mov    %edx,(%eax)
    }
}
c0100534:	c9                   	leave  
c0100535:	c3                   	ret    

c0100536 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100536:	55                   	push   %ebp
c0100537:	89 e5                	mov    %esp,%ebp
c0100539:	53                   	push   %ebx
c010053a:	83 ec 54             	sub    $0x54,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010053d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100540:	c7 00 2c 63 10 c0    	movl   $0xc010632c,(%eax)
    info->eip_line = 0;
c0100546:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100549:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100550:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100553:	c7 40 08 2c 63 10 c0 	movl   $0xc010632c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010055a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010055d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100564:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100567:	8b 55 08             	mov    0x8(%ebp),%edx
c010056a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010056d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100570:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100577:	c7 45 f4 70 75 10 c0 	movl   $0xc0107570,-0xc(%ebp)
    stab_end = __STAB_END__;
c010057e:	c7 45 f0 1c 26 11 c0 	movl   $0xc011261c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100585:	c7 45 ec 1d 26 11 c0 	movl   $0xc011261d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010058c:	c7 45 e8 53 50 11 c0 	movl   $0xc0115053,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c0100593:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100596:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0100599:	76 0d                	jbe    c01005a8 <debuginfo_eip+0x72>
c010059b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010059e:	83 e8 01             	sub    $0x1,%eax
c01005a1:	0f b6 00             	movzbl (%eax),%eax
c01005a4:	84 c0                	test   %al,%al
c01005a6:	74 0a                	je     c01005b2 <debuginfo_eip+0x7c>
        return -1;
c01005a8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005ad:	e9 9e 02 00 00       	jmp    c0100850 <debuginfo_eip+0x31a>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005b2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005b9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005bc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005bf:	89 d1                	mov    %edx,%ecx
c01005c1:	29 c1                	sub    %eax,%ecx
c01005c3:	89 c8                	mov    %ecx,%eax
c01005c5:	c1 f8 02             	sar    $0x2,%eax
c01005c8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005ce:	83 e8 01             	sub    $0x1,%eax
c01005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01005d7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005db:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005e2:	00 
c01005e3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005e6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005ea:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005ed:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005f4:	89 04 24             	mov    %eax,(%esp)
c01005f7:	e8 f4 fd ff ff       	call   c01003f0 <stab_binsearch>
    if (lfile == 0)
c01005fc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005ff:	85 c0                	test   %eax,%eax
c0100601:	75 0a                	jne    c010060d <debuginfo_eip+0xd7>
        return -1;
c0100603:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100608:	e9 43 02 00 00       	jmp    c0100850 <debuginfo_eip+0x31a>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010060d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100610:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100613:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100616:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100619:	8b 45 08             	mov    0x8(%ebp),%eax
c010061c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100620:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100627:	00 
c0100628:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010062b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010062f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100632:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100636:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100639:	89 04 24             	mov    %eax,(%esp)
c010063c:	e8 af fd ff ff       	call   c01003f0 <stab_binsearch>

    if (lfun <= rfun) {
c0100641:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100644:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100647:	39 c2                	cmp    %eax,%edx
c0100649:	7f 72                	jg     c01006bd <debuginfo_eip+0x187>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010064b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010064e:	89 c2                	mov    %eax,%edx
c0100650:	89 d0                	mov    %edx,%eax
c0100652:	01 c0                	add    %eax,%eax
c0100654:	01 d0                	add    %edx,%eax
c0100656:	c1 e0 02             	shl    $0x2,%eax
c0100659:	03 45 f4             	add    -0xc(%ebp),%eax
c010065c:	8b 10                	mov    (%eax),%edx
c010065e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100661:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100664:	89 cb                	mov    %ecx,%ebx
c0100666:	29 c3                	sub    %eax,%ebx
c0100668:	89 d8                	mov    %ebx,%eax
c010066a:	39 c2                	cmp    %eax,%edx
c010066c:	73 1e                	jae    c010068c <debuginfo_eip+0x156>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010066e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100671:	89 c2                	mov    %eax,%edx
c0100673:	89 d0                	mov    %edx,%eax
c0100675:	01 c0                	add    %eax,%eax
c0100677:	01 d0                	add    %edx,%eax
c0100679:	c1 e0 02             	shl    $0x2,%eax
c010067c:	03 45 f4             	add    -0xc(%ebp),%eax
c010067f:	8b 00                	mov    (%eax),%eax
c0100681:	89 c2                	mov    %eax,%edx
c0100683:	03 55 ec             	add    -0x14(%ebp),%edx
c0100686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100689:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010068c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010068f:	89 c2                	mov    %eax,%edx
c0100691:	89 d0                	mov    %edx,%eax
c0100693:	01 c0                	add    %eax,%eax
c0100695:	01 d0                	add    %edx,%eax
c0100697:	c1 e0 02             	shl    $0x2,%eax
c010069a:	03 45 f4             	add    -0xc(%ebp),%eax
c010069d:	8b 50 08             	mov    0x8(%eax),%edx
c01006a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a9:	8b 40 10             	mov    0x10(%eax),%eax
c01006ac:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006af:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006b2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006b8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006bb:	eb 15                	jmp    c01006d2 <debuginfo_eip+0x19c>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c0:	8b 55 08             	mov    0x8(%ebp),%edx
c01006c3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006c9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d5:	8b 40 08             	mov    0x8(%eax),%eax
c01006d8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006df:	00 
c01006e0:	89 04 24             	mov    %eax,(%esp)
c01006e3:	e8 57 58 00 00       	call   c0105f3f <strfind>
c01006e8:	89 c2                	mov    %eax,%edx
c01006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ed:	8b 40 08             	mov    0x8(%eax),%eax
c01006f0:	29 c2                	sub    %eax,%edx
c01006f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006f5:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c01006f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01006fb:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006ff:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100706:	00 
c0100707:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010070a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010070e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100711:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100715:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100718:	89 04 24             	mov    %eax,(%esp)
c010071b:	e8 d0 fc ff ff       	call   c01003f0 <stab_binsearch>
    if (lline <= rline) {
c0100720:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100723:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100726:	39 c2                	cmp    %eax,%edx
c0100728:	7f 20                	jg     c010074a <debuginfo_eip+0x214>
        info->eip_line = stabs[rline].n_desc;
c010072a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010072d:	89 c2                	mov    %eax,%edx
c010072f:	89 d0                	mov    %edx,%eax
c0100731:	01 c0                	add    %eax,%eax
c0100733:	01 d0                	add    %edx,%eax
c0100735:	c1 e0 02             	shl    $0x2,%eax
c0100738:	03 45 f4             	add    -0xc(%ebp),%eax
c010073b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010073f:	0f b7 d0             	movzwl %ax,%edx
c0100742:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100745:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100748:	eb 13                	jmp    c010075d <debuginfo_eip+0x227>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010074a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010074f:	e9 fc 00 00 00       	jmp    c0100850 <debuginfo_eip+0x31a>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100754:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100757:	83 e8 01             	sub    $0x1,%eax
c010075a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010075d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100760:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100763:	39 c2                	cmp    %eax,%edx
c0100765:	7c 4a                	jl     c01007b1 <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
c0100767:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076a:	89 c2                	mov    %eax,%edx
c010076c:	89 d0                	mov    %edx,%eax
c010076e:	01 c0                	add    %eax,%eax
c0100770:	01 d0                	add    %edx,%eax
c0100772:	c1 e0 02             	shl    $0x2,%eax
c0100775:	03 45 f4             	add    -0xc(%ebp),%eax
c0100778:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010077c:	3c 84                	cmp    $0x84,%al
c010077e:	74 31                	je     c01007b1 <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100783:	89 c2                	mov    %eax,%edx
c0100785:	89 d0                	mov    %edx,%eax
c0100787:	01 c0                	add    %eax,%eax
c0100789:	01 d0                	add    %edx,%eax
c010078b:	c1 e0 02             	shl    $0x2,%eax
c010078e:	03 45 f4             	add    -0xc(%ebp),%eax
c0100791:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100795:	3c 64                	cmp    $0x64,%al
c0100797:	75 bb                	jne    c0100754 <debuginfo_eip+0x21e>
c0100799:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079c:	89 c2                	mov    %eax,%edx
c010079e:	89 d0                	mov    %edx,%eax
c01007a0:	01 c0                	add    %eax,%eax
c01007a2:	01 d0                	add    %edx,%eax
c01007a4:	c1 e0 02             	shl    $0x2,%eax
c01007a7:	03 45 f4             	add    -0xc(%ebp),%eax
c01007aa:	8b 40 08             	mov    0x8(%eax),%eax
c01007ad:	85 c0                	test   %eax,%eax
c01007af:	74 a3                	je     c0100754 <debuginfo_eip+0x21e>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007b1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007b7:	39 c2                	cmp    %eax,%edx
c01007b9:	7c 40                	jl     c01007fb <debuginfo_eip+0x2c5>
c01007bb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007be:	89 c2                	mov    %eax,%edx
c01007c0:	89 d0                	mov    %edx,%eax
c01007c2:	01 c0                	add    %eax,%eax
c01007c4:	01 d0                	add    %edx,%eax
c01007c6:	c1 e0 02             	shl    $0x2,%eax
c01007c9:	03 45 f4             	add    -0xc(%ebp),%eax
c01007cc:	8b 10                	mov    (%eax),%edx
c01007ce:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007d4:	89 cb                	mov    %ecx,%ebx
c01007d6:	29 c3                	sub    %eax,%ebx
c01007d8:	89 d8                	mov    %ebx,%eax
c01007da:	39 c2                	cmp    %eax,%edx
c01007dc:	73 1d                	jae    c01007fb <debuginfo_eip+0x2c5>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007de:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007e1:	89 c2                	mov    %eax,%edx
c01007e3:	89 d0                	mov    %edx,%eax
c01007e5:	01 c0                	add    %eax,%eax
c01007e7:	01 d0                	add    %edx,%eax
c01007e9:	c1 e0 02             	shl    $0x2,%eax
c01007ec:	03 45 f4             	add    -0xc(%ebp),%eax
c01007ef:	8b 00                	mov    (%eax),%eax
c01007f1:	89 c2                	mov    %eax,%edx
c01007f3:	03 55 ec             	add    -0x14(%ebp),%edx
c01007f6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007f9:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c01007fb:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01007fe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100801:	39 c2                	cmp    %eax,%edx
c0100803:	7d 46                	jge    c010084b <debuginfo_eip+0x315>
        for (lline = lfun + 1;
c0100805:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100808:	83 c0 01             	add    $0x1,%eax
c010080b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010080e:	eb 18                	jmp    c0100828 <debuginfo_eip+0x2f2>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100810:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100813:	8b 40 14             	mov    0x14(%eax),%eax
c0100816:	8d 50 01             	lea    0x1(%eax),%edx
c0100819:	8b 45 0c             	mov    0xc(%ebp),%eax
c010081c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c010081f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100822:	83 c0 01             	add    $0x1,%eax
c0100825:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100828:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010082b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010082e:	39 c2                	cmp    %eax,%edx
c0100830:	7d 19                	jge    c010084b <debuginfo_eip+0x315>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100832:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100835:	89 c2                	mov    %eax,%edx
c0100837:	89 d0                	mov    %edx,%eax
c0100839:	01 c0                	add    %eax,%eax
c010083b:	01 d0                	add    %edx,%eax
c010083d:	c1 e0 02             	shl    $0x2,%eax
c0100840:	03 45 f4             	add    -0xc(%ebp),%eax
c0100843:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100847:	3c a0                	cmp    $0xa0,%al
c0100849:	74 c5                	je     c0100810 <debuginfo_eip+0x2da>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c010084b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100850:	83 c4 54             	add    $0x54,%esp
c0100853:	5b                   	pop    %ebx
c0100854:	5d                   	pop    %ebp
c0100855:	c3                   	ret    

c0100856 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100856:	55                   	push   %ebp
c0100857:	89 e5                	mov    %esp,%ebp
c0100859:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010085c:	c7 04 24 36 63 10 c0 	movl   $0xc0106336,(%esp)
c0100863:	e8 df fa ff ff       	call   c0100347 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100868:	c7 44 24 04 2c 00 10 	movl   $0xc010002c,0x4(%esp)
c010086f:	c0 
c0100870:	c7 04 24 4f 63 10 c0 	movl   $0xc010634f,(%esp)
c0100877:	e8 cb fa ff ff       	call   c0100347 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010087c:	c7 44 24 04 7f 62 10 	movl   $0xc010627f,0x4(%esp)
c0100883:	c0 
c0100884:	c7 04 24 67 63 10 c0 	movl   $0xc0106367,(%esp)
c010088b:	e8 b7 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c0100890:	c7 44 24 04 38 8a 11 	movl   $0xc0118a38,0x4(%esp)
c0100897:	c0 
c0100898:	c7 04 24 7f 63 10 c0 	movl   $0xc010637f,(%esp)
c010089f:	e8 a3 fa ff ff       	call   c0100347 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008a4:	c7 44 24 04 68 99 11 	movl   $0xc0119968,0x4(%esp)
c01008ab:	c0 
c01008ac:	c7 04 24 97 63 10 c0 	movl   $0xc0106397,(%esp)
c01008b3:	e8 8f fa ff ff       	call   c0100347 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008b8:	b8 68 99 11 c0       	mov    $0xc0119968,%eax
c01008bd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008c3:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c01008c8:	89 d1                	mov    %edx,%ecx
c01008ca:	29 c1                	sub    %eax,%ecx
c01008cc:	89 c8                	mov    %ecx,%eax
c01008ce:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008d4:	85 c0                	test   %eax,%eax
c01008d6:	0f 48 c2             	cmovs  %edx,%eax
c01008d9:	c1 f8 0a             	sar    $0xa,%eax
c01008dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008e0:	c7 04 24 b0 63 10 c0 	movl   $0xc01063b0,(%esp)
c01008e7:	e8 5b fa ff ff       	call   c0100347 <cprintf>
}
c01008ec:	c9                   	leave  
c01008ed:	c3                   	ret    

c01008ee <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01008ee:	55                   	push   %ebp
c01008ef:	89 e5                	mov    %esp,%ebp
c01008f1:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c01008f7:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01008fa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0100901:	89 04 24             	mov    %eax,(%esp)
c0100904:	e8 2d fc ff ff       	call   c0100536 <debuginfo_eip>
c0100909:	85 c0                	test   %eax,%eax
c010090b:	74 15                	je     c0100922 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010090d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100910:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100914:	c7 04 24 da 63 10 c0 	movl   $0xc01063da,(%esp)
c010091b:	e8 27 fa ff ff       	call   c0100347 <cprintf>
c0100920:	eb 69                	jmp    c010098b <print_debuginfo+0x9d>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100922:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100929:	eb 1a                	jmp    c0100945 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
c010092b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010092e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100931:	01 d0                	add    %edx,%eax
c0100933:	0f b6 10             	movzbl (%eax),%edx
c0100936:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c010093c:	03 45 f4             	add    -0xc(%ebp),%eax
c010093f:	88 10                	mov    %dl,(%eax)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100941:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100945:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100948:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010094b:	7f de                	jg     c010092b <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010094d:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c0100953:	03 45 f4             	add    -0xc(%ebp),%eax
c0100956:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100959:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010095c:	8b 55 08             	mov    0x8(%ebp),%edx
c010095f:	89 d1                	mov    %edx,%ecx
c0100961:	29 c1                	sub    %eax,%ecx
c0100963:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100966:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100969:	89 4c 24 10          	mov    %ecx,0x10(%esp)
                fnname, eip - info.eip_fn_addr);
c010096d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100973:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100977:	89 54 24 08          	mov    %edx,0x8(%esp)
c010097b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010097f:	c7 04 24 f6 63 10 c0 	movl   $0xc01063f6,(%esp)
c0100986:	e8 bc f9 ff ff       	call   c0100347 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c010098b:	c9                   	leave  
c010098c:	c3                   	ret    

c010098d <read_eip>:

static __noinline uint32_t
read_eip(void) {
c010098d:	55                   	push   %ebp
c010098e:	89 e5                	mov    %esp,%ebp
c0100990:	53                   	push   %ebx
c0100991:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100994:	8b 5d 04             	mov    0x4(%ebp),%ebx
c0100997:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return eip;
c010099a:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010099d:	83 c4 10             	add    $0x10,%esp
c01009a0:	5b                   	pop    %ebx
c01009a1:	5d                   	pop    %ebp
c01009a2:	c3                   	ret    

c01009a3 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009a3:	55                   	push   %ebp
c01009a4:	89 e5                	mov    %esp,%ebp
c01009a6:	53                   	push   %ebx
c01009a7:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009aa:	89 eb                	mov    %ebp,%ebx
c01009ac:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    return ebp;
c01009af:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009b5:	e8 d3 ff ff ff       	call   c010098d <read_eip>
c01009ba:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009bd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009c4:	e9 82 00 00 00       	jmp    c0100a4b <print_stackframe+0xa8>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009cc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009d3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009d7:	c7 04 24 08 64 10 c0 	movl   $0xc0106408,(%esp)
c01009de:	e8 64 f9 ff ff       	call   c0100347 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c01009e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e6:	83 c0 08             	add    $0x8,%eax
c01009e9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c01009ec:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01009f3:	eb 1f                	jmp    c0100a14 <print_stackframe+0x71>
            cprintf("0x%08x ", args[j]);
c01009f5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01009f8:	c1 e0 02             	shl    $0x2,%eax
c01009fb:	03 45 e4             	add    -0x1c(%ebp),%eax
c01009fe:	8b 00                	mov    (%eax),%eax
c0100a00:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a04:	c7 04 24 24 64 10 c0 	movl   $0xc0106424,(%esp)
c0100a0b:	e8 37 f9 ff ff       	call   c0100347 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a10:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a14:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a18:	7e db                	jle    c01009f5 <print_stackframe+0x52>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a1a:	c7 04 24 2c 64 10 c0 	movl   $0xc010642c,(%esp)
c0100a21:	e8 21 f9 ff ff       	call   c0100347 <cprintf>
        print_debuginfo(eip - 1);
c0100a26:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a29:	83 e8 01             	sub    $0x1,%eax
c0100a2c:	89 04 24             	mov    %eax,(%esp)
c0100a2f:	e8 ba fe ff ff       	call   c01008ee <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a37:	83 c0 04             	add    $0x4,%eax
c0100a3a:	8b 00                	mov    (%eax),%eax
c0100a3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a42:	8b 00                	mov    (%eax),%eax
c0100a44:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a47:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a4b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a4f:	74 0a                	je     c0100a5b <print_stackframe+0xb8>
c0100a51:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a55:	0f 8e 6e ff ff ff    	jle    c01009c9 <print_stackframe+0x26>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a5b:	83 c4 34             	add    $0x34,%esp
c0100a5e:	5b                   	pop    %ebx
c0100a5f:	5d                   	pop    %ebp
c0100a60:	c3                   	ret    
c0100a61:	00 00                	add    %al,(%eax)
	...

c0100a64 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a64:	55                   	push   %ebp
c0100a65:	89 e5                	mov    %esp,%ebp
c0100a67:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a6a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a71:	eb 0d                	jmp    c0100a80 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
c0100a73:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a74:	eb 0a                	jmp    c0100a80 <parse+0x1c>
            *buf ++ = '\0';
c0100a76:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a79:	c6 00 00             	movb   $0x0,(%eax)
c0100a7c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a80:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a83:	0f b6 00             	movzbl (%eax),%eax
c0100a86:	84 c0                	test   %al,%al
c0100a88:	74 1d                	je     c0100aa7 <parse+0x43>
c0100a8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a8d:	0f b6 00             	movzbl (%eax),%eax
c0100a90:	0f be c0             	movsbl %al,%eax
c0100a93:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a97:	c7 04 24 b0 64 10 c0 	movl   $0xc01064b0,(%esp)
c0100a9e:	e8 69 54 00 00       	call   c0105f0c <strchr>
c0100aa3:	85 c0                	test   %eax,%eax
c0100aa5:	75 cf                	jne    c0100a76 <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100aa7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aaa:	0f b6 00             	movzbl (%eax),%eax
c0100aad:	84 c0                	test   %al,%al
c0100aaf:	74 5e                	je     c0100b0f <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ab1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ab5:	75 14                	jne    c0100acb <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ab7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100abe:	00 
c0100abf:	c7 04 24 b5 64 10 c0 	movl   $0xc01064b5,(%esp)
c0100ac6:	e8 7c f8 ff ff       	call   c0100347 <cprintf>
        }
        argv[argc ++] = buf;
c0100acb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ace:	c1 e0 02             	shl    $0x2,%eax
c0100ad1:	03 45 0c             	add    0xc(%ebp),%eax
c0100ad4:	8b 55 08             	mov    0x8(%ebp),%edx
c0100ad7:	89 10                	mov    %edx,(%eax)
c0100ad9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100add:	eb 04                	jmp    c0100ae3 <parse+0x7f>
            buf ++;
c0100adf:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100ae3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ae6:	0f b6 00             	movzbl (%eax),%eax
c0100ae9:	84 c0                	test   %al,%al
c0100aeb:	74 86                	je     c0100a73 <parse+0xf>
c0100aed:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af0:	0f b6 00             	movzbl (%eax),%eax
c0100af3:	0f be c0             	movsbl %al,%eax
c0100af6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100afa:	c7 04 24 b0 64 10 c0 	movl   $0xc01064b0,(%esp)
c0100b01:	e8 06 54 00 00       	call   c0105f0c <strchr>
c0100b06:	85 c0                	test   %eax,%eax
c0100b08:	74 d5                	je     c0100adf <parse+0x7b>
            buf ++;
        }
    }
c0100b0a:	e9 64 ff ff ff       	jmp    c0100a73 <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100b0f:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b10:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b13:	c9                   	leave  
c0100b14:	c3                   	ret    

c0100b15 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b15:	55                   	push   %ebp
c0100b16:	89 e5                	mov    %esp,%ebp
c0100b18:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b1b:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b22:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b25:	89 04 24             	mov    %eax,(%esp)
c0100b28:	e8 37 ff ff ff       	call   c0100a64 <parse>
c0100b2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b34:	75 0a                	jne    c0100b40 <runcmd+0x2b>
        return 0;
c0100b36:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b3b:	e9 85 00 00 00       	jmp    c0100bc5 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b40:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b47:	eb 5c                	jmp    c0100ba5 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b49:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b4c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b4f:	89 d0                	mov    %edx,%eax
c0100b51:	01 c0                	add    %eax,%eax
c0100b53:	01 d0                	add    %edx,%eax
c0100b55:	c1 e0 02             	shl    $0x2,%eax
c0100b58:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100b5d:	8b 00                	mov    (%eax),%eax
c0100b5f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b63:	89 04 24             	mov    %eax,(%esp)
c0100b66:	e8 fc 52 00 00       	call   c0105e67 <strcmp>
c0100b6b:	85 c0                	test   %eax,%eax
c0100b6d:	75 32                	jne    c0100ba1 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b6f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b72:	89 d0                	mov    %edx,%eax
c0100b74:	01 c0                	add    %eax,%eax
c0100b76:	01 d0                	add    %edx,%eax
c0100b78:	c1 e0 02             	shl    $0x2,%eax
c0100b7b:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100b80:	8b 50 08             	mov    0x8(%eax),%edx
c0100b83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b86:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0100b89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b8c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100b90:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b93:	83 c0 04             	add    $0x4,%eax
c0100b96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b9a:	89 0c 24             	mov    %ecx,(%esp)
c0100b9d:	ff d2                	call   *%edx
c0100b9f:	eb 24                	jmp    c0100bc5 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100ba1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ba8:	83 f8 02             	cmp    $0x2,%eax
c0100bab:	76 9c                	jbe    c0100b49 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bad:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bb0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bb4:	c7 04 24 d3 64 10 c0 	movl   $0xc01064d3,(%esp)
c0100bbb:	e8 87 f7 ff ff       	call   c0100347 <cprintf>
    return 0;
c0100bc0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bc5:	c9                   	leave  
c0100bc6:	c3                   	ret    

c0100bc7 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bc7:	55                   	push   %ebp
c0100bc8:	89 e5                	mov    %esp,%ebp
c0100bca:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bcd:	c7 04 24 ec 64 10 c0 	movl   $0xc01064ec,(%esp)
c0100bd4:	e8 6e f7 ff ff       	call   c0100347 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bd9:	c7 04 24 14 65 10 c0 	movl   $0xc0106514,(%esp)
c0100be0:	e8 62 f7 ff ff       	call   c0100347 <cprintf>

    if (tf != NULL) {
c0100be5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100be9:	74 0e                	je     c0100bf9 <kmonitor+0x32>
        print_trapframe(tf);
c0100beb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bee:	89 04 24             	mov    %eax,(%esp)
c0100bf1:	e8 e6 0e 00 00       	call   c0101adc <print_trapframe>
c0100bf6:	eb 01                	jmp    c0100bf9 <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
c0100bf8:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100bf9:	c7 04 24 39 65 10 c0 	movl   $0xc0106539,(%esp)
c0100c00:	e8 33 f6 ff ff       	call   c0100238 <readline>
c0100c05:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c08:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c0c:	74 ea                	je     c0100bf8 <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
c0100c0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c18:	89 04 24             	mov    %eax,(%esp)
c0100c1b:	e8 f5 fe ff ff       	call   c0100b15 <runcmd>
c0100c20:	85 c0                	test   %eax,%eax
c0100c22:	79 d4                	jns    c0100bf8 <kmonitor+0x31>
                break;
c0100c24:	90                   	nop
            }
        }
    }
}
c0100c25:	c9                   	leave  
c0100c26:	c3                   	ret    

c0100c27 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c27:	55                   	push   %ebp
c0100c28:	89 e5                	mov    %esp,%ebp
c0100c2a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c2d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c34:	eb 3f                	jmp    c0100c75 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c36:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c39:	89 d0                	mov    %edx,%eax
c0100c3b:	01 c0                	add    %eax,%eax
c0100c3d:	01 d0                	add    %edx,%eax
c0100c3f:	c1 e0 02             	shl    $0x2,%eax
c0100c42:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100c47:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c4a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c4d:	89 d0                	mov    %edx,%eax
c0100c4f:	01 c0                	add    %eax,%eax
c0100c51:	01 d0                	add    %edx,%eax
c0100c53:	c1 e0 02             	shl    $0x2,%eax
c0100c56:	05 20 80 11 c0       	add    $0xc0118020,%eax
c0100c5b:	8b 00                	mov    (%eax),%eax
c0100c5d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c61:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c65:	c7 04 24 3d 65 10 c0 	movl   $0xc010653d,(%esp)
c0100c6c:	e8 d6 f6 ff ff       	call   c0100347 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c71:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c78:	83 f8 02             	cmp    $0x2,%eax
c0100c7b:	76 b9                	jbe    c0100c36 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c7d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c82:	c9                   	leave  
c0100c83:	c3                   	ret    

c0100c84 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c84:	55                   	push   %ebp
c0100c85:	89 e5                	mov    %esp,%ebp
c0100c87:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c8a:	e8 c7 fb ff ff       	call   c0100856 <print_kerninfo>
    return 0;
c0100c8f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c94:	c9                   	leave  
c0100c95:	c3                   	ret    

c0100c96 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100c96:	55                   	push   %ebp
c0100c97:	89 e5                	mov    %esp,%ebp
c0100c99:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100c9c:	e8 02 fd ff ff       	call   c01009a3 <print_stackframe>
    return 0;
c0100ca1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca6:	c9                   	leave  
c0100ca7:	c3                   	ret    

c0100ca8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100ca8:	55                   	push   %ebp
c0100ca9:	89 e5                	mov    %esp,%ebp
c0100cab:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cae:	a1 60 8e 11 c0       	mov    0xc0118e60,%eax
c0100cb3:	85 c0                	test   %eax,%eax
c0100cb5:	75 4c                	jne    c0100d03 <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
c0100cb7:	c7 05 60 8e 11 c0 01 	movl   $0x1,0xc0118e60
c0100cbe:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cc1:	8d 55 14             	lea    0x14(%ebp),%edx
c0100cc4:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100cc7:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ccc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cd3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cd7:	c7 04 24 46 65 10 c0 	movl   $0xc0106546,(%esp)
c0100cde:	e8 64 f6 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100ce3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ce6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cea:	8b 45 10             	mov    0x10(%ebp),%eax
c0100ced:	89 04 24             	mov    %eax,(%esp)
c0100cf0:	e8 1f f6 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100cf5:	c7 04 24 62 65 10 c0 	movl   $0xc0106562,(%esp)
c0100cfc:	e8 46 f6 ff ff       	call   c0100347 <cprintf>
c0100d01:	eb 01                	jmp    c0100d04 <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100d03:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100d04:	e8 31 0a 00 00       	call   c010173a <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d09:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d10:	e8 b2 fe ff ff       	call   c0100bc7 <kmonitor>
    }
c0100d15:	eb f2                	jmp    c0100d09 <__panic+0x61>

c0100d17 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d17:	55                   	push   %ebp
c0100d18:	89 e5                	mov    %esp,%ebp
c0100d1a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d1d:	8d 55 14             	lea    0x14(%ebp),%edx
c0100d20:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100d23:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d28:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d2c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d2f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d33:	c7 04 24 64 65 10 c0 	movl   $0xc0106564,(%esp)
c0100d3a:	e8 08 f6 ff ff       	call   c0100347 <cprintf>
    vcprintf(fmt, ap);
c0100d3f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d42:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d46:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d49:	89 04 24             	mov    %eax,(%esp)
c0100d4c:	e8 c3 f5 ff ff       	call   c0100314 <vcprintf>
    cprintf("\n");
c0100d51:	c7 04 24 62 65 10 c0 	movl   $0xc0106562,(%esp)
c0100d58:	e8 ea f5 ff ff       	call   c0100347 <cprintf>
    va_end(ap);
}
c0100d5d:	c9                   	leave  
c0100d5e:	c3                   	ret    

c0100d5f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d5f:	55                   	push   %ebp
c0100d60:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d62:	a1 60 8e 11 c0       	mov    0xc0118e60,%eax
}
c0100d67:	5d                   	pop    %ebp
c0100d68:	c3                   	ret    
c0100d69:	00 00                	add    %al,(%eax)
	...

c0100d6c <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d6c:	55                   	push   %ebp
c0100d6d:	89 e5                	mov    %esp,%ebp
c0100d6f:	83 ec 28             	sub    $0x28,%esp
c0100d72:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d78:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d7c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d80:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d84:	ee                   	out    %al,(%dx)
c0100d85:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d8b:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d8f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100d93:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100d97:	ee                   	out    %al,(%dx)
c0100d98:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100d9e:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100da2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100da6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100daa:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dab:	c7 05 4c 99 11 c0 00 	movl   $0x0,0xc011994c
c0100db2:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100db5:	c7 04 24 82 65 10 c0 	movl   $0xc0106582,(%esp)
c0100dbc:	e8 86 f5 ff ff       	call   c0100347 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dc1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dc8:	e8 cb 09 00 00       	call   c0101798 <pic_enable>
}
c0100dcd:	c9                   	leave  
c0100dce:	c3                   	ret    
	...

c0100dd0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100dd0:	55                   	push   %ebp
c0100dd1:	89 e5                	mov    %esp,%ebp
c0100dd3:	53                   	push   %ebx
c0100dd4:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100dd7:	9c                   	pushf  
c0100dd8:	5b                   	pop    %ebx
c0100dd9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0100ddc:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100ddf:	25 00 02 00 00       	and    $0x200,%eax
c0100de4:	85 c0                	test   %eax,%eax
c0100de6:	74 0c                	je     c0100df4 <__intr_save+0x24>
        intr_disable();
c0100de8:	e8 4d 09 00 00       	call   c010173a <intr_disable>
        return 1;
c0100ded:	b8 01 00 00 00       	mov    $0x1,%eax
c0100df2:	eb 05                	jmp    c0100df9 <__intr_save+0x29>
    }
    return 0;
c0100df4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100df9:	83 c4 14             	add    $0x14,%esp
c0100dfc:	5b                   	pop    %ebx
c0100dfd:	5d                   	pop    %ebp
c0100dfe:	c3                   	ret    

c0100dff <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100dff:	55                   	push   %ebp
c0100e00:	89 e5                	mov    %esp,%ebp
c0100e02:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e09:	74 05                	je     c0100e10 <__intr_restore+0x11>
        intr_enable();
c0100e0b:	e8 24 09 00 00       	call   c0101734 <intr_enable>
    }
}
c0100e10:	c9                   	leave  
c0100e11:	c3                   	ret    

c0100e12 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e12:	55                   	push   %ebp
c0100e13:	89 e5                	mov    %esp,%ebp
c0100e15:	53                   	push   %ebx
c0100e16:	83 ec 14             	sub    $0x14,%esp
c0100e19:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e1f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e23:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e27:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e2b:	ec                   	in     (%dx),%al
c0100e2c:	89 c3                	mov    %eax,%ebx
c0100e2e:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
c0100e31:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e37:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e3b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e3f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e43:	ec                   	in     (%dx),%al
c0100e44:	89 c3                	mov    %eax,%ebx
c0100e46:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0100e49:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e4f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e53:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e57:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	89 c3                	mov    %eax,%ebx
c0100e5e:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0100e61:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e67:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e6b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e6f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e73:	ec                   	in     (%dx),%al
c0100e74:	89 c3                	mov    %eax,%ebx
c0100e76:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e79:	83 c4 14             	add    $0x14,%esp
c0100e7c:	5b                   	pop    %ebx
c0100e7d:	5d                   	pop    %ebp
c0100e7e:	c3                   	ret    

c0100e7f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e7f:	55                   	push   %ebp
c0100e80:	89 e5                	mov    %esp,%ebp
c0100e82:	53                   	push   %ebx
c0100e83:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e86:	c7 45 f8 00 80 0b c0 	movl   $0xc00b8000,-0x8(%ebp)
    uint16_t was = *cp;
c0100e8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100e90:	0f b7 00             	movzwl (%eax),%eax
c0100e93:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100e97:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100e9a:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100e9f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100ea2:	0f b7 00             	movzwl (%eax),%eax
c0100ea5:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ea9:	74 12                	je     c0100ebd <cga_init+0x3e>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100eab:	c7 45 f8 00 00 0b c0 	movl   $0xc00b0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
c0100eb2:	66 c7 05 86 8e 11 c0 	movw   $0x3b4,0xc0118e86
c0100eb9:	b4 03 
c0100ebb:	eb 13                	jmp    c0100ed0 <cga_init+0x51>
    } else {
        *cp = was;
c0100ebd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100ec0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ec4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ec7:	66 c7 05 86 8e 11 c0 	movw   $0x3d4,0xc0118e86
c0100ece:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ed0:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100ed7:	0f b7 c0             	movzwl %ax,%eax
c0100eda:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100ede:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ee2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ee6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100eea:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100eeb:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100ef2:	83 c0 01             	add    $0x1,%eax
c0100ef5:	0f b7 c0             	movzwl %ax,%eax
c0100ef8:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100efc:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f00:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100f04:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f08:	ec                   	in     (%dx),%al
c0100f09:	89 c3                	mov    %eax,%ebx
c0100f0b:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
c0100f0e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f12:	0f b6 c0             	movzbl %al,%eax
c0100f15:	c1 e0 08             	shl    $0x8,%eax
c0100f18:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
c0100f1b:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100f22:	0f b7 c0             	movzwl %ax,%eax
c0100f25:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f29:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f2d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f31:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f35:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f36:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0100f3d:	83 c0 01             	add    $0x1,%eax
c0100f40:	0f b7 c0             	movzwl %ax,%eax
c0100f43:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f47:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f4b:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100f4f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f53:	ec                   	in     (%dx),%al
c0100f54:	89 c3                	mov    %eax,%ebx
c0100f56:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
c0100f59:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f5d:	0f b6 c0             	movzbl %al,%eax
c0100f60:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f63:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100f66:	a3 80 8e 11 c0       	mov    %eax,0xc0118e80
    crt_pos = pos;
c0100f6b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100f6e:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
}
c0100f74:	83 c4 24             	add    $0x24,%esp
c0100f77:	5b                   	pop    %ebx
c0100f78:	5d                   	pop    %ebp
c0100f79:	c3                   	ret    

c0100f7a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f7a:	55                   	push   %ebp
c0100f7b:	89 e5                	mov    %esp,%ebp
c0100f7d:	53                   	push   %ebx
c0100f7e:	83 ec 54             	sub    $0x54,%esp
c0100f81:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f87:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f8b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f8f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f93:	ee                   	out    %al,(%dx)
c0100f94:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100f9a:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100f9e:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fa2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fa6:	ee                   	out    %al,(%dx)
c0100fa7:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fad:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fb1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fb5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fb9:	ee                   	out    %al,(%dx)
c0100fba:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fc0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fc4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fc8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fcc:	ee                   	out    %al,(%dx)
c0100fcd:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fd3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fd7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100fdb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fdf:	ee                   	out    %al,(%dx)
c0100fe0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100fe6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100fea:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100fee:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100ff2:	ee                   	out    %al,(%dx)
c0100ff3:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0100ff9:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0100ffd:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101001:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101005:	ee                   	out    %al,(%dx)
c0101006:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101010:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101014:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101018:	ec                   	in     (%dx),%al
c0101019:	89 c3                	mov    %eax,%ebx
c010101b:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
c010101e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101022:	3c ff                	cmp    $0xff,%al
c0101024:	0f 95 c0             	setne  %al
c0101027:	0f b6 c0             	movzbl %al,%eax
c010102a:	a3 88 8e 11 c0       	mov    %eax,0xc0118e88
c010102f:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101035:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101039:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c010103d:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101041:	ec                   	in     (%dx),%al
c0101042:	89 c3                	mov    %eax,%ebx
c0101044:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
c0101047:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010104d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101051:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101055:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101059:	ec                   	in     (%dx),%al
c010105a:	89 c3                	mov    %eax,%ebx
c010105c:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010105f:	a1 88 8e 11 c0       	mov    0xc0118e88,%eax
c0101064:	85 c0                	test   %eax,%eax
c0101066:	74 0c                	je     c0101074 <serial_init+0xfa>
        pic_enable(IRQ_COM1);
c0101068:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010106f:	e8 24 07 00 00       	call   c0101798 <pic_enable>
    }
}
c0101074:	83 c4 54             	add    $0x54,%esp
c0101077:	5b                   	pop    %ebx
c0101078:	5d                   	pop    %ebp
c0101079:	c3                   	ret    

c010107a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010107a:	55                   	push   %ebp
c010107b:	89 e5                	mov    %esp,%ebp
c010107d:	53                   	push   %ebx
c010107e:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101081:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101088:	eb 09                	jmp    c0101093 <lpt_putc_sub+0x19>
        delay();
c010108a:	e8 83 fd ff ff       	call   c0100e12 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010108f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101093:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
c0101099:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010109d:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c01010a1:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01010a5:	ec                   	in     (%dx),%al
c01010a6:	89 c3                	mov    %eax,%ebx
c01010a8:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c01010ab:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010af:	84 c0                	test   %al,%al
c01010b1:	78 09                	js     c01010bc <lpt_putc_sub+0x42>
c01010b3:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c01010ba:	7e ce                	jle    c010108a <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
c01010bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01010bf:	0f b6 c0             	movzbl %al,%eax
c01010c2:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
c01010c8:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010cb:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010cf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010d3:	ee                   	out    %al,(%dx)
c01010d4:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010da:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
c01010de:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010e2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010e6:	ee                   	out    %al,(%dx)
c01010e7:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
c01010ed:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
c01010f1:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01010f5:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01010f9:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c01010fa:	83 c4 24             	add    $0x24,%esp
c01010fd:	5b                   	pop    %ebx
c01010fe:	5d                   	pop    %ebp
c01010ff:	c3                   	ret    

c0101100 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101100:	55                   	push   %ebp
c0101101:	89 e5                	mov    %esp,%ebp
c0101103:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101106:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010110a:	74 0d                	je     c0101119 <lpt_putc+0x19>
        lpt_putc_sub(c);
c010110c:	8b 45 08             	mov    0x8(%ebp),%eax
c010110f:	89 04 24             	mov    %eax,(%esp)
c0101112:	e8 63 ff ff ff       	call   c010107a <lpt_putc_sub>
c0101117:	eb 24                	jmp    c010113d <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c0101119:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101120:	e8 55 ff ff ff       	call   c010107a <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101125:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010112c:	e8 49 ff ff ff       	call   c010107a <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101131:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101138:	e8 3d ff ff ff       	call   c010107a <lpt_putc_sub>
    }
}
c010113d:	c9                   	leave  
c010113e:	c3                   	ret    

c010113f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010113f:	55                   	push   %ebp
c0101140:	89 e5                	mov    %esp,%ebp
c0101142:	53                   	push   %ebx
c0101143:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101146:	8b 45 08             	mov    0x8(%ebp),%eax
c0101149:	b0 00                	mov    $0x0,%al
c010114b:	85 c0                	test   %eax,%eax
c010114d:	75 07                	jne    c0101156 <cga_putc+0x17>
        c |= 0x0700;
c010114f:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101156:	8b 45 08             	mov    0x8(%ebp),%eax
c0101159:	25 ff 00 00 00       	and    $0xff,%eax
c010115e:	83 f8 0a             	cmp    $0xa,%eax
c0101161:	74 4e                	je     c01011b1 <cga_putc+0x72>
c0101163:	83 f8 0d             	cmp    $0xd,%eax
c0101166:	74 59                	je     c01011c1 <cga_putc+0x82>
c0101168:	83 f8 08             	cmp    $0x8,%eax
c010116b:	0f 85 8c 00 00 00    	jne    c01011fd <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
c0101171:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101178:	66 85 c0             	test   %ax,%ax
c010117b:	0f 84 a1 00 00 00    	je     c0101222 <cga_putc+0xe3>
            crt_pos --;
c0101181:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101188:	83 e8 01             	sub    $0x1,%eax
c010118b:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c0101191:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c0101196:	0f b7 15 84 8e 11 c0 	movzwl 0xc0118e84,%edx
c010119d:	0f b7 d2             	movzwl %dx,%edx
c01011a0:	01 d2                	add    %edx,%edx
c01011a2:	01 c2                	add    %eax,%edx
c01011a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01011a7:	b0 00                	mov    $0x0,%al
c01011a9:	83 c8 20             	or     $0x20,%eax
c01011ac:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011af:	eb 71                	jmp    c0101222 <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
c01011b1:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c01011b8:	83 c0 50             	add    $0x50,%eax
c01011bb:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011c1:	0f b7 1d 84 8e 11 c0 	movzwl 0xc0118e84,%ebx
c01011c8:	0f b7 0d 84 8e 11 c0 	movzwl 0xc0118e84,%ecx
c01011cf:	0f b7 c1             	movzwl %cx,%eax
c01011d2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011d8:	c1 e8 10             	shr    $0x10,%eax
c01011db:	89 c2                	mov    %eax,%edx
c01011dd:	66 c1 ea 06          	shr    $0x6,%dx
c01011e1:	89 d0                	mov    %edx,%eax
c01011e3:	c1 e0 02             	shl    $0x2,%eax
c01011e6:	01 d0                	add    %edx,%eax
c01011e8:	c1 e0 04             	shl    $0x4,%eax
c01011eb:	89 ca                	mov    %ecx,%edx
c01011ed:	66 29 c2             	sub    %ax,%dx
c01011f0:	89 d8                	mov    %ebx,%eax
c01011f2:	66 29 d0             	sub    %dx,%ax
c01011f5:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
        break;
c01011fb:	eb 26                	jmp    c0101223 <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c01011fd:	8b 15 80 8e 11 c0    	mov    0xc0118e80,%edx
c0101203:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c010120a:	0f b7 c8             	movzwl %ax,%ecx
c010120d:	01 c9                	add    %ecx,%ecx
c010120f:	01 d1                	add    %edx,%ecx
c0101211:	8b 55 08             	mov    0x8(%ebp),%edx
c0101214:	66 89 11             	mov    %dx,(%ecx)
c0101217:	83 c0 01             	add    $0x1,%eax
c010121a:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
        break;
c0101220:	eb 01                	jmp    c0101223 <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101222:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101223:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c010122a:	66 3d cf 07          	cmp    $0x7cf,%ax
c010122e:	76 5b                	jbe    c010128b <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101230:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c0101235:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010123b:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c0101240:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101247:	00 
c0101248:	89 54 24 04          	mov    %edx,0x4(%esp)
c010124c:	89 04 24             	mov    %eax,(%esp)
c010124f:	e8 be 4e 00 00       	call   c0106112 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101254:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010125b:	eb 15                	jmp    c0101272 <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
c010125d:	a1 80 8e 11 c0       	mov    0xc0118e80,%eax
c0101262:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101265:	01 d2                	add    %edx,%edx
c0101267:	01 d0                	add    %edx,%eax
c0101269:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010126e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101272:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101279:	7e e2                	jle    c010125d <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010127b:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c0101282:	83 e8 50             	sub    $0x50,%eax
c0101285:	66 a3 84 8e 11 c0    	mov    %ax,0xc0118e84
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010128b:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c0101292:	0f b7 c0             	movzwl %ax,%eax
c0101295:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101299:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c010129d:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012a1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012a5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c01012a6:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c01012ad:	66 c1 e8 08          	shr    $0x8,%ax
c01012b1:	0f b6 c0             	movzbl %al,%eax
c01012b4:	0f b7 15 86 8e 11 c0 	movzwl 0xc0118e86,%edx
c01012bb:	83 c2 01             	add    $0x1,%edx
c01012be:	0f b7 d2             	movzwl %dx,%edx
c01012c1:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01012c5:	88 45 ed             	mov    %al,-0x13(%ebp)
c01012c8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012cc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012d0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012d1:	0f b7 05 86 8e 11 c0 	movzwl 0xc0118e86,%eax
c01012d8:	0f b7 c0             	movzwl %ax,%eax
c01012db:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012df:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012e3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012e7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012eb:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012ec:	0f b7 05 84 8e 11 c0 	movzwl 0xc0118e84,%eax
c01012f3:	0f b6 c0             	movzbl %al,%eax
c01012f6:	0f b7 15 86 8e 11 c0 	movzwl 0xc0118e86,%edx
c01012fd:	83 c2 01             	add    $0x1,%edx
c0101300:	0f b7 d2             	movzwl %dx,%edx
c0101303:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101307:	88 45 e5             	mov    %al,-0x1b(%ebp)
c010130a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010130e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101312:	ee                   	out    %al,(%dx)
}
c0101313:	83 c4 34             	add    $0x34,%esp
c0101316:	5b                   	pop    %ebx
c0101317:	5d                   	pop    %ebp
c0101318:	c3                   	ret    

c0101319 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101319:	55                   	push   %ebp
c010131a:	89 e5                	mov    %esp,%ebp
c010131c:	53                   	push   %ebx
c010131d:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101320:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101327:	eb 09                	jmp    c0101332 <serial_putc_sub+0x19>
        delay();
c0101329:	e8 e4 fa ff ff       	call   c0100e12 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010132e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101332:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101338:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010133c:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101340:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101344:	ec                   	in     (%dx),%al
c0101345:	89 c3                	mov    %eax,%ebx
c0101347:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c010134a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010134e:	0f b6 c0             	movzbl %al,%eax
c0101351:	83 e0 20             	and    $0x20,%eax
c0101354:	85 c0                	test   %eax,%eax
c0101356:	75 09                	jne    c0101361 <serial_putc_sub+0x48>
c0101358:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c010135f:	7e c8                	jle    c0101329 <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101361:	8b 45 08             	mov    0x8(%ebp),%eax
c0101364:	0f b6 c0             	movzbl %al,%eax
c0101367:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c010136d:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101370:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101374:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101378:	ee                   	out    %al,(%dx)
}
c0101379:	83 c4 14             	add    $0x14,%esp
c010137c:	5b                   	pop    %ebx
c010137d:	5d                   	pop    %ebp
c010137e:	c3                   	ret    

c010137f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010137f:	55                   	push   %ebp
c0101380:	89 e5                	mov    %esp,%ebp
c0101382:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101385:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101389:	74 0d                	je     c0101398 <serial_putc+0x19>
        serial_putc_sub(c);
c010138b:	8b 45 08             	mov    0x8(%ebp),%eax
c010138e:	89 04 24             	mov    %eax,(%esp)
c0101391:	e8 83 ff ff ff       	call   c0101319 <serial_putc_sub>
c0101396:	eb 24                	jmp    c01013bc <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c0101398:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c010139f:	e8 75 ff ff ff       	call   c0101319 <serial_putc_sub>
        serial_putc_sub(' ');
c01013a4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013ab:	e8 69 ff ff ff       	call   c0101319 <serial_putc_sub>
        serial_putc_sub('\b');
c01013b0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013b7:	e8 5d ff ff ff       	call   c0101319 <serial_putc_sub>
    }
}
c01013bc:	c9                   	leave  
c01013bd:	c3                   	ret    

c01013be <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013be:	55                   	push   %ebp
c01013bf:	89 e5                	mov    %esp,%ebp
c01013c1:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013c4:	eb 32                	jmp    c01013f8 <cons_intr+0x3a>
        if (c != 0) {
c01013c6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013ca:	74 2c                	je     c01013f8 <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
c01013cc:	a1 a4 90 11 c0       	mov    0xc01190a4,%eax
c01013d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013d4:	88 90 a0 8e 11 c0    	mov    %dl,-0x3fee7160(%eax)
c01013da:	83 c0 01             	add    $0x1,%eax
c01013dd:	a3 a4 90 11 c0       	mov    %eax,0xc01190a4
            if (cons.wpos == CONSBUFSIZE) {
c01013e2:	a1 a4 90 11 c0       	mov    0xc01190a4,%eax
c01013e7:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013ec:	75 0a                	jne    c01013f8 <cons_intr+0x3a>
                cons.wpos = 0;
c01013ee:	c7 05 a4 90 11 c0 00 	movl   $0x0,0xc01190a4
c01013f5:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c01013f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01013fb:	ff d0                	call   *%eax
c01013fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101400:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101404:	75 c0                	jne    c01013c6 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101406:	c9                   	leave  
c0101407:	c3                   	ret    

c0101408 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101408:	55                   	push   %ebp
c0101409:	89 e5                	mov    %esp,%ebp
c010140b:	53                   	push   %ebx
c010140c:	83 ec 14             	sub    $0x14,%esp
c010140f:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101415:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101419:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010141d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101421:	ec                   	in     (%dx),%al
c0101422:	89 c3                	mov    %eax,%ebx
c0101424:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0101427:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010142b:	0f b6 c0             	movzbl %al,%eax
c010142e:	83 e0 01             	and    $0x1,%eax
c0101431:	85 c0                	test   %eax,%eax
c0101433:	75 07                	jne    c010143c <serial_proc_data+0x34>
        return -1;
c0101435:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010143a:	eb 32                	jmp    c010146e <serial_proc_data+0x66>
c010143c:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101442:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101446:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010144a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010144e:	ec                   	in     (%dx),%al
c010144f:	89 c3                	mov    %eax,%ebx
c0101451:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0101454:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101458:	0f b6 c0             	movzbl %al,%eax
c010145b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
c010145e:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
c0101462:	75 07                	jne    c010146b <serial_proc_data+0x63>
        c = '\b';
c0101464:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
c010146b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010146e:	83 c4 14             	add    $0x14,%esp
c0101471:	5b                   	pop    %ebx
c0101472:	5d                   	pop    %ebp
c0101473:	c3                   	ret    

c0101474 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101474:	55                   	push   %ebp
c0101475:	89 e5                	mov    %esp,%ebp
c0101477:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010147a:	a1 88 8e 11 c0       	mov    0xc0118e88,%eax
c010147f:	85 c0                	test   %eax,%eax
c0101481:	74 0c                	je     c010148f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101483:	c7 04 24 08 14 10 c0 	movl   $0xc0101408,(%esp)
c010148a:	e8 2f ff ff ff       	call   c01013be <cons_intr>
    }
}
c010148f:	c9                   	leave  
c0101490:	c3                   	ret    

c0101491 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c0101491:	55                   	push   %ebp
c0101492:	89 e5                	mov    %esp,%ebp
c0101494:	53                   	push   %ebx
c0101495:	83 ec 44             	sub    $0x44,%esp
c0101498:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010149e:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01014a2:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01014a6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01014aa:	ec                   	in     (%dx),%al
c01014ab:	89 c3                	mov    %eax,%ebx
c01014ad:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
c01014b0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014b4:	0f b6 c0             	movzbl %al,%eax
c01014b7:	83 e0 01             	and    $0x1,%eax
c01014ba:	85 c0                	test   %eax,%eax
c01014bc:	75 0a                	jne    c01014c8 <kbd_proc_data+0x37>
        return -1;
c01014be:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014c3:	e9 61 01 00 00       	jmp    c0101629 <kbd_proc_data+0x198>
c01014c8:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014ce:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01014d2:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01014d6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01014da:	ec                   	in     (%dx),%al
c01014db:	89 c3                	mov    %eax,%ebx
c01014dd:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
c01014e0:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014e4:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014e7:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014eb:	75 17                	jne    c0101504 <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
c01014ed:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01014f2:	83 c8 40             	or     $0x40,%eax
c01014f5:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
        return 0;
c01014fa:	b8 00 00 00 00       	mov    $0x0,%eax
c01014ff:	e9 25 01 00 00       	jmp    c0101629 <kbd_proc_data+0x198>
    } else if (data & 0x80) {
c0101504:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101508:	84 c0                	test   %al,%al
c010150a:	79 47                	jns    c0101553 <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010150c:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101511:	83 e0 40             	and    $0x40,%eax
c0101514:	85 c0                	test   %eax,%eax
c0101516:	75 09                	jne    c0101521 <kbd_proc_data+0x90>
c0101518:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010151c:	83 e0 7f             	and    $0x7f,%eax
c010151f:	eb 04                	jmp    c0101525 <kbd_proc_data+0x94>
c0101521:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101525:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152c:	0f b6 80 60 80 11 c0 	movzbl -0x3fee7fa0(%eax),%eax
c0101533:	83 c8 40             	or     $0x40,%eax
c0101536:	0f b6 c0             	movzbl %al,%eax
c0101539:	f7 d0                	not    %eax
c010153b:	89 c2                	mov    %eax,%edx
c010153d:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101542:	21 d0                	and    %edx,%eax
c0101544:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
        return 0;
c0101549:	b8 00 00 00 00       	mov    $0x0,%eax
c010154e:	e9 d6 00 00 00       	jmp    c0101629 <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
c0101553:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101558:	83 e0 40             	and    $0x40,%eax
c010155b:	85 c0                	test   %eax,%eax
c010155d:	74 11                	je     c0101570 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010155f:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101563:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101568:	83 e0 bf             	and    $0xffffffbf,%eax
c010156b:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
    }

    shift |= shiftcode[data];
c0101570:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101574:	0f b6 80 60 80 11 c0 	movzbl -0x3fee7fa0(%eax),%eax
c010157b:	0f b6 d0             	movzbl %al,%edx
c010157e:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c0101583:	09 d0                	or     %edx,%eax
c0101585:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8
    shift ^= togglecode[data];
c010158a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158e:	0f b6 80 60 81 11 c0 	movzbl -0x3fee7ea0(%eax),%eax
c0101595:	0f b6 d0             	movzbl %al,%edx
c0101598:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c010159d:	31 d0                	xor    %edx,%eax
c010159f:	a3 a8 90 11 c0       	mov    %eax,0xc01190a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01015a4:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01015a9:	83 e0 03             	and    $0x3,%eax
c01015ac:	8b 14 85 60 85 11 c0 	mov    -0x3fee7aa0(,%eax,4),%edx
c01015b3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015b7:	01 d0                	add    %edx,%eax
c01015b9:	0f b6 00             	movzbl (%eax),%eax
c01015bc:	0f b6 c0             	movzbl %al,%eax
c01015bf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015c2:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01015c7:	83 e0 08             	and    $0x8,%eax
c01015ca:	85 c0                	test   %eax,%eax
c01015cc:	74 22                	je     c01015f0 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
c01015ce:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015d2:	7e 0c                	jle    c01015e0 <kbd_proc_data+0x14f>
c01015d4:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015d8:	7f 06                	jg     c01015e0 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
c01015da:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015de:	eb 10                	jmp    c01015f0 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
c01015e0:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015e4:	7e 0a                	jle    c01015f0 <kbd_proc_data+0x15f>
c01015e6:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015ea:	7f 04                	jg     c01015f0 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
c01015ec:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c01015f0:	a1 a8 90 11 c0       	mov    0xc01190a8,%eax
c01015f5:	f7 d0                	not    %eax
c01015f7:	83 e0 06             	and    $0x6,%eax
c01015fa:	85 c0                	test   %eax,%eax
c01015fc:	75 28                	jne    c0101626 <kbd_proc_data+0x195>
c01015fe:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101605:	75 1f                	jne    c0101626 <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
c0101607:	c7 04 24 9d 65 10 c0 	movl   $0xc010659d,(%esp)
c010160e:	e8 34 ed ff ff       	call   c0100347 <cprintf>
c0101613:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101619:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010161d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101621:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101625:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101626:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101629:	83 c4 44             	add    $0x44,%esp
c010162c:	5b                   	pop    %ebx
c010162d:	5d                   	pop    %ebp
c010162e:	c3                   	ret    

c010162f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010162f:	55                   	push   %ebp
c0101630:	89 e5                	mov    %esp,%ebp
c0101632:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101635:	c7 04 24 91 14 10 c0 	movl   $0xc0101491,(%esp)
c010163c:	e8 7d fd ff ff       	call   c01013be <cons_intr>
}
c0101641:	c9                   	leave  
c0101642:	c3                   	ret    

c0101643 <kbd_init>:

static void
kbd_init(void) {
c0101643:	55                   	push   %ebp
c0101644:	89 e5                	mov    %esp,%ebp
c0101646:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101649:	e8 e1 ff ff ff       	call   c010162f <kbd_intr>
    pic_enable(IRQ_KBD);
c010164e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101655:	e8 3e 01 00 00       	call   c0101798 <pic_enable>
}
c010165a:	c9                   	leave  
c010165b:	c3                   	ret    

c010165c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010165c:	55                   	push   %ebp
c010165d:	89 e5                	mov    %esp,%ebp
c010165f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101662:	e8 18 f8 ff ff       	call   c0100e7f <cga_init>
    serial_init();
c0101667:	e8 0e f9 ff ff       	call   c0100f7a <serial_init>
    kbd_init();
c010166c:	e8 d2 ff ff ff       	call   c0101643 <kbd_init>
    if (!serial_exists) {
c0101671:	a1 88 8e 11 c0       	mov    0xc0118e88,%eax
c0101676:	85 c0                	test   %eax,%eax
c0101678:	75 0c                	jne    c0101686 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010167a:	c7 04 24 a9 65 10 c0 	movl   $0xc01065a9,(%esp)
c0101681:	e8 c1 ec ff ff       	call   c0100347 <cprintf>
    }
}
c0101686:	c9                   	leave  
c0101687:	c3                   	ret    

c0101688 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101688:	55                   	push   %ebp
c0101689:	89 e5                	mov    %esp,%ebp
c010168b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010168e:	e8 3d f7 ff ff       	call   c0100dd0 <__intr_save>
c0101693:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c0101696:	8b 45 08             	mov    0x8(%ebp),%eax
c0101699:	89 04 24             	mov    %eax,(%esp)
c010169c:	e8 5f fa ff ff       	call   c0101100 <lpt_putc>
        cga_putc(c);
c01016a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a4:	89 04 24             	mov    %eax,(%esp)
c01016a7:	e8 93 fa ff ff       	call   c010113f <cga_putc>
        serial_putc(c);
c01016ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01016af:	89 04 24             	mov    %eax,(%esp)
c01016b2:	e8 c8 fc ff ff       	call   c010137f <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016ba:	89 04 24             	mov    %eax,(%esp)
c01016bd:	e8 3d f7 ff ff       	call   c0100dff <__intr_restore>
}
c01016c2:	c9                   	leave  
c01016c3:	c3                   	ret    

c01016c4 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016c4:	55                   	push   %ebp
c01016c5:	89 e5                	mov    %esp,%ebp
c01016c7:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016d1:	e8 fa f6 ff ff       	call   c0100dd0 <__intr_save>
c01016d6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016d9:	e8 96 fd ff ff       	call   c0101474 <serial_intr>
        kbd_intr();
c01016de:	e8 4c ff ff ff       	call   c010162f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016e3:	8b 15 a0 90 11 c0    	mov    0xc01190a0,%edx
c01016e9:	a1 a4 90 11 c0       	mov    0xc01190a4,%eax
c01016ee:	39 c2                	cmp    %eax,%edx
c01016f0:	74 30                	je     c0101722 <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
c01016f2:	a1 a0 90 11 c0       	mov    0xc01190a0,%eax
c01016f7:	0f b6 90 a0 8e 11 c0 	movzbl -0x3fee7160(%eax),%edx
c01016fe:	0f b6 d2             	movzbl %dl,%edx
c0101701:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0101704:	83 c0 01             	add    $0x1,%eax
c0101707:	a3 a0 90 11 c0       	mov    %eax,0xc01190a0
            if (cons.rpos == CONSBUFSIZE) {
c010170c:	a1 a0 90 11 c0       	mov    0xc01190a0,%eax
c0101711:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101716:	75 0a                	jne    c0101722 <cons_getc+0x5e>
                cons.rpos = 0;
c0101718:	c7 05 a0 90 11 c0 00 	movl   $0x0,0xc01190a0
c010171f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101722:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101725:	89 04 24             	mov    %eax,(%esp)
c0101728:	e8 d2 f6 ff ff       	call   c0100dff <__intr_restore>
    return c;
c010172d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101730:	c9                   	leave  
c0101731:	c3                   	ret    
	...

c0101734 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101734:	55                   	push   %ebp
c0101735:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101737:	fb                   	sti    
    sti();
}
c0101738:	5d                   	pop    %ebp
c0101739:	c3                   	ret    

c010173a <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c010173a:	55                   	push   %ebp
c010173b:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c010173d:	fa                   	cli    
    cli();
}
c010173e:	5d                   	pop    %ebp
c010173f:	c3                   	ret    

c0101740 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101740:	55                   	push   %ebp
c0101741:	89 e5                	mov    %esp,%ebp
c0101743:	83 ec 14             	sub    $0x14,%esp
c0101746:	8b 45 08             	mov    0x8(%ebp),%eax
c0101749:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c010174d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101751:	66 a3 70 85 11 c0    	mov    %ax,0xc0118570
    if (did_init) {
c0101757:	a1 ac 90 11 c0       	mov    0xc01190ac,%eax
c010175c:	85 c0                	test   %eax,%eax
c010175e:	74 36                	je     c0101796 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0101760:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101764:	0f b6 c0             	movzbl %al,%eax
c0101767:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010176d:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101770:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0101774:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0101778:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0101779:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c010177d:	66 c1 e8 08          	shr    $0x8,%ax
c0101781:	0f b6 c0             	movzbl %al,%eax
c0101784:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010178a:	88 45 f9             	mov    %al,-0x7(%ebp)
c010178d:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0101791:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101795:	ee                   	out    %al,(%dx)
    }
}
c0101796:	c9                   	leave  
c0101797:	c3                   	ret    

c0101798 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0101798:	55                   	push   %ebp
c0101799:	89 e5                	mov    %esp,%ebp
c010179b:	53                   	push   %ebx
c010179c:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010179f:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a2:	ba 01 00 00 00       	mov    $0x1,%edx
c01017a7:	89 d3                	mov    %edx,%ebx
c01017a9:	89 c1                	mov    %eax,%ecx
c01017ab:	d3 e3                	shl    %cl,%ebx
c01017ad:	89 d8                	mov    %ebx,%eax
c01017af:	89 c2                	mov    %eax,%edx
c01017b1:	f7 d2                	not    %edx
c01017b3:	0f b7 05 70 85 11 c0 	movzwl 0xc0118570,%eax
c01017ba:	21 d0                	and    %edx,%eax
c01017bc:	0f b7 c0             	movzwl %ax,%eax
c01017bf:	89 04 24             	mov    %eax,(%esp)
c01017c2:	e8 79 ff ff ff       	call   c0101740 <pic_setmask>
}
c01017c7:	83 c4 04             	add    $0x4,%esp
c01017ca:	5b                   	pop    %ebx
c01017cb:	5d                   	pop    %ebp
c01017cc:	c3                   	ret    

c01017cd <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c01017cd:	55                   	push   %ebp
c01017ce:	89 e5                	mov    %esp,%ebp
c01017d0:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c01017d3:	c7 05 ac 90 11 c0 01 	movl   $0x1,0xc01190ac
c01017da:	00 00 00 
c01017dd:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c01017e3:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c01017e7:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c01017eb:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01017ef:	ee                   	out    %al,(%dx)
c01017f0:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01017f6:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01017fa:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01017fe:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0101802:	ee                   	out    %al,(%dx)
c0101803:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c0101809:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c010180d:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101811:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101815:	ee                   	out    %al,(%dx)
c0101816:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c010181c:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c0101820:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101824:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101828:	ee                   	out    %al,(%dx)
c0101829:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c010182f:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c0101833:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101837:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c010183b:	ee                   	out    %al,(%dx)
c010183c:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c0101842:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c0101846:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010184a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010184e:	ee                   	out    %al,(%dx)
c010184f:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0101855:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0101859:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010185d:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101861:	ee                   	out    %al,(%dx)
c0101862:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0101868:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c010186c:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101870:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101874:	ee                   	out    %al,(%dx)
c0101875:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010187b:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010187f:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101883:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101887:	ee                   	out    %al,(%dx)
c0101888:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010188e:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0101892:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101896:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010189a:	ee                   	out    %al,(%dx)
c010189b:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c01018a1:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c01018a5:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c01018a9:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01018ad:	ee                   	out    %al,(%dx)
c01018ae:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c01018b4:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c01018b8:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c01018bc:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c01018c0:	ee                   	out    %al,(%dx)
c01018c1:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c01018c7:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c01018cb:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c01018cf:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c01018d3:	ee                   	out    %al,(%dx)
c01018d4:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c01018da:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c01018de:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c01018e2:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c01018e6:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c01018e7:	0f b7 05 70 85 11 c0 	movzwl 0xc0118570,%eax
c01018ee:	66 83 f8 ff          	cmp    $0xffff,%ax
c01018f2:	74 12                	je     c0101906 <pic_init+0x139>
        pic_setmask(irq_mask);
c01018f4:	0f b7 05 70 85 11 c0 	movzwl 0xc0118570,%eax
c01018fb:	0f b7 c0             	movzwl %ax,%eax
c01018fe:	89 04 24             	mov    %eax,(%esp)
c0101901:	e8 3a fe ff ff       	call   c0101740 <pic_setmask>
    }
}
c0101906:	c9                   	leave  
c0101907:	c3                   	ret    

c0101908 <print_ticks>:
#include <console.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c0101908:	55                   	push   %ebp
c0101909:	89 e5                	mov    %esp,%ebp
c010190b:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c010190e:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0101915:	00 
c0101916:	c7 04 24 e0 65 10 c0 	movl   $0xc01065e0,(%esp)
c010191d:	e8 25 ea ff ff       	call   c0100347 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
    panic("EOT: kernel seems ok.");
#endif
}
c0101922:	c9                   	leave  
c0101923:	c3                   	ret    

c0101924 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c0101924:	55                   	push   %ebp
c0101925:	89 e5                	mov    %esp,%ebp
c0101927:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c010192a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0101931:	e9 c3 00 00 00       	jmp    c01019f9 <idt_init+0xd5>
        SETGATE(idt[i], 0,  GD_KTEXT, __vectors[i], DPL_KERNEL);
c0101936:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101939:	8b 04 85 00 86 11 c0 	mov    -0x3fee7a00(,%eax,4),%eax
c0101940:	89 c2                	mov    %eax,%edx
c0101942:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101945:	66 89 14 c5 c0 90 11 	mov    %dx,-0x3fee6f40(,%eax,8)
c010194c:	c0 
c010194d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101950:	66 c7 04 c5 c2 90 11 	movw   $0x8,-0x3fee6f3e(,%eax,8)
c0101957:	c0 08 00 
c010195a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010195d:	0f b6 14 c5 c4 90 11 	movzbl -0x3fee6f3c(,%eax,8),%edx
c0101964:	c0 
c0101965:	83 e2 e0             	and    $0xffffffe0,%edx
c0101968:	88 14 c5 c4 90 11 c0 	mov    %dl,-0x3fee6f3c(,%eax,8)
c010196f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101972:	0f b6 14 c5 c4 90 11 	movzbl -0x3fee6f3c(,%eax,8),%edx
c0101979:	c0 
c010197a:	83 e2 1f             	and    $0x1f,%edx
c010197d:	88 14 c5 c4 90 11 c0 	mov    %dl,-0x3fee6f3c(,%eax,8)
c0101984:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0101987:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c010198e:	c0 
c010198f:	83 e2 f0             	and    $0xfffffff0,%edx
c0101992:	83 ca 0e             	or     $0xe,%edx
c0101995:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c010199c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010199f:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c01019a6:	c0 
c01019a7:	83 e2 ef             	and    $0xffffffef,%edx
c01019aa:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c01019b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019b4:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c01019bb:	c0 
c01019bc:	83 e2 9f             	and    $0xffffff9f,%edx
c01019bf:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c01019c6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019c9:	0f b6 14 c5 c5 90 11 	movzbl -0x3fee6f3b(,%eax,8),%edx
c01019d0:	c0 
c01019d1:	83 ca 80             	or     $0xffffff80,%edx
c01019d4:	88 14 c5 c5 90 11 c0 	mov    %dl,-0x3fee6f3b(,%eax,8)
c01019db:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019de:	8b 04 85 00 86 11 c0 	mov    -0x3fee7a00(,%eax,4),%eax
c01019e5:	c1 e8 10             	shr    $0x10,%eax
c01019e8:	89 c2                	mov    %eax,%edx
c01019ea:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019ed:	66 89 14 c5 c6 90 11 	mov    %dx,-0x3fee6f3a(,%eax,8)
c01019f4:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01019f5:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01019f9:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01019fc:	3d ff 00 00 00       	cmp    $0xff,%eax
c0101a01:	0f 86 2f ff ff ff    	jbe    c0101936 <idt_init+0x12>
        SETGATE(idt[i], 0,  GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c0101a07:	a1 e4 87 11 c0       	mov    0xc01187e4,%eax
c0101a0c:	66 a3 88 94 11 c0    	mov    %ax,0xc0119488
c0101a12:	66 c7 05 8a 94 11 c0 	movw   $0x8,0xc011948a
c0101a19:	08 00 
c0101a1b:	0f b6 05 8c 94 11 c0 	movzbl 0xc011948c,%eax
c0101a22:	83 e0 e0             	and    $0xffffffe0,%eax
c0101a25:	a2 8c 94 11 c0       	mov    %al,0xc011948c
c0101a2a:	0f b6 05 8c 94 11 c0 	movzbl 0xc011948c,%eax
c0101a31:	83 e0 1f             	and    $0x1f,%eax
c0101a34:	a2 8c 94 11 c0       	mov    %al,0xc011948c
c0101a39:	0f b6 05 8d 94 11 c0 	movzbl 0xc011948d,%eax
c0101a40:	83 e0 f0             	and    $0xfffffff0,%eax
c0101a43:	83 c8 0e             	or     $0xe,%eax
c0101a46:	a2 8d 94 11 c0       	mov    %al,0xc011948d
c0101a4b:	0f b6 05 8d 94 11 c0 	movzbl 0xc011948d,%eax
c0101a52:	83 e0 ef             	and    $0xffffffef,%eax
c0101a55:	a2 8d 94 11 c0       	mov    %al,0xc011948d
c0101a5a:	0f b6 05 8d 94 11 c0 	movzbl 0xc011948d,%eax
c0101a61:	83 c8 60             	or     $0x60,%eax
c0101a64:	a2 8d 94 11 c0       	mov    %al,0xc011948d
c0101a69:	0f b6 05 8d 94 11 c0 	movzbl 0xc011948d,%eax
c0101a70:	83 c8 80             	or     $0xffffff80,%eax
c0101a73:	a2 8d 94 11 c0       	mov    %al,0xc011948d
c0101a78:	a1 e4 87 11 c0       	mov    0xc01187e4,%eax
c0101a7d:	c1 e8 10             	shr    $0x10,%eax
c0101a80:	66 a3 8e 94 11 c0    	mov    %ax,0xc011948e
c0101a86:	c7 45 f8 80 85 11 c0 	movl   $0xc0118580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0101a8d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101a90:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd); // load the IDT
      
}
c0101a93:	c9                   	leave  
c0101a94:	c3                   	ret    

c0101a95 <trapname>:

static const char *
trapname(int trapno) {
c0101a95:	55                   	push   %ebp
c0101a96:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0101a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0101a9b:	83 f8 13             	cmp    $0x13,%eax
c0101a9e:	77 0c                	ja     c0101aac <trapname+0x17>
        return excnames[trapno];
c0101aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0101aa3:	8b 04 85 40 69 10 c0 	mov    -0x3fef96c0(,%eax,4),%eax
c0101aaa:	eb 18                	jmp    c0101ac4 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0101aac:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0101ab0:	7e 0d                	jle    c0101abf <trapname+0x2a>
c0101ab2:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0101ab6:	7f 07                	jg     c0101abf <trapname+0x2a>
        return "Hardware Interrupt";
c0101ab8:	b8 ea 65 10 c0       	mov    $0xc01065ea,%eax
c0101abd:	eb 05                	jmp    c0101ac4 <trapname+0x2f>
    }
    return "(unknown trap)";
c0101abf:	b8 fd 65 10 c0       	mov    $0xc01065fd,%eax
}
c0101ac4:	5d                   	pop    %ebp
c0101ac5:	c3                   	ret    

c0101ac6 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0101ac6:	55                   	push   %ebp
c0101ac7:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0101ac9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101acc:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101ad0:	66 83 f8 08          	cmp    $0x8,%ax
c0101ad4:	0f 94 c0             	sete   %al
c0101ad7:	0f b6 c0             	movzbl %al,%eax
}
c0101ada:	5d                   	pop    %ebp
c0101adb:	c3                   	ret    

c0101adc <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c0101adc:	55                   	push   %ebp
c0101add:	89 e5                	mov    %esp,%ebp
c0101adf:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c0101ae2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101ae9:	c7 04 24 3e 66 10 c0 	movl   $0xc010663e,(%esp)
c0101af0:	e8 52 e8 ff ff       	call   c0100347 <cprintf>
    print_regs(&tf->tf_regs);
c0101af5:	8b 45 08             	mov    0x8(%ebp),%eax
c0101af8:	89 04 24             	mov    %eax,(%esp)
c0101afb:	e8 a1 01 00 00       	call   c0101ca1 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c0101b00:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b03:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c0101b07:	0f b7 c0             	movzwl %ax,%eax
c0101b0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b0e:	c7 04 24 4f 66 10 c0 	movl   $0xc010664f,(%esp)
c0101b15:	e8 2d e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c0101b1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1d:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c0101b21:	0f b7 c0             	movzwl %ax,%eax
c0101b24:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b28:	c7 04 24 62 66 10 c0 	movl   $0xc0106662,(%esp)
c0101b2f:	e8 13 e8 ff ff       	call   c0100347 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0101b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b37:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0101b3b:	0f b7 c0             	movzwl %ax,%eax
c0101b3e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b42:	c7 04 24 75 66 10 c0 	movl   $0xc0106675,(%esp)
c0101b49:	e8 f9 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0101b4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b51:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0101b55:	0f b7 c0             	movzwl %ax,%eax
c0101b58:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b5c:	c7 04 24 88 66 10 c0 	movl   $0xc0106688,(%esp)
c0101b63:	e8 df e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0101b68:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b6b:	8b 40 30             	mov    0x30(%eax),%eax
c0101b6e:	89 04 24             	mov    %eax,(%esp)
c0101b71:	e8 1f ff ff ff       	call   c0101a95 <trapname>
c0101b76:	8b 55 08             	mov    0x8(%ebp),%edx
c0101b79:	8b 52 30             	mov    0x30(%edx),%edx
c0101b7c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0101b80:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101b84:	c7 04 24 9b 66 10 c0 	movl   $0xc010669b,(%esp)
c0101b8b:	e8 b7 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0101b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b93:	8b 40 34             	mov    0x34(%eax),%eax
c0101b96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b9a:	c7 04 24 ad 66 10 c0 	movl   $0xc01066ad,(%esp)
c0101ba1:	e8 a1 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0101ba6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ba9:	8b 40 38             	mov    0x38(%eax),%eax
c0101bac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bb0:	c7 04 24 bc 66 10 c0 	movl   $0xc01066bc,(%esp)
c0101bb7:	e8 8b e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0101bbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bbf:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101bc3:	0f b7 c0             	movzwl %ax,%eax
c0101bc6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101bca:	c7 04 24 cb 66 10 c0 	movl   $0xc01066cb,(%esp)
c0101bd1:	e8 71 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c0101bd6:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bd9:	8b 40 40             	mov    0x40(%eax),%eax
c0101bdc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101be0:	c7 04 24 de 66 10 c0 	movl   $0xc01066de,(%esp)
c0101be7:	e8 5b e7 ff ff       	call   c0100347 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101bec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0101bf3:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c0101bfa:	eb 3e                	jmp    c0101c3a <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c0101bfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bff:	8b 50 40             	mov    0x40(%eax),%edx
c0101c02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101c05:	21 d0                	and    %edx,%eax
c0101c07:	85 c0                	test   %eax,%eax
c0101c09:	74 28                	je     c0101c33 <print_trapframe+0x157>
c0101c0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c0e:	8b 04 85 a0 85 11 c0 	mov    -0x3fee7a60(,%eax,4),%eax
c0101c15:	85 c0                	test   %eax,%eax
c0101c17:	74 1a                	je     c0101c33 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c0101c19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c1c:	8b 04 85 a0 85 11 c0 	mov    -0x3fee7a60(,%eax,4),%eax
c0101c23:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c27:	c7 04 24 ed 66 10 c0 	movl   $0xc01066ed,(%esp)
c0101c2e:	e8 14 e7 ff ff       	call   c0100347 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0101c33:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101c37:	d1 65 f0             	shll   -0x10(%ebp)
c0101c3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0101c3d:	83 f8 17             	cmp    $0x17,%eax
c0101c40:	76 ba                	jbe    c0101bfc <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0101c42:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c45:	8b 40 40             	mov    0x40(%eax),%eax
c0101c48:	25 00 30 00 00       	and    $0x3000,%eax
c0101c4d:	c1 e8 0c             	shr    $0xc,%eax
c0101c50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c54:	c7 04 24 f1 66 10 c0 	movl   $0xc01066f1,(%esp)
c0101c5b:	e8 e7 e6 ff ff       	call   c0100347 <cprintf>

    if (!trap_in_kernel(tf)) {
c0101c60:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c63:	89 04 24             	mov    %eax,(%esp)
c0101c66:	e8 5b fe ff ff       	call   c0101ac6 <trap_in_kernel>
c0101c6b:	85 c0                	test   %eax,%eax
c0101c6d:	75 30                	jne    c0101c9f <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0101c6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c72:	8b 40 44             	mov    0x44(%eax),%eax
c0101c75:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c79:	c7 04 24 fa 66 10 c0 	movl   $0xc01066fa,(%esp)
c0101c80:	e8 c2 e6 ff ff       	call   c0100347 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0101c85:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c88:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0101c8c:	0f b7 c0             	movzwl %ax,%eax
c0101c8f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101c93:	c7 04 24 09 67 10 c0 	movl   $0xc0106709,(%esp)
c0101c9a:	e8 a8 e6 ff ff       	call   c0100347 <cprintf>
    }
}
c0101c9f:	c9                   	leave  
c0101ca0:	c3                   	ret    

c0101ca1 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0101ca1:	55                   	push   %ebp
c0101ca2:	89 e5                	mov    %esp,%ebp
c0101ca4:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0101ca7:	8b 45 08             	mov    0x8(%ebp),%eax
c0101caa:	8b 00                	mov    (%eax),%eax
c0101cac:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cb0:	c7 04 24 1c 67 10 c0 	movl   $0xc010671c,(%esp)
c0101cb7:	e8 8b e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0101cbc:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cbf:	8b 40 04             	mov    0x4(%eax),%eax
c0101cc2:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cc6:	c7 04 24 2b 67 10 c0 	movl   $0xc010672b,(%esp)
c0101ccd:	e8 75 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c0101cd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101cd5:	8b 40 08             	mov    0x8(%eax),%eax
c0101cd8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cdc:	c7 04 24 3a 67 10 c0 	movl   $0xc010673a,(%esp)
c0101ce3:	e8 5f e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c0101ce8:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ceb:	8b 40 0c             	mov    0xc(%eax),%eax
c0101cee:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101cf2:	c7 04 24 49 67 10 c0 	movl   $0xc0106749,(%esp)
c0101cf9:	e8 49 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c0101cfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d01:	8b 40 10             	mov    0x10(%eax),%eax
c0101d04:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d08:	c7 04 24 58 67 10 c0 	movl   $0xc0106758,(%esp)
c0101d0f:	e8 33 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c0101d14:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d17:	8b 40 14             	mov    0x14(%eax),%eax
c0101d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d1e:	c7 04 24 67 67 10 c0 	movl   $0xc0106767,(%esp)
c0101d25:	e8 1d e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0101d2a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d2d:	8b 40 18             	mov    0x18(%eax),%eax
c0101d30:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d34:	c7 04 24 76 67 10 c0 	movl   $0xc0106776,(%esp)
c0101d3b:	e8 07 e6 ff ff       	call   c0100347 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0101d40:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d43:	8b 40 1c             	mov    0x1c(%eax),%eax
c0101d46:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101d4a:	c7 04 24 85 67 10 c0 	movl   $0xc0106785,(%esp)
c0101d51:	e8 f1 e5 ff ff       	call   c0100347 <cprintf>
}
c0101d56:	c9                   	leave  
c0101d57:	c3                   	ret    

c0101d58 <trap_dispatch>:

/* trap_dispatch - dispatch based on what type of trap occurred */
static void
trap_dispatch(struct trapframe *tf) {
c0101d58:	55                   	push   %ebp
c0101d59:	89 e5                	mov    %esp,%ebp
c0101d5b:	83 ec 28             	sub    $0x28,%esp
    char c;

    switch (tf->tf_trapno) {
c0101d5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101d61:	8b 40 30             	mov    0x30(%eax),%eax
c0101d64:	83 f8 2f             	cmp    $0x2f,%eax
c0101d67:	77 21                	ja     c0101d8a <trap_dispatch+0x32>
c0101d69:	83 f8 2e             	cmp    $0x2e,%eax
c0101d6c:	0f 83 05 01 00 00    	jae    c0101e77 <trap_dispatch+0x11f>
c0101d72:	83 f8 21             	cmp    $0x21,%eax
c0101d75:	0f 84 82 00 00 00    	je     c0101dfd <trap_dispatch+0xa5>
c0101d7b:	83 f8 24             	cmp    $0x24,%eax
c0101d7e:	74 57                	je     c0101dd7 <trap_dispatch+0x7f>
c0101d80:	83 f8 20             	cmp    $0x20,%eax
c0101d83:	74 16                	je     c0101d9b <trap_dispatch+0x43>
c0101d85:	e9 b5 00 00 00       	jmp    c0101e3f <trap_dispatch+0xe7>
c0101d8a:	83 e8 78             	sub    $0x78,%eax
c0101d8d:	83 f8 01             	cmp    $0x1,%eax
c0101d90:	0f 87 a9 00 00 00    	ja     c0101e3f <trap_dispatch+0xe7>
c0101d96:	e9 88 00 00 00       	jmp    c0101e23 <trap_dispatch+0xcb>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c0101d9b:	a1 4c 99 11 c0       	mov    0xc011994c,%eax
c0101da0:	83 c0 01             	add    $0x1,%eax
c0101da3:	a3 4c 99 11 c0       	mov    %eax,0xc011994c
        if (ticks % TICK_NUM == 0) {
c0101da8:	8b 0d 4c 99 11 c0    	mov    0xc011994c,%ecx
c0101dae:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c0101db3:	89 c8                	mov    %ecx,%eax
c0101db5:	f7 e2                	mul    %edx
c0101db7:	89 d0                	mov    %edx,%eax
c0101db9:	c1 e8 05             	shr    $0x5,%eax
c0101dbc:	6b c0 64             	imul   $0x64,%eax,%eax
c0101dbf:	89 ca                	mov    %ecx,%edx
c0101dc1:	29 c2                	sub    %eax,%edx
c0101dc3:	89 d0                	mov    %edx,%eax
c0101dc5:	85 c0                	test   %eax,%eax
c0101dc7:	0f 85 ad 00 00 00    	jne    c0101e7a <trap_dispatch+0x122>
            print_ticks();
c0101dcd:	e8 36 fb ff ff       	call   c0101908 <print_ticks>
        }
        break;
c0101dd2:	e9 a3 00 00 00       	jmp    c0101e7a <trap_dispatch+0x122>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c0101dd7:	e8 e8 f8 ff ff       	call   c01016c4 <cons_getc>
c0101ddc:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c0101ddf:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101de3:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101de7:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101deb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101def:	c7 04 24 94 67 10 c0 	movl   $0xc0106794,(%esp)
c0101df6:	e8 4c e5 ff ff       	call   c0100347 <cprintf>
        break;
c0101dfb:	eb 7e                	jmp    c0101e7b <trap_dispatch+0x123>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0101dfd:	e8 c2 f8 ff ff       	call   c01016c4 <cons_getc>
c0101e02:	88 45 f7             	mov    %al,-0x9(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0101e05:	0f be 55 f7          	movsbl -0x9(%ebp),%edx
c0101e09:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c0101e0d:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101e11:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101e15:	c7 04 24 a6 67 10 c0 	movl   $0xc01067a6,(%esp)
c0101e1c:	e8 26 e5 ff ff       	call   c0100347 <cprintf>
        break;
c0101e21:	eb 58                	jmp    c0101e7b <trap_dispatch+0x123>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0101e23:	c7 44 24 08 b5 67 10 	movl   $0xc01067b5,0x8(%esp)
c0101e2a:	c0 
c0101e2b:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0101e32:	00 
c0101e33:	c7 04 24 c5 67 10 c0 	movl   $0xc01067c5,(%esp)
c0101e3a:	e8 69 ee ff ff       	call   c0100ca8 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0101e3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e42:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0101e46:	0f b7 c0             	movzwl %ax,%eax
c0101e49:	83 e0 03             	and    $0x3,%eax
c0101e4c:	85 c0                	test   %eax,%eax
c0101e4e:	75 2b                	jne    c0101e7b <trap_dispatch+0x123>
            print_trapframe(tf);
c0101e50:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e53:	89 04 24             	mov    %eax,(%esp)
c0101e56:	e8 81 fc ff ff       	call   c0101adc <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0101e5b:	c7 44 24 08 d6 67 10 	movl   $0xc01067d6,0x8(%esp)
c0101e62:	c0 
c0101e63:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0101e6a:	00 
c0101e6b:	c7 04 24 c5 67 10 c0 	movl   $0xc01067c5,(%esp)
c0101e72:	e8 31 ee ff ff       	call   c0100ca8 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0101e77:	90                   	nop
c0101e78:	eb 01                	jmp    c0101e7b <trap_dispatch+0x123>
         */
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }
        break;
c0101e7a:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0101e7b:	c9                   	leave  
c0101e7c:	c3                   	ret    

c0101e7d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0101e7d:	55                   	push   %ebp
c0101e7e:	89 e5                	mov    %esp,%ebp
c0101e80:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0101e83:	8b 45 08             	mov    0x8(%ebp),%eax
c0101e86:	89 04 24             	mov    %eax,(%esp)
c0101e89:	e8 ca fe ff ff       	call   c0101d58 <trap_dispatch>
}
c0101e8e:	c9                   	leave  
c0101e8f:	c3                   	ret    

c0101e90 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0101e90:	1e                   	push   %ds
    pushl %es
c0101e91:	06                   	push   %es
    pushl %fs
c0101e92:	0f a0                	push   %fs
    pushl %gs
c0101e94:	0f a8                	push   %gs
    pushal
c0101e96:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0101e97:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0101e9c:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0101e9e:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0101ea0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0101ea1:	e8 d7 ff ff ff       	call   c0101e7d <trap>

    # pop the pushed stack pointer
    popl %esp
c0101ea6:	5c                   	pop    %esp

c0101ea7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0101ea7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0101ea8:	0f a9                	pop    %gs
    popl %fs
c0101eaa:	0f a1                	pop    %fs
    popl %es
c0101eac:	07                   	pop    %es
    popl %ds
c0101ead:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0101eae:	83 c4 08             	add    $0x8,%esp
    iret
c0101eb1:	cf                   	iret   
	...

c0101eb4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0101eb4:	6a 00                	push   $0x0
  pushl $0
c0101eb6:	6a 00                	push   $0x0
  jmp __alltraps
c0101eb8:	e9 d3 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ebd <vector1>:
.globl vector1
vector1:
  pushl $0
c0101ebd:	6a 00                	push   $0x0
  pushl $1
c0101ebf:	6a 01                	push   $0x1
  jmp __alltraps
c0101ec1:	e9 ca ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ec6 <vector2>:
.globl vector2
vector2:
  pushl $0
c0101ec6:	6a 00                	push   $0x0
  pushl $2
c0101ec8:	6a 02                	push   $0x2
  jmp __alltraps
c0101eca:	e9 c1 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ecf <vector3>:
.globl vector3
vector3:
  pushl $0
c0101ecf:	6a 00                	push   $0x0
  pushl $3
c0101ed1:	6a 03                	push   $0x3
  jmp __alltraps
c0101ed3:	e9 b8 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ed8 <vector4>:
.globl vector4
vector4:
  pushl $0
c0101ed8:	6a 00                	push   $0x0
  pushl $4
c0101eda:	6a 04                	push   $0x4
  jmp __alltraps
c0101edc:	e9 af ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ee1 <vector5>:
.globl vector5
vector5:
  pushl $0
c0101ee1:	6a 00                	push   $0x0
  pushl $5
c0101ee3:	6a 05                	push   $0x5
  jmp __alltraps
c0101ee5:	e9 a6 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101eea <vector6>:
.globl vector6
vector6:
  pushl $0
c0101eea:	6a 00                	push   $0x0
  pushl $6
c0101eec:	6a 06                	push   $0x6
  jmp __alltraps
c0101eee:	e9 9d ff ff ff       	jmp    c0101e90 <__alltraps>

c0101ef3 <vector7>:
.globl vector7
vector7:
  pushl $0
c0101ef3:	6a 00                	push   $0x0
  pushl $7
c0101ef5:	6a 07                	push   $0x7
  jmp __alltraps
c0101ef7:	e9 94 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101efc <vector8>:
.globl vector8
vector8:
  pushl $8
c0101efc:	6a 08                	push   $0x8
  jmp __alltraps
c0101efe:	e9 8d ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f03 <vector9>:
.globl vector9
vector9:
  pushl $9
c0101f03:	6a 09                	push   $0x9
  jmp __alltraps
c0101f05:	e9 86 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f0a <vector10>:
.globl vector10
vector10:
  pushl $10
c0101f0a:	6a 0a                	push   $0xa
  jmp __alltraps
c0101f0c:	e9 7f ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f11 <vector11>:
.globl vector11
vector11:
  pushl $11
c0101f11:	6a 0b                	push   $0xb
  jmp __alltraps
c0101f13:	e9 78 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f18 <vector12>:
.globl vector12
vector12:
  pushl $12
c0101f18:	6a 0c                	push   $0xc
  jmp __alltraps
c0101f1a:	e9 71 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f1f <vector13>:
.globl vector13
vector13:
  pushl $13
c0101f1f:	6a 0d                	push   $0xd
  jmp __alltraps
c0101f21:	e9 6a ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f26 <vector14>:
.globl vector14
vector14:
  pushl $14
c0101f26:	6a 0e                	push   $0xe
  jmp __alltraps
c0101f28:	e9 63 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f2d <vector15>:
.globl vector15
vector15:
  pushl $0
c0101f2d:	6a 00                	push   $0x0
  pushl $15
c0101f2f:	6a 0f                	push   $0xf
  jmp __alltraps
c0101f31:	e9 5a ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f36 <vector16>:
.globl vector16
vector16:
  pushl $0
c0101f36:	6a 00                	push   $0x0
  pushl $16
c0101f38:	6a 10                	push   $0x10
  jmp __alltraps
c0101f3a:	e9 51 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f3f <vector17>:
.globl vector17
vector17:
  pushl $17
c0101f3f:	6a 11                	push   $0x11
  jmp __alltraps
c0101f41:	e9 4a ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f46 <vector18>:
.globl vector18
vector18:
  pushl $0
c0101f46:	6a 00                	push   $0x0
  pushl $18
c0101f48:	6a 12                	push   $0x12
  jmp __alltraps
c0101f4a:	e9 41 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f4f <vector19>:
.globl vector19
vector19:
  pushl $0
c0101f4f:	6a 00                	push   $0x0
  pushl $19
c0101f51:	6a 13                	push   $0x13
  jmp __alltraps
c0101f53:	e9 38 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f58 <vector20>:
.globl vector20
vector20:
  pushl $0
c0101f58:	6a 00                	push   $0x0
  pushl $20
c0101f5a:	6a 14                	push   $0x14
  jmp __alltraps
c0101f5c:	e9 2f ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f61 <vector21>:
.globl vector21
vector21:
  pushl $0
c0101f61:	6a 00                	push   $0x0
  pushl $21
c0101f63:	6a 15                	push   $0x15
  jmp __alltraps
c0101f65:	e9 26 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f6a <vector22>:
.globl vector22
vector22:
  pushl $0
c0101f6a:	6a 00                	push   $0x0
  pushl $22
c0101f6c:	6a 16                	push   $0x16
  jmp __alltraps
c0101f6e:	e9 1d ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f73 <vector23>:
.globl vector23
vector23:
  pushl $0
c0101f73:	6a 00                	push   $0x0
  pushl $23
c0101f75:	6a 17                	push   $0x17
  jmp __alltraps
c0101f77:	e9 14 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f7c <vector24>:
.globl vector24
vector24:
  pushl $0
c0101f7c:	6a 00                	push   $0x0
  pushl $24
c0101f7e:	6a 18                	push   $0x18
  jmp __alltraps
c0101f80:	e9 0b ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f85 <vector25>:
.globl vector25
vector25:
  pushl $0
c0101f85:	6a 00                	push   $0x0
  pushl $25
c0101f87:	6a 19                	push   $0x19
  jmp __alltraps
c0101f89:	e9 02 ff ff ff       	jmp    c0101e90 <__alltraps>

c0101f8e <vector26>:
.globl vector26
vector26:
  pushl $0
c0101f8e:	6a 00                	push   $0x0
  pushl $26
c0101f90:	6a 1a                	push   $0x1a
  jmp __alltraps
c0101f92:	e9 f9 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101f97 <vector27>:
.globl vector27
vector27:
  pushl $0
c0101f97:	6a 00                	push   $0x0
  pushl $27
c0101f99:	6a 1b                	push   $0x1b
  jmp __alltraps
c0101f9b:	e9 f0 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fa0 <vector28>:
.globl vector28
vector28:
  pushl $0
c0101fa0:	6a 00                	push   $0x0
  pushl $28
c0101fa2:	6a 1c                	push   $0x1c
  jmp __alltraps
c0101fa4:	e9 e7 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fa9 <vector29>:
.globl vector29
vector29:
  pushl $0
c0101fa9:	6a 00                	push   $0x0
  pushl $29
c0101fab:	6a 1d                	push   $0x1d
  jmp __alltraps
c0101fad:	e9 de fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fb2 <vector30>:
.globl vector30
vector30:
  pushl $0
c0101fb2:	6a 00                	push   $0x0
  pushl $30
c0101fb4:	6a 1e                	push   $0x1e
  jmp __alltraps
c0101fb6:	e9 d5 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fbb <vector31>:
.globl vector31
vector31:
  pushl $0
c0101fbb:	6a 00                	push   $0x0
  pushl $31
c0101fbd:	6a 1f                	push   $0x1f
  jmp __alltraps
c0101fbf:	e9 cc fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fc4 <vector32>:
.globl vector32
vector32:
  pushl $0
c0101fc4:	6a 00                	push   $0x0
  pushl $32
c0101fc6:	6a 20                	push   $0x20
  jmp __alltraps
c0101fc8:	e9 c3 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fcd <vector33>:
.globl vector33
vector33:
  pushl $0
c0101fcd:	6a 00                	push   $0x0
  pushl $33
c0101fcf:	6a 21                	push   $0x21
  jmp __alltraps
c0101fd1:	e9 ba fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fd6 <vector34>:
.globl vector34
vector34:
  pushl $0
c0101fd6:	6a 00                	push   $0x0
  pushl $34
c0101fd8:	6a 22                	push   $0x22
  jmp __alltraps
c0101fda:	e9 b1 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fdf <vector35>:
.globl vector35
vector35:
  pushl $0
c0101fdf:	6a 00                	push   $0x0
  pushl $35
c0101fe1:	6a 23                	push   $0x23
  jmp __alltraps
c0101fe3:	e9 a8 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101fe8 <vector36>:
.globl vector36
vector36:
  pushl $0
c0101fe8:	6a 00                	push   $0x0
  pushl $36
c0101fea:	6a 24                	push   $0x24
  jmp __alltraps
c0101fec:	e9 9f fe ff ff       	jmp    c0101e90 <__alltraps>

c0101ff1 <vector37>:
.globl vector37
vector37:
  pushl $0
c0101ff1:	6a 00                	push   $0x0
  pushl $37
c0101ff3:	6a 25                	push   $0x25
  jmp __alltraps
c0101ff5:	e9 96 fe ff ff       	jmp    c0101e90 <__alltraps>

c0101ffa <vector38>:
.globl vector38
vector38:
  pushl $0
c0101ffa:	6a 00                	push   $0x0
  pushl $38
c0101ffc:	6a 26                	push   $0x26
  jmp __alltraps
c0101ffe:	e9 8d fe ff ff       	jmp    c0101e90 <__alltraps>

c0102003 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102003:	6a 00                	push   $0x0
  pushl $39
c0102005:	6a 27                	push   $0x27
  jmp __alltraps
c0102007:	e9 84 fe ff ff       	jmp    c0101e90 <__alltraps>

c010200c <vector40>:
.globl vector40
vector40:
  pushl $0
c010200c:	6a 00                	push   $0x0
  pushl $40
c010200e:	6a 28                	push   $0x28
  jmp __alltraps
c0102010:	e9 7b fe ff ff       	jmp    c0101e90 <__alltraps>

c0102015 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102015:	6a 00                	push   $0x0
  pushl $41
c0102017:	6a 29                	push   $0x29
  jmp __alltraps
c0102019:	e9 72 fe ff ff       	jmp    c0101e90 <__alltraps>

c010201e <vector42>:
.globl vector42
vector42:
  pushl $0
c010201e:	6a 00                	push   $0x0
  pushl $42
c0102020:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102022:	e9 69 fe ff ff       	jmp    c0101e90 <__alltraps>

c0102027 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102027:	6a 00                	push   $0x0
  pushl $43
c0102029:	6a 2b                	push   $0x2b
  jmp __alltraps
c010202b:	e9 60 fe ff ff       	jmp    c0101e90 <__alltraps>

c0102030 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102030:	6a 00                	push   $0x0
  pushl $44
c0102032:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102034:	e9 57 fe ff ff       	jmp    c0101e90 <__alltraps>

c0102039 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102039:	6a 00                	push   $0x0
  pushl $45
c010203b:	6a 2d                	push   $0x2d
  jmp __alltraps
c010203d:	e9 4e fe ff ff       	jmp    c0101e90 <__alltraps>

c0102042 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102042:	6a 00                	push   $0x0
  pushl $46
c0102044:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102046:	e9 45 fe ff ff       	jmp    c0101e90 <__alltraps>

c010204b <vector47>:
.globl vector47
vector47:
  pushl $0
c010204b:	6a 00                	push   $0x0
  pushl $47
c010204d:	6a 2f                	push   $0x2f
  jmp __alltraps
c010204f:	e9 3c fe ff ff       	jmp    c0101e90 <__alltraps>

c0102054 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102054:	6a 00                	push   $0x0
  pushl $48
c0102056:	6a 30                	push   $0x30
  jmp __alltraps
c0102058:	e9 33 fe ff ff       	jmp    c0101e90 <__alltraps>

c010205d <vector49>:
.globl vector49
vector49:
  pushl $0
c010205d:	6a 00                	push   $0x0
  pushl $49
c010205f:	6a 31                	push   $0x31
  jmp __alltraps
c0102061:	e9 2a fe ff ff       	jmp    c0101e90 <__alltraps>

c0102066 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102066:	6a 00                	push   $0x0
  pushl $50
c0102068:	6a 32                	push   $0x32
  jmp __alltraps
c010206a:	e9 21 fe ff ff       	jmp    c0101e90 <__alltraps>

c010206f <vector51>:
.globl vector51
vector51:
  pushl $0
c010206f:	6a 00                	push   $0x0
  pushl $51
c0102071:	6a 33                	push   $0x33
  jmp __alltraps
c0102073:	e9 18 fe ff ff       	jmp    c0101e90 <__alltraps>

c0102078 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102078:	6a 00                	push   $0x0
  pushl $52
c010207a:	6a 34                	push   $0x34
  jmp __alltraps
c010207c:	e9 0f fe ff ff       	jmp    c0101e90 <__alltraps>

c0102081 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102081:	6a 00                	push   $0x0
  pushl $53
c0102083:	6a 35                	push   $0x35
  jmp __alltraps
c0102085:	e9 06 fe ff ff       	jmp    c0101e90 <__alltraps>

c010208a <vector54>:
.globl vector54
vector54:
  pushl $0
c010208a:	6a 00                	push   $0x0
  pushl $54
c010208c:	6a 36                	push   $0x36
  jmp __alltraps
c010208e:	e9 fd fd ff ff       	jmp    c0101e90 <__alltraps>

c0102093 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102093:	6a 00                	push   $0x0
  pushl $55
c0102095:	6a 37                	push   $0x37
  jmp __alltraps
c0102097:	e9 f4 fd ff ff       	jmp    c0101e90 <__alltraps>

c010209c <vector56>:
.globl vector56
vector56:
  pushl $0
c010209c:	6a 00                	push   $0x0
  pushl $56
c010209e:	6a 38                	push   $0x38
  jmp __alltraps
c01020a0:	e9 eb fd ff ff       	jmp    c0101e90 <__alltraps>

c01020a5 <vector57>:
.globl vector57
vector57:
  pushl $0
c01020a5:	6a 00                	push   $0x0
  pushl $57
c01020a7:	6a 39                	push   $0x39
  jmp __alltraps
c01020a9:	e9 e2 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020ae <vector58>:
.globl vector58
vector58:
  pushl $0
c01020ae:	6a 00                	push   $0x0
  pushl $58
c01020b0:	6a 3a                	push   $0x3a
  jmp __alltraps
c01020b2:	e9 d9 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020b7 <vector59>:
.globl vector59
vector59:
  pushl $0
c01020b7:	6a 00                	push   $0x0
  pushl $59
c01020b9:	6a 3b                	push   $0x3b
  jmp __alltraps
c01020bb:	e9 d0 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020c0 <vector60>:
.globl vector60
vector60:
  pushl $0
c01020c0:	6a 00                	push   $0x0
  pushl $60
c01020c2:	6a 3c                	push   $0x3c
  jmp __alltraps
c01020c4:	e9 c7 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020c9 <vector61>:
.globl vector61
vector61:
  pushl $0
c01020c9:	6a 00                	push   $0x0
  pushl $61
c01020cb:	6a 3d                	push   $0x3d
  jmp __alltraps
c01020cd:	e9 be fd ff ff       	jmp    c0101e90 <__alltraps>

c01020d2 <vector62>:
.globl vector62
vector62:
  pushl $0
c01020d2:	6a 00                	push   $0x0
  pushl $62
c01020d4:	6a 3e                	push   $0x3e
  jmp __alltraps
c01020d6:	e9 b5 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020db <vector63>:
.globl vector63
vector63:
  pushl $0
c01020db:	6a 00                	push   $0x0
  pushl $63
c01020dd:	6a 3f                	push   $0x3f
  jmp __alltraps
c01020df:	e9 ac fd ff ff       	jmp    c0101e90 <__alltraps>

c01020e4 <vector64>:
.globl vector64
vector64:
  pushl $0
c01020e4:	6a 00                	push   $0x0
  pushl $64
c01020e6:	6a 40                	push   $0x40
  jmp __alltraps
c01020e8:	e9 a3 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020ed <vector65>:
.globl vector65
vector65:
  pushl $0
c01020ed:	6a 00                	push   $0x0
  pushl $65
c01020ef:	6a 41                	push   $0x41
  jmp __alltraps
c01020f1:	e9 9a fd ff ff       	jmp    c0101e90 <__alltraps>

c01020f6 <vector66>:
.globl vector66
vector66:
  pushl $0
c01020f6:	6a 00                	push   $0x0
  pushl $66
c01020f8:	6a 42                	push   $0x42
  jmp __alltraps
c01020fa:	e9 91 fd ff ff       	jmp    c0101e90 <__alltraps>

c01020ff <vector67>:
.globl vector67
vector67:
  pushl $0
c01020ff:	6a 00                	push   $0x0
  pushl $67
c0102101:	6a 43                	push   $0x43
  jmp __alltraps
c0102103:	e9 88 fd ff ff       	jmp    c0101e90 <__alltraps>

c0102108 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102108:	6a 00                	push   $0x0
  pushl $68
c010210a:	6a 44                	push   $0x44
  jmp __alltraps
c010210c:	e9 7f fd ff ff       	jmp    c0101e90 <__alltraps>

c0102111 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102111:	6a 00                	push   $0x0
  pushl $69
c0102113:	6a 45                	push   $0x45
  jmp __alltraps
c0102115:	e9 76 fd ff ff       	jmp    c0101e90 <__alltraps>

c010211a <vector70>:
.globl vector70
vector70:
  pushl $0
c010211a:	6a 00                	push   $0x0
  pushl $70
c010211c:	6a 46                	push   $0x46
  jmp __alltraps
c010211e:	e9 6d fd ff ff       	jmp    c0101e90 <__alltraps>

c0102123 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102123:	6a 00                	push   $0x0
  pushl $71
c0102125:	6a 47                	push   $0x47
  jmp __alltraps
c0102127:	e9 64 fd ff ff       	jmp    c0101e90 <__alltraps>

c010212c <vector72>:
.globl vector72
vector72:
  pushl $0
c010212c:	6a 00                	push   $0x0
  pushl $72
c010212e:	6a 48                	push   $0x48
  jmp __alltraps
c0102130:	e9 5b fd ff ff       	jmp    c0101e90 <__alltraps>

c0102135 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102135:	6a 00                	push   $0x0
  pushl $73
c0102137:	6a 49                	push   $0x49
  jmp __alltraps
c0102139:	e9 52 fd ff ff       	jmp    c0101e90 <__alltraps>

c010213e <vector74>:
.globl vector74
vector74:
  pushl $0
c010213e:	6a 00                	push   $0x0
  pushl $74
c0102140:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102142:	e9 49 fd ff ff       	jmp    c0101e90 <__alltraps>

c0102147 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102147:	6a 00                	push   $0x0
  pushl $75
c0102149:	6a 4b                	push   $0x4b
  jmp __alltraps
c010214b:	e9 40 fd ff ff       	jmp    c0101e90 <__alltraps>

c0102150 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102150:	6a 00                	push   $0x0
  pushl $76
c0102152:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102154:	e9 37 fd ff ff       	jmp    c0101e90 <__alltraps>

c0102159 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102159:	6a 00                	push   $0x0
  pushl $77
c010215b:	6a 4d                	push   $0x4d
  jmp __alltraps
c010215d:	e9 2e fd ff ff       	jmp    c0101e90 <__alltraps>

c0102162 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102162:	6a 00                	push   $0x0
  pushl $78
c0102164:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102166:	e9 25 fd ff ff       	jmp    c0101e90 <__alltraps>

c010216b <vector79>:
.globl vector79
vector79:
  pushl $0
c010216b:	6a 00                	push   $0x0
  pushl $79
c010216d:	6a 4f                	push   $0x4f
  jmp __alltraps
c010216f:	e9 1c fd ff ff       	jmp    c0101e90 <__alltraps>

c0102174 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102174:	6a 00                	push   $0x0
  pushl $80
c0102176:	6a 50                	push   $0x50
  jmp __alltraps
c0102178:	e9 13 fd ff ff       	jmp    c0101e90 <__alltraps>

c010217d <vector81>:
.globl vector81
vector81:
  pushl $0
c010217d:	6a 00                	push   $0x0
  pushl $81
c010217f:	6a 51                	push   $0x51
  jmp __alltraps
c0102181:	e9 0a fd ff ff       	jmp    c0101e90 <__alltraps>

c0102186 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102186:	6a 00                	push   $0x0
  pushl $82
c0102188:	6a 52                	push   $0x52
  jmp __alltraps
c010218a:	e9 01 fd ff ff       	jmp    c0101e90 <__alltraps>

c010218f <vector83>:
.globl vector83
vector83:
  pushl $0
c010218f:	6a 00                	push   $0x0
  pushl $83
c0102191:	6a 53                	push   $0x53
  jmp __alltraps
c0102193:	e9 f8 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102198 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102198:	6a 00                	push   $0x0
  pushl $84
c010219a:	6a 54                	push   $0x54
  jmp __alltraps
c010219c:	e9 ef fc ff ff       	jmp    c0101e90 <__alltraps>

c01021a1 <vector85>:
.globl vector85
vector85:
  pushl $0
c01021a1:	6a 00                	push   $0x0
  pushl $85
c01021a3:	6a 55                	push   $0x55
  jmp __alltraps
c01021a5:	e9 e6 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021aa <vector86>:
.globl vector86
vector86:
  pushl $0
c01021aa:	6a 00                	push   $0x0
  pushl $86
c01021ac:	6a 56                	push   $0x56
  jmp __alltraps
c01021ae:	e9 dd fc ff ff       	jmp    c0101e90 <__alltraps>

c01021b3 <vector87>:
.globl vector87
vector87:
  pushl $0
c01021b3:	6a 00                	push   $0x0
  pushl $87
c01021b5:	6a 57                	push   $0x57
  jmp __alltraps
c01021b7:	e9 d4 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021bc <vector88>:
.globl vector88
vector88:
  pushl $0
c01021bc:	6a 00                	push   $0x0
  pushl $88
c01021be:	6a 58                	push   $0x58
  jmp __alltraps
c01021c0:	e9 cb fc ff ff       	jmp    c0101e90 <__alltraps>

c01021c5 <vector89>:
.globl vector89
vector89:
  pushl $0
c01021c5:	6a 00                	push   $0x0
  pushl $89
c01021c7:	6a 59                	push   $0x59
  jmp __alltraps
c01021c9:	e9 c2 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021ce <vector90>:
.globl vector90
vector90:
  pushl $0
c01021ce:	6a 00                	push   $0x0
  pushl $90
c01021d0:	6a 5a                	push   $0x5a
  jmp __alltraps
c01021d2:	e9 b9 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021d7 <vector91>:
.globl vector91
vector91:
  pushl $0
c01021d7:	6a 00                	push   $0x0
  pushl $91
c01021d9:	6a 5b                	push   $0x5b
  jmp __alltraps
c01021db:	e9 b0 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021e0 <vector92>:
.globl vector92
vector92:
  pushl $0
c01021e0:	6a 00                	push   $0x0
  pushl $92
c01021e2:	6a 5c                	push   $0x5c
  jmp __alltraps
c01021e4:	e9 a7 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021e9 <vector93>:
.globl vector93
vector93:
  pushl $0
c01021e9:	6a 00                	push   $0x0
  pushl $93
c01021eb:	6a 5d                	push   $0x5d
  jmp __alltraps
c01021ed:	e9 9e fc ff ff       	jmp    c0101e90 <__alltraps>

c01021f2 <vector94>:
.globl vector94
vector94:
  pushl $0
c01021f2:	6a 00                	push   $0x0
  pushl $94
c01021f4:	6a 5e                	push   $0x5e
  jmp __alltraps
c01021f6:	e9 95 fc ff ff       	jmp    c0101e90 <__alltraps>

c01021fb <vector95>:
.globl vector95
vector95:
  pushl $0
c01021fb:	6a 00                	push   $0x0
  pushl $95
c01021fd:	6a 5f                	push   $0x5f
  jmp __alltraps
c01021ff:	e9 8c fc ff ff       	jmp    c0101e90 <__alltraps>

c0102204 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102204:	6a 00                	push   $0x0
  pushl $96
c0102206:	6a 60                	push   $0x60
  jmp __alltraps
c0102208:	e9 83 fc ff ff       	jmp    c0101e90 <__alltraps>

c010220d <vector97>:
.globl vector97
vector97:
  pushl $0
c010220d:	6a 00                	push   $0x0
  pushl $97
c010220f:	6a 61                	push   $0x61
  jmp __alltraps
c0102211:	e9 7a fc ff ff       	jmp    c0101e90 <__alltraps>

c0102216 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102216:	6a 00                	push   $0x0
  pushl $98
c0102218:	6a 62                	push   $0x62
  jmp __alltraps
c010221a:	e9 71 fc ff ff       	jmp    c0101e90 <__alltraps>

c010221f <vector99>:
.globl vector99
vector99:
  pushl $0
c010221f:	6a 00                	push   $0x0
  pushl $99
c0102221:	6a 63                	push   $0x63
  jmp __alltraps
c0102223:	e9 68 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102228 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102228:	6a 00                	push   $0x0
  pushl $100
c010222a:	6a 64                	push   $0x64
  jmp __alltraps
c010222c:	e9 5f fc ff ff       	jmp    c0101e90 <__alltraps>

c0102231 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102231:	6a 00                	push   $0x0
  pushl $101
c0102233:	6a 65                	push   $0x65
  jmp __alltraps
c0102235:	e9 56 fc ff ff       	jmp    c0101e90 <__alltraps>

c010223a <vector102>:
.globl vector102
vector102:
  pushl $0
c010223a:	6a 00                	push   $0x0
  pushl $102
c010223c:	6a 66                	push   $0x66
  jmp __alltraps
c010223e:	e9 4d fc ff ff       	jmp    c0101e90 <__alltraps>

c0102243 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102243:	6a 00                	push   $0x0
  pushl $103
c0102245:	6a 67                	push   $0x67
  jmp __alltraps
c0102247:	e9 44 fc ff ff       	jmp    c0101e90 <__alltraps>

c010224c <vector104>:
.globl vector104
vector104:
  pushl $0
c010224c:	6a 00                	push   $0x0
  pushl $104
c010224e:	6a 68                	push   $0x68
  jmp __alltraps
c0102250:	e9 3b fc ff ff       	jmp    c0101e90 <__alltraps>

c0102255 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102255:	6a 00                	push   $0x0
  pushl $105
c0102257:	6a 69                	push   $0x69
  jmp __alltraps
c0102259:	e9 32 fc ff ff       	jmp    c0101e90 <__alltraps>

c010225e <vector106>:
.globl vector106
vector106:
  pushl $0
c010225e:	6a 00                	push   $0x0
  pushl $106
c0102260:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102262:	e9 29 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102267 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102267:	6a 00                	push   $0x0
  pushl $107
c0102269:	6a 6b                	push   $0x6b
  jmp __alltraps
c010226b:	e9 20 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102270 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102270:	6a 00                	push   $0x0
  pushl $108
c0102272:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102274:	e9 17 fc ff ff       	jmp    c0101e90 <__alltraps>

c0102279 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102279:	6a 00                	push   $0x0
  pushl $109
c010227b:	6a 6d                	push   $0x6d
  jmp __alltraps
c010227d:	e9 0e fc ff ff       	jmp    c0101e90 <__alltraps>

c0102282 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102282:	6a 00                	push   $0x0
  pushl $110
c0102284:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102286:	e9 05 fc ff ff       	jmp    c0101e90 <__alltraps>

c010228b <vector111>:
.globl vector111
vector111:
  pushl $0
c010228b:	6a 00                	push   $0x0
  pushl $111
c010228d:	6a 6f                	push   $0x6f
  jmp __alltraps
c010228f:	e9 fc fb ff ff       	jmp    c0101e90 <__alltraps>

c0102294 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102294:	6a 00                	push   $0x0
  pushl $112
c0102296:	6a 70                	push   $0x70
  jmp __alltraps
c0102298:	e9 f3 fb ff ff       	jmp    c0101e90 <__alltraps>

c010229d <vector113>:
.globl vector113
vector113:
  pushl $0
c010229d:	6a 00                	push   $0x0
  pushl $113
c010229f:	6a 71                	push   $0x71
  jmp __alltraps
c01022a1:	e9 ea fb ff ff       	jmp    c0101e90 <__alltraps>

c01022a6 <vector114>:
.globl vector114
vector114:
  pushl $0
c01022a6:	6a 00                	push   $0x0
  pushl $114
c01022a8:	6a 72                	push   $0x72
  jmp __alltraps
c01022aa:	e9 e1 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022af <vector115>:
.globl vector115
vector115:
  pushl $0
c01022af:	6a 00                	push   $0x0
  pushl $115
c01022b1:	6a 73                	push   $0x73
  jmp __alltraps
c01022b3:	e9 d8 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022b8 <vector116>:
.globl vector116
vector116:
  pushl $0
c01022b8:	6a 00                	push   $0x0
  pushl $116
c01022ba:	6a 74                	push   $0x74
  jmp __alltraps
c01022bc:	e9 cf fb ff ff       	jmp    c0101e90 <__alltraps>

c01022c1 <vector117>:
.globl vector117
vector117:
  pushl $0
c01022c1:	6a 00                	push   $0x0
  pushl $117
c01022c3:	6a 75                	push   $0x75
  jmp __alltraps
c01022c5:	e9 c6 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022ca <vector118>:
.globl vector118
vector118:
  pushl $0
c01022ca:	6a 00                	push   $0x0
  pushl $118
c01022cc:	6a 76                	push   $0x76
  jmp __alltraps
c01022ce:	e9 bd fb ff ff       	jmp    c0101e90 <__alltraps>

c01022d3 <vector119>:
.globl vector119
vector119:
  pushl $0
c01022d3:	6a 00                	push   $0x0
  pushl $119
c01022d5:	6a 77                	push   $0x77
  jmp __alltraps
c01022d7:	e9 b4 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022dc <vector120>:
.globl vector120
vector120:
  pushl $0
c01022dc:	6a 00                	push   $0x0
  pushl $120
c01022de:	6a 78                	push   $0x78
  jmp __alltraps
c01022e0:	e9 ab fb ff ff       	jmp    c0101e90 <__alltraps>

c01022e5 <vector121>:
.globl vector121
vector121:
  pushl $0
c01022e5:	6a 00                	push   $0x0
  pushl $121
c01022e7:	6a 79                	push   $0x79
  jmp __alltraps
c01022e9:	e9 a2 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022ee <vector122>:
.globl vector122
vector122:
  pushl $0
c01022ee:	6a 00                	push   $0x0
  pushl $122
c01022f0:	6a 7a                	push   $0x7a
  jmp __alltraps
c01022f2:	e9 99 fb ff ff       	jmp    c0101e90 <__alltraps>

c01022f7 <vector123>:
.globl vector123
vector123:
  pushl $0
c01022f7:	6a 00                	push   $0x0
  pushl $123
c01022f9:	6a 7b                	push   $0x7b
  jmp __alltraps
c01022fb:	e9 90 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102300 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102300:	6a 00                	push   $0x0
  pushl $124
c0102302:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102304:	e9 87 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102309 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102309:	6a 00                	push   $0x0
  pushl $125
c010230b:	6a 7d                	push   $0x7d
  jmp __alltraps
c010230d:	e9 7e fb ff ff       	jmp    c0101e90 <__alltraps>

c0102312 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102312:	6a 00                	push   $0x0
  pushl $126
c0102314:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102316:	e9 75 fb ff ff       	jmp    c0101e90 <__alltraps>

c010231b <vector127>:
.globl vector127
vector127:
  pushl $0
c010231b:	6a 00                	push   $0x0
  pushl $127
c010231d:	6a 7f                	push   $0x7f
  jmp __alltraps
c010231f:	e9 6c fb ff ff       	jmp    c0101e90 <__alltraps>

c0102324 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102324:	6a 00                	push   $0x0
  pushl $128
c0102326:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c010232b:	e9 60 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102330 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102330:	6a 00                	push   $0x0
  pushl $129
c0102332:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102337:	e9 54 fb ff ff       	jmp    c0101e90 <__alltraps>

c010233c <vector130>:
.globl vector130
vector130:
  pushl $0
c010233c:	6a 00                	push   $0x0
  pushl $130
c010233e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102343:	e9 48 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102348 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102348:	6a 00                	push   $0x0
  pushl $131
c010234a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c010234f:	e9 3c fb ff ff       	jmp    c0101e90 <__alltraps>

c0102354 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102354:	6a 00                	push   $0x0
  pushl $132
c0102356:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c010235b:	e9 30 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102360 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102360:	6a 00                	push   $0x0
  pushl $133
c0102362:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102367:	e9 24 fb ff ff       	jmp    c0101e90 <__alltraps>

c010236c <vector134>:
.globl vector134
vector134:
  pushl $0
c010236c:	6a 00                	push   $0x0
  pushl $134
c010236e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102373:	e9 18 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102378 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102378:	6a 00                	push   $0x0
  pushl $135
c010237a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c010237f:	e9 0c fb ff ff       	jmp    c0101e90 <__alltraps>

c0102384 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102384:	6a 00                	push   $0x0
  pushl $136
c0102386:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010238b:	e9 00 fb ff ff       	jmp    c0101e90 <__alltraps>

c0102390 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102390:	6a 00                	push   $0x0
  pushl $137
c0102392:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102397:	e9 f4 fa ff ff       	jmp    c0101e90 <__alltraps>

c010239c <vector138>:
.globl vector138
vector138:
  pushl $0
c010239c:	6a 00                	push   $0x0
  pushl $138
c010239e:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c01023a3:	e9 e8 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023a8 <vector139>:
.globl vector139
vector139:
  pushl $0
c01023a8:	6a 00                	push   $0x0
  pushl $139
c01023aa:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c01023af:	e9 dc fa ff ff       	jmp    c0101e90 <__alltraps>

c01023b4 <vector140>:
.globl vector140
vector140:
  pushl $0
c01023b4:	6a 00                	push   $0x0
  pushl $140
c01023b6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c01023bb:	e9 d0 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023c0 <vector141>:
.globl vector141
vector141:
  pushl $0
c01023c0:	6a 00                	push   $0x0
  pushl $141
c01023c2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c01023c7:	e9 c4 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023cc <vector142>:
.globl vector142
vector142:
  pushl $0
c01023cc:	6a 00                	push   $0x0
  pushl $142
c01023ce:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c01023d3:	e9 b8 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023d8 <vector143>:
.globl vector143
vector143:
  pushl $0
c01023d8:	6a 00                	push   $0x0
  pushl $143
c01023da:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c01023df:	e9 ac fa ff ff       	jmp    c0101e90 <__alltraps>

c01023e4 <vector144>:
.globl vector144
vector144:
  pushl $0
c01023e4:	6a 00                	push   $0x0
  pushl $144
c01023e6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c01023eb:	e9 a0 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023f0 <vector145>:
.globl vector145
vector145:
  pushl $0
c01023f0:	6a 00                	push   $0x0
  pushl $145
c01023f2:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c01023f7:	e9 94 fa ff ff       	jmp    c0101e90 <__alltraps>

c01023fc <vector146>:
.globl vector146
vector146:
  pushl $0
c01023fc:	6a 00                	push   $0x0
  pushl $146
c01023fe:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102403:	e9 88 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102408 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102408:	6a 00                	push   $0x0
  pushl $147
c010240a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c010240f:	e9 7c fa ff ff       	jmp    c0101e90 <__alltraps>

c0102414 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102414:	6a 00                	push   $0x0
  pushl $148
c0102416:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c010241b:	e9 70 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102420 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102420:	6a 00                	push   $0x0
  pushl $149
c0102422:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102427:	e9 64 fa ff ff       	jmp    c0101e90 <__alltraps>

c010242c <vector150>:
.globl vector150
vector150:
  pushl $0
c010242c:	6a 00                	push   $0x0
  pushl $150
c010242e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102433:	e9 58 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102438 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102438:	6a 00                	push   $0x0
  pushl $151
c010243a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c010243f:	e9 4c fa ff ff       	jmp    c0101e90 <__alltraps>

c0102444 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102444:	6a 00                	push   $0x0
  pushl $152
c0102446:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c010244b:	e9 40 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102450 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102450:	6a 00                	push   $0x0
  pushl $153
c0102452:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102457:	e9 34 fa ff ff       	jmp    c0101e90 <__alltraps>

c010245c <vector154>:
.globl vector154
vector154:
  pushl $0
c010245c:	6a 00                	push   $0x0
  pushl $154
c010245e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102463:	e9 28 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102468 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102468:	6a 00                	push   $0x0
  pushl $155
c010246a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c010246f:	e9 1c fa ff ff       	jmp    c0101e90 <__alltraps>

c0102474 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102474:	6a 00                	push   $0x0
  pushl $156
c0102476:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010247b:	e9 10 fa ff ff       	jmp    c0101e90 <__alltraps>

c0102480 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102480:	6a 00                	push   $0x0
  pushl $157
c0102482:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102487:	e9 04 fa ff ff       	jmp    c0101e90 <__alltraps>

c010248c <vector158>:
.globl vector158
vector158:
  pushl $0
c010248c:	6a 00                	push   $0x0
  pushl $158
c010248e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102493:	e9 f8 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102498 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102498:	6a 00                	push   $0x0
  pushl $159
c010249a:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c010249f:	e9 ec f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024a4 <vector160>:
.globl vector160
vector160:
  pushl $0
c01024a4:	6a 00                	push   $0x0
  pushl $160
c01024a6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c01024ab:	e9 e0 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024b0 <vector161>:
.globl vector161
vector161:
  pushl $0
c01024b0:	6a 00                	push   $0x0
  pushl $161
c01024b2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c01024b7:	e9 d4 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024bc <vector162>:
.globl vector162
vector162:
  pushl $0
c01024bc:	6a 00                	push   $0x0
  pushl $162
c01024be:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c01024c3:	e9 c8 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024c8 <vector163>:
.globl vector163
vector163:
  pushl $0
c01024c8:	6a 00                	push   $0x0
  pushl $163
c01024ca:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c01024cf:	e9 bc f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024d4 <vector164>:
.globl vector164
vector164:
  pushl $0
c01024d4:	6a 00                	push   $0x0
  pushl $164
c01024d6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c01024db:	e9 b0 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024e0 <vector165>:
.globl vector165
vector165:
  pushl $0
c01024e0:	6a 00                	push   $0x0
  pushl $165
c01024e2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c01024e7:	e9 a4 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024ec <vector166>:
.globl vector166
vector166:
  pushl $0
c01024ec:	6a 00                	push   $0x0
  pushl $166
c01024ee:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c01024f3:	e9 98 f9 ff ff       	jmp    c0101e90 <__alltraps>

c01024f8 <vector167>:
.globl vector167
vector167:
  pushl $0
c01024f8:	6a 00                	push   $0x0
  pushl $167
c01024fa:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c01024ff:	e9 8c f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102504 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102504:	6a 00                	push   $0x0
  pushl $168
c0102506:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010250b:	e9 80 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102510 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102510:	6a 00                	push   $0x0
  pushl $169
c0102512:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102517:	e9 74 f9 ff ff       	jmp    c0101e90 <__alltraps>

c010251c <vector170>:
.globl vector170
vector170:
  pushl $0
c010251c:	6a 00                	push   $0x0
  pushl $170
c010251e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102523:	e9 68 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102528 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102528:	6a 00                	push   $0x0
  pushl $171
c010252a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c010252f:	e9 5c f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102534 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102534:	6a 00                	push   $0x0
  pushl $172
c0102536:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c010253b:	e9 50 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102540 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102540:	6a 00                	push   $0x0
  pushl $173
c0102542:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102547:	e9 44 f9 ff ff       	jmp    c0101e90 <__alltraps>

c010254c <vector174>:
.globl vector174
vector174:
  pushl $0
c010254c:	6a 00                	push   $0x0
  pushl $174
c010254e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102553:	e9 38 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102558 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102558:	6a 00                	push   $0x0
  pushl $175
c010255a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c010255f:	e9 2c f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102564 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102564:	6a 00                	push   $0x0
  pushl $176
c0102566:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c010256b:	e9 20 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102570 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102570:	6a 00                	push   $0x0
  pushl $177
c0102572:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102577:	e9 14 f9 ff ff       	jmp    c0101e90 <__alltraps>

c010257c <vector178>:
.globl vector178
vector178:
  pushl $0
c010257c:	6a 00                	push   $0x0
  pushl $178
c010257e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102583:	e9 08 f9 ff ff       	jmp    c0101e90 <__alltraps>

c0102588 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102588:	6a 00                	push   $0x0
  pushl $179
c010258a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c010258f:	e9 fc f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102594 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102594:	6a 00                	push   $0x0
  pushl $180
c0102596:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010259b:	e9 f0 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025a0 <vector181>:
.globl vector181
vector181:
  pushl $0
c01025a0:	6a 00                	push   $0x0
  pushl $181
c01025a2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c01025a7:	e9 e4 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025ac <vector182>:
.globl vector182
vector182:
  pushl $0
c01025ac:	6a 00                	push   $0x0
  pushl $182
c01025ae:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c01025b3:	e9 d8 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025b8 <vector183>:
.globl vector183
vector183:
  pushl $0
c01025b8:	6a 00                	push   $0x0
  pushl $183
c01025ba:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c01025bf:	e9 cc f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025c4 <vector184>:
.globl vector184
vector184:
  pushl $0
c01025c4:	6a 00                	push   $0x0
  pushl $184
c01025c6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c01025cb:	e9 c0 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025d0 <vector185>:
.globl vector185
vector185:
  pushl $0
c01025d0:	6a 00                	push   $0x0
  pushl $185
c01025d2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c01025d7:	e9 b4 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025dc <vector186>:
.globl vector186
vector186:
  pushl $0
c01025dc:	6a 00                	push   $0x0
  pushl $186
c01025de:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c01025e3:	e9 a8 f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025e8 <vector187>:
.globl vector187
vector187:
  pushl $0
c01025e8:	6a 00                	push   $0x0
  pushl $187
c01025ea:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c01025ef:	e9 9c f8 ff ff       	jmp    c0101e90 <__alltraps>

c01025f4 <vector188>:
.globl vector188
vector188:
  pushl $0
c01025f4:	6a 00                	push   $0x0
  pushl $188
c01025f6:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c01025fb:	e9 90 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102600 <vector189>:
.globl vector189
vector189:
  pushl $0
c0102600:	6a 00                	push   $0x0
  pushl $189
c0102602:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0102607:	e9 84 f8 ff ff       	jmp    c0101e90 <__alltraps>

c010260c <vector190>:
.globl vector190
vector190:
  pushl $0
c010260c:	6a 00                	push   $0x0
  pushl $190
c010260e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0102613:	e9 78 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102618 <vector191>:
.globl vector191
vector191:
  pushl $0
c0102618:	6a 00                	push   $0x0
  pushl $191
c010261a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010261f:	e9 6c f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102624 <vector192>:
.globl vector192
vector192:
  pushl $0
c0102624:	6a 00                	push   $0x0
  pushl $192
c0102626:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010262b:	e9 60 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102630 <vector193>:
.globl vector193
vector193:
  pushl $0
c0102630:	6a 00                	push   $0x0
  pushl $193
c0102632:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0102637:	e9 54 f8 ff ff       	jmp    c0101e90 <__alltraps>

c010263c <vector194>:
.globl vector194
vector194:
  pushl $0
c010263c:	6a 00                	push   $0x0
  pushl $194
c010263e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0102643:	e9 48 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102648 <vector195>:
.globl vector195
vector195:
  pushl $0
c0102648:	6a 00                	push   $0x0
  pushl $195
c010264a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010264f:	e9 3c f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102654 <vector196>:
.globl vector196
vector196:
  pushl $0
c0102654:	6a 00                	push   $0x0
  pushl $196
c0102656:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010265b:	e9 30 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102660 <vector197>:
.globl vector197
vector197:
  pushl $0
c0102660:	6a 00                	push   $0x0
  pushl $197
c0102662:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0102667:	e9 24 f8 ff ff       	jmp    c0101e90 <__alltraps>

c010266c <vector198>:
.globl vector198
vector198:
  pushl $0
c010266c:	6a 00                	push   $0x0
  pushl $198
c010266e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0102673:	e9 18 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102678 <vector199>:
.globl vector199
vector199:
  pushl $0
c0102678:	6a 00                	push   $0x0
  pushl $199
c010267a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010267f:	e9 0c f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102684 <vector200>:
.globl vector200
vector200:
  pushl $0
c0102684:	6a 00                	push   $0x0
  pushl $200
c0102686:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010268b:	e9 00 f8 ff ff       	jmp    c0101e90 <__alltraps>

c0102690 <vector201>:
.globl vector201
vector201:
  pushl $0
c0102690:	6a 00                	push   $0x0
  pushl $201
c0102692:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c0102697:	e9 f4 f7 ff ff       	jmp    c0101e90 <__alltraps>

c010269c <vector202>:
.globl vector202
vector202:
  pushl $0
c010269c:	6a 00                	push   $0x0
  pushl $202
c010269e:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01026a3:	e9 e8 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026a8 <vector203>:
.globl vector203
vector203:
  pushl $0
c01026a8:	6a 00                	push   $0x0
  pushl $203
c01026aa:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01026af:	e9 dc f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026b4 <vector204>:
.globl vector204
vector204:
  pushl $0
c01026b4:	6a 00                	push   $0x0
  pushl $204
c01026b6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01026bb:	e9 d0 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026c0 <vector205>:
.globl vector205
vector205:
  pushl $0
c01026c0:	6a 00                	push   $0x0
  pushl $205
c01026c2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01026c7:	e9 c4 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026cc <vector206>:
.globl vector206
vector206:
  pushl $0
c01026cc:	6a 00                	push   $0x0
  pushl $206
c01026ce:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01026d3:	e9 b8 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026d8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01026d8:	6a 00                	push   $0x0
  pushl $207
c01026da:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01026df:	e9 ac f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026e4 <vector208>:
.globl vector208
vector208:
  pushl $0
c01026e4:	6a 00                	push   $0x0
  pushl $208
c01026e6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01026eb:	e9 a0 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026f0 <vector209>:
.globl vector209
vector209:
  pushl $0
c01026f0:	6a 00                	push   $0x0
  pushl $209
c01026f2:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c01026f7:	e9 94 f7 ff ff       	jmp    c0101e90 <__alltraps>

c01026fc <vector210>:
.globl vector210
vector210:
  pushl $0
c01026fc:	6a 00                	push   $0x0
  pushl $210
c01026fe:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0102703:	e9 88 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102708 <vector211>:
.globl vector211
vector211:
  pushl $0
c0102708:	6a 00                	push   $0x0
  pushl $211
c010270a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010270f:	e9 7c f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102714 <vector212>:
.globl vector212
vector212:
  pushl $0
c0102714:	6a 00                	push   $0x0
  pushl $212
c0102716:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010271b:	e9 70 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102720 <vector213>:
.globl vector213
vector213:
  pushl $0
c0102720:	6a 00                	push   $0x0
  pushl $213
c0102722:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0102727:	e9 64 f7 ff ff       	jmp    c0101e90 <__alltraps>

c010272c <vector214>:
.globl vector214
vector214:
  pushl $0
c010272c:	6a 00                	push   $0x0
  pushl $214
c010272e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0102733:	e9 58 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102738 <vector215>:
.globl vector215
vector215:
  pushl $0
c0102738:	6a 00                	push   $0x0
  pushl $215
c010273a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010273f:	e9 4c f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102744 <vector216>:
.globl vector216
vector216:
  pushl $0
c0102744:	6a 00                	push   $0x0
  pushl $216
c0102746:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010274b:	e9 40 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102750 <vector217>:
.globl vector217
vector217:
  pushl $0
c0102750:	6a 00                	push   $0x0
  pushl $217
c0102752:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0102757:	e9 34 f7 ff ff       	jmp    c0101e90 <__alltraps>

c010275c <vector218>:
.globl vector218
vector218:
  pushl $0
c010275c:	6a 00                	push   $0x0
  pushl $218
c010275e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0102763:	e9 28 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102768 <vector219>:
.globl vector219
vector219:
  pushl $0
c0102768:	6a 00                	push   $0x0
  pushl $219
c010276a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010276f:	e9 1c f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102774 <vector220>:
.globl vector220
vector220:
  pushl $0
c0102774:	6a 00                	push   $0x0
  pushl $220
c0102776:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010277b:	e9 10 f7 ff ff       	jmp    c0101e90 <__alltraps>

c0102780 <vector221>:
.globl vector221
vector221:
  pushl $0
c0102780:	6a 00                	push   $0x0
  pushl $221
c0102782:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0102787:	e9 04 f7 ff ff       	jmp    c0101e90 <__alltraps>

c010278c <vector222>:
.globl vector222
vector222:
  pushl $0
c010278c:	6a 00                	push   $0x0
  pushl $222
c010278e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0102793:	e9 f8 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102798 <vector223>:
.globl vector223
vector223:
  pushl $0
c0102798:	6a 00                	push   $0x0
  pushl $223
c010279a:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c010279f:	e9 ec f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027a4 <vector224>:
.globl vector224
vector224:
  pushl $0
c01027a4:	6a 00                	push   $0x0
  pushl $224
c01027a6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01027ab:	e9 e0 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027b0 <vector225>:
.globl vector225
vector225:
  pushl $0
c01027b0:	6a 00                	push   $0x0
  pushl $225
c01027b2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01027b7:	e9 d4 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027bc <vector226>:
.globl vector226
vector226:
  pushl $0
c01027bc:	6a 00                	push   $0x0
  pushl $226
c01027be:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01027c3:	e9 c8 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027c8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01027c8:	6a 00                	push   $0x0
  pushl $227
c01027ca:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01027cf:	e9 bc f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027d4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01027d4:	6a 00                	push   $0x0
  pushl $228
c01027d6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01027db:	e9 b0 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027e0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01027e0:	6a 00                	push   $0x0
  pushl $229
c01027e2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01027e7:	e9 a4 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027ec <vector230>:
.globl vector230
vector230:
  pushl $0
c01027ec:	6a 00                	push   $0x0
  pushl $230
c01027ee:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c01027f3:	e9 98 f6 ff ff       	jmp    c0101e90 <__alltraps>

c01027f8 <vector231>:
.globl vector231
vector231:
  pushl $0
c01027f8:	6a 00                	push   $0x0
  pushl $231
c01027fa:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c01027ff:	e9 8c f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102804 <vector232>:
.globl vector232
vector232:
  pushl $0
c0102804:	6a 00                	push   $0x0
  pushl $232
c0102806:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010280b:	e9 80 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102810 <vector233>:
.globl vector233
vector233:
  pushl $0
c0102810:	6a 00                	push   $0x0
  pushl $233
c0102812:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0102817:	e9 74 f6 ff ff       	jmp    c0101e90 <__alltraps>

c010281c <vector234>:
.globl vector234
vector234:
  pushl $0
c010281c:	6a 00                	push   $0x0
  pushl $234
c010281e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0102823:	e9 68 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102828 <vector235>:
.globl vector235
vector235:
  pushl $0
c0102828:	6a 00                	push   $0x0
  pushl $235
c010282a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010282f:	e9 5c f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102834 <vector236>:
.globl vector236
vector236:
  pushl $0
c0102834:	6a 00                	push   $0x0
  pushl $236
c0102836:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010283b:	e9 50 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102840 <vector237>:
.globl vector237
vector237:
  pushl $0
c0102840:	6a 00                	push   $0x0
  pushl $237
c0102842:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0102847:	e9 44 f6 ff ff       	jmp    c0101e90 <__alltraps>

c010284c <vector238>:
.globl vector238
vector238:
  pushl $0
c010284c:	6a 00                	push   $0x0
  pushl $238
c010284e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0102853:	e9 38 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102858 <vector239>:
.globl vector239
vector239:
  pushl $0
c0102858:	6a 00                	push   $0x0
  pushl $239
c010285a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010285f:	e9 2c f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102864 <vector240>:
.globl vector240
vector240:
  pushl $0
c0102864:	6a 00                	push   $0x0
  pushl $240
c0102866:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010286b:	e9 20 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102870 <vector241>:
.globl vector241
vector241:
  pushl $0
c0102870:	6a 00                	push   $0x0
  pushl $241
c0102872:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0102877:	e9 14 f6 ff ff       	jmp    c0101e90 <__alltraps>

c010287c <vector242>:
.globl vector242
vector242:
  pushl $0
c010287c:	6a 00                	push   $0x0
  pushl $242
c010287e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0102883:	e9 08 f6 ff ff       	jmp    c0101e90 <__alltraps>

c0102888 <vector243>:
.globl vector243
vector243:
  pushl $0
c0102888:	6a 00                	push   $0x0
  pushl $243
c010288a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010288f:	e9 fc f5 ff ff       	jmp    c0101e90 <__alltraps>

c0102894 <vector244>:
.globl vector244
vector244:
  pushl $0
c0102894:	6a 00                	push   $0x0
  pushl $244
c0102896:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010289b:	e9 f0 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028a0 <vector245>:
.globl vector245
vector245:
  pushl $0
c01028a0:	6a 00                	push   $0x0
  pushl $245
c01028a2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01028a7:	e9 e4 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028ac <vector246>:
.globl vector246
vector246:
  pushl $0
c01028ac:	6a 00                	push   $0x0
  pushl $246
c01028ae:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01028b3:	e9 d8 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028b8 <vector247>:
.globl vector247
vector247:
  pushl $0
c01028b8:	6a 00                	push   $0x0
  pushl $247
c01028ba:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01028bf:	e9 cc f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028c4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $248
c01028c6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01028cb:	e9 c0 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028d0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01028d0:	6a 00                	push   $0x0
  pushl $249
c01028d2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01028d7:	e9 b4 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028dc <vector250>:
.globl vector250
vector250:
  pushl $0
c01028dc:	6a 00                	push   $0x0
  pushl $250
c01028de:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01028e3:	e9 a8 f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028e8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $251
c01028ea:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01028ef:	e9 9c f5 ff ff       	jmp    c0101e90 <__alltraps>

c01028f4 <vector252>:
.globl vector252
vector252:
  pushl $0
c01028f4:	6a 00                	push   $0x0
  pushl $252
c01028f6:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c01028fb:	e9 90 f5 ff ff       	jmp    c0101e90 <__alltraps>

c0102900 <vector253>:
.globl vector253
vector253:
  pushl $0
c0102900:	6a 00                	push   $0x0
  pushl $253
c0102902:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0102907:	e9 84 f5 ff ff       	jmp    c0101e90 <__alltraps>

c010290c <vector254>:
.globl vector254
vector254:
  pushl $0
c010290c:	6a 00                	push   $0x0
  pushl $254
c010290e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0102913:	e9 78 f5 ff ff       	jmp    c0101e90 <__alltraps>

c0102918 <vector255>:
.globl vector255
vector255:
  pushl $0
c0102918:	6a 00                	push   $0x0
  pushl $255
c010291a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010291f:	e9 6c f5 ff ff       	jmp    c0101e90 <__alltraps>

c0102924 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0102924:	55                   	push   %ebp
c0102925:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0102927:	8b 55 08             	mov    0x8(%ebp),%edx
c010292a:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c010292f:	89 d1                	mov    %edx,%ecx
c0102931:	29 c1                	sub    %eax,%ecx
c0102933:	89 c8                	mov    %ecx,%eax
c0102935:	c1 f8 02             	sar    $0x2,%eax
c0102938:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c010293e:	5d                   	pop    %ebp
c010293f:	c3                   	ret    

c0102940 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0102940:	55                   	push   %ebp
c0102941:	89 e5                	mov    %esp,%ebp
c0102943:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0102946:	8b 45 08             	mov    0x8(%ebp),%eax
c0102949:	89 04 24             	mov    %eax,(%esp)
c010294c:	e8 d3 ff ff ff       	call   c0102924 <page2ppn>
c0102951:	c1 e0 0c             	shl    $0xc,%eax
}
c0102954:	c9                   	leave  
c0102955:	c3                   	ret    

c0102956 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0102956:	55                   	push   %ebp
c0102957:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0102959:	8b 45 08             	mov    0x8(%ebp),%eax
c010295c:	8b 00                	mov    (%eax),%eax
}
c010295e:	5d                   	pop    %ebp
c010295f:	c3                   	ret    

c0102960 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0102960:	55                   	push   %ebp
c0102961:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0102963:	8b 45 08             	mov    0x8(%ebp),%eax
c0102966:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102969:	89 10                	mov    %edx,(%eax)
}
c010296b:	5d                   	pop    %ebp
c010296c:	c3                   	ret    

c010296d <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c010296d:	55                   	push   %ebp
c010296e:	89 e5                	mov    %esp,%ebp
c0102970:	83 ec 10             	sub    $0x10,%esp
c0102973:	c7 45 fc 50 99 11 c0 	movl   $0xc0119950,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010297a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010297d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0102980:	89 50 04             	mov    %edx,0x4(%eax)
c0102983:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102986:	8b 50 04             	mov    0x4(%eax),%edx
c0102989:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010298c:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010298e:	c7 05 58 99 11 c0 00 	movl   $0x0,0xc0119958
c0102995:	00 00 00 
}
c0102998:	c9                   	leave  
c0102999:	c3                   	ret    

c010299a <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c010299a:	55                   	push   %ebp
c010299b:	89 e5                	mov    %esp,%ebp
c010299d:	53                   	push   %ebx
c010299e:	83 ec 74             	sub    $0x74,%esp
    assert(n > 0);
c01029a1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01029a5:	75 24                	jne    c01029cb <default_init_memmap+0x31>
c01029a7:	c7 44 24 0c 90 69 10 	movl   $0xc0106990,0xc(%esp)
c01029ae:	c0 
c01029af:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01029b6:	c0 
c01029b7:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01029be:	00 
c01029bf:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01029c6:	e8 dd e2 ff ff       	call   c0100ca8 <__panic>
    struct Page *p = base +1;
c01029cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01029ce:	83 c0 14             	add    $0x14,%eax
c01029d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p < base + n; ++ p) {
c01029d4:	e9 c0 00 00 00       	jmp    c0102a99 <default_init_memmap+0xff>
        assert(PageReserved(p));
c01029d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01029dc:	83 c0 04             	add    $0x4,%eax
c01029df:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01029e6:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01029e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01029ec:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01029ef:	0f a3 10             	bt     %edx,(%eax)
c01029f2:	19 db                	sbb    %ebx,%ebx
c01029f4:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    return oldbit != 0;
c01029f7:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01029fb:	0f 95 c0             	setne  %al
c01029fe:	0f b6 c0             	movzbl %al,%eax
c0102a01:	85 c0                	test   %eax,%eax
c0102a03:	75 24                	jne    c0102a29 <default_init_memmap+0x8f>
c0102a05:	c7 44 24 0c c1 69 10 	movl   $0xc01069c1,0xc(%esp)
c0102a0c:	c0 
c0102a0d:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0102a14:	c0 
c0102a15:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0102a1c:	00 
c0102a1d:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0102a24:	e8 7f e2 ff ff       	call   c0100ca8 <__panic>
        ClearPageReserved(p);
c0102a29:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a2c:	83 c0 04             	add    $0x4,%eax
c0102a2f:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c0102a36:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102a39:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102a3c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0102a3f:	0f b3 10             	btr    %edx,(%eax)
        ClearPageProperty(p);        
c0102a42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a45:	83 c0 04             	add    $0x4,%eax
c0102a48:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
c0102a4f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0102a52:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102a55:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102a58:	0f b3 10             	btr    %edx,(%eax)
	p->property = 0;
c0102a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a5e:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c0102a65:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102a6c:	00 
c0102a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a70:	89 04 24             	mov    %eax,(%esp)
c0102a73:	e8 e8 fe ff ff       	call   c0102960 <set_page_ref>
	list_init(&(p->page_link));
c0102a78:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102a7b:	83 c0 0c             	add    $0xc,%eax
c0102a7e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0102a81:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a84:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102a87:	89 50 04             	mov    %edx,0x4(%eax)
c0102a8a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a8d:	8b 50 04             	mov    0x4(%eax),%edx
c0102a90:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102a93:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base +1;
    for (; p < base + n; ++ p) {
c0102a95:	83 45 f4 14          	addl   $0x14,-0xc(%ebp)
c0102a99:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102a9c:	89 d0                	mov    %edx,%eax
c0102a9e:	c1 e0 02             	shl    $0x2,%eax
c0102aa1:	01 d0                	add    %edx,%eax
c0102aa3:	c1 e0 02             	shl    $0x2,%eax
c0102aa6:	03 45 08             	add    0x8(%ebp),%eax
c0102aa9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0102aac:	0f 87 27 ff ff ff    	ja     c01029d9 <default_init_memmap+0x3f>
        ClearPageProperty(p);        
	p->property = 0;
        set_page_ref(p, 0);
	list_init(&(p->page_link));
    }
    assert(PageReserved(base));
c0102ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ab5:	83 c0 04             	add    $0x4,%eax
c0102ab8:	c7 45 d0 00 00 00 00 	movl   $0x0,-0x30(%ebp)
c0102abf:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102ac2:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102ac5:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0102ac8:	0f a3 10             	bt     %edx,(%eax)
c0102acb:	19 db                	sbb    %ebx,%ebx
c0102acd:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    return oldbit != 0;
c0102ad0:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0102ad4:	0f 95 c0             	setne  %al
c0102ad7:	0f b6 c0             	movzbl %al,%eax
c0102ada:	85 c0                	test   %eax,%eax
c0102adc:	75 24                	jne    c0102b02 <default_init_memmap+0x168>
c0102ade:	c7 44 24 0c d1 69 10 	movl   $0xc01069d1,0xc(%esp)
c0102ae5:	c0 
c0102ae6:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0102aed:	c0 
c0102aee:	c7 44 24 04 50 00 00 	movl   $0x50,0x4(%esp)
c0102af5:	00 
c0102af6:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0102afd:	e8 a6 e1 ff ff       	call   c0100ca8 <__panic>
    ClearPageReserved(base);
c0102b02:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b05:	83 c0 04             	add    $0x4,%eax
c0102b08:	c7 45 c4 00 00 00 00 	movl   $0x0,-0x3c(%ebp)
c0102b0f:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b12:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102b15:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102b18:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0102b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b1e:	83 c0 04             	add    $0x4,%eax
c0102b21:	c7 45 bc 01 00 00 00 	movl   $0x1,-0x44(%ebp)
c0102b28:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102b2b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0102b2e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102b31:	0f ab 10             	bts    %edx,(%eax)

    base->property = n;
c0102b34:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b37:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102b3a:	89 50 08             	mov    %edx,0x8(%eax)

    set_page_ref(base, 0);
c0102b3d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0102b44:	00 
c0102b45:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b48:	89 04 24             	mov    %eax,(%esp)
c0102b4b:	e8 10 fe ff ff       	call   c0102960 <set_page_ref>

    list_add_before(&free_list, &(base -> page_link)); 
c0102b50:	8b 45 08             	mov    0x8(%ebp),%eax
c0102b53:	83 c0 0c             	add    $0xc,%eax
c0102b56:	c7 45 b4 50 99 11 c0 	movl   $0xc0119950,-0x4c(%ebp)
c0102b5d:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0102b60:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b63:	8b 00                	mov    (%eax),%eax
c0102b65:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102b68:	89 55 ac             	mov    %edx,-0x54(%ebp)
c0102b6b:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102b6e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102b71:	89 45 a4             	mov    %eax,-0x5c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102b74:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102b77:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0102b7a:	89 10                	mov    %edx,(%eax)
c0102b7c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102b7f:	8b 10                	mov    (%eax),%edx
c0102b81:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102b84:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102b87:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102b8a:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0102b8d:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102b90:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102b93:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0102b96:	89 10                	mov    %edx,(%eax)
    nr_free += n;
c0102b98:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c0102b9d:	03 45 0c             	add    0xc(%ebp),%eax
c0102ba0:	a3 58 99 11 c0       	mov    %eax,0xc0119958

}
c0102ba5:	83 c4 74             	add    $0x74,%esp
c0102ba8:	5b                   	pop    %ebx
c0102ba9:	5d                   	pop    %ebp
c0102baa:	c3                   	ret    

c0102bab <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c0102bab:	55                   	push   %ebp
c0102bac:	89 e5                	mov    %esp,%ebp
c0102bae:	53                   	push   %ebx
c0102baf:	81 ec 94 00 00 00    	sub    $0x94,%esp
    assert(n > 0);
c0102bb5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0102bb9:	75 24                	jne    c0102bdf <default_alloc_pages+0x34>
c0102bbb:	c7 44 24 0c 90 69 10 	movl   $0xc0106990,0xc(%esp)
c0102bc2:	c0 
c0102bc3:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0102bca:	c0 
c0102bcb:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0102bd2:	00 
c0102bd3:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0102bda:	e8 c9 e0 ff ff       	call   c0100ca8 <__panic>
    if (n > nr_free) {
c0102bdf:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c0102be4:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102be7:	73 0a                	jae    c0102bf3 <default_alloc_pages+0x48>
        return NULL;
c0102be9:	b8 00 00 00 00       	mov    $0x0,%eax
c0102bee:	e9 34 02 00 00       	jmp    c0102e27 <default_alloc_pages+0x27c>
    }
    struct Page *page = NULL;
c0102bf3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    list_entry_t *le = &free_list;
c0102bfa:	c7 45 f0 50 99 11 c0 	movl   $0xc0119950,-0x10(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0102c01:	eb 74                	jmp    c0102c77 <default_alloc_pages+0xcc>
        struct Page *p = le2page(le, page_link);
c0102c03:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c06:	83 e8 0c             	sub    $0xc,%eax
c0102c09:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (PageProperty(p) && !PageReserved(p) && p->property >= n) {
c0102c0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c0f:	83 c0 04             	add    $0x4,%eax
c0102c12:	c7 45 e0 01 00 00 00 	movl   $0x1,-0x20(%ebp)
c0102c19:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c1c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102c1f:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0102c22:	0f a3 10             	bt     %edx,(%eax)
c0102c25:	19 db                	sbb    %ebx,%ebx
c0102c27:	89 5d d8             	mov    %ebx,-0x28(%ebp)
    return oldbit != 0;
c0102c2a:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0102c2e:	0f 95 c0             	setne  %al
c0102c31:	0f b6 c0             	movzbl %al,%eax
c0102c34:	85 c0                	test   %eax,%eax
c0102c36:	74 3f                	je     c0102c77 <default_alloc_pages+0xcc>
c0102c38:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c3b:	83 c0 04             	add    $0x4,%eax
c0102c3e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
c0102c45:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0102c48:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102c4b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102c4e:	0f a3 10             	bt     %edx,(%eax)
c0102c51:	19 db                	sbb    %ebx,%ebx
c0102c53:	89 5d cc             	mov    %ebx,-0x34(%ebp)
    return oldbit != 0;
c0102c56:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0102c5a:	0f 95 c0             	setne  %al
c0102c5d:	0f b6 c0             	movzbl %al,%eax
c0102c60:	85 c0                	test   %eax,%eax
c0102c62:	75 13                	jne    c0102c77 <default_alloc_pages+0xcc>
c0102c64:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c67:	8b 40 08             	mov    0x8(%eax),%eax
c0102c6a:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102c6d:	72 08                	jb     c0102c77 <default_alloc_pages+0xcc>
            page = p;
c0102c6f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102c72:	89 45 f4             	mov    %eax,-0xc(%ebp)
            break;
c0102c75:	eb 1c                	jmp    c0102c93 <default_alloc_pages+0xe8>
c0102c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102c7a:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102c7d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102c80:	8b 40 04             	mov    0x4(%eax),%eax
    if (n > nr_free) {
        return NULL;
    }
    struct Page *page = NULL;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0102c83:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0102c86:	81 7d f0 50 99 11 c0 	cmpl   $0xc0119950,-0x10(%ebp)
c0102c8d:	0f 85 70 ff ff ff    	jne    c0102c03 <default_alloc_pages+0x58>
        if (PageProperty(p) && !PageReserved(p) && p->property >= n) {
            page = p;
            break;
        }
    }
    if (page != NULL) {
c0102c93:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102c97:	0f 84 87 01 00 00    	je     c0102e24 <default_alloc_pages+0x279>
	le = page->page_link.prev;        
c0102c9d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca0:	8b 40 0c             	mov    0xc(%eax),%eax
c0102ca3:	89 45 f0             	mov    %eax,-0x10(%ebp)
	list_del(&(page->page_link));
c0102ca6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ca9:	83 c0 0c             	add    $0xc,%eax
c0102cac:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102caf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102cb2:	8b 40 04             	mov    0x4(%eax),%eax
c0102cb5:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102cb8:	8b 12                	mov    (%edx),%edx
c0102cba:	89 55 c0             	mov    %edx,-0x40(%ebp)
c0102cbd:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102cc0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0102cc3:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0102cc6:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102cc9:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102ccc:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102ccf:	89 10                	mov    %edx,(%eax)
        if (page->property > n) {
c0102cd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102cd4:	8b 40 08             	mov    0x8(%eax),%eax
c0102cd7:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102cda:	0f 86 aa 00 00 00    	jbe    c0102d8a <default_alloc_pages+0x1df>
            struct Page *p = page + n;
c0102ce0:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ce3:	89 d0                	mov    %edx,%eax
c0102ce5:	c1 e0 02             	shl    $0x2,%eax
c0102ce8:	01 d0                	add    %edx,%eax
c0102cea:	c1 e0 02             	shl    $0x2,%eax
c0102ced:	03 45 f4             	add    -0xc(%ebp),%eax
c0102cf0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	    ClearPageReserved(p);
c0102cf3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102cf6:	83 c0 04             	add    $0x4,%eax
c0102cf9:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0102d00:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d03:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102d06:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102d09:	0f b3 10             	btr    %edx,(%eax)
            SetPageProperty(p);            p->property = page->property - n;
c0102d0c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d0f:	83 c0 04             	add    $0x4,%eax
c0102d12:	c7 45 b0 01 00 00 00 	movl   $0x1,-0x50(%ebp)
c0102d19:	89 45 ac             	mov    %eax,-0x54(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102d1c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c0102d1f:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102d22:	0f ab 10             	bts    %edx,(%eax)
c0102d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d28:	8b 40 08             	mov    0x8(%eax),%eax
c0102d2b:	89 c2                	mov    %eax,%edx
c0102d2d:	2b 55 08             	sub    0x8(%ebp),%edx
c0102d30:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d33:	89 50 08             	mov    %edx,0x8(%eax)
            list_add(le, &(p->page_link));
c0102d36:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102d39:	8d 50 0c             	lea    0xc(%eax),%edx
c0102d3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102d3f:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0102d42:	89 55 a4             	mov    %edx,-0x5c(%ebp)
c0102d45:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0102d48:	89 45 a0             	mov    %eax,-0x60(%ebp)
c0102d4b:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0102d4e:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0102d51:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0102d54:	8b 40 04             	mov    0x4(%eax),%eax
c0102d57:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0102d5a:	89 55 98             	mov    %edx,-0x68(%ebp)
c0102d5d:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0102d60:	89 55 94             	mov    %edx,-0x6c(%ebp)
c0102d63:	89 45 90             	mov    %eax,-0x70(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0102d66:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102d69:	8b 55 98             	mov    -0x68(%ebp),%edx
c0102d6c:	89 10                	mov    %edx,(%eax)
c0102d6e:	8b 45 90             	mov    -0x70(%ebp),%eax
c0102d71:	8b 10                	mov    (%eax),%edx
c0102d73:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0102d76:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0102d79:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102d7c:	8b 55 90             	mov    -0x70(%ebp),%edx
c0102d7f:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0102d82:	8b 45 98             	mov    -0x68(%ebp),%eax
c0102d85:	8b 55 94             	mov    -0x6c(%ebp),%edx
c0102d88:	89 10                	mov    %edx,(%eax)
    }
        struct Page *p = page;
c0102d8a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102d8d:	89 45 ec             	mov    %eax,-0x14(%ebp)
        for (; p < page + n; ++p) {
c0102d90:	eb 6c                	jmp    c0102dfe <default_alloc_pages+0x253>

            SetPageReserved(p);
c0102d92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102d95:	83 c0 04             	add    $0x4,%eax
c0102d98:	c7 45 8c 00 00 00 00 	movl   $0x0,-0x74(%ebp)
c0102d9f:	89 45 88             	mov    %eax,-0x78(%ebp)
c0102da2:	8b 45 88             	mov    -0x78(%ebp),%eax
c0102da5:	8b 55 8c             	mov    -0x74(%ebp),%edx
c0102da8:	0f ab 10             	bts    %edx,(%eax)
            ClearPageProperty(p);
c0102dab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102dae:	83 c0 04             	add    $0x4,%eax
c0102db1:	c7 45 84 01 00 00 00 	movl   $0x1,-0x7c(%ebp)
c0102db8:	89 45 80             	mov    %eax,-0x80(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0102dbb:	8b 45 80             	mov    -0x80(%ebp),%eax
c0102dbe:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0102dc1:	0f b3 10             	btr    %edx,(%eax)
            p->property = 0;
c0102dc4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102dc7:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)

            list_init(&(p->page_link));
c0102dce:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102dd1:	83 c0 0c             	add    $0xc,%eax
c0102dd4:	89 85 7c ff ff ff    	mov    %eax,-0x84(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102dda:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102de0:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0102de6:	89 50 04             	mov    %edx,0x4(%eax)
c0102de9:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102def:	8b 50 04             	mov    0x4(%eax),%edx
c0102df2:	8b 85 7c ff ff ff    	mov    -0x84(%ebp),%eax
c0102df8:	89 10                	mov    %edx,(%eax)
	    ClearPageReserved(p);
            SetPageProperty(p);            p->property = page->property - n;
            list_add(le, &(p->page_link));
    }
        struct Page *p = page;
        for (; p < page + n; ++p) {
c0102dfa:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0102dfe:	8b 55 08             	mov    0x8(%ebp),%edx
c0102e01:	89 d0                	mov    %edx,%eax
c0102e03:	c1 e0 02             	shl    $0x2,%eax
c0102e06:	01 d0                	add    %edx,%eax
c0102e08:	c1 e0 02             	shl    $0x2,%eax
c0102e0b:	03 45 f4             	add    -0xc(%ebp),%eax
c0102e0e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102e11:	0f 87 7b ff ff ff    	ja     c0102d92 <default_alloc_pages+0x1e7>
            ClearPageProperty(p);
            p->property = 0;

            list_init(&(p->page_link));
        }        
	nr_free -= n;
c0102e17:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c0102e1c:	2b 45 08             	sub    0x8(%ebp),%eax
c0102e1f:	a3 58 99 11 c0       	mov    %eax,0xc0119958
        
    }
    return page;
c0102e24:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0102e27:	81 c4 94 00 00 00    	add    $0x94,%esp
c0102e2d:	5b                   	pop    %ebx
c0102e2e:	5d                   	pop    %ebp
c0102e2f:	c3                   	ret    

c0102e30 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0102e30:	55                   	push   %ebp
c0102e31:	89 e5                	mov    %esp,%ebp
c0102e33:	81 ec 98 00 00 00    	sub    $0x98,%esp
    assert(n > 0);
c0102e39:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0102e3d:	75 24                	jne    c0102e63 <default_free_pages+0x33>
c0102e3f:	c7 44 24 0c 90 69 10 	movl   $0xc0106990,0xc(%esp)
c0102e46:	c0 
c0102e47:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0102e4e:	c0 
c0102e4f:	c7 44 24 04 86 00 00 	movl   $0x86,0x4(%esp)
c0102e56:	00 
c0102e57:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0102e5e:	e8 45 de ff ff       	call   c0100ca8 <__panic>
    struct Page *p;
    list_entry_t *le = &free_list;
c0102e63:	c7 45 f4 50 99 11 c0 	movl   $0xc0119950,-0xc(%ebp)
    while((le = list_next(le)) != &free_list) {
c0102e6a:	eb 11                	jmp    c0102e7d <default_free_pages+0x4d>
        p = le2page(le, page_link);
c0102e6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e6f:	83 e8 0c             	sub    $0xc,%eax
c0102e72:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if(p > base)
c0102e75:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0102e78:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102e7b:	77 1a                	ja     c0102e97 <default_free_pages+0x67>
            break;
c0102e7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102e80:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0102e83:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0102e86:	8b 40 04             	mov    0x4(%eax),%eax
static void
default_free_pages(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p;
    list_entry_t *le = &free_list;
    while((le = list_next(le)) != &free_list) {
c0102e89:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102e8c:	81 7d f4 50 99 11 c0 	cmpl   $0xc0119950,-0xc(%ebp)
c0102e93:	75 d7                	jne    c0102e6c <default_free_pages+0x3c>
c0102e95:	eb 01                	jmp    c0102e98 <default_free_pages+0x68>
        p = le2page(le, page_link);
        if(p > base)
            break;
c0102e97:	90                   	nop
    }
    base->property = n;
c0102e98:	8b 45 08             	mov    0x8(%ebp),%eax
c0102e9b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0102e9e:	89 50 08             	mov    %edx,0x8(%eax)
c0102ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102ea4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102ea7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0102eaa:	8b 00                	mov    (%eax),%eax

    list_entry_t *tle = list_prev(le);
c0102eac:	89 45 f0             	mov    %eax,-0x10(%ebp)
    struct Page *tp;

    tp = le2page(le, page_link);
c0102eaf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102eb2:	83 e8 0c             	sub    $0xc,%eax
c0102eb5:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (base + base->property == tp) {
c0102eb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ebb:	8b 50 08             	mov    0x8(%eax),%edx
c0102ebe:	89 d0                	mov    %edx,%eax
c0102ec0:	c1 e0 02             	shl    $0x2,%eax
c0102ec3:	01 d0                	add    %edx,%eax
c0102ec5:	c1 e0 02             	shl    $0x2,%eax
c0102ec8:	03 45 08             	add    0x8(%ebp),%eax
c0102ecb:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0102ece:	75 3f                	jne    c0102f0f <default_free_pages+0xdf>
        base->property += tp->property;
c0102ed0:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ed3:	8b 50 08             	mov    0x8(%eax),%edx
c0102ed6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ed9:	8b 40 08             	mov    0x8(%eax),%eax
c0102edc:	01 c2                	add    %eax,%edx
c0102ede:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ee1:	89 50 08             	mov    %edx,0x8(%eax)
        list_del(&(tp->page_link));
c0102ee4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102ee7:	83 c0 0c             	add    $0xc,%eax
c0102eea:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102eed:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0102ef0:	8b 40 04             	mov    0x4(%eax),%eax
c0102ef3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0102ef6:	8b 12                	mov    (%edx),%edx
c0102ef8:	89 55 d8             	mov    %edx,-0x28(%ebp)
c0102efb:	89 45 d4             	mov    %eax,-0x2c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102efe:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0102f01:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0102f04:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f07:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0102f0a:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0102f0d:	89 10                	mov    %edx,(%eax)
    }

    tp = le2page(tle, page_link);
c0102f0f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f12:	83 e8 0c             	sub    $0xc,%eax
c0102f15:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (tp + tp->property == base) {
c0102f18:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f1b:	8b 50 08             	mov    0x8(%eax),%edx
c0102f1e:	89 d0                	mov    %edx,%eax
c0102f20:	c1 e0 02             	shl    $0x2,%eax
c0102f23:	01 d0                	add    %edx,%eax
c0102f25:	c1 e0 02             	shl    $0x2,%eax
c0102f28:	03 45 ec             	add    -0x14(%ebp),%eax
c0102f2b:	3b 45 08             	cmp    0x8(%ebp),%eax
c0102f2e:	75 53                	jne    c0102f83 <default_free_pages+0x153>
        tp->property += base->property;
c0102f30:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f33:	8b 50 08             	mov    0x8(%eax),%edx
c0102f36:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f39:	8b 40 08             	mov    0x8(%eax),%eax
c0102f3c:	01 c2                	add    %eax,%edx
c0102f3e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f41:	89 50 08             	mov    %edx,0x8(%eax)
c0102f44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0102f47:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0102f4a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0102f4d:	8b 00                	mov    (%eax),%eax
        tle = list_prev(tle);
c0102f4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
        list_del(&(tp->page_link));
c0102f52:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f55:	83 c0 0c             	add    $0xc,%eax
c0102f58:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0102f5b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0102f5e:	8b 40 04             	mov    0x4(%eax),%eax
c0102f61:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0102f64:	8b 12                	mov    (%edx),%edx
c0102f66:	89 55 c8             	mov    %edx,-0x38(%ebp)
c0102f69:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0102f6c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0102f6f:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0102f72:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0102f75:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0102f78:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0102f7b:	89 10                	mov    %edx,(%eax)

        base = tp;
c0102f7d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f80:	89 45 08             	mov    %eax,0x8(%ebp)
    }

    for (tp = base + 1; tp < base + base->property; ++tp) {
c0102f83:	8b 45 08             	mov    0x8(%ebp),%eax
c0102f86:	83 c0 14             	add    $0x14,%eax
c0102f89:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0102f8c:	eb 5d                	jmp    c0102feb <default_free_pages+0x1bb>
        ClearPageReserved(tp);
c0102f8e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102f91:	83 c0 04             	add    $0x4,%eax
c0102f94:	c7 45 c0 00 00 00 00 	movl   $0x0,-0x40(%ebp)
c0102f9b:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0102f9e:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0102fa1:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0102fa4:	0f b3 10             	btr    %edx,(%eax)
        ClearPageProperty(tp);
c0102fa7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102faa:	83 c0 04             	add    $0x4,%eax
c0102fad:	c7 45 b8 01 00 00 00 	movl   $0x1,-0x48(%ebp)
c0102fb4:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0102fb7:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0102fba:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0102fbd:	0f b3 10             	btr    %edx,(%eax)
        tp->property = 0;
c0102fc0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fc3:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        list_init(&(tp->page_link));
c0102fca:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0102fcd:	83 c0 0c             	add    $0xc,%eax
c0102fd0:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0102fd3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102fd6:	8b 55 b0             	mov    -0x50(%ebp),%edx
c0102fd9:	89 50 04             	mov    %edx,0x4(%eax)
c0102fdc:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102fdf:	8b 50 04             	mov    0x4(%eax),%edx
c0102fe2:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0102fe5:	89 10                	mov    %edx,(%eax)
        list_del(&(tp->page_link));

        base = tp;
    }

    for (tp = base + 1; tp < base + base->property; ++tp) {
c0102fe7:	83 45 ec 14          	addl   $0x14,-0x14(%ebp)
c0102feb:	8b 45 08             	mov    0x8(%ebp),%eax
c0102fee:	8b 50 08             	mov    0x8(%eax),%edx
c0102ff1:	89 d0                	mov    %edx,%eax
c0102ff3:	c1 e0 02             	shl    $0x2,%eax
c0102ff6:	01 d0                	add    %edx,%eax
c0102ff8:	c1 e0 02             	shl    $0x2,%eax
c0102ffb:	03 45 08             	add    0x8(%ebp),%eax
c0102ffe:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103001:	77 8b                	ja     c0102f8e <default_free_pages+0x15e>
        ClearPageReserved(tp);
        ClearPageProperty(tp);
        tp->property = 0;
        list_init(&(tp->page_link));
    }
    ClearPageReserved(base);
c0103003:	8b 45 08             	mov    0x8(%ebp),%eax
c0103006:	83 c0 04             	add    $0x4,%eax
c0103009:	c7 45 ac 00 00 00 00 	movl   $0x0,-0x54(%ebp)
c0103010:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0103013:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103016:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103019:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c010301c:	8b 45 08             	mov    0x8(%ebp),%eax
c010301f:	83 c0 04             	add    $0x4,%eax
c0103022:	c7 45 a4 01 00 00 00 	movl   $0x1,-0x5c(%ebp)
c0103029:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010302c:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010302f:	8b 55 a4             	mov    -0x5c(%ebp),%edx
c0103032:	0f ab 10             	bts    %edx,(%eax)
    list_add(tle, &(base->page_link));
c0103035:	8b 45 08             	mov    0x8(%ebp),%eax
c0103038:	8d 50 0c             	lea    0xc(%eax),%edx
c010303b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010303e:	89 45 9c             	mov    %eax,-0x64(%ebp)
c0103041:	89 55 98             	mov    %edx,-0x68(%ebp)
c0103044:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0103047:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010304a:	8b 45 98             	mov    -0x68(%ebp),%eax
c010304d:	89 45 90             	mov    %eax,-0x70(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0103050:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0103053:	8b 40 04             	mov    0x4(%eax),%eax
c0103056:	8b 55 90             	mov    -0x70(%ebp),%edx
c0103059:	89 55 8c             	mov    %edx,-0x74(%ebp)
c010305c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010305f:	89 55 88             	mov    %edx,-0x78(%ebp)
c0103062:	89 45 84             	mov    %eax,-0x7c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103065:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103068:	8b 55 8c             	mov    -0x74(%ebp),%edx
c010306b:	89 10                	mov    %edx,(%eax)
c010306d:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0103070:	8b 10                	mov    (%eax),%edx
c0103072:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103075:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0103078:	8b 45 8c             	mov    -0x74(%ebp),%eax
c010307b:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010307e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103081:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0103084:	8b 55 88             	mov    -0x78(%ebp),%edx
c0103087:	89 10                	mov    %edx,(%eax)

    nr_free += n;
c0103089:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c010308e:	03 45 0c             	add    0xc(%ebp),%eax
c0103091:	a3 58 99 11 c0       	mov    %eax,0xc0119958
}
c0103096:	c9                   	leave  
c0103097:	c3                   	ret    

c0103098 <default_nr_free_pages>:


static size_t
default_nr_free_pages(void) {
c0103098:	55                   	push   %ebp
c0103099:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010309b:	a1 58 99 11 c0       	mov    0xc0119958,%eax
}
c01030a0:	5d                   	pop    %ebp
c01030a1:	c3                   	ret    

c01030a2 <basic_check>:

static void
basic_check(void) {
c01030a2:	55                   	push   %ebp
c01030a3:	89 e5                	mov    %esp,%ebp
c01030a5:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01030a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01030af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01030b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01030b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01030b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01030bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030c2:	e8 a6 0e 00 00       	call   c0103f6d <alloc_pages>
c01030c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01030ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01030ce:	75 24                	jne    c01030f4 <basic_check+0x52>
c01030d0:	c7 44 24 0c e4 69 10 	movl   $0xc01069e4,0xc(%esp)
c01030d7:	c0 
c01030d8:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01030df:	c0 
c01030e0:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c01030e7:	00 
c01030e8:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01030ef:	e8 b4 db ff ff       	call   c0100ca8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01030f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01030fb:	e8 6d 0e 00 00       	call   c0103f6d <alloc_pages>
c0103100:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103103:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103107:	75 24                	jne    c010312d <basic_check+0x8b>
c0103109:	c7 44 24 0c 00 6a 10 	movl   $0xc0106a00,0xc(%esp)
c0103110:	c0 
c0103111:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103118:	c0 
c0103119:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c0103120:	00 
c0103121:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103128:	e8 7b db ff ff       	call   c0100ca8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010312d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103134:	e8 34 0e 00 00       	call   c0103f6d <alloc_pages>
c0103139:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010313c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103140:	75 24                	jne    c0103166 <basic_check+0xc4>
c0103142:	c7 44 24 0c 1c 6a 10 	movl   $0xc0106a1c,0xc(%esp)
c0103149:	c0 
c010314a:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103151:	c0 
c0103152:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c0103159:	00 
c010315a:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103161:	e8 42 db ff ff       	call   c0100ca8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103166:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103169:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010316c:	74 10                	je     c010317e <basic_check+0xdc>
c010316e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103171:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103174:	74 08                	je     c010317e <basic_check+0xdc>
c0103176:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103179:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010317c:	75 24                	jne    c01031a2 <basic_check+0x100>
c010317e:	c7 44 24 0c 38 6a 10 	movl   $0xc0106a38,0xc(%esp)
c0103185:	c0 
c0103186:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c010318d:	c0 
c010318e:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0103195:	00 
c0103196:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c010319d:	e8 06 db ff ff       	call   c0100ca8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01031a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031a5:	89 04 24             	mov    %eax,(%esp)
c01031a8:	e8 a9 f7 ff ff       	call   c0102956 <page_ref>
c01031ad:	85 c0                	test   %eax,%eax
c01031af:	75 1e                	jne    c01031cf <basic_check+0x12d>
c01031b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01031b4:	89 04 24             	mov    %eax,(%esp)
c01031b7:	e8 9a f7 ff ff       	call   c0102956 <page_ref>
c01031bc:	85 c0                	test   %eax,%eax
c01031be:	75 0f                	jne    c01031cf <basic_check+0x12d>
c01031c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01031c3:	89 04 24             	mov    %eax,(%esp)
c01031c6:	e8 8b f7 ff ff       	call   c0102956 <page_ref>
c01031cb:	85 c0                	test   %eax,%eax
c01031cd:	74 24                	je     c01031f3 <basic_check+0x151>
c01031cf:	c7 44 24 0c 5c 6a 10 	movl   $0xc0106a5c,0xc(%esp)
c01031d6:	c0 
c01031d7:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01031de:	c0 
c01031df:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c01031e6:	00 
c01031e7:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01031ee:	e8 b5 da ff ff       	call   c0100ca8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01031f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01031f6:	89 04 24             	mov    %eax,(%esp)
c01031f9:	e8 42 f7 ff ff       	call   c0102940 <page2pa>
c01031fe:	8b 15 c0 98 11 c0    	mov    0xc01198c0,%edx
c0103204:	c1 e2 0c             	shl    $0xc,%edx
c0103207:	39 d0                	cmp    %edx,%eax
c0103209:	72 24                	jb     c010322f <basic_check+0x18d>
c010320b:	c7 44 24 0c 98 6a 10 	movl   $0xc0106a98,0xc(%esp)
c0103212:	c0 
c0103213:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c010321a:	c0 
c010321b:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0103222:	00 
c0103223:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c010322a:	e8 79 da ff ff       	call   c0100ca8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c010322f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103232:	89 04 24             	mov    %eax,(%esp)
c0103235:	e8 06 f7 ff ff       	call   c0102940 <page2pa>
c010323a:	8b 15 c0 98 11 c0    	mov    0xc01198c0,%edx
c0103240:	c1 e2 0c             	shl    $0xc,%edx
c0103243:	39 d0                	cmp    %edx,%eax
c0103245:	72 24                	jb     c010326b <basic_check+0x1c9>
c0103247:	c7 44 24 0c b5 6a 10 	movl   $0xc0106ab5,0xc(%esp)
c010324e:	c0 
c010324f:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103256:	c0 
c0103257:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c010325e:	00 
c010325f:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103266:	e8 3d da ff ff       	call   c0100ca8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c010326b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010326e:	89 04 24             	mov    %eax,(%esp)
c0103271:	e8 ca f6 ff ff       	call   c0102940 <page2pa>
c0103276:	8b 15 c0 98 11 c0    	mov    0xc01198c0,%edx
c010327c:	c1 e2 0c             	shl    $0xc,%edx
c010327f:	39 d0                	cmp    %edx,%eax
c0103281:	72 24                	jb     c01032a7 <basic_check+0x205>
c0103283:	c7 44 24 0c d2 6a 10 	movl   $0xc0106ad2,0xc(%esp)
c010328a:	c0 
c010328b:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103292:	c0 
c0103293:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c010329a:	00 
c010329b:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01032a2:	e8 01 da ff ff       	call   c0100ca8 <__panic>

    list_entry_t free_list_store = free_list;
c01032a7:	a1 50 99 11 c0       	mov    0xc0119950,%eax
c01032ac:	8b 15 54 99 11 c0    	mov    0xc0119954,%edx
c01032b2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01032b5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01032b8:	c7 45 e0 50 99 11 c0 	movl   $0xc0119950,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01032bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032c2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01032c5:	89 50 04             	mov    %edx,0x4(%eax)
c01032c8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032cb:	8b 50 04             	mov    0x4(%eax),%edx
c01032ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01032d1:	89 10                	mov    %edx,(%eax)
c01032d3:	c7 45 dc 50 99 11 c0 	movl   $0xc0119950,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01032da:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01032dd:	8b 40 04             	mov    0x4(%eax),%eax
c01032e0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01032e3:	0f 94 c0             	sete   %al
c01032e6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c01032e9:	85 c0                	test   %eax,%eax
c01032eb:	75 24                	jne    c0103311 <basic_check+0x26f>
c01032ed:	c7 44 24 0c ef 6a 10 	movl   $0xc0106aef,0xc(%esp)
c01032f4:	c0 
c01032f5:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01032fc:	c0 
c01032fd:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103304:	00 
c0103305:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c010330c:	e8 97 d9 ff ff       	call   c0100ca8 <__panic>

    unsigned int nr_free_store = nr_free;
c0103311:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c0103316:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103319:	c7 05 58 99 11 c0 00 	movl   $0x0,0xc0119958
c0103320:	00 00 00 

    assert(alloc_page() == NULL);
c0103323:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010332a:	e8 3e 0c 00 00       	call   c0103f6d <alloc_pages>
c010332f:	85 c0                	test   %eax,%eax
c0103331:	74 24                	je     c0103357 <basic_check+0x2b5>
c0103333:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c010333a:	c0 
c010333b:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103342:	c0 
c0103343:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c010334a:	00 
c010334b:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103352:	e8 51 d9 ff ff       	call   c0100ca8 <__panic>

    free_page(p0);
c0103357:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010335e:	00 
c010335f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103362:	89 04 24             	mov    %eax,(%esp)
c0103365:	e8 3b 0c 00 00       	call   c0103fa5 <free_pages>
    free_page(p1);
c010336a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103371:	00 
c0103372:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103375:	89 04 24             	mov    %eax,(%esp)
c0103378:	e8 28 0c 00 00       	call   c0103fa5 <free_pages>
    free_page(p2);
c010337d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103384:	00 
c0103385:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103388:	89 04 24             	mov    %eax,(%esp)
c010338b:	e8 15 0c 00 00       	call   c0103fa5 <free_pages>
    assert(nr_free == 3);
c0103390:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c0103395:	83 f8 03             	cmp    $0x3,%eax
c0103398:	74 24                	je     c01033be <basic_check+0x31c>
c010339a:	c7 44 24 0c 1b 6b 10 	movl   $0xc0106b1b,0xc(%esp)
c01033a1:	c0 
c01033a2:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01033a9:	c0 
c01033aa:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c01033b1:	00 
c01033b2:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01033b9:	e8 ea d8 ff ff       	call   c0100ca8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c01033be:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033c5:	e8 a3 0b 00 00       	call   c0103f6d <alloc_pages>
c01033ca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01033cd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01033d1:	75 24                	jne    c01033f7 <basic_check+0x355>
c01033d3:	c7 44 24 0c e4 69 10 	movl   $0xc01069e4,0xc(%esp)
c01033da:	c0 
c01033db:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01033e2:	c0 
c01033e3:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c01033ea:	00 
c01033eb:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01033f2:	e8 b1 d8 ff ff       	call   c0100ca8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01033f7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01033fe:	e8 6a 0b 00 00       	call   c0103f6d <alloc_pages>
c0103403:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103406:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010340a:	75 24                	jne    c0103430 <basic_check+0x38e>
c010340c:	c7 44 24 0c 00 6a 10 	movl   $0xc0106a00,0xc(%esp)
c0103413:	c0 
c0103414:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c010341b:	c0 
c010341c:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103423:	00 
c0103424:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c010342b:	e8 78 d8 ff ff       	call   c0100ca8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103430:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103437:	e8 31 0b 00 00       	call   c0103f6d <alloc_pages>
c010343c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010343f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103443:	75 24                	jne    c0103469 <basic_check+0x3c7>
c0103445:	c7 44 24 0c 1c 6a 10 	movl   $0xc0106a1c,0xc(%esp)
c010344c:	c0 
c010344d:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103454:	c0 
c0103455:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c010345c:	00 
c010345d:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103464:	e8 3f d8 ff ff       	call   c0100ca8 <__panic>

    assert(alloc_page() == NULL);
c0103469:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103470:	e8 f8 0a 00 00       	call   c0103f6d <alloc_pages>
c0103475:	85 c0                	test   %eax,%eax
c0103477:	74 24                	je     c010349d <basic_check+0x3fb>
c0103479:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c0103480:	c0 
c0103481:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103488:	c0 
c0103489:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103490:	00 
c0103491:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103498:	e8 0b d8 ff ff       	call   c0100ca8 <__panic>

    free_page(p0);
c010349d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01034a4:	00 
c01034a5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01034a8:	89 04 24             	mov    %eax,(%esp)
c01034ab:	e8 f5 0a 00 00       	call   c0103fa5 <free_pages>
c01034b0:	c7 45 d8 50 99 11 c0 	movl   $0xc0119950,-0x28(%ebp)
c01034b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01034ba:	8b 40 04             	mov    0x4(%eax),%eax
c01034bd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c01034c0:	0f 94 c0             	sete   %al
c01034c3:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c01034c6:	85 c0                	test   %eax,%eax
c01034c8:	74 24                	je     c01034ee <basic_check+0x44c>
c01034ca:	c7 44 24 0c 28 6b 10 	movl   $0xc0106b28,0xc(%esp)
c01034d1:	c0 
c01034d2:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01034d9:	c0 
c01034da:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c01034e1:	00 
c01034e2:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01034e9:	e8 ba d7 ff ff       	call   c0100ca8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c01034ee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01034f5:	e8 73 0a 00 00       	call   c0103f6d <alloc_pages>
c01034fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01034fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103500:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103503:	74 24                	je     c0103529 <basic_check+0x487>
c0103505:	c7 44 24 0c 40 6b 10 	movl   $0xc0106b40,0xc(%esp)
c010350c:	c0 
c010350d:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103514:	c0 
c0103515:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c010351c:	00 
c010351d:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103524:	e8 7f d7 ff ff       	call   c0100ca8 <__panic>
    assert(alloc_page() == NULL);
c0103529:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103530:	e8 38 0a 00 00       	call   c0103f6d <alloc_pages>
c0103535:	85 c0                	test   %eax,%eax
c0103537:	74 24                	je     c010355d <basic_check+0x4bb>
c0103539:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c0103540:	c0 
c0103541:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103548:	c0 
c0103549:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0103550:	00 
c0103551:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103558:	e8 4b d7 ff ff       	call   c0100ca8 <__panic>

    assert(nr_free == 0);
c010355d:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c0103562:	85 c0                	test   %eax,%eax
c0103564:	74 24                	je     c010358a <basic_check+0x4e8>
c0103566:	c7 44 24 0c 59 6b 10 	movl   $0xc0106b59,0xc(%esp)
c010356d:	c0 
c010356e:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103575:	c0 
c0103576:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c010357d:	00 
c010357e:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103585:	e8 1e d7 ff ff       	call   c0100ca8 <__panic>
    free_list = free_list_store;
c010358a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010358d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103590:	a3 50 99 11 c0       	mov    %eax,0xc0119950
c0103595:	89 15 54 99 11 c0    	mov    %edx,0xc0119954
    nr_free = nr_free_store;
c010359b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010359e:	a3 58 99 11 c0       	mov    %eax,0xc0119958

    free_page(p);
c01035a3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035aa:	00 
c01035ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01035ae:	89 04 24             	mov    %eax,(%esp)
c01035b1:	e8 ef 09 00 00       	call   c0103fa5 <free_pages>
    free_page(p1);
c01035b6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035bd:	00 
c01035be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035c1:	89 04 24             	mov    %eax,(%esp)
c01035c4:	e8 dc 09 00 00       	call   c0103fa5 <free_pages>
    free_page(p2);
c01035c9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01035d0:	00 
c01035d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035d4:	89 04 24             	mov    %eax,(%esp)
c01035d7:	e8 c9 09 00 00       	call   c0103fa5 <free_pages>
}
c01035dc:	c9                   	leave  
c01035dd:	c3                   	ret    

c01035de <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c01035de:	55                   	push   %ebp
c01035df:	89 e5                	mov    %esp,%ebp
c01035e1:	53                   	push   %ebx
c01035e2:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c01035e8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01035ef:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c01035f6:	c7 45 ec 50 99 11 c0 	movl   $0xc0119950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01035fd:	eb 6b                	jmp    c010366a <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c01035ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103602:	83 e8 0c             	sub    $0xc,%eax
c0103605:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103608:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010360b:	83 c0 04             	add    $0x4,%eax
c010360e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103615:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103618:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010361b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010361e:	0f a3 10             	bt     %edx,(%eax)
c0103621:	19 db                	sbb    %ebx,%ebx
c0103623:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    return oldbit != 0;
c0103626:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c010362a:	0f 95 c0             	setne  %al
c010362d:	0f b6 c0             	movzbl %al,%eax
c0103630:	85 c0                	test   %eax,%eax
c0103632:	75 24                	jne    c0103658 <default_check+0x7a>
c0103634:	c7 44 24 0c 66 6b 10 	movl   $0xc0106b66,0xc(%esp)
c010363b:	c0 
c010363c:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103643:	c0 
c0103644:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c010364b:	00 
c010364c:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103653:	e8 50 d6 ff ff       	call   c0100ca8 <__panic>
        count ++, total += p->property;
c0103658:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010365c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010365f:	8b 50 08             	mov    0x8(%eax),%edx
c0103662:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103665:	01 d0                	add    %edx,%eax
c0103667:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010366a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010366d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103670:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103673:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103676:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103679:	81 7d ec 50 99 11 c0 	cmpl   $0xc0119950,-0x14(%ebp)
c0103680:	0f 85 79 ff ff ff    	jne    c01035ff <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103686:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103689:	e8 49 09 00 00       	call   c0103fd7 <nr_free_pages>
c010368e:	39 c3                	cmp    %eax,%ebx
c0103690:	74 24                	je     c01036b6 <default_check+0xd8>
c0103692:	c7 44 24 0c 76 6b 10 	movl   $0xc0106b76,0xc(%esp)
c0103699:	c0 
c010369a:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01036a1:	c0 
c01036a2:	c7 44 24 04 f3 00 00 	movl   $0xf3,0x4(%esp)
c01036a9:	00 
c01036aa:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01036b1:	e8 f2 d5 ff ff       	call   c0100ca8 <__panic>

    basic_check();
c01036b6:	e8 e7 f9 ff ff       	call   c01030a2 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c01036bb:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01036c2:	e8 a6 08 00 00       	call   c0103f6d <alloc_pages>
c01036c7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c01036ca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01036ce:	75 24                	jne    c01036f4 <default_check+0x116>
c01036d0:	c7 44 24 0c 8f 6b 10 	movl   $0xc0106b8f,0xc(%esp)
c01036d7:	c0 
c01036d8:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01036df:	c0 
c01036e0:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c01036e7:	00 
c01036e8:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01036ef:	e8 b4 d5 ff ff       	call   c0100ca8 <__panic>
    assert(!PageProperty(p0));
c01036f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01036f7:	83 c0 04             	add    $0x4,%eax
c01036fa:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103701:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103704:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103707:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010370a:	0f a3 10             	bt     %edx,(%eax)
c010370d:	19 db                	sbb    %ebx,%ebx
c010370f:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    return oldbit != 0;
c0103712:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103716:	0f 95 c0             	setne  %al
c0103719:	0f b6 c0             	movzbl %al,%eax
c010371c:	85 c0                	test   %eax,%eax
c010371e:	74 24                	je     c0103744 <default_check+0x166>
c0103720:	c7 44 24 0c 9a 6b 10 	movl   $0xc0106b9a,0xc(%esp)
c0103727:	c0 
c0103728:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c010372f:	c0 
c0103730:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0103737:	00 
c0103738:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c010373f:	e8 64 d5 ff ff       	call   c0100ca8 <__panic>

    list_entry_t free_list_store = free_list;
c0103744:	a1 50 99 11 c0       	mov    0xc0119950,%eax
c0103749:	8b 15 54 99 11 c0    	mov    0xc0119954,%edx
c010374f:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103752:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103755:	c7 45 b4 50 99 11 c0 	movl   $0xc0119950,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010375c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010375f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103762:	89 50 04             	mov    %edx,0x4(%eax)
c0103765:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103768:	8b 50 04             	mov    0x4(%eax),%edx
c010376b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010376e:	89 10                	mov    %edx,(%eax)
c0103770:	c7 45 b0 50 99 11 c0 	movl   $0xc0119950,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103777:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010377a:	8b 40 04             	mov    0x4(%eax),%eax
c010377d:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103780:	0f 94 c0             	sete   %al
c0103783:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103786:	85 c0                	test   %eax,%eax
c0103788:	75 24                	jne    c01037ae <default_check+0x1d0>
c010378a:	c7 44 24 0c ef 6a 10 	movl   $0xc0106aef,0xc(%esp)
c0103791:	c0 
c0103792:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103799:	c0 
c010379a:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01037a1:	00 
c01037a2:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01037a9:	e8 fa d4 ff ff       	call   c0100ca8 <__panic>
    assert(alloc_page() == NULL);
c01037ae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01037b5:	e8 b3 07 00 00       	call   c0103f6d <alloc_pages>
c01037ba:	85 c0                	test   %eax,%eax
c01037bc:	74 24                	je     c01037e2 <default_check+0x204>
c01037be:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c01037c5:	c0 
c01037c6:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01037cd:	c0 
c01037ce:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c01037d5:	00 
c01037d6:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01037dd:	e8 c6 d4 ff ff       	call   c0100ca8 <__panic>

    unsigned int nr_free_store = nr_free;
c01037e2:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c01037e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c01037ea:	c7 05 58 99 11 c0 00 	movl   $0x0,0xc0119958
c01037f1:	00 00 00 

    free_pages(p0 + 2, 3);
c01037f4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037f7:	83 c0 28             	add    $0x28,%eax
c01037fa:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0103801:	00 
c0103802:	89 04 24             	mov    %eax,(%esp)
c0103805:	e8 9b 07 00 00       	call   c0103fa5 <free_pages>
    assert(alloc_pages(4) == NULL);
c010380a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0103811:	e8 57 07 00 00       	call   c0103f6d <alloc_pages>
c0103816:	85 c0                	test   %eax,%eax
c0103818:	74 24                	je     c010383e <default_check+0x260>
c010381a:	c7 44 24 0c ac 6b 10 	movl   $0xc0106bac,0xc(%esp)
c0103821:	c0 
c0103822:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103829:	c0 
c010382a:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c0103831:	00 
c0103832:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103839:	e8 6a d4 ff ff       	call   c0100ca8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010383e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103841:	83 c0 28             	add    $0x28,%eax
c0103844:	83 c0 04             	add    $0x4,%eax
c0103847:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010384e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103851:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0103854:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0103857:	0f a3 10             	bt     %edx,(%eax)
c010385a:	19 db                	sbb    %ebx,%ebx
c010385c:	89 5d a4             	mov    %ebx,-0x5c(%ebp)
    return oldbit != 0;
c010385f:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0103863:	0f 95 c0             	setne  %al
c0103866:	0f b6 c0             	movzbl %al,%eax
c0103869:	85 c0                	test   %eax,%eax
c010386b:	74 0e                	je     c010387b <default_check+0x29d>
c010386d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103870:	83 c0 28             	add    $0x28,%eax
c0103873:	8b 40 08             	mov    0x8(%eax),%eax
c0103876:	83 f8 03             	cmp    $0x3,%eax
c0103879:	74 24                	je     c010389f <default_check+0x2c1>
c010387b:	c7 44 24 0c c4 6b 10 	movl   $0xc0106bc4,0xc(%esp)
c0103882:	c0 
c0103883:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c010388a:	c0 
c010388b:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0103892:	00 
c0103893:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c010389a:	e8 09 d4 ff ff       	call   c0100ca8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010389f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01038a6:	e8 c2 06 00 00       	call   c0103f6d <alloc_pages>
c01038ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01038ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01038b2:	75 24                	jne    c01038d8 <default_check+0x2fa>
c01038b4:	c7 44 24 0c f0 6b 10 	movl   $0xc0106bf0,0xc(%esp)
c01038bb:	c0 
c01038bc:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01038c3:	c0 
c01038c4:	c7 44 24 04 06 01 00 	movl   $0x106,0x4(%esp)
c01038cb:	00 
c01038cc:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01038d3:	e8 d0 d3 ff ff       	call   c0100ca8 <__panic>
    assert(alloc_page() == NULL);
c01038d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038df:	e8 89 06 00 00       	call   c0103f6d <alloc_pages>
c01038e4:	85 c0                	test   %eax,%eax
c01038e6:	74 24                	je     c010390c <default_check+0x32e>
c01038e8:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c01038ef:	c0 
c01038f0:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01038f7:	c0 
c01038f8:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01038ff:	00 
c0103900:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103907:	e8 9c d3 ff ff       	call   c0100ca8 <__panic>
    assert(p0 + 2 == p1);
c010390c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010390f:	83 c0 28             	add    $0x28,%eax
c0103912:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0103915:	74 24                	je     c010393b <default_check+0x35d>
c0103917:	c7 44 24 0c 0e 6c 10 	movl   $0xc0106c0e,0xc(%esp)
c010391e:	c0 
c010391f:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103926:	c0 
c0103927:	c7 44 24 04 08 01 00 	movl   $0x108,0x4(%esp)
c010392e:	00 
c010392f:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103936:	e8 6d d3 ff ff       	call   c0100ca8 <__panic>

    p2 = p0 + 1;
c010393b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010393e:	83 c0 14             	add    $0x14,%eax
c0103941:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0103944:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010394b:	00 
c010394c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010394f:	89 04 24             	mov    %eax,(%esp)
c0103952:	e8 4e 06 00 00       	call   c0103fa5 <free_pages>
    free_pages(p1, 3);
c0103957:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010395e:	00 
c010395f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103962:	89 04 24             	mov    %eax,(%esp)
c0103965:	e8 3b 06 00 00       	call   c0103fa5 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010396a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010396d:	83 c0 04             	add    $0x4,%eax
c0103970:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0103977:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010397a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010397d:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0103980:	0f a3 10             	bt     %edx,(%eax)
c0103983:	19 db                	sbb    %ebx,%ebx
c0103985:	89 5d 98             	mov    %ebx,-0x68(%ebp)
    return oldbit != 0;
c0103988:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010398c:	0f 95 c0             	setne  %al
c010398f:	0f b6 c0             	movzbl %al,%eax
c0103992:	85 c0                	test   %eax,%eax
c0103994:	74 0b                	je     c01039a1 <default_check+0x3c3>
c0103996:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103999:	8b 40 08             	mov    0x8(%eax),%eax
c010399c:	83 f8 01             	cmp    $0x1,%eax
c010399f:	74 24                	je     c01039c5 <default_check+0x3e7>
c01039a1:	c7 44 24 0c 1c 6c 10 	movl   $0xc0106c1c,0xc(%esp)
c01039a8:	c0 
c01039a9:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c01039b0:	c0 
c01039b1:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01039b8:	00 
c01039b9:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c01039c0:	e8 e3 d2 ff ff       	call   c0100ca8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01039c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039c8:	83 c0 04             	add    $0x4,%eax
c01039cb:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01039d2:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01039d5:	8b 45 90             	mov    -0x70(%ebp),%eax
c01039d8:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01039db:	0f a3 10             	bt     %edx,(%eax)
c01039de:	19 db                	sbb    %ebx,%ebx
c01039e0:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
    return oldbit != 0;
c01039e3:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01039e7:	0f 95 c0             	setne  %al
c01039ea:	0f b6 c0             	movzbl %al,%eax
c01039ed:	85 c0                	test   %eax,%eax
c01039ef:	74 0b                	je     c01039fc <default_check+0x41e>
c01039f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039f4:	8b 40 08             	mov    0x8(%eax),%eax
c01039f7:	83 f8 03             	cmp    $0x3,%eax
c01039fa:	74 24                	je     c0103a20 <default_check+0x442>
c01039fc:	c7 44 24 0c 44 6c 10 	movl   $0xc0106c44,0xc(%esp)
c0103a03:	c0 
c0103a04:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103a0b:	c0 
c0103a0c:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0103a13:	00 
c0103a14:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103a1b:	e8 88 d2 ff ff       	call   c0100ca8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0103a20:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103a27:	e8 41 05 00 00       	call   c0103f6d <alloc_pages>
c0103a2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a2f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a32:	83 e8 14             	sub    $0x14,%eax
c0103a35:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103a38:	74 24                	je     c0103a5e <default_check+0x480>
c0103a3a:	c7 44 24 0c 6a 6c 10 	movl   $0xc0106c6a,0xc(%esp)
c0103a41:	c0 
c0103a42:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103a49:	c0 
c0103a4a:	c7 44 24 04 10 01 00 	movl   $0x110,0x4(%esp)
c0103a51:	00 
c0103a52:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103a59:	e8 4a d2 ff ff       	call   c0100ca8 <__panic>
    free_page(p0);
c0103a5e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103a65:	00 
c0103a66:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103a69:	89 04 24             	mov    %eax,(%esp)
c0103a6c:	e8 34 05 00 00       	call   c0103fa5 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0103a71:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0103a78:	e8 f0 04 00 00       	call   c0103f6d <alloc_pages>
c0103a7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103a80:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103a83:	83 c0 14             	add    $0x14,%eax
c0103a86:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0103a89:	74 24                	je     c0103aaf <default_check+0x4d1>
c0103a8b:	c7 44 24 0c 88 6c 10 	movl   $0xc0106c88,0xc(%esp)
c0103a92:	c0 
c0103a93:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103a9a:	c0 
c0103a9b:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0103aa2:	00 
c0103aa3:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103aaa:	e8 f9 d1 ff ff       	call   c0100ca8 <__panic>

    free_pages(p0, 2);
c0103aaf:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0103ab6:	00 
c0103ab7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103aba:	89 04 24             	mov    %eax,(%esp)
c0103abd:	e8 e3 04 00 00       	call   c0103fa5 <free_pages>
    free_page(p2);
c0103ac2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ac9:	00 
c0103aca:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103acd:	89 04 24             	mov    %eax,(%esp)
c0103ad0:	e8 d0 04 00 00       	call   c0103fa5 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0103ad5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103adc:	e8 8c 04 00 00       	call   c0103f6d <alloc_pages>
c0103ae1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103ae4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ae8:	75 24                	jne    c0103b0e <default_check+0x530>
c0103aea:	c7 44 24 0c a8 6c 10 	movl   $0xc0106ca8,0xc(%esp)
c0103af1:	c0 
c0103af2:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103af9:	c0 
c0103afa:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0103b01:	00 
c0103b02:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103b09:	e8 9a d1 ff ff       	call   c0100ca8 <__panic>
    assert(alloc_page() == NULL);
c0103b0e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b15:	e8 53 04 00 00       	call   c0103f6d <alloc_pages>
c0103b1a:	85 c0                	test   %eax,%eax
c0103b1c:	74 24                	je     c0103b42 <default_check+0x564>
c0103b1e:	c7 44 24 0c 06 6b 10 	movl   $0xc0106b06,0xc(%esp)
c0103b25:	c0 
c0103b26:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103b2d:	c0 
c0103b2e:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0103b35:	00 
c0103b36:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103b3d:	e8 66 d1 ff ff       	call   c0100ca8 <__panic>

    assert(nr_free == 0);
c0103b42:	a1 58 99 11 c0       	mov    0xc0119958,%eax
c0103b47:	85 c0                	test   %eax,%eax
c0103b49:	74 24                	je     c0103b6f <default_check+0x591>
c0103b4b:	c7 44 24 0c 59 6b 10 	movl   $0xc0106b59,0xc(%esp)
c0103b52:	c0 
c0103b53:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103b5a:	c0 
c0103b5b:	c7 44 24 04 1a 01 00 	movl   $0x11a,0x4(%esp)
c0103b62:	00 
c0103b63:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103b6a:	e8 39 d1 ff ff       	call   c0100ca8 <__panic>
    nr_free = nr_free_store;
c0103b6f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103b72:	a3 58 99 11 c0       	mov    %eax,0xc0119958

    free_list = free_list_store;
c0103b77:	8b 45 80             	mov    -0x80(%ebp),%eax
c0103b7a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0103b7d:	a3 50 99 11 c0       	mov    %eax,0xc0119950
c0103b82:	89 15 54 99 11 c0    	mov    %edx,0xc0119954
    free_pages(p0, 5);
c0103b88:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0103b8f:	00 
c0103b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103b93:	89 04 24             	mov    %eax,(%esp)
c0103b96:	e8 0a 04 00 00       	call   c0103fa5 <free_pages>

    le = &free_list;
c0103b9b:	c7 45 ec 50 99 11 c0 	movl   $0xc0119950,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103ba2:	eb 1f                	jmp    c0103bc3 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
c0103ba4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ba7:	83 e8 0c             	sub    $0xc,%eax
c0103baa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0103bad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0103bb1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103bb4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103bb7:	8b 40 08             	mov    0x8(%eax),%eax
c0103bba:	89 d1                	mov    %edx,%ecx
c0103bbc:	29 c1                	sub    %eax,%ecx
c0103bbe:	89 c8                	mov    %ecx,%eax
c0103bc0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103bc3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bc6:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103bc9:	8b 45 88             	mov    -0x78(%ebp),%eax
c0103bcc:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103bcf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103bd2:	81 7d ec 50 99 11 c0 	cmpl   $0xc0119950,-0x14(%ebp)
c0103bd9:	75 c9                	jne    c0103ba4 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c0103bdb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bdf:	74 24                	je     c0103c05 <default_check+0x627>
c0103be1:	c7 44 24 0c c6 6c 10 	movl   $0xc0106cc6,0xc(%esp)
c0103be8:	c0 
c0103be9:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103bf0:	c0 
c0103bf1:	c7 44 24 04 25 01 00 	movl   $0x125,0x4(%esp)
c0103bf8:	00 
c0103bf9:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103c00:	e8 a3 d0 ff ff       	call   c0100ca8 <__panic>
    assert(total == 0);
c0103c05:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c09:	74 24                	je     c0103c2f <default_check+0x651>
c0103c0b:	c7 44 24 0c d1 6c 10 	movl   $0xc0106cd1,0xc(%esp)
c0103c12:	c0 
c0103c13:	c7 44 24 08 96 69 10 	movl   $0xc0106996,0x8(%esp)
c0103c1a:	c0 
c0103c1b:	c7 44 24 04 26 01 00 	movl   $0x126,0x4(%esp)
c0103c22:	00 
c0103c23:	c7 04 24 ab 69 10 c0 	movl   $0xc01069ab,(%esp)
c0103c2a:	e8 79 d0 ff ff       	call   c0100ca8 <__panic>
}
c0103c2f:	81 c4 94 00 00 00    	add    $0x94,%esp
c0103c35:	5b                   	pop    %ebx
c0103c36:	5d                   	pop    %ebp
c0103c37:	c3                   	ret    

c0103c38 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103c38:	55                   	push   %ebp
c0103c39:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103c3b:	8b 55 08             	mov    0x8(%ebp),%edx
c0103c3e:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c0103c43:	89 d1                	mov    %edx,%ecx
c0103c45:	29 c1                	sub    %eax,%ecx
c0103c47:	89 c8                	mov    %ecx,%eax
c0103c49:	c1 f8 02             	sar    $0x2,%eax
c0103c4c:	69 c0 cd cc cc cc    	imul   $0xcccccccd,%eax,%eax
}
c0103c52:	5d                   	pop    %ebp
c0103c53:	c3                   	ret    

c0103c54 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0103c54:	55                   	push   %ebp
c0103c55:	89 e5                	mov    %esp,%ebp
c0103c57:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103c5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c5d:	89 04 24             	mov    %eax,(%esp)
c0103c60:	e8 d3 ff ff ff       	call   c0103c38 <page2ppn>
c0103c65:	c1 e0 0c             	shl    $0xc,%eax
}
c0103c68:	c9                   	leave  
c0103c69:	c3                   	ret    

c0103c6a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0103c6a:	55                   	push   %ebp
c0103c6b:	89 e5                	mov    %esp,%ebp
c0103c6d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0103c70:	8b 45 08             	mov    0x8(%ebp),%eax
c0103c73:	89 c2                	mov    %eax,%edx
c0103c75:	c1 ea 0c             	shr    $0xc,%edx
c0103c78:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0103c7d:	39 c2                	cmp    %eax,%edx
c0103c7f:	72 1c                	jb     c0103c9d <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0103c81:	c7 44 24 08 0c 6d 10 	movl   $0xc0106d0c,0x8(%esp)
c0103c88:	c0 
c0103c89:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0103c90:	00 
c0103c91:	c7 04 24 2b 6d 10 c0 	movl   $0xc0106d2b,(%esp)
c0103c98:	e8 0b d0 ff ff       	call   c0100ca8 <__panic>
    }
    return &pages[PPN(pa)];
c0103c9d:	8b 0d 64 99 11 c0    	mov    0xc0119964,%ecx
c0103ca3:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ca6:	89 c2                	mov    %eax,%edx
c0103ca8:	c1 ea 0c             	shr    $0xc,%edx
c0103cab:	89 d0                	mov    %edx,%eax
c0103cad:	c1 e0 02             	shl    $0x2,%eax
c0103cb0:	01 d0                	add    %edx,%eax
c0103cb2:	c1 e0 02             	shl    $0x2,%eax
c0103cb5:	01 c8                	add    %ecx,%eax
}
c0103cb7:	c9                   	leave  
c0103cb8:	c3                   	ret    

c0103cb9 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0103cb9:	55                   	push   %ebp
c0103cba:	89 e5                	mov    %esp,%ebp
c0103cbc:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0103cbf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103cc2:	89 04 24             	mov    %eax,(%esp)
c0103cc5:	e8 8a ff ff ff       	call   c0103c54 <page2pa>
c0103cca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ccd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cd0:	c1 e8 0c             	shr    $0xc,%eax
c0103cd3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103cd6:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0103cdb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0103cde:	72 23                	jb     c0103d03 <page2kva+0x4a>
c0103ce0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ce3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0103ce7:	c7 44 24 08 3c 6d 10 	movl   $0xc0106d3c,0x8(%esp)
c0103cee:	c0 
c0103cef:	c7 44 24 04 61 00 00 	movl   $0x61,0x4(%esp)
c0103cf6:	00 
c0103cf7:	c7 04 24 2b 6d 10 c0 	movl   $0xc0106d2b,(%esp)
c0103cfe:	e8 a5 cf ff ff       	call   c0100ca8 <__panic>
c0103d03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103d06:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0103d0b:	c9                   	leave  
c0103d0c:	c3                   	ret    

c0103d0d <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0103d0d:	55                   	push   %ebp
c0103d0e:	89 e5                	mov    %esp,%ebp
c0103d10:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0103d13:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d16:	83 e0 01             	and    $0x1,%eax
c0103d19:	85 c0                	test   %eax,%eax
c0103d1b:	75 1c                	jne    c0103d39 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0103d1d:	c7 44 24 08 60 6d 10 	movl   $0xc0106d60,0x8(%esp)
c0103d24:	c0 
c0103d25:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0103d2c:	00 
c0103d2d:	c7 04 24 2b 6d 10 c0 	movl   $0xc0106d2b,(%esp)
c0103d34:	e8 6f cf ff ff       	call   c0100ca8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0103d39:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d3c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d41:	89 04 24             	mov    %eax,(%esp)
c0103d44:	e8 21 ff ff ff       	call   c0103c6a <pa2page>
}
c0103d49:	c9                   	leave  
c0103d4a:	c3                   	ret    

c0103d4b <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0103d4b:	55                   	push   %ebp
c0103d4c:	89 e5                	mov    %esp,%ebp
c0103d4e:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0103d51:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d54:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0103d59:	89 04 24             	mov    %eax,(%esp)
c0103d5c:	e8 09 ff ff ff       	call   c0103c6a <pa2page>
}
c0103d61:	c9                   	leave  
c0103d62:	c3                   	ret    

c0103d63 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0103d63:	55                   	push   %ebp
c0103d64:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103d66:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d69:	8b 00                	mov    (%eax),%eax
}
c0103d6b:	5d                   	pop    %ebp
c0103d6c:	c3                   	ret    

c0103d6d <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0103d6d:	55                   	push   %ebp
c0103d6e:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0103d70:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d73:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103d76:	89 10                	mov    %edx,(%eax)
}
c0103d78:	5d                   	pop    %ebp
c0103d79:	c3                   	ret    

c0103d7a <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0103d7a:	55                   	push   %ebp
c0103d7b:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0103d7d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d80:	8b 00                	mov    (%eax),%eax
c0103d82:	8d 50 01             	lea    0x1(%eax),%edx
c0103d85:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d88:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103d8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d8d:	8b 00                	mov    (%eax),%eax
}
c0103d8f:	5d                   	pop    %ebp
c0103d90:	c3                   	ret    

c0103d91 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0103d91:	55                   	push   %ebp
c0103d92:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0103d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d97:	8b 00                	mov    (%eax),%eax
c0103d99:	8d 50 ff             	lea    -0x1(%eax),%edx
c0103d9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0103d9f:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0103da1:	8b 45 08             	mov    0x8(%ebp),%eax
c0103da4:	8b 00                	mov    (%eax),%eax
}
c0103da6:	5d                   	pop    %ebp
c0103da7:	c3                   	ret    

c0103da8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0103da8:	55                   	push   %ebp
c0103da9:	89 e5                	mov    %esp,%ebp
c0103dab:	53                   	push   %ebx
c0103dac:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0103daf:	9c                   	pushf  
c0103db0:	5b                   	pop    %ebx
c0103db1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0103db4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0103db7:	25 00 02 00 00       	and    $0x200,%eax
c0103dbc:	85 c0                	test   %eax,%eax
c0103dbe:	74 0c                	je     c0103dcc <__intr_save+0x24>
        intr_disable();
c0103dc0:	e8 75 d9 ff ff       	call   c010173a <intr_disable>
        return 1;
c0103dc5:	b8 01 00 00 00       	mov    $0x1,%eax
c0103dca:	eb 05                	jmp    c0103dd1 <__intr_save+0x29>
    }
    return 0;
c0103dcc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103dd1:	83 c4 14             	add    $0x14,%esp
c0103dd4:	5b                   	pop    %ebx
c0103dd5:	5d                   	pop    %ebp
c0103dd6:	c3                   	ret    

c0103dd7 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0103dd7:	55                   	push   %ebp
c0103dd8:	89 e5                	mov    %esp,%ebp
c0103dda:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0103ddd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103de1:	74 05                	je     c0103de8 <__intr_restore+0x11>
        intr_enable();
c0103de3:	e8 4c d9 ff ff       	call   c0101734 <intr_enable>
    }
}
c0103de8:	c9                   	leave  
c0103de9:	c3                   	ret    

c0103dea <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0103dea:	55                   	push   %ebp
c0103deb:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0103ded:	8b 45 08             	mov    0x8(%ebp),%eax
c0103df0:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0103df3:	b8 23 00 00 00       	mov    $0x23,%eax
c0103df8:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0103dfa:	b8 23 00 00 00       	mov    $0x23,%eax
c0103dff:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0103e01:	b8 10 00 00 00       	mov    $0x10,%eax
c0103e06:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0103e08:	b8 10 00 00 00       	mov    $0x10,%eax
c0103e0d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0103e0f:	b8 10 00 00 00       	mov    $0x10,%eax
c0103e14:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0103e16:	ea 1d 3e 10 c0 08 00 	ljmp   $0x8,$0xc0103e1d
}
c0103e1d:	5d                   	pop    %ebp
c0103e1e:	c3                   	ret    

c0103e1f <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0103e1f:	55                   	push   %ebp
c0103e20:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0103e22:	8b 45 08             	mov    0x8(%ebp),%eax
c0103e25:	a3 e4 98 11 c0       	mov    %eax,0xc01198e4
}
c0103e2a:	5d                   	pop    %ebp
c0103e2b:	c3                   	ret    

c0103e2c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0103e2c:	55                   	push   %ebp
c0103e2d:	89 e5                	mov    %esp,%ebp
c0103e2f:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0103e32:	b8 00 80 11 c0       	mov    $0xc0118000,%eax
c0103e37:	89 04 24             	mov    %eax,(%esp)
c0103e3a:	e8 e0 ff ff ff       	call   c0103e1f <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0103e3f:	66 c7 05 e8 98 11 c0 	movw   $0x10,0xc01198e8
c0103e46:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0103e48:	66 c7 05 28 8a 11 c0 	movw   $0x68,0xc0118a28
c0103e4f:	68 00 
c0103e51:	b8 e0 98 11 c0       	mov    $0xc01198e0,%eax
c0103e56:	66 a3 2a 8a 11 c0    	mov    %ax,0xc0118a2a
c0103e5c:	b8 e0 98 11 c0       	mov    $0xc01198e0,%eax
c0103e61:	c1 e8 10             	shr    $0x10,%eax
c0103e64:	a2 2c 8a 11 c0       	mov    %al,0xc0118a2c
c0103e69:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e70:	83 e0 f0             	and    $0xfffffff0,%eax
c0103e73:	83 c8 09             	or     $0x9,%eax
c0103e76:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e7b:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e82:	83 e0 ef             	and    $0xffffffef,%eax
c0103e85:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e8a:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103e91:	83 e0 9f             	and    $0xffffff9f,%eax
c0103e94:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103e99:	0f b6 05 2d 8a 11 c0 	movzbl 0xc0118a2d,%eax
c0103ea0:	83 c8 80             	or     $0xffffff80,%eax
c0103ea3:	a2 2d 8a 11 c0       	mov    %al,0xc0118a2d
c0103ea8:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103eaf:	83 e0 f0             	and    $0xfffffff0,%eax
c0103eb2:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103eb7:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ebe:	83 e0 ef             	and    $0xffffffef,%eax
c0103ec1:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ec6:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103ecd:	83 e0 df             	and    $0xffffffdf,%eax
c0103ed0:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ed5:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103edc:	83 c8 40             	or     $0x40,%eax
c0103edf:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ee4:	0f b6 05 2e 8a 11 c0 	movzbl 0xc0118a2e,%eax
c0103eeb:	83 e0 7f             	and    $0x7f,%eax
c0103eee:	a2 2e 8a 11 c0       	mov    %al,0xc0118a2e
c0103ef3:	b8 e0 98 11 c0       	mov    $0xc01198e0,%eax
c0103ef8:	c1 e8 18             	shr    $0x18,%eax
c0103efb:	a2 2f 8a 11 c0       	mov    %al,0xc0118a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c0103f00:	c7 04 24 30 8a 11 c0 	movl   $0xc0118a30,(%esp)
c0103f07:	e8 de fe ff ff       	call   c0103dea <lgdt>
c0103f0c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0103f12:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0103f16:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0103f19:	c9                   	leave  
c0103f1a:	c3                   	ret    

c0103f1b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0103f1b:	55                   	push   %ebp
c0103f1c:	89 e5                	mov    %esp,%ebp
c0103f1e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0103f21:	c7 05 5c 99 11 c0 f0 	movl   $0xc0106cf0,0xc011995c
c0103f28:	6c 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0103f2b:	a1 5c 99 11 c0       	mov    0xc011995c,%eax
c0103f30:	8b 00                	mov    (%eax),%eax
c0103f32:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f36:	c7 04 24 8c 6d 10 c0 	movl   $0xc0106d8c,(%esp)
c0103f3d:	e8 05 c4 ff ff       	call   c0100347 <cprintf>
    pmm_manager->init();
c0103f42:	a1 5c 99 11 c0       	mov    0xc011995c,%eax
c0103f47:	8b 40 04             	mov    0x4(%eax),%eax
c0103f4a:	ff d0                	call   *%eax
}
c0103f4c:	c9                   	leave  
c0103f4d:	c3                   	ret    

c0103f4e <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0103f4e:	55                   	push   %ebp
c0103f4f:	89 e5                	mov    %esp,%ebp
c0103f51:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0103f54:	a1 5c 99 11 c0       	mov    0xc011995c,%eax
c0103f59:	8b 50 08             	mov    0x8(%eax),%edx
c0103f5c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103f5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103f63:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f66:	89 04 24             	mov    %eax,(%esp)
c0103f69:	ff d2                	call   *%edx
}
c0103f6b:	c9                   	leave  
c0103f6c:	c3                   	ret    

c0103f6d <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0103f6d:	55                   	push   %ebp
c0103f6e:	89 e5                	mov    %esp,%ebp
c0103f70:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0103f73:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c0103f7a:	e8 29 fe ff ff       	call   c0103da8 <__intr_save>
c0103f7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        page = pmm_manager->alloc_pages(n);
c0103f82:	a1 5c 99 11 c0       	mov    0xc011995c,%eax
c0103f87:	8b 50 0c             	mov    0xc(%eax),%edx
c0103f8a:	8b 45 08             	mov    0x8(%ebp),%eax
c0103f8d:	89 04 24             	mov    %eax,(%esp)
c0103f90:	ff d2                	call   *%edx
c0103f92:	89 45 f4             	mov    %eax,-0xc(%ebp)
    }
    local_intr_restore(intr_flag);
c0103f95:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103f98:	89 04 24             	mov    %eax,(%esp)
c0103f9b:	e8 37 fe ff ff       	call   c0103dd7 <__intr_restore>
    return page;
c0103fa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0103fa3:	c9                   	leave  
c0103fa4:	c3                   	ret    

c0103fa5 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0103fa5:	55                   	push   %ebp
c0103fa6:	89 e5                	mov    %esp,%ebp
c0103fa8:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0103fab:	e8 f8 fd ff ff       	call   c0103da8 <__intr_save>
c0103fb0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0103fb3:	a1 5c 99 11 c0       	mov    0xc011995c,%eax
c0103fb8:	8b 50 10             	mov    0x10(%eax),%edx
c0103fbb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103fbe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0103fc2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103fc5:	89 04 24             	mov    %eax,(%esp)
c0103fc8:	ff d2                	call   *%edx
    }
    local_intr_restore(intr_flag);
c0103fca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103fcd:	89 04 24             	mov    %eax,(%esp)
c0103fd0:	e8 02 fe ff ff       	call   c0103dd7 <__intr_restore>
}
c0103fd5:	c9                   	leave  
c0103fd6:	c3                   	ret    

c0103fd7 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0103fd7:	55                   	push   %ebp
c0103fd8:	89 e5                	mov    %esp,%ebp
c0103fda:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0103fdd:	e8 c6 fd ff ff       	call   c0103da8 <__intr_save>
c0103fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0103fe5:	a1 5c 99 11 c0       	mov    0xc011995c,%eax
c0103fea:	8b 40 14             	mov    0x14(%eax),%eax
c0103fed:	ff d0                	call   *%eax
c0103fef:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0103ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103ff5:	89 04 24             	mov    %eax,(%esp)
c0103ff8:	e8 da fd ff ff       	call   c0103dd7 <__intr_restore>
    return ret;
c0103ffd:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104000:	c9                   	leave  
c0104001:	c3                   	ret    

c0104002 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104002:	55                   	push   %ebp
c0104003:	89 e5                	mov    %esp,%ebp
c0104005:	57                   	push   %edi
c0104006:	56                   	push   %esi
c0104007:	53                   	push   %ebx
c0104008:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010400e:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104015:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c010401c:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104023:	c7 04 24 a3 6d 10 c0 	movl   $0xc0106da3,(%esp)
c010402a:	e8 18 c3 ff ff       	call   c0100347 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010402f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104036:	e9 0b 01 00 00       	jmp    c0104146 <page_init+0x144>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010403b:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010403e:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104041:	89 d0                	mov    %edx,%eax
c0104043:	c1 e0 02             	shl    $0x2,%eax
c0104046:	01 d0                	add    %edx,%eax
c0104048:	c1 e0 02             	shl    $0x2,%eax
c010404b:	01 c8                	add    %ecx,%eax
c010404d:	8b 50 08             	mov    0x8(%eax),%edx
c0104050:	8b 40 04             	mov    0x4(%eax),%eax
c0104053:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104056:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104059:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010405c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010405f:	89 d0                	mov    %edx,%eax
c0104061:	c1 e0 02             	shl    $0x2,%eax
c0104064:	01 d0                	add    %edx,%eax
c0104066:	c1 e0 02             	shl    $0x2,%eax
c0104069:	01 c8                	add    %ecx,%eax
c010406b:	8b 50 10             	mov    0x10(%eax),%edx
c010406e:	8b 40 0c             	mov    0xc(%eax),%eax
c0104071:	03 45 b8             	add    -0x48(%ebp),%eax
c0104074:	13 55 bc             	adc    -0x44(%ebp),%edx
c0104077:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010407a:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c010407d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104080:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104083:	89 d0                	mov    %edx,%eax
c0104085:	c1 e0 02             	shl    $0x2,%eax
c0104088:	01 d0                	add    %edx,%eax
c010408a:	c1 e0 02             	shl    $0x2,%eax
c010408d:	01 c8                	add    %ecx,%eax
c010408f:	83 c0 14             	add    $0x14,%eax
c0104092:	8b 00                	mov    (%eax),%eax
c0104094:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104097:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010409a:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010409d:	89 c6                	mov    %eax,%esi
c010409f:	89 d7                	mov    %edx,%edi
c01040a1:	83 c6 ff             	add    $0xffffffff,%esi
c01040a4:	83 d7 ff             	adc    $0xffffffff,%edi
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c01040a7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01040aa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040ad:	89 d0                	mov    %edx,%eax
c01040af:	c1 e0 02             	shl    $0x2,%eax
c01040b2:	01 d0                	add    %edx,%eax
c01040b4:	c1 e0 02             	shl    $0x2,%eax
c01040b7:	01 c8                	add    %ecx,%eax
c01040b9:	8b 48 0c             	mov    0xc(%eax),%ecx
c01040bc:	8b 58 10             	mov    0x10(%eax),%ebx
c01040bf:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01040c2:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01040c6:	89 74 24 14          	mov    %esi,0x14(%esp)
c01040ca:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01040ce:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01040d1:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01040d4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01040d8:	89 54 24 10          	mov    %edx,0x10(%esp)
c01040dc:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01040e0:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01040e4:	c7 04 24 b0 6d 10 c0 	movl   $0xc0106db0,(%esp)
c01040eb:	e8 57 c2 ff ff       	call   c0100347 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01040f0:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01040f3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01040f6:	89 d0                	mov    %edx,%eax
c01040f8:	c1 e0 02             	shl    $0x2,%eax
c01040fb:	01 d0                	add    %edx,%eax
c01040fd:	c1 e0 02             	shl    $0x2,%eax
c0104100:	01 c8                	add    %ecx,%eax
c0104102:	83 c0 14             	add    $0x14,%eax
c0104105:	8b 00                	mov    (%eax),%eax
c0104107:	83 f8 01             	cmp    $0x1,%eax
c010410a:	75 36                	jne    c0104142 <page_init+0x140>
            if (maxpa < end && begin < KMEMSIZE) {
c010410c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010410f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104112:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104115:	77 2b                	ja     c0104142 <page_init+0x140>
c0104117:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010411a:	72 05                	jb     c0104121 <page_init+0x11f>
c010411c:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010411f:	73 21                	jae    c0104142 <page_init+0x140>
c0104121:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104125:	77 1b                	ja     c0104142 <page_init+0x140>
c0104127:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010412b:	72 09                	jb     c0104136 <page_init+0x134>
c010412d:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c0104134:	77 0c                	ja     c0104142 <page_init+0x140>
                maxpa = end;
c0104136:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104139:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010413c:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010413f:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104142:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104146:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104149:	8b 00                	mov    (%eax),%eax
c010414b:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c010414e:	0f 8f e7 fe ff ff    	jg     c010403b <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c0104154:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104158:	72 1d                	jb     c0104177 <page_init+0x175>
c010415a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010415e:	77 09                	ja     c0104169 <page_init+0x167>
c0104160:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c0104167:	76 0e                	jbe    c0104177 <page_init+0x175>
        maxpa = KMEMSIZE;
c0104169:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0104170:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c0104177:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010417a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010417d:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104181:	c1 ea 0c             	shr    $0xc,%edx
c0104184:	a3 c0 98 11 c0       	mov    %eax,0xc01198c0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0104189:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0104190:	b8 68 99 11 c0       	mov    $0xc0119968,%eax
c0104195:	83 e8 01             	sub    $0x1,%eax
c0104198:	03 45 ac             	add    -0x54(%ebp),%eax
c010419b:	89 45 a8             	mov    %eax,-0x58(%ebp)
c010419e:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01041a1:	ba 00 00 00 00       	mov    $0x0,%edx
c01041a6:	f7 75 ac             	divl   -0x54(%ebp)
c01041a9:	89 d0                	mov    %edx,%eax
c01041ab:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01041ae:	89 d1                	mov    %edx,%ecx
c01041b0:	29 c1                	sub    %eax,%ecx
c01041b2:	89 c8                	mov    %ecx,%eax
c01041b4:	a3 64 99 11 c0       	mov    %eax,0xc0119964

    for (i = 0; i < npage; i ++) {
c01041b9:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01041c0:	eb 2f                	jmp    c01041f1 <page_init+0x1ef>
        SetPageReserved(pages + i);
c01041c2:	8b 0d 64 99 11 c0    	mov    0xc0119964,%ecx
c01041c8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041cb:	89 d0                	mov    %edx,%eax
c01041cd:	c1 e0 02             	shl    $0x2,%eax
c01041d0:	01 d0                	add    %edx,%eax
c01041d2:	c1 e0 02             	shl    $0x2,%eax
c01041d5:	01 c8                	add    %ecx,%eax
c01041d7:	83 c0 04             	add    $0x4,%eax
c01041da:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01041e1:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01041e4:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01041e7:	8b 55 90             	mov    -0x70(%ebp),%edx
c01041ea:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01041ed:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01041f1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01041f4:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c01041f9:	39 c2                	cmp    %eax,%edx
c01041fb:	72 c5                	jb     c01041c2 <page_init+0x1c0>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01041fd:	8b 15 c0 98 11 c0    	mov    0xc01198c0,%edx
c0104203:	89 d0                	mov    %edx,%eax
c0104205:	c1 e0 02             	shl    $0x2,%eax
c0104208:	01 d0                	add    %edx,%eax
c010420a:	c1 e0 02             	shl    $0x2,%eax
c010420d:	89 c2                	mov    %eax,%edx
c010420f:	a1 64 99 11 c0       	mov    0xc0119964,%eax
c0104214:	01 d0                	add    %edx,%eax
c0104216:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104219:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104220:	77 23                	ja     c0104245 <page_init+0x243>
c0104222:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104225:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104229:	c7 44 24 08 e0 6d 10 	movl   $0xc0106de0,0x8(%esp)
c0104230:	c0 
c0104231:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c0104238:	00 
c0104239:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104240:	e8 63 ca ff ff       	call   c0100ca8 <__panic>
c0104245:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104248:	05 00 00 00 40       	add    $0x40000000,%eax
c010424d:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104250:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104257:	e9 7c 01 00 00       	jmp    c01043d8 <page_init+0x3d6>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c010425c:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010425f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104262:	89 d0                	mov    %edx,%eax
c0104264:	c1 e0 02             	shl    $0x2,%eax
c0104267:	01 d0                	add    %edx,%eax
c0104269:	c1 e0 02             	shl    $0x2,%eax
c010426c:	01 c8                	add    %ecx,%eax
c010426e:	8b 50 08             	mov    0x8(%eax),%edx
c0104271:	8b 40 04             	mov    0x4(%eax),%eax
c0104274:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104277:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010427a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c010427d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104280:	89 d0                	mov    %edx,%eax
c0104282:	c1 e0 02             	shl    $0x2,%eax
c0104285:	01 d0                	add    %edx,%eax
c0104287:	c1 e0 02             	shl    $0x2,%eax
c010428a:	01 c8                	add    %ecx,%eax
c010428c:	8b 50 10             	mov    0x10(%eax),%edx
c010428f:	8b 40 0c             	mov    0xc(%eax),%eax
c0104292:	03 45 d0             	add    -0x30(%ebp),%eax
c0104295:	13 55 d4             	adc    -0x2c(%ebp),%edx
c0104298:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010429b:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c010429e:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01042a1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01042a4:	89 d0                	mov    %edx,%eax
c01042a6:	c1 e0 02             	shl    $0x2,%eax
c01042a9:	01 d0                	add    %edx,%eax
c01042ab:	c1 e0 02             	shl    $0x2,%eax
c01042ae:	01 c8                	add    %ecx,%eax
c01042b0:	83 c0 14             	add    $0x14,%eax
c01042b3:	8b 00                	mov    (%eax),%eax
c01042b5:	83 f8 01             	cmp    $0x1,%eax
c01042b8:	0f 85 16 01 00 00    	jne    c01043d4 <page_init+0x3d2>
            if (begin < freemem) {
c01042be:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01042c1:	ba 00 00 00 00       	mov    $0x0,%edx
c01042c6:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01042c9:	72 17                	jb     c01042e2 <page_init+0x2e0>
c01042cb:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01042ce:	77 05                	ja     c01042d5 <page_init+0x2d3>
c01042d0:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01042d3:	76 0d                	jbe    c01042e2 <page_init+0x2e0>
                begin = freemem;
c01042d5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01042d8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01042db:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01042e2:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01042e6:	72 1d                	jb     c0104305 <page_init+0x303>
c01042e8:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01042ec:	77 09                	ja     c01042f7 <page_init+0x2f5>
c01042ee:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01042f5:	76 0e                	jbe    c0104305 <page_init+0x303>
                end = KMEMSIZE;
c01042f7:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01042fe:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104305:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104308:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010430b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010430e:	0f 87 c0 00 00 00    	ja     c01043d4 <page_init+0x3d2>
c0104314:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104317:	72 09                	jb     c0104322 <page_init+0x320>
c0104319:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010431c:	0f 83 b2 00 00 00    	jae    c01043d4 <page_init+0x3d2>
                begin = ROUNDUP(begin, PGSIZE);
c0104322:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104329:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010432c:	03 45 9c             	add    -0x64(%ebp),%eax
c010432f:	83 e8 01             	sub    $0x1,%eax
c0104332:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104335:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104338:	ba 00 00 00 00       	mov    $0x0,%edx
c010433d:	f7 75 9c             	divl   -0x64(%ebp)
c0104340:	89 d0                	mov    %edx,%eax
c0104342:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104345:	89 d1                	mov    %edx,%ecx
c0104347:	29 c1                	sub    %eax,%ecx
c0104349:	89 c8                	mov    %ecx,%eax
c010434b:	ba 00 00 00 00       	mov    $0x0,%edx
c0104350:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104353:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104356:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104359:	89 45 94             	mov    %eax,-0x6c(%ebp)
c010435c:	8b 45 94             	mov    -0x6c(%ebp),%eax
c010435f:	ba 00 00 00 00       	mov    $0x0,%edx
c0104364:	89 c1                	mov    %eax,%ecx
c0104366:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
c010436c:	89 8d 78 ff ff ff    	mov    %ecx,-0x88(%ebp)
c0104372:	89 d1                	mov    %edx,%ecx
c0104374:	83 e1 00             	and    $0x0,%ecx
c0104377:	89 8d 7c ff ff ff    	mov    %ecx,-0x84(%ebp)
c010437d:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0104383:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0104389:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010438c:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c010438f:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104392:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104395:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104398:	77 3a                	ja     c01043d4 <page_init+0x3d2>
c010439a:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010439d:	72 05                	jb     c01043a4 <page_init+0x3a2>
c010439f:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c01043a2:	73 30                	jae    c01043d4 <page_init+0x3d2>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c01043a4:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01043a7:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01043aa:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01043ad:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01043b0:	29 c8                	sub    %ecx,%eax
c01043b2:	19 da                	sbb    %ebx,%edx
c01043b4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01043b8:	c1 ea 0c             	shr    $0xc,%edx
c01043bb:	89 c3                	mov    %eax,%ebx
c01043bd:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01043c0:	89 04 24             	mov    %eax,(%esp)
c01043c3:	e8 a2 f8 ff ff       	call   c0103c6a <pa2page>
c01043c8:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01043cc:	89 04 24             	mov    %eax,(%esp)
c01043cf:	e8 7a fb ff ff       	call   c0103f4e <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01043d4:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01043d8:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01043db:	8b 00                	mov    (%eax),%eax
c01043dd:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01043e0:	0f 8f 76 fe ff ff    	jg     c010425c <page_init+0x25a>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01043e6:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01043ec:	5b                   	pop    %ebx
c01043ed:	5e                   	pop    %esi
c01043ee:	5f                   	pop    %edi
c01043ef:	5d                   	pop    %ebp
c01043f0:	c3                   	ret    

c01043f1 <enable_paging>:

static void
enable_paging(void) {
c01043f1:	55                   	push   %ebp
c01043f2:	89 e5                	mov    %esp,%ebp
c01043f4:	53                   	push   %ebx
c01043f5:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01043f8:	a1 60 99 11 c0       	mov    0xc0119960,%eax
c01043fd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104400:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104403:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104406:	0f 20 c3             	mov    %cr0,%ebx
c0104409:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr0;
c010440c:	8b 45 f0             	mov    -0x10(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c010440f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104412:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104419:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c010441d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104420:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104423:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104426:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104429:	83 c4 10             	add    $0x10,%esp
c010442c:	5b                   	pop    %ebx
c010442d:	5d                   	pop    %ebp
c010442e:	c3                   	ret    

c010442f <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c010442f:	55                   	push   %ebp
c0104430:	89 e5                	mov    %esp,%ebp
c0104432:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104435:	8b 45 14             	mov    0x14(%ebp),%eax
c0104438:	8b 55 0c             	mov    0xc(%ebp),%edx
c010443b:	31 d0                	xor    %edx,%eax
c010443d:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104442:	85 c0                	test   %eax,%eax
c0104444:	74 24                	je     c010446a <boot_map_segment+0x3b>
c0104446:	c7 44 24 0c 12 6e 10 	movl   $0xc0106e12,0xc(%esp)
c010444d:	c0 
c010444e:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104455:	c0 
c0104456:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c010445d:	00 
c010445e:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104465:	e8 3e c8 ff ff       	call   c0100ca8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c010446a:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104471:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104474:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104479:	03 45 10             	add    0x10(%ebp),%eax
c010447c:	03 45 f0             	add    -0x10(%ebp),%eax
c010447f:	83 e8 01             	sub    $0x1,%eax
c0104482:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104485:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104488:	ba 00 00 00 00       	mov    $0x0,%edx
c010448d:	f7 75 f0             	divl   -0x10(%ebp)
c0104490:	89 d0                	mov    %edx,%eax
c0104492:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104495:	89 d1                	mov    %edx,%ecx
c0104497:	29 c1                	sub    %eax,%ecx
c0104499:	89 c8                	mov    %ecx,%eax
c010449b:	c1 e8 0c             	shr    $0xc,%eax
c010449e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c01044a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01044a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01044aa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044af:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01044b2:	8b 45 14             	mov    0x14(%ebp),%eax
c01044b5:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044b8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044bb:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01044c0:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01044c3:	eb 6b                	jmp    c0104530 <boot_map_segment+0x101>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01044c5:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01044cc:	00 
c01044cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01044d0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01044d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01044d7:	89 04 24             	mov    %eax,(%esp)
c01044da:	e8 cc 01 00 00       	call   c01046ab <get_pte>
c01044df:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01044e2:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01044e6:	75 24                	jne    c010450c <boot_map_segment+0xdd>
c01044e8:	c7 44 24 0c 3e 6e 10 	movl   $0xc0106e3e,0xc(%esp)
c01044ef:	c0 
c01044f0:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c01044f7:	c0 
c01044f8:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c01044ff:	00 
c0104500:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104507:	e8 9c c7 ff ff       	call   c0100ca8 <__panic>
        *ptep = pa | PTE_P | perm;
c010450c:	8b 45 18             	mov    0x18(%ebp),%eax
c010450f:	8b 55 14             	mov    0x14(%ebp),%edx
c0104512:	09 d0                	or     %edx,%eax
c0104514:	89 c2                	mov    %eax,%edx
c0104516:	83 ca 01             	or     $0x1,%edx
c0104519:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010451c:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c010451e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104522:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104529:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104530:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104534:	75 8f                	jne    c01044c5 <boot_map_segment+0x96>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104536:	c9                   	leave  
c0104537:	c3                   	ret    

c0104538 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104538:	55                   	push   %ebp
c0104539:	89 e5                	mov    %esp,%ebp
c010453b:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c010453e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104545:	e8 23 fa ff ff       	call   c0103f6d <alloc_pages>
c010454a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c010454d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104551:	75 1c                	jne    c010456f <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104553:	c7 44 24 08 4b 6e 10 	movl   $0xc0106e4b,0x8(%esp)
c010455a:	c0 
c010455b:	c7 44 24 04 16 01 00 	movl   $0x116,0x4(%esp)
c0104562:	00 
c0104563:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c010456a:	e8 39 c7 ff ff       	call   c0100ca8 <__panic>
    }
    return page2kva(p);
c010456f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104572:	89 04 24             	mov    %eax,(%esp)
c0104575:	e8 3f f7 ff ff       	call   c0103cb9 <page2kva>
}
c010457a:	c9                   	leave  
c010457b:	c3                   	ret    

c010457c <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c010457c:	55                   	push   %ebp
c010457d:	89 e5                	mov    %esp,%ebp
c010457f:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104582:	e8 94 f9 ff ff       	call   c0103f1b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104587:	e8 76 fa ff ff       	call   c0104002 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010458c:	e8 7f 04 00 00       	call   c0104a10 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104591:	e8 a2 ff ff ff       	call   c0104538 <boot_alloc_page>
c0104596:	a3 c4 98 11 c0       	mov    %eax,0xc01198c4
    memset(boot_pgdir, 0, PGSIZE);
c010459b:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01045a0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01045a7:	00 
c01045a8:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01045af:	00 
c01045b0:	89 04 24             	mov    %eax,(%esp)
c01045b3:	e8 0f 1b 00 00       	call   c01060c7 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01045b8:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01045bd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01045c0:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01045c7:	77 23                	ja     c01045ec <pmm_init+0x70>
c01045c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045cc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01045d0:	c7 44 24 08 e0 6d 10 	movl   $0xc0106de0,0x8(%esp)
c01045d7:	c0 
c01045d8:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c01045df:	00 
c01045e0:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c01045e7:	e8 bc c6 ff ff       	call   c0100ca8 <__panic>
c01045ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045ef:	05 00 00 00 40       	add    $0x40000000,%eax
c01045f4:	a3 60 99 11 c0       	mov    %eax,0xc0119960

    check_pgdir();
c01045f9:	e8 30 04 00 00       	call   c0104a2e <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01045fe:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104603:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104609:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c010460e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104611:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104618:	77 23                	ja     c010463d <pmm_init+0xc1>
c010461a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010461d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104621:	c7 44 24 08 e0 6d 10 	movl   $0xc0106de0,0x8(%esp)
c0104628:	c0 
c0104629:	c7 44 24 04 38 01 00 	movl   $0x138,0x4(%esp)
c0104630:	00 
c0104631:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104638:	e8 6b c6 ff ff       	call   c0100ca8 <__panic>
c010463d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104640:	05 00 00 00 40       	add    $0x40000000,%eax
c0104645:	83 c8 03             	or     $0x3,%eax
c0104648:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c010464a:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c010464f:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104656:	00 
c0104657:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010465e:	00 
c010465f:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104666:	38 
c0104667:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c010466e:	c0 
c010466f:	89 04 24             	mov    %eax,(%esp)
c0104672:	e8 b8 fd ff ff       	call   c010442f <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104677:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c010467c:	8b 15 c4 98 11 c0    	mov    0xc01198c4,%edx
c0104682:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104688:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010468a:	e8 62 fd ff ff       	call   c01043f1 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c010468f:	e8 98 f7 ff ff       	call   c0103e2c <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104694:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104699:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c010469f:	e8 25 0a 00 00       	call   c01050c9 <check_boot_pgdir>

    print_pgdir();
c01046a4:	e8 99 0e 00 00       	call   c0105542 <print_pgdir>

}
c01046a9:	c9                   	leave  
c01046aa:	c3                   	ret    

c01046ab <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01046ab:	55                   	push   %ebp
c01046ac:	89 e5                	mov    %esp,%ebp
c01046ae:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01046b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01046b4:	c1 e8 16             	shr    $0x16,%eax
c01046b7:	c1 e0 02             	shl    $0x2,%eax
c01046ba:	03 45 08             	add    0x8(%ebp),%eax
c01046bd:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!(*pdep & PTE_P)) {
c01046c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046c3:	8b 00                	mov    (%eax),%eax
c01046c5:	83 e0 01             	and    $0x1,%eax
c01046c8:	85 c0                	test   %eax,%eax
c01046ca:	0f 85 c4 00 00 00    	jne    c0104794 <get_pte+0xe9>
        if (!create)
c01046d0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01046d4:	75 0a                	jne    c01046e0 <get_pte+0x35>
            return NULL;
c01046d6:	b8 00 00 00 00       	mov    $0x0,%eax
c01046db:	e9 10 01 00 00       	jmp    c01047f0 <get_pte+0x145>
        struct Page* page;
        if (create && (page = alloc_pages(1)) == NULL)
c01046e0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01046e4:	74 1f                	je     c0104705 <get_pte+0x5a>
c01046e6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01046ed:	e8 7b f8 ff ff       	call   c0103f6d <alloc_pages>
c01046f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01046f5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01046f9:	75 0a                	jne    c0104705 <get_pte+0x5a>
            return NULL;
c01046fb:	b8 00 00 00 00       	mov    $0x0,%eax
c0104700:	e9 eb 00 00 00       	jmp    c01047f0 <get_pte+0x145>
        set_page_ref(page, 1);
c0104705:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010470c:	00 
c010470d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104710:	89 04 24             	mov    %eax,(%esp)
c0104713:	e8 55 f6 ff ff       	call   c0103d6d <set_page_ref>
        uintptr_t phia = page2pa(page);
c0104718:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471b:	89 04 24             	mov    %eax,(%esp)
c010471e:	e8 31 f5 ff ff       	call   c0103c54 <page2pa>
c0104723:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(phia), 0, PGSIZE);
c0104726:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104729:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010472c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010472f:	c1 e8 0c             	shr    $0xc,%eax
c0104732:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104735:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c010473a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010473d:	72 23                	jb     c0104762 <get_pte+0xb7>
c010473f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104742:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104746:	c7 44 24 08 3c 6d 10 	movl   $0xc0106d3c,0x8(%esp)
c010474d:	c0 
c010474e:	c7 44 24 04 88 01 00 	movl   $0x188,0x4(%esp)
c0104755:	00 
c0104756:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c010475d:	e8 46 c5 ff ff       	call   c0100ca8 <__panic>
c0104762:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104765:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010476a:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104771:	00 
c0104772:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104779:	00 
c010477a:	89 04 24             	mov    %eax,(%esp)
c010477d:	e8 45 19 00 00       	call   c01060c7 <memset>
        *pdep = PDE_ADDR(phia) | PTE_U | PTE_W | PTE_P;
c0104782:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104785:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010478a:	89 c2                	mov    %eax,%edx
c010478c:	83 ca 07             	or     $0x7,%edx
c010478f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104792:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];}
c0104794:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104797:	8b 00                	mov    (%eax),%eax
c0104799:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010479e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01047a1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047a4:	c1 e8 0c             	shr    $0xc,%eax
c01047a7:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01047aa:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c01047af:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01047b2:	72 23                	jb     c01047d7 <get_pte+0x12c>
c01047b4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047b7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047bb:	c7 44 24 08 3c 6d 10 	movl   $0xc0106d3c,0x8(%esp)
c01047c2:	c0 
c01047c3:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
c01047ca:	00 
c01047cb:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c01047d2:	e8 d1 c4 ff ff       	call   c0100ca8 <__panic>
c01047d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01047da:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01047df:	8b 55 0c             	mov    0xc(%ebp),%edx
c01047e2:	c1 ea 0c             	shr    $0xc,%edx
c01047e5:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01047eb:	c1 e2 02             	shl    $0x2,%edx
c01047ee:	01 d0                	add    %edx,%eax
c01047f0:	c9                   	leave  
c01047f1:	c3                   	ret    

c01047f2 <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01047f2:	55                   	push   %ebp
c01047f3:	89 e5                	mov    %esp,%ebp
c01047f5:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01047f8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047ff:	00 
c0104800:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104803:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104807:	8b 45 08             	mov    0x8(%ebp),%eax
c010480a:	89 04 24             	mov    %eax,(%esp)
c010480d:	e8 99 fe ff ff       	call   c01046ab <get_pte>
c0104812:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0104815:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104819:	74 08                	je     c0104823 <get_page+0x31>
        *ptep_store = ptep;
c010481b:	8b 45 10             	mov    0x10(%ebp),%eax
c010481e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104821:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0104823:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104827:	74 1b                	je     c0104844 <get_page+0x52>
c0104829:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010482c:	8b 00                	mov    (%eax),%eax
c010482e:	83 e0 01             	and    $0x1,%eax
c0104831:	84 c0                	test   %al,%al
c0104833:	74 0f                	je     c0104844 <get_page+0x52>
        return pte2page(*ptep);
c0104835:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104838:	8b 00                	mov    (%eax),%eax
c010483a:	89 04 24             	mov    %eax,(%esp)
c010483d:	e8 cb f4 ff ff       	call   c0103d0d <pte2page>
c0104842:	eb 05                	jmp    c0104849 <get_page+0x57>
    }
    return NULL;
c0104844:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104849:	c9                   	leave  
c010484a:	c3                   	ret    

c010484b <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c010484b:	55                   	push   %ebp
c010484c:	89 e5                	mov    %esp,%ebp
c010484e:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P){
c0104851:	8b 45 10             	mov    0x10(%ebp),%eax
c0104854:	8b 00                	mov    (%eax),%eax
c0104856:	83 e0 01             	and    $0x1,%eax
c0104859:	84 c0                	test   %al,%al
c010485b:	74 52                	je     c01048af <page_remove_pte+0x64>
        struct Page *page = pte2page(*ptep);
c010485d:	8b 45 10             	mov    0x10(%ebp),%eax
c0104860:	8b 00                	mov    (%eax),%eax
c0104862:	89 04 24             	mov    %eax,(%esp)
c0104865:	e8 a3 f4 ff ff       	call   c0103d0d <pte2page>
c010486a:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
c010486d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104870:	89 04 24             	mov    %eax,(%esp)
c0104873:	e8 19 f5 ff ff       	call   c0103d91 <page_ref_dec>
        if(page->ref == 0) {
c0104878:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010487b:	8b 00                	mov    (%eax),%eax
c010487d:	85 c0                	test   %eax,%eax
c010487f:	75 13                	jne    c0104894 <page_remove_pte+0x49>
            free_page(page);
c0104881:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104888:	00 
c0104889:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010488c:	89 04 24             	mov    %eax,(%esp)
c010488f:	e8 11 f7 ff ff       	call   c0103fa5 <free_pages>
        }
        *ptep = 0;
c0104894:	8b 45 10             	mov    0x10(%ebp),%eax
c0104897:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);
c010489d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01048a7:	89 04 24             	mov    %eax,(%esp)
c01048aa:	e8 ff 00 00 00       	call   c01049ae <tlb_invalidate>
    }}
c01048af:	c9                   	leave  
c01048b0:	c3                   	ret    

c01048b1 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c01048b1:	55                   	push   %ebp
c01048b2:	89 e5                	mov    %esp,%ebp
c01048b4:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01048b7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01048be:	00 
c01048bf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048c2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048c6:	8b 45 08             	mov    0x8(%ebp),%eax
c01048c9:	89 04 24             	mov    %eax,(%esp)
c01048cc:	e8 da fd ff ff       	call   c01046ab <get_pte>
c01048d1:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c01048d4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01048d8:	74 19                	je     c01048f3 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c01048da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048dd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01048e1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01048e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01048e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01048eb:	89 04 24             	mov    %eax,(%esp)
c01048ee:	e8 58 ff ff ff       	call   c010484b <page_remove_pte>
    }
}
c01048f3:	c9                   	leave  
c01048f4:	c3                   	ret    

c01048f5 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c01048f5:	55                   	push   %ebp
c01048f6:	89 e5                	mov    %esp,%ebp
c01048f8:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c01048fb:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104902:	00 
c0104903:	8b 45 10             	mov    0x10(%ebp),%eax
c0104906:	89 44 24 04          	mov    %eax,0x4(%esp)
c010490a:	8b 45 08             	mov    0x8(%ebp),%eax
c010490d:	89 04 24             	mov    %eax,(%esp)
c0104910:	e8 96 fd ff ff       	call   c01046ab <get_pte>
c0104915:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0104918:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010491c:	75 0a                	jne    c0104928 <page_insert+0x33>
        return -E_NO_MEM;
c010491e:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0104923:	e9 84 00 00 00       	jmp    c01049ac <page_insert+0xb7>
    }
    page_ref_inc(page);
c0104928:	8b 45 0c             	mov    0xc(%ebp),%eax
c010492b:	89 04 24             	mov    %eax,(%esp)
c010492e:	e8 47 f4 ff ff       	call   c0103d7a <page_ref_inc>
    if (*ptep & PTE_P) {
c0104933:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104936:	8b 00                	mov    (%eax),%eax
c0104938:	83 e0 01             	and    $0x1,%eax
c010493b:	84 c0                	test   %al,%al
c010493d:	74 3e                	je     c010497d <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010493f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104942:	8b 00                	mov    (%eax),%eax
c0104944:	89 04 24             	mov    %eax,(%esp)
c0104947:	e8 c1 f3 ff ff       	call   c0103d0d <pte2page>
c010494c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c010494f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104952:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0104955:	75 0d                	jne    c0104964 <page_insert+0x6f>
            page_ref_dec(page);
c0104957:	8b 45 0c             	mov    0xc(%ebp),%eax
c010495a:	89 04 24             	mov    %eax,(%esp)
c010495d:	e8 2f f4 ff ff       	call   c0103d91 <page_ref_dec>
c0104962:	eb 19                	jmp    c010497d <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0104964:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104967:	89 44 24 08          	mov    %eax,0x8(%esp)
c010496b:	8b 45 10             	mov    0x10(%ebp),%eax
c010496e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104972:	8b 45 08             	mov    0x8(%ebp),%eax
c0104975:	89 04 24             	mov    %eax,(%esp)
c0104978:	e8 ce fe ff ff       	call   c010484b <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c010497d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104980:	89 04 24             	mov    %eax,(%esp)
c0104983:	e8 cc f2 ff ff       	call   c0103c54 <page2pa>
c0104988:	0b 45 14             	or     0x14(%ebp),%eax
c010498b:	89 c2                	mov    %eax,%edx
c010498d:	83 ca 01             	or     $0x1,%edx
c0104990:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104993:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0104995:	8b 45 10             	mov    0x10(%ebp),%eax
c0104998:	89 44 24 04          	mov    %eax,0x4(%esp)
c010499c:	8b 45 08             	mov    0x8(%ebp),%eax
c010499f:	89 04 24             	mov    %eax,(%esp)
c01049a2:	e8 07 00 00 00       	call   c01049ae <tlb_invalidate>
    return 0;
c01049a7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01049ac:	c9                   	leave  
c01049ad:	c3                   	ret    

c01049ae <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c01049ae:	55                   	push   %ebp
c01049af:	89 e5                	mov    %esp,%ebp
c01049b1:	53                   	push   %ebx
c01049b2:	83 ec 24             	sub    $0x24,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c01049b5:	0f 20 db             	mov    %cr3,%ebx
c01049b8:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr3;
c01049bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c01049be:	89 c2                	mov    %eax,%edx
c01049c0:	8b 45 08             	mov    0x8(%ebp),%eax
c01049c3:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01049c6:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01049cd:	77 23                	ja     c01049f2 <tlb_invalidate+0x44>
c01049cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049d2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01049d6:	c7 44 24 08 e0 6d 10 	movl   $0xc0106de0,0x8(%esp)
c01049dd:	c0 
c01049de:	c7 44 24 04 ec 01 00 	movl   $0x1ec,0x4(%esp)
c01049e5:	00 
c01049e6:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c01049ed:	e8 b6 c2 ff ff       	call   c0100ca8 <__panic>
c01049f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049f5:	05 00 00 00 40       	add    $0x40000000,%eax
c01049fa:	39 c2                	cmp    %eax,%edx
c01049fc:	75 0c                	jne    c0104a0a <tlb_invalidate+0x5c>
        invlpg((void *)la);
c01049fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a01:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0104a04:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a07:	0f 01 38             	invlpg (%eax)
    }
}
c0104a0a:	83 c4 24             	add    $0x24,%esp
c0104a0d:	5b                   	pop    %ebx
c0104a0e:	5d                   	pop    %ebp
c0104a0f:	c3                   	ret    

c0104a10 <check_alloc_page>:

static void
check_alloc_page(void) {
c0104a10:	55                   	push   %ebp
c0104a11:	89 e5                	mov    %esp,%ebp
c0104a13:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0104a16:	a1 5c 99 11 c0       	mov    0xc011995c,%eax
c0104a1b:	8b 40 18             	mov    0x18(%eax),%eax
c0104a1e:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0104a20:	c7 04 24 64 6e 10 c0 	movl   $0xc0106e64,(%esp)
c0104a27:	e8 1b b9 ff ff       	call   c0100347 <cprintf>
}
c0104a2c:	c9                   	leave  
c0104a2d:	c3                   	ret    

c0104a2e <check_pgdir>:

static void
check_pgdir(void) {
c0104a2e:	55                   	push   %ebp
c0104a2f:	89 e5                	mov    %esp,%ebp
c0104a31:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0104a34:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0104a39:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0104a3e:	76 24                	jbe    c0104a64 <check_pgdir+0x36>
c0104a40:	c7 44 24 0c 83 6e 10 	movl   $0xc0106e83,0xc(%esp)
c0104a47:	c0 
c0104a48:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104a4f:	c0 
c0104a50:	c7 44 24 04 f9 01 00 	movl   $0x1f9,0x4(%esp)
c0104a57:	00 
c0104a58:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104a5f:	e8 44 c2 ff ff       	call   c0100ca8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0104a64:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104a69:	85 c0                	test   %eax,%eax
c0104a6b:	74 0e                	je     c0104a7b <check_pgdir+0x4d>
c0104a6d:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104a72:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104a77:	85 c0                	test   %eax,%eax
c0104a79:	74 24                	je     c0104a9f <check_pgdir+0x71>
c0104a7b:	c7 44 24 0c a0 6e 10 	movl   $0xc0106ea0,0xc(%esp)
c0104a82:	c0 
c0104a83:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104a8a:	c0 
c0104a8b:	c7 44 24 04 fa 01 00 	movl   $0x1fa,0x4(%esp)
c0104a92:	00 
c0104a93:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104a9a:	e8 09 c2 ff ff       	call   c0100ca8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0104a9f:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104aa4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104aab:	00 
c0104aac:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104ab3:	00 
c0104ab4:	89 04 24             	mov    %eax,(%esp)
c0104ab7:	e8 36 fd ff ff       	call   c01047f2 <get_page>
c0104abc:	85 c0                	test   %eax,%eax
c0104abe:	74 24                	je     c0104ae4 <check_pgdir+0xb6>
c0104ac0:	c7 44 24 0c d8 6e 10 	movl   $0xc0106ed8,0xc(%esp)
c0104ac7:	c0 
c0104ac8:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104acf:	c0 
c0104ad0:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c0104ad7:	00 
c0104ad8:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104adf:	e8 c4 c1 ff ff       	call   c0100ca8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0104ae4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104aeb:	e8 7d f4 ff ff       	call   c0103f6d <alloc_pages>
c0104af0:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0104af3:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104af8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104aff:	00 
c0104b00:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b07:	00 
c0104b08:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104b0b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104b0f:	89 04 24             	mov    %eax,(%esp)
c0104b12:	e8 de fd ff ff       	call   c01048f5 <page_insert>
c0104b17:	85 c0                	test   %eax,%eax
c0104b19:	74 24                	je     c0104b3f <check_pgdir+0x111>
c0104b1b:	c7 44 24 0c 00 6f 10 	movl   $0xc0106f00,0xc(%esp)
c0104b22:	c0 
c0104b23:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104b2a:	c0 
c0104b2b:	c7 44 24 04 ff 01 00 	movl   $0x1ff,0x4(%esp)
c0104b32:	00 
c0104b33:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104b3a:	e8 69 c1 ff ff       	call   c0100ca8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0104b3f:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104b44:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104b4b:	00 
c0104b4c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b53:	00 
c0104b54:	89 04 24             	mov    %eax,(%esp)
c0104b57:	e8 4f fb ff ff       	call   c01046ab <get_pte>
c0104b5c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104b5f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104b63:	75 24                	jne    c0104b89 <check_pgdir+0x15b>
c0104b65:	c7 44 24 0c 2c 6f 10 	movl   $0xc0106f2c,0xc(%esp)
c0104b6c:	c0 
c0104b6d:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104b74:	c0 
c0104b75:	c7 44 24 04 02 02 00 	movl   $0x202,0x4(%esp)
c0104b7c:	00 
c0104b7d:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104b84:	e8 1f c1 ff ff       	call   c0100ca8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104b89:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b8c:	8b 00                	mov    (%eax),%eax
c0104b8e:	89 04 24             	mov    %eax,(%esp)
c0104b91:	e8 77 f1 ff ff       	call   c0103d0d <pte2page>
c0104b96:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104b99:	74 24                	je     c0104bbf <check_pgdir+0x191>
c0104b9b:	c7 44 24 0c 59 6f 10 	movl   $0xc0106f59,0xc(%esp)
c0104ba2:	c0 
c0104ba3:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104baa:	c0 
c0104bab:	c7 44 24 04 03 02 00 	movl   $0x203,0x4(%esp)
c0104bb2:	00 
c0104bb3:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104bba:	e8 e9 c0 ff ff       	call   c0100ca8 <__panic>
    assert(page_ref(p1) == 1);
c0104bbf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104bc2:	89 04 24             	mov    %eax,(%esp)
c0104bc5:	e8 99 f1 ff ff       	call   c0103d63 <page_ref>
c0104bca:	83 f8 01             	cmp    $0x1,%eax
c0104bcd:	74 24                	je     c0104bf3 <check_pgdir+0x1c5>
c0104bcf:	c7 44 24 0c 6f 6f 10 	movl   $0xc0106f6f,0xc(%esp)
c0104bd6:	c0 
c0104bd7:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104bde:	c0 
c0104bdf:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c0104be6:	00 
c0104be7:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104bee:	e8 b5 c0 ff ff       	call   c0100ca8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0104bf3:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104bf8:	8b 00                	mov    (%eax),%eax
c0104bfa:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104bff:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104c02:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c05:	c1 e8 0c             	shr    $0xc,%eax
c0104c08:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104c0b:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c0104c10:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0104c13:	72 23                	jb     c0104c38 <check_pgdir+0x20a>
c0104c15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c18:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c1c:	c7 44 24 08 3c 6d 10 	movl   $0xc0106d3c,0x8(%esp)
c0104c23:	c0 
c0104c24:	c7 44 24 04 06 02 00 	movl   $0x206,0x4(%esp)
c0104c2b:	00 
c0104c2c:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104c33:	e8 70 c0 ff ff       	call   c0100ca8 <__panic>
c0104c38:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c3b:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104c40:	83 c0 04             	add    $0x4,%eax
c0104c43:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0104c46:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104c4b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c52:	00 
c0104c53:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104c5a:	00 
c0104c5b:	89 04 24             	mov    %eax,(%esp)
c0104c5e:	e8 48 fa ff ff       	call   c01046ab <get_pte>
c0104c63:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104c66:	74 24                	je     c0104c8c <check_pgdir+0x25e>
c0104c68:	c7 44 24 0c 84 6f 10 	movl   $0xc0106f84,0xc(%esp)
c0104c6f:	c0 
c0104c70:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104c77:	c0 
c0104c78:	c7 44 24 04 07 02 00 	movl   $0x207,0x4(%esp)
c0104c7f:	00 
c0104c80:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104c87:	e8 1c c0 ff ff       	call   c0100ca8 <__panic>

    p2 = alloc_page();
c0104c8c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104c93:	e8 d5 f2 ff ff       	call   c0103f6d <alloc_pages>
c0104c98:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0104c9b:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104ca0:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0104ca7:	00 
c0104ca8:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104caf:	00 
c0104cb0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0104cb3:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104cb7:	89 04 24             	mov    %eax,(%esp)
c0104cba:	e8 36 fc ff ff       	call   c01048f5 <page_insert>
c0104cbf:	85 c0                	test   %eax,%eax
c0104cc1:	74 24                	je     c0104ce7 <check_pgdir+0x2b9>
c0104cc3:	c7 44 24 0c ac 6f 10 	movl   $0xc0106fac,0xc(%esp)
c0104cca:	c0 
c0104ccb:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104cd2:	c0 
c0104cd3:	c7 44 24 04 0a 02 00 	movl   $0x20a,0x4(%esp)
c0104cda:	00 
c0104cdb:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104ce2:	e8 c1 bf ff ff       	call   c0100ca8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104ce7:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104cec:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104cf3:	00 
c0104cf4:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104cfb:	00 
c0104cfc:	89 04 24             	mov    %eax,(%esp)
c0104cff:	e8 a7 f9 ff ff       	call   c01046ab <get_pte>
c0104d04:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d07:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104d0b:	75 24                	jne    c0104d31 <check_pgdir+0x303>
c0104d0d:	c7 44 24 0c e4 6f 10 	movl   $0xc0106fe4,0xc(%esp)
c0104d14:	c0 
c0104d15:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104d1c:	c0 
c0104d1d:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0104d24:	00 
c0104d25:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104d2c:	e8 77 bf ff ff       	call   c0100ca8 <__panic>
    assert(*ptep & PTE_U);
c0104d31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d34:	8b 00                	mov    (%eax),%eax
c0104d36:	83 e0 04             	and    $0x4,%eax
c0104d39:	85 c0                	test   %eax,%eax
c0104d3b:	75 24                	jne    c0104d61 <check_pgdir+0x333>
c0104d3d:	c7 44 24 0c 14 70 10 	movl   $0xc0107014,0xc(%esp)
c0104d44:	c0 
c0104d45:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104d4c:	c0 
c0104d4d:	c7 44 24 04 0c 02 00 	movl   $0x20c,0x4(%esp)
c0104d54:	00 
c0104d55:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104d5c:	e8 47 bf ff ff       	call   c0100ca8 <__panic>
    assert(*ptep & PTE_W);
c0104d61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d64:	8b 00                	mov    (%eax),%eax
c0104d66:	83 e0 02             	and    $0x2,%eax
c0104d69:	85 c0                	test   %eax,%eax
c0104d6b:	75 24                	jne    c0104d91 <check_pgdir+0x363>
c0104d6d:	c7 44 24 0c 22 70 10 	movl   $0xc0107022,0xc(%esp)
c0104d74:	c0 
c0104d75:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104d7c:	c0 
c0104d7d:	c7 44 24 04 0d 02 00 	movl   $0x20d,0x4(%esp)
c0104d84:	00 
c0104d85:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104d8c:	e8 17 bf ff ff       	call   c0100ca8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0104d91:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104d96:	8b 00                	mov    (%eax),%eax
c0104d98:	83 e0 04             	and    $0x4,%eax
c0104d9b:	85 c0                	test   %eax,%eax
c0104d9d:	75 24                	jne    c0104dc3 <check_pgdir+0x395>
c0104d9f:	c7 44 24 0c 30 70 10 	movl   $0xc0107030,0xc(%esp)
c0104da6:	c0 
c0104da7:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104dae:	c0 
c0104daf:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0104db6:	00 
c0104db7:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104dbe:	e8 e5 be ff ff       	call   c0100ca8 <__panic>
    assert(page_ref(p2) == 1);
c0104dc3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104dc6:	89 04 24             	mov    %eax,(%esp)
c0104dc9:	e8 95 ef ff ff       	call   c0103d63 <page_ref>
c0104dce:	83 f8 01             	cmp    $0x1,%eax
c0104dd1:	74 24                	je     c0104df7 <check_pgdir+0x3c9>
c0104dd3:	c7 44 24 0c 46 70 10 	movl   $0xc0107046,0xc(%esp)
c0104dda:	c0 
c0104ddb:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104de2:	c0 
c0104de3:	c7 44 24 04 0f 02 00 	movl   $0x20f,0x4(%esp)
c0104dea:	00 
c0104deb:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104df2:	e8 b1 be ff ff       	call   c0100ca8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0104df7:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104dfc:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104e03:	00 
c0104e04:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104e0b:	00 
c0104e0c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0104e0f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104e13:	89 04 24             	mov    %eax,(%esp)
c0104e16:	e8 da fa ff ff       	call   c01048f5 <page_insert>
c0104e1b:	85 c0                	test   %eax,%eax
c0104e1d:	74 24                	je     c0104e43 <check_pgdir+0x415>
c0104e1f:	c7 44 24 0c 58 70 10 	movl   $0xc0107058,0xc(%esp)
c0104e26:	c0 
c0104e27:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104e2e:	c0 
c0104e2f:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0104e36:	00 
c0104e37:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104e3e:	e8 65 be ff ff       	call   c0100ca8 <__panic>
    assert(page_ref(p1) == 2);
c0104e43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e46:	89 04 24             	mov    %eax,(%esp)
c0104e49:	e8 15 ef ff ff       	call   c0103d63 <page_ref>
c0104e4e:	83 f8 02             	cmp    $0x2,%eax
c0104e51:	74 24                	je     c0104e77 <check_pgdir+0x449>
c0104e53:	c7 44 24 0c 84 70 10 	movl   $0xc0107084,0xc(%esp)
c0104e5a:	c0 
c0104e5b:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104e62:	c0 
c0104e63:	c7 44 24 04 12 02 00 	movl   $0x212,0x4(%esp)
c0104e6a:	00 
c0104e6b:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104e72:	e8 31 be ff ff       	call   c0100ca8 <__panic>
    assert(page_ref(p2) == 0);
c0104e77:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104e7a:	89 04 24             	mov    %eax,(%esp)
c0104e7d:	e8 e1 ee ff ff       	call   c0103d63 <page_ref>
c0104e82:	85 c0                	test   %eax,%eax
c0104e84:	74 24                	je     c0104eaa <check_pgdir+0x47c>
c0104e86:	c7 44 24 0c 96 70 10 	movl   $0xc0107096,0xc(%esp)
c0104e8d:	c0 
c0104e8e:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104e95:	c0 
c0104e96:	c7 44 24 04 13 02 00 	movl   $0x213,0x4(%esp)
c0104e9d:	00 
c0104e9e:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104ea5:	e8 fe bd ff ff       	call   c0100ca8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0104eaa:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104eaf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104eb6:	00 
c0104eb7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104ebe:	00 
c0104ebf:	89 04 24             	mov    %eax,(%esp)
c0104ec2:	e8 e4 f7 ff ff       	call   c01046ab <get_pte>
c0104ec7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104eca:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104ece:	75 24                	jne    c0104ef4 <check_pgdir+0x4c6>
c0104ed0:	c7 44 24 0c e4 6f 10 	movl   $0xc0106fe4,0xc(%esp)
c0104ed7:	c0 
c0104ed8:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104edf:	c0 
c0104ee0:	c7 44 24 04 14 02 00 	movl   $0x214,0x4(%esp)
c0104ee7:	00 
c0104ee8:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104eef:	e8 b4 bd ff ff       	call   c0100ca8 <__panic>
    assert(pte2page(*ptep) == p1);
c0104ef4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef7:	8b 00                	mov    (%eax),%eax
c0104ef9:	89 04 24             	mov    %eax,(%esp)
c0104efc:	e8 0c ee ff ff       	call   c0103d0d <pte2page>
c0104f01:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104f04:	74 24                	je     c0104f2a <check_pgdir+0x4fc>
c0104f06:	c7 44 24 0c 59 6f 10 	movl   $0xc0106f59,0xc(%esp)
c0104f0d:	c0 
c0104f0e:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104f15:	c0 
c0104f16:	c7 44 24 04 15 02 00 	movl   $0x215,0x4(%esp)
c0104f1d:	00 
c0104f1e:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104f25:	e8 7e bd ff ff       	call   c0100ca8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0104f2a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f2d:	8b 00                	mov    (%eax),%eax
c0104f2f:	83 e0 04             	and    $0x4,%eax
c0104f32:	85 c0                	test   %eax,%eax
c0104f34:	74 24                	je     c0104f5a <check_pgdir+0x52c>
c0104f36:	c7 44 24 0c a8 70 10 	movl   $0xc01070a8,0xc(%esp)
c0104f3d:	c0 
c0104f3e:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104f45:	c0 
c0104f46:	c7 44 24 04 16 02 00 	movl   $0x216,0x4(%esp)
c0104f4d:	00 
c0104f4e:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104f55:	e8 4e bd ff ff       	call   c0100ca8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0104f5a:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104f5f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104f66:	00 
c0104f67:	89 04 24             	mov    %eax,(%esp)
c0104f6a:	e8 42 f9 ff ff       	call   c01048b1 <page_remove>
    assert(page_ref(p1) == 1);
c0104f6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f72:	89 04 24             	mov    %eax,(%esp)
c0104f75:	e8 e9 ed ff ff       	call   c0103d63 <page_ref>
c0104f7a:	83 f8 01             	cmp    $0x1,%eax
c0104f7d:	74 24                	je     c0104fa3 <check_pgdir+0x575>
c0104f7f:	c7 44 24 0c 6f 6f 10 	movl   $0xc0106f6f,0xc(%esp)
c0104f86:	c0 
c0104f87:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104f8e:	c0 
c0104f8f:	c7 44 24 04 19 02 00 	movl   $0x219,0x4(%esp)
c0104f96:	00 
c0104f97:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104f9e:	e8 05 bd ff ff       	call   c0100ca8 <__panic>
    assert(page_ref(p2) == 0);
c0104fa3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104fa6:	89 04 24             	mov    %eax,(%esp)
c0104fa9:	e8 b5 ed ff ff       	call   c0103d63 <page_ref>
c0104fae:	85 c0                	test   %eax,%eax
c0104fb0:	74 24                	je     c0104fd6 <check_pgdir+0x5a8>
c0104fb2:	c7 44 24 0c 96 70 10 	movl   $0xc0107096,0xc(%esp)
c0104fb9:	c0 
c0104fba:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0104fc1:	c0 
c0104fc2:	c7 44 24 04 1a 02 00 	movl   $0x21a,0x4(%esp)
c0104fc9:	00 
c0104fca:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0104fd1:	e8 d2 bc ff ff       	call   c0100ca8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0104fd6:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0104fdb:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104fe2:	00 
c0104fe3:	89 04 24             	mov    %eax,(%esp)
c0104fe6:	e8 c6 f8 ff ff       	call   c01048b1 <page_remove>
    assert(page_ref(p1) == 0);
c0104feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104fee:	89 04 24             	mov    %eax,(%esp)
c0104ff1:	e8 6d ed ff ff       	call   c0103d63 <page_ref>
c0104ff6:	85 c0                	test   %eax,%eax
c0104ff8:	74 24                	je     c010501e <check_pgdir+0x5f0>
c0104ffa:	c7 44 24 0c bd 70 10 	movl   $0xc01070bd,0xc(%esp)
c0105001:	c0 
c0105002:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0105009:	c0 
c010500a:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c0105011:	00 
c0105012:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0105019:	e8 8a bc ff ff       	call   c0100ca8 <__panic>
    assert(page_ref(p2) == 0);
c010501e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105021:	89 04 24             	mov    %eax,(%esp)
c0105024:	e8 3a ed ff ff       	call   c0103d63 <page_ref>
c0105029:	85 c0                	test   %eax,%eax
c010502b:	74 24                	je     c0105051 <check_pgdir+0x623>
c010502d:	c7 44 24 0c 96 70 10 	movl   $0xc0107096,0xc(%esp)
c0105034:	c0 
c0105035:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c010503c:	c0 
c010503d:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c0105044:	00 
c0105045:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c010504c:	e8 57 bc ff ff       	call   c0100ca8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0105051:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0105056:	8b 00                	mov    (%eax),%eax
c0105058:	89 04 24             	mov    %eax,(%esp)
c010505b:	e8 eb ec ff ff       	call   c0103d4b <pde2page>
c0105060:	89 04 24             	mov    %eax,(%esp)
c0105063:	e8 fb ec ff ff       	call   c0103d63 <page_ref>
c0105068:	83 f8 01             	cmp    $0x1,%eax
c010506b:	74 24                	je     c0105091 <check_pgdir+0x663>
c010506d:	c7 44 24 0c d0 70 10 	movl   $0xc01070d0,0xc(%esp)
c0105074:	c0 
c0105075:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c010507c:	c0 
c010507d:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0105084:	00 
c0105085:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c010508c:	e8 17 bc ff ff       	call   c0100ca8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c0105091:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0105096:	8b 00                	mov    (%eax),%eax
c0105098:	89 04 24             	mov    %eax,(%esp)
c010509b:	e8 ab ec ff ff       	call   c0103d4b <pde2page>
c01050a0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050a7:	00 
c01050a8:	89 04 24             	mov    %eax,(%esp)
c01050ab:	e8 f5 ee ff ff       	call   c0103fa5 <free_pages>
    boot_pgdir[0] = 0;
c01050b0:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01050b5:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01050bb:	c7 04 24 f7 70 10 c0 	movl   $0xc01070f7,(%esp)
c01050c2:	e8 80 b2 ff ff       	call   c0100347 <cprintf>
}
c01050c7:	c9                   	leave  
c01050c8:	c3                   	ret    

c01050c9 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01050c9:	55                   	push   %ebp
c01050ca:	89 e5                	mov    %esp,%ebp
c01050cc:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01050cf:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01050d6:	e9 cb 00 00 00       	jmp    c01051a6 <check_boot_pgdir+0xdd>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01050db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050de:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01050e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050e4:	c1 e8 0c             	shr    $0xc,%eax
c01050e7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01050ea:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c01050ef:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01050f2:	72 23                	jb     c0105117 <check_boot_pgdir+0x4e>
c01050f4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01050f7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01050fb:	c7 44 24 08 3c 6d 10 	movl   $0xc0106d3c,0x8(%esp)
c0105102:	c0 
c0105103:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c010510a:	00 
c010510b:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0105112:	e8 91 bb ff ff       	call   c0100ca8 <__panic>
c0105117:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010511a:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010511f:	89 c2                	mov    %eax,%edx
c0105121:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0105126:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010512d:	00 
c010512e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105132:	89 04 24             	mov    %eax,(%esp)
c0105135:	e8 71 f5 ff ff       	call   c01046ab <get_pte>
c010513a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010513d:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105141:	75 24                	jne    c0105167 <check_boot_pgdir+0x9e>
c0105143:	c7 44 24 0c 14 71 10 	movl   $0xc0107114,0xc(%esp)
c010514a:	c0 
c010514b:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0105152:	c0 
c0105153:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c010515a:	00 
c010515b:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0105162:	e8 41 bb ff ff       	call   c0100ca8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105167:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010516a:	8b 00                	mov    (%eax),%eax
c010516c:	89 c2                	mov    %eax,%edx
c010516e:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c0105174:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105177:	39 c2                	cmp    %eax,%edx
c0105179:	74 24                	je     c010519f <check_boot_pgdir+0xd6>
c010517b:	c7 44 24 0c 51 71 10 	movl   $0xc0107151,0xc(%esp)
c0105182:	c0 
c0105183:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c010518a:	c0 
c010518b:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105192:	00 
c0105193:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c010519a:	e8 09 bb ff ff       	call   c0100ca8 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010519f:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01051a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01051a9:	a1 c0 98 11 c0       	mov    0xc01198c0,%eax
c01051ae:	39 c2                	cmp    %eax,%edx
c01051b0:	0f 82 25 ff ff ff    	jb     c01050db <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c01051b6:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01051bb:	05 ac 0f 00 00       	add    $0xfac,%eax
c01051c0:	8b 00                	mov    (%eax),%eax
c01051c2:	89 c2                	mov    %eax,%edx
c01051c4:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c01051ca:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01051cf:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01051d2:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01051d9:	77 23                	ja     c01051fe <check_boot_pgdir+0x135>
c01051db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01051de:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051e2:	c7 44 24 08 e0 6d 10 	movl   $0xc0106de0,0x8(%esp)
c01051e9:	c0 
c01051ea:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01051f1:	00 
c01051f2:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c01051f9:	e8 aa ba ff ff       	call   c0100ca8 <__panic>
c01051fe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105201:	05 00 00 00 40       	add    $0x40000000,%eax
c0105206:	39 c2                	cmp    %eax,%edx
c0105208:	74 24                	je     c010522e <check_boot_pgdir+0x165>
c010520a:	c7 44 24 0c 68 71 10 	movl   $0xc0107168,0xc(%esp)
c0105211:	c0 
c0105212:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0105219:	c0 
c010521a:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0105221:	00 
c0105222:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0105229:	e8 7a ba ff ff       	call   c0100ca8 <__panic>

    assert(boot_pgdir[0] == 0);
c010522e:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0105233:	8b 00                	mov    (%eax),%eax
c0105235:	85 c0                	test   %eax,%eax
c0105237:	74 24                	je     c010525d <check_boot_pgdir+0x194>
c0105239:	c7 44 24 0c 9c 71 10 	movl   $0xc010719c,0xc(%esp)
c0105240:	c0 
c0105241:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0105248:	c0 
c0105249:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105250:	00 
c0105251:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0105258:	e8 4b ba ff ff       	call   c0100ca8 <__panic>

    struct Page *p;
    p = alloc_page();
c010525d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105264:	e8 04 ed ff ff       	call   c0103f6d <alloc_pages>
c0105269:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c010526c:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0105271:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105278:	00 
c0105279:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105280:	00 
c0105281:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105284:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105288:	89 04 24             	mov    %eax,(%esp)
c010528b:	e8 65 f6 ff ff       	call   c01048f5 <page_insert>
c0105290:	85 c0                	test   %eax,%eax
c0105292:	74 24                	je     c01052b8 <check_boot_pgdir+0x1ef>
c0105294:	c7 44 24 0c b0 71 10 	movl   $0xc01071b0,0xc(%esp)
c010529b:	c0 
c010529c:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c01052a3:	c0 
c01052a4:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c01052ab:	00 
c01052ac:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c01052b3:	e8 f0 b9 ff ff       	call   c0100ca8 <__panic>
    assert(page_ref(p) == 1);
c01052b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01052bb:	89 04 24             	mov    %eax,(%esp)
c01052be:	e8 a0 ea ff ff       	call   c0103d63 <page_ref>
c01052c3:	83 f8 01             	cmp    $0x1,%eax
c01052c6:	74 24                	je     c01052ec <check_boot_pgdir+0x223>
c01052c8:	c7 44 24 0c de 71 10 	movl   $0xc01071de,0xc(%esp)
c01052cf:	c0 
c01052d0:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c01052d7:	c0 
c01052d8:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c01052df:	00 
c01052e0:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c01052e7:	e8 bc b9 ff ff       	call   c0100ca8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01052ec:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c01052f1:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01052f8:	00 
c01052f9:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105300:	00 
c0105301:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105304:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105308:	89 04 24             	mov    %eax,(%esp)
c010530b:	e8 e5 f5 ff ff       	call   c01048f5 <page_insert>
c0105310:	85 c0                	test   %eax,%eax
c0105312:	74 24                	je     c0105338 <check_boot_pgdir+0x26f>
c0105314:	c7 44 24 0c f0 71 10 	movl   $0xc01071f0,0xc(%esp)
c010531b:	c0 
c010531c:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0105323:	c0 
c0105324:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c010532b:	00 
c010532c:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0105333:	e8 70 b9 ff ff       	call   c0100ca8 <__panic>
    assert(page_ref(p) == 2);
c0105338:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010533b:	89 04 24             	mov    %eax,(%esp)
c010533e:	e8 20 ea ff ff       	call   c0103d63 <page_ref>
c0105343:	83 f8 02             	cmp    $0x2,%eax
c0105346:	74 24                	je     c010536c <check_boot_pgdir+0x2a3>
c0105348:	c7 44 24 0c 27 72 10 	movl   $0xc0107227,0xc(%esp)
c010534f:	c0 
c0105350:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c0105357:	c0 
c0105358:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c010535f:	00 
c0105360:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0105367:	e8 3c b9 ff ff       	call   c0100ca8 <__panic>

    const char *str = "ucore: Hello world!!";
c010536c:	c7 45 dc 38 72 10 c0 	movl   $0xc0107238,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105373:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105376:	89 44 24 04          	mov    %eax,0x4(%esp)
c010537a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105381:	e8 64 0a 00 00       	call   c0105dea <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105386:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c010538d:	00 
c010538e:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105395:	e8 cd 0a 00 00       	call   c0105e67 <strcmp>
c010539a:	85 c0                	test   %eax,%eax
c010539c:	74 24                	je     c01053c2 <check_boot_pgdir+0x2f9>
c010539e:	c7 44 24 0c 50 72 10 	movl   $0xc0107250,0xc(%esp)
c01053a5:	c0 
c01053a6:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c01053ad:	c0 
c01053ae:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c01053b5:	00 
c01053b6:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c01053bd:	e8 e6 b8 ff ff       	call   c0100ca8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c01053c2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01053c5:	89 04 24             	mov    %eax,(%esp)
c01053c8:	e8 ec e8 ff ff       	call   c0103cb9 <page2kva>
c01053cd:	05 00 01 00 00       	add    $0x100,%eax
c01053d2:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c01053d5:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01053dc:	e8 ab 09 00 00       	call   c0105d8c <strlen>
c01053e1:	85 c0                	test   %eax,%eax
c01053e3:	74 24                	je     c0105409 <check_boot_pgdir+0x340>
c01053e5:	c7 44 24 0c 88 72 10 	movl   $0xc0107288,0xc(%esp)
c01053ec:	c0 
c01053ed:	c7 44 24 08 29 6e 10 	movl   $0xc0106e29,0x8(%esp)
c01053f4:	c0 
c01053f5:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c01053fc:	00 
c01053fd:	c7 04 24 04 6e 10 c0 	movl   $0xc0106e04,(%esp)
c0105404:	e8 9f b8 ff ff       	call   c0100ca8 <__panic>

    free_page(p);
c0105409:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105410:	00 
c0105411:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105414:	89 04 24             	mov    %eax,(%esp)
c0105417:	e8 89 eb ff ff       	call   c0103fa5 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010541c:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0105421:	8b 00                	mov    (%eax),%eax
c0105423:	89 04 24             	mov    %eax,(%esp)
c0105426:	e8 20 e9 ff ff       	call   c0103d4b <pde2page>
c010542b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105432:	00 
c0105433:	89 04 24             	mov    %eax,(%esp)
c0105436:	e8 6a eb ff ff       	call   c0103fa5 <free_pages>
    boot_pgdir[0] = 0;
c010543b:	a1 c4 98 11 c0       	mov    0xc01198c4,%eax
c0105440:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105446:	c7 04 24 ac 72 10 c0 	movl   $0xc01072ac,(%esp)
c010544d:	e8 f5 ae ff ff       	call   c0100347 <cprintf>
}
c0105452:	c9                   	leave  
c0105453:	c3                   	ret    

c0105454 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105454:	55                   	push   %ebp
c0105455:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105457:	8b 45 08             	mov    0x8(%ebp),%eax
c010545a:	83 e0 04             	and    $0x4,%eax
c010545d:	85 c0                	test   %eax,%eax
c010545f:	74 07                	je     c0105468 <perm2str+0x14>
c0105461:	b8 75 00 00 00       	mov    $0x75,%eax
c0105466:	eb 05                	jmp    c010546d <perm2str+0x19>
c0105468:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010546d:	a2 48 99 11 c0       	mov    %al,0xc0119948
    str[1] = 'r';
c0105472:	c6 05 49 99 11 c0 72 	movb   $0x72,0xc0119949
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105479:	8b 45 08             	mov    0x8(%ebp),%eax
c010547c:	83 e0 02             	and    $0x2,%eax
c010547f:	85 c0                	test   %eax,%eax
c0105481:	74 07                	je     c010548a <perm2str+0x36>
c0105483:	b8 77 00 00 00       	mov    $0x77,%eax
c0105488:	eb 05                	jmp    c010548f <perm2str+0x3b>
c010548a:	b8 2d 00 00 00       	mov    $0x2d,%eax
c010548f:	a2 4a 99 11 c0       	mov    %al,0xc011994a
    str[3] = '\0';
c0105494:	c6 05 4b 99 11 c0 00 	movb   $0x0,0xc011994b
    return str;
c010549b:	b8 48 99 11 c0       	mov    $0xc0119948,%eax
}
c01054a0:	5d                   	pop    %ebp
c01054a1:	c3                   	ret    

c01054a2 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01054a2:	55                   	push   %ebp
c01054a3:	89 e5                	mov    %esp,%ebp
c01054a5:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01054a8:	8b 45 10             	mov    0x10(%ebp),%eax
c01054ab:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054ae:	72 0e                	jb     c01054be <get_pgtable_items+0x1c>
        return 0;
c01054b0:	b8 00 00 00 00       	mov    $0x0,%eax
c01054b5:	e9 86 00 00 00       	jmp    c0105540 <get_pgtable_items+0x9e>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c01054ba:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c01054be:	8b 45 10             	mov    0x10(%ebp),%eax
c01054c1:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054c4:	73 12                	jae    c01054d8 <get_pgtable_items+0x36>
c01054c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01054c9:	c1 e0 02             	shl    $0x2,%eax
c01054cc:	03 45 14             	add    0x14(%ebp),%eax
c01054cf:	8b 00                	mov    (%eax),%eax
c01054d1:	83 e0 01             	and    $0x1,%eax
c01054d4:	85 c0                	test   %eax,%eax
c01054d6:	74 e2                	je     c01054ba <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c01054d8:	8b 45 10             	mov    0x10(%ebp),%eax
c01054db:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01054de:	73 5b                	jae    c010553b <get_pgtable_items+0x99>
        if (left_store != NULL) {
c01054e0:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01054e4:	74 08                	je     c01054ee <get_pgtable_items+0x4c>
            *left_store = start;
c01054e6:	8b 45 18             	mov    0x18(%ebp),%eax
c01054e9:	8b 55 10             	mov    0x10(%ebp),%edx
c01054ec:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c01054ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01054f1:	c1 e0 02             	shl    $0x2,%eax
c01054f4:	03 45 14             	add    0x14(%ebp),%eax
c01054f7:	8b 00                	mov    (%eax),%eax
c01054f9:	83 e0 07             	and    $0x7,%eax
c01054fc:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01054ff:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105503:	eb 04                	jmp    c0105509 <get_pgtable_items+0x67>
            start ++;
c0105505:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105509:	8b 45 10             	mov    0x10(%ebp),%eax
c010550c:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010550f:	73 17                	jae    c0105528 <get_pgtable_items+0x86>
c0105511:	8b 45 10             	mov    0x10(%ebp),%eax
c0105514:	c1 e0 02             	shl    $0x2,%eax
c0105517:	03 45 14             	add    0x14(%ebp),%eax
c010551a:	8b 00                	mov    (%eax),%eax
c010551c:	89 c2                	mov    %eax,%edx
c010551e:	83 e2 07             	and    $0x7,%edx
c0105521:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105524:	39 c2                	cmp    %eax,%edx
c0105526:	74 dd                	je     c0105505 <get_pgtable_items+0x63>
            start ++;
        }
        if (right_store != NULL) {
c0105528:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010552c:	74 08                	je     c0105536 <get_pgtable_items+0x94>
            *right_store = start;
c010552e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105531:	8b 55 10             	mov    0x10(%ebp),%edx
c0105534:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105536:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105539:	eb 05                	jmp    c0105540 <get_pgtable_items+0x9e>
    }
    return 0;
c010553b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105540:	c9                   	leave  
c0105541:	c3                   	ret    

c0105542 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105542:	55                   	push   %ebp
c0105543:	89 e5                	mov    %esp,%ebp
c0105545:	57                   	push   %edi
c0105546:	56                   	push   %esi
c0105547:	53                   	push   %ebx
c0105548:	83 ec 5c             	sub    $0x5c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010554b:	c7 04 24 cc 72 10 c0 	movl   $0xc01072cc,(%esp)
c0105552:	e8 f0 ad ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
c0105557:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010555e:	e9 0b 01 00 00       	jmp    c010566e <print_pgdir+0x12c>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105563:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105566:	89 04 24             	mov    %eax,(%esp)
c0105569:	e8 e6 fe ff ff       	call   c0105454 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c010556e:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105571:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105574:	89 cb                	mov    %ecx,%ebx
c0105576:	29 d3                	sub    %edx,%ebx
c0105578:	89 da                	mov    %ebx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c010557a:	89 d6                	mov    %edx,%esi
c010557c:	c1 e6 16             	shl    $0x16,%esi
c010557f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105582:	89 d3                	mov    %edx,%ebx
c0105584:	c1 e3 16             	shl    $0x16,%ebx
c0105587:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010558a:	89 d1                	mov    %edx,%ecx
c010558c:	c1 e1 16             	shl    $0x16,%ecx
c010558f:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105592:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c0105595:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105598:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c010559b:	29 d7                	sub    %edx,%edi
c010559d:	89 fa                	mov    %edi,%edx
c010559f:	89 44 24 14          	mov    %eax,0x14(%esp)
c01055a3:	89 74 24 10          	mov    %esi,0x10(%esp)
c01055a7:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01055ab:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01055af:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055b3:	c7 04 24 fd 72 10 c0 	movl   $0xc01072fd,(%esp)
c01055ba:	e8 88 ad ff ff       	call   c0100347 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c01055bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01055c2:	c1 e0 0a             	shl    $0xa,%eax
c01055c5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c01055c8:	eb 5c                	jmp    c0105626 <print_pgdir+0xe4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01055ca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01055cd:	89 04 24             	mov    %eax,(%esp)
c01055d0:	e8 7f fe ff ff       	call   c0105454 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c01055d5:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c01055d8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01055db:	89 cb                	mov    %ecx,%ebx
c01055dd:	29 d3                	sub    %edx,%ebx
c01055df:	89 da                	mov    %ebx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c01055e1:	89 d6                	mov    %edx,%esi
c01055e3:	c1 e6 0c             	shl    $0xc,%esi
c01055e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01055e9:	89 d3                	mov    %edx,%ebx
c01055eb:	c1 e3 0c             	shl    $0xc,%ebx
c01055ee:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01055f1:	89 d1                	mov    %edx,%ecx
c01055f3:	c1 e1 0c             	shl    $0xc,%ecx
c01055f6:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c01055f9:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c01055fc:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01055ff:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c0105602:	29 d7                	sub    %edx,%edi
c0105604:	89 fa                	mov    %edi,%edx
c0105606:	89 44 24 14          	mov    %eax,0x14(%esp)
c010560a:	89 74 24 10          	mov    %esi,0x10(%esp)
c010560e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105612:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105616:	89 54 24 04          	mov    %edx,0x4(%esp)
c010561a:	c7 04 24 1c 73 10 c0 	movl   $0xc010731c,(%esp)
c0105621:	e8 21 ad ff ff       	call   c0100347 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105626:	8b 15 84 6d 10 c0    	mov    0xc0106d84,%edx
c010562c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010562f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105632:	89 ce                	mov    %ecx,%esi
c0105634:	c1 e6 0a             	shl    $0xa,%esi
c0105637:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010563a:	89 cb                	mov    %ecx,%ebx
c010563c:	c1 e3 0a             	shl    $0xa,%ebx
c010563f:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105642:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105646:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105649:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c010564d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105651:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105655:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105659:	89 1c 24             	mov    %ebx,(%esp)
c010565c:	e8 41 fe ff ff       	call   c01054a2 <get_pgtable_items>
c0105661:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105664:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105668:	0f 85 5c ff ff ff    	jne    c01055ca <print_pgdir+0x88>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c010566e:	8b 15 88 6d 10 c0    	mov    0xc0106d88,%edx
c0105674:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105677:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c010567a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c010567e:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105681:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105685:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105689:	89 44 24 08          	mov    %eax,0x8(%esp)
c010568d:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105694:	00 
c0105695:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010569c:	e8 01 fe ff ff       	call   c01054a2 <get_pgtable_items>
c01056a1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056a4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01056a8:	0f 85 b5 fe ff ff    	jne    c0105563 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c01056ae:	c7 04 24 40 73 10 c0 	movl   $0xc0107340,(%esp)
c01056b5:	e8 8d ac ff ff       	call   c0100347 <cprintf>
}
c01056ba:	83 c4 5c             	add    $0x5c,%esp
c01056bd:	5b                   	pop    %ebx
c01056be:	5e                   	pop    %esi
c01056bf:	5f                   	pop    %edi
c01056c0:	5d                   	pop    %ebp
c01056c1:	c3                   	ret    
	...

c01056c4 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01056c4:	55                   	push   %ebp
c01056c5:	89 e5                	mov    %esp,%ebp
c01056c7:	56                   	push   %esi
c01056c8:	53                   	push   %ebx
c01056c9:	83 ec 60             	sub    $0x60,%esp
c01056cc:	8b 45 10             	mov    0x10(%ebp),%eax
c01056cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01056d2:	8b 45 14             	mov    0x14(%ebp),%eax
c01056d5:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01056d8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01056db:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01056de:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056e1:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01056e4:	8b 45 18             	mov    0x18(%ebp),%eax
c01056e7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056ed:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01056f0:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01056f3:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01056f6:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01056f9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01056fc:	89 d3                	mov    %edx,%ebx
c01056fe:	89 c6                	mov    %eax,%esi
c0105700:	89 75 e0             	mov    %esi,-0x20(%ebp)
c0105703:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0105706:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105709:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010570c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105710:	74 1c                	je     c010572e <printnum+0x6a>
c0105712:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105715:	ba 00 00 00 00       	mov    $0x0,%edx
c010571a:	f7 75 e4             	divl   -0x1c(%ebp)
c010571d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0105720:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105723:	ba 00 00 00 00       	mov    $0x0,%edx
c0105728:	f7 75 e4             	divl   -0x1c(%ebp)
c010572b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010572e:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105731:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105734:	89 d6                	mov    %edx,%esi
c0105736:	89 c3                	mov    %eax,%ebx
c0105738:	89 f0                	mov    %esi,%eax
c010573a:	89 da                	mov    %ebx,%edx
c010573c:	f7 75 e4             	divl   -0x1c(%ebp)
c010573f:	89 d3                	mov    %edx,%ebx
c0105741:	89 c6                	mov    %eax,%esi
c0105743:	89 75 e0             	mov    %esi,-0x20(%ebp)
c0105746:	89 5d dc             	mov    %ebx,-0x24(%ebp)
c0105749:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010574c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010574f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105752:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0105755:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105758:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010575b:	89 c3                	mov    %eax,%ebx
c010575d:	89 d6                	mov    %edx,%esi
c010575f:	89 5d e8             	mov    %ebx,-0x18(%ebp)
c0105762:	89 75 ec             	mov    %esi,-0x14(%ebp)
c0105765:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105768:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010576b:	8b 45 18             	mov    0x18(%ebp),%eax
c010576e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105773:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105776:	77 56                	ja     c01057ce <printnum+0x10a>
c0105778:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010577b:	72 05                	jb     c0105782 <printnum+0xbe>
c010577d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105780:	77 4c                	ja     c01057ce <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
c0105782:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105785:	8d 50 ff             	lea    -0x1(%eax),%edx
c0105788:	8b 45 20             	mov    0x20(%ebp),%eax
c010578b:	89 44 24 18          	mov    %eax,0x18(%esp)
c010578f:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105793:	8b 45 18             	mov    0x18(%ebp),%eax
c0105796:	89 44 24 10          	mov    %eax,0x10(%esp)
c010579a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010579d:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01057a0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01057a4:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01057a8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057ab:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057af:	8b 45 08             	mov    0x8(%ebp),%eax
c01057b2:	89 04 24             	mov    %eax,(%esp)
c01057b5:	e8 0a ff ff ff       	call   c01056c4 <printnum>
c01057ba:	eb 1c                	jmp    c01057d8 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01057bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01057bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01057c3:	8b 45 20             	mov    0x20(%ebp),%eax
c01057c6:	89 04 24             	mov    %eax,(%esp)
c01057c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01057cc:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01057ce:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01057d2:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01057d6:	7f e4                	jg     c01057bc <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01057d8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01057db:	05 f4 73 10 c0       	add    $0xc01073f4,%eax
c01057e0:	0f b6 00             	movzbl (%eax),%eax
c01057e3:	0f be c0             	movsbl %al,%eax
c01057e6:	8b 55 0c             	mov    0xc(%ebp),%edx
c01057e9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01057ed:	89 04 24             	mov    %eax,(%esp)
c01057f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01057f3:	ff d0                	call   *%eax
}
c01057f5:	83 c4 60             	add    $0x60,%esp
c01057f8:	5b                   	pop    %ebx
c01057f9:	5e                   	pop    %esi
c01057fa:	5d                   	pop    %ebp
c01057fb:	c3                   	ret    

c01057fc <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c01057fc:	55                   	push   %ebp
c01057fd:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c01057ff:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105803:	7e 14                	jle    c0105819 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c0105805:	8b 45 08             	mov    0x8(%ebp),%eax
c0105808:	8b 00                	mov    (%eax),%eax
c010580a:	8d 48 08             	lea    0x8(%eax),%ecx
c010580d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105810:	89 0a                	mov    %ecx,(%edx)
c0105812:	8b 50 04             	mov    0x4(%eax),%edx
c0105815:	8b 00                	mov    (%eax),%eax
c0105817:	eb 30                	jmp    c0105849 <getuint+0x4d>
    }
    else if (lflag) {
c0105819:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010581d:	74 16                	je     c0105835 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010581f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105822:	8b 00                	mov    (%eax),%eax
c0105824:	8d 48 04             	lea    0x4(%eax),%ecx
c0105827:	8b 55 08             	mov    0x8(%ebp),%edx
c010582a:	89 0a                	mov    %ecx,(%edx)
c010582c:	8b 00                	mov    (%eax),%eax
c010582e:	ba 00 00 00 00       	mov    $0x0,%edx
c0105833:	eb 14                	jmp    c0105849 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c0105835:	8b 45 08             	mov    0x8(%ebp),%eax
c0105838:	8b 00                	mov    (%eax),%eax
c010583a:	8d 48 04             	lea    0x4(%eax),%ecx
c010583d:	8b 55 08             	mov    0x8(%ebp),%edx
c0105840:	89 0a                	mov    %ecx,(%edx)
c0105842:	8b 00                	mov    (%eax),%eax
c0105844:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0105849:	5d                   	pop    %ebp
c010584a:	c3                   	ret    

c010584b <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010584b:	55                   	push   %ebp
c010584c:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010584e:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c0105852:	7e 14                	jle    c0105868 <getint+0x1d>
        return va_arg(*ap, long long);
c0105854:	8b 45 08             	mov    0x8(%ebp),%eax
c0105857:	8b 00                	mov    (%eax),%eax
c0105859:	8d 48 08             	lea    0x8(%eax),%ecx
c010585c:	8b 55 08             	mov    0x8(%ebp),%edx
c010585f:	89 0a                	mov    %ecx,(%edx)
c0105861:	8b 50 04             	mov    0x4(%eax),%edx
c0105864:	8b 00                	mov    (%eax),%eax
c0105866:	eb 30                	jmp    c0105898 <getint+0x4d>
    }
    else if (lflag) {
c0105868:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010586c:	74 16                	je     c0105884 <getint+0x39>
        return va_arg(*ap, long);
c010586e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105871:	8b 00                	mov    (%eax),%eax
c0105873:	8d 48 04             	lea    0x4(%eax),%ecx
c0105876:	8b 55 08             	mov    0x8(%ebp),%edx
c0105879:	89 0a                	mov    %ecx,(%edx)
c010587b:	8b 00                	mov    (%eax),%eax
c010587d:	89 c2                	mov    %eax,%edx
c010587f:	c1 fa 1f             	sar    $0x1f,%edx
c0105882:	eb 14                	jmp    c0105898 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
c0105884:	8b 45 08             	mov    0x8(%ebp),%eax
c0105887:	8b 00                	mov    (%eax),%eax
c0105889:	8d 48 04             	lea    0x4(%eax),%ecx
c010588c:	8b 55 08             	mov    0x8(%ebp),%edx
c010588f:	89 0a                	mov    %ecx,(%edx)
c0105891:	8b 00                	mov    (%eax),%eax
c0105893:	89 c2                	mov    %eax,%edx
c0105895:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
c0105898:	5d                   	pop    %ebp
c0105899:	c3                   	ret    

c010589a <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010589a:	55                   	push   %ebp
c010589b:	89 e5                	mov    %esp,%ebp
c010589d:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01058a0:	8d 55 14             	lea    0x14(%ebp),%edx
c01058a3:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01058a6:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
c01058a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058ab:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01058af:	8b 45 10             	mov    0x10(%ebp),%eax
c01058b2:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058bd:	8b 45 08             	mov    0x8(%ebp),%eax
c01058c0:	89 04 24             	mov    %eax,(%esp)
c01058c3:	e8 02 00 00 00       	call   c01058ca <vprintfmt>
    va_end(ap);
}
c01058c8:	c9                   	leave  
c01058c9:	c3                   	ret    

c01058ca <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01058ca:	55                   	push   %ebp
c01058cb:	89 e5                	mov    %esp,%ebp
c01058cd:	56                   	push   %esi
c01058ce:	53                   	push   %ebx
c01058cf:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01058d2:	eb 17                	jmp    c01058eb <vprintfmt+0x21>
            if (ch == '\0') {
c01058d4:	85 db                	test   %ebx,%ebx
c01058d6:	0f 84 db 03 00 00    	je     c0105cb7 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
c01058dc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058df:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058e3:	89 1c 24             	mov    %ebx,(%esp)
c01058e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01058e9:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01058eb:	8b 45 10             	mov    0x10(%ebp),%eax
c01058ee:	0f b6 00             	movzbl (%eax),%eax
c01058f1:	0f b6 d8             	movzbl %al,%ebx
c01058f4:	83 fb 25             	cmp    $0x25,%ebx
c01058f7:	0f 95 c0             	setne  %al
c01058fa:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c01058fe:	84 c0                	test   %al,%al
c0105900:	75 d2                	jne    c01058d4 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c0105902:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c0105906:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010590d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105910:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c0105913:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010591a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010591d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105920:	eb 04                	jmp    c0105926 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
c0105922:	90                   	nop
c0105923:	eb 01                	jmp    c0105926 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
c0105925:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c0105926:	8b 45 10             	mov    0x10(%ebp),%eax
c0105929:	0f b6 00             	movzbl (%eax),%eax
c010592c:	0f b6 d8             	movzbl %al,%ebx
c010592f:	89 d8                	mov    %ebx,%eax
c0105931:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0105935:	83 e8 23             	sub    $0x23,%eax
c0105938:	83 f8 55             	cmp    $0x55,%eax
c010593b:	0f 87 45 03 00 00    	ja     c0105c86 <vprintfmt+0x3bc>
c0105941:	8b 04 85 18 74 10 c0 	mov    -0x3fef8be8(,%eax,4),%eax
c0105948:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010594a:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010594e:	eb d6                	jmp    c0105926 <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0105950:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c0105954:	eb d0                	jmp    c0105926 <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105956:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010595d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105960:	89 d0                	mov    %edx,%eax
c0105962:	c1 e0 02             	shl    $0x2,%eax
c0105965:	01 d0                	add    %edx,%eax
c0105967:	01 c0                	add    %eax,%eax
c0105969:	01 d8                	add    %ebx,%eax
c010596b:	83 e8 30             	sub    $0x30,%eax
c010596e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0105971:	8b 45 10             	mov    0x10(%ebp),%eax
c0105974:	0f b6 00             	movzbl (%eax),%eax
c0105977:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010597a:	83 fb 2f             	cmp    $0x2f,%ebx
c010597d:	7e 39                	jle    c01059b8 <vprintfmt+0xee>
c010597f:	83 fb 39             	cmp    $0x39,%ebx
c0105982:	7f 34                	jg     c01059b8 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c0105984:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0105988:	eb d3                	jmp    c010595d <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010598a:	8b 45 14             	mov    0x14(%ebp),%eax
c010598d:	8d 50 04             	lea    0x4(%eax),%edx
c0105990:	89 55 14             	mov    %edx,0x14(%ebp)
c0105993:	8b 00                	mov    (%eax),%eax
c0105995:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c0105998:	eb 1f                	jmp    c01059b9 <vprintfmt+0xef>

        case '.':
            if (width < 0)
c010599a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010599e:	79 82                	jns    c0105922 <vprintfmt+0x58>
                width = 0;
c01059a0:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01059a7:	e9 76 ff ff ff       	jmp    c0105922 <vprintfmt+0x58>

        case '#':
            altflag = 1;
c01059ac:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01059b3:	e9 6e ff ff ff       	jmp    c0105926 <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c01059b8:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c01059b9:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01059bd:	0f 89 62 ff ff ff    	jns    c0105925 <vprintfmt+0x5b>
                width = precision, precision = -1;
c01059c3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01059c6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01059c9:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01059d0:	e9 50 ff ff ff       	jmp    c0105925 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01059d5:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01059d9:	e9 48 ff ff ff       	jmp    c0105926 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01059de:	8b 45 14             	mov    0x14(%ebp),%eax
c01059e1:	8d 50 04             	lea    0x4(%eax),%edx
c01059e4:	89 55 14             	mov    %edx,0x14(%ebp)
c01059e7:	8b 00                	mov    (%eax),%eax
c01059e9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059ec:	89 54 24 04          	mov    %edx,0x4(%esp)
c01059f0:	89 04 24             	mov    %eax,(%esp)
c01059f3:	8b 45 08             	mov    0x8(%ebp),%eax
c01059f6:	ff d0                	call   *%eax
            break;
c01059f8:	e9 b4 02 00 00       	jmp    c0105cb1 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
c01059fd:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a00:	8d 50 04             	lea    0x4(%eax),%edx
c0105a03:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a06:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0105a08:	85 db                	test   %ebx,%ebx
c0105a0a:	79 02                	jns    c0105a0e <vprintfmt+0x144>
                err = -err;
c0105a0c:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0105a0e:	83 fb 06             	cmp    $0x6,%ebx
c0105a11:	7f 0b                	jg     c0105a1e <vprintfmt+0x154>
c0105a13:	8b 34 9d d8 73 10 c0 	mov    -0x3fef8c28(,%ebx,4),%esi
c0105a1a:	85 f6                	test   %esi,%esi
c0105a1c:	75 23                	jne    c0105a41 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
c0105a1e:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105a22:	c7 44 24 08 05 74 10 	movl   $0xc0107405,0x8(%esp)
c0105a29:	c0 
c0105a2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a34:	89 04 24             	mov    %eax,(%esp)
c0105a37:	e8 5e fe ff ff       	call   c010589a <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0105a3c:	e9 70 02 00 00       	jmp    c0105cb1 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0105a41:	89 74 24 0c          	mov    %esi,0xc(%esp)
c0105a45:	c7 44 24 08 0e 74 10 	movl   $0xc010740e,0x8(%esp)
c0105a4c:	c0 
c0105a4d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a57:	89 04 24             	mov    %eax,(%esp)
c0105a5a:	e8 3b fe ff ff       	call   c010589a <printfmt>
            }
            break;
c0105a5f:	e9 4d 02 00 00       	jmp    c0105cb1 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c0105a64:	8b 45 14             	mov    0x14(%ebp),%eax
c0105a67:	8d 50 04             	lea    0x4(%eax),%edx
c0105a6a:	89 55 14             	mov    %edx,0x14(%ebp)
c0105a6d:	8b 30                	mov    (%eax),%esi
c0105a6f:	85 f6                	test   %esi,%esi
c0105a71:	75 05                	jne    c0105a78 <vprintfmt+0x1ae>
                p = "(null)";
c0105a73:	be 11 74 10 c0       	mov    $0xc0107411,%esi
            }
            if (width > 0 && padc != '-') {
c0105a78:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a7c:	7e 7c                	jle    c0105afa <vprintfmt+0x230>
c0105a7e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c0105a82:	74 76                	je     c0105afa <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105a84:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c0105a87:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105a8a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a8e:	89 34 24             	mov    %esi,(%esp)
c0105a91:	e8 21 03 00 00       	call   c0105db7 <strnlen>
c0105a96:	89 da                	mov    %ebx,%edx
c0105a98:	29 c2                	sub    %eax,%edx
c0105a9a:	89 d0                	mov    %edx,%eax
c0105a9c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a9f:	eb 17                	jmp    c0105ab8 <vprintfmt+0x1ee>
                    putch(padc, putdat);
c0105aa1:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c0105aa5:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105aa8:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105aac:	89 04 24             	mov    %eax,(%esp)
c0105aaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ab2:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c0105ab4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105ab8:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105abc:	7f e3                	jg     c0105aa1 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105abe:	eb 3a                	jmp    c0105afa <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
c0105ac0:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105ac4:	74 1f                	je     c0105ae5 <vprintfmt+0x21b>
c0105ac6:	83 fb 1f             	cmp    $0x1f,%ebx
c0105ac9:	7e 05                	jle    c0105ad0 <vprintfmt+0x206>
c0105acb:	83 fb 7e             	cmp    $0x7e,%ebx
c0105ace:	7e 15                	jle    c0105ae5 <vprintfmt+0x21b>
                    putch('?', putdat);
c0105ad0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ad3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ad7:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c0105ade:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ae1:	ff d0                	call   *%eax
c0105ae3:	eb 0f                	jmp    c0105af4 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
c0105ae5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ae8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aec:	89 1c 24             	mov    %ebx,(%esp)
c0105aef:	8b 45 08             	mov    0x8(%ebp),%eax
c0105af2:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c0105af4:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105af8:	eb 01                	jmp    c0105afb <vprintfmt+0x231>
c0105afa:	90                   	nop
c0105afb:	0f b6 06             	movzbl (%esi),%eax
c0105afe:	0f be d8             	movsbl %al,%ebx
c0105b01:	85 db                	test   %ebx,%ebx
c0105b03:	0f 95 c0             	setne  %al
c0105b06:	83 c6 01             	add    $0x1,%esi
c0105b09:	84 c0                	test   %al,%al
c0105b0b:	74 29                	je     c0105b36 <vprintfmt+0x26c>
c0105b0d:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105b11:	78 ad                	js     c0105ac0 <vprintfmt+0x1f6>
c0105b13:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c0105b17:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105b1b:	79 a3                	jns    c0105ac0 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105b1d:	eb 17                	jmp    c0105b36 <vprintfmt+0x26c>
                putch(' ', putdat);
c0105b1f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b26:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0105b2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b30:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0105b32:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0105b36:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105b3a:	7f e3                	jg     c0105b1f <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
c0105b3c:	e9 70 01 00 00       	jmp    c0105cb1 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0105b41:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b44:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b48:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b4b:	89 04 24             	mov    %eax,(%esp)
c0105b4e:	e8 f8 fc ff ff       	call   c010584b <getint>
c0105b53:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b56:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0105b59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b5f:	85 d2                	test   %edx,%edx
c0105b61:	79 26                	jns    c0105b89 <vprintfmt+0x2bf>
                putch('-', putdat);
c0105b63:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b66:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b6a:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0105b71:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b74:	ff d0                	call   *%eax
                num = -(long long)num;
c0105b76:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b79:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b7c:	f7 d8                	neg    %eax
c0105b7e:	83 d2 00             	adc    $0x0,%edx
c0105b81:	f7 da                	neg    %edx
c0105b83:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b86:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0105b89:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105b90:	e9 a8 00 00 00       	jmp    c0105c3d <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c0105b95:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105b98:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b9c:	8d 45 14             	lea    0x14(%ebp),%eax
c0105b9f:	89 04 24             	mov    %eax,(%esp)
c0105ba2:	e8 55 fc ff ff       	call   c01057fc <getuint>
c0105ba7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105baa:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c0105bad:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0105bb4:	e9 84 00 00 00       	jmp    c0105c3d <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c0105bb9:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105bbc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bc0:	8d 45 14             	lea    0x14(%ebp),%eax
c0105bc3:	89 04 24             	mov    %eax,(%esp)
c0105bc6:	e8 31 fc ff ff       	call   c01057fc <getuint>
c0105bcb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bce:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c0105bd1:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c0105bd8:	eb 63                	jmp    c0105c3d <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
c0105bda:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bdd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105be1:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0105be8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105beb:	ff d0                	call   *%eax
            putch('x', putdat);
c0105bed:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bf0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105bf4:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0105bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105bfe:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0105c00:	8b 45 14             	mov    0x14(%ebp),%eax
c0105c03:	8d 50 04             	lea    0x4(%eax),%edx
c0105c06:	89 55 14             	mov    %edx,0x14(%ebp)
c0105c09:	8b 00                	mov    (%eax),%eax
c0105c0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c0e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c0105c15:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0105c1c:	eb 1f                	jmp    c0105c3d <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0105c1e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c25:	8d 45 14             	lea    0x14(%ebp),%eax
c0105c28:	89 04 24             	mov    %eax,(%esp)
c0105c2b:	e8 cc fb ff ff       	call   c01057fc <getuint>
c0105c30:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105c33:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c0105c36:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0105c3d:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0105c41:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c44:	89 54 24 18          	mov    %edx,0x18(%esp)
c0105c48:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0105c4b:	89 54 24 14          	mov    %edx,0x14(%esp)
c0105c4f:	89 44 24 10          	mov    %eax,0x10(%esp)
c0105c53:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c56:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105c59:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105c5d:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105c61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c64:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c68:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c6b:	89 04 24             	mov    %eax,(%esp)
c0105c6e:	e8 51 fa ff ff       	call   c01056c4 <printnum>
            break;
c0105c73:	eb 3c                	jmp    c0105cb1 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c0105c75:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c78:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c7c:	89 1c 24             	mov    %ebx,(%esp)
c0105c7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c82:	ff d0                	call   *%eax
            break;
c0105c84:	eb 2b                	jmp    c0105cb1 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c0105c86:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c89:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105c8d:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c0105c94:	8b 45 08             	mov    0x8(%ebp),%eax
c0105c97:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c0105c99:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105c9d:	eb 04                	jmp    c0105ca3 <vprintfmt+0x3d9>
c0105c9f:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ca3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ca6:	83 e8 01             	sub    $0x1,%eax
c0105ca9:	0f b6 00             	movzbl (%eax),%eax
c0105cac:	3c 25                	cmp    $0x25,%al
c0105cae:	75 ef                	jne    c0105c9f <vprintfmt+0x3d5>
                /* do nothing */;
            break;
c0105cb0:	90                   	nop
        }
    }
c0105cb1:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0105cb2:	e9 34 fc ff ff       	jmp    c01058eb <vprintfmt+0x21>
            if (ch == '\0') {
                return;
c0105cb7:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c0105cb8:	83 c4 40             	add    $0x40,%esp
c0105cbb:	5b                   	pop    %ebx
c0105cbc:	5e                   	pop    %esi
c0105cbd:	5d                   	pop    %ebp
c0105cbe:	c3                   	ret    

c0105cbf <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c0105cbf:	55                   	push   %ebp
c0105cc0:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c0105cc2:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cc5:	8b 40 08             	mov    0x8(%eax),%eax
c0105cc8:	8d 50 01             	lea    0x1(%eax),%edx
c0105ccb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cce:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c0105cd1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd4:	8b 10                	mov    (%eax),%edx
c0105cd6:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cd9:	8b 40 04             	mov    0x4(%eax),%eax
c0105cdc:	39 c2                	cmp    %eax,%edx
c0105cde:	73 12                	jae    c0105cf2 <sprintputch+0x33>
        *b->buf ++ = ch;
c0105ce0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ce3:	8b 00                	mov    (%eax),%eax
c0105ce5:	8b 55 08             	mov    0x8(%ebp),%edx
c0105ce8:	88 10                	mov    %dl,(%eax)
c0105cea:	8d 50 01             	lea    0x1(%eax),%edx
c0105ced:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105cf0:	89 10                	mov    %edx,(%eax)
    }
}
c0105cf2:	5d                   	pop    %ebp
c0105cf3:	c3                   	ret    

c0105cf4 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c0105cf4:	55                   	push   %ebp
c0105cf5:	89 e5                	mov    %esp,%ebp
c0105cf7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0105cfa:	8d 55 14             	lea    0x14(%ebp),%edx
c0105cfd:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0105d00:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
c0105d02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d05:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d09:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d0c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d17:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d1a:	89 04 24             	mov    %eax,(%esp)
c0105d1d:	e8 08 00 00 00       	call   c0105d2a <vsnprintf>
c0105d22:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0105d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105d28:	c9                   	leave  
c0105d29:	c3                   	ret    

c0105d2a <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0105d2a:	55                   	push   %ebp
c0105d2b:	89 e5                	mov    %esp,%ebp
c0105d2d:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0105d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d33:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d39:	83 e8 01             	sub    $0x1,%eax
c0105d3c:	03 45 08             	add    0x8(%ebp),%eax
c0105d3f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d42:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0105d49:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0105d4d:	74 0a                	je     c0105d59 <vsnprintf+0x2f>
c0105d4f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105d52:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d55:	39 c2                	cmp    %eax,%edx
c0105d57:	76 07                	jbe    c0105d60 <vsnprintf+0x36>
        return -E_INVAL;
c0105d59:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0105d5e:	eb 2a                	jmp    c0105d8a <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0105d60:	8b 45 14             	mov    0x14(%ebp),%eax
c0105d63:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105d67:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d6a:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105d6e:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0105d71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d75:	c7 04 24 bf 5c 10 c0 	movl   $0xc0105cbf,(%esp)
c0105d7c:	e8 49 fb ff ff       	call   c01058ca <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0105d81:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105d84:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0105d87:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105d8a:	c9                   	leave  
c0105d8b:	c3                   	ret    

c0105d8c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0105d8c:	55                   	push   %ebp
c0105d8d:	89 e5                	mov    %esp,%ebp
c0105d8f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105d92:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0105d99:	eb 04                	jmp    c0105d9f <strlen+0x13>
        cnt ++;
c0105d9b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0105d9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da2:	0f b6 00             	movzbl (%eax),%eax
c0105da5:	84 c0                	test   %al,%al
c0105da7:	0f 95 c0             	setne  %al
c0105daa:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105dae:	84 c0                	test   %al,%al
c0105db0:	75 e9                	jne    c0105d9b <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0105db2:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105db5:	c9                   	leave  
c0105db6:	c3                   	ret    

c0105db7 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0105db7:	55                   	push   %ebp
c0105db8:	89 e5                	mov    %esp,%ebp
c0105dba:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0105dbd:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0105dc4:	eb 04                	jmp    c0105dca <strnlen+0x13>
        cnt ++;
c0105dc6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0105dca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105dcd:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105dd0:	73 13                	jae    c0105de5 <strnlen+0x2e>
c0105dd2:	8b 45 08             	mov    0x8(%ebp),%eax
c0105dd5:	0f b6 00             	movzbl (%eax),%eax
c0105dd8:	84 c0                	test   %al,%al
c0105dda:	0f 95 c0             	setne  %al
c0105ddd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105de1:	84 c0                	test   %al,%al
c0105de3:	75 e1                	jne    c0105dc6 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0105de5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0105de8:	c9                   	leave  
c0105de9:	c3                   	ret    

c0105dea <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0105dea:	55                   	push   %ebp
c0105deb:	89 e5                	mov    %esp,%ebp
c0105ded:	57                   	push   %edi
c0105dee:	56                   	push   %esi
c0105def:	53                   	push   %ebx
c0105df0:	83 ec 24             	sub    $0x24,%esp
c0105df3:	8b 45 08             	mov    0x8(%ebp),%eax
c0105df6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105df9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105dfc:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0105dff:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105e02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105e05:	89 d6                	mov    %edx,%esi
c0105e07:	89 c3                	mov    %eax,%ebx
c0105e09:	89 df                	mov    %ebx,%edi
c0105e0b:	ac                   	lods   %ds:(%esi),%al
c0105e0c:	aa                   	stos   %al,%es:(%edi)
c0105e0d:	84 c0                	test   %al,%al
c0105e0f:	75 fa                	jne    c0105e0b <strcpy+0x21>
c0105e11:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105e14:	89 fb                	mov    %edi,%ebx
c0105e16:	89 75 e8             	mov    %esi,-0x18(%ebp)
c0105e19:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
c0105e1c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105e1f:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0105e22:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0105e25:	83 c4 24             	add    $0x24,%esp
c0105e28:	5b                   	pop    %ebx
c0105e29:	5e                   	pop    %esi
c0105e2a:	5f                   	pop    %edi
c0105e2b:	5d                   	pop    %ebp
c0105e2c:	c3                   	ret    

c0105e2d <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0105e2d:	55                   	push   %ebp
c0105e2e:	89 e5                	mov    %esp,%ebp
c0105e30:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0105e33:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e36:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0105e39:	eb 21                	jmp    c0105e5c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0105e3b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e3e:	0f b6 10             	movzbl (%eax),%edx
c0105e41:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e44:	88 10                	mov    %dl,(%eax)
c0105e46:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e49:	0f b6 00             	movzbl (%eax),%eax
c0105e4c:	84 c0                	test   %al,%al
c0105e4e:	74 04                	je     c0105e54 <strncpy+0x27>
            src ++;
c0105e50:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0105e54:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0105e58:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0105e5c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105e60:	75 d9                	jne    c0105e3b <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0105e62:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105e65:	c9                   	leave  
c0105e66:	c3                   	ret    

c0105e67 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0105e67:	55                   	push   %ebp
c0105e68:	89 e5                	mov    %esp,%ebp
c0105e6a:	57                   	push   %edi
c0105e6b:	56                   	push   %esi
c0105e6c:	53                   	push   %ebx
c0105e6d:	83 ec 24             	sub    $0x24,%esp
c0105e70:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e73:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105e76:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105e79:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0105e7c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0105e7f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105e82:	89 d6                	mov    %edx,%esi
c0105e84:	89 c3                	mov    %eax,%ebx
c0105e86:	89 df                	mov    %ebx,%edi
c0105e88:	ac                   	lods   %ds:(%esi),%al
c0105e89:	ae                   	scas   %es:(%edi),%al
c0105e8a:	75 08                	jne    c0105e94 <strcmp+0x2d>
c0105e8c:	84 c0                	test   %al,%al
c0105e8e:	75 f8                	jne    c0105e88 <strcmp+0x21>
c0105e90:	31 c0                	xor    %eax,%eax
c0105e92:	eb 04                	jmp    c0105e98 <strcmp+0x31>
c0105e94:	19 c0                	sbb    %eax,%eax
c0105e96:	0c 01                	or     $0x1,%al
c0105e98:	89 fb                	mov    %edi,%ebx
c0105e9a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0105e9d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105ea0:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105ea3:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0105ea6:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0105ea9:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0105eac:	83 c4 24             	add    $0x24,%esp
c0105eaf:	5b                   	pop    %ebx
c0105eb0:	5e                   	pop    %esi
c0105eb1:	5f                   	pop    %edi
c0105eb2:	5d                   	pop    %ebp
c0105eb3:	c3                   	ret    

c0105eb4 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0105eb4:	55                   	push   %ebp
c0105eb5:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105eb7:	eb 0c                	jmp    c0105ec5 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0105eb9:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0105ebd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105ec1:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0105ec5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ec9:	74 1a                	je     c0105ee5 <strncmp+0x31>
c0105ecb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ece:	0f b6 00             	movzbl (%eax),%eax
c0105ed1:	84 c0                	test   %al,%al
c0105ed3:	74 10                	je     c0105ee5 <strncmp+0x31>
c0105ed5:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed8:	0f b6 10             	movzbl (%eax),%edx
c0105edb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ede:	0f b6 00             	movzbl (%eax),%eax
c0105ee1:	38 c2                	cmp    %al,%dl
c0105ee3:	74 d4                	je     c0105eb9 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0105ee5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ee9:	74 1a                	je     c0105f05 <strncmp+0x51>
c0105eeb:	8b 45 08             	mov    0x8(%ebp),%eax
c0105eee:	0f b6 00             	movzbl (%eax),%eax
c0105ef1:	0f b6 d0             	movzbl %al,%edx
c0105ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ef7:	0f b6 00             	movzbl (%eax),%eax
c0105efa:	0f b6 c0             	movzbl %al,%eax
c0105efd:	89 d1                	mov    %edx,%ecx
c0105eff:	29 c1                	sub    %eax,%ecx
c0105f01:	89 c8                	mov    %ecx,%eax
c0105f03:	eb 05                	jmp    c0105f0a <strncmp+0x56>
c0105f05:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f0a:	5d                   	pop    %ebp
c0105f0b:	c3                   	ret    

c0105f0c <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0105f0c:	55                   	push   %ebp
c0105f0d:	89 e5                	mov    %esp,%ebp
c0105f0f:	83 ec 04             	sub    $0x4,%esp
c0105f12:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f15:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105f18:	eb 14                	jmp    c0105f2e <strchr+0x22>
        if (*s == c) {
c0105f1a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f1d:	0f b6 00             	movzbl (%eax),%eax
c0105f20:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105f23:	75 05                	jne    c0105f2a <strchr+0x1e>
            return (char *)s;
c0105f25:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f28:	eb 13                	jmp    c0105f3d <strchr+0x31>
        }
        s ++;
c0105f2a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0105f2e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f31:	0f b6 00             	movzbl (%eax),%eax
c0105f34:	84 c0                	test   %al,%al
c0105f36:	75 e2                	jne    c0105f1a <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0105f38:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105f3d:	c9                   	leave  
c0105f3e:	c3                   	ret    

c0105f3f <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0105f3f:	55                   	push   %ebp
c0105f40:	89 e5                	mov    %esp,%ebp
c0105f42:	83 ec 04             	sub    $0x4,%esp
c0105f45:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f48:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0105f4b:	eb 0f                	jmp    c0105f5c <strfind+0x1d>
        if (*s == c) {
c0105f4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f50:	0f b6 00             	movzbl (%eax),%eax
c0105f53:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0105f56:	74 10                	je     c0105f68 <strfind+0x29>
            break;
        }
        s ++;
c0105f58:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0105f5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f5f:	0f b6 00             	movzbl (%eax),%eax
c0105f62:	84 c0                	test   %al,%al
c0105f64:	75 e7                	jne    c0105f4d <strfind+0xe>
c0105f66:	eb 01                	jmp    c0105f69 <strfind+0x2a>
        if (*s == c) {
            break;
c0105f68:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0105f69:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0105f6c:	c9                   	leave  
c0105f6d:	c3                   	ret    

c0105f6e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0105f6e:	55                   	push   %ebp
c0105f6f:	89 e5                	mov    %esp,%ebp
c0105f71:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0105f74:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0105f7b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105f82:	eb 04                	jmp    c0105f88 <strtol+0x1a>
        s ++;
c0105f84:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0105f88:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f8b:	0f b6 00             	movzbl (%eax),%eax
c0105f8e:	3c 20                	cmp    $0x20,%al
c0105f90:	74 f2                	je     c0105f84 <strtol+0x16>
c0105f92:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f95:	0f b6 00             	movzbl (%eax),%eax
c0105f98:	3c 09                	cmp    $0x9,%al
c0105f9a:	74 e8                	je     c0105f84 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0105f9c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f9f:	0f b6 00             	movzbl (%eax),%eax
c0105fa2:	3c 2b                	cmp    $0x2b,%al
c0105fa4:	75 06                	jne    c0105fac <strtol+0x3e>
        s ++;
c0105fa6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105faa:	eb 15                	jmp    c0105fc1 <strtol+0x53>
    }
    else if (*s == '-') {
c0105fac:	8b 45 08             	mov    0x8(%ebp),%eax
c0105faf:	0f b6 00             	movzbl (%eax),%eax
c0105fb2:	3c 2d                	cmp    $0x2d,%al
c0105fb4:	75 0b                	jne    c0105fc1 <strtol+0x53>
        s ++, neg = 1;
c0105fb6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0105fba:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0105fc1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105fc5:	74 06                	je     c0105fcd <strtol+0x5f>
c0105fc7:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0105fcb:	75 24                	jne    c0105ff1 <strtol+0x83>
c0105fcd:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fd0:	0f b6 00             	movzbl (%eax),%eax
c0105fd3:	3c 30                	cmp    $0x30,%al
c0105fd5:	75 1a                	jne    c0105ff1 <strtol+0x83>
c0105fd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fda:	83 c0 01             	add    $0x1,%eax
c0105fdd:	0f b6 00             	movzbl (%eax),%eax
c0105fe0:	3c 78                	cmp    $0x78,%al
c0105fe2:	75 0d                	jne    c0105ff1 <strtol+0x83>
        s += 2, base = 16;
c0105fe4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0105fe8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0105fef:	eb 2a                	jmp    c010601b <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0105ff1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ff5:	75 17                	jne    c010600e <strtol+0xa0>
c0105ff7:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ffa:	0f b6 00             	movzbl (%eax),%eax
c0105ffd:	3c 30                	cmp    $0x30,%al
c0105fff:	75 0d                	jne    c010600e <strtol+0xa0>
        s ++, base = 8;
c0106001:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0106005:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010600c:	eb 0d                	jmp    c010601b <strtol+0xad>
    }
    else if (base == 0) {
c010600e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106012:	75 07                	jne    c010601b <strtol+0xad>
        base = 10;
c0106014:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010601b:	8b 45 08             	mov    0x8(%ebp),%eax
c010601e:	0f b6 00             	movzbl (%eax),%eax
c0106021:	3c 2f                	cmp    $0x2f,%al
c0106023:	7e 1b                	jle    c0106040 <strtol+0xd2>
c0106025:	8b 45 08             	mov    0x8(%ebp),%eax
c0106028:	0f b6 00             	movzbl (%eax),%eax
c010602b:	3c 39                	cmp    $0x39,%al
c010602d:	7f 11                	jg     c0106040 <strtol+0xd2>
            dig = *s - '0';
c010602f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106032:	0f b6 00             	movzbl (%eax),%eax
c0106035:	0f be c0             	movsbl %al,%eax
c0106038:	83 e8 30             	sub    $0x30,%eax
c010603b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010603e:	eb 48                	jmp    c0106088 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0106040:	8b 45 08             	mov    0x8(%ebp),%eax
c0106043:	0f b6 00             	movzbl (%eax),%eax
c0106046:	3c 60                	cmp    $0x60,%al
c0106048:	7e 1b                	jle    c0106065 <strtol+0xf7>
c010604a:	8b 45 08             	mov    0x8(%ebp),%eax
c010604d:	0f b6 00             	movzbl (%eax),%eax
c0106050:	3c 7a                	cmp    $0x7a,%al
c0106052:	7f 11                	jg     c0106065 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0106054:	8b 45 08             	mov    0x8(%ebp),%eax
c0106057:	0f b6 00             	movzbl (%eax),%eax
c010605a:	0f be c0             	movsbl %al,%eax
c010605d:	83 e8 57             	sub    $0x57,%eax
c0106060:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0106063:	eb 23                	jmp    c0106088 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0106065:	8b 45 08             	mov    0x8(%ebp),%eax
c0106068:	0f b6 00             	movzbl (%eax),%eax
c010606b:	3c 40                	cmp    $0x40,%al
c010606d:	7e 38                	jle    c01060a7 <strtol+0x139>
c010606f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106072:	0f b6 00             	movzbl (%eax),%eax
c0106075:	3c 5a                	cmp    $0x5a,%al
c0106077:	7f 2e                	jg     c01060a7 <strtol+0x139>
            dig = *s - 'A' + 10;
c0106079:	8b 45 08             	mov    0x8(%ebp),%eax
c010607c:	0f b6 00             	movzbl (%eax),%eax
c010607f:	0f be c0             	movsbl %al,%eax
c0106082:	83 e8 37             	sub    $0x37,%eax
c0106085:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0106088:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010608b:	3b 45 10             	cmp    0x10(%ebp),%eax
c010608e:	7d 16                	jge    c01060a6 <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
c0106090:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0106094:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106097:	0f af 45 10          	imul   0x10(%ebp),%eax
c010609b:	03 45 f4             	add    -0xc(%ebp),%eax
c010609e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c01060a1:	e9 75 ff ff ff       	jmp    c010601b <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c01060a6:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c01060a7:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01060ab:	74 08                	je     c01060b5 <strtol+0x147>
        *endptr = (char *) s;
c01060ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060b0:	8b 55 08             	mov    0x8(%ebp),%edx
c01060b3:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c01060b5:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01060b9:	74 07                	je     c01060c2 <strtol+0x154>
c01060bb:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01060be:	f7 d8                	neg    %eax
c01060c0:	eb 03                	jmp    c01060c5 <strtol+0x157>
c01060c2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01060c5:	c9                   	leave  
c01060c6:	c3                   	ret    

c01060c7 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c01060c7:	55                   	push   %ebp
c01060c8:	89 e5                	mov    %esp,%ebp
c01060ca:	57                   	push   %edi
c01060cb:	56                   	push   %esi
c01060cc:	53                   	push   %ebx
c01060cd:	83 ec 24             	sub    $0x24,%esp
c01060d0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060d3:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c01060d6:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
c01060da:	8b 55 08             	mov    0x8(%ebp),%edx
c01060dd:	89 55 f0             	mov    %edx,-0x10(%ebp)
c01060e0:	88 45 ef             	mov    %al,-0x11(%ebp)
c01060e3:	8b 45 10             	mov    0x10(%ebp),%eax
c01060e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c01060e9:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01060ec:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c01060f0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01060f3:	89 ce                	mov    %ecx,%esi
c01060f5:	89 d3                	mov    %edx,%ebx
c01060f7:	89 f1                	mov    %esi,%ecx
c01060f9:	89 df                	mov    %ebx,%edi
c01060fb:	f3 aa                	rep stos %al,%es:(%edi)
c01060fd:	89 fb                	mov    %edi,%ebx
c01060ff:	89 ce                	mov    %ecx,%esi
c0106101:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0106104:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0106107:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010610a:	83 c4 24             	add    $0x24,%esp
c010610d:	5b                   	pop    %ebx
c010610e:	5e                   	pop    %esi
c010610f:	5f                   	pop    %edi
c0106110:	5d                   	pop    %ebp
c0106111:	c3                   	ret    

c0106112 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0106112:	55                   	push   %ebp
c0106113:	89 e5                	mov    %esp,%ebp
c0106115:	57                   	push   %edi
c0106116:	56                   	push   %esi
c0106117:	53                   	push   %ebx
c0106118:	83 ec 38             	sub    $0x38,%esp
c010611b:	8b 45 08             	mov    0x8(%ebp),%eax
c010611e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106121:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106124:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106127:	8b 45 10             	mov    0x10(%ebp),%eax
c010612a:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010612d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106130:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0106133:	73 4e                	jae    c0106183 <memmove+0x71>
c0106135:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106138:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010613b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010613e:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106141:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106144:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0106147:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010614a:	89 c1                	mov    %eax,%ecx
c010614c:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010614f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106152:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106155:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0106158:	89 d7                	mov    %edx,%edi
c010615a:	89 c3                	mov    %eax,%ebx
c010615c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010615f:	89 de                	mov    %ebx,%esi
c0106161:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0106163:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106166:	83 e1 03             	and    $0x3,%ecx
c0106169:	74 02                	je     c010616d <memmove+0x5b>
c010616b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010616d:	89 f3                	mov    %esi,%ebx
c010616f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0106172:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0106175:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0106178:	89 7d d4             	mov    %edi,-0x2c(%ebp)
c010617b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010617e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106181:	eb 3b                	jmp    c01061be <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0106183:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106186:	83 e8 01             	sub    $0x1,%eax
c0106189:	89 c2                	mov    %eax,%edx
c010618b:	03 55 ec             	add    -0x14(%ebp),%edx
c010618e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106191:	83 e8 01             	sub    $0x1,%eax
c0106194:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0106197:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010619a:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c010619d:	89 d6                	mov    %edx,%esi
c010619f:	89 c3                	mov    %eax,%ebx
c01061a1:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c01061a4:	89 df                	mov    %ebx,%edi
c01061a6:	fd                   	std    
c01061a7:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c01061a9:	fc                   	cld    
c01061aa:	89 fb                	mov    %edi,%ebx
c01061ac:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c01061af:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c01061b2:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c01061b5:	89 75 c8             	mov    %esi,-0x38(%ebp)
c01061b8:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c01061bb:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c01061be:	83 c4 38             	add    $0x38,%esp
c01061c1:	5b                   	pop    %ebx
c01061c2:	5e                   	pop    %esi
c01061c3:	5f                   	pop    %edi
c01061c4:	5d                   	pop    %ebp
c01061c5:	c3                   	ret    

c01061c6 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c01061c6:	55                   	push   %ebp
c01061c7:	89 e5                	mov    %esp,%ebp
c01061c9:	57                   	push   %edi
c01061ca:	56                   	push   %esi
c01061cb:	53                   	push   %ebx
c01061cc:	83 ec 24             	sub    $0x24,%esp
c01061cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01061d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01061d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01061d8:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01061db:	8b 45 10             	mov    0x10(%ebp),%eax
c01061de:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c01061e1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061e4:	89 c1                	mov    %eax,%ecx
c01061e6:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c01061e9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01061ec:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01061ef:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c01061f2:	89 d7                	mov    %edx,%edi
c01061f4:	89 c3                	mov    %eax,%ebx
c01061f6:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c01061f9:	89 de                	mov    %ebx,%esi
c01061fb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c01061fd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0106200:	83 e1 03             	and    $0x3,%ecx
c0106203:	74 02                	je     c0106207 <memcpy+0x41>
c0106205:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0106207:	89 f3                	mov    %esi,%ebx
c0106209:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c010620c:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010620f:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
c0106212:	89 7d e0             	mov    %edi,-0x20(%ebp)
c0106215:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0106218:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010621b:	83 c4 24             	add    $0x24,%esp
c010621e:	5b                   	pop    %ebx
c010621f:	5e                   	pop    %esi
c0106220:	5f                   	pop    %edi
c0106221:	5d                   	pop    %ebp
c0106222:	c3                   	ret    

c0106223 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0106223:	55                   	push   %ebp
c0106224:	89 e5                	mov    %esp,%ebp
c0106226:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0106229:	8b 45 08             	mov    0x8(%ebp),%eax
c010622c:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010622f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106232:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0106235:	eb 32                	jmp    c0106269 <memcmp+0x46>
        if (*s1 != *s2) {
c0106237:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010623a:	0f b6 10             	movzbl (%eax),%edx
c010623d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106240:	0f b6 00             	movzbl (%eax),%eax
c0106243:	38 c2                	cmp    %al,%dl
c0106245:	74 1a                	je     c0106261 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0106247:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010624a:	0f b6 00             	movzbl (%eax),%eax
c010624d:	0f b6 d0             	movzbl %al,%edx
c0106250:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0106253:	0f b6 00             	movzbl (%eax),%eax
c0106256:	0f b6 c0             	movzbl %al,%eax
c0106259:	89 d1                	mov    %edx,%ecx
c010625b:	29 c1                	sub    %eax,%ecx
c010625d:	89 c8                	mov    %ecx,%eax
c010625f:	eb 1c                	jmp    c010627d <memcmp+0x5a>
        }
        s1 ++, s2 ++;
c0106261:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0106265:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0106269:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010626d:	0f 95 c0             	setne  %al
c0106270:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0106274:	84 c0                	test   %al,%al
c0106276:	75 bf                	jne    c0106237 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0106278:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010627d:	c9                   	leave  
c010627e:	c3                   	ret    
