//
//  NTESBaseViewController.h
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NTESBaseViewController : UIViewController

@property (nonatomic, assign) BOOL showQuickPassBottomView;

- (void)shouldHideBottomView:(BOOL)hide;

- (void)shouldHideLogoView:(BOOL)hide;

@end

