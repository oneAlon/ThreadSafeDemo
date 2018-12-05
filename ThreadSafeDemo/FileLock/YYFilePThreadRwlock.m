//
//  YYFilePThreadRwlock.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/4.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYFilePThreadRwlock.h"
#import <pthread.h>

@interface YYFilePThreadRwlock()

@property (nonatomic ,assign) pthread_rwlock_t lock;

@end

@implementation YYFilePThreadRwlock

- (void)dealloc {
    pthread_rwlock_destroy(&_lock);
}

- (instancetype)init {
    if (self = [super init]) {
        // 初始化锁
        pthread_rwlock_init(&_lock, NULL);
    }
    return self;
}

- (void)readWriteTest {
    for (int i = 0; i < 3; i++) {
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            [self writeFile];
            [self readFile];
        });
    }
}


- (void)readFile {
    
    // 加锁
    pthread_rwlock_rdlock(&_lock);
    
    sleep(1);
    NSLog(@"读文件--%@", [NSThread currentThread]);
    
    // 解锁
    pthread_rwlock_unlock(&_lock);
}

- (void)writeFile {
    
    // 加锁
    pthread_rwlock_wrlock(&_lock);
    
    sleep(1);
    NSLog(@"写文件--%@", [NSThread currentThread]);
    
    // 解锁
    pthread_rwlock_unlock(&_lock);
    
}

@end
