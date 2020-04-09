//
//  NTESQLLoginViewController.m
//  NTESQuickPassPublicDemo
//
//  Created by Ke Xu on 2019/1/31.
//  Copyright © 2019 Xu Ke. All rights reserved.
//

#import "NTESQLLoginViewController.h"
#import <Masonry.h>
#import "NTESQPDemoDefines.h"
#import <NTESQuickPass/NTESQuickPass.h>
#import <WebKit/WebKit.h>
#import "NTESQLServiceViewController.h"
#import "NTESQPVerifyingPopView.h"
#import "NTESQPLoginSuccessViewController.h"
#import "NTESDemoHttpRequest.h"

/**
 *    服务协议跳转页面地址：
 *    移动协议：
 *    https://wap.cmpassport.com/resources/html/contract.html
 *    电信协议
 *    https://e.189.cn/sdk/agreement/content.do?type=main&appKey=&hidetop=true&returnUrl=
 */

@interface NTESQLLoginViewController ()

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UILabel *phoneLabel;

@property (nonatomic, strong) UIButton *quickLoginButton;

@property (nonatomic, strong) UIView *bottomView;

@property (copy, nonatomic) NSString *accessToken;

@property (nonatomic, strong) UIButton *timeButton;

@property (nonatomic, strong) UIView *firstSeparateLine;

@property (nonatomic, strong) UIView *secondSeparateLine;

@property (nonatomic, strong) UITextField *phoneTextField;

@property (nonatomic, strong) UITextField *verifyCodeTextField;

@property (nonatomic, strong) UIActivityIndicatorView * activityIndicator;

@property (nonatomic, assign) NSInteger carrierType;

@end

@implementation NTESQLLoginViewController

- (instancetype)init
{
    if (self = [super init]) {
        self.showQuickPassBottomView = NO;
        self.carrierType = [[NTESQuickLoginManager sharedInstance] getCarrier];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self customInitSubViews];
}

- (void)customInitSubViews
{
    [self shouldHideBottomView:YES];
    [self __initThemeLabel];
    [self __initPhoneLabel];
    [self __initActivityIndicator];
    [self __initQuickLoginButton];
    [self __initCustomBottomView];
    
    if (self.carrierType == 1) {
        [self.activityIndicator startAnimating];
        [self.quickLoginButton setUserInteractionEnabled:NO];
        [self.quickLoginButton setAlpha:0.7];
    }
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

- (void)__initPhoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:20.0*KHeightScale];
        [self.view addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.themeLabel.mas_bottom).offset(56.5*KHeightScale);
            make.centerX.equalTo(self.view);
        }];
    }
}

- (void)__initActivityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setColor:[UIColor blueColor]];
        [self.view addSubview:_activityIndicator];
        [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.view);
            make.width.equalTo(@200);
            make.height.equalTo(@200);
        }];
    }
}

- (void)__initQuickLoginButton
{
    if (!_quickLoginButton) {
        _quickLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = [_themeTitle isEqualToString:loginTitle] ? quickLoginButtonTitle : quickRegisterButtonTitle;
        [_quickLoginButton setTitle:title forState:UIControlStateNormal];
        [_quickLoginButton setTitle:title forState:UIControlStateHighlighted];
        [_quickLoginButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateNormal];
        [_quickLoginButton setTitleColor:UIColorFromHex(0xffffff) forState:UIControlStateHighlighted];
        _quickLoginButton.titleLabel.font = [UIFont systemFontOfSize:15.0f*KHeightScale];
        _quickLoginButton.layer.cornerRadius = 44.0*KHeightScale/2;
        _quickLoginButton.layer.masksToBounds = YES;
        [_quickLoginButton addTarget:self action:@selector(authorizeLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_quickLoginButton];
        [_quickLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneLabel.mas_bottom).offset(32*KHeightScale);
            make.centerX.equalTo(self.view);
            make.height.equalTo(@(44*KHeightScale));
            make.width.equalTo(@(307*KWidthScale));
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 307*KWidthScale, 44*KHeightScale);
        gradientLayer.colors = @[(id)UIColorFromHex(0xAC5FF9).CGColor, (id)UIColorFromHex(0x7846F1).CGColor];
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        [_quickLoginButton.layer insertSublayer:gradientLayer atIndex:0];
    }
}

