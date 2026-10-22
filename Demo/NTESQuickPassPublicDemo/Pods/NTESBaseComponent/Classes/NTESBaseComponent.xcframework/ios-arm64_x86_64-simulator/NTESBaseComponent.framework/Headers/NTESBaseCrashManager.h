//
//  NTESBaseCrashManager.h
//  NTESBaseComponent
//
//  Created by 罗礼豪 on 2020/9/10.
//  Copyright © 2020 罗礼豪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NTESSDKType) {
    NTESSDKTypeQuickPass = 1,  // 号码认证
    NTESSDKTypeLiveDetect,     // 活体检测
    NTESSDKTypeVerifyCode,     // 验证码
};

typedef NS_ENUM(NSUInteger, NTESSDKEnviroment) {
    NTESSDKEnviromentTest = 1,  // 测试环境
    NTESSDKEnviromentOnline,    // 线上环境
};

NS_ASSUME_NONNULL_BEGIN

@interface NTESBaseCrashManager : NSObject

+ (NTESBaseCrashManager *)sharedInstance;

/**
 开始收集崩溃日志
 */
- (void)startCollectCrash:(NTESSDKType)type withEnviroment:(NTESSDKEnviroment)enviroment;

/**
取消收集崩溃日志
*/
- (void)cancelCollectCrash;

@end

NS_ASSUME_NONNULL_END
