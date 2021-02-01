//
//  NTESLDCollectModel.h
//  NTESBaseComponent
//
//  Created by 罗礼豪 on 2021/1/25.
//  Copyright © 2021 罗礼豪. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, NTESLDErrorType) {
    NTESLDSDKInnerError = 1,        // SDK自身异常(crash等)
    NTESLDSDKNoPass,                // SDK检测异常(动作不通过等)
    NTESLDSDKGetconf,               // getconf接口异常
    NTESLDSDKCheck                  // check接口异常
};


NS_ASSUME_NONNULL_BEGIN

@interface NTESLDCollectModel : NSObject

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

@end

NS_ASSUME_NONNULL_END
