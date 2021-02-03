package com.aliyun.apsaravideo.sophon.bean;

import java.io.Serializable;

/**
 * 服务器返回的包含加入频道信息的业务类
 */
public class RTCAuthInfo implements Serializable {

    public int code;
    public RTCAuthInfo_Data data;

    public static class RTCAuthInfo_Data implements Serializable {
        public String appid;
        public String userid;
        public String nonce;
        public long timestamp;
        public String token;
        public RTCAuthInfo_Data_Turn turn;
        public String ConferenceId;
        public String[] gslb;
        public String key;

        public String getConferenceId() {
            return ConferenceId;
        }

        public void setConferenceId(String conferenceId) {
            ConferenceId = conferenceId;
        }

        public String getAppid() {
            return appid;
        }

        public void setAppid(String appid) {
            this.appid = appid;
        }

        public String getUserid() {
            return userid;
        }

        public void setUserid(String userid) {
            this.userid = userid;
        }

        public String getNonce() {
            return nonce;
        }

        public void setNonce(String nonce) {
            this.nonce = nonce;
        }

        public long getTimestamp() {
            return timestamp;
        }

        public void setTimestamp(long timestamp) {
            this.timestamp = timestamp;
        }

        public String getToken() {
            return token;
        }

        public void setToken(String token) {
            this.token = token;
        }

        public RTCAuthInfo_Data_Turn getTurn() {
            return turn;
        }

        public void setTurn(RTCAuthInfo_Data_Turn turn) {
            this.turn = turn;
        }

        public String[] getGslb() {
            return gslb;
        }

        public void setGslb(String[] gslb) {
            this.gslb = gslb;
        }

        public String getKey() {
            return key;
        }

        public void setKey(String key) {
            this.key = key;
        }

        public static class RTCAuthInfo_Data_Turn implements Serializable {
            public String username;
            public String password;

            public String getUsername() {
                return username;
            }

            public void setUsername(String username) {
                this.username = username;
            }

            public String getPassword() {
                return password;
            }

            public void setPassword(String password) {
                this.password = password;
            }
        }
    }

    public int server;

    public int getCode() {
        return code;
    }

    public void setCode(int code) {
        this.code = code;
    }

    public RTCAuthInfo_Data getData() {
        return data;
    }

    public void setData(RTCAuthInfo_Data data) {
        this.data = data;
    }

    public int getServer() {
        return server;
    }

    public void setServer(int server) {
        this.server = server;
    }
}
