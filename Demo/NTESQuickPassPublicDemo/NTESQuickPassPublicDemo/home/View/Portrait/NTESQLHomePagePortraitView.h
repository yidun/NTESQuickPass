//
//  NTESQLHomePagePortraitView.h
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/3.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESQLHomePagePortraitViewDelegate <NSObject>

- (void)loginButtonWithFullScreenDidTipped:(UIButton *_Nullable)sender;
- (void)loginButtonWithPopScreenDidTipped:(UIButton *_Nullable)sender;
- (void)loginButtonWithLocalPhoneDidTipped:(UIButton *_Nonnull)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NTESQLHomePagePortraitView : UIView

@property (nonatomic, weak) id<NTESQLHomePagePortraitViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
