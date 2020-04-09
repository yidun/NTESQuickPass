//
//  NTESQPVerifyingPopView.m
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/7/5.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import "NTESQPVerifyingPopView.h"
#import "NTESQPDemoDefines.h"
#import <Masonry.h>

static UIView *popView = nil;

@interface NTESQPVerifyingPopView ()

@end

@implementation NTESQPVerifyingPopView

+ (void)showVerifyingFromView:(UIView *)superView title:(NSString *)title
{
    popView = [[UIView alloc] initWithFrame:superView.bounds];
    popView.backgroundColor = UIColorFromHexA(0x000000, 0.48);
    [superView addSubview:popView];
    
    UIView *bgView = [[UIView alloc] init];
    [popView addSubview:bgView];
    bgView.layer.cornerRadius = 14.0;
    bgView.backgroundColor = UIColorFromHex(0xffffff);
    bgView.opaque = NO;
    [bgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(popView);
        make.top.equalTo(popView).offset(250*KHeightScale);
        make.height.equalTo(@(128*KHeightScale));
        make.width.equalTo(@(213*KHeightScale));
    }];
    
    UIImageView *verifyingImageView = [[UIImageView alloc] init];
    [bgView addSubview:verifyingImageView];
    verifyingImageView.image = [UIImage imageNamed:@"verifying"];
    [verifyingImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(bgView).offset(26*KHeightScale);
        make.height.equalTo(@(42*KHeightScale));
        make.width.equalTo(@(123*KHeightScale));
    }];
    
    UILabel *verifyingLable = [[UILabel alloc] init];
    [bgView addSubview:verifyingLable];
    verifyingLable.text = title;
    verifyingLable.font = [UIFont systemFontOfSize:14];
    [verifyingLable mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(bgView);
        make.top.equalTo(verifyingImageView.mas_bottom).offset(16*KHeightScale);
    }];
}

+ (void)hideVerifyingView
{
    if (popView && [popView superview]) {
        [popView removeFromSuperview];
    }
}

@end
