package com.aliyun.apsaravideo.sophon.utils;

import android.content.Context;

public class DensityUtil {

    public static int dip2px(Context context ,float dp){
        float scale = context.getResources().getDisplayMetrics().density;
        return (int) (dp * scale + 0.5f);
    }

    public static int px2dip(Context context,float px){
        float scale = context.getResources().getDisplayMetrics().density;
        return (int) (px / scale + 0.5f);
    }
}
