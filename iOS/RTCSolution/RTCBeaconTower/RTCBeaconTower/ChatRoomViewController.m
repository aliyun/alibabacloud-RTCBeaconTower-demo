//
//  ChatRoomViewController.m
//  RtcVideo
//
//  Created by 黄浩 on 2020/2/19.
//  Copyright © 2020 RtcVideo. All rights reserved.
//

#import "ChatRoomViewController.h"
#import "BottomControlView.h" 
#import "RemoteView.h"
#import "BeaconHeader.h"
#import "AliRTCBeaconTower.h"
#import <CommonCrypto/CommonHMAC.h>

#define remoteWidth 90

#define offset_x 12
#define off_x 16

#define offset_y 16

#define timeAppear 5

@interface ChatRoomViewController ()<AliRTCBeaconTowerDelegate,UIScrollViewDelegate>

@property (nonatomic, strong) BottomControlView *controlView;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) NSMutableArray *remoteDataArray;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UILabel *toastLabel; 
@property (nonatomic, strong) RemoteView *localView;
@property (nonatomic, strong) RemoteView *currentLocalView;
@property (nonatomic, strong) UIView *tapView;

@property (nonatomic, strong) NSTimer *time;
@property (nonatomic, assign) NSInteger totoalTime;
@property (nonatomic, assign) NSInteger disTime;
@property (nonatomic, assign) BOOL isAppear;

@end

@implementation ChatRoomViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[AliRTCBeaconTower sharedInstance] setDelegate:self];
    [[NSUserDefaults standardUserDefaults] setObject:self.userName forKey:@"nameid"];
    [UIApplication sharedApplication].idleTimerDisabled = YES;
    self.time = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(scheduledTimer) userInfo:nil repeats:YES];
    [self.time setFireDate:[NSDate distantFuture]];
    self.isAppear = YES;
    
    
    self.navigationController.navigationBar.translucent = NO;
    self.view.backgroundColor = RGBHex(0x1D212C);
    
    [self initRtcEnging];
    [self addobserver];
    
    NSLog(@"---------%@",[AliRtcEngine getSdkVersion]);
    [self setNavView];
}

- (void)setNavView {
    self.navigationItem.title = [NSString stringWithFormat:@"会议码:%@",self.channelNumber];
    @weakify(self);
    UIButton *rightbutton = [UIButton buttonWithType:UIButtonTypeSystem];
    [rightbutton setTitle:@"复制" forState:UIControlStateNormal];
    [rightbutton setTitleColor:RGB(0, 193, 222) forState:UIControlStateNormal];
    [rightbutton sizeToFit];
    [[rightbutton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = self.channelNumber;
        [self beginToastWithString:[NSString stringWithFormat:@"会议码:%@已被复制",self.channelNumber]];
    }];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:rightbutton];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = RGBHex(0x1D212C);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor],NSFontAttributeName : [UIFont systemFontOfSize:17]}];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    [UIApplication sharedApplication].idleTimerDisabled = NO;
    
    [self leaveAction];
}
- (void)dealloc {
    NSLog(@"ChatRoomViewController dealloc");
}

- (void)leaveAction {
    [[AliRTCBeaconTower sharedInstance] logout];
    [self.time invalidate];
    self.time = nil;
}

- (void)createTapGesture {
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] init];
    [self.tapView addGestureRecognizer:tap];
    @weakify(self);
    [[tap rac_gestureSignal] subscribeNext:^(__kindof UIGestureRecognizer * _Nullable x) {
        @strongify(self);
        self.disTime = 0;
        self.isAppear = !self.isAppear;
        [self setControlViewAppear:self.isAppear];
    }];
}

- (void)scheduledTimer {
    self.totoalTime ++;
    [self setTimeLabel];
    if (self.isAppear) {
        self.disTime++;
        if (self.disTime >= timeAppear) {
            self.isAppear = NO;
            self.disTime = 0;
            [self setControlViewAppear:NO];
        }
    } else {
        self.disTime = 0;
    }
}

