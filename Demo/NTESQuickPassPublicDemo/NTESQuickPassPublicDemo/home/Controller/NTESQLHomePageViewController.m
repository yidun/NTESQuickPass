
//
//  NTESQLHomePageViewController.m
//  NTESQuickPassPublicDemo
//
//  Created by Ke Xu on 2019/1/31.
//  Copyright © 2019 Xu Ke. All rights reserved.
//

#import "NTESQLHomePageViewController.h"
#import "NTESQPDemoDefines.h"
#import "NTESQLLoginViewController.h"
#import "NTESQPLoginSuccessViewController.h"
#import <NTESQuickPass/NTESQuickPass.h>
#import "NTESQLHomePagePortraitView.h"
#import "NTESDemoHttpRequest.h"
#import "NTESQLHomePageCustomUIModel.h"
#import "NTESQLHomePageNetworkEntity.h"
#import "NTESToastView.h"
#import "NTESQLHomePageLandscapeView.h"
#import "NTESQPLoginViewController.h"
#import "NTESQLNavigationView.h"
#import "UIColor+NTESQuickPass.h"
#import "NTESToastView.h"

@interface  NTESQLHomePageViewController() <UINavigationBarDelegate, NTESQLHomePagePortraitViewDelegate, NTESQLHomePageLandscapeViewDelegate>

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) NTESQLLoginViewController *loginViewController;

@property (nonatomic, assign) BOOL shouldQL;
@property (nonatomic, assign) BOOL precheckSuccess;

@property (nonatomic, strong) NTESQuickLoginModel *customModel;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) NSInteger popType;       /// 弹窗模式的样式
@property (nonatomic, assign) NSInteger portraitType;  /// 屏幕旋转的类型  0 竖屏  1 横屏

@property (nonatomic, strong) NTESQLHomePagePortraitView *pageView;
@property (nonatomic, strong) NTESQLHomePageLandscapeView *pageLandscapeView;

@property (nonatomic, assign) UIInterfaceOrientation faceOrientation;

@end

@implementation NTESQLHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self requestModelConfig];
    [self registerQuickLogin];
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeScreenRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)requestModelConfig {
    WeakSelf(self);
    [NTESQLHomePageNetworkEntity requestModelConfig:^(NTESQuickLoginModel * _Nullable model) {
        weakSelf.customModel = model;
    }];
}

- (void)didChangeScreenRotate:(NSNotification *)notification {
    [self deviceOrientation];
}

/// 设置UI
- (void)setupViews {
    [self deviceOrientation];
}

- (void)deviceOrientation {
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
           || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
           if (self.pageView == nil) {
               NTESQLHomePagePortraitView *pageView = [[NTESQLHomePagePortraitView alloc] init];
               self.pageView = pageView;
           }
           self.pageView.delegate = self;
           [self.view addSubview:self.pageView];
           [self.pageView mas_remakeConstraints:^(MASConstraintMaker *make) {
               make.edges.equalTo(self.view);
           }];
        _portraitType = 0; /// 竖屏
    } else {
        _portraitType = 1; /// 横屏
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) {
            self.faceOrientation = UIInterfaceOrientationLandscapeLeft;
        } else {
            self.faceOrientation = UIInterfaceOrientationLandscapeRight;
        }
        if (self.pageLandscapeView == nil) {
            NTESQLHomePageLandscapeView *pageLandscapeView = [[NTESQLHomePageLandscapeView alloc] init];
            self.pageLandscapeView = pageLandscapeView;
        }
        self.pageLandscapeView.delegate = self;
        [self.view addSubview:self.pageLandscapeView];
        [self.pageLandscapeView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
}

/// 使用易盾提供的businessID进行初始化业务，回调中返回初始化结果
- (void)registerQuickLogin {
    // 在使用一键登录之前，请先调用shouldQuickLogin方法，判断当前上网卡的网络环境和运营商是否可以一键登录
    self.shouldQL = [[NTESQuickLoginManager sharedInstance] shouldQuickLogin];
    
    if (self.shouldQL) {
        WeakSelf(self);
        [[NTESQuickLoginManager sharedInstance] registerWithBusinessID:QL_BUSINESSID timeout:3*1000 configURL:nil extData:nil completion:^(NSDictionary * _Nullable params, BOOL success) {
            if (success) {
                weakSelf.token = [params objectForKey:@"token"];
                weakSelf.precheckSuccess = YES;
            } else {
                NSLog(@"precheck失败");
                weakSelf.precheckSuccess = NO;
            }
        }];
    }
}

