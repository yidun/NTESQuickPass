//
//  NTESQLHomePageNetworkEntity.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/19.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLHomePageNetworkEntity.h"
#import "NTESQPDemoDefines.h"
#import "NTESDemoHttpRequest.h"
//#import <MJExtension/MJExtension.h>
#import "UIColor+NTESQuickPass.h"

@implementation NTESQLHomePageNetworkEntity

+ (void)requestModelConfig:(successHandle)successHandle {
    //   [NTESDemoHttpRequest startRequestWithURL:API_LOGIN_GET_CONFIG httpMethod:@"GET" requestData:nil finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
    //       dispatch_sync(dispatch_get_main_queue(), ^{
    //          if (data) {
    
    NSBundle *bundle = [NSBundle mainBundle];
    NSData * data = [NSData dataWithContentsOfFile:[bundle pathForResource:@"oneclick_login_config_ios" ofType:@"json"]];
    
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
    
    NTESQuickLoginModel *customModel = [[NTESQuickLoginModel alloc] init];
    if (dict.count == 0) {
        successHandle(customModel);
        return;
    }
    
    customModel.backgroundColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"backgroundColor"]];
    customModel.bgImage = [UIImage imageNamed:[dict objectForKey:@"bgImage"]];
    customModel.navTextFont = [UIFont systemFontOfSize:[[dict objectForKey:@"navTextFont"] intValue]];
    customModel.navText = [dict objectForKey:@"navText"];
    customModel.navTextColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"navTextColor"]];
    customModel.navBgColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"navBgColor"]];
    customModel.navTextHidden = [[dict objectForKey:@"navTextHidden"] boolValue];
    customModel.logoImg = [UIImage imageNamed:[dict objectForKey:@"logoIconName"]];
    customModel.numberColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"numberColor"]];
    customModel.numberFont = [UIFont systemFontOfSize:[[dict objectForKey:@"numberFont"] intValue]];
    customModel.brandColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"brandColor"]];
    customModel.brandFont = [UIFont systemFontOfSize:[[dict objectForKey:@"brandFont"] intValue]];
    customModel.brandHidden = [[dict objectForKey:@"brandHidden"] boolValue];
    customModel.brandHeight = [[dict objectForKey:@"brandHeight"] intValue];
    customModel.logBtnTextFont = [UIFont systemFontOfSize:[[dict objectForKey:@"loginBtnTextSize"] intValue]];
    customModel.logBtnText = [dict objectForKey:@"logBtnText"];
    customModel.logBtnTextColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"logBtnTextColor"]];
    customModel.logBtnUsableBGColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"logBtnUsableBGColor"]];
    //              customModel.uncheckedImg = [UIImage imageNamed:@"checkBox"];
    //              customModel.checkedImg = [UIImage imageNamed:@"checkedBox"];
    //              customModel.privacyColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"privacyColor"]];
    //              customModel.protocolColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"protocolColor"]];
    customModel.closePopImg = [UIImage imageNamed:[dict objectForKey:@"closePopImg"]];
    customModel.numberBackgroundColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"numberBackgroundColor"]];
    customModel.numberHeight = [[dict objectForKey:@"numberHeight"] intValue];
    customModel.numberCornerRadius = [[dict objectForKey:@"numberCornerRadius"] intValue];
    customModel.numberLeftContent = [dict objectForKey:@"numberLeftContent"];
    customModel.numberRightContent = [dict objectForKey:@"numberRightContent"];
    customModel.faceOrientation = [[dict objectForKey:@"faceOrientation"] intValue];
    customModel.logoHeight = [[dict objectForKey:@"logoHeight"] intValue];
    customModel.logoHidden = [[dict objectForKey:@"logoHidden"] boolValue];
    customModel.modalTransitionStyle = [[dict objectForKey:@"modalTransitionStyle"] intValue];
    customModel.privacyFont = [UIFont systemFontOfSize:[[dict objectForKey:@"privacyFont"] intValue]];
    int prograssHUDBlock = [[dict objectForKey:@"prograssHUDBlock"] intValue];
    if (prograssHUDBlock) {
        customModel.prograssHUDBlock = ^(UIView * _Nullable prograssHUDBlock) {
            NSLog(@"111");
        };
    }
    
    int loadingViewBlock = [[dict objectForKey:@"loadingViewBlock"] intValue];
    if (loadingViewBlock) {
        customModel.loadingViewBlock = ^(UIView * _Nullable customLoadingView) {
            NSLog(@"222");
        };
    }
    
    //              customModel.backActionBlock = ^{
    //                  [NTESToastView showNotice:@"返回按钮点击"];
    //                  NSLog(@"backAction");
    //              };
    
    customModel.closeActionBlock = ^{
        NSLog(@"closeActionBlock");
    };
    
    customModel.loginActionBlock = ^(BOOL isChecked) {
        NSLog(@"loginAction");
    };
    
    customModel.checkActionBlock = ^(BOOL isChecked) {
        NSLog(@"checkAction");
    };
    
    customModel.privacyActionBlock = ^(int privacyType) {
        NSLog(@"privacyAction");
    };
    
    customModel.appPrivacyText = [dict objectForKey:@"appPrivacyText"];
    customModel.appFPrivacyText = [dict objectForKey:@"appFPrivacyText"];
    customModel.appFPrivacyURL = [dict objectForKey:@"appFPrivacyURL"];
    customModel.appSPrivacyText = [dict objectForKey:@"appSPrivacyText"];
    customModel.appSPrivacyURL = [dict objectForKey:@"appSPrivacyURL"];
    customModel.appPrivacyOriginLeftMargin = [[dict objectForKey:@"appPrivacyOriginLeftMargin"] doubleValue];
    customModel.appPrivacyOriginRightMargin = [[dict objectForKey:@"appPrivacyOriginRightMargin"] doubleValue];
    customModel.appPrivacyOriginBottomMargin = [[dict objectForKey:@"appPrivacyOriginBottomMargin"] doubleValue];
    
    
    customModel.appFPrivacyTitleText = [dict objectForKey:@"appFPrivacyTitleText"];
    customModel.appPrivacyTitleText = [dict objectForKey:@"appPrivacyTitleText"];
    customModel.appSPrivacyTitleText = [dict objectForKey:@"appSPrivacyTitleText"];
    customModel.appPrivacyAlignment = [[dict objectForKey:@"appPrivacyAlignment"] intValue];
    customModel.isOpenSwipeGesture = [[dict objectForKey:@"isOpenSwipeGesture"] boolValue];
    customModel.logBtnOffsetTopY = [[dict objectForKey:@"logBtnOffsetTopY"] doubleValue];
    customModel.logBtnHeight = [[dict objectForKey:@"logBtnHeight"] doubleValue];
    customModel.brandOffsetTopY = [[dict objectForKey:@"brandOffsetTopY"] doubleValue];
    customModel.brandOffsetX = [[dict objectForKey:@"brandOffsetX"] doubleValue];
    customModel.numberOffsetTopY = [[dict objectForKey:@"numberOffsetTopY"] doubleValue];
    customModel.numberOffsetX = [[dict objectForKey:@"numberOffsetX"] doubleValue];
    customModel.checkBoxAlignment = [[dict objectForKey:@"checkBoxAlignment"] intValue];
    customModel.checkBoxMargin = [[dict objectForKey:@"checkBoxMargin"] intValue];
    customModel.checkboxWH = [[dict objectForKey:@"checkboxWH"] intValue];
    customModel.checkedHidden = [[dict objectForKey:@"checkedHidden"] boolValue];
    customModel.checkedImg = [UIImage imageNamed:[dict objectForKey:@"checkedImageName"]];
    customModel.uncheckedImg = [UIImage imageNamed:[dict objectForKey:@"unCheckedImageName"]];
    customModel.logBtnOriginRight = [[dict objectForKey:@"logBtnOriginRight"] intValue];
    customModel.logBtnOriginLeft = [[dict objectForKey:@"logBtnOriginLeft"] intValue];
    
    
    customModel.logoOffsetTopY = [[dict objectForKey:@"logoOffsetTopY"] doubleValue];
    customModel.logoOffsetX = [[dict objectForKey:@"logoOffsetX"] doubleValue];
    customModel.logBtnRadius = [[dict objectForKey:@"logBtnRadius"] intValue];
    customModel.logoWidth = [[dict objectForKey:@"logoWidth"] intValue];
    
    customModel.logoOffsetTopY = [[dict objectForKey:@"logoOffsetTopY"] doubleValue];
    customModel.logoOffsetX = [[dict objectForKey:@"logoOffsetX"] doubleValue];
    customModel.brandBackgroundColor = [UIColor ntes_colorWithHexString:@"brandBackgroundColor"];
    
    customModel.shouldHiddenNavReturnImg = [[dict objectForKey:@"shouldHiddenNavReturnImg"] boolValue];
    
    customModel.privacyNavReturnImg = [UIImage imageNamed:[dict objectForKey:@"privacyNavReturnImg"]];
    customModel.navReturnImgHeight = [[dict objectForKey:@"navReturnImgHeight"] intValue];
    customModel.navReturnImgLeftMargin = [[dict objectForKey:@"navReturnImgLeftMargin"] intValue];
    customModel.navReturnImgWidth = [[dict objectForKey:@"navReturnImgWidth"] intValue];
    customModel.videoURL = [dict objectForKey:@"videoURL"];
    customModel.navReturnImgBottomMargin = [[dict objectForKey:@"navReturnImgBottomMargin"] intValue];
    customModel.modalTransitionStyle = [[dict objectForKey:@"modalTransitionStyle"] intValue];
    customModel.navReturnImg = [UIImage imageNamed:[dict objectForKey:@"navReturnImg"]];
    customModel.logBtnHighlightedImg = [UIImage imageNamed:[dict objectForKey:@"logBtnHighlightedImg"]];
    customModel.navBarHidden = [[dict objectForKey:@"navBarHidden"] boolValue];
    customModel.logBtnEnableImg = [UIImage imageNamed:[dict objectForKey:@"logBtnEnableImg"]];
    int shouldHiddenPrivacyMarks = [[dict objectForKey:@"shouldHiddenPrivacyMarks"] intValue];
    if (shouldHiddenPrivacyMarks) {
        customModel.shouldHiddenPrivacyMarks = YES;
    } else {
        customModel.shouldHiddenPrivacyMarks = NO;
    }
    
    int navControl = [[dict objectForKey:@"navControl"] intValue];
    int navControlRightMargin = [[dict objectForKey:@"navControlRightMargin"] intValue];
    int navControlBottomMargin = [[dict objectForKey:@"navControlBottomMargin"] intValue];
    int navControlWidth = [[dict objectForKey:@"navControlWidth"] intValue];
    int navControlHeight = [[dict objectForKey:@"navControlHeight"] intValue];
    
    if (navControl) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 40, 40)];
        customModel.navControlRightMargin = navControlRightMargin;
        customModel.navControlBottomMargin = navControlBottomMargin;
        customModel.navControlWidth = navControlWidth;
        customModel.navControlHeight = navControlHeight;
        view.backgroundColor = [UIColor redColor];
        customModel.navControl = view;
    }
    
    int customNavBlock = [[dict objectForKey:@"customNavBlock"] intValue];
    int customViewBlock = [[dict objectForKey:@"customViewBlock"] intValue];
    if (customNavBlock) {
        customModel.customNavBlock = ^(UIView * _Nullable customNavView) {
            UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(100, 30, 40, 40)];
            navView.backgroundColor = [UIColor redColor];
            [customNavView addSubview:navView];
        };
    }
    if (customViewBlock) {
        customModel.customViewBlock = ^(UIView * _Nullable customView) {
            UIView *navView = [[UIView alloc] initWithFrame:CGRectMake(100, 100, 40, 40)];
            navView.backgroundColor = [UIColor redColor];
            [customView addSubview:navView];
        };
    }
    
    int currentStatusBarStyle = [[dict objectForKey:@"currentStatusBarStyle"] intValue];
    customModel.statusBarStyle = currentStatusBarStyle;
    
    //           NSString *str = [[NSBundle mainBundle] resourcePath];
    //           NSString *filePath = [NSString stringWithFormat:@"%@%@",str,@"play.mov"];
    
    //              customModel.localVideoFileName = @"video_landscape.mp4";
    customModel.isRepeatPlay = [[dict objectForKey:@"isRepeatPlay"] boolValue];
    
    //           customModel.faceOrientation = UIInterfaceOrientationLandscapeLeft;
    customModel.animationRepeatCount = [[dict objectForKey:@"animationRepeatCount"] integerValue];
    UIImage *image1 = [UIImage imageNamed:[dict objectForKey:@"image1"]];
    UIImage *image2 = [UIImage imageNamed:[dict objectForKey:@"image2"]];
    if (image1 && image2) {
        customModel.animationImages = @[image1, image2];
    }
    customModel.animationDuration = [[dict objectForKey:@"animationDuration"] integerValue];;
    customModel.brandColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:[UIColor redColor] andDarkColor:[UIColor blackColor]];
    UIColor *darkColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"navDarkColor"]] ? : [UIColor blackColor];
    UIColor *normalColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"navNormalColor"]] ? : [UIColor blackColor];
    
    customModel.navBgColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:normalColor andDarkColor:darkColor];
    customModel.protocolColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:[UIColor ntes_colorWithHexString:[dict objectForKey:@"protocolColor"]] ? : [UIColor blackColor] andDarkColor:[UIColor redColor]];
    customModel.privacyColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:[UIColor ntes_colorWithHexString:[dict objectForKey:@"privacyColor"]] ? : [UIColor blackColor] andDarkColor:[UIColor blackColor]];
    customModel.privacyState = [[dict objectForKey:@"privacyState"] boolValue];
    
    int authWindowPop = [[dict objectForKey:@"authWindowPop"] intValue];
    if (authWindowPop == 0) {
        customModel.authWindowPop = NTESAuthWindowPopFullScreen;
    } else if (authWindowPop == 1) {
        customModel.authWindowPop = NTESAuthWindowPopCenter;
    } else {
        customModel.authWindowPop = NTESAuthWindowPopBottom;
    }
    
    int closePopImgHeight = [[dict objectForKey:@"closePopImgHeight"] intValue];
    int closePopImgWidth = [[dict objectForKey:@"closePopImgWidth"] intValue];
    customModel.closePopImgWidth = closePopImgWidth;
    customModel.closePopImgHeight = closePopImgHeight;
    
    int closePopImgOriginY = [[dict objectForKey:@"closePopImgOriginY"] intValue];
    int closePopImgOriginX = [[dict objectForKey:@"closePopImgOriginX"] intValue];
    customModel.closePopImgOriginX = closePopImgOriginX;
    customModel.closePopImgOriginY = closePopImgOriginY;
    
    float authWindowHeight = [[dict objectForKey:@"authWindowHeight"] floatValue];
    customModel.authWindowHeight = authWindowHeight;
    
    float authWindowWidth = [[dict objectForKey:@"authWindowWidth"] floatValue];
    customModel.authWindowWidth = authWindowWidth;
    
    int authWindowCenterOriginX = [[dict objectForKey:@"authWindowCenterOriginX"] intValue];
    int authWindowCenterOriginY = [[dict objectForKey:@"authWindowCenterOriginY"] intValue];
    customModel.authWindowCenterOriginY = authWindowCenterOriginY;
    customModel.authWindowCenterOriginX = authWindowCenterOriginX;
    
    int popCenterCornerRadius = [[dict objectForKey:@"popCenterCornerRadius"] intValue];
    int popBottomCornerRadius = [[dict objectForKey:@"popBottomCornerRadius"] intValue];
    customModel.popBottomCornerRadius = popBottomCornerRadius;
    customModel.popCenterCornerRadius = popCenterCornerRadius;
    customModel.presentDirectionType = [[dict objectForKey:@"presentDirectionType"] intValue];
    
    BOOL videoMarkView =  [[dict objectForKey:@"videoMarkView"] boolValue];
    if (videoMarkView) {
        UIView *videoMarkView = [[UIView alloc] init];
        videoMarkView.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.3];
        customModel.videoMarkView = videoMarkView;
    }
    
    NSString *localVideoFileName = [dict objectForKey:@"localVideoFileName"];
    if (localVideoFileName) {
        customModel.localVideoFileName = localVideoFileName;
    }
    
    customModel.popBackgroundColor = [[UIColor ntes_colorWithHexString:[dict objectForKey:@"popBackgroundColor"]] colorWithAlphaComponent:[[dict objectForKey:@"alpha"] doubleValue]];
    customModel.openBackTapGestureRecognizer = true;
    customModel.customizedTransition = true;
    successHandle(customModel);
    NSLog(@"==%@",dict);
    //          }
    //       });
    //
    //   }];
    
}

