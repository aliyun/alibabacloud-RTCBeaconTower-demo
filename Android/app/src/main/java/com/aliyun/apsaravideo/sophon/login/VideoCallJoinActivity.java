package com.aliyun.apsaravideo.sophon.login;

import android.content.Intent;
import android.os.Bundle;
import android.text.TextUtils;
import android.view.Menu;
import android.view.View;
import android.widget.Button;
import android.widget.EditText;
import android.widget.TextView;
import android.widget.Toast;

import com.alirtc.beacontowner.R;
import com.alivc.rtc.AliRtcAuthInfo;
import com.aliyun.apsaravideo.sophon.base.BaseActivity;
import com.aliyun.apsaravideo.sophon.bean.RTCAuthInfo;
import com.aliyun.apsaravideo.sophon.listener.ChannelTextWatchListener;
import com.aliyun.apsaravideo.sophon.listener.TextChangeListener;
import com.aliyun.apsaravideo.sophon.listener.TextWatcherListener;
import com.aliyun.apsaravideo.sophon.utils.MockAliRtcAuthInfo;
import com.aliyun.apsaravideo.sophon.utils.PermissionUtils;
import com.aliyun.apsaravideo.sophon.utils.SpHistoryUtils;
import com.aliyun.apsaravideo.sophon.utils.StringUtil;
import com.aliyun.apsaravideo.sophon.videocall.VideoCallActivity;

import java.security.NoSuchAlgorithmException;

/**
 * 视频通话创建频道界面
 */
public class VideoCallJoinActivity extends BaseActivity implements View.OnClickListener, TextChangeListener {

    private static final String TAG = VideoCallJoinActivity.class.getSimpleName();

    /**
     * 是否展示错误提示
     */
    private static boolean SHOW_ERROR_TIPS = false;


    private Button btnJoinMeeting;
    private Button btnCreateMeeting;
    private TextView titlebarTitle;
    private EditText mEtNickName;
    private EditText etChannel;
    private TextView mTvShowErrorTips;
    private TextWatcherListener mTextWatcherListener;
    private ChannelTextWatchListener mChannelTextWatchListener;

