//
//  AliToast.m
//  AliRTCApp
//
//  Created by 黄浩 on 2019/11/25.
//  Copyright © 2019 AliRTCApp. All rights reserved.
//

#import "Toast.h"
#import "BeaconHeader.h"


@implementation Toast

+ (void)showToastWithMessage:(NSString *)message type:(AliToastType)type {
    
    UIView *bgView = [[UIView alloc]init];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:bgView];
    bgView.backgroundColor = [UIColor whiteColor] ;
    bgView.layer.cornerRadius = 5;
    
    // label
    UILabel *label = [[UILabel alloc]init];
    label.text = message;
    [bgView addSubview:label];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:15];
    
    if (type == AliToastTypeNormal) {
        label.textColor = [UIColor blackColor];
    } else if (type == AliToastTypeError) {
        label.textColor = [UIColor colorWithRed:230/255.0 green:57/255.0 blue:58/255.0 alpha:1];
    } else if (type == AliToastTypeWarn) {
        label.textColor = [UIColor colorWithRed:245/255.0 green:180/255.0 blue:55/255.0 alpha:1];
    }
    
    bgView.frame = CGRectMake(10, -30, keyWindow.frame.size.width - 20, 30);
    label.frame = CGRectMake(0, 0, bgView.frame.size.width, bgView.frame.size.height);
    [UIView animateWithDuration:0.5 animations:^{
        bgView.frame = CGRectMake(10, 5, keyWindow.frame.size.width - 20, 30);
    }];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.5 animations:^{
            bgView.frame = CGRectMake(10, -30, keyWindow.frame.size.width - 20, 30);
        } completion:^(BOOL finished) {
            [bgView removeFromSuperview];
        }];
    });
}

+ (void)showToastWithMessage:(NSString *)message {
    if (!message || !message.length) {
        return;
    }
    UIView *bgView = [[UIView alloc]init];
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    [keyWindow addSubview:bgView];
    bgView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.3];
    bgView.layer.cornerRadius = 5;
    
    // label
    UILabel *label = [[UILabel alloc]init];
    label.text = message;
    [bgView addSubview:label];
    label.numberOfLines = 0;
    label.textAlignment = NSTextAlignmentCenter;
    label.font = [UIFont boldSystemFontOfSize:15];
    
    CGFloat bgWidth = keyWindow.frame.size.width - 60;
    
    kGlobalQueue(^{
        CGRect rect = [message boundingRectWithSize:CGSizeMake(bgWidth - 30, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont boldSystemFontOfSize:15]} context:nil];
        kMainQueue(^{
            bgView.bounds = CGRectMake(0, 0, bgWidth, rect.size.height + 40);
            bgView.center = CGPointMake(keyWindow.center.x, keyWindow.center.y);
            label.frame = CGRectMake(15, 20, bgView.frame.size.width - 30, rect.size.height);
            
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [UIView animateWithDuration:0.5 animations:^{
                    bgView.alpha = 0;
                } completion:^(BOOL finished) {
                    [bgView removeFromSuperview];
                }];
            });
        });
    });
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
