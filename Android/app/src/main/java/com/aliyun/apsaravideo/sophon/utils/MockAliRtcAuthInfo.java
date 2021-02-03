package com.aliyun.apsaravideo.sophon.utils;

import com.alivc.rtc.AliRtcAuthInfo;

import java.security.MessageDigest;
import java.security.NoSuchAlgorithmException;
import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;
import java.util.Random;
import java.util.SimpleTimeZone;
import java.util.UUID;

/**
 * 本地鉴权信息提供类，正式上线时候建议使用服务器下发鉴权信息
 * 目前只支持int类型的uid
 */
public class MockAliRtcAuthInfo {

    public static AliRtcAuthInfo mockAuthInfo(String channelId, String userId){
        String appId = ""; //修改为自己的appid 该方案仅为开发测试使用，正式上线需要使用服务端的AppServer
        String appKey = ""; //修改为自己的appkey 该方案仅为开发测试使用，正式上线需要使用服务端的AppServer
        String nonce = String.format("AK-%s", UUID.randomUUID().toString());
        Calendar nowTime = Calendar.getInstance();
        nowTime.add(Calendar.HOUR_OF_DAY, 48);
        long timestamp = nowTime.getTimeInMillis() / 1000;
        AliRtcAuthInfo aliRtcAuthInfo = new AliRtcAuthInfo();
        try {
            aliRtcAuthInfo.setAppid(appId);
            aliRtcAuthInfo.setConferenceId(channelId);
            aliRtcAuthInfo.setUserId(userId);
            aliRtcAuthInfo.setToken(createToken(appId,appKey,channelId,userId,nonce,timestamp));
            aliRtcAuthInfo.setNonce(nonce);
            aliRtcAuthInfo.setTimestamp(timestamp);
            String[] gslb = new String[]{"https://rgslb.rtc.aliyuncs.com"};
            aliRtcAuthInfo.setGslb(gslb);
        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }
        return aliRtcAuthInfo;
    }
    public static String createUserId(String channelID, String user) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        digest.update(channelID.getBytes());
        digest.update("/".getBytes());
        digest.update(user.getBytes());
        String uid = bin2hex(digest.digest());
        return uid.substring(0, 16);
    }
    //生成随机的房间号
    public static String randomRoom(){
        return String.valueOf((int)((Math.random()*9+1)*100000));
    }

    /*生成当前UTC时间戳Time*/
    public static String generateTimestamp(long expriseTime) {
        Date date = new Date(System.currentTimeMillis() + expriseTime);
        SimpleDateFormat df = new SimpleDateFormat("yyyy-MM-dd'T'HH:mm:ss'Z'");
        df.setTimeZone(new SimpleTimeZone(0, "GMT"));
        return df.format(date);
    }
    public static String createToken(
            String appId, String appKey, String channelId, String userId,
            String nonce, Long timestamp
    ) throws NoSuchAlgorithmException {
        MessageDigest digest = MessageDigest.getInstance("SHA-256");
        digest.update(appId.getBytes());
        digest.update(appKey.getBytes());
        digest.update(channelId.getBytes());
        digest.update(userId.getBytes());
        digest.update(nonce.getBytes());
        digest.update(Long.toString(timestamp).getBytes());
        String token = bin2hex(digest.digest());
        return token;
    }
    static String bin2hex(byte[] data) {
        StringBuilder hex = new StringBuilder(data.length * 2);
        for (byte b : data)
            hex.append(String.format("%02x", b & 0xFF));
        return hex.toString();
    }

}
