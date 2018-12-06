//
//  YYCompareViewController.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/12/6.
//  Copyright © 2018 xygj. All rights reserved.
//

#import "YYCompareViewController.h"
#import <QuartzCore/CAMediaTiming.h>
#import <libkern/OSAtomic.h>
#import <os/lock.h>
#import <pthread.h>

static double const count = 10000;

@interface YYCompareViewController ()

@property (nonatomic ,assign) OSSpinLock spinLock;

@property (nonatomic ,assign) os_unfair_lock osUnfairLock;

@property (nonatomic ,assign) pthread_mutexattr_t attr;
@property (nonatomic ,assign) pthread_mutex_t pthreadMutex;

@property (nonatomic ,strong) NSLock *lock;

@property (nonatomic ,strong) dispatch_semaphore_t semaphore;

@end

@implementation YYCompareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self lockInit];
}

- (void)lockInit {
    
    _spinLock = OS_SPINLOCK_INIT;
    
    _osUnfairLock = OS_UNFAIR_LOCK_INIT;
    
    pthread_mutexattr_init(&_attr);
    pthread_mutexattr_settype(&_attr, PTHREAD_MUTEX_NORMAL);
    pthread_mutex_init(&_pthreadMutex, &_attr);
    
    _lock = [[NSLock alloc] init];
    
    _semaphore = dispatch_semaphore_create(1);
}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        double begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            OSSpinLockLock(&self->_spinLock);
            OSSpinLockUnlock(&self->_spinLock);
        }
        double end = CACurrentMediaTime();
        NSLog(@"OSSpinLock执行时间:%8.2f ms", (end - begin) * 1000);
    });
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        double begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            if (@available(iOS 10.0, *)) {
                os_unfair_lock_lock(&self->_osUnfairLock);
                os_unfair_lock_unlock(&self->_osUnfairLock);
            } else {
                // Fallback on earlier versions
            }
        }
        double end = CACurrentMediaTime();
        NSLog(@"os_unfair_lock执行时间:%8.2f ms", (end - begin) * 1000);
    });
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        double begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            pthread_mutex_lock(&self->_pthreadMutex);
            pthread_mutex_unlock(&self->_pthreadMutex);
        }
        double end = CACurrentMediaTime();
        NSLog(@"pthread_mutex_t执行时间:%8.2f ms", (end - begin) * 1000);
    });
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        double begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            [self->_lock lock];
            [self->_lock unlock];
        }
        double end = CACurrentMediaTime();
        NSLog(@"NSLock执行时间:%8.2f ms", (end - begin) * 1000);
    });
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        double begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            dispatch_semaphore_wait(self.semaphore, DISPATCH_TIME_FOREVER);
            dispatch_semaphore_signal(self.semaphore);
        }
        double end = CACurrentMediaTime();
        NSLog(@"dispatch_semaphore执行时间:%8.2f ms", (end - begin) * 1000);
    });
    
    
    dispatch_async(dispatch_queue_create(0, 0), ^{
        double begin = CACurrentMediaTime();
        for (int i = 0; i < count; i++) {
            @synchronized (self) {
                
            }
        }
        double end = CACurrentMediaTime();
        NSLog(@"synchronized执行时间:%8.2f ms", (end - begin) * 1000);
    });
}

@end
