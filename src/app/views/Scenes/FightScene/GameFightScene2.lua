--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


--通用提示界面
-- User: CongQin
-- Date: 17/07/05

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
local GameFightSceneHelp = require('app.views.Scenes.FightScene.GameFightSceneHelp')
local platformMethod = require('app.Platform.platformMethod')
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

local GameFightScene2 = class("GameFightScene2", require("app.views.Scenes.Common.SceneBase"))

function GameFightScene2:ctor(index)
    GameFightScene2.super.ctor(self)
    self:loadSceneCSB('Scenes/GameFightScene2.csb')
    self:BindNodes(self.root, "Panel_1",
        "Panel_1.Button_1", "Panel_1.Button_6",
        "Panel_1.Text_5", "Panel_1.Text_6", "Panel_1.Text_7", "Panel_1.Text_10",
        "Panel_1.PlayerNode_0", "Panel_1.PlayerNode_1", "Panel_1.PlayerNode_2", "Panel_1.PlayerNode_3", "Panel_1.PlayerNode_4", "Panel_1.PlayerNode_5",
        "Panel_1.Button_ZB", "Panel_1.Button_ZX", "Panel_1.Button_BQ", "Panel_1.Button_YY",
        "Panel_1.Image_tips", "Panel_1.Image_tips.Text_tip", "Panel_1.Image_iconBanker",
        "Panel_1.xhText", "Panel_1.wifiSpr", "Panel_1.battBgSprite", "Panel_1.battImage", "Panel_1.batteryText",
        "Panel_1.Panel_cards",
        "Panel_1.Panel_cards.Image_card01", "Panel_1.Panel_cards.Image_card02",
        "Panel_1.Panel_cards.Image_card03", "Panel_1.Panel_cards.Image_card04",
        "Panel_1.Panel_cards.Image_card05", "Panel_1.Panel_cards.Image_card06",
        "Panel_1.Panel_cards.Image_card07", "Panel_1.Panel_cards.Image_card08",
        "Panel_1.Panel_cards.Image_card09", "Panel_1.Panel_cards.Image_card10",

        "Panel_1.Panel_cards.Image_card11", "Panel_1.Panel_cards.Image_card12",
        "Panel_1.Panel_cards.Image_card13", "Panel_1.Panel_cards.Image_card14",
        "Panel_1.Panel_cards.Image_card15", "Panel_1.Panel_cards.Image_card16",
        "Panel_1.Panel_cards.Image_card17", "Panel_1.Panel_cards.Image_card18",
        "Panel_1.Panel_cards.Image_card19", "Panel_1.Panel_cards.Image_card20",

        "Panel_1.Panel_cards.Image_card21", "Panel_1.Panel_cards.Image_card22",
        "Panel_1.Panel_cards.Image_card23", "Panel_1.Panel_cards.Image_card24",
        "Panel_1.Panel_cards.Image_card25", "Panel_1.Panel_cards.Image_card26",
        "Panel_1.Panel_cards.Image_card27", "Panel_1.Panel_cards.Image_card28",
        "Panel_1.Panel_cards.Image_card29", "Panel_1.Panel_cards.Image_card30",

        "Panel_1.Panel_cards.Button_card1", "Panel_1.Panel_cards.Button_card2",
        "Panel_1.Panel_cards.Button_card1.Text_btncard1", "Panel_1.Panel_cards.Button_card2.Text_btncard2")

    for i = 1, 6 do
        self["PlayerNode_" .. i - 1]:BindNodes(self["PlayerNode_" .. i - 1],
            'Image_1.Image_head',
            'Image_1.Text_name',
            'Image_1.Text_point',
            'Image_1.Panel_1',
            'Image_1.Text_xz_point',
            'Image_1.Image_bankerback',
            "Image_1.Button_Info",
            "Image_1.FileNode_GoldAm")
        if i == 1 then
            self["PlayerNode_" .. i - 1].AnimateTimeLine = cc.CSLoader:createTimeline("Animation/Am_NodeRoomPlayerSelf.csb")
        elseif i == 2 or i == 3 or i == 5 then
            self["PlayerNode_" .. i - 1].AnimateTimeLine = cc.CSLoader:createTimeline("Animation/Am_NodeRoomPlayer.csb")
        else
            self["PlayerNode_" .. i - 1].AnimateTimeLine = cc.CSLoader:createTimeline("Animation/Am_NodeRoomPlayerRight.csb")
        end

        self["PlayerNode_" .. i - 1]:runAction(self["PlayerNode_" .. i - 1].AnimateTimeLine)
        self["PlayerNode_" .. i - 1].FileNode_GoldAm.AnimateTimeLine = cc.CSLoader:createTimeline("Animation/Am_GoldAdd.csb")
        self["PlayerNode_" .. i - 1].FileNode_GoldAm:runAction(self["PlayerNode_" .. i - 1].FileNode_GoldAm.AnimateTimeLine)
    end

    self.AnimateTimeLine = cc.CSLoader:createTimeline("Scenes/GameFightScene2.csb")
    self:runAction(self.AnimateTimeLine)
    self.roomTypeIndex = index

    self:refresh()
    self:initEvent()
    self.schedulerID = nil

    self.Text_10:setString("")
    self.battImage:setVisible(false)
    self.batteryText:setVisible(false)
    self.battBgSprite:setVisible(false)
    self.xhText:setVisible(false)
    self.wifiSpr:setVisible(false)

    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateGame), 1.0, false)
end

--初始化房间
function GameFightScene2:refresh()
    self.Image_iconBanker:setVisible(false)
    self.Panel_cards:setVisible(false)
    self.Button_BQ:setVisible(false)
    self.Button_YY:setVisible(false)
    self.banker = nil
    self.RoomNum = 0
    self.VoiceCoolDown = 0

    self.Button_ZX:setVisible(false)
    self.Button_ZB:setVisible(false)
    self.Image_tips:setVisible(false)
    self.Text_tip:setString("")

    self.BankerAmOver = true

    for i = 1, 6 do
        self["PlayerNode_" .. i - 1]:setVisible(false)
    end

    self:refreshRoomInfo()

    self:checkGameStuat()
    --    self:updateGame()
    --self:checkPlayerStuat()
    --self:refreshPlayerPoint()
end

function GameFightScene2:refreshRoomInfo()
    if FightManager.roomdata ~= nil and FightManager.roomdata.roomNo ~= nil then
        self.Text_5:setString(FightManager.roomdata.roomNo)
    end

    self.Text_6:setString(roomType[self.roomTypeIndex])
    self.Text_7:setString(roomBase[self.roomTypeIndex])
end

