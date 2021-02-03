<template>
    <div class="rtc-demo" :class="isFullScreen ? 'fullScreen' : ''">
        <div class="header" v-show="$store.state.data.classNum"><span @click="hCopy" id="channel">会议码：{{$store.state.data.classNum}}</span><span>&nbsp;昵称：{{$store.state.data.userName}}</span></div>
        <div class="container">
            <div class="container-box">
                <!-- <div v-if="toastVideo!==''" class="toast-video">{{toastVideo}}<span @click="toastVideo=''">x</span></div> -->
                <div class="center-avatar">{{$store.state.data.classNum}}</div>
                <video :class="{'transform':!$store.state.data.isSwitchScreen}" id="localVideo" autoplay></video>
                <!-- <i @click="myFullscreen" :style="!this.isFullScreen ? 'background-image:url('+ fullUrl +')' : 'background-image:url('+ fullOnUrl +')'"></i> -->
            </div>
            <div class="container-memberVideo" :class="showSlide ? 'showright' : 'hideright'">
                <div class="memberContainer">
                    <div v-show="isFullScreen" class="memberTab" @click="showSlide=!showSlide"><i class="iconfont" :class="!showSlide? 'icon-zuobian' : 'icon-youbian'"></i></div>
                    <div class="member-content">
                        <userlist></userlist>
                    </div>
                </div>
            </div>
        </div>
        <div class="footer">
            <div class="logo">
                <i class="iconfont icon-rtcyinshipintongxin"></i><span>音视频通信</span>
            </div>
            <div class="function">
                <div class="mic">
                    <i @click="muteLocalMic" :style="this.audio ? 'background-image:url('+ micUrl +')' : 'background-image:url('+ micOnUrl +')'"></i>
                    <span>静音</span>
                </div>
                <div class="camera">
                    <i @click="muteLocalCamera" :style="this.video ? 'background-image:url('+ cameraUrl +')' : 'background-image:url('+ cameraOnUrl +')'"></i>
                    <span>摄像头</span>
                </div>
                <div class="off">
                    <i @click="leaveShadow = true" :style="'background-image:url('+ offUrl +')'"></i>
                    <span>离开会议</span>
                </div>
                <div class="screenShare">
                    <i @click="publishScreen" :style="!this.$store.state.data.isPublishScreen ? 'background-image:url('+ screenUrl +')' : 'background-image:url('+ screenOnUrl +')'"></i>
                    <span>共享屏幕</span>
                </div>
                <div class="muteAll">
                    <i @click="muteAll" :style="!this.muteAllState ? 'background-image:url('+ muteAllUrl +')' : 'background-image:url('+ muteAllOnUrl +')'"></i>
                    <span>全员静音</span>
                </div>
            </div>
            <div class="nsetting">
                <el-popover placement="top" width="247" trigger="click">
                    <div>
                        <span style="font-size: 12px">下次加入会议自动触发</span>
                        <br>
                        <hr>
                        <br>
                        <span style="margin-right:20px">打开自己的麦克风</span>
                        <el-switch active-color="#016EFF" v-model="preSetMic">
                        </el-switch>
                        <br>
                        <br>
                        <span style="margin-right:20px">打开自己的摄像头</span>
                        <el-switch active-color="#016EFF" v-model="preSetCamera">
                        </el-switch>
                    </div>
                    <i slot="reference" :style="'background-image:url('+ settingUrl +')'"></i>
                </el-popover>
                <span>设置</span>
            </div>
        </div>
        <div v-show="leaveShadow" class="shadow">
            <div class="leaveShadow">
                <p>你想要结束会议吗？</p>
                <div>
                    <span @click="leaveShadow = false">取消</span>
                    <span class="goBack" @click="goBack">结束会议</span>
                </div>
            </div>
        </div>
    </div>
</template>

