package com.aliyun.apsaravideo.sophon.listener;

import android.text.Editable;
import android.text.TextUtils;
import android.text.TextWatcher;

/**
 * EditText 内容改变监听
 */
public class ChannelTextWatchListener implements TextWatcher {


    /**
     * 用户可输入的最大频道号长度
     */
    public static final int MAX_INPUT_CONENT_LENGTH = 12;

    public TextChangeListener mListener;

    public ChannelTextWatchListener(TextChangeListener listener){
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

        if(!TextUtils.isEmpty(content) && content.length() > MAX_INPUT_CONENT_LENGTH && mListener != null){
            mListener.onFormatError(TextChangeListener.TYPE_CHANNEL);
        }
        if(content.length() <= MAX_INPUT_CONENT_LENGTH && mListener != null){
            mListener.onFormatRight(TextChangeListener.TYPE_CHANNEL);
        }
        if (mListener!=null){
            mListener.onEnableBtn(content);
        }
    }
}
