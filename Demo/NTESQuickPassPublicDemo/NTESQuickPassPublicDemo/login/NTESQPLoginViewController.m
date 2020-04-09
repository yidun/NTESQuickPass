//
//  NTESQPLoginViewController.m
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import "NTESQPLoginViewController.h"
#import <Masonry.h>
#import "NTESQPDemoDefines.h"
#import "NTESQPLoginSuccessViewController.h"
#import "NTESQPVerifyingPopView.h"
#import <NTESQuickPass/NTESQuickPassManager.h>
#import "NTESDemoHttpRequest.h"

@interface NTESQPLoginViewController ()

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UITextField *phoneNumberTextField;

@property (nonatomic, strong) UIView *firstSeparateLine;

@property (nonatomic, strong) UIView *secondSeparateLine;

@property (nonatomic, strong) UIButton *nextButton;

@property (nonatomic, strong) UIButton *timeButton;

@property (nonatomic, strong) UITextField *verifyCodeTextField;

@property (nonatomic, strong) NTESQuickPassManager *manager;

@property (nonatomic, strong) NSDictionary *params;

@end

@implementation NTESQPLoginViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.showQuickPassBottomView = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitSubViews];
    self.manager = [NTESQuickPassManager sharedInstance];
}

- (void)customInitSubViews
{
    self.showQuickPassBottomView = YES;
    [self __initThemeLabel];
    [self __initTextField];
    [self __initSeparateLine];
    [self __initNextButton];
}

- (void)doPhoneNumberVerify
{
    // test
//    self.phoneNumberTextField.text = @"15356683517";
    if (!self.phoneNumberTextField.text.length) {
        [self showToastWithMsg:@"手机号不可为空"];
        return;
    }
    [NTESQPVerifyingPopView showVerifyingFromView:self.view title:verifyingQPText];
    WeakSelf(self);
    self.manager.timeOut = 10.0 * 1000;
    [self.manager verifyPhoneNumber:self.phoneNumberTextField.text businessID:QP_BUSINESSID completion:^(NSDictionary * _Nullable params, NTESQPStatus status, BOOL success) {
        StrongSelf(weakSelf);
        dispatch_async(dispatch_get_main_queue(), ^{
            if (status == NTESQPAccessTokenSuccess) {
                strongSelf.params = params;
                [strongSelf startCheck];
            }
            if (status == NTESQPPhoneNumInvalid) {
                [NTESQPVerifyingPopView hideVerifyingView];
                [strongSelf showToastWithMsg:@"请输入正确的手机号"];
                return;
            }
            if (status == NTESQPNonGateway) {
                [NTESQPVerifyingPopView hideVerifyingView];
                [strongSelf showToastWithMsg:@"请确保蜂窝网络连接"];
                return;
            }
            if (status == NTESQPAccessTokenTimeout) {
                [NTESQPVerifyingPopView hideVerifyingView];
                [strongSelf showToastWithMsg:@"请求超时"];
                [strongSelf showSendMessageView];
                return;
            }
            if (status == NTESQPAccessTokenFailure) {
                [NTESQPVerifyingPopView hideVerifyingView];
                [strongSelf showToastWithMsg:@"请求失败"];
                [strongSelf showSendMessageView];
                return;
            }
        });
    }];
}

- (void)showSendMessageView
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateView];
    });
}

- (void)startCheck
{
    NSDictionary *dict = @{
                           @"accessToken":[self.params objectForKey:@"accessToken"]?:@"",
                           @"token":[self.params objectForKey:@"token"]?:@"",
                           @"phone":self.phoneNumberTextField.text,
                           };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        [NTESQPVerifyingPopView hideVerifyingView];
        NSLog(@"got a error");
        return;
    }
    
    [NTESDemoHttpRequest startRequestWithURL:API_LOGIN_TOKEN_QPCHECK httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NTESQPVerifyingPopView hideVerifyingView];
            if (data) {
                [self parseCheckObject:data];
            } else {
                [self showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
                [self showSendMessageView];
            }
        });
    }];
}