- (void)getPhoneNumberWithText:(NSString *)title {
    if (!self.shouldQL || !self.precheckSuccess) {
        NSLog(@"不允许一键登录");
        return;
    }
    self.loginViewController = [[NTESQLLoginViewController alloc] init];
    self.loginViewController.themeTitle = title;
    self.loginViewController.token = self.token;
    
    WeakSelf(self);
    [[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        dispatch_async(dispatch_get_main_queue(), ^{
             if (success) {
                 [weakSelf setCustomUI];
                 if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 1) {
                     [weakSelf authorizeCTLoginWithText:title];
                 } else if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 2) {
                     [weakSelf authorizeCMLoginWithText:title];
                 } else {
                     [weakSelf authorizeCULoginWithText:title];
                 }
             } else {
                 [weakSelf.navigationController pushViewController:weakSelf.loginViewController animated:YES];
                 [weakSelf.loginViewController updateView];
               
                #ifdef TEST_MODE_QA
                [weakSelf.loginViewController showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
                #endif
           }
        });
       
    }];
}

/// 电信授权认证接口
- (void)authorizeCTLoginWithText:(NSString *)title {
    WeakSelf(self);
    [[NTESQuickLoginManager sharedInstance] CTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            weakSelf.accessToken = [resultDic objectForKey:@"accessToken"];
            [weakSelf startCheckWithText:title];
        } else {
            // 取号失败
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200060"]) {
                NSLog(@"切换登录方式");
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController pushViewController:weakSelf.loginViewController animated:YES];
                [weakSelf.loginViewController updateView];
            }
            
            #ifdef TEST_MODE_QA
            [weakSelf.loginViewController showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
            #endif
        }
    }];
}

/// 移动授权认证接口
- (void)authorizeCMLoginWithText:(NSString *)title {
    WeakSelf(self);
    [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            weakSelf.accessToken = [resultDic objectForKey:@"accessToken"];
            [weakSelf startCheckWithText:title];
        } else {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200060"]) {
                NSLog(@"切换登录方式");
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
                [weakSelf.navigationController pushViewController:weakSelf.loginViewController animated:YES];
                [weakSelf.loginViewController updateView];
            }
            
            #ifdef TEST_MODE_QA
            [weakSelf.loginViewController showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
            #endif
        }
    }];
}

/// 联通授权认证接口
- (void)authorizeCULoginWithText:(NSString *)title {
    WeakSelf(self);
    [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            weakSelf.accessToken = [resultDic objectForKey:@"accessToken"];
            [weakSelf startCheckWithText:title];
        } else {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"10104"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"10105"]) {
                NSLog(@"切换登录方式");
                [weakSelf.navigationController pushViewController:weakSelf.loginViewController animated:YES];
                [weakSelf.loginViewController updateView];
            }
            
            #ifdef TEST_MODE_QA
            [weakSelf.loginViewController showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
            #endif
        }
    }];
}

