//
//  AppDelegate.m
//  NTESQuickPassPublicDemo
//
//  Created by Xu Ke on 2018/6/14.
//  Copyright © 2018年 Xu Ke. All rights reserved.
//

#import "AppDelegate.h"
#import "NTESQLHomePageViewController.h"
#import "NTESNavigationController.h"
#import "NTESQLGuidePageController.h"
#import "NTESQPDemoDefines.h"


@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
//    [NSThread sleepForTimeInterval:1.0];
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
       self.window.backgroundColor = [UIColor whiteColor];
       
       NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
       if (![userDefaults boolForKey:IS_NO_FIRST_OPEN]) {
           [userDefaults setBool:YES forKey:IS_NO_FIRST_OPEN];
           NTESQLGuidePageController *vc = [[NTESQLGuidePageController alloc] init];
           self.window.rootViewController = vc;
           [self.window makeKeyWindow];
       } else {
           NTESQLHomePageViewController *vc = [[NTESQLHomePageViewController alloc] init];
           NTESNavigationController *nav = [[NTESNavigationController alloc] initWithRootViewController:vc];
           self.window.rootViewController = nav;
           [self.window makeKeyWindow];
       }
    
    return YES;
}


- (void)applicationWillResignActive:(UIApplication *)application {
    
}


- (void)applicationDidEnterBackground:(UIApplication *)application {

}


- (void)applicationWillEnterForeground:(UIApplication *)application {

}


- (void)applicationDidBecomeActive:(UIApplication *)application {

}


- (void)applicationWillTerminate:(UIApplication *)application {

}


@end
