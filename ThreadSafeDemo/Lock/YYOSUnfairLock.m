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
 
 低级锁定，允许服务员在争用时有效阻止。
  
   通常，更高级别的同步原语，例如由提供的那些
   pthread或dispatch子系统应该是首选。
  
   存储在锁中的值应视为不透明和实现
   定义后，它们包含系统可能使用的线程所有权信息
   尝试解决优先级倒置问题。
  
   必须从锁定它的同一个线程解锁此锁定
   从另一个线程解锁将导致断言中止该过程。
  
   不得通过共享从多个进程或线程访问此锁
   或多重映射的内存，锁实现依赖于地址
   锁定值和拥有过程。
  
   必须使用OS_UNFAIR_LOCK_INIT初始化
  
   @discussion
   替换已弃用的OSSpinLock。不是争论而是
   等待内核被解锁唤醒。
  
   与OSSpinLock一样，没有尝试公平或锁定排序，例如一个
   解锁器可能会在唤醒之前立即重新获取锁定
   服务员有机会尝试获得锁定。这可能是
   有利于性能的原因，但也使服务员的饥饿a
   可能性。
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
