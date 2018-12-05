//
//  YYFileBarrier.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/4.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYFileBarrier.h"

@interface YYFileBarrier()

@property (nonatomic ,strong) dispatch_queue_t queue;

@end

@implementation YYFileBarrier


- (instancetype)init {
    if (self = [super init]) {
        _queue = dispatch_queue_create("com.onealon.queue", DISPATCH_QUEUE_CONCURRENT);
    }
    return self;
}

- (void)readWriteTest {
    dispatch_async(_queue, ^{
        [self readFile];
    });
    dispatch_async(_queue, ^{
        [self readFile];
    });
    dispatch_async(_queue, ^{
        [self readFile];
    });
    
    dispatch_barrier_async(_queue, ^{
        [self writeFile];
    });
    dispatch_barrier_async(_queue, ^{
        [self writeFile];
    });
}

- (void)readFile {
    
    sleep(1);
    NSLog(@"读文件--%@", [NSThread currentThread]);
    
}

- (void)writeFile {

    sleep(1);
    NSLog(@"写文件--%@", [NSThread currentThread]);
    
}

@end
