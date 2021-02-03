package com.aliyun.apsaravideo.sophon.login;

import android.content.Context;
import android.content.Intent;
import android.os.Bundle;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.text.TextUtils;
import android.util.Log;
import android.view.View;
import android.widget.Button;
import android.widget.ImageView;
import android.widget.TextView;
import android.widget.Toast;

import com.aliyun.apsaravideo.sophon.utils.NetWatchdog;
import com.aliyun.apsaravideo.sophon.videocall.VideoCallActivity;
import com.alirtc.beacontowner.R;
import com.aliyun.apsaravideo.sophon.bean.RTCAuthInfo;
import com.aliyun.apsaravideo.sophon.bean.RTCMeetingInfo;
import com.aliyun.apsaravideo.sophon.network.RequestRTCAuthInfo;


/**
 * 网络异常Activity
 */
public class NetWorkErrorActivity extends AppCompatActivity implements NetWatchdog.NetConnectedListener,
        View.OnClickListener {

    /**
     * 视频通话
     */
    public static final int VIDEO_FLAG = 0;
    /**
     * 网络重连是否成功
     */
    public static boolean NET_RE_CONNECTED_SUCCESS = false;
    private int flag;
    private TextView mTitleBarTitle;
    private Button mBtnRetry;
    private ImageView mTitleBarBack;
    private NetWatchdog netWatchdog;
    private String userName;
    private String channelId;

    /**
     * 跳转到网络异常Activity
     *
     * @param context    context
     * @param flag       是视频通话还是语音通话
     */
    public static void startNetWorkErrorActivity(Context context, int flag, Bundle realIntent) {
        Intent intent = new Intent(context, NetWorkErrorActivity.class);
        intent.putExtra("flag", flag);
        intent.putExtra("bundle", realIntent);
        context.startActivity(intent);
    }

    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(R.layout.activity_net_work_error);
        flag = getIntent().getIntExtra("flag", 0);
        Bundle bundle = getIntent().getBundleExtra("bundle");
        if (bundle != null) {
            userName = bundle.getString("userName");
            channelId = bundle.getString("channel");
        }
        initView();
        initNetWork();

    }

    /**
     * 初始化View
     */
    private void initView() {
        mTitleBarTitle = findViewById(R.id.titlebar_title);
        mBtnRetry = findViewById(R.id.btn_retry);
        mTitleBarBack = findViewById(R.id.titlebar_back);
        mTitleBarBack.setOnClickListener(this);
        mBtnRetry.setOnClickListener(this);
        mTitleBarTitle.setText(flag == VIDEO_FLAG ?
                getResources().getString(R.string.aliyun_video_call) : getResources().getString(R.string.aliyun_audio_call));
    }

    /**
     * 创建会议
     */
    private void createChannel() {
        RequestRTCAuthInfo.getMeetingInfo(userName, new RequestRTCAuthInfo.OnRequestMeetingListener() {
            @Override
            public void onObtainMeetingInfo(RTCMeetingInfo rtcMeetingInfo) {
                if (rtcMeetingInfo == null) {
                    return;
                }
                //获取会议码，进入会议
                startVideoCallActivity(rtcMeetingInfo.getData().getMeetingID(), userName);
            }

            @Override
            public void onFailure(String failure) {
            }
        });
    }

    /**
     * 加入会议
     *
     * @param channelId
     * @param userName
     */
    private void startVideoCallActivity(final String channelId, final String userName) {
        Log.d("scar", "startVideoCallActivity: "+channelId+"————"+userName );
        RequestRTCAuthInfo.getAuthInfo(userName, channelId, new RequestRTCAuthInfo.OnRequestAuthInfoListener() {
            @Override
            public void onObtainAuthInfo(RTCAuthInfo rtcAuthInfo) {

                rtcAuthInfo.data.ConferenceId = channelId;
                showAuthInfo(channelId, rtcAuthInfo, userName);
            }

            @Override
            public void onFailure(String failure) {
            }
        });
    }

    /**
     * 网络获取加入频道信息
     *
     * @param rtcAuthInfo
     */
    public void showAuthInfo(String channelId, RTCAuthInfo rtcAuthInfo, String userName) {
        Intent intent = new Intent(this, VideoCallActivity.class);
        Bundle b = new Bundle();
        //用户名
        b.putString("username", userName);
        //频道号
        b.putString("channel", channelId);
        //音频播放
        b.putSerializable("rtcAuthInfo", rtcAuthInfo);
        intent.putExtras(b);
        startActivity(intent);
        finish();
    }


    /**
     * 初始化网络监测
     */
    private void initNetWork() {
        if (netWatchdog == null) {
            netWatchdog = new NetWatchdog(this);
            netWatchdog.setNetConnectedListener(this);
            netWatchdog.startWatch();
        }
    }

    /**
     * 网络已连接
     */
    @Override
    public void onReNetConnected(boolean isReconnect) {
        NET_RE_CONNECTED_SUCCESS = true;
    }

    /**
     * 网络未连接
     */
    @Override
    public void onNetUnConnected() {
        NET_RE_CONNECTED_SUCCESS = false;
    }

    /**
     * retry
     */
    private void reConnected() {
        if (NET_RE_CONNECTED_SUCCESS) {
            if (userName!= null) {
                //channelid空的时候是创建会议，否则是加入会议
                if (TextUtils.isEmpty(channelId)) {
                    createChannel();
                } else {
                    startVideoCallActivity(channelId, userName);
                }
            } else {
                finish();
            }
        } else {
            Toast.makeText(this, getResources().getString(R.string.aliyun_net_connect_error), Toast.LENGTH_SHORT).show();
        }
    }

    @Override
    public void onClick(View v) {
        int onClickViewId = v.getId();
        if (onClickViewId == R.id.titlebar_back) {
            finish();
        } else if (onClickViewId == R.id.btn_retry) {
            reConnected();
        }
    }

    @Override
    protected void onDestroy() {
        super.onDestroy();
        if (netWatchdog != null) {
            netWatchdog.setNetConnectedListener(null);
            netWatchdog.stopWatch();
        }
    }
}
