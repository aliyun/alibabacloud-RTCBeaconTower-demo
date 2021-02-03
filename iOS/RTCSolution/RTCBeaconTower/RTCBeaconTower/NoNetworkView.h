//
//  NoNetworkView.h
//  BeaconTowner
//
//  Created by 黄浩 on 2020/3/9.
//  Copyright © 2020 BeaconTowner. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface NoNetworkView : UIView

@property (nonatomic, copy) void(^againBlock)(void);

@property (nonatomic, strong) UIImageView *imageV;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subTitleLabel;
@property (nonatomic, strong) UIButton *againBtn;

@end

NS_ASSUME_NONNULL_END