<script>
    import RTCClient from "../../core/rtc-client";
    import Utils from "../../core/utils/utils";
    import offUrl from '../../assets/icon/off.png';
    import micUrl from '../../assets/icon/mic.png';
    import micOnUrl from '../../assets/icon/mic-on.png';
    import cameraUrl from '../../assets/icon/camera.png';
    import cameraOnUrl from '../../assets/icon/camera-on.png';
    import screenUrl from '../../assets/icon/screen.png';
    import screenOnUrl from '../../assets/icon/screen-on.png';
    import muteAllUrl from '../../assets/icon/muteall.png';
    import muteAllOnUrl from '../../assets/icon/muteall-on.png';
    import fullUrl from '../../assets/icon/full.png';
    import fullOnUrl from '../../assets/icon/full-on.png';
    import settingUrl from '../../assets/icon/setting.png';
    import micListUrl from '../../assets/icon/micList.png';
    import micListOffUrl from '../../assets/icon/micList-off.png';
    export default {
        data() {
            return {
                audio: true,
                video: true,
                leaveShadow: false, //离开窗口
                isFullScreen: false, //全屏状态
                // toastVideo: "", //主窗口顶部显示信息
                showSlide: true, //全屏状态侧边显示状态
                muteAllState: false, //全员静音状态
                offUrl: offUrl,
                micUrl: micUrl,
                micOnUrl: micOnUrl,
                cameraUrl: cameraUrl,
                cameraOnUrl: cameraOnUrl,
                screenUrl: screenUrl,
                screenOnUrl: screenOnUrl,
                muteAllUrl: muteAllUrl,
                muteAllOnUrl: muteAllOnUrl,
                fullUrl: fullUrl,
                fullOnUrl: fullOnUrl,
                settingUrl: settingUrl,
                micListUrl: micListUrl,
                micListOffUrl: micListOffUrl,
                preSetMic: true, //预设麦克风
                preSetCamera: true //预设摄像头
            };
        },
        created() {},
        mounted() {
            this.$nextTick(() => {
                window.rtcClient = RTCClient.instance;
                this.init();
            });
        },
        methods: {
            // 初始化 开启预览
            init() {
                this.registerCallBack();
                RTCClient.instance.setAutoPublishSubscribe(true, true);
                RTCClient.instance.login(this.$store.state.data.classNum, this.$store.state.data.userName).then(userId => {
                    if (RTCClient.instance.getRoomUserList().length === 0) {
                        this.$message("当前只有你一个人，你可以点击页面顶部【复制会议码】给其他参会人员");
                    }
                    hvuex({
                        isSwitchScreen:false,
                        userId: userId,
                        isPublish: true,
                    }).then(() => {
                        Utils.startPreview(document.getElementById(userId)).then(re => {
                            RTCClient.instance.setDisplayLocalVideo(document.getElementById("localVideo"), 1)
                        });
                    });
                }).catch(err => {
                    this.$message(err.message);
                })
            },
            // 注册回调
            registerCallBack() {
                RTCClient.instance.registerCallBack((eventName, data) => {
                    switch (eventName) {
                        case "onJoin":
                        case "onPublisher":
                        case "onUnPublisher":
                        case "onNotify":
                            hvuex({
                                userList: RTCClient.instance.getRoomUserList()
                            });
                            break;
                        case "onSubscribeResult":
                            Utils.showRemoteVideo(data);
                            break;
                        case "onUserVideoMuted":
                            break;
                        case "onUserAudioMuted":
                            break;
                        case "onError":
                            Utils.showErrorMsg(data);
                            break;
                        case "onBye":
                            Utils.onByeMessage(data);
                            break;
                        case "onLeave":
                            hvuex({
                                userList: RTCClient.instance.getRoomUserList()
                            });
                            break;
                    }
                });
            },
            // 离会返回
            goBack() {
                Utils.exitRoom();
            },
            // 控制本地麦克风采集
            muteLocalMic() {
                if (!this.$store.state.data.isPublish) {
                    this.$message("未推流");
                    return
                }
                RTCClient.instance.muteLocalMic(!this.audio);
                this.audio = !this.audio;
            },
            // 摄像头禁止
            muteLocalCamera() {
                if (!this.$store.state.data.isPublish) {
                    this.$message("未推流");
                    return
                }
                RTCClient.instance.muteLocalCamera(document.getElementById("localVideo")).then(re=>{
                    RTCClient.instance.setDisplayLocalVideo(document.getElementById(RTCClient.instance.userId));
                })
                this.video = !this.video;
            },
            // 推屏幕流
            publishScreen() {
                if (!this.$store.state.data.isPublish) {
                    Util.toast("未推流");
                    return false;
                }
                if (this.$store.state.data.isPublishScreen) {
                    RTCClient.instance
                        .stopPublishScreen()
                        .then(re => {
                            hvuex({
                                isPublishScreen: false
                            });
                        })
                        .catch(err => {});
                } else {
                    RTCClient.instance
                        .startPublishScreen()
                        .then(() => {
                            hvuex({
                                isPublishScreen: true
                            });
                        })
                        .catch(err => {});
                }
            },
            // 点击会议码事件 复制会议码
            hCopy() {
                this.$message(Utils.hCopy("channel") ? "会议码已复制" : "")
            },
            // 全员静音开/关
            muteAll() {
                this.muteAllState = !this.muteAllState
                if (this.muteAllState) {
                    RTCClient.instance.muteAllRemoteAudioPlaying(true);
                    this.$message("当前全员已静音");
                } else {
                    RTCClient.instance.muteAllRemoteAudioPlaying(false);
                    this.$message("全员静音已关闭");
                }
            },
        },
        watch: {
            /**
             * 监听预设麦克风
             */
            preSetMic(n, o) {
                window.localStorage.removeItem("preSetMic");
                window.localStorage.setItem("preSetMic", this.preSetMic);
            },
            /**
             * 监听预设摄像头
             */
            preSetCamera(n, o) {
                window.localStorage.removeItem("preSetCamera");
                window.localStorage.setItem("preSetCamera", this.preSetCamera);
            }
        }
    };
