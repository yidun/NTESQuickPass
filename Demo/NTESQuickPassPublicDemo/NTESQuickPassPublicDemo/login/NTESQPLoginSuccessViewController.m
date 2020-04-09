//
//  NTESQPLoginSuccessViewController.m
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import "NTESQPLoginSuccessViewController.h"
#import <Masonry.h>
#import "NTESQPDemoDefines.h"
#import "NTESQPHomePageViewController.h"
#import "NTESQLHomePageViewController.h"

@interface NTESQPLoginSuccessViewController ()

@property (nonatomic, strong) UIImageView *successImageView;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UIButton *backToRootButton;

@end

@implementation NTESQPLoginSuccessViewController

- (void)viewDidLoad
{
    self.showQuickPassBottomView = self.type == NTESQuickPassType ? YES : NO;
    [super viewDidLoad];
    [self customInitSubViews];
}

- (void)customInitSubViews
{
    [self __initSuccessImageView];
    [self __initThemeLabel];
    [self __initBackToRootButton];
}

- (void)__initSuccessImageView
{
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] init];
        if (self.type == NTESQuickPassType) {
            [_successImageView setImage:[UIImage imageNamed:@"success"]];
        } else {
            [_successImageView setImage:[UIImage imageNamed:@"Group"]];
        }
        
        [self.view addSubview:_successImageView];
        [_successImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.top.equalTo(self.view).offset(135.5*KHeightScale);
            make.height.equalTo(@(103.5*KHeightScale));
            make.width.equalTo(@(191*KHeightScale));
        }];
    }
}

- (void)__initThemeLabel
{
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = [UIFont systemFontOfSize:21.0*KHeightScale];
        _themeLabel.text = [self.themeTitle stringByAppendingString:@"成功"];
        [self.view addSubview:_themeLabel];
        [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.successImageView.mas_bottom).offset(4*KHeightScale);
            make.centerX.equalTo(self.view);
        }];
    }
}

- (void)__initBackToRootButton
{
    if (!_backToRootButton) {
        _backToRootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backToRootButton setTitle:backToRoot forState:UIControlStateNormal];
        [_backToRootButton setTitle:backToRoot forState:UIControlStateHighlighted];
        _backToRootButton.titleLabel.textColor = [UIColor whiteColor];
        _backToRootButton.titleLabel.font = [UIFont systemFontOfSize:15.0f];
        _backToRootButton.layer.cornerRadius = 44.0*KHeightScale/2;
        _backToRootButton.layer.masksToBounds = YES;
        [_backToRootButton addTarget:self action:@selector(doBackToRoot) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_backToRootButton];
        [_backToRootButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.themeLabel.mas_bottom).offset(42.5*KHeightScale);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@(44*KHeightScale));
            make.width.equalTo(@(307*KWidthScale));
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 307*KWidthScale, 44*KHeightScale);
        if (self.type == NTESQuickPassType) {
            gradientLayer.colors = @[(id)UIColorFromHex(0x60b1fe).CGColor, (id)UIColorFromHex(0x6551f6).CGColor];
        } else {
            gradientLayer.colors = @[(id)UIColorFromHex(0xAC5FF9).CGColor, (id)UIColorFromHex(0x7846F1).CGColor];
        }
        
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        [_backToRootButton.layer insertSublayer:gradientLayer atIndex:0];
    }
}

- (void)doBackToRoot
{
    if (self.type == NTESQuickPassType) {
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[NTESQPHomePageViewController class]]) {
                NTESQPHomePageViewController *mainVC = (NTESQPHomePageViewController *)vc;
                [self.navigationController popToViewController:mainVC animated:YES];
            }
        }
    } else {
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[NTESQLHomePageViewController class]]) {
                NTESQLHomePageViewController *mainVC = (NTESQLHomePageViewController *)vc;
                [self.navigationController popToViewController:mainVC animated:YES];
            }
        }
    }
}

@end
