//
//  NTESCheckedToastView.h
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2021/12/1.
//  Copyright © 2021 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NTESCheckedToastViewDelegate <NSObject>

- (void)submitButtonDidTipped;

- (void)cancelButtonDidTipped;

@end

NS_ASSUME_NONNULL_BEGIN

@interface NTESCheckedToastView : UIView

@property (nonatomic, weak) id<NTESCheckedToastViewDelegate> delegate;

@end

NS_ASSUME_NONNULL_END
