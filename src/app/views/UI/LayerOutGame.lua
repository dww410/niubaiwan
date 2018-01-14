--region LayerOutGame.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 退出游戏提示
--create by niyinguo
--Date: 17/06/02

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerOutGame = class("LayerOutGame", require("app.views.UI.PopUI"))

function LayerOutGame:ctor()
    LayerOutGame.super.ctor(self)
     self:BindNodes(self.WidgetNode,"Panel_1",
    "Panel_1.Button_Close",
    "Panel_1.Button_Sure",
    "Panel_1.Button_ChangeAcc")

    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)

    UIHelper.BindClickByButton(self.Button_Sure,function(sender,event)
        ExitGame()
    end)

    UIHelper.BindClickByButton(self.Button_ChangeAcc,function(sender,event)
        self:Close()
    end)
end

function LayerOutGame:getWidget()
    return "PopUIs/LayerOutGame.csb"
end
function LayerOutGame:onEnter()
    self.super.onEnter(self)
end

function LayerOutGame:onExit()
    self.super.onExit(self)
end

return LayerOutGame

--endregion
