package com.aliyun.apsaravideo.sophon.videocall.view;

import android.content.Context;
import android.util.AttributeSet;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.widget.ImageButton;
import android.widget.RelativeLayout;

import com.alirtc.beacontowner.R;


/**
 * 主页按钮点击的View
 */
public class AlivcControlView extends RelativeLayout {

    private boolean btnEnabled = true;
    /**
     * 预览
     */
    private ImageButton btnCameraPreview;
    /**
     * 静音
     */
    private ImageButton imgMute;
    /**
     * 免提
     */
    private ImageButton btnHandsfree;
    /**
     * 切换摄像头
     */
    private ImageButton btnSwitchCamera;

    /**
     * 挂断
     */
    private ImageButton btnHangUp;

    /**
     * 语音模式
     */
    private ImageButton btnVoiceMode;

    /**
     * 记录摄像头选中与否
     */
    private boolean mIsCameraPreview;

    /**
     * 记录镜头翻转与否
     */
    private boolean mIsSwitchCamera;
    private OnControlPanelListener onControlPanelListener;

    public AlivcControlView(Context context) {
        super(context);
        initView();
    }

    public AlivcControlView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initView();
    }

    public AlivcControlView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initView();
    }

    private void initView() {
        LayoutInflater.from(getContext()).inflate(R.layout.aliyun_video_call_control_panel, this, true);
        findAllView();
    }


    private void findAllView() {
        btnCameraPreview = (ImageButton) findViewById(R.id.btn_camera_preview);
        imgMute = (ImageButton) findViewById(R.id.alivc_videocall_img_mute);
        btnHandsfree = (ImageButton) findViewById(R.id.btn_handsfree);
        btnSwitchCamera = (ImageButton) findViewById(R.id.btn_switch_camera);
        btnHangUp = (ImageButton) findViewById(R.id.btn_hang_up);
        btnVoiceMode = (ImageButton) findViewById(R.id.btn_voice_mode);

        btnCameraPreview.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                mIsCameraPreview = !view.isSelected();

                view.setSelected(!view.isSelected());
                onControlPanelListener.onCameraPreview(view.isSelected());
            }
        });
        imgMute.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                view.setSelected(!view.isSelected());
                onControlPanelListener.onMute(view.isSelected());
            }
        });
        btnHandsfree.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                view.setSelected(!view.isSelected());
                onControlPanelListener.onHandsFree(view.isSelected());
            }
        });
        btnSwitchCamera.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                mIsSwitchCamera = !view.isSelected();

                view.setSelected(!view.isSelected());
                onControlPanelListener.onSwitchCamera();
            }
        });
        btnHangUp.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                view.setSelected(!view.isSelected());
                onControlPanelListener.onHangUp();
            }
        });
        btnVoiceMode.setOnClickListener(new OnClickListener() {
            @Override
            public void onClick(View view) {
                view.setSelected(!view.isSelected());
                onControlPanelListener.onVoiceMode();
            }
        });
    }

    /**
     * 设置对外点击事件的监听
     *
     * @param onControlPanelListener
     */
    public void setOnControlPanelListener(OnControlPanelListener onControlPanelListener) {
        this.onControlPanelListener = onControlPanelListener;
    }

    /**
     * 对外暴露的点击事件回调
     */
    public interface OnControlPanelListener {
        void onCameraPreview(boolean bool);

        void onMute(boolean bool);

        void onHandsFree(boolean bool);

        void onSwitchCamera();

        void onHangUp();

        void onVoiceMode();
    }

    /**
     * 设置ImageButton 是否可用
     */
    public void setImageButtonEnabled(boolean enabled) {
        btnCameraPreview.setEnabled(enabled);
        btnVoiceMode.setEnabled(enabled);
        btnEnabled = enabled;
    }

    /**
     * 切换语音模式,改变摄像头和镜头翻转按钮为不可点击
     * 如果之前是选中状态，那么清空选中状态并置为不可点击
     */
    public void switchAudioState(boolean isAudioState) {
        //如果之前选中了做处理，如果之前未选中则不做处理
        if (isAudioState) {
            btnCameraPreview.setSelected(false);
            btnSwitchCamera.setSelected(false);
            //音视频模式，还原按钮状态
        } else {
            btnSwitchCamera.setSelected(mIsSwitchCamera);
            btnCameraPreview.setSelected(mIsCameraPreview);
        }

        btnCameraPreview.setEnabled(!isAudioState);
        btnSwitchCamera.setEnabled(!isAudioState);

    }

    public boolean getImageButtonEnabled() {
        return btnEnabled;
    }

}
