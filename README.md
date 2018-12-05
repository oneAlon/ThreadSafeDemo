# ThreadSafeDemo
多线程同步方案

- OSSpinLock
- os_unfair_lock

## OSSpinLock

自旋锁, 不安全, 已经被启用

```objc
// 初始化锁
OSSpinLock moneyLock = OS_SPINLOCK_INIT;
```

```objc
// 加锁
OSSpinLockLock(&_moneyLock);
// 需要加锁的内容
...
// 解锁
OSSpinLockUnlock(&_moneyLock);

```



**自定义自旋锁**

```objc
// 声明一个Int类型的变量
@property (nonatomic ,assign) int32_t customMoneyLock;
```

```objc
// 提供加锁方法
void _customOSSpinLock(int32_t *__lock) {
    
    while (*__lock != 0) {
        NSLog(@"自旋啊!!!");
    }
    *__lock = ~*__lock;
}

// 提供解锁方法
void _customOSSpinUnLock(int32_t *__lock) {
    *__lock = 0;
}
```

```objective-c
// 测试代码
_customOSSpinLock(&_moneyLock);
....
_customOSSpinUnLock(&_moneyLock);
```



## os_unfair_lock

用于取代不安全的OSSpinLock, 从iOS10才开始支持.

```objective-c
// 初始化
_moneyLock = OS_UNFAIR_LOCK_INIT;
// 加锁
os_unfair_lock_lock(&_moneyLock);
// 加锁的代码
....
// 解锁
os_unfair_lock_unlock(&_moneyLock);
```

