//
//  RTCNavigationController.m
//  RTCSolution
//
//  Created by Aliyun on 2020/6/29.
//  Copyright © 2020 Aliyun. All rights reserved.
//

#import "RTCNavigationController.h"

@interface RTCNavigationController ()

@end

@implementation RTCNavigationController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

-(BOOL)shouldAutorotate
{
    return [[self.viewControllers lastObject] shouldAutorotate];
      
}
  
#if __IPHONE_OS_VERSION_MAX_ALLOWED < __IPHONE_9_0
- (NSUInteger)supportedInterfaceOrientations
#else
- (UIInterfaceOrientationMask)supportedInterfaceOrientations
#endif
{
     return [[self.viewControllers lastObject] supportedInterfaceOrientations];
}
  
- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation {
      
    return [[self.viewControllers lastObject] preferredInterfaceOrientationForPresentation];
}

- (UIViewController *)childViewControllerForStatusBarStyle{
    return self.topViewController;
}

@end
