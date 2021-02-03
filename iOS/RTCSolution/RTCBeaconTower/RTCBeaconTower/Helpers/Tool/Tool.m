//
//  Tool.m
//  AliRTCApp
//
//  Created by 黄浩 on 2020/1/2.
//  Copyright © 2020 AliRTCApp. All rights reserved.
//

#import "Tool.h"
#import "Reachability.h"


@implementation Tool


+ (UIViewController *)currentViewController {
    //获得当前活动窗口的根视图
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    UIViewController *currentShowingVC = [self findCurrentShowingViewControllerFrom:vc];
    return currentShowingVC;
}

+ (UIViewController *)findCurrentShowingViewControllerFrom:(UIViewController *)vc {
    //方法1：递归方法 Recursive method
    UIViewController *currentShowingVC;
    if ([vc presentedViewController]) { //注要优先判断vc是否有弹出其他视图，如有则当前显示的视图肯定是在那上面
        // 当前视图是被presented出来的
        UIViewController *nextRootVC = [vc presentedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        UIViewController *nextRootVC = [(UITabBarController *)vc selectedViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else if ([vc isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        UIViewController *nextRootVC = [(UINavigationController *)vc visibleViewController];
        currentShowingVC = [self findCurrentShowingViewControllerFrom:nextRootVC];
        
    } else {
        // 根视图为非导航类
        currentShowingVC = vc;
    }
    
    return currentShowingVC;
    
    /*
    //方法2：遍历方法
    while (1)
    {
        if (vc.presentedViewController) {
            vc = vc.presentedViewController;
            
        } else if ([vc isKindOfClass:[UITabBarController class]]) {
            vc = ((UITabBarController*)vc).selectedViewController;
            
        } else if ([vc isKindOfClass:[UINavigationController class]]) {
            vc = ((UINavigationController*)vc).visibleViewController;
            
        //} else if (vc.childViewControllers.count > 0) {
        //    //如果是普通控制器，找childViewControllers最后一个
        //    vc = [vc.childViewControllers lastObject];
        } else {
            break;
        }
    }
    return vc;
    //*/
}


+ (BOOL)isPhoneX {
   BOOL iPhoneX = NO;
     if (UIDevice.currentDevice.userInterfaceIdiom != UIUserInterfaceIdiomPhone) {//判断是否是手机
           return iPhoneX;
       }
       if (@available(iOS 11.0, *)) {
           UIWindow *mainWindow = [UIApplication sharedApplication].keyWindow;
           if (mainWindow.safeAreaInsets.bottom > 0.0) {
               iPhoneX = YES;
           }
       }
       return iPhoneX;
}

+ (BOOL)haveNetwork {
    Reachability *reachability   = [Reachability reachabilityWithHostName:@"www.apple.com"];
    NetworkStatus internetStatus = [reachability currentReachabilityStatus];
    NSString *net = @"WIFI";
    BOOL network = YES;
    switch (internetStatus) {
        case ReachableViaWiFi:
            net = @"WIFI";
            network = YES;
            break;
        case ReachableViaWWAN:
            net = @"蜂窝数据";
            network = YES;
            //net = [self getNetType ];   //判断具体类型
            break;
        case NotReachable:
            net = @"当前无网路连接";
            network = NO;
        default:
            break;
    }
    return network;
}
    
@end
