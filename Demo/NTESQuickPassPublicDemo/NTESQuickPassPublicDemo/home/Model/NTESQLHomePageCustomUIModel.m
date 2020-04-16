//
//  NTESQLHomePageCustomUIModel.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/19.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLHomePageCustomUIModel.h"
#import "UIColor+NTESQuickPass.h"

@implementation NTESQLHomePageCustomUIModel

+ (NTESQuickLoginModel *)configCustomUIModel {
    
    NTESQuickLoginModel *model = [[NTESQuickLoginModel alloc] init];
    model.presentDirectionType = NTESPresentDirectionPush;
    model.backgroundColor = [UIColor whiteColor];
//    model.authWindowPop = NTESAuthWindowPopFullScreen;
//    model.navText = @"免密登录";
    model.navTextColor = [UIColor blueColor];
    model.navBgColor = [UIColor whiteColor];
    model.closePopImg = [UIImage imageNamed:@"checkedBox"];
    model.faceOrientation = UIInterfaceOrientationPortrait;
    model.navBarHidden = YES;
    model.authWindowPop = NTESAuthWindowPopCenter;

   /// logo
    model.logoImg = [UIImage imageNamed:@"login_logo-1"];
    model.logoWidth = 52;
    model.logoHeight = 52;
    model.logoOffsetTopY = 148;
    model.logoHidden = NO;

   /// 手机号码
    model.numberColor = [UIColor whiteColor];
    model.numberFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    model.numberOffsetX = 0;
    model.numberOffsetTopY = 210;
    model.numberHeight = 27;

   ///  品牌
    model.brandColor = [UIColor whiteColor];
    model.brandFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    model.brandWidth = 200;
    model.brandBackgroundColor = [UIColor clearColor];
    model.brandHeight = 20;
    model.brandOffsetTopY = 239;
    model.brandOffsetX = 0;

    /// 登录按钮
    model.logBtnTextFont = [UIFont systemFontOfSize:14];
//    model.logBtnEnableImg = [UIImage imageNamed:@"logo"];
    model.logBtnTextColor = [UIColor whiteColor];
    model.logBtnOffsetTopY = 285;
    model.logBtnText = @"确定登录";
    model.logBtnRadius = 8;
    model.logBtnUsableBGColor = [UIColor blueColor];
    model.logBtnHeight = 44;

    /// 隐私协议
    model.appPrivacyText = @"登录即同意《默认》并授权NTESQuick PassPublicDemo 获得本机号码";
//    model.appFPrivacyText = @"用户隐私协议";
//    model.appFPrivacyURL = @"http://www.baidu.com";
//    model.appSPrivacyText = @"《用户服务条款》";
//    model.appSPrivacyURL = @"http://www.baidu.com";
//    model.appFPrivacyTitleText = @"hhahha";
    model.uncheckedImg = [UIImage imageNamed:@"checkBox"];
    model.checkedImg = [UIImage imageNamed:@"checkedBox"];
    model.privacyState = YES;
    model.checkedHidden = NO;
    model.isOpenSwipeGesture = NO;
    model.appPrivacyOriginBottomMargin = 63;

    model.privacyColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    model.protocolColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];

    model.closePopImg = [UIImage imageNamed:@"ic_close"];
    if (@available(iOS 13.0, *)) {
       model.currentStatusBarStyle = UIStatusBarStyleDarkContent;
       model.otherStatusBarStyle = UIStatusBarStyleDarkContent;
    } else {
       model.currentStatusBarStyle = UIStatusBarStyleDefault;
       model.otherStatusBarStyle = UIStatusBarStyleLightContent;
    }
    return model;
}

@end
