//
//  NTESQLServiceViewController.m
//  NTESQuickPassPublicDemo
//
//  Created by Ke Xu on 2019/2/12.
//  Copyright © 2019 Xu Ke. All rights reserved.
//

#import "NTESQLServiceViewController.h"
#import <WebKit/WebKit.h>
#import "NTESQPDemoDefines.h"

@implementation NTESQLServiceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self shouldHideBottomView:YES];
    [self shouldHideLogoView:YES];
    
    CGFloat height = 91.5*KHeightScale;
    WKWebView *webView = [[WKWebView alloc] initWithFrame:CGRectMake(0, height, self.view.frame.size.width, self.view.frame.size.height - height)];
    [self.view addSubview:webView];
    NSURL *url = [NSURL URLWithString:self.serviceHTML];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

@end
