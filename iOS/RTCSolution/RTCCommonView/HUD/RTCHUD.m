//
//  RTCHUD.m
//  RTCInteractiveLiveClass
//
//  Created by Aliyun on 2020/6/30.
//

#import "RTCHUD.h"
#import "MBProgressHUD.h"

@implementation RTCHUD

+ (void)showHud:(NSString*)msg inView:(UIView*)view {
    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeText;
    hud.label.text = msg;
    hud.label.textColor = [UIColor whiteColor];
    hud.bezelView.style =  MBProgressHUDBackgroundStyleSolidColor;
    hud.bezelView.backgroundColor = [UIColor colorWithRed:24/255.0 green:24/255.0 blue:24/255.0 alpha:1];
    [hud hideAnimated:YES afterDelay:1.f];
}

+(void)showHUDInView:(UIView *)view{
   [MBProgressHUD showHUDAddedTo:view animated:YES];
}

+(void)hideHUDInView:(UIView *)view{
    [MBProgressHUD hideHUDForView:view animated:YES];
}

@end