- (void)setTimeLabel {
    
    NSInteger hour = self.totoalTime / 3600;
    NSInteger minutes = self.totoalTime /60;
    NSInteger second = self.totoalTime % 60;
    if (self.totoalTime >= 3600) {
        self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld:%.2ld",hour,(long)minutes,(long)second];
    } else {
        self.timeLabel.text = [NSString stringWithFormat:@"%.2ld:%.2ld",(long)minutes,(long)second];
    }
}

- (void)setControlViewAppear:(BOOL)appear {
    if (appear) {
        self.controlView.hidden = NO;
        [UIView animateWithDuration:0.2 animations:^{
            self.controlView.alpha = 1;
        } completion:^(BOOL finished) {
            [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(25);
                make.centerX.equalTo(self.view.mas_centerX);
                make.bottom.equalTo(self.controlView.mas_top).offset(-15);
            }];
        }];
    } else {
        [UIView animateWithDuration:0.2 animations:^{
            self.controlView.alpha = 0;
        } completion:^(BOOL finished) {
            self.controlView.hidden = YES;
            [self.timeLabel mas_remakeConstraints:^(MASConstraintMaker *make) {
                make.width.mas_equalTo(100);
                make.height.mas_equalTo(25);
                make.centerX.equalTo(self.view.mas_centerX);
                make.bottom.equalTo(self.view.mas_bottom).offset(-20);
            }];
        }];
    }
}

- (void)addobserver {
    
    @weakify(self);
    [[self.controlView.muteAudioBtn.actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.controlView.muteAudioBtn.actionBtn.selected = !self.controlView.muteAudioBtn.actionBtn.selected;
        self.controlView.muteAudioBtn.type = self.controlView.muteAudioBtn.actionBtn.selected ? StateTypeSelected : StateTypeNormal;
        [[AliRTCBeaconTower sharedInstance] muteLocalMic:self.controlView.muteAudioBtn.actionBtn.selected];
        
        [self beginToastWithString:self.controlView.muteAudioBtn.actionBtn.selected ?@"静音已开启":@"静音已关闭"];
    }];
    
    [[self.controlView.muteCameraBtn.actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.controlView.muteCameraBtn.actionBtn.selected = !self.controlView.muteCameraBtn.actionBtn.selected;
        self.controlView.muteCameraBtn.type = self.controlView.muteCameraBtn.actionBtn.selected ? StateTypeSelected : StateTypeNormal;
//        [self.rtcEngine muteLocalCamera:self.controlView.muteCameraBtn.actionBtn.selected forTrack:AliRtcVideoTrackCamera];
 
        if (self.controlView.muteCameraBtn.actionBtn.selected) {
            
            //不推流
            [[AliRTCBeaconTower sharedInstance] leaveSeat];
            
//            [self.rtcEngine configLocalCameraPublish:NO];
//            [self.rtcEngine configLocalAudioPublish:YES];
//            [self.rtcEngine configLocalSimulcast:NO forTrack:AliRtcVideoTrackCamera];
//            [self.rtcEngine publish:^(int errCode) {
//                NSLog(@"1-发布结果%d",errCode);
//            }];
            [self beginToastWithString:@"摄像头已关闭"];
        } else {
            //推流
            [[AliRTCBeaconTower sharedInstance] enterSeat];
//            [self.rtcEngine configLocalCameraPublish:YES];
//            [self.rtcEngine configLocalAudioPublish:YES];
//            [self.rtcEngine configLocalSimulcast:YES forTrack:AliRtcVideoTrackCamera];
//            [self.rtcEngine publish:^(int errCode) {
//                NSLog(@"2-发布结果%d",errCode);
//            }];
            [self beginToastWithString:@"摄像头已开启"];
        }
    }];
    
    [[self.controlView.phoneBtn.actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        self.controlView.phoneBtn.actionBtn.selected = !self.controlView.phoneBtn.actionBtn.selected;
        [[AliRTCBeaconTower sharedInstance] enableSpeakPhone:self.controlView.phoneBtn.actionBtn.selected];
        self.controlView.phoneBtn.type = self.controlView.phoneBtn.actionBtn.selected ? StateTypeSelected : StateTypeNormal;
        [self beginToastWithString:self.controlView.phoneBtn.actionBtn.selected ?@"免提已开启":@"免提已关闭"];
    }];
    
    
    [[self.controlView.cameraTurnBtn.actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        [[AliRTCBeaconTower sharedInstance] switchCamera];
    }];
    
    
    [[self.controlView.hangBtn.actionBtn rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(__kindof UIControl * _Nullable x) {
        @strongify(self);
        [self leaveAction];
    }];
    
    //
    self.localView.tapBlock = ^(NSString * _Nonnull uid, RemoteView * _Nonnull remoteView) {
        @strongify(self);
        [self manageLocalAndRemoteTransfer:remoteView uid:uid];
    };
}

- (void)setupUI {
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.tapView];
    [self.view addSubview:self.toastLabel];
    [self.view addSubview:self.controlView];
    [self.view addSubview:self.timeLabel];
    
    self.scrollView.frame = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);