function GameFightScene2:initEvent()
    UIHelper.BindClickByButtons({ self.Button_6 }, function(sender, event)
        if sender == self.Button_6 then --规则
            local data4 = roomType[self.roomTypeIndex] .. " "

            local data5 = "五花牛(5倍) 炸弹牛(6倍) 五小牛(8倍) "

            require("app.views.UI.LayerRoomRule").new(self.Text_6:getString(), self.Text_7:getString(), FpRule[1], data4, data5):Show()
        end
    end)

    UIHelper.BindClickByButtons({ self.Button_1 }, function(sender, event)
        self.Button_1:setVisible(false)
        require("app.views.UI.LayerFightSet").new(2):Show():SetCloseCallBack(function(isupdate)
            self.Button_1:setVisible(true)
            if isupdate == 3 then
                if FightManager.roomdata.roomNo ~= nil then

                    if FightManager.roomdata.status > GameStatus.READYING then
                        MessageTip.Show("单局结束后才能离开房间")
                        return
                    end

                    --                    WaitProgress.Show()
                    GameFightSceneHelp.ExitRoom()
                    cc.UserDefault:getInstance():setStringForKey("SinLoveJinBiRoom", "a")
                else --没有坐下直接离开
                    self:CloseAll()
                    local pScene = require("app.views.Scenes.MainScene.MainScene"):new()
                    cc.Director:getInstance():replaceScene(pScene)
                end
            elseif isupdate == 4 then
                --                 WaitProgress.Show()
                GameFightSceneHelp.DeleteRoom()
            elseif isupdate == 5 then
                require("app.views.UI.LayerSetting").new("game"):Show()
            end
        end)
    end)

    UIHelper.BindClickByButtons({ self.Button_ZB, self.Button_ZX, self.Button_BQ }, function(sender, event)
        if sender == self.Button_ZX then --坐下
            self.Button_ZX:setVisible(false)

            PauseStateToLua3 = function(sutat)
                if sutat == 1 then
                    print("连接 金币场 成功-5")
                    FightManager.GameRoomtype = 2
                    local smsg = matching_pb.IntoRequest()
                    smsg.username = PlayerManager.Player.userName -- 1; //用户名
                    smsg.baseScore = tonumber(roomBase[self.roomTypeIndex]) --2;  //底分
                    local msgData = smsg:SerializeToString()
                    MSG.send(Enum.INTO_ROOM_SERVER, msgData, 3)
                    --创建匹配中的动画
                    GameFightSceneHelp.CreateAm_PPZ(self.Panel_1, cc.p(568, 290))
                    GlobalData.isServer3connect = true
                else
                    print("连接 金币场 失败-5")
                end
                PauseStateToLua3 = function() print('PauseStateToLua3') end
            end
            Socket_SetServer(SERVER_NETGATE.ip3, SERVER_NETGATE.port3, 3)
            Socket_Reconnect(3)



        elseif sender == self.Button_ZB then --准备
            if FightManager.roomdata.baseScore == 2 then
                if PlayerManager.Player.gold < 200 then
                    MessageTip.Show("金币不足，不能游戏")
                    return
                end
                cc.UserDefault:getInstance():setStringForKey("SinLoveJinBiRoom", "b")
            elseif FightManager.roomdata.baseScore == 4 then
                if PlayerManager.Player.gold < 600 then
                    MessageTip.Show("金币不足，不能游戏")
                    return
                end
                cc.UserDefault:getInstance():setStringForKey("SinLoveJinBiRoom", "c")
            elseif FightManager.roomdata.baseScore == 8 then
                if PlayerManager.Player.gold < 1200 then
                    MessageTip.Show("金币不足，不能游戏")
                    return
                end
                cc.UserDefault:getInstance():setStringForKey("SinLoveJinBiRoom", "d")
            elseif FightManager.roomdata.baseScore == 16 then
                if PlayerManager.Player.gold < 2500 then
                    MessageTip.Show("金币不足，不能游戏")
                    return
                end
                cc.UserDefault:getInstance():setStringForKey("SinLoveJinBiRoom", "e")
            end
            self.Button_ZB:setVisible(false)
            --            WaitProgress.Show()
            GameFightSceneHelp.GameReady()
        elseif sender == self.Button_BQ then --表情
            require("app.views.UI.LayerFightBQ").new():Show():SetCloseCallBack(function(isupdate)
            end)
        end
    end)

    StopRecodCallback = function(resout)
        if targetPlatform == cc.PLATFORM_OS_ANDROID then
            if resout == "Success" then
                --上传文件
                print("录制成功:" .. cc.FileUtils:getInstance():getWritablePath() .. "update/" .. FightManager.roomdata.roomNo .. "_" .. self["PlayerNode_0"].seatNo .. ".wav")
                upLoadFile(HTTPURL.url .. ":60606/upload/upload", cc.FileUtils:getInstance():getWritablePath() .. "update/" .. FightManager.roomdata.roomNo .. "_" .. self["PlayerNode_0"].seatNo .. ".wav")
            else
                MessageTip.Show("录制时间过短")
            end
        elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then

        else
            if resout == 1 then
                --上传文件
                upLoadFile(HTTPURL.url .. ":60606/upload/upload", cc.FileUtils:getInstance():getWritablePath() .. "update/" .. FightManager.roomdata.roomNo .. "_" .. self["PlayerNode_0"].seatNo .. ".wav")

            else
                MessageTip.Show("录制时间过短")
            end
        end
    end

    uploadResout = function(data)
        local fileData = Json.decode(data)
        if fileData.files[1].url ~= nil then
            GameFightSceneHelp.sendVoice(fileData.files[1].name)
            --上传完成 删除本地的
            os.remove(cc.FileUtils:getInstance():getWritablePath() .. "update/" .. FightManager.roomdata.roomNo .. "_" .. self["PlayerNode_0"].seatNo .. ".wav")
        else
            MessageTip.Show(fileData.files[1].error)
        end
    end
    self.Button_YY:addTouchEventListener(function(btn, event)
        --            MessageTip.Show("金币房间禁止语音")
        if event == TOUCH_EVENT_BEGAN then

            if self.VoiceCoolDown > 0 then
                MessageTip.Show("请稍等片刻")
                return
            end
            self.VoiceCoolDown = 5
            local s = cc.Director:getInstance():getWinSize()
            GameFightSceneHelp.CreateAm_LY(self.Panel_1, cc.p(s.width / 2, s.height / 2), self["PlayerNode_0"].seatNo, StopRecodCallback)
            GameFightSceneHelp.startRecording(self["PlayerNode_0"].seatNo)

        elseif event == TOUCH_EVENT_ENDED then
            if self.Panel_1:getChildByName("voice" .. self["PlayerNode_0"].seatNo) then
                local sprite = self.Panel_1:getChildByName("voice" .. self["PlayerNode_0"].seatNo)
                sprite:removeFromParent()
                --停止录制
                platformMethod.StopRecordSound(StopRecodCallback)
                self.VoiceCoolDown = 5
            end
        elseif event == TOUCH_EVENT_CANCELED then
        end
        return
    end)

    UIHelper.BindClickByButtons({ self.Button_card1, self.Button_card2 }, function(sender, event)
        if sender == self.Button_card1 then
            if self.Text_btncard1:getString() == "准备" then --准备开始下一回合
                if FightManager.roomdata.baseScore == 2 then
                    if PlayerManager.Player.gold < 200 then
                        MessageTip.Show("金币不足，不能游戏")
                        return
                    end
                elseif FightManager.roomdata.baseScore == 4 then
                    if PlayerManager.Player.gold < 600 then
                        MessageTip.Show("金币不足，不能游戏")
                        return
                    end
                elseif FightManager.roomdata.baseScore == 8 then
                    if PlayerManager.Player.gold < 1200 then
                        MessageTip.Show("金币不足，不能游戏")
                        return
                    end
                elseif FightManager.roomdata.baseScore == 16 then
                    if PlayerManager.Player.gold < 2500 then
                        MessageTip.Show("金币不足，不能游戏")
                        return
                    end
                end
                self.Button_card1:setVisible(false)
                GameFightSceneHelp.GameReady()
            elseif self.Text_btncard1:getString() == "搓牌" then
                --                MessageTip.Show("金币房间禁止搓牌")
                local cards = {}
                for i = 1, #FightManager.roomdata.seats do --吧牌添加到自己的座位中

                    if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                        cards = FightManager.roomdata.seats[i].cards
                        if table.getn(cards) == 5 then

                            require("app.views.Scenes.FightScene.GameFightSceneCP2").new(cards):Show():SetCloseCallBack(function(isupdate)
                                self:FlopCard()
                            end)
                        end

                        break
                    end
                end
                return
            elseif self.Text_btncard1:getString() == "提示" then
                self.Button_card1:setVisible(false)
                local cards = GameFightSceneHelp.getcardsByseatNo(self["PlayerNode_" .. 0].seatNo)

                if table.getn(cards) == 5 then
                    local niuniutype = GameFightSceneHelp.orderByRule(self["PlayerNode_" .. 0].seatNo, FightManager.roomdata.smallBull, FightManager.roomdata.bombBull, FightManager.roomdata.threetwoBull, FightManager.roomdata.suitBull, FightManager.roomdata.spottedBull, FightManager.roomdata.straightBull, FightManager.roomdata.doubleBull)
                    cards = GameFightSceneHelp.getcardsByseatNo(self["PlayerNode_" .. 0].seatNo)

                    if niuniutype == 0 then
                        SoundHelper.playMusicSound(94, PlayerManager.Player.sex, false)
                    else
                        SoundHelper.playMusicSound(129 + niuniutype, PlayerManager.Player.sex, false)
                    end
                    self:CardTiShi(cards, niuniutype)
                end
            end
        elseif sender == self.Button_card2 then
            if self.Text_btncard2:getString() == "翻牌" then
                self.Button_card1:setVisible(true)
                self:FlopCard()
            elseif self.Text_btncard2:getString() == "亮牌" then
                self.Button_card1:setVisible(false)
                self.Button_card2:setVisible(false)
                GameFightSceneHelp.showCard()
            end
        end
    end)


    UIHelper.BindClickByButtons({
        self["PlayerNode_0"].Button_Info, self["PlayerNode_1"].Button_Info, self["PlayerNode_2"].Button_Info,
        self["PlayerNode_3"].Button_Info, self["PlayerNode_4"].Button_Info, self["PlayerNode_5"].Button_Info
    }, function(sender, event)
        local seatNo = 0
        if sender == self["PlayerNode_0"].Button_Info then
            seatNo = self["PlayerNode_0"].seatNo
        elseif sender == self["PlayerNode_1"].Button_Info then
            seatNo = self["PlayerNode_1"].seatNo
        elseif sender == self["PlayerNode_2"].Button_Info then
            seatNo = self["PlayerNode_2"].seatNo
        elseif sender == self["PlayerNode_3"].Button_Info then
            seatNo = self["PlayerNode_3"].seatNo
        elseif sender == self["PlayerNode_4"].Button_Info then
            seatNo = self["PlayerNode_4"].seatNo
        elseif sender == self["PlayerNode_5"].Button_Info then
            seatNo = self["PlayerNode_5"].seatNo
        end
        require("app.views.UI.LayerFightUserInfo").new(seatNo):Show()
    end)
