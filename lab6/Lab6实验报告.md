#Lab6实验报告
计23班 杨煜 2011010312

##练习0:填写已有实验
按要求填写已有实验。
对已有实验的改进为：

- 继续更新proc.c中的alloc\_proc函数
- 初始化新加入到proc\_struct中的内容(未完成这项更新之前无法执行make grade函数)

##使用 Round Robin 调度算法
###请理解并分析sched_class中各个函数指针的用法，并结合Round Robin调度算法描ucore的调度执行过程
理解sched\_class的关键是看懂schedule函数：
将调度过程抽象化为三个过程：在run\_queue中出队、入队、选择下一个。

调度算法包括这三个过程及另外需要的初始化init和时钟函数。通过调用sched\_class的五个对应函数指针执行实际代码，就可以使的sched\_class成为一个统一的接口，因此实现不同调度算法只需实现不同sched\_class这个类即可完成。

Round Robin代码中的默认调度算法，它实现了先进先出的调度队列，其中schedule函数通过default\_sched\_class调了RR\_enqueue并将当前运行的被打断进程加入队尾，之后调RR\_pick\_next获取队列的头作为下一个运行进程，之后调RR\_dequeue把这个进程出队。另外需说明的是RR\_proc\_tick在每个时钟发生时被调用，因此时间片归零的进程会被trap函数执行调度schedule而交出cpu的使用权。

###请在实验报告中简要说明如何设计实现”多级反馈队列调度算法“

多级反馈队列调度算法在Round Robin的基础上把维护一个队列改成维护多个不同优先级的队列。因此只要在proc\_struct中加上一项当前优先级的标记，之后在入队时按优先级加入对应队列，出队时按顺序出队，在pick\_next时按优先级依次搜索各个队列，最后找到一队不为空，返回其队首并将其优先级下调就可完成。

##实现Stride Scheduling调度算法
###设计实现过程
按照注释的提示实现Stride Scheduling算法，在实现的过程中应当维护run\_queue和proc\_struct两个结构体中的内容定义保证没有遗漏。关于BIG_STRIDE的定义按照实验指导书上的计算完成定义。在trap\_dispatch函数中时钟中断下面需要调用sched\_class\_proc\_tick(current)以更新进程的时间片，因此需修改sched.h和sched.c调度文件，使的该函数能被trap.c调用。

##总结：
本Lab中涉及到的重要知识点：

- Round Robin处理机调度算法--对应default\_sched.c中的RR系列的函数
- Stride Scheduling处理机调度算法--对应default\_sched\_stride.c中的stride系列的函数

未涉及的知识点：

- 其余的处理机调度算法