//    [self.scrollView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.left.mas_equalTo(0);
//        make.top.mas_equalTo(0);
//        make.right.mas_equalTo(0);
//        make.bottom.mas_equalTo(0);
//    }];
    
    [self.tapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.bottom.mas_equalTo(0);
        make.top.equalTo(self.scrollView.mas_top).offset(120);
    }];
    
    [self.toastLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.view.mas_centerX);
        make.width.mas_equalTo(180);
        make.height.mas_equalTo(40);
        make.bottom.equalTo(self.timeLabel.mas_top).offset(-12);
    }];
    
    [self.controlView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(0);
        make.bottom.mas_equalTo(-10);
        make.height.mas_equalTo(220);
    }];
    
    [self.timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.mas_equalTo(100);
        make.height.mas_equalTo(25);
        make.centerX.equalTo(self.view.mas_centerX);
        make.bottom.equalTo(self.controlView.mas_top).offset(-15);
    }];
    
    
    
}

- (void)setlocalView {
    [self.scrollView addSubview:self.localView];
    self.localView.isLocal = YES;
    self.localView.nameLabel.text = @"自己";
    self.localView.frame = CGRectMake(0, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
    [[AliRTCBeaconTower sharedInstance]  setLocalViewConfig:self.localView.canvas forTrack:AliRtcVideoTrackCamera];
    [[AliRTCBeaconTower sharedInstance] startPreview];
    
    
    PositionView *view = [[PositionView alloc] init];
    view.nameLabel.text = @"自己";
    view.frame = CGRectMake(off_x, offset_y, remoteWidth, remoteWidth);
    [self.scrollView addSubview:view];
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    [dic setObject:self.localView forKey:@"remoteView"];
    [dic setObject:@"" forKey:@"uid"];
    [self.remoteDataArray addObject:dic];
    
    self.localView.positionView = view;
    self.currentLocalView = self.localView;
}

- (void)initRtcEnging {
    
    
    AliRtcAuthInfo *authInfo = [ChatRoomViewController GenerateAliRtcAuthInfoWithChnnelId:self.channelNumber];
    
    [self beginToastWithString:@"请等待其他人加入"];
    [self.time setFireDate:[NSDate distantPast]];
    self.controlView.muteAudioBtn.type = StateTypeNormal;
    self.controlView.muteCameraBtn.type = StateTypeNormal;
    [self setupUI];
    [self createTapGesture];
    [self setlocalView];
    [self joinChannel:authInfo];
}



+ (AliRtcAuthInfo *)GenerateAliRtcAuthInfoWithChnnelId:(NSString *)channelID {
    NSString *AppID = @"" ;  //修改为自己的appid 该方案仅为开发测试使用，正式上线需要使用服务端的AppServer
    NSString *AppKey = @"";  //修改为自己的appkey 该方案仅为开发测试使用，正式上线需要使用服务端的AppServer
    
    NSString *userID = [NSString stringWithFormat:@"%d%d",(int)[[NSDate new] timeIntervalSince1970],(int)arc4random()];
   
    NSString *nonce = [NSString stringWithFormat:@"AK-%@",[[NSUUID UUID] UUIDString]];
   
    NSTimeInterval interval = 48 * 60 * 60;//48小时时间戳
    NSDate *datenow = [[NSDate date] initWithTimeIntervalSinceNow:interval];//现在时间
    long long timestamp = (long)(long)([datenow timeIntervalSince1970]*1000);
   
    //获取到token
    NSString *token = [NSString stringWithFormat:@"%@%@%@%@%@%lld",AppID,AppKey,channelID,userID,nonce,timestamp];
   
    //将token加密
    const char *s = [token cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *keyData = [NSData dataWithBytes:s length:strlen(s)];
    uint8_t digest[CC_SHA256_DIGEST_LENGTH] = {0};
    CC_SHA256(keyData.bytes, (CC_LONG)keyData.length, digest);
    NSData *out = [NSData dataWithBytes:digest length:CC_SHA256_DIGEST_LENGTH];
    const unsigned *hashBytes = [out bytes];
    NSString *hash = [NSString stringWithFormat:@"%08x%08x%08x%08x%08x%08x%08x%08x",
    ntohl(hashBytes[0]), ntohl(hashBytes[1]), ntohl(hashBytes[2]),
    ntohl(hashBytes[3]), ntohl(hashBytes[4]), ntohl(hashBytes[5]),
    ntohl(hashBytes[6]), ntohl(hashBytes[7])];
    
//    NSString *nonce = [NSString stringWithFormat:@"AK-%@",[[NSUUID UUID] UUIDString]];
//    NSTimeInterval interval = 48 * 60 * 60;//48小时时间戳
//    NSDate *datenow = [[NSDate date] initWithTimeIntervalSinceNow:interval];//现在时间
//    long long timestamp = (long)(long)([datenow timeIntervalSince1970]*1000);
    NSArray *GSLB = @[@"https://rgslb.rtc.aliyuncs.com"];

    NSArray *agent = [NSArray array];
    AliRtcAuthInfo *authInfo = [[AliRtcAuthInfo alloc] init];
    authInfo.appid = AppID;
    authInfo.user_id = userID;
    authInfo.channel = channelID;
    authInfo.nonce = nonce;
    authInfo.timestamp = timestamp;
    authInfo.token = hash;
    authInfo.gslb = GSLB;
    authInfo.agent = agent;
    return authInfo;
}


//
- (void)joinChannel:(AliRtcAuthInfo *)authInfo {
    //加入频道
    @weakify(self);
    [[AliRTCBeaconTower sharedInstance] login:authInfo name:self.userName];
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    self.currentLocalView.frame = CGRectMake(scrollView.contentOffset.x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
}

- (void)alertString:(NSString *)string {
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:string message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        [self leaveAction];
    }];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}

// 被服务器踢出频道的消息
- (void)onBye:(int)code {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertString:@"您被踢出改房间，请退出重试"];
    });
}