end

--判断游戏是否已经开始
function GameFightScene2:checkGameStuat()
    if FightManager.roomdata.roomNo == nil then
        self.Button_card1:setVisible(false)
        self.Button_card2:setVisible(false)
        self.Button_ZB:setVisible(false)
        self.Button_ZB:setEnabled(false)
        self.Button_ZX:setVisible(true)
        self.Button_ZX:setEnabled(true)
    else
        self.Button_card1:setVisible(false)
        self.Button_card2:setVisible(false)
        self.Button_ZX:setVisible(false)
        self.Button_ZX:setEnabled(false)
        self.Button_ZB:setVisible(true)
        self.Button_ZB:setEnabled(true)
    end

    if FightManager.roomdata.status ~= nil and FightManager.roomdata.status > GameStatus.READYING then
        self.Button_ZB:setVisible(false)
    end
end

--绑定玩家信息
function GameFightScene2:checkPlayerStuat()
    --绑定自己的座位信息
    local otherplayerdata = {}
    for i = 1, #FightManager.roomdata.seats do
        if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
            self:refreshPlayerNode(0, true, FightManager.roomdata.seats[i].seatNo)
            --检查玩家是否已经准备
            if FightManager.roomdata.seats[i].ready == true and FightManager.roomdata.status <= 1 then
                self:readyPlayerNode(FightManager.roomdata.seats[i].seatNo)
                self.Button_YY:setVisible(true)
                self.Button_BQ:setVisible(true)
            end
        else
            table.insert(otherplayerdata, FightManager.roomdata.seats[i])
        end
    end
    --绑定其他玩家的座位信息
    for i = 1, #otherplayerdata do
        if self["PlayerNode_" .. i]:isVisible() == false then
            self:refreshPlayerNode(i, true, otherplayerdata[i].seatNo)
            if otherplayerdata[i].ready == true and FightManager.roomdata.status <= 1 then
                self:readyPlayerNode(otherplayerdata[i].seatNo)
            end
        end
    end

    self:refreshPlayerPoint()
end

--刷新玩家分数
function GameFightScene2:refreshPlayerPoint()
    for i = 1, 6 do
        for a = 1, #FightManager.roomdata.seats do
            if self["PlayerNode_" .. i - 1].seatNo ~= nil and FightManager.roomdata.seats[a].seatNo == self["PlayerNode_" .. i - 1].seatNo then
                self["PlayerNode_" .. i - 1].Text_point:setString(FightManager.roomdata.seats[a].gold)

                local name = FightManager.roomdata.seats[a].name

                if Tool.SubStringGetTotalIndex(name) > 4 then
                    name = Tool.SubStringUTF8(name, 0, 4) .. ".."
                end

                self["PlayerNode_" .. i - 1].Text_name:setString(name)

                UIHelper.loadImgUrl(self["PlayerNode_" .. i - 1].Image_head, FightManager.roomdata.seats[a].headPic, FightManager.roomdata.seats[a].userName)
                break
            end
        end
    end
end

--重新设置游戏参数
function GameFightScene2:reSetGame()

    self.Image_tips:setVisible(false)
    self.FlopAmIng = false --是否正在翻牌


    for i = 1, 6 do
        self["PlayerNode_" .. i - 1].AnimateTimeLine:gotoFrameAndPause(0)
        if self["PlayerNode_" .. i - 1]:getChildByTag(2017) ~= nil then
            self["PlayerNode_" .. i - 1]:removeChildByTag(2017)
        end
        if self.Panel_1:getChildByTag(i * 1000 + 1) then
            self.Panel_1:removeChildByTag(i * 1000 + 1)
        end

        if self.Panel_1:getChildByTag(i * 1000 + 2) then
            self.Panel_1:removeChildByTag(i * 1000 + 2)
        end

        if self.Panel_1:getChildByTag(i * 1000 + 3) then
            self.Panel_1:removeChildByTag(i * 1000 + 3)
        end

        if self.Panel_1:getChildByTag(i * 1000 + 4) then
            self.Panel_1:removeChildByTag(i * 1000 + 4)
        end

        if self.Panel_1:getChildByTag(i * 1000 + 5) then
            self.Panel_1:removeChildByTag(i * 1000 + 5)
        end

        if self.Panel_1:getChildByTag(i * 1000 + 1) then
            self.Panel_1:removeChildByTag(i * 1000 + 1)
        end

        if self.Panel_1:getChildByTag(i * 5000 + 2) then
            self.Panel_1:removeChildByTag(i * 1000 + 2)
        end

        if self.Panel_1:getChildByTag(i * 5000 + 3) then
            self.Panel_1:removeChildByTag(i * 1000 + 3)
        end

        if self.Panel_1:getChildByTag(i * 5000 + 4) then
            self.Panel_1:removeChildByTag(i * 1000 + 4)
        end
        if self.Panel_1:getChildByTag(i * 5000 + 5) then
            self.Panel_1:removeChildByTag(i * 5000 + 5)
        end

        if self.Panel_cards:getChildByName("lpresout" .. i - 1) then
            self.Panel_cards:removeChildByName("lpresout" .. i - 1)
        end

        if self["PlayerNode_" .. i - 1]:getChildByName("Am_Qiang") then
            local sprite = self["PlayerNode_" .. i - 1]:getChildByName("Am_Qiang")
            sprite:removeFromParent()
        end

        if i < 6 then
            if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
                self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
            end

            if self.Panel_1:getChildByTag(998 + i) ~= nil then
                self.Panel_1:removeChildByTag(998 + i)
            end
        end
    end



    for i = 1, 30 do
        if i < 10 then
            self["Image_card0" .. i]:setVisible(true)
            self["Image_card0" .. i]:removeAllChildren()
            self["Image_card0" .. i]:loadTexture("fengmian.png", ccui.TextureResType.plistType)
        else
            self["Image_card" .. i]:setVisible(true)
            self["Image_card" .. i]:removeAllChildren()
            self["Image_card" .. i]:loadTexture("fengmian.png", ccui.TextureResType.plistType)
        end
    end
end

--准备游戏
function GameFightScene2:GameReady(seatNo)

    self:refreshPlayerPoint()
    self:readyPlayerNode(seatNo)

    for i = 1, 6 do
        if self["PlayerNode_" .. i - 1].seatNo == seatNo then
            self["PlayerNode_" .. i - 1].AnimateTimeLine:gotoFrameAndPause(0)
            break
        end
    end


    if self["PlayerNode_" .. 0].seatNo == seatNo then
        self.Button_ZX:setVisible(false)
        self.Button_ZB:setVisible(false)
        self.Button_card1:setVisible(false)
        self.Button_YY:setVisible(true)
        self.Button_BQ:setVisible(true)
        if self.schedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil
        end
        self.Image_tips:setVisible(true)
        self.Text_tip:setString("等待其他玩家准备")
        self.RoomNum = FightManager.roomdata.roomNo
        self.seatNo = self["PlayerNode_" .. 0].seatNo
        for i = 1, #FightManager.roomdata.seats do --清空所有座位的卡牌
            FightManager.roomdata.seats[i].cards = {}
        end

        for i = 1, 6 do
            if self.Panel_cards:getChildByName("lpresout" .. i - 1) then
                self.Panel_cards:removeChildByName("lpresout" .. i - 1)
            end
        end

        for i = 1, 30 do
            if i < 10 then
                self["Image_card0" .. i]:setVisible(false)
                self["Image_card0" .. i]:removeAllChildren()
                self["Image_card0" .. i]:loadTexture("fengmian.png", ccui.TextureResType.plistType)
            else
                self["Image_card" .. i]:setVisible(false)
                self["Image_card" .. i]:removeAllChildren()
                self["Image_card" .. i]:loadTexture("fengmian.png", ccui.TextureResType.plistType)
            end
        end
        self.AnimateTimeLine:gotoFrameAndPause(0)
    end
end

