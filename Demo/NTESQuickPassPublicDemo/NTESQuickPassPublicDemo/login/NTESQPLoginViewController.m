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
#import "UIColor+NTESQuickPass.h"

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

@property (nonatomic, strong) UIImageView *phoneImageView;
@property (nonatomic, strong) UIImageView *codeImageView;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation NTESQPLoginViewController

- (instancetype)init {
    if (self = [super init]) {
//        self.showQuickPassBottomView = YES;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    self.manager = [NTESQuickPassManager sharedInstance];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleView.text = @"易盾本机校验";
    titleView.font = [UIFont systemFontOfSize:17];
    titleView.textColor = [UIColor ntes_colorWithHexString:@"#333333"];
    self.navigationItem.titleView = titleView;
      
    UIImageView *backImageView = [[UIImageView alloc] init];
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(leftBarButtonItemDidTipped)];
    [backImageView addGestureRecognizer:tap];
    backImageView.userInteractionEnabled = YES;
    backImageView.image = [UIImage imageNamed:@"back"];
    backImageView.frame = CGRectMake(0, 0, 18, 18);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backImageView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(valeChange:) name:UITextFieldTextDidChangeNotification object:self.phoneNumberTextField];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    [self setupLine];
}

- (void)setupLine {
    CGFloat navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44;
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor ntes_colorWithHexString:@"#C5C5C7"];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(navHeight);
        make.height.mas_equalTo(1);
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self customInitSubViews];
}

- (void)didChangeRotate:(NSNotification *)notification {
    [self.view endEditing:YES];
    
    CGFloat navHeight;
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
        || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
        navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44;
    } else {
        navHeight = 44;
    }
    if (self.lineView) {
        [self.lineView removeFromSuperview];    
        self.lineView = nil;
    }
    
    UIView *lineView = [[UIView alloc] init];
    self.lineView = lineView;
    lineView.backgroundColor = [UIColor ntes_colorWithHexString:@"#C5C5C7"];
    [self.view addSubview:lineView];
    [lineView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view).mas_offset(navHeight);
        make.height.mas_equalTo(1);
    }];
    
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
           || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
    
        CGFloat navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44;
        [self.themeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(60 + navHeight);
            make.right.equalTo(self.view.mas_centerX).offset(-40);
        }];
    } else {
        CGFloat navHeight = 44;
        [self.themeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(30 + navHeight);
            make.right.equalTo(self.view.mas_centerX).offset(-40);
        }];
    }
    
    [self customInitSubViews];
}

- (void)valeChange:(NSNotification *)notification {
//    [self.view endEditing:YES];
    UITextField *textField = notification.object;
    NSString *content = textField.text;
    if (content.length > 0) {
        self.nextButton.enabled = YES;
        self.nextButton.alpha = 1;
    } else {
        self.nextButton.enabled = NO;
        self.nextButton.alpha = 0.5;
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (@available(iOS 13.0, *)) {
        return UIStatusBarStyleDarkContent;
    } else {
        return UIStatusBarStyleDefault;
    }
}

- (void)leftBarButtonItemDidTipped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInitSubViews {
//    self.showQuickPassBottomView = YES;
    [self __initThemeLabel];
    [self __initTextField];
    [self __initSeparateLine];
    [self __initNextButton];
}

- (void)doPhoneNumberVerify {
    // test
//    self.phoneNumberTextField.text = @"13251026527";
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

- (void)showSendMessageView {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self updateView];
    });
}

- (void)startCheck {
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
//                [self showSendMessageView];
            } else {
                [self showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
                [self showSendMessageView];
            }
        });
    }];
}

