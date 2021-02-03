package com.aliyun.apsaravideo.sophon.videocall.view;

import android.content.Context;
import android.os.CountDownTimer;
import android.support.annotation.Nullable;
import android.util.AttributeSet;
import android.util.Log;

import com.alirtc.beacontowner.R;


/**
 * 显示时长的组件
 */
public class AlivcTimeTextView extends android.support.v7.widget.AppCompatTextView {
    CountDownTimer mCountDownTimer;
    private long mStartTime = 0;

    public AlivcTimeTextView(Context context) {
        super(context);
        init();
    }

    public AlivcTimeTextView(Context context, @Nullable AttributeSet attrs) {
        super(context, attrs);
        init();
    }

    public AlivcTimeTextView(Context context, @Nullable AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        init();
    }

    private void init() {
        mCountDownTimer = new CountDownTimer(Integer.MAX_VALUE, 1000) {
            @Override
            public void onTick(long millisUntilFinished) {
                show();
                setTime((System.currentTimeMillis() - mStartTime) / 1000);
            }

            @Override
            public void onFinish() {
            }
        };
    }

    private void show() {
        setVisibility(mStartTime == 0 ? GONE : VISIBLE);
    }

    public void start() {
        mStartTime = System.currentTimeMillis();
        mCountDownTimer.start();
    }

    public void stop() {
        mStartTime = 0;
        mCountDownTimer.cancel();

    }

    private void setTime(long timeSeconds) {
        String hours = unitFormat(getHours(timeSeconds));
        String minutes = unitFormat(getMinutes(timeSeconds));
        String seconds = unitFormat(getSeconds(timeSeconds));
        String timeinclude = getResources().getString(R.string.aliyun_time_txt_include_hour, hours, minutes, seconds);
        String time = getResources().getString(R.string.aliyun_time_txt, minutes, seconds);

        this.setText((getHours(timeSeconds) <= 0) ? time : timeinclude);
      //  Log.i("scar", "setTime: " + ((getHours(timeSeconds) <= 0) ? time : timeinclude));
    }

    public static String unitFormat(int i) {
        String retStr = null;
        if (i >= 0 && i < 10) {
            retStr = "0" + Integer.toString(i);
        } else {
            retStr = "" + i;
        }
        return retStr;
    }

    public static int getHours(long timeSeconds) {
        return (int) (timeSeconds / 3600);
    }

    public static int getMinutes(long timeSeconds) {
        return (int) ((timeSeconds % 3600) / 60);
    }

    public static int getSeconds(long timeSeconds) {
        return (int) (timeSeconds % 60);
    }
}
