//
//  NTESQLHomePagePortraitBottomView.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/3.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLHomePagePortraitBottomView.h"
#import "NTESQPDemoDefines.h"
#import "UIColor+NTESQuickPass.h"

@interface NTESQLHomePagePortraitBottomView()

@property (nonatomic, strong) UIButton *loginFullScreenButton;
@property (nonatomic, strong) UIButton *loginPopButton;
@property (nonatomic, strong) UIButton *loginSafeButton;
@property (nonatomic, strong) UILabel *contentLabel;

@end

@implementation NTESQLHomePagePortraitBottomView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        [self setupViews];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setupViews {
    _loginFullScreenButton = [[UIButton alloc] init];
    _loginFullScreenButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _loginFullScreenButton.titleLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    _loginFullScreenButton.layer.cornerRadius = 8;
    _loginFullScreenButton.layer.masksToBounds = YES;
    [_loginFullScreenButton setTitle:@"一键登录 | 全屏" forState:UIControlStateNormal];
    [_loginFullScreenButton addTarget:self action:@selector(loginFullScreenButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:_loginFullScreenButton];
    [_loginFullScreenButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(40);
        make.right.equalTo(self).mas_offset(-40);
        make.top.equalTo(self).mas_offset(40);
        make.height.mas_equalTo(44);
    }];
    
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH - 80, 44);
    gradientLayer.colors = @[(id)[UIColor ntes_colorWithHexString:@"#5F83FE"].CGColor, (id)[UIColor ntes_colorWithHexString:@"#324DFF"].CGColor];
    gradientLayer.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer.endPoint = CGPointMake(1.0, 0.5);
    [_loginFullScreenButton.layer insertSublayer:gradientLayer atIndex:0];
    
    _loginPopButton = [[UIButton alloc] init];
    _loginPopButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _loginPopButton.titleLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    _loginPopButton.layer.cornerRadius = 8;
    _loginPopButton.layer.masksToBounds = YES;
    [_loginPopButton addTarget:self action:@selector(loginPopButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [_loginPopButton setTitle:@"一键登录 | 弹窗" forState:UIControlStateNormal];
    [self addSubview:_loginPopButton];
    [_loginPopButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(40);
        make.right.equalTo(self).mas_offset(-40);
        make.top.equalTo(self.loginFullScreenButton.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(44);
    }];
    CAGradientLayer *gradientLayer1 = [CAGradientLayer layer];
    gradientLayer1.frame = CGRectMake(0, 0, SCREEN_WIDTH - 80, 44);
    gradientLayer1.colors = @[(id)[UIColor ntes_colorWithHexString:@"#5F83FE"].CGColor, (id)[UIColor ntes_colorWithHexString:@"#324DFF"].CGColor];
    gradientLayer1.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer1.endPoint = CGPointMake(1.0, 0.5);
    [_loginPopButton.layer insertSublayer:gradientLayer1 atIndex:0];
    
    _loginSafeButton = [[UIButton alloc] init];
    _loginSafeButton.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    _loginSafeButton.titleLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
    _loginSafeButton.layer.cornerRadius = 8;
    _loginSafeButton.layer.masksToBounds = YES;
    [_loginSafeButton addTarget:self action:@selector(loginSafeButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [_loginSafeButton setTitle:@"一键登录 |  智能安全版" forState:UIControlStateNormal];
    [self addSubview:_loginSafeButton];
    [_loginSafeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).mas_offset(40);
        make.right.equalTo(self).mas_offset(-40);
        make.top.equalTo(self.loginPopButton.mas_bottom).mas_offset(20);
        make.height.mas_equalTo(44);
    }];
    
    CAGradientLayer *gradientLayer2 = [CAGradientLayer layer];
    gradientLayer2.frame = CGRectMake(0, 0, SCREEN_WIDTH - 80, 44);
    gradientLayer2.colors = @[(id)[UIColor ntes_colorWithHexString:@"#5F83FE"].CGColor, (id)[UIColor ntes_colorWithHexString:@"#324DFF"].CGColor];
    gradientLayer2.startPoint = CGPointMake(0.0, 0.5);
    gradientLayer2.endPoint = CGPointMake(1.0, 0.5);
    [_loginSafeButton.layer insertSublayer:gradientLayer2 atIndex:0];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.text = @"翻转手机体验横屏";
    _contentLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12 * KHeightScale];
    _contentLabel.textColor = [UIColor ntes_colorWithHexString:@"#878A99"];
    [self addSubview:_contentLabel];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.top.equalTo(self.loginSafeButton.mas_bottom).mas_offset(20);
    }];
    
    UILabel *bottomCopyRightLabel = [[UILabel alloc] init];
    bottomCopyRightLabel.text = bottomCopyRightText;
    bottomCopyRightLabel.font = [UIFont systemFontOfSize:11.0];
    bottomCopyRightLabel.textColor = [UIColor ntes_colorWithHexString:@"#B8BBCC"];
    [self addSubview:bottomCopyRightLabel];
    CGFloat bottomWhiteHeight = IS_IPHONE_X ? -42 : -8;
    [bottomCopyRightLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self);
        make.bottom.equalTo(self.mas_bottom).offset(bottomWhiteHeight);
     }];
}

- (void)setType:(NTESQLHomePagePortraitType)type {
    _type = type;
    if (type == NTESQLHomePagePortraitTypeLogin) {
        _loginFullScreenButton.hidden = NO;
        _loginSafeButton.hidden = NO;
        [_loginPopButton setTitle:@"一键登录 | 弹窗" forState:UIControlStateNormal];
        [_loginPopButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(40);
            make.right.equalTo(self).mas_offset(-40);
            make.top.equalTo(self.loginFullScreenButton.mas_bottom).mas_offset(20);
            make.height.mas_equalTo(44);
        }];
    } else {
        [_loginPopButton setTitle:@"本机校验" forState:UIControlStateNormal];
        _loginFullScreenButton.hidden = YES;
        _loginSafeButton.hidden = YES;
         [_loginPopButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self).mas_offset(40);
            make.right.equalTo(self).mas_offset(-40);
            make.top.equalTo(self).mas_offset(40);
            make.height.mas_equalTo(44);
        }];
    }
}

/// 全屏按钮的点击
/// @param sender sender
- (void)loginFullScreenButtonDidTipped:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginButtonWithFullScreenDidTipped:)]) {
        [_delegate loginButtonWithFullScreenDidTipped:sender];
    }
}

/// 半屏按钮的点击
/// @param sender sender
- (void)loginPopButtonDidTipped:(UIButton *)sender {
    if (_type == NTESQLHomePagePortraitTypeLogin) {
        if (_delegate && [_delegate respondsToSelector:@selector(loginButtonWithPopScreenDidTipped:)]) {
            [_delegate loginButtonWithPopScreenDidTipped:sender];
        }
    } else {
        if (_delegate && [_delegate respondsToSelector:@selector(loginButtonWithLocalPhoneDidTipped:)]) {
            [_delegate loginButtonWithLocalPhoneDidTipped:sender];
        }
    }
}

- (void)loginSafeButtonDidTipped:(UIButton *)sender {
    if (_delegate && [_delegate respondsToSelector:@selector(loginSafeButtonDidTipped:)]) {
        [_delegate loginSafeButtonDidTipped:sender];
    }
}

@end