--游戏开始
function GameFightScene2:GameStart()

    self:reSetGame()

    self:refreshRoomInfo()
    self:refreshPlayerPoint()




    for i = 1, 6 do
        self["PlayerNode_" .. i - 1].Panel_1:setOpacity(0)
    end


    self.Image_tips:setVisible(true)
    self.Text_tip:setString("游戏开始了")




    for i = 1, #FightManager.roomdata.seats do
        self:putBet(FightManager.roomdata.seats[i].seatNo, FightManager.roomdata.baseScore)
    end
end

--开始抢庄
function GameFightScene2:StartBanker()
    self.Image_tips:setVisible(true)
    self.Button_card1:setVisible(false)
    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
    local time3 = 11

    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, function(dt)
        time3 = time3 - 1
        self.Text_tip:setString("开始抢庄:" .. (time3 - 1))

        if time3 <= 1 then
            for i = 1, 5 do
                if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
                    self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
                end
            end
            self.Image_tips:setVisible(false)
            if self.schedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                self.schedulerID = nil
            end
        end
    end), 1, false)

    --创建明牌抢庄的按钮
    local pos = { [1] = cc.p(340.80, 170), [2] = cc.p(454.40, 170), [3] = cc.p(568.00, 170), [4] = cc.p(681.60, 170), [5] = cc.p(795.20, 170) }
    local str = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "" }
    local pngname = { [1] = "myqz0.png", [2] = "myqz1.png", [3] = "myqz2.png", [4] = "myqz3.png", [5] = "myqz4.png" }
    for i = 1, 5 do
        if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
            self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
        end
        local btn = ccui.Button:create(pngname[i], pngname[i], pngname[i], ccui.TextureResType.plistType)
        btn:ignoreContentAdaptWithSize(false)
        btn:setContentSize(cc.size(100, 70))
        self.Panel_1:addChild(btn)
        btn:setName("qiangzhuangbtn" .. i)
        btn:setPosition(pos[i])

        local score = ccui.Text:create(str[i], DEFAULTFONT, 30)
        btn:addChild(score)
        score:setPosition(cc.p(btn:getCenter().x - 2, btn:getCenter().y))

        UIHelper.BindClickByButtons({ btn }, function(sender, event)
            --抢注钱需要判断玩家金币是否能输得起
            local paygold = GameFightSceneHelp.getMaxGoldPay(i - 1)
            if PlayerManager.Player.gold < GameFightSceneHelp.getMaxGoldPay(i - 1) then
                MessageTip.Show("当前需要金币" .. paygold .. "才能抢" .. i - 1 .. "倍")
                return
            end
            for i = 1, 5 do
                if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
                    self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
                end
            end
            GameFightSceneHelp.StartBanker(i - 1)

            if self.schedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                self.schedulerID = nil
            end
        end)
    end
end

--完成抢庄
function GameFightScene2:BankerEnd(seatNo, grab)
    for i = 1, 6 do
        if self["PlayerNode_" .. i - 1].seatNo == seatNo then
            local isqiang = false
            if grab ~= nil and grab > 0 then
                isqiang = true
            end
            GameFightSceneHelp.CreateAm_QZ(self["PlayerNode_" .. i - 1], isqiang, grab, nil)
        end
    end

    if self["PlayerNode_" .. 0].seatNo == seatNo then
        self.Image_tips:setVisible(true)
        self.Text_tip:setString("等待其他玩家抢庄")
        if self.schedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil
        end


        for i = 1, 5 do
            if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
                self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
            end
        end
    end
end

--设置庄家
function GameFightScene2:setBanker()
    self.BankerAmOver = false
    local bankerNode
    for i = 1, 6 do
        if self["PlayerNode_" .. i - 1].seatNo == FightManager.roomdata.banker then
            bankerNode = self["PlayerNode_" .. i - 1]
            break
        end
    end

    for i = 1, 6 do
        if self["PlayerNode_" .. i - 1]:getChildByName("Am_Qiang") then
            local sprite = self["PlayerNode_" .. i - 1]:getChildByName("Am_Qiang")
            if self["PlayerNode_" .. i - 1] ~= bankerNode then
                sprite:removeFromParent()
            else
                sprite:setVisible(false)
            end
        end
    end

    --执行跑马灯的动画
    local AmTime = 0
    AmTime = AmTime + 0.4305
    SoundHelper.playMusicSound(99, 1, false)
    self.Image_iconBanker:setVisible(false)
    local data = {}
    table.insert(data, self["PlayerNode_0"].Image_bankerback)
    for i = 1, 5 do
        if self["PlayerNode_" .. i]:isVisible() == true then
            AmTime = AmTime + 0.4305
            table.insert(data, self["PlayerNode_" .. i].Image_bankerback)
        end
    end
    self.Panel_1:stopActionByTag(1)
    local action = GameFightSceneHelp.BankerAm(data, bankerNode)
    action:setTag(1)
    self.Panel_1:runAction(action)
    AmTime = AmTime + 50 / 60
    self.banker = FightManager.roomdata.banker

    self.Panel_1:runAction(cc.Sequence:create(cc.DelayTime:create(AmTime), cc.CallFunc:create(function()
        self.Image_tips:setVisible(true)
        local str = ""
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == FightManager.roomdata.banker then
                str = FightManager.roomdata.seats[i].name
                break
            end
        end
        self.Text_tip:setString(str .. "成为了庄家")
        if self.Image_iconBanker:isVisible() == false then
            self.Image_iconBanker:setVisible(true)
        end
        local pos = cc.p(bankerNode:getPositionX(), bankerNode:getPositionY())

        if bankerNode:getChildByName("Am_Qiang") then
            local sprite = bankerNode:getChildByName("Am_Qiang")
            if sprite.beishu ~= nil and sprite.beishu == 0 then
                sprite:setSpriteFrame(cc.Sprite:createWithSpriteFrameName("niuniu_bei1.png"):getSpriteFrame())
            end
            sprite:setVisible(true)
            sprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(sprite:getPositionX() - 85, sprite:getPositionY() + 50)), cc.CallFunc:create(function()
                sprite:setVisible(true)
                sprite:setScale(0.7)
            end)))
        end

        if math.abs(pos.x - (self.Image_iconBanker:getPositionX() - 100)) < 2 then
            self.Image_tips:setVisible(false)
            self.BankerAmOver = true
            self:setBat()
            return
        end

        self.Image_iconBanker:runAction(cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(568, 293)), cc.MoveTo:create(0.5, cc.p(pos.x + 100, pos.y + 50)), cc.CallFunc:create(function()
            self.Image_tips:setVisible(false)
            self.BankerAmOver = true
            self:setBat()
        end)))
    end)))
end

--玩家下注
function GameFightScene2:setBat()
    self.Image_tips:setVisible(true)
    self.banker = FightManager.roomdata.banker
    self.Button_card1:setVisible(false)
    if self["PlayerNode_" .. 0].seatNo == FightManager.roomdata.banker then
        self.Text_tip:setString("等待闲家下注")
    else
        if self.schedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil
        end

        local time2 = 11

        self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, function(dt)
            time2 = time2 - 1
            self.Text_tip:setString("请选择下注分数:" .. (time2 - 1))


            if time2 <= 1 then
                for i = 1, 5 do
                    if self.Panel_1:getChildByTag(998 + i) ~= nil then
                        self.Panel_1:removeChildByTag(998 + i)
                    end
                end
                self.Image_tips:setVisible(false)
                if self.schedulerID ~= nil then
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                    self.schedulerID = nil
                end
            end
        end), 1, false)
        --创建下注的按钮
        local pos2 = { [1] = cc.p(397.60, 170), [2] = cc.p(511.20, 170), [3] = cc.p(624.80, 170), [4] = cc.p(738.40, 170) }
        local scores = { [1] = FightManager.roomdata.baseScore, [2] = FightManager.roomdata.baseScore * 2, [3] = FightManager.roomdata.baseScore * 3, [4] = FightManager.roomdata.baseScore * 4, [5] = FightManager.roomdata.baseScore * 10 }
        for i = 1, 4 do
            if self.Panel_1:getChildByTag(998 + i) ~= nil then
                self.Panel_1:removeChildByTag(998 + i)
            end
            local btn = ccui.Button:create("niuniubtn.png", "niuniubtn.png", "niuniubtn.png", ccui.TextureResType.plistType)
            btn:ignoreContentAdaptWithSize(false)
            btn:setContentSize(cc.size(100, 70))
            self.Panel_1:addChild(btn)
            btn:setTag(998 + i)
            btn:setPosition(pos2[i])
            local score = ccui.Text:create(scores[i], DEFAULTFONT, 35)
            btn:addChild(score)
            score:setPosition(cc.p(btn:getCenter().x - 2, btn:getCenter().y))
            UIHelper.BindClickByButtons({ btn }, function(sender, event)
                for i = 1, 5 do
                    if self.Panel_1:getChildByTag(998 + i) ~= nil then
                        self.Panel_1:removeChildByTag(998 + i)
                    end
                end
                GameFightSceneHelp.putBet(scores[i])
                if self.schedulerID ~= nil then
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                    self.schedulerID = nil
                end
            end)
        end
    end
