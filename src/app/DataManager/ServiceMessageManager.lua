--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--玩家信息
--create by niyinguo
--Date: $time$
local platformMethod = require('app.Platform.platformMethod')
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local ServiceMessageManager=ServiceMessageManager or {}

--请求公告
function ServiceMessageManager.GetNotice()
   MSG.send(Enum.NOTICE_SERVER,"",1)
   print("请求公告")
end

--请求房间列表
function ServiceMessageManager.GetRoomList()
   MSG.send(Enum.ROOMS_SERVER,"",1)
      print("请求房间列表")
end

--请求充值列表
function ServiceMessageManager.GetRechargeList()
   MSG.send(Enum.RECHARGE_SERVER,"",1)
      print("请求充值列表")
end

--请求系统信息
function ServiceMessageManager.GetSystemSet()
   MSG.send(Enum.SYSTEM_SERVER,"",1)
      print("请求系统信息")
end

--获取游戏记录
function ServiceMessageManager.GetGameRecode()
   MSG.send(Enum.GAME_RECORD_SERVER,"",1)
   print("获取游戏记录")
end

--获取每日奖励
function ServiceMessageManager.GetEveryDayGift()
   MSG.send(Enum.RECEIVE_GOLD_SERVER,"",1)
end

--救济金
function ServiceMessageManager.GetHelpGift()
    MSG.send(Enum.RECEIVE_BENEFIT_SERVER,"",1)
end

--请求微信充值
function ServiceMessageManager.SendRequstRecharge(body,money)
    local smsg = hall_pb.ReChargeWeChatRequest()
    smsg.body=body
    smsg.total_fee=money..""
    smsg.spbill_create_ip=PlayerManager.Player.lastLoginIP
    print(smsg.spbill_create_ip)
    local msgData = smsg:SerializeToString()
    MSG.send(Enum.RECHARGE_PAY_SERVER,msgData,1)
end

function ServiceMessageManager.SendWeChatPay(prepayid,noncestr,sign,orderid)
    local timeStamp = os.time()..""
    PayStuate= function(sutat)
        MSG.send(Enum.USER_INFO_SERVER,"",1)
    end
    platformMethod.weichatpay(APP_INFO.appid,APP_INFO.apppayid,prepayid,noncestr,timeStamp,sign,"Sign=WXPay",orderid,PayStuate)
end

--roomNum 房间号
--titleStr 标题
--shareStr 描述.
--imgUrl 图片地址,大小不能超过32K.
--shareScene 发送场景：0聊天界面 1朋友圈. 
--shareType 分享类型 1 文字 2 图片 3 音乐 4 视频 5 网页
function ServiceMessageManager.WeChatShare(roomNum,titleStr,shareStr,imgUrl,shareScene,shareType)
    PayStuate= function(sutat)
        if targetPlatform == cc.PLATFORM_OS_ANDROID then
            if sutat=="-4" or sutat=="-2" then
                MessageTip.Show("分享取消!")
            elseif sutat=="-99" then
                MessageTip.Show("您没有安装微信,请先安装微信!")
            else
                MessageTip.Show("微信分享成功")
            end
        else
            if sutat==0 then
            MessageTip.Show("微信分享成功")
            else
            MessageTip.Show("微信分享失败")
            end
        end
    end
    platformMethod.weichatfenxiang(GAME_URL.downLoadUrl.."?RoomNum="..roomNum,titleStr,shareStr,imgUrl,shareScene,PayStuate,5)
end

--微信登录
function ServiceMessageManager.WeChatLogin(code)
    local xhr=MSG.newXMLHttpRequest()
    local sendTable = {}
    sendTable["appid"] = APP_INFO.appid
    sendTable["secret"] = APP_INFO.appsecret
    sendTable["code"] = code
    sendTable["grant_type"] = "authorization_code"


    MSG.getHttp(xhr,"https://api.weixin.qq.com/sns/oauth2/access_token?appid="..APP_INFO.appid.."&secret="..APP_INFO.appsecret.."&code="..code.."&grant_type=authorization_code",function()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local fileData =  json.decode(xhr.response) 
           if fileData.errcode==nil or fileData.errcode==0 then
                ServiceMessageManager.SaveUserAccessToken(fileData.access_token)
                ServiceMessageManager.SaveUserRefreshToken(fileData.refresh_token)
                ServiceMessageManager.SaveUserOpenId(fileData.openid)
                ServiceMessageManager.WeChatGetInfo(fileData.access_token,fileData.openid)
            end
        end
        WaitProgress.Close()
    end)
end

