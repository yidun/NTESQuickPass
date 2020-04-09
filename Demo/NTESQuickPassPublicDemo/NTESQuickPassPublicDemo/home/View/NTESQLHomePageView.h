//
//  NTESQLHomePageView.h
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/3/17.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESQLHomePageViewDelegate <NSObject>

- (void)registerButtonDidTipped:(UIButton *_Nullable)sender;
- (void)loginButtonDidTipped:(UIButton *_Nullable)sender;
- (void)exchangeButtonDidTipped:(UIButton *_Nullable)sender;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NTESQLHomePageView : UIView

@property (nonatomic, weak) id<NTESQLHomePageViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
