
obj/__user_yield.out:     file format elf32-i386


Disassembly of section .text:

00800020 <opendir>:
#include <error.h>
#include <unistd.h>

DIR dir, *dirp=&dir;
DIR *
opendir(const char *path) {
  800020:	55                   	push   %ebp
  800021:	89 e5                	mov    %esp,%ebp
  800023:	53                   	push   %ebx
  800024:	83 ec 34             	sub    $0x34,%esp

    if ((dirp->fd = open(path, O_RDONLY)) < 0) {
  800027:	8b 1d 00 20 80 00    	mov    0x802000,%ebx
  80002d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800034:	00 
  800035:	8b 45 08             	mov    0x8(%ebp),%eax
  800038:	89 04 24             	mov    %eax,(%esp)
  80003b:	e8 b8 00 00 00       	call   8000f8 <open>
  800040:	89 03                	mov    %eax,(%ebx)
  800042:	8b 03                	mov    (%ebx),%eax
  800044:	85 c0                	test   %eax,%eax
  800046:	78 44                	js     80008c <opendir+0x6c>
        goto failed;
    }
    struct stat __stat, *stat = &__stat;
  800048:	8d 45 e4             	lea    -0x1c(%ebp),%eax
  80004b:	89 45 f4             	mov    %eax,-0xc(%ebp)
    if (fstat(dirp->fd, stat) != 0 || !S_ISDIR(stat->st_mode)) {
  80004e:	a1 00 20 80 00       	mov    0x802000,%eax
  800053:	8b 00                	mov    (%eax),%eax
  800055:	8b 55 f4             	mov    -0xc(%ebp),%edx
  800058:	89 54 24 04          	mov    %edx,0x4(%esp)
  80005c:	89 04 24             	mov    %eax,(%esp)
  80005f:	e8 24 01 00 00       	call   800188 <fstat>
  800064:	85 c0                	test   %eax,%eax
  800066:	75 25                	jne    80008d <opendir+0x6d>
  800068:	8b 45 f4             	mov    -0xc(%ebp),%eax
  80006b:	8b 00                	mov    (%eax),%eax
  80006d:	25 00 70 00 00       	and    $0x7000,%eax
  800072:	3d 00 20 00 00       	cmp    $0x2000,%eax
  800077:	75 14                	jne    80008d <opendir+0x6d>
        goto failed;
    }
    dirp->dirent.offset = 0;
  800079:	a1 00 20 80 00       	mov    0x802000,%eax
  80007e:	c7 40 04 00 00 00 00 	movl   $0x0,0x4(%eax)
    return dirp;
  800085:	a1 00 20 80 00       	mov    0x802000,%eax
  80008a:	eb 06                	jmp    800092 <opendir+0x72>
DIR dir, *dirp=&dir;
DIR *
opendir(const char *path) {

    if ((dirp->fd = open(path, O_RDONLY)) < 0) {
        goto failed;
  80008c:	90                   	nop
    }
    dirp->dirent.offset = 0;
    return dirp;

failed:
    return NULL;
  80008d:	b8 00 00 00 00       	mov    $0x0,%eax
}
  800092:	83 c4 34             	add    $0x34,%esp
  800095:	5b                   	pop    %ebx
  800096:	5d                   	pop    %ebp
  800097:	c3                   	ret    

00800098 <readdir>:

struct dirent *
readdir(DIR *dirp) {
  800098:	55                   	push   %ebp
  800099:	89 e5                	mov    %esp,%ebp
  80009b:	83 ec 18             	sub    $0x18,%esp
    if (sys_getdirentry(dirp->fd, &(dirp->dirent)) == 0) {
  80009e:	8b 45 08             	mov    0x8(%ebp),%eax
  8000a1:	8d 50 04             	lea    0x4(%eax),%edx
  8000a4:	8b 45 08             	mov    0x8(%ebp),%eax
  8000a7:	8b 00                	mov    (%eax),%eax
  8000a9:	89 54 24 04          	mov    %edx,0x4(%esp)
  8000ad:	89 04 24             	mov    %eax,(%esp)
  8000b0:	e8 f8 06 00 00       	call   8007ad <sys_getdirentry>
  8000b5:	85 c0                	test   %eax,%eax
  8000b7:	75 08                	jne    8000c1 <readdir+0x29>
        return &(dirp->dirent);
  8000b9:	8b 45 08             	mov    0x8(%ebp),%eax
  8000bc:	83 c0 04             	add    $0x4,%eax
  8000bf:	eb 05                	jmp    8000c6 <readdir+0x2e>
    }
    return NULL;
  8000c1:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8000c6:	c9                   	leave  
  8000c7:	c3                   	ret    

008000c8 <closedir>:

void
closedir(DIR *dirp) {
  8000c8:	55                   	push   %ebp
  8000c9:	89 e5                	mov    %esp,%ebp
  8000cb:	83 ec 18             	sub    $0x18,%esp
    close(dirp->fd);
  8000ce:	8b 45 08             	mov    0x8(%ebp),%eax
  8000d1:	8b 00                	mov    (%eax),%eax
  8000d3:	89 04 24             	mov    %eax,(%esp)
  8000d6:	e8 37 00 00 00       	call   800112 <close>
}
  8000db:	c9                   	leave  
  8000dc:	c3                   	ret    

008000dd <getcwd>:

int
getcwd(char *buffer, size_t len) {
  8000dd:	55                   	push   %ebp
  8000de:	89 e5                	mov    %esp,%ebp
  8000e0:	83 ec 18             	sub    $0x18,%esp
    return sys_getcwd(buffer, len);
  8000e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8000e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8000ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8000ed:	89 04 24             	mov    %eax,(%esp)
  8000f0:	e8 96 06 00 00       	call   80078b <sys_getcwd>
}
  8000f5:	c9                   	leave  
  8000f6:	c3                   	ret    
	...

008000f8 <open>:
#include <stat.h>
#include <error.h>
#include <unistd.h>

int
open(const char *path, uint32_t open_flags) {
  8000f8:	55                   	push   %ebp
  8000f9:	89 e5                	mov    %esp,%ebp
  8000fb:	83 ec 18             	sub    $0x18,%esp
    return sys_open(path, open_flags);
  8000fe:	8b 45 0c             	mov    0xc(%ebp),%eax
  800101:	89 44 24 04          	mov    %eax,0x4(%esp)
  800105:	8b 45 08             	mov    0x8(%ebp),%eax
  800108:	89 04 24             	mov    %eax,(%esp)
  80010b:	e8 86 05 00 00       	call   800696 <sys_open>
}
  800110:	c9                   	leave  
  800111:	c3                   	ret    

00800112 <close>:

int
close(int fd) {
  800112:	55                   	push   %ebp
  800113:	89 e5                	mov    %esp,%ebp
  800115:	83 ec 18             	sub    $0x18,%esp
    return sys_close(fd);
  800118:	8b 45 08             	mov    0x8(%ebp),%eax
  80011b:	89 04 24             	mov    %eax,(%esp)
  80011e:	e8 95 05 00 00       	call   8006b8 <sys_close>
}
  800123:	c9                   	leave  
  800124:	c3                   	ret    

00800125 <read>:

int
read(int fd, void *base, size_t len) {
  800125:	55                   	push   %ebp
  800126:	89 e5                	mov    %esp,%ebp
  800128:	83 ec 18             	sub    $0x18,%esp
    return sys_read(fd, base, len);
  80012b:	8b 45 10             	mov    0x10(%ebp),%eax
  80012e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800132:	8b 45 0c             	mov    0xc(%ebp),%eax
  800135:	89 44 24 04          	mov    %eax,0x4(%esp)
  800139:	8b 45 08             	mov    0x8(%ebp),%eax
  80013c:	89 04 24             	mov    %eax,(%esp)
  80013f:	e8 8f 05 00 00       	call   8006d3 <sys_read>
}
  800144:	c9                   	leave  
  800145:	c3                   	ret    

00800146 <write>:

int
write(int fd, void *base, size_t len) {
  800146:	55                   	push   %ebp
  800147:	89 e5                	mov    %esp,%ebp
  800149:	83 ec 18             	sub    $0x18,%esp
    return sys_write(fd, base, len);
  80014c:	8b 45 10             	mov    0x10(%ebp),%eax
  80014f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800153:	8b 45 0c             	mov    0xc(%ebp),%eax
  800156:	89 44 24 04          	mov    %eax,0x4(%esp)
  80015a:	8b 45 08             	mov    0x8(%ebp),%eax
  80015d:	89 04 24             	mov    %eax,(%esp)
  800160:	e8 97 05 00 00       	call   8006fc <sys_write>
}
  800165:	c9                   	leave  
  800166:	c3                   	ret    

00800167 <seek>:

int
seek(int fd, off_t pos, int whence) {
  800167:	55                   	push   %ebp
  800168:	89 e5                	mov    %esp,%ebp
  80016a:	83 ec 18             	sub    $0x18,%esp
    return sys_seek(fd, pos, whence);
  80016d:	8b 45 10             	mov    0x10(%ebp),%eax
  800170:	89 44 24 08          	mov    %eax,0x8(%esp)
  800174:	8b 45 0c             	mov    0xc(%ebp),%eax
  800177:	89 44 24 04          	mov    %eax,0x4(%esp)
  80017b:	8b 45 08             	mov    0x8(%ebp),%eax
  80017e:	89 04 24             	mov    %eax,(%esp)
  800181:	e8 9f 05 00 00       	call   800725 <sys_seek>
}
  800186:	c9                   	leave  
  800187:	c3                   	ret    

00800188 <fstat>:

int
fstat(int fd, struct stat *stat) {
  800188:	55                   	push   %ebp
  800189:	89 e5                	mov    %esp,%ebp
  80018b:	83 ec 18             	sub    $0x18,%esp
    return sys_fstat(fd, stat);
  80018e:	8b 45 0c             	mov    0xc(%ebp),%eax
  800191:	89 44 24 04          	mov    %eax,0x4(%esp)
  800195:	8b 45 08             	mov    0x8(%ebp),%eax
  800198:	89 04 24             	mov    %eax,(%esp)
  80019b:	e8 ae 05 00 00       	call   80074e <sys_fstat>
}
  8001a0:	c9                   	leave  
  8001a1:	c3                   	ret    

008001a2 <fsync>:

int
fsync(int fd) {
  8001a2:	55                   	push   %ebp
  8001a3:	89 e5                	mov    %esp,%ebp
  8001a5:	83 ec 18             	sub    $0x18,%esp
    return sys_fsync(fd);
  8001a8:	8b 45 08             	mov    0x8(%ebp),%eax
  8001ab:	89 04 24             	mov    %eax,(%esp)
  8001ae:	e8 bd 05 00 00       	call   800770 <sys_fsync>
}
  8001b3:	c9                   	leave  
  8001b4:	c3                   	ret    

008001b5 <dup2>:

int
dup2(int fd1, int fd2) {
  8001b5:	55                   	push   %ebp
  8001b6:	89 e5                	mov    %esp,%ebp
  8001b8:	83 ec 18             	sub    $0x18,%esp
    return sys_dup(fd1, fd2);
  8001bb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8001be:	89 44 24 04          	mov    %eax,0x4(%esp)
  8001c2:	8b 45 08             	mov    0x8(%ebp),%eax
  8001c5:	89 04 24             	mov    %eax,(%esp)
  8001c8:	e8 02 06 00 00       	call   8007cf <sys_dup>
}
  8001cd:	c9                   	leave  
  8001ce:	c3                   	ret    

008001cf <transmode>:

static char
transmode(struct stat *stat) {
  8001cf:	55                   	push   %ebp
  8001d0:	89 e5                	mov    %esp,%ebp
  8001d2:	83 ec 10             	sub    $0x10,%esp
    uint32_t mode = stat->st_mode;
  8001d5:	8b 45 08             	mov    0x8(%ebp),%eax
  8001d8:	8b 00                	mov    (%eax),%eax
  8001da:	89 45 fc             	mov    %eax,-0x4(%ebp)
    if (S_ISREG(mode)) return 'r';
  8001dd:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8001e0:	25 00 70 00 00       	and    $0x7000,%eax
  8001e5:	3d 00 10 00 00       	cmp    $0x1000,%eax
  8001ea:	75 07                	jne    8001f3 <transmode+0x24>
  8001ec:	b8 72 00 00 00       	mov    $0x72,%eax
  8001f1:	eb 5d                	jmp    800250 <transmode+0x81>
    if (S_ISDIR(mode)) return 'd';
  8001f3:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8001f6:	25 00 70 00 00       	and    $0x7000,%eax
  8001fb:	3d 00 20 00 00       	cmp    $0x2000,%eax
  800200:	75 07                	jne    800209 <transmode+0x3a>
  800202:	b8 64 00 00 00       	mov    $0x64,%eax
  800207:	eb 47                	jmp    800250 <transmode+0x81>
    if (S_ISLNK(mode)) return 'l';
  800209:	8b 45 fc             	mov    -0x4(%ebp),%eax
  80020c:	25 00 70 00 00       	and    $0x7000,%eax
  800211:	3d 00 30 00 00       	cmp    $0x3000,%eax
  800216:	75 07                	jne    80021f <transmode+0x50>
  800218:	b8 6c 00 00 00       	mov    $0x6c,%eax
  80021d:	eb 31                	jmp    800250 <transmode+0x81>
    if (S_ISCHR(mode)) return 'c';
  80021f:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800222:	25 00 70 00 00       	and    $0x7000,%eax
  800227:	3d 00 40 00 00       	cmp    $0x4000,%eax
  80022c:	75 07                	jne    800235 <transmode+0x66>
  80022e:	b8 63 00 00 00       	mov    $0x63,%eax
  800233:	eb 1b                	jmp    800250 <transmode+0x81>
    if (S_ISBLK(mode)) return 'b';
  800235:	8b 45 fc             	mov    -0x4(%ebp),%eax
  800238:	25 00 70 00 00       	and    $0x7000,%eax
  80023d:	3d 00 50 00 00       	cmp    $0x5000,%eax
  800242:	75 07                	jne    80024b <transmode+0x7c>
  800244:	b8 62 00 00 00       	mov    $0x62,%eax
  800249:	eb 05                	jmp    800250 <transmode+0x81>
    return '-';
  80024b:	b8 2d 00 00 00       	mov    $0x2d,%eax
}
  800250:	c9                   	leave  
  800251:	c3                   	ret    

00800252 <print_stat>:

void
print_stat(const char *name, int fd, struct stat *stat) {
  800252:	55                   	push   %ebp
  800253:	89 e5                	mov    %esp,%ebp
  800255:	83 ec 18             	sub    $0x18,%esp
    cprintf("[%03d] %s\n", fd, name);
  800258:	8b 45 08             	mov    0x8(%ebp),%eax
  80025b:	89 44 24 08          	mov    %eax,0x8(%esp)
  80025f:	8b 45 0c             	mov    0xc(%ebp),%eax
  800262:	89 44 24 04          	mov    %eax,0x4(%esp)
  800266:	c7 04 24 40 19 80 00 	movl   $0x801940,(%esp)
  80026d:	e8 72 01 00 00       	call   8003e4 <cprintf>
    cprintf("    mode    : %c\n", transmode(stat));
  800272:	8b 45 10             	mov    0x10(%ebp),%eax
  800275:	89 04 24             	mov    %eax,(%esp)
  800278:	e8 52 ff ff ff       	call   8001cf <transmode>
  80027d:	0f be c0             	movsbl %al,%eax
  800280:	89 44 24 04          	mov    %eax,0x4(%esp)
  800284:	c7 04 24 4b 19 80 00 	movl   $0x80194b,(%esp)
  80028b:	e8 54 01 00 00       	call   8003e4 <cprintf>
    cprintf("    links   : %lu\n", stat->st_nlinks);
  800290:	8b 45 10             	mov    0x10(%ebp),%eax
  800293:	8b 40 04             	mov    0x4(%eax),%eax
  800296:	89 44 24 04          	mov    %eax,0x4(%esp)
  80029a:	c7 04 24 5d 19 80 00 	movl   $0x80195d,(%esp)
  8002a1:	e8 3e 01 00 00       	call   8003e4 <cprintf>
    cprintf("    blocks  : %lu\n", stat->st_blocks);
  8002a6:	8b 45 10             	mov    0x10(%ebp),%eax
  8002a9:	8b 40 08             	mov    0x8(%eax),%eax
  8002ac:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002b0:	c7 04 24 70 19 80 00 	movl   $0x801970,(%esp)
  8002b7:	e8 28 01 00 00       	call   8003e4 <cprintf>
    cprintf("    size    : %lu\n", stat->st_size);
  8002bc:	8b 45 10             	mov    0x10(%ebp),%eax
  8002bf:	8b 40 0c             	mov    0xc(%eax),%eax
  8002c2:	89 44 24 04          	mov    %eax,0x4(%esp)
  8002c6:	c7 04 24 83 19 80 00 	movl   $0x801983,(%esp)
  8002cd:	e8 12 01 00 00       	call   8003e4 <cprintf>
}
  8002d2:	c9                   	leave  
  8002d3:	c3                   	ret    

008002d4 <_start>:
.text
.globl _start
_start:
    # set ebp for backtrace
    movl $0x0, %ebp
  8002d4:	bd 00 00 00 00       	mov    $0x0,%ebp

    # load argc and argv
    movl (%esp), %ebx
  8002d9:	8b 1c 24             	mov    (%esp),%ebx
    lea 0x4(%esp), %ecx
  8002dc:	8d 4c 24 04          	lea    0x4(%esp),%ecx


    # move down the esp register
    # since it may cause page fault in backtrace
    subl $0x20, %esp
  8002e0:	83 ec 20             	sub    $0x20,%esp

    # save argc and argv on stack
    pushl %ecx
  8002e3:	51                   	push   %ecx
    pushl %ebx
  8002e4:	53                   	push   %ebx

    # call user-program function
    call umain
  8002e5:	e8 6c 07 00 00       	call   800a56 <umain>
1:  jmp 1b
  8002ea:	eb fe                	jmp    8002ea <_start+0x16>

008002ec <__panic>:
#include <stdio.h>
#include <ulib.h>
#include <error.h>

void
__panic(const char *file, int line, const char *fmt, ...) {
  8002ec:	55                   	push   %ebp
  8002ed:	89 e5                	mov    %esp,%ebp
  8002ef:	83 ec 28             	sub    $0x28,%esp
    // print the 'message'
    va_list ap;
    va_start(ap, fmt);
  8002f2:	8d 55 14             	lea    0x14(%ebp),%edx
  8002f5:	8d 45 f4             	lea    -0xc(%ebp),%eax
  8002f8:	89 10                	mov    %edx,(%eax)
    cprintf("user panic at %s:%d:\n    ", file, line);
  8002fa:	8b 45 0c             	mov    0xc(%ebp),%eax
  8002fd:	89 44 24 08          	mov    %eax,0x8(%esp)
  800301:	8b 45 08             	mov    0x8(%ebp),%eax
  800304:	89 44 24 04          	mov    %eax,0x4(%esp)
  800308:	c7 04 24 96 19 80 00 	movl   $0x801996,(%esp)
  80030f:	e8 d0 00 00 00       	call   8003e4 <cprintf>
    vcprintf(fmt, ap);
  800314:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800317:	89 44 24 04          	mov    %eax,0x4(%esp)
  80031b:	8b 45 10             	mov    0x10(%ebp),%eax
  80031e:	89 04 24             	mov    %eax,(%esp)
  800321:	e8 82 00 00 00       	call   8003a8 <vcprintf>
    cprintf("\n");
  800326:	c7 04 24 b0 19 80 00 	movl   $0x8019b0,(%esp)
  80032d:	e8 b2 00 00 00       	call   8003e4 <cprintf>
    va_end(ap);
    exit(-E_PANIC);
  800332:	c7 04 24 f6 ff ff ff 	movl   $0xfffffff6,(%esp)
  800339:	e8 ad 05 00 00       	call   8008eb <exit>

0080033e <__warn>:
}

void
__warn(const char *file, int line, const char *fmt, ...) {
  80033e:	55                   	push   %ebp
  80033f:	89 e5                	mov    %esp,%ebp
  800341:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    va_start(ap, fmt);
  800344:	8d 55 14             	lea    0x14(%ebp),%edx
  800347:	8d 45 f4             	lea    -0xc(%ebp),%eax
  80034a:	89 10                	mov    %edx,(%eax)
    cprintf("user warning at %s:%d:\n    ", file, line);
  80034c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80034f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800353:	8b 45 08             	mov    0x8(%ebp),%eax
  800356:	89 44 24 04          	mov    %eax,0x4(%esp)
  80035a:	c7 04 24 b2 19 80 00 	movl   $0x8019b2,(%esp)
  800361:	e8 7e 00 00 00       	call   8003e4 <cprintf>
    vcprintf(fmt, ap);
  800366:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800369:	89 44 24 04          	mov    %eax,0x4(%esp)
  80036d:	8b 45 10             	mov    0x10(%ebp),%eax
  800370:	89 04 24             	mov    %eax,(%esp)
  800373:	e8 30 00 00 00       	call   8003a8 <vcprintf>
    cprintf("\n");
  800378:	c7 04 24 b0 19 80 00 	movl   $0x8019b0,(%esp)
  80037f:	e8 60 00 00 00       	call   8003e4 <cprintf>
    va_end(ap);
}
  800384:	c9                   	leave  
  800385:	c3                   	ret    
	...

00800388 <cputch>:
/* *
 * cputch - writes a single character @c to stdout, and it will
 * increace the value of counter pointed by @cnt.
 * */
static void
cputch(int c, int *cnt) {
  800388:	55                   	push   %ebp
  800389:	89 e5                	mov    %esp,%ebp
  80038b:	83 ec 18             	sub    $0x18,%esp
    sys_putc(c);
  80038e:	8b 45 08             	mov    0x8(%ebp),%eax
  800391:	89 04 24             	mov    %eax,(%esp)
  800394:	e8 5b 02 00 00       	call   8005f4 <sys_putc>
    (*cnt) ++;
  800399:	8b 45 0c             	mov    0xc(%ebp),%eax
  80039c:	8b 00                	mov    (%eax),%eax
  80039e:	8d 50 01             	lea    0x1(%eax),%edx
  8003a1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8003a4:	89 10                	mov    %edx,(%eax)
}
  8003a6:	c9                   	leave  
  8003a7:	c3                   	ret    

008003a8 <vcprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want cprintf() instead.
 * */
int
vcprintf(const char *fmt, va_list ap) {
  8003a8:	55                   	push   %ebp
  8003a9:	89 e5                	mov    %esp,%ebp
  8003ab:	83 ec 38             	sub    $0x38,%esp
    int cnt = 0;
  8003ae:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)cputch, NO_FD, &cnt, fmt, ap);
  8003b5:	b8 88 03 80 00       	mov    $0x800388,%eax
  8003ba:	8b 55 0c             	mov    0xc(%ebp),%edx
  8003bd:	89 54 24 10          	mov    %edx,0x10(%esp)
  8003c1:	8b 55 08             	mov    0x8(%ebp),%edx
  8003c4:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8003c8:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8003cb:	89 54 24 08          	mov    %edx,0x8(%esp)
  8003cf:	c7 44 24 04 d9 6a ff 	movl   $0xffff6ad9,0x4(%esp)
  8003d6:	ff 
  8003d7:	89 04 24             	mov    %eax,(%esp)
  8003da:	e8 7b 09 00 00       	call   800d5a <vprintfmt>
    return cnt;
  8003df:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8003e2:	c9                   	leave  
  8003e3:	c3                   	ret    

008003e4 <cprintf>:
 *
 * The return value is the number of characters which would be
 * written to stdout.
 * */
int
cprintf(const char *fmt, ...) {
  8003e4:	55                   	push   %ebp
  8003e5:	89 e5                	mov    %esp,%ebp
  8003e7:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  8003ea:	8d 55 0c             	lea    0xc(%ebp),%edx
  8003ed:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8003f0:	89 10                	mov    %edx,(%eax)
    int cnt = vcprintf(fmt, ap);
  8003f2:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8003f5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8003f9:	8b 45 08             	mov    0x8(%ebp),%eax
  8003fc:	89 04 24             	mov    %eax,(%esp)
  8003ff:	e8 a4 ff ff ff       	call   8003a8 <vcprintf>
  800404:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);

    return cnt;
  800407:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80040a:	c9                   	leave  
  80040b:	c3                   	ret    

0080040c <cputs>:
/* *
 * cputs- writes the string pointed by @str to stdout and
 * appends a newline character.
 * */
int
cputs(const char *str) {
  80040c:	55                   	push   %ebp
  80040d:	89 e5                	mov    %esp,%ebp
  80040f:	83 ec 28             	sub    $0x28,%esp
    int cnt = 0;
  800412:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
    char c;
    while ((c = *str ++) != '\0') {
  800419:	eb 13                	jmp    80042e <cputs+0x22>
        cputch(c, &cnt);
  80041b:	0f be 45 f7          	movsbl -0x9(%ebp),%eax
  80041f:	8d 55 f0             	lea    -0x10(%ebp),%edx
  800422:	89 54 24 04          	mov    %edx,0x4(%esp)
  800426:	89 04 24             	mov    %eax,(%esp)
  800429:	e8 5a ff ff ff       	call   800388 <cputch>
 * */
int
cputs(const char *str) {
    int cnt = 0;
    char c;
    while ((c = *str ++) != '\0') {
  80042e:	8b 45 08             	mov    0x8(%ebp),%eax
  800431:	0f b6 00             	movzbl (%eax),%eax
  800434:	88 45 f7             	mov    %al,-0x9(%ebp)
  800437:	80 7d f7 00          	cmpb   $0x0,-0x9(%ebp)
  80043b:	0f 95 c0             	setne  %al
  80043e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  800442:	84 c0                	test   %al,%al
  800444:	75 d5                	jne    80041b <cputs+0xf>
        cputch(c, &cnt);
    }
    cputch('\n', &cnt);
  800446:	8d 45 f0             	lea    -0x10(%ebp),%eax
  800449:	89 44 24 04          	mov    %eax,0x4(%esp)
  80044d:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800454:	e8 2f ff ff ff       	call   800388 <cputch>
    return cnt;
  800459:	8b 45 f0             	mov    -0x10(%ebp),%eax
}
  80045c:	c9                   	leave  
  80045d:	c3                   	ret    

0080045e <fputch>:


static void
fputch(char c, int *cnt, int fd) {
  80045e:	55                   	push   %ebp
  80045f:	89 e5                	mov    %esp,%ebp
  800461:	83 ec 28             	sub    $0x28,%esp
  800464:	8b 45 08             	mov    0x8(%ebp),%eax
  800467:	88 45 f4             	mov    %al,-0xc(%ebp)
    write(fd, &c, sizeof(char));
  80046a:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800471:	00 
  800472:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800475:	89 44 24 04          	mov    %eax,0x4(%esp)
  800479:	8b 45 10             	mov    0x10(%ebp),%eax
  80047c:	89 04 24             	mov    %eax,(%esp)
  80047f:	e8 c2 fc ff ff       	call   800146 <write>
    (*cnt) ++;
  800484:	8b 45 0c             	mov    0xc(%ebp),%eax
  800487:	8b 00                	mov    (%eax),%eax
  800489:	8d 50 01             	lea    0x1(%eax),%edx
  80048c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80048f:	89 10                	mov    %edx,(%eax)
}
  800491:	c9                   	leave  
  800492:	c3                   	ret    

00800493 <vfprintf>:

int
vfprintf(int fd, const char *fmt, va_list ap) {
  800493:	55                   	push   %ebp
  800494:	89 e5                	mov    %esp,%ebp
  800496:	83 ec 38             	sub    $0x38,%esp
    int cnt = 0;
  800499:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    vprintfmt((void*)fputch, fd, &cnt, fmt, ap);
  8004a0:	b8 5e 04 80 00       	mov    $0x80045e,%eax
  8004a5:	8b 55 10             	mov    0x10(%ebp),%edx
  8004a8:	89 54 24 10          	mov    %edx,0x10(%esp)
  8004ac:	8b 55 0c             	mov    0xc(%ebp),%edx
  8004af:	89 54 24 0c          	mov    %edx,0xc(%esp)
  8004b3:	8d 55 f4             	lea    -0xc(%ebp),%edx
  8004b6:	89 54 24 08          	mov    %edx,0x8(%esp)
  8004ba:	8b 55 08             	mov    0x8(%ebp),%edx
  8004bd:	89 54 24 04          	mov    %edx,0x4(%esp)
  8004c1:	89 04 24             	mov    %eax,(%esp)
  8004c4:	e8 91 08 00 00       	call   800d5a <vprintfmt>
    return cnt;
  8004c9:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8004cc:	c9                   	leave  
  8004cd:	c3                   	ret    

008004ce <fprintf>:

int
fprintf(int fd, const char *fmt, ...) {
  8004ce:	55                   	push   %ebp
  8004cf:	89 e5                	mov    %esp,%ebp
  8004d1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;

    va_start(ap, fmt);
  8004d4:	8d 55 10             	lea    0x10(%ebp),%edx
  8004d7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8004da:	89 10                	mov    %edx,(%eax)
    int cnt = vfprintf(fd, fmt, ap);
  8004dc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8004df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8004e3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8004e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8004ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8004ed:	89 04 24             	mov    %eax,(%esp)
  8004f0:	e8 9e ff ff ff       	call   800493 <vfprintf>
  8004f5:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);

    return cnt;
  8004f8:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  8004fb:	c9                   	leave  
  8004fc:	c3                   	ret    
  8004fd:	00 00                	add    %al,(%eax)
	...

00800500 <syscall>:


#define MAX_ARGS            5

static inline int
syscall(int num, ...) {
  800500:	55                   	push   %ebp
  800501:	89 e5                	mov    %esp,%ebp
  800503:	57                   	push   %edi
  800504:	56                   	push   %esi
  800505:	53                   	push   %ebx
  800506:	83 ec 24             	sub    $0x24,%esp
    va_list ap;
    va_start(ap, num);
  800509:	8d 55 0c             	lea    0xc(%ebp),%edx
  80050c:	8d 45 e8             	lea    -0x18(%ebp),%eax
  80050f:	89 10                	mov    %edx,(%eax)
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  800511:	c7 45 f0 00 00 00 00 	movl   $0x0,-0x10(%ebp)
  800518:	eb 16                	jmp    800530 <syscall+0x30>
        a[i] = va_arg(ap, uint32_t);
  80051a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80051d:	8d 50 04             	lea    0x4(%eax),%edx
  800520:	89 55 e8             	mov    %edx,-0x18(%ebp)
  800523:	8b 10                	mov    (%eax),%edx
  800525:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800528:	89 54 85 d4          	mov    %edx,-0x2c(%ebp,%eax,4)
syscall(int num, ...) {
    va_list ap;
    va_start(ap, num);
    uint32_t a[MAX_ARGS];
    int i, ret;
    for (i = 0; i < MAX_ARGS; i ++) {
  80052c:	83 45 f0 01          	addl   $0x1,-0x10(%ebp)
  800530:	83 7d f0 04          	cmpl   $0x4,-0x10(%ebp)
  800534:	7e e4                	jle    80051a <syscall+0x1a>
    asm volatile (
        "int %1;"
        : "=a" (ret)
        : "i" (T_SYSCALL),
          "a" (num),
          "d" (a[0]),
  800536:	8b 55 d4             	mov    -0x2c(%ebp),%edx
          "c" (a[1]),
  800539:	8b 4d d8             	mov    -0x28(%ebp),%ecx
          "b" (a[2]),
  80053c:	8b 5d dc             	mov    -0x24(%ebp),%ebx
          "D" (a[3]),
  80053f:	8b 7d e0             	mov    -0x20(%ebp),%edi
          "S" (a[4])
  800542:	8b 75 e4             	mov    -0x1c(%ebp),%esi
    for (i = 0; i < MAX_ARGS; i ++) {
        a[i] = va_arg(ap, uint32_t);
    }
    va_end(ap);

    asm volatile (
  800545:	8b 45 08             	mov    0x8(%ebp),%eax
  800548:	89 45 d0             	mov    %eax,-0x30(%ebp)
  80054b:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80054e:	cd 80                	int    $0x80
  800550:	89 c3                	mov    %eax,%ebx
  800552:	89 5d ec             	mov    %ebx,-0x14(%ebp)
          "c" (a[1]),
          "b" (a[2]),
          "D" (a[3]),
          "S" (a[4])
        : "cc", "memory");
    return ret;
  800555:	8b 45 ec             	mov    -0x14(%ebp),%eax
}
  800558:	83 c4 24             	add    $0x24,%esp
  80055b:	5b                   	pop    %ebx
  80055c:	5e                   	pop    %esi
  80055d:	5f                   	pop    %edi
  80055e:	5d                   	pop    %ebp
  80055f:	c3                   	ret    

00800560 <sys_exit>:

int
sys_exit(int error_code) {
  800560:	55                   	push   %ebp
  800561:	89 e5                	mov    %esp,%ebp
  800563:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_exit, error_code);
  800566:	8b 45 08             	mov    0x8(%ebp),%eax
  800569:	89 44 24 04          	mov    %eax,0x4(%esp)
  80056d:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800574:	e8 87 ff ff ff       	call   800500 <syscall>
}
  800579:	c9                   	leave  
  80057a:	c3                   	ret    

0080057b <sys_fork>:

int
sys_fork(void) {
  80057b:	55                   	push   %ebp
  80057c:	89 e5                	mov    %esp,%ebp
  80057e:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_fork);
  800581:	c7 04 24 02 00 00 00 	movl   $0x2,(%esp)
  800588:	e8 73 ff ff ff       	call   800500 <syscall>
}
  80058d:	c9                   	leave  
  80058e:	c3                   	ret    

0080058f <sys_wait>:

int
sys_wait(int pid, int *store) {
  80058f:	55                   	push   %ebp
  800590:	89 e5                	mov    %esp,%ebp
  800592:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_wait, pid, store);
  800595:	8b 45 0c             	mov    0xc(%ebp),%eax
  800598:	89 44 24 08          	mov    %eax,0x8(%esp)
  80059c:	8b 45 08             	mov    0x8(%ebp),%eax
  80059f:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005a3:	c7 04 24 03 00 00 00 	movl   $0x3,(%esp)
  8005aa:	e8 51 ff ff ff       	call   800500 <syscall>
}
  8005af:	c9                   	leave  
  8005b0:	c3                   	ret    

008005b1 <sys_yield>:

int
sys_yield(void) {
  8005b1:	55                   	push   %ebp
  8005b2:	89 e5                	mov    %esp,%ebp
  8005b4:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_yield);
  8005b7:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  8005be:	e8 3d ff ff ff       	call   800500 <syscall>
}
  8005c3:	c9                   	leave  
  8005c4:	c3                   	ret    

008005c5 <sys_kill>:

int
sys_kill(int pid) {
  8005c5:	55                   	push   %ebp
  8005c6:	89 e5                	mov    %esp,%ebp
  8005c8:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_kill, pid);
  8005cb:	8b 45 08             	mov    0x8(%ebp),%eax
  8005ce:	89 44 24 04          	mov    %eax,0x4(%esp)
  8005d2:	c7 04 24 0c 00 00 00 	movl   $0xc,(%esp)
  8005d9:	e8 22 ff ff ff       	call   800500 <syscall>
}
  8005de:	c9                   	leave  
  8005df:	c3                   	ret    

008005e0 <sys_getpid>:

int
sys_getpid(void) {
  8005e0:	55                   	push   %ebp
  8005e1:	89 e5                	mov    %esp,%ebp
  8005e3:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_getpid);
  8005e6:	c7 04 24 12 00 00 00 	movl   $0x12,(%esp)
  8005ed:	e8 0e ff ff ff       	call   800500 <syscall>
}
  8005f2:	c9                   	leave  
  8005f3:	c3                   	ret    

008005f4 <sys_putc>:

int
sys_putc(int c) {
  8005f4:	55                   	push   %ebp
  8005f5:	89 e5                	mov    %esp,%ebp
  8005f7:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_putc, c);
  8005fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8005fd:	89 44 24 04          	mov    %eax,0x4(%esp)
  800601:	c7 04 24 1e 00 00 00 	movl   $0x1e,(%esp)
  800608:	e8 f3 fe ff ff       	call   800500 <syscall>
}
  80060d:	c9                   	leave  
  80060e:	c3                   	ret    

