package com.aliyun.apsaravideo.sophon.utils;

/**
 * 防止快速点击
 */
public class FastClickUtil {

    /**
     * 上次点击的时间
     */
    private  static long mLastClickTime=0;
    /**
     * 快速点击的时间间隔
     */
    private  static int mIntervalTime = 500;

    public static boolean isFastClick(){
        long currentTime = System.currentTimeMillis();
        boolean isAllowClick;
        if(currentTime - mLastClickTime > mIntervalTime){
            isAllowClick = false;
        }else{
            isAllowClick = true;
        }
        mLastClickTime = currentTime;
        return isAllowClick;
    }
}
