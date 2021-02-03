//
//  LoadingButton.h
//  VoiceCall
//
//  Created by aliyun on 2020/4/20.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LoadingButton : UIButton

- (void)setBackgroundColor:(nullable UIColor *)color forState:(UIControlState)state;

- (void)startLoading;

- (void)stopLoading;

@end

NS_ASSUME_NONNULL_END