end

--显示下注结果
function GameFightScene2:putBet(seatNo, score)
    for i = 1, 6 do
        if self["PlayerNode_" .. i - 1].seatNo ~= nil and self["PlayerNode_" .. i - 1].seatNo == seatNo then
            self["PlayerNode_" .. i - 1].Text_xz_point:setString(score)
            self["PlayerNode_" .. i - 1].AnimateTimeLine:play("start", false)
            SoundHelper.playMusicSound(90, 0, false)
        end
    end
    if self["PlayerNode_" .. 0].seatNo == seatNo then
        self.Text_tip:setString("等待其他玩家")
        for i = 1, 5 do
            if self.Panel_1:getChildByTag(998 + i) ~= nil then
                self.Panel_1:removeChildByTag(998 + i)
            end
        end
    end
end

--发牌动画
function GameFightScene2:Licensing()

    self.Button_card1:setVisible(false)
    self.Button_card2:setVisible(false)

    self.FlopAmIng = false

    self.Image_tips:setVisible(true)
    self.Text_tip:setString("开始发牌")

    for i = 1, 5 do
        if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
            self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
        end
        if self.Panel_1:getChildByTag(998 + i) ~= nil then
            self.Panel_1:removeChildByTag(998 + i)
        end
    end

    local cardCount = 0
    for i = 1, #FightManager.roomdata.seats do
        if FightManager.roomdata.seats[i].seatNo == self["PlayerNode_" .. 0].seatNo then
            cardCount = #FightManager.roomdata.seats[i].cards
        end
    end
    --    print("========================"..cardCount)

    if cardCount > 0 then

        self.Panel_cards:setVisible(true)
        local num = #FightManager.roomdata.seats

        if cardCount == 4 then
            self.AnimateTimeLine:play("fapai" .. num .. "_1", false)
        else
            self.AnimateTimeLine:play("fapai2_" .. num, false)
        end
        SoundHelper.playMusicSound(14, 1, false)

        --把没有发的牌隐藏了
        local delaytime = 0
        if num == 2 then
            for i = 1, 20 do
                self["Image_card" .. 10 + i]:setVisible(false)
            end
            delaytime = 60 / 90
        elseif num == 3 then
            for i = 1, 15 do
                self["Image_card" .. 15 + i]:setVisible(false)
            end
            delaytime = 85 / 90
        elseif num == 4 then
            for i = 1, 10 do
                self["Image_card" .. 20 + i]:setVisible(false)
            end
            delaytime = 110 / 90
        elseif num == 5 then
            for i = 1, 5 do
                self["Image_card" .. 25 + i]:setVisible(false)
            end
            delaytime = 135 / 90
        elseif num == 6 then
            delaytime = 160 / 90
        end

        --牌发完了
        self.Panel_cards:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime / 2),
            cc.CallFunc:create(function()
                if cardCount == 4 then
                    self:FlopCard()
                    self:StartBanker()
                else
                    self.Button_card1:setVisible(true)
                    self.Text_btncard1:setString("搓牌")
                    self.Button_card2:setVisible(true)
                    self.Text_btncard2:setString("翻牌")
                    self.FlopAmIng = false
                    self:LookCardTime()
                    for i = 1, 5 do
                        if self["PlayerNode_" .. i].seatNo ~= nil and self["PlayerNode_" .. i]:isVisible() == true then
                            GameFightSceneHelp.CreateAm_CPZ(self["PlayerNode_" .. i])
                        end
                    end
                end
            end)))
        return delaytime
    end
end

--查看手牌倒计时
function GameFightScene2:LookCardTime()
    for i = 1, 5 do
        if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
            self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
        end
        if self.Panel_1:getChildByTag(998 + i) ~= nil then
            self.Panel_1:removeChildByTag(998 + i)
        end
    end

    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end

    local time4 = 11
    self.Image_tips:setVisible(true)

    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, function(dt)
        time4 = time4 - 1
        self.Text_tip:setString("查看手牌:" .. (time4 - 1))

        if time4 <= 1 then
            self.Button_card1:setVisible(false)
            self.Button_card2:setVisible(false)
            self.Image_tips:setVisible(false)
            if self.schedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                self.schedulerID = nil
            end
        end
    end), 1, false)
end

--翻牌动画
function GameFightScene2:FlopCard()

    if self.FlopAmIng == false then


        self.FlopAmIng = true


        local cards = {}
        for i = 1, #FightManager.roomdata.seats do --吧牌添加到自己的座位中

            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                cards = FightManager.roomdata.seats[i].cards
                break
            end
        end


        if table.getn(cards) == 4 or table.getn(cards) == 5 then

            for i = 1, #cards do
                if self["Image_card0" .. i]:getChildrenCount() < 1 then
                    local openAnim = cc.Sequence:create(cc.OrbitCamera:create(0.2, 1, 0, 0, 90, 0, 0),
                        cc.CallFunc:create(function()
                            local spr = cards[i].cardColor .. "_" .. cards[i].value .. ".png"
                            local cardSpr = cc.Sprite:createWithSpriteFrameName(spr)
                            self["Image_card0" .. i]:addChild(cardSpr)
                            --cardSpr:setScale(1/3)
                            cardSpr:setAnchorPoint(cc.p(0, 0))
                        end),
                        cc.OrbitCamera:create(0.2, 1, 0, 270, 90, 0, 0),
                        cc.CallFunc:create(function()
                            --                    if table.getn(cards)==5 then
                            --                    self.Button_card1:setVisible(true)
                            --                    end
                            self.Text_btncard2:setString("亮牌")
                            self.Text_btncard1:setString("提示")
                        end))
                    self["Image_card0" .. i]:runAction(openAnim)
                end
            end
        end
    end
end

--卡牌提示
function GameFightScene2:CardTiShi(cards, cardstype)
    for i = 1, #cards do
        self["Image_card0" .. i]:removeAllChildren()
        self["Image_card0" .. i]:loadTexture(cards[i].cardColor .. "_" .. cards[i].value .. ".png", ccui.TextureResType.plistType)
        if i == 1 then
            self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 - 120, 80))))
        elseif i == 2 then
            self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 - 60, 80))))
        elseif i == 4 then
            self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 + 60 + 20, 80))))
        elseif i == 5 then
            self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 + 120 + 20, 80))))
        end
    end

    if self.Panel_cards:getChildByName("lpresout" .. 0) then
        self.Panel_cards:removeChildByName("lpresout" .. 0)
    end

    local node = cc.Node:create()
    node:setName("lpresout" .. 0)
    self.Panel_cards:addChild(node)
    node:setPosition(cc.p(self["Image_card0" .. 3]:getPositionX(), self["Image_card0" .. 3]:getPositionY() - 30))

    local sprite = cc.Sprite:createWithSpriteFrameName(NIUNIUTYPE[cardstype])
    node:addChild(sprite)

    GameFightSceneHelp.CreateAm_TSNIUNIU(node, cardstype, false)

    --如果有倍数吧倍数加上去
    local str = GameFightSceneHelp.getniuniuTypenum(cardstype, true, true, true, false, 1)
    if str ~= nil then
        local child = cc.Sprite:createWithSpriteFrameName(str)
        node:add(child)
        child:setPositionX(100)
    end
end

