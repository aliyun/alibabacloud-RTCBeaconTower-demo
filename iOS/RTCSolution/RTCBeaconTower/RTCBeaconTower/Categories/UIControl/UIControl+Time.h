//
//  UIControl+Time.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/27.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIControl (Time)

// 可以用这个给重复点击加间隔
@property (nonatomic, assign) NSTimeInterval filterTime;


@end

NS_ASSUME_NONNULL_END
