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
#import "NTESQPLoginViewController.h"

@interface NTESQLHomePageCustomUIModel()

@property (nonatomic, strong) UIViewController *viewController;

@end

@implementation NTESQLHomePageCustomUIModel

+ (instancetype)getInstance {
    return [[NTESQLHomePageCustomUIModel alloc] init];
}

- (NTESQuickLoginModel *)configCustomUIModel:(NSInteger)popType
                                    withType:(NSInteger)portraitType
                              viewController:(UIViewController *)viewController {
    self.viewController = viewController;
    
    NTESQuickLoginModel *model = [[NTESQuickLoginModel alloc] init];
    model.presentDirectionType = NTESPresentDirectionPush;
    model.navTextColor = [UIColor blueColor];
    model.navBgColor = [UIColor whiteColor];
    model.closePopImg = [UIImage imageNamed:@"checkedBox"];
    model.faceOrientation = NTESInterfaceOrientationAll;
    model.prefersHomeIndicatorHidden = YES;
    model.authWindowPop = NTESAuthWindowPopFullScreen;
    model.popBackgroundColor = [UIColor redColor];
    model.backgroundColor = [UIColor blackColor];
    
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
    model.brandHeight = 20;
    model.brandOffsetX = 0;

        /// 登录按钮
    model.logBtnTextFont = [UIFont systemFontOfSize:14];
    //    model.logBtnEnableImg = [UIImage imageNamed:@"logo"];
    model.logBtnTextColor = [UIColor whiteColor];
    model.logBtnText = @"确定登录";
    model.logBtnRadius = 8;
    model.logBtnHeight = 44;
    model.startPoint = CGPointMake(0, 0.5);
    model.endPoint = CGPointMake(1, 0.5);
    model.colors = @[(__bridge id)[UIColor redColor].CGColor, (__bridge id)[UIColor yellowColor].CGColor];

        /// 隐私协议
    /// 隐私协议
    model.appPrivacyText = @"登录即同意《默认》并授权获得《用户政策》和《用户隐私协议》以及《用户行为准则》和《用户相关条令》";
    model.appFPrivacyText = @"《用户政策》";
    model.appFPrivacyURL = @"https://dun.163.com/?from=baiduP_PP_PP664&sdclkid=AL2N15fsbJDiALjpALAD";
    model.appSPrivacyText = @"《用户隐私协议》";
    model.appSPrivacyURL = @"https://dun.163.com/?from=baiduP_PP_PP664&sdclkid=AL2N15fsbJDiALjpALAD";
    model.appTPrivacyText = @"《用户行为准则》";
    model.appTPrivacyURL = @"https://dun.163.com/?from=baiduP_PP_PP664&sdclkid=AL2N15fsbJDiALjpALAD";
    model.appFourPrivacyText = @"《用户相关条令》";
    model.appFourPrivacyURL = @"https://dun.163.com/?from=baiduP_PP_PP664&sdclkid=AL2N15fsbJDiALjpALAD";
    model.uncheckedImg = [[UIImage imageNamed:@"login_kuang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkedImg = [[UIImage imageNamed:@"login_kuang_gou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkboxWH = 11;
    model.privacyState = NO;
    model.isOpenSwipeGesture = NO;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    model.closePopImg = [UIImage imageNamed:@"ic_close"];
    model.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    model.appPrivacyWordSpacing = 1;
    model.appPrivacyLineSpacing = 5;
    model.progressColor = [UIColor redColor];
    
    
    if (@available(iOS 13.0, *)) {
        model.statusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        model.statusBarStyle = UIStatusBarStyleDefault;
    }

    if (popType == 0 || popType == 2) {/// 全屏模式
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

        model.authWindowWidth = 295;
        model.authWindowHeight = 315;
        model.popBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

        model.uncheckedImg = [[UIImage imageNamed:@"checkBox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        model.checkedImg = [[UIImage imageNamed:@"checkedBox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    };

    CGFloat navHeight;
    if (portraitType == 0) {
        model.localVideoFileName = @"video_portrait.mp4";
        navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44;
    } else {
        navHeight = 44;
        if (popType == 1) {
            model.logBtnOffsetTopY = 195;
        }
        model.localVideoFileName = @"video_landscape.mp4";
    }
    model.isRepeatPlay = YES;
    model.customViewBlock = ^(UIView * _Nullable customView) {
//        customView.backgroundColor = [UIColor blackColor];
        UILabel *otherLabel = [[UILabel alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(otherLabelTapped:)];
        [otherLabel addGestureRecognizer:tap];
        otherLabel.userInteractionEnabled = YES;
        otherLabel.text = @"其他登录方式";
        otherLabel.textAlignment = NSTextAlignmentCenter;
        otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#324DFF"];
        otherLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [customView addSubview:otherLabel];

        if (popType == 0 || popType == 2) { /// 全屏模式
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

    model.loginActionBlock = ^(BOOL isChecked) {
        NSLog(@"loginAction");
        if (isChecked) {
            NSLog(@"loginAction====复选框已勾选");
        } else {
            CABasicAnimation *shake = [CABasicAnimation animationWithKeyPath:@"transform.translation.x"];
                shake.fromValue = [NSNumber numberWithFloat:-5];
                shake.toValue = [NSNumber numberWithFloat:5];
                shake.duration = 0.1;//执行时间
                shake.autoreverses = YES;//是否重复
                shake.repeatCount = 2;//次数
            
                [[NTESQuickLoginManager sharedInstance].model.privacyTextView.layer addAnimation:shake forKey:@"shakeAnimation"];
            [[NTESQuickLoginManager sharedInstance].model.checkBox.layer addAnimation:shake forKey:@"shakeAnimation"];
            NSLog(@"loginAction====复选框未勾选");
        }
    };

    model.checkActionBlock = ^(BOOL isChecked) {
        NSLog(@"checkAction");
        if (isChecked) {
            NSLog(@"checkAction===选中复选框");
        } else {
            NSLog(@"checkAction===取消复选框");
        }
    };

    model.privacyActionBlock = ^(int privacyType) {
        if (privacyType == 0) {
            NSLog(@"点击默认协议");
        } else if (privacyType == 1) {
            NSLog(@"点击客户第1个协议");
        } else if (privacyType == 2) {
            NSLog(@"点击客户第2个协议");
        }
        NSLog(@"privacyAction");
    };
    model.privacyColor = [UIColor redColor];
    return model;
}

- (void)otherLabelTapped:(UITapGestureRecognizer *)tap {
    NTESQPLoginViewController *loginController = [[NTESQPLoginViewController alloc] init];
    [self.viewController.navigationController pushViewController:loginController animated:YES];
}

@end

