package com.aliyun.apsaravideo.sophon.utils;

import android.app.Activity;
import android.content.Context;
import android.content.SharedPreferences;

public class SharedPreferenceUtils {
    private static final String SHAREDPRE_FILE = "videocall";
    private static final String USER_INFO = "user_info";

    public static void setUser(Context context, String user) {
        SharedPreferences mySharedPreferences = context.getSharedPreferences(SHAREDPRE_FILE, Activity.MODE_PRIVATE);
        SharedPreferences.Editor editor = mySharedPreferences.edit();
        editor.putString(USER_INFO, user);
        editor.commit();
    }

    public static String getUser(Context context) {
        SharedPreferences sharedPreferences = context.getSharedPreferences(SHAREDPRE_FILE,
                Activity.MODE_PRIVATE);
        String userInfo = sharedPreferences.getString(USER_INFO, "");
        return userInfo;
    }
}
