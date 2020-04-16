//
//  NTESQLHomePageLandscapeView.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/7.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLHomePageLandscapeView.h"
#import "NTESQPDemoDefines.h"
#import "UIColor+NTESQuickPass.h"

@interface NTESQLHomePageLandscapeView()

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *loginButton;
@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UIButton *loginTabButton;  /// 一键登录切换按钮
@property (nonatomic, strong) UIButton *checkTabButton;  /// 本机校验切换按钮
@property (nonatomic, strong) UIView *loginTabLineView;  /// 一键登录切换按钮底部的线
@property (nonatomic, strong) UIView *checkTabLineView;  /// 本机校验切换按钮底部的线

@property (nonatomic, strong) UIButton *loginFullScreenButton;
@property (nonatomic, strong) UIButton *loginPopButton;
@property (nonatomic, strong) UILabel *contentLabel;

@property (nonatomic, assign) NSInteger type;

@end

@implementation NTESQLHomePageLandscapeView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
    }
    return self;
}

- (void)setupViews {
    if (!_backgroundImageView) {
        _backgroundImageView = [[UIImageView alloc] init];
        _backgroundImageView.image = [UIImage imageNamed:@"pic_bg_heng"];
        [self addSubview:_backgroundImageView];
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self);
        }];
      
        UIImageView *logoImageView = [[UIImageView alloc] init];
        self.logoImageView = logoImageView;
        logoImageView.tintColor = [UIColor whiteColor];
        logoImageView.image = [[UIImage imageNamed:@"logo_heng"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_backgroundImageView addSubview:logoImageView];
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(IS_IPHONE_X ? 64 : 40);
            make.centerX.equalTo(self);
            make.width.equalTo(@(152));
            make.height.equalTo(@(40));
        }];
    }
    
    CGFloat leftMargin = (SCREEN_WIDTH - 64 * 2 - 82) / 2;
    _loginTabButton = [[UIButton alloc] init];
    [_loginTabButton setTitle:@"一键登录" forState:UIControlStateNormal];
    [_loginTabButton addTarget:self action:@selector(loginTabButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [_loginTabButton setTitleColor:[UIColor ntes_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _loginTabButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self addSubview:_loginTabButton];
    [_loginTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(leftMargin);
        make.top.equalTo(self.logoImageView.mas_bottom).mas_offset(60);
        make.size.mas_equalTo(CGSizeMake(64, 22));
    }];
    
    UIView *loginTabLineView = [[UIView alloc] init];
    self.loginTabLineView = loginTabLineView;
    loginTabLineView.layer.cornerRadius = 2;
    loginTabLineView.layer.masksToBounds = YES;
    loginTabLineView.backgroundColor = [UIColor ntes_colorWithHexString:@"FFFFFF"];
    [self addSubview:loginTabLineView];
    [loginTabLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginTabButton);
        make.top.equalTo(self.loginTabButton.mas_bottom).mas_offset(12);
        make.size.mas_equalTo(CGSizeMake(64, 2.5));
    }];
    
    _checkTabButton = [[UIButton alloc] init];
    [_checkTabButton setTitle:@"本机校验" forState:UIControlStateNormal];
    [_checkTabButton addTarget:self action:@selector(checkTabButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [_checkTabButton setTitleColor:[UIColor ntes_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _checkTabButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self addSubview:_checkTabButton];
    [_checkTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-leftMargin);
        make.top.equalTo(self.logoImageView.mas_bottom).mas_offset(60);
        make.size.mas_equalTo(CGSizeMake(64, 22));
    }];
    
    UIView *checkTabLineView = [[UIView alloc] init];
    self.checkTabLineView = checkTabLineView;
    self.checkTabLineView.hidden = YES;
    checkTabLineView.backgroundColor = [UIColor ntes_colorWithHexString:@"FFFFFF"];
    checkTabLineView.layer.cornerRadius = 2;
    checkTabLineView.layer.masksToBounds = YES;
    [self addSubview:checkTabLineView];
    [checkTabLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.checkTabButton);
        make.top.equalTo(self.checkTabButton.mas_bottom).mas_offset(12);
        make.size.mas_equalTo(CGSizeMake(64, 2.5));
    }];
    
    _loginFullScreenButton = [[UIButton alloc] init];
    _loginFullScreenButton.backgroundColor = [UIColor whiteColor];
    _loginFullScreenButton.layer.cornerRadius = 8;
    _loginFullScreenButton.layer.masksToBounds = YES;
    [_loginFullScreenButton setTitleColor:[UIColor ntes_colorWithHexString:@"#324DFF"] forState:UIControlStateNormal];
    [_loginFullScreenButton setTitle:@"一键登录 | 全屏" forState:UIControlStateNormal];
    [_loginFullScreenButton addTarget:self action:@selector(loginFullScreenButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginFullScreenButton];
    [_loginFullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(295);
        make.top.equalTo(checkTabLineView.mas_bottom).mas_offset(22);
        make.height.mas_equalTo(44);
    }];
       
    _loginPopButton = [[UIButton alloc] init];
    _loginPopButton.layer.cornerRadius = 8;
    _loginPopButton.layer.masksToBounds = YES;
    _loginPopButton.backgroundColor = [UIColor whiteColor];
    [_loginPopButton addTarget:self action:@selector(loginPopButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [_loginPopButton setTitle:@"一键登录 | 弹窗" forState:UIControlStateNormal];
    [_loginPopButton setTitleColor:[UIColor ntes_colorWithHexString:@"#324DFF"] forState:UIControlStateNormal];
    [self addSubview:_loginPopButton];
    [_loginPopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(295);
        make.top.equalTo(self.loginFullScreenButton.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(44);
    }];
       
    UILabel *bottomCopyRightLabel = [[UILabel alloc] init];
    bottomCopyRightLabel.text = bottomCopyRightText;
    bottomCopyRightLabel.textAlignment = NSTextAlignmentCenter;
    bottomCopyRightLabel.font = [UIFont systemFontOfSize:11.0];
    bottomCopyRightLabel.textColor = [UIColor ntes_colorWithHexString:@"#B8BBCC"];
    [self addSubview:bottomCopyRightLabel];
    CGFloat bottomWhiteHeight = 34;
    [bottomCopyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self).offset(-bottomWhiteHeight);
    }];
    
}

