package com.aliyun.apsaravideo.sophon.listener;

import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;
import android.util.Log;

/**
 * EditText 花名内容改变监听
 */
public class TextWatcherListener implements TextWatcher {

    /**
     * 用户可输入的最大花名长度
     */
    public static final int MAX_INPUT_CONENT_LENGTH = 12;

    /**
     *用户可输入的最小花名长度
     */
    public static final int MIN_INPUT_CONENT_LENGTH =2;

    public TextChangeListener mListener;

    public TextWatcherListener(TextChangeListener listener) {
        this.mListener = listener;
    }

    @Override
    public void beforeTextChanged(CharSequence s, int start, int count, int after) {

    }

    @Override
    public void onTextChanged(CharSequence s, int start, int before, int count) {

    }

    @Override
    public void afterTextChanged(Editable s) {
        String content = s.toString();

        if (TextUtils.isEmpty(content) || content.length() > MAX_INPUT_CONENT_LENGTH) {
            if (mListener != null) {
                mListener.onFormatError(TextChangeListener.TYPE_NICK);
            }

        }
        if (content.length() >= MIN_INPUT_CONENT_LENGTH && mListener != null) {
            mListener.onFormatRight(TextChangeListener.TYPE_NICK);

        }
    }
}
