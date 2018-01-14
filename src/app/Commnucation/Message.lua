--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
-- User: CongQin
-- Date: 16/04/08
local MSG=MSG or {}
local targetPlatform    = cc.Application:getInstance():getTargetPlatform()

function MSG.newXMLHttpRequest()
    local xhr= cc.XMLHttpRequest:new()
    xhr.responseType = cc.XMLHTTPREQUEST_RESPONSE_JSON
    if targetPlatform==cc.PLATFORM_OS_WINDOWS then
        xhr:setRequestHeader("User-Agent","pc")
    elseif targetPlatform==cc.PLATFORM_OS_ANDROID then
        xhr:setRequestHeader("User-Agent","android")
    else
        xhr:setRequestHeader("User-Agent","ios")
    end
    xhr:setRequestHeader("Cookie",cc.UserDefault:getInstance():getStringForKey("Cookie"))
    return xhr
end

function MSG.send(id,msg,servertype)
    Socket_SendMsg(id,msg,#msg,servertype)
end

function MSG.sendHttp(xhr,str,handler,file,uuid)
    xhr:open("POST",str)
    xhr:registerScriptHandler(handler)
    if file~=nil then
        xhr:setRequestHeader("Content-Type", "multipart/form-data;boundary=".. uuid )
        xhr:send(file)
    else
        xhr:send()
    end
end



function MSG.getHttp(xhr,str,handler)
    xhr:open("GET",str)
    xhr:registerScriptHandler(handler)
    xhr:send()
end

cc.exports.MSG=MSG
--endregion