- (void)__initCustomBottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self.view addSubview:_bottomView];
        CGFloat bottomWhiteHeight = IS_IPHONE_X ? -44 : -20;
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.view).offset(bottomWhiteHeight);
            make.width.equalTo(@(168*KWidthScale));
            make.height.equalTo(@(16.5*KHeightScale));
            make.centerX.equalTo(self.view);
        }];
        
        UILabel *agreeLabel = [[UILabel alloc] init];
        agreeLabel.text = agreeText;
        agreeLabel.font = [UIFont systemFontOfSize:12.0*KHeightScale];
        agreeLabel.textColor = UIColorFromHex(0x999999);
        [self.bottomView addSubview:agreeLabel];
        [agreeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.bottomView);
            make.centerY.equalTo(self.bottomView);
        }];
        
        UIButton *agreeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *agreeTitle = CMService;
        switch (self.carrierType) {
            case 1:
                agreeTitle = CTService;
                break;
            case 2:
                agreeTitle = CMService;
                break;
            case 3:
                break;
            default:
                agreeTitle = CMService;
                break;
        }
        [agreeButton setTitle:agreeTitle forState:UIControlStateNormal];
        [agreeButton setTitle:agreeTitle forState:UIControlStateHighlighted];
        [agreeButton setTitleColor:UIColorFromHex(0x2a62ff) forState:UIControlStateNormal];
        [agreeButton setTitleColor:UIColorFromHex(0x2a62ff) forState:UIControlStateHighlighted];
        agreeButton.titleLabel.font = [UIFont systemFontOfSize:12.0*KHeightScale];
        [agreeButton addTarget:self action:@selector(showService) forControlEvents:UIControlEventTouchUpInside];
        [self.bottomView addSubview:agreeButton];
        [agreeButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(agreeLabel.mas_right);
            make.centerY.equalTo(self.bottomView);
        }];
    }
}

- (void)getPhoneNumber
{
    if (self.carrierType == 1) {
        [[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.activityIndicator stopAnimating];
                NSNumber *boolNum = [resultDic objectForKey:@"success"];
                BOOL success = [boolNum boolValue];
                if (success) {
                    self.phoneLabel.text = [resultDic objectForKey:@"securityPhone"];
                    [self.quickLoginButton setUserInteractionEnabled:YES];
                    [self.quickLoginButton setAlpha:1.0];
                } else {
#ifdef TEST_MODE_QA
                    [self showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
#endif
                    [self updateView];
                }
            });
        }];
    }
}

- (void)authorizeLoginButtonClick
{
    [NTESQPVerifyingPopView showVerifyingFromView:self.view title:verifyingQLText];
    [[NTESQuickLoginManager sharedInstance] CTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *boolNum = [resultDic objectForKey:@"success"];
            BOOL success = [boolNum boolValue];
            if (success) {
                self.accessToken = [resultDic objectForKey:@"accessToken"];
                [self startCheckAuthorize];
            } else {
                [NTESQPVerifyingPopView hideVerifyingView];
                [self showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
                [self updateView];
            }
        });
    }];
}

- (void)startCheckAuthorize
{
    NSDictionary *dict = @{
                           @"accessToken":self.accessToken?:@"",
                           @"token":self.token?:@"",
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
    
    [NTESDemoHttpRequest startRequestWithURL:API_LOGIN_TOKEN_QLCHECK httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NTESQPVerifyingPopView hideVerifyingView];
            if (data) {
                [self parseCheckObject:data];
            } else {
                [self showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
                [self updateView];
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
                NSDictionary *data = [dict objectForKey:@"data"];
                id phone = [data objectForKey:@"phone"];
                
                if (phone && [phone isKindOfClass:[NSString class]]) {
                    NSString *phoneNum = phone;
                    if (phoneNum.length > 0) {
                        [self verifySuccess];
                    } else {
                        [self showToastWithMsg:@"一键登录失败"];
                        [self updateView];
                    }
                }
            } else if ([code integerValue] == 1003){
                [self updateView];
            } else {
                [self showToastWithMsg:[NSString stringWithFormat:@"错误，code=%@", code]];
                [self updateView];
            }
        }
    } else {
        [self showToastWithMsg:@"返回数据格式错误"];
        [self updateView];
    }
}