--微信登录(获取用户信息)
function ServiceMessageManager.WeChatGetInfo(access_token,openid)
    local xhr=MSG.newXMLHttpRequest()
    local sendTable = {}
    sendTable["access_token"] = access_token
    sendTable["openid"] = openid

    MSG.getHttp(xhr,"https://api.weixin.qq.com/sns/userinfo?access_token="..access_token.."&openid="..openid,function()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local variable = Tool.splistStr(xhr.response,"\\")
            local str = ""
            for i = 1, #variable do
                str = str..variable[i]
            end
            local fileData =  json.decode(str) 
            if fileData.errcode==nil then
                ServiceMessageManager.login(fileData.unionid,fileData.sex,fileData.nickname,fileData.headimgurl,"android")
            end
        end
        WaitProgress.Close()
    end)
end

--检验授权凭证（access_token）是否有效
function ServiceMessageManager.WeChatCheckToken(access_token,openid)
    local xhr=MSG.newXMLHttpRequest()
    local sendTable = {}
    sendTable["access_token"] = access_token
    sendTable["openid"] = openid
    MSG.getHttp(xhr,"https://api.weixin.qq.com/sns/auth?access_token="..access_token.."&openid="..openid,function()
--    MSG.getHttp(xhr,"https://api.weixin.qq.com/sns/auth?"..UIHelper:escape(json.encode(sendTable)),function()
        if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
            local fileData =  json.decode(xhr.response) 
            if fileData.errcode == 0 then
                ServiceMessageManager.WeChatGetInfo(access_token,openid)
            else
                ServiceMessageManager.SaveUserAccessToken("NoToken")
                ServiceMessageManager.SaveUserRefreshToken("NoToken")
                ServiceMessageManager.SaveUserOpenId("NoToken")
            end
        elseif xhr.readyState == 1 and xhr.status == 0 then
                ServiceMessageManager.SaveUserAccessToken("NoToken")
                ServiceMessageManager.SaveUserRefreshToken("NoToken")
                ServiceMessageManager.SaveUserOpenId("NoToken")
        end
        WaitProgress.Close()
    end)
end



--刷新或续期access_token使用
function ServiceMessageManager.WeChatRefreshToken(refresh_token)
    local xhr=MSG.newXMLHttpRequest()
    local sendTable = {}
    sendTable["appid"] = APP_INFO.appid
    sendTable["grant_type"] = "refresh_token"
    sendTable["refresh_token"] = refresh_token
MSG.getHttp(xhr,"https://api.weixin.qq.com/sns/oauth2/refresh_token?appid="..APP_INFO.appid.."&grant_type=refresh_token&refresh_token="..refresh_token,function()
if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
local fileData =  json.decode(xhr.response)
if fileData.errcode==nil or fileData.errcode==0 then
                ServiceMessageManager.SaveUserAccessToken(fileData.access_token)
                ServiceMessageManager.SaveUserRefreshToken(fileData.refresh_token)
                ServiceMessageManager.SaveUserOpenId(fileData.openid)
            end
        end
    end)
end


--登录游戏
function ServiceMessageManager.login(unionid,sex,nickname,headimgurl,data)
    PauseStateToLua = function(sutat)
        if sutat==1 then
            print("连接 大厅服务器 成功-1")
            local smsg = hall_pb.LoginRequest()
            smsg.token=unionid
            smsg.sex = sex
            smsg.headimgurl = headimgurl
            smsg.name = nickname
            smsg.platform=data
            local msgData = smsg:SerializeToString()
            ServiceMessageManager.unionid=unionid
            ServiceMessageManager.platform=data
            MSG.send(Enum.LOGIN_SERVER,msgData,1)
        else
            print("连接 大厅服务器 失败-1")
        end
        PauseStateToLua= function() print('PauseStateToLua') end
    end
    Socket_Reconnect(1)
end

--保存refresh_token
function ServiceMessageManager.SaveUserRefreshToken(refresh_token)
    cc.UserDefault:getInstance():setStringForKey("refresh_token",refresh_token)
end
--读取refresh_token
function ServiceMessageManager.LoadUserRefreshToken()
    return cc.UserDefault:getInstance():getStringForKey("refresh_token","NoToken")
end

--保存access_token
function ServiceMessageManager.SaveUserAccessToken(access_token)
    cc.UserDefault:getInstance():setStringForKey("access_token",access_token)
end
--读取access_token
function ServiceMessageManager.LoadUserAccessToken()
    return cc.UserDefault:getInstance():getStringForKey("access_token","NoToken")
end

--保存openid
function ServiceMessageManager.SaveUserOpenId(openid)
    cc.UserDefault:getInstance():setStringForKey("openid",openid)
end
--读取openid
function ServiceMessageManager.LoadUserOpenId()
    return cc.UserDefault:getInstance():getStringForKey("openid","NoToken")
end

cc.exports.ServiceMessageManager=ServiceMessageManager
return ServiceMessageManager
--endregion
