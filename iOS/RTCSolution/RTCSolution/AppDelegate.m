//
//  AppDelegate.m
//  RTCSolution
//
//  Created by Aliyun on 2020/6/28.
//  Copyright © 2020 Aliyun. All rights reserved.
//

#import "AppDelegate.h"
#import "RTCHomeViewController.h"
#import "RTCNavigationController.h"
#import <AliRTCSdk/AliRTCSdk.h>

@interface AppDelegate () <UIAlertViewDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    // Override point for customization after application launch.
    self.window =[[UIWindow alloc]initWithFrame:[UIScreen mainScreen].bounds];
    RTCNavigationController *nav =[[RTCNavigationController alloc]initWithRootViewController:[RTCHomeViewController new]];
    [self.window setRootViewController:nav];
    [self.window makeKeyAndVisible];
    NSString *version = [AliRtcEngine getSdkVersion];

    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    NSLog(@"\n ===> 程序暂停 !");
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    
}
 
- (void)applicationDidEnterBackground:(UIApplication *)application {
    NSLog(@"\n ===> 进入后台 ！");
}




@end
