//
//  NTESQLFindCurrentVCEntity.m
//  NTESQuickPassPublicDemo
//
//  Created by 罗礼豪 on 2020/4/13.
//  Copyright © 2020 Xu Ke. All rights reserved.
//

#import "NTESQLFindCurrentVCEntity.h"

@implementation NTESQLFindCurrentVCEntity


+ (UIViewController *)findVisibleViewController {
    
    UIViewController *currentViewController = [self getRootViewController];

    BOOL runLoopFind = YES;
    while (runLoopFind) {
        if (currentViewController.presentedViewController) {
            currentViewController = currentViewController.presentedViewController;
        } else {
            if ([currentViewController isKindOfClass:[UINavigationController class]]) {
                currentViewController = ((UINavigationController *)currentViewController).visibleViewController;
            } else if ([currentViewController isKindOfClass:[UITabBarController class]]) {
                currentViewController = ((UITabBarController* )currentViewController).selectedViewController;
            } else {
                break;
            }
        }
    }
    
    return currentViewController;
}

+ (UIViewController *)getRootViewController{
    UIWindow* window = [[[UIApplication sharedApplication] delegate] window];
    return window.rootViewController;
}

@end
