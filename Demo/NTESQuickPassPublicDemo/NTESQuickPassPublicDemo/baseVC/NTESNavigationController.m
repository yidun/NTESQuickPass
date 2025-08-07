//
//  NTESNavigationController.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/14.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESNavigationController.h"

@interface NTESNavigationController ()

@end

@implementation NTESNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    //设置右滑返回手势的代理为自身
    __weak typeof(self) weakself = self;
    if ([self respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.interactivePopGestureRecognizer.delegate = (id)weakself;
    }
}

- (BOOL)gestureRecognizerShouldBegin:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer == self.interactivePopGestureRecognizer) {
        //屏蔽调用rootViewController的滑动返回手势，避免右滑返回手势引起crash
        if (self.viewControllers.count < 2 ||
 self.visibleViewController == [self.viewControllers objectAtIndex:0]) {
            return NO;
        }
    }
    //这里就是非右滑手势调用的方法啦，统一允许激活
    return YES;
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    if (self.viewControllers.count != 0) {
        UIViewController *viewController = [self.viewControllers lastObject];
        return [viewController preferredStatusBarStyle];
    }
    return UIStatusBarStyleLightContent;
    
}

- (BOOL)shouldAutorotate {
    return [self.topViewController shouldAutorotate];
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations {
    return [self.topViewController supportedInterfaceOrientations];
}

- (BOOL)prefersStatusBarHidden {
    return [self.topViewController prefersStatusBarHidden];
}

@end
