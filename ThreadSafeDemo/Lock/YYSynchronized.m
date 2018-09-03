//
//  YYSynchronized.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYSynchronized.h"

@implementation YYSynchronized

/*
 是对mutex递归锁的封装
 */

- (void)__saveMoney {
    @synchronized(self){
        [super __saveMoney];
    }
}

- (void)__drawMoney {
    @synchronized(self){
        [super __drawMoney];
    }
}

- (void)__saleTicket {
    @synchronized(self){
        [super __saleTicket];
    }
}

- (void)otherTest {
    static int count = 0;
    NSObject *obj = [[NSObject alloc] init];
    @synchronized(obj){
        if (count < 5) {
            count++;
            [self otherTest];
        }
    }
}


@end
