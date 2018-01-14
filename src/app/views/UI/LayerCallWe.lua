--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 联系客服
--create by niyinguo
--Date: 17/06/02

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerCallWe = class("LayerCallWe", require("app.views.UI.PopUI"))

function LayerCallWe:ctor()
    LayerCallWe.super.ctor(self)
    self:BindNodes(self.WidgetNode,"Panel_1",
    "Panel_1.Button_Close",
    "Panel_1.Image_8.callNum0",
    "Panel_1.Image_8.callNum1",
    "Panel_1.Image_8.callNum2")

    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)

    self.callNum0:setString(SystemDataManager.SystemSet.agentGroup)
    self.callNum1:setString(SystemDataManager.SystemSet.weChatNumber)
    self.callNum2:setString(SystemDataManager.SystemSet.customerService)
end

function LayerCallWe:getWidget()
    return "PopUIs/LayerCallWe.csb"
end
function LayerCallWe:onEnter()
    self.super.onEnter(self)
end

function LayerCallWe:onExit()
    self.super.onExit(self)
end

return LayerCallWe

--endregion