--亮牌动画
function GameFightScene2:OpenCardAm(seatNo)
    if self["PlayerNode_" .. 0].seatNo == seatNo then
        self.Button_card1:setVisible(false)
        self.Button_card2:setVisible(false)
        if self.schedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil
        end

        self.Text_tip:setString("等待其他玩家亮牌")

        local cards = GameFightSceneHelp.getcardsByseatNo(seatNo)
        if table.getn(cards) == 5 then
            local niuniutype = GameFightSceneHelp.orderByRule(seatNo, FightManager.roomdata.smallBull, FightManager.roomdata.bombBull, FightManager.roomdata.threetwoBull, FightManager.roomdata.suitBull, FightManager.roomdata.spottedBull, FightManager.roomdata.straightBull, FightManager.roomdata.doubleBull)
            cards = GameFightSceneHelp.getcardsByseatNo(seatNo)

            if niuniutype == 0 then
                SoundHelper.playMusicSound(94, GameFightSceneHelp.getsexByseatNo(seatNo), false)
            else
                SoundHelper.playMusicSound(129 + niuniutype, GameFightSceneHelp.getsexByseatNo(seatNo), false)
            end
            self:CardTiShi(cards, niuniutype)
        end
    end


    for i = 1, 5 do
        local node = cc.Node:create()
        if self["PlayerNode_" .. i].seatNo == seatNo and self["PlayerNode_" .. i]:getChildByName("Am_CPZ") then
            local sprite = self["PlayerNode_" .. i]:getChildByName("Am_CPZ")
            sprite:removeFromParent()
        end
        --根据座位号取得卡组信息
        local cards = GameFightSceneHelp.getcardsByseatNo(seatNo)
        --吧牌显示出来
        if table.getn(cards) == 5 then
            local niuniutype = GameFightSceneHelp.orderByRule(seatNo, true, true, true, false)
            cards = GameFightSceneHelp.getcardsByseatNo(seatNo)

            if self["PlayerNode_" .. i].seatNo == seatNo and self["PlayerNode_" .. i].seatNo == FightManager.roomdata.banker then
                --庄家亮牌最后亮
                if self.Panel_cards:getChildByName("lpresoutWC") then
                    self.Panel_cards:removeChildByName("lpresoutWC")
                end
                local sprite = cc.Sprite:createWithSpriteFrameName("niuniu_img26.png")
                node:addChild(sprite)
                self.Panel_cards:addChild(node)
                node:setName("lpresoutWC")

                if i == 1 then
                    node:setPosition(cc.p(self["Image_card0" .. 8]:getPositionX(), self["Image_card0" .. 8]:getPositionY() - 30))
                else
                    node:setPosition(cc.p(self["Image_card" .. 8 + (i - 1) * 5]:getPositionX(), self["Image_card" .. 8 + (i - 1) * 5]:getPositionY() - 30))
                end
                GameFightSceneHelp.CreateAm_TSNIUNIU(node, 0, true)
                node:setScale(0.7)
            elseif self["PlayerNode_" .. i].seatNo == seatNo then

                for a = 1, 5 do
                    if i == 1 then
                        if a == 5 then
                            self["Image_card" .. 5 + a]:loadTexture(cards[a].cardColor .. "_" .. cards[a].value .. ".png", ccui.TextureResType.plistType)
                        else
                            self["Image_card0" .. 5 + a]:loadTexture(cards[a].cardColor .. "_" .. cards[a].value .. ".png", ccui.TextureResType.plistType)
                        end
                        if niuniutype ~= 0 and a == 4 then
                            self["Image_card0" .. 5 + a]:setPositionX(self["Image_card0" .. 5 + a]:getPositionX() + 10)
                        end

                        if niuniutype ~= 0 and a == 5 then
                            self["Image_card" .. 5 + a]:setPositionX(self["Image_card" .. 5 + a]:getPositionX() + 10)
                        end
                    else
                        self["Image_card" .. 5 * i + a]:loadTexture(cards[a].cardColor .. "_" .. cards[a].value .. ".png", ccui.TextureResType.plistType)

                        if niuniutype ~= 0 and a == 4 or niuniutype ~= 0 and a == 5 then
                            self["Image_card" .. 5 * i + a]:setPositionX(self["Image_card" .. 5 * i + a]:getPositionX() + 10)
                        end
                    end
                end

                if self.Panel_cards:getChildByName("lpresout" .. i) then
                    self.Panel_cards:removeChildByName("lpresout" .. i)
                end

                local sprite = cc.Sprite:createWithSpriteFrameName(NIUNIUTYPE[niuniutype])
                node:addChild(sprite)
                self.Panel_cards:addChild(node)
                node:setName("lpresout" .. i)

                if i == 1 then
                    node:setPosition(cc.p(self["Image_card0" .. 8]:getPositionX(), self["Image_card0" .. 8]:getPositionY() - 30))
                else
                    node:setPosition(cc.p(self["Image_card" .. 8 + (i - 1) * 5]:getPositionX(), self["Image_card" .. 8 + (i - 1) * 5]:getPositionY() - 30))
                end
                node:setScale(0.7)

                --如果有倍数吧倍数加上去
                local str = GameFightSceneHelp.getniuniuTypenum(niuniutype, true, true, true, false, 1)
                if str ~= nil then
                    local child = cc.Sprite:createWithSpriteFrameName(str)
                    node:add(child)
                    child:setPositionX(90)
                end

                if niuniutype == 0 then
                    SoundHelper.playMusicSound(94, GameFightSceneHelp.getsexByseatNo(seatNo), false)
                else
                    SoundHelper.playMusicSound(129 + niuniutype, GameFightSceneHelp.getsexByseatNo(seatNo), false)
                end

                GameFightSceneHelp.CreateAm_TSNIUNIU(node, niuniutype, fasle)
            end
        end
    end
end

