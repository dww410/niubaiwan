--region LayerAgent.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 
--create by niyinguo
--Date: $time$

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
local platformMethod = require('app.Platform.platformMethod')

local LayerAgent = class("LayerAgent", require("app.views.UI.PopUI"))

function LayerAgent:ctor()
    LayerAgent.super.ctor(self)
    self:BindNodes(self.WidgetNode,"Panel_1.Text_wechat")
    self:BindNodes(self.WidgetNode,"Panel_1.Button_Agent","Panel_1.Button_Close")

    self.Text_wechat:setString(SystemDataManager.SystemSet.weChatNumber)
    UIHelper.BindClickByButton(self.Button_Agent,function(sender,event)
        MessageTip.Show("复制成功")
        platformMethod.copyString(SystemDataManager.SystemSet.weChatNumber.."")
    end)
    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)
end

function LayerAgent:getWidget()
    return "PopUIs/LayerAgent.csb"
end
function LayerAgent:onEnter()
    self.super.onEnter(self)
end

function LayerAgent:onExit()
    self.super.onExit(self)
end

return LayerAgent

--endregion
