package com.aliyun.apsaravideo.sophon.rtc;



import com.alivc.rtc.AliRtcEngine;

public abstract class BaseRTCBeaconTower {


    /**
     * 获取单例
     */
    public static RTCBeaconTowerImpl sharedInstance() {
        return RTCBeaconTowerImpl.sharedInstance();
    }

    /**
     * 销毁实例
     */
    public abstract void destorySharedInstance();



    /**
     * 登出
     */
    public abstract void logout();



    /**
     * 停止发布音频
     */
    public abstract int muteLocalMic(boolean isMute);


    /**
     * 停止发布视频
     */
    public abstract int muteLocalCamera(boolean isMute);


    /**
     * 设置本地预览渲染参数
     */
    public abstract void setLocalViewConfig(AliRtcEngine.AliVideoCanvas localAliVideoCanvas, AliRtcEngine.AliRtcVideoTrack aliRtcVideoTrackCamera);


    /**
     * 开启预览
     */
    public abstract void startPreview();


    /**
     * 停止预览
     */
    public abstract void stopPreview();


    /**
     * 设置是否订阅远端相机流。默认为订阅大流。当对流进行操作时（如手动订阅，关闭订阅），必须调用subscribe才能生效
     */
    public abstract void configRemoteCameraTrack(String userId, boolean master, boolean enable);


    /**
     * 订阅。
     */
    public abstract void subscribe(String userId);


    /**
     * 设置远端渲染参数。
     */
    public abstract void setRemoteViewConfig(AliRtcEngine.AliVideoCanvas aliVideoCanvas, String uid, AliRtcEngine.AliRtcVideoTrack aliRtcVideoTrack);


    /**
     * 设置监听。
     */
    public abstract void setDelegate(RTCBeaconTowerCallback callback);




}

