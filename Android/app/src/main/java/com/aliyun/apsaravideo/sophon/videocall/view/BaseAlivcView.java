package com.aliyun.apsaravideo.sophon.videocall.view;

import android.app.Activity;
import android.content.Context;
import android.util.AttributeSet;
import android.view.View;
import android.widget.RelativeLayout;
import android.widget.Toast;

public abstract class BaseAlivcView extends RelativeLayout{

    public BaseAlivcView(Context context) {
        super(context);
        initView();
    }

    public BaseAlivcView(Context context, AttributeSet attrs) {
        super(context, attrs);
        initView();
    }

    public BaseAlivcView(Context context, AttributeSet attrs, int defStyleAttr) {
        super(context, attrs, defStyleAttr);
        initView();
    }

    protected abstract void initView();

    /**
     * addSubView 添加子view到布局中
     *
     * @param view 子view
     */
    protected void addSubView(View view) {
        LayoutParams params = new LayoutParams(LayoutParams.MATCH_PARENT, LayoutParams.MATCH_PARENT);
        addView(view, params);//添加到布局中
    }

    protected void showToast(final String content){
        ((Activity)getContext()).runOnUiThread(new Runnable() {
            @Override
            public void run() {
                Toast.makeText(getContext(), content, Toast.LENGTH_LONG).show();
            }
        });
    }

}
