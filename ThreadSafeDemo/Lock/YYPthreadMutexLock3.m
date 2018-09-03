//
//  YYPthreadMutexLock3.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYPthreadMutexLock3.h"
#import <pthread.h>

@interface YYPthreadMutexLock3()

@property (nonatomic ,assign) pthread_mutex_t mutex;
@property (nonatomic ,assign) pthread_cond_t condition;
@property (nonatomic ,strong) NSMutableArray *data;

@end

@implementation YYPthreadMutexLock3


- (void)dealloc {
    pthread_mutex_destroy(&_mutex);
    pthread_cond_destroy(&_condition);
}

- (instancetype)init {
    if (self = [super init]) {
        
        // 初始化属性
        pthread_mutexattr_t attr;
        pthread_mutexattr_init(&attr);
        pthread_mutexattr_settype(&attr, PTHREAD_MUTEX_NORMAL);
        
        // 初始化条件
        pthread_cond_init(&_condition, NULL);
        
        // 初始化锁
        pthread_mutex_init(&_mutex, &attr);
        
        // 释放资源
        pthread_mutexattr_destroy(&attr);
        
        self.data = [NSMutableArray array];
    }
    return self;
}

/*
 场景:data中有数据就删除掉
 */

- (void)otherTest {
    dispatch_queue_t queue = dispatch_queue_create("com.onealon.queueName", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self addData];
    });
    dispatch_async(queue, ^{
        [self removeData];
    });
}

- (void)addData {
    // 加锁
    pthread_mutex_lock(&_mutex);
    sleep(1);
    [self.data addObject:@"a"];
    NSLog(@"加数据");
//    pthread_cond_signal(&_condition);
    pthread_cond_broadcast(&_condition);
    pthread_mutex_unlock(&_mutex);
}

static int extracted(YYPthreadMutexLock3 *object) {
    return pthread_cond_wait(&object->_condition, &object->_mutex);
}

- (void)removeData {
    pthread_mutex_lock(&_mutex);
    if (self.data.count == 0) {
        // 进入休眠, 放开锁, 被唤醒后会再次对mutex加锁.
        extracted(self);
    }
    [self.data removeLastObject];
    NSLog(@"减数据");
    pthread_mutex_unlock(&_mutex);
}

@end
