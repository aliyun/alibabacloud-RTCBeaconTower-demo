//
//  UIView+Loading.h
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/20.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <objc/message.h>

NS_ASSUME_NONNULL_BEGIN

@interface UIView (Loading)

@property (nonatomic, strong) UIActivityIndicatorView *loadView;


- (void)startLoadingAnimation;
- (void)stopLoadingAnimation;

@end

NS_ASSUME_NONNULL_END
