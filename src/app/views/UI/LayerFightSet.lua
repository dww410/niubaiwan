--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 游戏设置
--create by CongQin
--Date: 17/06/20
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')


local LayerFightSet = class("LayerFightSet", require("app.views.UI.PopUI"))

function LayerFightSet:ctor(uitype)
    LayerFightSet.super.ctor(self)
     self:BindNodes(self.WidgetNode,"Panel_2",
    "Panel_2.Button_2","Panel_2.Button_3","Panel_2.Button_4","Panel_2.Button_5")

    self.uitype=uitype
    self.Updated=0
    self:initEvent()
    self.WidgetNode:setPositionX(1035)
    self:removeChildByName("BG")
    if self.uitype~=nil and self.uitype==2 then
        self.Button_4:setVisible(false)
        self.Button_5:setPosition(self.Button_4:getPosition())
    end
end

function LayerFightSet:initEvent()
    UIHelper.BindClickByButtons({self.Button_2,self.Button_3,self.Button_4,self.Button_5}, function(sender, event)
        
        if sender == self.Button_2 then
            self.Updated=0
        elseif sender == self.Button_3 then
            self.Updated=3
        elseif sender == self.Button_4 then
            self.Updated=4
        elseif sender == self.Button_5 then
            self.Updated=5
        end
            self:Close()
    end )
end

function LayerFightSet:getWidget()
    return "PopUIs/LayerFightSet.csb"
end
function LayerFightSet:onEnter()
    self.super.onEnter(self)
end

function LayerFightSet:onExit()
    self.super.onExit(self)
end

return LayerFightSet

--endregion