--开始比牌
function GameFightScene2:Settlement(jumpToZb)
    --金币加减
    local delayTime = 1
    self.Image_tips:setVisible(true)
    self.Panel_cards:setVisible(true)
    self.Text_tip:setString("开始比牌")
    self.Button_card1:setVisible(false)
    self.Button_card2:setVisible(false)

    --所有人亮牌
    if self.Panel_cards:getChildByName("lpresoutWC") then
        self.Panel_cards:removeChildByName("lpresoutWC")
    end

    if #FightManager.resoutdata > 0 then
        for i = 1, #FightManager.resoutdata do
            for a = 1, 6 do
                if self["PlayerNode_" .. a - 1].seatNo ~= nil and self["PlayerNode_" .. a - 1].seatNo == FightManager.resoutdata[i].seatNo and FightManager.resoutdata[i].seatNo == FightManager.roomdata.banker then
                    if FightManager.resoutdata[i].value == 0 then
                        SoundHelper.playMusicSound(94, FightManager.resoutdata[i].sex, false)
                    else
                        SoundHelper.playMusicSound(129 + FightManager.resoutdata[i].value, FightManager.resoutdata[i].sex, false)
                    end
                end
            end

            for a = 1, 5 do
                if self["PlayerNode_" .. a].seatNo ~= nil and self["PlayerNode_" .. a].seatNo == FightManager.resoutdata[i].seatNo and FightManager.resoutdata[i].seatNo == FightManager.roomdata.banker then
                    local cards = FightManager.resoutdata[i].cards
                    --吧牌显示出来
                    for b = 1, 5 do
                        if a == 1 then
                            if b == 5 then
                                self["Image_card" .. 5 + b]:loadTexture(cards[b].cardColor .. "_" .. cards[b].value .. ".png", ccui.TextureResType.plistType)
                            else
                                self["Image_card0" .. 5 + b]:loadTexture(cards[b].cardColor .. "_" .. cards[b].value .. ".png", ccui.TextureResType.plistType)
                            end
                            if FightManager.resoutdata[i].value ~= 0 and b == 4 then
                                self["Image_card0" .. 5 + b]:setPositionX(self["Image_card0" .. 5 + b]:getPositionX() + 10)
                            end

                            if FightManager.resoutdata[i].value ~= 0 and b == 5 then
                                self["Image_card" .. 5 + b]:setPositionX(self["Image_card" .. 5 + b]:getPositionX() + 10)
                            end
                        else
                            self["Image_card" .. 5 * a + b]:loadTexture(cards[b].cardColor .. "_" .. cards[b].value .. ".png", ccui.TextureResType.plistType)

                            if FightManager.resoutdata[i].value ~= 0 and b == 4 or FightManager.resoutdata[i].value ~= 0 and b == 5 then
                                self["Image_card" .. 5 * a + b]:setPositionX(self["Image_card" .. 5 * a + b]:getPositionX() + 10)
                            end
                        end
                    end

                    if self.Panel_cards:getChildByName("lpresout" .. a) then
                        self.Panel_cards:removeChildByName("lpresout" .. a)
                    end

                    local node = cc.Node:create()
                    self.Panel_cards:addChild(node)
                    node:setName("lpresout" .. a)
                    if a == 1 then
                        node:setPosition(cc.p(self["Image_card0" .. 8]:getPositionX(), self["Image_card0" .. 8]:getPositionY() - 30))
                    else
                        node:setPosition(cc.p(self["Image_card" .. 8 + (a - 1) * 5]:getPositionX(), self["Image_card" .. 8 + (a - 1) * 5]:getPositionY() - 30))
                    end

                    local sprite = cc.Sprite:createWithSpriteFrameName(NIUNIUTYPE[FightManager.resoutdata[i].value])
                    node:addChild(sprite)
                    node:setScale(0.7)

                    --如果有倍数吧倍数加上去
                    local str = GameFightSceneHelp.getniuniuTypenum(FightManager.resoutdata[i].value, true, true, true, false, 1)
                    if str ~= nil then
                        local child = cc.Sprite:createWithSpriteFrameName(str)
                        node:add(child)
                        child:setPositionX(90)
                    end
                    GameFightSceneHelp.CreateAm_TSNIUNIU(node, FightManager.resoutdata[i].value, false)
                end
            end
        end
    end

    if jumpToZb == nil then
        --取得庄家的位置
        local bankerNode = nil
        local LoseNode = {}
        local WinNode = {}
        if #FightManager.resoutdata > 0 then
            for i = 1, #FightManager.resoutdata do
                for a = 1, 6 do
                    if self["PlayerNode_" .. a - 1].seatNo ~= nil and self["PlayerNode_" .. a - 1].seatNo == FightManager.roomdata.banker then
                        bankerNode = self["PlayerNode_" .. a - 1]
                    end

                    if self["PlayerNode_" .. a - 1].seatNo ~= nil and self["PlayerNode_" .. a - 1].seatNo == FightManager.resoutdata[i].seatNo and self["PlayerNode_" .. a - 1].seatNo ~= FightManager.roomdata.banker then
                        if FightManager.resoutdata[i].score < 0 then
                            table.insert(LoseNode, self["PlayerNode_" .. a - 1])
                        elseif FightManager.resoutdata[i].score > 0 then
                            table.insert(WinNode, self["PlayerNode_" .. a - 1])
                        end
                    end
                end
            end
        end
        --先飞庄家赢得金币
        for i = 1, #LoseNode do
            for a = 1, 10 do
                local gold = cc.Sprite:createWithSpriteFrameName("niuniu_img16.png")
                self.Panel_1:addChild(gold)
                gold:setScale(0.64)
                gold:setPosition(LoseNode[i]:getPosition())
                gold:setTag(i * 1000 + a)
                gold:setOpacity(0)
                local bezier = GameFightSceneHelp.GetBezier(cc.p(LoseNode[i]:getPositionX(), LoseNode[i]:getPositionY()), cc.p(bankerNode:getPositionX(), bankerNode:getPositionY()))
                gold:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime + 0.2 + a * 0.05), cc.FadeIn:create(0), cc.BezierTo:create(0.55, bezier),
                    cc.CallFunc:create(function()
                        gold:removeFromParent()
                    end)))
            end
            self.Panel_1:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime + 0.2 + 2 * 0.05), cc.CallFunc:create(function()
                SoundHelper.playMusicSound(15, 0, false)
            end)))
        end

        if #LoseNode >= 1 then
            delayTime = delayTime + 1
            self.Panel_1:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime), cc.CallFunc:create(function()
                bankerNode.FileNode_GoldAm.AnimateTimeLine:play("play", false)
            end)))
        end

        --在飞庄家输的金币
        for i = 1, #WinNode do
            for a = 1, 10 do
                local gold = cc.Sprite:createWithSpriteFrameName("niuniu_img16.png")
                self.Panel_1:addChild(gold)
                gold:setScale(0.64)
                gold:setPosition(bankerNode:getPosition())
                gold:setTag(i * 5000 + a)
                gold:setOpacity(0)
                local bezier = GameFightSceneHelp.GetBezier(cc.p(bankerNode:getPositionX(), bankerNode:getPositionY()), cc.p(WinNode[i]:getPositionX(), WinNode[i]:getPositionY()))
                gold:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime + 0.2 + a * 0.05), cc.FadeIn:create(0), cc.BezierTo:create(0.55, bezier),
                    cc.CallFunc:create(function()
                        gold:removeFromParent()
                    end)))
            end
            self.Panel_1:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime + 0.2 + 2 * 0.05), cc.CallFunc:create(function()
                SoundHelper.playMusicSound(15, 0, false)
            end)))

            self.Panel_1:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime + 1), cc.CallFunc:create(function()
                WinNode[i].FileNode_GoldAm.AnimateTimeLine:play("play", false)
            end)))
        end

        if WinNode ~= nil and #WinNode >= 1 then
            delayTime = delayTime + 1
        end

        self.Panel_cards:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime),
            cc.CallFunc:create(function()
                if #FightManager.resoutdata > 0 then
                    for i = 1, #FightManager.resoutdata do
                        for a = 1, 6 do
                            if self["PlayerNode_" .. a - 1].seatNo ~= nil and self["PlayerNode_" .. a - 1].seatNo == FightManager.resoutdata[i].seatNo then
                                if self["PlayerNode_" .. a - 1]:getChildByTag(2017) ~= nil then
                                    self["PlayerNode_" .. a - 1]:removeChildByTag(2017)
                                end
                                local sprite = GameFightSceneHelp.getnumber(FightManager.resoutdata[i].score)
                                self["PlayerNode_" .. a - 1]:addChild(sprite)
                                sprite:setTag(2017)
                                sprite:setPosition(cc.p(self["PlayerNode_" .. a - 1]:getCenter().x, self["PlayerNode_" .. a - 1]:getCenter().y + 75))
                                break
                            end
                        end
                    end
                end
            end)))
    end
    self.Panel_cards:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime + 1),
        cc.CallFunc:create(function()
            self:refreshPlayerPoint()


            if self.schedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                self.schedulerID = nil
            end
            local time1 = 31
            self.Image_tips:setVisible(true)

            self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, function(dt)
                time1 = time1 - 1
                self.Text_tip:setString((time1 - 1) .. "秒后没准备会自动退出")
                FightManager.roomdata.status = 1


                if time1 <= 1 then
                    self.Button_card1:setVisible(false)
                    self.Image_tips:setVisible(false)
                    if self.schedulerID ~= nil then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                        self.schedulerID = nil
                    end
                end
            end), 1, false)

            self.Button_card1:setVisible(true)
            self.Text_btncard1:setString("准备")
        end)))
end

function GameFightScene2:updateGame(dt)
    --      下一行有错误
    self.Text_10:setString(os.date("%H:%M")) --设置时间
    if dt ~= nil and self.VoiceCoolDown > 0 then
        --声音发送冷却倒计时
        self.VoiceCoolDown = self.VoiceCoolDown - dt
    end

    local batteryNum = platformMethod.getBattery() -- 获取电量
    local wifi = platformMethod.GetNetwork() --获取网络信号

    local num = tonumber(batteryNum)
    if batteryNum and num then
        self.batteryText:setString(batteryNum .. "%")
        local width = 43.5 * num / 100
        self.battImage:setContentSize(cc.size(width, 18))
        self.battImage:setVisible(true)
        self.batteryText:setVisible(true)
        self.battBgSprite:setVisible(true)
    else
        self.battImage:setVisible(false)
        self.batteryText:setVisible(false)
        self.battBgSprite:setVisible(false)
    end

    if wifi then
        if wifi == "WIFI" then
            self.xhText:setVisible(false)
            self.wifiSpr:setVisible(true)
        else
            self.xhText:setVisible(true)
            self.wifiSpr:setVisible(false)
            self.xhText:setString(wifi)
        end
    else
        self.xhText:setVisible(false)
        self.wifiSpr:setVisible(false)
    end
end

function GameFightScene2:refreshPlayerNode(index, isVisible, seatNo)
    self["PlayerNode_" .. index]:setVisible(isVisible)
    self["PlayerNode_" .. index].seatNo = seatNo

    --清除金币加减数字
    if self["PlayerNode_" .. index]:getChildByTag(2017) ~= nil then
        self["PlayerNode_" .. index]:removeChildByTag(2017)
    end

    --清除庄家图片
    local pos = cc.p(self["PlayerNode_" .. index]:getPositionX(), self["PlayerNode_" .. index]:getPositionY())
    if math.abs(pos.x - (self.Image_iconBanker:getPositionX() - 100)) < 2 then
        if self.Image_iconBanker:isVisible() == true then
            self.Image_iconBanker:setVisible(false)
        end
    end
end

function GameFightScene2:readyPlayerNode(seatNo)
    for i = 1, 6 do
        if self["PlayerNode_" .. i - 1].seatNo == seatNo and self["PlayerNode_" .. i - 1].AnimateTimeLine:getCurrentFrame() < 50 then

            self["PlayerNode_" .. i - 1].AnimateTimeLine:play("ready", false)
            break
        end
    end
end

function GameFightScene2:onEnterTransitionFinish()

    self.super.onEnterTransitionFinish(self)
    if SoundHelper.isMusicPlaying() then
        SoundHelper.stopMusic()
    end

    SoundHelper.playMusicSound(87, 0, true)
