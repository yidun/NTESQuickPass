//
//  WYUASDKErrorCode.h
//  TYRZSDK
//
//  Created by 谢鸿标 on 2018/10/24.
//  Copyright © 2018 com.CMCC.iOS. All rights reserved.
//

#ifndef WYUASDKErrorCode_h
#define WYUASDKErrorCode_h

#import <Foundation/Foundation.h>

typedef NSString *WYUASDKErrorCode;

//成功
static WYUASDKErrorCode const UASDKErrorCodeSuccess                = @"103000";
//数据解析异常
static WYUASDKErrorCode const UASDKErrorCodeProcessException       = @"200021";
//无网络
static WYUASDKErrorCode const UASDKErrorCodeNoNetwork              = @"200022";
//请求超时
static WYUASDKErrorCode const UASDKErrorCodeRequestTimeout         = @"200023";
//未知错误
static WYUASDKErrorCode const UASDKErrorCodeUnknownError           = @"200025";
//蜂窝未开启或不稳定
static WYUASDKErrorCode const UASDKErrorCodeNonCellularNetwork     = @"200027";
//网络请求出错(HTTP Code 非200)
static WYUASDKErrorCode const UASDKErrorCodeRequestError           = @"200028";
//非移动网关重定向失败
static WYUASDKErrorCode const UASDKErrorCodeWAPRedirectFailed      = @"200038";
//无SIM卡
static WYUASDKErrorCode const UASDKErrorCodePhoneWithoutSIM        = @"200048";
//Socket创建或发送接收数据失败
static WYUASDKErrorCode const UASDKErrorCodeSocketError            = @"200050";
//用户点击了“账号切换”按钮（自定义短信页面customSMS为YES才会返回）
static WYUASDKErrorCode const UASDKErrorCodeCustomSMSVC            = @"200060";
//显示登录"授权页面"被拦截（hooked）
static WYUASDKErrorCode const UASDKErrorCodeAutoVCisHooked         = @"200061";
////预取号不支持联通
//static WYUASDKErrorCode const UASDKErrorCodeNOSupportUnicom        = @"200062";
////预取号不支持电信
//static WYUASDKErrorCode const UASDKErrorCodeNOSupportTelecom       = @"200063";
//服务端返回数据异常
static WYUASDKErrorCode const UASDKErrorCodeExceptionData          = @"200064";
//CA根证书校验失败
static WYUASDKErrorCode const UASDKErrorCodeCAAuthFailed           = @"200072";
//本机号码校验仅支持移动手机号
static WYUASDKErrorCode const UASDKErrorCodeGetMoblieOnlyCMCC      = @"200080";
//服务器繁忙
static WYUASDKErrorCode const UASDKErrorCodeServerBusy             = @"200082";
//ppLocation为空
static WYUASDKErrorCode const UASDKErrorCodeLocationError          = @"200086";
//监听授权界面成功弹起
static WYUASDKErrorCode const UASDKSuccessGetAuthVCCode            = @"200087";
//当前网络不支持取号
static WYUASDKErrorCode const UASDKErrorCodeUnsupportedNetwork     = @"200096";

/**
 获取错误码描述

 @param code 错误码
 @return 返回对应描述
 */
FOUNDATION_EXPORT NSString *UASDKErrorDescription(WYUASDKErrorCode code);

#endif /* UASDKErrorCode_h */
