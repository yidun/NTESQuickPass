//
//  NTESQLNavigationView.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/13.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLNavigationView.h"
#import "NTESQPDemoDefines.h"
#import "UIColor+NTESQuickPass.h"
#import <NTESQuickPass/NTESQuickPass.h>
#import "NTESQLFindCurrentVCEntity.h"

@interface NTESQLNavigationView()

/// 导航栏返回按钮
@property (nonatomic, strong) UIButton *backButton;

/// 导航栏中间标题
@property (nonatomic, strong) UILabel *titleView;

@end

@implementation NTESQLNavigationView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    _backButton = [[UIButton alloc] init];
    [_backButton setImage:[[UIImage imageNamed:@"ic_back"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
    [_backButton addTarget:self action:@selector(backButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_backButton];
    [_backButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(20);
        make.bottom.equalTo(self).mas_offset(-6);
        make.size.mas_equalTo(CGSizeMake(16, 16));
    }];
      
    _titleView = [[UILabel alloc] init];
    _titleView.textAlignment = NSTextAlignmentCenter;
    _titleView.text = @"免密登录";
    _titleView.font = [UIFont fontWithName:@"PingFangSC-Regular" size:17];
    _titleView.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    [self addSubview:_titleView];
    [_titleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.backButton);
        make.centerX.equalTo(self);
    }];
}

- (void)backButtonDidTipped:(UIButton *)sender {
    NTESAuthWindowPop authWindowPop = [NTESQuickLoginManager sharedInstance].model.authWindowPop;
       NTESPresentDirection presentDirectionType = [NTESQuickLoginManager sharedInstance].model.presentDirectionType;
    UIViewController *currentController = [NTESQuickLoginManager sharedInstance].model.currentVC;
       if (authWindowPop == NTESAuthWindowPopFullScreen && presentDirectionType == NTESPresentDirectionPush) {
           [currentController.navigationController popViewControllerAnimated:YES];
       } else {
           [currentController dismissViewControllerAnimated:YES completion:nil];
       }
}


@end
