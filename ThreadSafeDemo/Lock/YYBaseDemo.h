//
//  YYBaseDemo.h
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface YYBaseDemo : NSObject

- (void)moneyTest;
- (void)ticketTest;
- (void)otherTest;

#pragma mark - 暴露给子类去使用
- (void)__saveMoney;
- (void)__drawMoney;
- (void)__saleTicket;

@end
