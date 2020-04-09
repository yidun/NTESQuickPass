//
//  NTESQLLoginViewController.h
//  NTESQuickPassPublicDemo
//
//  Created by Ke Xu on 2019/1/31.
//  Copyright © 2019 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESBaseViewController.h"

@interface NTESQLLoginViewController : NTESBaseViewController

@property (nonatomic, copy) NSString *themeTitle;

@property (nonatomic, copy) NSString *token;

- (void)updateView;

- (void)showToastWithMsg:(NSString *)msg;

- (void)getPhoneNumber;

@end