- (void)sendMessage
{
    // 电信
//    self.phoneTextField.text = @"15356683517";
    // 移动
//    self.phoneTextField.text = @"18257124073";
    // 联通
//    self.phoneTextField.text = @"13251026527";
    if (self.phoneTextField.text.length < 11) {
        [self showToastWithMsg:@"请输入11位手机号"];
        return;
    }
    NSString *urlString = [NSString stringWithFormat:@"%@?phone=%@", API_LOGIN_SMS_SEND, self.phoneTextField.text];
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

- (void)verifySMSCode
{
    if (self.phoneTextField.text.length < 11) {
        [self showToastWithMsg:@"请输入11位手机号"];
        return;
    }
    NSDictionary *dict = @{
                           @"phone":self.phoneTextField.text,
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

- (void)verifySuccess
{
    NTESQPLoginSuccessViewController *vc = [[NTESQPLoginSuccessViewController alloc] init];
    vc.themeTitle = self.themeTitle;
    vc.type = NTESQuickLoginType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showService
{
    NTESQLServiceViewController *vc = [[NTESQLServiceViewController alloc] init];
    switch (self.carrierType) {
        case 1:
            vc.serviceHTML = CTServiceHTML;
            break;
        case 2:
            vc.serviceHTML = CMServiceHTML;
        case 3:
            break;
        default:
            vc.serviceHTML = CMServiceHTML;
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
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

- (void)updateView
{
    [self.phoneLabel removeFromSuperview];
    
    self.phoneTextField = [[UITextField alloc] init];
    self.phoneTextField.placeholder = @"请输入手机号";
    self.phoneTextField.font = [UIFont systemFontOfSize:15.0*KHeightScale];
    [self.view addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLabel);
        make.right.equalTo(self.view).offset(-154*KWidthScale);
        make.top.equalTo(self.themeLabel.mas_bottom).offset(39.5*KHeightScale);
    }];
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.view addSubview:self.timeButton];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:15.0*KHeightScale];
    [self.timeButton setTitle:@"发送验证码" forState:UIControlStateNormal];
    [self.timeButton setTitleColor:UIColorFromHex(0x0062ff) forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    [self.timeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneTextField);
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
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(11.5*KHeightScale);
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
    
    self.secondSeparateLine = [[UIView alloc] init];
    [self.secondSeparateLine setBackgroundColor:UIColorFromHex(0xe2e2e2)];
    [self.view addSubview:self.secondSeparateLine];
    [self.secondSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.verifyCodeTextField);
        make.right.equalTo(self.verifyCodeTextField);
        make.top.equalTo(self.verifyCodeTextField.mas_bottom).offset(11.5*KHeightScale);
        make.height.equalTo(@0.5);
    }];
    
    [self.quickLoginButton removeTarget:self action:@selector(authorizeLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.quickLoginButton setTitle:self.themeTitle forState:UIControlStateNormal];
    [self.quickLoginButton setTitle:self.themeTitle forState:UIControlStateHighlighted];
    [self.quickLoginButton addTarget:self action:@selector(verifySMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.quickLoginButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondSeparateLine.mas_bottom).offset(31.5*KHeightScale);
        make.left.equalTo(self.verifyCodeTextField);
        make.right.equalTo(self.verifyCodeTextField);
        make.height.equalTo(@(44*KHeightScale));
    }];
    
    [self.bottomView removeFromSuperview];
}

@end