/// 调用服务端接口进行校验
- (void)startCheckWithText:(NSString *)title {
    NSDictionary *dict = @{
        @"accessToken":self.accessToken?:@"",
        @"token":self.token?:@"",
    };
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dict
                                                       options:NSJSONWritingPrettyPrinted
                                                         error:&error];
    if (error) {
        return;
    }
    
    WeakSelf(self);
    [NTESDemoHttpRequest startRequestWithURL:API_LOGIN_TOKEN_QLCHECK httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSNumber *code = [dict objectForKey:@"code"];
                
                 [weakSelf dismissViewControllerAnimated:NO completion:nil];
                if ([code integerValue] == 200) {
                    NSDictionary *data = [dict objectForKey:@"data"];
                    NSString *phoneNum = [data objectForKey:@"phone"];
                    
                    if (phoneNum && phoneNum.length > 0) {
                        NTESQPLoginSuccessViewController *vc = [[NTESQPLoginSuccessViewController alloc] init];
                        vc.themeTitle = title;
                        vc.type = NTESQuickLoginType;
                        if (weakSelf.popType == 0) {
                            weakSelf.customModel.authWindowPop = NTESAuthWindowPopFullScreen;
                            vc.model = weakSelf.customModel;
                            [weakSelf.navigationController pushViewController:vc animated:YES];
                        } else {
                            weakSelf.customModel.authWindowPop = NTESAuthWindowPopCenter;
                            vc.model = weakSelf.customModel;
                            vc.successHandle = ^{
                                [weakSelf registerQuickLogin];
                            };
                            vc.modalPresentationStyle = UIModalPresentationOverFullScreen;
                            [weakSelf presentViewController:vc animated:YES completion:nil];
                        }
                    } else {
                         weakSelf.loginViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                        [weakSelf presentViewController:weakSelf.loginViewController animated:YES completion:nil];
                        if (weakSelf.popType == 0) {
                            weakSelf.customModel.authWindowPop = NTESAuthWindowPopFullScreen;
                        } else {
                            weakSelf.customModel.authWindowPop = NTESAuthWindowPopCenter;
                        }
                        weakSelf.loginViewController.model = weakSelf.customModel;
                        [weakSelf.loginViewController updateView];
                        
                        #ifdef TEST_MODE_QA
                        [weakSelf.loginViewController showToastWithMsg:@"一键登录失败"];
                        #endif
                    }
                } else if ([code integerValue] == 1003){
                    if (weakSelf.popType == 0) {
                       weakSelf.customModel.authWindowPop = NTESAuthWindowPopFullScreen;
                      [weakSelf.navigationController pushViewController:weakSelf.loginViewController animated:YES];
                    } else {
                        weakSelf.loginViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                        [weakSelf presentViewController:weakSelf.loginViewController animated:YES completion:nil];
                        weakSelf.customModel.authWindowPop = NTESAuthWindowPopCenter;
                    }
                    weakSelf.loginViewController.model = weakSelf.customModel;
                    [weakSelf.loginViewController updateView];
                } else {
                   if (weakSelf.popType == 0) {
                       weakSelf.customModel.authWindowPop = NTESAuthWindowPopFullScreen;
                      [weakSelf.navigationController pushViewController:weakSelf.loginViewController animated:YES];
                    } else {
                        weakSelf.loginViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                        [weakSelf presentViewController:weakSelf.loginViewController animated:YES completion:nil];
                        weakSelf.customModel.authWindowPop = NTESAuthWindowPopCenter;
                    }
                    weakSelf.loginViewController.model = weakSelf.customModel;
                    [weakSelf.loginViewController updateView];
                    
                    #ifdef TEST_MODE_QA
                    [weakSelf.loginViewController showToastWithMsg:[NSString stringWithFormat:@"错误，code=%@", code]];
                    #endif
                }
            } else {
                if (weakSelf.popType == 0) {
                   weakSelf.customModel.authWindowPop = NTESAuthWindowPopFullScreen;
                  [weakSelf.navigationController pushViewController:weakSelf.loginViewController animated:YES];
                } else {
                    weakSelf.loginViewController.modalPresentationStyle = UIModalPresentationOverFullScreen;
                    [weakSelf presentViewController:weakSelf.loginViewController animated:YES completion:nil];
                    weakSelf.customModel.authWindowPop = NTESAuthWindowPopCenter;
                }
                weakSelf.loginViewController.model = weakSelf.customModel;
                [weakSelf.loginViewController updateView];
                
                #ifdef TEST_MODE_QA
                [weakSelf.loginViewController showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
                #endif
            }
            
        });
    }];
}

