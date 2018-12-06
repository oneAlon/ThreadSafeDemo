//
//  ViewController.m
//  ThreadSafeDemo
//
//  Created by xygj on 2018/8/27.
//  Copyright © 2018年 xygj. All rights reserved.
//

#import "ViewController.h"
#import "YYBaseDemo.h"
#import "YYOSSpinLock.h"
#import "YYPthreadMutexLock.h"
#import "YYPthreadMutexLock2.h"
#import "YYPthreadMutexLock3.h"
#import "YYNSCondition.h"
#import "YYSynchronized.h"
#import "YYNSConditionLock.h"
#import "YYSemaphore.h"

#import "YYFilePThreadRwlock.h"
#import "YYFileBarrier.h"

#import "YYCompareViewController.h"

@interface ViewController ()

@end

@implementation ViewController

/*
 自旋锁和互斥锁
     自旋锁: 如果资源被占用, 调用者会一直循环. spin
     互斥锁: 如果资源被占用, 资源申请者就会进入休眠状态.
 */

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (IBAction)lockDemo:(id)sender {
    
    YYBaseDemo *demo = [[YYSemaphore alloc] init];
//    [demo moneyTest];
    //    [demo ticketTest];
    [demo otherTest];
    
}

- (IBAction)fileDemo:(id)sender {
    /*
     同一时间只能允许一个线程对文件进行写操作.
     同一时间允许多个线程对文件进行读操作.
     */
    
//    YYFilePThreadRwlock *lock = [[YYFilePThreadRwlock alloc] init];
    YYFileBarrier *lock = [[YYFileBarrier alloc] init];
    [lock readWriteTest];
    
    
}

@end
