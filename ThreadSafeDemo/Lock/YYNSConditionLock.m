//
//  YYNSConditionLock.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/9/3.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "YYNSConditionLock.h"

@interface YYNSConditionLock()

@property (nonatomic ,strong) NSConditionLock *condition;
@property (nonatomic ,strong) NSMutableArray *data;

@end

@implementation YYNSConditionLock

- (instancetype)init {
    if (self = [super init]) {
        _condition = [[NSConditionLock alloc] initWithCondition:10];
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
    [_condition lockWhenCondition:10];
    sleep(1);
    [self.data addObject:@"a"];
    NSLog(@"加数据");
    //    [_condition signal];
    [_condition unlockWithCondition:20];
}

- (void)removeData {
    if (self.data.count == 0) {
        // 进入休眠, 放开锁, 被唤醒后会再次对mutex加锁.
//        [_condition wait];
        [_condition lockWhenCondition:20];
    }
    [self.data removeLastObject];
    NSLog(@"减数据");
    [_condition unlock];
}

@end
