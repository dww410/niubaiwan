--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--解散房间界面
-- User: CongQin
-- Date: 17/06/13
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerDissolveRoom = class("LayerDissolveRoom", require("app.views.UI.PopUI"))
function LayerDissolveRoom:ctor(name)
    LayerDissolveRoom.super.ctor(self)
    self:BindNodes(self.WidgetNode, "Panel_1", "Panel_1.BG", "Panel_1.BG.Button_1", "Panel_1.BG.Button_2", "Panel_1.BG.LoadingBar_1", "Panel_1.BG.Text_2",
        "Panel_1.BG.ListView", "Panel_1.BG.Button_2.Text_5")
    self.Name = name
    self:refresh()
    self:initEvent()
    self.CloseType = 0
    self.Updated = false
    self.cooltime = 0
    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateGame), 1 / 60, false)
end

function LayerDissolveRoom:getWidget()
    return "PopUIs/LayerDissolveRoom.csb"
end


function LayerDissolveRoom:updateGame(dt)
    local JsTime = 30
    self.LoadingBar_1:setPercent(100 - ((self.cooltime * 100) / tonumber(JsTime)))
    self.cooltime = self.cooltime + dt
    local coldtime = tonumber(JsTime) - self.cooltime
    if coldtime <= 0 then
        coldtime = 0
    end

    if self.cooltime >= tonumber(JsTime) - 2 then
        self.Button_1:setVisible(false)
        self.Button_2:setVisible(false)
    else
        self.Text_5:setString("同意(" .. math.floor(coldtime) .. ")")
    end


    if self.cooltime >= tonumber(JsTime) then
        if self.schedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil
        end
    end
end

function LayerDissolveRoom:refresh()
    local isbtnvisible = false
    for i = 1, #FightManager.roomdata.seats do
        if self.Name == FightManager.roomdata.seats[i].userName then
            local name = FightManager.roomdata.seats[i].name
            if Tool.SubStringGetTotalIndex(name) > 4 then
                name = Tool.SubStringUTF8(name, 0, 4) .. ".."
            end
            self.Text_2:setString(name)
        end

        if PlayerManager.Player.userName == FightManager.roomdata.seats[i].userName then
            isbtnvisible = true
        end
    end

    if isbtnvisible == false then
        self.Button_1:setVisible(false)
        self.Button_2:setVisible(false)
    end

    if self.Name == PlayerManager.Player.userName or self.Name == PlayerManager.Player.name then
        self.Button_1:setVisible(false)
        self.Button_2:setVisible(false)
    end

    local PlayerNum = #FightManager.roomdata.seats

    self.ListView:setContentSize(cc.size(114 * PlayerNum, self.ListView:getContentSize().height))

    for i = 1, PlayerNum do
        local cell = cc.CSLoader:createNode('Components/Cell_DissolveRoom.csb'):getChildByName("Panel_1")
        cell:removeFromParent()
        self.ListView:pushBackCustomItem(cell)
        self:refreshCell(cell, i, 0, false)
    end
end

function LayerDissolveRoom:initEvent()
    UIHelper.BindClickByButtons({ self.Button_1, self.Button_2 }, function(sender, event)
        if sender == self.Button_1 then
            --            WaitProgress.Show()
            local smsg = game_pb.DeleteConfirmRequest()
            smsg.agree = false
            local msgData = smsg:SerializeToString()
            MSG.send(Enum.DELETE_CONFIRM_SERVER, msgData, 2)
            --self:Close()
        elseif sender == self.Button_2 then
            --            WaitProgress.Show()
            local smsg = game_pb.DeleteConfirmRequest()
            smsg.agree = true
            local msgData = smsg:SerializeToString()
            MSG.send(Enum.DELETE_CONFIRM_SERVER, msgData, 2)
            --self:Close()
        end
    end)
end


--跟新cell显示的信息
function LayerDissolveRoom:refreshCell(cell, i, seatNo, agree)
    local data = FightManager.roomdata.seats[i]
    if cell == nil then
        cell = self.ListView:getItem(i - 1)
    end

    local name = data.name
    if Tool.SubStringGetTotalIndex(name) > 4 then
        name = Tool.SubStringUTF8(name, 0, 4) .. ".."
    end

    UIHelper.loadImgUrl(UIHelper.getNode(cell, { "Image_1" }), data.headPic, data.userName)
    UIHelper.getNode(cell, { "Text_1" }):setString(name)
    if data.seatNo == seatNo and agree == true or data.userName == self.Name or data.name == self.Name then
        UIHelper.getNode(cell, { "Image_2" }):loadTexture("niuniu_img24.png", ccui.TextureResType.plistType)
    elseif data.seatNo == seatNo and agree == false then
        UIHelper.getNode(cell, { "Image_2" }):loadTexture("niuniu_img25.png", ccui.TextureResType.plistType)
    end
end

function LayerDissolveRoom:onEnter()
    self.super.onEnter(self)
    --收到解散游戏投票同意消息
    MessageHandle.addHandle(Enum.DELETE_CONFIRM_CLIENT, function(msgid, data)
        WaitProgress.Close()
        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.DeleteConfirmResponse()
        cmsg:ParseFromString(data)

        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName and cmsg.seatNo == FightManager.roomdata.seats[i].seatNo then
                self.Button_1:setVisible(false)
                self.Button_2:setVisible(false)
                break
            end
        end

        for i = 1, #FightManager.roomdata.seats do
            self:refreshCell(nil, i, cmsg.seatNo, cmsg.agree)
        end
    end, self)

    --收到解散成功游戏消息
    MessageHandle.addHandle(Enum.DELETED_CLIENT, function(msgid, data)
        WaitProgress.Close()
        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.DeletedResponse()
        cmsg:ParseFromString(data)
        if cmsg.deleted == false then
            self.Panel_1:runAction(cc.Sequence:create(cc.DelayTime:create(2),
                cc.CallFunc:create(function()
                    self:Close()
                end)))
        end
    end, self)

    --收到游戏结束消息
    MessageHandle.addHandle(Enum.OVER_CLIENT, function(msgid, data)
        WaitProgress.Close()
        if FightManager.roomdata.roomNo == nil then
            return
        end
        self:Close()
    end, self)
end

function LayerDissolveRoom:onExit()
    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
    self.super.onExit(self)
    MessageHandle.removeHandle(self)
end

return LayerDissolveRoom

--endregion
