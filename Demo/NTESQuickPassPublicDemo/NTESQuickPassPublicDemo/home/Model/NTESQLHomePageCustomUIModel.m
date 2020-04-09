//
//  NTESQLHomePageCustomUIModel.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/19.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLHomePageCustomUIModel.h"

@implementation NTESQLHomePageCustomUIModel

+ (NTESQuickLoginCustomModel *)configCustomUIModel {
    
    NTESQuickLoginCustomModel *model = [[NTESQuickLoginCustomModel alloc] init];
    model.presentDirectionType = NTESPresentDirectionPush;
    model.backgroundColor = [UIColor whiteColor];
    model.authWindowPop = NTESAuthWindowPopFullScreen;
    model.closePopImg = [UIImage imageNamed:@"checkedBox"];
    model.faceOrientation = UIInterfaceOrientationPortrait;
    model.navBarHidden = NO;
    model.navTextFont = [UIFont systemFontOfSize:18];
    model.navTextColor = [UIColor redColor];
    model.navReturnImgLeftMargin = 6;
    model.navBgColor = [UIColor blueColor];
    model.navText = @"易盾登录";
    model.navTextHidden = NO;
    model.navReturnImg = [UIImage imageNamed:@"back-1"];

   /// logo
    model.logoImg = [UIImage imageNamed:@"logo1"];
    model.logoWidth = 50;
    model.logoHeight = 100;
    model.logoOffsetX = 0;
    model.logoOffsetX = 0;
    model.logoHidden = NO;

   /// 手机号码
    model.numberColor = [UIColor blackColor];
    model.numberFont = [UIFont systemFontOfSize:12];
    model.numberOffsetX = 0;
    model.numberOffsetTopY = 0;
    model.numberHeight = 27;

   ///  品牌
    model.brandColor = [UIColor redColor];
    model.brandFont = [UIFont systemFontOfSize:12];
    model.brandWidth = 200;
    model.brandHeight = 20;
    model.brandOffsetX = 0;
    model.brandOffsetX = 0;
    model.logBtnTextFont = [UIFont systemFontOfSize:14];
    model.logBtnTextColor = [UIColor redColor];
    model.logBtnRadius = 12;
    model.logBtnText = @"本机登录";
    model.logBtnUsableBGColor = [UIColor blueColor];
    model.logBtnHeight = 44;
    model.logBtnEnableImg = [UIImage imageNamed:@"login_able"];
    model.logBtnDisableImg = [UIImage imageNamed:@"login_disable"];

    UIButton *wechatButton = [[UIButton alloc] init];
    wechatButton.backgroundColor = [UIColor redColor];
    [wechatButton setBackgroundImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
    UIButton *paypalButton = [[UIButton alloc] init];
    [paypalButton setBackgroundImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
    paypalButton.backgroundColor = [UIColor redColor];
    UIButton *qqButton = [[UIButton alloc] init];
    [qqButton setBackgroundImage:[UIImage imageNamed:@"checkedBox"] forState:UIControlStateNormal];
    qqButton.backgroundColor = [UIColor redColor];

    model.appPrivacyText = @"登录即同意《默认》和《用户隐私协议》";
    model.appFPrivacyText = @"《用户隐私协议》";
    model.appFPrivacyURL = @"http://www.baidu.com";
    model.appSPrivacyText = @"《用户服务条款》";
    model.appSPrivacyURL = @"http://www.baidu.com";
//    model.appPrivacyOriginLeftMargin = 200;
    model.appFPrivacyTitleText = @"hhahha";
 
    model.uncheckedImg = [UIImage imageNamed:@"checkBox"];
    model.checkedImg = [UIImage imageNamed:@"checkedBox"];
    model.privacyState = NO;
    model.checkedHidden = NO;
    model.isOpenSwipeGesture = NO;

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
