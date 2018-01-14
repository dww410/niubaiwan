--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--通用提示界面
-- User: CongQin
-- Date: 17/02/18

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerTips = class("LayerTips", require("app.views.UI.PopUI"))
function LayerTips:ctor(text,btncanelvisible)
    LayerTips.super.ctor(self)
    self:BindNodes(self.WidgetNode,"common_popBg",
    "common_popBg.btnSure","common_popBg.ButtonCanel","common_popBg.noticeLabel"
    )
    self.text=text
    self:refresh()
    self:initEvent()

    if btncanelvisible==false then
        self.ButtonCanel:setVisible(false)
        self.btnSure:setPositionX(self.common_popBg:getCenter().x)
    end
    self.CloseType=0
    self.Updated=false 
end

function LayerTips:getWidget()
    return "PopUIs/LayerTips.csb"
end

function LayerTips:refresh()
    self.noticeLabel:setString(self.text)
end

function LayerTips:initEvent()
     UIHelper.BindClickByButtons({self.btnSure,self.ButtonCanel}, function(sender, event)
        if sender == self.ButtonCanel then
            self:Close()
        elseif sender == self.btnSure then
            self.Updated=true
            self:Close()
        end
    end )

end

function LayerTips:onEnter()
    self.super.onEnter(self)
end

function LayerTips:onExit()
    self.super.onExit(self)
end
return LayerTips

--endregion
