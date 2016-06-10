#Lab2实验报告

计23班 杨煜 2011010312

##练习0:填写已有实验
使用diffmerge工具进行代码比对，并将Lab1中的实验代码填写在Lab2指定的位置上。

##练习1:实现first-fit连续物理内存分配算法
###设计实现过程
仔细阅读了default\_pmm.c的注释，了解了其代码实现的思路。我们可以只存储每块空闲内存第一页，然后修正free\_list中内存块顺序的执行方式，使得default\_free\_pages中合并空闲块等操作能够正常执行。
###改进空间
就内存分配算法而言，有比first-fit本身更好的算法，比如buddy\_system
###与所给答案的差别
答案中的free_list存储每一块空闲内存的所有页，我实现中仅存储了每块内容的第一页，效率比所给答案中的要高。

##练习2:实现寻找虚拟地址对应的页表项
###设计实现过程
使用memset等内存访问函数用的是内核虚地址kernel virtual address

###PDE和PTE各个组成部分的含义和以及对ucore而言的潜在用处
除前20位为地址位之外，其余各位的定义可以在mmu.h中找到。

```
/* page table/directory entry flags */#define PTE_P           0x001                   // Present  存在位#define PTE_W           0x002                   // Writeable 可写位#define PTE_U           0x004                   // User 访问所需特权级#define PTE_PWT         0x008                   // Write-Through #define PTE_PCD         0x010                   // Cache-Disable#define PTE_A           0x020                   // Accessed 已访问位#define PTE_D           0x040                   // Dirty 已修改位#define PTE_PS          0x080                   // Page Size#define PTE_MBZ         0x180                   // Bits must be zero#define PTE_AVAIL       0xE00                   // Available for software use                                                // The PTE_AVAIL bits aren't used by the kernel or interpreted by the                                                // hardware, so user processes are allowed to set them arbitrarily.
```

###ucore执行过程中访存出现页访问异常
硬件保存状态信息，禁止中断，进行异常处理。
##练习3:释放某虚地址所在的页并取消对应二级页表项的映射

###设计实现过程
首先判断这个要移除的页是否存在，若存在则进行下一步的操作，找到这个页的映射项，将其页引用次数减1；若此时这个页引用次数下降到0，就释放该页，与此同时要对tlb进行修改。

###回答问题：数据结构Page的全局变量（其实是一个数组）的每一项与页表中的页目录项和页表项有无对应关系？如果有，其对应关系是啥？
我认为有对应关系，在分配page和释放page时，均和页目录项、页表项有对应关系。

##总结：
本次Lab对应的知识点为：
内存分配算法 －－练习一
页表项结构   －－练习二
TLB控制     －－练习三

