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

#define TEST_MODE_QA

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

#define IS_IPHONE_X (([[UIApplication sharedApplication] statusBarFrame].size.height == 44) ? YES : NO)

#define DT_IS_IPHONEX_XS   (SCREEN_HEIGHT == 812.f)  //是否是iPhoneX、iPhoneXS
#define DT_IS_IPHONEXR_XSMax   (SCREEN_HEIGHT == 896.f)  //是否是iPhoneXR、iPhoneX Max
#define IS_IPHONEX_SET  (DT_IS_IPHONEX_XS||DT_IS_IPHONEXR_XSMax)  //是否是iPhoneX系列手机

#define IS_DEVICE_PORTRAIT (([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown || [[UIDevice currentDevice] orientation] == UIDeviceOrientationUnknown) ? YES : NO)
#define IS_DEVICE_LEFT (([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) ? YES : NO)

#define KWidthScale ((SCREEN_WIDTH) / 375.0)
#define KHeightScale ((SCREEN_HEIGHT) / 667.0)

#define UIColorFromHexA(hexValue, a)     [UIColor colorWithRed:(((hexValue & 0xFF0000) >> 16))/255.0f green:(((hexValue & 0xFF00) >> 8))/255.0f blue:((hexValue & 0xFF))/255.0f alpha:a]
#define UIColorFromHex(hexValue)        UIColorFromHexA(hexValue, 1.0f)

#define bottomPassText              @"本机校验服务 - 体验demo"
#define bottomLoginText             @"一键登录服务 - 体验demo"
#define bottomCopyRightText         @"© 1997-2020 网易公司"
#define homePageTitle               @"网易易盾"
#define quickPassTitle              @"本机校验DEMO"
#define quickLoginTitle             @"不拿用户数据，不做数据营销，安全可靠"
#define changeToQuickPass           @"点击切换至本机校验DEMO"
#define changeToQuickLogin          @"点击切换至一键登录DEMO"
#define registerTitle               @"注册"
#define loginTitle                  @"登录"
#define nextTitle                   @"注册/登录"
#define backToRoot                  @"返回首页"
#define verifyingQPText             @"本机校验中..."
#define verifyingQLText             @"一键登录中..."
#define quickLoginButtonTitle       @"本机号码一键登录"
#define quickRegisterButtonTitle    @"本机号码一键注册"
#define agreeText                   @"同意"
#define CMService                   @"《中国移动认证服务条款》"
#define CTService                   @"《中国电信认证服务条款》"

#define IS_NO_FIRST_OPEN                   @"IS_NO_FIRST_OPEN"

#import <Masonry/Masonry.h>

#define RGBA(r,g,b,a) [UIColor colorWithRed:r/255.0f green:g/255.0f blue:b/255.0f alpha:a]

#endif /* NTESQPDefines_h */


