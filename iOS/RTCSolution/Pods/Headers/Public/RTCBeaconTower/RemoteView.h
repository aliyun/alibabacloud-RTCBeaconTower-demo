//
//  RemoteView.h
//  AliChatRoom
//
//  Created by 黄浩 on 2020/2/14.
//  Copyright © 2020 AliChatRoom. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AliRTCSdk/AliRTCSdk.h>
#import <ReactiveObjC/ReactiveObjC.h>

NS_ASSUME_NONNULL_BEGIN

@class PositionView;

@interface RemoteView : UIView

@property (nonatomic, copy) void(^tapBlock)(NSString *uid,RemoteView *remoteView);

@property (nonatomic, strong) AliRenderView *remoteView;
@property (nonatomic, strong) AliVideoCanvas *canvas;
@property (nonatomic, strong) AliRenderView *screenView;
@property (nonatomic, strong) AliVideoCanvas *screenCanvas;
@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, copy  ) NSString *uid;
@property (nonatomic, assign) BOOL isLocal;

@property (nonatomic, strong) PositionView *positionView;

@end

@interface PositionView : UIView

@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *nameLabel;

@end

NS_ASSUME_NONNULL_END
