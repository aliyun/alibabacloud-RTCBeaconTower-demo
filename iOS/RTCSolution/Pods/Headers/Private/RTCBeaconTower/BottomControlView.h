//
//  BottomControlView.h
//  RtcVideo
//
//  Created by 黄浩 on 2020/2/19.
//  Copyright © 2020 RtcVideo. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

typedef NS_ENUM(NSInteger,StateType) {
    StateTypeNormal,
    StateTypeSelected,
    StateTypeDisEnable
};

@class CustomView;

@interface BottomControlView : UIView

@property (nonatomic, strong) CustomView *muteAudioBtn;
@property (nonatomic, strong) CustomView *muteCameraBtn;
@property (nonatomic, strong) CustomView *phoneBtn;
@property (nonatomic, strong) CustomView *hangBtn;
@property (nonatomic, strong) CustomView *cameraTurnBtn;


@end


@interface CustomView : UIView

@property (nonatomic, assign) StateType type;
@property (nonatomic, assign) BOOL selected;

@property (nonatomic, strong) UIButton *actionBtn;
@property (nonatomic, strong) UILabel *nameLabel;


@end

NS_ASSUME_NONNULL_END
