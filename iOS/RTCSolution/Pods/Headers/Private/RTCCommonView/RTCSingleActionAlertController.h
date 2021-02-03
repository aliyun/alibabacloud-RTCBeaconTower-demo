//
//  RTCSingleActionAlertController.h
//  RTCVideoLiveRoom
//
//  Created by aliyun on 2020/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTCSingleActionAlertController : UIViewController

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
                  actionTitle:(NSString *)actionTitle
                       action:(void(^)(void))action;
@end

NS_ASSUME_NONNULL_END
