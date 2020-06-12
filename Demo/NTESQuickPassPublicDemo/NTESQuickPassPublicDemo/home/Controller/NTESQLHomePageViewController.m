
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

@interface  NTESQLHomePageViewController() <UINavigationBarDelegate, NTESQLHomePagePortraitViewDelegate, NTESQLHomePageLandscapeViewDelegate,NTESQuickLoginManagerDelegate>

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) NTESQLLoginViewController *loginViewController;

@property (nonatomic, strong) NTESQuickLoginModel *customModel;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, assign) NSInteger popType;       /// 弹窗模式的样式
@property (nonatomic, assign) NSInteger portraitType;  /// 屏幕旋转的类型  0 竖屏  1 横屏

@property (nonatomic, strong) NTESQLHomePagePortraitView *pageView;
@property (nonatomic, strong) NTESQLHomePageLandscapeView *pageLandscapeView;

@property (nonatomic, assign) UIInterfaceOrientation faceOrientation;

@property (nonatomic, copy) NSDictionary *resultDic;

@property (nonatomic, assign) BOOL shouldQL;
@property (nonatomic, assign) BOOL precheckSuccess;

@end

@implementation NTESQLHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
    
    [self registerQuickLogin];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeScreenRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
}

- (void)didChangeScreenRotate:(NSNotification *)notification {
    [self deviceOrientation];
}

/// 设置UI
- (void)setupViews {
    [self deviceOrientation];
}

/// 根据屏幕旋转的方向切换视图界面
- (void)deviceOrientation {
    if (IS_DEVICE_PORTRAIT) {
        /**横屏的界面视图*/
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
        if (IS_DEVICE_LEFT) {
            self.faceOrientation = UIInterfaceOrientationLandscapeLeft;
        } else {
            self.faceOrientation = UIInterfaceOrientationLandscapeRight;
        }
        /**竖屏的界面视图*/
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
    [NTESQuickLoginManager sharedInstance].delegate = self;
    if (self.shouldQL) {
        WeakSelf(self);
        [[NTESQuickLoginManager sharedInstance] registerWithBusinessID:@"" timeout:3*1000 configURL:nil extData:nil completion:^(NSDictionary * _Nullable params, BOOL success) {
            if (success) {
                weakSelf.token = [params objectForKey:@"token"];
                weakSelf.precheckSuccess = YES;
                [weakSelf getPhoneNumber];
            } else {
                NSLog(@"precheck失败");
                weakSelf.precheckSuccess = NO;
            }
        }];
    }
}

- (void)getPhoneNumber {
    WeakSelf(self);
    [[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
        weakSelf.resultDic = resultDic;
    }];
}

- (void)getPhoneNumberWithText:(NSString *)title {
    if (!self.shouldQL || !self.precheckSuccess) {
        NSLog(@"不允许一键登录");
        return;
    }
    self.loginViewController = [[NTESQLLoginViewController alloc] init];
    self.loginViewController.themeTitle = title;
    self.loginViewController.token = self.token;

    NSNumber *boolNum = [self.resultDic objectForKey:@"success"];
    BOOL success = [boolNum boolValue];
    WeakSelf(self);
    if (success) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf setCustomUI];
            [weakSelf authorizeCTCMCULoginWithText:title];
        });
    } else {
        [[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
            NSNumber *boolNum = [resultDic objectForKey:@"success"];
            weakSelf.resultDic = resultDic;
            BOOL success = [boolNum boolValue];
            dispatch_async(dispatch_get_main_queue(), ^{
                if (success) {
                    [weakSelf setCustomUI];
                    [weakSelf authorizeCTCMCULoginWithText:title];
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
}

/// 授权认证接口
- (void)authorizeCTCMCULoginWithText:(NSString *)title {
    WeakSelf(self);
    [[NTESQuickLoginManager sharedInstance] CUCMCTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
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

/// 调用服务端接口进行校验
- (void)startCheckWithText:(NSString *)title {
    NSDictionary *dict = @{
        @"accessToken":self.accessToken ? : @"",
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
    [NTESDemoHttpRequest startRequestWithURL:@"" httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf dismissViewControllerAnimated:NO completion:nil];
            if (data) {
                NSDictionary *dict = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
                NSNumber *code = [dict objectForKey:@"code"];
                
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
    self.customModel = [[NTESQLHomePageCustomUIModel getInstance] configCustomUIModel:self.popType withType:self.portraitType faceOrientation:self.faceOrientation];
    self.customModel.currentVC = self;
    [[NTESQuickLoginManager sharedInstance] setupModel:self.customModel];
}

#pragma - NTESQuickLoginManagerDelegate

- (void)authViewDealloc {
    NSLog(@"授权页面销毁了");
}

- (void)authViewDidLoad {
    NSLog(@"授权页面初始化");
}

- (void)authViewWillAppear {
    NSLog(@"授权页面将要出现");
}

- (void)authViewDidAppear {
    NSLog(@"授权页面已经出现");
}

- (void)authViewWillDisappear {
    NSLog(@"授权页面将要消失");
}

- (void)authViewDidDisappear {
    NSLog(@"授权页面已经消失");
}

#pragma - 竖屏全屏按钮点击的代理

/// 竖屏全屏登录按钮点击
- (void)loginButtonWithFullScreenDidTipped:(UIButton *)sender {
    self.popType = 0;
    self.portraitType = 0;
    [self getPhoneNumberWithText:registerTitle];  /// 0-全屏
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