- (void)verifySMSCode
{
    NSDictionary *dict = @{
                           @"phone":self.phoneNumberTextField.text,
                           @"code":self.verifyCodeTextField.text,
                           };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        NSLog(@"got a error");
        return;
    }
    
    [NTESDemoHttpRequest startRequestWithURL:API_LOGIN_CODE_CHECK httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSLog(@"verify code --- %@", dict);
                if ([[dict objectForKey:@"code"] integerValue] == 200) {
                    [self verifySuccess];
                } else {
                    [self showToastWithMsg:@"请输入正确的验证码"];
                    self.verifyCodeTextField.text = @"";
                }
            } else {
                [self showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
            }
        });
    }];
}

- (void)parseCheckObject:(NSData *)data
{
    NSError *jsonSerializationError;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonSerializationError];
    if (!jsonSerializationError) {
        
        id code = [dict objectForKey:@"code"];
        
        if (code && [code isKindOfClass:[NSNumber class]]) {
            
            if ([code integerValue] == 200) {
                [self verifySuccess];
            } else if ([code integerValue] == 1000){
                [self showSendMessageView];
            } else {
                [self showToastWithMsg:[NSString stringWithFormat:@"错误：%@", code]];
                [self showSendMessageView];
            }
        }
    } else {
        [self showToastWithMsg:@"返回数据格式错误"];
        [self showSendMessageView];
    }
}

- (void)parseSMSObject:(NSData *)data
{
    NSError *jsonSerializationError;
    
    NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:&jsonSerializationError];
    
    if (!jsonSerializationError) {
        
        id code = [dict objectForKey:@"code"];
        
        if (code && [code isKindOfClass:[NSNumber class]]) {
            
            if ([code integerValue] == 200) {
                // 验证码发送成功
                [self startTime:self.timeButton];
                [self showToastWithMsg:@"短信发送成功"];
            } else {
                [self showToastWithMsg:@"短信发送失败"];
            }
        }
    }
}

- (void)verifySuccess
{
    NTESQPLoginSuccessViewController *vc = [[NTESQPLoginSuccessViewController alloc] init];
    vc.themeTitle = self.themeTitle;
    vc.type = NTESQuickPassType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startTime:(UIButton *)button
{
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timeNew = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timeNew, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timeNew, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timeNew);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"重新发送" forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromHex(0x0062ff) forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
            });
        } else {
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"（%@秒）", strTime] forState:UIControlStateNormal];
                [button setTitleColor:UIColorFromHex(0x000000) forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
            });
            timeout--;
        }
    });
    dispatch_resume(timeNew);
}

- (void)sendMessage
{
    NSString *urlString = [NSString stringWithFormat:@"%@?phone=%@", API_LOGIN_SMS_SEND, self.phoneNumberTextField.text];
    [NTESDemoHttpRequest startRequestWithURL:urlString httpMethod:@"GET" requestData:nil finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                [self parseSMSObject:data];
            } else {
                [self showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
            }
        });
    }];
}

- (void)__initThemeLabel
{
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = [UIFont systemFontOfSize:24.0*KHeightScale];
        _themeLabel.text = self.themeTitle;
        [self.view addSubview:_themeLabel];
        [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(118.5*KHeightScale);
            make.left.equalTo(self.view).offset(34*KWidthScale);
        }];
    }
}

- (void)__initTextField
{
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[UITextField alloc] init];
        _phoneNumberTextField.placeholder = @"请输入手机号";
        _phoneNumberTextField.font = [UIFont systemFontOfSize:15.0*KHeightScale];
        [self.view addSubview:_phoneNumberTextField];
        [_phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.themeLabel);
            make.right.equalTo(self.view).offset(-34*KWidthScale);
            make.top.equalTo(self.themeLabel.mas_bottom).offset(41*KHeightScale);
        }];
    }
}

- (void)__initSeparateLine
{
    if (!_secondSeparateLine) {
        _secondSeparateLine = [[UIView alloc] init];
        [_secondSeparateLine setBackgroundColor:UIColorFromHex(0xe2e2e2)];
        [self.view addSubview:_secondSeparateLine];
        [_secondSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneNumberTextField);
            make.right.equalTo(self.phoneNumberTextField);
            make.top.equalTo(self.phoneNumberTextField.mas_bottom).offset(12*KHeightScale);
            make.height.equalTo(@0.5);
        }];
    }
}

