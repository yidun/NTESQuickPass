//
//  UIColor+NTESQuickPass.h
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/17.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIColor (NTESQuickPass)

/// 应用适配暗黑模式
/// @param whiteColor 正常状态下字体的颜色
/// @param darkColor  暗黑转态下字体的颜色
+ (nullable UIColor *)ntes_colorWithDynamicProviderWithWhiteColor:(UIColor *)whiteColor andDarkColor:(UIColor *)darkColor;

+ (nullable UIColor *)ntes_colorWithHexString:(NSString *)string;

@end

NS_ASSUME_NONNULL_END
