//
//  AliToast.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/25.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, AliToastType) {
    AliToastTypeNormal, //正常
    AliToastTypeError,  //错误
    AliToastTypeWarn    //警告
};
NS_ASSUME_NONNULL_BEGIN

@interface Toast : UIView

/** 纯文本toast提示 */
+ (void)showToastWithMessage:(NSString *)message type:(AliToastType)type;

/** 纯文本toast提示 中间*/
+ (void)showToastWithMessage:(NSString *)message;

@end

NS_ASSUME_NONNULL_END
