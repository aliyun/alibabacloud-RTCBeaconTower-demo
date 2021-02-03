//
//  RTCModuleItemCCell.h
//  AliyunVideoClient_Entrance
//
//  Created by Aliyun on 2018/4/4.
//  Copyright © 2018年 Alibaba. All rights reserved.
//  首页模块的CollectionViewCell

#import <UIKit/UIKit.h>

@class RTCModuleDefine;


@interface RTCModuleItemCCell : UICollectionViewCell


/**
 功能模块的图片
 */
@property (weak, nonatomic) IBOutlet UIImageView *moduleImageView;


/**
 功能模块的名称
 */
@property (weak, nonatomic) IBOutlet UILabel *moduleLabel;


/**
 渲染cell

 @param aDefine 功能模块
 */
- (void)configWithModule:(RTCModuleDefine *)aDefine;

@end
