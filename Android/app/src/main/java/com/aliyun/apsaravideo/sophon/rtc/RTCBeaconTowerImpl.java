package com.aliyun.apsaravideo.sophon.rtc;
import android.util.Log;

import com.alivc.rtc.AliRtcAuthInfo;
import com.alivc.rtc.AliRtcEngine;
import com.alivc.rtc.AliRtcEngineEventListener;
import com.alivc.rtc.AliRtcEngineNotify;
import com.alivc.rtc.AliRtcRemoteUserInfo;
import com.aliyun.apsaravideo.sophon.utils.ApplicationContextUtil;
import com.aliyun.apsaravideo.sophon.utils.ThreadUtils;
import static com.alivc.rtc.AliRtcEngine.AliRtcVideoTrack.AliRtcVideoTrackCamera;

public class RTCBeaconTowerImpl extends BaseRTCBeaconTower{
    public AliRtcEngine mAliRtcEngine;
    private static RTCBeaconTowerImpl mInstance;
    private RTCBeaconTowerCallback mRtcBeaconTowerCallback;

    private static final String TAG = RTCBeaconTowerImpl.class.getSimpleName();

    private RTCBeaconTowerImpl() {
        init();
    }
    public void init() {
        if (mAliRtcEngine == null) {
            AliRtcEngine.setH5CompatibleMode(1);
            mAliRtcEngine = AliRtcEngine.getInstance(ApplicationContextUtil.getAppContext());
            mAliRtcEngine.setRtcEngineEventListener(new VideoAliRtcEngineEventListener());
            mAliRtcEngine.setRtcEngineNotify(new VideoAliRtcEngineNotify());
            //手动发布，手动订阅
            mAliRtcEngine.setAutoPublishSubscribe(false, false);
        }
    }

    public AliRtcRemoteUserInfo getUserInfo(String s) {
        if (mAliRtcEngine != null) {
            return mAliRtcEngine.getUserInfo(s);
        }
        return new AliRtcRemoteUserInfo();
    }

    public void enableSpeakerphone(boolean s) {
        if (mAliRtcEngine != null) {
            mAliRtcEngine.enableSpeakerphone(s);
        }
    }

    /**
     * 获取单例
     */
    public static RTCBeaconTowerImpl sharedInstance() {
        if (mInstance == null) {
            synchronized (RTCBeaconTowerImpl.class) {
                mInstance = new RTCBeaconTowerImpl();
            }
        }
        return mInstance;
    }

    /**
     * 销毁当前实例
     */
    @Override
    public void destorySharedInstance() {
        if (mAliRtcEngine != null) {
            mAliRtcEngine.destroy();
            mAliRtcEngine = null;
        }
        mInstance = null;
    }


    public void joinChannel(AliRtcAuthInfo authInfo, String displayName) {
        mAliRtcEngine.joinChannel(authInfo,displayName);
    }
    /**
     * 登出
     */
    @Override
    public void logout() {
        if (mAliRtcEngine != null) {
            mAliRtcEngine.stopPreview();
            mAliRtcEngine.leaveChannel();
        }
    }


    /**
     * 设置播放远端视频流
     */
    @Override
    public void setRemoteViewConfig(AliRtcEngine.AliVideoCanvas aliVideoCanvas, String uid, AliRtcEngine.AliRtcVideoTrack aliRtcVideoTrack) {
        Log.i(TAG, "setRemoteViewConfig: ");
        if (mAliRtcEngine != null) {
            mAliRtcEngine.setRemoteViewConfig(aliVideoCanvas, uid, aliRtcVideoTrack);
        }
    }

    @Override
    public void setDelegate(RTCBeaconTowerCallback callback) {
        mRtcBeaconTowerCallback = callback;
    }


    /**
     * 是否发布本地音频流
     * @return 返回0为切换成功，其他为切换失败
     */
    @Override
    public int muteLocalMic(boolean muteLocalMic) {
        if (mAliRtcEngine != null) {
            return mAliRtcEngine.muteLocalMic(muteLocalMic);
        }
        return -1;
    }

    /**
     * 是否发布本地相机流
     * @return 返回0为切换成功，其他为切换失败
     */
    @Override
    public int muteLocalCamera(boolean isMute) {
        if (mAliRtcEngine != null) {
            return mAliRtcEngine.muteLocalCamera(isMute, AliRtcEngine.AliRtcVideoTrack.AliRtcVideoTrackCamera);
        }
        return -1;
    }


    /**
     * 设置本地预览渲染参数
     * @param localAliVideoCanvas canvas
     * @param aliRtcVideoTrackCamera 类型
     */
    @Override
    public void setLocalViewConfig(AliRtcEngine.AliVideoCanvas localAliVideoCanvas, AliRtcEngine.AliRtcVideoTrack aliRtcVideoTrackCamera) {
        Log.i(TAG, "setLocalViewConfig: ");
        if (mAliRtcEngine != null) {
            mAliRtcEngine.setLocalViewConfig(localAliVideoCanvas, aliRtcVideoTrackCamera);
        }
    }

    /**
     * 切换前后摄像头
     * @return 返回0为切换成功，其他为切换失败
     */
    public int switchCamera() {
        if (mAliRtcEngine != null) {
            return mAliRtcEngine.switchCamera();
        }
        return -1;
    }


