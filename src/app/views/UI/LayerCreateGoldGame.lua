--region LayerCreateGoldGame.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 金币模式
--create by niyinguo
--Date: 2017/06/09

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerCreateGoldGame = class("LayerCreateGoldGame", require("app.views.UI.PopUI"))
function LayerCreateGoldGame:ctor(text, btncanelvisible)
    LayerCreateGoldGame.super.ctor(self)
    self:BindNodes(self.WidgetNode,
        "Node.Panel_1.Button_Close",
        "Node.Panel_1.Button_Create",
        "Node.Panel_1.GameRoomButton0",
        "Node.Panel_1.GameRoomButton1",
        "Node.Panel_1.GameRoomButton2",
        "Node.Panel_1.GameRoomButton3")

    self.roomIndex = -1

    --191 191 191 255 255 255
    UIHelper.BindClickByButtons({ self.Button_Close, self.Button_Create, self.GameRoomButton0, self.GameRoomButton1, self.GameRoomButton2, self.GameRoomButton3 }, function(sender, event)
        if sender == self.Button_Close then
            self:Close()
        elseif sender == self.Button_Create then
            --加入
            if self.roomIndex == 0 then
                if PlayerManager.Player.gold < 200 then
                    self:shortGold()
                    return
                end
            elseif self.roomIndex == 1 then
                if PlayerManager.Player.gold < 600 then
                    self:shortGold()
                    return
                end
            elseif self.roomIndex == 2 then
                if PlayerManager.Player.gold < 1200 then
                    self:shortGold()
                    return
                end
            elseif self.roomIndex == 3 then
                if PlayerManager.Player.gold < 2500 then
                    self:shortGold()
                    return
                end
            end

            local pScene = require("app.views.Scenes.FightScene.GameFightScene2").new(self.roomIndex)
            cc.Director:getInstance():replaceScene(pScene)

        elseif sender == self.GameRoomButton0 then
            self:setSelectRoom(0)
        elseif sender == self.GameRoomButton1 then
            self:setSelectRoom(1)
        elseif sender == self.GameRoomButton2 then
            self:setSelectRoom(2)
        elseif sender == self.GameRoomButton3 then
            self:setSelectRoom(3)
        end
    end)
    self:setSelectRoom(0)
end

function LayerCreateGoldGame:shortGold()
    MessageTip.Show("抱歉！金币不足")
    --    local layer = require("app.views.UI.LayerTips").new("是否跳转到商城购买?", true):Show():SetCloseCallBack(function(isupdata)
    --        if isupdata == true then
    --            require("app.views.UI.LayerRecharge").new():Show():showPanelIndex(3)
    --        end
    --    end)
end

function LayerCreateGoldGame:connetGoldRoom(baseScore)

    PauseStateToLua3 = function(sutat)
        if sutat == 1 then
            print("连接 金币场 成功-5")
            WaitProgress.Show()
            FightManager.GameRoomtype = 2
            local smsg = matching_pb.IntoRequest()
            smsg.username = PlayerManager.Player.userName -- 1; //用户名
            smsg.baseScore = baseScore --2;  //底分
            local msgData = smsg:SerializeToString()
            MSG.send(Enum.INTO_ROOM_SERVER, msgData, 3)
            GlobalData.isServer3connect = true
        else
            print("连接 金币场 失败-5")
        end
        PauseStateToLua3 = function() print('PauseStateToLua3') end
    end
end

function LayerCreateGoldGame:setSelectRoom(roomIndex)
    if roomIndex == self.roomIndex then
        return
    end
    self.GameRoomButton0:setColor(cc.c3b(191, 191, 191))
    self.GameRoomButton1:setColor(cc.c3b(191, 191, 191))
    self.GameRoomButton2:setColor(cc.c3b(191, 191, 191))
    self.GameRoomButton3:setColor(cc.c3b(191, 191, 191))

    self.roomIndex = roomIndex
    self["GameRoomButton" .. self.roomIndex]:setColor(cc.c3b(255, 255, 255))
end

function LayerCreateGoldGame:getWidget()
    return "PopUIs/LayerCreateGoldGame.csb"
end

function LayerCreateGoldGame:onEnter()
    self.super.onEnter()
end

function LayerCreateGoldGame:onExit()
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListener(self.listener1)
    self.super.onExit(self)
end

return LayerCreateGoldGame

--endregion
