--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--微信分享 朋友圈界面
-- User: CongQin
-- Date: 17/06/02
local platformMethod = require('app.Platform.platformMethod')
local MessageTip = require('app.views.UI.MessageTip')

local LayerWeiChat = class("LayerWeiChat", require("app.views.UI.PopUI"))

function LayerWeiChat:ctor()
    LayerWeiChat.super.ctor(self)
    self:BindNodes(self.WidgetNode,
    "Image_bg.Button_1","Image_bg.Button_2"
    )
    self:refresh()
    self:initEvent()

    self.Updated=false 
end

function LayerWeiChat:getWidget()
    return "PopUIs/LayerWeiChat.csb"
end

function LayerWeiChat:refresh()

end

function LayerWeiChat:initEvent()
     UIHelper.BindClickByButtons({self.Button_1,self.Button_2}, function(sender, event)
        if sender == self.Button_1 then
            ServiceMessageManager.WeChatShare(0,APP_INFO.appname.."（仿真实战·手感搓牌）","激情斗牛，约上好友，明牌抢庄，炸弹带五花。大家都在玩，就等你了【点我下载】","",0,5)
        elseif sender == self.Button_2 then
            ServiceMessageManager.WeChatShare(0,APP_INFO.appname.."（仿真实战·手感搓牌）","激情斗牛，约上好友，明牌抢庄，炸弹带五花。大家都在玩，就等你了【点我下载】","",1,5)
        end
    end )
end

function LayerWeiChat:onEnter()
    self.super.onEnter(self)
end

function LayerWeiChat:onExit()
    self.super.onExit(self)
end
return LayerWeiChat
--endregion