- (void)verifySMSCode {
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

- (void)parseCheckObject:(NSData *)data {
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

- (void)parseSMSObject:(NSData *)data {
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

- (void)verifySuccess {
    NTESQPLoginSuccessViewController *vc = [[NTESQPLoginSuccessViewController alloc] init];
    vc.themeTitle = self.themeTitle;
    vc.type = NTESQuickPassType;
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)startTime:(UIButton *)button {
    __block int timeout = 60;
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    dispatch_source_t timeNew = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER, 0, 0, queue);
    dispatch_source_set_timer(timeNew, dispatch_walltime(NULL, 0), 1.0 * NSEC_PER_SEC, 0);
    dispatch_source_set_event_handler(timeNew, ^{
        if (timeout <= 0) {
            dispatch_source_cancel(timeNew);
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:@"重新发送" forState:UIControlStateNormal];
                [button setTitleColor:[UIColor ntes_colorWithHexString:@"#324DFF"] forState:UIControlStateNormal];
                button.userInteractionEnabled = YES;
                button.layer.borderColor = [UIColor ntes_colorWithHexString:@"#324DFF"].CGColor;
            });
        } else {
            NSString *strTime = [NSString stringWithFormat:@"%d", timeout];
            dispatch_async(dispatch_get_main_queue(), ^{
                [button setTitle:[NSString stringWithFormat:@"%@s", strTime] forState:UIControlStateNormal];
                [button setTitleColor:[UIColor ntes_colorWithHexString:@"#666666"] forState:UIControlStateNormal];
                button.userInteractionEnabled = NO;
                button.layer.borderColor = [UIColor clearColor].CGColor;
            });
            timeout--;
        }
    });
    dispatch_resume(timeNew);
}

- (void)sendMessage {
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

- (void)__initThemeLabel {
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
        _themeLabel.text = @"注册/登录";
        _themeLabel.textColor = [UIColor ntes_colorWithHexString:@"#333333"];
        [self.view addSubview:_themeLabel];
        CGFloat navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44;
        [_themeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.view).offset(60 + navHeight);
            make.right.equalTo(self.view.mas_centerX).offset(-40);
        }];
    }
}

- (void)__initTextField {
    if (!_phoneImageView) {
        _phoneImageView = [[UIImageView alloc] init];
        _phoneImageView.image = [UIImage imageNamed:@"ic_phone"];
        [self.view addSubview:_phoneImageView];
        [_phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.themeLabel.mas_bottom).offset(41);
            make.left.equalTo(self.themeLabel);
            make.size.mas_equalTo(CGSizeMake(14, 14));
        }];
    }
    
    if (!_phoneNumberTextField) {
        _phoneNumberTextField = [[UITextField alloc] init];
//        _phoneNumberTextField.placeholder = @"请输入手机号";
        _phoneNumberTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor ntes_colorWithHexString:@"#999999"]}];
        _phoneNumberTextField.font = [UIFont systemFontOfSize:15.0];
        _phoneNumberTextField.textColor = [UIColor ntes_colorWithHexString:@"#333333 "];
        [self.view addSubview:_phoneNumberTextField];
        [_phoneNumberTextField mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(self.phoneImageView.mas_right).mas_offset(11);
            make.right.equalTo(self.view).offset(-34);
            make.centerY.equalTo(self.phoneImageView);
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
            make.left.equalTo(self.phoneNumberTextField).mas_offset(-25);
            make.right.equalTo(self.view.mas_centerX).mas_offset(150);
            make.top.equalTo(self.phoneNumberTextField.mas_bottom).offset(12);
            make.height.equalTo(@0.5);
        }];
    }
}

