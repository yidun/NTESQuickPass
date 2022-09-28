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