    private PermissionUtils.PermissionGrant mGrant = new PermissionUtils.PermissionGrant() {
        @Override
        public void onPermissionGranted(int requestCode) {
            try {
                Toast.makeText(VideoCallJoinActivity.this, "已获取权限", Toast.LENGTH_SHORT).show();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }

        @Override
        public void onPermissionCancel() {
            try {
                Toast.makeText(VideoCallJoinActivity.this, "未获取权限", Toast.LENGTH_SHORT).show();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    };

    @Override
    protected void initViews(Bundle savedInstanceState) {
        if (!this.isTaskRoot()) {
            finish();
            return;
        }
        checkHadPermissions(mGrant, 1000);

        initView();
    }

    @Override
    protected int getLayoutId() {
        return R.layout.activity_join;
    }

    /**
     * 初始化View
     */
    private void initView() {
        titlebarTitle = findViewById(R.id.titlebar_title);
        btnCreateMeeting = findViewById(R.id.btn_meeting_create);
        btnJoinMeeting = findViewById(R.id.btn_meeting_join);
        mEtNickName = findViewById(R.id.et_nickname);
        etChannel = findViewById(R.id.et_channel_id);
        mTvShowErrorTips = findViewById(R.id.tv_show_error_tips);
        mTextWatcherListener = new TextWatcherListener(this);
        mChannelTextWatchListener = new ChannelTextWatchListener(this);
        mEtNickName.addTextChangedListener(mTextWatcherListener);
        etChannel.addTextChangedListener(mChannelTextWatchListener);
        titlebarTitle.setText(getResources().getString(R.string.aliyun_video_call));

        String etNickNamelStr = mEtNickName.getText().toString();
        if (TextUtils.isEmpty(etNickNamelStr) || etNickNamelStr.length() > TextWatcherListener.MAX_INPUT_CONENT_LENGTH) {
            btnCreateMeeting.setEnabled(false);
        }
        String etChannelStr = etChannel.getText().toString();
        if (TextUtils.isEmpty(etChannelStr) || etChannelStr.length() > TextWatcherListener.MAX_INPUT_CONENT_LENGTH) {
            btnJoinMeeting.setEnabled(false);
        }
    }

    private void startVideoCallActivity(final String channelId, final String userName) {

        //本地生成token
        try {
            AliRtcAuthInfo authInfo =  MockAliRtcAuthInfo.mockAuthInfo(channelId,MockAliRtcAuthInfo.createUserId(channelId,userName));
            RTCAuthInfo info = new RTCAuthInfo();
            RTCAuthInfo.RTCAuthInfo_Data info_data = new RTCAuthInfo.RTCAuthInfo_Data();
            info.data = info_data;
            info.data.appid = authInfo.mAppid;
            info.data.userid = authInfo.mUserId;
            info.data.nonce = authInfo.mNonce;
            info.data.timestamp = authInfo.mTimestamp;
            info.data.token = authInfo.mToken;
            info.data.gslb = authInfo.mGslb;
            info.data.ConferenceId =  authInfo.mConferenceId;
            showAuthInfo(channelId, info, userName);

        } catch (NoSuchAlgorithmException e) {
            e.printStackTrace();
        }


        //网络获取token
        //RequestRTCAuthInfo.getAuthInfo(userName, channelId, new RequestRTCAuthInfo.OnRequestAuthInfoListener() {
        //    @Override
        //    public void onObtainAuthInfo(RTCAuthInfo rtcAuthInfo) {
        //
        //        rtcAuthInfo.data.ConferenceId = channelId;
        //        showAuthInfo(channelId, rtcAuthInfo, userName);
        //    }
        //
        //    @Override
        //    public void onFailure(String failure) {
        //        Toast.makeText(VideoCallJoinActivity.this, failure, Toast.LENGTH_SHORT).show();
        //    }
        //});
    }

    /**
     * 创建会议
     * @param v
     */
    public void createChannel(View v) {
        v.setEnabled(false);
        final String userName = mEtNickName.getText().toString();
        if (TextUtils.isEmpty(userName)) {
            Toast.makeText(this, "请输入用户名", Toast.LENGTH_SHORT).show();
            return;
        }
        //判断网络情况
        //if (!NetWatchdog.hasNet(VideoCallJoinActivity.this)) {
        //    Bundle bundle = new Bundle();
        //    bundle.putString("userName", userName);
        //    //创建会议的时候，channelId为空
        //    bundle.putString("channel", "");
        //    NetWorkErrorActivity.startNetWorkErrorActivity(VideoCallJoinActivity.this, NetWorkErrorActivity.VIDEO_FLAG, bundle);
        //    return;
        //}

        String roomID = MockAliRtcAuthInfo.randomRoom();
        //设置会议码
        etChannel.setText(roomID);
        StringUtil.clipChannelId(roomID, VideoCallJoinActivity.this);
        //保存会议码
        SpHistoryUtils.saveSearchHistory(VideoCallJoinActivity.this,roomID);
        v.setEnabled(true);
        //获取会议码，进入会议
        startVideoCallActivity(roomID, userName);

        //RequestRTCAuthInfo.getMeetingInfo(userName, new RequestRTCAuthInfo.OnRequestMeetingListener() {
        //    @Override
        //    public void onObtainMeetingInfo(RTCMeetingInfo rtcMeetingInfo) {
        //        showProgressDialog(false);
        //        if (rtcMeetingInfo == null) {
        //            return;
        //        }
        //        //设置会议码
        //        etChannel.setText(rtcMeetingInfo.getData().getMeetingID());
        //        StringUtil.clipChannelId(rtcMeetingInfo.getData().getMeetingID(), VideoCallJoinActivity.this);
        //        //保存会议码
        //        SpHistoryUtils.saveSearchHistory(VideoCallJoinActivity.this, rtcMeetingInfo.getData().getMeetingID());
        //        v.setEnabled(true);
        //        //获取会议码，进入会议
        //        startVideoCallActivity(rtcMeetingInfo.getData().getMeetingID(), userName);
        //    }
        //
        //    @Override
        //    public void onFailure(String failure) {
        //        Toast.makeText(VideoCallJoinActivity.this, failure, Toast.LENGTH_SHORT).show();
        //        v.setEnabled(true);
        //    }
        //});
    }

    /**
     * 加入会议
     *
     * @param view
     */
    public void joinChannel(View view) {
        final String userName = mEtNickName.getText().toString();
        final String channelId = etChannel.getText().toString();
        if (TextUtils.isEmpty(userName)) {
            Toast.makeText(this, "请输入昵称", Toast.LENGTH_SHORT).show();
            return;
        }
        if (TextUtils.isEmpty(channelId)) {
            Toast.makeText(this, "请输入会议码", Toast.LENGTH_SHORT).show();
            return;
        }
        //判断网络情况
        //if (!NetWatchdog.hasNet(VideoCallJoinActivity.this)) {
        //    Bundle bundle = new Bundle();
        //    bundle.putString("userName", userName);
        //    //创建会议的时候，channelid为空
        //    bundle.putString("channel", channelId);
        //    NetWorkErrorActivity.startNetWorkErrorActivity(VideoCallJoinActivity.this, NetWorkErrorActivity.VIDEO_FLAG, bundle);
        //    return;
        //}
        //保存会议码
        SpHistoryUtils.saveSearchHistory(VideoCallJoinActivity.this, channelId);
        startVideoCallActivity(channelId, userName);
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
    }

    /**
     * 频道号格式错误的回调
     * 1:花名
     * 2：会议码
     */
    @Override
    public void onFormatError(int type) {
        if (TYPE_NICK == type) {
            btnCreateMeeting.setEnabled(false);
        } else {
            if (!SHOW_ERROR_TIPS) {
                mTvShowErrorTips.setVisibility(View.VISIBLE);
                SHOW_ERROR_TIPS = true;
            }
            btnJoinMeeting.setEnabled(false);
        }
    }

    /**
     * 频道号格式正确的回调
     */
    @Override
    public void onFormatRight(int type) {
        if (TYPE_NICK == type) {
            btnCreateMeeting.setEnabled(true);
        } else {
            if (SHOW_ERROR_TIPS) {
                mTvShowErrorTips.setVisibility(View.GONE);
                SHOW_ERROR_TIPS = false;
            }
            //如果会议码有输入，那么 加入按钮可用，创建会议按钮不可用
            btnJoinMeeting.setEnabled(true);
        }
    }

    /**
     * 如果会议码有输入，那么 加入按钮可用，创建会议按钮不可用
     *
     * @param text
     */
    @Override
    public void onEnableBtn(String text) {
        if (!TextUtils.isEmpty(text)) {
            btnCreateMeeting.setEnabled(false);
        } else {
            btnCreateMeeting.setEnabled(true);
        }
    }

    @Override
    public void onClick(View v) {

        if (v.getId() == R.id.titlebar_back) {
            finish();
        }
    }

    @Override
    public boolean onCreateOptionsMenu(Menu menu) {
        return true;
    }
}
