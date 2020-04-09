//
//  NTESQPHomePageViewController.m
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import "NTESQPHomePageViewController.h"
#import <Masonry.h>
#import "NTESQPDemoDefines.h"
#import "NTESQPLoginViewController.h"
#import "NTESQLHomePageViewController.h"

@interface NTESQPHomePageViewController () <UINavigationBarDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;

@property (nonatomic, strong) UIButton *registerButton;

@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *exchangeButton;

@end

@implementation NTESQPHomePageViewController

- (void)viewWillAppear:(BOOL)animated
{
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self customInitSubViews];
}

- (void)customInitSubViews
{
    [self __initBackgroundView];
    [self __initButton];
    [self __initBottomView];
}

- (void)__initBackgroundView
{
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"pic_bjjy"];
        [self.view addSubview:_backgroundImageView];
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view);
            make.width.equalTo(self.view);
            make.height.equalTo(@(354*KHeightScale));
        }];
        
        UIImageView *logoImageView = [[UIImageView alloc] init];
        logoImageView.image = [UIImage imageNamed:@"ico_logo_bar_white"];
        [_backgroundImageView addSubview:logoImageView];
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(64);
            make.left.equalTo(self.view).offset(20);
            make.width.equalTo(@(30*KHeightScale));
            make.height.equalTo(@(30*KHeightScale));
        }];
        
        UILabel *homePageTitleLable = [[UILabel alloc] init];
        homePageTitleLable.text = homePageTitle;
        homePageTitleLable.font = [UIFont systemFontOfSize:28.0f*KHeightScale];
        homePageTitleLable.textColor = UIColorFromHex(0xffffff);
        [_backgroundImageView addSubview:homePageTitleLable];
        [homePageTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logoImageView.mas_bottom).offset(26*KHeightScale);
            make.left.equalTo(self.view).offset(24);
        }];
        
        UILabel *quickPassTitleLable = [[UILabel alloc] init];
        quickPassTitleLable.text = quickPassTitle;
        quickPassTitleLable.font = [UIFont systemFontOfSize:24.0f*KHeightScale];
        quickPassTitleLable.textColor = UIColorFromHex(0xffffff);
        [_backgroundImageView addSubview:quickPassTitleLable];
        [quickPassTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(homePageTitleLable.mas_bottom).offset(4*KHeightScale);
            make.left.equalTo(self.view).offset(24);
        }];
    }
}

- (void)__initButton
{
    if (!_exchangeButton) {
        _exchangeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _exchangeButton.backgroundColor = [UIColor clearColor];
        [_exchangeButton addTarget:self action:@selector(doExchange) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_exchangeButton];
        [_exchangeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view);
            make.width.equalTo(@(198.5*KWidthScale));
            make.bottom.equalTo(self.backgroundImageView).offset(-17*KHeightScale);
            make.height.equalTo(@(20*KHeightScale));
        }];
        
        UILabel *exchangeLabel = [[UILabel alloc] init];
        exchangeLabel.text = changeToQuickLogin;
        exchangeLabel.font = [UIFont systemFontOfSize:14.0f*KWidthScale];
        exchangeLabel.textColor = UIColorFromHex(0xffffff);
        [_exchangeButton addSubview:exchangeLabel];
        [exchangeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.exchangeButton);
            make.centerY.equalTo(self.exchangeButton);
        }];
        
        UIImageView *rightImageView = [[UIImageView alloc] init];
        rightImageView.image = [UIImage imageNamed:@"ico_arrow_bjjy"];
        [_exchangeButton addSubview:rightImageView];
        [rightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.exchangeButton);
            make.left.equalTo(exchangeLabel.mas_right).offset(4*KWidthScale);
            make.width.equalTo(@(14*KWidthScale));
            make.height.equalTo(@(14*KWidthScale));
        }];
    }
    
    if (!_loginButton) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:loginTitle forState:UIControlStateNormal];
        [_loginButton setTitle:loginTitle forState:UIControlStateHighlighted];
        [_loginButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
        [_loginButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateHighlighted];
        _loginButton.titleLabel.font = [UIFont systemFontOfSize:15.0f*KHeightScale];
        _loginButton.layer.cornerRadius = 44.0*KHeightScale/2;
        _loginButton.layer.masksToBounds = YES;
        [_loginButton addTarget:self action:@selector(doLogin) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_loginButton];
        [_loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.backgroundImageView.mas_bottom).offset(90*KHeightScale);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@(44*KHeightScale));
            make.width.equalTo(@(307*KWidthScale));
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 307*KWidthScale, 44*KHeightScale);
        gradientLayer.colors = @[(id)UIColorFromHex(0x60b1fe).CGColor, (id)UIColorFromHex(0x6551f6).CGColor];
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        [_loginButton.layer insertSublayer:gradientLayer atIndex:0];
    }
    
    if (!_registerButton) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:registerTitle forState:UIControlStateNormal];
        [_registerButton setTitle:registerTitle forState:UIControlStateHighlighted];
        [_registerButton setTitleColor:UIColorFromHex(0x2a62ff) forState:UIControlStateNormal];
        [_registerButton setTitleColor:UIColorFromHex(0x2a62ff) forState:UIControlStateHighlighted];
        _registerButton.titleLabel.font = [UIFont systemFontOfSize:15.0f*KHeightScale];
        _registerButton.layer.cornerRadius = 44.0*KHeightScale/2;
        _registerButton.layer.masksToBounds = YES;
        _registerButton.layer.borderColor = (UIColorFromHex(0x2a62ff)).CGColor;
        _registerButton.layer.borderWidth = 1;
        [_registerButton addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_registerButton];
        [_registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.loginButton.mas_bottom).offset(30*KHeightScale);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@(44*KHeightScale));
            make.width.equalTo(@(307*KWidthScale));
        }];
    }
}

- (void)__initBottomView
{
    UILabel *bottomCopyRightLabel = [[UILabel alloc] init];
    bottomCopyRightLabel.text = bottomCopyRightText;
    bottomCopyRightLabel.font = [UIFont systemFontOfSize:12.0*KHeightScale];
    bottomCopyRightLabel.textColor = UIColorFromHex(0x999999);
    [self.view addSubview:bottomCopyRightLabel];
    CGFloat bottomWhiteHeight = IS_IPHONE_X ? -44 : -20;
    [bottomCopyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(bottomWhiteHeight);
    }];
}

- (void)doRegister
{
    NTESQPLoginViewController *vc = [[NTESQPLoginViewController alloc] init];
    vc.themeTitle = registerTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doLogin
{
    NTESQPLoginViewController *vc = [[NTESQPLoginViewController alloc] init];
    vc.themeTitle = loginTitle;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)doExchange
{
    NTESQLHomePageViewController *vc = [[NTESQLHomePageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