- (void)onOccurError:(int)error {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self alertString:[NSString stringWithFormat:@"SDK内部错误，请退出重试 error=%d",error]];
    });
}

- (void)onJoinChannelResult:(int)result authInfo:(AliRtcAuthInfo *)authInfo {
    //开始推流
    if(result == 0) {
        [[AliRTCBeaconTower sharedInstance] enterSeat];
    } else {
        [self alertString:@"入会失败，请退出重试"];
    }
   
}
/**
 * @brief 当远端用户的流发生变化时，返回这个消息
 * @note 远方用户停止推流，也会发送这个消息
 */
- (void)onRemoteTrackAvailableNotify:(NSString *)uid audioTrack:(AliRtcAudioTrack)audioTrack videoTrack:(AliRtcVideoTrack)videoTrack {
    @weakify(self);
    kMainQueue((^{
        @strongify(self);
        __block BOOL find = false;
        __block NSInteger idex;
        __block RemoteView *view;
        [self.remoteDataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
            if ([uid isEqualToString:obj[@"uid"]]) {
                view = obj[@"remoteView"];
                idex = idx;
                find = YES;
                *stop = YES;
            }
        }];
        if (!find || !view) {
            return ;
        }
        if (videoTrack == AliRtcVideoTrackNo) {
            //没有流
            view.screenView.hidden = YES;
            view.remoteView.hidden = YES;
            view.headImageView.hidden = NO;
        } else if (videoTrack == AliRtcVideoTrackCamera) {
            //相机流
            view.screenView.hidden = YES;
            view.remoteView.hidden = NO;
            view.headImageView.hidden = YES;
            
        
            [[AliRTCBeaconTower sharedInstance]  configRemoteCameraTrack:uid preferMaster:view.isLocal enable:YES];
            [[AliRTCBeaconTower sharedInstance] configRemoteScreenTrack:uid enable:YES];
            [[AliRTCBeaconTower sharedInstance] configRemoteAudio:uid enable:YES];
            [[AliRTCBeaconTower sharedInstance] subscribe:uid onResult:^(NSString * _Nonnull uid, AliRtcVideoTrack vt, AliRtcAudioTrack at) {
                
            }];
//            [self.rtcEngine subscribe:uid onResult:^(NSString *uid, AliRtcVideoTrack vt, AliRtcAudioTrack at) {
////                NSLog(@"22222订阅结果 %lu",(unsigned long)vt);
//            }];
            [[AliRTCBeaconTower sharedInstance] setRemoteViewConfig:view.canvas uid:uid forTrack:AliRtcVideoTrackCamera];
//            [self.rtcEngine setRemoteViewConfig:view.canvas uid:uid forTrack:AliRtcVideoTrackCamera];
        } else {
         //共享流 或者 共享+相机流
            view.screenView.hidden = NO;
            view.remoteView.hidden = YES;
            view.headImageView.hidden = YES;
            
            [[AliRTCBeaconTower sharedInstance] configRemoteCameraTrack:uid preferMaster:NO enable:NO];
            [[AliRTCBeaconTower sharedInstance] configRemoteScreenTrack:uid enable:YES];
            [[AliRTCBeaconTower sharedInstance] configRemoteAudio:uid enable:YES];
            [[AliRTCBeaconTower sharedInstance] subscribe:uid onResult:^(NSString *uid, AliRtcVideoTrack vt, AliRtcAudioTrack at) {
//                NSLog(@"11111订阅结果 %lu",(unsigned long)vt);
            }];
            [[AliRTCBeaconTower sharedInstance] setRemoteViewConfig:view.screenCanvas uid:uid forTrack:AliRtcVideoTrackScreen];
        }
//        NSLog(@"视频流改变%lu",(unsigned long)videoTrack);
    }));
}

