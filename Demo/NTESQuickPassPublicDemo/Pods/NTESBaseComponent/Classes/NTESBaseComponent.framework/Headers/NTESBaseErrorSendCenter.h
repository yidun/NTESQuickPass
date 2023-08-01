//
//  NTESBaseErrorSendCenter.h
//  NTESBaseComponent
//
//  Created by 罗礼豪 on 2021/1/20.
//  Copyright © 2021 罗礼豪. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "NTESBaseQPCollectModel.h"
#import "NTESBaseLDCollectModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface NTESBaseErrorSendCenter : NSObject

/**
 活体检测数据模型
 */
@property (nonatomic, strong) NTESBaseLDCollectModel *collectModel;

/**
 号码认证数据模型
 */
@property (nonatomic, strong) NTESBaseQPCollectModel *collectQPModel;

+ (NTESBaseErrorSendCenter *)sharedInstance;

/**
 初始化活体模型
 */
- (void)__initLDErrorModel;

/**
 初始化号码认证模型
 */
- (void)__initQPErrorModel;

/**
 *  @abstract   活体检测上传错误信息
 *
 *  @param      errorType       错误类型
 *  @param      message           错误的详细信息
 *  @param      httpCode         接口返回的code码
 *  @param      actionType     动作类型
 */
- (void)collectLDErrorType:(NTESLDErrorType)errorType
                messags:(NSString * _Nullable)message
               httpCode:(NSNumber * _Nullable)httpCode
              actionType:(NSString *_Nullable)actionType;

/**
 *  @abstract   活体检测上传错误信息
 *
 *  @param      errorType       错误类型
 *  @param      objectName    桶名
 *  @param      httpCode         接口返回的code码
 *  @param      actionType     动作类型
 */
- (void)collectLDErrorType:(NTESLDErrorType)errorType
                objectName:(NSString * _Nullable)objectName
                messags:(NSString * _Nullable)message
               httpCode:(NSNumber * _Nullable)httpCode
              actionType:(NSString *_Nullable)actionType;

/**
 *  @abstract   一键登录错误信息上报
 *
 *  @param      errorType       错误类型
 *  @param      monitorType   业务类型
 *  @param      message           错误的详细信息
 *  @param      code                  运行商code码
 *  @param      httpCode         接口返回的code码
 *  @param      requestTime   请求时间
 *  @param      requestURL     请求地址
 */
- (void)collectQLErrorType:(NTESBaseQPErrorType)errorType
             monitorType:(NTESBaseQPMonitorType)monitorType
                 message:(NSString *)message
                    code:(NSNumber *)code
                httpCode:(NSNumber *)httpCode
             requestTime:(NSNumber *)requestTime
              requestURL:(NSString *)requestURL;

/**
 *  @abstract   本机校验错误信息上报
 *
 *  @param      errorType       错误类型
 *  @param      monitorType   业务类型
 *  @param      message           错误的详细信息
 *  @param      code                  运行商code码
 *  @param      httpCode         接口返回的code码
 *  @param      requestTime   请求时间
 *  @param      requestURL     请求地址
 */
- (void)collectQPErrorType:(NTESBaseQPErrorType)errorType
             monitorType:(NTESBaseQPMonitorType)monitorType
                 message:(NSString *)message
                    code:(NSNumber *)code
                httpCode:(NSNumber *)httpCode
             requestTime:(NSNumber *)requestTime
              requestURL:(NSString *)requestURL;

/**
 *  @abstract   开始活体检测错误上传
 *
 */
- (void)startLDCollect;

/**
 *  @abstract   开始一键登录错误上传
 *
 */
- (void)startQLCollect;

/**
 *  @abstract   开始本机校验错误上传
 *
 */
- (void)startQPCollect;

@end

NS_ASSUME_NONNULL_END
