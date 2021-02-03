//
//  AliRTCBeaconTower.h
//  AFNetworking
//
//  Created by 孙震 on 2020/12/28.
//

#import <Foundation/Foundation.h>
#import <AliRTCSdk/AliRTCSdk.h>
NS_ASSUME_NONNULL_BEGIN


@protocol AliRTCBeaconTowerDelegate <NSObject>

/// 远端用户下线通知
/// @param uid 用户id
- (void)onRemoteUserOffLineNotify:(NSString *)uid;


/// 远端用户上线通知
/// @param uid 用户id
- (void)onRemoteUserOnLineNotify:(NSString *)uid;

/// 自己上麦通知
/// @param errorCode 结果
- (void)onEnterSeatResult:(int)errorCode;

/// 自己下线通知
/// @param errorCode 结果
- (void)onLeaveSeatResult:(int)errorCode;

/// 房间被销毁通知
- (void)onRoomdestroy;

/**
 * @brief 如果engine出现error，通过这个回调通知app
 * @param error  Error type
 */
- (void)onOccurError:(int)error;
/**
* @brief 如果engine出现warning，通过这个回调通知app
* @param warn  Warning type
*/
- (void)onOccurWarning:(int)warn;
/**
* @brief 如果engine出现严重error，通过这个回调通知app
* @param error  错误类型
*/
- (void)onSDKError:(int)error;

/**
* @brief 加入频道结果
* @param result 加入频道结果，成功返回0，失败返回错误码
* @note 此回调等同于joinChannel接口的block，二者择一处理即可
*/
- (void)onJoinChannelResult:(int)result authInfo:(AliRtcAuthInfo *)authInfo;

/**
* @brief 离开频道结果
* @param result 离开频道结果，成功返回0，失败返回错误码
* @note 调用leaveChannel接口后返回，如果leaveChannel后直接调用destroy，将不会收到此回调
*/
- (void)onLeaveChannelResult:(int)result;

/**
* @brief 当远端用户的流发生变化时，返回这个消息
* @note 远方用户停止推流，也会发送这个消息
*/
- (void)onRemoteTrackAvailableNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack;

/**
 * @brief 当订阅情况发生变化时，返回这个消息
 */
- (void)onSubscribeChangedNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack;

/**
 * @brief 用户muteAudio通知
 * @param uid 执行muteAudio的用户
 * @param isMute YES:静音 NO:未静音
 */
- (void)onUserAudioMuted:(NSString *)uid audioMuted:(BOOL)isMute;

/**
 * @brief 用户muteVideo通知
 * @param uid 执行muteVideo的用户
 * @param isMute YES:推流黑帧 NO:正常推流
 */
- (void)onUserVideoMuted:(NSString *)uid videoMuted:(BOOL)isMute;

/**
 * @brief 网络质量变化时发出的消息
 * @param uid 网络质量发生变化的uid
 * @param upQuality  上行网络质量
 * @param downQuality  下行网络质量
 * @note 当网络质量发生变化时触发，uid为@""时代表self的网络质量变化
 */
- (void)onNetworkQualityChanged:(NSString *)uid
               upNetworkQuality:(AliRtcNetworkQuality)upQuality
             downNetworkQuality:(AliRtcNetworkQuality)downQuality;

/**
 * @brief 当用户角色发生变化化时通知
 * @param oldRole 变化前角色类型
 * @param newRole 变化后角色类型
 * @note 调用setClientRole方法切换角色成功时触发此回调
 */
- (void)onUpdateRoleNotifyWithOldRole:(AliRtcClientRole)oldRole newRole:(AliRtcClientRole)newRole;

@end

@interface AliRTCBeaconTower : NSObject

/**
* @brief 获取单例
* @return RTCManager 单例对象
*/
+ (AliRTCBeaconTower *) sharedInstance;


/// 销毁RTCSDK
+ (void)destroySharedInstance;

/// 设置代理
/// @param delegate 代理对象
- (void)setDelegate:(id<AliRTCBeaconTowerDelegate>)delegate;

/**
* @brief 加入频道
* @param authInfo   频道号
* @param name    任意用于显示的用户名称。不是User ID
*/
- (void)login:(AliRtcAuthInfo *)authInfo name:(NSString *)name;

/// 离开频道
- (void)logout;

