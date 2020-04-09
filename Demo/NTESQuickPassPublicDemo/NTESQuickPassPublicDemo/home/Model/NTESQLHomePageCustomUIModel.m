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
    model.backgroundColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:[UIColor whiteColor] andDarkColor:[UIColor blackColor]];
    model.authWindowPop = NTESAuthWindowPopFullScreen;
    model.closePopImg = [UIImage imageNamed:@"checkedBox"];
    model.faceOrientation = UIInterfaceOrientationPortrait;
    model.navBarHidden = NO;
    model.navTextFont = [UIFont systemFontOfSize:18];
    model.navTextColor = [UIColor redColor];
    model.navReturnImgLeftMargin = 6;
    model.navBgColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:[UIColor blueColor] andDarkColor:[UIColor whiteColor]];
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

    model.appPrivacyText = @"登录即同意《默认》和《用户隐私协议》";
    model.appFPrivacyText = @"《用户隐私协议》";
    model.appFPrivacyURL = @"http://www.baidu.com";
    model.appSPrivacyText = @"《用户服务条款》";
    model.appSPrivacyURL = @"http://www.baidu.com";
    model.appFPrivacyTitleText = @"hhahha";
    
    if (model.authWindowPop == NTESAuthWindowPopFullScreen) {
        if (model.faceOrientation == UIInterfaceOrientationPortrait) {
            model.localVideoFileName = @"video_portrait.mp4";
        } else {
            model.localVideoFileName = @"video_landscape.mp4";
        }
        model.isRepeatPlay = YES;
    }
   
    model.uncheckedImg = [UIImage imageNamed:@"checkBox"];
    model.checkedImg = [UIImage imageNamed:@"checkedBox"];
    model.privacyState = NO;
    model.checkedHidden = NO;
    model.isOpenSwipeGesture = NO;
    model.popBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.7];

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