/// 一键登录按钮点击
/// @param sender 登录按钮
- (void)loginTabButtonDidTipped:(UIButton *)sender {
    self.checkTabLineView.hidden = YES;
    self.loginTabLineView.hidden = NO;
    self.type = 0;
    
    _loginFullScreenButton.hidden = NO;
    [_loginPopButton setTitle:@"一键登录 | 弹窗" forState:UIControlStateNormal];
    [_loginPopButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(295);
        make.top.equalTo(self.loginFullScreenButton.mas_bottom).mas_offset(22);
        make.height.mas_equalTo(44);
    }];
}

/// 本机校验按钮点击
/// @param sender 本机校验按钮
- (void)checkTabButtonDidTipped:(UIButton *)sender {
    self.checkTabLineView.hidden = NO;
    self.loginTabLineView.hidden = YES;
    self.type = 1;
    
    [_loginPopButton setTitle:@"本机校验" forState:UIControlStateNormal];
    _loginFullScreenButton.hidden = YES;
    [_loginPopButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.width.mas_equalTo(295);
        make.top.equalTo(self.checkTabLineView.mas_bottom).mas_offset(22);
        make.height.mas_equalTo(44);
    }];
}

#pragma NTESQLHomePageLandscapeViewDelegate

- (void)loginFullScreenButtonDidTipped:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginButtonWithLandscapeFullScreenDidTipped:)]) {
        [_delegate loginButtonWithLandscapeFullScreenDidTipped:sender];
    }
}

- (void)loginPopButtonDidTipped:(UIButton *)sender {
    if (_type == 0) {
         if (_delegate && [_delegate respondsToSelector:@selector(loginButtonWithLandscapePopScreenDidTipped:)]) {
             [_delegate loginButtonWithLandscapePopScreenDidTipped:sender];
         }
     } else {
         if (_delegate && [_delegate respondsToSelector:@selector(loginButtonWithLandscapeLocalPhoneDidTipped:)]) {
             [_delegate loginButtonWithLandscapeLocalPhoneDidTipped:sender];
         }
     }
}

@end
