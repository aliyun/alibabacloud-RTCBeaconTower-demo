//
//  RTCDoubleActionsAlertController.h
//  RTCVideoLiveRoom
//
//  Created by aliyun on 2020/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTCDoubleActionsAlertController : UIViewController

- (instancetype)initWithTitle:(NSString *)title
                      message:(NSString *)message
              leftActionTitle:(NSString *)leftTitle
                   leftAction:(void(^)(void))leftAction
             rightActionTitle:(NSString *)rightTitle
                  rightAction:(void(^)(void))rightAction;

@end

NS_ASSUME_NONNULL_END