- (void)__initNextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_nextButton setTitle:nextTitle forState:UIControlStateNormal];
        [_nextButton setTitle:nextTitle forState:UIControlStateHighlighted];
        _nextButton.titleLabel.textColor = [UIColor whiteColor];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:15.0*KHeightScale];
        _nextButton.layer.cornerRadius = 44.0*KHeightScale/2;
        _nextButton.layer.masksToBounds = YES;
        [_nextButton addTarget:self action:@selector(doPhoneNumberVerify) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.secondSeparateLine.mas_bottom).offset(33*KHeightScale);
            make.left.equalTo(self.phoneNumberTextField);
            make.right.equalTo(self.phoneNumberTextField);
            make.height.equalTo(@(44*KHeightScale));
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 307*KWidthScale, 44*KHeightScale);
        gradientLayer.colors = @[(id)UIColorFromHex(0x60b1fe).CGColor, (id)UIColorFromHex(0x6551f6).CGColor];
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        [_nextButton.layer insertSublayer:gradientLayer atIndex:0];
    }
}

- (void)updateView
{
    [self.phoneNumberTextField mas_updateConstraints:^(MASConstraintMaker *make) {
       make.left.equalTo(self.themeLabel);
       make.right.equalTo(self.view).offset(-154*KWidthScale);
       make.top.equalTo(self.themeLabel.mas_bottom).offset(41*KHeightScale);
    }];

    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.timeButton];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:15.0*KHeightScale];
    [self.timeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.timeButton setTitleColor:UIColorFromHex(0x0062ff) forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneNumberTextField);
        make.width.equalTo(@(120*KWidthScale));
        make.height.equalTo(@(21*KHeightScale));
        make.right.equalTo(self.view).offset(-34*KWidthScale);
    }];
    
    self.firstSeparateLine = [[UIView alloc] init];
    [self.firstSeparateLine setBackgroundColor:UIColorFromHex(0xe2e2e2)];
    [self.view addSubview:self.firstSeparateLine];
    [self.firstSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLabel);
        make.right.equalTo(self.view).offset(-34*KWidthScale);
        make.top.equalTo(self.phoneNumberTextField.mas_bottom).offset(11.5*KHeightScale);
        make.height.equalTo(@0.5);
    }];
    
    self.verifyCodeTextField = [[UITextField alloc] init];
    self.verifyCodeTextField.placeholder = @"请输入验证码";
    self.verifyCodeTextField.font = [UIFont systemFontOfSize:15.0*KHeightScale];
    [self.view addSubview:self.verifyCodeTextField];
    [self.verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLabel);
        make.right.equalTo(self.view).offset(-34*KWidthScale);
        make.top.equalTo(self.firstSeparateLine.mas_bottom).offset(19.5*KHeightScale);
    }];
    
    [self.secondSeparateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verifyCodeTextField);
        make.right.equalTo(self.verifyCodeTextField);
        make.top.equalTo(self.verifyCodeTextField.mas_bottom).offset(11.5*KHeightScale);
        make.height.equalTo(@0.5);
    }];
    
    [self.nextButton removeTarget:self action:@selector(doPhoneNumberVerify) forControlEvents:UIControlEventTouchUpInside];
    [_nextButton setTitle:self.themeTitle forState:UIControlStateNormal];
    [_nextButton setTitle:self.themeTitle forState:UIControlStateHighlighted];
    [self.nextButton addTarget:self action:@selector(verifySMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondSeparateLine.mas_bottom).offset(31.5*KHeightScale);
        make.left.equalTo(self.verifyCodeTextField);
        make.right.equalTo(self.verifyCodeTextField);
        make.height.equalTo(@(44*KHeightScale));
    }];
}

- (void)showToastWithMsg:(NSString *)msg
{
    if (@available(iOS 8.0, *)) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                       message:msg
                                                                preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:nil];
        [alert addAction:action];
        [self presentViewController:alert animated:NO completion:nil];
        
    } else {
        // Fallback on earlier versions
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
        [alert show];
    }
}

@end
