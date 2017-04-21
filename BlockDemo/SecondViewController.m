//
//  SecondViewController.m
//  BlockDemo
//
//  Created by ligb on 2017/3/30.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import "SecondViewController.h"
#import "Test.h"

@interface SecondViewController ()
@property (nonatomic, copy) NSString *kkString;
@property (nonatomic, strong) Test *testClass;

@property (nonatomic , strong) dispatch_queue_t dispatchQueue;///全局串行队列

@end

@implementation SecondViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    _kkString = @"TsuiYuenHong";
    _testClass = [Test new];
    
    //weak strong dance 不会循环引用
    dispatch_async(self.dispatchQueue, ^{//使用串行队列
        [self testNormalBlockWithWeakStrongDance];
    });
    
    //使用异步队列
//    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//        [self testNormalBlockWithWeakStrongDance];
//    });
    
    
    //不用 weak strong dace 也不会循环引用，不过会延长生命周期
//    dispatch_async(self.dispatchQueue, ^{
//         [self testTargetBlock];
//    });

    //循环引用test
//    dispatch_async(self.dispatchQueue, ^{
//       [self testNormalBlock];
//    });

}

// 循环引用
- (void)testNormalBlock{
    [_testClass excuteNormalBlockWithParameter:_kkString CompletedBlock:^(NSString *string) {
        NSDictionary *dict = @{_kkString:string};
        NSLog(@"%@",dict);
    }];
}

//直接使用类方法测试》》 不会出现循环引用
- (void)testNormalBlockAction{
    [Test excuteNormalBlockWithParameter:_kkString CompletedBlock:^(NSString *string) {
        NSDictionary *dict = @{_kkString:string};
        NSLog(@"%@",dict);
    }];
}



// weak strong dance 不会循环引用
- (void)testNormalBlockWithWeakStrongDance{
    __weak typeof(self) wSelf = self;
    [_testClass excuteNormalBlockWithParameter:_kkString CompletedBlock:^(NSString *string) {
        if (!wSelf) return; // 注意判空 （可测试:注释该行，跳转后5秒内返回第一页，会出现 crash）
        __strong typeof(self) sSelf = wSelf; // 防止以下操作过程中 wSelf 被释放
        NSDictionary *dict = @{sSelf.kkString:string};
        NSLog(@"%@",dict);
        
//        // 注释 __strong typeof(self) sSelf = wSelf;代码后，在 for 循环过程中返回第一页，就知道 __strong typeof(self) sSelf = wSelf; 有什么用了
//        NSMutableArray *mArr = [NSMutableArray array];
//        for (int i = 0; i < 100000; i ++) {
//            [mArr addObject:wSelf.kkString];
//            NSLog(@"%@",wSelf.kkString);
//        }
        
    }];
}

// 不用 weak strong dace 也不会循环引用，不过会延长生命周期
- (void)testTargetBlock{
    [_testClass excuteTargetBlockWithTarget:self Parameter:_kkString CompletedBlock:^(typeof(self) target, NSString *string) {
        NSDictionary *dict = @{target.kkString:string};
        NSLog(@"%@",dict);
    }];
}

- (void)logHelloWorld{
    NSLog(@"Hello World");
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)dealloc{
    NSLog(@"--- SecondViewController Class Dealloc ---");
}

- (dispatch_queue_t)dispatchQueue{
    if (!_dispatchQueue) {
        _dispatchQueue = dispatch_queue_create("dispatchTestQueue", DISPATCH_QUEUE_SERIAL);
    }
    return _dispatchQueue;
}


@end
