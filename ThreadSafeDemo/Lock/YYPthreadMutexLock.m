//
//  YYPthreadMutexLock.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYPthreadMutexLock.h"
#import <pthread.h>

@interface YYPthreadMutexLock()
@property (nonatomic ,assign) pthread_mutexattr_t attr;
@property (nonatomic ,assign) pthread_mutex_t moneyMutex;
@property (nonatomic ,assign) pthread_mutex_t tickMutex;

@end

@implementation YYPthreadMutexLock

/*
 #define PTHREAD_MUTEX_NORMAL        0
 #define PTHREAD_MUTEX_ERRORCHECK    1
 #define PTHREAD_MUTEX_RECURSIVE        2 递归锁
 #define PTHREAD_MUTEX_DEFAULT        PTHREAD_MUTEX_NORMAL
 */

- (void)dealloc {
    pthread_mutex_destroy(&_moneyMutex);
    pthread_mutex_destroy(&_tickMutex);
    pthread_mutexattr_destroy(&_attr);
}

- (instancetype)init {
    if (self = [super init]) {
        // 初始化属性
        pthread_mutexattr_init(&_attr);
        pthread_mutexattr_settype(&_attr, PTHREAD_MUTEX_NORMAL);
        // 初始化锁
        pthread_mutex_init(&_moneyMutex, &_attr);
        pthread_mutex_init(&_tickMutex, &_attr);
    }
    return self;
}

- (void)__saveMoney {
    pthread_mutex_lock(&_moneyMutex);
    [super __saveMoney];
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)__drawMoney {
    pthread_mutex_lock(&_moneyMutex);
    [super __drawMoney];
    pthread_mutex_unlock(&_moneyMutex);
}

- (void)__saleTicket {
    pthread_mutex_lock(&_tickMutex);
    [super __saleTicket];
    pthread_mutex_unlock(&_tickMutex);
}

@end