    /**
     * 开始预览
     */
    @Override
    public void startPreview() {
        if (mAliRtcEngine != null) {
            mAliRtcEngine.startPreview();
        }
    }


    @Override
    public void stopPreview() {
        if (mAliRtcEngine != null) {
            mAliRtcEngine.stopPreview();
        }
    }

    public void startPublish() {
        if (mAliRtcEngine != null) {
            mAliRtcEngine.configLocalCameraPublish(true);
            mAliRtcEngine.configLocalAudioPublish(true);
            mAliRtcEngine.publish();
        }
    }

    public void stopPublish() {
        if (mAliRtcEngine != null) {
            mAliRtcEngine.configLocalCameraPublish(false);
            mAliRtcEngine.configLocalAudioPublish(false);
            mAliRtcEngine.publish();
        }
    }

    public void configLocalCameraPublish(boolean cameraPublish){
        if (mAliRtcEngine != null) {
            mAliRtcEngine.configLocalCameraPublish(cameraPublish);
            mAliRtcEngine.publish();
        }
    }
    public String[] getOnlineRemoteUsers(){
        if (mAliRtcEngine != null) {
          return mAliRtcEngine.getOnlineRemoteUsers();
        }
        return new String[0];
    }

    /**
     * 设置是否订阅远端相机流。默认为订阅大流，手动订阅时，需要调用subscribe才能生效。
     * @param userId userid
     * @param master true为优先订阅大流，false为订阅次小流。
     * @param enable true为订阅远端相机流，false为停止订阅远端相机流。
     */
    @Override
    public void configRemoteCameraTrack(String userId, boolean master, boolean enable) {
        if (mAliRtcEngine != null) {
            mAliRtcEngine.configRemoteCameraTrack(userId, master, enable);
            // 订阅远端音频流。
            mAliRtcEngine.configRemoteAudio(userId, true);
            // 订阅远端屏幕流。
            mAliRtcEngine.configRemoteScreenTrack(userId, true);
            subscribe(userId);
        }
    }


    @Override
    public void subscribe(String userId) {
        if (mAliRtcEngine != null) {
            mAliRtcEngine.subscribe(userId);
        }
    }

    /**
     * RtcEngine回调监听器
     */
    class VideoAliRtcEngineEventListener extends AliRtcEngineEventListener {
        /**
         * 加入房间返回
         */
        @Override
        public void onJoinChannelResult(int i) {
            Log.d(TAG, "onJoinChatResult " + i);
            ThreadUtils.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    //手动推送音视频流
                    mAliRtcEngine.configLocalCameraPublish(true);
                    mAliRtcEngine.configLocalAudioPublish(true);
                    mAliRtcEngine.configLocalSimulcast(true, AliRtcVideoTrackCamera);
                    mAliRtcEngine.publish();
                    if(mRtcBeaconTowerCallback != null){
                        mRtcBeaconTowerCallback.onJoinChannelResult(i);
                    }
                }
            });

        }

        @Override
        public void onSubscribeChangedNotify(String uid, AliRtcEngine.AliRtcAudioTrack audioTrack, AliRtcEngine.AliRtcVideoTrack videoTrack) {
            super.onSubscribeChangedNotify(uid, audioTrack, videoTrack);
            ThreadUtils.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if(mRtcBeaconTowerCallback != null){
                        enableSpeakerphone(false);
                        mRtcBeaconTowerCallback.onSubscribeChangedNotify(uid,audioTrack,videoTrack);
                    }
                }
            });

        }


    }

    /**
     * SDK事件通知(回调接口都在子线程)
     */
    class VideoAliRtcEngineNotify extends AliRtcEngineNotify {
        /**
         * 当远端用户上线时会返回这个消息
         */
        @Override
        public void onRemoteUserOnLineNotify(String s) {
            Log.i(TAG, "onRemoteUserOnLineNotify: result" + s);
            ThreadUtils.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if(mRtcBeaconTowerCallback != null){
                        mRtcBeaconTowerCallback.onRemoteUserOnLineNotify(s);
                    }
                }
            });
        }

        /**
         * 当远端用户下线时会返回这个消息
         */
        @Override
        public void onRemoteUserOffLineNotify(final String s) {
            ThreadUtils.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    if(mRtcBeaconTowerCallback != null){
                        mRtcBeaconTowerCallback.onRemoteUserOffLineNotify(s);
                    }
                }
            });
        }

        /**
         * 当远端用户的流发生变化时，返回这个消息
         */
        @Override
        public void onRemoteTrackAvailableNotify(final String uid, final AliRtcEngine.AliRtcAudioTrack aliRtcAudioTrack,
                                                 final AliRtcEngine.AliRtcVideoTrack aliRtcVideoTrack) {
            Log.d(TAG, "onRemoteTrackAvailableNotify: result" + uid + "____" + aliRtcAudioTrack + "————" + aliRtcVideoTrack);
            ThreadUtils.runOnUiThread(new Runnable() {
                @Override
                public void run() {
                    //手动订阅流，默认大流
                    configRemoteCameraTrack(uid,true,true);
                    if(mRtcBeaconTowerCallback != null){
                        mRtcBeaconTowerCallback.onRemoteTrackAvailableNotify(uid,aliRtcAudioTrack,aliRtcVideoTrack);
                    }
                }
            });
        }
    }

}
