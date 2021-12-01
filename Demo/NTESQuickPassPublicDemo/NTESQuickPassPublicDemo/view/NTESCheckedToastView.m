//
//  NTESCheckedToastView.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2021/12/1.
//  Copyright © 2021 Xu Ke. All rights reserved.
//

#import "NTESCheckedToastView.h"
#import <Masonry/Masonry.h>

@interface NTESCheckedToastView()

@property (nonatomic, strong) UIView *contentView;

@end

@implementation NTESCheckedToastView

- (instancetype)initWithFrame:(CGRect)frame  {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
        [self setupView];
    }
    return self;
}

- (void)setupView {
    UIView *contentView = [[UIView alloc] init];
    contentView.backgroundColor = [UIColor whiteColor];
    [self addSubview:contentView];
    [contentView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.size.mas_equalTo(CGSizeMake([UIScreen mainScreen].bounds.size.width - 50, 200));
        make.centerX.centerY.equalTo(self);
    }];
    
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.text = @"请您仔细阅读【链接】，点击“确定”，表示您已经阅读并同意以上协议。";
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = [UIColor grayColor];
    [contentView addSubview:contentLabel];
    [contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(contentView).mas_offset(30);
        make.left.equalTo(contentView).mas_offset(10);
        make.right.equalTo(contentView).mas_offset(-10);
    }];
    
    UIButton *submitButton = [[UIButton alloc] init];
    submitButton.backgroundColor = [UIColor darkGrayColor];
    [submitButton addTarget:self action:@selector(submitButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [submitButton setTitle:@"确定" forState:UIControlStateNormal];
    [contentView addSubview:submitButton];
    [submitButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(contentView).mas_offset(-10);
        make.bottom.equalTo(contentView).mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
    
    UIButton *cancleButton = [[UIButton alloc] init];
    cancleButton.backgroundColor = [UIColor darkGrayColor];
    [cancleButton addTarget:self action:@selector(cancleButtonDidTipped:) forControlEvents:UIControlEventTouchUpInside];
    [cancleButton setTitle:@"取消" forState:UIControlStateNormal];
    [contentView addSubview:cancleButton];
    [cancleButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(contentView).mas_offset(10);
        make.bottom.equalTo(contentView).mas_offset(-20);
        make.size.mas_equalTo(CGSizeMake(100, 30));
    }];
}

- (void)submitButtonDidTipped:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(submitButtonDidTipped)]) {
        [_delegate submitButtonDidTipped];
    }
}

- (void)cancleButtonDidTipped:(UIButton *)button {
    if (_delegate && [_delegate respondsToSelector:@selector(cancelButtonDidTipped)]) {
        [_delegate cancelButtonDidTipped];
    }
}

@end
