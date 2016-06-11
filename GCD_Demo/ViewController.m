//
//  ViewController.m
//  GCD_Demo
//
//  Created by Shelin on 16/6/9.
//  Copyright © 2016年 xiemingjiang. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self group];

}

#pragma mark - 异步主队列，不会开新线程，都在主线程执行

- (void)asyncMain {
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    NSLog(@"----start----");
    
    dispatch_async(mainQueue, ^{
        NSLog(@"----1----%@", [NSThread currentThread]);
    });
    
    dispatch_async(mainQueue, ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
    });
    
    dispatch_async(mainQueue, ^{
        NSLog(@"----3----%@", [NSThread currentThread]);
    });
    
    NSLog(@"----finish----");
}

#pragma mark - 同步主队列，线程死锁

- (void)syncMain {
    
    dispatch_queue_t mainQueue = dispatch_get_main_queue();
    
    NSLog(@"----start----");
    
    dispatch_sync(mainQueue, ^{
        NSLog(@"----1----%@", [NSThread currentThread]);
    });
    
    dispatch_sync(mainQueue, ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
    });
    
    dispatch_sync(mainQueue, ^{
        NSLog(@"----3----%@", [NSThread currentThread]);
    });
    
    NSLog(@"----finish----");
}

#pragma mark - 异步并行队列，会开线程

- (void)async_concurrent {
    
    NSLog(@"----start----");
    
    dispatch_queue_t queue = dispatch_queue_create("Shelin_Q", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(queue, ^{
        NSLog(@"----1----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----3----%@", [NSThread currentThread]);
    });
    
    NSLog(@"----finish----");
    
}

#pragma mark - 异步串行队列，会开线程

- (void)async_serial {
    NSLog(@"----start----");
    
    dispatch_queue_t queue = dispatch_queue_create("Shelin_Q", DISPATCH_QUEUE_SERIAL);
    
    dispatch_async(queue, ^{
        NSLog(@"----1----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
    });
    dispatch_async(queue, ^{
        NSLog(@"----3----%@", [NSThread currentThread]);
    });
    
    NSLog(@"----finish----");
}

#pragma mark - 同步并行队列，会开线程

- (void)sync_concurrent {
    NSLog(@"----start----");
    
    dispatch_queue_t queue = dispatch_queue_create("Shelin_Q", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_sync(queue, ^{
        NSLog(@"----1----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----3----%@", [NSThread currentThread]);
    });
    NSLog(@"----finish----");
}

#pragma mark - 同步串队列，不会开线程

- (void)sync_serial {
    
    NSLog(@"----start----");
    dispatch_queue_t queue = dispatch_queue_create("Shelin_Q", DISPATCH_QUEUE_SERIAL);
    
    dispatch_sync(queue, ^{
        NSLog(@"----1----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
    });
    dispatch_sync(queue, ^{
        NSLog(@"----3----%@", [NSThread currentThread]);
    });
    NSLog(@"----finish----");
}

#pragma mark - 异步全局并行队列，会开线程

- (void)async_global {
    
    NSLog(@"----start----");
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----1----%@", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
    });
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----3----%@", [NSThread currentThread]);
    });
     NSLog(@"----finish----");
}

#pragma mark - 同步全局并行队列，不会开线程

- (void)sync_global {
    NSLog(@"----start----");
    
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----1----%@", [NSThread currentThread]);
    });
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
    });
    dispatch_sync(dispatch_get_global_queue(0, 0), ^{
        NSLog(@"----3----%@", [NSThread currentThread]);
    });
    NSLog(@"----finish----");
}

#pragma mark - dispatch_barrier栅栏
#warning 注意配合全局并发队列无效!

- (void)barrier_async {
    dispatch_queue_t q = dispatch_queue_create("", DISPATCH_QUEUE_CONCURRENT);
    
    dispatch_async(q, ^{
        NSLog(@"----1----%@", [NSThread currentThread]);

    });
    
    dispatch_async(q, ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
        
    });
    
    dispatch_barrier_async(q, ^{
        NSLog(@"----barrier----%@", [NSThread currentThread]);
    
    });
    
    dispatch_async(q, ^{
        NSLog(@"----3----%@", [NSThread currentThread]);
        
    });
    
    dispatch_async(q, ^{
        NSLog(@"----4----%@", [NSThread currentThread]);
        
    });
    
}

#pragma mark - 快速迭代，异步无序的

- (void)apply {
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    
    dispatch_apply(10, q, ^(size_t index) {
        NSLog(@"----%zd----%@", index, [NSThread currentThread]);
    });
}

#pragma mark - 队列组

- (void)group {
    dispatch_queue_t q = dispatch_get_global_queue(0, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, q, ^{
        NSLog(@"----1----%@", [NSThread currentThread]);
    });
    
    dispatch_group_async(group, q, ^{
        NSLog(@"----2----%@", [NSThread currentThread]);
    });
    
    //以上两个任务都执行完毕才执行dispatch_group_notify
    dispatch_group_notify(group, q, ^{
        NSLog(@"dispatch_group_notify");
    });
}

@end
