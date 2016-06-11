
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 50 12 00 	lgdtl  0x125018
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
c010001e:	bc 00 50 12 c0       	mov    $0xc0125000,%esp
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
c0100032:	ba 18 8c 12 c0       	mov    $0xc0128c18,%edx
c0100037:	b8 90 5a 12 c0       	mov    $0xc0125a90,%eax
c010003c:	89 d1                	mov    %edx,%ecx
c010003e:	29 c1                	sub    %eax,%ecx
c0100040:	89 c8                	mov    %ecx,%eax
c0100042:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100046:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010004d:	00 
c010004e:	c7 04 24 90 5a 12 c0 	movl   $0xc0125a90,(%esp)
c0100055:	e8 79 9e 00 00       	call   c0109ed3 <memset>

    cons_init();                // init the console
c010005a:	e8 15 16 00 00       	call   c0101674 <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005f:	c7 45 f4 a0 a0 10 c0 	movl   $0xc010a0a0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100066:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100069:	89 44 24 04          	mov    %eax,0x4(%esp)
c010006d:	c7 04 24 bc a0 10 c0 	movl   $0xc010a0bc,(%esp)
c0100074:	e8 e6 02 00 00       	call   c010035f <cprintf>

    print_kerninfo();
c0100079:	e8 f0 07 00 00       	call   c010086e <print_kerninfo>

    grade_backtrace();
c010007e:	e8 9d 00 00 00       	call   c0100120 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100083:	e8 77 54 00 00       	call   c01054ff <pmm_init>

    pic_init();                 // init interrupt controller
c0100088:	e8 f4 1f 00 00       	call   c0102081 <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008d:	e8 6c 21 00 00       	call   c01021fe <idt_init>

    vmm_init();                 // init virtual memory management
c0100092:	e8 de 7b 00 00       	call   c0107c75 <vmm_init>
    proc_init();                // init process table
c0100097:	e8 9b 8f 00 00       	call   c0109037 <proc_init>
    
    ide_init();                 // init ide devices
c010009c:	e8 12 17 00 00       	call   c01017b3 <ide_init>
    swap_init();                // init swap
c01000a1:	e8 f5 66 00 00       	call   c010679b <swap_init>

    clock_init();               // init clock interrupt
c01000a6:	e8 d9 0c 00 00       	call   c0100d84 <clock_init>
    intr_enable();              // enable irq interrupt
c01000ab:	e8 38 1f 00 00       	call   c0101fe8 <intr_enable>

    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();
    
    cpu_idle();                 // run idle process
c01000b0:	e8 41 91 00 00       	call   c01091f6 <cpu_idle>

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
c01000d2:	e8 d7 0b 00 00       	call   c0100cae <mon_backtrace>
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
c0100163:	a1 a0 5a 12 c0       	mov    0xc0125aa0,%eax
c0100168:	89 54 24 08          	mov    %edx,0x8(%esp)
c010016c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100170:	c7 04 24 c1 a0 10 c0 	movl   $0xc010a0c1,(%esp)
c0100177:	e8 e3 01 00 00       	call   c010035f <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c010017c:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100180:	0f b7 d0             	movzwl %ax,%edx
c0100183:	a1 a0 5a 12 c0       	mov    0xc0125aa0,%eax
c0100188:	89 54 24 08          	mov    %edx,0x8(%esp)
c010018c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100190:	c7 04 24 cf a0 10 c0 	movl   $0xc010a0cf,(%esp)
c0100197:	e8 c3 01 00 00       	call   c010035f <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c010019c:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c01001a0:	0f b7 d0             	movzwl %ax,%edx
c01001a3:	a1 a0 5a 12 c0       	mov    0xc0125aa0,%eax
c01001a8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ac:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001b0:	c7 04 24 dd a0 10 c0 	movl   $0xc010a0dd,(%esp)
c01001b7:	e8 a3 01 00 00       	call   c010035f <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001bc:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001c0:	0f b7 d0             	movzwl %ax,%edx
c01001c3:	a1 a0 5a 12 c0       	mov    0xc0125aa0,%eax
c01001c8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001cc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001d0:	c7 04 24 eb a0 10 c0 	movl   $0xc010a0eb,(%esp)
c01001d7:	e8 83 01 00 00       	call   c010035f <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001dc:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001e0:	0f b7 d0             	movzwl %ax,%edx
c01001e3:	a1 a0 5a 12 c0       	mov    0xc0125aa0,%eax
c01001e8:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001f0:	c7 04 24 f9 a0 10 c0 	movl   $0xc010a0f9,(%esp)
c01001f7:	e8 63 01 00 00       	call   c010035f <cprintf>
    round ++;
c01001fc:	a1 a0 5a 12 c0       	mov    0xc0125aa0,%eax
c0100201:	83 c0 01             	add    $0x1,%eax
c0100204:	a3 a0 5a 12 c0       	mov    %eax,0xc0125aa0
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
c0100220:	c7 04 24 08 a1 10 c0 	movl   $0xc010a108,(%esp)
c0100227:	e8 33 01 00 00       	call   c010035f <cprintf>
    lab1_switch_to_user();
c010022c:	e8 da ff ff ff       	call   c010020b <lab1_switch_to_user>
    lab1_print_cur_status();
c0100231:	e8 0f ff ff ff       	call   c0100145 <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c0100236:	c7 04 24 28 a1 10 c0 	movl   $0xc010a128,(%esp)
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
c0100263:	c7 04 24 47 a1 10 c0 	movl   $0xc010a147,(%esp)
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
c01002ae:	81 c2 c0 5a 12 c0    	add    $0xc0125ac0,%edx
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
c01002f3:	05 c0 5a 12 c0       	add    $0xc0125ac0,%eax
c01002f8:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002fb:	b8 c0 5a 12 c0       	mov    $0xc0125ac0,%eax
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
c0100318:	e8 83 13 00 00       	call   c01016a0 <cons_putc>
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
c0100355:	e8 78 92 00 00       	call   c01095d2 <vprintfmt>
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
c0100393:	e8 08 13 00 00       	call   c01016a0 <cons_putc>
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
c01003f2:	e8 e5 12 00 00       	call   c01016dc <cons_getc>
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
c0100558:	c7 00 4c a1 10 c0    	movl   $0xc010a14c,(%eax)
    info->eip_line = 0;
c010055e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100561:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100568:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056b:	c7 40 08 4c a1 10 c0 	movl   $0xc010a14c,0x8(%eax)
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

    stabs = __STAB_BEGIN__;
c010058f:	c7 45 f4 84 c3 10 c0 	movl   $0xc010c384,-0xc(%ebp)
    stab_end = __STAB_END__;
c0100596:	c7 45 f0 2c db 11 c0 	movl   $0xc011db2c,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c010059d:	c7 45 ec 2d db 11 c0 	movl   $0xc011db2d,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c01005a4:	c7 45 e8 fd 22 12 c0 	movl   $0xc01222fd,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005ae:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005b1:	76 0d                	jbe    c01005c0 <debuginfo_eip+0x72>
c01005b3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005b6:	83 e8 01             	sub    $0x1,%eax
c01005b9:	0f b6 00             	movzbl (%eax),%eax
c01005bc:	84 c0                	test   %al,%al
c01005be:	74 0a                	je     c01005ca <debuginfo_eip+0x7c>
        return -1;
c01005c0:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005c5:	e9 9e 02 00 00       	jmp    c0100868 <debuginfo_eip+0x31a>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005ca:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005d1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005d4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005d7:	89 d1                	mov    %edx,%ecx
c01005d9:	29 c1                	sub    %eax,%ecx
c01005db:	89 c8                	mov    %ecx,%eax
c01005dd:	c1 f8 02             	sar    $0x2,%eax
c01005e0:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005e6:	83 e8 01             	sub    $0x1,%eax
c01005e9:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01005ef:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005f3:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005fa:	00 
c01005fb:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005fe:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100602:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c0100605:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100609:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010060c:	89 04 24             	mov    %eax,(%esp)
c010060f:	e8 f4 fd ff ff       	call   c0100408 <stab_binsearch>
    if (lfile == 0)
c0100614:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100617:	85 c0                	test   %eax,%eax
c0100619:	75 0a                	jne    c0100625 <debuginfo_eip+0xd7>
        return -1;
c010061b:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100620:	e9 43 02 00 00       	jmp    c0100868 <debuginfo_eip+0x31a>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c0100625:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100628:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010062b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010062e:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100631:	8b 45 08             	mov    0x8(%ebp),%eax
c0100634:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100638:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c010063f:	00 
c0100640:	8d 45 d8             	lea    -0x28(%ebp),%eax
c0100643:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100647:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010064a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010064e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100651:	89 04 24             	mov    %eax,(%esp)
c0100654:	e8 af fd ff ff       	call   c0100408 <stab_binsearch>

    if (lfun <= rfun) {
c0100659:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010065c:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010065f:	39 c2                	cmp    %eax,%edx
c0100661:	7f 72                	jg     c01006d5 <debuginfo_eip+0x187>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c0100663:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100666:	89 c2                	mov    %eax,%edx
c0100668:	89 d0                	mov    %edx,%eax
c010066a:	01 c0                	add    %eax,%eax
c010066c:	01 d0                	add    %edx,%eax
c010066e:	c1 e0 02             	shl    $0x2,%eax
c0100671:	03 45 f4             	add    -0xc(%ebp),%eax
c0100674:	8b 10                	mov    (%eax),%edx
c0100676:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100679:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010067c:	89 cb                	mov    %ecx,%ebx
c010067e:	29 c3                	sub    %eax,%ebx
c0100680:	89 d8                	mov    %ebx,%eax
c0100682:	39 c2                	cmp    %eax,%edx
c0100684:	73 1e                	jae    c01006a4 <debuginfo_eip+0x156>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c0100686:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100689:	89 c2                	mov    %eax,%edx
c010068b:	89 d0                	mov    %edx,%eax
c010068d:	01 c0                	add    %eax,%eax
c010068f:	01 d0                	add    %edx,%eax
c0100691:	c1 e0 02             	shl    $0x2,%eax
c0100694:	03 45 f4             	add    -0xc(%ebp),%eax
c0100697:	8b 00                	mov    (%eax),%eax
c0100699:	89 c2                	mov    %eax,%edx
c010069b:	03 55 ec             	add    -0x14(%ebp),%edx
c010069e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006a1:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c01006a4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006a7:	89 c2                	mov    %eax,%edx
c01006a9:	89 d0                	mov    %edx,%eax
c01006ab:	01 c0                	add    %eax,%eax
c01006ad:	01 d0                	add    %edx,%eax
c01006af:	c1 e0 02             	shl    $0x2,%eax
c01006b2:	03 45 f4             	add    -0xc(%ebp),%eax
c01006b5:	8b 50 08             	mov    0x8(%eax),%edx
c01006b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006bb:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006c1:	8b 40 10             	mov    0x10(%eax),%eax
c01006c4:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006ca:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006cd:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006d0:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006d3:	eb 15                	jmp    c01006ea <debuginfo_eip+0x19c>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006d5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d8:	8b 55 08             	mov    0x8(%ebp),%edx
c01006db:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006de:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006e1:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006ea:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006ed:	8b 40 08             	mov    0x8(%eax),%eax
c01006f0:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006f7:	00 
c01006f8:	89 04 24             	mov    %eax,(%esp)
c01006fb:	e8 4b 96 00 00       	call   c0109d4b <strfind>
c0100700:	89 c2                	mov    %eax,%edx
c0100702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100705:	8b 40 08             	mov    0x8(%eax),%eax
c0100708:	29 c2                	sub    %eax,%edx
c010070a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010070d:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100710:	8b 45 08             	mov    0x8(%ebp),%eax
c0100713:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100717:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c010071e:	00 
c010071f:	8d 45 d0             	lea    -0x30(%ebp),%eax
c0100722:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100726:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100729:	89 44 24 04          	mov    %eax,0x4(%esp)
c010072d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100730:	89 04 24             	mov    %eax,(%esp)
c0100733:	e8 d0 fc ff ff       	call   c0100408 <stab_binsearch>
    if (lline <= rline) {
c0100738:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010073b:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073e:	39 c2                	cmp    %eax,%edx
c0100740:	7f 20                	jg     c0100762 <debuginfo_eip+0x214>
        info->eip_line = stabs[rline].n_desc;
c0100742:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100745:	89 c2                	mov    %eax,%edx
c0100747:	89 d0                	mov    %edx,%eax
c0100749:	01 c0                	add    %eax,%eax
c010074b:	01 d0                	add    %edx,%eax
c010074d:	c1 e0 02             	shl    $0x2,%eax
c0100750:	03 45 f4             	add    -0xc(%ebp),%eax
c0100753:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c0100757:	0f b7 d0             	movzwl %ax,%edx
c010075a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010075d:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100760:	eb 13                	jmp    c0100775 <debuginfo_eip+0x227>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c0100762:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100767:	e9 fc 00 00 00       	jmp    c0100868 <debuginfo_eip+0x31a>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c010076c:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010076f:	83 e8 01             	sub    $0x1,%eax
c0100772:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100775:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100778:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010077b:	39 c2                	cmp    %eax,%edx
c010077d:	7c 4a                	jl     c01007c9 <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
c010077f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100782:	89 c2                	mov    %eax,%edx
c0100784:	89 d0                	mov    %edx,%eax
c0100786:	01 c0                	add    %eax,%eax
c0100788:	01 d0                	add    %edx,%eax
c010078a:	c1 e0 02             	shl    $0x2,%eax
c010078d:	03 45 f4             	add    -0xc(%ebp),%eax
c0100790:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100794:	3c 84                	cmp    $0x84,%al
c0100796:	74 31                	je     c01007c9 <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100798:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010079b:	89 c2                	mov    %eax,%edx
c010079d:	89 d0                	mov    %edx,%eax
c010079f:	01 c0                	add    %eax,%eax
c01007a1:	01 d0                	add    %edx,%eax
c01007a3:	c1 e0 02             	shl    $0x2,%eax
c01007a6:	03 45 f4             	add    -0xc(%ebp),%eax
c01007a9:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007ad:	3c 64                	cmp    $0x64,%al
c01007af:	75 bb                	jne    c010076c <debuginfo_eip+0x21e>
c01007b1:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007b4:	89 c2                	mov    %eax,%edx
c01007b6:	89 d0                	mov    %edx,%eax
c01007b8:	01 c0                	add    %eax,%eax
c01007ba:	01 d0                	add    %edx,%eax
c01007bc:	c1 e0 02             	shl    $0x2,%eax
c01007bf:	03 45 f4             	add    -0xc(%ebp),%eax
c01007c2:	8b 40 08             	mov    0x8(%eax),%eax
c01007c5:	85 c0                	test   %eax,%eax
c01007c7:	74 a3                	je     c010076c <debuginfo_eip+0x21e>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c9:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007cc:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007cf:	39 c2                	cmp    %eax,%edx
c01007d1:	7c 40                	jl     c0100813 <debuginfo_eip+0x2c5>
c01007d3:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007d6:	89 c2                	mov    %eax,%edx
c01007d8:	89 d0                	mov    %edx,%eax
c01007da:	01 c0                	add    %eax,%eax
c01007dc:	01 d0                	add    %edx,%eax
c01007de:	c1 e0 02             	shl    $0x2,%eax
c01007e1:	03 45 f4             	add    -0xc(%ebp),%eax
c01007e4:	8b 10                	mov    (%eax),%edx
c01007e6:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007ec:	89 cb                	mov    %ecx,%ebx
c01007ee:	29 c3                	sub    %eax,%ebx
c01007f0:	89 d8                	mov    %ebx,%eax
c01007f2:	39 c2                	cmp    %eax,%edx
c01007f4:	73 1d                	jae    c0100813 <debuginfo_eip+0x2c5>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007f6:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f9:	89 c2                	mov    %eax,%edx
c01007fb:	89 d0                	mov    %edx,%eax
c01007fd:	01 c0                	add    %eax,%eax
c01007ff:	01 d0                	add    %edx,%eax
c0100801:	c1 e0 02             	shl    $0x2,%eax
c0100804:	03 45 f4             	add    -0xc(%ebp),%eax
c0100807:	8b 00                	mov    (%eax),%eax
c0100809:	89 c2                	mov    %eax,%edx
c010080b:	03 55 ec             	add    -0x14(%ebp),%edx
c010080e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100811:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c0100813:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100816:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100819:	39 c2                	cmp    %eax,%edx
c010081b:	7d 46                	jge    c0100863 <debuginfo_eip+0x315>
        for (lline = lfun + 1;
c010081d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100820:	83 c0 01             	add    $0x1,%eax
c0100823:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c0100826:	eb 18                	jmp    c0100840 <debuginfo_eip+0x2f2>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100828:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082b:	8b 40 14             	mov    0x14(%eax),%eax
c010082e:	8d 50 01             	lea    0x1(%eax),%edx
c0100831:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100834:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c0100837:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010083a:	83 c0 01             	add    $0x1,%eax
c010083d:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100840:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100843:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c0100846:	39 c2                	cmp    %eax,%edx
c0100848:	7d 19                	jge    c0100863 <debuginfo_eip+0x315>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c010084a:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010084d:	89 c2                	mov    %eax,%edx
c010084f:	89 d0                	mov    %edx,%eax
c0100851:	01 c0                	add    %eax,%eax
c0100853:	01 d0                	add    %edx,%eax
c0100855:	c1 e0 02             	shl    $0x2,%eax
c0100858:	03 45 f4             	add    -0xc(%ebp),%eax
c010085b:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010085f:	3c a0                	cmp    $0xa0,%al
c0100861:	74 c5                	je     c0100828 <debuginfo_eip+0x2da>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c0100863:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100868:	83 c4 54             	add    $0x54,%esp
c010086b:	5b                   	pop    %ebx
c010086c:	5d                   	pop    %ebp
c010086d:	c3                   	ret    

c010086e <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c010086e:	55                   	push   %ebp
c010086f:	89 e5                	mov    %esp,%ebp
c0100871:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c0100874:	c7 04 24 56 a1 10 c0 	movl   $0xc010a156,(%esp)
c010087b:	e8 df fa ff ff       	call   c010035f <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100880:	c7 44 24 04 2c 00 10 	movl   $0xc010002c,0x4(%esp)
c0100887:	c0 
c0100888:	c7 04 24 6f a1 10 c0 	movl   $0xc010a16f,(%esp)
c010088f:	e8 cb fa ff ff       	call   c010035f <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c0100894:	c7 44 24 04 8b a0 10 	movl   $0xc010a08b,0x4(%esp)
c010089b:	c0 
c010089c:	c7 04 24 87 a1 10 c0 	movl   $0xc010a187,(%esp)
c01008a3:	e8 b7 fa ff ff       	call   c010035f <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008a8:	c7 44 24 04 90 5a 12 	movl   $0xc0125a90,0x4(%esp)
c01008af:	c0 
c01008b0:	c7 04 24 9f a1 10 c0 	movl   $0xc010a19f,(%esp)
c01008b7:	e8 a3 fa ff ff       	call   c010035f <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008bc:	c7 44 24 04 18 8c 12 	movl   $0xc0128c18,0x4(%esp)
c01008c3:	c0 
c01008c4:	c7 04 24 b7 a1 10 c0 	movl   $0xc010a1b7,(%esp)
c01008cb:	e8 8f fa ff ff       	call   c010035f <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008d0:	b8 18 8c 12 c0       	mov    $0xc0128c18,%eax
c01008d5:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008db:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c01008e0:	89 d1                	mov    %edx,%ecx
c01008e2:	29 c1                	sub    %eax,%ecx
c01008e4:	89 c8                	mov    %ecx,%eax
c01008e6:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008ec:	85 c0                	test   %eax,%eax
c01008ee:	0f 48 c2             	cmovs  %edx,%eax
c01008f1:	c1 f8 0a             	sar    $0xa,%eax
c01008f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f8:	c7 04 24 d0 a1 10 c0 	movl   $0xc010a1d0,(%esp)
c01008ff:	e8 5b fa ff ff       	call   c010035f <cprintf>
}
c0100904:	c9                   	leave  
c0100905:	c3                   	ret    

c0100906 <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c0100906:	55                   	push   %ebp
c0100907:	89 e5                	mov    %esp,%ebp
c0100909:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c010090f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100912:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100916:	8b 45 08             	mov    0x8(%ebp),%eax
c0100919:	89 04 24             	mov    %eax,(%esp)
c010091c:	e8 2d fc ff ff       	call   c010054e <debuginfo_eip>
c0100921:	85 c0                	test   %eax,%eax
c0100923:	74 15                	je     c010093a <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c0100925:	8b 45 08             	mov    0x8(%ebp),%eax
c0100928:	89 44 24 04          	mov    %eax,0x4(%esp)
c010092c:	c7 04 24 fa a1 10 c0 	movl   $0xc010a1fa,(%esp)
c0100933:	e8 27 fa ff ff       	call   c010035f <cprintf>
c0100938:	eb 69                	jmp    c01009a3 <print_debuginfo+0x9d>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c010093a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100941:	eb 1a                	jmp    c010095d <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
c0100943:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0100946:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100949:	01 d0                	add    %edx,%eax
c010094b:	0f b6 10             	movzbl (%eax),%edx
c010094e:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c0100954:	03 45 f4             	add    -0xc(%ebp),%eax
c0100957:	88 10                	mov    %dl,(%eax)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100959:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010095d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100960:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0100963:	7f de                	jg     c0100943 <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c0100965:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c010096b:	03 45 f4             	add    -0xc(%ebp),%eax
c010096e:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100971:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100974:	8b 55 08             	mov    0x8(%ebp),%edx
c0100977:	89 d1                	mov    %edx,%ecx
c0100979:	29 c1                	sub    %eax,%ecx
c010097b:	8b 55 e0             	mov    -0x20(%ebp),%edx
c010097e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100981:	89 4c 24 10          	mov    %ecx,0x10(%esp)
                fnname, eip - info.eip_fn_addr);
c0100985:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c010098b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010098f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100993:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100997:	c7 04 24 16 a2 10 c0 	movl   $0xc010a216,(%esp)
c010099e:	e8 bc f9 ff ff       	call   c010035f <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c01009a3:	c9                   	leave  
c01009a4:	c3                   	ret    

c01009a5 <read_eip>:

static __noinline uint32_t
read_eip(void) {
c01009a5:	55                   	push   %ebp
c01009a6:	89 e5                	mov    %esp,%ebp
c01009a8:	53                   	push   %ebx
c01009a9:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009ac:	8b 5d 04             	mov    0x4(%ebp),%ebx
c01009af:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return eip;
c01009b2:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01009b5:	83 c4 10             	add    $0x10,%esp
c01009b8:	5b                   	pop    %ebx
c01009b9:	5d                   	pop    %ebp
c01009ba:	c3                   	ret    

c01009bb <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009bb:	55                   	push   %ebp
c01009bc:	89 e5                	mov    %esp,%ebp
c01009be:	53                   	push   %ebx
c01009bf:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009c2:	89 eb                	mov    %ebp,%ebx
c01009c4:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    return ebp;
c01009c7:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();
c01009ca:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009cd:	e8 d3 ff ff ff       	call   c01009a5 <read_eip>
c01009d2:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009d5:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009dc:	e9 82 00 00 00       	jmp    c0100a63 <print_stackframe+0xa8>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009e1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009e4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009ef:	c7 04 24 28 a2 10 c0 	movl   $0xc010a228,(%esp)
c01009f6:	e8 64 f9 ff ff       	call   c010035f <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c01009fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009fe:	83 c0 08             	add    $0x8,%eax
c0100a01:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c0100a04:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a0b:	eb 1f                	jmp    c0100a2c <print_stackframe+0x71>
            cprintf("0x%08x ", args[j]);
c0100a0d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a10:	c1 e0 02             	shl    $0x2,%eax
c0100a13:	03 45 e4             	add    -0x1c(%ebp),%eax
c0100a16:	8b 00                	mov    (%eax),%eax
c0100a18:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a1c:	c7 04 24 44 a2 10 c0 	movl   $0xc010a244,(%esp)
c0100a23:	e8 37 f9 ff ff       	call   c010035f <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a28:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a2c:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a30:	7e db                	jle    c0100a0d <print_stackframe+0x52>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a32:	c7 04 24 4c a2 10 c0 	movl   $0xc010a24c,(%esp)
c0100a39:	e8 21 f9 ff ff       	call   c010035f <cprintf>
        print_debuginfo(eip - 1);
c0100a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a41:	83 e8 01             	sub    $0x1,%eax
c0100a44:	89 04 24             	mov    %eax,(%esp)
c0100a47:	e8 ba fe ff ff       	call   c0100906 <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a4c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a4f:	83 c0 04             	add    $0x4,%eax
c0100a52:	8b 00                	mov    (%eax),%eax
c0100a54:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a5a:	8b 00                	mov    (%eax),%eax
c0100a5c:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
    uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a5f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a63:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a67:	74 0a                	je     c0100a73 <print_stackframe+0xb8>
c0100a69:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a6d:	0f 8e 6e ff ff ff    	jle    c01009e1 <print_stackframe+0x26>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a73:	83 c4 34             	add    $0x34,%esp
c0100a76:	5b                   	pop    %ebx
c0100a77:	5d                   	pop    %ebp
c0100a78:	c3                   	ret    
c0100a79:	00 00                	add    %al,(%eax)
	...

c0100a7c <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a7c:	55                   	push   %ebp
c0100a7d:	89 e5                	mov    %esp,%ebp
c0100a7f:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a82:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a89:	eb 0d                	jmp    c0100a98 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
c0100a8b:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a8c:	eb 0a                	jmp    c0100a98 <parse+0x1c>
            *buf ++ = '\0';
c0100a8e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a91:	c6 00 00             	movb   $0x0,(%eax)
c0100a94:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a98:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9b:	0f b6 00             	movzbl (%eax),%eax
c0100a9e:	84 c0                	test   %al,%al
c0100aa0:	74 1d                	je     c0100abf <parse+0x43>
c0100aa2:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aa5:	0f b6 00             	movzbl (%eax),%eax
c0100aa8:	0f be c0             	movsbl %al,%eax
c0100aab:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aaf:	c7 04 24 d0 a2 10 c0 	movl   $0xc010a2d0,(%esp)
c0100ab6:	e8 5d 92 00 00       	call   c0109d18 <strchr>
c0100abb:	85 c0                	test   %eax,%eax
c0100abd:	75 cf                	jne    c0100a8e <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100abf:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ac2:	0f b6 00             	movzbl (%eax),%eax
c0100ac5:	84 c0                	test   %al,%al
c0100ac7:	74 5e                	je     c0100b27 <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac9:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100acd:	75 14                	jne    c0100ae3 <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100acf:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ad6:	00 
c0100ad7:	c7 04 24 d5 a2 10 c0 	movl   $0xc010a2d5,(%esp)
c0100ade:	e8 7c f8 ff ff       	call   c010035f <cprintf>
        }
        argv[argc ++] = buf;
c0100ae3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ae6:	c1 e0 02             	shl    $0x2,%eax
c0100ae9:	03 45 0c             	add    0xc(%ebp),%eax
c0100aec:	8b 55 08             	mov    0x8(%ebp),%edx
c0100aef:	89 10                	mov    %edx,(%eax)
c0100af1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100af5:	eb 04                	jmp    c0100afb <parse+0x7f>
            buf ++;
c0100af7:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100afb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100afe:	0f b6 00             	movzbl (%eax),%eax
c0100b01:	84 c0                	test   %al,%al
c0100b03:	74 86                	je     c0100a8b <parse+0xf>
c0100b05:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b08:	0f b6 00             	movzbl (%eax),%eax
c0100b0b:	0f be c0             	movsbl %al,%eax
c0100b0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b12:	c7 04 24 d0 a2 10 c0 	movl   $0xc010a2d0,(%esp)
c0100b19:	e8 fa 91 00 00       	call   c0109d18 <strchr>
c0100b1e:	85 c0                	test   %eax,%eax
c0100b20:	74 d5                	je     c0100af7 <parse+0x7b>
            buf ++;
        }
    }
c0100b22:	e9 64 ff ff ff       	jmp    c0100a8b <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100b27:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b28:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b2b:	c9                   	leave  
c0100b2c:	c3                   	ret    

c0100b2d <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b2d:	55                   	push   %ebp
c0100b2e:	89 e5                	mov    %esp,%ebp
c0100b30:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b33:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b36:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b3d:	89 04 24             	mov    %eax,(%esp)
c0100b40:	e8 37 ff ff ff       	call   c0100a7c <parse>
c0100b45:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b48:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b4c:	75 0a                	jne    c0100b58 <runcmd+0x2b>
        return 0;
c0100b4e:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b53:	e9 85 00 00 00       	jmp    c0100bdd <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b58:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b5f:	eb 5c                	jmp    c0100bbd <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b61:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b64:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b67:	89 d0                	mov    %edx,%eax
c0100b69:	01 c0                	add    %eax,%eax
c0100b6b:	01 d0                	add    %edx,%eax
c0100b6d:	c1 e0 02             	shl    $0x2,%eax
c0100b70:	05 20 50 12 c0       	add    $0xc0125020,%eax
c0100b75:	8b 00                	mov    (%eax),%eax
c0100b77:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b7b:	89 04 24             	mov    %eax,(%esp)
c0100b7e:	e8 f0 90 00 00       	call   c0109c73 <strcmp>
c0100b83:	85 c0                	test   %eax,%eax
c0100b85:	75 32                	jne    c0100bb9 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b87:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b8a:	89 d0                	mov    %edx,%eax
c0100b8c:	01 c0                	add    %eax,%eax
c0100b8e:	01 d0                	add    %edx,%eax
c0100b90:	c1 e0 02             	shl    $0x2,%eax
c0100b93:	05 20 50 12 c0       	add    $0xc0125020,%eax
c0100b98:	8b 50 08             	mov    0x8(%eax),%edx
c0100b9b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b9e:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0100ba1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ba4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ba8:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100bab:	83 c0 04             	add    $0x4,%eax
c0100bae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bb2:	89 0c 24             	mov    %ecx,(%esp)
c0100bb5:	ff d2                	call   *%edx
c0100bb7:	eb 24                	jmp    c0100bdd <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bb9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bbd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bc0:	83 f8 02             	cmp    $0x2,%eax
c0100bc3:	76 9c                	jbe    c0100b61 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bc5:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bc8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bcc:	c7 04 24 f3 a2 10 c0 	movl   $0xc010a2f3,(%esp)
c0100bd3:	e8 87 f7 ff ff       	call   c010035f <cprintf>
    return 0;
c0100bd8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bdd:	c9                   	leave  
c0100bde:	c3                   	ret    

c0100bdf <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bdf:	55                   	push   %ebp
c0100be0:	89 e5                	mov    %esp,%ebp
c0100be2:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100be5:	c7 04 24 0c a3 10 c0 	movl   $0xc010a30c,(%esp)
c0100bec:	e8 6e f7 ff ff       	call   c010035f <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100bf1:	c7 04 24 34 a3 10 c0 	movl   $0xc010a334,(%esp)
c0100bf8:	e8 62 f7 ff ff       	call   c010035f <cprintf>

    if (tf != NULL) {
c0100bfd:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100c01:	74 0e                	je     c0100c11 <kmonitor+0x32>
        print_trapframe(tf);
c0100c03:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c06:	89 04 24             	mov    %eax,(%esp)
c0100c09:	e8 a8 17 00 00       	call   c01023b6 <print_trapframe>
c0100c0e:	eb 01                	jmp    c0100c11 <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
c0100c10:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c11:	c7 04 24 59 a3 10 c0 	movl   $0xc010a359,(%esp)
c0100c18:	e8 33 f6 ff ff       	call   c0100250 <readline>
c0100c1d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c20:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c24:	74 ea                	je     c0100c10 <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
c0100c26:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c29:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c30:	89 04 24             	mov    %eax,(%esp)
c0100c33:	e8 f5 fe ff ff       	call   c0100b2d <runcmd>
c0100c38:	85 c0                	test   %eax,%eax
c0100c3a:	79 d4                	jns    c0100c10 <kmonitor+0x31>
                break;
c0100c3c:	90                   	nop
            }
        }
    }
}
c0100c3d:	c9                   	leave  
c0100c3e:	c3                   	ret    

c0100c3f <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c3f:	55                   	push   %ebp
c0100c40:	89 e5                	mov    %esp,%ebp
c0100c42:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c45:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c4c:	eb 3f                	jmp    c0100c8d <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c4e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c51:	89 d0                	mov    %edx,%eax
c0100c53:	01 c0                	add    %eax,%eax
c0100c55:	01 d0                	add    %edx,%eax
c0100c57:	c1 e0 02             	shl    $0x2,%eax
c0100c5a:	05 20 50 12 c0       	add    $0xc0125020,%eax
c0100c5f:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c62:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c65:	89 d0                	mov    %edx,%eax
c0100c67:	01 c0                	add    %eax,%eax
c0100c69:	01 d0                	add    %edx,%eax
c0100c6b:	c1 e0 02             	shl    $0x2,%eax
c0100c6e:	05 20 50 12 c0       	add    $0xc0125020,%eax
c0100c73:	8b 00                	mov    (%eax),%eax
c0100c75:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c7d:	c7 04 24 5d a3 10 c0 	movl   $0xc010a35d,(%esp)
c0100c84:	e8 d6 f6 ff ff       	call   c010035f <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c89:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c8d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c90:	83 f8 02             	cmp    $0x2,%eax
c0100c93:	76 b9                	jbe    c0100c4e <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c95:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c9a:	c9                   	leave  
c0100c9b:	c3                   	ret    

c0100c9c <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c9c:	55                   	push   %ebp
c0100c9d:	89 e5                	mov    %esp,%ebp
c0100c9f:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100ca2:	e8 c7 fb ff ff       	call   c010086e <print_kerninfo>
    return 0;
c0100ca7:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cac:	c9                   	leave  
c0100cad:	c3                   	ret    

c0100cae <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100cae:	55                   	push   %ebp
c0100caf:	89 e5                	mov    %esp,%ebp
c0100cb1:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cb4:	e8 02 fd ff ff       	call   c01009bb <print_stackframe>
    return 0;
c0100cb9:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cbe:	c9                   	leave  
c0100cbf:	c3                   	ret    

c0100cc0 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cc0:	55                   	push   %ebp
c0100cc1:	89 e5                	mov    %esp,%ebp
c0100cc3:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cc6:	a1 c0 5e 12 c0       	mov    0xc0125ec0,%eax
c0100ccb:	85 c0                	test   %eax,%eax
c0100ccd:	75 4c                	jne    c0100d1b <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
c0100ccf:	c7 05 c0 5e 12 c0 01 	movl   $0x1,0xc0125ec0
c0100cd6:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cd9:	8d 55 14             	lea    0x14(%ebp),%edx
c0100cdc:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100cdf:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100ce1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100ce4:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ce8:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ceb:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cef:	c7 04 24 66 a3 10 c0 	movl   $0xc010a366,(%esp)
c0100cf6:	e8 64 f6 ff ff       	call   c010035f <cprintf>
    vcprintf(fmt, ap);
c0100cfb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cfe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d02:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d05:	89 04 24             	mov    %eax,(%esp)
c0100d08:	e8 1f f6 ff ff       	call   c010032c <vcprintf>
    cprintf("\n");
c0100d0d:	c7 04 24 82 a3 10 c0 	movl   $0xc010a382,(%esp)
c0100d14:	e8 46 f6 ff ff       	call   c010035f <cprintf>
c0100d19:	eb 01                	jmp    c0100d1c <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100d1b:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100d1c:	e8 cd 12 00 00       	call   c0101fee <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d21:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d28:	e8 b2 fe ff ff       	call   c0100bdf <kmonitor>
    }
c0100d2d:	eb f2                	jmp    c0100d21 <__panic+0x61>

c0100d2f <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d2f:	55                   	push   %ebp
c0100d30:	89 e5                	mov    %esp,%ebp
c0100d32:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d35:	8d 55 14             	lea    0x14(%ebp),%edx
c0100d38:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100d3b:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d40:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d44:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d47:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d4b:	c7 04 24 84 a3 10 c0 	movl   $0xc010a384,(%esp)
c0100d52:	e8 08 f6 ff ff       	call   c010035f <cprintf>
    vcprintf(fmt, ap);
c0100d57:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d5a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d5e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d61:	89 04 24             	mov    %eax,(%esp)
c0100d64:	e8 c3 f5 ff ff       	call   c010032c <vcprintf>
    cprintf("\n");
c0100d69:	c7 04 24 82 a3 10 c0 	movl   $0xc010a382,(%esp)
c0100d70:	e8 ea f5 ff ff       	call   c010035f <cprintf>
    va_end(ap);
}
c0100d75:	c9                   	leave  
c0100d76:	c3                   	ret    

c0100d77 <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d77:	55                   	push   %ebp
c0100d78:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d7a:	a1 c0 5e 12 c0       	mov    0xc0125ec0,%eax
}
c0100d7f:	5d                   	pop    %ebp
c0100d80:	c3                   	ret    
c0100d81:	00 00                	add    %al,(%eax)
	...

c0100d84 <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d84:	55                   	push   %ebp
c0100d85:	89 e5                	mov    %esp,%ebp
c0100d87:	83 ec 28             	sub    $0x28,%esp
c0100d8a:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d90:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d94:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d98:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d9c:	ee                   	out    %al,(%dx)
c0100d9d:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100da3:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100da7:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100dab:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100daf:	ee                   	out    %al,(%dx)
c0100db0:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100db6:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100dba:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100dbe:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dc2:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dc3:	c7 05 14 8b 12 c0 00 	movl   $0x0,0xc0128b14
c0100dca:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dcd:	c7 04 24 a2 a3 10 c0 	movl   $0xc010a3a2,(%esp)
c0100dd4:	e8 86 f5 ff ff       	call   c010035f <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd9:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100de0:	e8 67 12 00 00       	call   c010204c <pic_enable>
}
c0100de5:	c9                   	leave  
c0100de6:	c3                   	ret    
	...

c0100de8 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de8:	55                   	push   %ebp
c0100de9:	89 e5                	mov    %esp,%ebp
c0100deb:	53                   	push   %ebx
c0100dec:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100def:	9c                   	pushf  
c0100df0:	5b                   	pop    %ebx
c0100df1:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0100df4:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100df7:	25 00 02 00 00       	and    $0x200,%eax
c0100dfc:	85 c0                	test   %eax,%eax
c0100dfe:	74 0c                	je     c0100e0c <__intr_save+0x24>
        intr_disable();
c0100e00:	e8 e9 11 00 00       	call   c0101fee <intr_disable>
        return 1;
c0100e05:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e0a:	eb 05                	jmp    c0100e11 <__intr_save+0x29>
    }
    return 0;
c0100e0c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e11:	83 c4 14             	add    $0x14,%esp
c0100e14:	5b                   	pop    %ebx
c0100e15:	5d                   	pop    %ebp
c0100e16:	c3                   	ret    

c0100e17 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e17:	55                   	push   %ebp
c0100e18:	89 e5                	mov    %esp,%ebp
c0100e1a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e1d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e21:	74 05                	je     c0100e28 <__intr_restore+0x11>
        intr_enable();
c0100e23:	e8 c0 11 00 00       	call   c0101fe8 <intr_enable>
    }
}
c0100e28:	c9                   	leave  
c0100e29:	c3                   	ret    

c0100e2a <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e2a:	55                   	push   %ebp
c0100e2b:	89 e5                	mov    %esp,%ebp
c0100e2d:	53                   	push   %ebx
c0100e2e:	83 ec 14             	sub    $0x14,%esp
c0100e31:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e37:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e3b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e3f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e43:	ec                   	in     (%dx),%al
c0100e44:	89 c3                	mov    %eax,%ebx
c0100e46:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
c0100e49:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e4f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e53:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e57:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e5b:	ec                   	in     (%dx),%al
c0100e5c:	89 c3                	mov    %eax,%ebx
c0100e5e:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0100e61:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e67:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e6b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e6f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e73:	ec                   	in     (%dx),%al
c0100e74:	89 c3                	mov    %eax,%ebx
c0100e76:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0100e79:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e7f:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e83:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e87:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e8b:	ec                   	in     (%dx),%al
c0100e8c:	89 c3                	mov    %eax,%ebx
c0100e8e:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e91:	83 c4 14             	add    $0x14,%esp
c0100e94:	5b                   	pop    %ebx
c0100e95:	5d                   	pop    %ebp
c0100e96:	c3                   	ret    

c0100e97 <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e97:	55                   	push   %ebp
c0100e98:	89 e5                	mov    %esp,%ebp
c0100e9a:	53                   	push   %ebx
c0100e9b:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e9e:	c7 45 f8 00 80 0b c0 	movl   $0xc00b8000,-0x8(%ebp)
    uint16_t was = *cp;
c0100ea5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100ea8:	0f b7 00             	movzwl (%eax),%eax
c0100eab:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100eb2:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eb7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100eba:	0f b7 00             	movzwl (%eax),%eax
c0100ebd:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100ec1:	74 12                	je     c0100ed5 <cga_init+0x3e>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ec3:	c7 45 f8 00 00 0b c0 	movl   $0xc00b0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
c0100eca:	66 c7 05 e6 5e 12 c0 	movw   $0x3b4,0xc0125ee6
c0100ed1:	b4 03 
c0100ed3:	eb 13                	jmp    c0100ee8 <cga_init+0x51>
    } else {
        *cp = was;
c0100ed5:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100ed8:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100edc:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100edf:	66 c7 05 e6 5e 12 c0 	movw   $0x3d4,0xc0125ee6
c0100ee6:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee8:	0f b7 05 e6 5e 12 c0 	movzwl 0xc0125ee6,%eax
c0100eef:	0f b7 c0             	movzwl %ax,%eax
c0100ef2:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100ef6:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100efa:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100efe:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100f02:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100f03:	0f b7 05 e6 5e 12 c0 	movzwl 0xc0125ee6,%eax
c0100f0a:	83 c0 01             	add    $0x1,%eax
c0100f0d:	0f b7 c0             	movzwl %ax,%eax
c0100f10:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f14:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f18:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100f1c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f20:	ec                   	in     (%dx),%al
c0100f21:	89 c3                	mov    %eax,%ebx
c0100f23:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
c0100f26:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f2a:	0f b6 c0             	movzbl %al,%eax
c0100f2d:	c1 e0 08             	shl    $0x8,%eax
c0100f30:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
c0100f33:	0f b7 05 e6 5e 12 c0 	movzwl 0xc0125ee6,%eax
c0100f3a:	0f b7 c0             	movzwl %ax,%eax
c0100f3d:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f41:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f45:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f49:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f4d:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f4e:	0f b7 05 e6 5e 12 c0 	movzwl 0xc0125ee6,%eax
c0100f55:	83 c0 01             	add    $0x1,%eax
c0100f58:	0f b7 c0             	movzwl %ax,%eax
c0100f5b:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f5f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f63:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100f67:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f6b:	ec                   	in     (%dx),%al
c0100f6c:	89 c3                	mov    %eax,%ebx
c0100f6e:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
c0100f71:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f75:	0f b6 c0             	movzbl %al,%eax
c0100f78:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f7b:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100f7e:	a3 e0 5e 12 c0       	mov    %eax,0xc0125ee0
    crt_pos = pos;
c0100f83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100f86:	66 a3 e4 5e 12 c0    	mov    %ax,0xc0125ee4
}
c0100f8c:	83 c4 24             	add    $0x24,%esp
c0100f8f:	5b                   	pop    %ebx
c0100f90:	5d                   	pop    %ebp
c0100f91:	c3                   	ret    

c0100f92 <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f92:	55                   	push   %ebp
c0100f93:	89 e5                	mov    %esp,%ebp
c0100f95:	53                   	push   %ebx
c0100f96:	83 ec 54             	sub    $0x54,%esp
c0100f99:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f9f:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100fa3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100fa7:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fab:	ee                   	out    %al,(%dx)
c0100fac:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100fb2:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100fb6:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fba:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fbe:	ee                   	out    %al,(%dx)
c0100fbf:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fc5:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fc9:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fcd:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fd1:	ee                   	out    %al,(%dx)
c0100fd2:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fd8:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fdc:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fe0:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fe4:	ee                   	out    %al,(%dx)
c0100fe5:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100feb:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fef:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100ff3:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100ff7:	ee                   	out    %al,(%dx)
c0100ff8:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100ffe:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0101002:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101006:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c010100a:	ee                   	out    %al,(%dx)
c010100b:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101011:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c0101015:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101019:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010101d:	ee                   	out    %al,(%dx)
c010101e:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101024:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101028:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c010102c:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101030:	ec                   	in     (%dx),%al
c0101031:	89 c3                	mov    %eax,%ebx
c0101033:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
c0101036:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c010103a:	3c ff                	cmp    $0xff,%al
c010103c:	0f 95 c0             	setne  %al
c010103f:	0f b6 c0             	movzbl %al,%eax
c0101042:	a3 e8 5e 12 c0       	mov    %eax,0xc0125ee8
c0101047:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010104d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101051:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101055:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101059:	ec                   	in     (%dx),%al
c010105a:	89 c3                	mov    %eax,%ebx
c010105c:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
c010105f:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101065:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101069:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c010106d:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101071:	ec                   	in     (%dx),%al
c0101072:	89 c3                	mov    %eax,%ebx
c0101074:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c0101077:	a1 e8 5e 12 c0       	mov    0xc0125ee8,%eax
c010107c:	85 c0                	test   %eax,%eax
c010107e:	74 0c                	je     c010108c <serial_init+0xfa>
        pic_enable(IRQ_COM1);
c0101080:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0101087:	e8 c0 0f 00 00       	call   c010204c <pic_enable>
    }
}
c010108c:	83 c4 54             	add    $0x54,%esp
c010108f:	5b                   	pop    %ebx
c0101090:	5d                   	pop    %ebp
c0101091:	c3                   	ret    

c0101092 <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c0101092:	55                   	push   %ebp
c0101093:	89 e5                	mov    %esp,%ebp
c0101095:	53                   	push   %ebx
c0101096:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101099:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c01010a0:	eb 09                	jmp    c01010ab <lpt_putc_sub+0x19>
        delay();
c01010a2:	e8 83 fd ff ff       	call   c0100e2a <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c01010a7:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c01010ab:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
c01010b1:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010b5:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c01010b9:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01010bd:	ec                   	in     (%dx),%al
c01010be:	89 c3                	mov    %eax,%ebx
c01010c0:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c01010c3:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010c7:	84 c0                	test   %al,%al
c01010c9:	78 09                	js     c01010d4 <lpt_putc_sub+0x42>
c01010cb:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c01010d2:	7e ce                	jle    c01010a2 <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
c01010d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01010d7:	0f b6 c0             	movzbl %al,%eax
c01010da:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
c01010e0:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010e3:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010e7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010eb:	ee                   	out    %al,(%dx)
c01010ec:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010f2:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
c01010f6:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010fa:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010fe:	ee                   	out    %al,(%dx)
c01010ff:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
c0101105:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
c0101109:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c010110d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101111:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c0101112:	83 c4 24             	add    $0x24,%esp
c0101115:	5b                   	pop    %ebx
c0101116:	5d                   	pop    %ebp
c0101117:	c3                   	ret    

c0101118 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101118:	55                   	push   %ebp
c0101119:	89 e5                	mov    %esp,%ebp
c010111b:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010111e:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101122:	74 0d                	je     c0101131 <lpt_putc+0x19>
        lpt_putc_sub(c);
c0101124:	8b 45 08             	mov    0x8(%ebp),%eax
c0101127:	89 04 24             	mov    %eax,(%esp)
c010112a:	e8 63 ff ff ff       	call   c0101092 <lpt_putc_sub>
c010112f:	eb 24                	jmp    c0101155 <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c0101131:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101138:	e8 55 ff ff ff       	call   c0101092 <lpt_putc_sub>
        lpt_putc_sub(' ');
c010113d:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0101144:	e8 49 ff ff ff       	call   c0101092 <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101149:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101150:	e8 3d ff ff ff       	call   c0101092 <lpt_putc_sub>
    }
}
c0101155:	c9                   	leave  
c0101156:	c3                   	ret    

c0101157 <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c0101157:	55                   	push   %ebp
c0101158:	89 e5                	mov    %esp,%ebp
c010115a:	53                   	push   %ebx
c010115b:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c010115e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101161:	b0 00                	mov    $0x0,%al
c0101163:	85 c0                	test   %eax,%eax
c0101165:	75 07                	jne    c010116e <cga_putc+0x17>
        c |= 0x0700;
c0101167:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c010116e:	8b 45 08             	mov    0x8(%ebp),%eax
c0101171:	25 ff 00 00 00       	and    $0xff,%eax
c0101176:	83 f8 0a             	cmp    $0xa,%eax
c0101179:	74 4e                	je     c01011c9 <cga_putc+0x72>
c010117b:	83 f8 0d             	cmp    $0xd,%eax
c010117e:	74 59                	je     c01011d9 <cga_putc+0x82>
c0101180:	83 f8 08             	cmp    $0x8,%eax
c0101183:	0f 85 8c 00 00 00    	jne    c0101215 <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
c0101189:	0f b7 05 e4 5e 12 c0 	movzwl 0xc0125ee4,%eax
c0101190:	66 85 c0             	test   %ax,%ax
c0101193:	0f 84 a1 00 00 00    	je     c010123a <cga_putc+0xe3>
            crt_pos --;
c0101199:	0f b7 05 e4 5e 12 c0 	movzwl 0xc0125ee4,%eax
c01011a0:	83 e8 01             	sub    $0x1,%eax
c01011a3:	66 a3 e4 5e 12 c0    	mov    %ax,0xc0125ee4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011a9:	a1 e0 5e 12 c0       	mov    0xc0125ee0,%eax
c01011ae:	0f b7 15 e4 5e 12 c0 	movzwl 0xc0125ee4,%edx
c01011b5:	0f b7 d2             	movzwl %dx,%edx
c01011b8:	01 d2                	add    %edx,%edx
c01011ba:	01 c2                	add    %eax,%edx
c01011bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01011bf:	b0 00                	mov    $0x0,%al
c01011c1:	83 c8 20             	or     $0x20,%eax
c01011c4:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011c7:	eb 71                	jmp    c010123a <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
c01011c9:	0f b7 05 e4 5e 12 c0 	movzwl 0xc0125ee4,%eax
c01011d0:	83 c0 50             	add    $0x50,%eax
c01011d3:	66 a3 e4 5e 12 c0    	mov    %ax,0xc0125ee4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011d9:	0f b7 1d e4 5e 12 c0 	movzwl 0xc0125ee4,%ebx
c01011e0:	0f b7 0d e4 5e 12 c0 	movzwl 0xc0125ee4,%ecx
c01011e7:	0f b7 c1             	movzwl %cx,%eax
c01011ea:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011f0:	c1 e8 10             	shr    $0x10,%eax
c01011f3:	89 c2                	mov    %eax,%edx
c01011f5:	66 c1 ea 06          	shr    $0x6,%dx
c01011f9:	89 d0                	mov    %edx,%eax
c01011fb:	c1 e0 02             	shl    $0x2,%eax
c01011fe:	01 d0                	add    %edx,%eax
c0101200:	c1 e0 04             	shl    $0x4,%eax
c0101203:	89 ca                	mov    %ecx,%edx
c0101205:	66 29 c2             	sub    %ax,%dx
c0101208:	89 d8                	mov    %ebx,%eax
c010120a:	66 29 d0             	sub    %dx,%ax
c010120d:	66 a3 e4 5e 12 c0    	mov    %ax,0xc0125ee4
        break;
c0101213:	eb 26                	jmp    c010123b <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c0101215:	8b 15 e0 5e 12 c0    	mov    0xc0125ee0,%edx
c010121b:	0f b7 05 e4 5e 12 c0 	movzwl 0xc0125ee4,%eax
c0101222:	0f b7 c8             	movzwl %ax,%ecx
c0101225:	01 c9                	add    %ecx,%ecx
c0101227:	01 d1                	add    %edx,%ecx
c0101229:	8b 55 08             	mov    0x8(%ebp),%edx
c010122c:	66 89 11             	mov    %dx,(%ecx)
c010122f:	83 c0 01             	add    $0x1,%eax
c0101232:	66 a3 e4 5e 12 c0    	mov    %ax,0xc0125ee4
        break;
c0101238:	eb 01                	jmp    c010123b <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c010123a:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c010123b:	0f b7 05 e4 5e 12 c0 	movzwl 0xc0125ee4,%eax
c0101242:	66 3d cf 07          	cmp    $0x7cf,%ax
c0101246:	76 5b                	jbe    c01012a3 <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101248:	a1 e0 5e 12 c0       	mov    0xc0125ee0,%eax
c010124d:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c0101253:	a1 e0 5e 12 c0       	mov    0xc0125ee0,%eax
c0101258:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c010125f:	00 
c0101260:	89 54 24 04          	mov    %edx,0x4(%esp)
c0101264:	89 04 24             	mov    %eax,(%esp)
c0101267:	e8 b2 8c 00 00       	call   c0109f1e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010126c:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c0101273:	eb 15                	jmp    c010128a <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
c0101275:	a1 e0 5e 12 c0       	mov    0xc0125ee0,%eax
c010127a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010127d:	01 d2                	add    %edx,%edx
c010127f:	01 d0                	add    %edx,%eax
c0101281:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101286:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010128a:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101291:	7e e2                	jle    c0101275 <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c0101293:	0f b7 05 e4 5e 12 c0 	movzwl 0xc0125ee4,%eax
c010129a:	83 e8 50             	sub    $0x50,%eax
c010129d:	66 a3 e4 5e 12 c0    	mov    %ax,0xc0125ee4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c01012a3:	0f b7 05 e6 5e 12 c0 	movzwl 0xc0125ee6,%eax
c01012aa:	0f b7 c0             	movzwl %ax,%eax
c01012ad:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01012b1:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c01012b5:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012b9:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012bd:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c01012be:	0f b7 05 e4 5e 12 c0 	movzwl 0xc0125ee4,%eax
c01012c5:	66 c1 e8 08          	shr    $0x8,%ax
c01012c9:	0f b6 c0             	movzbl %al,%eax
c01012cc:	0f b7 15 e6 5e 12 c0 	movzwl 0xc0125ee6,%edx
c01012d3:	83 c2 01             	add    $0x1,%edx
c01012d6:	0f b7 d2             	movzwl %dx,%edx
c01012d9:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01012dd:	88 45 ed             	mov    %al,-0x13(%ebp)
c01012e0:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012e4:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012e8:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012e9:	0f b7 05 e6 5e 12 c0 	movzwl 0xc0125ee6,%eax
c01012f0:	0f b7 c0             	movzwl %ax,%eax
c01012f3:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012f7:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012fb:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012ff:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101303:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c0101304:	0f b7 05 e4 5e 12 c0 	movzwl 0xc0125ee4,%eax
c010130b:	0f b6 c0             	movzbl %al,%eax
c010130e:	0f b7 15 e6 5e 12 c0 	movzwl 0xc0125ee6,%edx
c0101315:	83 c2 01             	add    $0x1,%edx
c0101318:	0f b7 d2             	movzwl %dx,%edx
c010131b:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c010131f:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101322:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101326:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010132a:	ee                   	out    %al,(%dx)
}
c010132b:	83 c4 34             	add    $0x34,%esp
c010132e:	5b                   	pop    %ebx
c010132f:	5d                   	pop    %ebp
c0101330:	c3                   	ret    

c0101331 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101331:	55                   	push   %ebp
c0101332:	89 e5                	mov    %esp,%ebp
c0101334:	53                   	push   %ebx
c0101335:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101338:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c010133f:	eb 09                	jmp    c010134a <serial_putc_sub+0x19>
        delay();
c0101341:	e8 e4 fa ff ff       	call   c0100e2a <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101346:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c010134a:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101350:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101354:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101358:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010135c:	ec                   	in     (%dx),%al
c010135d:	89 c3                	mov    %eax,%ebx
c010135f:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0101362:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101366:	0f b6 c0             	movzbl %al,%eax
c0101369:	83 e0 20             	and    $0x20,%eax
c010136c:	85 c0                	test   %eax,%eax
c010136e:	75 09                	jne    c0101379 <serial_putc_sub+0x48>
c0101370:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c0101377:	7e c8                	jle    c0101341 <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101379:	8b 45 08             	mov    0x8(%ebp),%eax
c010137c:	0f b6 c0             	movzbl %al,%eax
c010137f:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c0101385:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101388:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c010138c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101390:	ee                   	out    %al,(%dx)
}
c0101391:	83 c4 14             	add    $0x14,%esp
c0101394:	5b                   	pop    %ebx
c0101395:	5d                   	pop    %ebp
c0101396:	c3                   	ret    

c0101397 <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c0101397:	55                   	push   %ebp
c0101398:	89 e5                	mov    %esp,%ebp
c010139a:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c010139d:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c01013a1:	74 0d                	je     c01013b0 <serial_putc+0x19>
        serial_putc_sub(c);
c01013a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01013a6:	89 04 24             	mov    %eax,(%esp)
c01013a9:	e8 83 ff ff ff       	call   c0101331 <serial_putc_sub>
c01013ae:	eb 24                	jmp    c01013d4 <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c01013b0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013b7:	e8 75 ff ff ff       	call   c0101331 <serial_putc_sub>
        serial_putc_sub(' ');
c01013bc:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013c3:	e8 69 ff ff ff       	call   c0101331 <serial_putc_sub>
        serial_putc_sub('\b');
c01013c8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013cf:	e8 5d ff ff ff       	call   c0101331 <serial_putc_sub>
    }
}
c01013d4:	c9                   	leave  
c01013d5:	c3                   	ret    

c01013d6 <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013d6:	55                   	push   %ebp
c01013d7:	89 e5                	mov    %esp,%ebp
c01013d9:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013dc:	eb 32                	jmp    c0101410 <cons_intr+0x3a>
        if (c != 0) {
c01013de:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013e2:	74 2c                	je     c0101410 <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
c01013e4:	a1 04 61 12 c0       	mov    0xc0126104,%eax
c01013e9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013ec:	88 90 00 5f 12 c0    	mov    %dl,-0x3feda100(%eax)
c01013f2:	83 c0 01             	add    $0x1,%eax
c01013f5:	a3 04 61 12 c0       	mov    %eax,0xc0126104
            if (cons.wpos == CONSBUFSIZE) {
c01013fa:	a1 04 61 12 c0       	mov    0xc0126104,%eax
c01013ff:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101404:	75 0a                	jne    c0101410 <cons_intr+0x3a>
                cons.wpos = 0;
c0101406:	c7 05 04 61 12 c0 00 	movl   $0x0,0xc0126104
c010140d:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101410:	8b 45 08             	mov    0x8(%ebp),%eax
c0101413:	ff d0                	call   *%eax
c0101415:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101418:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c010141c:	75 c0                	jne    c01013de <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c010141e:	c9                   	leave  
c010141f:	c3                   	ret    

c0101420 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101420:	55                   	push   %ebp
c0101421:	89 e5                	mov    %esp,%ebp
c0101423:	53                   	push   %ebx
c0101424:	83 ec 14             	sub    $0x14,%esp
c0101427:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010142d:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101431:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101435:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101439:	ec                   	in     (%dx),%al
c010143a:	89 c3                	mov    %eax,%ebx
c010143c:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c010143f:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c0101443:	0f b6 c0             	movzbl %al,%eax
c0101446:	83 e0 01             	and    $0x1,%eax
c0101449:	85 c0                	test   %eax,%eax
c010144b:	75 07                	jne    c0101454 <serial_proc_data+0x34>
        return -1;
c010144d:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0101452:	eb 32                	jmp    c0101486 <serial_proc_data+0x66>
c0101454:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010145a:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c010145e:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101462:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101466:	ec                   	in     (%dx),%al
c0101467:	89 c3                	mov    %eax,%ebx
c0101469:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c010146c:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101470:	0f b6 c0             	movzbl %al,%eax
c0101473:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
c0101476:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
c010147a:	75 07                	jne    c0101483 <serial_proc_data+0x63>
        c = '\b';
c010147c:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
c0101483:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0101486:	83 c4 14             	add    $0x14,%esp
c0101489:	5b                   	pop    %ebx
c010148a:	5d                   	pop    %ebp
c010148b:	c3                   	ret    

c010148c <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c010148c:	55                   	push   %ebp
c010148d:	89 e5                	mov    %esp,%ebp
c010148f:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c0101492:	a1 e8 5e 12 c0       	mov    0xc0125ee8,%eax
c0101497:	85 c0                	test   %eax,%eax
c0101499:	74 0c                	je     c01014a7 <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c010149b:	c7 04 24 20 14 10 c0 	movl   $0xc0101420,(%esp)
c01014a2:	e8 2f ff ff ff       	call   c01013d6 <cons_intr>
    }
}
c01014a7:	c9                   	leave  
c01014a8:	c3                   	ret    

c01014a9 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014a9:	55                   	push   %ebp
c01014aa:	89 e5                	mov    %esp,%ebp
c01014ac:	53                   	push   %ebx
c01014ad:	83 ec 44             	sub    $0x44,%esp
c01014b0:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014b6:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01014ba:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01014be:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01014c2:	ec                   	in     (%dx),%al
c01014c3:	89 c3                	mov    %eax,%ebx
c01014c5:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
c01014c8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014cc:	0f b6 c0             	movzbl %al,%eax
c01014cf:	83 e0 01             	and    $0x1,%eax
c01014d2:	85 c0                	test   %eax,%eax
c01014d4:	75 0a                	jne    c01014e0 <kbd_proc_data+0x37>
        return -1;
c01014d6:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014db:	e9 61 01 00 00       	jmp    c0101641 <kbd_proc_data+0x198>
c01014e0:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014e6:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01014ea:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01014ee:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01014f2:	ec                   	in     (%dx),%al
c01014f3:	89 c3                	mov    %eax,%ebx
c01014f5:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
c01014f8:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014fc:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014ff:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c0101503:	75 17                	jne    c010151c <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
c0101505:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c010150a:	83 c8 40             	or     $0x40,%eax
c010150d:	a3 08 61 12 c0       	mov    %eax,0xc0126108
        return 0;
c0101512:	b8 00 00 00 00       	mov    $0x0,%eax
c0101517:	e9 25 01 00 00       	jmp    c0101641 <kbd_proc_data+0x198>
    } else if (data & 0x80) {
c010151c:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101520:	84 c0                	test   %al,%al
c0101522:	79 47                	jns    c010156b <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c0101524:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c0101529:	83 e0 40             	and    $0x40,%eax
c010152c:	85 c0                	test   %eax,%eax
c010152e:	75 09                	jne    c0101539 <kbd_proc_data+0x90>
c0101530:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101534:	83 e0 7f             	and    $0x7f,%eax
c0101537:	eb 04                	jmp    c010153d <kbd_proc_data+0x94>
c0101539:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153d:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101540:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101544:	0f b6 80 60 50 12 c0 	movzbl -0x3fedafa0(%eax),%eax
c010154b:	83 c8 40             	or     $0x40,%eax
c010154e:	0f b6 c0             	movzbl %al,%eax
c0101551:	f7 d0                	not    %eax
c0101553:	89 c2                	mov    %eax,%edx
c0101555:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c010155a:	21 d0                	and    %edx,%eax
c010155c:	a3 08 61 12 c0       	mov    %eax,0xc0126108
        return 0;
c0101561:	b8 00 00 00 00       	mov    $0x0,%eax
c0101566:	e9 d6 00 00 00       	jmp    c0101641 <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
c010156b:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c0101570:	83 e0 40             	and    $0x40,%eax
c0101573:	85 c0                	test   %eax,%eax
c0101575:	74 11                	je     c0101588 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c0101577:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c010157b:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c0101580:	83 e0 bf             	and    $0xffffffbf,%eax
c0101583:	a3 08 61 12 c0       	mov    %eax,0xc0126108
    }

    shift |= shiftcode[data];
c0101588:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010158c:	0f b6 80 60 50 12 c0 	movzbl -0x3fedafa0(%eax),%eax
c0101593:	0f b6 d0             	movzbl %al,%edx
c0101596:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c010159b:	09 d0                	or     %edx,%eax
c010159d:	a3 08 61 12 c0       	mov    %eax,0xc0126108
    shift ^= togglecode[data];
c01015a2:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015a6:	0f b6 80 60 51 12 c0 	movzbl -0x3fedaea0(%eax),%eax
c01015ad:	0f b6 d0             	movzbl %al,%edx
c01015b0:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c01015b5:	31 d0                	xor    %edx,%eax
c01015b7:	a3 08 61 12 c0       	mov    %eax,0xc0126108

    c = charcode[shift & (CTL | SHIFT)][data];
c01015bc:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c01015c1:	83 e0 03             	and    $0x3,%eax
c01015c4:	8b 14 85 60 55 12 c0 	mov    -0x3fedaaa0(,%eax,4),%edx
c01015cb:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015cf:	01 d0                	add    %edx,%eax
c01015d1:	0f b6 00             	movzbl (%eax),%eax
c01015d4:	0f b6 c0             	movzbl %al,%eax
c01015d7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015da:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c01015df:	83 e0 08             	and    $0x8,%eax
c01015e2:	85 c0                	test   %eax,%eax
c01015e4:	74 22                	je     c0101608 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
c01015e6:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015ea:	7e 0c                	jle    c01015f8 <kbd_proc_data+0x14f>
c01015ec:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015f0:	7f 06                	jg     c01015f8 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
c01015f2:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015f6:	eb 10                	jmp    c0101608 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
c01015f8:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015fc:	7e 0a                	jle    c0101608 <kbd_proc_data+0x15f>
c01015fe:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c0101602:	7f 04                	jg     c0101608 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
c0101604:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101608:	a1 08 61 12 c0       	mov    0xc0126108,%eax
c010160d:	f7 d0                	not    %eax
c010160f:	83 e0 06             	and    $0x6,%eax
c0101612:	85 c0                	test   %eax,%eax
c0101614:	75 28                	jne    c010163e <kbd_proc_data+0x195>
c0101616:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c010161d:	75 1f                	jne    c010163e <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
c010161f:	c7 04 24 bd a3 10 c0 	movl   $0xc010a3bd,(%esp)
c0101626:	e8 34 ed ff ff       	call   c010035f <cprintf>
c010162b:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101631:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101635:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101639:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c010163d:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c010163e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101641:	83 c4 44             	add    $0x44,%esp
c0101644:	5b                   	pop    %ebx
c0101645:	5d                   	pop    %ebp
c0101646:	c3                   	ret    

c0101647 <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c0101647:	55                   	push   %ebp
c0101648:	89 e5                	mov    %esp,%ebp
c010164a:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c010164d:	c7 04 24 a9 14 10 c0 	movl   $0xc01014a9,(%esp)
c0101654:	e8 7d fd ff ff       	call   c01013d6 <cons_intr>
}
c0101659:	c9                   	leave  
c010165a:	c3                   	ret    

c010165b <kbd_init>:

static void
kbd_init(void) {
c010165b:	55                   	push   %ebp
c010165c:	89 e5                	mov    %esp,%ebp
c010165e:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101661:	e8 e1 ff ff ff       	call   c0101647 <kbd_intr>
    pic_enable(IRQ_KBD);
c0101666:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010166d:	e8 da 09 00 00       	call   c010204c <pic_enable>
}
c0101672:	c9                   	leave  
c0101673:	c3                   	ret    

c0101674 <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c0101674:	55                   	push   %ebp
c0101675:	89 e5                	mov    %esp,%ebp
c0101677:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c010167a:	e8 18 f8 ff ff       	call   c0100e97 <cga_init>
    serial_init();
c010167f:	e8 0e f9 ff ff       	call   c0100f92 <serial_init>
    kbd_init();
c0101684:	e8 d2 ff ff ff       	call   c010165b <kbd_init>
    if (!serial_exists) {
c0101689:	a1 e8 5e 12 c0       	mov    0xc0125ee8,%eax
c010168e:	85 c0                	test   %eax,%eax
c0101690:	75 0c                	jne    c010169e <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c0101692:	c7 04 24 c9 a3 10 c0 	movl   $0xc010a3c9,(%esp)
c0101699:	e8 c1 ec ff ff       	call   c010035f <cprintf>
    }
}
c010169e:	c9                   	leave  
c010169f:	c3                   	ret    

c01016a0 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c01016a0:	55                   	push   %ebp
c01016a1:	89 e5                	mov    %esp,%ebp
c01016a3:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c01016a6:	e8 3d f7 ff ff       	call   c0100de8 <__intr_save>
c01016ab:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b1:	89 04 24             	mov    %eax,(%esp)
c01016b4:	e8 5f fa ff ff       	call   c0101118 <lpt_putc>
        cga_putc(c);
c01016b9:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bc:	89 04 24             	mov    %eax,(%esp)
c01016bf:	e8 93 fa ff ff       	call   c0101157 <cga_putc>
        serial_putc(c);
c01016c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01016c7:	89 04 24             	mov    %eax,(%esp)
c01016ca:	e8 c8 fc ff ff       	call   c0101397 <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016cf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016d2:	89 04 24             	mov    %eax,(%esp)
c01016d5:	e8 3d f7 ff ff       	call   c0100e17 <__intr_restore>
}
c01016da:	c9                   	leave  
c01016db:	c3                   	ret    

c01016dc <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016dc:	55                   	push   %ebp
c01016dd:	89 e5                	mov    %esp,%ebp
c01016df:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016e2:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016e9:	e8 fa f6 ff ff       	call   c0100de8 <__intr_save>
c01016ee:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016f1:	e8 96 fd ff ff       	call   c010148c <serial_intr>
        kbd_intr();
c01016f6:	e8 4c ff ff ff       	call   c0101647 <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016fb:	8b 15 00 61 12 c0    	mov    0xc0126100,%edx
c0101701:	a1 04 61 12 c0       	mov    0xc0126104,%eax
c0101706:	39 c2                	cmp    %eax,%edx
c0101708:	74 30                	je     c010173a <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
c010170a:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c010170f:	0f b6 90 00 5f 12 c0 	movzbl -0x3feda100(%eax),%edx
c0101716:	0f b6 d2             	movzbl %dl,%edx
c0101719:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010171c:	83 c0 01             	add    $0x1,%eax
c010171f:	a3 00 61 12 c0       	mov    %eax,0xc0126100
            if (cons.rpos == CONSBUFSIZE) {
c0101724:	a1 00 61 12 c0       	mov    0xc0126100,%eax
c0101729:	3d 00 02 00 00       	cmp    $0x200,%eax
c010172e:	75 0a                	jne    c010173a <cons_getc+0x5e>
                cons.rpos = 0;
c0101730:	c7 05 00 61 12 c0 00 	movl   $0x0,0xc0126100
c0101737:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c010173a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010173d:	89 04 24             	mov    %eax,(%esp)
c0101740:	e8 d2 f6 ff ff       	call   c0100e17 <__intr_restore>
    return c;
c0101745:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101748:	c9                   	leave  
c0101749:	c3                   	ret    
	...

c010174c <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c010174c:	55                   	push   %ebp
c010174d:	89 e5                	mov    %esp,%ebp
c010174f:	53                   	push   %ebx
c0101750:	83 ec 14             	sub    $0x14,%esp
c0101753:	8b 45 08             	mov    0x8(%ebp),%eax
c0101756:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c010175a:	90                   	nop
c010175b:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c010175f:	83 c0 07             	add    $0x7,%eax
c0101762:	0f b7 c0             	movzwl %ax,%eax
c0101765:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101769:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010176d:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101771:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101775:	ec                   	in     (%dx),%al
c0101776:	89 c3                	mov    %eax,%ebx
c0101778:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c010177b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010177f:	0f b6 c0             	movzbl %al,%eax
c0101782:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0101785:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101788:	25 80 00 00 00       	and    $0x80,%eax
c010178d:	85 c0                	test   %eax,%eax
c010178f:	75 ca                	jne    c010175b <ide_wait_ready+0xf>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0101791:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0101795:	74 11                	je     c01017a8 <ide_wait_ready+0x5c>
c0101797:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010179a:	83 e0 21             	and    $0x21,%eax
c010179d:	85 c0                	test   %eax,%eax
c010179f:	74 07                	je     c01017a8 <ide_wait_ready+0x5c>
        return -1;
c01017a1:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01017a6:	eb 05                	jmp    c01017ad <ide_wait_ready+0x61>
    }
    return 0;
c01017a8:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01017ad:	83 c4 14             	add    $0x14,%esp
c01017b0:	5b                   	pop    %ebx
c01017b1:	5d                   	pop    %ebp
c01017b2:	c3                   	ret    

c01017b3 <ide_init>:

void
ide_init(void) {
c01017b3:	55                   	push   %ebp
c01017b4:	89 e5                	mov    %esp,%ebp
c01017b6:	57                   	push   %edi
c01017b7:	56                   	push   %esi
c01017b8:	53                   	push   %ebx
c01017b9:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01017bf:	66 c7 45 e6 00 00    	movw   $0x0,-0x1a(%ebp)
c01017c5:	e9 e3 02 00 00       	jmp    c0101aad <ide_init+0x2fa>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c01017ca:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01017ce:	c1 e0 03             	shl    $0x3,%eax
c01017d1:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01017d8:	29 c2                	sub    %eax,%edx
c01017da:	8d 82 20 61 12 c0    	lea    -0x3fed9ee0(%edx),%eax
c01017e0:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c01017e3:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01017e7:	66 d1 e8             	shr    %ax
c01017ea:	0f b7 c0             	movzwl %ax,%eax
c01017ed:	0f b7 04 85 e8 a3 10 	movzwl -0x3fef5c18(,%eax,4),%eax
c01017f4:	c0 
c01017f5:	66 89 45 da          	mov    %ax,-0x26(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c01017f9:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01017fd:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101804:	00 
c0101805:	89 04 24             	mov    %eax,(%esp)
c0101808:	e8 3f ff ff ff       	call   c010174c <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c010180d:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101811:	83 e0 01             	and    $0x1,%eax
c0101814:	c1 e0 04             	shl    $0x4,%eax
c0101817:	83 c8 e0             	or     $0xffffffe0,%eax
c010181a:	0f b6 c0             	movzbl %al,%eax
c010181d:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101821:	83 c2 06             	add    $0x6,%edx
c0101824:	0f b7 d2             	movzwl %dx,%edx
c0101827:	66 89 55 c2          	mov    %dx,-0x3e(%ebp)
c010182b:	88 45 c1             	mov    %al,-0x3f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010182e:	0f b6 45 c1          	movzbl -0x3f(%ebp),%eax
c0101832:	0f b7 55 c2          	movzwl -0x3e(%ebp),%edx
c0101836:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101837:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c010183b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101842:	00 
c0101843:	89 04 24             	mov    %eax,(%esp)
c0101846:	e8 01 ff ff ff       	call   c010174c <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c010184b:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c010184f:	83 c0 07             	add    $0x7,%eax
c0101852:	0f b7 c0             	movzwl %ax,%eax
c0101855:	66 89 45 be          	mov    %ax,-0x42(%ebp)
c0101859:	c6 45 bd ec          	movb   $0xec,-0x43(%ebp)
c010185d:	0f b6 45 bd          	movzbl -0x43(%ebp),%eax
c0101861:	0f b7 55 be          	movzwl -0x42(%ebp),%edx
c0101865:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c0101866:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c010186a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101871:	00 
c0101872:	89 04 24             	mov    %eax,(%esp)
c0101875:	e8 d2 fe ff ff       	call   c010174c <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c010187a:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c010187e:	83 c0 07             	add    $0x7,%eax
c0101881:	0f b7 c0             	movzwl %ax,%eax
c0101884:	66 89 45 ba          	mov    %ax,-0x46(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101888:	0f b7 55 ba          	movzwl -0x46(%ebp),%edx
c010188c:	66 89 95 a6 fd ff ff 	mov    %dx,-0x25a(%ebp)
c0101893:	0f b7 95 a6 fd ff ff 	movzwl -0x25a(%ebp),%edx
c010189a:	ec                   	in     (%dx),%al
c010189b:	89 c3                	mov    %eax,%ebx
c010189d:	88 5d b9             	mov    %bl,-0x47(%ebp)
    return data;
c01018a0:	0f b6 45 b9          	movzbl -0x47(%ebp),%eax
c01018a4:	84 c0                	test   %al,%al
c01018a6:	0f 84 fb 01 00 00    	je     c0101aa7 <ide_init+0x2f4>
c01018ac:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01018b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01018b7:	00 
c01018b8:	89 04 24             	mov    %eax,(%esp)
c01018bb:	e8 8c fe ff ff       	call   c010174c <ide_wait_ready>
c01018c0:	85 c0                	test   %eax,%eax
c01018c2:	0f 85 df 01 00 00    	jne    c0101aa7 <ide_init+0x2f4>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c01018c8:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01018cc:	c1 e0 03             	shl    $0x3,%eax
c01018cf:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018d6:	29 c2                	sub    %eax,%edx
c01018d8:	8d 82 20 61 12 c0    	lea    -0x3fed9ee0(%edx),%eax
c01018de:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c01018e1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01018e5:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01018e8:	8d 85 ac fd ff ff    	lea    -0x254(%ebp),%eax
c01018ee:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01018f1:	c7 45 ac 80 00 00 00 	movl   $0x80,-0x54(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c01018f8:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01018fb:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c01018fe:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0101901:	89 ce                	mov    %ecx,%esi
c0101903:	89 d3                	mov    %edx,%ebx
c0101905:	89 f7                	mov    %esi,%edi
c0101907:	89 d9                	mov    %ebx,%ecx
c0101909:	89 c2                	mov    %eax,%edx
c010190b:	fc                   	cld    
c010190c:	f2 6d                	repnz insl (%dx),%es:(%edi)
c010190e:	89 cb                	mov    %ecx,%ebx
c0101910:	89 fe                	mov    %edi,%esi
c0101912:	89 75 b0             	mov    %esi,-0x50(%ebp)
c0101915:	89 5d ac             	mov    %ebx,-0x54(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101918:	8d 85 ac fd ff ff    	lea    -0x254(%ebp),%eax
c010191e:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101921:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101924:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c010192a:	89 45 d0             	mov    %eax,-0x30(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c010192d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101930:	25 00 00 00 04       	and    $0x4000000,%eax
c0101935:	85 c0                	test   %eax,%eax
c0101937:	74 0e                	je     c0101947 <ide_init+0x194>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101939:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010193c:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c0101942:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0101945:	eb 09                	jmp    c0101950 <ide_init+0x19d>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c0101947:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010194a:	8b 40 78             	mov    0x78(%eax),%eax
c010194d:	89 45 e0             	mov    %eax,-0x20(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101950:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101954:	c1 e0 03             	shl    $0x3,%eax
c0101957:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010195e:	29 c2                	sub    %eax,%edx
c0101960:	81 c2 20 61 12 c0    	add    $0xc0126120,%edx
c0101966:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101969:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c010196c:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101970:	c1 e0 03             	shl    $0x3,%eax
c0101973:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c010197a:	29 c2                	sub    %eax,%edx
c010197c:	81 c2 20 61 12 c0    	add    $0xc0126120,%edx
c0101982:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0101985:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0101988:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010198b:	83 c0 62             	add    $0x62,%eax
c010198e:	0f b7 00             	movzwl (%eax),%eax
c0101991:	0f b7 c0             	movzwl %ax,%eax
c0101994:	25 00 02 00 00       	and    $0x200,%eax
c0101999:	85 c0                	test   %eax,%eax
c010199b:	75 24                	jne    c01019c1 <ide_init+0x20e>
c010199d:	c7 44 24 0c f0 a3 10 	movl   $0xc010a3f0,0xc(%esp)
c01019a4:	c0 
c01019a5:	c7 44 24 08 33 a4 10 	movl   $0xc010a433,0x8(%esp)
c01019ac:	c0 
c01019ad:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01019b4:	00 
c01019b5:	c7 04 24 48 a4 10 c0 	movl   $0xc010a448,(%esp)
c01019bc:	e8 ff f2 ff ff       	call   c0100cc0 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c01019c1:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01019c5:	c1 e0 03             	shl    $0x3,%eax
c01019c8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019cf:	29 c2                	sub    %eax,%edx
c01019d1:	8d 82 20 61 12 c0    	lea    -0x3fed9ee0(%edx),%eax
c01019d7:	83 c0 0c             	add    $0xc,%eax
c01019da:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01019dd:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01019e0:	83 c0 36             	add    $0x36,%eax
c01019e3:	89 45 c8             	mov    %eax,-0x38(%ebp)
        unsigned int i, length = 40;
c01019e6:	c7 45 c4 28 00 00 00 	movl   $0x28,-0x3c(%ebp)
        for (i = 0; i < length; i += 2) {
c01019ed:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01019f4:	eb 30                	jmp    c0101a26 <ide_init+0x273>
            model[i] = data[i + 1], model[i + 1] = data[i];
c01019f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01019f9:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01019fc:	01 c2                	add    %eax,%edx
c01019fe:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a01:	83 c0 01             	add    $0x1,%eax
c0101a04:	03 45 c8             	add    -0x38(%ebp),%eax
c0101a07:	0f b6 00             	movzbl (%eax),%eax
c0101a0a:	88 02                	mov    %al,(%edx)
c0101a0c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a0f:	83 c0 01             	add    $0x1,%eax
c0101a12:	03 45 cc             	add    -0x34(%ebp),%eax
c0101a15:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a18:	8b 4d c8             	mov    -0x38(%ebp),%ecx
c0101a1b:	01 ca                	add    %ecx,%edx
c0101a1d:	0f b6 12             	movzbl (%edx),%edx
c0101a20:	88 10                	mov    %dl,(%eax)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101a22:	83 45 dc 02          	addl   $0x2,-0x24(%ebp)
c0101a26:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a29:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0101a2c:	72 c8                	jb     c01019f6 <ide_init+0x243>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101a2e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a31:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101a34:	01 d0                	add    %edx,%eax
c0101a36:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101a39:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0101a3d:	0f 95 c0             	setne  %al
c0101a40:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0101a44:	84 c0                	test   %al,%al
c0101a46:	74 0f                	je     c0101a57 <ide_init+0x2a4>
c0101a48:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a4b:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101a4e:	01 d0                	add    %edx,%eax
c0101a50:	0f b6 00             	movzbl (%eax),%eax
c0101a53:	3c 20                	cmp    $0x20,%al
c0101a55:	74 d7                	je     c0101a2e <ide_init+0x27b>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101a57:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101a5b:	c1 e0 03             	shl    $0x3,%eax
c0101a5e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a65:	29 c2                	sub    %eax,%edx
c0101a67:	8d 82 20 61 12 c0    	lea    -0x3fed9ee0(%edx),%eax
c0101a6d:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101a70:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101a74:	c1 e0 03             	shl    $0x3,%eax
c0101a77:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a7e:	29 c2                	sub    %eax,%edx
c0101a80:	8d 82 20 61 12 c0    	lea    -0x3fed9ee0(%edx),%eax
c0101a86:	8b 50 08             	mov    0x8(%eax),%edx
c0101a89:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101a8d:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101a91:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101a95:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a99:	c7 04 24 5a a4 10 c0 	movl   $0xc010a45a,(%esp)
c0101aa0:	e8 ba e8 ff ff       	call   c010035f <cprintf>
c0101aa5:	eb 01                	jmp    c0101aa8 <ide_init+0x2f5>
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
        ide_wait_ready(iobase, 0);

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
            continue ;
c0101aa7:	90                   	nop

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101aa8:	66 83 45 e6 01       	addw   $0x1,-0x1a(%ebp)
c0101aad:	66 83 7d e6 03       	cmpw   $0x3,-0x1a(%ebp)
c0101ab2:	0f 86 12 fd ff ff    	jbe    c01017ca <ide_init+0x17>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101ab8:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101abf:	e8 88 05 00 00       	call   c010204c <pic_enable>
    pic_enable(IRQ_IDE2);
c0101ac4:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101acb:	e8 7c 05 00 00       	call   c010204c <pic_enable>
}
c0101ad0:	81 c4 6c 02 00 00    	add    $0x26c,%esp
c0101ad6:	5b                   	pop    %ebx
c0101ad7:	5e                   	pop    %esi
c0101ad8:	5f                   	pop    %edi
c0101ad9:	5d                   	pop    %ebp
c0101ada:	c3                   	ret    

c0101adb <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101adb:	55                   	push   %ebp
c0101adc:	89 e5                	mov    %esp,%ebp
c0101ade:	83 ec 04             	sub    $0x4,%esp
c0101ae1:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ae4:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101ae8:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101aed:	77 24                	ja     c0101b13 <ide_device_valid+0x38>
c0101aef:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101af3:	c1 e0 03             	shl    $0x3,%eax
c0101af6:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101afd:	29 c2                	sub    %eax,%edx
c0101aff:	8d 82 20 61 12 c0    	lea    -0x3fed9ee0(%edx),%eax
c0101b05:	0f b6 00             	movzbl (%eax),%eax
c0101b08:	84 c0                	test   %al,%al
c0101b0a:	74 07                	je     c0101b13 <ide_device_valid+0x38>
c0101b0c:	b8 01 00 00 00       	mov    $0x1,%eax
c0101b11:	eb 05                	jmp    c0101b18 <ide_device_valid+0x3d>
c0101b13:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b18:	c9                   	leave  
c0101b19:	c3                   	ret    

c0101b1a <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101b1a:	55                   	push   %ebp
c0101b1b:	89 e5                	mov    %esp,%ebp
c0101b1d:	83 ec 08             	sub    $0x8,%esp
c0101b20:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b23:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101b27:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b2b:	89 04 24             	mov    %eax,(%esp)
c0101b2e:	e8 a8 ff ff ff       	call   c0101adb <ide_device_valid>
c0101b33:	85 c0                	test   %eax,%eax
c0101b35:	74 1b                	je     c0101b52 <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101b37:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b3b:	c1 e0 03             	shl    $0x3,%eax
c0101b3e:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b45:	29 c2                	sub    %eax,%edx
c0101b47:	8d 82 20 61 12 c0    	lea    -0x3fed9ee0(%edx),%eax
c0101b4d:	8b 40 08             	mov    0x8(%eax),%eax
c0101b50:	eb 05                	jmp    c0101b57 <ide_device_size+0x3d>
    }
    return 0;
c0101b52:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b57:	c9                   	leave  
c0101b58:	c3                   	ret    

c0101b59 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101b59:	55                   	push   %ebp
c0101b5a:	89 e5                	mov    %esp,%ebp
c0101b5c:	57                   	push   %edi
c0101b5d:	56                   	push   %esi
c0101b5e:	53                   	push   %ebx
c0101b5f:	83 ec 5c             	sub    $0x5c,%esp
c0101b62:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b65:	66 89 45 b4          	mov    %ax,-0x4c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101b69:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101b70:	77 24                	ja     c0101b96 <ide_read_secs+0x3d>
c0101b72:	66 83 7d b4 03       	cmpw   $0x3,-0x4c(%ebp)
c0101b77:	77 1d                	ja     c0101b96 <ide_read_secs+0x3d>
c0101b79:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101b7d:	c1 e0 03             	shl    $0x3,%eax
c0101b80:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b87:	29 c2                	sub    %eax,%edx
c0101b89:	8d 82 20 61 12 c0    	lea    -0x3fed9ee0(%edx),%eax
c0101b8f:	0f b6 00             	movzbl (%eax),%eax
c0101b92:	84 c0                	test   %al,%al
c0101b94:	75 24                	jne    c0101bba <ide_read_secs+0x61>
c0101b96:	c7 44 24 0c 78 a4 10 	movl   $0xc010a478,0xc(%esp)
c0101b9d:	c0 
c0101b9e:	c7 44 24 08 33 a4 10 	movl   $0xc010a433,0x8(%esp)
c0101ba5:	c0 
c0101ba6:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101bad:	00 
c0101bae:	c7 04 24 48 a4 10 c0 	movl   $0xc010a448,(%esp)
c0101bb5:	e8 06 f1 ff ff       	call   c0100cc0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101bba:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101bc1:	77 0f                	ja     c0101bd2 <ide_read_secs+0x79>
c0101bc3:	8b 45 14             	mov    0x14(%ebp),%eax
c0101bc6:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101bc9:	01 d0                	add    %edx,%eax
c0101bcb:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101bd0:	76 24                	jbe    c0101bf6 <ide_read_secs+0x9d>
c0101bd2:	c7 44 24 0c a0 a4 10 	movl   $0xc010a4a0,0xc(%esp)
c0101bd9:	c0 
c0101bda:	c7 44 24 08 33 a4 10 	movl   $0xc010a433,0x8(%esp)
c0101be1:	c0 
c0101be2:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101be9:	00 
c0101bea:	c7 04 24 48 a4 10 c0 	movl   $0xc010a448,(%esp)
c0101bf1:	e8 ca f0 ff ff       	call   c0100cc0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101bf6:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101bfa:	66 d1 e8             	shr    %ax
c0101bfd:	0f b7 c0             	movzwl %ax,%eax
c0101c00:	0f b7 04 85 e8 a3 10 	movzwl -0x3fef5c18(,%eax,4),%eax
c0101c07:	c0 
c0101c08:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
c0101c0c:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101c10:	66 d1 e8             	shr    %ax
c0101c13:	0f b7 c0             	movzwl %ax,%eax
c0101c16:	0f b7 04 85 ea a3 10 	movzwl -0x3fef5c16(,%eax,4),%eax
c0101c1d:	c0 
c0101c1e:	66 89 45 e0          	mov    %ax,-0x20(%ebp)

    ide_wait_ready(iobase, 0);
c0101c22:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101c26:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101c2d:	00 
c0101c2e:	89 04 24             	mov    %eax,(%esp)
c0101c31:	e8 16 fb ff ff       	call   c010174c <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101c36:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
c0101c3a:	83 c0 02             	add    $0x2,%eax
c0101c3d:	0f b7 c0             	movzwl %ax,%eax
c0101c40:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c0101c44:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c48:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c4c:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c50:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101c51:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c54:	0f b6 c0             	movzbl %al,%eax
c0101c57:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c5b:	83 c2 02             	add    $0x2,%edx
c0101c5e:	0f b7 d2             	movzwl %dx,%edx
c0101c61:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c65:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c68:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c6c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c70:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101c71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c74:	0f b6 c0             	movzbl %al,%eax
c0101c77:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c7b:	83 c2 03             	add    $0x3,%edx
c0101c7e:	0f b7 d2             	movzwl %dx,%edx
c0101c81:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c0101c85:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101c88:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c8c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c90:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101c91:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c94:	c1 e8 08             	shr    $0x8,%eax
c0101c97:	0f b6 c0             	movzbl %al,%eax
c0101c9a:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c9e:	83 c2 04             	add    $0x4,%edx
c0101ca1:	0f b7 d2             	movzwl %dx,%edx
c0101ca4:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101ca8:	88 45 d1             	mov    %al,-0x2f(%ebp)
c0101cab:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101caf:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101cb3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101cb4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cb7:	c1 e8 10             	shr    $0x10,%eax
c0101cba:	0f b6 c0             	movzbl %al,%eax
c0101cbd:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101cc1:	83 c2 05             	add    $0x5,%edx
c0101cc4:	0f b7 d2             	movzwl %dx,%edx
c0101cc7:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
c0101ccb:	88 45 cd             	mov    %al,-0x33(%ebp)
c0101cce:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101cd2:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101cd6:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101cd7:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101cdb:	83 e0 01             	and    $0x1,%eax
c0101cde:	89 c2                	mov    %eax,%edx
c0101ce0:	c1 e2 04             	shl    $0x4,%edx
c0101ce3:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ce6:	c1 e8 18             	shr    $0x18,%eax
c0101ce9:	83 e0 0f             	and    $0xf,%eax
c0101cec:	09 d0                	or     %edx,%eax
c0101cee:	83 c8 e0             	or     $0xffffffe0,%eax
c0101cf1:	0f b6 c0             	movzbl %al,%eax
c0101cf4:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101cf8:	83 c2 06             	add    $0x6,%edx
c0101cfb:	0f b7 d2             	movzwl %dx,%edx
c0101cfe:	66 89 55 ca          	mov    %dx,-0x36(%ebp)
c0101d02:	88 45 c9             	mov    %al,-0x37(%ebp)
c0101d05:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101d09:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101d0d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101d0e:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101d12:	83 c0 07             	add    $0x7,%eax
c0101d15:	0f b7 c0             	movzwl %ax,%eax
c0101d18:	66 89 45 c6          	mov    %ax,-0x3a(%ebp)
c0101d1c:	c6 45 c5 20          	movb   $0x20,-0x3b(%ebp)
c0101d20:	0f b6 45 c5          	movzbl -0x3b(%ebp),%eax
c0101d24:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101d28:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101d29:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d30:	eb 5c                	jmp    c0101d8e <ide_read_secs+0x235>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101d32:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101d36:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101d3d:	00 
c0101d3e:	89 04 24             	mov    %eax,(%esp)
c0101d41:	e8 06 fa ff ff       	call   c010174c <ide_wait_ready>
c0101d46:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0101d49:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0101d4d:	75 47                	jne    c0101d96 <ide_read_secs+0x23d>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d4f:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101d53:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101d56:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d59:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0101d5c:	c7 45 b8 80 00 00 00 	movl   $0x80,-0x48(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101d63:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0101d66:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0101d69:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0101d6c:	89 ce                	mov    %ecx,%esi
c0101d6e:	89 d3                	mov    %edx,%ebx
c0101d70:	89 f7                	mov    %esi,%edi
c0101d72:	89 d9                	mov    %ebx,%ecx
c0101d74:	89 c2                	mov    %eax,%edx
c0101d76:	fc                   	cld    
c0101d77:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101d79:	89 cb                	mov    %ecx,%ebx
c0101d7b:	89 fe                	mov    %edi,%esi
c0101d7d:	89 75 bc             	mov    %esi,-0x44(%ebp)
c0101d80:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d83:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101d87:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101d8e:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101d92:	75 9e                	jne    c0101d32 <ide_read_secs+0x1d9>
c0101d94:	eb 01                	jmp    c0101d97 <ide_read_secs+0x23e>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c0101d96:	90                   	nop
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101d97:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
c0101d9a:	83 c4 5c             	add    $0x5c,%esp
c0101d9d:	5b                   	pop    %ebx
c0101d9e:	5e                   	pop    %esi
c0101d9f:	5f                   	pop    %edi
c0101da0:	5d                   	pop    %ebp
c0101da1:	c3                   	ret    

c0101da2 <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101da2:	55                   	push   %ebp
c0101da3:	89 e5                	mov    %esp,%ebp
c0101da5:	56                   	push   %esi
c0101da6:	53                   	push   %ebx
c0101da7:	83 ec 50             	sub    $0x50,%esp
c0101daa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101dad:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101db1:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101db8:	77 24                	ja     c0101dde <ide_write_secs+0x3c>
c0101dba:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101dbf:	77 1d                	ja     c0101dde <ide_write_secs+0x3c>
c0101dc1:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101dc5:	c1 e0 03             	shl    $0x3,%eax
c0101dc8:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101dcf:	29 c2                	sub    %eax,%edx
c0101dd1:	8d 82 20 61 12 c0    	lea    -0x3fed9ee0(%edx),%eax
c0101dd7:	0f b6 00             	movzbl (%eax),%eax
c0101dda:	84 c0                	test   %al,%al
c0101ddc:	75 24                	jne    c0101e02 <ide_write_secs+0x60>
c0101dde:	c7 44 24 0c 78 a4 10 	movl   $0xc010a478,0xc(%esp)
c0101de5:	c0 
c0101de6:	c7 44 24 08 33 a4 10 	movl   $0xc010a433,0x8(%esp)
c0101ded:	c0 
c0101dee:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101df5:	00 
c0101df6:	c7 04 24 48 a4 10 c0 	movl   $0xc010a448,(%esp)
c0101dfd:	e8 be ee ff ff       	call   c0100cc0 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101e02:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101e09:	77 0f                	ja     c0101e1a <ide_write_secs+0x78>
c0101e0b:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e0e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e11:	01 d0                	add    %edx,%eax
c0101e13:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101e18:	76 24                	jbe    c0101e3e <ide_write_secs+0x9c>
c0101e1a:	c7 44 24 0c a0 a4 10 	movl   $0xc010a4a0,0xc(%esp)
c0101e21:	c0 
c0101e22:	c7 44 24 08 33 a4 10 	movl   $0xc010a433,0x8(%esp)
c0101e29:	c0 
c0101e2a:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101e31:	00 
c0101e32:	c7 04 24 48 a4 10 c0 	movl   $0xc010a448,(%esp)
c0101e39:	e8 82 ee ff ff       	call   c0100cc0 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101e3e:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e42:	66 d1 e8             	shr    %ax
c0101e45:	0f b7 c0             	movzwl %ax,%eax
c0101e48:	0f b7 04 85 e8 a3 10 	movzwl -0x3fef5c18(,%eax,4),%eax
c0101e4f:	c0 
c0101e50:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e54:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e58:	66 d1 e8             	shr    %ax
c0101e5b:	0f b7 c0             	movzwl %ax,%eax
c0101e5e:	0f b7 04 85 ea a3 10 	movzwl -0x3fef5c16(,%eax,4),%eax
c0101e65:	c0 
c0101e66:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101e6a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e6e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101e75:	00 
c0101e76:	89 04 24             	mov    %eax,(%esp)
c0101e79:	e8 ce f8 ff ff       	call   c010174c <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101e7e:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101e82:	83 c0 02             	add    $0x2,%eax
c0101e85:	0f b7 c0             	movzwl %ax,%eax
c0101e88:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101e8c:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e90:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101e94:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101e98:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101e99:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e9c:	0f b6 c0             	movzbl %al,%eax
c0101e9f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ea3:	83 c2 02             	add    $0x2,%edx
c0101ea6:	0f b7 d2             	movzwl %dx,%edx
c0101ea9:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ead:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101eb0:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101eb4:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101eb8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ebc:	0f b6 c0             	movzbl %al,%eax
c0101ebf:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ec3:	83 c2 03             	add    $0x3,%edx
c0101ec6:	0f b7 d2             	movzwl %dx,%edx
c0101ec9:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101ecd:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101ed0:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101ed4:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101ed8:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101ed9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101edc:	c1 e8 08             	shr    $0x8,%eax
c0101edf:	0f b6 c0             	movzbl %al,%eax
c0101ee2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ee6:	83 c2 04             	add    $0x4,%edx
c0101ee9:	0f b7 d2             	movzwl %dx,%edx
c0101eec:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101ef0:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101ef3:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101ef7:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101efb:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101efc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101eff:	c1 e8 10             	shr    $0x10,%eax
c0101f02:	0f b6 c0             	movzbl %al,%eax
c0101f05:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f09:	83 c2 05             	add    $0x5,%edx
c0101f0c:	0f b7 d2             	movzwl %dx,%edx
c0101f0f:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101f13:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101f16:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101f1a:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101f1e:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101f1f:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f23:	83 e0 01             	and    $0x1,%eax
c0101f26:	89 c2                	mov    %eax,%edx
c0101f28:	c1 e2 04             	shl    $0x4,%edx
c0101f2b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f2e:	c1 e8 18             	shr    $0x18,%eax
c0101f31:	83 e0 0f             	and    $0xf,%eax
c0101f34:	09 d0                	or     %edx,%eax
c0101f36:	83 c8 e0             	or     $0xffffffe0,%eax
c0101f39:	0f b6 c0             	movzbl %al,%eax
c0101f3c:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f40:	83 c2 06             	add    $0x6,%edx
c0101f43:	0f b7 d2             	movzwl %dx,%edx
c0101f46:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101f4a:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101f4d:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101f51:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101f55:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f56:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f5a:	83 c0 07             	add    $0x7,%eax
c0101f5d:	0f b7 c0             	movzwl %ax,%eax
c0101f60:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101f64:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101f68:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101f6c:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101f70:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101f71:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f78:	eb 58                	jmp    c0101fd2 <ide_write_secs+0x230>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101f7a:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f7e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101f85:	00 
c0101f86:	89 04 24             	mov    %eax,(%esp)
c0101f89:	e8 be f7 ff ff       	call   c010174c <ide_wait_ready>
c0101f8e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101f91:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101f95:	75 43                	jne    c0101fda <ide_write_secs+0x238>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101f97:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f9b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101f9e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101fa1:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101fa4:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101fab:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101fae:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101fb1:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0101fb4:	89 ce                	mov    %ecx,%esi
c0101fb6:	89 d3                	mov    %edx,%ebx
c0101fb8:	89 d9                	mov    %ebx,%ecx
c0101fba:	89 c2                	mov    %eax,%edx
c0101fbc:	fc                   	cld    
c0101fbd:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101fbf:	89 cb                	mov    %ecx,%ebx
c0101fc1:	89 75 cc             	mov    %esi,-0x34(%ebp)
c0101fc4:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101fc7:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101fcb:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101fd2:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101fd6:	75 a2                	jne    c0101f7a <ide_write_secs+0x1d8>
c0101fd8:	eb 01                	jmp    c0101fdb <ide_write_secs+0x239>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c0101fda:	90                   	nop
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101fdb:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101fde:	83 c4 50             	add    $0x50,%esp
c0101fe1:	5b                   	pop    %ebx
c0101fe2:	5e                   	pop    %esi
c0101fe3:	5d                   	pop    %ebp
c0101fe4:	c3                   	ret    
c0101fe5:	00 00                	add    %al,(%eax)
	...

c0101fe8 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101fe8:	55                   	push   %ebp
c0101fe9:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101feb:	fb                   	sti    
    sti();
}
c0101fec:	5d                   	pop    %ebp
c0101fed:	c3                   	ret    

c0101fee <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101fee:	55                   	push   %ebp
c0101fef:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101ff1:	fa                   	cli    
    cli();
}
c0101ff2:	5d                   	pop    %ebp
c0101ff3:	c3                   	ret    

c0101ff4 <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101ff4:	55                   	push   %ebp
c0101ff5:	89 e5                	mov    %esp,%ebp
c0101ff7:	83 ec 14             	sub    $0x14,%esp
c0101ffa:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ffd:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0102001:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102005:	66 a3 70 55 12 c0    	mov    %ax,0xc0125570
    if (did_init) {
c010200b:	a1 00 62 12 c0       	mov    0xc0126200,%eax
c0102010:	85 c0                	test   %eax,%eax
c0102012:	74 36                	je     c010204a <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c0102014:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102018:	0f b6 c0             	movzbl %al,%eax
c010201b:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102021:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0102024:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102028:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010202c:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c010202d:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102031:	66 c1 e8 08          	shr    $0x8,%ax
c0102035:	0f b6 c0             	movzbl %al,%eax
c0102038:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c010203e:	88 45 f9             	mov    %al,-0x7(%ebp)
c0102041:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c0102045:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102049:	ee                   	out    %al,(%dx)
    }
}
c010204a:	c9                   	leave  
c010204b:	c3                   	ret    

c010204c <pic_enable>:

void
pic_enable(unsigned int irq) {
c010204c:	55                   	push   %ebp
c010204d:	89 e5                	mov    %esp,%ebp
c010204f:	53                   	push   %ebx
c0102050:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c0102053:	8b 45 08             	mov    0x8(%ebp),%eax
c0102056:	ba 01 00 00 00       	mov    $0x1,%edx
c010205b:	89 d3                	mov    %edx,%ebx
c010205d:	89 c1                	mov    %eax,%ecx
c010205f:	d3 e3                	shl    %cl,%ebx
c0102061:	89 d8                	mov    %ebx,%eax
c0102063:	89 c2                	mov    %eax,%edx
c0102065:	f7 d2                	not    %edx
c0102067:	0f b7 05 70 55 12 c0 	movzwl 0xc0125570,%eax
c010206e:	21 d0                	and    %edx,%eax
c0102070:	0f b7 c0             	movzwl %ax,%eax
c0102073:	89 04 24             	mov    %eax,(%esp)
c0102076:	e8 79 ff ff ff       	call   c0101ff4 <pic_setmask>
}
c010207b:	83 c4 04             	add    $0x4,%esp
c010207e:	5b                   	pop    %ebx
c010207f:	5d                   	pop    %ebp
c0102080:	c3                   	ret    

c0102081 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0102081:	55                   	push   %ebp
c0102082:	89 e5                	mov    %esp,%ebp
c0102084:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c0102087:	c7 05 00 62 12 c0 01 	movl   $0x1,0xc0126200
c010208e:	00 00 00 
c0102091:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102097:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c010209b:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c010209f:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c01020a3:	ee                   	out    %al,(%dx)
c01020a4:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01020aa:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01020ae:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01020b2:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01020b6:	ee                   	out    %al,(%dx)
c01020b7:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01020bd:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01020c1:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01020c5:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01020c9:	ee                   	out    %al,(%dx)
c01020ca:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01020d0:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01020d4:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01020d8:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01020dc:	ee                   	out    %al,(%dx)
c01020dd:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01020e3:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01020e7:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01020eb:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01020ef:	ee                   	out    %al,(%dx)
c01020f0:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01020f6:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01020fa:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01020fe:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0102102:	ee                   	out    %al,(%dx)
c0102103:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102109:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c010210d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102111:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0102115:	ee                   	out    %al,(%dx)
c0102116:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c010211c:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102120:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0102124:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102128:	ee                   	out    %al,(%dx)
c0102129:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c010212f:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c0102133:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0102137:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c010213b:	ee                   	out    %al,(%dx)
c010213c:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c0102142:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c0102146:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c010214a:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c010214e:	ee                   	out    %al,(%dx)
c010214f:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c0102155:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102159:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c010215d:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102161:	ee                   	out    %al,(%dx)
c0102162:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0102168:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c010216c:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0102170:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0102174:	ee                   	out    %al,(%dx)
c0102175:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c010217b:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c010217f:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0102183:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0102187:	ee                   	out    %al,(%dx)
c0102188:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c010218e:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c0102192:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0102196:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c010219a:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c010219b:	0f b7 05 70 55 12 c0 	movzwl 0xc0125570,%eax
c01021a2:	66 83 f8 ff          	cmp    $0xffff,%ax
c01021a6:	74 12                	je     c01021ba <pic_init+0x139>
        pic_setmask(irq_mask);
c01021a8:	0f b7 05 70 55 12 c0 	movzwl 0xc0125570,%eax
c01021af:	0f b7 c0             	movzwl %ax,%eax
c01021b2:	89 04 24             	mov    %eax,(%esp)
c01021b5:	e8 3a fe ff ff       	call   c0101ff4 <pic_setmask>
    }
}
c01021ba:	c9                   	leave  
c01021bb:	c3                   	ret    

c01021bc <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01021bc:	55                   	push   %ebp
c01021bd:	89 e5                	mov    %esp,%ebp
c01021bf:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01021c2:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01021c9:	00 
c01021ca:	c7 04 24 e0 a4 10 c0 	movl   $0xc010a4e0,(%esp)
c01021d1:	e8 89 e1 ff ff       	call   c010035f <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01021d6:	c7 04 24 ea a4 10 c0 	movl   $0xc010a4ea,(%esp)
c01021dd:	e8 7d e1 ff ff       	call   c010035f <cprintf>
    panic("EOT: kernel seems ok.");
c01021e2:	c7 44 24 08 f8 a4 10 	movl   $0xc010a4f8,0x8(%esp)
c01021e9:	c0 
c01021ea:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01021f1:	00 
c01021f2:	c7 04 24 0e a5 10 c0 	movl   $0xc010a50e,(%esp)
c01021f9:	e8 c2 ea ff ff       	call   c0100cc0 <__panic>

c01021fe <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01021fe:	55                   	push   %ebp
c01021ff:	89 e5                	mov    %esp,%ebp
c0102201:	83 ec 10             	sub    $0x10,%esp
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;

    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c0102204:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c010220b:	e9 c3 00 00 00       	jmp    c01022d3 <idt_init+0xd5>
        SETGATE(idt[i], 0,  GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102210:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102213:	8b 04 85 00 56 12 c0 	mov    -0x3fedaa00(,%eax,4),%eax
c010221a:	89 c2                	mov    %eax,%edx
c010221c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010221f:	66 89 14 c5 20 62 12 	mov    %dx,-0x3fed9de0(,%eax,8)
c0102226:	c0 
c0102227:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010222a:	66 c7 04 c5 22 62 12 	movw   $0x8,-0x3fed9dde(,%eax,8)
c0102231:	c0 08 00 
c0102234:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102237:	0f b6 14 c5 24 62 12 	movzbl -0x3fed9ddc(,%eax,8),%edx
c010223e:	c0 
c010223f:	83 e2 e0             	and    $0xffffffe0,%edx
c0102242:	88 14 c5 24 62 12 c0 	mov    %dl,-0x3fed9ddc(,%eax,8)
c0102249:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010224c:	0f b6 14 c5 24 62 12 	movzbl -0x3fed9ddc(,%eax,8),%edx
c0102253:	c0 
c0102254:	83 e2 1f             	and    $0x1f,%edx
c0102257:	88 14 c5 24 62 12 c0 	mov    %dl,-0x3fed9ddc(,%eax,8)
c010225e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102261:	0f b6 14 c5 25 62 12 	movzbl -0x3fed9ddb(,%eax,8),%edx
c0102268:	c0 
c0102269:	83 e2 f0             	and    $0xfffffff0,%edx
c010226c:	83 ca 0e             	or     $0xe,%edx
c010226f:	88 14 c5 25 62 12 c0 	mov    %dl,-0x3fed9ddb(,%eax,8)
c0102276:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102279:	0f b6 14 c5 25 62 12 	movzbl -0x3fed9ddb(,%eax,8),%edx
c0102280:	c0 
c0102281:	83 e2 ef             	and    $0xffffffef,%edx
c0102284:	88 14 c5 25 62 12 c0 	mov    %dl,-0x3fed9ddb(,%eax,8)
c010228b:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010228e:	0f b6 14 c5 25 62 12 	movzbl -0x3fed9ddb(,%eax,8),%edx
c0102295:	c0 
c0102296:	83 e2 9f             	and    $0xffffff9f,%edx
c0102299:	88 14 c5 25 62 12 c0 	mov    %dl,-0x3fed9ddb(,%eax,8)
c01022a0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022a3:	0f b6 14 c5 25 62 12 	movzbl -0x3fed9ddb(,%eax,8),%edx
c01022aa:	c0 
c01022ab:	83 ca 80             	or     $0xffffff80,%edx
c01022ae:	88 14 c5 25 62 12 c0 	mov    %dl,-0x3fed9ddb(,%eax,8)
c01022b5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022b8:	8b 04 85 00 56 12 c0 	mov    -0x3fedaa00(,%eax,4),%eax
c01022bf:	c1 e8 10             	shr    $0x10,%eax
c01022c2:	89 c2                	mov    %eax,%edx
c01022c4:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022c7:	66 89 14 c5 26 62 12 	mov    %dx,-0x3fed9dda(,%eax,8)
c01022ce:	c0 
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;

    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01022cf:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01022d3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022d6:	3d ff 00 00 00       	cmp    $0xff,%eax
c01022db:	0f 86 2f ff ff ff    	jbe    c0102210 <idt_init+0x12>
        SETGATE(idt[i], 0,  GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01022e1:	a1 e4 57 12 c0       	mov    0xc01257e4,%eax
c01022e6:	66 a3 e8 65 12 c0    	mov    %ax,0xc01265e8
c01022ec:	66 c7 05 ea 65 12 c0 	movw   $0x8,0xc01265ea
c01022f3:	08 00 
c01022f5:	0f b6 05 ec 65 12 c0 	movzbl 0xc01265ec,%eax
c01022fc:	83 e0 e0             	and    $0xffffffe0,%eax
c01022ff:	a2 ec 65 12 c0       	mov    %al,0xc01265ec
c0102304:	0f b6 05 ec 65 12 c0 	movzbl 0xc01265ec,%eax
c010230b:	83 e0 1f             	and    $0x1f,%eax
c010230e:	a2 ec 65 12 c0       	mov    %al,0xc01265ec
c0102313:	0f b6 05 ed 65 12 c0 	movzbl 0xc01265ed,%eax
c010231a:	83 e0 f0             	and    $0xfffffff0,%eax
c010231d:	83 c8 0e             	or     $0xe,%eax
c0102320:	a2 ed 65 12 c0       	mov    %al,0xc01265ed
c0102325:	0f b6 05 ed 65 12 c0 	movzbl 0xc01265ed,%eax
c010232c:	83 e0 ef             	and    $0xffffffef,%eax
c010232f:	a2 ed 65 12 c0       	mov    %al,0xc01265ed
c0102334:	0f b6 05 ed 65 12 c0 	movzbl 0xc01265ed,%eax
c010233b:	83 c8 60             	or     $0x60,%eax
c010233e:	a2 ed 65 12 c0       	mov    %al,0xc01265ed
c0102343:	0f b6 05 ed 65 12 c0 	movzbl 0xc01265ed,%eax
c010234a:	83 c8 80             	or     $0xffffff80,%eax
c010234d:	a2 ed 65 12 c0       	mov    %al,0xc01265ed
c0102352:	a1 e4 57 12 c0       	mov    0xc01257e4,%eax
c0102357:	c1 e8 10             	shr    $0x10,%eax
c010235a:	66 a3 ee 65 12 c0    	mov    %ax,0xc01265ee
c0102360:	c7 45 f8 80 55 12 c0 	movl   $0xc0125580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c0102367:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010236a:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd); // load the IDT
}
c010236d:	c9                   	leave  
c010236e:	c3                   	ret    

c010236f <trapname>:

static const char *
trapname(int trapno) {
c010236f:	55                   	push   %ebp
c0102370:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c0102372:	8b 45 08             	mov    0x8(%ebp),%eax
c0102375:	83 f8 13             	cmp    $0x13,%eax
c0102378:	77 0c                	ja     c0102386 <trapname+0x17>
        return excnames[trapno];
c010237a:	8b 45 08             	mov    0x8(%ebp),%eax
c010237d:	8b 04 85 e0 a8 10 c0 	mov    -0x3fef5720(,%eax,4),%eax
c0102384:	eb 18                	jmp    c010239e <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c0102386:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c010238a:	7e 0d                	jle    c0102399 <trapname+0x2a>
c010238c:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102390:	7f 07                	jg     c0102399 <trapname+0x2a>
        return "Hardware Interrupt";
c0102392:	b8 1f a5 10 c0       	mov    $0xc010a51f,%eax
c0102397:	eb 05                	jmp    c010239e <trapname+0x2f>
    }
    return "(unknown trap)";
c0102399:	b8 32 a5 10 c0       	mov    $0xc010a532,%eax
}
c010239e:	5d                   	pop    %ebp
c010239f:	c3                   	ret    

c01023a0 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c01023a0:	55                   	push   %ebp
c01023a1:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c01023a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01023a6:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023aa:	66 83 f8 08          	cmp    $0x8,%ax
c01023ae:	0f 94 c0             	sete   %al
c01023b1:	0f b6 c0             	movzbl %al,%eax
}
c01023b4:	5d                   	pop    %ebp
c01023b5:	c3                   	ret    

c01023b6 <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01023b6:	55                   	push   %ebp
c01023b7:	89 e5                	mov    %esp,%ebp
c01023b9:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01023bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01023bf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023c3:	c7 04 24 73 a5 10 c0 	movl   $0xc010a573,(%esp)
c01023ca:	e8 90 df ff ff       	call   c010035f <cprintf>
    print_regs(&tf->tf_regs);
c01023cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d2:	89 04 24             	mov    %eax,(%esp)
c01023d5:	e8 a1 01 00 00       	call   c010257b <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01023da:	8b 45 08             	mov    0x8(%ebp),%eax
c01023dd:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01023e1:	0f b7 c0             	movzwl %ax,%eax
c01023e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e8:	c7 04 24 84 a5 10 c0 	movl   $0xc010a584,(%esp)
c01023ef:	e8 6b df ff ff       	call   c010035f <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01023f4:	8b 45 08             	mov    0x8(%ebp),%eax
c01023f7:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01023fb:	0f b7 c0             	movzwl %ax,%eax
c01023fe:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102402:	c7 04 24 97 a5 10 c0 	movl   $0xc010a597,(%esp)
c0102409:	e8 51 df ff ff       	call   c010035f <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c010240e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102411:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c0102415:	0f b7 c0             	movzwl %ax,%eax
c0102418:	89 44 24 04          	mov    %eax,0x4(%esp)
c010241c:	c7 04 24 aa a5 10 c0 	movl   $0xc010a5aa,(%esp)
c0102423:	e8 37 df ff ff       	call   c010035f <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102428:	8b 45 08             	mov    0x8(%ebp),%eax
c010242b:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c010242f:	0f b7 c0             	movzwl %ax,%eax
c0102432:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102436:	c7 04 24 bd a5 10 c0 	movl   $0xc010a5bd,(%esp)
c010243d:	e8 1d df ff ff       	call   c010035f <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c0102442:	8b 45 08             	mov    0x8(%ebp),%eax
c0102445:	8b 40 30             	mov    0x30(%eax),%eax
c0102448:	89 04 24             	mov    %eax,(%esp)
c010244b:	e8 1f ff ff ff       	call   c010236f <trapname>
c0102450:	8b 55 08             	mov    0x8(%ebp),%edx
c0102453:	8b 52 30             	mov    0x30(%edx),%edx
c0102456:	89 44 24 08          	mov    %eax,0x8(%esp)
c010245a:	89 54 24 04          	mov    %edx,0x4(%esp)
c010245e:	c7 04 24 d0 a5 10 c0 	movl   $0xc010a5d0,(%esp)
c0102465:	e8 f5 de ff ff       	call   c010035f <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c010246a:	8b 45 08             	mov    0x8(%ebp),%eax
c010246d:	8b 40 34             	mov    0x34(%eax),%eax
c0102470:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102474:	c7 04 24 e2 a5 10 c0 	movl   $0xc010a5e2,(%esp)
c010247b:	e8 df de ff ff       	call   c010035f <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102480:	8b 45 08             	mov    0x8(%ebp),%eax
c0102483:	8b 40 38             	mov    0x38(%eax),%eax
c0102486:	89 44 24 04          	mov    %eax,0x4(%esp)
c010248a:	c7 04 24 f1 a5 10 c0 	movl   $0xc010a5f1,(%esp)
c0102491:	e8 c9 de ff ff       	call   c010035f <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c0102496:	8b 45 08             	mov    0x8(%ebp),%eax
c0102499:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010249d:	0f b7 c0             	movzwl %ax,%eax
c01024a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024a4:	c7 04 24 00 a6 10 c0 	movl   $0xc010a600,(%esp)
c01024ab:	e8 af de ff ff       	call   c010035f <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01024b0:	8b 45 08             	mov    0x8(%ebp),%eax
c01024b3:	8b 40 40             	mov    0x40(%eax),%eax
c01024b6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024ba:	c7 04 24 13 a6 10 c0 	movl   $0xc010a613,(%esp)
c01024c1:	e8 99 de ff ff       	call   c010035f <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01024c6:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01024cd:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01024d4:	eb 3e                	jmp    c0102514 <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01024d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d9:	8b 50 40             	mov    0x40(%eax),%edx
c01024dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01024df:	21 d0                	and    %edx,%eax
c01024e1:	85 c0                	test   %eax,%eax
c01024e3:	74 28                	je     c010250d <print_trapframe+0x157>
c01024e5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024e8:	8b 04 85 a0 55 12 c0 	mov    -0x3fedaa60(,%eax,4),%eax
c01024ef:	85 c0                	test   %eax,%eax
c01024f1:	74 1a                	je     c010250d <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01024f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024f6:	8b 04 85 a0 55 12 c0 	mov    -0x3fedaa60(,%eax,4),%eax
c01024fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102501:	c7 04 24 22 a6 10 c0 	movl   $0xc010a622,(%esp)
c0102508:	e8 52 de ff ff       	call   c010035f <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c010250d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102511:	d1 65 f0             	shll   -0x10(%ebp)
c0102514:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102517:	83 f8 17             	cmp    $0x17,%eax
c010251a:	76 ba                	jbe    c01024d6 <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c010251c:	8b 45 08             	mov    0x8(%ebp),%eax
c010251f:	8b 40 40             	mov    0x40(%eax),%eax
c0102522:	25 00 30 00 00       	and    $0x3000,%eax
c0102527:	c1 e8 0c             	shr    $0xc,%eax
c010252a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010252e:	c7 04 24 26 a6 10 c0 	movl   $0xc010a626,(%esp)
c0102535:	e8 25 de ff ff       	call   c010035f <cprintf>

    if (!trap_in_kernel(tf)) {
c010253a:	8b 45 08             	mov    0x8(%ebp),%eax
c010253d:	89 04 24             	mov    %eax,(%esp)
c0102540:	e8 5b fe ff ff       	call   c01023a0 <trap_in_kernel>
c0102545:	85 c0                	test   %eax,%eax
c0102547:	75 30                	jne    c0102579 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102549:	8b 45 08             	mov    0x8(%ebp),%eax
c010254c:	8b 40 44             	mov    0x44(%eax),%eax
c010254f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102553:	c7 04 24 2f a6 10 c0 	movl   $0xc010a62f,(%esp)
c010255a:	e8 00 de ff ff       	call   c010035f <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c010255f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102562:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c0102566:	0f b7 c0             	movzwl %ax,%eax
c0102569:	89 44 24 04          	mov    %eax,0x4(%esp)
c010256d:	c7 04 24 3e a6 10 c0 	movl   $0xc010a63e,(%esp)
c0102574:	e8 e6 dd ff ff       	call   c010035f <cprintf>
    }
}
c0102579:	c9                   	leave  
c010257a:	c3                   	ret    

c010257b <print_regs>:

void
print_regs(struct pushregs *regs) {
c010257b:	55                   	push   %ebp
c010257c:	89 e5                	mov    %esp,%ebp
c010257e:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102581:	8b 45 08             	mov    0x8(%ebp),%eax
c0102584:	8b 00                	mov    (%eax),%eax
c0102586:	89 44 24 04          	mov    %eax,0x4(%esp)
c010258a:	c7 04 24 51 a6 10 c0 	movl   $0xc010a651,(%esp)
c0102591:	e8 c9 dd ff ff       	call   c010035f <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c0102596:	8b 45 08             	mov    0x8(%ebp),%eax
c0102599:	8b 40 04             	mov    0x4(%eax),%eax
c010259c:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025a0:	c7 04 24 60 a6 10 c0 	movl   $0xc010a660,(%esp)
c01025a7:	e8 b3 dd ff ff       	call   c010035f <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01025ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01025af:	8b 40 08             	mov    0x8(%eax),%eax
c01025b2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025b6:	c7 04 24 6f a6 10 c0 	movl   $0xc010a66f,(%esp)
c01025bd:	e8 9d dd ff ff       	call   c010035f <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01025c2:	8b 45 08             	mov    0x8(%ebp),%eax
c01025c5:	8b 40 0c             	mov    0xc(%eax),%eax
c01025c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025cc:	c7 04 24 7e a6 10 c0 	movl   $0xc010a67e,(%esp)
c01025d3:	e8 87 dd ff ff       	call   c010035f <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01025d8:	8b 45 08             	mov    0x8(%ebp),%eax
c01025db:	8b 40 10             	mov    0x10(%eax),%eax
c01025de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025e2:	c7 04 24 8d a6 10 c0 	movl   $0xc010a68d,(%esp)
c01025e9:	e8 71 dd ff ff       	call   c010035f <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01025ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01025f1:	8b 40 14             	mov    0x14(%eax),%eax
c01025f4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025f8:	c7 04 24 9c a6 10 c0 	movl   $0xc010a69c,(%esp)
c01025ff:	e8 5b dd ff ff       	call   c010035f <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c0102604:	8b 45 08             	mov    0x8(%ebp),%eax
c0102607:	8b 40 18             	mov    0x18(%eax),%eax
c010260a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010260e:	c7 04 24 ab a6 10 c0 	movl   $0xc010a6ab,(%esp)
c0102615:	e8 45 dd ff ff       	call   c010035f <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c010261a:	8b 45 08             	mov    0x8(%ebp),%eax
c010261d:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102620:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102624:	c7 04 24 ba a6 10 c0 	movl   $0xc010a6ba,(%esp)
c010262b:	e8 2f dd ff ff       	call   c010035f <cprintf>
}
c0102630:	c9                   	leave  
c0102631:	c3                   	ret    

c0102632 <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c0102632:	55                   	push   %ebp
c0102633:	89 e5                	mov    %esp,%ebp
c0102635:	53                   	push   %ebx
c0102636:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102639:	8b 45 08             	mov    0x8(%ebp),%eax
c010263c:	8b 40 34             	mov    0x34(%eax),%eax
c010263f:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102642:	84 c0                	test   %al,%al
c0102644:	74 07                	je     c010264d <print_pgfault+0x1b>
c0102646:	b9 c9 a6 10 c0       	mov    $0xc010a6c9,%ecx
c010264b:	eb 05                	jmp    c0102652 <print_pgfault+0x20>
c010264d:	b9 da a6 10 c0       	mov    $0xc010a6da,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c0102652:	8b 45 08             	mov    0x8(%ebp),%eax
c0102655:	8b 40 34             	mov    0x34(%eax),%eax
c0102658:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010265b:	85 c0                	test   %eax,%eax
c010265d:	74 07                	je     c0102666 <print_pgfault+0x34>
c010265f:	ba 57 00 00 00       	mov    $0x57,%edx
c0102664:	eb 05                	jmp    c010266b <print_pgfault+0x39>
c0102666:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c010266b:	8b 45 08             	mov    0x8(%ebp),%eax
c010266e:	8b 40 34             	mov    0x34(%eax),%eax
c0102671:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102674:	85 c0                	test   %eax,%eax
c0102676:	74 07                	je     c010267f <print_pgfault+0x4d>
c0102678:	b8 55 00 00 00       	mov    $0x55,%eax
c010267d:	eb 05                	jmp    c0102684 <print_pgfault+0x52>
c010267f:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c0102684:	0f 20 d3             	mov    %cr2,%ebx
c0102687:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c010268a:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c010268d:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102691:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0102695:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102699:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010269d:	c7 04 24 e8 a6 10 c0 	movl   $0xc010a6e8,(%esp)
c01026a4:	e8 b6 dc ff ff       	call   c010035f <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01026a9:	83 c4 34             	add    $0x34,%esp
c01026ac:	5b                   	pop    %ebx
c01026ad:	5d                   	pop    %ebp
c01026ae:	c3                   	ret    

c01026af <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01026af:	55                   	push   %ebp
c01026b0:	89 e5                	mov    %esp,%ebp
c01026b2:	53                   	push   %ebx
c01026b3:	83 ec 24             	sub    $0x24,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01026b6:	8b 45 08             	mov    0x8(%ebp),%eax
c01026b9:	89 04 24             	mov    %eax,(%esp)
c01026bc:	e8 71 ff ff ff       	call   c0102632 <print_pgfault>
    if (check_mm_struct != NULL) {
c01026c1:	a1 0c 8c 12 c0       	mov    0xc0128c0c,%eax
c01026c6:	85 c0                	test   %eax,%eax
c01026c8:	74 2c                	je     c01026f6 <pgfault_handler+0x47>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01026ca:	0f 20 d3             	mov    %cr2,%ebx
c01026cd:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01026d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01026d3:	89 c1                	mov    %eax,%ecx
c01026d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01026d8:	8b 50 34             	mov    0x34(%eax),%edx
c01026db:	a1 0c 8c 12 c0       	mov    0xc0128c0c,%eax
c01026e0:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01026e4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01026e8:	89 04 24             	mov    %eax,(%esp)
c01026eb:	e8 92 5c 00 00       	call   c0108382 <do_pgfault>
    }
    panic("unhandled page fault.\n");
}
c01026f0:	83 c4 24             	add    $0x24,%esp
c01026f3:	5b                   	pop    %ebx
c01026f4:	5d                   	pop    %ebp
c01026f5:	c3                   	ret    
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
    }
    panic("unhandled page fault.\n");
c01026f6:	c7 44 24 08 0b a7 10 	movl   $0xc010a70b,0x8(%esp)
c01026fd:	c0 
c01026fe:	c7 44 24 04 a7 00 00 	movl   $0xa7,0x4(%esp)
c0102705:	00 
c0102706:	c7 04 24 0e a5 10 c0 	movl   $0xc010a50e,(%esp)
c010270d:	e8 ae e5 ff ff       	call   c0100cc0 <__panic>

c0102712 <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c0102712:	55                   	push   %ebp
c0102713:	89 e5                	mov    %esp,%ebp
c0102715:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102718:	8b 45 08             	mov    0x8(%ebp),%eax
c010271b:	8b 40 30             	mov    0x30(%eax),%eax
c010271e:	83 f8 24             	cmp    $0x24,%eax
c0102721:	0f 84 c2 00 00 00    	je     c01027e9 <trap_dispatch+0xd7>
c0102727:	83 f8 24             	cmp    $0x24,%eax
c010272a:	77 18                	ja     c0102744 <trap_dispatch+0x32>
c010272c:	83 f8 20             	cmp    $0x20,%eax
c010272f:	74 7c                	je     c01027ad <trap_dispatch+0x9b>
c0102731:	83 f8 21             	cmp    $0x21,%eax
c0102734:	0f 84 d8 00 00 00    	je     c0102812 <trap_dispatch+0x100>
c010273a:	83 f8 0e             	cmp    $0xe,%eax
c010273d:	74 28                	je     c0102767 <trap_dispatch+0x55>
c010273f:	e9 10 01 00 00       	jmp    c0102854 <trap_dispatch+0x142>
c0102744:	83 f8 2e             	cmp    $0x2e,%eax
c0102747:	0f 82 07 01 00 00    	jb     c0102854 <trap_dispatch+0x142>
c010274d:	83 f8 2f             	cmp    $0x2f,%eax
c0102750:	0f 86 36 01 00 00    	jbe    c010288c <trap_dispatch+0x17a>
c0102756:	83 e8 78             	sub    $0x78,%eax
c0102759:	83 f8 01             	cmp    $0x1,%eax
c010275c:	0f 87 f2 00 00 00    	ja     c0102854 <trap_dispatch+0x142>
c0102762:	e9 d1 00 00 00       	jmp    c0102838 <trap_dispatch+0x126>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c0102767:	8b 45 08             	mov    0x8(%ebp),%eax
c010276a:	89 04 24             	mov    %eax,(%esp)
c010276d:	e8 3d ff ff ff       	call   c01026af <pgfault_handler>
c0102772:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0102775:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102779:	0f 84 10 01 00 00    	je     c010288f <trap_dispatch+0x17d>
            print_trapframe(tf);
c010277f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102782:	89 04 24             	mov    %eax,(%esp)
c0102785:	e8 2c fc ff ff       	call   c01023b6 <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c010278a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010278d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102791:	c7 44 24 08 22 a7 10 	movl   $0xc010a722,0x8(%esp)
c0102798:	c0 
c0102799:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c01027a0:	00 
c01027a1:	c7 04 24 0e a5 10 c0 	movl   $0xc010a50e,(%esp)
c01027a8:	e8 13 e5 ff ff       	call   c0100cc0 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c01027ad:	a1 14 8b 12 c0       	mov    0xc0128b14,%eax
c01027b2:	83 c0 01             	add    $0x1,%eax
c01027b5:	a3 14 8b 12 c0       	mov    %eax,0xc0128b14
        if (ticks % TICK_NUM == 0) {
c01027ba:	8b 0d 14 8b 12 c0    	mov    0xc0128b14,%ecx
c01027c0:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01027c5:	89 c8                	mov    %ecx,%eax
c01027c7:	f7 e2                	mul    %edx
c01027c9:	89 d0                	mov    %edx,%eax
c01027cb:	c1 e8 05             	shr    $0x5,%eax
c01027ce:	6b c0 64             	imul   $0x64,%eax,%eax
c01027d1:	89 ca                	mov    %ecx,%edx
c01027d3:	29 c2                	sub    %eax,%edx
c01027d5:	89 d0                	mov    %edx,%eax
c01027d7:	85 c0                	test   %eax,%eax
c01027d9:	0f 85 b3 00 00 00    	jne    c0102892 <trap_dispatch+0x180>
            print_ticks();
c01027df:	e8 d8 f9 ff ff       	call   c01021bc <print_ticks>
        } 
        break;
c01027e4:	e9 a9 00 00 00       	jmp    c0102892 <trap_dispatch+0x180>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01027e9:	e8 ee ee ff ff       	call   c01016dc <cons_getc>
c01027ee:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01027f1:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01027f5:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01027f9:	89 54 24 08          	mov    %edx,0x8(%esp)
c01027fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102801:	c7 04 24 3d a7 10 c0 	movl   $0xc010a73d,(%esp)
c0102808:	e8 52 db ff ff       	call   c010035f <cprintf>
        break;
c010280d:	e9 81 00 00 00       	jmp    c0102893 <trap_dispatch+0x181>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c0102812:	e8 c5 ee ff ff       	call   c01016dc <cons_getc>
c0102817:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c010281a:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c010281e:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c0102822:	89 54 24 08          	mov    %edx,0x8(%esp)
c0102826:	89 44 24 04          	mov    %eax,0x4(%esp)
c010282a:	c7 04 24 4f a7 10 c0 	movl   $0xc010a74f,(%esp)
c0102831:	e8 29 db ff ff       	call   c010035f <cprintf>
        break;
c0102836:	eb 5b                	jmp    c0102893 <trap_dispatch+0x181>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102838:	c7 44 24 08 5e a7 10 	movl   $0xc010a75e,0x8(%esp)
c010283f:	c0 
c0102840:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0102847:	00 
c0102848:	c7 04 24 0e a5 10 c0 	movl   $0xc010a50e,(%esp)
c010284f:	e8 6c e4 ff ff       	call   c0100cc0 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c0102854:	8b 45 08             	mov    0x8(%ebp),%eax
c0102857:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c010285b:	0f b7 c0             	movzwl %ax,%eax
c010285e:	83 e0 03             	and    $0x3,%eax
c0102861:	85 c0                	test   %eax,%eax
c0102863:	75 2e                	jne    c0102893 <trap_dispatch+0x181>
            print_trapframe(tf);
c0102865:	8b 45 08             	mov    0x8(%ebp),%eax
c0102868:	89 04 24             	mov    %eax,(%esp)
c010286b:	e8 46 fb ff ff       	call   c01023b6 <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102870:	c7 44 24 08 6e a7 10 	movl   $0xc010a76e,0x8(%esp)
c0102877:	c0 
c0102878:	c7 44 24 04 df 00 00 	movl   $0xdf,0x4(%esp)
c010287f:	00 
c0102880:	c7 04 24 0e a5 10 c0 	movl   $0xc010a50e,(%esp)
c0102887:	e8 34 e4 ff ff       	call   c0100cc0 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c010288c:	90                   	nop
c010288d:	eb 04                	jmp    c0102893 <trap_dispatch+0x181>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle pgfault failed. %e\n", ret);
        }
        break;
c010288f:	90                   	nop
c0102890:	eb 01                	jmp    c0102893 <trap_dispatch+0x181>
         */
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        } 
        break;
c0102892:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c0102893:	c9                   	leave  
c0102894:	c3                   	ret    

c0102895 <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c0102895:	55                   	push   %ebp
c0102896:	89 e5                	mov    %esp,%ebp
c0102898:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c010289b:	8b 45 08             	mov    0x8(%ebp),%eax
c010289e:	89 04 24             	mov    %eax,(%esp)
c01028a1:	e8 6c fe ff ff       	call   c0102712 <trap_dispatch>
}
c01028a6:	c9                   	leave  
c01028a7:	c3                   	ret    

c01028a8 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01028a8:	1e                   	push   %ds
    pushl %es
c01028a9:	06                   	push   %es
    pushl %fs
c01028aa:	0f a0                	push   %fs
    pushl %gs
c01028ac:	0f a8                	push   %gs
    pushal
c01028ae:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01028af:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01028b4:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01028b6:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01028b8:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01028b9:	e8 d7 ff ff ff       	call   c0102895 <trap>

    # pop the pushed stack pointer
    popl %esp
c01028be:	5c                   	pop    %esp

c01028bf <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01028bf:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01028c0:	0f a9                	pop    %gs
    popl %fs
c01028c2:	0f a1                	pop    %fs
    popl %es
c01028c4:	07                   	pop    %es
    popl %ds
c01028c5:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01028c6:	83 c4 08             	add    $0x8,%esp
    iret
c01028c9:	cf                   	iret   

c01028ca <forkrets>:

.globl forkrets
forkrets:
    # set stack to this new process's trapframe
    movl 4(%esp), %esp
c01028ca:	8b 64 24 04          	mov    0x4(%esp),%esp
    jmp __trapret
c01028ce:	e9 ec ff ff ff       	jmp    c01028bf <__trapret>
	...

c01028d4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01028d4:	6a 00                	push   $0x0
  pushl $0
c01028d6:	6a 00                	push   $0x0
  jmp __alltraps
c01028d8:	e9 cb ff ff ff       	jmp    c01028a8 <__alltraps>

c01028dd <vector1>:
.globl vector1
vector1:
  pushl $0
c01028dd:	6a 00                	push   $0x0
  pushl $1
c01028df:	6a 01                	push   $0x1
  jmp __alltraps
c01028e1:	e9 c2 ff ff ff       	jmp    c01028a8 <__alltraps>

c01028e6 <vector2>:
.globl vector2
vector2:
  pushl $0
c01028e6:	6a 00                	push   $0x0
  pushl $2
c01028e8:	6a 02                	push   $0x2
  jmp __alltraps
c01028ea:	e9 b9 ff ff ff       	jmp    c01028a8 <__alltraps>

c01028ef <vector3>:
.globl vector3
vector3:
  pushl $0
c01028ef:	6a 00                	push   $0x0
  pushl $3
c01028f1:	6a 03                	push   $0x3
  jmp __alltraps
c01028f3:	e9 b0 ff ff ff       	jmp    c01028a8 <__alltraps>

c01028f8 <vector4>:
.globl vector4
vector4:
  pushl $0
c01028f8:	6a 00                	push   $0x0
  pushl $4
c01028fa:	6a 04                	push   $0x4
  jmp __alltraps
c01028fc:	e9 a7 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102901 <vector5>:
.globl vector5
vector5:
  pushl $0
c0102901:	6a 00                	push   $0x0
  pushl $5
c0102903:	6a 05                	push   $0x5
  jmp __alltraps
c0102905:	e9 9e ff ff ff       	jmp    c01028a8 <__alltraps>

c010290a <vector6>:
.globl vector6
vector6:
  pushl $0
c010290a:	6a 00                	push   $0x0
  pushl $6
c010290c:	6a 06                	push   $0x6
  jmp __alltraps
c010290e:	e9 95 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102913 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102913:	6a 00                	push   $0x0
  pushl $7
c0102915:	6a 07                	push   $0x7
  jmp __alltraps
c0102917:	e9 8c ff ff ff       	jmp    c01028a8 <__alltraps>

c010291c <vector8>:
.globl vector8
vector8:
  pushl $8
c010291c:	6a 08                	push   $0x8
  jmp __alltraps
c010291e:	e9 85 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102923 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102923:	6a 09                	push   $0x9
  jmp __alltraps
c0102925:	e9 7e ff ff ff       	jmp    c01028a8 <__alltraps>

c010292a <vector10>:
.globl vector10
vector10:
  pushl $10
c010292a:	6a 0a                	push   $0xa
  jmp __alltraps
c010292c:	e9 77 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102931 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102931:	6a 0b                	push   $0xb
  jmp __alltraps
c0102933:	e9 70 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102938 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102938:	6a 0c                	push   $0xc
  jmp __alltraps
c010293a:	e9 69 ff ff ff       	jmp    c01028a8 <__alltraps>

c010293f <vector13>:
.globl vector13
vector13:
  pushl $13
c010293f:	6a 0d                	push   $0xd
  jmp __alltraps
c0102941:	e9 62 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102946 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102946:	6a 0e                	push   $0xe
  jmp __alltraps
c0102948:	e9 5b ff ff ff       	jmp    c01028a8 <__alltraps>

c010294d <vector15>:
.globl vector15
vector15:
  pushl $0
c010294d:	6a 00                	push   $0x0
  pushl $15
c010294f:	6a 0f                	push   $0xf
  jmp __alltraps
c0102951:	e9 52 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102956 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102956:	6a 00                	push   $0x0
  pushl $16
c0102958:	6a 10                	push   $0x10
  jmp __alltraps
c010295a:	e9 49 ff ff ff       	jmp    c01028a8 <__alltraps>

c010295f <vector17>:
.globl vector17
vector17:
  pushl $17
c010295f:	6a 11                	push   $0x11
  jmp __alltraps
c0102961:	e9 42 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102966 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102966:	6a 00                	push   $0x0
  pushl $18
c0102968:	6a 12                	push   $0x12
  jmp __alltraps
c010296a:	e9 39 ff ff ff       	jmp    c01028a8 <__alltraps>

c010296f <vector19>:
.globl vector19
vector19:
  pushl $0
c010296f:	6a 00                	push   $0x0
  pushl $19
c0102971:	6a 13                	push   $0x13
  jmp __alltraps
c0102973:	e9 30 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102978 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102978:	6a 00                	push   $0x0
  pushl $20
c010297a:	6a 14                	push   $0x14
  jmp __alltraps
c010297c:	e9 27 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102981 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102981:	6a 00                	push   $0x0
  pushl $21
c0102983:	6a 15                	push   $0x15
  jmp __alltraps
c0102985:	e9 1e ff ff ff       	jmp    c01028a8 <__alltraps>

c010298a <vector22>:
.globl vector22
vector22:
  pushl $0
c010298a:	6a 00                	push   $0x0
  pushl $22
c010298c:	6a 16                	push   $0x16
  jmp __alltraps
c010298e:	e9 15 ff ff ff       	jmp    c01028a8 <__alltraps>

c0102993 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102993:	6a 00                	push   $0x0
  pushl $23
c0102995:	6a 17                	push   $0x17
  jmp __alltraps
c0102997:	e9 0c ff ff ff       	jmp    c01028a8 <__alltraps>

c010299c <vector24>:
.globl vector24
vector24:
  pushl $0
c010299c:	6a 00                	push   $0x0
  pushl $24
c010299e:	6a 18                	push   $0x18
  jmp __alltraps
c01029a0:	e9 03 ff ff ff       	jmp    c01028a8 <__alltraps>

c01029a5 <vector25>:
.globl vector25
vector25:
  pushl $0
c01029a5:	6a 00                	push   $0x0
  pushl $25
c01029a7:	6a 19                	push   $0x19
  jmp __alltraps
c01029a9:	e9 fa fe ff ff       	jmp    c01028a8 <__alltraps>

c01029ae <vector26>:
.globl vector26
vector26:
  pushl $0
c01029ae:	6a 00                	push   $0x0
  pushl $26
c01029b0:	6a 1a                	push   $0x1a
  jmp __alltraps
c01029b2:	e9 f1 fe ff ff       	jmp    c01028a8 <__alltraps>

c01029b7 <vector27>:
.globl vector27
vector27:
  pushl $0
c01029b7:	6a 00                	push   $0x0
  pushl $27
c01029b9:	6a 1b                	push   $0x1b
  jmp __alltraps
c01029bb:	e9 e8 fe ff ff       	jmp    c01028a8 <__alltraps>

c01029c0 <vector28>:
.globl vector28
vector28:
  pushl $0
c01029c0:	6a 00                	push   $0x0
  pushl $28
c01029c2:	6a 1c                	push   $0x1c
  jmp __alltraps
c01029c4:	e9 df fe ff ff       	jmp    c01028a8 <__alltraps>

c01029c9 <vector29>:
.globl vector29
vector29:
  pushl $0
c01029c9:	6a 00                	push   $0x0
  pushl $29
c01029cb:	6a 1d                	push   $0x1d
  jmp __alltraps
c01029cd:	e9 d6 fe ff ff       	jmp    c01028a8 <__alltraps>

c01029d2 <vector30>:
.globl vector30
vector30:
  pushl $0
c01029d2:	6a 00                	push   $0x0
  pushl $30
c01029d4:	6a 1e                	push   $0x1e
  jmp __alltraps
c01029d6:	e9 cd fe ff ff       	jmp    c01028a8 <__alltraps>

c01029db <vector31>:
.globl vector31
vector31:
  pushl $0
c01029db:	6a 00                	push   $0x0
  pushl $31
c01029dd:	6a 1f                	push   $0x1f
  jmp __alltraps
c01029df:	e9 c4 fe ff ff       	jmp    c01028a8 <__alltraps>

c01029e4 <vector32>:
.globl vector32
vector32:
  pushl $0
c01029e4:	6a 00                	push   $0x0
  pushl $32
c01029e6:	6a 20                	push   $0x20
  jmp __alltraps
c01029e8:	e9 bb fe ff ff       	jmp    c01028a8 <__alltraps>

c01029ed <vector33>:
.globl vector33
vector33:
  pushl $0
c01029ed:	6a 00                	push   $0x0
  pushl $33
c01029ef:	6a 21                	push   $0x21
  jmp __alltraps
c01029f1:	e9 b2 fe ff ff       	jmp    c01028a8 <__alltraps>

c01029f6 <vector34>:
.globl vector34
vector34:
  pushl $0
c01029f6:	6a 00                	push   $0x0
  pushl $34
c01029f8:	6a 22                	push   $0x22
  jmp __alltraps
c01029fa:	e9 a9 fe ff ff       	jmp    c01028a8 <__alltraps>

c01029ff <vector35>:
.globl vector35
vector35:
  pushl $0
c01029ff:	6a 00                	push   $0x0
  pushl $35
c0102a01:	6a 23                	push   $0x23
  jmp __alltraps
c0102a03:	e9 a0 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a08 <vector36>:
.globl vector36
vector36:
  pushl $0
c0102a08:	6a 00                	push   $0x0
  pushl $36
c0102a0a:	6a 24                	push   $0x24
  jmp __alltraps
c0102a0c:	e9 97 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a11 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102a11:	6a 00                	push   $0x0
  pushl $37
c0102a13:	6a 25                	push   $0x25
  jmp __alltraps
c0102a15:	e9 8e fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a1a <vector38>:
.globl vector38
vector38:
  pushl $0
c0102a1a:	6a 00                	push   $0x0
  pushl $38
c0102a1c:	6a 26                	push   $0x26
  jmp __alltraps
c0102a1e:	e9 85 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a23 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102a23:	6a 00                	push   $0x0
  pushl $39
c0102a25:	6a 27                	push   $0x27
  jmp __alltraps
c0102a27:	e9 7c fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a2c <vector40>:
.globl vector40
vector40:
  pushl $0
c0102a2c:	6a 00                	push   $0x0
  pushl $40
c0102a2e:	6a 28                	push   $0x28
  jmp __alltraps
c0102a30:	e9 73 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a35 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102a35:	6a 00                	push   $0x0
  pushl $41
c0102a37:	6a 29                	push   $0x29
  jmp __alltraps
c0102a39:	e9 6a fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a3e <vector42>:
.globl vector42
vector42:
  pushl $0
c0102a3e:	6a 00                	push   $0x0
  pushl $42
c0102a40:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102a42:	e9 61 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a47 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102a47:	6a 00                	push   $0x0
  pushl $43
c0102a49:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102a4b:	e9 58 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a50 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102a50:	6a 00                	push   $0x0
  pushl $44
c0102a52:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102a54:	e9 4f fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a59 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102a59:	6a 00                	push   $0x0
  pushl $45
c0102a5b:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102a5d:	e9 46 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a62 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102a62:	6a 00                	push   $0x0
  pushl $46
c0102a64:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102a66:	e9 3d fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a6b <vector47>:
.globl vector47
vector47:
  pushl $0
c0102a6b:	6a 00                	push   $0x0
  pushl $47
c0102a6d:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102a6f:	e9 34 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a74 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102a74:	6a 00                	push   $0x0
  pushl $48
c0102a76:	6a 30                	push   $0x30
  jmp __alltraps
c0102a78:	e9 2b fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a7d <vector49>:
.globl vector49
vector49:
  pushl $0
c0102a7d:	6a 00                	push   $0x0
  pushl $49
c0102a7f:	6a 31                	push   $0x31
  jmp __alltraps
c0102a81:	e9 22 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a86 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102a86:	6a 00                	push   $0x0
  pushl $50
c0102a88:	6a 32                	push   $0x32
  jmp __alltraps
c0102a8a:	e9 19 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a8f <vector51>:
.globl vector51
vector51:
  pushl $0
c0102a8f:	6a 00                	push   $0x0
  pushl $51
c0102a91:	6a 33                	push   $0x33
  jmp __alltraps
c0102a93:	e9 10 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102a98 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102a98:	6a 00                	push   $0x0
  pushl $52
c0102a9a:	6a 34                	push   $0x34
  jmp __alltraps
c0102a9c:	e9 07 fe ff ff       	jmp    c01028a8 <__alltraps>

c0102aa1 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102aa1:	6a 00                	push   $0x0
  pushl $53
c0102aa3:	6a 35                	push   $0x35
  jmp __alltraps
c0102aa5:	e9 fe fd ff ff       	jmp    c01028a8 <__alltraps>

c0102aaa <vector54>:
.globl vector54
vector54:
  pushl $0
c0102aaa:	6a 00                	push   $0x0
  pushl $54
c0102aac:	6a 36                	push   $0x36
  jmp __alltraps
c0102aae:	e9 f5 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102ab3 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102ab3:	6a 00                	push   $0x0
  pushl $55
c0102ab5:	6a 37                	push   $0x37
  jmp __alltraps
c0102ab7:	e9 ec fd ff ff       	jmp    c01028a8 <__alltraps>

c0102abc <vector56>:
.globl vector56
vector56:
  pushl $0
c0102abc:	6a 00                	push   $0x0
  pushl $56
c0102abe:	6a 38                	push   $0x38
  jmp __alltraps
c0102ac0:	e9 e3 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102ac5 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102ac5:	6a 00                	push   $0x0
  pushl $57
c0102ac7:	6a 39                	push   $0x39
  jmp __alltraps
c0102ac9:	e9 da fd ff ff       	jmp    c01028a8 <__alltraps>

c0102ace <vector58>:
.globl vector58
vector58:
  pushl $0
c0102ace:	6a 00                	push   $0x0
  pushl $58
c0102ad0:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102ad2:	e9 d1 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102ad7 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102ad7:	6a 00                	push   $0x0
  pushl $59
c0102ad9:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102adb:	e9 c8 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102ae0 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102ae0:	6a 00                	push   $0x0
  pushl $60
c0102ae2:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102ae4:	e9 bf fd ff ff       	jmp    c01028a8 <__alltraps>

c0102ae9 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102ae9:	6a 00                	push   $0x0
  pushl $61
c0102aeb:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102aed:	e9 b6 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102af2 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102af2:	6a 00                	push   $0x0
  pushl $62
c0102af4:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102af6:	e9 ad fd ff ff       	jmp    c01028a8 <__alltraps>

c0102afb <vector63>:
.globl vector63
vector63:
  pushl $0
c0102afb:	6a 00                	push   $0x0
  pushl $63
c0102afd:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102aff:	e9 a4 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b04 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102b04:	6a 00                	push   $0x0
  pushl $64
c0102b06:	6a 40                	push   $0x40
  jmp __alltraps
c0102b08:	e9 9b fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b0d <vector65>:
.globl vector65
vector65:
  pushl $0
c0102b0d:	6a 00                	push   $0x0
  pushl $65
c0102b0f:	6a 41                	push   $0x41
  jmp __alltraps
c0102b11:	e9 92 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b16 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102b16:	6a 00                	push   $0x0
  pushl $66
c0102b18:	6a 42                	push   $0x42
  jmp __alltraps
c0102b1a:	e9 89 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b1f <vector67>:
.globl vector67
vector67:
  pushl $0
c0102b1f:	6a 00                	push   $0x0
  pushl $67
c0102b21:	6a 43                	push   $0x43
  jmp __alltraps
c0102b23:	e9 80 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b28 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102b28:	6a 00                	push   $0x0
  pushl $68
c0102b2a:	6a 44                	push   $0x44
  jmp __alltraps
c0102b2c:	e9 77 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b31 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102b31:	6a 00                	push   $0x0
  pushl $69
c0102b33:	6a 45                	push   $0x45
  jmp __alltraps
c0102b35:	e9 6e fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b3a <vector70>:
.globl vector70
vector70:
  pushl $0
c0102b3a:	6a 00                	push   $0x0
  pushl $70
c0102b3c:	6a 46                	push   $0x46
  jmp __alltraps
c0102b3e:	e9 65 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b43 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102b43:	6a 00                	push   $0x0
  pushl $71
c0102b45:	6a 47                	push   $0x47
  jmp __alltraps
c0102b47:	e9 5c fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b4c <vector72>:
.globl vector72
vector72:
  pushl $0
c0102b4c:	6a 00                	push   $0x0
  pushl $72
c0102b4e:	6a 48                	push   $0x48
  jmp __alltraps
c0102b50:	e9 53 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b55 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102b55:	6a 00                	push   $0x0
  pushl $73
c0102b57:	6a 49                	push   $0x49
  jmp __alltraps
c0102b59:	e9 4a fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b5e <vector74>:
.globl vector74
vector74:
  pushl $0
c0102b5e:	6a 00                	push   $0x0
  pushl $74
c0102b60:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102b62:	e9 41 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b67 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102b67:	6a 00                	push   $0x0
  pushl $75
c0102b69:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102b6b:	e9 38 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b70 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102b70:	6a 00                	push   $0x0
  pushl $76
c0102b72:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102b74:	e9 2f fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b79 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102b79:	6a 00                	push   $0x0
  pushl $77
c0102b7b:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102b7d:	e9 26 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b82 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102b82:	6a 00                	push   $0x0
  pushl $78
c0102b84:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102b86:	e9 1d fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b8b <vector79>:
.globl vector79
vector79:
  pushl $0
c0102b8b:	6a 00                	push   $0x0
  pushl $79
c0102b8d:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102b8f:	e9 14 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b94 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102b94:	6a 00                	push   $0x0
  pushl $80
c0102b96:	6a 50                	push   $0x50
  jmp __alltraps
c0102b98:	e9 0b fd ff ff       	jmp    c01028a8 <__alltraps>

c0102b9d <vector81>:
.globl vector81
vector81:
  pushl $0
c0102b9d:	6a 00                	push   $0x0
  pushl $81
c0102b9f:	6a 51                	push   $0x51
  jmp __alltraps
c0102ba1:	e9 02 fd ff ff       	jmp    c01028a8 <__alltraps>

c0102ba6 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102ba6:	6a 00                	push   $0x0
  pushl $82
c0102ba8:	6a 52                	push   $0x52
  jmp __alltraps
c0102baa:	e9 f9 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102baf <vector83>:
.globl vector83
vector83:
  pushl $0
c0102baf:	6a 00                	push   $0x0
  pushl $83
c0102bb1:	6a 53                	push   $0x53
  jmp __alltraps
c0102bb3:	e9 f0 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102bb8 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102bb8:	6a 00                	push   $0x0
  pushl $84
c0102bba:	6a 54                	push   $0x54
  jmp __alltraps
c0102bbc:	e9 e7 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102bc1 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102bc1:	6a 00                	push   $0x0
  pushl $85
c0102bc3:	6a 55                	push   $0x55
  jmp __alltraps
c0102bc5:	e9 de fc ff ff       	jmp    c01028a8 <__alltraps>

c0102bca <vector86>:
.globl vector86
vector86:
  pushl $0
c0102bca:	6a 00                	push   $0x0
  pushl $86
c0102bcc:	6a 56                	push   $0x56
  jmp __alltraps
c0102bce:	e9 d5 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102bd3 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102bd3:	6a 00                	push   $0x0
  pushl $87
c0102bd5:	6a 57                	push   $0x57
  jmp __alltraps
c0102bd7:	e9 cc fc ff ff       	jmp    c01028a8 <__alltraps>

c0102bdc <vector88>:
.globl vector88
vector88:
  pushl $0
c0102bdc:	6a 00                	push   $0x0
  pushl $88
c0102bde:	6a 58                	push   $0x58
  jmp __alltraps
c0102be0:	e9 c3 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102be5 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102be5:	6a 00                	push   $0x0
  pushl $89
c0102be7:	6a 59                	push   $0x59
  jmp __alltraps
c0102be9:	e9 ba fc ff ff       	jmp    c01028a8 <__alltraps>

c0102bee <vector90>:
.globl vector90
vector90:
  pushl $0
c0102bee:	6a 00                	push   $0x0
  pushl $90
c0102bf0:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102bf2:	e9 b1 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102bf7 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102bf7:	6a 00                	push   $0x0
  pushl $91
c0102bf9:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102bfb:	e9 a8 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c00 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102c00:	6a 00                	push   $0x0
  pushl $92
c0102c02:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102c04:	e9 9f fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c09 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102c09:	6a 00                	push   $0x0
  pushl $93
c0102c0b:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102c0d:	e9 96 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c12 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102c12:	6a 00                	push   $0x0
  pushl $94
c0102c14:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102c16:	e9 8d fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c1b <vector95>:
.globl vector95
vector95:
  pushl $0
c0102c1b:	6a 00                	push   $0x0
  pushl $95
c0102c1d:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102c1f:	e9 84 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c24 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102c24:	6a 00                	push   $0x0
  pushl $96
c0102c26:	6a 60                	push   $0x60
  jmp __alltraps
c0102c28:	e9 7b fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c2d <vector97>:
.globl vector97
vector97:
  pushl $0
c0102c2d:	6a 00                	push   $0x0
  pushl $97
c0102c2f:	6a 61                	push   $0x61
  jmp __alltraps
c0102c31:	e9 72 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c36 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102c36:	6a 00                	push   $0x0
  pushl $98
c0102c38:	6a 62                	push   $0x62
  jmp __alltraps
c0102c3a:	e9 69 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c3f <vector99>:
.globl vector99
vector99:
  pushl $0
c0102c3f:	6a 00                	push   $0x0
  pushl $99
c0102c41:	6a 63                	push   $0x63
  jmp __alltraps
c0102c43:	e9 60 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c48 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102c48:	6a 00                	push   $0x0
  pushl $100
c0102c4a:	6a 64                	push   $0x64
  jmp __alltraps
c0102c4c:	e9 57 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c51 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102c51:	6a 00                	push   $0x0
  pushl $101
c0102c53:	6a 65                	push   $0x65
  jmp __alltraps
c0102c55:	e9 4e fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c5a <vector102>:
.globl vector102
vector102:
  pushl $0
c0102c5a:	6a 00                	push   $0x0
  pushl $102
c0102c5c:	6a 66                	push   $0x66
  jmp __alltraps
c0102c5e:	e9 45 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c63 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102c63:	6a 00                	push   $0x0
  pushl $103
c0102c65:	6a 67                	push   $0x67
  jmp __alltraps
c0102c67:	e9 3c fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c6c <vector104>:
.globl vector104
vector104:
  pushl $0
c0102c6c:	6a 00                	push   $0x0
  pushl $104
c0102c6e:	6a 68                	push   $0x68
  jmp __alltraps
c0102c70:	e9 33 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c75 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102c75:	6a 00                	push   $0x0
  pushl $105
c0102c77:	6a 69                	push   $0x69
  jmp __alltraps
c0102c79:	e9 2a fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c7e <vector106>:
.globl vector106
vector106:
  pushl $0
c0102c7e:	6a 00                	push   $0x0
  pushl $106
c0102c80:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102c82:	e9 21 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c87 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102c87:	6a 00                	push   $0x0
  pushl $107
c0102c89:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102c8b:	e9 18 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c90 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102c90:	6a 00                	push   $0x0
  pushl $108
c0102c92:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102c94:	e9 0f fc ff ff       	jmp    c01028a8 <__alltraps>

c0102c99 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102c99:	6a 00                	push   $0x0
  pushl $109
c0102c9b:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102c9d:	e9 06 fc ff ff       	jmp    c01028a8 <__alltraps>

c0102ca2 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102ca2:	6a 00                	push   $0x0
  pushl $110
c0102ca4:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102ca6:	e9 fd fb ff ff       	jmp    c01028a8 <__alltraps>

c0102cab <vector111>:
.globl vector111
vector111:
  pushl $0
c0102cab:	6a 00                	push   $0x0
  pushl $111
c0102cad:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102caf:	e9 f4 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102cb4 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102cb4:	6a 00                	push   $0x0
  pushl $112
c0102cb6:	6a 70                	push   $0x70
  jmp __alltraps
c0102cb8:	e9 eb fb ff ff       	jmp    c01028a8 <__alltraps>

c0102cbd <vector113>:
.globl vector113
vector113:
  pushl $0
c0102cbd:	6a 00                	push   $0x0
  pushl $113
c0102cbf:	6a 71                	push   $0x71
  jmp __alltraps
c0102cc1:	e9 e2 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102cc6 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102cc6:	6a 00                	push   $0x0
  pushl $114
c0102cc8:	6a 72                	push   $0x72
  jmp __alltraps
c0102cca:	e9 d9 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102ccf <vector115>:
.globl vector115
vector115:
  pushl $0
c0102ccf:	6a 00                	push   $0x0
  pushl $115
c0102cd1:	6a 73                	push   $0x73
  jmp __alltraps
c0102cd3:	e9 d0 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102cd8 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102cd8:	6a 00                	push   $0x0
  pushl $116
c0102cda:	6a 74                	push   $0x74
  jmp __alltraps
c0102cdc:	e9 c7 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102ce1 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102ce1:	6a 00                	push   $0x0
  pushl $117
c0102ce3:	6a 75                	push   $0x75
  jmp __alltraps
c0102ce5:	e9 be fb ff ff       	jmp    c01028a8 <__alltraps>

c0102cea <vector118>:
.globl vector118
vector118:
  pushl $0
c0102cea:	6a 00                	push   $0x0
  pushl $118
c0102cec:	6a 76                	push   $0x76
  jmp __alltraps
c0102cee:	e9 b5 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102cf3 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102cf3:	6a 00                	push   $0x0
  pushl $119
c0102cf5:	6a 77                	push   $0x77
  jmp __alltraps
c0102cf7:	e9 ac fb ff ff       	jmp    c01028a8 <__alltraps>

c0102cfc <vector120>:
.globl vector120
vector120:
  pushl $0
c0102cfc:	6a 00                	push   $0x0
  pushl $120
c0102cfe:	6a 78                	push   $0x78
  jmp __alltraps
c0102d00:	e9 a3 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d05 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102d05:	6a 00                	push   $0x0
  pushl $121
c0102d07:	6a 79                	push   $0x79
  jmp __alltraps
c0102d09:	e9 9a fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d0e <vector122>:
.globl vector122
vector122:
  pushl $0
c0102d0e:	6a 00                	push   $0x0
  pushl $122
c0102d10:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102d12:	e9 91 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d17 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102d17:	6a 00                	push   $0x0
  pushl $123
c0102d19:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102d1b:	e9 88 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d20 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102d20:	6a 00                	push   $0x0
  pushl $124
c0102d22:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102d24:	e9 7f fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d29 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102d29:	6a 00                	push   $0x0
  pushl $125
c0102d2b:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102d2d:	e9 76 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d32 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102d32:	6a 00                	push   $0x0
  pushl $126
c0102d34:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102d36:	e9 6d fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d3b <vector127>:
.globl vector127
vector127:
  pushl $0
c0102d3b:	6a 00                	push   $0x0
  pushl $127
c0102d3d:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102d3f:	e9 64 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d44 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102d44:	6a 00                	push   $0x0
  pushl $128
c0102d46:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102d4b:	e9 58 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d50 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102d50:	6a 00                	push   $0x0
  pushl $129
c0102d52:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102d57:	e9 4c fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d5c <vector130>:
.globl vector130
vector130:
  pushl $0
c0102d5c:	6a 00                	push   $0x0
  pushl $130
c0102d5e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102d63:	e9 40 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d68 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102d68:	6a 00                	push   $0x0
  pushl $131
c0102d6a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102d6f:	e9 34 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d74 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102d74:	6a 00                	push   $0x0
  pushl $132
c0102d76:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102d7b:	e9 28 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d80 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102d80:	6a 00                	push   $0x0
  pushl $133
c0102d82:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102d87:	e9 1c fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d8c <vector134>:
.globl vector134
vector134:
  pushl $0
c0102d8c:	6a 00                	push   $0x0
  pushl $134
c0102d8e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102d93:	e9 10 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102d98 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102d98:	6a 00                	push   $0x0
  pushl $135
c0102d9a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102d9f:	e9 04 fb ff ff       	jmp    c01028a8 <__alltraps>

c0102da4 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102da4:	6a 00                	push   $0x0
  pushl $136
c0102da6:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102dab:	e9 f8 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102db0 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102db0:	6a 00                	push   $0x0
  pushl $137
c0102db2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102db7:	e9 ec fa ff ff       	jmp    c01028a8 <__alltraps>

c0102dbc <vector138>:
.globl vector138
vector138:
  pushl $0
c0102dbc:	6a 00                	push   $0x0
  pushl $138
c0102dbe:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102dc3:	e9 e0 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102dc8 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102dc8:	6a 00                	push   $0x0
  pushl $139
c0102dca:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102dcf:	e9 d4 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102dd4 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102dd4:	6a 00                	push   $0x0
  pushl $140
c0102dd6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102ddb:	e9 c8 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102de0 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102de0:	6a 00                	push   $0x0
  pushl $141
c0102de2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102de7:	e9 bc fa ff ff       	jmp    c01028a8 <__alltraps>

c0102dec <vector142>:
.globl vector142
vector142:
  pushl $0
c0102dec:	6a 00                	push   $0x0
  pushl $142
c0102dee:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102df3:	e9 b0 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102df8 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102df8:	6a 00                	push   $0x0
  pushl $143
c0102dfa:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102dff:	e9 a4 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e04 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102e04:	6a 00                	push   $0x0
  pushl $144
c0102e06:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102e0b:	e9 98 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e10 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102e10:	6a 00                	push   $0x0
  pushl $145
c0102e12:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102e17:	e9 8c fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e1c <vector146>:
.globl vector146
vector146:
  pushl $0
c0102e1c:	6a 00                	push   $0x0
  pushl $146
c0102e1e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102e23:	e9 80 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e28 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102e28:	6a 00                	push   $0x0
  pushl $147
c0102e2a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102e2f:	e9 74 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e34 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102e34:	6a 00                	push   $0x0
  pushl $148
c0102e36:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102e3b:	e9 68 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e40 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102e40:	6a 00                	push   $0x0
  pushl $149
c0102e42:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102e47:	e9 5c fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e4c <vector150>:
.globl vector150
vector150:
  pushl $0
c0102e4c:	6a 00                	push   $0x0
  pushl $150
c0102e4e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102e53:	e9 50 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e58 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102e58:	6a 00                	push   $0x0
  pushl $151
c0102e5a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102e5f:	e9 44 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e64 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102e64:	6a 00                	push   $0x0
  pushl $152
c0102e66:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102e6b:	e9 38 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e70 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102e70:	6a 00                	push   $0x0
  pushl $153
c0102e72:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102e77:	e9 2c fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e7c <vector154>:
.globl vector154
vector154:
  pushl $0
c0102e7c:	6a 00                	push   $0x0
  pushl $154
c0102e7e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102e83:	e9 20 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e88 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102e88:	6a 00                	push   $0x0
  pushl $155
c0102e8a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102e8f:	e9 14 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102e94 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102e94:	6a 00                	push   $0x0
  pushl $156
c0102e96:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102e9b:	e9 08 fa ff ff       	jmp    c01028a8 <__alltraps>

c0102ea0 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102ea0:	6a 00                	push   $0x0
  pushl $157
c0102ea2:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102ea7:	e9 fc f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102eac <vector158>:
.globl vector158
vector158:
  pushl $0
c0102eac:	6a 00                	push   $0x0
  pushl $158
c0102eae:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102eb3:	e9 f0 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102eb8 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102eb8:	6a 00                	push   $0x0
  pushl $159
c0102eba:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102ebf:	e9 e4 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102ec4 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102ec4:	6a 00                	push   $0x0
  pushl $160
c0102ec6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102ecb:	e9 d8 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102ed0 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102ed0:	6a 00                	push   $0x0
  pushl $161
c0102ed2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102ed7:	e9 cc f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102edc <vector162>:
.globl vector162
vector162:
  pushl $0
c0102edc:	6a 00                	push   $0x0
  pushl $162
c0102ede:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102ee3:	e9 c0 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102ee8 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102ee8:	6a 00                	push   $0x0
  pushl $163
c0102eea:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102eef:	e9 b4 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102ef4 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102ef4:	6a 00                	push   $0x0
  pushl $164
c0102ef6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102efb:	e9 a8 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f00 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102f00:	6a 00                	push   $0x0
  pushl $165
c0102f02:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102f07:	e9 9c f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f0c <vector166>:
.globl vector166
vector166:
  pushl $0
c0102f0c:	6a 00                	push   $0x0
  pushl $166
c0102f0e:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102f13:	e9 90 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f18 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102f18:	6a 00                	push   $0x0
  pushl $167
c0102f1a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102f1f:	e9 84 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f24 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102f24:	6a 00                	push   $0x0
  pushl $168
c0102f26:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102f2b:	e9 78 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f30 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102f30:	6a 00                	push   $0x0
  pushl $169
c0102f32:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102f37:	e9 6c f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f3c <vector170>:
.globl vector170
vector170:
  pushl $0
c0102f3c:	6a 00                	push   $0x0
  pushl $170
c0102f3e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102f43:	e9 60 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f48 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102f48:	6a 00                	push   $0x0
  pushl $171
c0102f4a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102f4f:	e9 54 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f54 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102f54:	6a 00                	push   $0x0
  pushl $172
c0102f56:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102f5b:	e9 48 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f60 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102f60:	6a 00                	push   $0x0
  pushl $173
c0102f62:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102f67:	e9 3c f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f6c <vector174>:
.globl vector174
vector174:
  pushl $0
c0102f6c:	6a 00                	push   $0x0
  pushl $174
c0102f6e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102f73:	e9 30 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f78 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102f78:	6a 00                	push   $0x0
  pushl $175
c0102f7a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102f7f:	e9 24 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f84 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102f84:	6a 00                	push   $0x0
  pushl $176
c0102f86:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102f8b:	e9 18 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f90 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102f90:	6a 00                	push   $0x0
  pushl $177
c0102f92:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102f97:	e9 0c f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102f9c <vector178>:
.globl vector178
vector178:
  pushl $0
c0102f9c:	6a 00                	push   $0x0
  pushl $178
c0102f9e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102fa3:	e9 00 f9 ff ff       	jmp    c01028a8 <__alltraps>

c0102fa8 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102fa8:	6a 00                	push   $0x0
  pushl $179
c0102faa:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102faf:	e9 f4 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0102fb4 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102fb4:	6a 00                	push   $0x0
  pushl $180
c0102fb6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102fbb:	e9 e8 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0102fc0 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102fc0:	6a 00                	push   $0x0
  pushl $181
c0102fc2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102fc7:	e9 dc f8 ff ff       	jmp    c01028a8 <__alltraps>

c0102fcc <vector182>:
.globl vector182
vector182:
  pushl $0
c0102fcc:	6a 00                	push   $0x0
  pushl $182
c0102fce:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102fd3:	e9 d0 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0102fd8 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102fd8:	6a 00                	push   $0x0
  pushl $183
c0102fda:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102fdf:	e9 c4 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0102fe4 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102fe4:	6a 00                	push   $0x0
  pushl $184
c0102fe6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102feb:	e9 b8 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0102ff0 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102ff0:	6a 00                	push   $0x0
  pushl $185
c0102ff2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102ff7:	e9 ac f8 ff ff       	jmp    c01028a8 <__alltraps>

c0102ffc <vector186>:
.globl vector186
vector186:
  pushl $0
c0102ffc:	6a 00                	push   $0x0
  pushl $186
c0102ffe:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0103003:	e9 a0 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103008 <vector187>:
.globl vector187
vector187:
  pushl $0
c0103008:	6a 00                	push   $0x0
  pushl $187
c010300a:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c010300f:	e9 94 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103014 <vector188>:
.globl vector188
vector188:
  pushl $0
c0103014:	6a 00                	push   $0x0
  pushl $188
c0103016:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010301b:	e9 88 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103020 <vector189>:
.globl vector189
vector189:
  pushl $0
c0103020:	6a 00                	push   $0x0
  pushl $189
c0103022:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0103027:	e9 7c f8 ff ff       	jmp    c01028a8 <__alltraps>

c010302c <vector190>:
.globl vector190
vector190:
  pushl $0
c010302c:	6a 00                	push   $0x0
  pushl $190
c010302e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0103033:	e9 70 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103038 <vector191>:
.globl vector191
vector191:
  pushl $0
c0103038:	6a 00                	push   $0x0
  pushl $191
c010303a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010303f:	e9 64 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103044 <vector192>:
.globl vector192
vector192:
  pushl $0
c0103044:	6a 00                	push   $0x0
  pushl $192
c0103046:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010304b:	e9 58 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103050 <vector193>:
.globl vector193
vector193:
  pushl $0
c0103050:	6a 00                	push   $0x0
  pushl $193
c0103052:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0103057:	e9 4c f8 ff ff       	jmp    c01028a8 <__alltraps>

c010305c <vector194>:
.globl vector194
vector194:
  pushl $0
c010305c:	6a 00                	push   $0x0
  pushl $194
c010305e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0103063:	e9 40 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103068 <vector195>:
.globl vector195
vector195:
  pushl $0
c0103068:	6a 00                	push   $0x0
  pushl $195
c010306a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010306f:	e9 34 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103074 <vector196>:
.globl vector196
vector196:
  pushl $0
c0103074:	6a 00                	push   $0x0
  pushl $196
c0103076:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010307b:	e9 28 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103080 <vector197>:
.globl vector197
vector197:
  pushl $0
c0103080:	6a 00                	push   $0x0
  pushl $197
c0103082:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0103087:	e9 1c f8 ff ff       	jmp    c01028a8 <__alltraps>

c010308c <vector198>:
.globl vector198
vector198:
  pushl $0
c010308c:	6a 00                	push   $0x0
  pushl $198
c010308e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103093:	e9 10 f8 ff ff       	jmp    c01028a8 <__alltraps>

c0103098 <vector199>:
.globl vector199
vector199:
  pushl $0
c0103098:	6a 00                	push   $0x0
  pushl $199
c010309a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010309f:	e9 04 f8 ff ff       	jmp    c01028a8 <__alltraps>

c01030a4 <vector200>:
.globl vector200
vector200:
  pushl $0
c01030a4:	6a 00                	push   $0x0
  pushl $200
c01030a6:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c01030ab:	e9 f8 f7 ff ff       	jmp    c01028a8 <__alltraps>

c01030b0 <vector201>:
.globl vector201
vector201:
  pushl $0
c01030b0:	6a 00                	push   $0x0
  pushl $201
c01030b2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01030b7:	e9 ec f7 ff ff       	jmp    c01028a8 <__alltraps>

c01030bc <vector202>:
.globl vector202
vector202:
  pushl $0
c01030bc:	6a 00                	push   $0x0
  pushl $202
c01030be:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01030c3:	e9 e0 f7 ff ff       	jmp    c01028a8 <__alltraps>

c01030c8 <vector203>:
.globl vector203
vector203:
  pushl $0
c01030c8:	6a 00                	push   $0x0
  pushl $203
c01030ca:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01030cf:	e9 d4 f7 ff ff       	jmp    c01028a8 <__alltraps>

c01030d4 <vector204>:
.globl vector204
vector204:
  pushl $0
c01030d4:	6a 00                	push   $0x0
  pushl $204
c01030d6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01030db:	e9 c8 f7 ff ff       	jmp    c01028a8 <__alltraps>

c01030e0 <vector205>:
.globl vector205
vector205:
  pushl $0
c01030e0:	6a 00                	push   $0x0
  pushl $205
c01030e2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01030e7:	e9 bc f7 ff ff       	jmp    c01028a8 <__alltraps>

c01030ec <vector206>:
.globl vector206
vector206:
  pushl $0
c01030ec:	6a 00                	push   $0x0
  pushl $206
c01030ee:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01030f3:	e9 b0 f7 ff ff       	jmp    c01028a8 <__alltraps>

c01030f8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01030f8:	6a 00                	push   $0x0
  pushl $207
c01030fa:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01030ff:	e9 a4 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103104 <vector208>:
.globl vector208
vector208:
  pushl $0
c0103104:	6a 00                	push   $0x0
  pushl $208
c0103106:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c010310b:	e9 98 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103110 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103110:	6a 00                	push   $0x0
  pushl $209
c0103112:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103117:	e9 8c f7 ff ff       	jmp    c01028a8 <__alltraps>

c010311c <vector210>:
.globl vector210
vector210:
  pushl $0
c010311c:	6a 00                	push   $0x0
  pushl $210
c010311e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103123:	e9 80 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103128 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103128:	6a 00                	push   $0x0
  pushl $211
c010312a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010312f:	e9 74 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103134 <vector212>:
.globl vector212
vector212:
  pushl $0
c0103134:	6a 00                	push   $0x0
  pushl $212
c0103136:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010313b:	e9 68 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103140 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103140:	6a 00                	push   $0x0
  pushl $213
c0103142:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103147:	e9 5c f7 ff ff       	jmp    c01028a8 <__alltraps>

c010314c <vector214>:
.globl vector214
vector214:
  pushl $0
c010314c:	6a 00                	push   $0x0
  pushl $214
c010314e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103153:	e9 50 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103158 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103158:	6a 00                	push   $0x0
  pushl $215
c010315a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010315f:	e9 44 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103164 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103164:	6a 00                	push   $0x0
  pushl $216
c0103166:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010316b:	e9 38 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103170 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103170:	6a 00                	push   $0x0
  pushl $217
c0103172:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103177:	e9 2c f7 ff ff       	jmp    c01028a8 <__alltraps>

c010317c <vector218>:
.globl vector218
vector218:
  pushl $0
c010317c:	6a 00                	push   $0x0
  pushl $218
c010317e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103183:	e9 20 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103188 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103188:	6a 00                	push   $0x0
  pushl $219
c010318a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010318f:	e9 14 f7 ff ff       	jmp    c01028a8 <__alltraps>

c0103194 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103194:	6a 00                	push   $0x0
  pushl $220
c0103196:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010319b:	e9 08 f7 ff ff       	jmp    c01028a8 <__alltraps>

c01031a0 <vector221>:
.globl vector221
vector221:
  pushl $0
c01031a0:	6a 00                	push   $0x0
  pushl $221
c01031a2:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c01031a7:	e9 fc f6 ff ff       	jmp    c01028a8 <__alltraps>

c01031ac <vector222>:
.globl vector222
vector222:
  pushl $0
c01031ac:	6a 00                	push   $0x0
  pushl $222
c01031ae:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01031b3:	e9 f0 f6 ff ff       	jmp    c01028a8 <__alltraps>

c01031b8 <vector223>:
.globl vector223
vector223:
  pushl $0
c01031b8:	6a 00                	push   $0x0
  pushl $223
c01031ba:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01031bf:	e9 e4 f6 ff ff       	jmp    c01028a8 <__alltraps>

c01031c4 <vector224>:
.globl vector224
vector224:
  pushl $0
c01031c4:	6a 00                	push   $0x0
  pushl $224
c01031c6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01031cb:	e9 d8 f6 ff ff       	jmp    c01028a8 <__alltraps>

c01031d0 <vector225>:
.globl vector225
vector225:
  pushl $0
c01031d0:	6a 00                	push   $0x0
  pushl $225
c01031d2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01031d7:	e9 cc f6 ff ff       	jmp    c01028a8 <__alltraps>

c01031dc <vector226>:
.globl vector226
vector226:
  pushl $0
c01031dc:	6a 00                	push   $0x0
  pushl $226
c01031de:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01031e3:	e9 c0 f6 ff ff       	jmp    c01028a8 <__alltraps>

c01031e8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01031e8:	6a 00                	push   $0x0
  pushl $227
c01031ea:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01031ef:	e9 b4 f6 ff ff       	jmp    c01028a8 <__alltraps>

c01031f4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01031f4:	6a 00                	push   $0x0
  pushl $228
c01031f6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01031fb:	e9 a8 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103200 <vector229>:
.globl vector229
vector229:
  pushl $0
c0103200:	6a 00                	push   $0x0
  pushl $229
c0103202:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c0103207:	e9 9c f6 ff ff       	jmp    c01028a8 <__alltraps>

c010320c <vector230>:
.globl vector230
vector230:
  pushl $0
c010320c:	6a 00                	push   $0x0
  pushl $230
c010320e:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103213:	e9 90 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103218 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103218:	6a 00                	push   $0x0
  pushl $231
c010321a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010321f:	e9 84 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103224 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103224:	6a 00                	push   $0x0
  pushl $232
c0103226:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010322b:	e9 78 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103230 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103230:	6a 00                	push   $0x0
  pushl $233
c0103232:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103237:	e9 6c f6 ff ff       	jmp    c01028a8 <__alltraps>

c010323c <vector234>:
.globl vector234
vector234:
  pushl $0
c010323c:	6a 00                	push   $0x0
  pushl $234
c010323e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103243:	e9 60 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103248 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103248:	6a 00                	push   $0x0
  pushl $235
c010324a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010324f:	e9 54 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103254 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103254:	6a 00                	push   $0x0
  pushl $236
c0103256:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010325b:	e9 48 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103260 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103260:	6a 00                	push   $0x0
  pushl $237
c0103262:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103267:	e9 3c f6 ff ff       	jmp    c01028a8 <__alltraps>

c010326c <vector238>:
.globl vector238
vector238:
  pushl $0
c010326c:	6a 00                	push   $0x0
  pushl $238
c010326e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103273:	e9 30 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103278 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103278:	6a 00                	push   $0x0
  pushl $239
c010327a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010327f:	e9 24 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103284 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103284:	6a 00                	push   $0x0
  pushl $240
c0103286:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010328b:	e9 18 f6 ff ff       	jmp    c01028a8 <__alltraps>

c0103290 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103290:	6a 00                	push   $0x0
  pushl $241
c0103292:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103297:	e9 0c f6 ff ff       	jmp    c01028a8 <__alltraps>

c010329c <vector242>:
.globl vector242
vector242:
  pushl $0
c010329c:	6a 00                	push   $0x0
  pushl $242
c010329e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c01032a3:	e9 00 f6 ff ff       	jmp    c01028a8 <__alltraps>

c01032a8 <vector243>:
.globl vector243
vector243:
  pushl $0
c01032a8:	6a 00                	push   $0x0
  pushl $243
c01032aa:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c01032af:	e9 f4 f5 ff ff       	jmp    c01028a8 <__alltraps>

c01032b4 <vector244>:
.globl vector244
vector244:
  pushl $0
c01032b4:	6a 00                	push   $0x0
  pushl $244
c01032b6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01032bb:	e9 e8 f5 ff ff       	jmp    c01028a8 <__alltraps>

c01032c0 <vector245>:
.globl vector245
vector245:
  pushl $0
c01032c0:	6a 00                	push   $0x0
  pushl $245
c01032c2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01032c7:	e9 dc f5 ff ff       	jmp    c01028a8 <__alltraps>

c01032cc <vector246>:
.globl vector246
vector246:
  pushl $0
c01032cc:	6a 00                	push   $0x0
  pushl $246
c01032ce:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01032d3:	e9 d0 f5 ff ff       	jmp    c01028a8 <__alltraps>

c01032d8 <vector247>:
.globl vector247
vector247:
  pushl $0
c01032d8:	6a 00                	push   $0x0
  pushl $247
c01032da:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01032df:	e9 c4 f5 ff ff       	jmp    c01028a8 <__alltraps>

c01032e4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01032e4:	6a 00                	push   $0x0
  pushl $248
c01032e6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01032eb:	e9 b8 f5 ff ff       	jmp    c01028a8 <__alltraps>

c01032f0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01032f0:	6a 00                	push   $0x0
  pushl $249
c01032f2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01032f7:	e9 ac f5 ff ff       	jmp    c01028a8 <__alltraps>

c01032fc <vector250>:
.globl vector250
vector250:
  pushl $0
c01032fc:	6a 00                	push   $0x0
  pushl $250
c01032fe:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c0103303:	e9 a0 f5 ff ff       	jmp    c01028a8 <__alltraps>

c0103308 <vector251>:
.globl vector251
vector251:
  pushl $0
c0103308:	6a 00                	push   $0x0
  pushl $251
c010330a:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c010330f:	e9 94 f5 ff ff       	jmp    c01028a8 <__alltraps>

c0103314 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103314:	6a 00                	push   $0x0
  pushl $252
c0103316:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010331b:	e9 88 f5 ff ff       	jmp    c01028a8 <__alltraps>

c0103320 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103320:	6a 00                	push   $0x0
  pushl $253
c0103322:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103327:	e9 7c f5 ff ff       	jmp    c01028a8 <__alltraps>

c010332c <vector254>:
.globl vector254
vector254:
  pushl $0
c010332c:	6a 00                	push   $0x0
  pushl $254
c010332e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0103333:	e9 70 f5 ff ff       	jmp    c01028a8 <__alltraps>

c0103338 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103338:	6a 00                	push   $0x0
  pushl $255
c010333a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010333f:	e9 64 f5 ff ff       	jmp    c01028a8 <__alltraps>

c0103344 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103344:	55                   	push   %ebp
c0103345:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103347:	8b 55 08             	mov    0x8(%ebp),%edx
c010334a:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c010334f:	89 d1                	mov    %edx,%ecx
c0103351:	29 c1                	sub    %eax,%ecx
c0103353:	89 c8                	mov    %ecx,%eax
c0103355:	c1 f8 05             	sar    $0x5,%eax
}
c0103358:	5d                   	pop    %ebp
c0103359:	c3                   	ret    

c010335a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010335a:	55                   	push   %ebp
c010335b:	89 e5                	mov    %esp,%ebp
c010335d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103360:	8b 45 08             	mov    0x8(%ebp),%eax
c0103363:	89 04 24             	mov    %eax,(%esp)
c0103366:	e8 d9 ff ff ff       	call   c0103344 <page2ppn>
c010336b:	c1 e0 0c             	shl    $0xc,%eax
}
c010336e:	c9                   	leave  
c010336f:	c3                   	ret    

c0103370 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103370:	55                   	push   %ebp
c0103371:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103373:	8b 45 08             	mov    0x8(%ebp),%eax
c0103376:	8b 00                	mov    (%eax),%eax
}
c0103378:	5d                   	pop    %ebp
c0103379:	c3                   	ret    

c010337a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010337a:	55                   	push   %ebp
c010337b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010337d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103380:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103383:	89 10                	mov    %edx,(%eax)
}
c0103385:	5d                   	pop    %ebp
c0103386:	c3                   	ret    

c0103387 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103387:	55                   	push   %ebp
c0103388:	89 e5                	mov    %esp,%ebp
c010338a:	83 ec 10             	sub    $0x10,%esp
c010338d:	c7 45 fc 18 8b 12 c0 	movl   $0xc0128b18,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103394:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103397:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010339a:	89 50 04             	mov    %edx,0x4(%eax)
c010339d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033a0:	8b 50 04             	mov    0x4(%eax),%edx
c01033a3:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01033a6:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c01033a8:	c7 05 20 8b 12 c0 00 	movl   $0x0,0xc0128b20
c01033af:	00 00 00 
}
c01033b2:	c9                   	leave  
c01033b3:	c3                   	ret    

c01033b4 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01033b4:	55                   	push   %ebp
c01033b5:	89 e5                	mov    %esp,%ebp
c01033b7:	53                   	push   %ebx
c01033b8:	83 ec 44             	sub    $0x44,%esp
    assert(n > 0);
c01033bb:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01033bf:	75 24                	jne    c01033e5 <default_init_memmap+0x31>
c01033c1:	c7 44 24 0c 30 a9 10 	movl   $0xc010a930,0xc(%esp)
c01033c8:	c0 
c01033c9:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c01033d0:	c0 
c01033d1:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01033d8:	00 
c01033d9:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01033e0:	e8 db d8 ff ff       	call   c0100cc0 <__panic>
    struct Page *p;
    for (p = base; p != base + n; p++) {
c01033e5:	8b 45 08             	mov    0x8(%ebp),%eax
c01033e8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033eb:	e9 dc 00 00 00       	jmp    c01034cc <default_init_memmap+0x118>
        assert(PageReserved(p));
c01033f0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033f3:	83 c0 04             	add    $0x4,%eax
c01033f6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01033fd:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103400:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103403:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0103406:	0f a3 10             	bt     %edx,(%eax)
c0103409:	19 db                	sbb    %ebx,%ebx
c010340b:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    return oldbit != 0;
c010340e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103412:	0f 95 c0             	setne  %al
c0103415:	0f b6 c0             	movzbl %al,%eax
c0103418:	85 c0                	test   %eax,%eax
c010341a:	75 24                	jne    c0103440 <default_init_memmap+0x8c>
c010341c:	c7 44 24 0c 61 a9 10 	movl   $0xc010a961,0xc(%esp)
c0103423:	c0 
c0103424:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c010342b:	c0 
c010342c:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0103433:	00 
c0103434:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c010343b:	e8 80 d8 ff ff       	call   c0100cc0 <__panic>
        p->flags = 0;
c0103440:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103443:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        SetPageProperty(p);
c010344a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010344d:	83 c0 04             	add    $0x4,%eax
c0103450:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103457:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010345a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010345d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103460:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0103463:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103466:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c010346d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103474:	00 
c0103475:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103478:	89 04 24             	mov    %eax,(%esp)
c010347b:	e8 fa fe ff ff       	call   c010337a <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c0103480:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103483:	83 c0 0c             	add    $0xc,%eax
c0103486:	c7 45 dc 18 8b 12 c0 	movl   $0xc0128b18,-0x24(%ebp)
c010348d:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103490:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103493:	8b 00                	mov    (%eax),%eax
c0103495:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103498:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010349b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010349e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01034a1:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01034a4:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01034a7:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01034aa:	89 10                	mov    %edx,(%eax)
c01034ac:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01034af:	8b 10                	mov    (%eax),%edx
c01034b1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034b4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01034b7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01034ba:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01034bd:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01034c0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01034c3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01034c6:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p;
    for (p = base; p != base + n; p++) {
c01034c8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01034cc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034cf:	c1 e0 05             	shl    $0x5,%eax
c01034d2:	03 45 08             	add    0x8(%ebp),%eax
c01034d5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01034d8:	0f 85 12 ff ff ff    	jne    c01033f0 <default_init_memmap+0x3c>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free = nr_free + n;
c01034de:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c01034e3:	03 45 0c             	add    0xc(%ebp),%eax
c01034e6:	a3 20 8b 12 c0       	mov    %eax,0xc0128b20
    base->property = n;
c01034eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01034ee:	8b 55 0c             	mov    0xc(%ebp),%edx
c01034f1:	89 50 08             	mov    %edx,0x8(%eax)



}
c01034f4:	83 c4 44             	add    $0x44,%esp
c01034f7:	5b                   	pop    %ebx
c01034f8:	5d                   	pop    %ebp
c01034f9:	c3                   	ret    

c01034fa <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01034fa:	55                   	push   %ebp
c01034fb:	89 e5                	mov    %esp,%ebp
c01034fd:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c0103500:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0103504:	75 24                	jne    c010352a <default_alloc_pages+0x30>
c0103506:	c7 44 24 0c 30 a9 10 	movl   $0xc010a930,0xc(%esp)
c010350d:	c0 
c010350e:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103515:	c0 
c0103516:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c010351d:	00 
c010351e:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103525:	e8 96 d7 ff ff       	call   c0100cc0 <__panic>
    if (n > nr_free) {
c010352a:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c010352f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103532:	73 0a                	jae    c010353e <default_alloc_pages+0x44>
        return NULL;
c0103534:	b8 00 00 00 00       	mov    $0x0,%eax
c0103539:	e9 37 01 00 00       	jmp    c0103675 <default_alloc_pages+0x17b>
    }
    list_entry_t *len, *le;
    le = &free_list;
c010353e:	c7 45 f4 18 8b 12 c0 	movl   $0xc0128b18,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
c0103545:	e9 0a 01 00 00       	jmp    c0103654 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c010354a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010354d:	83 e8 0c             	sub    $0xc,%eax
c0103550:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c0103553:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103556:	8b 40 08             	mov    0x8(%eax),%eax
c0103559:	3b 45 08             	cmp    0x8(%ebp),%eax
c010355c:	0f 82 f2 00 00 00    	jb     c0103654 <default_alloc_pages+0x15a>
	int i;
        for(i = 0;i < n; i++){
c0103562:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103569:	eb 7c                	jmp    c01035e7 <default_alloc_pages+0xed>
c010356b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010356e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103571:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103574:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c0103577:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *newp = le2page(le, page_link);
c010357a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010357d:	83 e8 0c             	sub    $0xc,%eax
c0103580:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(newp);
c0103583:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103586:	83 c0 04             	add    $0x4,%eax
c0103589:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103590:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103593:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103596:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103599:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(newp);
c010359c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010359f:	83 c0 04             	add    $0x4,%eax
c01035a2:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c01035a9:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01035ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01035af:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01035b2:	0f b3 10             	btr    %edx,(%eax)
c01035b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035b8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01035bb:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035be:	8b 40 04             	mov    0x4(%eax),%eax
c01035c1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01035c4:	8b 12                	mov    (%edx),%edx
c01035c6:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01035c9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01035cc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01035cf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01035d2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01035d5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035d8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01035db:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c01035dd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035e0:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
	int i;
        for(i = 0;i < n; i++){
c01035e3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01035e7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035ea:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035ed:	0f 82 78 ff ff ff    	jb     c010356b <default_alloc_pages+0x71>
          SetPageReserved(newp);
          ClearPageProperty(newp);
          list_del(le);
          le = len;
        }
        if(p->property > n){
c01035f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035f6:	8b 40 08             	mov    0x8(%eax),%eax
c01035f9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035fc:	76 12                	jbe    c0103610 <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c01035fe:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103601:	8d 50 f4             	lea    -0xc(%eax),%edx
c0103604:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103607:	8b 40 08             	mov    0x8(%eax),%eax
c010360a:	2b 45 08             	sub    0x8(%ebp),%eax
c010360d:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c0103610:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103613:	83 c0 04             	add    $0x4,%eax
c0103616:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010361d:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103620:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103623:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103626:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c0103629:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010362c:	83 c0 04             	add    $0x4,%eax
c010362f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0103636:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103639:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010363c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010363f:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c0103642:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c0103647:	2b 45 08             	sub    0x8(%ebp),%eax
c010364a:	a3 20 8b 12 c0       	mov    %eax,0xc0128b20
        return p;
c010364f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103652:	eb 21                	jmp    c0103675 <default_alloc_pages+0x17b>
c0103654:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103657:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010365a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010365d:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *len, *le;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
c0103660:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103663:	81 7d f4 18 8b 12 c0 	cmpl   $0xc0128b18,-0xc(%ebp)
c010366a:	0f 85 da fe ff ff    	jne    c010354a <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c0103670:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103675:	c9                   	leave  
c0103676:	c3                   	ret    

c0103677 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103677:	55                   	push   %ebp
c0103678:	89 e5                	mov    %esp,%ebp
c010367a:	53                   	push   %ebx
c010367b:	83 ec 64             	sub    $0x64,%esp
    
    assert(n > 0);
c010367e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103682:	75 24                	jne    c01036a8 <default_free_pages+0x31>
c0103684:	c7 44 24 0c 30 a9 10 	movl   $0xc010a930,0xc(%esp)
c010368b:	c0 
c010368c:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103693:	c0 
c0103694:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c010369b:	00 
c010369c:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01036a3:	e8 18 d6 ff ff       	call   c0100cc0 <__panic>
    assert(PageReserved(base));
c01036a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01036ab:	83 c0 04             	add    $0x4,%eax
c01036ae:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01036b5:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036b8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036bb:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01036be:	0f a3 10             	bt     %edx,(%eax)
c01036c1:	19 db                	sbb    %ebx,%ebx
c01036c3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    return oldbit != 0;
c01036c6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01036ca:	0f 95 c0             	setne  %al
c01036cd:	0f b6 c0             	movzbl %al,%eax
c01036d0:	85 c0                	test   %eax,%eax
c01036d2:	75 24                	jne    c01036f8 <default_free_pages+0x81>
c01036d4:	c7 44 24 0c 71 a9 10 	movl   $0xc010a971,0xc(%esp)
c01036db:	c0 
c01036dc:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c01036e3:	c0 
c01036e4:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01036eb:	00 
c01036ec:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01036f3:	e8 c8 d5 ff ff       	call   c0100cc0 <__panic>

    list_entry_t *le = &free_list;
c01036f8:	c7 45 f4 18 8b 12 c0 	movl   $0xc0128b18,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c01036ff:	eb 11                	jmp    c0103712 <default_free_pages+0x9b>
      p = le2page(le, page_link);
c0103701:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103704:	83 e8 0c             	sub    $0xc,%eax
c0103707:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c010370a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010370d:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103710:	77 1a                	ja     c010372c <default_free_pages+0xb5>
        break;
c0103712:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103715:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103718:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010371b:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c010371e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103721:	81 7d f4 18 8b 12 c0 	cmpl   $0xc0128b18,-0xc(%ebp)
c0103728:	75 d7                	jne    c0103701 <default_free_pages+0x8a>
c010372a:	eb 01                	jmp    c010372d <default_free_pages+0xb6>
      p = le2page(le, page_link);
      if(p>base){
        break;
c010372c:	90                   	nop
      }
    }
    //list_add_before(le, base->page_link);
    for(p = base;p < base + n; p++){
c010372d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103730:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103733:	eb 4b                	jmp    c0103780 <default_free_pages+0x109>
      list_add_before(le, &(p->page_link));
c0103735:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103738:	8d 50 0c             	lea    0xc(%eax),%edx
c010373b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010373e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103741:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103744:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103747:	8b 00                	mov    (%eax),%eax
c0103749:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010374c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010374f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103752:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103755:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103758:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010375b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010375e:	89 10                	mov    %edx,(%eax)
c0103760:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103763:	8b 10                	mov    (%eax),%edx
c0103765:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103768:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010376b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010376e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103771:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103774:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103777:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010377a:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p = base;p < base + n; p++){
c010377c:	83 45 f0 20          	addl   $0x20,-0x10(%ebp)
c0103780:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103783:	c1 e0 05             	shl    $0x5,%eax
c0103786:	03 45 08             	add    0x8(%ebp),%eax
c0103789:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010378c:	77 a7                	ja     c0103735 <default_free_pages+0xbe>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c010378e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103791:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103798:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010379f:	00 
c01037a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01037a3:	89 04 24             	mov    %eax,(%esp)
c01037a6:	e8 cf fb ff ff       	call   c010337a <set_page_ref>
    ClearPageProperty(base);
c01037ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01037ae:	83 c0 04             	add    $0x4,%eax
c01037b1:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01037b8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01037bb:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01037be:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01037c1:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c01037c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01037c7:	83 c0 04             	add    $0x4,%eax
c01037ca:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01037d1:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01037d4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01037d7:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01037da:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c01037dd:	8b 45 08             	mov    0x8(%ebp),%eax
c01037e0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01037e3:	89 50 08             	mov    %edx,0x8(%eax)
    
    p = le2page(le,page_link) ;
c01037e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037e9:	83 e8 0c             	sub    $0xc,%eax
c01037ec:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c01037ef:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037f2:	c1 e0 05             	shl    $0x5,%eax
c01037f5:	03 45 08             	add    0x8(%ebp),%eax
c01037f8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01037fb:	75 1e                	jne    c010381b <default_free_pages+0x1a4>
      base->property += p->property;
c01037fd:	8b 45 08             	mov    0x8(%ebp),%eax
c0103800:	8b 50 08             	mov    0x8(%eax),%edx
c0103803:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103806:	8b 40 08             	mov    0x8(%eax),%eax
c0103809:	01 c2                	add    %eax,%edx
c010380b:	8b 45 08             	mov    0x8(%ebp),%eax
c010380e:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0103811:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103814:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c010381b:	8b 45 08             	mov    0x8(%ebp),%eax
c010381e:	83 c0 0c             	add    $0xc,%eax
c0103821:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0103824:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103827:	8b 00                	mov    (%eax),%eax
c0103829:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c010382c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010382f:	83 e8 0c             	sub    $0xc,%eax
c0103832:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c0103835:	81 7d f4 18 8b 12 c0 	cmpl   $0xc0128b18,-0xc(%ebp)
c010383c:	74 57                	je     c0103895 <default_free_pages+0x21e>
c010383e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103841:	83 e8 20             	sub    $0x20,%eax
c0103844:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103847:	75 4c                	jne    c0103895 <default_free_pages+0x21e>
      while(le!=&free_list){
c0103849:	eb 41                	jmp    c010388c <default_free_pages+0x215>
        if(p->property){
c010384b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010384e:	8b 40 08             	mov    0x8(%eax),%eax
c0103851:	85 c0                	test   %eax,%eax
c0103853:	74 20                	je     c0103875 <default_free_pages+0x1fe>
          p->property += base->property;
c0103855:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103858:	8b 50 08             	mov    0x8(%eax),%edx
c010385b:	8b 45 08             	mov    0x8(%ebp),%eax
c010385e:	8b 40 08             	mov    0x8(%eax),%eax
c0103861:	01 c2                	add    %eax,%edx
c0103863:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103866:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c0103869:	8b 45 08             	mov    0x8(%ebp),%eax
c010386c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0103873:	eb 20                	jmp    c0103895 <default_free_pages+0x21e>
c0103875:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103878:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010387b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010387e:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0103880:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0103883:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103886:	83 e8 0c             	sub    $0xc,%eax
c0103889:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c010388c:	81 7d f4 18 8b 12 c0 	cmpl   $0xc0128b18,-0xc(%ebp)
c0103893:	75 b6                	jne    c010384b <default_free_pages+0x1d4>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free = nr_free + n;
c0103895:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c010389a:	03 45 0c             	add    0xc(%ebp),%eax
c010389d:	a3 20 8b 12 c0       	mov    %eax,0xc0128b20
}
c01038a2:	83 c4 64             	add    $0x64,%esp
c01038a5:	5b                   	pop    %ebx
c01038a6:	5d                   	pop    %ebp
c01038a7:	c3                   	ret    

c01038a8 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c01038a8:	55                   	push   %ebp
c01038a9:	89 e5                	mov    %esp,%ebp
    return nr_free;
c01038ab:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
}
c01038b0:	5d                   	pop    %ebp
c01038b1:	c3                   	ret    

c01038b2 <basic_check>:

static void
basic_check(void) {
c01038b2:	55                   	push   %ebp
c01038b3:	89 e5                	mov    %esp,%ebp
c01038b5:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01038b8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01038bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038c2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038c5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038c8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01038cb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038d2:	e8 f6 15 00 00       	call   c0104ecd <alloc_pages>
c01038d7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038da:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01038de:	75 24                	jne    c0103904 <basic_check+0x52>
c01038e0:	c7 44 24 0c 84 a9 10 	movl   $0xc010a984,0xc(%esp)
c01038e7:	c0 
c01038e8:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c01038ef:	c0 
c01038f0:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c01038f7:	00 
c01038f8:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01038ff:	e8 bc d3 ff ff       	call   c0100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103904:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010390b:	e8 bd 15 00 00       	call   c0104ecd <alloc_pages>
c0103910:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103913:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103917:	75 24                	jne    c010393d <basic_check+0x8b>
c0103919:	c7 44 24 0c a0 a9 10 	movl   $0xc010a9a0,0xc(%esp)
c0103920:	c0 
c0103921:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103928:	c0 
c0103929:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103930:	00 
c0103931:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103938:	e8 83 d3 ff ff       	call   c0100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010393d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103944:	e8 84 15 00 00       	call   c0104ecd <alloc_pages>
c0103949:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010394c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103950:	75 24                	jne    c0103976 <basic_check+0xc4>
c0103952:	c7 44 24 0c bc a9 10 	movl   $0xc010a9bc,0xc(%esp)
c0103959:	c0 
c010395a:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103961:	c0 
c0103962:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0103969:	00 
c010396a:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103971:	e8 4a d3 ff ff       	call   c0100cc0 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103976:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103979:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010397c:	74 10                	je     c010398e <basic_check+0xdc>
c010397e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103981:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103984:	74 08                	je     c010398e <basic_check+0xdc>
c0103986:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103989:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010398c:	75 24                	jne    c01039b2 <basic_check+0x100>
c010398e:	c7 44 24 0c d8 a9 10 	movl   $0xc010a9d8,0xc(%esp)
c0103995:	c0 
c0103996:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c010399d:	c0 
c010399e:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c01039a5:	00 
c01039a6:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01039ad:	e8 0e d3 ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01039b2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039b5:	89 04 24             	mov    %eax,(%esp)
c01039b8:	e8 b3 f9 ff ff       	call   c0103370 <page_ref>
c01039bd:	85 c0                	test   %eax,%eax
c01039bf:	75 1e                	jne    c01039df <basic_check+0x12d>
c01039c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039c4:	89 04 24             	mov    %eax,(%esp)
c01039c7:	e8 a4 f9 ff ff       	call   c0103370 <page_ref>
c01039cc:	85 c0                	test   %eax,%eax
c01039ce:	75 0f                	jne    c01039df <basic_check+0x12d>
c01039d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039d3:	89 04 24             	mov    %eax,(%esp)
c01039d6:	e8 95 f9 ff ff       	call   c0103370 <page_ref>
c01039db:	85 c0                	test   %eax,%eax
c01039dd:	74 24                	je     c0103a03 <basic_check+0x151>
c01039df:	c7 44 24 0c fc a9 10 	movl   $0xc010a9fc,0xc(%esp)
c01039e6:	c0 
c01039e7:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c01039ee:	c0 
c01039ef:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c01039f6:	00 
c01039f7:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01039fe:	e8 bd d2 ff ff       	call   c0100cc0 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c0103a03:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103a06:	89 04 24             	mov    %eax,(%esp)
c0103a09:	e8 4c f9 ff ff       	call   c010335a <page2pa>
c0103a0e:	8b 15 40 6a 12 c0    	mov    0xc0126a40,%edx
c0103a14:	c1 e2 0c             	shl    $0xc,%edx
c0103a17:	39 d0                	cmp    %edx,%eax
c0103a19:	72 24                	jb     c0103a3f <basic_check+0x18d>
c0103a1b:	c7 44 24 0c 38 aa 10 	movl   $0xc010aa38,0xc(%esp)
c0103a22:	c0 
c0103a23:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103a2a:	c0 
c0103a2b:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103a32:	00 
c0103a33:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103a3a:	e8 81 d2 ff ff       	call   c0100cc0 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a42:	89 04 24             	mov    %eax,(%esp)
c0103a45:	e8 10 f9 ff ff       	call   c010335a <page2pa>
c0103a4a:	8b 15 40 6a 12 c0    	mov    0xc0126a40,%edx
c0103a50:	c1 e2 0c             	shl    $0xc,%edx
c0103a53:	39 d0                	cmp    %edx,%eax
c0103a55:	72 24                	jb     c0103a7b <basic_check+0x1c9>
c0103a57:	c7 44 24 0c 55 aa 10 	movl   $0xc010aa55,0xc(%esp)
c0103a5e:	c0 
c0103a5f:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103a66:	c0 
c0103a67:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103a6e:	00 
c0103a6f:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103a76:	e8 45 d2 ff ff       	call   c0100cc0 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103a7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a7e:	89 04 24             	mov    %eax,(%esp)
c0103a81:	e8 d4 f8 ff ff       	call   c010335a <page2pa>
c0103a86:	8b 15 40 6a 12 c0    	mov    0xc0126a40,%edx
c0103a8c:	c1 e2 0c             	shl    $0xc,%edx
c0103a8f:	39 d0                	cmp    %edx,%eax
c0103a91:	72 24                	jb     c0103ab7 <basic_check+0x205>
c0103a93:	c7 44 24 0c 72 aa 10 	movl   $0xc010aa72,0xc(%esp)
c0103a9a:	c0 
c0103a9b:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103aa2:	c0 
c0103aa3:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103aaa:	00 
c0103aab:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103ab2:	e8 09 d2 ff ff       	call   c0100cc0 <__panic>

    list_entry_t free_list_store = free_list;
c0103ab7:	a1 18 8b 12 c0       	mov    0xc0128b18,%eax
c0103abc:	8b 15 1c 8b 12 c0    	mov    0xc0128b1c,%edx
c0103ac2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ac5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103ac8:	c7 45 e0 18 8b 12 c0 	movl   $0xc0128b18,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103acf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ad2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103ad5:	89 50 04             	mov    %edx,0x4(%eax)
c0103ad8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103adb:	8b 50 04             	mov    0x4(%eax),%edx
c0103ade:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ae1:	89 10                	mov    %edx,(%eax)
c0103ae3:	c7 45 dc 18 8b 12 c0 	movl   $0xc0128b18,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103aea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103aed:	8b 40 04             	mov    0x4(%eax),%eax
c0103af0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103af3:	0f 94 c0             	sete   %al
c0103af6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103af9:	85 c0                	test   %eax,%eax
c0103afb:	75 24                	jne    c0103b21 <basic_check+0x26f>
c0103afd:	c7 44 24 0c 8f aa 10 	movl   $0xc010aa8f,0xc(%esp)
c0103b04:	c0 
c0103b05:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103b0c:	c0 
c0103b0d:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0103b14:	00 
c0103b15:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103b1c:	e8 9f d1 ff ff       	call   c0100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
c0103b21:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c0103b26:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103b29:	c7 05 20 8b 12 c0 00 	movl   $0x0,0xc0128b20
c0103b30:	00 00 00 

    assert(alloc_page() == NULL);
c0103b33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b3a:	e8 8e 13 00 00       	call   c0104ecd <alloc_pages>
c0103b3f:	85 c0                	test   %eax,%eax
c0103b41:	74 24                	je     c0103b67 <basic_check+0x2b5>
c0103b43:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c0103b4a:	c0 
c0103b4b:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103b52:	c0 
c0103b53:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0103b5a:	00 
c0103b5b:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103b62:	e8 59 d1 ff ff       	call   c0100cc0 <__panic>

    free_page(p0);
c0103b67:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b6e:	00 
c0103b6f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b72:	89 04 24             	mov    %eax,(%esp)
c0103b75:	e8 be 13 00 00       	call   c0104f38 <free_pages>
    free_page(p1);
c0103b7a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b81:	00 
c0103b82:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b85:	89 04 24             	mov    %eax,(%esp)
c0103b88:	e8 ab 13 00 00       	call   c0104f38 <free_pages>
    free_page(p2);
c0103b8d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b94:	00 
c0103b95:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b98:	89 04 24             	mov    %eax,(%esp)
c0103b9b:	e8 98 13 00 00       	call   c0104f38 <free_pages>
    assert(nr_free == 3);
c0103ba0:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c0103ba5:	83 f8 03             	cmp    $0x3,%eax
c0103ba8:	74 24                	je     c0103bce <basic_check+0x31c>
c0103baa:	c7 44 24 0c bb aa 10 	movl   $0xc010aabb,0xc(%esp)
c0103bb1:	c0 
c0103bb2:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103bb9:	c0 
c0103bba:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103bc1:	00 
c0103bc2:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103bc9:	e8 f2 d0 ff ff       	call   c0100cc0 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103bce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bd5:	e8 f3 12 00 00       	call   c0104ecd <alloc_pages>
c0103bda:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103bdd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103be1:	75 24                	jne    c0103c07 <basic_check+0x355>
c0103be3:	c7 44 24 0c 84 a9 10 	movl   $0xc010a984,0xc(%esp)
c0103bea:	c0 
c0103beb:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103bf2:	c0 
c0103bf3:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103bfa:	00 
c0103bfb:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103c02:	e8 b9 d0 ff ff       	call   c0100cc0 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103c07:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c0e:	e8 ba 12 00 00       	call   c0104ecd <alloc_pages>
c0103c13:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c16:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c1a:	75 24                	jne    c0103c40 <basic_check+0x38e>
c0103c1c:	c7 44 24 0c a0 a9 10 	movl   $0xc010a9a0,0xc(%esp)
c0103c23:	c0 
c0103c24:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103c2b:	c0 
c0103c2c:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103c33:	00 
c0103c34:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103c3b:	e8 80 d0 ff ff       	call   c0100cc0 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103c40:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c47:	e8 81 12 00 00       	call   c0104ecd <alloc_pages>
c0103c4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c4f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c53:	75 24                	jne    c0103c79 <basic_check+0x3c7>
c0103c55:	c7 44 24 0c bc a9 10 	movl   $0xc010a9bc,0xc(%esp)
c0103c5c:	c0 
c0103c5d:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103c64:	c0 
c0103c65:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103c6c:	00 
c0103c6d:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103c74:	e8 47 d0 ff ff       	call   c0100cc0 <__panic>

    assert(alloc_page() == NULL);
c0103c79:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c80:	e8 48 12 00 00       	call   c0104ecd <alloc_pages>
c0103c85:	85 c0                	test   %eax,%eax
c0103c87:	74 24                	je     c0103cad <basic_check+0x3fb>
c0103c89:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c0103c90:	c0 
c0103c91:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103c98:	c0 
c0103c99:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103ca0:	00 
c0103ca1:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103ca8:	e8 13 d0 ff ff       	call   c0100cc0 <__panic>

    free_page(p0);
c0103cad:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103cb4:	00 
c0103cb5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103cb8:	89 04 24             	mov    %eax,(%esp)
c0103cbb:	e8 78 12 00 00       	call   c0104f38 <free_pages>
c0103cc0:	c7 45 d8 18 8b 12 c0 	movl   $0xc0128b18,-0x28(%ebp)
c0103cc7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103cca:	8b 40 04             	mov    0x4(%eax),%eax
c0103ccd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103cd0:	0f 94 c0             	sete   %al
c0103cd3:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103cd6:	85 c0                	test   %eax,%eax
c0103cd8:	74 24                	je     c0103cfe <basic_check+0x44c>
c0103cda:	c7 44 24 0c c8 aa 10 	movl   $0xc010aac8,0xc(%esp)
c0103ce1:	c0 
c0103ce2:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103ce9:	c0 
c0103cea:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103cf1:	00 
c0103cf2:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103cf9:	e8 c2 cf ff ff       	call   c0100cc0 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103cfe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d05:	e8 c3 11 00 00       	call   c0104ecd <alloc_pages>
c0103d0a:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103d0d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d10:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103d13:	74 24                	je     c0103d39 <basic_check+0x487>
c0103d15:	c7 44 24 0c e0 aa 10 	movl   $0xc010aae0,0xc(%esp)
c0103d1c:	c0 
c0103d1d:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103d24:	c0 
c0103d25:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103d2c:	00 
c0103d2d:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103d34:	e8 87 cf ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c0103d39:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d40:	e8 88 11 00 00       	call   c0104ecd <alloc_pages>
c0103d45:	85 c0                	test   %eax,%eax
c0103d47:	74 24                	je     c0103d6d <basic_check+0x4bb>
c0103d49:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c0103d50:	c0 
c0103d51:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103d58:	c0 
c0103d59:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103d60:	00 
c0103d61:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103d68:	e8 53 cf ff ff       	call   c0100cc0 <__panic>

    assert(nr_free == 0);
c0103d6d:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c0103d72:	85 c0                	test   %eax,%eax
c0103d74:	74 24                	je     c0103d9a <basic_check+0x4e8>
c0103d76:	c7 44 24 0c f9 aa 10 	movl   $0xc010aaf9,0xc(%esp)
c0103d7d:	c0 
c0103d7e:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103d85:	c0 
c0103d86:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103d8d:	00 
c0103d8e:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103d95:	e8 26 cf ff ff       	call   c0100cc0 <__panic>
    free_list = free_list_store;
c0103d9a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d9d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103da0:	a3 18 8b 12 c0       	mov    %eax,0xc0128b18
c0103da5:	89 15 1c 8b 12 c0    	mov    %edx,0xc0128b1c
    nr_free = nr_free_store;
c0103dab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103dae:	a3 20 8b 12 c0       	mov    %eax,0xc0128b20

    free_page(p);
c0103db3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103dba:	00 
c0103dbb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dbe:	89 04 24             	mov    %eax,(%esp)
c0103dc1:	e8 72 11 00 00       	call   c0104f38 <free_pages>
    free_page(p1);
c0103dc6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103dcd:	00 
c0103dce:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dd1:	89 04 24             	mov    %eax,(%esp)
c0103dd4:	e8 5f 11 00 00       	call   c0104f38 <free_pages>
    free_page(p2);
c0103dd9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103de0:	00 
c0103de1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103de4:	89 04 24             	mov    %eax,(%esp)
c0103de7:	e8 4c 11 00 00       	call   c0104f38 <free_pages>
}
c0103dec:	c9                   	leave  
c0103ded:	c3                   	ret    

c0103dee <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103dee:	55                   	push   %ebp
c0103def:	89 e5                	mov    %esp,%ebp
c0103df1:	53                   	push   %ebx
c0103df2:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103df8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103dff:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103e06:	c7 45 ec 18 8b 12 c0 	movl   $0xc0128b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103e0d:	eb 6b                	jmp    c0103e7a <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103e0f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e12:	83 e8 0c             	sub    $0xc,%eax
c0103e15:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103e18:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e1b:	83 c0 04             	add    $0x4,%eax
c0103e1e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103e25:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e28:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103e2b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103e2e:	0f a3 10             	bt     %edx,(%eax)
c0103e31:	19 db                	sbb    %ebx,%ebx
c0103e33:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    return oldbit != 0;
c0103e36:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103e3a:	0f 95 c0             	setne  %al
c0103e3d:	0f b6 c0             	movzbl %al,%eax
c0103e40:	85 c0                	test   %eax,%eax
c0103e42:	75 24                	jne    c0103e68 <default_check+0x7a>
c0103e44:	c7 44 24 0c 06 ab 10 	movl   $0xc010ab06,0xc(%esp)
c0103e4b:	c0 
c0103e4c:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103e53:	c0 
c0103e54:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103e5b:	00 
c0103e5c:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103e63:	e8 58 ce ff ff       	call   c0100cc0 <__panic>
        count ++, total += p->property;
c0103e68:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103e6c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e6f:	8b 50 08             	mov    0x8(%eax),%edx
c0103e72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e75:	01 d0                	add    %edx,%eax
c0103e77:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e7a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e7d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103e80:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e83:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103e86:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e89:	81 7d ec 18 8b 12 c0 	cmpl   $0xc0128b18,-0x14(%ebp)
c0103e90:	0f 85 79 ff ff ff    	jne    c0103e0f <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103e96:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103e99:	e8 cc 10 00 00       	call   c0104f6a <nr_free_pages>
c0103e9e:	39 c3                	cmp    %eax,%ebx
c0103ea0:	74 24                	je     c0103ec6 <default_check+0xd8>
c0103ea2:	c7 44 24 0c 16 ab 10 	movl   $0xc010ab16,0xc(%esp)
c0103ea9:	c0 
c0103eaa:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103eb1:	c0 
c0103eb2:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103eb9:	00 
c0103eba:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103ec1:	e8 fa cd ff ff       	call   c0100cc0 <__panic>

    basic_check();
c0103ec6:	e8 e7 f9 ff ff       	call   c01038b2 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103ecb:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103ed2:	e8 f6 0f 00 00       	call   c0104ecd <alloc_pages>
c0103ed7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103eda:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ede:	75 24                	jne    c0103f04 <default_check+0x116>
c0103ee0:	c7 44 24 0c 2f ab 10 	movl   $0xc010ab2f,0xc(%esp)
c0103ee7:	c0 
c0103ee8:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103eef:	c0 
c0103ef0:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103ef7:	00 
c0103ef8:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103eff:	e8 bc cd ff ff       	call   c0100cc0 <__panic>
    assert(!PageProperty(p0));
c0103f04:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103f07:	83 c0 04             	add    $0x4,%eax
c0103f0a:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103f11:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f14:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103f17:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103f1a:	0f a3 10             	bt     %edx,(%eax)
c0103f1d:	19 db                	sbb    %ebx,%ebx
c0103f1f:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    return oldbit != 0;
c0103f22:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103f26:	0f 95 c0             	setne  %al
c0103f29:	0f b6 c0             	movzbl %al,%eax
c0103f2c:	85 c0                	test   %eax,%eax
c0103f2e:	74 24                	je     c0103f54 <default_check+0x166>
c0103f30:	c7 44 24 0c 3a ab 10 	movl   $0xc010ab3a,0xc(%esp)
c0103f37:	c0 
c0103f38:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103f3f:	c0 
c0103f40:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0103f47:	00 
c0103f48:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103f4f:	e8 6c cd ff ff       	call   c0100cc0 <__panic>

    list_entry_t free_list_store = free_list;
c0103f54:	a1 18 8b 12 c0       	mov    0xc0128b18,%eax
c0103f59:	8b 15 1c 8b 12 c0    	mov    0xc0128b1c,%edx
c0103f5f:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103f62:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103f65:	c7 45 b4 18 8b 12 c0 	movl   $0xc0128b18,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103f6c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f6f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f72:	89 50 04             	mov    %edx,0x4(%eax)
c0103f75:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f78:	8b 50 04             	mov    0x4(%eax),%edx
c0103f7b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f7e:	89 10                	mov    %edx,(%eax)
c0103f80:	c7 45 b0 18 8b 12 c0 	movl   $0xc0128b18,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103f87:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f8a:	8b 40 04             	mov    0x4(%eax),%eax
c0103f8d:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103f90:	0f 94 c0             	sete   %al
c0103f93:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103f96:	85 c0                	test   %eax,%eax
c0103f98:	75 24                	jne    c0103fbe <default_check+0x1d0>
c0103f9a:	c7 44 24 0c 8f aa 10 	movl   $0xc010aa8f,0xc(%esp)
c0103fa1:	c0 
c0103fa2:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103fa9:	c0 
c0103faa:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103fb1:	00 
c0103fb2:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103fb9:	e8 02 cd ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c0103fbe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fc5:	e8 03 0f 00 00       	call   c0104ecd <alloc_pages>
c0103fca:	85 c0                	test   %eax,%eax
c0103fcc:	74 24                	je     c0103ff2 <default_check+0x204>
c0103fce:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c0103fd5:	c0 
c0103fd6:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0103fdd:	c0 
c0103fde:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103fe5:	00 
c0103fe6:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0103fed:	e8 ce cc ff ff       	call   c0100cc0 <__panic>

    unsigned int nr_free_store = nr_free;
c0103ff2:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c0103ff7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103ffa:	c7 05 20 8b 12 c0 00 	movl   $0x0,0xc0128b20
c0104001:	00 00 00 

    free_pages(p0 + 2, 3);
c0104004:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104007:	83 c0 40             	add    $0x40,%eax
c010400a:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104011:	00 
c0104012:	89 04 24             	mov    %eax,(%esp)
c0104015:	e8 1e 0f 00 00       	call   c0104f38 <free_pages>
    assert(alloc_pages(4) == NULL);
c010401a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104021:	e8 a7 0e 00 00       	call   c0104ecd <alloc_pages>
c0104026:	85 c0                	test   %eax,%eax
c0104028:	74 24                	je     c010404e <default_check+0x260>
c010402a:	c7 44 24 0c 4c ab 10 	movl   $0xc010ab4c,0xc(%esp)
c0104031:	c0 
c0104032:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0104039:	c0 
c010403a:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0104041:	00 
c0104042:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0104049:	e8 72 cc ff ff       	call   c0100cc0 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010404e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104051:	83 c0 40             	add    $0x40,%eax
c0104054:	83 c0 04             	add    $0x4,%eax
c0104057:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010405e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104061:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104064:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104067:	0f a3 10             	bt     %edx,(%eax)
c010406a:	19 db                	sbb    %ebx,%ebx
c010406c:	89 5d a4             	mov    %ebx,-0x5c(%ebp)
    return oldbit != 0;
c010406f:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104073:	0f 95 c0             	setne  %al
c0104076:	0f b6 c0             	movzbl %al,%eax
c0104079:	85 c0                	test   %eax,%eax
c010407b:	74 0e                	je     c010408b <default_check+0x29d>
c010407d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104080:	83 c0 40             	add    $0x40,%eax
c0104083:	8b 40 08             	mov    0x8(%eax),%eax
c0104086:	83 f8 03             	cmp    $0x3,%eax
c0104089:	74 24                	je     c01040af <default_check+0x2c1>
c010408b:	c7 44 24 0c 64 ab 10 	movl   $0xc010ab64,0xc(%esp)
c0104092:	c0 
c0104093:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c010409a:	c0 
c010409b:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c01040a2:	00 
c01040a3:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01040aa:	e8 11 cc ff ff       	call   c0100cc0 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c01040af:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01040b6:	e8 12 0e 00 00       	call   c0104ecd <alloc_pages>
c01040bb:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01040be:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01040c2:	75 24                	jne    c01040e8 <default_check+0x2fa>
c01040c4:	c7 44 24 0c 90 ab 10 	movl   $0xc010ab90,0xc(%esp)
c01040cb:	c0 
c01040cc:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c01040d3:	c0 
c01040d4:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01040db:	00 
c01040dc:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01040e3:	e8 d8 cb ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c01040e8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040ef:	e8 d9 0d 00 00       	call   c0104ecd <alloc_pages>
c01040f4:	85 c0                	test   %eax,%eax
c01040f6:	74 24                	je     c010411c <default_check+0x32e>
c01040f8:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c01040ff:	c0 
c0104100:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0104107:	c0 
c0104108:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c010410f:	00 
c0104110:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0104117:	e8 a4 cb ff ff       	call   c0100cc0 <__panic>
    assert(p0 + 2 == p1);
c010411c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010411f:	83 c0 40             	add    $0x40,%eax
c0104122:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104125:	74 24                	je     c010414b <default_check+0x35d>
c0104127:	c7 44 24 0c ae ab 10 	movl   $0xc010abae,0xc(%esp)
c010412e:	c0 
c010412f:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0104136:	c0 
c0104137:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c010413e:	00 
c010413f:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0104146:	e8 75 cb ff ff       	call   c0100cc0 <__panic>

    p2 = p0 + 1;
c010414b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010414e:	83 c0 20             	add    $0x20,%eax
c0104151:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0104154:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010415b:	00 
c010415c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010415f:	89 04 24             	mov    %eax,(%esp)
c0104162:	e8 d1 0d 00 00       	call   c0104f38 <free_pages>
    free_pages(p1, 3);
c0104167:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010416e:	00 
c010416f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104172:	89 04 24             	mov    %eax,(%esp)
c0104175:	e8 be 0d 00 00       	call   c0104f38 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010417a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010417d:	83 c0 04             	add    $0x4,%eax
c0104180:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104187:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010418a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010418d:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104190:	0f a3 10             	bt     %edx,(%eax)
c0104193:	19 db                	sbb    %ebx,%ebx
c0104195:	89 5d 98             	mov    %ebx,-0x68(%ebp)
    return oldbit != 0;
c0104198:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010419c:	0f 95 c0             	setne  %al
c010419f:	0f b6 c0             	movzbl %al,%eax
c01041a2:	85 c0                	test   %eax,%eax
c01041a4:	74 0b                	je     c01041b1 <default_check+0x3c3>
c01041a6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01041a9:	8b 40 08             	mov    0x8(%eax),%eax
c01041ac:	83 f8 01             	cmp    $0x1,%eax
c01041af:	74 24                	je     c01041d5 <default_check+0x3e7>
c01041b1:	c7 44 24 0c bc ab 10 	movl   $0xc010abbc,0xc(%esp)
c01041b8:	c0 
c01041b9:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c01041c0:	c0 
c01041c1:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041c8:	00 
c01041c9:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01041d0:	e8 eb ca ff ff       	call   c0100cc0 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01041d5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041d8:	83 c0 04             	add    $0x4,%eax
c01041db:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01041e2:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041e5:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041e8:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041eb:	0f a3 10             	bt     %edx,(%eax)
c01041ee:	19 db                	sbb    %ebx,%ebx
c01041f0:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
    return oldbit != 0;
c01041f3:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01041f7:	0f 95 c0             	setne  %al
c01041fa:	0f b6 c0             	movzbl %al,%eax
c01041fd:	85 c0                	test   %eax,%eax
c01041ff:	74 0b                	je     c010420c <default_check+0x41e>
c0104201:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104204:	8b 40 08             	mov    0x8(%eax),%eax
c0104207:	83 f8 03             	cmp    $0x3,%eax
c010420a:	74 24                	je     c0104230 <default_check+0x442>
c010420c:	c7 44 24 0c e4 ab 10 	movl   $0xc010abe4,0xc(%esp)
c0104213:	c0 
c0104214:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c010421b:	c0 
c010421c:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0104223:	00 
c0104224:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c010422b:	e8 90 ca ff ff       	call   c0100cc0 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104230:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104237:	e8 91 0c 00 00       	call   c0104ecd <alloc_pages>
c010423c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010423f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104242:	83 e8 20             	sub    $0x20,%eax
c0104245:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104248:	74 24                	je     c010426e <default_check+0x480>
c010424a:	c7 44 24 0c 0a ac 10 	movl   $0xc010ac0a,0xc(%esp)
c0104251:	c0 
c0104252:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0104259:	c0 
c010425a:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104261:	00 
c0104262:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0104269:	e8 52 ca ff ff       	call   c0100cc0 <__panic>
    free_page(p0);
c010426e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104275:	00 
c0104276:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104279:	89 04 24             	mov    %eax,(%esp)
c010427c:	e8 b7 0c 00 00       	call   c0104f38 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104281:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104288:	e8 40 0c 00 00       	call   c0104ecd <alloc_pages>
c010428d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104290:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104293:	83 c0 20             	add    $0x20,%eax
c0104296:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104299:	74 24                	je     c01042bf <default_check+0x4d1>
c010429b:	c7 44 24 0c 28 ac 10 	movl   $0xc010ac28,0xc(%esp)
c01042a2:	c0 
c01042a3:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c01042aa:	c0 
c01042ab:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01042b2:	00 
c01042b3:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c01042ba:	e8 01 ca ff ff       	call   c0100cc0 <__panic>

    free_pages(p0, 2);
c01042bf:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01042c6:	00 
c01042c7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042ca:	89 04 24             	mov    %eax,(%esp)
c01042cd:	e8 66 0c 00 00       	call   c0104f38 <free_pages>
    free_page(p2);
c01042d2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042d9:	00 
c01042da:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01042dd:	89 04 24             	mov    %eax,(%esp)
c01042e0:	e8 53 0c 00 00       	call   c0104f38 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01042e5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01042ec:	e8 dc 0b 00 00       	call   c0104ecd <alloc_pages>
c01042f1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042f4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01042f8:	75 24                	jne    c010431e <default_check+0x530>
c01042fa:	c7 44 24 0c 48 ac 10 	movl   $0xc010ac48,0xc(%esp)
c0104301:	c0 
c0104302:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0104309:	c0 
c010430a:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104311:	00 
c0104312:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0104319:	e8 a2 c9 ff ff       	call   c0100cc0 <__panic>
    assert(alloc_page() == NULL);
c010431e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104325:	e8 a3 0b 00 00       	call   c0104ecd <alloc_pages>
c010432a:	85 c0                	test   %eax,%eax
c010432c:	74 24                	je     c0104352 <default_check+0x564>
c010432e:	c7 44 24 0c a6 aa 10 	movl   $0xc010aaa6,0xc(%esp)
c0104335:	c0 
c0104336:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c010433d:	c0 
c010433e:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0104345:	00 
c0104346:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c010434d:	e8 6e c9 ff ff       	call   c0100cc0 <__panic>

    assert(nr_free == 0);
c0104352:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c0104357:	85 c0                	test   %eax,%eax
c0104359:	74 24                	je     c010437f <default_check+0x591>
c010435b:	c7 44 24 0c f9 aa 10 	movl   $0xc010aaf9,0xc(%esp)
c0104362:	c0 
c0104363:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c010436a:	c0 
c010436b:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104372:	00 
c0104373:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c010437a:	e8 41 c9 ff ff       	call   c0100cc0 <__panic>
    nr_free = nr_free_store;
c010437f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104382:	a3 20 8b 12 c0       	mov    %eax,0xc0128b20

    free_list = free_list_store;
c0104387:	8b 45 80             	mov    -0x80(%ebp),%eax
c010438a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010438d:	a3 18 8b 12 c0       	mov    %eax,0xc0128b18
c0104392:	89 15 1c 8b 12 c0    	mov    %edx,0xc0128b1c
    free_pages(p0, 5);
c0104398:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010439f:	00 
c01043a0:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01043a3:	89 04 24             	mov    %eax,(%esp)
c01043a6:	e8 8d 0b 00 00       	call   c0104f38 <free_pages>

    le = &free_list;
c01043ab:	c7 45 ec 18 8b 12 c0 	movl   $0xc0128b18,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01043b2:	eb 1f                	jmp    c01043d3 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
c01043b4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043b7:	83 e8 0c             	sub    $0xc,%eax
c01043ba:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01043bd:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01043c1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01043c4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01043c7:	8b 40 08             	mov    0x8(%eax),%eax
c01043ca:	89 d1                	mov    %edx,%ecx
c01043cc:	29 c1                	sub    %eax,%ecx
c01043ce:	89 c8                	mov    %ecx,%eax
c01043d0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043d3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043d6:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01043d9:	8b 45 88             	mov    -0x78(%ebp),%eax
c01043dc:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01043df:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01043e2:	81 7d ec 18 8b 12 c0 	cmpl   $0xc0128b18,-0x14(%ebp)
c01043e9:	75 c9                	jne    c01043b4 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01043eb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043ef:	74 24                	je     c0104415 <default_check+0x627>
c01043f1:	c7 44 24 0c 66 ac 10 	movl   $0xc010ac66,0xc(%esp)
c01043f8:	c0 
c01043f9:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c0104400:	c0 
c0104401:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c0104408:	00 
c0104409:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c0104410:	e8 ab c8 ff ff       	call   c0100cc0 <__panic>
    assert(total == 0);
c0104415:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104419:	74 24                	je     c010443f <default_check+0x651>
c010441b:	c7 44 24 0c 71 ac 10 	movl   $0xc010ac71,0xc(%esp)
c0104422:	c0 
c0104423:	c7 44 24 08 36 a9 10 	movl   $0xc010a936,0x8(%esp)
c010442a:	c0 
c010442b:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0104432:	00 
c0104433:	c7 04 24 4b a9 10 c0 	movl   $0xc010a94b,(%esp)
c010443a:	e8 81 c8 ff ff       	call   c0100cc0 <__panic>
}
c010443f:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104445:	5b                   	pop    %ebx
c0104446:	5d                   	pop    %ebp
c0104447:	c3                   	ret    

c0104448 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104448:	55                   	push   %ebp
c0104449:	89 e5                	mov    %esp,%ebp
c010444b:	53                   	push   %ebx
c010444c:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c010444f:	9c                   	pushf  
c0104450:	5b                   	pop    %ebx
c0104451:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0104454:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104457:	25 00 02 00 00       	and    $0x200,%eax
c010445c:	85 c0                	test   %eax,%eax
c010445e:	74 0c                	je     c010446c <__intr_save+0x24>
        intr_disable();
c0104460:	e8 89 db ff ff       	call   c0101fee <intr_disable>
        return 1;
c0104465:	b8 01 00 00 00       	mov    $0x1,%eax
c010446a:	eb 05                	jmp    c0104471 <__intr_save+0x29>
    }
    return 0;
c010446c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104471:	83 c4 14             	add    $0x14,%esp
c0104474:	5b                   	pop    %ebx
c0104475:	5d                   	pop    %ebp
c0104476:	c3                   	ret    

c0104477 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104477:	55                   	push   %ebp
c0104478:	89 e5                	mov    %esp,%ebp
c010447a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c010447d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104481:	74 05                	je     c0104488 <__intr_restore+0x11>
        intr_enable();
c0104483:	e8 60 db ff ff       	call   c0101fe8 <intr_enable>
    }
}
c0104488:	c9                   	leave  
c0104489:	c3                   	ret    

c010448a <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c010448a:	55                   	push   %ebp
c010448b:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010448d:	8b 55 08             	mov    0x8(%ebp),%edx
c0104490:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c0104495:	89 d1                	mov    %edx,%ecx
c0104497:	29 c1                	sub    %eax,%ecx
c0104499:	89 c8                	mov    %ecx,%eax
c010449b:	c1 f8 05             	sar    $0x5,%eax
}
c010449e:	5d                   	pop    %ebp
c010449f:	c3                   	ret    

c01044a0 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01044a0:	55                   	push   %ebp
c01044a1:	89 e5                	mov    %esp,%ebp
c01044a3:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01044a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01044a9:	89 04 24             	mov    %eax,(%esp)
c01044ac:	e8 d9 ff ff ff       	call   c010448a <page2ppn>
c01044b1:	c1 e0 0c             	shl    $0xc,%eax
}
c01044b4:	c9                   	leave  
c01044b5:	c3                   	ret    

c01044b6 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01044b6:	55                   	push   %ebp
c01044b7:	89 e5                	mov    %esp,%ebp
c01044b9:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01044bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01044bf:	89 c2                	mov    %eax,%edx
c01044c1:	c1 ea 0c             	shr    $0xc,%edx
c01044c4:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c01044c9:	39 c2                	cmp    %eax,%edx
c01044cb:	72 1c                	jb     c01044e9 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01044cd:	c7 44 24 08 ac ac 10 	movl   $0xc010acac,0x8(%esp)
c01044d4:	c0 
c01044d5:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c01044dc:	00 
c01044dd:	c7 04 24 cb ac 10 c0 	movl   $0xc010accb,(%esp)
c01044e4:	e8 d7 c7 ff ff       	call   c0100cc0 <__panic>
    }
    return &pages[PPN(pa)];
c01044e9:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c01044ee:	8b 55 08             	mov    0x8(%ebp),%edx
c01044f1:	c1 ea 0c             	shr    $0xc,%edx
c01044f4:	c1 e2 05             	shl    $0x5,%edx
c01044f7:	01 d0                	add    %edx,%eax
}
c01044f9:	c9                   	leave  
c01044fa:	c3                   	ret    

c01044fb <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01044fb:	55                   	push   %ebp
c01044fc:	89 e5                	mov    %esp,%ebp
c01044fe:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104501:	8b 45 08             	mov    0x8(%ebp),%eax
c0104504:	89 04 24             	mov    %eax,(%esp)
c0104507:	e8 94 ff ff ff       	call   c01044a0 <page2pa>
c010450c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010450f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104512:	c1 e8 0c             	shr    $0xc,%eax
c0104515:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104518:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c010451d:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104520:	72 23                	jb     c0104545 <page2kva+0x4a>
c0104522:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104525:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104529:	c7 44 24 08 dc ac 10 	movl   $0xc010acdc,0x8(%esp)
c0104530:	c0 
c0104531:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104538:	00 
c0104539:	c7 04 24 cb ac 10 c0 	movl   $0xc010accb,(%esp)
c0104540:	e8 7b c7 ff ff       	call   c0100cc0 <__panic>
c0104545:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104548:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c010454d:	c9                   	leave  
c010454e:	c3                   	ret    

c010454f <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c010454f:	55                   	push   %ebp
c0104550:	89 e5                	mov    %esp,%ebp
c0104552:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104555:	8b 45 08             	mov    0x8(%ebp),%eax
c0104558:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010455b:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104562:	77 23                	ja     c0104587 <kva2page+0x38>
c0104564:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104567:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010456b:	c7 44 24 08 00 ad 10 	movl   $0xc010ad00,0x8(%esp)
c0104572:	c0 
c0104573:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c010457a:	00 
c010457b:	c7 04 24 cb ac 10 c0 	movl   $0xc010accb,(%esp)
c0104582:	e8 39 c7 ff ff       	call   c0100cc0 <__panic>
c0104587:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010458a:	05 00 00 00 40       	add    $0x40000000,%eax
c010458f:	89 04 24             	mov    %eax,(%esp)
c0104592:	e8 1f ff ff ff       	call   c01044b6 <pa2page>
}
c0104597:	c9                   	leave  
c0104598:	c3                   	ret    

c0104599 <__slob_get_free_pages>:
static slob_t *slobfree = &arena;
static bigblock_t *bigblocks;


static void* __slob_get_free_pages(gfp_t gfp, int order)
{
c0104599:	55                   	push   %ebp
c010459a:	89 e5                	mov    %esp,%ebp
c010459c:	53                   	push   %ebx
c010459d:	83 ec 24             	sub    $0x24,%esp
  struct Page * page = alloc_pages(1 << order);
c01045a0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045a3:	ba 01 00 00 00       	mov    $0x1,%edx
c01045a8:	89 d3                	mov    %edx,%ebx
c01045aa:	89 c1                	mov    %eax,%ecx
c01045ac:	d3 e3                	shl    %cl,%ebx
c01045ae:	89 d8                	mov    %ebx,%eax
c01045b0:	89 04 24             	mov    %eax,(%esp)
c01045b3:	e8 15 09 00 00       	call   c0104ecd <alloc_pages>
c01045b8:	89 45 f4             	mov    %eax,-0xc(%ebp)
  if(!page)
c01045bb:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01045bf:	75 07                	jne    c01045c8 <__slob_get_free_pages+0x2f>
    return NULL;
c01045c1:	b8 00 00 00 00       	mov    $0x0,%eax
c01045c6:	eb 0b                	jmp    c01045d3 <__slob_get_free_pages+0x3a>
  return page2kva(page);
c01045c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01045cb:	89 04 24             	mov    %eax,(%esp)
c01045ce:	e8 28 ff ff ff       	call   c01044fb <page2kva>
}
c01045d3:	83 c4 24             	add    $0x24,%esp
c01045d6:	5b                   	pop    %ebx
c01045d7:	5d                   	pop    %ebp
c01045d8:	c3                   	ret    

c01045d9 <__slob_free_pages>:

#define __slob_get_free_page(gfp) __slob_get_free_pages(gfp, 0)

static inline void __slob_free_pages(unsigned long kva, int order)
{
c01045d9:	55                   	push   %ebp
c01045da:	89 e5                	mov    %esp,%ebp
c01045dc:	53                   	push   %ebx
c01045dd:	83 ec 14             	sub    $0x14,%esp
  free_pages(kva2page(kva), 1 << order);
c01045e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01045e3:	ba 01 00 00 00       	mov    $0x1,%edx
c01045e8:	89 d3                	mov    %edx,%ebx
c01045ea:	89 c1                	mov    %eax,%ecx
c01045ec:	d3 e3                	shl    %cl,%ebx
c01045ee:	89 d8                	mov    %ebx,%eax
c01045f0:	89 c3                	mov    %eax,%ebx
c01045f2:	8b 45 08             	mov    0x8(%ebp),%eax
c01045f5:	89 04 24             	mov    %eax,(%esp)
c01045f8:	e8 52 ff ff ff       	call   c010454f <kva2page>
c01045fd:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104601:	89 04 24             	mov    %eax,(%esp)
c0104604:	e8 2f 09 00 00       	call   c0104f38 <free_pages>
}
c0104609:	83 c4 14             	add    $0x14,%esp
c010460c:	5b                   	pop    %ebx
c010460d:	5d                   	pop    %ebp
c010460e:	c3                   	ret    

c010460f <slob_alloc>:

static void slob_free(void *b, int size);

static void *slob_alloc(size_t size, gfp_t gfp, int align)
{
c010460f:	55                   	push   %ebp
c0104610:	89 e5                	mov    %esp,%ebp
c0104612:	83 ec 38             	sub    $0x38,%esp
  assert( (size + SLOB_UNIT) < PAGE_SIZE );
c0104615:	8b 45 08             	mov    0x8(%ebp),%eax
c0104618:	83 c0 08             	add    $0x8,%eax
c010461b:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0104620:	76 24                	jbe    c0104646 <slob_alloc+0x37>
c0104622:	c7 44 24 0c 24 ad 10 	movl   $0xc010ad24,0xc(%esp)
c0104629:	c0 
c010462a:	c7 44 24 08 43 ad 10 	movl   $0xc010ad43,0x8(%esp)
c0104631:	c0 
c0104632:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c0104639:	00 
c010463a:	c7 04 24 58 ad 10 c0 	movl   $0xc010ad58,(%esp)
c0104641:	e8 7a c6 ff ff       	call   c0100cc0 <__panic>

	slob_t *prev, *cur, *aligned = 0;
c0104646:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
c010464d:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0104654:	8b 45 08             	mov    0x8(%ebp),%eax
c0104657:	83 c0 07             	add    $0x7,%eax
c010465a:	c1 e8 03             	shr    $0x3,%eax
c010465d:	89 45 e0             	mov    %eax,-0x20(%ebp)
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
c0104660:	e8 e3 fd ff ff       	call   c0104448 <__intr_save>
c0104665:	89 45 e4             	mov    %eax,-0x1c(%ebp)
	prev = slobfree;
c0104668:	a1 08 5a 12 c0       	mov    0xc0125a08,%eax
c010466d:	89 45 f4             	mov    %eax,-0xc(%ebp)
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c0104670:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104673:	8b 40 04             	mov    0x4(%eax),%eax
c0104676:	89 45 f0             	mov    %eax,-0x10(%ebp)
		if (align) {
c0104679:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010467d:	74 27                	je     c01046a6 <slob_alloc+0x97>
			aligned = (slob_t *)ALIGN((unsigned long)cur, align);
c010467f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0104682:	8b 45 10             	mov    0x10(%ebp),%eax
c0104685:	01 d0                	add    %edx,%eax
c0104687:	8d 50 ff             	lea    -0x1(%eax),%edx
c010468a:	8b 45 10             	mov    0x10(%ebp),%eax
c010468d:	f7 d8                	neg    %eax
c010468f:	21 d0                	and    %edx,%eax
c0104691:	89 45 ec             	mov    %eax,-0x14(%ebp)
			delta = aligned - cur;
c0104694:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104697:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010469a:	89 d1                	mov    %edx,%ecx
c010469c:	29 c1                	sub    %eax,%ecx
c010469e:	89 c8                	mov    %ecx,%eax
c01046a0:	c1 f8 03             	sar    $0x3,%eax
c01046a3:	89 45 e8             	mov    %eax,-0x18(%ebp)
		}
		if (cur->units >= units + delta) { /* room enough? */
c01046a6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046a9:	8b 00                	mov    (%eax),%eax
c01046ab:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01046ae:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c01046b1:	01 ca                	add    %ecx,%edx
c01046b3:	39 d0                	cmp    %edx,%eax
c01046b5:	0f 8c a6 00 00 00    	jl     c0104761 <slob_alloc+0x152>
			if (delta) { /* need to fragment head to align? */
c01046bb:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01046bf:	74 38                	je     c01046f9 <slob_alloc+0xea>
				aligned->units = cur->units - delta;
c01046c1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046c4:	8b 00                	mov    (%eax),%eax
c01046c6:	89 c2                	mov    %eax,%edx
c01046c8:	2b 55 e8             	sub    -0x18(%ebp),%edx
c01046cb:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046ce:	89 10                	mov    %edx,(%eax)
				aligned->next = cur->next;
c01046d0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046d3:	8b 50 04             	mov    0x4(%eax),%edx
c01046d6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046d9:	89 50 04             	mov    %edx,0x4(%eax)
				cur->next = aligned;
c01046dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046df:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01046e2:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = delta;
c01046e5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046e8:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01046eb:	89 10                	mov    %edx,(%eax)
				prev = cur;
c01046ed:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046f0:	89 45 f4             	mov    %eax,-0xc(%ebp)
				cur = aligned;
c01046f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01046f6:	89 45 f0             	mov    %eax,-0x10(%ebp)
			}

			if (cur->units == units) /* exact fit? */
c01046f9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01046fc:	8b 00                	mov    (%eax),%eax
c01046fe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0104701:	75 0e                	jne    c0104711 <slob_alloc+0x102>
				prev->next = cur->next; /* unlink */
c0104703:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104706:	8b 50 04             	mov    0x4(%eax),%edx
c0104709:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010470c:	89 50 04             	mov    %edx,0x4(%eax)
c010470f:	eb 38                	jmp    c0104749 <slob_alloc+0x13a>
			else { /* fragment */
				prev->next = cur + units;
c0104711:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104714:	c1 e0 03             	shl    $0x3,%eax
c0104717:	89 c2                	mov    %eax,%edx
c0104719:	03 55 f0             	add    -0x10(%ebp),%edx
c010471c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010471f:	89 50 04             	mov    %edx,0x4(%eax)
				prev->next->units = cur->units - units;
c0104722:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104725:	8b 40 04             	mov    0x4(%eax),%eax
c0104728:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010472b:	8b 12                	mov    (%edx),%edx
c010472d:	2b 55 e0             	sub    -0x20(%ebp),%edx
c0104730:	89 10                	mov    %edx,(%eax)
				prev->next->next = cur->next;
c0104732:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104735:	8b 40 04             	mov    0x4(%eax),%eax
c0104738:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010473b:	8b 52 04             	mov    0x4(%edx),%edx
c010473e:	89 50 04             	mov    %edx,0x4(%eax)
				cur->units = units;
c0104741:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104744:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0104747:	89 10                	mov    %edx,(%eax)
			}

			slobfree = prev;
c0104749:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010474c:	a3 08 5a 12 c0       	mov    %eax,0xc0125a08
			spin_unlock_irqrestore(&slob_lock, flags);
c0104751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104754:	89 04 24             	mov    %eax,(%esp)
c0104757:	e8 1b fd ff ff       	call   c0104477 <__intr_restore>
			return cur;
c010475c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010475f:	eb 7f                	jmp    c01047e0 <slob_alloc+0x1d1>
		}
		if (cur == slobfree) {
c0104761:	a1 08 5a 12 c0       	mov    0xc0125a08,%eax
c0104766:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104769:	75 61                	jne    c01047cc <slob_alloc+0x1bd>
			spin_unlock_irqrestore(&slob_lock, flags);
c010476b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010476e:	89 04 24             	mov    %eax,(%esp)
c0104771:	e8 01 fd ff ff       	call   c0104477 <__intr_restore>

			if (size == PAGE_SIZE) /* trying to shrink arena? */
c0104776:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c010477d:	75 07                	jne    c0104786 <slob_alloc+0x177>
				return 0;
c010477f:	b8 00 00 00 00       	mov    $0x0,%eax
c0104784:	eb 5a                	jmp    c01047e0 <slob_alloc+0x1d1>

			cur = (slob_t *)__slob_get_free_page(gfp);
c0104786:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010478d:	00 
c010478e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104791:	89 04 24             	mov    %eax,(%esp)
c0104794:	e8 00 fe ff ff       	call   c0104599 <__slob_get_free_pages>
c0104799:	89 45 f0             	mov    %eax,-0x10(%ebp)
			if (!cur)
c010479c:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01047a0:	75 07                	jne    c01047a9 <slob_alloc+0x19a>
				return 0;
c01047a2:	b8 00 00 00 00       	mov    $0x0,%eax
c01047a7:	eb 37                	jmp    c01047e0 <slob_alloc+0x1d1>

			slob_free(cur, PAGE_SIZE);
c01047a9:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01047b0:	00 
c01047b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047b4:	89 04 24             	mov    %eax,(%esp)
c01047b7:	e8 26 00 00 00       	call   c01047e2 <slob_free>
			spin_lock_irqsave(&slob_lock, flags);
c01047bc:	e8 87 fc ff ff       	call   c0104448 <__intr_save>
c01047c1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
			cur = slobfree;
c01047c4:	a1 08 5a 12 c0       	mov    0xc0125a08,%eax
c01047c9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	int delta = 0, units = SLOB_UNITS(size);
	unsigned long flags;

	spin_lock_irqsave(&slob_lock, flags);
	prev = slobfree;
	for (cur = prev->next; ; prev = cur, cur = cur->next) {
c01047cc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01047d2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047d5:	8b 40 04             	mov    0x4(%eax),%eax
c01047d8:	89 45 f0             	mov    %eax,-0x10(%ebp)

			slob_free(cur, PAGE_SIZE);
			spin_lock_irqsave(&slob_lock, flags);
			cur = slobfree;
		}
	}
c01047db:	e9 99 fe ff ff       	jmp    c0104679 <slob_alloc+0x6a>
}
c01047e0:	c9                   	leave  
c01047e1:	c3                   	ret    

c01047e2 <slob_free>:

static void slob_free(void *block, int size)
{
c01047e2:	55                   	push   %ebp
c01047e3:	89 e5                	mov    %esp,%ebp
c01047e5:	83 ec 28             	sub    $0x28,%esp
	slob_t *cur, *b = (slob_t *)block;
c01047e8:	8b 45 08             	mov    0x8(%ebp),%eax
c01047eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c01047ee:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01047f2:	0f 84 f7 00 00 00    	je     c01048ef <slob_free+0x10d>
		return;

	if (size)
c01047f8:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01047fc:	74 10                	je     c010480e <slob_free+0x2c>
		b->units = SLOB_UNITS(size);
c01047fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104801:	83 c0 07             	add    $0x7,%eax
c0104804:	c1 e8 03             	shr    $0x3,%eax
c0104807:	89 c2                	mov    %eax,%edx
c0104809:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010480c:	89 10                	mov    %edx,(%eax)

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
c010480e:	e8 35 fc ff ff       	call   c0104448 <__intr_save>
c0104813:	89 45 ec             	mov    %eax,-0x14(%ebp)
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c0104816:	a1 08 5a 12 c0       	mov    0xc0125a08,%eax
c010481b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010481e:	eb 27                	jmp    c0104847 <slob_free+0x65>
		if (cur >= cur->next && (b > cur || b < cur->next))
c0104820:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104823:	8b 40 04             	mov    0x4(%eax),%eax
c0104826:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104829:	77 13                	ja     c010483e <slob_free+0x5c>
c010482b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010482e:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0104831:	77 27                	ja     c010485a <slob_free+0x78>
c0104833:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104836:	8b 40 04             	mov    0x4(%eax),%eax
c0104839:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010483c:	77 1c                	ja     c010485a <slob_free+0x78>
	if (size)
		b->units = SLOB_UNITS(size);

	/* Find reinsertion point */
	spin_lock_irqsave(&slob_lock, flags);
	for (cur = slobfree; !(b > cur && b < cur->next); cur = cur->next)
c010483e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104841:	8b 40 04             	mov    0x4(%eax),%eax
c0104844:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104847:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010484a:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010484d:	76 d1                	jbe    c0104820 <slob_free+0x3e>
c010484f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104852:	8b 40 04             	mov    0x4(%eax),%eax
c0104855:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0104858:	76 c6                	jbe    c0104820 <slob_free+0x3e>
		if (cur >= cur->next && (b > cur || b < cur->next))
			break;

	if (b + b->units == cur->next) {
c010485a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010485d:	8b 00                	mov    (%eax),%eax
c010485f:	c1 e0 03             	shl    $0x3,%eax
c0104862:	89 c2                	mov    %eax,%edx
c0104864:	03 55 f0             	add    -0x10(%ebp),%edx
c0104867:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010486a:	8b 40 04             	mov    0x4(%eax),%eax
c010486d:	39 c2                	cmp    %eax,%edx
c010486f:	75 25                	jne    c0104896 <slob_free+0xb4>
		b->units += cur->next->units;
c0104871:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104874:	8b 10                	mov    (%eax),%edx
c0104876:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104879:	8b 40 04             	mov    0x4(%eax),%eax
c010487c:	8b 00                	mov    (%eax),%eax
c010487e:	01 c2                	add    %eax,%edx
c0104880:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104883:	89 10                	mov    %edx,(%eax)
		b->next = cur->next->next;
c0104885:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104888:	8b 40 04             	mov    0x4(%eax),%eax
c010488b:	8b 50 04             	mov    0x4(%eax),%edx
c010488e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104891:	89 50 04             	mov    %edx,0x4(%eax)
c0104894:	eb 0c                	jmp    c01048a2 <slob_free+0xc0>
	} else
		b->next = cur->next;
c0104896:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104899:	8b 50 04             	mov    0x4(%eax),%edx
c010489c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010489f:	89 50 04             	mov    %edx,0x4(%eax)

	if (cur + cur->units == b) {
c01048a2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048a5:	8b 00                	mov    (%eax),%eax
c01048a7:	c1 e0 03             	shl    $0x3,%eax
c01048aa:	03 45 f4             	add    -0xc(%ebp),%eax
c01048ad:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01048b0:	75 1f                	jne    c01048d1 <slob_free+0xef>
		cur->units += b->units;
c01048b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048b5:	8b 10                	mov    (%eax),%edx
c01048b7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048ba:	8b 00                	mov    (%eax),%eax
c01048bc:	01 c2                	add    %eax,%edx
c01048be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048c1:	89 10                	mov    %edx,(%eax)
		cur->next = b->next;
c01048c3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01048c6:	8b 50 04             	mov    0x4(%eax),%edx
c01048c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048cc:	89 50 04             	mov    %edx,0x4(%eax)
c01048cf:	eb 09                	jmp    c01048da <slob_free+0xf8>
	} else
		cur->next = b;
c01048d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01048d7:	89 50 04             	mov    %edx,0x4(%eax)

	slobfree = cur;
c01048da:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01048dd:	a3 08 5a 12 c0       	mov    %eax,0xc0125a08

	spin_unlock_irqrestore(&slob_lock, flags);
c01048e2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01048e5:	89 04 24             	mov    %eax,(%esp)
c01048e8:	e8 8a fb ff ff       	call   c0104477 <__intr_restore>
c01048ed:	eb 01                	jmp    c01048f0 <slob_free+0x10e>
{
	slob_t *cur, *b = (slob_t *)block;
	unsigned long flags;

	if (!block)
		return;
c01048ef:	90                   	nop
		cur->next = b;

	slobfree = cur;

	spin_unlock_irqrestore(&slob_lock, flags);
}
c01048f0:	c9                   	leave  
c01048f1:	c3                   	ret    

c01048f2 <slob_init>:



void
slob_init(void) {
c01048f2:	55                   	push   %ebp
c01048f3:	89 e5                	mov    %esp,%ebp
c01048f5:	83 ec 18             	sub    $0x18,%esp
  cprintf("use SLOB allocator\n");
c01048f8:	c7 04 24 6a ad 10 c0 	movl   $0xc010ad6a,(%esp)
c01048ff:	e8 5b ba ff ff       	call   c010035f <cprintf>
}
c0104904:	c9                   	leave  
c0104905:	c3                   	ret    

c0104906 <kmalloc_init>:

inline void 
kmalloc_init(void) {
c0104906:	55                   	push   %ebp
c0104907:	89 e5                	mov    %esp,%ebp
c0104909:	83 ec 18             	sub    $0x18,%esp
    slob_init();
c010490c:	e8 e1 ff ff ff       	call   c01048f2 <slob_init>
    cprintf("kmalloc_init() succeeded!\n");
c0104911:	c7 04 24 7e ad 10 c0 	movl   $0xc010ad7e,(%esp)
c0104918:	e8 42 ba ff ff       	call   c010035f <cprintf>
}
c010491d:	c9                   	leave  
c010491e:	c3                   	ret    

c010491f <slob_allocated>:

size_t
slob_allocated(void) {
c010491f:	55                   	push   %ebp
c0104920:	89 e5                	mov    %esp,%ebp
  return 0;
c0104922:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104927:	5d                   	pop    %ebp
c0104928:	c3                   	ret    

c0104929 <kallocated>:

size_t
kallocated(void) {
c0104929:	55                   	push   %ebp
c010492a:	89 e5                	mov    %esp,%ebp
   return slob_allocated();
c010492c:	e8 ee ff ff ff       	call   c010491f <slob_allocated>
}
c0104931:	5d                   	pop    %ebp
c0104932:	c3                   	ret    

c0104933 <find_order>:

static int find_order(int size)
{
c0104933:	55                   	push   %ebp
c0104934:	89 e5                	mov    %esp,%ebp
c0104936:	83 ec 10             	sub    $0x10,%esp
	int order = 0;
c0104939:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
	for ( ; size > 4096 ; size >>=1)
c0104940:	eb 07                	jmp    c0104949 <find_order+0x16>
		order++;
c0104942:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
}

static int find_order(int size)
{
	int order = 0;
	for ( ; size > 4096 ; size >>=1)
c0104946:	d1 7d 08             	sarl   0x8(%ebp)
c0104949:	81 7d 08 00 10 00 00 	cmpl   $0x1000,0x8(%ebp)
c0104950:	7f f0                	jg     c0104942 <find_order+0xf>
		order++;
	return order;
c0104952:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0104955:	c9                   	leave  
c0104956:	c3                   	ret    

c0104957 <__kmalloc>:

static void *__kmalloc(size_t size, gfp_t gfp)
{
c0104957:	55                   	push   %ebp
c0104958:	89 e5                	mov    %esp,%ebp
c010495a:	83 ec 28             	sub    $0x28,%esp
	slob_t *m;
	bigblock_t *bb;
	unsigned long flags;

	if (size < PAGE_SIZE - SLOB_UNIT) {
c010495d:	81 7d 08 f7 0f 00 00 	cmpl   $0xff7,0x8(%ebp)
c0104964:	77 38                	ja     c010499e <__kmalloc+0x47>
		m = slob_alloc(size + SLOB_UNIT, gfp, 0);
c0104966:	8b 45 08             	mov    0x8(%ebp),%eax
c0104969:	8d 50 08             	lea    0x8(%eax),%edx
c010496c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104973:	00 
c0104974:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104977:	89 44 24 04          	mov    %eax,0x4(%esp)
c010497b:	89 14 24             	mov    %edx,(%esp)
c010497e:	e8 8c fc ff ff       	call   c010460f <slob_alloc>
c0104983:	89 45 f4             	mov    %eax,-0xc(%ebp)
		return m ? (void *)(m + 1) : 0;
c0104986:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010498a:	74 08                	je     c0104994 <__kmalloc+0x3d>
c010498c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010498f:	83 c0 08             	add    $0x8,%eax
c0104992:	eb 05                	jmp    c0104999 <__kmalloc+0x42>
c0104994:	b8 00 00 00 00       	mov    $0x0,%eax
c0104999:	e9 a6 00 00 00       	jmp    c0104a44 <__kmalloc+0xed>
	}

	bb = slob_alloc(sizeof(bigblock_t), gfp, 0);
c010499e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01049a5:	00 
c01049a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049a9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01049ad:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
c01049b4:	e8 56 fc ff ff       	call   c010460f <slob_alloc>
c01049b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
	if (!bb)
c01049bc:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01049c0:	75 07                	jne    c01049c9 <__kmalloc+0x72>
		return 0;
c01049c2:	b8 00 00 00 00       	mov    $0x0,%eax
c01049c7:	eb 7b                	jmp    c0104a44 <__kmalloc+0xed>

	bb->order = find_order(size);
c01049c9:	8b 45 08             	mov    0x8(%ebp),%eax
c01049cc:	89 04 24             	mov    %eax,(%esp)
c01049cf:	e8 5f ff ff ff       	call   c0104933 <find_order>
c01049d4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01049d7:	89 02                	mov    %eax,(%edx)
	bb->pages = (void *)__slob_get_free_pages(gfp, bb->order);
c01049d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049dc:	8b 00                	mov    (%eax),%eax
c01049de:	89 44 24 04          	mov    %eax,0x4(%esp)
c01049e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01049e5:	89 04 24             	mov    %eax,(%esp)
c01049e8:	e8 ac fb ff ff       	call   c0104599 <__slob_get_free_pages>
c01049ed:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01049f0:	89 42 04             	mov    %eax,0x4(%edx)

	if (bb->pages) {
c01049f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01049f6:	8b 40 04             	mov    0x4(%eax),%eax
c01049f9:	85 c0                	test   %eax,%eax
c01049fb:	74 2f                	je     c0104a2c <__kmalloc+0xd5>
		spin_lock_irqsave(&block_lock, flags);
c01049fd:	e8 46 fa ff ff       	call   c0104448 <__intr_save>
c0104a02:	89 45 ec             	mov    %eax,-0x14(%ebp)
		bb->next = bigblocks;
c0104a05:	8b 15 24 6a 12 c0    	mov    0xc0126a24,%edx
c0104a0b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a0e:	89 50 08             	mov    %edx,0x8(%eax)
		bigblocks = bb;
c0104a11:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a14:	a3 24 6a 12 c0       	mov    %eax,0xc0126a24
		spin_unlock_irqrestore(&block_lock, flags);
c0104a19:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104a1c:	89 04 24             	mov    %eax,(%esp)
c0104a1f:	e8 53 fa ff ff       	call   c0104477 <__intr_restore>
		return bb->pages;
c0104a24:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a27:	8b 40 04             	mov    0x4(%eax),%eax
c0104a2a:	eb 18                	jmp    c0104a44 <__kmalloc+0xed>
	}

	slob_free(bb, sizeof(bigblock_t));
c0104a2c:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104a33:	00 
c0104a34:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104a37:	89 04 24             	mov    %eax,(%esp)
c0104a3a:	e8 a3 fd ff ff       	call   c01047e2 <slob_free>
	return 0;
c0104a3f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104a44:	c9                   	leave  
c0104a45:	c3                   	ret    

c0104a46 <kmalloc>:

void *
kmalloc(size_t size)
{
c0104a46:	55                   	push   %ebp
c0104a47:	89 e5                	mov    %esp,%ebp
c0104a49:	83 ec 18             	sub    $0x18,%esp
  return __kmalloc(size, 0);
c0104a4c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104a53:	00 
c0104a54:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a57:	89 04 24             	mov    %eax,(%esp)
c0104a5a:	e8 f8 fe ff ff       	call   c0104957 <__kmalloc>
}
c0104a5f:	c9                   	leave  
c0104a60:	c3                   	ret    

c0104a61 <kfree>:


void kfree(void *block)
{
c0104a61:	55                   	push   %ebp
c0104a62:	89 e5                	mov    %esp,%ebp
c0104a64:	83 ec 28             	sub    $0x28,%esp
	bigblock_t *bb, **last = &bigblocks;
c0104a67:	c7 45 f0 24 6a 12 c0 	movl   $0xc0126a24,-0x10(%ebp)
	unsigned long flags;

	if (!block)
c0104a6e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104a72:	0f 84 a4 00 00 00    	je     c0104b1c <kfree+0xbb>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104a78:	8b 45 08             	mov    0x8(%ebp),%eax
c0104a7b:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104a80:	85 c0                	test   %eax,%eax
c0104a82:	75 7f                	jne    c0104b03 <kfree+0xa2>
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
c0104a84:	e8 bf f9 ff ff       	call   c0104448 <__intr_save>
c0104a89:	89 45 ec             	mov    %eax,-0x14(%ebp)
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104a8c:	a1 24 6a 12 c0       	mov    0xc0126a24,%eax
c0104a91:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104a94:	eb 5c                	jmp    c0104af2 <kfree+0x91>
			if (bb->pages == block) {
c0104a96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104a99:	8b 40 04             	mov    0x4(%eax),%eax
c0104a9c:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104a9f:	75 3f                	jne    c0104ae0 <kfree+0x7f>
				*last = bb->next;
c0104aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aa4:	8b 50 08             	mov    0x8(%eax),%edx
c0104aa7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104aaa:	89 10                	mov    %edx,(%eax)
				spin_unlock_irqrestore(&block_lock, flags);
c0104aac:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104aaf:	89 04 24             	mov    %eax,(%esp)
c0104ab2:	e8 c0 f9 ff ff       	call   c0104477 <__intr_restore>
				__slob_free_pages((unsigned long)block, bb->order);
c0104ab7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aba:	8b 10                	mov    (%eax),%edx
c0104abc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104abf:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104ac3:	89 04 24             	mov    %eax,(%esp)
c0104ac6:	e8 0e fb ff ff       	call   c01045d9 <__slob_free_pages>
				slob_free(bb, sizeof(bigblock_t));
c0104acb:	c7 44 24 04 0c 00 00 	movl   $0xc,0x4(%esp)
c0104ad2:	00 
c0104ad3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ad6:	89 04 24             	mov    %eax,(%esp)
c0104ad9:	e8 04 fd ff ff       	call   c01047e2 <slob_free>
				return;
c0104ade:	eb 3d                	jmp    c0104b1d <kfree+0xbc>
		return;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		/* might be on the big block list */
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; last = &bb->next, bb = bb->next) {
c0104ae0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104ae3:	83 c0 08             	add    $0x8,%eax
c0104ae6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104ae9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104aec:	8b 40 08             	mov    0x8(%eax),%eax
c0104aef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104af2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104af6:	75 9e                	jne    c0104a96 <kfree+0x35>
				__slob_free_pages((unsigned long)block, bb->order);
				slob_free(bb, sizeof(bigblock_t));
				return;
			}
		}
		spin_unlock_irqrestore(&block_lock, flags);
c0104af8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104afb:	89 04 24             	mov    %eax,(%esp)
c0104afe:	e8 74 f9 ff ff       	call   c0104477 <__intr_restore>
	}

	slob_free((slob_t *)block - 1, 0);
c0104b03:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b06:	83 e8 08             	sub    $0x8,%eax
c0104b09:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104b10:	00 
c0104b11:	89 04 24             	mov    %eax,(%esp)
c0104b14:	e8 c9 fc ff ff       	call   c01047e2 <slob_free>
	return;
c0104b19:	90                   	nop
c0104b1a:	eb 01                	jmp    c0104b1d <kfree+0xbc>
{
	bigblock_t *bb, **last = &bigblocks;
	unsigned long flags;

	if (!block)
		return;
c0104b1c:	90                   	nop
		spin_unlock_irqrestore(&block_lock, flags);
	}

	slob_free((slob_t *)block - 1, 0);
	return;
}
c0104b1d:	c9                   	leave  
c0104b1e:	c3                   	ret    

c0104b1f <ksize>:


unsigned int ksize(const void *block)
{
c0104b1f:	55                   	push   %ebp
c0104b20:	89 e5                	mov    %esp,%ebp
c0104b22:	53                   	push   %ebx
c0104b23:	83 ec 24             	sub    $0x24,%esp
	bigblock_t *bb;
	unsigned long flags;

	if (!block)
c0104b26:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104b2a:	75 07                	jne    c0104b33 <ksize+0x14>
		return 0;
c0104b2c:	b8 00 00 00 00       	mov    $0x0,%eax
c0104b31:	eb 6d                	jmp    c0104ba0 <ksize+0x81>

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
c0104b33:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b36:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104b3b:	85 c0                	test   %eax,%eax
c0104b3d:	75 56                	jne    c0104b95 <ksize+0x76>
		spin_lock_irqsave(&block_lock, flags);
c0104b3f:	e8 04 f9 ff ff       	call   c0104448 <__intr_save>
c0104b44:	89 45 f0             	mov    %eax,-0x10(%ebp)
		for (bb = bigblocks; bb; bb = bb->next)
c0104b47:	a1 24 6a 12 c0       	mov    0xc0126a24,%eax
c0104b4c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b4f:	eb 33                	jmp    c0104b84 <ksize+0x65>
			if (bb->pages == block) {
c0104b51:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b54:	8b 40 04             	mov    0x4(%eax),%eax
c0104b57:	3b 45 08             	cmp    0x8(%ebp),%eax
c0104b5a:	75 1f                	jne    c0104b7b <ksize+0x5c>
				spin_unlock_irqrestore(&slob_lock, flags);
c0104b5c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b5f:	89 04 24             	mov    %eax,(%esp)
c0104b62:	e8 10 f9 ff ff       	call   c0104477 <__intr_restore>
				return PAGE_SIZE << bb->order;
c0104b67:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b6a:	8b 00                	mov    (%eax),%eax
c0104b6c:	ba 00 10 00 00       	mov    $0x1000,%edx
c0104b71:	89 d3                	mov    %edx,%ebx
c0104b73:	89 c1                	mov    %eax,%ecx
c0104b75:	d3 e3                	shl    %cl,%ebx
c0104b77:	89 d8                	mov    %ebx,%eax
c0104b79:	eb 25                	jmp    c0104ba0 <ksize+0x81>
	if (!block)
		return 0;

	if (!((unsigned long)block & (PAGE_SIZE-1))) {
		spin_lock_irqsave(&block_lock, flags);
		for (bb = bigblocks; bb; bb = bb->next)
c0104b7b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104b7e:	8b 40 08             	mov    0x8(%eax),%eax
c0104b81:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104b84:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104b88:	75 c7                	jne    c0104b51 <ksize+0x32>
			if (bb->pages == block) {
				spin_unlock_irqrestore(&slob_lock, flags);
				return PAGE_SIZE << bb->order;
			}
		spin_unlock_irqrestore(&block_lock, flags);
c0104b8a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104b8d:	89 04 24             	mov    %eax,(%esp)
c0104b90:	e8 e2 f8 ff ff       	call   c0104477 <__intr_restore>
	}

	return ((slob_t *)block - 1)->units * SLOB_UNIT;
c0104b95:	8b 45 08             	mov    0x8(%ebp),%eax
c0104b98:	83 e8 08             	sub    $0x8,%eax
c0104b9b:	8b 00                	mov    (%eax),%eax
c0104b9d:	c1 e0 03             	shl    $0x3,%eax
}
c0104ba0:	83 c4 24             	add    $0x24,%esp
c0104ba3:	5b                   	pop    %ebx
c0104ba4:	5d                   	pop    %ebp
c0104ba5:	c3                   	ret    
	...

c0104ba8 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104ba8:	55                   	push   %ebp
c0104ba9:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0104bab:	8b 55 08             	mov    0x8(%ebp),%edx
c0104bae:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c0104bb3:	89 d1                	mov    %edx,%ecx
c0104bb5:	29 c1                	sub    %eax,%ecx
c0104bb7:	89 c8                	mov    %ecx,%eax
c0104bb9:	c1 f8 05             	sar    $0x5,%eax
}
c0104bbc:	5d                   	pop    %ebp
c0104bbd:	c3                   	ret    

c0104bbe <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0104bbe:	55                   	push   %ebp
c0104bbf:	89 e5                	mov    %esp,%ebp
c0104bc1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104bc4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bc7:	89 04 24             	mov    %eax,(%esp)
c0104bca:	e8 d9 ff ff ff       	call   c0104ba8 <page2ppn>
c0104bcf:	c1 e0 0c             	shl    $0xc,%eax
}
c0104bd2:	c9                   	leave  
c0104bd3:	c3                   	ret    

c0104bd4 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104bd4:	55                   	push   %ebp
c0104bd5:	89 e5                	mov    %esp,%ebp
c0104bd7:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0104bda:	8b 45 08             	mov    0x8(%ebp),%eax
c0104bdd:	89 c2                	mov    %eax,%edx
c0104bdf:	c1 ea 0c             	shr    $0xc,%edx
c0104be2:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0104be7:	39 c2                	cmp    %eax,%edx
c0104be9:	72 1c                	jb     c0104c07 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0104beb:	c7 44 24 08 9c ad 10 	movl   $0xc010ad9c,0x8(%esp)
c0104bf2:	c0 
c0104bf3:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0104bfa:	00 
c0104bfb:	c7 04 24 bb ad 10 c0 	movl   $0xc010adbb,(%esp)
c0104c02:	e8 b9 c0 ff ff       	call   c0100cc0 <__panic>
    }
    return &pages[PPN(pa)];
c0104c07:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c0104c0c:	8b 55 08             	mov    0x8(%ebp),%edx
c0104c0f:	c1 ea 0c             	shr    $0xc,%edx
c0104c12:	c1 e2 05             	shl    $0x5,%edx
c0104c15:	01 d0                	add    %edx,%eax
}
c0104c17:	c9                   	leave  
c0104c18:	c3                   	ret    

c0104c19 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0104c19:	55                   	push   %ebp
c0104c1a:	89 e5                	mov    %esp,%ebp
c0104c1c:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0104c1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c22:	89 04 24             	mov    %eax,(%esp)
c0104c25:	e8 94 ff ff ff       	call   c0104bbe <page2pa>
c0104c2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104c2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c30:	c1 e8 0c             	shr    $0xc,%eax
c0104c33:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104c36:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0104c3b:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0104c3e:	72 23                	jb     c0104c63 <page2kva+0x4a>
c0104c40:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c43:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104c47:	c7 44 24 08 cc ad 10 	movl   $0xc010adcc,0x8(%esp)
c0104c4e:	c0 
c0104c4f:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0104c56:	00 
c0104c57:	c7 04 24 bb ad 10 c0 	movl   $0xc010adbb,(%esp)
c0104c5e:	e8 5d c0 ff ff       	call   c0100cc0 <__panic>
c0104c63:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c66:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0104c6b:	c9                   	leave  
c0104c6c:	c3                   	ret    

c0104c6d <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0104c6d:	55                   	push   %ebp
c0104c6e:	89 e5                	mov    %esp,%ebp
c0104c70:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0104c73:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c76:	83 e0 01             	and    $0x1,%eax
c0104c79:	85 c0                	test   %eax,%eax
c0104c7b:	75 1c                	jne    c0104c99 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104c7d:	c7 44 24 08 f0 ad 10 	movl   $0xc010adf0,0x8(%esp)
c0104c84:	c0 
c0104c85:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0104c8c:	00 
c0104c8d:	c7 04 24 bb ad 10 c0 	movl   $0xc010adbb,(%esp)
c0104c94:	e8 27 c0 ff ff       	call   c0100cc0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104c99:	8b 45 08             	mov    0x8(%ebp),%eax
c0104c9c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ca1:	89 04 24             	mov    %eax,(%esp)
c0104ca4:	e8 2b ff ff ff       	call   c0104bd4 <pa2page>
}
c0104ca9:	c9                   	leave  
c0104caa:	c3                   	ret    

c0104cab <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104cab:	55                   	push   %ebp
c0104cac:	89 e5                	mov    %esp,%ebp
c0104cae:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c0104cb1:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cb4:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104cb9:	89 04 24             	mov    %eax,(%esp)
c0104cbc:	e8 13 ff ff ff       	call   c0104bd4 <pa2page>
}
c0104cc1:	c9                   	leave  
c0104cc2:	c3                   	ret    

c0104cc3 <page_ref>:

static inline int
page_ref(struct Page *page) {
c0104cc3:	55                   	push   %ebp
c0104cc4:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0104cc6:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cc9:	8b 00                	mov    (%eax),%eax
}
c0104ccb:	5d                   	pop    %ebp
c0104ccc:	c3                   	ret    

c0104ccd <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c0104ccd:	55                   	push   %ebp
c0104cce:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c0104cd0:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cd3:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104cd6:	89 10                	mov    %edx,(%eax)
}
c0104cd8:	5d                   	pop    %ebp
c0104cd9:	c3                   	ret    

c0104cda <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c0104cda:	55                   	push   %ebp
c0104cdb:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c0104cdd:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ce0:	8b 00                	mov    (%eax),%eax
c0104ce2:	8d 50 01             	lea    0x1(%eax),%edx
c0104ce5:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ce8:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104cea:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ced:	8b 00                	mov    (%eax),%eax
}
c0104cef:	5d                   	pop    %ebp
c0104cf0:	c3                   	ret    

c0104cf1 <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c0104cf1:	55                   	push   %ebp
c0104cf2:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c0104cf4:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cf7:	8b 00                	mov    (%eax),%eax
c0104cf9:	8d 50 ff             	lea    -0x1(%eax),%edx
c0104cfc:	8b 45 08             	mov    0x8(%ebp),%eax
c0104cff:	89 10                	mov    %edx,(%eax)
    return page->ref;
c0104d01:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d04:	8b 00                	mov    (%eax),%eax
}
c0104d06:	5d                   	pop    %ebp
c0104d07:	c3                   	ret    

c0104d08 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0104d08:	55                   	push   %ebp
c0104d09:	89 e5                	mov    %esp,%ebp
c0104d0b:	53                   	push   %ebx
c0104d0c:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0104d0f:	9c                   	pushf  
c0104d10:	5b                   	pop    %ebx
c0104d11:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0104d14:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0104d17:	25 00 02 00 00       	and    $0x200,%eax
c0104d1c:	85 c0                	test   %eax,%eax
c0104d1e:	74 0c                	je     c0104d2c <__intr_save+0x24>
        intr_disable();
c0104d20:	e8 c9 d2 ff ff       	call   c0101fee <intr_disable>
        return 1;
c0104d25:	b8 01 00 00 00       	mov    $0x1,%eax
c0104d2a:	eb 05                	jmp    c0104d31 <__intr_save+0x29>
    }
    return 0;
c0104d2c:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0104d31:	83 c4 14             	add    $0x14,%esp
c0104d34:	5b                   	pop    %ebx
c0104d35:	5d                   	pop    %ebp
c0104d36:	c3                   	ret    

c0104d37 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104d37:	55                   	push   %ebp
c0104d38:	89 e5                	mov    %esp,%ebp
c0104d3a:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104d3d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0104d41:	74 05                	je     c0104d48 <__intr_restore+0x11>
        intr_enable();
c0104d43:	e8 a0 d2 ff ff       	call   c0101fe8 <intr_enable>
    }
}
c0104d48:	c9                   	leave  
c0104d49:	c3                   	ret    

c0104d4a <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104d4a:	55                   	push   %ebp
c0104d4b:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104d4d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d50:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c0104d53:	b8 23 00 00 00       	mov    $0x23,%eax
c0104d58:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104d5a:	b8 23 00 00 00       	mov    $0x23,%eax
c0104d5f:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c0104d61:	b8 10 00 00 00       	mov    $0x10,%eax
c0104d66:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104d68:	b8 10 00 00 00       	mov    $0x10,%eax
c0104d6d:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104d6f:	b8 10 00 00 00       	mov    $0x10,%eax
c0104d74:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104d76:	ea 7d 4d 10 c0 08 00 	ljmp   $0x8,$0xc0104d7d
}
c0104d7d:	5d                   	pop    %ebp
c0104d7e:	c3                   	ret    

c0104d7f <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104d7f:	55                   	push   %ebp
c0104d80:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c0104d82:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d85:	a3 64 6a 12 c0       	mov    %eax,0xc0126a64
}
c0104d8a:	5d                   	pop    %ebp
c0104d8b:	c3                   	ret    

c0104d8c <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104d8c:	55                   	push   %ebp
c0104d8d:	89 e5                	mov    %esp,%ebp
c0104d8f:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c0104d92:	b8 00 50 12 c0       	mov    $0xc0125000,%eax
c0104d97:	89 04 24             	mov    %eax,(%esp)
c0104d9a:	e8 e0 ff ff ff       	call   c0104d7f <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104d9f:	66 c7 05 68 6a 12 c0 	movw   $0x10,0xc0126a68
c0104da6:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104da8:	66 c7 05 48 5a 12 c0 	movw   $0x68,0xc0125a48
c0104daf:	68 00 
c0104db1:	b8 60 6a 12 c0       	mov    $0xc0126a60,%eax
c0104db6:	66 a3 4a 5a 12 c0    	mov    %ax,0xc0125a4a
c0104dbc:	b8 60 6a 12 c0       	mov    $0xc0126a60,%eax
c0104dc1:	c1 e8 10             	shr    $0x10,%eax
c0104dc4:	a2 4c 5a 12 c0       	mov    %al,0xc0125a4c
c0104dc9:	0f b6 05 4d 5a 12 c0 	movzbl 0xc0125a4d,%eax
c0104dd0:	83 e0 f0             	and    $0xfffffff0,%eax
c0104dd3:	83 c8 09             	or     $0x9,%eax
c0104dd6:	a2 4d 5a 12 c0       	mov    %al,0xc0125a4d
c0104ddb:	0f b6 05 4d 5a 12 c0 	movzbl 0xc0125a4d,%eax
c0104de2:	83 e0 ef             	and    $0xffffffef,%eax
c0104de5:	a2 4d 5a 12 c0       	mov    %al,0xc0125a4d
c0104dea:	0f b6 05 4d 5a 12 c0 	movzbl 0xc0125a4d,%eax
c0104df1:	83 e0 9f             	and    $0xffffff9f,%eax
c0104df4:	a2 4d 5a 12 c0       	mov    %al,0xc0125a4d
c0104df9:	0f b6 05 4d 5a 12 c0 	movzbl 0xc0125a4d,%eax
c0104e00:	83 c8 80             	or     $0xffffff80,%eax
c0104e03:	a2 4d 5a 12 c0       	mov    %al,0xc0125a4d
c0104e08:	0f b6 05 4e 5a 12 c0 	movzbl 0xc0125a4e,%eax
c0104e0f:	83 e0 f0             	and    $0xfffffff0,%eax
c0104e12:	a2 4e 5a 12 c0       	mov    %al,0xc0125a4e
c0104e17:	0f b6 05 4e 5a 12 c0 	movzbl 0xc0125a4e,%eax
c0104e1e:	83 e0 ef             	and    $0xffffffef,%eax
c0104e21:	a2 4e 5a 12 c0       	mov    %al,0xc0125a4e
c0104e26:	0f b6 05 4e 5a 12 c0 	movzbl 0xc0125a4e,%eax
c0104e2d:	83 e0 df             	and    $0xffffffdf,%eax
c0104e30:	a2 4e 5a 12 c0       	mov    %al,0xc0125a4e
c0104e35:	0f b6 05 4e 5a 12 c0 	movzbl 0xc0125a4e,%eax
c0104e3c:	83 c8 40             	or     $0x40,%eax
c0104e3f:	a2 4e 5a 12 c0       	mov    %al,0xc0125a4e
c0104e44:	0f b6 05 4e 5a 12 c0 	movzbl 0xc0125a4e,%eax
c0104e4b:	83 e0 7f             	and    $0x7f,%eax
c0104e4e:	a2 4e 5a 12 c0       	mov    %al,0xc0125a4e
c0104e53:	b8 60 6a 12 c0       	mov    $0xc0126a60,%eax
c0104e58:	c1 e8 18             	shr    $0x18,%eax
c0104e5b:	a2 4f 5a 12 c0       	mov    %al,0xc0125a4f

    // reload all segment registers
    lgdt(&gdt_pd);
c0104e60:	c7 04 24 50 5a 12 c0 	movl   $0xc0125a50,(%esp)
c0104e67:	e8 de fe ff ff       	call   c0104d4a <lgdt>
c0104e6c:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c0104e72:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104e76:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104e79:	c9                   	leave  
c0104e7a:	c3                   	ret    

c0104e7b <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104e7b:	55                   	push   %ebp
c0104e7c:	89 e5                	mov    %esp,%ebp
c0104e7e:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c0104e81:	c7 05 24 8b 12 c0 90 	movl   $0xc010ac90,0xc0128b24
c0104e88:	ac 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104e8b:	a1 24 8b 12 c0       	mov    0xc0128b24,%eax
c0104e90:	8b 00                	mov    (%eax),%eax
c0104e92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104e96:	c7 04 24 1c ae 10 c0 	movl   $0xc010ae1c,(%esp)
c0104e9d:	e8 bd b4 ff ff       	call   c010035f <cprintf>
    pmm_manager->init();
c0104ea2:	a1 24 8b 12 c0       	mov    0xc0128b24,%eax
c0104ea7:	8b 40 04             	mov    0x4(%eax),%eax
c0104eaa:	ff d0                	call   *%eax
}
c0104eac:	c9                   	leave  
c0104ead:	c3                   	ret    

c0104eae <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104eae:	55                   	push   %ebp
c0104eaf:	89 e5                	mov    %esp,%ebp
c0104eb1:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c0104eb4:	a1 24 8b 12 c0       	mov    0xc0128b24,%eax
c0104eb9:	8b 50 08             	mov    0x8(%eax),%edx
c0104ebc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104ebf:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104ec3:	8b 45 08             	mov    0x8(%ebp),%eax
c0104ec6:	89 04 24             	mov    %eax,(%esp)
c0104ec9:	ff d2                	call   *%edx
}
c0104ecb:	c9                   	leave  
c0104ecc:	c3                   	ret    

c0104ecd <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c0104ecd:	55                   	push   %ebp
c0104ece:	89 e5                	mov    %esp,%ebp
c0104ed0:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c0104ed3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c0104eda:	e8 29 fe ff ff       	call   c0104d08 <__intr_save>
c0104edf:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c0104ee2:	a1 24 8b 12 c0       	mov    0xc0128b24,%eax
c0104ee7:	8b 50 0c             	mov    0xc(%eax),%edx
c0104eea:	8b 45 08             	mov    0x8(%ebp),%eax
c0104eed:	89 04 24             	mov    %eax,(%esp)
c0104ef0:	ff d2                	call   *%edx
c0104ef2:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c0104ef5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ef8:	89 04 24             	mov    %eax,(%esp)
c0104efb:	e8 37 fe ff ff       	call   c0104d37 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c0104f00:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f04:	75 2d                	jne    c0104f33 <alloc_pages+0x66>
c0104f06:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c0104f0a:	77 27                	ja     c0104f33 <alloc_pages+0x66>
c0104f0c:	a1 cc 6a 12 c0       	mov    0xc0126acc,%eax
c0104f11:	85 c0                	test   %eax,%eax
c0104f13:	74 1e                	je     c0104f33 <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c0104f15:	8b 55 08             	mov    0x8(%ebp),%edx
c0104f18:	a1 0c 8c 12 c0       	mov    0xc0128c0c,%eax
c0104f1d:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0104f24:	00 
c0104f25:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104f29:	89 04 24             	mov    %eax,(%esp)
c0104f2c:	e8 76 19 00 00       	call   c01068a7 <swap_out>
    }
c0104f31:	eb a7                	jmp    c0104eda <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c0104f33:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104f36:	c9                   	leave  
c0104f37:	c3                   	ret    

c0104f38 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104f38:	55                   	push   %ebp
c0104f39:	89 e5                	mov    %esp,%ebp
c0104f3b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104f3e:	e8 c5 fd ff ff       	call   c0104d08 <__intr_save>
c0104f43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104f46:	a1 24 8b 12 c0       	mov    0xc0128b24,%eax
c0104f4b:	8b 50 10             	mov    0x10(%eax),%edx
c0104f4e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f51:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104f55:	8b 45 08             	mov    0x8(%ebp),%eax
c0104f58:	89 04 24             	mov    %eax,(%esp)
c0104f5b:	ff d2                	call   *%edx
    }
    local_intr_restore(intr_flag);
c0104f5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f60:	89 04 24             	mov    %eax,(%esp)
c0104f63:	e8 cf fd ff ff       	call   c0104d37 <__intr_restore>
}
c0104f68:	c9                   	leave  
c0104f69:	c3                   	ret    

c0104f6a <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104f6a:	55                   	push   %ebp
c0104f6b:	89 e5                	mov    %esp,%ebp
c0104f6d:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c0104f70:	e8 93 fd ff ff       	call   c0104d08 <__intr_save>
c0104f75:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104f78:	a1 24 8b 12 c0       	mov    0xc0128b24,%eax
c0104f7d:	8b 40 14             	mov    0x14(%eax),%eax
c0104f80:	ff d0                	call   *%eax
c0104f82:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c0104f85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f88:	89 04 24             	mov    %eax,(%esp)
c0104f8b:	e8 a7 fd ff ff       	call   c0104d37 <__intr_restore>
    return ret;
c0104f90:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c0104f93:	c9                   	leave  
c0104f94:	c3                   	ret    

c0104f95 <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c0104f95:	55                   	push   %ebp
c0104f96:	89 e5                	mov    %esp,%ebp
c0104f98:	57                   	push   %edi
c0104f99:	56                   	push   %esi
c0104f9a:	53                   	push   %ebx
c0104f9b:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c0104fa1:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104fa8:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104faf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104fb6:	c7 04 24 33 ae 10 c0 	movl   $0xc010ae33,(%esp)
c0104fbd:	e8 9d b3 ff ff       	call   c010035f <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c0104fc2:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104fc9:	e9 0b 01 00 00       	jmp    c01050d9 <page_init+0x144>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104fce:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104fd1:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104fd4:	89 d0                	mov    %edx,%eax
c0104fd6:	c1 e0 02             	shl    $0x2,%eax
c0104fd9:	01 d0                	add    %edx,%eax
c0104fdb:	c1 e0 02             	shl    $0x2,%eax
c0104fde:	01 c8                	add    %ecx,%eax
c0104fe0:	8b 50 08             	mov    0x8(%eax),%edx
c0104fe3:	8b 40 04             	mov    0x4(%eax),%eax
c0104fe6:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0104fe9:	89 55 bc             	mov    %edx,-0x44(%ebp)
c0104fec:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104fef:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104ff2:	89 d0                	mov    %edx,%eax
c0104ff4:	c1 e0 02             	shl    $0x2,%eax
c0104ff7:	01 d0                	add    %edx,%eax
c0104ff9:	c1 e0 02             	shl    $0x2,%eax
c0104ffc:	01 c8                	add    %ecx,%eax
c0104ffe:	8b 50 10             	mov    0x10(%eax),%edx
c0105001:	8b 40 0c             	mov    0xc(%eax),%eax
c0105004:	03 45 b8             	add    -0x48(%ebp),%eax
c0105007:	13 55 bc             	adc    -0x44(%ebp),%edx
c010500a:	89 45 b0             	mov    %eax,-0x50(%ebp)
c010500d:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c0105010:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0105013:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105016:	89 d0                	mov    %edx,%eax
c0105018:	c1 e0 02             	shl    $0x2,%eax
c010501b:	01 d0                	add    %edx,%eax
c010501d:	c1 e0 02             	shl    $0x2,%eax
c0105020:	01 c8                	add    %ecx,%eax
c0105022:	83 c0 14             	add    $0x14,%eax
c0105025:	8b 00                	mov    (%eax),%eax
c0105027:	89 45 84             	mov    %eax,-0x7c(%ebp)
c010502a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010502d:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0105030:	89 c6                	mov    %eax,%esi
c0105032:	89 d7                	mov    %edx,%edi
c0105034:	83 c6 ff             	add    $0xffffffff,%esi
c0105037:	83 d7 ff             	adc    $0xffffffff,%edi
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c010503a:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c010503d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105040:	89 d0                	mov    %edx,%eax
c0105042:	c1 e0 02             	shl    $0x2,%eax
c0105045:	01 d0                	add    %edx,%eax
c0105047:	c1 e0 02             	shl    $0x2,%eax
c010504a:	01 c8                	add    %ecx,%eax
c010504c:	8b 48 0c             	mov    0xc(%eax),%ecx
c010504f:	8b 58 10             	mov    0x10(%eax),%ebx
c0105052:	8b 45 84             	mov    -0x7c(%ebp),%eax
c0105055:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0105059:	89 74 24 14          	mov    %esi,0x14(%esp)
c010505d:	89 7c 24 18          	mov    %edi,0x18(%esp)
c0105061:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0105064:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0105067:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010506b:	89 54 24 10          	mov    %edx,0x10(%esp)
c010506f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0105073:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0105077:	c7 04 24 40 ae 10 c0 	movl   $0xc010ae40,(%esp)
c010507e:	e8 dc b2 ff ff       	call   c010035f <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c0105083:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105086:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105089:	89 d0                	mov    %edx,%eax
c010508b:	c1 e0 02             	shl    $0x2,%eax
c010508e:	01 d0                	add    %edx,%eax
c0105090:	c1 e0 02             	shl    $0x2,%eax
c0105093:	01 c8                	add    %ecx,%eax
c0105095:	83 c0 14             	add    $0x14,%eax
c0105098:	8b 00                	mov    (%eax),%eax
c010509a:	83 f8 01             	cmp    $0x1,%eax
c010509d:	75 36                	jne    c01050d5 <page_init+0x140>
            if (maxpa < end && begin < KMEMSIZE) {
c010509f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01050a2:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01050a5:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01050a8:	77 2b                	ja     c01050d5 <page_init+0x140>
c01050aa:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c01050ad:	72 05                	jb     c01050b4 <page_init+0x11f>
c01050af:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c01050b2:	73 21                	jae    c01050d5 <page_init+0x140>
c01050b4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01050b8:	77 1b                	ja     c01050d5 <page_init+0x140>
c01050ba:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01050be:	72 09                	jb     c01050c9 <page_init+0x134>
c01050c0:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01050c7:	77 0c                	ja     c01050d5 <page_init+0x140>
                maxpa = end;
c01050c9:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01050cc:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01050cf:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01050d2:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01050d5:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01050d9:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01050dc:	8b 00                	mov    (%eax),%eax
c01050de:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01050e1:	0f 8f e7 fe ff ff    	jg     c0104fce <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01050e7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01050eb:	72 1d                	jb     c010510a <page_init+0x175>
c01050ed:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01050f1:	77 09                	ja     c01050fc <page_init+0x167>
c01050f3:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01050fa:	76 0e                	jbe    c010510a <page_init+0x175>
        maxpa = KMEMSIZE;
c01050fc:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c0105103:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c010510a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010510d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105110:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0105114:	c1 ea 0c             	shr    $0xc,%edx
c0105117:	a3 40 6a 12 c0       	mov    %eax,0xc0126a40
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c010511c:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c0105123:	b8 18 8c 12 c0       	mov    $0xc0128c18,%eax
c0105128:	83 e8 01             	sub    $0x1,%eax
c010512b:	03 45 ac             	add    -0x54(%ebp),%eax
c010512e:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0105131:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0105134:	ba 00 00 00 00       	mov    $0x0,%edx
c0105139:	f7 75 ac             	divl   -0x54(%ebp)
c010513c:	89 d0                	mov    %edx,%eax
c010513e:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0105141:	89 d1                	mov    %edx,%ecx
c0105143:	29 c1                	sub    %eax,%ecx
c0105145:	89 c8                	mov    %ecx,%eax
c0105147:	a3 2c 8b 12 c0       	mov    %eax,0xc0128b2c

    for (i = 0; i < npage; i ++) {
c010514c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0105153:	eb 27                	jmp    c010517c <page_init+0x1e7>
        SetPageReserved(pages + i);
c0105155:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c010515a:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010515d:	c1 e2 05             	shl    $0x5,%edx
c0105160:	01 d0                	add    %edx,%eax
c0105162:	83 c0 04             	add    $0x4,%eax
c0105165:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c010516c:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010516f:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0105172:	8b 55 90             	mov    -0x70(%ebp),%edx
c0105175:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0105178:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010517c:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010517f:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0105184:	39 c2                	cmp    %eax,%edx
c0105186:	72 cd                	jb     c0105155 <page_init+0x1c0>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0105188:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c010518d:	89 c2                	mov    %eax,%edx
c010518f:	c1 e2 05             	shl    $0x5,%edx
c0105192:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c0105197:	01 d0                	add    %edx,%eax
c0105199:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c010519c:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c01051a3:	77 23                	ja     c01051c8 <page_init+0x233>
c01051a5:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01051a8:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01051ac:	c7 44 24 08 70 ae 10 	movl   $0xc010ae70,0x8(%esp)
c01051b3:	c0 
c01051b4:	c7 44 24 04 e9 00 00 	movl   $0xe9,0x4(%esp)
c01051bb:	00 
c01051bc:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01051c3:	e8 f8 ba ff ff       	call   c0100cc0 <__panic>
c01051c8:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c01051cb:	05 00 00 00 40       	add    $0x40000000,%eax
c01051d0:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c01051d3:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01051da:	e9 7c 01 00 00       	jmp    c010535b <page_init+0x3c6>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01051df:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01051e2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01051e5:	89 d0                	mov    %edx,%eax
c01051e7:	c1 e0 02             	shl    $0x2,%eax
c01051ea:	01 d0                	add    %edx,%eax
c01051ec:	c1 e0 02             	shl    $0x2,%eax
c01051ef:	01 c8                	add    %ecx,%eax
c01051f1:	8b 50 08             	mov    0x8(%eax),%edx
c01051f4:	8b 40 04             	mov    0x4(%eax),%eax
c01051f7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01051fa:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c01051fd:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105200:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105203:	89 d0                	mov    %edx,%eax
c0105205:	c1 e0 02             	shl    $0x2,%eax
c0105208:	01 d0                	add    %edx,%eax
c010520a:	c1 e0 02             	shl    $0x2,%eax
c010520d:	01 c8                	add    %ecx,%eax
c010520f:	8b 50 10             	mov    0x10(%eax),%edx
c0105212:	8b 40 0c             	mov    0xc(%eax),%eax
c0105215:	03 45 d0             	add    -0x30(%ebp),%eax
c0105218:	13 55 d4             	adc    -0x2c(%ebp),%edx
c010521b:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010521e:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0105221:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0105224:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105227:	89 d0                	mov    %edx,%eax
c0105229:	c1 e0 02             	shl    $0x2,%eax
c010522c:	01 d0                	add    %edx,%eax
c010522e:	c1 e0 02             	shl    $0x2,%eax
c0105231:	01 c8                	add    %ecx,%eax
c0105233:	83 c0 14             	add    $0x14,%eax
c0105236:	8b 00                	mov    (%eax),%eax
c0105238:	83 f8 01             	cmp    $0x1,%eax
c010523b:	0f 85 16 01 00 00    	jne    c0105357 <page_init+0x3c2>
            if (begin < freemem) {
c0105241:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0105244:	ba 00 00 00 00       	mov    $0x0,%edx
c0105249:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010524c:	72 17                	jb     c0105265 <page_init+0x2d0>
c010524e:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0105251:	77 05                	ja     c0105258 <page_init+0x2c3>
c0105253:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0105256:	76 0d                	jbe    c0105265 <page_init+0x2d0>
                begin = freemem;
c0105258:	8b 45 a0             	mov    -0x60(%ebp),%eax
c010525b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010525e:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0105265:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0105269:	72 1d                	jb     c0105288 <page_init+0x2f3>
c010526b:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010526f:	77 09                	ja     c010527a <page_init+0x2e5>
c0105271:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0105278:	76 0e                	jbe    c0105288 <page_init+0x2f3>
                end = KMEMSIZE;
c010527a:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0105281:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0105288:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010528b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010528e:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105291:	0f 87 c0 00 00 00    	ja     c0105357 <page_init+0x3c2>
c0105297:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010529a:	72 09                	jb     c01052a5 <page_init+0x310>
c010529c:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c010529f:	0f 83 b2 00 00 00    	jae    c0105357 <page_init+0x3c2>
                begin = ROUNDUP(begin, PGSIZE);
c01052a5:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c01052ac:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01052af:	03 45 9c             	add    -0x64(%ebp),%eax
c01052b2:	83 e8 01             	sub    $0x1,%eax
c01052b5:	89 45 98             	mov    %eax,-0x68(%ebp)
c01052b8:	8b 45 98             	mov    -0x68(%ebp),%eax
c01052bb:	ba 00 00 00 00       	mov    $0x0,%edx
c01052c0:	f7 75 9c             	divl   -0x64(%ebp)
c01052c3:	89 d0                	mov    %edx,%eax
c01052c5:	8b 55 98             	mov    -0x68(%ebp),%edx
c01052c8:	89 d1                	mov    %edx,%ecx
c01052ca:	29 c1                	sub    %eax,%ecx
c01052cc:	89 c8                	mov    %ecx,%eax
c01052ce:	ba 00 00 00 00       	mov    $0x0,%edx
c01052d3:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01052d6:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c01052d9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01052dc:	89 45 94             	mov    %eax,-0x6c(%ebp)
c01052df:	8b 45 94             	mov    -0x6c(%ebp),%eax
c01052e2:	ba 00 00 00 00       	mov    $0x0,%edx
c01052e7:	89 c1                	mov    %eax,%ecx
c01052e9:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
c01052ef:	89 8d 78 ff ff ff    	mov    %ecx,-0x88(%ebp)
c01052f5:	89 d1                	mov    %edx,%ecx
c01052f7:	83 e1 00             	and    $0x0,%ecx
c01052fa:	89 8d 7c ff ff ff    	mov    %ecx,-0x84(%ebp)
c0105300:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0105306:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c010530c:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010530f:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0105312:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105315:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105318:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c010531b:	77 3a                	ja     c0105357 <page_init+0x3c2>
c010531d:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0105320:	72 05                	jb     c0105327 <page_init+0x392>
c0105322:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0105325:	73 30                	jae    c0105357 <page_init+0x3c2>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0105327:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010532a:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c010532d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0105330:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0105333:	29 c8                	sub    %ecx,%eax
c0105335:	19 da                	sbb    %ebx,%edx
c0105337:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c010533b:	c1 ea 0c             	shr    $0xc,%edx
c010533e:	89 c3                	mov    %eax,%ebx
c0105340:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0105343:	89 04 24             	mov    %eax,(%esp)
c0105346:	e8 89 f8 ff ff       	call   c0104bd4 <pa2page>
c010534b:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c010534f:	89 04 24             	mov    %eax,(%esp)
c0105352:	e8 57 fb ff ff       	call   c0104eae <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0105357:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c010535b:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c010535e:	8b 00                	mov    (%eax),%eax
c0105360:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0105363:	0f 8f 76 fe ff ff    	jg     c01051df <page_init+0x24a>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0105369:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c010536f:	5b                   	pop    %ebx
c0105370:	5e                   	pop    %esi
c0105371:	5f                   	pop    %edi
c0105372:	5d                   	pop    %ebp
c0105373:	c3                   	ret    

c0105374 <enable_paging>:

static void
enable_paging(void) {
c0105374:	55                   	push   %ebp
c0105375:	89 e5                	mov    %esp,%ebp
c0105377:	53                   	push   %ebx
c0105378:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c010537b:	a1 28 8b 12 c0       	mov    0xc0128b28,%eax
c0105380:	89 45 f4             	mov    %eax,-0xc(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0105383:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105386:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0105389:	0f 20 c3             	mov    %cr0,%ebx
c010538c:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr0;
c010538f:	8b 45 f0             	mov    -0x10(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0105392:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0105395:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c010539c:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c01053a0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c01053a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c01053a6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01053a9:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c01053ac:	83 c4 10             	add    $0x10,%esp
c01053af:	5b                   	pop    %ebx
c01053b0:	5d                   	pop    %ebp
c01053b1:	c3                   	ret    

c01053b2 <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c01053b2:	55                   	push   %ebp
c01053b3:	89 e5                	mov    %esp,%ebp
c01053b5:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c01053b8:	8b 45 14             	mov    0x14(%ebp),%eax
c01053bb:	8b 55 0c             	mov    0xc(%ebp),%edx
c01053be:	31 d0                	xor    %edx,%eax
c01053c0:	25 ff 0f 00 00       	and    $0xfff,%eax
c01053c5:	85 c0                	test   %eax,%eax
c01053c7:	74 24                	je     c01053ed <boot_map_segment+0x3b>
c01053c9:	c7 44 24 0c a2 ae 10 	movl   $0xc010aea2,0xc(%esp)
c01053d0:	c0 
c01053d1:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c01053d8:	c0 
c01053d9:	c7 44 24 04 12 01 00 	movl   $0x112,0x4(%esp)
c01053e0:	00 
c01053e1:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01053e8:	e8 d3 b8 ff ff       	call   c0100cc0 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c01053ed:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c01053f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01053f7:	25 ff 0f 00 00       	and    $0xfff,%eax
c01053fc:	03 45 10             	add    0x10(%ebp),%eax
c01053ff:	03 45 f0             	add    -0x10(%ebp),%eax
c0105402:	83 e8 01             	sub    $0x1,%eax
c0105405:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105408:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010540b:	ba 00 00 00 00       	mov    $0x0,%edx
c0105410:	f7 75 f0             	divl   -0x10(%ebp)
c0105413:	89 d0                	mov    %edx,%eax
c0105415:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0105418:	89 d1                	mov    %edx,%ecx
c010541a:	29 c1                	sub    %eax,%ecx
c010541c:	89 c8                	mov    %ecx,%eax
c010541e:	c1 e8 0c             	shr    $0xc,%eax
c0105421:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0105424:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105427:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010542a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010542d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105432:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0105435:	8b 45 14             	mov    0x14(%ebp),%eax
c0105438:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010543b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010543e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105443:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0105446:	eb 6b                	jmp    c01054b3 <boot_map_segment+0x101>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0105448:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010544f:	00 
c0105450:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105453:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105457:	8b 45 08             	mov    0x8(%ebp),%eax
c010545a:	89 04 24             	mov    %eax,(%esp)
c010545d:	e8 d1 01 00 00       	call   c0105633 <get_pte>
c0105462:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0105465:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0105469:	75 24                	jne    c010548f <boot_map_segment+0xdd>
c010546b:	c7 44 24 0c ce ae 10 	movl   $0xc010aece,0xc(%esp)
c0105472:	c0 
c0105473:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c010547a:	c0 
c010547b:	c7 44 24 04 18 01 00 	movl   $0x118,0x4(%esp)
c0105482:	00 
c0105483:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c010548a:	e8 31 b8 ff ff       	call   c0100cc0 <__panic>
        *ptep = pa | PTE_P | perm;
c010548f:	8b 45 18             	mov    0x18(%ebp),%eax
c0105492:	8b 55 14             	mov    0x14(%ebp),%edx
c0105495:	09 d0                	or     %edx,%eax
c0105497:	89 c2                	mov    %eax,%edx
c0105499:	83 ca 01             	or     $0x1,%edx
c010549c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010549f:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c01054a1:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01054a5:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c01054ac:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c01054b3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01054b7:	75 8f                	jne    c0105448 <boot_map_segment+0x96>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c01054b9:	c9                   	leave  
c01054ba:	c3                   	ret    

c01054bb <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c01054bb:	55                   	push   %ebp
c01054bc:	89 e5                	mov    %esp,%ebp
c01054be:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c01054c1:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01054c8:	e8 00 fa ff ff       	call   c0104ecd <alloc_pages>
c01054cd:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c01054d0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01054d4:	75 1c                	jne    c01054f2 <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c01054d6:	c7 44 24 08 db ae 10 	movl   $0xc010aedb,0x8(%esp)
c01054dd:	c0 
c01054de:	c7 44 24 04 24 01 00 	movl   $0x124,0x4(%esp)
c01054e5:	00 
c01054e6:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01054ed:	e8 ce b7 ff ff       	call   c0100cc0 <__panic>
    }
    return page2kva(p);
c01054f2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054f5:	89 04 24             	mov    %eax,(%esp)
c01054f8:	e8 1c f7 ff ff       	call   c0104c19 <page2kva>
}
c01054fd:	c9                   	leave  
c01054fe:	c3                   	ret    

c01054ff <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c01054ff:	55                   	push   %ebp
c0105500:	89 e5                	mov    %esp,%ebp
c0105502:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0105505:	e8 71 f9 ff ff       	call   c0104e7b <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c010550a:	e8 86 fa ff ff       	call   c0104f95 <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c010550f:	e8 4f 05 00 00       	call   c0105a63 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0105514:	e8 a2 ff ff ff       	call   c01054bb <boot_alloc_page>
c0105519:	a3 44 6a 12 c0       	mov    %eax,0xc0126a44
    memset(boot_pgdir, 0, PGSIZE);
c010551e:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105523:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c010552a:	00 
c010552b:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105532:	00 
c0105533:	89 04 24             	mov    %eax,(%esp)
c0105536:	e8 98 49 00 00       	call   c0109ed3 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c010553b:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105540:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105543:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010554a:	77 23                	ja     c010556f <pmm_init+0x70>
c010554c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010554f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105553:	c7 44 24 08 70 ae 10 	movl   $0xc010ae70,0x8(%esp)
c010555a:	c0 
c010555b:	c7 44 24 04 3e 01 00 	movl   $0x13e,0x4(%esp)
c0105562:	00 
c0105563:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c010556a:	e8 51 b7 ff ff       	call   c0100cc0 <__panic>
c010556f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105572:	05 00 00 00 40       	add    $0x40000000,%eax
c0105577:	a3 28 8b 12 c0       	mov    %eax,0xc0128b28

    check_pgdir();
c010557c:	e8 00 05 00 00       	call   c0105a81 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0105581:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105586:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c010558c:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105591:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105594:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c010559b:	77 23                	ja     c01055c0 <pmm_init+0xc1>
c010559d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055a0:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01055a4:	c7 44 24 08 70 ae 10 	movl   $0xc010ae70,0x8(%esp)
c01055ab:	c0 
c01055ac:	c7 44 24 04 46 01 00 	movl   $0x146,0x4(%esp)
c01055b3:	00 
c01055b4:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01055bb:	e8 00 b7 ff ff       	call   c0100cc0 <__panic>
c01055c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01055c3:	05 00 00 00 40       	add    $0x40000000,%eax
c01055c8:	83 c8 03             	or     $0x3,%eax
c01055cb:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c01055cd:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c01055d2:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c01055d9:	00 
c01055da:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01055e1:	00 
c01055e2:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c01055e9:	38 
c01055ea:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c01055f1:	c0 
c01055f2:	89 04 24             	mov    %eax,(%esp)
c01055f5:	e8 b8 fd ff ff       	call   c01053b2 <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c01055fa:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c01055ff:	8b 15 44 6a 12 c0    	mov    0xc0126a44,%edx
c0105605:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c010560b:	89 10                	mov    %edx,(%eax)

    enable_paging();
c010560d:	e8 62 fd ff ff       	call   c0105374 <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0105612:	e8 75 f7 ff ff       	call   c0104d8c <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0105617:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c010561c:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0105622:	e8 f5 0a 00 00       	call   c010611c <check_boot_pgdir>

    print_pgdir();
c0105627:	e8 69 0f 00 00       	call   c0106595 <print_pgdir>
    
    kmalloc_init();
c010562c:	e8 d5 f2 ff ff       	call   c0104906 <kmalloc_init>

}
c0105631:	c9                   	leave  
c0105632:	c3                   	ret    

c0105633 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0105633:	55                   	push   %ebp
c0105634:	89 e5                	mov    %esp,%ebp
c0105636:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0105639:	8b 45 0c             	mov    0xc(%ebp),%eax
c010563c:	c1 e8 16             	shr    $0x16,%eax
c010563f:	c1 e0 02             	shl    $0x2,%eax
c0105642:	03 45 08             	add    0x8(%ebp),%eax
c0105645:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!(*pdep & PTE_P)) {
c0105648:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010564b:	8b 00                	mov    (%eax),%eax
c010564d:	83 e0 01             	and    $0x1,%eax
c0105650:	85 c0                	test   %eax,%eax
c0105652:	0f 85 c4 00 00 00    	jne    c010571c <get_pte+0xe9>
        if (!create) return NULL;
c0105658:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010565c:	75 0a                	jne    c0105668 <get_pte+0x35>
c010565e:	b8 00 00 00 00       	mov    $0x0,%eax
c0105663:	e9 10 01 00 00       	jmp    c0105778 <get_pte+0x145>
        struct Page* page;
        if (create && (page = alloc_pages(1)) == NULL) return NULL;
c0105668:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010566c:	74 1f                	je     c010568d <get_pte+0x5a>
c010566e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105675:	e8 53 f8 ff ff       	call   c0104ecd <alloc_pages>
c010567a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010567d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105681:	75 0a                	jne    c010568d <get_pte+0x5a>
c0105683:	b8 00 00 00 00       	mov    $0x0,%eax
c0105688:	e9 eb 00 00 00       	jmp    c0105778 <get_pte+0x145>
        set_page_ref(page, 1);
c010568d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105694:	00 
c0105695:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105698:	89 04 24             	mov    %eax,(%esp)
c010569b:	e8 2d f6 ff ff       	call   c0104ccd <set_page_ref>
        uintptr_t phia = page2pa(page);
c01056a0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01056a3:	89 04 24             	mov    %eax,(%esp)
c01056a6:	e8 13 f5 ff ff       	call   c0104bbe <page2pa>
c01056ab:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(phia), 0, PGSIZE);
c01056ae:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01056b1:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01056b4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056b7:	c1 e8 0c             	shr    $0xc,%eax
c01056ba:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01056bd:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c01056c2:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c01056c5:	72 23                	jb     c01056ea <get_pte+0xb7>
c01056c7:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056ca:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01056ce:	c7 44 24 08 cc ad 10 	movl   $0xc010adcc,0x8(%esp)
c01056d5:	c0 
c01056d6:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c01056dd:	00 
c01056de:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01056e5:	e8 d6 b5 ff ff       	call   c0100cc0 <__panic>
c01056ea:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01056ed:	2d 00 00 00 40       	sub    $0x40000000,%eax
c01056f2:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01056f9:	00 
c01056fa:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105701:	00 
c0105702:	89 04 24             	mov    %eax,(%esp)
c0105705:	e8 c9 47 00 00       	call   c0109ed3 <memset>
        *pdep = PDE_ADDR(phia) | PTE_U | PTE_W | PTE_P;
c010570a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010570d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105712:	89 c2                	mov    %eax,%edx
c0105714:	83 ca 07             	or     $0x7,%edx
c0105717:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010571a:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c010571c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010571f:	8b 00                	mov    (%eax),%eax
c0105721:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105726:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0105729:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010572c:	c1 e8 0c             	shr    $0xc,%eax
c010572f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105732:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0105737:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010573a:	72 23                	jb     c010575f <get_pte+0x12c>
c010573c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010573f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105743:	c7 44 24 08 cc ad 10 	movl   $0xc010adcc,0x8(%esp)
c010574a:	c0 
c010574b:	c7 44 24 04 99 01 00 	movl   $0x199,0x4(%esp)
c0105752:	00 
c0105753:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c010575a:	e8 61 b5 ff ff       	call   c0100cc0 <__panic>
c010575f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105762:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105767:	8b 55 0c             	mov    0xc(%ebp),%edx
c010576a:	c1 ea 0c             	shr    $0xc,%edx
c010576d:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0105773:	c1 e2 02             	shl    $0x2,%edx
c0105776:	01 d0                	add    %edx,%eax
}
c0105778:	c9                   	leave  
c0105779:	c3                   	ret    

c010577a <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010577a:	55                   	push   %ebp
c010577b:	89 e5                	mov    %esp,%ebp
c010577d:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105780:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105787:	00 
c0105788:	8b 45 0c             	mov    0xc(%ebp),%eax
c010578b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010578f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105792:	89 04 24             	mov    %eax,(%esp)
c0105795:	e8 99 fe ff ff       	call   c0105633 <get_pte>
c010579a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c010579d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c01057a1:	74 08                	je     c01057ab <get_page+0x31>
        *ptep_store = ptep;
c01057a3:	8b 45 10             	mov    0x10(%ebp),%eax
c01057a6:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01057a9:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c01057ab:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01057af:	74 1b                	je     c01057cc <get_page+0x52>
c01057b1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057b4:	8b 00                	mov    (%eax),%eax
c01057b6:	83 e0 01             	and    $0x1,%eax
c01057b9:	84 c0                	test   %al,%al
c01057bb:	74 0f                	je     c01057cc <get_page+0x52>
        return pte2page(*ptep);
c01057bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057c0:	8b 00                	mov    (%eax),%eax
c01057c2:	89 04 24             	mov    %eax,(%esp)
c01057c5:	e8 a3 f4 ff ff       	call   c0104c6d <pte2page>
c01057ca:	eb 05                	jmp    c01057d1 <get_page+0x57>
    }
    return NULL;
c01057cc:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01057d1:	c9                   	leave  
c01057d2:	c3                   	ret    

c01057d3 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01057d3:	55                   	push   %ebp
c01057d4:	89 e5                	mov    %esp,%ebp
c01057d6:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P){
c01057d9:	8b 45 10             	mov    0x10(%ebp),%eax
c01057dc:	8b 00                	mov    (%eax),%eax
c01057de:	83 e0 01             	and    $0x1,%eax
c01057e1:	84 c0                	test   %al,%al
c01057e3:	74 52                	je     c0105837 <page_remove_pte+0x64>
        struct Page *page = pte2page(*ptep);
c01057e5:	8b 45 10             	mov    0x10(%ebp),%eax
c01057e8:	8b 00                	mov    (%eax),%eax
c01057ea:	89 04 24             	mov    %eax,(%esp)
c01057ed:	e8 7b f4 ff ff       	call   c0104c6d <pte2page>
c01057f2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
c01057f5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01057f8:	89 04 24             	mov    %eax,(%esp)
c01057fb:	e8 f1 f4 ff ff       	call   c0104cf1 <page_ref_dec>
        if(page->ref == 0) free_page(page);
c0105800:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105803:	8b 00                	mov    (%eax),%eax
c0105805:	85 c0                	test   %eax,%eax
c0105807:	75 13                	jne    c010581c <page_remove_pte+0x49>
c0105809:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105810:	00 
c0105811:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105814:	89 04 24             	mov    %eax,(%esp)
c0105817:	e8 1c f7 ff ff       	call   c0104f38 <free_pages>
        
        *ptep = 0;
c010581c:	8b 45 10             	mov    0x10(%ebp),%eax
c010581f:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);
c0105825:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105828:	89 44 24 04          	mov    %eax,0x4(%esp)
c010582c:	8b 45 08             	mov    0x8(%ebp),%eax
c010582f:	89 04 24             	mov    %eax,(%esp)
c0105832:	e8 ff 00 00 00       	call   c0105936 <tlb_invalidate>
    }
}
c0105837:	c9                   	leave  
c0105838:	c3                   	ret    

c0105839 <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c0105839:	55                   	push   %ebp
c010583a:	89 e5                	mov    %esp,%ebp
c010583c:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c010583f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105846:	00 
c0105847:	8b 45 0c             	mov    0xc(%ebp),%eax
c010584a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010584e:	8b 45 08             	mov    0x8(%ebp),%eax
c0105851:	89 04 24             	mov    %eax,(%esp)
c0105854:	e8 da fd ff ff       	call   c0105633 <get_pte>
c0105859:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c010585c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105860:	74 19                	je     c010587b <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105862:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105865:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105869:	8b 45 0c             	mov    0xc(%ebp),%eax
c010586c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105870:	8b 45 08             	mov    0x8(%ebp),%eax
c0105873:	89 04 24             	mov    %eax,(%esp)
c0105876:	e8 58 ff ff ff       	call   c01057d3 <page_remove_pte>
    }
}
c010587b:	c9                   	leave  
c010587c:	c3                   	ret    

c010587d <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c010587d:	55                   	push   %ebp
c010587e:	89 e5                	mov    %esp,%ebp
c0105880:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105883:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010588a:	00 
c010588b:	8b 45 10             	mov    0x10(%ebp),%eax
c010588e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105892:	8b 45 08             	mov    0x8(%ebp),%eax
c0105895:	89 04 24             	mov    %eax,(%esp)
c0105898:	e8 96 fd ff ff       	call   c0105633 <get_pte>
c010589d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c01058a0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01058a4:	75 0a                	jne    c01058b0 <page_insert+0x33>
        return -E_NO_MEM;
c01058a6:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c01058ab:	e9 84 00 00 00       	jmp    c0105934 <page_insert+0xb7>
    }
    page_ref_inc(page);
c01058b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058b3:	89 04 24             	mov    %eax,(%esp)
c01058b6:	e8 1f f4 ff ff       	call   c0104cda <page_ref_inc>
    if (*ptep & PTE_P) {
c01058bb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058be:	8b 00                	mov    (%eax),%eax
c01058c0:	83 e0 01             	and    $0x1,%eax
c01058c3:	84 c0                	test   %al,%al
c01058c5:	74 3e                	je     c0105905 <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c01058c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058ca:	8b 00                	mov    (%eax),%eax
c01058cc:	89 04 24             	mov    %eax,(%esp)
c01058cf:	e8 99 f3 ff ff       	call   c0104c6d <pte2page>
c01058d4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01058d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01058da:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01058dd:	75 0d                	jne    c01058ec <page_insert+0x6f>
            page_ref_dec(page);
c01058df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01058e2:	89 04 24             	mov    %eax,(%esp)
c01058e5:	e8 07 f4 ff ff       	call   c0104cf1 <page_ref_dec>
c01058ea:	eb 19                	jmp    c0105905 <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01058ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01058ef:	89 44 24 08          	mov    %eax,0x8(%esp)
c01058f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01058f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01058fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01058fd:	89 04 24             	mov    %eax,(%esp)
c0105900:	e8 ce fe ff ff       	call   c01057d3 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c0105905:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105908:	89 04 24             	mov    %eax,(%esp)
c010590b:	e8 ae f2 ff ff       	call   c0104bbe <page2pa>
c0105910:	0b 45 14             	or     0x14(%ebp),%eax
c0105913:	89 c2                	mov    %eax,%edx
c0105915:	83 ca 01             	or     $0x1,%edx
c0105918:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010591b:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c010591d:	8b 45 10             	mov    0x10(%ebp),%eax
c0105920:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105924:	8b 45 08             	mov    0x8(%ebp),%eax
c0105927:	89 04 24             	mov    %eax,(%esp)
c010592a:	e8 07 00 00 00       	call   c0105936 <tlb_invalidate>
    return 0;
c010592f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105934:	c9                   	leave  
c0105935:	c3                   	ret    

c0105936 <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c0105936:	55                   	push   %ebp
c0105937:	89 e5                	mov    %esp,%ebp
c0105939:	53                   	push   %ebx
c010593a:	83 ec 24             	sub    $0x24,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c010593d:	0f 20 db             	mov    %cr3,%ebx
c0105940:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr3;
c0105943:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c0105946:	89 c2                	mov    %eax,%edx
c0105948:	8b 45 08             	mov    0x8(%ebp),%eax
c010594b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010594e:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0105955:	77 23                	ja     c010597a <tlb_invalidate+0x44>
c0105957:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010595a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010595e:	c7 44 24 08 70 ae 10 	movl   $0xc010ae70,0x8(%esp)
c0105965:	c0 
c0105966:	c7 44 24 04 fb 01 00 	movl   $0x1fb,0x4(%esp)
c010596d:	00 
c010596e:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105975:	e8 46 b3 ff ff       	call   c0100cc0 <__panic>
c010597a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010597d:	05 00 00 00 40       	add    $0x40000000,%eax
c0105982:	39 c2                	cmp    %eax,%edx
c0105984:	75 0c                	jne    c0105992 <tlb_invalidate+0x5c>
        invlpg((void *)la);
c0105986:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105989:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c010598c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010598f:	0f 01 38             	invlpg (%eax)
    }
}
c0105992:	83 c4 24             	add    $0x24,%esp
c0105995:	5b                   	pop    %ebx
c0105996:	5d                   	pop    %ebp
c0105997:	c3                   	ret    

c0105998 <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c0105998:	55                   	push   %ebp
c0105999:	89 e5                	mov    %esp,%ebp
c010599b:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c010599e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01059a5:	e8 23 f5 ff ff       	call   c0104ecd <alloc_pages>
c01059aa:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c01059ad:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01059b1:	0f 84 a7 00 00 00    	je     c0105a5e <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c01059b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01059ba:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01059be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01059c1:	89 44 24 08          	mov    %eax,0x8(%esp)
c01059c5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059c8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01059cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01059cf:	89 04 24             	mov    %eax,(%esp)
c01059d2:	e8 a6 fe ff ff       	call   c010587d <page_insert>
c01059d7:	85 c0                	test   %eax,%eax
c01059d9:	74 1a                	je     c01059f5 <pgdir_alloc_page+0x5d>
            free_page(page);
c01059db:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01059e2:	00 
c01059e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01059e6:	89 04 24             	mov    %eax,(%esp)
c01059e9:	e8 4a f5 ff ff       	call   c0104f38 <free_pages>
            return NULL;
c01059ee:	b8 00 00 00 00       	mov    $0x0,%eax
c01059f3:	eb 6c                	jmp    c0105a61 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c01059f5:	a1 cc 6a 12 c0       	mov    0xc0126acc,%eax
c01059fa:	85 c0                	test   %eax,%eax
c01059fc:	74 60                	je     c0105a5e <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01059fe:	a1 0c 8c 12 c0       	mov    0xc0128c0c,%eax
c0105a03:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105a0a:	00 
c0105a0b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105a0e:	89 54 24 08          	mov    %edx,0x8(%esp)
c0105a12:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a15:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a19:	89 04 24             	mov    %eax,(%esp)
c0105a1c:	e8 3a 0e 00 00       	call   c010685b <swap_map_swappable>
            page->pra_vaddr=la;
c0105a21:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a24:	8b 55 0c             	mov    0xc(%ebp),%edx
c0105a27:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c0105a2a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a2d:	89 04 24             	mov    %eax,(%esp)
c0105a30:	e8 8e f2 ff ff       	call   c0104cc3 <page_ref>
c0105a35:	83 f8 01             	cmp    $0x1,%eax
c0105a38:	74 24                	je     c0105a5e <pgdir_alloc_page+0xc6>
c0105a3a:	c7 44 24 0c f4 ae 10 	movl   $0xc010aef4,0xc(%esp)
c0105a41:	c0 
c0105a42:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105a49:	c0 
c0105a4a:	c7 44 24 04 0e 02 00 	movl   $0x20e,0x4(%esp)
c0105a51:	00 
c0105a52:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105a59:	e8 62 b2 ff ff       	call   c0100cc0 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0105a5e:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105a61:	c9                   	leave  
c0105a62:	c3                   	ret    

c0105a63 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105a63:	55                   	push   %ebp
c0105a64:	89 e5                	mov    %esp,%ebp
c0105a66:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c0105a69:	a1 24 8b 12 c0       	mov    0xc0128b24,%eax
c0105a6e:	8b 40 18             	mov    0x18(%eax),%eax
c0105a71:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105a73:	c7 04 24 08 af 10 c0 	movl   $0xc010af08,(%esp)
c0105a7a:	e8 e0 a8 ff ff       	call   c010035f <cprintf>
}
c0105a7f:	c9                   	leave  
c0105a80:	c3                   	ret    

c0105a81 <check_pgdir>:

static void
check_pgdir(void) {
c0105a81:	55                   	push   %ebp
c0105a82:	89 e5                	mov    %esp,%ebp
c0105a84:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c0105a87:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0105a8c:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105a91:	76 24                	jbe    c0105ab7 <check_pgdir+0x36>
c0105a93:	c7 44 24 0c 27 af 10 	movl   $0xc010af27,0xc(%esp)
c0105a9a:	c0 
c0105a9b:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105aa2:	c0 
c0105aa3:	c7 44 24 04 1f 02 00 	movl   $0x21f,0x4(%esp)
c0105aaa:	00 
c0105aab:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105ab2:	e8 09 b2 ff ff       	call   c0100cc0 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c0105ab7:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105abc:	85 c0                	test   %eax,%eax
c0105abe:	74 0e                	je     c0105ace <check_pgdir+0x4d>
c0105ac0:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105ac5:	25 ff 0f 00 00       	and    $0xfff,%eax
c0105aca:	85 c0                	test   %eax,%eax
c0105acc:	74 24                	je     c0105af2 <check_pgdir+0x71>
c0105ace:	c7 44 24 0c 44 af 10 	movl   $0xc010af44,0xc(%esp)
c0105ad5:	c0 
c0105ad6:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105add:	c0 
c0105ade:	c7 44 24 04 20 02 00 	movl   $0x220,0x4(%esp)
c0105ae5:	00 
c0105ae6:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105aed:	e8 ce b1 ff ff       	call   c0100cc0 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c0105af2:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105af7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105afe:	00 
c0105aff:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105b06:	00 
c0105b07:	89 04 24             	mov    %eax,(%esp)
c0105b0a:	e8 6b fc ff ff       	call   c010577a <get_page>
c0105b0f:	85 c0                	test   %eax,%eax
c0105b11:	74 24                	je     c0105b37 <check_pgdir+0xb6>
c0105b13:	c7 44 24 0c 7c af 10 	movl   $0xc010af7c,0xc(%esp)
c0105b1a:	c0 
c0105b1b:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105b22:	c0 
c0105b23:	c7 44 24 04 21 02 00 	movl   $0x221,0x4(%esp)
c0105b2a:	00 
c0105b2b:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105b32:	e8 89 b1 ff ff       	call   c0100cc0 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c0105b37:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b3e:	e8 8a f3 ff ff       	call   c0104ecd <alloc_pages>
c0105b43:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c0105b46:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105b4b:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105b52:	00 
c0105b53:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b5a:	00 
c0105b5b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105b5e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105b62:	89 04 24             	mov    %eax,(%esp)
c0105b65:	e8 13 fd ff ff       	call   c010587d <page_insert>
c0105b6a:	85 c0                	test   %eax,%eax
c0105b6c:	74 24                	je     c0105b92 <check_pgdir+0x111>
c0105b6e:	c7 44 24 0c a4 af 10 	movl   $0xc010afa4,0xc(%esp)
c0105b75:	c0 
c0105b76:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105b7d:	c0 
c0105b7e:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c0105b85:	00 
c0105b86:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105b8d:	e8 2e b1 ff ff       	call   c0100cc0 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105b92:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105b97:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105b9e:	00 
c0105b9f:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105ba6:	00 
c0105ba7:	89 04 24             	mov    %eax,(%esp)
c0105baa:	e8 84 fa ff ff       	call   c0105633 <get_pte>
c0105baf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105bb2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105bb6:	75 24                	jne    c0105bdc <check_pgdir+0x15b>
c0105bb8:	c7 44 24 0c d0 af 10 	movl   $0xc010afd0,0xc(%esp)
c0105bbf:	c0 
c0105bc0:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105bc7:	c0 
c0105bc8:	c7 44 24 04 28 02 00 	movl   $0x228,0x4(%esp)
c0105bcf:	00 
c0105bd0:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105bd7:	e8 e4 b0 ff ff       	call   c0100cc0 <__panic>
    assert(pte2page(*ptep) == p1);
c0105bdc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105bdf:	8b 00                	mov    (%eax),%eax
c0105be1:	89 04 24             	mov    %eax,(%esp)
c0105be4:	e8 84 f0 ff ff       	call   c0104c6d <pte2page>
c0105be9:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105bec:	74 24                	je     c0105c12 <check_pgdir+0x191>
c0105bee:	c7 44 24 0c fd af 10 	movl   $0xc010affd,0xc(%esp)
c0105bf5:	c0 
c0105bf6:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105bfd:	c0 
c0105bfe:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105c05:	00 
c0105c06:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105c0d:	e8 ae b0 ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p1) == 1);
c0105c12:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105c15:	89 04 24             	mov    %eax,(%esp)
c0105c18:	e8 a6 f0 ff ff       	call   c0104cc3 <page_ref>
c0105c1d:	83 f8 01             	cmp    $0x1,%eax
c0105c20:	74 24                	je     c0105c46 <check_pgdir+0x1c5>
c0105c22:	c7 44 24 0c 13 b0 10 	movl   $0xc010b013,0xc(%esp)
c0105c29:	c0 
c0105c2a:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105c31:	c0 
c0105c32:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c0105c39:	00 
c0105c3a:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105c41:	e8 7a b0 ff ff       	call   c0100cc0 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c0105c46:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105c4b:	8b 00                	mov    (%eax),%eax
c0105c4d:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105c52:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105c55:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c58:	c1 e8 0c             	shr    $0xc,%eax
c0105c5b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105c5e:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0105c63:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c0105c66:	72 23                	jb     c0105c8b <check_pgdir+0x20a>
c0105c68:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105c6f:	c7 44 24 08 cc ad 10 	movl   $0xc010adcc,0x8(%esp)
c0105c76:	c0 
c0105c77:	c7 44 24 04 2c 02 00 	movl   $0x22c,0x4(%esp)
c0105c7e:	00 
c0105c7f:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105c86:	e8 35 b0 ff ff       	call   c0100cc0 <__panic>
c0105c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105c8e:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105c93:	83 c0 04             	add    $0x4,%eax
c0105c96:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c0105c99:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105c9e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105ca5:	00 
c0105ca6:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105cad:	00 
c0105cae:	89 04 24             	mov    %eax,(%esp)
c0105cb1:	e8 7d f9 ff ff       	call   c0105633 <get_pte>
c0105cb6:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0105cb9:	74 24                	je     c0105cdf <check_pgdir+0x25e>
c0105cbb:	c7 44 24 0c 28 b0 10 	movl   $0xc010b028,0xc(%esp)
c0105cc2:	c0 
c0105cc3:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105cca:	c0 
c0105ccb:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105cd2:	00 
c0105cd3:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105cda:	e8 e1 af ff ff       	call   c0100cc0 <__panic>

    p2 = alloc_page();
c0105cdf:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105ce6:	e8 e2 f1 ff ff       	call   c0104ecd <alloc_pages>
c0105ceb:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c0105cee:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105cf3:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c0105cfa:	00 
c0105cfb:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105d02:	00 
c0105d03:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0105d06:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105d0a:	89 04 24             	mov    %eax,(%esp)
c0105d0d:	e8 6b fb ff ff       	call   c010587d <page_insert>
c0105d12:	85 c0                	test   %eax,%eax
c0105d14:	74 24                	je     c0105d3a <check_pgdir+0x2b9>
c0105d16:	c7 44 24 0c 50 b0 10 	movl   $0xc010b050,0xc(%esp)
c0105d1d:	c0 
c0105d1e:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105d25:	c0 
c0105d26:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c0105d2d:	00 
c0105d2e:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105d35:	e8 86 af ff ff       	call   c0100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105d3a:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105d3f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105d46:	00 
c0105d47:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105d4e:	00 
c0105d4f:	89 04 24             	mov    %eax,(%esp)
c0105d52:	e8 dc f8 ff ff       	call   c0105633 <get_pte>
c0105d57:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105d5a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105d5e:	75 24                	jne    c0105d84 <check_pgdir+0x303>
c0105d60:	c7 44 24 0c 88 b0 10 	movl   $0xc010b088,0xc(%esp)
c0105d67:	c0 
c0105d68:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105d6f:	c0 
c0105d70:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c0105d77:	00 
c0105d78:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105d7f:	e8 3c af ff ff       	call   c0100cc0 <__panic>
    assert(*ptep & PTE_U);
c0105d84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105d87:	8b 00                	mov    (%eax),%eax
c0105d89:	83 e0 04             	and    $0x4,%eax
c0105d8c:	85 c0                	test   %eax,%eax
c0105d8e:	75 24                	jne    c0105db4 <check_pgdir+0x333>
c0105d90:	c7 44 24 0c b8 b0 10 	movl   $0xc010b0b8,0xc(%esp)
c0105d97:	c0 
c0105d98:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105d9f:	c0 
c0105da0:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105da7:	00 
c0105da8:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105daf:	e8 0c af ff ff       	call   c0100cc0 <__panic>
    assert(*ptep & PTE_W);
c0105db4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105db7:	8b 00                	mov    (%eax),%eax
c0105db9:	83 e0 02             	and    $0x2,%eax
c0105dbc:	85 c0                	test   %eax,%eax
c0105dbe:	75 24                	jne    c0105de4 <check_pgdir+0x363>
c0105dc0:	c7 44 24 0c c6 b0 10 	movl   $0xc010b0c6,0xc(%esp)
c0105dc7:	c0 
c0105dc8:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105dcf:	c0 
c0105dd0:	c7 44 24 04 33 02 00 	movl   $0x233,0x4(%esp)
c0105dd7:	00 
c0105dd8:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105ddf:	e8 dc ae ff ff       	call   c0100cc0 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c0105de4:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105de9:	8b 00                	mov    (%eax),%eax
c0105deb:	83 e0 04             	and    $0x4,%eax
c0105dee:	85 c0                	test   %eax,%eax
c0105df0:	75 24                	jne    c0105e16 <check_pgdir+0x395>
c0105df2:	c7 44 24 0c d4 b0 10 	movl   $0xc010b0d4,0xc(%esp)
c0105df9:	c0 
c0105dfa:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105e01:	c0 
c0105e02:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c0105e09:	00 
c0105e0a:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105e11:	e8 aa ae ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 1);
c0105e16:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e19:	89 04 24             	mov    %eax,(%esp)
c0105e1c:	e8 a2 ee ff ff       	call   c0104cc3 <page_ref>
c0105e21:	83 f8 01             	cmp    $0x1,%eax
c0105e24:	74 24                	je     c0105e4a <check_pgdir+0x3c9>
c0105e26:	c7 44 24 0c ea b0 10 	movl   $0xc010b0ea,0xc(%esp)
c0105e2d:	c0 
c0105e2e:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105e35:	c0 
c0105e36:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105e3d:	00 
c0105e3e:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105e45:	e8 76 ae ff ff       	call   c0100cc0 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c0105e4a:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105e4f:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105e56:	00 
c0105e57:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105e5e:	00 
c0105e5f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105e62:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105e66:	89 04 24             	mov    %eax,(%esp)
c0105e69:	e8 0f fa ff ff       	call   c010587d <page_insert>
c0105e6e:	85 c0                	test   %eax,%eax
c0105e70:	74 24                	je     c0105e96 <check_pgdir+0x415>
c0105e72:	c7 44 24 0c fc b0 10 	movl   $0xc010b0fc,0xc(%esp)
c0105e79:	c0 
c0105e7a:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105e81:	c0 
c0105e82:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c0105e89:	00 
c0105e8a:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105e91:	e8 2a ae ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p1) == 2);
c0105e96:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105e99:	89 04 24             	mov    %eax,(%esp)
c0105e9c:	e8 22 ee ff ff       	call   c0104cc3 <page_ref>
c0105ea1:	83 f8 02             	cmp    $0x2,%eax
c0105ea4:	74 24                	je     c0105eca <check_pgdir+0x449>
c0105ea6:	c7 44 24 0c 28 b1 10 	movl   $0xc010b128,0xc(%esp)
c0105ead:	c0 
c0105eae:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105eb5:	c0 
c0105eb6:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105ebd:	00 
c0105ebe:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105ec5:	e8 f6 ad ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 0);
c0105eca:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ecd:	89 04 24             	mov    %eax,(%esp)
c0105ed0:	e8 ee ed ff ff       	call   c0104cc3 <page_ref>
c0105ed5:	85 c0                	test   %eax,%eax
c0105ed7:	74 24                	je     c0105efd <check_pgdir+0x47c>
c0105ed9:	c7 44 24 0c 3a b1 10 	movl   $0xc010b13a,0xc(%esp)
c0105ee0:	c0 
c0105ee1:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105ee8:	c0 
c0105ee9:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105ef0:	00 
c0105ef1:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105ef8:	e8 c3 ad ff ff       	call   c0100cc0 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c0105efd:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105f02:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105f09:	00 
c0105f0a:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105f11:	00 
c0105f12:	89 04 24             	mov    %eax,(%esp)
c0105f15:	e8 19 f7 ff ff       	call   c0105633 <get_pte>
c0105f1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105f1d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105f21:	75 24                	jne    c0105f47 <check_pgdir+0x4c6>
c0105f23:	c7 44 24 0c 88 b0 10 	movl   $0xc010b088,0xc(%esp)
c0105f2a:	c0 
c0105f2b:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105f32:	c0 
c0105f33:	c7 44 24 04 3a 02 00 	movl   $0x23a,0x4(%esp)
c0105f3a:	00 
c0105f3b:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105f42:	e8 79 ad ff ff       	call   c0100cc0 <__panic>
    assert(pte2page(*ptep) == p1);
c0105f47:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f4a:	8b 00                	mov    (%eax),%eax
c0105f4c:	89 04 24             	mov    %eax,(%esp)
c0105f4f:	e8 19 ed ff ff       	call   c0104c6d <pte2page>
c0105f54:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0105f57:	74 24                	je     c0105f7d <check_pgdir+0x4fc>
c0105f59:	c7 44 24 0c fd af 10 	movl   $0xc010affd,0xc(%esp)
c0105f60:	c0 
c0105f61:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105f68:	c0 
c0105f69:	c7 44 24 04 3b 02 00 	movl   $0x23b,0x4(%esp)
c0105f70:	00 
c0105f71:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105f78:	e8 43 ad ff ff       	call   c0100cc0 <__panic>
    assert((*ptep & PTE_U) == 0);
c0105f7d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105f80:	8b 00                	mov    (%eax),%eax
c0105f82:	83 e0 04             	and    $0x4,%eax
c0105f85:	85 c0                	test   %eax,%eax
c0105f87:	74 24                	je     c0105fad <check_pgdir+0x52c>
c0105f89:	c7 44 24 0c 4c b1 10 	movl   $0xc010b14c,0xc(%esp)
c0105f90:	c0 
c0105f91:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105f98:	c0 
c0105f99:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c0105fa0:	00 
c0105fa1:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105fa8:	e8 13 ad ff ff       	call   c0100cc0 <__panic>

    page_remove(boot_pgdir, 0x0);
c0105fad:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0105fb2:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0105fb9:	00 
c0105fba:	89 04 24             	mov    %eax,(%esp)
c0105fbd:	e8 77 f8 ff ff       	call   c0105839 <page_remove>
    assert(page_ref(p1) == 1);
c0105fc2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105fc5:	89 04 24             	mov    %eax,(%esp)
c0105fc8:	e8 f6 ec ff ff       	call   c0104cc3 <page_ref>
c0105fcd:	83 f8 01             	cmp    $0x1,%eax
c0105fd0:	74 24                	je     c0105ff6 <check_pgdir+0x575>
c0105fd2:	c7 44 24 0c 13 b0 10 	movl   $0xc010b013,0xc(%esp)
c0105fd9:	c0 
c0105fda:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0105fe1:	c0 
c0105fe2:	c7 44 24 04 3f 02 00 	movl   $0x23f,0x4(%esp)
c0105fe9:	00 
c0105fea:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0105ff1:	e8 ca ac ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 0);
c0105ff6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ff9:	89 04 24             	mov    %eax,(%esp)
c0105ffc:	e8 c2 ec ff ff       	call   c0104cc3 <page_ref>
c0106001:	85 c0                	test   %eax,%eax
c0106003:	74 24                	je     c0106029 <check_pgdir+0x5a8>
c0106005:	c7 44 24 0c 3a b1 10 	movl   $0xc010b13a,0xc(%esp)
c010600c:	c0 
c010600d:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0106014:	c0 
c0106015:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c010601c:	00 
c010601d:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0106024:	e8 97 ac ff ff       	call   c0100cc0 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c0106029:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c010602e:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106035:	00 
c0106036:	89 04 24             	mov    %eax,(%esp)
c0106039:	e8 fb f7 ff ff       	call   c0105839 <page_remove>
    assert(page_ref(p1) == 0);
c010603e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106041:	89 04 24             	mov    %eax,(%esp)
c0106044:	e8 7a ec ff ff       	call   c0104cc3 <page_ref>
c0106049:	85 c0                	test   %eax,%eax
c010604b:	74 24                	je     c0106071 <check_pgdir+0x5f0>
c010604d:	c7 44 24 0c 61 b1 10 	movl   $0xc010b161,0xc(%esp)
c0106054:	c0 
c0106055:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c010605c:	c0 
c010605d:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c0106064:	00 
c0106065:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c010606c:	e8 4f ac ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p2) == 0);
c0106071:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106074:	89 04 24             	mov    %eax,(%esp)
c0106077:	e8 47 ec ff ff       	call   c0104cc3 <page_ref>
c010607c:	85 c0                	test   %eax,%eax
c010607e:	74 24                	je     c01060a4 <check_pgdir+0x623>
c0106080:	c7 44 24 0c 3a b1 10 	movl   $0xc010b13a,0xc(%esp)
c0106087:	c0 
c0106088:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c010608f:	c0 
c0106090:	c7 44 24 04 44 02 00 	movl   $0x244,0x4(%esp)
c0106097:	00 
c0106098:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c010609f:	e8 1c ac ff ff       	call   c0100cc0 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c01060a4:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c01060a9:	8b 00                	mov    (%eax),%eax
c01060ab:	89 04 24             	mov    %eax,(%esp)
c01060ae:	e8 f8 eb ff ff       	call   c0104cab <pde2page>
c01060b3:	89 04 24             	mov    %eax,(%esp)
c01060b6:	e8 08 ec ff ff       	call   c0104cc3 <page_ref>
c01060bb:	83 f8 01             	cmp    $0x1,%eax
c01060be:	74 24                	je     c01060e4 <check_pgdir+0x663>
c01060c0:	c7 44 24 0c 74 b1 10 	movl   $0xc010b174,0xc(%esp)
c01060c7:	c0 
c01060c8:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c01060cf:	c0 
c01060d0:	c7 44 24 04 46 02 00 	movl   $0x246,0x4(%esp)
c01060d7:	00 
c01060d8:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01060df:	e8 dc ab ff ff       	call   c0100cc0 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01060e4:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c01060e9:	8b 00                	mov    (%eax),%eax
c01060eb:	89 04 24             	mov    %eax,(%esp)
c01060ee:	e8 b8 eb ff ff       	call   c0104cab <pde2page>
c01060f3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01060fa:	00 
c01060fb:	89 04 24             	mov    %eax,(%esp)
c01060fe:	e8 35 ee ff ff       	call   c0104f38 <free_pages>
    boot_pgdir[0] = 0;
c0106103:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0106108:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c010610e:	c7 04 24 9b b1 10 c0 	movl   $0xc010b19b,(%esp)
c0106115:	e8 45 a2 ff ff       	call   c010035f <cprintf>
}
c010611a:	c9                   	leave  
c010611b:	c3                   	ret    

c010611c <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c010611c:	55                   	push   %ebp
c010611d:	89 e5                	mov    %esp,%ebp
c010611f:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0106122:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106129:	e9 cb 00 00 00       	jmp    c01061f9 <check_boot_pgdir+0xdd>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c010612e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106131:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106134:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106137:	c1 e8 0c             	shr    $0xc,%eax
c010613a:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010613d:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0106142:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0106145:	72 23                	jb     c010616a <check_boot_pgdir+0x4e>
c0106147:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010614a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010614e:	c7 44 24 08 cc ad 10 	movl   $0xc010adcc,0x8(%esp)
c0106155:	c0 
c0106156:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c010615d:	00 
c010615e:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0106165:	e8 56 ab ff ff       	call   c0100cc0 <__panic>
c010616a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010616d:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0106172:	89 c2                	mov    %eax,%edx
c0106174:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0106179:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106180:	00 
c0106181:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106185:	89 04 24             	mov    %eax,(%esp)
c0106188:	e8 a6 f4 ff ff       	call   c0105633 <get_pte>
c010618d:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106190:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0106194:	75 24                	jne    c01061ba <check_boot_pgdir+0x9e>
c0106196:	c7 44 24 0c b8 b1 10 	movl   $0xc010b1b8,0xc(%esp)
c010619d:	c0 
c010619e:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c01061a5:	c0 
c01061a6:	c7 44 24 04 52 02 00 	movl   $0x252,0x4(%esp)
c01061ad:	00 
c01061ae:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01061b5:	e8 06 ab ff ff       	call   c0100cc0 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c01061ba:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01061bd:	8b 00                	mov    (%eax),%eax
c01061bf:	89 c2                	mov    %eax,%edx
c01061c1:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c01061c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01061ca:	39 c2                	cmp    %eax,%edx
c01061cc:	74 24                	je     c01061f2 <check_boot_pgdir+0xd6>
c01061ce:	c7 44 24 0c f5 b1 10 	movl   $0xc010b1f5,0xc(%esp)
c01061d5:	c0 
c01061d6:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c01061dd:	c0 
c01061de:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c01061e5:	00 
c01061e6:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01061ed:	e8 ce aa ff ff       	call   c0100cc0 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01061f2:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c01061f9:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01061fc:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0106201:	39 c2                	cmp    %eax,%edx
c0106203:	0f 82 25 ff ff ff    	jb     c010612e <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0106209:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c010620e:	05 ac 0f 00 00       	add    $0xfac,%eax
c0106213:	8b 00                	mov    (%eax),%eax
c0106215:	89 c2                	mov    %eax,%edx
c0106217:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c010621d:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0106222:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0106225:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c010622c:	77 23                	ja     c0106251 <check_boot_pgdir+0x135>
c010622e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106231:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106235:	c7 44 24 08 70 ae 10 	movl   $0xc010ae70,0x8(%esp)
c010623c:	c0 
c010623d:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0106244:	00 
c0106245:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c010624c:	e8 6f aa ff ff       	call   c0100cc0 <__panic>
c0106251:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106254:	05 00 00 00 40       	add    $0x40000000,%eax
c0106259:	39 c2                	cmp    %eax,%edx
c010625b:	74 24                	je     c0106281 <check_boot_pgdir+0x165>
c010625d:	c7 44 24 0c 0c b2 10 	movl   $0xc010b20c,0xc(%esp)
c0106264:	c0 
c0106265:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c010626c:	c0 
c010626d:	c7 44 24 04 56 02 00 	movl   $0x256,0x4(%esp)
c0106274:	00 
c0106275:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c010627c:	e8 3f aa ff ff       	call   c0100cc0 <__panic>

    assert(boot_pgdir[0] == 0);
c0106281:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0106286:	8b 00                	mov    (%eax),%eax
c0106288:	85 c0                	test   %eax,%eax
c010628a:	74 24                	je     c01062b0 <check_boot_pgdir+0x194>
c010628c:	c7 44 24 0c 40 b2 10 	movl   $0xc010b240,0xc(%esp)
c0106293:	c0 
c0106294:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c010629b:	c0 
c010629c:	c7 44 24 04 58 02 00 	movl   $0x258,0x4(%esp)
c01062a3:	00 
c01062a4:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01062ab:	e8 10 aa ff ff       	call   c0100cc0 <__panic>

    struct Page *p;
    p = alloc_page();
c01062b0:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01062b7:	e8 11 ec ff ff       	call   c0104ecd <alloc_pages>
c01062bc:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c01062bf:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c01062c4:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c01062cb:	00 
c01062cc:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c01062d3:	00 
c01062d4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01062d7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01062db:	89 04 24             	mov    %eax,(%esp)
c01062de:	e8 9a f5 ff ff       	call   c010587d <page_insert>
c01062e3:	85 c0                	test   %eax,%eax
c01062e5:	74 24                	je     c010630b <check_boot_pgdir+0x1ef>
c01062e7:	c7 44 24 0c 54 b2 10 	movl   $0xc010b254,0xc(%esp)
c01062ee:	c0 
c01062ef:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c01062f6:	c0 
c01062f7:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c01062fe:	00 
c01062ff:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0106306:	e8 b5 a9 ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p) == 1);
c010630b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010630e:	89 04 24             	mov    %eax,(%esp)
c0106311:	e8 ad e9 ff ff       	call   c0104cc3 <page_ref>
c0106316:	83 f8 01             	cmp    $0x1,%eax
c0106319:	74 24                	je     c010633f <check_boot_pgdir+0x223>
c010631b:	c7 44 24 0c 82 b2 10 	movl   $0xc010b282,0xc(%esp)
c0106322:	c0 
c0106323:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c010632a:	c0 
c010632b:	c7 44 24 04 5d 02 00 	movl   $0x25d,0x4(%esp)
c0106332:	00 
c0106333:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c010633a:	e8 81 a9 ff ff       	call   c0100cc0 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c010633f:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0106344:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c010634b:	00 
c010634c:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0106353:	00 
c0106354:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106357:	89 54 24 04          	mov    %edx,0x4(%esp)
c010635b:	89 04 24             	mov    %eax,(%esp)
c010635e:	e8 1a f5 ff ff       	call   c010587d <page_insert>
c0106363:	85 c0                	test   %eax,%eax
c0106365:	74 24                	je     c010638b <check_boot_pgdir+0x26f>
c0106367:	c7 44 24 0c 94 b2 10 	movl   $0xc010b294,0xc(%esp)
c010636e:	c0 
c010636f:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0106376:	c0 
c0106377:	c7 44 24 04 5e 02 00 	movl   $0x25e,0x4(%esp)
c010637e:	00 
c010637f:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0106386:	e8 35 a9 ff ff       	call   c0100cc0 <__panic>
    assert(page_ref(p) == 2);
c010638b:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010638e:	89 04 24             	mov    %eax,(%esp)
c0106391:	e8 2d e9 ff ff       	call   c0104cc3 <page_ref>
c0106396:	83 f8 02             	cmp    $0x2,%eax
c0106399:	74 24                	je     c01063bf <check_boot_pgdir+0x2a3>
c010639b:	c7 44 24 0c cb b2 10 	movl   $0xc010b2cb,0xc(%esp)
c01063a2:	c0 
c01063a3:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c01063aa:	c0 
c01063ab:	c7 44 24 04 5f 02 00 	movl   $0x25f,0x4(%esp)
c01063b2:	00 
c01063b3:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c01063ba:	e8 01 a9 ff ff       	call   c0100cc0 <__panic>

    const char *str = "ucore: Hello world!!";
c01063bf:	c7 45 dc dc b2 10 c0 	movl   $0xc010b2dc,-0x24(%ebp)
    strcpy((void *)0x100, str);
c01063c6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01063c9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063cd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01063d4:	e8 1d 38 00 00       	call   c0109bf6 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c01063d9:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c01063e0:	00 
c01063e1:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c01063e8:	e8 86 38 00 00       	call   c0109c73 <strcmp>
c01063ed:	85 c0                	test   %eax,%eax
c01063ef:	74 24                	je     c0106415 <check_boot_pgdir+0x2f9>
c01063f1:	c7 44 24 0c f4 b2 10 	movl   $0xc010b2f4,0xc(%esp)
c01063f8:	c0 
c01063f9:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0106400:	c0 
c0106401:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
c0106408:	00 
c0106409:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0106410:	e8 ab a8 ff ff       	call   c0100cc0 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0106415:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106418:	89 04 24             	mov    %eax,(%esp)
c010641b:	e8 f9 e7 ff ff       	call   c0104c19 <page2kva>
c0106420:	05 00 01 00 00       	add    $0x100,%eax
c0106425:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0106428:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c010642f:	e8 64 37 00 00       	call   c0109b98 <strlen>
c0106434:	85 c0                	test   %eax,%eax
c0106436:	74 24                	je     c010645c <check_boot_pgdir+0x340>
c0106438:	c7 44 24 0c 2c b3 10 	movl   $0xc010b32c,0xc(%esp)
c010643f:	c0 
c0106440:	c7 44 24 08 b9 ae 10 	movl   $0xc010aeb9,0x8(%esp)
c0106447:	c0 
c0106448:	c7 44 24 04 66 02 00 	movl   $0x266,0x4(%esp)
c010644f:	00 
c0106450:	c7 04 24 94 ae 10 c0 	movl   $0xc010ae94,(%esp)
c0106457:	e8 64 a8 ff ff       	call   c0100cc0 <__panic>

    free_page(p);
c010645c:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106463:	00 
c0106464:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106467:	89 04 24             	mov    %eax,(%esp)
c010646a:	e8 c9 ea ff ff       	call   c0104f38 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c010646f:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0106474:	8b 00                	mov    (%eax),%eax
c0106476:	89 04 24             	mov    %eax,(%esp)
c0106479:	e8 2d e8 ff ff       	call   c0104cab <pde2page>
c010647e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106485:	00 
c0106486:	89 04 24             	mov    %eax,(%esp)
c0106489:	e8 aa ea ff ff       	call   c0104f38 <free_pages>
    boot_pgdir[0] = 0;
c010648e:	a1 44 6a 12 c0       	mov    0xc0126a44,%eax
c0106493:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0106499:	c7 04 24 50 b3 10 c0 	movl   $0xc010b350,(%esp)
c01064a0:	e8 ba 9e ff ff       	call   c010035f <cprintf>
}
c01064a5:	c9                   	leave  
c01064a6:	c3                   	ret    

c01064a7 <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c01064a7:	55                   	push   %ebp
c01064a8:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c01064aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01064ad:	83 e0 04             	and    $0x4,%eax
c01064b0:	85 c0                	test   %eax,%eax
c01064b2:	74 07                	je     c01064bb <perm2str+0x14>
c01064b4:	b8 75 00 00 00       	mov    $0x75,%eax
c01064b9:	eb 05                	jmp    c01064c0 <perm2str+0x19>
c01064bb:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01064c0:	a2 c8 6a 12 c0       	mov    %al,0xc0126ac8
    str[1] = 'r';
c01064c5:	c6 05 c9 6a 12 c0 72 	movb   $0x72,0xc0126ac9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c01064cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01064cf:	83 e0 02             	and    $0x2,%eax
c01064d2:	85 c0                	test   %eax,%eax
c01064d4:	74 07                	je     c01064dd <perm2str+0x36>
c01064d6:	b8 77 00 00 00       	mov    $0x77,%eax
c01064db:	eb 05                	jmp    c01064e2 <perm2str+0x3b>
c01064dd:	b8 2d 00 00 00       	mov    $0x2d,%eax
c01064e2:	a2 ca 6a 12 c0       	mov    %al,0xc0126aca
    str[3] = '\0';
c01064e7:	c6 05 cb 6a 12 c0 00 	movb   $0x0,0xc0126acb
    return str;
c01064ee:	b8 c8 6a 12 c0       	mov    $0xc0126ac8,%eax
}
c01064f3:	5d                   	pop    %ebp
c01064f4:	c3                   	ret    

c01064f5 <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c01064f5:	55                   	push   %ebp
c01064f6:	89 e5                	mov    %esp,%ebp
c01064f8:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c01064fb:	8b 45 10             	mov    0x10(%ebp),%eax
c01064fe:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106501:	72 0e                	jb     c0106511 <get_pgtable_items+0x1c>
        return 0;
c0106503:	b8 00 00 00 00       	mov    $0x0,%eax
c0106508:	e9 86 00 00 00       	jmp    c0106593 <get_pgtable_items+0x9e>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c010650d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0106511:	8b 45 10             	mov    0x10(%ebp),%eax
c0106514:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106517:	73 12                	jae    c010652b <get_pgtable_items+0x36>
c0106519:	8b 45 10             	mov    0x10(%ebp),%eax
c010651c:	c1 e0 02             	shl    $0x2,%eax
c010651f:	03 45 14             	add    0x14(%ebp),%eax
c0106522:	8b 00                	mov    (%eax),%eax
c0106524:	83 e0 01             	and    $0x1,%eax
c0106527:	85 c0                	test   %eax,%eax
c0106529:	74 e2                	je     c010650d <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c010652b:	8b 45 10             	mov    0x10(%ebp),%eax
c010652e:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106531:	73 5b                	jae    c010658e <get_pgtable_items+0x99>
        if (left_store != NULL) {
c0106533:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0106537:	74 08                	je     c0106541 <get_pgtable_items+0x4c>
            *left_store = start;
c0106539:	8b 45 18             	mov    0x18(%ebp),%eax
c010653c:	8b 55 10             	mov    0x10(%ebp),%edx
c010653f:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0106541:	8b 45 10             	mov    0x10(%ebp),%eax
c0106544:	c1 e0 02             	shl    $0x2,%eax
c0106547:	03 45 14             	add    0x14(%ebp),%eax
c010654a:	8b 00                	mov    (%eax),%eax
c010654c:	83 e0 07             	and    $0x7,%eax
c010654f:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0106552:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0106556:	eb 04                	jmp    c010655c <get_pgtable_items+0x67>
            start ++;
c0106558:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c010655c:	8b 45 10             	mov    0x10(%ebp),%eax
c010655f:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106562:	73 17                	jae    c010657b <get_pgtable_items+0x86>
c0106564:	8b 45 10             	mov    0x10(%ebp),%eax
c0106567:	c1 e0 02             	shl    $0x2,%eax
c010656a:	03 45 14             	add    0x14(%ebp),%eax
c010656d:	8b 00                	mov    (%eax),%eax
c010656f:	89 c2                	mov    %eax,%edx
c0106571:	83 e2 07             	and    $0x7,%edx
c0106574:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106577:	39 c2                	cmp    %eax,%edx
c0106579:	74 dd                	je     c0106558 <get_pgtable_items+0x63>
            start ++;
        }
        if (right_store != NULL) {
c010657b:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c010657f:	74 08                	je     c0106589 <get_pgtable_items+0x94>
            *right_store = start;
c0106581:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0106584:	8b 55 10             	mov    0x10(%ebp),%edx
c0106587:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0106589:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010658c:	eb 05                	jmp    c0106593 <get_pgtable_items+0x9e>
    }
    return 0;
c010658e:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106593:	c9                   	leave  
c0106594:	c3                   	ret    

c0106595 <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0106595:	55                   	push   %ebp
c0106596:	89 e5                	mov    %esp,%ebp
c0106598:	57                   	push   %edi
c0106599:	56                   	push   %esi
c010659a:	53                   	push   %ebx
c010659b:	83 ec 5c             	sub    $0x5c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c010659e:	c7 04 24 70 b3 10 c0 	movl   $0xc010b370,(%esp)
c01065a5:	e8 b5 9d ff ff       	call   c010035f <cprintf>
    size_t left, right = 0, perm;
c01065aa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01065b1:	e9 0b 01 00 00       	jmp    c01066c1 <print_pgdir+0x12c>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01065b6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01065b9:	89 04 24             	mov    %eax,(%esp)
c01065bc:	e8 e6 fe ff ff       	call   c01064a7 <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c01065c1:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c01065c4:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01065c7:	89 cb                	mov    %ecx,%ebx
c01065c9:	29 d3                	sub    %edx,%ebx
c01065cb:	89 da                	mov    %ebx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c01065cd:	89 d6                	mov    %edx,%esi
c01065cf:	c1 e6 16             	shl    $0x16,%esi
c01065d2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01065d5:	89 d3                	mov    %edx,%ebx
c01065d7:	c1 e3 16             	shl    $0x16,%ebx
c01065da:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01065dd:	89 d1                	mov    %edx,%ecx
c01065df:	c1 e1 16             	shl    $0x16,%ecx
c01065e2:	8b 7d dc             	mov    -0x24(%ebp),%edi
c01065e5:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c01065e8:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01065eb:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c01065ee:	29 d7                	sub    %edx,%edi
c01065f0:	89 fa                	mov    %edi,%edx
c01065f2:	89 44 24 14          	mov    %eax,0x14(%esp)
c01065f6:	89 74 24 10          	mov    %esi,0x10(%esp)
c01065fa:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01065fe:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106602:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106606:	c7 04 24 a1 b3 10 c0 	movl   $0xc010b3a1,(%esp)
c010660d:	e8 4d 9d ff ff       	call   c010035f <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0106612:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106615:	c1 e0 0a             	shl    $0xa,%eax
c0106618:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c010661b:	eb 5c                	jmp    c0106679 <print_pgdir+0xe4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c010661d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106620:	89 04 24             	mov    %eax,(%esp)
c0106623:	e8 7f fe ff ff       	call   c01064a7 <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0106628:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c010662b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010662e:	89 cb                	mov    %ecx,%ebx
c0106630:	29 d3                	sub    %edx,%ebx
c0106632:	89 da                	mov    %ebx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0106634:	89 d6                	mov    %edx,%esi
c0106636:	c1 e6 0c             	shl    $0xc,%esi
c0106639:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010663c:	89 d3                	mov    %edx,%ebx
c010663e:	c1 e3 0c             	shl    $0xc,%ebx
c0106641:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106644:	89 d1                	mov    %edx,%ecx
c0106646:	c1 e1 0c             	shl    $0xc,%ecx
c0106649:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c010664c:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c010664f:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0106652:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c0106655:	29 d7                	sub    %edx,%edi
c0106657:	89 fa                	mov    %edi,%edx
c0106659:	89 44 24 14          	mov    %eax,0x14(%esp)
c010665d:	89 74 24 10          	mov    %esi,0x10(%esp)
c0106661:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0106665:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0106669:	89 54 24 04          	mov    %edx,0x4(%esp)
c010666d:	c7 04 24 c0 b3 10 c0 	movl   $0xc010b3c0,(%esp)
c0106674:	e8 e6 9c ff ff       	call   c010035f <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0106679:	8b 15 14 ae 10 c0    	mov    0xc010ae14,%edx
c010667f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0106682:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0106685:	89 ce                	mov    %ecx,%esi
c0106687:	c1 e6 0a             	shl    $0xa,%esi
c010668a:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c010668d:	89 cb                	mov    %ecx,%ebx
c010668f:	c1 e3 0a             	shl    $0xa,%ebx
c0106692:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0106695:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0106699:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c010669c:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01066a0:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01066a4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01066a8:	89 74 24 04          	mov    %esi,0x4(%esp)
c01066ac:	89 1c 24             	mov    %ebx,(%esp)
c01066af:	e8 41 fe ff ff       	call   c01064f5 <get_pgtable_items>
c01066b4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01066b7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01066bb:	0f 85 5c ff ff ff    	jne    c010661d <print_pgdir+0x88>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c01066c1:	8b 15 18 ae 10 c0    	mov    0xc010ae18,%edx
c01066c7:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01066ca:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c01066cd:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c01066d1:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c01066d4:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c01066d8:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01066dc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01066e0:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c01066e7:	00 
c01066e8:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01066ef:	e8 01 fe ff ff       	call   c01064f5 <get_pgtable_items>
c01066f4:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01066f7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01066fb:	0f 85 b5 fe ff ff    	jne    c01065b6 <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0106701:	c7 04 24 e4 b3 10 c0 	movl   $0xc010b3e4,(%esp)
c0106708:	e8 52 9c ff ff       	call   c010035f <cprintf>
}
c010670d:	83 c4 5c             	add    $0x5c,%esp
c0106710:	5b                   	pop    %ebx
c0106711:	5e                   	pop    %esi
c0106712:	5f                   	pop    %edi
c0106713:	5d                   	pop    %ebp
c0106714:	c3                   	ret    
c0106715:	00 00                	add    %al,(%eax)
	...

c0106718 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106718:	55                   	push   %ebp
c0106719:	89 e5                	mov    %esp,%ebp
c010671b:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010671e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106721:	89 c2                	mov    %eax,%edx
c0106723:	c1 ea 0c             	shr    $0xc,%edx
c0106726:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c010672b:	39 c2                	cmp    %eax,%edx
c010672d:	72 1c                	jb     c010674b <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010672f:	c7 44 24 08 18 b4 10 	movl   $0xc010b418,0x8(%esp)
c0106736:	c0 
c0106737:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c010673e:	00 
c010673f:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c0106746:	e8 75 a5 ff ff       	call   c0100cc0 <__panic>
    }
    return &pages[PPN(pa)];
c010674b:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c0106750:	8b 55 08             	mov    0x8(%ebp),%edx
c0106753:	c1 ea 0c             	shr    $0xc,%edx
c0106756:	c1 e2 05             	shl    $0x5,%edx
c0106759:	01 d0                	add    %edx,%eax
}
c010675b:	c9                   	leave  
c010675c:	c3                   	ret    

c010675d <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c010675d:	55                   	push   %ebp
c010675e:	89 e5                	mov    %esp,%ebp
c0106760:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c0106763:	8b 45 08             	mov    0x8(%ebp),%eax
c0106766:	83 e0 01             	and    $0x1,%eax
c0106769:	85 c0                	test   %eax,%eax
c010676b:	75 1c                	jne    c0106789 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c010676d:	c7 44 24 08 48 b4 10 	movl   $0xc010b448,0x8(%esp)
c0106774:	c0 
c0106775:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c010677c:	00 
c010677d:	c7 04 24 37 b4 10 c0 	movl   $0xc010b437,(%esp)
c0106784:	e8 37 a5 ff ff       	call   c0100cc0 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106789:	8b 45 08             	mov    0x8(%ebp),%eax
c010678c:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0106791:	89 04 24             	mov    %eax,(%esp)
c0106794:	e8 7f ff ff ff       	call   c0106718 <pa2page>
}
c0106799:	c9                   	leave  
c010679a:	c3                   	ret    

c010679b <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c010679b:	55                   	push   %ebp
c010679c:	89 e5                	mov    %esp,%ebp
c010679e:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c01067a1:	e8 92 1e 00 00       	call   c0108638 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01067a6:	a1 dc 8b 12 c0       	mov    0xc0128bdc,%eax
c01067ab:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01067b0:	76 0c                	jbe    c01067be <swap_init+0x23>
c01067b2:	a1 dc 8b 12 c0       	mov    0xc0128bdc,%eax
c01067b7:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01067bc:	76 25                	jbe    c01067e3 <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01067be:	a1 dc 8b 12 c0       	mov    0xc0128bdc,%eax
c01067c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01067c7:	c7 44 24 08 69 b4 10 	movl   $0xc010b469,0x8(%esp)
c01067ce:	c0 
c01067cf:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c01067d6:	00 
c01067d7:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c01067de:	e8 dd a4 ff ff       	call   c0100cc0 <__panic>
     }
     

     sm = &swap_manager_fifo;
c01067e3:	c7 05 d4 6a 12 c0 60 	movl   $0xc0125a60,0xc0126ad4
c01067ea:	5a 12 c0 
     int r = sm->init();
c01067ed:	a1 d4 6a 12 c0       	mov    0xc0126ad4,%eax
c01067f2:	8b 40 04             	mov    0x4(%eax),%eax
c01067f5:	ff d0                	call   *%eax
c01067f7:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c01067fa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01067fe:	75 26                	jne    c0106826 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c0106800:	c7 05 cc 6a 12 c0 01 	movl   $0x1,0xc0126acc
c0106807:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c010680a:	a1 d4 6a 12 c0       	mov    0xc0126ad4,%eax
c010680f:	8b 00                	mov    (%eax),%eax
c0106811:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106815:	c7 04 24 93 b4 10 c0 	movl   $0xc010b493,(%esp)
c010681c:	e8 3e 9b ff ff       	call   c010035f <cprintf>
          check_swap();
c0106821:	e8 a4 04 00 00       	call   c0106cca <check_swap>
     }

     return r;
c0106826:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106829:	c9                   	leave  
c010682a:	c3                   	ret    

c010682b <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c010682b:	55                   	push   %ebp
c010682c:	89 e5                	mov    %esp,%ebp
c010682e:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c0106831:	a1 d4 6a 12 c0       	mov    0xc0126ad4,%eax
c0106836:	8b 50 08             	mov    0x8(%eax),%edx
c0106839:	8b 45 08             	mov    0x8(%ebp),%eax
c010683c:	89 04 24             	mov    %eax,(%esp)
c010683f:	ff d2                	call   *%edx
}
c0106841:	c9                   	leave  
c0106842:	c3                   	ret    

c0106843 <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c0106843:	55                   	push   %ebp
c0106844:	89 e5                	mov    %esp,%ebp
c0106846:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106849:	a1 d4 6a 12 c0       	mov    0xc0126ad4,%eax
c010684e:	8b 50 0c             	mov    0xc(%eax),%edx
c0106851:	8b 45 08             	mov    0x8(%ebp),%eax
c0106854:	89 04 24             	mov    %eax,(%esp)
c0106857:	ff d2                	call   *%edx
}
c0106859:	c9                   	leave  
c010685a:	c3                   	ret    

c010685b <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c010685b:	55                   	push   %ebp
c010685c:	89 e5                	mov    %esp,%ebp
c010685e:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c0106861:	a1 d4 6a 12 c0       	mov    0xc0126ad4,%eax
c0106866:	8b 50 10             	mov    0x10(%eax),%edx
c0106869:	8b 45 14             	mov    0x14(%ebp),%eax
c010686c:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0106870:	8b 45 10             	mov    0x10(%ebp),%eax
c0106873:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106877:	8b 45 0c             	mov    0xc(%ebp),%eax
c010687a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010687e:	8b 45 08             	mov    0x8(%ebp),%eax
c0106881:	89 04 24             	mov    %eax,(%esp)
c0106884:	ff d2                	call   *%edx
}
c0106886:	c9                   	leave  
c0106887:	c3                   	ret    

c0106888 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106888:	55                   	push   %ebp
c0106889:	89 e5                	mov    %esp,%ebp
c010688b:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010688e:	a1 d4 6a 12 c0       	mov    0xc0126ad4,%eax
c0106893:	8b 50 14             	mov    0x14(%eax),%edx
c0106896:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106899:	89 44 24 04          	mov    %eax,0x4(%esp)
c010689d:	8b 45 08             	mov    0x8(%ebp),%eax
c01068a0:	89 04 24             	mov    %eax,(%esp)
c01068a3:	ff d2                	call   *%edx
}
c01068a5:	c9                   	leave  
c01068a6:	c3                   	ret    

c01068a7 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01068a7:	55                   	push   %ebp
c01068a8:	89 e5                	mov    %esp,%ebp
c01068aa:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01068ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01068b4:	e9 5a 01 00 00       	jmp    c0106a13 <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01068b9:	a1 d4 6a 12 c0       	mov    0xc0126ad4,%eax
c01068be:	8b 50 18             	mov    0x18(%eax),%edx
c01068c1:	8b 45 10             	mov    0x10(%ebp),%eax
c01068c4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01068c8:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01068cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01068d2:	89 04 24             	mov    %eax,(%esp)
c01068d5:	ff d2                	call   *%edx
c01068d7:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01068da:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01068de:	74 18                	je     c01068f8 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01068e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01068e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068e7:	c7 04 24 a8 b4 10 c0 	movl   $0xc010b4a8,(%esp)
c01068ee:	e8 6c 9a ff ff       	call   c010035f <cprintf>
                  break;
c01068f3:	e9 27 01 00 00       	jmp    c0106a1f <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c01068f8:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01068fb:	8b 40 1c             	mov    0x1c(%eax),%eax
c01068fe:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c0106901:	8b 45 08             	mov    0x8(%ebp),%eax
c0106904:	8b 40 0c             	mov    0xc(%eax),%eax
c0106907:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010690e:	00 
c010690f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106912:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106916:	89 04 24             	mov    %eax,(%esp)
c0106919:	e8 15 ed ff ff       	call   c0105633 <get_pte>
c010691e:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c0106921:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106924:	8b 00                	mov    (%eax),%eax
c0106926:	83 e0 01             	and    $0x1,%eax
c0106929:	85 c0                	test   %eax,%eax
c010692b:	75 24                	jne    c0106951 <swap_out+0xaa>
c010692d:	c7 44 24 0c d5 b4 10 	movl   $0xc010b4d5,0xc(%esp)
c0106934:	c0 
c0106935:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c010693c:	c0 
c010693d:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106944:	00 
c0106945:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c010694c:	e8 6f a3 ff ff       	call   c0100cc0 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c0106951:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106954:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106957:	8b 52 1c             	mov    0x1c(%edx),%edx
c010695a:	c1 ea 0c             	shr    $0xc,%edx
c010695d:	83 c2 01             	add    $0x1,%edx
c0106960:	c1 e2 08             	shl    $0x8,%edx
c0106963:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106967:	89 14 24             	mov    %edx,(%esp)
c010696a:	e8 83 1d 00 00       	call   c01086f2 <swapfs_write>
c010696f:	85 c0                	test   %eax,%eax
c0106971:	74 34                	je     c01069a7 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c0106973:	c7 04 24 ff b4 10 c0 	movl   $0xc010b4ff,(%esp)
c010697a:	e8 e0 99 ff ff       	call   c010035f <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010697f:	a1 d4 6a 12 c0       	mov    0xc0126ad4,%eax
c0106984:	8b 50 10             	mov    0x10(%eax),%edx
c0106987:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010698a:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0106991:	00 
c0106992:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106996:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106999:	89 44 24 04          	mov    %eax,0x4(%esp)
c010699d:	8b 45 08             	mov    0x8(%ebp),%eax
c01069a0:	89 04 24             	mov    %eax,(%esp)
c01069a3:	ff d2                	call   *%edx
                    continue;
c01069a5:	eb 68                	jmp    c0106a0f <swap_out+0x168>
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01069a7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069aa:	8b 40 1c             	mov    0x1c(%eax),%eax
c01069ad:	c1 e8 0c             	shr    $0xc,%eax
c01069b0:	83 c0 01             	add    $0x1,%eax
c01069b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01069b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01069ba:	89 44 24 08          	mov    %eax,0x8(%esp)
c01069be:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01069c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01069c5:	c7 04 24 18 b5 10 c0 	movl   $0xc010b518,(%esp)
c01069cc:	e8 8e 99 ff ff       	call   c010035f <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01069d1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069d4:	8b 40 1c             	mov    0x1c(%eax),%eax
c01069d7:	c1 e8 0c             	shr    $0xc,%eax
c01069da:	83 c0 01             	add    $0x1,%eax
c01069dd:	89 c2                	mov    %eax,%edx
c01069df:	c1 e2 08             	shl    $0x8,%edx
c01069e2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01069e5:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01069e7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01069ea:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01069f1:	00 
c01069f2:	89 04 24             	mov    %eax,(%esp)
c01069f5:	e8 3e e5 ff ff       	call   c0104f38 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c01069fa:	8b 45 08             	mov    0x8(%ebp),%eax
c01069fd:	8b 40 0c             	mov    0xc(%eax),%eax
c0106a00:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106a03:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106a07:	89 04 24             	mov    %eax,(%esp)
c0106a0a:	e8 27 ef ff ff       	call   c0105936 <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c0106a0f:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106a13:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106a16:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106a19:	0f 85 9a fe ff ff    	jne    c01068b9 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c0106a1f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106a22:	c9                   	leave  
c0106a23:	c3                   	ret    

c0106a24 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106a24:	55                   	push   %ebp
c0106a25:	89 e5                	mov    %esp,%ebp
c0106a27:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106a2a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106a31:	e8 97 e4 ff ff       	call   c0104ecd <alloc_pages>
c0106a36:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106a39:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106a3d:	75 24                	jne    c0106a63 <swap_in+0x3f>
c0106a3f:	c7 44 24 0c 58 b5 10 	movl   $0xc010b558,0xc(%esp)
c0106a46:	c0 
c0106a47:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106a4e:	c0 
c0106a4f:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0106a56:	00 
c0106a57:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106a5e:	e8 5d a2 ff ff       	call   c0100cc0 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c0106a63:	8b 45 08             	mov    0x8(%ebp),%eax
c0106a66:	8b 40 0c             	mov    0xc(%eax),%eax
c0106a69:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106a70:	00 
c0106a71:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106a74:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106a78:	89 04 24             	mov    %eax,(%esp)
c0106a7b:	e8 b3 eb ff ff       	call   c0105633 <get_pte>
c0106a80:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c0106a83:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106a86:	8b 00                	mov    (%eax),%eax
c0106a88:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106a8b:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106a8f:	89 04 24             	mov    %eax,(%esp)
c0106a92:	e8 e9 1b 00 00       	call   c0108680 <swapfs_read>
c0106a97:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106a9a:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106a9e:	74 2a                	je     c0106aca <swap_in+0xa6>
     {
        assert(r!=0);
c0106aa0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106aa4:	75 24                	jne    c0106aca <swap_in+0xa6>
c0106aa6:	c7 44 24 0c 65 b5 10 	movl   $0xc010b565,0xc(%esp)
c0106aad:	c0 
c0106aae:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106ab5:	c0 
c0106ab6:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c0106abd:	00 
c0106abe:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106ac5:	e8 f6 a1 ff ff       	call   c0100cc0 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c0106aca:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106acd:	8b 00                	mov    (%eax),%eax
c0106acf:	89 c2                	mov    %eax,%edx
c0106ad1:	c1 ea 08             	shr    $0x8,%edx
c0106ad4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106ad7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106adb:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106adf:	c7 04 24 6c b5 10 c0 	movl   $0xc010b56c,(%esp)
c0106ae6:	e8 74 98 ff ff       	call   c010035f <cprintf>
     *ptr_result=result;
c0106aeb:	8b 45 10             	mov    0x10(%ebp),%eax
c0106aee:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106af1:	89 10                	mov    %edx,(%eax)
     return 0;
c0106af3:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106af8:	c9                   	leave  
c0106af9:	c3                   	ret    

c0106afa <check_content_set>:



static inline void
check_content_set(void)
{
c0106afa:	55                   	push   %ebp
c0106afb:	89 e5                	mov    %esp,%ebp
c0106afd:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c0106b00:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106b05:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106b08:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0106b0d:	83 f8 01             	cmp    $0x1,%eax
c0106b10:	74 24                	je     c0106b36 <check_content_set+0x3c>
c0106b12:	c7 44 24 0c aa b5 10 	movl   $0xc010b5aa,0xc(%esp)
c0106b19:	c0 
c0106b1a:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106b21:	c0 
c0106b22:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106b29:	00 
c0106b2a:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106b31:	e8 8a a1 ff ff       	call   c0100cc0 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106b36:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106b3b:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106b3e:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0106b43:	83 f8 01             	cmp    $0x1,%eax
c0106b46:	74 24                	je     c0106b6c <check_content_set+0x72>
c0106b48:	c7 44 24 0c aa b5 10 	movl   $0xc010b5aa,0xc(%esp)
c0106b4f:	c0 
c0106b50:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106b57:	c0 
c0106b58:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c0106b5f:	00 
c0106b60:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106b67:	e8 54 a1 ff ff       	call   c0100cc0 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106b6c:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106b71:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106b74:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0106b79:	83 f8 02             	cmp    $0x2,%eax
c0106b7c:	74 24                	je     c0106ba2 <check_content_set+0xa8>
c0106b7e:	c7 44 24 0c b9 b5 10 	movl   $0xc010b5b9,0xc(%esp)
c0106b85:	c0 
c0106b86:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106b8d:	c0 
c0106b8e:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c0106b95:	00 
c0106b96:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106b9d:	e8 1e a1 ff ff       	call   c0100cc0 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c0106ba2:	b8 10 20 00 00       	mov    $0x2010,%eax
c0106ba7:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106baa:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0106baf:	83 f8 02             	cmp    $0x2,%eax
c0106bb2:	74 24                	je     c0106bd8 <check_content_set+0xde>
c0106bb4:	c7 44 24 0c b9 b5 10 	movl   $0xc010b5b9,0xc(%esp)
c0106bbb:	c0 
c0106bbc:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106bc3:	c0 
c0106bc4:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c0106bcb:	00 
c0106bcc:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106bd3:	e8 e8 a0 ff ff       	call   c0100cc0 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c0106bd8:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106bdd:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106be0:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0106be5:	83 f8 03             	cmp    $0x3,%eax
c0106be8:	74 24                	je     c0106c0e <check_content_set+0x114>
c0106bea:	c7 44 24 0c c8 b5 10 	movl   $0xc010b5c8,0xc(%esp)
c0106bf1:	c0 
c0106bf2:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106bf9:	c0 
c0106bfa:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c0106c01:	00 
c0106c02:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106c09:	e8 b2 a0 ff ff       	call   c0100cc0 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c0106c0e:	b8 10 30 00 00       	mov    $0x3010,%eax
c0106c13:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106c16:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0106c1b:	83 f8 03             	cmp    $0x3,%eax
c0106c1e:	74 24                	je     c0106c44 <check_content_set+0x14a>
c0106c20:	c7 44 24 0c c8 b5 10 	movl   $0xc010b5c8,0xc(%esp)
c0106c27:	c0 
c0106c28:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106c2f:	c0 
c0106c30:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106c37:	00 
c0106c38:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106c3f:	e8 7c a0 ff ff       	call   c0100cc0 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106c44:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106c49:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106c4c:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0106c51:	83 f8 04             	cmp    $0x4,%eax
c0106c54:	74 24                	je     c0106c7a <check_content_set+0x180>
c0106c56:	c7 44 24 0c d7 b5 10 	movl   $0xc010b5d7,0xc(%esp)
c0106c5d:	c0 
c0106c5e:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106c65:	c0 
c0106c66:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106c6d:	00 
c0106c6e:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106c75:	e8 46 a0 ff ff       	call   c0100cc0 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106c7a:	b8 10 40 00 00       	mov    $0x4010,%eax
c0106c7f:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106c82:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0106c87:	83 f8 04             	cmp    $0x4,%eax
c0106c8a:	74 24                	je     c0106cb0 <check_content_set+0x1b6>
c0106c8c:	c7 44 24 0c d7 b5 10 	movl   $0xc010b5d7,0xc(%esp)
c0106c93:	c0 
c0106c94:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106c9b:	c0 
c0106c9c:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c0106ca3:	00 
c0106ca4:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106cab:	e8 10 a0 ff ff       	call   c0100cc0 <__panic>
}
c0106cb0:	c9                   	leave  
c0106cb1:	c3                   	ret    

c0106cb2 <check_content_access>:

static inline int
check_content_access(void)
{
c0106cb2:	55                   	push   %ebp
c0106cb3:	89 e5                	mov    %esp,%ebp
c0106cb5:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c0106cb8:	a1 d4 6a 12 c0       	mov    0xc0126ad4,%eax
c0106cbd:	8b 40 1c             	mov    0x1c(%eax),%eax
c0106cc0:	ff d0                	call   *%eax
c0106cc2:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c0106cc5:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106cc8:	c9                   	leave  
c0106cc9:	c3                   	ret    

c0106cca <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c0106cca:	55                   	push   %ebp
c0106ccb:	89 e5                	mov    %esp,%ebp
c0106ccd:	53                   	push   %ebx
c0106cce:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c0106cd1:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0106cd8:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c0106cdf:	c7 45 e8 18 8b 12 c0 	movl   $0xc0128b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106ce6:	eb 6b                	jmp    c0106d53 <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c0106ce8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106ceb:	83 e8 0c             	sub    $0xc,%eax
c0106cee:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c0106cf1:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106cf4:	83 c0 04             	add    $0x4,%eax
c0106cf7:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c0106cfe:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106d01:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106d04:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106d07:	0f a3 10             	bt     %edx,(%eax)
c0106d0a:	19 db                	sbb    %ebx,%ebx
c0106d0c:	89 5d bc             	mov    %ebx,-0x44(%ebp)
    return oldbit != 0;
c0106d0f:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0106d13:	0f 95 c0             	setne  %al
c0106d16:	0f b6 c0             	movzbl %al,%eax
c0106d19:	85 c0                	test   %eax,%eax
c0106d1b:	75 24                	jne    c0106d41 <check_swap+0x77>
c0106d1d:	c7 44 24 0c e6 b5 10 	movl   $0xc010b5e6,0xc(%esp)
c0106d24:	c0 
c0106d25:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106d2c:	c0 
c0106d2d:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106d34:	00 
c0106d35:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106d3c:	e8 7f 9f ff ff       	call   c0100cc0 <__panic>
        count ++, total += p->property;
c0106d41:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106d45:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106d48:	8b 50 08             	mov    0x8(%eax),%edx
c0106d4b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d4e:	01 d0                	add    %edx,%eax
c0106d50:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106d53:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106d56:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106d59:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106d5c:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106d5f:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106d62:	81 7d e8 18 8b 12 c0 	cmpl   $0xc0128b18,-0x18(%ebp)
c0106d69:	0f 85 79 ff ff ff    	jne    c0106ce8 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c0106d6f:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0106d72:	e8 f3 e1 ff ff       	call   c0104f6a <nr_free_pages>
c0106d77:	39 c3                	cmp    %eax,%ebx
c0106d79:	74 24                	je     c0106d9f <check_swap+0xd5>
c0106d7b:	c7 44 24 0c f6 b5 10 	movl   $0xc010b5f6,0xc(%esp)
c0106d82:	c0 
c0106d83:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106d8a:	c0 
c0106d8b:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0106d92:	00 
c0106d93:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106d9a:	e8 21 9f ff ff       	call   c0100cc0 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c0106d9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106da2:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106da6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106da9:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106dad:	c7 04 24 10 b6 10 c0 	movl   $0xc010b610,(%esp)
c0106db4:	e8 a6 95 ff ff       	call   c010035f <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c0106db9:	e8 0f 0b 00 00       	call   c01078cd <mm_create>
c0106dbe:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c0106dc1:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0106dc5:	75 24                	jne    c0106deb <check_swap+0x121>
c0106dc7:	c7 44 24 0c 36 b6 10 	movl   $0xc010b636,0xc(%esp)
c0106dce:	c0 
c0106dcf:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106dd6:	c0 
c0106dd7:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c0106dde:	00 
c0106ddf:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106de6:	e8 d5 9e ff ff       	call   c0100cc0 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c0106deb:	a1 0c 8c 12 c0       	mov    0xc0128c0c,%eax
c0106df0:	85 c0                	test   %eax,%eax
c0106df2:	74 24                	je     c0106e18 <check_swap+0x14e>
c0106df4:	c7 44 24 0c 41 b6 10 	movl   $0xc010b641,0xc(%esp)
c0106dfb:	c0 
c0106dfc:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106e03:	c0 
c0106e04:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106e0b:	00 
c0106e0c:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106e13:	e8 a8 9e ff ff       	call   c0100cc0 <__panic>

     check_mm_struct = mm;
c0106e18:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e1b:	a3 0c 8c 12 c0       	mov    %eax,0xc0128c0c

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c0106e20:	8b 15 44 6a 12 c0    	mov    0xc0126a44,%edx
c0106e26:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e29:	89 50 0c             	mov    %edx,0xc(%eax)
c0106e2c:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106e2f:	8b 40 0c             	mov    0xc(%eax),%eax
c0106e32:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106e35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106e38:	8b 00                	mov    (%eax),%eax
c0106e3a:	85 c0                	test   %eax,%eax
c0106e3c:	74 24                	je     c0106e62 <check_swap+0x198>
c0106e3e:	c7 44 24 0c 59 b6 10 	movl   $0xc010b659,0xc(%esp)
c0106e45:	c0 
c0106e46:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106e4d:	c0 
c0106e4e:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106e55:	00 
c0106e56:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106e5d:	e8 5e 9e ff ff       	call   c0100cc0 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c0106e62:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106e69:	00 
c0106e6a:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c0106e71:	00 
c0106e72:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106e79:	e8 c7 0a 00 00       	call   c0107945 <vma_create>
c0106e7e:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c0106e81:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106e85:	75 24                	jne    c0106eab <check_swap+0x1e1>
c0106e87:	c7 44 24 0c 67 b6 10 	movl   $0xc010b667,0xc(%esp)
c0106e8e:	c0 
c0106e8f:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106e96:	c0 
c0106e97:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c0106e9e:	00 
c0106e9f:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106ea6:	e8 15 9e ff ff       	call   c0100cc0 <__panic>

     insert_vma_struct(mm, vma);
c0106eab:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0106eae:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106eb2:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106eb5:	89 04 24             	mov    %eax,(%esp)
c0106eb8:	e8 18 0c 00 00       	call   c0107ad5 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c0106ebd:	c7 04 24 74 b6 10 c0 	movl   $0xc010b674,(%esp)
c0106ec4:	e8 96 94 ff ff       	call   c010035f <cprintf>
     pte_t *temp_ptep=NULL;
c0106ec9:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c0106ed0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ed3:	8b 40 0c             	mov    0xc(%eax),%eax
c0106ed6:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0106edd:	00 
c0106ede:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0106ee5:	00 
c0106ee6:	89 04 24             	mov    %eax,(%esp)
c0106ee9:	e8 45 e7 ff ff       	call   c0105633 <get_pte>
c0106eee:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c0106ef1:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106ef5:	75 24                	jne    c0106f1b <check_swap+0x251>
c0106ef7:	c7 44 24 0c a8 b6 10 	movl   $0xc010b6a8,0xc(%esp)
c0106efe:	c0 
c0106eff:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106f06:	c0 
c0106f07:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0106f0e:	00 
c0106f0f:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106f16:	e8 a5 9d ff ff       	call   c0100cc0 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106f1b:	c7 04 24 bc b6 10 c0 	movl   $0xc010b6bc,(%esp)
c0106f22:	e8 38 94 ff ff       	call   c010035f <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106f27:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106f2e:	e9 a3 00 00 00       	jmp    c0106fd6 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c0106f33:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106f3a:	e8 8e df ff ff       	call   c0104ecd <alloc_pages>
c0106f3f:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106f42:	89 04 95 40 8b 12 c0 	mov    %eax,-0x3fed74c0(,%edx,4)
          assert(check_rp[i] != NULL );
c0106f49:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f4c:	8b 04 85 40 8b 12 c0 	mov    -0x3fed74c0(,%eax,4),%eax
c0106f53:	85 c0                	test   %eax,%eax
c0106f55:	75 24                	jne    c0106f7b <check_swap+0x2b1>
c0106f57:	c7 44 24 0c e0 b6 10 	movl   $0xc010b6e0,0xc(%esp)
c0106f5e:	c0 
c0106f5f:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106f66:	c0 
c0106f67:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0106f6e:	00 
c0106f6f:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106f76:	e8 45 9d ff ff       	call   c0100cc0 <__panic>
          assert(!PageProperty(check_rp[i]));
c0106f7b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106f7e:	8b 04 85 40 8b 12 c0 	mov    -0x3fed74c0(,%eax,4),%eax
c0106f85:	83 c0 04             	add    $0x4,%eax
c0106f88:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c0106f8f:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0106f92:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0106f95:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0106f98:	0f a3 10             	bt     %edx,(%eax)
c0106f9b:	19 db                	sbb    %ebx,%ebx
c0106f9d:	89 5d ac             	mov    %ebx,-0x54(%ebp)
    return oldbit != 0;
c0106fa0:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c0106fa4:	0f 95 c0             	setne  %al
c0106fa7:	0f b6 c0             	movzbl %al,%eax
c0106faa:	85 c0                	test   %eax,%eax
c0106fac:	74 24                	je     c0106fd2 <check_swap+0x308>
c0106fae:	c7 44 24 0c f4 b6 10 	movl   $0xc010b6f4,0xc(%esp)
c0106fb5:	c0 
c0106fb6:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0106fbd:	c0 
c0106fbe:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0106fc5:	00 
c0106fc6:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0106fcd:	e8 ee 9c ff ff       	call   c0100cc0 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106fd2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106fd6:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106fda:	0f 8e 53 ff ff ff    	jle    c0106f33 <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c0106fe0:	a1 18 8b 12 c0       	mov    0xc0128b18,%eax
c0106fe5:	8b 15 1c 8b 12 c0    	mov    0xc0128b1c,%edx
c0106feb:	89 45 98             	mov    %eax,-0x68(%ebp)
c0106fee:	89 55 9c             	mov    %edx,-0x64(%ebp)
c0106ff1:	c7 45 a8 18 8b 12 c0 	movl   $0xc0128b18,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106ff8:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106ffb:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106ffe:	89 50 04             	mov    %edx,0x4(%eax)
c0107001:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0107004:	8b 50 04             	mov    0x4(%eax),%edx
c0107007:	8b 45 a8             	mov    -0x58(%ebp),%eax
c010700a:	89 10                	mov    %edx,(%eax)
c010700c:	c7 45 a4 18 8b 12 c0 	movl   $0xc0128b18,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0107013:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0107016:	8b 40 04             	mov    0x4(%eax),%eax
c0107019:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c010701c:	0f 94 c0             	sete   %al
c010701f:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0107022:	85 c0                	test   %eax,%eax
c0107024:	75 24                	jne    c010704a <check_swap+0x380>
c0107026:	c7 44 24 0c 0f b7 10 	movl   $0xc010b70f,0xc(%esp)
c010702d:	c0 
c010702e:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0107035:	c0 
c0107036:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c010703d:	00 
c010703e:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0107045:	e8 76 9c ff ff       	call   c0100cc0 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c010704a:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c010704f:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0107052:	c7 05 20 8b 12 c0 00 	movl   $0x0,0xc0128b20
c0107059:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010705c:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107063:	eb 1e                	jmp    c0107083 <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0107065:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107068:	8b 04 85 40 8b 12 c0 	mov    -0x3fed74c0(,%eax,4),%eax
c010706f:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107076:	00 
c0107077:	89 04 24             	mov    %eax,(%esp)
c010707a:	e8 b9 de ff ff       	call   c0104f38 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c010707f:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0107083:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0107087:	7e dc                	jle    c0107065 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0107089:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c010708e:	83 f8 04             	cmp    $0x4,%eax
c0107091:	74 24                	je     c01070b7 <check_swap+0x3ed>
c0107093:	c7 44 24 0c 28 b7 10 	movl   $0xc010b728,0xc(%esp)
c010709a:	c0 
c010709b:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c01070a2:	c0 
c01070a3:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c01070aa:	00 
c01070ab:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c01070b2:	e8 09 9c ff ff       	call   c0100cc0 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c01070b7:	c7 04 24 4c b7 10 c0 	movl   $0xc010b74c,(%esp)
c01070be:	e8 9c 92 ff ff       	call   c010035f <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c01070c3:	c7 05 d8 6a 12 c0 00 	movl   $0x0,0xc0126ad8
c01070ca:	00 00 00 
     
     check_content_set();
c01070cd:	e8 28 fa ff ff       	call   c0106afa <check_content_set>
     assert( nr_free == 0);         
c01070d2:	a1 20 8b 12 c0       	mov    0xc0128b20,%eax
c01070d7:	85 c0                	test   %eax,%eax
c01070d9:	74 24                	je     c01070ff <check_swap+0x435>
c01070db:	c7 44 24 0c 73 b7 10 	movl   $0xc010b773,0xc(%esp)
c01070e2:	c0 
c01070e3:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c01070ea:	c0 
c01070eb:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c01070f2:	00 
c01070f3:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c01070fa:	e8 c1 9b ff ff       	call   c0100cc0 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c01070ff:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0107106:	eb 26                	jmp    c010712e <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0107108:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010710b:	c7 04 85 60 8b 12 c0 	movl   $0xffffffff,-0x3fed74a0(,%eax,4)
c0107112:	ff ff ff ff 
c0107116:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107119:	8b 14 85 60 8b 12 c0 	mov    -0x3fed74a0(,%eax,4),%edx
c0107120:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107123:	89 14 85 a0 8b 12 c0 	mov    %edx,-0x3fed7460(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c010712a:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010712e:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0107132:	7e d4                	jle    c0107108 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107134:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010713b:	e9 eb 00 00 00       	jmp    c010722b <check_swap+0x561>
         check_ptep[i]=0;
c0107140:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107143:	c7 04 85 f4 8b 12 c0 	movl   $0x0,-0x3fed740c(,%eax,4)
c010714a:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c010714e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107151:	83 c0 01             	add    $0x1,%eax
c0107154:	c1 e0 0c             	shl    $0xc,%eax
c0107157:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010715e:	00 
c010715f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107163:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107166:	89 04 24             	mov    %eax,(%esp)
c0107169:	e8 c5 e4 ff ff       	call   c0105633 <get_pte>
c010716e:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107171:	89 04 95 f4 8b 12 c0 	mov    %eax,-0x3fed740c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0107178:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010717b:	8b 04 85 f4 8b 12 c0 	mov    -0x3fed740c(,%eax,4),%eax
c0107182:	85 c0                	test   %eax,%eax
c0107184:	75 24                	jne    c01071aa <check_swap+0x4e0>
c0107186:	c7 44 24 0c 80 b7 10 	movl   $0xc010b780,0xc(%esp)
c010718d:	c0 
c010718e:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0107195:	c0 
c0107196:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010719d:	00 
c010719e:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c01071a5:	e8 16 9b ff ff       	call   c0100cc0 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c01071aa:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071ad:	8b 04 85 f4 8b 12 c0 	mov    -0x3fed740c(,%eax,4),%eax
c01071b4:	8b 00                	mov    (%eax),%eax
c01071b6:	89 04 24             	mov    %eax,(%esp)
c01071b9:	e8 9f f5 ff ff       	call   c010675d <pte2page>
c01071be:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01071c1:	8b 14 95 40 8b 12 c0 	mov    -0x3fed74c0(,%edx,4),%edx
c01071c8:	39 d0                	cmp    %edx,%eax
c01071ca:	74 24                	je     c01071f0 <check_swap+0x526>
c01071cc:	c7 44 24 0c 98 b7 10 	movl   $0xc010b798,0xc(%esp)
c01071d3:	c0 
c01071d4:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c01071db:	c0 
c01071dc:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c01071e3:	00 
c01071e4:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c01071eb:	e8 d0 9a ff ff       	call   c0100cc0 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c01071f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01071f3:	8b 04 85 f4 8b 12 c0 	mov    -0x3fed740c(,%eax,4),%eax
c01071fa:	8b 00                	mov    (%eax),%eax
c01071fc:	83 e0 01             	and    $0x1,%eax
c01071ff:	85 c0                	test   %eax,%eax
c0107201:	75 24                	jne    c0107227 <check_swap+0x55d>
c0107203:	c7 44 24 0c c0 b7 10 	movl   $0xc010b7c0,0xc(%esp)
c010720a:	c0 
c010720b:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c0107212:	c0 
c0107213:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c010721a:	00 
c010721b:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c0107222:	e8 99 9a ff ff       	call   c0100cc0 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107227:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010722b:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010722f:	0f 8e 0b ff ff ff    	jle    c0107140 <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0107235:	c7 04 24 dc b7 10 c0 	movl   $0xc010b7dc,(%esp)
c010723c:	e8 1e 91 ff ff       	call   c010035f <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0107241:	e8 6c fa ff ff       	call   c0106cb2 <check_content_access>
c0107246:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0107249:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010724d:	74 24                	je     c0107273 <check_swap+0x5a9>
c010724f:	c7 44 24 0c 02 b8 10 	movl   $0xc010b802,0xc(%esp)
c0107256:	c0 
c0107257:	c7 44 24 08 ea b4 10 	movl   $0xc010b4ea,0x8(%esp)
c010725e:	c0 
c010725f:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0107266:	00 
c0107267:	c7 04 24 84 b4 10 c0 	movl   $0xc010b484,(%esp)
c010726e:	e8 4d 9a ff ff       	call   c0100cc0 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107273:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010727a:	eb 1e                	jmp    c010729a <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c010727c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010727f:	8b 04 85 40 8b 12 c0 	mov    -0x3fed74c0(,%eax,4),%eax
c0107286:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010728d:	00 
c010728e:	89 04 24             	mov    %eax,(%esp)
c0107291:	e8 a2 dc ff ff       	call   c0104f38 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0107296:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c010729a:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c010729e:	7e dc                	jle    c010727c <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c01072a0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01072a3:	89 04 24             	mov    %eax,(%esp)
c01072a6:	e8 5b 09 00 00       	call   c0107c06 <mm_destroy>
         
     nr_free = nr_free_store;
c01072ab:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01072ae:	a3 20 8b 12 c0       	mov    %eax,0xc0128b20
     free_list = free_list_store;
c01072b3:	8b 45 98             	mov    -0x68(%ebp),%eax
c01072b6:	8b 55 9c             	mov    -0x64(%ebp),%edx
c01072b9:	a3 18 8b 12 c0       	mov    %eax,0xc0128b18
c01072be:	89 15 1c 8b 12 c0    	mov    %edx,0xc0128b1c

     
     le = &free_list;
c01072c4:	c7 45 e8 18 8b 12 c0 	movl   $0xc0128b18,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01072cb:	eb 1f                	jmp    c01072ec <check_swap+0x622>
         struct Page *p = le2page(le, page_link);
c01072cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072d0:	83 e8 0c             	sub    $0xc,%eax
c01072d3:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c01072d6:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01072da:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01072dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01072e0:	8b 40 08             	mov    0x8(%eax),%eax
c01072e3:	89 d1                	mov    %edx,%ecx
c01072e5:	29 c1                	sub    %eax,%ecx
c01072e7:	89 c8                	mov    %ecx,%eax
c01072e9:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01072ec:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01072ef:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01072f2:	8b 45 a0             	mov    -0x60(%ebp),%eax
c01072f5:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c01072f8:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01072fb:	81 7d e8 18 8b 12 c0 	cmpl   $0xc0128b18,-0x18(%ebp)
c0107302:	75 c9                	jne    c01072cd <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0107304:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107307:	89 44 24 08          	mov    %eax,0x8(%esp)
c010730b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010730e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107312:	c7 04 24 09 b8 10 c0 	movl   $0xc010b809,(%esp)
c0107319:	e8 41 90 ff ff       	call   c010035f <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c010731e:	c7 04 24 23 b8 10 c0 	movl   $0xc010b823,(%esp)
c0107325:	e8 35 90 ff ff       	call   c010035f <cprintf>
}
c010732a:	83 c4 74             	add    $0x74,%esp
c010732d:	5b                   	pop    %ebx
c010732e:	5d                   	pop    %ebp
c010732f:	c3                   	ret    

c0107330 <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0107330:	55                   	push   %ebp
c0107331:	89 e5                	mov    %esp,%ebp
c0107333:	83 ec 10             	sub    $0x10,%esp
c0107336:	c7 45 fc 04 8c 12 c0 	movl   $0xc0128c04,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c010733d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107340:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107343:	89 50 04             	mov    %edx,0x4(%eax)
c0107346:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0107349:	8b 50 04             	mov    0x4(%eax),%edx
c010734c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010734f:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0107351:	8b 45 08             	mov    0x8(%ebp),%eax
c0107354:	c7 40 14 04 8c 12 c0 	movl   $0xc0128c04,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c010735b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107360:	c9                   	leave  
c0107361:	c3                   	ret    

c0107362 <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0107362:	55                   	push   %ebp
c0107363:	89 e5                	mov    %esp,%ebp
c0107365:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0107368:	8b 45 08             	mov    0x8(%ebp),%eax
c010736b:	8b 40 14             	mov    0x14(%eax),%eax
c010736e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0107371:	8b 45 10             	mov    0x10(%ebp),%eax
c0107374:	83 c0 14             	add    $0x14,%eax
c0107377:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c010737a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010737e:	74 06                	je     c0107386 <_fifo_map_swappable+0x24>
c0107380:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107384:	75 24                	jne    c01073aa <_fifo_map_swappable+0x48>
c0107386:	c7 44 24 0c 3c b8 10 	movl   $0xc010b83c,0xc(%esp)
c010738d:	c0 
c010738e:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107395:	c0 
c0107396:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c010739d:	00 
c010739e:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c01073a5:	e8 16 99 ff ff       	call   c0100cc0 <__panic>
c01073aa:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073ad:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01073b0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073b3:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c01073b6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073b9:	8b 00                	mov    (%eax),%eax
c01073bb:	8b 55 e8             	mov    -0x18(%ebp),%edx
c01073be:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c01073c1:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01073c4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01073c7:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01073ca:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01073cd:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01073d0:	89 10                	mov    %edx,(%eax)
c01073d2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01073d5:	8b 10                	mov    (%eax),%edx
c01073d7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01073da:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01073dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01073e0:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01073e3:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01073e6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01073e9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01073ec:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
    list_add_before(head, entry);       
    return 0;
c01073ee:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01073f3:	c9                   	leave  
c01073f4:	c3                   	ret    

c01073f5 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c01073f5:	55                   	push   %ebp
c01073f6:	89 e5                	mov    %esp,%ebp
c01073f8:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c01073fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01073fe:	8b 40 14             	mov    0x14(%eax),%eax
c0107401:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0107404:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107408:	75 24                	jne    c010742e <_fifo_swap_out_victim+0x39>
c010740a:	c7 44 24 0c 83 b8 10 	movl   $0xc010b883,0xc(%esp)
c0107411:	c0 
c0107412:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107419:	c0 
c010741a:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0107421:	00 
c0107422:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107429:	e8 92 98 ff ff       	call   c0100cc0 <__panic>
     assert(in_tick==0);
c010742e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0107432:	74 24                	je     c0107458 <_fifo_swap_out_victim+0x63>
c0107434:	c7 44 24 0c 90 b8 10 	movl   $0xc010b890,0xc(%esp)
c010743b:	c0 
c010743c:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107443:	c0 
c0107444:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c010744b:	00 
c010744c:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107453:	e8 68 98 ff ff       	call   c0100cc0 <__panic>
c0107458:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010745b:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010745e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107461:	8b 40 04             	mov    0x4(%eax),%eax
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *le = list_next(head);
c0107464:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head!=le);
c0107467:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010746a:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010746d:	75 24                	jne    c0107493 <_fifo_swap_out_victim+0x9e>
c010746f:	c7 44 24 0c 9b b8 10 	movl   $0xc010b89b,0xc(%esp)
c0107476:	c0 
c0107477:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c010747e:	c0 
c010747f:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0107486:	00 
c0107487:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c010748e:	e8 2d 98 ff ff       	call   c0100cc0 <__panic>
     struct Page *p = le2page(le, pra_page_link);
c0107493:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107496:	83 e8 14             	sub    $0x14,%eax
c0107499:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010749c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010749f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01074a2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01074a5:	8b 40 04             	mov    0x4(%eax),%eax
c01074a8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01074ab:	8b 12                	mov    (%edx),%edx
c01074ad:	89 55 e0             	mov    %edx,-0x20(%ebp)
c01074b0:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01074b3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01074b6:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01074b9:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01074bc:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01074bf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c01074c2:	89 10                	mov    %edx,(%eax)
     list_del(le);
     assert(p !=NULL);
c01074c4:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01074c8:	75 24                	jne    c01074ee <_fifo_swap_out_victim+0xf9>
c01074ca:	c7 44 24 0c a4 b8 10 	movl   $0xc010b8a4,0xc(%esp)
c01074d1:	c0 
c01074d2:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c01074d9:	c0 
c01074da:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c01074e1:	00 
c01074e2:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c01074e9:	e8 d2 97 ff ff       	call   c0100cc0 <__panic>
     *ptr_page = p;        
c01074ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074f1:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01074f4:	89 10                	mov    %edx,(%eax)
     return 0;
c01074f6:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01074fb:	c9                   	leave  
c01074fc:	c3                   	ret    

c01074fd <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c01074fd:	55                   	push   %ebp
c01074fe:	89 e5                	mov    %esp,%ebp
c0107500:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107503:	c7 04 24 b0 b8 10 c0 	movl   $0xc010b8b0,(%esp)
c010750a:	e8 50 8e ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c010750f:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107514:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0107517:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c010751c:	83 f8 04             	cmp    $0x4,%eax
c010751f:	74 24                	je     c0107545 <_fifo_check_swap+0x48>
c0107521:	c7 44 24 0c d6 b8 10 	movl   $0xc010b8d6,0xc(%esp)
c0107528:	c0 
c0107529:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107530:	c0 
c0107531:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c0107538:	00 
c0107539:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107540:	e8 7b 97 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0107545:	c7 04 24 e8 b8 10 c0 	movl   $0xc010b8e8,(%esp)
c010754c:	e8 0e 8e ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0107551:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107556:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0107559:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c010755e:	83 f8 04             	cmp    $0x4,%eax
c0107561:	74 24                	je     c0107587 <_fifo_check_swap+0x8a>
c0107563:	c7 44 24 0c d6 b8 10 	movl   $0xc010b8d6,0xc(%esp)
c010756a:	c0 
c010756b:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107572:	c0 
c0107573:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c010757a:	00 
c010757b:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107582:	e8 39 97 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107587:	c7 04 24 10 b9 10 c0 	movl   $0xc010b910,(%esp)
c010758e:	e8 cc 8d ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107593:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107598:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c010759b:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c01075a0:	83 f8 04             	cmp    $0x4,%eax
c01075a3:	74 24                	je     c01075c9 <_fifo_check_swap+0xcc>
c01075a5:	c7 44 24 0c d6 b8 10 	movl   $0xc010b8d6,0xc(%esp)
c01075ac:	c0 
c01075ad:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c01075b4:	c0 
c01075b5:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c01075bc:	00 
c01075bd:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c01075c4:	e8 f7 96 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01075c9:	c7 04 24 38 b9 10 c0 	movl   $0xc010b938,(%esp)
c01075d0:	e8 8a 8d ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01075d5:	b8 00 20 00 00       	mov    $0x2000,%eax
c01075da:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c01075dd:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c01075e2:	83 f8 04             	cmp    $0x4,%eax
c01075e5:	74 24                	je     c010760b <_fifo_check_swap+0x10e>
c01075e7:	c7 44 24 0c d6 b8 10 	movl   $0xc010b8d6,0xc(%esp)
c01075ee:	c0 
c01075ef:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c01075f6:	c0 
c01075f7:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c01075fe:	00 
c01075ff:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107606:	e8 b5 96 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c010760b:	c7 04 24 60 b9 10 c0 	movl   $0xc010b960,(%esp)
c0107612:	e8 48 8d ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107617:	b8 00 50 00 00       	mov    $0x5000,%eax
c010761c:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c010761f:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0107624:	83 f8 05             	cmp    $0x5,%eax
c0107627:	74 24                	je     c010764d <_fifo_check_swap+0x150>
c0107629:	c7 44 24 0c 86 b9 10 	movl   $0xc010b986,0xc(%esp)
c0107630:	c0 
c0107631:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107638:	c0 
c0107639:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c0107640:	00 
c0107641:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107648:	e8 73 96 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c010764d:	c7 04 24 38 b9 10 c0 	movl   $0xc010b938,(%esp)
c0107654:	e8 06 8d ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107659:	b8 00 20 00 00       	mov    $0x2000,%eax
c010765e:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c0107661:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0107666:	83 f8 05             	cmp    $0x5,%eax
c0107669:	74 24                	je     c010768f <_fifo_check_swap+0x192>
c010766b:	c7 44 24 0c 86 b9 10 	movl   $0xc010b986,0xc(%esp)
c0107672:	c0 
c0107673:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c010767a:	c0 
c010767b:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c0107682:	00 
c0107683:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c010768a:	e8 31 96 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010768f:	c7 04 24 e8 b8 10 c0 	movl   $0xc010b8e8,(%esp)
c0107696:	e8 c4 8c ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c010769b:	b8 00 10 00 00       	mov    $0x1000,%eax
c01076a0:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01076a3:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c01076a8:	83 f8 06             	cmp    $0x6,%eax
c01076ab:	74 24                	je     c01076d1 <_fifo_check_swap+0x1d4>
c01076ad:	c7 44 24 0c 95 b9 10 	movl   $0xc010b995,0xc(%esp)
c01076b4:	c0 
c01076b5:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c01076bc:	c0 
c01076bd:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01076c4:	00 
c01076c5:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c01076cc:	e8 ef 95 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01076d1:	c7 04 24 38 b9 10 c0 	movl   $0xc010b938,(%esp)
c01076d8:	e8 82 8c ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01076dd:	b8 00 20 00 00       	mov    $0x2000,%eax
c01076e2:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01076e5:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c01076ea:	83 f8 07             	cmp    $0x7,%eax
c01076ed:	74 24                	je     c0107713 <_fifo_check_swap+0x216>
c01076ef:	c7 44 24 0c a4 b9 10 	movl   $0xc010b9a4,0xc(%esp)
c01076f6:	c0 
c01076f7:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c01076fe:	c0 
c01076ff:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107706:	00 
c0107707:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c010770e:	e8 ad 95 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c0107713:	c7 04 24 b0 b8 10 c0 	movl   $0xc010b8b0,(%esp)
c010771a:	e8 40 8c ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c010771f:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107724:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107727:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c010772c:	83 f8 08             	cmp    $0x8,%eax
c010772f:	74 24                	je     c0107755 <_fifo_check_swap+0x258>
c0107731:	c7 44 24 0c b3 b9 10 	movl   $0xc010b9b3,0xc(%esp)
c0107738:	c0 
c0107739:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107740:	c0 
c0107741:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107748:	00 
c0107749:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107750:	e8 6b 95 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107755:	c7 04 24 10 b9 10 c0 	movl   $0xc010b910,(%esp)
c010775c:	e8 fe 8b ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0107761:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107766:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107769:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c010776e:	83 f8 09             	cmp    $0x9,%eax
c0107771:	74 24                	je     c0107797 <_fifo_check_swap+0x29a>
c0107773:	c7 44 24 0c c2 b9 10 	movl   $0xc010b9c2,0xc(%esp)
c010777a:	c0 
c010777b:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107782:	c0 
c0107783:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c010778a:	00 
c010778b:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107792:	e8 29 95 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107797:	c7 04 24 60 b9 10 c0 	movl   $0xc010b960,(%esp)
c010779e:	e8 bc 8b ff ff       	call   c010035f <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01077a3:	b8 00 50 00 00       	mov    $0x5000,%eax
c01077a8:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c01077ab:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c01077b0:	83 f8 0a             	cmp    $0xa,%eax
c01077b3:	74 24                	je     c01077d9 <_fifo_check_swap+0x2dc>
c01077b5:	c7 44 24 0c d1 b9 10 	movl   $0xc010b9d1,0xc(%esp)
c01077bc:	c0 
c01077bd:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c01077c4:	c0 
c01077c5:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c01077cc:	00 
c01077cd:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c01077d4:	e8 e7 94 ff ff       	call   c0100cc0 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01077d9:	c7 04 24 e8 b8 10 c0 	movl   $0xc010b8e8,(%esp)
c01077e0:	e8 7a 8b ff ff       	call   c010035f <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c01077e5:	b8 00 10 00 00       	mov    $0x1000,%eax
c01077ea:	0f b6 00             	movzbl (%eax),%eax
c01077ed:	3c 0a                	cmp    $0xa,%al
c01077ef:	74 24                	je     c0107815 <_fifo_check_swap+0x318>
c01077f1:	c7 44 24 0c e4 b9 10 	movl   $0xc010b9e4,0xc(%esp)
c01077f8:	c0 
c01077f9:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107800:	c0 
c0107801:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0107808:	00 
c0107809:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107810:	e8 ab 94 ff ff       	call   c0100cc0 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0107815:	b8 00 10 00 00       	mov    $0x1000,%eax
c010781a:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c010781d:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c0107822:	83 f8 0b             	cmp    $0xb,%eax
c0107825:	74 24                	je     c010784b <_fifo_check_swap+0x34e>
c0107827:	c7 44 24 0c 05 ba 10 	movl   $0xc010ba05,0xc(%esp)
c010782e:	c0 
c010782f:	c7 44 24 08 5a b8 10 	movl   $0xc010b85a,0x8(%esp)
c0107836:	c0 
c0107837:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c010783e:	00 
c010783f:	c7 04 24 6f b8 10 c0 	movl   $0xc010b86f,(%esp)
c0107846:	e8 75 94 ff ff       	call   c0100cc0 <__panic>
    return 0;
c010784b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107850:	c9                   	leave  
c0107851:	c3                   	ret    

c0107852 <_fifo_init>:


static int
_fifo_init(void)
{
c0107852:	55                   	push   %ebp
c0107853:	89 e5                	mov    %esp,%ebp
    return 0;
c0107855:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010785a:	5d                   	pop    %ebp
c010785b:	c3                   	ret    

c010785c <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c010785c:	55                   	push   %ebp
c010785d:	89 e5                	mov    %esp,%ebp
    return 0;
c010785f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107864:	5d                   	pop    %ebp
c0107865:	c3                   	ret    

c0107866 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107866:	55                   	push   %ebp
c0107867:	89 e5                	mov    %esp,%ebp
c0107869:	b8 00 00 00 00       	mov    $0x0,%eax
c010786e:	5d                   	pop    %ebp
c010786f:	c3                   	ret    

c0107870 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0107870:	55                   	push   %ebp
c0107871:	89 e5                	mov    %esp,%ebp
c0107873:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107876:	8b 45 08             	mov    0x8(%ebp),%eax
c0107879:	89 c2                	mov    %eax,%edx
c010787b:	c1 ea 0c             	shr    $0xc,%edx
c010787e:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0107883:	39 c2                	cmp    %eax,%edx
c0107885:	72 1c                	jb     c01078a3 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107887:	c7 44 24 08 28 ba 10 	movl   $0xc010ba28,0x8(%esp)
c010788e:	c0 
c010788f:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0107896:	00 
c0107897:	c7 04 24 47 ba 10 c0 	movl   $0xc010ba47,(%esp)
c010789e:	e8 1d 94 ff ff       	call   c0100cc0 <__panic>
    }
    return &pages[PPN(pa)];
c01078a3:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c01078a8:	8b 55 08             	mov    0x8(%ebp),%edx
c01078ab:	c1 ea 0c             	shr    $0xc,%edx
c01078ae:	c1 e2 05             	shl    $0x5,%edx
c01078b1:	01 d0                	add    %edx,%eax
}
c01078b3:	c9                   	leave  
c01078b4:	c3                   	ret    

c01078b5 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c01078b5:	55                   	push   %ebp
c01078b6:	89 e5                	mov    %esp,%ebp
c01078b8:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01078bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01078be:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01078c3:	89 04 24             	mov    %eax,(%esp)
c01078c6:	e8 a5 ff ff ff       	call   c0107870 <pa2page>
}
c01078cb:	c9                   	leave  
c01078cc:	c3                   	ret    

c01078cd <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01078cd:	55                   	push   %ebp
c01078ce:	89 e5                	mov    %esp,%ebp
c01078d0:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01078d3:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01078da:	e8 67 d1 ff ff       	call   c0104a46 <kmalloc>
c01078df:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01078e2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01078e6:	74 58                	je     c0107940 <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01078e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078eb:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01078ee:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078f1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01078f4:	89 50 04             	mov    %edx,0x4(%eax)
c01078f7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078fa:	8b 50 04             	mov    0x4(%eax),%edx
c01078fd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107900:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c0107902:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107905:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c010790c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010790f:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107916:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107919:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c0107920:	a1 cc 6a 12 c0       	mov    0xc0126acc,%eax
c0107925:	85 c0                	test   %eax,%eax
c0107927:	74 0d                	je     c0107936 <mm_create+0x69>
c0107929:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010792c:	89 04 24             	mov    %eax,(%esp)
c010792f:	e8 f7 ee ff ff       	call   c010682b <swap_init_mm>
c0107934:	eb 0a                	jmp    c0107940 <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107936:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107939:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c0107940:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0107943:	c9                   	leave  
c0107944:	c3                   	ret    

c0107945 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107945:	55                   	push   %ebp
c0107946:	89 e5                	mov    %esp,%ebp
c0107948:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c010794b:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c0107952:	e8 ef d0 ff ff       	call   c0104a46 <kmalloc>
c0107957:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c010795a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010795e:	74 1b                	je     c010797b <vma_create+0x36>
        vma->vm_start = vm_start;
c0107960:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107963:	8b 55 08             	mov    0x8(%ebp),%edx
c0107966:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107969:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010796c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010796f:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c0107972:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107975:	8b 55 10             	mov    0x10(%ebp),%edx
c0107978:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c010797b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010797e:	c9                   	leave  
c010797f:	c3                   	ret    

c0107980 <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c0107980:	55                   	push   %ebp
c0107981:	89 e5                	mov    %esp,%ebp
c0107983:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107986:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c010798d:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0107991:	0f 84 95 00 00 00    	je     c0107a2c <find_vma+0xac>
        vma = mm->mmap_cache;
c0107997:	8b 45 08             	mov    0x8(%ebp),%eax
c010799a:	8b 40 08             	mov    0x8(%eax),%eax
c010799d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01079a0:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01079a4:	74 16                	je     c01079bc <find_vma+0x3c>
c01079a6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01079a9:	8b 40 04             	mov    0x4(%eax),%eax
c01079ac:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01079af:	77 0b                	ja     c01079bc <find_vma+0x3c>
c01079b1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01079b4:	8b 40 08             	mov    0x8(%eax),%eax
c01079b7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01079ba:	77 61                	ja     c0107a1d <find_vma+0x9d>
                bool found = 0;
c01079bc:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01079c3:	8b 45 08             	mov    0x8(%ebp),%eax
c01079c6:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01079c9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01079cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01079cf:	eb 28                	jmp    c01079f9 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01079d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079d4:	83 e8 10             	sub    $0x10,%eax
c01079d7:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01079da:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01079dd:	8b 40 04             	mov    0x4(%eax),%eax
c01079e0:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01079e3:	77 14                	ja     c01079f9 <find_vma+0x79>
c01079e5:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01079e8:	8b 40 08             	mov    0x8(%eax),%eax
c01079eb:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01079ee:	76 09                	jbe    c01079f9 <find_vma+0x79>
                        found = 1;
c01079f0:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c01079f7:	eb 17                	jmp    c0107a10 <find_vma+0x90>
c01079f9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079fc:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01079ff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107a02:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107a05:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107a08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a0b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107a0e:	75 c1                	jne    c01079d1 <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c0107a10:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107a14:	75 07                	jne    c0107a1d <find_vma+0x9d>
                    vma = NULL;
c0107a16:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107a1d:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0107a21:	74 09                	je     c0107a2c <find_vma+0xac>
            mm->mmap_cache = vma;
c0107a23:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a26:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107a29:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107a2c:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0107a2f:	c9                   	leave  
c0107a30:	c3                   	ret    

c0107a31 <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c0107a31:	55                   	push   %ebp
c0107a32:	89 e5                	mov    %esp,%ebp
c0107a34:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107a37:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a3a:	8b 50 04             	mov    0x4(%eax),%edx
c0107a3d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a40:	8b 40 08             	mov    0x8(%eax),%eax
c0107a43:	39 c2                	cmp    %eax,%edx
c0107a45:	72 24                	jb     c0107a6b <check_vma_overlap+0x3a>
c0107a47:	c7 44 24 0c 55 ba 10 	movl   $0xc010ba55,0xc(%esp)
c0107a4e:	c0 
c0107a4f:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107a56:	c0 
c0107a57:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c0107a5e:	00 
c0107a5f:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107a66:	e8 55 92 ff ff       	call   c0100cc0 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107a6b:	8b 45 08             	mov    0x8(%ebp),%eax
c0107a6e:	8b 50 08             	mov    0x8(%eax),%edx
c0107a71:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107a74:	8b 40 04             	mov    0x4(%eax),%eax
c0107a77:	39 c2                	cmp    %eax,%edx
c0107a79:	76 24                	jbe    c0107a9f <check_vma_overlap+0x6e>
c0107a7b:	c7 44 24 0c 98 ba 10 	movl   $0xc010ba98,0xc(%esp)
c0107a82:	c0 
c0107a83:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107a8a:	c0 
c0107a8b:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107a92:	00 
c0107a93:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107a9a:	e8 21 92 ff ff       	call   c0100cc0 <__panic>
    assert(next->vm_start < next->vm_end);
c0107a9f:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107aa2:	8b 50 04             	mov    0x4(%eax),%edx
c0107aa5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107aa8:	8b 40 08             	mov    0x8(%eax),%eax
c0107aab:	39 c2                	cmp    %eax,%edx
c0107aad:	72 24                	jb     c0107ad3 <check_vma_overlap+0xa2>
c0107aaf:	c7 44 24 0c b7 ba 10 	movl   $0xc010bab7,0xc(%esp)
c0107ab6:	c0 
c0107ab7:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107abe:	c0 
c0107abf:	c7 44 24 04 6a 00 00 	movl   $0x6a,0x4(%esp)
c0107ac6:	00 
c0107ac7:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107ace:	e8 ed 91 ff ff       	call   c0100cc0 <__panic>
}
c0107ad3:	c9                   	leave  
c0107ad4:	c3                   	ret    

c0107ad5 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c0107ad5:	55                   	push   %ebp
c0107ad6:	89 e5                	mov    %esp,%ebp
c0107ad8:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c0107adb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ade:	8b 50 04             	mov    0x4(%eax),%edx
c0107ae1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ae4:	8b 40 08             	mov    0x8(%eax),%eax
c0107ae7:	39 c2                	cmp    %eax,%edx
c0107ae9:	72 24                	jb     c0107b0f <insert_vma_struct+0x3a>
c0107aeb:	c7 44 24 0c d5 ba 10 	movl   $0xc010bad5,0xc(%esp)
c0107af2:	c0 
c0107af3:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107afa:	c0 
c0107afb:	c7 44 24 04 71 00 00 	movl   $0x71,0x4(%esp)
c0107b02:	00 
c0107b03:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107b0a:	e8 b1 91 ff ff       	call   c0100cc0 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c0107b0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107b12:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107b15:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b18:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107b1b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c0107b21:	eb 1f                	jmp    c0107b42 <insert_vma_struct+0x6d>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c0107b23:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b26:	83 e8 10             	sub    $0x10,%eax
c0107b29:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107b2c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b2f:	8b 50 04             	mov    0x4(%eax),%edx
c0107b32:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b35:	8b 40 04             	mov    0x4(%eax),%eax
c0107b38:	39 c2                	cmp    %eax,%edx
c0107b3a:	77 1f                	ja     c0107b5b <insert_vma_struct+0x86>
                break;
            }
            le_prev = le;
c0107b3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b3f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107b42:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b45:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107b48:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107b4b:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107b4e:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107b51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107b54:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b57:	75 ca                	jne    c0107b23 <insert_vma_struct+0x4e>
c0107b59:	eb 01                	jmp    c0107b5c <insert_vma_struct+0x87>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
                break;
c0107b5b:	90                   	nop
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107b5c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b5f:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0107b62:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107b65:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107b68:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107b6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b6e:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b71:	74 15                	je     c0107b88 <insert_vma_struct+0xb3>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c0107b73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b76:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107b79:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b7c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b80:	89 14 24             	mov    %edx,(%esp)
c0107b83:	e8 a9 fe ff ff       	call   c0107a31 <check_vma_overlap>
    }
    if (le_next != list) {
c0107b88:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b8b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b8e:	74 15                	je     c0107ba5 <insert_vma_struct+0xd0>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c0107b90:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107b93:	83 e8 10             	sub    $0x10,%eax
c0107b96:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b9a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107b9d:	89 04 24             	mov    %eax,(%esp)
c0107ba0:	e8 8c fe ff ff       	call   c0107a31 <check_vma_overlap>
    }

    vma->vm_mm = mm;
c0107ba5:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107ba8:	8b 55 08             	mov    0x8(%ebp),%edx
c0107bab:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c0107bad:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107bb0:	8d 50 10             	lea    0x10(%eax),%edx
c0107bb3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107bb6:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107bb9:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0107bbc:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107bbf:	8b 40 04             	mov    0x4(%eax),%eax
c0107bc2:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0107bc5:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0107bc8:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0107bcb:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0107bce:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0107bd1:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107bd4:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0107bd7:	89 10                	mov    %edx,(%eax)
c0107bd9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0107bdc:	8b 10                	mov    (%eax),%edx
c0107bde:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107be1:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0107be4:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107be7:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0107bea:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0107bed:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107bf0:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0107bf3:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107bf5:	8b 45 08             	mov    0x8(%ebp),%eax
c0107bf8:	8b 40 10             	mov    0x10(%eax),%eax
c0107bfb:	8d 50 01             	lea    0x1(%eax),%edx
c0107bfe:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c01:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107c04:	c9                   	leave  
c0107c05:	c3                   	ret    

c0107c06 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107c06:	55                   	push   %ebp
c0107c07:	89 e5                	mov    %esp,%ebp
c0107c09:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107c0c:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c0f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c0107c12:	eb 36                	jmp    c0107c4a <mm_destroy+0x44>
c0107c14:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c17:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107c1a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107c1d:	8b 40 04             	mov    0x4(%eax),%eax
c0107c20:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0107c23:	8b 12                	mov    (%edx),%edx
c0107c25:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107c28:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107c2b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c2e:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107c31:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107c34:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c37:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107c3a:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
c0107c3c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c3f:	83 e8 10             	sub    $0x10,%eax
c0107c42:	89 04 24             	mov    %eax,(%esp)
c0107c45:	e8 17 ce ff ff       	call   c0104a61 <kfree>
c0107c4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107c4d:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107c50:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107c53:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c0107c56:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0107c59:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107c5c:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107c5f:	75 b3                	jne    c0107c14 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link));  //kfree vma        
    }
    kfree(mm); //kfree mm
c0107c61:	8b 45 08             	mov    0x8(%ebp),%eax
c0107c64:	89 04 24             	mov    %eax,(%esp)
c0107c67:	e8 f5 cd ff ff       	call   c0104a61 <kfree>
    mm=NULL;
c0107c6c:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c0107c73:	c9                   	leave  
c0107c74:	c3                   	ret    

c0107c75 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107c75:	55                   	push   %ebp
c0107c76:	89 e5                	mov    %esp,%ebp
c0107c78:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107c7b:	e8 02 00 00 00       	call   c0107c82 <check_vmm>
}
c0107c80:	c9                   	leave  
c0107c81:	c3                   	ret    

c0107c82 <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c0107c82:	55                   	push   %ebp
c0107c83:	89 e5                	mov    %esp,%ebp
c0107c85:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107c88:	e8 dd d2 ff ff       	call   c0104f6a <nr_free_pages>
c0107c8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c0107c90:	e8 13 00 00 00       	call   c0107ca8 <check_vma_struct>
    check_pgfault();
c0107c95:	e8 a7 04 00 00       	call   c0108141 <check_pgfault>

    cprintf("check_vmm() succeeded.\n");
c0107c9a:	c7 04 24 f1 ba 10 c0 	movl   $0xc010baf1,(%esp)
c0107ca1:	e8 b9 86 ff ff       	call   c010035f <cprintf>
}
c0107ca6:	c9                   	leave  
c0107ca7:	c3                   	ret    

c0107ca8 <check_vma_struct>:

static void
check_vma_struct(void) {
c0107ca8:	55                   	push   %ebp
c0107ca9:	89 e5                	mov    %esp,%ebp
c0107cab:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107cae:	e8 b7 d2 ff ff       	call   c0104f6a <nr_free_pages>
c0107cb3:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107cb6:	e8 12 fc ff ff       	call   c01078cd <mm_create>
c0107cbb:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107cbe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0107cc2:	75 24                	jne    c0107ce8 <check_vma_struct+0x40>
c0107cc4:	c7 44 24 0c 09 bb 10 	movl   $0xc010bb09,0xc(%esp)
c0107ccb:	c0 
c0107ccc:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107cd3:	c0 
c0107cd4:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0107cdb:	00 
c0107cdc:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107ce3:	e8 d8 8f ff ff       	call   c0100cc0 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107ce8:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107cef:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0107cf2:	89 d0                	mov    %edx,%eax
c0107cf4:	c1 e0 02             	shl    $0x2,%eax
c0107cf7:	01 d0                	add    %edx,%eax
c0107cf9:	01 c0                	add    %eax,%eax
c0107cfb:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107cfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d01:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107d04:	eb 70                	jmp    c0107d76 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107d06:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107d09:	89 d0                	mov    %edx,%eax
c0107d0b:	c1 e0 02             	shl    $0x2,%eax
c0107d0e:	01 d0                	add    %edx,%eax
c0107d10:	83 c0 02             	add    $0x2,%eax
c0107d13:	89 c1                	mov    %eax,%ecx
c0107d15:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107d18:	89 d0                	mov    %edx,%eax
c0107d1a:	c1 e0 02             	shl    $0x2,%eax
c0107d1d:	01 d0                	add    %edx,%eax
c0107d1f:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107d26:	00 
c0107d27:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107d2b:	89 04 24             	mov    %eax,(%esp)
c0107d2e:	e8 12 fc ff ff       	call   c0107945 <vma_create>
c0107d33:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107d36:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107d3a:	75 24                	jne    c0107d60 <check_vma_struct+0xb8>
c0107d3c:	c7 44 24 0c 14 bb 10 	movl   $0xc010bb14,0xc(%esp)
c0107d43:	c0 
c0107d44:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107d4b:	c0 
c0107d4c:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0107d53:	00 
c0107d54:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107d5b:	e8 60 8f ff ff       	call   c0100cc0 <__panic>
        insert_vma_struct(mm, vma);
c0107d60:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d63:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d67:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107d6a:	89 04 24             	mov    %eax,(%esp)
c0107d6d:	e8 63 fd ff ff       	call   c0107ad5 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c0107d72:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107d76:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107d7a:	7f 8a                	jg     c0107d06 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107d7c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d7f:	83 c0 01             	add    $0x1,%eax
c0107d82:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107d85:	eb 70                	jmp    c0107df7 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107d87:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107d8a:	89 d0                	mov    %edx,%eax
c0107d8c:	c1 e0 02             	shl    $0x2,%eax
c0107d8f:	01 d0                	add    %edx,%eax
c0107d91:	83 c0 02             	add    $0x2,%eax
c0107d94:	89 c1                	mov    %eax,%ecx
c0107d96:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107d99:	89 d0                	mov    %edx,%eax
c0107d9b:	c1 e0 02             	shl    $0x2,%eax
c0107d9e:	01 d0                	add    %edx,%eax
c0107da0:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107da7:	00 
c0107da8:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107dac:	89 04 24             	mov    %eax,(%esp)
c0107daf:	e8 91 fb ff ff       	call   c0107945 <vma_create>
c0107db4:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107db7:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107dbb:	75 24                	jne    c0107de1 <check_vma_struct+0x139>
c0107dbd:	c7 44 24 0c 14 bb 10 	movl   $0xc010bb14,0xc(%esp)
c0107dc4:	c0 
c0107dc5:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107dcc:	c0 
c0107dcd:	c7 44 24 04 bf 00 00 	movl   $0xbf,0x4(%esp)
c0107dd4:	00 
c0107dd5:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107ddc:	e8 df 8e ff ff       	call   c0100cc0 <__panic>
        insert_vma_struct(mm, vma);
c0107de1:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107de4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107de8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107deb:	89 04 24             	mov    %eax,(%esp)
c0107dee:	e8 e2 fc ff ff       	call   c0107ad5 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c0107df3:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107df7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107dfa:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107dfd:	7e 88                	jle    c0107d87 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107dff:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e02:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0107e05:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107e08:	8b 40 04             	mov    0x4(%eax),%eax
c0107e0b:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107e0e:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c0107e15:	e9 97 00 00 00       	jmp    c0107eb1 <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107e1a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107e1d:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0107e20:	75 24                	jne    c0107e46 <check_vma_struct+0x19e>
c0107e22:	c7 44 24 0c 20 bb 10 	movl   $0xc010bb20,0xc(%esp)
c0107e29:	c0 
c0107e2a:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107e31:	c0 
c0107e32:	c7 44 24 04 c6 00 00 	movl   $0xc6,0x4(%esp)
c0107e39:	00 
c0107e3a:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107e41:	e8 7a 8e ff ff       	call   c0100cc0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107e46:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107e49:	83 e8 10             	sub    $0x10,%eax
c0107e4c:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107e4f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107e52:	8b 48 04             	mov    0x4(%eax),%ecx
c0107e55:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e58:	89 d0                	mov    %edx,%eax
c0107e5a:	c1 e0 02             	shl    $0x2,%eax
c0107e5d:	01 d0                	add    %edx,%eax
c0107e5f:	39 c1                	cmp    %eax,%ecx
c0107e61:	75 17                	jne    c0107e7a <check_vma_struct+0x1d2>
c0107e63:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0107e66:	8b 48 08             	mov    0x8(%eax),%ecx
c0107e69:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107e6c:	89 d0                	mov    %edx,%eax
c0107e6e:	c1 e0 02             	shl    $0x2,%eax
c0107e71:	01 d0                	add    %edx,%eax
c0107e73:	83 c0 02             	add    $0x2,%eax
c0107e76:	39 c1                	cmp    %eax,%ecx
c0107e78:	74 24                	je     c0107e9e <check_vma_struct+0x1f6>
c0107e7a:	c7 44 24 0c 38 bb 10 	movl   $0xc010bb38,0xc(%esp)
c0107e81:	c0 
c0107e82:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107e89:	c0 
c0107e8a:	c7 44 24 04 c8 00 00 	movl   $0xc8,0x4(%esp)
c0107e91:	00 
c0107e92:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107e99:	e8 22 8e ff ff       	call   c0100cc0 <__panic>
c0107e9e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107ea1:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c0107ea4:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0107ea7:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c0107eaa:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c0107ead:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107eb1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107eb4:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107eb7:	0f 8e 5d ff ff ff    	jle    c0107e1a <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107ebd:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c0107ec4:	e9 cd 01 00 00       	jmp    c0108096 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107ec9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ecc:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ed0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ed3:	89 04 24             	mov    %eax,(%esp)
c0107ed6:	e8 a5 fa ff ff       	call   c0107980 <find_vma>
c0107edb:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107ede:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c0107ee2:	75 24                	jne    c0107f08 <check_vma_struct+0x260>
c0107ee4:	c7 44 24 0c 6d bb 10 	movl   $0xc010bb6d,0xc(%esp)
c0107eeb:	c0 
c0107eec:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107ef3:	c0 
c0107ef4:	c7 44 24 04 ce 00 00 	movl   $0xce,0x4(%esp)
c0107efb:	00 
c0107efc:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107f03:	e8 b8 8d ff ff       	call   c0100cc0 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107f08:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f0b:	83 c0 01             	add    $0x1,%eax
c0107f0e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f12:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f15:	89 04 24             	mov    %eax,(%esp)
c0107f18:	e8 63 fa ff ff       	call   c0107980 <find_vma>
c0107f1d:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c0107f20:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0107f24:	75 24                	jne    c0107f4a <check_vma_struct+0x2a2>
c0107f26:	c7 44 24 0c 7a bb 10 	movl   $0xc010bb7a,0xc(%esp)
c0107f2d:	c0 
c0107f2e:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107f35:	c0 
c0107f36:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0107f3d:	00 
c0107f3e:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107f45:	e8 76 8d ff ff       	call   c0100cc0 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107f4a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f4d:	83 c0 02             	add    $0x2,%eax
c0107f50:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f54:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f57:	89 04 24             	mov    %eax,(%esp)
c0107f5a:	e8 21 fa ff ff       	call   c0107980 <find_vma>
c0107f5f:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c0107f62:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0107f66:	74 24                	je     c0107f8c <check_vma_struct+0x2e4>
c0107f68:	c7 44 24 0c 87 bb 10 	movl   $0xc010bb87,0xc(%esp)
c0107f6f:	c0 
c0107f70:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107f77:	c0 
c0107f78:	c7 44 24 04 d2 00 00 	movl   $0xd2,0x4(%esp)
c0107f7f:	00 
c0107f80:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107f87:	e8 34 8d ff ff       	call   c0100cc0 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c0107f8c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107f8f:	83 c0 03             	add    $0x3,%eax
c0107f92:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f96:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107f99:	89 04 24             	mov    %eax,(%esp)
c0107f9c:	e8 df f9 ff ff       	call   c0107980 <find_vma>
c0107fa1:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c0107fa4:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c0107fa8:	74 24                	je     c0107fce <check_vma_struct+0x326>
c0107faa:	c7 44 24 0c 94 bb 10 	movl   $0xc010bb94,0xc(%esp)
c0107fb1:	c0 
c0107fb2:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107fb9:	c0 
c0107fba:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0107fc1:	00 
c0107fc2:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0107fc9:	e8 f2 8c ff ff       	call   c0100cc0 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107fce:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107fd1:	83 c0 04             	add    $0x4,%eax
c0107fd4:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107fd8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107fdb:	89 04 24             	mov    %eax,(%esp)
c0107fde:	e8 9d f9 ff ff       	call   c0107980 <find_vma>
c0107fe3:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107fe6:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107fea:	74 24                	je     c0108010 <check_vma_struct+0x368>
c0107fec:	c7 44 24 0c a1 bb 10 	movl   $0xc010bba1,0xc(%esp)
c0107ff3:	c0 
c0107ff4:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0107ffb:	c0 
c0107ffc:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0108003:	00 
c0108004:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c010800b:	e8 b0 8c ff ff       	call   c0100cc0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0108010:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108013:	8b 50 04             	mov    0x4(%eax),%edx
c0108016:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108019:	39 c2                	cmp    %eax,%edx
c010801b:	75 10                	jne    c010802d <check_vma_struct+0x385>
c010801d:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108020:	8b 50 08             	mov    0x8(%eax),%edx
c0108023:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108026:	83 c0 02             	add    $0x2,%eax
c0108029:	39 c2                	cmp    %eax,%edx
c010802b:	74 24                	je     c0108051 <check_vma_struct+0x3a9>
c010802d:	c7 44 24 0c b0 bb 10 	movl   $0xc010bbb0,0xc(%esp)
c0108034:	c0 
c0108035:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c010803c:	c0 
c010803d:	c7 44 24 04 d8 00 00 	movl   $0xd8,0x4(%esp)
c0108044:	00 
c0108045:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c010804c:	e8 6f 8c ff ff       	call   c0100cc0 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0108051:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108054:	8b 50 04             	mov    0x4(%eax),%edx
c0108057:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010805a:	39 c2                	cmp    %eax,%edx
c010805c:	75 10                	jne    c010806e <check_vma_struct+0x3c6>
c010805e:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108061:	8b 50 08             	mov    0x8(%eax),%edx
c0108064:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108067:	83 c0 02             	add    $0x2,%eax
c010806a:	39 c2                	cmp    %eax,%edx
c010806c:	74 24                	je     c0108092 <check_vma_struct+0x3ea>
c010806e:	c7 44 24 0c e0 bb 10 	movl   $0xc010bbe0,0xc(%esp)
c0108075:	c0 
c0108076:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c010807d:	c0 
c010807e:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0108085:	00 
c0108086:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c010808d:	e8 2e 8c ff ff       	call   c0100cc0 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0108092:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0108096:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108099:	89 d0                	mov    %edx,%eax
c010809b:	c1 e0 02             	shl    $0x2,%eax
c010809e:	01 d0                	add    %edx,%eax
c01080a0:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01080a3:	0f 8d 20 fe ff ff    	jge    c0107ec9 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c01080a9:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c01080b0:	eb 70                	jmp    c0108122 <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c01080b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080b9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01080bc:	89 04 24             	mov    %eax,(%esp)
c01080bf:	e8 bc f8 ff ff       	call   c0107980 <find_vma>
c01080c4:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c01080c7:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01080cb:	74 27                	je     c01080f4 <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c01080cd:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01080d0:	8b 50 08             	mov    0x8(%eax),%edx
c01080d3:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01080d6:	8b 40 04             	mov    0x4(%eax),%eax
c01080d9:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01080dd:	89 44 24 08          	mov    %eax,0x8(%esp)
c01080e1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01080e8:	c7 04 24 10 bc 10 c0 	movl   $0xc010bc10,(%esp)
c01080ef:	e8 6b 82 ff ff       	call   c010035f <cprintf>
        }
        assert(vma_below_5 == NULL);
c01080f4:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c01080f8:	74 24                	je     c010811e <check_vma_struct+0x476>
c01080fa:	c7 44 24 0c 35 bc 10 	movl   $0xc010bc35,0xc(%esp)
c0108101:	c0 
c0108102:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0108109:	c0 
c010810a:	c7 44 24 04 e1 00 00 	movl   $0xe1,0x4(%esp)
c0108111:	00 
c0108112:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0108119:	e8 a2 8b ff ff       	call   c0100cc0 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c010811e:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0108122:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108126:	79 8a                	jns    c01080b2 <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0108128:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010812b:	89 04 24             	mov    %eax,(%esp)
c010812e:	e8 d3 fa ff ff       	call   c0107c06 <mm_destroy>

    cprintf("check_vma_struct() succeeded!\n");
c0108133:	c7 04 24 4c bc 10 c0 	movl   $0xc010bc4c,(%esp)
c010813a:	e8 20 82 ff ff       	call   c010035f <cprintf>
}
c010813f:	c9                   	leave  
c0108140:	c3                   	ret    

c0108141 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0108141:	55                   	push   %ebp
c0108142:	89 e5                	mov    %esp,%ebp
c0108144:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0108147:	e8 1e ce ff ff       	call   c0104f6a <nr_free_pages>
c010814c:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c010814f:	e8 79 f7 ff ff       	call   c01078cd <mm_create>
c0108154:	a3 0c 8c 12 c0       	mov    %eax,0xc0128c0c
    assert(check_mm_struct != NULL);
c0108159:	a1 0c 8c 12 c0       	mov    0xc0128c0c,%eax
c010815e:	85 c0                	test   %eax,%eax
c0108160:	75 24                	jne    c0108186 <check_pgfault+0x45>
c0108162:	c7 44 24 0c 6b bc 10 	movl   $0xc010bc6b,0xc(%esp)
c0108169:	c0 
c010816a:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0108171:	c0 
c0108172:	c7 44 24 04 f1 00 00 	movl   $0xf1,0x4(%esp)
c0108179:	00 
c010817a:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0108181:	e8 3a 8b ff ff       	call   c0100cc0 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0108186:	a1 0c 8c 12 c0       	mov    0xc0128c0c,%eax
c010818b:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c010818e:	8b 15 44 6a 12 c0    	mov    0xc0126a44,%edx
c0108194:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108197:	89 50 0c             	mov    %edx,0xc(%eax)
c010819a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010819d:	8b 40 0c             	mov    0xc(%eax),%eax
c01081a0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c01081a3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01081a6:	8b 00                	mov    (%eax),%eax
c01081a8:	85 c0                	test   %eax,%eax
c01081aa:	74 24                	je     c01081d0 <check_pgfault+0x8f>
c01081ac:	c7 44 24 0c 83 bc 10 	movl   $0xc010bc83,0xc(%esp)
c01081b3:	c0 
c01081b4:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c01081bb:	c0 
c01081bc:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c01081c3:	00 
c01081c4:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c01081cb:	e8 f0 8a ff ff       	call   c0100cc0 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c01081d0:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c01081d7:	00 
c01081d8:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c01081df:	00 
c01081e0:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01081e7:	e8 59 f7 ff ff       	call   c0107945 <vma_create>
c01081ec:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c01081ef:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01081f3:	75 24                	jne    c0108219 <check_pgfault+0xd8>
c01081f5:	c7 44 24 0c 14 bb 10 	movl   $0xc010bb14,0xc(%esp)
c01081fc:	c0 
c01081fd:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0108204:	c0 
c0108205:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c010820c:	00 
c010820d:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0108214:	e8 a7 8a ff ff       	call   c0100cc0 <__panic>

    insert_vma_struct(mm, vma);
c0108219:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010821c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108220:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108223:	89 04 24             	mov    %eax,(%esp)
c0108226:	e8 aa f8 ff ff       	call   c0107ad5 <insert_vma_struct>

    uintptr_t addr = 0x100;
c010822b:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0108232:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108235:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108239:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010823c:	89 04 24             	mov    %eax,(%esp)
c010823f:	e8 3c f7 ff ff       	call   c0107980 <find_vma>
c0108244:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0108247:	74 24                	je     c010826d <check_pgfault+0x12c>
c0108249:	c7 44 24 0c 91 bc 10 	movl   $0xc010bc91,0xc(%esp)
c0108250:	c0 
c0108251:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c0108258:	c0 
c0108259:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c0108260:	00 
c0108261:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c0108268:	e8 53 8a ff ff       	call   c0100cc0 <__panic>

    int i, sum = 0;
c010826d:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0108274:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010827b:	eb 15                	jmp    c0108292 <check_pgfault+0x151>
        *(char *)(addr + i) = i;
c010827d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108280:	03 45 dc             	add    -0x24(%ebp),%eax
c0108283:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108286:	88 10                	mov    %dl,(%eax)
        sum += i;
c0108288:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010828b:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c010828e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0108292:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0108296:	7e e5                	jle    c010827d <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0108298:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010829f:	eb 13                	jmp    c01082b4 <check_pgfault+0x173>
        sum -= *(char *)(addr + i);
c01082a1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01082a4:	03 45 dc             	add    -0x24(%ebp),%eax
c01082a7:	0f b6 00             	movzbl (%eax),%eax
c01082aa:	0f be c0             	movsbl %al,%eax
c01082ad:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c01082b0:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01082b4:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c01082b8:	7e e7                	jle    c01082a1 <check_pgfault+0x160>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c01082ba:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01082be:	74 24                	je     c01082e4 <check_pgfault+0x1a3>
c01082c0:	c7 44 24 0c ab bc 10 	movl   $0xc010bcab,0xc(%esp)
c01082c7:	c0 
c01082c8:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c01082cf:	c0 
c01082d0:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c01082d7:	00 
c01082d8:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c01082df:	e8 dc 89 ff ff       	call   c0100cc0 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c01082e4:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01082e7:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01082ea:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01082ed:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01082f2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082f6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01082f9:	89 04 24             	mov    %eax,(%esp)
c01082fc:	e8 38 d5 ff ff       	call   c0105839 <page_remove>
    free_page(pde2page(pgdir[0]));
c0108301:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108304:	8b 00                	mov    (%eax),%eax
c0108306:	89 04 24             	mov    %eax,(%esp)
c0108309:	e8 a7 f5 ff ff       	call   c01078b5 <pde2page>
c010830e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0108315:	00 
c0108316:	89 04 24             	mov    %eax,(%esp)
c0108319:	e8 1a cc ff ff       	call   c0104f38 <free_pages>
    pgdir[0] = 0;
c010831e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108321:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0108327:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010832a:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0108331:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108334:	89 04 24             	mov    %eax,(%esp)
c0108337:	e8 ca f8 ff ff       	call   c0107c06 <mm_destroy>
    check_mm_struct = NULL;
c010833c:	c7 05 0c 8c 12 c0 00 	movl   $0x0,0xc0128c0c
c0108343:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0108346:	e8 1f cc ff ff       	call   c0104f6a <nr_free_pages>
c010834b:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010834e:	74 24                	je     c0108374 <check_pgfault+0x233>
c0108350:	c7 44 24 0c b4 bc 10 	movl   $0xc010bcb4,0xc(%esp)
c0108357:	c0 
c0108358:	c7 44 24 08 73 ba 10 	movl   $0xc010ba73,0x8(%esp)
c010835f:	c0 
c0108360:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0108367:	00 
c0108368:	c7 04 24 88 ba 10 c0 	movl   $0xc010ba88,(%esp)
c010836f:	e8 4c 89 ff ff       	call   c0100cc0 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0108374:	c7 04 24 db bc 10 c0 	movl   $0xc010bcdb,(%esp)
c010837b:	e8 df 7f ff ff       	call   c010035f <cprintf>
}
c0108380:	c9                   	leave  
c0108381:	c3                   	ret    

c0108382 <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0108382:	55                   	push   %ebp
c0108383:	89 e5                	mov    %esp,%ebp
c0108385:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0108388:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c010838f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108392:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108396:	8b 45 08             	mov    0x8(%ebp),%eax
c0108399:	89 04 24             	mov    %eax,(%esp)
c010839c:	e8 df f5 ff ff       	call   c0107980 <find_vma>
c01083a1:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c01083a4:	a1 d8 6a 12 c0       	mov    0xc0126ad8,%eax
c01083a9:	83 c0 01             	add    $0x1,%eax
c01083ac:	a3 d8 6a 12 c0       	mov    %eax,0xc0126ad8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c01083b1:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01083b5:	74 0b                	je     c01083c2 <do_pgfault+0x40>
c01083b7:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01083ba:	8b 40 04             	mov    0x4(%eax),%eax
c01083bd:	3b 45 10             	cmp    0x10(%ebp),%eax
c01083c0:	76 18                	jbe    c01083da <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c01083c2:	8b 45 10             	mov    0x10(%ebp),%eax
c01083c5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083c9:	c7 04 24 f8 bc 10 c0 	movl   $0xc010bcf8,(%esp)
c01083d0:	e8 8a 7f ff ff       	call   c010035f <cprintf>
        goto failed;
c01083d5:	e9 d9 01 00 00       	jmp    c01085b3 <do_pgfault+0x231>
    }
    //check the error_code
    switch (error_code & 3) {
c01083da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083dd:	83 e0 03             	and    $0x3,%eax
c01083e0:	85 c0                	test   %eax,%eax
c01083e2:	74 34                	je     c0108418 <do_pgfault+0x96>
c01083e4:	83 f8 01             	cmp    $0x1,%eax
c01083e7:	74 1e                	je     c0108407 <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c01083e9:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01083ec:	8b 40 0c             	mov    0xc(%eax),%eax
c01083ef:	83 e0 02             	and    $0x2,%eax
c01083f2:	85 c0                	test   %eax,%eax
c01083f4:	75 40                	jne    c0108436 <do_pgfault+0xb4>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c01083f6:	c7 04 24 28 bd 10 c0 	movl   $0xc010bd28,(%esp)
c01083fd:	e8 5d 7f ff ff       	call   c010035f <cprintf>
            goto failed;
c0108402:	e9 ac 01 00 00       	jmp    c01085b3 <do_pgfault+0x231>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0108407:	c7 04 24 88 bd 10 c0 	movl   $0xc010bd88,(%esp)
c010840e:	e8 4c 7f ff ff       	call   c010035f <cprintf>
        goto failed;
c0108413:	e9 9b 01 00 00       	jmp    c01085b3 <do_pgfault+0x231>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0108418:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010841b:	8b 40 0c             	mov    0xc(%eax),%eax
c010841e:	83 e0 05             	and    $0x5,%eax
c0108421:	85 c0                	test   %eax,%eax
c0108423:	75 12                	jne    c0108437 <do_pgfault+0xb5>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0108425:	c7 04 24 c0 bd 10 c0 	movl   $0xc010bdc0,(%esp)
c010842c:	e8 2e 7f ff ff       	call   c010035f <cprintf>
            goto failed;
c0108431:	e9 7d 01 00 00       	jmp    c01085b3 <do_pgfault+0x231>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c0108436:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0108437:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c010843e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108441:	8b 40 0c             	mov    0xc(%eax),%eax
c0108444:	83 e0 02             	and    $0x2,%eax
c0108447:	85 c0                	test   %eax,%eax
c0108449:	74 04                	je     c010844f <do_pgfault+0xcd>
        perm |= PTE_W;
c010844b:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c010844f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108452:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108455:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108458:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010845d:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0108460:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0108467:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
 ptep = get_pte(mm->pgdir, addr, 1);
c010846e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108471:	8b 40 0c             	mov    0xc(%eax),%eax
c0108474:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010847b:	00 
c010847c:	8b 55 10             	mov    0x10(%ebp),%edx
c010847f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108483:	89 04 24             	mov    %eax,(%esp)
c0108486:	e8 a8 d1 ff ff       	call   c0105633 <get_pte>
c010848b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (!ptep) {
c010848e:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108492:	75 11                	jne    c01084a5 <do_pgfault+0x123>
        cprintf("failed in get_pte in do_pgfault\n");
c0108494:	c7 04 24 24 be 10 c0 	movl   $0xc010be24,(%esp)
c010849b:	e8 bf 7e ff ff       	call   c010035f <cprintf>
        goto failed;
c01084a0:	e9 0e 01 00 00       	jmp    c01085b3 <do_pgfault+0x231>
    }
    
    if (*ptep == 0) {
c01084a5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01084a8:	8b 00                	mov    (%eax),%eax
c01084aa:	85 c0                	test   %eax,%eax
c01084ac:	75 3a                	jne    c01084e8 <do_pgfault+0x166>
        struct Page* page = pgdir_alloc_page(mm->pgdir, addr, perm);
c01084ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01084b1:	8b 40 0c             	mov    0xc(%eax),%eax
c01084b4:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01084b7:	89 54 24 08          	mov    %edx,0x8(%esp)
c01084bb:	8b 55 10             	mov    0x10(%ebp),%edx
c01084be:	89 54 24 04          	mov    %edx,0x4(%esp)
c01084c2:	89 04 24             	mov    %eax,(%esp)
c01084c5:	e8 ce d4 ff ff       	call   c0105998 <pgdir_alloc_page>
c01084ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if (!page) {
c01084cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01084d1:	0f 85 d5 00 00 00    	jne    c01085ac <do_pgfault+0x22a>
            cprintf("failed in pgdir_alloc_page in do_pgfault\n");
c01084d7:	c7 04 24 48 be 10 c0 	movl   $0xc010be48,(%esp)
c01084de:	e8 7c 7e ff ff       	call   c010035f <cprintf>
            goto failed;
c01084e3:	e9 cb 00 00 00       	jmp    c01085b3 <do_pgfault+0x231>
        }
    }

    else {
        if(swap_init_ok) {
c01084e8:	a1 cc 6a 12 c0       	mov    0xc0126acc,%eax
c01084ed:	85 c0                	test   %eax,%eax
c01084ef:	0f 84 a0 00 00 00    	je     c0108595 <do_pgfault+0x213>
            struct Page *page = NULL;
c01084f5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
            ret = swap_in(mm, addr, &page);
c01084fc:	8d 45 dc             	lea    -0x24(%ebp),%eax
c01084ff:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108503:	8b 45 10             	mov    0x10(%ebp),%eax
c0108506:	89 44 24 04          	mov    %eax,0x4(%esp)
c010850a:	8b 45 08             	mov    0x8(%ebp),%eax
c010850d:	89 04 24             	mov    %eax,(%esp)
c0108510:	e8 0f e5 ff ff       	call   c0106a24 <swap_in>
c0108515:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0108518:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010851c:	74 11                	je     c010852f <do_pgfault+0x1ad>
                cprintf("failed in swap_in in do_pgfault\n");
c010851e:	c7 04 24 74 be 10 c0 	movl   $0xc010be74,(%esp)
c0108525:	e8 35 7e ff ff       	call   c010035f <cprintf>
                goto failed;
c010852a:	e9 84 00 00 00       	jmp    c01085b3 <do_pgfault+0x231>
            }
            ret = page_insert(mm->pgdir, page, addr, perm);
c010852f:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108532:	8b 45 08             	mov    0x8(%ebp),%eax
c0108535:	8b 40 0c             	mov    0xc(%eax),%eax
c0108538:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c010853b:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c010853f:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0108542:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0108546:	89 54 24 04          	mov    %edx,0x4(%esp)
c010854a:	89 04 24             	mov    %eax,(%esp)
c010854d:	e8 2b d3 ff ff       	call   c010587d <page_insert>
c0108552:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0108555:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108559:	74 0e                	je     c0108569 <do_pgfault+0x1e7>
                cprintf("failed in page_insert in do_pgfault\n");
c010855b:	c7 04 24 98 be 10 c0 	movl   $0xc010be98,(%esp)
c0108562:	e8 f8 7d ff ff       	call   c010035f <cprintf>
                goto failed;
c0108567:	eb 4a                	jmp    c01085b3 <do_pgfault+0x231>
            }
            swap_map_swappable(mm, addr, page, 1);
c0108569:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010856c:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0108573:	00 
c0108574:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108578:	8b 45 10             	mov    0x10(%ebp),%eax
c010857b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010857f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108582:	89 04 24             	mov    %eax,(%esp)
c0108585:	e8 d1 e2 ff ff       	call   c010685b <swap_map_swappable>
            page->pra_vaddr = addr;
c010858a:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010858d:	8b 55 10             	mov    0x10(%ebp),%edx
c0108590:	89 50 1c             	mov    %edx,0x1c(%eax)
c0108593:	eb 17                	jmp    c01085ac <do_pgfault+0x22a>
        }
        else {
            cprintf("there is no swap_init_ok, ptep is %x, failed\n",*ptep);
c0108595:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108598:	8b 00                	mov    (%eax),%eax
c010859a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010859e:	c7 04 24 c0 be 10 c0 	movl   $0xc010bec0,(%esp)
c01085a5:	e8 b5 7d ff ff       	call   c010035f <cprintf>
            goto failed;
c01085aa:	eb 07                	jmp    c01085b3 <do_pgfault+0x231>
        }
   }
   ret = 0;
c01085ac:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c01085b3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01085b6:	c9                   	leave  
c01085b7:	c3                   	ret    

c01085b8 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01085b8:	55                   	push   %ebp
c01085b9:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01085bb:	8b 55 08             	mov    0x8(%ebp),%edx
c01085be:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c01085c3:	89 d1                	mov    %edx,%ecx
c01085c5:	29 c1                	sub    %eax,%ecx
c01085c7:	89 c8                	mov    %ecx,%eax
c01085c9:	c1 f8 05             	sar    $0x5,%eax
}
c01085cc:	5d                   	pop    %ebp
c01085cd:	c3                   	ret    

c01085ce <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01085ce:	55                   	push   %ebp
c01085cf:	89 e5                	mov    %esp,%ebp
c01085d1:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01085d4:	8b 45 08             	mov    0x8(%ebp),%eax
c01085d7:	89 04 24             	mov    %eax,(%esp)
c01085da:	e8 d9 ff ff ff       	call   c01085b8 <page2ppn>
c01085df:	c1 e0 0c             	shl    $0xc,%eax
}
c01085e2:	c9                   	leave  
c01085e3:	c3                   	ret    

c01085e4 <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c01085e4:	55                   	push   %ebp
c01085e5:	89 e5                	mov    %esp,%ebp
c01085e7:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01085ea:	8b 45 08             	mov    0x8(%ebp),%eax
c01085ed:	89 04 24             	mov    %eax,(%esp)
c01085f0:	e8 d9 ff ff ff       	call   c01085ce <page2pa>
c01085f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01085f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01085fb:	c1 e8 0c             	shr    $0xc,%eax
c01085fe:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108601:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0108606:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108609:	72 23                	jb     c010862e <page2kva+0x4a>
c010860b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010860e:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108612:	c7 44 24 08 f0 be 10 	movl   $0xc010bef0,0x8(%esp)
c0108619:	c0 
c010861a:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0108621:	00 
c0108622:	c7 04 24 13 bf 10 c0 	movl   $0xc010bf13,(%esp)
c0108629:	e8 92 86 ff ff       	call   c0100cc0 <__panic>
c010862e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108631:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108636:	c9                   	leave  
c0108637:	c3                   	ret    

c0108638 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c0108638:	55                   	push   %ebp
c0108639:	89 e5                	mov    %esp,%ebp
c010863b:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c010863e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108645:	e8 91 94 ff ff       	call   c0101adb <ide_device_valid>
c010864a:	85 c0                	test   %eax,%eax
c010864c:	75 1c                	jne    c010866a <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c010864e:	c7 44 24 08 21 bf 10 	movl   $0xc010bf21,0x8(%esp)
c0108655:	c0 
c0108656:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c010865d:	00 
c010865e:	c7 04 24 3b bf 10 c0 	movl   $0xc010bf3b,(%esp)
c0108665:	e8 56 86 ff ff       	call   c0100cc0 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c010866a:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108671:	e8 a4 94 ff ff       	call   c0101b1a <ide_device_size>
c0108676:	c1 e8 03             	shr    $0x3,%eax
c0108679:	a3 dc 8b 12 c0       	mov    %eax,0xc0128bdc
}
c010867e:	c9                   	leave  
c010867f:	c3                   	ret    

c0108680 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c0108680:	55                   	push   %ebp
c0108681:	89 e5                	mov    %esp,%ebp
c0108683:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108686:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108689:	89 04 24             	mov    %eax,(%esp)
c010868c:	e8 53 ff ff ff       	call   c01085e4 <page2kva>
c0108691:	8b 55 08             	mov    0x8(%ebp),%edx
c0108694:	c1 ea 08             	shr    $0x8,%edx
c0108697:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010869a:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010869e:	74 0b                	je     c01086ab <swapfs_read+0x2b>
c01086a0:	8b 15 dc 8b 12 c0    	mov    0xc0128bdc,%edx
c01086a6:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c01086a9:	72 23                	jb     c01086ce <swapfs_read+0x4e>
c01086ab:	8b 45 08             	mov    0x8(%ebp),%eax
c01086ae:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01086b2:	c7 44 24 08 4c bf 10 	movl   $0xc010bf4c,0x8(%esp)
c01086b9:	c0 
c01086ba:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01086c1:	00 
c01086c2:	c7 04 24 3b bf 10 c0 	movl   $0xc010bf3b,(%esp)
c01086c9:	e8 f2 85 ff ff       	call   c0100cc0 <__panic>
c01086ce:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01086d1:	c1 e2 03             	shl    $0x3,%edx
c01086d4:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01086db:	00 
c01086dc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01086e0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01086e4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01086eb:	e8 69 94 ff ff       	call   c0101b59 <ide_read_secs>
}
c01086f0:	c9                   	leave  
c01086f1:	c3                   	ret    

c01086f2 <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c01086f2:	55                   	push   %ebp
c01086f3:	89 e5                	mov    %esp,%ebp
c01086f5:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01086f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086fb:	89 04 24             	mov    %eax,(%esp)
c01086fe:	e8 e1 fe ff ff       	call   c01085e4 <page2kva>
c0108703:	8b 55 08             	mov    0x8(%ebp),%edx
c0108706:	c1 ea 08             	shr    $0x8,%edx
c0108709:	89 55 f4             	mov    %edx,-0xc(%ebp)
c010870c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108710:	74 0b                	je     c010871d <swapfs_write+0x2b>
c0108712:	8b 15 dc 8b 12 c0    	mov    0xc0128bdc,%edx
c0108718:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c010871b:	72 23                	jb     c0108740 <swapfs_write+0x4e>
c010871d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108720:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108724:	c7 44 24 08 4c bf 10 	movl   $0xc010bf4c,0x8(%esp)
c010872b:	c0 
c010872c:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c0108733:	00 
c0108734:	c7 04 24 3b bf 10 c0 	movl   $0xc010bf3b,(%esp)
c010873b:	e8 80 85 ff ff       	call   c0100cc0 <__panic>
c0108740:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108743:	c1 e2 03             	shl    $0x3,%edx
c0108746:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c010874d:	00 
c010874e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108752:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108756:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010875d:	e8 40 96 ff ff       	call   c0101da2 <ide_write_secs>
}
c0108762:	c9                   	leave  
c0108763:	c3                   	ret    

c0108764 <kernel_thread_entry>:
.text
.globl kernel_thread_entry
kernel_thread_entry:        # void kernel_thread(void)

    pushl %edx              # push arg
c0108764:	52                   	push   %edx
    call *%ebx              # call fn
c0108765:	ff d3                	call   *%ebx

    pushl %eax              # save the return value of fn(arg)
c0108767:	50                   	push   %eax
    call do_exit            # call do_exit to terminate current thread
c0108768:	e8 52 08 00 00       	call   c0108fbf <do_exit>
c010876d:	00 00                	add    %al,(%eax)
	...

c0108770 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0108770:	55                   	push   %ebp
c0108771:	89 e5                	mov    %esp,%ebp
c0108773:	53                   	push   %ebx
c0108774:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0108777:	9c                   	pushf  
c0108778:	5b                   	pop    %ebx
c0108779:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c010877c:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010877f:	25 00 02 00 00       	and    $0x200,%eax
c0108784:	85 c0                	test   %eax,%eax
c0108786:	74 0c                	je     c0108794 <__intr_save+0x24>
        intr_disable();
c0108788:	e8 61 98 ff ff       	call   c0101fee <intr_disable>
        return 1;
c010878d:	b8 01 00 00 00       	mov    $0x1,%eax
c0108792:	eb 05                	jmp    c0108799 <__intr_save+0x29>
    }
    return 0;
c0108794:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108799:	83 c4 14             	add    $0x14,%esp
c010879c:	5b                   	pop    %ebx
c010879d:	5d                   	pop    %ebp
c010879e:	c3                   	ret    

c010879f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010879f:	55                   	push   %ebp
c01087a0:	89 e5                	mov    %esp,%ebp
c01087a2:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c01087a5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01087a9:	74 05                	je     c01087b0 <__intr_restore+0x11>
        intr_enable();
c01087ab:	e8 38 98 ff ff       	call   c0101fe8 <intr_enable>
    }
}
c01087b0:	c9                   	leave  
c01087b1:	c3                   	ret    

c01087b2 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c01087b2:	55                   	push   %ebp
c01087b3:	89 e5                	mov    %esp,%ebp
    return page - pages;
c01087b5:	8b 55 08             	mov    0x8(%ebp),%edx
c01087b8:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c01087bd:	89 d1                	mov    %edx,%ecx
c01087bf:	29 c1                	sub    %eax,%ecx
c01087c1:	89 c8                	mov    %ecx,%eax
c01087c3:	c1 f8 05             	sar    $0x5,%eax
}
c01087c6:	5d                   	pop    %ebp
c01087c7:	c3                   	ret    

c01087c8 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c01087c8:	55                   	push   %ebp
c01087c9:	89 e5                	mov    %esp,%ebp
c01087cb:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c01087ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01087d1:	89 04 24             	mov    %eax,(%esp)
c01087d4:	e8 d9 ff ff ff       	call   c01087b2 <page2ppn>
c01087d9:	c1 e0 0c             	shl    $0xc,%eax
}
c01087dc:	c9                   	leave  
c01087dd:	c3                   	ret    

c01087de <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c01087de:	55                   	push   %ebp
c01087df:	89 e5                	mov    %esp,%ebp
c01087e1:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c01087e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01087e7:	89 c2                	mov    %eax,%edx
c01087e9:	c1 ea 0c             	shr    $0xc,%edx
c01087ec:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c01087f1:	39 c2                	cmp    %eax,%edx
c01087f3:	72 1c                	jb     c0108811 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c01087f5:	c7 44 24 08 6c bf 10 	movl   $0xc010bf6c,0x8(%esp)
c01087fc:	c0 
c01087fd:	c7 44 24 04 5f 00 00 	movl   $0x5f,0x4(%esp)
c0108804:	00 
c0108805:	c7 04 24 8b bf 10 c0 	movl   $0xc010bf8b,(%esp)
c010880c:	e8 af 84 ff ff       	call   c0100cc0 <__panic>
    }
    return &pages[PPN(pa)];
c0108811:	a1 2c 8b 12 c0       	mov    0xc0128b2c,%eax
c0108816:	8b 55 08             	mov    0x8(%ebp),%edx
c0108819:	c1 ea 0c             	shr    $0xc,%edx
c010881c:	c1 e2 05             	shl    $0x5,%edx
c010881f:	01 d0                	add    %edx,%eax
}
c0108821:	c9                   	leave  
c0108822:	c3                   	ret    

c0108823 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c0108823:	55                   	push   %ebp
c0108824:	89 e5                	mov    %esp,%ebp
c0108826:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108829:	8b 45 08             	mov    0x8(%ebp),%eax
c010882c:	89 04 24             	mov    %eax,(%esp)
c010882f:	e8 94 ff ff ff       	call   c01087c8 <page2pa>
c0108834:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108837:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010883a:	c1 e8 0c             	shr    $0xc,%eax
c010883d:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108840:	a1 40 6a 12 c0       	mov    0xc0126a40,%eax
c0108845:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108848:	72 23                	jb     c010886d <page2kva+0x4a>
c010884a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010884d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108851:	c7 44 24 08 9c bf 10 	movl   $0xc010bf9c,0x8(%esp)
c0108858:	c0 
c0108859:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c0108860:	00 
c0108861:	c7 04 24 8b bf 10 c0 	movl   $0xc010bf8b,(%esp)
c0108868:	e8 53 84 ff ff       	call   c0100cc0 <__panic>
c010886d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108870:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c0108875:	c9                   	leave  
c0108876:	c3                   	ret    

c0108877 <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c0108877:	55                   	push   %ebp
c0108878:	89 e5                	mov    %esp,%ebp
c010887a:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c010887d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108880:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108883:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010888a:	77 23                	ja     c01088af <kva2page+0x38>
c010888c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010888f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108893:	c7 44 24 08 c0 bf 10 	movl   $0xc010bfc0,0x8(%esp)
c010889a:	c0 
c010889b:	c7 44 24 04 6b 00 00 	movl   $0x6b,0x4(%esp)
c01088a2:	00 
c01088a3:	c7 04 24 8b bf 10 c0 	movl   $0xc010bf8b,(%esp)
c01088aa:	e8 11 84 ff ff       	call   c0100cc0 <__panic>
c01088af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088b2:	05 00 00 00 40       	add    $0x40000000,%eax
c01088b7:	89 04 24             	mov    %eax,(%esp)
c01088ba:	e8 1f ff ff ff       	call   c01087de <pa2page>
}
c01088bf:	c9                   	leave  
c01088c0:	c3                   	ret    

c01088c1 <alloc_proc>:
void forkrets(struct trapframe *tf);
void switch_to(struct context *from, struct context *to);

// alloc_proc - alloc a proc_struct and init all fields of proc_struct
static struct proc_struct *
alloc_proc(void) {
c01088c1:	55                   	push   %ebp
c01088c2:	89 e5                	mov    %esp,%ebp
c01088c4:	83 ec 28             	sub    $0x28,%esp
    struct proc_struct *proc = kmalloc(sizeof(struct proc_struct));
c01088c7:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
c01088ce:	e8 73 c1 ff ff       	call   c0104a46 <kmalloc>
c01088d3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (proc != NULL) {
c01088d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01088da:	0f 84 a1 00 00 00    	je     c0108981 <alloc_proc+0xc0>
     *       struct trapframe *tf;                       // Trap frame for current interrupt
     *       uintptr_t cr3;                              // CR3 register: the base addr of Page Directroy Table(PDT)
     *       uint32_t flags;                             // Process flag
     *       char name[PROC_NAME_LEN + 1];               // Process name
     */
        proc->state = PROC_UNINIT;
c01088e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088e3:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        proc->pid = -1;
c01088e9:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088ec:	c7 40 04 ff ff ff ff 	movl   $0xffffffff,0x4(%eax)
        proc->runs = 0;
c01088f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01088f6:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        proc->kstack = 0;
c01088fd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108900:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        proc->need_resched = 0;
c0108907:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010890a:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        proc->parent = NULL;
c0108911:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108914:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
        proc->mm = NULL;
c010891b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010891e:	c7 40 18 00 00 00 00 	movl   $0x0,0x18(%eax)
        memset(&(proc->context), 0, sizeof(struct context));
c0108925:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108928:	83 c0 1c             	add    $0x1c,%eax
c010892b:	c7 44 24 08 20 00 00 	movl   $0x20,0x8(%esp)
c0108932:	00 
c0108933:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010893a:	00 
c010893b:	89 04 24             	mov    %eax,(%esp)
c010893e:	e8 90 15 00 00       	call   c0109ed3 <memset>
        proc->tf = NULL;
c0108943:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108946:	c7 40 3c 00 00 00 00 	movl   $0x0,0x3c(%eax)
        proc->cr3 = boot_cr3;
c010894d:	8b 15 28 8b 12 c0    	mov    0xc0128b28,%edx
c0108953:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108956:	89 50 40             	mov    %edx,0x40(%eax)
        proc->flags = 0;
c0108959:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010895c:	c7 40 44 00 00 00 00 	movl   $0x0,0x44(%eax)
        memset(proc->name, 0, PROC_NAME_LEN);
c0108963:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108966:	83 c0 48             	add    $0x48,%eax
c0108969:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c0108970:	00 
c0108971:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108978:	00 
c0108979:	89 04 24             	mov    %eax,(%esp)
c010897c:	e8 52 15 00 00       	call   c0109ed3 <memset>
    }
    return proc;
c0108981:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108984:	c9                   	leave  
c0108985:	c3                   	ret    

c0108986 <set_proc_name>:

// set_proc_name - set the name of proc
char *
set_proc_name(struct proc_struct *proc, const char *name) {
c0108986:	55                   	push   %ebp
c0108987:	89 e5                	mov    %esp,%ebp
c0108989:	83 ec 18             	sub    $0x18,%esp
    memset(proc->name, 0, sizeof(proc->name));
c010898c:	8b 45 08             	mov    0x8(%ebp),%eax
c010898f:	83 c0 48             	add    $0x48,%eax
c0108992:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c0108999:	00 
c010899a:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01089a1:	00 
c01089a2:	89 04 24             	mov    %eax,(%esp)
c01089a5:	e8 29 15 00 00       	call   c0109ed3 <memset>
    return memcpy(proc->name, name, PROC_NAME_LEN);
c01089aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ad:	8d 50 48             	lea    0x48(%eax),%edx
c01089b0:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01089b7:	00 
c01089b8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01089bb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089bf:	89 14 24             	mov    %edx,(%esp)
c01089c2:	e8 0b 16 00 00       	call   c0109fd2 <memcpy>
}
c01089c7:	c9                   	leave  
c01089c8:	c3                   	ret    

c01089c9 <get_proc_name>:

// get_proc_name - get the name of proc
char *
get_proc_name(struct proc_struct *proc) {
c01089c9:	55                   	push   %ebp
c01089ca:	89 e5                	mov    %esp,%ebp
c01089cc:	83 ec 18             	sub    $0x18,%esp
    static char name[PROC_NAME_LEN + 1];
    memset(name, 0, sizeof(name));
c01089cf:	c7 44 24 08 10 00 00 	movl   $0x10,0x8(%esp)
c01089d6:	00 
c01089d7:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01089de:	00 
c01089df:	c7 04 24 04 8b 12 c0 	movl   $0xc0128b04,(%esp)
c01089e6:	e8 e8 14 00 00       	call   c0109ed3 <memset>
    return memcpy(name, proc->name, PROC_NAME_LEN);
c01089eb:	8b 45 08             	mov    0x8(%ebp),%eax
c01089ee:	83 c0 48             	add    $0x48,%eax
c01089f1:	c7 44 24 08 0f 00 00 	movl   $0xf,0x8(%esp)
c01089f8:	00 
c01089f9:	89 44 24 04          	mov    %eax,0x4(%esp)
c01089fd:	c7 04 24 04 8b 12 c0 	movl   $0xc0128b04,(%esp)
c0108a04:	e8 c9 15 00 00       	call   c0109fd2 <memcpy>
}
c0108a09:	c9                   	leave  
c0108a0a:	c3                   	ret    

c0108a0b <get_pid>:

// get_pid - alloc a unique pid for process
static int
get_pid(void) {
c0108a0b:	55                   	push   %ebp
c0108a0c:	89 e5                	mov    %esp,%ebp
c0108a0e:	83 ec 10             	sub    $0x10,%esp
    static_assert(MAX_PID > MAX_PROCESS);
    struct proc_struct *proc;
    list_entry_t *list = &proc_list, *le;
c0108a11:	c7 45 f8 10 8c 12 c0 	movl   $0xc0128c10,-0x8(%ebp)
    static int next_safe = MAX_PID, last_pid = MAX_PID;
    if (++ last_pid >= MAX_PID) {
c0108a18:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
c0108a1d:	83 c0 01             	add    $0x1,%eax
c0108a20:	a3 80 5a 12 c0       	mov    %eax,0xc0125a80
c0108a25:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
c0108a2a:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108a2f:	7e 0c                	jle    c0108a3d <get_pid+0x32>
        last_pid = 1;
c0108a31:	c7 05 80 5a 12 c0 01 	movl   $0x1,0xc0125a80
c0108a38:	00 00 00 
        goto inside;
c0108a3b:	eb 13                	jmp    c0108a50 <get_pid+0x45>
    }
    if (last_pid >= next_safe) {
c0108a3d:	8b 15 80 5a 12 c0    	mov    0xc0125a80,%edx
c0108a43:	a1 84 5a 12 c0       	mov    0xc0125a84,%eax
c0108a48:	39 c2                	cmp    %eax,%edx
c0108a4a:	0f 8c ac 00 00 00    	jl     c0108afc <get_pid+0xf1>
    inside:
        next_safe = MAX_PID;
c0108a50:	c7 05 84 5a 12 c0 00 	movl   $0x2000,0xc0125a84
c0108a57:	20 00 00 
    repeat:
        le = list;
c0108a5a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108a5d:	89 45 fc             	mov    %eax,-0x4(%ebp)
        while ((le = list_next(le)) != list) {
c0108a60:	eb 7f                	jmp    c0108ae1 <get_pid+0xd6>
            proc = le2proc(le, list_link);
c0108a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a65:	83 e8 58             	sub    $0x58,%eax
c0108a68:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (proc->pid == last_pid) {
c0108a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108a6e:	8b 50 04             	mov    0x4(%eax),%edx
c0108a71:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
c0108a76:	39 c2                	cmp    %eax,%edx
c0108a78:	75 3e                	jne    c0108ab8 <get_pid+0xad>
                if (++ last_pid >= next_safe) {
c0108a7a:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
c0108a7f:	83 c0 01             	add    $0x1,%eax
c0108a82:	a3 80 5a 12 c0       	mov    %eax,0xc0125a80
c0108a87:	8b 15 80 5a 12 c0    	mov    0xc0125a80,%edx
c0108a8d:	a1 84 5a 12 c0       	mov    0xc0125a84,%eax
c0108a92:	39 c2                	cmp    %eax,%edx
c0108a94:	7c 4b                	jl     c0108ae1 <get_pid+0xd6>
                    if (last_pid >= MAX_PID) {
c0108a96:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
c0108a9b:	3d ff 1f 00 00       	cmp    $0x1fff,%eax
c0108aa0:	7e 0a                	jle    c0108aac <get_pid+0xa1>
                        last_pid = 1;
c0108aa2:	c7 05 80 5a 12 c0 01 	movl   $0x1,0xc0125a80
c0108aa9:	00 00 00 
                    }
                    next_safe = MAX_PID;
c0108aac:	c7 05 84 5a 12 c0 00 	movl   $0x2000,0xc0125a84
c0108ab3:	20 00 00 
                    goto repeat;
c0108ab6:	eb a2                	jmp    c0108a5a <get_pid+0x4f>
                }
            }
            else if (proc->pid > last_pid && next_safe > proc->pid) {
c0108ab8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108abb:	8b 50 04             	mov    0x4(%eax),%edx
c0108abe:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
c0108ac3:	39 c2                	cmp    %eax,%edx
c0108ac5:	7e 1a                	jle    c0108ae1 <get_pid+0xd6>
c0108ac7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108aca:	8b 50 04             	mov    0x4(%eax),%edx
c0108acd:	a1 84 5a 12 c0       	mov    0xc0125a84,%eax
c0108ad2:	39 c2                	cmp    %eax,%edx
c0108ad4:	7d 0b                	jge    c0108ae1 <get_pid+0xd6>
                next_safe = proc->pid;
c0108ad6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ad9:	8b 40 04             	mov    0x4(%eax),%eax
c0108adc:	a3 84 5a 12 c0       	mov    %eax,0xc0125a84
c0108ae1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108ae4:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108ae7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108aea:	8b 40 04             	mov    0x4(%eax),%eax
    if (last_pid >= next_safe) {
    inside:
        next_safe = MAX_PID;
    repeat:
        le = list;
        while ((le = list_next(le)) != list) {
c0108aed:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0108af0:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108af3:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c0108af6:	0f 85 66 ff ff ff    	jne    c0108a62 <get_pid+0x57>
            else if (proc->pid > last_pid && next_safe > proc->pid) {
                next_safe = proc->pid;
            }
        }
    }
    return last_pid;
c0108afc:	a1 80 5a 12 c0       	mov    0xc0125a80,%eax
}
c0108b01:	c9                   	leave  
c0108b02:	c3                   	ret    

c0108b03 <proc_run>:

// proc_run - make process "proc" running on cpu
// NOTE: before call switch_to, should load  base addr of "proc"'s new PDT
void
proc_run(struct proc_struct *proc) {
c0108b03:	55                   	push   %ebp
c0108b04:	89 e5                	mov    %esp,%ebp
c0108b06:	83 ec 28             	sub    $0x28,%esp
    if (proc != current) {
c0108b09:	a1 e8 6a 12 c0       	mov    0xc0126ae8,%eax
c0108b0e:	39 45 08             	cmp    %eax,0x8(%ebp)
c0108b11:	74 63                	je     c0108b76 <proc_run+0x73>
        bool intr_flag;
        struct proc_struct *prev = current, *next = proc;
c0108b13:	a1 e8 6a 12 c0       	mov    0xc0126ae8,%eax
c0108b18:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108b1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b1e:	89 45 f0             	mov    %eax,-0x10(%ebp)
        local_intr_save(intr_flag);
c0108b21:	e8 4a fc ff ff       	call   c0108770 <__intr_save>
c0108b26:	89 45 ec             	mov    %eax,-0x14(%ebp)
        {
            current = proc;
c0108b29:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b2c:	a3 e8 6a 12 c0       	mov    %eax,0xc0126ae8
            load_esp0(next->kstack + KSTACKSIZE);
c0108b31:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b34:	8b 40 0c             	mov    0xc(%eax),%eax
c0108b37:	05 00 20 00 00       	add    $0x2000,%eax
c0108b3c:	89 04 24             	mov    %eax,(%esp)
c0108b3f:	e8 3b c2 ff ff       	call   c0104d7f <load_esp0>
            lcr3(next->cr3);
c0108b44:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b47:	8b 40 40             	mov    0x40(%eax),%eax
c0108b4a:	89 45 e8             	mov    %eax,-0x18(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0108b4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108b50:	0f 22 d8             	mov    %eax,%cr3
            switch_to(&(prev->context), &(next->context));
c0108b53:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108b56:	8d 50 1c             	lea    0x1c(%eax),%edx
c0108b59:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108b5c:	83 c0 1c             	add    $0x1c,%eax
c0108b5f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108b63:	89 04 24             	mov    %eax,(%esp)
c0108b66:	e8 a9 06 00 00       	call   c0109214 <switch_to>
        }
        local_intr_restore(intr_flag);
c0108b6b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108b6e:	89 04 24             	mov    %eax,(%esp)
c0108b71:	e8 29 fc ff ff       	call   c010879f <__intr_restore>
    }
}
c0108b76:	c9                   	leave  
c0108b77:	c3                   	ret    

c0108b78 <forkret>:

// forkret -- the first kernel entry point of a new thread/process
// NOTE: the addr of forkret is setted in copy_thread function
//       after switch_to, the current proc will execute here.
static void
forkret(void) {
c0108b78:	55                   	push   %ebp
c0108b79:	89 e5                	mov    %esp,%ebp
c0108b7b:	83 ec 18             	sub    $0x18,%esp
    forkrets(current->tf);
c0108b7e:	a1 e8 6a 12 c0       	mov    0xc0126ae8,%eax
c0108b83:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108b86:	89 04 24             	mov    %eax,(%esp)
c0108b89:	e8 3c 9d ff ff       	call   c01028ca <forkrets>
}
c0108b8e:	c9                   	leave  
c0108b8f:	c3                   	ret    

c0108b90 <hash_proc>:

// hash_proc - add proc into proc hash_list
static void
hash_proc(struct proc_struct *proc) {
c0108b90:	55                   	push   %ebp
c0108b91:	89 e5                	mov    %esp,%ebp
c0108b93:	53                   	push   %ebx
c0108b94:	83 ec 34             	sub    $0x34,%esp
    list_add(hash_list + pid_hashfn(proc->pid), &(proc->hash_link));
c0108b97:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b9a:	8d 58 60             	lea    0x60(%eax),%ebx
c0108b9d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ba0:	8b 40 04             	mov    0x4(%eax),%eax
c0108ba3:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108baa:	00 
c0108bab:	89 04 24             	mov    %eax,(%esp)
c0108bae:	e8 ed 07 00 00       	call   c01093a0 <hash32>
c0108bb3:	c1 e0 03             	shl    $0x3,%eax
c0108bb6:	05 00 6b 12 c0       	add    $0xc0126b00,%eax
c0108bbb:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108bbe:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c0108bc1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108bc4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108bc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108bca:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108bcd:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108bd0:	8b 40 04             	mov    0x4(%eax),%eax
c0108bd3:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108bd6:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0108bd9:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108bdc:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0108bdf:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108be2:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108be5:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108be8:	89 10                	mov    %edx,(%eax)
c0108bea:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108bed:	8b 10                	mov    (%eax),%edx
c0108bef:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108bf2:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108bf5:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108bf8:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108bfb:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108bfe:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108c01:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108c04:	89 10                	mov    %edx,(%eax)
}
c0108c06:	83 c4 34             	add    $0x34,%esp
c0108c09:	5b                   	pop    %ebx
c0108c0a:	5d                   	pop    %ebp
c0108c0b:	c3                   	ret    

c0108c0c <find_proc>:

// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
c0108c0c:	55                   	push   %ebp
c0108c0d:	89 e5                	mov    %esp,%ebp
c0108c0f:	83 ec 28             	sub    $0x28,%esp
    if (0 < pid && pid < MAX_PID) {
c0108c12:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108c16:	7e 5f                	jle    c0108c77 <find_proc+0x6b>
c0108c18:	81 7d 08 ff 1f 00 00 	cmpl   $0x1fff,0x8(%ebp)
c0108c1f:	7f 56                	jg     c0108c77 <find_proc+0x6b>
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
c0108c21:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c24:	c7 44 24 04 0a 00 00 	movl   $0xa,0x4(%esp)
c0108c2b:	00 
c0108c2c:	89 04 24             	mov    %eax,(%esp)
c0108c2f:	e8 6c 07 00 00       	call   c01093a0 <hash32>
c0108c34:	c1 e0 03             	shl    $0x3,%eax
c0108c37:	05 00 6b 12 c0       	add    $0xc0126b00,%eax
c0108c3c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108c3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108c42:	89 45 f4             	mov    %eax,-0xc(%ebp)
        while ((le = list_next(le)) != list) {
c0108c45:	eb 19                	jmp    c0108c60 <find_proc+0x54>
            struct proc_struct *proc = le2proc(le, hash_link);
c0108c47:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c4a:	83 e8 60             	sub    $0x60,%eax
c0108c4d:	89 45 ec             	mov    %eax,-0x14(%ebp)
            if (proc->pid == pid) {
c0108c50:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c53:	8b 40 04             	mov    0x4(%eax),%eax
c0108c56:	3b 45 08             	cmp    0x8(%ebp),%eax
c0108c59:	75 05                	jne    c0108c60 <find_proc+0x54>
                return proc;
c0108c5b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108c5e:	eb 1c                	jmp    c0108c7c <find_proc+0x70>
c0108c60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c63:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0108c66:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108c69:	8b 40 04             	mov    0x4(%eax),%eax
// find_proc - find proc frome proc hash_list according to pid
struct proc_struct *
find_proc(int pid) {
    if (0 < pid && pid < MAX_PID) {
        list_entry_t *list = hash_list + pid_hashfn(pid), *le = list;
        while ((le = list_next(le)) != list) {
c0108c6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c6f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108c72:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0108c75:	75 d0                	jne    c0108c47 <find_proc+0x3b>
            if (proc->pid == pid) {
                return proc;
            }
        }
    }
    return NULL;
c0108c77:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108c7c:	c9                   	leave  
c0108c7d:	c3                   	ret    

c0108c7e <kernel_thread>:

// kernel_thread - create a kernel thread using "fn" function
// NOTE: the contents of temp trapframe tf will be copied to 
//       proc->tf in do_fork-->copy_thread function
int
kernel_thread(int (*fn)(void *), void *arg, uint32_t clone_flags) {
c0108c7e:	55                   	push   %ebp
c0108c7f:	89 e5                	mov    %esp,%ebp
c0108c81:	83 ec 68             	sub    $0x68,%esp
    struct trapframe tf;
    memset(&tf, 0, sizeof(struct trapframe));
c0108c84:	c7 44 24 08 4c 00 00 	movl   $0x4c,0x8(%esp)
c0108c8b:	00 
c0108c8c:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108c93:	00 
c0108c94:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108c97:	89 04 24             	mov    %eax,(%esp)
c0108c9a:	e8 34 12 00 00       	call   c0109ed3 <memset>
    tf.tf_cs = KERNEL_CS;
c0108c9f:	66 c7 45 e8 08 00    	movw   $0x8,-0x18(%ebp)
    tf.tf_ds = tf.tf_es = tf.tf_ss = KERNEL_DS;
c0108ca5:	66 c7 45 f4 10 00    	movw   $0x10,-0xc(%ebp)
c0108cab:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0108caf:	66 89 45 d4          	mov    %ax,-0x2c(%ebp)
c0108cb3:	0f b7 45 d4          	movzwl -0x2c(%ebp),%eax
c0108cb7:	66 89 45 d8          	mov    %ax,-0x28(%ebp)
    tf.tf_regs.reg_ebx = (uint32_t)fn;
c0108cbb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108cbe:	89 45 bc             	mov    %eax,-0x44(%ebp)
    tf.tf_regs.reg_edx = (uint32_t)arg;
c0108cc1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108cc4:	89 45 c0             	mov    %eax,-0x40(%ebp)
    tf.tf_eip = (uint32_t)kernel_thread_entry;
c0108cc7:	b8 64 87 10 c0       	mov    $0xc0108764,%eax
c0108ccc:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    return do_fork(clone_flags | CLONE_VM, 0, &tf);
c0108ccf:	8b 45 10             	mov    0x10(%ebp),%eax
c0108cd2:	89 c2                	mov    %eax,%edx
c0108cd4:	80 ce 01             	or     $0x1,%dh
c0108cd7:	8d 45 ac             	lea    -0x54(%ebp),%eax
c0108cda:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108cde:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0108ce5:	00 
c0108ce6:	89 14 24             	mov    %edx,(%esp)
c0108ce9:	e8 79 01 00 00       	call   c0108e67 <do_fork>
}
c0108cee:	c9                   	leave  
c0108cef:	c3                   	ret    

c0108cf0 <setup_kstack>:

// setup_kstack - alloc pages with size KSTACKPAGE as process kernel stack
static int
setup_kstack(struct proc_struct *proc) {
c0108cf0:	55                   	push   %ebp
c0108cf1:	89 e5                	mov    %esp,%ebp
c0108cf3:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_pages(KSTACKPAGE);
c0108cf6:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0108cfd:	e8 cb c1 ff ff       	call   c0104ecd <alloc_pages>
c0108d02:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0108d05:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108d09:	74 1a                	je     c0108d25 <setup_kstack+0x35>
        proc->kstack = (uintptr_t)page2kva(page);
c0108d0b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108d0e:	89 04 24             	mov    %eax,(%esp)
c0108d11:	e8 0d fb ff ff       	call   c0108823 <page2kva>
c0108d16:	89 c2                	mov    %eax,%edx
c0108d18:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d1b:	89 50 0c             	mov    %edx,0xc(%eax)
        return 0;
c0108d1e:	b8 00 00 00 00       	mov    $0x0,%eax
c0108d23:	eb 05                	jmp    c0108d2a <setup_kstack+0x3a>
    }
    return -E_NO_MEM;
c0108d25:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
}
c0108d2a:	c9                   	leave  
c0108d2b:	c3                   	ret    

c0108d2c <put_kstack>:

// put_kstack - free the memory space of process kernel stack
static void
put_kstack(struct proc_struct *proc) {
c0108d2c:	55                   	push   %ebp
c0108d2d:	89 e5                	mov    %esp,%ebp
c0108d2f:	83 ec 18             	sub    $0x18,%esp
    free_pages(kva2page((void *)(proc->kstack)), KSTACKPAGE);
c0108d32:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d35:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d38:	89 04 24             	mov    %eax,(%esp)
c0108d3b:	e8 37 fb ff ff       	call   c0108877 <kva2page>
c0108d40:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c0108d47:	00 
c0108d48:	89 04 24             	mov    %eax,(%esp)
c0108d4b:	e8 e8 c1 ff ff       	call   c0104f38 <free_pages>
}
c0108d50:	c9                   	leave  
c0108d51:	c3                   	ret    

c0108d52 <copy_mm>:

// copy_mm - process "proc" duplicate OR share process "current"'s mm according clone_flags
//         - if clone_flags & CLONE_VM, then "share" ; else "duplicate"
static int
copy_mm(uint32_t clone_flags, struct proc_struct *proc) {
c0108d52:	55                   	push   %ebp
c0108d53:	89 e5                	mov    %esp,%ebp
c0108d55:	83 ec 18             	sub    $0x18,%esp
    assert(current->mm == NULL);
c0108d58:	a1 e8 6a 12 c0       	mov    0xc0126ae8,%eax
c0108d5d:	8b 40 18             	mov    0x18(%eax),%eax
c0108d60:	85 c0                	test   %eax,%eax
c0108d62:	74 24                	je     c0108d88 <copy_mm+0x36>
c0108d64:	c7 44 24 0c e4 bf 10 	movl   $0xc010bfe4,0xc(%esp)
c0108d6b:	c0 
c0108d6c:	c7 44 24 08 f8 bf 10 	movl   $0xc010bff8,0x8(%esp)
c0108d73:	c0 
c0108d74:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c0108d7b:	00 
c0108d7c:	c7 04 24 0d c0 10 c0 	movl   $0xc010c00d,(%esp)
c0108d83:	e8 38 7f ff ff       	call   c0100cc0 <__panic>
    /* do nothing in this project */
    return 0;
c0108d88:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108d8d:	c9                   	leave  
c0108d8e:	c3                   	ret    

c0108d8f <copy_thread>:

// copy_thread - setup the trapframe on the  process's kernel stack top and
//             - setup the kernel entry point and stack of process
static void
copy_thread(struct proc_struct *proc, uintptr_t esp, struct trapframe *tf) {
c0108d8f:	55                   	push   %ebp
c0108d90:	89 e5                	mov    %esp,%ebp
c0108d92:	57                   	push   %edi
c0108d93:	56                   	push   %esi
c0108d94:	53                   	push   %ebx
    proc->tf = (struct trapframe *)(proc->kstack + KSTACKSIZE) - 1;
c0108d95:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d98:	8b 40 0c             	mov    0xc(%eax),%eax
c0108d9b:	05 b4 1f 00 00       	add    $0x1fb4,%eax
c0108da0:	89 c2                	mov    %eax,%edx
c0108da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0108da5:	89 50 3c             	mov    %edx,0x3c(%eax)
    *(proc->tf) = *tf;
c0108da8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dab:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108dae:	8b 55 10             	mov    0x10(%ebp),%edx
c0108db1:	bb 4c 00 00 00       	mov    $0x4c,%ebx
c0108db6:	89 c1                	mov    %eax,%ecx
c0108db8:	83 e1 01             	and    $0x1,%ecx
c0108dbb:	85 c9                	test   %ecx,%ecx
c0108dbd:	74 0e                	je     c0108dcd <copy_thread+0x3e>
c0108dbf:	0f b6 0a             	movzbl (%edx),%ecx
c0108dc2:	88 08                	mov    %cl,(%eax)
c0108dc4:	83 c0 01             	add    $0x1,%eax
c0108dc7:	83 c2 01             	add    $0x1,%edx
c0108dca:	83 eb 01             	sub    $0x1,%ebx
c0108dcd:	89 c1                	mov    %eax,%ecx
c0108dcf:	83 e1 02             	and    $0x2,%ecx
c0108dd2:	85 c9                	test   %ecx,%ecx
c0108dd4:	74 0f                	je     c0108de5 <copy_thread+0x56>
c0108dd6:	0f b7 0a             	movzwl (%edx),%ecx
c0108dd9:	66 89 08             	mov    %cx,(%eax)
c0108ddc:	83 c0 02             	add    $0x2,%eax
c0108ddf:	83 c2 02             	add    $0x2,%edx
c0108de2:	83 eb 02             	sub    $0x2,%ebx
c0108de5:	89 d9                	mov    %ebx,%ecx
c0108de7:	c1 e9 02             	shr    $0x2,%ecx
c0108dea:	89 c7                	mov    %eax,%edi
c0108dec:	89 d6                	mov    %edx,%esi
c0108dee:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108df0:	89 f2                	mov    %esi,%edx
c0108df2:	89 f8                	mov    %edi,%eax
c0108df4:	b9 00 00 00 00       	mov    $0x0,%ecx
c0108df9:	89 de                	mov    %ebx,%esi
c0108dfb:	83 e6 02             	and    $0x2,%esi
c0108dfe:	85 f6                	test   %esi,%esi
c0108e00:	74 0b                	je     c0108e0d <copy_thread+0x7e>
c0108e02:	0f b7 34 0a          	movzwl (%edx,%ecx,1),%esi
c0108e06:	66 89 34 08          	mov    %si,(%eax,%ecx,1)
c0108e0a:	83 c1 02             	add    $0x2,%ecx
c0108e0d:	83 e3 01             	and    $0x1,%ebx
c0108e10:	85 db                	test   %ebx,%ebx
c0108e12:	74 07                	je     c0108e1b <copy_thread+0x8c>
c0108e14:	0f b6 14 0a          	movzbl (%edx,%ecx,1),%edx
c0108e18:	88 14 08             	mov    %dl,(%eax,%ecx,1)
    proc->tf->tf_regs.reg_eax = 0;
c0108e1b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e1e:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108e21:	c7 40 1c 00 00 00 00 	movl   $0x0,0x1c(%eax)
    proc->tf->tf_esp = esp;
c0108e28:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e2b:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108e2e:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108e31:	89 50 44             	mov    %edx,0x44(%eax)
    proc->tf->tf_eflags |= FL_IF;
c0108e34:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e37:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108e3a:	8b 55 08             	mov    0x8(%ebp),%edx
c0108e3d:	8b 52 3c             	mov    0x3c(%edx),%edx
c0108e40:	8b 52 40             	mov    0x40(%edx),%edx
c0108e43:	80 ce 02             	or     $0x2,%dh
c0108e46:	89 50 40             	mov    %edx,0x40(%eax)

    proc->context.eip = (uintptr_t)forkret;
c0108e49:	ba 78 8b 10 c0       	mov    $0xc0108b78,%edx
c0108e4e:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e51:	89 50 1c             	mov    %edx,0x1c(%eax)
    proc->context.esp = (uintptr_t)(proc->tf);
c0108e54:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e57:	8b 40 3c             	mov    0x3c(%eax),%eax
c0108e5a:	89 c2                	mov    %eax,%edx
c0108e5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e5f:	89 50 20             	mov    %edx,0x20(%eax)
}
c0108e62:	5b                   	pop    %ebx
c0108e63:	5e                   	pop    %esi
c0108e64:	5f                   	pop    %edi
c0108e65:	5d                   	pop    %ebp
c0108e66:	c3                   	ret    

c0108e67 <do_fork>:
 * @clone_flags: used to guide how to clone the child process
 * @stack:       the parent's user stack pointer. if stack==0, It means to fork a kernel thread.
 * @tf:          the trapframe info, which will be copied to child process's proc->tf
 */
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
c0108e67:	55                   	push   %ebp
c0108e68:	89 e5                	mov    %esp,%ebp
c0108e6a:	83 ec 48             	sub    $0x48,%esp
    int ret = -E_NO_FREE_PROC;
c0108e6d:	c7 45 f4 fb ff ff ff 	movl   $0xfffffffb,-0xc(%ebp)
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
c0108e74:	a1 00 8b 12 c0       	mov    0xc0128b00,%eax
c0108e79:	3d ff 0f 00 00       	cmp    $0xfff,%eax
c0108e7e:	0f 8f 16 01 00 00    	jg     c0108f9a <do_fork+0x133>
        goto fork_out;
    }
    ret = -E_NO_MEM;
c0108e84:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)
    //    3. call copy_mm to dup OR share mm according clone_flag
    //    4. call copy_thread to setup tf & context in proc_struct
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
proc = alloc_proc();
c0108e8b:	e8 31 fa ff ff       	call   c01088c1 <alloc_proc>
c0108e90:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!proc)
c0108e93:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108e97:	0f 84 00 01 00 00    	je     c0108f9d <do_fork+0x136>
        goto fork_out;
    int ret2;
    ret2 = setup_kstack(proc);
c0108e9d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ea0:	89 04 24             	mov    %eax,(%esp)
c0108ea3:	e8 48 fe ff ff       	call   c0108cf0 <setup_kstack>
c0108ea8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (ret2)
c0108eab:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108eaf:	0f 85 fc 00 00 00    	jne    c0108fb1 <do_fork+0x14a>
        goto bad_fork_cleanup_proc;
    ret2 = copy_mm(clone_flags, proc);
c0108eb5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108eb8:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ebc:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ebf:	89 04 24             	mov    %eax,(%esp)
c0108ec2:	e8 8b fe ff ff       	call   c0108d52 <copy_mm>
c0108ec7:	89 45 ec             	mov    %eax,-0x14(%ebp)
    if (ret2)
c0108eca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0108ece:	0f 85 cf 00 00 00    	jne    c0108fa3 <do_fork+0x13c>
        goto bad_fork_cleanup_kstack;
    copy_thread(proc, stack, tf);
c0108ed4:	8b 45 10             	mov    0x10(%ebp),%eax
c0108ed7:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108edb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ede:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108ee2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108ee5:	89 04 24             	mov    %eax,(%esp)
c0108ee8:	e8 a2 fe ff ff       	call   c0108d8f <copy_thread>
    bool intr_flag;
    local_intr_save(intr_flag);
c0108eed:	e8 7e f8 ff ff       	call   c0108770 <__intr_save>
c0108ef2:	89 45 e8             	mov    %eax,-0x18(%ebp)
    {
        proc->pid = get_pid();
c0108ef5:	e8 11 fb ff ff       	call   c0108a0b <get_pid>
c0108efa:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108efd:	89 42 04             	mov    %eax,0x4(%edx)
        proc->parent = current;
c0108f00:	8b 15 e8 6a 12 c0    	mov    0xc0126ae8,%edx
c0108f06:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f09:	89 50 14             	mov    %edx,0x14(%eax)
        nr_process++;
c0108f0c:	a1 00 8b 12 c0       	mov    0xc0128b00,%eax
c0108f11:	83 c0 01             	add    $0x1,%eax
c0108f14:	a3 00 8b 12 c0       	mov    %eax,0xc0128b00
        list_add(&proc_list, &(proc->list_link));
c0108f19:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f1c:	83 c0 58             	add    $0x58,%eax
c0108f1f:	c7 45 e4 10 8c 12 c0 	movl   $0xc0128c10,-0x1c(%ebp)
c0108f26:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108f29:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108f2c:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0108f2f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108f32:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c0108f35:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108f38:	8b 40 04             	mov    0x4(%eax),%eax
c0108f3b:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0108f3e:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0108f41:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0108f44:	89 55 d0             	mov    %edx,-0x30(%ebp)
c0108f47:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0108f4a:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108f4d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0108f50:	89 10                	mov    %edx,(%eax)
c0108f52:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0108f55:	8b 10                	mov    (%eax),%edx
c0108f57:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108f5a:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0108f5d:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108f60:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108f63:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0108f66:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0108f69:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0108f6c:	89 10                	mov    %edx,(%eax)
        hash_proc(proc);
c0108f6e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f71:	89 04 24             	mov    %eax,(%esp)
c0108f74:	e8 17 fc ff ff       	call   c0108b90 <hash_proc>
    }
    local_intr_restore(intr_flag);
c0108f79:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108f7c:	89 04 24             	mov    %eax,(%esp)
c0108f7f:	e8 1b f8 ff ff       	call   c010879f <__intr_restore>
    wakeup_proc(proc);
c0108f84:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f87:	89 04 24             	mov    %eax,(%esp)
c0108f8a:	e8 ff 02 00 00       	call   c010928e <wakeup_proc>
    ret = proc->pid;
c0108f8f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108f92:	8b 40 04             	mov    0x4(%eax),%eax
c0108f95:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108f98:	eb 04                	jmp    c0108f9e <do_fork+0x137>
int
do_fork(uint32_t clone_flags, uintptr_t stack, struct trapframe *tf) {
    int ret = -E_NO_FREE_PROC;
    struct proc_struct *proc;
    if (nr_process >= MAX_PROCESS) {
        goto fork_out;
c0108f9a:	90                   	nop
c0108f9b:	eb 01                	jmp    c0108f9e <do_fork+0x137>
    //    5. insert proc_struct into hash_list && proc_list
    //    6. call wakeup_proc to make the new child process RUNNABLE
    //    7. set ret vaule using child proc's pid
proc = alloc_proc();
    if (!proc)
        goto fork_out;
c0108f9d:	90                   	nop
    }
    local_intr_restore(intr_flag);
    wakeup_proc(proc);
    ret = proc->pid;
    fork_out:
    return ret;
c0108f9e:	8b 45 f4             	mov    -0xc(%ebp),%eax
bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
    goto fork_out;
}
c0108fa1:	c9                   	leave  
c0108fa2:	c3                   	ret    
    ret2 = setup_kstack(proc);
    if (ret2)
        goto bad_fork_cleanup_proc;
    ret2 = copy_mm(clone_flags, proc);
    if (ret2)
        goto bad_fork_cleanup_kstack;
c0108fa3:	90                   	nop
    ret = proc->pid;
    fork_out:
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
c0108fa4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fa7:	89 04 24             	mov    %eax,(%esp)
c0108faa:	e8 7d fd ff ff       	call   c0108d2c <put_kstack>
c0108faf:	eb 01                	jmp    c0108fb2 <do_fork+0x14b>
    if (!proc)
        goto fork_out;
    int ret2;
    ret2 = setup_kstack(proc);
    if (ret2)
        goto bad_fork_cleanup_proc;
c0108fb1:	90                   	nop
    return ret;

bad_fork_cleanup_kstack:
    put_kstack(proc);
bad_fork_cleanup_proc:
    kfree(proc);
c0108fb2:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108fb5:	89 04 24             	mov    %eax,(%esp)
c0108fb8:	e8 a4 ba ff ff       	call   c0104a61 <kfree>
    goto fork_out;
c0108fbd:	eb df                	jmp    c0108f9e <do_fork+0x137>

c0108fbf <do_exit>:
// do_exit - called by sys_exit
//   1. call exit_mmap & put_pgdir & mm_destroy to free the almost all memory space of process
//   2. set process' state as PROC_ZOMBIE, then call wakeup_proc(parent) to ask parent reclaim itself.
//   3. call scheduler to switch to other process
int
do_exit(int error_code) {
c0108fbf:	55                   	push   %ebp
c0108fc0:	89 e5                	mov    %esp,%ebp
c0108fc2:	83 ec 18             	sub    $0x18,%esp
    panic("process exit!!.\n");
c0108fc5:	c7 44 24 08 21 c0 10 	movl   $0xc010c021,0x8(%esp)
c0108fcc:	c0 
c0108fcd:	c7 44 24 04 5e 01 00 	movl   $0x15e,0x4(%esp)
c0108fd4:	00 
c0108fd5:	c7 04 24 0d c0 10 c0 	movl   $0xc010c00d,(%esp)
c0108fdc:	e8 df 7c ff ff       	call   c0100cc0 <__panic>

c0108fe1 <init_main>:
}

// init_main - the second kernel thread used to create user_main kernel threads
static int
init_main(void *arg) {
c0108fe1:	55                   	push   %ebp
c0108fe2:	89 e5                	mov    %esp,%ebp
c0108fe4:	83 ec 18             	sub    $0x18,%esp
    cprintf("this initproc, pid = %d, name = \"%s\"\n", current->pid, get_proc_name(current));
c0108fe7:	a1 e8 6a 12 c0       	mov    0xc0126ae8,%eax
c0108fec:	89 04 24             	mov    %eax,(%esp)
c0108fef:	e8 d5 f9 ff ff       	call   c01089c9 <get_proc_name>
c0108ff4:	8b 15 e8 6a 12 c0    	mov    0xc0126ae8,%edx
c0108ffa:	8b 52 04             	mov    0x4(%edx),%edx
c0108ffd:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109001:	89 54 24 04          	mov    %edx,0x4(%esp)
c0109005:	c7 04 24 34 c0 10 c0 	movl   $0xc010c034,(%esp)
c010900c:	e8 4e 73 ff ff       	call   c010035f <cprintf>
    cprintf("To U: \"%s\".\n", (const char *)arg);
c0109011:	8b 45 08             	mov    0x8(%ebp),%eax
c0109014:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109018:	c7 04 24 5a c0 10 c0 	movl   $0xc010c05a,(%esp)
c010901f:	e8 3b 73 ff ff       	call   c010035f <cprintf>
    cprintf("To U: \"en.., Bye, Bye. :)\"\n");
c0109024:	c7 04 24 67 c0 10 c0 	movl   $0xc010c067,(%esp)
c010902b:	e8 2f 73 ff ff       	call   c010035f <cprintf>
    return 0;
c0109030:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109035:	c9                   	leave  
c0109036:	c3                   	ret    

c0109037 <proc_init>:

// proc_init - set up the first kernel thread idleproc "idle" by itself and 
//           - create the second kernel thread init_main
void
proc_init(void) {
c0109037:	55                   	push   %ebp
c0109038:	89 e5                	mov    %esp,%ebp
c010903a:	83 ec 28             	sub    $0x28,%esp
c010903d:	c7 45 ec 10 8c 12 c0 	movl   $0xc0128c10,-0x14(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0109044:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109047:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010904a:	89 50 04             	mov    %edx,0x4(%eax)
c010904d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109050:	8b 50 04             	mov    0x4(%eax),%edx
c0109053:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109056:	89 10                	mov    %edx,(%eax)
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0109058:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010905f:	eb 26                	jmp    c0109087 <proc_init+0x50>
        list_init(hash_list + i);
c0109061:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109064:	c1 e0 03             	shl    $0x3,%eax
c0109067:	05 00 6b 12 c0       	add    $0xc0126b00,%eax
c010906c:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010906f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109072:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109075:	89 50 04             	mov    %edx,0x4(%eax)
c0109078:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010907b:	8b 50 04             	mov    0x4(%eax),%edx
c010907e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109081:	89 10                	mov    %edx,(%eax)
void
proc_init(void) {
    int i;

    list_init(&proc_list);
    for (i = 0; i < HASH_LIST_SIZE; i ++) {
c0109083:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0109087:	81 7d f4 ff 03 00 00 	cmpl   $0x3ff,-0xc(%ebp)
c010908e:	7e d1                	jle    c0109061 <proc_init+0x2a>
        list_init(hash_list + i);
    }

    if ((idleproc = alloc_proc()) == NULL) {
c0109090:	e8 2c f8 ff ff       	call   c01088c1 <alloc_proc>
c0109095:	a3 e0 6a 12 c0       	mov    %eax,0xc0126ae0
c010909a:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c010909f:	85 c0                	test   %eax,%eax
c01090a1:	75 1c                	jne    c01090bf <proc_init+0x88>
        panic("cannot alloc idleproc.\n");
c01090a3:	c7 44 24 08 83 c0 10 	movl   $0xc010c083,0x8(%esp)
c01090aa:	c0 
c01090ab:	c7 44 24 04 76 01 00 	movl   $0x176,0x4(%esp)
c01090b2:	00 
c01090b3:	c7 04 24 0d c0 10 c0 	movl   $0xc010c00d,(%esp)
c01090ba:	e8 01 7c ff ff       	call   c0100cc0 <__panic>
    }

    idleproc->pid = 0;
c01090bf:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c01090c4:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    idleproc->state = PROC_RUNNABLE;
c01090cb:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c01090d0:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
    idleproc->kstack = (uintptr_t)bootstack;
c01090d6:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c01090db:	ba 00 30 12 c0       	mov    $0xc0123000,%edx
c01090e0:	89 50 0c             	mov    %edx,0xc(%eax)
    idleproc->need_resched = 1;
c01090e3:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c01090e8:	c7 40 10 01 00 00 00 	movl   $0x1,0x10(%eax)
    set_proc_name(idleproc, "idle");
c01090ef:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c01090f4:	c7 44 24 04 9b c0 10 	movl   $0xc010c09b,0x4(%esp)
c01090fb:	c0 
c01090fc:	89 04 24             	mov    %eax,(%esp)
c01090ff:	e8 82 f8 ff ff       	call   c0108986 <set_proc_name>
    nr_process ++;
c0109104:	a1 00 8b 12 c0       	mov    0xc0128b00,%eax
c0109109:	83 c0 01             	add    $0x1,%eax
c010910c:	a3 00 8b 12 c0       	mov    %eax,0xc0128b00

    current = idleproc;
c0109111:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c0109116:	a3 e8 6a 12 c0       	mov    %eax,0xc0126ae8

    int pid = kernel_thread(init_main, "Hello world!!", 0);
c010911b:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0109122:	00 
c0109123:	c7 44 24 04 a0 c0 10 	movl   $0xc010c0a0,0x4(%esp)
c010912a:	c0 
c010912b:	c7 04 24 e1 8f 10 c0 	movl   $0xc0108fe1,(%esp)
c0109132:	e8 47 fb ff ff       	call   c0108c7e <kernel_thread>
c0109137:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (pid <= 0) {
c010913a:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010913e:	7f 1c                	jg     c010915c <proc_init+0x125>
        panic("create init_main failed.\n");
c0109140:	c7 44 24 08 ae c0 10 	movl   $0xc010c0ae,0x8(%esp)
c0109147:	c0 
c0109148:	c7 44 24 04 84 01 00 	movl   $0x184,0x4(%esp)
c010914f:	00 
c0109150:	c7 04 24 0d c0 10 c0 	movl   $0xc010c00d,(%esp)
c0109157:	e8 64 7b ff ff       	call   c0100cc0 <__panic>
    }

    initproc = find_proc(pid);
c010915c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010915f:	89 04 24             	mov    %eax,(%esp)
c0109162:	e8 a5 fa ff ff       	call   c0108c0c <find_proc>
c0109167:	a3 e4 6a 12 c0       	mov    %eax,0xc0126ae4
    set_proc_name(initproc, "init");
c010916c:	a1 e4 6a 12 c0       	mov    0xc0126ae4,%eax
c0109171:	c7 44 24 04 c8 c0 10 	movl   $0xc010c0c8,0x4(%esp)
c0109178:	c0 
c0109179:	89 04 24             	mov    %eax,(%esp)
c010917c:	e8 05 f8 ff ff       	call   c0108986 <set_proc_name>

    assert(idleproc != NULL && idleproc->pid == 0);
c0109181:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c0109186:	85 c0                	test   %eax,%eax
c0109188:	74 0c                	je     c0109196 <proc_init+0x15f>
c010918a:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c010918f:	8b 40 04             	mov    0x4(%eax),%eax
c0109192:	85 c0                	test   %eax,%eax
c0109194:	74 24                	je     c01091ba <proc_init+0x183>
c0109196:	c7 44 24 0c d0 c0 10 	movl   $0xc010c0d0,0xc(%esp)
c010919d:	c0 
c010919e:	c7 44 24 08 f8 bf 10 	movl   $0xc010bff8,0x8(%esp)
c01091a5:	c0 
c01091a6:	c7 44 24 04 8a 01 00 	movl   $0x18a,0x4(%esp)
c01091ad:	00 
c01091ae:	c7 04 24 0d c0 10 c0 	movl   $0xc010c00d,(%esp)
c01091b5:	e8 06 7b ff ff       	call   c0100cc0 <__panic>
    assert(initproc != NULL && initproc->pid == 1);
c01091ba:	a1 e4 6a 12 c0       	mov    0xc0126ae4,%eax
c01091bf:	85 c0                	test   %eax,%eax
c01091c1:	74 0d                	je     c01091d0 <proc_init+0x199>
c01091c3:	a1 e4 6a 12 c0       	mov    0xc0126ae4,%eax
c01091c8:	8b 40 04             	mov    0x4(%eax),%eax
c01091cb:	83 f8 01             	cmp    $0x1,%eax
c01091ce:	74 24                	je     c01091f4 <proc_init+0x1bd>
c01091d0:	c7 44 24 0c f8 c0 10 	movl   $0xc010c0f8,0xc(%esp)
c01091d7:	c0 
c01091d8:	c7 44 24 08 f8 bf 10 	movl   $0xc010bff8,0x8(%esp)
c01091df:	c0 
c01091e0:	c7 44 24 04 8b 01 00 	movl   $0x18b,0x4(%esp)
c01091e7:	00 
c01091e8:	c7 04 24 0d c0 10 c0 	movl   $0xc010c00d,(%esp)
c01091ef:	e8 cc 7a ff ff       	call   c0100cc0 <__panic>
}
c01091f4:	c9                   	leave  
c01091f5:	c3                   	ret    

c01091f6 <cpu_idle>:

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
c01091f6:	55                   	push   %ebp
c01091f7:	89 e5                	mov    %esp,%ebp
c01091f9:	83 ec 08             	sub    $0x8,%esp
c01091fc:	eb 01                	jmp    c01091ff <cpu_idle+0x9>
    while (1) {
        if (current->need_resched) {
            schedule();
        }
    }
c01091fe:	90                   	nop

// cpu_idle - at the end of kern_init, the first kernel thread idleproc will do below works
void
cpu_idle(void) {
    while (1) {
        if (current->need_resched) {
c01091ff:	a1 e8 6a 12 c0       	mov    0xc0126ae8,%eax
c0109204:	8b 40 10             	mov    0x10(%eax),%eax
c0109207:	85 c0                	test   %eax,%eax
c0109209:	74 f3                	je     c01091fe <cpu_idle+0x8>
            schedule();
c010920b:	e8 c7 00 00 00       	call   c01092d7 <schedule>
        }
    }
c0109210:	eb ec                	jmp    c01091fe <cpu_idle+0x8>
	...

c0109214 <switch_to>:
.text
.globl switch_to
switch_to:                      # switch_to(from, to)

    # save from's registers
    movl 4(%esp), %eax          # eax points to from
c0109214:	8b 44 24 04          	mov    0x4(%esp),%eax
    popl 0(%eax)                # save eip !popl
c0109218:	8f 00                	popl   (%eax)
    movl %esp, 4(%eax)
c010921a:	89 60 04             	mov    %esp,0x4(%eax)
    movl %ebx, 8(%eax)
c010921d:	89 58 08             	mov    %ebx,0x8(%eax)
    movl %ecx, 12(%eax)
c0109220:	89 48 0c             	mov    %ecx,0xc(%eax)
    movl %edx, 16(%eax)
c0109223:	89 50 10             	mov    %edx,0x10(%eax)
    movl %esi, 20(%eax)
c0109226:	89 70 14             	mov    %esi,0x14(%eax)
    movl %edi, 24(%eax)
c0109229:	89 78 18             	mov    %edi,0x18(%eax)
    movl %ebp, 28(%eax)
c010922c:	89 68 1c             	mov    %ebp,0x1c(%eax)

    # restore to's registers
    movl 4(%esp), %eax          # not 8(%esp): popped return address already
c010922f:	8b 44 24 04          	mov    0x4(%esp),%eax
                                # eax now points to to
    movl 28(%eax), %ebp
c0109233:	8b 68 1c             	mov    0x1c(%eax),%ebp
    movl 24(%eax), %edi
c0109236:	8b 78 18             	mov    0x18(%eax),%edi
    movl 20(%eax), %esi
c0109239:	8b 70 14             	mov    0x14(%eax),%esi
    movl 16(%eax), %edx
c010923c:	8b 50 10             	mov    0x10(%eax),%edx
    movl 12(%eax), %ecx
c010923f:	8b 48 0c             	mov    0xc(%eax),%ecx
    movl 8(%eax), %ebx
c0109242:	8b 58 08             	mov    0x8(%eax),%ebx
    movl 4(%eax), %esp
c0109245:	8b 60 04             	mov    0x4(%eax),%esp

    pushl 0(%eax)               # push eip
c0109248:	ff 30                	pushl  (%eax)

    ret
c010924a:	c3                   	ret    
	...

c010924c <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c010924c:	55                   	push   %ebp
c010924d:	89 e5                	mov    %esp,%ebp
c010924f:	53                   	push   %ebx
c0109250:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0109253:	9c                   	pushf  
c0109254:	5b                   	pop    %ebx
c0109255:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0109258:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c010925b:	25 00 02 00 00       	and    $0x200,%eax
c0109260:	85 c0                	test   %eax,%eax
c0109262:	74 0c                	je     c0109270 <__intr_save+0x24>
        intr_disable();
c0109264:	e8 85 8d ff ff       	call   c0101fee <intr_disable>
        return 1;
c0109269:	b8 01 00 00 00       	mov    $0x1,%eax
c010926e:	eb 05                	jmp    c0109275 <__intr_save+0x29>
    }
    return 0;
c0109270:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109275:	83 c4 14             	add    $0x14,%esp
c0109278:	5b                   	pop    %ebx
c0109279:	5d                   	pop    %ebp
c010927a:	c3                   	ret    

c010927b <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c010927b:	55                   	push   %ebp
c010927c:	89 e5                	mov    %esp,%ebp
c010927e:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0109281:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109285:	74 05                	je     c010928c <__intr_restore+0x11>
        intr_enable();
c0109287:	e8 5c 8d ff ff       	call   c0101fe8 <intr_enable>
    }
}
c010928c:	c9                   	leave  
c010928d:	c3                   	ret    

c010928e <wakeup_proc>:
#include <proc.h>
#include <sched.h>
#include <assert.h>

void
wakeup_proc(struct proc_struct *proc) {
c010928e:	55                   	push   %ebp
c010928f:	89 e5                	mov    %esp,%ebp
c0109291:	83 ec 18             	sub    $0x18,%esp
    assert(proc->state != PROC_ZOMBIE && proc->state != PROC_RUNNABLE);
c0109294:	8b 45 08             	mov    0x8(%ebp),%eax
c0109297:	8b 00                	mov    (%eax),%eax
c0109299:	83 f8 03             	cmp    $0x3,%eax
c010929c:	74 0a                	je     c01092a8 <wakeup_proc+0x1a>
c010929e:	8b 45 08             	mov    0x8(%ebp),%eax
c01092a1:	8b 00                	mov    (%eax),%eax
c01092a3:	83 f8 02             	cmp    $0x2,%eax
c01092a6:	75 24                	jne    c01092cc <wakeup_proc+0x3e>
c01092a8:	c7 44 24 0c 20 c1 10 	movl   $0xc010c120,0xc(%esp)
c01092af:	c0 
c01092b0:	c7 44 24 08 5b c1 10 	movl   $0xc010c15b,0x8(%esp)
c01092b7:	c0 
c01092b8:	c7 44 24 04 09 00 00 	movl   $0x9,0x4(%esp)
c01092bf:	00 
c01092c0:	c7 04 24 70 c1 10 c0 	movl   $0xc010c170,(%esp)
c01092c7:	e8 f4 79 ff ff       	call   c0100cc0 <__panic>
    proc->state = PROC_RUNNABLE;
c01092cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01092cf:	c7 00 02 00 00 00    	movl   $0x2,(%eax)
}
c01092d5:	c9                   	leave  
c01092d6:	c3                   	ret    

c01092d7 <schedule>:

void
schedule(void) {
c01092d7:	55                   	push   %ebp
c01092d8:	89 e5                	mov    %esp,%ebp
c01092da:	83 ec 38             	sub    $0x38,%esp
    bool intr_flag;
    list_entry_t *le, *last;
    struct proc_struct *next = NULL;
c01092dd:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    local_intr_save(intr_flag);
c01092e4:	e8 63 ff ff ff       	call   c010924c <__intr_save>
c01092e9:	89 45 ec             	mov    %eax,-0x14(%ebp)
    {
        current->need_resched = 0;
c01092ec:	a1 e8 6a 12 c0       	mov    0xc0126ae8,%eax
c01092f1:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)
        last = (current == idleproc) ? &proc_list : &(current->list_link);
c01092f8:	8b 15 e8 6a 12 c0    	mov    0xc0126ae8,%edx
c01092fe:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c0109303:	39 c2                	cmp    %eax,%edx
c0109305:	74 0a                	je     c0109311 <schedule+0x3a>
c0109307:	a1 e8 6a 12 c0       	mov    0xc0126ae8,%eax
c010930c:	83 c0 58             	add    $0x58,%eax
c010930f:	eb 05                	jmp    c0109316 <schedule+0x3f>
c0109311:	b8 10 8c 12 c0       	mov    $0xc0128c10,%eax
c0109316:	89 45 e8             	mov    %eax,-0x18(%ebp)
        le = last;
c0109319:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010931c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010931f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109322:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0109325:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109328:	8b 40 04             	mov    0x4(%eax),%eax
        do {
            if ((le = list_next(le)) != &proc_list) {
c010932b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010932e:	81 7d f4 10 8c 12 c0 	cmpl   $0xc0128c10,-0xc(%ebp)
c0109335:	74 13                	je     c010934a <schedule+0x73>
                next = le2proc(le, list_link);
c0109337:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010933a:	83 e8 58             	sub    $0x58,%eax
c010933d:	89 45 f0             	mov    %eax,-0x10(%ebp)
                if (next->state == PROC_RUNNABLE) {
c0109340:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109343:	8b 00                	mov    (%eax),%eax
c0109345:	83 f8 02             	cmp    $0x2,%eax
c0109348:	74 0a                	je     c0109354 <schedule+0x7d>
                    break;
                }
            }
        } while (le != last);
c010934a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010934d:	3b 45 e8             	cmp    -0x18(%ebp),%eax
c0109350:	75 cd                	jne    c010931f <schedule+0x48>
c0109352:	eb 01                	jmp    c0109355 <schedule+0x7e>
        le = last;
        do {
            if ((le = list_next(le)) != &proc_list) {
                next = le2proc(le, list_link);
                if (next->state == PROC_RUNNABLE) {
                    break;
c0109354:	90                   	nop
                }
            }
        } while (le != last);
        if (next == NULL || next->state != PROC_RUNNABLE) {
c0109355:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109359:	74 0a                	je     c0109365 <schedule+0x8e>
c010935b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010935e:	8b 00                	mov    (%eax),%eax
c0109360:	83 f8 02             	cmp    $0x2,%eax
c0109363:	74 08                	je     c010936d <schedule+0x96>
            next = idleproc;
c0109365:	a1 e0 6a 12 c0       	mov    0xc0126ae0,%eax
c010936a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        }
        next->runs ++;
c010936d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109370:	8b 40 08             	mov    0x8(%eax),%eax
c0109373:	8d 50 01             	lea    0x1(%eax),%edx
c0109376:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109379:	89 50 08             	mov    %edx,0x8(%eax)
        if (next != current) {
c010937c:	a1 e8 6a 12 c0       	mov    0xc0126ae8,%eax
c0109381:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0109384:	74 0b                	je     c0109391 <schedule+0xba>
            proc_run(next);
c0109386:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109389:	89 04 24             	mov    %eax,(%esp)
c010938c:	e8 72 f7 ff ff       	call   c0108b03 <proc_run>
        }
    }
    local_intr_restore(intr_flag);
c0109391:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109394:	89 04 24             	mov    %eax,(%esp)
c0109397:	e8 df fe ff ff       	call   c010927b <__intr_restore>
}
c010939c:	c9                   	leave  
c010939d:	c3                   	ret    
	...

c01093a0 <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
c01093a0:	55                   	push   %ebp
c01093a1:	89 e5                	mov    %esp,%ebp
c01093a3:	53                   	push   %ebx
c01093a4:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
c01093a7:	8b 45 08             	mov    0x8(%ebp),%eax
c01093aa:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
c01093b0:	89 45 f8             	mov    %eax,-0x8(%ebp)
    return (hash >> (32 - bits));
c01093b3:	b8 20 00 00 00       	mov    $0x20,%eax
c01093b8:	2b 45 0c             	sub    0xc(%ebp),%eax
c01093bb:	8b 55 f8             	mov    -0x8(%ebp),%edx
c01093be:	89 d3                	mov    %edx,%ebx
c01093c0:	89 c1                	mov    %eax,%ecx
c01093c2:	d3 eb                	shr    %cl,%ebx
c01093c4:	89 d8                	mov    %ebx,%eax
}
c01093c6:	83 c4 10             	add    $0x10,%esp
c01093c9:	5b                   	pop    %ebx
c01093ca:	5d                   	pop    %ebp
c01093cb:	c3                   	ret    

c01093cc <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01093cc:	55                   	push   %ebp
c01093cd:	89 e5                	mov    %esp,%ebp
c01093cf:	56                   	push   %esi
c01093d0:	53                   	push   %ebx
c01093d1:	83 ec 60             	sub    $0x60,%esp
c01093d4:	8b 45 10             	mov    0x10(%ebp),%eax
c01093d7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01093da:	8b 45 14             	mov    0x14(%ebp),%eax
c01093dd:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01093e0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01093e3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01093e6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01093e9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01093ec:	8b 45 18             	mov    0x18(%ebp),%eax
c01093ef:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01093f2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01093f5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01093f8:	89 45 c8             	mov    %eax,-0x38(%ebp)
c01093fb:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01093fe:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0109401:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0109404:	89 d3                	mov    %edx,%ebx
c0109406:	89 c6                	mov    %eax,%esi
c0109408:	89 75 e0             	mov    %esi,-0x20(%ebp)
c010940b:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c010940e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109411:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109414:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0109418:	74 1c                	je     c0109436 <printnum+0x6a>
c010941a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010941d:	ba 00 00 00 00       	mov    $0x0,%edx
c0109422:	f7 75 e4             	divl   -0x1c(%ebp)
c0109425:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0109428:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010942b:	ba 00 00 00 00       	mov    $0x0,%edx
c0109430:	f7 75 e4             	divl   -0x1c(%ebp)
c0109433:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109436:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0109439:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010943c:	89 d6                	mov    %edx,%esi
c010943e:	89 c3                	mov    %eax,%ebx
c0109440:	89 f0                	mov    %esi,%eax
c0109442:	89 da                	mov    %ebx,%edx
c0109444:	f7 75 e4             	divl   -0x1c(%ebp)
c0109447:	89 d3                	mov    %edx,%ebx
c0109449:	89 c6                	mov    %eax,%esi
c010944b:	89 75 e0             	mov    %esi,-0x20(%ebp)
c010944e:	89 5d dc             	mov    %ebx,-0x24(%ebp)
c0109451:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109454:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0109457:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010945a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010945d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0109460:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0109463:	89 c3                	mov    %eax,%ebx
c0109465:	89 d6                	mov    %edx,%esi
c0109467:	89 5d e8             	mov    %ebx,-0x18(%ebp)
c010946a:	89 75 ec             	mov    %esi,-0x14(%ebp)
c010946d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109470:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0109473:	8b 45 18             	mov    0x18(%ebp),%eax
c0109476:	ba 00 00 00 00       	mov    $0x0,%edx
c010947b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010947e:	77 56                	ja     c01094d6 <printnum+0x10a>
c0109480:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0109483:	72 05                	jb     c010948a <printnum+0xbe>
c0109485:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0109488:	77 4c                	ja     c01094d6 <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
c010948a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010948d:	8d 50 ff             	lea    -0x1(%eax),%edx
c0109490:	8b 45 20             	mov    0x20(%ebp),%eax
c0109493:	89 44 24 18          	mov    %eax,0x18(%esp)
c0109497:	89 54 24 14          	mov    %edx,0x14(%esp)
c010949b:	8b 45 18             	mov    0x18(%ebp),%eax
c010949e:	89 44 24 10          	mov    %eax,0x10(%esp)
c01094a2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01094a5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01094a8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01094ac:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01094b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094b3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01094ba:	89 04 24             	mov    %eax,(%esp)
c01094bd:	e8 0a ff ff ff       	call   c01093cc <printnum>
c01094c2:	eb 1c                	jmp    c01094e0 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01094c4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01094c7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01094cb:	8b 45 20             	mov    0x20(%ebp),%eax
c01094ce:	89 04 24             	mov    %eax,(%esp)
c01094d1:	8b 45 08             	mov    0x8(%ebp),%eax
c01094d4:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01094d6:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01094da:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01094de:	7f e4                	jg     c01094c4 <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01094e0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01094e3:	05 08 c2 10 c0       	add    $0xc010c208,%eax
c01094e8:	0f b6 00             	movzbl (%eax),%eax
c01094eb:	0f be c0             	movsbl %al,%eax
c01094ee:	8b 55 0c             	mov    0xc(%ebp),%edx
c01094f1:	89 54 24 04          	mov    %edx,0x4(%esp)
c01094f5:	89 04 24             	mov    %eax,(%esp)
c01094f8:	8b 45 08             	mov    0x8(%ebp),%eax
c01094fb:	ff d0                	call   *%eax
}
c01094fd:	83 c4 60             	add    $0x60,%esp
c0109500:	5b                   	pop    %ebx
c0109501:	5e                   	pop    %esi
c0109502:	5d                   	pop    %ebp
c0109503:	c3                   	ret    

c0109504 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0109504:	55                   	push   %ebp
c0109505:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109507:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010950b:	7e 14                	jle    c0109521 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010950d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109510:	8b 00                	mov    (%eax),%eax
c0109512:	8d 48 08             	lea    0x8(%eax),%ecx
c0109515:	8b 55 08             	mov    0x8(%ebp),%edx
c0109518:	89 0a                	mov    %ecx,(%edx)
c010951a:	8b 50 04             	mov    0x4(%eax),%edx
c010951d:	8b 00                	mov    (%eax),%eax
c010951f:	eb 30                	jmp    c0109551 <getuint+0x4d>
    }
    else if (lflag) {
c0109521:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109525:	74 16                	je     c010953d <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0109527:	8b 45 08             	mov    0x8(%ebp),%eax
c010952a:	8b 00                	mov    (%eax),%eax
c010952c:	8d 48 04             	lea    0x4(%eax),%ecx
c010952f:	8b 55 08             	mov    0x8(%ebp),%edx
c0109532:	89 0a                	mov    %ecx,(%edx)
c0109534:	8b 00                	mov    (%eax),%eax
c0109536:	ba 00 00 00 00       	mov    $0x0,%edx
c010953b:	eb 14                	jmp    c0109551 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010953d:	8b 45 08             	mov    0x8(%ebp),%eax
c0109540:	8b 00                	mov    (%eax),%eax
c0109542:	8d 48 04             	lea    0x4(%eax),%ecx
c0109545:	8b 55 08             	mov    0x8(%ebp),%edx
c0109548:	89 0a                	mov    %ecx,(%edx)
c010954a:	8b 00                	mov    (%eax),%eax
c010954c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0109551:	5d                   	pop    %ebp
c0109552:	c3                   	ret    

c0109553 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0109553:	55                   	push   %ebp
c0109554:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0109556:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010955a:	7e 14                	jle    c0109570 <getint+0x1d>
        return va_arg(*ap, long long);
c010955c:	8b 45 08             	mov    0x8(%ebp),%eax
c010955f:	8b 00                	mov    (%eax),%eax
c0109561:	8d 48 08             	lea    0x8(%eax),%ecx
c0109564:	8b 55 08             	mov    0x8(%ebp),%edx
c0109567:	89 0a                	mov    %ecx,(%edx)
c0109569:	8b 50 04             	mov    0x4(%eax),%edx
c010956c:	8b 00                	mov    (%eax),%eax
c010956e:	eb 30                	jmp    c01095a0 <getint+0x4d>
    }
    else if (lflag) {
c0109570:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109574:	74 16                	je     c010958c <getint+0x39>
        return va_arg(*ap, long);
c0109576:	8b 45 08             	mov    0x8(%ebp),%eax
c0109579:	8b 00                	mov    (%eax),%eax
c010957b:	8d 48 04             	lea    0x4(%eax),%ecx
c010957e:	8b 55 08             	mov    0x8(%ebp),%edx
c0109581:	89 0a                	mov    %ecx,(%edx)
c0109583:	8b 00                	mov    (%eax),%eax
c0109585:	89 c2                	mov    %eax,%edx
c0109587:	c1 fa 1f             	sar    $0x1f,%edx
c010958a:	eb 14                	jmp    c01095a0 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
c010958c:	8b 45 08             	mov    0x8(%ebp),%eax
c010958f:	8b 00                	mov    (%eax),%eax
c0109591:	8d 48 04             	lea    0x4(%eax),%ecx
c0109594:	8b 55 08             	mov    0x8(%ebp),%edx
c0109597:	89 0a                	mov    %ecx,(%edx)
c0109599:	8b 00                	mov    (%eax),%eax
c010959b:	89 c2                	mov    %eax,%edx
c010959d:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
c01095a0:	5d                   	pop    %ebp
c01095a1:	c3                   	ret    

c01095a2 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01095a2:	55                   	push   %ebp
c01095a3:	89 e5                	mov    %esp,%ebp
c01095a5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01095a8:	8d 55 14             	lea    0x14(%ebp),%edx
c01095ab:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01095ae:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
c01095b0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01095b3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01095b7:	8b 45 10             	mov    0x10(%ebp),%eax
c01095ba:	89 44 24 08          	mov    %eax,0x8(%esp)
c01095be:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095c1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095c5:	8b 45 08             	mov    0x8(%ebp),%eax
c01095c8:	89 04 24             	mov    %eax,(%esp)
c01095cb:	e8 02 00 00 00       	call   c01095d2 <vprintfmt>
    va_end(ap);
}
c01095d0:	c9                   	leave  
c01095d1:	c3                   	ret    

c01095d2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01095d2:	55                   	push   %ebp
c01095d3:	89 e5                	mov    %esp,%ebp
c01095d5:	56                   	push   %esi
c01095d6:	53                   	push   %ebx
c01095d7:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01095da:	eb 17                	jmp    c01095f3 <vprintfmt+0x21>
            if (ch == '\0') {
c01095dc:	85 db                	test   %ebx,%ebx
c01095de:	0f 84 db 03 00 00    	je     c01099bf <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
c01095e4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01095e7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01095eb:	89 1c 24             	mov    %ebx,(%esp)
c01095ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01095f1:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01095f3:	8b 45 10             	mov    0x10(%ebp),%eax
c01095f6:	0f b6 00             	movzbl (%eax),%eax
c01095f9:	0f b6 d8             	movzbl %al,%ebx
c01095fc:	83 fb 25             	cmp    $0x25,%ebx
c01095ff:	0f 95 c0             	setne  %al
c0109602:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0109606:	84 c0                	test   %al,%al
c0109608:	75 d2                	jne    c01095dc <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010960a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010960e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0109615:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109618:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010961b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0109622:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109625:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109628:	eb 04                	jmp    c010962e <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
c010962a:	90                   	nop
c010962b:	eb 01                	jmp    c010962e <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
c010962d:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010962e:	8b 45 10             	mov    0x10(%ebp),%eax
c0109631:	0f b6 00             	movzbl (%eax),%eax
c0109634:	0f b6 d8             	movzbl %al,%ebx
c0109637:	89 d8                	mov    %ebx,%eax
c0109639:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c010963d:	83 e8 23             	sub    $0x23,%eax
c0109640:	83 f8 55             	cmp    $0x55,%eax
c0109643:	0f 87 45 03 00 00    	ja     c010998e <vprintfmt+0x3bc>
c0109649:	8b 04 85 2c c2 10 c0 	mov    -0x3fef3dd4(,%eax,4),%eax
c0109650:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0109652:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0109656:	eb d6                	jmp    c010962e <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0109658:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010965c:	eb d0                	jmp    c010962e <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010965e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0109665:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109668:	89 d0                	mov    %edx,%eax
c010966a:	c1 e0 02             	shl    $0x2,%eax
c010966d:	01 d0                	add    %edx,%eax
c010966f:	01 c0                	add    %eax,%eax
c0109671:	01 d8                	add    %ebx,%eax
c0109673:	83 e8 30             	sub    $0x30,%eax
c0109676:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0109679:	8b 45 10             	mov    0x10(%ebp),%eax
c010967c:	0f b6 00             	movzbl (%eax),%eax
c010967f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0109682:	83 fb 2f             	cmp    $0x2f,%ebx
c0109685:	7e 39                	jle    c01096c0 <vprintfmt+0xee>
c0109687:	83 fb 39             	cmp    $0x39,%ebx
c010968a:	7f 34                	jg     c01096c0 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010968c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c0109690:	eb d3                	jmp    c0109665 <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c0109692:	8b 45 14             	mov    0x14(%ebp),%eax
c0109695:	8d 50 04             	lea    0x4(%eax),%edx
c0109698:	89 55 14             	mov    %edx,0x14(%ebp)
c010969b:	8b 00                	mov    (%eax),%eax
c010969d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01096a0:	eb 1f                	jmp    c01096c1 <vprintfmt+0xef>

        case '.':
            if (width < 0)
c01096a2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01096a6:	79 82                	jns    c010962a <vprintfmt+0x58>
                width = 0;
c01096a8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01096af:	e9 76 ff ff ff       	jmp    c010962a <vprintfmt+0x58>

        case '#':
            altflag = 1;
c01096b4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01096bb:	e9 6e ff ff ff       	jmp    c010962e <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c01096c0:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c01096c1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01096c5:	0f 89 62 ff ff ff    	jns    c010962d <vprintfmt+0x5b>
                width = precision, precision = -1;
c01096cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01096ce:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01096d1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01096d8:	e9 50 ff ff ff       	jmp    c010962d <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01096dd:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01096e1:	e9 48 ff ff ff       	jmp    c010962e <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01096e6:	8b 45 14             	mov    0x14(%ebp),%eax
c01096e9:	8d 50 04             	lea    0x4(%eax),%edx
c01096ec:	89 55 14             	mov    %edx,0x14(%ebp)
c01096ef:	8b 00                	mov    (%eax),%eax
c01096f1:	8b 55 0c             	mov    0xc(%ebp),%edx
c01096f4:	89 54 24 04          	mov    %edx,0x4(%esp)
c01096f8:	89 04 24             	mov    %eax,(%esp)
c01096fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01096fe:	ff d0                	call   *%eax
            break;
c0109700:	e9 b4 02 00 00       	jmp    c01099b9 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0109705:	8b 45 14             	mov    0x14(%ebp),%eax
c0109708:	8d 50 04             	lea    0x4(%eax),%edx
c010970b:	89 55 14             	mov    %edx,0x14(%ebp)
c010970e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0109710:	85 db                	test   %ebx,%ebx
c0109712:	79 02                	jns    c0109716 <vprintfmt+0x144>
                err = -err;
c0109714:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0109716:	83 fb 06             	cmp    $0x6,%ebx
c0109719:	7f 0b                	jg     c0109726 <vprintfmt+0x154>
c010971b:	8b 34 9d ec c1 10 c0 	mov    -0x3fef3e14(,%ebx,4),%esi
c0109722:	85 f6                	test   %esi,%esi
c0109724:	75 23                	jne    c0109749 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
c0109726:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010972a:	c7 44 24 08 19 c2 10 	movl   $0xc010c219,0x8(%esp)
c0109731:	c0 
c0109732:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109735:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109739:	8b 45 08             	mov    0x8(%ebp),%eax
c010973c:	89 04 24             	mov    %eax,(%esp)
c010973f:	e8 5e fe ff ff       	call   c01095a2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0109744:	e9 70 02 00 00       	jmp    c01099b9 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0109749:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010974d:	c7 44 24 08 22 c2 10 	movl   $0xc010c222,0x8(%esp)
c0109754:	c0 
c0109755:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109758:	89 44 24 04          	mov    %eax,0x4(%esp)
c010975c:	8b 45 08             	mov    0x8(%ebp),%eax
c010975f:	89 04 24             	mov    %eax,(%esp)
c0109762:	e8 3b fe ff ff       	call   c01095a2 <printfmt>
            }
            break;
c0109767:	e9 4d 02 00 00       	jmp    c01099b9 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010976c:	8b 45 14             	mov    0x14(%ebp),%eax
c010976f:	8d 50 04             	lea    0x4(%eax),%edx
c0109772:	89 55 14             	mov    %edx,0x14(%ebp)
c0109775:	8b 30                	mov    (%eax),%esi
c0109777:	85 f6                	test   %esi,%esi
c0109779:	75 05                	jne    c0109780 <vprintfmt+0x1ae>
                p = "(null)";
c010977b:	be 25 c2 10 c0       	mov    $0xc010c225,%esi
            }
            if (width > 0 && padc != '-') {
c0109780:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109784:	7e 7c                	jle    c0109802 <vprintfmt+0x230>
c0109786:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010978a:	74 76                	je     c0109802 <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010978c:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010978f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109792:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109796:	89 34 24             	mov    %esi,(%esp)
c0109799:	e8 25 04 00 00       	call   c0109bc3 <strnlen>
c010979e:	89 da                	mov    %ebx,%edx
c01097a0:	29 c2                	sub    %eax,%edx
c01097a2:	89 d0                	mov    %edx,%eax
c01097a4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01097a7:	eb 17                	jmp    c01097c0 <vprintfmt+0x1ee>
                    putch(padc, putdat);
c01097a9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01097ad:	8b 55 0c             	mov    0xc(%ebp),%edx
c01097b0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01097b4:	89 04 24             	mov    %eax,(%esp)
c01097b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01097ba:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01097bc:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01097c0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01097c4:	7f e3                	jg     c01097a9 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01097c6:	eb 3a                	jmp    c0109802 <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
c01097c8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01097cc:	74 1f                	je     c01097ed <vprintfmt+0x21b>
c01097ce:	83 fb 1f             	cmp    $0x1f,%ebx
c01097d1:	7e 05                	jle    c01097d8 <vprintfmt+0x206>
c01097d3:	83 fb 7e             	cmp    $0x7e,%ebx
c01097d6:	7e 15                	jle    c01097ed <vprintfmt+0x21b>
                    putch('?', putdat);
c01097d8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097db:	89 44 24 04          	mov    %eax,0x4(%esp)
c01097df:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01097e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01097e9:	ff d0                	call   *%eax
c01097eb:	eb 0f                	jmp    c01097fc <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
c01097ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01097f0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01097f4:	89 1c 24             	mov    %ebx,(%esp)
c01097f7:	8b 45 08             	mov    0x8(%ebp),%eax
c01097fa:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01097fc:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0109800:	eb 01                	jmp    c0109803 <vprintfmt+0x231>
c0109802:	90                   	nop
c0109803:	0f b6 06             	movzbl (%esi),%eax
c0109806:	0f be d8             	movsbl %al,%ebx
c0109809:	85 db                	test   %ebx,%ebx
c010980b:	0f 95 c0             	setne  %al
c010980e:	83 c6 01             	add    $0x1,%esi
c0109811:	84 c0                	test   %al,%al
c0109813:	74 29                	je     c010983e <vprintfmt+0x26c>
c0109815:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109819:	78 ad                	js     c01097c8 <vprintfmt+0x1f6>
c010981b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010981f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0109823:	79 a3                	jns    c01097c8 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0109825:	eb 17                	jmp    c010983e <vprintfmt+0x26c>
                putch(' ', putdat);
c0109827:	8b 45 0c             	mov    0xc(%ebp),%eax
c010982a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010982e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0109835:	8b 45 08             	mov    0x8(%ebp),%eax
c0109838:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010983a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010983e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109842:	7f e3                	jg     c0109827 <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
c0109844:	e9 70 01 00 00       	jmp    c01099b9 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0109849:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010984c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109850:	8d 45 14             	lea    0x14(%ebp),%eax
c0109853:	89 04 24             	mov    %eax,(%esp)
c0109856:	e8 f8 fc ff ff       	call   c0109553 <getint>
c010985b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010985e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0109861:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109864:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109867:	85 d2                	test   %edx,%edx
c0109869:	79 26                	jns    c0109891 <vprintfmt+0x2bf>
                putch('-', putdat);
c010986b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010986e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109872:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0109879:	8b 45 08             	mov    0x8(%ebp),%eax
c010987c:	ff d0                	call   *%eax
                num = -(long long)num;
c010987e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109881:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109884:	f7 d8                	neg    %eax
c0109886:	83 d2 00             	adc    $0x0,%edx
c0109889:	f7 da                	neg    %edx
c010988b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010988e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c0109891:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c0109898:	e9 a8 00 00 00       	jmp    c0109945 <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c010989d:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01098a0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01098a4:	8d 45 14             	lea    0x14(%ebp),%eax
c01098a7:	89 04 24             	mov    %eax,(%esp)
c01098aa:	e8 55 fc ff ff       	call   c0109504 <getuint>
c01098af:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01098b2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01098b5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01098bc:	e9 84 00 00 00       	jmp    c0109945 <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01098c1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01098c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01098c8:	8d 45 14             	lea    0x14(%ebp),%eax
c01098cb:	89 04 24             	mov    %eax,(%esp)
c01098ce:	e8 31 fc ff ff       	call   c0109504 <getuint>
c01098d3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01098d6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01098d9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01098e0:	eb 63                	jmp    c0109945 <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
c01098e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098e5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01098e9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c01098f0:	8b 45 08             	mov    0x8(%ebp),%eax
c01098f3:	ff d0                	call   *%eax
            putch('x', putdat);
c01098f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01098f8:	89 44 24 04          	mov    %eax,0x4(%esp)
c01098fc:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0109903:	8b 45 08             	mov    0x8(%ebp),%eax
c0109906:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0109908:	8b 45 14             	mov    0x14(%ebp),%eax
c010990b:	8d 50 04             	lea    0x4(%eax),%edx
c010990e:	89 55 14             	mov    %edx,0x14(%ebp)
c0109911:	8b 00                	mov    (%eax),%eax
c0109913:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109916:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010991d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0109924:	eb 1f                	jmp    c0109945 <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0109926:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109929:	89 44 24 04          	mov    %eax,0x4(%esp)
c010992d:	8d 45 14             	lea    0x14(%ebp),%eax
c0109930:	89 04 24             	mov    %eax,(%esp)
c0109933:	e8 cc fb ff ff       	call   c0109504 <getuint>
c0109938:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010993b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010993e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0109945:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0109949:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010994c:	89 54 24 18          	mov    %edx,0x18(%esp)
c0109950:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109953:	89 54 24 14          	mov    %edx,0x14(%esp)
c0109957:	89 44 24 10          	mov    %eax,0x10(%esp)
c010995b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010995e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0109961:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109965:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0109969:	8b 45 0c             	mov    0xc(%ebp),%eax
c010996c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109970:	8b 45 08             	mov    0x8(%ebp),%eax
c0109973:	89 04 24             	mov    %eax,(%esp)
c0109976:	e8 51 fa ff ff       	call   c01093cc <printnum>
            break;
c010997b:	eb 3c                	jmp    c01099b9 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010997d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109980:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109984:	89 1c 24             	mov    %ebx,(%esp)
c0109987:	8b 45 08             	mov    0x8(%ebp),%eax
c010998a:	ff d0                	call   *%eax
            break;
c010998c:	eb 2b                	jmp    c01099b9 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010998e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109991:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109995:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c010999c:	8b 45 08             	mov    0x8(%ebp),%eax
c010999f:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01099a1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01099a5:	eb 04                	jmp    c01099ab <vprintfmt+0x3d9>
c01099a7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01099ab:	8b 45 10             	mov    0x10(%ebp),%eax
c01099ae:	83 e8 01             	sub    $0x1,%eax
c01099b1:	0f b6 00             	movzbl (%eax),%eax
c01099b4:	3c 25                	cmp    $0x25,%al
c01099b6:	75 ef                	jne    c01099a7 <vprintfmt+0x3d5>
                /* do nothing */;
            break;
c01099b8:	90                   	nop
        }
    }
c01099b9:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01099ba:	e9 34 fc ff ff       	jmp    c01095f3 <vprintfmt+0x21>
            if (ch == '\0') {
                return;
c01099bf:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01099c0:	83 c4 40             	add    $0x40,%esp
c01099c3:	5b                   	pop    %ebx
c01099c4:	5e                   	pop    %esi
c01099c5:	5d                   	pop    %ebp
c01099c6:	c3                   	ret    

c01099c7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01099c7:	55                   	push   %ebp
c01099c8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01099ca:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099cd:	8b 40 08             	mov    0x8(%eax),%eax
c01099d0:	8d 50 01             	lea    0x1(%eax),%edx
c01099d3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099d6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01099d9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099dc:	8b 10                	mov    (%eax),%edx
c01099de:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099e1:	8b 40 04             	mov    0x4(%eax),%eax
c01099e4:	39 c2                	cmp    %eax,%edx
c01099e6:	73 12                	jae    c01099fa <sprintputch+0x33>
        *b->buf ++ = ch;
c01099e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099eb:	8b 00                	mov    (%eax),%eax
c01099ed:	8b 55 08             	mov    0x8(%ebp),%edx
c01099f0:	88 10                	mov    %dl,(%eax)
c01099f2:	8d 50 01             	lea    0x1(%eax),%edx
c01099f5:	8b 45 0c             	mov    0xc(%ebp),%eax
c01099f8:	89 10                	mov    %edx,(%eax)
    }
}
c01099fa:	5d                   	pop    %ebp
c01099fb:	c3                   	ret    

c01099fc <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c01099fc:	55                   	push   %ebp
c01099fd:	89 e5                	mov    %esp,%ebp
c01099ff:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0109a02:	8d 55 14             	lea    0x14(%ebp),%edx
c0109a05:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0109a08:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
c0109a0a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a0d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109a11:	8b 45 10             	mov    0x10(%ebp),%eax
c0109a14:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109a18:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a1b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a1f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a22:	89 04 24             	mov    %eax,(%esp)
c0109a25:	e8 08 00 00 00       	call   c0109a32 <vsnprintf>
c0109a2a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c0109a2d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109a30:	c9                   	leave  
c0109a31:	c3                   	ret    

c0109a32 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0109a32:	55                   	push   %ebp
c0109a33:	89 e5                	mov    %esp,%ebp
c0109a35:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0109a38:	8b 45 08             	mov    0x8(%ebp),%eax
c0109a3b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109a3e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109a41:	83 e8 01             	sub    $0x1,%eax
c0109a44:	03 45 08             	add    0x8(%ebp),%eax
c0109a47:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109a4a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0109a51:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0109a55:	74 0a                	je     c0109a61 <vsnprintf+0x2f>
c0109a57:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109a5a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109a5d:	39 c2                	cmp    %eax,%edx
c0109a5f:	76 07                	jbe    c0109a68 <vsnprintf+0x36>
        return -E_INVAL;
c0109a61:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0109a66:	eb 2a                	jmp    c0109a92 <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0109a68:	8b 45 14             	mov    0x14(%ebp),%eax
c0109a6b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0109a6f:	8b 45 10             	mov    0x10(%ebp),%eax
c0109a72:	89 44 24 08          	mov    %eax,0x8(%esp)
c0109a76:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0109a79:	89 44 24 04          	mov    %eax,0x4(%esp)
c0109a7d:	c7 04 24 c7 99 10 c0 	movl   $0xc01099c7,(%esp)
c0109a84:	e8 49 fb ff ff       	call   c01095d2 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0109a89:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109a8c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c0109a8f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0109a92:	c9                   	leave  
c0109a93:	c3                   	ret    

c0109a94 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c0109a94:	55                   	push   %ebp
c0109a95:	89 e5                	mov    %esp,%ebp
c0109a97:	57                   	push   %edi
c0109a98:	56                   	push   %esi
c0109a99:	53                   	push   %ebx
c0109a9a:	83 ec 34             	sub    $0x34,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c0109a9d:	a1 88 5a 12 c0       	mov    0xc0125a88,%eax
c0109aa2:	8b 15 8c 5a 12 c0    	mov    0xc0125a8c,%edx
c0109aa8:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c0109aae:	6b c8 05             	imul   $0x5,%eax,%ecx
c0109ab1:	01 cf                	add    %ecx,%edi
c0109ab3:	b9 6d e6 ec de       	mov    $0xdeece66d,%ecx
c0109ab8:	f7 e1                	mul    %ecx
c0109aba:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
c0109abd:	89 ca                	mov    %ecx,%edx
c0109abf:	83 c0 0b             	add    $0xb,%eax
c0109ac2:	83 d2 00             	adc    $0x0,%edx
c0109ac5:	89 c3                	mov    %eax,%ebx
c0109ac7:	80 e7 ff             	and    $0xff,%bh
c0109aca:	0f b7 f2             	movzwl %dx,%esi
c0109acd:	89 1d 88 5a 12 c0    	mov    %ebx,0xc0125a88
c0109ad3:	89 35 8c 5a 12 c0    	mov    %esi,0xc0125a8c
    unsigned long long result = (next >> 12);
c0109ad9:	a1 88 5a 12 c0       	mov    0xc0125a88,%eax
c0109ade:	8b 15 8c 5a 12 c0    	mov    0xc0125a8c,%edx
c0109ae4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0109ae8:	c1 ea 0c             	shr    $0xc,%edx
c0109aeb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109aee:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0109af1:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0109af8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109afb:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109afe:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0109b01:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0109b04:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0109b07:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0109b0a:	89 d3                	mov    %edx,%ebx
c0109b0c:	89 c6                	mov    %eax,%esi
c0109b0e:	89 75 d8             	mov    %esi,-0x28(%ebp)
c0109b11:	89 5d e8             	mov    %ebx,-0x18(%ebp)
c0109b14:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b17:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109b1a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0109b1e:	74 1c                	je     c0109b3c <rand+0xa8>
c0109b20:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b23:	ba 00 00 00 00       	mov    $0x0,%edx
c0109b28:	f7 75 dc             	divl   -0x24(%ebp)
c0109b2b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c0109b2e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109b31:	ba 00 00 00 00       	mov    $0x0,%edx
c0109b36:	f7 75 dc             	divl   -0x24(%ebp)
c0109b39:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109b3c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0109b3f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109b42:	89 d6                	mov    %edx,%esi
c0109b44:	89 c3                	mov    %eax,%ebx
c0109b46:	89 f0                	mov    %esi,%eax
c0109b48:	89 da                	mov    %ebx,%edx
c0109b4a:	f7 75 dc             	divl   -0x24(%ebp)
c0109b4d:	89 d3                	mov    %edx,%ebx
c0109b4f:	89 c6                	mov    %eax,%esi
c0109b51:	89 75 d8             	mov    %esi,-0x28(%ebp)
c0109b54:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
c0109b57:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0109b5a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0109b5d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0109b60:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0109b63:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0109b66:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0109b69:	89 c3                	mov    %eax,%ebx
c0109b6b:	89 d6                	mov    %edx,%esi
c0109b6d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
c0109b70:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0109b73:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0109b76:	83 c4 34             	add    $0x34,%esp
c0109b79:	5b                   	pop    %ebx
c0109b7a:	5e                   	pop    %esi
c0109b7b:	5f                   	pop    %edi
c0109b7c:	5d                   	pop    %ebp
c0109b7d:	c3                   	ret    

c0109b7e <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c0109b7e:	55                   	push   %ebp
c0109b7f:	89 e5                	mov    %esp,%ebp
    next = seed;
c0109b81:	8b 45 08             	mov    0x8(%ebp),%eax
c0109b84:	ba 00 00 00 00       	mov    $0x0,%edx
c0109b89:	a3 88 5a 12 c0       	mov    %eax,0xc0125a88
c0109b8e:	89 15 8c 5a 12 c0    	mov    %edx,0xc0125a8c
}
c0109b94:	5d                   	pop    %ebp
c0109b95:	c3                   	ret    
	...

c0109b98 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c0109b98:	55                   	push   %ebp
c0109b99:	89 e5                	mov    %esp,%ebp
c0109b9b:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109b9e:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c0109ba5:	eb 04                	jmp    c0109bab <strlen+0x13>
        cnt ++;
c0109ba7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c0109bab:	8b 45 08             	mov    0x8(%ebp),%eax
c0109bae:	0f b6 00             	movzbl (%eax),%eax
c0109bb1:	84 c0                	test   %al,%al
c0109bb3:	0f 95 c0             	setne  %al
c0109bb6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109bba:	84 c0                	test   %al,%al
c0109bbc:	75 e9                	jne    c0109ba7 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c0109bbe:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109bc1:	c9                   	leave  
c0109bc2:	c3                   	ret    

c0109bc3 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c0109bc3:	55                   	push   %ebp
c0109bc4:	89 e5                	mov    %esp,%ebp
c0109bc6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c0109bc9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c0109bd0:	eb 04                	jmp    c0109bd6 <strnlen+0x13>
        cnt ++;
c0109bd2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c0109bd6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109bd9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0109bdc:	73 13                	jae    c0109bf1 <strnlen+0x2e>
c0109bde:	8b 45 08             	mov    0x8(%ebp),%eax
c0109be1:	0f b6 00             	movzbl (%eax),%eax
c0109be4:	84 c0                	test   %al,%al
c0109be6:	0f 95 c0             	setne  %al
c0109be9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109bed:	84 c0                	test   %al,%al
c0109bef:	75 e1                	jne    c0109bd2 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0109bf1:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0109bf4:	c9                   	leave  
c0109bf5:	c3                   	ret    

c0109bf6 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0109bf6:	55                   	push   %ebp
c0109bf7:	89 e5                	mov    %esp,%ebp
c0109bf9:	57                   	push   %edi
c0109bfa:	56                   	push   %esi
c0109bfb:	53                   	push   %ebx
c0109bfc:	83 ec 24             	sub    $0x24,%esp
c0109bff:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c02:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c05:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c08:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0109c0b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0109c0e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109c11:	89 d6                	mov    %edx,%esi
c0109c13:	89 c3                	mov    %eax,%ebx
c0109c15:	89 df                	mov    %ebx,%edi
c0109c17:	ac                   	lods   %ds:(%esi),%al
c0109c18:	aa                   	stos   %al,%es:(%edi)
c0109c19:	84 c0                	test   %al,%al
c0109c1b:	75 fa                	jne    c0109c17 <strcpy+0x21>
c0109c1d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109c20:	89 fb                	mov    %edi,%ebx
c0109c22:	89 75 e8             	mov    %esi,-0x18(%ebp)
c0109c25:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
c0109c28:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109c2b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0109c2e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0109c31:	83 c4 24             	add    $0x24,%esp
c0109c34:	5b                   	pop    %ebx
c0109c35:	5e                   	pop    %esi
c0109c36:	5f                   	pop    %edi
c0109c37:	5d                   	pop    %ebp
c0109c38:	c3                   	ret    

c0109c39 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0109c39:	55                   	push   %ebp
c0109c3a:	89 e5                	mov    %esp,%ebp
c0109c3c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0109c3f:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c42:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0109c45:	eb 21                	jmp    c0109c68 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0109c47:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c4a:	0f b6 10             	movzbl (%eax),%edx
c0109c4d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109c50:	88 10                	mov    %dl,(%eax)
c0109c52:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0109c55:	0f b6 00             	movzbl (%eax),%eax
c0109c58:	84 c0                	test   %al,%al
c0109c5a:	74 04                	je     c0109c60 <strncpy+0x27>
            src ++;
c0109c5c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0109c60:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0109c64:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0109c68:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109c6c:	75 d9                	jne    c0109c47 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0109c6e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109c71:	c9                   	leave  
c0109c72:	c3                   	ret    

c0109c73 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0109c73:	55                   	push   %ebp
c0109c74:	89 e5                	mov    %esp,%ebp
c0109c76:	57                   	push   %edi
c0109c77:	56                   	push   %esi
c0109c78:	53                   	push   %ebx
c0109c79:	83 ec 24             	sub    $0x24,%esp
c0109c7c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109c7f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109c82:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109c85:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0109c88:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109c8b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109c8e:	89 d6                	mov    %edx,%esi
c0109c90:	89 c3                	mov    %eax,%ebx
c0109c92:	89 df                	mov    %ebx,%edi
c0109c94:	ac                   	lods   %ds:(%esi),%al
c0109c95:	ae                   	scas   %es:(%edi),%al
c0109c96:	75 08                	jne    c0109ca0 <strcmp+0x2d>
c0109c98:	84 c0                	test   %al,%al
c0109c9a:	75 f8                	jne    c0109c94 <strcmp+0x21>
c0109c9c:	31 c0                	xor    %eax,%eax
c0109c9e:	eb 04                	jmp    c0109ca4 <strcmp+0x31>
c0109ca0:	19 c0                	sbb    %eax,%eax
c0109ca2:	0c 01                	or     $0x1,%al
c0109ca4:	89 fb                	mov    %edi,%ebx
c0109ca6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0109ca9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0109cac:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0109caf:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0109cb2:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0109cb5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0109cb8:	83 c4 24             	add    $0x24,%esp
c0109cbb:	5b                   	pop    %ebx
c0109cbc:	5e                   	pop    %esi
c0109cbd:	5f                   	pop    %edi
c0109cbe:	5d                   	pop    %ebp
c0109cbf:	c3                   	ret    

c0109cc0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0109cc0:	55                   	push   %ebp
c0109cc1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109cc3:	eb 0c                	jmp    c0109cd1 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0109cc5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0109cc9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109ccd:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0109cd1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109cd5:	74 1a                	je     c0109cf1 <strncmp+0x31>
c0109cd7:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cda:	0f b6 00             	movzbl (%eax),%eax
c0109cdd:	84 c0                	test   %al,%al
c0109cdf:	74 10                	je     c0109cf1 <strncmp+0x31>
c0109ce1:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ce4:	0f b6 10             	movzbl (%eax),%edx
c0109ce7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109cea:	0f b6 00             	movzbl (%eax),%eax
c0109ced:	38 c2                	cmp    %al,%dl
c0109cef:	74 d4                	je     c0109cc5 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0109cf1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109cf5:	74 1a                	je     c0109d11 <strncmp+0x51>
c0109cf7:	8b 45 08             	mov    0x8(%ebp),%eax
c0109cfa:	0f b6 00             	movzbl (%eax),%eax
c0109cfd:	0f b6 d0             	movzbl %al,%edx
c0109d00:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d03:	0f b6 00             	movzbl (%eax),%eax
c0109d06:	0f b6 c0             	movzbl %al,%eax
c0109d09:	89 d1                	mov    %edx,%ecx
c0109d0b:	29 c1                	sub    %eax,%ecx
c0109d0d:	89 c8                	mov    %ecx,%eax
c0109d0f:	eb 05                	jmp    c0109d16 <strncmp+0x56>
c0109d11:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109d16:	5d                   	pop    %ebp
c0109d17:	c3                   	ret    

c0109d18 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0109d18:	55                   	push   %ebp
c0109d19:	89 e5                	mov    %esp,%ebp
c0109d1b:	83 ec 04             	sub    $0x4,%esp
c0109d1e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d21:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109d24:	eb 14                	jmp    c0109d3a <strchr+0x22>
        if (*s == c) {
c0109d26:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d29:	0f b6 00             	movzbl (%eax),%eax
c0109d2c:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109d2f:	75 05                	jne    c0109d36 <strchr+0x1e>
            return (char *)s;
c0109d31:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d34:	eb 13                	jmp    c0109d49 <strchr+0x31>
        }
        s ++;
c0109d36:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0109d3a:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d3d:	0f b6 00             	movzbl (%eax),%eax
c0109d40:	84 c0                	test   %al,%al
c0109d42:	75 e2                	jne    c0109d26 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0109d44:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0109d49:	c9                   	leave  
c0109d4a:	c3                   	ret    

c0109d4b <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0109d4b:	55                   	push   %ebp
c0109d4c:	89 e5                	mov    %esp,%ebp
c0109d4e:	83 ec 04             	sub    $0x4,%esp
c0109d51:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109d54:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0109d57:	eb 0f                	jmp    c0109d68 <strfind+0x1d>
        if (*s == c) {
c0109d59:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d5c:	0f b6 00             	movzbl (%eax),%eax
c0109d5f:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0109d62:	74 10                	je     c0109d74 <strfind+0x29>
            break;
        }
        s ++;
c0109d64:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0109d68:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d6b:	0f b6 00             	movzbl (%eax),%eax
c0109d6e:	84 c0                	test   %al,%al
c0109d70:	75 e7                	jne    c0109d59 <strfind+0xe>
c0109d72:	eb 01                	jmp    c0109d75 <strfind+0x2a>
        if (*s == c) {
            break;
c0109d74:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0109d75:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0109d78:	c9                   	leave  
c0109d79:	c3                   	ret    

c0109d7a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0109d7a:	55                   	push   %ebp
c0109d7b:	89 e5                	mov    %esp,%ebp
c0109d7d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0109d80:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0109d87:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109d8e:	eb 04                	jmp    c0109d94 <strtol+0x1a>
        s ++;
c0109d90:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0109d94:	8b 45 08             	mov    0x8(%ebp),%eax
c0109d97:	0f b6 00             	movzbl (%eax),%eax
c0109d9a:	3c 20                	cmp    $0x20,%al
c0109d9c:	74 f2                	je     c0109d90 <strtol+0x16>
c0109d9e:	8b 45 08             	mov    0x8(%ebp),%eax
c0109da1:	0f b6 00             	movzbl (%eax),%eax
c0109da4:	3c 09                	cmp    $0x9,%al
c0109da6:	74 e8                	je     c0109d90 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0109da8:	8b 45 08             	mov    0x8(%ebp),%eax
c0109dab:	0f b6 00             	movzbl (%eax),%eax
c0109dae:	3c 2b                	cmp    $0x2b,%al
c0109db0:	75 06                	jne    c0109db8 <strtol+0x3e>
        s ++;
c0109db2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109db6:	eb 15                	jmp    c0109dcd <strtol+0x53>
    }
    else if (*s == '-') {
c0109db8:	8b 45 08             	mov    0x8(%ebp),%eax
c0109dbb:	0f b6 00             	movzbl (%eax),%eax
c0109dbe:	3c 2d                	cmp    $0x2d,%al
c0109dc0:	75 0b                	jne    c0109dcd <strtol+0x53>
        s ++, neg = 1;
c0109dc2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109dc6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0109dcd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109dd1:	74 06                	je     c0109dd9 <strtol+0x5f>
c0109dd3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0109dd7:	75 24                	jne    c0109dfd <strtol+0x83>
c0109dd9:	8b 45 08             	mov    0x8(%ebp),%eax
c0109ddc:	0f b6 00             	movzbl (%eax),%eax
c0109ddf:	3c 30                	cmp    $0x30,%al
c0109de1:	75 1a                	jne    c0109dfd <strtol+0x83>
c0109de3:	8b 45 08             	mov    0x8(%ebp),%eax
c0109de6:	83 c0 01             	add    $0x1,%eax
c0109de9:	0f b6 00             	movzbl (%eax),%eax
c0109dec:	3c 78                	cmp    $0x78,%al
c0109dee:	75 0d                	jne    c0109dfd <strtol+0x83>
        s += 2, base = 16;
c0109df0:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0109df4:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0109dfb:	eb 2a                	jmp    c0109e27 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0109dfd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109e01:	75 17                	jne    c0109e1a <strtol+0xa0>
c0109e03:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e06:	0f b6 00             	movzbl (%eax),%eax
c0109e09:	3c 30                	cmp    $0x30,%al
c0109e0b:	75 0d                	jne    c0109e1a <strtol+0xa0>
        s ++, base = 8;
c0109e0d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109e11:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0109e18:	eb 0d                	jmp    c0109e27 <strtol+0xad>
    }
    else if (base == 0) {
c0109e1a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0109e1e:	75 07                	jne    c0109e27 <strtol+0xad>
        base = 10;
c0109e20:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0109e27:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e2a:	0f b6 00             	movzbl (%eax),%eax
c0109e2d:	3c 2f                	cmp    $0x2f,%al
c0109e2f:	7e 1b                	jle    c0109e4c <strtol+0xd2>
c0109e31:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e34:	0f b6 00             	movzbl (%eax),%eax
c0109e37:	3c 39                	cmp    $0x39,%al
c0109e39:	7f 11                	jg     c0109e4c <strtol+0xd2>
            dig = *s - '0';
c0109e3b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e3e:	0f b6 00             	movzbl (%eax),%eax
c0109e41:	0f be c0             	movsbl %al,%eax
c0109e44:	83 e8 30             	sub    $0x30,%eax
c0109e47:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109e4a:	eb 48                	jmp    c0109e94 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0109e4c:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e4f:	0f b6 00             	movzbl (%eax),%eax
c0109e52:	3c 60                	cmp    $0x60,%al
c0109e54:	7e 1b                	jle    c0109e71 <strtol+0xf7>
c0109e56:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e59:	0f b6 00             	movzbl (%eax),%eax
c0109e5c:	3c 7a                	cmp    $0x7a,%al
c0109e5e:	7f 11                	jg     c0109e71 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0109e60:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e63:	0f b6 00             	movzbl (%eax),%eax
c0109e66:	0f be c0             	movsbl %al,%eax
c0109e69:	83 e8 57             	sub    $0x57,%eax
c0109e6c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0109e6f:	eb 23                	jmp    c0109e94 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0109e71:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e74:	0f b6 00             	movzbl (%eax),%eax
c0109e77:	3c 40                	cmp    $0x40,%al
c0109e79:	7e 38                	jle    c0109eb3 <strtol+0x139>
c0109e7b:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e7e:	0f b6 00             	movzbl (%eax),%eax
c0109e81:	3c 5a                	cmp    $0x5a,%al
c0109e83:	7f 2e                	jg     c0109eb3 <strtol+0x139>
            dig = *s - 'A' + 10;
c0109e85:	8b 45 08             	mov    0x8(%ebp),%eax
c0109e88:	0f b6 00             	movzbl (%eax),%eax
c0109e8b:	0f be c0             	movsbl %al,%eax
c0109e8e:	83 e8 37             	sub    $0x37,%eax
c0109e91:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0109e94:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0109e97:	3b 45 10             	cmp    0x10(%ebp),%eax
c0109e9a:	7d 16                	jge    c0109eb2 <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
c0109e9c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0109ea0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109ea3:	0f af 45 10          	imul   0x10(%ebp),%eax
c0109ea7:	03 45 f4             	add    -0xc(%ebp),%eax
c0109eaa:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0109ead:	e9 75 ff ff ff       	jmp    c0109e27 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0109eb2:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0109eb3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0109eb7:	74 08                	je     c0109ec1 <strtol+0x147>
        *endptr = (char *) s;
c0109eb9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109ebc:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ebf:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0109ec1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0109ec5:	74 07                	je     c0109ece <strtol+0x154>
c0109ec7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0109eca:	f7 d8                	neg    %eax
c0109ecc:	eb 03                	jmp    c0109ed1 <strtol+0x157>
c0109ece:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0109ed1:	c9                   	leave  
c0109ed2:	c3                   	ret    

c0109ed3 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0109ed3:	55                   	push   %ebp
c0109ed4:	89 e5                	mov    %esp,%ebp
c0109ed6:	57                   	push   %edi
c0109ed7:	56                   	push   %esi
c0109ed8:	53                   	push   %ebx
c0109ed9:	83 ec 24             	sub    $0x24,%esp
c0109edc:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109edf:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0109ee2:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
c0109ee6:	8b 55 08             	mov    0x8(%ebp),%edx
c0109ee9:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0109eec:	88 45 ef             	mov    %al,-0x11(%ebp)
c0109eef:	8b 45 10             	mov    0x10(%ebp),%eax
c0109ef2:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0109ef5:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0109ef8:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0109efc:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109eff:	89 ce                	mov    %ecx,%esi
c0109f01:	89 d3                	mov    %edx,%ebx
c0109f03:	89 f1                	mov    %esi,%ecx
c0109f05:	89 df                	mov    %ebx,%edi
c0109f07:	f3 aa                	rep stos %al,%es:(%edi)
c0109f09:	89 fb                	mov    %edi,%ebx
c0109f0b:	89 ce                	mov    %ecx,%esi
c0109f0d:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0109f10:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0109f13:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0109f16:	83 c4 24             	add    $0x24,%esp
c0109f19:	5b                   	pop    %ebx
c0109f1a:	5e                   	pop    %esi
c0109f1b:	5f                   	pop    %edi
c0109f1c:	5d                   	pop    %ebp
c0109f1d:	c3                   	ret    

c0109f1e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0109f1e:	55                   	push   %ebp
c0109f1f:	89 e5                	mov    %esp,%ebp
c0109f21:	57                   	push   %edi
c0109f22:	56                   	push   %esi
c0109f23:	53                   	push   %ebx
c0109f24:	83 ec 38             	sub    $0x38,%esp
c0109f27:	8b 45 08             	mov    0x8(%ebp),%eax
c0109f2a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109f2d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109f30:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109f33:	8b 45 10             	mov    0x10(%ebp),%eax
c0109f36:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0109f39:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f3c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0109f3f:	73 4e                	jae    c0109f8f <memmove+0x71>
c0109f41:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0109f44:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0109f47:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109f4a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0109f4d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109f50:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109f53:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0109f56:	89 c1                	mov    %eax,%ecx
c0109f58:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109f5b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0109f5e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0109f61:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0109f64:	89 d7                	mov    %edx,%edi
c0109f66:	89 c3                	mov    %eax,%ebx
c0109f68:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0109f6b:	89 de                	mov    %ebx,%esi
c0109f6d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0109f6f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0109f72:	83 e1 03             	and    $0x3,%ecx
c0109f75:	74 02                	je     c0109f79 <memmove+0x5b>
c0109f77:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109f79:	89 f3                	mov    %esi,%ebx
c0109f7b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0109f7e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0109f81:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0109f84:	89 7d d4             	mov    %edi,-0x2c(%ebp)
c0109f87:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0109f8a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0109f8d:	eb 3b                	jmp    c0109fca <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0109f8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109f92:	83 e8 01             	sub    $0x1,%eax
c0109f95:	89 c2                	mov    %eax,%edx
c0109f97:	03 55 ec             	add    -0x14(%ebp),%edx
c0109f9a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109f9d:	83 e8 01             	sub    $0x1,%eax
c0109fa0:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0109fa3:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0109fa6:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c0109fa9:	89 d6                	mov    %edx,%esi
c0109fab:	89 c3                	mov    %eax,%ebx
c0109fad:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0109fb0:	89 df                	mov    %ebx,%edi
c0109fb2:	fd                   	std    
c0109fb3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0109fb5:	fc                   	cld    
c0109fb6:	89 fb                	mov    %edi,%ebx
c0109fb8:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c0109fbb:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0109fbe:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0109fc1:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0109fc4:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0109fc7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0109fca:	83 c4 38             	add    $0x38,%esp
c0109fcd:	5b                   	pop    %ebx
c0109fce:	5e                   	pop    %esi
c0109fcf:	5f                   	pop    %edi
c0109fd0:	5d                   	pop    %ebp
c0109fd1:	c3                   	ret    

c0109fd2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0109fd2:	55                   	push   %ebp
c0109fd3:	89 e5                	mov    %esp,%ebp
c0109fd5:	57                   	push   %edi
c0109fd6:	56                   	push   %esi
c0109fd7:	53                   	push   %ebx
c0109fd8:	83 ec 24             	sub    $0x24,%esp
c0109fdb:	8b 45 08             	mov    0x8(%ebp),%eax
c0109fde:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0109fe1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0109fe4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0109fe7:	8b 45 10             	mov    0x10(%ebp),%eax
c0109fea:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0109fed:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0109ff0:	89 c1                	mov    %eax,%ecx
c0109ff2:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0109ff5:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0109ff8:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0109ffb:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c0109ffe:	89 d7                	mov    %edx,%edi
c010a000:	89 c3                	mov    %eax,%ebx
c010a002:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010a005:	89 de                	mov    %ebx,%esi
c010a007:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c010a009:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c010a00c:	83 e1 03             	and    $0x3,%ecx
c010a00f:	74 02                	je     c010a013 <memcpy+0x41>
c010a011:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c010a013:	89 f3                	mov    %esi,%ebx
c010a015:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c010a018:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c010a01b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
c010a01e:	89 7d e0             	mov    %edi,-0x20(%ebp)
c010a021:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c010a024:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c010a027:	83 c4 24             	add    $0x24,%esp
c010a02a:	5b                   	pop    %ebx
c010a02b:	5e                   	pop    %esi
c010a02c:	5f                   	pop    %edi
c010a02d:	5d                   	pop    %ebp
c010a02e:	c3                   	ret    

c010a02f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c010a02f:	55                   	push   %ebp
c010a030:	89 e5                	mov    %esp,%ebp
c010a032:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c010a035:	8b 45 08             	mov    0x8(%ebp),%eax
c010a038:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c010a03b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010a03e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c010a041:	eb 32                	jmp    c010a075 <memcmp+0x46>
        if (*s1 != *s2) {
c010a043:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010a046:	0f b6 10             	movzbl (%eax),%edx
c010a049:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010a04c:	0f b6 00             	movzbl (%eax),%eax
c010a04f:	38 c2                	cmp    %al,%dl
c010a051:	74 1a                	je     c010a06d <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c010a053:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010a056:	0f b6 00             	movzbl (%eax),%eax
c010a059:	0f b6 d0             	movzbl %al,%edx
c010a05c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c010a05f:	0f b6 00             	movzbl (%eax),%eax
c010a062:	0f b6 c0             	movzbl %al,%eax
c010a065:	89 d1                	mov    %edx,%ecx
c010a067:	29 c1                	sub    %eax,%ecx
c010a069:	89 c8                	mov    %ecx,%eax
c010a06b:	eb 1c                	jmp    c010a089 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
c010a06d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c010a071:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c010a075:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c010a079:	0f 95 c0             	setne  %al
c010a07c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c010a080:	84 c0                	test   %al,%al
c010a082:	75 bf                	jne    c010a043 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c010a084:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010a089:	c9                   	leave  
c010a08a:	c3                   	ret    
