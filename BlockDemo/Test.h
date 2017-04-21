//
//  Test.h
//  BlockDemo
//
//  Created by ligb on 2017/3/30.
//  Copyright © 2017年 com.mobile-kingdom.ekapps. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^NormalBlock)(NSString *string);
typedef void(^TargetBlock)(id target, NSString *string);

@interface Test : NSObject

@property (nonatomic, copy) TargetBlock targetBlock;
@property (nonatomic, copy) NormalBlock normalBlock;

- (void)excuteNormalBlockWithParameter:(NSString *)string
                        CompletedBlock:(NormalBlock )completedBlock;

- (void)excuteTargetBlockWithTarget:(id )target
                          Parameter:(NSString *)string
                     CompletedBlock:(TargetBlock )completedBlock;

+ (void)excuteNormalBlockWithParameter:(NSString *)string CompletedBlock:(NormalBlock)completeBlock;

@end
