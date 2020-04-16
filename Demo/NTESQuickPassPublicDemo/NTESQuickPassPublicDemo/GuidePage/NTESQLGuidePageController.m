//
//  NTESQLGuidePageController.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/15.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLGuidePageController.h"
#import "NTESQLHomePageViewController.h"
#import "NTESNavigationController.h"
#import <Masonry/Masonry.h>
#import "NTESQPDemoDefines.h"
#import "UIColor+NTESQuickPass.h"

@interface NTESQLGuidePageController ()

@property (nonatomic, strong) UIButton *enterButton;
@property (nonatomic, strong) UIImageView *backImageView;

@end

@implementation NTESQLGuidePageController

- (void)viewDidLoad {
    [super viewDidLoad];
   
    UIImageView *backImageView = [[UIImageView alloc] init];
    backImageView.userInteractionEnabled = YES;
    self.backImageView = backImageView;
    backImageView.image = [UIImage imageNamed:@"bg_欢迎页"];
    [self.view addSubview:backImageView];
    [backImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
    
    UIImageView *logoImageView = [[UIImageView alloc] init];
    logoImageView.tintColor = [UIColor whiteColor];
    logoImageView.image = [[UIImage imageNamed:@"kj_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [backImageView addSubview:logoImageView];
    [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(backImageView).mas_offset(139);
        make.centerX.equalTo(backImageView);
        make.width.mas_offset(82);
        make.height.mas_offset(105);
    }];
    
    UILabel *bottomCopyRightLabel = [[UILabel alloc] init];
    bottomCopyRightLabel.text = bottomCopyRightText;
    bottomCopyRightLabel.font = [UIFont systemFontOfSize:11.0];
    bottomCopyRightLabel.textColor = [UIColor ntes_colorWithHexString:@"#B8BBCC"];
    [backImageView addSubview:bottomCopyRightLabel];
    CGFloat bottomWhiteHeight = IS_IPHONE_X ? -42 : -8;
    [bottomCopyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView);
        make.bottom.equalTo(backImageView.mas_bottom).offset(bottomWhiteHeight);
    }];
    
    UIButton *enterButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.enterButton = enterButton;
    enterButton.layer.cornerRadius = 8;
    enterButton.layer.masksToBounds = YES;
    enterButton.layer.borderColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"].CGColor;
    enterButton.layer.borderWidth = 1;
    [enterButton setTitleColor:[UIColor ntes_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    enterButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [enterButton setTitle:@"立即体验" forState:UIControlStateNormal];
    [enterButton addTarget:self action:@selector(enterButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [backImageView addSubview:enterButton];
    [enterButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(backImageView);
        make.size.mas_equalTo(CGSizeMake(215, 44));
        make.bottom.equalTo(bottomCopyRightLabel.mas_top).mas_offset(-40);
    }];
    
    UILabel *firstLabel = [[UILabel alloc] init];
    firstLabel.textAlignment = NSTextAlignmentLeft;
    firstLabel.text = @"不留用户数据，保护数据隐私";
    firstLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    firstLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    [self.backImageView addSubview:firstLabel];
    [firstLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.enterButton).mas_offset(40);
        make.bottom.equalTo(self.enterButton.mas_top).mas_offset(-40);
        make.height.mas_equalTo(20);
    }];
    
    UIButton *firstButton = [UIButton buttonWithType:UIButtonTypeCustom];
    firstButton.layer.cornerRadius = 5;
    firstButton.layer.masksToBounds = YES;
    firstButton.layer.borderColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"].CGColor;
    firstButton.layer.borderWidth = 1;
    [self.backImageView addSubview:firstButton];
    [firstButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(firstLabel);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.right.equalTo(firstLabel.mas_left).mas_offset(-10);
    }];
    
    UILabel *secondLabel = [[UILabel alloc] init];
    secondLabel.textAlignment = NSTextAlignmentLeft;
    secondLabel.text = @"轻量SDK，极速接入";
    secondLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    secondLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    [self.backImageView addSubview:secondLabel];
    [secondLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.enterButton).mas_offset(40);
        make.bottom.equalTo(firstLabel.mas_top).mas_offset(-10);
        make.height.mas_equalTo(20);
    }];

    UIButton *secondButton = [UIButton buttonWithType:UIButtonTypeCustom];
    secondButton.layer.cornerRadius = 5;
    secondButton.layer.masksToBounds = YES;
    secondButton.layer.borderColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"].CGColor;
    secondButton.layer.borderWidth = 1;
    [backImageView addSubview:secondButton];
    [secondButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(secondLabel);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.right.equalTo(secondLabel.mas_left).mas_offset(-10);
    }];

    UILabel *thirdLabel = [[UILabel alloc] init];
    thirdLabel.text = @"快速认证，提升转化";
    thirdLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:13];
    thirdLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    [backImageView addSubview:thirdLabel];
    [thirdLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.enterButton).mas_offset(40);
        make.bottom.equalTo(secondLabel.mas_top).mas_offset(-10);
        make.height.mas_equalTo(20);
    }];

    UIButton *thirdButton = [UIButton buttonWithType:UIButtonTypeCustom];
    thirdButton.layer.cornerRadius = 5;
    thirdButton.layer.masksToBounds = YES;
    thirdButton.layer.borderColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"].CGColor;
    thirdButton.layer.borderWidth = 1;
    [backImageView addSubview:thirdButton];
    [thirdButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(thirdLabel);
        make.size.mas_equalTo(CGSizeMake(10, 10));
        make.right.equalTo(thirdLabel.mas_left).mas_offset(-10);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.textAlignment = NSTextAlignmentCenter;
    contentLabel.text = @"号码认证";
    contentLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    contentLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:32];
    [self.backImageView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.backImageView);
        make.bottom.equalTo(thirdLabel.mas_top).mas_offset(-20);
    }];
}

- (void)enterButtonDidTipped:(UIButton *)sender {
    NTESQLHomePageViewController *vc = [[NTESQLHomePageViewController alloc] init];
    NTESNavigationController *nav = [[NTESNavigationController alloc] initWithRootViewController:vc];
    [UIApplication sharedApplication].delegate.window.rootViewController = nav;
}

- (BOOL)shouldAutorotate {
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
     return UIInterfaceOrientationMaskPortrait;
}

@end
