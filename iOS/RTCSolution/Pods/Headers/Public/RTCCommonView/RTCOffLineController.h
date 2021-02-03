//
//  RTCOffLineController.h
//  RTCCommonView
//
//  Created by aliyun on 2020/8/19.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface RTCOffLineController : UIViewController

- (instancetype)initWithcloseAction:(void(^)(void))closeAction
                        retryAction:(void(^)(void))retryAction;
@end

NS_ASSUME_NONNULL_END
