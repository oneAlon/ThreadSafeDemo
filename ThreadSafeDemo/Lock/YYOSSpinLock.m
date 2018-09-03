//
//  YYOSSpinLock.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYOSSpinLock.h"
#import <libkern/OSAtomic.h>

@interface YYOSSpinLock()

@property (nonatomic ,assign) OSSpinLock moneyLock;
@property (nonatomic ,assign) OSSpinLock tickLock;

@end

@implementation YYOSSpinLock

- (instancetype)init {
    if (self = [super init]) {
        _moneyLock = OS_SPINLOCK_INIT;
        _tickLock = OS_SPINLOCK_INIT;
    }
    return self;
}

- (void)__saveMoney {
    OSSpinLockLock(&_moneyLock);
    [super __saveMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__drawMoney {
    OSSpinLockLock(&_moneyLock);
    [super __drawMoney];
    OSSpinLockUnlock(&_moneyLock);
}

- (void)__saleTicket {
    OSSpinLockLock(&_tickLock);
    [super __saleTicket];
    OSSpinLockUnlock(&_tickLock);
}


@end
