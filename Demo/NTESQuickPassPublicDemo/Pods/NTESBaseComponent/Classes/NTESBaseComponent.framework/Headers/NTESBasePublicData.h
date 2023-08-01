//
//  NTESBasePublicData.h
//  NTESBaseComponent
//
//  Created by 罗礼豪 on 2021/1/20.
//  Copyright © 2021 罗礼豪. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NTESBASEESDKVERSION @"1.8"

typedef NS_ENUM(NSUInteger, NTESSendErrorEnvironment) {
    NTESSendErrorEnvironmentTest, // 测试环境
    NTESSendErrorEnvironmentOnline, // 线上环境
};

typedef NS_ENUM(NSInteger, NTESBaseQPOperatorType) {
    NTESBaseQPOperatorTypeCT = 1,
    NTESBaseQPOperatorTypeCM,
    NTESBaseQPOperatorTypeCU,
    NTESBaseQPOperatorTypeNone,
    NTESBaseQPOperatorTypeOK,
};

NS_ASSUME_NONNULL_BEGIN

@interface NTESBasePublicData : NSObject

+ (NTESBasePublicData *)sharedInstance;

// 业务id
@property (nonatomic, copy) NSString *businessId;

// 客户端ip
@property (nonatomic, copy) NSString *ip;

// 手机型号
@property (nonatomic, copy) NSString *model;

// 操作系统信息(版本号之类)
@property (nonatomic, copy) NSString *osInfo;

// sdk版本号
@property (nonatomic, strong) NSString *version;

// getconf接口返回的token
@property (nonatomic, strong) NSString *token;

@property (nonatomic, assign) NTESSendErrorEnvironment environment;

// 运营商类型
@property (nonatomic, assign) NTESBaseQPOperatorType ot;

// 运行环境
@property (nonatomic, strong) NSNumber *envType;

// 用户输入的手机号
@property (nonatomic, copy) NSString *phone;

// 是否允许上传错误信息
@property (nonatomic, assign) BOOL allowUploadInfo;

@end

NS_ASSUME_NONNULL_END
