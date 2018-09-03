//
//  YYNSCondition.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYNSCondition.h"

@interface YYNSCondition()

@property (nonatomic ,strong) NSCondition *condition;
@property (nonatomic ,strong) NSMutableArray *data;

@end

@implementation YYNSCondition

- (instancetype)init {
    if (self = [super init]) {
        _condition = [[NSCondition alloc] init];
        self.data = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)otherTest {
    dispatch_queue_t queue = dispatch_queue_create("com.onealon.queueName", DISPATCH_QUEUE_CONCURRENT);
    dispatch_async(queue, ^{
        [self addData];
    });
    dispatch_async(queue, ^{
        [self removeData];
    });
}

- (void)addData {
    // 加锁
    [_condition lock];
    sleep(1);
    [self.data addObject:@"a"];
    NSLog(@"加数据");
//    [_condition signal];
    [_condition broadcast];
    [_condition unlock];
}

- (void)removeData {
    [_condition lock];
    if (self.data.count == 0) {
        // 进入休眠, 放开锁, 被唤醒后会再次对mutex加锁.
        [_condition wait];
    }
    [self.data removeLastObject];
    NSLog(@"减数据");
    [_condition unlock];
}

@end