0080060f <sys_pgdir>:

int
sys_pgdir(void) {
  80060f:	55                   	push   %ebp
  800610:	89 e5                	mov    %esp,%ebp
  800612:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_pgdir);
  800615:	c7 04 24 1f 00 00 00 	movl   $0x1f,(%esp)
  80061c:	e8 df fe ff ff       	call   800500 <syscall>
}
  800621:	c9                   	leave  
  800622:	c3                   	ret    

00800623 <sys_lab6_set_priority>:

void
sys_lab6_set_priority(uint32_t priority)
{
  800623:	55                   	push   %ebp
  800624:	89 e5                	mov    %esp,%ebp
  800626:	83 ec 08             	sub    $0x8,%esp
    syscall(SYS_lab6_set_priority, priority);
  800629:	8b 45 08             	mov    0x8(%ebp),%eax
  80062c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800630:	c7 04 24 ff 00 00 00 	movl   $0xff,(%esp)
  800637:	e8 c4 fe ff ff       	call   800500 <syscall>
}
  80063c:	c9                   	leave  
  80063d:	c3                   	ret    

0080063e <sys_sleep>:

int
sys_sleep(unsigned int time) {
  80063e:	55                   	push   %ebp
  80063f:	89 e5                	mov    %esp,%ebp
  800641:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_sleep, time);
  800644:	8b 45 08             	mov    0x8(%ebp),%eax
  800647:	89 44 24 04          	mov    %eax,0x4(%esp)
  80064b:	c7 04 24 0b 00 00 00 	movl   $0xb,(%esp)
  800652:	e8 a9 fe ff ff       	call   800500 <syscall>
}
  800657:	c9                   	leave  
  800658:	c3                   	ret    

00800659 <sys_gettime>:

int
sys_gettime(void) {
  800659:	55                   	push   %ebp
  80065a:	89 e5                	mov    %esp,%ebp
  80065c:	83 ec 04             	sub    $0x4,%esp
    return syscall(SYS_gettime);
  80065f:	c7 04 24 11 00 00 00 	movl   $0x11,(%esp)
  800666:	e8 95 fe ff ff       	call   800500 <syscall>
}
  80066b:	c9                   	leave  
  80066c:	c3                   	ret    

0080066d <sys_exec>:

int
sys_exec(const char *name, int argc, const char **argv) {
  80066d:	55                   	push   %ebp
  80066e:	89 e5                	mov    %esp,%ebp
  800670:	83 ec 10             	sub    $0x10,%esp
    return syscall(SYS_exec, name, argc, argv);
  800673:	8b 45 10             	mov    0x10(%ebp),%eax
  800676:	89 44 24 0c          	mov    %eax,0xc(%esp)
  80067a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80067d:	89 44 24 08          	mov    %eax,0x8(%esp)
  800681:	8b 45 08             	mov    0x8(%ebp),%eax
  800684:	89 44 24 04          	mov    %eax,0x4(%esp)
  800688:	c7 04 24 04 00 00 00 	movl   $0x4,(%esp)
  80068f:	e8 6c fe ff ff       	call   800500 <syscall>
}
  800694:	c9                   	leave  
  800695:	c3                   	ret    

00800696 <sys_open>:

int
sys_open(const char *path, uint32_t open_flags) {
  800696:	55                   	push   %ebp
  800697:	89 e5                	mov    %esp,%ebp
  800699:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_open, path, open_flags);
  80069c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80069f:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006a3:	8b 45 08             	mov    0x8(%ebp),%eax
  8006a6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006aa:	c7 04 24 64 00 00 00 	movl   $0x64,(%esp)
  8006b1:	e8 4a fe ff ff       	call   800500 <syscall>
}
  8006b6:	c9                   	leave  
  8006b7:	c3                   	ret    

008006b8 <sys_close>:

int
sys_close(int fd) {
  8006b8:	55                   	push   %ebp
  8006b9:	89 e5                	mov    %esp,%ebp
  8006bb:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_close, fd);
  8006be:	8b 45 08             	mov    0x8(%ebp),%eax
  8006c1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006c5:	c7 04 24 65 00 00 00 	movl   $0x65,(%esp)
  8006cc:	e8 2f fe ff ff       	call   800500 <syscall>
}
  8006d1:	c9                   	leave  
  8006d2:	c3                   	ret    

