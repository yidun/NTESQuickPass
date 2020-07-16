//
//  NTESQLHomePagePortraitView.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/3.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLHomePagePortraitView.h"
#import "NTESQPDemoDefines.h"
#import "UIColor+NTESQuickPass.h"
#import "NTESQLHomePagePortraitBottomView.h"

@interface NTESQLHomePagePortraitView()<NTESQLHomePagePortraitBottomViewDelegate>

@property (nonatomic, strong) UIImageView *backgroundImageView;
@property (nonatomic, strong) UIButton *registerButton;
@property (nonatomic, strong) UIButton *loginButton;

@property (nonatomic, strong) UIButton *loginTabButton;  /// 一键登录切换按钮
@property (nonatomic, strong) UIButton *checkTabButton;  /// 本机校验切换按钮
@property (nonatomic, strong) UIView *loginTabLineView;  /// 一键登录切换按钮底部的线
@property (nonatomic, strong) UIView *checkTabLineView;  /// 本机校验切换按钮底部的线

@property (nonatomic, strong) NTESQLHomePagePortraitBottomView *bottomView;  /// 横屏底部白色的控件
 
@end

@implementation NTESQLHomePagePortraitView

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
        _backgroundImageView.image = [UIImage imageNamed:@"bg_shouye"];
        [self addSubview:_backgroundImageView];
        [_backgroundImageView mas_makeConstraints:^(MASConstraintMaker *make) {
           make.edges.equalTo(self);
        }];
      
        UIImageView *logoImageView = [[UIImageView alloc] init];
        logoImageView.tintColor = [UIColor whiteColor];
        logoImageView.image = [[UIImage imageNamed:@"kj_logo"] imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [_backgroundImageView addSubview:logoImageView];
        [logoImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self).offset(IS_IPHONE_X ? 128 : 108);
            make.centerX.equalTo(self);
            make.width.equalTo(@(82));
            make.height.equalTo(@(105));
        }];
    
        UILabel *quickPassTitleLable = [[UILabel alloc] init];
        quickPassTitleLable.text = quickLoginTitle;
        quickPassTitleLable.font = [UIFont fontWithName:@"PingFangSC-Regular" size:15];
        quickPassTitleLable.textColor = UIColorFromHex(0xffffff);
        quickPassTitleLable.textAlignment = NSTextAlignmentCenter;
        [_backgroundImageView addSubview:quickPassTitleLable];
        [quickPassTitleLable mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(logoImageView.mas_bottom).offset(15);
            make.centerX.equalTo(self);
        }];
    }
    
    CGFloat leftMargin = (SCREEN_WIDTH - 64 * 2 - 82) / 2;
    _loginTabButton = [[UIButton alloc] init];
    _loginTabButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _loginTabButton.titleLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    [_loginTabButton setTitle:@"一键登录" forState:UIControlStateNormal];
    [_loginTabButton addTarget:self action:@selector(loginTabButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [_loginTabButton setTitleColor:[UIColor ntes_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _loginTabButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self addSubview:_loginTabButton];
    [_loginTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(leftMargin);
        make.bottom.equalTo(self).mas_offset(- 312);
        make.size.mas_equalTo(CGSizeMake(64, 22));
    }];
    
    UIView *loginTabLineView = [[UIView alloc] init];
    self.loginTabLineView = loginTabLineView;
    loginTabLineView.layer.cornerRadius = 1.25;
    loginTabLineView.layer.masksToBounds = YES;
    loginTabLineView.backgroundColor = [UIColor ntes_colorWithHexString:@"FFFFFF"];
    [self addSubview:loginTabLineView];
    [loginTabLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.loginTabButton);
        make.top.equalTo(self.loginTabButton.mas_bottom).mas_offset(11);
        make.size.mas_equalTo(CGSizeMake(64, 2.5));
    }];
    
    _checkTabButton = [[UIButton alloc] init];
    [_checkTabButton setTitle:@"本机校验" forState:UIControlStateNormal];
    _checkTabButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _checkTabButton.titleLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    [_checkTabButton addTarget:self action:@selector(checkTabButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [_checkTabButton setTitleColor:[UIColor ntes_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
    _checkTabButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self addSubview:_checkTabButton];
    [_checkTabButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).mas_offset(-leftMargin);
        make.bottom.equalTo(self).mas_offset(- 312);
        make.size.mas_equalTo(CGSizeMake(64, 22));
    }];
    
    UIView *checkTabLineView = [[UIView alloc] init];
    self.checkTabLineView = checkTabLineView;
    self.checkTabLineView.hidden = YES;
    checkTabLineView.backgroundColor = [UIColor ntes_colorWithHexString:@"FFFFFF"];
    checkTabLineView.layer.cornerRadius = 1.25;
    checkTabLineView.layer.masksToBounds = YES;
    [self addSubview:checkTabLineView];
    [checkTabLineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.checkTabButton);
        make.top.equalTo(self.checkTabButton.mas_bottom).mas_offset(11);
        make.size.mas_equalTo(CGSizeMake(64, 2.5));
    }];
    
    _bottomView = [[NTESQLHomePagePortraitBottomView alloc] initWithFrame:CGRectMake(0, SCREEN_HEIGHT - 351, SCREEN_WIDTH, 351)];
    _bottomView.delegate = self;
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self addSubview:_bottomView];

    UIBezierPath *path = [UIBezierPath bezierPathWithRoundedRect:_bottomView.bounds byRoundingCorners:UIRectCornerTopLeft | UIRectCornerTopRight cornerRadii:CGSizeMake(16,16)];
    CAShapeLayer *layer = [[CAShapeLayer alloc] init];
    layer.frame = _bottomView.bounds;
    layer.path = path.CGPath;
    _bottomView.layer.mask = layer;
}

/// 一键登录按钮点击
/// @param sender 登录按钮
- (void)loginTabButtonDidTipped:(UIButton *)sender {
    self.checkTabLineView.hidden = YES;
    self.loginTabLineView.hidden = NO;
    _bottomView.type = NTESQLHomePagePortraitTypeLogin;
}

/// 本机校验按钮点击
/// @param sender 本机校验按钮
- (void)checkTabButtonDidTipped:(UIButton *)sender {
    self.checkTabLineView.hidden = NO;
    self.loginTabLineView.hidden = YES;
    _bottomView.type = NTESQLHomePagePortraitTypeCheck;
}

#pragma NTESQLHomePagePortraitBottomViewDelegate

- (void)loginButtonWithFullScreenDidTipped:(UIButton *_Nullable)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginButtonWithFullScreenDidTipped:)]) {
        [_delegate loginButtonWithFullScreenDidTipped:sender];
    }
}

- (void)loginButtonWithPopScreenDidTipped:(UIButton *_Nullable)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginButtonWithPopScreenDidTipped:)]) {
        [_delegate loginButtonWithPopScreenDidTipped:sender];
    }
}

- (void)loginButtonWithLocalPhoneDidTipped:(UIButton *_Nonnull)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginButtonWithLocalPhoneDidTipped:)]) {
        [_delegate loginButtonWithLocalPhoneDidTipped:sender];
    }
}

- (void)loginSafeButtonDidTipped:(UIButton *_Nonnull)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginSafeButtonDidTipped:)]) {
        [_delegate loginSafeButtonDidTipped:sender];
    }
}

@end