- (void)__initNextButton
{
    if (!_nextButton) {
        _nextButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _nextButton.enabled = NO;
        _nextButton.alpha = 0.5;
        [_nextButton setTitle:nextTitle forState:UIControlStateNormal];
        [_nextButton setTitle:nextTitle forState:UIControlStateHighlighted];
        _nextButton.titleLabel.textColor = [UIColor whiteColor];
        _nextButton.titleLabel.font = [UIFont systemFontOfSize:15.0];
        _nextButton.layer.cornerRadius = 8;
        _nextButton.layer.masksToBounds = YES;
        [_nextButton addTarget:self action:@selector(doPhoneNumberVerify) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:_nextButton];
        [_nextButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.secondSeparateLine.mas_bottom).offset(33);
            make.left.equalTo(self.themeLabel);
            make.right.equalTo(self.view.mas_centerX).mas_offset(150);
            make.height.equalTo(@(44));
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        gradientLayer.frame = CGRectMake(0, 0, 307, 44);
        gradientLayer.colors = @[(id)[UIColor ntes_colorWithHexString:@"#5F83FE"].CGColor, (id)[UIColor ntes_colorWithHexString:@"#324DFF"].CGColor];
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        [_nextButton.layer insertSublayer:gradientLayer atIndex:0];
    }
}

- (void)updateView
{
//    [self.themeLabel mas_updateConstraints:^(MASConstraintMaker *make) {
//       make.left.equalTo(self.themeLabel);
//       make.right.equalTo(self.view).offset(-154);
//       make.top.equalTo(self.themeLabel.mas_bottom).offset(41);
//    }];
    
    self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.timeButton.layer.cornerRadius = 3;
    self.timeButton.layer.masksToBounds = YES;
    [self.view addSubview:self.timeButton];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.timeButton.layer.borderColor = [UIColor ntes_colorWithHexString:@"#324DFF"].CGColor;
    self.timeButton.layer.borderWidth = 1;
    [self.timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.timeButton setTitleColor:[UIColor ntes_colorWithHexString:@"#324DFF"] forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.timeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.phoneNumberTextField);
        make.width.equalTo(@(80));
        make.height.equalTo(@(28));
        make.right.equalTo(self.view.mas_centerX).offset(150);
    }];

    self.firstSeparateLine = [[UIView alloc] init];
    [self.firstSeparateLine setBackgroundColor:UIColorFromHex(0xe2e2e2)];
    [self.view addSubview:self.firstSeparateLine];
    [self.firstSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLabel);
        make.right.equalTo(self.view.mas_centerX).offset(150);
        make.top.equalTo(self.phoneNumberTextField.mas_bottom).offset(11.5);
        make.height.equalTo(@0.5);
    }];
    
    _codeImageView = [[UIImageView alloc] init];
    _codeImageView.image = [UIImage imageNamed:@"ic_namb-1"];
    [self.view addSubview:_codeImageView];
    [_codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
       make.top.equalTo(self.firstSeparateLine.mas_bottom).offset(19.5);
       make.left.equalTo(self.themeLabel);
       make.size.mas_equalTo(CGSizeMake(14, 14));
    }];
    
    self.verifyCodeTextField = [[UITextField alloc] init];
    self.verifyCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor ntes_colorWithHexString:@"#999999"]}];
    self.verifyCodeTextField.font = [UIFont systemFontOfSize:15.0];
    self.verifyCodeTextField.textColor = [UIColor ntes_colorWithHexString:@"#333333 "];
    [self.view addSubview:self.verifyCodeTextField];
    [self.verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeImageView.mas_right).mas_offset(11);
        make.right.equalTo(self.view.mas_centerX).offset(150);
        make.centerY.equalTo(self.codeImageView);
    }];
    
    [self.secondSeparateLine mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLabel);
        make.right.equalTo(self.verifyCodeTextField);
        make.top.equalTo(self.verifyCodeTextField.mas_bottom).offset(11.5);
        make.height.equalTo(@0.5);
    }];
    
    [self.nextButton removeTarget:self action:@selector(doPhoneNumberVerify) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton addTarget:self action:@selector(verifySMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.nextButton mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondSeparateLine.mas_bottom).offset(31.5);
        make.left.equalTo(self.verifyCodeTextField);
        make.right.equalTo(self.view.mas_centerX).mas_offset(150);
        make.height.equalTo(@(44));
    }];
}

- (void)showToastWithMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