- (nullable UIColor *)ntes_colorWithHexString:(NSString *)string {
    return [self ntes_colorWithHexString:string alpha:1.0f];
}

- (nullable UIColor *)ntes_colorWithHexString:(NSString *)string alpha:(CGFloat)alpha {
    NSString *pureHexString = [[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    if ([pureHexString hasPrefix:[@"#" uppercaseString]] || [pureHexString hasPrefix:[@"#" lowercaseString]]) {
        pureHexString = [pureHexString substringFromIndex:1];
    }
    
    CGFloat r, g, b, a;
    if (ntes_hexStrToRGBA(string, &r, &g, &b, &a)) {
        return [UIColor colorWithRed:r green:g blue:b alpha:a];
    }
    return nil;
}

static BOOL ntes_hexStrToRGBA(NSString *str, CGFloat *r, CGFloat *g, CGFloat *b, CGFloat *a) {
    NSCharacterSet *set = [NSCharacterSet whitespaceAndNewlineCharacterSet];
    str = [[str stringByTrimmingCharactersInSet:set] uppercaseString];
    if ([str hasPrefix:@"#"]) {
        str = [str substringFromIndex:1];
    } else if ([str hasPrefix:@"0X"]) {
        str = [str substringFromIndex:2];
    }
    
    NSUInteger length = [str length];
    //         RGB            RGBA          RRGGBB        RRGGBBAA
    if (length != 3 && length != 4 && length != 6 && length != 8) {
        return NO;
    }
    
    //RGB,RGBA,RRGGBB,RRGGBBAA
    if (length < 5) {
        *r = ntes_hexStrToInt([str substringWithRange:NSMakeRange(0, 1)]) / 255.0f;
        *g = ntes_hexStrToInt([str substringWithRange:NSMakeRange(1, 1)]) / 255.0f;
        *b = ntes_hexStrToInt([str substringWithRange:NSMakeRange(2, 1)]) / 255.0f;
        if (length == 4) {
            *a = ntes_hexStrToInt([str substringWithRange:NSMakeRange(3, 1)]) / 255.0f;
        } else {
            *a = 1;
        }
    } else {
        *r = ntes_hexStrToInt([str substringWithRange:NSMakeRange(0, 2)]) / 255.0f;
        *g = ntes_hexStrToInt([str substringWithRange:NSMakeRange(2, 2)]) / 255.0f;
        *b = ntes_hexStrToInt([str substringWithRange:NSMakeRange(4, 2)]) / 255.0f;
        if (length == 8) {
            *a = ntes_hexStrToInt([str substringWithRange:NSMakeRange(6, 2)]) / 255.0f;
        } else {
            *a = 1;
        }
    }
    return YES;
}

static inline NSUInteger ntes_hexStrToInt(NSString *str) {
    uint32_t result = 0;
    sscanf([str UTF8String], "%X", &result);
    return result;
}

- (UIImage *)loadImageWithName:(NSString *)name {
    if (name && name.length > 0) {
        UIImage *image = [UIImage imageNamed:name];
        return image;
    }else return nil;
}


@end

