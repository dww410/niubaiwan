--region LayerBindTip.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 绑定邀请码的提示
--create by niyinguo
--Date: 2017 6 9

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
local platformMethod = require('app.Platform.platformMethod')

local LayerBindTip = class("LayerBindTip", require("app.views.UI.PopUI"))

function LayerBindTip:ctor()
    LayerBindTip.super.ctor(self)
    self:BindNodes(self.WidgetNode,
    "Panel_1.Button_Close",
    "Panel_1.Button_Return",
    "Panel_1.Button_Bind",
    "Panel_1.Image_4.rmbText",
    "Panel_1.Image_4.diamondText",
    "Panel_1.Image_4.adddiamondText",
    "Panel_1.Image_4.Image_4_0_0",
    "Panel_1.Image_4.Image_4_0_0_0"
    )
    self.money = 0

    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)

    UIHelper.BindClickByButton(self.Button_Return,function(sender,event)
        if self.rechargeMoney~=0 then
           ServiceMessageManager.SendRequstRecharge("buy diamond",self.money*100)
        end
    end)

    UIHelper.BindClickByButton(self.Button_Bind,function(sender,event)
        require("app.views.UI.LayerInvitation").new():Show()
        self:Close()
    end)

    self.rechargeMoney = 0
    self.dimondGiveNum = {1,3,6,13,32,64}
    self.dimondgGetNum = {6,16,30,68,128,328}
    self.goldGiveNum = {1.2,4,8,22,47,127}
    self.goldGetNum = {6,18,30,68,128,288}
end

function LayerBindTip:setRechargeMoney(money, gave, index, moneytype)
    self.rmbText:setString("￥"..money)
    self.money = money
    if moneytype == 1 then
       local diamond = Tool.GetRounding(money/PlayerManager.Player.ratio)
       self.diamondText:setString(""..diamond)
       local gaveDiamond = Tool.GetRounding(gave/PlayerManager.Player.ratio)
       self.adddiamondText:setString(""..gaveDiamond)
       self.Image_4_0_0:loadTexture("rechange_diamond.png",ccui.TextureResType.plistType)
       self.Image_4_0_0_0:loadTexture("rechange_diamond.png",ccui.TextureResType.plistType)
    else
       self.diamondText:setString(""..self.goldGetNum[index])
       self.adddiamondText:setString(""..self.goldGiveNum[index])
       self.Image_4_0_0:loadTexture("rechange_gold.png",ccui.TextureResType.plistType)
       self.Image_4_0_0_0:loadTexture("rechange_gold.png",ccui.TextureResType.plistType)
    end
  
    self.rechargeMoney = money
end

function LayerBindTip:getWidget()
    return "PopUIs/LayerBindTip.csb"
end
function LayerBindTip:onEnter()
    self.super.onEnter(self)
end

function LayerBindTip:onExit()
    self.super.onExit(self)
    self.rechargeMoney = 0
end

return LayerBindTip

--endregion
