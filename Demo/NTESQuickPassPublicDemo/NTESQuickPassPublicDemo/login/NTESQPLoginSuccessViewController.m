//
//  NTESQPLoginSuccessViewController.m
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import "NTESQPLoginSuccessViewController.h"
#import <Masonry.h>
#import "NTESQPDemoDefines.h"
#import "NTESQLHomePageViewController.h"
#import "UIColor+NTESQuickPass.h"

@interface NTESQPLoginSuccessViewController ()

@property (nonatomic, strong) UIImageView *successImageView;

@property (nonatomic, strong) UILabel *themeLabel;

@property (nonatomic, strong) UIButton *backToRootButton;

@property (nonatomic, strong) UIView *customBottomView;
@property (nonatomic, strong) UIButton *closeButton;

@property (nonatomic, strong) UIView *lineView;

@end

@implementation NTESQPLoginSuccessViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self customInitSubViews];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    
    UILabel *titleView = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 44)];
    if (_type == NTESQuickPassType) {
        titleView.text = @"易盾本机校验";
    } else {
        titleView.text = @"易盾一键登录";
    }
    
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
    
     [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(didChangeScreenRotate:) name:UIApplicationDidChangeStatusBarFrameNotification object:nil];
    
    [self didChangeScreenRotate:nil];
}

- (void)didChangeScreenRotate:(NSNotification *)notification {
    if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft) {
        _model.faceOrientation = UIInterfaceOrientationLandscapeLeft;
    } else if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
        _model.faceOrientation = UIInterfaceOrientationLandscapeRight;
    } else if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait) {
       _model.faceOrientation = UIInterfaceOrientationPortrait;
    }
    
    [self customInitSubViews];
    
    if (_model.authWindowPop != NTESAuthWindowPopCenter) {
        CGFloat navHeight;
        if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortrait
              || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationPortraitUpsideDown) {
            navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44;
        } else {
            navHeight = 44;
        }
        
        if ([NTESQuickLoginManager sharedInstance].getCarrier != 3) {
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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    if (_model.authWindowPop == NTESAuthWindowPopCenter) {
        [self.navigationController setNavigationBarHidden:YES animated:NO];
    } else {
        [self.navigationController setNavigationBarHidden:NO animated:NO];
        self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    }
}

- (void)leftBarButtonItemDidTipped {
    NTESAuthWindowPop authWindowPop = self.model.authWindowPop;
    if (authWindowPop == NTESAuthWindowPopCenter) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
       [self.navigationController popViewControllerAnimated:YES];
    }
    
}

- (void)customInitSubViews {
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
        [closeButton setImage:[UIImage imageNamed:@"ic_close"] forState:UIControlStateNormal];
        self.closeButton = closeButton;
        [_customBottomView addSubview:closeButton];
        [closeButton mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.size.mas_equalTo(CGSizeMake(20, 20));
            make.right.equalTo(self.customBottomView).mas_offset(-10);
            make.top.equalTo(self.customBottomView).mas_offset(10);
        }];
        self.view.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [_customBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.centerX.equalTo(self.view).mas_offset(authWindowCenterOriginX);
            make.centerY.equalTo(self.view).mas_offset(authWindowCenterOriginY);
            make.size.mas_offset(CGSizeMake(295, 315));
        }];
        self.lineView.hidden = YES;
    } else {
        self.view.backgroundColor = [UIColor whiteColor];
        [_customBottomView mas_remakeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.view);
        }];
    }
    
    [self __initSuccessImageView];
    [self __initThemeLabel];
    [self __initBackToRootButton];
}

- (void)closeButtonDidTipped {
    if (self.successHandle) {
        self.successHandle();
    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)__initSuccessImageView {
    if (!_successImageView) {
        _successImageView = [[UIImageView alloc] init];
        [_successImageView setImage:[UIImage imageNamed:@"pic_success"]];
        [self.customBottomView addSubview:_successImageView];
    }
    CGFloat navHeight;
    NTESAuthWindowPop authWindowPop = self.model.authWindowPop;
     if ([[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeLeft || [[UIDevice currentDevice] orientation] == UIInterfaceOrientationLandscapeRight) {
        navHeight = 44 + 30;
    } else {
        navHeight = (IS_IPHONEX_SET ? 44.f : 20.f) + 44 + 44;
    }
    [_successImageView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.customBottomView);
        if (authWindowPop == NTESAuthWindowPopCenter) {
            make.top.equalTo(self.customBottomView).offset(30);
        } else {
            make.top.equalTo(self.customBottomView).offset(navHeight);
        }
        make.height.equalTo(@(133));
        make.width.equalTo(@(128));
    }];
}

- (void)__initThemeLabel {
    if (!_themeLabel) {
        _themeLabel = [[UILabel alloc] init];
        _themeLabel.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:16];
        _themeLabel.text = @"注册/登录成功！";
        _themeLabel.textColor = [UIColor ntes_colorWithHexString:@"#333333"];
        [self.customBottomView addSubview:_themeLabel];
        [_themeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.successImageView.mas_bottom).offset(4*KHeightScale);
            make.centerX.equalTo(self.customBottomView);
        }];
    }
}

- (void)__initBackToRootButton {
    if (!_backToRootButton) {
        _backToRootButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backToRootButton setTitle:backToRoot forState:UIControlStateNormal];
        [_backToRootButton setTitle:backToRoot forState:UIControlStateHighlighted];
        _backToRootButton.titleLabel.textColor = [UIColor whiteColor];
        _backToRootButton.titleLabel.font = [UIFont systemFontOfSize:16.0f];
        _backToRootButton.layer.cornerRadius = 8;
        _backToRootButton.layer.masksToBounds = YES;
        [_backToRootButton addTarget:self action:@selector(doBackToRoot) forControlEvents:UIControlEventTouchUpInside];
        [self.customBottomView addSubview:_backToRootButton];
        NTESAuthWindowPop authWindowPop = self.model.authWindowPop;
        [_backToRootButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.equalTo(self.themeLabel.mas_bottom).offset(30);
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
        [_backToRootButton.layer insertSublayer:gradientLayer atIndex:0];
    }
}

- (void)doBackToRoot {
    if (self.successHandle) {
        self.successHandle();
    }
    if (_model.authWindowPop == NTESAuthWindowPopCenter) {
        [self dismissViewControllerAnimated:YES completion:nil];
    } else {
        for (UIViewController *vc in self.navigationController.childViewControllers) {
            if ([vc isKindOfClass:[NTESQLHomePageViewController class]]) {
                NTESQLHomePageViewController *mainVC = (NTESQLHomePageViewController *)vc;
                [self.navigationController popToViewController:mainVC animated:YES];
            }
        }
    }
}

@end