end

function GameFightScene2:onEnter()
    self.super.onEnter(self)
    --收到进入房间消息

    MessageHandle.addHandle(Enum.INTO_ROOM_CLIENT, function(msgid, data)

        WaitProgress.Close()
        self.Text_tip:setString("房间加入成功,请尽快准备")
        MessageTip.Show("房间加入成功,请尽快准备")
        if self.Panel_1:getChildByName("Am_FJPPZ") then
            local sprite = self.Panel_1:getChildByName("Am_FJPPZ")
            sprite:removeFromParent()
        end
        --10秒准备倒计时（时间到了自动退出）
        if FightManager.roomdata.status ~= nil and FightManager.roomdata.status <= 1 then

            self.Image_tips:setVisible(true)
            if self.schedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                self.schedulerID = nil
            end

            local time5 = 31

            self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, function(dt)
                time5 = time5 - 1

                self.Text_tip:setString((time5 - 1) .. "秒后没准备会自动退出")
                if time5 <= 1 then
                    GameFightSceneHelp.ExitRoom()
                    if self.schedulerID ~= nil then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                        self.schedulerID = nil
                    end
                end
            end), 1, false)
        else
        end

        self:checkGameStuat()
        self:checkPlayerStuat()
        self:refreshRoomInfo()
        self:refreshPlayerPoint()
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                --检查玩家是否已经准备
                if FightManager.roomdata.seats[i].ready == true and FightManager.roomdata.status <= GameStatus.READYING then
                    self:GameReady(FightManager.roomdata.seats[i].seatNo)
                end
            end
        end
    end, self)

    --收到有人进入消息
    MessageHandle.addHandle(Enum.ADD_ROOM_CLIENT, function(msgid, data)
        --        WaitProgress.Close()
        if FightManager.roomdata.roomNo == nil then
            return
        end

        self:checkPlayerStuat()
    end, self)

    --收到有人离开消息
    MessageHandle.addHandle(Enum.EXIT_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = matching_pb.ExitResponse()
        cmsg:ParseFromString(data)

        if cmsg.seatNo == 0 or self["PlayerNode_" .. 0]:isVisible() == true and self["PlayerNode_" .. 0].seatNo == cmsg.seatNo then
            self:CloseAll()
            local pScene = require("app.views.Scenes.MainScene.MainScene"):new()
            cc.Director:getInstance():replaceScene(pScene)
            return
        end

        for i = 1, 5 do
            self["PlayerNode_" .. i]:setVisible(false)
            self["PlayerNode_" .. i].seatNo = nil
            self["PlayerNode_" .. i].Image_head:removeAllChildren()
            self["PlayerNode_" .. i].AnimateTimeLine:gotoFrameAndPause(0)
        end

        self:checkPlayerStuat()
    end, self)

    --收到准备消息
    MessageHandle.addHandle(Enum.READY_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = matching_pb.ReadyResponse()
        cmsg:ParseFromString(data)
        self:GameReady(cmsg.seatNo)
    end, self)



    --收到清牌消息
    MessageHandle.addHandle(Enum.COMPLETE_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.ReadyResponse()
        cmsg:ParseFromString(data)
        self:cleanPai(cmsg.seatNo)
    end, self)



    --收到开始游戏消息
    MessageHandle.addHandle(Enum.START_CLIENT, function(msgid, data)
        WaitProgress.Close()
        if FightManager.roomdata.roomNo == nil then
            return
        end


        self:GameStart()
    end, self)

    --收到抢庄游戏消息
    MessageHandle.addHandle(Enum.GRAB_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = matching_pb.GrabResponse()
        cmsg:ParseFromString(data)
        self:BankerEnd(cmsg.seatNo, cmsg.grab)
    end, self)


    --收到确定庄家游戏消息
    MessageHandle.addHandle(Enum.SET_BANKER_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end


        self:setBanker()
    end, self)

    --收到玩家下注游戏消息
    MessageHandle.addHandle(Enum.PLAY_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = matching_pb.PlayResponse()
        cmsg:ParseFromString(data)
        self:putBet(cmsg.seatNo, cmsg.playScore)
    end, self)

    --收到发牌游戏消息
    MessageHandle.addHandle(Enum.DEAL_CARD_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end

        self:Licensing()
    end, self)

    --收到亮牌游戏消息
    MessageHandle.addHandle(Enum.OPEN_CARD_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = matching_pb.OpenCardResponse()
        cmsg:ParseFromString(data)
        self:OpenCardAm(cmsg.seatNo)
    end, self)

    --收到开始比牌游戏消息
    MessageHandle.addHandle(Enum.RESULT_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end


        self:Settlement()
    end, self)

    --收到玩家互动消息
    MessageHandle.addHandle(Enum.INTERACTION_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = matching_pb.InteractionResponse()
        cmsg:ParseFromString(data)

        local startPos = cc.p(0, 0)
        local endPos = cc.p(0, 0)
        for i = 1, 6 do
            if self["PlayerNode_" .. i - 1]:isVisible() == true and self["PlayerNode_" .. i - 1].seatNo ~= nil and self["PlayerNode_" .. i - 1].seatNo == cmsg.seatNo then
                startPos = cc.p(self["PlayerNode_" .. i - 1]:getPositionX(), self["PlayerNode_" .. i - 1]:getPositionY())
            end

            if self["PlayerNode_" .. i - 1]:isVisible() == true and self["PlayerNode_" .. i - 1].seatNo ~= nil and self["PlayerNode_" .. i - 1].seatNo == cmsg.otherSeatNo then
                endPos = cc.p(self["PlayerNode_" .. i - 1]:getPositionX(), self["PlayerNode_" .. i - 1]:getPositionY())
            end
        end
        print("seatNo:" .. cmsg.seatNo .. "—otherseatNo:" .. cmsg.otherSeatNo)
        GameFightSceneHelp.CreateAm_Hd(self.Panel_1, startPos, endPos, cmsg.seatNo, cmsg.otherSeatNo, cmsg.content, GameFightSceneHelp.getsexByseatNo(cmsg.seatNo))
    end, self)

    --收到玩家表情提示语
    MessageHandle.addHandle(Enum.IMG_TEXT_CLIENT, function(msgid, data)
        --        WaitProgress.Close()
        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = matching_pb.ImgTextResponse()
        cmsg:ParseFromString(data)
        local startPos = cc.p(0, 0)
        for i = 1, 6 do
            if self["PlayerNode_" .. i - 1]:isVisible() == true and self["PlayerNode_" .. i - 1].seatNo ~= nil and self["PlayerNode_" .. i - 1].seatNo == cmsg.seatNo then
                startPos = cc.p(self["PlayerNode_" .. i - 1]:getPositionX(), self["PlayerNode_" .. i - 1]:getPositionY())
            end
        end
        if cmsg.img == true then
            GameFightSceneHelp.CreateAm_BQ(self.Panel_1, startPos, cmsg.seatNo, cmsg.content)
        else
            GameFightSceneHelp.CreateAm_TSY(self.Panel_1, startPos, cmsg.seatNo, cmsg.content)
            SoundHelper.playMusicSound(cmsg.content, GameFightSceneHelp.getsexByseatNo(cmsg.seatNo), false)
        end
    end, self)

    --收到玩家语音
    MessageHandle.addHandle(Enum.VOICE_CLIENT, function(msgid, data)
        --        WaitProgress.Close()
        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.VoiceResponse()
        cmsg:ParseFromString(data)

        local time = platformMethod.PlaySound("http://" .. HTTPURL.url .. ":60606/file/" .. FightManager.roomdata.roomNo .. "/" .. cmsg.content)

        --执行语音播放动画
        local startPos = cc.p(0, 0)
        for i = 1, 6 do
            if self["PlayerNode_" .. i - 1]:isVisible() == true and self["PlayerNode_" .. i - 1].seatNo ~= nil and self["PlayerNode_" .. i - 1].seatNo == cmsg.seatNo then
                startPos = cc.p(self["PlayerNode_" .. i - 1]:getPositionX(), self["PlayerNode_" .. i - 1]:getPositionY())
            end
        end
        if time == nil then
            time = 5
        end
        GameFightSceneHelp.CreateAm_VoiceF(self.Panel_1, startPos, cmsg.seatNo, time / 10)
    end, self)
end

function GameFightScene2:CloseAll()
    FightManager.roomdata = {}
    if self.scheduler ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.scheduler)
        self.scheduler = nil
    end
    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end
    MessageHandle.removeHandle(self)
end

function GameFightScene2:onExit()
    self.super.onExit(self)
    self:CloseAll()
end

return GameFightScene2

--endregion
