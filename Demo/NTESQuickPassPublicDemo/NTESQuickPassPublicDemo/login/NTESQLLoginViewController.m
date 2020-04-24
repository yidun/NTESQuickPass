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
#import "UIColor+NTESQuickPass.h"
#import "NTESToastView.h"

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

@property (nonatomic, strong) UIImageView *phoneImageView;
@property (nonatomic, strong) UIImageView *codeImageView;

@property (nonatomic, strong) UIView *customBottomView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation NTESQLLoginViewController

- (instancetype)init {
    if (self = [super init]) {
        self.carrierType = [[NTESQuickLoginManager sharedInstance] getCarrier];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self customInitSubViews];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeScreenRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [NTESToastView showNotice:@"一键登录失败，自动降级为手机短信校验"];
}

- (void)didChangeScreenRotate:(NSNotification *)notification {
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) {
        _model.faceOrientation = UIInterfaceOrientationLandscapeLeft;
    } else if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
        _model.faceOrientation = UIInterfaceOrientationLandscapeRight;
    } else if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait) {
       _model.faceOrientation = UIInterfaceOrientationPortrait;
    }
    
    [self updateView];
    
    if (_model.authWindowPop != NTESAuthWindowPopCenter) {
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
    }
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    if (_model.authWindowPop == NTESAuthWindowPopCenter) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
        self.lineView.hidden = YES;
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
         self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
       
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    titleView.text = @"易盾一键登录";
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
}

- (void)leftBarButtonItemDidTipped {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)customInitSubViews {
//    [self shouldHideBottomView:YES];
    [self __initThemeLabel];
    [self __initPhoneLabel];
    [self __initQuickLoginButton];
    [self __initCustomBottomView];
    
//    if (self.carrierType == 1) {
//        [self.quickLoginButton setUserInteractionEnabled:NO];
//        [self.quickLoginButton setAlpha:0.7];
//    }
}

- (void)__initThemeLabel {
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:24];
        _themeLabel.text = @"注册/登录";
        _themeLabel.textColor = [UIColor ntes_colorWithHexString:@"#333333"];
        [self.customBottomView addSubview:_themeLabel];
        NTESAuthWindowPop authWindowPop = self.model.authWindowPop;
        [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            if (authWindowPop == NTESAuthWindowPopCenter) {
                make.top.equalTo(self.customBottomView).mas_offset(30);
                make.right.equalTo(self.customBottomView.mas_centerX).mas_offset(-20);
            } else {
                make.top.equalTo(self.customBottomView).mas_offset(IS_IPHONE_X ? 124 : 104);
                make.right.equalTo(self.customBottomView.mas_centerX).mas_offset(-40);
            }
        }];
    }
}

- (void)__initPhoneLabel
{
    if (!_phoneLabel) {
        _phoneLabel = [[UILabel alloc] init];
        _phoneLabel.font = [UIFont systemFontOfSize:20.0*KHeightScale];
        [self.customBottomView addSubview:_phoneLabel];
        [_phoneLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.themeLabel.mas_bottom).offset(56.5*KHeightScale);
            make.centerX.equalTo(self.customBottomView);
        }];
    }
}

- (void)__initActivityIndicator
{
    if (!_activityIndicator) {
        _activityIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        [_activityIndicator setColor:[UIColor blueColor]];
        [self.customBottomView addSubview:_activityIndicator];
        [_activityIndicator mas_makeConstraints:^(MASConstraintMaker *make) {
            make.center.equalTo(self.customBottomView);
            make.width.equalTo(@200);
            make.height.equalTo(@200);
        }];
    }
}

