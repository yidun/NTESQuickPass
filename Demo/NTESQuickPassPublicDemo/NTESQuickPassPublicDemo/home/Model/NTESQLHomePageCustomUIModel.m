//
//  NTESQLHomePageCustomUIModel.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/19.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLHomePageCustomUIModel.h"
#import "UIColor+NTESQuickPass.h"
#import "NTESQPDemoDefines.h"
#import "NTESQLNavigationView.h"
#import "NTESToastView.h"

@implementation NTESQLHomePageCustomUIModel

+ (instancetype)getInstance {
    return [[NTESQLHomePageCustomUIModel alloc] init];
}

- (NTESQuickLoginModel *)configCustomUIModel:(NSInteger)popType
                                    withType:(NSInteger)portraitType
                             faceOrientation:(UIInterfaceOrientation)faceOrientation {
    
    NTESQuickLoginModel *model = [[NTESQuickLoginModel alloc] init];
    model.presentDirectionType = NTESPresentDirectionPresent;
    model.backgroundColor = [UIColor whiteColor];
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
    model.logoHidden = NO;

    /// 手机号码
    model.numberFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    model.numberOffsetX = 0;
    model.numberHeight = 27;

    ///  品牌
    model.brandFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    model.brandWidth = 200;
    model.brandBackgroundColor = [UIColor clearColor];
    model.brandHeight = 20;
    model.brandOffsetX = 0;

        /// 登录按钮
    model.logBtnTextFont = [UIFont systemFontOfSize:14];
    //    model.logBtnEnableImg = [UIImage imageNamed:@"logo"];
    model.logBtnTextColor = [UIColor whiteColor];
    model.logBtnText = @"确定登录";
    model.logBtnRadius = 8;
    model.logBtnHeight = 44;
    model.colors = @[(id)[UIColor ntes_colorWithHexString:@"#FFFFFF"].CGColor, (id)[UIColor ntes_colorWithHexString:@"#324DFF"].CGColor];

        /// 隐私协议
    model.appPrivacyText = @"登录即同意《默认》并授权NTESQuickPass PublicDemo 获得本机号码";
    model.uncheckedImg = [[UIImage imageNamed:@"login_kuang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkedImg = [[UIImage imageNamed:@"login_kuang_gou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkboxWH = 11;
    model.privacyState = YES;
    model.isOpenSwipeGesture = NO;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    model.closePopImg = [UIImage imageNamed:@"ic_close"];
    model.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    if (@available(iOS 13.0, *)) {
        model.currentStatusBarStyle = UIStatusBarStyleDarkContent;
        model.otherStatusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        model.currentStatusBarStyle = UIStatusBarStyleDefault;
        model.otherStatusBarStyle = UIStatusBarStyleDefault;
    }

    if (popType == 0) {/// 全屏模式
        model.authWindowPop = NTESAuthWindowPopFullScreen;
        model.numberColor = [UIColor whiteColor];
        model.brandColor = [UIColor whiteColor];
        model.privacyColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
        model.protocolColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];

        if (portraitType == 0) {
            /// 全屏、竖屏模式
            model.logoOffsetTopY = 148;
            model.numberOffsetTopY = 210;
            model.brandOffsetTopY = 239;
            model.logBtnOffsetTopY = 285;
            model.appPrivacyOriginBottomMargin = 63;
            model.logBtnOriginLeft = 40;
            model.logBtnOriginRight = 40;
        } else {
            /// 全屏、横屏模式
            model.logoOffsetTopY = 30 + 44;
            model.numberOffsetTopY = 92 + 44;
            model.brandOffsetTopY = 121 + 44;
            model.logBtnOffsetTopY = 167 + 44;
            model.appPrivacyOriginBottomMargin = 31;
            model.appPrivacyOriginLeftMargin = 200;
            model.appPrivacyOriginRightMargin = 90;
            model.logBtnOriginLeft = (SCREEN_WIDTH - 295) / 2;
            model.logBtnOriginRight = (SCREEN_WIDTH - 295) / 2;
        }
    } else { /// 弹窗模式
        model.logBtnOriginLeft = 30;
        model.logBtnOriginRight = 30;
        model.numberColor = [UIColor ntes_colorWithHexString:@"#333333"];
        model.brandColor = [UIColor ntes_colorWithHexString:@"#666666"];
        model.logoOffsetTopY = 30;
        model.numberOffsetTopY = 92;
        model.brandOffsetTopY = 121;
        model.logBtnOffsetTopY = 167;
        model.appPrivacyOriginBottomMargin = 20;
        model.authWindowPop = NTESAuthWindowPopCenter;
        model.appPrivacyOriginLeftMargin = 49;
        model.appPrivacyOriginRightMargin = 30;
        model.privacyColor = [UIColor ntes_colorWithHexString:@"#999999"];
        model.protocolColor = [UIColor ntes_colorWithHexString:@"#999999"];
        model.logBtnOffsetTopY = 167;

        model.scaleW = (295) / SCREEN_WIDTH;
        model.scaleH = (315) / SCREEN_HEIGHT;
        model.popBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

        model.uncheckedImg = [[UIImage imageNamed:@"checkBox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        model.checkedImg = [[UIImage imageNamed:@"checkedBox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    };

    CGFloat navHeight;
    if (portraitType == 0) {
        model.localVideoFileName = @"video_portrait.mp4";
        model.faceOrientation = UIInterfaceOrientationPortrait;
        navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44;
    } else {
        navHeight = 44;
        if (popType == 1) {
            model.logBtnOffsetTopY = 195;
        }
        model.faceOrientation = faceOrientation;
        model.loginDidDisapperfaceOrientation = faceOrientation;
        model.localVideoFileName = @"video_landscape.mp4";
    }
    model.isRepeatPlay = YES;
    model.customViewBlock = ^(UIView * _Nullable customView) {
        UILabel *otherLabel = [[UILabel alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
        [otherLabel addGestureRecognizer:tap];
        otherLabel.userInteractionEnabled = YES;
        otherLabel.text = @"其他登录方式";
        otherLabel.textAlignment = NSTextAlignmentCenter;
        otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#324DFF"];
        otherLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [customView addSubview:otherLabel];

        if (popType == 0) { /// 全屏模式
            NTESQLNavigationView *navigationView = [[NTESQLNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, navHeight)];
            navigationView.backgroundColor = [UIColor clearColor];
            [customView addSubview:navigationView];
            otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];

            if (portraitType == 0) { /// 全屏、竖屏模式
                [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(customView);
                    make.top.equalTo(customView).mas_offset(339);
                    make.height.mas_equalTo(16);
                }];
            } else { /// 全屏、横屏模式
                [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(customView);
                    make.top.equalTo(customView).mas_offset(227 + 44);
                    make.height.mas_equalTo(16);
                }];
            }
        } else {
            /// 弹窗模式
            otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#324DFF"];
            [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(customView);
                make.top.equalTo(customView).mas_offset(227);
                make.height.mas_equalTo(16);
            }];
        }
    };

    model.backActionBlock = ^{
        [NTESToastView showNotice:@"返回按钮点击"];
        NSLog(@"backAction");
    };

    model.loginActionBlock = ^(BOOL isChecked) {
        NSLog(@"loginAction");
        if (isChecked) {
            [NTESToastView showNotice:@"复选框已勾选"];
        } else {
            [NTESToastView showNotice:@"复选框未勾选"];
        }
    };

    model.checkActionBlock = ^(BOOL isChecked) {
        NSLog(@"checkAction");
        if (isChecked) {
            [NTESToastView showNotice:@"选中复选框"];
        } else {
            [NTESToastView showNotice:@"取消复选框"];
        }
    };

    model.privacyActionBlock = ^(int privacyType) {
        if (privacyType == 0) {
            [NTESToastView showNotice:@"点击默认协议"];
        } else if (privacyType == 1) {
            [NTESToastView showNotice:@"点击客户第1个协议"];
        } else if (privacyType == 2) {
            [NTESToastView showNotice:@"点击客户第2个协议"];
        }
        NSLog(@"privacyAction");
    };
    return model;
}

- (void)labelTapped {
    [[NTESQuickLoginManager sharedInstance] closeAuthController:^{
    
    }];;
}

@end