</script>

<style lang="scss">
    .rtc-demo {
        .header {
            position: absolute;
            top: 0;
            left: 0;
            height: 40px;
            font-size: 16px;
            color: #fff;
            background: #016EFF;
            width: 100%;
            text-align: center;
            line-height: 40px;
            #channel {
                user-select: text;
                -webkit-user-select: text;
                -moz-user-select: text;
                -ms-user-select: text;
                cursor: pointer;
            }
        }
        .container {
            position: absolute;
            display: flex;
            width: 100%;
            bottom: 113px;
            top: 40px;
            background: #f8f8f8;
            .container-box {
                width: calc(100% - 218px);
                height: 100%;
                position: relative;
                background: #2F2F2F;
                .toast-video {
                    width: 100%;
                    height: 50px;
                    background: rgba(0, 0, 0, .8);
                    position: absolute;
                    top: 0;
                    line-height: 50px;
                    color: #FFFFFF;
                    font-size: 16px;
                    padding-left: 30px;
                    z-index: 1;
                    span {
                        padding: 0 10px;
                        position: absolute;
                        right: 10px;
                        cursor: pointer;
                    }
                }
                .center-avatar {
                    width: 100px;
                    height: 100px;
                    position: absolute;
                    left: 50%;
                    top: 50%;
                    margin-left: -50px;
                    margin-top: -50px;
                    font-size: 30px;
                    font-weight: 800;
                    color: #fff;
                    border-radius: 50%;
                    background: #016EFF;
                    text-align: center;
                    line-height: 100px;
                }
                video {
                    width: 100%;
                    height: 100%;
                    background: transparent;
                    position: relative;
                }
                i {
                    width: 36px;
                    height: 36px;
                    position: absolute;
                    right: 35px;
                    bottom: 35px;
                    display: inline-block;
                    background-repeat: no-repeat;
                    background-position: center center;
                    cursor: pointer;
                }
            }
            .container-memberVideo {
                .memberContainer {
                    width: 209px;
                    height: 100%;
                    padding: 10px 13px;
                    background: #fff;
                    .member-title {
                        display: flex;
                        border-bottom: 1px solid #C0C0C0;
                        margin-bottom: 2px;
                        li {
                            font-size: 14px;
                            height: 44px;
                            width: 50%;
                            line-height: 44px;
                            text-align: center;
                            position: relative;
                            display: inline-block;
                            cursor: pointer;
                            i {
                                position: absolute;
                                left: 0;
                                bottom: -1px;
                                height: 2px;
                                width: 100%;
                                background: #0079F2;
                            }
                        }
                    }
                    .member-content {
                        height: calc(100% - 65px);
                    }
                }
            }
        }
        .footer {
            position: absolute;
            bottom: 0;
            left: 0;
            height: 113px;
            width: 100%;
            background: #f8f8f8;
            display: flex;
            justify-content: space-between;
            .logo {
                display: flex;
                align-items: center;
                margin-left: 7px;
                i {
                    font-size: 40px;
                    margin: 0 5px;
                }
                span {
                    font-size: 16px;
                }
            }
            .function {
                display: flex;
                div {
                    margin: 0 13px;
                    display: flex;
                    flex-direction: column;
                    justify-content: center;
                    align-items: center;
                    i {
                        width: 120px;
                        height: 48px;
                        border-radius: 24px;
                        background-color: #E5E5E5;
                        margin-bottom: 12px;
                        cursor: pointer;
                        background-repeat: no-repeat;
                        background-position: center center;
                    }
                    span {
                        font-size: 15px;
                        color: #2F2F2F;
                    }
                }
                .off {
                    i {
                        background-color: #F5222D;
                    }
                }
            }
            .nsetting {
                visibility: hidden;
                margin-right: 34px;
                display: flex;
                flex-direction: column;
                justify-content: center;
                align-items: center;
                i {
                    width: 32px;
                    height: 32px;
                    display: block;
                    background-repeat: no-repeat;
                    background-position: center center;
                    margin-bottom: 12px;
                    cursor: pointer;
                }
            }
        }
        .shadow {
            width: 100%;
            height: 100%;
            position: fixed;
            .leaveShadow {
                width: 308px;
                height: 216px;
                position: fixed;
                z-index: 100;
                top: 50%;
                left: 50%;
                transform: translate(-50%, -50%);
                background: #ffffff;
                border-radius: 8px;
                padding: 65px 30px 36px;
                display: flex;
                flex-direction: column;
                justify-content: space-between;
                p {
                    text-align: center;
                    color: #111111;
                }
                div {
                    display: flex;
                    justify-content: space-between;
                }
                span {
                    width: 111px;
                    height: 40px;
                    border: 1px solid rgba(0, 0, 0, 0.76);
                    border-radius: 2.5px;
                    display: inline-block;
                    text-align: center;
                    line-height: 40px;
                    cursor: pointer;
                }
                .goBack {
                    border: none;
                    color: #ffffff;
                    background: #3296FA;
                }
            }
        }
        .screenToast {
            width: 288px;
            height: 91px;
            background: #111;
            opacity: 0.9;
            position: fixed;
            left: 50%;
            margin-left: -144px;
            top: 12px;
            border-radius: 4px;
            display: flex;
            align-items: center;
            justify-content: center;
            z-index: 2;
            i {
                width: 18px;
                height: 18px;
                background: red;
                border-radius: 50%;
                margin-right: 16px;
            }
            span {
                color: #fff;
                font-size: 20px;
            }
        }
    }
    .fullScreen {
        .header {
            display: none;
        }
        .container {
            top: 0;
            bottom: 0;
            .container-box {
                width: 100%;
                i {
                    bottom: 148px;
                }
            }
            .container-memberVideo {
                position: absolute;
                right: 0;
                .memberContainer {
                    height: 420px;
                    top: 15%;
                    .memberTab {
                        width: 24px;
                        height: 72px;
                        position: absolute;
                        right: 209px;
                        border-width: 12px;
                        border-color: transparent #ffffff transparent transparent;
                        border-style: solid;
                        top: 42%;
                        float: left;
                        cursor: pointer;
                        i {
                            line-height: 48px;
                            font-weight: 800;
                        }
                    }
                }
            }
            .hideright {
                .memberContainer {
                    position: fixed;
                    right: -209px;
                }
            }
            .showright {
                .memberContainer {
                    position: fixed;
                    right: 0;
                }
            }
        }
    }
    .transform {
        transform: rotateY(180deg);
        -webkit-transform: rotateY(180deg);
        -moz-transform: rotateY(180deg);
    }
</style>
