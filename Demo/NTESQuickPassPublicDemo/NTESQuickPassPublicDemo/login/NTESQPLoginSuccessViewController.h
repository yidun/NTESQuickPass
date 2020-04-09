//
//  NTESQPLoginSuccessViewController.h
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "NTESBaseViewController.h"

typedef NS_ENUM(NSUInteger, NTESLoginType) {
    NTESQuickPassType = 1,
    NTESQuickLoginType,
};

@interface NTESQPLoginSuccessViewController : NTESBaseViewController

@property (nonatomic, copy) NSString *themeTitle;

@property (nonatomic, assign) NTESLoginType type;

@end