- (void)__initQuickLoginButton {
    if (!_quickLoginButton) {
        NTESAuthWindowPop authWindowPop = self.model.authWindowPop;
        _quickLoginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        NSString *title = @"注册/登录";
        [_quickLoginButton setTitle:title forState:UIControlStateNormal];
        [_quickLoginButton setTitle:title forState:UIControlStateHighlighted];
        [_quickLoginButton setTitleColor:[UIColor ntes_colorWithHexString:@"#FFFFFF"] forState:UIControlStateNormal];
        [_quickLoginButton setTitleColor:[UIColor ntes_colorWithHexString:@"#FFFFFF"] forState:UIControlStateHighlighted];
        _quickLoginButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _quickLoginButton.layer.cornerRadius = 8;
        _quickLoginButton.layer.masksToBounds = YES;
        [_quickLoginButton addTarget:self action:@selector(authorizeLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
        [self.customBottomView addSubview:_quickLoginButton];
        
        [_quickLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.phoneLabel.mas_bottom).offset(30);
            make.centerX.equalTo(self.customBottomView);
            make.height.equalTo(@(44));
            if (authWindowPop == NTESAuthWindowPopCenter) {
                make.width.equalTo(@(235));
            } else {
                make.width.equalTo(@(295));
            }
        }];
        
        CAGradientLayer *gradientLayer = [CAGradientLayer layer];
        if (authWindowPop == NTESAuthWindowPopCenter) {
            gradientLayer.frame = CGRectMake(0, 0, 235, 44);
        } else {
            gradientLayer.frame = CGRectMake(0, 0, 295, 44);
        }
        gradientLayer.colors = @[(id)[UIColor ntes_colorWithHexString:@"#5F83FE"].CGColor, (id)[UIColor ntes_colorWithHexString:@"#324DFF"].CGColor];
        gradientLayer.startPoint = CGPointMake(0.0, 0.5);
        gradientLayer.endPoint = CGPointMake(1.0, 0.5);
        [_quickLoginButton.layer insertSublayer:gradientLayer atIndex:0];
    }
}

