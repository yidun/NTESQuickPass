//
//  NTESQPCollectModel.h
//  NTESQuickPass
//
//  Created by Xu Ke on 2018/6/15.
//

#import <Foundation/Foundation.h>
#import "NTESBasePublicData.h"

typedef NS_ENUM(NSInteger, NTESQPErrorType) {
    NTESQPDNSError = 1,             // dns解析错误
    NTESQPConnectError,             // 连接错误
    NTESQPRequestTimeoutError,      // 接口请求超时
    NTESQPCheckout4GTimeoutError,   // 流量切换超时
    NTESQPOperatorReturnError,      // 返回值错误
    NTESQPSDKError,                 // SDK自身异常
    NTESQPOtherError,               // 其他错误
};

typedef NS_ENUM(NSInteger, NTESQPMonitorType) {
    NTESQPPrecheckMonitor = 1,      // 本机验证 preCheck接口
    NTESQPOperatorMonitor,          // 本机验证 运营商取号接口
    NTESSDKMonitor,                 // SDK本身
    NTESQLPrecheckMonitor,          // 一键登录 precheck接口
    NTESQLOperatorMonitor,          // 一键登录 运营商取号接口
};

@interface NTESQPCollectModel : NSObject

- (void)uploadError;

// 业务id，必传
@property (nonatomic, copy) NSString *businessId;

// 易盾token，非必传
@property (nonatomic, copy) NSString *token;

// 监控对象，必传
@property (nonatomic, assign) NTESQPMonitorType monitorType;

// 错误类型， 必传
@property (nonatomic, assign) NTESQPErrorType errorType;

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
@property (nonatomic, assign) NTESQPOperatorType ot;

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
