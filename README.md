# GCD
GCD
1、简介：
 Grand Central Dispatch"强大的中枢调度器"，为多核运行的解决方案，会自动合理的利用更多CUP内核，自动管理线程生命周期（创建线程、调度任务、销毁线程），我们只需要对队列和任务进行操作，纯C语言Api

2、
异步：dispatch_async
- 会开启新线程执行任务
- 不需要等待当前执行任务，就可以执行下一个语句

同步：```dispatch_sync```，需要立即执行
- 不会开启新线程，在当前线程执行任务
- 需要等待当前任务执行完毕后，才可以执行下一个语句

3、队列
- 主队列：在主线程执行，特殊的串行队列，直接获取，不需要创建
- 串行队列（```DISPATCH_QUEUE_SERIAL```）：先进先出的顺序，把任务取出来一个一个的执行，只有前一个任务执行完毕后才执行下一个任务
- 并行队列（```DISPATCH_QUEUE_CONCURRENT```）：可能开启线程，多个任务同时执行，同步方式下执行不开启线程，并发功能无效
- 全局队列：系统提供的特殊的并发队列，供全局使用，不需要创建，

4、dispatch_once在程序运行过程中只执行一次，实现单例

5、dispatch_after延迟执行某段代码，和RunLoop相关

6、dispatch_barrier_async、sync栅栏：拦截前面的任务，等待前面的任务全部执行完毕后才回调执行栅栏的任务，再等待栅栏的任务执行完毕再执行栅栏后面的任务。全局队列不能和栅栏配合使用，需要手动创建队列。

7、队列组（```dispatch_group```）使用场景：两个任务都执行完毕再执行第三个任务，```dispatch_group_notify```

8、dispatch_apply快速迭代，类似for循环，如果在并发队列是异步无序的，同时进行

9、```dispatch_group_wait```组等待

10、信号量（```dispatch_semaphore``）

11、```Dispatch Source```

12、GCD使用的注意点
线程死锁：同步+主队列、同步函数嵌套都会造成线程死锁

线程间通信
