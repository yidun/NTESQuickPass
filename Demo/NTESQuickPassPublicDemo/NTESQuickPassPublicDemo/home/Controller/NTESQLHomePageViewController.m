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
#import "NTESQPHomePageViewController.h"
#import "NTESQPLoginSuccessViewController.h"
#import <NTESQuickPass/NTESQuickPass.h>
#import "NTESQLHomePageView.h"
#import "NTESDemoHttpRequest.h"
#import "NTESQLHomePageCustomUIModel.h"

@interface  NTESQLHomePageViewController() <UINavigationBarDelegate, NTESQLHomePageViewDelegate>

@property (nonatomic, copy) NSString *token;
@property (nonatomic, copy) NSString *accessToken;

@property (nonatomic, strong) NTESQLLoginViewController *loginViewController;

@property (nonatomic, assign) BOOL shouldQL;
@property (nonatomic, assign) BOOL precheckSuccess;

@end

@implementation NTESQLHomePageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self setupViews];
    [self registerQuickLogin];
}

- (void)viewWillAppear:(BOOL)animated {
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

/// 设置UI
- (void)setupViews {
    NTESQLHomePageView *pageView = [[NTESQLHomePageView alloc] init];
    pageView.delegate = self;
    [self.view addSubview:pageView];
    [pageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

/// 使用易盾提供的businessID进行初始化业务，回调中返回初始化结果 ⚠️BusinessID ,请填写易盾分配的业务方ID
- (void)registerQuickLogin {
    // 在使用一键登录之前，请先调用shouldQuickLogin方法，判断当前上网卡的网络环境和运营商是否可以一键登录
    self.shouldQL = [[NTESQuickLoginManager sharedInstance] shouldQuickLogin];
    
    if (self.shouldQL) {
        [[NTESQuickLoginManager sharedInstance] registerWithBusinessID:@"易盾分配的业务方ID" timeout:3*1000 configURL:nil extData:nil completion:^(NSDictionary * _Nullable params, BOOL success) {
            if (success) {
                self.token = [params objectForKey:@"token"];
                self.precheckSuccess = YES;
            } else {
                NSLog(@"precheck失败");
                self.precheckSuccess = NO;
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
    
    [[NTESQuickLoginManager sharedInstance] getPhoneNumberCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            [self setCustomUI];
            if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 1) {
                [self authorizeCTLoginWithText:title];
            } else if ([[NTESQuickLoginManager sharedInstance] getCarrier] == 2) {
                [self authorizeCMLoginWithText:title];
            } else {
                [self authorizeCULoginWithText:title];
            }
        } else {
            [self.navigationController pushViewController:self.loginViewController animated:YES];
            [self.loginViewController updateView];
            
            #ifdef TEST_MODE_QA
            [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
            #endif
        }
    }];
}

/// 电信授权认证接口
- (void)authorizeCTLoginWithText:(NSString *)title {
    [[NTESQuickLoginManager sharedInstance] CTAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            [self startCheckWithText:title];
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
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController pushViewController:self.loginViewController animated:YES];
                [self.loginViewController updateView];
            }
            
            #ifdef TEST_MODE_QA
            [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
            #endif
        }
    }];
}

/// 移动授权认证接口
- (void)authorizeCMLoginWithText:(NSString *)title {
    [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            [self startCheckWithText:title];
        } else {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"200020"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"200060"]) {
                NSLog(@"切换登录方式");
                [self dismissViewControllerAnimated:YES completion:nil];
                [self.navigationController pushViewController:self.loginViewController animated:YES];
                [self.loginViewController updateView];
            }
            
            #ifdef TEST_MODE_QA
            [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
            #endif
        }
    }];
}

/// 联通授权认证接口
- (void)authorizeCULoginWithText:(NSString *)title {
    [[NTESQuickLoginManager sharedInstance] CUCMAuthorizeLoginCompletion:^(NSDictionary * _Nonnull resultDic) {
        NSNumber *boolNum = [resultDic objectForKey:@"success"];
        BOOL success = [boolNum boolValue];
        if (success) {
            self.accessToken = [resultDic objectForKey:@"accessToken"];
            [self startCheckWithText:title];
        } else {
            NSString *resultCode = [resultDic objectForKey:@"resultCode"];
            if ([resultCode isEqualToString:@"10104"]) {
                NSLog(@"取消登录");
            }
            if ([resultCode isEqualToString:@"10105"]) {
                NSLog(@"切换登录方式");
                [self.navigationController pushViewController:self.loginViewController animated:YES];
                [self.loginViewController updateView];
            }
            
            #ifdef TEST_MODE_QA
            [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"code:%@\ndesc:%@",  [resultDic objectForKey:@"resultCode"], [resultDic objectForKey:@"desc"]]];
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
    
    [NTESDemoHttpRequest startRequestWithURL:API_LOGIN_TOKEN_QLCHECK httpMethod:@"POST" requestData:jsonData finishBlock:^(NSData *data, NSError *error, NSInteger statusCode) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:YES completion:nil];
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
                        [self.navigationController pushViewController:vc animated:YES];
                    } else {
                        [self.navigationController pushViewController:self.loginViewController animated:YES];
                        [self.loginViewController updateView];
                        
                        #ifdef TEST_MODE_QA
                        [self.loginViewController showToastWithMsg:@"一键登录失败"];
                        #endif
                    }
                } else if ([code integerValue] == 1003){
                    [self.navigationController pushViewController:self.loginViewController animated:YES];
                    [self.loginViewController updateView];
                } else {
                    [self.navigationController pushViewController:self.loginViewController animated:YES];
                    [self.loginViewController updateView];
                    
                    #ifdef TEST_MODE_QA
                    [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"错误，code=%@", code]];
                    #endif
                }
            } else {
                [self.navigationController pushViewController:self.loginViewController animated:YES];
                [self.loginViewController updateView];
                
                #ifdef TEST_MODE_QA
                [self.loginViewController showToastWithMsg:[NSString stringWithFormat:@"服务器错误-%ld", (long)statusCode]];
                #endif
            }
        });
    }];
}

/// 授权页面自定义
- (void)setCustomUI {
    NTESQuickLoginCustomModel *model = [NTESQLHomePageCustomUIModel configCustomUIModel];
    model.currentVC = self;
    
//    model.customViewBlock = ^(UIView * _Nullable customView) {
//        UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 300, self.view.bounds.size.width, 100)];
//        bottom.backgroundColor = [UIColor redColor];
//        [customView addSubview:bottom];
//    };
//    model.customNavBlock = ^(UIView * _Nullable customNavView) {
//        UIView *bottom = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 30)];
//        bottom.backgroundColor = [UIColor redColor];
//        [customNavView addSubview:bottom];
//    };
    [[NTESQuickLoginManager sharedInstance] setupModel:model];
    
}

- (void)clickRightBtn {
    if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        [self.navigationController popViewControllerAnimated:YES];
    }
    NSLog(@"点击了右键，自行关闭授权页面可以使用dismissViewControllerAnimated方法");
}

#pragma - NTESQLHomePageViewDelegate

/// 点击注册按钮
- (void)registerButtonDidTipped:(UIButton *)sender {
    [self getPhoneNumberWithText:registerTitle];
}

/// 点击登录按钮
- (void)loginButtonDidTipped:(UIButton *)sender {
    [self getPhoneNumberWithText:loginTitle];
}

/// 点击切换账号按钮
- (void)exchangeButtonDidTipped:(UIButton *)sender {
    NTESQPHomePageViewController *vc = [[NTESQPHomePageViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}

@end

