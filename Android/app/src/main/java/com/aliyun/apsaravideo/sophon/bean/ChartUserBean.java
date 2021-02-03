package com.aliyun.apsaravideo.sophon.bean;

import org.webrtc.sdk.SophonSurfaceView;

public class ChartUserBean {

    public String mUserId;
    public boolean mIsLocal;

    public SophonSurfaceView mCameraSurface;

    public SophonSurfaceView mScreenSurface;

    public String mUserName;
    //是否相机镜像
    public boolean mIsCameraFlip;
    //是否屏幕镜像
    public boolean mIsScreenFlip;

}
