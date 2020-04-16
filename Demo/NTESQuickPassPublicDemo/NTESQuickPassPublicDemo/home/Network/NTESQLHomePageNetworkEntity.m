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
   [NTESDemoHttpRequest startRequestWithURL:API_LOGIN_GET_CONFIG httpMethod:@"GET" requestData:nil finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
//       if (data) {
//          NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//           NTESQuickLoginModel *customModel = [NTESQuickLoginModel mj_objectWithKeyValues:dict];
//           customModel.backgroundColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"backgroundColor"]];
//           customModel.navTextFont = [UIFont systemFontOfSize:[[dict objectForKey:@"navTextFont"] intValue]];
//           customModel.navTextColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"navTextColor"]];
//           customModel.navBgColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"navBgColor"]];
//           customModel.logoImg = [UIImage imageNamed:[dict objectForKey:@"logoIconName"]];
//           customModel.numberColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"numberColor"]];
//           customModel.numberFont = [UIFont systemFontOfSize:[[dict objectForKey:@"numberFont"] intValue]];
//           customModel.brandColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"brandColor"]];
//           customModel.brandFont = [UIFont systemFontOfSize:[[dict objectForKey:@"brandFont"] intValue]];
//           customModel.brandHidden = [[dict objectForKey:@"brandHidden"] boolValue];
//           customModel.logBtnTextFont = [UIFont systemFontOfSize:[[dict objectForKey:@"loginBtnTextSize"] intValue]];
//           customModel.logBtnTextColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"logBtnTextColor"]];
//           customModel.logBtnUsableBGColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"logBtnUsableBGColor"]];
//           customModel.uncheckedImg = [UIImage imageNamed:@"checkBox"];
//           customModel.checkedImg = [UIImage imageNamed:@"checkedBox"];
//           customModel.privacyColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"privacyColor"]];
//           customModel.protocolColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"protocolColor"]];
//           customModel.closePopImg = [UIImage imageNamed:[dict objectForKey:@"closePopImg"]];
//           customModel.numberBackgroundColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"numberBackgroundColor"]];
//           customModel.numberCornerRadius = [[dict objectForKey:@"numberCornerRadius"] intValue];
//           customModel.numberLeftContent = [dict objectForKey:@"numberLeftContent"];
//           customModel.numberRightContent = [dict objectForKey:@"numberRightContent"];
//           customModel.faceOrientation = [[dict objectForKey:@"faceOrientation"] intValue];
//           customModel.privacyFont = [UIFont systemFontOfSize:[[dict objectForKey:@"privacyFont"] intValue]];
//           
//           customModel.appPrivacyText = [dict objectForKey:@"appPrivacyText"];
//           customModel.appFPrivacyText = [dict objectForKey:@"appFPrivacyText"];
//           customModel.appFPrivacyURL = [dict objectForKey:@"appFPrivacyURL"];
//           customModel.appSPrivacyText = [dict objectForKey:@"appSPrivacyText"];
//           customModel.appSPrivacyURL = [dict objectForKey:@"appSPrivacyURL"];
//           customModel.appPrivacyOriginLeftMargin = [[dict objectForKey:@"appPrivacyOriginLeftMargin"] doubleValue];
//           customModel.appFPrivacyTitleText = [dict objectForKey:@"appFPrivacyTitleText"];
//           customModel.appPrivacyTitleText = [dict objectForKey:@"appPrivacyTitleText"];
//           customModel.appSPrivacyTitleText = [dict objectForKey:@"appSPrivacyTitleText"];
//           customModel.appPrivacyAlignment = [[dict objectForKey:@"appPrivacyAlignment"] intValue];
//           customModel.isOpenSwipeGesture = [[dict objectForKey:@"isOpenSwipeGesture"] boolValue];
//           customModel.logBtnOffsetTopY = [[dict objectForKey:@"logBtnOffsetTopY"] doubleValue];
//           customModel.logBtnHeight = [[dict objectForKey:@"logBtnHeight"] doubleValue];
//           customModel.brandOffsetTopY = [[dict objectForKey:@"brandOffsetTopY"] doubleValue];
//           customModel.brandOffsetX = [[dict objectForKey:@"brandOffsetX"] doubleValue];
//           customModel.numberOffsetTopY = [[dict objectForKey:@"numberOffsetTopY"] doubleValue];
//           customModel.numberOffsetX = [[dict objectForKey:@"numberOffsetX"] doubleValue];
//           
//           customModel.logoOffsetTopY = [[dict objectForKey:@"logoOffsetTopY"] doubleValue];
//           customModel.logoOffsetX = [[dict objectForKey:@"logoOffsetX"] doubleValue];
//           
//           customModel.logoOffsetTopY = [[dict objectForKey:@"logoOffsetTopY"] doubleValue];
//           customModel.logoOffsetX = [[dict objectForKey:@"logoOffsetX"] doubleValue];
//
//           customModel.videoURL = [dict objectForKey:@"videoURL"];
//           
////           NSString *str = [[NSBundle mainBundle] resourcePath];
////           NSString *filePath = [NSString stringWithFormat:@"%@%@",str,@"play.mov"];
//
//           customModel.localVideoFileName = [dict objectForKey:@"localVideoFileName"];
//           customModel.isRepeatPlay = [[dict objectForKey:@"isRepeatPlay"] boolValue];
//           
////           customModel.faceOrientation = UIInterfaceOrientationLandscapeLeft;
//           customModel.animationRepeatCount = [[dict objectForKey:@"animationRepeatCount"] integerValue];
//           UIImage *image1 = [UIImage imageNamed:[dict objectForKey:@"image1"]];
//           UIImage *image2 = [UIImage imageNamed:[dict objectForKey:@"image2"]];
//           if (image1 && image2) {
//               customModel.animationImages = @[image1, image2];
//           }
//           customModel.animationDuration = [[dict objectForKey:@"animationDuration"] integerValue];;
//           
////           customModel.x = [[dict objectForKey:@"x"] doubleValue];
////           customModel.y = [[dict objectForKey:@"y"] doubleValue];
////           customModel.width = [[dict objectForKey:@"width"] doubleValue];
////           customModel.height = [[dict objectForKey:@"height"] doubleValue];
////           customModel.custombackgroundcolor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"custombackgroundcolor"]];
////
////           customModel.navX = [[dict objectForKey:@"navX"] doubleValue];
////           customModel.navY = [[dict objectForKey:@"navY"] doubleValue];
////           customModel.navWidth = [[dict objectForKey:@"navWidth"] doubleValue];
////           customModel.navHeight = [[dict objectForKey:@"navHeight"] doubleValue];
//////
//           customModel.brandColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:[UIColor redColor] andDarkColor:[UIColor blackColor]];
//           UIColor *darkColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"navDarkColor"]];
//           UIColor *normalColor = [UIColor ntes_colorWithHexString:[dict objectForKey:@"navNormalColor"]];
//           
//           customModel.navBgColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:normalColor andDarkColor:darkColor];
//           customModel.protocolColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:[UIColor redColor] andDarkColor:[UIColor blackColor]];
//           customModel.privacyColor = [UIColor ntes_colorWithDynamicProviderWithWhiteColor:[UIColor blackColor] andDarkColor:[UIColor redColor]];
//           
//           customModel.popBackgroundColor = [[UIColor ntes_colorWithHexString:[dict objectForKey:@"popBackgroundColor"]] colorWithAlphaComponent:[[dict objectForKey:@"alpha"] doubleValue]];
// 
//           successHandle(customModel);
//           NSLog(@"==%@",dict);
//       }
   }];
}

@end

