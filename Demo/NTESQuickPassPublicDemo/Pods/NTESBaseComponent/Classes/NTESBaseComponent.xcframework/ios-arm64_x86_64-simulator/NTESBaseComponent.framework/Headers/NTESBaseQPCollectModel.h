//
//  NTESBaseQPCollectModel.h
//  NTESBaseComponent
//
//  Created by 罗礼豪 on 2021/3/23.
//  Copyright © 2021 罗礼豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESBasePublicData.h"

typedef NS_ENUM(NSInteger, NTESBaseQPErrorType) {
    NTESBaseQPDNSError = 1,             // dns解析错误
    NTESBaseQPConnectError,             // 连接错误
    NTESBaseQPRequestTimeoutError,      // 接口请求超时
    NTESBaseQPCheckout4GTimeoutError,   // 流量切换超时
    NTESBaseQPOperatorReturnError,      // 返回值错误
    NTESBaseQPSDKError,                 // SDK自身异常
    NTESBaseQPOtherError,               // 其他错误
};

typedef NS_ENUM(NSInteger, NTESBaseQPMonitorType) {
    NTESBaseQPPrecheckMonitor = 1,      // 本机验证 preCheck接口
    NTESBaseQPOperatorMonitor,          // 本机验证 运营商取号接口
    NTESBaseSDKMonitor,                 // SDK本身
    NTESBaseQLPrecheckMonitor,          // 一键登录 precheck接口
    NTESBaseQLOperatorMonitor,          // 一键登录 运营商取号接口
};

NS_ASSUME_NONNULL_BEGIN

@interface NTESBaseQPCollectModel : NSObject

- (void)uploadError;

// 业务id，必传
@property (nonatomic, copy) NSString *businessId;

// 易盾token，非必传
@property (nonatomic, copy) NSString *token;

// 监控对象，必传
@property (nonatomic, assign) NTESBaseQPMonitorType monitorType;

// 错误类型， 必传
@property (nonatomic, assign) NTESBaseQPErrorType errorType;

// http错误码，非必传
@property (nonatomic, strong) NSNumber *httpCode;

// body里面的错误返回码，非必传
@property (nonatomic, strong) NSNumber *code;

// 错误信息，必传
@property (nonatomic, copy) NSString *message;

// 客户端ip，必传
@property (nonatomic, copy) NSString *ip;

// dns信息，非必传
@property (nonatomic, copy) NSString *dns;

// 请求耗时，必传
@property (nonatomic, strong) NSNumber *requestTime;

// 请求url， 非必传
@property (nonatomic, copy) NSString *requestURL;

// 运营商类型，必传
@property (nonatomic, assign) NTESBaseQPOperatorType ot;

// 用户输入的手机号，非必传
@property (nonatomic, copy) NSString *phone;

// 系统api拿到的真正手机号，非必传
@property (nonatomic, copy) NSString *realPhone;

// 运行环境，必传
@property (nonatomic, strong) NSNumber *envType;

// 手机型号，非必传
@property (nonatomic, copy) NSString *phoneModel;

// 操作系统信息(版本号之类)，非必传
@property (nonatomic, copy) NSString *osInfo;

// 发生异常时客户端时间戳，必传
@property (nonatomic, copy) NSString *clientTime;

// 重试次数（目前只针对切换4g），iOS没有重试，传0，必传
@property (nonatomic, strong) NSNumber *retryTimes;

// sdk版本号，必传
@property (nonatomic, strong) NSString *version;

@end

NS_ASSUME_NONNULL_END
