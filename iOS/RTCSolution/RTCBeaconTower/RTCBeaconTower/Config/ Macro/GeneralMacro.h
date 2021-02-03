//
//  GeneralMacro.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/12.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#ifndef GeneralMacro_h
#define GeneralMacro_h


#define kApplication        [UIApplication sharedApplication]

#define kKeyWindow          [UIApplication sharedApplication].keyWindow

#define kAppDelegate        [UIApplication sharedApplication].delegate

#define kUserDefaults      [NSUserDefaults standardUserDefaults]

#define kNotificationCenter [NSNotificationCenter defaultCenter]

#define kWeakSelf(type)  __weak typeof(type) weak##type = type;
#define kStrongSelf(type) __strong typeof(type) type = weak##type;


#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

#define kfont(F) [UIFont systemFontOfSize:F]

#define kImage(N) [UIImage imageNamed:N]


#define kGlobalQueue(block) dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), block)

#define kMainQueue(block) dispatch_async(dispatch_get_main_queue(),block)


#define RGB(r, g, b)        [UIColor colorWithRed: (r) / 255.0 green: (g) / 255.0 blue: (b) / 255.0 alpha: 1.0]
#define RGBA(R, G, B,A)    [UIColor colorWithRed:R/255.0 green:G/255.0 blue:B/255.0 alpha:A]
#define MainSelectColor  RGB(62, 154, 83)

// 设置 view 圆角和边框
#define kViewBorderRadius(View, Radius, Width, Color) \
                                                      \
    [View.layer setCornerRadius: (Radius)];           \
    [View.layer setMasksToBounds:YES];                \
    [View.layer setBorderWidth:(Width)];              \
    [View.layer setBorderColor:[Color CGColor]]

#define RGBHex(rgbValue) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define RGBHexAlpha(rgbValue,a) [UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 green:((float)((rgbValue & 0xFF00) >> 8))/255.0 blue:((float)(rgbValue & 0xFF))/255.0 alpha:(a)]

#endif /* GeneralMacro_h */
