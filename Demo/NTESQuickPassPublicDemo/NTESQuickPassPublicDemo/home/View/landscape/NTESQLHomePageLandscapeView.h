//
//  NTESQLHomePageLandscapeView.h
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/7.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESQLHomePageLandscapeViewDelegate <NSObject>

- (void)loginButtonWithLandscapeFullScreenDidTipped:(UIButton *_Nullable)sender;
- (void)loginButtonWithLandscapePopScreenDidTipped:(UIButton *_Nullable)sender;
- (void)loginButtonWithLandscapeLocalPhoneDidTipped:(UIButton *_Nonnull)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NTESQLHomePageLandscapeView : UIView

@property (nonatomic, weak) id<NTESQLHomePageLandscapeViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
