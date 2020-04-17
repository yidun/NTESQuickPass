//
//  NTESQLHomePagePortraitBottomView.h
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/3.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESQLHomePagePortraitBottomViewDelegate <NSObject>

- (void)loginButtonWithFullScreenDidTipped:(UIButton *_Nullable)sender;
- (void)loginButtonWithPopScreenDidTipped:(UIButton *_Nullable)sender;
- (void)loginButtonWithLocalPhoneDidTipped:(UIButton *_Nonnull)sender;

@end

typedef NS_ENUM(NSUInteger, NTESQLHomePagePortraitType) {
    NTESQLHomePagePortraitTypeLogin = 0, /// 一键登录
    NTESQLHomePagePortraitTypeCheck, /// 本机校验
};

NS_ASSUME_NONNULL_BEGIN

@interface NTESQLHomePagePortraitBottomView : UIView

@property (nonatomic, assign) NTESQLHomePagePortraitType type;
@property (nonatomic, weak) id<NTESQLHomePagePortraitBottomViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
