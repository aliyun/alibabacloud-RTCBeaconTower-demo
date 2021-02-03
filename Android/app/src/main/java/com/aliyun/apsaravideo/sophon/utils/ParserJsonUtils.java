package com.aliyun.apsaravideo.sophon.utils;



import com.aliyun.apsaravideo.sophon.bean.RTCAuthInfo;
import com.aliyun.apsaravideo.sophon.bean.RTCMeetingInfo;

import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.ArrayList;
import java.util.List;


public class ParserJsonUtils {

    /**
     * 解析login数据源
     *
     * @param result 返回一个RTCAuthInfo
     */
    public static RTCAuthInfo parserLoginJson(String result) {
        RTCAuthInfo rtcAuthInfo = new RTCAuthInfo();
        RTCAuthInfo.RTCAuthInfo_Data rtcAuthInfoData = new RTCAuthInfo.RTCAuthInfo_Data();
        RTCAuthInfo.RTCAuthInfo_Data.RTCAuthInfo_Data_Turn rtcAuthInfoDataTurn = new RTCAuthInfo.RTCAuthInfo_Data.RTCAuthInfo_Data_Turn();

        int server = 0;
        String appid = "";
        String userid = "";
        String nonce = "";
        long timestamp = 0;
        String token = "";
        String key = "";
        String username = "";
        String password = "";
        List<String> list = null;
        try {
            JSONObject jsonObject = new JSONObject(result);

            if (jsonObject.has("server")) {
                server = jsonObject.getInt("server");
            }

            JSONObject responseBody = jsonObject.getJSONObject("data");

            if (responseBody.has("appid")) {
                appid = responseBody.getString("appid");
            }
            if (responseBody.has("userid")) {
                userid = responseBody.getString("userid");
            }
            if (responseBody.has("nonce")) {
                nonce = responseBody.getString("nonce");
            }
            if (responseBody.has("timestamp")) {
                timestamp = responseBody.getLong("timestamp");
            }
            if (responseBody.has("token")) {
                token = responseBody.getString("token");
            }
            if (responseBody.has("key")) {
                key = responseBody.getString("key");
            }

            if (responseBody.has("turn")) {

                JSONObject jsonObject3 = responseBody.getJSONObject("turn");
                if (jsonObject3.has("username")) {
                    username = jsonObject3.getString("username");

                }
                if (jsonObject3.has("password")) {
                    password = jsonObject3.getString("password");
                }
            }
            if (responseBody.has("gslb")) {
                JSONArray jsonArray = responseBody.getJSONArray("gslb");
                list = new ArrayList<>();
                //遍历这个json格式的数组
                for (int i = 0; i < jsonArray.length(); i++) {
                    list.add(jsonArray.getString(i));
                }
            }

            rtcAuthInfo.setServer(server);

            rtcAuthInfoData.setAppid(appid);
            rtcAuthInfoData.setUserid(userid);
            rtcAuthInfoData.setNonce(nonce);
            rtcAuthInfoData.setTimestamp(timestamp);
            rtcAuthInfoData.setToken(token);
            rtcAuthInfoData.setKey(key);
            if (list != null) {
                rtcAuthInfoData.setGslb(list.toArray(new String[list.size()]));
            }

            rtcAuthInfoDataTurn.setUsername(username);
            rtcAuthInfoDataTurn.setPassword(password);

            rtcAuthInfoData.setTurn(rtcAuthInfoDataTurn);

            rtcAuthInfo.setData(rtcAuthInfoData);
            return rtcAuthInfo;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return null;
    }
    /**
     * 解析创建会议获取的数据源
     *
     * @param result
     */
    public static RTCMeetingInfo parserMeetingJson(String result) {
        RTCMeetingInfo rtcMeetingInfo = new RTCMeetingInfo();
        RTCMeetingInfo.DataBean dataBean  =new RTCMeetingInfo.DataBean();
        int server = 0;
        int code =0;
        String meetingID ="";
        try {
            JSONObject jsonObject = new JSONObject(result);

            if (jsonObject.has("server")) {
                server = jsonObject.getInt("server");
            }
            if (jsonObject.has("code")) {
                code = jsonObject.getInt("code");
            }
            JSONObject responseBody = jsonObject.getJSONObject("data");

            if (responseBody.has("meetingID")) {
                meetingID = responseBody.getString("meetingID");
            }
            dataBean.setMeetingID(meetingID);
            rtcMeetingInfo.setServer(server);
            rtcMeetingInfo.setCode(code);
            rtcMeetingInfo.setData(dataBean);
            return rtcMeetingInfo;
        } catch (JSONException e) {
            e.printStackTrace();
        }
        return null;
    }
}
