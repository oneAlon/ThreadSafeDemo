//
//  YYNSLock.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYNSLock.h"

@interface YYNSLock()

@property (nonatomic ,strong) NSLock *moneyLock;
@property (nonatomic ,strong) NSLock *tickLock;
@property (nonatomic ,strong) NSRecursiveLock *lock;

@end

@implementation YYNSLock

/*
 An object that coordinates the operation of multiple threads of execution within the same application.
 An NSLock object can be used to mediate access to an application’s global data or to protect a critical section of code, allowing it to run atomically.
 
 Warning
 The NSLock class uses POSIX threads to implement its locking behavior. When sending an unlock message to an NSLock object, you must be sure that message is sent from the same thread that sent the initial lock message. Unlocking a lock from a different thread can result in undefined behavior.
 You should not use this class to implement a recursive lock. Calling the lock method twice on the same thread will lock up your thread permanently. Use the NSRecursiveLock class to implement recursive locks instead.
 Unlocking a lock that is not locked is considered a programmer error and should be fixed in your code. The NSLock class reports such errors by printing an error message to the console when they occur.
 
 NSLock的lock和unlock必须在同一个线程
 如果想使用递归锁, 不能使用NSLock, 因为在同一个线程连续两次调用NSLock的lock方法, 会将线程永久锁定. 请使用NSRecursiveLock实现递归锁.
 */

- (instancetype)init {
    if (self = [super init]) {
        _moneyLock = [[NSLock alloc] init];
        _tickLock = [[NSLock alloc] init];
        _lock = [[NSRecursiveLock alloc] init];
    }
    return self;
}

- (void)__saveMoney {
//    [_moneyLock lock];
    [super __saveMoney];
//    [_moneyLock unlock];
}

- (void)__drawMoney {
//    [_moneyLock lock];
    [super __drawMoney];
//    [_moneyLock unlock];
}

- (void)__saleTicket {
//    [_tickLock lock];
    [super __saleTicket];
    [_tickLock unlock];
}

- (void)otherTest {
    [_lock lock];
    NSLog(@"%s", __func__);
    static int count = 0;
    if (count < 5) {
        count++;
        [self otherTest];
    }
    [_lock unlock];
}
@end
