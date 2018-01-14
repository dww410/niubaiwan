--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
-- User: qincong
-- Date: 16/04/08
require('app.Commnucation.MessageManager')
local MessageTip = require('app.views.UI.MessageTip')
local UnionManager = UnionManager or { }
UnionManager.UnionInfo={}
UnionManager.Chatlist={}  --聊天信息
UnionManager.Fightlist={} --友谊战信息
UnionManager.Donatelist={} --捐赠信息

function UnionManager.ProcessMsg(msgid,strHex)
   
end

function UnionManager.reload()
    --UnionManager.UnionInfo={}
    UnionManager.Chatlist={}  
    UnionManager.Fightlist={} 
    UnionManager.Donatelist={} 
end

cc.exports.UnionManager=UnionManager
return UnionManager
--endregion
