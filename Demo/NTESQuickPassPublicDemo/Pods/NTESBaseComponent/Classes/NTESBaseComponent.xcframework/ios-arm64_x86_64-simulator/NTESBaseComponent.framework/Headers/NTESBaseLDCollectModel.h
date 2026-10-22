//
//  NTESBaseLDCollectModel.h
//  NTESBaseComponent
//
//  Created by 罗礼豪 on 2021/3/23.
//  Copyright © 2021 罗礼豪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NTESLDErrorType) {
    NTESBaseLDSDKInnerError = 1,        // SDK自身异常(crash等)
    NTESBaseLDSDKNoPass,                // 活体检测不通过
    NTESBaseLDSDKGetconf,               // getconf接口异常
    NTESBaseLDSDKCheck,                 // check接口异常
    NTESBaseLDUploadImageError,         // 上传图片失败
    NTESBaseLDAIInitError,              // 算法引擎初始化失败
    NTESBaseLDOpenCameraError,          // 打开相机失败
    NTESBaseLDLocalCheckError,          // 本地检测动作不通过
    NTESBaseLDActiveExit,               // 主动退出
    NTESBaseLDNOSUoloadFailure,         // 上传NOS失败
    NTESBaseLDAlgorithmWriteFailure,    // 算法写入沙盒失败
};


NS_ASSUME_NONNULL_BEGIN

@interface NTESBaseLDCollectModel : NSObject

- (void)uploadError;

// 错误类型， 必传
@property (nonatomic, assign) NTESLDErrorType type;

// pid，必传
@property (nonatomic, copy) NSString *pid;

// 业务id，必传
@property (nonatomic, copy) NSString *bid;

// 终端类型
@property (nonatomic, copy) NSString *tt;

// 发生异常时客户端时间戳，必传
@property (nonatomic, copy) NSString *nts;

// 本地获取到的ip
@property (nonatomic, copy) NSString *ip;

// 错误类型描述
@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSMutableDictionary *value;

// getconf接口返回的token，如果有
@property (nonatomic, copy) NSString *tk;

// 服务端接口响应码，如果有
@property (nonatomic, copy) NSNumber *hc;

// 不通过的动作类型
@property (nonatomic, copy) NSString *fa;

// 机型
@property (nonatomic, copy) NSString *m;

// sdk版本
@property (nonatomic, copy) NSString *v;

// 操作系统
@property (nonatomic, copy) NSString *os;

// getconf接口返回的token
@property (nonatomic, strong) NSString *token;

// nos 服务objectName
@property (nonatomic, strong) NSString *objectName;

@end

NS_ASSUME_NONNULL_END
