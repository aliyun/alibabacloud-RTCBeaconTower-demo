//
//  AliRTCBeaconTower.m
//  AFNetworking
//
//  Created by 孙震 on 2020/12/28.
//

#import "AliRTCBeaconTower.h"

@interface AliRTCBeaconTower()<AliRtcEngineDelegate>
/**
 @brief SDK实例
 */
@property (nonatomic, strong) AliRtcEngine *engine;

@property (nonatomic, weak) id<AliRTCBeaconTowerDelegate> delegate;


@end

static dispatch_once_t onceToken;
static AliRTCBeaconTower *manager = nil;

@implementation AliRTCBeaconTower

+ (AliRTCBeaconTower *) sharedInstance{

    dispatch_once(&onceToken, ^{
        manager = [[super allocWithZone:NULL] init];
        
    });
    return manager;
}

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    return [AliRTCBeaconTower sharedInstance];
}

- (id)copyWithZone:(nullable NSZone *)zone {
    return [AliRTCBeaconTower sharedInstance];
}

- (id)mutableCopyWithZone:(nullable NSZone *)zone {
    return [AliRTCBeaconTower sharedInstance];
}


/**
 @brief 初始化SDK
 */
- (void)initializeSDK{
    [AliRtcEngine setH5CompatibleMode:YES];
    _engine = [AliRtcEngine sharedInstance:self extras:@""];
    [_engine setAutoPublish:NO withAutoSubscribe:NO];
    [_engine setVideoProfile:AliRtcVideoProfile_480_640P_15 forTrack:AliRtcVideoTrackCamera];
    [_engine enableSpeakerphone:NO];
}

+ (void)destroySharedInstance{
    [AliRtcEngine destroy];
    onceToken = 0;
    manager = nil;
}

- (void)login:(AliRtcAuthInfo *)authInfo name:(NSString *)name {
    [self.engine joinChannel:authInfo name:name onResult:nil];
}

- (void)logout {
     [self.engine leaveChannel];
}

/// 上麦只需要切换角色
/// 成功的回调是 onUpdateRoleNotifyWithOldRole
- (void)enterSeat {
    __weak typeof(self) weakSelf = self;
    [self.engine configLocalAudioPublish:YES];
    [self.engine configLocalCameraPublish:YES];
    [self.engine publish:^(int errCode) {
        //主播身份切换结果通知
        if([weakSelf.delegate respondsToSelector:@selector(onEnterSeatResult:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.delegate onEnterSeatResult:errCode];
            });
        }
    }];
}

//角色变化通知
- (void)onUpdateRoleNotifyWithOldRole:(AliRtcClientRole)oldRole
                              newRole:(AliRtcClientRole)newRole
{
//     __weak typeof(self) weakSelf = self;
//    if (newRole == AliRtcClientRoleInteractive)
//    {
//        //切换成主播
//        [self.engine configLocalAudioPublish:YES];
//        [self.engine configLocalCameraPublish:YES];
//        [self.engine publish:^(int errCode) {
//            //主播身份切换结果通知
//            if([weakSelf.delegate respondsToSelector:@selector(onEnterSeatResult:)]) {
//                dispatch_async(dispatch_get_main_queue(), ^{
//                    [weakSelf.delegate onEnterSeatResult:errCode];
//                });
//            }
//        }];
//    }
    if ([self.delegate respondsToSelector:@selector(onUpdateRoleNotifyWithOldRole:newRole:)]) {
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate onUpdateRoleNotifyWithOldRole:oldRole newRole:newRole];
        });
        
    }
    
}

///  下麦需要停止推流 成功的回调是 onUpdateRoleNotifyWithOldRole
- (void)leaveSeat
{
    __weak typeof(self) weakSelf = self;
    [self.engine configLocalAudioPublish:YES];
    [self.engine configLocalCameraPublish:NO];
    [self.engine publish:^(int errCode) {
        if (errCode == 0) {
            [weakSelf.engine setClientRole:AliRtcClientRolelive];
        }
        //主播下麦结果通知
        if([weakSelf.delegate respondsToSelector:@selector(onLeaveSeatResult:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf.delegate onLeaveSeatResult:errCode];
            });
        }
    }];
}


- (int)muteLocalMic:(BOOL)mute {
    return [self.engine muteLocalMic:mute];
}

- (int)muteLocalCamera:(BOOL)mute forTrack:(AliRtcVideoTrack)track {
    if (mute) {
        [self.engine stopPreview];
    }else{
        [self.engine startPreview];
    }
    return [self.engine muteLocalCamera:mute forTrack:track];
   
}

- (int)switchCamera {
    return [self.engine switchCamera];
}

- (int)enableSpeakPhone:(BOOL)enable {
    return [self.engine enableSpeakerphone:enable];
}

