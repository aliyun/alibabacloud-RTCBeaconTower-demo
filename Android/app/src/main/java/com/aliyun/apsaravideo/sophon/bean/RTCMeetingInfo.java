package com.aliyun.apsaravideo.sophon.bean;

public class RTCMeetingInfo {

    /**
     * code : 0
     * data : {"meetingID":"976633"}
     * server : 23238
     */

    private int code;
    private DataBean data;
    private int server;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public DataBean getData() {
        return data;
    }

    public void setData(DataBean data) {
        this.data = data;
    }

    public int getServer() {
        return server;
    }

    public void setServer(int server) {
        this.server = server;
    }

    public static class DataBean {
        /**
         * meetingID : 976633
         */

        private String meetingID;

        public String getMeetingID() {
            return meetingID;
        }

        public void setMeetingID(String meetingID) {
            this.meetingID = meetingID;
        }
    }
}
