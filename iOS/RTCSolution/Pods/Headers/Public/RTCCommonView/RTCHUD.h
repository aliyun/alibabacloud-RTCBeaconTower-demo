//
//  RTCHUD.h
//  RTCInteractiveLiveClass
//
//  Created by Aliyun on 2020/6/30.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTCHUD : NSObject
+ (void)showHud:(NSString*)msg inView:(UIView*)view;
+ (void)showHUDInView:(UIView *)view;
+ (void)hideHUDInView:(UIView *)view;
@end

NS_ASSUME_NONNULL_END
