//
//  NTESQLLoginViewController.h
//  NTESQuickPassPublicDemo
//
//  Created by Ke Xu on 2019/1/31.
//  Copyright © 2019 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESBaseViewController.h"
#import <NTESQuickPass/NTESQuickPass.h>

typedef void(^SuccessHandle)(void);

@interface NTESQLLoginViewController : UIViewController

@property (nonatomic, strong) NTESQuickLoginModel *model;

@property (nonatomic, copy) NSString *themeTitle;

@property (nonatomic, copy) NSString *token;

@property (nonatomic, copy) SuccessHandle successHandle;

- (void)updateView;

- (void)showToastWithMsg:(NSString *)msg;

- (void)getPhoneNumber;

@end
