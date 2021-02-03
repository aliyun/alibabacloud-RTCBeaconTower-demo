package com.aliyun.apsaravideo.sophon.listener;

import android.view.View;

public interface TextChangeListener {

    int TYPE_NICK =1;
    int TYPE_CHANNEL =2;
        /**
         * 格式错误
         */
        void onFormatError(int i);

        /**
         * 格式正确
         */
        void onFormatRight(int i);

    /**
     * 创建会议按钮是否可以点击
     * @param text
     */
    void onEnableBtn(String text);

}
