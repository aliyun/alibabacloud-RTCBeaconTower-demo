// import 'aliyun-webrtc-sdk';
import Http from "./http/http";
export default class RTCClient {
    constructor() {
        this._clinet = new AliRtcEngine();
        this._handleEvents();
        this._clinet.setChannelProfile(0);
        this._channel = null;
        this._userName = null;
        this._userId = null;
        this._callBack = null; // 回调 
        this._isInCall = false;// 是否在频道里
        this._isPublish = false;// 是否推流
        this._isAudioOnlyMode = false;// 是否是纯音频模式
        this._autoPublish = true;// 自动推流
        this._autoSubscribe = true;// 自动订阅
        this._isPreview = false;// 是否开启了预览
        this._isScreenSharePreview = false; //是否开启了屏幕分享预览
        this._isMuteLocalMic = false; //
        this._isMuteLocalCamera = false; //
        this._currentRole = 0; // 默认当前角色是主播
        this._clinet.enableHighDefinitionPreview(false);
        this._remoteStreamList = [];
        this._localScreenStream = null; // 保存屏幕流 meadiaStream
        this._localCameraStream = null; // 保存相机流 meadiaStream
        this._userMuteInfo = {};// {userId:{isAudioMute:false,isVideoMute:false}};
        /**
         * 默认参数
         */
        this._clinet.setVideoProfile({
            width: 640,
            height: 480,
            frameRate: 15,
            maxBitrate: 100*1000
        }, 1);
        this._clinet.setVideoProfile({
            width: 1920,
            height: 1080,
            frameRate: 10,
            maxBitrate: 1500000
        }, 2);
    }
    /**
     * 获取实例
     */
    static get instance() {
        if (!RTCClient._instance) {
            RTCClient._instance = new RTCClient();
        }
        return RTCClient._instance;
    }
    /**
     * 获取是否在频道中
     */
    get isInCall() {
        return this._isInCall;
    }
    /**
    * 获取是否在推流
    */
    get isPublish() {
        return this._isPublish;
    }
    /**
    * 获取自己的userName
    */
    get userName() {
        return this._userName;
    }
    /**
    * 获取自己的userid
    */
    get userId() {
        return this._userId;
    }
    /**
    * 获取自己的channel
    */
    get channel() {
        return this._channel;
    }
    /**
    * 获取预览状态
    */
    get isPreview() {
        return this._isPreview;
    }
    /**
     * 获取屏幕分享状态
     */
    get isScreenSharePreview (){
        return this._isScreenSharePreview;
    }
    /**
     * 获取是否mute  视频
     */
    get isMuteLocalCamera() {
        return this._isMuteLocalCamera;
    }
    /**
     * 获取是否mute  音频
     */
    get isMuteLocalMic() {
        return this._isMuteLocalMic;
    }
    /**
     * 获取当前角色
     */
    get currentRole() {
        return this._currentRole;
    }

