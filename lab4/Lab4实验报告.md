#Lab4实验报告
计23班 杨煜 2011010312

##练习0：填写已有实验
根据要求完成了Lab1，Lab2，Lab3实验中修改部分的填写

##练习1：分配并初始化一个进程控制块
###设计实现过程
按照proc_struct的初始定义将其中的每一项都进行初始化，其中state，pid，cr3这三项具有要求的初始取值，应按照其要求的初始取值进行初始化。

###请说明proc_struct中struct context context和struct trapframe *tf成员变量含义和在本实验中的作用
context的作用是为内核线程切换所准备的上下文，其中只要存各个内核线程间不一样的部分。ucorelab实验中context用来存储进程切换信息，在proc\_run中出现，和switch\_to搭配使用完成从idleproc到initproc的切换。

tf是每个线程都有的中断帧，在内核栈的顶端；每发生中断时存储相关信息，再执行中断处理历程时使用。ucorelab实验中do\_fork函数的参数，设置了新的内核线程的中断帧，传递了要建立的新的内核的线程信息。

##练习2：为新创建的内核线程分配资源
###设计实现过程
按照注释的说明完成了do\_fork函数的实现，同时填充了proc->pid、proc->parent、nr\_process、proc\_list；先调用了get\_pid以在hash\_proc中发挥作用。

###与标准答案的差别
部分扩大了禁止中断的保护范围。

###请说明ucore是否做到给每个新fork的线程一个唯一的id
不能做到。只有每一个在proc\_list中的线程才有唯一的id；每一个新fork的线程可能分配到曾被使用过但是现在已经是释放状态的pid。get\_pid函数中维护了两个静态变量，last
\_pid为上次分配的pid，next\_safe是经维护的当前进程链表中大于last\_pid的最小的pid，这样从last_pid到next\_safe之间的pid均可以使用。

##练习3：阅读代码，理解 proc_run 函数和它调用的函数如何完成进程切换的

###对proc_run函数的分析
proc\_run函数先切换了内核栈和页表，之后调用switch\_to函数加载context以完成进程切换。

###在本实验的执行过程中，创建且运行了几个内核线程？2个，idleproc和initproc，其中前者在os初始化完成之后执行了cpu_idle函数，调用了schedule函数，然后切换到initproc运行。

###语句local\_intr\_save(intr\_flag);....local\_intr\_restore(intr\_flag);在这里有何作用?请说明理由前者的作用是禁止中断，后者的作用是重新开启中断。这两条雨具构成了对其间代码的保护，以防被中断打断。

##总结
涉及到的重要知识点：

- 进程控制块的概念--对应proc\_struct结构体
- 内核栈的概念--对应copy\_thread函数
- 进程切换过程--对应switch\_to函数、context结构体、proc\_run函数
- 进程状态--对应proc->state和wakeup\_proc函数
- 进程管理--对应schedule函数

未涉及到的知识点：

- TSS的概念
