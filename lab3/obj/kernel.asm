
bin/kernel:     file format elf32-i386


Disassembly of section .text:

c0100000 <kern_entry>:
.text
.globl kern_entry
kern_entry:
    # reload temperate gdt (second time) to remap all physical memory
    # virtual_addr 0~4G=linear_addr&physical_addr -KERNBASE~4G-KERNBASE 
    lgdt REALLOC(__gdtdesc)
c0100000:	0f 01 15 18 00 12 00 	lgdtl  0x120018
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
c010001e:	bc 00 00 12 c0       	mov    $0xc0120000,%esp
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
c0100032:	ba b0 1b 12 c0       	mov    $0xc0121bb0,%edx
c0100037:	b8 68 0a 12 c0       	mov    $0xc0120a68,%eax
c010003c:	89 d1                	mov    %edx,%ecx
c010003e:	29 c1                	sub    %eax,%ecx
c0100040:	89 c8                	mov    %ecx,%eax
c0100042:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100046:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010004d:	00 
c010004e:	c7 04 24 68 0a 12 c0 	movl   $0xc0120a68,(%esp)
c0100055:	e8 89 8c 00 00       	call   c0108ce3 <memset>

    cons_init();                // init the console
c010005a:	e8 0d 16 00 00       	call   c010166c <cons_init>

    const char *message = "(THU.CST) os is loading ...";
c010005f:	c7 45 f4 a0 8e 10 c0 	movl   $0xc0108ea0,-0xc(%ebp)
    cprintf("%s\n\n", message);
c0100066:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100069:	89 44 24 04          	mov    %eax,0x4(%esp)
c010006d:	c7 04 24 bc 8e 10 c0 	movl   $0xc0108ebc,(%esp)
c0100074:	e8 de 02 00 00       	call   c0100357 <cprintf>

    print_kerninfo();
c0100079:	e8 e8 07 00 00       	call   c0100866 <print_kerninfo>

    grade_backtrace();
c010007e:	e8 95 00 00 00       	call   c0100118 <grade_backtrace>

    pmm_init();                 // init physical memory management
c0100083:	e8 51 4d 00 00       	call   c0104dd9 <pmm_init>

    pic_init();                 // init interrupt controller
c0100088:	e8 ec 1f 00 00       	call   c0102079 <pic_init>
    idt_init();                 // init interrupt descriptor table
c010008d:	e8 64 21 00 00       	call   c01021f6 <idt_init>

    vmm_init();                 // init virtual memory management
c0100092:	e8 fa 75 00 00       	call   c0107691 <vmm_init>

    ide_init();                 // init ide devices
c0100097:	e8 0f 17 00 00       	call   c01017ab <ide_init>
    swap_init();                // init swap
c010009c:	e8 06 61 00 00       	call   c01061a7 <swap_init>

    clock_init();               // init clock interrupt
c01000a1:	e8 d6 0c 00 00       	call   c0100d7c <clock_init>
    intr_enable();              // enable irq interrupt
c01000a6:	e8 35 1f 00 00       	call   c0101fe0 <intr_enable>
    //LAB1: CAHLLENGE 1 If you try to do it, uncomment lab1_switch_test()
    // user/kernel mode switch test
    //lab1_switch_test();

    /* do nothing */
    while (1);
c01000ab:	eb fe                	jmp    c01000ab <kern_init+0x7f>

c01000ad <grade_backtrace2>:
}

void __attribute__((noinline))
grade_backtrace2(int arg0, int arg1, int arg2, int arg3) {
c01000ad:	55                   	push   %ebp
c01000ae:	89 e5                	mov    %esp,%ebp
c01000b0:	83 ec 18             	sub    $0x18,%esp
    mon_backtrace(0, NULL, NULL);
c01000b3:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01000ba:	00 
c01000bb:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01000c2:	00 
c01000c3:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c01000ca:	e8 d7 0b 00 00       	call   c0100ca6 <mon_backtrace>
}
c01000cf:	c9                   	leave  
c01000d0:	c3                   	ret    

c01000d1 <grade_backtrace1>:

void __attribute__((noinline))
grade_backtrace1(int arg0, int arg1) {
c01000d1:	55                   	push   %ebp
c01000d2:	89 e5                	mov    %esp,%ebp
c01000d4:	53                   	push   %ebx
c01000d5:	83 ec 14             	sub    $0x14,%esp
    grade_backtrace2(arg0, (int)&arg0, arg1, (int)&arg1);
c01000d8:	8d 5d 0c             	lea    0xc(%ebp),%ebx
c01000db:	8b 4d 0c             	mov    0xc(%ebp),%ecx
c01000de:	8d 55 08             	lea    0x8(%ebp),%edx
c01000e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01000e4:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c01000e8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01000ec:	89 54 24 04          	mov    %edx,0x4(%esp)
c01000f0:	89 04 24             	mov    %eax,(%esp)
c01000f3:	e8 b5 ff ff ff       	call   c01000ad <grade_backtrace2>
}
c01000f8:	83 c4 14             	add    $0x14,%esp
c01000fb:	5b                   	pop    %ebx
c01000fc:	5d                   	pop    %ebp
c01000fd:	c3                   	ret    

c01000fe <grade_backtrace0>:

void __attribute__((noinline))
grade_backtrace0(int arg0, int arg1, int arg2) {
c01000fe:	55                   	push   %ebp
c01000ff:	89 e5                	mov    %esp,%ebp
c0100101:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace1(arg0, arg2);
c0100104:	8b 45 10             	mov    0x10(%ebp),%eax
c0100107:	89 44 24 04          	mov    %eax,0x4(%esp)
c010010b:	8b 45 08             	mov    0x8(%ebp),%eax
c010010e:	89 04 24             	mov    %eax,(%esp)
c0100111:	e8 bb ff ff ff       	call   c01000d1 <grade_backtrace1>
}
c0100116:	c9                   	leave  
c0100117:	c3                   	ret    

c0100118 <grade_backtrace>:

void
grade_backtrace(void) {
c0100118:	55                   	push   %ebp
c0100119:	89 e5                	mov    %esp,%ebp
c010011b:	83 ec 18             	sub    $0x18,%esp
    grade_backtrace0(0, (int)kern_init, 0xffff0000);
c010011e:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c0100123:	c7 44 24 08 00 00 ff 	movl   $0xffff0000,0x8(%esp)
c010012a:	ff 
c010012b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010012f:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100136:	e8 c3 ff ff ff       	call   c01000fe <grade_backtrace0>
}
c010013b:	c9                   	leave  
c010013c:	c3                   	ret    

c010013d <lab1_print_cur_status>:

static void
lab1_print_cur_status(void) {
c010013d:	55                   	push   %ebp
c010013e:	89 e5                	mov    %esp,%ebp
c0100140:	83 ec 28             	sub    $0x28,%esp
    static int round = 0;
    uint16_t reg1, reg2, reg3, reg4;
    asm volatile (
c0100143:	8c 4d f6             	mov    %cs,-0xa(%ebp)
c0100146:	8c 5d f4             	mov    %ds,-0xc(%ebp)
c0100149:	8c 45 f2             	mov    %es,-0xe(%ebp)
c010014c:	8c 55 f0             	mov    %ss,-0x10(%ebp)
            "mov %%cs, %0;"
            "mov %%ds, %1;"
            "mov %%es, %2;"
            "mov %%ss, %3;"
            : "=m"(reg1), "=m"(reg2), "=m"(reg3), "=m"(reg4));
    cprintf("%d: @ring %d\n", round, reg1 & 3);
c010014f:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100153:	0f b7 c0             	movzwl %ax,%eax
c0100156:	89 c2                	mov    %eax,%edx
c0100158:	83 e2 03             	and    $0x3,%edx
c010015b:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c0100160:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100164:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100168:	c7 04 24 c1 8e 10 c0 	movl   $0xc0108ec1,(%esp)
c010016f:	e8 e3 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  cs = %x\n", round, reg1);
c0100174:	0f b7 45 f6          	movzwl -0xa(%ebp),%eax
c0100178:	0f b7 d0             	movzwl %ax,%edx
c010017b:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c0100180:	89 54 24 08          	mov    %edx,0x8(%esp)
c0100184:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100188:	c7 04 24 cf 8e 10 c0 	movl   $0xc0108ecf,(%esp)
c010018f:	e8 c3 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  ds = %x\n", round, reg2);
c0100194:	0f b7 45 f4          	movzwl -0xc(%ebp),%eax
c0100198:	0f b7 d0             	movzwl %ax,%edx
c010019b:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001a0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001a4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001a8:	c7 04 24 dd 8e 10 c0 	movl   $0xc0108edd,(%esp)
c01001af:	e8 a3 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  es = %x\n", round, reg3);
c01001b4:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c01001b8:	0f b7 d0             	movzwl %ax,%edx
c01001bb:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001c0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001c4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001c8:	c7 04 24 eb 8e 10 c0 	movl   $0xc0108eeb,(%esp)
c01001cf:	e8 83 01 00 00       	call   c0100357 <cprintf>
    cprintf("%d:  ss = %x\n", round, reg4);
c01001d4:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c01001d8:	0f b7 d0             	movzwl %ax,%edx
c01001db:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001e0:	89 54 24 08          	mov    %edx,0x8(%esp)
c01001e4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01001e8:	c7 04 24 f9 8e 10 c0 	movl   $0xc0108ef9,(%esp)
c01001ef:	e8 63 01 00 00       	call   c0100357 <cprintf>
    round ++;
c01001f4:	a1 80 0a 12 c0       	mov    0xc0120a80,%eax
c01001f9:	83 c0 01             	add    $0x1,%eax
c01001fc:	a3 80 0a 12 c0       	mov    %eax,0xc0120a80
}
c0100201:	c9                   	leave  
c0100202:	c3                   	ret    

c0100203 <lab1_switch_to_user>:

static void
lab1_switch_to_user(void) {
c0100203:	55                   	push   %ebp
c0100204:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 : TODO
}
c0100206:	5d                   	pop    %ebp
c0100207:	c3                   	ret    

c0100208 <lab1_switch_to_kernel>:

static void
lab1_switch_to_kernel(void) {
c0100208:	55                   	push   %ebp
c0100209:	89 e5                	mov    %esp,%ebp
    //LAB1 CHALLENGE 1 :  TODO
}
c010020b:	5d                   	pop    %ebp
c010020c:	c3                   	ret    

c010020d <lab1_switch_test>:

static void
lab1_switch_test(void) {
c010020d:	55                   	push   %ebp
c010020e:	89 e5                	mov    %esp,%ebp
c0100210:	83 ec 18             	sub    $0x18,%esp
    lab1_print_cur_status();
c0100213:	e8 25 ff ff ff       	call   c010013d <lab1_print_cur_status>
    cprintf("+++ switch to  user  mode +++\n");
c0100218:	c7 04 24 08 8f 10 c0 	movl   $0xc0108f08,(%esp)
c010021f:	e8 33 01 00 00       	call   c0100357 <cprintf>
    lab1_switch_to_user();
c0100224:	e8 da ff ff ff       	call   c0100203 <lab1_switch_to_user>
    lab1_print_cur_status();
c0100229:	e8 0f ff ff ff       	call   c010013d <lab1_print_cur_status>
    cprintf("+++ switch to kernel mode +++\n");
c010022e:	c7 04 24 28 8f 10 c0 	movl   $0xc0108f28,(%esp)
c0100235:	e8 1d 01 00 00       	call   c0100357 <cprintf>
    lab1_switch_to_kernel();
c010023a:	e8 c9 ff ff ff       	call   c0100208 <lab1_switch_to_kernel>
    lab1_print_cur_status();
c010023f:	e8 f9 fe ff ff       	call   c010013d <lab1_print_cur_status>
}
c0100244:	c9                   	leave  
c0100245:	c3                   	ret    
	...

c0100248 <readline>:
 * The readline() function returns the text of the line read. If some errors
 * are happened, NULL is returned. The return value is a global variable,
 * thus it should be copied before it is used.
 * */
char *
readline(const char *prompt) {
c0100248:	55                   	push   %ebp
c0100249:	89 e5                	mov    %esp,%ebp
c010024b:	83 ec 28             	sub    $0x28,%esp
    if (prompt != NULL) {
c010024e:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100252:	74 13                	je     c0100267 <readline+0x1f>
        cprintf("%s", prompt);
c0100254:	8b 45 08             	mov    0x8(%ebp),%eax
c0100257:	89 44 24 04          	mov    %eax,0x4(%esp)
c010025b:	c7 04 24 47 8f 10 c0 	movl   $0xc0108f47,(%esp)
c0100262:	e8 f0 00 00 00       	call   c0100357 <cprintf>
    }
    int i = 0, c;
c0100267:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c010026e:	eb 01                	jmp    c0100271 <readline+0x29>
        else if (c == '\n' || c == '\r') {
            cputchar(c);
            buf[i] = '\0';
            return buf;
        }
    }
c0100270:	90                   	nop
    if (prompt != NULL) {
        cprintf("%s", prompt);
    }
    int i = 0, c;
    while (1) {
        c = getchar();
c0100271:	e8 6e 01 00 00       	call   c01003e4 <getchar>
c0100276:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (c < 0) {
c0100279:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010027d:	79 07                	jns    c0100286 <readline+0x3e>
            return NULL;
c010027f:	b8 00 00 00 00       	mov    $0x0,%eax
c0100284:	eb 79                	jmp    c01002ff <readline+0xb7>
        }
        else if (c >= ' ' && i < BUFSIZE - 1) {
c0100286:	83 7d f0 1f          	cmpl   $0x1f,-0x10(%ebp)
c010028a:	7e 28                	jle    c01002b4 <readline+0x6c>
c010028c:	81 7d f4 fe 03 00 00 	cmpl   $0x3fe,-0xc(%ebp)
c0100293:	7f 1f                	jg     c01002b4 <readline+0x6c>
            cputchar(c);
c0100295:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100298:	89 04 24             	mov    %eax,(%esp)
c010029b:	e8 df 00 00 00       	call   c010037f <cputchar>
            buf[i ++] = c;
c01002a0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002a3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01002a6:	81 c2 a0 0a 12 c0    	add    $0xc0120aa0,%edx
c01002ac:	88 02                	mov    %al,(%edx)
c01002ae:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01002b2:	eb 46                	jmp    c01002fa <readline+0xb2>
        }
        else if (c == '\b' && i > 0) {
c01002b4:	83 7d f0 08          	cmpl   $0x8,-0x10(%ebp)
c01002b8:	75 17                	jne    c01002d1 <readline+0x89>
c01002ba:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01002be:	7e 11                	jle    c01002d1 <readline+0x89>
            cputchar(c);
c01002c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002c3:	89 04 24             	mov    %eax,(%esp)
c01002c6:	e8 b4 00 00 00       	call   c010037f <cputchar>
            i --;
c01002cb:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01002cf:	eb 29                	jmp    c01002fa <readline+0xb2>
        }
        else if (c == '\n' || c == '\r') {
c01002d1:	83 7d f0 0a          	cmpl   $0xa,-0x10(%ebp)
c01002d5:	74 06                	je     c01002dd <readline+0x95>
c01002d7:	83 7d f0 0d          	cmpl   $0xd,-0x10(%ebp)
c01002db:	75 93                	jne    c0100270 <readline+0x28>
            cputchar(c);
c01002dd:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01002e0:	89 04 24             	mov    %eax,(%esp)
c01002e3:	e8 97 00 00 00       	call   c010037f <cputchar>
            buf[i] = '\0';
c01002e8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01002eb:	05 a0 0a 12 c0       	add    $0xc0120aa0,%eax
c01002f0:	c6 00 00             	movb   $0x0,(%eax)
            return buf;
c01002f3:	b8 a0 0a 12 c0       	mov    $0xc0120aa0,%eax
c01002f8:	eb 05                	jmp    c01002ff <readline+0xb7>
        }
    }
c01002fa:	e9 71 ff ff ff       	jmp    c0100270 <readline+0x28>
}
c01002ff:	c9                   	leave  
c0100300:	c3                   	ret    
c0100301:	00 00                	add    %al,(%eax)
	...

c0100304 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
c0100304:	55                   	push   %ebp
c0100305:	89 e5                	mov    %esp,%ebp
c0100307:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c010030a:	8b 45 08             	mov    0x8(%ebp),%eax
c010030d:	89 04 24             	mov    %eax,(%esp)
c0100310:	e8 83 13 00 00       	call   c0101698 <cons_putc>
    (*cnt) ++;
c0100315:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100318:	8b 00                	mov    (%eax),%eax
c010031a:	8d 50 01             	lea    0x1(%eax),%edx
c010031d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100320:	89 10                	mov    %edx,(%eax)
}
c0100322:	c9                   	leave  
c0100323:	c3                   	ret    

c0100324 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
c0100324:	55                   	push   %ebp
c0100325:	89 e5                	mov    %esp,%ebp
c0100327:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c010032a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, &cnt, fmt, ap);
c0100331:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100334:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0100338:	8b 45 08             	mov    0x8(%ebp),%eax
c010033b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010033f:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100342:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100346:	c7 04 24 04 03 10 c0 	movl   $0xc0100304,(%esp)
c010034d:	e8 90 80 00 00       	call   c01083e2 <vprintfmt>
    return cnt;
c0100352:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100355:	c9                   	leave  
c0100356:	c3                   	ret    

c0100357 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
c0100357:	55                   	push   %ebp
c0100358:	89 e5                	mov    %esp,%ebp
c010035a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c010035d:	8d 55 0c             	lea    0xc(%ebp),%edx
c0100360:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0100363:	89 10                	mov    %edx,(%eax)
    cnt = vcprintf(fmt, ap);
c0100365:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100368:	89 44 24 04          	mov    %eax,0x4(%esp)
c010036c:	8b 45 08             	mov    0x8(%ebp),%eax
c010036f:	89 04 24             	mov    %eax,(%esp)
c0100372:	e8 ad ff ff ff       	call   c0100324 <vcprintf>
c0100377:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010037a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010037d:	c9                   	leave  
c010037e:	c3                   	ret    

c010037f <cputchar>:

/* cputchar - writes a single character to stdout */
void
cputchar(int c) {
c010037f:	55                   	push   %ebp
c0100380:	89 e5                	mov    %esp,%ebp
c0100382:	83 ec 18             	sub    $0x18,%esp
    cons_putc(c);
c0100385:	8b 45 08             	mov    0x8(%ebp),%eax
c0100388:	89 04 24             	mov    %eax,(%esp)
c010038b:	e8 08 13 00 00       	call   c0101698 <cons_putc>
}
c0100390:	c9                   	leave  
c0100391:	c3                   	ret    

c0100392 <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
c0100392:	55                   	push   %ebp
c0100393:	89 e5                	mov    %esp,%ebp
c0100395:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
c0100398:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
c010039f:	eb 13                	jmp    c01003b4 <cputs+0x22>
        cputch(c, &cnt);
c01003a1:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
c01003a5:	8d 55 f0             	lea    -0x10(%ebp),%edx
c01003a8:	89 54 24 04          	mov    %edx,0x4(%esp)
c01003ac:	89 04 24             	mov    %eax,(%esp)
c01003af:	e8 50 ff ff ff       	call   c0100304 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
c01003b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01003b7:	0f b6 00             	movzbl (%eax),%eax
c01003ba:	88 45 f7             	mov    %al,-0x9(%ebp)
c01003bd:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
c01003c1:	0f 95 c0             	setne  %al
c01003c4:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01003c8:	84 c0                	test   %al,%al
c01003ca:	75 d5                	jne    c01003a1 <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
c01003cc:	8d 45 f0             	lea    -0x10(%ebp),%eax
c01003cf:	89 44 24 04          	mov    %eax,0x4(%esp)
c01003d3:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
c01003da:	e8 25 ff ff ff       	call   c0100304 <cputch>
    return cnt;
c01003df:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c01003e2:	c9                   	leave  
c01003e3:	c3                   	ret    

c01003e4 <getchar>:

/* getchar - reads a single non-zero character from stdin */
int
getchar(void) {
c01003e4:	55                   	push   %ebp
c01003e5:	89 e5                	mov    %esp,%ebp
c01003e7:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = cons_getc()) == 0)
c01003ea:	e8 e5 12 00 00       	call   c01016d4 <cons_getc>
c01003ef:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01003f2:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01003f6:	74 f2                	je     c01003ea <getchar+0x6>
        /* do nothing */;
    return c;
c01003f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01003fb:	c9                   	leave  
c01003fc:	c3                   	ret    
c01003fd:	00 00                	add    %al,(%eax)
	...

c0100400 <stab_binsearch>:
 *      stab_binsearch(stabs, &left, &right, N_SO, 0xf0100184);
 * will exit setting left = 118, right = 554.
 * */
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
c0100400:	55                   	push   %ebp
c0100401:	89 e5                	mov    %esp,%ebp
c0100403:	83 ec 20             	sub    $0x20,%esp
    int l = *region_left, r = *region_right, any_matches = 0;
c0100406:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100409:	8b 00                	mov    (%eax),%eax
c010040b:	89 45 fc             	mov    %eax,-0x4(%ebp)
c010040e:	8b 45 10             	mov    0x10(%ebp),%eax
c0100411:	8b 00                	mov    (%eax),%eax
c0100413:	89 45 f8             	mov    %eax,-0x8(%ebp)
c0100416:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)

    while (l <= r) {
c010041d:	e9 c6 00 00 00       	jmp    c01004e8 <stab_binsearch+0xe8>
        int true_m = (l + r) / 2, m = true_m;
c0100422:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100425:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100428:	01 d0                	add    %edx,%eax
c010042a:	89 c2                	mov    %eax,%edx
c010042c:	c1 ea 1f             	shr    $0x1f,%edx
c010042f:	01 d0                	add    %edx,%eax
c0100431:	d1 f8                	sar    %eax
c0100433:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0100436:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100439:	89 45 f0             	mov    %eax,-0x10(%ebp)

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c010043c:	eb 04                	jmp    c0100442 <stab_binsearch+0x42>
            m --;
c010043e:	83 6d f0 01          	subl   $0x1,-0x10(%ebp)

    while (l <= r) {
        int true_m = (l + r) / 2, m = true_m;

        // search for earliest stab with right type
        while (m >= l && stabs[m].n_type != type) {
c0100442:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100445:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c0100448:	7c 1b                	jl     c0100465 <stab_binsearch+0x65>
c010044a:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010044d:	89 d0                	mov    %edx,%eax
c010044f:	01 c0                	add    %eax,%eax
c0100451:	01 d0                	add    %edx,%eax
c0100453:	c1 e0 02             	shl    $0x2,%eax
c0100456:	03 45 08             	add    0x8(%ebp),%eax
c0100459:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010045d:	0f b6 c0             	movzbl %al,%eax
c0100460:	3b 45 14             	cmp    0x14(%ebp),%eax
c0100463:	75 d9                	jne    c010043e <stab_binsearch+0x3e>
            m --;
        }
        if (m < l) {    // no match in [l, m]
c0100465:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100468:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010046b:	7d 0b                	jge    c0100478 <stab_binsearch+0x78>
            l = true_m + 1;
c010046d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100470:	83 c0 01             	add    $0x1,%eax
c0100473:	89 45 fc             	mov    %eax,-0x4(%ebp)
            continue;
c0100476:	eb 70                	jmp    c01004e8 <stab_binsearch+0xe8>
        }

        // actual binary search
        any_matches = 1;
c0100478:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
        if (stabs[m].n_value < addr) {
c010047f:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0100482:	89 d0                	mov    %edx,%eax
c0100484:	01 c0                	add    %eax,%eax
c0100486:	01 d0                	add    %edx,%eax
c0100488:	c1 e0 02             	shl    $0x2,%eax
c010048b:	03 45 08             	add    0x8(%ebp),%eax
c010048e:	8b 40 08             	mov    0x8(%eax),%eax
c0100491:	3b 45 18             	cmp    0x18(%ebp),%eax
c0100494:	73 13                	jae    c01004a9 <stab_binsearch+0xa9>
            *region_left = m;
c0100496:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100499:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010049c:	89 10                	mov    %edx,(%eax)
            l = true_m + 1;
c010049e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01004a1:	83 c0 01             	add    $0x1,%eax
c01004a4:	89 45 fc             	mov    %eax,-0x4(%ebp)
c01004a7:	eb 3f                	jmp    c01004e8 <stab_binsearch+0xe8>
        } else if (stabs[m].n_value > addr) {
c01004a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004ac:	89 d0                	mov    %edx,%eax
c01004ae:	01 c0                	add    %eax,%eax
c01004b0:	01 d0                	add    %edx,%eax
c01004b2:	c1 e0 02             	shl    $0x2,%eax
c01004b5:	03 45 08             	add    0x8(%ebp),%eax
c01004b8:	8b 40 08             	mov    0x8(%eax),%eax
c01004bb:	3b 45 18             	cmp    0x18(%ebp),%eax
c01004be:	76 16                	jbe    c01004d6 <stab_binsearch+0xd6>
            *region_right = m - 1;
c01004c0:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004c3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01004c6:	8b 45 10             	mov    0x10(%ebp),%eax
c01004c9:	89 10                	mov    %edx,(%eax)
            r = m - 1;
c01004cb:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004ce:	83 e8 01             	sub    $0x1,%eax
c01004d1:	89 45 f8             	mov    %eax,-0x8(%ebp)
c01004d4:	eb 12                	jmp    c01004e8 <stab_binsearch+0xe8>
        } else {
            // exact match for 'addr', but continue loop to find
            // *region_right
            *region_left = m;
c01004d6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004d9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01004dc:	89 10                	mov    %edx,(%eax)
            l = m;
c01004de:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01004e1:	89 45 fc             	mov    %eax,-0x4(%ebp)
            addr ++;
c01004e4:	83 45 18 01          	addl   $0x1,0x18(%ebp)
static void
stab_binsearch(const struct stab *stabs, int *region_left, int *region_right,
           int type, uintptr_t addr) {
    int l = *region_left, r = *region_right, any_matches = 0;

    while (l <= r) {
c01004e8:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01004eb:	3b 45 f8             	cmp    -0x8(%ebp),%eax
c01004ee:	0f 8e 2e ff ff ff    	jle    c0100422 <stab_binsearch+0x22>
            l = m;
            addr ++;
        }
    }

    if (!any_matches) {
c01004f4:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01004f8:	75 0f                	jne    c0100509 <stab_binsearch+0x109>
        *region_right = *region_left - 1;
c01004fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01004fd:	8b 00                	mov    (%eax),%eax
c01004ff:	8d 50 ff             	lea    -0x1(%eax),%edx
c0100502:	8b 45 10             	mov    0x10(%ebp),%eax
c0100505:	89 10                	mov    %edx,(%eax)
c0100507:	eb 3b                	jmp    c0100544 <stab_binsearch+0x144>
    }
    else {
        // find rightmost region containing 'addr'
        l = *region_right;
c0100509:	8b 45 10             	mov    0x10(%ebp),%eax
c010050c:	8b 00                	mov    (%eax),%eax
c010050e:	89 45 fc             	mov    %eax,-0x4(%ebp)
        for (; l > *region_left && stabs[l].n_type != type; l --)
c0100511:	eb 04                	jmp    c0100517 <stab_binsearch+0x117>
c0100513:	83 6d fc 01          	subl   $0x1,-0x4(%ebp)
c0100517:	8b 45 0c             	mov    0xc(%ebp),%eax
c010051a:	8b 00                	mov    (%eax),%eax
c010051c:	3b 45 fc             	cmp    -0x4(%ebp),%eax
c010051f:	7d 1b                	jge    c010053c <stab_binsearch+0x13c>
c0100521:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100524:	89 d0                	mov    %edx,%eax
c0100526:	01 c0                	add    %eax,%eax
c0100528:	01 d0                	add    %edx,%eax
c010052a:	c1 e0 02             	shl    $0x2,%eax
c010052d:	03 45 08             	add    0x8(%ebp),%eax
c0100530:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100534:	0f b6 c0             	movzbl %al,%eax
c0100537:	3b 45 14             	cmp    0x14(%ebp),%eax
c010053a:	75 d7                	jne    c0100513 <stab_binsearch+0x113>
            /* do nothing */;
        *region_left = l;
c010053c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010053f:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0100542:	89 10                	mov    %edx,(%eax)
    }
}
c0100544:	c9                   	leave  
c0100545:	c3                   	ret    

c0100546 <debuginfo_eip>:
 * the specified instruction address, @addr.  Returns 0 if information
 * was found, and negative if not.  But even if it returns negative it
 * has stored some information into '*info'.
 * */
int
debuginfo_eip(uintptr_t addr, struct eipdebuginfo *info) {
c0100546:	55                   	push   %ebp
c0100547:	89 e5                	mov    %esp,%ebp
c0100549:	53                   	push   %ebx
c010054a:	83 ec 54             	sub    $0x54,%esp
    const struct stab *stabs, *stab_end;
    const char *stabstr, *stabstr_end;

    info->eip_file = "<unknown>";
c010054d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100550:	c7 00 4c 8f 10 c0    	movl   $0xc0108f4c,(%eax)
    info->eip_line = 0;
c0100556:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100559:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    info->eip_fn_name = "<unknown>";
c0100560:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100563:	c7 40 08 4c 8f 10 c0 	movl   $0xc0108f4c,0x8(%eax)
    info->eip_fn_namelen = 9;
c010056a:	8b 45 0c             	mov    0xc(%ebp),%eax
c010056d:	c7 40 0c 09 00 00 00 	movl   $0x9,0xc(%eax)
    info->eip_fn_addr = addr;
c0100574:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100577:	8b 55 08             	mov    0x8(%ebp),%edx
c010057a:	89 50 10             	mov    %edx,0x10(%eax)
    info->eip_fn_narg = 0;
c010057d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100580:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)

    stabs = __STAB_BEGIN__;
c0100587:	c7 45 f4 ac ae 10 c0 	movl   $0xc010aeac,-0xc(%ebp)
    stab_end = __STAB_END__;
c010058e:	c7 45 f0 68 a0 11 c0 	movl   $0xc011a068,-0x10(%ebp)
    stabstr = __STABSTR_BEGIN__;
c0100595:	c7 45 ec 69 a0 11 c0 	movl   $0xc011a069,-0x14(%ebp)
    stabstr_end = __STABSTR_END__;
c010059c:	c7 45 e8 f3 d8 11 c0 	movl   $0xc011d8f3,-0x18(%ebp)

    // String table validity checks
    if (stabstr_end <= stabstr || stabstr_end[-1] != 0) {
c01005a3:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005a6:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c01005a9:	76 0d                	jbe    c01005b8 <debuginfo_eip+0x72>
c01005ab:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01005ae:	83 e8 01             	sub    $0x1,%eax
c01005b1:	0f b6 00             	movzbl (%eax),%eax
c01005b4:	84 c0                	test   %al,%al
c01005b6:	74 0a                	je     c01005c2 <debuginfo_eip+0x7c>
        return -1;
c01005b8:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01005bd:	e9 9e 02 00 00       	jmp    c0100860 <debuginfo_eip+0x31a>
    // 'eip'.  First, we find the basic source file containing 'eip'.
    // Then, we look in that source file for the function.  Then we look
    // for the line number.

    // Search the entire set of stabs for the source file (type N_SO).
    int lfile = 0, rfile = (stab_end - stabs) - 1;
c01005c2:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
c01005c9:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01005cc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01005cf:	89 d1                	mov    %edx,%ecx
c01005d1:	29 c1                	sub    %eax,%ecx
c01005d3:	89 c8                	mov    %ecx,%eax
c01005d5:	c1 f8 02             	sar    $0x2,%eax
c01005d8:	69 c0 ab aa aa aa    	imul   $0xaaaaaaab,%eax,%eax
c01005de:	83 e8 01             	sub    $0x1,%eax
c01005e1:	89 45 e0             	mov    %eax,-0x20(%ebp)
    stab_binsearch(stabs, &lfile, &rfile, N_SO, addr);
c01005e4:	8b 45 08             	mov    0x8(%ebp),%eax
c01005e7:	89 44 24 10          	mov    %eax,0x10(%esp)
c01005eb:	c7 44 24 0c 64 00 00 	movl   $0x64,0xc(%esp)
c01005f2:	00 
c01005f3:	8d 45 e0             	lea    -0x20(%ebp),%eax
c01005f6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01005fa:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100601:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100604:	89 04 24             	mov    %eax,(%esp)
c0100607:	e8 f4 fd ff ff       	call   c0100400 <stab_binsearch>
    if (lfile == 0)
c010060c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010060f:	85 c0                	test   %eax,%eax
c0100611:	75 0a                	jne    c010061d <debuginfo_eip+0xd7>
        return -1;
c0100613:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c0100618:	e9 43 02 00 00       	jmp    c0100860 <debuginfo_eip+0x31a>

    // Search within that file's stabs for the function definition
    // (N_FUN).
    int lfun = lfile, rfun = rfile;
c010061d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100620:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0100623:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0100626:	89 45 d8             	mov    %eax,-0x28(%ebp)
    int lline, rline;
    stab_binsearch(stabs, &lfun, &rfun, N_FUN, addr);
c0100629:	8b 45 08             	mov    0x8(%ebp),%eax
c010062c:	89 44 24 10          	mov    %eax,0x10(%esp)
c0100630:	c7 44 24 0c 24 00 00 	movl   $0x24,0xc(%esp)
c0100637:	00 
c0100638:	8d 45 d8             	lea    -0x28(%ebp),%eax
c010063b:	89 44 24 08          	mov    %eax,0x8(%esp)
c010063f:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0100642:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100646:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100649:	89 04 24             	mov    %eax,(%esp)
c010064c:	e8 af fd ff ff       	call   c0100400 <stab_binsearch>

    if (lfun <= rfun) {
c0100651:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0100654:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100657:	39 c2                	cmp    %eax,%edx
c0100659:	7f 72                	jg     c01006cd <debuginfo_eip+0x187>
        // stabs[lfun] points to the function name
        // in the string table, but check bounds just in case.
        if (stabs[lfun].n_strx < stabstr_end - stabstr) {
c010065b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010065e:	89 c2                	mov    %eax,%edx
c0100660:	89 d0                	mov    %edx,%eax
c0100662:	01 c0                	add    %eax,%eax
c0100664:	01 d0                	add    %edx,%eax
c0100666:	c1 e0 02             	shl    $0x2,%eax
c0100669:	03 45 f4             	add    -0xc(%ebp),%eax
c010066c:	8b 10                	mov    (%eax),%edx
c010066e:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0100671:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0100674:	89 cb                	mov    %ecx,%ebx
c0100676:	29 c3                	sub    %eax,%ebx
c0100678:	89 d8                	mov    %ebx,%eax
c010067a:	39 c2                	cmp    %eax,%edx
c010067c:	73 1e                	jae    c010069c <debuginfo_eip+0x156>
            info->eip_fn_name = stabstr + stabs[lfun].n_strx;
c010067e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100681:	89 c2                	mov    %eax,%edx
c0100683:	89 d0                	mov    %edx,%eax
c0100685:	01 c0                	add    %eax,%eax
c0100687:	01 d0                	add    %edx,%eax
c0100689:	c1 e0 02             	shl    $0x2,%eax
c010068c:	03 45 f4             	add    -0xc(%ebp),%eax
c010068f:	8b 00                	mov    (%eax),%eax
c0100691:	89 c2                	mov    %eax,%edx
c0100693:	03 55 ec             	add    -0x14(%ebp),%edx
c0100696:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100699:	89 50 08             	mov    %edx,0x8(%eax)
        }
        info->eip_fn_addr = stabs[lfun].n_value;
c010069c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c010069f:	89 c2                	mov    %eax,%edx
c01006a1:	89 d0                	mov    %edx,%eax
c01006a3:	01 c0                	add    %eax,%eax
c01006a5:	01 d0                	add    %edx,%eax
c01006a7:	c1 e0 02             	shl    $0x2,%eax
c01006aa:	03 45 f4             	add    -0xc(%ebp),%eax
c01006ad:	8b 50 08             	mov    0x8(%eax),%edx
c01006b0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b3:	89 50 10             	mov    %edx,0x10(%eax)
        addr -= info->eip_fn_addr;
c01006b6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006b9:	8b 40 10             	mov    0x10(%eax),%eax
c01006bc:	29 45 08             	sub    %eax,0x8(%ebp)
        // Search within the function definition for the line number.
        lline = lfun;
c01006bf:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01006c2:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfun;
c01006c5:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01006c8:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01006cb:	eb 15                	jmp    c01006e2 <debuginfo_eip+0x19c>
    } else {
        // Couldn't find function stab!  Maybe we're in an assembly
        // file.  Search the whole file for the line number.
        info->eip_fn_addr = addr;
c01006cd:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006d0:	8b 55 08             	mov    0x8(%ebp),%edx
c01006d3:	89 50 10             	mov    %edx,0x10(%eax)
        lline = lfile;
c01006d6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01006d9:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        rline = rfile;
c01006dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01006df:	89 45 d0             	mov    %eax,-0x30(%ebp)
    }
    info->eip_fn_namelen = strfind(info->eip_fn_name, ':') - info->eip_fn_name;
c01006e2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006e5:	8b 40 08             	mov    0x8(%eax),%eax
c01006e8:	c7 44 24 04 3a 00 00 	movl   $0x3a,0x4(%esp)
c01006ef:	00 
c01006f0:	89 04 24             	mov    %eax,(%esp)
c01006f3:	e8 63 84 00 00       	call   c0108b5b <strfind>
c01006f8:	89 c2                	mov    %eax,%edx
c01006fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01006fd:	8b 40 08             	mov    0x8(%eax),%eax
c0100700:	29 c2                	sub    %eax,%edx
c0100702:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100705:	89 50 0c             	mov    %edx,0xc(%eax)

    // Search within [lline, rline] for the line number stab.
    // If found, set info->eip_line to the right line number.
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
c0100708:	8b 45 08             	mov    0x8(%ebp),%eax
c010070b:	89 44 24 10          	mov    %eax,0x10(%esp)
c010070f:	c7 44 24 0c 44 00 00 	movl   $0x44,0xc(%esp)
c0100716:	00 
c0100717:	8d 45 d0             	lea    -0x30(%ebp),%eax
c010071a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010071e:	8d 45 d4             	lea    -0x2c(%ebp),%eax
c0100721:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100725:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100728:	89 04 24             	mov    %eax,(%esp)
c010072b:	e8 d0 fc ff ff       	call   c0100400 <stab_binsearch>
    if (lline <= rline) {
c0100730:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100733:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0100736:	39 c2                	cmp    %eax,%edx
c0100738:	7f 20                	jg     c010075a <debuginfo_eip+0x214>
        info->eip_line = stabs[rline].n_desc;
c010073a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010073d:	89 c2                	mov    %eax,%edx
c010073f:	89 d0                	mov    %edx,%eax
c0100741:	01 c0                	add    %eax,%eax
c0100743:	01 d0                	add    %edx,%eax
c0100745:	c1 e0 02             	shl    $0x2,%eax
c0100748:	03 45 f4             	add    -0xc(%ebp),%eax
c010074b:	0f b7 40 06          	movzwl 0x6(%eax),%eax
c010074f:	0f b7 d0             	movzwl %ax,%edx
c0100752:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100755:	89 50 04             	mov    %edx,0x4(%eax)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c0100758:	eb 13                	jmp    c010076d <debuginfo_eip+0x227>
    // If not found, return -1.
    stab_binsearch(stabs, &lline, &rline, N_SLINE, addr);
    if (lline <= rline) {
        info->eip_line = stabs[rline].n_desc;
    } else {
        return -1;
c010075a:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010075f:	e9 fc 00 00 00       	jmp    c0100860 <debuginfo_eip+0x31a>
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
           && stabs[lline].n_type != N_SOL
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
        lline --;
c0100764:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100767:	83 e8 01             	sub    $0x1,%eax
c010076a:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Search backwards from the line number for the relevant filename stab.
    // We can't just use the "lfile" stab because inlined functions
    // can interpolate code from a different file!
    // Such included source files use the N_SOL stab type.
    while (lline >= lfile
c010076d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0100770:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0100773:	39 c2                	cmp    %eax,%edx
c0100775:	7c 4a                	jl     c01007c1 <debuginfo_eip+0x27b>
           && stabs[lline].n_type != N_SOL
c0100777:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010077a:	89 c2                	mov    %eax,%edx
c010077c:	89 d0                	mov    %edx,%eax
c010077e:	01 c0                	add    %eax,%eax
c0100780:	01 d0                	add    %edx,%eax
c0100782:	c1 e0 02             	shl    $0x2,%eax
c0100785:	03 45 f4             	add    -0xc(%ebp),%eax
c0100788:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c010078c:	3c 84                	cmp    $0x84,%al
c010078e:	74 31                	je     c01007c1 <debuginfo_eip+0x27b>
           && (stabs[lline].n_type != N_SO || !stabs[lline].n_value)) {
c0100790:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100793:	89 c2                	mov    %eax,%edx
c0100795:	89 d0                	mov    %edx,%eax
c0100797:	01 c0                	add    %eax,%eax
c0100799:	01 d0                	add    %edx,%eax
c010079b:	c1 e0 02             	shl    $0x2,%eax
c010079e:	03 45 f4             	add    -0xc(%ebp),%eax
c01007a1:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c01007a5:	3c 64                	cmp    $0x64,%al
c01007a7:	75 bb                	jne    c0100764 <debuginfo_eip+0x21e>
c01007a9:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ac:	89 c2                	mov    %eax,%edx
c01007ae:	89 d0                	mov    %edx,%eax
c01007b0:	01 c0                	add    %eax,%eax
c01007b2:	01 d0                	add    %edx,%eax
c01007b4:	c1 e0 02             	shl    $0x2,%eax
c01007b7:	03 45 f4             	add    -0xc(%ebp),%eax
c01007ba:	8b 40 08             	mov    0x8(%eax),%eax
c01007bd:	85 c0                	test   %eax,%eax
c01007bf:	74 a3                	je     c0100764 <debuginfo_eip+0x21e>
        lline --;
    }
    if (lline >= lfile && stabs[lline].n_strx < stabstr_end - stabstr) {
c01007c1:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01007c4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01007c7:	39 c2                	cmp    %eax,%edx
c01007c9:	7c 40                	jl     c010080b <debuginfo_eip+0x2c5>
c01007cb:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007ce:	89 c2                	mov    %eax,%edx
c01007d0:	89 d0                	mov    %edx,%eax
c01007d2:	01 c0                	add    %eax,%eax
c01007d4:	01 d0                	add    %edx,%eax
c01007d6:	c1 e0 02             	shl    $0x2,%eax
c01007d9:	03 45 f4             	add    -0xc(%ebp),%eax
c01007dc:	8b 10                	mov    (%eax),%edx
c01007de:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c01007e1:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01007e4:	89 cb                	mov    %ecx,%ebx
c01007e6:	29 c3                	sub    %eax,%ebx
c01007e8:	89 d8                	mov    %ebx,%eax
c01007ea:	39 c2                	cmp    %eax,%edx
c01007ec:	73 1d                	jae    c010080b <debuginfo_eip+0x2c5>
        info->eip_file = stabstr + stabs[lline].n_strx;
c01007ee:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01007f1:	89 c2                	mov    %eax,%edx
c01007f3:	89 d0                	mov    %edx,%eax
c01007f5:	01 c0                	add    %eax,%eax
c01007f7:	01 d0                	add    %edx,%eax
c01007f9:	c1 e0 02             	shl    $0x2,%eax
c01007fc:	03 45 f4             	add    -0xc(%ebp),%eax
c01007ff:	8b 00                	mov    (%eax),%eax
c0100801:	89 c2                	mov    %eax,%edx
c0100803:	03 55 ec             	add    -0x14(%ebp),%edx
c0100806:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100809:	89 10                	mov    %edx,(%eax)
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
c010080b:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010080e:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0100811:	39 c2                	cmp    %eax,%edx
c0100813:	7d 46                	jge    c010085b <debuginfo_eip+0x315>
        for (lline = lfun + 1;
c0100815:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100818:	83 c0 01             	add    $0x1,%eax
c010081b:	89 45 d4             	mov    %eax,-0x2c(%ebp)
c010081e:	eb 18                	jmp    c0100838 <debuginfo_eip+0x2f2>
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
            info->eip_fn_narg ++;
c0100820:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100823:	8b 40 14             	mov    0x14(%eax),%eax
c0100826:	8d 50 01             	lea    0x1(%eax),%edx
c0100829:	8b 45 0c             	mov    0xc(%ebp),%eax
c010082c:	89 50 14             	mov    %edx,0x14(%eax)
    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
             lline ++) {
c010082f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100832:	83 c0 01             	add    $0x1,%eax
c0100835:	89 45 d4             	mov    %eax,-0x2c(%ebp)

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100838:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010083b:	8b 45 d8             	mov    -0x28(%ebp),%eax
    }

    // Set eip_fn_narg to the number of arguments taken by the function,
    // or 0 if there was no containing function.
    if (lfun < rfun) {
        for (lline = lfun + 1;
c010083e:	39 c2                	cmp    %eax,%edx
c0100840:	7d 19                	jge    c010085b <debuginfo_eip+0x315>
             lline < rfun && stabs[lline].n_type == N_PSYM;
c0100842:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0100845:	89 c2                	mov    %eax,%edx
c0100847:	89 d0                	mov    %edx,%eax
c0100849:	01 c0                	add    %eax,%eax
c010084b:	01 d0                	add    %edx,%eax
c010084d:	c1 e0 02             	shl    $0x2,%eax
c0100850:	03 45 f4             	add    -0xc(%ebp),%eax
c0100853:	0f b6 40 04          	movzbl 0x4(%eax),%eax
c0100857:	3c a0                	cmp    $0xa0,%al
c0100859:	74 c5                	je     c0100820 <debuginfo_eip+0x2da>
             lline ++) {
            info->eip_fn_narg ++;
        }
    }
    return 0;
c010085b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100860:	83 c4 54             	add    $0x54,%esp
c0100863:	5b                   	pop    %ebx
c0100864:	5d                   	pop    %ebp
c0100865:	c3                   	ret    

c0100866 <print_kerninfo>:
 * print_kerninfo - print the information about kernel, including the location
 * of kernel entry, the start addresses of data and text segements, the start
 * address of free memory and how many memory that kernel has used.
 * */
void
print_kerninfo(void) {
c0100866:	55                   	push   %ebp
c0100867:	89 e5                	mov    %esp,%ebp
c0100869:	83 ec 18             	sub    $0x18,%esp
    extern char etext[], edata[], end[], kern_init[];
    cprintf("Special kernel symbols:\n");
c010086c:	c7 04 24 56 8f 10 c0 	movl   $0xc0108f56,(%esp)
c0100873:	e8 df fa ff ff       	call   c0100357 <cprintf>
    cprintf("  entry  0x%08x (phys)\n", kern_init);
c0100878:	c7 44 24 04 2c 00 10 	movl   $0xc010002c,0x4(%esp)
c010087f:	c0 
c0100880:	c7 04 24 6f 8f 10 c0 	movl   $0xc0108f6f,(%esp)
c0100887:	e8 cb fa ff ff       	call   c0100357 <cprintf>
    cprintf("  etext  0x%08x (phys)\n", etext);
c010088c:	c7 44 24 04 9b 8e 10 	movl   $0xc0108e9b,0x4(%esp)
c0100893:	c0 
c0100894:	c7 04 24 87 8f 10 c0 	movl   $0xc0108f87,(%esp)
c010089b:	e8 b7 fa ff ff       	call   c0100357 <cprintf>
    cprintf("  edata  0x%08x (phys)\n", edata);
c01008a0:	c7 44 24 04 68 0a 12 	movl   $0xc0120a68,0x4(%esp)
c01008a7:	c0 
c01008a8:	c7 04 24 9f 8f 10 c0 	movl   $0xc0108f9f,(%esp)
c01008af:	e8 a3 fa ff ff       	call   c0100357 <cprintf>
    cprintf("  end    0x%08x (phys)\n", end);
c01008b4:	c7 44 24 04 b0 1b 12 	movl   $0xc0121bb0,0x4(%esp)
c01008bb:	c0 
c01008bc:	c7 04 24 b7 8f 10 c0 	movl   $0xc0108fb7,(%esp)
c01008c3:	e8 8f fa ff ff       	call   c0100357 <cprintf>
    cprintf("Kernel executable memory footprint: %dKB\n", (end - kern_init + 1023)/1024);
c01008c8:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c01008cd:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008d3:	b8 2c 00 10 c0       	mov    $0xc010002c,%eax
c01008d8:	89 d1                	mov    %edx,%ecx
c01008da:	29 c1                	sub    %eax,%ecx
c01008dc:	89 c8                	mov    %ecx,%eax
c01008de:	8d 90 ff 03 00 00    	lea    0x3ff(%eax),%edx
c01008e4:	85 c0                	test   %eax,%eax
c01008e6:	0f 48 c2             	cmovs  %edx,%eax
c01008e9:	c1 f8 0a             	sar    $0xa,%eax
c01008ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01008f0:	c7 04 24 d0 8f 10 c0 	movl   $0xc0108fd0,(%esp)
c01008f7:	e8 5b fa ff ff       	call   c0100357 <cprintf>
}
c01008fc:	c9                   	leave  
c01008fd:	c3                   	ret    

c01008fe <print_debuginfo>:
/* *
 * print_debuginfo - read and print the stat information for the address @eip,
 * and info.eip_fn_addr should be the first address of the related function.
 * */
void
print_debuginfo(uintptr_t eip) {
c01008fe:	55                   	push   %ebp
c01008ff:	89 e5                	mov    %esp,%ebp
c0100901:	81 ec 48 01 00 00    	sub    $0x148,%esp
    struct eipdebuginfo info;
    if (debuginfo_eip(eip, &info) != 0) {
c0100907:	8d 45 dc             	lea    -0x24(%ebp),%eax
c010090a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010090e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100911:	89 04 24             	mov    %eax,(%esp)
c0100914:	e8 2d fc ff ff       	call   c0100546 <debuginfo_eip>
c0100919:	85 c0                	test   %eax,%eax
c010091b:	74 15                	je     c0100932 <print_debuginfo+0x34>
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
c010091d:	8b 45 08             	mov    0x8(%ebp),%eax
c0100920:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100924:	c7 04 24 fa 8f 10 c0 	movl   $0xc0108ffa,(%esp)
c010092b:	e8 27 fa ff ff       	call   c0100357 <cprintf>
c0100930:	eb 69                	jmp    c010099b <print_debuginfo+0x9d>
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100932:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100939:	eb 1a                	jmp    c0100955 <print_debuginfo+0x57>
            fnname[j] = info.eip_fn_name[j];
c010093b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010093e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100941:	01 d0                	add    %edx,%eax
c0100943:	0f b6 10             	movzbl (%eax),%edx
c0100946:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c010094c:	03 45 f4             	add    -0xc(%ebp),%eax
c010094f:	88 10                	mov    %dl,(%eax)
        cprintf("    <unknow>: -- 0x%08x --\n", eip);
    }
    else {
        char fnname[256];
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
c0100951:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100955:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100958:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010095b:	7f de                	jg     c010093b <print_debuginfo+0x3d>
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
c010095d:	8d 85 dc fe ff ff    	lea    -0x124(%ebp),%eax
c0100963:	03 45 f4             	add    -0xc(%ebp),%eax
c0100966:	c6 00 00             	movb   $0x0,(%eax)
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
                fnname, eip - info.eip_fn_addr);
c0100969:	8b 45 ec             	mov    -0x14(%ebp),%eax
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c010096c:	8b 55 08             	mov    0x8(%ebp),%edx
c010096f:	89 d1                	mov    %edx,%ecx
c0100971:	29 c1                	sub    %eax,%ecx
c0100973:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0100976:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0100979:	89 4c 24 10          	mov    %ecx,0x10(%esp)
                fnname, eip - info.eip_fn_addr);
c010097d:	8d 8d dc fe ff ff    	lea    -0x124(%ebp),%ecx
c0100983:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
        int j;
        for (j = 0; j < info.eip_fn_namelen; j ++) {
            fnname[j] = info.eip_fn_name[j];
        }
        fnname[j] = '\0';
        cprintf("    %s:%d: %s+%d\n", info.eip_file, info.eip_line,
c0100987:	89 54 24 08          	mov    %edx,0x8(%esp)
c010098b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010098f:	c7 04 24 16 90 10 c0 	movl   $0xc0109016,(%esp)
c0100996:	e8 bc f9 ff ff       	call   c0100357 <cprintf>
                fnname, eip - info.eip_fn_addr);
    }
}
c010099b:	c9                   	leave  
c010099c:	c3                   	ret    

c010099d <read_eip>:

static __noinline uint32_t
read_eip(void) {
c010099d:	55                   	push   %ebp
c010099e:	89 e5                	mov    %esp,%ebp
c01009a0:	53                   	push   %ebx
c01009a1:	83 ec 10             	sub    $0x10,%esp
    uint32_t eip;
    asm volatile("movl 4(%%ebp), %0" : "=r" (eip));
c01009a4:	8b 5d 04             	mov    0x4(%ebp),%ebx
c01009a7:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return eip;
c01009aa:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c01009ad:	83 c4 10             	add    $0x10,%esp
c01009b0:	5b                   	pop    %ebx
c01009b1:	5d                   	pop    %ebp
c01009b2:	c3                   	ret    

c01009b3 <print_stackframe>:
 *
 * Note that, the length of ebp-chain is limited. In boot/bootasm.S, before jumping
 * to the kernel entry, the value of ebp has been set to zero, that's the boundary.
 * */
void
print_stackframe(void) {
c01009b3:	55                   	push   %ebp
c01009b4:	89 e5                	mov    %esp,%ebp
c01009b6:	53                   	push   %ebx
c01009b7:	83 ec 34             	sub    $0x34,%esp
}

static inline uint32_t
read_ebp(void) {
    uint32_t ebp;
    asm volatile ("movl %%ebp, %0" : "=r" (ebp));
c01009ba:	89 eb                	mov    %ebp,%ebx
c01009bc:	89 5d e0             	mov    %ebx,-0x20(%ebp)
    return ebp;
c01009bf:	8b 45 e0             	mov    -0x20(%ebp),%eax
      *    (3.4) call print_debuginfo(eip-1) to print the C calling function name and line number, etc.
      *    (3.5) popup a calling stackframe
      *           NOTICE: the calling funciton's return addr eip  = ss:[ebp+4]
      *                   the calling funciton's ebp = ss:[ebp]
      */
          uint32_t ebp = read_ebp(), eip = read_eip();
c01009c2:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01009c5:	e8 d3 ff ff ff       	call   c010099d <read_eip>
c01009ca:	89 45 f0             	mov    %eax,-0x10(%ebp)

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c01009cd:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01009d4:	e9 82 00 00 00       	jmp    c0100a5b <print_stackframe+0xa8>
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
c01009d9:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01009dc:	89 44 24 08          	mov    %eax,0x8(%esp)
c01009e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009e3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01009e7:	c7 04 24 28 90 10 c0 	movl   $0xc0109028,(%esp)
c01009ee:	e8 64 f9 ff ff       	call   c0100357 <cprintf>
        uint32_t *args = (uint32_t *)ebp + 2;
c01009f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01009f6:	83 c0 08             	add    $0x8,%eax
c01009f9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        for (j = 0; j < 4; j ++) {
c01009fc:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
c0100a03:	eb 1f                	jmp    c0100a24 <print_stackframe+0x71>
            cprintf("0x%08x ", args[j]);
c0100a05:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0100a08:	c1 e0 02             	shl    $0x2,%eax
c0100a0b:	03 45 e4             	add    -0x1c(%ebp),%eax
c0100a0e:	8b 00                	mov    (%eax),%eax
c0100a10:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100a14:	c7 04 24 44 90 10 c0 	movl   $0xc0109044,(%esp)
c0100a1b:	e8 37 f9 ff ff       	call   c0100357 <cprintf>

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
        cprintf("ebp:0x%08x eip:0x%08x args:", ebp, eip);
        uint32_t *args = (uint32_t *)ebp + 2;
        for (j = 0; j < 4; j ++) {
c0100a20:	83 45 e8 01          	addl   $0x1,-0x18(%ebp)
c0100a24:	83 7d e8 03          	cmpl   $0x3,-0x18(%ebp)
c0100a28:	7e db                	jle    c0100a05 <print_stackframe+0x52>
            cprintf("0x%08x ", args[j]);
        }
        cprintf("\n");
c0100a2a:	c7 04 24 4c 90 10 c0 	movl   $0xc010904c,(%esp)
c0100a31:	e8 21 f9 ff ff       	call   c0100357 <cprintf>
        print_debuginfo(eip - 1);
c0100a36:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100a39:	83 e8 01             	sub    $0x1,%eax
c0100a3c:	89 04 24             	mov    %eax,(%esp)
c0100a3f:	e8 ba fe ff ff       	call   c01008fe <print_debuginfo>
        eip = ((uint32_t *)ebp)[1];
c0100a44:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a47:	83 c0 04             	add    $0x4,%eax
c0100a4a:	8b 00                	mov    (%eax),%eax
c0100a4c:	89 45 f0             	mov    %eax,-0x10(%ebp)
        ebp = ((uint32_t *)ebp)[0];
c0100a4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100a52:	8b 00                	mov    (%eax),%eax
c0100a54:	89 45 f4             	mov    %eax,-0xc(%ebp)
      *                   the calling funciton's ebp = ss:[ebp]
      */
          uint32_t ebp = read_ebp(), eip = read_eip();

    int i, j;
    for (i = 0; ebp != 0 && i < STACKFRAME_DEPTH; i ++) {
c0100a57:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0100a5b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100a5f:	74 0a                	je     c0100a6b <print_stackframe+0xb8>
c0100a61:	83 7d ec 13          	cmpl   $0x13,-0x14(%ebp)
c0100a65:	0f 8e 6e ff ff ff    	jle    c01009d9 <print_stackframe+0x26>
        cprintf("\n");
        print_debuginfo(eip - 1);
        eip = ((uint32_t *)ebp)[1];
        ebp = ((uint32_t *)ebp)[0];
    }
}
c0100a6b:	83 c4 34             	add    $0x34,%esp
c0100a6e:	5b                   	pop    %ebx
c0100a6f:	5d                   	pop    %ebp
c0100a70:	c3                   	ret    
c0100a71:	00 00                	add    %al,(%eax)
	...

c0100a74 <parse>:
#define MAXARGS         16
#define WHITESPACE      " \t\n\r"

/* parse - parse the command buffer into whitespace-separated arguments */
static int
parse(char *buf, char **argv) {
c0100a74:	55                   	push   %ebp
c0100a75:	89 e5                	mov    %esp,%ebp
c0100a77:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
c0100a7a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a81:	eb 0d                	jmp    c0100a90 <parse+0x1c>
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
c0100a83:	90                   	nop
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a84:	eb 0a                	jmp    c0100a90 <parse+0x1c>
            *buf ++ = '\0';
c0100a86:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a89:	c6 00 00             	movb   $0x0,(%eax)
c0100a8c:	83 45 08 01          	addl   $0x1,0x8(%ebp)
static int
parse(char *buf, char **argv) {
    int argc = 0;
    while (1) {
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
c0100a90:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a93:	0f b6 00             	movzbl (%eax),%eax
c0100a96:	84 c0                	test   %al,%al
c0100a98:	74 1d                	je     c0100ab7 <parse+0x43>
c0100a9a:	8b 45 08             	mov    0x8(%ebp),%eax
c0100a9d:	0f b6 00             	movzbl (%eax),%eax
c0100aa0:	0f be c0             	movsbl %al,%eax
c0100aa3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100aa7:	c7 04 24 d0 90 10 c0 	movl   $0xc01090d0,(%esp)
c0100aae:	e8 75 80 00 00       	call   c0108b28 <strchr>
c0100ab3:	85 c0                	test   %eax,%eax
c0100ab5:	75 cf                	jne    c0100a86 <parse+0x12>
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
c0100ab7:	8b 45 08             	mov    0x8(%ebp),%eax
c0100aba:	0f b6 00             	movzbl (%eax),%eax
c0100abd:	84 c0                	test   %al,%al
c0100abf:	74 5e                	je     c0100b1f <parse+0xab>
            break;
        }

        // save and scan past next arg
        if (argc == MAXARGS - 1) {
c0100ac1:	83 7d f4 0f          	cmpl   $0xf,-0xc(%ebp)
c0100ac5:	75 14                	jne    c0100adb <parse+0x67>
            cprintf("Too many arguments (max %d).\n", MAXARGS);
c0100ac7:	c7 44 24 04 10 00 00 	movl   $0x10,0x4(%esp)
c0100ace:	00 
c0100acf:	c7 04 24 d5 90 10 c0 	movl   $0xc01090d5,(%esp)
c0100ad6:	e8 7c f8 ff ff       	call   c0100357 <cprintf>
        }
        argv[argc ++] = buf;
c0100adb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100ade:	c1 e0 02             	shl    $0x2,%eax
c0100ae1:	03 45 0c             	add    0xc(%ebp),%eax
c0100ae4:	8b 55 08             	mov    0x8(%ebp),%edx
c0100ae7:	89 10                	mov    %edx,(%eax)
c0100ae9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100aed:	eb 04                	jmp    c0100af3 <parse+0x7f>
            buf ++;
c0100aef:	83 45 08 01          	addl   $0x1,0x8(%ebp)
        // save and scan past next arg
        if (argc == MAXARGS - 1) {
            cprintf("Too many arguments (max %d).\n", MAXARGS);
        }
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
c0100af3:	8b 45 08             	mov    0x8(%ebp),%eax
c0100af6:	0f b6 00             	movzbl (%eax),%eax
c0100af9:	84 c0                	test   %al,%al
c0100afb:	74 86                	je     c0100a83 <parse+0xf>
c0100afd:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b00:	0f b6 00             	movzbl (%eax),%eax
c0100b03:	0f be c0             	movsbl %al,%eax
c0100b06:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b0a:	c7 04 24 d0 90 10 c0 	movl   $0xc01090d0,(%esp)
c0100b11:	e8 12 80 00 00       	call   c0108b28 <strchr>
c0100b16:	85 c0                	test   %eax,%eax
c0100b18:	74 d5                	je     c0100aef <parse+0x7b>
            buf ++;
        }
    }
c0100b1a:	e9 64 ff ff ff       	jmp    c0100a83 <parse+0xf>
        // find global whitespace
        while (*buf != '\0' && strchr(WHITESPACE, *buf) != NULL) {
            *buf ++ = '\0';
        }
        if (*buf == '\0') {
            break;
c0100b1f:	90                   	nop
        argv[argc ++] = buf;
        while (*buf != '\0' && strchr(WHITESPACE, *buf) == NULL) {
            buf ++;
        }
    }
    return argc;
c0100b20:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0100b23:	c9                   	leave  
c0100b24:	c3                   	ret    

c0100b25 <runcmd>:
/* *
 * runcmd - parse the input string, split it into separated arguments
 * and then lookup and invoke some related commands/
 * */
static int
runcmd(char *buf, struct trapframe *tf) {
c0100b25:	55                   	push   %ebp
c0100b26:	89 e5                	mov    %esp,%ebp
c0100b28:	83 ec 68             	sub    $0x68,%esp
    char *argv[MAXARGS];
    int argc = parse(buf, argv);
c0100b2b:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100b32:	8b 45 08             	mov    0x8(%ebp),%eax
c0100b35:	89 04 24             	mov    %eax,(%esp)
c0100b38:	e8 37 ff ff ff       	call   c0100a74 <parse>
c0100b3d:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (argc == 0) {
c0100b40:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0100b44:	75 0a                	jne    c0100b50 <runcmd+0x2b>
        return 0;
c0100b46:	b8 00 00 00 00       	mov    $0x0,%eax
c0100b4b:	e9 85 00 00 00       	jmp    c0100bd5 <runcmd+0xb0>
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100b50:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100b57:	eb 5c                	jmp    c0100bb5 <runcmd+0x90>
        if (strcmp(commands[i].name, argv[0]) == 0) {
c0100b59:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c0100b5c:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b5f:	89 d0                	mov    %edx,%eax
c0100b61:	01 c0                	add    %eax,%eax
c0100b63:	01 d0                	add    %edx,%eax
c0100b65:	c1 e0 02             	shl    $0x2,%eax
c0100b68:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100b6d:	8b 00                	mov    (%eax),%eax
c0100b6f:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0100b73:	89 04 24             	mov    %eax,(%esp)
c0100b76:	e8 08 7f 00 00       	call   c0108a83 <strcmp>
c0100b7b:	85 c0                	test   %eax,%eax
c0100b7d:	75 32                	jne    c0100bb1 <runcmd+0x8c>
            return commands[i].func(argc - 1, argv + 1, tf);
c0100b7f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100b82:	89 d0                	mov    %edx,%eax
c0100b84:	01 c0                	add    %eax,%eax
c0100b86:	01 d0                	add    %edx,%eax
c0100b88:	c1 e0 02             	shl    $0x2,%eax
c0100b8b:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100b90:	8b 50 08             	mov    0x8(%eax),%edx
c0100b93:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100b96:	8d 48 ff             	lea    -0x1(%eax),%ecx
c0100b99:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100b9c:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ba0:	8d 45 b0             	lea    -0x50(%ebp),%eax
c0100ba3:	83 c0 04             	add    $0x4,%eax
c0100ba6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100baa:	89 0c 24             	mov    %ecx,(%esp)
c0100bad:	ff d2                	call   *%edx
c0100baf:	eb 24                	jmp    c0100bd5 <runcmd+0xb0>
    int argc = parse(buf, argv);
    if (argc == 0) {
        return 0;
    }
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100bb1:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100bb5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100bb8:	83 f8 02             	cmp    $0x2,%eax
c0100bbb:	76 9c                	jbe    c0100b59 <runcmd+0x34>
        if (strcmp(commands[i].name, argv[0]) == 0) {
            return commands[i].func(argc - 1, argv + 1, tf);
        }
    }
    cprintf("Unknown command '%s'\n", argv[0]);
c0100bbd:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0100bc0:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100bc4:	c7 04 24 f3 90 10 c0 	movl   $0xc01090f3,(%esp)
c0100bcb:	e8 87 f7 ff ff       	call   c0100357 <cprintf>
    return 0;
c0100bd0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100bd5:	c9                   	leave  
c0100bd6:	c3                   	ret    

c0100bd7 <kmonitor>:

/***** Implementations of basic kernel monitor commands *****/

void
kmonitor(struct trapframe *tf) {
c0100bd7:	55                   	push   %ebp
c0100bd8:	89 e5                	mov    %esp,%ebp
c0100bda:	83 ec 28             	sub    $0x28,%esp
    cprintf("Welcome to the kernel debug monitor!!\n");
c0100bdd:	c7 04 24 0c 91 10 c0 	movl   $0xc010910c,(%esp)
c0100be4:	e8 6e f7 ff ff       	call   c0100357 <cprintf>
    cprintf("Type 'help' for a list of commands.\n");
c0100be9:	c7 04 24 34 91 10 c0 	movl   $0xc0109134,(%esp)
c0100bf0:	e8 62 f7 ff ff       	call   c0100357 <cprintf>

    if (tf != NULL) {
c0100bf5:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100bf9:	74 0e                	je     c0100c09 <kmonitor+0x32>
        print_trapframe(tf);
c0100bfb:	8b 45 08             	mov    0x8(%ebp),%eax
c0100bfe:	89 04 24             	mov    %eax,(%esp)
c0100c01:	e8 a8 17 00 00       	call   c01023ae <print_trapframe>
c0100c06:	eb 01                	jmp    c0100c09 <kmonitor+0x32>
        if ((buf = readline("K> ")) != NULL) {
            if (runcmd(buf, tf) < 0) {
                break;
            }
        }
    }
c0100c08:	90                   	nop
        print_trapframe(tf);
    }

    char *buf;
    while (1) {
        if ((buf = readline("K> ")) != NULL) {
c0100c09:	c7 04 24 59 91 10 c0 	movl   $0xc0109159,(%esp)
c0100c10:	e8 33 f6 ff ff       	call   c0100248 <readline>
c0100c15:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0100c18:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0100c1c:	74 ea                	je     c0100c08 <kmonitor+0x31>
            if (runcmd(buf, tf) < 0) {
c0100c1e:	8b 45 08             	mov    0x8(%ebp),%eax
c0100c21:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c25:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c28:	89 04 24             	mov    %eax,(%esp)
c0100c2b:	e8 f5 fe ff ff       	call   c0100b25 <runcmd>
c0100c30:	85 c0                	test   %eax,%eax
c0100c32:	79 d4                	jns    c0100c08 <kmonitor+0x31>
                break;
c0100c34:	90                   	nop
            }
        }
    }
}
c0100c35:	c9                   	leave  
c0100c36:	c3                   	ret    

c0100c37 <mon_help>:

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
c0100c37:	55                   	push   %ebp
c0100c38:	89 e5                	mov    %esp,%ebp
c0100c3a:	83 ec 28             	sub    $0x28,%esp
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c3d:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0100c44:	eb 3f                	jmp    c0100c85 <mon_help+0x4e>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
c0100c46:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c49:	89 d0                	mov    %edx,%eax
c0100c4b:	01 c0                	add    %eax,%eax
c0100c4d:	01 d0                	add    %edx,%eax
c0100c4f:	c1 e0 02             	shl    $0x2,%eax
c0100c52:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100c57:	8b 48 04             	mov    0x4(%eax),%ecx
c0100c5a:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0100c5d:	89 d0                	mov    %edx,%eax
c0100c5f:	01 c0                	add    %eax,%eax
c0100c61:	01 d0                	add    %edx,%eax
c0100c63:	c1 e0 02             	shl    $0x2,%eax
c0100c66:	05 20 00 12 c0       	add    $0xc0120020,%eax
c0100c6b:	8b 00                	mov    (%eax),%eax
c0100c6d:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0100c71:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100c75:	c7 04 24 5d 91 10 c0 	movl   $0xc010915d,(%esp)
c0100c7c:	e8 d6 f6 ff ff       	call   c0100357 <cprintf>

/* mon_help - print the information about mon_* functions */
int
mon_help(int argc, char **argv, struct trapframe *tf) {
    int i;
    for (i = 0; i < NCOMMANDS; i ++) {
c0100c81:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0100c85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100c88:	83 f8 02             	cmp    $0x2,%eax
c0100c8b:	76 b9                	jbe    c0100c46 <mon_help+0xf>
        cprintf("%s - %s\n", commands[i].name, commands[i].desc);
    }
    return 0;
c0100c8d:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100c92:	c9                   	leave  
c0100c93:	c3                   	ret    

c0100c94 <mon_kerninfo>:
/* *
 * mon_kerninfo - call print_kerninfo in kern/debug/kdebug.c to
 * print the memory occupancy in kernel.
 * */
int
mon_kerninfo(int argc, char **argv, struct trapframe *tf) {
c0100c94:	55                   	push   %ebp
c0100c95:	89 e5                	mov    %esp,%ebp
c0100c97:	83 ec 08             	sub    $0x8,%esp
    print_kerninfo();
c0100c9a:	e8 c7 fb ff ff       	call   c0100866 <print_kerninfo>
    return 0;
c0100c9f:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100ca4:	c9                   	leave  
c0100ca5:	c3                   	ret    

c0100ca6 <mon_backtrace>:
/* *
 * mon_backtrace - call print_stackframe in kern/debug/kdebug.c to
 * print a backtrace of the stack.
 * */
int
mon_backtrace(int argc, char **argv, struct trapframe *tf) {
c0100ca6:	55                   	push   %ebp
c0100ca7:	89 e5                	mov    %esp,%ebp
c0100ca9:	83 ec 08             	sub    $0x8,%esp
    print_stackframe();
c0100cac:	e8 02 fd ff ff       	call   c01009b3 <print_stackframe>
    return 0;
c0100cb1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100cb6:	c9                   	leave  
c0100cb7:	c3                   	ret    

c0100cb8 <__panic>:
/* *
 * __panic - __panic is called on unresolvable fatal errors. it prints
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
c0100cb8:	55                   	push   %ebp
c0100cb9:	89 e5                	mov    %esp,%ebp
c0100cbb:	83 ec 28             	sub    $0x28,%esp
    if (is_panic) {
c0100cbe:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
c0100cc3:	85 c0                	test   %eax,%eax
c0100cc5:	75 4c                	jne    c0100d13 <__panic+0x5b>
        goto panic_dead;
    }
    is_panic = 1;
c0100cc7:	c7 05 a0 0e 12 c0 01 	movl   $0x1,0xc0120ea0
c0100cce:	00 00 00 

    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
c0100cd1:	8d 55 14             	lea    0x14(%ebp),%edx
c0100cd4:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100cd7:	89 10                	mov    %edx,(%eax)
    cprintf("kernel panic at %s:%d:\n    ", file, line);
c0100cd9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100cdc:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100ce0:	8b 45 08             	mov    0x8(%ebp),%eax
c0100ce3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100ce7:	c7 04 24 66 91 10 c0 	movl   $0xc0109166,(%esp)
c0100cee:	e8 64 f6 ff ff       	call   c0100357 <cprintf>
    vcprintf(fmt, ap);
c0100cf3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100cf6:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100cfa:	8b 45 10             	mov    0x10(%ebp),%eax
c0100cfd:	89 04 24             	mov    %eax,(%esp)
c0100d00:	e8 1f f6 ff ff       	call   c0100324 <vcprintf>
    cprintf("\n");
c0100d05:	c7 04 24 82 91 10 c0 	movl   $0xc0109182,(%esp)
c0100d0c:	e8 46 f6 ff ff       	call   c0100357 <cprintf>
c0100d11:	eb 01                	jmp    c0100d14 <__panic+0x5c>
 * "panic: 'message'", and then enters the kernel monitor.
 * */
void
__panic(const char *file, int line, const char *fmt, ...) {
    if (is_panic) {
        goto panic_dead;
c0100d13:	90                   	nop
    vcprintf(fmt, ap);
    cprintf("\n");
    va_end(ap);

panic_dead:
    intr_disable();
c0100d14:	e8 cd 12 00 00       	call   c0101fe6 <intr_disable>
    while (1) {
        kmonitor(NULL);
c0100d19:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100d20:	e8 b2 fe ff ff       	call   c0100bd7 <kmonitor>
    }
c0100d25:	eb f2                	jmp    c0100d19 <__panic+0x61>

c0100d27 <__warn>:
}

/* __warn - like panic, but don't */
void
__warn(const char *file, int line, const char *fmt, ...) {
c0100d27:	55                   	push   %ebp
c0100d28:	89 e5                	mov    %esp,%ebp
c0100d2a:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
c0100d2d:	8d 55 14             	lea    0x14(%ebp),%edx
c0100d30:	8d 45 f4             	lea    -0xc(%ebp),%eax
c0100d33:	89 10                	mov    %edx,(%eax)
    cprintf("kernel warning at %s:%d:\n    ", file, line);
c0100d35:	8b 45 0c             	mov    0xc(%ebp),%eax
c0100d38:	89 44 24 08          	mov    %eax,0x8(%esp)
c0100d3c:	8b 45 08             	mov    0x8(%ebp),%eax
c0100d3f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d43:	c7 04 24 84 91 10 c0 	movl   $0xc0109184,(%esp)
c0100d4a:	e8 08 f6 ff ff       	call   c0100357 <cprintf>
    vcprintf(fmt, ap);
c0100d4f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0100d52:	89 44 24 04          	mov    %eax,0x4(%esp)
c0100d56:	8b 45 10             	mov    0x10(%ebp),%eax
c0100d59:	89 04 24             	mov    %eax,(%esp)
c0100d5c:	e8 c3 f5 ff ff       	call   c0100324 <vcprintf>
    cprintf("\n");
c0100d61:	c7 04 24 82 91 10 c0 	movl   $0xc0109182,(%esp)
c0100d68:	e8 ea f5 ff ff       	call   c0100357 <cprintf>
    va_end(ap);
}
c0100d6d:	c9                   	leave  
c0100d6e:	c3                   	ret    

c0100d6f <is_kernel_panic>:

bool
is_kernel_panic(void) {
c0100d6f:	55                   	push   %ebp
c0100d70:	89 e5                	mov    %esp,%ebp
    return is_panic;
c0100d72:	a1 a0 0e 12 c0       	mov    0xc0120ea0,%eax
}
c0100d77:	5d                   	pop    %ebp
c0100d78:	c3                   	ret    
c0100d79:	00 00                	add    %al,(%eax)
	...

c0100d7c <clock_init>:
/* *
 * clock_init - initialize 8253 clock to interrupt 100 times per second,
 * and then enable IRQ_TIMER.
 * */
void
clock_init(void) {
c0100d7c:	55                   	push   %ebp
c0100d7d:	89 e5                	mov    %esp,%ebp
c0100d7f:	83 ec 28             	sub    $0x28,%esp
c0100d82:	66 c7 45 f6 43 00    	movw   $0x43,-0xa(%ebp)
c0100d88:	c6 45 f5 34          	movb   $0x34,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100d8c:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100d90:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100d94:	ee                   	out    %al,(%dx)
c0100d95:	66 c7 45 f2 40 00    	movw   $0x40,-0xe(%ebp)
c0100d9b:	c6 45 f1 9c          	movb   $0x9c,-0xf(%ebp)
c0100d9f:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100da3:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100da7:	ee                   	out    %al,(%dx)
c0100da8:	66 c7 45 ee 40 00    	movw   $0x40,-0x12(%ebp)
c0100dae:	c6 45 ed 2e          	movb   $0x2e,-0x13(%ebp)
c0100db2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100db6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100dba:	ee                   	out    %al,(%dx)
    outb(TIMER_MODE, TIMER_SEL0 | TIMER_RATEGEN | TIMER_16BIT);
    outb(IO_TIMER1, TIMER_DIV(100) % 256);
    outb(IO_TIMER1, TIMER_DIV(100) / 256);

    // initialize time counter 'ticks' to zero
    ticks = 0;
c0100dbb:	c7 05 bc 1a 12 c0 00 	movl   $0x0,0xc0121abc
c0100dc2:	00 00 00 

    cprintf("++ setup timer interrupts\n");
c0100dc5:	c7 04 24 a2 91 10 c0 	movl   $0xc01091a2,(%esp)
c0100dcc:	e8 86 f5 ff ff       	call   c0100357 <cprintf>
    pic_enable(IRQ_TIMER);
c0100dd1:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0100dd8:	e8 67 12 00 00       	call   c0102044 <pic_enable>
}
c0100ddd:	c9                   	leave  
c0100dde:	c3                   	ret    
	...

c0100de0 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c0100de0:	55                   	push   %ebp
c0100de1:	89 e5                	mov    %esp,%ebp
c0100de3:	53                   	push   %ebx
c0100de4:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c0100de7:	9c                   	pushf  
c0100de8:	5b                   	pop    %ebx
c0100de9:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c0100dec:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c0100def:	25 00 02 00 00       	and    $0x200,%eax
c0100df4:	85 c0                	test   %eax,%eax
c0100df6:	74 0c                	je     c0100e04 <__intr_save+0x24>
        intr_disable();
c0100df8:	e8 e9 11 00 00       	call   c0101fe6 <intr_disable>
        return 1;
c0100dfd:	b8 01 00 00 00       	mov    $0x1,%eax
c0100e02:	eb 05                	jmp    c0100e09 <__intr_save+0x29>
    }
    return 0;
c0100e04:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0100e09:	83 c4 14             	add    $0x14,%esp
c0100e0c:	5b                   	pop    %ebx
c0100e0d:	5d                   	pop    %ebp
c0100e0e:	c3                   	ret    

c0100e0f <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0100e0f:	55                   	push   %ebp
c0100e10:	89 e5                	mov    %esp,%ebp
c0100e12:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0100e15:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0100e19:	74 05                	je     c0100e20 <__intr_restore+0x11>
        intr_enable();
c0100e1b:	e8 c0 11 00 00       	call   c0101fe0 <intr_enable>
    }
}
c0100e20:	c9                   	leave  
c0100e21:	c3                   	ret    

c0100e22 <delay>:
#include <memlayout.h>
#include <sync.h>

/* stupid I/O delay routine necessitated by historical PC design flaws */
static void
delay(void) {
c0100e22:	55                   	push   %ebp
c0100e23:	89 e5                	mov    %esp,%ebp
c0100e25:	53                   	push   %ebx
c0100e26:	83 ec 14             	sub    $0x14,%esp
c0100e29:	66 c7 45 fa 84 00    	movw   $0x84,-0x6(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e2f:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0100e33:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e37:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e3b:	ec                   	in     (%dx),%al
c0100e3c:	89 c3                	mov    %eax,%ebx
c0100e3e:	88 5d f9             	mov    %bl,-0x7(%ebp)
    return data;
c0100e41:	66 c7 45 f6 84 00    	movw   $0x84,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e47:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100e4b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e4f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e53:	ec                   	in     (%dx),%al
c0100e54:	89 c3                	mov    %eax,%ebx
c0100e56:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0100e59:	66 c7 45 f2 84 00    	movw   $0x84,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e5f:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100e63:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e67:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e6b:	ec                   	in     (%dx),%al
c0100e6c:	89 c3                	mov    %eax,%ebx
c0100e6e:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0100e71:	66 c7 45 ee 84 00    	movw   $0x84,-0x12(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100e77:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100e7b:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0100e7f:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100e83:	ec                   	in     (%dx),%al
c0100e84:	89 c3                	mov    %eax,%ebx
c0100e86:	88 5d ed             	mov    %bl,-0x13(%ebp)
    inb(0x84);
    inb(0x84);
    inb(0x84);
    inb(0x84);
}
c0100e89:	83 c4 14             	add    $0x14,%esp
c0100e8c:	5b                   	pop    %ebx
c0100e8d:	5d                   	pop    %ebp
c0100e8e:	c3                   	ret    

c0100e8f <cga_init>:
static uint16_t addr_6845;

/* TEXT-mode CGA/VGA display output */

static void
cga_init(void) {
c0100e8f:	55                   	push   %ebp
c0100e90:	89 e5                	mov    %esp,%ebp
c0100e92:	53                   	push   %ebx
c0100e93:	83 ec 24             	sub    $0x24,%esp
    volatile uint16_t *cp = (uint16_t *)(CGA_BUF + KERNBASE);
c0100e96:	c7 45 f8 00 80 0b c0 	movl   $0xc00b8000,-0x8(%ebp)
    uint16_t was = *cp;
c0100e9d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100ea0:	0f b7 00             	movzwl (%eax),%eax
c0100ea3:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
    *cp = (uint16_t) 0xA55A;
c0100ea7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100eaa:	66 c7 00 5a a5       	movw   $0xa55a,(%eax)
    if (*cp != 0xA55A) {
c0100eaf:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100eb2:	0f b7 00             	movzwl (%eax),%eax
c0100eb5:	66 3d 5a a5          	cmp    $0xa55a,%ax
c0100eb9:	74 12                	je     c0100ecd <cga_init+0x3e>
        cp = (uint16_t*)(MONO_BUF + KERNBASE);
c0100ebb:	c7 45 f8 00 00 0b c0 	movl   $0xc00b0000,-0x8(%ebp)
        addr_6845 = MONO_BASE;
c0100ec2:	66 c7 05 c6 0e 12 c0 	movw   $0x3b4,0xc0120ec6
c0100ec9:	b4 03 
c0100ecb:	eb 13                	jmp    c0100ee0 <cga_init+0x51>
    } else {
        *cp = was;
c0100ecd:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100ed0:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100ed4:	66 89 10             	mov    %dx,(%eax)
        addr_6845 = CGA_BASE;
c0100ed7:	66 c7 05 c6 0e 12 c0 	movw   $0x3d4,0xc0120ec6
c0100ede:	d4 03 
    }

    // Extract cursor location
    uint32_t pos;
    outb(addr_6845, 14);
c0100ee0:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100ee7:	0f b7 c0             	movzwl %ax,%eax
c0100eea:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0100eee:	c6 45 ed 0e          	movb   $0xe,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100ef2:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100ef6:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100efa:	ee                   	out    %al,(%dx)
    pos = inb(addr_6845 + 1) << 8;
c0100efb:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f02:	83 c0 01             	add    $0x1,%eax
c0100f05:	0f b7 c0             	movzwl %ax,%eax
c0100f08:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f0c:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100f10:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100f14:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f18:	ec                   	in     (%dx),%al
c0100f19:	89 c3                	mov    %eax,%ebx
c0100f1b:	88 5d e9             	mov    %bl,-0x17(%ebp)
    return data;
c0100f1e:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100f22:	0f b6 c0             	movzbl %al,%eax
c0100f25:	c1 e0 08             	shl    $0x8,%eax
c0100f28:	89 45 f0             	mov    %eax,-0x10(%ebp)
    outb(addr_6845, 15);
c0100f2b:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f32:	0f b7 c0             	movzwl %ax,%eax
c0100f35:	66 89 45 e6          	mov    %ax,-0x1a(%ebp)
c0100f39:	c6 45 e5 0f          	movb   $0xf,-0x1b(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f3d:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100f41:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100f45:	ee                   	out    %al,(%dx)
    pos |= inb(addr_6845 + 1);
c0100f46:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c0100f4d:	83 c0 01             	add    $0x1,%eax
c0100f50:	0f b7 c0             	movzwl %ax,%eax
c0100f53:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0100f57:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0100f5b:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0100f5f:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0100f63:	ec                   	in     (%dx),%al
c0100f64:	89 c3                	mov    %eax,%ebx
c0100f66:	88 5d e1             	mov    %bl,-0x1f(%ebp)
    return data;
c0100f69:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100f6d:	0f b6 c0             	movzbl %al,%eax
c0100f70:	09 45 f0             	or     %eax,-0x10(%ebp)

    crt_buf = (uint16_t*) cp;
c0100f73:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0100f76:	a3 c0 0e 12 c0       	mov    %eax,0xc0120ec0
    crt_pos = pos;
c0100f7b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0100f7e:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
}
c0100f84:	83 c4 24             	add    $0x24,%esp
c0100f87:	5b                   	pop    %ebx
c0100f88:	5d                   	pop    %ebp
c0100f89:	c3                   	ret    

c0100f8a <serial_init>:

static bool serial_exists = 0;

static void
serial_init(void) {
c0100f8a:	55                   	push   %ebp
c0100f8b:	89 e5                	mov    %esp,%ebp
c0100f8d:	53                   	push   %ebx
c0100f8e:	83 ec 54             	sub    $0x54,%esp
c0100f91:	66 c7 45 f6 fa 03    	movw   $0x3fa,-0xa(%ebp)
c0100f97:	c6 45 f5 00          	movb   $0x0,-0xb(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0100f9b:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0100f9f:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0100fa3:	ee                   	out    %al,(%dx)
c0100fa4:	66 c7 45 f2 fb 03    	movw   $0x3fb,-0xe(%ebp)
c0100faa:	c6 45 f1 80          	movb   $0x80,-0xf(%ebp)
c0100fae:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0100fb2:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0100fb6:	ee                   	out    %al,(%dx)
c0100fb7:	66 c7 45 ee f8 03    	movw   $0x3f8,-0x12(%ebp)
c0100fbd:	c6 45 ed 0c          	movb   $0xc,-0x13(%ebp)
c0100fc1:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0100fc5:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0100fc9:	ee                   	out    %al,(%dx)
c0100fca:	66 c7 45 ea f9 03    	movw   $0x3f9,-0x16(%ebp)
c0100fd0:	c6 45 e9 00          	movb   $0x0,-0x17(%ebp)
c0100fd4:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0100fd8:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0100fdc:	ee                   	out    %al,(%dx)
c0100fdd:	66 c7 45 e6 fb 03    	movw   $0x3fb,-0x1a(%ebp)
c0100fe3:	c6 45 e5 03          	movb   $0x3,-0x1b(%ebp)
c0100fe7:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0100feb:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0100fef:	ee                   	out    %al,(%dx)
c0100ff0:	66 c7 45 e2 fc 03    	movw   $0x3fc,-0x1e(%ebp)
c0100ff6:	c6 45 e1 00          	movb   $0x0,-0x1f(%ebp)
c0100ffa:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0100ffe:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101002:	ee                   	out    %al,(%dx)
c0101003:	66 c7 45 de f9 03    	movw   $0x3f9,-0x22(%ebp)
c0101009:	c6 45 dd 01          	movb   $0x1,-0x23(%ebp)
c010100d:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101011:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101015:	ee                   	out    %al,(%dx)
c0101016:	66 c7 45 da fd 03    	movw   $0x3fd,-0x26(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010101c:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101020:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101024:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101028:	ec                   	in     (%dx),%al
c0101029:	89 c3                	mov    %eax,%ebx
c010102b:	88 5d d9             	mov    %bl,-0x27(%ebp)
    return data;
c010102e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
    // Enable rcv interrupts
    outb(COM1 + COM_IER, COM_IER_RDI);

    // Clear any preexisting overrun indications and interrupts
    // Serial port doesn't exist if COM_LSR returns 0xFF
    serial_exists = (inb(COM1 + COM_LSR) != 0xFF);
c0101032:	3c ff                	cmp    $0xff,%al
c0101034:	0f 95 c0             	setne  %al
c0101037:	0f b6 c0             	movzbl %al,%eax
c010103a:	a3 c8 0e 12 c0       	mov    %eax,0xc0120ec8
c010103f:	66 c7 45 d6 fa 03    	movw   $0x3fa,-0x2a(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101045:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101049:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c010104d:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101051:	ec                   	in     (%dx),%al
c0101052:	89 c3                	mov    %eax,%ebx
c0101054:	88 5d d5             	mov    %bl,-0x2b(%ebp)
    return data;
c0101057:	66 c7 45 d2 f8 03    	movw   $0x3f8,-0x2e(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c010105d:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101061:	66 89 55 c6          	mov    %dx,-0x3a(%ebp)
c0101065:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101069:	ec                   	in     (%dx),%al
c010106a:	89 c3                	mov    %eax,%ebx
c010106c:	88 5d d1             	mov    %bl,-0x2f(%ebp)
    (void) inb(COM1+COM_IIR);
    (void) inb(COM1+COM_RX);

    if (serial_exists) {
c010106f:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c0101074:	85 c0                	test   %eax,%eax
c0101076:	74 0c                	je     c0101084 <serial_init+0xfa>
        pic_enable(IRQ_COM1);
c0101078:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c010107f:	e8 c0 0f 00 00       	call   c0102044 <pic_enable>
    }
}
c0101084:	83 c4 54             	add    $0x54,%esp
c0101087:	5b                   	pop    %ebx
c0101088:	5d                   	pop    %ebp
c0101089:	c3                   	ret    

c010108a <lpt_putc_sub>:

static void
lpt_putc_sub(int c) {
c010108a:	55                   	push   %ebp
c010108b:	89 e5                	mov    %esp,%ebp
c010108d:	53                   	push   %ebx
c010108e:	83 ec 24             	sub    $0x24,%esp
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c0101091:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101098:	eb 09                	jmp    c01010a3 <lpt_putc_sub+0x19>
        delay();
c010109a:	e8 83 fd ff ff       	call   c0100e22 <delay>
}

static void
lpt_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(LPTPORT + 1) & 0x80) && i < 12800; i ++) {
c010109f:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c01010a3:	66 c7 45 f6 79 03    	movw   $0x379,-0xa(%ebp)
c01010a9:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01010ad:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c01010b1:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c01010b5:	ec                   	in     (%dx),%al
c01010b6:	89 c3                	mov    %eax,%ebx
c01010b8:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c01010bb:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01010bf:	84 c0                	test   %al,%al
c01010c1:	78 09                	js     c01010cc <lpt_putc_sub+0x42>
c01010c3:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c01010ca:	7e ce                	jle    c010109a <lpt_putc_sub+0x10>
        delay();
    }
    outb(LPTPORT + 0, c);
c01010cc:	8b 45 08             	mov    0x8(%ebp),%eax
c01010cf:	0f b6 c0             	movzbl %al,%eax
c01010d2:	66 c7 45 f2 78 03    	movw   $0x378,-0xe(%ebp)
c01010d8:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c01010db:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01010df:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01010e3:	ee                   	out    %al,(%dx)
c01010e4:	66 c7 45 ee 7a 03    	movw   $0x37a,-0x12(%ebp)
c01010ea:	c6 45 ed 0d          	movb   $0xd,-0x13(%ebp)
c01010ee:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01010f2:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01010f6:	ee                   	out    %al,(%dx)
c01010f7:	66 c7 45 ea 7a 03    	movw   $0x37a,-0x16(%ebp)
c01010fd:	c6 45 e9 08          	movb   $0x8,-0x17(%ebp)
c0101101:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101105:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101109:	ee                   	out    %al,(%dx)
    outb(LPTPORT + 2, 0x08 | 0x04 | 0x01);
    outb(LPTPORT + 2, 0x08);
}
c010110a:	83 c4 24             	add    $0x24,%esp
c010110d:	5b                   	pop    %ebx
c010110e:	5d                   	pop    %ebp
c010110f:	c3                   	ret    

c0101110 <lpt_putc>:

/* lpt_putc - copy console output to parallel port */
static void
lpt_putc(int c) {
c0101110:	55                   	push   %ebp
c0101111:	89 e5                	mov    %esp,%ebp
c0101113:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101116:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c010111a:	74 0d                	je     c0101129 <lpt_putc+0x19>
        lpt_putc_sub(c);
c010111c:	8b 45 08             	mov    0x8(%ebp),%eax
c010111f:	89 04 24             	mov    %eax,(%esp)
c0101122:	e8 63 ff ff ff       	call   c010108a <lpt_putc_sub>
c0101127:	eb 24                	jmp    c010114d <lpt_putc+0x3d>
    }
    else {
        lpt_putc_sub('\b');
c0101129:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101130:	e8 55 ff ff ff       	call   c010108a <lpt_putc_sub>
        lpt_putc_sub(' ');
c0101135:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c010113c:	e8 49 ff ff ff       	call   c010108a <lpt_putc_sub>
        lpt_putc_sub('\b');
c0101141:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c0101148:	e8 3d ff ff ff       	call   c010108a <lpt_putc_sub>
    }
}
c010114d:	c9                   	leave  
c010114e:	c3                   	ret    

c010114f <cga_putc>:

/* cga_putc - print character to console */
static void
cga_putc(int c) {
c010114f:	55                   	push   %ebp
c0101150:	89 e5                	mov    %esp,%ebp
c0101152:	53                   	push   %ebx
c0101153:	83 ec 34             	sub    $0x34,%esp
    // set black on white
    if (!(c & ~0xFF)) {
c0101156:	8b 45 08             	mov    0x8(%ebp),%eax
c0101159:	b0 00                	mov    $0x0,%al
c010115b:	85 c0                	test   %eax,%eax
c010115d:	75 07                	jne    c0101166 <cga_putc+0x17>
        c |= 0x0700;
c010115f:	81 4d 08 00 07 00 00 	orl    $0x700,0x8(%ebp)
    }

    switch (c & 0xff) {
c0101166:	8b 45 08             	mov    0x8(%ebp),%eax
c0101169:	25 ff 00 00 00       	and    $0xff,%eax
c010116e:	83 f8 0a             	cmp    $0xa,%eax
c0101171:	74 4e                	je     c01011c1 <cga_putc+0x72>
c0101173:	83 f8 0d             	cmp    $0xd,%eax
c0101176:	74 59                	je     c01011d1 <cga_putc+0x82>
c0101178:	83 f8 08             	cmp    $0x8,%eax
c010117b:	0f 85 8c 00 00 00    	jne    c010120d <cga_putc+0xbe>
    case '\b':
        if (crt_pos > 0) {
c0101181:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101188:	66 85 c0             	test   %ax,%ax
c010118b:	0f 84 a1 00 00 00    	je     c0101232 <cga_putc+0xe3>
            crt_pos --;
c0101191:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101198:	83 e8 01             	sub    $0x1,%eax
c010119b:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
c01011a1:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c01011a6:	0f b7 15 c4 0e 12 c0 	movzwl 0xc0120ec4,%edx
c01011ad:	0f b7 d2             	movzwl %dx,%edx
c01011b0:	01 d2                	add    %edx,%edx
c01011b2:	01 c2                	add    %eax,%edx
c01011b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01011b7:	b0 00                	mov    $0x0,%al
c01011b9:	83 c8 20             	or     $0x20,%eax
c01011bc:	66 89 02             	mov    %ax,(%edx)
        }
        break;
c01011bf:	eb 71                	jmp    c0101232 <cga_putc+0xe3>
    case '\n':
        crt_pos += CRT_COLS;
c01011c1:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01011c8:	83 c0 50             	add    $0x50,%eax
c01011cb:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    case '\r':
        crt_pos -= (crt_pos % CRT_COLS);
c01011d1:	0f b7 1d c4 0e 12 c0 	movzwl 0xc0120ec4,%ebx
c01011d8:	0f b7 0d c4 0e 12 c0 	movzwl 0xc0120ec4,%ecx
c01011df:	0f b7 c1             	movzwl %cx,%eax
c01011e2:	69 c0 cd cc 00 00    	imul   $0xcccd,%eax,%eax
c01011e8:	c1 e8 10             	shr    $0x10,%eax
c01011eb:	89 c2                	mov    %eax,%edx
c01011ed:	66 c1 ea 06          	shr    $0x6,%dx
c01011f1:	89 d0                	mov    %edx,%eax
c01011f3:	c1 e0 02             	shl    $0x2,%eax
c01011f6:	01 d0                	add    %edx,%eax
c01011f8:	c1 e0 04             	shl    $0x4,%eax
c01011fb:	89 ca                	mov    %ecx,%edx
c01011fd:	66 29 c2             	sub    %ax,%dx
c0101200:	89 d8                	mov    %ebx,%eax
c0101202:	66 29 d0             	sub    %dx,%ax
c0101205:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
        break;
c010120b:	eb 26                	jmp    c0101233 <cga_putc+0xe4>
    default:
        crt_buf[crt_pos ++] = c;     // write the character
c010120d:	8b 15 c0 0e 12 c0    	mov    0xc0120ec0,%edx
c0101213:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010121a:	0f b7 c8             	movzwl %ax,%ecx
c010121d:	01 c9                	add    %ecx,%ecx
c010121f:	01 d1                	add    %edx,%ecx
c0101221:	8b 55 08             	mov    0x8(%ebp),%edx
c0101224:	66 89 11             	mov    %dx,(%ecx)
c0101227:	83 c0 01             	add    $0x1,%eax
c010122a:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
        break;
c0101230:	eb 01                	jmp    c0101233 <cga_putc+0xe4>
    case '\b':
        if (crt_pos > 0) {
            crt_pos --;
            crt_buf[crt_pos] = (c & ~0xff) | ' ';
        }
        break;
c0101232:	90                   	nop
        crt_buf[crt_pos ++] = c;     // write the character
        break;
    }

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
c0101233:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c010123a:	66 3d cf 07          	cmp    $0x7cf,%ax
c010123e:	76 5b                	jbe    c010129b <cga_putc+0x14c>
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
c0101240:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101245:	8d 90 a0 00 00 00    	lea    0xa0(%eax),%edx
c010124b:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101250:	c7 44 24 08 00 0f 00 	movl   $0xf00,0x8(%esp)
c0101257:	00 
c0101258:	89 54 24 04          	mov    %edx,0x4(%esp)
c010125c:	89 04 24             	mov    %eax,(%esp)
c010125f:	e8 ca 7a 00 00       	call   c0108d2e <memmove>
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c0101264:	c7 45 f4 80 07 00 00 	movl   $0x780,-0xc(%ebp)
c010126b:	eb 15                	jmp    c0101282 <cga_putc+0x133>
            crt_buf[i] = 0x0700 | ' ';
c010126d:	a1 c0 0e 12 c0       	mov    0xc0120ec0,%eax
c0101272:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0101275:	01 d2                	add    %edx,%edx
c0101277:	01 d0                	add    %edx,%eax
c0101279:	66 c7 00 20 07       	movw   $0x720,(%eax)

    // What is the purpose of this?
    if (crt_pos >= CRT_SIZE) {
        int i;
        memmove(crt_buf, crt_buf + CRT_COLS, (CRT_SIZE - CRT_COLS) * sizeof(uint16_t));
        for (i = CRT_SIZE - CRT_COLS; i < CRT_SIZE; i ++) {
c010127e:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0101282:	81 7d f4 cf 07 00 00 	cmpl   $0x7cf,-0xc(%ebp)
c0101289:	7e e2                	jle    c010126d <cga_putc+0x11e>
            crt_buf[i] = 0x0700 | ' ';
        }
        crt_pos -= CRT_COLS;
c010128b:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101292:	83 e8 50             	sub    $0x50,%eax
c0101295:	66 a3 c4 0e 12 c0    	mov    %ax,0xc0120ec4
    }

    // move that little blinky thing
    outb(addr_6845, 14);
c010129b:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c01012a2:	0f b7 c0             	movzwl %ax,%eax
c01012a5:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c01012a9:	c6 45 f1 0e          	movb   $0xe,-0xf(%ebp)
c01012ad:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01012b1:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01012b5:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos >> 8);
c01012b6:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c01012bd:	66 c1 e8 08          	shr    $0x8,%ax
c01012c1:	0f b6 c0             	movzbl %al,%eax
c01012c4:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c01012cb:	83 c2 01             	add    $0x1,%edx
c01012ce:	0f b7 d2             	movzwl %dx,%edx
c01012d1:	66 89 55 ee          	mov    %dx,-0x12(%ebp)
c01012d5:	88 45 ed             	mov    %al,-0x13(%ebp)
c01012d8:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01012dc:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01012e0:	ee                   	out    %al,(%dx)
    outb(addr_6845, 15);
c01012e1:	0f b7 05 c6 0e 12 c0 	movzwl 0xc0120ec6,%eax
c01012e8:	0f b7 c0             	movzwl %ax,%eax
c01012eb:	66 89 45 ea          	mov    %ax,-0x16(%ebp)
c01012ef:	c6 45 e9 0f          	movb   $0xf,-0x17(%ebp)
c01012f3:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01012f7:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01012fb:	ee                   	out    %al,(%dx)
    outb(addr_6845 + 1, crt_pos);
c01012fc:	0f b7 05 c4 0e 12 c0 	movzwl 0xc0120ec4,%eax
c0101303:	0f b6 c0             	movzbl %al,%eax
c0101306:	0f b7 15 c6 0e 12 c0 	movzwl 0xc0120ec6,%edx
c010130d:	83 c2 01             	add    $0x1,%edx
c0101310:	0f b7 d2             	movzwl %dx,%edx
c0101313:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101317:	88 45 e5             	mov    %al,-0x1b(%ebp)
c010131a:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c010131e:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101322:	ee                   	out    %al,(%dx)
}
c0101323:	83 c4 34             	add    $0x34,%esp
c0101326:	5b                   	pop    %ebx
c0101327:	5d                   	pop    %ebp
c0101328:	c3                   	ret    

c0101329 <serial_putc_sub>:

static void
serial_putc_sub(int c) {
c0101329:	55                   	push   %ebp
c010132a:	89 e5                	mov    %esp,%ebp
c010132c:	53                   	push   %ebx
c010132d:	83 ec 14             	sub    $0x14,%esp
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c0101330:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
c0101337:	eb 09                	jmp    c0101342 <serial_putc_sub+0x19>
        delay();
c0101339:	e8 e4 fa ff ff       	call   c0100e22 <delay>
}

static void
serial_putc_sub(int c) {
    int i;
    for (i = 0; !(inb(COM1 + COM_LSR) & COM_LSR_TXRDY) && i < 12800; i ++) {
c010133e:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
c0101342:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101348:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c010134c:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101350:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101354:	ec                   	in     (%dx),%al
c0101355:	89 c3                	mov    %eax,%ebx
c0101357:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c010135a:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c010135e:	0f b6 c0             	movzbl %al,%eax
c0101361:	83 e0 20             	and    $0x20,%eax
c0101364:	85 c0                	test   %eax,%eax
c0101366:	75 09                	jne    c0101371 <serial_putc_sub+0x48>
c0101368:	81 7d f8 ff 31 00 00 	cmpl   $0x31ff,-0x8(%ebp)
c010136f:	7e c8                	jle    c0101339 <serial_putc_sub+0x10>
        delay();
    }
    outb(COM1 + COM_TX, c);
c0101371:	8b 45 08             	mov    0x8(%ebp),%eax
c0101374:	0f b6 c0             	movzbl %al,%eax
c0101377:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
c010137d:	88 45 f1             	mov    %al,-0xf(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101380:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c0101384:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101388:	ee                   	out    %al,(%dx)
}
c0101389:	83 c4 14             	add    $0x14,%esp
c010138c:	5b                   	pop    %ebx
c010138d:	5d                   	pop    %ebp
c010138e:	c3                   	ret    

c010138f <serial_putc>:

/* serial_putc - print character to serial port */
static void
serial_putc(int c) {
c010138f:	55                   	push   %ebp
c0101390:	89 e5                	mov    %esp,%ebp
c0101392:	83 ec 04             	sub    $0x4,%esp
    if (c != '\b') {
c0101395:	83 7d 08 08          	cmpl   $0x8,0x8(%ebp)
c0101399:	74 0d                	je     c01013a8 <serial_putc+0x19>
        serial_putc_sub(c);
c010139b:	8b 45 08             	mov    0x8(%ebp),%eax
c010139e:	89 04 24             	mov    %eax,(%esp)
c01013a1:	e8 83 ff ff ff       	call   c0101329 <serial_putc_sub>
c01013a6:	eb 24                	jmp    c01013cc <serial_putc+0x3d>
    }
    else {
        serial_putc_sub('\b');
c01013a8:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013af:	e8 75 ff ff ff       	call   c0101329 <serial_putc_sub>
        serial_putc_sub(' ');
c01013b4:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c01013bb:	e8 69 ff ff ff       	call   c0101329 <serial_putc_sub>
        serial_putc_sub('\b');
c01013c0:	c7 04 24 08 00 00 00 	movl   $0x8,(%esp)
c01013c7:	e8 5d ff ff ff       	call   c0101329 <serial_putc_sub>
    }
}
c01013cc:	c9                   	leave  
c01013cd:	c3                   	ret    

c01013ce <cons_intr>:
/* *
 * cons_intr - called by device interrupt routines to feed input
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
c01013ce:	55                   	push   %ebp
c01013cf:	89 e5                	mov    %esp,%ebp
c01013d1:	83 ec 18             	sub    $0x18,%esp
    int c;
    while ((c = (*proc)()) != -1) {
c01013d4:	eb 32                	jmp    c0101408 <cons_intr+0x3a>
        if (c != 0) {
c01013d6:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01013da:	74 2c                	je     c0101408 <cons_intr+0x3a>
            cons.buf[cons.wpos ++] = c;
c01013dc:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c01013e1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01013e4:	88 90 e0 0e 12 c0    	mov    %dl,-0x3fedf120(%eax)
c01013ea:	83 c0 01             	add    $0x1,%eax
c01013ed:	a3 e4 10 12 c0       	mov    %eax,0xc01210e4
            if (cons.wpos == CONSBUFSIZE) {
c01013f2:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c01013f7:	3d 00 02 00 00       	cmp    $0x200,%eax
c01013fc:	75 0a                	jne    c0101408 <cons_intr+0x3a>
                cons.wpos = 0;
c01013fe:	c7 05 e4 10 12 c0 00 	movl   $0x0,0xc01210e4
c0101405:	00 00 00 
 * characters into the circular console input buffer.
 * */
static void
cons_intr(int (*proc)(void)) {
    int c;
    while ((c = (*proc)()) != -1) {
c0101408:	8b 45 08             	mov    0x8(%ebp),%eax
c010140b:	ff d0                	call   *%eax
c010140d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101410:	83 7d f4 ff          	cmpl   $0xffffffff,-0xc(%ebp)
c0101414:	75 c0                	jne    c01013d6 <cons_intr+0x8>
            if (cons.wpos == CONSBUFSIZE) {
                cons.wpos = 0;
            }
        }
    }
}
c0101416:	c9                   	leave  
c0101417:	c3                   	ret    

c0101418 <serial_proc_data>:

/* serial_proc_data - get data from serial port */
static int
serial_proc_data(void) {
c0101418:	55                   	push   %ebp
c0101419:	89 e5                	mov    %esp,%ebp
c010141b:	53                   	push   %ebx
c010141c:	83 ec 14             	sub    $0x14,%esp
c010141f:	66 c7 45 f6 fd 03    	movw   $0x3fd,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101425:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101429:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010142d:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101431:	ec                   	in     (%dx),%al
c0101432:	89 c3                	mov    %eax,%ebx
c0101434:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0101437:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
    if (!(inb(COM1 + COM_LSR) & COM_LSR_DATA)) {
c010143b:	0f b6 c0             	movzbl %al,%eax
c010143e:	83 e0 01             	and    $0x1,%eax
c0101441:	85 c0                	test   %eax,%eax
c0101443:	75 07                	jne    c010144c <serial_proc_data+0x34>
        return -1;
c0101445:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010144a:	eb 32                	jmp    c010147e <serial_proc_data+0x66>
c010144c:	66 c7 45 f2 f8 03    	movw   $0x3f8,-0xe(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101452:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101456:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c010145a:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010145e:	ec                   	in     (%dx),%al
c010145f:	89 c3                	mov    %eax,%ebx
c0101461:	88 5d f1             	mov    %bl,-0xf(%ebp)
    return data;
c0101464:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
    }
    int c = inb(COM1 + COM_RX);
c0101468:	0f b6 c0             	movzbl %al,%eax
c010146b:	89 45 f8             	mov    %eax,-0x8(%ebp)
    if (c == 127) {
c010146e:	83 7d f8 7f          	cmpl   $0x7f,-0x8(%ebp)
c0101472:	75 07                	jne    c010147b <serial_proc_data+0x63>
        c = '\b';
c0101474:	c7 45 f8 08 00 00 00 	movl   $0x8,-0x8(%ebp)
    }
    return c;
c010147b:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c010147e:	83 c4 14             	add    $0x14,%esp
c0101481:	5b                   	pop    %ebx
c0101482:	5d                   	pop    %ebp
c0101483:	c3                   	ret    

c0101484 <serial_intr>:

/* serial_intr - try to feed input characters from serial port */
void
serial_intr(void) {
c0101484:	55                   	push   %ebp
c0101485:	89 e5                	mov    %esp,%ebp
c0101487:	83 ec 18             	sub    $0x18,%esp
    if (serial_exists) {
c010148a:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c010148f:	85 c0                	test   %eax,%eax
c0101491:	74 0c                	je     c010149f <serial_intr+0x1b>
        cons_intr(serial_proc_data);
c0101493:	c7 04 24 18 14 10 c0 	movl   $0xc0101418,(%esp)
c010149a:	e8 2f ff ff ff       	call   c01013ce <cons_intr>
    }
}
c010149f:	c9                   	leave  
c01014a0:	c3                   	ret    

c01014a1 <kbd_proc_data>:
 *
 * The kbd_proc_data() function gets data from the keyboard.
 * If we finish a character, return it, else 0. And return -1 if no data.
 * */
static int
kbd_proc_data(void) {
c01014a1:	55                   	push   %ebp
c01014a2:	89 e5                	mov    %esp,%ebp
c01014a4:	53                   	push   %ebx
c01014a5:	83 ec 44             	sub    $0x44,%esp
c01014a8:	66 c7 45 f0 64 00    	movw   $0x64,-0x10(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014ae:	0f b7 55 f0          	movzwl -0x10(%ebp),%edx
c01014b2:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01014b6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01014ba:	ec                   	in     (%dx),%al
c01014bb:	89 c3                	mov    %eax,%ebx
c01014bd:	88 5d ef             	mov    %bl,-0x11(%ebp)
    return data;
c01014c0:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
    int c;
    uint8_t data;
    static uint32_t shift;

    if ((inb(KBSTATP) & KBS_DIB) == 0) {
c01014c4:	0f b6 c0             	movzbl %al,%eax
c01014c7:	83 e0 01             	and    $0x1,%eax
c01014ca:	85 c0                	test   %eax,%eax
c01014cc:	75 0a                	jne    c01014d8 <kbd_proc_data+0x37>
        return -1;
c01014ce:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c01014d3:	e9 61 01 00 00       	jmp    c0101639 <kbd_proc_data+0x198>
c01014d8:	66 c7 45 ec 60 00    	movw   $0x60,-0x14(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c01014de:	0f b7 55 ec          	movzwl -0x14(%ebp),%edx
c01014e2:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c01014e6:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c01014ea:	ec                   	in     (%dx),%al
c01014eb:	89 c3                	mov    %eax,%ebx
c01014ed:	88 5d eb             	mov    %bl,-0x15(%ebp)
    return data;
c01014f0:	0f b6 45 eb          	movzbl -0x15(%ebp),%eax
    }

    data = inb(KBDATAP);
c01014f4:	88 45 f3             	mov    %al,-0xd(%ebp)

    if (data == 0xE0) {
c01014f7:	80 7d f3 e0          	cmpb   $0xe0,-0xd(%ebp)
c01014fb:	75 17                	jne    c0101514 <kbd_proc_data+0x73>
        // E0 escape character
        shift |= E0ESC;
c01014fd:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101502:	83 c8 40             	or     $0x40,%eax
c0101505:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c010150a:	b8 00 00 00 00       	mov    $0x0,%eax
c010150f:	e9 25 01 00 00       	jmp    c0101639 <kbd_proc_data+0x198>
    } else if (data & 0x80) {
c0101514:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101518:	84 c0                	test   %al,%al
c010151a:	79 47                	jns    c0101563 <kbd_proc_data+0xc2>
        // Key released
        data = (shift & E0ESC ? data : data & 0x7F);
c010151c:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101521:	83 e0 40             	and    $0x40,%eax
c0101524:	85 c0                	test   %eax,%eax
c0101526:	75 09                	jne    c0101531 <kbd_proc_data+0x90>
c0101528:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010152c:	83 e0 7f             	and    $0x7f,%eax
c010152f:	eb 04                	jmp    c0101535 <kbd_proc_data+0x94>
c0101531:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101535:	88 45 f3             	mov    %al,-0xd(%ebp)
        shift &= ~(shiftcode[data] | E0ESC);
c0101538:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010153c:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c0101543:	83 c8 40             	or     $0x40,%eax
c0101546:	0f b6 c0             	movzbl %al,%eax
c0101549:	f7 d0                	not    %eax
c010154b:	89 c2                	mov    %eax,%edx
c010154d:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101552:	21 d0                	and    %edx,%eax
c0101554:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
        return 0;
c0101559:	b8 00 00 00 00       	mov    $0x0,%eax
c010155e:	e9 d6 00 00 00       	jmp    c0101639 <kbd_proc_data+0x198>
    } else if (shift & E0ESC) {
c0101563:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101568:	83 e0 40             	and    $0x40,%eax
c010156b:	85 c0                	test   %eax,%eax
c010156d:	74 11                	je     c0101580 <kbd_proc_data+0xdf>
        // Last character was an E0 escape; or with 0x80
        data |= 0x80;
c010156f:	80 4d f3 80          	orb    $0x80,-0xd(%ebp)
        shift &= ~E0ESC;
c0101573:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101578:	83 e0 bf             	and    $0xffffffbf,%eax
c010157b:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    }

    shift |= shiftcode[data];
c0101580:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c0101584:	0f b6 80 60 00 12 c0 	movzbl -0x3fedffa0(%eax),%eax
c010158b:	0f b6 d0             	movzbl %al,%edx
c010158e:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101593:	09 d0                	or     %edx,%eax
c0101595:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8
    shift ^= togglecode[data];
c010159a:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c010159e:	0f b6 80 60 01 12 c0 	movzbl -0x3fedfea0(%eax),%eax
c01015a5:	0f b6 d0             	movzbl %al,%edx
c01015a8:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01015ad:	31 d0                	xor    %edx,%eax
c01015af:	a3 e8 10 12 c0       	mov    %eax,0xc01210e8

    c = charcode[shift & (CTL | SHIFT)][data];
c01015b4:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01015b9:	83 e0 03             	and    $0x3,%eax
c01015bc:	8b 14 85 60 05 12 c0 	mov    -0x3fedfaa0(,%eax,4),%edx
c01015c3:	0f b6 45 f3          	movzbl -0xd(%ebp),%eax
c01015c7:	01 d0                	add    %edx,%eax
c01015c9:	0f b6 00             	movzbl (%eax),%eax
c01015cc:	0f b6 c0             	movzbl %al,%eax
c01015cf:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (shift & CAPSLOCK) {
c01015d2:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c01015d7:	83 e0 08             	and    $0x8,%eax
c01015da:	85 c0                	test   %eax,%eax
c01015dc:	74 22                	je     c0101600 <kbd_proc_data+0x15f>
        if ('a' <= c && c <= 'z')
c01015de:	83 7d f4 60          	cmpl   $0x60,-0xc(%ebp)
c01015e2:	7e 0c                	jle    c01015f0 <kbd_proc_data+0x14f>
c01015e4:	83 7d f4 7a          	cmpl   $0x7a,-0xc(%ebp)
c01015e8:	7f 06                	jg     c01015f0 <kbd_proc_data+0x14f>
            c += 'A' - 'a';
c01015ea:	83 6d f4 20          	subl   $0x20,-0xc(%ebp)
c01015ee:	eb 10                	jmp    c0101600 <kbd_proc_data+0x15f>
        else if ('A' <= c && c <= 'Z')
c01015f0:	83 7d f4 40          	cmpl   $0x40,-0xc(%ebp)
c01015f4:	7e 0a                	jle    c0101600 <kbd_proc_data+0x15f>
c01015f6:	83 7d f4 5a          	cmpl   $0x5a,-0xc(%ebp)
c01015fa:	7f 04                	jg     c0101600 <kbd_proc_data+0x15f>
            c += 'a' - 'A';
c01015fc:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
    }

    // Process special keys
    // Ctrl-Alt-Del: reboot
    if (!(~shift & (CTL | ALT)) && c == KEY_DEL) {
c0101600:	a1 e8 10 12 c0       	mov    0xc01210e8,%eax
c0101605:	f7 d0                	not    %eax
c0101607:	83 e0 06             	and    $0x6,%eax
c010160a:	85 c0                	test   %eax,%eax
c010160c:	75 28                	jne    c0101636 <kbd_proc_data+0x195>
c010160e:	81 7d f4 e9 00 00 00 	cmpl   $0xe9,-0xc(%ebp)
c0101615:	75 1f                	jne    c0101636 <kbd_proc_data+0x195>
        cprintf("Rebooting!\n");
c0101617:	c7 04 24 bd 91 10 c0 	movl   $0xc01091bd,(%esp)
c010161e:	e8 34 ed ff ff       	call   c0100357 <cprintf>
c0101623:	66 c7 45 e8 92 00    	movw   $0x92,-0x18(%ebp)
c0101629:	c6 45 e7 03          	movb   $0x3,-0x19(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010162d:	0f b6 45 e7          	movzbl -0x19(%ebp),%eax
c0101631:	0f b7 55 e8          	movzwl -0x18(%ebp),%edx
c0101635:	ee                   	out    %al,(%dx)
        outb(0x92, 0x3); // courtesy of Chris Frost
    }
    return c;
c0101636:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101639:	83 c4 44             	add    $0x44,%esp
c010163c:	5b                   	pop    %ebx
c010163d:	5d                   	pop    %ebp
c010163e:	c3                   	ret    

c010163f <kbd_intr>:

/* kbd_intr - try to feed input characters from keyboard */
static void
kbd_intr(void) {
c010163f:	55                   	push   %ebp
c0101640:	89 e5                	mov    %esp,%ebp
c0101642:	83 ec 18             	sub    $0x18,%esp
    cons_intr(kbd_proc_data);
c0101645:	c7 04 24 a1 14 10 c0 	movl   $0xc01014a1,(%esp)
c010164c:	e8 7d fd ff ff       	call   c01013ce <cons_intr>
}
c0101651:	c9                   	leave  
c0101652:	c3                   	ret    

c0101653 <kbd_init>:

static void
kbd_init(void) {
c0101653:	55                   	push   %ebp
c0101654:	89 e5                	mov    %esp,%ebp
c0101656:	83 ec 18             	sub    $0x18,%esp
    // drain the kbd buffer
    kbd_intr();
c0101659:	e8 e1 ff ff ff       	call   c010163f <kbd_intr>
    pic_enable(IRQ_KBD);
c010165e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0101665:	e8 da 09 00 00       	call   c0102044 <pic_enable>
}
c010166a:	c9                   	leave  
c010166b:	c3                   	ret    

c010166c <cons_init>:

/* cons_init - initializes the console devices */
void
cons_init(void) {
c010166c:	55                   	push   %ebp
c010166d:	89 e5                	mov    %esp,%ebp
c010166f:	83 ec 18             	sub    $0x18,%esp
    cga_init();
c0101672:	e8 18 f8 ff ff       	call   c0100e8f <cga_init>
    serial_init();
c0101677:	e8 0e f9 ff ff       	call   c0100f8a <serial_init>
    kbd_init();
c010167c:	e8 d2 ff ff ff       	call   c0101653 <kbd_init>
    if (!serial_exists) {
c0101681:	a1 c8 0e 12 c0       	mov    0xc0120ec8,%eax
c0101686:	85 c0                	test   %eax,%eax
c0101688:	75 0c                	jne    c0101696 <cons_init+0x2a>
        cprintf("serial port does not exist!!\n");
c010168a:	c7 04 24 c9 91 10 c0 	movl   $0xc01091c9,(%esp)
c0101691:	e8 c1 ec ff ff       	call   c0100357 <cprintf>
    }
}
c0101696:	c9                   	leave  
c0101697:	c3                   	ret    

c0101698 <cons_putc>:

/* cons_putc - print a single character @c to console devices */
void
cons_putc(int c) {
c0101698:	55                   	push   %ebp
c0101699:	89 e5                	mov    %esp,%ebp
c010169b:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c010169e:	e8 3d f7 ff ff       	call   c0100de0 <__intr_save>
c01016a3:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        lpt_putc(c);
c01016a6:	8b 45 08             	mov    0x8(%ebp),%eax
c01016a9:	89 04 24             	mov    %eax,(%esp)
c01016ac:	e8 5f fa ff ff       	call   c0101110 <lpt_putc>
        cga_putc(c);
c01016b1:	8b 45 08             	mov    0x8(%ebp),%eax
c01016b4:	89 04 24             	mov    %eax,(%esp)
c01016b7:	e8 93 fa ff ff       	call   c010114f <cga_putc>
        serial_putc(c);
c01016bc:	8b 45 08             	mov    0x8(%ebp),%eax
c01016bf:	89 04 24             	mov    %eax,(%esp)
c01016c2:	e8 c8 fc ff ff       	call   c010138f <serial_putc>
    }
    local_intr_restore(intr_flag);
c01016c7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01016ca:	89 04 24             	mov    %eax,(%esp)
c01016cd:	e8 3d f7 ff ff       	call   c0100e0f <__intr_restore>
}
c01016d2:	c9                   	leave  
c01016d3:	c3                   	ret    

c01016d4 <cons_getc>:
/* *
 * cons_getc - return the next input character from console,
 * or 0 if none waiting.
 * */
int
cons_getc(void) {
c01016d4:	55                   	push   %ebp
c01016d5:	89 e5                	mov    %esp,%ebp
c01016d7:	83 ec 28             	sub    $0x28,%esp
    int c = 0;
c01016da:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    local_intr_save(intr_flag);
c01016e1:	e8 fa f6 ff ff       	call   c0100de0 <__intr_save>
c01016e6:	89 45 f0             	mov    %eax,-0x10(%ebp)
    {
        // poll for any pending input characters,
        // so that this function works even when interrupts are disabled
        // (e.g., when called from the kernel monitor).
        serial_intr();
c01016e9:	e8 96 fd ff ff       	call   c0101484 <serial_intr>
        kbd_intr();
c01016ee:	e8 4c ff ff ff       	call   c010163f <kbd_intr>

        // grab the next character from the input buffer.
        if (cons.rpos != cons.wpos) {
c01016f3:	8b 15 e0 10 12 c0    	mov    0xc01210e0,%edx
c01016f9:	a1 e4 10 12 c0       	mov    0xc01210e4,%eax
c01016fe:	39 c2                	cmp    %eax,%edx
c0101700:	74 30                	je     c0101732 <cons_getc+0x5e>
            c = cons.buf[cons.rpos ++];
c0101702:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c0101707:	0f b6 90 e0 0e 12 c0 	movzbl -0x3fedf120(%eax),%edx
c010170e:	0f b6 d2             	movzbl %dl,%edx
c0101711:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0101714:	83 c0 01             	add    $0x1,%eax
c0101717:	a3 e0 10 12 c0       	mov    %eax,0xc01210e0
            if (cons.rpos == CONSBUFSIZE) {
c010171c:	a1 e0 10 12 c0       	mov    0xc01210e0,%eax
c0101721:	3d 00 02 00 00       	cmp    $0x200,%eax
c0101726:	75 0a                	jne    c0101732 <cons_getc+0x5e>
                cons.rpos = 0;
c0101728:	c7 05 e0 10 12 c0 00 	movl   $0x0,0xc01210e0
c010172f:	00 00 00 
            }
        }
    }
    local_intr_restore(intr_flag);
c0101732:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0101735:	89 04 24             	mov    %eax,(%esp)
c0101738:	e8 d2 f6 ff ff       	call   c0100e0f <__intr_restore>
    return c;
c010173d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101740:	c9                   	leave  
c0101741:	c3                   	ret    
	...

c0101744 <ide_wait_ready>:
    unsigned int size;          // Size in Sectors
    unsigned char model[41];    // Model in String
} ide_devices[MAX_IDE];

static int
ide_wait_ready(unsigned short iobase, bool check_error) {
c0101744:	55                   	push   %ebp
c0101745:	89 e5                	mov    %esp,%ebp
c0101747:	53                   	push   %ebx
c0101748:	83 ec 14             	sub    $0x14,%esp
c010174b:	8b 45 08             	mov    0x8(%ebp),%eax
c010174e:	66 89 45 e8          	mov    %ax,-0x18(%ebp)
    int r;
    while ((r = inb(iobase + ISA_STATUS)) & IDE_BSY)
c0101752:	90                   	nop
c0101753:	0f b7 45 e8          	movzwl -0x18(%ebp),%eax
c0101757:	83 c0 07             	add    $0x7,%eax
c010175a:	0f b7 c0             	movzwl %ax,%eax
c010175d:	66 89 45 f6          	mov    %ax,-0xa(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101761:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c0101765:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101769:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c010176d:	ec                   	in     (%dx),%al
c010176e:	89 c3                	mov    %eax,%ebx
c0101770:	88 5d f5             	mov    %bl,-0xb(%ebp)
    return data;
c0101773:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c0101777:	0f b6 c0             	movzbl %al,%eax
c010177a:	89 45 f8             	mov    %eax,-0x8(%ebp)
c010177d:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101780:	25 80 00 00 00       	and    $0x80,%eax
c0101785:	85 c0                	test   %eax,%eax
c0101787:	75 ca                	jne    c0101753 <ide_wait_ready+0xf>
        /* nothing */;
    if (check_error && (r & (IDE_DF | IDE_ERR)) != 0) {
c0101789:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c010178d:	74 11                	je     c01017a0 <ide_wait_ready+0x5c>
c010178f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0101792:	83 e0 21             	and    $0x21,%eax
c0101795:	85 c0                	test   %eax,%eax
c0101797:	74 07                	je     c01017a0 <ide_wait_ready+0x5c>
        return -1;
c0101799:	b8 ff ff ff ff       	mov    $0xffffffff,%eax
c010179e:	eb 05                	jmp    c01017a5 <ide_wait_ready+0x61>
    }
    return 0;
c01017a0:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01017a5:	83 c4 14             	add    $0x14,%esp
c01017a8:	5b                   	pop    %ebx
c01017a9:	5d                   	pop    %ebp
c01017aa:	c3                   	ret    

c01017ab <ide_init>:

void
ide_init(void) {
c01017ab:	55                   	push   %ebp
c01017ac:	89 e5                	mov    %esp,%ebp
c01017ae:	57                   	push   %edi
c01017af:	56                   	push   %esi
c01017b0:	53                   	push   %ebx
c01017b1:	81 ec 6c 02 00 00    	sub    $0x26c,%esp
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c01017b7:	66 c7 45 e6 00 00    	movw   $0x0,-0x1a(%ebp)
c01017bd:	e9 e3 02 00 00       	jmp    c0101aa5 <ide_init+0x2fa>
        /* assume that no device here */
        ide_devices[ideno].valid = 0;
c01017c2:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01017c6:	c1 e0 03             	shl    $0x3,%eax
c01017c9:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01017d0:	29 c2                	sub    %eax,%edx
c01017d2:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01017d8:	c6 00 00             	movb   $0x0,(%eax)

        iobase = IO_BASE(ideno);
c01017db:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01017df:	66 d1 e8             	shr    %ax
c01017e2:	0f b7 c0             	movzwl %ax,%eax
c01017e5:	0f b7 04 85 e8 91 10 	movzwl -0x3fef6e18(,%eax,4),%eax
c01017ec:	c0 
c01017ed:	66 89 45 da          	mov    %ax,-0x26(%ebp)

        /* wait device ready */
        ide_wait_ready(iobase, 0);
c01017f1:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01017f5:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01017fc:	00 
c01017fd:	89 04 24             	mov    %eax,(%esp)
c0101800:	e8 3f ff ff ff       	call   c0101744 <ide_wait_ready>

        /* step1: select drive */
        outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4));
c0101805:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101809:	83 e0 01             	and    $0x1,%eax
c010180c:	c1 e0 04             	shl    $0x4,%eax
c010180f:	83 c8 e0             	or     $0xffffffe0,%eax
c0101812:	0f b6 c0             	movzbl %al,%eax
c0101815:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101819:	83 c2 06             	add    $0x6,%edx
c010181c:	0f b7 d2             	movzwl %dx,%edx
c010181f:	66 89 55 c2          	mov    %dx,-0x3e(%ebp)
c0101823:	88 45 c1             	mov    %al,-0x3f(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101826:	0f b6 45 c1          	movzbl -0x3f(%ebp),%eax
c010182a:	0f b7 55 c2          	movzwl -0x3e(%ebp),%edx
c010182e:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010182f:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101833:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010183a:	00 
c010183b:	89 04 24             	mov    %eax,(%esp)
c010183e:	e8 01 ff ff ff       	call   c0101744 <ide_wait_ready>

        /* step2: send ATA identify command */
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
c0101843:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101847:	83 c0 07             	add    $0x7,%eax
c010184a:	0f b7 c0             	movzwl %ax,%eax
c010184d:	66 89 45 be          	mov    %ax,-0x42(%ebp)
c0101851:	c6 45 bd ec          	movb   $0xec,-0x43(%ebp)
c0101855:	0f b6 45 bd          	movzbl -0x43(%ebp),%eax
c0101859:	0f b7 55 be          	movzwl -0x42(%ebp),%edx
c010185d:	ee                   	out    %al,(%dx)
        ide_wait_ready(iobase, 0);
c010185e:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101862:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101869:	00 
c010186a:	89 04 24             	mov    %eax,(%esp)
c010186d:	e8 d2 fe ff ff       	call   c0101744 <ide_wait_ready>

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
c0101872:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c0101876:	83 c0 07             	add    $0x7,%eax
c0101879:	0f b7 c0             	movzwl %ax,%eax
c010187c:	66 89 45 ba          	mov    %ax,-0x46(%ebp)
static inline void invlpg(void *addr) __attribute__((always_inline));

static inline uint8_t
inb(uint16_t port) {
    uint8_t data;
    asm volatile ("inb %1, %0" : "=a" (data) : "d" (port) : "memory");
c0101880:	0f b7 55 ba          	movzwl -0x46(%ebp),%edx
c0101884:	66 89 95 a6 fd ff ff 	mov    %dx,-0x25a(%ebp)
c010188b:	0f b7 95 a6 fd ff ff 	movzwl -0x25a(%ebp),%edx
c0101892:	ec                   	in     (%dx),%al
c0101893:	89 c3                	mov    %eax,%ebx
c0101895:	88 5d b9             	mov    %bl,-0x47(%ebp)
    return data;
c0101898:	0f b6 45 b9          	movzbl -0x47(%ebp),%eax
c010189c:	84 c0                	test   %al,%al
c010189e:	0f 84 fb 01 00 00    	je     c0101a9f <ide_init+0x2f4>
c01018a4:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01018a8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01018af:	00 
c01018b0:	89 04 24             	mov    %eax,(%esp)
c01018b3:	e8 8c fe ff ff       	call   c0101744 <ide_wait_ready>
c01018b8:	85 c0                	test   %eax,%eax
c01018ba:	0f 85 df 01 00 00    	jne    c0101a9f <ide_init+0x2f4>
            continue ;
        }

        /* device is ok */
        ide_devices[ideno].valid = 1;
c01018c0:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01018c4:	c1 e0 03             	shl    $0x3,%eax
c01018c7:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01018ce:	29 c2                	sub    %eax,%edx
c01018d0:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01018d6:	c6 00 01             	movb   $0x1,(%eax)

        /* read identification space of the device */
        unsigned int buffer[128];
        insl(iobase + ISA_DATA, buffer, sizeof(buffer) / sizeof(unsigned int));
c01018d9:	0f b7 45 da          	movzwl -0x26(%ebp),%eax
c01018dd:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01018e0:	8d 85 ac fd ff ff    	lea    -0x254(%ebp),%eax
c01018e6:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01018e9:	c7 45 ac 80 00 00 00 	movl   $0x80,-0x54(%ebp)
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c01018f0:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01018f3:	8b 4d b0             	mov    -0x50(%ebp),%ecx
c01018f6:	8b 55 ac             	mov    -0x54(%ebp),%edx
c01018f9:	89 ce                	mov    %ecx,%esi
c01018fb:	89 d3                	mov    %edx,%ebx
c01018fd:	89 f7                	mov    %esi,%edi
c01018ff:	89 d9                	mov    %ebx,%ecx
c0101901:	89 c2                	mov    %eax,%edx
c0101903:	fc                   	cld    
c0101904:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101906:	89 cb                	mov    %ecx,%ebx
c0101908:	89 fe                	mov    %edi,%esi
c010190a:	89 75 b0             	mov    %esi,-0x50(%ebp)
c010190d:	89 5d ac             	mov    %ebx,-0x54(%ebp)

        unsigned char *ident = (unsigned char *)buffer;
c0101910:	8d 85 ac fd ff ff    	lea    -0x254(%ebp),%eax
c0101916:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        unsigned int sectors;
        unsigned int cmdsets = *(unsigned int *)(ident + IDE_IDENT_CMDSETS);
c0101919:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010191c:	8b 80 a4 00 00 00    	mov    0xa4(%eax),%eax
c0101922:	89 45 d0             	mov    %eax,-0x30(%ebp)
        /* device use 48-bits or 28-bits addressing */
        if (cmdsets & (1 << 26)) {
c0101925:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101928:	25 00 00 00 04       	and    $0x4000000,%eax
c010192d:	85 c0                	test   %eax,%eax
c010192f:	74 0e                	je     c010193f <ide_init+0x194>
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA_EXT);
c0101931:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101934:	8b 80 c8 00 00 00    	mov    0xc8(%eax),%eax
c010193a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c010193d:	eb 09                	jmp    c0101948 <ide_init+0x19d>
        }
        else {
            sectors = *(unsigned int *)(ident + IDE_IDENT_MAX_LBA);
c010193f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101942:	8b 40 78             	mov    0x78(%eax),%eax
c0101945:	89 45 e0             	mov    %eax,-0x20(%ebp)
        }
        ide_devices[ideno].sets = cmdsets;
c0101948:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c010194c:	c1 e0 03             	shl    $0x3,%eax
c010194f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101956:	29 c2                	sub    %eax,%edx
c0101958:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c010195e:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101961:	89 42 04             	mov    %eax,0x4(%edx)
        ide_devices[ideno].size = sectors;
c0101964:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101968:	c1 e0 03             	shl    $0x3,%eax
c010196b:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101972:	29 c2                	sub    %eax,%edx
c0101974:	81 c2 00 11 12 c0    	add    $0xc0121100,%edx
c010197a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010197d:	89 42 08             	mov    %eax,0x8(%edx)

        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);
c0101980:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0101983:	83 c0 62             	add    $0x62,%eax
c0101986:	0f b7 00             	movzwl (%eax),%eax
c0101989:	0f b7 c0             	movzwl %ax,%eax
c010198c:	25 00 02 00 00       	and    $0x200,%eax
c0101991:	85 c0                	test   %eax,%eax
c0101993:	75 24                	jne    c01019b9 <ide_init+0x20e>
c0101995:	c7 44 24 0c f0 91 10 	movl   $0xc01091f0,0xc(%esp)
c010199c:	c0 
c010199d:	c7 44 24 08 33 92 10 	movl   $0xc0109233,0x8(%esp)
c01019a4:	c0 
c01019a5:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01019ac:	00 
c01019ad:	c7 04 24 48 92 10 c0 	movl   $0xc0109248,(%esp)
c01019b4:	e8 ff f2 ff ff       	call   c0100cb8 <__panic>

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
c01019b9:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c01019bd:	c1 e0 03             	shl    $0x3,%eax
c01019c0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c01019c7:	29 c2                	sub    %eax,%edx
c01019c9:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c01019cf:	83 c0 0c             	add    $0xc,%eax
c01019d2:	89 45 cc             	mov    %eax,-0x34(%ebp)
c01019d5:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01019d8:	83 c0 36             	add    $0x36,%eax
c01019db:	89 45 c8             	mov    %eax,-0x38(%ebp)
        unsigned int i, length = 40;
c01019de:	c7 45 c4 28 00 00 00 	movl   $0x28,-0x3c(%ebp)
        for (i = 0; i < length; i += 2) {
c01019e5:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01019ec:	eb 30                	jmp    c0101a1e <ide_init+0x273>
            model[i] = data[i + 1], model[i + 1] = data[i];
c01019ee:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01019f1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01019f4:	01 c2                	add    %eax,%edx
c01019f6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01019f9:	83 c0 01             	add    $0x1,%eax
c01019fc:	03 45 c8             	add    -0x38(%ebp),%eax
c01019ff:	0f b6 00             	movzbl (%eax),%eax
c0101a02:	88 02                	mov    %al,(%edx)
c0101a04:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a07:	83 c0 01             	add    $0x1,%eax
c0101a0a:	03 45 cc             	add    -0x34(%ebp),%eax
c0101a0d:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0101a10:	8b 4d c8             	mov    -0x38(%ebp),%ecx
c0101a13:	01 ca                	add    %ecx,%edx
c0101a15:	0f b6 12             	movzbl (%edx),%edx
c0101a18:	88 10                	mov    %dl,(%eax)
        /* check if supports LBA */
        assert((*(unsigned short *)(ident + IDE_IDENT_CAPABILITIES) & 0x200) != 0);

        unsigned char *model = ide_devices[ideno].model, *data = ident + IDE_IDENT_MODEL;
        unsigned int i, length = 40;
        for (i = 0; i < length; i += 2) {
c0101a1a:	83 45 dc 02          	addl   $0x2,-0x24(%ebp)
c0101a1e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a21:	3b 45 c4             	cmp    -0x3c(%ebp),%eax
c0101a24:	72 c8                	jb     c01019ee <ide_init+0x243>
            model[i] = data[i + 1], model[i + 1] = data[i];
        }
        do {
            model[i] = '\0';
c0101a26:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a29:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101a2c:	01 d0                	add    %edx,%eax
c0101a2e:	c6 00 00             	movb   $0x0,(%eax)
        } while (i -- > 0 && model[i] == ' ');
c0101a31:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0101a35:	0f 95 c0             	setne  %al
c0101a38:	83 6d dc 01          	subl   $0x1,-0x24(%ebp)
c0101a3c:	84 c0                	test   %al,%al
c0101a3e:	74 0f                	je     c0101a4f <ide_init+0x2a4>
c0101a40:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0101a43:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0101a46:	01 d0                	add    %edx,%eax
c0101a48:	0f b6 00             	movzbl (%eax),%eax
c0101a4b:	3c 20                	cmp    $0x20,%al
c0101a4d:	74 d7                	je     c0101a26 <ide_init+0x27b>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
c0101a4f:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101a53:	c1 e0 03             	shl    $0x3,%eax
c0101a56:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a5d:	29 c2                	sub    %eax,%edx
c0101a5f:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101a65:	8d 48 0c             	lea    0xc(%eax),%ecx
c0101a68:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101a6c:	c1 e0 03             	shl    $0x3,%eax
c0101a6f:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101a76:	29 c2                	sub    %eax,%edx
c0101a78:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101a7e:	8b 50 08             	mov    0x8(%eax),%edx
c0101a81:	0f b7 45 e6          	movzwl -0x1a(%ebp),%eax
c0101a85:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0101a89:	89 54 24 08          	mov    %edx,0x8(%esp)
c0101a8d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0101a91:	c7 04 24 5a 92 10 c0 	movl   $0xc010925a,(%esp)
c0101a98:	e8 ba e8 ff ff       	call   c0100357 <cprintf>
c0101a9d:	eb 01                	jmp    c0101aa0 <ide_init+0x2f5>
        outb(iobase + ISA_COMMAND, IDE_CMD_IDENTIFY);
        ide_wait_ready(iobase, 0);

        /* step3: polling */
        if (inb(iobase + ISA_STATUS) == 0 || ide_wait_ready(iobase, 1) != 0) {
            continue ;
c0101a9f:	90                   	nop

void
ide_init(void) {
    static_assert((SECTSIZE % 4) == 0);
    unsigned short ideno, iobase;
    for (ideno = 0; ideno < MAX_IDE; ideno ++) {
c0101aa0:	66 83 45 e6 01       	addw   $0x1,-0x1a(%ebp)
c0101aa5:	66 83 7d e6 03       	cmpw   $0x3,-0x1a(%ebp)
c0101aaa:	0f 86 12 fd ff ff    	jbe    c01017c2 <ide_init+0x17>

        cprintf("ide %d: %10u(sectors), '%s'.\n", ideno, ide_devices[ideno].size, ide_devices[ideno].model);
    }

    // enable ide interrupt
    pic_enable(IRQ_IDE1);
c0101ab0:	c7 04 24 0e 00 00 00 	movl   $0xe,(%esp)
c0101ab7:	e8 88 05 00 00       	call   c0102044 <pic_enable>
    pic_enable(IRQ_IDE2);
c0101abc:	c7 04 24 0f 00 00 00 	movl   $0xf,(%esp)
c0101ac3:	e8 7c 05 00 00       	call   c0102044 <pic_enable>
}
c0101ac8:	81 c4 6c 02 00 00    	add    $0x26c,%esp
c0101ace:	5b                   	pop    %ebx
c0101acf:	5e                   	pop    %esi
c0101ad0:	5f                   	pop    %edi
c0101ad1:	5d                   	pop    %ebp
c0101ad2:	c3                   	ret    

c0101ad3 <ide_device_valid>:

bool
ide_device_valid(unsigned short ideno) {
c0101ad3:	55                   	push   %ebp
c0101ad4:	89 e5                	mov    %esp,%ebp
c0101ad6:	83 ec 04             	sub    $0x4,%esp
c0101ad9:	8b 45 08             	mov    0x8(%ebp),%eax
c0101adc:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    return VALID_IDE(ideno);
c0101ae0:	66 83 7d fc 03       	cmpw   $0x3,-0x4(%ebp)
c0101ae5:	77 24                	ja     c0101b0b <ide_device_valid+0x38>
c0101ae7:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101aeb:	c1 e0 03             	shl    $0x3,%eax
c0101aee:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101af5:	29 c2                	sub    %eax,%edx
c0101af7:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101afd:	0f b6 00             	movzbl (%eax),%eax
c0101b00:	84 c0                	test   %al,%al
c0101b02:	74 07                	je     c0101b0b <ide_device_valid+0x38>
c0101b04:	b8 01 00 00 00       	mov    $0x1,%eax
c0101b09:	eb 05                	jmp    c0101b10 <ide_device_valid+0x3d>
c0101b0b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b10:	c9                   	leave  
c0101b11:	c3                   	ret    

c0101b12 <ide_device_size>:

size_t
ide_device_size(unsigned short ideno) {
c0101b12:	55                   	push   %ebp
c0101b13:	89 e5                	mov    %esp,%ebp
c0101b15:	83 ec 08             	sub    $0x8,%esp
c0101b18:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b1b:	66 89 45 fc          	mov    %ax,-0x4(%ebp)
    if (ide_device_valid(ideno)) {
c0101b1f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b23:	89 04 24             	mov    %eax,(%esp)
c0101b26:	e8 a8 ff ff ff       	call   c0101ad3 <ide_device_valid>
c0101b2b:	85 c0                	test   %eax,%eax
c0101b2d:	74 1b                	je     c0101b4a <ide_device_size+0x38>
        return ide_devices[ideno].size;
c0101b2f:	0f b7 45 fc          	movzwl -0x4(%ebp),%eax
c0101b33:	c1 e0 03             	shl    $0x3,%eax
c0101b36:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b3d:	29 c2                	sub    %eax,%edx
c0101b3f:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101b45:	8b 40 08             	mov    0x8(%eax),%eax
c0101b48:	eb 05                	jmp    c0101b4f <ide_device_size+0x3d>
    }
    return 0;
c0101b4a:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0101b4f:	c9                   	leave  
c0101b50:	c3                   	ret    

c0101b51 <ide_read_secs>:

int
ide_read_secs(unsigned short ideno, uint32_t secno, void *dst, size_t nsecs) {
c0101b51:	55                   	push   %ebp
c0101b52:	89 e5                	mov    %esp,%ebp
c0101b54:	57                   	push   %edi
c0101b55:	56                   	push   %esi
c0101b56:	53                   	push   %ebx
c0101b57:	83 ec 5c             	sub    $0x5c,%esp
c0101b5a:	8b 45 08             	mov    0x8(%ebp),%eax
c0101b5d:	66 89 45 b4          	mov    %ax,-0x4c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101b61:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101b68:	77 24                	ja     c0101b8e <ide_read_secs+0x3d>
c0101b6a:	66 83 7d b4 03       	cmpw   $0x3,-0x4c(%ebp)
c0101b6f:	77 1d                	ja     c0101b8e <ide_read_secs+0x3d>
c0101b71:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101b75:	c1 e0 03             	shl    $0x3,%eax
c0101b78:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101b7f:	29 c2                	sub    %eax,%edx
c0101b81:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101b87:	0f b6 00             	movzbl (%eax),%eax
c0101b8a:	84 c0                	test   %al,%al
c0101b8c:	75 24                	jne    c0101bb2 <ide_read_secs+0x61>
c0101b8e:	c7 44 24 0c 78 92 10 	movl   $0xc0109278,0xc(%esp)
c0101b95:	c0 
c0101b96:	c7 44 24 08 33 92 10 	movl   $0xc0109233,0x8(%esp)
c0101b9d:	c0 
c0101b9e:	c7 44 24 04 9f 00 00 	movl   $0x9f,0x4(%esp)
c0101ba5:	00 
c0101ba6:	c7 04 24 48 92 10 c0 	movl   $0xc0109248,(%esp)
c0101bad:	e8 06 f1 ff ff       	call   c0100cb8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101bb2:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101bb9:	77 0f                	ja     c0101bca <ide_read_secs+0x79>
c0101bbb:	8b 45 14             	mov    0x14(%ebp),%eax
c0101bbe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101bc1:	01 d0                	add    %edx,%eax
c0101bc3:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101bc8:	76 24                	jbe    c0101bee <ide_read_secs+0x9d>
c0101bca:	c7 44 24 0c a0 92 10 	movl   $0xc01092a0,0xc(%esp)
c0101bd1:	c0 
c0101bd2:	c7 44 24 08 33 92 10 	movl   $0xc0109233,0x8(%esp)
c0101bd9:	c0 
c0101bda:	c7 44 24 04 a0 00 00 	movl   $0xa0,0x4(%esp)
c0101be1:	00 
c0101be2:	c7 04 24 48 92 10 c0 	movl   $0xc0109248,(%esp)
c0101be9:	e8 ca f0 ff ff       	call   c0100cb8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101bee:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101bf2:	66 d1 e8             	shr    %ax
c0101bf5:	0f b7 c0             	movzwl %ax,%eax
c0101bf8:	0f b7 04 85 e8 91 10 	movzwl -0x3fef6e18(,%eax,4),%eax
c0101bff:	c0 
c0101c00:	66 89 45 e2          	mov    %ax,-0x1e(%ebp)
c0101c04:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101c08:	66 d1 e8             	shr    %ax
c0101c0b:	0f b7 c0             	movzwl %ax,%eax
c0101c0e:	0f b7 04 85 ea 91 10 	movzwl -0x3fef6e16(,%eax,4),%eax
c0101c15:	c0 
c0101c16:	66 89 45 e0          	mov    %ax,-0x20(%ebp)

    ide_wait_ready(iobase, 0);
c0101c1a:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101c1e:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101c25:	00 
c0101c26:	89 04 24             	mov    %eax,(%esp)
c0101c29:	e8 16 fb ff ff       	call   c0101744 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101c2e:	0f b7 45 e0          	movzwl -0x20(%ebp),%eax
c0101c32:	83 c0 02             	add    $0x2,%eax
c0101c35:	0f b7 c0             	movzwl %ax,%eax
c0101c38:	66 89 45 de          	mov    %ax,-0x22(%ebp)
c0101c3c:	c6 45 dd 00          	movb   $0x0,-0x23(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101c40:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101c44:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101c48:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101c49:	8b 45 14             	mov    0x14(%ebp),%eax
c0101c4c:	0f b6 c0             	movzbl %al,%eax
c0101c4f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c53:	83 c2 02             	add    $0x2,%edx
c0101c56:	0f b7 d2             	movzwl %dx,%edx
c0101c59:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101c5d:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101c60:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101c64:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101c68:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101c69:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c6c:	0f b6 c0             	movzbl %al,%eax
c0101c6f:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c73:	83 c2 03             	add    $0x3,%edx
c0101c76:	0f b7 d2             	movzwl %dx,%edx
c0101c79:	66 89 55 d6          	mov    %dx,-0x2a(%ebp)
c0101c7d:	88 45 d5             	mov    %al,-0x2b(%ebp)
c0101c80:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101c84:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101c88:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101c89:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101c8c:	c1 e8 08             	shr    $0x8,%eax
c0101c8f:	0f b6 c0             	movzbl %al,%eax
c0101c92:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101c96:	83 c2 04             	add    $0x4,%edx
c0101c99:	0f b7 d2             	movzwl %dx,%edx
c0101c9c:	66 89 55 d2          	mov    %dx,-0x2e(%ebp)
c0101ca0:	88 45 d1             	mov    %al,-0x2f(%ebp)
c0101ca3:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0101ca7:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c0101cab:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101cac:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101caf:	c1 e8 10             	shr    $0x10,%eax
c0101cb2:	0f b6 c0             	movzbl %al,%eax
c0101cb5:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101cb9:	83 c2 05             	add    $0x5,%edx
c0101cbc:	0f b7 d2             	movzwl %dx,%edx
c0101cbf:	66 89 55 ce          	mov    %dx,-0x32(%ebp)
c0101cc3:	88 45 cd             	mov    %al,-0x33(%ebp)
c0101cc6:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c0101cca:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c0101cce:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101ccf:	0f b7 45 b4          	movzwl -0x4c(%ebp),%eax
c0101cd3:	83 e0 01             	and    $0x1,%eax
c0101cd6:	89 c2                	mov    %eax,%edx
c0101cd8:	c1 e2 04             	shl    $0x4,%edx
c0101cdb:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101cde:	c1 e8 18             	shr    $0x18,%eax
c0101ce1:	83 e0 0f             	and    $0xf,%eax
c0101ce4:	09 d0                	or     %edx,%eax
c0101ce6:	83 c8 e0             	or     $0xffffffe0,%eax
c0101ce9:	0f b6 c0             	movzbl %al,%eax
c0101cec:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101cf0:	83 c2 06             	add    $0x6,%edx
c0101cf3:	0f b7 d2             	movzwl %dx,%edx
c0101cf6:	66 89 55 ca          	mov    %dx,-0x36(%ebp)
c0101cfa:	88 45 c9             	mov    %al,-0x37(%ebp)
c0101cfd:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c0101d01:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0101d05:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);
c0101d06:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101d0a:	83 c0 07             	add    $0x7,%eax
c0101d0d:	0f b7 c0             	movzwl %ax,%eax
c0101d10:	66 89 45 c6          	mov    %ax,-0x3a(%ebp)
c0101d14:	c6 45 c5 20          	movb   $0x20,-0x3b(%ebp)
c0101d18:	0f b6 45 c5          	movzbl -0x3b(%ebp),%eax
c0101d1c:	0f b7 55 c6          	movzwl -0x3a(%ebp),%edx
c0101d20:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101d21:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d28:	eb 5c                	jmp    c0101d86 <ide_read_secs+0x235>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101d2a:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101d2e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101d35:	00 
c0101d36:	89 04 24             	mov    %eax,(%esp)
c0101d39:	e8 06 fa ff ff       	call   c0101744 <ide_wait_ready>
c0101d3e:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0101d41:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0101d45:	75 47                	jne    c0101d8e <ide_read_secs+0x23d>
            goto out;
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
c0101d47:	0f b7 45 e2          	movzwl -0x1e(%ebp),%eax
c0101d4b:	89 45 c0             	mov    %eax,-0x40(%ebp)
c0101d4e:	8b 45 10             	mov    0x10(%ebp),%eax
c0101d51:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0101d54:	c7 45 b8 80 00 00 00 	movl   $0x80,-0x48(%ebp)
    return data;
}

static inline void
insl(uint32_t port, void *addr, int cnt) {
    asm volatile (
c0101d5b:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0101d5e:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0101d61:	8b 55 b8             	mov    -0x48(%ebp),%edx
c0101d64:	89 ce                	mov    %ecx,%esi
c0101d66:	89 d3                	mov    %edx,%ebx
c0101d68:	89 f7                	mov    %esi,%edi
c0101d6a:	89 d9                	mov    %ebx,%ecx
c0101d6c:	89 c2                	mov    %eax,%edx
c0101d6e:	fc                   	cld    
c0101d6f:	f2 6d                	repnz insl (%dx),%es:(%edi)
c0101d71:	89 cb                	mov    %ecx,%ebx
c0101d73:	89 fe                	mov    %edi,%esi
c0101d75:	89 75 bc             	mov    %esi,-0x44(%ebp)
c0101d78:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_READ);

    int ret = 0;
    for (; nsecs > 0; nsecs --, dst += SECTSIZE) {
c0101d7b:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101d7f:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101d86:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101d8a:	75 9e                	jne    c0101d2a <ide_read_secs+0x1d9>
c0101d8c:	eb 01                	jmp    c0101d8f <ide_read_secs+0x23e>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c0101d8e:	90                   	nop
        }
        insl(iobase, dst, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101d8f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
}
c0101d92:	83 c4 5c             	add    $0x5c,%esp
c0101d95:	5b                   	pop    %ebx
c0101d96:	5e                   	pop    %esi
c0101d97:	5f                   	pop    %edi
c0101d98:	5d                   	pop    %ebp
c0101d99:	c3                   	ret    

c0101d9a <ide_write_secs>:

int
ide_write_secs(unsigned short ideno, uint32_t secno, const void *src, size_t nsecs) {
c0101d9a:	55                   	push   %ebp
c0101d9b:	89 e5                	mov    %esp,%ebp
c0101d9d:	56                   	push   %esi
c0101d9e:	53                   	push   %ebx
c0101d9f:	83 ec 50             	sub    $0x50,%esp
c0101da2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101da5:	66 89 45 c4          	mov    %ax,-0x3c(%ebp)
    assert(nsecs <= MAX_NSECS && VALID_IDE(ideno));
c0101da9:	81 7d 14 80 00 00 00 	cmpl   $0x80,0x14(%ebp)
c0101db0:	77 24                	ja     c0101dd6 <ide_write_secs+0x3c>
c0101db2:	66 83 7d c4 03       	cmpw   $0x3,-0x3c(%ebp)
c0101db7:	77 1d                	ja     c0101dd6 <ide_write_secs+0x3c>
c0101db9:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101dbd:	c1 e0 03             	shl    $0x3,%eax
c0101dc0:	8d 14 c5 00 00 00 00 	lea    0x0(,%eax,8),%edx
c0101dc7:	29 c2                	sub    %eax,%edx
c0101dc9:	8d 82 00 11 12 c0    	lea    -0x3fedef00(%edx),%eax
c0101dcf:	0f b6 00             	movzbl (%eax),%eax
c0101dd2:	84 c0                	test   %al,%al
c0101dd4:	75 24                	jne    c0101dfa <ide_write_secs+0x60>
c0101dd6:	c7 44 24 0c 78 92 10 	movl   $0xc0109278,0xc(%esp)
c0101ddd:	c0 
c0101dde:	c7 44 24 08 33 92 10 	movl   $0xc0109233,0x8(%esp)
c0101de5:	c0 
c0101de6:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c0101ded:	00 
c0101dee:	c7 04 24 48 92 10 c0 	movl   $0xc0109248,(%esp)
c0101df5:	e8 be ee ff ff       	call   c0100cb8 <__panic>
    assert(secno < MAX_DISK_NSECS && secno + nsecs <= MAX_DISK_NSECS);
c0101dfa:	81 7d 0c ff ff ff 0f 	cmpl   $0xfffffff,0xc(%ebp)
c0101e01:	77 0f                	ja     c0101e12 <ide_write_secs+0x78>
c0101e03:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e06:	8b 55 0c             	mov    0xc(%ebp),%edx
c0101e09:	01 d0                	add    %edx,%eax
c0101e0b:	3d 00 00 00 10       	cmp    $0x10000000,%eax
c0101e10:	76 24                	jbe    c0101e36 <ide_write_secs+0x9c>
c0101e12:	c7 44 24 0c a0 92 10 	movl   $0xc01092a0,0xc(%esp)
c0101e19:	c0 
c0101e1a:	c7 44 24 08 33 92 10 	movl   $0xc0109233,0x8(%esp)
c0101e21:	c0 
c0101e22:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0101e29:	00 
c0101e2a:	c7 04 24 48 92 10 c0 	movl   $0xc0109248,(%esp)
c0101e31:	e8 82 ee ff ff       	call   c0100cb8 <__panic>
    unsigned short iobase = IO_BASE(ideno), ioctrl = IO_CTRL(ideno);
c0101e36:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e3a:	66 d1 e8             	shr    %ax
c0101e3d:	0f b7 c0             	movzwl %ax,%eax
c0101e40:	0f b7 04 85 e8 91 10 	movzwl -0x3fef6e18(,%eax,4),%eax
c0101e47:	c0 
c0101e48:	66 89 45 f2          	mov    %ax,-0xe(%ebp)
c0101e4c:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101e50:	66 d1 e8             	shr    %ax
c0101e53:	0f b7 c0             	movzwl %ax,%eax
c0101e56:	0f b7 04 85 ea 91 10 	movzwl -0x3fef6e16(,%eax,4),%eax
c0101e5d:	c0 
c0101e5e:	66 89 45 f0          	mov    %ax,-0x10(%ebp)

    ide_wait_ready(iobase, 0);
c0101e62:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101e66:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0101e6d:	00 
c0101e6e:	89 04 24             	mov    %eax,(%esp)
c0101e71:	e8 ce f8 ff ff       	call   c0101744 <ide_wait_ready>

    // generate interrupt
    outb(ioctrl + ISA_CTRL, 0);
c0101e76:	0f b7 45 f0          	movzwl -0x10(%ebp),%eax
c0101e7a:	83 c0 02             	add    $0x2,%eax
c0101e7d:	0f b7 c0             	movzwl %ax,%eax
c0101e80:	66 89 45 ee          	mov    %ax,-0x12(%ebp)
c0101e84:	c6 45 ed 00          	movb   $0x0,-0x13(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c0101e88:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c0101e8c:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c0101e90:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECCNT, nsecs);
c0101e91:	8b 45 14             	mov    0x14(%ebp),%eax
c0101e94:	0f b6 c0             	movzbl %al,%eax
c0101e97:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101e9b:	83 c2 02             	add    $0x2,%edx
c0101e9e:	0f b7 d2             	movzwl %dx,%edx
c0101ea1:	66 89 55 ea          	mov    %dx,-0x16(%ebp)
c0101ea5:	88 45 e9             	mov    %al,-0x17(%ebp)
c0101ea8:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c0101eac:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c0101eb0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SECTOR, secno & 0xFF);
c0101eb1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101eb4:	0f b6 c0             	movzbl %al,%eax
c0101eb7:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ebb:	83 c2 03             	add    $0x3,%edx
c0101ebe:	0f b7 d2             	movzwl %dx,%edx
c0101ec1:	66 89 55 e6          	mov    %dx,-0x1a(%ebp)
c0101ec5:	88 45 e5             	mov    %al,-0x1b(%ebp)
c0101ec8:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0101ecc:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c0101ed0:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_LO, (secno >> 8) & 0xFF);
c0101ed1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ed4:	c1 e8 08             	shr    $0x8,%eax
c0101ed7:	0f b6 c0             	movzbl %al,%eax
c0101eda:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101ede:	83 c2 04             	add    $0x4,%edx
c0101ee1:	0f b7 d2             	movzwl %dx,%edx
c0101ee4:	66 89 55 e2          	mov    %dx,-0x1e(%ebp)
c0101ee8:	88 45 e1             	mov    %al,-0x1f(%ebp)
c0101eeb:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c0101eef:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0101ef3:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
c0101ef4:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101ef7:	c1 e8 10             	shr    $0x10,%eax
c0101efa:	0f b6 c0             	movzbl %al,%eax
c0101efd:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f01:	83 c2 05             	add    $0x5,%edx
c0101f04:	0f b7 d2             	movzwl %dx,%edx
c0101f07:	66 89 55 de          	mov    %dx,-0x22(%ebp)
c0101f0b:	88 45 dd             	mov    %al,-0x23(%ebp)
c0101f0e:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c0101f12:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0101f16:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
c0101f17:	0f b7 45 c4          	movzwl -0x3c(%ebp),%eax
c0101f1b:	83 e0 01             	and    $0x1,%eax
c0101f1e:	89 c2                	mov    %eax,%edx
c0101f20:	c1 e2 04             	shl    $0x4,%edx
c0101f23:	8b 45 0c             	mov    0xc(%ebp),%eax
c0101f26:	c1 e8 18             	shr    $0x18,%eax
c0101f29:	83 e0 0f             	and    $0xf,%eax
c0101f2c:	09 d0                	or     %edx,%eax
c0101f2e:	83 c8 e0             	or     $0xffffffe0,%eax
c0101f31:	0f b6 c0             	movzbl %al,%eax
c0101f34:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c0101f38:	83 c2 06             	add    $0x6,%edx
c0101f3b:	0f b7 d2             	movzwl %dx,%edx
c0101f3e:	66 89 55 da          	mov    %dx,-0x26(%ebp)
c0101f42:	88 45 d9             	mov    %al,-0x27(%ebp)
c0101f45:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0101f49:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0101f4d:	ee                   	out    %al,(%dx)
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);
c0101f4e:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f52:	83 c0 07             	add    $0x7,%eax
c0101f55:	0f b7 c0             	movzwl %ax,%eax
c0101f58:	66 89 45 d6          	mov    %ax,-0x2a(%ebp)
c0101f5c:	c6 45 d5 30          	movb   $0x30,-0x2b(%ebp)
c0101f60:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0101f64:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0101f68:	ee                   	out    %al,(%dx)

    int ret = 0;
c0101f69:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101f70:	eb 58                	jmp    c0101fca <ide_write_secs+0x230>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
c0101f72:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f76:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0101f7d:	00 
c0101f7e:	89 04 24             	mov    %eax,(%esp)
c0101f81:	e8 be f7 ff ff       	call   c0101744 <ide_wait_ready>
c0101f86:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0101f89:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0101f8d:	75 43                	jne    c0101fd2 <ide_write_secs+0x238>
            goto out;
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
c0101f8f:	0f b7 45 f2          	movzwl -0xe(%ebp),%eax
c0101f93:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0101f96:	8b 45 10             	mov    0x10(%ebp),%eax
c0101f99:	89 45 cc             	mov    %eax,-0x34(%ebp)
c0101f9c:	c7 45 c8 80 00 00 00 	movl   $0x80,-0x38(%ebp)
    asm volatile ("outw %0, %1" :: "a" (data), "d" (port) : "memory");
}

static inline void
outsl(uint32_t port, const void *addr, int cnt) {
    asm volatile (
c0101fa3:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0101fa6:	8b 4d cc             	mov    -0x34(%ebp),%ecx
c0101fa9:	8b 55 c8             	mov    -0x38(%ebp),%edx
c0101fac:	89 ce                	mov    %ecx,%esi
c0101fae:	89 d3                	mov    %edx,%ebx
c0101fb0:	89 d9                	mov    %ebx,%ecx
c0101fb2:	89 c2                	mov    %eax,%edx
c0101fb4:	fc                   	cld    
c0101fb5:	f2 6f                	repnz outsl %ds:(%esi),(%dx)
c0101fb7:	89 cb                	mov    %ecx,%ebx
c0101fb9:	89 75 cc             	mov    %esi,-0x34(%ebp)
c0101fbc:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    outb(iobase + ISA_CYL_HI, (secno >> 16) & 0xFF);
    outb(iobase + ISA_SDH, 0xE0 | ((ideno & 1) << 4) | ((secno >> 24) & 0xF));
    outb(iobase + ISA_COMMAND, IDE_CMD_WRITE);

    int ret = 0;
    for (; nsecs > 0; nsecs --, src += SECTSIZE) {
c0101fbf:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
c0101fc3:	81 45 10 00 02 00 00 	addl   $0x200,0x10(%ebp)
c0101fca:	83 7d 14 00          	cmpl   $0x0,0x14(%ebp)
c0101fce:	75 a2                	jne    c0101f72 <ide_write_secs+0x1d8>
c0101fd0:	eb 01                	jmp    c0101fd3 <ide_write_secs+0x239>
        if ((ret = ide_wait_ready(iobase, 1)) != 0) {
            goto out;
c0101fd2:	90                   	nop
        }
        outsl(iobase, src, SECTSIZE / sizeof(uint32_t));
    }

out:
    return ret;
c0101fd3:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0101fd6:	83 c4 50             	add    $0x50,%esp
c0101fd9:	5b                   	pop    %ebx
c0101fda:	5e                   	pop    %esi
c0101fdb:	5d                   	pop    %ebp
c0101fdc:	c3                   	ret    
c0101fdd:	00 00                	add    %al,(%eax)
	...

c0101fe0 <intr_enable>:
#include <x86.h>
#include <intr.h>

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
c0101fe0:	55                   	push   %ebp
c0101fe1:	89 e5                	mov    %esp,%ebp
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
}

static inline void
sti(void) {
    asm volatile ("sti");
c0101fe3:	fb                   	sti    
    sti();
}
c0101fe4:	5d                   	pop    %ebp
c0101fe5:	c3                   	ret    

c0101fe6 <intr_disable>:

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
c0101fe6:	55                   	push   %ebp
c0101fe7:	89 e5                	mov    %esp,%ebp
}

static inline void
cli(void) {
    asm volatile ("cli" ::: "memory");
c0101fe9:	fa                   	cli    
    cli();
}
c0101fea:	5d                   	pop    %ebp
c0101feb:	c3                   	ret    

c0101fec <pic_setmask>:
// Initial IRQ mask has interrupt 2 enabled (for slave 8259A).
static uint16_t irq_mask = 0xFFFF & ~(1 << IRQ_SLAVE);
static bool did_init = 0;

static void
pic_setmask(uint16_t mask) {
c0101fec:	55                   	push   %ebp
c0101fed:	89 e5                	mov    %esp,%ebp
c0101fef:	83 ec 14             	sub    $0x14,%esp
c0101ff2:	8b 45 08             	mov    0x8(%ebp),%eax
c0101ff5:	66 89 45 ec          	mov    %ax,-0x14(%ebp)
    irq_mask = mask;
c0101ff9:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0101ffd:	66 a3 70 05 12 c0    	mov    %ax,0xc0120570
    if (did_init) {
c0102003:	a1 e0 11 12 c0       	mov    0xc01211e0,%eax
c0102008:	85 c0                	test   %eax,%eax
c010200a:	74 36                	je     c0102042 <pic_setmask+0x56>
        outb(IO_PIC1 + 1, mask);
c010200c:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102010:	0f b6 c0             	movzbl %al,%eax
c0102013:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c0102019:	88 45 fd             	mov    %al,-0x3(%ebp)
        : "memory", "cc");
}

static inline void
outb(uint16_t port, uint8_t data) {
    asm volatile ("outb %0, %1" :: "a" (data), "d" (port) : "memory");
c010201c:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102020:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c0102024:	ee                   	out    %al,(%dx)
        outb(IO_PIC2 + 1, mask >> 8);
c0102025:	0f b7 45 ec          	movzwl -0x14(%ebp),%eax
c0102029:	66 c1 e8 08          	shr    $0x8,%ax
c010202d:	0f b6 c0             	movzbl %al,%eax
c0102030:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c0102036:	88 45 f9             	mov    %al,-0x7(%ebp)
c0102039:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c010203d:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c0102041:	ee                   	out    %al,(%dx)
    }
}
c0102042:	c9                   	leave  
c0102043:	c3                   	ret    

c0102044 <pic_enable>:

void
pic_enable(unsigned int irq) {
c0102044:	55                   	push   %ebp
c0102045:	89 e5                	mov    %esp,%ebp
c0102047:	53                   	push   %ebx
c0102048:	83 ec 04             	sub    $0x4,%esp
    pic_setmask(irq_mask & ~(1 << irq));
c010204b:	8b 45 08             	mov    0x8(%ebp),%eax
c010204e:	ba 01 00 00 00       	mov    $0x1,%edx
c0102053:	89 d3                	mov    %edx,%ebx
c0102055:	89 c1                	mov    %eax,%ecx
c0102057:	d3 e3                	shl    %cl,%ebx
c0102059:	89 d8                	mov    %ebx,%eax
c010205b:	89 c2                	mov    %eax,%edx
c010205d:	f7 d2                	not    %edx
c010205f:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c0102066:	21 d0                	and    %edx,%eax
c0102068:	0f b7 c0             	movzwl %ax,%eax
c010206b:	89 04 24             	mov    %eax,(%esp)
c010206e:	e8 79 ff ff ff       	call   c0101fec <pic_setmask>
}
c0102073:	83 c4 04             	add    $0x4,%esp
c0102076:	5b                   	pop    %ebx
c0102077:	5d                   	pop    %ebp
c0102078:	c3                   	ret    

c0102079 <pic_init>:

/* pic_init - initialize the 8259A interrupt controllers */
void
pic_init(void) {
c0102079:	55                   	push   %ebp
c010207a:	89 e5                	mov    %esp,%ebp
c010207c:	83 ec 44             	sub    $0x44,%esp
    did_init = 1;
c010207f:	c7 05 e0 11 12 c0 01 	movl   $0x1,0xc01211e0
c0102086:	00 00 00 
c0102089:	66 c7 45 fe 21 00    	movw   $0x21,-0x2(%ebp)
c010208f:	c6 45 fd ff          	movb   $0xff,-0x3(%ebp)
c0102093:	0f b6 45 fd          	movzbl -0x3(%ebp),%eax
c0102097:	0f b7 55 fe          	movzwl -0x2(%ebp),%edx
c010209b:	ee                   	out    %al,(%dx)
c010209c:	66 c7 45 fa a1 00    	movw   $0xa1,-0x6(%ebp)
c01020a2:	c6 45 f9 ff          	movb   $0xff,-0x7(%ebp)
c01020a6:	0f b6 45 f9          	movzbl -0x7(%ebp),%eax
c01020aa:	0f b7 55 fa          	movzwl -0x6(%ebp),%edx
c01020ae:	ee                   	out    %al,(%dx)
c01020af:	66 c7 45 f6 20 00    	movw   $0x20,-0xa(%ebp)
c01020b5:	c6 45 f5 11          	movb   $0x11,-0xb(%ebp)
c01020b9:	0f b6 45 f5          	movzbl -0xb(%ebp),%eax
c01020bd:	0f b7 55 f6          	movzwl -0xa(%ebp),%edx
c01020c1:	ee                   	out    %al,(%dx)
c01020c2:	66 c7 45 f2 21 00    	movw   $0x21,-0xe(%ebp)
c01020c8:	c6 45 f1 20          	movb   $0x20,-0xf(%ebp)
c01020cc:	0f b6 45 f1          	movzbl -0xf(%ebp),%eax
c01020d0:	0f b7 55 f2          	movzwl -0xe(%ebp),%edx
c01020d4:	ee                   	out    %al,(%dx)
c01020d5:	66 c7 45 ee 21 00    	movw   $0x21,-0x12(%ebp)
c01020db:	c6 45 ed 04          	movb   $0x4,-0x13(%ebp)
c01020df:	0f b6 45 ed          	movzbl -0x13(%ebp),%eax
c01020e3:	0f b7 55 ee          	movzwl -0x12(%ebp),%edx
c01020e7:	ee                   	out    %al,(%dx)
c01020e8:	66 c7 45 ea 21 00    	movw   $0x21,-0x16(%ebp)
c01020ee:	c6 45 e9 03          	movb   $0x3,-0x17(%ebp)
c01020f2:	0f b6 45 e9          	movzbl -0x17(%ebp),%eax
c01020f6:	0f b7 55 ea          	movzwl -0x16(%ebp),%edx
c01020fa:	ee                   	out    %al,(%dx)
c01020fb:	66 c7 45 e6 a0 00    	movw   $0xa0,-0x1a(%ebp)
c0102101:	c6 45 e5 11          	movb   $0x11,-0x1b(%ebp)
c0102105:	0f b6 45 e5          	movzbl -0x1b(%ebp),%eax
c0102109:	0f b7 55 e6          	movzwl -0x1a(%ebp),%edx
c010210d:	ee                   	out    %al,(%dx)
c010210e:	66 c7 45 e2 a1 00    	movw   $0xa1,-0x1e(%ebp)
c0102114:	c6 45 e1 28          	movb   $0x28,-0x1f(%ebp)
c0102118:	0f b6 45 e1          	movzbl -0x1f(%ebp),%eax
c010211c:	0f b7 55 e2          	movzwl -0x1e(%ebp),%edx
c0102120:	ee                   	out    %al,(%dx)
c0102121:	66 c7 45 de a1 00    	movw   $0xa1,-0x22(%ebp)
c0102127:	c6 45 dd 02          	movb   $0x2,-0x23(%ebp)
c010212b:	0f b6 45 dd          	movzbl -0x23(%ebp),%eax
c010212f:	0f b7 55 de          	movzwl -0x22(%ebp),%edx
c0102133:	ee                   	out    %al,(%dx)
c0102134:	66 c7 45 da a1 00    	movw   $0xa1,-0x26(%ebp)
c010213a:	c6 45 d9 03          	movb   $0x3,-0x27(%ebp)
c010213e:	0f b6 45 d9          	movzbl -0x27(%ebp),%eax
c0102142:	0f b7 55 da          	movzwl -0x26(%ebp),%edx
c0102146:	ee                   	out    %al,(%dx)
c0102147:	66 c7 45 d6 20 00    	movw   $0x20,-0x2a(%ebp)
c010214d:	c6 45 d5 68          	movb   $0x68,-0x2b(%ebp)
c0102151:	0f b6 45 d5          	movzbl -0x2b(%ebp),%eax
c0102155:	0f b7 55 d6          	movzwl -0x2a(%ebp),%edx
c0102159:	ee                   	out    %al,(%dx)
c010215a:	66 c7 45 d2 20 00    	movw   $0x20,-0x2e(%ebp)
c0102160:	c6 45 d1 0a          	movb   $0xa,-0x2f(%ebp)
c0102164:	0f b6 45 d1          	movzbl -0x2f(%ebp),%eax
c0102168:	0f b7 55 d2          	movzwl -0x2e(%ebp),%edx
c010216c:	ee                   	out    %al,(%dx)
c010216d:	66 c7 45 ce a0 00    	movw   $0xa0,-0x32(%ebp)
c0102173:	c6 45 cd 68          	movb   $0x68,-0x33(%ebp)
c0102177:	0f b6 45 cd          	movzbl -0x33(%ebp),%eax
c010217b:	0f b7 55 ce          	movzwl -0x32(%ebp),%edx
c010217f:	ee                   	out    %al,(%dx)
c0102180:	66 c7 45 ca a0 00    	movw   $0xa0,-0x36(%ebp)
c0102186:	c6 45 c9 0a          	movb   $0xa,-0x37(%ebp)
c010218a:	0f b6 45 c9          	movzbl -0x37(%ebp),%eax
c010218e:	0f b7 55 ca          	movzwl -0x36(%ebp),%edx
c0102192:	ee                   	out    %al,(%dx)
    outb(IO_PIC1, 0x0a);    // read IRR by default

    outb(IO_PIC2, 0x68);    // OCW3
    outb(IO_PIC2, 0x0a);    // OCW3

    if (irq_mask != 0xFFFF) {
c0102193:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c010219a:	66 83 f8 ff          	cmp    $0xffff,%ax
c010219e:	74 12                	je     c01021b2 <pic_init+0x139>
        pic_setmask(irq_mask);
c01021a0:	0f b7 05 70 05 12 c0 	movzwl 0xc0120570,%eax
c01021a7:	0f b7 c0             	movzwl %ax,%eax
c01021aa:	89 04 24             	mov    %eax,(%esp)
c01021ad:	e8 3a fe ff ff       	call   c0101fec <pic_setmask>
    }
}
c01021b2:	c9                   	leave  
c01021b3:	c3                   	ret    

c01021b4 <print_ticks>:
#include <swap.h>
#include <kdebug.h>

#define TICK_NUM 100

static void print_ticks() {
c01021b4:	55                   	push   %ebp
c01021b5:	89 e5                	mov    %esp,%ebp
c01021b7:	83 ec 18             	sub    $0x18,%esp
    cprintf("%d ticks\n",TICK_NUM);
c01021ba:	c7 44 24 04 64 00 00 	movl   $0x64,0x4(%esp)
c01021c1:	00 
c01021c2:	c7 04 24 e0 92 10 c0 	movl   $0xc01092e0,(%esp)
c01021c9:	e8 89 e1 ff ff       	call   c0100357 <cprintf>
#ifdef DEBUG_GRADE
    cprintf("End of Test.\n");
c01021ce:	c7 04 24 ea 92 10 c0 	movl   $0xc01092ea,(%esp)
c01021d5:	e8 7d e1 ff ff       	call   c0100357 <cprintf>
    panic("EOT: kernel seems ok.");
c01021da:	c7 44 24 08 f8 92 10 	movl   $0xc01092f8,0x8(%esp)
c01021e1:	c0 
c01021e2:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c01021e9:	00 
c01021ea:	c7 04 24 0e 93 10 c0 	movl   $0xc010930e,(%esp)
c01021f1:	e8 c2 ea ff ff       	call   c0100cb8 <__panic>

c01021f6 <idt_init>:
    sizeof(idt) - 1, (uintptr_t)idt
};

/* idt_init - initialize IDT to each of the entry points in kern/trap/vectors.S */
void
idt_init(void) {
c01021f6:	55                   	push   %ebp
c01021f7:	89 e5                	mov    %esp,%ebp
c01021f9:	83 ec 10             	sub    $0x10,%esp
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01021fc:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
c0102203:	e9 c3 00 00 00       	jmp    c01022cb <idt_init+0xd5>
        SETGATE(idt[i], 0,  GD_KTEXT, __vectors[i], DPL_KERNEL);
c0102208:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010220b:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c0102212:	89 c2                	mov    %eax,%edx
c0102214:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102217:	66 89 14 c5 00 12 12 	mov    %dx,-0x3fedee00(,%eax,8)
c010221e:	c0 
c010221f:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102222:	66 c7 04 c5 02 12 12 	movw   $0x8,-0x3fededfe(,%eax,8)
c0102229:	c0 08 00 
c010222c:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010222f:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c0102236:	c0 
c0102237:	83 e2 e0             	and    $0xffffffe0,%edx
c010223a:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102241:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102244:	0f b6 14 c5 04 12 12 	movzbl -0x3fededfc(,%eax,8),%edx
c010224b:	c0 
c010224c:	83 e2 1f             	and    $0x1f,%edx
c010224f:	88 14 c5 04 12 12 c0 	mov    %dl,-0x3fededfc(,%eax,8)
c0102256:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102259:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102260:	c0 
c0102261:	83 e2 f0             	and    $0xfffffff0,%edx
c0102264:	83 ca 0e             	or     $0xe,%edx
c0102267:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c010226e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102271:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c0102278:	c0 
c0102279:	83 e2 ef             	and    $0xffffffef,%edx
c010227c:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c0102283:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0102286:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c010228d:	c0 
c010228e:	83 e2 9f             	and    $0xffffff9f,%edx
c0102291:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c0102298:	8b 45 fc             	mov    -0x4(%ebp),%eax
c010229b:	0f b6 14 c5 05 12 12 	movzbl -0x3fededfb(,%eax,8),%edx
c01022a2:	c0 
c01022a3:	83 ca 80             	or     $0xffffff80,%edx
c01022a6:	88 14 c5 05 12 12 c0 	mov    %dl,-0x3fededfb(,%eax,8)
c01022ad:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022b0:	8b 04 85 00 06 12 c0 	mov    -0x3fedfa00(,%eax,4),%eax
c01022b7:	c1 e8 10             	shr    $0x10,%eax
c01022ba:	89 c2                	mov    %eax,%edx
c01022bc:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022bf:	66 89 14 c5 06 12 12 	mov    %dx,-0x3fededfa(,%eax,8)
c01022c6:	c0 
      *     You don't know the meaning of this instruction? just google it! and check the libs/x86.h to know more.
      *     Notice: the argument of lidt is idt_pd. try to find it!
      */
    extern uintptr_t __vectors[];
    int i;
    for (i = 0; i < sizeof(idt) / sizeof(struct gatedesc); i ++) {
c01022c7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c01022cb:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01022ce:	3d ff 00 00 00       	cmp    $0xff,%eax
c01022d3:	0f 86 2f ff ff ff    	jbe    c0102208 <idt_init+0x12>
        SETGATE(idt[i], 0,  GD_KTEXT, __vectors[i], DPL_KERNEL);
    }
    SETGATE(idt[T_SWITCH_TOK], 0, GD_KTEXT, __vectors[T_SWITCH_TOK], DPL_USER);
c01022d9:	a1 e4 07 12 c0       	mov    0xc01207e4,%eax
c01022de:	66 a3 c8 15 12 c0    	mov    %ax,0xc01215c8
c01022e4:	66 c7 05 ca 15 12 c0 	movw   $0x8,0xc01215ca
c01022eb:	08 00 
c01022ed:	0f b6 05 cc 15 12 c0 	movzbl 0xc01215cc,%eax
c01022f4:	83 e0 e0             	and    $0xffffffe0,%eax
c01022f7:	a2 cc 15 12 c0       	mov    %al,0xc01215cc
c01022fc:	0f b6 05 cc 15 12 c0 	movzbl 0xc01215cc,%eax
c0102303:	83 e0 1f             	and    $0x1f,%eax
c0102306:	a2 cc 15 12 c0       	mov    %al,0xc01215cc
c010230b:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c0102312:	83 e0 f0             	and    $0xfffffff0,%eax
c0102315:	83 c8 0e             	or     $0xe,%eax
c0102318:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c010231d:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c0102324:	83 e0 ef             	and    $0xffffffef,%eax
c0102327:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c010232c:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c0102333:	83 c8 60             	or     $0x60,%eax
c0102336:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c010233b:	0f b6 05 cd 15 12 c0 	movzbl 0xc01215cd,%eax
c0102342:	83 c8 80             	or     $0xffffff80,%eax
c0102345:	a2 cd 15 12 c0       	mov    %al,0xc01215cd
c010234a:	a1 e4 07 12 c0       	mov    0xc01207e4,%eax
c010234f:	c1 e8 10             	shr    $0x10,%eax
c0102352:	66 a3 ce 15 12 c0    	mov    %ax,0xc01215ce
c0102358:	c7 45 f8 80 05 12 c0 	movl   $0xc0120580,-0x8(%ebp)
    }
}

static inline void
lidt(struct pseudodesc *pd) {
    asm volatile ("lidt (%0)" :: "r" (pd) : "memory");
c010235f:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0102362:	0f 01 18             	lidtl  (%eax)
    lidt(&idt_pd); // load the IDT
}
c0102365:	c9                   	leave  
c0102366:	c3                   	ret    

c0102367 <trapname>:

static const char *
trapname(int trapno) {
c0102367:	55                   	push   %ebp
c0102368:	89 e5                	mov    %esp,%ebp
        "Alignment Check",
        "Machine-Check",
        "SIMD Floating-Point Exception"
    };

    if (trapno < sizeof(excnames)/sizeof(const char * const)) {
c010236a:	8b 45 08             	mov    0x8(%ebp),%eax
c010236d:	83 f8 13             	cmp    $0x13,%eax
c0102370:	77 0c                	ja     c010237e <trapname+0x17>
        return excnames[trapno];
c0102372:	8b 45 08             	mov    0x8(%ebp),%eax
c0102375:	8b 04 85 e0 96 10 c0 	mov    -0x3fef6920(,%eax,4),%eax
c010237c:	eb 18                	jmp    c0102396 <trapname+0x2f>
    }
    if (trapno >= IRQ_OFFSET && trapno < IRQ_OFFSET + 16) {
c010237e:	83 7d 08 1f          	cmpl   $0x1f,0x8(%ebp)
c0102382:	7e 0d                	jle    c0102391 <trapname+0x2a>
c0102384:	83 7d 08 2f          	cmpl   $0x2f,0x8(%ebp)
c0102388:	7f 07                	jg     c0102391 <trapname+0x2a>
        return "Hardware Interrupt";
c010238a:	b8 1f 93 10 c0       	mov    $0xc010931f,%eax
c010238f:	eb 05                	jmp    c0102396 <trapname+0x2f>
    }
    return "(unknown trap)";
c0102391:	b8 32 93 10 c0       	mov    $0xc0109332,%eax
}
c0102396:	5d                   	pop    %ebp
c0102397:	c3                   	ret    

c0102398 <trap_in_kernel>:

/* trap_in_kernel - test if trap happened in kernel */
bool
trap_in_kernel(struct trapframe *tf) {
c0102398:	55                   	push   %ebp
c0102399:	89 e5                	mov    %esp,%ebp
    return (tf->tf_cs == (uint16_t)KERNEL_CS);
c010239b:	8b 45 08             	mov    0x8(%ebp),%eax
c010239e:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c01023a2:	66 83 f8 08          	cmp    $0x8,%ax
c01023a6:	0f 94 c0             	sete   %al
c01023a9:	0f b6 c0             	movzbl %al,%eax
}
c01023ac:	5d                   	pop    %ebp
c01023ad:	c3                   	ret    

c01023ae <print_trapframe>:
    "TF", "IF", "DF", "OF", NULL, NULL, "NT", NULL,
    "RF", "VM", "AC", "VIF", "VIP", "ID", NULL, NULL,
};

void
print_trapframe(struct trapframe *tf) {
c01023ae:	55                   	push   %ebp
c01023af:	89 e5                	mov    %esp,%ebp
c01023b1:	83 ec 28             	sub    $0x28,%esp
    cprintf("trapframe at %p\n", tf);
c01023b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01023b7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023bb:	c7 04 24 73 93 10 c0 	movl   $0xc0109373,(%esp)
c01023c2:	e8 90 df ff ff       	call   c0100357 <cprintf>
    print_regs(&tf->tf_regs);
c01023c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ca:	89 04 24             	mov    %eax,(%esp)
c01023cd:	e8 a1 01 00 00       	call   c0102573 <print_regs>
    cprintf("  ds   0x----%04x\n", tf->tf_ds);
c01023d2:	8b 45 08             	mov    0x8(%ebp),%eax
c01023d5:	0f b7 40 2c          	movzwl 0x2c(%eax),%eax
c01023d9:	0f b7 c0             	movzwl %ax,%eax
c01023dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023e0:	c7 04 24 84 93 10 c0 	movl   $0xc0109384,(%esp)
c01023e7:	e8 6b df ff ff       	call   c0100357 <cprintf>
    cprintf("  es   0x----%04x\n", tf->tf_es);
c01023ec:	8b 45 08             	mov    0x8(%ebp),%eax
c01023ef:	0f b7 40 28          	movzwl 0x28(%eax),%eax
c01023f3:	0f b7 c0             	movzwl %ax,%eax
c01023f6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01023fa:	c7 04 24 97 93 10 c0 	movl   $0xc0109397,(%esp)
c0102401:	e8 51 df ff ff       	call   c0100357 <cprintf>
    cprintf("  fs   0x----%04x\n", tf->tf_fs);
c0102406:	8b 45 08             	mov    0x8(%ebp),%eax
c0102409:	0f b7 40 24          	movzwl 0x24(%eax),%eax
c010240d:	0f b7 c0             	movzwl %ax,%eax
c0102410:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102414:	c7 04 24 aa 93 10 c0 	movl   $0xc01093aa,(%esp)
c010241b:	e8 37 df ff ff       	call   c0100357 <cprintf>
    cprintf("  gs   0x----%04x\n", tf->tf_gs);
c0102420:	8b 45 08             	mov    0x8(%ebp),%eax
c0102423:	0f b7 40 20          	movzwl 0x20(%eax),%eax
c0102427:	0f b7 c0             	movzwl %ax,%eax
c010242a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010242e:	c7 04 24 bd 93 10 c0 	movl   $0xc01093bd,(%esp)
c0102435:	e8 1d df ff ff       	call   c0100357 <cprintf>
    cprintf("  trap 0x%08x %s\n", tf->tf_trapno, trapname(tf->tf_trapno));
c010243a:	8b 45 08             	mov    0x8(%ebp),%eax
c010243d:	8b 40 30             	mov    0x30(%eax),%eax
c0102440:	89 04 24             	mov    %eax,(%esp)
c0102443:	e8 1f ff ff ff       	call   c0102367 <trapname>
c0102448:	8b 55 08             	mov    0x8(%ebp),%edx
c010244b:	8b 52 30             	mov    0x30(%edx),%edx
c010244e:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102452:	89 54 24 04          	mov    %edx,0x4(%esp)
c0102456:	c7 04 24 d0 93 10 c0 	movl   $0xc01093d0,(%esp)
c010245d:	e8 f5 de ff ff       	call   c0100357 <cprintf>
    cprintf("  err  0x%08x\n", tf->tf_err);
c0102462:	8b 45 08             	mov    0x8(%ebp),%eax
c0102465:	8b 40 34             	mov    0x34(%eax),%eax
c0102468:	89 44 24 04          	mov    %eax,0x4(%esp)
c010246c:	c7 04 24 e2 93 10 c0 	movl   $0xc01093e2,(%esp)
c0102473:	e8 df de ff ff       	call   c0100357 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
c0102478:	8b 45 08             	mov    0x8(%ebp),%eax
c010247b:	8b 40 38             	mov    0x38(%eax),%eax
c010247e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102482:	c7 04 24 f1 93 10 c0 	movl   $0xc01093f1,(%esp)
c0102489:	e8 c9 de ff ff       	call   c0100357 <cprintf>
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
c010248e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102491:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102495:	0f b7 c0             	movzwl %ax,%eax
c0102498:	89 44 24 04          	mov    %eax,0x4(%esp)
c010249c:	c7 04 24 00 94 10 c0 	movl   $0xc0109400,(%esp)
c01024a3:	e8 af de ff ff       	call   c0100357 <cprintf>
    cprintf("  flag 0x%08x ", tf->tf_eflags);
c01024a8:	8b 45 08             	mov    0x8(%ebp),%eax
c01024ab:	8b 40 40             	mov    0x40(%eax),%eax
c01024ae:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024b2:	c7 04 24 13 94 10 c0 	movl   $0xc0109413,(%esp)
c01024b9:	e8 99 de ff ff       	call   c0100357 <cprintf>

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c01024be:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01024c5:	c7 45 f0 01 00 00 00 	movl   $0x1,-0x10(%ebp)
c01024cc:	eb 3e                	jmp    c010250c <print_trapframe+0x15e>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
c01024ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01024d1:	8b 50 40             	mov    0x40(%eax),%edx
c01024d4:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01024d7:	21 d0                	and    %edx,%eax
c01024d9:	85 c0                	test   %eax,%eax
c01024db:	74 28                	je     c0102505 <print_trapframe+0x157>
c01024dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024e0:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c01024e7:	85 c0                	test   %eax,%eax
c01024e9:	74 1a                	je     c0102505 <print_trapframe+0x157>
            cprintf("%s,", IA32flags[i]);
c01024eb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01024ee:	8b 04 85 a0 05 12 c0 	mov    -0x3fedfa60(,%eax,4),%eax
c01024f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01024f9:	c7 04 24 22 94 10 c0 	movl   $0xc0109422,(%esp)
c0102500:	e8 52 de ff ff       	call   c0100357 <cprintf>
    cprintf("  eip  0x%08x\n", tf->tf_eip);
    cprintf("  cs   0x----%04x\n", tf->tf_cs);
    cprintf("  flag 0x%08x ", tf->tf_eflags);

    int i, j;
    for (i = 0, j = 1; i < sizeof(IA32flags) / sizeof(IA32flags[0]); i ++, j <<= 1) {
c0102505:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0102509:	d1 65 f0             	shll   -0x10(%ebp)
c010250c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010250f:	83 f8 17             	cmp    $0x17,%eax
c0102512:	76 ba                	jbe    c01024ce <print_trapframe+0x120>
        if ((tf->tf_eflags & j) && IA32flags[i] != NULL) {
            cprintf("%s,", IA32flags[i]);
        }
    }
    cprintf("IOPL=%d\n", (tf->tf_eflags & FL_IOPL_MASK) >> 12);
c0102514:	8b 45 08             	mov    0x8(%ebp),%eax
c0102517:	8b 40 40             	mov    0x40(%eax),%eax
c010251a:	25 00 30 00 00       	and    $0x3000,%eax
c010251f:	c1 e8 0c             	shr    $0xc,%eax
c0102522:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102526:	c7 04 24 26 94 10 c0 	movl   $0xc0109426,(%esp)
c010252d:	e8 25 de ff ff       	call   c0100357 <cprintf>

    if (!trap_in_kernel(tf)) {
c0102532:	8b 45 08             	mov    0x8(%ebp),%eax
c0102535:	89 04 24             	mov    %eax,(%esp)
c0102538:	e8 5b fe ff ff       	call   c0102398 <trap_in_kernel>
c010253d:	85 c0                	test   %eax,%eax
c010253f:	75 30                	jne    c0102571 <print_trapframe+0x1c3>
        cprintf("  esp  0x%08x\n", tf->tf_esp);
c0102541:	8b 45 08             	mov    0x8(%ebp),%eax
c0102544:	8b 40 44             	mov    0x44(%eax),%eax
c0102547:	89 44 24 04          	mov    %eax,0x4(%esp)
c010254b:	c7 04 24 2f 94 10 c0 	movl   $0xc010942f,(%esp)
c0102552:	e8 00 de ff ff       	call   c0100357 <cprintf>
        cprintf("  ss   0x----%04x\n", tf->tf_ss);
c0102557:	8b 45 08             	mov    0x8(%ebp),%eax
c010255a:	0f b7 40 48          	movzwl 0x48(%eax),%eax
c010255e:	0f b7 c0             	movzwl %ax,%eax
c0102561:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102565:	c7 04 24 3e 94 10 c0 	movl   $0xc010943e,(%esp)
c010256c:	e8 e6 dd ff ff       	call   c0100357 <cprintf>
    }
}
c0102571:	c9                   	leave  
c0102572:	c3                   	ret    

c0102573 <print_regs>:

void
print_regs(struct pushregs *regs) {
c0102573:	55                   	push   %ebp
c0102574:	89 e5                	mov    %esp,%ebp
c0102576:	83 ec 18             	sub    $0x18,%esp
    cprintf("  edi  0x%08x\n", regs->reg_edi);
c0102579:	8b 45 08             	mov    0x8(%ebp),%eax
c010257c:	8b 00                	mov    (%eax),%eax
c010257e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102582:	c7 04 24 51 94 10 c0 	movl   $0xc0109451,(%esp)
c0102589:	e8 c9 dd ff ff       	call   c0100357 <cprintf>
    cprintf("  esi  0x%08x\n", regs->reg_esi);
c010258e:	8b 45 08             	mov    0x8(%ebp),%eax
c0102591:	8b 40 04             	mov    0x4(%eax),%eax
c0102594:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102598:	c7 04 24 60 94 10 c0 	movl   $0xc0109460,(%esp)
c010259f:	e8 b3 dd ff ff       	call   c0100357 <cprintf>
    cprintf("  ebp  0x%08x\n", regs->reg_ebp);
c01025a4:	8b 45 08             	mov    0x8(%ebp),%eax
c01025a7:	8b 40 08             	mov    0x8(%eax),%eax
c01025aa:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025ae:	c7 04 24 6f 94 10 c0 	movl   $0xc010946f,(%esp)
c01025b5:	e8 9d dd ff ff       	call   c0100357 <cprintf>
    cprintf("  oesp 0x%08x\n", regs->reg_oesp);
c01025ba:	8b 45 08             	mov    0x8(%ebp),%eax
c01025bd:	8b 40 0c             	mov    0xc(%eax),%eax
c01025c0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025c4:	c7 04 24 7e 94 10 c0 	movl   $0xc010947e,(%esp)
c01025cb:	e8 87 dd ff ff       	call   c0100357 <cprintf>
    cprintf("  ebx  0x%08x\n", regs->reg_ebx);
c01025d0:	8b 45 08             	mov    0x8(%ebp),%eax
c01025d3:	8b 40 10             	mov    0x10(%eax),%eax
c01025d6:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025da:	c7 04 24 8d 94 10 c0 	movl   $0xc010948d,(%esp)
c01025e1:	e8 71 dd ff ff       	call   c0100357 <cprintf>
    cprintf("  edx  0x%08x\n", regs->reg_edx);
c01025e6:	8b 45 08             	mov    0x8(%ebp),%eax
c01025e9:	8b 40 14             	mov    0x14(%eax),%eax
c01025ec:	89 44 24 04          	mov    %eax,0x4(%esp)
c01025f0:	c7 04 24 9c 94 10 c0 	movl   $0xc010949c,(%esp)
c01025f7:	e8 5b dd ff ff       	call   c0100357 <cprintf>
    cprintf("  ecx  0x%08x\n", regs->reg_ecx);
c01025fc:	8b 45 08             	mov    0x8(%ebp),%eax
c01025ff:	8b 40 18             	mov    0x18(%eax),%eax
c0102602:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102606:	c7 04 24 ab 94 10 c0 	movl   $0xc01094ab,(%esp)
c010260d:	e8 45 dd ff ff       	call   c0100357 <cprintf>
    cprintf("  eax  0x%08x\n", regs->reg_eax);
c0102612:	8b 45 08             	mov    0x8(%ebp),%eax
c0102615:	8b 40 1c             	mov    0x1c(%eax),%eax
c0102618:	89 44 24 04          	mov    %eax,0x4(%esp)
c010261c:	c7 04 24 ba 94 10 c0 	movl   $0xc01094ba,(%esp)
c0102623:	e8 2f dd ff ff       	call   c0100357 <cprintf>
}
c0102628:	c9                   	leave  
c0102629:	c3                   	ret    

c010262a <print_pgfault>:

static inline void
print_pgfault(struct trapframe *tf) {
c010262a:	55                   	push   %ebp
c010262b:	89 e5                	mov    %esp,%ebp
c010262d:	53                   	push   %ebx
c010262e:	83 ec 34             	sub    $0x34,%esp
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
c0102631:	8b 45 08             	mov    0x8(%ebp),%eax
c0102634:	8b 40 34             	mov    0x34(%eax),%eax
c0102637:	83 e0 01             	and    $0x1,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010263a:	84 c0                	test   %al,%al
c010263c:	74 07                	je     c0102645 <print_pgfault+0x1b>
c010263e:	b9 c9 94 10 c0       	mov    $0xc01094c9,%ecx
c0102643:	eb 05                	jmp    c010264a <print_pgfault+0x20>
c0102645:	b9 da 94 10 c0       	mov    $0xc01094da,%ecx
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
c010264a:	8b 45 08             	mov    0x8(%ebp),%eax
c010264d:	8b 40 34             	mov    0x34(%eax),%eax
c0102650:	83 e0 02             	and    $0x2,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c0102653:	85 c0                	test   %eax,%eax
c0102655:	74 07                	je     c010265e <print_pgfault+0x34>
c0102657:	ba 57 00 00 00       	mov    $0x57,%edx
c010265c:	eb 05                	jmp    c0102663 <print_pgfault+0x39>
c010265e:	ba 52 00 00 00       	mov    $0x52,%edx
            (tf->tf_err & 4) ? 'U' : 'K',
c0102663:	8b 45 08             	mov    0x8(%ebp),%eax
c0102666:	8b 40 34             	mov    0x34(%eax),%eax
c0102669:	83 e0 04             	and    $0x4,%eax
    /* error_code:
     * bit 0 == 0 means no page found, 1 means protection fault
     * bit 1 == 0 means read, 1 means write
     * bit 2 == 0 means kernel, 1 means user
     * */
    cprintf("page fault at 0x%08x: %c/%c [%s].\n", rcr2(),
c010266c:	85 c0                	test   %eax,%eax
c010266e:	74 07                	je     c0102677 <print_pgfault+0x4d>
c0102670:	b8 55 00 00 00       	mov    $0x55,%eax
c0102675:	eb 05                	jmp    c010267c <print_pgfault+0x52>
c0102677:	b8 4b 00 00 00       	mov    $0x4b,%eax
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c010267c:	0f 20 d3             	mov    %cr2,%ebx
c010267f:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c0102682:	8b 5d f4             	mov    -0xc(%ebp),%ebx
c0102685:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0102689:	89 54 24 0c          	mov    %edx,0xc(%esp)
c010268d:	89 44 24 08          	mov    %eax,0x8(%esp)
c0102691:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0102695:	c7 04 24 e8 94 10 c0 	movl   $0xc01094e8,(%esp)
c010269c:	e8 b6 dc ff ff       	call   c0100357 <cprintf>
            (tf->tf_err & 4) ? 'U' : 'K',
            (tf->tf_err & 2) ? 'W' : 'R',
            (tf->tf_err & 1) ? "protection fault" : "no page found");
}
c01026a1:	83 c4 34             	add    $0x34,%esp
c01026a4:	5b                   	pop    %ebx
c01026a5:	5d                   	pop    %ebp
c01026a6:	c3                   	ret    

c01026a7 <pgfault_handler>:

static int
pgfault_handler(struct trapframe *tf) {
c01026a7:	55                   	push   %ebp
c01026a8:	89 e5                	mov    %esp,%ebp
c01026aa:	53                   	push   %ebx
c01026ab:	83 ec 24             	sub    $0x24,%esp
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
c01026ae:	8b 45 08             	mov    0x8(%ebp),%eax
c01026b1:	89 04 24             	mov    %eax,(%esp)
c01026b4:	e8 71 ff ff ff       	call   c010262a <print_pgfault>
    if (check_mm_struct != NULL) {
c01026b9:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01026be:	85 c0                	test   %eax,%eax
c01026c0:	74 2c                	je     c01026ee <pgfault_handler+0x47>
}

static inline uintptr_t
rcr2(void) {
    uintptr_t cr2;
    asm volatile ("mov %%cr2, %0" : "=r" (cr2) :: "memory");
c01026c2:	0f 20 d3             	mov    %cr2,%ebx
c01026c5:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return cr2;
c01026c8:	8b 45 f4             	mov    -0xc(%ebp),%eax
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
c01026cb:	89 c1                	mov    %eax,%ecx
c01026cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01026d0:	8b 50 34             	mov    0x34(%eax),%edx
c01026d3:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01026d8:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c01026dc:	89 54 24 04          	mov    %edx,0x4(%esp)
c01026e0:	89 04 24             	mov    %eax,(%esp)
c01026e3:	e8 12 57 00 00       	call   c0107dfa <do_pgfault>
    }
    panic("unhandled page fault.\n");
}
c01026e8:	83 c4 24             	add    $0x24,%esp
c01026eb:	5b                   	pop    %ebx
c01026ec:	5d                   	pop    %ebp
c01026ed:	c3                   	ret    
    extern struct mm_struct *check_mm_struct;
    print_pgfault(tf);
    if (check_mm_struct != NULL) {
        return do_pgfault(check_mm_struct, tf->tf_err, rcr2());
    }
    panic("unhandled page fault.\n");
c01026ee:	c7 44 24 08 0b 95 10 	movl   $0xc010950b,0x8(%esp)
c01026f5:	c0 
c01026f6:	c7 44 24 04 a6 00 00 	movl   $0xa6,0x4(%esp)
c01026fd:	00 
c01026fe:	c7 04 24 0e 93 10 c0 	movl   $0xc010930e,(%esp)
c0102705:	e8 ae e5 ff ff       	call   c0100cb8 <__panic>

c010270a <trap_dispatch>:

static volatile int in_swap_tick_event = 0;
extern struct mm_struct *check_mm_struct;

static void
trap_dispatch(struct trapframe *tf) {
c010270a:	55                   	push   %ebp
c010270b:	89 e5                	mov    %esp,%ebp
c010270d:	83 ec 28             	sub    $0x28,%esp
    char c;

    int ret;

    switch (tf->tf_trapno) {
c0102710:	8b 45 08             	mov    0x8(%ebp),%eax
c0102713:	8b 40 30             	mov    0x30(%eax),%eax
c0102716:	83 f8 24             	cmp    $0x24,%eax
c0102719:	0f 84 c2 00 00 00    	je     c01027e1 <trap_dispatch+0xd7>
c010271f:	83 f8 24             	cmp    $0x24,%eax
c0102722:	77 18                	ja     c010273c <trap_dispatch+0x32>
c0102724:	83 f8 20             	cmp    $0x20,%eax
c0102727:	74 7c                	je     c01027a5 <trap_dispatch+0x9b>
c0102729:	83 f8 21             	cmp    $0x21,%eax
c010272c:	0f 84 d8 00 00 00    	je     c010280a <trap_dispatch+0x100>
c0102732:	83 f8 0e             	cmp    $0xe,%eax
c0102735:	74 28                	je     c010275f <trap_dispatch+0x55>
c0102737:	e9 10 01 00 00       	jmp    c010284c <trap_dispatch+0x142>
c010273c:	83 f8 2e             	cmp    $0x2e,%eax
c010273f:	0f 82 07 01 00 00    	jb     c010284c <trap_dispatch+0x142>
c0102745:	83 f8 2f             	cmp    $0x2f,%eax
c0102748:	0f 86 36 01 00 00    	jbe    c0102884 <trap_dispatch+0x17a>
c010274e:	83 e8 78             	sub    $0x78,%eax
c0102751:	83 f8 01             	cmp    $0x1,%eax
c0102754:	0f 87 f2 00 00 00    	ja     c010284c <trap_dispatch+0x142>
c010275a:	e9 d1 00 00 00       	jmp    c0102830 <trap_dispatch+0x126>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
c010275f:	8b 45 08             	mov    0x8(%ebp),%eax
c0102762:	89 04 24             	mov    %eax,(%esp)
c0102765:	e8 3d ff ff ff       	call   c01026a7 <pgfault_handler>
c010276a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010276d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0102771:	0f 84 10 01 00 00    	je     c0102887 <trap_dispatch+0x17d>
            print_trapframe(tf);
c0102777:	8b 45 08             	mov    0x8(%ebp),%eax
c010277a:	89 04 24             	mov    %eax,(%esp)
c010277d:	e8 2c fc ff ff       	call   c01023ae <print_trapframe>
            panic("handle pgfault failed. %e\n", ret);
c0102782:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0102785:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0102789:	c7 44 24 08 22 95 10 	movl   $0xc0109522,0x8(%esp)
c0102790:	c0 
c0102791:	c7 44 24 04 b6 00 00 	movl   $0xb6,0x4(%esp)
c0102798:	00 
c0102799:	c7 04 24 0e 93 10 c0 	movl   $0xc010930e,(%esp)
c01027a0:	e8 13 e5 ff ff       	call   c0100cb8 <__panic>
        /* handle the timer interrupt */
        /* (1) After a timer interrupt, you should record this event using a global variable (increase it), such as ticks in kern/driver/clock.c
         * (2) Every TICK_NUM cycle, you can print some info using a funciton, such as print_ticks().
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
c01027a5:	a1 bc 1a 12 c0       	mov    0xc0121abc,%eax
c01027aa:	83 c0 01             	add    $0x1,%eax
c01027ad:	a3 bc 1a 12 c0       	mov    %eax,0xc0121abc
        if (ticks % TICK_NUM == 0) {
c01027b2:	8b 0d bc 1a 12 c0    	mov    0xc0121abc,%ecx
c01027b8:	ba 1f 85 eb 51       	mov    $0x51eb851f,%edx
c01027bd:	89 c8                	mov    %ecx,%eax
c01027bf:	f7 e2                	mul    %edx
c01027c1:	89 d0                	mov    %edx,%eax
c01027c3:	c1 e8 05             	shr    $0x5,%eax
c01027c6:	6b c0 64             	imul   $0x64,%eax,%eax
c01027c9:	89 ca                	mov    %ecx,%edx
c01027cb:	29 c2                	sub    %eax,%edx
c01027cd:	89 d0                	mov    %edx,%eax
c01027cf:	85 c0                	test   %eax,%eax
c01027d1:	0f 85 b3 00 00 00    	jne    c010288a <trap_dispatch+0x180>
            print_ticks();
c01027d7:	e8 d8 f9 ff ff       	call   c01021b4 <print_ticks>
        }        break;
c01027dc:	e9 a9 00 00 00       	jmp    c010288a <trap_dispatch+0x180>
    case IRQ_OFFSET + IRQ_COM1:
        c = cons_getc();
c01027e1:	e8 ee ee ff ff       	call   c01016d4 <cons_getc>
c01027e6:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("serial [%03d] %c\n", c, c);
c01027e9:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c01027ed:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c01027f1:	89 54 24 08          	mov    %edx,0x8(%esp)
c01027f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01027f9:	c7 04 24 3d 95 10 c0 	movl   $0xc010953d,(%esp)
c0102800:	e8 52 db ff ff       	call   c0100357 <cprintf>
        break;
c0102805:	e9 81 00 00 00       	jmp    c010288b <trap_dispatch+0x181>
    case IRQ_OFFSET + IRQ_KBD:
        c = cons_getc();
c010280a:	e8 c5 ee ff ff       	call   c01016d4 <cons_getc>
c010280f:	88 45 f3             	mov    %al,-0xd(%ebp)
        cprintf("kbd [%03d] %c\n", c, c);
c0102812:	0f be 55 f3          	movsbl -0xd(%ebp),%edx
c0102816:	0f be 45 f3          	movsbl -0xd(%ebp),%eax
c010281a:	89 54 24 08          	mov    %edx,0x8(%esp)
c010281e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0102822:	c7 04 24 4f 95 10 c0 	movl   $0xc010954f,(%esp)
c0102829:	e8 29 db ff ff       	call   c0100357 <cprintf>
        break;
c010282e:	eb 5b                	jmp    c010288b <trap_dispatch+0x181>
    //LAB1 CHALLENGE 1 : YOUR CODE you should modify below codes.
    case T_SWITCH_TOU:
    case T_SWITCH_TOK:
        panic("T_SWITCH_** ??\n");
c0102830:	c7 44 24 08 5e 95 10 	movl   $0xc010955e,0x8(%esp)
c0102837:	c0 
c0102838:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c010283f:	00 
c0102840:	c7 04 24 0e 93 10 c0 	movl   $0xc010930e,(%esp)
c0102847:	e8 6c e4 ff ff       	call   c0100cb8 <__panic>
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
    default:
        // in kernel, it must be a mistake
        if ((tf->tf_cs & 3) == 0) {
c010284c:	8b 45 08             	mov    0x8(%ebp),%eax
c010284f:	0f b7 40 3c          	movzwl 0x3c(%eax),%eax
c0102853:	0f b7 c0             	movzwl %ax,%eax
c0102856:	83 e0 03             	and    $0x3,%eax
c0102859:	85 c0                	test   %eax,%eax
c010285b:	75 2e                	jne    c010288b <trap_dispatch+0x181>
            print_trapframe(tf);
c010285d:	8b 45 08             	mov    0x8(%ebp),%eax
c0102860:	89 04 24             	mov    %eax,(%esp)
c0102863:	e8 46 fb ff ff       	call   c01023ae <print_trapframe>
            panic("unexpected trap in kernel.\n");
c0102868:	c7 44 24 08 6e 95 10 	movl   $0xc010956e,0x8(%esp)
c010286f:	c0 
c0102870:	c7 44 24 04 dd 00 00 	movl   $0xdd,0x4(%esp)
c0102877:	00 
c0102878:	c7 04 24 0e 93 10 c0 	movl   $0xc010930e,(%esp)
c010287f:	e8 34 e4 ff ff       	call   c0100cb8 <__panic>
        panic("T_SWITCH_** ??\n");
        break;
    case IRQ_OFFSET + IRQ_IDE1:
    case IRQ_OFFSET + IRQ_IDE2:
        /* do nothing */
        break;
c0102884:	90                   	nop
c0102885:	eb 04                	jmp    c010288b <trap_dispatch+0x181>
    case T_PGFLT:  //page fault
        if ((ret = pgfault_handler(tf)) != 0) {
            print_trapframe(tf);
            panic("handle pgfault failed. %e\n", ret);
        }
        break;
c0102887:	90                   	nop
c0102888:	eb 01                	jmp    c010288b <trap_dispatch+0x181>
         * (3) Too Simple? Yes, I think so!
         */
        ticks ++;
        if (ticks % TICK_NUM == 0) {
            print_ticks();
        }        break;
c010288a:	90                   	nop
        if ((tf->tf_cs & 3) == 0) {
            print_trapframe(tf);
            panic("unexpected trap in kernel.\n");
        }
    }
}
c010288b:	c9                   	leave  
c010288c:	c3                   	ret    

c010288d <trap>:
 * trap - handles or dispatches an exception/interrupt. if and when trap() returns,
 * the code in kern/trap/trapentry.S restores the old CPU state saved in the
 * trapframe and then uses the iret instruction to return from the exception.
 * */
void
trap(struct trapframe *tf) {
c010288d:	55                   	push   %ebp
c010288e:	89 e5                	mov    %esp,%ebp
c0102890:	83 ec 18             	sub    $0x18,%esp
    // dispatch based on what type of trap occurred
    trap_dispatch(tf);
c0102893:	8b 45 08             	mov    0x8(%ebp),%eax
c0102896:	89 04 24             	mov    %eax,(%esp)
c0102899:	e8 6c fe ff ff       	call   c010270a <trap_dispatch>
}
c010289e:	c9                   	leave  
c010289f:	c3                   	ret    

c01028a0 <__alltraps>:
.text
.globl __alltraps
__alltraps:
    # push registers to build a trap frame
    # therefore make the stack look like a struct trapframe
    pushl %ds
c01028a0:	1e                   	push   %ds
    pushl %es
c01028a1:	06                   	push   %es
    pushl %fs
c01028a2:	0f a0                	push   %fs
    pushl %gs
c01028a4:	0f a8                	push   %gs
    pushal
c01028a6:	60                   	pusha  

    # load GD_KDATA into %ds and %es to set up data segments for kernel
    movl $GD_KDATA, %eax
c01028a7:	b8 10 00 00 00       	mov    $0x10,%eax
    movw %ax, %ds
c01028ac:	8e d8                	mov    %eax,%ds
    movw %ax, %es
c01028ae:	8e c0                	mov    %eax,%es

    # push %esp to pass a pointer to the trapframe as an argument to trap()
    pushl %esp
c01028b0:	54                   	push   %esp

    # call trap(tf), where tf=%esp
    call trap
c01028b1:	e8 d7 ff ff ff       	call   c010288d <trap>

    # pop the pushed stack pointer
    popl %esp
c01028b6:	5c                   	pop    %esp

c01028b7 <__trapret>:

    # return falls through to trapret...
.globl __trapret
__trapret:
    # restore registers from stack
    popal
c01028b7:	61                   	popa   

    # restore %ds, %es, %fs and %gs
    popl %gs
c01028b8:	0f a9                	pop    %gs
    popl %fs
c01028ba:	0f a1                	pop    %fs
    popl %es
c01028bc:	07                   	pop    %es
    popl %ds
c01028bd:	1f                   	pop    %ds

    # get rid of the trap number and error code
    addl $0x8, %esp
c01028be:	83 c4 08             	add    $0x8,%esp
    iret
c01028c1:	cf                   	iret   
	...

c01028c4 <vector0>:
# handler
.text
.globl __alltraps
.globl vector0
vector0:
  pushl $0
c01028c4:	6a 00                	push   $0x0
  pushl $0
c01028c6:	6a 00                	push   $0x0
  jmp __alltraps
c01028c8:	e9 d3 ff ff ff       	jmp    c01028a0 <__alltraps>

c01028cd <vector1>:
.globl vector1
vector1:
  pushl $0
c01028cd:	6a 00                	push   $0x0
  pushl $1
c01028cf:	6a 01                	push   $0x1
  jmp __alltraps
c01028d1:	e9 ca ff ff ff       	jmp    c01028a0 <__alltraps>

c01028d6 <vector2>:
.globl vector2
vector2:
  pushl $0
c01028d6:	6a 00                	push   $0x0
  pushl $2
c01028d8:	6a 02                	push   $0x2
  jmp __alltraps
c01028da:	e9 c1 ff ff ff       	jmp    c01028a0 <__alltraps>

c01028df <vector3>:
.globl vector3
vector3:
  pushl $0
c01028df:	6a 00                	push   $0x0
  pushl $3
c01028e1:	6a 03                	push   $0x3
  jmp __alltraps
c01028e3:	e9 b8 ff ff ff       	jmp    c01028a0 <__alltraps>

c01028e8 <vector4>:
.globl vector4
vector4:
  pushl $0
c01028e8:	6a 00                	push   $0x0
  pushl $4
c01028ea:	6a 04                	push   $0x4
  jmp __alltraps
c01028ec:	e9 af ff ff ff       	jmp    c01028a0 <__alltraps>

c01028f1 <vector5>:
.globl vector5
vector5:
  pushl $0
c01028f1:	6a 00                	push   $0x0
  pushl $5
c01028f3:	6a 05                	push   $0x5
  jmp __alltraps
c01028f5:	e9 a6 ff ff ff       	jmp    c01028a0 <__alltraps>

c01028fa <vector6>:
.globl vector6
vector6:
  pushl $0
c01028fa:	6a 00                	push   $0x0
  pushl $6
c01028fc:	6a 06                	push   $0x6
  jmp __alltraps
c01028fe:	e9 9d ff ff ff       	jmp    c01028a0 <__alltraps>

c0102903 <vector7>:
.globl vector7
vector7:
  pushl $0
c0102903:	6a 00                	push   $0x0
  pushl $7
c0102905:	6a 07                	push   $0x7
  jmp __alltraps
c0102907:	e9 94 ff ff ff       	jmp    c01028a0 <__alltraps>

c010290c <vector8>:
.globl vector8
vector8:
  pushl $8
c010290c:	6a 08                	push   $0x8
  jmp __alltraps
c010290e:	e9 8d ff ff ff       	jmp    c01028a0 <__alltraps>

c0102913 <vector9>:
.globl vector9
vector9:
  pushl $9
c0102913:	6a 09                	push   $0x9
  jmp __alltraps
c0102915:	e9 86 ff ff ff       	jmp    c01028a0 <__alltraps>

c010291a <vector10>:
.globl vector10
vector10:
  pushl $10
c010291a:	6a 0a                	push   $0xa
  jmp __alltraps
c010291c:	e9 7f ff ff ff       	jmp    c01028a0 <__alltraps>

c0102921 <vector11>:
.globl vector11
vector11:
  pushl $11
c0102921:	6a 0b                	push   $0xb
  jmp __alltraps
c0102923:	e9 78 ff ff ff       	jmp    c01028a0 <__alltraps>

c0102928 <vector12>:
.globl vector12
vector12:
  pushl $12
c0102928:	6a 0c                	push   $0xc
  jmp __alltraps
c010292a:	e9 71 ff ff ff       	jmp    c01028a0 <__alltraps>

c010292f <vector13>:
.globl vector13
vector13:
  pushl $13
c010292f:	6a 0d                	push   $0xd
  jmp __alltraps
c0102931:	e9 6a ff ff ff       	jmp    c01028a0 <__alltraps>

c0102936 <vector14>:
.globl vector14
vector14:
  pushl $14
c0102936:	6a 0e                	push   $0xe
  jmp __alltraps
c0102938:	e9 63 ff ff ff       	jmp    c01028a0 <__alltraps>

c010293d <vector15>:
.globl vector15
vector15:
  pushl $0
c010293d:	6a 00                	push   $0x0
  pushl $15
c010293f:	6a 0f                	push   $0xf
  jmp __alltraps
c0102941:	e9 5a ff ff ff       	jmp    c01028a0 <__alltraps>

c0102946 <vector16>:
.globl vector16
vector16:
  pushl $0
c0102946:	6a 00                	push   $0x0
  pushl $16
c0102948:	6a 10                	push   $0x10
  jmp __alltraps
c010294a:	e9 51 ff ff ff       	jmp    c01028a0 <__alltraps>

c010294f <vector17>:
.globl vector17
vector17:
  pushl $17
c010294f:	6a 11                	push   $0x11
  jmp __alltraps
c0102951:	e9 4a ff ff ff       	jmp    c01028a0 <__alltraps>

c0102956 <vector18>:
.globl vector18
vector18:
  pushl $0
c0102956:	6a 00                	push   $0x0
  pushl $18
c0102958:	6a 12                	push   $0x12
  jmp __alltraps
c010295a:	e9 41 ff ff ff       	jmp    c01028a0 <__alltraps>

c010295f <vector19>:
.globl vector19
vector19:
  pushl $0
c010295f:	6a 00                	push   $0x0
  pushl $19
c0102961:	6a 13                	push   $0x13
  jmp __alltraps
c0102963:	e9 38 ff ff ff       	jmp    c01028a0 <__alltraps>

c0102968 <vector20>:
.globl vector20
vector20:
  pushl $0
c0102968:	6a 00                	push   $0x0
  pushl $20
c010296a:	6a 14                	push   $0x14
  jmp __alltraps
c010296c:	e9 2f ff ff ff       	jmp    c01028a0 <__alltraps>

c0102971 <vector21>:
.globl vector21
vector21:
  pushl $0
c0102971:	6a 00                	push   $0x0
  pushl $21
c0102973:	6a 15                	push   $0x15
  jmp __alltraps
c0102975:	e9 26 ff ff ff       	jmp    c01028a0 <__alltraps>

c010297a <vector22>:
.globl vector22
vector22:
  pushl $0
c010297a:	6a 00                	push   $0x0
  pushl $22
c010297c:	6a 16                	push   $0x16
  jmp __alltraps
c010297e:	e9 1d ff ff ff       	jmp    c01028a0 <__alltraps>

c0102983 <vector23>:
.globl vector23
vector23:
  pushl $0
c0102983:	6a 00                	push   $0x0
  pushl $23
c0102985:	6a 17                	push   $0x17
  jmp __alltraps
c0102987:	e9 14 ff ff ff       	jmp    c01028a0 <__alltraps>

c010298c <vector24>:
.globl vector24
vector24:
  pushl $0
c010298c:	6a 00                	push   $0x0
  pushl $24
c010298e:	6a 18                	push   $0x18
  jmp __alltraps
c0102990:	e9 0b ff ff ff       	jmp    c01028a0 <__alltraps>

c0102995 <vector25>:
.globl vector25
vector25:
  pushl $0
c0102995:	6a 00                	push   $0x0
  pushl $25
c0102997:	6a 19                	push   $0x19
  jmp __alltraps
c0102999:	e9 02 ff ff ff       	jmp    c01028a0 <__alltraps>

c010299e <vector26>:
.globl vector26
vector26:
  pushl $0
c010299e:	6a 00                	push   $0x0
  pushl $26
c01029a0:	6a 1a                	push   $0x1a
  jmp __alltraps
c01029a2:	e9 f9 fe ff ff       	jmp    c01028a0 <__alltraps>

c01029a7 <vector27>:
.globl vector27
vector27:
  pushl $0
c01029a7:	6a 00                	push   $0x0
  pushl $27
c01029a9:	6a 1b                	push   $0x1b
  jmp __alltraps
c01029ab:	e9 f0 fe ff ff       	jmp    c01028a0 <__alltraps>

c01029b0 <vector28>:
.globl vector28
vector28:
  pushl $0
c01029b0:	6a 00                	push   $0x0
  pushl $28
c01029b2:	6a 1c                	push   $0x1c
  jmp __alltraps
c01029b4:	e9 e7 fe ff ff       	jmp    c01028a0 <__alltraps>

c01029b9 <vector29>:
.globl vector29
vector29:
  pushl $0
c01029b9:	6a 00                	push   $0x0
  pushl $29
c01029bb:	6a 1d                	push   $0x1d
  jmp __alltraps
c01029bd:	e9 de fe ff ff       	jmp    c01028a0 <__alltraps>

c01029c2 <vector30>:
.globl vector30
vector30:
  pushl $0
c01029c2:	6a 00                	push   $0x0
  pushl $30
c01029c4:	6a 1e                	push   $0x1e
  jmp __alltraps
c01029c6:	e9 d5 fe ff ff       	jmp    c01028a0 <__alltraps>

c01029cb <vector31>:
.globl vector31
vector31:
  pushl $0
c01029cb:	6a 00                	push   $0x0
  pushl $31
c01029cd:	6a 1f                	push   $0x1f
  jmp __alltraps
c01029cf:	e9 cc fe ff ff       	jmp    c01028a0 <__alltraps>

c01029d4 <vector32>:
.globl vector32
vector32:
  pushl $0
c01029d4:	6a 00                	push   $0x0
  pushl $32
c01029d6:	6a 20                	push   $0x20
  jmp __alltraps
c01029d8:	e9 c3 fe ff ff       	jmp    c01028a0 <__alltraps>

c01029dd <vector33>:
.globl vector33
vector33:
  pushl $0
c01029dd:	6a 00                	push   $0x0
  pushl $33
c01029df:	6a 21                	push   $0x21
  jmp __alltraps
c01029e1:	e9 ba fe ff ff       	jmp    c01028a0 <__alltraps>

c01029e6 <vector34>:
.globl vector34
vector34:
  pushl $0
c01029e6:	6a 00                	push   $0x0
  pushl $34
c01029e8:	6a 22                	push   $0x22
  jmp __alltraps
c01029ea:	e9 b1 fe ff ff       	jmp    c01028a0 <__alltraps>

c01029ef <vector35>:
.globl vector35
vector35:
  pushl $0
c01029ef:	6a 00                	push   $0x0
  pushl $35
c01029f1:	6a 23                	push   $0x23
  jmp __alltraps
c01029f3:	e9 a8 fe ff ff       	jmp    c01028a0 <__alltraps>

c01029f8 <vector36>:
.globl vector36
vector36:
  pushl $0
c01029f8:	6a 00                	push   $0x0
  pushl $36
c01029fa:	6a 24                	push   $0x24
  jmp __alltraps
c01029fc:	e9 9f fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a01 <vector37>:
.globl vector37
vector37:
  pushl $0
c0102a01:	6a 00                	push   $0x0
  pushl $37
c0102a03:	6a 25                	push   $0x25
  jmp __alltraps
c0102a05:	e9 96 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a0a <vector38>:
.globl vector38
vector38:
  pushl $0
c0102a0a:	6a 00                	push   $0x0
  pushl $38
c0102a0c:	6a 26                	push   $0x26
  jmp __alltraps
c0102a0e:	e9 8d fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a13 <vector39>:
.globl vector39
vector39:
  pushl $0
c0102a13:	6a 00                	push   $0x0
  pushl $39
c0102a15:	6a 27                	push   $0x27
  jmp __alltraps
c0102a17:	e9 84 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a1c <vector40>:
.globl vector40
vector40:
  pushl $0
c0102a1c:	6a 00                	push   $0x0
  pushl $40
c0102a1e:	6a 28                	push   $0x28
  jmp __alltraps
c0102a20:	e9 7b fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a25 <vector41>:
.globl vector41
vector41:
  pushl $0
c0102a25:	6a 00                	push   $0x0
  pushl $41
c0102a27:	6a 29                	push   $0x29
  jmp __alltraps
c0102a29:	e9 72 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a2e <vector42>:
.globl vector42
vector42:
  pushl $0
c0102a2e:	6a 00                	push   $0x0
  pushl $42
c0102a30:	6a 2a                	push   $0x2a
  jmp __alltraps
c0102a32:	e9 69 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a37 <vector43>:
.globl vector43
vector43:
  pushl $0
c0102a37:	6a 00                	push   $0x0
  pushl $43
c0102a39:	6a 2b                	push   $0x2b
  jmp __alltraps
c0102a3b:	e9 60 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a40 <vector44>:
.globl vector44
vector44:
  pushl $0
c0102a40:	6a 00                	push   $0x0
  pushl $44
c0102a42:	6a 2c                	push   $0x2c
  jmp __alltraps
c0102a44:	e9 57 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a49 <vector45>:
.globl vector45
vector45:
  pushl $0
c0102a49:	6a 00                	push   $0x0
  pushl $45
c0102a4b:	6a 2d                	push   $0x2d
  jmp __alltraps
c0102a4d:	e9 4e fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a52 <vector46>:
.globl vector46
vector46:
  pushl $0
c0102a52:	6a 00                	push   $0x0
  pushl $46
c0102a54:	6a 2e                	push   $0x2e
  jmp __alltraps
c0102a56:	e9 45 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a5b <vector47>:
.globl vector47
vector47:
  pushl $0
c0102a5b:	6a 00                	push   $0x0
  pushl $47
c0102a5d:	6a 2f                	push   $0x2f
  jmp __alltraps
c0102a5f:	e9 3c fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a64 <vector48>:
.globl vector48
vector48:
  pushl $0
c0102a64:	6a 00                	push   $0x0
  pushl $48
c0102a66:	6a 30                	push   $0x30
  jmp __alltraps
c0102a68:	e9 33 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a6d <vector49>:
.globl vector49
vector49:
  pushl $0
c0102a6d:	6a 00                	push   $0x0
  pushl $49
c0102a6f:	6a 31                	push   $0x31
  jmp __alltraps
c0102a71:	e9 2a fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a76 <vector50>:
.globl vector50
vector50:
  pushl $0
c0102a76:	6a 00                	push   $0x0
  pushl $50
c0102a78:	6a 32                	push   $0x32
  jmp __alltraps
c0102a7a:	e9 21 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a7f <vector51>:
.globl vector51
vector51:
  pushl $0
c0102a7f:	6a 00                	push   $0x0
  pushl $51
c0102a81:	6a 33                	push   $0x33
  jmp __alltraps
c0102a83:	e9 18 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a88 <vector52>:
.globl vector52
vector52:
  pushl $0
c0102a88:	6a 00                	push   $0x0
  pushl $52
c0102a8a:	6a 34                	push   $0x34
  jmp __alltraps
c0102a8c:	e9 0f fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a91 <vector53>:
.globl vector53
vector53:
  pushl $0
c0102a91:	6a 00                	push   $0x0
  pushl $53
c0102a93:	6a 35                	push   $0x35
  jmp __alltraps
c0102a95:	e9 06 fe ff ff       	jmp    c01028a0 <__alltraps>

c0102a9a <vector54>:
.globl vector54
vector54:
  pushl $0
c0102a9a:	6a 00                	push   $0x0
  pushl $54
c0102a9c:	6a 36                	push   $0x36
  jmp __alltraps
c0102a9e:	e9 fd fd ff ff       	jmp    c01028a0 <__alltraps>

c0102aa3 <vector55>:
.globl vector55
vector55:
  pushl $0
c0102aa3:	6a 00                	push   $0x0
  pushl $55
c0102aa5:	6a 37                	push   $0x37
  jmp __alltraps
c0102aa7:	e9 f4 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102aac <vector56>:
.globl vector56
vector56:
  pushl $0
c0102aac:	6a 00                	push   $0x0
  pushl $56
c0102aae:	6a 38                	push   $0x38
  jmp __alltraps
c0102ab0:	e9 eb fd ff ff       	jmp    c01028a0 <__alltraps>

c0102ab5 <vector57>:
.globl vector57
vector57:
  pushl $0
c0102ab5:	6a 00                	push   $0x0
  pushl $57
c0102ab7:	6a 39                	push   $0x39
  jmp __alltraps
c0102ab9:	e9 e2 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102abe <vector58>:
.globl vector58
vector58:
  pushl $0
c0102abe:	6a 00                	push   $0x0
  pushl $58
c0102ac0:	6a 3a                	push   $0x3a
  jmp __alltraps
c0102ac2:	e9 d9 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102ac7 <vector59>:
.globl vector59
vector59:
  pushl $0
c0102ac7:	6a 00                	push   $0x0
  pushl $59
c0102ac9:	6a 3b                	push   $0x3b
  jmp __alltraps
c0102acb:	e9 d0 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102ad0 <vector60>:
.globl vector60
vector60:
  pushl $0
c0102ad0:	6a 00                	push   $0x0
  pushl $60
c0102ad2:	6a 3c                	push   $0x3c
  jmp __alltraps
c0102ad4:	e9 c7 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102ad9 <vector61>:
.globl vector61
vector61:
  pushl $0
c0102ad9:	6a 00                	push   $0x0
  pushl $61
c0102adb:	6a 3d                	push   $0x3d
  jmp __alltraps
c0102add:	e9 be fd ff ff       	jmp    c01028a0 <__alltraps>

c0102ae2 <vector62>:
.globl vector62
vector62:
  pushl $0
c0102ae2:	6a 00                	push   $0x0
  pushl $62
c0102ae4:	6a 3e                	push   $0x3e
  jmp __alltraps
c0102ae6:	e9 b5 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102aeb <vector63>:
.globl vector63
vector63:
  pushl $0
c0102aeb:	6a 00                	push   $0x0
  pushl $63
c0102aed:	6a 3f                	push   $0x3f
  jmp __alltraps
c0102aef:	e9 ac fd ff ff       	jmp    c01028a0 <__alltraps>

c0102af4 <vector64>:
.globl vector64
vector64:
  pushl $0
c0102af4:	6a 00                	push   $0x0
  pushl $64
c0102af6:	6a 40                	push   $0x40
  jmp __alltraps
c0102af8:	e9 a3 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102afd <vector65>:
.globl vector65
vector65:
  pushl $0
c0102afd:	6a 00                	push   $0x0
  pushl $65
c0102aff:	6a 41                	push   $0x41
  jmp __alltraps
c0102b01:	e9 9a fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b06 <vector66>:
.globl vector66
vector66:
  pushl $0
c0102b06:	6a 00                	push   $0x0
  pushl $66
c0102b08:	6a 42                	push   $0x42
  jmp __alltraps
c0102b0a:	e9 91 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b0f <vector67>:
.globl vector67
vector67:
  pushl $0
c0102b0f:	6a 00                	push   $0x0
  pushl $67
c0102b11:	6a 43                	push   $0x43
  jmp __alltraps
c0102b13:	e9 88 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b18 <vector68>:
.globl vector68
vector68:
  pushl $0
c0102b18:	6a 00                	push   $0x0
  pushl $68
c0102b1a:	6a 44                	push   $0x44
  jmp __alltraps
c0102b1c:	e9 7f fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b21 <vector69>:
.globl vector69
vector69:
  pushl $0
c0102b21:	6a 00                	push   $0x0
  pushl $69
c0102b23:	6a 45                	push   $0x45
  jmp __alltraps
c0102b25:	e9 76 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b2a <vector70>:
.globl vector70
vector70:
  pushl $0
c0102b2a:	6a 00                	push   $0x0
  pushl $70
c0102b2c:	6a 46                	push   $0x46
  jmp __alltraps
c0102b2e:	e9 6d fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b33 <vector71>:
.globl vector71
vector71:
  pushl $0
c0102b33:	6a 00                	push   $0x0
  pushl $71
c0102b35:	6a 47                	push   $0x47
  jmp __alltraps
c0102b37:	e9 64 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b3c <vector72>:
.globl vector72
vector72:
  pushl $0
c0102b3c:	6a 00                	push   $0x0
  pushl $72
c0102b3e:	6a 48                	push   $0x48
  jmp __alltraps
c0102b40:	e9 5b fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b45 <vector73>:
.globl vector73
vector73:
  pushl $0
c0102b45:	6a 00                	push   $0x0
  pushl $73
c0102b47:	6a 49                	push   $0x49
  jmp __alltraps
c0102b49:	e9 52 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b4e <vector74>:
.globl vector74
vector74:
  pushl $0
c0102b4e:	6a 00                	push   $0x0
  pushl $74
c0102b50:	6a 4a                	push   $0x4a
  jmp __alltraps
c0102b52:	e9 49 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b57 <vector75>:
.globl vector75
vector75:
  pushl $0
c0102b57:	6a 00                	push   $0x0
  pushl $75
c0102b59:	6a 4b                	push   $0x4b
  jmp __alltraps
c0102b5b:	e9 40 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b60 <vector76>:
.globl vector76
vector76:
  pushl $0
c0102b60:	6a 00                	push   $0x0
  pushl $76
c0102b62:	6a 4c                	push   $0x4c
  jmp __alltraps
c0102b64:	e9 37 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b69 <vector77>:
.globl vector77
vector77:
  pushl $0
c0102b69:	6a 00                	push   $0x0
  pushl $77
c0102b6b:	6a 4d                	push   $0x4d
  jmp __alltraps
c0102b6d:	e9 2e fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b72 <vector78>:
.globl vector78
vector78:
  pushl $0
c0102b72:	6a 00                	push   $0x0
  pushl $78
c0102b74:	6a 4e                	push   $0x4e
  jmp __alltraps
c0102b76:	e9 25 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b7b <vector79>:
.globl vector79
vector79:
  pushl $0
c0102b7b:	6a 00                	push   $0x0
  pushl $79
c0102b7d:	6a 4f                	push   $0x4f
  jmp __alltraps
c0102b7f:	e9 1c fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b84 <vector80>:
.globl vector80
vector80:
  pushl $0
c0102b84:	6a 00                	push   $0x0
  pushl $80
c0102b86:	6a 50                	push   $0x50
  jmp __alltraps
c0102b88:	e9 13 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b8d <vector81>:
.globl vector81
vector81:
  pushl $0
c0102b8d:	6a 00                	push   $0x0
  pushl $81
c0102b8f:	6a 51                	push   $0x51
  jmp __alltraps
c0102b91:	e9 0a fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b96 <vector82>:
.globl vector82
vector82:
  pushl $0
c0102b96:	6a 00                	push   $0x0
  pushl $82
c0102b98:	6a 52                	push   $0x52
  jmp __alltraps
c0102b9a:	e9 01 fd ff ff       	jmp    c01028a0 <__alltraps>

c0102b9f <vector83>:
.globl vector83
vector83:
  pushl $0
c0102b9f:	6a 00                	push   $0x0
  pushl $83
c0102ba1:	6a 53                	push   $0x53
  jmp __alltraps
c0102ba3:	e9 f8 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102ba8 <vector84>:
.globl vector84
vector84:
  pushl $0
c0102ba8:	6a 00                	push   $0x0
  pushl $84
c0102baa:	6a 54                	push   $0x54
  jmp __alltraps
c0102bac:	e9 ef fc ff ff       	jmp    c01028a0 <__alltraps>

c0102bb1 <vector85>:
.globl vector85
vector85:
  pushl $0
c0102bb1:	6a 00                	push   $0x0
  pushl $85
c0102bb3:	6a 55                	push   $0x55
  jmp __alltraps
c0102bb5:	e9 e6 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102bba <vector86>:
.globl vector86
vector86:
  pushl $0
c0102bba:	6a 00                	push   $0x0
  pushl $86
c0102bbc:	6a 56                	push   $0x56
  jmp __alltraps
c0102bbe:	e9 dd fc ff ff       	jmp    c01028a0 <__alltraps>

c0102bc3 <vector87>:
.globl vector87
vector87:
  pushl $0
c0102bc3:	6a 00                	push   $0x0
  pushl $87
c0102bc5:	6a 57                	push   $0x57
  jmp __alltraps
c0102bc7:	e9 d4 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102bcc <vector88>:
.globl vector88
vector88:
  pushl $0
c0102bcc:	6a 00                	push   $0x0
  pushl $88
c0102bce:	6a 58                	push   $0x58
  jmp __alltraps
c0102bd0:	e9 cb fc ff ff       	jmp    c01028a0 <__alltraps>

c0102bd5 <vector89>:
.globl vector89
vector89:
  pushl $0
c0102bd5:	6a 00                	push   $0x0
  pushl $89
c0102bd7:	6a 59                	push   $0x59
  jmp __alltraps
c0102bd9:	e9 c2 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102bde <vector90>:
.globl vector90
vector90:
  pushl $0
c0102bde:	6a 00                	push   $0x0
  pushl $90
c0102be0:	6a 5a                	push   $0x5a
  jmp __alltraps
c0102be2:	e9 b9 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102be7 <vector91>:
.globl vector91
vector91:
  pushl $0
c0102be7:	6a 00                	push   $0x0
  pushl $91
c0102be9:	6a 5b                	push   $0x5b
  jmp __alltraps
c0102beb:	e9 b0 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102bf0 <vector92>:
.globl vector92
vector92:
  pushl $0
c0102bf0:	6a 00                	push   $0x0
  pushl $92
c0102bf2:	6a 5c                	push   $0x5c
  jmp __alltraps
c0102bf4:	e9 a7 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102bf9 <vector93>:
.globl vector93
vector93:
  pushl $0
c0102bf9:	6a 00                	push   $0x0
  pushl $93
c0102bfb:	6a 5d                	push   $0x5d
  jmp __alltraps
c0102bfd:	e9 9e fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c02 <vector94>:
.globl vector94
vector94:
  pushl $0
c0102c02:	6a 00                	push   $0x0
  pushl $94
c0102c04:	6a 5e                	push   $0x5e
  jmp __alltraps
c0102c06:	e9 95 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c0b <vector95>:
.globl vector95
vector95:
  pushl $0
c0102c0b:	6a 00                	push   $0x0
  pushl $95
c0102c0d:	6a 5f                	push   $0x5f
  jmp __alltraps
c0102c0f:	e9 8c fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c14 <vector96>:
.globl vector96
vector96:
  pushl $0
c0102c14:	6a 00                	push   $0x0
  pushl $96
c0102c16:	6a 60                	push   $0x60
  jmp __alltraps
c0102c18:	e9 83 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c1d <vector97>:
.globl vector97
vector97:
  pushl $0
c0102c1d:	6a 00                	push   $0x0
  pushl $97
c0102c1f:	6a 61                	push   $0x61
  jmp __alltraps
c0102c21:	e9 7a fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c26 <vector98>:
.globl vector98
vector98:
  pushl $0
c0102c26:	6a 00                	push   $0x0
  pushl $98
c0102c28:	6a 62                	push   $0x62
  jmp __alltraps
c0102c2a:	e9 71 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c2f <vector99>:
.globl vector99
vector99:
  pushl $0
c0102c2f:	6a 00                	push   $0x0
  pushl $99
c0102c31:	6a 63                	push   $0x63
  jmp __alltraps
c0102c33:	e9 68 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c38 <vector100>:
.globl vector100
vector100:
  pushl $0
c0102c38:	6a 00                	push   $0x0
  pushl $100
c0102c3a:	6a 64                	push   $0x64
  jmp __alltraps
c0102c3c:	e9 5f fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c41 <vector101>:
.globl vector101
vector101:
  pushl $0
c0102c41:	6a 00                	push   $0x0
  pushl $101
c0102c43:	6a 65                	push   $0x65
  jmp __alltraps
c0102c45:	e9 56 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c4a <vector102>:
.globl vector102
vector102:
  pushl $0
c0102c4a:	6a 00                	push   $0x0
  pushl $102
c0102c4c:	6a 66                	push   $0x66
  jmp __alltraps
c0102c4e:	e9 4d fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c53 <vector103>:
.globl vector103
vector103:
  pushl $0
c0102c53:	6a 00                	push   $0x0
  pushl $103
c0102c55:	6a 67                	push   $0x67
  jmp __alltraps
c0102c57:	e9 44 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c5c <vector104>:
.globl vector104
vector104:
  pushl $0
c0102c5c:	6a 00                	push   $0x0
  pushl $104
c0102c5e:	6a 68                	push   $0x68
  jmp __alltraps
c0102c60:	e9 3b fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c65 <vector105>:
.globl vector105
vector105:
  pushl $0
c0102c65:	6a 00                	push   $0x0
  pushl $105
c0102c67:	6a 69                	push   $0x69
  jmp __alltraps
c0102c69:	e9 32 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c6e <vector106>:
.globl vector106
vector106:
  pushl $0
c0102c6e:	6a 00                	push   $0x0
  pushl $106
c0102c70:	6a 6a                	push   $0x6a
  jmp __alltraps
c0102c72:	e9 29 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c77 <vector107>:
.globl vector107
vector107:
  pushl $0
c0102c77:	6a 00                	push   $0x0
  pushl $107
c0102c79:	6a 6b                	push   $0x6b
  jmp __alltraps
c0102c7b:	e9 20 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c80 <vector108>:
.globl vector108
vector108:
  pushl $0
c0102c80:	6a 00                	push   $0x0
  pushl $108
c0102c82:	6a 6c                	push   $0x6c
  jmp __alltraps
c0102c84:	e9 17 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c89 <vector109>:
.globl vector109
vector109:
  pushl $0
c0102c89:	6a 00                	push   $0x0
  pushl $109
c0102c8b:	6a 6d                	push   $0x6d
  jmp __alltraps
c0102c8d:	e9 0e fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c92 <vector110>:
.globl vector110
vector110:
  pushl $0
c0102c92:	6a 00                	push   $0x0
  pushl $110
c0102c94:	6a 6e                	push   $0x6e
  jmp __alltraps
c0102c96:	e9 05 fc ff ff       	jmp    c01028a0 <__alltraps>

c0102c9b <vector111>:
.globl vector111
vector111:
  pushl $0
c0102c9b:	6a 00                	push   $0x0
  pushl $111
c0102c9d:	6a 6f                	push   $0x6f
  jmp __alltraps
c0102c9f:	e9 fc fb ff ff       	jmp    c01028a0 <__alltraps>

c0102ca4 <vector112>:
.globl vector112
vector112:
  pushl $0
c0102ca4:	6a 00                	push   $0x0
  pushl $112
c0102ca6:	6a 70                	push   $0x70
  jmp __alltraps
c0102ca8:	e9 f3 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102cad <vector113>:
.globl vector113
vector113:
  pushl $0
c0102cad:	6a 00                	push   $0x0
  pushl $113
c0102caf:	6a 71                	push   $0x71
  jmp __alltraps
c0102cb1:	e9 ea fb ff ff       	jmp    c01028a0 <__alltraps>

c0102cb6 <vector114>:
.globl vector114
vector114:
  pushl $0
c0102cb6:	6a 00                	push   $0x0
  pushl $114
c0102cb8:	6a 72                	push   $0x72
  jmp __alltraps
c0102cba:	e9 e1 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102cbf <vector115>:
.globl vector115
vector115:
  pushl $0
c0102cbf:	6a 00                	push   $0x0
  pushl $115
c0102cc1:	6a 73                	push   $0x73
  jmp __alltraps
c0102cc3:	e9 d8 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102cc8 <vector116>:
.globl vector116
vector116:
  pushl $0
c0102cc8:	6a 00                	push   $0x0
  pushl $116
c0102cca:	6a 74                	push   $0x74
  jmp __alltraps
c0102ccc:	e9 cf fb ff ff       	jmp    c01028a0 <__alltraps>

c0102cd1 <vector117>:
.globl vector117
vector117:
  pushl $0
c0102cd1:	6a 00                	push   $0x0
  pushl $117
c0102cd3:	6a 75                	push   $0x75
  jmp __alltraps
c0102cd5:	e9 c6 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102cda <vector118>:
.globl vector118
vector118:
  pushl $0
c0102cda:	6a 00                	push   $0x0
  pushl $118
c0102cdc:	6a 76                	push   $0x76
  jmp __alltraps
c0102cde:	e9 bd fb ff ff       	jmp    c01028a0 <__alltraps>

c0102ce3 <vector119>:
.globl vector119
vector119:
  pushl $0
c0102ce3:	6a 00                	push   $0x0
  pushl $119
c0102ce5:	6a 77                	push   $0x77
  jmp __alltraps
c0102ce7:	e9 b4 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102cec <vector120>:
.globl vector120
vector120:
  pushl $0
c0102cec:	6a 00                	push   $0x0
  pushl $120
c0102cee:	6a 78                	push   $0x78
  jmp __alltraps
c0102cf0:	e9 ab fb ff ff       	jmp    c01028a0 <__alltraps>

c0102cf5 <vector121>:
.globl vector121
vector121:
  pushl $0
c0102cf5:	6a 00                	push   $0x0
  pushl $121
c0102cf7:	6a 79                	push   $0x79
  jmp __alltraps
c0102cf9:	e9 a2 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102cfe <vector122>:
.globl vector122
vector122:
  pushl $0
c0102cfe:	6a 00                	push   $0x0
  pushl $122
c0102d00:	6a 7a                	push   $0x7a
  jmp __alltraps
c0102d02:	e9 99 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d07 <vector123>:
.globl vector123
vector123:
  pushl $0
c0102d07:	6a 00                	push   $0x0
  pushl $123
c0102d09:	6a 7b                	push   $0x7b
  jmp __alltraps
c0102d0b:	e9 90 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d10 <vector124>:
.globl vector124
vector124:
  pushl $0
c0102d10:	6a 00                	push   $0x0
  pushl $124
c0102d12:	6a 7c                	push   $0x7c
  jmp __alltraps
c0102d14:	e9 87 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d19 <vector125>:
.globl vector125
vector125:
  pushl $0
c0102d19:	6a 00                	push   $0x0
  pushl $125
c0102d1b:	6a 7d                	push   $0x7d
  jmp __alltraps
c0102d1d:	e9 7e fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d22 <vector126>:
.globl vector126
vector126:
  pushl $0
c0102d22:	6a 00                	push   $0x0
  pushl $126
c0102d24:	6a 7e                	push   $0x7e
  jmp __alltraps
c0102d26:	e9 75 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d2b <vector127>:
.globl vector127
vector127:
  pushl $0
c0102d2b:	6a 00                	push   $0x0
  pushl $127
c0102d2d:	6a 7f                	push   $0x7f
  jmp __alltraps
c0102d2f:	e9 6c fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d34 <vector128>:
.globl vector128
vector128:
  pushl $0
c0102d34:	6a 00                	push   $0x0
  pushl $128
c0102d36:	68 80 00 00 00       	push   $0x80
  jmp __alltraps
c0102d3b:	e9 60 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d40 <vector129>:
.globl vector129
vector129:
  pushl $0
c0102d40:	6a 00                	push   $0x0
  pushl $129
c0102d42:	68 81 00 00 00       	push   $0x81
  jmp __alltraps
c0102d47:	e9 54 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d4c <vector130>:
.globl vector130
vector130:
  pushl $0
c0102d4c:	6a 00                	push   $0x0
  pushl $130
c0102d4e:	68 82 00 00 00       	push   $0x82
  jmp __alltraps
c0102d53:	e9 48 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d58 <vector131>:
.globl vector131
vector131:
  pushl $0
c0102d58:	6a 00                	push   $0x0
  pushl $131
c0102d5a:	68 83 00 00 00       	push   $0x83
  jmp __alltraps
c0102d5f:	e9 3c fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d64 <vector132>:
.globl vector132
vector132:
  pushl $0
c0102d64:	6a 00                	push   $0x0
  pushl $132
c0102d66:	68 84 00 00 00       	push   $0x84
  jmp __alltraps
c0102d6b:	e9 30 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d70 <vector133>:
.globl vector133
vector133:
  pushl $0
c0102d70:	6a 00                	push   $0x0
  pushl $133
c0102d72:	68 85 00 00 00       	push   $0x85
  jmp __alltraps
c0102d77:	e9 24 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d7c <vector134>:
.globl vector134
vector134:
  pushl $0
c0102d7c:	6a 00                	push   $0x0
  pushl $134
c0102d7e:	68 86 00 00 00       	push   $0x86
  jmp __alltraps
c0102d83:	e9 18 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d88 <vector135>:
.globl vector135
vector135:
  pushl $0
c0102d88:	6a 00                	push   $0x0
  pushl $135
c0102d8a:	68 87 00 00 00       	push   $0x87
  jmp __alltraps
c0102d8f:	e9 0c fb ff ff       	jmp    c01028a0 <__alltraps>

c0102d94 <vector136>:
.globl vector136
vector136:
  pushl $0
c0102d94:	6a 00                	push   $0x0
  pushl $136
c0102d96:	68 88 00 00 00       	push   $0x88
  jmp __alltraps
c0102d9b:	e9 00 fb ff ff       	jmp    c01028a0 <__alltraps>

c0102da0 <vector137>:
.globl vector137
vector137:
  pushl $0
c0102da0:	6a 00                	push   $0x0
  pushl $137
c0102da2:	68 89 00 00 00       	push   $0x89
  jmp __alltraps
c0102da7:	e9 f4 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102dac <vector138>:
.globl vector138
vector138:
  pushl $0
c0102dac:	6a 00                	push   $0x0
  pushl $138
c0102dae:	68 8a 00 00 00       	push   $0x8a
  jmp __alltraps
c0102db3:	e9 e8 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102db8 <vector139>:
.globl vector139
vector139:
  pushl $0
c0102db8:	6a 00                	push   $0x0
  pushl $139
c0102dba:	68 8b 00 00 00       	push   $0x8b
  jmp __alltraps
c0102dbf:	e9 dc fa ff ff       	jmp    c01028a0 <__alltraps>

c0102dc4 <vector140>:
.globl vector140
vector140:
  pushl $0
c0102dc4:	6a 00                	push   $0x0
  pushl $140
c0102dc6:	68 8c 00 00 00       	push   $0x8c
  jmp __alltraps
c0102dcb:	e9 d0 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102dd0 <vector141>:
.globl vector141
vector141:
  pushl $0
c0102dd0:	6a 00                	push   $0x0
  pushl $141
c0102dd2:	68 8d 00 00 00       	push   $0x8d
  jmp __alltraps
c0102dd7:	e9 c4 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102ddc <vector142>:
.globl vector142
vector142:
  pushl $0
c0102ddc:	6a 00                	push   $0x0
  pushl $142
c0102dde:	68 8e 00 00 00       	push   $0x8e
  jmp __alltraps
c0102de3:	e9 b8 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102de8 <vector143>:
.globl vector143
vector143:
  pushl $0
c0102de8:	6a 00                	push   $0x0
  pushl $143
c0102dea:	68 8f 00 00 00       	push   $0x8f
  jmp __alltraps
c0102def:	e9 ac fa ff ff       	jmp    c01028a0 <__alltraps>

c0102df4 <vector144>:
.globl vector144
vector144:
  pushl $0
c0102df4:	6a 00                	push   $0x0
  pushl $144
c0102df6:	68 90 00 00 00       	push   $0x90
  jmp __alltraps
c0102dfb:	e9 a0 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e00 <vector145>:
.globl vector145
vector145:
  pushl $0
c0102e00:	6a 00                	push   $0x0
  pushl $145
c0102e02:	68 91 00 00 00       	push   $0x91
  jmp __alltraps
c0102e07:	e9 94 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e0c <vector146>:
.globl vector146
vector146:
  pushl $0
c0102e0c:	6a 00                	push   $0x0
  pushl $146
c0102e0e:	68 92 00 00 00       	push   $0x92
  jmp __alltraps
c0102e13:	e9 88 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e18 <vector147>:
.globl vector147
vector147:
  pushl $0
c0102e18:	6a 00                	push   $0x0
  pushl $147
c0102e1a:	68 93 00 00 00       	push   $0x93
  jmp __alltraps
c0102e1f:	e9 7c fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e24 <vector148>:
.globl vector148
vector148:
  pushl $0
c0102e24:	6a 00                	push   $0x0
  pushl $148
c0102e26:	68 94 00 00 00       	push   $0x94
  jmp __alltraps
c0102e2b:	e9 70 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e30 <vector149>:
.globl vector149
vector149:
  pushl $0
c0102e30:	6a 00                	push   $0x0
  pushl $149
c0102e32:	68 95 00 00 00       	push   $0x95
  jmp __alltraps
c0102e37:	e9 64 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e3c <vector150>:
.globl vector150
vector150:
  pushl $0
c0102e3c:	6a 00                	push   $0x0
  pushl $150
c0102e3e:	68 96 00 00 00       	push   $0x96
  jmp __alltraps
c0102e43:	e9 58 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e48 <vector151>:
.globl vector151
vector151:
  pushl $0
c0102e48:	6a 00                	push   $0x0
  pushl $151
c0102e4a:	68 97 00 00 00       	push   $0x97
  jmp __alltraps
c0102e4f:	e9 4c fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e54 <vector152>:
.globl vector152
vector152:
  pushl $0
c0102e54:	6a 00                	push   $0x0
  pushl $152
c0102e56:	68 98 00 00 00       	push   $0x98
  jmp __alltraps
c0102e5b:	e9 40 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e60 <vector153>:
.globl vector153
vector153:
  pushl $0
c0102e60:	6a 00                	push   $0x0
  pushl $153
c0102e62:	68 99 00 00 00       	push   $0x99
  jmp __alltraps
c0102e67:	e9 34 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e6c <vector154>:
.globl vector154
vector154:
  pushl $0
c0102e6c:	6a 00                	push   $0x0
  pushl $154
c0102e6e:	68 9a 00 00 00       	push   $0x9a
  jmp __alltraps
c0102e73:	e9 28 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e78 <vector155>:
.globl vector155
vector155:
  pushl $0
c0102e78:	6a 00                	push   $0x0
  pushl $155
c0102e7a:	68 9b 00 00 00       	push   $0x9b
  jmp __alltraps
c0102e7f:	e9 1c fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e84 <vector156>:
.globl vector156
vector156:
  pushl $0
c0102e84:	6a 00                	push   $0x0
  pushl $156
c0102e86:	68 9c 00 00 00       	push   $0x9c
  jmp __alltraps
c0102e8b:	e9 10 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e90 <vector157>:
.globl vector157
vector157:
  pushl $0
c0102e90:	6a 00                	push   $0x0
  pushl $157
c0102e92:	68 9d 00 00 00       	push   $0x9d
  jmp __alltraps
c0102e97:	e9 04 fa ff ff       	jmp    c01028a0 <__alltraps>

c0102e9c <vector158>:
.globl vector158
vector158:
  pushl $0
c0102e9c:	6a 00                	push   $0x0
  pushl $158
c0102e9e:	68 9e 00 00 00       	push   $0x9e
  jmp __alltraps
c0102ea3:	e9 f8 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102ea8 <vector159>:
.globl vector159
vector159:
  pushl $0
c0102ea8:	6a 00                	push   $0x0
  pushl $159
c0102eaa:	68 9f 00 00 00       	push   $0x9f
  jmp __alltraps
c0102eaf:	e9 ec f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102eb4 <vector160>:
.globl vector160
vector160:
  pushl $0
c0102eb4:	6a 00                	push   $0x0
  pushl $160
c0102eb6:	68 a0 00 00 00       	push   $0xa0
  jmp __alltraps
c0102ebb:	e9 e0 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102ec0 <vector161>:
.globl vector161
vector161:
  pushl $0
c0102ec0:	6a 00                	push   $0x0
  pushl $161
c0102ec2:	68 a1 00 00 00       	push   $0xa1
  jmp __alltraps
c0102ec7:	e9 d4 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102ecc <vector162>:
.globl vector162
vector162:
  pushl $0
c0102ecc:	6a 00                	push   $0x0
  pushl $162
c0102ece:	68 a2 00 00 00       	push   $0xa2
  jmp __alltraps
c0102ed3:	e9 c8 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102ed8 <vector163>:
.globl vector163
vector163:
  pushl $0
c0102ed8:	6a 00                	push   $0x0
  pushl $163
c0102eda:	68 a3 00 00 00       	push   $0xa3
  jmp __alltraps
c0102edf:	e9 bc f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102ee4 <vector164>:
.globl vector164
vector164:
  pushl $0
c0102ee4:	6a 00                	push   $0x0
  pushl $164
c0102ee6:	68 a4 00 00 00       	push   $0xa4
  jmp __alltraps
c0102eeb:	e9 b0 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102ef0 <vector165>:
.globl vector165
vector165:
  pushl $0
c0102ef0:	6a 00                	push   $0x0
  pushl $165
c0102ef2:	68 a5 00 00 00       	push   $0xa5
  jmp __alltraps
c0102ef7:	e9 a4 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102efc <vector166>:
.globl vector166
vector166:
  pushl $0
c0102efc:	6a 00                	push   $0x0
  pushl $166
c0102efe:	68 a6 00 00 00       	push   $0xa6
  jmp __alltraps
c0102f03:	e9 98 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f08 <vector167>:
.globl vector167
vector167:
  pushl $0
c0102f08:	6a 00                	push   $0x0
  pushl $167
c0102f0a:	68 a7 00 00 00       	push   $0xa7
  jmp __alltraps
c0102f0f:	e9 8c f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f14 <vector168>:
.globl vector168
vector168:
  pushl $0
c0102f14:	6a 00                	push   $0x0
  pushl $168
c0102f16:	68 a8 00 00 00       	push   $0xa8
  jmp __alltraps
c0102f1b:	e9 80 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f20 <vector169>:
.globl vector169
vector169:
  pushl $0
c0102f20:	6a 00                	push   $0x0
  pushl $169
c0102f22:	68 a9 00 00 00       	push   $0xa9
  jmp __alltraps
c0102f27:	e9 74 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f2c <vector170>:
.globl vector170
vector170:
  pushl $0
c0102f2c:	6a 00                	push   $0x0
  pushl $170
c0102f2e:	68 aa 00 00 00       	push   $0xaa
  jmp __alltraps
c0102f33:	e9 68 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f38 <vector171>:
.globl vector171
vector171:
  pushl $0
c0102f38:	6a 00                	push   $0x0
  pushl $171
c0102f3a:	68 ab 00 00 00       	push   $0xab
  jmp __alltraps
c0102f3f:	e9 5c f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f44 <vector172>:
.globl vector172
vector172:
  pushl $0
c0102f44:	6a 00                	push   $0x0
  pushl $172
c0102f46:	68 ac 00 00 00       	push   $0xac
  jmp __alltraps
c0102f4b:	e9 50 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f50 <vector173>:
.globl vector173
vector173:
  pushl $0
c0102f50:	6a 00                	push   $0x0
  pushl $173
c0102f52:	68 ad 00 00 00       	push   $0xad
  jmp __alltraps
c0102f57:	e9 44 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f5c <vector174>:
.globl vector174
vector174:
  pushl $0
c0102f5c:	6a 00                	push   $0x0
  pushl $174
c0102f5e:	68 ae 00 00 00       	push   $0xae
  jmp __alltraps
c0102f63:	e9 38 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f68 <vector175>:
.globl vector175
vector175:
  pushl $0
c0102f68:	6a 00                	push   $0x0
  pushl $175
c0102f6a:	68 af 00 00 00       	push   $0xaf
  jmp __alltraps
c0102f6f:	e9 2c f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f74 <vector176>:
.globl vector176
vector176:
  pushl $0
c0102f74:	6a 00                	push   $0x0
  pushl $176
c0102f76:	68 b0 00 00 00       	push   $0xb0
  jmp __alltraps
c0102f7b:	e9 20 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f80 <vector177>:
.globl vector177
vector177:
  pushl $0
c0102f80:	6a 00                	push   $0x0
  pushl $177
c0102f82:	68 b1 00 00 00       	push   $0xb1
  jmp __alltraps
c0102f87:	e9 14 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f8c <vector178>:
.globl vector178
vector178:
  pushl $0
c0102f8c:	6a 00                	push   $0x0
  pushl $178
c0102f8e:	68 b2 00 00 00       	push   $0xb2
  jmp __alltraps
c0102f93:	e9 08 f9 ff ff       	jmp    c01028a0 <__alltraps>

c0102f98 <vector179>:
.globl vector179
vector179:
  pushl $0
c0102f98:	6a 00                	push   $0x0
  pushl $179
c0102f9a:	68 b3 00 00 00       	push   $0xb3
  jmp __alltraps
c0102f9f:	e9 fc f8 ff ff       	jmp    c01028a0 <__alltraps>

c0102fa4 <vector180>:
.globl vector180
vector180:
  pushl $0
c0102fa4:	6a 00                	push   $0x0
  pushl $180
c0102fa6:	68 b4 00 00 00       	push   $0xb4
  jmp __alltraps
c0102fab:	e9 f0 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0102fb0 <vector181>:
.globl vector181
vector181:
  pushl $0
c0102fb0:	6a 00                	push   $0x0
  pushl $181
c0102fb2:	68 b5 00 00 00       	push   $0xb5
  jmp __alltraps
c0102fb7:	e9 e4 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0102fbc <vector182>:
.globl vector182
vector182:
  pushl $0
c0102fbc:	6a 00                	push   $0x0
  pushl $182
c0102fbe:	68 b6 00 00 00       	push   $0xb6
  jmp __alltraps
c0102fc3:	e9 d8 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0102fc8 <vector183>:
.globl vector183
vector183:
  pushl $0
c0102fc8:	6a 00                	push   $0x0
  pushl $183
c0102fca:	68 b7 00 00 00       	push   $0xb7
  jmp __alltraps
c0102fcf:	e9 cc f8 ff ff       	jmp    c01028a0 <__alltraps>

c0102fd4 <vector184>:
.globl vector184
vector184:
  pushl $0
c0102fd4:	6a 00                	push   $0x0
  pushl $184
c0102fd6:	68 b8 00 00 00       	push   $0xb8
  jmp __alltraps
c0102fdb:	e9 c0 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0102fe0 <vector185>:
.globl vector185
vector185:
  pushl $0
c0102fe0:	6a 00                	push   $0x0
  pushl $185
c0102fe2:	68 b9 00 00 00       	push   $0xb9
  jmp __alltraps
c0102fe7:	e9 b4 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0102fec <vector186>:
.globl vector186
vector186:
  pushl $0
c0102fec:	6a 00                	push   $0x0
  pushl $186
c0102fee:	68 ba 00 00 00       	push   $0xba
  jmp __alltraps
c0102ff3:	e9 a8 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0102ff8 <vector187>:
.globl vector187
vector187:
  pushl $0
c0102ff8:	6a 00                	push   $0x0
  pushl $187
c0102ffa:	68 bb 00 00 00       	push   $0xbb
  jmp __alltraps
c0102fff:	e9 9c f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103004 <vector188>:
.globl vector188
vector188:
  pushl $0
c0103004:	6a 00                	push   $0x0
  pushl $188
c0103006:	68 bc 00 00 00       	push   $0xbc
  jmp __alltraps
c010300b:	e9 90 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103010 <vector189>:
.globl vector189
vector189:
  pushl $0
c0103010:	6a 00                	push   $0x0
  pushl $189
c0103012:	68 bd 00 00 00       	push   $0xbd
  jmp __alltraps
c0103017:	e9 84 f8 ff ff       	jmp    c01028a0 <__alltraps>

c010301c <vector190>:
.globl vector190
vector190:
  pushl $0
c010301c:	6a 00                	push   $0x0
  pushl $190
c010301e:	68 be 00 00 00       	push   $0xbe
  jmp __alltraps
c0103023:	e9 78 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103028 <vector191>:
.globl vector191
vector191:
  pushl $0
c0103028:	6a 00                	push   $0x0
  pushl $191
c010302a:	68 bf 00 00 00       	push   $0xbf
  jmp __alltraps
c010302f:	e9 6c f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103034 <vector192>:
.globl vector192
vector192:
  pushl $0
c0103034:	6a 00                	push   $0x0
  pushl $192
c0103036:	68 c0 00 00 00       	push   $0xc0
  jmp __alltraps
c010303b:	e9 60 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103040 <vector193>:
.globl vector193
vector193:
  pushl $0
c0103040:	6a 00                	push   $0x0
  pushl $193
c0103042:	68 c1 00 00 00       	push   $0xc1
  jmp __alltraps
c0103047:	e9 54 f8 ff ff       	jmp    c01028a0 <__alltraps>

c010304c <vector194>:
.globl vector194
vector194:
  pushl $0
c010304c:	6a 00                	push   $0x0
  pushl $194
c010304e:	68 c2 00 00 00       	push   $0xc2
  jmp __alltraps
c0103053:	e9 48 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103058 <vector195>:
.globl vector195
vector195:
  pushl $0
c0103058:	6a 00                	push   $0x0
  pushl $195
c010305a:	68 c3 00 00 00       	push   $0xc3
  jmp __alltraps
c010305f:	e9 3c f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103064 <vector196>:
.globl vector196
vector196:
  pushl $0
c0103064:	6a 00                	push   $0x0
  pushl $196
c0103066:	68 c4 00 00 00       	push   $0xc4
  jmp __alltraps
c010306b:	e9 30 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103070 <vector197>:
.globl vector197
vector197:
  pushl $0
c0103070:	6a 00                	push   $0x0
  pushl $197
c0103072:	68 c5 00 00 00       	push   $0xc5
  jmp __alltraps
c0103077:	e9 24 f8 ff ff       	jmp    c01028a0 <__alltraps>

c010307c <vector198>:
.globl vector198
vector198:
  pushl $0
c010307c:	6a 00                	push   $0x0
  pushl $198
c010307e:	68 c6 00 00 00       	push   $0xc6
  jmp __alltraps
c0103083:	e9 18 f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103088 <vector199>:
.globl vector199
vector199:
  pushl $0
c0103088:	6a 00                	push   $0x0
  pushl $199
c010308a:	68 c7 00 00 00       	push   $0xc7
  jmp __alltraps
c010308f:	e9 0c f8 ff ff       	jmp    c01028a0 <__alltraps>

c0103094 <vector200>:
.globl vector200
vector200:
  pushl $0
c0103094:	6a 00                	push   $0x0
  pushl $200
c0103096:	68 c8 00 00 00       	push   $0xc8
  jmp __alltraps
c010309b:	e9 00 f8 ff ff       	jmp    c01028a0 <__alltraps>

c01030a0 <vector201>:
.globl vector201
vector201:
  pushl $0
c01030a0:	6a 00                	push   $0x0
  pushl $201
c01030a2:	68 c9 00 00 00       	push   $0xc9
  jmp __alltraps
c01030a7:	e9 f4 f7 ff ff       	jmp    c01028a0 <__alltraps>

c01030ac <vector202>:
.globl vector202
vector202:
  pushl $0
c01030ac:	6a 00                	push   $0x0
  pushl $202
c01030ae:	68 ca 00 00 00       	push   $0xca
  jmp __alltraps
c01030b3:	e9 e8 f7 ff ff       	jmp    c01028a0 <__alltraps>

c01030b8 <vector203>:
.globl vector203
vector203:
  pushl $0
c01030b8:	6a 00                	push   $0x0
  pushl $203
c01030ba:	68 cb 00 00 00       	push   $0xcb
  jmp __alltraps
c01030bf:	e9 dc f7 ff ff       	jmp    c01028a0 <__alltraps>

c01030c4 <vector204>:
.globl vector204
vector204:
  pushl $0
c01030c4:	6a 00                	push   $0x0
  pushl $204
c01030c6:	68 cc 00 00 00       	push   $0xcc
  jmp __alltraps
c01030cb:	e9 d0 f7 ff ff       	jmp    c01028a0 <__alltraps>

c01030d0 <vector205>:
.globl vector205
vector205:
  pushl $0
c01030d0:	6a 00                	push   $0x0
  pushl $205
c01030d2:	68 cd 00 00 00       	push   $0xcd
  jmp __alltraps
c01030d7:	e9 c4 f7 ff ff       	jmp    c01028a0 <__alltraps>

c01030dc <vector206>:
.globl vector206
vector206:
  pushl $0
c01030dc:	6a 00                	push   $0x0
  pushl $206
c01030de:	68 ce 00 00 00       	push   $0xce
  jmp __alltraps
c01030e3:	e9 b8 f7 ff ff       	jmp    c01028a0 <__alltraps>

c01030e8 <vector207>:
.globl vector207
vector207:
  pushl $0
c01030e8:	6a 00                	push   $0x0
  pushl $207
c01030ea:	68 cf 00 00 00       	push   $0xcf
  jmp __alltraps
c01030ef:	e9 ac f7 ff ff       	jmp    c01028a0 <__alltraps>

c01030f4 <vector208>:
.globl vector208
vector208:
  pushl $0
c01030f4:	6a 00                	push   $0x0
  pushl $208
c01030f6:	68 d0 00 00 00       	push   $0xd0
  jmp __alltraps
c01030fb:	e9 a0 f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103100 <vector209>:
.globl vector209
vector209:
  pushl $0
c0103100:	6a 00                	push   $0x0
  pushl $209
c0103102:	68 d1 00 00 00       	push   $0xd1
  jmp __alltraps
c0103107:	e9 94 f7 ff ff       	jmp    c01028a0 <__alltraps>

c010310c <vector210>:
.globl vector210
vector210:
  pushl $0
c010310c:	6a 00                	push   $0x0
  pushl $210
c010310e:	68 d2 00 00 00       	push   $0xd2
  jmp __alltraps
c0103113:	e9 88 f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103118 <vector211>:
.globl vector211
vector211:
  pushl $0
c0103118:	6a 00                	push   $0x0
  pushl $211
c010311a:	68 d3 00 00 00       	push   $0xd3
  jmp __alltraps
c010311f:	e9 7c f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103124 <vector212>:
.globl vector212
vector212:
  pushl $0
c0103124:	6a 00                	push   $0x0
  pushl $212
c0103126:	68 d4 00 00 00       	push   $0xd4
  jmp __alltraps
c010312b:	e9 70 f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103130 <vector213>:
.globl vector213
vector213:
  pushl $0
c0103130:	6a 00                	push   $0x0
  pushl $213
c0103132:	68 d5 00 00 00       	push   $0xd5
  jmp __alltraps
c0103137:	e9 64 f7 ff ff       	jmp    c01028a0 <__alltraps>

c010313c <vector214>:
.globl vector214
vector214:
  pushl $0
c010313c:	6a 00                	push   $0x0
  pushl $214
c010313e:	68 d6 00 00 00       	push   $0xd6
  jmp __alltraps
c0103143:	e9 58 f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103148 <vector215>:
.globl vector215
vector215:
  pushl $0
c0103148:	6a 00                	push   $0x0
  pushl $215
c010314a:	68 d7 00 00 00       	push   $0xd7
  jmp __alltraps
c010314f:	e9 4c f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103154 <vector216>:
.globl vector216
vector216:
  pushl $0
c0103154:	6a 00                	push   $0x0
  pushl $216
c0103156:	68 d8 00 00 00       	push   $0xd8
  jmp __alltraps
c010315b:	e9 40 f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103160 <vector217>:
.globl vector217
vector217:
  pushl $0
c0103160:	6a 00                	push   $0x0
  pushl $217
c0103162:	68 d9 00 00 00       	push   $0xd9
  jmp __alltraps
c0103167:	e9 34 f7 ff ff       	jmp    c01028a0 <__alltraps>

c010316c <vector218>:
.globl vector218
vector218:
  pushl $0
c010316c:	6a 00                	push   $0x0
  pushl $218
c010316e:	68 da 00 00 00       	push   $0xda
  jmp __alltraps
c0103173:	e9 28 f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103178 <vector219>:
.globl vector219
vector219:
  pushl $0
c0103178:	6a 00                	push   $0x0
  pushl $219
c010317a:	68 db 00 00 00       	push   $0xdb
  jmp __alltraps
c010317f:	e9 1c f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103184 <vector220>:
.globl vector220
vector220:
  pushl $0
c0103184:	6a 00                	push   $0x0
  pushl $220
c0103186:	68 dc 00 00 00       	push   $0xdc
  jmp __alltraps
c010318b:	e9 10 f7 ff ff       	jmp    c01028a0 <__alltraps>

c0103190 <vector221>:
.globl vector221
vector221:
  pushl $0
c0103190:	6a 00                	push   $0x0
  pushl $221
c0103192:	68 dd 00 00 00       	push   $0xdd
  jmp __alltraps
c0103197:	e9 04 f7 ff ff       	jmp    c01028a0 <__alltraps>

c010319c <vector222>:
.globl vector222
vector222:
  pushl $0
c010319c:	6a 00                	push   $0x0
  pushl $222
c010319e:	68 de 00 00 00       	push   $0xde
  jmp __alltraps
c01031a3:	e9 f8 f6 ff ff       	jmp    c01028a0 <__alltraps>

c01031a8 <vector223>:
.globl vector223
vector223:
  pushl $0
c01031a8:	6a 00                	push   $0x0
  pushl $223
c01031aa:	68 df 00 00 00       	push   $0xdf
  jmp __alltraps
c01031af:	e9 ec f6 ff ff       	jmp    c01028a0 <__alltraps>

c01031b4 <vector224>:
.globl vector224
vector224:
  pushl $0
c01031b4:	6a 00                	push   $0x0
  pushl $224
c01031b6:	68 e0 00 00 00       	push   $0xe0
  jmp __alltraps
c01031bb:	e9 e0 f6 ff ff       	jmp    c01028a0 <__alltraps>

c01031c0 <vector225>:
.globl vector225
vector225:
  pushl $0
c01031c0:	6a 00                	push   $0x0
  pushl $225
c01031c2:	68 e1 00 00 00       	push   $0xe1
  jmp __alltraps
c01031c7:	e9 d4 f6 ff ff       	jmp    c01028a0 <__alltraps>

c01031cc <vector226>:
.globl vector226
vector226:
  pushl $0
c01031cc:	6a 00                	push   $0x0
  pushl $226
c01031ce:	68 e2 00 00 00       	push   $0xe2
  jmp __alltraps
c01031d3:	e9 c8 f6 ff ff       	jmp    c01028a0 <__alltraps>

c01031d8 <vector227>:
.globl vector227
vector227:
  pushl $0
c01031d8:	6a 00                	push   $0x0
  pushl $227
c01031da:	68 e3 00 00 00       	push   $0xe3
  jmp __alltraps
c01031df:	e9 bc f6 ff ff       	jmp    c01028a0 <__alltraps>

c01031e4 <vector228>:
.globl vector228
vector228:
  pushl $0
c01031e4:	6a 00                	push   $0x0
  pushl $228
c01031e6:	68 e4 00 00 00       	push   $0xe4
  jmp __alltraps
c01031eb:	e9 b0 f6 ff ff       	jmp    c01028a0 <__alltraps>

c01031f0 <vector229>:
.globl vector229
vector229:
  pushl $0
c01031f0:	6a 00                	push   $0x0
  pushl $229
c01031f2:	68 e5 00 00 00       	push   $0xe5
  jmp __alltraps
c01031f7:	e9 a4 f6 ff ff       	jmp    c01028a0 <__alltraps>

c01031fc <vector230>:
.globl vector230
vector230:
  pushl $0
c01031fc:	6a 00                	push   $0x0
  pushl $230
c01031fe:	68 e6 00 00 00       	push   $0xe6
  jmp __alltraps
c0103203:	e9 98 f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103208 <vector231>:
.globl vector231
vector231:
  pushl $0
c0103208:	6a 00                	push   $0x0
  pushl $231
c010320a:	68 e7 00 00 00       	push   $0xe7
  jmp __alltraps
c010320f:	e9 8c f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103214 <vector232>:
.globl vector232
vector232:
  pushl $0
c0103214:	6a 00                	push   $0x0
  pushl $232
c0103216:	68 e8 00 00 00       	push   $0xe8
  jmp __alltraps
c010321b:	e9 80 f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103220 <vector233>:
.globl vector233
vector233:
  pushl $0
c0103220:	6a 00                	push   $0x0
  pushl $233
c0103222:	68 e9 00 00 00       	push   $0xe9
  jmp __alltraps
c0103227:	e9 74 f6 ff ff       	jmp    c01028a0 <__alltraps>

c010322c <vector234>:
.globl vector234
vector234:
  pushl $0
c010322c:	6a 00                	push   $0x0
  pushl $234
c010322e:	68 ea 00 00 00       	push   $0xea
  jmp __alltraps
c0103233:	e9 68 f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103238 <vector235>:
.globl vector235
vector235:
  pushl $0
c0103238:	6a 00                	push   $0x0
  pushl $235
c010323a:	68 eb 00 00 00       	push   $0xeb
  jmp __alltraps
c010323f:	e9 5c f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103244 <vector236>:
.globl vector236
vector236:
  pushl $0
c0103244:	6a 00                	push   $0x0
  pushl $236
c0103246:	68 ec 00 00 00       	push   $0xec
  jmp __alltraps
c010324b:	e9 50 f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103250 <vector237>:
.globl vector237
vector237:
  pushl $0
c0103250:	6a 00                	push   $0x0
  pushl $237
c0103252:	68 ed 00 00 00       	push   $0xed
  jmp __alltraps
c0103257:	e9 44 f6 ff ff       	jmp    c01028a0 <__alltraps>

c010325c <vector238>:
.globl vector238
vector238:
  pushl $0
c010325c:	6a 00                	push   $0x0
  pushl $238
c010325e:	68 ee 00 00 00       	push   $0xee
  jmp __alltraps
c0103263:	e9 38 f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103268 <vector239>:
.globl vector239
vector239:
  pushl $0
c0103268:	6a 00                	push   $0x0
  pushl $239
c010326a:	68 ef 00 00 00       	push   $0xef
  jmp __alltraps
c010326f:	e9 2c f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103274 <vector240>:
.globl vector240
vector240:
  pushl $0
c0103274:	6a 00                	push   $0x0
  pushl $240
c0103276:	68 f0 00 00 00       	push   $0xf0
  jmp __alltraps
c010327b:	e9 20 f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103280 <vector241>:
.globl vector241
vector241:
  pushl $0
c0103280:	6a 00                	push   $0x0
  pushl $241
c0103282:	68 f1 00 00 00       	push   $0xf1
  jmp __alltraps
c0103287:	e9 14 f6 ff ff       	jmp    c01028a0 <__alltraps>

c010328c <vector242>:
.globl vector242
vector242:
  pushl $0
c010328c:	6a 00                	push   $0x0
  pushl $242
c010328e:	68 f2 00 00 00       	push   $0xf2
  jmp __alltraps
c0103293:	e9 08 f6 ff ff       	jmp    c01028a0 <__alltraps>

c0103298 <vector243>:
.globl vector243
vector243:
  pushl $0
c0103298:	6a 00                	push   $0x0
  pushl $243
c010329a:	68 f3 00 00 00       	push   $0xf3
  jmp __alltraps
c010329f:	e9 fc f5 ff ff       	jmp    c01028a0 <__alltraps>

c01032a4 <vector244>:
.globl vector244
vector244:
  pushl $0
c01032a4:	6a 00                	push   $0x0
  pushl $244
c01032a6:	68 f4 00 00 00       	push   $0xf4
  jmp __alltraps
c01032ab:	e9 f0 f5 ff ff       	jmp    c01028a0 <__alltraps>

c01032b0 <vector245>:
.globl vector245
vector245:
  pushl $0
c01032b0:	6a 00                	push   $0x0
  pushl $245
c01032b2:	68 f5 00 00 00       	push   $0xf5
  jmp __alltraps
c01032b7:	e9 e4 f5 ff ff       	jmp    c01028a0 <__alltraps>

c01032bc <vector246>:
.globl vector246
vector246:
  pushl $0
c01032bc:	6a 00                	push   $0x0
  pushl $246
c01032be:	68 f6 00 00 00       	push   $0xf6
  jmp __alltraps
c01032c3:	e9 d8 f5 ff ff       	jmp    c01028a0 <__alltraps>

c01032c8 <vector247>:
.globl vector247
vector247:
  pushl $0
c01032c8:	6a 00                	push   $0x0
  pushl $247
c01032ca:	68 f7 00 00 00       	push   $0xf7
  jmp __alltraps
c01032cf:	e9 cc f5 ff ff       	jmp    c01028a0 <__alltraps>

c01032d4 <vector248>:
.globl vector248
vector248:
  pushl $0
c01032d4:	6a 00                	push   $0x0
  pushl $248
c01032d6:	68 f8 00 00 00       	push   $0xf8
  jmp __alltraps
c01032db:	e9 c0 f5 ff ff       	jmp    c01028a0 <__alltraps>

c01032e0 <vector249>:
.globl vector249
vector249:
  pushl $0
c01032e0:	6a 00                	push   $0x0
  pushl $249
c01032e2:	68 f9 00 00 00       	push   $0xf9
  jmp __alltraps
c01032e7:	e9 b4 f5 ff ff       	jmp    c01028a0 <__alltraps>

c01032ec <vector250>:
.globl vector250
vector250:
  pushl $0
c01032ec:	6a 00                	push   $0x0
  pushl $250
c01032ee:	68 fa 00 00 00       	push   $0xfa
  jmp __alltraps
c01032f3:	e9 a8 f5 ff ff       	jmp    c01028a0 <__alltraps>

c01032f8 <vector251>:
.globl vector251
vector251:
  pushl $0
c01032f8:	6a 00                	push   $0x0
  pushl $251
c01032fa:	68 fb 00 00 00       	push   $0xfb
  jmp __alltraps
c01032ff:	e9 9c f5 ff ff       	jmp    c01028a0 <__alltraps>

c0103304 <vector252>:
.globl vector252
vector252:
  pushl $0
c0103304:	6a 00                	push   $0x0
  pushl $252
c0103306:	68 fc 00 00 00       	push   $0xfc
  jmp __alltraps
c010330b:	e9 90 f5 ff ff       	jmp    c01028a0 <__alltraps>

c0103310 <vector253>:
.globl vector253
vector253:
  pushl $0
c0103310:	6a 00                	push   $0x0
  pushl $253
c0103312:	68 fd 00 00 00       	push   $0xfd
  jmp __alltraps
c0103317:	e9 84 f5 ff ff       	jmp    c01028a0 <__alltraps>

c010331c <vector254>:
.globl vector254
vector254:
  pushl $0
c010331c:	6a 00                	push   $0x0
  pushl $254
c010331e:	68 fe 00 00 00       	push   $0xfe
  jmp __alltraps
c0103323:	e9 78 f5 ff ff       	jmp    c01028a0 <__alltraps>

c0103328 <vector255>:
.globl vector255
vector255:
  pushl $0
c0103328:	6a 00                	push   $0x0
  pushl $255
c010332a:	68 ff 00 00 00       	push   $0xff
  jmp __alltraps
c010332f:	e9 6c f5 ff ff       	jmp    c01028a0 <__alltraps>

c0103334 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0103334:	55                   	push   %ebp
c0103335:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0103337:	8b 55 08             	mov    0x8(%ebp),%edx
c010333a:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c010333f:	89 d1                	mov    %edx,%ecx
c0103341:	29 c1                	sub    %eax,%ecx
c0103343:	89 c8                	mov    %ecx,%eax
c0103345:	c1 f8 05             	sar    $0x5,%eax
}
c0103348:	5d                   	pop    %ebp
c0103349:	c3                   	ret    

c010334a <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010334a:	55                   	push   %ebp
c010334b:	89 e5                	mov    %esp,%ebp
c010334d:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0103350:	8b 45 08             	mov    0x8(%ebp),%eax
c0103353:	89 04 24             	mov    %eax,(%esp)
c0103356:	e8 d9 ff ff ff       	call   c0103334 <page2ppn>
c010335b:	c1 e0 0c             	shl    $0xc,%eax
}
c010335e:	c9                   	leave  
c010335f:	c3                   	ret    

c0103360 <page_ref>:
pde2page(pde_t pde) {
    return pa2page(PDE_ADDR(pde));
}

static inline int
page_ref(struct Page *page) {
c0103360:	55                   	push   %ebp
c0103361:	89 e5                	mov    %esp,%ebp
    return page->ref;
c0103363:	8b 45 08             	mov    0x8(%ebp),%eax
c0103366:	8b 00                	mov    (%eax),%eax
}
c0103368:	5d                   	pop    %ebp
c0103369:	c3                   	ret    

c010336a <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c010336a:	55                   	push   %ebp
c010336b:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c010336d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103370:	8b 55 0c             	mov    0xc(%ebp),%edx
c0103373:	89 10                	mov    %edx,(%eax)
}
c0103375:	5d                   	pop    %ebp
c0103376:	c3                   	ret    

c0103377 <default_init>:

#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
default_init(void) {
c0103377:	55                   	push   %ebp
c0103378:	89 e5                	mov    %esp,%ebp
c010337a:	83 ec 10             	sub    $0x10,%esp
c010337d:	c7 45 fc c0 1a 12 c0 	movl   $0xc0121ac0,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103384:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103387:	8b 55 fc             	mov    -0x4(%ebp),%edx
c010338a:	89 50 04             	mov    %edx,0x4(%eax)
c010338d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103390:	8b 50 04             	mov    0x4(%eax),%edx
c0103393:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0103396:	89 10                	mov    %edx,(%eax)
    list_init(&free_list);
    nr_free = 0;
c0103398:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c010339f:	00 00 00 
}
c01033a2:	c9                   	leave  
c01033a3:	c3                   	ret    

c01033a4 <default_init_memmap>:

static void
default_init_memmap(struct Page *base, size_t n) {
c01033a4:	55                   	push   %ebp
c01033a5:	89 e5                	mov    %esp,%ebp
c01033a7:	53                   	push   %ebx
c01033a8:	83 ec 44             	sub    $0x44,%esp
    assert(n > 0);
c01033ab:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c01033af:	75 24                	jne    c01033d5 <default_init_memmap+0x31>
c01033b1:	c7 44 24 0c 30 97 10 	movl   $0xc0109730,0xc(%esp)
c01033b8:	c0 
c01033b9:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c01033c0:	c0 
c01033c1:	c7 44 24 04 46 00 00 	movl   $0x46,0x4(%esp)
c01033c8:	00 
c01033c9:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c01033d0:	e8 e3 d8 ff ff       	call   c0100cb8 <__panic>
    struct Page *p;
    for (p = base; p != base + n; p++) {
c01033d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01033d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01033db:	e9 dc 00 00 00       	jmp    c01034bc <default_init_memmap+0x118>
        assert(PageReserved(p));
c01033e0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01033e3:	83 c0 04             	add    $0x4,%eax
c01033e6:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c01033ed:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01033f0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01033f3:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01033f6:	0f a3 10             	bt     %edx,(%eax)
c01033f9:	19 db                	sbb    %ebx,%ebx
c01033fb:	89 5d e8             	mov    %ebx,-0x18(%ebp)
    return oldbit != 0;
c01033fe:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0103402:	0f 95 c0             	setne  %al
c0103405:	0f b6 c0             	movzbl %al,%eax
c0103408:	85 c0                	test   %eax,%eax
c010340a:	75 24                	jne    c0103430 <default_init_memmap+0x8c>
c010340c:	c7 44 24 0c 61 97 10 	movl   $0xc0109761,0xc(%esp)
c0103413:	c0 
c0103414:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c010341b:	c0 
c010341c:	c7 44 24 04 49 00 00 	movl   $0x49,0x4(%esp)
c0103423:	00 
c0103424:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c010342b:	e8 88 d8 ff ff       	call   c0100cb8 <__panic>
        p->flags = 0;
c0103430:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103433:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)

        SetPageProperty(p);
c010343a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010343d:	83 c0 04             	add    $0x4,%eax
c0103440:	c7 45 e4 01 00 00 00 	movl   $0x1,-0x1c(%ebp)
c0103447:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010344a:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010344d:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0103450:	0f ab 10             	bts    %edx,(%eax)
        p->property = 0;
c0103453:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103456:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        set_page_ref(p, 0);
c010345d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0103464:	00 
c0103465:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103468:	89 04 24             	mov    %eax,(%esp)
c010346b:	e8 fa fe ff ff       	call   c010336a <set_page_ref>
        list_add_before(&free_list, &(p->page_link));
c0103470:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103473:	83 c0 0c             	add    $0xc,%eax
c0103476:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
c010347d:	89 45 d8             	mov    %eax,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103480:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103483:	8b 00                	mov    (%eax),%eax
c0103485:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0103488:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010348b:	89 45 d0             	mov    %eax,-0x30(%ebp)
c010348e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103491:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103494:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103497:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010349a:	89 10                	mov    %edx,(%eax)
c010349c:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010349f:	8b 10                	mov    (%eax),%edx
c01034a1:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01034a4:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01034a7:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01034aa:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01034ad:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01034b0:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01034b3:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01034b6:	89 10                	mov    %edx,(%eax)

static void
default_init_memmap(struct Page *base, size_t n) {
    assert(n > 0);
    struct Page *p;
    for (p = base; p != base + n; p++) {
c01034b8:	83 45 f4 20          	addl   $0x20,-0xc(%ebp)
c01034bc:	8b 45 0c             	mov    0xc(%ebp),%eax
c01034bf:	c1 e0 05             	shl    $0x5,%eax
c01034c2:	03 45 08             	add    0x8(%ebp),%eax
c01034c5:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01034c8:	0f 85 12 ff ff ff    	jne    c01033e0 <default_init_memmap+0x3c>
        SetPageProperty(p);
        p->property = 0;
        set_page_ref(p, 0);
        list_add_before(&free_list, &(p->page_link));
    }
    nr_free = nr_free + n;
c01034ce:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c01034d3:	03 45 0c             	add    0xc(%ebp),%eax
c01034d6:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
    base->property = n;
c01034db:	8b 45 08             	mov    0x8(%ebp),%eax
c01034de:	8b 55 0c             	mov    0xc(%ebp),%edx
c01034e1:	89 50 08             	mov    %edx,0x8(%eax)



}
c01034e4:	83 c4 44             	add    $0x44,%esp
c01034e7:	5b                   	pop    %ebx
c01034e8:	5d                   	pop    %ebp
c01034e9:	c3                   	ret    

c01034ea <default_alloc_pages>:

static struct Page *
default_alloc_pages(size_t n) {
c01034ea:	55                   	push   %ebp
c01034eb:	89 e5                	mov    %esp,%ebp
c01034ed:	83 ec 68             	sub    $0x68,%esp
    assert(n > 0);
c01034f0:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01034f4:	75 24                	jne    c010351a <default_alloc_pages+0x30>
c01034f6:	c7 44 24 0c 30 97 10 	movl   $0xc0109730,0xc(%esp)
c01034fd:	c0 
c01034fe:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103505:	c0 
c0103506:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c010350d:	00 
c010350e:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103515:	e8 9e d7 ff ff       	call   c0100cb8 <__panic>
    if (n > nr_free) {
c010351a:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c010351f:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103522:	73 0a                	jae    c010352e <default_alloc_pages+0x44>
        return NULL;
c0103524:	b8 00 00 00 00       	mov    $0x0,%eax
c0103529:	e9 37 01 00 00       	jmp    c0103665 <default_alloc_pages+0x17b>
    }
    list_entry_t *len, *le;
    le = &free_list;
c010352e:	c7 45 f4 c0 1a 12 c0 	movl   $0xc0121ac0,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
c0103535:	e9 0a 01 00 00       	jmp    c0103644 <default_alloc_pages+0x15a>
      struct Page *p = le2page(le, page_link);
c010353a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010353d:	83 e8 0c             	sub    $0xc,%eax
c0103540:	89 45 ec             	mov    %eax,-0x14(%ebp)
      if(p->property >= n){
c0103543:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103546:	8b 40 08             	mov    0x8(%eax),%eax
c0103549:	3b 45 08             	cmp    0x8(%ebp),%eax
c010354c:	0f 82 f2 00 00 00    	jb     c0103644 <default_alloc_pages+0x15a>
	int i;
        for(i = 0;i < n; i++){
c0103552:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
c0103559:	eb 7c                	jmp    c01035d7 <default_alloc_pages+0xed>
c010355b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010355e:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103561:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103564:	8b 40 04             	mov    0x4(%eax),%eax
          len = list_next(le);
c0103567:	89 45 e8             	mov    %eax,-0x18(%ebp)
          struct Page *newp = le2page(le, page_link);
c010356a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010356d:	83 e8 0c             	sub    $0xc,%eax
c0103570:	89 45 e4             	mov    %eax,-0x1c(%ebp)
          SetPageReserved(newp);
c0103573:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103576:	83 c0 04             	add    $0x4,%eax
c0103579:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0103580:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0103583:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103586:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0103589:	0f ab 10             	bts    %edx,(%eax)
          ClearPageProperty(newp);
c010358c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010358f:	83 c0 04             	add    $0x4,%eax
c0103592:	c7 45 d4 01 00 00 00 	movl   $0x1,-0x2c(%ebp)
c0103599:	89 45 d0             	mov    %eax,-0x30(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c010359c:	8b 45 d0             	mov    -0x30(%ebp),%eax
c010359f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01035a2:	0f b3 10             	btr    %edx,(%eax)
c01035a5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035a8:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c01035ab:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01035ae:	8b 40 04             	mov    0x4(%eax),%eax
c01035b1:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01035b4:	8b 12                	mov    (%edx),%edx
c01035b6:	89 55 c8             	mov    %edx,-0x38(%ebp)
c01035b9:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c01035bc:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01035bf:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c01035c2:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c01035c5:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01035c8:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01035cb:	89 10                	mov    %edx,(%eax)
          list_del(le);
          le = len;
c01035cd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01035d0:	89 45 f4             	mov    %eax,-0xc(%ebp)

    while((le=list_next(le)) != &free_list) {
      struct Page *p = le2page(le, page_link);
      if(p->property >= n){
	int i;
        for(i = 0;i < n; i++){
c01035d3:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
c01035d7:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01035da:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035dd:	0f 82 78 ff ff ff    	jb     c010355b <default_alloc_pages+0x71>
          SetPageReserved(newp);
          ClearPageProperty(newp);
          list_del(le);
          le = len;
        }
        if(p->property > n){
c01035e3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035e6:	8b 40 08             	mov    0x8(%eax),%eax
c01035e9:	3b 45 08             	cmp    0x8(%ebp),%eax
c01035ec:	76 12                	jbe    c0103600 <default_alloc_pages+0x116>
          (le2page(le,page_link))->property = p->property - n;
c01035ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01035f1:	8d 50 f4             	lea    -0xc(%eax),%edx
c01035f4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01035f7:	8b 40 08             	mov    0x8(%eax),%eax
c01035fa:	2b 45 08             	sub    0x8(%ebp),%eax
c01035fd:	89 42 08             	mov    %eax,0x8(%edx)
        }
        ClearPageProperty(p);
c0103600:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103603:	83 c0 04             	add    $0x4,%eax
c0103606:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c010360d:	89 45 bc             	mov    %eax,-0x44(%ebp)
c0103610:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103613:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103616:	0f b3 10             	btr    %edx,(%eax)
        SetPageReserved(p);
c0103619:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010361c:	83 c0 04             	add    $0x4,%eax
c010361f:	c7 45 b8 00 00 00 00 	movl   $0x0,-0x48(%ebp)
c0103626:	89 45 b4             	mov    %eax,-0x4c(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0103629:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010362c:	8b 55 b8             	mov    -0x48(%ebp),%edx
c010362f:	0f ab 10             	bts    %edx,(%eax)
        nr_free -= n;
c0103632:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103637:	2b 45 08             	sub    0x8(%ebp),%eax
c010363a:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
        return p;
c010363f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103642:	eb 21                	jmp    c0103665 <default_alloc_pages+0x17b>
c0103644:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103647:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010364a:	8b 45 b0             	mov    -0x50(%ebp),%eax
c010364d:	8b 40 04             	mov    0x4(%eax),%eax
        return NULL;
    }
    list_entry_t *len, *le;
    le = &free_list;

    while((le=list_next(le)) != &free_list) {
c0103650:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103653:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c010365a:	0f 85 da fe ff ff    	jne    c010353a <default_alloc_pages+0x50>
        SetPageReserved(p);
        nr_free -= n;
        return p;
      }
    }
    return NULL;
c0103660:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0103665:	c9                   	leave  
c0103666:	c3                   	ret    

c0103667 <default_free_pages>:

static void
default_free_pages(struct Page *base, size_t n) {
c0103667:	55                   	push   %ebp
c0103668:	89 e5                	mov    %esp,%ebp
c010366a:	53                   	push   %ebx
c010366b:	83 ec 64             	sub    $0x64,%esp
    
    assert(n > 0);
c010366e:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0103672:	75 24                	jne    c0103698 <default_free_pages+0x31>
c0103674:	c7 44 24 0c 30 97 10 	movl   $0xc0109730,0xc(%esp)
c010367b:	c0 
c010367c:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103683:	c0 
c0103684:	c7 44 24 04 7c 00 00 	movl   $0x7c,0x4(%esp)
c010368b:	00 
c010368c:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103693:	e8 20 d6 ff ff       	call   c0100cb8 <__panic>
    assert(PageReserved(base));
c0103698:	8b 45 08             	mov    0x8(%ebp),%eax
c010369b:	83 c0 04             	add    $0x4,%eax
c010369e:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c01036a5:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01036a8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01036ab:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01036ae:	0f a3 10             	bt     %edx,(%eax)
c01036b1:	19 db                	sbb    %ebx,%ebx
c01036b3:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
    return oldbit != 0;
c01036b6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01036ba:	0f 95 c0             	setne  %al
c01036bd:	0f b6 c0             	movzbl %al,%eax
c01036c0:	85 c0                	test   %eax,%eax
c01036c2:	75 24                	jne    c01036e8 <default_free_pages+0x81>
c01036c4:	c7 44 24 0c 71 97 10 	movl   $0xc0109771,0xc(%esp)
c01036cb:	c0 
c01036cc:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c01036d3:	c0 
c01036d4:	c7 44 24 04 7d 00 00 	movl   $0x7d,0x4(%esp)
c01036db:	00 
c01036dc:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c01036e3:	e8 d0 d5 ff ff       	call   c0100cb8 <__panic>

    list_entry_t *le = &free_list;
c01036e8:	c7 45 f4 c0 1a 12 c0 	movl   $0xc0121ac0,-0xc(%ebp)
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c01036ef:	eb 11                	jmp    c0103702 <default_free_pages+0x9b>
      p = le2page(le, page_link);
c01036f1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01036f4:	83 e8 0c             	sub    $0xc,%eax
c01036f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
      if(p>base){
c01036fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01036fd:	3b 45 08             	cmp    0x8(%ebp),%eax
c0103700:	77 1a                	ja     c010371c <default_free_pages+0xb5>
        break;
c0103702:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103705:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0103708:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010370b:	8b 40 04             	mov    0x4(%eax),%eax
    assert(n > 0);
    assert(PageReserved(base));

    list_entry_t *le = &free_list;
    struct Page * p;
    while((le=list_next(le)) != &free_list) {
c010370e:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103711:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c0103718:	75 d7                	jne    c01036f1 <default_free_pages+0x8a>
c010371a:	eb 01                	jmp    c010371d <default_free_pages+0xb6>
      p = le2page(le, page_link);
      if(p>base){
        break;
c010371c:	90                   	nop
      }
    }
    //list_add_before(le, base->page_link);
    for(p = base;p < base + n; p++){
c010371d:	8b 45 08             	mov    0x8(%ebp),%eax
c0103720:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103723:	eb 4b                	jmp    c0103770 <default_free_pages+0x109>
      list_add_before(le, &(p->page_link));
c0103725:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103728:	8d 50 0c             	lea    0xc(%eax),%edx
c010372b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010372e:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0103731:	89 55 d8             	mov    %edx,-0x28(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0103734:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103737:	8b 00                	mov    (%eax),%eax
c0103739:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010373c:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c010373f:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103742:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103745:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0103748:	8b 45 cc             	mov    -0x34(%ebp),%eax
c010374b:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c010374e:	89 10                	mov    %edx,(%eax)
c0103750:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103753:	8b 10                	mov    (%eax),%edx
c0103755:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103758:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c010375b:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010375e:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0103761:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0103764:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0103767:	8b 55 d0             	mov    -0x30(%ebp),%edx
c010376a:	89 10                	mov    %edx,(%eax)
      if(p>base){
        break;
      }
    }
    //list_add_before(le, base->page_link);
    for(p = base;p < base + n; p++){
c010376c:	83 45 f0 20          	addl   $0x20,-0x10(%ebp)
c0103770:	8b 45 0c             	mov    0xc(%ebp),%eax
c0103773:	c1 e0 05             	shl    $0x5,%eax
c0103776:	03 45 08             	add    0x8(%ebp),%eax
c0103779:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010377c:	77 a7                	ja     c0103725 <default_free_pages+0xbe>
      list_add_before(le, &(p->page_link));
    }
    base->flags = 0;
c010377e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103781:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    set_page_ref(base, 0);
c0103788:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010378f:	00 
c0103790:	8b 45 08             	mov    0x8(%ebp),%eax
c0103793:	89 04 24             	mov    %eax,(%esp)
c0103796:	e8 cf fb ff ff       	call   c010336a <set_page_ref>
    ClearPageProperty(base);
c010379b:	8b 45 08             	mov    0x8(%ebp),%eax
c010379e:	83 c0 04             	add    $0x4,%eax
c01037a1:	c7 45 c8 01 00 00 00 	movl   $0x1,-0x38(%ebp)
c01037a8:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * @nr:     the bit to clear
 * @addr:   the address to start counting from
 * */
static inline void
clear_bit(int nr, volatile void *addr) {
    asm volatile ("btrl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01037ab:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01037ae:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01037b1:	0f b3 10             	btr    %edx,(%eax)
    SetPageProperty(base);
c01037b4:	8b 45 08             	mov    0x8(%ebp),%eax
c01037b7:	83 c0 04             	add    $0x4,%eax
c01037ba:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c01037c1:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c01037c4:	8b 45 bc             	mov    -0x44(%ebp),%eax
c01037c7:	8b 55 c0             	mov    -0x40(%ebp),%edx
c01037ca:	0f ab 10             	bts    %edx,(%eax)
    base->property = n;
c01037cd:	8b 45 08             	mov    0x8(%ebp),%eax
c01037d0:	8b 55 0c             	mov    0xc(%ebp),%edx
c01037d3:	89 50 08             	mov    %edx,0x8(%eax)
    
    p = le2page(le,page_link) ;
c01037d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01037d9:	83 e8 0c             	sub    $0xc,%eax
c01037dc:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if( base+n == p ){
c01037df:	8b 45 0c             	mov    0xc(%ebp),%eax
c01037e2:	c1 e0 05             	shl    $0x5,%eax
c01037e5:	03 45 08             	add    0x8(%ebp),%eax
c01037e8:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c01037eb:	75 1e                	jne    c010380b <default_free_pages+0x1a4>
      base->property += p->property;
c01037ed:	8b 45 08             	mov    0x8(%ebp),%eax
c01037f0:	8b 50 08             	mov    0x8(%eax),%edx
c01037f3:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01037f6:	8b 40 08             	mov    0x8(%eax),%eax
c01037f9:	01 c2                	add    %eax,%edx
c01037fb:	8b 45 08             	mov    0x8(%ebp),%eax
c01037fe:	89 50 08             	mov    %edx,0x8(%eax)
      p->property = 0;
c0103801:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103804:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
    }
    le = list_prev(&(base->page_link));
c010380b:	8b 45 08             	mov    0x8(%ebp),%eax
c010380e:	83 c0 0c             	add    $0xc,%eax
c0103811:	89 45 b8             	mov    %eax,-0x48(%ebp)
 * list_prev - get the previous entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_prev(list_entry_t *listelm) {
    return listelm->prev;
c0103814:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0103817:	8b 00                	mov    (%eax),%eax
c0103819:	89 45 f4             	mov    %eax,-0xc(%ebp)
    p = le2page(le, page_link);
c010381c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010381f:	83 e8 0c             	sub    $0xc,%eax
c0103822:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if(le!=&free_list && p==base-1){
c0103825:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c010382c:	74 57                	je     c0103885 <default_free_pages+0x21e>
c010382e:	8b 45 08             	mov    0x8(%ebp),%eax
c0103831:	83 e8 20             	sub    $0x20,%eax
c0103834:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0103837:	75 4c                	jne    c0103885 <default_free_pages+0x21e>
      while(le!=&free_list){
c0103839:	eb 41                	jmp    c010387c <default_free_pages+0x215>
        if(p->property){
c010383b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010383e:	8b 40 08             	mov    0x8(%eax),%eax
c0103841:	85 c0                	test   %eax,%eax
c0103843:	74 20                	je     c0103865 <default_free_pages+0x1fe>
          p->property += base->property;
c0103845:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103848:	8b 50 08             	mov    0x8(%eax),%edx
c010384b:	8b 45 08             	mov    0x8(%ebp),%eax
c010384e:	8b 40 08             	mov    0x8(%eax),%eax
c0103851:	01 c2                	add    %eax,%edx
c0103853:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103856:	89 50 08             	mov    %edx,0x8(%eax)
          base->property = 0;
c0103859:	8b 45 08             	mov    0x8(%ebp),%eax
c010385c:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
          break;
c0103863:	eb 20                	jmp    c0103885 <default_free_pages+0x21e>
c0103865:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103868:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c010386b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c010386e:	8b 00                	mov    (%eax),%eax
        }
        le = list_prev(le);
c0103870:	89 45 f4             	mov    %eax,-0xc(%ebp)
        p = le2page(le,page_link);
c0103873:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103876:	83 e8 0c             	sub    $0xc,%eax
c0103879:	89 45 f0             	mov    %eax,-0x10(%ebp)
      p->property = 0;
    }
    le = list_prev(&(base->page_link));
    p = le2page(le, page_link);
    if(le!=&free_list && p==base-1){
      while(le!=&free_list){
c010387c:	81 7d f4 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0xc(%ebp)
c0103883:	75 b6                	jne    c010383b <default_free_pages+0x1d4>
        le = list_prev(le);
        p = le2page(le,page_link);
      }
    }

    nr_free = nr_free + n;
c0103885:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c010388a:	03 45 0c             	add    0xc(%ebp),%eax
c010388d:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
}
c0103892:	83 c4 64             	add    $0x64,%esp
c0103895:	5b                   	pop    %ebx
c0103896:	5d                   	pop    %ebp
c0103897:	c3                   	ret    

c0103898 <default_nr_free_pages>:

static size_t
default_nr_free_pages(void) {
c0103898:	55                   	push   %ebp
c0103899:	89 e5                	mov    %esp,%ebp
    return nr_free;
c010389b:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
}
c01038a0:	5d                   	pop    %ebp
c01038a1:	c3                   	ret    

c01038a2 <basic_check>:

static void
basic_check(void) {
c01038a2:	55                   	push   %ebp
c01038a3:	89 e5                	mov    %esp,%ebp
c01038a5:	83 ec 48             	sub    $0x48,%esp
    struct Page *p0, *p1, *p2;
    p0 = p1 = p2 = NULL;
c01038a8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01038af:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01038b2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01038b5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01038b8:	89 45 ec             	mov    %eax,-0x14(%ebp)
    assert((p0 = alloc_page()) != NULL);
c01038bb:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038c2:	e8 e0 0e 00 00       	call   c01047a7 <alloc_pages>
c01038c7:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01038ca:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01038ce:	75 24                	jne    c01038f4 <basic_check+0x52>
c01038d0:	c7 44 24 0c 84 97 10 	movl   $0xc0109784,0xc(%esp)
c01038d7:	c0 
c01038d8:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c01038df:	c0 
c01038e0:	c7 44 24 04 b0 00 00 	movl   $0xb0,0x4(%esp)
c01038e7:	00 
c01038e8:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c01038ef:	e8 c4 d3 ff ff       	call   c0100cb8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c01038f4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01038fb:	e8 a7 0e 00 00       	call   c01047a7 <alloc_pages>
c0103900:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103903:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103907:	75 24                	jne    c010392d <basic_check+0x8b>
c0103909:	c7 44 24 0c a0 97 10 	movl   $0xc01097a0,0xc(%esp)
c0103910:	c0 
c0103911:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103918:	c0 
c0103919:	c7 44 24 04 b1 00 00 	movl   $0xb1,0x4(%esp)
c0103920:	00 
c0103921:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103928:	e8 8b d3 ff ff       	call   c0100cb8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c010392d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103934:	e8 6e 0e 00 00       	call   c01047a7 <alloc_pages>
c0103939:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010393c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103940:	75 24                	jne    c0103966 <basic_check+0xc4>
c0103942:	c7 44 24 0c bc 97 10 	movl   $0xc01097bc,0xc(%esp)
c0103949:	c0 
c010394a:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103951:	c0 
c0103952:	c7 44 24 04 b2 00 00 	movl   $0xb2,0x4(%esp)
c0103959:	00 
c010395a:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103961:	e8 52 d3 ff ff       	call   c0100cb8 <__panic>

    assert(p0 != p1 && p0 != p2 && p1 != p2);
c0103966:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103969:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010396c:	74 10                	je     c010397e <basic_check+0xdc>
c010396e:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103971:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0103974:	74 08                	je     c010397e <basic_check+0xdc>
c0103976:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103979:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010397c:	75 24                	jne    c01039a2 <basic_check+0x100>
c010397e:	c7 44 24 0c d8 97 10 	movl   $0xc01097d8,0xc(%esp)
c0103985:	c0 
c0103986:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c010398d:	c0 
c010398e:	c7 44 24 04 b4 00 00 	movl   $0xb4,0x4(%esp)
c0103995:	00 
c0103996:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c010399d:	e8 16 d3 ff ff       	call   c0100cb8 <__panic>
    assert(page_ref(p0) == 0 && page_ref(p1) == 0 && page_ref(p2) == 0);
c01039a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039a5:	89 04 24             	mov    %eax,(%esp)
c01039a8:	e8 b3 f9 ff ff       	call   c0103360 <page_ref>
c01039ad:	85 c0                	test   %eax,%eax
c01039af:	75 1e                	jne    c01039cf <basic_check+0x12d>
c01039b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01039b4:	89 04 24             	mov    %eax,(%esp)
c01039b7:	e8 a4 f9 ff ff       	call   c0103360 <page_ref>
c01039bc:	85 c0                	test   %eax,%eax
c01039be:	75 0f                	jne    c01039cf <basic_check+0x12d>
c01039c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01039c3:	89 04 24             	mov    %eax,(%esp)
c01039c6:	e8 95 f9 ff ff       	call   c0103360 <page_ref>
c01039cb:	85 c0                	test   %eax,%eax
c01039cd:	74 24                	je     c01039f3 <basic_check+0x151>
c01039cf:	c7 44 24 0c fc 97 10 	movl   $0xc01097fc,0xc(%esp)
c01039d6:	c0 
c01039d7:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c01039de:	c0 
c01039df:	c7 44 24 04 b5 00 00 	movl   $0xb5,0x4(%esp)
c01039e6:	00 
c01039e7:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c01039ee:	e8 c5 d2 ff ff       	call   c0100cb8 <__panic>

    assert(page2pa(p0) < npage * PGSIZE);
c01039f3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01039f6:	89 04 24             	mov    %eax,(%esp)
c01039f9:	e8 4c f9 ff ff       	call   c010334a <page2pa>
c01039fe:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103a04:	c1 e2 0c             	shl    $0xc,%edx
c0103a07:	39 d0                	cmp    %edx,%eax
c0103a09:	72 24                	jb     c0103a2f <basic_check+0x18d>
c0103a0b:	c7 44 24 0c 38 98 10 	movl   $0xc0109838,0xc(%esp)
c0103a12:	c0 
c0103a13:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103a1a:	c0 
c0103a1b:	c7 44 24 04 b7 00 00 	movl   $0xb7,0x4(%esp)
c0103a22:	00 
c0103a23:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103a2a:	e8 89 d2 ff ff       	call   c0100cb8 <__panic>
    assert(page2pa(p1) < npage * PGSIZE);
c0103a2f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103a32:	89 04 24             	mov    %eax,(%esp)
c0103a35:	e8 10 f9 ff ff       	call   c010334a <page2pa>
c0103a3a:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103a40:	c1 e2 0c             	shl    $0xc,%edx
c0103a43:	39 d0                	cmp    %edx,%eax
c0103a45:	72 24                	jb     c0103a6b <basic_check+0x1c9>
c0103a47:	c7 44 24 0c 55 98 10 	movl   $0xc0109855,0xc(%esp)
c0103a4e:	c0 
c0103a4f:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103a56:	c0 
c0103a57:	c7 44 24 04 b8 00 00 	movl   $0xb8,0x4(%esp)
c0103a5e:	00 
c0103a5f:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103a66:	e8 4d d2 ff ff       	call   c0100cb8 <__panic>
    assert(page2pa(p2) < npage * PGSIZE);
c0103a6b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103a6e:	89 04 24             	mov    %eax,(%esp)
c0103a71:	e8 d4 f8 ff ff       	call   c010334a <page2pa>
c0103a76:	8b 15 20 1a 12 c0    	mov    0xc0121a20,%edx
c0103a7c:	c1 e2 0c             	shl    $0xc,%edx
c0103a7f:	39 d0                	cmp    %edx,%eax
c0103a81:	72 24                	jb     c0103aa7 <basic_check+0x205>
c0103a83:	c7 44 24 0c 72 98 10 	movl   $0xc0109872,0xc(%esp)
c0103a8a:	c0 
c0103a8b:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103a92:	c0 
c0103a93:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0103a9a:	00 
c0103a9b:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103aa2:	e8 11 d2 ff ff       	call   c0100cb8 <__panic>

    list_entry_t free_list_store = free_list;
c0103aa7:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0103aac:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0103ab2:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0103ab5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0103ab8:	c7 45 e0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x20(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103abf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ac2:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0103ac5:	89 50 04             	mov    %edx,0x4(%eax)
c0103ac8:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103acb:	8b 50 04             	mov    0x4(%eax),%edx
c0103ace:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0103ad1:	89 10                	mov    %edx,(%eax)
c0103ad3:	c7 45 dc c0 1a 12 c0 	movl   $0xc0121ac0,-0x24(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103ada:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0103add:	8b 40 04             	mov    0x4(%eax),%eax
c0103ae0:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c0103ae3:	0f 94 c0             	sete   %al
c0103ae6:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103ae9:	85 c0                	test   %eax,%eax
c0103aeb:	75 24                	jne    c0103b11 <basic_check+0x26f>
c0103aed:	c7 44 24 0c 8f 98 10 	movl   $0xc010988f,0xc(%esp)
c0103af4:	c0 
c0103af5:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103afc:	c0 
c0103afd:	c7 44 24 04 bd 00 00 	movl   $0xbd,0x4(%esp)
c0103b04:	00 
c0103b05:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103b0c:	e8 a7 d1 ff ff       	call   c0100cb8 <__panic>

    unsigned int nr_free_store = nr_free;
c0103b11:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103b16:	89 45 e8             	mov    %eax,-0x18(%ebp)
    nr_free = 0;
c0103b19:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0103b20:	00 00 00 

    assert(alloc_page() == NULL);
c0103b23:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103b2a:	e8 78 0c 00 00       	call   c01047a7 <alloc_pages>
c0103b2f:	85 c0                	test   %eax,%eax
c0103b31:	74 24                	je     c0103b57 <basic_check+0x2b5>
c0103b33:	c7 44 24 0c a6 98 10 	movl   $0xc01098a6,0xc(%esp)
c0103b3a:	c0 
c0103b3b:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103b42:	c0 
c0103b43:	c7 44 24 04 c2 00 00 	movl   $0xc2,0x4(%esp)
c0103b4a:	00 
c0103b4b:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103b52:	e8 61 d1 ff ff       	call   c0100cb8 <__panic>

    free_page(p0);
c0103b57:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b5e:	00 
c0103b5f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103b62:	89 04 24             	mov    %eax,(%esp)
c0103b65:	e8 a8 0c 00 00       	call   c0104812 <free_pages>
    free_page(p1);
c0103b6a:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b71:	00 
c0103b72:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103b75:	89 04 24             	mov    %eax,(%esp)
c0103b78:	e8 95 0c 00 00       	call   c0104812 <free_pages>
    free_page(p2);
c0103b7d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103b84:	00 
c0103b85:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103b88:	89 04 24             	mov    %eax,(%esp)
c0103b8b:	e8 82 0c 00 00       	call   c0104812 <free_pages>
    assert(nr_free == 3);
c0103b90:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103b95:	83 f8 03             	cmp    $0x3,%eax
c0103b98:	74 24                	je     c0103bbe <basic_check+0x31c>
c0103b9a:	c7 44 24 0c bb 98 10 	movl   $0xc01098bb,0xc(%esp)
c0103ba1:	c0 
c0103ba2:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103ba9:	c0 
c0103baa:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0103bb1:	00 
c0103bb2:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103bb9:	e8 fa d0 ff ff       	call   c0100cb8 <__panic>

    assert((p0 = alloc_page()) != NULL);
c0103bbe:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bc5:	e8 dd 0b 00 00       	call   c01047a7 <alloc_pages>
c0103bca:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103bcd:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0103bd1:	75 24                	jne    c0103bf7 <basic_check+0x355>
c0103bd3:	c7 44 24 0c 84 97 10 	movl   $0xc0109784,0xc(%esp)
c0103bda:	c0 
c0103bdb:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103be2:	c0 
c0103be3:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0103bea:	00 
c0103beb:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103bf2:	e8 c1 d0 ff ff       	call   c0100cb8 <__panic>
    assert((p1 = alloc_page()) != NULL);
c0103bf7:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103bfe:	e8 a4 0b 00 00       	call   c01047a7 <alloc_pages>
c0103c03:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103c06:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0103c0a:	75 24                	jne    c0103c30 <basic_check+0x38e>
c0103c0c:	c7 44 24 0c a0 97 10 	movl   $0xc01097a0,0xc(%esp)
c0103c13:	c0 
c0103c14:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103c1b:	c0 
c0103c1c:	c7 44 24 04 ca 00 00 	movl   $0xca,0x4(%esp)
c0103c23:	00 
c0103c24:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103c2b:	e8 88 d0 ff ff       	call   c0100cb8 <__panic>
    assert((p2 = alloc_page()) != NULL);
c0103c30:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c37:	e8 6b 0b 00 00       	call   c01047a7 <alloc_pages>
c0103c3c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0103c3f:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0103c43:	75 24                	jne    c0103c69 <basic_check+0x3c7>
c0103c45:	c7 44 24 0c bc 97 10 	movl   $0xc01097bc,0xc(%esp)
c0103c4c:	c0 
c0103c4d:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103c54:	c0 
c0103c55:	c7 44 24 04 cb 00 00 	movl   $0xcb,0x4(%esp)
c0103c5c:	00 
c0103c5d:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103c64:	e8 4f d0 ff ff       	call   c0100cb8 <__panic>

    assert(alloc_page() == NULL);
c0103c69:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103c70:	e8 32 0b 00 00       	call   c01047a7 <alloc_pages>
c0103c75:	85 c0                	test   %eax,%eax
c0103c77:	74 24                	je     c0103c9d <basic_check+0x3fb>
c0103c79:	c7 44 24 0c a6 98 10 	movl   $0xc01098a6,0xc(%esp)
c0103c80:	c0 
c0103c81:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103c88:	c0 
c0103c89:	c7 44 24 04 cd 00 00 	movl   $0xcd,0x4(%esp)
c0103c90:	00 
c0103c91:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103c98:	e8 1b d0 ff ff       	call   c0100cb8 <__panic>

    free_page(p0);
c0103c9d:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103ca4:	00 
c0103ca5:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103ca8:	89 04 24             	mov    %eax,(%esp)
c0103cab:	e8 62 0b 00 00       	call   c0104812 <free_pages>
c0103cb0:	c7 45 d8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x28(%ebp)
c0103cb7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0103cba:	8b 40 04             	mov    0x4(%eax),%eax
c0103cbd:	39 45 d8             	cmp    %eax,-0x28(%ebp)
c0103cc0:	0f 94 c0             	sete   %al
c0103cc3:	0f b6 c0             	movzbl %al,%eax
    assert(!list_empty(&free_list));
c0103cc6:	85 c0                	test   %eax,%eax
c0103cc8:	74 24                	je     c0103cee <basic_check+0x44c>
c0103cca:	c7 44 24 0c c8 98 10 	movl   $0xc01098c8,0xc(%esp)
c0103cd1:	c0 
c0103cd2:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103cd9:	c0 
c0103cda:	c7 44 24 04 d0 00 00 	movl   $0xd0,0x4(%esp)
c0103ce1:	00 
c0103ce2:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103ce9:	e8 ca cf ff ff       	call   c0100cb8 <__panic>

    struct Page *p;
    assert((p = alloc_page()) == p0);
c0103cee:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103cf5:	e8 ad 0a 00 00       	call   c01047a7 <alloc_pages>
c0103cfa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0103cfd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103d00:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0103d03:	74 24                	je     c0103d29 <basic_check+0x487>
c0103d05:	c7 44 24 0c e0 98 10 	movl   $0xc01098e0,0xc(%esp)
c0103d0c:	c0 
c0103d0d:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103d14:	c0 
c0103d15:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c0103d1c:	00 
c0103d1d:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103d24:	e8 8f cf ff ff       	call   c0100cb8 <__panic>
    assert(alloc_page() == NULL);
c0103d29:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103d30:	e8 72 0a 00 00       	call   c01047a7 <alloc_pages>
c0103d35:	85 c0                	test   %eax,%eax
c0103d37:	74 24                	je     c0103d5d <basic_check+0x4bb>
c0103d39:	c7 44 24 0c a6 98 10 	movl   $0xc01098a6,0xc(%esp)
c0103d40:	c0 
c0103d41:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103d48:	c0 
c0103d49:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c0103d50:	00 
c0103d51:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103d58:	e8 5b cf ff ff       	call   c0100cb8 <__panic>

    assert(nr_free == 0);
c0103d5d:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103d62:	85 c0                	test   %eax,%eax
c0103d64:	74 24                	je     c0103d8a <basic_check+0x4e8>
c0103d66:	c7 44 24 0c f9 98 10 	movl   $0xc01098f9,0xc(%esp)
c0103d6d:	c0 
c0103d6e:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103d75:	c0 
c0103d76:	c7 44 24 04 d6 00 00 	movl   $0xd6,0x4(%esp)
c0103d7d:	00 
c0103d7e:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103d85:	e8 2e cf ff ff       	call   c0100cb8 <__panic>
    free_list = free_list_store;
c0103d8a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0103d8d:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0103d90:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0103d95:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    nr_free = nr_free_store;
c0103d9b:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103d9e:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_page(p);
c0103da3:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103daa:	00 
c0103dab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103dae:	89 04 24             	mov    %eax,(%esp)
c0103db1:	e8 5c 0a 00 00       	call   c0104812 <free_pages>
    free_page(p1);
c0103db6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103dbd:	00 
c0103dbe:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103dc1:	89 04 24             	mov    %eax,(%esp)
c0103dc4:	e8 49 0a 00 00       	call   c0104812 <free_pages>
    free_page(p2);
c0103dc9:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0103dd0:	00 
c0103dd1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0103dd4:	89 04 24             	mov    %eax,(%esp)
c0103dd7:	e8 36 0a 00 00       	call   c0104812 <free_pages>
}
c0103ddc:	c9                   	leave  
c0103ddd:	c3                   	ret    

c0103dde <default_check>:

// LAB2: below code is used to check the first fit allocation algorithm (your EXERCISE 1) 
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
c0103dde:	55                   	push   %ebp
c0103ddf:	89 e5                	mov    %esp,%ebp
c0103de1:	53                   	push   %ebx
c0103de2:	81 ec 94 00 00 00    	sub    $0x94,%esp
    int count = 0, total = 0;
c0103de8:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0103def:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    list_entry_t *le = &free_list;
c0103df6:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c0103dfd:	eb 6b                	jmp    c0103e6a <default_check+0x8c>
        struct Page *p = le2page(le, page_link);
c0103dff:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e02:	83 e8 0c             	sub    $0xc,%eax
c0103e05:	89 45 e8             	mov    %eax,-0x18(%ebp)
        assert(PageProperty(p));
c0103e08:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e0b:	83 c0 04             	add    $0x4,%eax
c0103e0e:	c7 45 d0 01 00 00 00 	movl   $0x1,-0x30(%ebp)
c0103e15:	89 45 cc             	mov    %eax,-0x34(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103e18:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0103e1b:	8b 55 d0             	mov    -0x30(%ebp),%edx
c0103e1e:	0f a3 10             	bt     %edx,(%eax)
c0103e21:	19 db                	sbb    %ebx,%ebx
c0103e23:	89 5d c8             	mov    %ebx,-0x38(%ebp)
    return oldbit != 0;
c0103e26:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c0103e2a:	0f 95 c0             	setne  %al
c0103e2d:	0f b6 c0             	movzbl %al,%eax
c0103e30:	85 c0                	test   %eax,%eax
c0103e32:	75 24                	jne    c0103e58 <default_check+0x7a>
c0103e34:	c7 44 24 0c 06 99 10 	movl   $0xc0109906,0xc(%esp)
c0103e3b:	c0 
c0103e3c:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103e43:	c0 
c0103e44:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0103e4b:	00 
c0103e4c:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103e53:	e8 60 ce ff ff       	call   c0100cb8 <__panic>
        count ++, total += p->property;
c0103e58:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0103e5c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0103e5f:	8b 50 08             	mov    0x8(%eax),%edx
c0103e62:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0103e65:	01 d0                	add    %edx,%eax
c0103e67:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0103e6a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0103e6d:	89 45 c4             	mov    %eax,-0x3c(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0103e70:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0103e73:	8b 40 04             	mov    0x4(%eax),%eax
// NOTICE: You SHOULD NOT CHANGE basic_check, default_check functions!
static void
default_check(void) {
    int count = 0, total = 0;
    list_entry_t *le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c0103e76:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0103e79:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c0103e80:	0f 85 79 ff ff ff    	jne    c0103dff <default_check+0x21>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
    }
    assert(total == nr_free_pages());
c0103e86:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c0103e89:	e8 b6 09 00 00       	call   c0104844 <nr_free_pages>
c0103e8e:	39 c3                	cmp    %eax,%ebx
c0103e90:	74 24                	je     c0103eb6 <default_check+0xd8>
c0103e92:	c7 44 24 0c 16 99 10 	movl   $0xc0109916,0xc(%esp)
c0103e99:	c0 
c0103e9a:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103ea1:	c0 
c0103ea2:	c7 44 24 04 ea 00 00 	movl   $0xea,0x4(%esp)
c0103ea9:	00 
c0103eaa:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103eb1:	e8 02 ce ff ff       	call   c0100cb8 <__panic>

    basic_check();
c0103eb6:	e8 e7 f9 ff ff       	call   c01038a2 <basic_check>

    struct Page *p0 = alloc_pages(5), *p1, *p2;
c0103ebb:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c0103ec2:	e8 e0 08 00 00       	call   c01047a7 <alloc_pages>
c0103ec7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(p0 != NULL);
c0103eca:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0103ece:	75 24                	jne    c0103ef4 <default_check+0x116>
c0103ed0:	c7 44 24 0c 2f 99 10 	movl   $0xc010992f,0xc(%esp)
c0103ed7:	c0 
c0103ed8:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103edf:	c0 
c0103ee0:	c7 44 24 04 ef 00 00 	movl   $0xef,0x4(%esp)
c0103ee7:	00 
c0103ee8:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103eef:	e8 c4 cd ff ff       	call   c0100cb8 <__panic>
    assert(!PageProperty(p0));
c0103ef4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ef7:	83 c0 04             	add    $0x4,%eax
c0103efa:	c7 45 c0 01 00 00 00 	movl   $0x1,-0x40(%ebp)
c0103f01:	89 45 bc             	mov    %eax,-0x44(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0103f04:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0103f07:	8b 55 c0             	mov    -0x40(%ebp),%edx
c0103f0a:	0f a3 10             	bt     %edx,(%eax)
c0103f0d:	19 db                	sbb    %ebx,%ebx
c0103f0f:	89 5d b8             	mov    %ebx,-0x48(%ebp)
    return oldbit != 0;
c0103f12:	83 7d b8 00          	cmpl   $0x0,-0x48(%ebp)
c0103f16:	0f 95 c0             	setne  %al
c0103f19:	0f b6 c0             	movzbl %al,%eax
c0103f1c:	85 c0                	test   %eax,%eax
c0103f1e:	74 24                	je     c0103f44 <default_check+0x166>
c0103f20:	c7 44 24 0c 3a 99 10 	movl   $0xc010993a,0xc(%esp)
c0103f27:	c0 
c0103f28:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103f2f:	c0 
c0103f30:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0103f37:	00 
c0103f38:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103f3f:	e8 74 cd ff ff       	call   c0100cb8 <__panic>

    list_entry_t free_list_store = free_list;
c0103f44:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c0103f49:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c0103f4f:	89 45 80             	mov    %eax,-0x80(%ebp)
c0103f52:	89 55 84             	mov    %edx,-0x7c(%ebp)
c0103f55:	c7 45 b4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x4c(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0103f5c:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f5f:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c0103f62:	89 50 04             	mov    %edx,0x4(%eax)
c0103f65:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f68:	8b 50 04             	mov    0x4(%eax),%edx
c0103f6b:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c0103f6e:	89 10                	mov    %edx,(%eax)
c0103f70:	c7 45 b0 c0 1a 12 c0 	movl   $0xc0121ac0,-0x50(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0103f77:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0103f7a:	8b 40 04             	mov    0x4(%eax),%eax
c0103f7d:	39 45 b0             	cmp    %eax,-0x50(%ebp)
c0103f80:	0f 94 c0             	sete   %al
c0103f83:	0f b6 c0             	movzbl %al,%eax
    list_init(&free_list);
    assert(list_empty(&free_list));
c0103f86:	85 c0                	test   %eax,%eax
c0103f88:	75 24                	jne    c0103fae <default_check+0x1d0>
c0103f8a:	c7 44 24 0c 8f 98 10 	movl   $0xc010988f,0xc(%esp)
c0103f91:	c0 
c0103f92:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103f99:	c0 
c0103f9a:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0103fa1:	00 
c0103fa2:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103fa9:	e8 0a cd ff ff       	call   c0100cb8 <__panic>
    assert(alloc_page() == NULL);
c0103fae:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0103fb5:	e8 ed 07 00 00       	call   c01047a7 <alloc_pages>
c0103fba:	85 c0                	test   %eax,%eax
c0103fbc:	74 24                	je     c0103fe2 <default_check+0x204>
c0103fbe:	c7 44 24 0c a6 98 10 	movl   $0xc01098a6,0xc(%esp)
c0103fc5:	c0 
c0103fc6:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0103fcd:	c0 
c0103fce:	c7 44 24 04 f5 00 00 	movl   $0xf5,0x4(%esp)
c0103fd5:	00 
c0103fd6:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0103fdd:	e8 d6 cc ff ff       	call   c0100cb8 <__panic>

    unsigned int nr_free_store = nr_free;
c0103fe2:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0103fe7:	89 45 e0             	mov    %eax,-0x20(%ebp)
    nr_free = 0;
c0103fea:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0103ff1:	00 00 00 

    free_pages(p0 + 2, 3);
c0103ff4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0103ff7:	83 c0 40             	add    $0x40,%eax
c0103ffa:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c0104001:	00 
c0104002:	89 04 24             	mov    %eax,(%esp)
c0104005:	e8 08 08 00 00       	call   c0104812 <free_pages>
    assert(alloc_pages(4) == NULL);
c010400a:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
c0104011:	e8 91 07 00 00       	call   c01047a7 <alloc_pages>
c0104016:	85 c0                	test   %eax,%eax
c0104018:	74 24                	je     c010403e <default_check+0x260>
c010401a:	c7 44 24 0c 4c 99 10 	movl   $0xc010994c,0xc(%esp)
c0104021:	c0 
c0104022:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0104029:	c0 
c010402a:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0104031:	00 
c0104032:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0104039:	e8 7a cc ff ff       	call   c0100cb8 <__panic>
    assert(PageProperty(p0 + 2) && p0[2].property == 3);
c010403e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104041:	83 c0 40             	add    $0x40,%eax
c0104044:	83 c0 04             	add    $0x4,%eax
c0104047:	c7 45 ac 01 00 00 00 	movl   $0x1,-0x54(%ebp)
c010404e:	89 45 a8             	mov    %eax,-0x58(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c0104051:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104054:	8b 55 ac             	mov    -0x54(%ebp),%edx
c0104057:	0f a3 10             	bt     %edx,(%eax)
c010405a:	19 db                	sbb    %ebx,%ebx
c010405c:	89 5d a4             	mov    %ebx,-0x5c(%ebp)
    return oldbit != 0;
c010405f:	83 7d a4 00          	cmpl   $0x0,-0x5c(%ebp)
c0104063:	0f 95 c0             	setne  %al
c0104066:	0f b6 c0             	movzbl %al,%eax
c0104069:	85 c0                	test   %eax,%eax
c010406b:	74 0e                	je     c010407b <default_check+0x29d>
c010406d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104070:	83 c0 40             	add    $0x40,%eax
c0104073:	8b 40 08             	mov    0x8(%eax),%eax
c0104076:	83 f8 03             	cmp    $0x3,%eax
c0104079:	74 24                	je     c010409f <default_check+0x2c1>
c010407b:	c7 44 24 0c 64 99 10 	movl   $0xc0109964,0xc(%esp)
c0104082:	c0 
c0104083:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c010408a:	c0 
c010408b:	c7 44 24 04 fc 00 00 	movl   $0xfc,0x4(%esp)
c0104092:	00 
c0104093:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c010409a:	e8 19 cc ff ff       	call   c0100cb8 <__panic>
    assert((p1 = alloc_pages(3)) != NULL);
c010409f:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
c01040a6:	e8 fc 06 00 00       	call   c01047a7 <alloc_pages>
c01040ab:	89 45 dc             	mov    %eax,-0x24(%ebp)
c01040ae:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01040b2:	75 24                	jne    c01040d8 <default_check+0x2fa>
c01040b4:	c7 44 24 0c 90 99 10 	movl   $0xc0109990,0xc(%esp)
c01040bb:	c0 
c01040bc:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c01040c3:	c0 
c01040c4:	c7 44 24 04 fd 00 00 	movl   $0xfd,0x4(%esp)
c01040cb:	00 
c01040cc:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c01040d3:	e8 e0 cb ff ff       	call   c0100cb8 <__panic>
    assert(alloc_page() == NULL);
c01040d8:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01040df:	e8 c3 06 00 00       	call   c01047a7 <alloc_pages>
c01040e4:	85 c0                	test   %eax,%eax
c01040e6:	74 24                	je     c010410c <default_check+0x32e>
c01040e8:	c7 44 24 0c a6 98 10 	movl   $0xc01098a6,0xc(%esp)
c01040ef:	c0 
c01040f0:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c01040f7:	c0 
c01040f8:	c7 44 24 04 fe 00 00 	movl   $0xfe,0x4(%esp)
c01040ff:	00 
c0104100:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0104107:	e8 ac cb ff ff       	call   c0100cb8 <__panic>
    assert(p0 + 2 == p1);
c010410c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010410f:	83 c0 40             	add    $0x40,%eax
c0104112:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104115:	74 24                	je     c010413b <default_check+0x35d>
c0104117:	c7 44 24 0c ae 99 10 	movl   $0xc01099ae,0xc(%esp)
c010411e:	c0 
c010411f:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0104126:	c0 
c0104127:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c010412e:	00 
c010412f:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0104136:	e8 7d cb ff ff       	call   c0100cb8 <__panic>

    p2 = p0 + 1;
c010413b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010413e:	83 c0 20             	add    $0x20,%eax
c0104141:	89 45 d8             	mov    %eax,-0x28(%ebp)
    free_page(p0);
c0104144:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c010414b:	00 
c010414c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010414f:	89 04 24             	mov    %eax,(%esp)
c0104152:	e8 bb 06 00 00       	call   c0104812 <free_pages>
    free_pages(p1, 3);
c0104157:	c7 44 24 04 03 00 00 	movl   $0x3,0x4(%esp)
c010415e:	00 
c010415f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0104162:	89 04 24             	mov    %eax,(%esp)
c0104165:	e8 a8 06 00 00       	call   c0104812 <free_pages>
    assert(PageProperty(p0) && p0->property == 1);
c010416a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010416d:	83 c0 04             	add    $0x4,%eax
c0104170:	c7 45 a0 01 00 00 00 	movl   $0x1,-0x60(%ebp)
c0104177:	89 45 9c             	mov    %eax,-0x64(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010417a:	8b 45 9c             	mov    -0x64(%ebp),%eax
c010417d:	8b 55 a0             	mov    -0x60(%ebp),%edx
c0104180:	0f a3 10             	bt     %edx,(%eax)
c0104183:	19 db                	sbb    %ebx,%ebx
c0104185:	89 5d 98             	mov    %ebx,-0x68(%ebp)
    return oldbit != 0;
c0104188:	83 7d 98 00          	cmpl   $0x0,-0x68(%ebp)
c010418c:	0f 95 c0             	setne  %al
c010418f:	0f b6 c0             	movzbl %al,%eax
c0104192:	85 c0                	test   %eax,%eax
c0104194:	74 0b                	je     c01041a1 <default_check+0x3c3>
c0104196:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104199:	8b 40 08             	mov    0x8(%eax),%eax
c010419c:	83 f8 01             	cmp    $0x1,%eax
c010419f:	74 24                	je     c01041c5 <default_check+0x3e7>
c01041a1:	c7 44 24 0c bc 99 10 	movl   $0xc01099bc,0xc(%esp)
c01041a8:	c0 
c01041a9:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c01041b0:	c0 
c01041b1:	c7 44 24 04 04 01 00 	movl   $0x104,0x4(%esp)
c01041b8:	00 
c01041b9:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c01041c0:	e8 f3 ca ff ff       	call   c0100cb8 <__panic>
    assert(PageProperty(p1) && p1->property == 3);
c01041c5:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041c8:	83 c0 04             	add    $0x4,%eax
c01041cb:	c7 45 94 01 00 00 00 	movl   $0x1,-0x6c(%ebp)
c01041d2:	89 45 90             	mov    %eax,-0x70(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c01041d5:	8b 45 90             	mov    -0x70(%ebp),%eax
c01041d8:	8b 55 94             	mov    -0x6c(%ebp),%edx
c01041db:	0f a3 10             	bt     %edx,(%eax)
c01041de:	19 db                	sbb    %ebx,%ebx
c01041e0:	89 5d 8c             	mov    %ebx,-0x74(%ebp)
    return oldbit != 0;
c01041e3:	83 7d 8c 00          	cmpl   $0x0,-0x74(%ebp)
c01041e7:	0f 95 c0             	setne  %al
c01041ea:	0f b6 c0             	movzbl %al,%eax
c01041ed:	85 c0                	test   %eax,%eax
c01041ef:	74 0b                	je     c01041fc <default_check+0x41e>
c01041f1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01041f4:	8b 40 08             	mov    0x8(%eax),%eax
c01041f7:	83 f8 03             	cmp    $0x3,%eax
c01041fa:	74 24                	je     c0104220 <default_check+0x442>
c01041fc:	c7 44 24 0c e4 99 10 	movl   $0xc01099e4,0xc(%esp)
c0104203:	c0 
c0104204:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c010420b:	c0 
c010420c:	c7 44 24 04 05 01 00 	movl   $0x105,0x4(%esp)
c0104213:	00 
c0104214:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c010421b:	e8 98 ca ff ff       	call   c0100cb8 <__panic>

    assert((p0 = alloc_page()) == p2 - 1);
c0104220:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104227:	e8 7b 05 00 00       	call   c01047a7 <alloc_pages>
c010422c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c010422f:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104232:	83 e8 20             	sub    $0x20,%eax
c0104235:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104238:	74 24                	je     c010425e <default_check+0x480>
c010423a:	c7 44 24 0c 0a 9a 10 	movl   $0xc0109a0a,0xc(%esp)
c0104241:	c0 
c0104242:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c0104249:	c0 
c010424a:	c7 44 24 04 07 01 00 	movl   $0x107,0x4(%esp)
c0104251:	00 
c0104252:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0104259:	e8 5a ca ff ff       	call   c0100cb8 <__panic>
    free_page(p0);
c010425e:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104265:	00 
c0104266:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104269:	89 04 24             	mov    %eax,(%esp)
c010426c:	e8 a1 05 00 00       	call   c0104812 <free_pages>
    assert((p0 = alloc_pages(2)) == p2 + 1);
c0104271:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
c0104278:	e8 2a 05 00 00       	call   c01047a7 <alloc_pages>
c010427d:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104280:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0104283:	83 c0 20             	add    $0x20,%eax
c0104286:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104289:	74 24                	je     c01042af <default_check+0x4d1>
c010428b:	c7 44 24 0c 28 9a 10 	movl   $0xc0109a28,0xc(%esp)
c0104292:	c0 
c0104293:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c010429a:	c0 
c010429b:	c7 44 24 04 09 01 00 	movl   $0x109,0x4(%esp)
c01042a2:	00 
c01042a3:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c01042aa:	e8 09 ca ff ff       	call   c0100cb8 <__panic>

    free_pages(p0, 2);
c01042af:	c7 44 24 04 02 00 00 	movl   $0x2,0x4(%esp)
c01042b6:	00 
c01042b7:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01042ba:	89 04 24             	mov    %eax,(%esp)
c01042bd:	e8 50 05 00 00       	call   c0104812 <free_pages>
    free_page(p2);
c01042c2:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01042c9:	00 
c01042ca:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01042cd:	89 04 24             	mov    %eax,(%esp)
c01042d0:	e8 3d 05 00 00       	call   c0104812 <free_pages>

    assert((p0 = alloc_pages(5)) != NULL);
c01042d5:	c7 04 24 05 00 00 00 	movl   $0x5,(%esp)
c01042dc:	e8 c6 04 00 00       	call   c01047a7 <alloc_pages>
c01042e1:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c01042e4:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01042e8:	75 24                	jne    c010430e <default_check+0x530>
c01042ea:	c7 44 24 0c 48 9a 10 	movl   $0xc0109a48,0xc(%esp)
c01042f1:	c0 
c01042f2:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c01042f9:	c0 
c01042fa:	c7 44 24 04 0e 01 00 	movl   $0x10e,0x4(%esp)
c0104301:	00 
c0104302:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0104309:	e8 aa c9 ff ff       	call   c0100cb8 <__panic>
    assert(alloc_page() == NULL);
c010430e:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104315:	e8 8d 04 00 00       	call   c01047a7 <alloc_pages>
c010431a:	85 c0                	test   %eax,%eax
c010431c:	74 24                	je     c0104342 <default_check+0x564>
c010431e:	c7 44 24 0c a6 98 10 	movl   $0xc01098a6,0xc(%esp)
c0104325:	c0 
c0104326:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c010432d:	c0 
c010432e:	c7 44 24 04 0f 01 00 	movl   $0x10f,0x4(%esp)
c0104335:	00 
c0104336:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c010433d:	e8 76 c9 ff ff       	call   c0100cb8 <__panic>

    assert(nr_free == 0);
c0104342:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0104347:	85 c0                	test   %eax,%eax
c0104349:	74 24                	je     c010436f <default_check+0x591>
c010434b:	c7 44 24 0c f9 98 10 	movl   $0xc01098f9,0xc(%esp)
c0104352:	c0 
c0104353:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c010435a:	c0 
c010435b:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104362:	00 
c0104363:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c010436a:	e8 49 c9 ff ff       	call   c0100cb8 <__panic>
    nr_free = nr_free_store;
c010436f:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104372:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8

    free_list = free_list_store;
c0104377:	8b 45 80             	mov    -0x80(%ebp),%eax
c010437a:	8b 55 84             	mov    -0x7c(%ebp),%edx
c010437d:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0104382:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4
    free_pages(p0, 5);
c0104388:	c7 44 24 04 05 00 00 	movl   $0x5,0x4(%esp)
c010438f:	00 
c0104390:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104393:	89 04 24             	mov    %eax,(%esp)
c0104396:	e8 77 04 00 00       	call   c0104812 <free_pages>

    le = &free_list;
c010439b:	c7 45 ec c0 1a 12 c0 	movl   $0xc0121ac0,-0x14(%ebp)
    while ((le = list_next(le)) != &free_list) {
c01043a2:	eb 1f                	jmp    c01043c3 <default_check+0x5e5>
        struct Page *p = le2page(le, page_link);
c01043a4:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043a7:	83 e8 0c             	sub    $0xc,%eax
c01043aa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        count --, total -= p->property;
c01043ad:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01043b1:	8b 55 f0             	mov    -0x10(%ebp),%edx
c01043b4:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01043b7:	8b 40 08             	mov    0x8(%eax),%eax
c01043ba:	89 d1                	mov    %edx,%ecx
c01043bc:	29 c1                	sub    %eax,%ecx
c01043be:	89 c8                	mov    %ecx,%eax
c01043c0:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01043c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01043c6:	89 45 88             	mov    %eax,-0x78(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c01043c9:	8b 45 88             	mov    -0x78(%ebp),%eax
c01043cc:	8b 40 04             	mov    0x4(%eax),%eax

    free_list = free_list_store;
    free_pages(p0, 5);

    le = &free_list;
    while ((le = list_next(le)) != &free_list) {
c01043cf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01043d2:	81 7d ec c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x14(%ebp)
c01043d9:	75 c9                	jne    c01043a4 <default_check+0x5c6>
        struct Page *p = le2page(le, page_link);
        count --, total -= p->property;
    }
    assert(count == 0);
c01043db:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01043df:	74 24                	je     c0104405 <default_check+0x627>
c01043e1:	c7 44 24 0c 66 9a 10 	movl   $0xc0109a66,0xc(%esp)
c01043e8:	c0 
c01043e9:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c01043f0:	c0 
c01043f1:	c7 44 24 04 1c 01 00 	movl   $0x11c,0x4(%esp)
c01043f8:	00 
c01043f9:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c0104400:	e8 b3 c8 ff ff       	call   c0100cb8 <__panic>
    assert(total == 0);
c0104405:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0104409:	74 24                	je     c010442f <default_check+0x651>
c010440b:	c7 44 24 0c 71 9a 10 	movl   $0xc0109a71,0xc(%esp)
c0104412:	c0 
c0104413:	c7 44 24 08 36 97 10 	movl   $0xc0109736,0x8(%esp)
c010441a:	c0 
c010441b:	c7 44 24 04 1d 01 00 	movl   $0x11d,0x4(%esp)
c0104422:	00 
c0104423:	c7 04 24 4b 97 10 c0 	movl   $0xc010974b,(%esp)
c010442a:	e8 89 c8 ff ff       	call   c0100cb8 <__panic>
}
c010442f:	81 c4 94 00 00 00    	add    $0x94,%esp
c0104435:	5b                   	pop    %ebx
c0104436:	5d                   	pop    %ebp
c0104437:	c3                   	ret    

c0104438 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0104438:	55                   	push   %ebp
c0104439:	89 e5                	mov    %esp,%ebp
    return page - pages;
c010443b:	8b 55 08             	mov    0x8(%ebp),%edx
c010443e:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0104443:	89 d1                	mov    %edx,%ecx
c0104445:	29 c1                	sub    %eax,%ecx
c0104447:	89 c8                	mov    %ecx,%eax
c0104449:	c1 f8 05             	sar    $0x5,%eax
}
c010444c:	5d                   	pop    %ebp
c010444d:	c3                   	ret    

c010444e <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c010444e:	55                   	push   %ebp
c010444f:	89 e5                	mov    %esp,%ebp
c0104451:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c0104454:	8b 45 08             	mov    0x8(%ebp),%eax
c0104457:	89 04 24             	mov    %eax,(%esp)
c010445a:	e8 d9 ff ff ff       	call   c0104438 <page2ppn>
c010445f:	c1 e0 0c             	shl    $0xc,%eax
}
c0104462:	c9                   	leave  
c0104463:	c3                   	ret    

c0104464 <pa2page>:

static inline struct Page *
pa2page(uintptr_t pa) {
c0104464:	55                   	push   %ebp
c0104465:	89 e5                	mov    %esp,%ebp
c0104467:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010446a:	8b 45 08             	mov    0x8(%ebp),%eax
c010446d:	89 c2                	mov    %eax,%edx
c010446f:	c1 ea 0c             	shr    $0xc,%edx
c0104472:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104477:	39 c2                	cmp    %eax,%edx
c0104479:	72 1c                	jb     c0104497 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010447b:	c7 44 24 08 ac 9a 10 	movl   $0xc0109aac,0x8(%esp)
c0104482:	c0 
c0104483:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010448a:	00 
c010448b:	c7 04 24 cb 9a 10 c0 	movl   $0xc0109acb,(%esp)
c0104492:	e8 21 c8 ff ff       	call   c0100cb8 <__panic>
    }
    return &pages[PPN(pa)];
c0104497:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c010449c:	8b 55 08             	mov    0x8(%ebp),%edx
c010449f:	c1 ea 0c             	shr    $0xc,%edx
c01044a2:	c1 e2 05             	shl    $0x5,%edx
c01044a5:	01 d0                	add    %edx,%eax
}
c01044a7:	c9                   	leave  
c01044a8:	c3                   	ret    

c01044a9 <page2kva>:

static inline void *
page2kva(struct Page *page) {
c01044a9:	55                   	push   %ebp
c01044aa:	89 e5                	mov    %esp,%ebp
c01044ac:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c01044af:	8b 45 08             	mov    0x8(%ebp),%eax
c01044b2:	89 04 24             	mov    %eax,(%esp)
c01044b5:	e8 94 ff ff ff       	call   c010444e <page2pa>
c01044ba:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01044bd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044c0:	c1 e8 0c             	shr    $0xc,%eax
c01044c3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01044c6:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c01044cb:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c01044ce:	72 23                	jb     c01044f3 <page2kva+0x4a>
c01044d0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044d3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01044d7:	c7 44 24 08 dc 9a 10 	movl   $0xc0109adc,0x8(%esp)
c01044de:	c0 
c01044df:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c01044e6:	00 
c01044e7:	c7 04 24 cb 9a 10 c0 	movl   $0xc0109acb,(%esp)
c01044ee:	e8 c5 c7 ff ff       	call   c0100cb8 <__panic>
c01044f3:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01044f6:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01044fb:	c9                   	leave  
c01044fc:	c3                   	ret    

c01044fd <kva2page>:

static inline struct Page *
kva2page(void *kva) {
c01044fd:	55                   	push   %ebp
c01044fe:	89 e5                	mov    %esp,%ebp
c0104500:	83 ec 28             	sub    $0x28,%esp
    return pa2page(PADDR(kva));
c0104503:	8b 45 08             	mov    0x8(%ebp),%eax
c0104506:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104509:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104510:	77 23                	ja     c0104535 <kva2page+0x38>
c0104512:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104515:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104519:	c7 44 24 08 00 9b 10 	movl   $0xc0109b00,0x8(%esp)
c0104520:	c0 
c0104521:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c0104528:	00 
c0104529:	c7 04 24 cb 9a 10 c0 	movl   $0xc0109acb,(%esp)
c0104530:	e8 83 c7 ff ff       	call   c0100cb8 <__panic>
c0104535:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104538:	05 00 00 00 40       	add    $0x40000000,%eax
c010453d:	89 04 24             	mov    %eax,(%esp)
c0104540:	e8 1f ff ff ff       	call   c0104464 <pa2page>
}
c0104545:	c9                   	leave  
c0104546:	c3                   	ret    

c0104547 <pte2page>:

static inline struct Page *
pte2page(pte_t pte) {
c0104547:	55                   	push   %ebp
c0104548:	89 e5                	mov    %esp,%ebp
c010454a:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010454d:	8b 45 08             	mov    0x8(%ebp),%eax
c0104550:	83 e0 01             	and    $0x1,%eax
c0104553:	85 c0                	test   %eax,%eax
c0104555:	75 1c                	jne    c0104573 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0104557:	c7 44 24 08 24 9b 10 	movl   $0xc0109b24,0x8(%esp)
c010455e:	c0 
c010455f:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0104566:	00 
c0104567:	c7 04 24 cb 9a 10 c0 	movl   $0xc0109acb,(%esp)
c010456e:	e8 45 c7 ff ff       	call   c0100cb8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0104573:	8b 45 08             	mov    0x8(%ebp),%eax
c0104576:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010457b:	89 04 24             	mov    %eax,(%esp)
c010457e:	e8 e1 fe ff ff       	call   c0104464 <pa2page>
}
c0104583:	c9                   	leave  
c0104584:	c3                   	ret    

c0104585 <pde2page>:

static inline struct Page *
pde2page(pde_t pde) {
c0104585:	55                   	push   %ebp
c0104586:	89 e5                	mov    %esp,%ebp
c0104588:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c010458b:	8b 45 08             	mov    0x8(%ebp),%eax
c010458e:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104593:	89 04 24             	mov    %eax,(%esp)
c0104596:	e8 c9 fe ff ff       	call   c0104464 <pa2page>
}
c010459b:	c9                   	leave  
c010459c:	c3                   	ret    

c010459d <page_ref>:

static inline int
page_ref(struct Page *page) {
c010459d:	55                   	push   %ebp
c010459e:	89 e5                	mov    %esp,%ebp
    return page->ref;
c01045a0:	8b 45 08             	mov    0x8(%ebp),%eax
c01045a3:	8b 00                	mov    (%eax),%eax
}
c01045a5:	5d                   	pop    %ebp
c01045a6:	c3                   	ret    

c01045a7 <set_page_ref>:

static inline void
set_page_ref(struct Page *page, int val) {
c01045a7:	55                   	push   %ebp
c01045a8:	89 e5                	mov    %esp,%ebp
    page->ref = val;
c01045aa:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ad:	8b 55 0c             	mov    0xc(%ebp),%edx
c01045b0:	89 10                	mov    %edx,(%eax)
}
c01045b2:	5d                   	pop    %ebp
c01045b3:	c3                   	ret    

c01045b4 <page_ref_inc>:

static inline int
page_ref_inc(struct Page *page) {
c01045b4:	55                   	push   %ebp
c01045b5:	89 e5                	mov    %esp,%ebp
    page->ref += 1;
c01045b7:	8b 45 08             	mov    0x8(%ebp),%eax
c01045ba:	8b 00                	mov    (%eax),%eax
c01045bc:	8d 50 01             	lea    0x1(%eax),%edx
c01045bf:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c2:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01045c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01045c7:	8b 00                	mov    (%eax),%eax
}
c01045c9:	5d                   	pop    %ebp
c01045ca:	c3                   	ret    

c01045cb <page_ref_dec>:

static inline int
page_ref_dec(struct Page *page) {
c01045cb:	55                   	push   %ebp
c01045cc:	89 e5                	mov    %esp,%ebp
    page->ref -= 1;
c01045ce:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d1:	8b 00                	mov    (%eax),%eax
c01045d3:	8d 50 ff             	lea    -0x1(%eax),%edx
c01045d6:	8b 45 08             	mov    0x8(%ebp),%eax
c01045d9:	89 10                	mov    %edx,(%eax)
    return page->ref;
c01045db:	8b 45 08             	mov    0x8(%ebp),%eax
c01045de:	8b 00                	mov    (%eax),%eax
}
c01045e0:	5d                   	pop    %ebp
c01045e1:	c3                   	ret    

c01045e2 <__intr_save>:
#include <x86.h>
#include <intr.h>
#include <mmu.h>

static inline bool
__intr_save(void) {
c01045e2:	55                   	push   %ebp
c01045e3:	89 e5                	mov    %esp,%ebp
c01045e5:	53                   	push   %ebx
c01045e6:	83 ec 14             	sub    $0x14,%esp
}

static inline uint32_t
read_eflags(void) {
    uint32_t eflags;
    asm volatile ("pushfl; popl %0" : "=r" (eflags));
c01045e9:	9c                   	pushf  
c01045ea:	5b                   	pop    %ebx
c01045eb:	89 5d f4             	mov    %ebx,-0xc(%ebp)
    return eflags;
c01045ee:	8b 45 f4             	mov    -0xc(%ebp),%eax
    if (read_eflags() & FL_IF) {
c01045f1:	25 00 02 00 00       	and    $0x200,%eax
c01045f6:	85 c0                	test   %eax,%eax
c01045f8:	74 0c                	je     c0104606 <__intr_save+0x24>
        intr_disable();
c01045fa:	e8 e7 d9 ff ff       	call   c0101fe6 <intr_disable>
        return 1;
c01045ff:	b8 01 00 00 00       	mov    $0x1,%eax
c0104604:	eb 05                	jmp    c010460b <__intr_save+0x29>
    }
    return 0;
c0104606:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010460b:	83 c4 14             	add    $0x14,%esp
c010460e:	5b                   	pop    %ebx
c010460f:	5d                   	pop    %ebp
c0104610:	c3                   	ret    

c0104611 <__intr_restore>:

static inline void
__intr_restore(bool flag) {
c0104611:	55                   	push   %ebp
c0104612:	89 e5                	mov    %esp,%ebp
c0104614:	83 ec 08             	sub    $0x8,%esp
    if (flag) {
c0104617:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010461b:	74 05                	je     c0104622 <__intr_restore+0x11>
        intr_enable();
c010461d:	e8 be d9 ff ff       	call   c0101fe0 <intr_enable>
    }
}
c0104622:	c9                   	leave  
c0104623:	c3                   	ret    

c0104624 <lgdt>:
/* *
 * lgdt - load the global descriptor table register and reset the
 * data/code segement registers for kernel.
 * */
static inline void
lgdt(struct pseudodesc *pd) {
c0104624:	55                   	push   %ebp
c0104625:	89 e5                	mov    %esp,%ebp
    asm volatile ("lgdt (%0)" :: "r" (pd));
c0104627:	8b 45 08             	mov    0x8(%ebp),%eax
c010462a:	0f 01 10             	lgdtl  (%eax)
    asm volatile ("movw %%ax, %%gs" :: "a" (USER_DS));
c010462d:	b8 23 00 00 00       	mov    $0x23,%eax
c0104632:	8e e8                	mov    %eax,%gs
    asm volatile ("movw %%ax, %%fs" :: "a" (USER_DS));
c0104634:	b8 23 00 00 00       	mov    $0x23,%eax
c0104639:	8e e0                	mov    %eax,%fs
    asm volatile ("movw %%ax, %%es" :: "a" (KERNEL_DS));
c010463b:	b8 10 00 00 00       	mov    $0x10,%eax
c0104640:	8e c0                	mov    %eax,%es
    asm volatile ("movw %%ax, %%ds" :: "a" (KERNEL_DS));
c0104642:	b8 10 00 00 00       	mov    $0x10,%eax
c0104647:	8e d8                	mov    %eax,%ds
    asm volatile ("movw %%ax, %%ss" :: "a" (KERNEL_DS));
c0104649:	b8 10 00 00 00       	mov    $0x10,%eax
c010464e:	8e d0                	mov    %eax,%ss
    // reload cs
    asm volatile ("ljmp %0, $1f\n 1:\n" :: "i" (KERNEL_CS));
c0104650:	ea 57 46 10 c0 08 00 	ljmp   $0x8,$0xc0104657
}
c0104657:	5d                   	pop    %ebp
c0104658:	c3                   	ret    

c0104659 <load_esp0>:
 * load_esp0 - change the ESP0 in default task state segment,
 * so that we can use different kernel stack when we trap frame
 * user to kernel.
 * */
void
load_esp0(uintptr_t esp0) {
c0104659:	55                   	push   %ebp
c010465a:	89 e5                	mov    %esp,%ebp
    ts.ts_esp0 = esp0;
c010465c:	8b 45 08             	mov    0x8(%ebp),%eax
c010465f:	a3 44 1a 12 c0       	mov    %eax,0xc0121a44
}
c0104664:	5d                   	pop    %ebp
c0104665:	c3                   	ret    

c0104666 <gdt_init>:

/* gdt_init - initialize the default GDT and TSS */
static void
gdt_init(void) {
c0104666:	55                   	push   %ebp
c0104667:	89 e5                	mov    %esp,%ebp
c0104669:	83 ec 14             	sub    $0x14,%esp
    // set boot kernel stack and default SS0
    load_esp0((uintptr_t)bootstacktop);
c010466c:	b8 00 00 12 c0       	mov    $0xc0120000,%eax
c0104671:	89 04 24             	mov    %eax,(%esp)
c0104674:	e8 e0 ff ff ff       	call   c0104659 <load_esp0>
    ts.ts_ss0 = KERNEL_DS;
c0104679:	66 c7 05 48 1a 12 c0 	movw   $0x10,0xc0121a48
c0104680:	10 00 

    // initialize the TSS filed of the gdt
    gdt[SEG_TSS] = SEGTSS(STS_T32A, (uintptr_t)&ts, sizeof(ts), DPL_KERNEL);
c0104682:	66 c7 05 28 0a 12 c0 	movw   $0x68,0xc0120a28
c0104689:	68 00 
c010468b:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c0104690:	66 a3 2a 0a 12 c0    	mov    %ax,0xc0120a2a
c0104696:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c010469b:	c1 e8 10             	shr    $0x10,%eax
c010469e:	a2 2c 0a 12 c0       	mov    %al,0xc0120a2c
c01046a3:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c01046aa:	83 e0 f0             	and    $0xfffffff0,%eax
c01046ad:	83 c8 09             	or     $0x9,%eax
c01046b0:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c01046b5:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c01046bc:	83 e0 ef             	and    $0xffffffef,%eax
c01046bf:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c01046c4:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c01046cb:	83 e0 9f             	and    $0xffffff9f,%eax
c01046ce:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c01046d3:	0f b6 05 2d 0a 12 c0 	movzbl 0xc0120a2d,%eax
c01046da:	83 c8 80             	or     $0xffffff80,%eax
c01046dd:	a2 2d 0a 12 c0       	mov    %al,0xc0120a2d
c01046e2:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01046e9:	83 e0 f0             	and    $0xfffffff0,%eax
c01046ec:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c01046f1:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c01046f8:	83 e0 ef             	and    $0xffffffef,%eax
c01046fb:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c0104700:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104707:	83 e0 df             	and    $0xffffffdf,%eax
c010470a:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c010470f:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104716:	83 c8 40             	or     $0x40,%eax
c0104719:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c010471e:	0f b6 05 2e 0a 12 c0 	movzbl 0xc0120a2e,%eax
c0104725:	83 e0 7f             	and    $0x7f,%eax
c0104728:	a2 2e 0a 12 c0       	mov    %al,0xc0120a2e
c010472d:	b8 40 1a 12 c0       	mov    $0xc0121a40,%eax
c0104732:	c1 e8 18             	shr    $0x18,%eax
c0104735:	a2 2f 0a 12 c0       	mov    %al,0xc0120a2f

    // reload all segment registers
    lgdt(&gdt_pd);
c010473a:	c7 04 24 30 0a 12 c0 	movl   $0xc0120a30,(%esp)
c0104741:	e8 de fe ff ff       	call   c0104624 <lgdt>
c0104746:	66 c7 45 fe 28 00    	movw   $0x28,-0x2(%ebp)
    asm volatile ("cli" ::: "memory");
}

static inline void
ltr(uint16_t sel) {
    asm volatile ("ltr %0" :: "r" (sel) : "memory");
c010474c:	0f b7 45 fe          	movzwl -0x2(%ebp),%eax
c0104750:	0f 00 d8             	ltr    %ax

    // load the TSS
    ltr(GD_TSS);
}
c0104753:	c9                   	leave  
c0104754:	c3                   	ret    

c0104755 <init_pmm_manager>:

//init_pmm_manager - initialize a pmm_manager instance
static void
init_pmm_manager(void) {
c0104755:	55                   	push   %ebp
c0104756:	89 e5                	mov    %esp,%ebp
c0104758:	83 ec 18             	sub    $0x18,%esp
    pmm_manager = &default_pmm_manager;
c010475b:	c7 05 cc 1a 12 c0 90 	movl   $0xc0109a90,0xc0121acc
c0104762:	9a 10 c0 
    cprintf("memory management: %s\n", pmm_manager->name);
c0104765:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c010476a:	8b 00                	mov    (%eax),%eax
c010476c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104770:	c7 04 24 50 9b 10 c0 	movl   $0xc0109b50,(%esp)
c0104777:	e8 db bb ff ff       	call   c0100357 <cprintf>
    pmm_manager->init();
c010477c:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104781:	8b 40 04             	mov    0x4(%eax),%eax
c0104784:	ff d0                	call   *%eax
}
c0104786:	c9                   	leave  
c0104787:	c3                   	ret    

c0104788 <init_memmap>:

//init_memmap - call pmm->init_memmap to build Page struct for free memory  
static void
init_memmap(struct Page *base, size_t n) {
c0104788:	55                   	push   %ebp
c0104789:	89 e5                	mov    %esp,%ebp
c010478b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->init_memmap(base, n);
c010478e:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104793:	8b 50 08             	mov    0x8(%eax),%edx
c0104796:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104799:	89 44 24 04          	mov    %eax,0x4(%esp)
c010479d:	8b 45 08             	mov    0x8(%ebp),%eax
c01047a0:	89 04 24             	mov    %eax,(%esp)
c01047a3:	ff d2                	call   *%edx
}
c01047a5:	c9                   	leave  
c01047a6:	c3                   	ret    

c01047a7 <alloc_pages>:

//alloc_pages - call pmm->alloc_pages to allocate a continuous n*PAGESIZE memory 
struct Page *
alloc_pages(size_t n) {
c01047a7:	55                   	push   %ebp
c01047a8:	89 e5                	mov    %esp,%ebp
c01047aa:	83 ec 28             	sub    $0x28,%esp
    struct Page *page=NULL;
c01047ad:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    bool intr_flag;
    
    while (1)
    {
         local_intr_save(intr_flag);
c01047b4:	e8 29 fe ff ff       	call   c01045e2 <__intr_save>
c01047b9:	89 45 f0             	mov    %eax,-0x10(%ebp)
         {
              page = pmm_manager->alloc_pages(n);
c01047bc:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c01047c1:	8b 50 0c             	mov    0xc(%eax),%edx
c01047c4:	8b 45 08             	mov    0x8(%ebp),%eax
c01047c7:	89 04 24             	mov    %eax,(%esp)
c01047ca:	ff d2                	call   *%edx
c01047cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
         }
         local_intr_restore(intr_flag);
c01047cf:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01047d2:	89 04 24             	mov    %eax,(%esp)
c01047d5:	e8 37 fe ff ff       	call   c0104611 <__intr_restore>

         if (page != NULL || n > 1 || swap_init_ok == 0) break;
c01047da:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01047de:	75 2d                	jne    c010480d <alloc_pages+0x66>
c01047e0:	83 7d 08 01          	cmpl   $0x1,0x8(%ebp)
c01047e4:	77 27                	ja     c010480d <alloc_pages+0x66>
c01047e6:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c01047eb:	85 c0                	test   %eax,%eax
c01047ed:	74 1e                	je     c010480d <alloc_pages+0x66>
         
         extern struct mm_struct *check_mm_struct;
         //cprintf("page %x, call swap_out in alloc_pages %d\n",page, n);
         swap_out(check_mm_struct, n, 0);
c01047ef:	8b 55 08             	mov    0x8(%ebp),%edx
c01047f2:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01047f7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01047fe:	00 
c01047ff:	89 54 24 04          	mov    %edx,0x4(%esp)
c0104803:	89 04 24             	mov    %eax,(%esp)
c0104806:	e8 a8 1a 00 00       	call   c01062b3 <swap_out>
    }
c010480b:	eb a7                	jmp    c01047b4 <alloc_pages+0xd>
    //cprintf("n %d,get page %x, No %d in alloc_pages\n",n,page,(page-pages));
    return page;
c010480d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0104810:	c9                   	leave  
c0104811:	c3                   	ret    

c0104812 <free_pages>:

//free_pages - call pmm->free_pages to free a continuous n*PAGESIZE memory 
void
free_pages(struct Page *base, size_t n) {
c0104812:	55                   	push   %ebp
c0104813:	89 e5                	mov    %esp,%ebp
c0104815:	83 ec 28             	sub    $0x28,%esp
    bool intr_flag;
    local_intr_save(intr_flag);
c0104818:	e8 c5 fd ff ff       	call   c01045e2 <__intr_save>
c010481d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        pmm_manager->free_pages(base, n);
c0104820:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104825:	8b 50 10             	mov    0x10(%eax),%edx
c0104828:	8b 45 0c             	mov    0xc(%ebp),%eax
c010482b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010482f:	8b 45 08             	mov    0x8(%ebp),%eax
c0104832:	89 04 24             	mov    %eax,(%esp)
c0104835:	ff d2                	call   *%edx
    }
    local_intr_restore(intr_flag);
c0104837:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010483a:	89 04 24             	mov    %eax,(%esp)
c010483d:	e8 cf fd ff ff       	call   c0104611 <__intr_restore>
}
c0104842:	c9                   	leave  
c0104843:	c3                   	ret    

c0104844 <nr_free_pages>:

//nr_free_pages - call pmm->nr_free_pages to get the size (nr*PAGESIZE) 
//of current free memory
size_t
nr_free_pages(void) {
c0104844:	55                   	push   %ebp
c0104845:	89 e5                	mov    %esp,%ebp
c0104847:	83 ec 28             	sub    $0x28,%esp
    size_t ret;
    bool intr_flag;
    local_intr_save(intr_flag);
c010484a:	e8 93 fd ff ff       	call   c01045e2 <__intr_save>
c010484f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    {
        ret = pmm_manager->nr_free_pages();
c0104852:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0104857:	8b 40 14             	mov    0x14(%eax),%eax
c010485a:	ff d0                	call   *%eax
c010485c:	89 45 f0             	mov    %eax,-0x10(%ebp)
    }
    local_intr_restore(intr_flag);
c010485f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104862:	89 04 24             	mov    %eax,(%esp)
c0104865:	e8 a7 fd ff ff       	call   c0104611 <__intr_restore>
    return ret;
c010486a:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
c010486d:	c9                   	leave  
c010486e:	c3                   	ret    

c010486f <page_init>:

/* pmm_init - initialize the physical memory management */
static void
page_init(void) {
c010486f:	55                   	push   %ebp
c0104870:	89 e5                	mov    %esp,%ebp
c0104872:	57                   	push   %edi
c0104873:	56                   	push   %esi
c0104874:	53                   	push   %ebx
c0104875:	81 ec 9c 00 00 00    	sub    $0x9c,%esp
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
c010487b:	c7 45 c4 00 80 00 c0 	movl   $0xc0008000,-0x3c(%ebp)
    uint64_t maxpa = 0;
c0104882:	c7 45 e0 00 00 00 00 	movl   $0x0,-0x20(%ebp)
c0104889:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)

    cprintf("e820map:\n");
c0104890:	c7 04 24 67 9b 10 c0 	movl   $0xc0109b67,(%esp)
c0104897:	e8 bb ba ff ff       	call   c0100357 <cprintf>
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c010489c:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c01048a3:	e9 0b 01 00 00       	jmp    c01049b3 <page_init+0x144>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c01048a8:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01048ab:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048ae:	89 d0                	mov    %edx,%eax
c01048b0:	c1 e0 02             	shl    $0x2,%eax
c01048b3:	01 d0                	add    %edx,%eax
c01048b5:	c1 e0 02             	shl    $0x2,%eax
c01048b8:	01 c8                	add    %ecx,%eax
c01048ba:	8b 50 08             	mov    0x8(%eax),%edx
c01048bd:	8b 40 04             	mov    0x4(%eax),%eax
c01048c0:	89 45 b8             	mov    %eax,-0x48(%ebp)
c01048c3:	89 55 bc             	mov    %edx,-0x44(%ebp)
c01048c6:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c01048c9:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048cc:	89 d0                	mov    %edx,%eax
c01048ce:	c1 e0 02             	shl    $0x2,%eax
c01048d1:	01 d0                	add    %edx,%eax
c01048d3:	c1 e0 02             	shl    $0x2,%eax
c01048d6:	01 c8                	add    %ecx,%eax
c01048d8:	8b 50 10             	mov    0x10(%eax),%edx
c01048db:	8b 40 0c             	mov    0xc(%eax),%eax
c01048de:	03 45 b8             	add    -0x48(%ebp),%eax
c01048e1:	13 55 bc             	adc    -0x44(%ebp),%edx
c01048e4:	89 45 b0             	mov    %eax,-0x50(%ebp)
c01048e7:	89 55 b4             	mov    %edx,-0x4c(%ebp)
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c01048ea:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c01048ed:	8b 55 dc             	mov    -0x24(%ebp),%edx
c01048f0:	89 d0                	mov    %edx,%eax
c01048f2:	c1 e0 02             	shl    $0x2,%eax
c01048f5:	01 d0                	add    %edx,%eax
c01048f7:	c1 e0 02             	shl    $0x2,%eax
c01048fa:	01 c8                	add    %ecx,%eax
c01048fc:	83 c0 14             	add    $0x14,%eax
c01048ff:	8b 00                	mov    (%eax),%eax
c0104901:	89 45 84             	mov    %eax,-0x7c(%ebp)
c0104904:	8b 45 b0             	mov    -0x50(%ebp),%eax
c0104907:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c010490a:	89 c6                	mov    %eax,%esi
c010490c:	89 d7                	mov    %edx,%edi
c010490e:	83 c6 ff             	add    $0xffffffff,%esi
c0104911:	83 d7 ff             	adc    $0xffffffff,%edi
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
c0104914:	8b 4d c4             	mov    -0x3c(%ebp),%ecx

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
        cprintf("  memory: %08llx, [%08llx, %08llx], type = %d.\n",
c0104917:	8b 55 dc             	mov    -0x24(%ebp),%edx
c010491a:	89 d0                	mov    %edx,%eax
c010491c:	c1 e0 02             	shl    $0x2,%eax
c010491f:	01 d0                	add    %edx,%eax
c0104921:	c1 e0 02             	shl    $0x2,%eax
c0104924:	01 c8                	add    %ecx,%eax
c0104926:	8b 48 0c             	mov    0xc(%eax),%ecx
c0104929:	8b 58 10             	mov    0x10(%eax),%ebx
c010492c:	8b 45 84             	mov    -0x7c(%ebp),%eax
c010492f:	89 44 24 1c          	mov    %eax,0x1c(%esp)
c0104933:	89 74 24 14          	mov    %esi,0x14(%esp)
c0104937:	89 7c 24 18          	mov    %edi,0x18(%esp)
c010493b:	8b 45 b8             	mov    -0x48(%ebp),%eax
c010493e:	8b 55 bc             	mov    -0x44(%ebp),%edx
c0104941:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104945:	89 54 24 10          	mov    %edx,0x10(%esp)
c0104949:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c010494d:	89 5c 24 08          	mov    %ebx,0x8(%esp)
c0104951:	c7 04 24 74 9b 10 c0 	movl   $0xc0109b74,(%esp)
c0104958:	e8 fa b9 ff ff       	call   c0100357 <cprintf>
                memmap->map[i].size, begin, end - 1, memmap->map[i].type);
        if (memmap->map[i].type == E820_ARM) {
c010495d:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104960:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104963:	89 d0                	mov    %edx,%eax
c0104965:	c1 e0 02             	shl    $0x2,%eax
c0104968:	01 d0                	add    %edx,%eax
c010496a:	c1 e0 02             	shl    $0x2,%eax
c010496d:	01 c8                	add    %ecx,%eax
c010496f:	83 c0 14             	add    $0x14,%eax
c0104972:	8b 00                	mov    (%eax),%eax
c0104974:	83 f8 01             	cmp    $0x1,%eax
c0104977:	75 36                	jne    c01049af <page_init+0x140>
            if (maxpa < end && begin < KMEMSIZE) {
c0104979:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010497c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010497f:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104982:	77 2b                	ja     c01049af <page_init+0x140>
c0104984:	3b 55 b4             	cmp    -0x4c(%ebp),%edx
c0104987:	72 05                	jb     c010498e <page_init+0x11f>
c0104989:	3b 45 b0             	cmp    -0x50(%ebp),%eax
c010498c:	73 21                	jae    c01049af <page_init+0x140>
c010498e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104992:	77 1b                	ja     c01049af <page_init+0x140>
c0104994:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0104998:	72 09                	jb     c01049a3 <page_init+0x134>
c010499a:	81 7d b8 ff ff ff 37 	cmpl   $0x37ffffff,-0x48(%ebp)
c01049a1:	77 0c                	ja     c01049af <page_init+0x140>
                maxpa = end;
c01049a3:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01049a6:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01049a9:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01049ac:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    struct e820map *memmap = (struct e820map *)(0x8000 + KERNBASE);
    uint64_t maxpa = 0;

    cprintf("e820map:\n");
    int i;
    for (i = 0; i < memmap->nr_map; i ++) {
c01049af:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c01049b3:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c01049b6:	8b 00                	mov    (%eax),%eax
c01049b8:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c01049bb:	0f 8f e7 fe ff ff    	jg     c01048a8 <page_init+0x39>
            if (maxpa < end && begin < KMEMSIZE) {
                maxpa = end;
            }
        }
    }
    if (maxpa > KMEMSIZE) {
c01049c1:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01049c5:	72 1d                	jb     c01049e4 <page_init+0x175>
c01049c7:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c01049cb:	77 09                	ja     c01049d6 <page_init+0x167>
c01049cd:	81 7d e0 00 00 00 38 	cmpl   $0x38000000,-0x20(%ebp)
c01049d4:	76 0e                	jbe    c01049e4 <page_init+0x175>
        maxpa = KMEMSIZE;
c01049d6:	c7 45 e0 00 00 00 38 	movl   $0x38000000,-0x20(%ebp)
c01049dd:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
    }

    extern char end[];

    npage = maxpa / PGSIZE;
c01049e4:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01049e7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01049ea:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01049ee:	c1 ea 0c             	shr    $0xc,%edx
c01049f1:	a3 20 1a 12 c0       	mov    %eax,0xc0121a20
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);
c01049f6:	c7 45 ac 00 10 00 00 	movl   $0x1000,-0x54(%ebp)
c01049fd:	b8 b0 1b 12 c0       	mov    $0xc0121bb0,%eax
c0104a02:	83 e8 01             	sub    $0x1,%eax
c0104a05:	03 45 ac             	add    -0x54(%ebp),%eax
c0104a08:	89 45 a8             	mov    %eax,-0x58(%ebp)
c0104a0b:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0104a0e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104a13:	f7 75 ac             	divl   -0x54(%ebp)
c0104a16:	89 d0                	mov    %edx,%eax
c0104a18:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0104a1b:	89 d1                	mov    %edx,%ecx
c0104a1d:	29 c1                	sub    %eax,%ecx
c0104a1f:	89 c8                	mov    %ecx,%eax
c0104a21:	a3 d4 1a 12 c0       	mov    %eax,0xc0121ad4

    for (i = 0; i < npage; i ++) {
c0104a26:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104a2d:	eb 27                	jmp    c0104a56 <page_init+0x1e7>
        SetPageReserved(pages + i);
c0104a2f:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0104a34:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a37:	c1 e2 05             	shl    $0x5,%edx
c0104a3a:	01 d0                	add    %edx,%eax
c0104a3c:	83 c0 04             	add    $0x4,%eax
c0104a3f:	c7 45 90 00 00 00 00 	movl   $0x0,-0x70(%ebp)
c0104a46:	89 45 8c             	mov    %eax,-0x74(%ebp)
 * Note that @nr may be almost arbitrarily large; this function is not
 * restricted to acting on a single-word quantity.
 * */
static inline void
set_bit(int nr, volatile void *addr) {
    asm volatile ("btsl %1, %0" :"=m" (*(volatile long *)addr) : "Ir" (nr));
c0104a49:	8b 45 8c             	mov    -0x74(%ebp),%eax
c0104a4c:	8b 55 90             	mov    -0x70(%ebp),%edx
c0104a4f:	0f ab 10             	bts    %edx,(%eax)
    extern char end[];

    npage = maxpa / PGSIZE;
    pages = (struct Page *)ROUNDUP((void *)end, PGSIZE);

    for (i = 0; i < npage; i ++) {
c0104a52:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104a56:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104a59:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104a5e:	39 c2                	cmp    %eax,%edx
c0104a60:	72 cd                	jb     c0104a2f <page_init+0x1c0>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);
c0104a62:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104a67:	89 c2                	mov    %eax,%edx
c0104a69:	c1 e2 05             	shl    $0x5,%edx
c0104a6c:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c0104a71:	01 d0                	add    %edx,%eax
c0104a73:	89 45 a4             	mov    %eax,-0x5c(%ebp)
c0104a76:	81 7d a4 ff ff ff bf 	cmpl   $0xbfffffff,-0x5c(%ebp)
c0104a7d:	77 23                	ja     c0104aa2 <page_init+0x233>
c0104a7f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104a82:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104a86:	c7 44 24 08 00 9b 10 	movl   $0xc0109b00,0x8(%esp)
c0104a8d:	c0 
c0104a8e:	c7 44 24 04 e8 00 00 	movl   $0xe8,0x4(%esp)
c0104a95:	00 
c0104a96:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0104a9d:	e8 16 c2 ff ff       	call   c0100cb8 <__panic>
c0104aa2:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0104aa5:	05 00 00 00 40       	add    $0x40000000,%eax
c0104aaa:	89 45 a0             	mov    %eax,-0x60(%ebp)

    for (i = 0; i < memmap->nr_map; i ++) {
c0104aad:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0104ab4:	e9 7c 01 00 00       	jmp    c0104c35 <page_init+0x3c6>
        uint64_t begin = memmap->map[i].addr, end = begin + memmap->map[i].size;
c0104ab9:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104abc:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104abf:	89 d0                	mov    %edx,%eax
c0104ac1:	c1 e0 02             	shl    $0x2,%eax
c0104ac4:	01 d0                	add    %edx,%eax
c0104ac6:	c1 e0 02             	shl    $0x2,%eax
c0104ac9:	01 c8                	add    %ecx,%eax
c0104acb:	8b 50 08             	mov    0x8(%eax),%edx
c0104ace:	8b 40 04             	mov    0x4(%eax),%eax
c0104ad1:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104ad4:	89 55 d4             	mov    %edx,-0x2c(%ebp)
c0104ad7:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104ada:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104add:	89 d0                	mov    %edx,%eax
c0104adf:	c1 e0 02             	shl    $0x2,%eax
c0104ae2:	01 d0                	add    %edx,%eax
c0104ae4:	c1 e0 02             	shl    $0x2,%eax
c0104ae7:	01 c8                	add    %ecx,%eax
c0104ae9:	8b 50 10             	mov    0x10(%eax),%edx
c0104aec:	8b 40 0c             	mov    0xc(%eax),%eax
c0104aef:	03 45 d0             	add    -0x30(%ebp),%eax
c0104af2:	13 55 d4             	adc    -0x2c(%ebp),%edx
c0104af5:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104af8:	89 55 cc             	mov    %edx,-0x34(%ebp)
        if (memmap->map[i].type == E820_ARM) {
c0104afb:	8b 4d c4             	mov    -0x3c(%ebp),%ecx
c0104afe:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0104b01:	89 d0                	mov    %edx,%eax
c0104b03:	c1 e0 02             	shl    $0x2,%eax
c0104b06:	01 d0                	add    %edx,%eax
c0104b08:	c1 e0 02             	shl    $0x2,%eax
c0104b0b:	01 c8                	add    %ecx,%eax
c0104b0d:	83 c0 14             	add    $0x14,%eax
c0104b10:	8b 00                	mov    (%eax),%eax
c0104b12:	83 f8 01             	cmp    $0x1,%eax
c0104b15:	0f 85 16 01 00 00    	jne    c0104c31 <page_init+0x3c2>
            if (begin < freemem) {
c0104b1b:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104b1e:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b23:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104b26:	72 17                	jb     c0104b3f <page_init+0x2d0>
c0104b28:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0104b2b:	77 05                	ja     c0104b32 <page_init+0x2c3>
c0104b2d:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0104b30:	76 0d                	jbe    c0104b3f <page_init+0x2d0>
                begin = freemem;
c0104b32:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0104b35:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104b38:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
            }
            if (end > KMEMSIZE) {
c0104b3f:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104b43:	72 1d                	jb     c0104b62 <page_init+0x2f3>
c0104b45:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0104b49:	77 09                	ja     c0104b54 <page_init+0x2e5>
c0104b4b:	81 7d c8 00 00 00 38 	cmpl   $0x38000000,-0x38(%ebp)
c0104b52:	76 0e                	jbe    c0104b62 <page_init+0x2f3>
                end = KMEMSIZE;
c0104b54:	c7 45 c8 00 00 00 38 	movl   $0x38000000,-0x38(%ebp)
c0104b5b:	c7 45 cc 00 00 00 00 	movl   $0x0,-0x34(%ebp)
            }
            if (begin < end) {
c0104b62:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b65:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104b68:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b6b:	0f 87 c0 00 00 00    	ja     c0104c31 <page_init+0x3c2>
c0104b71:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104b74:	72 09                	jb     c0104b7f <page_init+0x310>
c0104b76:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104b79:	0f 83 b2 00 00 00    	jae    c0104c31 <page_init+0x3c2>
                begin = ROUNDUP(begin, PGSIZE);
c0104b7f:	c7 45 9c 00 10 00 00 	movl   $0x1000,-0x64(%ebp)
c0104b86:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104b89:	03 45 9c             	add    -0x64(%ebp),%eax
c0104b8c:	83 e8 01             	sub    $0x1,%eax
c0104b8f:	89 45 98             	mov    %eax,-0x68(%ebp)
c0104b92:	8b 45 98             	mov    -0x68(%ebp),%eax
c0104b95:	ba 00 00 00 00       	mov    $0x0,%edx
c0104b9a:	f7 75 9c             	divl   -0x64(%ebp)
c0104b9d:	89 d0                	mov    %edx,%eax
c0104b9f:	8b 55 98             	mov    -0x68(%ebp),%edx
c0104ba2:	89 d1                	mov    %edx,%ecx
c0104ba4:	29 c1                	sub    %eax,%ecx
c0104ba6:	89 c8                	mov    %ecx,%eax
c0104ba8:	ba 00 00 00 00       	mov    $0x0,%edx
c0104bad:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0104bb0:	89 55 d4             	mov    %edx,-0x2c(%ebp)
                end = ROUNDDOWN(end, PGSIZE);
c0104bb3:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104bb6:	89 45 94             	mov    %eax,-0x6c(%ebp)
c0104bb9:	8b 45 94             	mov    -0x6c(%ebp),%eax
c0104bbc:	ba 00 00 00 00       	mov    $0x0,%edx
c0104bc1:	89 c1                	mov    %eax,%ecx
c0104bc3:	81 e1 00 f0 ff ff    	and    $0xfffff000,%ecx
c0104bc9:	89 8d 78 ff ff ff    	mov    %ecx,-0x88(%ebp)
c0104bcf:	89 d1                	mov    %edx,%ecx
c0104bd1:	83 e1 00             	and    $0x0,%ecx
c0104bd4:	89 8d 7c ff ff ff    	mov    %ecx,-0x84(%ebp)
c0104bda:	8b 85 78 ff ff ff    	mov    -0x88(%ebp),%eax
c0104be0:	8b 95 7c ff ff ff    	mov    -0x84(%ebp),%edx
c0104be6:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0104be9:	89 55 cc             	mov    %edx,-0x34(%ebp)
                if (begin < end) {
c0104bec:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104bef:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0104bf2:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104bf5:	77 3a                	ja     c0104c31 <page_init+0x3c2>
c0104bf7:	3b 55 cc             	cmp    -0x34(%ebp),%edx
c0104bfa:	72 05                	jb     c0104c01 <page_init+0x392>
c0104bfc:	3b 45 c8             	cmp    -0x38(%ebp),%eax
c0104bff:	73 30                	jae    c0104c31 <page_init+0x3c2>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
c0104c01:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0104c04:	8b 5d d4             	mov    -0x2c(%ebp),%ebx
c0104c07:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0104c0a:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0104c0d:	29 c8                	sub    %ecx,%eax
c0104c0f:	19 da                	sbb    %ebx,%edx
c0104c11:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c0104c15:	c1 ea 0c             	shr    $0xc,%edx
c0104c18:	89 c3                	mov    %eax,%ebx
c0104c1a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0104c1d:	89 04 24             	mov    %eax,(%esp)
c0104c20:	e8 3f f8 ff ff       	call   c0104464 <pa2page>
c0104c25:	89 5c 24 04          	mov    %ebx,0x4(%esp)
c0104c29:	89 04 24             	mov    %eax,(%esp)
c0104c2c:	e8 57 fb ff ff       	call   c0104788 <init_memmap>
        SetPageReserved(pages + i);
    }

    uintptr_t freemem = PADDR((uintptr_t)pages + sizeof(struct Page) * npage);

    for (i = 0; i < memmap->nr_map; i ++) {
c0104c31:	83 45 dc 01          	addl   $0x1,-0x24(%ebp)
c0104c35:	8b 45 c4             	mov    -0x3c(%ebp),%eax
c0104c38:	8b 00                	mov    (%eax),%eax
c0104c3a:	3b 45 dc             	cmp    -0x24(%ebp),%eax
c0104c3d:	0f 8f 76 fe ff ff    	jg     c0104ab9 <page_init+0x24a>
                    init_memmap(pa2page(begin), (end - begin) / PGSIZE);
                }
            }
        }
    }
}
c0104c43:	81 c4 9c 00 00 00    	add    $0x9c,%esp
c0104c49:	5b                   	pop    %ebx
c0104c4a:	5e                   	pop    %esi
c0104c4b:	5f                   	pop    %edi
c0104c4c:	5d                   	pop    %ebp
c0104c4d:	c3                   	ret    

c0104c4e <enable_paging>:

static void
enable_paging(void) {
c0104c4e:	55                   	push   %ebp
c0104c4f:	89 e5                	mov    %esp,%ebp
c0104c51:	53                   	push   %ebx
c0104c52:	83 ec 10             	sub    $0x10,%esp
    lcr3(boot_cr3);
c0104c55:	a1 d0 1a 12 c0       	mov    0xc0121ad0,%eax
c0104c5a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
}

static inline void
lcr3(uintptr_t cr3) {
    asm volatile ("mov %0, %%cr3" :: "r" (cr3) : "memory");
c0104c5d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104c60:	0f 22 d8             	mov    %eax,%cr3
}

static inline uintptr_t
rcr0(void) {
    uintptr_t cr0;
    asm volatile ("mov %%cr0, %0" : "=r" (cr0) :: "memory");
c0104c63:	0f 20 c3             	mov    %cr0,%ebx
c0104c66:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr0;
c0104c69:	8b 45 f0             	mov    -0x10(%ebp),%eax

    // turn on paging
    uint32_t cr0 = rcr0();
c0104c6c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    cr0 |= CR0_PE | CR0_PG | CR0_AM | CR0_WP | CR0_NE | CR0_TS | CR0_EM | CR0_MP;
c0104c6f:	81 4d f8 2f 00 05 80 	orl    $0x8005002f,-0x8(%ebp)
    cr0 &= ~(CR0_TS | CR0_EM);
c0104c76:	83 65 f8 f3          	andl   $0xfffffff3,-0x8(%ebp)
c0104c7a:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0104c7d:	89 45 ec             	mov    %eax,-0x14(%ebp)
    asm volatile ("pushl %0; popfl" :: "r" (eflags));
}

static inline void
lcr0(uintptr_t cr0) {
    asm volatile ("mov %0, %%cr0" :: "r" (cr0) : "memory");
c0104c80:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104c83:	0f 22 c0             	mov    %eax,%cr0
    lcr0(cr0);
}
c0104c86:	83 c4 10             	add    $0x10,%esp
c0104c89:	5b                   	pop    %ebx
c0104c8a:	5d                   	pop    %ebp
c0104c8b:	c3                   	ret    

c0104c8c <boot_map_segment>:
//  la:   linear address of this memory need to map (after x86 segment map)
//  size: memory size
//  pa:   physical address of this memory
//  perm: permission of this memory  
static void
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
c0104c8c:	55                   	push   %ebp
c0104c8d:	89 e5                	mov    %esp,%ebp
c0104c8f:	83 ec 38             	sub    $0x38,%esp
    assert(PGOFF(la) == PGOFF(pa));
c0104c92:	8b 45 14             	mov    0x14(%ebp),%eax
c0104c95:	8b 55 0c             	mov    0xc(%ebp),%edx
c0104c98:	31 d0                	xor    %edx,%eax
c0104c9a:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104c9f:	85 c0                	test   %eax,%eax
c0104ca1:	74 24                	je     c0104cc7 <boot_map_segment+0x3b>
c0104ca3:	c7 44 24 0c b2 9b 10 	movl   $0xc0109bb2,0xc(%esp)
c0104caa:	c0 
c0104cab:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0104cb2:	c0 
c0104cb3:	c7 44 24 04 11 01 00 	movl   $0x111,0x4(%esp)
c0104cba:	00 
c0104cbb:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0104cc2:	e8 f1 bf ff ff       	call   c0100cb8 <__panic>
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
c0104cc7:	c7 45 f0 00 10 00 00 	movl   $0x1000,-0x10(%ebp)
c0104cce:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104cd1:	25 ff 0f 00 00       	and    $0xfff,%eax
c0104cd6:	03 45 10             	add    0x10(%ebp),%eax
c0104cd9:	03 45 f0             	add    -0x10(%ebp),%eax
c0104cdc:	83 e8 01             	sub    $0x1,%eax
c0104cdf:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0104ce2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104ce5:	ba 00 00 00 00       	mov    $0x0,%edx
c0104cea:	f7 75 f0             	divl   -0x10(%ebp)
c0104ced:	89 d0                	mov    %edx,%eax
c0104cef:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0104cf2:	89 d1                	mov    %edx,%ecx
c0104cf4:	29 c1                	sub    %eax,%ecx
c0104cf6:	89 c8                	mov    %ecx,%eax
c0104cf8:	c1 e8 0c             	shr    $0xc,%eax
c0104cfb:	89 45 f4             	mov    %eax,-0xc(%ebp)
    la = ROUNDDOWN(la, PGSIZE);
c0104cfe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d01:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104d04:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104d07:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d0c:	89 45 0c             	mov    %eax,0xc(%ebp)
    pa = ROUNDDOWN(pa, PGSIZE);
c0104d0f:	8b 45 14             	mov    0x14(%ebp),%eax
c0104d12:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104d15:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0104d18:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104d1d:	89 45 14             	mov    %eax,0x14(%ebp)
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104d20:	eb 6b                	jmp    c0104d8d <boot_map_segment+0x101>
        pte_t *ptep = get_pte(pgdir, la, 1);
c0104d22:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0104d29:	00 
c0104d2a:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104d2d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0104d31:	8b 45 08             	mov    0x8(%ebp),%eax
c0104d34:	89 04 24             	mov    %eax,(%esp)
c0104d37:	e8 cc 01 00 00       	call   c0104f08 <get_pte>
c0104d3c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        assert(ptep != NULL);
c0104d3f:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0104d43:	75 24                	jne    c0104d69 <boot_map_segment+0xdd>
c0104d45:	c7 44 24 0c de 9b 10 	movl   $0xc0109bde,0xc(%esp)
c0104d4c:	c0 
c0104d4d:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0104d54:	c0 
c0104d55:	c7 44 24 04 17 01 00 	movl   $0x117,0x4(%esp)
c0104d5c:	00 
c0104d5d:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0104d64:	e8 4f bf ff ff       	call   c0100cb8 <__panic>
        *ptep = pa | PTE_P | perm;
c0104d69:	8b 45 18             	mov    0x18(%ebp),%eax
c0104d6c:	8b 55 14             	mov    0x14(%ebp),%edx
c0104d6f:	09 d0                	or     %edx,%eax
c0104d71:	89 c2                	mov    %eax,%edx
c0104d73:	83 ca 01             	or     $0x1,%edx
c0104d76:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0104d79:	89 10                	mov    %edx,(%eax)
boot_map_segment(pde_t *pgdir, uintptr_t la, size_t size, uintptr_t pa, uint32_t perm) {
    assert(PGOFF(la) == PGOFF(pa));
    size_t n = ROUNDUP(size + PGOFF(la), PGSIZE) / PGSIZE;
    la = ROUNDDOWN(la, PGSIZE);
    pa = ROUNDDOWN(pa, PGSIZE);
    for (; n > 0; n --, la += PGSIZE, pa += PGSIZE) {
c0104d7b:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0104d7f:	81 45 0c 00 10 00 00 	addl   $0x1000,0xc(%ebp)
c0104d86:	81 45 14 00 10 00 00 	addl   $0x1000,0x14(%ebp)
c0104d8d:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104d91:	75 8f                	jne    c0104d22 <boot_map_segment+0x96>
        pte_t *ptep = get_pte(pgdir, la, 1);
        assert(ptep != NULL);
        *ptep = pa | PTE_P | perm;
    }
}
c0104d93:	c9                   	leave  
c0104d94:	c3                   	ret    

c0104d95 <boot_alloc_page>:

//boot_alloc_page - allocate one page using pmm->alloc_pages(1) 
// return value: the kernel virtual address of this allocated page
//note: this function is used to get the memory for PDT(Page Directory Table)&PT(Page Table)
static void *
boot_alloc_page(void) {
c0104d95:	55                   	push   %ebp
c0104d96:	89 e5                	mov    %esp,%ebp
c0104d98:	83 ec 28             	sub    $0x28,%esp
    struct Page *p = alloc_page();
c0104d9b:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104da2:	e8 00 fa ff ff       	call   c01047a7 <alloc_pages>
c0104da7:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (p == NULL) {
c0104daa:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104dae:	75 1c                	jne    c0104dcc <boot_alloc_page+0x37>
        panic("boot_alloc_page failed.\n");
c0104db0:	c7 44 24 08 eb 9b 10 	movl   $0xc0109beb,0x8(%esp)
c0104db7:	c0 
c0104db8:	c7 44 24 04 23 01 00 	movl   $0x123,0x4(%esp)
c0104dbf:	00 
c0104dc0:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0104dc7:	e8 ec be ff ff       	call   c0100cb8 <__panic>
    }
    return page2kva(p);
c0104dcc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104dcf:	89 04 24             	mov    %eax,(%esp)
c0104dd2:	e8 d2 f6 ff ff       	call   c01044a9 <page2kva>
}
c0104dd7:	c9                   	leave  
c0104dd8:	c3                   	ret    

c0104dd9 <pmm_init>:

//pmm_init - setup a pmm to manage physical memory, build PDT&PT to setup paging mechanism 
//         - check the correctness of pmm & paging mechanism, print PDT&PT
void
pmm_init(void) {
c0104dd9:	55                   	push   %ebp
c0104dda:	89 e5                	mov    %esp,%ebp
c0104ddc:	83 ec 38             	sub    $0x38,%esp
    //We need to alloc/free the physical memory (granularity is 4KB or other size). 
    //So a framework of physical memory manager (struct pmm_manager)is defined in pmm.h
    //First we should init a physical memory manager(pmm) based on the framework.
    //Then pmm can alloc/free the physical memory. 
    //Now the first_fit/best_fit/worst_fit/buddy_system pmm are available.
    init_pmm_manager();
c0104ddf:	e8 71 f9 ff ff       	call   c0104755 <init_pmm_manager>

    // detect physical memory space, reserve already used memory,
    // then use pmm->init_memmap to create free page list
    page_init();
c0104de4:	e8 86 fa ff ff       	call   c010486f <page_init>

    //use pmm->check to verify the correctness of the alloc/free function in a pmm
    check_alloc_page();
c0104de9:	e8 4a 05 00 00       	call   c0105338 <check_alloc_page>

    // create boot_pgdir, an initial page directory(Page Directory Table, PDT)
    boot_pgdir = boot_alloc_page();
c0104dee:	e8 a2 ff ff ff       	call   c0104d95 <boot_alloc_page>
c0104df3:	a3 24 1a 12 c0       	mov    %eax,0xc0121a24
    memset(boot_pgdir, 0, PGSIZE);
c0104df8:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104dfd:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104e04:	00 
c0104e05:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104e0c:	00 
c0104e0d:	89 04 24             	mov    %eax,(%esp)
c0104e10:	e8 ce 3e 00 00       	call   c0108ce3 <memset>
    boot_cr3 = PADDR(boot_pgdir);
c0104e15:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e1a:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104e1d:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c0104e24:	77 23                	ja     c0104e49 <pmm_init+0x70>
c0104e26:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e29:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e2d:	c7 44 24 08 00 9b 10 	movl   $0xc0109b00,0x8(%esp)
c0104e34:	c0 
c0104e35:	c7 44 24 04 3d 01 00 	movl   $0x13d,0x4(%esp)
c0104e3c:	00 
c0104e3d:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0104e44:	e8 6f be ff ff       	call   c0100cb8 <__panic>
c0104e49:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104e4c:	05 00 00 00 40       	add    $0x40000000,%eax
c0104e51:	a3 d0 1a 12 c0       	mov    %eax,0xc0121ad0

    check_pgdir();
c0104e56:	e8 fb 04 00 00       	call   c0105356 <check_pgdir>

    static_assert(KERNBASE % PTSIZE == 0 && KERNTOP % PTSIZE == 0);

    // recursively insert boot_pgdir in itself
    // to form a virtual page table at virtual address VPT
    boot_pgdir[PDX(VPT)] = PADDR(boot_pgdir) | PTE_P | PTE_W;
c0104e5b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e60:	8d 90 ac 0f 00 00    	lea    0xfac(%eax),%edx
c0104e66:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104e6b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0104e6e:	81 7d f0 ff ff ff bf 	cmpl   $0xbfffffff,-0x10(%ebp)
c0104e75:	77 23                	ja     c0104e9a <pmm_init+0xc1>
c0104e77:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e7a:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104e7e:	c7 44 24 08 00 9b 10 	movl   $0xc0109b00,0x8(%esp)
c0104e85:	c0 
c0104e86:	c7 44 24 04 45 01 00 	movl   $0x145,0x4(%esp)
c0104e8d:	00 
c0104e8e:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0104e95:	e8 1e be ff ff       	call   c0100cb8 <__panic>
c0104e9a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104e9d:	05 00 00 00 40       	add    $0x40000000,%eax
c0104ea2:	83 c8 03             	or     $0x3,%eax
c0104ea5:	89 02                	mov    %eax,(%edx)

    // map all physical memory to linear memory with base linear addr KERNBASE
    //linear_addr KERNBASE~KERNBASE+KMEMSIZE = phy_addr 0~KMEMSIZE
    //But shouldn't use this map until enable_paging() & gdt_init() finished.
    boot_map_segment(boot_pgdir, KERNBASE, KMEMSIZE, 0, PTE_W);
c0104ea7:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104eac:	c7 44 24 10 02 00 00 	movl   $0x2,0x10(%esp)
c0104eb3:	00 
c0104eb4:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0104ebb:	00 
c0104ebc:	c7 44 24 08 00 00 00 	movl   $0x38000000,0x8(%esp)
c0104ec3:	38 
c0104ec4:	c7 44 24 04 00 00 00 	movl   $0xc0000000,0x4(%esp)
c0104ecb:	c0 
c0104ecc:	89 04 24             	mov    %eax,(%esp)
c0104ecf:	e8 b8 fd ff ff       	call   c0104c8c <boot_map_segment>

    //temporary map: 
    //virtual_addr 3G~3G+4M = linear_addr 0~4M = linear_addr 3G~3G+4M = phy_addr 0~4M     
    boot_pgdir[0] = boot_pgdir[PDX(KERNBASE)];
c0104ed4:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104ed9:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0104edf:	8b 92 00 0c 00 00    	mov    0xc00(%edx),%edx
c0104ee5:	89 10                	mov    %edx,(%eax)

    enable_paging();
c0104ee7:	e8 62 fd ff ff       	call   c0104c4e <enable_paging>

    //reload gdt(third time,the last time) to map all physical memory
    //virtual_addr 0~4G=liear_addr 0~4G
    //then set kernel stack(ss:esp) in TSS, setup TSS in gdt, load TSS
    gdt_init();
c0104eec:	e8 75 f7 ff ff       	call   c0104666 <gdt_init>

    //disable the map of virtual_addr 0~4M
    boot_pgdir[0] = 0;
c0104ef1:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0104ef6:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    //now the basic virtual memory map(see memalyout.h) is established.
    //check the correctness of the basic virtual memory map.
    check_boot_pgdir();
c0104efc:	e8 f0 0a 00 00       	call   c01059f1 <check_boot_pgdir>

    print_pgdir();
c0104f01:	e8 64 0f 00 00       	call   c0105e6a <print_pgdir>

}
c0104f06:	c9                   	leave  
c0104f07:	c3                   	ret    

c0104f08 <get_pte>:
//  pgdir:  the kernel virtual base address of PDT
//  la:     the linear address need to map
//  create: a logical value to decide if alloc a page for PT
// return vaule: the kernel virtual address of this pte
pte_t *
get_pte(pde_t *pgdir, uintptr_t la, bool create) {
c0104f08:	55                   	push   %ebp
c0104f09:	89 e5                	mov    %esp,%ebp
c0104f0b:	83 ec 38             	sub    $0x38,%esp
                          // (6) clear page content using memset
                          // (7) set page directory entry's permission
    }
    return NULL;          // (8) return page table entry
#endif
    pde_t *pdep = &pgdir[PDX(la)];
c0104f0e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0104f11:	c1 e8 16             	shr    $0x16,%eax
c0104f14:	c1 e0 02             	shl    $0x2,%eax
c0104f17:	03 45 08             	add    0x8(%ebp),%eax
c0104f1a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    if (!(*pdep & PTE_P)) {
c0104f1d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104f20:	8b 00                	mov    (%eax),%eax
c0104f22:	83 e0 01             	and    $0x1,%eax
c0104f25:	85 c0                	test   %eax,%eax
c0104f27:	0f 85 c4 00 00 00    	jne    c0104ff1 <get_pte+0xe9>
        if (!create) return NULL;
c0104f2d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104f31:	75 0a                	jne    c0104f3d <get_pte+0x35>
c0104f33:	b8 00 00 00 00       	mov    $0x0,%eax
c0104f38:	e9 10 01 00 00       	jmp    c010504d <get_pte+0x145>
        struct Page* page;
        if (create && (page = alloc_pages(1)) == NULL) return NULL;
c0104f3d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0104f41:	74 1f                	je     c0104f62 <get_pte+0x5a>
c0104f43:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0104f4a:	e8 58 f8 ff ff       	call   c01047a7 <alloc_pages>
c0104f4f:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0104f52:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0104f56:	75 0a                	jne    c0104f62 <get_pte+0x5a>
c0104f58:	b8 00 00 00 00       	mov    $0x0,%eax
c0104f5d:	e9 eb 00 00 00       	jmp    c010504d <get_pte+0x145>
        set_page_ref(page, 1);
c0104f62:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0104f69:	00 
c0104f6a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f6d:	89 04 24             	mov    %eax,(%esp)
c0104f70:	e8 32 f6 ff ff       	call   c01045a7 <set_page_ref>
        uintptr_t phia = page2pa(page);
c0104f75:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0104f78:	89 04 24             	mov    %eax,(%esp)
c0104f7b:	e8 ce f4 ff ff       	call   c010444e <page2pa>
c0104f80:	89 45 ec             	mov    %eax,-0x14(%ebp)
        memset(KADDR(phia), 0, PGSIZE);
c0104f83:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104f86:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0104f89:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f8c:	c1 e8 0c             	shr    $0xc,%eax
c0104f8f:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0104f92:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0104f97:	39 45 e4             	cmp    %eax,-0x1c(%ebp)
c0104f9a:	72 23                	jb     c0104fbf <get_pte+0xb7>
c0104f9c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104f9f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0104fa3:	c7 44 24 08 dc 9a 10 	movl   $0xc0109adc,0x8(%esp)
c0104faa:	c0 
c0104fab:	c7 44 24 04 93 01 00 	movl   $0x193,0x4(%esp)
c0104fb2:	00 
c0104fb3:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0104fba:	e8 f9 bc ff ff       	call   c0100cb8 <__panic>
c0104fbf:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0104fc2:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0104fc7:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0104fce:	00 
c0104fcf:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c0104fd6:	00 
c0104fd7:	89 04 24             	mov    %eax,(%esp)
c0104fda:	e8 04 3d 00 00       	call   c0108ce3 <memset>
        *pdep = PDE_ADDR(phia) | PTE_U | PTE_W | PTE_P;
c0104fdf:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0104fe2:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104fe7:	89 c2                	mov    %eax,%edx
c0104fe9:	83 ca 07             	or     $0x7,%edx
c0104fec:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104fef:	89 10                	mov    %edx,(%eax)
    }
    return &((pte_t *)KADDR(PDE_ADDR(*pdep)))[PTX(la)];
c0104ff1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0104ff4:	8b 00                	mov    (%eax),%eax
c0104ff6:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0104ffb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0104ffe:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105001:	c1 e8 0c             	shr    $0xc,%eax
c0105004:	89 45 dc             	mov    %eax,-0x24(%ebp)
c0105007:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010500c:	39 45 dc             	cmp    %eax,-0x24(%ebp)
c010500f:	72 23                	jb     c0105034 <get_pte+0x12c>
c0105011:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105014:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105018:	c7 44 24 08 dc 9a 10 	movl   $0xc0109adc,0x8(%esp)
c010501f:	c0 
c0105020:	c7 44 24 04 96 01 00 	movl   $0x196,0x4(%esp)
c0105027:	00 
c0105028:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010502f:	e8 84 bc ff ff       	call   c0100cb8 <__panic>
c0105034:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105037:	2d 00 00 00 40       	sub    $0x40000000,%eax
c010503c:	8b 55 0c             	mov    0xc(%ebp),%edx
c010503f:	c1 ea 0c             	shr    $0xc,%edx
c0105042:	81 e2 ff 03 00 00    	and    $0x3ff,%edx
c0105048:	c1 e2 02             	shl    $0x2,%edx
c010504b:	01 d0                	add    %edx,%eax
}
c010504d:	c9                   	leave  
c010504e:	c3                   	ret    

c010504f <get_page>:

//get_page - get related Page struct for linear address la using PDT pgdir
struct Page *
get_page(pde_t *pgdir, uintptr_t la, pte_t **ptep_store) {
c010504f:	55                   	push   %ebp
c0105050:	89 e5                	mov    %esp,%ebp
c0105052:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105055:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010505c:	00 
c010505d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105060:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105064:	8b 45 08             	mov    0x8(%ebp),%eax
c0105067:	89 04 24             	mov    %eax,(%esp)
c010506a:	e8 99 fe ff ff       	call   c0104f08 <get_pte>
c010506f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep_store != NULL) {
c0105072:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0105076:	74 08                	je     c0105080 <get_page+0x31>
        *ptep_store = ptep;
c0105078:	8b 45 10             	mov    0x10(%ebp),%eax
c010507b:	8b 55 f4             	mov    -0xc(%ebp),%edx
c010507e:	89 10                	mov    %edx,(%eax)
    }
    if (ptep != NULL && *ptep & PTE_P) {
c0105080:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105084:	74 1b                	je     c01050a1 <get_page+0x52>
c0105086:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105089:	8b 00                	mov    (%eax),%eax
c010508b:	83 e0 01             	and    $0x1,%eax
c010508e:	84 c0                	test   %al,%al
c0105090:	74 0f                	je     c01050a1 <get_page+0x52>
        return pte2page(*ptep);
c0105092:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105095:	8b 00                	mov    (%eax),%eax
c0105097:	89 04 24             	mov    %eax,(%esp)
c010509a:	e8 a8 f4 ff ff       	call   c0104547 <pte2page>
c010509f:	eb 05                	jmp    c01050a6 <get_page+0x57>
    }
    return NULL;
c01050a1:	b8 00 00 00 00       	mov    $0x0,%eax
}
c01050a6:	c9                   	leave  
c01050a7:	c3                   	ret    

c01050a8 <page_remove_pte>:

//page_remove_pte - free an Page sturct which is related linear address la
//                - and clean(invalidate) pte which is related linear address la
//note: PT is changed, so the TLB need to be invalidate 
static inline void
page_remove_pte(pde_t *pgdir, uintptr_t la, pte_t *ptep) {
c01050a8:	55                   	push   %ebp
c01050a9:	89 e5                	mov    %esp,%ebp
c01050ab:	83 ec 28             	sub    $0x28,%esp
                                  //(4) and free this page when page reference reachs 0
                                  //(5) clear second page table entry
                                  //(6) flush tlb
    }
#endif
    if(*ptep & PTE_P){
c01050ae:	8b 45 10             	mov    0x10(%ebp),%eax
c01050b1:	8b 00                	mov    (%eax),%eax
c01050b3:	83 e0 01             	and    $0x1,%eax
c01050b6:	84 c0                	test   %al,%al
c01050b8:	74 52                	je     c010510c <page_remove_pte+0x64>
        struct Page *page = pte2page(*ptep);
c01050ba:	8b 45 10             	mov    0x10(%ebp),%eax
c01050bd:	8b 00                	mov    (%eax),%eax
c01050bf:	89 04 24             	mov    %eax,(%esp)
c01050c2:	e8 80 f4 ff ff       	call   c0104547 <pte2page>
c01050c7:	89 45 f4             	mov    %eax,-0xc(%ebp)
        page_ref_dec(page);
c01050ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050cd:	89 04 24             	mov    %eax,(%esp)
c01050d0:	e8 f6 f4 ff ff       	call   c01045cb <page_ref_dec>
        if(page->ref == 0) free_page(page);
c01050d5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050d8:	8b 00                	mov    (%eax),%eax
c01050da:	85 c0                	test   %eax,%eax
c01050dc:	75 13                	jne    c01050f1 <page_remove_pte+0x49>
c01050de:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01050e5:	00 
c01050e6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01050e9:	89 04 24             	mov    %eax,(%esp)
c01050ec:	e8 21 f7 ff ff       	call   c0104812 <free_pages>
        
        *ptep = 0;
c01050f1:	8b 45 10             	mov    0x10(%ebp),%eax
c01050f4:	c7 00 00 00 00 00    	movl   $0x0,(%eax)
        tlb_invalidate(pgdir,la);
c01050fa:	8b 45 0c             	mov    0xc(%ebp),%eax
c01050fd:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105101:	8b 45 08             	mov    0x8(%ebp),%eax
c0105104:	89 04 24             	mov    %eax,(%esp)
c0105107:	e8 ff 00 00 00       	call   c010520b <tlb_invalidate>
    }
}
c010510c:	c9                   	leave  
c010510d:	c3                   	ret    

c010510e <page_remove>:

//page_remove - free an Page which is related linear address la and has an validated pte
void
page_remove(pde_t *pgdir, uintptr_t la) {
c010510e:	55                   	push   %ebp
c010510f:	89 e5                	mov    %esp,%ebp
c0105111:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 0);
c0105114:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010511b:	00 
c010511c:	8b 45 0c             	mov    0xc(%ebp),%eax
c010511f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105123:	8b 45 08             	mov    0x8(%ebp),%eax
c0105126:	89 04 24             	mov    %eax,(%esp)
c0105129:	e8 da fd ff ff       	call   c0104f08 <get_pte>
c010512e:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep != NULL) {
c0105131:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105135:	74 19                	je     c0105150 <page_remove+0x42>
        page_remove_pte(pgdir, la, ptep);
c0105137:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010513a:	89 44 24 08          	mov    %eax,0x8(%esp)
c010513e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105141:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105145:	8b 45 08             	mov    0x8(%ebp),%eax
c0105148:	89 04 24             	mov    %eax,(%esp)
c010514b:	e8 58 ff ff ff       	call   c01050a8 <page_remove_pte>
    }
}
c0105150:	c9                   	leave  
c0105151:	c3                   	ret    

c0105152 <page_insert>:
//  la:    the linear address need to map
//  perm:  the permission of this Page which is setted in related pte
// return value: always 0
//note: PT is changed, so the TLB need to be invalidate 
int
page_insert(pde_t *pgdir, struct Page *page, uintptr_t la, uint32_t perm) {
c0105152:	55                   	push   %ebp
c0105153:	89 e5                	mov    %esp,%ebp
c0105155:	83 ec 28             	sub    $0x28,%esp
    pte_t *ptep = get_pte(pgdir, la, 1);
c0105158:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c010515f:	00 
c0105160:	8b 45 10             	mov    0x10(%ebp),%eax
c0105163:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105167:	8b 45 08             	mov    0x8(%ebp),%eax
c010516a:	89 04 24             	mov    %eax,(%esp)
c010516d:	e8 96 fd ff ff       	call   c0104f08 <get_pte>
c0105172:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (ptep == NULL) {
c0105175:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105179:	75 0a                	jne    c0105185 <page_insert+0x33>
        return -E_NO_MEM;
c010517b:	b8 fc ff ff ff       	mov    $0xfffffffc,%eax
c0105180:	e9 84 00 00 00       	jmp    c0105209 <page_insert+0xb7>
    }
    page_ref_inc(page);
c0105185:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105188:	89 04 24             	mov    %eax,(%esp)
c010518b:	e8 24 f4 ff ff       	call   c01045b4 <page_ref_inc>
    if (*ptep & PTE_P) {
c0105190:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105193:	8b 00                	mov    (%eax),%eax
c0105195:	83 e0 01             	and    $0x1,%eax
c0105198:	84 c0                	test   %al,%al
c010519a:	74 3e                	je     c01051da <page_insert+0x88>
        struct Page *p = pte2page(*ptep);
c010519c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010519f:	8b 00                	mov    (%eax),%eax
c01051a1:	89 04 24             	mov    %eax,(%esp)
c01051a4:	e8 9e f3 ff ff       	call   c0104547 <pte2page>
c01051a9:	89 45 f0             	mov    %eax,-0x10(%ebp)
        if (p == page) {
c01051ac:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01051af:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01051b2:	75 0d                	jne    c01051c1 <page_insert+0x6f>
            page_ref_dec(page);
c01051b4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051b7:	89 04 24             	mov    %eax,(%esp)
c01051ba:	e8 0c f4 ff ff       	call   c01045cb <page_ref_dec>
c01051bf:	eb 19                	jmp    c01051da <page_insert+0x88>
        }
        else {
            page_remove_pte(pgdir, la, ptep);
c01051c1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051c4:	89 44 24 08          	mov    %eax,0x8(%esp)
c01051c8:	8b 45 10             	mov    0x10(%ebp),%eax
c01051cb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01051d2:	89 04 24             	mov    %eax,(%esp)
c01051d5:	e8 ce fe ff ff       	call   c01050a8 <page_remove_pte>
        }
    }
    *ptep = page2pa(page) | PTE_P | perm;
c01051da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01051dd:	89 04 24             	mov    %eax,(%esp)
c01051e0:	e8 69 f2 ff ff       	call   c010444e <page2pa>
c01051e5:	0b 45 14             	or     0x14(%ebp),%eax
c01051e8:	89 c2                	mov    %eax,%edx
c01051ea:	83 ca 01             	or     $0x1,%edx
c01051ed:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01051f0:	89 10                	mov    %edx,(%eax)
    tlb_invalidate(pgdir, la);
c01051f2:	8b 45 10             	mov    0x10(%ebp),%eax
c01051f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01051f9:	8b 45 08             	mov    0x8(%ebp),%eax
c01051fc:	89 04 24             	mov    %eax,(%esp)
c01051ff:	e8 07 00 00 00       	call   c010520b <tlb_invalidate>
    return 0;
c0105204:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105209:	c9                   	leave  
c010520a:	c3                   	ret    

c010520b <tlb_invalidate>:

// invalidate a TLB entry, but only if the page tables being
// edited are the ones currently in use by the processor.
void
tlb_invalidate(pde_t *pgdir, uintptr_t la) {
c010520b:	55                   	push   %ebp
c010520c:	89 e5                	mov    %esp,%ebp
c010520e:	53                   	push   %ebx
c010520f:	83 ec 24             	sub    $0x24,%esp
}

static inline uintptr_t
rcr3(void) {
    uintptr_t cr3;
    asm volatile ("mov %%cr3, %0" : "=r" (cr3) :: "memory");
c0105212:	0f 20 db             	mov    %cr3,%ebx
c0105215:	89 5d f0             	mov    %ebx,-0x10(%ebp)
    return cr3;
c0105218:	8b 45 f0             	mov    -0x10(%ebp),%eax
    if (rcr3() == PADDR(pgdir)) {
c010521b:	89 c2                	mov    %eax,%edx
c010521d:	8b 45 08             	mov    0x8(%ebp),%eax
c0105220:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0105223:	81 7d f4 ff ff ff bf 	cmpl   $0xbfffffff,-0xc(%ebp)
c010522a:	77 23                	ja     c010524f <tlb_invalidate+0x44>
c010522c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010522f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105233:	c7 44 24 08 00 9b 10 	movl   $0xc0109b00,0x8(%esp)
c010523a:	c0 
c010523b:	c7 44 24 04 f8 01 00 	movl   $0x1f8,0x4(%esp)
c0105242:	00 
c0105243:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010524a:	e8 69 ba ff ff       	call   c0100cb8 <__panic>
c010524f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105252:	05 00 00 00 40       	add    $0x40000000,%eax
c0105257:	39 c2                	cmp    %eax,%edx
c0105259:	75 0c                	jne    c0105267 <tlb_invalidate+0x5c>
        invlpg((void *)la);
c010525b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010525e:	89 45 ec             	mov    %eax,-0x14(%ebp)
}

static inline void
invlpg(void *addr) {
    asm volatile ("invlpg (%0)" :: "r" (addr) : "memory");
c0105261:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105264:	0f 01 38             	invlpg (%eax)
    }
}
c0105267:	83 c4 24             	add    $0x24,%esp
c010526a:	5b                   	pop    %ebx
c010526b:	5d                   	pop    %ebp
c010526c:	c3                   	ret    

c010526d <pgdir_alloc_page>:

// pgdir_alloc_page - call alloc_page & page_insert functions to 
//                  - allocate a page size memory & setup an addr map
//                  - pa<->la with linear address la and the PDT pgdir
struct Page *
pgdir_alloc_page(pde_t *pgdir, uintptr_t la, uint32_t perm) {
c010526d:	55                   	push   %ebp
c010526e:	89 e5                	mov    %esp,%ebp
c0105270:	83 ec 28             	sub    $0x28,%esp
    struct Page *page = alloc_page();
c0105273:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010527a:	e8 28 f5 ff ff       	call   c01047a7 <alloc_pages>
c010527f:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (page != NULL) {
c0105282:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0105286:	0f 84 a7 00 00 00    	je     c0105333 <pgdir_alloc_page+0xc6>
        if (page_insert(pgdir, page, la, perm) != 0) {
c010528c:	8b 45 10             	mov    0x10(%ebp),%eax
c010528f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105293:	8b 45 0c             	mov    0xc(%ebp),%eax
c0105296:	89 44 24 08          	mov    %eax,0x8(%esp)
c010529a:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010529d:	89 44 24 04          	mov    %eax,0x4(%esp)
c01052a1:	8b 45 08             	mov    0x8(%ebp),%eax
c01052a4:	89 04 24             	mov    %eax,(%esp)
c01052a7:	e8 a6 fe ff ff       	call   c0105152 <page_insert>
c01052ac:	85 c0                	test   %eax,%eax
c01052ae:	74 1a                	je     c01052ca <pgdir_alloc_page+0x5d>
            free_page(page);
c01052b0:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01052b7:	00 
c01052b8:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052bb:	89 04 24             	mov    %eax,(%esp)
c01052be:	e8 4f f5 ff ff       	call   c0104812 <free_pages>
            return NULL;
c01052c3:	b8 00 00 00 00       	mov    $0x0,%eax
c01052c8:	eb 6c                	jmp    c0105336 <pgdir_alloc_page+0xc9>
        }
        if (swap_init_ok){
c01052ca:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c01052cf:	85 c0                	test   %eax,%eax
c01052d1:	74 60                	je     c0105333 <pgdir_alloc_page+0xc6>
            swap_map_swappable(check_mm_struct, la, page, 0);
c01052d3:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01052d8:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c01052df:	00 
c01052e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01052e3:	89 54 24 08          	mov    %edx,0x8(%esp)
c01052e7:	8b 55 0c             	mov    0xc(%ebp),%edx
c01052ea:	89 54 24 04          	mov    %edx,0x4(%esp)
c01052ee:	89 04 24             	mov    %eax,(%esp)
c01052f1:	e8 71 0f 00 00       	call   c0106267 <swap_map_swappable>
            page->pra_vaddr=la;
c01052f6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01052f9:	8b 55 0c             	mov    0xc(%ebp),%edx
c01052fc:	89 50 1c             	mov    %edx,0x1c(%eax)
            assert(page_ref(page) == 1);
c01052ff:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105302:	89 04 24             	mov    %eax,(%esp)
c0105305:	e8 93 f2 ff ff       	call   c010459d <page_ref>
c010530a:	83 f8 01             	cmp    $0x1,%eax
c010530d:	74 24                	je     c0105333 <pgdir_alloc_page+0xc6>
c010530f:	c7 44 24 0c 04 9c 10 	movl   $0xc0109c04,0xc(%esp)
c0105316:	c0 
c0105317:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c010531e:	c0 
c010531f:	c7 44 24 04 0b 02 00 	movl   $0x20b,0x4(%esp)
c0105326:	00 
c0105327:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010532e:	e8 85 b9 ff ff       	call   c0100cb8 <__panic>
            //cprintf("get No. %d  page: pra_vaddr %x, pra_link.prev %x, pra_link_next %x in pgdir_alloc_page\n", (page-pages), page->pra_vaddr,page->pra_page_link.prev, page->pra_page_link.next);
        }

    }

    return page;
c0105333:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0105336:	c9                   	leave  
c0105337:	c3                   	ret    

c0105338 <check_alloc_page>:

static void
check_alloc_page(void) {
c0105338:	55                   	push   %ebp
c0105339:	89 e5                	mov    %esp,%ebp
c010533b:	83 ec 18             	sub    $0x18,%esp
    pmm_manager->check();
c010533e:	a1 cc 1a 12 c0       	mov    0xc0121acc,%eax
c0105343:	8b 40 18             	mov    0x18(%eax),%eax
c0105346:	ff d0                	call   *%eax
    cprintf("check_alloc_page() succeeded!\n");
c0105348:	c7 04 24 18 9c 10 c0 	movl   $0xc0109c18,(%esp)
c010534f:	e8 03 b0 ff ff       	call   c0100357 <cprintf>
}
c0105354:	c9                   	leave  
c0105355:	c3                   	ret    

c0105356 <check_pgdir>:

static void
check_pgdir(void) {
c0105356:	55                   	push   %ebp
c0105357:	89 e5                	mov    %esp,%ebp
c0105359:	83 ec 38             	sub    $0x38,%esp
    assert(npage <= KMEMSIZE / PGSIZE);
c010535c:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105361:	3d 00 80 03 00       	cmp    $0x38000,%eax
c0105366:	76 24                	jbe    c010538c <check_pgdir+0x36>
c0105368:	c7 44 24 0c 37 9c 10 	movl   $0xc0109c37,0xc(%esp)
c010536f:	c0 
c0105370:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105377:	c0 
c0105378:	c7 44 24 04 1c 02 00 	movl   $0x21c,0x4(%esp)
c010537f:	00 
c0105380:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105387:	e8 2c b9 ff ff       	call   c0100cb8 <__panic>
    assert(boot_pgdir != NULL && (uint32_t)PGOFF(boot_pgdir) == 0);
c010538c:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105391:	85 c0                	test   %eax,%eax
c0105393:	74 0e                	je     c01053a3 <check_pgdir+0x4d>
c0105395:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010539a:	25 ff 0f 00 00       	and    $0xfff,%eax
c010539f:	85 c0                	test   %eax,%eax
c01053a1:	74 24                	je     c01053c7 <check_pgdir+0x71>
c01053a3:	c7 44 24 0c 54 9c 10 	movl   $0xc0109c54,0xc(%esp)
c01053aa:	c0 
c01053ab:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01053b2:	c0 
c01053b3:	c7 44 24 04 1d 02 00 	movl   $0x21d,0x4(%esp)
c01053ba:	00 
c01053bb:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01053c2:	e8 f1 b8 ff ff       	call   c0100cb8 <__panic>
    assert(get_page(boot_pgdir, 0x0, NULL) == NULL);
c01053c7:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01053cc:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01053d3:	00 
c01053d4:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c01053db:	00 
c01053dc:	89 04 24             	mov    %eax,(%esp)
c01053df:	e8 6b fc ff ff       	call   c010504f <get_page>
c01053e4:	85 c0                	test   %eax,%eax
c01053e6:	74 24                	je     c010540c <check_pgdir+0xb6>
c01053e8:	c7 44 24 0c 8c 9c 10 	movl   $0xc0109c8c,0xc(%esp)
c01053ef:	c0 
c01053f0:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01053f7:	c0 
c01053f8:	c7 44 24 04 1e 02 00 	movl   $0x21e,0x4(%esp)
c01053ff:	00 
c0105400:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105407:	e8 ac b8 ff ff       	call   c0100cb8 <__panic>

    struct Page *p1, *p2;
    p1 = alloc_page();
c010540c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105413:	e8 8f f3 ff ff       	call   c01047a7 <alloc_pages>
c0105418:	89 45 f4             	mov    %eax,-0xc(%ebp)
    assert(page_insert(boot_pgdir, p1, 0x0, 0) == 0);
c010541b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105420:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c0105427:	00 
c0105428:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010542f:	00 
c0105430:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105433:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105437:	89 04 24             	mov    %eax,(%esp)
c010543a:	e8 13 fd ff ff       	call   c0105152 <page_insert>
c010543f:	85 c0                	test   %eax,%eax
c0105441:	74 24                	je     c0105467 <check_pgdir+0x111>
c0105443:	c7 44 24 0c b4 9c 10 	movl   $0xc0109cb4,0xc(%esp)
c010544a:	c0 
c010544b:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105452:	c0 
c0105453:	c7 44 24 04 22 02 00 	movl   $0x222,0x4(%esp)
c010545a:	00 
c010545b:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105462:	e8 51 b8 ff ff       	call   c0100cb8 <__panic>

    pte_t *ptep;
    assert((ptep = get_pte(boot_pgdir, 0x0, 0)) != NULL);
c0105467:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010546c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105473:	00 
c0105474:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010547b:	00 
c010547c:	89 04 24             	mov    %eax,(%esp)
c010547f:	e8 84 fa ff ff       	call   c0104f08 <get_pte>
c0105484:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105487:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c010548b:	75 24                	jne    c01054b1 <check_pgdir+0x15b>
c010548d:	c7 44 24 0c e0 9c 10 	movl   $0xc0109ce0,0xc(%esp)
c0105494:	c0 
c0105495:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c010549c:	c0 
c010549d:	c7 44 24 04 25 02 00 	movl   $0x225,0x4(%esp)
c01054a4:	00 
c01054a5:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01054ac:	e8 07 b8 ff ff       	call   c0100cb8 <__panic>
    assert(pte2page(*ptep) == p1);
c01054b1:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01054b4:	8b 00                	mov    (%eax),%eax
c01054b6:	89 04 24             	mov    %eax,(%esp)
c01054b9:	e8 89 f0 ff ff       	call   c0104547 <pte2page>
c01054be:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01054c1:	74 24                	je     c01054e7 <check_pgdir+0x191>
c01054c3:	c7 44 24 0c 0d 9d 10 	movl   $0xc0109d0d,0xc(%esp)
c01054ca:	c0 
c01054cb:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01054d2:	c0 
c01054d3:	c7 44 24 04 26 02 00 	movl   $0x226,0x4(%esp)
c01054da:	00 
c01054db:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01054e2:	e8 d1 b7 ff ff       	call   c0100cb8 <__panic>
    assert(page_ref(p1) == 1);
c01054e7:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01054ea:	89 04 24             	mov    %eax,(%esp)
c01054ed:	e8 ab f0 ff ff       	call   c010459d <page_ref>
c01054f2:	83 f8 01             	cmp    $0x1,%eax
c01054f5:	74 24                	je     c010551b <check_pgdir+0x1c5>
c01054f7:	c7 44 24 0c 23 9d 10 	movl   $0xc0109d23,0xc(%esp)
c01054fe:	c0 
c01054ff:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105506:	c0 
c0105507:	c7 44 24 04 27 02 00 	movl   $0x227,0x4(%esp)
c010550e:	00 
c010550f:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105516:	e8 9d b7 ff ff       	call   c0100cb8 <__panic>

    ptep = &((pte_t *)KADDR(PDE_ADDR(boot_pgdir[0])))[1];
c010551b:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105520:	8b 00                	mov    (%eax),%eax
c0105522:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0105527:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010552a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010552d:	c1 e8 0c             	shr    $0xc,%eax
c0105530:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105533:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105538:	39 45 e8             	cmp    %eax,-0x18(%ebp)
c010553b:	72 23                	jb     c0105560 <check_pgdir+0x20a>
c010553d:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105540:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105544:	c7 44 24 08 dc 9a 10 	movl   $0xc0109adc,0x8(%esp)
c010554b:	c0 
c010554c:	c7 44 24 04 29 02 00 	movl   $0x229,0x4(%esp)
c0105553:	00 
c0105554:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010555b:	e8 58 b7 ff ff       	call   c0100cb8 <__panic>
c0105560:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0105563:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105568:	83 c0 04             	add    $0x4,%eax
c010556b:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(get_pte(boot_pgdir, PGSIZE, 0) == ptep);
c010556e:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105573:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010557a:	00 
c010557b:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105582:	00 
c0105583:	89 04 24             	mov    %eax,(%esp)
c0105586:	e8 7d f9 ff ff       	call   c0104f08 <get_pte>
c010558b:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010558e:	74 24                	je     c01055b4 <check_pgdir+0x25e>
c0105590:	c7 44 24 0c 38 9d 10 	movl   $0xc0109d38,0xc(%esp)
c0105597:	c0 
c0105598:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c010559f:	c0 
c01055a0:	c7 44 24 04 2a 02 00 	movl   $0x22a,0x4(%esp)
c01055a7:	00 
c01055a8:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01055af:	e8 04 b7 ff ff       	call   c0100cb8 <__panic>

    p2 = alloc_page();
c01055b4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01055bb:	e8 e7 f1 ff ff       	call   c01047a7 <alloc_pages>
c01055c0:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(page_insert(boot_pgdir, p2, PGSIZE, PTE_U | PTE_W) == 0);
c01055c3:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01055c8:	c7 44 24 0c 06 00 00 	movl   $0x6,0xc(%esp)
c01055cf:	00 
c01055d0:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c01055d7:	00 
c01055d8:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c01055db:	89 54 24 04          	mov    %edx,0x4(%esp)
c01055df:	89 04 24             	mov    %eax,(%esp)
c01055e2:	e8 6b fb ff ff       	call   c0105152 <page_insert>
c01055e7:	85 c0                	test   %eax,%eax
c01055e9:	74 24                	je     c010560f <check_pgdir+0x2b9>
c01055eb:	c7 44 24 0c 60 9d 10 	movl   $0xc0109d60,0xc(%esp)
c01055f2:	c0 
c01055f3:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01055fa:	c0 
c01055fb:	c7 44 24 04 2d 02 00 	movl   $0x22d,0x4(%esp)
c0105602:	00 
c0105603:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010560a:	e8 a9 b6 ff ff       	call   c0100cb8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c010560f:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105614:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010561b:	00 
c010561c:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c0105623:	00 
c0105624:	89 04 24             	mov    %eax,(%esp)
c0105627:	e8 dc f8 ff ff       	call   c0104f08 <get_pte>
c010562c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010562f:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0105633:	75 24                	jne    c0105659 <check_pgdir+0x303>
c0105635:	c7 44 24 0c 98 9d 10 	movl   $0xc0109d98,0xc(%esp)
c010563c:	c0 
c010563d:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105644:	c0 
c0105645:	c7 44 24 04 2e 02 00 	movl   $0x22e,0x4(%esp)
c010564c:	00 
c010564d:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105654:	e8 5f b6 ff ff       	call   c0100cb8 <__panic>
    assert(*ptep & PTE_U);
c0105659:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010565c:	8b 00                	mov    (%eax),%eax
c010565e:	83 e0 04             	and    $0x4,%eax
c0105661:	85 c0                	test   %eax,%eax
c0105663:	75 24                	jne    c0105689 <check_pgdir+0x333>
c0105665:	c7 44 24 0c c8 9d 10 	movl   $0xc0109dc8,0xc(%esp)
c010566c:	c0 
c010566d:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105674:	c0 
c0105675:	c7 44 24 04 2f 02 00 	movl   $0x22f,0x4(%esp)
c010567c:	00 
c010567d:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105684:	e8 2f b6 ff ff       	call   c0100cb8 <__panic>
    assert(*ptep & PTE_W);
c0105689:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010568c:	8b 00                	mov    (%eax),%eax
c010568e:	83 e0 02             	and    $0x2,%eax
c0105691:	85 c0                	test   %eax,%eax
c0105693:	75 24                	jne    c01056b9 <check_pgdir+0x363>
c0105695:	c7 44 24 0c d6 9d 10 	movl   $0xc0109dd6,0xc(%esp)
c010569c:	c0 
c010569d:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01056a4:	c0 
c01056a5:	c7 44 24 04 30 02 00 	movl   $0x230,0x4(%esp)
c01056ac:	00 
c01056ad:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01056b4:	e8 ff b5 ff ff       	call   c0100cb8 <__panic>
    assert(boot_pgdir[0] & PTE_U);
c01056b9:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01056be:	8b 00                	mov    (%eax),%eax
c01056c0:	83 e0 04             	and    $0x4,%eax
c01056c3:	85 c0                	test   %eax,%eax
c01056c5:	75 24                	jne    c01056eb <check_pgdir+0x395>
c01056c7:	c7 44 24 0c e4 9d 10 	movl   $0xc0109de4,0xc(%esp)
c01056ce:	c0 
c01056cf:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01056d6:	c0 
c01056d7:	c7 44 24 04 31 02 00 	movl   $0x231,0x4(%esp)
c01056de:	00 
c01056df:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01056e6:	e8 cd b5 ff ff       	call   c0100cb8 <__panic>
    assert(page_ref(p2) == 1);
c01056eb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01056ee:	89 04 24             	mov    %eax,(%esp)
c01056f1:	e8 a7 ee ff ff       	call   c010459d <page_ref>
c01056f6:	83 f8 01             	cmp    $0x1,%eax
c01056f9:	74 24                	je     c010571f <check_pgdir+0x3c9>
c01056fb:	c7 44 24 0c fa 9d 10 	movl   $0xc0109dfa,0xc(%esp)
c0105702:	c0 
c0105703:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c010570a:	c0 
c010570b:	c7 44 24 04 32 02 00 	movl   $0x232,0x4(%esp)
c0105712:	00 
c0105713:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010571a:	e8 99 b5 ff ff       	call   c0100cb8 <__panic>

    assert(page_insert(boot_pgdir, p1, PGSIZE, 0) == 0);
c010571f:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105724:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010572b:	00 
c010572c:	c7 44 24 08 00 10 00 	movl   $0x1000,0x8(%esp)
c0105733:	00 
c0105734:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105737:	89 54 24 04          	mov    %edx,0x4(%esp)
c010573b:	89 04 24             	mov    %eax,(%esp)
c010573e:	e8 0f fa ff ff       	call   c0105152 <page_insert>
c0105743:	85 c0                	test   %eax,%eax
c0105745:	74 24                	je     c010576b <check_pgdir+0x415>
c0105747:	c7 44 24 0c 0c 9e 10 	movl   $0xc0109e0c,0xc(%esp)
c010574e:	c0 
c010574f:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105756:	c0 
c0105757:	c7 44 24 04 34 02 00 	movl   $0x234,0x4(%esp)
c010575e:	00 
c010575f:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105766:	e8 4d b5 ff ff       	call   c0100cb8 <__panic>
    assert(page_ref(p1) == 2);
c010576b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010576e:	89 04 24             	mov    %eax,(%esp)
c0105771:	e8 27 ee ff ff       	call   c010459d <page_ref>
c0105776:	83 f8 02             	cmp    $0x2,%eax
c0105779:	74 24                	je     c010579f <check_pgdir+0x449>
c010577b:	c7 44 24 0c 38 9e 10 	movl   $0xc0109e38,0xc(%esp)
c0105782:	c0 
c0105783:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c010578a:	c0 
c010578b:	c7 44 24 04 35 02 00 	movl   $0x235,0x4(%esp)
c0105792:	00 
c0105793:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010579a:	e8 19 b5 ff ff       	call   c0100cb8 <__panic>
    assert(page_ref(p2) == 0);
c010579f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01057a2:	89 04 24             	mov    %eax,(%esp)
c01057a5:	e8 f3 ed ff ff       	call   c010459d <page_ref>
c01057aa:	85 c0                	test   %eax,%eax
c01057ac:	74 24                	je     c01057d2 <check_pgdir+0x47c>
c01057ae:	c7 44 24 0c 4a 9e 10 	movl   $0xc0109e4a,0xc(%esp)
c01057b5:	c0 
c01057b6:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01057bd:	c0 
c01057be:	c7 44 24 04 36 02 00 	movl   $0x236,0x4(%esp)
c01057c5:	00 
c01057c6:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01057cd:	e8 e6 b4 ff ff       	call   c0100cb8 <__panic>
    assert((ptep = get_pte(boot_pgdir, PGSIZE, 0)) != NULL);
c01057d2:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01057d7:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01057de:	00 
c01057df:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01057e6:	00 
c01057e7:	89 04 24             	mov    %eax,(%esp)
c01057ea:	e8 19 f7 ff ff       	call   c0104f08 <get_pte>
c01057ef:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01057f2:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01057f6:	75 24                	jne    c010581c <check_pgdir+0x4c6>
c01057f8:	c7 44 24 0c 98 9d 10 	movl   $0xc0109d98,0xc(%esp)
c01057ff:	c0 
c0105800:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105807:	c0 
c0105808:	c7 44 24 04 37 02 00 	movl   $0x237,0x4(%esp)
c010580f:	00 
c0105810:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105817:	e8 9c b4 ff ff       	call   c0100cb8 <__panic>
    assert(pte2page(*ptep) == p1);
c010581c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010581f:	8b 00                	mov    (%eax),%eax
c0105821:	89 04 24             	mov    %eax,(%esp)
c0105824:	e8 1e ed ff ff       	call   c0104547 <pte2page>
c0105829:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c010582c:	74 24                	je     c0105852 <check_pgdir+0x4fc>
c010582e:	c7 44 24 0c 0d 9d 10 	movl   $0xc0109d0d,0xc(%esp)
c0105835:	c0 
c0105836:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c010583d:	c0 
c010583e:	c7 44 24 04 38 02 00 	movl   $0x238,0x4(%esp)
c0105845:	00 
c0105846:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010584d:	e8 66 b4 ff ff       	call   c0100cb8 <__panic>
    assert((*ptep & PTE_U) == 0);
c0105852:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105855:	8b 00                	mov    (%eax),%eax
c0105857:	83 e0 04             	and    $0x4,%eax
c010585a:	85 c0                	test   %eax,%eax
c010585c:	74 24                	je     c0105882 <check_pgdir+0x52c>
c010585e:	c7 44 24 0c 5c 9e 10 	movl   $0xc0109e5c,0xc(%esp)
c0105865:	c0 
c0105866:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c010586d:	c0 
c010586e:	c7 44 24 04 39 02 00 	movl   $0x239,0x4(%esp)
c0105875:	00 
c0105876:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010587d:	e8 36 b4 ff ff       	call   c0100cb8 <__panic>

    page_remove(boot_pgdir, 0x0);
c0105882:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105887:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
c010588e:	00 
c010588f:	89 04 24             	mov    %eax,(%esp)
c0105892:	e8 77 f8 ff ff       	call   c010510e <page_remove>
    assert(page_ref(p1) == 1);
c0105897:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010589a:	89 04 24             	mov    %eax,(%esp)
c010589d:	e8 fb ec ff ff       	call   c010459d <page_ref>
c01058a2:	83 f8 01             	cmp    $0x1,%eax
c01058a5:	74 24                	je     c01058cb <check_pgdir+0x575>
c01058a7:	c7 44 24 0c 23 9d 10 	movl   $0xc0109d23,0xc(%esp)
c01058ae:	c0 
c01058af:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01058b6:	c0 
c01058b7:	c7 44 24 04 3c 02 00 	movl   $0x23c,0x4(%esp)
c01058be:	00 
c01058bf:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01058c6:	e8 ed b3 ff ff       	call   c0100cb8 <__panic>
    assert(page_ref(p2) == 0);
c01058cb:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01058ce:	89 04 24             	mov    %eax,(%esp)
c01058d1:	e8 c7 ec ff ff       	call   c010459d <page_ref>
c01058d6:	85 c0                	test   %eax,%eax
c01058d8:	74 24                	je     c01058fe <check_pgdir+0x5a8>
c01058da:	c7 44 24 0c 4a 9e 10 	movl   $0xc0109e4a,0xc(%esp)
c01058e1:	c0 
c01058e2:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01058e9:	c0 
c01058ea:	c7 44 24 04 3d 02 00 	movl   $0x23d,0x4(%esp)
c01058f1:	00 
c01058f2:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01058f9:	e8 ba b3 ff ff       	call   c0100cb8 <__panic>

    page_remove(boot_pgdir, PGSIZE);
c01058fe:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105903:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c010590a:	00 
c010590b:	89 04 24             	mov    %eax,(%esp)
c010590e:	e8 fb f7 ff ff       	call   c010510e <page_remove>
    assert(page_ref(p1) == 0);
c0105913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105916:	89 04 24             	mov    %eax,(%esp)
c0105919:	e8 7f ec ff ff       	call   c010459d <page_ref>
c010591e:	85 c0                	test   %eax,%eax
c0105920:	74 24                	je     c0105946 <check_pgdir+0x5f0>
c0105922:	c7 44 24 0c 71 9e 10 	movl   $0xc0109e71,0xc(%esp)
c0105929:	c0 
c010592a:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105931:	c0 
c0105932:	c7 44 24 04 40 02 00 	movl   $0x240,0x4(%esp)
c0105939:	00 
c010593a:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105941:	e8 72 b3 ff ff       	call   c0100cb8 <__panic>
    assert(page_ref(p2) == 0);
c0105946:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105949:	89 04 24             	mov    %eax,(%esp)
c010594c:	e8 4c ec ff ff       	call   c010459d <page_ref>
c0105951:	85 c0                	test   %eax,%eax
c0105953:	74 24                	je     c0105979 <check_pgdir+0x623>
c0105955:	c7 44 24 0c 4a 9e 10 	movl   $0xc0109e4a,0xc(%esp)
c010595c:	c0 
c010595d:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105964:	c0 
c0105965:	c7 44 24 04 41 02 00 	movl   $0x241,0x4(%esp)
c010596c:	00 
c010596d:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105974:	e8 3f b3 ff ff       	call   c0100cb8 <__panic>

    assert(page_ref(pde2page(boot_pgdir[0])) == 1);
c0105979:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c010597e:	8b 00                	mov    (%eax),%eax
c0105980:	89 04 24             	mov    %eax,(%esp)
c0105983:	e8 fd eb ff ff       	call   c0104585 <pde2page>
c0105988:	89 04 24             	mov    %eax,(%esp)
c010598b:	e8 0d ec ff ff       	call   c010459d <page_ref>
c0105990:	83 f8 01             	cmp    $0x1,%eax
c0105993:	74 24                	je     c01059b9 <check_pgdir+0x663>
c0105995:	c7 44 24 0c 84 9e 10 	movl   $0xc0109e84,0xc(%esp)
c010599c:	c0 
c010599d:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01059a4:	c0 
c01059a5:	c7 44 24 04 43 02 00 	movl   $0x243,0x4(%esp)
c01059ac:	00 
c01059ad:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01059b4:	e8 ff b2 ff ff       	call   c0100cb8 <__panic>
    free_page(pde2page(boot_pgdir[0]));
c01059b9:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01059be:	8b 00                	mov    (%eax),%eax
c01059c0:	89 04 24             	mov    %eax,(%esp)
c01059c3:	e8 bd eb ff ff       	call   c0104585 <pde2page>
c01059c8:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01059cf:	00 
c01059d0:	89 04 24             	mov    %eax,(%esp)
c01059d3:	e8 3a ee ff ff       	call   c0104812 <free_pages>
    boot_pgdir[0] = 0;
c01059d8:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c01059dd:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_pgdir() succeeded!\n");
c01059e3:	c7 04 24 ab 9e 10 c0 	movl   $0xc0109eab,(%esp)
c01059ea:	e8 68 a9 ff ff       	call   c0100357 <cprintf>
}
c01059ef:	c9                   	leave  
c01059f0:	c3                   	ret    

c01059f1 <check_boot_pgdir>:

static void
check_boot_pgdir(void) {
c01059f1:	55                   	push   %ebp
c01059f2:	89 e5                	mov    %esp,%ebp
c01059f4:	83 ec 38             	sub    $0x38,%esp
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c01059f7:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01059fe:	e9 cb 00 00 00       	jmp    c0105ace <check_boot_pgdir+0xdd>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
c0105a03:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a06:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0105a09:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a0c:	c1 e8 0c             	shr    $0xc,%eax
c0105a0f:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0105a12:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105a17:	39 45 ec             	cmp    %eax,-0x14(%ebp)
c0105a1a:	72 23                	jb     c0105a3f <check_boot_pgdir+0x4e>
c0105a1c:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a1f:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105a23:	c7 44 24 08 dc 9a 10 	movl   $0xc0109adc,0x8(%esp)
c0105a2a:	c0 
c0105a2b:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c0105a32:	00 
c0105a33:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105a3a:	e8 79 b2 ff ff       	call   c0100cb8 <__panic>
c0105a3f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0105a42:	2d 00 00 00 40       	sub    $0x40000000,%eax
c0105a47:	89 c2                	mov    %eax,%edx
c0105a49:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105a4e:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0105a55:	00 
c0105a56:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105a5a:	89 04 24             	mov    %eax,(%esp)
c0105a5d:	e8 a6 f4 ff ff       	call   c0104f08 <get_pte>
c0105a62:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0105a65:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0105a69:	75 24                	jne    c0105a8f <check_boot_pgdir+0x9e>
c0105a6b:	c7 44 24 0c c8 9e 10 	movl   $0xc0109ec8,0xc(%esp)
c0105a72:	c0 
c0105a73:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105a7a:	c0 
c0105a7b:	c7 44 24 04 4f 02 00 	movl   $0x24f,0x4(%esp)
c0105a82:	00 
c0105a83:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105a8a:	e8 29 b2 ff ff       	call   c0100cb8 <__panic>
        assert(PTE_ADDR(*ptep) == i);
c0105a8f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0105a92:	8b 00                	mov    (%eax),%eax
c0105a94:	89 c2                	mov    %eax,%edx
c0105a96:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c0105a9c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0105a9f:	39 c2                	cmp    %eax,%edx
c0105aa1:	74 24                	je     c0105ac7 <check_boot_pgdir+0xd6>
c0105aa3:	c7 44 24 0c 05 9f 10 	movl   $0xc0109f05,0xc(%esp)
c0105aaa:	c0 
c0105aab:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105ab2:	c0 
c0105ab3:	c7 44 24 04 50 02 00 	movl   $0x250,0x4(%esp)
c0105aba:	00 
c0105abb:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105ac2:	e8 f1 b1 ff ff       	call   c0100cb8 <__panic>

static void
check_boot_pgdir(void) {
    pte_t *ptep;
    int i;
    for (i = 0; i < npage; i += PGSIZE) {
c0105ac7:	81 45 f4 00 10 00 00 	addl   $0x1000,-0xc(%ebp)
c0105ace:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0105ad1:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0105ad6:	39 c2                	cmp    %eax,%edx
c0105ad8:	0f 82 25 ff ff ff    	jb     c0105a03 <check_boot_pgdir+0x12>
        assert((ptep = get_pte(boot_pgdir, (uintptr_t)KADDR(i), 0)) != NULL);
        assert(PTE_ADDR(*ptep) == i);
    }

    assert(PDE_ADDR(boot_pgdir[PDX(VPT)]) == PADDR(boot_pgdir));
c0105ade:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105ae3:	05 ac 0f 00 00       	add    $0xfac,%eax
c0105ae8:	8b 00                	mov    (%eax),%eax
c0105aea:	89 c2                	mov    %eax,%edx
c0105aec:	81 e2 00 f0 ff ff    	and    $0xfffff000,%edx
c0105af2:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105af7:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105afa:	81 7d e4 ff ff ff bf 	cmpl   $0xbfffffff,-0x1c(%ebp)
c0105b01:	77 23                	ja     c0105b26 <check_boot_pgdir+0x135>
c0105b03:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b06:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0105b0a:	c7 44 24 08 00 9b 10 	movl   $0xc0109b00,0x8(%esp)
c0105b11:	c0 
c0105b12:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105b19:	00 
c0105b1a:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105b21:	e8 92 b1 ff ff       	call   c0100cb8 <__panic>
c0105b26:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105b29:	05 00 00 00 40       	add    $0x40000000,%eax
c0105b2e:	39 c2                	cmp    %eax,%edx
c0105b30:	74 24                	je     c0105b56 <check_boot_pgdir+0x165>
c0105b32:	c7 44 24 0c 1c 9f 10 	movl   $0xc0109f1c,0xc(%esp)
c0105b39:	c0 
c0105b3a:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105b41:	c0 
c0105b42:	c7 44 24 04 53 02 00 	movl   $0x253,0x4(%esp)
c0105b49:	00 
c0105b4a:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105b51:	e8 62 b1 ff ff       	call   c0100cb8 <__panic>

    assert(boot_pgdir[0] == 0);
c0105b56:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105b5b:	8b 00                	mov    (%eax),%eax
c0105b5d:	85 c0                	test   %eax,%eax
c0105b5f:	74 24                	je     c0105b85 <check_boot_pgdir+0x194>
c0105b61:	c7 44 24 0c 50 9f 10 	movl   $0xc0109f50,0xc(%esp)
c0105b68:	c0 
c0105b69:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105b70:	c0 
c0105b71:	c7 44 24 04 55 02 00 	movl   $0x255,0x4(%esp)
c0105b78:	00 
c0105b79:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105b80:	e8 33 b1 ff ff       	call   c0100cb8 <__panic>

    struct Page *p;
    p = alloc_page();
c0105b85:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0105b8c:	e8 16 ec ff ff       	call   c01047a7 <alloc_pages>
c0105b91:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(page_insert(boot_pgdir, p, 0x100, PTE_W) == 0);
c0105b94:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105b99:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105ba0:	00 
c0105ba1:	c7 44 24 08 00 01 00 	movl   $0x100,0x8(%esp)
c0105ba8:	00 
c0105ba9:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105bac:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105bb0:	89 04 24             	mov    %eax,(%esp)
c0105bb3:	e8 9a f5 ff ff       	call   c0105152 <page_insert>
c0105bb8:	85 c0                	test   %eax,%eax
c0105bba:	74 24                	je     c0105be0 <check_boot_pgdir+0x1ef>
c0105bbc:	c7 44 24 0c 64 9f 10 	movl   $0xc0109f64,0xc(%esp)
c0105bc3:	c0 
c0105bc4:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105bcb:	c0 
c0105bcc:	c7 44 24 04 59 02 00 	movl   $0x259,0x4(%esp)
c0105bd3:	00 
c0105bd4:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105bdb:	e8 d8 b0 ff ff       	call   c0100cb8 <__panic>
    assert(page_ref(p) == 1);
c0105be0:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105be3:	89 04 24             	mov    %eax,(%esp)
c0105be6:	e8 b2 e9 ff ff       	call   c010459d <page_ref>
c0105beb:	83 f8 01             	cmp    $0x1,%eax
c0105bee:	74 24                	je     c0105c14 <check_boot_pgdir+0x223>
c0105bf0:	c7 44 24 0c 92 9f 10 	movl   $0xc0109f92,0xc(%esp)
c0105bf7:	c0 
c0105bf8:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105bff:	c0 
c0105c00:	c7 44 24 04 5a 02 00 	movl   $0x25a,0x4(%esp)
c0105c07:	00 
c0105c08:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105c0f:	e8 a4 b0 ff ff       	call   c0100cb8 <__panic>
    assert(page_insert(boot_pgdir, p, 0x100 + PGSIZE, PTE_W) == 0);
c0105c14:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105c19:	c7 44 24 0c 02 00 00 	movl   $0x2,0xc(%esp)
c0105c20:	00 
c0105c21:	c7 44 24 08 00 11 00 	movl   $0x1100,0x8(%esp)
c0105c28:	00 
c0105c29:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105c2c:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105c30:	89 04 24             	mov    %eax,(%esp)
c0105c33:	e8 1a f5 ff ff       	call   c0105152 <page_insert>
c0105c38:	85 c0                	test   %eax,%eax
c0105c3a:	74 24                	je     c0105c60 <check_boot_pgdir+0x26f>
c0105c3c:	c7 44 24 0c a4 9f 10 	movl   $0xc0109fa4,0xc(%esp)
c0105c43:	c0 
c0105c44:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105c4b:	c0 
c0105c4c:	c7 44 24 04 5b 02 00 	movl   $0x25b,0x4(%esp)
c0105c53:	00 
c0105c54:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105c5b:	e8 58 b0 ff ff       	call   c0100cb8 <__panic>
    assert(page_ref(p) == 2);
c0105c60:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105c63:	89 04 24             	mov    %eax,(%esp)
c0105c66:	e8 32 e9 ff ff       	call   c010459d <page_ref>
c0105c6b:	83 f8 02             	cmp    $0x2,%eax
c0105c6e:	74 24                	je     c0105c94 <check_boot_pgdir+0x2a3>
c0105c70:	c7 44 24 0c db 9f 10 	movl   $0xc0109fdb,0xc(%esp)
c0105c77:	c0 
c0105c78:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105c7f:	c0 
c0105c80:	c7 44 24 04 5c 02 00 	movl   $0x25c,0x4(%esp)
c0105c87:	00 
c0105c88:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105c8f:	e8 24 b0 ff ff       	call   c0100cb8 <__panic>

    const char *str = "ucore: Hello world!!";
c0105c94:	c7 45 dc ec 9f 10 c0 	movl   $0xc0109fec,-0x24(%ebp)
    strcpy((void *)0x100, str);
c0105c9b:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105c9e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0105ca2:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105ca9:	e8 58 2d 00 00       	call   c0108a06 <strcpy>
    assert(strcmp((void *)0x100, (void *)(0x100 + PGSIZE)) == 0);
c0105cae:	c7 44 24 04 00 11 00 	movl   $0x1100,0x4(%esp)
c0105cb5:	00 
c0105cb6:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105cbd:	e8 c1 2d 00 00       	call   c0108a83 <strcmp>
c0105cc2:	85 c0                	test   %eax,%eax
c0105cc4:	74 24                	je     c0105cea <check_boot_pgdir+0x2f9>
c0105cc6:	c7 44 24 0c 04 a0 10 	movl   $0xc010a004,0xc(%esp)
c0105ccd:	c0 
c0105cce:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105cd5:	c0 
c0105cd6:	c7 44 24 04 60 02 00 	movl   $0x260,0x4(%esp)
c0105cdd:	00 
c0105cde:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105ce5:	e8 ce af ff ff       	call   c0100cb8 <__panic>

    *(char *)(page2kva(p) + 0x100) = '\0';
c0105cea:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105ced:	89 04 24             	mov    %eax,(%esp)
c0105cf0:	e8 b4 e7 ff ff       	call   c01044a9 <page2kva>
c0105cf5:	05 00 01 00 00       	add    $0x100,%eax
c0105cfa:	c6 00 00             	movb   $0x0,(%eax)
    assert(strlen((const char *)0x100) == 0);
c0105cfd:	c7 04 24 00 01 00 00 	movl   $0x100,(%esp)
c0105d04:	e8 9f 2c 00 00       	call   c01089a8 <strlen>
c0105d09:	85 c0                	test   %eax,%eax
c0105d0b:	74 24                	je     c0105d31 <check_boot_pgdir+0x340>
c0105d0d:	c7 44 24 0c 3c a0 10 	movl   $0xc010a03c,0xc(%esp)
c0105d14:	c0 
c0105d15:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0105d1c:	c0 
c0105d1d:	c7 44 24 04 63 02 00 	movl   $0x263,0x4(%esp)
c0105d24:	00 
c0105d25:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0105d2c:	e8 87 af ff ff       	call   c0100cb8 <__panic>

    free_page(p);
c0105d31:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d38:	00 
c0105d39:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105d3c:	89 04 24             	mov    %eax,(%esp)
c0105d3f:	e8 ce ea ff ff       	call   c0104812 <free_pages>
    free_page(pde2page(boot_pgdir[0]));
c0105d44:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105d49:	8b 00                	mov    (%eax),%eax
c0105d4b:	89 04 24             	mov    %eax,(%esp)
c0105d4e:	e8 32 e8 ff ff       	call   c0104585 <pde2page>
c0105d53:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0105d5a:	00 
c0105d5b:	89 04 24             	mov    %eax,(%esp)
c0105d5e:	e8 af ea ff ff       	call   c0104812 <free_pages>
    boot_pgdir[0] = 0;
c0105d63:	a1 24 1a 12 c0       	mov    0xc0121a24,%eax
c0105d68:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    cprintf("check_boot_pgdir() succeeded!\n");
c0105d6e:	c7 04 24 60 a0 10 c0 	movl   $0xc010a060,(%esp)
c0105d75:	e8 dd a5 ff ff       	call   c0100357 <cprintf>
}
c0105d7a:	c9                   	leave  
c0105d7b:	c3                   	ret    

c0105d7c <perm2str>:

//perm2str - use string 'u,r,w,-' to present the permission
static const char *
perm2str(int perm) {
c0105d7c:	55                   	push   %ebp
c0105d7d:	89 e5                	mov    %esp,%ebp
    static char str[4];
    str[0] = (perm & PTE_U) ? 'u' : '-';
c0105d7f:	8b 45 08             	mov    0x8(%ebp),%eax
c0105d82:	83 e0 04             	and    $0x4,%eax
c0105d85:	85 c0                	test   %eax,%eax
c0105d87:	74 07                	je     c0105d90 <perm2str+0x14>
c0105d89:	b8 75 00 00 00       	mov    $0x75,%eax
c0105d8e:	eb 05                	jmp    c0105d95 <perm2str+0x19>
c0105d90:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105d95:	a2 a8 1a 12 c0       	mov    %al,0xc0121aa8
    str[1] = 'r';
c0105d9a:	c6 05 a9 1a 12 c0 72 	movb   $0x72,0xc0121aa9
    str[2] = (perm & PTE_W) ? 'w' : '-';
c0105da1:	8b 45 08             	mov    0x8(%ebp),%eax
c0105da4:	83 e0 02             	and    $0x2,%eax
c0105da7:	85 c0                	test   %eax,%eax
c0105da9:	74 07                	je     c0105db2 <perm2str+0x36>
c0105dab:	b8 77 00 00 00       	mov    $0x77,%eax
c0105db0:	eb 05                	jmp    c0105db7 <perm2str+0x3b>
c0105db2:	b8 2d 00 00 00       	mov    $0x2d,%eax
c0105db7:	a2 aa 1a 12 c0       	mov    %al,0xc0121aaa
    str[3] = '\0';
c0105dbc:	c6 05 ab 1a 12 c0 00 	movb   $0x0,0xc0121aab
    return str;
c0105dc3:	b8 a8 1a 12 c0       	mov    $0xc0121aa8,%eax
}
c0105dc8:	5d                   	pop    %ebp
c0105dc9:	c3                   	ret    

c0105dca <get_pgtable_items>:
//  table:       the beginning addr of table
//  left_store:  the pointer of the high side of table's next range
//  right_store: the pointer of the low side of table's next range
// return value: 0 - not a invalid item range, perm - a valid item range with perm permission 
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
c0105dca:	55                   	push   %ebp
c0105dcb:	89 e5                	mov    %esp,%ebp
c0105dcd:	83 ec 10             	sub    $0x10,%esp
    if (start >= right) {
c0105dd0:	8b 45 10             	mov    0x10(%ebp),%eax
c0105dd3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105dd6:	72 0e                	jb     c0105de6 <get_pgtable_items+0x1c>
        return 0;
c0105dd8:	b8 00 00 00 00       	mov    $0x0,%eax
c0105ddd:	e9 86 00 00 00       	jmp    c0105e68 <get_pgtable_items+0x9e>
    }
    while (start < right && !(table[start] & PTE_P)) {
        start ++;
c0105de2:	83 45 10 01          	addl   $0x1,0x10(%ebp)
static int
get_pgtable_items(size_t left, size_t right, size_t start, uintptr_t *table, size_t *left_store, size_t *right_store) {
    if (start >= right) {
        return 0;
    }
    while (start < right && !(table[start] & PTE_P)) {
c0105de6:	8b 45 10             	mov    0x10(%ebp),%eax
c0105de9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105dec:	73 12                	jae    c0105e00 <get_pgtable_items+0x36>
c0105dee:	8b 45 10             	mov    0x10(%ebp),%eax
c0105df1:	c1 e0 02             	shl    $0x2,%eax
c0105df4:	03 45 14             	add    0x14(%ebp),%eax
c0105df7:	8b 00                	mov    (%eax),%eax
c0105df9:	83 e0 01             	and    $0x1,%eax
c0105dfc:	85 c0                	test   %eax,%eax
c0105dfe:	74 e2                	je     c0105de2 <get_pgtable_items+0x18>
        start ++;
    }
    if (start < right) {
c0105e00:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e03:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105e06:	73 5b                	jae    c0105e63 <get_pgtable_items+0x99>
        if (left_store != NULL) {
c0105e08:	83 7d 18 00          	cmpl   $0x0,0x18(%ebp)
c0105e0c:	74 08                	je     c0105e16 <get_pgtable_items+0x4c>
            *left_store = start;
c0105e0e:	8b 45 18             	mov    0x18(%ebp),%eax
c0105e11:	8b 55 10             	mov    0x10(%ebp),%edx
c0105e14:	89 10                	mov    %edx,(%eax)
        }
        int perm = (table[start ++] & PTE_USER);
c0105e16:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e19:	c1 e0 02             	shl    $0x2,%eax
c0105e1c:	03 45 14             	add    0x14(%ebp),%eax
c0105e1f:	8b 00                	mov    (%eax),%eax
c0105e21:	83 e0 07             	and    $0x7,%eax
c0105e24:	89 45 fc             	mov    %eax,-0x4(%ebp)
c0105e27:	83 45 10 01          	addl   $0x1,0x10(%ebp)
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105e2b:	eb 04                	jmp    c0105e31 <get_pgtable_items+0x67>
            start ++;
c0105e2d:	83 45 10 01          	addl   $0x1,0x10(%ebp)
    if (start < right) {
        if (left_store != NULL) {
            *left_store = start;
        }
        int perm = (table[start ++] & PTE_USER);
        while (start < right && (table[start] & PTE_USER) == perm) {
c0105e31:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e34:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0105e37:	73 17                	jae    c0105e50 <get_pgtable_items+0x86>
c0105e39:	8b 45 10             	mov    0x10(%ebp),%eax
c0105e3c:	c1 e0 02             	shl    $0x2,%eax
c0105e3f:	03 45 14             	add    0x14(%ebp),%eax
c0105e42:	8b 00                	mov    (%eax),%eax
c0105e44:	89 c2                	mov    %eax,%edx
c0105e46:	83 e2 07             	and    $0x7,%edx
c0105e49:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e4c:	39 c2                	cmp    %eax,%edx
c0105e4e:	74 dd                	je     c0105e2d <get_pgtable_items+0x63>
            start ++;
        }
        if (right_store != NULL) {
c0105e50:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c0105e54:	74 08                	je     c0105e5e <get_pgtable_items+0x94>
            *right_store = start;
c0105e56:	8b 45 1c             	mov    0x1c(%ebp),%eax
c0105e59:	8b 55 10             	mov    0x10(%ebp),%edx
c0105e5c:	89 10                	mov    %edx,(%eax)
        }
        return perm;
c0105e5e:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0105e61:	eb 05                	jmp    c0105e68 <get_pgtable_items+0x9e>
    }
    return 0;
c0105e63:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0105e68:	c9                   	leave  
c0105e69:	c3                   	ret    

c0105e6a <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
c0105e6a:	55                   	push   %ebp
c0105e6b:	89 e5                	mov    %esp,%ebp
c0105e6d:	57                   	push   %edi
c0105e6e:	56                   	push   %esi
c0105e6f:	53                   	push   %ebx
c0105e70:	83 ec 5c             	sub    $0x5c,%esp
    cprintf("-------------------- BEGIN --------------------\n");
c0105e73:	c7 04 24 80 a0 10 c0 	movl   $0xc010a080,(%esp)
c0105e7a:	e8 d8 a4 ff ff       	call   c0100357 <cprintf>
    size_t left, right = 0, perm;
c0105e7f:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105e86:	e9 0b 01 00 00       	jmp    c0105f96 <print_pgdir+0x12c>
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105e8b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105e8e:	89 04 24             	mov    %eax,(%esp)
c0105e91:	e8 e6 fe ff ff       	call   c0105d7c <perm2str>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
c0105e96:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105e99:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105e9c:	89 cb                	mov    %ecx,%ebx
c0105e9e:	29 d3                	sub    %edx,%ebx
c0105ea0:	89 da                	mov    %ebx,%edx
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
c0105ea2:	89 d6                	mov    %edx,%esi
c0105ea4:	c1 e6 16             	shl    $0x16,%esi
c0105ea7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0105eaa:	89 d3                	mov    %edx,%ebx
c0105eac:	c1 e3 16             	shl    $0x16,%ebx
c0105eaf:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105eb2:	89 d1                	mov    %edx,%ecx
c0105eb4:	c1 e1 16             	shl    $0x16,%ecx
c0105eb7:	8b 7d dc             	mov    -0x24(%ebp),%edi
c0105eba:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c0105ebd:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0105ec0:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c0105ec3:	29 d7                	sub    %edx,%edi
c0105ec5:	89 fa                	mov    %edi,%edx
c0105ec7:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105ecb:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105ecf:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105ed3:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105ed7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105edb:	c7 04 24 b1 a0 10 c0 	movl   $0xc010a0b1,(%esp)
c0105ee2:	e8 70 a4 ff ff       	call   c0100357 <cprintf>
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
c0105ee7:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0105eea:	c1 e0 0a             	shl    $0xa,%eax
c0105eed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105ef0:	eb 5c                	jmp    c0105f4e <print_pgdir+0xe4>
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105ef2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0105ef5:	89 04 24             	mov    %eax,(%esp)
c0105ef8:	e8 7f fe ff ff       	call   c0105d7c <perm2str>
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
c0105efd:	8b 4d d4             	mov    -0x2c(%ebp),%ecx
c0105f00:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105f03:	89 cb                	mov    %ecx,%ebx
c0105f05:	29 d3                	sub    %edx,%ebx
c0105f07:	89 da                	mov    %ebx,%edx
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
c0105f09:	89 d6                	mov    %edx,%esi
c0105f0b:	c1 e6 0c             	shl    $0xc,%esi
c0105f0e:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c0105f11:	89 d3                	mov    %edx,%ebx
c0105f13:	c1 e3 0c             	shl    $0xc,%ebx
c0105f16:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105f19:	89 d1                	mov    %edx,%ecx
c0105f1b:	c1 e1 0c             	shl    $0xc,%ecx
c0105f1e:	8b 7d d4             	mov    -0x2c(%ebp),%edi
c0105f21:	89 7d c4             	mov    %edi,-0x3c(%ebp)
c0105f24:	8b 55 d8             	mov    -0x28(%ebp),%edx
c0105f27:	8b 7d c4             	mov    -0x3c(%ebp),%edi
c0105f2a:	29 d7                	sub    %edx,%edi
c0105f2c:	89 fa                	mov    %edi,%edx
c0105f2e:	89 44 24 14          	mov    %eax,0x14(%esp)
c0105f32:	89 74 24 10          	mov    %esi,0x10(%esp)
c0105f36:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c0105f3a:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0105f3e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0105f42:	c7 04 24 d0 a0 10 c0 	movl   $0xc010a0d0,(%esp)
c0105f49:	e8 09 a4 ff ff       	call   c0100357 <cprintf>
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
        cprintf("PDE(%03x) %08x-%08x %08x %s\n", right - left,
                left * PTSIZE, right * PTSIZE, (right - left) * PTSIZE, perm2str(perm));
        size_t l, r = left * NPTEENTRY;
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
c0105f4e:	8b 15 48 9b 10 c0    	mov    0xc0109b48,%edx
c0105f54:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c0105f57:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0105f5a:	89 ce                	mov    %ecx,%esi
c0105f5c:	c1 e6 0a             	shl    $0xa,%esi
c0105f5f:	8b 4d e0             	mov    -0x20(%ebp),%ecx
c0105f62:	89 cb                	mov    %ecx,%ebx
c0105f64:	c1 e3 0a             	shl    $0xa,%ebx
c0105f67:	8d 4d d4             	lea    -0x2c(%ebp),%ecx
c0105f6a:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105f6e:	8d 4d d8             	lea    -0x28(%ebp),%ecx
c0105f71:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105f75:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105f79:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105f7d:	89 74 24 04          	mov    %esi,0x4(%esp)
c0105f81:	89 1c 24             	mov    %ebx,(%esp)
c0105f84:	e8 41 fe ff ff       	call   c0105dca <get_pgtable_items>
c0105f89:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105f8c:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105f90:	0f 85 5c ff ff ff    	jne    c0105ef2 <print_pgdir+0x88>
//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
    cprintf("-------------------- BEGIN --------------------\n");
    size_t left, right = 0, perm;
    while ((perm = get_pgtable_items(0, NPDEENTRY, right, vpd, &left, &right)) != 0) {
c0105f96:	8b 15 4c 9b 10 c0    	mov    0xc0109b4c,%edx
c0105f9c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0105f9f:	8d 4d dc             	lea    -0x24(%ebp),%ecx
c0105fa2:	89 4c 24 14          	mov    %ecx,0x14(%esp)
c0105fa6:	8d 4d e0             	lea    -0x20(%ebp),%ecx
c0105fa9:	89 4c 24 10          	mov    %ecx,0x10(%esp)
c0105fad:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0105fb1:	89 44 24 08          	mov    %eax,0x8(%esp)
c0105fb5:	c7 44 24 04 00 04 00 	movl   $0x400,0x4(%esp)
c0105fbc:	00 
c0105fbd:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0105fc4:	e8 01 fe ff ff       	call   c0105dca <get_pgtable_items>
c0105fc9:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0105fcc:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0105fd0:	0f 85 b5 fe ff ff    	jne    c0105e8b <print_pgdir+0x21>
        while ((perm = get_pgtable_items(left * NPTEENTRY, right * NPTEENTRY, r, vpt, &l, &r)) != 0) {
            cprintf("  |-- PTE(%05x) %08x-%08x %08x %s\n", r - l,
                    l * PGSIZE, r * PGSIZE, (r - l) * PGSIZE, perm2str(perm));
        }
    }
    cprintf("--------------------- END ---------------------\n");
c0105fd6:	c7 04 24 f4 a0 10 c0 	movl   $0xc010a0f4,(%esp)
c0105fdd:	e8 75 a3 ff ff       	call   c0100357 <cprintf>
}
c0105fe2:	83 c4 5c             	add    $0x5c,%esp
c0105fe5:	5b                   	pop    %ebx
c0105fe6:	5e                   	pop    %esi
c0105fe7:	5f                   	pop    %edi
c0105fe8:	5d                   	pop    %ebp
c0105fe9:	c3                   	ret    

c0105fea <kmalloc>:

void *
kmalloc(size_t n) {
c0105fea:	55                   	push   %ebp
c0105feb:	89 e5                	mov    %esp,%ebp
c0105fed:	83 ec 28             	sub    $0x28,%esp
    void * ptr=NULL;
c0105ff0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    struct Page *base=NULL;
c0105ff7:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    assert(n > 0 && n < 1024*0124);
c0105ffe:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0106002:	74 09                	je     c010600d <kmalloc+0x23>
c0106004:	81 7d 08 ff 4f 01 00 	cmpl   $0x14fff,0x8(%ebp)
c010600b:	76 24                	jbe    c0106031 <kmalloc+0x47>
c010600d:	c7 44 24 0c 25 a1 10 	movl   $0xc010a125,0xc(%esp)
c0106014:	c0 
c0106015:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c010601c:	c0 
c010601d:	c7 44 24 04 af 02 00 	movl   $0x2af,0x4(%esp)
c0106024:	00 
c0106025:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c010602c:	e8 87 ac ff ff       	call   c0100cb8 <__panic>
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c0106031:	8b 45 08             	mov    0x8(%ebp),%eax
c0106034:	05 ff 0f 00 00       	add    $0xfff,%eax
c0106039:	c1 e8 0c             	shr    $0xc,%eax
c010603c:	89 45 ec             	mov    %eax,-0x14(%ebp)
    base = alloc_pages(num_pages);
c010603f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106042:	89 04 24             	mov    %eax,(%esp)
c0106045:	e8 5d e7 ff ff       	call   c01047a7 <alloc_pages>
c010604a:	89 45 f0             	mov    %eax,-0x10(%ebp)
    assert(base != NULL);
c010604d:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106051:	75 24                	jne    c0106077 <kmalloc+0x8d>
c0106053:	c7 44 24 0c 3c a1 10 	movl   $0xc010a13c,0xc(%esp)
c010605a:	c0 
c010605b:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c0106062:	c0 
c0106063:	c7 44 24 04 b2 02 00 	movl   $0x2b2,0x4(%esp)
c010606a:	00 
c010606b:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c0106072:	e8 41 ac ff ff       	call   c0100cb8 <__panic>
    ptr=page2kva(base);
c0106077:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010607a:	89 04 24             	mov    %eax,(%esp)
c010607d:	e8 27 e4 ff ff       	call   c01044a9 <page2kva>
c0106082:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ptr;
c0106085:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106088:	c9                   	leave  
c0106089:	c3                   	ret    

c010608a <kfree>:

void 
kfree(void *ptr, size_t n) {
c010608a:	55                   	push   %ebp
c010608b:	89 e5                	mov    %esp,%ebp
c010608d:	83 ec 28             	sub    $0x28,%esp
    assert(n > 0 && n < 1024*0124);
c0106090:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0106094:	74 09                	je     c010609f <kfree+0x15>
c0106096:	81 7d 0c ff 4f 01 00 	cmpl   $0x14fff,0xc(%ebp)
c010609d:	76 24                	jbe    c01060c3 <kfree+0x39>
c010609f:	c7 44 24 0c 25 a1 10 	movl   $0xc010a125,0xc(%esp)
c01060a6:	c0 
c01060a7:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01060ae:	c0 
c01060af:	c7 44 24 04 b9 02 00 	movl   $0x2b9,0x4(%esp)
c01060b6:	00 
c01060b7:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01060be:	e8 f5 ab ff ff       	call   c0100cb8 <__panic>
    assert(ptr != NULL);
c01060c3:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c01060c7:	75 24                	jne    c01060ed <kfree+0x63>
c01060c9:	c7 44 24 0c 49 a1 10 	movl   $0xc010a149,0xc(%esp)
c01060d0:	c0 
c01060d1:	c7 44 24 08 c9 9b 10 	movl   $0xc0109bc9,0x8(%esp)
c01060d8:	c0 
c01060d9:	c7 44 24 04 ba 02 00 	movl   $0x2ba,0x4(%esp)
c01060e0:	00 
c01060e1:	c7 04 24 a4 9b 10 c0 	movl   $0xc0109ba4,(%esp)
c01060e8:	e8 cb ab ff ff       	call   c0100cb8 <__panic>
    struct Page *base=NULL;
c01060ed:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    int num_pages=(n+PGSIZE-1)/PGSIZE;
c01060f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01060f7:	05 ff 0f 00 00       	add    $0xfff,%eax
c01060fc:	c1 e8 0c             	shr    $0xc,%eax
c01060ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
    base = kva2page(ptr);
c0106102:	8b 45 08             	mov    0x8(%ebp),%eax
c0106105:	89 04 24             	mov    %eax,(%esp)
c0106108:	e8 f0 e3 ff ff       	call   c01044fd <kva2page>
c010610d:	89 45 f4             	mov    %eax,-0xc(%ebp)
    free_pages(base, num_pages);
c0106110:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106113:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106117:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010611a:	89 04 24             	mov    %eax,(%esp)
c010611d:	e8 f0 e6 ff ff       	call   c0104812 <free_pages>
}
c0106122:	c9                   	leave  
c0106123:	c3                   	ret    

c0106124 <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c0106124:	55                   	push   %ebp
c0106125:	89 e5                	mov    %esp,%ebp
c0106127:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c010612a:	8b 45 08             	mov    0x8(%ebp),%eax
c010612d:	89 c2                	mov    %eax,%edx
c010612f:	c1 ea 0c             	shr    $0xc,%edx
c0106132:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c0106137:	39 c2                	cmp    %eax,%edx
c0106139:	72 1c                	jb     c0106157 <pa2page+0x33>
        panic("pa2page called with invalid pa");
c010613b:	c7 44 24 08 58 a1 10 	movl   $0xc010a158,0x8(%esp)
c0106142:	c0 
c0106143:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c010614a:	00 
c010614b:	c7 04 24 77 a1 10 c0 	movl   $0xc010a177,(%esp)
c0106152:	e8 61 ab ff ff       	call   c0100cb8 <__panic>
    }
    return &pages[PPN(pa)];
c0106157:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c010615c:	8b 55 08             	mov    0x8(%ebp),%edx
c010615f:	c1 ea 0c             	shr    $0xc,%edx
c0106162:	c1 e2 05             	shl    $0x5,%edx
c0106165:	01 d0                	add    %edx,%eax
}
c0106167:	c9                   	leave  
c0106168:	c3                   	ret    

c0106169 <pte2page>:
kva2page(void *kva) {
    return pa2page(PADDR(kva));
}

static inline struct Page *
pte2page(pte_t pte) {
c0106169:	55                   	push   %ebp
c010616a:	89 e5                	mov    %esp,%ebp
c010616c:	83 ec 18             	sub    $0x18,%esp
    if (!(pte & PTE_P)) {
c010616f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106172:	83 e0 01             	and    $0x1,%eax
c0106175:	85 c0                	test   %eax,%eax
c0106177:	75 1c                	jne    c0106195 <pte2page+0x2c>
        panic("pte2page called with invalid pte");
c0106179:	c7 44 24 08 88 a1 10 	movl   $0xc010a188,0x8(%esp)
c0106180:	c0 
c0106181:	c7 44 24 04 6d 00 00 	movl   $0x6d,0x4(%esp)
c0106188:	00 
c0106189:	c7 04 24 77 a1 10 c0 	movl   $0xc010a177,(%esp)
c0106190:	e8 23 ab ff ff       	call   c0100cb8 <__panic>
    }
    return pa2page(PTE_ADDR(pte));
c0106195:	8b 45 08             	mov    0x8(%ebp),%eax
c0106198:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c010619d:	89 04 24             	mov    %eax,(%esp)
c01061a0:	e8 7f ff ff ff       	call   c0106124 <pa2page>
}
c01061a5:	c9                   	leave  
c01061a6:	c3                   	ret    

c01061a7 <swap_init>:

static void check_swap(void);

int
swap_init(void)
{
c01061a7:	55                   	push   %ebp
c01061a8:	89 e5                	mov    %esp,%ebp
c01061aa:	83 ec 28             	sub    $0x28,%esp
     swapfs_init();
c01061ad:	e8 fe 1e 00 00       	call   c01080b0 <swapfs_init>

     if (!(1024 <= max_swap_offset && max_swap_offset < MAX_SWAP_OFFSET_LIMIT))
c01061b2:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c01061b7:	3d ff 03 00 00       	cmp    $0x3ff,%eax
c01061bc:	76 0c                	jbe    c01061ca <swap_init+0x23>
c01061be:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c01061c3:	3d ff ff ff 00       	cmp    $0xffffff,%eax
c01061c8:	76 25                	jbe    c01061ef <swap_init+0x48>
     {
          panic("bad max_swap_offset %08x.\n", max_swap_offset);
c01061ca:	a1 7c 1b 12 c0       	mov    0xc0121b7c,%eax
c01061cf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01061d3:	c7 44 24 08 a9 a1 10 	movl   $0xc010a1a9,0x8(%esp)
c01061da:	c0 
c01061db:	c7 44 24 04 25 00 00 	movl   $0x25,0x4(%esp)
c01061e2:	00 
c01061e3:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c01061ea:	e8 c9 aa ff ff       	call   c0100cb8 <__panic>
     }
     

     sm = &swap_manager_fifo;
c01061ef:	c7 05 b4 1a 12 c0 40 	movl   $0xc0120a40,0xc0121ab4
c01061f6:	0a 12 c0 
     int r = sm->init();
c01061f9:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01061fe:	8b 40 04             	mov    0x4(%eax),%eax
c0106201:	ff d0                	call   *%eax
c0106203:	89 45 f4             	mov    %eax,-0xc(%ebp)
     
     if (r == 0)
c0106206:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010620a:	75 26                	jne    c0106232 <swap_init+0x8b>
     {
          swap_init_ok = 1;
c010620c:	c7 05 ac 1a 12 c0 01 	movl   $0x1,0xc0121aac
c0106213:	00 00 00 
          cprintf("SWAP: manager = %s\n", sm->name);
c0106216:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010621b:	8b 00                	mov    (%eax),%eax
c010621d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106221:	c7 04 24 d3 a1 10 c0 	movl   $0xc010a1d3,(%esp)
c0106228:	e8 2a a1 ff ff       	call   c0100357 <cprintf>
          check_swap();
c010622d:	e8 a4 04 00 00       	call   c01066d6 <check_swap>
     }

     return r;
c0106232:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0106235:	c9                   	leave  
c0106236:	c3                   	ret    

c0106237 <swap_init_mm>:

int
swap_init_mm(struct mm_struct *mm)
{
c0106237:	55                   	push   %ebp
c0106238:	89 e5                	mov    %esp,%ebp
c010623a:	83 ec 18             	sub    $0x18,%esp
     return sm->init_mm(mm);
c010623d:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106242:	8b 50 08             	mov    0x8(%eax),%edx
c0106245:	8b 45 08             	mov    0x8(%ebp),%eax
c0106248:	89 04 24             	mov    %eax,(%esp)
c010624b:	ff d2                	call   *%edx
}
c010624d:	c9                   	leave  
c010624e:	c3                   	ret    

c010624f <swap_tick_event>:

int
swap_tick_event(struct mm_struct *mm)
{
c010624f:	55                   	push   %ebp
c0106250:	89 e5                	mov    %esp,%ebp
c0106252:	83 ec 18             	sub    $0x18,%esp
     return sm->tick_event(mm);
c0106255:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010625a:	8b 50 0c             	mov    0xc(%eax),%edx
c010625d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106260:	89 04 24             	mov    %eax,(%esp)
c0106263:	ff d2                	call   *%edx
}
c0106265:	c9                   	leave  
c0106266:	c3                   	ret    

c0106267 <swap_map_swappable>:

int
swap_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106267:	55                   	push   %ebp
c0106268:	89 e5                	mov    %esp,%ebp
c010626a:	83 ec 18             	sub    $0x18,%esp
     return sm->map_swappable(mm, addr, page, swap_in);
c010626d:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106272:	8b 50 10             	mov    0x10(%eax),%edx
c0106275:	8b 45 14             	mov    0x14(%ebp),%eax
c0106278:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010627c:	8b 45 10             	mov    0x10(%ebp),%eax
c010627f:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106283:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106286:	89 44 24 04          	mov    %eax,0x4(%esp)
c010628a:	8b 45 08             	mov    0x8(%ebp),%eax
c010628d:	89 04 24             	mov    %eax,(%esp)
c0106290:	ff d2                	call   *%edx
}
c0106292:	c9                   	leave  
c0106293:	c3                   	ret    

c0106294 <swap_set_unswappable>:

int
swap_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0106294:	55                   	push   %ebp
c0106295:	89 e5                	mov    %esp,%ebp
c0106297:	83 ec 18             	sub    $0x18,%esp
     return sm->set_unswappable(mm, addr);
c010629a:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c010629f:	8b 50 14             	mov    0x14(%eax),%edx
c01062a2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01062a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01062ac:	89 04 24             	mov    %eax,(%esp)
c01062af:	ff d2                	call   *%edx
}
c01062b1:	c9                   	leave  
c01062b2:	c3                   	ret    

c01062b3 <swap_out>:

volatile unsigned int swap_out_num=0;

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
c01062b3:	55                   	push   %ebp
c01062b4:	89 e5                	mov    %esp,%ebp
c01062b6:	83 ec 38             	sub    $0x38,%esp
     int i;
     for (i = 0; i != n; ++ i)
c01062b9:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01062c0:	e9 5a 01 00 00       	jmp    c010641f <swap_out+0x16c>
     {
          uintptr_t v;
          //struct Page **ptr_page=NULL;
          struct Page *page;
          // cprintf("i %d, SWAP: call swap_out_victim\n",i);
          int r = sm->swap_out_victim(mm, &page, in_tick);
c01062c5:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01062ca:	8b 50 18             	mov    0x18(%eax),%edx
c01062cd:	8b 45 10             	mov    0x10(%ebp),%eax
c01062d0:	89 44 24 08          	mov    %eax,0x8(%esp)
c01062d4:	8d 45 e4             	lea    -0x1c(%ebp),%eax
c01062d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062db:	8b 45 08             	mov    0x8(%ebp),%eax
c01062de:	89 04 24             	mov    %eax,(%esp)
c01062e1:	ff d2                	call   *%edx
c01062e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
          if (r != 0) {
c01062e6:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c01062ea:	74 18                	je     c0106304 <swap_out+0x51>
                    cprintf("i %d, swap_out: call swap_out_victim failed\n",i);
c01062ec:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01062ef:	89 44 24 04          	mov    %eax,0x4(%esp)
c01062f3:	c7 04 24 e8 a1 10 c0 	movl   $0xc010a1e8,(%esp)
c01062fa:	e8 58 a0 ff ff       	call   c0100357 <cprintf>
                  break;
c01062ff:	e9 27 01 00 00       	jmp    c010642b <swap_out+0x178>
          }          
          //assert(!PageReserved(page));

          //cprintf("SWAP: choose victim page 0x%08x\n", page);
          
          v=page->pra_vaddr; 
c0106304:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106307:	8b 40 1c             	mov    0x1c(%eax),%eax
c010630a:	89 45 ec             	mov    %eax,-0x14(%ebp)
          pte_t *ptep = get_pte(mm->pgdir, v, 0);
c010630d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106310:	8b 40 0c             	mov    0xc(%eax),%eax
c0106313:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010631a:	00 
c010631b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010631e:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106322:	89 04 24             	mov    %eax,(%esp)
c0106325:	e8 de eb ff ff       	call   c0104f08 <get_pte>
c010632a:	89 45 e8             	mov    %eax,-0x18(%ebp)
          assert((*ptep & PTE_P) != 0);
c010632d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106330:	8b 00                	mov    (%eax),%eax
c0106332:	83 e0 01             	and    $0x1,%eax
c0106335:	85 c0                	test   %eax,%eax
c0106337:	75 24                	jne    c010635d <swap_out+0xaa>
c0106339:	c7 44 24 0c 15 a2 10 	movl   $0xc010a215,0xc(%esp)
c0106340:	c0 
c0106341:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106348:	c0 
c0106349:	c7 44 24 04 65 00 00 	movl   $0x65,0x4(%esp)
c0106350:	00 
c0106351:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106358:	e8 5b a9 ff ff       	call   c0100cb8 <__panic>

          if (swapfs_write( (page->pra_vaddr/PGSIZE+1)<<8, page) != 0) {
c010635d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106360:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106363:	8b 52 1c             	mov    0x1c(%edx),%edx
c0106366:	c1 ea 0c             	shr    $0xc,%edx
c0106369:	83 c2 01             	add    $0x1,%edx
c010636c:	c1 e2 08             	shl    $0x8,%edx
c010636f:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106373:	89 14 24             	mov    %edx,(%esp)
c0106376:	e8 ef 1d 00 00       	call   c010816a <swapfs_write>
c010637b:	85 c0                	test   %eax,%eax
c010637d:	74 34                	je     c01063b3 <swap_out+0x100>
                    cprintf("SWAP: failed to save\n");
c010637f:	c7 04 24 3f a2 10 c0 	movl   $0xc010a23f,(%esp)
c0106386:	e8 cc 9f ff ff       	call   c0100357 <cprintf>
                    sm->map_swappable(mm, v, page, 0);
c010638b:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c0106390:	8b 50 10             	mov    0x10(%eax),%edx
c0106393:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106396:	c7 44 24 0c 00 00 00 	movl   $0x0,0xc(%esp)
c010639d:	00 
c010639e:	89 44 24 08          	mov    %eax,0x8(%esp)
c01063a2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01063a5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063a9:	8b 45 08             	mov    0x8(%ebp),%eax
c01063ac:	89 04 24             	mov    %eax,(%esp)
c01063af:	ff d2                	call   *%edx
                    continue;
c01063b1:	eb 68                	jmp    c010641b <swap_out+0x168>
          }
          else {
                    cprintf("swap_out: i %d, store page in vaddr 0x%x to disk swap entry %d\n", i, v, page->pra_vaddr/PGSIZE+1);
c01063b3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063b6:	8b 40 1c             	mov    0x1c(%eax),%eax
c01063b9:	c1 e8 0c             	shr    $0xc,%eax
c01063bc:	83 c0 01             	add    $0x1,%eax
c01063bf:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01063c3:	8b 45 ec             	mov    -0x14(%ebp),%eax
c01063c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01063ca:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01063cd:	89 44 24 04          	mov    %eax,0x4(%esp)
c01063d1:	c7 04 24 58 a2 10 c0 	movl   $0xc010a258,(%esp)
c01063d8:	e8 7a 9f ff ff       	call   c0100357 <cprintf>
                    *ptep = (page->pra_vaddr/PGSIZE+1)<<8;
c01063dd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063e0:	8b 40 1c             	mov    0x1c(%eax),%eax
c01063e3:	c1 e8 0c             	shr    $0xc,%eax
c01063e6:	83 c0 01             	add    $0x1,%eax
c01063e9:	89 c2                	mov    %eax,%edx
c01063eb:	c1 e2 08             	shl    $0x8,%edx
c01063ee:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01063f1:	89 10                	mov    %edx,(%eax)
                    free_page(page);
c01063f3:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01063f6:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c01063fd:	00 
c01063fe:	89 04 24             	mov    %eax,(%esp)
c0106401:	e8 0c e4 ff ff       	call   c0104812 <free_pages>
          }
          
          tlb_invalidate(mm->pgdir, v);
c0106406:	8b 45 08             	mov    0x8(%ebp),%eax
c0106409:	8b 40 0c             	mov    0xc(%eax),%eax
c010640c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010640f:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106413:	89 04 24             	mov    %eax,(%esp)
c0106416:	e8 f0 ed ff ff       	call   c010520b <tlb_invalidate>

int
swap_out(struct mm_struct *mm, int n, int in_tick)
{
     int i;
     for (i = 0; i != n; ++ i)
c010641b:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c010641f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106422:	3b 45 0c             	cmp    0xc(%ebp),%eax
c0106425:	0f 85 9a fe ff ff    	jne    c01062c5 <swap_out+0x12>
                    free_page(page);
          }
          
          tlb_invalidate(mm->pgdir, v);
     }
     return i;
c010642b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010642e:	c9                   	leave  
c010642f:	c3                   	ret    

c0106430 <swap_in>:

int
swap_in(struct mm_struct *mm, uintptr_t addr, struct Page **ptr_result)
{
c0106430:	55                   	push   %ebp
c0106431:	89 e5                	mov    %esp,%ebp
c0106433:	83 ec 28             	sub    $0x28,%esp
     struct Page *result = alloc_page();
c0106436:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c010643d:	e8 65 e3 ff ff       	call   c01047a7 <alloc_pages>
c0106442:	89 45 f4             	mov    %eax,-0xc(%ebp)
     assert(result!=NULL);
c0106445:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106449:	75 24                	jne    c010646f <swap_in+0x3f>
c010644b:	c7 44 24 0c 98 a2 10 	movl   $0xc010a298,0xc(%esp)
c0106452:	c0 
c0106453:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c010645a:	c0 
c010645b:	c7 44 24 04 7b 00 00 	movl   $0x7b,0x4(%esp)
c0106462:	00 
c0106463:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c010646a:	e8 49 a8 ff ff       	call   c0100cb8 <__panic>

     pte_t *ptep = get_pte(mm->pgdir, addr, 0);
c010646f:	8b 45 08             	mov    0x8(%ebp),%eax
c0106472:	8b 40 0c             	mov    0xc(%eax),%eax
c0106475:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c010647c:	00 
c010647d:	8b 55 0c             	mov    0xc(%ebp),%edx
c0106480:	89 54 24 04          	mov    %edx,0x4(%esp)
c0106484:	89 04 24             	mov    %eax,(%esp)
c0106487:	e8 7c ea ff ff       	call   c0104f08 <get_pte>
c010648c:	89 45 f0             	mov    %eax,-0x10(%ebp)
     // cprintf("SWAP: load ptep %x swap entry %d to vaddr 0x%08x, page %x, No %d\n", ptep, (*ptep)>>8, addr, result, (result-pages));
    
     int r;
     if ((r = swapfs_read((*ptep), result)) != 0)
c010648f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106492:	8b 00                	mov    (%eax),%eax
c0106494:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0106497:	89 54 24 04          	mov    %edx,0x4(%esp)
c010649b:	89 04 24             	mov    %eax,(%esp)
c010649e:	e8 55 1c 00 00       	call   c01080f8 <swapfs_read>
c01064a3:	89 45 ec             	mov    %eax,-0x14(%ebp)
c01064a6:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01064aa:	74 2a                	je     c01064d6 <swap_in+0xa6>
     {
        assert(r!=0);
c01064ac:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c01064b0:	75 24                	jne    c01064d6 <swap_in+0xa6>
c01064b2:	c7 44 24 0c a5 a2 10 	movl   $0xc010a2a5,0xc(%esp)
c01064b9:	c0 
c01064ba:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c01064c1:	c0 
c01064c2:	c7 44 24 04 83 00 00 	movl   $0x83,0x4(%esp)
c01064c9:	00 
c01064ca:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c01064d1:	e8 e2 a7 ff ff       	call   c0100cb8 <__panic>
     }
     cprintf("swap_in: load disk swap entry %d with swap_page in vadr 0x%x\n", (*ptep)>>8, addr);
c01064d6:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01064d9:	8b 00                	mov    (%eax),%eax
c01064db:	89 c2                	mov    %eax,%edx
c01064dd:	c1 ea 08             	shr    $0x8,%edx
c01064e0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01064e3:	89 44 24 08          	mov    %eax,0x8(%esp)
c01064e7:	89 54 24 04          	mov    %edx,0x4(%esp)
c01064eb:	c7 04 24 ac a2 10 c0 	movl   $0xc010a2ac,(%esp)
c01064f2:	e8 60 9e ff ff       	call   c0100357 <cprintf>
     *ptr_result=result;
c01064f7:	8b 45 10             	mov    0x10(%ebp),%eax
c01064fa:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01064fd:	89 10                	mov    %edx,(%eax)
     return 0;
c01064ff:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106504:	c9                   	leave  
c0106505:	c3                   	ret    

c0106506 <check_content_set>:



static inline void
check_content_set(void)
{
c0106506:	55                   	push   %ebp
c0106507:	89 e5                	mov    %esp,%ebp
c0106509:	83 ec 18             	sub    $0x18,%esp
     *(unsigned char *)0x1000 = 0x0a;
c010650c:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106511:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c0106514:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106519:	83 f8 01             	cmp    $0x1,%eax
c010651c:	74 24                	je     c0106542 <check_content_set+0x3c>
c010651e:	c7 44 24 0c ea a2 10 	movl   $0xc010a2ea,0xc(%esp)
c0106525:	c0 
c0106526:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c010652d:	c0 
c010652e:	c7 44 24 04 90 00 00 	movl   $0x90,0x4(%esp)
c0106535:	00 
c0106536:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c010653d:	e8 76 a7 ff ff       	call   c0100cb8 <__panic>
     *(unsigned char *)0x1010 = 0x0a;
c0106542:	b8 10 10 00 00       	mov    $0x1010,%eax
c0106547:	c6 00 0a             	movb   $0xa,(%eax)
     assert(pgfault_num==1);
c010654a:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010654f:	83 f8 01             	cmp    $0x1,%eax
c0106552:	74 24                	je     c0106578 <check_content_set+0x72>
c0106554:	c7 44 24 0c ea a2 10 	movl   $0xc010a2ea,0xc(%esp)
c010655b:	c0 
c010655c:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106563:	c0 
c0106564:	c7 44 24 04 92 00 00 	movl   $0x92,0x4(%esp)
c010656b:	00 
c010656c:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106573:	e8 40 a7 ff ff       	call   c0100cb8 <__panic>
     *(unsigned char *)0x2000 = 0x0b;
c0106578:	b8 00 20 00 00       	mov    $0x2000,%eax
c010657d:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c0106580:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106585:	83 f8 02             	cmp    $0x2,%eax
c0106588:	74 24                	je     c01065ae <check_content_set+0xa8>
c010658a:	c7 44 24 0c f9 a2 10 	movl   $0xc010a2f9,0xc(%esp)
c0106591:	c0 
c0106592:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106599:	c0 
c010659a:	c7 44 24 04 94 00 00 	movl   $0x94,0x4(%esp)
c01065a1:	00 
c01065a2:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c01065a9:	e8 0a a7 ff ff       	call   c0100cb8 <__panic>
     *(unsigned char *)0x2010 = 0x0b;
c01065ae:	b8 10 20 00 00       	mov    $0x2010,%eax
c01065b3:	c6 00 0b             	movb   $0xb,(%eax)
     assert(pgfault_num==2);
c01065b6:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01065bb:	83 f8 02             	cmp    $0x2,%eax
c01065be:	74 24                	je     c01065e4 <check_content_set+0xde>
c01065c0:	c7 44 24 0c f9 a2 10 	movl   $0xc010a2f9,0xc(%esp)
c01065c7:	c0 
c01065c8:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c01065cf:	c0 
c01065d0:	c7 44 24 04 96 00 00 	movl   $0x96,0x4(%esp)
c01065d7:	00 
c01065d8:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c01065df:	e8 d4 a6 ff ff       	call   c0100cb8 <__panic>
     *(unsigned char *)0x3000 = 0x0c;
c01065e4:	b8 00 30 00 00       	mov    $0x3000,%eax
c01065e9:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c01065ec:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01065f1:	83 f8 03             	cmp    $0x3,%eax
c01065f4:	74 24                	je     c010661a <check_content_set+0x114>
c01065f6:	c7 44 24 0c 08 a3 10 	movl   $0xc010a308,0xc(%esp)
c01065fd:	c0 
c01065fe:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106605:	c0 
c0106606:	c7 44 24 04 98 00 00 	movl   $0x98,0x4(%esp)
c010660d:	00 
c010660e:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106615:	e8 9e a6 ff ff       	call   c0100cb8 <__panic>
     *(unsigned char *)0x3010 = 0x0c;
c010661a:	b8 10 30 00 00       	mov    $0x3010,%eax
c010661f:	c6 00 0c             	movb   $0xc,(%eax)
     assert(pgfault_num==3);
c0106622:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106627:	83 f8 03             	cmp    $0x3,%eax
c010662a:	74 24                	je     c0106650 <check_content_set+0x14a>
c010662c:	c7 44 24 0c 08 a3 10 	movl   $0xc010a308,0xc(%esp)
c0106633:	c0 
c0106634:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c010663b:	c0 
c010663c:	c7 44 24 04 9a 00 00 	movl   $0x9a,0x4(%esp)
c0106643:	00 
c0106644:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c010664b:	e8 68 a6 ff ff       	call   c0100cb8 <__panic>
     *(unsigned char *)0x4000 = 0x0d;
c0106650:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106655:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c0106658:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010665d:	83 f8 04             	cmp    $0x4,%eax
c0106660:	74 24                	je     c0106686 <check_content_set+0x180>
c0106662:	c7 44 24 0c 17 a3 10 	movl   $0xc010a317,0xc(%esp)
c0106669:	c0 
c010666a:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106671:	c0 
c0106672:	c7 44 24 04 9c 00 00 	movl   $0x9c,0x4(%esp)
c0106679:	00 
c010667a:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106681:	e8 32 a6 ff ff       	call   c0100cb8 <__panic>
     *(unsigned char *)0x4010 = 0x0d;
c0106686:	b8 10 40 00 00       	mov    $0x4010,%eax
c010668b:	c6 00 0d             	movb   $0xd,(%eax)
     assert(pgfault_num==4);
c010668e:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106693:	83 f8 04             	cmp    $0x4,%eax
c0106696:	74 24                	je     c01066bc <check_content_set+0x1b6>
c0106698:	c7 44 24 0c 17 a3 10 	movl   $0xc010a317,0xc(%esp)
c010669f:	c0 
c01066a0:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c01066a7:	c0 
c01066a8:	c7 44 24 04 9e 00 00 	movl   $0x9e,0x4(%esp)
c01066af:	00 
c01066b0:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c01066b7:	e8 fc a5 ff ff       	call   c0100cb8 <__panic>
}
c01066bc:	c9                   	leave  
c01066bd:	c3                   	ret    

c01066be <check_content_access>:

static inline int
check_content_access(void)
{
c01066be:	55                   	push   %ebp
c01066bf:	89 e5                	mov    %esp,%ebp
c01066c1:	83 ec 18             	sub    $0x18,%esp
    int ret = sm->check_swap();
c01066c4:	a1 b4 1a 12 c0       	mov    0xc0121ab4,%eax
c01066c9:	8b 40 1c             	mov    0x1c(%eax),%eax
c01066cc:	ff d0                	call   *%eax
c01066ce:	89 45 f4             	mov    %eax,-0xc(%ebp)
    return ret;
c01066d1:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01066d4:	c9                   	leave  
c01066d5:	c3                   	ret    

c01066d6 <check_swap>:
#define free_list (free_area.free_list)
#define nr_free (free_area.nr_free)

static void
check_swap(void)
{
c01066d6:	55                   	push   %ebp
c01066d7:	89 e5                	mov    %esp,%ebp
c01066d9:	53                   	push   %ebx
c01066da:	83 ec 74             	sub    $0x74,%esp
    //backup mem env
     int ret, count = 0, total = 0, i;
c01066dd:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c01066e4:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
     list_entry_t *le = &free_list;
c01066eb:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c01066f2:	eb 6b                	jmp    c010675f <check_swap+0x89>
        struct Page *p = le2page(le, page_link);
c01066f4:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01066f7:	83 e8 0c             	sub    $0xc,%eax
c01066fa:	89 45 e4             	mov    %eax,-0x1c(%ebp)
        assert(PageProperty(p));
c01066fd:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106700:	83 c0 04             	add    $0x4,%eax
c0106703:	c7 45 c4 01 00 00 00 	movl   $0x1,-0x3c(%ebp)
c010670a:	89 45 c0             	mov    %eax,-0x40(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010670d:	8b 45 c0             	mov    -0x40(%ebp),%eax
c0106710:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0106713:	0f a3 10             	bt     %edx,(%eax)
c0106716:	19 db                	sbb    %ebx,%ebx
c0106718:	89 5d bc             	mov    %ebx,-0x44(%ebp)
    return oldbit != 0;
c010671b:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c010671f:	0f 95 c0             	setne  %al
c0106722:	0f b6 c0             	movzbl %al,%eax
c0106725:	85 c0                	test   %eax,%eax
c0106727:	75 24                	jne    c010674d <check_swap+0x77>
c0106729:	c7 44 24 0c 26 a3 10 	movl   $0xc010a326,0xc(%esp)
c0106730:	c0 
c0106731:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106738:	c0 
c0106739:	c7 44 24 04 b9 00 00 	movl   $0xb9,0x4(%esp)
c0106740:	00 
c0106741:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106748:	e8 6b a5 ff ff       	call   c0100cb8 <__panic>
        count ++, total += p->property;
c010674d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0106751:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106754:	8b 50 08             	mov    0x8(%eax),%edx
c0106757:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010675a:	01 d0                	add    %edx,%eax
c010675c:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010675f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106762:	89 45 b8             	mov    %eax,-0x48(%ebp)
c0106765:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0106768:	8b 40 04             	mov    0x4(%eax),%eax
check_swap(void)
{
    //backup mem env
     int ret, count = 0, total = 0, i;
     list_entry_t *le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c010676b:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010676e:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c0106775:	0f 85 79 ff ff ff    	jne    c01066f4 <check_swap+0x1e>
        struct Page *p = le2page(le, page_link);
        assert(PageProperty(p));
        count ++, total += p->property;
     }
     assert(total == nr_free_pages());
c010677b:	8b 5d f0             	mov    -0x10(%ebp),%ebx
c010677e:	e8 c1 e0 ff ff       	call   c0104844 <nr_free_pages>
c0106783:	39 c3                	cmp    %eax,%ebx
c0106785:	74 24                	je     c01067ab <check_swap+0xd5>
c0106787:	c7 44 24 0c 36 a3 10 	movl   $0xc010a336,0xc(%esp)
c010678e:	c0 
c010678f:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106796:	c0 
c0106797:	c7 44 24 04 bc 00 00 	movl   $0xbc,0x4(%esp)
c010679e:	00 
c010679f:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c01067a6:	e8 0d a5 ff ff       	call   c0100cb8 <__panic>
     cprintf("BEGIN check_swap: count %d, total %d\n",count,total);
c01067ab:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01067ae:	89 44 24 08          	mov    %eax,0x8(%esp)
c01067b2:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01067b5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01067b9:	c7 04 24 50 a3 10 c0 	movl   $0xc010a350,(%esp)
c01067c0:	e8 92 9b ff ff       	call   c0100357 <cprintf>
     
     //now we set the phy pages env     
     struct mm_struct *mm = mm_create();
c01067c5:	e8 0f 0b 00 00       	call   c01072d9 <mm_create>
c01067ca:	89 45 e0             	mov    %eax,-0x20(%ebp)
     assert(mm != NULL);
c01067cd:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c01067d1:	75 24                	jne    c01067f7 <check_swap+0x121>
c01067d3:	c7 44 24 0c 76 a3 10 	movl   $0xc010a376,0xc(%esp)
c01067da:	c0 
c01067db:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c01067e2:	c0 
c01067e3:	c7 44 24 04 c1 00 00 	movl   $0xc1,0x4(%esp)
c01067ea:	00 
c01067eb:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c01067f2:	e8 c1 a4 ff ff       	call   c0100cb8 <__panic>

     extern struct mm_struct *check_mm_struct;
     assert(check_mm_struct == NULL);
c01067f7:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c01067fc:	85 c0                	test   %eax,%eax
c01067fe:	74 24                	je     c0106824 <check_swap+0x14e>
c0106800:	c7 44 24 0c 81 a3 10 	movl   $0xc010a381,0xc(%esp)
c0106807:	c0 
c0106808:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c010680f:	c0 
c0106810:	c7 44 24 04 c4 00 00 	movl   $0xc4,0x4(%esp)
c0106817:	00 
c0106818:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c010681f:	e8 94 a4 ff ff       	call   c0100cb8 <__panic>

     check_mm_struct = mm;
c0106824:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106827:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac

     pde_t *pgdir = mm->pgdir = boot_pgdir;
c010682c:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0106832:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106835:	89 50 0c             	mov    %edx,0xc(%eax)
c0106838:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010683b:	8b 40 0c             	mov    0xc(%eax),%eax
c010683e:	89 45 dc             	mov    %eax,-0x24(%ebp)
     assert(pgdir[0] == 0);
c0106841:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106844:	8b 00                	mov    (%eax),%eax
c0106846:	85 c0                	test   %eax,%eax
c0106848:	74 24                	je     c010686e <check_swap+0x198>
c010684a:	c7 44 24 0c 99 a3 10 	movl   $0xc010a399,0xc(%esp)
c0106851:	c0 
c0106852:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106859:	c0 
c010685a:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c0106861:	00 
c0106862:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106869:	e8 4a a4 ff ff       	call   c0100cb8 <__panic>

     struct vma_struct *vma = vma_create(BEING_CHECK_VALID_VADDR, CHECK_VALID_VADDR, VM_WRITE | VM_READ);
c010686e:	c7 44 24 08 03 00 00 	movl   $0x3,0x8(%esp)
c0106875:	00 
c0106876:	c7 44 24 04 00 60 00 	movl   $0x6000,0x4(%esp)
c010687d:	00 
c010687e:	c7 04 24 00 10 00 00 	movl   $0x1000,(%esp)
c0106885:	e8 c7 0a 00 00       	call   c0107351 <vma_create>
c010688a:	89 45 d8             	mov    %eax,-0x28(%ebp)
     assert(vma != NULL);
c010688d:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0106891:	75 24                	jne    c01068b7 <check_swap+0x1e1>
c0106893:	c7 44 24 0c a7 a3 10 	movl   $0xc010a3a7,0xc(%esp)
c010689a:	c0 
c010689b:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c01068a2:	c0 
c01068a3:	c7 44 24 04 cc 00 00 	movl   $0xcc,0x4(%esp)
c01068aa:	00 
c01068ab:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c01068b2:	e8 01 a4 ff ff       	call   c0100cb8 <__panic>

     insert_vma_struct(mm, vma);
c01068b7:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01068ba:	89 44 24 04          	mov    %eax,0x4(%esp)
c01068be:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01068c1:	89 04 24             	mov    %eax,(%esp)
c01068c4:	e8 18 0c 00 00       	call   c01074e1 <insert_vma_struct>

     //setup the temp Page Table vaddr 0~4MB
     cprintf("setup Page Table for vaddr 0X1000, so alloc a page\n");
c01068c9:	c7 04 24 b4 a3 10 c0 	movl   $0xc010a3b4,(%esp)
c01068d0:	e8 82 9a ff ff       	call   c0100357 <cprintf>
     pte_t *temp_ptep=NULL;
c01068d5:	c7 45 d4 00 00 00 00 	movl   $0x0,-0x2c(%ebp)
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
c01068dc:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01068df:	8b 40 0c             	mov    0xc(%eax),%eax
c01068e2:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c01068e9:	00 
c01068ea:	c7 44 24 04 00 10 00 	movl   $0x1000,0x4(%esp)
c01068f1:	00 
c01068f2:	89 04 24             	mov    %eax,(%esp)
c01068f5:	e8 0e e6 ff ff       	call   c0104f08 <get_pte>
c01068fa:	89 45 d4             	mov    %eax,-0x2c(%ebp)
     assert(temp_ptep!= NULL);
c01068fd:	83 7d d4 00          	cmpl   $0x0,-0x2c(%ebp)
c0106901:	75 24                	jne    c0106927 <check_swap+0x251>
c0106903:	c7 44 24 0c e8 a3 10 	movl   $0xc010a3e8,0xc(%esp)
c010690a:	c0 
c010690b:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106912:	c0 
c0106913:	c7 44 24 04 d4 00 00 	movl   $0xd4,0x4(%esp)
c010691a:	00 
c010691b:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106922:	e8 91 a3 ff ff       	call   c0100cb8 <__panic>
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
c0106927:	c7 04 24 fc a3 10 c0 	movl   $0xc010a3fc,(%esp)
c010692e:	e8 24 9a ff ff       	call   c0100357 <cprintf>
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106933:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c010693a:	e9 a3 00 00 00       	jmp    c01069e2 <check_swap+0x30c>
          check_rp[i] = alloc_page();
c010693f:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0106946:	e8 5c de ff ff       	call   c01047a7 <alloc_pages>
c010694b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010694e:	89 04 95 e0 1a 12 c0 	mov    %eax,-0x3fede520(,%edx,4)
          assert(check_rp[i] != NULL );
c0106955:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106958:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c010695f:	85 c0                	test   %eax,%eax
c0106961:	75 24                	jne    c0106987 <check_swap+0x2b1>
c0106963:	c7 44 24 0c 20 a4 10 	movl   $0xc010a420,0xc(%esp)
c010696a:	c0 
c010696b:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106972:	c0 
c0106973:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c010697a:	00 
c010697b:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106982:	e8 31 a3 ff ff       	call   c0100cb8 <__panic>
          assert(!PageProperty(check_rp[i]));
c0106987:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010698a:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106991:	83 c0 04             	add    $0x4,%eax
c0106994:	c7 45 b4 01 00 00 00 	movl   $0x1,-0x4c(%ebp)
c010699b:	89 45 b0             	mov    %eax,-0x50(%ebp)
 * @addr:   the address to count from
 * */
static inline bool
test_bit(int nr, volatile void *addr) {
    int oldbit;
    asm volatile ("btl %2, %1; sbbl %0,%0" : "=r" (oldbit) : "m" (*(volatile long *)addr), "Ir" (nr));
c010699e:	8b 45 b0             	mov    -0x50(%ebp),%eax
c01069a1:	8b 55 b4             	mov    -0x4c(%ebp),%edx
c01069a4:	0f a3 10             	bt     %edx,(%eax)
c01069a7:	19 db                	sbb    %ebx,%ebx
c01069a9:	89 5d ac             	mov    %ebx,-0x54(%ebp)
    return oldbit != 0;
c01069ac:	83 7d ac 00          	cmpl   $0x0,-0x54(%ebp)
c01069b0:	0f 95 c0             	setne  %al
c01069b3:	0f b6 c0             	movzbl %al,%eax
c01069b6:	85 c0                	test   %eax,%eax
c01069b8:	74 24                	je     c01069de <check_swap+0x308>
c01069ba:	c7 44 24 0c 34 a4 10 	movl   $0xc010a434,0xc(%esp)
c01069c1:	c0 
c01069c2:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c01069c9:	c0 
c01069ca:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c01069d1:	00 
c01069d2:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c01069d9:	e8 da a2 ff ff       	call   c0100cb8 <__panic>
     pte_t *temp_ptep=NULL;
     temp_ptep = get_pte(mm->pgdir, BEING_CHECK_VALID_VADDR, 1);
     assert(temp_ptep!= NULL);
     cprintf("setup Page Table vaddr 0~4MB OVER!\n");
     
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c01069de:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c01069e2:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c01069e6:	0f 8e 53 ff ff ff    	jle    c010693f <check_swap+0x269>
          check_rp[i] = alloc_page();
          assert(check_rp[i] != NULL );
          assert(!PageProperty(check_rp[i]));
     }
     list_entry_t free_list_store = free_list;
c01069ec:	a1 c0 1a 12 c0       	mov    0xc0121ac0,%eax
c01069f1:	8b 15 c4 1a 12 c0    	mov    0xc0121ac4,%edx
c01069f7:	89 45 98             	mov    %eax,-0x68(%ebp)
c01069fa:	89 55 9c             	mov    %edx,-0x64(%ebp)
c01069fd:	c7 45 a8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x58(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106a04:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106a07:	8b 55 a8             	mov    -0x58(%ebp),%edx
c0106a0a:	89 50 04             	mov    %edx,0x4(%eax)
c0106a0d:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106a10:	8b 50 04             	mov    0x4(%eax),%edx
c0106a13:	8b 45 a8             	mov    -0x58(%ebp),%eax
c0106a16:	89 10                	mov    %edx,(%eax)
c0106a18:	c7 45 a4 c0 1a 12 c0 	movl   $0xc0121ac0,-0x5c(%ebp)
 * list_empty - tests whether a list is empty
 * @list:       the list to test.
 * */
static inline bool
list_empty(list_entry_t *list) {
    return list->next == list;
c0106a1f:	8b 45 a4             	mov    -0x5c(%ebp),%eax
c0106a22:	8b 40 04             	mov    0x4(%eax),%eax
c0106a25:	39 45 a4             	cmp    %eax,-0x5c(%ebp)
c0106a28:	0f 94 c0             	sete   %al
c0106a2b:	0f b6 c0             	movzbl %al,%eax
     list_init(&free_list);
     assert(list_empty(&free_list));
c0106a2e:	85 c0                	test   %eax,%eax
c0106a30:	75 24                	jne    c0106a56 <check_swap+0x380>
c0106a32:	c7 44 24 0c 4f a4 10 	movl   $0xc010a44f,0xc(%esp)
c0106a39:	c0 
c0106a3a:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106a41:	c0 
c0106a42:	c7 44 24 04 de 00 00 	movl   $0xde,0x4(%esp)
c0106a49:	00 
c0106a4a:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106a51:	e8 62 a2 ff ff       	call   c0100cb8 <__panic>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
c0106a56:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106a5b:	89 45 d0             	mov    %eax,-0x30(%ebp)
     nr_free = 0;
c0106a5e:	c7 05 c8 1a 12 c0 00 	movl   $0x0,0xc0121ac8
c0106a65:	00 00 00 
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a68:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106a6f:	eb 1e                	jmp    c0106a8f <check_swap+0x3b9>
        free_pages(check_rp[i],1);
c0106a71:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106a74:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106a7b:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106a82:	00 
c0106a83:	89 04 24             	mov    %eax,(%esp)
c0106a86:	e8 87 dd ff ff       	call   c0104812 <free_pages>
     
     //assert(alloc_page() == NULL);
     
     unsigned int nr_free_store = nr_free;
     nr_free = 0;
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106a8b:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106a8f:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106a93:	7e dc                	jle    c0106a71 <check_swap+0x39b>
        free_pages(check_rp[i],1);
     }
     assert(nr_free==CHECK_VALID_PHY_PAGE_NUM);
c0106a95:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106a9a:	83 f8 04             	cmp    $0x4,%eax
c0106a9d:	74 24                	je     c0106ac3 <check_swap+0x3ed>
c0106a9f:	c7 44 24 0c 68 a4 10 	movl   $0xc010a468,0xc(%esp)
c0106aa6:	c0 
c0106aa7:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106aae:	c0 
c0106aaf:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0106ab6:	00 
c0106ab7:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106abe:	e8 f5 a1 ff ff       	call   c0100cb8 <__panic>
     
     cprintf("set up init env for check_swap begin!\n");
c0106ac3:	c7 04 24 8c a4 10 c0 	movl   $0xc010a48c,(%esp)
c0106aca:	e8 88 98 ff ff       	call   c0100357 <cprintf>
     //setup initial vir_page<->phy_page environment for page relpacement algorithm 

     
     pgfault_num=0;
c0106acf:	c7 05 b8 1a 12 c0 00 	movl   $0x0,0xc0121ab8
c0106ad6:	00 00 00 
     
     check_content_set();
c0106ad9:	e8 28 fa ff ff       	call   c0106506 <check_content_set>
     assert( nr_free == 0);         
c0106ade:	a1 c8 1a 12 c0       	mov    0xc0121ac8,%eax
c0106ae3:	85 c0                	test   %eax,%eax
c0106ae5:	74 24                	je     c0106b0b <check_swap+0x435>
c0106ae7:	c7 44 24 0c b3 a4 10 	movl   $0xc010a4b3,0xc(%esp)
c0106aee:	c0 
c0106aef:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106af6:	c0 
c0106af7:	c7 44 24 04 f0 00 00 	movl   $0xf0,0x4(%esp)
c0106afe:	00 
c0106aff:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106b06:	e8 ad a1 ff ff       	call   c0100cb8 <__panic>
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106b0b:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106b12:	eb 26                	jmp    c0106b3a <check_swap+0x464>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
c0106b14:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b17:	c7 04 85 00 1b 12 c0 	movl   $0xffffffff,-0x3fede500(,%eax,4)
c0106b1e:	ff ff ff ff 
c0106b22:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b25:	8b 14 85 00 1b 12 c0 	mov    -0x3fede500(,%eax,4),%edx
c0106b2c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b2f:	89 14 85 40 1b 12 c0 	mov    %edx,-0x3fede4c0(,%eax,4)
     
     pgfault_num=0;
     
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
c0106b36:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106b3a:	83 7d ec 09          	cmpl   $0x9,-0x14(%ebp)
c0106b3e:	7e d4                	jle    c0106b14 <check_swap+0x43e>
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106b40:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106b47:	e9 eb 00 00 00       	jmp    c0106c37 <check_swap+0x561>
         check_ptep[i]=0;
c0106b4c:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b4f:	c7 04 85 94 1b 12 c0 	movl   $0x0,-0x3fede46c(,%eax,4)
c0106b56:	00 00 00 00 
         check_ptep[i] = get_pte(pgdir, (i+1)*0x1000, 0);
c0106b5a:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b5d:	83 c0 01             	add    $0x1,%eax
c0106b60:	c1 e0 0c             	shl    $0xc,%eax
c0106b63:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0106b6a:	00 
c0106b6b:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106b6f:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106b72:	89 04 24             	mov    %eax,(%esp)
c0106b75:	e8 8e e3 ff ff       	call   c0104f08 <get_pte>
c0106b7a:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106b7d:	89 04 95 94 1b 12 c0 	mov    %eax,-0x3fede46c(,%edx,4)
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
c0106b84:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106b87:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106b8e:	85 c0                	test   %eax,%eax
c0106b90:	75 24                	jne    c0106bb6 <check_swap+0x4e0>
c0106b92:	c7 44 24 0c c0 a4 10 	movl   $0xc010a4c0,0xc(%esp)
c0106b99:	c0 
c0106b9a:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106ba1:	c0 
c0106ba2:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0106ba9:	00 
c0106baa:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106bb1:	e8 02 a1 ff ff       	call   c0100cb8 <__panic>
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
c0106bb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bb9:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106bc0:	8b 00                	mov    (%eax),%eax
c0106bc2:	89 04 24             	mov    %eax,(%esp)
c0106bc5:	e8 9f f5 ff ff       	call   c0106169 <pte2page>
c0106bca:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106bcd:	8b 14 95 e0 1a 12 c0 	mov    -0x3fede520(,%edx,4),%edx
c0106bd4:	39 d0                	cmp    %edx,%eax
c0106bd6:	74 24                	je     c0106bfc <check_swap+0x526>
c0106bd8:	c7 44 24 0c d8 a4 10 	movl   $0xc010a4d8,0xc(%esp)
c0106bdf:	c0 
c0106be0:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106be7:	c0 
c0106be8:	c7 44 24 04 f9 00 00 	movl   $0xf9,0x4(%esp)
c0106bef:	00 
c0106bf0:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106bf7:	e8 bc a0 ff ff       	call   c0100cb8 <__panic>
         assert((*check_ptep[i] & PTE_P));          
c0106bfc:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106bff:	8b 04 85 94 1b 12 c0 	mov    -0x3fede46c(,%eax,4),%eax
c0106c06:	8b 00                	mov    (%eax),%eax
c0106c08:	83 e0 01             	and    $0x1,%eax
c0106c0b:	85 c0                	test   %eax,%eax
c0106c0d:	75 24                	jne    c0106c33 <check_swap+0x55d>
c0106c0f:	c7 44 24 0c 00 a5 10 	movl   $0xc010a500,0xc(%esp)
c0106c16:	c0 
c0106c17:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106c1e:	c0 
c0106c1f:	c7 44 24 04 fa 00 00 	movl   $0xfa,0x4(%esp)
c0106c26:	00 
c0106c27:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106c2e:	e8 85 a0 ff ff       	call   c0100cb8 <__panic>
     check_content_set();
     assert( nr_free == 0);         
     for(i = 0; i<MAX_SEQ_NO ; i++) 
         swap_out_seq_no[i]=swap_in_seq_no[i]=-1;
     
     for (i= 0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106c33:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106c37:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106c3b:	0f 8e 0b ff ff ff    	jle    c0106b4c <check_swap+0x476>
         //cprintf("i %d, check_ptep addr %x, value %x\n", i, check_ptep[i], *check_ptep[i]);
         assert(check_ptep[i] != NULL);
         assert(pte2page(*check_ptep[i]) == check_rp[i]);
         assert((*check_ptep[i] & PTE_P));          
     }
     cprintf("set up init env for check_swap over!\n");
c0106c41:	c7 04 24 1c a5 10 c0 	movl   $0xc010a51c,(%esp)
c0106c48:	e8 0a 97 ff ff       	call   c0100357 <cprintf>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
c0106c4d:	e8 6c fa ff ff       	call   c01066be <check_content_access>
c0106c52:	89 45 cc             	mov    %eax,-0x34(%ebp)
     assert(ret==0);
c0106c55:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c0106c59:	74 24                	je     c0106c7f <check_swap+0x5a9>
c0106c5b:	c7 44 24 0c 42 a5 10 	movl   $0xc010a542,0xc(%esp)
c0106c62:	c0 
c0106c63:	c7 44 24 08 2a a2 10 	movl   $0xc010a22a,0x8(%esp)
c0106c6a:	c0 
c0106c6b:	c7 44 24 04 ff 00 00 	movl   $0xff,0x4(%esp)
c0106c72:	00 
c0106c73:	c7 04 24 c4 a1 10 c0 	movl   $0xc010a1c4,(%esp)
c0106c7a:	e8 39 a0 ff ff       	call   c0100cb8 <__panic>
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106c7f:	c7 45 ec 00 00 00 00 	movl   $0x0,-0x14(%ebp)
c0106c86:	eb 1e                	jmp    c0106ca6 <check_swap+0x5d0>
         free_pages(check_rp[i],1);
c0106c88:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106c8b:	8b 04 85 e0 1a 12 c0 	mov    -0x3fede520(,%eax,4),%eax
c0106c92:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0106c99:	00 
c0106c9a:	89 04 24             	mov    %eax,(%esp)
c0106c9d:	e8 70 db ff ff       	call   c0104812 <free_pages>
     // now access the virt pages to test  page relpacement algorithm 
     ret=check_content_access();
     assert(ret==0);
     
     //restore kernel mem env
     for (i=0;i<CHECK_VALID_PHY_PAGE_NUM;i++) {
c0106ca2:	83 45 ec 01          	addl   $0x1,-0x14(%ebp)
c0106ca6:	83 7d ec 03          	cmpl   $0x3,-0x14(%ebp)
c0106caa:	7e dc                	jle    c0106c88 <check_swap+0x5b2>
         free_pages(check_rp[i],1);
     } 

     //free_page(pte2page(*temp_ptep));
     
     mm_destroy(mm);
c0106cac:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106caf:	89 04 24             	mov    %eax,(%esp)
c0106cb2:	e8 5b 09 00 00       	call   c0107612 <mm_destroy>
         
     nr_free = nr_free_store;
c0106cb7:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0106cba:	a3 c8 1a 12 c0       	mov    %eax,0xc0121ac8
     free_list = free_list_store;
c0106cbf:	8b 45 98             	mov    -0x68(%ebp),%eax
c0106cc2:	8b 55 9c             	mov    -0x64(%ebp),%edx
c0106cc5:	a3 c0 1a 12 c0       	mov    %eax,0xc0121ac0
c0106cca:	89 15 c4 1a 12 c0    	mov    %edx,0xc0121ac4

     
     le = &free_list;
c0106cd0:	c7 45 e8 c0 1a 12 c0 	movl   $0xc0121ac0,-0x18(%ebp)
     while ((le = list_next(le)) != &free_list) {
c0106cd7:	eb 1f                	jmp    c0106cf8 <check_swap+0x622>
         struct Page *p = le2page(le, page_link);
c0106cd9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106cdc:	83 e8 0c             	sub    $0xc,%eax
c0106cdf:	89 45 c8             	mov    %eax,-0x38(%ebp)
         count --, total -= p->property;
c0106ce2:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0106ce6:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0106ce9:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0106cec:	8b 40 08             	mov    0x8(%eax),%eax
c0106cef:	89 d1                	mov    %edx,%ecx
c0106cf1:	29 c1                	sub    %eax,%ecx
c0106cf3:	89 c8                	mov    %ecx,%eax
c0106cf5:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0106cf8:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106cfb:	89 45 a0             	mov    %eax,-0x60(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106cfe:	8b 45 a0             	mov    -0x60(%ebp),%eax
c0106d01:	8b 40 04             	mov    0x4(%eax),%eax
     nr_free = nr_free_store;
     free_list = free_list_store;

     
     le = &free_list;
     while ((le = list_next(le)) != &free_list) {
c0106d04:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0106d07:	81 7d e8 c0 1a 12 c0 	cmpl   $0xc0121ac0,-0x18(%ebp)
c0106d0e:	75 c9                	jne    c0106cd9 <check_swap+0x603>
         struct Page *p = le2page(le, page_link);
         count --, total -= p->property;
     }
     cprintf("count is %d, total is %d\n",count,total);
c0106d10:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106d13:	89 44 24 08          	mov    %eax,0x8(%esp)
c0106d17:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106d1a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0106d1e:	c7 04 24 49 a5 10 c0 	movl   $0xc010a549,(%esp)
c0106d25:	e8 2d 96 ff ff       	call   c0100357 <cprintf>
     //assert(count == 0);
     
     cprintf("check_swap() succeeded!\n");
c0106d2a:	c7 04 24 63 a5 10 c0 	movl   $0xc010a563,(%esp)
c0106d31:	e8 21 96 ff ff       	call   c0100357 <cprintf>
}
c0106d36:	83 c4 74             	add    $0x74,%esp
c0106d39:	5b                   	pop    %ebx
c0106d3a:	5d                   	pop    %ebp
c0106d3b:	c3                   	ret    

c0106d3c <_fifo_init_mm>:
 * (2) _fifo_init_mm: init pra_list_head and let  mm->sm_priv point to the addr of pra_list_head.
 *              Now, From the memory control struct mm_struct, we can access FIFO PRA
 */
static int
_fifo_init_mm(struct mm_struct *mm)
{     
c0106d3c:	55                   	push   %ebp
c0106d3d:	89 e5                	mov    %esp,%ebp
c0106d3f:	83 ec 10             	sub    $0x10,%esp
c0106d42:	c7 45 fc a4 1b 12 c0 	movl   $0xc0121ba4,-0x4(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c0106d49:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d4c:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0106d4f:	89 50 04             	mov    %edx,0x4(%eax)
c0106d52:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d55:	8b 50 04             	mov    0x4(%eax),%edx
c0106d58:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0106d5b:	89 10                	mov    %edx,(%eax)
     list_init(&pra_list_head);
     mm->sm_priv = &pra_list_head;
c0106d5d:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d60:	c7 40 14 a4 1b 12 c0 	movl   $0xc0121ba4,0x14(%eax)
     //cprintf(" mm->sm_priv %x in fifo_init_mm\n",mm->sm_priv);
     return 0;
c0106d67:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106d6c:	c9                   	leave  
c0106d6d:	c3                   	ret    

c0106d6e <_fifo_map_swappable>:
/*
 * (3)_fifo_map_swappable: According FIFO PRA, we should link the most recent arrival page at the back of pra_list_head qeueue
 */
static int
_fifo_map_swappable(struct mm_struct *mm, uintptr_t addr, struct Page *page, int swap_in)
{
c0106d6e:	55                   	push   %ebp
c0106d6f:	89 e5                	mov    %esp,%ebp
c0106d71:	83 ec 38             	sub    $0x38,%esp
    list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106d74:	8b 45 08             	mov    0x8(%ebp),%eax
c0106d77:	8b 40 14             	mov    0x14(%eax),%eax
c0106d7a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    list_entry_t *entry=&(page->pra_page_link);
c0106d7d:	8b 45 10             	mov    0x10(%ebp),%eax
c0106d80:	83 c0 14             	add    $0x14,%eax
c0106d83:	89 45 f0             	mov    %eax,-0x10(%ebp)
 
    assert(entry != NULL && head != NULL);
c0106d86:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0106d8a:	74 06                	je     c0106d92 <_fifo_map_swappable+0x24>
c0106d8c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106d90:	75 24                	jne    c0106db6 <_fifo_map_swappable+0x48>
c0106d92:	c7 44 24 0c 7c a5 10 	movl   $0xc010a57c,0xc(%esp)
c0106d99:	c0 
c0106d9a:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0106da1:	c0 
c0106da2:	c7 44 24 04 32 00 00 	movl   $0x32,0x4(%esp)
c0106da9:	00 
c0106daa:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0106db1:	e8 02 9f ff ff       	call   c0100cb8 <__panic>
c0106db6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106db9:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106dbc:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106dbf:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * Insert the new element @elm *before* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_before(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm->prev, listelm);
c0106dc2:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106dc5:	8b 00                	mov    (%eax),%eax
c0106dc7:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0106dca:	89 55 e4             	mov    %edx,-0x1c(%ebp)
c0106dcd:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0106dd0:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0106dd3:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c0106dd6:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106dd9:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106ddc:	89 10                	mov    %edx,(%eax)
c0106dde:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106de1:	8b 10                	mov    (%eax),%edx
c0106de3:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106de6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c0106de9:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106dec:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106def:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c0106df2:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106df5:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106df8:	89 10                	mov    %edx,(%eax)
    //record the page access situlation
    /*LAB3 EXERCISE 2: YOUR CODE*/ 
    //(1)link the most recent arrival page at the back of the pra_list_head qeueue.
        list_add_before(head, entry);    
        return 0;
c0106dfa:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106dff:	c9                   	leave  
c0106e00:	c3                   	ret    

c0106e01 <_fifo_swap_out_victim>:
 *  (4)_fifo_swap_out_victim: According FIFO PRA, we should unlink the  earliest arrival page in front of pra_list_head qeueue,
 *                            then set the addr of addr of this page to ptr_page.
 */
static int
_fifo_swap_out_victim(struct mm_struct *mm, struct Page ** ptr_page, int in_tick)
{
c0106e01:	55                   	push   %ebp
c0106e02:	89 e5                	mov    %esp,%ebp
c0106e04:	83 ec 38             	sub    $0x38,%esp
     list_entry_t *head=(list_entry_t*) mm->sm_priv;
c0106e07:	8b 45 08             	mov    0x8(%ebp),%eax
c0106e0a:	8b 40 14             	mov    0x14(%eax),%eax
c0106e0d:	89 45 f4             	mov    %eax,-0xc(%ebp)
         assert(head != NULL);
c0106e10:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0106e14:	75 24                	jne    c0106e3a <_fifo_swap_out_victim+0x39>
c0106e16:	c7 44 24 0c c3 a5 10 	movl   $0xc010a5c3,0xc(%esp)
c0106e1d:	c0 
c0106e1e:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0106e25:	c0 
c0106e26:	c7 44 24 04 41 00 00 	movl   $0x41,0x4(%esp)
c0106e2d:	00 
c0106e2e:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0106e35:	e8 7e 9e ff ff       	call   c0100cb8 <__panic>
     assert(in_tick==0);
c0106e3a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0106e3e:	74 24                	je     c0106e64 <_fifo_swap_out_victim+0x63>
c0106e40:	c7 44 24 0c d0 a5 10 	movl   $0xc010a5d0,0xc(%esp)
c0106e47:	c0 
c0106e48:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0106e4f:	c0 
c0106e50:	c7 44 24 04 42 00 00 	movl   $0x42,0x4(%esp)
c0106e57:	00 
c0106e58:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0106e5f:	e8 54 9e ff ff       	call   c0100cb8 <__panic>
c0106e64:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e67:	89 45 e8             	mov    %eax,-0x18(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0106e6a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0106e6d:	8b 40 04             	mov    0x4(%eax),%eax
     /* Select the victim */
     /*LAB3 EXERCISE 2: YOUR CODE*/ 
     //(1)  unlink the  earliest arrival page in front of pra_list_head qeueue
     //(2)  set the addr of addr of this page to ptr_page
     list_entry_t *le = list_next(head);
c0106e70:	89 45 f0             	mov    %eax,-0x10(%ebp)
     assert(head!=le);
c0106e73:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0106e76:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c0106e79:	75 24                	jne    c0106e9f <_fifo_swap_out_victim+0x9e>
c0106e7b:	c7 44 24 0c db a5 10 	movl   $0xc010a5db,0xc(%esp)
c0106e82:	c0 
c0106e83:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0106e8a:	c0 
c0106e8b:	c7 44 24 04 48 00 00 	movl   $0x48,0x4(%esp)
c0106e92:	00 
c0106e93:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0106e9a:	e8 19 9e ff ff       	call   c0100cb8 <__panic>
     struct Page *p = le2page(le, pra_page_link);
c0106e9f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106ea2:	83 e8 14             	sub    $0x14,%eax
c0106ea5:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0106ea8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0106eab:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0106eae:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0106eb1:	8b 40 04             	mov    0x4(%eax),%eax
c0106eb4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0106eb7:	8b 12                	mov    (%edx),%edx
c0106eb9:	89 55 e0             	mov    %edx,-0x20(%ebp)
c0106ebc:	89 45 dc             	mov    %eax,-0x24(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0106ebf:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0106ec2:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0106ec5:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0106ec8:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0106ecb:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0106ece:	89 10                	mov    %edx,(%eax)
     list_del(le);
     assert(p !=NULL);
c0106ed0:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0106ed4:	75 24                	jne    c0106efa <_fifo_swap_out_victim+0xf9>
c0106ed6:	c7 44 24 0c e4 a5 10 	movl   $0xc010a5e4,0xc(%esp)
c0106edd:	c0 
c0106ede:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0106ee5:	c0 
c0106ee6:	c7 44 24 04 4b 00 00 	movl   $0x4b,0x4(%esp)
c0106eed:	00 
c0106eee:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0106ef5:	e8 be 9d ff ff       	call   c0100cb8 <__panic>
     *ptr_page = p;     
c0106efa:	8b 45 0c             	mov    0xc(%ebp),%eax
c0106efd:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0106f00:	89 10                	mov    %edx,(%eax)
     return 0;
c0106f02:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0106f07:	c9                   	leave  
c0106f08:	c3                   	ret    

c0106f09 <_fifo_check_swap>:

static int
_fifo_check_swap(void) {
c0106f09:	55                   	push   %ebp
c0106f0a:	89 e5                	mov    %esp,%ebp
c0106f0c:	83 ec 18             	sub    $0x18,%esp
    cprintf("write Virt Page c in fifo_check_swap\n");
c0106f0f:	c7 04 24 f0 a5 10 c0 	movl   $0xc010a5f0,(%esp)
c0106f16:	e8 3c 94 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c0106f1b:	b8 00 30 00 00       	mov    $0x3000,%eax
c0106f20:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==4);
c0106f23:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106f28:	83 f8 04             	cmp    $0x4,%eax
c0106f2b:	74 24                	je     c0106f51 <_fifo_check_swap+0x48>
c0106f2d:	c7 44 24 0c 16 a6 10 	movl   $0xc010a616,0xc(%esp)
c0106f34:	c0 
c0106f35:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0106f3c:	c0 
c0106f3d:	c7 44 24 04 54 00 00 	movl   $0x54,0x4(%esp)
c0106f44:	00 
c0106f45:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0106f4c:	e8 67 9d ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c0106f51:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c0106f58:	e8 fa 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c0106f5d:	b8 00 10 00 00       	mov    $0x1000,%eax
c0106f62:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==4);
c0106f65:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106f6a:	83 f8 04             	cmp    $0x4,%eax
c0106f6d:	74 24                	je     c0106f93 <_fifo_check_swap+0x8a>
c0106f6f:	c7 44 24 0c 16 a6 10 	movl   $0xc010a616,0xc(%esp)
c0106f76:	c0 
c0106f77:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0106f7e:	c0 
c0106f7f:	c7 44 24 04 57 00 00 	movl   $0x57,0x4(%esp)
c0106f86:	00 
c0106f87:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0106f8e:	e8 25 9d ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0106f93:	c7 04 24 50 a6 10 c0 	movl   $0xc010a650,(%esp)
c0106f9a:	e8 b8 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c0106f9f:	b8 00 40 00 00       	mov    $0x4000,%eax
c0106fa4:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==4);
c0106fa7:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106fac:	83 f8 04             	cmp    $0x4,%eax
c0106faf:	74 24                	je     c0106fd5 <_fifo_check_swap+0xcc>
c0106fb1:	c7 44 24 0c 16 a6 10 	movl   $0xc010a616,0xc(%esp)
c0106fb8:	c0 
c0106fb9:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0106fc0:	c0 
c0106fc1:	c7 44 24 04 5a 00 00 	movl   $0x5a,0x4(%esp)
c0106fc8:	00 
c0106fc9:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0106fd0:	e8 e3 9c ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0106fd5:	c7 04 24 78 a6 10 c0 	movl   $0xc010a678,(%esp)
c0106fdc:	e8 76 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0106fe1:	b8 00 20 00 00       	mov    $0x2000,%eax
c0106fe6:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==4);
c0106fe9:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0106fee:	83 f8 04             	cmp    $0x4,%eax
c0106ff1:	74 24                	je     c0107017 <_fifo_check_swap+0x10e>
c0106ff3:	c7 44 24 0c 16 a6 10 	movl   $0xc010a616,0xc(%esp)
c0106ffa:	c0 
c0106ffb:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0107002:	c0 
c0107003:	c7 44 24 04 5d 00 00 	movl   $0x5d,0x4(%esp)
c010700a:	00 
c010700b:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0107012:	e8 a1 9c ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c0107017:	c7 04 24 a0 a6 10 c0 	movl   $0xc010a6a0,(%esp)
c010701e:	e8 34 93 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c0107023:	b8 00 50 00 00       	mov    $0x5000,%eax
c0107028:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==5);
c010702b:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107030:	83 f8 05             	cmp    $0x5,%eax
c0107033:	74 24                	je     c0107059 <_fifo_check_swap+0x150>
c0107035:	c7 44 24 0c c6 a6 10 	movl   $0xc010a6c6,0xc(%esp)
c010703c:	c0 
c010703d:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0107044:	c0 
c0107045:	c7 44 24 04 60 00 00 	movl   $0x60,0x4(%esp)
c010704c:	00 
c010704d:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0107054:	e8 5f 9c ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c0107059:	c7 04 24 78 a6 10 c0 	movl   $0xc010a678,(%esp)
c0107060:	e8 f2 92 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c0107065:	b8 00 20 00 00       	mov    $0x2000,%eax
c010706a:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==5);
c010706d:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107072:	83 f8 05             	cmp    $0x5,%eax
c0107075:	74 24                	je     c010709b <_fifo_check_swap+0x192>
c0107077:	c7 44 24 0c c6 a6 10 	movl   $0xc010a6c6,0xc(%esp)
c010707e:	c0 
c010707f:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0107086:	c0 
c0107087:	c7 44 24 04 63 00 00 	movl   $0x63,0x4(%esp)
c010708e:	00 
c010708f:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0107096:	e8 1d 9c ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c010709b:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01070a2:	e8 b0 92 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x1000 = 0x0a;
c01070a7:	b8 00 10 00 00       	mov    $0x1000,%eax
c01070ac:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==6);
c01070af:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01070b4:	83 f8 06             	cmp    $0x6,%eax
c01070b7:	74 24                	je     c01070dd <_fifo_check_swap+0x1d4>
c01070b9:	c7 44 24 0c d5 a6 10 	movl   $0xc010a6d5,0xc(%esp)
c01070c0:	c0 
c01070c1:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c01070c8:	c0 
c01070c9:	c7 44 24 04 66 00 00 	movl   $0x66,0x4(%esp)
c01070d0:	00 
c01070d1:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c01070d8:	e8 db 9b ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page b in fifo_check_swap\n");
c01070dd:	c7 04 24 78 a6 10 c0 	movl   $0xc010a678,(%esp)
c01070e4:	e8 6e 92 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x2000 = 0x0b;
c01070e9:	b8 00 20 00 00       	mov    $0x2000,%eax
c01070ee:	c6 00 0b             	movb   $0xb,(%eax)
    assert(pgfault_num==7);
c01070f1:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01070f6:	83 f8 07             	cmp    $0x7,%eax
c01070f9:	74 24                	je     c010711f <_fifo_check_swap+0x216>
c01070fb:	c7 44 24 0c e4 a6 10 	movl   $0xc010a6e4,0xc(%esp)
c0107102:	c0 
c0107103:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c010710a:	c0 
c010710b:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c0107112:	00 
c0107113:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c010711a:	e8 99 9b ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page c in fifo_check_swap\n");
c010711f:	c7 04 24 f0 a5 10 c0 	movl   $0xc010a5f0,(%esp)
c0107126:	e8 2c 92 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x3000 = 0x0c;
c010712b:	b8 00 30 00 00       	mov    $0x3000,%eax
c0107130:	c6 00 0c             	movb   $0xc,(%eax)
    assert(pgfault_num==8);
c0107133:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107138:	83 f8 08             	cmp    $0x8,%eax
c010713b:	74 24                	je     c0107161 <_fifo_check_swap+0x258>
c010713d:	c7 44 24 0c f3 a6 10 	movl   $0xc010a6f3,0xc(%esp)
c0107144:	c0 
c0107145:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c010714c:	c0 
c010714d:	c7 44 24 04 6c 00 00 	movl   $0x6c,0x4(%esp)
c0107154:	00 
c0107155:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c010715c:	e8 57 9b ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page d in fifo_check_swap\n");
c0107161:	c7 04 24 50 a6 10 c0 	movl   $0xc010a650,(%esp)
c0107168:	e8 ea 91 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x4000 = 0x0d;
c010716d:	b8 00 40 00 00       	mov    $0x4000,%eax
c0107172:	c6 00 0d             	movb   $0xd,(%eax)
    assert(pgfault_num==9);
c0107175:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010717a:	83 f8 09             	cmp    $0x9,%eax
c010717d:	74 24                	je     c01071a3 <_fifo_check_swap+0x29a>
c010717f:	c7 44 24 0c 02 a7 10 	movl   $0xc010a702,0xc(%esp)
c0107186:	c0 
c0107187:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c010718e:	c0 
c010718f:	c7 44 24 04 6f 00 00 	movl   $0x6f,0x4(%esp)
c0107196:	00 
c0107197:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c010719e:	e8 15 9b ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page e in fifo_check_swap\n");
c01071a3:	c7 04 24 a0 a6 10 c0 	movl   $0xc010a6a0,(%esp)
c01071aa:	e8 a8 91 ff ff       	call   c0100357 <cprintf>
    *(unsigned char *)0x5000 = 0x0e;
c01071af:	b8 00 50 00 00       	mov    $0x5000,%eax
c01071b4:	c6 00 0e             	movb   $0xe,(%eax)
    assert(pgfault_num==10);
c01071b7:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c01071bc:	83 f8 0a             	cmp    $0xa,%eax
c01071bf:	74 24                	je     c01071e5 <_fifo_check_swap+0x2dc>
c01071c1:	c7 44 24 0c 11 a7 10 	movl   $0xc010a711,0xc(%esp)
c01071c8:	c0 
c01071c9:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c01071d0:	c0 
c01071d1:	c7 44 24 04 72 00 00 	movl   $0x72,0x4(%esp)
c01071d8:	00 
c01071d9:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c01071e0:	e8 d3 9a ff ff       	call   c0100cb8 <__panic>
    cprintf("write Virt Page a in fifo_check_swap\n");
c01071e5:	c7 04 24 28 a6 10 c0 	movl   $0xc010a628,(%esp)
c01071ec:	e8 66 91 ff ff       	call   c0100357 <cprintf>
    assert(*(unsigned char *)0x1000 == 0x0a);
c01071f1:	b8 00 10 00 00       	mov    $0x1000,%eax
c01071f6:	0f b6 00             	movzbl (%eax),%eax
c01071f9:	3c 0a                	cmp    $0xa,%al
c01071fb:	74 24                	je     c0107221 <_fifo_check_swap+0x318>
c01071fd:	c7 44 24 0c 24 a7 10 	movl   $0xc010a724,0xc(%esp)
c0107204:	c0 
c0107205:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c010720c:	c0 
c010720d:	c7 44 24 04 74 00 00 	movl   $0x74,0x4(%esp)
c0107214:	00 
c0107215:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c010721c:	e8 97 9a ff ff       	call   c0100cb8 <__panic>
    *(unsigned char *)0x1000 = 0x0a;
c0107221:	b8 00 10 00 00       	mov    $0x1000,%eax
c0107226:	c6 00 0a             	movb   $0xa,(%eax)
    assert(pgfault_num==11);
c0107229:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c010722e:	83 f8 0b             	cmp    $0xb,%eax
c0107231:	74 24                	je     c0107257 <_fifo_check_swap+0x34e>
c0107233:	c7 44 24 0c 45 a7 10 	movl   $0xc010a745,0xc(%esp)
c010723a:	c0 
c010723b:	c7 44 24 08 9a a5 10 	movl   $0xc010a59a,0x8(%esp)
c0107242:	c0 
c0107243:	c7 44 24 04 76 00 00 	movl   $0x76,0x4(%esp)
c010724a:	00 
c010724b:	c7 04 24 af a5 10 c0 	movl   $0xc010a5af,(%esp)
c0107252:	e8 61 9a ff ff       	call   c0100cb8 <__panic>
    return 0;
c0107257:	b8 00 00 00 00       	mov    $0x0,%eax
}
c010725c:	c9                   	leave  
c010725d:	c3                   	ret    

c010725e <_fifo_init>:


static int
_fifo_init(void)
{
c010725e:	55                   	push   %ebp
c010725f:	89 e5                	mov    %esp,%ebp
    return 0;
c0107261:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107266:	5d                   	pop    %ebp
c0107267:	c3                   	ret    

c0107268 <_fifo_set_unswappable>:

static int
_fifo_set_unswappable(struct mm_struct *mm, uintptr_t addr)
{
c0107268:	55                   	push   %ebp
c0107269:	89 e5                	mov    %esp,%ebp
    return 0;
c010726b:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0107270:	5d                   	pop    %ebp
c0107271:	c3                   	ret    

c0107272 <_fifo_tick_event>:

static int
_fifo_tick_event(struct mm_struct *mm)
{ return 0; }
c0107272:	55                   	push   %ebp
c0107273:	89 e5                	mov    %esp,%ebp
c0107275:	b8 00 00 00 00       	mov    $0x0,%eax
c010727a:	5d                   	pop    %ebp
c010727b:	c3                   	ret    

c010727c <pa2page>:
page2pa(struct Page *page) {
    return page2ppn(page) << PGSHIFT;
}

static inline struct Page *
pa2page(uintptr_t pa) {
c010727c:	55                   	push   %ebp
c010727d:	89 e5                	mov    %esp,%ebp
c010727f:	83 ec 18             	sub    $0x18,%esp
    if (PPN(pa) >= npage) {
c0107282:	8b 45 08             	mov    0x8(%ebp),%eax
c0107285:	89 c2                	mov    %eax,%edx
c0107287:	c1 ea 0c             	shr    $0xc,%edx
c010728a:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010728f:	39 c2                	cmp    %eax,%edx
c0107291:	72 1c                	jb     c01072af <pa2page+0x33>
        panic("pa2page called with invalid pa");
c0107293:	c7 44 24 08 68 a7 10 	movl   $0xc010a768,0x8(%esp)
c010729a:	c0 
c010729b:	c7 44 24 04 5b 00 00 	movl   $0x5b,0x4(%esp)
c01072a2:	00 
c01072a3:	c7 04 24 87 a7 10 c0 	movl   $0xc010a787,(%esp)
c01072aa:	e8 09 9a ff ff       	call   c0100cb8 <__panic>
    }
    return &pages[PPN(pa)];
c01072af:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c01072b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01072b7:	c1 ea 0c             	shr    $0xc,%edx
c01072ba:	c1 e2 05             	shl    $0x5,%edx
c01072bd:	01 d0                	add    %edx,%eax
}
c01072bf:	c9                   	leave  
c01072c0:	c3                   	ret    

c01072c1 <pde2page>:
    }
    return pa2page(PTE_ADDR(pte));
}

static inline struct Page *
pde2page(pde_t pde) {
c01072c1:	55                   	push   %ebp
c01072c2:	89 e5                	mov    %esp,%ebp
c01072c4:	83 ec 18             	sub    $0x18,%esp
    return pa2page(PDE_ADDR(pde));
c01072c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01072ca:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c01072cf:	89 04 24             	mov    %eax,(%esp)
c01072d2:	e8 a5 ff ff ff       	call   c010727c <pa2page>
}
c01072d7:	c9                   	leave  
c01072d8:	c3                   	ret    

c01072d9 <mm_create>:
static void check_vma_struct(void);
static void check_pgfault(void);

// mm_create -  alloc a mm_struct & initialize it.
struct mm_struct *
mm_create(void) {
c01072d9:	55                   	push   %ebp
c01072da:	89 e5                	mov    %esp,%ebp
c01072dc:	83 ec 28             	sub    $0x28,%esp
    struct mm_struct *mm = kmalloc(sizeof(struct mm_struct));
c01072df:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c01072e6:	e8 ff ec ff ff       	call   c0105fea <kmalloc>
c01072eb:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (mm != NULL) {
c01072ee:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01072f2:	74 58                	je     c010734c <mm_create+0x73>
        list_init(&(mm->mmap_list));
c01072f4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01072f7:	89 45 f0             	mov    %eax,-0x10(%ebp)
 * list_init - initialize a new entry
 * @elm:        new entry to be initialized
 * */
static inline void
list_init(list_entry_t *elm) {
    elm->prev = elm->next = elm;
c01072fa:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01072fd:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107300:	89 50 04             	mov    %edx,0x4(%eax)
c0107303:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107306:	8b 50 04             	mov    0x4(%eax),%edx
c0107309:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010730c:	89 10                	mov    %edx,(%eax)
        mm->mmap_cache = NULL;
c010730e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107311:	c7 40 08 00 00 00 00 	movl   $0x0,0x8(%eax)
        mm->pgdir = NULL;
c0107318:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010731b:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
        mm->map_count = 0;
c0107322:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107325:	c7 40 10 00 00 00 00 	movl   $0x0,0x10(%eax)

        if (swap_init_ok) swap_init_mm(mm);
c010732c:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0107331:	85 c0                	test   %eax,%eax
c0107333:	74 0d                	je     c0107342 <mm_create+0x69>
c0107335:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107338:	89 04 24             	mov    %eax,(%esp)
c010733b:	e8 f7 ee ff ff       	call   c0106237 <swap_init_mm>
c0107340:	eb 0a                	jmp    c010734c <mm_create+0x73>
        else mm->sm_priv = NULL;
c0107342:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107345:	c7 40 14 00 00 00 00 	movl   $0x0,0x14(%eax)
    }
    return mm;
c010734c:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010734f:	c9                   	leave  
c0107350:	c3                   	ret    

c0107351 <vma_create>:

// vma_create - alloc a vma_struct & initialize it. (addr range: vm_start~vm_end)
struct vma_struct *
vma_create(uintptr_t vm_start, uintptr_t vm_end, uint32_t vm_flags) {
c0107351:	55                   	push   %ebp
c0107352:	89 e5                	mov    %esp,%ebp
c0107354:	83 ec 28             	sub    $0x28,%esp
    struct vma_struct *vma = kmalloc(sizeof(struct vma_struct));
c0107357:	c7 04 24 18 00 00 00 	movl   $0x18,(%esp)
c010735e:	e8 87 ec ff ff       	call   c0105fea <kmalloc>
c0107363:	89 45 f4             	mov    %eax,-0xc(%ebp)

    if (vma != NULL) {
c0107366:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c010736a:	74 1b                	je     c0107387 <vma_create+0x36>
        vma->vm_start = vm_start;
c010736c:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010736f:	8b 55 08             	mov    0x8(%ebp),%edx
c0107372:	89 50 04             	mov    %edx,0x4(%eax)
        vma->vm_end = vm_end;
c0107375:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107378:	8b 55 0c             	mov    0xc(%ebp),%edx
c010737b:	89 50 08             	mov    %edx,0x8(%eax)
        vma->vm_flags = vm_flags;
c010737e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107381:	8b 55 10             	mov    0x10(%ebp),%edx
c0107384:	89 50 0c             	mov    %edx,0xc(%eax)
    }
    return vma;
c0107387:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010738a:	c9                   	leave  
c010738b:	c3                   	ret    

c010738c <find_vma>:


// find_vma - find a vma  (vma->vm_start <= addr <= vma_vm_end)
struct vma_struct *
find_vma(struct mm_struct *mm, uintptr_t addr) {
c010738c:	55                   	push   %ebp
c010738d:	89 e5                	mov    %esp,%ebp
c010738f:	83 ec 20             	sub    $0x20,%esp
    struct vma_struct *vma = NULL;
c0107392:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    if (mm != NULL) {
c0107399:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c010739d:	0f 84 95 00 00 00    	je     c0107438 <find_vma+0xac>
        vma = mm->mmap_cache;
c01073a3:	8b 45 08             	mov    0x8(%ebp),%eax
c01073a6:	8b 40 08             	mov    0x8(%eax),%eax
c01073a9:	89 45 fc             	mov    %eax,-0x4(%ebp)
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
c01073ac:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c01073b0:	74 16                	je     c01073c8 <find_vma+0x3c>
c01073b2:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073b5:	8b 40 04             	mov    0x4(%eax),%eax
c01073b8:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01073bb:	77 0b                	ja     c01073c8 <find_vma+0x3c>
c01073bd:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073c0:	8b 40 08             	mov    0x8(%eax),%eax
c01073c3:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01073c6:	77 61                	ja     c0107429 <find_vma+0x9d>
                bool found = 0;
c01073c8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)
                list_entry_t *list = &(mm->mmap_list), *le = list;
c01073cf:	8b 45 08             	mov    0x8(%ebp),%eax
c01073d2:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01073d5:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01073d8:	89 45 f4             	mov    %eax,-0xc(%ebp)
                while ((le = list_next(le)) != list) {
c01073db:	eb 28                	jmp    c0107405 <find_vma+0x79>
                    vma = le2vma(le, list_link);
c01073dd:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01073e0:	83 e8 10             	sub    $0x10,%eax
c01073e3:	89 45 fc             	mov    %eax,-0x4(%ebp)
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
c01073e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073e9:	8b 40 04             	mov    0x4(%eax),%eax
c01073ec:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01073ef:	77 14                	ja     c0107405 <find_vma+0x79>
c01073f1:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01073f4:	8b 40 08             	mov    0x8(%eax),%eax
c01073f7:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01073fa:	76 09                	jbe    c0107405 <find_vma+0x79>
                        found = 1;
c01073fc:	c7 45 f8 01 00 00 00 	movl   $0x1,-0x8(%ebp)
                        break;
c0107403:	eb 17                	jmp    c010741c <find_vma+0x90>
c0107405:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107408:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c010740b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010740e:	8b 40 04             	mov    0x4(%eax),%eax
    if (mm != NULL) {
        vma = mm->mmap_cache;
        if (!(vma != NULL && vma->vm_start <= addr && vma->vm_end > addr)) {
                bool found = 0;
                list_entry_t *list = &(mm->mmap_list), *le = list;
                while ((le = list_next(le)) != list) {
c0107411:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0107414:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107417:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010741a:	75 c1                	jne    c01073dd <find_vma+0x51>
                    if (vma->vm_start<=addr && addr < vma->vm_end) {
                        found = 1;
                        break;
                    }
                }
                if (!found) {
c010741c:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
c0107420:	75 07                	jne    c0107429 <find_vma+0x9d>
                    vma = NULL;
c0107422:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
                }
        }
        if (vma != NULL) {
c0107429:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c010742d:	74 09                	je     c0107438 <find_vma+0xac>
            mm->mmap_cache = vma;
c010742f:	8b 45 08             	mov    0x8(%ebp),%eax
c0107432:	8b 55 fc             	mov    -0x4(%ebp),%edx
c0107435:	89 50 08             	mov    %edx,0x8(%eax)
        }
    }
    return vma;
c0107438:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c010743b:	c9                   	leave  
c010743c:	c3                   	ret    

c010743d <check_vma_overlap>:


// check_vma_overlap - check if vma1 overlaps vma2 ?
static inline void
check_vma_overlap(struct vma_struct *prev, struct vma_struct *next) {
c010743d:	55                   	push   %ebp
c010743e:	89 e5                	mov    %esp,%ebp
c0107440:	83 ec 18             	sub    $0x18,%esp
    assert(prev->vm_start < prev->vm_end);
c0107443:	8b 45 08             	mov    0x8(%ebp),%eax
c0107446:	8b 50 04             	mov    0x4(%eax),%edx
c0107449:	8b 45 08             	mov    0x8(%ebp),%eax
c010744c:	8b 40 08             	mov    0x8(%eax),%eax
c010744f:	39 c2                	cmp    %eax,%edx
c0107451:	72 24                	jb     c0107477 <check_vma_overlap+0x3a>
c0107453:	c7 44 24 0c 95 a7 10 	movl   $0xc010a795,0xc(%esp)
c010745a:	c0 
c010745b:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107462:	c0 
c0107463:	c7 44 24 04 67 00 00 	movl   $0x67,0x4(%esp)
c010746a:	00 
c010746b:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107472:	e8 41 98 ff ff       	call   c0100cb8 <__panic>
    assert(prev->vm_end <= next->vm_start);
c0107477:	8b 45 08             	mov    0x8(%ebp),%eax
c010747a:	8b 50 08             	mov    0x8(%eax),%edx
c010747d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107480:	8b 40 04             	mov    0x4(%eax),%eax
c0107483:	39 c2                	cmp    %eax,%edx
c0107485:	76 24                	jbe    c01074ab <check_vma_overlap+0x6e>
c0107487:	c7 44 24 0c d8 a7 10 	movl   $0xc010a7d8,0xc(%esp)
c010748e:	c0 
c010748f:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107496:	c0 
c0107497:	c7 44 24 04 68 00 00 	movl   $0x68,0x4(%esp)
c010749e:	00 
c010749f:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c01074a6:	e8 0d 98 ff ff       	call   c0100cb8 <__panic>
    assert(next->vm_start < next->vm_end);
c01074ab:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074ae:	8b 50 04             	mov    0x4(%eax),%edx
c01074b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074b4:	8b 40 08             	mov    0x8(%eax),%eax
c01074b7:	39 c2                	cmp    %eax,%edx
c01074b9:	72 24                	jb     c01074df <check_vma_overlap+0xa2>
c01074bb:	c7 44 24 0c f7 a7 10 	movl   $0xc010a7f7,0xc(%esp)
c01074c2:	c0 
c01074c3:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c01074ca:	c0 
c01074cb:	c7 44 24 04 69 00 00 	movl   $0x69,0x4(%esp)
c01074d2:	00 
c01074d3:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c01074da:	e8 d9 97 ff ff       	call   c0100cb8 <__panic>
}
c01074df:	c9                   	leave  
c01074e0:	c3                   	ret    

c01074e1 <insert_vma_struct>:


// insert_vma_struct -insert vma in mm's list link
void
insert_vma_struct(struct mm_struct *mm, struct vma_struct *vma) {
c01074e1:	55                   	push   %ebp
c01074e2:	89 e5                	mov    %esp,%ebp
c01074e4:	83 ec 48             	sub    $0x48,%esp
    assert(vma->vm_start < vma->vm_end);
c01074e7:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074ea:	8b 50 04             	mov    0x4(%eax),%edx
c01074ed:	8b 45 0c             	mov    0xc(%ebp),%eax
c01074f0:	8b 40 08             	mov    0x8(%eax),%eax
c01074f3:	39 c2                	cmp    %eax,%edx
c01074f5:	72 24                	jb     c010751b <insert_vma_struct+0x3a>
c01074f7:	c7 44 24 0c 15 a8 10 	movl   $0xc010a815,0xc(%esp)
c01074fe:	c0 
c01074ff:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107506:	c0 
c0107507:	c7 44 24 04 70 00 00 	movl   $0x70,0x4(%esp)
c010750e:	00 
c010750f:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107516:	e8 9d 97 ff ff       	call   c0100cb8 <__panic>
    list_entry_t *list = &(mm->mmap_list);
c010751b:	8b 45 08             	mov    0x8(%ebp),%eax
c010751e:	89 45 ec             	mov    %eax,-0x14(%ebp)
    list_entry_t *le_prev = list, *le_next;
c0107521:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107524:	89 45 f4             	mov    %eax,-0xc(%ebp)

        list_entry_t *le = list;
c0107527:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010752a:	89 45 f0             	mov    %eax,-0x10(%ebp)
        while ((le = list_next(le)) != list) {
c010752d:	eb 1f                	jmp    c010754e <insert_vma_struct+0x6d>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
c010752f:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107532:	83 e8 10             	sub    $0x10,%eax
c0107535:	89 45 e8             	mov    %eax,-0x18(%ebp)
            if (mmap_prev->vm_start > vma->vm_start) {
c0107538:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010753b:	8b 50 04             	mov    0x4(%eax),%edx
c010753e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107541:	8b 40 04             	mov    0x4(%eax),%eax
c0107544:	39 c2                	cmp    %eax,%edx
c0107546:	77 1f                	ja     c0107567 <insert_vma_struct+0x86>
                break;
            }
            le_prev = le;
c0107548:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010754b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010754e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107551:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0107554:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107557:	8b 40 04             	mov    0x4(%eax),%eax
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c010755a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010755d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107560:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107563:	75 ca                	jne    c010752f <insert_vma_struct+0x4e>
c0107565:	eb 01                	jmp    c0107568 <insert_vma_struct+0x87>
            struct vma_struct *mmap_prev = le2vma(le, list_link);
            if (mmap_prev->vm_start > vma->vm_start) {
                break;
c0107567:	90                   	nop
    assert(vma->vm_start < vma->vm_end);
    list_entry_t *list = &(mm->mmap_list);
    list_entry_t *le_prev = list, *le_next;

        list_entry_t *le = list;
        while ((le = list_next(le)) != list) {
c0107568:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010756b:	89 45 dc             	mov    %eax,-0x24(%ebp)
c010756e:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107571:	8b 40 04             	mov    0x4(%eax),%eax
                break;
            }
            le_prev = le;
        }

    le_next = list_next(le_prev);
c0107574:	89 45 e4             	mov    %eax,-0x1c(%ebp)

    /* check overlap */
    if (le_prev != list) {
c0107577:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010757a:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010757d:	74 15                	je     c0107594 <insert_vma_struct+0xb3>
        check_vma_overlap(le2vma(le_prev, list_link), vma);
c010757f:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107582:	8d 50 f0             	lea    -0x10(%eax),%edx
c0107585:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107588:	89 44 24 04          	mov    %eax,0x4(%esp)
c010758c:	89 14 24             	mov    %edx,(%esp)
c010758f:	e8 a9 fe ff ff       	call   c010743d <check_vma_overlap>
    }
    if (le_next != list) {
c0107594:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107597:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c010759a:	74 15                	je     c01075b1 <insert_vma_struct+0xd0>
        check_vma_overlap(vma, le2vma(le_next, list_link));
c010759c:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010759f:	83 e8 10             	sub    $0x10,%eax
c01075a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01075a6:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075a9:	89 04 24             	mov    %eax,(%esp)
c01075ac:	e8 8c fe ff ff       	call   c010743d <check_vma_overlap>
    }

    vma->vm_mm = mm;
c01075b1:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075b4:	8b 55 08             	mov    0x8(%ebp),%edx
c01075b7:	89 10                	mov    %edx,(%eax)
    list_add_after(le_prev, &(vma->list_link));
c01075b9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01075bc:	8d 50 10             	lea    0x10(%eax),%edx
c01075bf:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01075c2:	89 45 d8             	mov    %eax,-0x28(%ebp)
c01075c5:	89 55 d4             	mov    %edx,-0x2c(%ebp)
 * Insert the new element @elm *after* the element @listelm which
 * is already in the list.
 * */
static inline void
list_add_after(list_entry_t *listelm, list_entry_t *elm) {
    __list_add(elm, listelm, listelm->next);
c01075c8:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01075cb:	8b 40 04             	mov    0x4(%eax),%eax
c01075ce:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01075d1:	89 55 d0             	mov    %edx,-0x30(%ebp)
c01075d4:	8b 55 d8             	mov    -0x28(%ebp),%edx
c01075d7:	89 55 cc             	mov    %edx,-0x34(%ebp)
c01075da:	89 45 c8             	mov    %eax,-0x38(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_add(list_entry_t *elm, list_entry_t *prev, list_entry_t *next) {
    prev->next = next->prev = elm;
c01075dd:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01075e0:	8b 55 d0             	mov    -0x30(%ebp),%edx
c01075e3:	89 10                	mov    %edx,(%eax)
c01075e5:	8b 45 c8             	mov    -0x38(%ebp),%eax
c01075e8:	8b 10                	mov    (%eax),%edx
c01075ea:	8b 45 cc             	mov    -0x34(%ebp),%eax
c01075ed:	89 50 04             	mov    %edx,0x4(%eax)
    elm->next = next;
c01075f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01075f3:	8b 55 c8             	mov    -0x38(%ebp),%edx
c01075f6:	89 50 04             	mov    %edx,0x4(%eax)
    elm->prev = prev;
c01075f9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01075fc:	8b 55 cc             	mov    -0x34(%ebp),%edx
c01075ff:	89 10                	mov    %edx,(%eax)

    mm->map_count ++;
c0107601:	8b 45 08             	mov    0x8(%ebp),%eax
c0107604:	8b 40 10             	mov    0x10(%eax),%eax
c0107607:	8d 50 01             	lea    0x1(%eax),%edx
c010760a:	8b 45 08             	mov    0x8(%ebp),%eax
c010760d:	89 50 10             	mov    %edx,0x10(%eax)
}
c0107610:	c9                   	leave  
c0107611:	c3                   	ret    

c0107612 <mm_destroy>:

// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {
c0107612:	55                   	push   %ebp
c0107613:	89 e5                	mov    %esp,%ebp
c0107615:	83 ec 38             	sub    $0x38,%esp

    list_entry_t *list = &(mm->mmap_list), *le;
c0107618:	8b 45 08             	mov    0x8(%ebp),%eax
c010761b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    while ((le = list_next(list)) != list) {
c010761e:	eb 3e                	jmp    c010765e <mm_destroy+0x4c>
c0107620:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107623:	89 45 ec             	mov    %eax,-0x14(%ebp)
 * Note: list_empty() on @listelm does not return true after this, the entry is
 * in an undefined state.
 * */
static inline void
list_del(list_entry_t *listelm) {
    __list_del(listelm->prev, listelm->next);
c0107626:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107629:	8b 40 04             	mov    0x4(%eax),%eax
c010762c:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010762f:	8b 12                	mov    (%edx),%edx
c0107631:	89 55 e8             	mov    %edx,-0x18(%ebp)
c0107634:	89 45 e4             	mov    %eax,-0x1c(%ebp)
 * This is only for internal list manipulation where we know
 * the prev/next entries already!
 * */
static inline void
__list_del(list_entry_t *prev, list_entry_t *next) {
    prev->next = next;
c0107637:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010763a:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010763d:	89 50 04             	mov    %edx,0x4(%eax)
    next->prev = prev;
c0107640:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107643:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0107646:	89 10                	mov    %edx,(%eax)
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
c0107648:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010764b:	83 e8 10             	sub    $0x10,%eax
c010764e:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c0107655:	00 
c0107656:	89 04 24             	mov    %eax,(%esp)
c0107659:	e8 2c ea ff ff       	call   c010608a <kfree>
c010765e:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107661:	89 45 e0             	mov    %eax,-0x20(%ebp)
 * list_next - get the next entry
 * @listelm:    the list head
 **/
static inline list_entry_t *
list_next(list_entry_t *listelm) {
    return listelm->next;
c0107664:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107667:	8b 40 04             	mov    0x4(%eax),%eax
// mm_destroy - free mm and mm internal fields
void
mm_destroy(struct mm_struct *mm) {

    list_entry_t *list = &(mm->mmap_list), *le;
    while ((le = list_next(list)) != list) {
c010766a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010766d:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107670:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107673:	75 ab                	jne    c0107620 <mm_destroy+0xe>
        list_del(le);
        kfree(le2vma(le, list_link),sizeof(struct vma_struct));  //kfree vma        
    }
    kfree(mm, sizeof(struct mm_struct)); //kfree mm
c0107675:	c7 44 24 04 18 00 00 	movl   $0x18,0x4(%esp)
c010767c:	00 
c010767d:	8b 45 08             	mov    0x8(%ebp),%eax
c0107680:	89 04 24             	mov    %eax,(%esp)
c0107683:	e8 02 ea ff ff       	call   c010608a <kfree>
    mm=NULL;
c0107688:	c7 45 08 00 00 00 00 	movl   $0x0,0x8(%ebp)
}
c010768f:	c9                   	leave  
c0107690:	c3                   	ret    

c0107691 <vmm_init>:

// vmm_init - initialize virtual memory management
//          - now just call check_vmm to check correctness of vmm
void
vmm_init(void) {
c0107691:	55                   	push   %ebp
c0107692:	89 e5                	mov    %esp,%ebp
c0107694:	83 ec 08             	sub    $0x8,%esp
    check_vmm();
c0107697:	e8 02 00 00 00       	call   c010769e <check_vmm>
}
c010769c:	c9                   	leave  
c010769d:	c3                   	ret    

c010769e <check_vmm>:

// check_vmm - check correctness of vmm
static void
check_vmm(void) {
c010769e:	55                   	push   %ebp
c010769f:	89 e5                	mov    %esp,%ebp
c01076a1:	83 ec 28             	sub    $0x28,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01076a4:	e8 9b d1 ff ff       	call   c0104844 <nr_free_pages>
c01076a9:	89 45 f4             	mov    %eax,-0xc(%ebp)
    
    check_vma_struct();
c01076ac:	e8 41 00 00 00       	call   c01076f2 <check_vma_struct>
    check_pgfault();
c01076b1:	e8 03 05 00 00       	call   c0107bb9 <check_pgfault>

    assert(nr_free_pages_store == nr_free_pages());
c01076b6:	e8 89 d1 ff ff       	call   c0104844 <nr_free_pages>
c01076bb:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c01076be:	74 24                	je     c01076e4 <check_vmm+0x46>
c01076c0:	c7 44 24 0c 34 a8 10 	movl   $0xc010a834,0xc(%esp)
c01076c7:	c0 
c01076c8:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c01076cf:	c0 
c01076d0:	c7 44 24 04 a9 00 00 	movl   $0xa9,0x4(%esp)
c01076d7:	00 
c01076d8:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c01076df:	e8 d4 95 ff ff       	call   c0100cb8 <__panic>

    cprintf("check_vmm() succeeded.\n");
c01076e4:	c7 04 24 5b a8 10 c0 	movl   $0xc010a85b,(%esp)
c01076eb:	e8 67 8c ff ff       	call   c0100357 <cprintf>
}
c01076f0:	c9                   	leave  
c01076f1:	c3                   	ret    

c01076f2 <check_vma_struct>:

static void
check_vma_struct(void) {
c01076f2:	55                   	push   %ebp
c01076f3:	89 e5                	mov    %esp,%ebp
c01076f5:	83 ec 68             	sub    $0x68,%esp
    size_t nr_free_pages_store = nr_free_pages();
c01076f8:	e8 47 d1 ff ff       	call   c0104844 <nr_free_pages>
c01076fd:	89 45 ec             	mov    %eax,-0x14(%ebp)

    struct mm_struct *mm = mm_create();
c0107700:	e8 d4 fb ff ff       	call   c01072d9 <mm_create>
c0107705:	89 45 e8             	mov    %eax,-0x18(%ebp)
    assert(mm != NULL);
c0107708:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010770c:	75 24                	jne    c0107732 <check_vma_struct+0x40>
c010770e:	c7 44 24 0c 73 a8 10 	movl   $0xc010a873,0xc(%esp)
c0107715:	c0 
c0107716:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c010771d:	c0 
c010771e:	c7 44 24 04 b3 00 00 	movl   $0xb3,0x4(%esp)
c0107725:	00 
c0107726:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c010772d:	e8 86 95 ff ff       	call   c0100cb8 <__panic>

    int step1 = 10, step2 = step1 * 10;
c0107732:	c7 45 e4 0a 00 00 00 	movl   $0xa,-0x1c(%ebp)
c0107739:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010773c:	89 d0                	mov    %edx,%eax
c010773e:	c1 e0 02             	shl    $0x2,%eax
c0107741:	01 d0                	add    %edx,%eax
c0107743:	01 c0                	add    %eax,%eax
c0107745:	89 45 e0             	mov    %eax,-0x20(%ebp)

    int i;
    for (i = step1; i >= 1; i --) {
c0107748:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c010774b:	89 45 f4             	mov    %eax,-0xc(%ebp)
c010774e:	eb 70                	jmp    c01077c0 <check_vma_struct+0xce>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c0107750:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107753:	89 d0                	mov    %edx,%eax
c0107755:	c1 e0 02             	shl    $0x2,%eax
c0107758:	01 d0                	add    %edx,%eax
c010775a:	83 c0 02             	add    $0x2,%eax
c010775d:	89 c1                	mov    %eax,%ecx
c010775f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107762:	89 d0                	mov    %edx,%eax
c0107764:	c1 e0 02             	shl    $0x2,%eax
c0107767:	01 d0                	add    %edx,%eax
c0107769:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c0107770:	00 
c0107771:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c0107775:	89 04 24             	mov    %eax,(%esp)
c0107778:	e8 d4 fb ff ff       	call   c0107351 <vma_create>
c010777d:	89 45 dc             	mov    %eax,-0x24(%ebp)
        assert(vma != NULL);
c0107780:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c0107784:	75 24                	jne    c01077aa <check_vma_struct+0xb8>
c0107786:	c7 44 24 0c 7e a8 10 	movl   $0xc010a87e,0xc(%esp)
c010778d:	c0 
c010778e:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107795:	c0 
c0107796:	c7 44 24 04 ba 00 00 	movl   $0xba,0x4(%esp)
c010779d:	00 
c010779e:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c01077a5:	e8 0e 95 ff ff       	call   c0100cb8 <__panic>
        insert_vma_struct(mm, vma);
c01077aa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c01077ad:	89 44 24 04          	mov    %eax,0x4(%esp)
c01077b1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01077b4:	89 04 24             	mov    %eax,(%esp)
c01077b7:	e8 25 fd ff ff       	call   c01074e1 <insert_vma_struct>
    assert(mm != NULL);

    int step1 = 10, step2 = step1 * 10;

    int i;
    for (i = step1; i >= 1; i --) {
c01077bc:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c01077c0:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c01077c4:	7f 8a                	jg     c0107750 <check_vma_struct+0x5e>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c01077c6:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01077c9:	83 c0 01             	add    $0x1,%eax
c01077cc:	89 45 f4             	mov    %eax,-0xc(%ebp)
c01077cf:	eb 70                	jmp    c0107841 <check_vma_struct+0x14f>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
c01077d1:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01077d4:	89 d0                	mov    %edx,%eax
c01077d6:	c1 e0 02             	shl    $0x2,%eax
c01077d9:	01 d0                	add    %edx,%eax
c01077db:	83 c0 02             	add    $0x2,%eax
c01077de:	89 c1                	mov    %eax,%ecx
c01077e0:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01077e3:	89 d0                	mov    %edx,%eax
c01077e5:	c1 e0 02             	shl    $0x2,%eax
c01077e8:	01 d0                	add    %edx,%eax
c01077ea:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
c01077f1:	00 
c01077f2:	89 4c 24 04          	mov    %ecx,0x4(%esp)
c01077f6:	89 04 24             	mov    %eax,(%esp)
c01077f9:	e8 53 fb ff ff       	call   c0107351 <vma_create>
c01077fe:	89 45 d8             	mov    %eax,-0x28(%ebp)
        assert(vma != NULL);
c0107801:	83 7d d8 00          	cmpl   $0x0,-0x28(%ebp)
c0107805:	75 24                	jne    c010782b <check_vma_struct+0x139>
c0107807:	c7 44 24 0c 7e a8 10 	movl   $0xc010a87e,0xc(%esp)
c010780e:	c0 
c010780f:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107816:	c0 
c0107817:	c7 44 24 04 c0 00 00 	movl   $0xc0,0x4(%esp)
c010781e:	00 
c010781f:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107826:	e8 8d 94 ff ff       	call   c0100cb8 <__panic>
        insert_vma_struct(mm, vma);
c010782b:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010782e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107832:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107835:	89 04 24             	mov    %eax,(%esp)
c0107838:	e8 a4 fc ff ff       	call   c01074e1 <insert_vma_struct>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    for (i = step1 + 1; i <= step2; i ++) {
c010783d:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107841:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107844:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107847:	7e 88                	jle    c01077d1 <check_vma_struct+0xdf>
        struct vma_struct *vma = vma_create(i * 5, i * 5 + 2, 0);
        assert(vma != NULL);
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));
c0107849:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010784c:	89 45 b8             	mov    %eax,-0x48(%ebp)
c010784f:	8b 45 b8             	mov    -0x48(%ebp),%eax
c0107852:	8b 40 04             	mov    0x4(%eax),%eax
c0107855:	89 45 f0             	mov    %eax,-0x10(%ebp)

    for (i = 1; i <= step2; i ++) {
c0107858:	c7 45 f4 01 00 00 00 	movl   $0x1,-0xc(%ebp)
c010785f:	e9 97 00 00 00       	jmp    c01078fb <check_vma_struct+0x209>
        assert(le != &(mm->mmap_list));
c0107864:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107867:	3b 45 f0             	cmp    -0x10(%ebp),%eax
c010786a:	75 24                	jne    c0107890 <check_vma_struct+0x19e>
c010786c:	c7 44 24 0c 8a a8 10 	movl   $0xc010a88a,0xc(%esp)
c0107873:	c0 
c0107874:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c010787b:	c0 
c010787c:	c7 44 24 04 c7 00 00 	movl   $0xc7,0x4(%esp)
c0107883:	00 
c0107884:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c010788b:	e8 28 94 ff ff       	call   c0100cb8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
c0107890:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0107893:	83 e8 10             	sub    $0x10,%eax
c0107896:	89 45 d4             	mov    %eax,-0x2c(%ebp)
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
c0107899:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c010789c:	8b 48 04             	mov    0x4(%eax),%ecx
c010789f:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01078a2:	89 d0                	mov    %edx,%eax
c01078a4:	c1 e0 02             	shl    $0x2,%eax
c01078a7:	01 d0                	add    %edx,%eax
c01078a9:	39 c1                	cmp    %eax,%ecx
c01078ab:	75 17                	jne    c01078c4 <check_vma_struct+0x1d2>
c01078ad:	8b 45 d4             	mov    -0x2c(%ebp),%eax
c01078b0:	8b 48 08             	mov    0x8(%eax),%ecx
c01078b3:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01078b6:	89 d0                	mov    %edx,%eax
c01078b8:	c1 e0 02             	shl    $0x2,%eax
c01078bb:	01 d0                	add    %edx,%eax
c01078bd:	83 c0 02             	add    $0x2,%eax
c01078c0:	39 c1                	cmp    %eax,%ecx
c01078c2:	74 24                	je     c01078e8 <check_vma_struct+0x1f6>
c01078c4:	c7 44 24 0c a4 a8 10 	movl   $0xc010a8a4,0xc(%esp)
c01078cb:	c0 
c01078cc:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c01078d3:	c0 
c01078d4:	c7 44 24 04 c9 00 00 	movl   $0xc9,0x4(%esp)
c01078db:	00 
c01078dc:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c01078e3:	e8 d0 93 ff ff       	call   c0100cb8 <__panic>
c01078e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
c01078eb:	89 45 b4             	mov    %eax,-0x4c(%ebp)
c01078ee:	8b 45 b4             	mov    -0x4c(%ebp),%eax
c01078f1:	8b 40 04             	mov    0x4(%eax),%eax
        le = list_next(le);
c01078f4:	89 45 f0             	mov    %eax,-0x10(%ebp)
        insert_vma_struct(mm, vma);
    }

    list_entry_t *le = list_next(&(mm->mmap_list));

    for (i = 1; i <= step2; i ++) {
c01078f7:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c01078fb:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01078fe:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107901:	0f 8e 5d ff ff ff    	jle    c0107864 <check_vma_struct+0x172>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107907:	c7 45 f4 05 00 00 00 	movl   $0x5,-0xc(%ebp)
c010790e:	e9 cd 01 00 00       	jmp    c0107ae0 <check_vma_struct+0x3ee>
        struct vma_struct *vma1 = find_vma(mm, i);
c0107913:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107916:	89 44 24 04          	mov    %eax,0x4(%esp)
c010791a:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010791d:	89 04 24             	mov    %eax,(%esp)
c0107920:	e8 67 fa ff ff       	call   c010738c <find_vma>
c0107925:	89 45 d0             	mov    %eax,-0x30(%ebp)
        assert(vma1 != NULL);
c0107928:	83 7d d0 00          	cmpl   $0x0,-0x30(%ebp)
c010792c:	75 24                	jne    c0107952 <check_vma_struct+0x260>
c010792e:	c7 44 24 0c d9 a8 10 	movl   $0xc010a8d9,0xc(%esp)
c0107935:	c0 
c0107936:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c010793d:	c0 
c010793e:	c7 44 24 04 cf 00 00 	movl   $0xcf,0x4(%esp)
c0107945:	00 
c0107946:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c010794d:	e8 66 93 ff ff       	call   c0100cb8 <__panic>
        struct vma_struct *vma2 = find_vma(mm, i+1);
c0107952:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107955:	83 c0 01             	add    $0x1,%eax
c0107958:	89 44 24 04          	mov    %eax,0x4(%esp)
c010795c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c010795f:	89 04 24             	mov    %eax,(%esp)
c0107962:	e8 25 fa ff ff       	call   c010738c <find_vma>
c0107967:	89 45 cc             	mov    %eax,-0x34(%ebp)
        assert(vma2 != NULL);
c010796a:	83 7d cc 00          	cmpl   $0x0,-0x34(%ebp)
c010796e:	75 24                	jne    c0107994 <check_vma_struct+0x2a2>
c0107970:	c7 44 24 0c e6 a8 10 	movl   $0xc010a8e6,0xc(%esp)
c0107977:	c0 
c0107978:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c010797f:	c0 
c0107980:	c7 44 24 04 d1 00 00 	movl   $0xd1,0x4(%esp)
c0107987:	00 
c0107988:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c010798f:	e8 24 93 ff ff       	call   c0100cb8 <__panic>
        struct vma_struct *vma3 = find_vma(mm, i+2);
c0107994:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107997:	83 c0 02             	add    $0x2,%eax
c010799a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010799e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079a1:	89 04 24             	mov    %eax,(%esp)
c01079a4:	e8 e3 f9 ff ff       	call   c010738c <find_vma>
c01079a9:	89 45 c8             	mov    %eax,-0x38(%ebp)
        assert(vma3 == NULL);
c01079ac:	83 7d c8 00          	cmpl   $0x0,-0x38(%ebp)
c01079b0:	74 24                	je     c01079d6 <check_vma_struct+0x2e4>
c01079b2:	c7 44 24 0c f3 a8 10 	movl   $0xc010a8f3,0xc(%esp)
c01079b9:	c0 
c01079ba:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c01079c1:	c0 
c01079c2:	c7 44 24 04 d3 00 00 	movl   $0xd3,0x4(%esp)
c01079c9:	00 
c01079ca:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c01079d1:	e8 e2 92 ff ff       	call   c0100cb8 <__panic>
        struct vma_struct *vma4 = find_vma(mm, i+3);
c01079d6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01079d9:	83 c0 03             	add    $0x3,%eax
c01079dc:	89 44 24 04          	mov    %eax,0x4(%esp)
c01079e0:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01079e3:	89 04 24             	mov    %eax,(%esp)
c01079e6:	e8 a1 f9 ff ff       	call   c010738c <find_vma>
c01079eb:	89 45 c4             	mov    %eax,-0x3c(%ebp)
        assert(vma4 == NULL);
c01079ee:	83 7d c4 00          	cmpl   $0x0,-0x3c(%ebp)
c01079f2:	74 24                	je     c0107a18 <check_vma_struct+0x326>
c01079f4:	c7 44 24 0c 00 a9 10 	movl   $0xc010a900,0xc(%esp)
c01079fb:	c0 
c01079fc:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107a03:	c0 
c0107a04:	c7 44 24 04 d5 00 00 	movl   $0xd5,0x4(%esp)
c0107a0b:	00 
c0107a0c:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107a13:	e8 a0 92 ff ff       	call   c0100cb8 <__panic>
        struct vma_struct *vma5 = find_vma(mm, i+4);
c0107a18:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a1b:	83 c0 04             	add    $0x4,%eax
c0107a1e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107a22:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107a25:	89 04 24             	mov    %eax,(%esp)
c0107a28:	e8 5f f9 ff ff       	call   c010738c <find_vma>
c0107a2d:	89 45 c0             	mov    %eax,-0x40(%ebp)
        assert(vma5 == NULL);
c0107a30:	83 7d c0 00          	cmpl   $0x0,-0x40(%ebp)
c0107a34:	74 24                	je     c0107a5a <check_vma_struct+0x368>
c0107a36:	c7 44 24 0c 0d a9 10 	movl   $0xc010a90d,0xc(%esp)
c0107a3d:	c0 
c0107a3e:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107a45:	c0 
c0107a46:	c7 44 24 04 d7 00 00 	movl   $0xd7,0x4(%esp)
c0107a4d:	00 
c0107a4e:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107a55:	e8 5e 92 ff ff       	call   c0100cb8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
c0107a5a:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107a5d:	8b 50 04             	mov    0x4(%eax),%edx
c0107a60:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a63:	39 c2                	cmp    %eax,%edx
c0107a65:	75 10                	jne    c0107a77 <check_vma_struct+0x385>
c0107a67:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0107a6a:	8b 50 08             	mov    0x8(%eax),%edx
c0107a6d:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107a70:	83 c0 02             	add    $0x2,%eax
c0107a73:	39 c2                	cmp    %eax,%edx
c0107a75:	74 24                	je     c0107a9b <check_vma_struct+0x3a9>
c0107a77:	c7 44 24 0c 1c a9 10 	movl   $0xc010a91c,0xc(%esp)
c0107a7e:	c0 
c0107a7f:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107a86:	c0 
c0107a87:	c7 44 24 04 d9 00 00 	movl   $0xd9,0x4(%esp)
c0107a8e:	00 
c0107a8f:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107a96:	e8 1d 92 ff ff       	call   c0100cb8 <__panic>
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
c0107a9b:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107a9e:	8b 50 04             	mov    0x4(%eax),%edx
c0107aa1:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107aa4:	39 c2                	cmp    %eax,%edx
c0107aa6:	75 10                	jne    c0107ab8 <check_vma_struct+0x3c6>
c0107aa8:	8b 45 cc             	mov    -0x34(%ebp),%eax
c0107aab:	8b 50 08             	mov    0x8(%eax),%edx
c0107aae:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107ab1:	83 c0 02             	add    $0x2,%eax
c0107ab4:	39 c2                	cmp    %eax,%edx
c0107ab6:	74 24                	je     c0107adc <check_vma_struct+0x3ea>
c0107ab8:	c7 44 24 0c 4c a9 10 	movl   $0xc010a94c,0xc(%esp)
c0107abf:	c0 
c0107ac0:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107ac7:	c0 
c0107ac8:	c7 44 24 04 da 00 00 	movl   $0xda,0x4(%esp)
c0107acf:	00 
c0107ad0:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107ad7:	e8 dc 91 ff ff       	call   c0100cb8 <__panic>
        struct vma_struct *mmap = le2vma(le, list_link);
        assert(mmap->vm_start == i * 5 && mmap->vm_end == i * 5 + 2);
        le = list_next(le);
    }

    for (i = 5; i <= 5 * step2; i +=5) {
c0107adc:	83 45 f4 05          	addl   $0x5,-0xc(%ebp)
c0107ae0:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0107ae3:	89 d0                	mov    %edx,%eax
c0107ae5:	c1 e0 02             	shl    $0x2,%eax
c0107ae8:	01 d0                	add    %edx,%eax
c0107aea:	3b 45 f4             	cmp    -0xc(%ebp),%eax
c0107aed:	0f 8d 20 fe ff ff    	jge    c0107913 <check_vma_struct+0x221>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107af3:	c7 45 f4 04 00 00 00 	movl   $0x4,-0xc(%ebp)
c0107afa:	eb 70                	jmp    c0107b6c <check_vma_struct+0x47a>
        struct vma_struct *vma_below_5= find_vma(mm,i);
c0107afc:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107aff:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b03:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b06:	89 04 24             	mov    %eax,(%esp)
c0107b09:	e8 7e f8 ff ff       	call   c010738c <find_vma>
c0107b0e:	89 45 bc             	mov    %eax,-0x44(%ebp)
        if (vma_below_5 != NULL ) {
c0107b11:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107b15:	74 27                	je     c0107b3e <check_vma_struct+0x44c>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
c0107b17:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107b1a:	8b 50 08             	mov    0x8(%eax),%edx
c0107b1d:	8b 45 bc             	mov    -0x44(%ebp),%eax
c0107b20:	8b 40 04             	mov    0x4(%eax),%eax
c0107b23:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0107b27:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107b2b:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107b2e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107b32:	c7 04 24 7c a9 10 c0 	movl   $0xc010a97c,(%esp)
c0107b39:	e8 19 88 ff ff       	call   c0100357 <cprintf>
        }
        assert(vma_below_5 == NULL);
c0107b3e:	83 7d bc 00          	cmpl   $0x0,-0x44(%ebp)
c0107b42:	74 24                	je     c0107b68 <check_vma_struct+0x476>
c0107b44:	c7 44 24 0c a1 a9 10 	movl   $0xc010a9a1,0xc(%esp)
c0107b4b:	c0 
c0107b4c:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107b53:	c0 
c0107b54:	c7 44 24 04 e2 00 00 	movl   $0xe2,0x4(%esp)
c0107b5b:	00 
c0107b5c:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107b63:	e8 50 91 ff ff       	call   c0100cb8 <__panic>

        assert(vma1->vm_start == i  && vma1->vm_end == i  + 2);
        assert(vma2->vm_start == i  && vma2->vm_end == i  + 2);
    }

    for (i =4; i>=0; i--) {
c0107b68:	83 6d f4 01          	subl   $0x1,-0xc(%ebp)
c0107b6c:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107b70:	79 8a                	jns    c0107afc <check_vma_struct+0x40a>
           cprintf("vma_below_5: i %x, start %x, end %x\n",i, vma_below_5->vm_start, vma_below_5->vm_end); 
        }
        assert(vma_below_5 == NULL);
    }

    mm_destroy(mm);
c0107b72:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107b75:	89 04 24             	mov    %eax,(%esp)
c0107b78:	e8 95 fa ff ff       	call   c0107612 <mm_destroy>

    assert(nr_free_pages_store == nr_free_pages());
c0107b7d:	e8 c2 cc ff ff       	call   c0104844 <nr_free_pages>
c0107b82:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107b85:	74 24                	je     c0107bab <check_vma_struct+0x4b9>
c0107b87:	c7 44 24 0c 34 a8 10 	movl   $0xc010a834,0xc(%esp)
c0107b8e:	c0 
c0107b8f:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107b96:	c0 
c0107b97:	c7 44 24 04 e7 00 00 	movl   $0xe7,0x4(%esp)
c0107b9e:	00 
c0107b9f:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107ba6:	e8 0d 91 ff ff       	call   c0100cb8 <__panic>

    cprintf("check_vma_struct() succeeded!\n");
c0107bab:	c7 04 24 b8 a9 10 c0 	movl   $0xc010a9b8,(%esp)
c0107bb2:	e8 a0 87 ff ff       	call   c0100357 <cprintf>
}
c0107bb7:	c9                   	leave  
c0107bb8:	c3                   	ret    

c0107bb9 <check_pgfault>:

struct mm_struct *check_mm_struct;

// check_pgfault - check correctness of pgfault handler
static void
check_pgfault(void) {
c0107bb9:	55                   	push   %ebp
c0107bba:	89 e5                	mov    %esp,%ebp
c0107bbc:	83 ec 38             	sub    $0x38,%esp
    size_t nr_free_pages_store = nr_free_pages();
c0107bbf:	e8 80 cc ff ff       	call   c0104844 <nr_free_pages>
c0107bc4:	89 45 ec             	mov    %eax,-0x14(%ebp)

    check_mm_struct = mm_create();
c0107bc7:	e8 0d f7 ff ff       	call   c01072d9 <mm_create>
c0107bcc:	a3 ac 1b 12 c0       	mov    %eax,0xc0121bac
    assert(check_mm_struct != NULL);
c0107bd1:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0107bd6:	85 c0                	test   %eax,%eax
c0107bd8:	75 24                	jne    c0107bfe <check_pgfault+0x45>
c0107bda:	c7 44 24 0c d7 a9 10 	movl   $0xc010a9d7,0xc(%esp)
c0107be1:	c0 
c0107be2:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107be9:	c0 
c0107bea:	c7 44 24 04 f4 00 00 	movl   $0xf4,0x4(%esp)
c0107bf1:	00 
c0107bf2:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107bf9:	e8 ba 90 ff ff       	call   c0100cb8 <__panic>

    struct mm_struct *mm = check_mm_struct;
c0107bfe:	a1 ac 1b 12 c0       	mov    0xc0121bac,%eax
c0107c03:	89 45 e8             	mov    %eax,-0x18(%ebp)
    pde_t *pgdir = mm->pgdir = boot_pgdir;
c0107c06:	8b 15 24 1a 12 c0    	mov    0xc0121a24,%edx
c0107c0c:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c0f:	89 50 0c             	mov    %edx,0xc(%eax)
c0107c12:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c15:	8b 40 0c             	mov    0xc(%eax),%eax
c0107c18:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    assert(pgdir[0] == 0);
c0107c1b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107c1e:	8b 00                	mov    (%eax),%eax
c0107c20:	85 c0                	test   %eax,%eax
c0107c22:	74 24                	je     c0107c48 <check_pgfault+0x8f>
c0107c24:	c7 44 24 0c ef a9 10 	movl   $0xc010a9ef,0xc(%esp)
c0107c2b:	c0 
c0107c2c:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107c33:	c0 
c0107c34:	c7 44 24 04 f8 00 00 	movl   $0xf8,0x4(%esp)
c0107c3b:	00 
c0107c3c:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107c43:	e8 70 90 ff ff       	call   c0100cb8 <__panic>

    struct vma_struct *vma = vma_create(0, PTSIZE, VM_WRITE);
c0107c48:	c7 44 24 08 02 00 00 	movl   $0x2,0x8(%esp)
c0107c4f:	00 
c0107c50:	c7 44 24 04 00 00 40 	movl   $0x400000,0x4(%esp)
c0107c57:	00 
c0107c58:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
c0107c5f:	e8 ed f6 ff ff       	call   c0107351 <vma_create>
c0107c64:	89 45 e0             	mov    %eax,-0x20(%ebp)
    assert(vma != NULL);
c0107c67:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107c6b:	75 24                	jne    c0107c91 <check_pgfault+0xd8>
c0107c6d:	c7 44 24 0c 7e a8 10 	movl   $0xc010a87e,0xc(%esp)
c0107c74:	c0 
c0107c75:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107c7c:	c0 
c0107c7d:	c7 44 24 04 fb 00 00 	movl   $0xfb,0x4(%esp)
c0107c84:	00 
c0107c85:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107c8c:	e8 27 90 ff ff       	call   c0100cb8 <__panic>

    insert_vma_struct(mm, vma);
c0107c91:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0107c94:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107c98:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107c9b:	89 04 24             	mov    %eax,(%esp)
c0107c9e:	e8 3e f8 ff ff       	call   c01074e1 <insert_vma_struct>

    uintptr_t addr = 0x100;
c0107ca3:	c7 45 dc 00 01 00 00 	movl   $0x100,-0x24(%ebp)
    assert(find_vma(mm, addr) == vma);
c0107caa:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107cad:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107cb1:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107cb4:	89 04 24             	mov    %eax,(%esp)
c0107cb7:	e8 d0 f6 ff ff       	call   c010738c <find_vma>
c0107cbc:	3b 45 e0             	cmp    -0x20(%ebp),%eax
c0107cbf:	74 24                	je     c0107ce5 <check_pgfault+0x12c>
c0107cc1:	c7 44 24 0c fd a9 10 	movl   $0xc010a9fd,0xc(%esp)
c0107cc8:	c0 
c0107cc9:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107cd0:	c0 
c0107cd1:	c7 44 24 04 00 01 00 	movl   $0x100,0x4(%esp)
c0107cd8:	00 
c0107cd9:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107ce0:	e8 d3 8f ff ff       	call   c0100cb8 <__panic>

    int i, sum = 0;
c0107ce5:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    for (i = 0; i < 100; i ++) {
c0107cec:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107cf3:	eb 15                	jmp    c0107d0a <check_pgfault+0x151>
        *(char *)(addr + i) = i;
c0107cf5:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107cf8:	03 45 dc             	add    -0x24(%ebp),%eax
c0107cfb:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0107cfe:	88 10                	mov    %dl,(%eax)
        sum += i;
c0107d00:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d03:	01 45 f0             	add    %eax,-0x10(%ebp)

    uintptr_t addr = 0x100;
    assert(find_vma(mm, addr) == vma);

    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
c0107d06:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107d0a:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107d0e:	7e e5                	jle    c0107cf5 <check_pgfault+0x13c>
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107d10:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
c0107d17:	eb 13                	jmp    c0107d2c <check_pgfault+0x173>
        sum -= *(char *)(addr + i);
c0107d19:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0107d1c:	03 45 dc             	add    -0x24(%ebp),%eax
c0107d1f:	0f b6 00             	movzbl (%eax),%eax
c0107d22:	0f be c0             	movsbl %al,%eax
c0107d25:	29 45 f0             	sub    %eax,-0x10(%ebp)
    int i, sum = 0;
    for (i = 0; i < 100; i ++) {
        *(char *)(addr + i) = i;
        sum += i;
    }
    for (i = 0; i < 100; i ++) {
c0107d28:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
c0107d2c:	83 7d f4 63          	cmpl   $0x63,-0xc(%ebp)
c0107d30:	7e e7                	jle    c0107d19 <check_pgfault+0x160>
        sum -= *(char *)(addr + i);
    }
    assert(sum == 0);
c0107d32:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0107d36:	74 24                	je     c0107d5c <check_pgfault+0x1a3>
c0107d38:	c7 44 24 0c 17 aa 10 	movl   $0xc010aa17,0xc(%esp)
c0107d3f:	c0 
c0107d40:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107d47:	c0 
c0107d48:	c7 44 24 04 0a 01 00 	movl   $0x10a,0x4(%esp)
c0107d4f:	00 
c0107d50:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107d57:	e8 5c 8f ff ff       	call   c0100cb8 <__panic>

    page_remove(pgdir, ROUNDDOWN(addr, PGSIZE));
c0107d5c:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107d5f:	89 45 d8             	mov    %eax,-0x28(%ebp)
c0107d62:	8b 45 d8             	mov    -0x28(%ebp),%eax
c0107d65:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107d6a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107d6e:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d71:	89 04 24             	mov    %eax,(%esp)
c0107d74:	e8 95 d3 ff ff       	call   c010510e <page_remove>
    free_page(pde2page(pgdir[0]));
c0107d79:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d7c:	8b 00                	mov    (%eax),%eax
c0107d7e:	89 04 24             	mov    %eax,(%esp)
c0107d81:	e8 3b f5 ff ff       	call   c01072c1 <pde2page>
c0107d86:	c7 44 24 04 01 00 00 	movl   $0x1,0x4(%esp)
c0107d8d:	00 
c0107d8e:	89 04 24             	mov    %eax,(%esp)
c0107d91:	e8 7c ca ff ff       	call   c0104812 <free_pages>
    pgdir[0] = 0;
c0107d96:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107d99:	c7 00 00 00 00 00    	movl   $0x0,(%eax)

    mm->pgdir = NULL;
c0107d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107da2:	c7 40 0c 00 00 00 00 	movl   $0x0,0xc(%eax)
    mm_destroy(mm);
c0107da9:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107dac:	89 04 24             	mov    %eax,(%esp)
c0107daf:	e8 5e f8 ff ff       	call   c0107612 <mm_destroy>
    check_mm_struct = NULL;
c0107db4:	c7 05 ac 1b 12 c0 00 	movl   $0x0,0xc0121bac
c0107dbb:	00 00 00 

    assert(nr_free_pages_store == nr_free_pages());
c0107dbe:	e8 81 ca ff ff       	call   c0104844 <nr_free_pages>
c0107dc3:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0107dc6:	74 24                	je     c0107dec <check_pgfault+0x233>
c0107dc8:	c7 44 24 0c 34 a8 10 	movl   $0xc010a834,0xc(%esp)
c0107dcf:	c0 
c0107dd0:	c7 44 24 08 b3 a7 10 	movl   $0xc010a7b3,0x8(%esp)
c0107dd7:	c0 
c0107dd8:	c7 44 24 04 14 01 00 	movl   $0x114,0x4(%esp)
c0107ddf:	00 
c0107de0:	c7 04 24 c8 a7 10 c0 	movl   $0xc010a7c8,(%esp)
c0107de7:	e8 cc 8e ff ff       	call   c0100cb8 <__panic>

    cprintf("check_pgfault() succeeded!\n");
c0107dec:	c7 04 24 20 aa 10 c0 	movl   $0xc010aa20,(%esp)
c0107df3:	e8 5f 85 ff ff       	call   c0100357 <cprintf>
}
c0107df8:	c9                   	leave  
c0107df9:	c3                   	ret    

c0107dfa <do_pgfault>:
 *            was a read (0) or write (1).
 *         -- The U/S flag (bit 2) indicates whether the processor was executing at user mode (1)
 *            or supervisor mode (0) at the time of the exception.
 */
int
do_pgfault(struct mm_struct *mm, uint32_t error_code, uintptr_t addr) {
c0107dfa:	55                   	push   %ebp
c0107dfb:	89 e5                	mov    %esp,%ebp
c0107dfd:	83 ec 38             	sub    $0x38,%esp
    int ret = -E_INVAL;
c0107e00:	c7 45 f4 fd ff ff ff 	movl   $0xfffffffd,-0xc(%ebp)
    //try to find a vma which include addr
    struct vma_struct *vma = find_vma(mm, addr);
c0107e07:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e0a:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e0e:	8b 45 08             	mov    0x8(%ebp),%eax
c0107e11:	89 04 24             	mov    %eax,(%esp)
c0107e14:	e8 73 f5 ff ff       	call   c010738c <find_vma>
c0107e19:	89 45 ec             	mov    %eax,-0x14(%ebp)

    pgfault_num++;
c0107e1c:	a1 b8 1a 12 c0       	mov    0xc0121ab8,%eax
c0107e21:	83 c0 01             	add    $0x1,%eax
c0107e24:	a3 b8 1a 12 c0       	mov    %eax,0xc0121ab8
    //If the addr is in the range of a mm's vma?
    if (vma == NULL || vma->vm_start > addr) {
c0107e29:	83 7d ec 00          	cmpl   $0x0,-0x14(%ebp)
c0107e2d:	74 0b                	je     c0107e3a <do_pgfault+0x40>
c0107e2f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e32:	8b 40 04             	mov    0x4(%eax),%eax
c0107e35:	3b 45 10             	cmp    0x10(%ebp),%eax
c0107e38:	76 18                	jbe    c0107e52 <do_pgfault+0x58>
        cprintf("not valid addr %x, and  can not find it in vma\n", addr);
c0107e3a:	8b 45 10             	mov    0x10(%ebp),%eax
c0107e3d:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107e41:	c7 04 24 3c aa 10 c0 	movl   $0xc010aa3c,(%esp)
c0107e48:	e8 0a 85 ff ff       	call   c0100357 <cprintf>
        goto failed;
c0107e4d:	e9 d9 01 00 00       	jmp    c010802b <do_pgfault+0x231>
    }
    //check the error_code
    switch (error_code & 3) {
c0107e52:	8b 45 0c             	mov    0xc(%ebp),%eax
c0107e55:	83 e0 03             	and    $0x3,%eax
c0107e58:	85 c0                	test   %eax,%eax
c0107e5a:	74 34                	je     c0107e90 <do_pgfault+0x96>
c0107e5c:	83 f8 01             	cmp    $0x1,%eax
c0107e5f:	74 1e                	je     c0107e7f <do_pgfault+0x85>
    default:
            /* error code flag : default is 3 ( W/R=1, P=1): write, present */
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
c0107e61:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e64:	8b 40 0c             	mov    0xc(%eax),%eax
c0107e67:	83 e0 02             	and    $0x2,%eax
c0107e6a:	85 c0                	test   %eax,%eax
c0107e6c:	75 40                	jne    c0107eae <do_pgfault+0xb4>
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
c0107e6e:	c7 04 24 6c aa 10 c0 	movl   $0xc010aa6c,(%esp)
c0107e75:	e8 dd 84 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0107e7a:	e9 ac 01 00 00       	jmp    c010802b <do_pgfault+0x231>
        }
        break;
    case 1: /* error code flag : (W/R=0, P=1): read, present */
        cprintf("do_pgfault failed: error code flag = read AND present\n");
c0107e7f:	c7 04 24 cc aa 10 c0 	movl   $0xc010aacc,(%esp)
c0107e86:	e8 cc 84 ff ff       	call   c0100357 <cprintf>
        goto failed;
c0107e8b:	e9 9b 01 00 00       	jmp    c010802b <do_pgfault+0x231>
    case 0: /* error code flag : (W/R=0, P=0): read, not present */
        if (!(vma->vm_flags & (VM_READ | VM_EXEC))) {
c0107e90:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107e93:	8b 40 0c             	mov    0xc(%eax),%eax
c0107e96:	83 e0 05             	and    $0x5,%eax
c0107e99:	85 c0                	test   %eax,%eax
c0107e9b:	75 12                	jne    c0107eaf <do_pgfault+0xb5>
            cprintf("do_pgfault failed: error code flag = read AND not present, but the addr's vma cannot read or exec\n");
c0107e9d:	c7 04 24 04 ab 10 c0 	movl   $0xc010ab04,(%esp)
c0107ea4:	e8 ae 84 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0107ea9:	e9 7d 01 00 00       	jmp    c010802b <do_pgfault+0x231>
    case 2: /* error code flag : (W/R=1, P=0): write, not present */
        if (!(vma->vm_flags & VM_WRITE)) {
            cprintf("do_pgfault failed: error code flag = write AND not present, but the addr's vma cannot write\n");
            goto failed;
        }
        break;
c0107eae:	90                   	nop
     *    (write an non_existed addr && addr is writable) OR
     *    (read  an non_existed addr && addr is readable)
     * THEN
     *    continue process
     */
    uint32_t perm = PTE_U;
c0107eaf:	c7 45 f0 04 00 00 00 	movl   $0x4,-0x10(%ebp)
    if (vma->vm_flags & VM_WRITE) {
c0107eb6:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0107eb9:	8b 40 0c             	mov    0xc(%eax),%eax
c0107ebc:	83 e0 02             	and    $0x2,%eax
c0107ebf:	85 c0                	test   %eax,%eax
c0107ec1:	74 04                	je     c0107ec7 <do_pgfault+0xcd>
        perm |= PTE_W;
c0107ec3:	83 4d f0 02          	orl    $0x2,-0x10(%ebp)
    }
    addr = ROUNDDOWN(addr, PGSIZE);
c0107ec7:	8b 45 10             	mov    0x10(%ebp),%eax
c0107eca:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0107ecd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0107ed0:	25 00 f0 ff ff       	and    $0xfffff000,%eax
c0107ed5:	89 45 10             	mov    %eax,0x10(%ebp)

    ret = -E_NO_MEM;
c0107ed8:	c7 45 f4 fc ff ff ff 	movl   $0xfffffffc,-0xc(%ebp)

    pte_t *ptep=NULL;
c0107edf:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
            cprintf("no swap_init_ok but ptep is %x, failed\n",*ptep);
            goto failed;
        }
   }
#endif
  ptep = get_pte(mm->pgdir, addr, 1);
c0107ee6:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ee9:	8b 40 0c             	mov    0xc(%eax),%eax
c0107eec:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
c0107ef3:	00 
c0107ef4:	8b 55 10             	mov    0x10(%ebp),%edx
c0107ef7:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107efb:	89 04 24             	mov    %eax,(%esp)
c0107efe:	e8 05 d0 ff ff       	call   c0104f08 <get_pte>
c0107f03:	89 45 e4             	mov    %eax,-0x1c(%ebp)
    if (!ptep) {
c0107f06:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0107f0a:	75 11                	jne    c0107f1d <do_pgfault+0x123>
        cprintf("failed in get_pte in do_pgfault\n");
c0107f0c:	c7 04 24 68 ab 10 c0 	movl   $0xc010ab68,(%esp)
c0107f13:	e8 3f 84 ff ff       	call   c0100357 <cprintf>
        goto failed;
c0107f18:	e9 0e 01 00 00       	jmp    c010802b <do_pgfault+0x231>
    }
    
    if (*ptep == 0) {
c0107f1d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0107f20:	8b 00                	mov    (%eax),%eax
c0107f22:	85 c0                	test   %eax,%eax
c0107f24:	75 3a                	jne    c0107f60 <do_pgfault+0x166>
        struct Page* page = pgdir_alloc_page(mm->pgdir, addr, perm);
c0107f26:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f29:	8b 40 0c             	mov    0xc(%eax),%eax
c0107f2c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0107f2f:	89 54 24 08          	mov    %edx,0x8(%esp)
c0107f33:	8b 55 10             	mov    0x10(%ebp),%edx
c0107f36:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107f3a:	89 04 24             	mov    %eax,(%esp)
c0107f3d:	e8 2b d3 ff ff       	call   c010526d <pgdir_alloc_page>
c0107f42:	89 45 e0             	mov    %eax,-0x20(%ebp)
        if (!page) {
c0107f45:	83 7d e0 00          	cmpl   $0x0,-0x20(%ebp)
c0107f49:	0f 85 d5 00 00 00    	jne    c0108024 <do_pgfault+0x22a>
            cprintf("failed in pgdir_alloc_page in do_pgfault\n");
c0107f4f:	c7 04 24 8c ab 10 c0 	movl   $0xc010ab8c,(%esp)
c0107f56:	e8 fc 83 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0107f5b:	e9 cb 00 00 00       	jmp    c010802b <do_pgfault+0x231>
        }
    }

    else {
        if(swap_init_ok) {
c0107f60:	a1 ac 1a 12 c0       	mov    0xc0121aac,%eax
c0107f65:	85 c0                	test   %eax,%eax
c0107f67:	0f 84 a0 00 00 00    	je     c010800d <do_pgfault+0x213>
            struct Page *page = NULL;
c0107f6d:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
            ret = swap_in(mm, addr, &page);
c0107f74:	8d 45 dc             	lea    -0x24(%ebp),%eax
c0107f77:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107f7b:	8b 45 10             	mov    0x10(%ebp),%eax
c0107f7e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107f82:	8b 45 08             	mov    0x8(%ebp),%eax
c0107f85:	89 04 24             	mov    %eax,(%esp)
c0107f88:	e8 a3 e4 ff ff       	call   c0106430 <swap_in>
c0107f8d:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0107f90:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107f94:	74 11                	je     c0107fa7 <do_pgfault+0x1ad>
                cprintf("failed in swap_in in do_pgfault\n");
c0107f96:	c7 04 24 b8 ab 10 c0 	movl   $0xc010abb8,(%esp)
c0107f9d:	e8 b5 83 ff ff       	call   c0100357 <cprintf>
                goto failed;
c0107fa2:	e9 84 00 00 00       	jmp    c010802b <do_pgfault+0x231>
            }
            ret = page_insert(mm->pgdir, page, addr, perm);
c0107fa7:	8b 55 dc             	mov    -0x24(%ebp),%edx
c0107faa:	8b 45 08             	mov    0x8(%ebp),%eax
c0107fad:	8b 40 0c             	mov    0xc(%eax),%eax
c0107fb0:	8b 4d f0             	mov    -0x10(%ebp),%ecx
c0107fb3:	89 4c 24 0c          	mov    %ecx,0xc(%esp)
c0107fb7:	8b 4d 10             	mov    0x10(%ebp),%ecx
c0107fba:	89 4c 24 08          	mov    %ecx,0x8(%esp)
c0107fbe:	89 54 24 04          	mov    %edx,0x4(%esp)
c0107fc2:	89 04 24             	mov    %eax,(%esp)
c0107fc5:	e8 88 d1 ff ff       	call   c0105152 <page_insert>
c0107fca:	89 45 f4             	mov    %eax,-0xc(%ebp)
            if (ret != 0) {
c0107fcd:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0107fd1:	74 0e                	je     c0107fe1 <do_pgfault+0x1e7>
                cprintf("failed in page_insert in do_pgfault\n");
c0107fd3:	c7 04 24 dc ab 10 c0 	movl   $0xc010abdc,(%esp)
c0107fda:	e8 78 83 ff ff       	call   c0100357 <cprintf>
                goto failed;
c0107fdf:	eb 4a                	jmp    c010802b <do_pgfault+0x231>
            }
            swap_map_swappable(mm, addr, page, 1);
c0107fe1:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0107fe4:	c7 44 24 0c 01 00 00 	movl   $0x1,0xc(%esp)
c0107feb:	00 
c0107fec:	89 44 24 08          	mov    %eax,0x8(%esp)
c0107ff0:	8b 45 10             	mov    0x10(%ebp),%eax
c0107ff3:	89 44 24 04          	mov    %eax,0x4(%esp)
c0107ff7:	8b 45 08             	mov    0x8(%ebp),%eax
c0107ffa:	89 04 24             	mov    %eax,(%esp)
c0107ffd:	e8 65 e2 ff ff       	call   c0106267 <swap_map_swappable>
            page->pra_vaddr = addr;
c0108002:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108005:	8b 55 10             	mov    0x10(%ebp),%edx
c0108008:	89 50 1c             	mov    %edx,0x1c(%eax)
c010800b:	eb 17                	jmp    c0108024 <do_pgfault+0x22a>
        }
        else {
            cprintf("there is no swap_init_ok, ptep is %x, failed\n",*ptep);
c010800d:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108010:	8b 00                	mov    (%eax),%eax
c0108012:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108016:	c7 04 24 04 ac 10 c0 	movl   $0xc010ac04,(%esp)
c010801d:	e8 35 83 ff ff       	call   c0100357 <cprintf>
            goto failed;
c0108022:	eb 07                	jmp    c010802b <do_pgfault+0x231>
        }
   }
   ret = 0;
c0108024:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
failed:
    return ret;
c010802b:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c010802e:	c9                   	leave  
c010802f:	c3                   	ret    

c0108030 <page2ppn>:

extern struct Page *pages;
extern size_t npage;

static inline ppn_t
page2ppn(struct Page *page) {
c0108030:	55                   	push   %ebp
c0108031:	89 e5                	mov    %esp,%ebp
    return page - pages;
c0108033:	8b 55 08             	mov    0x8(%ebp),%edx
c0108036:	a1 d4 1a 12 c0       	mov    0xc0121ad4,%eax
c010803b:	89 d1                	mov    %edx,%ecx
c010803d:	29 c1                	sub    %eax,%ecx
c010803f:	89 c8                	mov    %ecx,%eax
c0108041:	c1 f8 05             	sar    $0x5,%eax
}
c0108044:	5d                   	pop    %ebp
c0108045:	c3                   	ret    

c0108046 <page2pa>:

static inline uintptr_t
page2pa(struct Page *page) {
c0108046:	55                   	push   %ebp
c0108047:	89 e5                	mov    %esp,%ebp
c0108049:	83 ec 04             	sub    $0x4,%esp
    return page2ppn(page) << PGSHIFT;
c010804c:	8b 45 08             	mov    0x8(%ebp),%eax
c010804f:	89 04 24             	mov    %eax,(%esp)
c0108052:	e8 d9 ff ff ff       	call   c0108030 <page2ppn>
c0108057:	c1 e0 0c             	shl    $0xc,%eax
}
c010805a:	c9                   	leave  
c010805b:	c3                   	ret    

c010805c <page2kva>:
    }
    return &pages[PPN(pa)];
}

static inline void *
page2kva(struct Page *page) {
c010805c:	55                   	push   %ebp
c010805d:	89 e5                	mov    %esp,%ebp
c010805f:	83 ec 28             	sub    $0x28,%esp
    return KADDR(page2pa(page));
c0108062:	8b 45 08             	mov    0x8(%ebp),%eax
c0108065:	89 04 24             	mov    %eax,(%esp)
c0108068:	e8 d9 ff ff ff       	call   c0108046 <page2pa>
c010806d:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108070:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108073:	c1 e8 0c             	shr    $0xc,%eax
c0108076:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108079:	a1 20 1a 12 c0       	mov    0xc0121a20,%eax
c010807e:	39 45 f0             	cmp    %eax,-0x10(%ebp)
c0108081:	72 23                	jb     c01080a6 <page2kva+0x4a>
c0108083:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108086:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010808a:	c7 44 24 08 34 ac 10 	movl   $0xc010ac34,0x8(%esp)
c0108091:	c0 
c0108092:	c7 44 24 04 62 00 00 	movl   $0x62,0x4(%esp)
c0108099:	00 
c010809a:	c7 04 24 57 ac 10 c0 	movl   $0xc010ac57,(%esp)
c01080a1:	e8 12 8c ff ff       	call   c0100cb8 <__panic>
c01080a6:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01080a9:	2d 00 00 00 40       	sub    $0x40000000,%eax
}
c01080ae:	c9                   	leave  
c01080af:	c3                   	ret    

c01080b0 <swapfs_init>:
#include <ide.h>
#include <pmm.h>
#include <assert.h>

void
swapfs_init(void) {
c01080b0:	55                   	push   %ebp
c01080b1:	89 e5                	mov    %esp,%ebp
c01080b3:	83 ec 18             	sub    $0x18,%esp
    static_assert((PGSIZE % SECTSIZE) == 0);
    if (!ide_device_valid(SWAP_DEV_NO)) {
c01080b6:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01080bd:	e8 11 9a ff ff       	call   c0101ad3 <ide_device_valid>
c01080c2:	85 c0                	test   %eax,%eax
c01080c4:	75 1c                	jne    c01080e2 <swapfs_init+0x32>
        panic("swap fs isn't available.\n");
c01080c6:	c7 44 24 08 65 ac 10 	movl   $0xc010ac65,0x8(%esp)
c01080cd:	c0 
c01080ce:	c7 44 24 04 0d 00 00 	movl   $0xd,0x4(%esp)
c01080d5:	00 
c01080d6:	c7 04 24 7f ac 10 c0 	movl   $0xc010ac7f,(%esp)
c01080dd:	e8 d6 8b ff ff       	call   c0100cb8 <__panic>
    }
    max_swap_offset = ide_device_size(SWAP_DEV_NO) / (PGSIZE / SECTSIZE);
c01080e2:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01080e9:	e8 24 9a ff ff       	call   c0101b12 <ide_device_size>
c01080ee:	c1 e8 03             	shr    $0x3,%eax
c01080f1:	a3 7c 1b 12 c0       	mov    %eax,0xc0121b7c
}
c01080f6:	c9                   	leave  
c01080f7:	c3                   	ret    

c01080f8 <swapfs_read>:

int
swapfs_read(swap_entry_t entry, struct Page *page) {
c01080f8:	55                   	push   %ebp
c01080f9:	89 e5                	mov    %esp,%ebp
c01080fb:	83 ec 28             	sub    $0x28,%esp
    return ide_read_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c01080fe:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108101:	89 04 24             	mov    %eax,(%esp)
c0108104:	e8 53 ff ff ff       	call   c010805c <page2kva>
c0108109:	8b 55 08             	mov    0x8(%ebp),%edx
c010810c:	c1 ea 08             	shr    $0x8,%edx
c010810f:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108112:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108116:	74 0b                	je     c0108123 <swapfs_read+0x2b>
c0108118:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c010811e:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108121:	72 23                	jb     c0108146 <swapfs_read+0x4e>
c0108123:	8b 45 08             	mov    0x8(%ebp),%eax
c0108126:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010812a:	c7 44 24 08 90 ac 10 	movl   $0xc010ac90,0x8(%esp)
c0108131:	c0 
c0108132:	c7 44 24 04 14 00 00 	movl   $0x14,0x4(%esp)
c0108139:	00 
c010813a:	c7 04 24 7f ac 10 c0 	movl   $0xc010ac7f,(%esp)
c0108141:	e8 72 8b ff ff       	call   c0100cb8 <__panic>
c0108146:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108149:	c1 e2 03             	shl    $0x3,%edx
c010814c:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c0108153:	00 
c0108154:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108158:	89 54 24 04          	mov    %edx,0x4(%esp)
c010815c:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c0108163:	e8 e9 99 ff ff       	call   c0101b51 <ide_read_secs>
}
c0108168:	c9                   	leave  
c0108169:	c3                   	ret    

c010816a <swapfs_write>:

int
swapfs_write(swap_entry_t entry, struct Page *page) {
c010816a:	55                   	push   %ebp
c010816b:	89 e5                	mov    %esp,%ebp
c010816d:	83 ec 28             	sub    $0x28,%esp
    return ide_write_secs(SWAP_DEV_NO, swap_offset(entry) * PAGE_NSECT, page2kva(page), PAGE_NSECT);
c0108170:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108173:	89 04 24             	mov    %eax,(%esp)
c0108176:	e8 e1 fe ff ff       	call   c010805c <page2kva>
c010817b:	8b 55 08             	mov    0x8(%ebp),%edx
c010817e:	c1 ea 08             	shr    $0x8,%edx
c0108181:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108184:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
c0108188:	74 0b                	je     c0108195 <swapfs_write+0x2b>
c010818a:	8b 15 7c 1b 12 c0    	mov    0xc0121b7c,%edx
c0108190:	39 55 f4             	cmp    %edx,-0xc(%ebp)
c0108193:	72 23                	jb     c01081b8 <swapfs_write+0x4e>
c0108195:	8b 45 08             	mov    0x8(%ebp),%eax
c0108198:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010819c:	c7 44 24 08 90 ac 10 	movl   $0xc010ac90,0x8(%esp)
c01081a3:	c0 
c01081a4:	c7 44 24 04 19 00 00 	movl   $0x19,0x4(%esp)
c01081ab:	00 
c01081ac:	c7 04 24 7f ac 10 c0 	movl   $0xc010ac7f,(%esp)
c01081b3:	e8 00 8b ff ff       	call   c0100cb8 <__panic>
c01081b8:	8b 55 f4             	mov    -0xc(%ebp),%edx
c01081bb:	c1 e2 03             	shl    $0x3,%edx
c01081be:	c7 44 24 0c 08 00 00 	movl   $0x8,0xc(%esp)
c01081c5:	00 
c01081c6:	89 44 24 08          	mov    %eax,0x8(%esp)
c01081ca:	89 54 24 04          	mov    %edx,0x4(%esp)
c01081ce:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
c01081d5:	e8 c0 9b ff ff       	call   c0101d9a <ide_write_secs>
}
c01081da:	c9                   	leave  
c01081db:	c3                   	ret    

c01081dc <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*), void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
c01081dc:	55                   	push   %ebp
c01081dd:	89 e5                	mov    %esp,%ebp
c01081df:	56                   	push   %esi
c01081e0:	53                   	push   %ebx
c01081e1:	83 ec 60             	sub    $0x60,%esp
c01081e4:	8b 45 10             	mov    0x10(%ebp),%eax
c01081e7:	89 45 d0             	mov    %eax,-0x30(%ebp)
c01081ea:	8b 45 14             	mov    0x14(%ebp),%eax
c01081ed:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
c01081f0:	8b 45 d0             	mov    -0x30(%ebp),%eax
c01081f3:	8b 55 d4             	mov    -0x2c(%ebp),%edx
c01081f6:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01081f9:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
c01081fc:	8b 45 18             	mov    0x18(%ebp),%eax
c01081ff:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108202:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108205:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108208:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010820b:	89 55 cc             	mov    %edx,-0x34(%ebp)
c010820e:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108211:	8b 55 cc             	mov    -0x34(%ebp),%edx
c0108214:	89 d3                	mov    %edx,%ebx
c0108216:	89 c6                	mov    %eax,%esi
c0108218:	89 75 e0             	mov    %esi,-0x20(%ebp)
c010821b:	89 5d f0             	mov    %ebx,-0x10(%ebp)
c010821e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108221:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108224:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
c0108228:	74 1c                	je     c0108246 <printnum+0x6a>
c010822a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010822d:	ba 00 00 00 00       	mov    $0x0,%edx
c0108232:	f7 75 e4             	divl   -0x1c(%ebp)
c0108235:	89 55 f4             	mov    %edx,-0xc(%ebp)
c0108238:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010823b:	ba 00 00 00 00       	mov    $0x0,%edx
c0108240:	f7 75 e4             	divl   -0x1c(%ebp)
c0108243:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108246:	8b 55 e0             	mov    -0x20(%ebp),%edx
c0108249:	8b 45 f4             	mov    -0xc(%ebp),%eax
c010824c:	89 d6                	mov    %edx,%esi
c010824e:	89 c3                	mov    %eax,%ebx
c0108250:	89 f0                	mov    %esi,%eax
c0108252:	89 da                	mov    %ebx,%edx
c0108254:	f7 75 e4             	divl   -0x1c(%ebp)
c0108257:	89 d3                	mov    %edx,%ebx
c0108259:	89 c6                	mov    %eax,%esi
c010825b:	89 75 e0             	mov    %esi,-0x20(%ebp)
c010825e:	89 5d dc             	mov    %ebx,-0x24(%ebp)
c0108261:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108264:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0108267:	8b 55 f0             	mov    -0x10(%ebp),%edx
c010826a:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c010826d:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108270:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0108273:	89 c3                	mov    %eax,%ebx
c0108275:	89 d6                	mov    %edx,%esi
c0108277:	89 5d e8             	mov    %ebx,-0x18(%ebp)
c010827a:	89 75 ec             	mov    %esi,-0x14(%ebp)
c010827d:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108280:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
c0108283:	8b 45 18             	mov    0x18(%ebp),%eax
c0108286:	ba 00 00 00 00       	mov    $0x0,%edx
c010828b:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c010828e:	77 56                	ja     c01082e6 <printnum+0x10a>
c0108290:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
c0108293:	72 05                	jb     c010829a <printnum+0xbe>
c0108295:	3b 45 d0             	cmp    -0x30(%ebp),%eax
c0108298:	77 4c                	ja     c01082e6 <printnum+0x10a>
        printnum(putch, putdat, result, base, width - 1, padc);
c010829a:	8b 45 1c             	mov    0x1c(%ebp),%eax
c010829d:	8d 50 ff             	lea    -0x1(%eax),%edx
c01082a0:	8b 45 20             	mov    0x20(%ebp),%eax
c01082a3:	89 44 24 18          	mov    %eax,0x18(%esp)
c01082a7:	89 54 24 14          	mov    %edx,0x14(%esp)
c01082ab:	8b 45 18             	mov    0x18(%ebp),%eax
c01082ae:	89 44 24 10          	mov    %eax,0x10(%esp)
c01082b2:	8b 45 e8             	mov    -0x18(%ebp),%eax
c01082b5:	8b 55 ec             	mov    -0x14(%ebp),%edx
c01082b8:	89 44 24 08          	mov    %eax,0x8(%esp)
c01082bc:	89 54 24 0c          	mov    %edx,0xc(%esp)
c01082c0:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082c3:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01082ca:	89 04 24             	mov    %eax,(%esp)
c01082cd:	e8 0a ff ff ff       	call   c01081dc <printnum>
c01082d2:	eb 1c                	jmp    c01082f0 <printnum+0x114>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat);
c01082d4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01082d7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01082db:	8b 45 20             	mov    0x20(%ebp),%eax
c01082de:	89 04 24             	mov    %eax,(%esp)
c01082e1:	8b 45 08             	mov    0x8(%ebp),%eax
c01082e4:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
c01082e6:	83 6d 1c 01          	subl   $0x1,0x1c(%ebp)
c01082ea:	83 7d 1c 00          	cmpl   $0x0,0x1c(%ebp)
c01082ee:	7f e4                	jg     c01082d4 <printnum+0xf8>
            putch(padc, putdat);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat);
c01082f0:	8b 45 d8             	mov    -0x28(%ebp),%eax
c01082f3:	05 30 ad 10 c0       	add    $0xc010ad30,%eax
c01082f8:	0f b6 00             	movzbl (%eax),%eax
c01082fb:	0f be c0             	movsbl %al,%eax
c01082fe:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108301:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108305:	89 04 24             	mov    %eax,(%esp)
c0108308:	8b 45 08             	mov    0x8(%ebp),%eax
c010830b:	ff d0                	call   *%eax
}
c010830d:	83 c4 60             	add    $0x60,%esp
c0108310:	5b                   	pop    %ebx
c0108311:	5e                   	pop    %esi
c0108312:	5d                   	pop    %ebp
c0108313:	c3                   	ret    

c0108314 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
c0108314:	55                   	push   %ebp
c0108315:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108317:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010831b:	7e 14                	jle    c0108331 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
c010831d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108320:	8b 00                	mov    (%eax),%eax
c0108322:	8d 48 08             	lea    0x8(%eax),%ecx
c0108325:	8b 55 08             	mov    0x8(%ebp),%edx
c0108328:	89 0a                	mov    %ecx,(%edx)
c010832a:	8b 50 04             	mov    0x4(%eax),%edx
c010832d:	8b 00                	mov    (%eax),%eax
c010832f:	eb 30                	jmp    c0108361 <getuint+0x4d>
    }
    else if (lflag) {
c0108331:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108335:	74 16                	je     c010834d <getuint+0x39>
        return va_arg(*ap, unsigned long);
c0108337:	8b 45 08             	mov    0x8(%ebp),%eax
c010833a:	8b 00                	mov    (%eax),%eax
c010833c:	8d 48 04             	lea    0x4(%eax),%ecx
c010833f:	8b 55 08             	mov    0x8(%ebp),%edx
c0108342:	89 0a                	mov    %ecx,(%edx)
c0108344:	8b 00                	mov    (%eax),%eax
c0108346:	ba 00 00 00 00       	mov    $0x0,%edx
c010834b:	eb 14                	jmp    c0108361 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
c010834d:	8b 45 08             	mov    0x8(%ebp),%eax
c0108350:	8b 00                	mov    (%eax),%eax
c0108352:	8d 48 04             	lea    0x4(%eax),%ecx
c0108355:	8b 55 08             	mov    0x8(%ebp),%edx
c0108358:	89 0a                	mov    %ecx,(%edx)
c010835a:	8b 00                	mov    (%eax),%eax
c010835c:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
c0108361:	5d                   	pop    %ebp
c0108362:	c3                   	ret    

c0108363 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
c0108363:	55                   	push   %ebp
c0108364:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
c0108366:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
c010836a:	7e 14                	jle    c0108380 <getint+0x1d>
        return va_arg(*ap, long long);
c010836c:	8b 45 08             	mov    0x8(%ebp),%eax
c010836f:	8b 00                	mov    (%eax),%eax
c0108371:	8d 48 08             	lea    0x8(%eax),%ecx
c0108374:	8b 55 08             	mov    0x8(%ebp),%edx
c0108377:	89 0a                	mov    %ecx,(%edx)
c0108379:	8b 50 04             	mov    0x4(%eax),%edx
c010837c:	8b 00                	mov    (%eax),%eax
c010837e:	eb 30                	jmp    c01083b0 <getint+0x4d>
    }
    else if (lflag) {
c0108380:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108384:	74 16                	je     c010839c <getint+0x39>
        return va_arg(*ap, long);
c0108386:	8b 45 08             	mov    0x8(%ebp),%eax
c0108389:	8b 00                	mov    (%eax),%eax
c010838b:	8d 48 04             	lea    0x4(%eax),%ecx
c010838e:	8b 55 08             	mov    0x8(%ebp),%edx
c0108391:	89 0a                	mov    %ecx,(%edx)
c0108393:	8b 00                	mov    (%eax),%eax
c0108395:	89 c2                	mov    %eax,%edx
c0108397:	c1 fa 1f             	sar    $0x1f,%edx
c010839a:	eb 14                	jmp    c01083b0 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
c010839c:	8b 45 08             	mov    0x8(%ebp),%eax
c010839f:	8b 00                	mov    (%eax),%eax
c01083a1:	8d 48 04             	lea    0x4(%eax),%ecx
c01083a4:	8b 55 08             	mov    0x8(%ebp),%edx
c01083a7:	89 0a                	mov    %ecx,(%edx)
c01083a9:	8b 00                	mov    (%eax),%eax
c01083ab:	89 c2                	mov    %eax,%edx
c01083ad:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
c01083b0:	5d                   	pop    %ebp
c01083b1:	c3                   	ret    

c01083b2 <printfmt>:
 * @putch:      specified putch function, print a single character
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*), void *putdat, const char *fmt, ...) {
c01083b2:	55                   	push   %ebp
c01083b3:	89 e5                	mov    %esp,%ebp
c01083b5:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
c01083b8:	8d 55 14             	lea    0x14(%ebp),%edx
c01083bb:	8d 45 f4             	lea    -0xc(%ebp),%eax
c01083be:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, putdat, fmt, ap);
c01083c0:	8b 45 f4             	mov    -0xc(%ebp),%eax
c01083c3:	89 44 24 0c          	mov    %eax,0xc(%esp)
c01083c7:	8b 45 10             	mov    0x10(%ebp),%eax
c01083ca:	89 44 24 08          	mov    %eax,0x8(%esp)
c01083ce:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083d1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083d5:	8b 45 08             	mov    0x8(%ebp),%eax
c01083d8:	89 04 24             	mov    %eax,(%esp)
c01083db:	e8 02 00 00 00       	call   c01083e2 <vprintfmt>
    va_end(ap);
}
c01083e0:	c9                   	leave  
c01083e1:	c3                   	ret    

c01083e2 <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*), void *putdat, const char *fmt, va_list ap) {
c01083e2:	55                   	push   %ebp
c01083e3:	89 e5                	mov    %esp,%ebp
c01083e5:	56                   	push   %esi
c01083e6:	53                   	push   %ebx
c01083e7:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01083ea:	eb 17                	jmp    c0108403 <vprintfmt+0x21>
            if (ch == '\0') {
c01083ec:	85 db                	test   %ebx,%ebx
c01083ee:	0f 84 db 03 00 00    	je     c01087cf <vprintfmt+0x3ed>
                return;
            }
            putch(ch, putdat);
c01083f4:	8b 45 0c             	mov    0xc(%ebp),%eax
c01083f7:	89 44 24 04          	mov    %eax,0x4(%esp)
c01083fb:	89 1c 24             	mov    %ebx,(%esp)
c01083fe:	8b 45 08             	mov    0x8(%ebp),%eax
c0108401:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c0108403:	8b 45 10             	mov    0x10(%ebp),%eax
c0108406:	0f b6 00             	movzbl (%eax),%eax
c0108409:	0f b6 d8             	movzbl %al,%ebx
c010840c:	83 fb 25             	cmp    $0x25,%ebx
c010840f:	0f 95 c0             	setne  %al
c0108412:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c0108416:	84 c0                	test   %al,%al
c0108418:	75 d2                	jne    c01083ec <vprintfmt+0xa>
            }
            putch(ch, putdat);
        }

        // Process a %-escape sequence
        char padc = ' ';
c010841a:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
c010841e:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
c0108425:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108428:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
c010842b:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
c0108432:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108435:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108438:	eb 04                	jmp    c010843e <vprintfmt+0x5c>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
c010843a:	90                   	nop
c010843b:	eb 01                	jmp    c010843e <vprintfmt+0x5c>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
c010843d:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
c010843e:	8b 45 10             	mov    0x10(%ebp),%eax
c0108441:	0f b6 00             	movzbl (%eax),%eax
c0108444:	0f b6 d8             	movzbl %al,%ebx
c0108447:	89 d8                	mov    %ebx,%eax
c0108449:	83 45 10 01          	addl   $0x1,0x10(%ebp)
c010844d:	83 e8 23             	sub    $0x23,%eax
c0108450:	83 f8 55             	cmp    $0x55,%eax
c0108453:	0f 87 45 03 00 00    	ja     c010879e <vprintfmt+0x3bc>
c0108459:	8b 04 85 54 ad 10 c0 	mov    -0x3fef52ac(,%eax,4),%eax
c0108460:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
c0108462:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
c0108466:	eb d6                	jmp    c010843e <vprintfmt+0x5c>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
c0108468:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
c010846c:	eb d0                	jmp    c010843e <vprintfmt+0x5c>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010846e:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
c0108475:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108478:	89 d0                	mov    %edx,%eax
c010847a:	c1 e0 02             	shl    $0x2,%eax
c010847d:	01 d0                	add    %edx,%eax
c010847f:	01 c0                	add    %eax,%eax
c0108481:	01 d8                	add    %ebx,%eax
c0108483:	83 e8 30             	sub    $0x30,%eax
c0108486:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
c0108489:	8b 45 10             	mov    0x10(%ebp),%eax
c010848c:	0f b6 00             	movzbl (%eax),%eax
c010848f:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
c0108492:	83 fb 2f             	cmp    $0x2f,%ebx
c0108495:	7e 39                	jle    c01084d0 <vprintfmt+0xee>
c0108497:	83 fb 39             	cmp    $0x39,%ebx
c010849a:	7f 34                	jg     c01084d0 <vprintfmt+0xee>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
c010849c:	83 45 10 01          	addl   $0x1,0x10(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
c01084a0:	eb d3                	jmp    c0108475 <vprintfmt+0x93>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
c01084a2:	8b 45 14             	mov    0x14(%ebp),%eax
c01084a5:	8d 50 04             	lea    0x4(%eax),%edx
c01084a8:	89 55 14             	mov    %edx,0x14(%ebp)
c01084ab:	8b 00                	mov    (%eax),%eax
c01084ad:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
c01084b0:	eb 1f                	jmp    c01084d1 <vprintfmt+0xef>

        case '.':
            if (width < 0)
c01084b2:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01084b6:	79 82                	jns    c010843a <vprintfmt+0x58>
                width = 0;
c01084b8:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
c01084bf:	e9 76 ff ff ff       	jmp    c010843a <vprintfmt+0x58>

        case '#':
            altflag = 1;
c01084c4:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
c01084cb:	e9 6e ff ff ff       	jmp    c010843e <vprintfmt+0x5c>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
c01084d0:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
c01084d1:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01084d5:	0f 89 62 ff ff ff    	jns    c010843d <vprintfmt+0x5b>
                width = precision, precision = -1;
c01084db:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01084de:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01084e1:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
c01084e8:	e9 50 ff ff ff       	jmp    c010843d <vprintfmt+0x5b>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
c01084ed:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
c01084f1:	e9 48 ff ff ff       	jmp    c010843e <vprintfmt+0x5c>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat);
c01084f6:	8b 45 14             	mov    0x14(%ebp),%eax
c01084f9:	8d 50 04             	lea    0x4(%eax),%edx
c01084fc:	89 55 14             	mov    %edx,0x14(%ebp)
c01084ff:	8b 00                	mov    (%eax),%eax
c0108501:	8b 55 0c             	mov    0xc(%ebp),%edx
c0108504:	89 54 24 04          	mov    %edx,0x4(%esp)
c0108508:	89 04 24             	mov    %eax,(%esp)
c010850b:	8b 45 08             	mov    0x8(%ebp),%eax
c010850e:	ff d0                	call   *%eax
            break;
c0108510:	e9 b4 02 00 00       	jmp    c01087c9 <vprintfmt+0x3e7>

        // error message
        case 'e':
            err = va_arg(ap, int);
c0108515:	8b 45 14             	mov    0x14(%ebp),%eax
c0108518:	8d 50 04             	lea    0x4(%eax),%edx
c010851b:	89 55 14             	mov    %edx,0x14(%ebp)
c010851e:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
c0108520:	85 db                	test   %ebx,%ebx
c0108522:	79 02                	jns    c0108526 <vprintfmt+0x144>
                err = -err;
c0108524:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
c0108526:	83 fb 06             	cmp    $0x6,%ebx
c0108529:	7f 0b                	jg     c0108536 <vprintfmt+0x154>
c010852b:	8b 34 9d 14 ad 10 c0 	mov    -0x3fef52ec(,%ebx,4),%esi
c0108532:	85 f6                	test   %esi,%esi
c0108534:	75 23                	jne    c0108559 <vprintfmt+0x177>
                printfmt(putch, putdat, "error %d", err);
c0108536:	89 5c 24 0c          	mov    %ebx,0xc(%esp)
c010853a:	c7 44 24 08 41 ad 10 	movl   $0xc010ad41,0x8(%esp)
c0108541:	c0 
c0108542:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108545:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108549:	8b 45 08             	mov    0x8(%ebp),%eax
c010854c:	89 04 24             	mov    %eax,(%esp)
c010854f:	e8 5e fe ff ff       	call   c01083b2 <printfmt>
            }
            else {
                printfmt(putch, putdat, "%s", p);
            }
            break;
c0108554:	e9 70 02 00 00       	jmp    c01087c9 <vprintfmt+0x3e7>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, putdat, "error %d", err);
            }
            else {
                printfmt(putch, putdat, "%s", p);
c0108559:	89 74 24 0c          	mov    %esi,0xc(%esp)
c010855d:	c7 44 24 08 4a ad 10 	movl   $0xc010ad4a,0x8(%esp)
c0108564:	c0 
c0108565:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108568:	89 44 24 04          	mov    %eax,0x4(%esp)
c010856c:	8b 45 08             	mov    0x8(%ebp),%eax
c010856f:	89 04 24             	mov    %eax,(%esp)
c0108572:	e8 3b fe ff ff       	call   c01083b2 <printfmt>
            }
            break;
c0108577:	e9 4d 02 00 00       	jmp    c01087c9 <vprintfmt+0x3e7>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
c010857c:	8b 45 14             	mov    0x14(%ebp),%eax
c010857f:	8d 50 04             	lea    0x4(%eax),%edx
c0108582:	89 55 14             	mov    %edx,0x14(%ebp)
c0108585:	8b 30                	mov    (%eax),%esi
c0108587:	85 f6                	test   %esi,%esi
c0108589:	75 05                	jne    c0108590 <vprintfmt+0x1ae>
                p = "(null)";
c010858b:	be 4d ad 10 c0       	mov    $0xc010ad4d,%esi
            }
            if (width > 0 && padc != '-') {
c0108590:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108594:	7e 7c                	jle    c0108612 <vprintfmt+0x230>
c0108596:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
c010859a:	74 76                	je     c0108612 <vprintfmt+0x230>
                for (width -= strnlen(p, precision); width > 0; width --) {
c010859c:	8b 5d e8             	mov    -0x18(%ebp),%ebx
c010859f:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c01085a2:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085a6:	89 34 24             	mov    %esi,(%esp)
c01085a9:	e8 25 04 00 00       	call   c01089d3 <strnlen>
c01085ae:	89 da                	mov    %ebx,%edx
c01085b0:	29 c2                	sub    %eax,%edx
c01085b2:	89 d0                	mov    %edx,%eax
c01085b4:	89 45 e8             	mov    %eax,-0x18(%ebp)
c01085b7:	eb 17                	jmp    c01085d0 <vprintfmt+0x1ee>
                    putch(padc, putdat);
c01085b9:	0f be 45 db          	movsbl -0x25(%ebp),%eax
c01085bd:	8b 55 0c             	mov    0xc(%ebp),%edx
c01085c0:	89 54 24 04          	mov    %edx,0x4(%esp)
c01085c4:	89 04 24             	mov    %eax,(%esp)
c01085c7:	8b 45 08             	mov    0x8(%ebp),%eax
c01085ca:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
c01085cc:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c01085d0:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c01085d4:	7f e3                	jg     c01085b9 <vprintfmt+0x1d7>
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c01085d6:	eb 3a                	jmp    c0108612 <vprintfmt+0x230>
                if (altflag && (ch < ' ' || ch > '~')) {
c01085d8:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
c01085dc:	74 1f                	je     c01085fd <vprintfmt+0x21b>
c01085de:	83 fb 1f             	cmp    $0x1f,%ebx
c01085e1:	7e 05                	jle    c01085e8 <vprintfmt+0x206>
c01085e3:	83 fb 7e             	cmp    $0x7e,%ebx
c01085e6:	7e 15                	jle    c01085fd <vprintfmt+0x21b>
                    putch('?', putdat);
c01085e8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01085eb:	89 44 24 04          	mov    %eax,0x4(%esp)
c01085ef:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
c01085f6:	8b 45 08             	mov    0x8(%ebp),%eax
c01085f9:	ff d0                	call   *%eax
c01085fb:	eb 0f                	jmp    c010860c <vprintfmt+0x22a>
                }
                else {
                    putch(ch, putdat);
c01085fd:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108600:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108604:	89 1c 24             	mov    %ebx,(%esp)
c0108607:	8b 45 08             	mov    0x8(%ebp),%eax
c010860a:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
c010860c:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c0108610:	eb 01                	jmp    c0108613 <vprintfmt+0x231>
c0108612:	90                   	nop
c0108613:	0f b6 06             	movzbl (%esi),%eax
c0108616:	0f be d8             	movsbl %al,%ebx
c0108619:	85 db                	test   %ebx,%ebx
c010861b:	0f 95 c0             	setne  %al
c010861e:	83 c6 01             	add    $0x1,%esi
c0108621:	84 c0                	test   %al,%al
c0108623:	74 29                	je     c010864e <vprintfmt+0x26c>
c0108625:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108629:	78 ad                	js     c01085d8 <vprintfmt+0x1f6>
c010862b:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
c010862f:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
c0108633:	79 a3                	jns    c01085d8 <vprintfmt+0x1f6>
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c0108635:	eb 17                	jmp    c010864e <vprintfmt+0x26c>
                putch(' ', putdat);
c0108637:	8b 45 0c             	mov    0xc(%ebp),%eax
c010863a:	89 44 24 04          	mov    %eax,0x4(%esp)
c010863e:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
c0108645:	8b 45 08             	mov    0x8(%ebp),%eax
c0108648:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat);
                }
            }
            for (; width > 0; width --) {
c010864a:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
c010864e:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c0108652:	7f e3                	jg     c0108637 <vprintfmt+0x255>
                putch(' ', putdat);
            }
            break;
c0108654:	e9 70 01 00 00       	jmp    c01087c9 <vprintfmt+0x3e7>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
c0108659:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010865c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108660:	8d 45 14             	lea    0x14(%ebp),%eax
c0108663:	89 04 24             	mov    %eax,(%esp)
c0108666:	e8 f8 fc ff ff       	call   c0108363 <getint>
c010866b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010866e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
c0108671:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108674:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108677:	85 d2                	test   %edx,%edx
c0108679:	79 26                	jns    c01086a1 <vprintfmt+0x2bf>
                putch('-', putdat);
c010867b:	8b 45 0c             	mov    0xc(%ebp),%eax
c010867e:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108682:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
c0108689:	8b 45 08             	mov    0x8(%ebp),%eax
c010868c:	ff d0                	call   *%eax
                num = -(long long)num;
c010868e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108691:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108694:	f7 d8                	neg    %eax
c0108696:	83 d2 00             	adc    $0x0,%edx
c0108699:	f7 da                	neg    %edx
c010869b:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010869e:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
c01086a1:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01086a8:	e9 a8 00 00 00       	jmp    c0108755 <vprintfmt+0x373>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
c01086ad:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01086b0:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086b4:	8d 45 14             	lea    0x14(%ebp),%eax
c01086b7:	89 04 24             	mov    %eax,(%esp)
c01086ba:	e8 55 fc ff ff       	call   c0108314 <getuint>
c01086bf:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086c2:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
c01086c5:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
c01086cc:	e9 84 00 00 00       	jmp    c0108755 <vprintfmt+0x373>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
c01086d1:	8b 45 e0             	mov    -0x20(%ebp),%eax
c01086d4:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086d8:	8d 45 14             	lea    0x14(%ebp),%eax
c01086db:	89 04 24             	mov    %eax,(%esp)
c01086de:	e8 31 fc ff ff       	call   c0108314 <getuint>
c01086e3:	89 45 f0             	mov    %eax,-0x10(%ebp)
c01086e6:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
c01086e9:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
c01086f0:	eb 63                	jmp    c0108755 <vprintfmt+0x373>

        // pointer
        case 'p':
            putch('0', putdat);
c01086f2:	8b 45 0c             	mov    0xc(%ebp),%eax
c01086f5:	89 44 24 04          	mov    %eax,0x4(%esp)
c01086f9:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
c0108700:	8b 45 08             	mov    0x8(%ebp),%eax
c0108703:	ff d0                	call   *%eax
            putch('x', putdat);
c0108705:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108708:	89 44 24 04          	mov    %eax,0x4(%esp)
c010870c:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
c0108713:	8b 45 08             	mov    0x8(%ebp),%eax
c0108716:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
c0108718:	8b 45 14             	mov    0x14(%ebp),%eax
c010871b:	8d 50 04             	lea    0x4(%eax),%edx
c010871e:	89 55 14             	mov    %edx,0x14(%ebp)
c0108721:	8b 00                	mov    (%eax),%eax
c0108723:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108726:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
c010872d:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
c0108734:	eb 1f                	jmp    c0108755 <vprintfmt+0x373>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
c0108736:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108739:	89 44 24 04          	mov    %eax,0x4(%esp)
c010873d:	8d 45 14             	lea    0x14(%ebp),%eax
c0108740:	89 04 24             	mov    %eax,(%esp)
c0108743:	e8 cc fb ff ff       	call   c0108314 <getuint>
c0108748:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010874b:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
c010874e:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, putdat, num, base, width, padc);
c0108755:	0f be 55 db          	movsbl -0x25(%ebp),%edx
c0108759:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010875c:	89 54 24 18          	mov    %edx,0x18(%esp)
c0108760:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108763:	89 54 24 14          	mov    %edx,0x14(%esp)
c0108767:	89 44 24 10          	mov    %eax,0x10(%esp)
c010876b:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010876e:	8b 55 f4             	mov    -0xc(%ebp),%edx
c0108771:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108775:	89 54 24 0c          	mov    %edx,0xc(%esp)
c0108779:	8b 45 0c             	mov    0xc(%ebp),%eax
c010877c:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108780:	8b 45 08             	mov    0x8(%ebp),%eax
c0108783:	89 04 24             	mov    %eax,(%esp)
c0108786:	e8 51 fa ff ff       	call   c01081dc <printnum>
            break;
c010878b:	eb 3c                	jmp    c01087c9 <vprintfmt+0x3e7>

        // escaped '%' character
        case '%':
            putch(ch, putdat);
c010878d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108790:	89 44 24 04          	mov    %eax,0x4(%esp)
c0108794:	89 1c 24             	mov    %ebx,(%esp)
c0108797:	8b 45 08             	mov    0x8(%ebp),%eax
c010879a:	ff d0                	call   *%eax
            break;
c010879c:	eb 2b                	jmp    c01087c9 <vprintfmt+0x3e7>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat);
c010879e:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087a1:	89 44 24 04          	mov    %eax,0x4(%esp)
c01087a5:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
c01087ac:	8b 45 08             	mov    0x8(%ebp),%eax
c01087af:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
c01087b1:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01087b5:	eb 04                	jmp    c01087bb <vprintfmt+0x3d9>
c01087b7:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c01087bb:	8b 45 10             	mov    0x10(%ebp),%eax
c01087be:	83 e8 01             	sub    $0x1,%eax
c01087c1:	0f b6 00             	movzbl (%eax),%eax
c01087c4:	3c 25                	cmp    $0x25,%al
c01087c6:	75 ef                	jne    c01087b7 <vprintfmt+0x3d5>
                /* do nothing */;
            break;
c01087c8:	90                   	nop
        }
    }
c01087c9:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
c01087ca:	e9 34 fc ff ff       	jmp    c0108403 <vprintfmt+0x21>
            if (ch == '\0') {
                return;
c01087cf:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
c01087d0:	83 c4 40             	add    $0x40,%esp
c01087d3:	5b                   	pop    %ebx
c01087d4:	5e                   	pop    %esi
c01087d5:	5d                   	pop    %ebp
c01087d6:	c3                   	ret    

c01087d7 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
c01087d7:	55                   	push   %ebp
c01087d8:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
c01087da:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087dd:	8b 40 08             	mov    0x8(%eax),%eax
c01087e0:	8d 50 01             	lea    0x1(%eax),%edx
c01087e3:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087e6:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
c01087e9:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087ec:	8b 10                	mov    (%eax),%edx
c01087ee:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087f1:	8b 40 04             	mov    0x4(%eax),%eax
c01087f4:	39 c2                	cmp    %eax,%edx
c01087f6:	73 12                	jae    c010880a <sprintputch+0x33>
        *b->buf ++ = ch;
c01087f8:	8b 45 0c             	mov    0xc(%ebp),%eax
c01087fb:	8b 00                	mov    (%eax),%eax
c01087fd:	8b 55 08             	mov    0x8(%ebp),%edx
c0108800:	88 10                	mov    %dl,(%eax)
c0108802:	8d 50 01             	lea    0x1(%eax),%edx
c0108805:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108808:	89 10                	mov    %edx,(%eax)
    }
}
c010880a:	5d                   	pop    %ebp
c010880b:	c3                   	ret    

c010880c <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
c010880c:	55                   	push   %ebp
c010880d:	89 e5                	mov    %esp,%ebp
c010880f:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
c0108812:	8d 55 14             	lea    0x14(%ebp),%edx
c0108815:	8d 45 f0             	lea    -0x10(%ebp),%eax
c0108818:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
c010881a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010881d:	89 44 24 0c          	mov    %eax,0xc(%esp)
c0108821:	8b 45 10             	mov    0x10(%ebp),%eax
c0108824:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108828:	8b 45 0c             	mov    0xc(%ebp),%eax
c010882b:	89 44 24 04          	mov    %eax,0x4(%esp)
c010882f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108832:	89 04 24             	mov    %eax,(%esp)
c0108835:	e8 08 00 00 00       	call   c0108842 <vsnprintf>
c010883a:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
c010883d:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c0108840:	c9                   	leave  
c0108841:	c3                   	ret    

c0108842 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
c0108842:	55                   	push   %ebp
c0108843:	89 e5                	mov    %esp,%ebp
c0108845:	83 ec 28             	sub    $0x28,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
c0108848:	8b 45 08             	mov    0x8(%ebp),%eax
c010884b:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010884e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108851:	83 e8 01             	sub    $0x1,%eax
c0108854:	03 45 08             	add    0x8(%ebp),%eax
c0108857:	89 45 f0             	mov    %eax,-0x10(%ebp)
c010885a:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
c0108861:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
c0108865:	74 0a                	je     c0108871 <vsnprintf+0x2f>
c0108867:	8b 55 ec             	mov    -0x14(%ebp),%edx
c010886a:	8b 45 f0             	mov    -0x10(%ebp),%eax
c010886d:	39 c2                	cmp    %eax,%edx
c010886f:	76 07                	jbe    c0108878 <vsnprintf+0x36>
        return -E_INVAL;
c0108871:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
c0108876:	eb 2a                	jmp    c01088a2 <vsnprintf+0x60>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, &b, fmt, ap);
c0108878:	8b 45 14             	mov    0x14(%ebp),%eax
c010887b:	89 44 24 0c          	mov    %eax,0xc(%esp)
c010887f:	8b 45 10             	mov    0x10(%ebp),%eax
c0108882:	89 44 24 08          	mov    %eax,0x8(%esp)
c0108886:	8d 45 ec             	lea    -0x14(%ebp),%eax
c0108889:	89 44 24 04          	mov    %eax,0x4(%esp)
c010888d:	c7 04 24 d7 87 10 c0 	movl   $0xc01087d7,(%esp)
c0108894:	e8 49 fb ff ff       	call   c01083e2 <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
c0108899:	8b 45 ec             	mov    -0x14(%ebp),%eax
c010889c:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
c010889f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
c01088a2:	c9                   	leave  
c01088a3:	c3                   	ret    

c01088a4 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
c01088a4:	55                   	push   %ebp
c01088a5:	89 e5                	mov    %esp,%ebp
c01088a7:	57                   	push   %edi
c01088a8:	56                   	push   %esi
c01088a9:	53                   	push   %ebx
c01088aa:	83 ec 34             	sub    $0x34,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
c01088ad:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c01088b2:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c01088b8:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
c01088be:	6b c8 05             	imul   $0x5,%eax,%ecx
c01088c1:	01 cf                	add    %ecx,%edi
c01088c3:	b9 6d e6 ec de       	mov    $0xdeece66d,%ecx
c01088c8:	f7 e1                	mul    %ecx
c01088ca:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
c01088cd:	89 ca                	mov    %ecx,%edx
c01088cf:	83 c0 0b             	add    $0xb,%eax
c01088d2:	83 d2 00             	adc    $0x0,%edx
c01088d5:	89 c3                	mov    %eax,%ebx
c01088d7:	80 e7 ff             	and    $0xff,%bh
c01088da:	0f b7 f2             	movzwl %dx,%esi
c01088dd:	89 1d 60 0a 12 c0    	mov    %ebx,0xc0120a60
c01088e3:	89 35 64 0a 12 c0    	mov    %esi,0xc0120a64
    unsigned long long result = (next >> 12);
c01088e9:	a1 60 0a 12 c0       	mov    0xc0120a60,%eax
c01088ee:	8b 15 64 0a 12 c0    	mov    0xc0120a64,%edx
c01088f4:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
c01088f8:	c1 ea 0c             	shr    $0xc,%edx
c01088fb:	89 45 e0             	mov    %eax,-0x20(%ebp)
c01088fe:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
c0108901:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
c0108908:	8b 45 e0             	mov    -0x20(%ebp),%eax
c010890b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c010890e:	89 45 c8             	mov    %eax,-0x38(%ebp)
c0108911:	89 55 cc             	mov    %edx,-0x34(%ebp)
c0108914:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108917:	8b 55 cc             	mov    -0x34(%ebp),%edx
c010891a:	89 d3                	mov    %edx,%ebx
c010891c:	89 c6                	mov    %eax,%esi
c010891e:	89 75 d8             	mov    %esi,-0x28(%ebp)
c0108921:	89 5d e8             	mov    %ebx,-0x18(%ebp)
c0108924:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108927:	89 45 ec             	mov    %eax,-0x14(%ebp)
c010892a:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
c010892e:	74 1c                	je     c010894c <rand+0xa8>
c0108930:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108933:	ba 00 00 00 00       	mov    $0x0,%edx
c0108938:	f7 75 dc             	divl   -0x24(%ebp)
c010893b:	89 55 ec             	mov    %edx,-0x14(%ebp)
c010893e:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108941:	ba 00 00 00 00       	mov    $0x0,%edx
c0108946:	f7 75 dc             	divl   -0x24(%ebp)
c0108949:	89 45 e8             	mov    %eax,-0x18(%ebp)
c010894c:	8b 55 d8             	mov    -0x28(%ebp),%edx
c010894f:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108952:	89 d6                	mov    %edx,%esi
c0108954:	89 c3                	mov    %eax,%ebx
c0108956:	89 f0                	mov    %esi,%eax
c0108958:	89 da                	mov    %ebx,%edx
c010895a:	f7 75 dc             	divl   -0x24(%ebp)
c010895d:	89 d3                	mov    %edx,%ebx
c010895f:	89 c6                	mov    %eax,%esi
c0108961:	89 75 d8             	mov    %esi,-0x28(%ebp)
c0108964:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
c0108967:	8b 45 d8             	mov    -0x28(%ebp),%eax
c010896a:	89 45 c8             	mov    %eax,-0x38(%ebp)
c010896d:	8b 55 e8             	mov    -0x18(%ebp),%edx
c0108970:	89 55 c4             	mov    %edx,-0x3c(%ebp)
c0108973:	8b 45 c8             	mov    -0x38(%ebp),%eax
c0108976:	8b 55 c4             	mov    -0x3c(%ebp),%edx
c0108979:	89 c3                	mov    %eax,%ebx
c010897b:	89 d6                	mov    %edx,%esi
c010897d:	89 5d e0             	mov    %ebx,-0x20(%ebp)
c0108980:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0108983:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
c0108986:	83 c4 34             	add    $0x34,%esp
c0108989:	5b                   	pop    %ebx
c010898a:	5e                   	pop    %esi
c010898b:	5f                   	pop    %edi
c010898c:	5d                   	pop    %ebp
c010898d:	c3                   	ret    

c010898e <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
c010898e:	55                   	push   %ebp
c010898f:	89 e5                	mov    %esp,%ebp
    next = seed;
c0108991:	8b 45 08             	mov    0x8(%ebp),%eax
c0108994:	ba 00 00 00 00       	mov    $0x0,%edx
c0108999:	a3 60 0a 12 c0       	mov    %eax,0xc0120a60
c010899e:	89 15 64 0a 12 c0    	mov    %edx,0xc0120a64
}
c01089a4:	5d                   	pop    %ebp
c01089a5:	c3                   	ret    
	...

c01089a8 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
c01089a8:	55                   	push   %ebp
c01089a9:	89 e5                	mov    %esp,%ebp
c01089ab:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01089ae:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
c01089b5:	eb 04                	jmp    c01089bb <strlen+0x13>
        cnt ++;
c01089b7:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
c01089bb:	8b 45 08             	mov    0x8(%ebp),%eax
c01089be:	0f b6 00             	movzbl (%eax),%eax
c01089c1:	84 c0                	test   %al,%al
c01089c3:	0f 95 c0             	setne  %al
c01089c6:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01089ca:	84 c0                	test   %al,%al
c01089cc:	75 e9                	jne    c01089b7 <strlen+0xf>
        cnt ++;
    }
    return cnt;
c01089ce:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c01089d1:	c9                   	leave  
c01089d2:	c3                   	ret    

c01089d3 <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
c01089d3:	55                   	push   %ebp
c01089d4:	89 e5                	mov    %esp,%ebp
c01089d6:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
c01089d9:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
c01089e0:	eb 04                	jmp    c01089e6 <strnlen+0x13>
        cnt ++;
c01089e2:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
c01089e6:	8b 45 fc             	mov    -0x4(%ebp),%eax
c01089e9:	3b 45 0c             	cmp    0xc(%ebp),%eax
c01089ec:	73 13                	jae    c0108a01 <strnlen+0x2e>
c01089ee:	8b 45 08             	mov    0x8(%ebp),%eax
c01089f1:	0f b6 00             	movzbl (%eax),%eax
c01089f4:	84 c0                	test   %al,%al
c01089f6:	0f 95 c0             	setne  %al
c01089f9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c01089fd:	84 c0                	test   %al,%al
c01089ff:	75 e1                	jne    c01089e2 <strnlen+0xf>
        cnt ++;
    }
    return cnt;
c0108a01:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
c0108a04:	c9                   	leave  
c0108a05:	c3                   	ret    

c0108a06 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
c0108a06:	55                   	push   %ebp
c0108a07:	89 e5                	mov    %esp,%ebp
c0108a09:	57                   	push   %edi
c0108a0a:	56                   	push   %esi
c0108a0b:	53                   	push   %ebx
c0108a0c:	83 ec 24             	sub    $0x24,%esp
c0108a0f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a12:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a15:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a18:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
c0108a1b:	8b 55 ec             	mov    -0x14(%ebp),%edx
c0108a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108a21:	89 d6                	mov    %edx,%esi
c0108a23:	89 c3                	mov    %eax,%ebx
c0108a25:	89 df                	mov    %ebx,%edi
c0108a27:	ac                   	lods   %ds:(%esi),%al
c0108a28:	aa                   	stos   %al,%es:(%edi)
c0108a29:	84 c0                	test   %al,%al
c0108a2b:	75 fa                	jne    c0108a27 <strcpy+0x21>
c0108a2d:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108a30:	89 fb                	mov    %edi,%ebx
c0108a32:	89 75 e8             	mov    %esi,-0x18(%ebp)
c0108a35:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
c0108a38:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108a3b:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
c0108a3e:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
c0108a41:	83 c4 24             	add    $0x24,%esp
c0108a44:	5b                   	pop    %ebx
c0108a45:	5e                   	pop    %esi
c0108a46:	5f                   	pop    %edi
c0108a47:	5d                   	pop    %ebp
c0108a48:	c3                   	ret    

c0108a49 <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
c0108a49:	55                   	push   %ebp
c0108a4a:	89 e5                	mov    %esp,%ebp
c0108a4c:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
c0108a4f:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a52:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
c0108a55:	eb 21                	jmp    c0108a78 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
c0108a57:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a5a:	0f b6 10             	movzbl (%eax),%edx
c0108a5d:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a60:	88 10                	mov    %dl,(%eax)
c0108a62:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108a65:	0f b6 00             	movzbl (%eax),%eax
c0108a68:	84 c0                	test   %al,%al
c0108a6a:	74 04                	je     c0108a70 <strncpy+0x27>
            src ++;
c0108a6c:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
c0108a70:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108a74:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
c0108a78:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108a7c:	75 d9                	jne    c0108a57 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
c0108a7e:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108a81:	c9                   	leave  
c0108a82:	c3                   	ret    

c0108a83 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
c0108a83:	55                   	push   %ebp
c0108a84:	89 e5                	mov    %esp,%ebp
c0108a86:	57                   	push   %edi
c0108a87:	56                   	push   %esi
c0108a88:	53                   	push   %ebx
c0108a89:	83 ec 24             	sub    $0x24,%esp
c0108a8c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108a8f:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108a92:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108a95:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
c0108a98:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108a9b:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108a9e:	89 d6                	mov    %edx,%esi
c0108aa0:	89 c3                	mov    %eax,%ebx
c0108aa2:	89 df                	mov    %ebx,%edi
c0108aa4:	ac                   	lods   %ds:(%esi),%al
c0108aa5:	ae                   	scas   %es:(%edi),%al
c0108aa6:	75 08                	jne    c0108ab0 <strcmp+0x2d>
c0108aa8:	84 c0                	test   %al,%al
c0108aaa:	75 f8                	jne    c0108aa4 <strcmp+0x21>
c0108aac:	31 c0                	xor    %eax,%eax
c0108aae:	eb 04                	jmp    c0108ab4 <strcmp+0x31>
c0108ab0:	19 c0                	sbb    %eax,%eax
c0108ab2:	0c 01                	or     $0x1,%al
c0108ab4:	89 fb                	mov    %edi,%ebx
c0108ab6:	89 45 d0             	mov    %eax,-0x30(%ebp)
c0108ab9:	8b 45 d0             	mov    -0x30(%ebp),%eax
c0108abc:	89 45 e8             	mov    %eax,-0x18(%ebp)
c0108abf:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0108ac2:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
c0108ac5:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
c0108ac8:	83 c4 24             	add    $0x24,%esp
c0108acb:	5b                   	pop    %ebx
c0108acc:	5e                   	pop    %esi
c0108acd:	5f                   	pop    %edi
c0108ace:	5d                   	pop    %ebp
c0108acf:	c3                   	ret    

c0108ad0 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
c0108ad0:	55                   	push   %ebp
c0108ad1:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108ad3:	eb 0c                	jmp    c0108ae1 <strncmp+0x11>
        n --, s1 ++, s2 ++;
c0108ad5:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108ad9:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108add:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
c0108ae1:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108ae5:	74 1a                	je     c0108b01 <strncmp+0x31>
c0108ae7:	8b 45 08             	mov    0x8(%ebp),%eax
c0108aea:	0f b6 00             	movzbl (%eax),%eax
c0108aed:	84 c0                	test   %al,%al
c0108aef:	74 10                	je     c0108b01 <strncmp+0x31>
c0108af1:	8b 45 08             	mov    0x8(%ebp),%eax
c0108af4:	0f b6 10             	movzbl (%eax),%edx
c0108af7:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108afa:	0f b6 00             	movzbl (%eax),%eax
c0108afd:	38 c2                	cmp    %al,%dl
c0108aff:	74 d4                	je     c0108ad5 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108b01:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108b05:	74 1a                	je     c0108b21 <strncmp+0x51>
c0108b07:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b0a:	0f b6 00             	movzbl (%eax),%eax
c0108b0d:	0f b6 d0             	movzbl %al,%edx
c0108b10:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b13:	0f b6 00             	movzbl (%eax),%eax
c0108b16:	0f b6 c0             	movzbl %al,%eax
c0108b19:	89 d1                	mov    %edx,%ecx
c0108b1b:	29 c1                	sub    %eax,%ecx
c0108b1d:	89 c8                	mov    %ecx,%eax
c0108b1f:	eb 05                	jmp    c0108b26 <strncmp+0x56>
c0108b21:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108b26:	5d                   	pop    %ebp
c0108b27:	c3                   	ret    

c0108b28 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
c0108b28:	55                   	push   %ebp
c0108b29:	89 e5                	mov    %esp,%ebp
c0108b2b:	83 ec 04             	sub    $0x4,%esp
c0108b2e:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b31:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108b34:	eb 14                	jmp    c0108b4a <strchr+0x22>
        if (*s == c) {
c0108b36:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b39:	0f b6 00             	movzbl (%eax),%eax
c0108b3c:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108b3f:	75 05                	jne    c0108b46 <strchr+0x1e>
            return (char *)s;
c0108b41:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b44:	eb 13                	jmp    c0108b59 <strchr+0x31>
        }
        s ++;
c0108b46:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
c0108b4a:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b4d:	0f b6 00             	movzbl (%eax),%eax
c0108b50:	84 c0                	test   %al,%al
c0108b52:	75 e2                	jne    c0108b36 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
c0108b54:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108b59:	c9                   	leave  
c0108b5a:	c3                   	ret    

c0108b5b <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
c0108b5b:	55                   	push   %ebp
c0108b5c:	89 e5                	mov    %esp,%ebp
c0108b5e:	83 ec 04             	sub    $0x4,%esp
c0108b61:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108b64:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
c0108b67:	eb 0f                	jmp    c0108b78 <strfind+0x1d>
        if (*s == c) {
c0108b69:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b6c:	0f b6 00             	movzbl (%eax),%eax
c0108b6f:	3a 45 fc             	cmp    -0x4(%ebp),%al
c0108b72:	74 10                	je     c0108b84 <strfind+0x29>
            break;
        }
        s ++;
c0108b74:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
c0108b78:	8b 45 08             	mov    0x8(%ebp),%eax
c0108b7b:	0f b6 00             	movzbl (%eax),%eax
c0108b7e:	84 c0                	test   %al,%al
c0108b80:	75 e7                	jne    c0108b69 <strfind+0xe>
c0108b82:	eb 01                	jmp    c0108b85 <strfind+0x2a>
        if (*s == c) {
            break;
c0108b84:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
c0108b85:	8b 45 08             	mov    0x8(%ebp),%eax
}
c0108b88:	c9                   	leave  
c0108b89:	c3                   	ret    

c0108b8a <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
c0108b8a:	55                   	push   %ebp
c0108b8b:	89 e5                	mov    %esp,%ebp
c0108b8d:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
c0108b90:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
c0108b97:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108b9e:	eb 04                	jmp    c0108ba4 <strtol+0x1a>
        s ++;
c0108ba0:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
c0108ba4:	8b 45 08             	mov    0x8(%ebp),%eax
c0108ba7:	0f b6 00             	movzbl (%eax),%eax
c0108baa:	3c 20                	cmp    $0x20,%al
c0108bac:	74 f2                	je     c0108ba0 <strtol+0x16>
c0108bae:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bb1:	0f b6 00             	movzbl (%eax),%eax
c0108bb4:	3c 09                	cmp    $0x9,%al
c0108bb6:	74 e8                	je     c0108ba0 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
c0108bb8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bbb:	0f b6 00             	movzbl (%eax),%eax
c0108bbe:	3c 2b                	cmp    $0x2b,%al
c0108bc0:	75 06                	jne    c0108bc8 <strtol+0x3e>
        s ++;
c0108bc2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108bc6:	eb 15                	jmp    c0108bdd <strtol+0x53>
    }
    else if (*s == '-') {
c0108bc8:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bcb:	0f b6 00             	movzbl (%eax),%eax
c0108bce:	3c 2d                	cmp    $0x2d,%al
c0108bd0:	75 0b                	jne    c0108bdd <strtol+0x53>
        s ++, neg = 1;
c0108bd2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108bd6:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
c0108bdd:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108be1:	74 06                	je     c0108be9 <strtol+0x5f>
c0108be3:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
c0108be7:	75 24                	jne    c0108c0d <strtol+0x83>
c0108be9:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bec:	0f b6 00             	movzbl (%eax),%eax
c0108bef:	3c 30                	cmp    $0x30,%al
c0108bf1:	75 1a                	jne    c0108c0d <strtol+0x83>
c0108bf3:	8b 45 08             	mov    0x8(%ebp),%eax
c0108bf6:	83 c0 01             	add    $0x1,%eax
c0108bf9:	0f b6 00             	movzbl (%eax),%eax
c0108bfc:	3c 78                	cmp    $0x78,%al
c0108bfe:	75 0d                	jne    c0108c0d <strtol+0x83>
        s += 2, base = 16;
c0108c00:	83 45 08 02          	addl   $0x2,0x8(%ebp)
c0108c04:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
c0108c0b:	eb 2a                	jmp    c0108c37 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
c0108c0d:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108c11:	75 17                	jne    c0108c2a <strtol+0xa0>
c0108c13:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c16:	0f b6 00             	movzbl (%eax),%eax
c0108c19:	3c 30                	cmp    $0x30,%al
c0108c1b:	75 0d                	jne    c0108c2a <strtol+0xa0>
        s ++, base = 8;
c0108c1d:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108c21:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
c0108c28:	eb 0d                	jmp    c0108c37 <strtol+0xad>
    }
    else if (base == 0) {
c0108c2a:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108c2e:	75 07                	jne    c0108c37 <strtol+0xad>
        base = 10;
c0108c30:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
c0108c37:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c3a:	0f b6 00             	movzbl (%eax),%eax
c0108c3d:	3c 2f                	cmp    $0x2f,%al
c0108c3f:	7e 1b                	jle    c0108c5c <strtol+0xd2>
c0108c41:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c44:	0f b6 00             	movzbl (%eax),%eax
c0108c47:	3c 39                	cmp    $0x39,%al
c0108c49:	7f 11                	jg     c0108c5c <strtol+0xd2>
            dig = *s - '0';
c0108c4b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c4e:	0f b6 00             	movzbl (%eax),%eax
c0108c51:	0f be c0             	movsbl %al,%eax
c0108c54:	83 e8 30             	sub    $0x30,%eax
c0108c57:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c5a:	eb 48                	jmp    c0108ca4 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
c0108c5c:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c5f:	0f b6 00             	movzbl (%eax),%eax
c0108c62:	3c 60                	cmp    $0x60,%al
c0108c64:	7e 1b                	jle    c0108c81 <strtol+0xf7>
c0108c66:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c69:	0f b6 00             	movzbl (%eax),%eax
c0108c6c:	3c 7a                	cmp    $0x7a,%al
c0108c6e:	7f 11                	jg     c0108c81 <strtol+0xf7>
            dig = *s - 'a' + 10;
c0108c70:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c73:	0f b6 00             	movzbl (%eax),%eax
c0108c76:	0f be c0             	movsbl %al,%eax
c0108c79:	83 e8 57             	sub    $0x57,%eax
c0108c7c:	89 45 f4             	mov    %eax,-0xc(%ebp)
c0108c7f:	eb 23                	jmp    c0108ca4 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
c0108c81:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c84:	0f b6 00             	movzbl (%eax),%eax
c0108c87:	3c 40                	cmp    $0x40,%al
c0108c89:	7e 38                	jle    c0108cc3 <strtol+0x139>
c0108c8b:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c8e:	0f b6 00             	movzbl (%eax),%eax
c0108c91:	3c 5a                	cmp    $0x5a,%al
c0108c93:	7f 2e                	jg     c0108cc3 <strtol+0x139>
            dig = *s - 'A' + 10;
c0108c95:	8b 45 08             	mov    0x8(%ebp),%eax
c0108c98:	0f b6 00             	movzbl (%eax),%eax
c0108c9b:	0f be c0             	movsbl %al,%eax
c0108c9e:	83 e8 37             	sub    $0x37,%eax
c0108ca1:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
c0108ca4:	8b 45 f4             	mov    -0xc(%ebp),%eax
c0108ca7:	3b 45 10             	cmp    0x10(%ebp),%eax
c0108caa:	7d 16                	jge    c0108cc2 <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
c0108cac:	83 45 08 01          	addl   $0x1,0x8(%ebp)
c0108cb0:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108cb3:	0f af 45 10          	imul   0x10(%ebp),%eax
c0108cb7:	03 45 f4             	add    -0xc(%ebp),%eax
c0108cba:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
c0108cbd:	e9 75 ff ff ff       	jmp    c0108c37 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
c0108cc2:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
c0108cc3:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
c0108cc7:	74 08                	je     c0108cd1 <strtol+0x147>
        *endptr = (char *) s;
c0108cc9:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108ccc:	8b 55 08             	mov    0x8(%ebp),%edx
c0108ccf:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
c0108cd1:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
c0108cd5:	74 07                	je     c0108cde <strtol+0x154>
c0108cd7:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108cda:	f7 d8                	neg    %eax
c0108cdc:	eb 03                	jmp    c0108ce1 <strtol+0x157>
c0108cde:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
c0108ce1:	c9                   	leave  
c0108ce2:	c3                   	ret    

c0108ce3 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
c0108ce3:	55                   	push   %ebp
c0108ce4:	89 e5                	mov    %esp,%ebp
c0108ce6:	57                   	push   %edi
c0108ce7:	56                   	push   %esi
c0108ce8:	53                   	push   %ebx
c0108ce9:	83 ec 24             	sub    $0x24,%esp
c0108cec:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108cef:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
c0108cf2:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
c0108cf6:	8b 55 08             	mov    0x8(%ebp),%edx
c0108cf9:	89 55 f0             	mov    %edx,-0x10(%ebp)
c0108cfc:	88 45 ef             	mov    %al,-0x11(%ebp)
c0108cff:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d02:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
c0108d05:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0108d08:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
c0108d0c:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108d0f:	89 ce                	mov    %ecx,%esi
c0108d11:	89 d3                	mov    %edx,%ebx
c0108d13:	89 f1                	mov    %esi,%ecx
c0108d15:	89 df                	mov    %ebx,%edi
c0108d17:	f3 aa                	rep stos %al,%es:(%edi)
c0108d19:	89 fb                	mov    %edi,%ebx
c0108d1b:	89 ce                	mov    %ecx,%esi
c0108d1d:	89 75 e4             	mov    %esi,-0x1c(%ebp)
c0108d20:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
c0108d23:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
c0108d26:	83 c4 24             	add    $0x24,%esp
c0108d29:	5b                   	pop    %ebx
c0108d2a:	5e                   	pop    %esi
c0108d2b:	5f                   	pop    %edi
c0108d2c:	5d                   	pop    %ebp
c0108d2d:	c3                   	ret    

c0108d2e <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
c0108d2e:	55                   	push   %ebp
c0108d2f:	89 e5                	mov    %esp,%ebp
c0108d31:	57                   	push   %edi
c0108d32:	56                   	push   %esi
c0108d33:	53                   	push   %ebx
c0108d34:	83 ec 38             	sub    $0x38,%esp
c0108d37:	8b 45 08             	mov    0x8(%ebp),%eax
c0108d3a:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108d3d:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108d40:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108d43:	8b 45 10             	mov    0x10(%ebp),%eax
c0108d46:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
c0108d49:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d4c:	3b 45 ec             	cmp    -0x14(%ebp),%eax
c0108d4f:	73 4e                	jae    c0108d9f <memmove+0x71>
c0108d51:	8b 45 f0             	mov    -0x10(%ebp),%eax
c0108d54:	89 45 e4             	mov    %eax,-0x1c(%ebp)
c0108d57:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108d5a:	89 45 e0             	mov    %eax,-0x20(%ebp)
c0108d5d:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108d60:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108d63:	8b 45 dc             	mov    -0x24(%ebp),%eax
c0108d66:	89 c1                	mov    %eax,%ecx
c0108d68:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108d6b:	8b 55 e4             	mov    -0x1c(%ebp),%edx
c0108d6e:	8b 45 e0             	mov    -0x20(%ebp),%eax
c0108d71:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0108d74:	89 d7                	mov    %edx,%edi
c0108d76:	89 c3                	mov    %eax,%ebx
c0108d78:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0108d7b:	89 de                	mov    %ebx,%esi
c0108d7d:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108d7f:	8b 4d dc             	mov    -0x24(%ebp),%ecx
c0108d82:	83 e1 03             	and    $0x3,%ecx
c0108d85:	74 02                	je     c0108d89 <memmove+0x5b>
c0108d87:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108d89:	89 f3                	mov    %esi,%ebx
c0108d8b:	89 4d c0             	mov    %ecx,-0x40(%ebp)
c0108d8e:	8b 4d c0             	mov    -0x40(%ebp),%ecx
c0108d91:	89 4d d8             	mov    %ecx,-0x28(%ebp)
c0108d94:	89 7d d4             	mov    %edi,-0x2c(%ebp)
c0108d97:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108d9a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
c0108d9d:	eb 3b                	jmp    c0108dda <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
c0108d9f:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108da2:	83 e8 01             	sub    $0x1,%eax
c0108da5:	89 c2                	mov    %eax,%edx
c0108da7:	03 55 ec             	add    -0x14(%ebp),%edx
c0108daa:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108dad:	83 e8 01             	sub    $0x1,%eax
c0108db0:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
c0108db3:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0108db6:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c0108db9:	89 d6                	mov    %edx,%esi
c0108dbb:	89 c3                	mov    %eax,%ebx
c0108dbd:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0108dc0:	89 df                	mov    %ebx,%edi
c0108dc2:	fd                   	std    
c0108dc3:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108dc5:	fc                   	cld    
c0108dc6:	89 fb                	mov    %edi,%ebx
c0108dc8:	89 4d bc             	mov    %ecx,-0x44(%ebp)
c0108dcb:	8b 4d bc             	mov    -0x44(%ebp),%ecx
c0108dce:	89 4d cc             	mov    %ecx,-0x34(%ebp)
c0108dd1:	89 75 c8             	mov    %esi,-0x38(%ebp)
c0108dd4:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
c0108dd7:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
c0108dda:	83 c4 38             	add    $0x38,%esp
c0108ddd:	5b                   	pop    %ebx
c0108dde:	5e                   	pop    %esi
c0108ddf:	5f                   	pop    %edi
c0108de0:	5d                   	pop    %ebp
c0108de1:	c3                   	ret    

c0108de2 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
c0108de2:	55                   	push   %ebp
c0108de3:	89 e5                	mov    %esp,%ebp
c0108de5:	57                   	push   %edi
c0108de6:	56                   	push   %esi
c0108de7:	53                   	push   %ebx
c0108de8:	83 ec 24             	sub    $0x24,%esp
c0108deb:	8b 45 08             	mov    0x8(%ebp),%eax
c0108dee:	89 45 f0             	mov    %eax,-0x10(%ebp)
c0108df1:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108df4:	89 45 ec             	mov    %eax,-0x14(%ebp)
c0108df7:	8b 45 10             	mov    0x10(%ebp),%eax
c0108dfa:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
c0108dfd:	8b 45 e8             	mov    -0x18(%ebp),%eax
c0108e00:	89 c1                	mov    %eax,%ecx
c0108e02:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
c0108e05:	8b 55 f0             	mov    -0x10(%ebp),%edx
c0108e08:	8b 45 ec             	mov    -0x14(%ebp),%eax
c0108e0b:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c0108e0e:	89 d7                	mov    %edx,%edi
c0108e10:	89 c3                	mov    %eax,%ebx
c0108e12:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0108e15:	89 de                	mov    %ebx,%esi
c0108e17:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
c0108e19:	8b 4d e8             	mov    -0x18(%ebp),%ecx
c0108e1c:	83 e1 03             	and    $0x3,%ecx
c0108e1f:	74 02                	je     c0108e23 <memcpy+0x41>
c0108e21:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
c0108e23:	89 f3                	mov    %esi,%ebx
c0108e25:	89 4d d0             	mov    %ecx,-0x30(%ebp)
c0108e28:	8b 4d d0             	mov    -0x30(%ebp),%ecx
c0108e2b:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
c0108e2e:	89 7d e0             	mov    %edi,-0x20(%ebp)
c0108e31:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
c0108e34:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
c0108e37:	83 c4 24             	add    $0x24,%esp
c0108e3a:	5b                   	pop    %ebx
c0108e3b:	5e                   	pop    %esi
c0108e3c:	5f                   	pop    %edi
c0108e3d:	5d                   	pop    %ebp
c0108e3e:	c3                   	ret    

c0108e3f <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
c0108e3f:	55                   	push   %ebp
c0108e40:	89 e5                	mov    %esp,%ebp
c0108e42:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
c0108e45:	8b 45 08             	mov    0x8(%ebp),%eax
c0108e48:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
c0108e4b:	8b 45 0c             	mov    0xc(%ebp),%eax
c0108e4e:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
c0108e51:	eb 32                	jmp    c0108e85 <memcmp+0x46>
        if (*s1 != *s2) {
c0108e53:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108e56:	0f b6 10             	movzbl (%eax),%edx
c0108e59:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108e5c:	0f b6 00             	movzbl (%eax),%eax
c0108e5f:	38 c2                	cmp    %al,%dl
c0108e61:	74 1a                	je     c0108e7d <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
c0108e63:	8b 45 fc             	mov    -0x4(%ebp),%eax
c0108e66:	0f b6 00             	movzbl (%eax),%eax
c0108e69:	0f b6 d0             	movzbl %al,%edx
c0108e6c:	8b 45 f8             	mov    -0x8(%ebp),%eax
c0108e6f:	0f b6 00             	movzbl (%eax),%eax
c0108e72:	0f b6 c0             	movzbl %al,%eax
c0108e75:	89 d1                	mov    %edx,%ecx
c0108e77:	29 c1                	sub    %eax,%ecx
c0108e79:	89 c8                	mov    %ecx,%eax
c0108e7b:	eb 1c                	jmp    c0108e99 <memcmp+0x5a>
        }
        s1 ++, s2 ++;
c0108e7d:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
c0108e81:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
c0108e85:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
c0108e89:	0f 95 c0             	setne  %al
c0108e8c:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
c0108e90:	84 c0                	test   %al,%al
c0108e92:	75 bf                	jne    c0108e53 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
c0108e94:	b8 00 00 00 00       	mov    $0x0,%eax
}
c0108e99:	c9                   	leave  
c0108e9a:	c3                   	ret    
