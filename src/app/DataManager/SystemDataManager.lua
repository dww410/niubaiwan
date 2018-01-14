--region SystemDataManager.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 
--create by niyinguo
--Date: $time$

require('app.Commnucation.MessageManager')

local SystemDataManager = SystemDataManager or { }
local MessageTip = require('app.views.UI.MessageTip')
SystemDataManager.SystemSet=nil

function SystemDataManager.ProcessMsg(msgid,strHex)
     if msgid == Enum.SYSTEM_CLIENT then
        local cmsg = hall_pb.SystemResponse()
        cmsg:ParseFromString(strHex)
        SystemDataManager.SystemSet = {}
        SystemDataManager.SystemSet.ratio = cmsg.ratio
        SystemDataManager.SystemSet.spreadGive = cmsg.spreadGive
        SystemDataManager.SystemSet.extensionDomain = cmsg.extensionDomain
        SystemDataManager.SystemSet.payurl = cmsg.payurl
        SystemDataManager.SystemSet.agentGroup = cmsg.agentGroup
        SystemDataManager.SystemSet.weChatNumber = cmsg.weChatNumber
        SystemDataManager.SystemSet.customerService = cmsg.customerService
     end
end

cc.exports.SystemDataManager=SystemDataManager
return SystemDataManager

--endregion
