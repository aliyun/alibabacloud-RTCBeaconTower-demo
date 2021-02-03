package com.aliyun.apsaravideo.sophon.utils;

import android.content.ClipData;
import android.content.ClipboardManager;
import android.content.Context;
import android.text.TextUtils;
import android.widget.Toast;

/**
 * 字符串工具类
 */
public class StringUtil {

    /**
     * 复制内容到剪贴板
     * @param text
     * @param context
     */
    public static void clipChannelId(String text, Context context) {
        //获取剪贴板管理器：
        ClipboardManager cm = (ClipboardManager) context.getSystemService(Context.CLIPBOARD_SERVICE);
        // 创建普通字符型ClipData
        ClipData mClipData = ClipData.newPlainText("Label", text);
        // 将ClipData内容放到系统剪贴板里。
        cm.setPrimaryClip(mClipData);
        Toast.makeText(context, "已复制会议码: " + text, Toast.LENGTH_SHORT).show();
    }
}