/// 开始推流
- (void)enterSeat;

/// 停止推流
- (void)leaveSeat;

/**
* @brief mute/unmute本地音频采集
* @param mute  YES表示本地音频采集空帧；NO表示恢复正常
* @note mute是指采集和发送静音帧。采集和编码模块仍然在工作
* @return 0表示成功放入队列，-1表示被拒绝
*/
- (int)muteLocalMic:(BOOL)mute;

/**
* @brief 是否将停止本地视频采集
* @param mute     YES表示停止视频采集；NO表示恢复正常
* @param track    需要停止采集的track
* @return 0表示Success 非0表示Failure
* @note 发送黑色的视频帧。本地预览也呈现黑色。采集，编码，发送模块仍然工作，
*       只是视频内容是黑色帧
*/

- (int)muteLocalCamera:(BOOL)mute forTrack:(AliRtcVideoTrack)track;

/**
* @brief 切换前后摄像头
* @return 0表示Success 非0表示Failure
* @note 只有iOS和android提供这个接口
*/
- (int)switchCamera;

/**
* @brief 为远端的视频设置窗口以及绘制参数
* @param canvas canvas包含了窗口以及渲染方式
* @param uid    User ID。从App server分配的唯一标示符
* @param track  需要设置的track
* @return 0表示Success 非0表示Failure
* @note 支持joinChannel之前和之后切换窗口。如果canvas为nil或者view为nil，则停止渲染相应的流
*       如果在播放过程中需要重新设置render mode，请保持canvas中其他成员变量不变，仅修改
*       renderMode
*       如果在播放过程中需要重新设置mirror mode，请保持canvas中其他成员变量不变，仅修改
*       mirrorMode
*/

- (int)setRemoteViewConfig:(AliVideoCanvas *)canvas uid:(NSString *)uid forTrack:(AliRtcVideoTrack)track;

/**
* @brief 为本地预览设置窗口以及绘制参数
* @param viewConfig 包含了窗口以及渲染方式
* @param track      must be AliVideoTrackCamera
* @return 0表示Success 非0表示Failure
* @note 支持joinChannel之前和之后切换窗口。如果viewConfig或者viewConfig中的view为nil，则停止渲染
*       如果在播放过程中需要重新设置render mode，请保持canvas中其他成员变量不变，仅修改
*       renderMode
*       如果在播放过程中需要重新设置mirror mode，请保持canvas中其他成员变量不变，仅修改
*       mirrorMode
*/

- (int)setLocalViewConfig:(AliVideoCanvas *)viewConfig forTrack:(AliRtcVideoTrack)track;

/**
* @brief 停止本地预览
* @return 0表示Success 非0表示Failure
* @note leaveChannel会自动停止本地预览
*       会自动关闭摄像头 (如果正在publish camera流，则不会关闭摄像头)
*/

- (int)stopPreview;

/**
* @brief 开始本地预览
* @return 0表示Success 非0表示Failure
* @note 如果没有设置view，则无法预览。可以在joinChannel之前就开启预览
*       会自动打开摄像头
*/

- (int)startPreview;


- (void)configRemoteAudio:(NSString *)uid enable:(BOOL)enable;

- (void)configRemoteCameraTrack:(NSString *)uid preferMaster:(BOOL)master enable:(BOOL)enable;

- (void)configRemoteScreenTrack:(NSString *)uid enable:(BOOL)enable;

/**
* @brief 手动拉视频和音频流
* @param uid        User ID。不允许为nil
* @param onResult   当subscribe执行结束后调用这个回调
* @note 如果需要手动选择拉取的流，调用configRemoteAudio, configRemoteCameraTrack,
*       configRemoteScreenTrack来设置。缺省是拉取audio和camera track
*       如果需要unsub所有的流，先通过configRemoteAudio, configRemoteCameraTrack,
*       configRemoteScreenTrack来清除设置，然后调用subscribe
*/

- (void)subscribe:(NSString *)uid onResult:(void (^)(NSString *uid, AliRtcVideoTrack vt, AliRtcAudioTrack at))onResult;


/// 获取用户名
/// @param userid userId
- (NSString *)displayName:(NSString *)userid;

- (int)enableSpeakPhone:(BOOL)enable;

@end

NS_ASSUME_NONNULL_END