- (void)__initCustomBottomView
{
    if (!_bottomView) {
        _bottomView = [[UIView alloc] init];
        [self.customBottomView addSubview:_bottomView];
        CGFloat bottomWhiteHeight = -20;
        [_bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.bottom.equalTo(self.customBottomView).offset(bottomWhiteHeight);
            make.width.equalTo(@(168*KWidthScale));
            make.height.equalTo(@(16.5*KHeightScale));
            make.centerX.equalTo(self.customBottomView);
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

- (void)getPhoneNumber {
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

- (void)authorizeLoginButtonClick {
    [NTESQPVerifyingPopView showVerifyingFromView:self.customBottomView title:verifyingQLText];
    [[NTESQuickLoginManager sharedInstance] CTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        dispatch_async(dispatch_get_main_queue(), ^{
            NSNumber *boolNum = [resultDic objectForKey:@"success"];
            BOOL success = [boolNum boolValue];
            if (success) {
                self.accessToken = [resultDic objectForKey:@"accessToken"];
                [self startCheckAuthorize];
            } else {
                [NTESQPVerifyingPopView hideVerifyingView];
#ifdef TEST_MODE_QA
                [self showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
#endif
                [self updateView];
            }
        });
    }];
}

- (void)startCheckAuthorize {
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
    
    [NTESDemoHttpRequest startRequestWithURL:@"" httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [NTESQPVerifyingPopView hideVerifyingView];
            if (data) {
                [self parseCheckObject:data];
            } else {
#ifdef TEST_MODE_QA
                [self showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
#endif
                [self updateView];
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
                NSDictionary *data = [dict objectForKey:@"data"];
                id phone = [data objectForKey:@"phone"];
                
                if (phone && [phone isKindOfClass:[NSString class]]) {
                    NSString *phoneNum = phone;
                    if (phoneNum.length > 0) {
                        [self verifySuccess];
                    } else {
#ifdef TEST_MODE_QA
                        [self showToastWithMsg:@"一键登录失败"];
#endif
                        [self updateView];
                    }
                }
            } else if ([code integerValue] == 1003){
                [self updateView];
            } else {
#ifdef TEST_MODE_QA
                [self showToastWithMsg:[NSString stringWithFormat:@"错误，code=%@", code]];
#endif
                [self updateView];
            }
        }
    } else {
#ifdef TEST_MODE_QA
        [self showToastWithMsg:@"返回数据格式错误"];
#endif
        [self updateView];
    }
}

- (void)sendMessage {
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
    NSString *urlString = [NSString stringWithFormat:@"%@?phone=%@", @"", self.phoneTextField.text];
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
                button.userInteractionEnabled = YES;
                button.layer.borderColor = [UIColor ntes_colorWithHexString:@"#324DFF"].CGColor;
                [button setTitleColor:[UIColor ntes_colorWithHexString:@"#324DFF"] forState:UIControlStateNormal];
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

/// 点击按钮验证手机号和密码
- (void)verifySMSCode {
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
    
    [NTESDemoHttpRequest startRequestWithURL:@"" httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
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
    vc.model = self.model;
    if (_model.authWindowPop == NTESAuthWindowPopCenter) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[UIApplication sharedApplication].delegate.window.rootViewController presentViewController:vc animated:YES completion:nil];
    } else {
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (void)showService
{
    NTESQLServiceViewController *vc = [[NTESQLServiceViewController alloc] init];
    switch (self.carrierType) {
        case 1:
//            vc.serviceHTML = CTServiceHTML;
            break;
        case 2:
//            vc.serviceHTML = CMServiceHTML;
        case 3:
            break;
        default:
//            vc.serviceHTML = CMServiceHTML;
            break;
    }
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)showToastWithMsg:(NSString *)msg
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)updateView {
    [self.phoneLabel removeFromSuperview];
    
    CGFloat authWindowCenterOriginY = self.model.authWindowCenterOriginY;
    CGFloat authWindowCenterOriginX = self.model.authWindowCenterOriginX;
    int popCenterCornerRadius = self.model.popCenterCornerRadius;
    int popBottomCornerRadius = self.model.popBottomCornerRadius;
    NTESAuthWindowPop authWindowPop = self.model.authWindowPop;
 
    if (popCenterCornerRadius <= 0) {
        popCenterCornerRadius = 16;
    }
    if (popBottomCornerRadius <= 0) {
        popBottomCornerRadius = 16;
    }
    
    if (_customBottomView == nil) {
        _customBottomView = [[UIView alloc] init];
    }
    _customBottomView.layer.cornerRadius = popCenterCornerRadius;
    _customBottomView.layer.masksToBounds = YES;
    _customBottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_customBottomView];
    if (authWindowPop == NTESAuthWindowPopCenter) {
        UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeSystem];
        [closeButton addTarget:self action:@selector(closeButtonDidTipped) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setImage:[[UIImage imageNamed:@"ic_close"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] forState:UIControlStateNormal];
        self.closeButton = closeButton;
        [_customBottomView addSubview:closeButton];
        [closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.right.equalTo(self.customBottomView).mas_offset(-10);
            make.top.equalTo(self.customBottomView).mas_offset(10);
        }];
        self.view.backgroundColor = [UIColor clearColor];
        [_customBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).mas_offset(authWindowCenterOriginX);
            make.centerY.equalTo(self.view).mas_offset(authWindowCenterOriginY);
            make.size.mas_offset(CGSizeMake(285, 315));
        }];
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        [_customBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
 
    if (!_phoneImageView) {
       _phoneImageView = [[UIImageView alloc] init];
       _phoneImageView.image = [UIImage imageNamed:@"ic_phone"];
       [self.customBottomView addSubview:_phoneImageView];
       [_phoneImageView mas_makeConstraints:^(MASConstraintMaker *make) {
          make.top.equalTo(self.themeLabel.mas_bottom).offset(60);
          make.left.equalTo(self.themeLabel);
          make.size.mas_equalTo(CGSizeMake(14, 14));
       }];
    }
    
    if (self.phoneTextField == nil) {
        self.phoneTextField = [[UITextField alloc] init];
    }
    self.phoneTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"手机号" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor ntes_colorWithHexString:@"#999999"]}];
    self.phoneTextField.font = [UIFont systemFontOfSize:15.0];
    self.phoneTextField.textColor = [UIColor ntes_colorWithHexString:@"#333333"];
    [self.customBottomView addSubview:self.phoneTextField];
    [self.phoneTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.phoneImageView.mas_right).mas_offset(11);
        make.right.equalTo(self.customBottomView).offset(-154);
        make.centerY.equalTo(self.phoneImageView);
    }];
    
    if (self.timeButton == nil) {
         self.timeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    }
    self.timeButton.layer.cornerRadius = 3;
    self.timeButton.layer.masksToBounds = YES;
    [self.customBottomView addSubview:self.timeButton];
    self.timeButton.titleLabel.font = [UIFont systemFontOfSize:12.0];
    self.timeButton.layer.borderColor = [UIColor ntes_colorWithHexString:@"#324DFF"].CGColor;
    self.timeButton.layer.borderWidth = 1;
    [self.timeButton setTitle:@"获取验证码" forState:UIControlStateNormal];
    [self.timeButton setTitleColor:[UIColor ntes_colorWithHexString:@"#324DFF"] forState:UIControlStateNormal];
    [self.timeButton addTarget:self action:@selector(sendMessage) forControlEvents:UIControlEventTouchUpInside];
    self.timeButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
    [self.timeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
       make.centerY.equalTo(self.phoneTextField);
       make.width.equalTo(@(80));
       make.height.equalTo(@(28));
        if (authWindowPop == NTESAuthWindowPopCenter) {
            make.right.equalTo(self.customBottomView).offset(-30);
        } else {
            make.right.equalTo(self.customBottomView.mas_centerX).offset(150);
        }
    }];
    
    if (self.firstSeparateLine == nil) {
        self.firstSeparateLine = [[UIView alloc] init];
    }
    [self.firstSeparateLine setBackgroundColor:UIColorFromHex(0xe2e2e2)];
    [self.customBottomView addSubview:self.firstSeparateLine];
    [self.firstSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLabel);
        if (authWindowPop == NTESAuthWindowPopCenter) {
            make.right.equalTo(self.customBottomView).mas_offset(-30);
        } else {
            make.right.equalTo(self.customBottomView.mas_centerX).mas_offset(150);
        }
        make.top.equalTo(self.phoneTextField.mas_bottom).offset(11.5);
        make.height.equalTo(@0.5);
    }];
    
    if (!_codeImageView) {
          _codeImageView = [[UIImageView alloc] init];
          _codeImageView.image = [UIImage imageNamed:@"ic_namb"];
          [self.customBottomView addSubview:_codeImageView];
          [_codeImageView mas_makeConstraints:^(MASConstraintMaker *make) {
             make.top.equalTo(self.firstSeparateLine.mas_bottom).offset(20);
             make.left.equalTo(self.themeLabel);
             make.size.mas_equalTo(CGSizeMake(14, 14));
          }];
       }
    
    if (self.verifyCodeTextField == nil) {
        self.verifyCodeTextField = [[UITextField alloc] init];
    }
    self.verifyCodeTextField.attributedPlaceholder = [[NSAttributedString alloc] initWithString:@"验证码" attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15],NSForegroundColorAttributeName : [UIColor ntes_colorWithHexString:@"#999999"]}];
    self.verifyCodeTextField.font = [UIFont systemFontOfSize:15.0];
    self.verifyCodeTextField.textColor = [UIColor ntes_colorWithHexString:@"#333333 "];
    [self.customBottomView addSubview:self.verifyCodeTextField];
    [self.verifyCodeTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.codeImageView.mas_right).mas_offset(11);
        make.right.equalTo(self.customBottomView).offset(-34);
        make.centerY.equalTo(self.codeImageView);
    }];
    
    if (self.secondSeparateLine == nil) {
        self.secondSeparateLine = [[UIView alloc] init];
    }
    [self.secondSeparateLine setBackgroundColor:UIColorFromHex(0xe2e2e2)];
    [self.customBottomView addSubview:self.secondSeparateLine];
    [self.secondSeparateLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.themeLabel);
        if (authWindowPop == NTESAuthWindowPopCenter) {
            make.right.equalTo(self.customBottomView).mas_offset(-30);
        } else {
            make.right.equalTo(self.customBottomView.mas_centerX).mas_offset(150);
        }
        make.top.equalTo(self.verifyCodeTextField.mas_bottom).offset(11.5);
        make.height.equalTo(@0.5);
    }];
    
    [self.quickLoginButton removeTarget:self action:@selector(authorizeLoginButtonClick) forControlEvents:UIControlEventTouchUpInside];
    [self.quickLoginButton setTitle:@"注册/登录" forState:UIControlStateNormal];
    [self.quickLoginButton setTitle:@"注册/登录" forState:UIControlStateHighlighted];
    [self.quickLoginButton addTarget:self action:@selector(verifySMSCode) forControlEvents:UIControlEventTouchUpInside];
    [self.customBottomView addSubview:self.quickLoginButton];
     [_quickLoginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.secondSeparateLine.mas_bottom).offset(30);
        make.centerX.equalTo(self.customBottomView);
        make.height.equalTo(@(44));
         if (authWindowPop == NTESAuthWindowPopCenter) {
             make.width.equalTo(@(235));
         } else {
             make.width.equalTo(@(295));
         }
    }];
    
    [self.bottomView removeFromSuperview];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}


- (void)closeButtonDidTipped {
    [self dismissViewControllerAnimated:YES completion:nil];
}

@end
