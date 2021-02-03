package com.aliyun.apsaravideo.sophon.network;


import android.util.Log;


import com.aliyun.apsaravideo.sophon.bean.RTCAuthInfo;
import com.aliyun.apsaravideo.sophon.bean.RTCMeetingInfo;
import com.aliyun.apsaravideo.sophon.utils.AliRtcConstants;
import com.aliyun.apsaravideo.sophon.utils.ParserJsonUtils;
import com.aliyun.apsaravideo.sophon.utils.ThreadUtils;

import java.io.IOException;
import java.util.HashMap;
import java.util.Map;

import okhttp3.Call;
import okhttp3.Callback;
import okhttp3.OkHttpClient;
import okhttp3.Request;
import okhttp3.Response;

/**
 * alirtc服务器返回的包含加入频道信息的业务类
 */
public class RequestRTCAuthInfo {
    public static final String TAG = RequestRTCAuthInfo.class.getSimpleName();

    public static void getAuthInfo(final String userName, final String channelId, final OnRequestAuthInfoListener onRequestAuthInfoListener) {
        HashMap<String, String> hashMap = new HashMap<>();
        hashMap.put("user", userName);
        hashMap.put("room", channelId);
        hashMap.put("passwd", "12345678");
        String base = AliRtcConstants.SERVER_URL;
        String url = getQueryUrl(base, hashMap);

        OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder()
                .url(url)
                .build();

        Call call = client.newCall(request);

        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (onRequestAuthInfoListener != null) {
                            onRequestAuthInfoListener.onFailure("请求失败");
                        }
                    }
                });
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
              //  Log.i(TAG, "onResponse: "+response.body().string());
                final RTCAuthInfo rtcAuthInfo = ParserJsonUtils.parserLoginJson(response.body().string());
                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (rtcAuthInfo != null && onRequestAuthInfoListener != null) {
                            onRequestAuthInfoListener.onObtainAuthInfo(rtcAuthInfo);
                        }
                    }
                });


            }
        });

    }

    public static void getMeetingInfo(final String userName,final OnRequestMeetingListener onRequestMeetingListener) {
        HashMap<String, String> hashMap = new HashMap<>();
        hashMap.put("username", userName);

        String base = AliRtcConstants.CHANNEL_ID_URL;
        String url = getQueryUrl(base, hashMap);

        OkHttpClient client = new OkHttpClient();
        Request request = new Request.Builder()
                .url(url)
                .build();

        Call call = client.newCall(request);

        call.enqueue(new Callback() {
            @Override
            public void onFailure(Call call, IOException e) {
                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (onRequestMeetingListener != null) {
                            onRequestMeetingListener.onFailure("请求失败");
                        }
                    }
                });
            }

            @Override
            public void onResponse(Call call, Response response) throws IOException {
               // Log.i(TAG, "onResponse: "+response.body().string());
                final RTCMeetingInfo rtcMeetingInfo = ParserJsonUtils.parserMeetingJson(response.body().string());
                ThreadUtils.runOnUiThread(new Runnable() {
                    @Override
                    public void run() {
                        if (rtcMeetingInfo != null && onRequestMeetingListener != null) {
                            onRequestMeetingListener.onObtainMeetingInfo(rtcMeetingInfo);
                        }
                    }
                });


            }
        });

    }



    public interface OnRequestMeetingListener {
        void onObtainMeetingInfo(RTCMeetingInfo rtcMeetingInfo);

        void onFailure(String failure);
    }

    private OnRequestMeetingListener onRequestMeetingListener;

    public void setOnRequestMeetingListener(OnRequestAuthInfoListener onRequestAuthInfoListener) {
        this.mOnRequestAuthInfoListener = onRequestAuthInfoListener;
    }


    public interface OnRequestAuthInfoListener {
        void onObtainAuthInfo(RTCAuthInfo rtcAuthInfo);

        void onFailure(String failure);
    }
    private OnRequestAuthInfoListener mOnRequestAuthInfoListener;

    public void setOnRequestAuthInfoListener(OnRequestAuthInfoListener onRequestAuthInfoListener) {
        this.mOnRequestAuthInfoListener = onRequestAuthInfoListener;
    }

    /**
     * 拼接get数据
     *
     * @param url    地址
     * @param params get参数
     * @return
     */
    private static String getQueryUrl(String url, Map<String, String> params) {
        StringBuilder neoUrl = new StringBuilder(url);
        if (params != null) {
            neoUrl.append("?");
            for (Map.Entry<String, String> stringStringEntry : params.entrySet()) {
                neoUrl.append(stringStringEntry.getKey()).append("=").append(stringStringEntry.getValue()).append("&");
            }
            neoUrl = new StringBuilder(neoUrl.substring(0, neoUrl.length() - 1));
        }
        Log.i(TAG, "getQueryUrl: " + neoUrl.toString());
        return neoUrl.toString();
    }
}
