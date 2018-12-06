# ThreadSafeDemo
## 多线程同步方案

- OSSpinLock自旋锁, 已经弃用
- os_unfair_lock, iOS10开始支持
- pthread_mutex
  - pthread_mutex普通锁
  - pthread_mutex递归锁
  - pthread_mutex条件锁
- NSLock
  - NSLock普通锁, 对pthread_mutex的封装, 更加面向对象
  - NSRecursiveLock递归锁
  - NSCondition条件锁, 对mutex和condition的封装
  - NSConditionLock条件锁, 对NSCondition的进一步封装, 可以设置条件.

- dispatch_semaphore信号量, 通过控制线程的最大并发数量, 保证线程同步
- synchronized



## 文件的多读单写

- pthread_rwlock_P
- barrier_async_P