008006d3 <sys_read>:

int
sys_read(int fd, void *base, size_t len) {
  8006d3:	55                   	push   %ebp
  8006d4:	89 e5                	mov    %esp,%ebp
  8006d6:	83 ec 10             	sub    $0x10,%esp
    return syscall(SYS_read, fd, base, len);
  8006d9:	8b 45 10             	mov    0x10(%ebp),%eax
  8006dc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  8006e0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8006e3:	89 44 24 08          	mov    %eax,0x8(%esp)
  8006e7:	8b 45 08             	mov    0x8(%ebp),%eax
  8006ea:	89 44 24 04          	mov    %eax,0x4(%esp)
  8006ee:	c7 04 24 66 00 00 00 	movl   $0x66,(%esp)
  8006f5:	e8 06 fe ff ff       	call   800500 <syscall>
}
  8006fa:	c9                   	leave  
  8006fb:	c3                   	ret    

008006fc <sys_write>:

int
sys_write(int fd, void *base, size_t len) {
  8006fc:	55                   	push   %ebp
  8006fd:	89 e5                	mov    %esp,%ebp
  8006ff:	83 ec 10             	sub    $0x10,%esp
    return syscall(SYS_write, fd, base, len);
  800702:	8b 45 10             	mov    0x10(%ebp),%eax
  800705:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800709:	8b 45 0c             	mov    0xc(%ebp),%eax
  80070c:	89 44 24 08          	mov    %eax,0x8(%esp)
  800710:	8b 45 08             	mov    0x8(%ebp),%eax
  800713:	89 44 24 04          	mov    %eax,0x4(%esp)
  800717:	c7 04 24 67 00 00 00 	movl   $0x67,(%esp)
  80071e:	e8 dd fd ff ff       	call   800500 <syscall>
}
  800723:	c9                   	leave  
  800724:	c3                   	ret    

00800725 <sys_seek>:

int
sys_seek(int fd, off_t pos, int whence) {
  800725:	55                   	push   %ebp
  800726:	89 e5                	mov    %esp,%ebp
  800728:	83 ec 10             	sub    $0x10,%esp
    return syscall(SYS_seek, fd, pos, whence);
  80072b:	8b 45 10             	mov    0x10(%ebp),%eax
  80072e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800732:	8b 45 0c             	mov    0xc(%ebp),%eax
  800735:	89 44 24 08          	mov    %eax,0x8(%esp)
  800739:	8b 45 08             	mov    0x8(%ebp),%eax
  80073c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800740:	c7 04 24 68 00 00 00 	movl   $0x68,(%esp)
  800747:	e8 b4 fd ff ff       	call   800500 <syscall>
}
  80074c:	c9                   	leave  
  80074d:	c3                   	ret    

0080074e <sys_fstat>:

int
sys_fstat(int fd, struct stat *stat) {
  80074e:	55                   	push   %ebp
  80074f:	89 e5                	mov    %esp,%ebp
  800751:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_fstat, fd, stat);
  800754:	8b 45 0c             	mov    0xc(%ebp),%eax
  800757:	89 44 24 08          	mov    %eax,0x8(%esp)
  80075b:	8b 45 08             	mov    0x8(%ebp),%eax
  80075e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800762:	c7 04 24 6e 00 00 00 	movl   $0x6e,(%esp)
  800769:	e8 92 fd ff ff       	call   800500 <syscall>
}
  80076e:	c9                   	leave  
  80076f:	c3                   	ret    

00800770 <sys_fsync>:

int
sys_fsync(int fd) {
  800770:	55                   	push   %ebp
  800771:	89 e5                	mov    %esp,%ebp
  800773:	83 ec 08             	sub    $0x8,%esp
    return syscall(SYS_fsync, fd);
  800776:	8b 45 08             	mov    0x8(%ebp),%eax
  800779:	89 44 24 04          	mov    %eax,0x4(%esp)
  80077d:	c7 04 24 6f 00 00 00 	movl   $0x6f,(%esp)
  800784:	e8 77 fd ff ff       	call   800500 <syscall>
}
  800789:	c9                   	leave  
  80078a:	c3                   	ret    

0080078b <sys_getcwd>:

int
sys_getcwd(char *buffer, size_t len) {
  80078b:	55                   	push   %ebp
  80078c:	89 e5                	mov    %esp,%ebp
  80078e:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_getcwd, buffer, len);
  800791:	8b 45 0c             	mov    0xc(%ebp),%eax
  800794:	89 44 24 08          	mov    %eax,0x8(%esp)
  800798:	8b 45 08             	mov    0x8(%ebp),%eax
  80079b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80079f:	c7 04 24 79 00 00 00 	movl   $0x79,(%esp)
  8007a6:	e8 55 fd ff ff       	call   800500 <syscall>
}
  8007ab:	c9                   	leave  
  8007ac:	c3                   	ret    

008007ad <sys_getdirentry>:

int
sys_getdirentry(int fd, struct dirent *dirent) {
  8007ad:	55                   	push   %ebp
  8007ae:	89 e5                	mov    %esp,%ebp
  8007b0:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_getdirentry, fd, dirent);
  8007b3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007b6:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007ba:	8b 45 08             	mov    0x8(%ebp),%eax
  8007bd:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007c1:	c7 04 24 80 00 00 00 	movl   $0x80,(%esp)
  8007c8:	e8 33 fd ff ff       	call   800500 <syscall>
}
  8007cd:	c9                   	leave  
  8007ce:	c3                   	ret    

008007cf <sys_dup>:

int
sys_dup(int fd1, int fd2) {
  8007cf:	55                   	push   %ebp
  8007d0:	89 e5                	mov    %esp,%ebp
  8007d2:	83 ec 0c             	sub    $0xc,%esp
    return syscall(SYS_dup, fd1, fd2);
  8007d5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8007d8:	89 44 24 08          	mov    %eax,0x8(%esp)
  8007dc:	8b 45 08             	mov    0x8(%ebp),%eax
  8007df:	89 44 24 04          	mov    %eax,0x4(%esp)
  8007e3:	c7 04 24 82 00 00 00 	movl   $0x82,(%esp)
  8007ea:	e8 11 fd ff ff       	call   800500 <syscall>
}
  8007ef:	c9                   	leave  
  8007f0:	c3                   	ret    
  8007f1:	00 00                	add    %al,(%eax)
	...

008007f4 <test_and_set_bit>:
 * test_and_set_bit - Atomically set a bit and return its old value
 * @nr:     the bit to set
 * @addr:   the address to count from
 * */
static inline bool
test_and_set_bit(int nr, volatile void *addr) {
  8007f4:	55                   	push   %ebp
  8007f5:	89 e5                	mov    %esp,%ebp
  8007f7:	53                   	push   %ebx
  8007f8:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btsl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
  8007fb:	8b 55 0c             	mov    0xc(%ebp),%edx
  8007fe:	8b 45 08             	mov    0x8(%ebp),%eax
  800801:	0f ab 02             	bts    %eax,(%edx)
  800804:	19 db                	sbb    %ebx,%ebx
  800806:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return oldbit != 0;
  800809:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  80080d:	0f 95 c0             	setne  %al
  800810:	0f b6 c0             	movzbl %al,%eax
}
  800813:	83 c4 10             	add    $0x10,%esp
  800816:	5b                   	pop    %ebx
  800817:	5d                   	pop    %ebp
  800818:	c3                   	ret    

00800819 <test_and_clear_bit>:
 * test_and_clear_bit - Atomically clear a bit and return its old value
 * @nr:     the bit to clear
 * @addr:   the address to count from
 * */
static inline bool
test_and_clear_bit(int nr, volatile void *addr) {
  800819:	55                   	push   %ebp
  80081a:	89 e5                	mov    %esp,%ebp
  80081c:	53                   	push   %ebx
  80081d:	83 ec 10             	sub    $0x10,%esp
    int oldbit;
    asm volatile ("btrl %2, %1; sbbl %0, %0" : "=r" (oldbit), "=m" (*(volatile long *)addr) : "Ir" (nr) : "memory");
  800820:	8b 55 0c             	mov    0xc(%ebp),%edx
  800823:	8b 45 08             	mov    0x8(%ebp),%eax
  800826:	0f b3 02             	btr    %eax,(%edx)
  800829:	19 db                	sbb    %ebx,%ebx
  80082b:	89 5d f8             	mov    %ebx,-0x8(%ebp)
    return oldbit != 0;
  80082e:	83 7d f8 00          	cmpl   $0x0,-0x8(%ebp)
  800832:	0f 95 c0             	setne  %al
  800835:	0f b6 c0             	movzbl %al,%eax
}
  800838:	83 c4 10             	add    $0x10,%esp
  80083b:	5b                   	pop    %ebx
  80083c:	5d                   	pop    %ebp
  80083d:	c3                   	ret    

0080083e <try_lock>:
lock_init(lock_t *l) {
    *l = 0;
}

static inline bool
try_lock(lock_t *l) {
  80083e:	55                   	push   %ebp
  80083f:	89 e5                	mov    %esp,%ebp
  800841:	83 ec 08             	sub    $0x8,%esp
    return test_and_set_bit(0, l);
  800844:	8b 45 08             	mov    0x8(%ebp),%eax
  800847:	89 44 24 04          	mov    %eax,0x4(%esp)
  80084b:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800852:	e8 9d ff ff ff       	call   8007f4 <test_and_set_bit>
}
  800857:	c9                   	leave  
  800858:	c3                   	ret    

00800859 <lock>:

static inline void
lock(lock_t *l) {
  800859:	55                   	push   %ebp
  80085a:	89 e5                	mov    %esp,%ebp
  80085c:	83 ec 28             	sub    $0x28,%esp
    if (try_lock(l)) {
  80085f:	8b 45 08             	mov    0x8(%ebp),%eax
  800862:	89 04 24             	mov    %eax,(%esp)
  800865:	e8 d4 ff ff ff       	call   80083e <try_lock>
  80086a:	85 c0                	test   %eax,%eax
  80086c:	74 38                	je     8008a6 <lock+0x4d>
        int step = 0;
  80086e:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
        do {
            yield();
  800875:	e8 d3 00 00 00       	call   80094d <yield>
            if (++ step == 100) {
  80087a:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
  80087e:	83 7d f4 64          	cmpl   $0x64,-0xc(%ebp)
  800882:	75 13                	jne    800897 <lock+0x3e>
                step = 0;
  800884:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
                sleep(10);
  80088b:	c7 04 24 0a 00 00 00 	movl   $0xa,(%esp)
  800892:	e8 03 01 00 00       	call   80099a <sleep>
            }
        } while (try_lock(l));
  800897:	8b 45 08             	mov    0x8(%ebp),%eax
  80089a:	89 04 24             	mov    %eax,(%esp)
  80089d:	e8 9c ff ff ff       	call   80083e <try_lock>
  8008a2:	85 c0                	test   %eax,%eax
  8008a4:	75 cf                	jne    800875 <lock+0x1c>
    }
}
  8008a6:	c9                   	leave  
  8008a7:	c3                   	ret    

008008a8 <unlock>:

static inline void
unlock(lock_t *l) {
  8008a8:	55                   	push   %ebp
  8008a9:	89 e5                	mov    %esp,%ebp
  8008ab:	83 ec 08             	sub    $0x8,%esp
    test_and_clear_bit(0, l);
  8008ae:	8b 45 08             	mov    0x8(%ebp),%eax
  8008b1:	89 44 24 04          	mov    %eax,0x4(%esp)
  8008b5:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  8008bc:	e8 58 ff ff ff       	call   800819 <test_and_clear_bit>
}
  8008c1:	c9                   	leave  
  8008c2:	c3                   	ret    

008008c3 <lock_fork>:
#include <lock.h>

static lock_t fork_lock = INIT_LOCK;

void
lock_fork(void) {
  8008c3:	55                   	push   %ebp
  8008c4:	89 e5                	mov    %esp,%ebp
  8008c6:	83 ec 18             	sub    $0x18,%esp
    lock(&fork_lock);
  8008c9:	c7 04 24 20 20 80 00 	movl   $0x802020,(%esp)
  8008d0:	e8 84 ff ff ff       	call   800859 <lock>
}
  8008d5:	c9                   	leave  
  8008d6:	c3                   	ret    

008008d7 <unlock_fork>:

void
unlock_fork(void) {
  8008d7:	55                   	push   %ebp
  8008d8:	89 e5                	mov    %esp,%ebp
  8008da:	83 ec 04             	sub    $0x4,%esp
    unlock(&fork_lock);
  8008dd:	c7 04 24 20 20 80 00 	movl   $0x802020,(%esp)
  8008e4:	e8 bf ff ff ff       	call   8008a8 <unlock>
}
  8008e9:	c9                   	leave  
  8008ea:	c3                   	ret    

008008eb <exit>:

void
exit(int error_code) {
  8008eb:	55                   	push   %ebp
  8008ec:	89 e5                	mov    %esp,%ebp
  8008ee:	83 ec 18             	sub    $0x18,%esp
    sys_exit(error_code);
  8008f1:	8b 45 08             	mov    0x8(%ebp),%eax
  8008f4:	89 04 24             	mov    %eax,(%esp)
  8008f7:	e8 64 fc ff ff       	call   800560 <sys_exit>
    cprintf("BUG: exit failed.\n");
  8008fc:	c7 04 24 ce 19 80 00 	movl   $0x8019ce,(%esp)
  800903:	e8 dc fa ff ff       	call   8003e4 <cprintf>
    while (1);
  800908:	eb fe                	jmp    800908 <exit+0x1d>

0080090a <fork>:
}

int
fork(void) {
  80090a:	55                   	push   %ebp
  80090b:	89 e5                	mov    %esp,%ebp
  80090d:	83 ec 08             	sub    $0x8,%esp
    return sys_fork();
  800910:	e8 66 fc ff ff       	call   80057b <sys_fork>
}
  800915:	c9                   	leave  
  800916:	c3                   	ret    

00800917 <wait>:

int
wait(void) {
  800917:	55                   	push   %ebp
  800918:	89 e5                	mov    %esp,%ebp
  80091a:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(0, NULL);
  80091d:	c7 44 24 04 00 00 00 	movl   $0x0,0x4(%esp)
  800924:	00 
  800925:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  80092c:	e8 5e fc ff ff       	call   80058f <sys_wait>
}
  800931:	c9                   	leave  
  800932:	c3                   	ret    

00800933 <waitpid>:

int
waitpid(int pid, int *store) {
  800933:	55                   	push   %ebp
  800934:	89 e5                	mov    %esp,%ebp
  800936:	83 ec 18             	sub    $0x18,%esp
    return sys_wait(pid, store);
  800939:	8b 45 0c             	mov    0xc(%ebp),%eax
  80093c:	89 44 24 04          	mov    %eax,0x4(%esp)
  800940:	8b 45 08             	mov    0x8(%ebp),%eax
  800943:	89 04 24             	mov    %eax,(%esp)
  800946:	e8 44 fc ff ff       	call   80058f <sys_wait>
}
  80094b:	c9                   	leave  
  80094c:	c3                   	ret    

0080094d <yield>:

void
yield(void) {
  80094d:	55                   	push   %ebp
  80094e:	89 e5                	mov    %esp,%ebp
  800950:	83 ec 08             	sub    $0x8,%esp
    sys_yield();
  800953:	e8 59 fc ff ff       	call   8005b1 <sys_yield>
}
  800958:	c9                   	leave  
  800959:	c3                   	ret    

0080095a <kill>:

int
kill(int pid) {
  80095a:	55                   	push   %ebp
  80095b:	89 e5                	mov    %esp,%ebp
  80095d:	83 ec 18             	sub    $0x18,%esp
    return sys_kill(pid);
  800960:	8b 45 08             	mov    0x8(%ebp),%eax
  800963:	89 04 24             	mov    %eax,(%esp)
  800966:	e8 5a fc ff ff       	call   8005c5 <sys_kill>
}
  80096b:	c9                   	leave  
  80096c:	c3                   	ret    

0080096d <getpid>:

int
getpid(void) {
  80096d:	55                   	push   %ebp
  80096e:	89 e5                	mov    %esp,%ebp
  800970:	83 ec 08             	sub    $0x8,%esp
    return sys_getpid();
  800973:	e8 68 fc ff ff       	call   8005e0 <sys_getpid>
}
  800978:	c9                   	leave  
  800979:	c3                   	ret    

0080097a <print_pgdir>:

//print_pgdir - print the PDT&PT
void
print_pgdir(void) {
  80097a:	55                   	push   %ebp
  80097b:	89 e5                	mov    %esp,%ebp
  80097d:	83 ec 08             	sub    $0x8,%esp
    sys_pgdir();
  800980:	e8 8a fc ff ff       	call   80060f <sys_pgdir>
}
  800985:	c9                   	leave  
  800986:	c3                   	ret    

00800987 <lab6_set_priority>:

void
lab6_set_priority(uint32_t priority)
{
  800987:	55                   	push   %ebp
  800988:	89 e5                	mov    %esp,%ebp
  80098a:	83 ec 18             	sub    $0x18,%esp
    sys_lab6_set_priority(priority);
  80098d:	8b 45 08             	mov    0x8(%ebp),%eax
  800990:	89 04 24             	mov    %eax,(%esp)
  800993:	e8 8b fc ff ff       	call   800623 <sys_lab6_set_priority>
}
  800998:	c9                   	leave  
  800999:	c3                   	ret    

0080099a <sleep>:

int
sleep(unsigned int time) {
  80099a:	55                   	push   %ebp
  80099b:	89 e5                	mov    %esp,%ebp
  80099d:	83 ec 18             	sub    $0x18,%esp
    return sys_sleep(time);
  8009a0:	8b 45 08             	mov    0x8(%ebp),%eax
  8009a3:	89 04 24             	mov    %eax,(%esp)
  8009a6:	e8 93 fc ff ff       	call   80063e <sys_sleep>
}
  8009ab:	c9                   	leave  
  8009ac:	c3                   	ret    

008009ad <gettime_msec>:

unsigned int
gettime_msec(void) {
  8009ad:	55                   	push   %ebp
  8009ae:	89 e5                	mov    %esp,%ebp
  8009b0:	83 ec 08             	sub    $0x8,%esp
    return (unsigned int)sys_gettime();
  8009b3:	e8 a1 fc ff ff       	call   800659 <sys_gettime>
}
  8009b8:	c9                   	leave  
  8009b9:	c3                   	ret    

008009ba <__exec>:

int
__exec(const char *name, const char **argv) {
  8009ba:	55                   	push   %ebp
  8009bb:	89 e5                	mov    %esp,%ebp
  8009bd:	83 ec 28             	sub    $0x28,%esp
    int argc = 0;
  8009c0:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    while (argv[argc] != NULL) {
  8009c7:	eb 04                	jmp    8009cd <__exec+0x13>
        argc ++;
  8009c9:	83 45 f4 01          	addl   $0x1,-0xc(%ebp)
}

int
__exec(const char *name, const char **argv) {
    int argc = 0;
    while (argv[argc] != NULL) {
  8009cd:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009d0:	c1 e0 02             	shl    $0x2,%eax
  8009d3:	03 45 0c             	add    0xc(%ebp),%eax
  8009d6:	8b 00                	mov    (%eax),%eax
  8009d8:	85 c0                	test   %eax,%eax
  8009da:	75 ed                	jne    8009c9 <__exec+0xf>
        argc ++;
    }
    return sys_exec(name, argc, argv);
  8009dc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8009df:	89 44 24 08          	mov    %eax,0x8(%esp)
  8009e3:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8009e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8009ea:	8b 45 08             	mov    0x8(%ebp),%eax
  8009ed:	89 04 24             	mov    %eax,(%esp)
  8009f0:	e8 78 fc ff ff       	call   80066d <sys_exec>
}
  8009f5:	c9                   	leave  
  8009f6:	c3                   	ret    
	...

008009f8 <initfd>:
#include <stat.h>

int main(int argc, char *argv[]);

static int
initfd(int fd2, const char *path, uint32_t open_flags) {
  8009f8:	55                   	push   %ebp
  8009f9:	89 e5                	mov    %esp,%ebp
  8009fb:	83 ec 28             	sub    $0x28,%esp
    int fd1, ret;
    if ((fd1 = open(path, open_flags)) < 0) {
  8009fe:	8b 45 10             	mov    0x10(%ebp),%eax
  800a01:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a05:	8b 45 0c             	mov    0xc(%ebp),%eax
  800a08:	89 04 24             	mov    %eax,(%esp)
  800a0b:	e8 e8 f6 ff ff       	call   8000f8 <open>
  800a10:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800a13:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800a17:	79 05                	jns    800a1e <initfd+0x26>
        return fd1;
  800a19:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a1c:	eb 36                	jmp    800a54 <initfd+0x5c>
    }
    if (fd1 != fd2) {
  800a1e:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a21:	3b 45 08             	cmp    0x8(%ebp),%eax
  800a24:	74 2b                	je     800a51 <initfd+0x59>
        close(fd2);
  800a26:	8b 45 08             	mov    0x8(%ebp),%eax
  800a29:	89 04 24             	mov    %eax,(%esp)
  800a2c:	e8 e1 f6 ff ff       	call   800112 <close>
        ret = dup2(fd1, fd2);
  800a31:	8b 45 08             	mov    0x8(%ebp),%eax
  800a34:	89 44 24 04          	mov    %eax,0x4(%esp)
  800a38:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a3b:	89 04 24             	mov    %eax,(%esp)
  800a3e:	e8 72 f7 ff ff       	call   8001b5 <dup2>
  800a43:	89 45 f4             	mov    %eax,-0xc(%ebp)
        close(fd1);
  800a46:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800a49:	89 04 24             	mov    %eax,(%esp)
  800a4c:	e8 c1 f6 ff ff       	call   800112 <close>
    }
    return ret;
  800a51:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  800a54:	c9                   	leave  
  800a55:	c3                   	ret    

00800a56 <umain>:

void
umain(int argc, char *argv[]) {
  800a56:	55                   	push   %ebp
  800a57:	89 e5                	mov    %esp,%ebp
  800a59:	83 ec 28             	sub    $0x28,%esp
    int fd;
    if ((fd = initfd(0, "stdin:", O_RDONLY)) < 0) {
  800a5c:	c7 44 24 08 00 00 00 	movl   $0x0,0x8(%esp)
  800a63:	00 
  800a64:	c7 44 24 04 e1 19 80 	movl   $0x8019e1,0x4(%esp)
  800a6b:	00 
  800a6c:	c7 04 24 00 00 00 00 	movl   $0x0,(%esp)
  800a73:	e8 80 ff ff ff       	call   8009f8 <initfd>
  800a78:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800a7b:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800a7f:	79 23                	jns    800aa4 <umain+0x4e>
        warn("open <stdin> failed: %e.\n", fd);
  800a81:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800a84:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800a88:	c7 44 24 08 e8 19 80 	movl   $0x8019e8,0x8(%esp)
  800a8f:	00 
  800a90:	c7 44 24 04 1a 00 00 	movl   $0x1a,0x4(%esp)
  800a97:	00 
  800a98:	c7 04 24 02 1a 80 00 	movl   $0x801a02,(%esp)
  800a9f:	e8 9a f8 ff ff       	call   80033e <__warn>
    }
    if ((fd = initfd(1, "stdout:", O_WRONLY)) < 0) {
  800aa4:	c7 44 24 08 01 00 00 	movl   $0x1,0x8(%esp)
  800aab:	00 
  800aac:	c7 44 24 04 14 1a 80 	movl   $0x801a14,0x4(%esp)
  800ab3:	00 
  800ab4:	c7 04 24 01 00 00 00 	movl   $0x1,(%esp)
  800abb:	e8 38 ff ff ff       	call   8009f8 <initfd>
  800ac0:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800ac3:	83 7d f4 00          	cmpl   $0x0,-0xc(%ebp)
  800ac7:	79 23                	jns    800aec <umain+0x96>
        warn("open <stdout> failed: %e.\n", fd);
  800ac9:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800acc:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800ad0:	c7 44 24 08 1c 1a 80 	movl   $0x801a1c,0x8(%esp)
  800ad7:	00 
  800ad8:	c7 44 24 04 1d 00 00 	movl   $0x1d,0x4(%esp)
  800adf:	00 
  800ae0:	c7 04 24 02 1a 80 00 	movl   $0x801a02,(%esp)
  800ae7:	e8 52 f8 ff ff       	call   80033e <__warn>
    }
    int ret = main(argc, argv);
  800aec:	8b 45 0c             	mov    0xc(%ebp),%eax
  800aef:	89 44 24 04          	mov    %eax,0x4(%esp)
  800af3:	8b 45 08             	mov    0x8(%ebp),%eax
  800af6:	89 04 24             	mov    %eax,(%esp)
  800af9:	e8 ae 0d 00 00       	call   8018ac <main>
  800afe:	89 45 f0             	mov    %eax,-0x10(%ebp)
    exit(ret);
  800b01:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b04:	89 04 24             	mov    %eax,(%esp)
  800b07:	e8 df fd ff ff       	call   8008eb <exit>

00800b0c <hash32>:
 * @bits:   the number of bits in a return value
 *
 * High bits are more random, so we use them.
 * */
uint32_t
hash32(uint32_t val, unsigned int bits) {
  800b0c:	55                   	push   %ebp
  800b0d:	89 e5                	mov    %esp,%ebp
  800b0f:	53                   	push   %ebx
  800b10:	83 ec 10             	sub    $0x10,%esp
    uint32_t hash = val * GOLDEN_RATIO_PRIME_32;
  800b13:	8b 45 08             	mov    0x8(%ebp),%eax
  800b16:	69 c0 01 00 37 9e    	imul   $0x9e370001,%eax,%eax
  800b1c:	89 45 f8             	mov    %eax,-0x8(%ebp)
    return (hash >> (32 - bits));
  800b1f:	b8 20 00 00 00       	mov    $0x20,%eax
  800b24:	2b 45 0c             	sub    0xc(%ebp),%eax
  800b27:	8b 55 f8             	mov    -0x8(%ebp),%edx
  800b2a:	89 d3                	mov    %edx,%ebx
  800b2c:	89 c1                	mov    %eax,%ecx
  800b2e:	d3 eb                	shr    %cl,%ebx
  800b30:	89 d8                	mov    %ebx,%eax
}
  800b32:	83 c4 10             	add    $0x10,%esp
  800b35:	5b                   	pop    %ebx
  800b36:	5d                   	pop    %ebp
  800b37:	c3                   	ret    

00800b38 <printnum>:
 * @width:      maximum number of digits, if the actual width is less than @width, use @padc instead
 * @padc:       character that padded on the left if the actual width is less than @width
 * */
static void
printnum(void (*putch)(int, void*, int), int fd, void *putdat,
        unsigned long long num, unsigned base, int width, int padc) {
  800b38:	55                   	push   %ebp
  800b39:	89 e5                	mov    %esp,%ebp
  800b3b:	56                   	push   %esi
  800b3c:	53                   	push   %ebx
  800b3d:	83 ec 60             	sub    $0x60,%esp
  800b40:	8b 45 14             	mov    0x14(%ebp),%eax
  800b43:	89 45 d0             	mov    %eax,-0x30(%ebp)
  800b46:	8b 45 18             	mov    0x18(%ebp),%eax
  800b49:	89 45 d4             	mov    %eax,-0x2c(%ebp)
    unsigned long long result = num;
  800b4c:	8b 45 d0             	mov    -0x30(%ebp),%eax
  800b4f:	8b 55 d4             	mov    -0x2c(%ebp),%edx
  800b52:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800b55:	89 55 ec             	mov    %edx,-0x14(%ebp)
    unsigned mod = do_div(result, base);
  800b58:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800b5b:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  800b5e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800b61:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800b64:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800b67:	89 55 cc             	mov    %edx,-0x34(%ebp)
  800b6a:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800b6d:	8b 55 cc             	mov    -0x34(%ebp),%edx
  800b70:	89 d3                	mov    %edx,%ebx
  800b72:	89 c6                	mov    %eax,%esi
  800b74:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800b77:	89 5d f0             	mov    %ebx,-0x10(%ebp)
  800b7a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b7d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  800b80:	83 7d f0 00          	cmpl   $0x0,-0x10(%ebp)
  800b84:	74 1c                	je     800ba2 <printnum+0x6a>
  800b86:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b89:	ba 00 00 00 00       	mov    $0x0,%edx
  800b8e:	f7 75 e4             	divl   -0x1c(%ebp)
  800b91:	89 55 f4             	mov    %edx,-0xc(%ebp)
  800b94:	8b 45 f0             	mov    -0x10(%ebp),%eax
  800b97:	ba 00 00 00 00       	mov    $0x0,%edx
  800b9c:	f7 75 e4             	divl   -0x1c(%ebp)
  800b9f:	89 45 f0             	mov    %eax,-0x10(%ebp)
  800ba2:	8b 55 e0             	mov    -0x20(%ebp),%edx
  800ba5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800ba8:	89 d6                	mov    %edx,%esi
  800baa:	89 c3                	mov    %eax,%ebx
  800bac:	89 f0                	mov    %esi,%eax
  800bae:	89 da                	mov    %ebx,%edx
  800bb0:	f7 75 e4             	divl   -0x1c(%ebp)
  800bb3:	89 d3                	mov    %edx,%ebx
  800bb5:	89 c6                	mov    %eax,%esi
  800bb7:	89 75 e0             	mov    %esi,-0x20(%ebp)
  800bba:	89 5d dc             	mov    %ebx,-0x24(%ebp)
  800bbd:	8b 45 e0             	mov    -0x20(%ebp),%eax
  800bc0:	89 45 c8             	mov    %eax,-0x38(%ebp)
  800bc3:	8b 55 f0             	mov    -0x10(%ebp),%edx
  800bc6:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  800bc9:	8b 45 c8             	mov    -0x38(%ebp),%eax
  800bcc:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  800bcf:	89 c3                	mov    %eax,%ebx
  800bd1:	89 d6                	mov    %edx,%esi
  800bd3:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  800bd6:	89 75 ec             	mov    %esi,-0x14(%ebp)
  800bd9:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800bdc:	89 45 d8             	mov    %eax,-0x28(%ebp)

    // first recursively print all preceding (more significant) digits
    if (num >= base) {
  800bdf:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800be2:	ba 00 00 00 00       	mov    $0x0,%edx
  800be7:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  800bea:	77 64                	ja     800c50 <printnum+0x118>
  800bec:	3b 55 d4             	cmp    -0x2c(%ebp),%edx
  800bef:	72 05                	jb     800bf6 <printnum+0xbe>
  800bf1:	3b 45 d0             	cmp    -0x30(%ebp),%eax
  800bf4:	77 5a                	ja     800c50 <printnum+0x118>
        printnum(putch, fd, putdat, result, base, width - 1, padc);
  800bf6:	8b 45 20             	mov    0x20(%ebp),%eax
  800bf9:	8d 50 ff             	lea    -0x1(%eax),%edx
  800bfc:	8b 45 24             	mov    0x24(%ebp),%eax
  800bff:	89 44 24 1c          	mov    %eax,0x1c(%esp)
  800c03:	89 54 24 18          	mov    %edx,0x18(%esp)
  800c07:	8b 45 1c             	mov    0x1c(%ebp),%eax
  800c0a:	89 44 24 14          	mov    %eax,0x14(%esp)
  800c0e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  800c11:	8b 55 ec             	mov    -0x14(%ebp),%edx
  800c14:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800c18:	89 54 24 10          	mov    %edx,0x10(%esp)
  800c1c:	8b 45 10             	mov    0x10(%ebp),%eax
  800c1f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c23:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c26:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c2a:	8b 45 08             	mov    0x8(%ebp),%eax
  800c2d:	89 04 24             	mov    %eax,(%esp)
  800c30:	e8 03 ff ff ff       	call   800b38 <printnum>
  800c35:	eb 23                	jmp    800c5a <printnum+0x122>
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
            putch(padc, putdat, fd);
  800c37:	8b 45 0c             	mov    0xc(%ebp),%eax
  800c3a:	89 44 24 08          	mov    %eax,0x8(%esp)
  800c3e:	8b 45 10             	mov    0x10(%ebp),%eax
  800c41:	89 44 24 04          	mov    %eax,0x4(%esp)
  800c45:	8b 45 24             	mov    0x24(%ebp),%eax
  800c48:	89 04 24             	mov    %eax,(%esp)
  800c4b:	8b 45 08             	mov    0x8(%ebp),%eax
  800c4e:	ff d0                	call   *%eax
    // first recursively print all preceding (more significant) digits
    if (num >= base) {
        printnum(putch, fd, putdat, result, base, width - 1, padc);
    } else {
        // print any needed pad characters before first digit
        while (-- width > 0)
  800c50:	83 6d 20 01          	subl   $0x1,0x20(%ebp)
  800c54:	83 7d 20 00          	cmpl   $0x0,0x20(%ebp)
  800c58:	7f dd                	jg     800c37 <printnum+0xff>
            putch(padc, putdat, fd);
    }
    // then print this (the least significant) digit
    putch("0123456789abcdef"[mod], putdat, fd);
  800c5a:	8b 45 d8             	mov    -0x28(%ebp),%eax
  800c5d:	05 44 1c 80 00       	add    $0x801c44,%eax
  800c62:	0f b6 00             	movzbl (%eax),%eax
  800c65:	0f be c0             	movsbl %al,%eax
  800c68:	8b 55 0c             	mov    0xc(%ebp),%edx
  800c6b:	89 54 24 08          	mov    %edx,0x8(%esp)
  800c6f:	8b 55 10             	mov    0x10(%ebp),%edx
  800c72:	89 54 24 04          	mov    %edx,0x4(%esp)
  800c76:	89 04 24             	mov    %eax,(%esp)
  800c79:	8b 45 08             	mov    0x8(%ebp),%eax
  800c7c:	ff d0                	call   *%eax
}
  800c7e:	83 c4 60             	add    $0x60,%esp
  800c81:	5b                   	pop    %ebx
  800c82:	5e                   	pop    %esi
  800c83:	5d                   	pop    %ebp
  800c84:	c3                   	ret    

00800c85 <getuint>:
 * getuint - get an unsigned int of various possible sizes from a varargs list
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static unsigned long long
getuint(va_list *ap, int lflag) {
  800c85:	55                   	push   %ebp
  800c86:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  800c88:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800c8c:	7e 14                	jle    800ca2 <getuint+0x1d>
        return va_arg(*ap, unsigned long long);
  800c8e:	8b 45 08             	mov    0x8(%ebp),%eax
  800c91:	8b 00                	mov    (%eax),%eax
  800c93:	8d 48 08             	lea    0x8(%eax),%ecx
  800c96:	8b 55 08             	mov    0x8(%ebp),%edx
  800c99:	89 0a                	mov    %ecx,(%edx)
  800c9b:	8b 50 04             	mov    0x4(%eax),%edx
  800c9e:	8b 00                	mov    (%eax),%eax
  800ca0:	eb 30                	jmp    800cd2 <getuint+0x4d>
    }
    else if (lflag) {
  800ca2:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800ca6:	74 16                	je     800cbe <getuint+0x39>
        return va_arg(*ap, unsigned long);
  800ca8:	8b 45 08             	mov    0x8(%ebp),%eax
  800cab:	8b 00                	mov    (%eax),%eax
  800cad:	8d 48 04             	lea    0x4(%eax),%ecx
  800cb0:	8b 55 08             	mov    0x8(%ebp),%edx
  800cb3:	89 0a                	mov    %ecx,(%edx)
  800cb5:	8b 00                	mov    (%eax),%eax
  800cb7:	ba 00 00 00 00       	mov    $0x0,%edx
  800cbc:	eb 14                	jmp    800cd2 <getuint+0x4d>
    }
    else {
        return va_arg(*ap, unsigned int);
  800cbe:	8b 45 08             	mov    0x8(%ebp),%eax
  800cc1:	8b 00                	mov    (%eax),%eax
  800cc3:	8d 48 04             	lea    0x4(%eax),%ecx
  800cc6:	8b 55 08             	mov    0x8(%ebp),%edx
  800cc9:	89 0a                	mov    %ecx,(%edx)
  800ccb:	8b 00                	mov    (%eax),%eax
  800ccd:	ba 00 00 00 00       	mov    $0x0,%edx
    }
}
  800cd2:	5d                   	pop    %ebp
  800cd3:	c3                   	ret    

00800cd4 <getint>:
 * getint - same as getuint but signed, we can't use getuint because of sign extension
 * @ap:         a varargs list pointer
 * @lflag:      determines the size of the vararg that @ap points to
 * */
static long long
getint(va_list *ap, int lflag) {
  800cd4:	55                   	push   %ebp
  800cd5:	89 e5                	mov    %esp,%ebp
    if (lflag >= 2) {
  800cd7:	83 7d 0c 01          	cmpl   $0x1,0xc(%ebp)
  800cdb:	7e 14                	jle    800cf1 <getint+0x1d>
        return va_arg(*ap, long long);
  800cdd:	8b 45 08             	mov    0x8(%ebp),%eax
  800ce0:	8b 00                	mov    (%eax),%eax
  800ce2:	8d 48 08             	lea    0x8(%eax),%ecx
  800ce5:	8b 55 08             	mov    0x8(%ebp),%edx
  800ce8:	89 0a                	mov    %ecx,(%edx)
  800cea:	8b 50 04             	mov    0x4(%eax),%edx
  800ced:	8b 00                	mov    (%eax),%eax
  800cef:	eb 30                	jmp    800d21 <getint+0x4d>
    }
    else if (lflag) {
  800cf1:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  800cf5:	74 16                	je     800d0d <getint+0x39>
        return va_arg(*ap, long);
  800cf7:	8b 45 08             	mov    0x8(%ebp),%eax
  800cfa:	8b 00                	mov    (%eax),%eax
  800cfc:	8d 48 04             	lea    0x4(%eax),%ecx
  800cff:	8b 55 08             	mov    0x8(%ebp),%edx
  800d02:	89 0a                	mov    %ecx,(%edx)
  800d04:	8b 00                	mov    (%eax),%eax
  800d06:	89 c2                	mov    %eax,%edx
  800d08:	c1 fa 1f             	sar    $0x1f,%edx
  800d0b:	eb 14                	jmp    800d21 <getint+0x4d>
    }
    else {
        return va_arg(*ap, int);
  800d0d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d10:	8b 00                	mov    (%eax),%eax
  800d12:	8d 48 04             	lea    0x4(%eax),%ecx
  800d15:	8b 55 08             	mov    0x8(%ebp),%edx
  800d18:	89 0a                	mov    %ecx,(%edx)
  800d1a:	8b 00                	mov    (%eax),%eax
  800d1c:	89 c2                	mov    %eax,%edx
  800d1e:	c1 fa 1f             	sar    $0x1f,%edx
    }
}
  800d21:	5d                   	pop    %ebp
  800d22:	c3                   	ret    

00800d23 <printfmt>:
 * @fd:         file descriptor
 * @putdat:     used by @putch function
 * @fmt:        the format string to use
 * */
void
printfmt(void (*putch)(int, void*, int), int fd, void *putdat, const char *fmt, ...) {
  800d23:	55                   	push   %ebp
  800d24:	89 e5                	mov    %esp,%ebp
  800d26:	83 ec 38             	sub    $0x38,%esp
    va_list ap;

    va_start(ap, fmt);
  800d29:	8d 55 18             	lea    0x18(%ebp),%edx
  800d2c:	8d 45 f4             	lea    -0xc(%ebp),%eax
  800d2f:	89 10                	mov    %edx,(%eax)
    vprintfmt(putch, fd, putdat, fmt, ap);
  800d31:	8b 45 f4             	mov    -0xc(%ebp),%eax
  800d34:	89 44 24 10          	mov    %eax,0x10(%esp)
  800d38:	8b 45 14             	mov    0x14(%ebp),%eax
  800d3b:	89 44 24 0c          	mov    %eax,0xc(%esp)
  800d3f:	8b 45 10             	mov    0x10(%ebp),%eax
  800d42:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d46:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d49:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d4d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d50:	89 04 24             	mov    %eax,(%esp)
  800d53:	e8 02 00 00 00       	call   800d5a <vprintfmt>
    va_end(ap);
}
  800d58:	c9                   	leave  
  800d59:	c3                   	ret    

00800d5a <vprintfmt>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want printfmt() instead.
 * */
void
vprintfmt(void (*putch)(int, void*, int), int fd, void *putdat, const char *fmt, va_list ap) {
  800d5a:	55                   	push   %ebp
  800d5b:	89 e5                	mov    %esp,%ebp
  800d5d:	56                   	push   %esi
  800d5e:	53                   	push   %ebx
  800d5f:	83 ec 40             	sub    $0x40,%esp
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800d62:	eb 1e                	jmp    800d82 <vprintfmt+0x28>
            if (ch == '\0') {
  800d64:	85 db                	test   %ebx,%ebx
  800d66:	0f 84 45 04 00 00    	je     8011b1 <vprintfmt+0x457>
                return;
            }
            putch(ch, putdat, fd);
  800d6c:	8b 45 0c             	mov    0xc(%ebp),%eax
  800d6f:	89 44 24 08          	mov    %eax,0x8(%esp)
  800d73:	8b 45 10             	mov    0x10(%ebp),%eax
  800d76:	89 44 24 04          	mov    %eax,0x4(%esp)
  800d7a:	89 1c 24             	mov    %ebx,(%esp)
  800d7d:	8b 45 08             	mov    0x8(%ebp),%eax
  800d80:	ff d0                	call   *%eax
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  800d82:	8b 45 14             	mov    0x14(%ebp),%eax
  800d85:	0f b6 00             	movzbl (%eax),%eax
  800d88:	0f b6 d8             	movzbl %al,%ebx
  800d8b:	83 fb 25             	cmp    $0x25,%ebx
  800d8e:	0f 95 c0             	setne  %al
  800d91:	83 45 14 01          	addl   $0x1,0x14(%ebp)
  800d95:	84 c0                	test   %al,%al
  800d97:	75 cb                	jne    800d64 <vprintfmt+0xa>
            }
            putch(ch, putdat, fd);
        }

        // Process a %-escape sequence
        char padc = ' ';
  800d99:	c6 45 db 20          	movb   $0x20,-0x25(%ebp)
        width = precision = -1;
  800d9d:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
  800da4:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800da7:	89 45 e8             	mov    %eax,-0x18(%ebp)
        lflag = altflag = 0;
  800daa:	c7 45 dc 00 00 00 00 	movl   $0x0,-0x24(%ebp)
  800db1:	8b 45 dc             	mov    -0x24(%ebp),%eax
  800db4:	89 45 e0             	mov    %eax,-0x20(%ebp)
  800db7:	eb 04                	jmp    800dbd <vprintfmt+0x63>
            goto process_precision;

        case '.':
            if (width < 0)
                width = 0;
            goto reswitch;
  800db9:	90                   	nop
  800dba:	eb 01                	jmp    800dbd <vprintfmt+0x63>
            goto reswitch;

        process_precision:
            if (width < 0)
                width = precision, precision = -1;
            goto reswitch;
  800dbc:	90                   	nop
        char padc = ' ';
        width = precision = -1;
        lflag = altflag = 0;

    reswitch:
        switch (ch = *(unsigned char *)fmt ++) {
  800dbd:	8b 45 14             	mov    0x14(%ebp),%eax
  800dc0:	0f b6 00             	movzbl (%eax),%eax
  800dc3:	0f b6 d8             	movzbl %al,%ebx
  800dc6:	89 d8                	mov    %ebx,%eax
  800dc8:	83 45 14 01          	addl   $0x1,0x14(%ebp)
  800dcc:	83 e8 23             	sub    $0x23,%eax
  800dcf:	83 f8 55             	cmp    $0x55,%eax
  800dd2:	0f 87 a1 03 00 00    	ja     801179 <vprintfmt+0x41f>
  800dd8:	8b 04 85 68 1c 80 00 	mov    0x801c68(,%eax,4),%eax
  800ddf:	ff e0                	jmp    *%eax

        // flag to pad on the right
        case '-':
            padc = '-';
  800de1:	c6 45 db 2d          	movb   $0x2d,-0x25(%ebp)
            goto reswitch;
  800de5:	eb d6                	jmp    800dbd <vprintfmt+0x63>

        // flag to pad with 0's instead of spaces
        case '0':
            padc = '0';
  800de7:	c6 45 db 30          	movb   $0x30,-0x25(%ebp)
            goto reswitch;
  800deb:	eb d0                	jmp    800dbd <vprintfmt+0x63>

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  800ded:	c7 45 e4 00 00 00 00 	movl   $0x0,-0x1c(%ebp)
                precision = precision * 10 + ch - '0';
  800df4:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  800df7:	89 d0                	mov    %edx,%eax
  800df9:	c1 e0 02             	shl    $0x2,%eax
  800dfc:	01 d0                	add    %edx,%eax
  800dfe:	01 c0                	add    %eax,%eax
  800e00:	01 d8                	add    %ebx,%eax
  800e02:	83 e8 30             	sub    $0x30,%eax
  800e05:	89 45 e4             	mov    %eax,-0x1c(%ebp)
                ch = *fmt;
  800e08:	8b 45 14             	mov    0x14(%ebp),%eax
  800e0b:	0f b6 00             	movzbl (%eax),%eax
  800e0e:	0f be d8             	movsbl %al,%ebx
                if (ch < '0' || ch > '9') {
  800e11:	83 fb 2f             	cmp    $0x2f,%ebx
  800e14:	7e 39                	jle    800e4f <vprintfmt+0xf5>
  800e16:	83 fb 39             	cmp    $0x39,%ebx
  800e19:	7f 34                	jg     800e4f <vprintfmt+0xf5>
            padc = '0';
            goto reswitch;

        // width field
        case '1' ... '9':
            for (precision = 0; ; ++ fmt) {
  800e1b:	83 45 14 01          	addl   $0x1,0x14(%ebp)
                precision = precision * 10 + ch - '0';
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
  800e1f:	eb d3                	jmp    800df4 <vprintfmt+0x9a>
            goto process_precision;

        case '*':
            precision = va_arg(ap, int);
  800e21:	8b 45 18             	mov    0x18(%ebp),%eax
  800e24:	8d 50 04             	lea    0x4(%eax),%edx
  800e27:	89 55 18             	mov    %edx,0x18(%ebp)
  800e2a:	8b 00                	mov    (%eax),%eax
  800e2c:	89 45 e4             	mov    %eax,-0x1c(%ebp)
            goto process_precision;
  800e2f:	eb 1f                	jmp    800e50 <vprintfmt+0xf6>

        case '.':
            if (width < 0)
  800e31:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800e35:	79 82                	jns    800db9 <vprintfmt+0x5f>
                width = 0;
  800e37:	c7 45 e8 00 00 00 00 	movl   $0x0,-0x18(%ebp)
            goto reswitch;
  800e3e:	e9 76 ff ff ff       	jmp    800db9 <vprintfmt+0x5f>

        case '#':
            altflag = 1;
  800e43:	c7 45 dc 01 00 00 00 	movl   $0x1,-0x24(%ebp)
            goto reswitch;
  800e4a:	e9 6e ff ff ff       	jmp    800dbd <vprintfmt+0x63>
                ch = *fmt;
                if (ch < '0' || ch > '9') {
                    break;
                }
            }
            goto process_precision;
  800e4f:	90                   	nop
        case '#':
            altflag = 1;
            goto reswitch;

        process_precision:
            if (width < 0)
  800e50:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800e54:	0f 89 62 ff ff ff    	jns    800dbc <vprintfmt+0x62>
                width = precision, precision = -1;
  800e5a:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800e5d:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800e60:	c7 45 e4 ff ff ff ff 	movl   $0xffffffff,-0x1c(%ebp)
            goto reswitch;
  800e67:	e9 50 ff ff ff       	jmp    800dbc <vprintfmt+0x62>

        // long flag (doubled for long long)
        case 'l':
            lflag ++;
  800e6c:	83 45 e0 01          	addl   $0x1,-0x20(%ebp)
            goto reswitch;
  800e70:	e9 48 ff ff ff       	jmp    800dbd <vprintfmt+0x63>

        // character
        case 'c':
            putch(va_arg(ap, int), putdat, fd);
  800e75:	8b 45 18             	mov    0x18(%ebp),%eax
  800e78:	8d 50 04             	lea    0x4(%eax),%edx
  800e7b:	89 55 18             	mov    %edx,0x18(%ebp)
  800e7e:	8b 00                	mov    (%eax),%eax
  800e80:	8b 55 0c             	mov    0xc(%ebp),%edx
  800e83:	89 54 24 08          	mov    %edx,0x8(%esp)
  800e87:	8b 55 10             	mov    0x10(%ebp),%edx
  800e8a:	89 54 24 04          	mov    %edx,0x4(%esp)
  800e8e:	89 04 24             	mov    %eax,(%esp)
  800e91:	8b 45 08             	mov    0x8(%ebp),%eax
  800e94:	ff d0                	call   *%eax
            break;
  800e96:	e9 10 03 00 00       	jmp    8011ab <vprintfmt+0x451>

        // error message
        case 'e':
            err = va_arg(ap, int);
  800e9b:	8b 45 18             	mov    0x18(%ebp),%eax
  800e9e:	8d 50 04             	lea    0x4(%eax),%edx
  800ea1:	89 55 18             	mov    %edx,0x18(%ebp)
  800ea4:	8b 18                	mov    (%eax),%ebx
            if (err < 0) {
  800ea6:	85 db                	test   %ebx,%ebx
  800ea8:	79 02                	jns    800eac <vprintfmt+0x152>
                err = -err;
  800eaa:	f7 db                	neg    %ebx
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
  800eac:	83 fb 18             	cmp    $0x18,%ebx
  800eaf:	7f 0b                	jg     800ebc <vprintfmt+0x162>
  800eb1:	8b 34 9d e0 1b 80 00 	mov    0x801be0(,%ebx,4),%esi
  800eb8:	85 f6                	test   %esi,%esi
  800eba:	75 2a                	jne    800ee6 <vprintfmt+0x18c>
                printfmt(putch, fd, putdat, "error %d", err);
  800ebc:	89 5c 24 10          	mov    %ebx,0x10(%esp)
  800ec0:	c7 44 24 0c 55 1c 80 	movl   $0x801c55,0xc(%esp)
  800ec7:	00 
  800ec8:	8b 45 10             	mov    0x10(%ebp),%eax
  800ecb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ecf:	8b 45 0c             	mov    0xc(%ebp),%eax
  800ed2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ed6:	8b 45 08             	mov    0x8(%ebp),%eax
  800ed9:	89 04 24             	mov    %eax,(%esp)
  800edc:	e8 42 fe ff ff       	call   800d23 <printfmt>
            }
            else {
                printfmt(putch, fd, putdat, "%s", p);
            }
            break;
  800ee1:	e9 c5 02 00 00       	jmp    8011ab <vprintfmt+0x451>
            }
            if (err > MAXERROR || (p = error_string[err]) == NULL) {
                printfmt(putch, fd, putdat, "error %d", err);
            }
            else {
                printfmt(putch, fd, putdat, "%s", p);
  800ee6:	89 74 24 10          	mov    %esi,0x10(%esp)
  800eea:	c7 44 24 0c 5e 1c 80 	movl   $0x801c5e,0xc(%esp)
  800ef1:	00 
  800ef2:	8b 45 10             	mov    0x10(%ebp),%eax
  800ef5:	89 44 24 08          	mov    %eax,0x8(%esp)
  800ef9:	8b 45 0c             	mov    0xc(%ebp),%eax
  800efc:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f00:	8b 45 08             	mov    0x8(%ebp),%eax
  800f03:	89 04 24             	mov    %eax,(%esp)
  800f06:	e8 18 fe ff ff       	call   800d23 <printfmt>
            }
            break;
  800f0b:	e9 9b 02 00 00       	jmp    8011ab <vprintfmt+0x451>

        // string
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
  800f10:	8b 45 18             	mov    0x18(%ebp),%eax
  800f13:	8d 50 04             	lea    0x4(%eax),%edx
  800f16:	89 55 18             	mov    %edx,0x18(%ebp)
  800f19:	8b 30                	mov    (%eax),%esi
  800f1b:	85 f6                	test   %esi,%esi
  800f1d:	75 05                	jne    800f24 <vprintfmt+0x1ca>
                p = "(null)";
  800f1f:	be 61 1c 80 00       	mov    $0x801c61,%esi
            }
            if (width > 0 && padc != '-') {
  800f24:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800f28:	0f 8e 95 00 00 00    	jle    800fc3 <vprintfmt+0x269>
  800f2e:	80 7d db 2d          	cmpb   $0x2d,-0x25(%ebp)
  800f32:	0f 84 8b 00 00 00    	je     800fc3 <vprintfmt+0x269>
                for (width -= strnlen(p, precision); width > 0; width --) {
  800f38:	8b 5d e8             	mov    -0x18(%ebp),%ebx
  800f3b:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  800f3e:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f42:	89 34 24             	mov    %esi,(%esp)
  800f45:	e8 75 04 00 00       	call   8013bf <strnlen>
  800f4a:	89 da                	mov    %ebx,%edx
  800f4c:	29 c2                	sub    %eax,%edx
  800f4e:	89 d0                	mov    %edx,%eax
  800f50:	89 45 e8             	mov    %eax,-0x18(%ebp)
  800f53:	eb 1e                	jmp    800f73 <vprintfmt+0x219>
                    putch(padc, putdat, fd);
  800f55:	0f be 45 db          	movsbl -0x25(%ebp),%eax
  800f59:	8b 55 0c             	mov    0xc(%ebp),%edx
  800f5c:	89 54 24 08          	mov    %edx,0x8(%esp)
  800f60:	8b 55 10             	mov    0x10(%ebp),%edx
  800f63:	89 54 24 04          	mov    %edx,0x4(%esp)
  800f67:	89 04 24             	mov    %eax,(%esp)
  800f6a:	8b 45 08             	mov    0x8(%ebp),%eax
  800f6d:	ff d0                	call   *%eax
        case 's':
            if ((p = va_arg(ap, char *)) == NULL) {
                p = "(null)";
            }
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
  800f6f:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800f73:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  800f77:	7f dc                	jg     800f55 <vprintfmt+0x1fb>
                    putch(padc, putdat, fd);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800f79:	eb 48                	jmp    800fc3 <vprintfmt+0x269>
                if (altflag && (ch < ' ' || ch > '~')) {
  800f7b:	83 7d dc 00          	cmpl   $0x0,-0x24(%ebp)
  800f7f:	74 26                	je     800fa7 <vprintfmt+0x24d>
  800f81:	83 fb 1f             	cmp    $0x1f,%ebx
  800f84:	7e 05                	jle    800f8b <vprintfmt+0x231>
  800f86:	83 fb 7e             	cmp    $0x7e,%ebx
  800f89:	7e 1c                	jle    800fa7 <vprintfmt+0x24d>
                    putch('?', putdat, fd);
  800f8b:	8b 45 0c             	mov    0xc(%ebp),%eax
  800f8e:	89 44 24 08          	mov    %eax,0x8(%esp)
  800f92:	8b 45 10             	mov    0x10(%ebp),%eax
  800f95:	89 44 24 04          	mov    %eax,0x4(%esp)
  800f99:	c7 04 24 3f 00 00 00 	movl   $0x3f,(%esp)
  800fa0:	8b 45 08             	mov    0x8(%ebp),%eax
  800fa3:	ff d0                	call   *%eax
  800fa5:	eb 16                	jmp    800fbd <vprintfmt+0x263>
                }
                else {
                    putch(ch, putdat, fd);
  800fa7:	8b 45 0c             	mov    0xc(%ebp),%eax
  800faa:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fae:	8b 45 10             	mov    0x10(%ebp),%eax
  800fb1:	89 44 24 04          	mov    %eax,0x4(%esp)
  800fb5:	89 1c 24             	mov    %ebx,(%esp)
  800fb8:	8b 45 08             	mov    0x8(%ebp),%eax
  800fbb:	ff d0                	call   *%eax
            if (width > 0 && padc != '-') {
                for (width -= strnlen(p, precision); width > 0; width --) {
                    putch(padc, putdat, fd);
                }
            }
            for (; (ch = *p ++) != '\0' && (precision < 0 || -- precision >= 0); width --) {
  800fbd:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  800fc1:	eb 01                	jmp    800fc4 <vprintfmt+0x26a>
  800fc3:	90                   	nop
  800fc4:	0f b6 06             	movzbl (%esi),%eax
  800fc7:	0f be d8             	movsbl %al,%ebx
  800fca:	85 db                	test   %ebx,%ebx
  800fcc:	0f 95 c0             	setne  %al
  800fcf:	83 c6 01             	add    $0x1,%esi
  800fd2:	84 c0                	test   %al,%al
  800fd4:	74 30                	je     801006 <vprintfmt+0x2ac>
  800fd6:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fda:	78 9f                	js     800f7b <vprintfmt+0x221>
  800fdc:	83 6d e4 01          	subl   $0x1,-0x1c(%ebp)
  800fe0:	83 7d e4 00          	cmpl   $0x0,-0x1c(%ebp)
  800fe4:	79 95                	jns    800f7b <vprintfmt+0x221>
                }
                else {
                    putch(ch, putdat, fd);
                }
            }
            for (; width > 0; width --) {
  800fe6:	eb 1e                	jmp    801006 <vprintfmt+0x2ac>
                putch(' ', putdat, fd);
  800fe8:	8b 45 0c             	mov    0xc(%ebp),%eax
  800feb:	89 44 24 08          	mov    %eax,0x8(%esp)
  800fef:	8b 45 10             	mov    0x10(%ebp),%eax
  800ff2:	89 44 24 04          	mov    %eax,0x4(%esp)
  800ff6:	c7 04 24 20 00 00 00 	movl   $0x20,(%esp)
  800ffd:	8b 45 08             	mov    0x8(%ebp),%eax
  801000:	ff d0                	call   *%eax
                }
                else {
                    putch(ch, putdat, fd);
                }
            }
            for (; width > 0; width --) {
  801002:	83 6d e8 01          	subl   $0x1,-0x18(%ebp)
  801006:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80100a:	7f dc                	jg     800fe8 <vprintfmt+0x28e>
                putch(' ', putdat, fd);
            }
            break;
  80100c:	e9 9a 01 00 00       	jmp    8011ab <vprintfmt+0x451>

        // (signed) decimal
        case 'd':
            num = getint(&ap, lflag);
  801011:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801014:	89 44 24 04          	mov    %eax,0x4(%esp)
  801018:	8d 45 18             	lea    0x18(%ebp),%eax
  80101b:	89 04 24             	mov    %eax,(%esp)
  80101e:	e8 b1 fc ff ff       	call   800cd4 <getint>
  801023:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801026:	89 55 f4             	mov    %edx,-0xc(%ebp)
            if ((long long)num < 0) {
  801029:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80102c:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80102f:	85 d2                	test   %edx,%edx
  801031:	79 2d                	jns    801060 <vprintfmt+0x306>
                putch('-', putdat, fd);
  801033:	8b 45 0c             	mov    0xc(%ebp),%eax
  801036:	89 44 24 08          	mov    %eax,0x8(%esp)
  80103a:	8b 45 10             	mov    0x10(%ebp),%eax
  80103d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801041:	c7 04 24 2d 00 00 00 	movl   $0x2d,(%esp)
  801048:	8b 45 08             	mov    0x8(%ebp),%eax
  80104b:	ff d0                	call   *%eax
                num = -(long long)num;
  80104d:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801050:	8b 55 f4             	mov    -0xc(%ebp),%edx
  801053:	f7 d8                	neg    %eax
  801055:	83 d2 00             	adc    $0x0,%edx
  801058:	f7 da                	neg    %edx
  80105a:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80105d:	89 55 f4             	mov    %edx,-0xc(%ebp)
            }
            base = 10;
  801060:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  801067:	e9 b6 00 00 00       	jmp    801122 <vprintfmt+0x3c8>

        // unsigned decimal
        case 'u':
            num = getuint(&ap, lflag);
  80106c:	8b 45 e0             	mov    -0x20(%ebp),%eax
  80106f:	89 44 24 04          	mov    %eax,0x4(%esp)
  801073:	8d 45 18             	lea    0x18(%ebp),%eax
  801076:	89 04 24             	mov    %eax,(%esp)
  801079:	e8 07 fc ff ff       	call   800c85 <getuint>
  80107e:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801081:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 10;
  801084:	c7 45 ec 0a 00 00 00 	movl   $0xa,-0x14(%ebp)
            goto number;
  80108b:	e9 92 00 00 00       	jmp    801122 <vprintfmt+0x3c8>

        // (unsigned) octal
        case 'o':
            num = getuint(&ap, lflag);
  801090:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801093:	89 44 24 04          	mov    %eax,0x4(%esp)
  801097:	8d 45 18             	lea    0x18(%ebp),%eax
  80109a:	89 04 24             	mov    %eax,(%esp)
  80109d:	e8 e3 fb ff ff       	call   800c85 <getuint>
  8010a2:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010a5:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 8;
  8010a8:	c7 45 ec 08 00 00 00 	movl   $0x8,-0x14(%ebp)
            goto number;
  8010af:	eb 71                	jmp    801122 <vprintfmt+0x3c8>

        // pointer
        case 'p':
            putch('0', putdat, fd);
  8010b1:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010b4:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010b8:	8b 45 10             	mov    0x10(%ebp),%eax
  8010bb:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010bf:	c7 04 24 30 00 00 00 	movl   $0x30,(%esp)
  8010c6:	8b 45 08             	mov    0x8(%ebp),%eax
  8010c9:	ff d0                	call   *%eax
            putch('x', putdat, fd);
  8010cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8010ce:	89 44 24 08          	mov    %eax,0x8(%esp)
  8010d2:	8b 45 10             	mov    0x10(%ebp),%eax
  8010d5:	89 44 24 04          	mov    %eax,0x4(%esp)
  8010d9:	c7 04 24 78 00 00 00 	movl   $0x78,(%esp)
  8010e0:	8b 45 08             	mov    0x8(%ebp),%eax
  8010e3:	ff d0                	call   *%eax
            num = (unsigned long long)(uintptr_t)va_arg(ap, void *);
  8010e5:	8b 45 18             	mov    0x18(%ebp),%eax
  8010e8:	8d 50 04             	lea    0x4(%eax),%edx
  8010eb:	89 55 18             	mov    %edx,0x18(%ebp)
  8010ee:	8b 00                	mov    (%eax),%eax
  8010f0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8010f3:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
            base = 16;
  8010fa:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
            goto number;
  801101:	eb 1f                	jmp    801122 <vprintfmt+0x3c8>

        // (unsigned) hexadecimal
        case 'x':
            num = getuint(&ap, lflag);
  801103:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801106:	89 44 24 04          	mov    %eax,0x4(%esp)
  80110a:	8d 45 18             	lea    0x18(%ebp),%eax
  80110d:	89 04 24             	mov    %eax,(%esp)
  801110:	e8 70 fb ff ff       	call   800c85 <getuint>
  801115:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801118:	89 55 f4             	mov    %edx,-0xc(%ebp)
            base = 16;
  80111b:	c7 45 ec 10 00 00 00 	movl   $0x10,-0x14(%ebp)
        number:
            printnum(putch, fd, putdat, num, base, width, padc);
  801122:	0f be 55 db          	movsbl -0x25(%ebp),%edx
  801126:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801129:	89 54 24 1c          	mov    %edx,0x1c(%esp)
  80112d:	8b 55 e8             	mov    -0x18(%ebp),%edx
  801130:	89 54 24 18          	mov    %edx,0x18(%esp)
  801134:	89 44 24 14          	mov    %eax,0x14(%esp)
  801138:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80113b:	8b 55 f4             	mov    -0xc(%ebp),%edx
  80113e:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801142:	89 54 24 10          	mov    %edx,0x10(%esp)
  801146:	8b 45 10             	mov    0x10(%ebp),%eax
  801149:	89 44 24 08          	mov    %eax,0x8(%esp)
  80114d:	8b 45 0c             	mov    0xc(%ebp),%eax
  801150:	89 44 24 04          	mov    %eax,0x4(%esp)
  801154:	8b 45 08             	mov    0x8(%ebp),%eax
  801157:	89 04 24             	mov    %eax,(%esp)
  80115a:	e8 d9 f9 ff ff       	call   800b38 <printnum>
            break;
  80115f:	eb 4a                	jmp    8011ab <vprintfmt+0x451>

        // escaped '%' character
        case '%':
            putch(ch, putdat, fd);
  801161:	8b 45 0c             	mov    0xc(%ebp),%eax
  801164:	89 44 24 08          	mov    %eax,0x8(%esp)
  801168:	8b 45 10             	mov    0x10(%ebp),%eax
  80116b:	89 44 24 04          	mov    %eax,0x4(%esp)
  80116f:	89 1c 24             	mov    %ebx,(%esp)
  801172:	8b 45 08             	mov    0x8(%ebp),%eax
  801175:	ff d0                	call   *%eax
            break;
  801177:	eb 32                	jmp    8011ab <vprintfmt+0x451>

        // unrecognized escape sequence - just print it literally
        default:
            putch('%', putdat, fd);
  801179:	8b 45 0c             	mov    0xc(%ebp),%eax
  80117c:	89 44 24 08          	mov    %eax,0x8(%esp)
  801180:	8b 45 10             	mov    0x10(%ebp),%eax
  801183:	89 44 24 04          	mov    %eax,0x4(%esp)
  801187:	c7 04 24 25 00 00 00 	movl   $0x25,(%esp)
  80118e:	8b 45 08             	mov    0x8(%ebp),%eax
  801191:	ff d0                	call   *%eax
            for (fmt --; fmt[-1] != '%'; fmt --)
  801193:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
  801197:	eb 04                	jmp    80119d <vprintfmt+0x443>
  801199:	83 6d 14 01          	subl   $0x1,0x14(%ebp)
  80119d:	8b 45 14             	mov    0x14(%ebp),%eax
  8011a0:	83 e8 01             	sub    $0x1,%eax
  8011a3:	0f b6 00             	movzbl (%eax),%eax
  8011a6:	3c 25                	cmp    $0x25,%al
  8011a8:	75 ef                	jne    801199 <vprintfmt+0x43f>
                /* do nothing */;
            break;
  8011aa:	90                   	nop
        }
    }
  8011ab:	90                   	nop
    register int ch, err;
    unsigned long long num;
    int base, width, precision, lflag, altflag;

    while (1) {
        while ((ch = *(unsigned char *)fmt ++) != '%') {
  8011ac:	e9 d1 fb ff ff       	jmp    800d82 <vprintfmt+0x28>
            if (ch == '\0') {
                return;
  8011b1:	90                   	nop
            for (fmt --; fmt[-1] != '%'; fmt --)
                /* do nothing */;
            break;
        }
    }
}
  8011b2:	83 c4 40             	add    $0x40,%esp
  8011b5:	5b                   	pop    %ebx
  8011b6:	5e                   	pop    %esi
  8011b7:	5d                   	pop    %ebp
  8011b8:	c3                   	ret    

008011b9 <sprintputch>:
 * sprintputch - 'print' a single character in a buffer
 * @ch:         the character will be printed
 * @b:          the buffer to place the character @ch
 * */
static void
sprintputch(int ch, struct sprintbuf *b) {
  8011b9:	55                   	push   %ebp
  8011ba:	89 e5                	mov    %esp,%ebp
    b->cnt ++;
  8011bc:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011bf:	8b 40 08             	mov    0x8(%eax),%eax
  8011c2:	8d 50 01             	lea    0x1(%eax),%edx
  8011c5:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011c8:	89 50 08             	mov    %edx,0x8(%eax)
    if (b->buf < b->ebuf) {
  8011cb:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ce:	8b 10                	mov    (%eax),%edx
  8011d0:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011d3:	8b 40 04             	mov    0x4(%eax),%eax
  8011d6:	39 c2                	cmp    %eax,%edx
  8011d8:	73 12                	jae    8011ec <sprintputch+0x33>
        *b->buf ++ = ch;
  8011da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011dd:	8b 00                	mov    (%eax),%eax
  8011df:	8b 55 08             	mov    0x8(%ebp),%edx
  8011e2:	88 10                	mov    %dl,(%eax)
  8011e4:	8d 50 01             	lea    0x1(%eax),%edx
  8011e7:	8b 45 0c             	mov    0xc(%ebp),%eax
  8011ea:	89 10                	mov    %edx,(%eax)
    }
}
  8011ec:	5d                   	pop    %ebp
  8011ed:	c3                   	ret    

008011ee <snprintf>:
 * @str:        the buffer to place the result into
 * @size:       the size of buffer, including the trailing null space
 * @fmt:        the format string to use
 * */
int
snprintf(char *str, size_t size, const char *fmt, ...) {
  8011ee:	55                   	push   %ebp
  8011ef:	89 e5                	mov    %esp,%ebp
  8011f1:	83 ec 28             	sub    $0x28,%esp
    va_list ap;
    int cnt;
    va_start(ap, fmt);
  8011f4:	8d 55 14             	lea    0x14(%ebp),%edx
  8011f7:	8d 45 f0             	lea    -0x10(%ebp),%eax
  8011fa:	89 10                	mov    %edx,(%eax)
    cnt = vsnprintf(str, size, fmt, ap);
  8011fc:	8b 45 f0             	mov    -0x10(%ebp),%eax
  8011ff:	89 44 24 0c          	mov    %eax,0xc(%esp)
  801203:	8b 45 10             	mov    0x10(%ebp),%eax
  801206:	89 44 24 08          	mov    %eax,0x8(%esp)
  80120a:	8b 45 0c             	mov    0xc(%ebp),%eax
  80120d:	89 44 24 04          	mov    %eax,0x4(%esp)
  801211:	8b 45 08             	mov    0x8(%ebp),%eax
  801214:	89 04 24             	mov    %eax,(%esp)
  801217:	e8 08 00 00 00       	call   801224 <vsnprintf>
  80121c:	89 45 f4             	mov    %eax,-0xc(%ebp)
    va_end(ap);
    return cnt;
  80121f:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  801222:	c9                   	leave  
  801223:	c3                   	ret    

00801224 <vsnprintf>:
 *
 * Call this function if you are already dealing with a va_list.
 * Or you probably want snprintf() instead.
 * */
int
vsnprintf(char *str, size_t size, const char *fmt, va_list ap) {
  801224:	55                   	push   %ebp
  801225:	89 e5                	mov    %esp,%ebp
  801227:	83 ec 38             	sub    $0x38,%esp
    struct sprintbuf b = {str, str + size - 1, 0};
  80122a:	8b 45 08             	mov    0x8(%ebp),%eax
  80122d:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801230:	8b 45 0c             	mov    0xc(%ebp),%eax
  801233:	83 e8 01             	sub    $0x1,%eax
  801236:	03 45 08             	add    0x8(%ebp),%eax
  801239:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80123c:	c7 45 f4 00 00 00 00 	movl   $0x0,-0xc(%ebp)
    if (str == NULL || b.buf > b.ebuf) {
  801243:	83 7d 08 00          	cmpl   $0x0,0x8(%ebp)
  801247:	74 0a                	je     801253 <vsnprintf+0x2f>
  801249:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80124c:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80124f:	39 c2                	cmp    %eax,%edx
  801251:	76 07                	jbe    80125a <vsnprintf+0x36>
        return -E_INVAL;
  801253:	b8 fd ff ff ff       	mov    $0xfffffffd,%eax
  801258:	eb 33                	jmp    80128d <vsnprintf+0x69>
    }
    // print the string to the buffer
    vprintfmt((void*)sprintputch, NO_FD, &b, fmt, ap);
  80125a:	b8 b9 11 80 00       	mov    $0x8011b9,%eax
  80125f:	8b 55 14             	mov    0x14(%ebp),%edx
  801262:	89 54 24 10          	mov    %edx,0x10(%esp)
  801266:	8b 55 10             	mov    0x10(%ebp),%edx
  801269:	89 54 24 0c          	mov    %edx,0xc(%esp)
  80126d:	8d 55 ec             	lea    -0x14(%ebp),%edx
  801270:	89 54 24 08          	mov    %edx,0x8(%esp)
  801274:	c7 44 24 04 d9 6a ff 	movl   $0xffff6ad9,0x4(%esp)
  80127b:	ff 
  80127c:	89 04 24             	mov    %eax,(%esp)
  80127f:	e8 d6 fa ff ff       	call   800d5a <vprintfmt>
    // null terminate the buffer
    *b.buf = '\0';
  801284:	8b 45 ec             	mov    -0x14(%ebp),%eax
  801287:	c6 00 00             	movb   $0x0,(%eax)
    return b.cnt;
  80128a:	8b 45 f4             	mov    -0xc(%ebp),%eax
}
  80128d:	c9                   	leave  
  80128e:	c3                   	ret    
	...

00801290 <rand>:
 * rand - returns a pseudo-random integer
 *
 * The rand() function return a value in the range [0, RAND_MAX].
 * */
int
rand(void) {
  801290:	55                   	push   %ebp
  801291:	89 e5                	mov    %esp,%ebp
  801293:	57                   	push   %edi
  801294:	56                   	push   %esi
  801295:	53                   	push   %ebx
  801296:	83 ec 34             	sub    $0x34,%esp
    next = (next * 0x5DEECE66DLL + 0xBLL) & ((1LL << 48) - 1);
  801299:	a1 08 20 80 00       	mov    0x802008,%eax
  80129e:	8b 15 0c 20 80 00    	mov    0x80200c,%edx
  8012a4:	69 fa 6d e6 ec de    	imul   $0xdeece66d,%edx,%edi
  8012aa:	6b c8 05             	imul   $0x5,%eax,%ecx
  8012ad:	01 cf                	add    %ecx,%edi
  8012af:	b9 6d e6 ec de       	mov    $0xdeece66d,%ecx
  8012b4:	f7 e1                	mul    %ecx
  8012b6:	8d 0c 17             	lea    (%edi,%edx,1),%ecx
  8012b9:	89 ca                	mov    %ecx,%edx
  8012bb:	83 c0 0b             	add    $0xb,%eax
  8012be:	83 d2 00             	adc    $0x0,%edx
  8012c1:	89 c3                	mov    %eax,%ebx
  8012c3:	80 e7 ff             	and    $0xff,%bh
  8012c6:	0f b7 f2             	movzwl %dx,%esi
  8012c9:	89 1d 08 20 80 00    	mov    %ebx,0x802008
  8012cf:	89 35 0c 20 80 00    	mov    %esi,0x80200c
    unsigned long long result = (next >> 12);
  8012d5:	a1 08 20 80 00       	mov    0x802008,%eax
  8012da:	8b 15 0c 20 80 00    	mov    0x80200c,%edx
  8012e0:	0f ac d0 0c          	shrd   $0xc,%edx,%eax
  8012e4:	c1 ea 0c             	shr    $0xc,%edx
  8012e7:	89 45 e0             	mov    %eax,-0x20(%ebp)
  8012ea:	89 55 e4             	mov    %edx,-0x1c(%ebp)
    return (int)do_div(result, RAND_MAX + 1);
  8012ed:	c7 45 dc 00 00 00 80 	movl   $0x80000000,-0x24(%ebp)
  8012f4:	8b 45 e0             	mov    -0x20(%ebp),%eax
  8012f7:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  8012fa:	89 45 c8             	mov    %eax,-0x38(%ebp)
  8012fd:	89 55 cc             	mov    %edx,-0x34(%ebp)
  801300:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801303:	8b 55 cc             	mov    -0x34(%ebp),%edx
  801306:	89 d3                	mov    %edx,%ebx
  801308:	89 c6                	mov    %eax,%esi
  80130a:	89 75 d8             	mov    %esi,-0x28(%ebp)
  80130d:	89 5d e8             	mov    %ebx,-0x18(%ebp)
  801310:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801313:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801316:	83 7d e8 00          	cmpl   $0x0,-0x18(%ebp)
  80131a:	74 1c                	je     801338 <rand+0xa8>
  80131c:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80131f:	ba 00 00 00 00       	mov    $0x0,%edx
  801324:	f7 75 dc             	divl   -0x24(%ebp)
  801327:	89 55 ec             	mov    %edx,-0x14(%ebp)
  80132a:	8b 45 e8             	mov    -0x18(%ebp),%eax
  80132d:	ba 00 00 00 00       	mov    $0x0,%edx
  801332:	f7 75 dc             	divl   -0x24(%ebp)
  801335:	89 45 e8             	mov    %eax,-0x18(%ebp)
  801338:	8b 55 d8             	mov    -0x28(%ebp),%edx
  80133b:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80133e:	89 d6                	mov    %edx,%esi
  801340:	89 c3                	mov    %eax,%ebx
  801342:	89 f0                	mov    %esi,%eax
  801344:	89 da                	mov    %ebx,%edx
  801346:	f7 75 dc             	divl   -0x24(%ebp)
  801349:	89 d3                	mov    %edx,%ebx
  80134b:	89 c6                	mov    %eax,%esi
  80134d:	89 75 d8             	mov    %esi,-0x28(%ebp)
  801350:	89 5d d4             	mov    %ebx,-0x2c(%ebp)
  801353:	8b 45 d8             	mov    -0x28(%ebp),%eax
  801356:	89 45 c8             	mov    %eax,-0x38(%ebp)
  801359:	8b 55 e8             	mov    -0x18(%ebp),%edx
  80135c:	89 55 c4             	mov    %edx,-0x3c(%ebp)
  80135f:	8b 45 c8             	mov    -0x38(%ebp),%eax
  801362:	8b 55 c4             	mov    -0x3c(%ebp),%edx
  801365:	89 c3                	mov    %eax,%ebx
  801367:	89 d6                	mov    %edx,%esi
  801369:	89 5d e0             	mov    %ebx,-0x20(%ebp)
  80136c:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  80136f:	8b 45 d4             	mov    -0x2c(%ebp),%eax
}
  801372:	83 c4 34             	add    $0x34,%esp
  801375:	5b                   	pop    %ebx
  801376:	5e                   	pop    %esi
  801377:	5f                   	pop    %edi
  801378:	5d                   	pop    %ebp
  801379:	c3                   	ret    

0080137a <srand>:
/* *
 * srand - seed the random number generator with the given number
 * @seed:   the required seed number
 * */
void
srand(unsigned int seed) {
  80137a:	55                   	push   %ebp
  80137b:	89 e5                	mov    %esp,%ebp
    next = seed;
  80137d:	8b 45 08             	mov    0x8(%ebp),%eax
  801380:	ba 00 00 00 00       	mov    $0x0,%edx
  801385:	a3 08 20 80 00       	mov    %eax,0x802008
  80138a:	89 15 0c 20 80 00    	mov    %edx,0x80200c
}
  801390:	5d                   	pop    %ebp
  801391:	c3                   	ret    
	...

00801394 <strlen>:
 * @s:      the input string
 *
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
  801394:	55                   	push   %ebp
  801395:	89 e5                	mov    %esp,%ebp
  801397:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  80139a:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (*s ++ != '\0') {
  8013a1:	eb 04                	jmp    8013a7 <strlen+0x13>
        cnt ++;
  8013a3:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * The strlen() function returns the length of string @s.
 * */
size_t
strlen(const char *s) {
    size_t cnt = 0;
    while (*s ++ != '\0') {
  8013a7:	8b 45 08             	mov    0x8(%ebp),%eax
  8013aa:	0f b6 00             	movzbl (%eax),%eax
  8013ad:	84 c0                	test   %al,%al
  8013af:	0f 95 c0             	setne  %al
  8013b2:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8013b6:	84 c0                	test   %al,%al
  8013b8:	75 e9                	jne    8013a3 <strlen+0xf>
        cnt ++;
    }
    return cnt;
  8013ba:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013bd:	c9                   	leave  
  8013be:	c3                   	ret    

008013bf <strnlen>:
 * The return value is strlen(s), if that is less than @len, or
 * @len if there is no '\0' character among the first @len characters
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
  8013bf:	55                   	push   %ebp
  8013c0:	89 e5                	mov    %esp,%ebp
  8013c2:	83 ec 10             	sub    $0x10,%esp
    size_t cnt = 0;
  8013c5:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    while (cnt < len && *s ++ != '\0') {
  8013cc:	eb 04                	jmp    8013d2 <strnlen+0x13>
        cnt ++;
  8013ce:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
 * pointed by @s.
 * */
size_t
strnlen(const char *s, size_t len) {
    size_t cnt = 0;
    while (cnt < len && *s ++ != '\0') {
  8013d2:	8b 45 fc             	mov    -0x4(%ebp),%eax
  8013d5:	3b 45 0c             	cmp    0xc(%ebp),%eax
  8013d8:	73 13                	jae    8013ed <strnlen+0x2e>
  8013da:	8b 45 08             	mov    0x8(%ebp),%eax
  8013dd:	0f b6 00             	movzbl (%eax),%eax
  8013e0:	84 c0                	test   %al,%al
  8013e2:	0f 95 c0             	setne  %al
  8013e5:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8013e9:	84 c0                	test   %al,%al
  8013eb:	75 e1                	jne    8013ce <strnlen+0xf>
        cnt ++;
    }
    return cnt;
  8013ed:	8b 45 fc             	mov    -0x4(%ebp),%eax
}
  8013f0:	c9                   	leave  
  8013f1:	c3                   	ret    

008013f2 <strcat>:
 * @dst:    pointer to the @dst array, which should be large enough to contain the concatenated
 *          resulting string.
 * @src:    string to be appended, this should not overlap @dst
 * */
char *
strcat(char *dst, const char *src) {
  8013f2:	55                   	push   %ebp
  8013f3:	89 e5                	mov    %esp,%ebp
  8013f5:	83 ec 18             	sub    $0x18,%esp
    return strcpy(dst + strlen(dst), src);
  8013f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8013fb:	89 04 24             	mov    %eax,(%esp)
  8013fe:	e8 91 ff ff ff       	call   801394 <strlen>
  801403:	03 45 08             	add    0x8(%ebp),%eax
  801406:	8b 55 0c             	mov    0xc(%ebp),%edx
  801409:	89 54 24 04          	mov    %edx,0x4(%esp)
  80140d:	89 04 24             	mov    %eax,(%esp)
  801410:	e8 02 00 00 00       	call   801417 <strcpy>
}
  801415:	c9                   	leave  
  801416:	c3                   	ret    

00801417 <strcpy>:
 * To avoid overflows, the size of array pointed by @dst should be long enough to
 * contain the same string as @src (including the terminating null character), and
 * should not overlap in memory with @src.
 * */
char *
strcpy(char *dst, const char *src) {
  801417:	55                   	push   %ebp
  801418:	89 e5                	mov    %esp,%ebp
  80141a:	57                   	push   %edi
  80141b:	56                   	push   %esi
  80141c:	53                   	push   %ebx
  80141d:	83 ec 24             	sub    $0x24,%esp
  801420:	8b 45 08             	mov    0x8(%ebp),%eax
  801423:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801426:	8b 45 0c             	mov    0xc(%ebp),%eax
  801429:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCPY
#define __HAVE_ARCH_STRCPY
static inline char *
__strcpy(char *dst, const char *src) {
    int d0, d1, d2;
    asm volatile (
  80142c:	8b 55 ec             	mov    -0x14(%ebp),%edx
  80142f:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801432:	89 d6                	mov    %edx,%esi
  801434:	89 c3                	mov    %eax,%ebx
  801436:	89 df                	mov    %ebx,%edi
  801438:	ac                   	lods   %ds:(%esi),%al
  801439:	aa                   	stos   %al,%es:(%edi)
  80143a:	84 c0                	test   %al,%al
  80143c:	75 fa                	jne    801438 <strcpy+0x21>
  80143e:	89 45 d0             	mov    %eax,-0x30(%ebp)
  801441:	89 fb                	mov    %edi,%ebx
  801443:	89 75 e8             	mov    %esi,-0x18(%ebp)
  801446:	89 5d e4             	mov    %ebx,-0x1c(%ebp)
  801449:	8b 45 d0             	mov    -0x30(%ebp),%eax
  80144c:	89 45 e0             	mov    %eax,-0x20(%ebp)
        "stosb;"
        "testb %%al, %%al;"
        "jne 1b;"
        : "=&S" (d0), "=&D" (d1), "=&a" (d2)
        : "0" (src), "1" (dst) : "memory");
    return dst;
  80144f:	8b 45 f0             	mov    -0x10(%ebp),%eax
    char *p = dst;
    while ((*p ++ = *src ++) != '\0')
        /* nothing */;
    return dst;
#endif /* __HAVE_ARCH_STRCPY */
}
  801452:	83 c4 24             	add    $0x24,%esp
  801455:	5b                   	pop    %ebx
  801456:	5e                   	pop    %esi
  801457:	5f                   	pop    %edi
  801458:	5d                   	pop    %ebp
  801459:	c3                   	ret    

0080145a <strncpy>:
 * @len:    maximum number of characters to be copied from @src
 *
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
  80145a:	55                   	push   %ebp
  80145b:	89 e5                	mov    %esp,%ebp
  80145d:	83 ec 10             	sub    $0x10,%esp
    char *p = dst;
  801460:	8b 45 08             	mov    0x8(%ebp),%eax
  801463:	89 45 fc             	mov    %eax,-0x4(%ebp)
    while (len > 0) {
  801466:	eb 21                	jmp    801489 <strncpy+0x2f>
        if ((*p = *src) != '\0') {
  801468:	8b 45 0c             	mov    0xc(%ebp),%eax
  80146b:	0f b6 10             	movzbl (%eax),%edx
  80146e:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801471:	88 10                	mov    %dl,(%eax)
  801473:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801476:	0f b6 00             	movzbl (%eax),%eax
  801479:	84 c0                	test   %al,%al
  80147b:	74 04                	je     801481 <strncpy+0x27>
            src ++;
  80147d:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
        }
        p ++, len --;
  801481:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801485:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
 * The return value is @dst
 * */
char *
strncpy(char *dst, const char *src, size_t len) {
    char *p = dst;
    while (len > 0) {
  801489:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80148d:	75 d9                	jne    801468 <strncpy+0xe>
        if ((*p = *src) != '\0') {
            src ++;
        }
        p ++, len --;
    }
    return dst;
  80148f:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801492:	c9                   	leave  
  801493:	c3                   	ret    

00801494 <strcmp>:
 * - A value greater than zero indicates that the first character that does
 *   not match has a greater value in @s1 than in @s2;
 * - And a value less than zero indicates the opposite.
 * */
int
strcmp(const char *s1, const char *s2) {
  801494:	55                   	push   %ebp
  801495:	89 e5                	mov    %esp,%ebp
  801497:	57                   	push   %edi
  801498:	56                   	push   %esi
  801499:	53                   	push   %ebx
  80149a:	83 ec 24             	sub    $0x24,%esp
  80149d:	8b 45 08             	mov    0x8(%ebp),%eax
  8014a0:	89 45 f0             	mov    %eax,-0x10(%ebp)
  8014a3:	8b 45 0c             	mov    0xc(%ebp),%eax
  8014a6:	89 45 ec             	mov    %eax,-0x14(%ebp)
#ifndef __HAVE_ARCH_STRCMP
#define __HAVE_ARCH_STRCMP
static inline int
__strcmp(const char *s1, const char *s2) {
    int d0, d1, ret;
    asm volatile (
  8014a9:	8b 55 f0             	mov    -0x10(%ebp),%edx
  8014ac:	8b 45 ec             	mov    -0x14(%ebp),%eax
  8014af:	89 d6                	mov    %edx,%esi
  8014b1:	89 c3                	mov    %eax,%ebx
  8014b3:	89 df                	mov    %ebx,%edi
  8014b5:	ac                   	lods   %ds:(%esi),%al
  8014b6:	ae                   	scas   %es:(%edi),%al
  8014b7:	75 08                	jne    8014c1 <strcmp+0x2d>
  8014b9:	84 c0                	test   %al,%al
  8014bb:	75 f8                	jne    8014b5 <strcmp+0x21>
  8014bd:	31 c0                	xor    %eax,%eax
  8014bf:	eb 04                	jmp    8014c5 <strcmp+0x31>
  8014c1:	19 c0                	sbb    %eax,%eax
  8014c3:	0c 01                	or     $0x1,%al
  8014c5:	89 fb                	mov    %edi,%ebx
  8014c7:	89 45 d0             	mov    %eax,-0x30(%ebp)
  8014ca:	8b 45 d0             	mov    -0x30(%ebp),%eax
  8014cd:	89 45 e8             	mov    %eax,-0x18(%ebp)
  8014d0:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  8014d3:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "orb $1, %%al;"
        "3:"
        : "=a" (ret), "=&S" (d0), "=&D" (d1)
        : "1" (s1), "2" (s2)
        : "memory");
    return ret;
  8014d6:	8b 45 e8             	mov    -0x18(%ebp),%eax
    while (*s1 != '\0' && *s1 == *s2) {
        s1 ++, s2 ++;
    }
    return (int)((unsigned char)*s1 - (unsigned char)*s2);
#endif /* __HAVE_ARCH_STRCMP */
}
  8014d9:	83 c4 24             	add    $0x24,%esp
  8014dc:	5b                   	pop    %ebx
  8014dd:	5e                   	pop    %esi
  8014de:	5f                   	pop    %edi
  8014df:	5d                   	pop    %ebp
  8014e0:	c3                   	ret    

008014e1 <strncmp>:
 * they are equal to each other, it continues with the following pairs until
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
  8014e1:	55                   	push   %ebp
  8014e2:	89 e5                	mov    %esp,%ebp
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  8014e4:	eb 0c                	jmp    8014f2 <strncmp+0x11>
        n --, s1 ++, s2 ++;
  8014e6:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8014ea:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8014ee:	83 45 0c 01          	addl   $0x1,0xc(%ebp)
 * the characters differ, until a terminating null-character is reached, or
 * until @n characters match in both strings, whichever happens first.
 * */
int
strncmp(const char *s1, const char *s2, size_t n) {
    while (n > 0 && *s1 != '\0' && *s1 == *s2) {
  8014f2:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8014f6:	74 1a                	je     801512 <strncmp+0x31>
  8014f8:	8b 45 08             	mov    0x8(%ebp),%eax
  8014fb:	0f b6 00             	movzbl (%eax),%eax
  8014fe:	84 c0                	test   %al,%al
  801500:	74 10                	je     801512 <strncmp+0x31>
  801502:	8b 45 08             	mov    0x8(%ebp),%eax
  801505:	0f b6 10             	movzbl (%eax),%edx
  801508:	8b 45 0c             	mov    0xc(%ebp),%eax
  80150b:	0f b6 00             	movzbl (%eax),%eax
  80150e:	38 c2                	cmp    %al,%dl
  801510:	74 d4                	je     8014e6 <strncmp+0x5>
        n --, s1 ++, s2 ++;
    }
    return (n == 0) ? 0 : (int)((unsigned char)*s1 - (unsigned char)*s2);
  801512:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801516:	74 1a                	je     801532 <strncmp+0x51>
  801518:	8b 45 08             	mov    0x8(%ebp),%eax
  80151b:	0f b6 00             	movzbl (%eax),%eax
  80151e:	0f b6 d0             	movzbl %al,%edx
  801521:	8b 45 0c             	mov    0xc(%ebp),%eax
  801524:	0f b6 00             	movzbl (%eax),%eax
  801527:	0f b6 c0             	movzbl %al,%eax
  80152a:	89 d1                	mov    %edx,%ecx
  80152c:	29 c1                	sub    %eax,%ecx
  80152e:	89 c8                	mov    %ecx,%eax
  801530:	eb 05                	jmp    801537 <strncmp+0x56>
  801532:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801537:	5d                   	pop    %ebp
  801538:	c3                   	ret    

00801539 <strchr>:
 *
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
  801539:	55                   	push   %ebp
  80153a:	89 e5                	mov    %esp,%ebp
  80153c:	83 ec 04             	sub    $0x4,%esp
  80153f:	8b 45 0c             	mov    0xc(%ebp),%eax
  801542:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  801545:	eb 14                	jmp    80155b <strchr+0x22>
        if (*s == c) {
  801547:	8b 45 08             	mov    0x8(%ebp),%eax
  80154a:	0f b6 00             	movzbl (%eax),%eax
  80154d:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801550:	75 05                	jne    801557 <strchr+0x1e>
            return (char *)s;
  801552:	8b 45 08             	mov    0x8(%ebp),%eax
  801555:	eb 13                	jmp    80156a <strchr+0x31>
        }
        s ++;
  801557:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * The strchr() function returns a pointer to the first occurrence of
 * character in @s. If the value is not found, the function returns 'NULL'.
 * */
char *
strchr(const char *s, char c) {
    while (*s != '\0') {
  80155b:	8b 45 08             	mov    0x8(%ebp),%eax
  80155e:	0f b6 00             	movzbl (%eax),%eax
  801561:	84 c0                	test   %al,%al
  801563:	75 e2                	jne    801547 <strchr+0xe>
        if (*s == c) {
            return (char *)s;
        }
        s ++;
    }
    return NULL;
  801565:	b8 00 00 00 00       	mov    $0x0,%eax
}
  80156a:	c9                   	leave  
  80156b:	c3                   	ret    

0080156c <strfind>:
 * The strfind() function is like strchr() except that if @c is
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
  80156c:	55                   	push   %ebp
  80156d:	89 e5                	mov    %esp,%ebp
  80156f:	83 ec 04             	sub    $0x4,%esp
  801572:	8b 45 0c             	mov    0xc(%ebp),%eax
  801575:	88 45 fc             	mov    %al,-0x4(%ebp)
    while (*s != '\0') {
  801578:	eb 0f                	jmp    801589 <strfind+0x1d>
        if (*s == c) {
  80157a:	8b 45 08             	mov    0x8(%ebp),%eax
  80157d:	0f b6 00             	movzbl (%eax),%eax
  801580:	3a 45 fc             	cmp    -0x4(%ebp),%al
  801583:	74 10                	je     801595 <strfind+0x29>
            break;
        }
        s ++;
  801585:	83 45 08 01          	addl   $0x1,0x8(%ebp)
 * not found in @s, then it returns a pointer to the null byte at the
 * end of @s, rather than 'NULL'.
 * */
char *
strfind(const char *s, char c) {
    while (*s != '\0') {
  801589:	8b 45 08             	mov    0x8(%ebp),%eax
  80158c:	0f b6 00             	movzbl (%eax),%eax
  80158f:	84 c0                	test   %al,%al
  801591:	75 e7                	jne    80157a <strfind+0xe>
  801593:	eb 01                	jmp    801596 <strfind+0x2a>
        if (*s == c) {
            break;
  801595:	90                   	nop
        }
        s ++;
    }
    return (char *)s;
  801596:	8b 45 08             	mov    0x8(%ebp),%eax
}
  801599:	c9                   	leave  
  80159a:	c3                   	ret    

0080159b <strtol>:
 * an optional "0x" or "0X" prefix.
 *
 * The strtol() function returns the converted integral number as a long int value.
 * */
long
strtol(const char *s, char **endptr, int base) {
  80159b:	55                   	push   %ebp
  80159c:	89 e5                	mov    %esp,%ebp
  80159e:	83 ec 10             	sub    $0x10,%esp
    int neg = 0;
  8015a1:	c7 45 fc 00 00 00 00 	movl   $0x0,-0x4(%ebp)
    long val = 0;
  8015a8:	c7 45 f8 00 00 00 00 	movl   $0x0,-0x8(%ebp)

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  8015af:	eb 04                	jmp    8015b5 <strtol+0x1a>
        s ++;
  8015b1:	83 45 08 01          	addl   $0x1,0x8(%ebp)
strtol(const char *s, char **endptr, int base) {
    int neg = 0;
    long val = 0;

    // gobble initial whitespace
    while (*s == ' ' || *s == '\t') {
  8015b5:	8b 45 08             	mov    0x8(%ebp),%eax
  8015b8:	0f b6 00             	movzbl (%eax),%eax
  8015bb:	3c 20                	cmp    $0x20,%al
  8015bd:	74 f2                	je     8015b1 <strtol+0x16>
  8015bf:	8b 45 08             	mov    0x8(%ebp),%eax
  8015c2:	0f b6 00             	movzbl (%eax),%eax
  8015c5:	3c 09                	cmp    $0x9,%al
  8015c7:	74 e8                	je     8015b1 <strtol+0x16>
        s ++;
    }

    // plus/minus sign
    if (*s == '+') {
  8015c9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015cc:	0f b6 00             	movzbl (%eax),%eax
  8015cf:	3c 2b                	cmp    $0x2b,%al
  8015d1:	75 06                	jne    8015d9 <strtol+0x3e>
        s ++;
  8015d3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8015d7:	eb 15                	jmp    8015ee <strtol+0x53>
    }
    else if (*s == '-') {
  8015d9:	8b 45 08             	mov    0x8(%ebp),%eax
  8015dc:	0f b6 00             	movzbl (%eax),%eax
  8015df:	3c 2d                	cmp    $0x2d,%al
  8015e1:	75 0b                	jne    8015ee <strtol+0x53>
        s ++, neg = 1;
  8015e3:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8015e7:	c7 45 fc 01 00 00 00 	movl   $0x1,-0x4(%ebp)
    }

    // hex or octal base prefix
    if ((base == 0 || base == 16) && (s[0] == '0' && s[1] == 'x')) {
  8015ee:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  8015f2:	74 06                	je     8015fa <strtol+0x5f>
  8015f4:	83 7d 10 10          	cmpl   $0x10,0x10(%ebp)
  8015f8:	75 24                	jne    80161e <strtol+0x83>
  8015fa:	8b 45 08             	mov    0x8(%ebp),%eax
  8015fd:	0f b6 00             	movzbl (%eax),%eax
  801600:	3c 30                	cmp    $0x30,%al
  801602:	75 1a                	jne    80161e <strtol+0x83>
  801604:	8b 45 08             	mov    0x8(%ebp),%eax
  801607:	83 c0 01             	add    $0x1,%eax
  80160a:	0f b6 00             	movzbl (%eax),%eax
  80160d:	3c 78                	cmp    $0x78,%al
  80160f:	75 0d                	jne    80161e <strtol+0x83>
        s += 2, base = 16;
  801611:	83 45 08 02          	addl   $0x2,0x8(%ebp)
  801615:	c7 45 10 10 00 00 00 	movl   $0x10,0x10(%ebp)
  80161c:	eb 2a                	jmp    801648 <strtol+0xad>
    }
    else if (base == 0 && s[0] == '0') {
  80161e:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  801622:	75 17                	jne    80163b <strtol+0xa0>
  801624:	8b 45 08             	mov    0x8(%ebp),%eax
  801627:	0f b6 00             	movzbl (%eax),%eax
  80162a:	3c 30                	cmp    $0x30,%al
  80162c:	75 0d                	jne    80163b <strtol+0xa0>
        s ++, base = 8;
  80162e:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  801632:	c7 45 10 08 00 00 00 	movl   $0x8,0x10(%ebp)
  801639:	eb 0d                	jmp    801648 <strtol+0xad>
    }
    else if (base == 0) {
  80163b:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80163f:	75 07                	jne    801648 <strtol+0xad>
        base = 10;
  801641:	c7 45 10 0a 00 00 00 	movl   $0xa,0x10(%ebp)

    // digits
    while (1) {
        int dig;

        if (*s >= '0' && *s <= '9') {
  801648:	8b 45 08             	mov    0x8(%ebp),%eax
  80164b:	0f b6 00             	movzbl (%eax),%eax
  80164e:	3c 2f                	cmp    $0x2f,%al
  801650:	7e 1b                	jle    80166d <strtol+0xd2>
  801652:	8b 45 08             	mov    0x8(%ebp),%eax
  801655:	0f b6 00             	movzbl (%eax),%eax
  801658:	3c 39                	cmp    $0x39,%al
  80165a:	7f 11                	jg     80166d <strtol+0xd2>
            dig = *s - '0';
  80165c:	8b 45 08             	mov    0x8(%ebp),%eax
  80165f:	0f b6 00             	movzbl (%eax),%eax
  801662:	0f be c0             	movsbl %al,%eax
  801665:	83 e8 30             	sub    $0x30,%eax
  801668:	89 45 f4             	mov    %eax,-0xc(%ebp)
  80166b:	eb 48                	jmp    8016b5 <strtol+0x11a>
        }
        else if (*s >= 'a' && *s <= 'z') {
  80166d:	8b 45 08             	mov    0x8(%ebp),%eax
  801670:	0f b6 00             	movzbl (%eax),%eax
  801673:	3c 60                	cmp    $0x60,%al
  801675:	7e 1b                	jle    801692 <strtol+0xf7>
  801677:	8b 45 08             	mov    0x8(%ebp),%eax
  80167a:	0f b6 00             	movzbl (%eax),%eax
  80167d:	3c 7a                	cmp    $0x7a,%al
  80167f:	7f 11                	jg     801692 <strtol+0xf7>
            dig = *s - 'a' + 10;
  801681:	8b 45 08             	mov    0x8(%ebp),%eax
  801684:	0f b6 00             	movzbl (%eax),%eax
  801687:	0f be c0             	movsbl %al,%eax
  80168a:	83 e8 57             	sub    $0x57,%eax
  80168d:	89 45 f4             	mov    %eax,-0xc(%ebp)
  801690:	eb 23                	jmp    8016b5 <strtol+0x11a>
        }
        else if (*s >= 'A' && *s <= 'Z') {
  801692:	8b 45 08             	mov    0x8(%ebp),%eax
  801695:	0f b6 00             	movzbl (%eax),%eax
  801698:	3c 40                	cmp    $0x40,%al
  80169a:	7e 38                	jle    8016d4 <strtol+0x139>
  80169c:	8b 45 08             	mov    0x8(%ebp),%eax
  80169f:	0f b6 00             	movzbl (%eax),%eax
  8016a2:	3c 5a                	cmp    $0x5a,%al
  8016a4:	7f 2e                	jg     8016d4 <strtol+0x139>
            dig = *s - 'A' + 10;
  8016a6:	8b 45 08             	mov    0x8(%ebp),%eax
  8016a9:	0f b6 00             	movzbl (%eax),%eax
  8016ac:	0f be c0             	movsbl %al,%eax
  8016af:	83 e8 37             	sub    $0x37,%eax
  8016b2:	89 45 f4             	mov    %eax,-0xc(%ebp)
        }
        else {
            break;
        }
        if (dig >= base) {
  8016b5:	8b 45 f4             	mov    -0xc(%ebp),%eax
  8016b8:	3b 45 10             	cmp    0x10(%ebp),%eax
  8016bb:	7d 16                	jge    8016d3 <strtol+0x138>
            break;
        }
        s ++, val = (val * base) + dig;
  8016bd:	83 45 08 01          	addl   $0x1,0x8(%ebp)
  8016c1:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016c4:	0f af 45 10          	imul   0x10(%ebp),%eax
  8016c8:	03 45 f4             	add    -0xc(%ebp),%eax
  8016cb:	89 45 f8             	mov    %eax,-0x8(%ebp)
        // we don't properly detect overflow!
    }
  8016ce:	e9 75 ff ff ff       	jmp    801648 <strtol+0xad>
        }
        else {
            break;
        }
        if (dig >= base) {
            break;
  8016d3:	90                   	nop
        }
        s ++, val = (val * base) + dig;
        // we don't properly detect overflow!
    }

    if (endptr) {
  8016d4:	83 7d 0c 00          	cmpl   $0x0,0xc(%ebp)
  8016d8:	74 08                	je     8016e2 <strtol+0x147>
        *endptr = (char *) s;
  8016da:	8b 45 0c             	mov    0xc(%ebp),%eax
  8016dd:	8b 55 08             	mov    0x8(%ebp),%edx
  8016e0:	89 10                	mov    %edx,(%eax)
    }
    return (neg ? -val : val);
  8016e2:	83 7d fc 00          	cmpl   $0x0,-0x4(%ebp)
  8016e6:	74 07                	je     8016ef <strtol+0x154>
  8016e8:	8b 45 f8             	mov    -0x8(%ebp),%eax
  8016eb:	f7 d8                	neg    %eax
  8016ed:	eb 03                	jmp    8016f2 <strtol+0x157>
  8016ef:	8b 45 f8             	mov    -0x8(%ebp),%eax
}
  8016f2:	c9                   	leave  
  8016f3:	c3                   	ret    

008016f4 <memset>:
 * @n:      number of bytes to be set to the value
 *
 * The memset() function returns @s.
 * */
void *
memset(void *s, char c, size_t n) {
  8016f4:	55                   	push   %ebp
  8016f5:	89 e5                	mov    %esp,%ebp
  8016f7:	57                   	push   %edi
  8016f8:	56                   	push   %esi
  8016f9:	53                   	push   %ebx
  8016fa:	83 ec 24             	sub    $0x24,%esp
  8016fd:	8b 45 0c             	mov    0xc(%ebp),%eax
  801700:	88 45 d0             	mov    %al,-0x30(%ebp)
#ifdef __HAVE_ARCH_MEMSET
    return __memset(s, c, n);
  801703:	0f be 45 d0          	movsbl -0x30(%ebp),%eax
  801707:	8b 55 08             	mov    0x8(%ebp),%edx
  80170a:	89 55 f0             	mov    %edx,-0x10(%ebp)
  80170d:	88 45 ef             	mov    %al,-0x11(%ebp)
  801710:	8b 45 10             	mov    0x10(%ebp),%eax
  801713:	89 45 e8             	mov    %eax,-0x18(%ebp)
#ifndef __HAVE_ARCH_MEMSET
#define __HAVE_ARCH_MEMSET
static inline void *
__memset(void *s, char c, size_t n) {
    int d0, d1;
    asm volatile (
  801716:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  801719:	0f b6 45 ef          	movzbl -0x11(%ebp),%eax
  80171d:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801720:	89 ce                	mov    %ecx,%esi
  801722:	89 d3                	mov    %edx,%ebx
  801724:	89 f1                	mov    %esi,%ecx
  801726:	89 df                	mov    %ebx,%edi
  801728:	f3 aa                	rep stos %al,%es:(%edi)
  80172a:	89 fb                	mov    %edi,%ebx
  80172c:	89 ce                	mov    %ecx,%esi
  80172e:	89 75 e4             	mov    %esi,-0x1c(%ebp)
  801731:	89 5d e0             	mov    %ebx,-0x20(%ebp)
        "rep; stosb;"
        : "=&c" (d0), "=&D" (d1)
        : "0" (n), "a" (c), "1" (s)
        : "memory");
    return s;
  801734:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *p ++ = c;
    }
    return s;
#endif /* __HAVE_ARCH_MEMSET */
}
  801737:	83 c4 24             	add    $0x24,%esp
  80173a:	5b                   	pop    %ebx
  80173b:	5e                   	pop    %esi
  80173c:	5f                   	pop    %edi
  80173d:	5d                   	pop    %ebp
  80173e:	c3                   	ret    

0080173f <memmove>:
 * @n:      number of bytes to copy
 *
 * The memmove() function returns @dst.
 * */
void *
memmove(void *dst, const void *src, size_t n) {
  80173f:	55                   	push   %ebp
  801740:	89 e5                	mov    %esp,%ebp
  801742:	57                   	push   %edi
  801743:	56                   	push   %esi
  801744:	53                   	push   %ebx
  801745:	83 ec 38             	sub    $0x38,%esp
  801748:	8b 45 08             	mov    0x8(%ebp),%eax
  80174b:	89 45 f0             	mov    %eax,-0x10(%ebp)
  80174e:	8b 45 0c             	mov    0xc(%ebp),%eax
  801751:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801754:	8b 45 10             	mov    0x10(%ebp),%eax
  801757:	89 45 e8             	mov    %eax,-0x18(%ebp)

#ifndef __HAVE_ARCH_MEMMOVE
#define __HAVE_ARCH_MEMMOVE
static inline void *
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
  80175a:	8b 45 f0             	mov    -0x10(%ebp),%eax
  80175d:	3b 45 ec             	cmp    -0x14(%ebp),%eax
  801760:	73 4e                	jae    8017b0 <memmove+0x71>
  801762:	8b 45 f0             	mov    -0x10(%ebp),%eax
  801765:	89 45 e4             	mov    %eax,-0x1c(%ebp)
  801768:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80176b:	89 45 e0             	mov    %eax,-0x20(%ebp)
  80176e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801771:	89 45 dc             	mov    %eax,-0x24(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  801774:	8b 45 dc             	mov    -0x24(%ebp),%eax
  801777:	89 c1                	mov    %eax,%ecx
  801779:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  80177c:	8b 55 e4             	mov    -0x1c(%ebp),%edx
  80177f:	8b 45 e0             	mov    -0x20(%ebp),%eax
  801782:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  801785:	89 d7                	mov    %edx,%edi
  801787:	89 c3                	mov    %eax,%ebx
  801789:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  80178c:	89 de                	mov    %ebx,%esi
  80178e:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  801790:	8b 4d dc             	mov    -0x24(%ebp),%ecx
  801793:	83 e1 03             	and    $0x3,%ecx
  801796:	74 02                	je     80179a <memmove+0x5b>
  801798:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  80179a:	89 f3                	mov    %esi,%ebx
  80179c:	89 4d c0             	mov    %ecx,-0x40(%ebp)
  80179f:	8b 4d c0             	mov    -0x40(%ebp),%ecx
  8017a2:	89 4d d8             	mov    %ecx,-0x28(%ebp)
  8017a5:	89 7d d4             	mov    %edi,-0x2c(%ebp)
  8017a8:	89 5d d0             	mov    %ebx,-0x30(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  8017ab:	8b 45 e4             	mov    -0x1c(%ebp),%eax
  8017ae:	eb 3b                	jmp    8017eb <memmove+0xac>
    asm volatile (
        "std;"
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
  8017b0:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017b3:	83 e8 01             	sub    $0x1,%eax
  8017b6:	89 c2                	mov    %eax,%edx
  8017b8:	03 55 ec             	add    -0x14(%ebp),%edx
  8017bb:	8b 45 e8             	mov    -0x18(%ebp),%eax
  8017be:	83 e8 01             	sub    $0x1,%eax
  8017c1:	03 45 f0             	add    -0x10(%ebp),%eax
__memmove(void *dst, const void *src, size_t n) {
    if (dst < src) {
        return __memcpy(dst, src, n);
    }
    int d0, d1, d2;
    asm volatile (
  8017c4:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  8017c7:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  8017ca:	89 d6                	mov    %edx,%esi
  8017cc:	89 c3                	mov    %eax,%ebx
  8017ce:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8017d1:	89 df                	mov    %ebx,%edi
  8017d3:	fd                   	std    
  8017d4:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  8017d6:	fc                   	cld    
  8017d7:	89 fb                	mov    %edi,%ebx
  8017d9:	89 4d bc             	mov    %ecx,-0x44(%ebp)
  8017dc:	8b 4d bc             	mov    -0x44(%ebp),%ecx
  8017df:	89 4d cc             	mov    %ecx,-0x34(%ebp)
  8017e2:	89 75 c8             	mov    %esi,-0x38(%ebp)
  8017e5:	89 5d c4             	mov    %ebx,-0x3c(%ebp)
        "rep; movsb;"
        "cld;"
        : "=&c" (d0), "=&S" (d1), "=&D" (d2)
        : "0" (n), "1" (n - 1 + src), "2" (n - 1 + dst)
        : "memory");
    return dst;
  8017e8:	8b 45 f0             	mov    -0x10(%ebp),%eax
            *d ++ = *s ++;
        }
    }
    return dst;
#endif /* __HAVE_ARCH_MEMMOVE */
}
  8017eb:	83 c4 38             	add    $0x38,%esp
  8017ee:	5b                   	pop    %ebx
  8017ef:	5e                   	pop    %esi
  8017f0:	5f                   	pop    %edi
  8017f1:	5d                   	pop    %ebp
  8017f2:	c3                   	ret    

008017f3 <memcpy>:
 * it always copies exactly @n bytes. To avoid overflows, the size of arrays pointed
 * by both @src and @dst, should be at least @n bytes, and should not overlap
 * (for overlapping memory area, memmove is a safer approach).
 * */
void *
memcpy(void *dst, const void *src, size_t n) {
  8017f3:	55                   	push   %ebp
  8017f4:	89 e5                	mov    %esp,%ebp
  8017f6:	57                   	push   %edi
  8017f7:	56                   	push   %esi
  8017f8:	53                   	push   %ebx
  8017f9:	83 ec 24             	sub    $0x24,%esp
  8017fc:	8b 45 08             	mov    0x8(%ebp),%eax
  8017ff:	89 45 f0             	mov    %eax,-0x10(%ebp)
  801802:	8b 45 0c             	mov    0xc(%ebp),%eax
  801805:	89 45 ec             	mov    %eax,-0x14(%ebp)
  801808:	8b 45 10             	mov    0x10(%ebp),%eax
  80180b:	89 45 e8             	mov    %eax,-0x18(%ebp)
        "andl $3, %%ecx;"
        "jz 1f;"
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
  80180e:	8b 45 e8             	mov    -0x18(%ebp),%eax
  801811:	89 c1                	mov    %eax,%ecx
  801813:	c1 e9 02             	shr    $0x2,%ecx
#ifndef __HAVE_ARCH_MEMCPY
#define __HAVE_ARCH_MEMCPY
static inline void *
__memcpy(void *dst, const void *src, size_t n) {
    int d0, d1, d2;
    asm volatile (
  801816:	8b 55 f0             	mov    -0x10(%ebp),%edx
  801819:	8b 45 ec             	mov    -0x14(%ebp),%eax
  80181c:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  80181f:	89 d7                	mov    %edx,%edi
  801821:	89 c3                	mov    %eax,%ebx
  801823:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  801826:	89 de                	mov    %ebx,%esi
  801828:	f3 a5                	rep movsl %ds:(%esi),%es:(%edi)
  80182a:	8b 4d e8             	mov    -0x18(%ebp),%ecx
  80182d:	83 e1 03             	and    $0x3,%ecx
  801830:	74 02                	je     801834 <memcpy+0x41>
  801832:	f3 a4                	rep movsb %ds:(%esi),%es:(%edi)
  801834:	89 f3                	mov    %esi,%ebx
  801836:	89 4d d0             	mov    %ecx,-0x30(%ebp)
  801839:	8b 4d d0             	mov    -0x30(%ebp),%ecx
  80183c:	89 4d e4             	mov    %ecx,-0x1c(%ebp)
  80183f:	89 7d e0             	mov    %edi,-0x20(%ebp)
  801842:	89 5d dc             	mov    %ebx,-0x24(%ebp)
        "rep; movsb;"
        "1:"
        : "=&c" (d0), "=&D" (d1), "=&S" (d2)
        : "0" (n / 4), "g" (n), "1" (dst), "2" (src)
        : "memory");
    return dst;
  801845:	8b 45 f0             	mov    -0x10(%ebp),%eax
    while (n -- > 0) {
        *d ++ = *s ++;
    }
    return dst;
#endif /* __HAVE_ARCH_MEMCPY */
}
  801848:	83 c4 24             	add    $0x24,%esp
  80184b:	5b                   	pop    %ebx
  80184c:	5e                   	pop    %esi
  80184d:	5f                   	pop    %edi
  80184e:	5d                   	pop    %ebp
  80184f:	c3                   	ret    

00801850 <memcmp>:
 *   match in both memory blocks has a greater value in @v1 than in @v2
 *   as if evaluated as unsigned char values;
 * - And a value less than zero indicates the opposite.
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
  801850:	55                   	push   %ebp
  801851:	89 e5                	mov    %esp,%ebp
  801853:	83 ec 10             	sub    $0x10,%esp
    const char *s1 = (const char *)v1;
  801856:	8b 45 08             	mov    0x8(%ebp),%eax
  801859:	89 45 fc             	mov    %eax,-0x4(%ebp)
    const char *s2 = (const char *)v2;
  80185c:	8b 45 0c             	mov    0xc(%ebp),%eax
  80185f:	89 45 f8             	mov    %eax,-0x8(%ebp)
    while (n -- > 0) {
  801862:	eb 32                	jmp    801896 <memcmp+0x46>
        if (*s1 != *s2) {
  801864:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801867:	0f b6 10             	movzbl (%eax),%edx
  80186a:	8b 45 f8             	mov    -0x8(%ebp),%eax
  80186d:	0f b6 00             	movzbl (%eax),%eax
  801870:	38 c2                	cmp    %al,%dl
  801872:	74 1a                	je     80188e <memcmp+0x3e>
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
  801874:	8b 45 fc             	mov    -0x4(%ebp),%eax
  801877:	0f b6 00             	movzbl (%eax),%eax
  80187a:	0f b6 d0             	movzbl %al,%edx
  80187d:	8b 45 f8             	mov    -0x8(%ebp),%eax
  801880:	0f b6 00             	movzbl (%eax),%eax
  801883:	0f b6 c0             	movzbl %al,%eax
  801886:	89 d1                	mov    %edx,%ecx
  801888:	29 c1                	sub    %eax,%ecx
  80188a:	89 c8                	mov    %ecx,%eax
  80188c:	eb 1c                	jmp    8018aa <memcmp+0x5a>
        }
        s1 ++, s2 ++;
  80188e:	83 45 fc 01          	addl   $0x1,-0x4(%ebp)
  801892:	83 45 f8 01          	addl   $0x1,-0x8(%ebp)
 * */
int
memcmp(const void *v1, const void *v2, size_t n) {
    const char *s1 = (const char *)v1;
    const char *s2 = (const char *)v2;
    while (n -- > 0) {
  801896:	83 7d 10 00          	cmpl   $0x0,0x10(%ebp)
  80189a:	0f 95 c0             	setne  %al
  80189d:	83 6d 10 01          	subl   $0x1,0x10(%ebp)
  8018a1:	84 c0                	test   %al,%al
  8018a3:	75 bf                	jne    801864 <memcmp+0x14>
        if (*s1 != *s2) {
            return (int)((unsigned char)*s1 - (unsigned char)*s2);
        }
        s1 ++, s2 ++;
    }
    return 0;
  8018a5:	b8 00 00 00 00       	mov    $0x0,%eax
}
  8018aa:	c9                   	leave  
  8018ab:	c3                   	ret    

008018ac <main>:
#include <ulib.h>
#include <stdio.h>

int
main(void) {
  8018ac:	55                   	push   %ebp
  8018ad:	89 e5                	mov    %esp,%ebp
  8018af:	83 e4 f0             	and    $0xfffffff0,%esp
  8018b2:	83 ec 20             	sub    $0x20,%esp
    int i;
    cprintf("Hello, I am process %d.\n", getpid());
  8018b5:	e8 b3 f0 ff ff       	call   80096d <getpid>
  8018ba:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018be:	c7 04 24 c0 1d 80 00 	movl   $0x801dc0,(%esp)
  8018c5:	e8 1a eb ff ff       	call   8003e4 <cprintf>
    for (i = 0; i < 5; i ++) {
  8018ca:	c7 44 24 1c 00 00 00 	movl   $0x0,0x1c(%esp)
  8018d1:	00 
  8018d2:	eb 27                	jmp    8018fb <main+0x4f>
        yield();
  8018d4:	e8 74 f0 ff ff       	call   80094d <yield>
        cprintf("Back in process %d, iteration %d.\n", getpid(), i);
  8018d9:	e8 8f f0 ff ff       	call   80096d <getpid>
  8018de:	8b 54 24 1c          	mov    0x1c(%esp),%edx
  8018e2:	89 54 24 08          	mov    %edx,0x8(%esp)
  8018e6:	89 44 24 04          	mov    %eax,0x4(%esp)
  8018ea:	c7 04 24 dc 1d 80 00 	movl   $0x801ddc,(%esp)
  8018f1:	e8 ee ea ff ff       	call   8003e4 <cprintf>

int
main(void) {
    int i;
    cprintf("Hello, I am process %d.\n", getpid());
    for (i = 0; i < 5; i ++) {
  8018f6:	83 44 24 1c 01       	addl   $0x1,0x1c(%esp)
  8018fb:	83 7c 24 1c 04       	cmpl   $0x4,0x1c(%esp)
  801900:	7e d2                	jle    8018d4 <main+0x28>
        yield();
        cprintf("Back in process %d, iteration %d.\n", getpid(), i);
    }
    cprintf("All done in process %d.\n", getpid());
  801902:	e8 66 f0 ff ff       	call   80096d <getpid>
  801907:	89 44 24 04          	mov    %eax,0x4(%esp)
  80190b:	c7 04 24 ff 1d 80 00 	movl   $0x801dff,(%esp)
  801912:	e8 cd ea ff ff       	call   8003e4 <cprintf>
    cprintf("yield pass.\n");
  801917:	c7 04 24 18 1e 80 00 	movl   $0x801e18,(%esp)
  80191e:	e8 c1 ea ff ff       	call   8003e4 <cprintf>
    return 0;
  801923:	b8 00 00 00 00       	mov    $0x0,%eax
}
  801928:	c9                   	leave  
  801929:	c3                   	ret    