    /**
     * 获取屏幕分享流
     */
    get screenStream(){
        return this._localScreenStream;
    }
    /**
     * 设置是否允许发布音频流（默认为允许发布音频流）
     */
    set configLocalAudioPublish(enable) {
        this._clinet.configLocalAudioPublish = enable;
    }
    /**
     * 设置是否允许发布相机流（默认为允许发布相机流）
     */
    set configLocalCameraPublish(enable) {
        this._clinet.configLocalScreenPublish = enable;
    }
    /**
     * 设置是否允许发布屏幕共享流
     */
    set configLocalScreenPublish(enable) {
        this._clinet.configLocalScreenPublish = enable;
    }
    /**
     * 获取设备信息
     */
    async getDevices() {
        return this._clinet.getDevices();
    }
    /**
     * 检测浏览器是否支持RTC SDK
     */
    async isSuppert() {
        return this._isSuppert();
    }
    /**
     * 指定摄像头
     * @param {*} deviceId 
     */
    currentCamera(deviceId) {
        this._clinet.currentCamera = {
            deviceId: deviceId
        }
    }
    /**
     * 指定麦克风
     * @param {*} deviceId 
     */
    currentAudioCapture(deviceId) {
        this._clinet.currentAudioCapture = {
            deviceId: deviceId
        }
    }
    /**
     * 获取用户信息
     * @param {*} userId 
     */
    getUserInfo(userId) {
        return this._clinet.getUserInfo(userId);
    }
    /**
     * 注册回调
     */
    registerCallBack(callback) {
        this._callBack = callback;
    }
    /**
     * 设置是否自动推流是否自动订阅
     * @param {boolean} autoPub 
     * @param {boolean} autoSub 
     * @return {boolean} 
     */
    setAutoPublishSubscribe(autoPub, autoSub) {
        if (!this._isInCall) {
            this._autoPublish = autoPub;
            this._autoSubscribe = autoSub;
            return true;
        }
        return false;
    }
    /**
     * 设置纯音频模式还是音视频模式(默认为音视频模式)
     * @param {*} boolean
     * @return {boolean}  
     */
    setAudioOnlyMode(boolean) {
        if (!this._isInCall) {
            this._isAudioOnlyMode = boolean;
            return true;
        }
        return false;
    }
    /**
     * 设置角色
     * @param {*} role 
     */
    setClientRole(role) {
        this._clinet.setClientRole(role);
        if(!this.isInCall){
            this._currentRole = role;
        }
    }
    /**
     * 加入房间
     */
    login(channel,userName) {
        return new Promise((resolve, reject) => {
            this._isSuppert().then(() => {
                this._getAuthInfo(channel,userName).then(authInfo => {
                    this._clinet.joinChannel(authInfo, userName).then((re) => {
                        this._isInCall = true;
                        this._executeAutoPublish().then(res => {
                            resolve(authInfo.userid);
                        }).catch(err => {
                            reject(err);
                        })
                    }).catch(err => {
                        reject(err);
                        console.error(err);
                    })
                })
            })
        })
    }
    /**
     * 上麦
     */
    enterSeat(){
        this._clinet.setClientRole(0);
    }
    /**
     * 下麦
     */
    leavelSeat(){
        this.unPublish().then(()=>{
            this._clinet.setClientRole(1);
        }).catch(err=>{
            this._callBack("onLeaveSeatResult", err);
        })
    }
    /**
    * 预览
    * @param {*} video
    */
    startPreview(video) {
        return new Promise((resolve, reject) => {
            this._clinet.startPreview(video).then(() => {
                this._isPreview = true;
                setTimeout(()=>{
                    this._localCameraStream = video.srcObject;
                    resolve();
                },10)
            }).catch(err => {
                reject(err);
                console.error(err);
            })
        })
    }
    /**
     * 开启屏幕分享预览
     * @param {*} video 
     */
    startScreenSharePreview(video) {
        return new Promise((resolve, reject) => {
            this._clinet.startScreenSharePreview(video).then(() => {
                this._isScreenSharePreview = true;
                setTimeout(()=>{
                    this._localScreenStream = video.srcObject;
                    resolve();
                },10)
            }).catch(err => {
                reject(err);
                console.error(err,video);
            })
        })
    }
    /**
    * 停止预览
    */
    stopPreview() {
        return new Promise((resolve, reject) => {
            this._clinet.stopPreview().then(() => {
                this._isPreview = false;
                resolve();
            }).catch(err => {
                reject(err);
                console.error(err);
            })
        })
    }
    /**
     * 停止屏幕分享预览
     */
    stopScreenSharePreview() {
        return new Promise((resolve, reject) => {
            if(this._isScreenSharePreview){
                this._clinet.stopScreenSharePreview().then(() => {
                    this._isScreenSharePreview = false;
                    resolve();
                }).catch(err => {
                    reject(err);
                    console.error(err);
                })
            }else{
                resolve();
            }
        })
    }
    /**
     * 仅推音频流
     */
    publishOnlyAudio() {
        this._clinet.configLocalAudioPublish = true;
        this._clinet.configLocalCameraPublish = false;
        this._clinet.configLocalScreenPublish = false;
        return new Promise((resolve, reject) => {
            this._publish().then(re => {
                resolve(re)
            }).catch(err => {
                console.error(err);
                reject(err);
            })
        })
    }
    /**
     * 默认推音频流+相机流
     */
    publish() {
        this._clinet.configLocalAudioPublish = true;
        this._clinet.configLocalCameraPublish = true;
        return new Promise((resolve, reject) => {
            this._publish().then(re => {
                resolve(re)
            }).catch(err => {
                console.error(err);
                reject(err);
            })
        })
    }
    /**
     * 共享屏幕
     */
    startPublishScreen() {
        return new Promise((resolve, reject) => {
            if (this._clinet.isSupportScreenShare()) {
                this._clinet.configLocalScreenPublish = true;
                this._publish().then(re => {
                    resolve(re);
                }).catch(err => {
                    console.error(err);
                    reject(err);
                })
            } else {
                reject({ type: null, code: null, errorCode: null, message: "screen sharing is not supported", data: {}, description: "" });
            }
        });
    }
    /**
    * 停止共享屏幕
    */
    stopPublishScreen() {
        return new Promise((resolve, reject) => {
            this._clinet.configLocalScreenPublish = false;
            // if(this._isScreenSharePreview){
            //     this.stopScreenSharePreview();
            // }
            this._publish().then(re => {
                resolve(re);
            }).catch(err => {
                console.error(err);
                reject(err);
            })
        });
    }
    /**
     * 停止推流
     */
    unPublish() {
        return new Promise((resolve, reject) => {
            this._clinet.configLocalAudioPublish = false;
            this._clinet.configLocalCameraPublish = false;
            this._clinet.configLocalScreenPublish = false;
            this._publish().then(re => {
                resolve(re);
            }).catch(err => {
                console.error(err);
                reject(err);
            })
        })
    }
    /**
    * 设置是否订阅远端音频
    * @param {*} userId 
    * @param {*} enable 
    */
    configRemoteAudio(userId, enable) {
        this._clinet.configRemoteAudio(userId, enable);
    }
    /**
    * 设置是否订阅远端相机流
    * @param {*} userId 
    * @param {*} preferMaster true为优先订阅大流，false为优先订阅次小流。
    * @param {*} enable 
    */
    configRemoteCameraTrack(userId, preferMaster, enable) {
        this._clinet.configRemoteCameraTrack(userId, preferMaster, enable);
    }
    /**
     * 设置是否订阅远端屏幕流
     * @param {*} userId 
     * @param {*} enable 
     */
    configRemoteScreenTrack(userId, enable) {
        this._clinet.configRemoteScreenTrack(userId, enable);
    }
    /**
     * 订阅 内部判断是否有屏幕流，有屏幕流的话订阅屏幕流
     * @param {*} userId 
     */
    subscribe(userId) {
        return new Promise((resolve, reject) => {
            let arr = this._getPublishInfo(userId);
            if (arr.indexOf('sophon_video_screen_share') > -1) {
                this.subscribeScreen(userId).then(re => {
                    resolve(2);
                })
            } else {
                this.configRemoteScreenTrack(userId, false);
                this.configRemoteCameraTrack(userId, false, true);// 优先订阅小流
                this._subscribe(userId).then(re => {
                    resolve(1);
                }).catch(err => {
                    reject(err);
                    console.error(err);
                });
            }
        })
    }
    /**
     * 只订阅音频
     * @param {*} userId 
     */
    subscribeOnlyAudio(userId) {
        return new Promise((resolve, reject) => {
            this._clinet.configRemoteCameraTrack(userId, false, false);
            this._clinet.configRemoteScreenTrack(userId, false);
            this._subscribe(userId).then(re => {
                resolve(1);
            }).catch(err => {
                reject(err);
                console.error(err);
            })
        })
    }
    /**
     * 订阅大流（如果有屏幕流，优先订阅屏幕流）
     * @param {*} userId 
     */
    subscribeLarge(userId) {
        return new Promise((resolve, reject) => {
            let arr = this._getPublishInfo(userId);
            if (arr.indexOf('sophon_video_screen_share') > -1) {
                this.subscribeScreen(userId).then(re => {
                    resolve(2);
                })
            } else {
                this.configRemoteScreenTrack(userId, false);
                this.configRemoteCameraTrack(userId, true, true);// 优先订阅大流
                this._subscribe(userId).then(re => {
                    resolve(1);
                }).catch(err => {
                    reject(err);
                    console.error(err);
                });
            }
        })
    }
    /**
    * 订阅 屏幕流
    * @param {*} userId 
    */
    subscribeScreen(userId) {
        this.configRemoteScreenTrack(userId, true);
        return new Promise((resolve, reject) => {
            this._subscribe(userId).then(re => {
                resolve(re);
            }).catch(err => {
                reject(err);
                console.error(err);
            });
        })
    }
    /**
     * 为本地的视频设置渲染窗口以及绘制参数
     * @param {*} video 
     * @param {*} streamType 
     */
    setDisplayLocalVideo(video, streamType = 1){
        streamType == 1 ? video.srcObject = this._localCameraStream:this._localScreenStream;
    }
    /**
     * 为远端的视频设置渲染窗口以及绘制参数
     * @param {*} userId 
     * @param {*} video 
     * @param {*} streamType 
     */
    setDisplayRemoteVideo(userId, video, streamType) {
        this._clinet.setDisplayRemoteVideo(userId, video, streamType);
    }
    /**
     * 是否停止本地视频采集
     * @param {*} video
     * @return {boolean}
     */
    muteLocalCamera(video) {
        return new Promise((resolve, reject) => {
            if (this._clinet.muteLocalCamera(!this._isMuteLocalCamera)) {
                this._isMuteLocalCamera = !this._isMuteLocalCamera;
                if (this._isMuteLocalCamera) {
                    this.stopPreview().then(re => {
                        resolve();
                    }).catch(err => {
                        reject(err);
                    });
                } else {
                    this.startPreview(video).then(re => {
                        resolve();
                    }).catch(err => {
                        reject(err);
                    });;
                }
            } else {
                reject();
            }
        });
    }
    /**
     * 停止推相机流
     */
    muteLocalCameraPublish() {
        return new Promise((resolve, reject) => {
            this._clinet.configLocalCameraPublish = false;
            if (this._isMuteLocalCamera) {
                this._clinet.configLocalCameraPublish = true;
            }
            this._publish().then(re => {
                this._isMuteLocalCamera = !this._isMuteLocalCamera;
                if (this._isMuteLocalCamera) {
                    this.stopPreview().then(() => {
                        resolve(true);
                    });
                } else {
                    this.startPreview().then(() => {
                        resolve(true);
                    });
                }
            }).catch(err => {
                reject(err);
            })
        })
    }
    /**
    * 是否停止本地音频采集
    * @return {boolean} 
    */
    muteLocalMic() {
        if (this._clinet.muteLocalMic(!this._isMuteLocalMic)) {
            this._isMuteLocalMic = !this._isMuteLocalMic;
            return true;
        } else {
            return false;
        }
    }
    /**
     * 设置是否停止播放远端音频流
     * @param {*} userId 
     * @param {*} muted 
     */
    muteRemoteAudioPlaying(userId, muted) {
        this._clinet.muteRemoteAudioPlaying(userId, muted);
    }
    /**
     * 设置是否停止远端的所有音频流的播放   
     * @param {*} muted 
     */
    muteAllRemoteAudioPlaying(muted) {
        this._clinet.muteRemoteAudioPlaying(muted);
    }
    /**
     * 获取远端用户在线列表
     */
    getRoomUserList() {
        return this._clinet.getUserList();
    }
    /**
     * 离开频道
     */
    logout() {
        return new Promise((resolve, reject) => {
            if (this._isScreenSharePreview) {
                this.stopScreenSharePreview();
            }
            if (this._isPreview) {
                this.configLocalScreenPublish = false;
                this.stopPreview();
                this._clinet.leaveChannel().then(re => {
                    this._isInCall = false;
                    this._isPublish = false;
                    this._isMuteLocalCamera = false;
                    this._isMuteLocalMic = false;
                    resolve();
                }).catch(err => {
                    console.error(err);
                    reject(err);
                })
            } else {
                this._clinet.leaveChannel().then(re => {
                    this._isInCall = false;
                    this._isPublish = false;
                    this._isMuteLocalCamera = false;
                    this._isMuteLocalMic = false;
                    resolve();
                }).catch(err => {
                    console.error(err);
                    reject(err);
                })
            }
        })
    }
    /**
     * 检查
     */
    _isSuppert() {
        return new Promise((resolve, reject) => {
            this._clinet.isSupport().then((re) => {
                resolve(re);
            }).catch(err => {
                this._showErrorMsg(err);
                console.error(err);
                reject(err);
            })
        })
    }
    /**
     * 执行自动推流
     */
    _executeAutoPublish() {
        return new Promise((resolve, reject) => {
            if (this._autoPublish) {
                if (this._isAudioOnlyMode) {
                    this.publishOnlyAudio().then(re => {
                        resolve();
                    }).catch(err => {
                        reject(err);
                        console.error(err);
                    })
                } else {
                    this.publish().then((res) => {
                        resolve();
                    }).catch(err => {
                        reject(err);
                        console.error(err);
                    })
                }
            } else {
                resolve();
            }
        })
    }
    /**
     * 执行自动订阅
     * @param {object} publisher
     */
    _executeAutoSubscribe(publisher) {
        if (this._autoSubscribe) {
            if (this._isAudioOnlyMode) {
                this.subscribeOnlyAudio(publisher.userId).then(code => {
                    if (this._callBack) {
                        console.warn("onSubscribeResult",{ userId: publisher.userId, code: code });
                        this._callBack("onSubscribeResult", { userId: publisher.userId, code: code });
                    }
                })
            } else {
                this.subscribe(publisher.userId).then((code) => {
                    if (this._callBack) {
                        console.warn("onSubscribeResult",{ userId: publisher.userId, code: code });
                        this._callBack("onSubscribeResult", { userId: publisher.userId, code: code });
                    }
                })
            }
        }
    }
    /**
     * 调用sdk推流
     */
    _publish() {
        return new Promise((resolve, reject) => {
            this._clinet.publish().then(() => {
                if (!this._clinet.configLocalAudioPublish && !this._clinet.configLocalCameraPublish && !this._clinet.configLocalScreenPublish) {
                    this._isPublish = false;
                    this._isMuteLocalCamera = false;
                    this._isMuteLocalMic = false;
                    resolve(false);
                } else {
                    this._isPublish = true;
                    resolve(true);
                }
            }).catch(err => {
                reject(err);
            })
        })
    }
    /**
     * 调用sdk 订阅
     * @param {*} userId 
     */
    async _subscribe(userId) {
        return this._clinet.subscribe(userId);
    }
    /**
     * 检查订阅状况
     * @param {*} userId 
     * @return {boolean}
     */
    _checkSubscribeState(userId) {
        let streamConfigs = this.getUserInfo(userId).streamConfigs;
        let arr = streamConfigs.filter(v => { return v.subscribed });
        if (arr.length > 0) {
            return true;
        } else {
            return false;
        }
    }
    /**
     * 根据userId获取推流情况
     * @param {*} userId 
     */
    _getPublishInfo(userId) {
        console.warn('getPublishInfo:', userId);
        let arr = [];
        let streamConfigs = this.getUserInfo(userId);
        if (streamConfigs && streamConfigs.streamConfigs) {
            streamConfigs = streamConfigs.streamConfigs;
            streamConfigs.forEach(v => {
                if (v.state == "active") {
                    arr.push(v.label);
                }
            })
        } else {
        }
        console.warn('getPublishInfo:', arr)
        return arr;
    }
    /**
     * 获取鉴权信息
     */
    _getAuthInfo(channel,userName) {
        return new Promise((resolve, reject) => {
            Http.getAuthInfo(channel, userName).then(authInfo => {
                this._userId = authInfo.userid;
                this._channel = channel;
                this._userName = userName;
                resolve(authInfo);
            }).catch(err => {
                reject(err)
            })
        })
    }
    /**
     * 删除用户mute状态
     * @param {*} userId 
     */
    _deleteUserMuteState(userId) {
        if (this._userMuteInfo[userId]) {
            this._userMuteInfo[userId].isAudioMute = false;
            this._userMuteInfo[userId].isVideoMute = false;
            delete this._userMuteInfo[userId];
            this._deleteUserMuteState();
        }
    }
    /**
     * 处理用户muteAudio通知
     * @param {*} data 
     */
    _executeAutoMute(data) {
        if (this._userMuteInfo[data.userId]) {
            // 判断是否改变
            data.streamConfigs.forEach(v => {
                if (v.label == "sophon_audio") {
                    if (this._userMuteInfo[data.userId].isAudioMute !== v.muted) {
                        this._userMuteInfo[data.userId].isAudioMute = v.muted;
                        this._callBack("onUserAudioMuted", { userId: data.userId, mute: v.muted });
                    }
                }
            })
        } else {
            // 加上 并判断muted 是否是true 
            this._userMuteInfo[data.userId] = { isAudioMute: false, isVideoMute: false };
            data.streamConfigs.forEach(v => {
                if (v.label == "sophon_audio") {
                    this._userMuteInfo[data.userId].isAudioMute = v.muted;
                }
            })
            if (this._userMuteInfo[data.userId].isAudioMute) {
                this._callBack("onUserAudioMuted", { userId: data.userId, mute: this._userMuteInfo[data.userId].isAudioMute });
            }
        }
    }
     /**
     * 处理用户muteVideo通知
     * @param {*} data 
     */
    _executeVideoMute(data) {
        if (this._userMuteInfo[data.userId]) {
            // 判断是否改变
            data.streamConfigs.forEach(v => {
                if (v.label == "sophon_video_camera_large") {
                    if (this._userMuteInfo[data.userId].isVideoMute !== v.muted) {
                        this._userMuteInfo[data.userId].isVideoMute = v.muted;
                        this._callBack("onUserVideoMuted", { userId: data.userId, mute: v.muted });
                    }
                }
            })
        } else {
            // 加上 并判断muted 是否是true 
            this._userMuteInfo[data.userId] = { isAudioMute: false, isVideoMute: false };
            data.streamConfigs.forEach(v => {
                if (v.label == "sophon_video_camera_large") {
                    this._userMuteInfo[data.userId].isVideoMute = v.muted;
                }
            })
            if (this._userMuteInfo[data.userId].isVideoMute) {
                this._callBack("onUserVideoMuted", { userId: data.userId, mute: this._userMuteInfo[data.userId].isVideoMute });
            }
        }
    }
    /**
     * 回调
     */
    _handleEvents() {
        /**
        * 远端用户上线通知
        */
        this._clinet.on("onJoin", (data) => {
            console.warn("onJoin", data);
            if (this._callBack) {
                this._callBack("onJoin", data);
            }
        })
        /**
        * 远端用户推流通知
        */
        this._clinet.on("onPublisher", (publisher) => {
            console.warn("onPublisher", publisher);
            this._executeAutoSubscribe(publisher);
            if (this._callBack) {
                this._callBack("onPublisher", publisher);
            }
        })
        /**
        * 远端用户停止推流通知
        */
        this._clinet.on("onUnPublisher", (publisher) => {
            console.warn("onUnPublisher", publisher);
            if (this._checkSubscribeState(publisher.userId)) {
                // this._clinet.unSubscribe(publisher.userId);
            }
            if (this._callBack) {
                this._callBack("onUnPublisher", publisher);
            }
        })
        /**
         * 本地或远端用户的推流状态变化，muteLocalMic，muteLocalCamera操作时会收到回调
         * 返回data为getUserList调用的结果
         */
        this._clinet.on("onNotify", (data) => {
            console.warn("onNotify",data);
            data.forEach(v => {
                if (this._userId != v.userId) {
                    this._executeAutoMute(v);
                    this._executeVideoMute(v);
                }
            })
            if (this._callBack) {
                this._callBack("onNotify", data);
            }
        })
        /**
         * 角色切换回调
         */
        this._clinet.on("onUpdateRole", (data) => {
            console.warn(data);
            this._currentRole = data.newRole;
            if(this._currentRole == 0){
                this.publish().then((re)=>{
                    this._callBack("onEnterSeatResult", 0);
                }).catch(err=>{
                    this._callBack("onEnterSeatResult", err);
                });
            } else {
                this._callBack("onLeaveSeatResult", 0);
            }
            if (this._callBack) {
                this._callBack("onUpdateRole", data);
            }
        })
        /**
         * 错误信息
         */
        this._clinet.on("onError", (error) => {
            console.error('onError', error);
            if (this._callBack) {
                try {
                    switch (error.errorCode){
                        case 10012:
                            this._isScreenSharePreview = false;
                            break;
                    }
                } catch (error) {
                    
                }
                this._callBack("onError", error);
            }
        })
        /**
         * 被服务器踢出或者频道关闭时回调
         */
        this._clinet.on("onBye", (data) => {
            console.warn("onBye", data);
            this._isInCall = false;
            this._isPublish = false;
            this.stopScreenSharePreview();
            if (this._callBack) {
                this._callBack("onBye", data.code);
            }
        })
        /**
         * 远端离开频道回调
         */
        this._clinet.on("onLeave", (data) => {
            console.warn("onLeave", data);
            if (this._callBack) {
                this._callBack("onLeave", data);
            }
        })
    }
    /**
     * 显示错误信息
     * @param {*} err 
     */
    _showErrorMsg(error) {
        if (this._callBack) {
            this._callBack("onError", error);
        }
        console.error(error);
    }
}