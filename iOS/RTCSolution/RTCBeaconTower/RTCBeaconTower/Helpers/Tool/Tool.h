//
//  Tool.h
//  AliRTCApp
//
//  Created by 黄浩 on 2020/1/2.
//  Copyright © 2020 AliRTCApp. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface Tool : NSObject

+ (UIViewController *)currentViewController;

+ (BOOL)isPhoneX;

+ (BOOL)haveNetwork;

@end

NS_ASSUME_NONNULL_END