//- (NSString *)displayName:(NSString *)uid {
//    NSString *displayName = @"";
//    NSString *displayName_utf8 = [self.rtcEngine getUserInfo:uid][@"displayName"];
//
//    if (displayName_utf8) {
//        displayName = [NSString stringWithUTF8String:[displayName_utf8 cString]];
//    }
//    return displayName;
//}


//上线
- (void)onRemoteUserOnLineNotify:(NSString *)uid {
    
    @weakify(self);
    NSString *userName = [[AliRTCBeaconTower sharedInstance] displayName:uid];
    dispatch_async(dispatch_get_main_queue(), ^{
        NSLog(@"用户上线");
        @strongify(self);
        @synchronized (self.remoteDataArray) {
            PositionView *view = [[PositionView alloc] init];
            view.nameLabel.text = userName;
            [self.scrollView addSubview:view];
            
            
            RemoteView *remoteView = [[RemoteView alloc] init];
            remoteView.uid = uid;
            remoteView.frame = CGRectMake(self.remoteDataArray.count * (remoteWidth + offset_x) + off_x, offset_y, remoteWidth, remoteWidth);
            [self.scrollView addSubview:remoteView];
            remoteView.positionView = view;
            view.frame = remoteView.frame;

            remoteView.nameLabel.text = userName;
            NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
            [dic setObject:remoteView forKey:@"remoteView"];
            [dic setObject:uid forKey:@"uid"];
            [self.remoteDataArray addObject:dic];
            
            [self.scrollView setContentSize:CGSizeMake(self.remoteDataArray.count * (remoteWidth + offset_x) + off_x, self.scrollView.frame.size.height)];
            @weakify(self);
            remoteView.tapBlock = ^(NSString * _Nonnull uid, RemoteView * _Nonnull remoteView) {
                @strongify(self);
                [self manageLocalAndRemoteTransfer:remoteView uid:uid];
            };
        }
    });
}

