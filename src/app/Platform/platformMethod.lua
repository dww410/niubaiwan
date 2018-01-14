--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local platformMethod    = platformMethod or {}
local targetPlatform    = cc.Application:getInstance():getTargetPlatform()
local MessageTip = require('app.views.UI.MessageTip')
--取得设备码
function platformMethod.GetDeviceID()
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local args      = {"x",0}
        local signs     = "(Ljava/lang/String;I)Ljava/lang/String;"
        local luaj      = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local ok , ret  = luaj.callStaticMethod(className ,"getDeviceID",args, signs)
        cc.UserDefault:getInstance():setStringForKey("UID",ret)
        return ret
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then
        cc.UserDefault:getInstance():setStringForKey("UID","SinLoveUID")
    else
        local args      = {str1="x",str2=0}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "UUID"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"getUUID",args)
        cc.UserDefault:getInstance():setStringForKey("UID",ret)
    end
end
--复制
function platformMethod.copyString(str)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local args = {str,0}
        local signs = "(Ljava/lang/String;I)Ljava/lang/String;"
        local luaj = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local ok , ret = luaj.callStaticMethod(className ,"copyString",args, signs)
        return ret
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then
    else
        local args      = {str1=str,str2=0}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "UUID"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"getCopyWithString",args)
        return ret
    end
end
--获取电量
function platformMethod.getBattery()
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local args = {"x",0}
        local signs = "(Ljava/lang/String;I)Ljava/lang/String;"
        local luaj = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local ok , ret = luaj.callStaticMethod(className ,"getBattery",args, signs)
        return ret
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then
        
    else
        local args      = {str1=str,str2=0}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "UUID"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"getBattery",args)
        return ret
    end
end
--获取网络状态
function platformMethod.GetNetwork()
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local args = {"x",0}
        local signs = "(Ljava/lang/String;I)Ljava/lang/String;"
        local luaj = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local ok , ret = luaj.callStaticMethod(className ,"GetNetwork",args, signs)
--        print("===============GetNetwork==== " .. ret)
        return ret
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then
        
    else
        local args      = {str1=str,str2=0}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "UUID"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"GetNetwork",args)
        return ret
    end
end

--获取设备系统环境
function platformMethod.GetStstemVersion()
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        return "32"
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
        local args      = {str1=str,str2=0}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "UUID"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"GetStstemVersion",args)
        return ret
    end
end

function platformMethod.Pay(url)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local args = {url,0}
        local signs = "(Ljava/lang/String;I)Ljava/lang/String;"
        local luaj = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local ok , ret = luaj.callStaticMethod(className ,"PayUrl",args, signs)
--        print("===============Pay==== " .. ret)
        return ret
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
        local args      = {str1=url,str2=0}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "UUID"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"PayUrl",args)
        return ret
    end
end
--微信分享 
--data1 网页连接
--data2 标题
--data3 描述.
--data4 图片地址,大小不能超过32K.
--data5 发送场景：0聊天界面 1朋友圈. 
--data6 回调函数
--data7 分享类型 1 文字 2 图片 3 音乐 4 视频 5 网页
function platformMethod.weichatfenxiang(data1,data2,data3,data4,data5,data6,data7)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local luaj      = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local args      = {data1,data2,data3,data4,data5,data6,data7}
        local signs     = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;III)V"
        local ok  = luaj.callStaticMethod(className ,"WeChatShare",args, signs)
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
--        | webpageUrl   | String | 是   | 点击内容打开的链接. |
--        | title        | String | 是   | 标题. |
--        | description  | String | 是   | 描述. |
--        | thumbImage   | String | 是   | 图片地址,大小不能超过32K. |
--        | scene        | Number | 是   | 发送场景：0聊天界面 1朋友圈. |
        local args      = {webpageUrl=data1,title=data2,description=data3,thumbImage=data4,scene=data5,callback=data6,sendType=data7}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "UUID"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"WechatShare",args)
        return ret
    end
end
--微信支付
function platformMethod.weichatpay(appId,partnerId,prepayid,noncestr,timeStamp,packageValue,sign,orderid,func)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local luaj      = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local args      = {appId,partnerId,prepayid,noncestr,timeStamp,packageValue,sign,orderid,APP_INFO.apppayecret,func}
        local signs     = "(Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;Ljava/lang/String;I)V"
        local ok  = luaj.callStaticMethod(className ,"WeChatPay",args, signs)
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then
        
    else
        local args      = {appId=appId,partnerId=partnerId,prepayid=prepayid,noncestr=noncestr,timeStamp=timeStamp,packageValue=packageValue,sign=sign,orderid=orderid,func=func}
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "UUID"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"WechatPay",args)
        return ret
    end
end
--微信登录
function platformMethod.weichatlogin(data)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local luaj      = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local args      = {"WeChatLogin",data}
        local signs     = "(Ljava/lang/String;I)V"
        local ok  = luaj.callStaticMethod(className ,"WeChatLogin",args, signs)
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
        local args      = {callback=data}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "UUID"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"WechatAuth",args)
        return ret
    end
end

function platformMethod.wechatAccessLogin(accessToken,func)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local luaj      = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local args      = {accessToken,func}
        local signs     = "(Ljava/lang/String;I)V"
        local ok  = luaj.callStaticMethod(className ,"WeChatLoginByAccess",args, signs)
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
       
    end
end

--自动进入房间
function platformMethod.AutoInRoom(func)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
        local luaj      = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local args      = {func}
        local signs     = "(I)V"
        local ok  = luaj.callStaticMethod(className ,"AutoInRoom",args, signs)
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
        local args      = {callback=func}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "AppController"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"AutoInRoom",args)
        return ret
    end
end
--录制语音
function platformMethod.RecordSound(filepath)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
       local luaj      = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local args      = {filepath}
        local signs     = "(Ljava/lang/String;)V"
        local ok  = luaj.callStaticMethod(className ,"StartRecord",args, signs)
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
        local args      = {path=filepath,str2=""}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "AudioShare"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"Record",args)
        return ret
    end
end

--停止录音
function platformMethod.StopRecordSound( func)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
       local luaj      = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local args      = {func}
        local signs     = "(I)V"
        local ok  = luaj.callStaticMethod(className ,"StopRecord",args, signs)
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
        local args      = {callback=func,str2=""}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "AudioShare"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"StopRecord",args)
        return ret
    end
end

--播放语音
--| 参数名称      | 参数类型 | 是否必选 | 说明                                       |
--| ------------ | ------ | ---- | -------------------- |
--| path        | Number | 是   | 语音文件地址 |
function platformMethod.PlaySound(filepath)
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
       local luaj      = require "cocos.cocos2d.luaj"
        local className = "org/cocos2dx/lua/AppActivity"--类名
        local args      = {filepath}
        local signs     = "(Ljava/lang/String;)I"
        local ok ,ret = luaj.callStaticMethod(className ,"PlayRecord",args, signs)
        return ret
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
        local args      = {path=filepath,str2=""}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "AudioShare"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"Play",args)
        return ret
    end
end

--停止播放
function platformMethod.StopPlaySound( )
    if targetPlatform == cc.PLATFORM_OS_ANDROID then
       
    elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

    else
         local args      = {path="",str2=""}--参数
        local luaoc      = require "cocos.cocos2d.luaoc"
        local className = "AudioShare"--类名
        local ok , ret  = luaoc.callStaticMethod(className ,"StopPlay",args)
        return ret
    end
end

return platformMethod
--endregion
