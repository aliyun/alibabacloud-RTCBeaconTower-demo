//
//  RTC_ModuleDefine.m
//  AliyunVideoClient_Entrance
//
//  Created by Aliyun on 2018/3/22.
//  Copyright © 2018年 Alibaba. All rights reserved.
//

#import "RTCModuleDefine.h"

@implementation RTCModuleDefine

- (instancetype)init{
    self = [self initWithModuleType:RTC_ModuleType_AudioChat1To1];
    return self;
}

- (instancetype)initWithModuleType:(RTC_ModuleType)type{
    self = [super init];
    if (self) {
        _type = type;
        _name = [RTCModuleDefine nameWithModuleType:type];
        _image = [RTCModuleDefine imageWithModuleType:type];
    }
    return self;
}

+ (NSString *)nameWithModuleType:(RTC_ModuleType)type{
    switch (type) {
        case RTC_ModuleType_AudioChat1To1:
            return @"一对一语聊";
            break;
        case RTC_ModuleType_InteractiveClass:
            return @"互动大班课";
            break;
        case RTC_ModuleType_AudioChatRoom:
            return @"语音聊天室";
        case RTC_ModuleType_VideoLiveRoom:
            return @"视频互动直播";
            break;
         case RTC_ModuleType_MultiplayerVideo:
            return @"多人视频连麦";
            break;
        case RTC_ModuleType_SmallClass:
            return @"超级小班课";
            break;
        case RTC_ModuleType_BeaconTower:
            return @"音视频通话";
            break;
    }
}

+ (UIImage *__nullable)imageWithModuleType:(RTC_ModuleType)type{
    switch (type) {
        case RTC_ModuleType_AudioChat1To1:
            return [UIImage imageNamed:@"1v1"];
            break;
        case RTC_ModuleType_AudioChatRoom:
            return [UIImage imageNamed:@"interactiveLiveClass"];
            break;
        case RTC_ModuleType_InteractiveClass:
            return [UIImage imageNamed:@"chatRoom"];
        case RTC_ModuleType_VideoLiveRoom:
            return [UIImage imageNamed:@"videoliveClass"];
            break;
        case RTC_ModuleType_MultiplayerVideo:
            return [UIImage imageNamed:@"videoliveClass"];
            break;
        case RTC_ModuleType_SmallClass:
            return [UIImage imageNamed:@"smallClass"];
            break;
        case RTC_ModuleType_BeaconTower:
            return [UIImage imageNamed:@"beacon"];
            break;
    }
    
}


+ (NSArray <RTCModuleDefine *>*)allModules{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (int i = 0; i < 7; i ++) {
        RTC_ModuleType type = (RTC_ModuleType)i;
        RTCModuleDefine *module = [[RTCModuleDefine alloc]initWithModuleType:type];
        [mArray addObject:module];
    }
    return (NSArray *)mArray;
}


+ (NSArray <RTCModuleDefine *>*)allDemos{
    NSMutableArray *mArray = [[NSMutableArray alloc]init];
    for (int i = 7; i < 12; i ++) {
        RTC_ModuleType type = (RTC_ModuleType)i;
        RTCModuleDefine *module = [[RTCModuleDefine alloc]initWithModuleType:type];
        [mArray addObject:module];
    }
    return (NSArray *)mArray;
}

@end
