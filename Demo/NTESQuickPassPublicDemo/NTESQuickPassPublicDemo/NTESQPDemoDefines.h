//
//  NTESQPDefines.h
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#ifndef NTESQPDemoDefines_h
#define NTESQPDemoDefines_h

//#define TEST_MODE

//#define TEST_MODE_QA

#ifdef TEST_MODE
#define QL_BUSINESSID                @"3cc9408f47414f03a75947c108e60034"
#define QP_BUSINESSID                @"35d60d532b4f4c4c84f3e243c1989a27"
#define API_LOGIN_TOKEN_QLCHECK      @"http://eredar-server-test.nis.netease.com/api/login/oneclick"
#define API_LOGIN_TOKEN_QPCHECK      @"http://eredar-server-test.nis.netease.com/api/login/token"
#define API_LOGIN_CODE_CHECK         @"http://eredar-server-test.nis.netease.com/api/login/code"
#define API_LOGIN_SMS_SEND           @"http://eredar-server-test.nis.netease.com/api/sms/send"
#else
#define QL_BUSINESSID                @"b55f3c7d4729455c9c3fb23872065401"
#define QP_BUSINESSID                @"1412f24fcadc4f1e9b11590221a3e4eb"
#define API_LOGIN_TOKEN_QLCHECK      @"https://ye.dun.163yun.com/api/login/oneclick"
#define API_LOGIN_TOKEN_QPCHECK      @"https://ye.dun.163yun.com/api/login/token"
#define API_LOGIN_CODE_CHECK         @"https://ye.dun.163yun.com/api/login/code"
#define API_LOGIN_SMS_SEND           @"https://ye.dun.163yun.com/api/sms/send"
#endif

#define CMServiceHTML                @"https://wap.cmpassport.com/resources/html/contract.html"
#define CTServiceHTML                @"https://e.189.cn/sdk/agreement/detail.do?hidetop=true"

#define NUMBER_OF_NONCE              32
#define VERSION                      @"v1"
#define RANGE_TABLE                  @"kot8AB45jF6CDaUVWubcdKLZefgMpNOxyz01PQRnTvw23XYhiG7rsEqJHI9Slm"

#ifndef __OPTIMIZE__
#define NSLog(...) NSLog(__VA_ARGS__)
#else
#define NSLog(...) {}
#endif

#define WeakSelf(type) __weak __typeof__(type) weakSelf = type;
#define StrongSelf(type) __strong __typeof__(type) strongSelf = type;

#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width

#define IS_IPHONE_X (SCREEN_HEIGHT == 812.0f ? YES : NO)

#define KWidthScale ((SCREEN_WIDTH) / 375.0)
#define KHeightScale (IS_IPHONE_X ? ((SCREEN_HEIGHT) / 812.0) : ((SCREEN_HEIGHT) / 667.0))

#define UIColorFromHexA(hexValue, a)     [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:a]
#define UIColorFromHex(hexValue)        UIColorFromHexA(hexValue, 1.0f)

#define bottomPassText              @"本机校验服务 - 体验demo"
#define bottomLoginText             @"一键登录服务 - 体验demo"
#define bottomCopyRightText         @"© 1997-2019 网易公司"
#define homePageTitle               @"欢迎体验，"
#define quickPassTitle              @"本机校验DEMO"
#define quickLoginTitle             @"一键登录DEMO"
#define changeToQuickPass           @"点击切换至本机校验DEMO"
#define changeToQuickLogin          @"点击切换至一键登录DEMO"
#define registerTitle               @"注册"
#define loginTitle                  @"登录"
#define nextTitle                   @"下一步"
#define backToRoot                  @"返回DEMO"
#define verifyingQPText             @"本机校验中..."
#define verifyingQLText             @"一键登录中..."
#define quickLoginButtonTitle       @"本机号码一键登录"
#define quickRegisterButtonTitle    @"本机号码一键注册"
#define agreeText                   @"同意"
#define CMService                   @"《中国移动认证服务条款》"
#define CTService                   @"《中国电信认证服务条款》"

#import <Masonry/Masonry.h>

#endif /* NTESQPDefines_h */
