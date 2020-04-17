//
//  NTESQPLoginSuccessViewController.h
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESBaseViewController.h"
#import <NTESQuickPass/NTESQuickPass.h>

typedef void(^SuccessHandle)(void);

typedef NS_ENUM(NSUInteger, NTESLoginType) {
    NTESQuickPassType = 1,
    NTESQuickLoginType,
};

@interface NTESQPLoginSuccessViewController : UIViewController

@property (nonatomic, copy) SuccessHandle successHandle;

@property (nonatomic, strong) NTESQuickLoginModel *model;

@property (nonatomic, copy) NSString *themeTitle;

@property (nonatomic, assign) NTESLoginType type;

@end
