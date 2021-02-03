package com.aliyun.apsaravideo.sophon.rtc;

import com.alivc.rtc.AliRtcEngine;

public interface RTCBeaconTowerCallback {



   /**
    * 用户上线通知
    *
    * @param userId 用户id
    */
   void onRemoteUserOnLineNotify(String userId);

   /**
    * 用户下线通知
    * @param userId 用户id
    */
   void onRemoteUserOffLineNotify(String userId);



    /**
     * 加入房间通知
     * @param result 0为成功 反之失败
     */
    void onJoinChannelResult(int result);


   /**
    *
    * 当订阅情况发生变化时，返回这个消息 onSubscribeChangedNotify
    * @param userId  用户ID
    * @param videoTrack     订阅成功的视频流
    * @param audioTrack     订阅成功的音频流
    */
   void onRemoteTrackAvailableNotify(String userId, AliRtcEngine.AliRtcAudioTrack audioTrack, AliRtcEngine.AliRtcVideoTrack videoTrack);


   /**
    *
    * 订阅结果回调
    * @param userId  用户ID
    * @param videoTrack     订阅成功的视频流
    * @param audioTrack     订阅成功的音频流
    */
   void onSubscribeChangedNotify(String userId, AliRtcEngine.AliRtcAudioTrack audioTrack, AliRtcEngine.AliRtcVideoTrack videoTrack);




    /**
     * 网络状态回调
     *
     * @param aliRtcNetworkQuality1 下行网络质量
     * @param aliRtcNetworkQuality  上行网络质量
     * @param userId                     String  用户ID
     */
   void onNetworkQualityChanged(String userId, AliRtcEngine.AliRtcNetworkQuality aliRtcNetworkQuality, AliRtcEngine.AliRtcNetworkQuality aliRtcNetworkQuality1);


}
