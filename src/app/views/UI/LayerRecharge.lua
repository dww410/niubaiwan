--region LayerRecharge.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 充值面板
--create by niyinguo
--Date: 2017/06/09

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
local platformMethod = require('app.Platform.platformMethod')

local LayerRecharge = class("LayerRecharge", require("app.views.UI.PopUI"))

function LayerRecharge:ctor()
    LayerRecharge.super.ctor(self)
    self:BindNodes(self.WidgetNode,
        "Panel_1.Button_Close",
        "Panel_1.rechargeSelect",
        "Panel_1.goldSelect",
        "Panel_1.Button_Agent",
        "Panel_1.RechargePanel",
        "Panel_1.RechargePanel.ListView_Recharge",
        "Panel_1.RechargePanel.ListView_Recharge.RechargeItem_0",
        "Panel_1.RechargePanel.ListView_Recharge.RechargeItem_1",
        "Panel_1.RechargePanel.ListView_Recharge.RechargeItem_2",
        "Panel_1.RechargePanel.ListView_Recharge.RechargeItem_3",
        "Panel_1.RechargePanel.ListView_Recharge.RechargeItem_4",
        "Panel_1.RechargePanel.ListView_Recharge.RechargeItem_5",
        "Panel_1.RechargeGoldPanel",
        "Panel_1.RechargeGoldPanel.ListView_RechargeGold",
        "Panel_1.RechargeGoldPanel.ListView_RechargeGold.RechargeGoldItem_0",
        "Panel_1.RechargeGoldPanel.ListView_RechargeGold.RechargeGoldItem_1",
        "Panel_1.RechargeGoldPanel.ListView_RechargeGold.RechargeGoldItem_2",
        "Panel_1.RechargeGoldPanel.ListView_RechargeGold.RechargeGoldItem_3",
        "Panel_1.RechargeGoldPanel.ListView_RechargeGold.RechargeGoldItem_4",
        "Panel_1.RechargeGoldPanel.ListView_RechargeGold.RechargeGoldItem_5",
        "Panel_1.Text_QQ",
        "Panel_1.Text_WeChat"
    )

    self.curPanelIndex = 0
    self:initEvent()
    self:showPanelIndex(1)
    if SystemDataManager.SystemSet~=nil then
        self.Text_QQ:setString("QQ号:"..SystemDataManager.SystemSet.customerService)
        self.Text_WeChat:setString("微信号："..SystemDataManager.SystemSet.weChatNumber)
    end

    local value = {18,30,68,128,328,698 }
    local gavie = {3,6,14,28,72,154}
    for i = 1, 6 do
        UIHelper.getNode(self["RechargeItem_"..(i-1)],{"Image_Diamond"}):loadTexture("recharge_image_diamond_"..(i-1)..".png",ccui.TextureResType.plistType)
        UIHelper.getNode(self["RechargeItem_"..(i-1)],{"Image_Diamond"}):ignoreContentAdaptWithSize(true)
        UIHelper.getNode(self["RechargeItem_"..(i-1)],{"Text_Diamond"}):setString(Tool.GetRounding(value[i]/PlayerManager.Player.ratio))
        --if PlayerManager.Player.inviteCode~= nil and string.len(PlayerManager.Player.inviteCode)>1 then
        --    print("当前邀请码"..PlayerManager.Player.inviteCode)
        UIHelper.getNode(self["RechargeItem_"..(i-1)],{"bindmark"}):setVisible(true)
        UIHelper.getNode(self["RechargeItem_"..(i-1)],{"bindmark","Text"}):setString("赠送"..Tool.GetRounding(gavie[i]/PlayerManager.Player.ratio).."钻石")
        --             UIHelper.getNode(self["RechargeGoldItem_"..(i-1)],{"bindmark"}):setVisible(true)
        --else
        --    UIHelper.getNode(self["RechargeItem_"..(i-1)],{"bindmark"}):setVisible(false)
        --            UIHelper.getNode(self["RechargeGoldItem_"..(i-1)],{"bindmark"}):setVisible(false)
        --end
    end

end

function LayerRecharge:initEvent()
    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)
    UIHelper.BindClickByButton(self.Button_Agent,function(sender,event)
        MessageTip.Show("微信号复制成功")
        platformMethod.copyString(SystemDataManager.SystemSet.weChatNumber)
    end)

    self.rechargeSelect:addEventListener(function(sender,event)
        self:showPanelIndex(1)
        self.rechargeSelect:setSelected(true)
        SoundHelper.playMusicSound(65,0,false)
    end)
    self.goldSelect:addEventListener(function(sender,event)
        self:showPanelIndex(3)
        self.goldSelect:setSelected(true)
        SoundHelper.playMusicSound(65,0,false)
    end)


end



function LayerRecharge:showPanelIndex(index)
    if self.curPanelIndex == index then
        return
    end
    self.rechargeSelect:setSelected(false)
    self.goldSelect:setSelected(false)
    self.RechargePanel:setVisible(false)
    self.RechargeGoldPanel:setVisible(false)
    if index == 1 then
        self.RechargePanel:setVisible(true)
        self.rechargeSelect:setSelected(true)
    elseif index ==2 then
        WaitProgress.Show()
        ServiceMessageManager.GetRechargeList()
        self.recodeSelect:setSelected(true)
    elseif index ==3 then
        self.RechargeGoldPanel:setVisible(true)
        self.goldSelect:setSelected(true)
    end

    self.curPanelIndex = index
end

function LayerRecharge:getWidget()
    return "PopUIs/LayerRecharge.csb"
end
function LayerRecharge:onEnter()
    self.super.onEnter(self)

    MessageHandle.addHandle(Enum.RECHARGE_CLIENT, function(msgid,data)
        self.ListView_Recode:removeAllItems()
        local msg = hall_pb.RechargeResponse()
        msg:ParseFromString(data)
        for i = 1, #msg.recharges do
            local cell = cc.CSLoader:createNode('PopUIs/RechargeRecodeCell.csb'):getChildByName("RecodeItem")
            local orderLabel = cell:getChildByName("order")
            local moneyLabel  = cell:getChildByName("money")
            local stateLabel = cell:getChildByName("state")
            local timeLabel = cell:getChildByName("time")

            local item = msg.recharges[i]

            orderLabel:setString(item.rechargeNo)
            moneyLabel:setString(item.money)
            if item.success == 0 then
                stateLabel:setString("支付中")
            elseif item.success == 1 then
                stateLabel:setString("√")
            elseif item.success == 2 then
                stateLabel:setString("×")
            end
            timeLabel:setString(item.dateTime)
            cell:removeFromParent()
            self.ListView_Recode:pushBackCustomItem(cell)
        end
        --        for i = 1, 5 do
        --            local cell = cc.CSLoader:createNode('PopUIs/RechargeRecodeCell.csb'):getChildByName("RecodeItem")
        --            local orderLabel = cell:getChildByName("order")
        --            local moneyLabel  = cell:getChildByName("money")
        --            local stateLabel = cell:getChildByName("state")
        --            local timeLabel = cell:getChildByName("time")

        --            local item = msg.recharges[i]

        --            orderLabel:setString(i)
        --            moneyLabel:setString(99999)
        --            stateLabel:setString("成功")
        --            timeLabel:setString("2017/06/12 17:07")
        --            cell:removeFromParent()
        --            self.ListView_Recode:pushBackCustomItem(cell)
        --        end
        WaitProgress.Close()
        self.RecodePanel:setVisible(true)
    end,self)
end

function LayerRecharge:onExit()
    self.super.onExit(self)
    MessageHandle.removeHandle(self)
end

return LayerRecharge

--endregion
