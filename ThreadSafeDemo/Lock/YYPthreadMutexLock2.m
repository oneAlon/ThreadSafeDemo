//
//  YYPthreadMutexLock2.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYPthreadMutexLock2.h"
#import <pthread.h>

@interface YYPthreadMutexLock2()
@property (nonatomic ,assign) pthread_mutexattr_t attr;
@property (nonatomic ,assign) pthread_mutex_t mutex;

@end

@implementation YYPthreadMutexLock2

/*
 #define PTHREAD_MUTEX_NORMAL        0
 #define PTHREAD_MUTEX_ERRORCHECK    1
 #define PTHREAD_MUTEX_RECURSIVE        2 递归锁
 #define PTHREAD_MUTEX_DEFAULT        PTHREAD_MUTEX_NORMAL
 
 递归锁: 允许同一个线程对同一把锁进行重复操作
 
 */

- (void)dealloc {
    pthread_mutex_destroy(&_mutex);
    pthread_mutexattr_destroy(&_attr);
}

- (instancetype)init {
    if (self = [super init]) {
        // 初始化属性
        pthread_mutexattr_init(&_attr);
        pthread_mutexattr_settype(&_attr, PTHREAD_MUTEX_RECURSIVE);
        // 初始化递归锁
        pthread_mutex_init(&_mutex, &_attr);
    }
    return self;
}

/*
 非递归锁:
    otherTest执行第一次, 加锁
    otherTest执行第二次, 发现已经加锁, 等待解锁, 会出现一直等待, 死锁现象.
 
 递归锁:
    otherTest执行第一次, 加锁1-->执行完成, 解锁1
    otherTest执行第二次, 加锁2-->执行完成, 解锁2
    otherTest执行第三次, 加锁3-->执行完成, 解锁3
 
 */
- (void)otherTest {
    pthread_mutex_lock(&_mutex);
    NSLog(@"%s", __func__);
    static int count = 0;
    if (count < 5) {
        count++;
        [self otherTest];
    }
    pthread_mutex_unlock(&_mutex);
}

@end
