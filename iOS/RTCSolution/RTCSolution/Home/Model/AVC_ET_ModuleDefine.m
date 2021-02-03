//
//  AVC_ET_ModuleDefine.m
//  AliyunVideoClient_Entrance
//
//  Created by Zejian Cai on 2018/3/22.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "RTCModuleDefine.h"

@implementation RTCModuleDefine

- (instancetype)init{
    self = [self initWithModuleType:AVC_ET_ModuleType_VideoPaly];
    return self;
}

- (instancetype)initWithModuleType:(AVC_ET_ModuleType)type{
    self = [super init];
    if (self) {
        _type = type;
        _name = [RTCModuleDefine nameWithModuleType:type];
        _image = [RTCModuleDefine imageWithModuleType:type];
    }
    return self;
}

+ (NSString *)nameWithModuleType:(AVC_ET_ModuleType)type{
    switch (type) {
        case AVC_ET_ModuleType_Smartboard:
            return @"互动白板";
            break;
        case AVC_ET_ModuleType_RaceBeauty:
            return @"美颜美型";
            break;
        case AVC_ET_ModuleType_FaceDetect:
            return @"人脸识别";
            break;
        case AVC_ET_ModuleType_MetalPreview:
            return @"Metal预览";
            break;
    }
    return @"";
}

+ (UIImage *__nullable)imageWithModuleType:(AVC_ET_ModuleType)type{
    switch (type) {
        case AVC_ET_ModuleType_VideoEdit:
            return [UIImage imageNamed:@"avc_home_videoEdit"];
            break;
        case AVC_ET_ModuleType_VideoLive:
            return [UIImage imageNamed:@"avc_home_videoLive"];
            break;
        case AVC_ET_ModuleType_VideoPaly:
            return [UIImage imageNamed:@"avc_home_videoPlay"];
            break;
        case AVC_ET_ModuleType_VideoUpload:
            return [UIImage imageNamed:@"avc_home_videoUpload"];
            break;
        case AVC_ET_ModuleType_VideoShooting:
            return [UIImage imageNamed:@"avc_home_videoShooting"];
            break;
        case AVC_ET_ModuleType_PushFlow:
            return [UIImage imageNamed:@"avc_home_videoLive"];
            break;
        case AVC_ET_ModuleType_VideoClip:
            return [UIImage imageNamed:@"avc_home_videoCrop"];
            break;
        case AVC_ET_ModuleType_ShortVideo:
            return [UIImage imageNamed:@"avc_home_shortVideo"];
            break;
        case AVC_ET_ModuleType_RTC:
            return [UIImage imageNamed:@"avc_home_rtc_video"];
            
        case AVC_ET_ModuleType_RTC_Audio:
            return [UIImage imageNamed:@"avc_home_rtc_audio"];
            
            break;
        case AVC_ET_ModuleType_VideoShooting_Basic:
            return [UIImage imageNamed:@"avc_home_videoShooting"];
            break;
        case AVC_ET_ModuleType_VideoClip_Basic:
            return [UIImage imageNamed:@"avc_home_videoCrop"];
            break;
        case AVC_ET_ModuleType_Smartboard:
            return [UIImage imageNamed:@"avc_home_videoEdit"];
            break;
        case AVC_ET_ModuleType_RaceBeauty:
            return [UIImage imageNamed:@"beauty"];
            break;
        case AVC_ET_ModuleType_FaceDetect:
            return [UIImage imageNamed:@"avc_home_shortVideo"];
            break;
        case AVC_ET_ModuleType_MetalPreview:
            return [UIImage imageNamed:@"avc_home_shortVideo"];
            break;
    }

}


+ (NSArray <RTCModuleDefine *>*)allModules{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 7; i ++) {
        AVC_ET_ModuleType type = (AVC_ET_ModuleType)i;
        RTCModuleDefine *module = [[RTCModuleDefine alloc]initWithModuleType:type];
        [mArray addObject:module];
    }
    return (NSArray *)mArray;
}


+ (NSArray <RTCModuleDefine *>*)allDemos{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (int i = 7; i < 12; i ++) {
        AVC_ET_ModuleType type = (AVC_ET_ModuleType)i;
        RTCModuleDefine *module = [[RTCModuleDefine alloc]initWithModuleType:type];
        [mArray addObject:module];
    }
    return (NSArray *)mArray;
}

@end
