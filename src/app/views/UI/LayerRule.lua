--region LayerRule.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 
--create by niyinguo
--Date: 17/06/02

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerRule = class("LayerRule", require("app.views.UI.PopUI"))

function LayerRule:ctor()
    LayerRule.super.ctor(self)
     self:BindNodes(self.WidgetNode,"Panel_1",
    "Panel_1.Button_Close")

    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)
end

function LayerRule:getWidget()
    return "PopUIs/LayerRule.csb"
end
function LayerRule:onEnter()
    self.super.onEnter(self)
end

function LayerRule:onExit()
    self.super.onExit(self)
end

return LayerRule

--endregion
