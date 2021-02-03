package com.aliyun.apsaravideo.sophon.base;

import android.app.ProgressDialog;
import android.content.Intent;
import android.os.Bundle;
import android.os.Handler;
import android.support.annotation.NonNull;
import android.support.annotation.Nullable;
import android.support.v7.app.AppCompatActivity;
import android.view.View;

import com.aliyun.apsaravideo.sophon.utils.PermissionUtils;



public abstract class BaseActivity extends AppCompatActivity {

    private PermissionUtils.PermissionGrant mGrant;

    protected ProgressDialog mProgressDialog;


    @Override
    protected void onCreate(@Nullable Bundle savedInstanceState) {
        super.onCreate(savedInstanceState);
        setContentView(getLayoutId());

        initViews(savedInstanceState);
    }

    protected abstract void initViews(Bundle savedInstanceState);

    protected abstract int getLayoutId();

    @Override
    protected void onDestroy() {
        super.onDestroy();
    }


    protected  <T extends View> T f(int resId) {
        return (T) super.findViewById(resId);
    }


    private void requestPermission(){
        PermissionUtils.requestMultiPermissions(this,
                new String[]{
                        PermissionUtils.PERMISSION_CAMERA,
                        PermissionUtils.PERMISSION_WRITE_EXTERNAL_STORAGE,
                        PermissionUtils.PERMISSION_RECORD_AUDIO,
                        PermissionUtils.PERMISSION_READ_EXTERNAL_STORAGE}, mGrant);
    }

    @Override
    public void onRequestPermissionsResult(int requestCode, @NonNull String[] permissions, @NonNull int[] grantResults) {
        if(requestCode == PermissionUtils.CODE_MULTI_PERMISSION){
            PermissionUtils.requestPermissionsResult(this, requestCode, permissions, grantResults, mGrant);
        }else{
            super.onRequestPermissionsResult(requestCode, permissions, grantResults);
        }
    }

    @Override
    protected void onActivityResult(int requestCode, int resultCode, Intent data) {
        super.onActivityResult(requestCode, resultCode, data);
        if(requestCode == PermissionUtils.REQUEST_CODE_SETTING){
            new Handler().postDelayed(new Runnable() {
                @Override
                public void run() {
                    BaseActivity.this.requestPermission();
                }
            }, 500);

        }

    }


    public void checkHadPermissions(PermissionUtils.PermissionGrant grant, int delay) {
        this.mGrant = grant;
        requestPermission();
    }

    protected void showProgressDialog(boolean isShow) {
        if (isShow && mProgressDialog != null && !mProgressDialog.isShowing()) {
            mProgressDialog.show();
        } else if (isShow && mProgressDialog == null) {
            mProgressDialog = new ProgressDialog(this);
            mProgressDialog.setCanceledOnTouchOutside(false);
            mProgressDialog.setCancelable(false);
            //mProgressDialog.setMessage("登陆中...");
            mProgressDialog.show();
        } else if (!isShow && mProgressDialog != null) {
            mProgressDialog.dismiss();
        }
    }
}