- (int)setRemoteViewConfig:(AliVideoCanvas *)canvas uid:(NSString *)uid forTrack:(AliRtcVideoTrack)track {
    return [self.engine setRemoteViewConfig:canvas uid:uid forTrack:track];
}

- (int)setLocalViewConfig:(AliVideoCanvas *)viewConfig forTrack:(AliRtcVideoTrack)track {
    return [self.engine setLocalViewConfig:viewConfig forTrack:track];
}

- (int)stopPreview {
    return [self.engine stopPreview];
}

- (int)startPreview {
    return [self.engine startPreview];
}

- (void)configRemoteAudio:(NSString *)uid enable:(BOOL)enable {
    [self.engine configRemoteAudio:uid enable:enable];
}

- (void)configRemoteCameraTrack:(NSString *)uid preferMaster:(BOOL)master enable:(BOOL)enable {
    [self.engine configRemoteCameraTrack:uid preferMaster:master enable:enable];
}
- (void)configRemoteScreenTrack:(NSString *)uid enable:(BOOL)enable {
    [self.engine configRemoteScreenTrack:uid enable:enable];
}

- (void)subscribe:(NSString *)uid onResult:(void (^)(NSString *uid, AliRtcVideoTrack vt, AliRtcAudioTrack at))onResult {
    [self.engine subscribe:uid onResult:onResult];
}



- (AliRtcEngine *)engine {
    if (!_engine) {
        [self initializeSDK];
    }
    return _engine;
}
 
- (void)onOccurError:(int)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (error == AliRtcErrSdkInvalidState || error == AliRtcErrIceConnectionHeartbeatTimeout || error == AliRtcErrSessionRemoved ) {
            if ([self.delegate respondsToSelector:@selector(onSDKError:)])
            {
                [self.delegate onSDKError:error];
            }
        } else {
            if ([self.delegate respondsToSelector:@selector(onOccurError:)])
            {
                [self.delegate onOccurError:error];
            }
        }
    });
   
}

- (void)onOccurWarning:(int)warn
{
    if ([self.delegate respondsToSelector:@selector(onOccurWarning:)])
    {
        dispatch_async(dispatch_get_main_queue(), ^{
             [self.delegate onOccurWarning:warn];
        });
       
    }
}


- (void)onBye:(int)code {
    if (code == 2)
    {
        if ([self.delegate respondsToSelector:@selector(onRoomdestroy)])
        {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate onRoomdestroy];
            });
        }
    }
}

- (void)onJoinChannelResult:(int)result authInfo:(AliRtcAuthInfo *)authInfo {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(onJoinChannelResult:authInfo:)]) {
            [self.delegate onJoinChannelResult:result authInfo:authInfo];
        }
    });
}

- (void)onLeaveChannelResult:(int)result {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(onLeaveChannelResult:)]) {
            [self.delegate onLeaveChannelResult:result];
        }
    });
}

- (void)onRemoteTrackAvailableNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(onRemoteTrackAvailableNotify:audioTrack:videoTrack:)]) {
            [self.delegate onRemoteTrackAvailableNotify:uid audioTrack:audioTrack videoTrack:videoTrack];
        }
    });
}

- (void)onSubscribeChangedNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(onSubscribeChangedNotify:audioTrack:videoTrack:)]) {
            [self.delegate onSubscribeChangedNotify:uid audioTrack:audioTrack videoTrack:videoTrack];
        }
    });
}

- (void)onUserAudioMuted:(NSString *)uid audioMuted:(BOOL)isMute {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(onUserAudioMuted:audioMuted:)]) {
            [self.delegate onUserAudioMuted:uid audioMuted:isMute];
        }
    });
}


- (void)onUserVideoMuted:(NSString *)uid videoMuted:(BOOL)isMute {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(onUserVideoMuted:videoMuted:)]) {
            [self.delegate onUserVideoMuted:uid videoMuted:isMute];
        }
    });
}

- (void)onRemoteUserOffLineNotify:(NSString *)uid {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(onRemoteUserOffLineNotify:)]) {
            [self.delegate onRemoteUserOffLineNotify:uid];
        }
    });
}

- (void)onRemoteUserOnLineNotify:(NSString *)uid {
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([self.delegate respondsToSelector:@selector(onRemoteUserOnLineNotify:)]) {
            [self.delegate onRemoteUserOnLineNotify:uid];
        }
    });
}
- (NSString *)displayName:(NSString *)userid {

    NSString *displayName = @"";
    NSString *displayName_utf8 = [self.engine getUserInfo:userid][@"displayName"];
    
    if (displayName_utf8) {
        displayName = displayName_utf8;
    }
    return displayName;
}
 


@end
