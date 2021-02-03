package com.aliyun.apsaravideo.sophon.utils;

import android.text.TextUtils;

import java.util.regex.Matcher;
import java.util.regex.Pattern;

/**
 * 正则匹配规则类
 */
public class PatternUtils {

    /**
     *channelID命名要求：字符内容只允许[A-Za-z0-9_]，长度限制64字节，非法命名系统将拒绝提供服务。
     * @param channelId 频道号
     */
    public static boolean isValidChannelId(String channelId){
        Pattern pattern;
        if (TextUtils.isEmpty(channelId)){
            return false;
        }
        pattern = Pattern.compile("[0-9A-Za-z_]*");
        Matcher matcher =pattern.matcher(channelId);
        return matcher.matches();
    }
}
