//
//  YYSemaphore.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYSemaphore.h"

@interface YYSemaphore()

@property (nonatomic ,strong) dispatch_semaphore_t semaphore;

@end

@implementation YYSemaphore

/*
 semaphore叫做”信号量”
 信号量的初始值，可以用来控制线程并发访问的最大数量
 信号量的初始值为1，代表同时只允许1条线程访问资源，保证线程同步
 */

- (instancetype)init {
    if (self = [super init]) {
        self.semaphore = dispatch_semaphore_create(1);
    }
    return self;
}

- (void)otherTest {
    
    // 开20个线程, 操作数据
    for (int i = 0; i < 20; i++) {
        dispatch_async(dispatch_queue_create("com.onealon.queueName", 0), ^{
            [self threadTest];
        });
    }
    
}

- (void)threadTest {
    
    // 如果信号量小于0 就等待, 如果信号量大于0 就减1 然后执行后边的代码
    dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
    
    sleep(2);
    NSLog(@"操作数据---");
    
    // 信号量的值加1
    dispatch_semaphore_signal(self.semaphore);
}

@end