- (void)manageLocalAndRemoteTransfer:(RemoteView *)remoteView uid:(NSString *)uid {
    if (remoteView.isLocal) {
        return;
    }
    //订阅大小流
    if (uid.length > 0) {
        //订阅大流
        [[AliRTCBeaconTower sharedInstance] configRemoteCameraTrack:uid preferMaster:YES enable:YES];
        [[AliRTCBeaconTower sharedInstance] configRemoteScreenTrack:uid enable:YES];
        [[AliRTCBeaconTower sharedInstance] configRemoteAudio:uid enable:YES];
        [[AliRTCBeaconTower sharedInstance] subscribe:uid onResult:^(NSString *uid, AliRtcVideoTrack vt, AliRtcAudioTrack at) {
        }];
    }
    if (self.currentLocalView.uid.length > 0) {
        //订阅小流
        [[AliRTCBeaconTower sharedInstance] configRemoteCameraTrack:uid preferMaster:NO enable:YES];
        [[AliRTCBeaconTower sharedInstance] configRemoteScreenTrack:uid enable:YES];
        [[AliRTCBeaconTower sharedInstance] configRemoteAudio:uid enable:YES];
        [[AliRTCBeaconTower sharedInstance] subscribe:uid onResult:^(NSString *uid, AliRtcVideoTrack vt, AliRtcAudioTrack at) {
        }];
    }
    remoteView.isLocal = YES;
    self.currentLocalView.isLocal = NO;
    self.currentLocalView = remoteView;
    [self remoteLayOut];
}


//下线
- (void)onRemoteUserOffLineNotify:(NSString *)uid {
    
    NSString *userName =  [[AliRTCBeaconTower sharedInstance] displayName:uid];
    dispatch_async(dispatch_get_main_queue(), ^{
        [self beginToastWithString:[NSString stringWithFormat:@"%@已退出频道",userName]];
        @synchronized (self.remoteDataArray) {
            __block BOOL find = false;
            __block NSInteger idex;
            __block RemoteView *view;
            [self.remoteDataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                if ([uid isEqualToString:obj[@"uid"]]) {
                    view = obj[@"remoteView"];
                    idex = idx;
                    find = YES;
                    *stop = YES;
                }
            }];
            if (find && view) {
                [view.positionView removeFromSuperview];
                [view removeFromSuperview];
                [self.remoteDataArray removeObjectAtIndex:idex];
            }
            
            if ([uid isEqualToString:self.currentLocalView.uid]) {
                [self.remoteDataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
                    RemoteView *view = obj[@"remoteView"];
                    
                    view.positionView.frame = CGRectMake((remoteWidth + offset_x)* idx + off_x , offset_y, remoteWidth, remoteWidth);
                    [self.scrollView bringSubviewToFront:view.positionView];
                    
                    if (view.uid.length > 0) {
                        view.isLocal = NO;
                        [self.scrollView bringSubviewToFront:view];
                        view.frame = CGRectMake((remoteWidth + offset_x)* idx + off_x , offset_y, remoteWidth, remoteWidth);
                    } else {
                        view.isLocal = YES;
                        view.frame = CGRectMake(self.scrollView.contentOffset.x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
                        [self.scrollView sendSubviewToBack:view];
                        self.currentLocalView = view;
                    }
                }];
                [self.scrollView setContentSize:CGSizeMake(self.remoteDataArray.count * (remoteWidth + offset_x) + off_x, self.scrollView.frame.size.height)];
                
            } else {
                [self remoteLayOut];
            }
        }
    });
}

