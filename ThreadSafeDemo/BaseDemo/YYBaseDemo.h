//
//  YYBaseDemo.h
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol YYBaseDemoMoneyProtocol <NSObject>

- (void)__saveMoney;
- (void)__drawMoney;

@end

@protocol YYBaseDemoTicketProtocol <NSObject>

- (void)__saleTicket;

@end

@interface YYBaseDemo : NSObject<YYBaseDemoMoneyProtocol, YYBaseDemoTicketProtocol>

- (void)moneyTest;
- (void)ticketTest;
- (void)otherTest;

@end
