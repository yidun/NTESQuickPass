//
//  NTESQLHomePageCustomUIModel.h
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/19.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <NTESQuickPass/NTESQuickPass.h>

NS_ASSUME_NONNULL_BEGIN

@interface NTESQLHomePageCustomUIModel : NSObject

+ (instancetype)getInstance;

/// 配置登录界面数据模型
/// @param popType 弹窗的样式
/// @param portraitType 横竖屏Type
- (NTESQuickLoginModel *)configCustomUIModel:(NSInteger)popType
                                    withType:(NSInteger)portraitType
                              viewController:(UIViewController *)viewController;

@end

NS_ASSUME_NONNULL_END
