//
//  NTESBaseViewController.m
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import "NTESBaseViewController.h"
#import <Masonry.h>
#import "NTESQPDemoDefines.h"

@interface NTESBaseViewController ()

@property (nonatomic, strong) UILabel *bottomCopyRightLabel;

@property (nonatomic, strong) UILabel *bottomLabel;

@property (nonatomic, strong) UIButton *backBarButton;

@property (nonatomic, strong) UIImageView *logoImageView;

@end

@implementation NTESBaseViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self __initBottomView];
    [self __initBackBarButton];
    [self __initLogo];
}

- (void)shouldHideBottomView:(BOOL)hide
{
    if (hide) {
        self.bottomCopyRightLabel.alpha = 0.0;
        self.bottomLabel.alpha = 0.0;
    }
}

- (void)shouldHideLogoView:(BOOL)hide
{
    if (hide) {
        self.logoImageView.alpha = 0.0;
    }
}

- (void)__initBottomView
{
    _bottomCopyRightLabel = [[UILabel alloc] init];
    _bottomCopyRightLabel.text = bottomCopyRightText;
    _bottomCopyRightLabel.font = [UIFont systemFontOfSize:10.0*KHeightScale];
    _bottomCopyRightLabel.textColor = UIColorFromHex(0x999999);
    [self.view addSubview:_bottomCopyRightLabel];
    CGFloat bottomWhiteHeight = IS_IPHONE_X ? -44 : -20;
    [_bottomCopyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.view.mas_bottom).offset(bottomWhiteHeight);
    }];
    
    _bottomLabel = [[UILabel alloc] init];
    _bottomLabel.text = self.showQuickPassBottomView ? bottomPassText : bottomLoginText;
    _bottomLabel.font = [UIFont systemFontOfSize:10.0*KHeightScale];
    _bottomLabel.textColor = UIColorFromHex(0x999999);
    [self.view addSubview:_bottomLabel];
    [_bottomLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view);
        make.bottom.equalTo(self.bottomCopyRightLabel.mas_top).offset(-2);
    }];
}

- (void)__initBackBarButton
{
    if (!_backBarButton) {
        _backBarButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backBarButton addTarget:self action:@selector(doBack) forControlEvents:UIControlEventTouchUpInside];
        [_backBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        [_backBarButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateHighlighted];
        [self.view addSubview:_backBarButton];
        [_backBarButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.view).offset(28*KWidthScale);
            make.top.equalTo(self.view).offset(48.5*KHeightScale);
            make.width.equalTo(@(23*KHeightScale));
            make.height.equalTo(@(23*KHeightScale));
        }];
    }
}

- (void)__initLogo
{
    if (!_logoImageView) {
        _logoImageView = [[UIImageView alloc] init];
        [_logoImageView setImage:[UIImage imageNamed:@"ico_logo_bar"]];
        [self.view addSubview:_logoImageView];
        [_logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerY.equalTo(self.backBarButton);
            make.left.equalTo(self.backBarButton.mas_right);
            make.width.equalTo(@(30*KHeightScale));
            make.height.equalTo(@(30*KHeightScale));
        }];
    }
}

- (void)doBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
