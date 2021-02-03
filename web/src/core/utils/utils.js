import { Message } from 'element-ui';
import RTCClient from "../rtc-client";
import state from '../../vuex/state';
export default class Util {
    /**
     * 显示信息
     * @param {*} v 
     */
    static toast(v) {
        Message(v);
    }
    /**
     * 复制
     * @param {*} id 
     */
    static hCopy(id) {
        if (id) {
            try {
                var range = document.createRange();
                var tar = document.getElementById(id);
                range.selectNodeContents(tar);
                var selection = window.getSelection();
                selection.removeAllRanges();
                selection.addRange(range);
                document.execCommand('copy');
                selection.removeAllRanges();
            } catch (error) {
                console.log(error);
                return false;
            }
            return true;
        } else {
            return true;
        }
    }
    /**
     * 
     * @param {*} id 
     */
    static inputCopy(id) {
        try {
            var Url2 = document.getElementById(id);
            Url2.select(); // 选择对象
            document.execCommand("Copy");
            return true;
        } catch (error) {
            console.error(error);
            return false;
        }
    }
    /**
  * 获取浏览器地址栏参数
  * @param {*} url 
  * @param {*} name 
  */
    static getUrlParam(name) {
        let url = window.location.href;
        var reg = new RegExp('(^|&)' + name + '=([^&]*)(&|$)');
        let urlArr = url.split("?");
        if (urlArr.length > 1) {
            url = "?" + urlArr[1];
            var r = url.substr(1).match(reg);
            if (r != null) return decodeURIComponent(r[2]); return null;
        } else {
            return null;
        }
    }
    /**
     * 退出房间
     */
    static exitRoom() {
        RTCClient.instance
            .logout()
            .then(() => { }).catch(err => { }).then(() => {
                hvuex({ isPublishScreen: false, isPublish: false, isPreview: RTCClient.instance.isPreview });
                hv.$router.push("/");
            });
    }
    /**
     * 开始预览
     */
    static startPreview(view) {
        return new Promise((resolve,reject)=>{
            RTCClient.instance
            .startPreview(view)
            .then(() => {
                AppConfig.localStream = view.srcObject;
                hvuex({ isPreview: true });
                resolve();
            })
            .catch(err => {
                reject(err);
                console.error("", err);
            });
        })
    }
    /**
     * 显示远端用户
     * @param {*} data 
     */
    static showRemoteVideo(data) {
        let userInfo = RTCClient.instance.getUserInfo(data.userId);
        let video = document.getElementById(data.userId);
        let subUserId = document.getElementById("localVideo").getAttribute("subUserId");      
        if (subUserId) {
            if(subUserId == data.userId){
                video = document.getElementById("localVideo");
                let index = userInfo.streamConfigs.findIndex(item=>{ return item.label=="sophon_video_camera_large"&&item.subscribed })
                if(index==-1){
                    RTCClient.instance.subscribeLarge(data.userId).then((code)=>{
                        RTCClient.instance.setDisplayRemoteVideo(data.userId, video, code);
                    });
                    return false;  
                }
            } else {
                if(userInfo.displayName.indexOf("_老师")>-1){
                    hvuex({switchUserId:data.userId});
                }
            }
        } else {
            if(userInfo.displayName.indexOf("_老师")>-1){
                hvuex({switchUserId:data.userId});
            }
        }
        RTCClient.instance.setDisplayRemoteVideo(data.userId, video, data.code);
    }

    /**
     * 
     * @param {*} code 
     */
    static onByeMessage(code) {
        console.log(code);
        let messageTxt = "";
        if (code == 1) {
            messageTxt = "10分钟体验时间已到";
        } else if (code == 2) {
            messageTxt = "10分钟体验时间已到";
        } else {
            messageTxt = "同一个用户ID在其他端登录";
        }
        hv.$alert(messageTxt, "", {
            confirmButtonText: '确定',
            callback: action => {
                hv.$router.push("/");
            }
        });
    }
    /**
     * 显示错误
     */
    static showErrorMsg(data) {
        let resmsg = "";
        switch (data.errorCode) {
            case 10000:
                resmsg += "设备未知错误";
                break;
            case 10001:
                resmsg += "未找到音频设备";
                break;
            case 10002:
                resmsg += "未找到视频设备";
                break;
            case 10003:
                resmsg += "浏览器禁用音频设备";
                break;
            case 10004:
                resmsg += "浏览器禁用视频设备";
                break;
            case 10005:
                resmsg += "系统禁用音频设备";
                break;
            case 10006:
                resmsg += "系统禁用视频设备";
                break;
            case 10010:
                resmsg += "屏幕共享未知错误";
                break;
            case 10011:
                {
                    resmsg += "屏幕共享被禁用";
                    hvuex({ isPublishScreen: false });

                }
                break;
            case 10012:
                resmsg += "屏幕共享已取消";
                hvuex({ isPublishScreen: false });
                if (state.data.isSwitchScreen) {
                    if (state.data.isPublishScreen) {
                        document.getElementById(RTCClient.instance.userId).srcObject = RTCClient.instance.screenStream;
                    } else {
                        document.getElementById(RTCClient.instance.userId).srcObject = AppConfig.localStream;
                    }
                } else {
                    if (state.data.isPublishScreen) {
                        document.getElementById("localVideo").srcObject = RTCClient.instance.screenStream;
                    } else {
                        document.getElementById("localVideo").srcObject = AppConfig.localStream;
                    }
                }
                if (document.getElementById(RTCClient.instance.userId).srcObject == AppConfig.localStream) {
                    document.getElementById(RTCClient.instance.userId).srcObject = null;
                }
                break;
            case 10201:
                resmsg += "自动播放失败";
                break;
            case 10300:
                resmsg += "直播拉流失败，请重新拉流";
                document.getElementById("localVideo").srcObject = null;
                break;
            default:
                break;
        }
        resmsg ? Util.toast(resmsg) : Util.toast(data);
    }
}
