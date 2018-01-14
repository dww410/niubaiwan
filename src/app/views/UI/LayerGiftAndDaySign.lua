--region LayerGiftAndDaySign.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 充签到面板
--create by niyinguo
--Date: 2017/06/09

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerGiftAndDaySign = class("LayerGiftAndDaySign", require("app.views.UI.PopUI"))
function LayerGiftAndDaySign:ctor(text,btncanelvisible)
    LayerGiftAndDaySign.super.ctor(self)
    self:BindNodes(self.WidgetNode,
    "Panel_1.Button_Close",
    "Panel_1.SignButton",
    "Panel_1.GiftButton",
    "Panel_1.DaySignPanel",
    "Panel_1.DaySignPanel.Sign_0",
    "Panel_1.DaySignPanel.Sign_1",
    "Panel_1.DaySignPanel.Sign_2",
    "Panel_1.DaySignPanel.Sign_3",
    "Panel_1.DaySignPanel.Sign_4",
    "Panel_1.DaySignPanel.Sign_5",
    "Panel_1.DaySignPanel.Sign_6",
    "Panel_1.DaySignPanel.SignPanelButton",
    "Panel_1.DaySignPanel.SignPanelButton.Text_11_0",
    "Panel_1.DaySignPanel.Text_11",
    "Panel_1.RecodePanel",
    "Panel_1.RecodePanel.GetGiftButton",
    "Panel_1.RecodePanel.GetGiftButton.Text_20_0",
    "Panel_1.RecodePanel.Text_20_0_0"
    )


    UIHelper.BindClickByButtons({self.Button_Close,self.SignPanelButton,self.GetGiftButton},function(sender,event)
        if sender == self.Button_Close then
            self:Close()
        elseif sender == self.SignPanelButton then
            --签到
            ServiceMessageManager.GetEveryDayGift()
        elseif sender == self.GetGiftButton then
            --领取救济金
            ServiceMessageManager.GetHelpGift()
        end
    end)

    self.curPanelIndex = 2
    self.SignButton:addEventListener(function(sender,event)
        self.SignButton:setSelected(true)
        self.GiftButton:setSelected(false)
        self:showPanelIndex(1,false)
        SoundHelper.playMusicSound(65,0,false)
    end)
    self.GiftButton:addEventListener(function(sender,event)
        self.SignButton:setSelected(false)
        self.GiftButton:setSelected(true)
        self:showPanelIndex(2,false)
        SoundHelper.playMusicSound(65,0,false)
    end)

    for i = 1, 7 do
        UIHelper.getNode(self["Sign_"..(i-1)],{"SignMark"}):setVisible(false)
--        UIHelper.BindClickByButton(self["Sign_"..(i-1)],function(sender,event)
--            print("Sign_"..(i-1))
--        end)
    end
    
    self:showPanelIndex(1,false)
end

function LayerGiftAndDaySign:showPanelIndex(index,isUpdate)
    if self.curPanelIndex == index and isUpdate==false then
        return
    end
    self.DaySignPanel:setVisible(false)
    self.RecodePanel:setVisible(false)
    if index == 1 then
       self.DaySignPanel:setVisible(true)

        if GlobalData.RecordOpenSignTime == -1 then
       --游戏启动后第一次打开
       GlobalData.RecordOpenSignTime = tonumber(os.date("%d"))
        else
           local curTime = tonumber(os.date("%d"))
           if curTime~= GlobalData.RecordOpenSignTime then
              PlayerManager.Player.reward = 1
              PlayerManager.Player.benefit = 3
              print("RecordOpenSignTime："..GlobalData.RecordOpenSignTime)
           end
        end

       if  PlayerManager.Player.reward == 0 then
           self.SignPanelButton:setEnabled(false)
           self.Text_11_0:setString("已签到")
       else 
           self.SignPanelButton:setEnabled(true)
           self.Text_11_0:setString("签到")
       end

       self.Text_11:setString("累计第"..PlayerManager.Player.days.."天")

       for i = 1, PlayerManager.Player.days do
           UIHelper.getNode(self["Sign_"..(i-1)],{"SignMark"}):setVisible(true)
       end
       
    elseif index ==2 then
       self.RecodePanel:setVisible(true)


       if PlayerManager.Player.gold<5000 then
           if PlayerManager.Player.benefit == 0 then
              self.GetGiftButton:setEnabled(false)
              self.Text_20_0:setString("已领取")
           else
              self.GetGiftButton:setEnabled(true)
              self.Text_20_0:setString("可领取")
           end
       else
            self.GetGiftButton:setEnabled(false)
            self.Text_20_0:setString("不可领取")
       end
       self.Text_20_0_0:setString("今日领取次数:"..PlayerManager.Player.benefit.."/3")
    end

    self.curPanelIndex = index
end

function LayerGiftAndDaySign:getWidget()
    return "PopUIs/LayerGiftAndDaySign.csb"
end

function LayerGiftAndDaySign:onEnter()
   self.super.onEnter() 
    MessageHandle.addHandle(Enum.RECEIVE_GOLD_CLIENT,function(msgid,data)
        local cmsg = hall_pb.ReceiveGoldResponse()
        cmsg:ParseFromString(data)
        MessageTip.Show("获得金币:"..cmsg.gold) 
        PlayerManager.Player.reward = 0
        PlayerManager.Player.days = PlayerManager.Player.days+1

        self:showPanelIndex(1,true)
    end,self)

    MessageHandle.addHandle(Enum.RECEIVE_BENEFIT_CLIENT,function(msgid,data)
        local cmsg = hall_pb.ReceiveBenefitResponse()
        cmsg:ParseFromString(data)
        MessageTip.Show("获得金币:"..cmsg.gold) 
        PlayerManager.Player.benefit = PlayerManager.Player.benefit-1
        self:showPanelIndex(2,true)
    end,self)
end

function LayerGiftAndDaySign:onExit()
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListener(self.listener1)
    self.super.onExit(self)
    MessageHandle.removeHandle(self)
end

return LayerGiftAndDaySign

--endregion
