//
//  RTC_ModuleDefine.h
//  AliyunVideoClient_Entrance
//
//  Created by Aliyun on 2018/3/22.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

/**
  模块的定义与分类分类

 - RTC_ModuleType_ApsaraV: apsaraV
 - RTC_ModuleType_VideoShooting: 视频拍摄
 - RTC_ModuleType_VideoEdit: 视频编辑
 - RTC_ModuleType_VideoUpload: 视频上传
 - RTC_ModuleType_VideoLive: 视频直播
 - RTC_ModuleType_VideoPaly: 视频播放
 - RTC_ModuleType_LiveAnswer: 直播答题
 - RTC_ModuleType_MagicCamera:魔法相机
 - RTC_ModuleType_VideoClip:视频裁剪
 RTC_ModuleType_Temp_ShortVideo_Demo:原先短视频的demo
 */
typedef NS_ENUM(NSInteger,RTC_ModuleType){
    
    RTC_ModuleType_AudioChat1To1 = 1 << 0,//语聊1对1
    RTC_ModuleType_BeaconTower = 1 << 1,//音视频通话
    RTC_ModuleType_InteractiveClass = 1 << 2,//大班课
    RTC_ModuleType_AudioChatRoom = 1 << 3,//语聊房
    RTC_ModuleType_VideoLiveRoom = 1 << 4,//视频互动直播
    RTC_ModuleType_SmallClass = 1 << 5,//超级小班课
    RTC_ModuleType_MultiplayerVideo = 1 << 6,//多人视频连麦
    

};


@interface RTCModuleDefine : NSObject


/**
 指定初始化方法

 @param type 模块类型
 @return 实例变量
 */
- (instancetype)initWithModuleType:(RTC_ModuleType )type;


/**
 类型
 */
@property (assign, nonatomic) RTC_ModuleType type;

/**
 描述
 */
@property (strong, nonatomic, readonly) NSString *name;

/**
 图片0000、
    QQQ
 */
@property (strong, nonatomic, readonly) UIImage *image;


#pragma mark - 类方法
/**
 模块功能对应的描述

 @param type 模块功能
 @return 描述
 */
+ (NSString *)nameWithModuleType:(RTC_ModuleType )type;


/**
 模块功能对应的图片

 @param type 模块功能
 @return 图片
 */
+ (UIImage *__nullable)imageWithModuleType:(RTC_ModuleType )type;

/**
 返回创建好的所有的功能模块

 @return 排列好的所有的功能模块
 */
+ (NSArray <RTCModuleDefine *>*)allModules;


/**
 返回创建好的所有的demo模块
 
 @return 排列好的所有的功能模块
 */
+ (NSArray <RTCModuleDefine *>*)allDemos;



@end

NS_ASSUME_NONNULL_END
