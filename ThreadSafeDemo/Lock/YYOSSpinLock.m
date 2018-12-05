//
//  YYOSSpinLock.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYOSSpinLock.h"
#import <libkern/OSAtomic.h>

void _customOSSpinLock(int32_t *__lock) {
    
    while (*__lock != 0) {
        NSLog(@"自旋啊!!!");
    }
    *__lock = 1;
}

void _customOSSpinUnLock(int32_t *__lock) {
    *__lock = 0;
}

@interface YYOSSpinLock()

@property (nonatomic ,assign) OSSpinLock moneyLock;
@property (nonatomic ,assign) OSSpinLock tickLock;

@property (nonatomic ,assign) int32_t customMoneyLock;

@end

@implementation YYOSSpinLock

- (instancetype)init {
    if (self = [super init]) {
        // 默认值为0, 0表示未加锁, 非0表示加锁
        _moneyLock = OS_SPINLOCK_INIT;
        _tickLock = OS_SPINLOCK_INIT;
        
        _customMoneyLock = 0;
    }
    return self;
}

- (void)__saveMoney {
//    OSSpinLockLock(&_moneyLock);
//    [super __saveMoney];
//    OSSpinLockUnlock(&_moneyLock);
    
    // 自定义自旋锁
    _customOSSpinLock(&_moneyLock);
    [super __saveMoney];
    _customOSSpinUnLock(&_moneyLock);
}

- (void)__drawMoney {
//    OSSpinLockLock(&_moneyLock);
//    [super __drawMoney];
//    OSSpinLockUnlock(&_moneyLock);
    
    // 自定义自旋锁
    _customOSSpinLock(&_moneyLock);
    [super __drawMoney];
    _customOSSpinUnLock(&_moneyLock);
}

- (void)__saleTicket {
    OSSpinLockLock(&_tickLock);
    [super __saleTicket];
    OSSpinLockUnlock(&_tickLock);
}

@end