/// 授权页面自定义
- (void)setCustomUI {
    NTESQuickLoginModel *model = [[NTESQuickLoginModel alloc] init];
    model.presentDirectionType = NTESPresentDirectionPresent;
    model.backgroundColor = [UIColor whiteColor];
//    model.authWindowPop = NTESAuthWindowPopCenter;
//    model.navText = @"免密登录";
    model.navTextColor = [UIColor blueColor];
    model.navBgColor = [UIColor whiteColor];
    model.closePopImg = [UIImage imageNamed:@"checkedBox"];
    model.faceOrientation = UIInterfaceOrientationPortrait;
    model.navBarHidden = YES;
    model.authWindowPop = NTESAuthWindowPopCenter;

   /// logo
    model.logoImg = [UIImage imageNamed:@"login_logo-1"];
    model.logoWidth = 52;
    model.logoHeight = 52;
    model.logoHidden = NO;

   /// 手机号码
    model.numberFont = [UIFont fontWithName:@"PingFangSC-Semibold" size:18];
    model.numberOffsetX = 0;
    model.numberHeight = 27;

   ///  品牌
    model.brandFont = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
    model.brandWidth = 200;
    model.brandBackgroundColor = [UIColor clearColor];
    model.brandHeight = 20;
    model.brandOffsetX = 0;

    /// 登录按钮
    model.logBtnTextFont = [UIFont systemFontOfSize:14];
//    model.logBtnEnableImg = [UIImage imageNamed:@"logo"];
    model.logBtnTextColor = [UIColor whiteColor];
    model.logBtnText = @"确定登录";
    model.logBtnRadius = 8;
    model.logBtnHeight = 44;
    model.colors = @[(id)[UIColor ntes_colorWithHexString:@"#FFFFFF"].CGColor, (id)[UIColor ntes_colorWithHexString:@"#324DFF"].CGColor];

    /// 隐私协议
    model.appPrivacyText = @"登录即同意《默认》并授权NTESQuickPassPublicDemo 获得本机号码";
    model.uncheckedImg = [[UIImage imageNamed:@"login_kuang"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkedImg = [[UIImage imageNamed:@"login_kuang_gou"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    model.checkboxWH = 11;
    model.privacyState = YES;
//    model.checkedHidden = NO;
    model.isOpenSwipeGesture = NO;
    model.privacyFont = [UIFont fontWithName:@"PingFangSC-Regular" size:11];
    model.closePopImg = [UIImage imageNamed:@"ic_close"];
    model.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    if (@available(iOS 13.0, *)) {
        model.currentStatusBarStyle = UIStatusBarStyleLightContent;
        model.otherStatusBarStyle = UIStatusBarStyleDarkContent;
    } else {
        model.currentStatusBarStyle = UIStatusBarStyleLightContent;
        model.otherStatusBarStyle = UIStatusBarStyleDefault;
    }

    model.currentVC = self;

    if (_popType == 0) {/// 全屏模式
        model.authWindowPop = NTESAuthWindowPopFullScreen;
        model.numberColor = [UIColor whiteColor];
        model.brandColor = [UIColor whiteColor];
        model.privacyColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];
        model.protocolColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];

        if (_portraitType == 0) {
           /// 全屏、竖屏模式
           model.logoOffsetTopY = 148;
           model.numberOffsetTopY = 210;
           model.brandOffsetTopY = 239;
           model.logBtnOffsetTopY = 285;
           model.appPrivacyOriginBottomMargin = 63;
           model.logBtnOriginLeft = 40;
           model.logBtnOriginRight = 40;
        } else {
            /// 全屏、横屏模式
           model.logoOffsetTopY = 30 + 44;
           model.numberOffsetTopY = 92 + 44;
           model.brandOffsetTopY = 121 + 44;
           model.logBtnOffsetTopY = 167 + 44;
           model.appPrivacyOriginBottomMargin = 31;
           model.appPrivacyOriginLeftMargin = 200;
           model.appPrivacyOriginRightMargin = 90;
           model.logBtnOriginLeft = (SCREEN_WIDTH - 295) / 2;
           model.logBtnOriginRight = (SCREEN_WIDTH - 295) / 2;
        }
    } else { /// 弹窗模式
        model.logBtnOriginLeft = 30;
        model.logBtnOriginRight = 30;
        model.numberColor = [UIColor ntes_colorWithHexString:@"#333333"];
        model.brandColor = [UIColor ntes_colorWithHexString:@"#666666"];
        model.logoOffsetTopY = 30;
        model.numberOffsetTopY = 92;
        model.brandOffsetTopY = 121;
        model.logBtnOffsetTopY = 167;
        model.appPrivacyOriginBottomMargin = 20;
        model.authWindowPop = NTESAuthWindowPopCenter;
        model.appPrivacyOriginLeftMargin = 49;
        model.appPrivacyOriginRightMargin = 30;
        model.privacyColor = [UIColor ntes_colorWithHexString:@"#999999"];
        model.protocolColor = [UIColor ntes_colorWithHexString:@"#999999"];
        model.logBtnOffsetTopY = 167;

        model.scaleW = (295) / SCREEN_WIDTH;
        model.scaleH = (315) / SCREEN_HEIGHT;
        model.popBackgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];

        model.uncheckedImg = [[UIImage imageNamed:@"checkBox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
        model.checkedImg = [[UIImage imageNamed:@"checkedBox"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    };

    CGFloat navHeight;
    if (_portraitType == 0) {
        model.localVideoFileName = @"video_portrait.mp4";
        model.faceOrientation = UIInterfaceOrientationPortrait;
        navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44;
    } else {
        navHeight = 44;
        if (_popType == 1) {
            self.customModel.logBtnOffsetTopY = 195;
        }
        model.faceOrientation = self.faceOrientation;
        model.loginDidDisapperfaceOrientation = self.faceOrientation;
        model.localVideoFileName = @"video_landscape.mp4";
    }
    model.isRepeatPlay = YES;
//    self.customModel.videoURL = @"http://la-gia.shiraha.me/mp4/H264-1044x588-2MB-35s.mp4";

    WeakSelf(self);
    model.customViewBlock = ^(UIView * _Nullable customView) {
        UILabel *otherLabel = [[UILabel alloc] init];
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(labelTapped)];
        [otherLabel addGestureRecognizer:tap];
        otherLabel.userInteractionEnabled = YES;
        otherLabel.text = @"其他登录方式";
        otherLabel.textAlignment = NSTextAlignmentCenter;
        otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#324DFF"];
        otherLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:12];
        [customView addSubview:otherLabel];

        if (weakSelf.popType == 0) { /// 全屏模式
            NTESQLNavigationView *navigationView = [[NTESQLNavigationView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, navHeight)];
            navigationView.backgroundColor = [UIColor clearColor];
            [customView addSubview:navigationView];

            otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#FFFFFF"];

            if (weakSelf.portraitType == 0) { /// 全屏、竖屏模式
                [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(customView);
                    make.top.equalTo(customView).mas_offset(339);
                    make.height.mas_equalTo(16);
                }];
            } else { /// 全屏、横屏模式
                [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerX.equalTo(customView);
                    make.top.equalTo(customView).mas_offset(227 + 44);
                    make.height.mas_equalTo(16);
                }];
            }
        } else {
            /// 弹窗模式
            otherLabel.textColor = [UIColor ntes_colorWithHexString:@"#324DFF"];
            [otherLabel mas_makeConstraints:^(MASConstraintMaker *make) {
                make.centerX.equalTo(customView);
                make.top.equalTo(customView).mas_offset(227);
                make.height.mas_equalTo(16);
            }];
        }
    };

    model.backActionBlock = ^{
        NSLog(@"返回按钮点击");
    };

    model.loginActionBlock = ^{
        NSLog(@"登录按钮点击");
    };

    model.checkActionBlock = ^(BOOL isChecked) {
        if (isChecked) {
            NSLog(@"选中复选框");
        } else {
            NSLog(@"取消复选框");
        }
    };

    model.privacyActionBlock = ^(int privacyType) {
        if (privacyType == 0) {
            NSLog(@"点击默认协议");
        } else if (privacyType == 1) {
            NSLog(@"点击客户第1个协议");
        } else if (privacyType == 2) {
            NSLog(@"点击客户第2个协议");
        }
    };

    model.currentVC = self;
//    model.privacyNavReturnImg = [UIImage imageNamed:@"ic_namb"];
//    self.customModel = model;
    [[NTESQuickLoginManager sharedInstance] setupModel:model];
}

- (void)labelTapped {
    [[NTESQuickLoginManager sharedInstance] closeAuthController:^{
    
    }];;
    NSLog(@"======");
}

- (void)btnDidTipped:(UIButton *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController pushViewController:[[UIViewController alloc] init] animated:YES];
}

