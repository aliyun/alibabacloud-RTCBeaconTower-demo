package com.aliyun.apsaravideo.sophon.videocall.adapter;

import android.support.v7.widget.RecyclerView;
import android.support.v7.widget.SwitchCompat;
import android.text.TextUtils;
import android.util.Log;
import android.view.LayoutInflater;
import android.view.View;
import android.view.ViewGroup;
import android.view.ViewParent;
import android.widget.FrameLayout;
import android.widget.ImageView;
import android.widget.LinearLayout;
import android.widget.TextView;

import com.alirtc.beacontowner.R;
import com.aliyun.apsaravideo.sophon.bean.ChartUserBean;

import java.util.ArrayList;
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;

public class ChartUserAdapter extends BaseRecyclerViewAdapter<ChartUserAdapter.ChartViewHolder> {

    private List<String> mList = new ArrayList<>();
    private Map<String, ChartUserBean> mMap = new LinkedHashMap<>();

    @Override
    public ChartViewHolder onCreateViewHolder(ViewGroup parent, int viewType) {
        View rootView = LayoutInflater.from(parent.getContext()).inflate(R.layout.chart_content_userlist_item, parent, false);

        return new ChartViewHolder(rootView);
    }

    @Override
    public void onBindViewHolder(ChartViewHolder holder, int position) {
        holder.mScreenLayout.setVisibility(View.GONE);
        if (mList.isEmpty()) {
            return;
        }
        ChartUserBean item = mMap.get(mList.get(position));
        //如果没有surface则不显示
        holder.mSurfaceContainer.removeAllViews();
        holder.mScreenSurfaceContainer.removeAllViews();
        if (item == null) {
            return;
        }
        Log.e("scar", "onBindViewHolder: " + item.mUserName + "__" + position + item.mCameraSurface);
        if (item.mCameraSurface != null && null == item.mScreenSurface) {
            holder.mVideoLayout.setVisibility(View.VISIBLE);
            //如果老的surfaceview还在之前的viewtree中，需要先移除
            ViewParent parent = item.mCameraSurface.getParent();
            if (parent != null) {
                if (parent instanceof FrameLayout) {
                    ((FrameLayout) parent).removeAllViews();
                }
                holder.mSurfaceContainer.removeAllViews();
            }
            item.mCameraSurface.setZOrderOnTop(true);
            holder.mSurfaceContainer.addView(item.mCameraSurface, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
            item.mCameraSurface.setZOrderMediaOverlay(true);

        }
        holder.mUsernameTv.setText(item.mUserName);

        if (item.mScreenSurface != null) {
            holder.mVideoLayout.setVisibility(View.INVISIBLE);
            //如果老的surfaceview还在之前的viewtree中，需要先移除
            holder.mScreenLayout.setVisibility(View.VISIBLE);
            ViewParent parent = item.mScreenSurface.getParent();
            if (parent != null) {
                if (parent instanceof FrameLayout) {
                    ((FrameLayout) parent).removeAllViews();
                }
                holder.mScreenSurfaceContainer.removeAllViews();
            }
            item.mScreenSurface.setZOrderOnTop(true);
            holder.mScreenSurfaceContainer.addView(item.mScreenSurface, new FrameLayout.LayoutParams(FrameLayout.LayoutParams.MATCH_PARENT, FrameLayout.LayoutParams.MATCH_PARENT));
            item.mScreenSurface.setZOrderMediaOverlay(true);
        }
        holder.itemView.setOnClickListener(new View.OnClickListener() {
            @Override
            public void onClick(View v) {
                if (mOnItemClickListener != null) {
                    mOnItemClickListener.onItemClick(item, holder.itemView, holder.getAdapterPosition(), holder.getItemId());
                }
            }
        });
    }

    @Override
    public int getItemCount() {
        return mList.size();
    }

    public void setData(List<ChartUserBean> list, boolean notify) {
        mList.clear();
        mMap.clear();
        for (ChartUserBean item : list) {
            mList.add(item.mUserId);
            mMap.put(item.mUserId, item);
        }
        if (notify) {
            notifyDataSetChanged();
        }
    }

    /**
     * 本地预览视图，固定添加到第一个
     *
     * @param data
     * @param notify
     */
    public void addDataByPosition(ChartUserBean data, boolean notify) {
        mList.add(0, data.mUserId);
        mMap.put(data.mUserId, data);
        if (notify) {
            notifyItemInserted(mList.size() - 1);
        }
    }

    public void addData(ChartUserBean data, boolean notify) {
        mList.add(data.mUserId);
        mMap.put(data.mUserId, data);
        if (notify) {
            notifyItemInserted(mList.size() - 1);
        }
    }

    public void removeData(String uid, boolean notify) {
        int index = mList.indexOf(uid);
        if (index < 0) {
            return;
        }
        mList.remove(uid);
        mMap.remove(uid);
        if (notify) {
            notifyItemRemoved(index);
        }
    }

    public void updateData(ChartUserBean data, boolean notify) {
        if (mList.contains(data.mUserId)) {
            int index = mList.indexOf(data.mUserId);
            mMap.put(data.mUserId, data);
            if (notify) {
                notifyItemChanged(index);
            }
        } else {
            addData(data, notify);
        }
    }

    public void replace(final ChartUserBean newUserBean, int position) {
        if (position < -1 || TextUtils.isEmpty(mList.get(position))) {
            return;
        }
        mMap.remove(mList.get(position));
        mMap.put(newUserBean.mUserId, newUserBean);
        mList.remove(position);
        mList.add(position, newUserBean.mUserId);
        notifyItemChanged(position);
    }

    public ChartUserBean getDataByUid(String uid) {
        if (mList.contains(uid)) {
            if (mMap.get(uid) == null) {
                return null;
            } else {
                return mMap.get(uid);
            }
        }
        return null;
    }

    public ChartUserBean createDataIfNull(String uid) {
        ChartUserBean ret;
        if (TextUtils.isEmpty(uid) || (ret = mMap.get(uid)) == null) {
            ret = new ChartUserBean();
        }
        return ret;
    }

    public boolean containsUser(String uid) {
        if (!mList.isEmpty() && mList.contains(uid)) {
            return true;
        }
        return false;
    }


    public static class ChartViewHolder extends RecyclerView.ViewHolder {

        public FrameLayout mScreenSurfaceContainer;
        public LinearLayout mScreenLayout;
        public LinearLayout mVideoLayout;
        public FrameLayout mSurfaceContainer;
        public SwitchCompat mVideoFlip;
        public TextView mVideoMediaInfo;
        public SwitchCompat mScreenFlip;
        public TextView mScreenMediaInfo;
        public TextView mUsernameTv;
        public ImageView mUserAvatarIv;

        public ChartViewHolder(View itemView) {
            super(itemView);
            mVideoLayout = itemView.findViewById(R.id.chart_content_userlist_item_video_layout);
            mSurfaceContainer = itemView.findViewById(R.id.chart_content_userlist_item_surface_container);
            mScreenLayout = itemView.findViewById(R.id.chart_content_userlist_item_screen_layout);
            mScreenSurfaceContainer = itemView.findViewById(R.id.chart_content_userlist_item2_surface_container);
            mUsernameTv = itemView.findViewById(R.id.tv_username);
            mUserAvatarIv = itemView.findViewById(R.id.iv_user_avatar);
        }

    }

    private OnItemClickListener mOnItemClickListener;

    public void setOnItemClickListener(OnItemClickListener onItemClickListener) {

        this.mOnItemClickListener = onItemClickListener;
    }

    public interface OnItemClickListener {
        void onItemClick(ChartUserBean bean, View view, int position, long itemId);
    }

}
