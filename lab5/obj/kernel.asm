
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 a0 12 00 	lgdtl  0x12a018
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
c010001e:	bc 00 a0 12 c0       	mov    $0xc012a000,%esp
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
c0100032:	ba b8 ef 19 c0       	mov    $0xc019efb8,%edx
c0100037:	b8 3a be 19 c0       	mov    $0xc019be3a,%eax
c010003c:	89 d1                	mov    %edx,%ecx
c010003e:	29 c1                	sub    %eax,%ecx
c0100040:	89 c8                	mov    %ecx,%eax
c0100042:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100046:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010004d:	00 
c010004e:	c7 04 24 3a be 19 c0 	movl   $0xc019be3a,(%esp)
c0100055:	e8 2d be 00 00       	call   c010be87 <memset>

    cons_init();                // init the console
c010005a:	e8 0d 17 00 00       	call   c010176c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005f:	c7 45 f4 40 c0 10 c0 	movl   $0xc010c040,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100066:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100069:	89 44 24 04          	mov    %eax,0x4(%esp)
c010006d:	c7 04 24 5c c0 10 c0 	movl   $0xc010c05c,(%esp)
c0100074:	e8 e6 02 00 00       	call   c010035f <cprintf>

    print_kerninfo();
c0100079:	e8 ea 08 00 00       	call   c0100968 <print_kerninfo>

    grade_backtrace();
c010007e:	e8 9d 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100083:	e8 eb 56 00 00       	call   c0105773 <pmm_init>

    pic_init();                 // init interrupt controller
c0100088:	e8 ec 20 00 00       	call   c0102179 <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008d:	e8 64 22 00 00       	call   c01022f6 <idt_init>

    vmm_init();                 // init virtual memory management
c0100092:	e8 cf 86 00 00       	call   c0108766 <vmm_init>
    proc_init();                // init process table
c0100097:	e8 1d ad 00 00       	call   c010adb9 <proc_init>
    
    ide_init();                 // init ide devices
c010009c:	e8 0a 18 00 00       	call   c01018ab <ide_init>
    swap_init();                // init swap
c01000a1:	e8 95 6d 00 00       	call   c0106e3b <swap_init>

    clock_init();               // init clock interrupt
c01000a6:	e8 d1 0d 00 00       	call   c0100e7c <clock_init>
    intr_enable();              // enable irq interrupt
c01000ab:	e8 30 20 00 00       	call   c01020e0 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000b0:	e8 c3 ae 00 00       	call   c010af78 <cpu_idle>

c01000b5 <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000b5:	55                   	push   %ebp
c01000b6:	89 e5                	mov    %esp,%ebp
c01000b8:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000bb:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000c2:	00 
c01000c3:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000ca:	00 
c01000cb:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000d2:	e8 cf 0c 00 00       	call   c0100da6 <mon_backtrace>
}
c01000d7:	c9                   	leave  
c01000d8:	c3                   	ret    

c01000d9 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d9:	55                   	push   %ebp
c01000da:	89 e5                	mov    %esp,%ebp
c01000dc:	53                   	push   %ebx
c01000dd:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000e0:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000e3:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000e6:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e9:	8b 45 08             	mov    0x8(%ebp),%eax
c01000ec:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000f0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f8:	89 04 24             	mov    %eax,(%esp)
c01000fb:	e8 b5 ff ff ff       	call   c01000b5 <grade_backtrace2>
}
c0100100:	83 c4 14             	add    $0x14,%esp
c0100103:	5b                   	pop    %ebx
c0100104:	5d                   	pop    %ebp
c0100105:	c3                   	ret    

c0100106 <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c0100106:	55                   	push   %ebp
c0100107:	89 e5                	mov    %esp,%ebp
c0100109:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c010010c:	8b 45 10             	mov    0x10(%ebp),%eax
c010010f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100113:	8b 45 08             	mov    0x8(%ebp),%eax
c0100116:	89 04 24             	mov    %eax,(%esp)
c0100119:	e8 bb ff ff ff       	call   c01000d9 <grade_backtrace1>
}
c010011e:	c9                   	leave  
c010011f:	c3                   	ret    

c0100120 <grade_backtrace>:

void
grade_backtrace(void) {
c0100120:	55                   	push   %ebp
c0100121:	89 e5                	mov    %esp,%ebp
c0100123:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c0100126:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c010012b:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c0100132:	ff 
c0100133:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100137:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010013e:	e8 c3 ff ff ff       	call   c0100106 <grade_backtrace0>
}
c0100143:	c9                   	leave  
c0100144:	c3                   	ret    

c0100145 <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c0100145:	55                   	push   %ebp
c0100146:	89 e5                	mov    %esp,%ebp
c0100148:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c010014b:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c010014e:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100151:	8c 45 f2             	mov    %es,-0xe(%ebp)
c0100154:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c0100157:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c010015b:	0f b7 c0             	movzwl %ax,%eax
c010015e:	89 c2                	mov    %eax,%edx
c0100160:	83 e2 03             	and    $0x3,%edx
c0100163:	a1 40 be 19 c0       	mov    0xc019be40,%eax
c0100168:	89 54 24 08          	mov    %edx,0x8(%esp)
c010016c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100170:	c7 04 24 61 c0 10 c0 	movl   $0xc010c061,(%esp)
c0100177:	e8 e3 01 00 00       	call   c010035f <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010017c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100180:	0f b7 d0             	movzwl %ax,%edx
c0100183:	a1 40 be 19 c0       	mov    0xc019be40,%eax
c0100188:	89 54 24 08          	mov    %edx,0x8(%esp)
c010018c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100190:	c7 04 24 6f c0 10 c0 	movl   $0xc010c06f,(%esp)
c0100197:	e8 c3 01 00 00       	call   c010035f <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010019c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a0:	0f b7 d0             	movzwl %ax,%edx
c01001a3:	a1 40 be 19 c0       	mov    0xc019be40,%eax
c01001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b0:	c7 04 24 7d c0 10 c0 	movl   $0xc010c07d,(%esp)
c01001b7:	e8 a3 01 00 00       	call   c010035f <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001bc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c0:	0f b7 d0             	movzwl %ax,%edx
c01001c3:	a1 40 be 19 c0       	mov    0xc019be40,%eax
c01001c8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d0:	c7 04 24 8b c0 10 c0 	movl   $0xc010c08b,(%esp)
c01001d7:	e8 83 01 00 00       	call   c010035f <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001dc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e0:	0f b7 d0             	movzwl %ax,%edx
c01001e3:	a1 40 be 19 c0       	mov    0xc019be40,%eax
c01001e8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f0:	c7 04 24 99 c0 10 c0 	movl   $0xc010c099,(%esp)
c01001f7:	e8 63 01 00 00       	call   c010035f <cprintf>
    round ++;
c01001fc:	a1 40 be 19 c0       	mov    0xc019be40,%eax
c0100201:	83 c0 01             	add    $0x1,%eax
c0100204:	a3 40 be 19 c0       	mov    %eax,0xc019be40
}
c0100209:	c9                   	leave  
c010020a:	c3                   	ret    

c010020b <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c010020b:	55                   	push   %ebp
c010020c:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c010020e:	5d                   	pop    %ebp
c010020f:	c3                   	ret    

c0100210 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100210:	55                   	push   %ebp
c0100211:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c0100213:	5d                   	pop    %ebp
c0100214:	c3                   	ret    

c0100215 <lab1_switch_test>:

static void
lab1_switch_test(void) {
c0100215:	55                   	push   %ebp
c0100216:	89 e5                	mov    %esp,%ebp
c0100218:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c010021b:	e8 25 ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100220:	c7 04 24 a8 c0 10 c0 	movl   $0xc010c0a8,(%esp)
c0100227:	e8 33 01 00 00       	call   c010035f <cprintf>
    lab1_switch_to_user();
c010022c:	e8 da ff ff ff       	call   c010020b <lab1_switch_to_user>
    lab1_print_cur_status();
c0100231:	e8 0f ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100236:	c7 04 24 c8 c0 10 c0 	movl   $0xc010c0c8,(%esp)
c010023d:	e8 1d 01 00 00       	call   c010035f <cprintf>
    lab1_switch_to_kernel();
c0100242:	e8 c9 ff ff ff       	call   c0100210 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c0100247:	e8 f9 fe ff ff       	call   c0100145 <lab1_print_cur_status>
}
c010024c:	c9                   	leave  
c010024d:	c3                   	ret    
	...

c0100250 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100250:	55                   	push   %ebp
c0100251:	89 e5                	mov    %esp,%ebp
c0100253:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c0100256:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010025a:	74 13                	je     c010026f <readline+0x1f>
        cprintf("%s", prompt);
c010025c:	8b 45 08             	mov    0x8(%ebp),%eax
c010025f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100263:	c7 04 24 e7 c0 10 c0 	movl   $0xc010c0e7,(%esp)
c010026a:	e8 f0 00 00 00       	call   c010035f <cprintf>
    }
    int i = 0, c;
c010026f:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100276:	eb 01                	jmp    c0100279 <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
c0100278:	90                   	nop
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
c0100279:	e8 6e 01 00 00       	call   c01003ec <getchar>
c010027e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100281:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100285:	79 07                	jns    c010028e <readline+0x3e>
            return NULL;
c0100287:	b8 00 00 00 00       	mov    $0x0,%eax
c010028c:	eb 79                	jmp    c0100307 <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c010028e:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c0100292:	7e 28                	jle    c01002bc <readline+0x6c>
c0100294:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c010029b:	7f 1f                	jg     c01002bc <readline+0x6c>
            cputchar(c);
c010029d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a0:	89 04 24             	mov    %eax,(%esp)
c01002a3:	e8 df 00 00 00       	call   c0100387 <cputchar>
            buf[i ++] = c;
c01002a8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01002ae:	81 c2 60 be 19 c0    	add    $0xc019be60,%edx
c01002b4:	88 02                	mov    %al,(%edx)
c01002b6:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01002ba:	eb 46                	jmp    c0100302 <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01002bc:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002c0:	75 17                	jne    c01002d9 <readline+0x89>
c01002c2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002c6:	7e 11                	jle    c01002d9 <readline+0x89>
            cputchar(c);
c01002c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002cb:	89 04 24             	mov    %eax,(%esp)
c01002ce:	e8 b4 00 00 00       	call   c0100387 <cputchar>
            i --;
c01002d3:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002d7:	eb 29                	jmp    c0100302 <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c01002d9:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002dd:	74 06                	je     c01002e5 <readline+0x95>
c01002df:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002e3:	75 93                	jne    c0100278 <readline+0x28>
            cputchar(c);
c01002e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002e8:	89 04 24             	mov    %eax,(%esp)
c01002eb:	e8 97 00 00 00       	call   c0100387 <cputchar>
            buf[i] = '\0';
c01002f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002f3:	05 60 be 19 c0       	add    $0xc019be60,%eax
c01002f8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002fb:	b8 60 be 19 c0       	mov    $0xc019be60,%eax
c0100300:	eb 05                	jmp    c0100307 <readline+0xb7>
        }
    }
c0100302:	e9 71 ff ff ff       	jmp    c0100278 <readline+0x28>
}
c0100307:	c9                   	leave  
c0100308:	c3                   	ret    
c0100309:	00 00                	add    %al,(%eax)
	...

c010030c <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c010030c:	55                   	push   %ebp
c010030d:	89 e5                	mov    %esp,%ebp
c010030f:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100312:	8b 45 08             	mov    0x8(%ebp),%eax
c0100315:	89 04 24             	mov    %eax,(%esp)
c0100318:	e8 7b 14 00 00       	call   c0101798 <cons_putc>
    (*cnt) ++;
c010031d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100320:	8b 00                	mov    (%eax),%eax
c0100322:	8d 50 01             	lea    0x1(%eax),%edx
c0100325:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100328:	89 10                	mov    %edx,(%eax)
}
c010032a:	c9                   	leave  
c010032b:	c3                   	ret    

c010032c <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c010032c:	55                   	push   %ebp
c010032d:	89 e5                	mov    %esp,%ebp
c010032f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100332:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100339:	8b 45 0c             	mov    0xc(%ebp),%eax
c010033c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100340:	8b 45 08             	mov    0x8(%ebp),%eax
c0100343:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100347:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010034a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010034e:	c7 04 24 0c 03 10 c0 	movl   $0xc010030c,(%esp)
c0100355:	e8 2c b2 00 00       	call   c010b586 <vprintfmt>
    return cnt;
c010035a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010035d:	c9                   	leave  
c010035e:	c3                   	ret    

c010035f <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c010035f:	55                   	push   %ebp
c0100360:	89 e5                	mov    %esp,%ebp
c0100362:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0100365:	8d 55 0c             	lea    0xc(%ebp),%edx
c0100368:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010036b:	89 10                	mov    %edx,(%eax)
    cnt = vcprintf(fmt, ap);
c010036d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100370:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100374:	8b 45 08             	mov    0x8(%ebp),%eax
c0100377:	89 04 24             	mov    %eax,(%esp)
c010037a:	e8 ad ff ff ff       	call   c010032c <vcprintf>
c010037f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0100382:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100385:	c9                   	leave  
c0100386:	c3                   	ret    

c0100387 <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c0100387:	55                   	push   %ebp
c0100388:	89 e5                	mov    %esp,%ebp
c010038a:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010038d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100390:	89 04 24             	mov    %eax,(%esp)
c0100393:	e8 00 14 00 00       	call   c0101798 <cons_putc>
}
c0100398:	c9                   	leave  
c0100399:	c3                   	ret    

c010039a <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c010039a:	55                   	push   %ebp
c010039b:	89 e5                	mov    %esp,%ebp
c010039d:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c01003a0:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c01003a7:	eb 13                	jmp    c01003bc <cputs+0x22>
        cputch(c, &cnt);
c01003a9:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003ad:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003b0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003b4:	89 04 24             	mov    %eax,(%esp)
c01003b7:	e8 50 ff ff ff       	call   c010030c <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01003bf:	0f b6 00             	movzbl (%eax),%eax
c01003c2:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003c5:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c9:	0f 95 c0             	setne  %al
c01003cc:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01003d0:	84 c0                	test   %al,%al
c01003d2:	75 d5                	jne    c01003a9 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003d4:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003db:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003e2:	e8 25 ff ff ff       	call   c010030c <cputch>
    return cnt;
c01003e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003ea:	c9                   	leave  
c01003eb:	c3                   	ret    

c01003ec <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003ec:	55                   	push   %ebp
c01003ed:	89 e5                	mov    %esp,%ebp
c01003ef:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003f2:	e8 dd 13 00 00       	call   c01017d4 <cons_getc>
c01003f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003fe:	74 f2                	je     c01003f2 <getchar+0x6>
        /* do nothing */;
    return c;
c0100400:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100403:	c9                   	leave  
c0100404:	c3                   	ret    
c0100405:	00 00                	add    %al,(%eax)
	...

c0100408 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100408:	55                   	push   %ebp
c0100409:	89 e5                	mov    %esp,%ebp
c010040b:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c010040e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100411:	8b 00                	mov    (%eax),%eax
c0100413:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0100416:	8b 45 10             	mov    0x10(%ebp),%eax
c0100419:	8b 00                	mov    (%eax),%eax
c010041b:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010041e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c0100425:	e9 c6 00 00 00       	jmp    c01004f0 <stab_binsearch+0xe8>
        int true_m = (l + r) / 2, m = true_m;
c010042a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010042d:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100430:	01 d0                	add    %edx,%eax
c0100432:	89 c2                	mov    %eax,%edx
c0100434:	c1 ea 1f             	shr    $0x1f,%edx
c0100437:	01 d0                	add    %edx,%eax
c0100439:	d1 f8                	sar    %eax
c010043b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010043e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100441:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100444:	eb 04                	jmp    c010044a <stab_binsearch+0x42>
            m --;
c0100446:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010044a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010044d:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100450:	7c 1b                	jl     c010046d <stab_binsearch+0x65>
c0100452:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100455:	89 d0                	mov    %edx,%eax
c0100457:	01 c0                	add    %eax,%eax
c0100459:	01 d0                	add    %edx,%eax
c010045b:	c1 e0 02             	shl    $0x2,%eax
c010045e:	03 45 08             	add    0x8(%ebp),%eax
c0100461:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100465:	0f b6 c0             	movzbl %al,%eax
c0100468:	3b 45 14             	cmp    0x14(%ebp),%eax
c010046b:	75 d9                	jne    c0100446 <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c010046d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100470:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100473:	7d 0b                	jge    c0100480 <stab_binsearch+0x78>
            l = true_m + 1;
c0100475:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100478:	83 c0 01             	add    $0x1,%eax
c010047b:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c010047e:	eb 70                	jmp    c01004f0 <stab_binsearch+0xe8>
        }

        // actual binary search
        any_matches = 1;
c0100480:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c0100487:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010048a:	89 d0                	mov    %edx,%eax
c010048c:	01 c0                	add    %eax,%eax
c010048e:	01 d0                	add    %edx,%eax
c0100490:	c1 e0 02             	shl    $0x2,%eax
c0100493:	03 45 08             	add    0x8(%ebp),%eax
c0100496:	8b 40 08             	mov    0x8(%eax),%eax
c0100499:	3b 45 18             	cmp    0x18(%ebp),%eax
c010049c:	73 13                	jae    c01004b1 <stab_binsearch+0xa9>
            *region_left = m;
c010049e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004a1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004a4:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c01004a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004a9:	83 c0 01             	add    $0x1,%eax
c01004ac:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004af:	eb 3f                	jmp    c01004f0 <stab_binsearch+0xe8>
        } else if (stabs[m].n_value > addr) {
c01004b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004b4:	89 d0                	mov    %edx,%eax
c01004b6:	01 c0                	add    %eax,%eax
c01004b8:	01 d0                	add    %edx,%eax
c01004ba:	c1 e0 02             	shl    $0x2,%eax
c01004bd:	03 45 08             	add    0x8(%ebp),%eax
c01004c0:	8b 40 08             	mov    0x8(%eax),%eax
c01004c3:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004c6:	76 16                	jbe    c01004de <stab_binsearch+0xd6>
            *region_right = m - 1;
c01004c8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004cb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004ce:	8b 45 10             	mov    0x10(%ebp),%eax
c01004d1:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004d3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004d6:	83 e8 01             	sub    $0x1,%eax
c01004d9:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004dc:	eb 12                	jmp    c01004f0 <stab_binsearch+0xe8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004e1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004e4:	89 10                	mov    %edx,(%eax)
            l = m;
c01004e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e9:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004ec:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004f0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004f3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004f6:	0f 8e 2e ff ff ff    	jle    c010042a <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004fc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100500:	75 0f                	jne    c0100511 <stab_binsearch+0x109>
        *region_right = *region_left - 1;
c0100502:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100505:	8b 00                	mov    (%eax),%eax
c0100507:	8d 50 ff             	lea    -0x1(%eax),%edx
c010050a:	8b 45 10             	mov    0x10(%ebp),%eax
c010050d:	89 10                	mov    %edx,(%eax)
c010050f:	eb 3b                	jmp    c010054c <stab_binsearch+0x144>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100511:	8b 45 10             	mov    0x10(%ebp),%eax
c0100514:	8b 00                	mov    (%eax),%eax
c0100516:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100519:	eb 04                	jmp    c010051f <stab_binsearch+0x117>
c010051b:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c010051f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100522:	8b 00                	mov    (%eax),%eax
c0100524:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100527:	7d 1b                	jge    c0100544 <stab_binsearch+0x13c>
c0100529:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010052c:	89 d0                	mov    %edx,%eax
c010052e:	01 c0                	add    %eax,%eax
c0100530:	01 d0                	add    %edx,%eax
c0100532:	c1 e0 02             	shl    $0x2,%eax
c0100535:	03 45 08             	add    0x8(%ebp),%eax
c0100538:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010053c:	0f b6 c0             	movzbl %al,%eax
c010053f:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100542:	75 d7                	jne    c010051b <stab_binsearch+0x113>
            /* do nothing */;
        *region_left = l;
c0100544:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100547:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010054a:	89 10                	mov    %edx,(%eax)
    }
}
c010054c:	c9                   	leave  
c010054d:	c3                   	ret    

c010054e <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c010054e:	55                   	push   %ebp
c010054f:	89 e5                	mov    %esp,%ebp
c0100551:	53                   	push   %ebx
c0100552:	83 ec 54             	sub    $0x54,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c0100555:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100558:	c7 00 ec c0 10 c0    	movl   $0xc010c0ec,(%eax)
    info->eip_line = 0;
c010055e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100561:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100568:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056b:	c7 40 08 ec c0 10 c0 	movl   $0xc010c0ec,0x8(%eax)
    info->eip_fn_namelen = 9;
c0100572:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100575:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c010057c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010057f:	8b 55 08             	mov    0x8(%ebp),%edx
c0100582:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c0100585:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100588:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    // find the relevant set of stabs
    if (addr >= KERNBASE) {
c010058f:	81 7d 08 ff ff ff bf 	cmpl   $0xbfffffff,0x8(%ebp)
c0100596:	76 21                	jbe    c01005b9 <debuginfo_eip+0x6b>
        stabs = __STAB_BEGIN__;
c0100598:	c7 45 f4 20 e8 10 c0 	movl   $0xc010e820,-0xc(%ebp)
        stab_end = __STAB_END__;
c010059f:	c7 45 f0 40 30 12 c0 	movl   $0xc0123040,-0x10(%ebp)
        stabstr = __STABSTR_BEGIN__;
c01005a6:	c7 45 ec 41 30 12 c0 	movl   $0xc0123041,-0x14(%ebp)
        stabstr_end = __STABSTR_END__;
c01005ad:	c7 45 e8 31 7d 12 c0 	movl   $0xc0127d31,-0x18(%ebp)
c01005b4:	e9 ec 00 00 00       	jmp    c01006a5 <debuginfo_eip+0x157>
    }
    else {
        // user-program linker script, tools/user.ld puts the information about the
        // program's stabs (included __STAB_BEGIN__, __STAB_END__, __STABSTR_BEGIN__,
        // and __STABSTR_END__) in a structure located at virtual address USTAB.
        const struct userstabdata *usd = (struct userstabdata *)USTAB;
c01005b9:	c7 45 e4 00 00 20 00 	movl   $0x200000,-0x1c(%ebp)

        // make sure that debugger (current process) can access this memory
        struct mm_struct *mm;
        if (current == NULL || (mm = current->mm) == NULL) {
c01005c0:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c01005c5:	85 c0                	test   %eax,%eax
c01005c7:	74 11                	je     c01005da <debuginfo_eip+0x8c>
c01005c9:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c01005ce:	8b 40 18             	mov    0x18(%eax),%eax
c01005d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01005d4:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01005d8:	75 0a                	jne    c01005e4 <debuginfo_eip+0x96>
            return -1;
c01005da:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005df:	e9 7e 03 00 00       	jmp    c0100962 <debuginfo_eip+0x414>
        }
        if (!user_mem_check(mm, (uintptr_t)usd, sizeof(struct userstabdata), 0)) {
c01005e4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01005e7:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01005ee:	00 
c01005ef:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01005f6:	00 
c01005f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01005fb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01005fe:	89 04 24             	mov    %eax,(%esp)
c0100601:	e8 a3 8a 00 00       	call   c01090a9 <user_mem_check>
c0100606:	85 c0                	test   %eax,%eax
c0100608:	75 0a                	jne    c0100614 <debuginfo_eip+0xc6>
            return -1;
c010060a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010060f:	e9 4e 03 00 00       	jmp    c0100962 <debuginfo_eip+0x414>
        }

        stabs = usd->stabs;
c0100614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100617:	8b 00                	mov    (%eax),%eax
c0100619:	89 45 f4             	mov    %eax,-0xc(%ebp)
        stab_end = usd->stab_end;
c010061c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010061f:	8b 40 04             	mov    0x4(%eax),%eax
c0100622:	89 45 f0             	mov    %eax,-0x10(%ebp)
        stabstr = usd->stabstr;
c0100625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100628:	8b 40 08             	mov    0x8(%eax),%eax
c010062b:	89 45 ec             	mov    %eax,-0x14(%ebp)
        stabstr_end = usd->stabstr_end;
c010062e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100631:	8b 40 0c             	mov    0xc(%eax),%eax
c0100634:	89 45 e8             	mov    %eax,-0x18(%ebp)

        // make sure the STABS and string table memory is valid
        if (!user_mem_check(mm, (uintptr_t)stabs, (uintptr_t)stab_end - (uintptr_t)stabs, 0)) {
c0100637:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010063a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010063d:	29 c2                	sub    %eax,%edx
c010063f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100642:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0100649:	00 
c010064a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010064e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100652:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100655:	89 04 24             	mov    %eax,(%esp)
c0100658:	e8 4c 8a 00 00       	call   c01090a9 <user_mem_check>
c010065d:	85 c0                	test   %eax,%eax
c010065f:	75 0a                	jne    c010066b <debuginfo_eip+0x11d>
            return -1;
c0100661:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100666:	e9 f7 02 00 00       	jmp    c0100962 <debuginfo_eip+0x414>
        }
        if (!user_mem_check(mm, (uintptr_t)stabstr, stabstr_end - stabstr, 0)) {
c010066b:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010066e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100671:	89 d1                	mov    %edx,%ecx
c0100673:	29 c1                	sub    %eax,%ecx
c0100675:	89 c8                	mov    %ecx,%eax
c0100677:	89 c2                	mov    %eax,%edx
c0100679:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010067c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0100683:	00 
c0100684:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100688:	89 44 24 04          	mov    %eax,0x4(%esp)
c010068c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010068f:	89 04 24             	mov    %eax,(%esp)
c0100692:	e8 12 8a 00 00       	call   c01090a9 <user_mem_check>
c0100697:	85 c0                	test   %eax,%eax
c0100699:	75 0a                	jne    c01006a5 <debuginfo_eip+0x157>
            return -1;
c010069b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006a0:	e9 bd 02 00 00       	jmp    c0100962 <debuginfo_eip+0x414>
        }
    }

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01006a5:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006a8:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01006ab:	76 0d                	jbe    c01006ba <debuginfo_eip+0x16c>
c01006ad:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01006b0:	83 e8 01             	sub    $0x1,%eax
c01006b3:	0f b6 00             	movzbl (%eax),%eax
c01006b6:	84 c0                	test   %al,%al
c01006b8:	74 0a                	je     c01006c4 <debuginfo_eip+0x176>
        return -1;
c01006ba:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01006bf:	e9 9e 02 00 00       	jmp    c0100962 <debuginfo_eip+0x414>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01006c4:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01006cb:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01006ce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01006d1:	89 d3                	mov    %edx,%ebx
c01006d3:	29 c3                	sub    %eax,%ebx
c01006d5:	89 d8                	mov    %ebx,%eax
c01006d7:	c1 f8 02             	sar    $0x2,%eax
c01006da:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01006e0:	83 e8 01             	sub    $0x1,%eax
c01006e3:	89 45 d8             	mov    %eax,-0x28(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01006e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01006e9:	89 44 24 10          	mov    %eax,0x10(%esp)
c01006ed:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01006f4:	00 
c01006f5:	8d 45 d8             	lea    -0x28(%ebp),%eax
c01006f8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01006fc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01006ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100703:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100706:	89 04 24             	mov    %eax,(%esp)
c0100709:	e8 fa fc ff ff       	call   c0100408 <stab_binsearch>
    if (lfile == 0)
c010070e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100711:	85 c0                	test   %eax,%eax
c0100713:	75 0a                	jne    c010071f <debuginfo_eip+0x1d1>
        return -1;
c0100715:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010071a:	e9 43 02 00 00       	jmp    c0100962 <debuginfo_eip+0x414>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010071f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100722:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100725:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100728:	89 45 d0             	mov    %eax,-0x30(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c010072b:	8b 45 08             	mov    0x8(%ebp),%eax
c010072e:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100732:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100739:	00 
c010073a:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010073d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100741:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100744:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100748:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010074b:	89 04 24             	mov    %eax,(%esp)
c010074e:	e8 b5 fc ff ff       	call   c0100408 <stab_binsearch>

    if (lfun <= rfun) {
c0100753:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100756:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100759:	39 c2                	cmp    %eax,%edx
c010075b:	7f 72                	jg     c01007cf <debuginfo_eip+0x281>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010075d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100760:	89 c2                	mov    %eax,%edx
c0100762:	89 d0                	mov    %edx,%eax
c0100764:	01 c0                	add    %eax,%eax
c0100766:	01 d0                	add    %edx,%eax
c0100768:	c1 e0 02             	shl    $0x2,%eax
c010076b:	03 45 f4             	add    -0xc(%ebp),%eax
c010076e:	8b 10                	mov    (%eax),%edx
c0100770:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100773:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100776:	89 cb                	mov    %ecx,%ebx
c0100778:	29 c3                	sub    %eax,%ebx
c010077a:	89 d8                	mov    %ebx,%eax
c010077c:	39 c2                	cmp    %eax,%edx
c010077e:	73 1e                	jae    c010079e <debuginfo_eip+0x250>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100780:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100783:	89 c2                	mov    %eax,%edx
c0100785:	89 d0                	mov    %edx,%eax
c0100787:	01 c0                	add    %eax,%eax
c0100789:	01 d0                	add    %edx,%eax
c010078b:	c1 e0 02             	shl    $0x2,%eax
c010078e:	03 45 f4             	add    -0xc(%ebp),%eax
c0100791:	8b 00                	mov    (%eax),%eax
c0100793:	89 c2                	mov    %eax,%edx
c0100795:	03 55 ec             	add    -0x14(%ebp),%edx
c0100798:	8b 45 0c             	mov    0xc(%ebp),%eax
c010079b:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010079e:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007a1:	89 c2                	mov    %eax,%edx
c01007a3:	89 d0                	mov    %edx,%eax
c01007a5:	01 c0                	add    %eax,%eax
c01007a7:	01 d0                	add    %edx,%eax
c01007a9:	c1 e0 02             	shl    $0x2,%eax
c01007ac:	03 45 f4             	add    -0xc(%ebp),%eax
c01007af:	8b 50 08             	mov    0x8(%eax),%edx
c01007b2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007b5:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01007b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007bb:	8b 40 10             	mov    0x10(%eax),%eax
c01007be:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01007c1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007c4:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfun;
c01007c7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01007ca:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01007cd:	eb 15                	jmp    c01007e4 <debuginfo_eip+0x296>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01007cf:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007d2:	8b 55 08             	mov    0x8(%ebp),%edx
c01007d5:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01007d8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01007db:	89 45 cc             	mov    %eax,-0x34(%ebp)
        rline = rfile;
c01007de:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01007e1:	89 45 c8             	mov    %eax,-0x38(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01007e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007e7:	8b 40 08             	mov    0x8(%eax),%eax
c01007ea:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01007f1:	00 
c01007f2:	89 04 24             	mov    %eax,(%esp)
c01007f5:	e8 05 b5 00 00       	call   c010bcff <strfind>
c01007fa:	89 c2                	mov    %eax,%edx
c01007fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01007ff:	8b 40 08             	mov    0x8(%eax),%eax
c0100802:	29 c2                	sub    %eax,%edx
c0100804:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100807:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c010080a:	8b 45 08             	mov    0x8(%ebp),%eax
c010080d:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100811:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100818:	00 
c0100819:	8d 45 c8             	lea    -0x38(%ebp),%eax
c010081c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100820:	8d 45 cc             	lea    -0x34(%ebp),%eax
c0100823:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100827:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010082a:	89 04 24             	mov    %eax,(%esp)
c010082d:	e8 d6 fb ff ff       	call   c0100408 <stab_binsearch>
    if (lline <= rline) {
c0100832:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100835:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0100838:	39 c2                	cmp    %eax,%edx
c010083a:	7f 20                	jg     c010085c <debuginfo_eip+0x30e>
        info->eip_line = stabs[rline].n_desc;
c010083c:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010083f:	89 c2                	mov    %eax,%edx
c0100841:	89 d0                	mov    %edx,%eax
c0100843:	01 c0                	add    %eax,%eax
c0100845:	01 d0                	add    %edx,%eax
c0100847:	c1 e0 02             	shl    $0x2,%eax
c010084a:	03 45 f4             	add    -0xc(%ebp),%eax
c010084d:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100851:	0f b7 d0             	movzwl %ax,%edx
c0100854:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100857:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010085a:	eb 13                	jmp    c010086f <debuginfo_eip+0x321>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010085c:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100861:	e9 fc 00 00 00       	jmp    c0100962 <debuginfo_eip+0x414>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100866:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100869:	83 e8 01             	sub    $0x1,%eax
c010086c:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010086f:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0100872:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100875:	39 c2                	cmp    %eax,%edx
c0100877:	7c 4a                	jl     c01008c3 <debuginfo_eip+0x375>
           && stabs[lline].n_type != N_SOL
c0100879:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010087c:	89 c2                	mov    %eax,%edx
c010087e:	89 d0                	mov    %edx,%eax
c0100880:	01 c0                	add    %eax,%eax
c0100882:	01 d0                	add    %edx,%eax
c0100884:	c1 e0 02             	shl    $0x2,%eax
c0100887:	03 45 f4             	add    -0xc(%ebp),%eax
c010088a:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010088e:	3c 84                	cmp    $0x84,%al
c0100890:	74 31                	je     c01008c3 <debuginfo_eip+0x375>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100892:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100895:	89 c2                	mov    %eax,%edx
c0100897:	89 d0                	mov    %edx,%eax
c0100899:	01 c0                	add    %eax,%eax
c010089b:	01 d0                	add    %edx,%eax
c010089d:	c1 e0 02             	shl    $0x2,%eax
c01008a0:	03 45 f4             	add    -0xc(%ebp),%eax
c01008a3:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01008a7:	3c 64                	cmp    $0x64,%al
c01008a9:	75 bb                	jne    c0100866 <debuginfo_eip+0x318>
c01008ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008ae:	89 c2                	mov    %eax,%edx
c01008b0:	89 d0                	mov    %edx,%eax
c01008b2:	01 c0                	add    %eax,%eax
c01008b4:	01 d0                	add    %edx,%eax
c01008b6:	c1 e0 02             	shl    $0x2,%eax
c01008b9:	03 45 f4             	add    -0xc(%ebp),%eax
c01008bc:	8b 40 08             	mov    0x8(%eax),%eax
c01008bf:	85 c0                	test   %eax,%eax
c01008c1:	74 a3                	je     c0100866 <debuginfo_eip+0x318>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01008c3:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01008c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01008c9:	39 c2                	cmp    %eax,%edx
c01008cb:	7c 40                	jl     c010090d <debuginfo_eip+0x3bf>
c01008cd:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008d0:	89 c2                	mov    %eax,%edx
c01008d2:	89 d0                	mov    %edx,%eax
c01008d4:	01 c0                	add    %eax,%eax
c01008d6:	01 d0                	add    %edx,%eax
c01008d8:	c1 e0 02             	shl    $0x2,%eax
c01008db:	03 45 f4             	add    -0xc(%ebp),%eax
c01008de:	8b 10                	mov    (%eax),%edx
c01008e0:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01008e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01008e6:	89 cb                	mov    %ecx,%ebx
c01008e8:	29 c3                	sub    %eax,%ebx
c01008ea:	89 d8                	mov    %ebx,%eax
c01008ec:	39 c2                	cmp    %eax,%edx
c01008ee:	73 1d                	jae    c010090d <debuginfo_eip+0x3bf>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01008f0:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01008f3:	89 c2                	mov    %eax,%edx
c01008f5:	89 d0                	mov    %edx,%eax
c01008f7:	01 c0                	add    %eax,%eax
c01008f9:	01 d0                	add    %edx,%eax
c01008fb:	c1 e0 02             	shl    $0x2,%eax
c01008fe:	03 45 f4             	add    -0xc(%ebp),%eax
c0100901:	8b 00                	mov    (%eax),%eax
c0100903:	89 c2                	mov    %eax,%edx
c0100905:	03 55 ec             	add    -0x14(%ebp),%edx
c0100908:	8b 45 0c             	mov    0xc(%ebp),%eax
c010090b:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010090d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100910:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100913:	39 c2                	cmp    %eax,%edx
c0100915:	7d 46                	jge    c010095d <debuginfo_eip+0x40f>
        for (lline = lfun + 1;
c0100917:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010091a:	83 c0 01             	add    $0x1,%eax
c010091d:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0100920:	eb 18                	jmp    c010093a <debuginfo_eip+0x3ec>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100922:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100925:	8b 40 14             	mov    0x14(%eax),%eax
c0100928:	8d 50 01             	lea    0x1(%eax),%edx
c010092b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010092e:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100931:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100934:	83 c0 01             	add    $0x1,%eax
c0100937:	89 45 cc             	mov    %eax,-0x34(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010093a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010093d:	8b 45 d0             	mov    -0x30(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100940:	39 c2                	cmp    %eax,%edx
c0100942:	7d 19                	jge    c010095d <debuginfo_eip+0x40f>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100944:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0100947:	89 c2                	mov    %eax,%edx
c0100949:	89 d0                	mov    %edx,%eax
c010094b:	01 c0                	add    %eax,%eax
c010094d:	01 d0                	add    %edx,%eax
c010094f:	c1 e0 02             	shl    $0x2,%eax
c0100952:	03 45 f4             	add    -0xc(%ebp),%eax
c0100955:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100959:	3c a0                	cmp    $0xa0,%al
c010095b:	74 c5                	je     c0100922 <debuginfo_eip+0x3d4>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c010095d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100962:	83 c4 54             	add    $0x54,%esp
c0100965:	5b                   	pop    %ebx
c0100966:	5d                   	pop    %ebp
c0100967:	c3                   	ret    

c0100968 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100968:	55                   	push   %ebp
c0100969:	89 e5                	mov    %esp,%ebp
c010096b:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010096e:	c7 04 24 f6 c0 10 c0 	movl   $0xc010c0f6,(%esp)
c0100975:	e8 e5 f9 ff ff       	call   c010035f <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c010097a:	c7 44 24 04 2c 00 10 	movl   $0xc010002c,0x4(%esp)
c0100981:	c0 
c0100982:	c7 04 24 0f c1 10 c0 	movl   $0xc010c10f,(%esp)
c0100989:	e8 d1 f9 ff ff       	call   c010035f <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010098e:	c7 44 24 04 3f c0 10 	movl   $0xc010c03f,0x4(%esp)
c0100995:	c0 
c0100996:	c7 04 24 27 c1 10 c0 	movl   $0xc010c127,(%esp)
c010099d:	e8 bd f9 ff ff       	call   c010035f <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01009a2:	c7 44 24 04 3a be 19 	movl   $0xc019be3a,0x4(%esp)
c01009a9:	c0 
c01009aa:	c7 04 24 3f c1 10 c0 	movl   $0xc010c13f,(%esp)
c01009b1:	e8 a9 f9 ff ff       	call   c010035f <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01009b6:	c7 44 24 04 b8 ef 19 	movl   $0xc019efb8,0x4(%esp)
c01009bd:	c0 
c01009be:	c7 04 24 57 c1 10 c0 	movl   $0xc010c157,(%esp)
c01009c5:	e8 95 f9 ff ff       	call   c010035f <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01009ca:	b8 b8 ef 19 c0       	mov    $0xc019efb8,%eax
c01009cf:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009d5:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c01009da:	89 d1                	mov    %edx,%ecx
c01009dc:	29 c1                	sub    %eax,%ecx
c01009de:	89 c8                	mov    %ecx,%eax
c01009e0:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01009e6:	85 c0                	test   %eax,%eax
c01009e8:	0f 48 c2             	cmovs  %edx,%eax
c01009eb:	c1 f8 0a             	sar    $0xa,%eax
c01009ee:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009f2:	c7 04 24 70 c1 10 c0 	movl   $0xc010c170,(%esp)
c01009f9:	e8 61 f9 ff ff       	call   c010035f <cprintf>
}
c01009fe:	c9                   	leave  
c01009ff:	c3                   	ret    

c0100a00 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100a00:	55                   	push   %ebp
c0100a01:	89 e5                	mov    %esp,%ebp
c0100a03:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100a09:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100a0c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a10:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a13:	89 04 24             	mov    %eax,(%esp)
c0100a16:	e8 33 fb ff ff       	call   c010054e <debuginfo_eip>
c0100a1b:	85 c0                	test   %eax,%eax
c0100a1d:	74 15                	je     c0100a34 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a22:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a26:	c7 04 24 9a c1 10 c0 	movl   $0xc010c19a,(%esp)
c0100a2d:	e8 2d f9 ff ff       	call   c010035f <cprintf>
c0100a32:	eb 69                	jmp    c0100a9d <print_debuginfo+0x9d>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a34:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100a3b:	eb 1a                	jmp    c0100a57 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
c0100a3d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100a40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a43:	01 d0                	add    %edx,%eax
c0100a45:	0f b6 10             	movzbl (%eax),%edx
c0100a48:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c0100a4e:	03 45 f4             	add    -0xc(%ebp),%eax
c0100a51:	88 10                	mov    %dl,(%eax)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100a53:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100a57:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a5a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100a5d:	7f de                	jg     c0100a3d <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100a5f:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c0100a65:	03 45 f4             	add    -0xc(%ebp),%eax
c0100a68:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100a6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a6e:	8b 55 08             	mov    0x8(%ebp),%edx
c0100a71:	89 d1                	mov    %edx,%ecx
c0100a73:	29 c1                	sub    %eax,%ecx
c0100a75:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100a78:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100a7b:	89 4c 24 10          	mov    %ecx,0x10(%esp)
                fnname, eip - info.eip_fn_addr);
c0100a7f:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100a85:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100a89:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a91:	c7 04 24 b6 c1 10 c0 	movl   $0xc010c1b6,(%esp)
c0100a98:	e8 c2 f8 ff ff       	call   c010035f <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c0100a9d:	c9                   	leave  
c0100a9e:	c3                   	ret    

c0100a9f <read_eip>:

static __noinline uint32_t
read_eip(void) {
c0100a9f:	55                   	push   %ebp
c0100aa0:	89 e5                	mov    %esp,%ebp
c0100aa2:	53                   	push   %ebx
c0100aa3:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c0100aa6:	8b 5d 04             	mov    0x4(%ebp),%ebx
c0100aa9:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return eip;
c0100aac:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0100aaf:	83 c4 10             	add    $0x10,%esp
c0100ab2:	5b                   	pop    %ebx
c0100ab3:	5d                   	pop    %ebp
c0100ab4:	c3                   	ret    

c0100ab5 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c0100ab5:	55                   	push   %ebp
c0100ab6:	89 e5                	mov    %esp,%ebp
c0100ab8:	53                   	push   %ebx
c0100ab9:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c0100abc:	89 eb                	mov    %ebp,%ebx
c0100abe:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    return ebp;
c0100ac1:	8b 45 e0             	mov    -0x20(%ebp),%eax
     *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
     *    (3.5) popup a calling stackframe
     *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
     *                   the calling funciton's ebp = ss:[ebp]
     */
    uint32_t ebp = read_ebp();
c0100ac4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t eip = read_eip();
c0100ac7:	e8 d3 ff ff ff       	call   c0100a9f <read_eip>
c0100acc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    int i;
    int j;
    uint32_t *args;
    for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
c0100acf:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0100ad6:	e9 82 00 00 00       	jmp    c0100b5d <print_stackframe+0xa8>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c0100adb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100ade:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ae9:	c7 04 24 c8 c1 10 c0 	movl   $0xc010c1c8,(%esp)
c0100af0:	e8 6a f8 ff ff       	call   c010035f <cprintf>
        args = (uint32_t *)ebp + 2;
c0100af5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100af8:	83 c0 08             	add    $0x8,%eax
c0100afb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for(j = 0; j < 4; j++)
c0100afe:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100b05:	eb 1f                	jmp    c0100b26 <print_stackframe+0x71>
            cprintf("0x%08x ",args[j]);
c0100b07:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100b0a:	c1 e0 02             	shl    $0x2,%eax
c0100b0d:	03 45 e4             	add    -0x1c(%ebp),%eax
c0100b10:	8b 00                	mov    (%eax),%eax
c0100b12:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b16:	c7 04 24 e4 c1 10 c0 	movl   $0xc010c1e4,(%esp)
c0100b1d:	e8 3d f8 ff ff       	call   c010035f <cprintf>
    int j;
    uint32_t *args;
    for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        args = (uint32_t *)ebp + 2;
        for(j = 0; j < 4; j++)
c0100b22:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100b26:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100b2a:	7e db                	jle    c0100b07 <print_stackframe+0x52>
            cprintf("0x%08x ",args[j]);
        cprintf("\n");
c0100b2c:	c7 04 24 ec c1 10 c0 	movl   $0xc010c1ec,(%esp)
c0100b33:	e8 27 f8 ff ff       	call   c010035f <cprintf>
        print_debuginfo(eip-1);
c0100b38:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b3b:	83 e8 01             	sub    $0x1,%eax
c0100b3e:	89 04 24             	mov    %eax,(%esp)
c0100b41:	e8 ba fe ff ff       	call   c0100a00 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100b46:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b49:	83 c0 04             	add    $0x4,%eax
c0100b4c:	8b 00                	mov    (%eax),%eax
c0100b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100b54:	8b 00                	mov    (%eax),%eax
c0100b56:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t ebp = read_ebp();
    uint32_t eip = read_eip();
    int i;
    int j;
    uint32_t *args;
    for(i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i++) {
c0100b59:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100b5d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100b61:	74 0a                	je     c0100b6d <print_stackframe+0xb8>
c0100b63:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100b67:	0f 8e 6e ff ff ff    	jle    c0100adb <print_stackframe+0x26>
        cprintf("\n");
        print_debuginfo(eip-1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100b6d:	83 c4 34             	add    $0x34,%esp
c0100b70:	5b                   	pop    %ebx
c0100b71:	5d                   	pop    %ebp
c0100b72:	c3                   	ret    
	...

c0100b74 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100b74:	55                   	push   %ebp
c0100b75:	89 e5                	mov    %esp,%ebp
c0100b77:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100b7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b81:	eb 0d                	jmp    c0100b90 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
c0100b83:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b84:	eb 0a                	jmp    c0100b90 <parse+0x1c>
            *buf ++ = '\0';
c0100b86:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b89:	c6 00 00             	movb   $0x0,(%eax)
c0100b8c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100b90:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b93:	0f b6 00             	movzbl (%eax),%eax
c0100b96:	84 c0                	test   %al,%al
c0100b98:	74 1d                	je     c0100bb7 <parse+0x43>
c0100b9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b9d:	0f b6 00             	movzbl (%eax),%eax
c0100ba0:	0f be c0             	movsbl %al,%eax
c0100ba3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ba7:	c7 04 24 70 c2 10 c0 	movl   $0xc010c270,(%esp)
c0100bae:	e8 19 b1 00 00       	call   c010bccc <strchr>
c0100bb3:	85 c0                	test   %eax,%eax
c0100bb5:	75 cf                	jne    c0100b86 <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100bb7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bba:	0f b6 00             	movzbl (%eax),%eax
c0100bbd:	84 c0                	test   %al,%al
c0100bbf:	74 5e                	je     c0100c1f <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100bc1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100bc5:	75 14                	jne    c0100bdb <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100bc7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100bce:	00 
c0100bcf:	c7 04 24 75 c2 10 c0 	movl   $0xc010c275,(%esp)
c0100bd6:	e8 84 f7 ff ff       	call   c010035f <cprintf>
        }
        argv[argc ++] = buf;
c0100bdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bde:	c1 e0 02             	shl    $0x2,%eax
c0100be1:	03 45 0c             	add    0xc(%ebp),%eax
c0100be4:	8b 55 08             	mov    0x8(%ebp),%edx
c0100be7:	89 10                	mov    %edx,(%eax)
c0100be9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bed:	eb 04                	jmp    c0100bf3 <parse+0x7f>
            buf ++;
c0100bef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bf6:	0f b6 00             	movzbl (%eax),%eax
c0100bf9:	84 c0                	test   %al,%al
c0100bfb:	74 86                	je     c0100b83 <parse+0xf>
c0100bfd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c00:	0f b6 00             	movzbl (%eax),%eax
c0100c03:	0f be c0             	movsbl %al,%eax
c0100c06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c0a:	c7 04 24 70 c2 10 c0 	movl   $0xc010c270,(%esp)
c0100c11:	e8 b6 b0 00 00       	call   c010bccc <strchr>
c0100c16:	85 c0                	test   %eax,%eax
c0100c18:	74 d5                	je     c0100bef <parse+0x7b>
            buf ++;
        }
    }
c0100c1a:	e9 64 ff ff ff       	jmp    c0100b83 <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100c1f:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100c20:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100c23:	c9                   	leave  
c0100c24:	c3                   	ret    

c0100c25 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100c25:	55                   	push   %ebp
c0100c26:	89 e5                	mov    %esp,%ebp
c0100c28:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100c2b:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100c2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c35:	89 04 24             	mov    %eax,(%esp)
c0100c38:	e8 37 ff ff ff       	call   c0100b74 <parse>
c0100c3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100c40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100c44:	75 0a                	jne    c0100c50 <runcmd+0x2b>
        return 0;
c0100c46:	b8 00 00 00 00       	mov    $0x0,%eax
c0100c4b:	e9 85 00 00 00       	jmp    c0100cd5 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c57:	eb 5c                	jmp    c0100cb5 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100c59:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100c5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5f:	89 d0                	mov    %edx,%eax
c0100c61:	01 c0                	add    %eax,%eax
c0100c63:	01 d0                	add    %edx,%eax
c0100c65:	c1 e0 02             	shl    $0x2,%eax
c0100c68:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100c6d:	8b 00                	mov    (%eax),%eax
c0100c6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100c73:	89 04 24             	mov    %eax,(%esp)
c0100c76:	e8 ac af 00 00       	call   c010bc27 <strcmp>
c0100c7b:	85 c0                	test   %eax,%eax
c0100c7d:	75 32                	jne    c0100cb1 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100c7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c82:	89 d0                	mov    %edx,%eax
c0100c84:	01 c0                	add    %eax,%eax
c0100c86:	01 d0                	add    %edx,%eax
c0100c88:	c1 e0 02             	shl    $0x2,%eax
c0100c8b:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100c90:	8b 50 08             	mov    0x8(%eax),%edx
c0100c93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100c96:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0100c99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100c9c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ca0:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100ca3:	83 c0 04             	add    $0x4,%eax
c0100ca6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100caa:	89 0c 24             	mov    %ecx,(%esp)
c0100cad:	ff d2                	call   *%edx
c0100caf:	eb 24                	jmp    c0100cd5 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100cb1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100cb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cb8:	83 f8 02             	cmp    $0x2,%eax
c0100cbb:	76 9c                	jbe    c0100c59 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100cbd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100cc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cc4:	c7 04 24 93 c2 10 c0 	movl   $0xc010c293,(%esp)
c0100ccb:	e8 8f f6 ff ff       	call   c010035f <cprintf>
    return 0;
c0100cd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cd5:	c9                   	leave  
c0100cd6:	c3                   	ret    

c0100cd7 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100cd7:	55                   	push   %ebp
c0100cd8:	89 e5                	mov    %esp,%ebp
c0100cda:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100cdd:	c7 04 24 ac c2 10 c0 	movl   $0xc010c2ac,(%esp)
c0100ce4:	e8 76 f6 ff ff       	call   c010035f <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100ce9:	c7 04 24 d4 c2 10 c0 	movl   $0xc010c2d4,(%esp)
c0100cf0:	e8 6a f6 ff ff       	call   c010035f <cprintf>

    if (tf != NULL) {
c0100cf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100cf9:	74 0e                	je     c0100d09 <kmonitor+0x32>
        print_trapframe(tf);
c0100cfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100cfe:	89 04 24             	mov    %eax,(%esp)
c0100d01:	e8 a4 17 00 00       	call   c01024aa <print_trapframe>
c0100d06:	eb 01                	jmp    c0100d09 <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
c0100d08:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100d09:	c7 04 24 f9 c2 10 c0 	movl   $0xc010c2f9,(%esp)
c0100d10:	e8 3b f5 ff ff       	call   c0100250 <readline>
c0100d15:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100d18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100d1c:	74 ea                	je     c0100d08 <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
c0100d1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d28:	89 04 24             	mov    %eax,(%esp)
c0100d2b:	e8 f5 fe ff ff       	call   c0100c25 <runcmd>
c0100d30:	85 c0                	test   %eax,%eax
c0100d32:	79 d4                	jns    c0100d08 <kmonitor+0x31>
                break;
c0100d34:	90                   	nop
            }
        }
    }
}
c0100d35:	c9                   	leave  
c0100d36:	c3                   	ret    

c0100d37 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100d37:	55                   	push   %ebp
c0100d38:	89 e5                	mov    %esp,%ebp
c0100d3a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100d44:	eb 3f                	jmp    c0100d85 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100d46:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d49:	89 d0                	mov    %edx,%eax
c0100d4b:	01 c0                	add    %eax,%eax
c0100d4d:	01 d0                	add    %edx,%eax
c0100d4f:	c1 e0 02             	shl    $0x2,%eax
c0100d52:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d57:	8b 48 04             	mov    0x4(%eax),%ecx
c0100d5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100d5d:	89 d0                	mov    %edx,%eax
c0100d5f:	01 c0                	add    %eax,%eax
c0100d61:	01 d0                	add    %edx,%eax
c0100d63:	c1 e0 02             	shl    $0x2,%eax
c0100d66:	05 20 a0 12 c0       	add    $0xc012a020,%eax
c0100d6b:	8b 00                	mov    (%eax),%eax
c0100d6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100d71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d75:	c7 04 24 fd c2 10 c0 	movl   $0xc010c2fd,(%esp)
c0100d7c:	e8 de f5 ff ff       	call   c010035f <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100d81:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100d85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d88:	83 f8 02             	cmp    $0x2,%eax
c0100d8b:	76 b9                	jbe    c0100d46 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100d8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100d92:	c9                   	leave  
c0100d93:	c3                   	ret    

c0100d94 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100d94:	55                   	push   %ebp
c0100d95:	89 e5                	mov    %esp,%ebp
c0100d97:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100d9a:	e8 c9 fb ff ff       	call   c0100968 <print_kerninfo>
    return 0;
c0100d9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100da4:	c9                   	leave  
c0100da5:	c3                   	ret    

c0100da6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100da6:	55                   	push   %ebp
c0100da7:	89 e5                	mov    %esp,%ebp
c0100da9:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100dac:	e8 04 fd ff ff       	call   c0100ab5 <print_stackframe>
    return 0;
c0100db1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100db6:	c9                   	leave  
c0100db7:	c3                   	ret    

c0100db8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100db8:	55                   	push   %ebp
c0100db9:	89 e5                	mov    %esp,%ebp
c0100dbb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100dbe:	a1 60 c2 19 c0       	mov    0xc019c260,%eax
c0100dc3:	85 c0                	test   %eax,%eax
c0100dc5:	75 4c                	jne    c0100e13 <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
c0100dc7:	c7 05 60 c2 19 c0 01 	movl   $0x1,0xc019c260
c0100dce:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100dd1:	8d 55 14             	lea    0x14(%ebp),%edx
c0100dd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100dd7:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100dd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ddc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100de0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100de3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100de7:	c7 04 24 06 c3 10 c0 	movl   $0xc010c306,(%esp)
c0100dee:	e8 6c f5 ff ff       	call   c010035f <cprintf>
    vcprintf(fmt, ap);
c0100df3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100df6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100dfa:	8b 45 10             	mov    0x10(%ebp),%eax
c0100dfd:	89 04 24             	mov    %eax,(%esp)
c0100e00:	e8 27 f5 ff ff       	call   c010032c <vcprintf>
    cprintf("\n");
c0100e05:	c7 04 24 22 c3 10 c0 	movl   $0xc010c322,(%esp)
c0100e0c:	e8 4e f5 ff ff       	call   c010035f <cprintf>
c0100e11:	eb 01                	jmp    c0100e14 <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100e13:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100e14:	e8 cd 12 00 00       	call   c01020e6 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100e19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100e20:	e8 b2 fe ff ff       	call   c0100cd7 <kmonitor>
    }
c0100e25:	eb f2                	jmp    c0100e19 <__panic+0x61>

c0100e27 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100e27:	55                   	push   %ebp
c0100e28:	89 e5                	mov    %esp,%ebp
c0100e2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100e2d:	8d 55 14             	lea    0x14(%ebp),%edx
c0100e30:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100e33:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100e35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100e38:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100e3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100e3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e43:	c7 04 24 24 c3 10 c0 	movl   $0xc010c324,(%esp)
c0100e4a:	e8 10 f5 ff ff       	call   c010035f <cprintf>
    vcprintf(fmt, ap);
c0100e4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100e52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100e56:	8b 45 10             	mov    0x10(%ebp),%eax
c0100e59:	89 04 24             	mov    %eax,(%esp)
c0100e5c:	e8 cb f4 ff ff       	call   c010032c <vcprintf>
    cprintf("\n");
c0100e61:	c7 04 24 22 c3 10 c0 	movl   $0xc010c322,(%esp)
c0100e68:	e8 f2 f4 ff ff       	call   c010035f <cprintf>
    va_end(ap);
}
c0100e6d:	c9                   	leave  
c0100e6e:	c3                   	ret    

c0100e6f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100e6f:	55                   	push   %ebp
c0100e70:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100e72:	a1 60 c2 19 c0       	mov    0xc019c260,%eax
}
c0100e77:	5d                   	pop    %ebp
c0100e78:	c3                   	ret    
c0100e79:	00 00                	add    %al,(%eax)
	...

c0100e7c <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100e7c:	55                   	push   %ebp
c0100e7d:	89 e5                	mov    %esp,%ebp
c0100e7f:	83 ec 28             	sub    $0x28,%esp
c0100e82:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100e88:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100e8c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100e90:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e94:	ee                   	out    %al,(%dx)
c0100e95:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100e9b:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100e9f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100ea3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100ea7:	ee                   	out    %al,(%dx)
c0100ea8:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100eae:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100eb2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100eb6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100eba:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100ebb:	c7 05 b4 ee 19 c0 00 	movl   $0x0,0xc019eeb4
c0100ec2:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100ec5:	c7 04 24 42 c3 10 c0 	movl   $0xc010c342,(%esp)
c0100ecc:	e8 8e f4 ff ff       	call   c010035f <cprintf>
    pic_enable(IRQ_TIMER);
c0100ed1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100ed8:	e8 67 12 00 00       	call   c0102144 <pic_enable>
}
c0100edd:	c9                   	leave  
c0100ede:	c3                   	ret    
	...

c0100ee0 <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0100ee0:	55                   	push   %ebp
c0100ee1:	89 e5                	mov    %esp,%ebp
c0100ee3:	53                   	push   %ebx
c0100ee4:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100ee7:	9c                   	pushf  
c0100ee8:	5b                   	pop    %ebx
c0100ee9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0100eec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100eef:	25 00 02 00 00       	and    $0x200,%eax
c0100ef4:	85 c0                	test   %eax,%eax
c0100ef6:	74 0c                	je     c0100f04 <__intr_save+0x24>
        intr_disable();
c0100ef8:	e8 e9 11 00 00       	call   c01020e6 <intr_disable>
        return 1;
c0100efd:	b8 01 00 00 00       	mov    $0x1,%eax
c0100f02:	eb 05                	jmp    c0100f09 <__intr_save+0x29>
    }
    return 0;
c0100f04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100f09:	83 c4 14             	add    $0x14,%esp
c0100f0c:	5b                   	pop    %ebx
c0100f0d:	5d                   	pop    %ebp
c0100f0e:	c3                   	ret    

c0100f0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100f0f:	55                   	push   %ebp
c0100f10:	89 e5                	mov    %esp,%ebp
c0100f12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100f15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100f19:	74 05                	je     c0100f20 <__intr_restore+0x11>
        intr_enable();
c0100f1b:	e8 c0 11 00 00       	call   c01020e0 <intr_enable>
    }
}
c0100f20:	c9                   	leave  
c0100f21:	c3                   	ret    

c0100f22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100f22:	55                   	push   %ebp
c0100f23:	89 e5                	mov    %esp,%ebp
c0100f25:	53                   	push   %ebx
c0100f26:	83 ec 14             	sub    $0x14,%esp
c0100f29:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f2f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100f33:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100f37:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f3b:	ec                   	in     (%dx),%al
c0100f3c:	89 c3                	mov    %eax,%ebx
c0100f3e:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
c0100f41:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f47:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100f4b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100f4f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f53:	ec                   	in     (%dx),%al
c0100f54:	89 c3                	mov    %eax,%ebx
c0100f56:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0100f59:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f5f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100f63:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100f67:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f6b:	ec                   	in     (%dx),%al
c0100f6c:	89 c3                	mov    %eax,%ebx
c0100f6e:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0100f71:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f77:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f7b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100f7f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f83:	ec                   	in     (%dx),%al
c0100f84:	89 c3                	mov    %eax,%ebx
c0100f86:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100f89:	83 c4 14             	add    $0x14,%esp
c0100f8c:	5b                   	pop    %ebx
c0100f8d:	5d                   	pop    %ebp
c0100f8e:	c3                   	ret    

c0100f8f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100f8f:	55                   	push   %ebp
c0100f90:	89 e5                	mov    %esp,%ebp
c0100f92:	53                   	push   %ebx
c0100f93:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100f96:	c7 45 f8 00 80 0b c0 	movl   $0xc00b8000,-0x8(%ebp)
    uint16_t was = *cp;
c0100f9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100fa0:	0f b7 00             	movzwl (%eax),%eax
c0100fa3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100fa7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100faa:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100faf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100fb2:	0f b7 00             	movzwl (%eax),%eax
c0100fb5:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100fb9:	74 12                	je     c0100fcd <cga_init+0x3e>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100fbb:	c7 45 f8 00 00 0b c0 	movl   $0xc00b0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
c0100fc2:	66 c7 05 86 c2 19 c0 	movw   $0x3b4,0xc019c286
c0100fc9:	b4 03 
c0100fcb:	eb 13                	jmp    c0100fe0 <cga_init+0x51>
    } else {
        *cp = was;
c0100fcd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100fd0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fd4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100fd7:	66 c7 05 86 c2 19 c0 	movw   $0x3d4,0xc019c286
c0100fde:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100fe0:	0f b7 05 86 c2 19 c0 	movzwl 0xc019c286,%eax
c0100fe7:	0f b7 c0             	movzwl %ax,%eax
c0100fea:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100fee:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ff2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ff6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100ffa:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100ffb:	0f b7 05 86 c2 19 c0 	movzwl 0xc019c286,%eax
c0101002:	83 c0 01             	add    $0x1,%eax
c0101005:	0f b7 c0             	movzwl %ax,%eax
c0101008:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010100c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101010:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101014:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101018:	ec                   	in     (%dx),%al
c0101019:	89 c3                	mov    %eax,%ebx
c010101b:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
c010101e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101022:	0f b6 c0             	movzbl %al,%eax
c0101025:	c1 e0 08             	shl    $0x8,%eax
c0101028:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
c010102b:	0f b7 05 86 c2 19 c0 	movzwl 0xc019c286,%eax
c0101032:	0f b7 c0             	movzwl %ax,%eax
c0101035:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0101039:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010103d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101041:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101045:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0101046:	0f b7 05 86 c2 19 c0 	movzwl 0xc019c286,%eax
c010104d:	83 c0 01             	add    $0x1,%eax
c0101050:	0f b7 c0             	movzwl %ax,%eax
c0101053:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101057:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010105b:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c010105f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101063:	ec                   	in     (%dx),%al
c0101064:	89 c3                	mov    %eax,%ebx
c0101066:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
c0101069:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010106d:	0f b6 c0             	movzbl %al,%eax
c0101070:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
c0101073:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101076:	a3 80 c2 19 c0       	mov    %eax,0xc019c280
    crt_pos = pos;
c010107b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010107e:	66 a3 84 c2 19 c0    	mov    %ax,0xc019c284
}
c0101084:	83 c4 24             	add    $0x24,%esp
c0101087:	5b                   	pop    %ebx
c0101088:	5d                   	pop    %ebp
c0101089:	c3                   	ret    

c010108a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c010108a:	55                   	push   %ebp
c010108b:	89 e5                	mov    %esp,%ebp
c010108d:	53                   	push   %ebx
c010108e:	83 ec 54             	sub    $0x54,%esp
c0101091:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0101097:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010109b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010109f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010a3:	ee                   	out    %al,(%dx)
c01010a4:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c01010aa:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c01010ae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010b2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010b6:	ee                   	out    %al,(%dx)
c01010b7:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c01010bd:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c01010c1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010c5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010c9:	ee                   	out    %al,(%dx)
c01010ca:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c01010d0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c01010d4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01010d8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01010dc:	ee                   	out    %al,(%dx)
c01010dd:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c01010e3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c01010e7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c01010eb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c01010ef:	ee                   	out    %al,(%dx)
c01010f0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c01010f6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c01010fa:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c01010fe:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101102:	ee                   	out    %al,(%dx)
c0101103:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101109:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c010110d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101111:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101115:	ee                   	out    %al,(%dx)
c0101116:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010111c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101120:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101124:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101128:	ec                   	in     (%dx),%al
c0101129:	89 c3                	mov    %eax,%ebx
c010112b:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
c010112e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101132:	3c ff                	cmp    $0xff,%al
c0101134:	0f 95 c0             	setne  %al
c0101137:	0f b6 c0             	movzbl %al,%eax
c010113a:	a3 88 c2 19 c0       	mov    %eax,0xc019c288
c010113f:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101145:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101149:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c010114d:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101151:	ec                   	in     (%dx),%al
c0101152:	89 c3                	mov    %eax,%ebx
c0101154:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
c0101157:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010115d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101161:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101165:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101169:	ec                   	in     (%dx),%al
c010116a:	89 c3                	mov    %eax,%ebx
c010116c:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010116f:	a1 88 c2 19 c0       	mov    0xc019c288,%eax
c0101174:	85 c0                	test   %eax,%eax
c0101176:	74 0c                	je     c0101184 <serial_init+0xfa>
        pic_enable(IRQ_COM1);
c0101178:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010117f:	e8 c0 0f 00 00       	call   c0102144 <pic_enable>
    }
}
c0101184:	83 c4 54             	add    $0x54,%esp
c0101187:	5b                   	pop    %ebx
c0101188:	5d                   	pop    %ebp
c0101189:	c3                   	ret    

c010118a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010118a:	55                   	push   %ebp
c010118b:	89 e5                	mov    %esp,%ebp
c010118d:	53                   	push   %ebx
c010118e:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101191:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101198:	eb 09                	jmp    c01011a3 <lpt_putc_sub+0x19>
        delay();
c010119a:	e8 83 fd ff ff       	call   c0100f22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010119f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c01011a3:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
c01011a9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01011ad:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c01011b1:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01011b5:	ec                   	in     (%dx),%al
c01011b6:	89 c3                	mov    %eax,%ebx
c01011b8:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c01011bb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01011bf:	84 c0                	test   %al,%al
c01011c1:	78 09                	js     c01011cc <lpt_putc_sub+0x42>
c01011c3:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c01011ca:	7e ce                	jle    c010119a <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
c01011cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01011cf:	0f b6 c0             	movzbl %al,%eax
c01011d2:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
c01011d8:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01011db:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01011df:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01011e3:	ee                   	out    %al,(%dx)
c01011e4:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01011ea:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
c01011ee:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01011f2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01011f6:	ee                   	out    %al,(%dx)
c01011f7:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
c01011fd:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
c0101201:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101205:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101209:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010120a:	83 c4 24             	add    $0x24,%esp
c010120d:	5b                   	pop    %ebx
c010120e:	5d                   	pop    %ebp
c010120f:	c3                   	ret    

c0101210 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101210:	55                   	push   %ebp
c0101211:	89 e5                	mov    %esp,%ebp
c0101213:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101216:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010121a:	74 0d                	je     c0101229 <lpt_putc+0x19>
        lpt_putc_sub(c);
c010121c:	8b 45 08             	mov    0x8(%ebp),%eax
c010121f:	89 04 24             	mov    %eax,(%esp)
c0101222:	e8 63 ff ff ff       	call   c010118a <lpt_putc_sub>
c0101227:	eb 24                	jmp    c010124d <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c0101229:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101230:	e8 55 ff ff ff       	call   c010118a <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101235:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010123c:	e8 49 ff ff ff       	call   c010118a <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101241:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101248:	e8 3d ff ff ff       	call   c010118a <lpt_putc_sub>
    }
}
c010124d:	c9                   	leave  
c010124e:	c3                   	ret    

c010124f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010124f:	55                   	push   %ebp
c0101250:	89 e5                	mov    %esp,%ebp
c0101252:	53                   	push   %ebx
c0101253:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101256:	8b 45 08             	mov    0x8(%ebp),%eax
c0101259:	b0 00                	mov    $0x0,%al
c010125b:	85 c0                	test   %eax,%eax
c010125d:	75 07                	jne    c0101266 <cga_putc+0x17>
        c |= 0x0700;
c010125f:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101266:	8b 45 08             	mov    0x8(%ebp),%eax
c0101269:	25 ff 00 00 00       	and    $0xff,%eax
c010126e:	83 f8 0a             	cmp    $0xa,%eax
c0101271:	74 4e                	je     c01012c1 <cga_putc+0x72>
c0101273:	83 f8 0d             	cmp    $0xd,%eax
c0101276:	74 59                	je     c01012d1 <cga_putc+0x82>
c0101278:	83 f8 08             	cmp    $0x8,%eax
c010127b:	0f 85 8c 00 00 00    	jne    c010130d <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
c0101281:	0f b7 05 84 c2 19 c0 	movzwl 0xc019c284,%eax
c0101288:	66 85 c0             	test   %ax,%ax
c010128b:	0f 84 a1 00 00 00    	je     c0101332 <cga_putc+0xe3>
            crt_pos --;
c0101291:	0f b7 05 84 c2 19 c0 	movzwl 0xc019c284,%eax
c0101298:	83 e8 01             	sub    $0x1,%eax
c010129b:	66 a3 84 c2 19 c0    	mov    %ax,0xc019c284
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01012a1:	a1 80 c2 19 c0       	mov    0xc019c280,%eax
c01012a6:	0f b7 15 84 c2 19 c0 	movzwl 0xc019c284,%edx
c01012ad:	0f b7 d2             	movzwl %dx,%edx
c01012b0:	01 d2                	add    %edx,%edx
c01012b2:	01 c2                	add    %eax,%edx
c01012b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01012b7:	b0 00                	mov    $0x0,%al
c01012b9:	83 c8 20             	or     $0x20,%eax
c01012bc:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01012bf:	eb 71                	jmp    c0101332 <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
c01012c1:	0f b7 05 84 c2 19 c0 	movzwl 0xc019c284,%eax
c01012c8:	83 c0 50             	add    $0x50,%eax
c01012cb:	66 a3 84 c2 19 c0    	mov    %ax,0xc019c284
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01012d1:	0f b7 1d 84 c2 19 c0 	movzwl 0xc019c284,%ebx
c01012d8:	0f b7 0d 84 c2 19 c0 	movzwl 0xc019c284,%ecx
c01012df:	0f b7 c1             	movzwl %cx,%eax
c01012e2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01012e8:	c1 e8 10             	shr    $0x10,%eax
c01012eb:	89 c2                	mov    %eax,%edx
c01012ed:	66 c1 ea 06          	shr    $0x6,%dx
c01012f1:	89 d0                	mov    %edx,%eax
c01012f3:	c1 e0 02             	shl    $0x2,%eax
c01012f6:	01 d0                	add    %edx,%eax
c01012f8:	c1 e0 04             	shl    $0x4,%eax
c01012fb:	89 ca                	mov    %ecx,%edx
c01012fd:	66 29 c2             	sub    %ax,%dx
c0101300:	89 d8                	mov    %ebx,%eax
c0101302:	66 29 d0             	sub    %dx,%ax
c0101305:	66 a3 84 c2 19 c0    	mov    %ax,0xc019c284
        break;
c010130b:	eb 26                	jmp    c0101333 <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010130d:	8b 15 80 c2 19 c0    	mov    0xc019c280,%edx
c0101313:	0f b7 05 84 c2 19 c0 	movzwl 0xc019c284,%eax
c010131a:	0f b7 c8             	movzwl %ax,%ecx
c010131d:	01 c9                	add    %ecx,%ecx
c010131f:	01 d1                	add    %edx,%ecx
c0101321:	8b 55 08             	mov    0x8(%ebp),%edx
c0101324:	66 89 11             	mov    %dx,(%ecx)
c0101327:	83 c0 01             	add    $0x1,%eax
c010132a:	66 a3 84 c2 19 c0    	mov    %ax,0xc019c284
        break;
c0101330:	eb 01                	jmp    c0101333 <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101332:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101333:	0f b7 05 84 c2 19 c0 	movzwl 0xc019c284,%eax
c010133a:	66 3d cf 07          	cmp    $0x7cf,%ax
c010133e:	76 5b                	jbe    c010139b <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101340:	a1 80 c2 19 c0       	mov    0xc019c280,%eax
c0101345:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010134b:	a1 80 c2 19 c0       	mov    0xc019c280,%eax
c0101350:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101357:	00 
c0101358:	89 54 24 04          	mov    %edx,0x4(%esp)
c010135c:	89 04 24             	mov    %eax,(%esp)
c010135f:	e8 6e ab 00 00       	call   c010bed2 <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101364:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010136b:	eb 15                	jmp    c0101382 <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
c010136d:	a1 80 c2 19 c0       	mov    0xc019c280,%eax
c0101372:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101375:	01 d2                	add    %edx,%edx
c0101377:	01 d0                	add    %edx,%eax
c0101379:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010137e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101382:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101389:	7e e2                	jle    c010136d <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010138b:	0f b7 05 84 c2 19 c0 	movzwl 0xc019c284,%eax
c0101392:	83 e8 50             	sub    $0x50,%eax
c0101395:	66 a3 84 c2 19 c0    	mov    %ax,0xc019c284
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010139b:	0f b7 05 86 c2 19 c0 	movzwl 0xc019c286,%eax
c01013a2:	0f b7 c0             	movzwl %ax,%eax
c01013a5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01013a9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c01013ad:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01013b1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01013b5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c01013b6:	0f b7 05 84 c2 19 c0 	movzwl 0xc019c284,%eax
c01013bd:	66 c1 e8 08          	shr    $0x8,%ax
c01013c1:	0f b6 c0             	movzbl %al,%eax
c01013c4:	0f b7 15 86 c2 19 c0 	movzwl 0xc019c286,%edx
c01013cb:	83 c2 01             	add    $0x1,%edx
c01013ce:	0f b7 d2             	movzwl %dx,%edx
c01013d1:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01013d5:	88 45 ed             	mov    %al,-0x13(%ebp)
c01013d8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01013dc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01013e0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01013e1:	0f b7 05 86 c2 19 c0 	movzwl 0xc019c286,%eax
c01013e8:	0f b7 c0             	movzwl %ax,%eax
c01013eb:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01013ef:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01013f3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01013f7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01013fb:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01013fc:	0f b7 05 84 c2 19 c0 	movzwl 0xc019c284,%eax
c0101403:	0f b6 c0             	movzbl %al,%eax
c0101406:	0f b7 15 86 c2 19 c0 	movzwl 0xc019c286,%edx
c010140d:	83 c2 01             	add    $0x1,%edx
c0101410:	0f b7 d2             	movzwl %dx,%edx
c0101413:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101417:	88 45 e5             	mov    %al,-0x1b(%ebp)
c010141a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010141e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101422:	ee                   	out    %al,(%dx)
}
c0101423:	83 c4 34             	add    $0x34,%esp
c0101426:	5b                   	pop    %ebx
c0101427:	5d                   	pop    %ebp
c0101428:	c3                   	ret    

c0101429 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101429:	55                   	push   %ebp
c010142a:	89 e5                	mov    %esp,%ebp
c010142c:	53                   	push   %ebx
c010142d:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101430:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101437:	eb 09                	jmp    c0101442 <serial_putc_sub+0x19>
        delay();
c0101439:	e8 e4 fa ff ff       	call   c0100f22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010143e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101442:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101448:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010144c:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101450:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101454:	ec                   	in     (%dx),%al
c0101455:	89 c3                	mov    %eax,%ebx
c0101457:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c010145a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010145e:	0f b6 c0             	movzbl %al,%eax
c0101461:	83 e0 20             	and    $0x20,%eax
c0101464:	85 c0                	test   %eax,%eax
c0101466:	75 09                	jne    c0101471 <serial_putc_sub+0x48>
c0101468:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c010146f:	7e c8                	jle    c0101439 <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101471:	8b 45 08             	mov    0x8(%ebp),%eax
c0101474:	0f b6 c0             	movzbl %al,%eax
c0101477:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c010147d:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101480:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101484:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101488:	ee                   	out    %al,(%dx)
}
c0101489:	83 c4 14             	add    $0x14,%esp
c010148c:	5b                   	pop    %ebx
c010148d:	5d                   	pop    %ebp
c010148e:	c3                   	ret    

c010148f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010148f:	55                   	push   %ebp
c0101490:	89 e5                	mov    %esp,%ebp
c0101492:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101495:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101499:	74 0d                	je     c01014a8 <serial_putc+0x19>
        serial_putc_sub(c);
c010149b:	8b 45 08             	mov    0x8(%ebp),%eax
c010149e:	89 04 24             	mov    %eax,(%esp)
c01014a1:	e8 83 ff ff ff       	call   c0101429 <serial_putc_sub>
c01014a6:	eb 24                	jmp    c01014cc <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c01014a8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01014af:	e8 75 ff ff ff       	call   c0101429 <serial_putc_sub>
        serial_putc_sub(' ');
c01014b4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01014bb:	e8 69 ff ff ff       	call   c0101429 <serial_putc_sub>
        serial_putc_sub('\b');
c01014c0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01014c7:	e8 5d ff ff ff       	call   c0101429 <serial_putc_sub>
    }
}
c01014cc:	c9                   	leave  
c01014cd:	c3                   	ret    

c01014ce <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01014ce:	55                   	push   %ebp
c01014cf:	89 e5                	mov    %esp,%ebp
c01014d1:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01014d4:	eb 32                	jmp    c0101508 <cons_intr+0x3a>
        if (c != 0) {
c01014d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01014da:	74 2c                	je     c0101508 <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
c01014dc:	a1 a4 c4 19 c0       	mov    0xc019c4a4,%eax
c01014e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01014e4:	88 90 a0 c2 19 c0    	mov    %dl,-0x3fe63d60(%eax)
c01014ea:	83 c0 01             	add    $0x1,%eax
c01014ed:	a3 a4 c4 19 c0       	mov    %eax,0xc019c4a4
            if (cons.wpos == CONSBUFSIZE) {
c01014f2:	a1 a4 c4 19 c0       	mov    0xc019c4a4,%eax
c01014f7:	3d 00 02 00 00       	cmp    $0x200,%eax
c01014fc:	75 0a                	jne    c0101508 <cons_intr+0x3a>
                cons.wpos = 0;
c01014fe:	c7 05 a4 c4 19 c0 00 	movl   $0x0,0xc019c4a4
c0101505:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101508:	8b 45 08             	mov    0x8(%ebp),%eax
c010150b:	ff d0                	call   *%eax
c010150d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101510:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101514:	75 c0                	jne    c01014d6 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101516:	c9                   	leave  
c0101517:	c3                   	ret    

c0101518 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101518:	55                   	push   %ebp
c0101519:	89 e5                	mov    %esp,%ebp
c010151b:	53                   	push   %ebx
c010151c:	83 ec 14             	sub    $0x14,%esp
c010151f:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101525:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101529:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010152d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101531:	ec                   	in     (%dx),%al
c0101532:	89 c3                	mov    %eax,%ebx
c0101534:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0101537:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010153b:	0f b6 c0             	movzbl %al,%eax
c010153e:	83 e0 01             	and    $0x1,%eax
c0101541:	85 c0                	test   %eax,%eax
c0101543:	75 07                	jne    c010154c <serial_proc_data+0x34>
        return -1;
c0101545:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010154a:	eb 32                	jmp    c010157e <serial_proc_data+0x66>
c010154c:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101552:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101556:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010155a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010155e:	ec                   	in     (%dx),%al
c010155f:	89 c3                	mov    %eax,%ebx
c0101561:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0101564:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101568:	0f b6 c0             	movzbl %al,%eax
c010156b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
c010156e:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
c0101572:	75 07                	jne    c010157b <serial_proc_data+0x63>
        c = '\b';
c0101574:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
c010157b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010157e:	83 c4 14             	add    $0x14,%esp
c0101581:	5b                   	pop    %ebx
c0101582:	5d                   	pop    %ebp
c0101583:	c3                   	ret    

c0101584 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101584:	55                   	push   %ebp
c0101585:	89 e5                	mov    %esp,%ebp
c0101587:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010158a:	a1 88 c2 19 c0       	mov    0xc019c288,%eax
c010158f:	85 c0                	test   %eax,%eax
c0101591:	74 0c                	je     c010159f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101593:	c7 04 24 18 15 10 c0 	movl   $0xc0101518,(%esp)
c010159a:	e8 2f ff ff ff       	call   c01014ce <cons_intr>
    }
}
c010159f:	c9                   	leave  
c01015a0:	c3                   	ret    

c01015a1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01015a1:	55                   	push   %ebp
c01015a2:	89 e5                	mov    %esp,%ebp
c01015a4:	53                   	push   %ebx
c01015a5:	83 ec 44             	sub    $0x44,%esp
c01015a8:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01015ae:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01015b2:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01015b6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01015ba:	ec                   	in     (%dx),%al
c01015bb:	89 c3                	mov    %eax,%ebx
c01015bd:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
c01015c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01015c4:	0f b6 c0             	movzbl %al,%eax
c01015c7:	83 e0 01             	and    $0x1,%eax
c01015ca:	85 c0                	test   %eax,%eax
c01015cc:	75 0a                	jne    c01015d8 <kbd_proc_data+0x37>
        return -1;
c01015ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01015d3:	e9 61 01 00 00       	jmp    c0101739 <kbd_proc_data+0x198>
c01015d8:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01015de:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01015e2:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01015e6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01015ea:	ec                   	in     (%dx),%al
c01015eb:	89 c3                	mov    %eax,%ebx
c01015ed:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
c01015f0:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01015f4:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01015f7:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01015fb:	75 17                	jne    c0101614 <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
c01015fd:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c0101602:	83 c8 40             	or     $0x40,%eax
c0101605:	a3 a8 c4 19 c0       	mov    %eax,0xc019c4a8
        return 0;
c010160a:	b8 00 00 00 00       	mov    $0x0,%eax
c010160f:	e9 25 01 00 00       	jmp    c0101739 <kbd_proc_data+0x198>
    } else if (data & 0x80) {
c0101614:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101618:	84 c0                	test   %al,%al
c010161a:	79 47                	jns    c0101663 <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010161c:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c0101621:	83 e0 40             	and    $0x40,%eax
c0101624:	85 c0                	test   %eax,%eax
c0101626:	75 09                	jne    c0101631 <kbd_proc_data+0x90>
c0101628:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010162c:	83 e0 7f             	and    $0x7f,%eax
c010162f:	eb 04                	jmp    c0101635 <kbd_proc_data+0x94>
c0101631:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101635:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101638:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010163c:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c0101643:	83 c8 40             	or     $0x40,%eax
c0101646:	0f b6 c0             	movzbl %al,%eax
c0101649:	f7 d0                	not    %eax
c010164b:	89 c2                	mov    %eax,%edx
c010164d:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c0101652:	21 d0                	and    %edx,%eax
c0101654:	a3 a8 c4 19 c0       	mov    %eax,0xc019c4a8
        return 0;
c0101659:	b8 00 00 00 00       	mov    $0x0,%eax
c010165e:	e9 d6 00 00 00       	jmp    c0101739 <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
c0101663:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c0101668:	83 e0 40             	and    $0x40,%eax
c010166b:	85 c0                	test   %eax,%eax
c010166d:	74 11                	je     c0101680 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010166f:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101673:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c0101678:	83 e0 bf             	and    $0xffffffbf,%eax
c010167b:	a3 a8 c4 19 c0       	mov    %eax,0xc019c4a8
    }

    shift |= shiftcode[data];
c0101680:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101684:	0f b6 80 60 a0 12 c0 	movzbl -0x3fed5fa0(%eax),%eax
c010168b:	0f b6 d0             	movzbl %al,%edx
c010168e:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c0101693:	09 d0                	or     %edx,%eax
c0101695:	a3 a8 c4 19 c0       	mov    %eax,0xc019c4a8
    shift ^= togglecode[data];
c010169a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010169e:	0f b6 80 60 a1 12 c0 	movzbl -0x3fed5ea0(%eax),%eax
c01016a5:	0f b6 d0             	movzbl %al,%edx
c01016a8:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c01016ad:	31 d0                	xor    %edx,%eax
c01016af:	a3 a8 c4 19 c0       	mov    %eax,0xc019c4a8

    c = charcode[shift & (CTL | SHIFT)][data];
c01016b4:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c01016b9:	83 e0 03             	and    $0x3,%eax
c01016bc:	8b 14 85 60 a5 12 c0 	mov    -0x3fed5aa0(,%eax,4),%edx
c01016c3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01016c7:	01 d0                	add    %edx,%eax
c01016c9:	0f b6 00             	movzbl (%eax),%eax
c01016cc:	0f b6 c0             	movzbl %al,%eax
c01016cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01016d2:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c01016d7:	83 e0 08             	and    $0x8,%eax
c01016da:	85 c0                	test   %eax,%eax
c01016dc:	74 22                	je     c0101700 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
c01016de:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01016e2:	7e 0c                	jle    c01016f0 <kbd_proc_data+0x14f>
c01016e4:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01016e8:	7f 06                	jg     c01016f0 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
c01016ea:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01016ee:	eb 10                	jmp    c0101700 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
c01016f0:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01016f4:	7e 0a                	jle    c0101700 <kbd_proc_data+0x15f>
c01016f6:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01016fa:	7f 04                	jg     c0101700 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
c01016fc:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101700:	a1 a8 c4 19 c0       	mov    0xc019c4a8,%eax
c0101705:	f7 d0                	not    %eax
c0101707:	83 e0 06             	and    $0x6,%eax
c010170a:	85 c0                	test   %eax,%eax
c010170c:	75 28                	jne    c0101736 <kbd_proc_data+0x195>
c010170e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101715:	75 1f                	jne    c0101736 <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
c0101717:	c7 04 24 5d c3 10 c0 	movl   $0xc010c35d,(%esp)
c010171e:	e8 3c ec ff ff       	call   c010035f <cprintf>
c0101723:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101729:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010172d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101731:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101735:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101736:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101739:	83 c4 44             	add    $0x44,%esp
c010173c:	5b                   	pop    %ebx
c010173d:	5d                   	pop    %ebp
c010173e:	c3                   	ret    

c010173f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010173f:	55                   	push   %ebp
c0101740:	89 e5                	mov    %esp,%ebp
c0101742:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101745:	c7 04 24 a1 15 10 c0 	movl   $0xc01015a1,(%esp)
c010174c:	e8 7d fd ff ff       	call   c01014ce <cons_intr>
}
c0101751:	c9                   	leave  
c0101752:	c3                   	ret    

c0101753 <kbd_init>:

static void
kbd_init(void) {
c0101753:	55                   	push   %ebp
c0101754:	89 e5                	mov    %esp,%ebp
c0101756:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101759:	e8 e1 ff ff ff       	call   c010173f <kbd_intr>
    pic_enable(IRQ_KBD);
c010175e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101765:	e8 da 09 00 00       	call   c0102144 <pic_enable>
}
c010176a:	c9                   	leave  
c010176b:	c3                   	ret    

c010176c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010176c:	55                   	push   %ebp
c010176d:	89 e5                	mov    %esp,%ebp
c010176f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101772:	e8 18 f8 ff ff       	call   c0100f8f <cga_init>
    serial_init();
c0101777:	e8 0e f9 ff ff       	call   c010108a <serial_init>
    kbd_init();
c010177c:	e8 d2 ff ff ff       	call   c0101753 <kbd_init>
    if (!serial_exists) {
c0101781:	a1 88 c2 19 c0       	mov    0xc019c288,%eax
c0101786:	85 c0                	test   %eax,%eax
c0101788:	75 0c                	jne    c0101796 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010178a:	c7 04 24 69 c3 10 c0 	movl   $0xc010c369,(%esp)
c0101791:	e8 c9 eb ff ff       	call   c010035f <cprintf>
    }
}
c0101796:	c9                   	leave  
c0101797:	c3                   	ret    

c0101798 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101798:	55                   	push   %ebp
c0101799:	89 e5                	mov    %esp,%ebp
c010179b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010179e:	e8 3d f7 ff ff       	call   c0100ee0 <__intr_save>
c01017a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01017a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01017a9:	89 04 24             	mov    %eax,(%esp)
c01017ac:	e8 5f fa ff ff       	call   c0101210 <lpt_putc>
        cga_putc(c);
c01017b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01017b4:	89 04 24             	mov    %eax,(%esp)
c01017b7:	e8 93 fa ff ff       	call   c010124f <cga_putc>
        serial_putc(c);
c01017bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01017bf:	89 04 24             	mov    %eax,(%esp)
c01017c2:	e8 c8 fc ff ff       	call   c010148f <serial_putc>
    }
    local_intr_restore(intr_flag);
c01017c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01017ca:	89 04 24             	mov    %eax,(%esp)
c01017cd:	e8 3d f7 ff ff       	call   c0100f0f <__intr_restore>
}
c01017d2:	c9                   	leave  
c01017d3:	c3                   	ret    

c01017d4 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01017d4:	55                   	push   %ebp
c01017d5:	89 e5                	mov    %esp,%ebp
c01017d7:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01017da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01017e1:	e8 fa f6 ff ff       	call   c0100ee0 <__intr_save>
c01017e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01017e9:	e8 96 fd ff ff       	call   c0101584 <serial_intr>
        kbd_intr();
c01017ee:	e8 4c ff ff ff       	call   c010173f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01017f3:	8b 15 a0 c4 19 c0    	mov    0xc019c4a0,%edx
c01017f9:	a1 a4 c4 19 c0       	mov    0xc019c4a4,%eax
c01017fe:	39 c2                	cmp    %eax,%edx
c0101800:	74 30                	je     c0101832 <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
c0101802:	a1 a0 c4 19 c0       	mov    0xc019c4a0,%eax
c0101807:	0f b6 90 a0 c2 19 c0 	movzbl -0x3fe63d60(%eax),%edx
c010180e:	0f b6 d2             	movzbl %dl,%edx
c0101811:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0101814:	83 c0 01             	add    $0x1,%eax
c0101817:	a3 a0 c4 19 c0       	mov    %eax,0xc019c4a0
            if (cons.rpos == CONSBUFSIZE) {
c010181c:	a1 a0 c4 19 c0       	mov    0xc019c4a0,%eax
c0101821:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101826:	75 0a                	jne    c0101832 <cons_getc+0x5e>
                cons.rpos = 0;
c0101828:	c7 05 a0 c4 19 c0 00 	movl   $0x0,0xc019c4a0
c010182f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101832:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101835:	89 04 24             	mov    %eax,(%esp)
c0101838:	e8 d2 f6 ff ff       	call   c0100f0f <__intr_restore>
    return c;
c010183d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101840:	c9                   	leave  
c0101841:	c3                   	ret    
	...

c0101844 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0101844:	55                   	push   %ebp
c0101845:	89 e5                	mov    %esp,%ebp
c0101847:	53                   	push   %ebx
c0101848:	83 ec 14             	sub    $0x14,%esp
c010184b:	8b 45 08             	mov    0x8(%ebp),%eax
c010184e:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0101852:	90                   	nop
c0101853:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0101857:	83 c0 07             	add    $0x7,%eax
c010185a:	0f b7 c0             	movzwl %ax,%eax
c010185d:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101861:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101865:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101869:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010186d:	ec                   	in     (%dx),%al
c010186e:	89 c3                	mov    %eax,%ebx
c0101870:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0101873:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101877:	0f b6 c0             	movzbl %al,%eax
c010187a:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010187d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101880:	25 80 00 00 00       	and    $0x80,%eax
c0101885:	85 c0                	test   %eax,%eax
c0101887:	75 ca                	jne    c0101853 <ide_wait_ready+0xf>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0101889:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010188d:	74 11                	je     c01018a0 <ide_wait_ready+0x5c>
c010188f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101892:	83 e0 21             	and    $0x21,%eax
c0101895:	85 c0                	test   %eax,%eax
c0101897:	74 07                	je     c01018a0 <ide_wait_ready+0x5c>
        return -1;
c0101899:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010189e:	eb 05                	jmp    c01018a5 <ide_wait_ready+0x61>
    }
    return 0;
c01018a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01018a5:	83 c4 14             	add    $0x14,%esp
c01018a8:	5b                   	pop    %ebx
c01018a9:	5d                   	pop    %ebp
c01018aa:	c3                   	ret    

c01018ab <ide_init>:

void
ide_init(void) {
c01018ab:	55                   	push   %ebp
c01018ac:	89 e5                	mov    %esp,%ebp
c01018ae:	57                   	push   %edi
c01018af:	56                   	push   %esi
c01018b0:	53                   	push   %ebx
c01018b1:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01018b7:	66 c7 45 e6 00 00    	movw   $0x0,-0x1a(%ebp)
c01018bd:	e9 e3 02 00 00       	jmp    c0101ba5 <ide_init+0x2fa>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c01018c2:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01018c6:	c1 e0 03             	shl    $0x3,%eax
c01018c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018d0:	29 c2                	sub    %eax,%edx
c01018d2:	8d 82 c0 c4 19 c0    	lea    -0x3fe63b40(%edx),%eax
c01018d8:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c01018db:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01018df:	66 d1 e8             	shr    %ax
c01018e2:	0f b7 c0             	movzwl %ax,%eax
c01018e5:	0f b7 04 85 88 c3 10 	movzwl -0x3fef3c78(,%eax,4),%eax
c01018ec:	c0 
c01018ed:	66 89 45 da          	mov    %ax,-0x26(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c01018f1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01018f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01018fc:	00 
c01018fd:	89 04 24             	mov    %eax,(%esp)
c0101900:	e8 3f ff ff ff       	call   c0101844 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101905:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101909:	83 e0 01             	and    $0x1,%eax
c010190c:	c1 e0 04             	shl    $0x4,%eax
c010190f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101912:	0f b6 c0             	movzbl %al,%eax
c0101915:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101919:	83 c2 06             	add    $0x6,%edx
c010191c:	0f b7 d2             	movzwl %dx,%edx
c010191f:	66 89 55 c2          	mov    %dx,-0x3e(%ebp)
c0101923:	88 45 c1             	mov    %al,-0x3f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101926:	0f b6 45 c1          	movzbl -0x3f(%ebp),%eax
c010192a:	0f b7 55 c2          	movzwl -0x3e(%ebp),%edx
c010192e:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010192f:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101933:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010193a:	00 
c010193b:	89 04 24             	mov    %eax,(%esp)
c010193e:	e8 01 ff ff ff       	call   c0101844 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0101943:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101947:	83 c0 07             	add    $0x7,%eax
c010194a:	0f b7 c0             	movzwl %ax,%eax
c010194d:	66 89 45 be          	mov    %ax,-0x42(%ebp)
c0101951:	c6 45 bd ec          	movb   $0xec,-0x43(%ebp)
c0101955:	0f b6 45 bd          	movzbl -0x43(%ebp),%eax
c0101959:	0f b7 55 be          	movzwl -0x42(%ebp),%edx
c010195d:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010195e:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101962:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101969:	00 
c010196a:	89 04 24             	mov    %eax,(%esp)
c010196d:	e8 d2 fe ff ff       	call   c0101844 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0101972:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101976:	83 c0 07             	add    $0x7,%eax
c0101979:	0f b7 c0             	movzwl %ax,%eax
c010197c:	66 89 45 ba          	mov    %ax,-0x46(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101980:	0f b7 55 ba          	movzwl -0x46(%ebp),%edx
c0101984:	66 89 95 a6 fd ff ff 	mov    %dx,-0x25a(%ebp)
c010198b:	0f b7 95 a6 fd ff ff 	movzwl -0x25a(%ebp),%edx
c0101992:	ec                   	in     (%dx),%al
c0101993:	89 c3                	mov    %eax,%ebx
c0101995:	88 5d b9             	mov    %bl,-0x47(%ebp)
    return data;
c0101998:	0f b6 45 b9          	movzbl -0x47(%ebp),%eax
c010199c:	84 c0                	test   %al,%al
c010199e:	0f 84 fb 01 00 00    	je     c0101b9f <ide_init+0x2f4>
c01019a4:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01019a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01019af:	00 
c01019b0:	89 04 24             	mov    %eax,(%esp)
c01019b3:	e8 8c fe ff ff       	call   c0101844 <ide_wait_ready>
c01019b8:	85 c0                	test   %eax,%eax
c01019ba:	0f 85 df 01 00 00    	jne    c0101b9f <ide_init+0x2f4>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c01019c0:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01019c4:	c1 e0 03             	shl    $0x3,%eax
c01019c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019ce:	29 c2                	sub    %eax,%edx
c01019d0:	8d 82 c0 c4 19 c0    	lea    -0x3fe63b40(%edx),%eax
c01019d6:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c01019d9:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01019dd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01019e0:	8d 85 ac fd ff ff    	lea    -0x254(%ebp),%eax
c01019e6:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01019e9:	c7 45 ac 80 00 00 00 	movl   $0x80,-0x54(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c01019f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01019f3:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c01019f6:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01019f9:	89 ce                	mov    %ecx,%esi
c01019fb:	89 d3                	mov    %edx,%ebx
c01019fd:	89 f7                	mov    %esi,%edi
c01019ff:	89 d9                	mov    %ebx,%ecx
c0101a01:	89 c2                	mov    %eax,%edx
c0101a03:	fc                   	cld    
c0101a04:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101a06:	89 cb                	mov    %ecx,%ebx
c0101a08:	89 fe                	mov    %edi,%esi
c0101a0a:	89 75 b0             	mov    %esi,-0x50(%ebp)
c0101a0d:	89 5d ac             	mov    %ebx,-0x54(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101a10:	8d 85 ac fd ff ff    	lea    -0x254(%ebp),%eax
c0101a16:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101a19:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101a1c:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101a22:	89 45 d0             	mov    %eax,-0x30(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101a25:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101a28:	25 00 00 00 04       	and    $0x4000000,%eax
c0101a2d:	85 c0                	test   %eax,%eax
c0101a2f:	74 0e                	je     c0101a3f <ide_init+0x194>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101a31:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101a34:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101a3a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0101a3d:	eb 09                	jmp    c0101a48 <ide_init+0x19d>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101a3f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101a42:	8b 40 78             	mov    0x78(%eax),%eax
c0101a45:	89 45 e0             	mov    %eax,-0x20(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101a48:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101a4c:	c1 e0 03             	shl    $0x3,%eax
c0101a4f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a56:	29 c2                	sub    %eax,%edx
c0101a58:	81 c2 c0 c4 19 c0    	add    $0xc019c4c0,%edx
c0101a5e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101a61:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c0101a64:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101a68:	c1 e0 03             	shl    $0x3,%eax
c0101a6b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a72:	29 c2                	sub    %eax,%edx
c0101a74:	81 c2 c0 c4 19 c0    	add    $0xc019c4c0,%edx
c0101a7a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101a7d:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0101a80:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101a83:	83 c0 62             	add    $0x62,%eax
c0101a86:	0f b7 00             	movzwl (%eax),%eax
c0101a89:	0f b7 c0             	movzwl %ax,%eax
c0101a8c:	25 00 02 00 00       	and    $0x200,%eax
c0101a91:	85 c0                	test   %eax,%eax
c0101a93:	75 24                	jne    c0101ab9 <ide_init+0x20e>
c0101a95:	c7 44 24 0c 90 c3 10 	movl   $0xc010c390,0xc(%esp)
c0101a9c:	c0 
c0101a9d:	c7 44 24 08 d3 c3 10 	movl   $0xc010c3d3,0x8(%esp)
c0101aa4:	c0 
c0101aa5:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c0101aac:	00 
c0101aad:	c7 04 24 e8 c3 10 c0 	movl   $0xc010c3e8,(%esp)
c0101ab4:	e8 ff f2 ff ff       	call   c0100db8 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c0101ab9:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101abd:	c1 e0 03             	shl    $0x3,%eax
c0101ac0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ac7:	29 c2                	sub    %eax,%edx
c0101ac9:	8d 82 c0 c4 19 c0    	lea    -0x3fe63b40(%edx),%eax
c0101acf:	83 c0 0c             	add    $0xc,%eax
c0101ad2:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101ad5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101ad8:	83 c0 36             	add    $0x36,%eax
c0101adb:	89 45 c8             	mov    %eax,-0x38(%ebp)
        unsigned int i, length = 40;
c0101ade:	c7 45 c4 28 00 00 00 	movl   $0x28,-0x3c(%ebp)
        for (i = 0; i < length; i += 2) {
c0101ae5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0101aec:	eb 30                	jmp    c0101b1e <ide_init+0x273>
            model[i] = data[i + 1], model[i + 1] = data[i];
c0101aee:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101af1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101af4:	01 c2                	add    %eax,%edx
c0101af6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101af9:	83 c0 01             	add    $0x1,%eax
c0101afc:	03 45 c8             	add    -0x38(%ebp),%eax
c0101aff:	0f b6 00             	movzbl (%eax),%eax
c0101b02:	88 02                	mov    %al,(%edx)
c0101b04:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101b07:	83 c0 01             	add    $0x1,%eax
c0101b0a:	03 45 cc             	add    -0x34(%ebp),%eax
c0101b0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101b10:	8b 4d c8             	mov    -0x38(%ebp),%ecx
c0101b13:	01 ca                	add    %ecx,%edx
c0101b15:	0f b6 12             	movzbl (%edx),%edx
c0101b18:	88 10                	mov    %dl,(%eax)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101b1a:	83 45 dc 02          	addl   $0x2,-0x24(%ebp)
c0101b1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101b21:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0101b24:	72 c8                	jb     c0101aee <ide_init+0x243>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101b26:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101b29:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101b2c:	01 d0                	add    %edx,%eax
c0101b2e:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101b31:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0101b35:	0f 95 c0             	setne  %al
c0101b38:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0101b3c:	84 c0                	test   %al,%al
c0101b3e:	74 0f                	je     c0101b4f <ide_init+0x2a4>
c0101b40:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101b43:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101b46:	01 d0                	add    %edx,%eax
c0101b48:	0f b6 00             	movzbl (%eax),%eax
c0101b4b:	3c 20                	cmp    $0x20,%al
c0101b4d:	74 d7                	je     c0101b26 <ide_init+0x27b>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101b4f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101b53:	c1 e0 03             	shl    $0x3,%eax
c0101b56:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b5d:	29 c2                	sub    %eax,%edx
c0101b5f:	8d 82 c0 c4 19 c0    	lea    -0x3fe63b40(%edx),%eax
c0101b65:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101b68:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101b6c:	c1 e0 03             	shl    $0x3,%eax
c0101b6f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b76:	29 c2                	sub    %eax,%edx
c0101b78:	8d 82 c0 c4 19 c0    	lea    -0x3fe63b40(%edx),%eax
c0101b7e:	8b 50 08             	mov    0x8(%eax),%edx
c0101b81:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101b85:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101b89:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101b8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101b91:	c7 04 24 fa c3 10 c0 	movl   $0xc010c3fa,(%esp)
c0101b98:	e8 c2 e7 ff ff       	call   c010035f <cprintf>
c0101b9d:	eb 01                	jmp    c0101ba0 <ide_init+0x2f5>
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
        ide_wait_ready(iobase, 0);

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
            continue ;
c0101b9f:	90                   	nop

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101ba0:	66 83 45 e6 01       	addw   $0x1,-0x1a(%ebp)
c0101ba5:	66 83 7d e6 03       	cmpw   $0x3,-0x1a(%ebp)
c0101baa:	0f 86 12 fd ff ff    	jbe    c01018c2 <ide_init+0x17>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101bb0:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101bb7:	e8 88 05 00 00       	call   c0102144 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101bbc:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101bc3:	e8 7c 05 00 00       	call   c0102144 <pic_enable>
}
c0101bc8:	81 c4 6c 02 00 00    	add    $0x26c,%esp
c0101bce:	5b                   	pop    %ebx
c0101bcf:	5e                   	pop    %esi
c0101bd0:	5f                   	pop    %edi
c0101bd1:	5d                   	pop    %ebp
c0101bd2:	c3                   	ret    

c0101bd3 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101bd3:	55                   	push   %ebp
c0101bd4:	89 e5                	mov    %esp,%ebp
c0101bd6:	83 ec 04             	sub    $0x4,%esp
c0101bd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101bdc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101be0:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101be5:	77 24                	ja     c0101c0b <ide_device_valid+0x38>
c0101be7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101beb:	c1 e0 03             	shl    $0x3,%eax
c0101bee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101bf5:	29 c2                	sub    %eax,%edx
c0101bf7:	8d 82 c0 c4 19 c0    	lea    -0x3fe63b40(%edx),%eax
c0101bfd:	0f b6 00             	movzbl (%eax),%eax
c0101c00:	84 c0                	test   %al,%al
c0101c02:	74 07                	je     c0101c0b <ide_device_valid+0x38>
c0101c04:	b8 01 00 00 00       	mov    $0x1,%eax
c0101c09:	eb 05                	jmp    c0101c10 <ide_device_valid+0x3d>
c0101c0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101c10:	c9                   	leave  
c0101c11:	c3                   	ret    

c0101c12 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101c12:	55                   	push   %ebp
c0101c13:	89 e5                	mov    %esp,%ebp
c0101c15:	83 ec 08             	sub    $0x8,%esp
c0101c18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c1b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101c1f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101c23:	89 04 24             	mov    %eax,(%esp)
c0101c26:	e8 a8 ff ff ff       	call   c0101bd3 <ide_device_valid>
c0101c2b:	85 c0                	test   %eax,%eax
c0101c2d:	74 1b                	je     c0101c4a <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101c2f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101c33:	c1 e0 03             	shl    $0x3,%eax
c0101c36:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101c3d:	29 c2                	sub    %eax,%edx
c0101c3f:	8d 82 c0 c4 19 c0    	lea    -0x3fe63b40(%edx),%eax
c0101c45:	8b 40 08             	mov    0x8(%eax),%eax
c0101c48:	eb 05                	jmp    c0101c4f <ide_device_size+0x3d>
    }
    return 0;
c0101c4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101c4f:	c9                   	leave  
c0101c50:	c3                   	ret    

c0101c51 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101c51:	55                   	push   %ebp
c0101c52:	89 e5                	mov    %esp,%ebp
c0101c54:	57                   	push   %edi
c0101c55:	56                   	push   %esi
c0101c56:	53                   	push   %ebx
c0101c57:	83 ec 5c             	sub    $0x5c,%esp
c0101c5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101c5d:	66 89 45 b4          	mov    %ax,-0x4c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101c61:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101c68:	77 24                	ja     c0101c8e <ide_read_secs+0x3d>
c0101c6a:	66 83 7d b4 03       	cmpw   $0x3,-0x4c(%ebp)
c0101c6f:	77 1d                	ja     c0101c8e <ide_read_secs+0x3d>
c0101c71:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101c75:	c1 e0 03             	shl    $0x3,%eax
c0101c78:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101c7f:	29 c2                	sub    %eax,%edx
c0101c81:	8d 82 c0 c4 19 c0    	lea    -0x3fe63b40(%edx),%eax
c0101c87:	0f b6 00             	movzbl (%eax),%eax
c0101c8a:	84 c0                	test   %al,%al
c0101c8c:	75 24                	jne    c0101cb2 <ide_read_secs+0x61>
c0101c8e:	c7 44 24 0c 18 c4 10 	movl   $0xc010c418,0xc(%esp)
c0101c95:	c0 
c0101c96:	c7 44 24 08 d3 c3 10 	movl   $0xc010c3d3,0x8(%esp)
c0101c9d:	c0 
c0101c9e:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101ca5:	00 
c0101ca6:	c7 04 24 e8 c3 10 c0 	movl   $0xc010c3e8,(%esp)
c0101cad:	e8 06 f1 ff ff       	call   c0100db8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101cb2:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101cb9:	77 0f                	ja     c0101cca <ide_read_secs+0x79>
c0101cbb:	8b 45 14             	mov    0x14(%ebp),%eax
c0101cbe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101cc1:	01 d0                	add    %edx,%eax
c0101cc3:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101cc8:	76 24                	jbe    c0101cee <ide_read_secs+0x9d>
c0101cca:	c7 44 24 0c 40 c4 10 	movl   $0xc010c440,0xc(%esp)
c0101cd1:	c0 
c0101cd2:	c7 44 24 08 d3 c3 10 	movl   $0xc010c3d3,0x8(%esp)
c0101cd9:	c0 
c0101cda:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101ce1:	00 
c0101ce2:	c7 04 24 e8 c3 10 c0 	movl   $0xc010c3e8,(%esp)
c0101ce9:	e8 ca f0 ff ff       	call   c0100db8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101cee:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101cf2:	66 d1 e8             	shr    %ax
c0101cf5:	0f b7 c0             	movzwl %ax,%eax
c0101cf8:	0f b7 04 85 88 c3 10 	movzwl -0x3fef3c78(,%eax,4),%eax
c0101cff:	c0 
c0101d00:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
c0101d04:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101d08:	66 d1 e8             	shr    %ax
c0101d0b:	0f b7 c0             	movzwl %ax,%eax
c0101d0e:	0f b7 04 85 8a c3 10 	movzwl -0x3fef3c76(,%eax,4),%eax
c0101d15:	c0 
c0101d16:	66 89 45 e0          	mov    %ax,-0x20(%ebp)

    ide_wait_ready(iobase, 0);
c0101d1a:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101d1e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101d25:	00 
c0101d26:	89 04 24             	mov    %eax,(%esp)
c0101d29:	e8 16 fb ff ff       	call   c0101844 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101d2e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
c0101d32:	83 c0 02             	add    $0x2,%eax
c0101d35:	0f b7 c0             	movzwl %ax,%eax
c0101d38:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c0101d3c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101d40:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101d44:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101d48:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101d49:	8b 45 14             	mov    0x14(%ebp),%eax
c0101d4c:	0f b6 c0             	movzbl %al,%eax
c0101d4f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101d53:	83 c2 02             	add    $0x2,%edx
c0101d56:	0f b7 d2             	movzwl %dx,%edx
c0101d59:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101d5d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101d60:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101d64:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101d68:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101d69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d6c:	0f b6 c0             	movzbl %al,%eax
c0101d6f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101d73:	83 c2 03             	add    $0x3,%edx
c0101d76:	0f b7 d2             	movzwl %dx,%edx
c0101d79:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c0101d7d:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101d80:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101d84:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101d88:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101d89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101d8c:	c1 e8 08             	shr    $0x8,%eax
c0101d8f:	0f b6 c0             	movzbl %al,%eax
c0101d92:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101d96:	83 c2 04             	add    $0x4,%edx
c0101d99:	0f b7 d2             	movzwl %dx,%edx
c0101d9c:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101da0:	88 45 d1             	mov    %al,-0x2f(%ebp)
c0101da3:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101da7:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101dab:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101dac:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101daf:	c1 e8 10             	shr    $0x10,%eax
c0101db2:	0f b6 c0             	movzbl %al,%eax
c0101db5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101db9:	83 c2 05             	add    $0x5,%edx
c0101dbc:	0f b7 d2             	movzwl %dx,%edx
c0101dbf:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
c0101dc3:	88 45 cd             	mov    %al,-0x33(%ebp)
c0101dc6:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101dca:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101dce:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101dcf:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101dd3:	83 e0 01             	and    $0x1,%eax
c0101dd6:	89 c2                	mov    %eax,%edx
c0101dd8:	c1 e2 04             	shl    $0x4,%edx
c0101ddb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101dde:	c1 e8 18             	shr    $0x18,%eax
c0101de1:	83 e0 0f             	and    $0xf,%eax
c0101de4:	09 d0                	or     %edx,%eax
c0101de6:	83 c8 e0             	or     $0xffffffe0,%eax
c0101de9:	0f b6 c0             	movzbl %al,%eax
c0101dec:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101df0:	83 c2 06             	add    $0x6,%edx
c0101df3:	0f b7 d2             	movzwl %dx,%edx
c0101df6:	66 89 55 ca          	mov    %dx,-0x36(%ebp)
c0101dfa:	88 45 c9             	mov    %al,-0x37(%ebp)
c0101dfd:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101e01:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101e05:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101e06:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101e0a:	83 c0 07             	add    $0x7,%eax
c0101e0d:	0f b7 c0             	movzwl %ax,%eax
c0101e10:	66 89 45 c6          	mov    %ax,-0x3a(%ebp)
c0101e14:	c6 45 c5 20          	movb   $0x20,-0x3b(%ebp)
c0101e18:	0f b6 45 c5          	movzbl -0x3b(%ebp),%eax
c0101e1c:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101e20:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101e21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101e28:	eb 5c                	jmp    c0101e86 <ide_read_secs+0x235>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101e2a:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101e2e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101e35:	00 
c0101e36:	89 04 24             	mov    %eax,(%esp)
c0101e39:	e8 06 fa ff ff       	call   c0101844 <ide_wait_ready>
c0101e3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0101e41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0101e45:	75 47                	jne    c0101e8e <ide_read_secs+0x23d>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101e47:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101e4b:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101e4e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101e51:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0101e54:	c7 45 b8 80 00 00 00 	movl   $0x80,-0x48(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101e5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0101e5e:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0101e61:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0101e64:	89 ce                	mov    %ecx,%esi
c0101e66:	89 d3                	mov    %edx,%ebx
c0101e68:	89 f7                	mov    %esi,%edi
c0101e6a:	89 d9                	mov    %ebx,%ecx
c0101e6c:	89 c2                	mov    %eax,%edx
c0101e6e:	fc                   	cld    
c0101e6f:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101e71:	89 cb                	mov    %ecx,%ebx
c0101e73:	89 fe                	mov    %edi,%esi
c0101e75:	89 75 bc             	mov    %esi,-0x44(%ebp)
c0101e78:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101e7b:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101e7f:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101e86:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101e8a:	75 9e                	jne    c0101e2a <ide_read_secs+0x1d9>
c0101e8c:	eb 01                	jmp    c0101e8f <ide_read_secs+0x23e>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c0101e8e:	90                   	nop
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101e8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
c0101e92:	83 c4 5c             	add    $0x5c,%esp
c0101e95:	5b                   	pop    %ebx
c0101e96:	5e                   	pop    %esi
c0101e97:	5f                   	pop    %edi
c0101e98:	5d                   	pop    %ebp
c0101e99:	c3                   	ret    

c0101e9a <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101e9a:	55                   	push   %ebp
c0101e9b:	89 e5                	mov    %esp,%ebp
c0101e9d:	56                   	push   %esi
c0101e9e:	53                   	push   %ebx
c0101e9f:	83 ec 50             	sub    $0x50,%esp
c0101ea2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ea5:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101ea9:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101eb0:	77 24                	ja     c0101ed6 <ide_write_secs+0x3c>
c0101eb2:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101eb7:	77 1d                	ja     c0101ed6 <ide_write_secs+0x3c>
c0101eb9:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101ebd:	c1 e0 03             	shl    $0x3,%eax
c0101ec0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101ec7:	29 c2                	sub    %eax,%edx
c0101ec9:	8d 82 c0 c4 19 c0    	lea    -0x3fe63b40(%edx),%eax
c0101ecf:	0f b6 00             	movzbl (%eax),%eax
c0101ed2:	84 c0                	test   %al,%al
c0101ed4:	75 24                	jne    c0101efa <ide_write_secs+0x60>
c0101ed6:	c7 44 24 0c 18 c4 10 	movl   $0xc010c418,0xc(%esp)
c0101edd:	c0 
c0101ede:	c7 44 24 08 d3 c3 10 	movl   $0xc010c3d3,0x8(%esp)
c0101ee5:	c0 
c0101ee6:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101eed:	00 
c0101eee:	c7 04 24 e8 c3 10 c0 	movl   $0xc010c3e8,(%esp)
c0101ef5:	e8 be ee ff ff       	call   c0100db8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101efa:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101f01:	77 0f                	ja     c0101f12 <ide_write_secs+0x78>
c0101f03:	8b 45 14             	mov    0x14(%ebp),%eax
c0101f06:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101f09:	01 d0                	add    %edx,%eax
c0101f0b:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101f10:	76 24                	jbe    c0101f36 <ide_write_secs+0x9c>
c0101f12:	c7 44 24 0c 40 c4 10 	movl   $0xc010c440,0xc(%esp)
c0101f19:	c0 
c0101f1a:	c7 44 24 08 d3 c3 10 	movl   $0xc010c3d3,0x8(%esp)
c0101f21:	c0 
c0101f22:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101f29:	00 
c0101f2a:	c7 04 24 e8 c3 10 c0 	movl   $0xc010c3e8,(%esp)
c0101f31:	e8 82 ee ff ff       	call   c0100db8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101f36:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f3a:	66 d1 e8             	shr    %ax
c0101f3d:	0f b7 c0             	movzwl %ax,%eax
c0101f40:	0f b7 04 85 88 c3 10 	movzwl -0x3fef3c78(,%eax,4),%eax
c0101f47:	c0 
c0101f48:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101f4c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f50:	66 d1 e8             	shr    %ax
c0101f53:	0f b7 c0             	movzwl %ax,%eax
c0101f56:	0f b7 04 85 8a c3 10 	movzwl -0x3fef3c76(,%eax,4),%eax
c0101f5d:	c0 
c0101f5e:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101f62:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f66:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101f6d:	00 
c0101f6e:	89 04 24             	mov    %eax,(%esp)
c0101f71:	e8 ce f8 ff ff       	call   c0101844 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101f76:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101f7a:	83 c0 02             	add    $0x2,%eax
c0101f7d:	0f b7 c0             	movzwl %ax,%eax
c0101f80:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101f84:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101f88:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101f8c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101f90:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101f91:	8b 45 14             	mov    0x14(%ebp),%eax
c0101f94:	0f b6 c0             	movzbl %al,%eax
c0101f97:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f9b:	83 c2 02             	add    $0x2,%edx
c0101f9e:	0f b7 d2             	movzwl %dx,%edx
c0101fa1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101fa5:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101fa8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101fac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101fb0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101fb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101fb4:	0f b6 c0             	movzbl %al,%eax
c0101fb7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101fbb:	83 c2 03             	add    $0x3,%edx
c0101fbe:	0f b7 d2             	movzwl %dx,%edx
c0101fc1:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101fc5:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101fc8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101fcc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101fd0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101fd1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101fd4:	c1 e8 08             	shr    $0x8,%eax
c0101fd7:	0f b6 c0             	movzbl %al,%eax
c0101fda:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101fde:	83 c2 04             	add    $0x4,%edx
c0101fe1:	0f b7 d2             	movzwl %dx,%edx
c0101fe4:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101fe8:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101feb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101fef:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101ff3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101ff4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ff7:	c1 e8 10             	shr    $0x10,%eax
c0101ffa:	0f b6 c0             	movzbl %al,%eax
c0101ffd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102001:	83 c2 05             	add    $0x5,%edx
c0102004:	0f b7 d2             	movzwl %dx,%edx
c0102007:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c010200b:	88 45 dd             	mov    %al,-0x23(%ebp)
c010200e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102012:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102016:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0102017:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c010201b:	83 e0 01             	and    $0x1,%eax
c010201e:	89 c2                	mov    %eax,%edx
c0102020:	c1 e2 04             	shl    $0x4,%edx
c0102023:	8b 45 0c             	mov    0xc(%ebp),%eax
c0102026:	c1 e8 18             	shr    $0x18,%eax
c0102029:	83 e0 0f             	and    $0xf,%eax
c010202c:	09 d0                	or     %edx,%eax
c010202e:	83 c8 e0             	or     $0xffffffe0,%eax
c0102031:	0f b6 c0             	movzbl %al,%eax
c0102034:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0102038:	83 c2 06             	add    $0x6,%edx
c010203b:	0f b7 d2             	movzwl %dx,%edx
c010203e:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0102042:	88 45 d9             	mov    %al,-0x27(%ebp)
c0102045:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102049:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010204d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c010204e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0102052:	83 c0 07             	add    $0x7,%eax
c0102055:	0f b7 c0             	movzwl %ax,%eax
c0102058:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c010205c:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0102060:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102064:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102068:	ee                   	out    %al,(%dx)

    int ret = 0;
c0102069:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0102070:	eb 58                	jmp    c01020ca <ide_write_secs+0x230>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0102072:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0102076:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010207d:	00 
c010207e:	89 04 24             	mov    %eax,(%esp)
c0102081:	e8 be f7 ff ff       	call   c0101844 <ide_wait_ready>
c0102086:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102089:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010208d:	75 43                	jne    c01020d2 <ide_write_secs+0x238>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c010208f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0102093:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0102096:	8b 45 10             	mov    0x10(%ebp),%eax
c0102099:	89 45 cc             	mov    %eax,-0x34(%ebp)
c010209c:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c01020a3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01020a6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c01020a9:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01020ac:	89 ce                	mov    %ecx,%esi
c01020ae:	89 d3                	mov    %edx,%ebx
c01020b0:	89 d9                	mov    %ebx,%ecx
c01020b2:	89 c2                	mov    %eax,%edx
c01020b4:	fc                   	cld    
c01020b5:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c01020b7:	89 cb                	mov    %ecx,%ebx
c01020b9:	89 75 cc             	mov    %esi,-0x34(%ebp)
c01020bc:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c01020bf:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c01020c3:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c01020ca:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c01020ce:	75 a2                	jne    c0102072 <ide_write_secs+0x1d8>
c01020d0:	eb 01                	jmp    c01020d3 <ide_write_secs+0x239>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c01020d2:	90                   	nop
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c01020d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01020d6:	83 c4 50             	add    $0x50,%esp
c01020d9:	5b                   	pop    %ebx
c01020da:	5e                   	pop    %esi
c01020db:	5d                   	pop    %ebp
c01020dc:	c3                   	ret    
c01020dd:	00 00                	add    %al,(%eax)
	...

c01020e0 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c01020e0:	55                   	push   %ebp
c01020e1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c01020e3:	fb                   	sti    
    sti();
}
c01020e4:	5d                   	pop    %ebp
c01020e5:	c3                   	ret    

c01020e6 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c01020e6:	55                   	push   %ebp
c01020e7:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c01020e9:	fa                   	cli    
    cli();
}
c01020ea:	5d                   	pop    %ebp
c01020eb:	c3                   	ret    

c01020ec <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c01020ec:	55                   	push   %ebp
c01020ed:	89 e5                	mov    %esp,%ebp
c01020ef:	83 ec 14             	sub    $0x14,%esp
c01020f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01020f5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c01020f9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c01020fd:	66 a3 70 a5 12 c0    	mov    %ax,0xc012a570
    if (did_init) {
c0102103:	a1 a0 c5 19 c0       	mov    0xc019c5a0,%eax
c0102108:	85 c0                	test   %eax,%eax
c010210a:	74 36                	je     c0102142 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c010210c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102110:	0f b6 c0             	movzbl %al,%eax
c0102113:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102119:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010211c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102120:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0102124:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0102125:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102129:	66 c1 e8 08          	shr    $0x8,%ax
c010212d:	0f b6 c0             	movzbl %al,%eax
c0102130:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0102136:	88 45 f9             	mov    %al,-0x7(%ebp)
c0102139:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010213d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102141:	ee                   	out    %al,(%dx)
    }
}
c0102142:	c9                   	leave  
c0102143:	c3                   	ret    

c0102144 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0102144:	55                   	push   %ebp
c0102145:	89 e5                	mov    %esp,%ebp
c0102147:	53                   	push   %ebx
c0102148:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010214b:	8b 45 08             	mov    0x8(%ebp),%eax
c010214e:	ba 01 00 00 00       	mov    $0x1,%edx
c0102153:	89 d3                	mov    %edx,%ebx
c0102155:	89 c1                	mov    %eax,%ecx
c0102157:	d3 e3                	shl    %cl,%ebx
c0102159:	89 d8                	mov    %ebx,%eax
c010215b:	89 c2                	mov    %eax,%edx
c010215d:	f7 d2                	not    %edx
c010215f:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c0102166:	21 d0                	and    %edx,%eax
c0102168:	0f b7 c0             	movzwl %ax,%eax
c010216b:	89 04 24             	mov    %eax,(%esp)
c010216e:	e8 79 ff ff ff       	call   c01020ec <pic_setmask>
}
c0102173:	83 c4 04             	add    $0x4,%esp
c0102176:	5b                   	pop    %ebx
c0102177:	5d                   	pop    %ebp
c0102178:	c3                   	ret    

c0102179 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0102179:	55                   	push   %ebp
c010217a:	89 e5                	mov    %esp,%ebp
c010217c:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010217f:	c7 05 a0 c5 19 c0 01 	movl   $0x1,0xc019c5a0
c0102186:	00 00 00 
c0102189:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010218f:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0102193:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102197:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010219b:	ee                   	out    %al,(%dx)
c010219c:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01021a2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01021a6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01021aa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01021ae:	ee                   	out    %al,(%dx)
c01021af:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01021b5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01021b9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01021bd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01021c1:	ee                   	out    %al,(%dx)
c01021c2:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01021c8:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01021cc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01021d0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01021d4:	ee                   	out    %al,(%dx)
c01021d5:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01021db:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01021df:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01021e3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01021e7:	ee                   	out    %al,(%dx)
c01021e8:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01021ee:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01021f2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01021f6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01021fa:	ee                   	out    %al,(%dx)
c01021fb:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102201:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102205:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102209:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010220d:	ee                   	out    %al,(%dx)
c010220e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102214:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102218:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010221c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102220:	ee                   	out    %al,(%dx)
c0102221:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102227:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010222b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010222f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102233:	ee                   	out    %al,(%dx)
c0102234:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010223a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010223e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102242:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102246:	ee                   	out    %al,(%dx)
c0102247:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010224d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102251:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102255:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102259:	ee                   	out    %al,(%dx)
c010225a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0102260:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0102264:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0102268:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010226c:	ee                   	out    %al,(%dx)
c010226d:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0102273:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0102277:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010227b:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010227f:	ee                   	out    %al,(%dx)
c0102280:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0102286:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010228a:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010228e:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0102292:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0102293:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c010229a:	66 83 f8 ff          	cmp    $0xffff,%ax
c010229e:	74 12                	je     c01022b2 <pic_init+0x139>
        pic_setmask(irq_mask);
c01022a0:	0f b7 05 70 a5 12 c0 	movzwl 0xc012a570,%eax
c01022a7:	0f b7 c0             	movzwl %ax,%eax
c01022aa:	89 04 24             	mov    %eax,(%esp)
c01022ad:	e8 3a fe ff ff       	call   c01020ec <pic_setmask>
    }
}
c01022b2:	c9                   	leave  
c01022b3:	c3                   	ret    

c01022b4 <print_ticks>:
#include <sched.h>
#include <sync.h>

#define TICK_NUM 100

static void print_ticks() {
c01022b4:	55                   	push   %ebp
c01022b5:	89 e5                	mov    %esp,%ebp
c01022b7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01022ba:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01022c1:	00 
c01022c2:	c7 04 24 80 c4 10 c0 	movl   $0xc010c480,(%esp)
c01022c9:	e8 91 e0 ff ff       	call   c010035f <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01022ce:	c7 04 24 8a c4 10 c0 	movl   $0xc010c48a,(%esp)
c01022d5:	e8 85 e0 ff ff       	call   c010035f <cprintf>
    panic("EOT: kernel seems ok.");
c01022da:	c7 44 24 08 98 c4 10 	movl   $0xc010c498,0x8(%esp)
c01022e1:	c0 
c01022e2:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01022e9:	00 
c01022ea:	c7 04 24 ae c4 10 c0 	movl   $0xc010c4ae,(%esp)
c01022f1:	e8 c2 ea ff ff       	call   c0100db8 <__panic>

c01022f6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01022f6:	55                   	push   %ebp
c01022f7:	89 e5                	mov    %esp,%ebp
c01022f9:	83 ec 10             	sub    $0x10,%esp
     /* LAB5 2011010312 */
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here
    extern uintptr_t __vectors[];
    int i;
    for(i = 0; i < 256; i++) {
c01022fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102303:	e9 c3 00 00 00       	jmp    c01023cb <idt_init+0xd5>
        SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
c0102308:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010230b:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c0102312:	89 c2                	mov    %eax,%edx
c0102314:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102317:	66 89 14 c5 c0 c5 19 	mov    %dx,-0x3fe63a40(,%eax,8)
c010231e:	c0 
c010231f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102322:	66 c7 04 c5 c2 c5 19 	movw   $0x8,-0x3fe63a3e(,%eax,8)
c0102329:	c0 08 00 
c010232c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010232f:	0f b6 14 c5 c4 c5 19 	movzbl -0x3fe63a3c(,%eax,8),%edx
c0102336:	c0 
c0102337:	83 e2 e0             	and    $0xffffffe0,%edx
c010233a:	88 14 c5 c4 c5 19 c0 	mov    %dl,-0x3fe63a3c(,%eax,8)
c0102341:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102344:	0f b6 14 c5 c4 c5 19 	movzbl -0x3fe63a3c(,%eax,8),%edx
c010234b:	c0 
c010234c:	83 e2 1f             	and    $0x1f,%edx
c010234f:	88 14 c5 c4 c5 19 c0 	mov    %dl,-0x3fe63a3c(,%eax,8)
c0102356:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102359:	0f b6 14 c5 c5 c5 19 	movzbl -0x3fe63a3b(,%eax,8),%edx
c0102360:	c0 
c0102361:	83 e2 f0             	and    $0xfffffff0,%edx
c0102364:	83 ca 0e             	or     $0xe,%edx
c0102367:	88 14 c5 c5 c5 19 c0 	mov    %dl,-0x3fe63a3b(,%eax,8)
c010236e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102371:	0f b6 14 c5 c5 c5 19 	movzbl -0x3fe63a3b(,%eax,8),%edx
c0102378:	c0 
c0102379:	83 e2 ef             	and    $0xffffffef,%edx
c010237c:	88 14 c5 c5 c5 19 c0 	mov    %dl,-0x3fe63a3b(,%eax,8)
c0102383:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102386:	0f b6 14 c5 c5 c5 19 	movzbl -0x3fe63a3b(,%eax,8),%edx
c010238d:	c0 
c010238e:	83 e2 9f             	and    $0xffffff9f,%edx
c0102391:	88 14 c5 c5 c5 19 c0 	mov    %dl,-0x3fe63a3b(,%eax,8)
c0102398:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010239b:	0f b6 14 c5 c5 c5 19 	movzbl -0x3fe63a3b(,%eax,8),%edx
c01023a2:	c0 
c01023a3:	83 ca 80             	or     $0xffffff80,%edx
c01023a6:	88 14 c5 c5 c5 19 c0 	mov    %dl,-0x3fe63a3b(,%eax,8)
c01023ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023b0:	8b 04 85 00 a6 12 c0 	mov    -0x3fed5a00(,%eax,4),%eax
c01023b7:	c1 e8 10             	shr    $0x10,%eax
c01023ba:	89 c2                	mov    %eax,%edx
c01023bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01023bf:	66 89 14 c5 c6 c5 19 	mov    %dx,-0x3fe63a3a(,%eax,8)
c01023c6:	c0 
     /* LAB5 2011010312 */
     //you should update your lab1 code (just add ONE or TWO lines of code), let user app to use syscall to get the service of ucore
     //so you should setup the syscall interrupt gate in here
    extern uintptr_t __vectors[];
    int i;
    for(i = 0; i < 256; i++) {
c01023c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01023cb:	81 7d fc ff 00 00 00 	cmpl   $0xff,-0x4(%ebp)
c01023d2:	0f 8e 30 ff ff ff    	jle    c0102308 <idt_init+0x12>
        SETGATE(idt[i], 0, KERNEL_CS, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SYSCALL], 1, KERNEL_CS, __vectors[T_SYSCALL], DPL_USER);
c01023d8:	a1 00 a8 12 c0       	mov    0xc012a800,%eax
c01023dd:	66 a3 c0 c9 19 c0    	mov    %ax,0xc019c9c0
c01023e3:	66 c7 05 c2 c9 19 c0 	movw   $0x8,0xc019c9c2
c01023ea:	08 00 
c01023ec:	0f b6 05 c4 c9 19 c0 	movzbl 0xc019c9c4,%eax
c01023f3:	83 e0 e0             	and    $0xffffffe0,%eax
c01023f6:	a2 c4 c9 19 c0       	mov    %al,0xc019c9c4
c01023fb:	0f b6 05 c4 c9 19 c0 	movzbl 0xc019c9c4,%eax
c0102402:	83 e0 1f             	and    $0x1f,%eax
c0102405:	a2 c4 c9 19 c0       	mov    %al,0xc019c9c4
c010240a:	0f b6 05 c5 c9 19 c0 	movzbl 0xc019c9c5,%eax
c0102411:	83 c8 0f             	or     $0xf,%eax
c0102414:	a2 c5 c9 19 c0       	mov    %al,0xc019c9c5
c0102419:	0f b6 05 c5 c9 19 c0 	movzbl 0xc019c9c5,%eax
c0102420:	83 e0 ef             	and    $0xffffffef,%eax
c0102423:	a2 c5 c9 19 c0       	mov    %al,0xc019c9c5
c0102428:	0f b6 05 c5 c9 19 c0 	movzbl 0xc019c9c5,%eax
c010242f:	83 c8 60             	or     $0x60,%eax
c0102432:	a2 c5 c9 19 c0       	mov    %al,0xc019c9c5
c0102437:	0f b6 05 c5 c9 19 c0 	movzbl 0xc019c9c5,%eax
c010243e:	83 c8 80             	or     $0xffffff80,%eax
c0102441:	a2 c5 c9 19 c0       	mov    %al,0xc019c9c5
c0102446:	a1 00 a8 12 c0       	mov    0xc012a800,%eax
c010244b:	c1 e8 10             	shr    $0x10,%eax
c010244e:	66 a3 c6 c9 19 c0    	mov    %ax,0xc019c9c6
c0102454:	c7 45 f8 80 a5 12 c0 	movl   $0xc012a580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010245b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010245e:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd);
}
c0102461:	c9                   	leave  
c0102462:	c3                   	ret    

c0102463 <trapname>:

static const char *
trapname(int trapno) {
c0102463:	55                   	push   %ebp
c0102464:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102466:	8b 45 08             	mov    0x8(%ebp),%eax
c0102469:	83 f8 13             	cmp    $0x13,%eax
c010246c:	77 0c                	ja     c010247a <trapname+0x17>
        return excnames[trapno];
c010246e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102471:	8b 04 85 20 c9 10 c0 	mov    -0x3fef36e0(,%eax,4),%eax
c0102478:	eb 18                	jmp    c0102492 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010247a:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010247e:	7e 0d                	jle    c010248d <trapname+0x2a>
c0102480:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102484:	7f 07                	jg     c010248d <trapname+0x2a>
        return "Hardware Interrupt";
c0102486:	b8 bf c4 10 c0       	mov    $0xc010c4bf,%eax
c010248b:	eb 05                	jmp    c0102492 <trapname+0x2f>
    }
    return "(unknown trap)";
c010248d:	b8 d2 c4 10 c0       	mov    $0xc010c4d2,%eax
}
c0102492:	5d                   	pop    %ebp
c0102493:	c3                   	ret    

c0102494 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102494:	55                   	push   %ebp
c0102495:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c0102497:	8b 45 08             	mov    0x8(%ebp),%eax
c010249a:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010249e:	66 83 f8 08          	cmp    $0x8,%ax
c01024a2:	0f 94 c0             	sete   %al
c01024a5:	0f b6 c0             	movzbl %al,%eax
}
c01024a8:	5d                   	pop    %ebp
c01024a9:	c3                   	ret    

c01024aa <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01024aa:	55                   	push   %ebp
c01024ab:	89 e5                	mov    %esp,%ebp
c01024ad:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01024b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b7:	c7 04 24 13 c5 10 c0 	movl   $0xc010c513,(%esp)
c01024be:	e8 9c de ff ff       	call   c010035f <cprintf>
    print_regs(&tf->tf_regs);
c01024c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01024c6:	89 04 24             	mov    %eax,(%esp)
c01024c9:	e8 a1 01 00 00       	call   c010266f <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01024ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d1:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01024d5:	0f b7 c0             	movzwl %ax,%eax
c01024d8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024dc:	c7 04 24 24 c5 10 c0 	movl   $0xc010c524,(%esp)
c01024e3:	e8 77 de ff ff       	call   c010035f <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01024e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01024eb:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01024ef:	0f b7 c0             	movzwl %ax,%eax
c01024f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024f6:	c7 04 24 37 c5 10 c0 	movl   $0xc010c537,(%esp)
c01024fd:	e8 5d de ff ff       	call   c010035f <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102502:	8b 45 08             	mov    0x8(%ebp),%eax
c0102505:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102509:	0f b7 c0             	movzwl %ax,%eax
c010250c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102510:	c7 04 24 4a c5 10 c0 	movl   $0xc010c54a,(%esp)
c0102517:	e8 43 de ff ff       	call   c010035f <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c010251c:	8b 45 08             	mov    0x8(%ebp),%eax
c010251f:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102523:	0f b7 c0             	movzwl %ax,%eax
c0102526:	89 44 24 04          	mov    %eax,0x4(%esp)
c010252a:	c7 04 24 5d c5 10 c0 	movl   $0xc010c55d,(%esp)
c0102531:	e8 29 de ff ff       	call   c010035f <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102536:	8b 45 08             	mov    0x8(%ebp),%eax
c0102539:	8b 40 30             	mov    0x30(%eax),%eax
c010253c:	89 04 24             	mov    %eax,(%esp)
c010253f:	e8 1f ff ff ff       	call   c0102463 <trapname>
c0102544:	8b 55 08             	mov    0x8(%ebp),%edx
c0102547:	8b 52 30             	mov    0x30(%edx),%edx
c010254a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010254e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102552:	c7 04 24 70 c5 10 c0 	movl   $0xc010c570,(%esp)
c0102559:	e8 01 de ff ff       	call   c010035f <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010255e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102561:	8b 40 34             	mov    0x34(%eax),%eax
c0102564:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102568:	c7 04 24 82 c5 10 c0 	movl   $0xc010c582,(%esp)
c010256f:	e8 eb dd ff ff       	call   c010035f <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102574:	8b 45 08             	mov    0x8(%ebp),%eax
c0102577:	8b 40 38             	mov    0x38(%eax),%eax
c010257a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010257e:	c7 04 24 91 c5 10 c0 	movl   $0xc010c591,(%esp)
c0102585:	e8 d5 dd ff ff       	call   c010035f <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c010258a:	8b 45 08             	mov    0x8(%ebp),%eax
c010258d:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102591:	0f b7 c0             	movzwl %ax,%eax
c0102594:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102598:	c7 04 24 a0 c5 10 c0 	movl   $0xc010c5a0,(%esp)
c010259f:	e8 bb dd ff ff       	call   c010035f <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01025a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a7:	8b 40 40             	mov    0x40(%eax),%eax
c01025aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025ae:	c7 04 24 b3 c5 10 c0 	movl   $0xc010c5b3,(%esp)
c01025b5:	e8 a5 dd ff ff       	call   c010035f <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01025ba:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01025c1:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01025c8:	eb 3e                	jmp    c0102608 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01025ca:	8b 45 08             	mov    0x8(%ebp),%eax
c01025cd:	8b 50 40             	mov    0x40(%eax),%edx
c01025d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01025d3:	21 d0                	and    %edx,%eax
c01025d5:	85 c0                	test   %eax,%eax
c01025d7:	74 28                	je     c0102601 <print_trapframe+0x157>
c01025d9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025dc:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c01025e3:	85 c0                	test   %eax,%eax
c01025e5:	74 1a                	je     c0102601 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01025e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01025ea:	8b 04 85 a0 a5 12 c0 	mov    -0x3fed5a60(,%eax,4),%eax
c01025f1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025f5:	c7 04 24 c2 c5 10 c0 	movl   $0xc010c5c2,(%esp)
c01025fc:	e8 5e dd ff ff       	call   c010035f <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102601:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102605:	d1 65 f0             	shll   -0x10(%ebp)
c0102608:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010260b:	83 f8 17             	cmp    $0x17,%eax
c010260e:	76 ba                	jbe    c01025ca <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102610:	8b 45 08             	mov    0x8(%ebp),%eax
c0102613:	8b 40 40             	mov    0x40(%eax),%eax
c0102616:	25 00 30 00 00       	and    $0x3000,%eax
c010261b:	c1 e8 0c             	shr    $0xc,%eax
c010261e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102622:	c7 04 24 c6 c5 10 c0 	movl   $0xc010c5c6,(%esp)
c0102629:	e8 31 dd ff ff       	call   c010035f <cprintf>

    if (!trap_in_kernel(tf)) {
c010262e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102631:	89 04 24             	mov    %eax,(%esp)
c0102634:	e8 5b fe ff ff       	call   c0102494 <trap_in_kernel>
c0102639:	85 c0                	test   %eax,%eax
c010263b:	75 30                	jne    c010266d <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c010263d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102640:	8b 40 44             	mov    0x44(%eax),%eax
c0102643:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102647:	c7 04 24 cf c5 10 c0 	movl   $0xc010c5cf,(%esp)
c010264e:	e8 0c dd ff ff       	call   c010035f <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102653:	8b 45 08             	mov    0x8(%ebp),%eax
c0102656:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c010265a:	0f b7 c0             	movzwl %ax,%eax
c010265d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102661:	c7 04 24 de c5 10 c0 	movl   $0xc010c5de,(%esp)
c0102668:	e8 f2 dc ff ff       	call   c010035f <cprintf>
    }
}
c010266d:	c9                   	leave  
c010266e:	c3                   	ret    

c010266f <print_regs>:

void
print_regs(struct pushregs *regs) {
c010266f:	55                   	push   %ebp
c0102670:	89 e5                	mov    %esp,%ebp
c0102672:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102675:	8b 45 08             	mov    0x8(%ebp),%eax
c0102678:	8b 00                	mov    (%eax),%eax
c010267a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010267e:	c7 04 24 f1 c5 10 c0 	movl   $0xc010c5f1,(%esp)
c0102685:	e8 d5 dc ff ff       	call   c010035f <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c010268a:	8b 45 08             	mov    0x8(%ebp),%eax
c010268d:	8b 40 04             	mov    0x4(%eax),%eax
c0102690:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102694:	c7 04 24 00 c6 10 c0 	movl   $0xc010c600,(%esp)
c010269b:	e8 bf dc ff ff       	call   c010035f <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01026a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01026a3:	8b 40 08             	mov    0x8(%eax),%eax
c01026a6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026aa:	c7 04 24 0f c6 10 c0 	movl   $0xc010c60f,(%esp)
c01026b1:	e8 a9 dc ff ff       	call   c010035f <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01026b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01026b9:	8b 40 0c             	mov    0xc(%eax),%eax
c01026bc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026c0:	c7 04 24 1e c6 10 c0 	movl   $0xc010c61e,(%esp)
c01026c7:	e8 93 dc ff ff       	call   c010035f <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01026cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01026cf:	8b 40 10             	mov    0x10(%eax),%eax
c01026d2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026d6:	c7 04 24 2d c6 10 c0 	movl   $0xc010c62d,(%esp)
c01026dd:	e8 7d dc ff ff       	call   c010035f <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01026e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01026e5:	8b 40 14             	mov    0x14(%eax),%eax
c01026e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01026ec:	c7 04 24 3c c6 10 c0 	movl   $0xc010c63c,(%esp)
c01026f3:	e8 67 dc ff ff       	call   c010035f <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01026f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01026fb:	8b 40 18             	mov    0x18(%eax),%eax
c01026fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102702:	c7 04 24 4b c6 10 c0 	movl   $0xc010c64b,(%esp)
c0102709:	e8 51 dc ff ff       	call   c010035f <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010270e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102711:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102714:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102718:	c7 04 24 5a c6 10 c0 	movl   $0xc010c65a,(%esp)
c010271f:	e8 3b dc ff ff       	call   c010035f <cprintf>
}
c0102724:	c9                   	leave  
c0102725:	c3                   	ret    

c0102726 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102726:	55                   	push   %ebp
c0102727:	89 e5                	mov    %esp,%ebp
c0102729:	53                   	push   %ebx
c010272a:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c010272d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102730:	8b 40 34             	mov    0x34(%eax),%eax
c0102733:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102736:	84 c0                	test   %al,%al
c0102738:	74 07                	je     c0102741 <print_pgfault+0x1b>
c010273a:	b9 69 c6 10 c0       	mov    $0xc010c669,%ecx
c010273f:	eb 05                	jmp    c0102746 <print_pgfault+0x20>
c0102741:	b9 7a c6 10 c0       	mov    $0xc010c67a,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102746:	8b 45 08             	mov    0x8(%ebp),%eax
c0102749:	8b 40 34             	mov    0x34(%eax),%eax
c010274c:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010274f:	85 c0                	test   %eax,%eax
c0102751:	74 07                	je     c010275a <print_pgfault+0x34>
c0102753:	ba 57 00 00 00       	mov    $0x57,%edx
c0102758:	eb 05                	jmp    c010275f <print_pgfault+0x39>
c010275a:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c010275f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102762:	8b 40 34             	mov    0x34(%eax),%eax
c0102765:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102768:	85 c0                	test   %eax,%eax
c010276a:	74 07                	je     c0102773 <print_pgfault+0x4d>
c010276c:	b8 55 00 00 00       	mov    $0x55,%eax
c0102771:	eb 05                	jmp    c0102778 <print_pgfault+0x52>
c0102773:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102778:	0f 20 d3             	mov    %cr2,%ebx
c010277b:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010277e:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102781:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102785:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102789:	89 44 24 08          	mov    %eax,0x8(%esp)
c010278d:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102791:	c7 04 24 88 c6 10 c0 	movl   $0xc010c688,(%esp)
c0102798:	e8 c2 db ff ff       	call   c010035f <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c010279d:	83 c4 34             	add    $0x34,%esp
c01027a0:	5b                   	pop    %ebx
c01027a1:	5d                   	pop    %ebp
c01027a2:	c3                   	ret    

c01027a3 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01027a3:	55                   	push   %ebp
c01027a4:	89 e5                	mov    %esp,%ebp
c01027a6:	53                   	push   %ebx
c01027a7:	83 ec 24             	sub    $0x24,%esp
    extern struct mm_struct *check_mm_struct;
    if(check_mm_struct !=NULL) { //used for test check_swap
c01027aa:	a1 ac ef 19 c0       	mov    0xc019efac,%eax
c01027af:	85 c0                	test   %eax,%eax
c01027b1:	74 0b                	je     c01027be <pgfault_handler+0x1b>
            print_pgfault(tf);
c01027b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01027b6:	89 04 24             	mov    %eax,(%esp)
c01027b9:	e8 68 ff ff ff       	call   c0102726 <print_pgfault>
        }
    struct mm_struct *mm;
    if (check_mm_struct != NULL) {
c01027be:	a1 ac ef 19 c0       	mov    0xc019efac,%eax
c01027c3:	85 c0                	test   %eax,%eax
c01027c5:	74 3d                	je     c0102804 <pgfault_handler+0x61>
        assert(current == idleproc);
c01027c7:	8b 15 88 ce 19 c0    	mov    0xc019ce88,%edx
c01027cd:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c01027d2:	39 c2                	cmp    %eax,%edx
c01027d4:	74 24                	je     c01027fa <pgfault_handler+0x57>
c01027d6:	c7 44 24 0c ab c6 10 	movl   $0xc010c6ab,0xc(%esp)
c01027dd:	c0 
c01027de:	c7 44 24 08 bf c6 10 	movl   $0xc010c6bf,0x8(%esp)
c01027e5:	c0 
c01027e6:	c7 44 24 04 af 00 00 	movl   $0xaf,0x4(%esp)
c01027ed:	00 
c01027ee:	c7 04 24 ae c4 10 c0 	movl   $0xc010c4ae,(%esp)
c01027f5:	e8 be e5 ff ff       	call   c0100db8 <__panic>
        mm = check_mm_struct;
c01027fa:	a1 ac ef 19 c0       	mov    0xc019efac,%eax
c01027ff:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102802:	eb 46                	jmp    c010284a <pgfault_handler+0xa7>
    }
    else {
        if (current == NULL) {
c0102804:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0102809:	85 c0                	test   %eax,%eax
c010280b:	75 32                	jne    c010283f <pgfault_handler+0x9c>
            print_trapframe(tf);
c010280d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102810:	89 04 24             	mov    %eax,(%esp)
c0102813:	e8 92 fc ff ff       	call   c01024aa <print_trapframe>
            print_pgfault(tf);
c0102818:	8b 45 08             	mov    0x8(%ebp),%eax
c010281b:	89 04 24             	mov    %eax,(%esp)
c010281e:	e8 03 ff ff ff       	call   c0102726 <print_pgfault>
            panic("unhandled page fault.\n");
c0102823:	c7 44 24 08 d4 c6 10 	movl   $0xc010c6d4,0x8(%esp)
c010282a:	c0 
c010282b:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102832:	00 
c0102833:	c7 04 24 ae c4 10 c0 	movl   $0xc010c4ae,(%esp)
c010283a:	e8 79 e5 ff ff       	call   c0100db8 <__panic>
        }
        mm = current->mm;
c010283f:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0102844:	8b 40 18             	mov    0x18(%eax),%eax
c0102847:	89 45 f4             	mov    %eax,-0xc(%ebp)
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010284a:	0f 20 d3             	mov    %cr2,%ebx
c010284d:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr2;
c0102850:	8b 45 f0             	mov    -0x10(%ebp),%eax
    }
    return do_pgfault(mm, tf->tf_err, rcr2());
c0102853:	89 c2                	mov    %eax,%edx
c0102855:	8b 45 08             	mov    0x8(%ebp),%eax
c0102858:	8b 40 34             	mov    0x34(%eax),%eax
c010285b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010285f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102863:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102866:	89 04 24             	mov    %eax,(%esp)
c0102869:	e8 05 66 00 00       	call   c0108e73 <do_pgfault>
}
c010286e:	83 c4 24             	add    $0x24,%esp
c0102871:	5b                   	pop    %ebx
c0102872:	5d                   	pop    %ebp
c0102873:	c3                   	ret    

c0102874 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102874:	55                   	push   %ebp
c0102875:	89 e5                	mov    %esp,%ebp
c0102877:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret=0;
c010287a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    switch (tf->tf_trapno) {
c0102881:	8b 45 08             	mov    0x8(%ebp),%eax
c0102884:	8b 40 30             	mov    0x30(%eax),%eax
c0102887:	83 f8 2f             	cmp    $0x2f,%eax
c010288a:	77 38                	ja     c01028c4 <trap_dispatch+0x50>
c010288c:	83 f8 2e             	cmp    $0x2e,%eax
c010288f:	0f 83 f4 01 00 00    	jae    c0102a89 <trap_dispatch+0x215>
c0102895:	83 f8 20             	cmp    $0x20,%eax
c0102898:	0f 84 02 01 00 00    	je     c01029a0 <trap_dispatch+0x12c>
c010289e:	83 f8 20             	cmp    $0x20,%eax
c01028a1:	77 0a                	ja     c01028ad <trap_dispatch+0x39>
c01028a3:	83 f8 0e             	cmp    $0xe,%eax
c01028a6:	74 3e                	je     c01028e6 <trap_dispatch+0x72>
c01028a8:	e9 94 01 00 00       	jmp    c0102a41 <trap_dispatch+0x1cd>
c01028ad:	83 f8 21             	cmp    $0x21,%eax
c01028b0:	0f 84 49 01 00 00    	je     c01029ff <trap_dispatch+0x18b>
c01028b6:	83 f8 24             	cmp    $0x24,%eax
c01028b9:	0f 84 17 01 00 00    	je     c01029d6 <trap_dispatch+0x162>
c01028bf:	e9 7d 01 00 00       	jmp    c0102a41 <trap_dispatch+0x1cd>
c01028c4:	83 f8 78             	cmp    $0x78,%eax
c01028c7:	0f 82 74 01 00 00    	jb     c0102a41 <trap_dispatch+0x1cd>
c01028cd:	83 f8 79             	cmp    $0x79,%eax
c01028d0:	0f 86 4f 01 00 00    	jbe    c0102a25 <trap_dispatch+0x1b1>
c01028d6:	3d 80 00 00 00       	cmp    $0x80,%eax
c01028db:	0f 84 b5 00 00 00    	je     c0102996 <trap_dispatch+0x122>
c01028e1:	e9 5b 01 00 00       	jmp    c0102a41 <trap_dispatch+0x1cd>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c01028e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01028e9:	89 04 24             	mov    %eax,(%esp)
c01028ec:	e8 b2 fe ff ff       	call   c01027a3 <pgfault_handler>
c01028f1:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01028f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01028f8:	0f 84 8e 01 00 00    	je     c0102a8c <trap_dispatch+0x218>
            print_trapframe(tf);
c01028fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0102901:	89 04 24             	mov    %eax,(%esp)
c0102904:	e8 a1 fb ff ff       	call   c01024aa <print_trapframe>
            if (current == NULL) {
c0102909:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010290e:	85 c0                	test   %eax,%eax
c0102910:	75 23                	jne    c0102935 <trap_dispatch+0xc1>
                panic("handle pgfault failed. ret=%d\n", ret);
c0102912:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102915:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102919:	c7 44 24 08 ec c6 10 	movl   $0xc010c6ec,0x8(%esp)
c0102920:	c0 
c0102921:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0102928:	00 
c0102929:	c7 04 24 ae c4 10 c0 	movl   $0xc010c4ae,(%esp)
c0102930:	e8 83 e4 ff ff       	call   c0100db8 <__panic>
            }
            else {
                if (trap_in_kernel(tf)) {
c0102935:	8b 45 08             	mov    0x8(%ebp),%eax
c0102938:	89 04 24             	mov    %eax,(%esp)
c010293b:	e8 54 fb ff ff       	call   c0102494 <trap_in_kernel>
c0102940:	85 c0                	test   %eax,%eax
c0102942:	74 23                	je     c0102967 <trap_dispatch+0xf3>
                    panic("handle pgfault failed in kernel mode. ret=%d\n", ret);
c0102944:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102947:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010294b:	c7 44 24 08 0c c7 10 	movl   $0xc010c70c,0x8(%esp)
c0102952:	c0 
c0102953:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c010295a:	00 
c010295b:	c7 04 24 ae c4 10 c0 	movl   $0xc010c4ae,(%esp)
c0102962:	e8 51 e4 ff ff       	call   c0100db8 <__panic>
                }
                cprintf("killed by kernel.\n");
c0102967:	c7 04 24 3a c7 10 c0 	movl   $0xc010c73a,(%esp)
c010296e:	e8 ec d9 ff ff       	call   c010035f <cprintf>
                panic("handle user mode pgfault failed. ret=%d\n", ret); 
c0102973:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102976:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010297a:	c7 44 24 08 50 c7 10 	movl   $0xc010c750,0x8(%esp)
c0102981:	c0 
c0102982:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0102989:	00 
c010298a:	c7 04 24 ae c4 10 c0 	movl   $0xc010c4ae,(%esp)
c0102991:	e8 22 e4 ff ff       	call   c0100db8 <__panic>
                do_exit(-E_KILLED);
            }
        }
        break;
    case T_SYSCALL:
        syscall();
c0102996:	e8 f3 88 00 00       	call   c010b28e <syscall>
        break;
c010299b:	e9 f0 00 00 00       	jmp    c0102a90 <trap_dispatch+0x21c>
         */
        /* LAB5 2011010312 */
        /* you should upate you lab1 code (just add ONE or TWO lines of code):
         *    Every TICK_NUM cycle, you should set current process's current->need_resched = 1
         */
        ticks++;
c01029a0:	a1 b4 ee 19 c0       	mov    0xc019eeb4,%eax
c01029a5:	83 c0 01             	add    $0x1,%eax
c01029a8:	a3 b4 ee 19 c0       	mov    %eax,0xc019eeb4
        if(ticks == TICK_NUM) {
c01029ad:	a1 b4 ee 19 c0       	mov    0xc019eeb4,%eax
c01029b2:	83 f8 64             	cmp    $0x64,%eax
c01029b5:	0f 85 d4 00 00 00    	jne    c0102a8f <trap_dispatch+0x21b>
            ticks = 0;
c01029bb:	c7 05 b4 ee 19 c0 00 	movl   $0x0,0xc019eeb4
c01029c2:	00 00 00 
            current->need_resched = 1;
c01029c5:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c01029ca:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
        }
        break;
c01029d1:	e9 b9 00 00 00       	jmp    c0102a8f <trap_dispatch+0x21b>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01029d6:	e8 f9 ed ff ff       	call   c01017d4 <cons_getc>
c01029db:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01029de:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01029e2:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01029e6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01029ea:	89 44 24 04          	mov    %eax,0x4(%esp)
c01029ee:	c7 04 24 79 c7 10 c0 	movl   $0xc010c779,(%esp)
c01029f5:	e8 65 d9 ff ff       	call   c010035f <cprintf>
        break;
c01029fa:	e9 91 00 00 00       	jmp    c0102a90 <trap_dispatch+0x21c>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c01029ff:	e8 d0 ed ff ff       	call   c01017d4 <cons_getc>
c0102a04:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102a07:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102a0b:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102a0f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102a13:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102a17:	c7 04 24 8b c7 10 c0 	movl   $0xc010c78b,(%esp)
c0102a1e:	e8 3c d9 ff ff       	call   c010035f <cprintf>
        break;
c0102a23:	eb 6b                	jmp    c0102a90 <trap_dispatch+0x21c>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102a25:	c7 44 24 08 9a c7 10 	movl   $0xc010c79a,0x8(%esp)
c0102a2c:	c0 
c0102a2d:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0102a34:	00 
c0102a35:	c7 04 24 ae c4 10 c0 	movl   $0xc010c4ae,(%esp)
c0102a3c:	e8 77 e3 ff ff       	call   c0100db8 <__panic>
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        print_trapframe(tf);
c0102a41:	8b 45 08             	mov    0x8(%ebp),%eax
c0102a44:	89 04 24             	mov    %eax,(%esp)
c0102a47:	e8 5e fa ff ff       	call   c01024aa <print_trapframe>
        if (current != NULL) {
c0102a4c:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0102a51:	85 c0                	test   %eax,%eax
c0102a53:	74 18                	je     c0102a6d <trap_dispatch+0x1f9>
            cprintf("unhandled trap.\n");
c0102a55:	c7 04 24 aa c7 10 c0 	movl   $0xc010c7aa,(%esp)
c0102a5c:	e8 fe d8 ff ff       	call   c010035f <cprintf>
            do_exit(-E_KILLED);
c0102a61:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102a68:	e8 a6 75 00 00       	call   c010a013 <do_exit>
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");
c0102a6d:	c7 44 24 08 bb c7 10 	movl   $0xc010c7bb,0x8(%esp)
c0102a74:	c0 
c0102a75:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0102a7c:	00 
c0102a7d:	c7 04 24 ae c4 10 c0 	movl   $0xc010c4ae,(%esp)
c0102a84:	e8 2f e3 ff ff       	call   c0100db8 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102a89:	90                   	nop
c0102a8a:	eb 04                	jmp    c0102a90 <trap_dispatch+0x21c>
                cprintf("killed by kernel.\n");
                panic("handle user mode pgfault failed. ret=%d\n", ret); 
                do_exit(-E_KILLED);
            }
        }
        break;
c0102a8c:	90                   	nop
c0102a8d:	eb 01                	jmp    c0102a90 <trap_dispatch+0x21c>
        ticks++;
        if(ticks == TICK_NUM) {
            ticks = 0;
            current->need_resched = 1;
        }
        break;
c0102a8f:	90                   	nop
        }
        // in kernel, it must be a mistake
        panic("unexpected trap in kernel.\n");

    }
}
c0102a90:	c9                   	leave  
c0102a91:	c3                   	ret    

c0102a92 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102a92:	55                   	push   %ebp
c0102a93:	89 e5                	mov    %esp,%ebp
c0102a95:	83 ec 28             	sub    $0x28,%esp
    // dispatch based on what type of trap occurred
    // used for previous projects
    if (current == NULL) {
c0102a98:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0102a9d:	85 c0                	test   %eax,%eax
c0102a9f:	75 0d                	jne    c0102aae <trap+0x1c>
        trap_dispatch(tf);
c0102aa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0102aa4:	89 04 24             	mov    %eax,(%esp)
c0102aa7:	e8 c8 fd ff ff       	call   c0102874 <trap_dispatch>
c0102aac:	eb 6c                	jmp    c0102b1a <trap+0x88>
    }
    else {
        // keep a trapframe chain in stack
        struct trapframe *otf = current->tf;
c0102aae:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0102ab3:	8b 40 3c             	mov    0x3c(%eax),%eax
c0102ab6:	89 45 f4             	mov    %eax,-0xc(%ebp)
        current->tf = tf;
c0102ab9:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0102abe:	8b 55 08             	mov    0x8(%ebp),%edx
c0102ac1:	89 50 3c             	mov    %edx,0x3c(%eax)
    
        bool in_kernel = trap_in_kernel(tf);
c0102ac4:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ac7:	89 04 24             	mov    %eax,(%esp)
c0102aca:	e8 c5 f9 ff ff       	call   c0102494 <trap_in_kernel>
c0102acf:	89 45 f0             	mov    %eax,-0x10(%ebp)
    
        trap_dispatch(tf);
c0102ad2:	8b 45 08             	mov    0x8(%ebp),%eax
c0102ad5:	89 04 24             	mov    %eax,(%esp)
c0102ad8:	e8 97 fd ff ff       	call   c0102874 <trap_dispatch>
    
        current->tf = otf;
c0102add:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0102ae2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0102ae5:	89 50 3c             	mov    %edx,0x3c(%eax)
        if (!in_kernel) {
c0102ae8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0102aec:	75 2c                	jne    c0102b1a <trap+0x88>
            if (current->flags & PF_EXITING) {
c0102aee:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0102af3:	8b 40 44             	mov    0x44(%eax),%eax
c0102af6:	83 e0 01             	and    $0x1,%eax
c0102af9:	84 c0                	test   %al,%al
c0102afb:	74 0c                	je     c0102b09 <trap+0x77>
                do_exit(-E_KILLED);
c0102afd:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c0102b04:	e8 0a 75 00 00       	call   c010a013 <do_exit>
            }
            if (current->need_resched) {
c0102b09:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0102b0e:	8b 40 10             	mov    0x10(%eax),%eax
c0102b11:	85 c0                	test   %eax,%eax
c0102b13:	74 05                	je     c0102b1a <trap+0x88>
                schedule();
c0102b15:	e8 78 85 00 00       	call   c010b092 <schedule>
            }
        }
    }
}
c0102b1a:	c9                   	leave  
c0102b1b:	c3                   	ret    

c0102b1c <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c0102b1c:	1e                   	push   %ds
    pushl %es
c0102b1d:	06                   	push   %es
    pushl %fs
c0102b1e:	0f a0                	push   %fs
    pushl %gs
c0102b20:	0f a8                	push   %gs
    pushal
c0102b22:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c0102b23:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c0102b28:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c0102b2a:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c0102b2c:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c0102b2d:	e8 60 ff ff ff       	call   c0102a92 <trap>

    # pop the pushed stack pointer
    popl %esp
c0102b32:	5c                   	pop    %esp

c0102b33 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c0102b33:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c0102b34:	0f a9                	pop    %gs
    popl %fs
c0102b36:	0f a1                	pop    %fs
    popl %es
c0102b38:	07                   	pop    %es
    popl %ds
c0102b39:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c0102b3a:	83 c4 08             	add    $0x8,%esp
    iret
c0102b3d:	cf                   	iret   

c0102b3e <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c0102b3e:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c0102b42:	e9 ec ff ff ff       	jmp    c0102b33 <__trapret>
	...

c0102b48 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c0102b48:	6a 00                	push   $0x0
  pushl $0
c0102b4a:	6a 00                	push   $0x0
  jmp __alltraps
c0102b4c:	e9 cb ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b51 <vector1>:
.globl vector1
vector1:
  pushl $0
c0102b51:	6a 00                	push   $0x0
  pushl $1
c0102b53:	6a 01                	push   $0x1
  jmp __alltraps
c0102b55:	e9 c2 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b5a <vector2>:
.globl vector2
vector2:
  pushl $0
c0102b5a:	6a 00                	push   $0x0
  pushl $2
c0102b5c:	6a 02                	push   $0x2
  jmp __alltraps
c0102b5e:	e9 b9 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b63 <vector3>:
.globl vector3
vector3:
  pushl $0
c0102b63:	6a 00                	push   $0x0
  pushl $3
c0102b65:	6a 03                	push   $0x3
  jmp __alltraps
c0102b67:	e9 b0 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b6c <vector4>:
.globl vector4
vector4:
  pushl $0
c0102b6c:	6a 00                	push   $0x0
  pushl $4
c0102b6e:	6a 04                	push   $0x4
  jmp __alltraps
c0102b70:	e9 a7 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b75 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102b75:	6a 00                	push   $0x0
  pushl $5
c0102b77:	6a 05                	push   $0x5
  jmp __alltraps
c0102b79:	e9 9e ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b7e <vector6>:
.globl vector6
vector6:
  pushl $0
c0102b7e:	6a 00                	push   $0x0
  pushl $6
c0102b80:	6a 06                	push   $0x6
  jmp __alltraps
c0102b82:	e9 95 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b87 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102b87:	6a 00                	push   $0x0
  pushl $7
c0102b89:	6a 07                	push   $0x7
  jmp __alltraps
c0102b8b:	e9 8c ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b90 <vector8>:
.globl vector8
vector8:
  pushl $8
c0102b90:	6a 08                	push   $0x8
  jmp __alltraps
c0102b92:	e9 85 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b97 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102b97:	6a 09                	push   $0x9
  jmp __alltraps
c0102b99:	e9 7e ff ff ff       	jmp    c0102b1c <__alltraps>

c0102b9e <vector10>:
.globl vector10
vector10:
  pushl $10
c0102b9e:	6a 0a                	push   $0xa
  jmp __alltraps
c0102ba0:	e9 77 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102ba5 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102ba5:	6a 0b                	push   $0xb
  jmp __alltraps
c0102ba7:	e9 70 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bac <vector12>:
.globl vector12
vector12:
  pushl $12
c0102bac:	6a 0c                	push   $0xc
  jmp __alltraps
c0102bae:	e9 69 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bb3 <vector13>:
.globl vector13
vector13:
  pushl $13
c0102bb3:	6a 0d                	push   $0xd
  jmp __alltraps
c0102bb5:	e9 62 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bba <vector14>:
.globl vector14
vector14:
  pushl $14
c0102bba:	6a 0e                	push   $0xe
  jmp __alltraps
c0102bbc:	e9 5b ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bc1 <vector15>:
.globl vector15
vector15:
  pushl $0
c0102bc1:	6a 00                	push   $0x0
  pushl $15
c0102bc3:	6a 0f                	push   $0xf
  jmp __alltraps
c0102bc5:	e9 52 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bca <vector16>:
.globl vector16
vector16:
  pushl $0
c0102bca:	6a 00                	push   $0x0
  pushl $16
c0102bcc:	6a 10                	push   $0x10
  jmp __alltraps
c0102bce:	e9 49 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bd3 <vector17>:
.globl vector17
vector17:
  pushl $17
c0102bd3:	6a 11                	push   $0x11
  jmp __alltraps
c0102bd5:	e9 42 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bda <vector18>:
.globl vector18
vector18:
  pushl $0
c0102bda:	6a 00                	push   $0x0
  pushl $18
c0102bdc:	6a 12                	push   $0x12
  jmp __alltraps
c0102bde:	e9 39 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102be3 <vector19>:
.globl vector19
vector19:
  pushl $0
c0102be3:	6a 00                	push   $0x0
  pushl $19
c0102be5:	6a 13                	push   $0x13
  jmp __alltraps
c0102be7:	e9 30 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bec <vector20>:
.globl vector20
vector20:
  pushl $0
c0102bec:	6a 00                	push   $0x0
  pushl $20
c0102bee:	6a 14                	push   $0x14
  jmp __alltraps
c0102bf0:	e9 27 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bf5 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102bf5:	6a 00                	push   $0x0
  pushl $21
c0102bf7:	6a 15                	push   $0x15
  jmp __alltraps
c0102bf9:	e9 1e ff ff ff       	jmp    c0102b1c <__alltraps>

c0102bfe <vector22>:
.globl vector22
vector22:
  pushl $0
c0102bfe:	6a 00                	push   $0x0
  pushl $22
c0102c00:	6a 16                	push   $0x16
  jmp __alltraps
c0102c02:	e9 15 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102c07 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102c07:	6a 00                	push   $0x0
  pushl $23
c0102c09:	6a 17                	push   $0x17
  jmp __alltraps
c0102c0b:	e9 0c ff ff ff       	jmp    c0102b1c <__alltraps>

c0102c10 <vector24>:
.globl vector24
vector24:
  pushl $0
c0102c10:	6a 00                	push   $0x0
  pushl $24
c0102c12:	6a 18                	push   $0x18
  jmp __alltraps
c0102c14:	e9 03 ff ff ff       	jmp    c0102b1c <__alltraps>

c0102c19 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102c19:	6a 00                	push   $0x0
  pushl $25
c0102c1b:	6a 19                	push   $0x19
  jmp __alltraps
c0102c1d:	e9 fa fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c22 <vector26>:
.globl vector26
vector26:
  pushl $0
c0102c22:	6a 00                	push   $0x0
  pushl $26
c0102c24:	6a 1a                	push   $0x1a
  jmp __alltraps
c0102c26:	e9 f1 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c2b <vector27>:
.globl vector27
vector27:
  pushl $0
c0102c2b:	6a 00                	push   $0x0
  pushl $27
c0102c2d:	6a 1b                	push   $0x1b
  jmp __alltraps
c0102c2f:	e9 e8 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c34 <vector28>:
.globl vector28
vector28:
  pushl $0
c0102c34:	6a 00                	push   $0x0
  pushl $28
c0102c36:	6a 1c                	push   $0x1c
  jmp __alltraps
c0102c38:	e9 df fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c3d <vector29>:
.globl vector29
vector29:
  pushl $0
c0102c3d:	6a 00                	push   $0x0
  pushl $29
c0102c3f:	6a 1d                	push   $0x1d
  jmp __alltraps
c0102c41:	e9 d6 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c46 <vector30>:
.globl vector30
vector30:
  pushl $0
c0102c46:	6a 00                	push   $0x0
  pushl $30
c0102c48:	6a 1e                	push   $0x1e
  jmp __alltraps
c0102c4a:	e9 cd fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c4f <vector31>:
.globl vector31
vector31:
  pushl $0
c0102c4f:	6a 00                	push   $0x0
  pushl $31
c0102c51:	6a 1f                	push   $0x1f
  jmp __alltraps
c0102c53:	e9 c4 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c58 <vector32>:
.globl vector32
vector32:
  pushl $0
c0102c58:	6a 00                	push   $0x0
  pushl $32
c0102c5a:	6a 20                	push   $0x20
  jmp __alltraps
c0102c5c:	e9 bb fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c61 <vector33>:
.globl vector33
vector33:
  pushl $0
c0102c61:	6a 00                	push   $0x0
  pushl $33
c0102c63:	6a 21                	push   $0x21
  jmp __alltraps
c0102c65:	e9 b2 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c6a <vector34>:
.globl vector34
vector34:
  pushl $0
c0102c6a:	6a 00                	push   $0x0
  pushl $34
c0102c6c:	6a 22                	push   $0x22
  jmp __alltraps
c0102c6e:	e9 a9 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c73 <vector35>:
.globl vector35
vector35:
  pushl $0
c0102c73:	6a 00                	push   $0x0
  pushl $35
c0102c75:	6a 23                	push   $0x23
  jmp __alltraps
c0102c77:	e9 a0 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c7c <vector36>:
.globl vector36
vector36:
  pushl $0
c0102c7c:	6a 00                	push   $0x0
  pushl $36
c0102c7e:	6a 24                	push   $0x24
  jmp __alltraps
c0102c80:	e9 97 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c85 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102c85:	6a 00                	push   $0x0
  pushl $37
c0102c87:	6a 25                	push   $0x25
  jmp __alltraps
c0102c89:	e9 8e fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c8e <vector38>:
.globl vector38
vector38:
  pushl $0
c0102c8e:	6a 00                	push   $0x0
  pushl $38
c0102c90:	6a 26                	push   $0x26
  jmp __alltraps
c0102c92:	e9 85 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102c97 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102c97:	6a 00                	push   $0x0
  pushl $39
c0102c99:	6a 27                	push   $0x27
  jmp __alltraps
c0102c9b:	e9 7c fe ff ff       	jmp    c0102b1c <__alltraps>

c0102ca0 <vector40>:
.globl vector40
vector40:
  pushl $0
c0102ca0:	6a 00                	push   $0x0
  pushl $40
c0102ca2:	6a 28                	push   $0x28
  jmp __alltraps
c0102ca4:	e9 73 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102ca9 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102ca9:	6a 00                	push   $0x0
  pushl $41
c0102cab:	6a 29                	push   $0x29
  jmp __alltraps
c0102cad:	e9 6a fe ff ff       	jmp    c0102b1c <__alltraps>

c0102cb2 <vector42>:
.globl vector42
vector42:
  pushl $0
c0102cb2:	6a 00                	push   $0x0
  pushl $42
c0102cb4:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102cb6:	e9 61 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102cbb <vector43>:
.globl vector43
vector43:
  pushl $0
c0102cbb:	6a 00                	push   $0x0
  pushl $43
c0102cbd:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102cbf:	e9 58 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102cc4 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102cc4:	6a 00                	push   $0x0
  pushl $44
c0102cc6:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102cc8:	e9 4f fe ff ff       	jmp    c0102b1c <__alltraps>

c0102ccd <vector45>:
.globl vector45
vector45:
  pushl $0
c0102ccd:	6a 00                	push   $0x0
  pushl $45
c0102ccf:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102cd1:	e9 46 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102cd6 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102cd6:	6a 00                	push   $0x0
  pushl $46
c0102cd8:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102cda:	e9 3d fe ff ff       	jmp    c0102b1c <__alltraps>

c0102cdf <vector47>:
.globl vector47
vector47:
  pushl $0
c0102cdf:	6a 00                	push   $0x0
  pushl $47
c0102ce1:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102ce3:	e9 34 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102ce8 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102ce8:	6a 00                	push   $0x0
  pushl $48
c0102cea:	6a 30                	push   $0x30
  jmp __alltraps
c0102cec:	e9 2b fe ff ff       	jmp    c0102b1c <__alltraps>

c0102cf1 <vector49>:
.globl vector49
vector49:
  pushl $0
c0102cf1:	6a 00                	push   $0x0
  pushl $49
c0102cf3:	6a 31                	push   $0x31
  jmp __alltraps
c0102cf5:	e9 22 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102cfa <vector50>:
.globl vector50
vector50:
  pushl $0
c0102cfa:	6a 00                	push   $0x0
  pushl $50
c0102cfc:	6a 32                	push   $0x32
  jmp __alltraps
c0102cfe:	e9 19 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102d03 <vector51>:
.globl vector51
vector51:
  pushl $0
c0102d03:	6a 00                	push   $0x0
  pushl $51
c0102d05:	6a 33                	push   $0x33
  jmp __alltraps
c0102d07:	e9 10 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102d0c <vector52>:
.globl vector52
vector52:
  pushl $0
c0102d0c:	6a 00                	push   $0x0
  pushl $52
c0102d0e:	6a 34                	push   $0x34
  jmp __alltraps
c0102d10:	e9 07 fe ff ff       	jmp    c0102b1c <__alltraps>

c0102d15 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102d15:	6a 00                	push   $0x0
  pushl $53
c0102d17:	6a 35                	push   $0x35
  jmp __alltraps
c0102d19:	e9 fe fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d1e <vector54>:
.globl vector54
vector54:
  pushl $0
c0102d1e:	6a 00                	push   $0x0
  pushl $54
c0102d20:	6a 36                	push   $0x36
  jmp __alltraps
c0102d22:	e9 f5 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d27 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102d27:	6a 00                	push   $0x0
  pushl $55
c0102d29:	6a 37                	push   $0x37
  jmp __alltraps
c0102d2b:	e9 ec fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d30 <vector56>:
.globl vector56
vector56:
  pushl $0
c0102d30:	6a 00                	push   $0x0
  pushl $56
c0102d32:	6a 38                	push   $0x38
  jmp __alltraps
c0102d34:	e9 e3 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d39 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102d39:	6a 00                	push   $0x0
  pushl $57
c0102d3b:	6a 39                	push   $0x39
  jmp __alltraps
c0102d3d:	e9 da fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d42 <vector58>:
.globl vector58
vector58:
  pushl $0
c0102d42:	6a 00                	push   $0x0
  pushl $58
c0102d44:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102d46:	e9 d1 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d4b <vector59>:
.globl vector59
vector59:
  pushl $0
c0102d4b:	6a 00                	push   $0x0
  pushl $59
c0102d4d:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102d4f:	e9 c8 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d54 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102d54:	6a 00                	push   $0x0
  pushl $60
c0102d56:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102d58:	e9 bf fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d5d <vector61>:
.globl vector61
vector61:
  pushl $0
c0102d5d:	6a 00                	push   $0x0
  pushl $61
c0102d5f:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102d61:	e9 b6 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d66 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102d66:	6a 00                	push   $0x0
  pushl $62
c0102d68:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102d6a:	e9 ad fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d6f <vector63>:
.globl vector63
vector63:
  pushl $0
c0102d6f:	6a 00                	push   $0x0
  pushl $63
c0102d71:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102d73:	e9 a4 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d78 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102d78:	6a 00                	push   $0x0
  pushl $64
c0102d7a:	6a 40                	push   $0x40
  jmp __alltraps
c0102d7c:	e9 9b fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d81 <vector65>:
.globl vector65
vector65:
  pushl $0
c0102d81:	6a 00                	push   $0x0
  pushl $65
c0102d83:	6a 41                	push   $0x41
  jmp __alltraps
c0102d85:	e9 92 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d8a <vector66>:
.globl vector66
vector66:
  pushl $0
c0102d8a:	6a 00                	push   $0x0
  pushl $66
c0102d8c:	6a 42                	push   $0x42
  jmp __alltraps
c0102d8e:	e9 89 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d93 <vector67>:
.globl vector67
vector67:
  pushl $0
c0102d93:	6a 00                	push   $0x0
  pushl $67
c0102d95:	6a 43                	push   $0x43
  jmp __alltraps
c0102d97:	e9 80 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102d9c <vector68>:
.globl vector68
vector68:
  pushl $0
c0102d9c:	6a 00                	push   $0x0
  pushl $68
c0102d9e:	6a 44                	push   $0x44
  jmp __alltraps
c0102da0:	e9 77 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102da5 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102da5:	6a 00                	push   $0x0
  pushl $69
c0102da7:	6a 45                	push   $0x45
  jmp __alltraps
c0102da9:	e9 6e fd ff ff       	jmp    c0102b1c <__alltraps>

c0102dae <vector70>:
.globl vector70
vector70:
  pushl $0
c0102dae:	6a 00                	push   $0x0
  pushl $70
c0102db0:	6a 46                	push   $0x46
  jmp __alltraps
c0102db2:	e9 65 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102db7 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102db7:	6a 00                	push   $0x0
  pushl $71
c0102db9:	6a 47                	push   $0x47
  jmp __alltraps
c0102dbb:	e9 5c fd ff ff       	jmp    c0102b1c <__alltraps>

c0102dc0 <vector72>:
.globl vector72
vector72:
  pushl $0
c0102dc0:	6a 00                	push   $0x0
  pushl $72
c0102dc2:	6a 48                	push   $0x48
  jmp __alltraps
c0102dc4:	e9 53 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102dc9 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102dc9:	6a 00                	push   $0x0
  pushl $73
c0102dcb:	6a 49                	push   $0x49
  jmp __alltraps
c0102dcd:	e9 4a fd ff ff       	jmp    c0102b1c <__alltraps>

c0102dd2 <vector74>:
.globl vector74
vector74:
  pushl $0
c0102dd2:	6a 00                	push   $0x0
  pushl $74
c0102dd4:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102dd6:	e9 41 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102ddb <vector75>:
.globl vector75
vector75:
  pushl $0
c0102ddb:	6a 00                	push   $0x0
  pushl $75
c0102ddd:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102ddf:	e9 38 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102de4 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102de4:	6a 00                	push   $0x0
  pushl $76
c0102de6:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102de8:	e9 2f fd ff ff       	jmp    c0102b1c <__alltraps>

c0102ded <vector77>:
.globl vector77
vector77:
  pushl $0
c0102ded:	6a 00                	push   $0x0
  pushl $77
c0102def:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102df1:	e9 26 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102df6 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102df6:	6a 00                	push   $0x0
  pushl $78
c0102df8:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102dfa:	e9 1d fd ff ff       	jmp    c0102b1c <__alltraps>

c0102dff <vector79>:
.globl vector79
vector79:
  pushl $0
c0102dff:	6a 00                	push   $0x0
  pushl $79
c0102e01:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102e03:	e9 14 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102e08 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102e08:	6a 00                	push   $0x0
  pushl $80
c0102e0a:	6a 50                	push   $0x50
  jmp __alltraps
c0102e0c:	e9 0b fd ff ff       	jmp    c0102b1c <__alltraps>

c0102e11 <vector81>:
.globl vector81
vector81:
  pushl $0
c0102e11:	6a 00                	push   $0x0
  pushl $81
c0102e13:	6a 51                	push   $0x51
  jmp __alltraps
c0102e15:	e9 02 fd ff ff       	jmp    c0102b1c <__alltraps>

c0102e1a <vector82>:
.globl vector82
vector82:
  pushl $0
c0102e1a:	6a 00                	push   $0x0
  pushl $82
c0102e1c:	6a 52                	push   $0x52
  jmp __alltraps
c0102e1e:	e9 f9 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e23 <vector83>:
.globl vector83
vector83:
  pushl $0
c0102e23:	6a 00                	push   $0x0
  pushl $83
c0102e25:	6a 53                	push   $0x53
  jmp __alltraps
c0102e27:	e9 f0 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e2c <vector84>:
.globl vector84
vector84:
  pushl $0
c0102e2c:	6a 00                	push   $0x0
  pushl $84
c0102e2e:	6a 54                	push   $0x54
  jmp __alltraps
c0102e30:	e9 e7 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e35 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102e35:	6a 00                	push   $0x0
  pushl $85
c0102e37:	6a 55                	push   $0x55
  jmp __alltraps
c0102e39:	e9 de fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e3e <vector86>:
.globl vector86
vector86:
  pushl $0
c0102e3e:	6a 00                	push   $0x0
  pushl $86
c0102e40:	6a 56                	push   $0x56
  jmp __alltraps
c0102e42:	e9 d5 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e47 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102e47:	6a 00                	push   $0x0
  pushl $87
c0102e49:	6a 57                	push   $0x57
  jmp __alltraps
c0102e4b:	e9 cc fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e50 <vector88>:
.globl vector88
vector88:
  pushl $0
c0102e50:	6a 00                	push   $0x0
  pushl $88
c0102e52:	6a 58                	push   $0x58
  jmp __alltraps
c0102e54:	e9 c3 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e59 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102e59:	6a 00                	push   $0x0
  pushl $89
c0102e5b:	6a 59                	push   $0x59
  jmp __alltraps
c0102e5d:	e9 ba fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e62 <vector90>:
.globl vector90
vector90:
  pushl $0
c0102e62:	6a 00                	push   $0x0
  pushl $90
c0102e64:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102e66:	e9 b1 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e6b <vector91>:
.globl vector91
vector91:
  pushl $0
c0102e6b:	6a 00                	push   $0x0
  pushl $91
c0102e6d:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102e6f:	e9 a8 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e74 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102e74:	6a 00                	push   $0x0
  pushl $92
c0102e76:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102e78:	e9 9f fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e7d <vector93>:
.globl vector93
vector93:
  pushl $0
c0102e7d:	6a 00                	push   $0x0
  pushl $93
c0102e7f:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102e81:	e9 96 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e86 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102e86:	6a 00                	push   $0x0
  pushl $94
c0102e88:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102e8a:	e9 8d fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e8f <vector95>:
.globl vector95
vector95:
  pushl $0
c0102e8f:	6a 00                	push   $0x0
  pushl $95
c0102e91:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102e93:	e9 84 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102e98 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102e98:	6a 00                	push   $0x0
  pushl $96
c0102e9a:	6a 60                	push   $0x60
  jmp __alltraps
c0102e9c:	e9 7b fc ff ff       	jmp    c0102b1c <__alltraps>

c0102ea1 <vector97>:
.globl vector97
vector97:
  pushl $0
c0102ea1:	6a 00                	push   $0x0
  pushl $97
c0102ea3:	6a 61                	push   $0x61
  jmp __alltraps
c0102ea5:	e9 72 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102eaa <vector98>:
.globl vector98
vector98:
  pushl $0
c0102eaa:	6a 00                	push   $0x0
  pushl $98
c0102eac:	6a 62                	push   $0x62
  jmp __alltraps
c0102eae:	e9 69 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102eb3 <vector99>:
.globl vector99
vector99:
  pushl $0
c0102eb3:	6a 00                	push   $0x0
  pushl $99
c0102eb5:	6a 63                	push   $0x63
  jmp __alltraps
c0102eb7:	e9 60 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102ebc <vector100>:
.globl vector100
vector100:
  pushl $0
c0102ebc:	6a 00                	push   $0x0
  pushl $100
c0102ebe:	6a 64                	push   $0x64
  jmp __alltraps
c0102ec0:	e9 57 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102ec5 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102ec5:	6a 00                	push   $0x0
  pushl $101
c0102ec7:	6a 65                	push   $0x65
  jmp __alltraps
c0102ec9:	e9 4e fc ff ff       	jmp    c0102b1c <__alltraps>

c0102ece <vector102>:
.globl vector102
vector102:
  pushl $0
c0102ece:	6a 00                	push   $0x0
  pushl $102
c0102ed0:	6a 66                	push   $0x66
  jmp __alltraps
c0102ed2:	e9 45 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102ed7 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102ed7:	6a 00                	push   $0x0
  pushl $103
c0102ed9:	6a 67                	push   $0x67
  jmp __alltraps
c0102edb:	e9 3c fc ff ff       	jmp    c0102b1c <__alltraps>

c0102ee0 <vector104>:
.globl vector104
vector104:
  pushl $0
c0102ee0:	6a 00                	push   $0x0
  pushl $104
c0102ee2:	6a 68                	push   $0x68
  jmp __alltraps
c0102ee4:	e9 33 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102ee9 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102ee9:	6a 00                	push   $0x0
  pushl $105
c0102eeb:	6a 69                	push   $0x69
  jmp __alltraps
c0102eed:	e9 2a fc ff ff       	jmp    c0102b1c <__alltraps>

c0102ef2 <vector106>:
.globl vector106
vector106:
  pushl $0
c0102ef2:	6a 00                	push   $0x0
  pushl $106
c0102ef4:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102ef6:	e9 21 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102efb <vector107>:
.globl vector107
vector107:
  pushl $0
c0102efb:	6a 00                	push   $0x0
  pushl $107
c0102efd:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102eff:	e9 18 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102f04 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102f04:	6a 00                	push   $0x0
  pushl $108
c0102f06:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102f08:	e9 0f fc ff ff       	jmp    c0102b1c <__alltraps>

c0102f0d <vector109>:
.globl vector109
vector109:
  pushl $0
c0102f0d:	6a 00                	push   $0x0
  pushl $109
c0102f0f:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102f11:	e9 06 fc ff ff       	jmp    c0102b1c <__alltraps>

c0102f16 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102f16:	6a 00                	push   $0x0
  pushl $110
c0102f18:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102f1a:	e9 fd fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f1f <vector111>:
.globl vector111
vector111:
  pushl $0
c0102f1f:	6a 00                	push   $0x0
  pushl $111
c0102f21:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102f23:	e9 f4 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f28 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102f28:	6a 00                	push   $0x0
  pushl $112
c0102f2a:	6a 70                	push   $0x70
  jmp __alltraps
c0102f2c:	e9 eb fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f31 <vector113>:
.globl vector113
vector113:
  pushl $0
c0102f31:	6a 00                	push   $0x0
  pushl $113
c0102f33:	6a 71                	push   $0x71
  jmp __alltraps
c0102f35:	e9 e2 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f3a <vector114>:
.globl vector114
vector114:
  pushl $0
c0102f3a:	6a 00                	push   $0x0
  pushl $114
c0102f3c:	6a 72                	push   $0x72
  jmp __alltraps
c0102f3e:	e9 d9 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f43 <vector115>:
.globl vector115
vector115:
  pushl $0
c0102f43:	6a 00                	push   $0x0
  pushl $115
c0102f45:	6a 73                	push   $0x73
  jmp __alltraps
c0102f47:	e9 d0 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f4c <vector116>:
.globl vector116
vector116:
  pushl $0
c0102f4c:	6a 00                	push   $0x0
  pushl $116
c0102f4e:	6a 74                	push   $0x74
  jmp __alltraps
c0102f50:	e9 c7 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f55 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102f55:	6a 00                	push   $0x0
  pushl $117
c0102f57:	6a 75                	push   $0x75
  jmp __alltraps
c0102f59:	e9 be fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f5e <vector118>:
.globl vector118
vector118:
  pushl $0
c0102f5e:	6a 00                	push   $0x0
  pushl $118
c0102f60:	6a 76                	push   $0x76
  jmp __alltraps
c0102f62:	e9 b5 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f67 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102f67:	6a 00                	push   $0x0
  pushl $119
c0102f69:	6a 77                	push   $0x77
  jmp __alltraps
c0102f6b:	e9 ac fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f70 <vector120>:
.globl vector120
vector120:
  pushl $0
c0102f70:	6a 00                	push   $0x0
  pushl $120
c0102f72:	6a 78                	push   $0x78
  jmp __alltraps
c0102f74:	e9 a3 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f79 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102f79:	6a 00                	push   $0x0
  pushl $121
c0102f7b:	6a 79                	push   $0x79
  jmp __alltraps
c0102f7d:	e9 9a fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f82 <vector122>:
.globl vector122
vector122:
  pushl $0
c0102f82:	6a 00                	push   $0x0
  pushl $122
c0102f84:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102f86:	e9 91 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f8b <vector123>:
.globl vector123
vector123:
  pushl $0
c0102f8b:	6a 00                	push   $0x0
  pushl $123
c0102f8d:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102f8f:	e9 88 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f94 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102f94:	6a 00                	push   $0x0
  pushl $124
c0102f96:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102f98:	e9 7f fb ff ff       	jmp    c0102b1c <__alltraps>

c0102f9d <vector125>:
.globl vector125
vector125:
  pushl $0
c0102f9d:	6a 00                	push   $0x0
  pushl $125
c0102f9f:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102fa1:	e9 76 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102fa6 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102fa6:	6a 00                	push   $0x0
  pushl $126
c0102fa8:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102faa:	e9 6d fb ff ff       	jmp    c0102b1c <__alltraps>

c0102faf <vector127>:
.globl vector127
vector127:
  pushl $0
c0102faf:	6a 00                	push   $0x0
  pushl $127
c0102fb1:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102fb3:	e9 64 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102fb8 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102fb8:	6a 00                	push   $0x0
  pushl $128
c0102fba:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102fbf:	e9 58 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102fc4 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102fc4:	6a 00                	push   $0x0
  pushl $129
c0102fc6:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102fcb:	e9 4c fb ff ff       	jmp    c0102b1c <__alltraps>

c0102fd0 <vector130>:
.globl vector130
vector130:
  pushl $0
c0102fd0:	6a 00                	push   $0x0
  pushl $130
c0102fd2:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102fd7:	e9 40 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102fdc <vector131>:
.globl vector131
vector131:
  pushl $0
c0102fdc:	6a 00                	push   $0x0
  pushl $131
c0102fde:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102fe3:	e9 34 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102fe8 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102fe8:	6a 00                	push   $0x0
  pushl $132
c0102fea:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102fef:	e9 28 fb ff ff       	jmp    c0102b1c <__alltraps>

c0102ff4 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102ff4:	6a 00                	push   $0x0
  pushl $133
c0102ff6:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102ffb:	e9 1c fb ff ff       	jmp    c0102b1c <__alltraps>

c0103000 <vector134>:
.globl vector134
vector134:
  pushl $0
c0103000:	6a 00                	push   $0x0
  pushl $134
c0103002:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0103007:	e9 10 fb ff ff       	jmp    c0102b1c <__alltraps>

c010300c <vector135>:
.globl vector135
vector135:
  pushl $0
c010300c:	6a 00                	push   $0x0
  pushl $135
c010300e:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0103013:	e9 04 fb ff ff       	jmp    c0102b1c <__alltraps>

c0103018 <vector136>:
.globl vector136
vector136:
  pushl $0
c0103018:	6a 00                	push   $0x0
  pushl $136
c010301a:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c010301f:	e9 f8 fa ff ff       	jmp    c0102b1c <__alltraps>

c0103024 <vector137>:
.globl vector137
vector137:
  pushl $0
c0103024:	6a 00                	push   $0x0
  pushl $137
c0103026:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c010302b:	e9 ec fa ff ff       	jmp    c0102b1c <__alltraps>

c0103030 <vector138>:
.globl vector138
vector138:
  pushl $0
c0103030:	6a 00                	push   $0x0
  pushl $138
c0103032:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0103037:	e9 e0 fa ff ff       	jmp    c0102b1c <__alltraps>

c010303c <vector139>:
.globl vector139
vector139:
  pushl $0
c010303c:	6a 00                	push   $0x0
  pushl $139
c010303e:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0103043:	e9 d4 fa ff ff       	jmp    c0102b1c <__alltraps>

c0103048 <vector140>:
.globl vector140
vector140:
  pushl $0
c0103048:	6a 00                	push   $0x0
  pushl $140
c010304a:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c010304f:	e9 c8 fa ff ff       	jmp    c0102b1c <__alltraps>

c0103054 <vector141>:
.globl vector141
vector141:
  pushl $0
c0103054:	6a 00                	push   $0x0
  pushl $141
c0103056:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c010305b:	e9 bc fa ff ff       	jmp    c0102b1c <__alltraps>

c0103060 <vector142>:
.globl vector142
vector142:
  pushl $0
c0103060:	6a 00                	push   $0x0
  pushl $142
c0103062:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0103067:	e9 b0 fa ff ff       	jmp    c0102b1c <__alltraps>

c010306c <vector143>:
.globl vector143
vector143:
  pushl $0
c010306c:	6a 00                	push   $0x0
  pushl $143
c010306e:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0103073:	e9 a4 fa ff ff       	jmp    c0102b1c <__alltraps>

c0103078 <vector144>:
.globl vector144
vector144:
  pushl $0
c0103078:	6a 00                	push   $0x0
  pushl $144
c010307a:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c010307f:	e9 98 fa ff ff       	jmp    c0102b1c <__alltraps>

c0103084 <vector145>:
.globl vector145
vector145:
  pushl $0
c0103084:	6a 00                	push   $0x0
  pushl $145
c0103086:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c010308b:	e9 8c fa ff ff       	jmp    c0102b1c <__alltraps>

c0103090 <vector146>:
.globl vector146
vector146:
  pushl $0
c0103090:	6a 00                	push   $0x0
  pushl $146
c0103092:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0103097:	e9 80 fa ff ff       	jmp    c0102b1c <__alltraps>

c010309c <vector147>:
.globl vector147
vector147:
  pushl $0
c010309c:	6a 00                	push   $0x0
  pushl $147
c010309e:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c01030a3:	e9 74 fa ff ff       	jmp    c0102b1c <__alltraps>

c01030a8 <vector148>:
.globl vector148
vector148:
  pushl $0
c01030a8:	6a 00                	push   $0x0
  pushl $148
c01030aa:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c01030af:	e9 68 fa ff ff       	jmp    c0102b1c <__alltraps>

c01030b4 <vector149>:
.globl vector149
vector149:
  pushl $0
c01030b4:	6a 00                	push   $0x0
  pushl $149
c01030b6:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c01030bb:	e9 5c fa ff ff       	jmp    c0102b1c <__alltraps>

c01030c0 <vector150>:
.globl vector150
vector150:
  pushl $0
c01030c0:	6a 00                	push   $0x0
  pushl $150
c01030c2:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c01030c7:	e9 50 fa ff ff       	jmp    c0102b1c <__alltraps>

c01030cc <vector151>:
.globl vector151
vector151:
  pushl $0
c01030cc:	6a 00                	push   $0x0
  pushl $151
c01030ce:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c01030d3:	e9 44 fa ff ff       	jmp    c0102b1c <__alltraps>

c01030d8 <vector152>:
.globl vector152
vector152:
  pushl $0
c01030d8:	6a 00                	push   $0x0
  pushl $152
c01030da:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c01030df:	e9 38 fa ff ff       	jmp    c0102b1c <__alltraps>

c01030e4 <vector153>:
.globl vector153
vector153:
  pushl $0
c01030e4:	6a 00                	push   $0x0
  pushl $153
c01030e6:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c01030eb:	e9 2c fa ff ff       	jmp    c0102b1c <__alltraps>

c01030f0 <vector154>:
.globl vector154
vector154:
  pushl $0
c01030f0:	6a 00                	push   $0x0
  pushl $154
c01030f2:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c01030f7:	e9 20 fa ff ff       	jmp    c0102b1c <__alltraps>

c01030fc <vector155>:
.globl vector155
vector155:
  pushl $0
c01030fc:	6a 00                	push   $0x0
  pushl $155
c01030fe:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0103103:	e9 14 fa ff ff       	jmp    c0102b1c <__alltraps>

c0103108 <vector156>:
.globl vector156
vector156:
  pushl $0
c0103108:	6a 00                	push   $0x0
  pushl $156
c010310a:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c010310f:	e9 08 fa ff ff       	jmp    c0102b1c <__alltraps>

c0103114 <vector157>:
.globl vector157
vector157:
  pushl $0
c0103114:	6a 00                	push   $0x0
  pushl $157
c0103116:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c010311b:	e9 fc f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103120 <vector158>:
.globl vector158
vector158:
  pushl $0
c0103120:	6a 00                	push   $0x0
  pushl $158
c0103122:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0103127:	e9 f0 f9 ff ff       	jmp    c0102b1c <__alltraps>

c010312c <vector159>:
.globl vector159
vector159:
  pushl $0
c010312c:	6a 00                	push   $0x0
  pushl $159
c010312e:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0103133:	e9 e4 f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103138 <vector160>:
.globl vector160
vector160:
  pushl $0
c0103138:	6a 00                	push   $0x0
  pushl $160
c010313a:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c010313f:	e9 d8 f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103144 <vector161>:
.globl vector161
vector161:
  pushl $0
c0103144:	6a 00                	push   $0x0
  pushl $161
c0103146:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c010314b:	e9 cc f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103150 <vector162>:
.globl vector162
vector162:
  pushl $0
c0103150:	6a 00                	push   $0x0
  pushl $162
c0103152:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0103157:	e9 c0 f9 ff ff       	jmp    c0102b1c <__alltraps>

c010315c <vector163>:
.globl vector163
vector163:
  pushl $0
c010315c:	6a 00                	push   $0x0
  pushl $163
c010315e:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0103163:	e9 b4 f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103168 <vector164>:
.globl vector164
vector164:
  pushl $0
c0103168:	6a 00                	push   $0x0
  pushl $164
c010316a:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c010316f:	e9 a8 f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103174 <vector165>:
.globl vector165
vector165:
  pushl $0
c0103174:	6a 00                	push   $0x0
  pushl $165
c0103176:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c010317b:	e9 9c f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103180 <vector166>:
.globl vector166
vector166:
  pushl $0
c0103180:	6a 00                	push   $0x0
  pushl $166
c0103182:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0103187:	e9 90 f9 ff ff       	jmp    c0102b1c <__alltraps>

c010318c <vector167>:
.globl vector167
vector167:
  pushl $0
c010318c:	6a 00                	push   $0x0
  pushl $167
c010318e:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0103193:	e9 84 f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103198 <vector168>:
.globl vector168
vector168:
  pushl $0
c0103198:	6a 00                	push   $0x0
  pushl $168
c010319a:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c010319f:	e9 78 f9 ff ff       	jmp    c0102b1c <__alltraps>

c01031a4 <vector169>:
.globl vector169
vector169:
  pushl $0
c01031a4:	6a 00                	push   $0x0
  pushl $169
c01031a6:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c01031ab:	e9 6c f9 ff ff       	jmp    c0102b1c <__alltraps>

c01031b0 <vector170>:
.globl vector170
vector170:
  pushl $0
c01031b0:	6a 00                	push   $0x0
  pushl $170
c01031b2:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c01031b7:	e9 60 f9 ff ff       	jmp    c0102b1c <__alltraps>

c01031bc <vector171>:
.globl vector171
vector171:
  pushl $0
c01031bc:	6a 00                	push   $0x0
  pushl $171
c01031be:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c01031c3:	e9 54 f9 ff ff       	jmp    c0102b1c <__alltraps>

c01031c8 <vector172>:
.globl vector172
vector172:
  pushl $0
c01031c8:	6a 00                	push   $0x0
  pushl $172
c01031ca:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c01031cf:	e9 48 f9 ff ff       	jmp    c0102b1c <__alltraps>

c01031d4 <vector173>:
.globl vector173
vector173:
  pushl $0
c01031d4:	6a 00                	push   $0x0
  pushl $173
c01031d6:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c01031db:	e9 3c f9 ff ff       	jmp    c0102b1c <__alltraps>

c01031e0 <vector174>:
.globl vector174
vector174:
  pushl $0
c01031e0:	6a 00                	push   $0x0
  pushl $174
c01031e2:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c01031e7:	e9 30 f9 ff ff       	jmp    c0102b1c <__alltraps>

c01031ec <vector175>:
.globl vector175
vector175:
  pushl $0
c01031ec:	6a 00                	push   $0x0
  pushl $175
c01031ee:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c01031f3:	e9 24 f9 ff ff       	jmp    c0102b1c <__alltraps>

c01031f8 <vector176>:
.globl vector176
vector176:
  pushl $0
c01031f8:	6a 00                	push   $0x0
  pushl $176
c01031fa:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c01031ff:	e9 18 f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103204 <vector177>:
.globl vector177
vector177:
  pushl $0
c0103204:	6a 00                	push   $0x0
  pushl $177
c0103206:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c010320b:	e9 0c f9 ff ff       	jmp    c0102b1c <__alltraps>

c0103210 <vector178>:
.globl vector178
vector178:
  pushl $0
c0103210:	6a 00                	push   $0x0
  pushl $178
c0103212:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0103217:	e9 00 f9 ff ff       	jmp    c0102b1c <__alltraps>

c010321c <vector179>:
.globl vector179
vector179:
  pushl $0
c010321c:	6a 00                	push   $0x0
  pushl $179
c010321e:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0103223:	e9 f4 f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103228 <vector180>:
.globl vector180
vector180:
  pushl $0
c0103228:	6a 00                	push   $0x0
  pushl $180
c010322a:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c010322f:	e9 e8 f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103234 <vector181>:
.globl vector181
vector181:
  pushl $0
c0103234:	6a 00                	push   $0x0
  pushl $181
c0103236:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c010323b:	e9 dc f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103240 <vector182>:
.globl vector182
vector182:
  pushl $0
c0103240:	6a 00                	push   $0x0
  pushl $182
c0103242:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0103247:	e9 d0 f8 ff ff       	jmp    c0102b1c <__alltraps>

c010324c <vector183>:
.globl vector183
vector183:
  pushl $0
c010324c:	6a 00                	push   $0x0
  pushl $183
c010324e:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0103253:	e9 c4 f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103258 <vector184>:
.globl vector184
vector184:
  pushl $0
c0103258:	6a 00                	push   $0x0
  pushl $184
c010325a:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c010325f:	e9 b8 f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103264 <vector185>:
.globl vector185
vector185:
  pushl $0
c0103264:	6a 00                	push   $0x0
  pushl $185
c0103266:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c010326b:	e9 ac f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103270 <vector186>:
.globl vector186
vector186:
  pushl $0
c0103270:	6a 00                	push   $0x0
  pushl $186
c0103272:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0103277:	e9 a0 f8 ff ff       	jmp    c0102b1c <__alltraps>

c010327c <vector187>:
.globl vector187
vector187:
  pushl $0
c010327c:	6a 00                	push   $0x0
  pushl $187
c010327e:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0103283:	e9 94 f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103288 <vector188>:
.globl vector188
vector188:
  pushl $0
c0103288:	6a 00                	push   $0x0
  pushl $188
c010328a:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010328f:	e9 88 f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103294 <vector189>:
.globl vector189
vector189:
  pushl $0
c0103294:	6a 00                	push   $0x0
  pushl $189
c0103296:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c010329b:	e9 7c f8 ff ff       	jmp    c0102b1c <__alltraps>

c01032a0 <vector190>:
.globl vector190
vector190:
  pushl $0
c01032a0:	6a 00                	push   $0x0
  pushl $190
c01032a2:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c01032a7:	e9 70 f8 ff ff       	jmp    c0102b1c <__alltraps>

c01032ac <vector191>:
.globl vector191
vector191:
  pushl $0
c01032ac:	6a 00                	push   $0x0
  pushl $191
c01032ae:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c01032b3:	e9 64 f8 ff ff       	jmp    c0102b1c <__alltraps>

c01032b8 <vector192>:
.globl vector192
vector192:
  pushl $0
c01032b8:	6a 00                	push   $0x0
  pushl $192
c01032ba:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c01032bf:	e9 58 f8 ff ff       	jmp    c0102b1c <__alltraps>

c01032c4 <vector193>:
.globl vector193
vector193:
  pushl $0
c01032c4:	6a 00                	push   $0x0
  pushl $193
c01032c6:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c01032cb:	e9 4c f8 ff ff       	jmp    c0102b1c <__alltraps>

c01032d0 <vector194>:
.globl vector194
vector194:
  pushl $0
c01032d0:	6a 00                	push   $0x0
  pushl $194
c01032d2:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c01032d7:	e9 40 f8 ff ff       	jmp    c0102b1c <__alltraps>

c01032dc <vector195>:
.globl vector195
vector195:
  pushl $0
c01032dc:	6a 00                	push   $0x0
  pushl $195
c01032de:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c01032e3:	e9 34 f8 ff ff       	jmp    c0102b1c <__alltraps>

c01032e8 <vector196>:
.globl vector196
vector196:
  pushl $0
c01032e8:	6a 00                	push   $0x0
  pushl $196
c01032ea:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c01032ef:	e9 28 f8 ff ff       	jmp    c0102b1c <__alltraps>

c01032f4 <vector197>:
.globl vector197
vector197:
  pushl $0
c01032f4:	6a 00                	push   $0x0
  pushl $197
c01032f6:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c01032fb:	e9 1c f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103300 <vector198>:
.globl vector198
vector198:
  pushl $0
c0103300:	6a 00                	push   $0x0
  pushl $198
c0103302:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103307:	e9 10 f8 ff ff       	jmp    c0102b1c <__alltraps>

c010330c <vector199>:
.globl vector199
vector199:
  pushl $0
c010330c:	6a 00                	push   $0x0
  pushl $199
c010330e:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c0103313:	e9 04 f8 ff ff       	jmp    c0102b1c <__alltraps>

c0103318 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103318:	6a 00                	push   $0x0
  pushl $200
c010331a:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010331f:	e9 f8 f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103324 <vector201>:
.globl vector201
vector201:
  pushl $0
c0103324:	6a 00                	push   $0x0
  pushl $201
c0103326:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c010332b:	e9 ec f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103330 <vector202>:
.globl vector202
vector202:
  pushl $0
c0103330:	6a 00                	push   $0x0
  pushl $202
c0103332:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c0103337:	e9 e0 f7 ff ff       	jmp    c0102b1c <__alltraps>

c010333c <vector203>:
.globl vector203
vector203:
  pushl $0
c010333c:	6a 00                	push   $0x0
  pushl $203
c010333e:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c0103343:	e9 d4 f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103348 <vector204>:
.globl vector204
vector204:
  pushl $0
c0103348:	6a 00                	push   $0x0
  pushl $204
c010334a:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c010334f:	e9 c8 f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103354 <vector205>:
.globl vector205
vector205:
  pushl $0
c0103354:	6a 00                	push   $0x0
  pushl $205
c0103356:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c010335b:	e9 bc f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103360 <vector206>:
.globl vector206
vector206:
  pushl $0
c0103360:	6a 00                	push   $0x0
  pushl $206
c0103362:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c0103367:	e9 b0 f7 ff ff       	jmp    c0102b1c <__alltraps>

c010336c <vector207>:
.globl vector207
vector207:
  pushl $0
c010336c:	6a 00                	push   $0x0
  pushl $207
c010336e:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c0103373:	e9 a4 f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103378 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103378:	6a 00                	push   $0x0
  pushl $208
c010337a:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010337f:	e9 98 f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103384 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103384:	6a 00                	push   $0x0
  pushl $209
c0103386:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c010338b:	e9 8c f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103390 <vector210>:
.globl vector210
vector210:
  pushl $0
c0103390:	6a 00                	push   $0x0
  pushl $210
c0103392:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103397:	e9 80 f7 ff ff       	jmp    c0102b1c <__alltraps>

c010339c <vector211>:
.globl vector211
vector211:
  pushl $0
c010339c:	6a 00                	push   $0x0
  pushl $211
c010339e:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c01033a3:	e9 74 f7 ff ff       	jmp    c0102b1c <__alltraps>

c01033a8 <vector212>:
.globl vector212
vector212:
  pushl $0
c01033a8:	6a 00                	push   $0x0
  pushl $212
c01033aa:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c01033af:	e9 68 f7 ff ff       	jmp    c0102b1c <__alltraps>

c01033b4 <vector213>:
.globl vector213
vector213:
  pushl $0
c01033b4:	6a 00                	push   $0x0
  pushl $213
c01033b6:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c01033bb:	e9 5c f7 ff ff       	jmp    c0102b1c <__alltraps>

c01033c0 <vector214>:
.globl vector214
vector214:
  pushl $0
c01033c0:	6a 00                	push   $0x0
  pushl $214
c01033c2:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c01033c7:	e9 50 f7 ff ff       	jmp    c0102b1c <__alltraps>

c01033cc <vector215>:
.globl vector215
vector215:
  pushl $0
c01033cc:	6a 00                	push   $0x0
  pushl $215
c01033ce:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c01033d3:	e9 44 f7 ff ff       	jmp    c0102b1c <__alltraps>

c01033d8 <vector216>:
.globl vector216
vector216:
  pushl $0
c01033d8:	6a 00                	push   $0x0
  pushl $216
c01033da:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c01033df:	e9 38 f7 ff ff       	jmp    c0102b1c <__alltraps>

c01033e4 <vector217>:
.globl vector217
vector217:
  pushl $0
c01033e4:	6a 00                	push   $0x0
  pushl $217
c01033e6:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c01033eb:	e9 2c f7 ff ff       	jmp    c0102b1c <__alltraps>

c01033f0 <vector218>:
.globl vector218
vector218:
  pushl $0
c01033f0:	6a 00                	push   $0x0
  pushl $218
c01033f2:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c01033f7:	e9 20 f7 ff ff       	jmp    c0102b1c <__alltraps>

c01033fc <vector219>:
.globl vector219
vector219:
  pushl $0
c01033fc:	6a 00                	push   $0x0
  pushl $219
c01033fe:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c0103403:	e9 14 f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103408 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103408:	6a 00                	push   $0x0
  pushl $220
c010340a:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010340f:	e9 08 f7 ff ff       	jmp    c0102b1c <__alltraps>

c0103414 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103414:	6a 00                	push   $0x0
  pushl $221
c0103416:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c010341b:	e9 fc f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103420 <vector222>:
.globl vector222
vector222:
  pushl $0
c0103420:	6a 00                	push   $0x0
  pushl $222
c0103422:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c0103427:	e9 f0 f6 ff ff       	jmp    c0102b1c <__alltraps>

c010342c <vector223>:
.globl vector223
vector223:
  pushl $0
c010342c:	6a 00                	push   $0x0
  pushl $223
c010342e:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c0103433:	e9 e4 f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103438 <vector224>:
.globl vector224
vector224:
  pushl $0
c0103438:	6a 00                	push   $0x0
  pushl $224
c010343a:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c010343f:	e9 d8 f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103444 <vector225>:
.globl vector225
vector225:
  pushl $0
c0103444:	6a 00                	push   $0x0
  pushl $225
c0103446:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c010344b:	e9 cc f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103450 <vector226>:
.globl vector226
vector226:
  pushl $0
c0103450:	6a 00                	push   $0x0
  pushl $226
c0103452:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c0103457:	e9 c0 f6 ff ff       	jmp    c0102b1c <__alltraps>

c010345c <vector227>:
.globl vector227
vector227:
  pushl $0
c010345c:	6a 00                	push   $0x0
  pushl $227
c010345e:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c0103463:	e9 b4 f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103468 <vector228>:
.globl vector228
vector228:
  pushl $0
c0103468:	6a 00                	push   $0x0
  pushl $228
c010346a:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c010346f:	e9 a8 f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103474 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103474:	6a 00                	push   $0x0
  pushl $229
c0103476:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c010347b:	e9 9c f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103480 <vector230>:
.globl vector230
vector230:
  pushl $0
c0103480:	6a 00                	push   $0x0
  pushl $230
c0103482:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103487:	e9 90 f6 ff ff       	jmp    c0102b1c <__alltraps>

c010348c <vector231>:
.globl vector231
vector231:
  pushl $0
c010348c:	6a 00                	push   $0x0
  pushl $231
c010348e:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c0103493:	e9 84 f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103498 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103498:	6a 00                	push   $0x0
  pushl $232
c010349a:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010349f:	e9 78 f6 ff ff       	jmp    c0102b1c <__alltraps>

c01034a4 <vector233>:
.globl vector233
vector233:
  pushl $0
c01034a4:	6a 00                	push   $0x0
  pushl $233
c01034a6:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c01034ab:	e9 6c f6 ff ff       	jmp    c0102b1c <__alltraps>

c01034b0 <vector234>:
.globl vector234
vector234:
  pushl $0
c01034b0:	6a 00                	push   $0x0
  pushl $234
c01034b2:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c01034b7:	e9 60 f6 ff ff       	jmp    c0102b1c <__alltraps>

c01034bc <vector235>:
.globl vector235
vector235:
  pushl $0
c01034bc:	6a 00                	push   $0x0
  pushl $235
c01034be:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c01034c3:	e9 54 f6 ff ff       	jmp    c0102b1c <__alltraps>

c01034c8 <vector236>:
.globl vector236
vector236:
  pushl $0
c01034c8:	6a 00                	push   $0x0
  pushl $236
c01034ca:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c01034cf:	e9 48 f6 ff ff       	jmp    c0102b1c <__alltraps>

c01034d4 <vector237>:
.globl vector237
vector237:
  pushl $0
c01034d4:	6a 00                	push   $0x0
  pushl $237
c01034d6:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c01034db:	e9 3c f6 ff ff       	jmp    c0102b1c <__alltraps>

c01034e0 <vector238>:
.globl vector238
vector238:
  pushl $0
c01034e0:	6a 00                	push   $0x0
  pushl $238
c01034e2:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c01034e7:	e9 30 f6 ff ff       	jmp    c0102b1c <__alltraps>

c01034ec <vector239>:
.globl vector239
vector239:
  pushl $0
c01034ec:	6a 00                	push   $0x0
  pushl $239
c01034ee:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c01034f3:	e9 24 f6 ff ff       	jmp    c0102b1c <__alltraps>

c01034f8 <vector240>:
.globl vector240
vector240:
  pushl $0
c01034f8:	6a 00                	push   $0x0
  pushl $240
c01034fa:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c01034ff:	e9 18 f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103504 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103504:	6a 00                	push   $0x0
  pushl $241
c0103506:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c010350b:	e9 0c f6 ff ff       	jmp    c0102b1c <__alltraps>

c0103510 <vector242>:
.globl vector242
vector242:
  pushl $0
c0103510:	6a 00                	push   $0x0
  pushl $242
c0103512:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103517:	e9 00 f6 ff ff       	jmp    c0102b1c <__alltraps>

c010351c <vector243>:
.globl vector243
vector243:
  pushl $0
c010351c:	6a 00                	push   $0x0
  pushl $243
c010351e:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c0103523:	e9 f4 f5 ff ff       	jmp    c0102b1c <__alltraps>

c0103528 <vector244>:
.globl vector244
vector244:
  pushl $0
c0103528:	6a 00                	push   $0x0
  pushl $244
c010352a:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c010352f:	e9 e8 f5 ff ff       	jmp    c0102b1c <__alltraps>

c0103534 <vector245>:
.globl vector245
vector245:
  pushl $0
c0103534:	6a 00                	push   $0x0
  pushl $245
c0103536:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c010353b:	e9 dc f5 ff ff       	jmp    c0102b1c <__alltraps>

c0103540 <vector246>:
.globl vector246
vector246:
  pushl $0
c0103540:	6a 00                	push   $0x0
  pushl $246
c0103542:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c0103547:	e9 d0 f5 ff ff       	jmp    c0102b1c <__alltraps>

c010354c <vector247>:
.globl vector247
vector247:
  pushl $0
c010354c:	6a 00                	push   $0x0
  pushl $247
c010354e:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c0103553:	e9 c4 f5 ff ff       	jmp    c0102b1c <__alltraps>

c0103558 <vector248>:
.globl vector248
vector248:
  pushl $0
c0103558:	6a 00                	push   $0x0
  pushl $248
c010355a:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c010355f:	e9 b8 f5 ff ff       	jmp    c0102b1c <__alltraps>

c0103564 <vector249>:
.globl vector249
vector249:
  pushl $0
c0103564:	6a 00                	push   $0x0
  pushl $249
c0103566:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c010356b:	e9 ac f5 ff ff       	jmp    c0102b1c <__alltraps>

c0103570 <vector250>:
.globl vector250
vector250:
  pushl $0
c0103570:	6a 00                	push   $0x0
  pushl $250
c0103572:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103577:	e9 a0 f5 ff ff       	jmp    c0102b1c <__alltraps>

c010357c <vector251>:
.globl vector251
vector251:
  pushl $0
c010357c:	6a 00                	push   $0x0
  pushl $251
c010357e:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c0103583:	e9 94 f5 ff ff       	jmp    c0102b1c <__alltraps>

c0103588 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103588:	6a 00                	push   $0x0
  pushl $252
c010358a:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010358f:	e9 88 f5 ff ff       	jmp    c0102b1c <__alltraps>

c0103594 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103594:	6a 00                	push   $0x0
  pushl $253
c0103596:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c010359b:	e9 7c f5 ff ff       	jmp    c0102b1c <__alltraps>

c01035a0 <vector254>:
.globl vector254
vector254:
  pushl $0
c01035a0:	6a 00                	push   $0x0
  pushl $254
c01035a2:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c01035a7:	e9 70 f5 ff ff       	jmp    c0102b1c <__alltraps>

c01035ac <vector255>:
.globl vector255
vector255:
  pushl $0
c01035ac:	6a 00                	push   $0x0
  pushl $255
c01035ae:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c01035b3:	e9 64 f5 ff ff       	jmp    c0102b1c <__alltraps>

c01035b8 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01035b8:	55                   	push   %ebp
c01035b9:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01035bb:	8b 55 08             	mov    0x8(%ebp),%edx
c01035be:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c01035c3:	89 d1                	mov    %edx,%ecx
c01035c5:	29 c1                	sub    %eax,%ecx
c01035c7:	89 c8                	mov    %ecx,%eax
c01035c9:	c1 f8 05             	sar    $0x5,%eax
}
c01035cc:	5d                   	pop    %ebp
c01035cd:	c3                   	ret    

c01035ce <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01035ce:	55                   	push   %ebp
c01035cf:	89 e5                	mov    %esp,%ebp
c01035d1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01035d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01035d7:	89 04 24             	mov    %eax,(%esp)
c01035da:	e8 d9 ff ff ff       	call   c01035b8 <page2ppn>
c01035df:	c1 e0 0c             	shl    $0xc,%eax
}
c01035e2:	c9                   	leave  
c01035e3:	c3                   	ret    

c01035e4 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c01035e4:	55                   	push   %ebp
c01035e5:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01035e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01035ea:	8b 00                	mov    (%eax),%eax
}
c01035ec:	5d                   	pop    %ebp
c01035ed:	c3                   	ret    

c01035ee <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01035ee:	55                   	push   %ebp
c01035ef:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01035f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01035f4:	8b 55 0c             	mov    0xc(%ebp),%edx
c01035f7:	89 10                	mov    %edx,(%eax)
}
c01035f9:	5d                   	pop    %ebp
c01035fa:	c3                   	ret    

c01035fb <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c01035fb:	55                   	push   %ebp
c01035fc:	89 e5                	mov    %esp,%ebp
c01035fe:	83 ec 10             	sub    $0x10,%esp
c0103601:	c7 45 fc b8 ee 19 c0 	movl   $0xc019eeb8,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103608:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010360b:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010360e:	89 50 04             	mov    %edx,0x4(%eax)
c0103611:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103614:	8b 50 04             	mov    0x4(%eax),%edx
c0103617:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010361a:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c010361c:	c7 05 c0 ee 19 c0 00 	movl   $0x0,0xc019eec0
c0103623:	00 00 00 
}
c0103626:	c9                   	leave  
c0103627:	c3                   	ret    

c0103628 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c0103628:	55                   	push   %ebp
c0103629:	89 e5                	mov    %esp,%ebp
c010362b:	53                   	push   %ebx
c010362c:	83 ec 44             	sub    $0x44,%esp
    assert(n > 0);
c010362f:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103633:	75 24                	jne    c0103659 <default_init_memmap+0x31>
c0103635:	c7 44 24 0c 70 c9 10 	movl   $0xc010c970,0xc(%esp)
c010363c:	c0 
c010363d:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103644:	c0 
c0103645:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c010364c:	00 
c010364d:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103654:	e8 5f d7 ff ff       	call   c0100db8 <__panic>
    struct Page *p = base;
c0103659:	8b 45 08             	mov    0x8(%ebp),%eax
c010365c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    for (; p != base + n; p ++) {
c010365f:	e9 dc 00 00 00       	jmp    c0103740 <default_init_memmap+0x118>
        assert(PageReserved(p));
c0103664:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103667:	83 c0 04             	add    $0x4,%eax
c010366a:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103671:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103674:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103677:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010367a:	0f a3 10             	bt     %edx,(%eax)
c010367d:	19 db                	sbb    %ebx,%ebx
c010367f:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    return oldbit != 0;
c0103682:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103686:	0f 95 c0             	setne  %al
c0103689:	0f b6 c0             	movzbl %al,%eax
c010368c:	85 c0                	test   %eax,%eax
c010368e:	75 24                	jne    c01036b4 <default_init_memmap+0x8c>
c0103690:	c7 44 24 0c a1 c9 10 	movl   $0xc010c9a1,0xc(%esp)
c0103697:	c0 
c0103698:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c010369f:	c0 
c01036a0:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c01036a7:	00 
c01036a8:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c01036af:	e8 04 d7 ff ff       	call   c0100db8 <__panic>
        p->flags = 0;
c01036b4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036b7:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
        SetPageProperty(p);
c01036be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036c1:	83 c0 04             	add    $0x4,%eax
c01036c4:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c01036cb:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01036ce:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01036d1:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01036d4:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c01036d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036da:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c01036e1:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01036e8:	00 
c01036e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036ec:	89 04 24             	mov    %eax,(%esp)
c01036ef:	e8 fa fe ff ff       	call   c01035ee <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c01036f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f7:	83 c0 0c             	add    $0xc,%eax
c01036fa:	c7 45 dc b8 ee 19 c0 	movl   $0xc019eeb8,-0x24(%ebp)
c0103701:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103704:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103707:	8b 00                	mov    (%eax),%eax
c0103709:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010370c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010370f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103712:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103715:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103718:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010371b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010371e:	89 10                	mov    %edx,(%eax)
c0103720:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103723:	8b 10                	mov    (%eax),%edx
c0103725:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103728:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010372b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010372e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103731:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103734:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103737:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010373a:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p = base;
    for (; p != base + n; p ++) {
c010373c:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c0103740:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103743:	c1 e0 05             	shl    $0x5,%eax
c0103746:	03 45 08             	add    0x8(%ebp),%eax
c0103749:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010374c:	0f 85 12 ff ff ff    	jne    c0103664 <default_init_memmap+0x3c>
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }

    nr_free = nr_free + n;
c0103752:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c0103757:	03 45 0c             	add    0xc(%ebp),%eax
c010375a:	a3 c0 ee 19 c0       	mov    %eax,0xc019eec0
    base->property = n;
c010375f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103762:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103765:	89 50 08             	mov    %edx,0x8(%eax)
}
c0103768:	83 c4 44             	add    $0x44,%esp
c010376b:	5b                   	pop    %ebx
c010376c:	5d                   	pop    %ebp
c010376d:	c3                   	ret    

c010376e <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c010376e:	55                   	push   %ebp
c010376f:	89 e5                	mov    %esp,%ebp
c0103771:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103774:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103778:	75 24                	jne    c010379e <default_alloc_pages+0x30>
c010377a:	c7 44 24 0c 70 c9 10 	movl   $0xc010c970,0xc(%esp)
c0103781:	c0 
c0103782:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103789:	c0 
c010378a:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0103791:	00 
c0103792:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103799:	e8 1a d6 ff ff       	call   c0100db8 <__panic>
    if (n > nr_free) {
c010379e:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c01037a3:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037a6:	73 0a                	jae    c01037b2 <default_alloc_pages+0x44>
        return NULL;
c01037a8:	b8 00 00 00 00       	mov    $0x0,%eax
c01037ad:	e9 37 01 00 00       	jmp    c01038e9 <default_alloc_pages+0x17b>
    }
    list_entry_t *le, *len;
    le = &free_list;
c01037b2:	c7 45 f4 b8 ee 19 c0 	movl   $0xc019eeb8,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
c01037b9:	e9 0a 01 00 00       	jmp    c01038c8 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c01037be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037c1:	83 e8 0c             	sub    $0xc,%eax
c01037c4:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c01037c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01037ca:	8b 40 08             	mov    0x8(%eax),%eax
c01037cd:	3b 45 08             	cmp    0x8(%ebp),%eax
c01037d0:	0f 82 f2 00 00 00    	jb     c01038c8 <default_alloc_pages+0x15a>
        int i;
        for(i=0;i<n;i++){
c01037d6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01037dd:	eb 7c                	jmp    c010385b <default_alloc_pages+0xed>
c01037df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037e2:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01037e5:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01037e8:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c01037eb:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *pp = le2page(le, page_link);
c01037ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037f1:	83 e8 0c             	sub    $0xc,%eax
c01037f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(pp);
c01037f7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01037fa:	83 c0 04             	add    $0x4,%eax
c01037fd:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103804:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103807:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010380a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010380d:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(pp);
c0103810:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103813:	83 c0 04             	add    $0x4,%eax
c0103816:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c010381d:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103820:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103823:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103826:	0f b3 10             	btr    %edx,(%eax)
c0103829:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010382c:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c010382f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103832:	8b 40 04             	mov    0x4(%eax),%eax
c0103835:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103838:	8b 12                	mov    (%edx),%edx
c010383a:	89 55 c8             	mov    %edx,-0x38(%ebp)
c010383d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0103840:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0103843:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0103846:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0103849:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010384c:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010384f:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c0103851:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103854:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
        int i;
        for(i=0;i<n;i++){
c0103857:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c010385b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010385e:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103861:	0f 82 78 ff ff ff    	jb     c01037df <default_alloc_pages+0x71>
          SetPageReserved(pp);
          ClearPageProperty(pp);
          list_del(le);
          le = len;
        }
        if(p->property>n){
c0103867:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010386a:	8b 40 08             	mov    0x8(%eax),%eax
c010386d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103870:	76 12                	jbe    c0103884 <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c0103872:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103875:	8d 50 f4             	lea    -0xc(%eax),%edx
c0103878:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010387b:	8b 40 08             	mov    0x8(%eax),%eax
c010387e:	2b 45 08             	sub    0x8(%ebp),%eax
c0103881:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c0103884:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103887:	83 c0 04             	add    $0x4,%eax
c010388a:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103891:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103894:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103897:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010389a:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c010389d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038a0:	83 c0 04             	add    $0x4,%eax
c01038a3:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c01038aa:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01038ad:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01038b0:	8b 55 b8             	mov    -0x48(%ebp),%edx
c01038b3:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c01038b6:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c01038bb:	2b 45 08             	sub    0x8(%ebp),%eax
c01038be:	a3 c0 ee 19 c0       	mov    %eax,0xc019eec0
        return p;
c01038c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01038c6:	eb 21                	jmp    c01038e9 <default_alloc_pages+0x17b>
c01038c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038cb:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01038ce:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01038d1:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *le, *len;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
c01038d4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01038d7:	81 7d f4 b8 ee 19 c0 	cmpl   $0xc019eeb8,-0xc(%ebp)
c01038de:	0f 85 da fe ff ff    	jne    c01037be <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c01038e4:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01038e9:	c9                   	leave  
c01038ea:	c3                   	ret    

c01038eb <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c01038eb:	55                   	push   %ebp
c01038ec:	89 e5                	mov    %esp,%ebp
c01038ee:	53                   	push   %ebx
c01038ef:	83 ec 64             	sub    $0x64,%esp
    assert(n > 0);
c01038f2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01038f6:	75 24                	jne    c010391c <default_free_pages+0x31>
c01038f8:	c7 44 24 0c 70 c9 10 	movl   $0xc010c970,0xc(%esp)
c01038ff:	c0 
c0103900:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103907:	c0 
c0103908:	c7 44 24 04 78 00 00 	movl   $0x78,0x4(%esp)
c010390f:	00 
c0103910:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103917:	e8 9c d4 ff ff       	call   c0100db8 <__panic>
    assert(PageReserved(base));
c010391c:	8b 45 08             	mov    0x8(%ebp),%eax
c010391f:	83 c0 04             	add    $0x4,%eax
c0103922:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0103929:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010392c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010392f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0103932:	0f a3 10             	bt     %edx,(%eax)
c0103935:	19 db                	sbb    %ebx,%ebx
c0103937:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    return oldbit != 0;
c010393a:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010393e:	0f 95 c0             	setne  %al
c0103941:	0f b6 c0             	movzbl %al,%eax
c0103944:	85 c0                	test   %eax,%eax
c0103946:	75 24                	jne    c010396c <default_free_pages+0x81>
c0103948:	c7 44 24 0c b1 c9 10 	movl   $0xc010c9b1,0xc(%esp)
c010394f:	c0 
c0103950:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103957:	c0 
c0103958:	c7 44 24 04 79 00 00 	movl   $0x79,0x4(%esp)
c010395f:	00 
c0103960:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103967:	e8 4c d4 ff ff       	call   c0100db8 <__panic>

    list_entry_t *le = &free_list;
c010396c:	c7 45 f4 b8 ee 19 c0 	movl   $0xc019eeb8,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c0103973:	eb 11                	jmp    c0103986 <default_free_pages+0x9b>
      p = le2page(le, page_link);
c0103975:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103978:	83 e8 0c             	sub    $0xc,%eax
c010397b:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c010397e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103981:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103984:	77 1a                	ja     c01039a0 <default_free_pages+0xb5>
        break;
c0103986:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103989:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010398c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010398f:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c0103992:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103995:	81 7d f4 b8 ee 19 c0 	cmpl   $0xc019eeb8,-0xc(%ebp)
c010399c:	75 d7                	jne    c0103975 <default_free_pages+0x8a>
c010399e:	eb 01                	jmp    c01039a1 <default_free_pages+0xb6>
      p = le2page(le, page_link);
      if(p>base){
        break;
c01039a0:	90                   	nop
      }
    }
    //list_add_before(le, base->page_link);
    for(p = base;p < base + n;p++){
c01039a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01039a4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01039a7:	eb 4b                	jmp    c01039f4 <default_free_pages+0x109>
      list_add_before(le, &(p->page_link));
c01039a9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039ac:	8d 50 0c             	lea    0xc(%eax),%edx
c01039af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039b2:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01039b5:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01039b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039bb:	8b 00                	mov    (%eax),%eax
c01039bd:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01039c0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01039c3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01039c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01039c9:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01039cc:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01039cf:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01039d2:	89 10                	mov    %edx,(%eax)
c01039d4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01039d7:	8b 10                	mov    (%eax),%edx
c01039d9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01039dc:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01039df:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01039e2:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01039e5:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01039e8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01039eb:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01039ee:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p = base;p < base + n;p++){
c01039f0:	83 45 f0 20          	addl   $0x20,-0x10(%ebp)
c01039f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01039f7:	c1 e0 05             	shl    $0x5,%eax
c01039fa:	03 45 08             	add    0x8(%ebp),%eax
c01039fd:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103a00:	77 a7                	ja     c01039a9 <default_free_pages+0xbe>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c0103a02:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a05:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103a0c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103a13:	00 
c0103a14:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a17:	89 04 24             	mov    %eax,(%esp)
c0103a1a:	e8 cf fb ff ff       	call   c01035ee <set_page_ref>
    ClearPageProperty(base);
c0103a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a22:	83 c0 04             	add    $0x4,%eax
c0103a25:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c0103a2c:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103a2f:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103a32:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0103a35:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c0103a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a3b:	83 c0 04             	add    $0x4,%eax
c0103a3e:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103a45:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103a48:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103a4b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103a4e:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c0103a51:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a54:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103a57:	89 50 08             	mov    %edx,0x8(%eax)
    
    p = le2page(le,page_link) ;
c0103a5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a5d:	83 e8 0c             	sub    $0xc,%eax
c0103a60:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c0103a63:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103a66:	c1 e0 05             	shl    $0x5,%eax
c0103a69:	03 45 08             	add    0x8(%ebp),%eax
c0103a6c:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103a6f:	75 1e                	jne    c0103a8f <default_free_pages+0x1a4>
      base->property += p->property;
c0103a71:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a74:	8b 50 08             	mov    0x8(%eax),%edx
c0103a77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a7a:	8b 40 08             	mov    0x8(%eax),%eax
c0103a7d:	01 c2                	add    %eax,%edx
c0103a7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a82:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0103a85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a88:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c0103a8f:	8b 45 08             	mov    0x8(%ebp),%eax
c0103a92:	83 c0 0c             	add    $0xc,%eax
c0103a95:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0103a98:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103a9b:	8b 00                	mov    (%eax),%eax
c0103a9d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c0103aa0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aa3:	83 e8 0c             	sub    $0xc,%eax
c0103aa6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c0103aa9:	81 7d f4 b8 ee 19 c0 	cmpl   $0xc019eeb8,-0xc(%ebp)
c0103ab0:	74 57                	je     c0103b09 <default_free_pages+0x21e>
c0103ab2:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ab5:	83 e8 20             	sub    $0x20,%eax
c0103ab8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103abb:	75 4c                	jne    c0103b09 <default_free_pages+0x21e>
      while(le!=&free_list){
c0103abd:	eb 41                	jmp    c0103b00 <default_free_pages+0x215>
        if(p->property){
c0103abf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ac2:	8b 40 08             	mov    0x8(%eax),%eax
c0103ac5:	85 c0                	test   %eax,%eax
c0103ac7:	74 20                	je     c0103ae9 <default_free_pages+0x1fe>
          p->property += base->property;
c0103ac9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103acc:	8b 50 08             	mov    0x8(%eax),%edx
c0103acf:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ad2:	8b 40 08             	mov    0x8(%eax),%eax
c0103ad5:	01 c2                	add    %eax,%edx
c0103ad7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103ada:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c0103add:	8b 45 08             	mov    0x8(%ebp),%eax
c0103ae0:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0103ae7:	eb 20                	jmp    c0103b09 <default_free_pages+0x21e>
c0103ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103aec:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0103aef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103af2:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0103af4:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0103af7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103afa:	83 e8 0c             	sub    $0xc,%eax
c0103afd:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c0103b00:	81 7d f4 b8 ee 19 c0 	cmpl   $0xc019eeb8,-0xc(%ebp)
c0103b07:	75 b6                	jne    c0103abf <default_free_pages+0x1d4>
        }
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }
    nr_free = nr_free + n;
c0103b09:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c0103b0e:	03 45 0c             	add    0xc(%ebp),%eax
c0103b11:	a3 c0 ee 19 c0       	mov    %eax,0xc019eec0
    return ;
}
c0103b16:	83 c4 64             	add    $0x64,%esp
c0103b19:	5b                   	pop    %ebx
c0103b1a:	5d                   	pop    %ebp
c0103b1b:	c3                   	ret    

c0103b1c <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103b1c:	55                   	push   %ebp
c0103b1d:	89 e5                	mov    %esp,%ebp
    return nr_free;
c0103b1f:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
}
c0103b24:	5d                   	pop    %ebp
c0103b25:	c3                   	ret    

c0103b26 <basic_check>:

static void
basic_check(void) {
c0103b26:	55                   	push   %ebp
c0103b27:	89 e5                	mov    %esp,%ebp
c0103b29:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c0103b2c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103b33:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b36:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b3c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c0103b3f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b46:	e8 f6 15 00 00       	call   c0105141 <alloc_pages>
c0103b4b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103b4e:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103b52:	75 24                	jne    c0103b78 <basic_check+0x52>
c0103b54:	c7 44 24 0c c4 c9 10 	movl   $0xc010c9c4,0xc(%esp)
c0103b5b:	c0 
c0103b5c:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103b63:	c0 
c0103b64:	c7 44 24 04 ac 00 00 	movl   $0xac,0x4(%esp)
c0103b6b:	00 
c0103b6c:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103b73:	e8 40 d2 ff ff       	call   c0100db8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103b78:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b7f:	e8 bd 15 00 00       	call   c0105141 <alloc_pages>
c0103b84:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103b87:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103b8b:	75 24                	jne    c0103bb1 <basic_check+0x8b>
c0103b8d:	c7 44 24 0c e0 c9 10 	movl   $0xc010c9e0,0xc(%esp)
c0103b94:	c0 
c0103b95:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103b9c:	c0 
c0103b9d:	c7 44 24 04 ad 00 00 	movl   $0xad,0x4(%esp)
c0103ba4:	00 
c0103ba5:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103bac:	e8 07 d2 ff ff       	call   c0100db8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103bb1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bb8:	e8 84 15 00 00       	call   c0105141 <alloc_pages>
c0103bbd:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103bc0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103bc4:	75 24                	jne    c0103bea <basic_check+0xc4>
c0103bc6:	c7 44 24 0c fc c9 10 	movl   $0xc010c9fc,0xc(%esp)
c0103bcd:	c0 
c0103bce:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103bd5:	c0 
c0103bd6:	c7 44 24 04 ae 00 00 	movl   $0xae,0x4(%esp)
c0103bdd:	00 
c0103bde:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103be5:	e8 ce d1 ff ff       	call   c0100db8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103bea:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bed:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103bf0:	74 10                	je     c0103c02 <basic_check+0xdc>
c0103bf2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103bf5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103bf8:	74 08                	je     c0103c02 <basic_check+0xdc>
c0103bfa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103bfd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103c00:	75 24                	jne    c0103c26 <basic_check+0x100>
c0103c02:	c7 44 24 0c 18 ca 10 	movl   $0xc010ca18,0xc(%esp)
c0103c09:	c0 
c0103c0a:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103c11:	c0 
c0103c12:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c0103c19:	00 
c0103c1a:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103c21:	e8 92 d1 ff ff       	call   c0100db8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c0103c26:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c29:	89 04 24             	mov    %eax,(%esp)
c0103c2c:	e8 b3 f9 ff ff       	call   c01035e4 <page_ref>
c0103c31:	85 c0                	test   %eax,%eax
c0103c33:	75 1e                	jne    c0103c53 <basic_check+0x12d>
c0103c35:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103c38:	89 04 24             	mov    %eax,(%esp)
c0103c3b:	e8 a4 f9 ff ff       	call   c01035e4 <page_ref>
c0103c40:	85 c0                	test   %eax,%eax
c0103c42:	75 0f                	jne    c0103c53 <basic_check+0x12d>
c0103c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103c47:	89 04 24             	mov    %eax,(%esp)
c0103c4a:	e8 95 f9 ff ff       	call   c01035e4 <page_ref>
c0103c4f:	85 c0                	test   %eax,%eax
c0103c51:	74 24                	je     c0103c77 <basic_check+0x151>
c0103c53:	c7 44 24 0c 3c ca 10 	movl   $0xc010ca3c,0xc(%esp)
c0103c5a:	c0 
c0103c5b:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103c62:	c0 
c0103c63:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103c6a:	00 
c0103c6b:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103c72:	e8 41 d1 ff ff       	call   c0100db8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103c77:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103c7a:	89 04 24             	mov    %eax,(%esp)
c0103c7d:	e8 4c f9 ff ff       	call   c01035ce <page2pa>
c0103c82:	8b 15 e0 cd 19 c0    	mov    0xc019cde0,%edx
c0103c88:	c1 e2 0c             	shl    $0xc,%edx
c0103c8b:	39 d0                	cmp    %edx,%eax
c0103c8d:	72 24                	jb     c0103cb3 <basic_check+0x18d>
c0103c8f:	c7 44 24 0c 78 ca 10 	movl   $0xc010ca78,0xc(%esp)
c0103c96:	c0 
c0103c97:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103c9e:	c0 
c0103c9f:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0103ca6:	00 
c0103ca7:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103cae:	e8 05 d1 ff ff       	call   c0100db8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103cb3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103cb6:	89 04 24             	mov    %eax,(%esp)
c0103cb9:	e8 10 f9 ff ff       	call   c01035ce <page2pa>
c0103cbe:	8b 15 e0 cd 19 c0    	mov    0xc019cde0,%edx
c0103cc4:	c1 e2 0c             	shl    $0xc,%edx
c0103cc7:	39 d0                	cmp    %edx,%eax
c0103cc9:	72 24                	jb     c0103cef <basic_check+0x1c9>
c0103ccb:	c7 44 24 0c 95 ca 10 	movl   $0xc010ca95,0xc(%esp)
c0103cd2:	c0 
c0103cd3:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103cda:	c0 
c0103cdb:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0103ce2:	00 
c0103ce3:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103cea:	e8 c9 d0 ff ff       	call   c0100db8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103cef:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103cf2:	89 04 24             	mov    %eax,(%esp)
c0103cf5:	e8 d4 f8 ff ff       	call   c01035ce <page2pa>
c0103cfa:	8b 15 e0 cd 19 c0    	mov    0xc019cde0,%edx
c0103d00:	c1 e2 0c             	shl    $0xc,%edx
c0103d03:	39 d0                	cmp    %edx,%eax
c0103d05:	72 24                	jb     c0103d2b <basic_check+0x205>
c0103d07:	c7 44 24 0c b2 ca 10 	movl   $0xc010cab2,0xc(%esp)
c0103d0e:	c0 
c0103d0f:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103d16:	c0 
c0103d17:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c0103d1e:	00 
c0103d1f:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103d26:	e8 8d d0 ff ff       	call   c0100db8 <__panic>

    list_entry_t free_list_store = free_list;
c0103d2b:	a1 b8 ee 19 c0       	mov    0xc019eeb8,%eax
c0103d30:	8b 15 bc ee 19 c0    	mov    0xc019eebc,%edx
c0103d36:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103d39:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103d3c:	c7 45 e0 b8 ee 19 c0 	movl   $0xc019eeb8,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103d43:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d46:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103d49:	89 50 04             	mov    %edx,0x4(%eax)
c0103d4c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d4f:	8b 50 04             	mov    0x4(%eax),%edx
c0103d52:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103d55:	89 10                	mov    %edx,(%eax)
c0103d57:	c7 45 dc b8 ee 19 c0 	movl   $0xc019eeb8,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103d5e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103d61:	8b 40 04             	mov    0x4(%eax),%eax
c0103d64:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103d67:	0f 94 c0             	sete   %al
c0103d6a:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103d6d:	85 c0                	test   %eax,%eax
c0103d6f:	75 24                	jne    c0103d95 <basic_check+0x26f>
c0103d71:	c7 44 24 0c cf ca 10 	movl   $0xc010cacf,0xc(%esp)
c0103d78:	c0 
c0103d79:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103d80:	c0 
c0103d81:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103d88:	00 
c0103d89:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103d90:	e8 23 d0 ff ff       	call   c0100db8 <__panic>

    unsigned int nr_free_store = nr_free;
c0103d95:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c0103d9a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103d9d:	c7 05 c0 ee 19 c0 00 	movl   $0x0,0xc019eec0
c0103da4:	00 00 00 

    assert(alloc_page() == NULL);
c0103da7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103dae:	e8 8e 13 00 00       	call   c0105141 <alloc_pages>
c0103db3:	85 c0                	test   %eax,%eax
c0103db5:	74 24                	je     c0103ddb <basic_check+0x2b5>
c0103db7:	c7 44 24 0c e6 ca 10 	movl   $0xc010cae6,0xc(%esp)
c0103dbe:	c0 
c0103dbf:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103dc6:	c0 
c0103dc7:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0103dce:	00 
c0103dcf:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103dd6:	e8 dd cf ff ff       	call   c0100db8 <__panic>

    free_page(p0);
c0103ddb:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103de2:	00 
c0103de3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103de6:	89 04 24             	mov    %eax,(%esp)
c0103de9:	e8 be 13 00 00       	call   c01051ac <free_pages>
    free_page(p1);
c0103dee:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103df5:	00 
c0103df6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103df9:	89 04 24             	mov    %eax,(%esp)
c0103dfc:	e8 ab 13 00 00       	call   c01051ac <free_pages>
    free_page(p2);
c0103e01:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103e08:	00 
c0103e09:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103e0c:	89 04 24             	mov    %eax,(%esp)
c0103e0f:	e8 98 13 00 00       	call   c01051ac <free_pages>
    assert(nr_free == 3);
c0103e14:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c0103e19:	83 f8 03             	cmp    $0x3,%eax
c0103e1c:	74 24                	je     c0103e42 <basic_check+0x31c>
c0103e1e:	c7 44 24 0c fb ca 10 	movl   $0xc010cafb,0xc(%esp)
c0103e25:	c0 
c0103e26:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103e2d:	c0 
c0103e2e:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c0103e35:	00 
c0103e36:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103e3d:	e8 76 cf ff ff       	call   c0100db8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103e42:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e49:	e8 f3 12 00 00       	call   c0105141 <alloc_pages>
c0103e4e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e51:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103e55:	75 24                	jne    c0103e7b <basic_check+0x355>
c0103e57:	c7 44 24 0c c4 c9 10 	movl   $0xc010c9c4,0xc(%esp)
c0103e5e:	c0 
c0103e5f:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103e66:	c0 
c0103e67:	c7 44 24 04 c5 00 00 	movl   $0xc5,0x4(%esp)
c0103e6e:	00 
c0103e6f:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103e76:	e8 3d cf ff ff       	call   c0100db8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103e7b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103e82:	e8 ba 12 00 00       	call   c0105141 <alloc_pages>
c0103e87:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e8a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103e8e:	75 24                	jne    c0103eb4 <basic_check+0x38e>
c0103e90:	c7 44 24 0c e0 c9 10 	movl   $0xc010c9e0,0xc(%esp)
c0103e97:	c0 
c0103e98:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103e9f:	c0 
c0103ea0:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0103ea7:	00 
c0103ea8:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103eaf:	e8 04 cf ff ff       	call   c0100db8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103eb4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ebb:	e8 81 12 00 00       	call   c0105141 <alloc_pages>
c0103ec0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103ec3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103ec7:	75 24                	jne    c0103eed <basic_check+0x3c7>
c0103ec9:	c7 44 24 0c fc c9 10 	movl   $0xc010c9fc,0xc(%esp)
c0103ed0:	c0 
c0103ed1:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103ed8:	c0 
c0103ed9:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103ee0:	00 
c0103ee1:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103ee8:	e8 cb ce ff ff       	call   c0100db8 <__panic>

    assert(alloc_page() == NULL);
c0103eed:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103ef4:	e8 48 12 00 00       	call   c0105141 <alloc_pages>
c0103ef9:	85 c0                	test   %eax,%eax
c0103efb:	74 24                	je     c0103f21 <basic_check+0x3fb>
c0103efd:	c7 44 24 0c e6 ca 10 	movl   $0xc010cae6,0xc(%esp)
c0103f04:	c0 
c0103f05:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103f0c:	c0 
c0103f0d:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103f14:	00 
c0103f15:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103f1c:	e8 97 ce ff ff       	call   c0100db8 <__panic>

    free_page(p0);
c0103f21:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103f28:	00 
c0103f29:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103f2c:	89 04 24             	mov    %eax,(%esp)
c0103f2f:	e8 78 12 00 00       	call   c01051ac <free_pages>
c0103f34:	c7 45 d8 b8 ee 19 c0 	movl   $0xc019eeb8,-0x28(%ebp)
c0103f3b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103f3e:	8b 40 04             	mov    0x4(%eax),%eax
c0103f41:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103f44:	0f 94 c0             	sete   %al
c0103f47:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103f4a:	85 c0                	test   %eax,%eax
c0103f4c:	74 24                	je     c0103f72 <basic_check+0x44c>
c0103f4e:	c7 44 24 0c 08 cb 10 	movl   $0xc010cb08,0xc(%esp)
c0103f55:	c0 
c0103f56:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103f5d:	c0 
c0103f5e:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0103f65:	00 
c0103f66:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103f6d:	e8 46 ce ff ff       	call   c0100db8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103f72:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103f79:	e8 c3 11 00 00       	call   c0105141 <alloc_pages>
c0103f7e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103f81:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f84:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103f87:	74 24                	je     c0103fad <basic_check+0x487>
c0103f89:	c7 44 24 0c 20 cb 10 	movl   $0xc010cb20,0xc(%esp)
c0103f90:	c0 
c0103f91:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103f98:	c0 
c0103f99:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0103fa0:	00 
c0103fa1:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103fa8:	e8 0b ce ff ff       	call   c0100db8 <__panic>
    assert(alloc_page() == NULL);
c0103fad:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fb4:	e8 88 11 00 00       	call   c0105141 <alloc_pages>
c0103fb9:	85 c0                	test   %eax,%eax
c0103fbb:	74 24                	je     c0103fe1 <basic_check+0x4bb>
c0103fbd:	c7 44 24 0c e6 ca 10 	movl   $0xc010cae6,0xc(%esp)
c0103fc4:	c0 
c0103fc5:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103fcc:	c0 
c0103fcd:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103fd4:	00 
c0103fd5:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0103fdc:	e8 d7 cd ff ff       	call   c0100db8 <__panic>

    assert(nr_free == 0);
c0103fe1:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c0103fe6:	85 c0                	test   %eax,%eax
c0103fe8:	74 24                	je     c010400e <basic_check+0x4e8>
c0103fea:	c7 44 24 0c 39 cb 10 	movl   $0xc010cb39,0xc(%esp)
c0103ff1:	c0 
c0103ff2:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0103ff9:	c0 
c0103ffa:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0104001:	00 
c0104002:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0104009:	e8 aa cd ff ff       	call   c0100db8 <__panic>
    free_list = free_list_store;
c010400e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104011:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104014:	a3 b8 ee 19 c0       	mov    %eax,0xc019eeb8
c0104019:	89 15 bc ee 19 c0    	mov    %edx,0xc019eebc
    nr_free = nr_free_store;
c010401f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104022:	a3 c0 ee 19 c0       	mov    %eax,0xc019eec0

    free_page(p);
c0104027:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010402e:	00 
c010402f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104032:	89 04 24             	mov    %eax,(%esp)
c0104035:	e8 72 11 00 00       	call   c01051ac <free_pages>
    free_page(p1);
c010403a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104041:	00 
c0104042:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104045:	89 04 24             	mov    %eax,(%esp)
c0104048:	e8 5f 11 00 00       	call   c01051ac <free_pages>
    free_page(p2);
c010404d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104054:	00 
c0104055:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104058:	89 04 24             	mov    %eax,(%esp)
c010405b:	e8 4c 11 00 00       	call   c01051ac <free_pages>
}
c0104060:	c9                   	leave  
c0104061:	c3                   	ret    

c0104062 <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0104062:	55                   	push   %ebp
c0104063:	89 e5                	mov    %esp,%ebp
c0104065:	53                   	push   %ebx
c0104066:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c010406c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0104073:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c010407a:	c7 45 ec b8 ee 19 c0 	movl   $0xc019eeb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104081:	eb 6b                	jmp    c01040ee <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0104083:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104086:	83 e8 0c             	sub    $0xc,%eax
c0104089:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c010408c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010408f:	83 c0 04             	add    $0x4,%eax
c0104092:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0104099:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010409c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010409f:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01040a2:	0f a3 10             	bt     %edx,(%eax)
c01040a5:	19 db                	sbb    %ebx,%ebx
c01040a7:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    return oldbit != 0;
c01040aa:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01040ae:	0f 95 c0             	setne  %al
c01040b1:	0f b6 c0             	movzbl %al,%eax
c01040b4:	85 c0                	test   %eax,%eax
c01040b6:	75 24                	jne    c01040dc <default_check+0x7a>
c01040b8:	c7 44 24 0c 46 cb 10 	movl   $0xc010cb46,0xc(%esp)
c01040bf:	c0 
c01040c0:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c01040c7:	c0 
c01040c8:	c7 44 24 04 e3 00 00 	movl   $0xe3,0x4(%esp)
c01040cf:	00 
c01040d0:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c01040d7:	e8 dc cc ff ff       	call   c0100db8 <__panic>
        count ++, total += p->property;
c01040dc:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01040e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01040e3:	8b 50 08             	mov    0x8(%eax),%edx
c01040e6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01040e9:	01 d0                	add    %edx,%eax
c01040eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01040ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01040f1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01040f4:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01040f7:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01040fa:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01040fd:	81 7d ec b8 ee 19 c0 	cmpl   $0xc019eeb8,-0x14(%ebp)
c0104104:	0f 85 79 ff ff ff    	jne    c0104083 <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c010410a:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010410d:	e8 cc 10 00 00       	call   c01051de <nr_free_pages>
c0104112:	39 c3                	cmp    %eax,%ebx
c0104114:	74 24                	je     c010413a <default_check+0xd8>
c0104116:	c7 44 24 0c 56 cb 10 	movl   $0xc010cb56,0xc(%esp)
c010411d:	c0 
c010411e:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0104125:	c0 
c0104126:	c7 44 24 04 e6 00 00 	movl   $0xe6,0x4(%esp)
c010412d:	00 
c010412e:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0104135:	e8 7e cc ff ff       	call   c0100db8 <__panic>

    basic_check();
c010413a:	e8 e7 f9 ff ff       	call   c0103b26 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c010413f:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104146:	e8 f6 0f 00 00       	call   c0105141 <alloc_pages>
c010414b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c010414e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0104152:	75 24                	jne    c0104178 <default_check+0x116>
c0104154:	c7 44 24 0c 6f cb 10 	movl   $0xc010cb6f,0xc(%esp)
c010415b:	c0 
c010415c:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0104163:	c0 
c0104164:	c7 44 24 04 eb 00 00 	movl   $0xeb,0x4(%esp)
c010416b:	00 
c010416c:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0104173:	e8 40 cc ff ff       	call   c0100db8 <__panic>
    assert(!PageProperty(p0));
c0104178:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010417b:	83 c0 04             	add    $0x4,%eax
c010417e:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0104185:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104188:	8b 45 bc             	mov    -0x44(%ebp),%eax
c010418b:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010418e:	0f a3 10             	bt     %edx,(%eax)
c0104191:	19 db                	sbb    %ebx,%ebx
c0104193:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    return oldbit != 0;
c0104196:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c010419a:	0f 95 c0             	setne  %al
c010419d:	0f b6 c0             	movzbl %al,%eax
c01041a0:	85 c0                	test   %eax,%eax
c01041a2:	74 24                	je     c01041c8 <default_check+0x166>
c01041a4:	c7 44 24 0c 7a cb 10 	movl   $0xc010cb7a,0xc(%esp)
c01041ab:	c0 
c01041ac:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c01041b3:	c0 
c01041b4:	c7 44 24 04 ec 00 00 	movl   $0xec,0x4(%esp)
c01041bb:	00 
c01041bc:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c01041c3:	e8 f0 cb ff ff       	call   c0100db8 <__panic>

    list_entry_t free_list_store = free_list;
c01041c8:	a1 b8 ee 19 c0       	mov    0xc019eeb8,%eax
c01041cd:	8b 15 bc ee 19 c0    	mov    0xc019eebc,%edx
c01041d3:	89 45 80             	mov    %eax,-0x80(%ebp)
c01041d6:	89 55 84             	mov    %edx,-0x7c(%ebp)
c01041d9:	c7 45 b4 b8 ee 19 c0 	movl   $0xc019eeb8,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01041e0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01041e3:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01041e6:	89 50 04             	mov    %edx,0x4(%eax)
c01041e9:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01041ec:	8b 50 04             	mov    0x4(%eax),%edx
c01041ef:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01041f2:	89 10                	mov    %edx,(%eax)
c01041f4:	c7 45 b0 b8 ee 19 c0 	movl   $0xc019eeb8,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01041fb:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01041fe:	8b 40 04             	mov    0x4(%eax),%eax
c0104201:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0104204:	0f 94 c0             	sete   %al
c0104207:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c010420a:	85 c0                	test   %eax,%eax
c010420c:	75 24                	jne    c0104232 <default_check+0x1d0>
c010420e:	c7 44 24 0c cf ca 10 	movl   $0xc010cacf,0xc(%esp)
c0104215:	c0 
c0104216:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c010421d:	c0 
c010421e:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0104225:	00 
c0104226:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c010422d:	e8 86 cb ff ff       	call   c0100db8 <__panic>
    assert(alloc_page() == NULL);
c0104232:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104239:	e8 03 0f 00 00       	call   c0105141 <alloc_pages>
c010423e:	85 c0                	test   %eax,%eax
c0104240:	74 24                	je     c0104266 <default_check+0x204>
c0104242:	c7 44 24 0c e6 ca 10 	movl   $0xc010cae6,0xc(%esp)
c0104249:	c0 
c010424a:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0104251:	c0 
c0104252:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0104259:	00 
c010425a:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0104261:	e8 52 cb ff ff       	call   c0100db8 <__panic>

    unsigned int nr_free_store = nr_free;
c0104266:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c010426b:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c010426e:	c7 05 c0 ee 19 c0 00 	movl   $0x0,0xc019eec0
c0104275:	00 00 00 

    free_pages(p0 + 2, 3);
c0104278:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010427b:	83 c0 40             	add    $0x40,%eax
c010427e:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104285:	00 
c0104286:	89 04 24             	mov    %eax,(%esp)
c0104289:	e8 1e 0f 00 00       	call   c01051ac <free_pages>
    assert(alloc_pages(4) == NULL);
c010428e:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104295:	e8 a7 0e 00 00       	call   c0105141 <alloc_pages>
c010429a:	85 c0                	test   %eax,%eax
c010429c:	74 24                	je     c01042c2 <default_check+0x260>
c010429e:	c7 44 24 0c 8c cb 10 	movl   $0xc010cb8c,0xc(%esp)
c01042a5:	c0 
c01042a6:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c01042ad:	c0 
c01042ae:	c7 44 24 04 f7 00 00 	movl   $0xf7,0x4(%esp)
c01042b5:	00 
c01042b6:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c01042bd:	e8 f6 ca ff ff       	call   c0100db8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c01042c2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042c5:	83 c0 40             	add    $0x40,%eax
c01042c8:	83 c0 04             	add    $0x4,%eax
c01042cb:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c01042d2:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01042d5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01042d8:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01042db:	0f a3 10             	bt     %edx,(%eax)
c01042de:	19 db                	sbb    %ebx,%ebx
c01042e0:	89 5d a4             	mov    %ebx,-0x5c(%ebp)
    return oldbit != 0;
c01042e3:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c01042e7:	0f 95 c0             	setne  %al
c01042ea:	0f b6 c0             	movzbl %al,%eax
c01042ed:	85 c0                	test   %eax,%eax
c01042ef:	74 0e                	je     c01042ff <default_check+0x29d>
c01042f1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042f4:	83 c0 40             	add    $0x40,%eax
c01042f7:	8b 40 08             	mov    0x8(%eax),%eax
c01042fa:	83 f8 03             	cmp    $0x3,%eax
c01042fd:	74 24                	je     c0104323 <default_check+0x2c1>
c01042ff:	c7 44 24 0c a4 cb 10 	movl   $0xc010cba4,0xc(%esp)
c0104306:	c0 
c0104307:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c010430e:	c0 
c010430f:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0104316:	00 
c0104317:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c010431e:	e8 95 ca ff ff       	call   c0100db8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c0104323:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c010432a:	e8 12 0e 00 00       	call   c0105141 <alloc_pages>
c010432f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0104332:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0104336:	75 24                	jne    c010435c <default_check+0x2fa>
c0104338:	c7 44 24 0c d0 cb 10 	movl   $0xc010cbd0,0xc(%esp)
c010433f:	c0 
c0104340:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0104347:	c0 
c0104348:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c010434f:	00 
c0104350:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0104357:	e8 5c ca ff ff       	call   c0100db8 <__panic>
    assert(alloc_page() == NULL);
c010435c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104363:	e8 d9 0d 00 00       	call   c0105141 <alloc_pages>
c0104368:	85 c0                	test   %eax,%eax
c010436a:	74 24                	je     c0104390 <default_check+0x32e>
c010436c:	c7 44 24 0c e6 ca 10 	movl   $0xc010cae6,0xc(%esp)
c0104373:	c0 
c0104374:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c010437b:	c0 
c010437c:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0104383:	00 
c0104384:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c010438b:	e8 28 ca ff ff       	call   c0100db8 <__panic>
    assert(p0 + 2 == p1);
c0104390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104393:	83 c0 40             	add    $0x40,%eax
c0104396:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104399:	74 24                	je     c01043bf <default_check+0x35d>
c010439b:	c7 44 24 0c ee cb 10 	movl   $0xc010cbee,0xc(%esp)
c01043a2:	c0 
c01043a3:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c01043aa:	c0 
c01043ab:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c01043b2:	00 
c01043b3:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c01043ba:	e8 f9 c9 ff ff       	call   c0100db8 <__panic>

    p2 = p0 + 1;
c01043bf:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043c2:	83 c0 20             	add    $0x20,%eax
c01043c5:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c01043c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01043cf:	00 
c01043d0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043d3:	89 04 24             	mov    %eax,(%esp)
c01043d6:	e8 d1 0d 00 00       	call   c01051ac <free_pages>
    free_pages(p1, 3);
c01043db:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c01043e2:	00 
c01043e3:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01043e6:	89 04 24             	mov    %eax,(%esp)
c01043e9:	e8 be 0d 00 00       	call   c01051ac <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c01043ee:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043f1:	83 c0 04             	add    $0x4,%eax
c01043f4:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c01043fb:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01043fe:	8b 45 9c             	mov    -0x64(%ebp),%eax
c0104401:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104404:	0f a3 10             	bt     %edx,(%eax)
c0104407:	19 db                	sbb    %ebx,%ebx
c0104409:	89 5d 98             	mov    %ebx,-0x68(%ebp)
    return oldbit != 0;
c010440c:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c0104410:	0f 95 c0             	setne  %al
c0104413:	0f b6 c0             	movzbl %al,%eax
c0104416:	85 c0                	test   %eax,%eax
c0104418:	74 0b                	je     c0104425 <default_check+0x3c3>
c010441a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010441d:	8b 40 08             	mov    0x8(%eax),%eax
c0104420:	83 f8 01             	cmp    $0x1,%eax
c0104423:	74 24                	je     c0104449 <default_check+0x3e7>
c0104425:	c7 44 24 0c fc cb 10 	movl   $0xc010cbfc,0xc(%esp)
c010442c:	c0 
c010442d:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0104434:	c0 
c0104435:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c010443c:	00 
c010443d:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0104444:	e8 6f c9 ff ff       	call   c0100db8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c0104449:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010444c:	83 c0 04             	add    $0x4,%eax
c010444f:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c0104456:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104459:	8b 45 90             	mov    -0x70(%ebp),%eax
c010445c:	8b 55 94             	mov    -0x6c(%ebp),%edx
c010445f:	0f a3 10             	bt     %edx,(%eax)
c0104462:	19 db                	sbb    %ebx,%ebx
c0104464:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
    return oldbit != 0;
c0104467:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c010446b:	0f 95 c0             	setne  %al
c010446e:	0f b6 c0             	movzbl %al,%eax
c0104471:	85 c0                	test   %eax,%eax
c0104473:	74 0b                	je     c0104480 <default_check+0x41e>
c0104475:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104478:	8b 40 08             	mov    0x8(%eax),%eax
c010447b:	83 f8 03             	cmp    $0x3,%eax
c010447e:	74 24                	je     c01044a4 <default_check+0x442>
c0104480:	c7 44 24 0c 24 cc 10 	movl   $0xc010cc24,0xc(%esp)
c0104487:	c0 
c0104488:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c010448f:	c0 
c0104490:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0104497:	00 
c0104498:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c010449f:	e8 14 c9 ff ff       	call   c0100db8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c01044a4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01044ab:	e8 91 0c 00 00       	call   c0105141 <alloc_pages>
c01044b0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01044b3:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01044b6:	83 e8 20             	sub    $0x20,%eax
c01044b9:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01044bc:	74 24                	je     c01044e2 <default_check+0x480>
c01044be:	c7 44 24 0c 4a cc 10 	movl   $0xc010cc4a,0xc(%esp)
c01044c5:	c0 
c01044c6:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c01044cd:	c0 
c01044ce:	c7 44 24 04 03 01 00 	movl   $0x103,0x4(%esp)
c01044d5:	00 
c01044d6:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c01044dd:	e8 d6 c8 ff ff       	call   c0100db8 <__panic>
    free_page(p0);
c01044e2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01044e9:	00 
c01044ea:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01044ed:	89 04 24             	mov    %eax,(%esp)
c01044f0:	e8 b7 0c 00 00       	call   c01051ac <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c01044f5:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c01044fc:	e8 40 0c 00 00       	call   c0105141 <alloc_pages>
c0104501:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104504:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104507:	83 c0 20             	add    $0x20,%eax
c010450a:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c010450d:	74 24                	je     c0104533 <default_check+0x4d1>
c010450f:	c7 44 24 0c 68 cc 10 	movl   $0xc010cc68,0xc(%esp)
c0104516:	c0 
c0104517:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c010451e:	c0 
c010451f:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0104526:	00 
c0104527:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c010452e:	e8 85 c8 ff ff       	call   c0100db8 <__panic>

    free_pages(p0, 2);
c0104533:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c010453a:	00 
c010453b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010453e:	89 04 24             	mov    %eax,(%esp)
c0104541:	e8 66 0c 00 00       	call   c01051ac <free_pages>
    free_page(p2);
c0104546:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010454d:	00 
c010454e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104551:	89 04 24             	mov    %eax,(%esp)
c0104554:	e8 53 0c 00 00       	call   c01051ac <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c0104559:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0104560:	e8 dc 0b 00 00       	call   c0105141 <alloc_pages>
c0104565:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104568:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010456c:	75 24                	jne    c0104592 <default_check+0x530>
c010456e:	c7 44 24 0c 88 cc 10 	movl   $0xc010cc88,0xc(%esp)
c0104575:	c0 
c0104576:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c010457d:	c0 
c010457e:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0104585:	00 
c0104586:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c010458d:	e8 26 c8 ff ff       	call   c0100db8 <__panic>
    assert(alloc_page() == NULL);
c0104592:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104599:	e8 a3 0b 00 00       	call   c0105141 <alloc_pages>
c010459e:	85 c0                	test   %eax,%eax
c01045a0:	74 24                	je     c01045c6 <default_check+0x564>
c01045a2:	c7 44 24 0c e6 ca 10 	movl   $0xc010cae6,0xc(%esp)
c01045a9:	c0 
c01045aa:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c01045b1:	c0 
c01045b2:	c7 44 24 04 0b 01 00 	movl   $0x10b,0x4(%esp)
c01045b9:	00 
c01045ba:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c01045c1:	e8 f2 c7 ff ff       	call   c0100db8 <__panic>

    assert(nr_free == 0);
c01045c6:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c01045cb:	85 c0                	test   %eax,%eax
c01045cd:	74 24                	je     c01045f3 <default_check+0x591>
c01045cf:	c7 44 24 0c 39 cb 10 	movl   $0xc010cb39,0xc(%esp)
c01045d6:	c0 
c01045d7:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c01045de:	c0 
c01045df:	c7 44 24 04 0d 01 00 	movl   $0x10d,0x4(%esp)
c01045e6:	00 
c01045e7:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c01045ee:	e8 c5 c7 ff ff       	call   c0100db8 <__panic>
    nr_free = nr_free_store;
c01045f3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01045f6:	a3 c0 ee 19 c0       	mov    %eax,0xc019eec0

    free_list = free_list_store;
c01045fb:	8b 45 80             	mov    -0x80(%ebp),%eax
c01045fe:	8b 55 84             	mov    -0x7c(%ebp),%edx
c0104601:	a3 b8 ee 19 c0       	mov    %eax,0xc019eeb8
c0104606:	89 15 bc ee 19 c0    	mov    %edx,0xc019eebc
    free_pages(p0, 5);
c010460c:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c0104613:	00 
c0104614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104617:	89 04 24             	mov    %eax,(%esp)
c010461a:	e8 8d 0b 00 00       	call   c01051ac <free_pages>

    le = &free_list;
c010461f:	c7 45 ec b8 ee 19 c0 	movl   $0xc019eeb8,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0104626:	eb 1f                	jmp    c0104647 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
c0104628:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010462b:	83 e8 0c             	sub    $0xc,%eax
c010462e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c0104631:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104635:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104638:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010463b:	8b 40 08             	mov    0x8(%eax),%eax
c010463e:	89 d1                	mov    %edx,%ecx
c0104640:	29 c1                	sub    %eax,%ecx
c0104642:	89 c8                	mov    %ecx,%eax
c0104644:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104647:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010464a:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010464d:	8b 45 88             	mov    -0x78(%ebp),%eax
c0104650:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0104653:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104656:	81 7d ec b8 ee 19 c0 	cmpl   $0xc019eeb8,-0x14(%ebp)
c010465d:	75 c9                	jne    c0104628 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c010465f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104663:	74 24                	je     c0104689 <default_check+0x627>
c0104665:	c7 44 24 0c a6 cc 10 	movl   $0xc010cca6,0xc(%esp)
c010466c:	c0 
c010466d:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c0104674:	c0 
c0104675:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c010467c:	00 
c010467d:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c0104684:	e8 2f c7 ff ff       	call   c0100db8 <__panic>
    assert(total == 0);
c0104689:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010468d:	74 24                	je     c01046b3 <default_check+0x651>
c010468f:	c7 44 24 0c b1 cc 10 	movl   $0xc010ccb1,0xc(%esp)
c0104696:	c0 
c0104697:	c7 44 24 08 76 c9 10 	movl   $0xc010c976,0x8(%esp)
c010469e:	c0 
c010469f:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01046a6:	00 
c01046a7:	c7 04 24 8b c9 10 c0 	movl   $0xc010c98b,(%esp)
c01046ae:	e8 05 c7 ff ff       	call   c0100db8 <__panic>
}
c01046b3:	81 c4 94 00 00 00    	add    $0x94,%esp
c01046b9:	5b                   	pop    %ebx
c01046ba:	5d                   	pop    %ebp
c01046bb:	c3                   	ret    

c01046bc <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c01046bc:	55                   	push   %ebp
c01046bd:	89 e5                	mov    %esp,%ebp
c01046bf:	53                   	push   %ebx
c01046c0:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01046c3:	9c                   	pushf  
c01046c4:	5b                   	pop    %ebx
c01046c5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c01046c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01046cb:	25 00 02 00 00       	and    $0x200,%eax
c01046d0:	85 c0                	test   %eax,%eax
c01046d2:	74 0c                	je     c01046e0 <__intr_save+0x24>
        intr_disable();
c01046d4:	e8 0d da ff ff       	call   c01020e6 <intr_disable>
        return 1;
c01046d9:	b8 01 00 00 00       	mov    $0x1,%eax
c01046de:	eb 05                	jmp    c01046e5 <__intr_save+0x29>
    }
    return 0;
c01046e0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01046e5:	83 c4 14             	add    $0x14,%esp
c01046e8:	5b                   	pop    %ebx
c01046e9:	5d                   	pop    %ebp
c01046ea:	c3                   	ret    

c01046eb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01046eb:	55                   	push   %ebp
c01046ec:	89 e5                	mov    %esp,%ebp
c01046ee:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01046f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01046f5:	74 05                	je     c01046fc <__intr_restore+0x11>
        intr_enable();
c01046f7:	e8 e4 d9 ff ff       	call   c01020e0 <intr_enable>
    }
}
c01046fc:	c9                   	leave  
c01046fd:	c3                   	ret    

c01046fe <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01046fe:	55                   	push   %ebp
c01046ff:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104701:	8b 55 08             	mov    0x8(%ebp),%edx
c0104704:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c0104709:	89 d1                	mov    %edx,%ecx
c010470b:	29 c1                	sub    %eax,%ecx
c010470d:	89 c8                	mov    %ecx,%eax
c010470f:	c1 f8 05             	sar    $0x5,%eax
}
c0104712:	5d                   	pop    %ebp
c0104713:	c3                   	ret    

c0104714 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104714:	55                   	push   %ebp
c0104715:	89 e5                	mov    %esp,%ebp
c0104717:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010471a:	8b 45 08             	mov    0x8(%ebp),%eax
c010471d:	89 04 24             	mov    %eax,(%esp)
c0104720:	e8 d9 ff ff ff       	call   c01046fe <page2ppn>
c0104725:	c1 e0 0c             	shl    $0xc,%eax
}
c0104728:	c9                   	leave  
c0104729:	c3                   	ret    

c010472a <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c010472a:	55                   	push   %ebp
c010472b:	89 e5                	mov    %esp,%ebp
c010472d:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104730:	8b 45 08             	mov    0x8(%ebp),%eax
c0104733:	89 c2                	mov    %eax,%edx
c0104735:	c1 ea 0c             	shr    $0xc,%edx
c0104738:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c010473d:	39 c2                	cmp    %eax,%edx
c010473f:	72 1c                	jb     c010475d <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104741:	c7 44 24 08 ec cc 10 	movl   $0xc010ccec,0x8(%esp)
c0104748:	c0 
c0104749:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104750:	00 
c0104751:	c7 04 24 0b cd 10 c0 	movl   $0xc010cd0b,(%esp)
c0104758:	e8 5b c6 ff ff       	call   c0100db8 <__panic>
    }
    return &pages[PPN(pa)];
c010475d:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c0104762:	8b 55 08             	mov    0x8(%ebp),%edx
c0104765:	c1 ea 0c             	shr    $0xc,%edx
c0104768:	c1 e2 05             	shl    $0x5,%edx
c010476b:	01 d0                	add    %edx,%eax
}
c010476d:	c9                   	leave  
c010476e:	c3                   	ret    

c010476f <page2kva>:

static inline void *
page2kva(struct Page *page) {
c010476f:	55                   	push   %ebp
c0104770:	89 e5                	mov    %esp,%ebp
c0104772:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104775:	8b 45 08             	mov    0x8(%ebp),%eax
c0104778:	89 04 24             	mov    %eax,(%esp)
c010477b:	e8 94 ff ff ff       	call   c0104714 <page2pa>
c0104780:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104783:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104786:	c1 e8 0c             	shr    $0xc,%eax
c0104789:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010478c:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c0104791:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104794:	72 23                	jb     c01047b9 <page2kva+0x4a>
c0104796:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104799:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010479d:	c7 44 24 08 1c cd 10 	movl   $0xc010cd1c,0x8(%esp)
c01047a4:	c0 
c01047a5:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c01047ac:	00 
c01047ad:	c7 04 24 0b cd 10 c0 	movl   $0xc010cd0b,(%esp)
c01047b4:	e8 ff c5 ff ff       	call   c0100db8 <__panic>
c01047b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047bc:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01047c1:	c9                   	leave  
c01047c2:	c3                   	ret    

c01047c3 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01047c3:	55                   	push   %ebp
c01047c4:	89 e5                	mov    %esp,%ebp
c01047c6:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c01047c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01047cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047cf:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01047d6:	77 23                	ja     c01047fb <kva2page+0x38>
c01047d8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047db:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01047df:	c7 44 24 08 40 cd 10 	movl   $0xc010cd40,0x8(%esp)
c01047e6:	c0 
c01047e7:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c01047ee:	00 
c01047ef:	c7 04 24 0b cd 10 c0 	movl   $0xc010cd0b,(%esp)
c01047f6:	e8 bd c5 ff ff       	call   c0100db8 <__panic>
c01047fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01047fe:	05 00 00 00 40       	add    $0x40000000,%eax
c0104803:	89 04 24             	mov    %eax,(%esp)
c0104806:	e8 1f ff ff ff       	call   c010472a <pa2page>
}
c010480b:	c9                   	leave  
c010480c:	c3                   	ret    

c010480d <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c010480d:	55                   	push   %ebp
c010480e:	89 e5                	mov    %esp,%ebp
c0104810:	53                   	push   %ebx
c0104811:	83 ec 24             	sub    $0x24,%esp
  struct Page * page = alloc_pages(1 << order);
c0104814:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104817:	ba 01 00 00 00       	mov    $0x1,%edx
c010481c:	89 d3                	mov    %edx,%ebx
c010481e:	89 c1                	mov    %eax,%ecx
c0104820:	d3 e3                	shl    %cl,%ebx
c0104822:	89 d8                	mov    %ebx,%eax
c0104824:	89 04 24             	mov    %eax,(%esp)
c0104827:	e8 15 09 00 00       	call   c0105141 <alloc_pages>
c010482c:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c010482f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104833:	75 07                	jne    c010483c <__slob_get_free_pages+0x2f>
    return NULL;
c0104835:	b8 00 00 00 00       	mov    $0x0,%eax
c010483a:	eb 0b                	jmp    c0104847 <__slob_get_free_pages+0x3a>
  return page2kva(page);
c010483c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010483f:	89 04 24             	mov    %eax,(%esp)
c0104842:	e8 28 ff ff ff       	call   c010476f <page2kva>
}
c0104847:	83 c4 24             	add    $0x24,%esp
c010484a:	5b                   	pop    %ebx
c010484b:	5d                   	pop    %ebp
c010484c:	c3                   	ret    

c010484d <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c010484d:	55                   	push   %ebp
c010484e:	89 e5                	mov    %esp,%ebp
c0104850:	53                   	push   %ebx
c0104851:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c0104854:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104857:	ba 01 00 00 00       	mov    $0x1,%edx
c010485c:	89 d3                	mov    %edx,%ebx
c010485e:	89 c1                	mov    %eax,%ecx
c0104860:	d3 e3                	shl    %cl,%ebx
c0104862:	89 d8                	mov    %ebx,%eax
c0104864:	89 c3                	mov    %eax,%ebx
c0104866:	8b 45 08             	mov    0x8(%ebp),%eax
c0104869:	89 04 24             	mov    %eax,(%esp)
c010486c:	e8 52 ff ff ff       	call   c01047c3 <kva2page>
c0104871:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104875:	89 04 24             	mov    %eax,(%esp)
c0104878:	e8 2f 09 00 00       	call   c01051ac <free_pages>
}
c010487d:	83 c4 14             	add    $0x14,%esp
c0104880:	5b                   	pop    %ebx
c0104881:	5d                   	pop    %ebp
c0104882:	c3                   	ret    

c0104883 <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c0104883:	55                   	push   %ebp
c0104884:	89 e5                	mov    %esp,%ebp
c0104886:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104889:	8b 45 08             	mov    0x8(%ebp),%eax
c010488c:	83 c0 08             	add    $0x8,%eax
c010488f:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104894:	76 24                	jbe    c01048ba <slob_alloc+0x37>
c0104896:	c7 44 24 0c 64 cd 10 	movl   $0xc010cd64,0xc(%esp)
c010489d:	c0 
c010489e:	c7 44 24 08 83 cd 10 	movl   $0xc010cd83,0x8(%esp)
c01048a5:	c0 
c01048a6:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01048ad:	00 
c01048ae:	c7 04 24 98 cd 10 c0 	movl   $0xc010cd98,(%esp)
c01048b5:	e8 fe c4 ff ff       	call   c0100db8 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c01048ba:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c01048c1:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c01048c8:	8b 45 08             	mov    0x8(%ebp),%eax
c01048cb:	83 c0 07             	add    $0x7,%eax
c01048ce:	c1 e8 03             	shr    $0x3,%eax
c01048d1:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c01048d4:	e8 e3 fd ff ff       	call   c01046bc <__intr_save>
c01048d9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c01048dc:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c01048e1:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01048e4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048e7:	8b 40 04             	mov    0x4(%eax),%eax
c01048ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c01048ed:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01048f1:	74 27                	je     c010491a <slob_alloc+0x97>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c01048f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01048f6:	8b 45 10             	mov    0x10(%ebp),%eax
c01048f9:	01 d0                	add    %edx,%eax
c01048fb:	8d 50 ff             	lea    -0x1(%eax),%edx
c01048fe:	8b 45 10             	mov    0x10(%ebp),%eax
c0104901:	f7 d8                	neg    %eax
c0104903:	21 d0                	and    %edx,%eax
c0104905:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104908:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010490b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010490e:	89 d1                	mov    %edx,%ecx
c0104910:	29 c1                	sub    %eax,%ecx
c0104912:	89 c8                	mov    %ecx,%eax
c0104914:	c1 f8 03             	sar    $0x3,%eax
c0104917:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c010491a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010491d:	8b 00                	mov    (%eax),%eax
c010491f:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0104922:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0104925:	01 ca                	add    %ecx,%edx
c0104927:	39 d0                	cmp    %edx,%eax
c0104929:	0f 8c a6 00 00 00    	jl     c01049d5 <slob_alloc+0x152>
			if (delta) { /* need to fragment head to align? */
c010492f:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0104933:	74 38                	je     c010496d <slob_alloc+0xea>
				aligned->units = cur->units - delta;
c0104935:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104938:	8b 00                	mov    (%eax),%eax
c010493a:	89 c2                	mov    %eax,%edx
c010493c:	2b 55 e8             	sub    -0x18(%ebp),%edx
c010493f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104942:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c0104944:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104947:	8b 50 04             	mov    0x4(%eax),%edx
c010494a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010494d:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c0104950:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104953:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104956:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c0104959:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010495c:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010495f:	89 10                	mov    %edx,(%eax)
				prev = cur;
c0104961:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104964:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c0104967:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010496a:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c010496d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104970:	8b 00                	mov    (%eax),%eax
c0104972:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104975:	75 0e                	jne    c0104985 <slob_alloc+0x102>
				prev->next = cur->next; /* unlink */
c0104977:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010497a:	8b 50 04             	mov    0x4(%eax),%edx
c010497d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104980:	89 50 04             	mov    %edx,0x4(%eax)
c0104983:	eb 38                	jmp    c01049bd <slob_alloc+0x13a>
			else { /* fragment */
				prev->next = cur + units;
c0104985:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104988:	c1 e0 03             	shl    $0x3,%eax
c010498b:	89 c2                	mov    %eax,%edx
c010498d:	03 55 f0             	add    -0x10(%ebp),%edx
c0104990:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104993:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104996:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104999:	8b 40 04             	mov    0x4(%eax),%eax
c010499c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010499f:	8b 12                	mov    (%edx),%edx
c01049a1:	2b 55 e0             	sub    -0x20(%ebp),%edx
c01049a4:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c01049a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049a9:	8b 40 04             	mov    0x4(%eax),%eax
c01049ac:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01049af:	8b 52 04             	mov    0x4(%edx),%edx
c01049b2:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c01049b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049b8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01049bb:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c01049bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01049c0:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08
			spin_unlock_irqrestore(&slob_lock, flags);
c01049c5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049c8:	89 04 24             	mov    %eax,(%esp)
c01049cb:	e8 1b fd ff ff       	call   c01046eb <__intr_restore>
			return cur;
c01049d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049d3:	eb 7f                	jmp    c0104a54 <slob_alloc+0x1d1>
		}
		if (cur == slobfree) {
c01049d5:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c01049da:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01049dd:	75 61                	jne    c0104a40 <slob_alloc+0x1bd>
			spin_unlock_irqrestore(&slob_lock, flags);
c01049df:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01049e2:	89 04 24             	mov    %eax,(%esp)
c01049e5:	e8 01 fd ff ff       	call   c01046eb <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c01049ea:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c01049f1:	75 07                	jne    c01049fa <slob_alloc+0x177>
				return 0;
c01049f3:	b8 00 00 00 00       	mov    $0x0,%eax
c01049f8:	eb 5a                	jmp    c0104a54 <slob_alloc+0x1d1>

			cur = (slob_t *)__slob_get_free_page(gfp);
c01049fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a01:	00 
c0104a02:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a05:	89 04 24             	mov    %eax,(%esp)
c0104a08:	e8 00 fe ff ff       	call   c010480d <__slob_get_free_pages>
c0104a0d:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c0104a10:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104a14:	75 07                	jne    c0104a1d <slob_alloc+0x19a>
				return 0;
c0104a16:	b8 00 00 00 00       	mov    $0x0,%eax
c0104a1b:	eb 37                	jmp    c0104a54 <slob_alloc+0x1d1>

			slob_free(cur, PAGE_SIZE);
c0104a1d:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0104a24:	00 
c0104a25:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a28:	89 04 24             	mov    %eax,(%esp)
c0104a2b:	e8 26 00 00 00       	call   c0104a56 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c0104a30:	e8 87 fc ff ff       	call   c01046bc <__intr_save>
c0104a35:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c0104a38:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c0104a3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104a40:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a49:	8b 40 04             	mov    0x4(%eax),%eax
c0104a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c0104a4f:	e9 99 fe ff ff       	jmp    c01048ed <slob_alloc+0x6a>
}
c0104a54:	c9                   	leave  
c0104a55:	c3                   	ret    

c0104a56 <slob_free>:

static void slob_free(void *block, int size)
{
c0104a56:	55                   	push   %ebp
c0104a57:	89 e5                	mov    %esp,%ebp
c0104a59:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c0104a5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a5f:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104a62:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104a66:	0f 84 f7 00 00 00    	je     c0104b63 <slob_free+0x10d>
		return;

	if (size)
c0104a6c:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0104a70:	74 10                	je     c0104a82 <slob_free+0x2c>
		b->units = SLOB_UNITS(size);
c0104a72:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104a75:	83 c0 07             	add    $0x7,%eax
c0104a78:	c1 e8 03             	shr    $0x3,%eax
c0104a7b:	89 c2                	mov    %eax,%edx
c0104a7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a80:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c0104a82:	e8 35 fc ff ff       	call   c01046bc <__intr_save>
c0104a87:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104a8a:	a1 08 aa 12 c0       	mov    0xc012aa08,%eax
c0104a8f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a92:	eb 27                	jmp    c0104abb <slob_free+0x65>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104a94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a97:	8b 40 04             	mov    0x4(%eax),%eax
c0104a9a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104a9d:	77 13                	ja     c0104ab2 <slob_free+0x5c>
c0104a9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aa2:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104aa5:	77 27                	ja     c0104ace <slob_free+0x78>
c0104aa7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aaa:	8b 40 04             	mov    0x4(%eax),%eax
c0104aad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104ab0:	77 1c                	ja     c0104ace <slob_free+0x78>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104ab2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ab5:	8b 40 04             	mov    0x4(%eax),%eax
c0104ab8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104abb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104abe:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104ac1:	76 d1                	jbe    c0104a94 <slob_free+0x3e>
c0104ac3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ac6:	8b 40 04             	mov    0x4(%eax),%eax
c0104ac9:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104acc:	76 c6                	jbe    c0104a94 <slob_free+0x3e>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c0104ace:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ad1:	8b 00                	mov    (%eax),%eax
c0104ad3:	c1 e0 03             	shl    $0x3,%eax
c0104ad6:	89 c2                	mov    %eax,%edx
c0104ad8:	03 55 f0             	add    -0x10(%ebp),%edx
c0104adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ade:	8b 40 04             	mov    0x4(%eax),%eax
c0104ae1:	39 c2                	cmp    %eax,%edx
c0104ae3:	75 25                	jne    c0104b0a <slob_free+0xb4>
		b->units += cur->next->units;
c0104ae5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ae8:	8b 10                	mov    (%eax),%edx
c0104aea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aed:	8b 40 04             	mov    0x4(%eax),%eax
c0104af0:	8b 00                	mov    (%eax),%eax
c0104af2:	01 c2                	add    %eax,%edx
c0104af4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104af7:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104af9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104afc:	8b 40 04             	mov    0x4(%eax),%eax
c0104aff:	8b 50 04             	mov    0x4(%eax),%edx
c0104b02:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b05:	89 50 04             	mov    %edx,0x4(%eax)
c0104b08:	eb 0c                	jmp    c0104b16 <slob_free+0xc0>
	} else
		b->next = cur->next;
c0104b0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b0d:	8b 50 04             	mov    0x4(%eax),%edx
c0104b10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b13:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c0104b16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b19:	8b 00                	mov    (%eax),%eax
c0104b1b:	c1 e0 03             	shl    $0x3,%eax
c0104b1e:	03 45 f4             	add    -0xc(%ebp),%eax
c0104b21:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104b24:	75 1f                	jne    c0104b45 <slob_free+0xef>
		cur->units += b->units;
c0104b26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b29:	8b 10                	mov    (%eax),%edx
c0104b2b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b2e:	8b 00                	mov    (%eax),%eax
c0104b30:	01 c2                	add    %eax,%edx
c0104b32:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b35:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c0104b37:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b3a:	8b 50 04             	mov    0x4(%eax),%edx
c0104b3d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b40:	89 50 04             	mov    %edx,0x4(%eax)
c0104b43:	eb 09                	jmp    c0104b4e <slob_free+0xf8>
	} else
		cur->next = b;
c0104b45:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b48:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104b4b:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c0104b4e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b51:	a3 08 aa 12 c0       	mov    %eax,0xc012aa08

	spin_unlock_irqrestore(&slob_lock, flags);
c0104b56:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104b59:	89 04 24             	mov    %eax,(%esp)
c0104b5c:	e8 8a fb ff ff       	call   c01046eb <__intr_restore>
c0104b61:	eb 01                	jmp    c0104b64 <slob_free+0x10e>
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
		return;
c0104b63:	90                   	nop
		cur->next = b;

	slobfree = cur;

	spin_unlock_irqrestore(&slob_lock, flags);
}
c0104b64:	c9                   	leave  
c0104b65:	c3                   	ret    

c0104b66 <slob_init>:



void
slob_init(void) {
c0104b66:	55                   	push   %ebp
c0104b67:	89 e5                	mov    %esp,%ebp
c0104b69:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c0104b6c:	c7 04 24 aa cd 10 c0 	movl   $0xc010cdaa,(%esp)
c0104b73:	e8 e7 b7 ff ff       	call   c010035f <cprintf>
}
c0104b78:	c9                   	leave  
c0104b79:	c3                   	ret    

c0104b7a <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104b7a:	55                   	push   %ebp
c0104b7b:	89 e5                	mov    %esp,%ebp
c0104b7d:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c0104b80:	e8 e1 ff ff ff       	call   c0104b66 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0104b85:	c7 04 24 be cd 10 c0 	movl   $0xc010cdbe,(%esp)
c0104b8c:	e8 ce b7 ff ff       	call   c010035f <cprintf>
}
c0104b91:	c9                   	leave  
c0104b92:	c3                   	ret    

c0104b93 <slob_allocated>:

size_t
slob_allocated(void) {
c0104b93:	55                   	push   %ebp
c0104b94:	89 e5                	mov    %esp,%ebp
  return 0;
c0104b96:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104b9b:	5d                   	pop    %ebp
c0104b9c:	c3                   	ret    

c0104b9d <kallocated>:

size_t
kallocated(void) {
c0104b9d:	55                   	push   %ebp
c0104b9e:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c0104ba0:	e8 ee ff ff ff       	call   c0104b93 <slob_allocated>
}
c0104ba5:	5d                   	pop    %ebp
c0104ba6:	c3                   	ret    

c0104ba7 <find_order>:

static int find_order(int size)
{
c0104ba7:	55                   	push   %ebp
c0104ba8:	89 e5                	mov    %esp,%ebp
c0104baa:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104bad:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104bb4:	eb 07                	jmp    c0104bbd <find_order+0x16>
		order++;
c0104bb6:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104bba:	d1 7d 08             	sarl   0x8(%ebp)
c0104bbd:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104bc4:	7f f0                	jg     c0104bb6 <find_order+0xf>
		order++;
	return order;
c0104bc6:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104bc9:	c9                   	leave  
c0104bca:	c3                   	ret    

c0104bcb <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104bcb:	55                   	push   %ebp
c0104bcc:	89 e5                	mov    %esp,%ebp
c0104bce:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c0104bd1:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104bd8:	77 38                	ja     c0104c12 <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bdd:	8d 50 08             	lea    0x8(%eax),%edx
c0104be0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104be7:	00 
c0104be8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104beb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104bef:	89 14 24             	mov    %edx,(%esp)
c0104bf2:	e8 8c fc ff ff       	call   c0104883 <slob_alloc>
c0104bf7:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104bfa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104bfe:	74 08                	je     c0104c08 <__kmalloc+0x3d>
c0104c00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c03:	83 c0 08             	add    $0x8,%eax
c0104c06:	eb 05                	jmp    c0104c0d <__kmalloc+0x42>
c0104c08:	b8 00 00 00 00       	mov    $0x0,%eax
c0104c0d:	e9 a6 00 00 00       	jmp    c0104cb8 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c0104c12:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104c19:	00 
c0104c1a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c1d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104c21:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c0104c28:	e8 56 fc ff ff       	call   c0104883 <slob_alloc>
c0104c2d:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c0104c30:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104c34:	75 07                	jne    c0104c3d <__kmalloc+0x72>
		return 0;
c0104c36:	b8 00 00 00 00       	mov    $0x0,%eax
c0104c3b:	eb 7b                	jmp    c0104cb8 <__kmalloc+0xed>

	bb->order = find_order(size);
c0104c3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c40:	89 04 24             	mov    %eax,(%esp)
c0104c43:	e8 5f ff ff ff       	call   c0104ba7 <find_order>
c0104c48:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104c4b:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c0104c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c50:	8b 00                	mov    (%eax),%eax
c0104c52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104c56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104c59:	89 04 24             	mov    %eax,(%esp)
c0104c5c:	e8 ac fb ff ff       	call   c010480d <__slob_get_free_pages>
c0104c61:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104c64:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c0104c67:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c6a:	8b 40 04             	mov    0x4(%eax),%eax
c0104c6d:	85 c0                	test   %eax,%eax
c0104c6f:	74 2f                	je     c0104ca0 <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c0104c71:	e8 46 fa ff ff       	call   c01046bc <__intr_save>
c0104c76:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0104c79:	8b 15 c4 cd 19 c0    	mov    0xc019cdc4,%edx
c0104c7f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c82:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0104c85:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c88:	a3 c4 cd 19 c0       	mov    %eax,0xc019cdc4
		spin_unlock_irqrestore(&block_lock, flags);
c0104c8d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c90:	89 04 24             	mov    %eax,(%esp)
c0104c93:	e8 53 fa ff ff       	call   c01046eb <__intr_restore>
		return bb->pages;
c0104c98:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104c9b:	8b 40 04             	mov    0x4(%eax),%eax
c0104c9e:	eb 18                	jmp    c0104cb8 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104ca0:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104ca7:	00 
c0104ca8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104cab:	89 04 24             	mov    %eax,(%esp)
c0104cae:	e8 a3 fd ff ff       	call   c0104a56 <slob_free>
	return 0;
c0104cb3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104cb8:	c9                   	leave  
c0104cb9:	c3                   	ret    

c0104cba <kmalloc>:

void *
kmalloc(size_t size)
{
c0104cba:	55                   	push   %ebp
c0104cbb:	89 e5                	mov    %esp,%ebp
c0104cbd:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104cc0:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104cc7:	00 
c0104cc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ccb:	89 04 24             	mov    %eax,(%esp)
c0104cce:	e8 f8 fe ff ff       	call   c0104bcb <__kmalloc>
}
c0104cd3:	c9                   	leave  
c0104cd4:	c3                   	ret    

c0104cd5 <kfree>:


void kfree(void *block)
{
c0104cd5:	55                   	push   %ebp
c0104cd6:	89 e5                	mov    %esp,%ebp
c0104cd8:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104cdb:	c7 45 f0 c4 cd 19 c0 	movl   $0xc019cdc4,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104ce2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104ce6:	0f 84 a4 00 00 00    	je     c0104d90 <kfree+0xbb>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104cec:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cef:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104cf4:	85 c0                	test   %eax,%eax
c0104cf6:	75 7f                	jne    c0104d77 <kfree+0xa2>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104cf8:	e8 bf f9 ff ff       	call   c01046bc <__intr_save>
c0104cfd:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104d00:	a1 c4 cd 19 c0       	mov    0xc019cdc4,%eax
c0104d05:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d08:	eb 5c                	jmp    c0104d66 <kfree+0x91>
			if (bb->pages == block) {
c0104d0a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d0d:	8b 40 04             	mov    0x4(%eax),%eax
c0104d10:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104d13:	75 3f                	jne    c0104d54 <kfree+0x7f>
				*last = bb->next;
c0104d15:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d18:	8b 50 08             	mov    0x8(%eax),%edx
c0104d1b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104d1e:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104d20:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d23:	89 04 24             	mov    %eax,(%esp)
c0104d26:	e8 c0 f9 ff ff       	call   c01046eb <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104d2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d2e:	8b 10                	mov    (%eax),%edx
c0104d30:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d33:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104d37:	89 04 24             	mov    %eax,(%esp)
c0104d3a:	e8 0e fb ff ff       	call   c010484d <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104d3f:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104d46:	00 
c0104d47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d4a:	89 04 24             	mov    %eax,(%esp)
c0104d4d:	e8 04 fd ff ff       	call   c0104a56 <slob_free>
				return;
c0104d52:	eb 3d                	jmp    c0104d91 <kfree+0xbc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d57:	83 c0 08             	add    $0x8,%eax
c0104d5a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104d5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104d60:	8b 40 08             	mov    0x8(%eax),%eax
c0104d63:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104d66:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d6a:	75 9e                	jne    c0104d0a <kfree+0x35>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104d6c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104d6f:	89 04 24             	mov    %eax,(%esp)
c0104d72:	e8 74 f9 ff ff       	call   c01046eb <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104d77:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d7a:	83 e8 08             	sub    $0x8,%eax
c0104d7d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104d84:	00 
c0104d85:	89 04 24             	mov    %eax,(%esp)
c0104d88:	e8 c9 fc ff ff       	call   c0104a56 <slob_free>
	return;
c0104d8d:	90                   	nop
c0104d8e:	eb 01                	jmp    c0104d91 <kfree+0xbc>
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
		return;
c0104d90:	90                   	nop
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
c0104d91:	c9                   	leave  
c0104d92:	c3                   	ret    

c0104d93 <ksize>:


unsigned int ksize(const void *block)
{
c0104d93:	55                   	push   %ebp
c0104d94:	89 e5                	mov    %esp,%ebp
c0104d96:	53                   	push   %ebx
c0104d97:	83 ec 24             	sub    $0x24,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104d9a:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104d9e:	75 07                	jne    c0104da7 <ksize+0x14>
		return 0;
c0104da0:	b8 00 00 00 00       	mov    $0x0,%eax
c0104da5:	eb 6d                	jmp    c0104e14 <ksize+0x81>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104da7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104daa:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104daf:	85 c0                	test   %eax,%eax
c0104db1:	75 56                	jne    c0104e09 <ksize+0x76>
		spin_lock_irqsave(&block_lock, flags);
c0104db3:	e8 04 f9 ff ff       	call   c01046bc <__intr_save>
c0104db8:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104dbb:	a1 c4 cd 19 c0       	mov    0xc019cdc4,%eax
c0104dc0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104dc3:	eb 33                	jmp    c0104df8 <ksize+0x65>
			if (bb->pages == block) {
c0104dc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dc8:	8b 40 04             	mov    0x4(%eax),%eax
c0104dcb:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104dce:	75 1f                	jne    c0104def <ksize+0x5c>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104dd0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104dd3:	89 04 24             	mov    %eax,(%esp)
c0104dd6:	e8 10 f9 ff ff       	call   c01046eb <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104ddb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dde:	8b 00                	mov    (%eax),%eax
c0104de0:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104de5:	89 d3                	mov    %edx,%ebx
c0104de7:	89 c1                	mov    %eax,%ecx
c0104de9:	d3 e3                	shl    %cl,%ebx
c0104deb:	89 d8                	mov    %ebx,%eax
c0104ded:	eb 25                	jmp    c0104e14 <ksize+0x81>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104def:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104df2:	8b 40 08             	mov    0x8(%eax),%eax
c0104df5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104df8:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104dfc:	75 c7                	jne    c0104dc5 <ksize+0x32>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104dfe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e01:	89 04 24             	mov    %eax,(%esp)
c0104e04:	e8 e2 f8 ff ff       	call   c01046eb <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104e09:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e0c:	83 e8 08             	sub    $0x8,%eax
c0104e0f:	8b 00                	mov    (%eax),%eax
c0104e11:	c1 e0 03             	shl    $0x3,%eax
}
c0104e14:	83 c4 24             	add    $0x24,%esp
c0104e17:	5b                   	pop    %ebx
c0104e18:	5d                   	pop    %ebp
c0104e19:	c3                   	ret    
	...

c0104e1c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104e1c:	55                   	push   %ebp
c0104e1d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104e1f:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e22:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c0104e27:	89 d1                	mov    %edx,%ecx
c0104e29:	29 c1                	sub    %eax,%ecx
c0104e2b:	89 c8                	mov    %ecx,%eax
c0104e2d:	c1 f8 05             	sar    $0x5,%eax
}
c0104e30:	5d                   	pop    %ebp
c0104e31:	c3                   	ret    

c0104e32 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104e32:	55                   	push   %ebp
c0104e33:	89 e5                	mov    %esp,%ebp
c0104e35:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104e38:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e3b:	89 04 24             	mov    %eax,(%esp)
c0104e3e:	e8 d9 ff ff ff       	call   c0104e1c <page2ppn>
c0104e43:	c1 e0 0c             	shl    $0xc,%eax
}
c0104e46:	c9                   	leave  
c0104e47:	c3                   	ret    

c0104e48 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104e48:	55                   	push   %ebp
c0104e49:	89 e5                	mov    %esp,%ebp
c0104e4b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e51:	89 c2                	mov    %eax,%edx
c0104e53:	c1 ea 0c             	shr    $0xc,%edx
c0104e56:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c0104e5b:	39 c2                	cmp    %eax,%edx
c0104e5d:	72 1c                	jb     c0104e7b <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104e5f:	c7 44 24 08 dc cd 10 	movl   $0xc010cddc,0x8(%esp)
c0104e66:	c0 
c0104e67:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0104e6e:	00 
c0104e6f:	c7 04 24 fb cd 10 c0 	movl   $0xc010cdfb,(%esp)
c0104e76:	e8 3d bf ff ff       	call   c0100db8 <__panic>
    }
    return &pages[PPN(pa)];
c0104e7b:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c0104e80:	8b 55 08             	mov    0x8(%ebp),%edx
c0104e83:	c1 ea 0c             	shr    $0xc,%edx
c0104e86:	c1 e2 05             	shl    $0x5,%edx
c0104e89:	01 d0                	add    %edx,%eax
}
c0104e8b:	c9                   	leave  
c0104e8c:	c3                   	ret    

c0104e8d <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104e8d:	55                   	push   %ebp
c0104e8e:	89 e5                	mov    %esp,%ebp
c0104e90:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104e93:	8b 45 08             	mov    0x8(%ebp),%eax
c0104e96:	89 04 24             	mov    %eax,(%esp)
c0104e99:	e8 94 ff ff ff       	call   c0104e32 <page2pa>
c0104e9e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104ea1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ea4:	c1 e8 0c             	shr    $0xc,%eax
c0104ea7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104eaa:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c0104eaf:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104eb2:	72 23                	jb     c0104ed7 <page2kva+0x4a>
c0104eb4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eb7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104ebb:	c7 44 24 08 0c ce 10 	movl   $0xc010ce0c,0x8(%esp)
c0104ec2:	c0 
c0104ec3:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0104eca:	00 
c0104ecb:	c7 04 24 fb cd 10 c0 	movl   $0xc010cdfb,(%esp)
c0104ed2:	e8 e1 be ff ff       	call   c0100db8 <__panic>
c0104ed7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104eda:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104edf:	c9                   	leave  
c0104ee0:	c3                   	ret    

c0104ee1 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104ee1:	55                   	push   %ebp
c0104ee2:	89 e5                	mov    %esp,%ebp
c0104ee4:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104ee7:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eea:	83 e0 01             	and    $0x1,%eax
c0104eed:	85 c0                	test   %eax,%eax
c0104eef:	75 1c                	jne    c0104f0d <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104ef1:	c7 44 24 08 30 ce 10 	movl   $0xc010ce30,0x8(%esp)
c0104ef8:	c0 
c0104ef9:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0104f00:	00 
c0104f01:	c7 04 24 fb cd 10 c0 	movl   $0xc010cdfb,(%esp)
c0104f08:	e8 ab be ff ff       	call   c0100db8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104f0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f10:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f15:	89 04 24             	mov    %eax,(%esp)
c0104f18:	e8 2b ff ff ff       	call   c0104e48 <pa2page>
}
c0104f1d:	c9                   	leave  
c0104f1e:	c3                   	ret    

c0104f1f <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104f1f:	55                   	push   %ebp
c0104f20:	89 e5                	mov    %esp,%ebp
c0104f22:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104f25:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f28:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104f2d:	89 04 24             	mov    %eax,(%esp)
c0104f30:	e8 13 ff ff ff       	call   c0104e48 <pa2page>
}
c0104f35:	c9                   	leave  
c0104f36:	c3                   	ret    

c0104f37 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0104f37:	55                   	push   %ebp
c0104f38:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104f3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f3d:	8b 00                	mov    (%eax),%eax
}
c0104f3f:	5d                   	pop    %ebp
c0104f40:	c3                   	ret    

c0104f41 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104f41:	55                   	push   %ebp
c0104f42:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104f44:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f47:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104f4a:	89 10                	mov    %edx,(%eax)
}
c0104f4c:	5d                   	pop    %ebp
c0104f4d:	c3                   	ret    

c0104f4e <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104f4e:	55                   	push   %ebp
c0104f4f:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104f51:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f54:	8b 00                	mov    (%eax),%eax
c0104f56:	8d 50 01             	lea    0x1(%eax),%edx
c0104f59:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f5c:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104f5e:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f61:	8b 00                	mov    (%eax),%eax
}
c0104f63:	5d                   	pop    %ebp
c0104f64:	c3                   	ret    

c0104f65 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104f65:	55                   	push   %ebp
c0104f66:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104f68:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f6b:	8b 00                	mov    (%eax),%eax
c0104f6d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104f70:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f73:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104f75:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f78:	8b 00                	mov    (%eax),%eax
}
c0104f7a:	5d                   	pop    %ebp
c0104f7b:	c3                   	ret    

c0104f7c <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c0104f7c:	55                   	push   %ebp
c0104f7d:	89 e5                	mov    %esp,%ebp
c0104f7f:	53                   	push   %ebx
c0104f80:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104f83:	9c                   	pushf  
c0104f84:	5b                   	pop    %ebx
c0104f85:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0104f88:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104f8b:	25 00 02 00 00       	and    $0x200,%eax
c0104f90:	85 c0                	test   %eax,%eax
c0104f92:	74 0c                	je     c0104fa0 <__intr_save+0x24>
        intr_disable();
c0104f94:	e8 4d d1 ff ff       	call   c01020e6 <intr_disable>
        return 1;
c0104f99:	b8 01 00 00 00       	mov    $0x1,%eax
c0104f9e:	eb 05                	jmp    c0104fa5 <__intr_save+0x29>
    }
    return 0;
c0104fa0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104fa5:	83 c4 14             	add    $0x14,%esp
c0104fa8:	5b                   	pop    %ebx
c0104fa9:	5d                   	pop    %ebp
c0104faa:	c3                   	ret    

c0104fab <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104fab:	55                   	push   %ebp
c0104fac:	89 e5                	mov    %esp,%ebp
c0104fae:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104fb1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104fb5:	74 05                	je     c0104fbc <__intr_restore+0x11>
        intr_enable();
c0104fb7:	e8 24 d1 ff ff       	call   c01020e0 <intr_enable>
    }
}
c0104fbc:	c9                   	leave  
c0104fbd:	c3                   	ret    

c0104fbe <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104fbe:	55                   	push   %ebp
c0104fbf:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104fc1:	8b 45 08             	mov    0x8(%ebp),%eax
c0104fc4:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104fc7:	b8 23 00 00 00       	mov    $0x23,%eax
c0104fcc:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104fce:	b8 23 00 00 00       	mov    $0x23,%eax
c0104fd3:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104fd5:	b8 10 00 00 00       	mov    $0x10,%eax
c0104fda:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104fdc:	b8 10 00 00 00       	mov    $0x10,%eax
c0104fe1:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104fe3:	b8 10 00 00 00       	mov    $0x10,%eax
c0104fe8:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104fea:	ea f1 4f 10 c0 08 00 	ljmp   $0x8,$0xc0104ff1
}
c0104ff1:	5d                   	pop    %ebp
c0104ff2:	c3                   	ret    

c0104ff3 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104ff3:	55                   	push   %ebp
c0104ff4:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104ff6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ff9:	a3 04 ce 19 c0       	mov    %eax,0xc019ce04
}
c0104ffe:	5d                   	pop    %ebp
c0104fff:	c3                   	ret    

c0105000 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0105000:	55                   	push   %ebp
c0105001:	89 e5                	mov    %esp,%ebp
c0105003:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0105006:	b8 00 a0 12 c0       	mov    $0xc012a000,%eax
c010500b:	89 04 24             	mov    %eax,(%esp)
c010500e:	e8 e0 ff ff ff       	call   c0104ff3 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0105013:	66 c7 05 08 ce 19 c0 	movw   $0x10,0xc019ce08
c010501a:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c010501c:	66 c7 05 48 aa 12 c0 	movw   $0x68,0xc012aa48
c0105023:	68 00 
c0105025:	b8 00 ce 19 c0       	mov    $0xc019ce00,%eax
c010502a:	66 a3 4a aa 12 c0    	mov    %ax,0xc012aa4a
c0105030:	b8 00 ce 19 c0       	mov    $0xc019ce00,%eax
c0105035:	c1 e8 10             	shr    $0x10,%eax
c0105038:	a2 4c aa 12 c0       	mov    %al,0xc012aa4c
c010503d:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0105044:	83 e0 f0             	and    $0xfffffff0,%eax
c0105047:	83 c8 09             	or     $0x9,%eax
c010504a:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c010504f:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0105056:	83 e0 ef             	and    $0xffffffef,%eax
c0105059:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c010505e:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0105065:	83 e0 9f             	and    $0xffffff9f,%eax
c0105068:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c010506d:	0f b6 05 4d aa 12 c0 	movzbl 0xc012aa4d,%eax
c0105074:	83 c8 80             	or     $0xffffff80,%eax
c0105077:	a2 4d aa 12 c0       	mov    %al,0xc012aa4d
c010507c:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0105083:	83 e0 f0             	and    $0xfffffff0,%eax
c0105086:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c010508b:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c0105092:	83 e0 ef             	and    $0xffffffef,%eax
c0105095:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c010509a:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c01050a1:	83 e0 df             	and    $0xffffffdf,%eax
c01050a4:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c01050a9:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c01050b0:	83 c8 40             	or     $0x40,%eax
c01050b3:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c01050b8:	0f b6 05 4e aa 12 c0 	movzbl 0xc012aa4e,%eax
c01050bf:	83 e0 7f             	and    $0x7f,%eax
c01050c2:	a2 4e aa 12 c0       	mov    %al,0xc012aa4e
c01050c7:	b8 00 ce 19 c0       	mov    $0xc019ce00,%eax
c01050cc:	c1 e8 18             	shr    $0x18,%eax
c01050cf:	a2 4f aa 12 c0       	mov    %al,0xc012aa4f

    // reload all segment registers
    lgdt(&gdt_pd);
c01050d4:	c7 04 24 50 aa 12 c0 	movl   $0xc012aa50,(%esp)
c01050db:	e8 de fe ff ff       	call   c0104fbe <lgdt>
c01050e0:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c01050e6:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c01050ea:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c01050ed:	c9                   	leave  
c01050ee:	c3                   	ret    

c01050ef <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c01050ef:	55                   	push   %ebp
c01050f0:	89 e5                	mov    %esp,%ebp
c01050f2:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c01050f5:	c7 05 c4 ee 19 c0 d0 	movl   $0xc010ccd0,0xc019eec4
c01050fc:	cc 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c01050ff:	a1 c4 ee 19 c0       	mov    0xc019eec4,%eax
c0105104:	8b 00                	mov    (%eax),%eax
c0105106:	89 44 24 04          	mov    %eax,0x4(%esp)
c010510a:	c7 04 24 5c ce 10 c0 	movl   $0xc010ce5c,(%esp)
c0105111:	e8 49 b2 ff ff       	call   c010035f <cprintf>
    pmm_manager->init();
c0105116:	a1 c4 ee 19 c0       	mov    0xc019eec4,%eax
c010511b:	8b 40 04             	mov    0x4(%eax),%eax
c010511e:	ff d0                	call   *%eax
}
c0105120:	c9                   	leave  
c0105121:	c3                   	ret    

c0105122 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0105122:	55                   	push   %ebp
c0105123:	89 e5                	mov    %esp,%ebp
c0105125:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0105128:	a1 c4 ee 19 c0       	mov    0xc019eec4,%eax
c010512d:	8b 50 08             	mov    0x8(%eax),%edx
c0105130:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105133:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105137:	8b 45 08             	mov    0x8(%ebp),%eax
c010513a:	89 04 24             	mov    %eax,(%esp)
c010513d:	ff d2                	call   *%edx
}
c010513f:	c9                   	leave  
c0105140:	c3                   	ret    

c0105141 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0105141:	55                   	push   %ebp
c0105142:	89 e5                	mov    %esp,%ebp
c0105144:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0105147:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c010514e:	e8 29 fe ff ff       	call   c0104f7c <__intr_save>
c0105153:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0105156:	a1 c4 ee 19 c0       	mov    0xc019eec4,%eax
c010515b:	8b 50 0c             	mov    0xc(%eax),%edx
c010515e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105161:	89 04 24             	mov    %eax,(%esp)
c0105164:	ff d2                	call   *%edx
c0105166:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0105169:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010516c:	89 04 24             	mov    %eax,(%esp)
c010516f:	e8 37 fe ff ff       	call   c0104fab <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0105174:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105178:	75 2d                	jne    c01051a7 <alloc_pages+0x66>
c010517a:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c010517e:	77 27                	ja     c01051a7 <alloc_pages+0x66>
c0105180:	a1 6c ce 19 c0       	mov    0xc019ce6c,%eax
c0105185:	85 c0                	test   %eax,%eax
c0105187:	74 1e                	je     c01051a7 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0105189:	8b 55 08             	mov    0x8(%ebp),%edx
c010518c:	a1 ac ef 19 c0       	mov    0xc019efac,%eax
c0105191:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105198:	00 
c0105199:	89 54 24 04          	mov    %edx,0x4(%esp)
c010519d:	89 04 24             	mov    %eax,(%esp)
c01051a0:	e8 a2 1d 00 00       	call   c0106f47 <swap_out>
    }
c01051a5:	eb a7                	jmp    c010514e <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c01051a7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01051aa:	c9                   	leave  
c01051ab:	c3                   	ret    

c01051ac <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c01051ac:	55                   	push   %ebp
c01051ad:	89 e5                	mov    %esp,%ebp
c01051af:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01051b2:	e8 c5 fd ff ff       	call   c0104f7c <__intr_save>
c01051b7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c01051ba:	a1 c4 ee 19 c0       	mov    0xc019eec4,%eax
c01051bf:	8b 50 10             	mov    0x10(%eax),%edx
c01051c2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051cc:	89 04 24             	mov    %eax,(%esp)
c01051cf:	ff d2                	call   *%edx
    }
    local_intr_restore(intr_flag);
c01051d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051d4:	89 04 24             	mov    %eax,(%esp)
c01051d7:	e8 cf fd ff ff       	call   c0104fab <__intr_restore>
}
c01051dc:	c9                   	leave  
c01051dd:	c3                   	ret    

c01051de <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c01051de:	55                   	push   %ebp
c01051df:	89 e5                	mov    %esp,%ebp
c01051e1:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c01051e4:	e8 93 fd ff ff       	call   c0104f7c <__intr_save>
c01051e9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c01051ec:	a1 c4 ee 19 c0       	mov    0xc019eec4,%eax
c01051f1:	8b 40 14             	mov    0x14(%eax),%eax
c01051f4:	ff d0                	call   *%eax
c01051f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c01051f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051fc:	89 04 24             	mov    %eax,(%esp)
c01051ff:	e8 a7 fd ff ff       	call   c0104fab <__intr_restore>
    return ret;
c0105204:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0105207:	c9                   	leave  
c0105208:	c3                   	ret    

c0105209 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0105209:	55                   	push   %ebp
c010520a:	89 e5                	mov    %esp,%ebp
c010520c:	57                   	push   %edi
c010520d:	56                   	push   %esi
c010520e:	53                   	push   %ebx
c010520f:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0105215:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c010521c:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0105223:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c010522a:	c7 04 24 73 ce 10 c0 	movl   $0xc010ce73,(%esp)
c0105231:	e8 29 b1 ff ff       	call   c010035f <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105236:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010523d:	e9 0b 01 00 00       	jmp    c010534d <page_init+0x144>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105242:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105245:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105248:	89 d0                	mov    %edx,%eax
c010524a:	c1 e0 02             	shl    $0x2,%eax
c010524d:	01 d0                	add    %edx,%eax
c010524f:	c1 e0 02             	shl    $0x2,%eax
c0105252:	01 c8                	add    %ecx,%eax
c0105254:	8b 50 08             	mov    0x8(%eax),%edx
c0105257:	8b 40 04             	mov    0x4(%eax),%eax
c010525a:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010525d:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0105260:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105263:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105266:	89 d0                	mov    %edx,%eax
c0105268:	c1 e0 02             	shl    $0x2,%eax
c010526b:	01 d0                	add    %edx,%eax
c010526d:	c1 e0 02             	shl    $0x2,%eax
c0105270:	01 c8                	add    %ecx,%eax
c0105272:	8b 50 10             	mov    0x10(%eax),%edx
c0105275:	8b 40 0c             	mov    0xc(%eax),%eax
c0105278:	03 45 b8             	add    -0x48(%ebp),%eax
c010527b:	13 55 bc             	adc    -0x44(%ebp),%edx
c010527e:	89 45 b0             	mov    %eax,-0x50(%ebp)
c0105281:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c0105284:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0105287:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010528a:	89 d0                	mov    %edx,%eax
c010528c:	c1 e0 02             	shl    $0x2,%eax
c010528f:	01 d0                	add    %edx,%eax
c0105291:	c1 e0 02             	shl    $0x2,%eax
c0105294:	01 c8                	add    %ecx,%eax
c0105296:	83 c0 14             	add    $0x14,%eax
c0105299:	8b 00                	mov    (%eax),%eax
c010529b:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010529e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01052a1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01052a4:	89 c6                	mov    %eax,%esi
c01052a6:	89 d7                	mov    %edx,%edi
c01052a8:	83 c6 ff             	add    $0xffffffff,%esi
c01052ab:	83 d7 ff             	adc    $0xffffffff,%edi
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c01052ae:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01052b1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052b4:	89 d0                	mov    %edx,%eax
c01052b6:	c1 e0 02             	shl    $0x2,%eax
c01052b9:	01 d0                	add    %edx,%eax
c01052bb:	c1 e0 02             	shl    $0x2,%eax
c01052be:	01 c8                	add    %ecx,%eax
c01052c0:	8b 48 0c             	mov    0xc(%eax),%ecx
c01052c3:	8b 58 10             	mov    0x10(%eax),%ebx
c01052c6:	8b 45 84             	mov    -0x7c(%ebp),%eax
c01052c9:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c01052cd:	89 74 24 14          	mov    %esi,0x14(%esp)
c01052d1:	89 7c 24 18          	mov    %edi,0x18(%esp)
c01052d5:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01052d8:	8b 55 bc             	mov    -0x44(%ebp),%edx
c01052db:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01052df:	89 54 24 10          	mov    %edx,0x10(%esp)
c01052e3:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01052e7:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c01052eb:	c7 04 24 80 ce 10 c0 	movl   $0xc010ce80,(%esp)
c01052f2:	e8 68 b0 ff ff       	call   c010035f <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c01052f7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01052fa:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01052fd:	89 d0                	mov    %edx,%eax
c01052ff:	c1 e0 02             	shl    $0x2,%eax
c0105302:	01 d0                	add    %edx,%eax
c0105304:	c1 e0 02             	shl    $0x2,%eax
c0105307:	01 c8                	add    %ecx,%eax
c0105309:	83 c0 14             	add    $0x14,%eax
c010530c:	8b 00                	mov    (%eax),%eax
c010530e:	83 f8 01             	cmp    $0x1,%eax
c0105311:	75 36                	jne    c0105349 <page_init+0x140>
            if (maxpa < end && begin < KMEMSIZE) {
c0105313:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105316:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105319:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c010531c:	77 2b                	ja     c0105349 <page_init+0x140>
c010531e:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0105321:	72 05                	jb     c0105328 <page_init+0x11f>
c0105323:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c0105326:	73 21                	jae    c0105349 <page_init+0x140>
c0105328:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010532c:	77 1b                	ja     c0105349 <page_init+0x140>
c010532e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0105332:	72 09                	jb     c010533d <page_init+0x134>
c0105334:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c010533b:	77 0c                	ja     c0105349 <page_init+0x140>
                maxpa = end;
c010533d:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0105340:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105343:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105346:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0105349:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010534d:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0105350:	8b 00                	mov    (%eax),%eax
c0105352:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105355:	0f 8f e7 fe ff ff    	jg     c0105242 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c010535b:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010535f:	72 1d                	jb     c010537e <page_init+0x175>
c0105361:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105365:	77 09                	ja     c0105370 <page_init+0x167>
c0105367:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c010536e:	76 0e                	jbe    c010537e <page_init+0x175>
        maxpa = KMEMSIZE;
c0105370:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0105377:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010537e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105381:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105384:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0105388:	c1 ea 0c             	shr    $0xc,%edx
c010538b:	a3 e0 cd 19 c0       	mov    %eax,0xc019cde0
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c0105390:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0105397:	b8 b8 ef 19 c0       	mov    $0xc019efb8,%eax
c010539c:	83 e8 01             	sub    $0x1,%eax
c010539f:	03 45 ac             	add    -0x54(%ebp),%eax
c01053a2:	89 45 a8             	mov    %eax,-0x58(%ebp)
c01053a5:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01053a8:	ba 00 00 00 00       	mov    $0x0,%edx
c01053ad:	f7 75 ac             	divl   -0x54(%ebp)
c01053b0:	89 d0                	mov    %edx,%eax
c01053b2:	8b 55 a8             	mov    -0x58(%ebp),%edx
c01053b5:	89 d1                	mov    %edx,%ecx
c01053b7:	29 c1                	sub    %eax,%ecx
c01053b9:	89 c8                	mov    %ecx,%eax
c01053bb:	a3 cc ee 19 c0       	mov    %eax,0xc019eecc

    for (i = 0; i < npage; i ++) {
c01053c0:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01053c7:	eb 27                	jmp    c01053f0 <page_init+0x1e7>
        SetPageReserved(pages + i);
c01053c9:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c01053ce:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053d1:	c1 e2 05             	shl    $0x5,%edx
c01053d4:	01 d0                	add    %edx,%eax
c01053d6:	83 c0 04             	add    $0x4,%eax
c01053d9:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c01053e0:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01053e3:	8b 45 8c             	mov    -0x74(%ebp),%eax
c01053e6:	8b 55 90             	mov    -0x70(%ebp),%edx
c01053e9:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c01053ec:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01053f0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01053f3:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c01053f8:	39 c2                	cmp    %eax,%edx
c01053fa:	72 cd                	jb     c01053c9 <page_init+0x1c0>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c01053fc:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c0105401:	89 c2                	mov    %eax,%edx
c0105403:	c1 e2 05             	shl    $0x5,%edx
c0105406:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c010540b:	01 d0                	add    %edx,%eax
c010540d:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0105410:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0105417:	77 23                	ja     c010543c <page_init+0x233>
c0105419:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010541c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105420:	c7 44 24 08 b0 ce 10 	movl   $0xc010ceb0,0x8(%esp)
c0105427:	c0 
c0105428:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010542f:	00 
c0105430:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105437:	e8 7c b9 ff ff       	call   c0100db8 <__panic>
c010543c:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c010543f:	05 00 00 00 40       	add    $0x40000000,%eax
c0105444:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0105447:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010544e:	e9 7c 01 00 00       	jmp    c01055cf <page_init+0x3c6>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0105453:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105456:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105459:	89 d0                	mov    %edx,%eax
c010545b:	c1 e0 02             	shl    $0x2,%eax
c010545e:	01 d0                	add    %edx,%eax
c0105460:	c1 e0 02             	shl    $0x2,%eax
c0105463:	01 c8                	add    %ecx,%eax
c0105465:	8b 50 08             	mov    0x8(%eax),%edx
c0105468:	8b 40 04             	mov    0x4(%eax),%eax
c010546b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010546e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0105471:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105474:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105477:	89 d0                	mov    %edx,%eax
c0105479:	c1 e0 02             	shl    $0x2,%eax
c010547c:	01 d0                	add    %edx,%eax
c010547e:	c1 e0 02             	shl    $0x2,%eax
c0105481:	01 c8                	add    %ecx,%eax
c0105483:	8b 50 10             	mov    0x10(%eax),%edx
c0105486:	8b 40 0c             	mov    0xc(%eax),%eax
c0105489:	03 45 d0             	add    -0x30(%ebp),%eax
c010548c:	13 55 d4             	adc    -0x2c(%ebp),%edx
c010548f:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105492:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0105495:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105498:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010549b:	89 d0                	mov    %edx,%eax
c010549d:	c1 e0 02             	shl    $0x2,%eax
c01054a0:	01 d0                	add    %edx,%eax
c01054a2:	c1 e0 02             	shl    $0x2,%eax
c01054a5:	01 c8                	add    %ecx,%eax
c01054a7:	83 c0 14             	add    $0x14,%eax
c01054aa:	8b 00                	mov    (%eax),%eax
c01054ac:	83 f8 01             	cmp    $0x1,%eax
c01054af:	0f 85 16 01 00 00    	jne    c01055cb <page_init+0x3c2>
            if (begin < freemem) {
c01054b5:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01054b8:	ba 00 00 00 00       	mov    $0x0,%edx
c01054bd:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054c0:	72 17                	jb     c01054d9 <page_init+0x2d0>
c01054c2:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c01054c5:	77 05                	ja     c01054cc <page_init+0x2c3>
c01054c7:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c01054ca:	76 0d                	jbe    c01054d9 <page_init+0x2d0>
                begin = freemem;
c01054cc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01054cf:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01054d2:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c01054d9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01054dd:	72 1d                	jb     c01054fc <page_init+0x2f3>
c01054df:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01054e3:	77 09                	ja     c01054ee <page_init+0x2e5>
c01054e5:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c01054ec:	76 0e                	jbe    c01054fc <page_init+0x2f3>
                end = KMEMSIZE;
c01054ee:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c01054f5:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c01054fc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01054ff:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105502:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105505:	0f 87 c0 00 00 00    	ja     c01055cb <page_init+0x3c2>
c010550b:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010550e:	72 09                	jb     c0105519 <page_init+0x310>
c0105510:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105513:	0f 83 b2 00 00 00    	jae    c01055cb <page_init+0x3c2>
                begin = ROUNDUP(begin, PGSIZE);
c0105519:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0105520:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105523:	03 45 9c             	add    -0x64(%ebp),%eax
c0105526:	83 e8 01             	sub    $0x1,%eax
c0105529:	89 45 98             	mov    %eax,-0x68(%ebp)
c010552c:	8b 45 98             	mov    -0x68(%ebp),%eax
c010552f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105534:	f7 75 9c             	divl   -0x64(%ebp)
c0105537:	89 d0                	mov    %edx,%eax
c0105539:	8b 55 98             	mov    -0x68(%ebp),%edx
c010553c:	89 d1                	mov    %edx,%ecx
c010553e:	29 c1                	sub    %eax,%ecx
c0105540:	89 c8                	mov    %ecx,%eax
c0105542:	ba 00 00 00 00       	mov    $0x0,%edx
c0105547:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010554a:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c010554d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105550:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0105553:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0105556:	ba 00 00 00 00       	mov    $0x0,%edx
c010555b:	89 c1                	mov    %eax,%ecx
c010555d:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
c0105563:	89 8d 78 ff ff ff    	mov    %ecx,-0x88(%ebp)
c0105569:	89 d1                	mov    %edx,%ecx
c010556b:	83 e1 00             	and    $0x0,%ecx
c010556e:	89 8d 7c ff ff ff    	mov    %ecx,-0x84(%ebp)
c0105574:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c010557a:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0105580:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0105583:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105586:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105589:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010558c:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010558f:	77 3a                	ja     c01055cb <page_init+0x3c2>
c0105591:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105594:	72 05                	jb     c010559b <page_init+0x392>
c0105596:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105599:	73 30                	jae    c01055cb <page_init+0x3c2>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c010559b:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010559e:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c01055a1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01055a4:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01055a7:	29 c8                	sub    %ecx,%eax
c01055a9:	19 da                	sbb    %ebx,%edx
c01055ab:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01055af:	c1 ea 0c             	shr    $0xc,%edx
c01055b2:	89 c3                	mov    %eax,%ebx
c01055b4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01055b7:	89 04 24             	mov    %eax,(%esp)
c01055ba:	e8 89 f8 ff ff       	call   c0104e48 <pa2page>
c01055bf:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c01055c3:	89 04 24             	mov    %eax,(%esp)
c01055c6:	e8 57 fb ff ff       	call   c0105122 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c01055cb:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01055cf:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01055d2:	8b 00                	mov    (%eax),%eax
c01055d4:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01055d7:	0f 8f 76 fe ff ff    	jg     c0105453 <page_init+0x24a>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c01055dd:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c01055e3:	5b                   	pop    %ebx
c01055e4:	5e                   	pop    %esi
c01055e5:	5f                   	pop    %edi
c01055e6:	5d                   	pop    %ebp
c01055e7:	c3                   	ret    

c01055e8 <enable_paging>:

static void
enable_paging(void) {
c01055e8:	55                   	push   %ebp
c01055e9:	89 e5                	mov    %esp,%ebp
c01055eb:	53                   	push   %ebx
c01055ec:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c01055ef:	a1 c8 ee 19 c0       	mov    0xc019eec8,%eax
c01055f4:	89 45 f4             	mov    %eax,-0xc(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01055f7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01055fa:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c01055fd:	0f 20 c3             	mov    %cr0,%ebx
c0105600:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr0;
c0105603:	8b 45 f0             	mov    -0x10(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105606:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0105609:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0105610:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0105614:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0105617:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c010561a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010561d:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0105620:	83 c4 10             	add    $0x10,%esp
c0105623:	5b                   	pop    %ebx
c0105624:	5d                   	pop    %ebp
c0105625:	c3                   	ret    

c0105626 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0105626:	55                   	push   %ebp
c0105627:	89 e5                	mov    %esp,%ebp
c0105629:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c010562c:	8b 45 14             	mov    0x14(%ebp),%eax
c010562f:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105632:	31 d0                	xor    %edx,%eax
c0105634:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105639:	85 c0                	test   %eax,%eax
c010563b:	74 24                	je     c0105661 <boot_map_segment+0x3b>
c010563d:	c7 44 24 0c e2 ce 10 	movl   $0xc010cee2,0xc(%esp)
c0105644:	c0 
c0105645:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c010564c:	c0 
c010564d:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c0105654:	00 
c0105655:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010565c:	e8 57 b7 ff ff       	call   c0100db8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0105661:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0105668:	8b 45 0c             	mov    0xc(%ebp),%eax
c010566b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105670:	03 45 10             	add    0x10(%ebp),%eax
c0105673:	03 45 f0             	add    -0x10(%ebp),%eax
c0105676:	83 e8 01             	sub    $0x1,%eax
c0105679:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010567c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010567f:	ba 00 00 00 00       	mov    $0x0,%edx
c0105684:	f7 75 f0             	divl   -0x10(%ebp)
c0105687:	89 d0                	mov    %edx,%eax
c0105689:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010568c:	89 d1                	mov    %edx,%ecx
c010568e:	29 c1                	sub    %eax,%ecx
c0105690:	89 c8                	mov    %ecx,%eax
c0105692:	c1 e8 0c             	shr    $0xc,%eax
c0105695:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105698:	8b 45 0c             	mov    0xc(%ebp),%eax
c010569b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010569e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056a1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01056a6:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c01056a9:	8b 45 14             	mov    0x14(%ebp),%eax
c01056ac:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056af:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056b2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01056b7:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01056ba:	eb 6b                	jmp    c0105727 <boot_map_segment+0x101>
        pte_t *ptep = get_pte(pgdir, la, 1);
c01056bc:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01056c3:	00 
c01056c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01056c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01056cb:	8b 45 08             	mov    0x8(%ebp),%eax
c01056ce:	89 04 24             	mov    %eax,(%esp)
c01056d1:	e8 d1 01 00 00       	call   c01058a7 <get_pte>
c01056d6:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c01056d9:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01056dd:	75 24                	jne    c0105703 <boot_map_segment+0xdd>
c01056df:	c7 44 24 0c 0e cf 10 	movl   $0xc010cf0e,0xc(%esp)
c01056e6:	c0 
c01056e7:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01056ee:	c0 
c01056ef:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c01056f6:	00 
c01056f7:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01056fe:	e8 b5 b6 ff ff       	call   c0100db8 <__panic>
        *ptep = pa | PTE_P | perm;
c0105703:	8b 45 18             	mov    0x18(%ebp),%eax
c0105706:	8b 55 14             	mov    0x14(%ebp),%edx
c0105709:	09 d0                	or     %edx,%eax
c010570b:	89 c2                	mov    %eax,%edx
c010570d:	83 ca 01             	or     $0x1,%edx
c0105710:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105713:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105715:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0105719:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0105720:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0105727:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010572b:	75 8f                	jne    c01056bc <boot_map_segment+0x96>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c010572d:	c9                   	leave  
c010572e:	c3                   	ret    

c010572f <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c010572f:	55                   	push   %ebp
c0105730:	89 e5                	mov    %esp,%ebp
c0105732:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0105735:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010573c:	e8 00 fa ff ff       	call   c0105141 <alloc_pages>
c0105741:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0105744:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105748:	75 1c                	jne    c0105766 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c010574a:	c7 44 24 08 1b cf 10 	movl   $0xc010cf1b,0x8(%esp)
c0105751:	c0 
c0105752:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c0105759:	00 
c010575a:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105761:	e8 52 b6 ff ff       	call   c0100db8 <__panic>
    }
    return page2kva(p);
c0105766:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105769:	89 04 24             	mov    %eax,(%esp)
c010576c:	e8 1c f7 ff ff       	call   c0104e8d <page2kva>
}
c0105771:	c9                   	leave  
c0105772:	c3                   	ret    

c0105773 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0105773:	55                   	push   %ebp
c0105774:	89 e5                	mov    %esp,%ebp
c0105776:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105779:	e8 71 f9 ff ff       	call   c01050ef <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010577e:	e8 86 fa ff ff       	call   c0105209 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0105783:	e8 64 09 00 00       	call   c01060ec <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0105788:	e8 a2 ff ff ff       	call   c010572f <boot_alloc_page>
c010578d:	a3 e4 cd 19 c0       	mov    %eax,0xc019cde4
    memset(boot_pgdir, 0, PGSIZE);
c0105792:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0105797:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010579e:	00 
c010579f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01057a6:	00 
c01057a7:	89 04 24             	mov    %eax,(%esp)
c01057aa:	e8 d8 66 00 00       	call   c010be87 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c01057af:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c01057b4:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01057b7:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c01057be:	77 23                	ja     c01057e3 <pmm_init+0x70>
c01057c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01057c7:	c7 44 24 08 b0 ce 10 	movl   $0xc010ceb0,0x8(%esp)
c01057ce:	c0 
c01057cf:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c01057d6:	00 
c01057d7:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01057de:	e8 d5 b5 ff ff       	call   c0100db8 <__panic>
c01057e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057e6:	05 00 00 00 40       	add    $0x40000000,%eax
c01057eb:	a3 c8 ee 19 c0       	mov    %eax,0xc019eec8

    check_pgdir();
c01057f0:	e8 15 09 00 00       	call   c010610a <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c01057f5:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c01057fa:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0105800:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0105805:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105808:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010580f:	77 23                	ja     c0105834 <pmm_init+0xc1>
c0105811:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105814:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105818:	c7 44 24 08 b0 ce 10 	movl   $0xc010ceb0,0x8(%esp)
c010581f:	c0 
c0105820:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c0105827:	00 
c0105828:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010582f:	e8 84 b5 ff ff       	call   c0100db8 <__panic>
c0105834:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105837:	05 00 00 00 40       	add    $0x40000000,%eax
c010583c:	83 c8 03             	or     $0x3,%eax
c010583f:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0105841:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0105846:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c010584d:	00 
c010584e:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105855:	00 
c0105856:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c010585d:	38 
c010585e:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0105865:	c0 
c0105866:	89 04 24             	mov    %eax,(%esp)
c0105869:	e8 b8 fd ff ff       	call   c0105626 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c010586e:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0105873:	8b 15 e4 cd 19 c0    	mov    0xc019cde4,%edx
c0105879:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010587f:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0105881:	e8 62 fd ff ff       	call   c01055e8 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105886:	e8 75 f7 ff ff       	call   c0105000 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c010588b:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0105890:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105896:	e8 0a 0f 00 00       	call   c01067a5 <check_boot_pgdir>

    print_pgdir();
c010589b:	e8 7e 13 00 00       	call   c0106c1e <print_pgdir>
    
    kmalloc_init();
c01058a0:	e8 d5 f2 ff ff       	call   c0104b7a <kmalloc_init>

}
c01058a5:	c9                   	leave  
c01058a6:	c3                   	ret    

c01058a7 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c01058a7:	55                   	push   %ebp
c01058a8:	89 e5                	mov    %esp,%ebp
c01058aa:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c01058ad:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b0:	c1 e8 16             	shr    $0x16,%eax
c01058b3:	c1 e0 02             	shl    $0x2,%eax
c01058b6:	03 45 08             	add    0x8(%ebp),%eax
c01058b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!(*pdep & PTE_P)) {
c01058bc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058bf:	8b 00                	mov    (%eax),%eax
c01058c1:	83 e0 01             	and    $0x1,%eax
c01058c4:	85 c0                	test   %eax,%eax
c01058c6:	0f 85 c4 00 00 00    	jne    c0105990 <get_pte+0xe9>
        if (!create) return NULL;
c01058cc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01058d0:	75 0a                	jne    c01058dc <get_pte+0x35>
c01058d2:	b8 00 00 00 00       	mov    $0x0,%eax
c01058d7:	e9 10 01 00 00       	jmp    c01059ec <get_pte+0x145>
        struct Page* page;
        if (create && (page = alloc_pages(1)) == NULL) return NULL;
c01058dc:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01058e0:	74 1f                	je     c0105901 <get_pte+0x5a>
c01058e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01058e9:	e8 53 f8 ff ff       	call   c0105141 <alloc_pages>
c01058ee:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01058f1:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01058f5:	75 0a                	jne    c0105901 <get_pte+0x5a>
c01058f7:	b8 00 00 00 00       	mov    $0x0,%eax
c01058fc:	e9 eb 00 00 00       	jmp    c01059ec <get_pte+0x145>
        set_page_ref(page, 1);
c0105901:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105908:	00 
c0105909:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010590c:	89 04 24             	mov    %eax,(%esp)
c010590f:	e8 2d f6 ff ff       	call   c0104f41 <set_page_ref>
        uintptr_t phia = page2pa(page);
c0105914:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105917:	89 04 24             	mov    %eax,(%esp)
c010591a:	e8 13 f5 ff ff       	call   c0104e32 <page2pa>
c010591f:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(phia), 0, PGSIZE);
c0105922:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105925:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105928:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010592b:	c1 e8 0c             	shr    $0xc,%eax
c010592e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105931:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c0105936:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0105939:	72 23                	jb     c010595e <get_pte+0xb7>
c010593b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010593e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105942:	c7 44 24 08 0c ce 10 	movl   $0xc010ce0c,0x8(%esp)
c0105949:	c0 
c010594a:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c0105951:	00 
c0105952:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105959:	e8 5a b4 ff ff       	call   c0100db8 <__panic>
c010595e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105961:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105966:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010596d:	00 
c010596e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105975:	00 
c0105976:	89 04 24             	mov    %eax,(%esp)
c0105979:	e8 09 65 00 00       	call   c010be87 <memset>
        *pdep = PDE_ADDR(phia) | PTE_U | PTE_W | PTE_P;
c010597e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105981:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105986:	89 c2                	mov    %eax,%edx
c0105988:	83 ca 07             	or     $0x7,%edx
c010598b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010598e:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0105990:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105993:	8b 00                	mov    (%eax),%eax
c0105995:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010599a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010599d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059a0:	c1 e8 0c             	shr    $0xc,%eax
c01059a3:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01059a6:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c01059ab:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c01059ae:	72 23                	jb     c01059d3 <get_pte+0x12c>
c01059b0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059b7:	c7 44 24 08 0c ce 10 	movl   $0xc010ce0c,0x8(%esp)
c01059be:	c0 
c01059bf:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
c01059c6:	00 
c01059c7:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01059ce:	e8 e5 b3 ff ff       	call   c0100db8 <__panic>
c01059d3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01059d6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01059db:	8b 55 0c             	mov    0xc(%ebp),%edx
c01059de:	c1 ea 0c             	shr    $0xc,%edx
c01059e1:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c01059e7:	c1 e2 02             	shl    $0x2,%edx
c01059ea:	01 d0                	add    %edx,%eax
}
c01059ec:	c9                   	leave  
c01059ed:	c3                   	ret    

c01059ee <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c01059ee:	55                   	push   %ebp
c01059ef:	89 e5                	mov    %esp,%ebp
c01059f1:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c01059f4:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01059fb:	00 
c01059fc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105a03:	8b 45 08             	mov    0x8(%ebp),%eax
c0105a06:	89 04 24             	mov    %eax,(%esp)
c0105a09:	e8 99 fe ff ff       	call   c01058a7 <get_pte>
c0105a0e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0105a11:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105a15:	74 08                	je     c0105a1f <get_page+0x31>
        *ptep_store = ptep;
c0105a17:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a1a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a1d:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105a1f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105a23:	74 1b                	je     c0105a40 <get_page+0x52>
c0105a25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a28:	8b 00                	mov    (%eax),%eax
c0105a2a:	83 e0 01             	and    $0x1,%eax
c0105a2d:	84 c0                	test   %al,%al
c0105a2f:	74 0f                	je     c0105a40 <get_page+0x52>
        return pte2page(*ptep);
c0105a31:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a34:	8b 00                	mov    (%eax),%eax
c0105a36:	89 04 24             	mov    %eax,(%esp)
c0105a39:	e8 a3 f4 ff ff       	call   c0104ee1 <pte2page>
c0105a3e:	eb 05                	jmp    c0105a45 <get_page+0x57>
    }
    return NULL;
c0105a40:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105a45:	c9                   	leave  
c0105a46:	c3                   	ret    

c0105a47 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c0105a47:	55                   	push   %ebp
c0105a48:	89 e5                	mov    %esp,%ebp
c0105a4a:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if (*ptep & PTE_P) {
c0105a4d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a50:	8b 00                	mov    (%eax),%eax
c0105a52:	83 e0 01             	and    $0x1,%eax
c0105a55:	84 c0                	test   %al,%al
c0105a57:	74 52                	je     c0105aab <page_remove_pte+0x64>
        struct Page *page = pte2page(*ptep);
c0105a59:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a5c:	8b 00                	mov    (%eax),%eax
c0105a5e:	89 04 24             	mov    %eax,(%esp)
c0105a61:	e8 7b f4 ff ff       	call   c0104ee1 <pte2page>
c0105a66:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
c0105a69:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a6c:	89 04 24             	mov    %eax,(%esp)
c0105a6f:	e8 f1 f4 ff ff       	call   c0104f65 <page_ref_dec>
        if(page->ref == 0) {
c0105a74:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a77:	8b 00                	mov    (%eax),%eax
c0105a79:	85 c0                	test   %eax,%eax
c0105a7b:	75 13                	jne    c0105a90 <page_remove_pte+0x49>
            free_page(page);
c0105a7d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105a84:	00 
c0105a85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a88:	89 04 24             	mov    %eax,(%esp)
c0105a8b:	e8 1c f7 ff ff       	call   c01051ac <free_pages>
        }
        *ptep = 0;
c0105a90:	8b 45 10             	mov    0x10(%ebp),%eax
c0105a93:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir, la);
c0105a99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105a9c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105aa0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105aa3:	89 04 24             	mov    %eax,(%esp)
c0105aa6:	e8 0b 05 00 00       	call   c0105fb6 <tlb_invalidate>
    }
}
c0105aab:	c9                   	leave  
c0105aac:	c3                   	ret    

c0105aad <unmap_range>:

void
unmap_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c0105aad:	55                   	push   %ebp
c0105aae:	89 e5                	mov    %esp,%ebp
c0105ab0:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105ab3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105ab6:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105abb:	85 c0                	test   %eax,%eax
c0105abd:	75 0c                	jne    c0105acb <unmap_range+0x1e>
c0105abf:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ac2:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105ac7:	85 c0                	test   %eax,%eax
c0105ac9:	74 24                	je     c0105aef <unmap_range+0x42>
c0105acb:	c7 44 24 0c 34 cf 10 	movl   $0xc010cf34,0xc(%esp)
c0105ad2:	c0 
c0105ad3:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0105ada:	c0 
c0105adb:	c7 44 24 04 d4 01 00 	movl   $0x1d4,0x4(%esp)
c0105ae2:	00 
c0105ae3:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105aea:	e8 c9 b2 ff ff       	call   c0100db8 <__panic>
    assert(USER_ACCESS(start, end));
c0105aef:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0105af6:	76 11                	jbe    c0105b09 <unmap_range+0x5c>
c0105af8:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105afb:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105afe:	73 09                	jae    c0105b09 <unmap_range+0x5c>
c0105b00:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c0105b07:	76 24                	jbe    c0105b2d <unmap_range+0x80>
c0105b09:	c7 44 24 0c 5d cf 10 	movl   $0xc010cf5d,0xc(%esp)
c0105b10:	c0 
c0105b11:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0105b18:	c0 
c0105b19:	c7 44 24 04 d5 01 00 	movl   $0x1d5,0x4(%esp)
c0105b20:	00 
c0105b21:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105b28:	e8 8b b2 ff ff       	call   c0100db8 <__panic>

    do {
        pte_t *ptep = get_pte(pgdir, start, 0);
c0105b2d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b34:	00 
c0105b35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b38:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b3f:	89 04 24             	mov    %eax,(%esp)
c0105b42:	e8 60 fd ff ff       	call   c01058a7 <get_pte>
c0105b47:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105b4a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105b4e:	75 18                	jne    c0105b68 <unmap_range+0xbb>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105b50:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b53:	05 00 00 40 00       	add    $0x400000,%eax
c0105b58:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105b5b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105b5e:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105b63:	89 45 0c             	mov    %eax,0xc(%ebp)
            continue ;
c0105b66:	eb 29                	jmp    c0105b91 <unmap_range+0xe4>
        }
        if (*ptep != 0) {
c0105b68:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b6b:	8b 00                	mov    (%eax),%eax
c0105b6d:	85 c0                	test   %eax,%eax
c0105b6f:	74 19                	je     c0105b8a <unmap_range+0xdd>
            page_remove_pte(pgdir, start, ptep);
c0105b71:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105b74:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105b78:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b7b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105b7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105b82:	89 04 24             	mov    %eax,(%esp)
c0105b85:	e8 bd fe ff ff       	call   c0105a47 <page_remove_pte>
        }
        start += PGSIZE;
c0105b8a:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105b91:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105b95:	74 08                	je     c0105b9f <unmap_range+0xf2>
c0105b97:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105b9a:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105b9d:	72 8e                	jb     c0105b2d <unmap_range+0x80>
}
c0105b9f:	c9                   	leave  
c0105ba0:	c3                   	ret    

c0105ba1 <exit_range>:

void
exit_range(pde_t *pgdir, uintptr_t start, uintptr_t end) {
c0105ba1:	55                   	push   %ebp
c0105ba2:	89 e5                	mov    %esp,%ebp
c0105ba4:	83 ec 28             	sub    $0x28,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105ba7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105baa:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105baf:	85 c0                	test   %eax,%eax
c0105bb1:	75 0c                	jne    c0105bbf <exit_range+0x1e>
c0105bb3:	8b 45 10             	mov    0x10(%ebp),%eax
c0105bb6:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105bbb:	85 c0                	test   %eax,%eax
c0105bbd:	74 24                	je     c0105be3 <exit_range+0x42>
c0105bbf:	c7 44 24 0c 34 cf 10 	movl   $0xc010cf34,0xc(%esp)
c0105bc6:	c0 
c0105bc7:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0105bce:	c0 
c0105bcf:	c7 44 24 04 e6 01 00 	movl   $0x1e6,0x4(%esp)
c0105bd6:	00 
c0105bd7:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105bde:	e8 d5 b1 ff ff       	call   c0100db8 <__panic>
    assert(USER_ACCESS(start, end));
c0105be3:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c0105bea:	76 11                	jbe    c0105bfd <exit_range+0x5c>
c0105bec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105bef:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105bf2:	73 09                	jae    c0105bfd <exit_range+0x5c>
c0105bf4:	81 7d 10 00 00 00 b0 	cmpl   $0xb0000000,0x10(%ebp)
c0105bfb:	76 24                	jbe    c0105c21 <exit_range+0x80>
c0105bfd:	c7 44 24 0c 5d cf 10 	movl   $0xc010cf5d,0xc(%esp)
c0105c04:	c0 
c0105c05:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0105c0c:	c0 
c0105c0d:	c7 44 24 04 e7 01 00 	movl   $0x1e7,0x4(%esp)
c0105c14:	00 
c0105c15:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105c1c:	e8 97 b1 ff ff       	call   c0100db8 <__panic>

    start = ROUNDDOWN(start, PTSIZE);
c0105c21:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c24:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105c27:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c2a:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105c2f:	89 45 0c             	mov    %eax,0xc(%ebp)
    do {
        int pde_idx = PDX(start);
c0105c32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c35:	c1 e8 16             	shr    $0x16,%eax
c0105c38:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (pgdir[pde_idx] & PTE_P) {
c0105c3b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c3e:	c1 e0 02             	shl    $0x2,%eax
c0105c41:	03 45 08             	add    0x8(%ebp),%eax
c0105c44:	8b 00                	mov    (%eax),%eax
c0105c46:	83 e0 01             	and    $0x1,%eax
c0105c49:	84 c0                	test   %al,%al
c0105c4b:	74 32                	je     c0105c7f <exit_range+0xde>
            free_page(pde2page(pgdir[pde_idx]));
c0105c4d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c50:	c1 e0 02             	shl    $0x2,%eax
c0105c53:	03 45 08             	add    0x8(%ebp),%eax
c0105c56:	8b 00                	mov    (%eax),%eax
c0105c58:	89 04 24             	mov    %eax,(%esp)
c0105c5b:	e8 bf f2 ff ff       	call   c0104f1f <pde2page>
c0105c60:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105c67:	00 
c0105c68:	89 04 24             	mov    %eax,(%esp)
c0105c6b:	e8 3c f5 ff ff       	call   c01051ac <free_pages>
            pgdir[pde_idx] = 0;
c0105c70:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105c73:	c1 e0 02             	shl    $0x2,%eax
c0105c76:	03 45 08             	add    0x8(%ebp),%eax
c0105c79:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        }
        start += PTSIZE;
c0105c7f:	81 45 0c 00 00 40 00 	addl   $0x400000,0xc(%ebp)
    } while (start != 0 && start < end);
c0105c86:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0105c8a:	74 08                	je     c0105c94 <exit_range+0xf3>
c0105c8c:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105c8f:	3b 45 10             	cmp    0x10(%ebp),%eax
c0105c92:	72 9e                	jb     c0105c32 <exit_range+0x91>
}
c0105c94:	c9                   	leave  
c0105c95:	c3                   	ret    

c0105c96 <copy_range>:
 * @share: flags to indicate to dup OR share. We just use dup method, so it didn't be used.
 *
 * CALL GRAPH: copy_mm-->dup_mmap-->copy_range
 */
int
copy_range(pde_t *to, pde_t *from, uintptr_t start, uintptr_t end, bool share) {
c0105c96:	55                   	push   %ebp
c0105c97:	89 e5                	mov    %esp,%ebp
c0105c99:	83 ec 48             	sub    $0x48,%esp
    assert(start % PGSIZE == 0 && end % PGSIZE == 0);
c0105c9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105c9f:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105ca4:	85 c0                	test   %eax,%eax
c0105ca6:	75 0c                	jne    c0105cb4 <copy_range+0x1e>
c0105ca8:	8b 45 14             	mov    0x14(%ebp),%eax
c0105cab:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105cb0:	85 c0                	test   %eax,%eax
c0105cb2:	74 24                	je     c0105cd8 <copy_range+0x42>
c0105cb4:	c7 44 24 0c 34 cf 10 	movl   $0xc010cf34,0xc(%esp)
c0105cbb:	c0 
c0105cbc:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0105cc3:	c0 
c0105cc4:	c7 44 24 04 fc 01 00 	movl   $0x1fc,0x4(%esp)
c0105ccb:	00 
c0105ccc:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105cd3:	e8 e0 b0 ff ff       	call   c0100db8 <__panic>
    assert(USER_ACCESS(start, end));
c0105cd8:	81 7d 10 ff ff 1f 00 	cmpl   $0x1fffff,0x10(%ebp)
c0105cdf:	76 11                	jbe    c0105cf2 <copy_range+0x5c>
c0105ce1:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ce4:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105ce7:	73 09                	jae    c0105cf2 <copy_range+0x5c>
c0105ce9:	81 7d 14 00 00 00 b0 	cmpl   $0xb0000000,0x14(%ebp)
c0105cf0:	76 24                	jbe    c0105d16 <copy_range+0x80>
c0105cf2:	c7 44 24 0c 5d cf 10 	movl   $0xc010cf5d,0xc(%esp)
c0105cf9:	c0 
c0105cfa:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0105d01:	c0 
c0105d02:	c7 44 24 04 fd 01 00 	movl   $0x1fd,0x4(%esp)
c0105d09:	00 
c0105d0a:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105d11:	e8 a2 b0 ff ff       	call   c0100db8 <__panic>
    // copy content by page unit.
    do {
        //call get_pte to find process A's pte according to the addr start
        pte_t *ptep = get_pte(from, start, 0), *nptep;
c0105d16:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105d1d:	00 
c0105d1e:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d25:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105d28:	89 04 24             	mov    %eax,(%esp)
c0105d2b:	e8 77 fb ff ff       	call   c01058a7 <get_pte>
c0105d30:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (ptep == NULL) {
c0105d33:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105d37:	75 1b                	jne    c0105d54 <copy_range+0xbe>
            start = ROUNDDOWN(start + PTSIZE, PTSIZE);
c0105d39:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d3c:	05 00 00 40 00       	add    $0x400000,%eax
c0105d41:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d47:	25 00 00 c0 ff       	and    $0xffc00000,%eax
c0105d4c:	89 45 10             	mov    %eax,0x10(%ebp)
            continue ;
c0105d4f:	e9 4c 01 00 00       	jmp    c0105ea0 <copy_range+0x20a>
        }
        //call get_pte to find process B's pte according to the addr start. If pte is NULL, just alloc a PT
        if (*ptep & PTE_P) {
c0105d54:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d57:	8b 00                	mov    (%eax),%eax
c0105d59:	83 e0 01             	and    $0x1,%eax
c0105d5c:	84 c0                	test   %al,%al
c0105d5e:	0f 84 35 01 00 00    	je     c0105e99 <copy_range+0x203>
            if ((nptep = get_pte(to, start, 1)) == NULL) {
c0105d64:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105d6b:	00 
c0105d6c:	8b 45 10             	mov    0x10(%ebp),%eax
c0105d6f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105d73:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d76:	89 04 24             	mov    %eax,(%esp)
c0105d79:	e8 29 fb ff ff       	call   c01058a7 <get_pte>
c0105d7e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105d81:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0105d85:	75 0a                	jne    c0105d91 <copy_range+0xfb>
                return -E_NO_MEM;
c0105d87:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105d8c:	e9 26 01 00 00       	jmp    c0105eb7 <copy_range+0x221>
            }
        uint32_t perm = (*ptep & PTE_USER);
c0105d91:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d94:	8b 00                	mov    (%eax),%eax
c0105d96:	83 e0 07             	and    $0x7,%eax
c0105d99:	89 45 e8             	mov    %eax,-0x18(%ebp)
        //get page from ptep
        struct Page *page = pte2page(*ptep);
c0105d9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105d9f:	8b 00                	mov    (%eax),%eax
c0105da1:	89 04 24             	mov    %eax,(%esp)
c0105da4:	e8 38 f1 ff ff       	call   c0104ee1 <pte2page>
c0105da9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        // alloc a page for process B
        struct Page *npage=alloc_page();
c0105dac:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105db3:	e8 89 f3 ff ff       	call   c0105141 <alloc_pages>
c0105db8:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(page!=NULL);
c0105dbb:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105dbf:	75 24                	jne    c0105de5 <copy_range+0x14f>
c0105dc1:	c7 44 24 0c 75 cf 10 	movl   $0xc010cf75,0xc(%esp)
c0105dc8:	c0 
c0105dc9:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0105dd0:	c0 
c0105dd1:	c7 44 24 04 10 02 00 	movl   $0x210,0x4(%esp)
c0105dd8:	00 
c0105dd9:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105de0:	e8 d3 af ff ff       	call   c0100db8 <__panic>
        assert(npage!=NULL);
c0105de5:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105de9:	75 24                	jne    c0105e0f <copy_range+0x179>
c0105deb:	c7 44 24 0c 80 cf 10 	movl   $0xc010cf80,0xc(%esp)
c0105df2:	c0 
c0105df3:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0105dfa:	c0 
c0105dfb:	c7 44 24 04 11 02 00 	movl   $0x211,0x4(%esp)
c0105e02:	00 
c0105e03:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105e0a:	e8 a9 af ff ff       	call   c0100db8 <__panic>
        int ret=0;
c0105e0f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
         * (1) find src_kvaddr: the kernel virtual address of page
         * (2) find dst_kvaddr: the kernel virtual address of npage
         * (3) memory copy from src_kvaddr to dst_kvaddr, size is PGSIZE
         * (4) build the map of phy addr of  nage with the linear addr start
         */
            void * src_kvaddr = page2kva(page);
c0105e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e19:	89 04 24             	mov    %eax,(%esp)
c0105e1c:	e8 6c f0 ff ff       	call   c0104e8d <page2kva>
c0105e21:	89 45 d8             	mov    %eax,-0x28(%ebp)
            void * dst_kvaddr = page2kva(npage);
c0105e24:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e27:	89 04 24             	mov    %eax,(%esp)
c0105e2a:	e8 5e f0 ff ff       	call   c0104e8d <page2kva>
c0105e2f:	89 45 d4             	mov    %eax,-0x2c(%ebp)
            memcpy(dst_kvaddr, src_kvaddr, PGSIZE);
c0105e32:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105e39:	00 
c0105e3a:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0105e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e41:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105e44:	89 04 24             	mov    %eax,(%esp)
c0105e47:	e8 3a 61 00 00       	call   c010bf86 <memcpy>
            ret = page_insert(to, npage, start, perm);
c0105e4c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105e4f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105e53:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e56:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105e5a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105e5d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105e61:	8b 45 08             	mov    0x8(%ebp),%eax
c0105e64:	89 04 24             	mov    %eax,(%esp)
c0105e67:	e8 91 00 00 00       	call   c0105efd <page_insert>
c0105e6c:	89 45 dc             	mov    %eax,-0x24(%ebp)
            assert(ret == 0);
c0105e6f:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0105e73:	74 24                	je     c0105e99 <copy_range+0x203>
c0105e75:	c7 44 24 0c 8c cf 10 	movl   $0xc010cf8c,0xc(%esp)
c0105e7c:	c0 
c0105e7d:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0105e84:	c0 
c0105e85:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105e8c:	00 
c0105e8d:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105e94:	e8 1f af ff ff       	call   c0100db8 <__panic>
        }
        start += PGSIZE;
c0105e99:	81 45 10 00 10 00 00 	addl   $0x1000,0x10(%ebp)
    } while (start != 0 && start < end);
c0105ea0:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105ea4:	74 0c                	je     c0105eb2 <copy_range+0x21c>
c0105ea6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105ea9:	3b 45 14             	cmp    0x14(%ebp),%eax
c0105eac:	0f 82 64 fe ff ff    	jb     c0105d16 <copy_range+0x80>
    return 0;
c0105eb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105eb7:	c9                   	leave  
c0105eb8:	c3                   	ret    

c0105eb9 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105eb9:	55                   	push   %ebp
c0105eba:	89 e5                	mov    %esp,%ebp
c0105ebc:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105ebf:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105ec6:	00 
c0105ec7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eca:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ece:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ed1:	89 04 24             	mov    %eax,(%esp)
c0105ed4:	e8 ce f9 ff ff       	call   c01058a7 <get_pte>
c0105ed9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105edc:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105ee0:	74 19                	je     c0105efb <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105ee2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ee5:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105ee9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105eec:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ef0:	8b 45 08             	mov    0x8(%ebp),%eax
c0105ef3:	89 04 24             	mov    %eax,(%esp)
c0105ef6:	e8 4c fb ff ff       	call   c0105a47 <page_remove_pte>
    }
}
c0105efb:	c9                   	leave  
c0105efc:	c3                   	ret    

c0105efd <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105efd:	55                   	push   %ebp
c0105efe:	89 e5                	mov    %esp,%ebp
c0105f00:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105f03:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0105f0a:	00 
c0105f0b:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f12:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f15:	89 04 24             	mov    %eax,(%esp)
c0105f18:	e8 8a f9 ff ff       	call   c01058a7 <get_pte>
c0105f1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105f20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105f24:	75 0a                	jne    c0105f30 <page_insert+0x33>
        return -E_NO_MEM;
c0105f26:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105f2b:	e9 84 00 00 00       	jmp    c0105fb4 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105f30:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f33:	89 04 24             	mov    %eax,(%esp)
c0105f36:	e8 13 f0 ff ff       	call   c0104f4e <page_ref_inc>
    if (*ptep & PTE_P) {
c0105f3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f3e:	8b 00                	mov    (%eax),%eax
c0105f40:	83 e0 01             	and    $0x1,%eax
c0105f43:	84 c0                	test   %al,%al
c0105f45:	74 3e                	je     c0105f85 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c0105f47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f4a:	8b 00                	mov    (%eax),%eax
c0105f4c:	89 04 24             	mov    %eax,(%esp)
c0105f4f:	e8 8d ef ff ff       	call   c0104ee1 <pte2page>
c0105f54:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c0105f57:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f5a:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105f5d:	75 0d                	jne    c0105f6c <page_insert+0x6f>
            page_ref_dec(page);
c0105f5f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f62:	89 04 24             	mov    %eax,(%esp)
c0105f65:	e8 fb ef ff ff       	call   c0104f65 <page_ref_dec>
c0105f6a:	eb 19                	jmp    c0105f85 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c0105f6c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f6f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f73:	8b 45 10             	mov    0x10(%ebp),%eax
c0105f76:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105f7a:	8b 45 08             	mov    0x8(%ebp),%eax
c0105f7d:	89 04 24             	mov    %eax,(%esp)
c0105f80:	e8 c2 fa ff ff       	call   c0105a47 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105f85:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105f88:	89 04 24             	mov    %eax,(%esp)
c0105f8b:	e8 a2 ee ff ff       	call   c0104e32 <page2pa>
c0105f90:	0b 45 14             	or     0x14(%ebp),%eax
c0105f93:	89 c2                	mov    %eax,%edx
c0105f95:	83 ca 01             	or     $0x1,%edx
c0105f98:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105f9b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c0105f9d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105fa0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105fa4:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fa7:	89 04 24             	mov    %eax,(%esp)
c0105faa:	e8 07 00 00 00       	call   c0105fb6 <tlb_invalidate>
    return 0;
c0105faf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105fb4:	c9                   	leave  
c0105fb5:	c3                   	ret    

c0105fb6 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105fb6:	55                   	push   %ebp
c0105fb7:	89 e5                	mov    %esp,%ebp
c0105fb9:	53                   	push   %ebx
c0105fba:	83 ec 24             	sub    $0x24,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105fbd:	0f 20 db             	mov    %cr3,%ebx
c0105fc0:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr3;
c0105fc3:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105fc6:	89 c2                	mov    %eax,%edx
c0105fc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0105fcb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105fce:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105fd5:	77 23                	ja     c0105ffa <tlb_invalidate+0x44>
c0105fd7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fda:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105fde:	c7 44 24 08 b0 ce 10 	movl   $0xc010ceb0,0x8(%esp)
c0105fe5:	c0 
c0105fe6:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0105fed:	00 
c0105fee:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0105ff5:	e8 be ad ff ff       	call   c0100db8 <__panic>
c0105ffa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105ffd:	05 00 00 00 40       	add    $0x40000000,%eax
c0106002:	39 c2                	cmp    %eax,%edx
c0106004:	75 0c                	jne    c0106012 <tlb_invalidate+0x5c>
        invlpg((void *)la);
c0106006:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106009:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010600c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010600f:	0f 01 38             	invlpg (%eax)
    }
}
c0106012:	83 c4 24             	add    $0x24,%esp
c0106015:	5b                   	pop    %ebx
c0106016:	5d                   	pop    %ebp
c0106017:	c3                   	ret    

c0106018 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0106018:	55                   	push   %ebp
c0106019:	89 e5                	mov    %esp,%ebp
c010601b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c010601e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106025:	e8 17 f1 ff ff       	call   c0105141 <alloc_pages>
c010602a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c010602d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106031:	0f 84 b0 00 00 00    	je     c01060e7 <pgdir_alloc_page+0xcf>
        if (page_insert(pgdir, page, la, perm) != 0) {
c0106037:	8b 45 10             	mov    0x10(%ebp),%eax
c010603a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010603e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106041:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106045:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106048:	89 44 24 04          	mov    %eax,0x4(%esp)
c010604c:	8b 45 08             	mov    0x8(%ebp),%eax
c010604f:	89 04 24             	mov    %eax,(%esp)
c0106052:	e8 a6 fe ff ff       	call   c0105efd <page_insert>
c0106057:	85 c0                	test   %eax,%eax
c0106059:	74 1a                	je     c0106075 <pgdir_alloc_page+0x5d>
            free_page(page);
c010605b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106062:	00 
c0106063:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106066:	89 04 24             	mov    %eax,(%esp)
c0106069:	e8 3e f1 ff ff       	call   c01051ac <free_pages>
            return NULL;
c010606e:	b8 00 00 00 00       	mov    $0x0,%eax
c0106073:	eb 75                	jmp    c01060ea <pgdir_alloc_page+0xd2>
        }
        if (swap_init_ok){
c0106075:	a1 6c ce 19 c0       	mov    0xc019ce6c,%eax
c010607a:	85 c0                	test   %eax,%eax
c010607c:	74 69                	je     c01060e7 <pgdir_alloc_page+0xcf>
            if(check_mm_struct!=NULL) {
c010607e:	a1 ac ef 19 c0       	mov    0xc019efac,%eax
c0106083:	85 c0                	test   %eax,%eax
c0106085:	74 60                	je     c01060e7 <pgdir_alloc_page+0xcf>
                swap_map_swappable(check_mm_struct, la, page, 0);
c0106087:	a1 ac ef 19 c0       	mov    0xc019efac,%eax
c010608c:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106093:	00 
c0106094:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106097:	89 54 24 08          	mov    %edx,0x8(%esp)
c010609b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010609e:	89 54 24 04          	mov    %edx,0x4(%esp)
c01060a2:	89 04 24             	mov    %eax,(%esp)
c01060a5:	e8 51 0e 00 00       	call   c0106efb <swap_map_swappable>
                page->pra_vaddr=la;
c01060aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060ad:	8b 55 0c             	mov    0xc(%ebp),%edx
c01060b0:	89 50 1c             	mov    %edx,0x1c(%eax)
                assert(page_ref(page) == 1);
c01060b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01060b6:	89 04 24             	mov    %eax,(%esp)
c01060b9:	e8 79 ee ff ff       	call   c0104f37 <page_ref>
c01060be:	83 f8 01             	cmp    $0x1,%eax
c01060c1:	74 24                	je     c01060e7 <pgdir_alloc_page+0xcf>
c01060c3:	c7 44 24 0c 95 cf 10 	movl   $0xc010cf95,0xc(%esp)
c01060ca:	c0 
c01060cb:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01060d2:	c0 
c01060d3:	c7 44 24 04 6a 02 00 	movl   $0x26a,0x4(%esp)
c01060da:	00 
c01060db:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01060e2:	e8 d1 ac ff ff       	call   c0100db8 <__panic>
            }
        }

    }

    return page;
c01060e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01060ea:	c9                   	leave  
c01060eb:	c3                   	ret    

c01060ec <check_alloc_page>:

static void
check_alloc_page(void) {
c01060ec:	55                   	push   %ebp
c01060ed:	89 e5                	mov    %esp,%ebp
c01060ef:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c01060f2:	a1 c4 ee 19 c0       	mov    0xc019eec4,%eax
c01060f7:	8b 40 18             	mov    0x18(%eax),%eax
c01060fa:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c01060fc:	c7 04 24 ac cf 10 c0 	movl   $0xc010cfac,(%esp)
c0106103:	e8 57 a2 ff ff       	call   c010035f <cprintf>
}
c0106108:	c9                   	leave  
c0106109:	c3                   	ret    

c010610a <check_pgdir>:

static void
check_pgdir(void) {
c010610a:	55                   	push   %ebp
c010610b:	89 e5                	mov    %esp,%ebp
c010610d:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0106110:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c0106115:	3d 00 80 03 00       	cmp    $0x38000,%eax
c010611a:	76 24                	jbe    c0106140 <check_pgdir+0x36>
c010611c:	c7 44 24 0c cb cf 10 	movl   $0xc010cfcb,0xc(%esp)
c0106123:	c0 
c0106124:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c010612b:	c0 
c010612c:	c7 44 24 04 82 02 00 	movl   $0x282,0x4(%esp)
c0106133:	00 
c0106134:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010613b:	e8 78 ac ff ff       	call   c0100db8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0106140:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106145:	85 c0                	test   %eax,%eax
c0106147:	74 0e                	je     c0106157 <check_pgdir+0x4d>
c0106149:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c010614e:	25 ff 0f 00 00       	and    $0xfff,%eax
c0106153:	85 c0                	test   %eax,%eax
c0106155:	74 24                	je     c010617b <check_pgdir+0x71>
c0106157:	c7 44 24 0c e8 cf 10 	movl   $0xc010cfe8,0xc(%esp)
c010615e:	c0 
c010615f:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106166:	c0 
c0106167:	c7 44 24 04 83 02 00 	movl   $0x283,0x4(%esp)
c010616e:	00 
c010616f:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106176:	e8 3d ac ff ff       	call   c0100db8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c010617b:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106180:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106187:	00 
c0106188:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010618f:	00 
c0106190:	89 04 24             	mov    %eax,(%esp)
c0106193:	e8 56 f8 ff ff       	call   c01059ee <get_page>
c0106198:	85 c0                	test   %eax,%eax
c010619a:	74 24                	je     c01061c0 <check_pgdir+0xb6>
c010619c:	c7 44 24 0c 20 d0 10 	movl   $0xc010d020,0xc(%esp)
c01061a3:	c0 
c01061a4:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01061ab:	c0 
c01061ac:	c7 44 24 04 84 02 00 	movl   $0x284,0x4(%esp)
c01061b3:	00 
c01061b4:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01061bb:	e8 f8 ab ff ff       	call   c0100db8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c01061c0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01061c7:	e8 75 ef ff ff       	call   c0105141 <alloc_pages>
c01061cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c01061cf:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c01061d4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01061db:	00 
c01061dc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01061e3:	00 
c01061e4:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01061e7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01061eb:	89 04 24             	mov    %eax,(%esp)
c01061ee:	e8 0a fd ff ff       	call   c0105efd <page_insert>
c01061f3:	85 c0                	test   %eax,%eax
c01061f5:	74 24                	je     c010621b <check_pgdir+0x111>
c01061f7:	c7 44 24 0c 48 d0 10 	movl   $0xc010d048,0xc(%esp)
c01061fe:	c0 
c01061ff:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106206:	c0 
c0106207:	c7 44 24 04 88 02 00 	movl   $0x288,0x4(%esp)
c010620e:	00 
c010620f:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106216:	e8 9d ab ff ff       	call   c0100db8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c010621b:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106220:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106227:	00 
c0106228:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010622f:	00 
c0106230:	89 04 24             	mov    %eax,(%esp)
c0106233:	e8 6f f6 ff ff       	call   c01058a7 <get_pte>
c0106238:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010623b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010623f:	75 24                	jne    c0106265 <check_pgdir+0x15b>
c0106241:	c7 44 24 0c 74 d0 10 	movl   $0xc010d074,0xc(%esp)
c0106248:	c0 
c0106249:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106250:	c0 
c0106251:	c7 44 24 04 8b 02 00 	movl   $0x28b,0x4(%esp)
c0106258:	00 
c0106259:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106260:	e8 53 ab ff ff       	call   c0100db8 <__panic>
    assert(pte2page(*ptep) == p1);
c0106265:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106268:	8b 00                	mov    (%eax),%eax
c010626a:	89 04 24             	mov    %eax,(%esp)
c010626d:	e8 6f ec ff ff       	call   c0104ee1 <pte2page>
c0106272:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0106275:	74 24                	je     c010629b <check_pgdir+0x191>
c0106277:	c7 44 24 0c a1 d0 10 	movl   $0xc010d0a1,0xc(%esp)
c010627e:	c0 
c010627f:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106286:	c0 
c0106287:	c7 44 24 04 8c 02 00 	movl   $0x28c,0x4(%esp)
c010628e:	00 
c010628f:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106296:	e8 1d ab ff ff       	call   c0100db8 <__panic>
    assert(page_ref(p1) == 1);
c010629b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010629e:	89 04 24             	mov    %eax,(%esp)
c01062a1:	e8 91 ec ff ff       	call   c0104f37 <page_ref>
c01062a6:	83 f8 01             	cmp    $0x1,%eax
c01062a9:	74 24                	je     c01062cf <check_pgdir+0x1c5>
c01062ab:	c7 44 24 0c b7 d0 10 	movl   $0xc010d0b7,0xc(%esp)
c01062b2:	c0 
c01062b3:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01062ba:	c0 
c01062bb:	c7 44 24 04 8d 02 00 	movl   $0x28d,0x4(%esp)
c01062c2:	00 
c01062c3:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01062ca:	e8 e9 aa ff ff       	call   c0100db8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c01062cf:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c01062d4:	8b 00                	mov    (%eax),%eax
c01062d6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01062db:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01062de:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062e1:	c1 e8 0c             	shr    $0xc,%eax
c01062e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01062e7:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c01062ec:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c01062ef:	72 23                	jb     c0106314 <check_pgdir+0x20a>
c01062f1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01062f4:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01062f8:	c7 44 24 08 0c ce 10 	movl   $0xc010ce0c,0x8(%esp)
c01062ff:	c0 
c0106300:	c7 44 24 04 8f 02 00 	movl   $0x28f,0x4(%esp)
c0106307:	00 
c0106308:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010630f:	e8 a4 aa ff ff       	call   c0100db8 <__panic>
c0106314:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106317:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010631c:	83 c0 04             	add    $0x4,%eax
c010631f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0106322:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106327:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010632e:	00 
c010632f:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106336:	00 
c0106337:	89 04 24             	mov    %eax,(%esp)
c010633a:	e8 68 f5 ff ff       	call   c01058a7 <get_pte>
c010633f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106342:	74 24                	je     c0106368 <check_pgdir+0x25e>
c0106344:	c7 44 24 0c cc d0 10 	movl   $0xc010d0cc,0xc(%esp)
c010634b:	c0 
c010634c:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106353:	c0 
c0106354:	c7 44 24 04 90 02 00 	movl   $0x290,0x4(%esp)
c010635b:	00 
c010635c:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106363:	e8 50 aa ff ff       	call   c0100db8 <__panic>

    p2 = alloc_page();
c0106368:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010636f:	e8 cd ed ff ff       	call   c0105141 <alloc_pages>
c0106374:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0106377:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c010637c:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0106383:	00 
c0106384:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010638b:	00 
c010638c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010638f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106393:	89 04 24             	mov    %eax,(%esp)
c0106396:	e8 62 fb ff ff       	call   c0105efd <page_insert>
c010639b:	85 c0                	test   %eax,%eax
c010639d:	74 24                	je     c01063c3 <check_pgdir+0x2b9>
c010639f:	c7 44 24 0c f4 d0 10 	movl   $0xc010d0f4,0xc(%esp)
c01063a6:	c0 
c01063a7:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01063ae:	c0 
c01063af:	c7 44 24 04 93 02 00 	movl   $0x293,0x4(%esp)
c01063b6:	00 
c01063b7:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01063be:	e8 f5 a9 ff ff       	call   c0100db8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01063c3:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c01063c8:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01063cf:	00 
c01063d0:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01063d7:	00 
c01063d8:	89 04 24             	mov    %eax,(%esp)
c01063db:	e8 c7 f4 ff ff       	call   c01058a7 <get_pte>
c01063e0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01063e3:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01063e7:	75 24                	jne    c010640d <check_pgdir+0x303>
c01063e9:	c7 44 24 0c 2c d1 10 	movl   $0xc010d12c,0xc(%esp)
c01063f0:	c0 
c01063f1:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01063f8:	c0 
c01063f9:	c7 44 24 04 94 02 00 	movl   $0x294,0x4(%esp)
c0106400:	00 
c0106401:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106408:	e8 ab a9 ff ff       	call   c0100db8 <__panic>
    assert(*ptep & PTE_U);
c010640d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106410:	8b 00                	mov    (%eax),%eax
c0106412:	83 e0 04             	and    $0x4,%eax
c0106415:	85 c0                	test   %eax,%eax
c0106417:	75 24                	jne    c010643d <check_pgdir+0x333>
c0106419:	c7 44 24 0c 5c d1 10 	movl   $0xc010d15c,0xc(%esp)
c0106420:	c0 
c0106421:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106428:	c0 
c0106429:	c7 44 24 04 95 02 00 	movl   $0x295,0x4(%esp)
c0106430:	00 
c0106431:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106438:	e8 7b a9 ff ff       	call   c0100db8 <__panic>
    assert(*ptep & PTE_W);
c010643d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106440:	8b 00                	mov    (%eax),%eax
c0106442:	83 e0 02             	and    $0x2,%eax
c0106445:	85 c0                	test   %eax,%eax
c0106447:	75 24                	jne    c010646d <check_pgdir+0x363>
c0106449:	c7 44 24 0c 6a d1 10 	movl   $0xc010d16a,0xc(%esp)
c0106450:	c0 
c0106451:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106458:	c0 
c0106459:	c7 44 24 04 96 02 00 	movl   $0x296,0x4(%esp)
c0106460:	00 
c0106461:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106468:	e8 4b a9 ff ff       	call   c0100db8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c010646d:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106472:	8b 00                	mov    (%eax),%eax
c0106474:	83 e0 04             	and    $0x4,%eax
c0106477:	85 c0                	test   %eax,%eax
c0106479:	75 24                	jne    c010649f <check_pgdir+0x395>
c010647b:	c7 44 24 0c 78 d1 10 	movl   $0xc010d178,0xc(%esp)
c0106482:	c0 
c0106483:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c010648a:	c0 
c010648b:	c7 44 24 04 97 02 00 	movl   $0x297,0x4(%esp)
c0106492:	00 
c0106493:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010649a:	e8 19 a9 ff ff       	call   c0100db8 <__panic>
    assert(page_ref(p2) == 1);
c010649f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01064a2:	89 04 24             	mov    %eax,(%esp)
c01064a5:	e8 8d ea ff ff       	call   c0104f37 <page_ref>
c01064aa:	83 f8 01             	cmp    $0x1,%eax
c01064ad:	74 24                	je     c01064d3 <check_pgdir+0x3c9>
c01064af:	c7 44 24 0c 8e d1 10 	movl   $0xc010d18e,0xc(%esp)
c01064b6:	c0 
c01064b7:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01064be:	c0 
c01064bf:	c7 44 24 04 98 02 00 	movl   $0x298,0x4(%esp)
c01064c6:	00 
c01064c7:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01064ce:	e8 e5 a8 ff ff       	call   c0100db8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c01064d3:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c01064d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01064df:	00 
c01064e0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01064e7:	00 
c01064e8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01064eb:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064ef:	89 04 24             	mov    %eax,(%esp)
c01064f2:	e8 06 fa ff ff       	call   c0105efd <page_insert>
c01064f7:	85 c0                	test   %eax,%eax
c01064f9:	74 24                	je     c010651f <check_pgdir+0x415>
c01064fb:	c7 44 24 0c a0 d1 10 	movl   $0xc010d1a0,0xc(%esp)
c0106502:	c0 
c0106503:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c010650a:	c0 
c010650b:	c7 44 24 04 9a 02 00 	movl   $0x29a,0x4(%esp)
c0106512:	00 
c0106513:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010651a:	e8 99 a8 ff ff       	call   c0100db8 <__panic>
    assert(page_ref(p1) == 2);
c010651f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106522:	89 04 24             	mov    %eax,(%esp)
c0106525:	e8 0d ea ff ff       	call   c0104f37 <page_ref>
c010652a:	83 f8 02             	cmp    $0x2,%eax
c010652d:	74 24                	je     c0106553 <check_pgdir+0x449>
c010652f:	c7 44 24 0c cc d1 10 	movl   $0xc010d1cc,0xc(%esp)
c0106536:	c0 
c0106537:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c010653e:	c0 
c010653f:	c7 44 24 04 9b 02 00 	movl   $0x29b,0x4(%esp)
c0106546:	00 
c0106547:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010654e:	e8 65 a8 ff ff       	call   c0100db8 <__panic>
    assert(page_ref(p2) == 0);
c0106553:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106556:	89 04 24             	mov    %eax,(%esp)
c0106559:	e8 d9 e9 ff ff       	call   c0104f37 <page_ref>
c010655e:	85 c0                	test   %eax,%eax
c0106560:	74 24                	je     c0106586 <check_pgdir+0x47c>
c0106562:	c7 44 24 0c de d1 10 	movl   $0xc010d1de,0xc(%esp)
c0106569:	c0 
c010656a:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106571:	c0 
c0106572:	c7 44 24 04 9c 02 00 	movl   $0x29c,0x4(%esp)
c0106579:	00 
c010657a:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106581:	e8 32 a8 ff ff       	call   c0100db8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0106586:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c010658b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106592:	00 
c0106593:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010659a:	00 
c010659b:	89 04 24             	mov    %eax,(%esp)
c010659e:	e8 04 f3 ff ff       	call   c01058a7 <get_pte>
c01065a3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01065a6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01065aa:	75 24                	jne    c01065d0 <check_pgdir+0x4c6>
c01065ac:	c7 44 24 0c 2c d1 10 	movl   $0xc010d12c,0xc(%esp)
c01065b3:	c0 
c01065b4:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01065bb:	c0 
c01065bc:	c7 44 24 04 9d 02 00 	movl   $0x29d,0x4(%esp)
c01065c3:	00 
c01065c4:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01065cb:	e8 e8 a7 ff ff       	call   c0100db8 <__panic>
    assert(pte2page(*ptep) == p1);
c01065d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01065d3:	8b 00                	mov    (%eax),%eax
c01065d5:	89 04 24             	mov    %eax,(%esp)
c01065d8:	e8 04 e9 ff ff       	call   c0104ee1 <pte2page>
c01065dd:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01065e0:	74 24                	je     c0106606 <check_pgdir+0x4fc>
c01065e2:	c7 44 24 0c a1 d0 10 	movl   $0xc010d0a1,0xc(%esp)
c01065e9:	c0 
c01065ea:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01065f1:	c0 
c01065f2:	c7 44 24 04 9e 02 00 	movl   $0x29e,0x4(%esp)
c01065f9:	00 
c01065fa:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106601:	e8 b2 a7 ff ff       	call   c0100db8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0106606:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106609:	8b 00                	mov    (%eax),%eax
c010660b:	83 e0 04             	and    $0x4,%eax
c010660e:	85 c0                	test   %eax,%eax
c0106610:	74 24                	je     c0106636 <check_pgdir+0x52c>
c0106612:	c7 44 24 0c f0 d1 10 	movl   $0xc010d1f0,0xc(%esp)
c0106619:	c0 
c010661a:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106621:	c0 
c0106622:	c7 44 24 04 9f 02 00 	movl   $0x29f,0x4(%esp)
c0106629:	00 
c010662a:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106631:	e8 82 a7 ff ff       	call   c0100db8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0106636:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c010663b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0106642:	00 
c0106643:	89 04 24             	mov    %eax,(%esp)
c0106646:	e8 6e f8 ff ff       	call   c0105eb9 <page_remove>
    assert(page_ref(p1) == 1);
c010664b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010664e:	89 04 24             	mov    %eax,(%esp)
c0106651:	e8 e1 e8 ff ff       	call   c0104f37 <page_ref>
c0106656:	83 f8 01             	cmp    $0x1,%eax
c0106659:	74 24                	je     c010667f <check_pgdir+0x575>
c010665b:	c7 44 24 0c b7 d0 10 	movl   $0xc010d0b7,0xc(%esp)
c0106662:	c0 
c0106663:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c010666a:	c0 
c010666b:	c7 44 24 04 a2 02 00 	movl   $0x2a2,0x4(%esp)
c0106672:	00 
c0106673:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010667a:	e8 39 a7 ff ff       	call   c0100db8 <__panic>
    assert(page_ref(p2) == 0);
c010667f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106682:	89 04 24             	mov    %eax,(%esp)
c0106685:	e8 ad e8 ff ff       	call   c0104f37 <page_ref>
c010668a:	85 c0                	test   %eax,%eax
c010668c:	74 24                	je     c01066b2 <check_pgdir+0x5a8>
c010668e:	c7 44 24 0c de d1 10 	movl   $0xc010d1de,0xc(%esp)
c0106695:	c0 
c0106696:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c010669d:	c0 
c010669e:	c7 44 24 04 a3 02 00 	movl   $0x2a3,0x4(%esp)
c01066a5:	00 
c01066a6:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01066ad:	e8 06 a7 ff ff       	call   c0100db8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01066b2:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c01066b7:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01066be:	00 
c01066bf:	89 04 24             	mov    %eax,(%esp)
c01066c2:	e8 f2 f7 ff ff       	call   c0105eb9 <page_remove>
    assert(page_ref(p1) == 0);
c01066c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01066ca:	89 04 24             	mov    %eax,(%esp)
c01066cd:	e8 65 e8 ff ff       	call   c0104f37 <page_ref>
c01066d2:	85 c0                	test   %eax,%eax
c01066d4:	74 24                	je     c01066fa <check_pgdir+0x5f0>
c01066d6:	c7 44 24 0c 05 d2 10 	movl   $0xc010d205,0xc(%esp)
c01066dd:	c0 
c01066de:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01066e5:	c0 
c01066e6:	c7 44 24 04 a6 02 00 	movl   $0x2a6,0x4(%esp)
c01066ed:	00 
c01066ee:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01066f5:	e8 be a6 ff ff       	call   c0100db8 <__panic>
    assert(page_ref(p2) == 0);
c01066fa:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01066fd:	89 04 24             	mov    %eax,(%esp)
c0106700:	e8 32 e8 ff ff       	call   c0104f37 <page_ref>
c0106705:	85 c0                	test   %eax,%eax
c0106707:	74 24                	je     c010672d <check_pgdir+0x623>
c0106709:	c7 44 24 0c de d1 10 	movl   $0xc010d1de,0xc(%esp)
c0106710:	c0 
c0106711:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106718:	c0 
c0106719:	c7 44 24 04 a7 02 00 	movl   $0x2a7,0x4(%esp)
c0106720:	00 
c0106721:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106728:	e8 8b a6 ff ff       	call   c0100db8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c010672d:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106732:	8b 00                	mov    (%eax),%eax
c0106734:	89 04 24             	mov    %eax,(%esp)
c0106737:	e8 e3 e7 ff ff       	call   c0104f1f <pde2page>
c010673c:	89 04 24             	mov    %eax,(%esp)
c010673f:	e8 f3 e7 ff ff       	call   c0104f37 <page_ref>
c0106744:	83 f8 01             	cmp    $0x1,%eax
c0106747:	74 24                	je     c010676d <check_pgdir+0x663>
c0106749:	c7 44 24 0c 18 d2 10 	movl   $0xc010d218,0xc(%esp)
c0106750:	c0 
c0106751:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106758:	c0 
c0106759:	c7 44 24 04 a9 02 00 	movl   $0x2a9,0x4(%esp)
c0106760:	00 
c0106761:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106768:	e8 4b a6 ff ff       	call   c0100db8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c010676d:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106772:	8b 00                	mov    (%eax),%eax
c0106774:	89 04 24             	mov    %eax,(%esp)
c0106777:	e8 a3 e7 ff ff       	call   c0104f1f <pde2page>
c010677c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106783:	00 
c0106784:	89 04 24             	mov    %eax,(%esp)
c0106787:	e8 20 ea ff ff       	call   c01051ac <free_pages>
    boot_pgdir[0] = 0;
c010678c:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106791:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c0106797:	c7 04 24 3f d2 10 c0 	movl   $0xc010d23f,(%esp)
c010679e:	e8 bc 9b ff ff       	call   c010035f <cprintf>
}
c01067a3:	c9                   	leave  
c01067a4:	c3                   	ret    

c01067a5 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01067a5:	55                   	push   %ebp
c01067a6:	89 e5                	mov    %esp,%ebp
c01067a8:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01067ab:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01067b2:	e9 cb 00 00 00       	jmp    c0106882 <check_boot_pgdir+0xdd>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c01067b7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067ba:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01067bd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067c0:	c1 e8 0c             	shr    $0xc,%eax
c01067c3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01067c6:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c01067cb:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c01067ce:	72 23                	jb     c01067f3 <check_boot_pgdir+0x4e>
c01067d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01067d7:	c7 44 24 08 0c ce 10 	movl   $0xc010ce0c,0x8(%esp)
c01067de:	c0 
c01067df:	c7 44 24 04 b5 02 00 	movl   $0x2b5,0x4(%esp)
c01067e6:	00 
c01067e7:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01067ee:	e8 c5 a5 ff ff       	call   c0100db8 <__panic>
c01067f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067f6:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01067fb:	89 c2                	mov    %eax,%edx
c01067fd:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106802:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106809:	00 
c010680a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010680e:	89 04 24             	mov    %eax,(%esp)
c0106811:	e8 91 f0 ff ff       	call   c01058a7 <get_pte>
c0106816:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106819:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010681d:	75 24                	jne    c0106843 <check_boot_pgdir+0x9e>
c010681f:	c7 44 24 0c 5c d2 10 	movl   $0xc010d25c,0xc(%esp)
c0106826:	c0 
c0106827:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c010682e:	c0 
c010682f:	c7 44 24 04 b5 02 00 	movl   $0x2b5,0x4(%esp)
c0106836:	00 
c0106837:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010683e:	e8 75 a5 ff ff       	call   c0100db8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0106843:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106846:	8b 00                	mov    (%eax),%eax
c0106848:	89 c2                	mov    %eax,%edx
c010684a:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c0106850:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106853:	39 c2                	cmp    %eax,%edx
c0106855:	74 24                	je     c010687b <check_boot_pgdir+0xd6>
c0106857:	c7 44 24 0c 99 d2 10 	movl   $0xc010d299,0xc(%esp)
c010685e:	c0 
c010685f:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106866:	c0 
c0106867:	c7 44 24 04 b6 02 00 	movl   $0x2b6,0x4(%esp)
c010686e:	00 
c010686f:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106876:	e8 3d a5 ff ff       	call   c0100db8 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c010687b:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0106882:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106885:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c010688a:	39 c2                	cmp    %eax,%edx
c010688c:	0f 82 25 ff ff ff    	jb     c01067b7 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0106892:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106897:	05 ac 0f 00 00       	add    $0xfac,%eax
c010689c:	8b 00                	mov    (%eax),%eax
c010689e:	89 c2                	mov    %eax,%edx
c01068a0:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c01068a6:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c01068ab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01068ae:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c01068b5:	77 23                	ja     c01068da <check_boot_pgdir+0x135>
c01068b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01068be:	c7 44 24 08 b0 ce 10 	movl   $0xc010ceb0,0x8(%esp)
c01068c5:	c0 
c01068c6:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c01068cd:	00 
c01068ce:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01068d5:	e8 de a4 ff ff       	call   c0100db8 <__panic>
c01068da:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068dd:	05 00 00 00 40       	add    $0x40000000,%eax
c01068e2:	39 c2                	cmp    %eax,%edx
c01068e4:	74 24                	je     c010690a <check_boot_pgdir+0x165>
c01068e6:	c7 44 24 0c b0 d2 10 	movl   $0xc010d2b0,0xc(%esp)
c01068ed:	c0 
c01068ee:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01068f5:	c0 
c01068f6:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c01068fd:	00 
c01068fe:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106905:	e8 ae a4 ff ff       	call   c0100db8 <__panic>

    assert(boot_pgdir[0] == 0);
c010690a:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c010690f:	8b 00                	mov    (%eax),%eax
c0106911:	85 c0                	test   %eax,%eax
c0106913:	74 24                	je     c0106939 <check_boot_pgdir+0x194>
c0106915:	c7 44 24 0c e4 d2 10 	movl   $0xc010d2e4,0xc(%esp)
c010691c:	c0 
c010691d:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106924:	c0 
c0106925:	c7 44 24 04 bb 02 00 	movl   $0x2bb,0x4(%esp)
c010692c:	00 
c010692d:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106934:	e8 7f a4 ff ff       	call   c0100db8 <__panic>

    struct Page *p;
    p = alloc_page();
c0106939:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106940:	e8 fc e7 ff ff       	call   c0105141 <alloc_pages>
c0106945:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0106948:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c010694d:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0106954:	00 
c0106955:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c010695c:	00 
c010695d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106960:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106964:	89 04 24             	mov    %eax,(%esp)
c0106967:	e8 91 f5 ff ff       	call   c0105efd <page_insert>
c010696c:	85 c0                	test   %eax,%eax
c010696e:	74 24                	je     c0106994 <check_boot_pgdir+0x1ef>
c0106970:	c7 44 24 0c f8 d2 10 	movl   $0xc010d2f8,0xc(%esp)
c0106977:	c0 
c0106978:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c010697f:	c0 
c0106980:	c7 44 24 04 bf 02 00 	movl   $0x2bf,0x4(%esp)
c0106987:	00 
c0106988:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c010698f:	e8 24 a4 ff ff       	call   c0100db8 <__panic>
    assert(page_ref(p) == 1);
c0106994:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106997:	89 04 24             	mov    %eax,(%esp)
c010699a:	e8 98 e5 ff ff       	call   c0104f37 <page_ref>
c010699f:	83 f8 01             	cmp    $0x1,%eax
c01069a2:	74 24                	je     c01069c8 <check_boot_pgdir+0x223>
c01069a4:	c7 44 24 0c 26 d3 10 	movl   $0xc010d326,0xc(%esp)
c01069ab:	c0 
c01069ac:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01069b3:	c0 
c01069b4:	c7 44 24 04 c0 02 00 	movl   $0x2c0,0x4(%esp)
c01069bb:	00 
c01069bc:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c01069c3:	e8 f0 a3 ff ff       	call   c0100db8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c01069c8:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c01069cd:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01069d4:	00 
c01069d5:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c01069dc:	00 
c01069dd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01069e0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01069e4:	89 04 24             	mov    %eax,(%esp)
c01069e7:	e8 11 f5 ff ff       	call   c0105efd <page_insert>
c01069ec:	85 c0                	test   %eax,%eax
c01069ee:	74 24                	je     c0106a14 <check_boot_pgdir+0x26f>
c01069f0:	c7 44 24 0c 38 d3 10 	movl   $0xc010d338,0xc(%esp)
c01069f7:	c0 
c01069f8:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c01069ff:	c0 
c0106a00:	c7 44 24 04 c1 02 00 	movl   $0x2c1,0x4(%esp)
c0106a07:	00 
c0106a08:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106a0f:	e8 a4 a3 ff ff       	call   c0100db8 <__panic>
    assert(page_ref(p) == 2);
c0106a14:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106a17:	89 04 24             	mov    %eax,(%esp)
c0106a1a:	e8 18 e5 ff ff       	call   c0104f37 <page_ref>
c0106a1f:	83 f8 02             	cmp    $0x2,%eax
c0106a22:	74 24                	je     c0106a48 <check_boot_pgdir+0x2a3>
c0106a24:	c7 44 24 0c 6f d3 10 	movl   $0xc010d36f,0xc(%esp)
c0106a2b:	c0 
c0106a2c:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106a33:	c0 
c0106a34:	c7 44 24 04 c2 02 00 	movl   $0x2c2,0x4(%esp)
c0106a3b:	00 
c0106a3c:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106a43:	e8 70 a3 ff ff       	call   c0100db8 <__panic>

    const char *str = "ucore: Hello world!!";
c0106a48:	c7 45 dc 80 d3 10 c0 	movl   $0xc010d380,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0106a4f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106a52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106a56:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106a5d:	e8 48 51 00 00       	call   c010bbaa <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0106a62:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0106a69:	00 
c0106a6a:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106a71:	e8 b1 51 00 00       	call   c010bc27 <strcmp>
c0106a76:	85 c0                	test   %eax,%eax
c0106a78:	74 24                	je     c0106a9e <check_boot_pgdir+0x2f9>
c0106a7a:	c7 44 24 0c 98 d3 10 	movl   $0xc010d398,0xc(%esp)
c0106a81:	c0 
c0106a82:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106a89:	c0 
c0106a8a:	c7 44 24 04 c6 02 00 	movl   $0x2c6,0x4(%esp)
c0106a91:	00 
c0106a92:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106a99:	e8 1a a3 ff ff       	call   c0100db8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106a9e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106aa1:	89 04 24             	mov    %eax,(%esp)
c0106aa4:	e8 e4 e3 ff ff       	call   c0104e8d <page2kva>
c0106aa9:	05 00 01 00 00       	add    $0x100,%eax
c0106aae:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106ab1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0106ab8:	e8 8f 50 00 00       	call   c010bb4c <strlen>
c0106abd:	85 c0                	test   %eax,%eax
c0106abf:	74 24                	je     c0106ae5 <check_boot_pgdir+0x340>
c0106ac1:	c7 44 24 0c d0 d3 10 	movl   $0xc010d3d0,0xc(%esp)
c0106ac8:	c0 
c0106ac9:	c7 44 24 08 f9 ce 10 	movl   $0xc010cef9,0x8(%esp)
c0106ad0:	c0 
c0106ad1:	c7 44 24 04 c9 02 00 	movl   $0x2c9,0x4(%esp)
c0106ad8:	00 
c0106ad9:	c7 04 24 d4 ce 10 c0 	movl   $0xc010ced4,(%esp)
c0106ae0:	e8 d3 a2 ff ff       	call   c0100db8 <__panic>

    free_page(p);
c0106ae5:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106aec:	00 
c0106aed:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106af0:	89 04 24             	mov    %eax,(%esp)
c0106af3:	e8 b4 e6 ff ff       	call   c01051ac <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0106af8:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106afd:	8b 00                	mov    (%eax),%eax
c0106aff:	89 04 24             	mov    %eax,(%esp)
c0106b02:	e8 18 e4 ff ff       	call   c0104f1f <pde2page>
c0106b07:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106b0e:	00 
c0106b0f:	89 04 24             	mov    %eax,(%esp)
c0106b12:	e8 95 e6 ff ff       	call   c01051ac <free_pages>
    boot_pgdir[0] = 0;
c0106b17:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0106b1c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106b22:	c7 04 24 f4 d3 10 c0 	movl   $0xc010d3f4,(%esp)
c0106b29:	e8 31 98 ff ff       	call   c010035f <cprintf>
}
c0106b2e:	c9                   	leave  
c0106b2f:	c3                   	ret    

c0106b30 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0106b30:	55                   	push   %ebp
c0106b31:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0106b33:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b36:	83 e0 04             	and    $0x4,%eax
c0106b39:	85 c0                	test   %eax,%eax
c0106b3b:	74 07                	je     c0106b44 <perm2str+0x14>
c0106b3d:	b8 75 00 00 00       	mov    $0x75,%eax
c0106b42:	eb 05                	jmp    c0106b49 <perm2str+0x19>
c0106b44:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106b49:	a2 68 ce 19 c0       	mov    %al,0xc019ce68
    str[1] = 'r';
c0106b4e:	c6 05 69 ce 19 c0 72 	movb   $0x72,0xc019ce69
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0106b55:	8b 45 08             	mov    0x8(%ebp),%eax
c0106b58:	83 e0 02             	and    $0x2,%eax
c0106b5b:	85 c0                	test   %eax,%eax
c0106b5d:	74 07                	je     c0106b66 <perm2str+0x36>
c0106b5f:	b8 77 00 00 00       	mov    $0x77,%eax
c0106b64:	eb 05                	jmp    c0106b6b <perm2str+0x3b>
c0106b66:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0106b6b:	a2 6a ce 19 c0       	mov    %al,0xc019ce6a
    str[3] = '\0';
c0106b70:	c6 05 6b ce 19 c0 00 	movb   $0x0,0xc019ce6b
    return str;
c0106b77:	b8 68 ce 19 c0       	mov    $0xc019ce68,%eax
}
c0106b7c:	5d                   	pop    %ebp
c0106b7d:	c3                   	ret    

c0106b7e <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0106b7e:	55                   	push   %ebp
c0106b7f:	89 e5                	mov    %esp,%ebp
c0106b81:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0106b84:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b87:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106b8a:	72 0e                	jb     c0106b9a <get_pgtable_items+0x1c>
        return 0;
c0106b8c:	b8 00 00 00 00       	mov    $0x0,%eax
c0106b91:	e9 86 00 00 00       	jmp    c0106c1c <get_pgtable_items+0x9e>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0106b96:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106b9a:	8b 45 10             	mov    0x10(%ebp),%eax
c0106b9d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106ba0:	73 12                	jae    c0106bb4 <get_pgtable_items+0x36>
c0106ba2:	8b 45 10             	mov    0x10(%ebp),%eax
c0106ba5:	c1 e0 02             	shl    $0x2,%eax
c0106ba8:	03 45 14             	add    0x14(%ebp),%eax
c0106bab:	8b 00                	mov    (%eax),%eax
c0106bad:	83 e0 01             	and    $0x1,%eax
c0106bb0:	85 c0                	test   %eax,%eax
c0106bb2:	74 e2                	je     c0106b96 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0106bb4:	8b 45 10             	mov    0x10(%ebp),%eax
c0106bb7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106bba:	73 5b                	jae    c0106c17 <get_pgtable_items+0x99>
        if (left_store != NULL) {
c0106bbc:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106bc0:	74 08                	je     c0106bca <get_pgtable_items+0x4c>
            *left_store = start;
c0106bc2:	8b 45 18             	mov    0x18(%ebp),%eax
c0106bc5:	8b 55 10             	mov    0x10(%ebp),%edx
c0106bc8:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106bca:	8b 45 10             	mov    0x10(%ebp),%eax
c0106bcd:	c1 e0 02             	shl    $0x2,%eax
c0106bd0:	03 45 14             	add    0x14(%ebp),%eax
c0106bd3:	8b 00                	mov    (%eax),%eax
c0106bd5:	83 e0 07             	and    $0x7,%eax
c0106bd8:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0106bdb:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106bdf:	eb 04                	jmp    c0106be5 <get_pgtable_items+0x67>
            start ++;
c0106be1:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106be5:	8b 45 10             	mov    0x10(%ebp),%eax
c0106be8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106beb:	73 17                	jae    c0106c04 <get_pgtable_items+0x86>
c0106bed:	8b 45 10             	mov    0x10(%ebp),%eax
c0106bf0:	c1 e0 02             	shl    $0x2,%eax
c0106bf3:	03 45 14             	add    0x14(%ebp),%eax
c0106bf6:	8b 00                	mov    (%eax),%eax
c0106bf8:	89 c2                	mov    %eax,%edx
c0106bfa:	83 e2 07             	and    $0x7,%edx
c0106bfd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c00:	39 c2                	cmp    %eax,%edx
c0106c02:	74 dd                	je     c0106be1 <get_pgtable_items+0x63>
            start ++;
        }
        if (right_store != NULL) {
c0106c04:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0106c08:	74 08                	je     c0106c12 <get_pgtable_items+0x94>
            *right_store = start;
c0106c0a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106c0d:	8b 55 10             	mov    0x10(%ebp),%edx
c0106c10:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106c12:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106c15:	eb 05                	jmp    c0106c1c <get_pgtable_items+0x9e>
    }
    return 0;
c0106c17:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106c1c:	c9                   	leave  
c0106c1d:	c3                   	ret    

c0106c1e <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106c1e:	55                   	push   %ebp
c0106c1f:	89 e5                	mov    %esp,%ebp
c0106c21:	57                   	push   %edi
c0106c22:	56                   	push   %esi
c0106c23:	53                   	push   %ebx
c0106c24:	83 ec 5c             	sub    $0x5c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0106c27:	c7 04 24 14 d4 10 c0 	movl   $0xc010d414,(%esp)
c0106c2e:	e8 2c 97 ff ff       	call   c010035f <cprintf>
    size_t left, right = 0, perm;
c0106c33:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106c3a:	e9 0b 01 00 00       	jmp    c0106d4a <print_pgdir+0x12c>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106c3f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106c42:	89 04 24             	mov    %eax,(%esp)
c0106c45:	e8 e6 fe ff ff       	call   c0106b30 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0106c4a:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106c4d:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106c50:	89 cb                	mov    %ecx,%ebx
c0106c52:	29 d3                	sub    %edx,%ebx
c0106c54:	89 da                	mov    %ebx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0106c56:	89 d6                	mov    %edx,%esi
c0106c58:	c1 e6 16             	shl    $0x16,%esi
c0106c5b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106c5e:	89 d3                	mov    %edx,%ebx
c0106c60:	c1 e3 16             	shl    $0x16,%ebx
c0106c63:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106c66:	89 d1                	mov    %edx,%ecx
c0106c68:	c1 e1 16             	shl    $0x16,%ecx
c0106c6b:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0106c6e:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c0106c71:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106c74:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c0106c77:	29 d7                	sub    %edx,%edi
c0106c79:	89 fa                	mov    %edi,%edx
c0106c7b:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106c7f:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106c83:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106c87:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106c8b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106c8f:	c7 04 24 45 d4 10 c0 	movl   $0xc010d445,(%esp)
c0106c96:	e8 c4 96 ff ff       	call   c010035f <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0106c9b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106c9e:	c1 e0 0a             	shl    $0xa,%eax
c0106ca1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106ca4:	eb 5c                	jmp    c0106d02 <print_pgdir+0xe4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106ca6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ca9:	89 04 24             	mov    %eax,(%esp)
c0106cac:	e8 7f fe ff ff       	call   c0106b30 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106cb1:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0106cb4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106cb7:	89 cb                	mov    %ecx,%ebx
c0106cb9:	29 d3                	sub    %edx,%ebx
c0106cbb:	89 da                	mov    %ebx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106cbd:	89 d6                	mov    %edx,%esi
c0106cbf:	c1 e6 0c             	shl    $0xc,%esi
c0106cc2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0106cc5:	89 d3                	mov    %edx,%ebx
c0106cc7:	c1 e3 0c             	shl    $0xc,%ebx
c0106cca:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106ccd:	89 d1                	mov    %edx,%ecx
c0106ccf:	c1 e1 0c             	shl    $0xc,%ecx
c0106cd2:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0106cd5:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c0106cd8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106cdb:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c0106cde:	29 d7                	sub    %edx,%edi
c0106ce0:	89 fa                	mov    %edi,%edx
c0106ce2:	89 44 24 14          	mov    %eax,0x14(%esp)
c0106ce6:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106cea:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106cee:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106cf2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106cf6:	c7 04 24 64 d4 10 c0 	movl   $0xc010d464,(%esp)
c0106cfd:	e8 5d 96 ff ff       	call   c010035f <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106d02:	8b 15 54 ce 10 c0    	mov    0xc010ce54,%edx
c0106d08:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106d0b:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106d0e:	89 ce                	mov    %ecx,%esi
c0106d10:	c1 e6 0a             	shl    $0xa,%esi
c0106d13:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0106d16:	89 cb                	mov    %ecx,%ebx
c0106d18:	c1 e3 0a             	shl    $0xa,%ebx
c0106d1b:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106d1e:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106d22:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0106d25:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106d29:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106d2d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106d31:	89 74 24 04          	mov    %esi,0x4(%esp)
c0106d35:	89 1c 24             	mov    %ebx,(%esp)
c0106d38:	e8 41 fe ff ff       	call   c0106b7e <get_pgtable_items>
c0106d3d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106d40:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106d44:	0f 85 5c ff ff ff    	jne    c0106ca6 <print_pgdir+0x88>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0106d4a:	8b 15 58 ce 10 c0    	mov    0xc010ce58,%edx
c0106d50:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106d53:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0106d56:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106d5a:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0106d5d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0106d61:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0106d65:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106d69:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0106d70:	00 
c0106d71:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0106d78:	e8 01 fe ff ff       	call   c0106b7e <get_pgtable_items>
c0106d7d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106d80:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0106d84:	0f 85 b5 fe ff ff    	jne    c0106c3f <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106d8a:	c7 04 24 88 d4 10 c0 	movl   $0xc010d488,(%esp)
c0106d91:	e8 c9 95 ff ff       	call   c010035f <cprintf>
}
c0106d96:	83 c4 5c             	add    $0x5c,%esp
c0106d99:	5b                   	pop    %ebx
c0106d9a:	5e                   	pop    %esi
c0106d9b:	5f                   	pop    %edi
c0106d9c:	5d                   	pop    %ebp
c0106d9d:	c3                   	ret    
	...

c0106da0 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106da0:	55                   	push   %ebp
c0106da1:	89 e5                	mov    %esp,%ebp
c0106da3:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0106da6:	8b 45 08             	mov    0x8(%ebp),%eax
c0106da9:	89 c2                	mov    %eax,%edx
c0106dab:	c1 ea 0c             	shr    $0xc,%edx
c0106dae:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c0106db3:	39 c2                	cmp    %eax,%edx
c0106db5:	72 1c                	jb     c0106dd3 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0106db7:	c7 44 24 08 bc d4 10 	movl   $0xc010d4bc,0x8(%esp)
c0106dbe:	c0 
c0106dbf:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0106dc6:	00 
c0106dc7:	c7 04 24 db d4 10 c0 	movl   $0xc010d4db,(%esp)
c0106dce:	e8 e5 9f ff ff       	call   c0100db8 <__panic>
    }
    return &pages[PPN(pa)];
c0106dd3:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c0106dd8:	8b 55 08             	mov    0x8(%ebp),%edx
c0106ddb:	c1 ea 0c             	shr    $0xc,%edx
c0106dde:	c1 e2 05             	shl    $0x5,%edx
c0106de1:	01 d0                	add    %edx,%eax
}
c0106de3:	c9                   	leave  
c0106de4:	c3                   	ret    

c0106de5 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106de5:	55                   	push   %ebp
c0106de6:	89 e5                	mov    %esp,%ebp
c0106de8:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0106dee:	83 e0 01             	and    $0x1,%eax
c0106df1:	85 c0                	test   %eax,%eax
c0106df3:	75 1c                	jne    c0106e11 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106df5:	c7 44 24 08 ec d4 10 	movl   $0xc010d4ec,0x8(%esp)
c0106dfc:	c0 
c0106dfd:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c0106e04:	00 
c0106e05:	c7 04 24 db d4 10 c0 	movl   $0xc010d4db,(%esp)
c0106e0c:	e8 a7 9f ff ff       	call   c0100db8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106e11:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e14:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106e19:	89 04 24             	mov    %eax,(%esp)
c0106e1c:	e8 7f ff ff ff       	call   c0106da0 <pa2page>
}
c0106e21:	c9                   	leave  
c0106e22:	c3                   	ret    

c0106e23 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0106e23:	55                   	push   %ebp
c0106e24:	89 e5                	mov    %esp,%ebp
c0106e26:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0106e29:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e2c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106e31:	89 04 24             	mov    %eax,(%esp)
c0106e34:	e8 67 ff ff ff       	call   c0106da0 <pa2page>
}
c0106e39:	c9                   	leave  
c0106e3a:	c3                   	ret    

c0106e3b <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c0106e3b:	55                   	push   %ebp
c0106e3c:	89 e5                	mov    %esp,%ebp
c0106e3e:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c0106e41:	e8 06 24 00 00       	call   c010924c <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c0106e46:	a1 7c ef 19 c0       	mov    0xc019ef7c,%eax
c0106e4b:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c0106e50:	76 0c                	jbe    c0106e5e <swap_init+0x23>
c0106e52:	a1 7c ef 19 c0       	mov    0xc019ef7c,%eax
c0106e57:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c0106e5c:	76 25                	jbe    c0106e83 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c0106e5e:	a1 7c ef 19 c0       	mov    0xc019ef7c,%eax
c0106e63:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106e67:	c7 44 24 08 0d d5 10 	movl   $0xc010d50d,0x8(%esp)
c0106e6e:	c0 
c0106e6f:	c7 44 24 04 27 00 00 	movl   $0x27,0x4(%esp)
c0106e76:	00 
c0106e77:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0106e7e:	e8 35 9f ff ff       	call   c0100db8 <__panic>
     }
     

     sm = &swap_manager_fifo;
c0106e83:	c7 05 74 ce 19 c0 60 	movl   $0xc012aa60,0xc019ce74
c0106e8a:	aa 12 c0 
     int r = sm->init();
c0106e8d:	a1 74 ce 19 c0       	mov    0xc019ce74,%eax
c0106e92:	8b 40 04             	mov    0x4(%eax),%eax
c0106e95:	ff d0                	call   *%eax
c0106e97:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106e9a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e9e:	75 26                	jne    c0106ec6 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106ea0:	c7 05 6c ce 19 c0 01 	movl   $0x1,0xc019ce6c
c0106ea7:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106eaa:	a1 74 ce 19 c0       	mov    0xc019ce74,%eax
c0106eaf:	8b 00                	mov    (%eax),%eax
c0106eb1:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106eb5:	c7 04 24 37 d5 10 c0 	movl   $0xc010d537,(%esp)
c0106ebc:	e8 9e 94 ff ff       	call   c010035f <cprintf>
          check_swap();
c0106ec1:	e8 a4 04 00 00       	call   c010736a <check_swap>
     }

     return r;
c0106ec6:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106ec9:	c9                   	leave  
c0106eca:	c3                   	ret    

c0106ecb <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106ecb:	55                   	push   %ebp
c0106ecc:	89 e5                	mov    %esp,%ebp
c0106ece:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106ed1:	a1 74 ce 19 c0       	mov    0xc019ce74,%eax
c0106ed6:	8b 50 08             	mov    0x8(%eax),%edx
c0106ed9:	8b 45 08             	mov    0x8(%ebp),%eax
c0106edc:	89 04 24             	mov    %eax,(%esp)
c0106edf:	ff d2                	call   *%edx
}
c0106ee1:	c9                   	leave  
c0106ee2:	c3                   	ret    

c0106ee3 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106ee3:	55                   	push   %ebp
c0106ee4:	89 e5                	mov    %esp,%ebp
c0106ee6:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106ee9:	a1 74 ce 19 c0       	mov    0xc019ce74,%eax
c0106eee:	8b 50 0c             	mov    0xc(%eax),%edx
c0106ef1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106ef4:	89 04 24             	mov    %eax,(%esp)
c0106ef7:	ff d2                	call   *%edx
}
c0106ef9:	c9                   	leave  
c0106efa:	c3                   	ret    

c0106efb <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106efb:	55                   	push   %ebp
c0106efc:	89 e5                	mov    %esp,%ebp
c0106efe:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106f01:	a1 74 ce 19 c0       	mov    0xc019ce74,%eax
c0106f06:	8b 50 10             	mov    0x10(%eax),%edx
c0106f09:	8b 45 14             	mov    0x14(%ebp),%eax
c0106f0c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106f10:	8b 45 10             	mov    0x10(%ebp),%eax
c0106f13:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106f17:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f21:	89 04 24             	mov    %eax,(%esp)
c0106f24:	ff d2                	call   *%edx
}
c0106f26:	c9                   	leave  
c0106f27:	c3                   	ret    

c0106f28 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106f28:	55                   	push   %ebp
c0106f29:	89 e5                	mov    %esp,%ebp
c0106f2b:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c0106f2e:	a1 74 ce 19 c0       	mov    0xc019ce74,%eax
c0106f33:	8b 50 14             	mov    0x14(%eax),%edx
c0106f36:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106f39:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f40:	89 04 24             	mov    %eax,(%esp)
c0106f43:	ff d2                	call   *%edx
}
c0106f45:	c9                   	leave  
c0106f46:	c3                   	ret    

c0106f47 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c0106f47:	55                   	push   %ebp
c0106f48:	89 e5                	mov    %esp,%ebp
c0106f4a:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c0106f4d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106f54:	e9 5a 01 00 00       	jmp    c01070b3 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c0106f59:	a1 74 ce 19 c0       	mov    0xc019ce74,%eax
c0106f5e:	8b 50 18             	mov    0x18(%eax),%edx
c0106f61:	8b 45 10             	mov    0x10(%ebp),%eax
c0106f64:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106f68:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0106f6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f6f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106f72:	89 04 24             	mov    %eax,(%esp)
c0106f75:	ff d2                	call   *%edx
c0106f77:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c0106f7a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106f7e:	74 18                	je     c0106f98 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c0106f80:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106f83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106f87:	c7 04 24 4c d5 10 c0 	movl   $0xc010d54c,(%esp)
c0106f8e:	e8 cc 93 ff ff       	call   c010035f <cprintf>
                  break;
c0106f93:	e9 27 01 00 00       	jmp    c01070bf <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106f98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106f9b:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106f9e:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106fa1:	8b 45 08             	mov    0x8(%ebp),%eax
c0106fa4:	8b 40 0c             	mov    0xc(%eax),%eax
c0106fa7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106fae:	00 
c0106faf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106fb2:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106fb6:	89 04 24             	mov    %eax,(%esp)
c0106fb9:	e8 e9 e8 ff ff       	call   c01058a7 <get_pte>
c0106fbe:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106fc1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106fc4:	8b 00                	mov    (%eax),%eax
c0106fc6:	83 e0 01             	and    $0x1,%eax
c0106fc9:	85 c0                	test   %eax,%eax
c0106fcb:	75 24                	jne    c0106ff1 <swap_out+0xaa>
c0106fcd:	c7 44 24 0c 79 d5 10 	movl   $0xc010d579,0xc(%esp)
c0106fd4:	c0 
c0106fd5:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0106fdc:	c0 
c0106fdd:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0106fe4:	00 
c0106fe5:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0106fec:	e8 c7 9d ff ff       	call   c0100db8 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106ff1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106ff4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ff7:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106ffa:	c1 ea 0c             	shr    $0xc,%edx
c0106ffd:	83 c2 01             	add    $0x1,%edx
c0107000:	c1 e2 08             	shl    $0x8,%edx
c0107003:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107007:	89 14 24             	mov    %edx,(%esp)
c010700a:	e8 f7 22 00 00       	call   c0109306 <swapfs_write>
c010700f:	85 c0                	test   %eax,%eax
c0107011:	74 34                	je     c0107047 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0107013:	c7 04 24 a3 d5 10 c0 	movl   $0xc010d5a3,(%esp)
c010701a:	e8 40 93 ff ff       	call   c010035f <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010701f:	a1 74 ce 19 c0       	mov    0xc019ce74,%eax
c0107024:	8b 50 10             	mov    0x10(%eax),%edx
c0107027:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010702a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0107031:	00 
c0107032:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107036:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107039:	89 44 24 04          	mov    %eax,0x4(%esp)
c010703d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107040:	89 04 24             	mov    %eax,(%esp)
c0107043:	ff d2                	call   *%edx
                    continue;
c0107045:	eb 68                	jmp    c01070af <swap_out+0x168>
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c0107047:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010704a:	8b 40 1c             	mov    0x1c(%eax),%eax
c010704d:	c1 e8 0c             	shr    $0xc,%eax
c0107050:	83 c0 01             	add    $0x1,%eax
c0107053:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0107057:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010705a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010705e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107061:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107065:	c7 04 24 bc d5 10 c0 	movl   $0xc010d5bc,(%esp)
c010706c:	e8 ee 92 ff ff       	call   c010035f <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c0107071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107074:	8b 40 1c             	mov    0x1c(%eax),%eax
c0107077:	c1 e8 0c             	shr    $0xc,%eax
c010707a:	83 c0 01             	add    $0x1,%eax
c010707d:	89 c2                	mov    %eax,%edx
c010707f:	c1 e2 08             	shl    $0x8,%edx
c0107082:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107085:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c0107087:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010708a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107091:	00 
c0107092:	89 04 24             	mov    %eax,(%esp)
c0107095:	e8 12 e1 ff ff       	call   c01051ac <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c010709a:	8b 45 08             	mov    0x8(%ebp),%eax
c010709d:	8b 40 0c             	mov    0xc(%eax),%eax
c01070a0:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01070a3:	89 54 24 04          	mov    %edx,0x4(%esp)
c01070a7:	89 04 24             	mov    %eax,(%esp)
c01070aa:	e8 07 ef ff ff       	call   c0105fb6 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c01070af:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01070b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01070b6:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01070b9:	0f 85 9a fe ff ff    	jne    c0106f59 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c01070bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01070c2:	c9                   	leave  
c01070c3:	c3                   	ret    

c01070c4 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c01070c4:	55                   	push   %ebp
c01070c5:	89 e5                	mov    %esp,%ebp
c01070c7:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c01070ca:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01070d1:	e8 6b e0 ff ff       	call   c0105141 <alloc_pages>
c01070d6:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c01070d9:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01070dd:	75 24                	jne    c0107103 <swap_in+0x3f>
c01070df:	c7 44 24 0c fc d5 10 	movl   $0xc010d5fc,0xc(%esp)
c01070e6:	c0 
c01070e7:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01070ee:	c0 
c01070ef:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01070f6:	00 
c01070f7:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01070fe:	e8 b5 9c ff ff       	call   c0100db8 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0107103:	8b 45 08             	mov    0x8(%ebp),%eax
c0107106:	8b 40 0c             	mov    0xc(%eax),%eax
c0107109:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107110:	00 
c0107111:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107114:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107118:	89 04 24             	mov    %eax,(%esp)
c010711b:	e8 87 e7 ff ff       	call   c01058a7 <get_pte>
c0107120:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0107123:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107126:	8b 00                	mov    (%eax),%eax
c0107128:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010712b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010712f:	89 04 24             	mov    %eax,(%esp)
c0107132:	e8 5d 21 00 00       	call   c0109294 <swapfs_read>
c0107137:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010713a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010713e:	74 2a                	je     c010716a <swap_in+0xa6>
     {
        assert(r!=0);
c0107140:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107144:	75 24                	jne    c010716a <swap_in+0xa6>
c0107146:	c7 44 24 0c 09 d6 10 	movl   $0xc010d609,0xc(%esp)
c010714d:	c0 
c010714e:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0107155:	c0 
c0107156:	c7 44 24 04 85 00 00 	movl   $0x85,0x4(%esp)
c010715d:	00 
c010715e:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0107165:	e8 4e 9c ff ff       	call   c0100db8 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c010716a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010716d:	8b 00                	mov    (%eax),%eax
c010716f:	89 c2                	mov    %eax,%edx
c0107171:	c1 ea 08             	shr    $0x8,%edx
c0107174:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107177:	89 44 24 08          	mov    %eax,0x8(%esp)
c010717b:	89 54 24 04          	mov    %edx,0x4(%esp)
c010717f:	c7 04 24 10 d6 10 c0 	movl   $0xc010d610,(%esp)
c0107186:	e8 d4 91 ff ff       	call   c010035f <cprintf>
     *ptr_result=result;
c010718b:	8b 45 10             	mov    0x10(%ebp),%eax
c010718e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107191:	89 10                	mov    %edx,(%eax)
     return 0;
c0107193:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107198:	c9                   	leave  
c0107199:	c3                   	ret    

c010719a <check_content_set>:



static inline void
check_content_set(void)
{
c010719a:	55                   	push   %ebp
c010719b:	89 e5                	mov    %esp,%ebp
c010719d:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c01071a0:	b8 00 10 00 00       	mov    $0x1000,%eax
c01071a5:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01071a8:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c01071ad:	83 f8 01             	cmp    $0x1,%eax
c01071b0:	74 24                	je     c01071d6 <check_content_set+0x3c>
c01071b2:	c7 44 24 0c 4e d6 10 	movl   $0xc010d64e,0xc(%esp)
c01071b9:	c0 
c01071ba:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01071c1:	c0 
c01071c2:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c01071c9:	00 
c01071ca:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01071d1:	e8 e2 9b ff ff       	call   c0100db8 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c01071d6:	b8 10 10 00 00       	mov    $0x1010,%eax
c01071db:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c01071de:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c01071e3:	83 f8 01             	cmp    $0x1,%eax
c01071e6:	74 24                	je     c010720c <check_content_set+0x72>
c01071e8:	c7 44 24 0c 4e d6 10 	movl   $0xc010d64e,0xc(%esp)
c01071ef:	c0 
c01071f0:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01071f7:	c0 
c01071f8:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01071ff:	00 
c0107200:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0107207:	e8 ac 9b ff ff       	call   c0100db8 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c010720c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107211:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0107214:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107219:	83 f8 02             	cmp    $0x2,%eax
c010721c:	74 24                	je     c0107242 <check_content_set+0xa8>
c010721e:	c7 44 24 0c 5d d6 10 	movl   $0xc010d65d,0xc(%esp)
c0107225:	c0 
c0107226:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c010722d:	c0 
c010722e:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0107235:	00 
c0107236:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c010723d:	e8 76 9b ff ff       	call   c0100db8 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0107242:	b8 10 20 00 00       	mov    $0x2010,%eax
c0107247:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c010724a:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c010724f:	83 f8 02             	cmp    $0x2,%eax
c0107252:	74 24                	je     c0107278 <check_content_set+0xde>
c0107254:	c7 44 24 0c 5d d6 10 	movl   $0xc010d65d,0xc(%esp)
c010725b:	c0 
c010725c:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0107263:	c0 
c0107264:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c010726b:	00 
c010726c:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0107273:	e8 40 9b ff ff       	call   c0100db8 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0107278:	b8 00 30 00 00       	mov    $0x3000,%eax
c010727d:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0107280:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107285:	83 f8 03             	cmp    $0x3,%eax
c0107288:	74 24                	je     c01072ae <check_content_set+0x114>
c010728a:	c7 44 24 0c 6c d6 10 	movl   $0xc010d66c,0xc(%esp)
c0107291:	c0 
c0107292:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0107299:	c0 
c010729a:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c01072a1:	00 
c01072a2:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01072a9:	e8 0a 9b ff ff       	call   c0100db8 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c01072ae:	b8 10 30 00 00       	mov    $0x3010,%eax
c01072b3:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01072b6:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c01072bb:	83 f8 03             	cmp    $0x3,%eax
c01072be:	74 24                	je     c01072e4 <check_content_set+0x14a>
c01072c0:	c7 44 24 0c 6c d6 10 	movl   $0xc010d66c,0xc(%esp)
c01072c7:	c0 
c01072c8:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01072cf:	c0 
c01072d0:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c01072d7:	00 
c01072d8:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01072df:	e8 d4 9a ff ff       	call   c0100db8 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c01072e4:	b8 00 40 00 00       	mov    $0x4000,%eax
c01072e9:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c01072ec:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c01072f1:	83 f8 04             	cmp    $0x4,%eax
c01072f4:	74 24                	je     c010731a <check_content_set+0x180>
c01072f6:	c7 44 24 0c 7b d6 10 	movl   $0xc010d67b,0xc(%esp)
c01072fd:	c0 
c01072fe:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0107305:	c0 
c0107306:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c010730d:	00 
c010730e:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0107315:	e8 9e 9a ff ff       	call   c0100db8 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c010731a:	b8 10 40 00 00       	mov    $0x4010,%eax
c010731f:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0107322:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107327:	83 f8 04             	cmp    $0x4,%eax
c010732a:	74 24                	je     c0107350 <check_content_set+0x1b6>
c010732c:	c7 44 24 0c 7b d6 10 	movl   $0xc010d67b,0xc(%esp)
c0107333:	c0 
c0107334:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c010733b:	c0 
c010733c:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0107343:	00 
c0107344:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c010734b:	e8 68 9a ff ff       	call   c0100db8 <__panic>
}
c0107350:	c9                   	leave  
c0107351:	c3                   	ret    

c0107352 <check_content_access>:

static inline int
check_content_access(void)
{
c0107352:	55                   	push   %ebp
c0107353:	89 e5                	mov    %esp,%ebp
c0107355:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0107358:	a1 74 ce 19 c0       	mov    0xc019ce74,%eax
c010735d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0107360:	ff d0                	call   *%eax
c0107362:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0107365:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107368:	c9                   	leave  
c0107369:	c3                   	ret    

c010736a <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c010736a:	55                   	push   %ebp
c010736b:	89 e5                	mov    %esp,%ebp
c010736d:	53                   	push   %ebx
c010736e:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0107371:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107378:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c010737f:	c7 45 e8 b8 ee 19 c0 	movl   $0xc019eeb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0107386:	eb 6b                	jmp    c01073f3 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0107388:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010738b:	83 e8 0c             	sub    $0xc,%eax
c010738e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0107391:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107394:	83 c0 04             	add    $0x4,%eax
c0107397:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010739e:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01073a1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c01073a4:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01073a7:	0f a3 10             	bt     %edx,(%eax)
c01073aa:	19 db                	sbb    %ebx,%ebx
c01073ac:	89 5d bc             	mov    %ebx,-0x44(%ebp)
    return oldbit != 0;
c01073af:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01073b3:	0f 95 c0             	setne  %al
c01073b6:	0f b6 c0             	movzbl %al,%eax
c01073b9:	85 c0                	test   %eax,%eax
c01073bb:	75 24                	jne    c01073e1 <check_swap+0x77>
c01073bd:	c7 44 24 0c 8a d6 10 	movl   $0xc010d68a,0xc(%esp)
c01073c4:	c0 
c01073c5:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01073cc:	c0 
c01073cd:	c7 44 24 04 bb 00 00 	movl   $0xbb,0x4(%esp)
c01073d4:	00 
c01073d5:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01073dc:	e8 d7 99 ff ff       	call   c0100db8 <__panic>
        count ++, total += p->property;
c01073e1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01073e5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01073e8:	8b 50 08             	mov    0x8(%eax),%edx
c01073eb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073ee:	01 d0                	add    %edx,%eax
c01073f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01073f3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01073f6:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01073f9:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01073fc:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01073ff:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107402:	81 7d e8 b8 ee 19 c0 	cmpl   $0xc019eeb8,-0x18(%ebp)
c0107409:	0f 85 79 ff ff ff    	jne    c0107388 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c010740f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0107412:	e8 c7 dd ff ff       	call   c01051de <nr_free_pages>
c0107417:	39 c3                	cmp    %eax,%ebx
c0107419:	74 24                	je     c010743f <check_swap+0xd5>
c010741b:	c7 44 24 0c 9a d6 10 	movl   $0xc010d69a,0xc(%esp)
c0107422:	c0 
c0107423:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c010742a:	c0 
c010742b:	c7 44 24 04 be 00 00 	movl   $0xbe,0x4(%esp)
c0107432:	00 
c0107433:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c010743a:	e8 79 99 ff ff       	call   c0100db8 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c010743f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107442:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107446:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107449:	89 44 24 04          	mov    %eax,0x4(%esp)
c010744d:	c7 04 24 b4 d6 10 c0 	movl   $0xc010d6b4,(%esp)
c0107454:	e8 06 8f ff ff       	call   c010035f <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0107459:	e8 72 0b 00 00       	call   c0107fd0 <mm_create>
c010745e:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0107461:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107465:	75 24                	jne    c010748b <check_swap+0x121>
c0107467:	c7 44 24 0c da d6 10 	movl   $0xc010d6da,0xc(%esp)
c010746e:	c0 
c010746f:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0107476:	c0 
c0107477:	c7 44 24 04 c3 00 00 	movl   $0xc3,0x4(%esp)
c010747e:	00 
c010747f:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0107486:	e8 2d 99 ff ff       	call   c0100db8 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c010748b:	a1 ac ef 19 c0       	mov    0xc019efac,%eax
c0107490:	85 c0                	test   %eax,%eax
c0107492:	74 24                	je     c01074b8 <check_swap+0x14e>
c0107494:	c7 44 24 0c e5 d6 10 	movl   $0xc010d6e5,0xc(%esp)
c010749b:	c0 
c010749c:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01074a3:	c0 
c01074a4:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c01074ab:	00 
c01074ac:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01074b3:	e8 00 99 ff ff       	call   c0100db8 <__panic>

     check_mm_struct = mm;
c01074b8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01074bb:	a3 ac ef 19 c0       	mov    %eax,0xc019efac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c01074c0:	8b 15 e4 cd 19 c0    	mov    0xc019cde4,%edx
c01074c6:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01074c9:	89 50 0c             	mov    %edx,0xc(%eax)
c01074cc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01074cf:	8b 40 0c             	mov    0xc(%eax),%eax
c01074d2:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c01074d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01074d8:	8b 00                	mov    (%eax),%eax
c01074da:	85 c0                	test   %eax,%eax
c01074dc:	74 24                	je     c0107502 <check_swap+0x198>
c01074de:	c7 44 24 0c fd d6 10 	movl   $0xc010d6fd,0xc(%esp)
c01074e5:	c0 
c01074e6:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01074ed:	c0 
c01074ee:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c01074f5:	00 
c01074f6:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01074fd:	e8 b6 98 ff ff       	call   c0100db8 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0107502:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0107509:	00 
c010750a:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0107511:	00 
c0107512:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0107519:	e8 4b 0b 00 00       	call   c0108069 <vma_create>
c010751e:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0107521:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107525:	75 24                	jne    c010754b <check_swap+0x1e1>
c0107527:	c7 44 24 0c 0b d7 10 	movl   $0xc010d70b,0xc(%esp)
c010752e:	c0 
c010752f:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0107536:	c0 
c0107537:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c010753e:	00 
c010753f:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0107546:	e8 6d 98 ff ff       	call   c0100db8 <__panic>

     insert_vma_struct(mm, vma);
c010754b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010754e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107552:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107555:	89 04 24             	mov    %eax,(%esp)
c0107558:	e8 9c 0c 00 00       	call   c01081f9 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c010755d:	c7 04 24 18 d7 10 c0 	movl   $0xc010d718,(%esp)
c0107564:	e8 f6 8d ff ff       	call   c010035f <cprintf>
     pte_t *temp_ptep=NULL;
c0107569:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0107570:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107573:	8b 40 0c             	mov    0xc(%eax),%eax
c0107576:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010757d:	00 
c010757e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0107585:	00 
c0107586:	89 04 24             	mov    %eax,(%esp)
c0107589:	e8 19 e3 ff ff       	call   c01058a7 <get_pte>
c010758e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0107591:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0107595:	75 24                	jne    c01075bb <check_swap+0x251>
c0107597:	c7 44 24 0c 4c d7 10 	movl   $0xc010d74c,0xc(%esp)
c010759e:	c0 
c010759f:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01075a6:	c0 
c01075a7:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c01075ae:	00 
c01075af:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01075b6:	e8 fd 97 ff ff       	call   c0100db8 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c01075bb:	c7 04 24 60 d7 10 c0 	movl   $0xc010d760,(%esp)
c01075c2:	e8 98 8d ff ff       	call   c010035f <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01075c7:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01075ce:	e9 a3 00 00 00       	jmp    c0107676 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c01075d3:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01075da:	e8 62 db ff ff       	call   c0105141 <alloc_pages>
c01075df:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01075e2:	89 04 95 e0 ee 19 c0 	mov    %eax,-0x3fe61120(,%edx,4)
          assert(check_rp[i] != NULL );
c01075e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01075ec:	8b 04 85 e0 ee 19 c0 	mov    -0x3fe61120(,%eax,4),%eax
c01075f3:	85 c0                	test   %eax,%eax
c01075f5:	75 24                	jne    c010761b <check_swap+0x2b1>
c01075f7:	c7 44 24 0c 84 d7 10 	movl   $0xc010d784,0xc(%esp)
c01075fe:	c0 
c01075ff:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0107606:	c0 
c0107607:	c7 44 24 04 db 00 00 	movl   $0xdb,0x4(%esp)
c010760e:	00 
c010760f:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0107616:	e8 9d 97 ff ff       	call   c0100db8 <__panic>
          assert(!PageProperty(check_rp[i]));
c010761b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010761e:	8b 04 85 e0 ee 19 c0 	mov    -0x3fe61120(,%eax,4),%eax
c0107625:	83 c0 04             	add    $0x4,%eax
c0107628:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c010762f:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0107632:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0107635:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0107638:	0f a3 10             	bt     %edx,(%eax)
c010763b:	19 db                	sbb    %ebx,%ebx
c010763d:	89 5d ac             	mov    %ebx,-0x54(%ebp)
    return oldbit != 0;
c0107640:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0107644:	0f 95 c0             	setne  %al
c0107647:	0f b6 c0             	movzbl %al,%eax
c010764a:	85 c0                	test   %eax,%eax
c010764c:	74 24                	je     c0107672 <check_swap+0x308>
c010764e:	c7 44 24 0c 98 d7 10 	movl   $0xc010d798,0xc(%esp)
c0107655:	c0 
c0107656:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c010765d:	c0 
c010765e:	c7 44 24 04 dc 00 00 	movl   $0xdc,0x4(%esp)
c0107665:	00 
c0107666:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c010766d:	e8 46 97 ff ff       	call   c0100db8 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107672:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107676:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010767a:	0f 8e 53 ff ff ff    	jle    c01075d3 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0107680:	a1 b8 ee 19 c0       	mov    0xc019eeb8,%eax
c0107685:	8b 15 bc ee 19 c0    	mov    0xc019eebc,%edx
c010768b:	89 45 98             	mov    %eax,-0x68(%ebp)
c010768e:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0107691:	c7 45 a8 b8 ee 19 c0 	movl   $0xc019eeb8,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107698:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010769b:	8b 55 a8             	mov    -0x58(%ebp),%edx
c010769e:	89 50 04             	mov    %edx,0x4(%eax)
c01076a1:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01076a4:	8b 50 04             	mov    0x4(%eax),%edx
c01076a7:	8b 45 a8             	mov    -0x58(%ebp),%eax
c01076aa:	89 10                	mov    %edx,(%eax)
c01076ac:	c7 45 a4 b8 ee 19 c0 	movl   $0xc019eeb8,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c01076b3:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01076b6:	8b 40 04             	mov    0x4(%eax),%eax
c01076b9:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c01076bc:	0f 94 c0             	sete   %al
c01076bf:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c01076c2:	85 c0                	test   %eax,%eax
c01076c4:	75 24                	jne    c01076ea <check_swap+0x380>
c01076c6:	c7 44 24 0c b3 d7 10 	movl   $0xc010d7b3,0xc(%esp)
c01076cd:	c0 
c01076ce:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01076d5:	c0 
c01076d6:	c7 44 24 04 e0 00 00 	movl   $0xe0,0x4(%esp)
c01076dd:	00 
c01076de:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01076e5:	e8 ce 96 ff ff       	call   c0100db8 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c01076ea:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c01076ef:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c01076f2:	c7 05 c0 ee 19 c0 00 	movl   $0x0,0xc019eec0
c01076f9:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01076fc:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107703:	eb 1e                	jmp    c0107723 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0107705:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107708:	8b 04 85 e0 ee 19 c0 	mov    -0x3fe61120(,%eax,4),%eax
c010770f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107716:	00 
c0107717:	89 04 24             	mov    %eax,(%esp)
c010771a:	e8 8d da ff ff       	call   c01051ac <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010771f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107723:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107727:	7e dc                	jle    c0107705 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0107729:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c010772e:	83 f8 04             	cmp    $0x4,%eax
c0107731:	74 24                	je     c0107757 <check_swap+0x3ed>
c0107733:	c7 44 24 0c cc d7 10 	movl   $0xc010d7cc,0xc(%esp)
c010773a:	c0 
c010773b:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0107742:	c0 
c0107743:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c010774a:	00 
c010774b:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0107752:	e8 61 96 ff ff       	call   c0100db8 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0107757:	c7 04 24 f0 d7 10 c0 	movl   $0xc010d7f0,(%esp)
c010775e:	e8 fc 8b ff ff       	call   c010035f <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0107763:	c7 05 78 ce 19 c0 00 	movl   $0x0,0xc019ce78
c010776a:	00 00 00 
     
     check_content_set();
c010776d:	e8 28 fa ff ff       	call   c010719a <check_content_set>
     assert( nr_free == 0);         
c0107772:	a1 c0 ee 19 c0       	mov    0xc019eec0,%eax
c0107777:	85 c0                	test   %eax,%eax
c0107779:	74 24                	je     c010779f <check_swap+0x435>
c010777b:	c7 44 24 0c 17 d8 10 	movl   $0xc010d817,0xc(%esp)
c0107782:	c0 
c0107783:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c010778a:	c0 
c010778b:	c7 44 24 04 f2 00 00 	movl   $0xf2,0x4(%esp)
c0107792:	00 
c0107793:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c010779a:	e8 19 96 ff ff       	call   c0100db8 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010779f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01077a6:	eb 26                	jmp    c01077ce <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c01077a8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077ab:	c7 04 85 00 ef 19 c0 	movl   $0xffffffff,-0x3fe61100(,%eax,4)
c01077b2:	ff ff ff ff 
c01077b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077b9:	8b 14 85 00 ef 19 c0 	mov    -0x3fe61100(,%eax,4),%edx
c01077c0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077c3:	89 14 85 40 ef 19 c0 	mov    %edx,-0x3fe610c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01077ca:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01077ce:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c01077d2:	7e d4                	jle    c01077a8 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01077d4:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01077db:	e9 eb 00 00 00       	jmp    c01078cb <check_swap+0x561>
         check_ptep[i]=0;
c01077e0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077e3:	c7 04 85 94 ef 19 c0 	movl   $0x0,-0x3fe6106c(,%eax,4)
c01077ea:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c01077ee:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01077f1:	83 c0 01             	add    $0x1,%eax
c01077f4:	c1 e0 0c             	shl    $0xc,%eax
c01077f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01077fe:	00 
c01077ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107803:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107806:	89 04 24             	mov    %eax,(%esp)
c0107809:	e8 99 e0 ff ff       	call   c01058a7 <get_pte>
c010780e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107811:	89 04 95 94 ef 19 c0 	mov    %eax,-0x3fe6106c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0107818:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010781b:	8b 04 85 94 ef 19 c0 	mov    -0x3fe6106c(,%eax,4),%eax
c0107822:	85 c0                	test   %eax,%eax
c0107824:	75 24                	jne    c010784a <check_swap+0x4e0>
c0107826:	c7 44 24 0c 24 d8 10 	movl   $0xc010d824,0xc(%esp)
c010782d:	c0 
c010782e:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c0107835:	c0 
c0107836:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010783d:	00 
c010783e:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c0107845:	e8 6e 95 ff ff       	call   c0100db8 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c010784a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010784d:	8b 04 85 94 ef 19 c0 	mov    -0x3fe6106c(,%eax,4),%eax
c0107854:	8b 00                	mov    (%eax),%eax
c0107856:	89 04 24             	mov    %eax,(%esp)
c0107859:	e8 87 f5 ff ff       	call   c0106de5 <pte2page>
c010785e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107861:	8b 14 95 e0 ee 19 c0 	mov    -0x3fe61120(,%edx,4),%edx
c0107868:	39 d0                	cmp    %edx,%eax
c010786a:	74 24                	je     c0107890 <check_swap+0x526>
c010786c:	c7 44 24 0c 3c d8 10 	movl   $0xc010d83c,0xc(%esp)
c0107873:	c0 
c0107874:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c010787b:	c0 
c010787c:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107883:	00 
c0107884:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c010788b:	e8 28 95 ff ff       	call   c0100db8 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0107890:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107893:	8b 04 85 94 ef 19 c0 	mov    -0x3fe6106c(,%eax,4),%eax
c010789a:	8b 00                	mov    (%eax),%eax
c010789c:	83 e0 01             	and    $0x1,%eax
c010789f:	85 c0                	test   %eax,%eax
c01078a1:	75 24                	jne    c01078c7 <check_swap+0x55d>
c01078a3:	c7 44 24 0c 64 d8 10 	movl   $0xc010d864,0xc(%esp)
c01078aa:	c0 
c01078ab:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01078b2:	c0 
c01078b3:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01078ba:	00 
c01078bb:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c01078c2:	e8 f1 94 ff ff       	call   c0100db8 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01078c7:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01078cb:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01078cf:	0f 8e 0b ff ff ff    	jle    c01077e0 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c01078d5:	c7 04 24 80 d8 10 c0 	movl   $0xc010d880,(%esp)
c01078dc:	e8 7e 8a ff ff       	call   c010035f <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c01078e1:	e8 6c fa ff ff       	call   c0107352 <check_content_access>
c01078e6:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c01078e9:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c01078ed:	74 24                	je     c0107913 <check_swap+0x5a9>
c01078ef:	c7 44 24 0c a6 d8 10 	movl   $0xc010d8a6,0xc(%esp)
c01078f6:	c0 
c01078f7:	c7 44 24 08 8e d5 10 	movl   $0xc010d58e,0x8(%esp)
c01078fe:	c0 
c01078ff:	c7 44 24 04 01 01 00 	movl   $0x101,0x4(%esp)
c0107906:	00 
c0107907:	c7 04 24 28 d5 10 c0 	movl   $0xc010d528,(%esp)
c010790e:	e8 a5 94 ff ff       	call   c0100db8 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107913:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010791a:	eb 1e                	jmp    c010793a <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c010791c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010791f:	8b 04 85 e0 ee 19 c0 	mov    -0x3fe61120(,%eax,4),%eax
c0107926:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010792d:	00 
c010792e:	89 04 24             	mov    %eax,(%esp)
c0107931:	e8 76 d8 ff ff       	call   c01051ac <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107936:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010793a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010793e:	7e dc                	jle    c010791c <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
    free_page(pde2page(pgdir[0]));
c0107940:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107943:	8b 00                	mov    (%eax),%eax
c0107945:	89 04 24             	mov    %eax,(%esp)
c0107948:	e8 d6 f4 ff ff       	call   c0106e23 <pde2page>
c010794d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107954:	00 
c0107955:	89 04 24             	mov    %eax,(%esp)
c0107958:	e8 4f d8 ff ff       	call   c01051ac <free_pages>
     pgdir[0] = 0;
c010795d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107960:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
     mm->pgdir = NULL;
c0107966:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107969:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
     mm_destroy(mm);
c0107970:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107973:	89 04 24             	mov    %eax,(%esp)
c0107976:	e8 af 09 00 00       	call   c010832a <mm_destroy>
     check_mm_struct = NULL;
c010797b:	c7 05 ac ef 19 c0 00 	movl   $0x0,0xc019efac
c0107982:	00 00 00 
     
     nr_free = nr_free_store;
c0107985:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107988:	a3 c0 ee 19 c0       	mov    %eax,0xc019eec0
     free_list = free_list_store;
c010798d:	8b 45 98             	mov    -0x68(%ebp),%eax
c0107990:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0107993:	a3 b8 ee 19 c0       	mov    %eax,0xc019eeb8
c0107998:	89 15 bc ee 19 c0    	mov    %edx,0xc019eebc

     
     le = &free_list;
c010799e:	c7 45 e8 b8 ee 19 c0 	movl   $0xc019eeb8,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01079a5:	eb 1f                	jmp    c01079c6 <check_swap+0x65c>
         struct Page *p = le2page(le, page_link);
c01079a7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079aa:	83 e8 0c             	sub    $0xc,%eax
c01079ad:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c01079b0:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01079b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01079b7:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01079ba:	8b 40 08             	mov    0x8(%eax),%eax
c01079bd:	89 d1                	mov    %edx,%ecx
c01079bf:	29 c1                	sub    %eax,%ecx
c01079c1:	89 c8                	mov    %ecx,%eax
c01079c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01079c6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079c9:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01079cc:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01079cf:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01079d2:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01079d5:	81 7d e8 b8 ee 19 c0 	cmpl   $0xc019eeb8,-0x18(%ebp)
c01079dc:	75 c9                	jne    c01079a7 <check_swap+0x63d>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c01079de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079e1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01079e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079e8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079ec:	c7 04 24 ad d8 10 c0 	movl   $0xc010d8ad,(%esp)
c01079f3:	e8 67 89 ff ff       	call   c010035f <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c01079f8:	c7 04 24 c7 d8 10 c0 	movl   $0xc010d8c7,(%esp)
c01079ff:	e8 5b 89 ff ff       	call   c010035f <cprintf>
}
c0107a04:	83 c4 74             	add    $0x74,%esp
c0107a07:	5b                   	pop    %ebx
c0107a08:	5d                   	pop    %ebp
c0107a09:	c3                   	ret    
	...

c0107a0c <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0107a0c:	55                   	push   %ebp
c0107a0d:	89 e5                	mov    %esp,%ebp
c0107a0f:	83 ec 10             	sub    $0x10,%esp
c0107a12:	c7 45 fc a4 ef 19 c0 	movl   $0xc019efa4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107a19:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107a1c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107a1f:	89 50 04             	mov    %edx,0x4(%eax)
c0107a22:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107a25:	8b 50 04             	mov    0x4(%eax),%edx
c0107a28:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107a2b:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0107a2d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a30:	c7 40 14 a4 ef 19 c0 	movl   $0xc019efa4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0107a37:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107a3c:	c9                   	leave  
c0107a3d:	c3                   	ret    

c0107a3e <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0107a3e:	55                   	push   %ebp
c0107a3f:	89 e5                	mov    %esp,%ebp
c0107a41:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107a44:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a47:	8b 40 14             	mov    0x14(%eax),%eax
c0107a4a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0107a4d:	8b 45 10             	mov    0x10(%ebp),%eax
c0107a50:	83 c0 14             	add    $0x14,%eax
c0107a53:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0107a56:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107a5a:	74 06                	je     c0107a62 <_fifo_map_swappable+0x24>
c0107a5c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107a60:	75 24                	jne    c0107a86 <_fifo_map_swappable+0x48>
c0107a62:	c7 44 24 0c e0 d8 10 	movl   $0xc010d8e0,0xc(%esp)
c0107a69:	c0 
c0107a6a:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107a71:	c0 
c0107a72:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0107a79:	00 
c0107a7a:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107a81:	e8 32 93 ff ff       	call   c0100db8 <__panic>
c0107a86:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a89:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107a8c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107a8f:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0107a92:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107a95:	8b 00                	mov    (%eax),%eax
c0107a97:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107a9a:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0107a9d:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107aa0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107aa3:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107aa6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107aa9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107aac:	89 10                	mov    %edx,(%eax)
c0107aae:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107ab1:	8b 10                	mov    (%eax),%edx
c0107ab3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107ab6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107ab9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107abc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107abf:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107ac2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107ac5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107ac8:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: 2011010312*/
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
	list_add_before(head, entry);
	return 0;
c0107aca:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107acf:	c9                   	leave  
c0107ad0:	c3                   	ret    

c0107ad1 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0107ad1:	55                   	push   %ebp
c0107ad2:	89 e5                	mov    %esp,%ebp
c0107ad4:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107ad7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ada:	8b 40 14             	mov    0x14(%eax),%eax
c0107add:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0107ae0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107ae4:	75 24                	jne    c0107b0a <_fifo_swap_out_victim+0x39>
c0107ae6:	c7 44 24 0c 27 d9 10 	movl   $0xc010d927,0xc(%esp)
c0107aed:	c0 
c0107aee:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107af5:	c0 
c0107af6:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0107afd:	00 
c0107afe:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107b05:	e8 ae 92 ff ff       	call   c0100db8 <__panic>
     assert(in_tick==0);
c0107b0a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107b0e:	74 24                	je     c0107b34 <_fifo_swap_out_victim+0x63>
c0107b10:	c7 44 24 0c 34 d9 10 	movl   $0xc010d934,0xc(%esp)
c0107b17:	c0 
c0107b18:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107b1f:	c0 
c0107b20:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0107b27:	00 
c0107b28:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107b2f:	e8 84 92 ff ff       	call   c0100db8 <__panic>
c0107b34:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b37:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107b3a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b3d:	8b 40 04             	mov    0x4(%eax),%eax
     /* Select the victim */
     /*LAB3 EXERCISE 2: 2011010312*/
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *le = list_next(head);
c0107b40:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head!=le);
c0107b43:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b46:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107b49:	75 24                	jne    c0107b6f <_fifo_swap_out_victim+0x9e>
c0107b4b:	c7 44 24 0c 3f d9 10 	movl   $0xc010d93f,0xc(%esp)
c0107b52:	c0 
c0107b53:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107b5a:	c0 
c0107b5b:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0107b62:	00 
c0107b63:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107b6a:	e8 49 92 ff ff       	call   c0100db8 <__panic>
     struct Page *p = le2page(le, pra_page_link);
c0107b6f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b72:	83 e8 14             	sub    $0x14,%eax
c0107b75:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0107b78:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b7b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107b7e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b81:	8b 40 04             	mov    0x4(%eax),%eax
c0107b84:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107b87:	8b 12                	mov    (%edx),%edx
c0107b89:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0107b8c:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107b8f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b92:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107b95:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107b98:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107b9e:	89 10                	mov    %edx,(%eax)
     list_del(le);
     assert(p !=NULL);
c0107ba0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107ba4:	75 24                	jne    c0107bca <_fifo_swap_out_victim+0xf9>
c0107ba6:	c7 44 24 0c 48 d9 10 	movl   $0xc010d948,0xc(%esp)
c0107bad:	c0 
c0107bae:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107bb5:	c0 
c0107bb6:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c0107bbd:	00 
c0107bbe:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107bc5:	e8 ee 91 ff ff       	call   c0100db8 <__panic>
     *ptr_page = p;
c0107bca:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107bcd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107bd0:	89 10                	mov    %edx,(%eax)
     return 0;
c0107bd2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107bd7:	c9                   	leave  
c0107bd8:	c3                   	ret    

c0107bd9 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0107bd9:	55                   	push   %ebp
c0107bda:	89 e5                	mov    %esp,%ebp
c0107bdc:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107bdf:	c7 04 24 54 d9 10 c0 	movl   $0xc010d954,(%esp)
c0107be6:	e8 74 87 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107beb:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107bf0:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0107bf3:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107bf8:	83 f8 04             	cmp    $0x4,%eax
c0107bfb:	74 24                	je     c0107c21 <_fifo_check_swap+0x48>
c0107bfd:	c7 44 24 0c 7a d9 10 	movl   $0xc010d97a,0xc(%esp)
c0107c04:	c0 
c0107c05:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107c0c:	c0 
c0107c0d:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c0107c14:	00 
c0107c15:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107c1c:	e8 97 91 ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107c21:	c7 04 24 8c d9 10 c0 	movl   $0xc010d98c,(%esp)
c0107c28:	e8 32 87 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107c2d:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107c32:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0107c35:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107c3a:	83 f8 04             	cmp    $0x4,%eax
c0107c3d:	74 24                	je     c0107c63 <_fifo_check_swap+0x8a>
c0107c3f:	c7 44 24 0c 7a d9 10 	movl   $0xc010d97a,0xc(%esp)
c0107c46:	c0 
c0107c47:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107c4e:	c0 
c0107c4f:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0107c56:	00 
c0107c57:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107c5e:	e8 55 91 ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107c63:	c7 04 24 b4 d9 10 c0 	movl   $0xc010d9b4,(%esp)
c0107c6a:	e8 f0 86 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107c6f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107c74:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0107c77:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107c7c:	83 f8 04             	cmp    $0x4,%eax
c0107c7f:	74 24                	je     c0107ca5 <_fifo_check_swap+0xcc>
c0107c81:	c7 44 24 0c 7a d9 10 	movl   $0xc010d97a,0xc(%esp)
c0107c88:	c0 
c0107c89:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107c90:	c0 
c0107c91:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0107c98:	00 
c0107c99:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107ca0:	e8 13 91 ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107ca5:	c7 04 24 dc d9 10 c0 	movl   $0xc010d9dc,(%esp)
c0107cac:	e8 ae 86 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107cb1:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107cb6:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0107cb9:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107cbe:	83 f8 04             	cmp    $0x4,%eax
c0107cc1:	74 24                	je     c0107ce7 <_fifo_check_swap+0x10e>
c0107cc3:	c7 44 24 0c 7a d9 10 	movl   $0xc010d97a,0xc(%esp)
c0107cca:	c0 
c0107ccb:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107cd2:	c0 
c0107cd3:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c0107cda:	00 
c0107cdb:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107ce2:	e8 d1 90 ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107ce7:	c7 04 24 04 da 10 c0 	movl   $0xc010da04,(%esp)
c0107cee:	e8 6c 86 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107cf3:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107cf8:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c0107cfb:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107d00:	83 f8 05             	cmp    $0x5,%eax
c0107d03:	74 24                	je     c0107d29 <_fifo_check_swap+0x150>
c0107d05:	c7 44 24 0c 2a da 10 	movl   $0xc010da2a,0xc(%esp)
c0107d0c:	c0 
c0107d0d:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107d14:	c0 
c0107d15:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0107d1c:	00 
c0107d1d:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107d24:	e8 8f 90 ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107d29:	c7 04 24 dc d9 10 c0 	movl   $0xc010d9dc,(%esp)
c0107d30:	e8 2a 86 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107d35:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107d3a:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107d3d:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107d42:	83 f8 05             	cmp    $0x5,%eax
c0107d45:	74 24                	je     c0107d6b <_fifo_check_swap+0x192>
c0107d47:	c7 44 24 0c 2a da 10 	movl   $0xc010da2a,0xc(%esp)
c0107d4e:	c0 
c0107d4f:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107d56:	c0 
c0107d57:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0107d5e:	00 
c0107d5f:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107d66:	e8 4d 90 ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107d6b:	c7 04 24 8c d9 10 c0 	movl   $0xc010d98c,(%esp)
c0107d72:	e8 e8 85 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107d77:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107d7c:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c0107d7f:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107d84:	83 f8 06             	cmp    $0x6,%eax
c0107d87:	74 24                	je     c0107dad <_fifo_check_swap+0x1d4>
c0107d89:	c7 44 24 0c 39 da 10 	movl   $0xc010da39,0xc(%esp)
c0107d90:	c0 
c0107d91:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107d98:	c0 
c0107d99:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0107da0:	00 
c0107da1:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107da8:	e8 0b 90 ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107dad:	c7 04 24 dc d9 10 c0 	movl   $0xc010d9dc,(%esp)
c0107db4:	e8 a6 85 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107db9:	b8 00 20 00 00       	mov    $0x2000,%eax
c0107dbe:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c0107dc1:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107dc6:	83 f8 07             	cmp    $0x7,%eax
c0107dc9:	74 24                	je     c0107def <_fifo_check_swap+0x216>
c0107dcb:	c7 44 24 0c 48 da 10 	movl   $0xc010da48,0xc(%esp)
c0107dd2:	c0 
c0107dd3:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107dda:	c0 
c0107ddb:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107de2:	00 
c0107de3:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107dea:	e8 c9 8f ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107def:	c7 04 24 54 d9 10 c0 	movl   $0xc010d954,(%esp)
c0107df6:	e8 64 85 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0107dfb:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107e00:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107e03:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107e08:	83 f8 08             	cmp    $0x8,%eax
c0107e0b:	74 24                	je     c0107e31 <_fifo_check_swap+0x258>
c0107e0d:	c7 44 24 0c 57 da 10 	movl   $0xc010da57,0xc(%esp)
c0107e14:	c0 
c0107e15:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107e1c:	c0 
c0107e1d:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107e24:	00 
c0107e25:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107e2c:	e8 87 8f ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107e31:	c7 04 24 b4 d9 10 c0 	movl   $0xc010d9b4,(%esp)
c0107e38:	e8 22 85 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107e3d:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107e42:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107e45:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107e4a:	83 f8 09             	cmp    $0x9,%eax
c0107e4d:	74 24                	je     c0107e73 <_fifo_check_swap+0x29a>
c0107e4f:	c7 44 24 0c 66 da 10 	movl   $0xc010da66,0xc(%esp)
c0107e56:	c0 
c0107e57:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107e5e:	c0 
c0107e5f:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0107e66:	00 
c0107e67:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107e6e:	e8 45 8f ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107e73:	c7 04 24 04 da 10 c0 	movl   $0xc010da04,(%esp)
c0107e7a:	e8 e0 84 ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107e7f:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107e84:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c0107e87:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107e8c:	83 f8 0a             	cmp    $0xa,%eax
c0107e8f:	74 24                	je     c0107eb5 <_fifo_check_swap+0x2dc>
c0107e91:	c7 44 24 0c 75 da 10 	movl   $0xc010da75,0xc(%esp)
c0107e98:	c0 
c0107e99:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107ea0:	c0 
c0107ea1:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c0107ea8:	00 
c0107ea9:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107eb0:	e8 03 8f ff ff       	call   c0100db8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107eb5:	c7 04 24 8c d9 10 c0 	movl   $0xc010d98c,(%esp)
c0107ebc:	e8 9e 84 ff ff       	call   c010035f <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c0107ec1:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107ec6:	0f b6 00             	movzbl (%eax),%eax
c0107ec9:	3c 0a                	cmp    $0xa,%al
c0107ecb:	74 24                	je     c0107ef1 <_fifo_check_swap+0x318>
c0107ecd:	c7 44 24 0c 88 da 10 	movl   $0xc010da88,0xc(%esp)
c0107ed4:	c0 
c0107ed5:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107edc:	c0 
c0107edd:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0107ee4:	00 
c0107ee5:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107eec:	e8 c7 8e ff ff       	call   c0100db8 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0107ef1:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107ef6:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0107ef9:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0107efe:	83 f8 0b             	cmp    $0xb,%eax
c0107f01:	74 24                	je     c0107f27 <_fifo_check_swap+0x34e>
c0107f03:	c7 44 24 0c a9 da 10 	movl   $0xc010daa9,0xc(%esp)
c0107f0a:	c0 
c0107f0b:	c7 44 24 08 fe d8 10 	movl   $0xc010d8fe,0x8(%esp)
c0107f12:	c0 
c0107f13:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c0107f1a:	00 
c0107f1b:	c7 04 24 13 d9 10 c0 	movl   $0xc010d913,(%esp)
c0107f22:	e8 91 8e ff ff       	call   c0100db8 <__panic>
    return 0;
c0107f27:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107f2c:	c9                   	leave  
c0107f2d:	c3                   	ret    

c0107f2e <_fifo_init>:


static int
_fifo_init(void)
{
c0107f2e:	55                   	push   %ebp
c0107f2f:	89 e5                	mov    %esp,%ebp
    return 0;
c0107f31:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107f36:	5d                   	pop    %ebp
c0107f37:	c3                   	ret    

c0107f38 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107f38:	55                   	push   %ebp
c0107f39:	89 e5                	mov    %esp,%ebp
    return 0;
c0107f3b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107f40:	5d                   	pop    %ebp
c0107f41:	c3                   	ret    

c0107f42 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107f42:	55                   	push   %ebp
c0107f43:	89 e5                	mov    %esp,%ebp
c0107f45:	b8 00 00 00 00       	mov    $0x0,%eax
c0107f4a:	5d                   	pop    %ebp
c0107f4b:	c3                   	ret    

c0107f4c <lock_init>:
#define local_intr_restore(x)   __intr_restore(x);

typedef volatile bool lock_t;

static inline void
lock_init(lock_t *lock) {
c0107f4c:	55                   	push   %ebp
c0107f4d:	89 e5                	mov    %esp,%ebp
    *lock = 0;
c0107f4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f52:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
}
c0107f58:	5d                   	pop    %ebp
c0107f59:	c3                   	ret    

c0107f5a <mm_count>:
bool user_mem_check(struct mm_struct *mm, uintptr_t start, size_t len, bool write);
bool copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable);
bool copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len);

static inline int
mm_count(struct mm_struct *mm) {
c0107f5a:	55                   	push   %ebp
c0107f5b:	89 e5                	mov    %esp,%ebp
    return mm->mm_count;
c0107f5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f60:	8b 40 18             	mov    0x18(%eax),%eax
}
c0107f63:	5d                   	pop    %ebp
c0107f64:	c3                   	ret    

c0107f65 <set_mm_count>:

static inline void
set_mm_count(struct mm_struct *mm, int val) {
c0107f65:	55                   	push   %ebp
c0107f66:	89 e5                	mov    %esp,%ebp
    mm->mm_count = val;
c0107f68:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f6b:	8b 55 0c             	mov    0xc(%ebp),%edx
c0107f6e:	89 50 18             	mov    %edx,0x18(%eax)
}
c0107f71:	5d                   	pop    %ebp
c0107f72:	c3                   	ret    

c0107f73 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107f73:	55                   	push   %ebp
c0107f74:	89 e5                	mov    %esp,%ebp
c0107f76:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107f79:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f7c:	89 c2                	mov    %eax,%edx
c0107f7e:	c1 ea 0c             	shr    $0xc,%edx
c0107f81:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c0107f86:	39 c2                	cmp    %eax,%edx
c0107f88:	72 1c                	jb     c0107fa6 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107f8a:	c7 44 24 08 cc da 10 	movl   $0xc010dacc,0x8(%esp)
c0107f91:	c0 
c0107f92:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c0107f99:	00 
c0107f9a:	c7 04 24 eb da 10 c0 	movl   $0xc010daeb,(%esp)
c0107fa1:	e8 12 8e ff ff       	call   c0100db8 <__panic>
    }
    return &pages[PPN(pa)];
c0107fa6:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c0107fab:	8b 55 08             	mov    0x8(%ebp),%edx
c0107fae:	c1 ea 0c             	shr    $0xc,%edx
c0107fb1:	c1 e2 05             	shl    $0x5,%edx
c0107fb4:	01 d0                	add    %edx,%eax
}
c0107fb6:	c9                   	leave  
c0107fb7:	c3                   	ret    

c0107fb8 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c0107fb8:	55                   	push   %ebp
c0107fb9:	89 e5                	mov    %esp,%ebp
c0107fbb:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0107fbe:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fc1:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107fc6:	89 04 24             	mov    %eax,(%esp)
c0107fc9:	e8 a5 ff ff ff       	call   c0107f73 <pa2page>
}
c0107fce:	c9                   	leave  
c0107fcf:	c3                   	ret    

c0107fd0 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c0107fd0:	55                   	push   %ebp
c0107fd1:	89 e5                	mov    %esp,%ebp
c0107fd3:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c0107fd6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0107fdd:	e8 d8 cc ff ff       	call   c0104cba <kmalloc>
c0107fe2:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c0107fe5:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107fe9:	74 79                	je     c0108064 <mm_create+0x94>
        list_init(&(mm->mmap_list));
c0107feb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fee:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0107ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ff4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107ff7:	89 50 04             	mov    %edx,0x4(%eax)
c0107ffa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ffd:	8b 50 04             	mov    0x4(%eax),%edx
c0108000:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108003:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0108005:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108008:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c010800f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108012:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0108019:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010801c:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0108023:	a1 6c ce 19 c0       	mov    0xc019ce6c,%eax
c0108028:	85 c0                	test   %eax,%eax
c010802a:	74 0d                	je     c0108039 <mm_create+0x69>
c010802c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010802f:	89 04 24             	mov    %eax,(%esp)
c0108032:	e8 94 ee ff ff       	call   c0106ecb <swap_init_mm>
c0108037:	eb 0a                	jmp    c0108043 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0108039:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010803c:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        
        set_mm_count(mm, 0);
c0108043:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010804a:	00 
c010804b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010804e:	89 04 24             	mov    %eax,(%esp)
c0108051:	e8 0f ff ff ff       	call   c0107f65 <set_mm_count>
        lock_init(&(mm->mm_lock));
c0108056:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108059:	83 c0 1c             	add    $0x1c,%eax
c010805c:	89 04 24             	mov    %eax,(%esp)
c010805f:	e8 e8 fe ff ff       	call   c0107f4c <lock_init>
    }    
    return mm;
c0108064:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108067:	c9                   	leave  
c0108068:	c3                   	ret    

c0108069 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0108069:	55                   	push   %ebp
c010806a:	89 e5                	mov    %esp,%ebp
c010806c:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c010806f:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0108076:	e8 3f cc ff ff       	call   c0104cba <kmalloc>
c010807b:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010807e:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108082:	74 1b                	je     c010809f <vma_create+0x36>
        vma->vm_start = vm_start;
c0108084:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108087:	8b 55 08             	mov    0x8(%ebp),%edx
c010808a:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c010808d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108090:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108093:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0108096:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108099:	8b 55 10             	mov    0x10(%ebp),%edx
c010809c:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c010809f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01080a2:	c9                   	leave  
c01080a3:	c3                   	ret    

c01080a4 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c01080a4:	55                   	push   %ebp
c01080a5:	89 e5                	mov    %esp,%ebp
c01080a7:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c01080aa:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c01080b1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01080b5:	0f 84 95 00 00 00    	je     c0108150 <find_vma+0xac>
        vma = mm->mmap_cache;
c01080bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01080be:	8b 40 08             	mov    0x8(%eax),%eax
c01080c1:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01080c4:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01080c8:	74 16                	je     c01080e0 <find_vma+0x3c>
c01080ca:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01080cd:	8b 40 04             	mov    0x4(%eax),%eax
c01080d0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01080d3:	77 0b                	ja     c01080e0 <find_vma+0x3c>
c01080d5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01080d8:	8b 40 08             	mov    0x8(%eax),%eax
c01080db:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01080de:	77 61                	ja     c0108141 <find_vma+0x9d>
                bool found = 0;
c01080e0:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01080e7:	8b 45 08             	mov    0x8(%ebp),%eax
c01080ea:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01080ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01080f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01080f3:	eb 28                	jmp    c010811d <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01080f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080f8:	83 e8 10             	sub    $0x10,%eax
c01080fb:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01080fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108101:	8b 40 04             	mov    0x4(%eax),%eax
c0108104:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108107:	77 14                	ja     c010811d <find_vma+0x79>
c0108109:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010810c:	8b 40 08             	mov    0x8(%eax),%eax
c010810f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0108112:	76 09                	jbe    c010811d <find_vma+0x79>
                        found = 1;
c0108114:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c010811b:	eb 17                	jmp    c0108134 <find_vma+0x90>
c010811d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108120:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108123:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108126:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0108129:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010812c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010812f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108132:	75 c1                	jne    c01080f5 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0108134:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0108138:	75 07                	jne    c0108141 <find_vma+0x9d>
                    vma = NULL;
c010813a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0108141:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108145:	74 09                	je     c0108150 <find_vma+0xac>
            mm->mmap_cache = vma;
c0108147:	8b 45 08             	mov    0x8(%ebp),%eax
c010814a:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010814d:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0108150:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108153:	c9                   	leave  
c0108154:	c3                   	ret    

c0108155 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0108155:	55                   	push   %ebp
c0108156:	89 e5                	mov    %esp,%ebp
c0108158:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c010815b:	8b 45 08             	mov    0x8(%ebp),%eax
c010815e:	8b 50 04             	mov    0x4(%eax),%edx
c0108161:	8b 45 08             	mov    0x8(%ebp),%eax
c0108164:	8b 40 08             	mov    0x8(%eax),%eax
c0108167:	39 c2                	cmp    %eax,%edx
c0108169:	72 24                	jb     c010818f <check_vma_overlap+0x3a>
c010816b:	c7 44 24 0c f9 da 10 	movl   $0xc010daf9,0xc(%esp)
c0108172:	c0 
c0108173:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c010817a:	c0 
c010817b:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c0108182:	00 
c0108183:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c010818a:	e8 29 8c ff ff       	call   c0100db8 <__panic>
    assert(prev->vm_end <= next->vm_start);
c010818f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108192:	8b 50 08             	mov    0x8(%eax),%edx
c0108195:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108198:	8b 40 04             	mov    0x4(%eax),%eax
c010819b:	39 c2                	cmp    %eax,%edx
c010819d:	76 24                	jbe    c01081c3 <check_vma_overlap+0x6e>
c010819f:	c7 44 24 0c 3c db 10 	movl   $0xc010db3c,0xc(%esp)
c01081a6:	c0 
c01081a7:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c01081ae:	c0 
c01081af:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c01081b6:	00 
c01081b7:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c01081be:	e8 f5 8b ff ff       	call   c0100db8 <__panic>
    assert(next->vm_start < next->vm_end);
c01081c3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081c6:	8b 50 04             	mov    0x4(%eax),%edx
c01081c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01081cc:	8b 40 08             	mov    0x8(%eax),%eax
c01081cf:	39 c2                	cmp    %eax,%edx
c01081d1:	72 24                	jb     c01081f7 <check_vma_overlap+0xa2>
c01081d3:	c7 44 24 0c 5b db 10 	movl   $0xc010db5b,0xc(%esp)
c01081da:	c0 
c01081db:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c01081e2:	c0 
c01081e3:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c01081ea:	00 
c01081eb:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c01081f2:	e8 c1 8b ff ff       	call   c0100db8 <__panic>
}
c01081f7:	c9                   	leave  
c01081f8:	c3                   	ret    

c01081f9 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01081f9:	55                   	push   %ebp
c01081fa:	89 e5                	mov    %esp,%ebp
c01081fc:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01081ff:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108202:	8b 50 04             	mov    0x4(%eax),%edx
c0108205:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108208:	8b 40 08             	mov    0x8(%eax),%eax
c010820b:	39 c2                	cmp    %eax,%edx
c010820d:	72 24                	jb     c0108233 <insert_vma_struct+0x3a>
c010820f:	c7 44 24 0c 79 db 10 	movl   $0xc010db79,0xc(%esp)
c0108216:	c0 
c0108217:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c010821e:	c0 
c010821f:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0108226:	00 
c0108227:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c010822e:	e8 85 8b ff ff       	call   c0100db8 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0108233:	8b 45 08             	mov    0x8(%ebp),%eax
c0108236:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0108239:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010823c:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c010823f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108242:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0108245:	eb 1f                	jmp    c0108266 <insert_vma_struct+0x6d>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0108247:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010824a:	83 e8 10             	sub    $0x10,%eax
c010824d:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0108250:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108253:	8b 50 04             	mov    0x4(%eax),%edx
c0108256:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108259:	8b 40 04             	mov    0x4(%eax),%eax
c010825c:	39 c2                	cmp    %eax,%edx
c010825e:	77 1f                	ja     c010827f <insert_vma_struct+0x86>
                break;
            }
            le_prev = le;
c0108260:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108263:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108266:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108269:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010826c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010826f:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0108272:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108275:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108278:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010827b:	75 ca                	jne    c0108247 <insert_vma_struct+0x4e>
c010827d:	eb 01                	jmp    c0108280 <insert_vma_struct+0x87>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
                break;
c010827f:	90                   	nop
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0108280:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108283:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108286:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108289:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c010828c:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c010828f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108292:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108295:	74 15                	je     c01082ac <insert_vma_struct+0xb3>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0108297:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010829a:	8d 50 f0             	lea    -0x10(%eax),%edx
c010829d:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082a4:	89 14 24             	mov    %edx,(%esp)
c01082a7:	e8 a9 fe ff ff       	call   c0108155 <check_vma_overlap>
    }
    if (le_next != list) {
c01082ac:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082af:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01082b2:	74 15                	je     c01082c9 <insert_vma_struct+0xd0>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c01082b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082b7:	83 e8 10             	sub    $0x10,%eax
c01082ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082c1:	89 04 24             	mov    %eax,(%esp)
c01082c4:	e8 8c fe ff ff       	call   c0108155 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01082c9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082cc:	8b 55 08             	mov    0x8(%ebp),%edx
c01082cf:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01082d1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082d4:	8d 50 10             	lea    0x10(%eax),%edx
c01082d7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082da:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01082dd:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01082e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01082e3:	8b 40 04             	mov    0x4(%eax),%eax
c01082e6:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01082e9:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01082ec:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01082ef:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01082f2:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01082f5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01082f8:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01082fb:	89 10                	mov    %edx,(%eax)
c01082fd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108300:	8b 10                	mov    (%eax),%edx
c0108302:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108305:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108308:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010830b:	8b 55 c8             	mov    -0x38(%ebp),%edx
c010830e:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108311:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108314:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108317:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0108319:	8b 45 08             	mov    0x8(%ebp),%eax
c010831c:	8b 40 10             	mov    0x10(%eax),%eax
c010831f:	8d 50 01             	lea    0x1(%eax),%edx
c0108322:	8b 45 08             	mov    0x8(%ebp),%eax
c0108325:	89 50 10             	mov    %edx,0x10(%eax)
}
c0108328:	c9                   	leave  
c0108329:	c3                   	ret    

c010832a <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c010832a:	55                   	push   %ebp
c010832b:	89 e5                	mov    %esp,%ebp
c010832d:	83 ec 38             	sub    $0x38,%esp
    assert(mm_count(mm) == 0);
c0108330:	8b 45 08             	mov    0x8(%ebp),%eax
c0108333:	89 04 24             	mov    %eax,(%esp)
c0108336:	e8 1f fc ff ff       	call   c0107f5a <mm_count>
c010833b:	85 c0                	test   %eax,%eax
c010833d:	74 24                	je     c0108363 <mm_destroy+0x39>
c010833f:	c7 44 24 0c 95 db 10 	movl   $0xc010db95,0xc(%esp)
c0108346:	c0 
c0108347:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c010834e:	c0 
c010834f:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0108356:	00 
c0108357:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c010835e:	e8 55 8a ff ff       	call   c0100db8 <__panic>

    list_entry_t *list = &(mm->mmap_list), *le;
c0108363:	8b 45 08             	mov    0x8(%ebp),%eax
c0108366:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0108369:	eb 36                	jmp    c01083a1 <mm_destroy+0x77>
c010836b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010836e:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0108371:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108374:	8b 40 04             	mov    0x4(%eax),%eax
c0108377:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010837a:	8b 12                	mov    (%edx),%edx
c010837c:	89 55 e8             	mov    %edx,-0x18(%ebp)
c010837f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0108382:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108385:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108388:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010838b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010838e:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108391:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0108393:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108396:	83 e8 10             	sub    $0x10,%eax
c0108399:	89 04 24             	mov    %eax,(%esp)
c010839c:	e8 34 c9 ff ff       	call   c0104cd5 <kfree>
c01083a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083a4:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01083a7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01083aa:	8b 40 04             	mov    0x4(%eax),%eax
void
mm_destroy(struct mm_struct *mm) {
    assert(mm_count(mm) == 0);

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c01083ad:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01083b3:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01083b6:	75 b3                	jne    c010836b <mm_destroy+0x41>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c01083b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01083bb:	89 04 24             	mov    %eax,(%esp)
c01083be:	e8 12 c9 ff ff       	call   c0104cd5 <kfree>
    mm=NULL;
c01083c3:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c01083ca:	c9                   	leave  
c01083cb:	c3                   	ret    

c01083cc <mm_map>:

int
mm_map(struct mm_struct *mm, uintptr_t addr, size_t len, uint32_t vm_flags,
       struct vma_struct **vma_store) {
c01083cc:	55                   	push   %ebp
c01083cd:	89 e5                	mov    %esp,%ebp
c01083cf:	83 ec 38             	sub    $0x38,%esp
    uintptr_t start = ROUNDDOWN(addr, PGSIZE), end = ROUNDUP(addr + len, PGSIZE);
c01083d2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083d5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01083d8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01083db:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01083e0:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01083e3:	c7 45 e8 00 10 00 00 	movl   $0x1000,-0x18(%ebp)
c01083ea:	8b 45 10             	mov    0x10(%ebp),%eax
c01083ed:	8b 55 0c             	mov    0xc(%ebp),%edx
c01083f0:	01 d0                	add    %edx,%eax
c01083f2:	03 45 e8             	add    -0x18(%ebp),%eax
c01083f5:	83 e8 01             	sub    $0x1,%eax
c01083f8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01083fb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01083fe:	ba 00 00 00 00       	mov    $0x0,%edx
c0108403:	f7 75 e8             	divl   -0x18(%ebp)
c0108406:	89 d0                	mov    %edx,%eax
c0108408:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010840b:	89 d1                	mov    %edx,%ecx
c010840d:	29 c1                	sub    %eax,%ecx
c010840f:	89 c8                	mov    %ecx,%eax
c0108411:	89 45 e0             	mov    %eax,-0x20(%ebp)
    if (!USER_ACCESS(start, end)) {
c0108414:	81 7d ec ff ff 1f 00 	cmpl   $0x1fffff,-0x14(%ebp)
c010841b:	76 11                	jbe    c010842e <mm_map+0x62>
c010841d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108420:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108423:	73 09                	jae    c010842e <mm_map+0x62>
c0108425:	81 7d e0 00 00 00 b0 	cmpl   $0xb0000000,-0x20(%ebp)
c010842c:	76 0a                	jbe    c0108438 <mm_map+0x6c>
        return -E_INVAL;
c010842e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108433:	e9 b0 00 00 00       	jmp    c01084e8 <mm_map+0x11c>
    }

    assert(mm != NULL);
c0108438:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010843c:	75 24                	jne    c0108462 <mm_map+0x96>
c010843e:	c7 44 24 0c a7 db 10 	movl   $0xc010dba7,0xc(%esp)
c0108445:	c0 
c0108446:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c010844d:	c0 
c010844e:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0108455:	00 
c0108456:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c010845d:	e8 56 89 ff ff       	call   c0100db8 <__panic>

    int ret = -E_INVAL;
c0108462:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
c0108469:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010846c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108470:	8b 45 08             	mov    0x8(%ebp),%eax
c0108473:	89 04 24             	mov    %eax,(%esp)
c0108476:	e8 29 fc ff ff       	call   c01080a4 <find_vma>
c010847b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010847e:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0108482:	74 0b                	je     c010848f <mm_map+0xc3>
c0108484:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108487:	8b 40 04             	mov    0x4(%eax),%eax
c010848a:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c010848d:	72 52                	jb     c01084e1 <mm_map+0x115>
        goto out;
    }
    ret = -E_NO_MEM;
c010848f:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
c0108496:	8b 45 14             	mov    0x14(%ebp),%eax
c0108499:	89 44 24 08          	mov    %eax,0x8(%esp)
c010849d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01084a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01084a7:	89 04 24             	mov    %eax,(%esp)
c01084aa:	e8 ba fb ff ff       	call   c0108069 <vma_create>
c01084af:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01084b2:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01084b6:	74 2c                	je     c01084e4 <mm_map+0x118>
        goto out;
    }
    insert_vma_struct(mm, vma);
c01084b8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01084bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01084bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01084c2:	89 04 24             	mov    %eax,(%esp)
c01084c5:	e8 2f fd ff ff       	call   c01081f9 <insert_vma_struct>
    if (vma_store != NULL) {
c01084ca:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c01084ce:	74 08                	je     c01084d8 <mm_map+0x10c>
        *vma_store = vma;
c01084d0:	8b 45 18             	mov    0x18(%ebp),%eax
c01084d3:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01084d6:	89 10                	mov    %edx,(%eax)
    }
    ret = 0;
c01084d8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01084df:	eb 04                	jmp    c01084e5 <mm_map+0x119>

    int ret = -E_INVAL;

    struct vma_struct *vma;
    if ((vma = find_vma(mm, start)) != NULL && end > vma->vm_start) {
        goto out;
c01084e1:	90                   	nop
c01084e2:	eb 01                	jmp    c01084e5 <mm_map+0x119>
    }
    ret = -E_NO_MEM;

    if ((vma = vma_create(start, end, vm_flags)) == NULL) {
        goto out;
c01084e4:	90                   	nop
        *vma_store = vma;
    }
    ret = 0;

out:
    return ret;
c01084e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01084e8:	c9                   	leave  
c01084e9:	c3                   	ret    

c01084ea <dup_mmap>:

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
c01084ea:	55                   	push   %ebp
c01084eb:	89 e5                	mov    %esp,%ebp
c01084ed:	56                   	push   %esi
c01084ee:	53                   	push   %ebx
c01084ef:	83 ec 40             	sub    $0x40,%esp
    assert(to != NULL && from != NULL);
c01084f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01084f6:	74 06                	je     c01084fe <dup_mmap+0x14>
c01084f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01084fc:	75 24                	jne    c0108522 <dup_mmap+0x38>
c01084fe:	c7 44 24 0c b2 db 10 	movl   $0xc010dbb2,0xc(%esp)
c0108505:	c0 
c0108506:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c010850d:	c0 
c010850e:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c0108515:	00 
c0108516:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c010851d:	e8 96 88 ff ff       	call   c0100db8 <__panic>
    list_entry_t *list = &(from->mmap_list), *le = list;
c0108522:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108525:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108528:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010852b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_prev(le)) != list) {
c010852e:	e9 92 00 00 00       	jmp    c01085c5 <dup_mmap+0xdb>
        struct vma_struct *vma, *nvma;
        vma = le2vma(le, list_link);
c0108533:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108536:	83 e8 10             	sub    $0x10,%eax
c0108539:	89 45 ec             	mov    %eax,-0x14(%ebp)
        nvma = vma_create(vma->vm_start, vma->vm_end, vma->vm_flags);
c010853c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010853f:	8b 48 0c             	mov    0xc(%eax),%ecx
c0108542:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108545:	8b 50 08             	mov    0x8(%eax),%edx
c0108548:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010854b:	8b 40 04             	mov    0x4(%eax),%eax
c010854e:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108552:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108556:	89 04 24             	mov    %eax,(%esp)
c0108559:	e8 0b fb ff ff       	call   c0108069 <vma_create>
c010855e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        if (nvma == NULL) {
c0108561:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108565:	75 07                	jne    c010856e <dup_mmap+0x84>
            return -E_NO_MEM;
c0108567:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c010856c:	eb 76                	jmp    c01085e4 <dup_mmap+0xfa>
        }

        insert_vma_struct(to, nvma);
c010856e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108571:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108575:	8b 45 08             	mov    0x8(%ebp),%eax
c0108578:	89 04 24             	mov    %eax,(%esp)
c010857b:	e8 79 fc ff ff       	call   c01081f9 <insert_vma_struct>

        bool share = 0;
c0108580:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
c0108587:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010858a:	8b 58 08             	mov    0x8(%eax),%ebx
c010858d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108590:	8b 48 04             	mov    0x4(%eax),%ecx
c0108593:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108596:	8b 50 0c             	mov    0xc(%eax),%edx
c0108599:	8b 45 08             	mov    0x8(%ebp),%eax
c010859c:	8b 40 0c             	mov    0xc(%eax),%eax
c010859f:	8b 75 e4             	mov    -0x1c(%ebp),%esi
c01085a2:	89 74 24 10          	mov    %esi,0x10(%esp)
c01085a6:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01085aa:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01085ae:	89 54 24 04          	mov    %edx,0x4(%esp)
c01085b2:	89 04 24             	mov    %eax,(%esp)
c01085b5:	e8 dc d6 ff ff       	call   c0105c96 <copy_range>
c01085ba:	85 c0                	test   %eax,%eax
c01085bc:	74 07                	je     c01085c5 <dup_mmap+0xdb>
            return -E_NO_MEM;
c01085be:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01085c3:	eb 1f                	jmp    c01085e4 <dup_mmap+0xfa>
c01085c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085c8:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c01085cb:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01085ce:	8b 00                	mov    (%eax),%eax

int
dup_mmap(struct mm_struct *to, struct mm_struct *from) {
    assert(to != NULL && from != NULL);
    list_entry_t *list = &(from->mmap_list), *le = list;
    while ((le = list_prev(le)) != list) {
c01085d0:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085d3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085d6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01085d9:	0f 85 54 ff ff ff    	jne    c0108533 <dup_mmap+0x49>
        bool share = 0;
        if (copy_range(to->pgdir, from->pgdir, vma->vm_start, vma->vm_end, share) != 0) {
            return -E_NO_MEM;
        }
    }
    return 0;
c01085df:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01085e4:	83 c4 40             	add    $0x40,%esp
c01085e7:	5b                   	pop    %ebx
c01085e8:	5e                   	pop    %esi
c01085e9:	5d                   	pop    %ebp
c01085ea:	c3                   	ret    

c01085eb <exit_mmap>:

void
exit_mmap(struct mm_struct *mm) {
c01085eb:	55                   	push   %ebp
c01085ec:	89 e5                	mov    %esp,%ebp
c01085ee:	83 ec 38             	sub    $0x38,%esp
    assert(mm != NULL && mm_count(mm) == 0);
c01085f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01085f5:	74 0f                	je     c0108606 <exit_mmap+0x1b>
c01085f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01085fa:	89 04 24             	mov    %eax,(%esp)
c01085fd:	e8 58 f9 ff ff       	call   c0107f5a <mm_count>
c0108602:	85 c0                	test   %eax,%eax
c0108604:	74 24                	je     c010862a <exit_mmap+0x3f>
c0108606:	c7 44 24 0c d0 db 10 	movl   $0xc010dbd0,0xc(%esp)
c010860d:	c0 
c010860e:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108615:	c0 
c0108616:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c010861d:	00 
c010861e:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108625:	e8 8e 87 ff ff       	call   c0100db8 <__panic>
    pde_t *pgdir = mm->pgdir;
c010862a:	8b 45 08             	mov    0x8(%ebp),%eax
c010862d:	8b 40 0c             	mov    0xc(%eax),%eax
c0108630:	89 45 f0             	mov    %eax,-0x10(%ebp)
    list_entry_t *list = &(mm->mmap_list), *le = list;
c0108633:	8b 45 08             	mov    0x8(%ebp),%eax
c0108636:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108639:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010863c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(le)) != list) {
c010863f:	eb 28                	jmp    c0108669 <exit_mmap+0x7e>
        struct vma_struct *vma = le2vma(le, list_link);
c0108641:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108644:	83 e8 10             	sub    $0x10,%eax
c0108647:	89 45 e8             	mov    %eax,-0x18(%ebp)
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
c010864a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010864d:	8b 50 08             	mov    0x8(%eax),%edx
c0108650:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108653:	8b 40 04             	mov    0x4(%eax),%eax
c0108656:	89 54 24 08          	mov    %edx,0x8(%esp)
c010865a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010865e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108661:	89 04 24             	mov    %eax,(%esp)
c0108664:	e8 44 d4 ff ff       	call   c0105aad <unmap_range>
c0108669:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010866c:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010866f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108672:	8b 40 04             	mov    0x4(%eax),%eax
void
exit_mmap(struct mm_struct *mm) {
    assert(mm != NULL && mm_count(mm) == 0);
    pde_t *pgdir = mm->pgdir;
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
c0108675:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108678:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010867b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010867e:	75 c1                	jne    c0108641 <exit_mmap+0x56>
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c0108680:	eb 28                	jmp    c01086aa <exit_mmap+0xbf>
        struct vma_struct *vma = le2vma(le, list_link);
c0108682:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108685:	83 e8 10             	sub    $0x10,%eax
c0108688:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        exit_range(pgdir, vma->vm_start, vma->vm_end);
c010868b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010868e:	8b 50 08             	mov    0x8(%eax),%edx
c0108691:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108694:	8b 40 04             	mov    0x4(%eax),%eax
c0108697:	89 54 24 08          	mov    %edx,0x8(%esp)
c010869b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010869f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01086a2:	89 04 24             	mov    %eax,(%esp)
c01086a5:	e8 f7 d4 ff ff       	call   c0105ba1 <exit_range>
c01086aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086ad:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01086b0:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01086b3:	8b 40 04             	mov    0x4(%eax),%eax
    list_entry_t *list = &(mm->mmap_list), *le = list;
    while ((le = list_next(le)) != list) {
        struct vma_struct *vma = le2vma(le, list_link);
        unmap_range(pgdir, vma->vm_start, vma->vm_end);
    }
    while ((le = list_next(le)) != list) {
c01086b6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01086b9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01086bc:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01086bf:	75 c1                	jne    c0108682 <exit_mmap+0x97>
        struct vma_struct *vma = le2vma(le, list_link);
        exit_range(pgdir, vma->vm_start, vma->vm_end);
    }
}
c01086c1:	c9                   	leave  
c01086c2:	c3                   	ret    

c01086c3 <copy_from_user>:

bool
copy_from_user(struct mm_struct *mm, void *dst, const void *src, size_t len, bool writable) {
c01086c3:	55                   	push   %ebp
c01086c4:	89 e5                	mov    %esp,%ebp
c01086c6:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)src, len, writable)) {
c01086c9:	8b 45 10             	mov    0x10(%ebp),%eax
c01086cc:	8b 55 18             	mov    0x18(%ebp),%edx
c01086cf:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01086d3:	8b 55 14             	mov    0x14(%ebp),%edx
c01086d6:	89 54 24 08          	mov    %edx,0x8(%esp)
c01086da:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086de:	8b 45 08             	mov    0x8(%ebp),%eax
c01086e1:	89 04 24             	mov    %eax,(%esp)
c01086e4:	e8 c0 09 00 00       	call   c01090a9 <user_mem_check>
c01086e9:	85 c0                	test   %eax,%eax
c01086eb:	75 07                	jne    c01086f4 <copy_from_user+0x31>
        return 0;
c01086ed:	b8 00 00 00 00       	mov    $0x0,%eax
c01086f2:	eb 1e                	jmp    c0108712 <copy_from_user+0x4f>
    }
    memcpy(dst, src, len);
c01086f4:	8b 45 14             	mov    0x14(%ebp),%eax
c01086f7:	89 44 24 08          	mov    %eax,0x8(%esp)
c01086fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01086fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108705:	89 04 24             	mov    %eax,(%esp)
c0108708:	e8 79 38 00 00       	call   c010bf86 <memcpy>
    return 1;
c010870d:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0108712:	c9                   	leave  
c0108713:	c3                   	ret    

c0108714 <copy_to_user>:

bool
copy_to_user(struct mm_struct *mm, void *dst, const void *src, size_t len) {
c0108714:	55                   	push   %ebp
c0108715:	89 e5                	mov    %esp,%ebp
c0108717:	83 ec 18             	sub    $0x18,%esp
    if (!user_mem_check(mm, (uintptr_t)dst, len, 1)) {
c010871a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010871d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108724:	00 
c0108725:	8b 55 14             	mov    0x14(%ebp),%edx
c0108728:	89 54 24 08          	mov    %edx,0x8(%esp)
c010872c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108730:	8b 45 08             	mov    0x8(%ebp),%eax
c0108733:	89 04 24             	mov    %eax,(%esp)
c0108736:	e8 6e 09 00 00       	call   c01090a9 <user_mem_check>
c010873b:	85 c0                	test   %eax,%eax
c010873d:	75 07                	jne    c0108746 <copy_to_user+0x32>
        return 0;
c010873f:	b8 00 00 00 00       	mov    $0x0,%eax
c0108744:	eb 1e                	jmp    c0108764 <copy_to_user+0x50>
    }
    memcpy(dst, src, len);
c0108746:	8b 45 14             	mov    0x14(%ebp),%eax
c0108749:	89 44 24 08          	mov    %eax,0x8(%esp)
c010874d:	8b 45 10             	mov    0x10(%ebp),%eax
c0108750:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108754:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108757:	89 04 24             	mov    %eax,(%esp)
c010875a:	e8 27 38 00 00       	call   c010bf86 <memcpy>
    return 1;
c010875f:	b8 01 00 00 00       	mov    $0x1,%eax
}
c0108764:	c9                   	leave  
c0108765:	c3                   	ret    

c0108766 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0108766:	55                   	push   %ebp
c0108767:	89 e5                	mov    %esp,%ebp
c0108769:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c010876c:	e8 02 00 00 00       	call   c0108773 <check_vmm>
}
c0108771:	c9                   	leave  
c0108772:	c3                   	ret    

c0108773 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0108773:	55                   	push   %ebp
c0108774:	89 e5                	mov    %esp,%ebp
c0108776:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108779:	e8 60 ca ff ff       	call   c01051de <nr_free_pages>
c010877e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0108781:	e8 13 00 00 00       	call   c0108799 <check_vma_struct>
    check_pgfault();
c0108786:	e8 a7 04 00 00       	call   c0108c32 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c010878b:	c7 04 24 f0 db 10 c0 	movl   $0xc010dbf0,(%esp)
c0108792:	e8 c8 7b ff ff       	call   c010035f <cprintf>
}
c0108797:	c9                   	leave  
c0108798:	c3                   	ret    

c0108799 <check_vma_struct>:

static void
check_vma_struct(void) {
c0108799:	55                   	push   %ebp
c010879a:	89 e5                	mov    %esp,%ebp
c010879c:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010879f:	e8 3a ca ff ff       	call   c01051de <nr_free_pages>
c01087a4:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c01087a7:	e8 24 f8 ff ff       	call   c0107fd0 <mm_create>
c01087ac:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c01087af:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01087b3:	75 24                	jne    c01087d9 <check_vma_struct+0x40>
c01087b5:	c7 44 24 0c a7 db 10 	movl   $0xc010dba7,0xc(%esp)
c01087bc:	c0 
c01087bd:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c01087c4:	c0 
c01087c5:	c7 44 24 04 0c 01 00 	movl   $0x10c,0x4(%esp)
c01087cc:	00 
c01087cd:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c01087d4:	e8 df 85 ff ff       	call   c0100db8 <__panic>

    int step1 = 10, step2 = step1 * 10;
c01087d9:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c01087e0:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01087e3:	89 d0                	mov    %edx,%eax
c01087e5:	c1 e0 02             	shl    $0x2,%eax
c01087e8:	01 d0                	add    %edx,%eax
c01087ea:	01 c0                	add    %eax,%eax
c01087ec:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c01087ef:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01087f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01087f5:	eb 70                	jmp    c0108867 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01087f7:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01087fa:	89 d0                	mov    %edx,%eax
c01087fc:	c1 e0 02             	shl    $0x2,%eax
c01087ff:	01 d0                	add    %edx,%eax
c0108801:	83 c0 02             	add    $0x2,%eax
c0108804:	89 c1                	mov    %eax,%ecx
c0108806:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108809:	89 d0                	mov    %edx,%eax
c010880b:	c1 e0 02             	shl    $0x2,%eax
c010880e:	01 d0                	add    %edx,%eax
c0108810:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108817:	00 
c0108818:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010881c:	89 04 24             	mov    %eax,(%esp)
c010881f:	e8 45 f8 ff ff       	call   c0108069 <vma_create>
c0108824:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0108827:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010882b:	75 24                	jne    c0108851 <check_vma_struct+0xb8>
c010882d:	c7 44 24 0c 08 dc 10 	movl   $0xc010dc08,0xc(%esp)
c0108834:	c0 
c0108835:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c010883c:	c0 
c010883d:	c7 44 24 04 13 01 00 	movl   $0x113,0x4(%esp)
c0108844:	00 
c0108845:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c010884c:	e8 67 85 ff ff       	call   c0100db8 <__panic>
        insert_vma_struct(mm, vma);
c0108851:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108854:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108858:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010885b:	89 04 24             	mov    %eax,(%esp)
c010885e:	e8 96 f9 ff ff       	call   c01081f9 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0108863:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0108867:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010886b:	7f 8a                	jg     c01087f7 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c010886d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108870:	83 c0 01             	add    $0x1,%eax
c0108873:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108876:	eb 70                	jmp    c01088e8 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0108878:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010887b:	89 d0                	mov    %edx,%eax
c010887d:	c1 e0 02             	shl    $0x2,%eax
c0108880:	01 d0                	add    %edx,%eax
c0108882:	83 c0 02             	add    $0x2,%eax
c0108885:	89 c1                	mov    %eax,%ecx
c0108887:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010888a:	89 d0                	mov    %edx,%eax
c010888c:	c1 e0 02             	shl    $0x2,%eax
c010888f:	01 d0                	add    %edx,%eax
c0108891:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0108898:	00 
c0108899:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010889d:	89 04 24             	mov    %eax,(%esp)
c01088a0:	e8 c4 f7 ff ff       	call   c0108069 <vma_create>
c01088a5:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c01088a8:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c01088ac:	75 24                	jne    c01088d2 <check_vma_struct+0x139>
c01088ae:	c7 44 24 0c 08 dc 10 	movl   $0xc010dc08,0xc(%esp)
c01088b5:	c0 
c01088b6:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c01088bd:	c0 
c01088be:	c7 44 24 04 19 01 00 	movl   $0x119,0x4(%esp)
c01088c5:	00 
c01088c6:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c01088cd:	e8 e6 84 ff ff       	call   c0100db8 <__panic>
        insert_vma_struct(mm, vma);
c01088d2:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01088d5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01088d9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088dc:	89 04 24             	mov    %eax,(%esp)
c01088df:	e8 15 f9 ff ff       	call   c01081f9 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01088e4:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01088e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088eb:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01088ee:	7e 88                	jle    c0108878 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c01088f0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01088f3:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01088f6:	8b 45 b8             	mov    -0x48(%ebp),%eax
c01088f9:	8b 40 04             	mov    0x4(%eax),%eax
c01088fc:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c01088ff:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0108906:	e9 97 00 00 00       	jmp    c01089a2 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c010890b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010890e:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108911:	75 24                	jne    c0108937 <check_vma_struct+0x19e>
c0108913:	c7 44 24 0c 14 dc 10 	movl   $0xc010dc14,0xc(%esp)
c010891a:	c0 
c010891b:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108922:	c0 
c0108923:	c7 44 24 04 20 01 00 	movl   $0x120,0x4(%esp)
c010892a:	00 
c010892b:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108932:	e8 81 84 ff ff       	call   c0100db8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0108937:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010893a:	83 e8 10             	sub    $0x10,%eax
c010893d:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0108940:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108943:	8b 48 04             	mov    0x4(%eax),%ecx
c0108946:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108949:	89 d0                	mov    %edx,%eax
c010894b:	c1 e0 02             	shl    $0x2,%eax
c010894e:	01 d0                	add    %edx,%eax
c0108950:	39 c1                	cmp    %eax,%ecx
c0108952:	75 17                	jne    c010896b <check_vma_struct+0x1d2>
c0108954:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108957:	8b 48 08             	mov    0x8(%eax),%ecx
c010895a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010895d:	89 d0                	mov    %edx,%eax
c010895f:	c1 e0 02             	shl    $0x2,%eax
c0108962:	01 d0                	add    %edx,%eax
c0108964:	83 c0 02             	add    $0x2,%eax
c0108967:	39 c1                	cmp    %eax,%ecx
c0108969:	74 24                	je     c010898f <check_vma_struct+0x1f6>
c010896b:	c7 44 24 0c 2c dc 10 	movl   $0xc010dc2c,0xc(%esp)
c0108972:	c0 
c0108973:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c010897a:	c0 
c010897b:	c7 44 24 04 22 01 00 	movl   $0x122,0x4(%esp)
c0108982:	00 
c0108983:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c010898a:	e8 29 84 ff ff       	call   c0100db8 <__panic>
c010898f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108992:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0108995:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0108998:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c010899b:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c010899e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01089a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089a5:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c01089a8:	0f 8e 5d ff ff ff    	jle    c010890b <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c01089ae:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c01089b5:	e9 cd 01 00 00       	jmp    c0108b87 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c01089ba:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089bd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01089c4:	89 04 24             	mov    %eax,(%esp)
c01089c7:	e8 d8 f6 ff ff       	call   c01080a4 <find_vma>
c01089cc:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c01089cf:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c01089d3:	75 24                	jne    c01089f9 <check_vma_struct+0x260>
c01089d5:	c7 44 24 0c 61 dc 10 	movl   $0xc010dc61,0xc(%esp)
c01089dc:	c0 
c01089dd:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c01089e4:	c0 
c01089e5:	c7 44 24 04 28 01 00 	movl   $0x128,0x4(%esp)
c01089ec:	00 
c01089ed:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c01089f4:	e8 bf 83 ff ff       	call   c0100db8 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c01089f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01089fc:	83 c0 01             	add    $0x1,%eax
c01089ff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a03:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a06:	89 04 24             	mov    %eax,(%esp)
c0108a09:	e8 96 f6 ff ff       	call   c01080a4 <find_vma>
c0108a0e:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0108a11:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0108a15:	75 24                	jne    c0108a3b <check_vma_struct+0x2a2>
c0108a17:	c7 44 24 0c 6e dc 10 	movl   $0xc010dc6e,0xc(%esp)
c0108a1e:	c0 
c0108a1f:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108a26:	c0 
c0108a27:	c7 44 24 04 2a 01 00 	movl   $0x12a,0x4(%esp)
c0108a2e:	00 
c0108a2f:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108a36:	e8 7d 83 ff ff       	call   c0100db8 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0108a3b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a3e:	83 c0 02             	add    $0x2,%eax
c0108a41:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a45:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a48:	89 04 24             	mov    %eax,(%esp)
c0108a4b:	e8 54 f6 ff ff       	call   c01080a4 <find_vma>
c0108a50:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0108a53:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0108a57:	74 24                	je     c0108a7d <check_vma_struct+0x2e4>
c0108a59:	c7 44 24 0c 7b dc 10 	movl   $0xc010dc7b,0xc(%esp)
c0108a60:	c0 
c0108a61:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108a68:	c0 
c0108a69:	c7 44 24 04 2c 01 00 	movl   $0x12c,0x4(%esp)
c0108a70:	00 
c0108a71:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108a78:	e8 3b 83 ff ff       	call   c0100db8 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0108a7d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a80:	83 c0 03             	add    $0x3,%eax
c0108a83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108a87:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108a8a:	89 04 24             	mov    %eax,(%esp)
c0108a8d:	e8 12 f6 ff ff       	call   c01080a4 <find_vma>
c0108a92:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0108a95:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0108a99:	74 24                	je     c0108abf <check_vma_struct+0x326>
c0108a9b:	c7 44 24 0c 88 dc 10 	movl   $0xc010dc88,0xc(%esp)
c0108aa2:	c0 
c0108aa3:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108aaa:	c0 
c0108aab:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0108ab2:	00 
c0108ab3:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108aba:	e8 f9 82 ff ff       	call   c0100db8 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0108abf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ac2:	83 c0 04             	add    $0x4,%eax
c0108ac5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ac9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108acc:	89 04 24             	mov    %eax,(%esp)
c0108acf:	e8 d0 f5 ff ff       	call   c01080a4 <find_vma>
c0108ad4:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0108ad7:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0108adb:	74 24                	je     c0108b01 <check_vma_struct+0x368>
c0108add:	c7 44 24 0c 95 dc 10 	movl   $0xc010dc95,0xc(%esp)
c0108ae4:	c0 
c0108ae5:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108aec:	c0 
c0108aed:	c7 44 24 04 30 01 00 	movl   $0x130,0x4(%esp)
c0108af4:	00 
c0108af5:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108afc:	e8 b7 82 ff ff       	call   c0100db8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0108b01:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108b04:	8b 50 04             	mov    0x4(%eax),%edx
c0108b07:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b0a:	39 c2                	cmp    %eax,%edx
c0108b0c:	75 10                	jne    c0108b1e <check_vma_struct+0x385>
c0108b0e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108b11:	8b 50 08             	mov    0x8(%eax),%edx
c0108b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b17:	83 c0 02             	add    $0x2,%eax
c0108b1a:	39 c2                	cmp    %eax,%edx
c0108b1c:	74 24                	je     c0108b42 <check_vma_struct+0x3a9>
c0108b1e:	c7 44 24 0c a4 dc 10 	movl   $0xc010dca4,0xc(%esp)
c0108b25:	c0 
c0108b26:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108b2d:	c0 
c0108b2e:	c7 44 24 04 32 01 00 	movl   $0x132,0x4(%esp)
c0108b35:	00 
c0108b36:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108b3d:	e8 76 82 ff ff       	call   c0100db8 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0108b42:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108b45:	8b 50 04             	mov    0x4(%eax),%edx
c0108b48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b4b:	39 c2                	cmp    %eax,%edx
c0108b4d:	75 10                	jne    c0108b5f <check_vma_struct+0x3c6>
c0108b4f:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108b52:	8b 50 08             	mov    0x8(%eax),%edx
c0108b55:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b58:	83 c0 02             	add    $0x2,%eax
c0108b5b:	39 c2                	cmp    %eax,%edx
c0108b5d:	74 24                	je     c0108b83 <check_vma_struct+0x3ea>
c0108b5f:	c7 44 24 0c d4 dc 10 	movl   $0xc010dcd4,0xc(%esp)
c0108b66:	c0 
c0108b67:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108b6e:	c0 
c0108b6f:	c7 44 24 04 33 01 00 	movl   $0x133,0x4(%esp)
c0108b76:	00 
c0108b77:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108b7e:	e8 35 82 ff ff       	call   c0100db8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0108b83:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0108b87:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108b8a:	89 d0                	mov    %edx,%eax
c0108b8c:	c1 e0 02             	shl    $0x2,%eax
c0108b8f:	01 d0                	add    %edx,%eax
c0108b91:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0108b94:	0f 8d 20 fe ff ff    	jge    c01089ba <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0108b9a:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0108ba1:	eb 70                	jmp    c0108c13 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0108ba3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108baa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108bad:	89 04 24             	mov    %eax,(%esp)
c0108bb0:	e8 ef f4 ff ff       	call   c01080a4 <find_vma>
c0108bb5:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0108bb8:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0108bbc:	74 27                	je     c0108be5 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0108bbe:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108bc1:	8b 50 08             	mov    0x8(%eax),%edx
c0108bc4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0108bc7:	8b 40 04             	mov    0x4(%eax),%eax
c0108bca:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108bce:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108bd2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108bd5:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108bd9:	c7 04 24 04 dd 10 c0 	movl   $0xc010dd04,(%esp)
c0108be0:	e8 7a 77 ff ff       	call   c010035f <cprintf>
        }
        assert(vma_below_5 == NULL);
c0108be5:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0108be9:	74 24                	je     c0108c0f <check_vma_struct+0x476>
c0108beb:	c7 44 24 0c 29 dd 10 	movl   $0xc010dd29,0xc(%esp)
c0108bf2:	c0 
c0108bf3:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108bfa:	c0 
c0108bfb:	c7 44 24 04 3b 01 00 	movl   $0x13b,0x4(%esp)
c0108c02:	00 
c0108c03:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108c0a:	e8 a9 81 ff ff       	call   c0100db8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0108c0f:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0108c13:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108c17:	79 8a                	jns    c0108ba3 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0108c19:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c1c:	89 04 24             	mov    %eax,(%esp)
c0108c1f:	e8 06 f7 ff ff       	call   c010832a <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0108c24:	c7 04 24 40 dd 10 c0 	movl   $0xc010dd40,(%esp)
c0108c2b:	e8 2f 77 ff ff       	call   c010035f <cprintf>
}
c0108c30:	c9                   	leave  
c0108c31:	c3                   	ret    

c0108c32 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0108c32:	55                   	push   %ebp
c0108c33:	89 e5                	mov    %esp,%ebp
c0108c35:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108c38:	e8 a1 c5 ff ff       	call   c01051de <nr_free_pages>
c0108c3d:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0108c40:	e8 8b f3 ff ff       	call   c0107fd0 <mm_create>
c0108c45:	a3 ac ef 19 c0       	mov    %eax,0xc019efac
    assert(check_mm_struct != NULL);
c0108c4a:	a1 ac ef 19 c0       	mov    0xc019efac,%eax
c0108c4f:	85 c0                	test   %eax,%eax
c0108c51:	75 24                	jne    c0108c77 <check_pgfault+0x45>
c0108c53:	c7 44 24 0c 5f dd 10 	movl   $0xc010dd5f,0xc(%esp)
c0108c5a:	c0 
c0108c5b:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108c62:	c0 
c0108c63:	c7 44 24 04 4b 01 00 	movl   $0x14b,0x4(%esp)
c0108c6a:	00 
c0108c6b:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108c72:	e8 41 81 ff ff       	call   c0100db8 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0108c77:	a1 ac ef 19 c0       	mov    0xc019efac,%eax
c0108c7c:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0108c7f:	8b 15 e4 cd 19 c0    	mov    0xc019cde4,%edx
c0108c85:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c88:	89 50 0c             	mov    %edx,0xc(%eax)
c0108c8b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c8e:	8b 40 0c             	mov    0xc(%eax),%eax
c0108c91:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0108c94:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c97:	8b 00                	mov    (%eax),%eax
c0108c99:	85 c0                	test   %eax,%eax
c0108c9b:	74 24                	je     c0108cc1 <check_pgfault+0x8f>
c0108c9d:	c7 44 24 0c 77 dd 10 	movl   $0xc010dd77,0xc(%esp)
c0108ca4:	c0 
c0108ca5:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108cac:	c0 
c0108cad:	c7 44 24 04 4f 01 00 	movl   $0x14f,0x4(%esp)
c0108cb4:	00 
c0108cb5:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108cbc:	e8 f7 80 ff ff       	call   c0100db8 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0108cc1:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0108cc8:	00 
c0108cc9:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0108cd0:	00 
c0108cd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0108cd8:	e8 8c f3 ff ff       	call   c0108069 <vma_create>
c0108cdd:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0108ce0:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108ce4:	75 24                	jne    c0108d0a <check_pgfault+0xd8>
c0108ce6:	c7 44 24 0c 08 dc 10 	movl   $0xc010dc08,0xc(%esp)
c0108ced:	c0 
c0108cee:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108cf5:	c0 
c0108cf6:	c7 44 24 04 52 01 00 	movl   $0x152,0x4(%esp)
c0108cfd:	00 
c0108cfe:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108d05:	e8 ae 80 ff ff       	call   c0100db8 <__panic>

    insert_vma_struct(mm, vma);
c0108d0a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108d0d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d11:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d14:	89 04 24             	mov    %eax,(%esp)
c0108d17:	e8 dd f4 ff ff       	call   c01081f9 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0108d1c:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0108d23:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108d26:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108d2a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d2d:	89 04 24             	mov    %eax,(%esp)
c0108d30:	e8 6f f3 ff ff       	call   c01080a4 <find_vma>
c0108d35:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108d38:	74 24                	je     c0108d5e <check_pgfault+0x12c>
c0108d3a:	c7 44 24 0c 85 dd 10 	movl   $0xc010dd85,0xc(%esp)
c0108d41:	c0 
c0108d42:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108d49:	c0 
c0108d4a:	c7 44 24 04 57 01 00 	movl   $0x157,0x4(%esp)
c0108d51:	00 
c0108d52:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108d59:	e8 5a 80 ff ff       	call   c0100db8 <__panic>

    int i, sum = 0;
c0108d5e:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108d65:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108d6c:	eb 15                	jmp    c0108d83 <check_pgfault+0x151>
        *(char *)(addr + i) = i;
c0108d6e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d71:	03 45 dc             	add    -0x24(%ebp),%eax
c0108d74:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108d77:	88 10                	mov    %dl,(%eax)
        sum += i;
c0108d79:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d7c:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0108d7f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108d83:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108d87:	7e e5                	jle    c0108d6e <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108d89:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0108d90:	eb 13                	jmp    c0108da5 <check_pgfault+0x173>
        sum -= *(char *)(addr + i);
c0108d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d95:	03 45 dc             	add    -0x24(%ebp),%eax
c0108d98:	0f b6 00             	movzbl (%eax),%eax
c0108d9b:	0f be c0             	movsbl %al,%eax
c0108d9e:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108da1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108da5:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108da9:	7e e7                	jle    c0108d92 <check_pgfault+0x160>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0108dab:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108daf:	74 24                	je     c0108dd5 <check_pgfault+0x1a3>
c0108db1:	c7 44 24 0c 9f dd 10 	movl   $0xc010dd9f,0xc(%esp)
c0108db8:	c0 
c0108db9:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108dc0:	c0 
c0108dc1:	c7 44 24 04 61 01 00 	movl   $0x161,0x4(%esp)
c0108dc8:	00 
c0108dc9:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108dd0:	e8 e3 7f ff ff       	call   c0100db8 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0108dd5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108dd8:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0108ddb:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0108dde:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108de3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108de7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108dea:	89 04 24             	mov    %eax,(%esp)
c0108ded:	e8 c7 d0 ff ff       	call   c0105eb9 <page_remove>
    free_page(pde2page(pgdir[0]));
c0108df2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108df5:	8b 00                	mov    (%eax),%eax
c0108df7:	89 04 24             	mov    %eax,(%esp)
c0108dfa:	e8 b9 f1 ff ff       	call   c0107fb8 <pde2page>
c0108dff:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108e06:	00 
c0108e07:	89 04 24             	mov    %eax,(%esp)
c0108e0a:	e8 9d c3 ff ff       	call   c01051ac <free_pages>
    pgdir[0] = 0;
c0108e0f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108e12:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108e18:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108e1b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0108e22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108e25:	89 04 24             	mov    %eax,(%esp)
c0108e28:	e8 fd f4 ff ff       	call   c010832a <mm_destroy>
    check_mm_struct = NULL;
c0108e2d:	c7 05 ac ef 19 c0 00 	movl   $0x0,0xc019efac
c0108e34:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108e37:	e8 a2 c3 ff ff       	call   c01051de <nr_free_pages>
c0108e3c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108e3f:	74 24                	je     c0108e65 <check_pgfault+0x233>
c0108e41:	c7 44 24 0c a8 dd 10 	movl   $0xc010dda8,0xc(%esp)
c0108e48:	c0 
c0108e49:	c7 44 24 08 17 db 10 	movl   $0xc010db17,0x8(%esp)
c0108e50:	c0 
c0108e51:	c7 44 24 04 6b 01 00 	movl   $0x16b,0x4(%esp)
c0108e58:	00 
c0108e59:	c7 04 24 2c db 10 c0 	movl   $0xc010db2c,(%esp)
c0108e60:	e8 53 7f ff ff       	call   c0100db8 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108e65:	c7 04 24 cf dd 10 c0 	movl   $0xc010ddcf,(%esp)
c0108e6c:	e8 ee 74 ff ff       	call   c010035f <cprintf>
}
c0108e71:	c9                   	leave  
c0108e72:	c3                   	ret    

c0108e73 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108e73:	55                   	push   %ebp
c0108e74:	89 e5                	mov    %esp,%ebp
c0108e76:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108e79:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0108e80:	8b 45 10             	mov    0x10(%ebp),%eax
c0108e83:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108e87:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e8a:	89 04 24             	mov    %eax,(%esp)
c0108e8d:	e8 12 f2 ff ff       	call   c01080a4 <find_vma>
c0108e92:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0108e95:	a1 78 ce 19 c0       	mov    0xc019ce78,%eax
c0108e9a:	83 c0 01             	add    $0x1,%eax
c0108e9d:	a3 78 ce 19 c0       	mov    %eax,0xc019ce78
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0108ea2:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108ea6:	74 0b                	je     c0108eb3 <do_pgfault+0x40>
c0108ea8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108eab:	8b 40 04             	mov    0x4(%eax),%eax
c0108eae:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108eb1:	76 18                	jbe    c0108ecb <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0108eb3:	8b 45 10             	mov    0x10(%ebp),%eax
c0108eb6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108eba:	c7 04 24 ec dd 10 c0 	movl   $0xc010ddec,(%esp)
c0108ec1:	e8 99 74 ff ff       	call   c010035f <cprintf>
        goto failed;
c0108ec6:	e9 d9 01 00 00       	jmp    c01090a4 <do_pgfault+0x231>
    }
    //check the error_code
    switch (error_code & 3) {
c0108ecb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ece:	83 e0 03             	and    $0x3,%eax
c0108ed1:	85 c0                	test   %eax,%eax
c0108ed3:	74 34                	je     c0108f09 <do_pgfault+0x96>
c0108ed5:	83 f8 01             	cmp    $0x1,%eax
c0108ed8:	74 1e                	je     c0108ef8 <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0108eda:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108edd:	8b 40 0c             	mov    0xc(%eax),%eax
c0108ee0:	83 e0 02             	and    $0x2,%eax
c0108ee3:	85 c0                	test   %eax,%eax
c0108ee5:	75 40                	jne    c0108f27 <do_pgfault+0xb4>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0108ee7:	c7 04 24 1c de 10 c0 	movl   $0xc010de1c,(%esp)
c0108eee:	e8 6c 74 ff ff       	call   c010035f <cprintf>
            goto failed;
c0108ef3:	e9 ac 01 00 00       	jmp    c01090a4 <do_pgfault+0x231>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108ef8:	c7 04 24 7c de 10 c0 	movl   $0xc010de7c,(%esp)
c0108eff:	e8 5b 74 ff ff       	call   c010035f <cprintf>
        goto failed;
c0108f04:	e9 9b 01 00 00       	jmp    c01090a4 <do_pgfault+0x231>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108f09:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108f0c:	8b 40 0c             	mov    0xc(%eax),%eax
c0108f0f:	83 e0 05             	and    $0x5,%eax
c0108f12:	85 c0                	test   %eax,%eax
c0108f14:	75 12                	jne    c0108f28 <do_pgfault+0xb5>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108f16:	c7 04 24 b4 de 10 c0 	movl   $0xc010deb4,(%esp)
c0108f1d:	e8 3d 74 ff ff       	call   c010035f <cprintf>
            goto failed;
c0108f22:	e9 7d 01 00 00       	jmp    c01090a4 <do_pgfault+0x231>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c0108f27:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108f28:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0108f2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108f32:	8b 40 0c             	mov    0xc(%eax),%eax
c0108f35:	83 e0 02             	and    $0x2,%eax
c0108f38:	85 c0                	test   %eax,%eax
c0108f3a:	74 04                	je     c0108f40 <do_pgfault+0xcd>
        perm |= PTE_W;
c0108f3c:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0108f40:	8b 45 10             	mov    0x10(%ebp),%eax
c0108f43:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108f46:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108f49:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0108f4e:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108f51:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108f58:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
          ptep = get_pte(mm->pgdir, addr, 1);
c0108f5f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108f62:	8b 40 0c             	mov    0xc(%eax),%eax
c0108f65:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0108f6c:	00 
c0108f6d:	8b 55 10             	mov    0x10(%ebp),%edx
c0108f70:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108f74:	89 04 24             	mov    %eax,(%esp)
c0108f77:	e8 2b c9 ff ff       	call   c01058a7 <get_pte>
c0108f7c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (ptep == NULL) {
c0108f7f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108f83:	75 11                	jne    c0108f96 <do_pgfault+0x123>
        cprintf("get_pte in do_pgfault failed\n");
c0108f85:	c7 04 24 17 df 10 c0 	movl   $0xc010df17,(%esp)
c0108f8c:	e8 ce 73 ff ff       	call   c010035f <cprintf>
        goto failed;
c0108f91:	e9 0e 01 00 00       	jmp    c01090a4 <do_pgfault+0x231>
    }

    if (*ptep == 0) {
c0108f96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f99:	8b 00                	mov    (%eax),%eax
c0108f9b:	85 c0                	test   %eax,%eax
c0108f9d:	75 3a                	jne    c0108fd9 <do_pgfault+0x166>
        struct Page* page = pgdir_alloc_page(mm->pgdir, addr, perm);
c0108f9f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108fa2:	8b 40 0c             	mov    0xc(%eax),%eax
c0108fa5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108fa8:	89 54 24 08          	mov    %edx,0x8(%esp)
c0108fac:	8b 55 10             	mov    0x10(%ebp),%edx
c0108faf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108fb3:	89 04 24             	mov    %eax,(%esp)
c0108fb6:	e8 5d d0 ff ff       	call   c0106018 <pgdir_alloc_page>
c0108fbb:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if (page == NULL) {
c0108fbe:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0108fc2:	0f 85 d5 00 00 00    	jne    c010909d <do_pgfault+0x22a>
            cprintf("pgdir_alloc_page in do_pgfault failed\n");
c0108fc8:	c7 04 24 38 df 10 c0 	movl   $0xc010df38,(%esp)
c0108fcf:	e8 8b 73 ff ff       	call   c010035f <cprintf>
            goto failed;
c0108fd4:	e9 cb 00 00 00       	jmp    c01090a4 <do_pgfault+0x231>
        }
    }

    else {
        if(swap_init_ok) {
c0108fd9:	a1 6c ce 19 c0       	mov    0xc019ce6c,%eax
c0108fde:	85 c0                	test   %eax,%eax
c0108fe0:	0f 84 a0 00 00 00    	je     c0109086 <do_pgfault+0x213>
            struct Page *page = NULL;
c0108fe6:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
            ret = swap_in(mm, addr, &page);
c0108fed:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0108ff0:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108ff4:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ff7:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ffb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ffe:	89 04 24             	mov    %eax,(%esp)
c0109001:	e8 be e0 ff ff       	call   c01070c4 <swap_in>
c0109006:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0109009:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010900d:	74 11                	je     c0109020 <do_pgfault+0x1ad>
                cprintf("swap_in in do_pgfault failed\n");
c010900f:	c7 04 24 5f df 10 c0 	movl   $0xc010df5f,(%esp)
c0109016:	e8 44 73 ff ff       	call   c010035f <cprintf>
                goto failed;
c010901b:	e9 84 00 00 00       	jmp    c01090a4 <do_pgfault+0x231>
            }
            ret = page_insert(mm->pgdir, page, addr, perm);
c0109020:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0109023:	8b 45 08             	mov    0x8(%ebp),%eax
c0109026:	8b 40 0c             	mov    0xc(%eax),%eax
c0109029:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010902c:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0109030:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0109033:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0109037:	89 54 24 04          	mov    %edx,0x4(%esp)
c010903b:	89 04 24             	mov    %eax,(%esp)
c010903e:	e8 ba ce ff ff       	call   c0105efd <page_insert>
c0109043:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0109046:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010904a:	74 0e                	je     c010905a <do_pgfault+0x1e7>
                cprintf("page_insert in do_pgfault failed\n");
c010904c:	c7 04 24 80 df 10 c0 	movl   $0xc010df80,(%esp)
c0109053:	e8 07 73 ff ff       	call   c010035f <cprintf>
                goto failed;
c0109058:	eb 4a                	jmp    c01090a4 <do_pgfault+0x231>
            }
            swap_map_swappable(mm, addr, page, 1);
c010905a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010905d:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0109064:	00 
c0109065:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109069:	8b 45 10             	mov    0x10(%ebp),%eax
c010906c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109070:	8b 45 08             	mov    0x8(%ebp),%eax
c0109073:	89 04 24             	mov    %eax,(%esp)
c0109076:	e8 80 de ff ff       	call   c0106efb <swap_map_swappable>
            page->pra_vaddr = addr;
c010907b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010907e:	8b 55 10             	mov    0x10(%ebp),%edx
c0109081:	89 50 1c             	mov    %edx,0x1c(%eax)
c0109084:	eb 17                	jmp    c010909d <do_pgfault+0x22a>
        }
        else {
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
c0109086:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109089:	8b 00                	mov    (%eax),%eax
c010908b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010908f:	c7 04 24 a4 df 10 c0 	movl   $0xc010dfa4,(%esp)
c0109096:	e8 c4 72 ff ff       	call   c010035f <cprintf>
            goto failed;
c010909b:	eb 07                	jmp    c01090a4 <do_pgfault+0x231>
        }
   }
   ret = 0;
c010909d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c01090a4:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01090a7:	c9                   	leave  
c01090a8:	c3                   	ret    

c01090a9 <user_mem_check>:

bool
user_mem_check(struct mm_struct *mm, uintptr_t addr, size_t len, bool write) {
c01090a9:	55                   	push   %ebp
c01090aa:	89 e5                	mov    %esp,%ebp
c01090ac:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01090af:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01090b3:	0f 84 e0 00 00 00    	je     c0109199 <user_mem_check+0xf0>
        if (!USER_ACCESS(addr, addr + len)) {
c01090b9:	81 7d 0c ff ff 1f 00 	cmpl   $0x1fffff,0xc(%ebp)
c01090c0:	76 1c                	jbe    c01090de <user_mem_check+0x35>
c01090c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01090c5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01090c8:	01 d0                	add    %edx,%eax
c01090ca:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01090cd:	76 0f                	jbe    c01090de <user_mem_check+0x35>
c01090cf:	8b 45 10             	mov    0x10(%ebp),%eax
c01090d2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01090d5:	01 d0                	add    %edx,%eax
c01090d7:	3d 00 00 00 b0       	cmp    $0xb0000000,%eax
c01090dc:	76 0a                	jbe    c01090e8 <user_mem_check+0x3f>
            return 0;
c01090de:	b8 00 00 00 00       	mov    $0x0,%eax
c01090e3:	e9 e2 00 00 00       	jmp    c01091ca <user_mem_check+0x121>
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
c01090e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01090eb:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01090ee:	8b 45 10             	mov    0x10(%ebp),%eax
c01090f1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01090f4:	01 d0                	add    %edx,%eax
c01090f6:	89 45 f8             	mov    %eax,-0x8(%ebp)
        while (start < end) {
c01090f9:	e9 88 00 00 00       	jmp    c0109186 <user_mem_check+0xdd>
            if ((vma = find_vma(mm, start)) == NULL || start < vma->vm_start) {
c01090fe:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109101:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109105:	8b 45 08             	mov    0x8(%ebp),%eax
c0109108:	89 04 24             	mov    %eax,(%esp)
c010910b:	e8 94 ef ff ff       	call   c01080a4 <find_vma>
c0109110:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109113:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109117:	74 0b                	je     c0109124 <user_mem_check+0x7b>
c0109119:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010911c:	8b 40 04             	mov    0x4(%eax),%eax
c010911f:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0109122:	76 0a                	jbe    c010912e <user_mem_check+0x85>
                return 0;
c0109124:	b8 00 00 00 00       	mov    $0x0,%eax
c0109129:	e9 9c 00 00 00       	jmp    c01091ca <user_mem_check+0x121>
            }
            if (!(vma->vm_flags & ((write) ? VM_WRITE : VM_READ))) {
c010912e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109131:	8b 50 0c             	mov    0xc(%eax),%edx
c0109134:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0109138:	74 07                	je     c0109141 <user_mem_check+0x98>
c010913a:	b8 02 00 00 00       	mov    $0x2,%eax
c010913f:	eb 05                	jmp    c0109146 <user_mem_check+0x9d>
c0109141:	b8 01 00 00 00       	mov    $0x1,%eax
c0109146:	21 d0                	and    %edx,%eax
c0109148:	85 c0                	test   %eax,%eax
c010914a:	75 07                	jne    c0109153 <user_mem_check+0xaa>
                return 0;
c010914c:	b8 00 00 00 00       	mov    $0x0,%eax
c0109151:	eb 77                	jmp    c01091ca <user_mem_check+0x121>
            }
            if (write && (vma->vm_flags & VM_STACK)) {
c0109153:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0109157:	74 24                	je     c010917d <user_mem_check+0xd4>
c0109159:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010915c:	8b 40 0c             	mov    0xc(%eax),%eax
c010915f:	83 e0 08             	and    $0x8,%eax
c0109162:	85 c0                	test   %eax,%eax
c0109164:	74 17                	je     c010917d <user_mem_check+0xd4>
                if (start < vma->vm_start + PGSIZE) { //check stack start & size
c0109166:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109169:	8b 40 04             	mov    0x4(%eax),%eax
c010916c:	05 00 10 00 00       	add    $0x1000,%eax
c0109171:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0109174:	76 07                	jbe    c010917d <user_mem_check+0xd4>
                    return 0;
c0109176:	b8 00 00 00 00       	mov    $0x0,%eax
c010917b:	eb 4d                	jmp    c01091ca <user_mem_check+0x121>
                }
            }
            start = vma->vm_end;
c010917d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109180:	8b 40 08             	mov    0x8(%eax),%eax
c0109183:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!USER_ACCESS(addr, addr + len)) {
            return 0;
        }
        struct vma_struct *vma;
        uintptr_t start = addr, end = addr + len;
        while (start < end) {
c0109186:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109189:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c010918c:	0f 82 6c ff ff ff    	jb     c01090fe <user_mem_check+0x55>
                    return 0;
                }
            }
            start = vma->vm_end;
        }
        return 1;
c0109192:	b8 01 00 00 00       	mov    $0x1,%eax
c0109197:	eb 31                	jmp    c01091ca <user_mem_check+0x121>
    }
    return KERN_ACCESS(addr, addr + len);
c0109199:	81 7d 0c ff ff ff bf 	cmpl   $0xbfffffff,0xc(%ebp)
c01091a0:	76 23                	jbe    c01091c5 <user_mem_check+0x11c>
c01091a2:	8b 45 10             	mov    0x10(%ebp),%eax
c01091a5:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091a8:	01 d0                	add    %edx,%eax
c01091aa:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01091ad:	76 16                	jbe    c01091c5 <user_mem_check+0x11c>
c01091af:	8b 45 10             	mov    0x10(%ebp),%eax
c01091b2:	8b 55 0c             	mov    0xc(%ebp),%edx
c01091b5:	01 d0                	add    %edx,%eax
c01091b7:	3d 00 00 00 f8       	cmp    $0xf8000000,%eax
c01091bc:	77 07                	ja     c01091c5 <user_mem_check+0x11c>
c01091be:	b8 01 00 00 00       	mov    $0x1,%eax
c01091c3:	eb 05                	jmp    c01091ca <user_mem_check+0x121>
c01091c5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01091ca:	c9                   	leave  
c01091cb:	c3                   	ret    

c01091cc <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01091cc:	55                   	push   %ebp
c01091cd:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01091cf:	8b 55 08             	mov    0x8(%ebp),%edx
c01091d2:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c01091d7:	89 d1                	mov    %edx,%ecx
c01091d9:	29 c1                	sub    %eax,%ecx
c01091db:	89 c8                	mov    %ecx,%eax
c01091dd:	c1 f8 05             	sar    $0x5,%eax
}
c01091e0:	5d                   	pop    %ebp
c01091e1:	c3                   	ret    

c01091e2 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01091e2:	55                   	push   %ebp
c01091e3:	89 e5                	mov    %esp,%ebp
c01091e5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01091e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01091eb:	89 04 24             	mov    %eax,(%esp)
c01091ee:	e8 d9 ff ff ff       	call   c01091cc <page2ppn>
c01091f3:	c1 e0 0c             	shl    $0xc,%eax
}
c01091f6:	c9                   	leave  
c01091f7:	c3                   	ret    

c01091f8 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c01091f8:	55                   	push   %ebp
c01091f9:	89 e5                	mov    %esp,%ebp
c01091fb:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01091fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0109201:	89 04 24             	mov    %eax,(%esp)
c0109204:	e8 d9 ff ff ff       	call   c01091e2 <page2pa>
c0109209:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010920c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010920f:	c1 e8 0c             	shr    $0xc,%eax
c0109212:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109215:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c010921a:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010921d:	72 23                	jb     c0109242 <page2kva+0x4a>
c010921f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109222:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109226:	c7 44 24 08 cc df 10 	movl   $0xc010dfcc,0x8(%esp)
c010922d:	c0 
c010922e:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0109235:	00 
c0109236:	c7 04 24 ef df 10 c0 	movl   $0xc010dfef,(%esp)
c010923d:	e8 76 7b ff ff       	call   c0100db8 <__panic>
c0109242:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109245:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010924a:	c9                   	leave  
c010924b:	c3                   	ret    

c010924c <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c010924c:	55                   	push   %ebp
c010924d:	89 e5                	mov    %esp,%ebp
c010924f:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c0109252:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109259:	e8 75 89 ff ff       	call   c0101bd3 <ide_device_valid>
c010925e:	85 c0                	test   %eax,%eax
c0109260:	75 1c                	jne    c010927e <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c0109262:	c7 44 24 08 fd df 10 	movl   $0xc010dffd,0x8(%esp)
c0109269:	c0 
c010926a:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c0109271:	00 
c0109272:	c7 04 24 17 e0 10 c0 	movl   $0xc010e017,(%esp)
c0109279:	e8 3a 7b ff ff       	call   c0100db8 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c010927e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109285:	e8 88 89 ff ff       	call   c0101c12 <ide_device_size>
c010928a:	c1 e8 03             	shr    $0x3,%eax
c010928d:	a3 7c ef 19 c0       	mov    %eax,0xc019ef7c
}
c0109292:	c9                   	leave  
c0109293:	c3                   	ret    

c0109294 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0109294:	55                   	push   %ebp
c0109295:	89 e5                	mov    %esp,%ebp
c0109297:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010929a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010929d:	89 04 24             	mov    %eax,(%esp)
c01092a0:	e8 53 ff ff ff       	call   c01091f8 <page2kva>
c01092a5:	8b 55 08             	mov    0x8(%ebp),%edx
c01092a8:	c1 ea 08             	shr    $0x8,%edx
c01092ab:	89 55 f4             	mov    %edx,-0xc(%ebp)
c01092ae:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01092b2:	74 0b                	je     c01092bf <swapfs_read+0x2b>
c01092b4:	8b 15 7c ef 19 c0    	mov    0xc019ef7c,%edx
c01092ba:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01092bd:	72 23                	jb     c01092e2 <swapfs_read+0x4e>
c01092bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01092c2:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01092c6:	c7 44 24 08 28 e0 10 	movl   $0xc010e028,0x8(%esp)
c01092cd:	c0 
c01092ce:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01092d5:	00 
c01092d6:	c7 04 24 17 e0 10 c0 	movl   $0xc010e017,(%esp)
c01092dd:	e8 d6 7a ff ff       	call   c0100db8 <__panic>
c01092e2:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01092e5:	c1 e2 03             	shl    $0x3,%edx
c01092e8:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01092ef:	00 
c01092f0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01092f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01092f8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01092ff:	e8 4d 89 ff ff       	call   c0101c51 <ide_read_secs>
}
c0109304:	c9                   	leave  
c0109305:	c3                   	ret    

c0109306 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c0109306:	55                   	push   %ebp
c0109307:	89 e5                	mov    %esp,%ebp
c0109309:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c010930c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010930f:	89 04 24             	mov    %eax,(%esp)
c0109312:	e8 e1 fe ff ff       	call   c01091f8 <page2kva>
c0109317:	8b 55 08             	mov    0x8(%ebp),%edx
c010931a:	c1 ea 08             	shr    $0x8,%edx
c010931d:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109320:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109324:	74 0b                	je     c0109331 <swapfs_write+0x2b>
c0109326:	8b 15 7c ef 19 c0    	mov    0xc019ef7c,%edx
c010932c:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010932f:	72 23                	jb     c0109354 <swapfs_write+0x4e>
c0109331:	8b 45 08             	mov    0x8(%ebp),%eax
c0109334:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109338:	c7 44 24 08 28 e0 10 	movl   $0xc010e028,0x8(%esp)
c010933f:	c0 
c0109340:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0109347:	00 
c0109348:	c7 04 24 17 e0 10 c0 	movl   $0xc010e017,(%esp)
c010934f:	e8 64 7a ff ff       	call   c0100db8 <__panic>
c0109354:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109357:	c1 e2 03             	shl    $0x3,%edx
c010935a:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0109361:	00 
c0109362:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109366:	89 54 24 04          	mov    %edx,0x4(%esp)
c010936a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109371:	e8 24 8b ff ff       	call   c0101e9a <ide_write_secs>
}
c0109376:	c9                   	leave  
c0109377:	c3                   	ret    

c0109378 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c0109378:	52                   	push   %edx
    call *%ebx              # call fn
c0109379:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c010937b:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c010937c:	e8 92 0c 00 00       	call   c010a013 <do_exit>
c0109381:	00 00                	add    %al,(%eax)
	...

c0109384 <test_and_set_bit>:
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
c0109384:	55                   	push   %ebp
c0109385:	89 e5                	mov    %esp,%ebp
c0109387:	53                   	push   %ebx
c0109388:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c010938b:	8b 55 0c             	mov    0xc(%ebp),%edx
c010938e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109391:	0f ab 02             	bts    %eax,(%edx)
c0109394:	19 db                	sbb    %ebx,%ebx
c0109396:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return oldbit != 0;
c0109399:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c010939d:	0f 95 c0             	setne  %al
c01093a0:	0f b6 c0             	movzbl %al,%eax
}
c01093a3:	83 c4 10             	add    $0x10,%esp
c01093a6:	5b                   	pop    %ebx
c01093a7:	5d                   	pop    %ebp
c01093a8:	c3                   	ret    

c01093a9 <test_and_clear_bit>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
c01093a9:	55                   	push   %ebp
c01093aa:	89 e5                	mov    %esp,%ebp
c01093ac:	53                   	push   %ebx
c01093ad:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
c01093b0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01093b3:	8b 45 08             	mov    0x8(%ebp),%eax
c01093b6:	0f b3 02             	btr    %eax,(%edx)
c01093b9:	19 db                	sbb    %ebx,%ebx
c01093bb:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return oldbit != 0;
c01093be:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c01093c2:	0f 95 c0             	setne  %al
c01093c5:	0f b6 c0             	movzbl %al,%eax
}
c01093c8:	83 c4 10             	add    $0x10,%esp
c01093cb:	5b                   	pop    %ebx
c01093cc:	5d                   	pop    %ebp
c01093cd:	c3                   	ret    

c01093ce <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c01093ce:	55                   	push   %ebp
c01093cf:	89 e5                	mov    %esp,%ebp
c01093d1:	53                   	push   %ebx
c01093d2:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01093d5:	9c                   	pushf  
c01093d6:	5b                   	pop    %ebx
c01093d7:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c01093da:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01093dd:	25 00 02 00 00       	and    $0x200,%eax
c01093e2:	85 c0                	test   %eax,%eax
c01093e4:	74 0c                	je     c01093f2 <__intr_save+0x24>
        intr_disable();
c01093e6:	e8 fb 8c ff ff       	call   c01020e6 <intr_disable>
        return 1;
c01093eb:	b8 01 00 00 00       	mov    $0x1,%eax
c01093f0:	eb 05                	jmp    c01093f7 <__intr_save+0x29>
    }
    return 0;
c01093f2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01093f7:	83 c4 14             	add    $0x14,%esp
c01093fa:	5b                   	pop    %ebx
c01093fb:	5d                   	pop    %ebp
c01093fc:	c3                   	ret    

c01093fd <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c01093fd:	55                   	push   %ebp
c01093fe:	89 e5                	mov    %esp,%ebp
c0109400:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0109403:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109407:	74 05                	je     c010940e <__intr_restore+0x11>
        intr_enable();
c0109409:	e8 d2 8c ff ff       	call   c01020e0 <intr_enable>
    }
}
c010940e:	c9                   	leave  
c010940f:	c3                   	ret    

c0109410 <try_lock>:
lock_init(lock_t *lock) {
    *lock = 0;
}

static inline bool
try_lock(lock_t *lock) {
c0109410:	55                   	push   %ebp
c0109411:	89 e5                	mov    %esp,%ebp
c0109413:	83 ec 08             	sub    $0x8,%esp
    return !test_and_set_bit(0, lock);
c0109416:	8b 45 08             	mov    0x8(%ebp),%eax
c0109419:	89 44 24 04          	mov    %eax,0x4(%esp)
c010941d:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0109424:	e8 5b ff ff ff       	call   c0109384 <test_and_set_bit>
c0109429:	85 c0                	test   %eax,%eax
c010942b:	0f 94 c0             	sete   %al
c010942e:	0f b6 c0             	movzbl %al,%eax
}
c0109431:	c9                   	leave  
c0109432:	c3                   	ret    

c0109433 <lock>:

static inline void
lock(lock_t *lock) {
c0109433:	55                   	push   %ebp
c0109434:	89 e5                	mov    %esp,%ebp
c0109436:	83 ec 18             	sub    $0x18,%esp
    while (!try_lock(lock)) {
c0109439:	eb 05                	jmp    c0109440 <lock+0xd>
        schedule();
c010943b:	e8 52 1c 00 00       	call   c010b092 <schedule>
    return !test_and_set_bit(0, lock);
}

static inline void
lock(lock_t *lock) {
    while (!try_lock(lock)) {
c0109440:	8b 45 08             	mov    0x8(%ebp),%eax
c0109443:	89 04 24             	mov    %eax,(%esp)
c0109446:	e8 c5 ff ff ff       	call   c0109410 <try_lock>
c010944b:	85 c0                	test   %eax,%eax
c010944d:	74 ec                	je     c010943b <lock+0x8>
        schedule();
    }
}
c010944f:	c9                   	leave  
c0109450:	c3                   	ret    

c0109451 <unlock>:

static inline void
unlock(lock_t *lock) {
c0109451:	55                   	push   %ebp
c0109452:	89 e5                	mov    %esp,%ebp
c0109454:	83 ec 18             	sub    $0x18,%esp
    if (!test_and_clear_bit(0, lock)) {
c0109457:	8b 45 08             	mov    0x8(%ebp),%eax
c010945a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010945e:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0109465:	e8 3f ff ff ff       	call   c01093a9 <test_and_clear_bit>
c010946a:	85 c0                	test   %eax,%eax
c010946c:	75 1c                	jne    c010948a <unlock+0x39>
        panic("Unlock failed.\n");
c010946e:	c7 44 24 08 48 e0 10 	movl   $0xc010e048,0x8(%esp)
c0109475:	c0 
c0109476:	c7 44 24 04 34 00 00 	movl   $0x34,0x4(%esp)
c010947d:	00 
c010947e:	c7 04 24 58 e0 10 c0 	movl   $0xc010e058,(%esp)
c0109485:	e8 2e 79 ff ff       	call   c0100db8 <__panic>
    }
}
c010948a:	c9                   	leave  
c010948b:	c3                   	ret    

c010948c <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010948c:	55                   	push   %ebp
c010948d:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010948f:	8b 55 08             	mov    0x8(%ebp),%edx
c0109492:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c0109497:	89 d1                	mov    %edx,%ecx
c0109499:	29 c1                	sub    %eax,%ecx
c010949b:	89 c8                	mov    %ecx,%eax
c010949d:	c1 f8 05             	sar    $0x5,%eax
}
c01094a0:	5d                   	pop    %ebp
c01094a1:	c3                   	ret    

c01094a2 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01094a2:	55                   	push   %ebp
c01094a3:	89 e5                	mov    %esp,%ebp
c01094a5:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01094a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01094ab:	89 04 24             	mov    %eax,(%esp)
c01094ae:	e8 d9 ff ff ff       	call   c010948c <page2ppn>
c01094b3:	c1 e0 0c             	shl    $0xc,%eax
}
c01094b6:	c9                   	leave  
c01094b7:	c3                   	ret    

c01094b8 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01094b8:	55                   	push   %ebp
c01094b9:	89 e5                	mov    %esp,%ebp
c01094bb:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01094be:	8b 45 08             	mov    0x8(%ebp),%eax
c01094c1:	89 c2                	mov    %eax,%edx
c01094c3:	c1 ea 0c             	shr    $0xc,%edx
c01094c6:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c01094cb:	39 c2                	cmp    %eax,%edx
c01094cd:	72 1c                	jb     c01094eb <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01094cf:	c7 44 24 08 6c e0 10 	movl   $0xc010e06c,0x8(%esp)
c01094d6:	c0 
c01094d7:	c7 44 24 04 5e 00 00 	movl   $0x5e,0x4(%esp)
c01094de:	00 
c01094df:	c7 04 24 8b e0 10 c0 	movl   $0xc010e08b,(%esp)
c01094e6:	e8 cd 78 ff ff       	call   c0100db8 <__panic>
    }
    return &pages[PPN(pa)];
c01094eb:	a1 cc ee 19 c0       	mov    0xc019eecc,%eax
c01094f0:	8b 55 08             	mov    0x8(%ebp),%edx
c01094f3:	c1 ea 0c             	shr    $0xc,%edx
c01094f6:	c1 e2 05             	shl    $0x5,%edx
c01094f9:	01 d0                	add    %edx,%eax
}
c01094fb:	c9                   	leave  
c01094fc:	c3                   	ret    

c01094fd <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01094fd:	55                   	push   %ebp
c01094fe:	89 e5                	mov    %esp,%ebp
c0109500:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0109503:	8b 45 08             	mov    0x8(%ebp),%eax
c0109506:	89 04 24             	mov    %eax,(%esp)
c0109509:	e8 94 ff ff ff       	call   c01094a2 <page2pa>
c010950e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109511:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109514:	c1 e8 0c             	shr    $0xc,%eax
c0109517:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010951a:	a1 e0 cd 19 c0       	mov    0xc019cde0,%eax
c010951f:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109522:	72 23                	jb     c0109547 <page2kva+0x4a>
c0109524:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109527:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010952b:	c7 44 24 08 9c e0 10 	movl   $0xc010e09c,0x8(%esp)
c0109532:	c0 
c0109533:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c010953a:	00 
c010953b:	c7 04 24 8b e0 10 c0 	movl   $0xc010e08b,(%esp)
c0109542:	e8 71 78 ff ff       	call   c0100db8 <__panic>
c0109547:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010954a:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010954f:	c9                   	leave  
c0109550:	c3                   	ret    

c0109551 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0109551:	55                   	push   %ebp
c0109552:	89 e5                	mov    %esp,%ebp
c0109554:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0109557:	8b 45 08             	mov    0x8(%ebp),%eax
c010955a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010955d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0109564:	77 23                	ja     c0109589 <kva2page+0x38>
c0109566:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109569:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010956d:	c7 44 24 08 c0 e0 10 	movl   $0xc010e0c0,0x8(%esp)
c0109574:	c0 
c0109575:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c010957c:	00 
c010957d:	c7 04 24 8b e0 10 c0 	movl   $0xc010e08b,(%esp)
c0109584:	e8 2f 78 ff ff       	call   c0100db8 <__panic>
c0109589:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010958c:	05 00 00 00 40       	add    $0x40000000,%eax
c0109591:	89 04 24             	mov    %eax,(%esp)
c0109594:	e8 1f ff ff ff       	call   c01094b8 <pa2page>
}
c0109599:	c9                   	leave  
c010959a:	c3                   	ret    

c010959b <mm_count_inc>:

static inline int
mm_count_inc(struct mm_struct *mm) {
c010959b:	55                   	push   %ebp
c010959c:	89 e5                	mov    %esp,%ebp
    mm->mm_count += 1;
c010959e:	8b 45 08             	mov    0x8(%ebp),%eax
c01095a1:	8b 40 18             	mov    0x18(%eax),%eax
c01095a4:	8d 50 01             	lea    0x1(%eax),%edx
c01095a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01095aa:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c01095ad:	8b 45 08             	mov    0x8(%ebp),%eax
c01095b0:	8b 40 18             	mov    0x18(%eax),%eax
}
c01095b3:	5d                   	pop    %ebp
c01095b4:	c3                   	ret    

c01095b5 <mm_count_dec>:

static inline int
mm_count_dec(struct mm_struct *mm) {
c01095b5:	55                   	push   %ebp
c01095b6:	89 e5                	mov    %esp,%ebp
    mm->mm_count -= 1;
c01095b8:	8b 45 08             	mov    0x8(%ebp),%eax
c01095bb:	8b 40 18             	mov    0x18(%eax),%eax
c01095be:	8d 50 ff             	lea    -0x1(%eax),%edx
c01095c1:	8b 45 08             	mov    0x8(%ebp),%eax
c01095c4:	89 50 18             	mov    %edx,0x18(%eax)
    return mm->mm_count;
c01095c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01095ca:	8b 40 18             	mov    0x18(%eax),%eax
}
c01095cd:	5d                   	pop    %ebp
c01095ce:	c3                   	ret    

c01095cf <lock_mm>:

static inline void
lock_mm(struct mm_struct *mm) {
c01095cf:	55                   	push   %ebp
c01095d0:	89 e5                	mov    %esp,%ebp
c01095d2:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01095d5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01095d9:	74 0e                	je     c01095e9 <lock_mm+0x1a>
        lock(&(mm->mm_lock));
c01095db:	8b 45 08             	mov    0x8(%ebp),%eax
c01095de:	83 c0 1c             	add    $0x1c,%eax
c01095e1:	89 04 24             	mov    %eax,(%esp)
c01095e4:	e8 4a fe ff ff       	call   c0109433 <lock>
    }
}
c01095e9:	c9                   	leave  
c01095ea:	c3                   	ret    

c01095eb <unlock_mm>:

static inline void
unlock_mm(struct mm_struct *mm) {
c01095eb:	55                   	push   %ebp
c01095ec:	89 e5                	mov    %esp,%ebp
c01095ee:	83 ec 18             	sub    $0x18,%esp
    if (mm != NULL) {
c01095f1:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01095f5:	74 0e                	je     c0109605 <unlock_mm+0x1a>
        unlock(&(mm->mm_lock));
c01095f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01095fa:	83 c0 1c             	add    $0x1c,%eax
c01095fd:	89 04 24             	mov    %eax,(%esp)
c0109600:	e8 4c fe ff ff       	call   c0109451 <unlock>
    }
}
c0109605:	c9                   	leave  
c0109606:	c3                   	ret    

c0109607 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c0109607:	55                   	push   %ebp
c0109608:	89 e5                	mov    %esp,%ebp
c010960a:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c010960d:	c7 04 24 7c 00 00 00 	movl   $0x7c,(%esp)
c0109614:	e8 a1 b6 ff ff       	call   c0104cba <kmalloc>
c0109619:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c010961c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109620:	0f 84 cd 00 00 00    	je     c01096f3 <alloc_proc+0xec>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        proc->state = PROC_UNINIT;
c0109626:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109629:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        proc->pid = -1;
c010962f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109632:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
        proc->runs = 0;
c0109639:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010963c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        proc->kstack = 0;
c0109643:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109646:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        proc->need_resched = 0;
c010964d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109650:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        proc->parent = NULL;
c0109657:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010965a:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        proc->mm = NULL;
c0109661:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109664:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        memset(&(proc->context), 0, sizeof(struct context));
c010966b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010966e:	83 c0 1c             	add    $0x1c,%eax
c0109671:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0109678:	00 
c0109679:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109680:	00 
c0109681:	89 04 24             	mov    %eax,(%esp)
c0109684:	e8 fe 27 00 00       	call   c010be87 <memset>
        proc->tf = NULL;
c0109689:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010968c:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
        proc->cr3 = boot_cr3;
c0109693:	8b 15 c8 ee 19 c0    	mov    0xc019eec8,%edx
c0109699:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010969c:	89 50 40             	mov    %edx,0x40(%eax)
        proc->flags = 0;
c010969f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096a2:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
        memset(proc->name, 0, PROC_NAME_LEN);
c01096a9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096ac:	83 c0 48             	add    $0x48,%eax
c01096af:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01096b6:	00 
c01096b7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01096be:	00 
c01096bf:	89 04 24             	mov    %eax,(%esp)
c01096c2:	e8 c0 27 00 00       	call   c010be87 <memset>
    /*
     * below fields(add in LAB5) in proc_struct need to be initialized	
     *       uint32_t wait_state;                        // waiting state
     *       struct proc_struct *cptr, *yptr, *optr;     // relations between processes
	 */
        proc->wait_state = 0;
c01096c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096ca:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
        proc->cptr = proc->yptr = proc->optr = NULL;
c01096d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096d4:	c7 40 78 00 00 00 00 	movl   $0x0,0x78(%eax)
c01096db:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096de:	8b 50 78             	mov    0x78(%eax),%edx
c01096e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096e4:	89 50 74             	mov    %edx,0x74(%eax)
c01096e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096ea:	8b 50 74             	mov    0x74(%eax),%edx
c01096ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01096f0:	89 50 70             	mov    %edx,0x70(%eax)
    }
    return proc;
c01096f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01096f6:	c9                   	leave  
c01096f7:	c3                   	ret    

c01096f8 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c01096f8:	55                   	push   %ebp
c01096f9:	89 e5                	mov    %esp,%ebp
c01096fb:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c01096fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0109701:	83 c0 48             	add    $0x48,%eax
c0109704:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010970b:	00 
c010970c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109713:	00 
c0109714:	89 04 24             	mov    %eax,(%esp)
c0109717:	e8 6b 27 00 00       	call   c010be87 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c010971c:	8b 45 08             	mov    0x8(%ebp),%eax
c010971f:	8d 50 48             	lea    0x48(%eax),%edx
c0109722:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0109729:	00 
c010972a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010972d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109731:	89 14 24             	mov    %edx,(%esp)
c0109734:	e8 4d 28 00 00       	call   c010bf86 <memcpy>
}
c0109739:	c9                   	leave  
c010973a:	c3                   	ret    

c010973b <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c010973b:	55                   	push   %ebp
c010973c:	89 e5                	mov    %esp,%ebp
c010973e:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c0109741:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0109748:	00 
c0109749:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109750:	00 
c0109751:	c7 04 24 a4 ee 19 c0 	movl   $0xc019eea4,(%esp)
c0109758:	e8 2a 27 00 00       	call   c010be87 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c010975d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109760:	83 c0 48             	add    $0x48,%eax
c0109763:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c010976a:	00 
c010976b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010976f:	c7 04 24 a4 ee 19 c0 	movl   $0xc019eea4,(%esp)
c0109776:	e8 0b 28 00 00       	call   c010bf86 <memcpy>
}
c010977b:	c9                   	leave  
c010977c:	c3                   	ret    

c010977d <set_links>:

// set_links - set the relation links of process
static void
set_links(struct proc_struct *proc) {
c010977d:	55                   	push   %ebp
c010977e:	89 e5                	mov    %esp,%ebp
c0109780:	83 ec 20             	sub    $0x20,%esp
    list_add(&proc_list, &(proc->list_link));
c0109783:	8b 45 08             	mov    0x8(%ebp),%eax
c0109786:	83 c0 58             	add    $0x58,%eax
c0109789:	c7 45 fc b0 ef 19 c0 	movl   $0xc019efb0,-0x4(%ebp)
c0109790:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0109793:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109796:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109799:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010979c:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c010979f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01097a2:	8b 40 04             	mov    0x4(%eax),%eax
c01097a5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01097a8:	89 55 ec             	mov    %edx,-0x14(%ebp)
c01097ab:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01097ae:	89 55 e8             	mov    %edx,-0x18(%ebp)
c01097b1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01097b4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01097b7:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01097ba:	89 10                	mov    %edx,(%eax)
c01097bc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01097bf:	8b 10                	mov    (%eax),%edx
c01097c1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01097c4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01097c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097ca:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01097cd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01097d0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01097d3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01097d6:	89 10                	mov    %edx,(%eax)
    proc->yptr = NULL;
c01097d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01097db:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
    if ((proc->optr = proc->parent->cptr) != NULL) {
c01097e2:	8b 45 08             	mov    0x8(%ebp),%eax
c01097e5:	8b 40 14             	mov    0x14(%eax),%eax
c01097e8:	8b 50 70             	mov    0x70(%eax),%edx
c01097eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01097ee:	89 50 78             	mov    %edx,0x78(%eax)
c01097f1:	8b 45 08             	mov    0x8(%ebp),%eax
c01097f4:	8b 40 78             	mov    0x78(%eax),%eax
c01097f7:	85 c0                	test   %eax,%eax
c01097f9:	74 0c                	je     c0109807 <set_links+0x8a>
        proc->optr->yptr = proc;
c01097fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01097fe:	8b 40 78             	mov    0x78(%eax),%eax
c0109801:	8b 55 08             	mov    0x8(%ebp),%edx
c0109804:	89 50 74             	mov    %edx,0x74(%eax)
    }
    proc->parent->cptr = proc;
c0109807:	8b 45 08             	mov    0x8(%ebp),%eax
c010980a:	8b 40 14             	mov    0x14(%eax),%eax
c010980d:	8b 55 08             	mov    0x8(%ebp),%edx
c0109810:	89 50 70             	mov    %edx,0x70(%eax)
    nr_process ++;
c0109813:	a1 a0 ee 19 c0       	mov    0xc019eea0,%eax
c0109818:	83 c0 01             	add    $0x1,%eax
c010981b:	a3 a0 ee 19 c0       	mov    %eax,0xc019eea0
}
c0109820:	c9                   	leave  
c0109821:	c3                   	ret    

c0109822 <remove_links>:

// remove_links - clean the relation links of process
static void
remove_links(struct proc_struct *proc) {
c0109822:	55                   	push   %ebp
c0109823:	89 e5                	mov    %esp,%ebp
c0109825:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->list_link));
c0109828:	8b 45 08             	mov    0x8(%ebp),%eax
c010982b:	83 c0 58             	add    $0x58,%eax
c010982e:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0109831:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109834:	8b 40 04             	mov    0x4(%eax),%eax
c0109837:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010983a:	8b 12                	mov    (%edx),%edx
c010983c:	89 55 f8             	mov    %edx,-0x8(%ebp)
c010983f:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0109842:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109845:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109848:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c010984b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010984e:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109851:	89 10                	mov    %edx,(%eax)
    if (proc->optr != NULL) {
c0109853:	8b 45 08             	mov    0x8(%ebp),%eax
c0109856:	8b 40 78             	mov    0x78(%eax),%eax
c0109859:	85 c0                	test   %eax,%eax
c010985b:	74 0f                	je     c010986c <remove_links+0x4a>
        proc->optr->yptr = proc->yptr;
c010985d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109860:	8b 40 78             	mov    0x78(%eax),%eax
c0109863:	8b 55 08             	mov    0x8(%ebp),%edx
c0109866:	8b 52 74             	mov    0x74(%edx),%edx
c0109869:	89 50 74             	mov    %edx,0x74(%eax)
    }
    if (proc->yptr != NULL) {
c010986c:	8b 45 08             	mov    0x8(%ebp),%eax
c010986f:	8b 40 74             	mov    0x74(%eax),%eax
c0109872:	85 c0                	test   %eax,%eax
c0109874:	74 11                	je     c0109887 <remove_links+0x65>
        proc->yptr->optr = proc->optr;
c0109876:	8b 45 08             	mov    0x8(%ebp),%eax
c0109879:	8b 40 74             	mov    0x74(%eax),%eax
c010987c:	8b 55 08             	mov    0x8(%ebp),%edx
c010987f:	8b 52 78             	mov    0x78(%edx),%edx
c0109882:	89 50 78             	mov    %edx,0x78(%eax)
c0109885:	eb 0f                	jmp    c0109896 <remove_links+0x74>
    }
    else {
       proc->parent->cptr = proc->optr;
c0109887:	8b 45 08             	mov    0x8(%ebp),%eax
c010988a:	8b 40 14             	mov    0x14(%eax),%eax
c010988d:	8b 55 08             	mov    0x8(%ebp),%edx
c0109890:	8b 52 78             	mov    0x78(%edx),%edx
c0109893:	89 50 70             	mov    %edx,0x70(%eax)
    }
    nr_process --;
c0109896:	a1 a0 ee 19 c0       	mov    0xc019eea0,%eax
c010989b:	83 e8 01             	sub    $0x1,%eax
c010989e:	a3 a0 ee 19 c0       	mov    %eax,0xc019eea0
}
c01098a3:	c9                   	leave  
c01098a4:	c3                   	ret    

c01098a5 <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c01098a5:	55                   	push   %ebp
c01098a6:	89 e5                	mov    %esp,%ebp
c01098a8:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c01098ab:	c7 45 f8 b0 ef 19 c0 	movl   $0xc019efb0,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c01098b2:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01098b7:	83 c0 01             	add    $0x1,%eax
c01098ba:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c01098bf:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c01098c4:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c01098c9:	7e 0c                	jle    c01098d7 <get_pid+0x32>
        last_pid = 1;
c01098cb:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c01098d2:	00 00 00 
        goto inside;
c01098d5:	eb 13                	jmp    c01098ea <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c01098d7:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c01098dd:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c01098e2:	39 c2                	cmp    %eax,%edx
c01098e4:	0f 8c ac 00 00 00    	jl     c0109996 <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c01098ea:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c01098f1:	20 00 00 
    repeat:
        le = list;
c01098f4:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01098f7:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c01098fa:	eb 7f                	jmp    c010997b <get_pid+0xd6>
            proc = le2proc(le, list_link);
c01098fc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01098ff:	83 e8 58             	sub    $0x58,%eax
c0109902:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c0109905:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109908:	8b 50 04             	mov    0x4(%eax),%edx
c010990b:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109910:	39 c2                	cmp    %eax,%edx
c0109912:	75 3e                	jne    c0109952 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c0109914:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109919:	83 c0 01             	add    $0x1,%eax
c010991c:	a3 80 aa 12 c0       	mov    %eax,0xc012aa80
c0109921:	8b 15 80 aa 12 c0    	mov    0xc012aa80,%edx
c0109927:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c010992c:	39 c2                	cmp    %eax,%edx
c010992e:	7c 4b                	jl     c010997b <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c0109930:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c0109935:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c010993a:	7e 0a                	jle    c0109946 <get_pid+0xa1>
                        last_pid = 1;
c010993c:	c7 05 80 aa 12 c0 01 	movl   $0x1,0xc012aa80
c0109943:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0109946:	c7 05 84 aa 12 c0 00 	movl   $0x2000,0xc012aa84
c010994d:	20 00 00 
                    goto repeat;
c0109950:	eb a2                	jmp    c01098f4 <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0109952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109955:	8b 50 04             	mov    0x4(%eax),%edx
c0109958:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
c010995d:	39 c2                	cmp    %eax,%edx
c010995f:	7e 1a                	jle    c010997b <get_pid+0xd6>
c0109961:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109964:	8b 50 04             	mov    0x4(%eax),%edx
c0109967:	a1 84 aa 12 c0       	mov    0xc012aa84,%eax
c010996c:	39 c2                	cmp    %eax,%edx
c010996e:	7d 0b                	jge    c010997b <get_pid+0xd6>
                next_safe = proc->pid;
c0109970:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109973:	8b 40 04             	mov    0x4(%eax),%eax
c0109976:	a3 84 aa 12 c0       	mov    %eax,0xc012aa84
c010997b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010997e:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109981:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109984:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0109987:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010998a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010998d:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0109990:	0f 85 66 ff ff ff    	jne    c01098fc <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0109996:	a1 80 aa 12 c0       	mov    0xc012aa80,%eax
}
c010999b:	c9                   	leave  
c010999c:	c3                   	ret    

c010999d <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c010999d:	55                   	push   %ebp
c010999e:	89 e5                	mov    %esp,%ebp
c01099a0:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c01099a3:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c01099a8:	39 45 08             	cmp    %eax,0x8(%ebp)
c01099ab:	74 63                	je     c0109a10 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c01099ad:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c01099b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01099b5:	8b 45 08             	mov    0x8(%ebp),%eax
c01099b8:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c01099bb:	e8 0e fa ff ff       	call   c01093ce <__intr_save>
c01099c0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c01099c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01099c6:	a3 88 ce 19 c0       	mov    %eax,0xc019ce88
            load_esp0(next->kstack + KSTACKSIZE);
c01099cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099ce:	8b 40 0c             	mov    0xc(%eax),%eax
c01099d1:	05 00 20 00 00       	add    $0x2000,%eax
c01099d6:	89 04 24             	mov    %eax,(%esp)
c01099d9:	e8 15 b6 ff ff       	call   c0104ff3 <load_esp0>
            lcr3(next->cr3);
c01099de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099e1:	8b 40 40             	mov    0x40(%eax),%eax
c01099e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c01099e7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01099ea:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c01099ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01099f0:	8d 50 1c             	lea    0x1c(%eax),%edx
c01099f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01099f6:	83 c0 1c             	add    $0x1c,%eax
c01099f9:	89 54 24 04          	mov    %edx,0x4(%esp)
c01099fd:	89 04 24             	mov    %eax,(%esp)
c0109a00:	e8 8f 15 00 00       	call   c010af94 <switch_to>
        }
        local_intr_restore(intr_flag);
c0109a05:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a08:	89 04 24             	mov    %eax,(%esp)
c0109a0b:	e8 ed f9 ff ff       	call   c01093fd <__intr_restore>
    }
}
c0109a10:	c9                   	leave  
c0109a11:	c3                   	ret    

c0109a12 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0109a12:	55                   	push   %ebp
c0109a13:	89 e5                	mov    %esp,%ebp
c0109a15:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c0109a18:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0109a1d:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109a20:	89 04 24             	mov    %eax,(%esp)
c0109a23:	e8 16 91 ff ff       	call   c0102b3e <forkrets>
}
c0109a28:	c9                   	leave  
c0109a29:	c3                   	ret    

c0109a2a <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0109a2a:	55                   	push   %ebp
c0109a2b:	89 e5                	mov    %esp,%ebp
c0109a2d:	53                   	push   %ebx
c0109a2e:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0109a31:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a34:	8d 58 60             	lea    0x60(%eax),%ebx
c0109a37:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a3a:	8b 40 04             	mov    0x4(%eax),%eax
c0109a3d:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0109a44:	00 
c0109a45:	89 04 24             	mov    %eax,(%esp)
c0109a48:	e8 07 19 00 00       	call   c010b354 <hash32>
c0109a4d:	c1 e0 03             	shl    $0x3,%eax
c0109a50:	05 a0 ce 19 c0       	add    $0xc019cea0,%eax
c0109a55:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109a58:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0109a5b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109a5e:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109a61:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a64:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0109a67:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a6a:	8b 40 04             	mov    0x4(%eax),%eax
c0109a6d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109a70:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0109a73:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109a76:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0109a79:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0109a7c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109a7f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109a82:	89 10                	mov    %edx,(%eax)
c0109a84:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109a87:	8b 10                	mov    (%eax),%edx
c0109a89:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109a8c:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0109a8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109a92:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0109a95:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0109a98:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109a9b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0109a9e:	89 10                	mov    %edx,(%eax)
}
c0109aa0:	83 c4 34             	add    $0x34,%esp
c0109aa3:	5b                   	pop    %ebx
c0109aa4:	5d                   	pop    %ebp
c0109aa5:	c3                   	ret    

c0109aa6 <unhash_proc>:

// unhash_proc - delete proc from proc hash_list
static void
unhash_proc(struct proc_struct *proc) {
c0109aa6:	55                   	push   %ebp
c0109aa7:	89 e5                	mov    %esp,%ebp
c0109aa9:	83 ec 10             	sub    $0x10,%esp
    list_del(&(proc->hash_link));
c0109aac:	8b 45 08             	mov    0x8(%ebp),%eax
c0109aaf:	83 c0 60             	add    $0x60,%eax
c0109ab2:	89 45 fc             	mov    %eax,-0x4(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0109ab5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109ab8:	8b 40 04             	mov    0x4(%eax),%eax
c0109abb:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0109abe:	8b 12                	mov    (%edx),%edx
c0109ac0:	89 55 f8             	mov    %edx,-0x8(%ebp)
c0109ac3:	89 45 f4             	mov    %eax,-0xc(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0109ac6:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109ac9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109acc:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0109acf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109ad2:	8b 55 f8             	mov    -0x8(%ebp),%edx
c0109ad5:	89 10                	mov    %edx,(%eax)
}
c0109ad7:	c9                   	leave  
c0109ad8:	c3                   	ret    

c0109ad9 <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0109ad9:	55                   	push   %ebp
c0109ada:	89 e5                	mov    %esp,%ebp
c0109adc:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0109adf:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109ae3:	7e 5f                	jle    c0109b44 <find_proc+0x6b>
c0109ae5:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0109aec:	7f 56                	jg     c0109b44 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0109aee:	8b 45 08             	mov    0x8(%ebp),%eax
c0109af1:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0109af8:	00 
c0109af9:	89 04 24             	mov    %eax,(%esp)
c0109afc:	e8 53 18 00 00       	call   c010b354 <hash32>
c0109b01:	c1 e0 03             	shl    $0x3,%eax
c0109b04:	05 a0 ce 19 c0       	add    $0xc019cea0,%eax
c0109b09:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109b0c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109b0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0109b12:	eb 19                	jmp    c0109b2d <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0109b14:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b17:	83 e8 60             	sub    $0x60,%eax
c0109b1a:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0109b1d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b20:	8b 40 04             	mov    0x4(%eax),%eax
c0109b23:	3b 45 08             	cmp    0x8(%ebp),%eax
c0109b26:	75 05                	jne    c0109b2d <find_proc+0x54>
                return proc;
c0109b28:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b2b:	eb 1c                	jmp    c0109b49 <find_proc+0x70>
c0109b2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b30:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109b33:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b36:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0109b39:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109b3c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109b3f:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0109b42:	75 d0                	jne    c0109b14 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0109b44:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109b49:	c9                   	leave  
c0109b4a:	c3                   	ret    

c0109b4b <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0109b4b:	55                   	push   %ebp
c0109b4c:	89 e5                	mov    %esp,%ebp
c0109b4e:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0109b51:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0109b58:	00 
c0109b59:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109b60:	00 
c0109b61:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0109b64:	89 04 24             	mov    %eax,(%esp)
c0109b67:	e8 1b 23 00 00       	call   c010be87 <memset>
    tf.tf_cs = KERNEL_CS;
c0109b6c:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0109b72:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0109b78:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0109b7c:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0109b80:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0109b84:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0109b88:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b8b:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0109b8e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109b91:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0109b94:	b8 78 93 10 c0       	mov    $0xc0109378,%eax
c0109b99:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0109b9c:	8b 45 10             	mov    0x10(%ebp),%eax
c0109b9f:	89 c2                	mov    %eax,%edx
c0109ba1:	80 ce 01             	or     $0x1,%dh
c0109ba4:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0109ba7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109bab:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0109bb2:	00 
c0109bb3:	89 14 24             	mov    %edx,(%esp)
c0109bb6:	e8 27 03 00 00       	call   c0109ee2 <do_fork>
}
c0109bbb:	c9                   	leave  
c0109bbc:	c3                   	ret    

c0109bbd <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0109bbd:	55                   	push   %ebp
c0109bbe:	89 e5                	mov    %esp,%ebp
c0109bc0:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0109bc3:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0109bca:	e8 72 b5 ff ff       	call   c0105141 <alloc_pages>
c0109bcf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0109bd2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109bd6:	74 1a                	je     c0109bf2 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0109bd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109bdb:	89 04 24             	mov    %eax,(%esp)
c0109bde:	e8 1a f9 ff ff       	call   c01094fd <page2kva>
c0109be3:	89 c2                	mov    %eax,%edx
c0109be5:	8b 45 08             	mov    0x8(%ebp),%eax
c0109be8:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0109beb:	b8 00 00 00 00       	mov    $0x0,%eax
c0109bf0:	eb 05                	jmp    c0109bf7 <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0109bf2:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0109bf7:	c9                   	leave  
c0109bf8:	c3                   	ret    

c0109bf9 <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0109bf9:	55                   	push   %ebp
c0109bfa:	89 e5                	mov    %esp,%ebp
c0109bfc:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0109bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c02:	8b 40 0c             	mov    0xc(%eax),%eax
c0109c05:	89 04 24             	mov    %eax,(%esp)
c0109c08:	e8 44 f9 ff ff       	call   c0109551 <kva2page>
c0109c0d:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0109c14:	00 
c0109c15:	89 04 24             	mov    %eax,(%esp)
c0109c18:	e8 8f b5 ff ff       	call   c01051ac <free_pages>
}
c0109c1d:	c9                   	leave  
c0109c1e:	c3                   	ret    

c0109c1f <setup_pgdir>:

// setup_pgdir - alloc one page as PDT
static int
setup_pgdir(struct mm_struct *mm) {
c0109c1f:	55                   	push   %ebp
c0109c20:	89 e5                	mov    %esp,%ebp
c0109c22:	83 ec 28             	sub    $0x28,%esp
    struct Page *page;
    if ((page = alloc_page()) == NULL) {
c0109c25:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0109c2c:	e8 10 b5 ff ff       	call   c0105141 <alloc_pages>
c0109c31:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109c34:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109c38:	75 0a                	jne    c0109c44 <setup_pgdir+0x25>
        return -E_NO_MEM;
c0109c3a:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0109c3f:	e9 80 00 00 00       	jmp    c0109cc4 <setup_pgdir+0xa5>
    }
    pde_t *pgdir = page2kva(page);
c0109c44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109c47:	89 04 24             	mov    %eax,(%esp)
c0109c4a:	e8 ae f8 ff ff       	call   c01094fd <page2kva>
c0109c4f:	89 45 f0             	mov    %eax,-0x10(%ebp)
    memcpy(pgdir, boot_pgdir, PGSIZE);
c0109c52:	a1 e4 cd 19 c0       	mov    0xc019cde4,%eax
c0109c57:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0109c5e:	00 
c0109c5f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109c63:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c66:	89 04 24             	mov    %eax,(%esp)
c0109c69:	e8 18 23 00 00       	call   c010bf86 <memcpy>
    pgdir[PDX(VPT)] = PADDR(pgdir) | PTE_P | PTE_W;
c0109c6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c71:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0109c77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c7a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109c7d:	81 7d ec ff ff ff bf 	cmpl   $0xbfffffff,-0x14(%ebp)
c0109c84:	77 23                	ja     c0109ca9 <setup_pgdir+0x8a>
c0109c86:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c89:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109c8d:	c7 44 24 08 c0 e0 10 	movl   $0xc010e0c0,0x8(%esp)
c0109c94:	c0 
c0109c95:	c7 44 24 04 2e 01 00 	movl   $0x12e,0x4(%esp)
c0109c9c:	00 
c0109c9d:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c0109ca4:	e8 0f 71 ff ff       	call   c0100db8 <__panic>
c0109ca9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109cac:	05 00 00 00 40       	add    $0x40000000,%eax
c0109cb1:	83 c8 03             	or     $0x3,%eax
c0109cb4:	89 02                	mov    %eax,(%edx)
    mm->pgdir = pgdir;
c0109cb6:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cb9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109cbc:	89 50 0c             	mov    %edx,0xc(%eax)
    return 0;
c0109cbf:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109cc4:	c9                   	leave  
c0109cc5:	c3                   	ret    

c0109cc6 <put_pgdir>:

// put_pgdir - free the memory space of PDT
static void
put_pgdir(struct mm_struct *mm) {
c0109cc6:	55                   	push   %ebp
c0109cc7:	89 e5                	mov    %esp,%ebp
c0109cc9:	83 ec 18             	sub    $0x18,%esp
    free_page(kva2page(mm->pgdir));
c0109ccc:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ccf:	8b 40 0c             	mov    0xc(%eax),%eax
c0109cd2:	89 04 24             	mov    %eax,(%esp)
c0109cd5:	e8 77 f8 ff ff       	call   c0109551 <kva2page>
c0109cda:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0109ce1:	00 
c0109ce2:	89 04 24             	mov    %eax,(%esp)
c0109ce5:	e8 c2 b4 ff ff       	call   c01051ac <free_pages>
}
c0109cea:	c9                   	leave  
c0109ceb:	c3                   	ret    

c0109cec <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0109cec:	55                   	push   %ebp
c0109ced:	89 e5                	mov    %esp,%ebp
c0109cef:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm, *oldmm = current->mm;
c0109cf2:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0109cf7:	8b 40 18             	mov    0x18(%eax),%eax
c0109cfa:	89 45 ec             	mov    %eax,-0x14(%ebp)

    /* current is a kernel thread */
    if (oldmm == NULL) {
c0109cfd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109d01:	75 0a                	jne    c0109d0d <copy_mm+0x21>
        return 0;
c0109d03:	b8 00 00 00 00       	mov    $0x0,%eax
c0109d08:	e9 fb 00 00 00       	jmp    c0109e08 <copy_mm+0x11c>
    }
    if (clone_flags & CLONE_VM) {
c0109d0d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d10:	25 00 01 00 00       	and    $0x100,%eax
c0109d15:	85 c0                	test   %eax,%eax
c0109d17:	74 08                	je     c0109d21 <copy_mm+0x35>
        mm = oldmm;
c0109d19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d1c:	89 45 f4             	mov    %eax,-0xc(%ebp)
        goto good_mm;
c0109d1f:	eb 5d                	jmp    c0109d7e <copy_mm+0x92>
    }

    int ret = -E_NO_MEM;
c0109d21:	c7 45 f0 fc ff ff ff 	movl   $0xfffffffc,-0x10(%ebp)
    if ((mm = mm_create()) == NULL) {
c0109d28:	e8 a3 e2 ff ff       	call   c0107fd0 <mm_create>
c0109d2d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109d30:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0109d34:	0f 84 ca 00 00 00    	je     c0109e04 <copy_mm+0x118>
        goto bad_mm;
    }
    if (setup_pgdir(mm) != 0) {
c0109d3a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109d3d:	89 04 24             	mov    %eax,(%esp)
c0109d40:	e8 da fe ff ff       	call   c0109c1f <setup_pgdir>
c0109d45:	85 c0                	test   %eax,%eax
c0109d47:	0f 85 a9 00 00 00    	jne    c0109df6 <copy_mm+0x10a>
        goto bad_pgdir_cleanup_mm;
    }

    lock_mm(oldmm);
c0109d4d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d50:	89 04 24             	mov    %eax,(%esp)
c0109d53:	e8 77 f8 ff ff       	call   c01095cf <lock_mm>
    {
        ret = dup_mmap(mm, oldmm);
c0109d58:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d5b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109d5f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109d62:	89 04 24             	mov    %eax,(%esp)
c0109d65:	e8 80 e7 ff ff       	call   c01084ea <dup_mmap>
c0109d6a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    unlock_mm(oldmm);
c0109d6d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109d70:	89 04 24             	mov    %eax,(%esp)
c0109d73:	e8 73 f8 ff ff       	call   c01095eb <unlock_mm>

    if (ret != 0) {
c0109d78:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109d7c:	75 5f                	jne    c0109ddd <copy_mm+0xf1>
        goto bad_dup_cleanup_mmap;
    }

good_mm:
    mm_count_inc(mm);
c0109d7e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109d81:	89 04 24             	mov    %eax,(%esp)
c0109d84:	e8 12 f8 ff ff       	call   c010959b <mm_count_inc>
    proc->mm = mm;
c0109d89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d8c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109d8f:	89 50 18             	mov    %edx,0x18(%eax)
    proc->cr3 = PADDR(mm->pgdir);
c0109d92:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109d95:	8b 40 0c             	mov    0xc(%eax),%eax
c0109d98:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109d9b:	81 7d e8 ff ff ff bf 	cmpl   $0xbfffffff,-0x18(%ebp)
c0109da2:	77 23                	ja     c0109dc7 <copy_mm+0xdb>
c0109da4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109da7:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109dab:	c7 44 24 08 c0 e0 10 	movl   $0xc010e0c0,0x8(%esp)
c0109db2:	c0 
c0109db3:	c7 44 24 04 5d 01 00 	movl   $0x15d,0x4(%esp)
c0109dba:	00 
c0109dbb:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c0109dc2:	e8 f1 6f ff ff       	call   c0100db8 <__panic>
c0109dc7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109dca:	8d 90 00 00 00 40    	lea    0x40000000(%eax),%edx
c0109dd0:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109dd3:	89 50 40             	mov    %edx,0x40(%eax)
    return 0;
c0109dd6:	b8 00 00 00 00       	mov    $0x0,%eax
c0109ddb:	eb 2b                	jmp    c0109e08 <copy_mm+0x11c>
        ret = dup_mmap(mm, oldmm);
    }
    unlock_mm(oldmm);

    if (ret != 0) {
        goto bad_dup_cleanup_mmap;
c0109ddd:	90                   	nop
    mm_count_inc(mm);
    proc->mm = mm;
    proc->cr3 = PADDR(mm->pgdir);
    return 0;
bad_dup_cleanup_mmap:
    exit_mmap(mm);
c0109dde:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109de1:	89 04 24             	mov    %eax,(%esp)
c0109de4:	e8 02 e8 ff ff       	call   c01085eb <exit_mmap>
    put_pgdir(mm);
c0109de9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109dec:	89 04 24             	mov    %eax,(%esp)
c0109def:	e8 d2 fe ff ff       	call   c0109cc6 <put_pgdir>
c0109df4:	eb 01                	jmp    c0109df7 <copy_mm+0x10b>
    int ret = -E_NO_MEM;
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    if (setup_pgdir(mm) != 0) {
        goto bad_pgdir_cleanup_mm;
c0109df6:	90                   	nop
    return 0;
bad_dup_cleanup_mmap:
    exit_mmap(mm);
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c0109df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109dfa:	89 04 24             	mov    %eax,(%esp)
c0109dfd:	e8 28 e5 ff ff       	call   c010832a <mm_destroy>
c0109e02:	eb 01                	jmp    c0109e05 <copy_mm+0x119>
        goto good_mm;
    }

    int ret = -E_NO_MEM;
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
c0109e04:	90                   	nop
    exit_mmap(mm);
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    return ret;
c0109e05:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0109e08:	c9                   	leave  
c0109e09:	c3                   	ret    

c0109e0a <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0109e0a:	55                   	push   %ebp
c0109e0b:	89 e5                	mov    %esp,%ebp
c0109e0d:	57                   	push   %edi
c0109e0e:	56                   	push   %esi
c0109e0f:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0109e10:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e13:	8b 40 0c             	mov    0xc(%eax),%eax
c0109e16:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0109e1b:	89 c2                	mov    %eax,%edx
c0109e1d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e20:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0109e23:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e26:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109e29:	8b 55 10             	mov    0x10(%ebp),%edx
c0109e2c:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0109e31:	89 c1                	mov    %eax,%ecx
c0109e33:	83 e1 01             	and    $0x1,%ecx
c0109e36:	85 c9                	test   %ecx,%ecx
c0109e38:	74 0e                	je     c0109e48 <copy_thread+0x3e>
c0109e3a:	0f b6 0a             	movzbl (%edx),%ecx
c0109e3d:	88 08                	mov    %cl,(%eax)
c0109e3f:	83 c0 01             	add    $0x1,%eax
c0109e42:	83 c2 01             	add    $0x1,%edx
c0109e45:	83 eb 01             	sub    $0x1,%ebx
c0109e48:	89 c1                	mov    %eax,%ecx
c0109e4a:	83 e1 02             	and    $0x2,%ecx
c0109e4d:	85 c9                	test   %ecx,%ecx
c0109e4f:	74 0f                	je     c0109e60 <copy_thread+0x56>
c0109e51:	0f b7 0a             	movzwl (%edx),%ecx
c0109e54:	66 89 08             	mov    %cx,(%eax)
c0109e57:	83 c0 02             	add    $0x2,%eax
c0109e5a:	83 c2 02             	add    $0x2,%edx
c0109e5d:	83 eb 02             	sub    $0x2,%ebx
c0109e60:	89 d9                	mov    %ebx,%ecx
c0109e62:	c1 e9 02             	shr    $0x2,%ecx
c0109e65:	89 c7                	mov    %eax,%edi
c0109e67:	89 d6                	mov    %edx,%esi
c0109e69:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109e6b:	89 f2                	mov    %esi,%edx
c0109e6d:	89 f8                	mov    %edi,%eax
c0109e6f:	b9 00 00 00 00       	mov    $0x0,%ecx
c0109e74:	89 de                	mov    %ebx,%esi
c0109e76:	83 e6 02             	and    $0x2,%esi
c0109e79:	85 f6                	test   %esi,%esi
c0109e7b:	74 0b                	je     c0109e88 <copy_thread+0x7e>
c0109e7d:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0109e81:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0109e85:	83 c1 02             	add    $0x2,%ecx
c0109e88:	83 e3 01             	and    $0x1,%ebx
c0109e8b:	85 db                	test   %ebx,%ebx
c0109e8d:	74 07                	je     c0109e96 <copy_thread+0x8c>
c0109e8f:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0109e93:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0109e96:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e99:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109e9c:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0109ea3:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ea6:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109ea9:	8b 55 0c             	mov    0xc(%ebp),%edx
c0109eac:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0109eaf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109eb2:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109eb5:	8b 55 08             	mov    0x8(%ebp),%edx
c0109eb8:	8b 52 3c             	mov    0x3c(%edx),%edx
c0109ebb:	8b 52 40             	mov    0x40(%edx),%edx
c0109ebe:	80 ce 02             	or     $0x2,%dh
c0109ec1:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0109ec4:	ba 12 9a 10 c0       	mov    $0xc0109a12,%edx
c0109ec9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ecc:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0109ecf:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ed2:	8b 40 3c             	mov    0x3c(%eax),%eax
c0109ed5:	89 c2                	mov    %eax,%edx
c0109ed7:	8b 45 08             	mov    0x8(%ebp),%eax
c0109eda:	89 50 20             	mov    %edx,0x20(%eax)
}
c0109edd:	5b                   	pop    %ebx
c0109ede:	5e                   	pop    %esi
c0109edf:	5f                   	pop    %edi
c0109ee0:	5d                   	pop    %ebp
c0109ee1:	c3                   	ret    

c0109ee2 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0109ee2:	55                   	push   %ebp
c0109ee3:	89 e5                	mov    %esp,%ebp
c0109ee5:	83 ec 28             	sub    $0x28,%esp
    int ret = -E_NO_FREE_PROC;
c0109ee8:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0109eef:	a1 a0 ee 19 c0       	mov    0xc019eea0,%eax
c0109ef4:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0109ef9:	0f 8f ef 00 00 00    	jg     c0109fee <do_fork+0x10c>
        goto fork_out;
    }
    ret = -E_NO_MEM;
c0109eff:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    *    -------------------
	*    update step 1: set child proc's parent to current process, make sure current process's wait_state is 0
	*    update step 5: insert proc_struct into hash_list && proc_list, set the relation links of process
    */

    proc = alloc_proc();
c0109f06:	e8 fc f6 ff ff       	call   c0109607 <alloc_proc>
c0109f0b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (proc == NULL)
c0109f0e:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109f12:	0f 84 d9 00 00 00    	je     c0109ff1 <do_fork+0x10f>
        goto fork_out;

    int ret2;
    ret2 = setup_kstack(proc);
c0109f18:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f1b:	89 04 24             	mov    %eax,(%esp)
c0109f1e:	e8 9a fc ff ff       	call   c0109bbd <setup_kstack>
c0109f23:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (ret2 != 0)
c0109f26:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109f2a:	0f 85 d5 00 00 00    	jne    c010a005 <do_fork+0x123>
        goto bad_fork_cleanup_proc;

    ret2 = copy_mm(clone_flags, proc);
c0109f30:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f33:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f37:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f3a:	89 04 24             	mov    %eax,(%esp)
c0109f3d:	e8 aa fd ff ff       	call   c0109cec <copy_mm>
c0109f42:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (ret2 != 0)
c0109f45:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0109f49:	0f 85 a8 00 00 00    	jne    c0109ff7 <do_fork+0x115>
        goto bad_fork_cleanup_kstack;

    copy_thread(proc, stack, tf);
c0109f4f:	8b 45 10             	mov    0x10(%ebp),%eax
c0109f52:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109f56:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109f59:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109f5d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f60:	89 04 24             	mov    %eax,(%esp)
c0109f63:	e8 a2 fe ff ff       	call   c0109e0a <copy_thread>

    bool intr_flag;
    local_intr_save(intr_flag);
c0109f68:	e8 61 f4 ff ff       	call   c01093ce <__intr_save>
c0109f6d:	89 45 e8             	mov    %eax,-0x18(%ebp)
    {
        proc->pid = get_pid();
c0109f70:	e8 30 f9 ff ff       	call   c01098a5 <get_pid>
c0109f75:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109f78:	89 42 04             	mov    %eax,0x4(%edx)
        proc->parent = current;
c0109f7b:	8b 15 88 ce 19 c0    	mov    0xc019ce88,%edx
c0109f81:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f84:	89 50 14             	mov    %edx,0x14(%eax)
        assert(current->wait_state == 0);
c0109f87:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c0109f8c:	8b 40 6c             	mov    0x6c(%eax),%eax
c0109f8f:	85 c0                	test   %eax,%eax
c0109f91:	74 24                	je     c0109fb7 <do_fork+0xd5>
c0109f93:	c7 44 24 0c f8 e0 10 	movl   $0xc010e0f8,0xc(%esp)
c0109f9a:	c0 
c0109f9b:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c0109fa2:	c0 
c0109fa3:	c7 44 24 04 b9 01 00 	movl   $0x1b9,0x4(%esp)
c0109faa:	00 
c0109fab:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c0109fb2:	e8 01 6e ff ff       	call   c0100db8 <__panic>

        set_links(proc);
c0109fb7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109fba:	89 04 24             	mov    %eax,(%esp)
c0109fbd:	e8 bb f7 ff ff       	call   c010977d <set_links>
        hash_proc(proc);
c0109fc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109fc5:	89 04 24             	mov    %eax,(%esp)
c0109fc8:	e8 5d fa ff ff       	call   c0109a2a <hash_proc>
    }
    local_intr_restore(intr_flag);
c0109fcd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109fd0:	89 04 24             	mov    %eax,(%esp)
c0109fd3:	e8 25 f4 ff ff       	call   c01093fd <__intr_restore>

    wakeup_proc(proc);
c0109fd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109fdb:	89 04 24             	mov    %eax,(%esp)
c0109fde:	e8 2b 10 00 00       	call   c010b00e <wakeup_proc>

    ret = proc->pid;
c0109fe3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109fe6:	8b 40 04             	mov    0x4(%eax),%eax
c0109fe9:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109fec:	eb 04                	jmp    c0109ff2 <do_fork+0x110>
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
c0109fee:	90                   	nop
c0109fef:	eb 01                	jmp    c0109ff2 <do_fork+0x110>
	*    update step 5: insert proc_struct into hash_list && proc_list, set the relation links of process
    */

    proc = alloc_proc();
    if (proc == NULL)
        goto fork_out;
c0109ff1:	90                   	nop
    wakeup_proc(proc);

    ret = proc->pid;

fork_out:
    return ret;
c0109ff2:	8b 45 f4             	mov    -0xc(%ebp),%eax
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
c0109ff5:	c9                   	leave  
c0109ff6:	c3                   	ret    
    if (ret2 != 0)
        goto bad_fork_cleanup_proc;

    ret2 = copy_mm(clone_flags, proc);
    if (ret2 != 0)
        goto bad_fork_cleanup_kstack;
c0109ff7:	90                   	nop

fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0109ff8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109ffb:	89 04 24             	mov    %eax,(%esp)
c0109ffe:	e8 f6 fb ff ff       	call   c0109bf9 <put_kstack>
c010a003:	eb 01                	jmp    c010a006 <do_fork+0x124>
        goto fork_out;

    int ret2;
    ret2 = setup_kstack(proc);
    if (ret2 != 0)
        goto bad_fork_cleanup_proc;
c010a005:	90                   	nop
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c010a006:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a009:	89 04 24             	mov    %eax,(%esp)
c010a00c:	e8 c4 ac ff ff       	call   c0104cd5 <kfree>
    goto fork_out;
c010a011:	eb df                	jmp    c0109ff2 <do_fork+0x110>

c010a013 <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c010a013:	55                   	push   %ebp
c010a014:	89 e5                	mov    %esp,%ebp
c010a016:	83 ec 28             	sub    $0x28,%esp
    if (current == idleproc) {
c010a019:	8b 15 88 ce 19 c0    	mov    0xc019ce88,%edx
c010a01f:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010a024:	39 c2                	cmp    %eax,%edx
c010a026:	75 1c                	jne    c010a044 <do_exit+0x31>
        panic("idleproc exit.\n");
c010a028:	c7 44 24 08 26 e1 10 	movl   $0xc010e126,0x8(%esp)
c010a02f:	c0 
c010a030:	c7 44 24 04 d5 01 00 	movl   $0x1d5,0x4(%esp)
c010a037:	00 
c010a038:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a03f:	e8 74 6d ff ff       	call   c0100db8 <__panic>
    }
    if (current == initproc) {
c010a044:	8b 15 88 ce 19 c0    	mov    0xc019ce88,%edx
c010a04a:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010a04f:	39 c2                	cmp    %eax,%edx
c010a051:	75 1c                	jne    c010a06f <do_exit+0x5c>
        panic("initproc exit.\n");
c010a053:	c7 44 24 08 36 e1 10 	movl   $0xc010e136,0x8(%esp)
c010a05a:	c0 
c010a05b:	c7 44 24 04 d8 01 00 	movl   $0x1d8,0x4(%esp)
c010a062:	00 
c010a063:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a06a:	e8 49 6d ff ff       	call   c0100db8 <__panic>
    }
    
    struct mm_struct *mm = current->mm;
c010a06f:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a074:	8b 40 18             	mov    0x18(%eax),%eax
c010a077:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (mm != NULL) {
c010a07a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a07e:	74 4a                	je     c010a0ca <do_exit+0xb7>
        lcr3(boot_cr3);
c010a080:	a1 c8 ee 19 c0       	mov    0xc019eec8,%eax
c010a085:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010a088:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a08b:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c010a08e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a091:	89 04 24             	mov    %eax,(%esp)
c010a094:	e8 1c f5 ff ff       	call   c01095b5 <mm_count_dec>
c010a099:	85 c0                	test   %eax,%eax
c010a09b:	75 21                	jne    c010a0be <do_exit+0xab>
            exit_mmap(mm);
c010a09d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a0a0:	89 04 24             	mov    %eax,(%esp)
c010a0a3:	e8 43 e5 ff ff       	call   c01085eb <exit_mmap>
            put_pgdir(mm);
c010a0a8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a0ab:	89 04 24             	mov    %eax,(%esp)
c010a0ae:	e8 13 fc ff ff       	call   c0109cc6 <put_pgdir>
            mm_destroy(mm);
c010a0b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a0b6:	89 04 24             	mov    %eax,(%esp)
c010a0b9:	e8 6c e2 ff ff       	call   c010832a <mm_destroy>
        }
        current->mm = NULL;
c010a0be:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a0c3:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    current->state = PROC_ZOMBIE;
c010a0ca:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a0cf:	c7 00 03 00 00 00    	movl   $0x3,(%eax)
    current->exit_code = error_code;
c010a0d5:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a0da:	8b 55 08             	mov    0x8(%ebp),%edx
c010a0dd:	89 50 68             	mov    %edx,0x68(%eax)
    
    bool intr_flag;
    struct proc_struct *proc;
    local_intr_save(intr_flag);
c010a0e0:	e8 e9 f2 ff ff       	call   c01093ce <__intr_save>
c010a0e5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        proc = current->parent;
c010a0e8:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a0ed:	8b 40 14             	mov    0x14(%eax),%eax
c010a0f0:	89 45 ec             	mov    %eax,-0x14(%ebp)
        if (proc->wait_state == WT_CHILD) {
c010a0f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a0f6:	8b 40 6c             	mov    0x6c(%eax),%eax
c010a0f9:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c010a0fe:	0f 85 98 00 00 00    	jne    c010a19c <do_exit+0x189>
            wakeup_proc(proc);
c010a104:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a107:	89 04 24             	mov    %eax,(%esp)
c010a10a:	e8 ff 0e 00 00       	call   c010b00e <wakeup_proc>
        }
        while (current->cptr != NULL) {
c010a10f:	e9 88 00 00 00       	jmp    c010a19c <do_exit+0x189>
            proc = current->cptr;
c010a114:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a119:	8b 40 70             	mov    0x70(%eax),%eax
c010a11c:	89 45 ec             	mov    %eax,-0x14(%ebp)
            current->cptr = proc->optr;
c010a11f:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a124:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a127:	8b 52 78             	mov    0x78(%edx),%edx
c010a12a:	89 50 70             	mov    %edx,0x70(%eax)
    
            proc->yptr = NULL;
c010a12d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a130:	c7 40 74 00 00 00 00 	movl   $0x0,0x74(%eax)
            if ((proc->optr = initproc->cptr) != NULL) {
c010a137:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010a13c:	8b 50 70             	mov    0x70(%eax),%edx
c010a13f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a142:	89 50 78             	mov    %edx,0x78(%eax)
c010a145:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a148:	8b 40 78             	mov    0x78(%eax),%eax
c010a14b:	85 c0                	test   %eax,%eax
c010a14d:	74 0e                	je     c010a15d <do_exit+0x14a>
                initproc->cptr->yptr = proc;
c010a14f:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010a154:	8b 40 70             	mov    0x70(%eax),%eax
c010a157:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a15a:	89 50 74             	mov    %edx,0x74(%eax)
            }
            proc->parent = initproc;
c010a15d:	8b 15 84 ce 19 c0    	mov    0xc019ce84,%edx
c010a163:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a166:	89 50 14             	mov    %edx,0x14(%eax)
            initproc->cptr = proc;
c010a169:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010a16e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010a171:	89 50 70             	mov    %edx,0x70(%eax)
            if (proc->state == PROC_ZOMBIE) {
c010a174:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a177:	8b 00                	mov    (%eax),%eax
c010a179:	83 f8 03             	cmp    $0x3,%eax
c010a17c:	75 1f                	jne    c010a19d <do_exit+0x18a>
                if (initproc->wait_state == WT_CHILD) {
c010a17e:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010a183:	8b 40 6c             	mov    0x6c(%eax),%eax
c010a186:	3d 01 00 00 80       	cmp    $0x80000001,%eax
c010a18b:	75 10                	jne    c010a19d <do_exit+0x18a>
                    wakeup_proc(initproc);
c010a18d:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010a192:	89 04 24             	mov    %eax,(%esp)
c010a195:	e8 74 0e 00 00       	call   c010b00e <wakeup_proc>
c010a19a:	eb 01                	jmp    c010a19d <do_exit+0x18a>
    {
        proc = current->parent;
        if (proc->wait_state == WT_CHILD) {
            wakeup_proc(proc);
        }
        while (current->cptr != NULL) {
c010a19c:	90                   	nop
c010a19d:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a1a2:	8b 40 70             	mov    0x70(%eax),%eax
c010a1a5:	85 c0                	test   %eax,%eax
c010a1a7:	0f 85 67 ff ff ff    	jne    c010a114 <do_exit+0x101>
                    wakeup_proc(initproc);
                }
            }
        }
    }
    local_intr_restore(intr_flag);
c010a1ad:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a1b0:	89 04 24             	mov    %eax,(%esp)
c010a1b3:	e8 45 f2 ff ff       	call   c01093fd <__intr_restore>
    
    schedule();
c010a1b8:	e8 d5 0e 00 00       	call   c010b092 <schedule>
    panic("do_exit will not return!! %d.\n", current->pid);
c010a1bd:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a1c2:	8b 40 04             	mov    0x4(%eax),%eax
c010a1c5:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a1c9:	c7 44 24 08 48 e1 10 	movl   $0xc010e148,0x8(%esp)
c010a1d0:	c0 
c010a1d1:	c7 44 24 04 04 02 00 	movl   $0x204,0x4(%esp)
c010a1d8:	00 
c010a1d9:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a1e0:	e8 d3 6b ff ff       	call   c0100db8 <__panic>

c010a1e5 <load_icode>:
/* load_icode - load the content of binary program(ELF format) as the new content of current process
 * @binary:  the memory addr of the content of binary program
 * @size:  the size of the content of binary program
 */
static int
load_icode(unsigned char *binary, size_t size) {
c010a1e5:	55                   	push   %ebp
c010a1e6:	89 e5                	mov    %esp,%ebp
c010a1e8:	83 ec 78             	sub    $0x78,%esp
    if (current->mm != NULL) {
c010a1eb:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a1f0:	8b 40 18             	mov    0x18(%eax),%eax
c010a1f3:	85 c0                	test   %eax,%eax
c010a1f5:	74 1c                	je     c010a213 <load_icode+0x2e>
        panic("load_icode: current->mm must be empty.\n");
c010a1f7:	c7 44 24 08 68 e1 10 	movl   $0xc010e168,0x8(%esp)
c010a1fe:	c0 
c010a1ff:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c010a206:	00 
c010a207:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a20e:	e8 a5 6b ff ff       	call   c0100db8 <__panic>
    }

    int ret = -E_NO_MEM;
c010a213:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
c010a21a:	e8 b1 dd ff ff       	call   c0107fd0 <mm_create>
c010a21f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010a222:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010a226:	0f 84 26 06 00 00    	je     c010a852 <load_icode+0x66d>
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
c010a22c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a22f:	89 04 24             	mov    %eax,(%esp)
c010a232:	e8 e8 f9 ff ff       	call   c0109c1f <setup_pgdir>
c010a237:	85 c0                	test   %eax,%eax
c010a239:	0f 85 05 06 00 00    	jne    c010a844 <load_icode+0x65f>
        goto bad_pgdir_cleanup_mm;
    }
    //(3) copy TEXT/DATA section, build BSS parts in binary to memory space of process
    struct Page *page;
    //(3.1) get the file header of the bianry program (ELF format)
    struct elfhdr *elf = (struct elfhdr *)binary;
c010a23f:	8b 45 08             	mov    0x8(%ebp),%eax
c010a242:	89 45 cc             	mov    %eax,-0x34(%ebp)
    //(3.2) get the entry of the program section headers of the bianry program (ELF format)
    struct proghdr *ph = (struct proghdr *)(binary + elf->e_phoff);
c010a245:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a248:	8b 40 1c             	mov    0x1c(%eax),%eax
c010a24b:	03 45 08             	add    0x8(%ebp),%eax
c010a24e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    //(3.3) This program is valid?
    if (elf->e_magic != ELF_MAGIC) {
c010a251:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a254:	8b 00                	mov    (%eax),%eax
c010a256:	3d 7f 45 4c 46       	cmp    $0x464c457f,%eax
c010a25b:	74 0c                	je     c010a269 <load_icode+0x84>
        ret = -E_INVAL_ELF;
c010a25d:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
        goto bad_elf_cleanup_pgdir;
c010a264:	e9 ce 05 00 00       	jmp    c010a837 <load_icode+0x652>
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
c010a269:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a26c:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c010a270:	0f b7 c0             	movzwl %ax,%eax
c010a273:	c1 e0 05             	shl    $0x5,%eax
c010a276:	03 45 ec             	add    -0x14(%ebp),%eax
c010a279:	89 45 c8             	mov    %eax,-0x38(%ebp)
    for (; ph < ph_end; ph ++) {
c010a27c:	e9 1d 03 00 00       	jmp    c010a59e <load_icode+0x3b9>
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
c010a281:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a284:	8b 00                	mov    (%eax),%eax
c010a286:	83 f8 01             	cmp    $0x1,%eax
c010a289:	0f 85 04 03 00 00    	jne    c010a593 <load_icode+0x3ae>
            continue ;
        }
        if (ph->p_filesz > ph->p_memsz) {
c010a28f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a292:	8b 50 10             	mov    0x10(%eax),%edx
c010a295:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a298:	8b 40 14             	mov    0x14(%eax),%eax
c010a29b:	39 c2                	cmp    %eax,%edx
c010a29d:	76 0c                	jbe    c010a2ab <load_icode+0xc6>
            ret = -E_INVAL_ELF;
c010a29f:	c7 45 f4 f8 ff ff ff 	movl   $0xfffffff8,-0xc(%ebp)
            goto bad_cleanup_mmap;
c010a2a6:	e9 81 05 00 00       	jmp    c010a82c <load_icode+0x647>
        }
        if (ph->p_filesz == 0) {
c010a2ab:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2ae:	8b 40 10             	mov    0x10(%eax),%eax
c010a2b1:	85 c0                	test   %eax,%eax
c010a2b3:	0f 84 dd 02 00 00    	je     c010a596 <load_icode+0x3b1>
            continue ;
        }
    //(3.5) call mm_map fun to setup the new vma ( ph->p_va, ph->p_memsz)
        vm_flags = 0, perm = PTE_U;
c010a2b9:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c010a2c0:	c7 45 e4 04 00 00 00 	movl   $0x4,-0x1c(%ebp)
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
c010a2c7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2ca:	8b 40 18             	mov    0x18(%eax),%eax
c010a2cd:	83 e0 01             	and    $0x1,%eax
c010a2d0:	84 c0                	test   %al,%al
c010a2d2:	74 04                	je     c010a2d8 <load_icode+0xf3>
c010a2d4:	83 4d e8 04          	orl    $0x4,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
c010a2d8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2db:	8b 40 18             	mov    0x18(%eax),%eax
c010a2de:	83 e0 02             	and    $0x2,%eax
c010a2e1:	85 c0                	test   %eax,%eax
c010a2e3:	74 04                	je     c010a2e9 <load_icode+0x104>
c010a2e5:	83 4d e8 02          	orl    $0x2,-0x18(%ebp)
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
c010a2e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a2ec:	8b 40 18             	mov    0x18(%eax),%eax
c010a2ef:	83 e0 04             	and    $0x4,%eax
c010a2f2:	85 c0                	test   %eax,%eax
c010a2f4:	74 04                	je     c010a2fa <load_icode+0x115>
c010a2f6:	83 4d e8 01          	orl    $0x1,-0x18(%ebp)
        if (vm_flags & VM_WRITE) perm |= PTE_W;
c010a2fa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a2fd:	83 e0 02             	and    $0x2,%eax
c010a300:	85 c0                	test   %eax,%eax
c010a302:	74 04                	je     c010a308 <load_icode+0x123>
c010a304:	83 4d e4 02          	orl    $0x2,-0x1c(%ebp)
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
c010a308:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a30b:	8b 50 14             	mov    0x14(%eax),%edx
c010a30e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a311:	8b 40 08             	mov    0x8(%eax),%eax
c010a314:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a31b:	00 
c010a31c:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010a31f:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010a323:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a327:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a32b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a32e:	89 04 24             	mov    %eax,(%esp)
c010a331:	e8 96 e0 ff ff       	call   c01083cc <mm_map>
c010a336:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a339:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a33d:	0f 85 df 04 00 00    	jne    c010a822 <load_icode+0x63d>
            goto bad_cleanup_mmap;
        }
        unsigned char *from = binary + ph->p_offset;
c010a343:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a346:	8b 40 04             	mov    0x4(%eax),%eax
c010a349:	03 45 08             	add    0x8(%ebp),%eax
c010a34c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        size_t off, size;
        uintptr_t start = ph->p_va, end, la = ROUNDDOWN(start, PGSIZE);
c010a34f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a352:	8b 40 08             	mov    0x8(%eax),%eax
c010a355:	89 45 d8             	mov    %eax,-0x28(%ebp)
c010a358:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a35b:	89 45 c4             	mov    %eax,-0x3c(%ebp)
c010a35e:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010a361:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010a366:	89 45 d4             	mov    %eax,-0x2c(%ebp)

        ret = -E_NO_MEM;
c010a369:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
c010a370:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a373:	8b 50 08             	mov    0x8(%eax),%edx
c010a376:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a379:	8b 40 10             	mov    0x10(%eax),%eax
c010a37c:	01 d0                	add    %edx,%eax
c010a37e:	89 45 c0             	mov    %eax,-0x40(%ebp)
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c010a381:	e9 91 00 00 00       	jmp    c010a417 <load_icode+0x232>
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a386:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a389:	8b 40 0c             	mov    0xc(%eax),%eax
c010a38c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a38f:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a393:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a396:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a39a:	89 04 24             	mov    %eax,(%esp)
c010a39d:	e8 76 bc ff ff       	call   c0106018 <pgdir_alloc_page>
c010a3a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a3a5:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a3a9:	0f 84 76 04 00 00    	je     c010a825 <load_icode+0x640>
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a3af:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a3b2:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a3b5:	89 d1                	mov    %edx,%ecx
c010a3b7:	29 c1                	sub    %eax,%ecx
c010a3b9:	89 c8                	mov    %ecx,%eax
c010a3bb:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a3be:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a3c3:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a3c6:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a3c9:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a3d0:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a3d3:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a3d6:	73 0f                	jae    c010a3e7 <load_icode+0x202>
                size -= la - end;
c010a3d8:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a3db:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a3de:	89 d1                	mov    %edx,%ecx
c010a3e0:	29 c1                	sub    %eax,%ecx
c010a3e2:	89 c8                	mov    %ecx,%eax
c010a3e4:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memcpy(page2kva(page) + off, from, size);
c010a3e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a3ea:	89 04 24             	mov    %eax,(%esp)
c010a3ed:	e8 0b f1 ff ff       	call   c01094fd <page2kva>
c010a3f2:	03 45 bc             	add    -0x44(%ebp),%eax
c010a3f5:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010a3f8:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a3fc:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010a3ff:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a403:	89 04 24             	mov    %eax,(%esp)
c010a406:	e8 7b 1b 00 00       	call   c010bf86 <memcpy>
            start += size, from += size;
c010a40b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a40e:	01 45 d8             	add    %eax,-0x28(%ebp)
c010a411:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a414:	01 45 e0             	add    %eax,-0x20(%ebp)
        ret = -E_NO_MEM;

     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
c010a417:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a41a:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a41d:	0f 82 63 ff ff ff    	jb     c010a386 <load_icode+0x1a1>
            memcpy(page2kva(page) + off, from, size);
            start += size, from += size;
        }

      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
c010a423:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a426:	8b 50 08             	mov    0x8(%eax),%edx
c010a429:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a42c:	8b 40 14             	mov    0x14(%eax),%eax
c010a42f:	01 d0                	add    %edx,%eax
c010a431:	89 45 c0             	mov    %eax,-0x40(%ebp)
        if (start < la) {
c010a434:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a437:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a43a:	0f 83 45 01 00 00    	jae    c010a585 <load_icode+0x3a0>
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
c010a440:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a443:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a446:	0f 84 4d 01 00 00    	je     c010a599 <load_icode+0x3b4>
                continue ;
            }
            off = start + PGSIZE - la, size = PGSIZE - off;
c010a44c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a44f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a452:	89 d1                	mov    %edx,%ecx
c010a454:	29 c1                	sub    %eax,%ecx
c010a456:	89 c8                	mov    %ecx,%eax
c010a458:	05 00 10 00 00       	add    $0x1000,%eax
c010a45d:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a460:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a465:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a468:	89 45 dc             	mov    %eax,-0x24(%ebp)
            if (end < la) {
c010a46b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a46e:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a471:	73 0f                	jae    c010a482 <load_icode+0x29d>
                size -= la - end;
c010a473:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a476:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a479:	89 d1                	mov    %edx,%ecx
c010a47b:	29 c1                	sub    %eax,%ecx
c010a47d:	89 c8                	mov    %ecx,%eax
c010a47f:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a482:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a485:	89 04 24             	mov    %eax,(%esp)
c010a488:	e8 70 f0 ff ff       	call   c01094fd <page2kva>
c010a48d:	03 45 bc             	add    -0x44(%ebp),%eax
c010a490:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010a493:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a497:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a49e:	00 
c010a49f:	89 04 24             	mov    %eax,(%esp)
c010a4a2:	e8 e0 19 00 00       	call   c010be87 <memset>
            start += size;
c010a4a7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a4aa:	01 45 d8             	add    %eax,-0x28(%ebp)
            assert((end < la && start == end) || (end >= la && start == la));
c010a4ad:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a4b0:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a4b3:	73 0c                	jae    c010a4c1 <load_icode+0x2dc>
c010a4b5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a4b8:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a4bb:	0f 84 c4 00 00 00    	je     c010a585 <load_icode+0x3a0>
c010a4c1:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a4c4:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a4c7:	72 0c                	jb     c010a4d5 <load_icode+0x2f0>
c010a4c9:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a4cc:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a4cf:	0f 84 b0 00 00 00    	je     c010a585 <load_icode+0x3a0>
c010a4d5:	c7 44 24 0c 90 e1 10 	movl   $0xc010e190,0xc(%esp)
c010a4dc:	c0 
c010a4dd:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010a4e4:	c0 
c010a4e5:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c010a4ec:	00 
c010a4ed:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a4f4:	e8 bf 68 ff ff       	call   c0100db8 <__panic>
        }
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
c010a4f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a4fc:	8b 40 0c             	mov    0xc(%eax),%eax
c010a4ff:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010a502:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a506:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010a509:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a50d:	89 04 24             	mov    %eax,(%esp)
c010a510:	e8 03 bb ff ff       	call   c0106018 <pgdir_alloc_page>
c010a515:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a518:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a51c:	0f 84 06 03 00 00    	je     c010a828 <load_icode+0x643>
                goto bad_cleanup_mmap;
            }
            off = start - la, size = PGSIZE - off, la += PGSIZE;
c010a522:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a525:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010a528:	89 d1                	mov    %edx,%ecx
c010a52a:	29 c1                	sub    %eax,%ecx
c010a52c:	89 c8                	mov    %ecx,%eax
c010a52e:	89 45 bc             	mov    %eax,-0x44(%ebp)
c010a531:	b8 00 10 00 00       	mov    $0x1000,%eax
c010a536:	2b 45 bc             	sub    -0x44(%ebp),%eax
c010a539:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010a53c:	81 45 d4 00 10 00 00 	addl   $0x1000,-0x2c(%ebp)
            if (end < la) {
c010a543:	8b 45 c0             	mov    -0x40(%ebp),%eax
c010a546:	3b 45 d4             	cmp    -0x2c(%ebp),%eax
c010a549:	73 0f                	jae    c010a55a <load_icode+0x375>
                size -= la - end;
c010a54b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010a54e:	8b 55 c0             	mov    -0x40(%ebp),%edx
c010a551:	89 d1                	mov    %edx,%ecx
c010a553:	29 c1                	sub    %eax,%ecx
c010a555:	89 c8                	mov    %ecx,%eax
c010a557:	01 45 dc             	add    %eax,-0x24(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
c010a55a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a55d:	89 04 24             	mov    %eax,(%esp)
c010a560:	e8 98 ef ff ff       	call   c01094fd <page2kva>
c010a565:	03 45 bc             	add    -0x44(%ebp),%eax
c010a568:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010a56b:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a56f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a576:	00 
c010a577:	89 04 24             	mov    %eax,(%esp)
c010a57a:	e8 08 19 00 00       	call   c010be87 <memset>
            start += size;
c010a57f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010a582:	01 45 d8             	add    %eax,-0x28(%ebp)
            }
            memset(page2kva(page) + off, 0, size);
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
c010a585:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010a588:	3b 45 c0             	cmp    -0x40(%ebp),%eax
c010a58b:	0f 82 68 ff ff ff    	jb     c010a4f9 <load_icode+0x314>
c010a591:	eb 07                	jmp    c010a59a <load_icode+0x3b5>
    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
    //(3.4) find every program section headers
        if (ph->p_type != ELF_PT_LOAD) {
            continue ;
c010a593:	90                   	nop
c010a594:	eb 04                	jmp    c010a59a <load_icode+0x3b5>
        if (ph->p_filesz > ph->p_memsz) {
            ret = -E_INVAL_ELF;
            goto bad_cleanup_mmap;
        }
        if (ph->p_filesz == 0) {
            continue ;
c010a596:	90                   	nop
c010a597:	eb 01                	jmp    c010a59a <load_icode+0x3b5>
      //(3.6.2) build BSS section of binary program
        end = ph->p_va + ph->p_memsz;
        if (start < la) {
            /* ph->p_memsz == ph->p_filesz */
            if (start == end) {
                continue ;
c010a599:	90                   	nop
        goto bad_elf_cleanup_pgdir;
    }

    uint32_t vm_flags, perm;
    struct proghdr *ph_end = ph + elf->e_phnum;
    for (; ph < ph_end; ph ++) {
c010a59a:	83 45 ec 20          	addl   $0x20,-0x14(%ebp)
c010a59e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a5a1:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010a5a4:	0f 82 d7 fc ff ff    	jb     c010a281 <load_icode+0x9c>
            memset(page2kva(page) + off, 0, size);
            start += size;
        }
    }
    //(4) build user stack memory
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
c010a5aa:	c7 45 e8 0b 00 00 00 	movl   $0xb,-0x18(%ebp)
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
c010a5b1:	c7 44 24 10 00 00 00 	movl   $0x0,0x10(%esp)
c010a5b8:	00 
c010a5b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010a5bc:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a5c0:	c7 44 24 08 00 00 10 	movl   $0x100000,0x8(%esp)
c010a5c7:	00 
c010a5c8:	c7 44 24 04 00 00 f0 	movl   $0xaff00000,0x4(%esp)
c010a5cf:	af 
c010a5d0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a5d3:	89 04 24             	mov    %eax,(%esp)
c010a5d6:	e8 f1 dd ff ff       	call   c01083cc <mm_map>
c010a5db:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010a5de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a5e2:	0f 85 43 02 00 00    	jne    c010a82b <load_icode+0x646>
        goto bad_cleanup_mmap;
    }
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-PGSIZE , PTE_USER) != NULL);
c010a5e8:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a5eb:	8b 40 0c             	mov    0xc(%eax),%eax
c010a5ee:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a5f5:	00 
c010a5f6:	c7 44 24 04 00 f0 ff 	movl   $0xaffff000,0x4(%esp)
c010a5fd:	af 
c010a5fe:	89 04 24             	mov    %eax,(%esp)
c010a601:	e8 12 ba ff ff       	call   c0106018 <pgdir_alloc_page>
c010a606:	85 c0                	test   %eax,%eax
c010a608:	75 24                	jne    c010a62e <load_icode+0x449>
c010a60a:	c7 44 24 0c cc e1 10 	movl   $0xc010e1cc,0xc(%esp)
c010a611:	c0 
c010a612:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010a619:	c0 
c010a61a:	c7 44 24 04 73 02 00 	movl   $0x273,0x4(%esp)
c010a621:	00 
c010a622:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a629:	e8 8a 67 ff ff       	call   c0100db8 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-2*PGSIZE , PTE_USER) != NULL);
c010a62e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a631:	8b 40 0c             	mov    0xc(%eax),%eax
c010a634:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a63b:	00 
c010a63c:	c7 44 24 04 00 e0 ff 	movl   $0xafffe000,0x4(%esp)
c010a643:	af 
c010a644:	89 04 24             	mov    %eax,(%esp)
c010a647:	e8 cc b9 ff ff       	call   c0106018 <pgdir_alloc_page>
c010a64c:	85 c0                	test   %eax,%eax
c010a64e:	75 24                	jne    c010a674 <load_icode+0x48f>
c010a650:	c7 44 24 0c 10 e2 10 	movl   $0xc010e210,0xc(%esp)
c010a657:	c0 
c010a658:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010a65f:	c0 
c010a660:	c7 44 24 04 74 02 00 	movl   $0x274,0x4(%esp)
c010a667:	00 
c010a668:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a66f:	e8 44 67 ff ff       	call   c0100db8 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-3*PGSIZE , PTE_USER) != NULL);
c010a674:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a677:	8b 40 0c             	mov    0xc(%eax),%eax
c010a67a:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a681:	00 
c010a682:	c7 44 24 04 00 d0 ff 	movl   $0xafffd000,0x4(%esp)
c010a689:	af 
c010a68a:	89 04 24             	mov    %eax,(%esp)
c010a68d:	e8 86 b9 ff ff       	call   c0106018 <pgdir_alloc_page>
c010a692:	85 c0                	test   %eax,%eax
c010a694:	75 24                	jne    c010a6ba <load_icode+0x4d5>
c010a696:	c7 44 24 0c 54 e2 10 	movl   $0xc010e254,0xc(%esp)
c010a69d:	c0 
c010a69e:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010a6a5:	c0 
c010a6a6:	c7 44 24 04 75 02 00 	movl   $0x275,0x4(%esp)
c010a6ad:	00 
c010a6ae:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a6b5:	e8 fe 66 ff ff       	call   c0100db8 <__panic>
    assert(pgdir_alloc_page(mm->pgdir, USTACKTOP-4*PGSIZE , PTE_USER) != NULL);
c010a6ba:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a6bd:	8b 40 0c             	mov    0xc(%eax),%eax
c010a6c0:	c7 44 24 08 07 00 00 	movl   $0x7,0x8(%esp)
c010a6c7:	00 
c010a6c8:	c7 44 24 04 00 c0 ff 	movl   $0xafffc000,0x4(%esp)
c010a6cf:	af 
c010a6d0:	89 04 24             	mov    %eax,(%esp)
c010a6d3:	e8 40 b9 ff ff       	call   c0106018 <pgdir_alloc_page>
c010a6d8:	85 c0                	test   %eax,%eax
c010a6da:	75 24                	jne    c010a700 <load_icode+0x51b>
c010a6dc:	c7 44 24 0c 98 e2 10 	movl   $0xc010e298,0xc(%esp)
c010a6e3:	c0 
c010a6e4:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010a6eb:	c0 
c010a6ec:	c7 44 24 04 76 02 00 	movl   $0x276,0x4(%esp)
c010a6f3:	00 
c010a6f4:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a6fb:	e8 b8 66 ff ff       	call   c0100db8 <__panic>
    
    //(5) set current process's mm, sr3, and set CR3 reg = physical addr of Page Directory
    mm_count_inc(mm);
c010a700:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a703:	89 04 24             	mov    %eax,(%esp)
c010a706:	e8 90 ee ff ff       	call   c010959b <mm_count_inc>
    current->mm = mm;
c010a70b:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a710:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a713:	89 50 18             	mov    %edx,0x18(%eax)
    current->cr3 = PADDR(mm->pgdir);
c010a716:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a71b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010a71e:	8b 52 0c             	mov    0xc(%edx),%edx
c010a721:	89 55 b8             	mov    %edx,-0x48(%ebp)
c010a724:	81 7d b8 ff ff ff bf 	cmpl   $0xbfffffff,-0x48(%ebp)
c010a72b:	77 23                	ja     c010a750 <load_icode+0x56b>
c010a72d:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010a730:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a734:	c7 44 24 08 c0 e0 10 	movl   $0xc010e0c0,0x8(%esp)
c010a73b:	c0 
c010a73c:	c7 44 24 04 7b 02 00 	movl   $0x27b,0x4(%esp)
c010a743:	00 
c010a744:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a74b:	e8 68 66 ff ff       	call   c0100db8 <__panic>
c010a750:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010a753:	81 c2 00 00 00 40    	add    $0x40000000,%edx
c010a759:	89 50 40             	mov    %edx,0x40(%eax)
    lcr3(PADDR(mm->pgdir));
c010a75c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a75f:	8b 40 0c             	mov    0xc(%eax),%eax
c010a762:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010a765:	81 7d b4 ff ff ff bf 	cmpl   $0xbfffffff,-0x4c(%ebp)
c010a76c:	77 23                	ja     c010a791 <load_icode+0x5ac>
c010a76e:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a771:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a775:	c7 44 24 08 c0 e0 10 	movl   $0xc010e0c0,0x8(%esp)
c010a77c:	c0 
c010a77d:	c7 44 24 04 7c 02 00 	movl   $0x27c,0x4(%esp)
c010a784:	00 
c010a785:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a78c:	e8 27 66 ff ff       	call   c0100db8 <__panic>
c010a791:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010a794:	05 00 00 00 40       	add    $0x40000000,%eax
c010a799:	89 45 ac             	mov    %eax,-0x54(%ebp)
c010a79c:	8b 45 ac             	mov    -0x54(%ebp),%eax
c010a79f:	0f 22 d8             	mov    %eax,%cr3

    //(6) setup trapframe for user environment
    struct trapframe *tf = current->tf;
c010a7a2:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a7a7:	8b 40 3c             	mov    0x3c(%eax),%eax
c010a7aa:	89 45 b0             	mov    %eax,-0x50(%ebp)
    memset(tf, 0, sizeof(struct trapframe));
c010a7ad:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c010a7b4:	00 
c010a7b5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a7bc:	00 
c010a7bd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7c0:	89 04 24             	mov    %eax,(%esp)
c010a7c3:	e8 bf 16 00 00       	call   c010be87 <memset>
     *          tf_ds=tf_es=tf_ss should be USER_DS segment
     *          tf_esp should be the top addr of user stack (USTACKTOP)
     *          tf_eip should be the entry point of this binary program (elf->e_entry)
     *          tf_eflags should be set to enable computer to produce Interrupt
     */
    tf->tf_cs = USER_CS;
c010a7c8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7cb:	66 c7 40 3c 1b 00    	movw   $0x1b,0x3c(%eax)
    tf->tf_ds = tf->tf_es = tf->tf_ss = USER_DS;
c010a7d1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7d4:	66 c7 40 48 23 00    	movw   $0x23,0x48(%eax)
c010a7da:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7dd:	0f b7 50 48          	movzwl 0x48(%eax),%edx
c010a7e1:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7e4:	66 89 50 28          	mov    %dx,0x28(%eax)
c010a7e8:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7eb:	0f b7 50 28          	movzwl 0x28(%eax),%edx
c010a7ef:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7f2:	66 89 50 2c          	mov    %dx,0x2c(%eax)
    tf->tf_esp = USTACKTOP;
c010a7f6:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a7f9:	c7 40 44 00 00 00 b0 	movl   $0xb0000000,0x44(%eax)
    tf->tf_eip = elf->e_entry;
c010a800:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010a803:	8b 50 18             	mov    0x18(%eax),%edx
c010a806:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a809:	89 50 38             	mov    %edx,0x38(%eax)
    tf->tf_eflags = FL_IF;
c010a80c:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010a80f:	c7 40 40 00 02 00 00 	movl   $0x200,0x40(%eax)

    ret = 0;
c010a816:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
out:
    return ret;
c010a81d:	8b 45 f4             	mov    -0xc(%ebp),%eax
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
}
c010a820:	c9                   	leave  
c010a821:	c3                   	ret    
        if (ph->p_flags & ELF_PF_X) vm_flags |= VM_EXEC;
        if (ph->p_flags & ELF_PF_W) vm_flags |= VM_WRITE;
        if (ph->p_flags & ELF_PF_R) vm_flags |= VM_READ;
        if (vm_flags & VM_WRITE) perm |= PTE_W;
        if ((ret = mm_map(mm, ph->p_va, ph->p_memsz, vm_flags, NULL)) != 0) {
            goto bad_cleanup_mmap;
c010a822:	90                   	nop
c010a823:	eb 07                	jmp    c010a82c <load_icode+0x647>
     //(3.6) alloc memory, and  copy the contents of every program section (from, from+end) to process's memory (la, la+end)
        end = ph->p_va + ph->p_filesz;
     //(3.6.1) copy TEXT/DATA section of bianry program
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
c010a825:	90                   	nop
c010a826:	eb 04                	jmp    c010a82c <load_icode+0x647>
            start += size;
            assert((end < la && start == end) || (end >= la && start == la));
        }
        while (start < end) {
            if ((page = pgdir_alloc_page(mm->pgdir, la, perm)) == NULL) {
                goto bad_cleanup_mmap;
c010a828:	90                   	nop
c010a829:	eb 01                	jmp    c010a82c <load_icode+0x647>
        }
    }
    //(4) build user stack memory
    vm_flags = VM_READ | VM_WRITE | VM_STACK;
    if ((ret = mm_map(mm, USTACKTOP - USTACKSIZE, USTACKSIZE, vm_flags, NULL)) != 0) {
        goto bad_cleanup_mmap;
c010a82b:	90                   	nop

    ret = 0;
out:
    return ret;
bad_cleanup_mmap:
    exit_mmap(mm);
c010a82c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a82f:	89 04 24             	mov    %eax,(%esp)
c010a832:	e8 b4 dd ff ff       	call   c01085eb <exit_mmap>
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
c010a837:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a83a:	89 04 24             	mov    %eax,(%esp)
c010a83d:	e8 84 f4 ff ff       	call   c0109cc6 <put_pgdir>
c010a842:	eb 01                	jmp    c010a845 <load_icode+0x660>
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
    }
    //(2) create a new PDT, and mm->pgdir= kernel virtual addr of PDT
    if (setup_pgdir(mm) != 0) {
        goto bad_pgdir_cleanup_mm;
c010a844:	90                   	nop
bad_cleanup_mmap:
    exit_mmap(mm);
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
c010a845:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010a848:	89 04 24             	mov    %eax,(%esp)
c010a84b:	e8 da da ff ff       	call   c010832a <mm_destroy>
bad_mm:
    goto out;
c010a850:	eb cb                	jmp    c010a81d <load_icode+0x638>

    int ret = -E_NO_MEM;
    struct mm_struct *mm;
    //(1) create a new mm for current process
    if ((mm = mm_create()) == NULL) {
        goto bad_mm;
c010a852:	90                   	nop
bad_elf_cleanup_pgdir:
    put_pgdir(mm);
bad_pgdir_cleanup_mm:
    mm_destroy(mm);
bad_mm:
    goto out;
c010a853:	eb c8                	jmp    c010a81d <load_icode+0x638>

c010a855 <do_execve>:
}

// do_execve - call exit_mmap(mm)&put_pgdir(mm) to reclaim memory space of current process
//           - call load_icode to setup new memory space accroding binary prog.
int
do_execve(const char *name, size_t len, unsigned char *binary, size_t size) {
c010a855:	55                   	push   %ebp
c010a856:	89 e5                	mov    %esp,%ebp
c010a858:	83 ec 38             	sub    $0x38,%esp
    struct mm_struct *mm = current->mm;
c010a85b:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a860:	8b 40 18             	mov    0x18(%eax),%eax
c010a863:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (!user_mem_check(mm, (uintptr_t)name, len, 0)) {
c010a866:	8b 45 08             	mov    0x8(%ebp),%eax
c010a869:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010a870:	00 
c010a871:	8b 55 0c             	mov    0xc(%ebp),%edx
c010a874:	89 54 24 08          	mov    %edx,0x8(%esp)
c010a878:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a87c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a87f:	89 04 24             	mov    %eax,(%esp)
c010a882:	e8 22 e8 ff ff       	call   c01090a9 <user_mem_check>
c010a887:	85 c0                	test   %eax,%eax
c010a889:	75 0a                	jne    c010a895 <do_execve+0x40>
        return -E_INVAL;
c010a88b:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a890:	e9 f6 00 00 00       	jmp    c010a98b <do_execve+0x136>
    }
    if (len > PROC_NAME_LEN) {
c010a895:	83 7d 0c 0f          	cmpl   $0xf,0xc(%ebp)
c010a899:	76 07                	jbe    c010a8a2 <do_execve+0x4d>
        len = PROC_NAME_LEN;
c010a89b:	c7 45 0c 0f 00 00 00 	movl   $0xf,0xc(%ebp)
    }

    char local_name[PROC_NAME_LEN + 1];
    memset(local_name, 0, sizeof(local_name));
c010a8a2:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c010a8a9:	00 
c010a8aa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010a8b1:	00 
c010a8b2:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a8b5:	89 04 24             	mov    %eax,(%esp)
c010a8b8:	e8 ca 15 00 00       	call   c010be87 <memset>
    memcpy(local_name, name, len);
c010a8bd:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a8c0:	89 44 24 08          	mov    %eax,0x8(%esp)
c010a8c4:	8b 45 08             	mov    0x8(%ebp),%eax
c010a8c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a8cb:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010a8ce:	89 04 24             	mov    %eax,(%esp)
c010a8d1:	e8 b0 16 00 00       	call   c010bf86 <memcpy>

    if (mm != NULL) {
c010a8d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010a8da:	74 4a                	je     c010a926 <do_execve+0xd1>
        lcr3(boot_cr3);
c010a8dc:	a1 c8 ee 19 c0       	mov    0xc019eec8,%eax
c010a8e1:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010a8e4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a8e7:	0f 22 d8             	mov    %eax,%cr3
        if (mm_count_dec(mm) == 0) {
c010a8ea:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8ed:	89 04 24             	mov    %eax,(%esp)
c010a8f0:	e8 c0 ec ff ff       	call   c01095b5 <mm_count_dec>
c010a8f5:	85 c0                	test   %eax,%eax
c010a8f7:	75 21                	jne    c010a91a <do_execve+0xc5>
            exit_mmap(mm);
c010a8f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a8fc:	89 04 24             	mov    %eax,(%esp)
c010a8ff:	e8 e7 dc ff ff       	call   c01085eb <exit_mmap>
            put_pgdir(mm);
c010a904:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a907:	89 04 24             	mov    %eax,(%esp)
c010a90a:	e8 b7 f3 ff ff       	call   c0109cc6 <put_pgdir>
            mm_destroy(mm);
c010a90f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010a912:	89 04 24             	mov    %eax,(%esp)
c010a915:	e8 10 da ff ff       	call   c010832a <mm_destroy>
        }
        current->mm = NULL;
c010a91a:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a91f:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
c010a926:	8b 45 14             	mov    0x14(%ebp),%eax
c010a929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a92d:	8b 45 10             	mov    0x10(%ebp),%eax
c010a930:	89 04 24             	mov    %eax,(%esp)
c010a933:	e8 ad f8 ff ff       	call   c010a1e5 <load_icode>
c010a938:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010a93b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010a93f:	75 1b                	jne    c010a95c <do_execve+0x107>
        goto execve_exit;
    }
    set_proc_name(current, local_name);
c010a941:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a946:	8d 55 dc             	lea    -0x24(%ebp),%edx
c010a949:	89 54 24 04          	mov    %edx,0x4(%esp)
c010a94d:	89 04 24             	mov    %eax,(%esp)
c010a950:	e8 a3 ed ff ff       	call   c01096f8 <set_proc_name>
    return 0;
c010a955:	b8 00 00 00 00       	mov    $0x0,%eax
c010a95a:	eb 2f                	jmp    c010a98b <do_execve+0x136>
        }
        current->mm = NULL;
    }
    int ret;
    if ((ret = load_icode(binary, size)) != 0) {
        goto execve_exit;
c010a95c:	90                   	nop
    }
    set_proc_name(current, local_name);
    return 0;

execve_exit:
    do_exit(ret);
c010a95d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a960:	89 04 24             	mov    %eax,(%esp)
c010a963:	e8 ab f6 ff ff       	call   c010a013 <do_exit>
    panic("already exit: %e.\n", ret);
c010a968:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010a96b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010a96f:	c7 44 24 08 db e2 10 	movl   $0xc010e2db,0x8(%esp)
c010a976:	c0 
c010a977:	c7 44 24 04 bf 02 00 	movl   $0x2bf,0x4(%esp)
c010a97e:	00 
c010a97f:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010a986:	e8 2d 64 ff ff       	call   c0100db8 <__panic>
}
c010a98b:	c9                   	leave  
c010a98c:	c3                   	ret    

c010a98d <do_yield>:

// do_yield - ask the scheduler to reschedule
int
do_yield(void) {
c010a98d:	55                   	push   %ebp
c010a98e:	89 e5                	mov    %esp,%ebp
    current->need_resched = 1;
c010a990:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a995:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    return 0;
c010a99c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a9a1:	5d                   	pop    %ebp
c010a9a2:	c3                   	ret    

c010a9a3 <do_wait>:

// do_wait - wait one OR any children with PROC_ZOMBIE state, and free memory space of kernel stack
//         - proc struct of this child.
// NOTE: only after do_wait function, all resources of the child proces are free.
int
do_wait(int pid, int *code_store) {
c010a9a3:	55                   	push   %ebp
c010a9a4:	89 e5                	mov    %esp,%ebp
c010a9a6:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = current->mm;
c010a9a9:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010a9ae:	8b 40 18             	mov    0x18(%eax),%eax
c010a9b1:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (code_store != NULL) {
c010a9b4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010a9b8:	74 31                	je     c010a9eb <do_wait+0x48>
        if (!user_mem_check(mm, (uintptr_t)code_store, sizeof(int), 1)) {
c010a9ba:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a9bd:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c010a9c4:	00 
c010a9c5:	c7 44 24 08 04 00 00 	movl   $0x4,0x8(%esp)
c010a9cc:	00 
c010a9cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c010a9d1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010a9d4:	89 04 24             	mov    %eax,(%esp)
c010a9d7:	e8 cd e6 ff ff       	call   c01090a9 <user_mem_check>
c010a9dc:	85 c0                	test   %eax,%eax
c010a9de:	75 0b                	jne    c010a9eb <do_wait+0x48>
            return -E_INVAL;
c010a9e0:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010a9e5:	e9 47 01 00 00       	jmp    c010ab31 <do_wait+0x18e>
        current->wait_state = WT_CHILD;
        schedule();
        if (current->flags & PF_EXITING) {
            do_exit(-E_KILLED);
        }
        goto repeat;
c010a9ea:	90                   	nop
    }

    struct proc_struct *proc;
    bool intr_flag, haskid;
repeat:
    haskid = 0;
c010a9eb:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    if (pid != 0) {
c010a9f2:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010a9f6:	74 36                	je     c010aa2e <do_wait+0x8b>
        proc = find_proc(pid);
c010a9f8:	8b 45 08             	mov    0x8(%ebp),%eax
c010a9fb:	89 04 24             	mov    %eax,(%esp)
c010a9fe:	e8 d6 f0 ff ff       	call   c0109ad9 <find_proc>
c010aa03:	89 45 f4             	mov    %eax,-0xc(%ebp)
        if (proc != NULL && proc->parent == current) {
c010aa06:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010aa0a:	74 4f                	je     c010aa5b <do_wait+0xb8>
c010aa0c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aa0f:	8b 50 14             	mov    0x14(%eax),%edx
c010aa12:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010aa17:	39 c2                	cmp    %eax,%edx
c010aa19:	75 40                	jne    c010aa5b <do_wait+0xb8>
            haskid = 1;
c010aa1b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010aa22:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aa25:	8b 00                	mov    (%eax),%eax
c010aa27:	83 f8 03             	cmp    $0x3,%eax
c010aa2a:	75 2f                	jne    c010aa5b <do_wait+0xb8>
                goto found;
c010aa2c:	eb 7e                	jmp    c010aaac <do_wait+0x109>
            }
        }
    }
    else {
        proc = current->cptr;
c010aa2e:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010aa33:	8b 40 70             	mov    0x70(%eax),%eax
c010aa36:	89 45 f4             	mov    %eax,-0xc(%ebp)
        for (; proc != NULL; proc = proc->optr) {
c010aa39:	eb 1a                	jmp    c010aa55 <do_wait+0xb2>
            haskid = 1;
c010aa3b:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
            if (proc->state == PROC_ZOMBIE) {
c010aa42:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aa45:	8b 00                	mov    (%eax),%eax
c010aa47:	83 f8 03             	cmp    $0x3,%eax
c010aa4a:	74 5f                	je     c010aaab <do_wait+0x108>
            }
        }
    }
    else {
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) {
c010aa4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aa4f:	8b 40 78             	mov    0x78(%eax),%eax
c010aa52:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010aa55:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010aa59:	75 e0                	jne    c010aa3b <do_wait+0x98>
            if (proc->state == PROC_ZOMBIE) {
                goto found;
            }
        }
    }
    if (haskid) {
c010aa5b:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010aa5f:	74 40                	je     c010aaa1 <do_wait+0xfe>
        current->state = PROC_SLEEPING;
c010aa61:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010aa66:	c7 00 01 00 00 00    	movl   $0x1,(%eax)
        current->wait_state = WT_CHILD;
c010aa6c:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010aa71:	c7 40 6c 01 00 00 80 	movl   $0x80000001,0x6c(%eax)
        schedule();
c010aa78:	e8 15 06 00 00       	call   c010b092 <schedule>
        if (current->flags & PF_EXITING) {
c010aa7d:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010aa82:	8b 40 44             	mov    0x44(%eax),%eax
c010aa85:	83 e0 01             	and    $0x1,%eax
c010aa88:	84 c0                	test   %al,%al
c010aa8a:	0f 84 5a ff ff ff    	je     c010a9ea <do_wait+0x47>
            do_exit(-E_KILLED);
c010aa90:	c7 04 24 f7 ff ff ff 	movl   $0xfffffff7,(%esp)
c010aa97:	e8 77 f5 ff ff       	call   c010a013 <do_exit>
        }
        goto repeat;
c010aa9c:	e9 49 ff ff ff       	jmp    c010a9ea <do_wait+0x47>
    }
    return -E_BAD_PROC;
c010aaa1:	b8 fe ff ff ff       	mov    $0xfffffffe,%eax
c010aaa6:	e9 86 00 00 00       	jmp    c010ab31 <do_wait+0x18e>
    else {
        proc = current->cptr;
        for (; proc != NULL; proc = proc->optr) {
            haskid = 1;
            if (proc->state == PROC_ZOMBIE) {
                goto found;
c010aaab:	90                   	nop
        goto repeat;
    }
    return -E_BAD_PROC;

found:
    if (proc == idleproc || proc == initproc) {
c010aaac:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010aab1:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010aab4:	74 0a                	je     c010aac0 <do_wait+0x11d>
c010aab6:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010aabb:	39 45 f4             	cmp    %eax,-0xc(%ebp)
c010aabe:	75 1c                	jne    c010aadc <do_wait+0x139>
        panic("wait idleproc or initproc.\n");
c010aac0:	c7 44 24 08 ee e2 10 	movl   $0xc010e2ee,0x8(%esp)
c010aac7:	c0 
c010aac8:	c7 44 24 04 f8 02 00 	movl   $0x2f8,0x4(%esp)
c010aacf:	00 
c010aad0:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010aad7:	e8 dc 62 ff ff       	call   c0100db8 <__panic>
    }
    if (code_store != NULL) {
c010aadc:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010aae0:	74 0b                	je     c010aaed <do_wait+0x14a>
        *code_store = proc->exit_code;
c010aae2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aae5:	8b 50 68             	mov    0x68(%eax),%edx
c010aae8:	8b 45 0c             	mov    0xc(%ebp),%eax
c010aaeb:	89 10                	mov    %edx,(%eax)
    }
    local_intr_save(intr_flag);
c010aaed:	e8 dc e8 ff ff       	call   c01093ce <__intr_save>
c010aaf2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    {
        unhash_proc(proc);
c010aaf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010aaf8:	89 04 24             	mov    %eax,(%esp)
c010aafb:	e8 a6 ef ff ff       	call   c0109aa6 <unhash_proc>
        remove_links(proc);
c010ab00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab03:	89 04 24             	mov    %eax,(%esp)
c010ab06:	e8 17 ed ff ff       	call   c0109822 <remove_links>
    }
    local_intr_restore(intr_flag);
c010ab0b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ab0e:	89 04 24             	mov    %eax,(%esp)
c010ab11:	e8 e7 e8 ff ff       	call   c01093fd <__intr_restore>
    put_kstack(proc);
c010ab16:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab19:	89 04 24             	mov    %eax,(%esp)
c010ab1c:	e8 d8 f0 ff ff       	call   c0109bf9 <put_kstack>
    kfree(proc);
c010ab21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab24:	89 04 24             	mov    %eax,(%esp)
c010ab27:	e8 a9 a1 ff ff       	call   c0104cd5 <kfree>
    return 0;
c010ab2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010ab31:	c9                   	leave  
c010ab32:	c3                   	ret    

c010ab33 <do_kill>:

// do_kill - kill process with pid by set this process's flags with PF_EXITING
int
do_kill(int pid) {
c010ab33:	55                   	push   %ebp
c010ab34:	89 e5                	mov    %esp,%ebp
c010ab36:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc;
    if ((proc = find_proc(pid)) != NULL) {
c010ab39:	8b 45 08             	mov    0x8(%ebp),%eax
c010ab3c:	89 04 24             	mov    %eax,(%esp)
c010ab3f:	e8 95 ef ff ff       	call   c0109ad9 <find_proc>
c010ab44:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010ab47:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010ab4b:	74 41                	je     c010ab8e <do_kill+0x5b>
        if (!(proc->flags & PF_EXITING)) {
c010ab4d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab50:	8b 40 44             	mov    0x44(%eax),%eax
c010ab53:	83 e0 01             	and    $0x1,%eax
c010ab56:	85 c0                	test   %eax,%eax
c010ab58:	75 2d                	jne    c010ab87 <do_kill+0x54>
            proc->flags |= PF_EXITING;
c010ab5a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab5d:	8b 40 44             	mov    0x44(%eax),%eax
c010ab60:	89 c2                	mov    %eax,%edx
c010ab62:	83 ca 01             	or     $0x1,%edx
c010ab65:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab68:	89 50 44             	mov    %edx,0x44(%eax)
            if (proc->wait_state & WT_INTERRUPTED) {
c010ab6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab6e:	8b 40 6c             	mov    0x6c(%eax),%eax
c010ab71:	85 c0                	test   %eax,%eax
c010ab73:	79 0b                	jns    c010ab80 <do_kill+0x4d>
                wakeup_proc(proc);
c010ab75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ab78:	89 04 24             	mov    %eax,(%esp)
c010ab7b:	e8 8e 04 00 00       	call   c010b00e <wakeup_proc>
            }
            return 0;
c010ab80:	b8 00 00 00 00       	mov    $0x0,%eax
c010ab85:	eb 0c                	jmp    c010ab93 <do_kill+0x60>
        }
        return -E_KILLED;
c010ab87:	b8 f7 ff ff ff       	mov    $0xfffffff7,%eax
c010ab8c:	eb 05                	jmp    c010ab93 <do_kill+0x60>
    }
    return -E_INVAL;
c010ab8e:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
}
c010ab93:	c9                   	leave  
c010ab94:	c3                   	ret    

c010ab95 <kernel_execve>:

// kernel_execve - do SYS_exec syscall to exec a user program called by user_main kernel_thread
static int
kernel_execve(const char *name, unsigned char *binary, size_t size) {
c010ab95:	55                   	push   %ebp
c010ab96:	89 e5                	mov    %esp,%ebp
c010ab98:	57                   	push   %edi
c010ab99:	56                   	push   %esi
c010ab9a:	53                   	push   %ebx
c010ab9b:	83 ec 2c             	sub    $0x2c,%esp
    int ret, len = strlen(name);
c010ab9e:	8b 45 08             	mov    0x8(%ebp),%eax
c010aba1:	89 04 24             	mov    %eax,(%esp)
c010aba4:	e8 a3 0f 00 00       	call   c010bb4c <strlen>
c010aba9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    asm volatile (
c010abac:	b8 04 00 00 00       	mov    $0x4,%eax
c010abb1:	8b 55 08             	mov    0x8(%ebp),%edx
c010abb4:	8b 4d e4             	mov    -0x1c(%ebp),%ecx
c010abb7:	8b 5d 0c             	mov    0xc(%ebp),%ebx
c010abba:	8b 7d 10             	mov    0x10(%ebp),%edi
c010abbd:	89 c6                	mov    %eax,%esi
c010abbf:	89 f0                	mov    %esi,%eax
c010abc1:	cd 80                	int    $0x80
c010abc3:	89 c6                	mov    %eax,%esi
c010abc5:	89 75 e0             	mov    %esi,-0x20(%ebp)
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL), "0" (SYS_exec), "d" (name), "c" (len), "b" (binary), "D" (size)
        : "memory");
    return ret;
c010abc8:	8b 45 e0             	mov    -0x20(%ebp),%eax
}
c010abcb:	83 c4 2c             	add    $0x2c,%esp
c010abce:	5b                   	pop    %ebx
c010abcf:	5e                   	pop    %esi
c010abd0:	5f                   	pop    %edi
c010abd1:	5d                   	pop    %ebp
c010abd2:	c3                   	ret    

c010abd3 <user_main>:

#define KERNEL_EXECVE2(x, xstart, xsize)        __KERNEL_EXECVE2(x, xstart, xsize)

// user_main - kernel thread used to exec a user program
static int
user_main(void *arg) {
c010abd3:	55                   	push   %ebp
c010abd4:	89 e5                	mov    %esp,%ebp
c010abd6:	83 ec 18             	sub    $0x18,%esp
#ifdef TEST
    KERNEL_EXECVE2(TEST, TESTSTART, TESTSIZE);
c010abd9:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010abde:	8b 40 04             	mov    0x4(%eax),%eax
c010abe1:	c7 44 24 08 0a e3 10 	movl   $0xc010e30a,0x8(%esp)
c010abe8:	c0 
c010abe9:	89 44 24 04          	mov    %eax,0x4(%esp)
c010abed:	c7 04 24 14 e3 10 c0 	movl   $0xc010e314,(%esp)
c010abf4:	e8 66 57 ff ff       	call   c010035f <cprintf>
c010abf9:	b8 d2 78 00 00       	mov    $0x78d2,%eax
c010abfe:	89 44 24 08          	mov    %eax,0x8(%esp)
c010ac02:	c7 44 24 04 09 f8 15 	movl   $0xc015f809,0x4(%esp)
c010ac09:	c0 
c010ac0a:	c7 04 24 0a e3 10 c0 	movl   $0xc010e30a,(%esp)
c010ac11:	e8 7f ff ff ff       	call   c010ab95 <kernel_execve>
#else
    KERNEL_EXECVE(exit);
#endif
    panic("user_main execve failed.\n");
c010ac16:	c7 44 24 08 3b e3 10 	movl   $0xc010e33b,0x8(%esp)
c010ac1d:	c0 
c010ac1e:	c7 44 24 04 41 03 00 	movl   $0x341,0x4(%esp)
c010ac25:	00 
c010ac26:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010ac2d:	e8 86 61 ff ff       	call   c0100db8 <__panic>

c010ac32 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c010ac32:	55                   	push   %ebp
c010ac33:	89 e5                	mov    %esp,%ebp
c010ac35:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c010ac38:	e8 a1 a5 ff ff       	call   c01051de <nr_free_pages>
c010ac3d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t kernel_allocated_store = kallocated();
c010ac40:	e8 58 9f ff ff       	call   c0104b9d <kallocated>
c010ac45:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int pid = kernel_thread(user_main, NULL, 0);
c010ac48:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010ac4f:	00 
c010ac50:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010ac57:	00 
c010ac58:	c7 04 24 d3 ab 10 c0 	movl   $0xc010abd3,(%esp)
c010ac5f:	e8 e7 ee ff ff       	call   c0109b4b <kernel_thread>
c010ac64:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (pid <= 0) {
c010ac67:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c010ac6b:	7f 23                	jg     c010ac90 <init_main+0x5e>
        panic("create user_main failed.\n");
c010ac6d:	c7 44 24 08 55 e3 10 	movl   $0xc010e355,0x8(%esp)
c010ac74:	c0 
c010ac75:	c7 44 24 04 4c 03 00 	movl   $0x34c,0x4(%esp)
c010ac7c:	00 
c010ac7d:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010ac84:	e8 2f 61 ff ff       	call   c0100db8 <__panic>
    }

    while (do_wait(0, NULL) == 0) {
        schedule();
c010ac89:	e8 04 04 00 00       	call   c010b092 <schedule>
c010ac8e:	eb 01                	jmp    c010ac91 <init_main+0x5f>
    int pid = kernel_thread(user_main, NULL, 0);
    if (pid <= 0) {
        panic("create user_main failed.\n");
    }

    while (do_wait(0, NULL) == 0) {
c010ac90:	90                   	nop
c010ac91:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010ac98:	00 
c010ac99:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010aca0:	e8 fe fc ff ff       	call   c010a9a3 <do_wait>
c010aca5:	85 c0                	test   %eax,%eax
c010aca7:	74 e0                	je     c010ac89 <init_main+0x57>
        schedule();
    }

    cprintf("all user-mode processes have quit.\n");
c010aca9:	c7 04 24 70 e3 10 c0 	movl   $0xc010e370,(%esp)
c010acb0:	e8 aa 56 ff ff       	call   c010035f <cprintf>
    assert(initproc->cptr == NULL && initproc->yptr == NULL && initproc->optr == NULL);
c010acb5:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010acba:	8b 40 70             	mov    0x70(%eax),%eax
c010acbd:	85 c0                	test   %eax,%eax
c010acbf:	75 18                	jne    c010acd9 <init_main+0xa7>
c010acc1:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010acc6:	8b 40 74             	mov    0x74(%eax),%eax
c010acc9:	85 c0                	test   %eax,%eax
c010accb:	75 0c                	jne    c010acd9 <init_main+0xa7>
c010accd:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010acd2:	8b 40 78             	mov    0x78(%eax),%eax
c010acd5:	85 c0                	test   %eax,%eax
c010acd7:	74 24                	je     c010acfd <init_main+0xcb>
c010acd9:	c7 44 24 0c 94 e3 10 	movl   $0xc010e394,0xc(%esp)
c010ace0:	c0 
c010ace1:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010ace8:	c0 
c010ace9:	c7 44 24 04 54 03 00 	movl   $0x354,0x4(%esp)
c010acf0:	00 
c010acf1:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010acf8:	e8 bb 60 ff ff       	call   c0100db8 <__panic>
    assert(nr_process == 2);
c010acfd:	a1 a0 ee 19 c0       	mov    0xc019eea0,%eax
c010ad02:	83 f8 02             	cmp    $0x2,%eax
c010ad05:	74 24                	je     c010ad2b <init_main+0xf9>
c010ad07:	c7 44 24 0c df e3 10 	movl   $0xc010e3df,0xc(%esp)
c010ad0e:	c0 
c010ad0f:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010ad16:	c0 
c010ad17:	c7 44 24 04 55 03 00 	movl   $0x355,0x4(%esp)
c010ad1e:	00 
c010ad1f:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010ad26:	e8 8d 60 ff ff       	call   c0100db8 <__panic>
c010ad2b:	c7 45 e8 b0 ef 19 c0 	movl   $0xc019efb0,-0x18(%ebp)
c010ad32:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ad35:	8b 40 04             	mov    0x4(%eax),%eax
    assert(list_next(&proc_list) == &(initproc->list_link));
c010ad38:	8b 15 84 ce 19 c0    	mov    0xc019ce84,%edx
c010ad3e:	83 c2 58             	add    $0x58,%edx
c010ad41:	39 d0                	cmp    %edx,%eax
c010ad43:	74 24                	je     c010ad69 <init_main+0x137>
c010ad45:	c7 44 24 0c f0 e3 10 	movl   $0xc010e3f0,0xc(%esp)
c010ad4c:	c0 
c010ad4d:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010ad54:	c0 
c010ad55:	c7 44 24 04 56 03 00 	movl   $0x356,0x4(%esp)
c010ad5c:	00 
c010ad5d:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010ad64:	e8 4f 60 ff ff       	call   c0100db8 <__panic>
c010ad69:	c7 45 e4 b0 ef 19 c0 	movl   $0xc019efb0,-0x1c(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c010ad70:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010ad73:	8b 00                	mov    (%eax),%eax
    assert(list_prev(&proc_list) == &(initproc->list_link));
c010ad75:	8b 15 84 ce 19 c0    	mov    0xc019ce84,%edx
c010ad7b:	83 c2 58             	add    $0x58,%edx
c010ad7e:	39 d0                	cmp    %edx,%eax
c010ad80:	74 24                	je     c010ada6 <init_main+0x174>
c010ad82:	c7 44 24 0c 20 e4 10 	movl   $0xc010e420,0xc(%esp)
c010ad89:	c0 
c010ad8a:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010ad91:	c0 
c010ad92:	c7 44 24 04 57 03 00 	movl   $0x357,0x4(%esp)
c010ad99:	00 
c010ad9a:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010ada1:	e8 12 60 ff ff       	call   c0100db8 <__panic>

    cprintf("init check memory pass.\n");
c010ada6:	c7 04 24 50 e4 10 c0 	movl   $0xc010e450,(%esp)
c010adad:	e8 ad 55 ff ff       	call   c010035f <cprintf>
    return 0;
c010adb2:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010adb7:	c9                   	leave  
c010adb8:	c3                   	ret    

c010adb9 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c010adb9:	55                   	push   %ebp
c010adba:	89 e5                	mov    %esp,%ebp
c010adbc:	83 ec 28             	sub    $0x28,%esp
c010adbf:	c7 45 ec b0 ef 19 c0 	movl   $0xc019efb0,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010adc6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010adc9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010adcc:	89 50 04             	mov    %edx,0x4(%eax)
c010adcf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010add2:	8b 50 04             	mov    0x4(%eax),%edx
c010add5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010add8:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010adda:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010ade1:	eb 26                	jmp    c010ae09 <proc_init+0x50>
        list_init(hash_list + i);
c010ade3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010ade6:	c1 e0 03             	shl    $0x3,%eax
c010ade9:	05 a0 ce 19 c0       	add    $0xc019cea0,%eax
c010adee:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010adf1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010adf4:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010adf7:	89 50 04             	mov    %edx,0x4(%eax)
c010adfa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010adfd:	8b 50 04             	mov    0x4(%eax),%edx
c010ae00:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010ae03:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c010ae05:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010ae09:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010ae10:	7e d1                	jle    c010ade3 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c010ae12:	e8 f0 e7 ff ff       	call   c0109607 <alloc_proc>
c010ae17:	a3 80 ce 19 c0       	mov    %eax,0xc019ce80
c010ae1c:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010ae21:	85 c0                	test   %eax,%eax
c010ae23:	75 1c                	jne    c010ae41 <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c010ae25:	c7 44 24 08 69 e4 10 	movl   $0xc010e469,0x8(%esp)
c010ae2c:	c0 
c010ae2d:	c7 44 24 04 69 03 00 	movl   $0x369,0x4(%esp)
c010ae34:	00 
c010ae35:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010ae3c:	e8 77 5f ff ff       	call   c0100db8 <__panic>
    }

    idleproc->pid = 0;
c010ae41:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010ae46:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c010ae4d:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010ae52:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c010ae58:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010ae5d:	ba 00 80 12 c0       	mov    $0xc0128000,%edx
c010ae62:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c010ae65:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010ae6a:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c010ae71:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010ae76:	c7 44 24 04 81 e4 10 	movl   $0xc010e481,0x4(%esp)
c010ae7d:	c0 
c010ae7e:	89 04 24             	mov    %eax,(%esp)
c010ae81:	e8 72 e8 ff ff       	call   c01096f8 <set_proc_name>
    nr_process ++;
c010ae86:	a1 a0 ee 19 c0       	mov    0xc019eea0,%eax
c010ae8b:	83 c0 01             	add    $0x1,%eax
c010ae8e:	a3 a0 ee 19 c0       	mov    %eax,0xc019eea0

    current = idleproc;
c010ae93:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010ae98:	a3 88 ce 19 c0       	mov    %eax,0xc019ce88

    int pid = kernel_thread(init_main, NULL, 0);
c010ae9d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010aea4:	00 
c010aea5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010aeac:	00 
c010aead:	c7 04 24 32 ac 10 c0 	movl   $0xc010ac32,(%esp)
c010aeb4:	e8 92 ec ff ff       	call   c0109b4b <kernel_thread>
c010aeb9:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c010aebc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010aec0:	7f 1c                	jg     c010aede <proc_init+0x125>
        panic("create init_main failed.\n");
c010aec2:	c7 44 24 08 86 e4 10 	movl   $0xc010e486,0x8(%esp)
c010aec9:	c0 
c010aeca:	c7 44 24 04 77 03 00 	movl   $0x377,0x4(%esp)
c010aed1:	00 
c010aed2:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010aed9:	e8 da 5e ff ff       	call   c0100db8 <__panic>
    }

    initproc = find_proc(pid);
c010aede:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010aee1:	89 04 24             	mov    %eax,(%esp)
c010aee4:	e8 f0 eb ff ff       	call   c0109ad9 <find_proc>
c010aee9:	a3 84 ce 19 c0       	mov    %eax,0xc019ce84
    set_proc_name(initproc, "init");
c010aeee:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010aef3:	c7 44 24 04 a0 e4 10 	movl   $0xc010e4a0,0x4(%esp)
c010aefa:	c0 
c010aefb:	89 04 24             	mov    %eax,(%esp)
c010aefe:	e8 f5 e7 ff ff       	call   c01096f8 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c010af03:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010af08:	85 c0                	test   %eax,%eax
c010af0a:	74 0c                	je     c010af18 <proc_init+0x15f>
c010af0c:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010af11:	8b 40 04             	mov    0x4(%eax),%eax
c010af14:	85 c0                	test   %eax,%eax
c010af16:	74 24                	je     c010af3c <proc_init+0x183>
c010af18:	c7 44 24 0c a8 e4 10 	movl   $0xc010e4a8,0xc(%esp)
c010af1f:	c0 
c010af20:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010af27:	c0 
c010af28:	c7 44 24 04 7d 03 00 	movl   $0x37d,0x4(%esp)
c010af2f:	00 
c010af30:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010af37:	e8 7c 5e ff ff       	call   c0100db8 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c010af3c:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010af41:	85 c0                	test   %eax,%eax
c010af43:	74 0d                	je     c010af52 <proc_init+0x199>
c010af45:	a1 84 ce 19 c0       	mov    0xc019ce84,%eax
c010af4a:	8b 40 04             	mov    0x4(%eax),%eax
c010af4d:	83 f8 01             	cmp    $0x1,%eax
c010af50:	74 24                	je     c010af76 <proc_init+0x1bd>
c010af52:	c7 44 24 0c d0 e4 10 	movl   $0xc010e4d0,0xc(%esp)
c010af59:	c0 
c010af5a:	c7 44 24 08 11 e1 10 	movl   $0xc010e111,0x8(%esp)
c010af61:	c0 
c010af62:	c7 44 24 04 7e 03 00 	movl   $0x37e,0x4(%esp)
c010af69:	00 
c010af6a:	c7 04 24 e4 e0 10 c0 	movl   $0xc010e0e4,(%esp)
c010af71:	e8 42 5e ff ff       	call   c0100db8 <__panic>
}
c010af76:	c9                   	leave  
c010af77:	c3                   	ret    

c010af78 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c010af78:	55                   	push   %ebp
c010af79:	89 e5                	mov    %esp,%ebp
c010af7b:	83 ec 08             	sub    $0x8,%esp
c010af7e:	eb 01                	jmp    c010af81 <cpu_idle+0x9>
    while (1) {
        if (current->need_resched) {
            schedule();
        }
    }
c010af80:	90                   	nop

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
    while (1) {
        if (current->need_resched) {
c010af81:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010af86:	8b 40 10             	mov    0x10(%eax),%eax
c010af89:	85 c0                	test   %eax,%eax
c010af8b:	74 f3                	je     c010af80 <cpu_idle+0x8>
            schedule();
c010af8d:	e8 00 01 00 00       	call   c010b092 <schedule>
        }
    }
c010af92:	eb ec                	jmp    c010af80 <cpu_idle+0x8>

c010af94 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c010af94:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c010af98:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c010af9a:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c010af9d:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c010afa0:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c010afa3:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c010afa6:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c010afa9:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c010afac:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010afaf:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c010afb3:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c010afb6:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c010afb9:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c010afbc:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c010afbf:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c010afc2:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c010afc5:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c010afc8:	ff 30                	pushl  (%eax)

    ret
c010afca:	c3                   	ret    
	...

c010afcc <__intr_save>:
#include <assert.h>
#include <atomic.h>
#include <sched.h>

static inline bool
__intr_save(void) {
c010afcc:	55                   	push   %ebp
c010afcd:	89 e5                	mov    %esp,%ebp
c010afcf:	53                   	push   %ebx
c010afd0:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010afd3:	9c                   	pushf  
c010afd4:	5b                   	pop    %ebx
c010afd5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c010afd8:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010afdb:	25 00 02 00 00       	and    $0x200,%eax
c010afe0:	85 c0                	test   %eax,%eax
c010afe2:	74 0c                	je     c010aff0 <__intr_save+0x24>
        intr_disable();
c010afe4:	e8 fd 70 ff ff       	call   c01020e6 <intr_disable>
        return 1;
c010afe9:	b8 01 00 00 00       	mov    $0x1,%eax
c010afee:	eb 05                	jmp    c010aff5 <__intr_save+0x29>
    }
    return 0;
c010aff0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010aff5:	83 c4 14             	add    $0x14,%esp
c010aff8:	5b                   	pop    %ebx
c010aff9:	5d                   	pop    %ebp
c010affa:	c3                   	ret    

c010affb <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010affb:	55                   	push   %ebp
c010affc:	89 e5                	mov    %esp,%ebp
c010affe:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010b001:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010b005:	74 05                	je     c010b00c <__intr_restore+0x11>
        intr_enable();
c010b007:	e8 d4 70 ff ff       	call   c01020e0 <intr_enable>
    }
}
c010b00c:	c9                   	leave  
c010b00d:	c3                   	ret    

c010b00e <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c010b00e:	55                   	push   %ebp
c010b00f:	89 e5                	mov    %esp,%ebp
c010b011:	83 ec 28             	sub    $0x28,%esp
    assert(proc->state != PROC_ZOMBIE);
c010b014:	8b 45 08             	mov    0x8(%ebp),%eax
c010b017:	8b 00                	mov    (%eax),%eax
c010b019:	83 f8 03             	cmp    $0x3,%eax
c010b01c:	75 24                	jne    c010b042 <wakeup_proc+0x34>
c010b01e:	c7 44 24 0c f7 e4 10 	movl   $0xc010e4f7,0xc(%esp)
c010b025:	c0 
c010b026:	c7 44 24 08 12 e5 10 	movl   $0xc010e512,0x8(%esp)
c010b02d:	c0 
c010b02e:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c010b035:	00 
c010b036:	c7 04 24 27 e5 10 c0 	movl   $0xc010e527,(%esp)
c010b03d:	e8 76 5d ff ff       	call   c0100db8 <__panic>
    bool intr_flag;
    local_intr_save(intr_flag);
c010b042:	e8 85 ff ff ff       	call   c010afcc <__intr_save>
c010b047:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        if (proc->state != PROC_RUNNABLE) {
c010b04a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b04d:	8b 00                	mov    (%eax),%eax
c010b04f:	83 f8 02             	cmp    $0x2,%eax
c010b052:	74 15                	je     c010b069 <wakeup_proc+0x5b>
            proc->state = PROC_RUNNABLE;
c010b054:	8b 45 08             	mov    0x8(%ebp),%eax
c010b057:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
            proc->wait_state = 0;
c010b05d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b060:	c7 40 6c 00 00 00 00 	movl   $0x0,0x6c(%eax)
c010b067:	eb 1c                	jmp    c010b085 <wakeup_proc+0x77>
        }
        else {
            warn("wakeup runnable process.\n");
c010b069:	c7 44 24 08 3d e5 10 	movl   $0xc010e53d,0x8(%esp)
c010b070:	c0 
c010b071:	c7 44 24 04 12 00 00 	movl   $0x12,0x4(%esp)
c010b078:	00 
c010b079:	c7 04 24 27 e5 10 c0 	movl   $0xc010e527,(%esp)
c010b080:	e8 a2 5d ff ff       	call   c0100e27 <__warn>
        }
    }
    local_intr_restore(intr_flag);
c010b085:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b088:	89 04 24             	mov    %eax,(%esp)
c010b08b:	e8 6b ff ff ff       	call   c010affb <__intr_restore>
}
c010b090:	c9                   	leave  
c010b091:	c3                   	ret    

c010b092 <schedule>:

void
schedule(void) {
c010b092:	55                   	push   %ebp
c010b093:	89 e5                	mov    %esp,%ebp
c010b095:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c010b098:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c010b09f:	e8 28 ff ff ff       	call   c010afcc <__intr_save>
c010b0a4:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c010b0a7:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010b0ac:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c010b0b3:	8b 15 88 ce 19 c0    	mov    0xc019ce88,%edx
c010b0b9:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010b0be:	39 c2                	cmp    %eax,%edx
c010b0c0:	74 0a                	je     c010b0cc <schedule+0x3a>
c010b0c2:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010b0c7:	83 c0 58             	add    $0x58,%eax
c010b0ca:	eb 05                	jmp    c010b0d1 <schedule+0x3f>
c010b0cc:	b8 b0 ef 19 c0       	mov    $0xc019efb0,%eax
c010b0d1:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c010b0d4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b0d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b0da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0dd:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010b0e0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b0e3:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c010b0e6:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b0e9:	81 7d f4 b0 ef 19 c0 	cmpl   $0xc019efb0,-0xc(%ebp)
c010b0f0:	74 13                	je     c010b105 <schedule+0x73>
                next = le2proc(le, list_link);
c010b0f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b0f5:	83 e8 58             	sub    $0x58,%eax
c010b0f8:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c010b0fb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b0fe:	8b 00                	mov    (%eax),%eax
c010b100:	83 f8 02             	cmp    $0x2,%eax
c010b103:	74 0a                	je     c010b10f <schedule+0x7d>
                    break;
                }
            }
        } while (le != last);
c010b105:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b108:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c010b10b:	75 cd                	jne    c010b0da <schedule+0x48>
c010b10d:	eb 01                	jmp    c010b110 <schedule+0x7e>
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
                    break;
c010b10f:	90                   	nop
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
c010b110:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b114:	74 0a                	je     c010b120 <schedule+0x8e>
c010b116:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b119:	8b 00                	mov    (%eax),%eax
c010b11b:	83 f8 02             	cmp    $0x2,%eax
c010b11e:	74 08                	je     c010b128 <schedule+0x96>
            next = idleproc;
c010b120:	a1 80 ce 19 c0       	mov    0xc019ce80,%eax
c010b125:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c010b128:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b12b:	8b 40 08             	mov    0x8(%eax),%eax
c010b12e:	8d 50 01             	lea    0x1(%eax),%edx
c010b131:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b134:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c010b137:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010b13c:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c010b13f:	74 0b                	je     c010b14c <schedule+0xba>
            proc_run(next);
c010b141:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b144:	89 04 24             	mov    %eax,(%esp)
c010b147:	e8 51 e8 ff ff       	call   c010999d <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c010b14c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b14f:	89 04 24             	mov    %eax,(%esp)
c010b152:	e8 a4 fe ff ff       	call   c010affb <__intr_restore>
}
c010b157:	c9                   	leave  
c010b158:	c3                   	ret    
c010b159:	00 00                	add    %al,(%eax)
	...

c010b15c <sys_exit>:
#include <stdio.h>
#include <pmm.h>
#include <assert.h>

static int
sys_exit(uint32_t arg[]) {
c010b15c:	55                   	push   %ebp
c010b15d:	89 e5                	mov    %esp,%ebp
c010b15f:	83 ec 28             	sub    $0x28,%esp
    int error_code = (int)arg[0];
c010b162:	8b 45 08             	mov    0x8(%ebp),%eax
c010b165:	8b 00                	mov    (%eax),%eax
c010b167:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_exit(error_code);
c010b16a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b16d:	89 04 24             	mov    %eax,(%esp)
c010b170:	e8 9e ee ff ff       	call   c010a013 <do_exit>
}
c010b175:	c9                   	leave  
c010b176:	c3                   	ret    

c010b177 <sys_fork>:

static int
sys_fork(uint32_t arg[]) {
c010b177:	55                   	push   %ebp
c010b178:	89 e5                	mov    %esp,%ebp
c010b17a:	83 ec 28             	sub    $0x28,%esp
    struct trapframe *tf = current->tf;
c010b17d:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010b182:	8b 40 3c             	mov    0x3c(%eax),%eax
c010b185:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uintptr_t stack = tf->tf_esp;
c010b188:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b18b:	8b 40 44             	mov    0x44(%eax),%eax
c010b18e:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_fork(0, stack, tf);
c010b191:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b194:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b198:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b19b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b19f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c010b1a6:	e8 37 ed ff ff       	call   c0109ee2 <do_fork>
}
c010b1ab:	c9                   	leave  
c010b1ac:	c3                   	ret    

c010b1ad <sys_wait>:

static int
sys_wait(uint32_t arg[]) {
c010b1ad:	55                   	push   %ebp
c010b1ae:	89 e5                	mov    %esp,%ebp
c010b1b0:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010b1b3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1b6:	8b 00                	mov    (%eax),%eax
c010b1b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
    int *store = (int *)arg[1];
c010b1bb:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1be:	83 c0 04             	add    $0x4,%eax
c010b1c1:	8b 00                	mov    (%eax),%eax
c010b1c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
    return do_wait(pid, store);
c010b1c6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b1c9:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b1cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b1d0:	89 04 24             	mov    %eax,(%esp)
c010b1d3:	e8 cb f7 ff ff       	call   c010a9a3 <do_wait>
}
c010b1d8:	c9                   	leave  
c010b1d9:	c3                   	ret    

c010b1da <sys_exec>:

static int
sys_exec(uint32_t arg[]) {
c010b1da:	55                   	push   %ebp
c010b1db:	89 e5                	mov    %esp,%ebp
c010b1dd:	83 ec 28             	sub    $0x28,%esp
    const char *name = (const char *)arg[0];
c010b1e0:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1e3:	8b 00                	mov    (%eax),%eax
c010b1e5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    size_t len = (size_t)arg[1];
c010b1e8:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1eb:	8b 40 04             	mov    0x4(%eax),%eax
c010b1ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    unsigned char *binary = (unsigned char *)arg[2];
c010b1f1:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1f4:	83 c0 08             	add    $0x8,%eax
c010b1f7:	8b 00                	mov    (%eax),%eax
c010b1f9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    size_t size = (size_t)arg[3];
c010b1fc:	8b 45 08             	mov    0x8(%ebp),%eax
c010b1ff:	8b 40 0c             	mov    0xc(%eax),%eax
c010b202:	89 45 e8             	mov    %eax,-0x18(%ebp)
    return do_execve(name, len, binary, size);
c010b205:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b208:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b20c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b20f:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b213:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b216:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b21a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b21d:	89 04 24             	mov    %eax,(%esp)
c010b220:	e8 30 f6 ff ff       	call   c010a855 <do_execve>
}
c010b225:	c9                   	leave  
c010b226:	c3                   	ret    

c010b227 <sys_yield>:

static int
sys_yield(uint32_t arg[]) {
c010b227:	55                   	push   %ebp
c010b228:	89 e5                	mov    %esp,%ebp
c010b22a:	83 ec 08             	sub    $0x8,%esp
    return do_yield();
c010b22d:	e8 5b f7 ff ff       	call   c010a98d <do_yield>
}
c010b232:	c9                   	leave  
c010b233:	c3                   	ret    

c010b234 <sys_kill>:

static int
sys_kill(uint32_t arg[]) {
c010b234:	55                   	push   %ebp
c010b235:	89 e5                	mov    %esp,%ebp
c010b237:	83 ec 28             	sub    $0x28,%esp
    int pid = (int)arg[0];
c010b23a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b23d:	8b 00                	mov    (%eax),%eax
c010b23f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return do_kill(pid);
c010b242:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b245:	89 04 24             	mov    %eax,(%esp)
c010b248:	e8 e6 f8 ff ff       	call   c010ab33 <do_kill>
}
c010b24d:	c9                   	leave  
c010b24e:	c3                   	ret    

c010b24f <sys_getpid>:

static int
sys_getpid(uint32_t arg[]) {
c010b24f:	55                   	push   %ebp
c010b250:	89 e5                	mov    %esp,%ebp
    return current->pid;
c010b252:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010b257:	8b 40 04             	mov    0x4(%eax),%eax
}
c010b25a:	5d                   	pop    %ebp
c010b25b:	c3                   	ret    

c010b25c <sys_putc>:

static int
sys_putc(uint32_t arg[]) {
c010b25c:	55                   	push   %ebp
c010b25d:	89 e5                	mov    %esp,%ebp
c010b25f:	83 ec 28             	sub    $0x28,%esp
    int c = (int)arg[0];
c010b262:	8b 45 08             	mov    0x8(%ebp),%eax
c010b265:	8b 00                	mov    (%eax),%eax
c010b267:	89 45 f4             	mov    %eax,-0xc(%ebp)
    cputchar(c);
c010b26a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b26d:	89 04 24             	mov    %eax,(%esp)
c010b270:	e8 12 51 ff ff       	call   c0100387 <cputchar>
    return 0;
c010b275:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b27a:	c9                   	leave  
c010b27b:	c3                   	ret    

c010b27c <sys_pgdir>:

static int
sys_pgdir(uint32_t arg[]) {
c010b27c:	55                   	push   %ebp
c010b27d:	89 e5                	mov    %esp,%ebp
c010b27f:	83 ec 08             	sub    $0x8,%esp
    print_pgdir();
c010b282:	e8 97 b9 ff ff       	call   c0106c1e <print_pgdir>
    return 0;
c010b287:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010b28c:	c9                   	leave  
c010b28d:	c3                   	ret    

c010b28e <syscall>:
};

#define NUM_SYSCALLS        ((sizeof(syscalls)) / (sizeof(syscalls[0])))

void
syscall(void) {
c010b28e:	55                   	push   %ebp
c010b28f:	89 e5                	mov    %esp,%ebp
c010b291:	83 ec 48             	sub    $0x48,%esp
    struct trapframe *tf = current->tf;
c010b294:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010b299:	8b 40 3c             	mov    0x3c(%eax),%eax
c010b29c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    uint32_t arg[5];
    int num = tf->tf_regs.reg_eax;
c010b29f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2a2:	8b 40 1c             	mov    0x1c(%eax),%eax
c010b2a5:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (num >= 0 && num < NUM_SYSCALLS) {
c010b2a8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b2ac:	78 5e                	js     c010b30c <syscall+0x7e>
c010b2ae:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2b1:	83 f8 1f             	cmp    $0x1f,%eax
c010b2b4:	77 56                	ja     c010b30c <syscall+0x7e>
        if (syscalls[num] != NULL) {
c010b2b6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2b9:	8b 04 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%eax
c010b2c0:	85 c0                	test   %eax,%eax
c010b2c2:	74 48                	je     c010b30c <syscall+0x7e>
            arg[0] = tf->tf_regs.reg_edx;
c010b2c4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2c7:	8b 40 14             	mov    0x14(%eax),%eax
c010b2ca:	89 45 dc             	mov    %eax,-0x24(%ebp)
            arg[1] = tf->tf_regs.reg_ecx;
c010b2cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2d0:	8b 40 18             	mov    0x18(%eax),%eax
c010b2d3:	89 45 e0             	mov    %eax,-0x20(%ebp)
            arg[2] = tf->tf_regs.reg_ebx;
c010b2d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2d9:	8b 40 10             	mov    0x10(%eax),%eax
c010b2dc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            arg[3] = tf->tf_regs.reg_edi;
c010b2df:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2e2:	8b 00                	mov    (%eax),%eax
c010b2e4:	89 45 e8             	mov    %eax,-0x18(%ebp)
            arg[4] = tf->tf_regs.reg_esi;
c010b2e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b2ea:	8b 40 04             	mov    0x4(%eax),%eax
c010b2ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
            tf->tf_regs.reg_eax = syscalls[num](arg);
c010b2f0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b2f3:	8b 14 85 a0 aa 12 c0 	mov    -0x3fed5560(,%eax,4),%edx
c010b2fa:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010b2fd:	89 04 24             	mov    %eax,(%esp)
c010b300:	ff d2                	call   *%edx
c010b302:	89 c2                	mov    %eax,%edx
c010b304:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b307:	89 50 1c             	mov    %edx,0x1c(%eax)
        }
    }
    print_trapframe(tf);
    panic("undefined syscall %d, pid = %d, name = %s.\n",
            num, current->pid, current->name);
}
c010b30a:	c9                   	leave  
c010b30b:	c3                   	ret    
            arg[4] = tf->tf_regs.reg_esi;
            tf->tf_regs.reg_eax = syscalls[num](arg);
            return ;
        }
    }
    print_trapframe(tf);
c010b30c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b30f:	89 04 24             	mov    %eax,(%esp)
c010b312:	e8 93 71 ff ff       	call   c01024aa <print_trapframe>
    panic("undefined syscall %d, pid = %d, name = %s.\n",
c010b317:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010b31c:	8d 50 48             	lea    0x48(%eax),%edx
c010b31f:	a1 88 ce 19 c0       	mov    0xc019ce88,%eax
c010b324:	8b 40 04             	mov    0x4(%eax),%eax
c010b327:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b32b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b32f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b332:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b336:	c7 44 24 08 58 e5 10 	movl   $0xc010e558,0x8(%esp)
c010b33d:	c0 
c010b33e:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c010b345:	00 
c010b346:	c7 04 24 84 e5 10 c0 	movl   $0xc010e584,(%esp)
c010b34d:	e8 66 5a ff ff       	call   c0100db8 <__panic>
	...

c010b354 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c010b354:	55                   	push   %ebp
c010b355:	89 e5                	mov    %esp,%ebp
c010b357:	53                   	push   %ebx
c010b358:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c010b35b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b35e:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c010b364:	89 45 f8             	mov    %eax,-0x8(%ebp)
    return (hash >> (32 - bits));
c010b367:	b8 20 00 00 00       	mov    $0x20,%eax
c010b36c:	2b 45 0c             	sub    0xc(%ebp),%eax
c010b36f:	8b 55 f8             	mov    -0x8(%ebp),%edx
c010b372:	89 d3                	mov    %edx,%ebx
c010b374:	89 c1                	mov    %eax,%ecx
c010b376:	d3 eb                	shr    %cl,%ebx
c010b378:	89 d8                	mov    %ebx,%eax
}
c010b37a:	83 c4 10             	add    $0x10,%esp
c010b37d:	5b                   	pop    %ebx
c010b37e:	5d                   	pop    %ebp
c010b37f:	c3                   	ret    

c010b380 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c010b380:	55                   	push   %ebp
c010b381:	89 e5                	mov    %esp,%ebp
c010b383:	56                   	push   %esi
c010b384:	53                   	push   %ebx
c010b385:	83 ec 60             	sub    $0x60,%esp
c010b388:	8b 45 10             	mov    0x10(%ebp),%eax
c010b38b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010b38e:	8b 45 14             	mov    0x14(%ebp),%eax
c010b391:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c010b394:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010b397:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010b39a:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b39d:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c010b3a0:	8b 45 18             	mov    0x18(%ebp),%eax
c010b3a3:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010b3a6:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b3a9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b3ac:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010b3af:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010b3b2:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010b3b5:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010b3b8:	89 d3                	mov    %edx,%ebx
c010b3ba:	89 c6                	mov    %eax,%esi
c010b3bc:	89 75 e0             	mov    %esi,-0x20(%ebp)
c010b3bf:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c010b3c2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b3c5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010b3c8:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010b3cc:	74 1c                	je     c010b3ea <printnum+0x6a>
c010b3ce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b3d1:	ba 00 00 00 00       	mov    $0x0,%edx
c010b3d6:	f7 75 e4             	divl   -0x1c(%ebp)
c010b3d9:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010b3dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b3df:	ba 00 00 00 00       	mov    $0x0,%edx
c010b3e4:	f7 75 e4             	divl   -0x1c(%ebp)
c010b3e7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b3ea:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010b3ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b3f0:	89 d6                	mov    %edx,%esi
c010b3f2:	89 c3                	mov    %eax,%ebx
c010b3f4:	89 f0                	mov    %esi,%eax
c010b3f6:	89 da                	mov    %ebx,%edx
c010b3f8:	f7 75 e4             	divl   -0x1c(%ebp)
c010b3fb:	89 d3                	mov    %edx,%ebx
c010b3fd:	89 c6                	mov    %eax,%esi
c010b3ff:	89 75 e0             	mov    %esi,-0x20(%ebp)
c010b402:	89 5d dc             	mov    %ebx,-0x24(%ebp)
c010b405:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b408:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010b40b:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010b40e:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010b411:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010b414:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010b417:	89 c3                	mov    %eax,%ebx
c010b419:	89 d6                	mov    %edx,%esi
c010b41b:	89 5d e8             	mov    %ebx,-0x18(%ebp)
c010b41e:	89 75 ec             	mov    %esi,-0x14(%ebp)
c010b421:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b424:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c010b427:	8b 45 18             	mov    0x18(%ebp),%eax
c010b42a:	ba 00 00 00 00       	mov    $0x0,%edx
c010b42f:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b432:	77 56                	ja     c010b48a <printnum+0x10a>
c010b434:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010b437:	72 05                	jb     c010b43e <printnum+0xbe>
c010b439:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c010b43c:	77 4c                	ja     c010b48a <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
c010b43e:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010b441:	8d 50 ff             	lea    -0x1(%eax),%edx
c010b444:	8b 45 20             	mov    0x20(%ebp),%eax
c010b447:	89 44 24 18          	mov    %eax,0x18(%esp)
c010b44b:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b44f:	8b 45 18             	mov    0x18(%ebp),%eax
c010b452:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b456:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010b459:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010b45c:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b460:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b464:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b467:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b46b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b46e:	89 04 24             	mov    %eax,(%esp)
c010b471:	e8 0a ff ff ff       	call   c010b380 <printnum>
c010b476:	eb 1c                	jmp    c010b494 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c010b478:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b47b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b47f:	8b 45 20             	mov    0x20(%ebp),%eax
c010b482:	89 04 24             	mov    %eax,(%esp)
c010b485:	8b 45 08             	mov    0x8(%ebp),%eax
c010b488:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c010b48a:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c010b48e:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010b492:	7f e4                	jg     c010b478 <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c010b494:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010b497:	05 a4 e6 10 c0       	add    $0xc010e6a4,%eax
c010b49c:	0f b6 00             	movzbl (%eax),%eax
c010b49f:	0f be c0             	movsbl %al,%eax
c010b4a2:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b4a5:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b4a9:	89 04 24             	mov    %eax,(%esp)
c010b4ac:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4af:	ff d0                	call   *%eax
}
c010b4b1:	83 c4 60             	add    $0x60,%esp
c010b4b4:	5b                   	pop    %ebx
c010b4b5:	5e                   	pop    %esi
c010b4b6:	5d                   	pop    %ebp
c010b4b7:	c3                   	ret    

c010b4b8 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c010b4b8:	55                   	push   %ebp
c010b4b9:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b4bb:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b4bf:	7e 14                	jle    c010b4d5 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010b4c1:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4c4:	8b 00                	mov    (%eax),%eax
c010b4c6:	8d 48 08             	lea    0x8(%eax),%ecx
c010b4c9:	8b 55 08             	mov    0x8(%ebp),%edx
c010b4cc:	89 0a                	mov    %ecx,(%edx)
c010b4ce:	8b 50 04             	mov    0x4(%eax),%edx
c010b4d1:	8b 00                	mov    (%eax),%eax
c010b4d3:	eb 30                	jmp    c010b505 <getuint+0x4d>
    }
    else if (lflag) {
c010b4d5:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b4d9:	74 16                	je     c010b4f1 <getuint+0x39>
        return va_arg(*ap, unsigned long);
c010b4db:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4de:	8b 00                	mov    (%eax),%eax
c010b4e0:	8d 48 04             	lea    0x4(%eax),%ecx
c010b4e3:	8b 55 08             	mov    0x8(%ebp),%edx
c010b4e6:	89 0a                	mov    %ecx,(%edx)
c010b4e8:	8b 00                	mov    (%eax),%eax
c010b4ea:	ba 00 00 00 00       	mov    $0x0,%edx
c010b4ef:	eb 14                	jmp    c010b505 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010b4f1:	8b 45 08             	mov    0x8(%ebp),%eax
c010b4f4:	8b 00                	mov    (%eax),%eax
c010b4f6:	8d 48 04             	lea    0x4(%eax),%ecx
c010b4f9:	8b 55 08             	mov    0x8(%ebp),%edx
c010b4fc:	89 0a                	mov    %ecx,(%edx)
c010b4fe:	8b 00                	mov    (%eax),%eax
c010b500:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c010b505:	5d                   	pop    %ebp
c010b506:	c3                   	ret    

c010b507 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c010b507:	55                   	push   %ebp
c010b508:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c010b50a:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010b50e:	7e 14                	jle    c010b524 <getint+0x1d>
        return va_arg(*ap, long long);
c010b510:	8b 45 08             	mov    0x8(%ebp),%eax
c010b513:	8b 00                	mov    (%eax),%eax
c010b515:	8d 48 08             	lea    0x8(%eax),%ecx
c010b518:	8b 55 08             	mov    0x8(%ebp),%edx
c010b51b:	89 0a                	mov    %ecx,(%edx)
c010b51d:	8b 50 04             	mov    0x4(%eax),%edx
c010b520:	8b 00                	mov    (%eax),%eax
c010b522:	eb 30                	jmp    c010b554 <getint+0x4d>
    }
    else if (lflag) {
c010b524:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010b528:	74 16                	je     c010b540 <getint+0x39>
        return va_arg(*ap, long);
c010b52a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b52d:	8b 00                	mov    (%eax),%eax
c010b52f:	8d 48 04             	lea    0x4(%eax),%ecx
c010b532:	8b 55 08             	mov    0x8(%ebp),%edx
c010b535:	89 0a                	mov    %ecx,(%edx)
c010b537:	8b 00                	mov    (%eax),%eax
c010b539:	89 c2                	mov    %eax,%edx
c010b53b:	c1 fa 1f             	sar    $0x1f,%edx
c010b53e:	eb 14                	jmp    c010b554 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
c010b540:	8b 45 08             	mov    0x8(%ebp),%eax
c010b543:	8b 00                	mov    (%eax),%eax
c010b545:	8d 48 04             	lea    0x4(%eax),%ecx
c010b548:	8b 55 08             	mov    0x8(%ebp),%edx
c010b54b:	89 0a                	mov    %ecx,(%edx)
c010b54d:	8b 00                	mov    (%eax),%eax
c010b54f:	89 c2                	mov    %eax,%edx
c010b551:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
c010b554:	5d                   	pop    %ebp
c010b555:	c3                   	ret    

c010b556 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c010b556:	55                   	push   %ebp
c010b557:	89 e5                	mov    %esp,%ebp
c010b559:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c010b55c:	8d 55 14             	lea    0x14(%ebp),%edx
c010b55f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c010b562:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
c010b564:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010b567:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b56b:	8b 45 10             	mov    0x10(%ebp),%eax
c010b56e:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b572:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b575:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b579:	8b 45 08             	mov    0x8(%ebp),%eax
c010b57c:	89 04 24             	mov    %eax,(%esp)
c010b57f:	e8 02 00 00 00       	call   c010b586 <vprintfmt>
    va_end(ap);
}
c010b584:	c9                   	leave  
c010b585:	c3                   	ret    

c010b586 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c010b586:	55                   	push   %ebp
c010b587:	89 e5                	mov    %esp,%ebp
c010b589:	56                   	push   %esi
c010b58a:	53                   	push   %ebx
c010b58b:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b58e:	eb 17                	jmp    c010b5a7 <vprintfmt+0x21>
            if (ch == '\0') {
c010b590:	85 db                	test   %ebx,%ebx
c010b592:	0f 84 db 03 00 00    	je     c010b973 <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
c010b598:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b59b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b59f:	89 1c 24             	mov    %ebx,(%esp)
c010b5a2:	8b 45 08             	mov    0x8(%ebp),%eax
c010b5a5:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b5a7:	8b 45 10             	mov    0x10(%ebp),%eax
c010b5aa:	0f b6 00             	movzbl (%eax),%eax
c010b5ad:	0f b6 d8             	movzbl %al,%ebx
c010b5b0:	83 fb 25             	cmp    $0x25,%ebx
c010b5b3:	0f 95 c0             	setne  %al
c010b5b6:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c010b5ba:	84 c0                	test   %al,%al
c010b5bc:	75 d2                	jne    c010b590 <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010b5be:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010b5c2:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c010b5c9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b5cc:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010b5cf:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c010b5d6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010b5d9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010b5dc:	eb 04                	jmp    c010b5e2 <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
c010b5de:	90                   	nop
c010b5df:	eb 01                	jmp    c010b5e2 <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
c010b5e1:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010b5e2:	8b 45 10             	mov    0x10(%ebp),%eax
c010b5e5:	0f b6 00             	movzbl (%eax),%eax
c010b5e8:	0f b6 d8             	movzbl %al,%ebx
c010b5eb:	89 d8                	mov    %ebx,%eax
c010b5ed:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c010b5f1:	83 e8 23             	sub    $0x23,%eax
c010b5f4:	83 f8 55             	cmp    $0x55,%eax
c010b5f7:	0f 87 45 03 00 00    	ja     c010b942 <vprintfmt+0x3bc>
c010b5fd:	8b 04 85 c8 e6 10 c0 	mov    -0x3fef1938(,%eax,4),%eax
c010b604:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c010b606:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c010b60a:	eb d6                	jmp    c010b5e2 <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c010b60c:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010b610:	eb d0                	jmp    c010b5e2 <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b612:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c010b619:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010b61c:	89 d0                	mov    %edx,%eax
c010b61e:	c1 e0 02             	shl    $0x2,%eax
c010b621:	01 d0                	add    %edx,%eax
c010b623:	01 c0                	add    %eax,%eax
c010b625:	01 d8                	add    %ebx,%eax
c010b627:	83 e8 30             	sub    $0x30,%eax
c010b62a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c010b62d:	8b 45 10             	mov    0x10(%ebp),%eax
c010b630:	0f b6 00             	movzbl (%eax),%eax
c010b633:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c010b636:	83 fb 2f             	cmp    $0x2f,%ebx
c010b639:	7e 39                	jle    c010b674 <vprintfmt+0xee>
c010b63b:	83 fb 39             	cmp    $0x39,%ebx
c010b63e:	7f 34                	jg     c010b674 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010b640:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c010b644:	eb d3                	jmp    c010b619 <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c010b646:	8b 45 14             	mov    0x14(%ebp),%eax
c010b649:	8d 50 04             	lea    0x4(%eax),%edx
c010b64c:	89 55 14             	mov    %edx,0x14(%ebp)
c010b64f:	8b 00                	mov    (%eax),%eax
c010b651:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c010b654:	eb 1f                	jmp    c010b675 <vprintfmt+0xef>

        case '.':
            if (width < 0)
c010b656:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b65a:	79 82                	jns    c010b5de <vprintfmt+0x58>
                width = 0;
c010b65c:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c010b663:	e9 76 ff ff ff       	jmp    c010b5de <vprintfmt+0x58>

        case '#':
            altflag = 1;
c010b668:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c010b66f:	e9 6e ff ff ff       	jmp    c010b5e2 <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c010b674:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c010b675:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b679:	0f 89 62 ff ff ff    	jns    c010b5e1 <vprintfmt+0x5b>
                width = precision, precision = -1;
c010b67f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b682:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b685:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c010b68c:	e9 50 ff ff ff       	jmp    c010b5e1 <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c010b691:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c010b695:	e9 48 ff ff ff       	jmp    c010b5e2 <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c010b69a:	8b 45 14             	mov    0x14(%ebp),%eax
c010b69d:	8d 50 04             	lea    0x4(%eax),%edx
c010b6a0:	89 55 14             	mov    %edx,0x14(%ebp)
c010b6a3:	8b 00                	mov    (%eax),%eax
c010b6a5:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b6a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b6ac:	89 04 24             	mov    %eax,(%esp)
c010b6af:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6b2:	ff d0                	call   *%eax
            break;
c010b6b4:	e9 b4 02 00 00       	jmp    c010b96d <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
c010b6b9:	8b 45 14             	mov    0x14(%ebp),%eax
c010b6bc:	8d 50 04             	lea    0x4(%eax),%edx
c010b6bf:	89 55 14             	mov    %edx,0x14(%ebp)
c010b6c2:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c010b6c4:	85 db                	test   %ebx,%ebx
c010b6c6:	79 02                	jns    c010b6ca <vprintfmt+0x144>
                err = -err;
c010b6c8:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c010b6ca:	83 fb 18             	cmp    $0x18,%ebx
c010b6cd:	7f 0b                	jg     c010b6da <vprintfmt+0x154>
c010b6cf:	8b 34 9d 40 e6 10 c0 	mov    -0x3fef19c0(,%ebx,4),%esi
c010b6d6:	85 f6                	test   %esi,%esi
c010b6d8:	75 23                	jne    c010b6fd <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
c010b6da:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010b6de:	c7 44 24 08 b5 e6 10 	movl   $0xc010e6b5,0x8(%esp)
c010b6e5:	c0 
c010b6e6:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b6e9:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b6ed:	8b 45 08             	mov    0x8(%ebp),%eax
c010b6f0:	89 04 24             	mov    %eax,(%esp)
c010b6f3:	e8 5e fe ff ff       	call   c010b556 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c010b6f8:	e9 70 02 00 00       	jmp    c010b96d <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c010b6fd:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010b701:	c7 44 24 08 be e6 10 	movl   $0xc010e6be,0x8(%esp)
c010b708:	c0 
c010b709:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b70c:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b710:	8b 45 08             	mov    0x8(%ebp),%eax
c010b713:	89 04 24             	mov    %eax,(%esp)
c010b716:	e8 3b fe ff ff       	call   c010b556 <printfmt>
            }
            break;
c010b71b:	e9 4d 02 00 00       	jmp    c010b96d <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010b720:	8b 45 14             	mov    0x14(%ebp),%eax
c010b723:	8d 50 04             	lea    0x4(%eax),%edx
c010b726:	89 55 14             	mov    %edx,0x14(%ebp)
c010b729:	8b 30                	mov    (%eax),%esi
c010b72b:	85 f6                	test   %esi,%esi
c010b72d:	75 05                	jne    c010b734 <vprintfmt+0x1ae>
                p = "(null)";
c010b72f:	be c1 e6 10 c0       	mov    $0xc010e6c1,%esi
            }
            if (width > 0 && padc != '-') {
c010b734:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b738:	7e 7c                	jle    c010b7b6 <vprintfmt+0x230>
c010b73a:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010b73e:	74 76                	je     c010b7b6 <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b740:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010b743:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010b746:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b74a:	89 34 24             	mov    %esi,(%esp)
c010b74d:	e8 25 04 00 00       	call   c010bb77 <strnlen>
c010b752:	89 da                	mov    %ebx,%edx
c010b754:	29 c2                	sub    %eax,%edx
c010b756:	89 d0                	mov    %edx,%eax
c010b758:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010b75b:	eb 17                	jmp    c010b774 <vprintfmt+0x1ee>
                    putch(padc, putdat);
c010b75d:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c010b761:	8b 55 0c             	mov    0xc(%ebp),%edx
c010b764:	89 54 24 04          	mov    %edx,0x4(%esp)
c010b768:	89 04 24             	mov    %eax,(%esp)
c010b76b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b76e:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c010b770:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b774:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b778:	7f e3                	jg     c010b75d <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b77a:	eb 3a                	jmp    c010b7b6 <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
c010b77c:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c010b780:	74 1f                	je     c010b7a1 <vprintfmt+0x21b>
c010b782:	83 fb 1f             	cmp    $0x1f,%ebx
c010b785:	7e 05                	jle    c010b78c <vprintfmt+0x206>
c010b787:	83 fb 7e             	cmp    $0x7e,%ebx
c010b78a:	7e 15                	jle    c010b7a1 <vprintfmt+0x21b>
                    putch('?', putdat);
c010b78c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b78f:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b793:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c010b79a:	8b 45 08             	mov    0x8(%ebp),%eax
c010b79d:	ff d0                	call   *%eax
c010b79f:	eb 0f                	jmp    c010b7b0 <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
c010b7a1:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b7a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b7a8:	89 1c 24             	mov    %ebx,(%esp)
c010b7ab:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7ae:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010b7b0:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b7b4:	eb 01                	jmp    c010b7b7 <vprintfmt+0x231>
c010b7b6:	90                   	nop
c010b7b7:	0f b6 06             	movzbl (%esi),%eax
c010b7ba:	0f be d8             	movsbl %al,%ebx
c010b7bd:	85 db                	test   %ebx,%ebx
c010b7bf:	0f 95 c0             	setne  %al
c010b7c2:	83 c6 01             	add    $0x1,%esi
c010b7c5:	84 c0                	test   %al,%al
c010b7c7:	74 29                	je     c010b7f2 <vprintfmt+0x26c>
c010b7c9:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b7cd:	78 ad                	js     c010b77c <vprintfmt+0x1f6>
c010b7cf:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010b7d3:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c010b7d7:	79 a3                	jns    c010b77c <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b7d9:	eb 17                	jmp    c010b7f2 <vprintfmt+0x26c>
                putch(' ', putdat);
c010b7db:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b7de:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b7e2:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010b7e9:	8b 45 08             	mov    0x8(%ebp),%eax
c010b7ec:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010b7ee:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010b7f2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010b7f6:	7f e3                	jg     c010b7db <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
c010b7f8:	e9 70 01 00 00       	jmp    c010b96d <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c010b7fd:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b800:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b804:	8d 45 14             	lea    0x14(%ebp),%eax
c010b807:	89 04 24             	mov    %eax,(%esp)
c010b80a:	e8 f8 fc ff ff       	call   c010b507 <getint>
c010b80f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b812:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c010b815:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b818:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b81b:	85 d2                	test   %edx,%edx
c010b81d:	79 26                	jns    c010b845 <vprintfmt+0x2bf>
                putch('-', putdat);
c010b81f:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b822:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b826:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c010b82d:	8b 45 08             	mov    0x8(%ebp),%eax
c010b830:	ff d0                	call   *%eax
                num = -(long long)num;
c010b832:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b835:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b838:	f7 d8                	neg    %eax
c010b83a:	83 d2 00             	adc    $0x0,%edx
c010b83d:	f7 da                	neg    %edx
c010b83f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b842:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c010b845:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b84c:	e9 a8 00 00 00       	jmp    c010b8f9 <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010b851:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b854:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b858:	8d 45 14             	lea    0x14(%ebp),%eax
c010b85b:	89 04 24             	mov    %eax,(%esp)
c010b85e:	e8 55 fc ff ff       	call   c010b4b8 <getuint>
c010b863:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b866:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c010b869:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c010b870:	e9 84 00 00 00       	jmp    c010b8f9 <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c010b875:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b878:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b87c:	8d 45 14             	lea    0x14(%ebp),%eax
c010b87f:	89 04 24             	mov    %eax,(%esp)
c010b882:	e8 31 fc ff ff       	call   c010b4b8 <getuint>
c010b887:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b88a:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c010b88d:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c010b894:	eb 63                	jmp    c010b8f9 <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
c010b896:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b899:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b89d:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c010b8a4:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8a7:	ff d0                	call   *%eax
            putch('x', putdat);
c010b8a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b8ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b8b0:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c010b8b7:	8b 45 08             	mov    0x8(%ebp),%eax
c010b8ba:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c010b8bc:	8b 45 14             	mov    0x14(%ebp),%eax
c010b8bf:	8d 50 04             	lea    0x4(%eax),%edx
c010b8c2:	89 55 14             	mov    %edx,0x14(%ebp)
c010b8c5:	8b 00                	mov    (%eax),%eax
c010b8c7:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b8ca:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010b8d1:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c010b8d8:	eb 1f                	jmp    c010b8f9 <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c010b8da:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010b8dd:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b8e1:	8d 45 14             	lea    0x14(%ebp),%eax
c010b8e4:	89 04 24             	mov    %eax,(%esp)
c010b8e7:	e8 cc fb ff ff       	call   c010b4b8 <getuint>
c010b8ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b8ef:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010b8f2:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c010b8f9:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c010b8fd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010b900:	89 54 24 18          	mov    %edx,0x18(%esp)
c010b904:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010b907:	89 54 24 14          	mov    %edx,0x14(%esp)
c010b90b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010b90f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b912:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010b915:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b919:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010b91d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b920:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b924:	8b 45 08             	mov    0x8(%ebp),%eax
c010b927:	89 04 24             	mov    %eax,(%esp)
c010b92a:	e8 51 fa ff ff       	call   c010b380 <printnum>
            break;
c010b92f:	eb 3c                	jmp    c010b96d <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010b931:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b934:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b938:	89 1c 24             	mov    %ebx,(%esp)
c010b93b:	8b 45 08             	mov    0x8(%ebp),%eax
c010b93e:	ff d0                	call   *%eax
            break;
c010b940:	eb 2b                	jmp    c010b96d <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010b942:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b945:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b949:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010b950:	8b 45 08             	mov    0x8(%ebp),%eax
c010b953:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c010b955:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b959:	eb 04                	jmp    c010b95f <vprintfmt+0x3d9>
c010b95b:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010b95f:	8b 45 10             	mov    0x10(%ebp),%eax
c010b962:	83 e8 01             	sub    $0x1,%eax
c010b965:	0f b6 00             	movzbl (%eax),%eax
c010b968:	3c 25                	cmp    $0x25,%al
c010b96a:	75 ef                	jne    c010b95b <vprintfmt+0x3d5>
                /* do nothing */;
            break;
c010b96c:	90                   	nop
        }
    }
c010b96d:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c010b96e:	e9 34 fc ff ff       	jmp    c010b5a7 <vprintfmt+0x21>
            if (ch == '\0') {
                return;
c010b973:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c010b974:	83 c4 40             	add    $0x40,%esp
c010b977:	5b                   	pop    %ebx
c010b978:	5e                   	pop    %esi
c010b979:	5d                   	pop    %ebp
c010b97a:	c3                   	ret    

c010b97b <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c010b97b:	55                   	push   %ebp
c010b97c:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c010b97e:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b981:	8b 40 08             	mov    0x8(%eax),%eax
c010b984:	8d 50 01             	lea    0x1(%eax),%edx
c010b987:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b98a:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c010b98d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b990:	8b 10                	mov    (%eax),%edx
c010b992:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b995:	8b 40 04             	mov    0x4(%eax),%eax
c010b998:	39 c2                	cmp    %eax,%edx
c010b99a:	73 12                	jae    c010b9ae <sprintputch+0x33>
        *b->buf ++ = ch;
c010b99c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b99f:	8b 00                	mov    (%eax),%eax
c010b9a1:	8b 55 08             	mov    0x8(%ebp),%edx
c010b9a4:	88 10                	mov    %dl,(%eax)
c010b9a6:	8d 50 01             	lea    0x1(%eax),%edx
c010b9a9:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b9ac:	89 10                	mov    %edx,(%eax)
    }
}
c010b9ae:	5d                   	pop    %ebp
c010b9af:	c3                   	ret    

c010b9b0 <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010b9b0:	55                   	push   %ebp
c010b9b1:	89 e5                	mov    %esp,%ebp
c010b9b3:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010b9b6:	8d 55 14             	lea    0x14(%ebp),%edx
c010b9b9:	8d 45 f0             	lea    -0x10(%ebp),%eax
c010b9bc:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
c010b9be:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010b9c1:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010b9c5:	8b 45 10             	mov    0x10(%ebp),%eax
c010b9c8:	89 44 24 08          	mov    %eax,0x8(%esp)
c010b9cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b9cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c010b9d3:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9d6:	89 04 24             	mov    %eax,(%esp)
c010b9d9:	e8 08 00 00 00       	call   c010b9e6 <vsnprintf>
c010b9de:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010b9e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010b9e4:	c9                   	leave  
c010b9e5:	c3                   	ret    

c010b9e6 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c010b9e6:	55                   	push   %ebp
c010b9e7:	89 e5                	mov    %esp,%ebp
c010b9e9:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c010b9ec:	8b 45 08             	mov    0x8(%ebp),%eax
c010b9ef:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010b9f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c010b9f5:	83 e8 01             	sub    $0x1,%eax
c010b9f8:	03 45 08             	add    0x8(%ebp),%eax
c010b9fb:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010b9fe:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c010ba05:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010ba09:	74 0a                	je     c010ba15 <vsnprintf+0x2f>
c010ba0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010ba0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010ba11:	39 c2                	cmp    %eax,%edx
c010ba13:	76 07                	jbe    c010ba1c <vsnprintf+0x36>
        return -E_INVAL;
c010ba15:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c010ba1a:	eb 2a                	jmp    c010ba46 <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c010ba1c:	8b 45 14             	mov    0x14(%ebp),%eax
c010ba1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010ba23:	8b 45 10             	mov    0x10(%ebp),%eax
c010ba26:	89 44 24 08          	mov    %eax,0x8(%esp)
c010ba2a:	8d 45 ec             	lea    -0x14(%ebp),%eax
c010ba2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c010ba31:	c7 04 24 7b b9 10 c0 	movl   $0xc010b97b,(%esp)
c010ba38:	e8 49 fb ff ff       	call   c010b586 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c010ba3d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010ba40:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010ba43:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010ba46:	c9                   	leave  
c010ba47:	c3                   	ret    

c010ba48 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c010ba48:	55                   	push   %ebp
c010ba49:	89 e5                	mov    %esp,%ebp
c010ba4b:	57                   	push   %edi
c010ba4c:	56                   	push   %esi
c010ba4d:	53                   	push   %ebx
c010ba4e:	83 ec 34             	sub    $0x34,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c010ba51:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010ba56:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010ba5c:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c010ba62:	6b c8 05             	imul   $0x5,%eax,%ecx
c010ba65:	01 cf                	add    %ecx,%edi
c010ba67:	b9 6d e6 ec de       	mov    $0xdeece66d,%ecx
c010ba6c:	f7 e1                	mul    %ecx
c010ba6e:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
c010ba71:	89 ca                	mov    %ecx,%edx
c010ba73:	83 c0 0b             	add    $0xb,%eax
c010ba76:	83 d2 00             	adc    $0x0,%edx
c010ba79:	89 c3                	mov    %eax,%ebx
c010ba7b:	80 e7 ff             	and    $0xff,%bh
c010ba7e:	0f b7 f2             	movzwl %dx,%esi
c010ba81:	89 1d 20 ab 12 c0    	mov    %ebx,0xc012ab20
c010ba87:	89 35 24 ab 12 c0    	mov    %esi,0xc012ab24
    unsigned long long result = (next >> 12);
c010ba8d:	a1 20 ab 12 c0       	mov    0xc012ab20,%eax
c010ba92:	8b 15 24 ab 12 c0    	mov    0xc012ab24,%edx
c010ba98:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010ba9c:	c1 ea 0c             	shr    $0xc,%edx
c010ba9f:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010baa2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c010baa5:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c010baac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010baaf:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010bab2:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010bab5:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010bab8:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010babb:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010babe:	89 d3                	mov    %edx,%ebx
c010bac0:	89 c6                	mov    %eax,%esi
c010bac2:	89 75 d8             	mov    %esi,-0x28(%ebp)
c010bac5:	89 5d e8             	mov    %ebx,-0x18(%ebp)
c010bac8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bacb:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010bace:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010bad2:	74 1c                	je     c010baf0 <rand+0xa8>
c010bad4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bad7:	ba 00 00 00 00       	mov    $0x0,%edx
c010badc:	f7 75 dc             	divl   -0x24(%ebp)
c010badf:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010bae2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bae5:	ba 00 00 00 00       	mov    $0x0,%edx
c010baea:	f7 75 dc             	divl   -0x24(%ebp)
c010baed:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010baf0:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010baf3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010baf6:	89 d6                	mov    %edx,%esi
c010baf8:	89 c3                	mov    %eax,%ebx
c010bafa:	89 f0                	mov    %esi,%eax
c010bafc:	89 da                	mov    %ebx,%edx
c010bafe:	f7 75 dc             	divl   -0x24(%ebp)
c010bb01:	89 d3                	mov    %edx,%ebx
c010bb03:	89 c6                	mov    %eax,%esi
c010bb05:	89 75 d8             	mov    %esi,-0x28(%ebp)
c010bb08:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
c010bb0b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010bb0e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010bb11:	8b 55 e8             	mov    -0x18(%ebp),%edx
c010bb14:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010bb17:	8b 45 c8             	mov    -0x38(%ebp),%eax
c010bb1a:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c010bb1d:	89 c3                	mov    %eax,%ebx
c010bb1f:	89 d6                	mov    %edx,%esi
c010bb21:	89 5d e0             	mov    %ebx,-0x20(%ebp)
c010bb24:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c010bb27:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c010bb2a:	83 c4 34             	add    $0x34,%esp
c010bb2d:	5b                   	pop    %ebx
c010bb2e:	5e                   	pop    %esi
c010bb2f:	5f                   	pop    %edi
c010bb30:	5d                   	pop    %ebp
c010bb31:	c3                   	ret    

c010bb32 <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010bb32:	55                   	push   %ebp
c010bb33:	89 e5                	mov    %esp,%ebp
    next = seed;
c010bb35:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb38:	ba 00 00 00 00       	mov    $0x0,%edx
c010bb3d:	a3 20 ab 12 c0       	mov    %eax,0xc012ab20
c010bb42:	89 15 24 ab 12 c0    	mov    %edx,0xc012ab24
}
c010bb48:	5d                   	pop    %ebp
c010bb49:	c3                   	ret    
	...

c010bb4c <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c010bb4c:	55                   	push   %ebp
c010bb4d:	89 e5                	mov    %esp,%ebp
c010bb4f:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010bb52:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c010bb59:	eb 04                	jmp    c010bb5f <strlen+0x13>
        cnt ++;
c010bb5b:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c010bb5f:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb62:	0f b6 00             	movzbl (%eax),%eax
c010bb65:	84 c0                	test   %al,%al
c010bb67:	0f 95 c0             	setne  %al
c010bb6a:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bb6e:	84 c0                	test   %al,%al
c010bb70:	75 e9                	jne    c010bb5b <strlen+0xf>
        cnt ++;
    }
    return cnt;
c010bb72:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010bb75:	c9                   	leave  
c010bb76:	c3                   	ret    

c010bb77 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c010bb77:	55                   	push   %ebp
c010bb78:	89 e5                	mov    %esp,%ebp
c010bb7a:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c010bb7d:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c010bb84:	eb 04                	jmp    c010bb8a <strnlen+0x13>
        cnt ++;
c010bb86:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c010bb8a:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bb8d:	3b 45 0c             	cmp    0xc(%ebp),%eax
c010bb90:	73 13                	jae    c010bba5 <strnlen+0x2e>
c010bb92:	8b 45 08             	mov    0x8(%ebp),%eax
c010bb95:	0f b6 00             	movzbl (%eax),%eax
c010bb98:	84 c0                	test   %al,%al
c010bb9a:	0f 95 c0             	setne  %al
c010bb9d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bba1:	84 c0                	test   %al,%al
c010bba3:	75 e1                	jne    c010bb86 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c010bba5:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010bba8:	c9                   	leave  
c010bba9:	c3                   	ret    

c010bbaa <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c010bbaa:	55                   	push   %ebp
c010bbab:	89 e5                	mov    %esp,%ebp
c010bbad:	57                   	push   %edi
c010bbae:	56                   	push   %esi
c010bbaf:	53                   	push   %ebx
c010bbb0:	83 ec 24             	sub    $0x24,%esp
c010bbb3:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbb6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bbb9:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bbbc:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c010bbbf:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010bbc2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bbc5:	89 d6                	mov    %edx,%esi
c010bbc7:	89 c3                	mov    %eax,%ebx
c010bbc9:	89 df                	mov    %ebx,%edi
c010bbcb:	ac                   	lods   %ds:(%esi),%al
c010bbcc:	aa                   	stos   %al,%es:(%edi)
c010bbcd:	84 c0                	test   %al,%al
c010bbcf:	75 fa                	jne    c010bbcb <strcpy+0x21>
c010bbd1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010bbd4:	89 fb                	mov    %edi,%ebx
c010bbd6:	89 75 e8             	mov    %esi,-0x18(%ebp)
c010bbd9:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
c010bbdc:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010bbdf:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c010bbe2:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c010bbe5:	83 c4 24             	add    $0x24,%esp
c010bbe8:	5b                   	pop    %ebx
c010bbe9:	5e                   	pop    %esi
c010bbea:	5f                   	pop    %edi
c010bbeb:	5d                   	pop    %ebp
c010bbec:	c3                   	ret    

c010bbed <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c010bbed:	55                   	push   %ebp
c010bbee:	89 e5                	mov    %esp,%ebp
c010bbf0:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c010bbf3:	8b 45 08             	mov    0x8(%ebp),%eax
c010bbf6:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c010bbf9:	eb 21                	jmp    c010bc1c <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c010bbfb:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bbfe:	0f b6 10             	movzbl (%eax),%edx
c010bc01:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bc04:	88 10                	mov    %dl,(%eax)
c010bc06:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bc09:	0f b6 00             	movzbl (%eax),%eax
c010bc0c:	84 c0                	test   %al,%al
c010bc0e:	74 04                	je     c010bc14 <strncpy+0x27>
            src ++;
c010bc10:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c010bc14:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010bc18:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c010bc1c:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bc20:	75 d9                	jne    c010bbfb <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c010bc22:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010bc25:	c9                   	leave  
c010bc26:	c3                   	ret    

c010bc27 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c010bc27:	55                   	push   %ebp
c010bc28:	89 e5                	mov    %esp,%ebp
c010bc2a:	57                   	push   %edi
c010bc2b:	56                   	push   %esi
c010bc2c:	53                   	push   %ebx
c010bc2d:	83 ec 24             	sub    $0x24,%esp
c010bc30:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc33:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bc36:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bc39:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c010bc3c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010bc3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bc42:	89 d6                	mov    %edx,%esi
c010bc44:	89 c3                	mov    %eax,%ebx
c010bc46:	89 df                	mov    %ebx,%edi
c010bc48:	ac                   	lods   %ds:(%esi),%al
c010bc49:	ae                   	scas   %es:(%edi),%al
c010bc4a:	75 08                	jne    c010bc54 <strcmp+0x2d>
c010bc4c:	84 c0                	test   %al,%al
c010bc4e:	75 f8                	jne    c010bc48 <strcmp+0x21>
c010bc50:	31 c0                	xor    %eax,%eax
c010bc52:	eb 04                	jmp    c010bc58 <strcmp+0x31>
c010bc54:	19 c0                	sbb    %eax,%eax
c010bc56:	0c 01                	or     $0x1,%al
c010bc58:	89 fb                	mov    %edi,%ebx
c010bc5a:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010bc5d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010bc60:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010bc63:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c010bc66:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c010bc69:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c010bc6c:	83 c4 24             	add    $0x24,%esp
c010bc6f:	5b                   	pop    %ebx
c010bc70:	5e                   	pop    %esi
c010bc71:	5f                   	pop    %edi
c010bc72:	5d                   	pop    %ebp
c010bc73:	c3                   	ret    

c010bc74 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c010bc74:	55                   	push   %ebp
c010bc75:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010bc77:	eb 0c                	jmp    c010bc85 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c010bc79:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010bc7d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bc81:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c010bc85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bc89:	74 1a                	je     c010bca5 <strncmp+0x31>
c010bc8b:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc8e:	0f b6 00             	movzbl (%eax),%eax
c010bc91:	84 c0                	test   %al,%al
c010bc93:	74 10                	je     c010bca5 <strncmp+0x31>
c010bc95:	8b 45 08             	mov    0x8(%ebp),%eax
c010bc98:	0f b6 10             	movzbl (%eax),%edx
c010bc9b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bc9e:	0f b6 00             	movzbl (%eax),%eax
c010bca1:	38 c2                	cmp    %al,%dl
c010bca3:	74 d4                	je     c010bc79 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c010bca5:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bca9:	74 1a                	je     c010bcc5 <strncmp+0x51>
c010bcab:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcae:	0f b6 00             	movzbl (%eax),%eax
c010bcb1:	0f b6 d0             	movzbl %al,%edx
c010bcb4:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bcb7:	0f b6 00             	movzbl (%eax),%eax
c010bcba:	0f b6 c0             	movzbl %al,%eax
c010bcbd:	89 d1                	mov    %edx,%ecx
c010bcbf:	29 c1                	sub    %eax,%ecx
c010bcc1:	89 c8                	mov    %ecx,%eax
c010bcc3:	eb 05                	jmp    c010bcca <strncmp+0x56>
c010bcc5:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bcca:	5d                   	pop    %ebp
c010bccb:	c3                   	ret    

c010bccc <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c010bccc:	55                   	push   %ebp
c010bccd:	89 e5                	mov    %esp,%ebp
c010bccf:	83 ec 04             	sub    $0x4,%esp
c010bcd2:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bcd5:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010bcd8:	eb 14                	jmp    c010bcee <strchr+0x22>
        if (*s == c) {
c010bcda:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcdd:	0f b6 00             	movzbl (%eax),%eax
c010bce0:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010bce3:	75 05                	jne    c010bcea <strchr+0x1e>
            return (char *)s;
c010bce5:	8b 45 08             	mov    0x8(%ebp),%eax
c010bce8:	eb 13                	jmp    c010bcfd <strchr+0x31>
        }
        s ++;
c010bcea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c010bcee:	8b 45 08             	mov    0x8(%ebp),%eax
c010bcf1:	0f b6 00             	movzbl (%eax),%eax
c010bcf4:	84 c0                	test   %al,%al
c010bcf6:	75 e2                	jne    c010bcda <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c010bcf8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010bcfd:	c9                   	leave  
c010bcfe:	c3                   	ret    

c010bcff <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c010bcff:	55                   	push   %ebp
c010bd00:	89 e5                	mov    %esp,%ebp
c010bd02:	83 ec 04             	sub    $0x4,%esp
c010bd05:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bd08:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c010bd0b:	eb 0f                	jmp    c010bd1c <strfind+0x1d>
        if (*s == c) {
c010bd0d:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd10:	0f b6 00             	movzbl (%eax),%eax
c010bd13:	3a 45 fc             	cmp    -0x4(%ebp),%al
c010bd16:	74 10                	je     c010bd28 <strfind+0x29>
            break;
        }
        s ++;
c010bd18:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c010bd1c:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd1f:	0f b6 00             	movzbl (%eax),%eax
c010bd22:	84 c0                	test   %al,%al
c010bd24:	75 e7                	jne    c010bd0d <strfind+0xe>
c010bd26:	eb 01                	jmp    c010bd29 <strfind+0x2a>
        if (*s == c) {
            break;
c010bd28:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c010bd29:	8b 45 08             	mov    0x8(%ebp),%eax
}
c010bd2c:	c9                   	leave  
c010bd2d:	c3                   	ret    

c010bd2e <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c010bd2e:	55                   	push   %ebp
c010bd2f:	89 e5                	mov    %esp,%ebp
c010bd31:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c010bd34:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c010bd3b:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010bd42:	eb 04                	jmp    c010bd48 <strtol+0x1a>
        s ++;
c010bd44:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c010bd48:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd4b:	0f b6 00             	movzbl (%eax),%eax
c010bd4e:	3c 20                	cmp    $0x20,%al
c010bd50:	74 f2                	je     c010bd44 <strtol+0x16>
c010bd52:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd55:	0f b6 00             	movzbl (%eax),%eax
c010bd58:	3c 09                	cmp    $0x9,%al
c010bd5a:	74 e8                	je     c010bd44 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c010bd5c:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd5f:	0f b6 00             	movzbl (%eax),%eax
c010bd62:	3c 2b                	cmp    $0x2b,%al
c010bd64:	75 06                	jne    c010bd6c <strtol+0x3e>
        s ++;
c010bd66:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bd6a:	eb 15                	jmp    c010bd81 <strtol+0x53>
    }
    else if (*s == '-') {
c010bd6c:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd6f:	0f b6 00             	movzbl (%eax),%eax
c010bd72:	3c 2d                	cmp    $0x2d,%al
c010bd74:	75 0b                	jne    c010bd81 <strtol+0x53>
        s ++, neg = 1;
c010bd76:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bd7a:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c010bd81:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bd85:	74 06                	je     c010bd8d <strtol+0x5f>
c010bd87:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c010bd8b:	75 24                	jne    c010bdb1 <strtol+0x83>
c010bd8d:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd90:	0f b6 00             	movzbl (%eax),%eax
c010bd93:	3c 30                	cmp    $0x30,%al
c010bd95:	75 1a                	jne    c010bdb1 <strtol+0x83>
c010bd97:	8b 45 08             	mov    0x8(%ebp),%eax
c010bd9a:	83 c0 01             	add    $0x1,%eax
c010bd9d:	0f b6 00             	movzbl (%eax),%eax
c010bda0:	3c 78                	cmp    $0x78,%al
c010bda2:	75 0d                	jne    c010bdb1 <strtol+0x83>
        s += 2, base = 16;
c010bda4:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c010bda8:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c010bdaf:	eb 2a                	jmp    c010bddb <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c010bdb1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bdb5:	75 17                	jne    c010bdce <strtol+0xa0>
c010bdb7:	8b 45 08             	mov    0x8(%ebp),%eax
c010bdba:	0f b6 00             	movzbl (%eax),%eax
c010bdbd:	3c 30                	cmp    $0x30,%al
c010bdbf:	75 0d                	jne    c010bdce <strtol+0xa0>
        s ++, base = 8;
c010bdc1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010bdc5:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c010bdcc:	eb 0d                	jmp    c010bddb <strtol+0xad>
    }
    else if (base == 0) {
c010bdce:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010bdd2:	75 07                	jne    c010bddb <strtol+0xad>
        base = 10;
c010bdd4:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c010bddb:	8b 45 08             	mov    0x8(%ebp),%eax
c010bdde:	0f b6 00             	movzbl (%eax),%eax
c010bde1:	3c 2f                	cmp    $0x2f,%al
c010bde3:	7e 1b                	jle    c010be00 <strtol+0xd2>
c010bde5:	8b 45 08             	mov    0x8(%ebp),%eax
c010bde8:	0f b6 00             	movzbl (%eax),%eax
c010bdeb:	3c 39                	cmp    $0x39,%al
c010bded:	7f 11                	jg     c010be00 <strtol+0xd2>
            dig = *s - '0';
c010bdef:	8b 45 08             	mov    0x8(%ebp),%eax
c010bdf2:	0f b6 00             	movzbl (%eax),%eax
c010bdf5:	0f be c0             	movsbl %al,%eax
c010bdf8:	83 e8 30             	sub    $0x30,%eax
c010bdfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010bdfe:	eb 48                	jmp    c010be48 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c010be00:	8b 45 08             	mov    0x8(%ebp),%eax
c010be03:	0f b6 00             	movzbl (%eax),%eax
c010be06:	3c 60                	cmp    $0x60,%al
c010be08:	7e 1b                	jle    c010be25 <strtol+0xf7>
c010be0a:	8b 45 08             	mov    0x8(%ebp),%eax
c010be0d:	0f b6 00             	movzbl (%eax),%eax
c010be10:	3c 7a                	cmp    $0x7a,%al
c010be12:	7f 11                	jg     c010be25 <strtol+0xf7>
            dig = *s - 'a' + 10;
c010be14:	8b 45 08             	mov    0x8(%ebp),%eax
c010be17:	0f b6 00             	movzbl (%eax),%eax
c010be1a:	0f be c0             	movsbl %al,%eax
c010be1d:	83 e8 57             	sub    $0x57,%eax
c010be20:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010be23:	eb 23                	jmp    c010be48 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c010be25:	8b 45 08             	mov    0x8(%ebp),%eax
c010be28:	0f b6 00             	movzbl (%eax),%eax
c010be2b:	3c 40                	cmp    $0x40,%al
c010be2d:	7e 38                	jle    c010be67 <strtol+0x139>
c010be2f:	8b 45 08             	mov    0x8(%ebp),%eax
c010be32:	0f b6 00             	movzbl (%eax),%eax
c010be35:	3c 5a                	cmp    $0x5a,%al
c010be37:	7f 2e                	jg     c010be67 <strtol+0x139>
            dig = *s - 'A' + 10;
c010be39:	8b 45 08             	mov    0x8(%ebp),%eax
c010be3c:	0f b6 00             	movzbl (%eax),%eax
c010be3f:	0f be c0             	movsbl %al,%eax
c010be42:	83 e8 37             	sub    $0x37,%eax
c010be45:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c010be48:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010be4b:	3b 45 10             	cmp    0x10(%ebp),%eax
c010be4e:	7d 16                	jge    c010be66 <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
c010be50:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c010be54:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010be57:	0f af 45 10          	imul   0x10(%ebp),%eax
c010be5b:	03 45 f4             	add    -0xc(%ebp),%eax
c010be5e:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c010be61:	e9 75 ff ff ff       	jmp    c010bddb <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c010be66:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c010be67:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010be6b:	74 08                	je     c010be75 <strtol+0x147>
        *endptr = (char *) s;
c010be6d:	8b 45 0c             	mov    0xc(%ebp),%eax
c010be70:	8b 55 08             	mov    0x8(%ebp),%edx
c010be73:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c010be75:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010be79:	74 07                	je     c010be82 <strtol+0x154>
c010be7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010be7e:	f7 d8                	neg    %eax
c010be80:	eb 03                	jmp    c010be85 <strtol+0x157>
c010be82:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010be85:	c9                   	leave  
c010be86:	c3                   	ret    

c010be87 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c010be87:	55                   	push   %ebp
c010be88:	89 e5                	mov    %esp,%ebp
c010be8a:	57                   	push   %edi
c010be8b:	56                   	push   %esi
c010be8c:	53                   	push   %ebx
c010be8d:	83 ec 24             	sub    $0x24,%esp
c010be90:	8b 45 0c             	mov    0xc(%ebp),%eax
c010be93:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c010be96:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
c010be9a:	8b 55 08             	mov    0x8(%ebp),%edx
c010be9d:	89 55 f0             	mov    %edx,-0x10(%ebp)
c010bea0:	88 45 ef             	mov    %al,-0x11(%ebp)
c010bea3:	8b 45 10             	mov    0x10(%ebp),%eax
c010bea6:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c010bea9:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010beac:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c010beb0:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010beb3:	89 ce                	mov    %ecx,%esi
c010beb5:	89 d3                	mov    %edx,%ebx
c010beb7:	89 f1                	mov    %esi,%ecx
c010beb9:	89 df                	mov    %ebx,%edi
c010bebb:	f3 aa                	rep stos %al,%es:(%edi)
c010bebd:	89 fb                	mov    %edi,%ebx
c010bebf:	89 ce                	mov    %ecx,%esi
c010bec1:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c010bec4:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c010bec7:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c010beca:	83 c4 24             	add    $0x24,%esp
c010becd:	5b                   	pop    %ebx
c010bece:	5e                   	pop    %esi
c010becf:	5f                   	pop    %edi
c010bed0:	5d                   	pop    %ebp
c010bed1:	c3                   	ret    

c010bed2 <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c010bed2:	55                   	push   %ebp
c010bed3:	89 e5                	mov    %esp,%ebp
c010bed5:	57                   	push   %edi
c010bed6:	56                   	push   %esi
c010bed7:	53                   	push   %ebx
c010bed8:	83 ec 38             	sub    $0x38,%esp
c010bedb:	8b 45 08             	mov    0x8(%ebp),%eax
c010bede:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bee1:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bee4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010bee7:	8b 45 10             	mov    0x10(%ebp),%eax
c010beea:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c010beed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bef0:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010bef3:	73 4e                	jae    c010bf43 <memmove+0x71>
c010bef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010bef8:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010befb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010befe:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010bf01:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bf04:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bf07:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010bf0a:	89 c1                	mov    %eax,%ecx
c010bf0c:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bf0f:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010bf12:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010bf15:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c010bf18:	89 d7                	mov    %edx,%edi
c010bf1a:	89 c3                	mov    %eax,%ebx
c010bf1c:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010bf1f:	89 de                	mov    %ebx,%esi
c010bf21:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bf23:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c010bf26:	83 e1 03             	and    $0x3,%ecx
c010bf29:	74 02                	je     c010bf2d <memmove+0x5b>
c010bf2b:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bf2d:	89 f3                	mov    %esi,%ebx
c010bf2f:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c010bf32:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c010bf35:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c010bf38:	89 7d d4             	mov    %edi,-0x2c(%ebp)
c010bf3b:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bf3e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010bf41:	eb 3b                	jmp    c010bf7e <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c010bf43:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bf46:	83 e8 01             	sub    $0x1,%eax
c010bf49:	89 c2                	mov    %eax,%edx
c010bf4b:	03 55 ec             	add    -0x14(%ebp),%edx
c010bf4e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bf51:	83 e8 01             	sub    $0x1,%eax
c010bf54:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c010bf57:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010bf5a:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c010bf5d:	89 d6                	mov    %edx,%esi
c010bf5f:	89 c3                	mov    %eax,%ebx
c010bf61:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c010bf64:	89 df                	mov    %ebx,%edi
c010bf66:	fd                   	std    
c010bf67:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bf69:	fc                   	cld    
c010bf6a:	89 fb                	mov    %edi,%ebx
c010bf6c:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c010bf6f:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c010bf72:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c010bf75:	89 75 c8             	mov    %esi,-0x38(%ebp)
c010bf78:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c010bf7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c010bf7e:	83 c4 38             	add    $0x38,%esp
c010bf81:	5b                   	pop    %ebx
c010bf82:	5e                   	pop    %esi
c010bf83:	5f                   	pop    %edi
c010bf84:	5d                   	pop    %ebp
c010bf85:	c3                   	ret    

c010bf86 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c010bf86:	55                   	push   %ebp
c010bf87:	89 e5                	mov    %esp,%ebp
c010bf89:	57                   	push   %edi
c010bf8a:	56                   	push   %esi
c010bf8b:	53                   	push   %ebx
c010bf8c:	83 ec 24             	sub    $0x24,%esp
c010bf8f:	8b 45 08             	mov    0x8(%ebp),%eax
c010bf92:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010bf95:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bf98:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010bf9b:	8b 45 10             	mov    0x10(%ebp),%eax
c010bf9e:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c010bfa1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010bfa4:	89 c1                	mov    %eax,%ecx
c010bfa6:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c010bfa9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010bfac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010bfaf:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c010bfb2:	89 d7                	mov    %edx,%edi
c010bfb4:	89 c3                	mov    %eax,%ebx
c010bfb6:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010bfb9:	89 de                	mov    %ebx,%esi
c010bfbb:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010bfbd:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010bfc0:	83 e1 03             	and    $0x3,%ecx
c010bfc3:	74 02                	je     c010bfc7 <memcpy+0x41>
c010bfc5:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010bfc7:	89 f3                	mov    %esi,%ebx
c010bfc9:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c010bfcc:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010bfcf:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
c010bfd2:	89 7d e0             	mov    %edi,-0x20(%ebp)
c010bfd5:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010bfd8:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010bfdb:	83 c4 24             	add    $0x24,%esp
c010bfde:	5b                   	pop    %ebx
c010bfdf:	5e                   	pop    %esi
c010bfe0:	5f                   	pop    %edi
c010bfe1:	5d                   	pop    %ebp
c010bfe2:	c3                   	ret    

c010bfe3 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010bfe3:	55                   	push   %ebp
c010bfe4:	89 e5                	mov    %esp,%ebp
c010bfe6:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010bfe9:	8b 45 08             	mov    0x8(%ebp),%eax
c010bfec:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010bfef:	8b 45 0c             	mov    0xc(%ebp),%eax
c010bff2:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010bff5:	eb 32                	jmp    c010c029 <memcmp+0x46>
        if (*s1 != *s2) {
c010bff7:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010bffa:	0f b6 10             	movzbl (%eax),%edx
c010bffd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010c000:	0f b6 00             	movzbl (%eax),%eax
c010c003:	38 c2                	cmp    %al,%dl
c010c005:	74 1a                	je     c010c021 <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010c007:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010c00a:	0f b6 00             	movzbl (%eax),%eax
c010c00d:	0f b6 d0             	movzbl %al,%edx
c010c010:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010c013:	0f b6 00             	movzbl (%eax),%eax
c010c016:	0f b6 c0             	movzbl %al,%eax
c010c019:	89 d1                	mov    %edx,%ecx
c010c01b:	29 c1                	sub    %eax,%ecx
c010c01d:	89 c8                	mov    %ecx,%eax
c010c01f:	eb 1c                	jmp    c010c03d <memcmp+0x5a>
        }
        s1 ++, s2 ++;
c010c021:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010c025:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010c029:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010c02d:	0f 95 c0             	setne  %al
c010c030:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010c034:	84 c0                	test   %al,%al
c010c036:	75 bf                	jne    c010bff7 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010c038:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010c03d:	c9                   	leave  
c010c03e:	c3                   	ret    