- (void)clickCustomBtn {
    [self.loginViewController showToastWithMsg:@"点击了"];
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"点击了右键，自行关闭授权页面可以使用dismissViewControllerAnimated方法");
}

#pragma - 竖屏全屏按钮点击的代理

/// 竖屏全屏登录按钮点击
- (void)loginButtonWithFullScreenDidTipped:(UIButton *)sender {
    [self getPhoneNumberWithText:registerTitle];  /// 0-全屏
    self.popType = 0;
    self.portraitType = 0;
//    self.customModel.faceOrientation = UIInterfaceOrientationPortrait;
}

/// 竖屏弹窗登录按钮点击
- (void)loginButtonWithPopScreenDidTipped:(UIButton *)sender {
     self.popType = 1;
     self.portraitType = 0;
    [self getPhoneNumberWithText:registerTitle]; /// 1-半屏
}

/// 竖屏本机按钮点击
- (void)loginButtonWithLocalPhoneDidTipped:(UIButton *)sender {
     self.portraitType = 0;
    NTESQPLoginViewController *vc = [[NTESQPLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];;
}

#pragma 横屏全屏按钮点击的代理

/// 横屏全屏按钮的点击
- (void)loginButtonWithLandscapeFullScreenDidTipped:(UIButton *_Nullable)sender {
    self.popType = 0;
    self.portraitType = 1;
    [self getPhoneNumberWithText:registerTitle];
}

/// 横屏弹窗按钮的点击
- (void)loginButtonWithLandscapePopScreenDidTipped:(UIButton *_Nullable)sender {
    self.popType = 1;
    self.portraitType = 1;
    [self getPhoneNumberWithText:registerTitle];
}

/// 横屏本机校验按钮的点击
- (void)loginButtonWithLandscapeLocalPhoneDidTipped:(UIButton *_Nonnull)sender {
     self.portraitType = 1;
     NTESQPLoginViewController *vc = [[NTESQPLoginViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end


