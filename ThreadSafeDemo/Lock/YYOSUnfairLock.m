//
//  YYOSUnfairLock.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYOSUnfairLock.h"
#import <os/lock.h>

@interface YYOSUnfairLock()

@property (nonatomic ,assign) os_unfair_lock moneyLock;
@property (nonatomic ,assign) os_unfair_lock tickLock;

@end

/*
 unfair: 不公平
 从iOS10才开始支持
  
 通常，更高级别的同步原语，例如由提供的那些pthread或dispatch子系统应该是首选。
 解决优先级倒置问题。
  
 必须使用OS_UNFAIR_LOCK_INIT初始化
  
 替换已弃用的OSSpinLock。
 */

/*!
  @typedef os_unfair_lock
 
  @abstract
  Low-level lock that allows waiters to block efficiently on contention.
 
  In general, higher level synchronization primitives such as those provided by
  the pthread or dispatch subsystems should be preferred.
 
  The values stored in the lock should be considered opaque and implementation
  defined, they contain thread ownership information that the system may use
  to attempt to resolve priority inversions.
 
  This lock must be unlocked from the same thread that locked it, attemps to
  unlock from a different thread will cause an assertion aborting the process.
 
  This lock must not be accessed from multiple processes or threads via shared
  or multiply-mapped memory, the lock implementation relies on the address of
  the lock value and owning process.
 
  Must be initialized with OS_UNFAIR_LOCK_INIT
 
  @discussion
  Replacement for the deprecated OSSpinLock. Does not spin on contention but
  waits in the kernel to be woken up by an unlock.
 
  As with OSSpinLock there is no attempt at fairness or lock ordering, e.g. an
  unlocker can potentially immediately reacquire the lock before a woken up
  waiter gets an opportunity to attempt to acquire the lock. This may be
  advantageous for performance reasons, but also makes starvation of waiters a
  possibility.
 */

@implementation YYOSUnfairLock

- (instancetype)init {
    if (self = [super init]) {
        _moneyLock = OS_UNFAIR_LOCK_INIT;
        _tickLock = OS_UNFAIR_LOCK_INIT;
    }
    return self;
}

- (void)__saveMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __saveMoney];
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__drawMoney {
    os_unfair_lock_lock(&_moneyLock);
    [super __drawMoney];
    os_unfair_lock_unlock(&_moneyLock);
}

- (void)__saleTicket {
    os_unfair_lock_lock(&_tickLock);
    [super __saleTicket];
    os_unfair_lock_unlock(&_tickLock);
}

@end