//离开频道结果
- (void)onLeaveChannelResult:(int)result {
    NSLog(@"离开频道结果 %d",result);
    dispatch_async(dispatch_get_main_queue(), ^{
        [AliRTCBeaconTower destroySharedInstance];
        [self dismissViewControllerAnimated:YES completion:^{
        }];
    });
}

- (void)remoteLayOut {
    @weakify(self);
    [self.remoteDataArray enumerateObjectsUsingBlock:^(NSDictionary *obj, NSUInteger idx, BOOL * _Nonnull stop) {
        RemoteView *view = obj[@"remoteView"];
        @strongify(self);
        view.positionView.frame = CGRectMake((remoteWidth + offset_x)* idx + off_x , offset_y, remoteWidth, remoteWidth);
        [self.scrollView bringSubviewToFront:view.positionView];
        if (view && !view.isLocal) {
            [self.scrollView bringSubviewToFront:view];
            view.frame = CGRectMake((remoteWidth + offset_x)* idx + off_x , offset_y, remoteWidth, remoteWidth);
            
        } else if (view && view.isLocal) {
            view.frame = CGRectMake(self.scrollView.contentOffset.x, 0, self.scrollView.frame.size.width, self.scrollView.frame.size.height);
            [self.scrollView sendSubviewToBack:view];
        }
    }];
    [self.scrollView setContentSize:CGSizeMake(self.remoteDataArray.count * (remoteWidth + offset_x) + off_x, self.scrollView.frame.size.height)];
}


- (void)beginToastWithString:(NSString *)string {
    if (!string.length) {
        return;
    }
    self.toastLabel.text = string;
    self.toastLabel.alpha = 1;
    self.toastLabel.hidden = NO;
    @weakify(self);
    [UIView animateWithDuration:2 animations:^{
        @strongify(self);
        self.toastLabel.alpha = 0;
    } completion:^(BOOL finished) {
        @strongify(self);
        self.toastLabel.hidden = NO;
    }];
}

- (BottomControlView *)controlView {
    if (!_controlView) {
        _controlView = [[BottomControlView alloc] init];
    }
    return _controlView;
}

- (UILabel *)timeLabel {
    if (!_timeLabel) {
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.textAlignment = NSTextAlignmentCenter;
        _timeLabel.font = kfont(16);
        _timeLabel.textColor = [UIColor whiteColor];
        _timeLabel.text = @"00:00";
    }
    return _timeLabel;
}


- (NSMutableArray *)remoteDataArray {
    if (!_remoteDataArray) {
        _remoteDataArray = [[NSMutableArray alloc] init];
    }
    return _remoteDataArray;
}

- (UIScrollView *)scrollView {
    if (!_scrollView) {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
    }
    return _scrollView;
}

- (UILabel *)toastLabel {
    if (!_toastLabel) {
        _toastLabel = [[UILabel alloc] init];
        _toastLabel.backgroundColor = [UIColor colorWithRed:0/255.0 green:0/255.0 blue:0/255.0 alpha:0.8];
        _toastLabel.textColor = [UIColor whiteColor];
        _toastLabel.textAlignment = NSTextAlignmentCenter;
        _toastLabel.hidden = YES;
        _toastLabel.font = kfont(14);
    }
    return _toastLabel;
}

- (RemoteView *)localView {
    if (!_localView) {
        _localView = [[RemoteView alloc] init];
        _localView.uid = @"";
    }
    return _localView;
}


- (UIView *)tapView {
    if (!_tapView) {
        _tapView = [[UIView alloc] init];
    }
    return _tapView;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
