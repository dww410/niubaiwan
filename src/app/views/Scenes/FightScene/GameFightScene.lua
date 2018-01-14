local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
local GameFightSceneHelp = require('app.views.Scenes.FightScene.GameFightSceneHelp')
local platformMethod = require('app.Platform.platformMethod')
local targetPlatform = cc.Application:getInstance():getTargetPlatform()

local GameFightScene = class("GameFightScene", require("app.views.Scenes.Common.SceneBase"))
function GameFightScene:ctor()
    GameFightScene.super.ctor(self)
    self:loadSceneCSB('Scenes/GameFightScene.csb')
    self:BindNodes(self.root, "Panel_1",
        "Panel_1.Button_1", "Panel_1.Button_6",
        "Panel_1.Text_5", "Panel_1.Text_6", "Panel_1.Text_7", "Panel_1.Text_8", "Panel_1.Text_10",
        "Panel_1.PlayerNode_0", "Panel_1.PlayerNode_1", "Panel_1.PlayerNode_2", "Panel_1.PlayerNode_3", "Panel_1.PlayerNode_4", "Panel_1.PlayerNode_5",
        "Panel_1.Button_KS", "Panel_1.Button_YQ", "Panel_1.Button_ZX", "Panel_1.Button_BQ", "Panel_1.Button_YY", "Panel_1.Button_PG", "Panel_1.Button_XJ",
        "Panel_1.Image_tips", "Panel_1.Image_tips.Text_tip", "Panel_1.Image_iconBanker", "Panel_1.battBgSprite", "Panel_1.battImage", "Panel_1.batteryText",
        "Panel_1.xhText", "Panel_1.wifiSpr",
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

    self.AnimateTimeLine = cc.CSLoader:createTimeline("Scenes/GameFightScene.csb")
    self:runAction(self.AnimateTimeLine)
    self:refresh()
    self:initEvent()
    self.schedulerID = nil
    self.JoinAtMiddle = false


    self.Text_10:setString("")
    self.xhText:setVisible(false)
    self.wifiSpr:setVisible(false)
    self.battImage:setVisible(false)
    self.batteryText:setVisible(false)
    self.battBgSprite:setVisible(false)



    print("==================Loginstatus====" .. FightManager.roomdata.status)

    local JsTime = 0


    self:updateGame()
    self.scheduler = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, self.updateGame), 1.0, false)
end

function GameFightScene:refreshRoomInfo()
    if FightManager.roomdata ~= nil and FightManager.roomdata.roomNo ~= nil then
        self.Text_5:setString(FightManager.roomdata.roomNo)
        self.Text_6:setString(GameType[FightManager.roomdata.gameType])
        if FightManager.roomdata.gameType ~= 5 then
            self.Text_7:setString(FightManager.roomdata.baseScore .. "/" .. 2 * FightManager.roomdata.baseScore)
        else
            self.Text_7:setString(FightManager.roomdata.baseScore)
        end
        self.Text_8:setString(FightManager.roomdata.round .. "/" .. FightManager.roomdata.totalRound)
    end
end



function GameFightScene:refresh()

    self:refreshRoomInfo()

    for i = 1, 6 do
        self["PlayerNode_" .. i - 1]:setVisible(false)
    end

    for i = 1, 5 do
        if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
            self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
        end

        if self.Panel_1:getChildByTag(998 + i) ~= nil then
            self.Panel_1:removeChildByTag(998 + i)
        end
    end

    self.Image_iconBanker:setVisible(false)

    self.Panel_cards:setVisible(false)

    self.Button_BQ:setVisible(false)
    self.Button_YY:setVisible(false)

    self.Button_PG:setVisible(false)
    self.Button_XJ:setVisible(false)

    self.Button_card1:setVisible(false)
    self.Button_card2:setVisible(false)

    self.Button_ZX:setVisible(false)

    self.Button_YQ:setVisible(false)
    self.Button_KS:setVisible(false)

    self.Image_tips:setVisible(false)
    self.Text_tip:setString("")

    self.FlopCuoPai = false --允许搓牌
    self.FlopAmIng = false --允许翻牌
    self.MyFp = false --允许发牌

    self.banker = nil
    self.VoiceCoolDown = 0
    self.BankerAmOver = true

    --    self:refreshPlayerPoint() 刷新玩家分数
    self:checkGameStuat()
    self:checkPlayerStuat()
    --    self:updateGame()
end

function GameFightScene:initEvent()
    UIHelper.BindClickByButtons({ self.Button_6 }, function(sender, event)
        if sender == self.Button_6 then --规则
            local data4 = roomRule[FightManager.roomdata.payType] .. " "

            if FightManager.roomdata.playerPush == true then
                data4 = data4 .. "闲家推注 "
            end

            if FightManager.roomdata.startedInto == true then
                data4 = data4 .. "游戏开始后禁止加入 "
            end


            local data5 = ""

            if FightManager.roomdata.doubleBull == true then
                data5 = data5 .. "对子牛(4倍) "
            end

            if FightManager.roomdata.straightBull == true then
                data5 = data5 .. "顺子牛(5倍) "
            end
            if FightManager.roomdata.spottedBull == true then
                data5 = data5 .. "五花牛(5倍) \n"
            end
            if FightManager.roomdata.suitBull == true then
                data5 = data5 .. "同花牛(6倍) "
            end
            if FightManager.roomdata.threetwoBull == true then
                data5 = data5 .. "葫芦牛(7倍) "
            end

            if FightManager.roomdata.bombBull == true then
                data5 = data5 .. "炸弹牛(8倍) \n"
            end

            if FightManager.roomdata.smallBull == true then
                data5 = data5 .. "快乐牛(10倍) "
            end

            require("app.views.UI.LayerRoomRule").new(self.Text_6:getString(), self.Text_7:getString(), FpRule[FightManager.roomdata.rule], data4, data5):Show()
        end
    end)

    UIHelper.BindClickByButtons({ self.Button_1 }, function(sender, event)
        self.Button_1:setVisible(false)
        require("app.views.UI.LayerFightSet").new():Show():SetCloseCallBack(function(isupdate)
            self.Button_1:setVisible(true)
            if isupdate == 3 then --退出房间
                local isset = false
                for i = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                        isset = true
                        break
                    end
                end
                if FightManager.roomdata.round > 0 and isset == true then
                    ServiceMessageManager.GetRoomList()
                    return
                end
                GameFightSceneHelp.ExitRoom()
            elseif isupdate == 4 then
                local isset = false
                for i = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName and FightManager.roomdata.round > 0 and self.JoinAtMiddle == false then
                        isset = true
                        break
                    end
                end

                if FightManager.roomdata.roomOwner == PlayerManager.Player.userName then
                    isset = true
                end

                if isset == true then
                    GameFightSceneHelp.DeleteRoom()
                else
                    MessageTip.Show("您不是房主，无权解散房间")
                end
            elseif isupdate == 5 then
                require("app.views.UI.LayerSetting").new("game"):Show()
            end
        end)
    end)

    UIHelper.BindClickByButtons({ self.Button_KS, self.Button_YQ, self.Button_ZX, self.Button_BQ }, function(sender, event)
        if sender == self.Button_KS then --开始游戏


            self.Button_KS:setVisible(false)
            self.Button_YQ:setVisible(false)

            GameFightSceneHelp.GameStart()


        elseif sender == self.Button_ZX then --坐下
            self.Button_ZX:setVisible(false)
            if #FightManager.roomdata.seats < 6 then
                GameFightSceneHelp.Sitdown()
            else
                self.Button_PG:setVisible(true)
                self.Image_tips:setVisible(true)
                self.Text_tip:setString("本房间人数已满")
                MessageTip.Show("房间人数已满")
            end

        elseif sender == self.Button_YQ then --邀请
            local shareStr = ""
            shareStr = "我开了" .. FightManager.roomdata.totalRound .. "局、" .. self.Text_6:getString() .. "（底分：" .. self.Text_7:getString() .. "）的房间，快来和美女一起玩吧【点我下载】"
            ServiceMessageManager.WeChatShare(FightManager.roomdata.roomNo, APP_INFO.appname .. "◆房间号【" .. FightManager.roomdata.roomNo .. "】", shareStr, "", 0, 5)

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
    end)

    UIHelper.BindClickByButtons({ self.Button_card1, self.Button_card2 }, function(sender, event)
        if sender == self.Button_card1 then
            if self.Text_btncard1:getString() == "准备" then --准备开始下一回合
                self.Button_card1:setVisible(false)

                if FightManager.roomdata.round ~= nil and tonumber(FightManager.roomdata.round) > 0 then
                    self.Button_YQ:setVisible(false)
                end
                GameFightSceneHelp.GameReady()


            elseif self.Text_btncard1:getString() == "搓牌" then
                self.MyFp = false

                if self.FlopCuoPai == false then
                    self.FlopCuoPai = true

                    if FightManager.roomdata.disableTouchCard == true then
                        MessageTip.Show("该房间禁止搓牌")
                        return
                    end

                    local cards = {}
                    for i = 1, #FightManager.roomdata.seats do --吧牌添加到自己的座位中

                        if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                            cards = FightManager.roomdata.seats[i].cards
                            if table.getn(cards) == 5 then

                                self["Image_card01"]:setVisible(false)
                                self["Image_card02"]:setVisible(false)
                                self["Image_card03"]:setVisible(false)
                                self["Image_card04"]:setVisible(false)
                                self["Image_card05"]:setVisible(false)

                                if FightManager.roomdata.gameType ~= 4 then
                                    require("app.views.Scenes.FightScene.GameFightSceneCP").new(cards):Show():SetCloseCallBack(function(isupdate)
                                        self:FlopCard()
                                    end)
                                else
                                    require("app.views.Scenes.FightScene.GameFightSceneCP2").new(cards):Show():SetCloseCallBack(function(isupdate)
                                        self:FlopCard()
                                    end)
                                end
                            end
                        end
                    end
                end

            elseif self.Text_btncard1:getString() == "提示" then
                self.Button_card1:setVisible(false)
                self.MyFp = false
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

                if FightManager.roomdata.disableTouchCard == true then
                    self.Button_card1:setVisible(true)
                end
                self.FlopCuoPai = true
                self.MyFp = false
                self:FlopCard()
            elseif self.Text_btncard2:getString() == "亮牌" then
                self.Button_card1:setVisible(false)
                self.Button_card2:setVisible(false)
                self.MyFp = false
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
function GameFightScene:checkGameStuat()


    self.Button_PG:setVisible(false)
    self.Button_XJ:setVisible(false)
    self.Button_ZX:setVisible(false)
    self.Button_YQ:setVisible(false)

    self.Button_card1:setVisible(false)
    self.Button_card2:setVisible(false)


    local IsGOPEN = 0
    if tonumber(FightManager.roomdata.round) == 0 and FightManager.roomdata.status == GameStatus.WAITING then
        IsGOPEN = 0
    else
        IsGOPEN = 1
    end

    local MySitD = 0
    for i = 1, #FightManager.roomdata.seats do
        if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
            MySitD = 1
        end
    end


    if MySitD == 0 then

        if tonumber(FightManager.roomdata.round) > 0 then
            --                if FightManager.roomdata.status>1  then
            self.Button_PG:setVisible(true)
            --                end
        end

        if #FightManager.roomdata.seats < 6 then
            self.Button_ZX:setVisible(true)
        end



        --                if #FightManager.roomdata.seats < 6 then
        --                self.Image_tips:setVisible(true)
        --                self.Text_tip:setString("坐下后加入游戏")
        --                else
        --                self.Image_tips:setVisible(true)
        --                self.Text_tip:setString("本房间人数已满")
        --                end
    end
end

--绑定玩家信息
function GameFightScene:checkPlayerStuat()
    --绑定自己的座位信息



    local allplayerdata = {}
    for i = 1, #FightManager.roomdata.seats do
        table.insert(allplayerdata, FightManager.roomdata.seats[i])
    end

    local MyIsZx = 0
    local otherplayerdata = {}
    for i = 1, #allplayerdata do
        if allplayerdata[i].userName == PlayerManager.Player.userName then
            MyIsZx = 1
            self:refreshPlayerNode(0, true, allplayerdata[i].seatNo)
            if allplayerdata[i].ready == true and FightManager.roomdata.status <= 1 then
                self:readyPlayerNode(allplayerdata[i].seatNo)
                self.Button_YY:setVisible(true)
                self.Button_BQ:setVisible(true)
            end
        else
            table.insert(otherplayerdata, allplayerdata[i])
        end
    end




    --- -    绑定其他玩家的座位信息

    if #allplayerdata < 6 or MyIsZx == 1 then
        for i = 1, #otherplayerdata do
            if self["PlayerNode_" .. i]:isVisible() == false then
                self:refreshPlayerNode(i, true, otherplayerdata[i].seatNo)
                if otherplayerdata[i].ready == true and FightManager.roomdata.status <= 1 then
                    self:readyPlayerNode(otherplayerdata[i].seatNo)
                end
            end
        end
    else
        for i = 1, #otherplayerdata do
            if self["PlayerNode_" .. i - 1]:isVisible() == false then
                self:refreshPlayerNode(i - 1, true, otherplayerdata[i].seatNo)
                if otherplayerdata[i].ready == true and FightManager.roomdata.status <= 1 then
                    self:readyPlayerNode(otherplayerdata[i].seatNo)
                end
            end
        end
    end





    self:refreshPlayerPoint()
end

--刷新玩家分数
function GameFightScene:refreshPlayerPoint()
    if FightManager.roomdata.seats ~= nil then
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
end



--游戏准备消息
function GameFightScene:GameReady(seatNo)
    if self["PlayerNode_" .. 0].seatNo == seatNo then

        print("=================GameReady=status---" .. FightManager.roomdata.status)

        if FightManager.roomdata.status == 0 or FightManager.roomdata.status == 1 or FightManager.roomdata.status == 5 then


            if self.schedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                self.schedulerID = nil
            end

            SoundHelper.playMusicSound(100, 0, false)

            for i = 1, #FightManager.roomdata.seats do
                FightManager.roomdata.seats[i].cards = {}
            end

            self:reSetGame()



            self.Button_XJ:setVisible(false)
            self.Button_ZX:setVisible(false)
            self.Button_card1:setVisible(false)
            self.Button_card2:setVisible(false)
            self.Button_YY:setVisible(true)
            self.Button_BQ:setVisible(true)

            self.FlopCuoPai = false --允许搓牌
            self.FlopAmIng = false --允许翻牌
            self.MyFp = false --允许发牌

            self.RoomNum = FightManager.roomdata.roomNo

            self.totalRound = FightManager.roomdata.round - 1
            self.baseScore = FightManager.roomdata.baseScore
            self.gameType = FightManager.roomdata.gameType

            self.seatNo = self["PlayerNode_" .. 0].seatNo

            self:readyPlayerNode(seatNo)

            self.AnimateTimeLine:gotoFrameAndPause(0)
            self.JoinAtMiddle = false

            self.Image_tips:setVisible(true)
            self.Text_tip:setString("等待其他玩家准备")
        end
    end
end



--重新进入开始
function GameFightScene:GameStartAgain()

    print("=================GameStartAgain=status---" .. FightManager.roomdata.status)

    for i = 1, 6 do
        self["PlayerNode_" .. i - 1].Panel_1:setOpacity(0)
        self["PlayerNode_" .. i - 1].AnimateTimeLine:gotoFrameAndPause(0)
    end


    self.Button_card1:setVisible(false)
    self.Button_card2:setVisible(false)
    self.Button_ZX:setVisible(false)
    self.Button_YQ:setVisible(false)



    self.FlopCuoPai = false --允许搓牌
    self.FlopAmIng = false --允许翻牌
    self.MyFp = false --允许发牌


    self:refreshRoomInfo() --刷新牌局信息
    self:refreshPlayerPoint() --刷新玩家分数

    self.Image_tips:setVisible(true)


    if FightManager.roomdata.gameType == 3 and FightManager.roomdata.status == 2 then
        self:StartBanker()
    end

    if FightManager.roomdata.gameType == 5 and FightManager.roomdata.status == 4 then
        for i = 1, #FightManager.roomdata.seats do
            self:putBet(FightManager.roomdata.seats[i].seatNo, FightManager.roomdata.baseScore)
        end
    end
end





--游戏开始
function GameFightScene:GameStart()

    print("=================GameStart=status---" .. FightManager.roomdata.status)

    if self.schedulerID ~= nil then
        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
        self.schedulerID = nil
    end

    SoundHelper.playMusicSound(88, 0, false)

    for i = 1, #FightManager.roomdata.seats do
        FightManager.roomdata.seats[i].cards = {}
        if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
            self:readyPlayerNode(FightManager.roomdata.seats[i].seatNo)
            self.AnimateTimeLine:gotoFrameAndPause(0)
            self.JoinAtMiddle = false
        end
    end

    self.Button_KS:setVisible(false)

    self.RoomNum = FightManager.roomdata.roomNo
    self.totalRound = FightManager.roomdata.round - 1
    self.baseScore = FightManager.roomdata.baseScore
    self.gameType = FightManager.roomdata.gameType

    self.seatNo = self["PlayerNode_" .. 0].seatNo




    self:reSetGame()
    self:refreshRoomInfo()
    self:refreshPlayerPoint()

    self.Image_tips:setVisible(true)
    self.Text_tip:setString("游戏开始了")

    if FightManager.roomdata.gameType == 3 and FightManager.roomdata.status == 2 then
        self:StartBanker()
    end

    if FightManager.roomdata.gameType == 5 and FightManager.roomdata.status == 4 then
        for i = 1, #FightManager.roomdata.seats do
            self:putBet(FightManager.roomdata.seats[i].seatNo, FightManager.roomdata.baseScore)
        end
    end
end





--重新设置游戏参数
function GameFightScene:reSetGame()

    self.Button_card1:setVisible(false)
    self.Button_card2:setVisible(false)
    self.Button_ZX:setVisible(false)
    self.Button_YQ:setVisible(false)

    self.FlopCuoPai = false --允许搓牌
    self.FlopAmIng = false --允许翻牌
    self.MyFp = false --允许发牌

    for i = 1, #FightManager.roomdata.seats do
        FightManager.roomdata.seats[i].cards = {}
    end

    for i = 1, 6 do

        self["PlayerNode_" .. i - 1].Panel_1:setOpacity(0)
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
    end

    for i = 1, 5 do
        if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
            self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
        end

        if self.Panel_1:getChildByTag(998 + i) ~= nil then
            self.Panel_1:removeChildByTag(998 + i)
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




--开始抢庄
function GameFightScene:StartBanker()


    for i = 1, #FightManager.roomdata.seats do
        if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
            self.Button_KS:setVisible(false)
            self.Button_ZX:setVisible(false)
            self.Button_YQ:setVisible(false)
            self.Button_PG:setVisible(false)
            self.Button_XJ:setVisible(false)
            self.Button_card1:setVisible(false)
            self.Button_card2:setVisible(false)
        end
    end
    for i = 1, 5 do
        if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
            self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
        end
        if self.Panel_1:getChildByTag(998 + i) ~= nil then
            self.Panel_1:removeChildByTag(998 + i)
        end
    end


    self.Image_tips:setVisible(true)
    self.Text_tip:setString("开始抢庄")



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

    local JsTime = 10


    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, function(dt)
        JsTime = JsTime - 1
        self.Text_tip:setString("开始抢庄:" .. JsTime)
        SoundHelper.playMusicSound(101, 0, false)

        if JsTime <= 0 then
            self.Image_tips:setVisible(false)
            for i = 1, 5 do
                if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
                    self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
                end
            end

            if self.schedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                self.schedulerID = nil
            end
        end
    end), 1, false)



    --    print("==================B"..FightManager.roomdata.status)


    --创建自由抢庄的按钮
    if FightManager.roomdata.gameType == 3 and self["PlayerNode_" .. 0].seatNo ~= nil then
        local pos2 = { [1] = cc.p(511.20, 190), [2] = cc.p(624.80, 190) }
        local str = { [1] = "不抢", [2] = "抢" }
        local pngname = { [1] = "niuniubtn.png", [2] = "niuniubtn.png" }
        for i = 1, 2 do
            if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
                self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
            end
            local btn = ccui.Button:create(pngname[i], pngname[i], pngname[i], ccui.TextureResType.plistType)
            btn:ignoreContentAdaptWithSize(false)
            btn:setContentSize(cc.size(100, 70))
            self.Panel_1:addChild(btn)
            btn:setName("qiangzhuangbtn" .. i)
            btn:setPosition(pos2[i])

            local score = ccui.Text:create(str[i], DEFAULTFONT, 30)
            btn:addChild(score)
            score:setPosition(cc.p(btn:getCenter().x - 2, btn:getCenter().y))

            UIHelper.BindClickByButtons({ btn }, function(sender, event)
                for i = 1, 2 do
                    if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
                        self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
                    end
                end
                --                WaitProgress.Show()
                GameFightSceneHelp.StartBanker(i - 1)

                if self.schedulerID ~= nil then
                    cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                    self.schedulerID = nil
                end
            end)
        end
    end

    --创建明牌抢庄的按钮
    if FightManager.roomdata.gameType == 4 and self["PlayerNode_" .. 0] ~= nil then
        local pos1 = { [1] = cc.p(511.20, 190), [2] = cc.p(624.80, 190) }
        local pos2 = { [1] = cc.p(454.40, 190), [2] = cc.p(568.00, 190), [3] = cc.p(681.60, 190) }
        local pos3 = { [1] = cc.p(397.60, 190), [2] = cc.p(511.20, 190), [3] = cc.p(624.80, 190), [4] = cc.p(738.40, 190) }
        local pos4 = { [1] = cc.p(340.80, 190), [2] = cc.p(454.40, 190), [3] = cc.p(568.00, 190), [4] = cc.p(681.60, 190), [5] = cc.p(795.20, 190) }
        local str = { [1] = "", [2] = "", [3] = "", [4] = "", [5] = "" }
        local pngname = { [1] = "myqz0.png", [2] = "myqz1.png", [3] = "myqz2.png", [4] = "myqz3.png", [5] = "myqz4.png" }
        local btnnum = FightManager.roomdata.maxGetBankerScore + 1
        local pos = nil
        if FightManager.roomdata.maxGetBankerScore == 1 then
            pos = pos1
        elseif FightManager.roomdata.maxGetBankerScore == 2 then
            pos = pos2
        elseif FightManager.roomdata.maxGetBankerScore == 3 then
            pos = pos3
        elseif FightManager.roomdata.maxGetBankerScore == 4 then
            pos = pos4
        end

        for i = 1, btnnum do
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
                for i = 1, btnnum do
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
end

--完成抢庄
function GameFightScene:BankerEnd(seatNo, grab)
    for i = 1, 6 do
        if self["PlayerNode_" .. i - 1].seatNo == seatNo then
            local isqiang = false
            if grab ~= nil and grab > 0 then
                isqiang = true
            end
            GameFightSceneHelp.CreateAm_QZ(self["PlayerNode_" .. i - 1], isqiang, grab)
        end
    end

    if self["PlayerNode_" .. 0].seatNo == seatNo then
        self.Image_tips:setVisible(true)
        self.Text_tip:setString("等待其他玩家抢庄")
        if self.schedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil
        end

        if FightManager.roomdata.gameType == 3 or FightManager.roomdata.gameType == 4 then
            for i = 1, 5 do
                if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
                    self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
                end
            end
        end
    end
end



--设置庄家
function GameFightScene:setBanker()
    self.BankerAmOver = false
    local bankerNode
    for i = 1, 6 do
        if self["PlayerNode_" .. i - 1].seatNo == FightManager.roomdata.banker then
            bankerNode = self["PlayerNode_" .. i - 1]
            break
        end
    end

    if FightManager.roomdata.gameType == 3 then
        for i = 1, 6 do
            if self["PlayerNode_" .. i - 1]:getChildByName("Am_Qiang") then
                local sprite = self["PlayerNode_" .. i - 1]:getChildByName("Am_Qiang")
                sprite:removeFromParent()
            end
        end
    end


    if FightManager.roomdata.gameType == 4 then
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
    end


    local AmTime = 0


    if FightManager.roomdata.gameType == 1 then


        if FightManager.roomdata.round == 1 then
            --执行跑马灯的动画
            self.Text_tip:setString("正在随机选庄")
            SoundHelper.playMusicSound(99, 1, false)
            self.Image_iconBanker:setVisible(false)
            local data = {}
            for i = 1, 6 do
                if self["PlayerNode_" .. i - 1]:isVisible() == true then
                    AmTime = AmTime + 0.4305
                    table.insert(data, self["PlayerNode_" .. i - 1].Image_bankerback)
                end
            end
            self.Panel_1:stopActionByTag(1)
            local action = GameFightSceneHelp.BankerAm(data, bankerNode)
            --            action:setTag(1)
            self.Panel_1:runAction(action)
            AmTime = AmTime + 50 / 60
            self.banker = FightManager.roomdata.banker
            --        elseif FightManager.roomdata.round>1 then
            --            if self.banker~=nil and self.banker == FightManager.roomdata.banker then
            --                self.Image_tips:setVisible(false)
            --                self.BankerAmOver=true
            --                self:setBat()
            --                return


            --            end
        else
            self.Image_tips:setVisible(false)
            self.BankerAmOver = true
            --            self:setBat()
            --            return
        end
    end




    if FightManager.roomdata.gameType == 2 then
        if FightManager.roomdata.round == 1 then
            --执行跑马灯的动画
            self.Text_tip:setString("正在随机选庄")
            SoundHelper.playMusicSound(99, 1, false)
            self.Image_iconBanker:setVisible(false)
            local data = {}
            for i = 1, 6 do
                if self["PlayerNode_" .. i - 1]:isVisible() == true then
                    AmTime = AmTime + 0.4305
                    table.insert(data, self["PlayerNode_" .. i - 1].Image_bankerback)
                end
            end
            self.Panel_1:stopActionByTag(1)
            local action = GameFightSceneHelp.BankerAm(data, bankerNode)
            --            action:setTag(1)
            self.Panel_1:runAction(action)
            AmTime = AmTime + 50 / 60
            self.banker = FightManager.roomdata.banker
        else
            self.Image_tips:setVisible(false)
            self.BankerAmOver = true
            --            self:setBat()
            --            return
        end
    end





    if FightManager.roomdata.gameType == 3 then

        local isqiangcount = 0
        local qiangnum = {}
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].grabed == true then
                isqiangcount = isqiangcount + 1
                table.insert(qiangnum, FightManager.roomdata.seats[i])
            end
        end
        --        print("=================AAAA"..isqiangcount)
        if isqiangcount > 1 and FightManager.roomdata.round >= 1 then
            --执行跑马灯的动画
            self.Text_tip:setString("（" .. isqiangcount .. "）人正在抢庄")
            SoundHelper.playMusicSound(99, 1, false)
            self.Image_iconBanker:setVisible(false)
            local data = {}
            for i = 1, 6 do
                if self["PlayerNode_" .. i - 1]:isVisible() == true then
                    for k = 1, #qiangnum do
                        if qiangnum[k].seatNo == FightManager.roomdata.seats[i].seatNo then
                            AmTime = AmTime + 0.4305
                            table.insert(data, self["PlayerNode_" .. i - 1].Image_bankerback)
                        end
                    end
                end
            end
            self.Panel_1:stopActionByTag(1)
            local action = GameFightSceneHelp.BankerAm(data, bankerNode)
            --            action:setTag(1)
            self.Panel_1:runAction(action)
            AmTime = AmTime + 50 / 60
            self.banker = FightManager.roomdata.banker
        else
            self.Image_tips:setVisible(false)
            self.BankerAmOver = true
            --            self:setBat()
            --            return
        end
    end


    if FightManager.roomdata.gameType == 4 then
        self.MyFp = false --允许发牌
        local isqiangcount = 0
        local qiangnum = {}
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].grabed == true then
                isqiangcount = isqiangcount + 1
                table.insert(qiangnum, FightManager.roomdata.seats[i])
            end
        end

        --        print("=================AAAA"..isqiangcount)
        if isqiangcount > 1 and FightManager.roomdata.round >= 1 then
            self.Text_tip:setString("（" .. isqiangcount .. "）人正在抢庄")
            --执行跑马灯的动画
            SoundHelper.playMusicSound(99, 1, false)
            self.Image_iconBanker:setVisible(false)
            local data = {}
            for i = 1, 6 do
                if self["PlayerNode_" .. i - 1]:isVisible() == true then
                    for k = 1, #qiangnum do
                        if qiangnum[k].seatNo == FightManager.roomdata.seats[i].seatNo then
                            AmTime = AmTime + 0.4305
                            table.insert(data, self["PlayerNode_" .. i - 1].Image_bankerback)
                        end
                    end
                end
            end
            self.Panel_1:stopActionByTag(1)
            local action = GameFightSceneHelp.BankerAm(data, bankerNode)
            --            action:setTag(1)
            self.Panel_1:runAction(action)
            AmTime = AmTime + 50 / 60
            self.banker = FightManager.roomdata.banker
        else
            self.Image_tips:setVisible(false)
            self.BankerAmOver = true
            --            self:setBat()
            --            return
        end
    end

    self.Panel_1:runAction(cc.Sequence:create(cc.DelayTime:create(AmTime), cc.CallFunc:create(function()
        self.Image_tips:setVisible(true)
        local str = ""
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == FightManager.roomdata.banker then
                str = FightManager.roomdata.seats[i].name
                break
            end
        end
        self.Text_tip:setString("（" .. str .. "）成为了庄家")
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
                sprite:setScale(1.0)
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
function GameFightScene:setBat()


    for i = 1, #FightManager.roomdata.seats do
        if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
            self.Button_KS:setVisible(false)
            self.Button_ZX:setVisible(false)
            self.Button_YQ:setVisible(false)
            self.Button_PG:setVisible(false)
            self.Button_XJ:setVisible(false)
            self.Button_card1:setVisible(false)
            self.Button_card2:setVisible(false)
        end
    end


    self.MyFp = false --允许发牌
    self.Image_tips:setVisible(true)

    self.banker = FightManager.roomdata.banker

    for i = 1, 5 do
        if self.Panel_1:getChildByName("qiangzhuangbtn" .. i) ~= nil then
            self.Panel_1:removeChildByName("qiangzhuangbtn" .. i)
        end
        if self.Panel_1:getChildByTag(998 + i) ~= nil then
            self.Panel_1:removeChildByTag(998 + i)
        end
    end



    if self["PlayerNode_" .. 0].seatNo == FightManager.roomdata.banker or self["PlayerNode_" .. 0] == nil then
        self.Text_tip:setString("等待闲家下注")
        SoundHelper.playMusicSound(92, 0, false)
    else

        if self.schedulerID ~= nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
            self.schedulerID = nil
        end

        SoundHelper.playMusicSound(91, 0, false)

        local JsTime = 10
        self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, function(dt)
            JsTime = JsTime - 1
            self.Text_tip:setString("请选择下注分数:" .. JsTime)
            SoundHelper.playMusicSound(101, 0, false)

            if JsTime <= 0 then
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

        local pos2 = { [1] = cc.p(511.20, 190), [2] = cc.p(624.80, 190) }
        local pos3 = { [1] = cc.p(454.40, 190), [2] = cc.p(568.00, 190), [3] = cc.p(681.60, 190) }
        local scores = { [1] = FightManager.roomdata.baseScore, [2] = FightManager.roomdata.baseScore * 2, [3] = FightManager.roomdata.baseScore * 10 }

        --是否可以推注
        local ispush = 0
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                ispush = FightManager.roomdata.seats[i].push
                break
            end
        end

        if ispush ~= 0 and FightManager.roomdata.playerPush == true then
            scores[3] = ispush
            for i = 1, 3 do
                if self.Panel_1:getChildByTag(998 + i) ~= nil then
                    self.Panel_1:removeChildByTag(998 + i)
                end
                local btn = ccui.Button:create("niuniubtn.png", "niuniubtn.png", "niuniubtn.png", ccui.TextureResType.plistType)
                btn:ignoreContentAdaptWithSize(false)
                btn:setContentSize(cc.size(100, 70))
                self.Panel_1:addChild(btn)
                btn:setTag(998 + i)
                btn:setPosition(pos3[i])
                local score = ccui.Text:create(scores[i], DEFAULTFONT, 35)
                btn:addChild(score)
                score:setPosition(cc.p(btn:getCenter().x - 2, btn:getCenter().y))

                UIHelper.BindClickByButtons({ btn }, function(sender, event)

                    for i = 1, 3 do
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

        else

            for i = 1, 2 do
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
                    for i = 1, 2 do
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
end

--显示下注结果
function GameFightScene:putBet(seatNo, score)
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
function GameFightScene:Licensing()



    if self.MyFp == false then
        self.MyFp = true


        self.Button_card1:setVisible(false)
        self.Button_card2:setVisible(false)

        self.FlopCuoPai = false --允许搓牌
        self.FlopAmIng = false --允许翻牌

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


        local DyUNum = #FightManager.roomdata.seats

        local cardCount = 0
        for i = 1, DyUNum do
            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                cardCount = #FightManager.roomdata.seats[i].cards
            end
        end





        self.Panel_cards:setVisible(true)

        if FightManager.roomdata.gameType ~= 4 then
            self.AnimateTimeLine:play("fapai" .. DyUNum, false)
            SoundHelper.playMusicSound(14, 1, false)
        else
            if cardCount == 4 then
                self.AnimateTimeLine:play("fapai" .. DyUNum .. "_1", false)
            else
                self.AnimateTimeLine:play("fapai2_" .. DyUNum, false)
            end
            SoundHelper.playMusicSound(14, 1, false)
        end



        --把没有发的牌隐藏了
        local delaytime = 0
        if DyUNum == 2 then
            for i = 1, 20 do
                self["Image_card" .. 10 + i]:setVisible(false)
            end
            delaytime = 60 / 90
        elseif DyUNum == 3 then
            for i = 1, 15 do
                self["Image_card" .. 15 + i]:setVisible(false)
            end
            delaytime = 85 / 90
        elseif DyUNum == 4 then
            for i = 1, 10 do
                self["Image_card" .. 20 + i]:setVisible(false)
            end
            delaytime = 110 / 90
        elseif DyUNum == 5 then
            for i = 1, 5 do
                self["Image_card" .. 25 + i]:setVisible(false)
            end
            delaytime = 135 / 90
        elseif DyUNum == 6 then
            delaytime = 160 / 90
        end



        --牌发完了
        self.Panel_cards:runAction(cc.Sequence:create(cc.DelayTime:create(delaytime / 2), cc.CallFunc:create(function()
            if FightManager.roomdata.gameType == 4 and cardCount == 4 then
                self.FlopAmIng = false
                self:FlopCard()
                if FightManager.roomdata.status == 2 then
                    self:StartBanker()
                end
            else

                if FightManager.roomdata.gameType == 4 and cardCount == 5 and self.YaoFP == true then
                    self.FlopAmIng = false
                    self:FlopCard()
                end

                if FightManager.roomdata.disableTouchCard == false then
                    self.Button_card1:setVisible(true)
                    self.Text_btncard1:setString("搓牌")
                else
                    self.Text_btncard1:setString("提示")
                end

                self.Button_card2:setVisible(true)
                self.Text_btncard2:setString("翻牌")

                self.FlopCuoPai = false
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
function GameFightScene:LookCardTime()


    for i = 1, #FightManager.roomdata.seats do
        if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
            self.Button_KS:setVisible(false)
            self.Button_ZX:setVisible(false)
            self.Button_YQ:setVisible(false)
            self.Button_PG:setVisible(false)
            self.Button_XJ:setVisible(false)
        end
    end



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


    local JsTime = 10
    self.Image_tips:setVisible(true)




    self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, function(dt)
        JsTime = JsTime - 1
        self.Text_tip:setString("查看手牌:" .. JsTime)
        SoundHelper.playMusicSound(101, 0, false)

        if JsTime <= 0 then
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
function GameFightScene:FlopCard()

    if self.FlopAmIng == false then


        self.FlopAmIng = true

        self["Image_card01"]:setVisible(true)
        self["Image_card02"]:setVisible(true)
        self["Image_card03"]:setVisible(true)
        self["Image_card04"]:setVisible(true)
        self["Image_card05"]:setVisible(true)


        local FpCards = {}

        for i = 1, #FightManager.roomdata.seats do --吧牌添加到自己的座位中
            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                FpCards = FightManager.roomdata.seats[i].cards
                break
            end
        end

        if table.getn(FpCards) == 4 or table.getn(FpCards) == 5 then



            if FightManager.roomdata.gameType == 4 and table.getn(FpCards) == 5 and self.YaoFP == true then
                self.YaoFP = false




                for i = 1, 4 do
                    if self["Image_card0" .. i]:getChildrenCount() < 1 then
                        local openAnim = cc.Sequence:create(cc.OrbitCamera:create(0.2, 1, 0, 0, 90, 0, 0), cc.CallFunc:create(function()
                            local spr = FpCards[i].cardColor .. "_" .. FpCards[i].value .. ".png"
                            local cardSpr = cc.Sprite:createWithSpriteFrameName(spr)
                            self["Image_card0" .. i]:addChild(cardSpr)
                            cardSpr:setAnchorPoint(cc.p(0, 0))
                        end),
                            cc.OrbitCamera:create(0.2, 1, 0, 270, 90, 0, 0), cc.CallFunc:create(function()
                                --                    self.Text_btncard2:setString("亮牌")
                                --                    self.Text_btncard1:setString("提示")
                            end))
                        self["Image_card0" .. i]:runAction(openAnim)
                    end
                end


            else




                for i = 1, #FpCards do
                    if self["Image_card0" .. i]:getChildrenCount() < 1 then
                        local openAnim = cc.Sequence:create(cc.OrbitCamera:create(0.2, 1, 0, 0, 90, 0, 0), cc.CallFunc:create(function()
                            local spr = FpCards[i].cardColor .. "_" .. FpCards[i].value .. ".png"
                            local cardSpr = cc.Sprite:createWithSpriteFrameName(spr)
                            self["Image_card0" .. i]:addChild(cardSpr)
                            cardSpr:setAnchorPoint(cc.p(0, 0))
                        end),
                            cc.OrbitCamera:create(0.2, 1, 0, 270, 90, 0, 0), cc.CallFunc:create(function()
                                self.Text_btncard2:setString("亮牌")
                                self.Text_btncard1:setString("提示")
                            end))

                        self["Image_card0" .. i]:runAction(openAnim)
                    end
                end
            end
        end
    end
end

--卡牌提示
function GameFightScene:CardTiShi(cards, cardstype)
    for i = 1, #cards do
        self["Image_card0" .. i]:removeAllChildren()
        self["Image_card0" .. i]:loadTexture(cards[i].cardColor .. "_" .. cards[i].value .. ".png", ccui.TextureResType.plistType)
        if i == 1 then
            self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 - 120, 80))))
        elseif i == 2 then
            self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 - 60, 80))))
        elseif i == 3 then
            self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568, 80))))

        elseif i == 4 then
            if cardstype == 0 then
                self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 + 60, 80))))
            else
                self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 + 60 + 50, 80))))
            end

        elseif i == 5 then
            if cardstype == 0 then
                self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 + 120, 80))))
            else
                self["Image_card0" .. i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(568 + 120 + 50, 80))))
            end
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

    --如果有倍数吧倍数加上去
    local str = GameFightSceneHelp.getniuniuTypenum(cardstype, FightManager.roomdata.smallBull, FightManager.roomdata.bombBull, FightManager.roomdata.threetwoBull, FightManager.roomdata.suitBull, FightManager.roomdata.spottedBull, FightManager.roomdata.straightBull, FightManager.roomdata.doubleBull, FightManager.roomdata.rule)
    if str ~= nil then
        local child = cc.Sprite:createWithSpriteFrameName(str)
        node:add(child)
        child:setPositionX(100)
    end


    GameFightSceneHelp.CreateAm_TSNIUNIU(node, cardstype, false)
end

--亮牌动画
function GameFightScene:OpenCardAm(seatNo, sex)


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
                SoundHelper.playMusicSound(94, sex, false)
            else
                SoundHelper.playMusicSound(129 + niuniutype, sex, false)
            end
            self:CardTiShi(cards, niuniutype)
        end




    else

        for i = 1, 5 do

            local node = cc.Node:create()
            if self["PlayerNode_" .. i].seatNo == seatNo then


                if self["PlayerNode_" .. i]:getChildByName("Am_CPZ") then
                    local sprite = self["PlayerNode_" .. i]:getChildByName("Am_CPZ")
                    sprite:removeFromParent()
                end

                local cards = GameFightSceneHelp.getcardsByseatNo(seatNo)
                if table.getn(cards) == 5 then

                    local niuniutype = GameFightSceneHelp.orderByRule(seatNo, FightManager.roomdata.smallBull, FightManager.roomdata.bombBull, FightManager.roomdata.threetwoBull, FightManager.roomdata.suitBull, FightManager.roomdata.spottedBull, FightManager.roomdata.straightBull, FightManager.roomdata.doubleBull)
                    cards = GameFightSceneHelp.getcardsByseatNo(seatNo)
                    if self["PlayerNode_" .. i].seatNo == FightManager.roomdata.banker then
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

                    else



                        for a = 1, #cards do
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

                                if niuniutype ~= 0 and a == 4 then
                                    self["Image_card" .. 5 * i + a]:setPositionX(self["Image_card" .. 5 * i + a]:getPositionX() + 10)
                                end

                                if niuniutype ~= 0 and a == 5 then
                                    self["Image_card" .. 5 * i + a]:setPositionX(self["Image_card" .. 5 * i + a]:getPositionX() + 10)
                                end
                            end
                        end



                        if self.Panel_cards:getChildByName("lpresout" .. i) then
                            self.Panel_cards:removeChildByName("lpresout" .. i)
                        end

                        if #cards > 1 then
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

                            local str = GameFightSceneHelp.getniuniuTypenum(niuniutype, FightManager.roomdata.smallBull, FightManager.roomdata.bombBull, FightManager.roomdata.threetwoBull, FightManager.roomdata.suitBull, FightManager.roomdata.spottedBull, FightManager.roomdata.straightBull, FightManager.roomdata.doubleBull, FightManager.roomdata.rule)
                            if str ~= nil then
                                local child = cc.Sprite:createWithSpriteFrameName(str)
                                node:add(child)
                                child:setPositionX(90)
                            end

                            if niuniutype == 0 then
                                SoundHelper.playMusicSound(94, sex, false)
                            else
                                SoundHelper.playMusicSound(129 + niuniutype, sex, false)
                            end
                            GameFightSceneHelp.CreateAm_TSNIUNIU(node, niuniutype, fasle)
                        end
                    end
                end
            end
        end
    end
end

--开始比牌
function GameFightScene:Settlement(jumpToZb)
    --金币加减
    local delayTime = 1
    self.Image_tips:setVisible(true)
    self.Panel_cards:setVisible(true)
    self.Text_tip:setString("开始比牌")
    self.Button_card1:setVisible(false)
    self.Button_card2:setVisible(false)
    self.totalRound = FightManager.roomdata.round

    --所有人亮牌
    if self.Panel_cards:getChildByName("lpresoutWC") then
        self.Panel_cards:removeChildByName("lpresoutWC")
    end

    if #FightManager.resoutdata > 0 and self.JoinAtMiddle == false then
        for i = 1, #FightManager.resoutdata do
            for a = 1, 5 do
                if self["PlayerNode_" .. a].seatNo ~= nil and self["PlayerNode_" .. a].seatNo == FightManager.resoutdata[i].seatNo and FightManager.resoutdata[i].seatNo == FightManager.roomdata.banker then
                    local cards = FightManager.resoutdata[i].cards

                    --把庄家牌显示出来
                    for b = 1, #cards do
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

                            if FightManager.resoutdata[i].value ~= 0 and b == 4 then
                                self["Image_card" .. 5 * a + b]:setPositionX(self["Image_card" .. 5 * a + b]:getPositionX() + 10)
                            end

                            if FightManager.resoutdata[i].value ~= 0 and b == 5 then
                                self["Image_card" .. 5 * a + b]:setPositionX(self["Image_card" .. 5 * a + b]:getPositionX() + 10)
                            end
                        end
                    end


                    if self.Panel_cards:getChildByName("lpresout" .. a) then
                        self.Panel_cards:removeChildByName("lpresout" .. a)
                    end


                    if FightManager.resoutdata[i].value == 0 then
                        SoundHelper.playMusicSound(94, FightManager.resoutdata[i].sex, false)
                    else
                        SoundHelper.playMusicSound(129 + FightManager.resoutdata[i].value, FightManager.resoutdata[i].sex, false)
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
                    local str = GameFightSceneHelp.getniuniuTypenum(FightManager.resoutdata[i].value, FightManager.roomdata.smallBull, FightManager.roomdata.bombBull, FightManager.roomdata.threetwoBull, FightManager.roomdata.suitBull, FightManager.roomdata.spottedBull, FightManager.roomdata.straightBull, FightManager.roomdata.doubleBull, FightManager.roomdata.rule)
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

    if jumpToZb == nil and self.JoinAtMiddle == false then
        if FightManager.roomdata.gameType == 5 then
            --通比牛牛模式没有庄家
            local LoseNode = {}
            local WinNode = nil
            if #FightManager.resoutdata > 0 then
                for i = 1, #FightManager.resoutdata do
                    for a = 1, 6 do
                        if self["PlayerNode_" .. a - 1].seatNo ~= nil and self["PlayerNode_" .. a - 1].seatNo == FightManager.resoutdata[i].seatNo then
                            if FightManager.resoutdata[i].score < 0 then
                                table.insert(LoseNode, self["PlayerNode_" .. a - 1])
                            elseif FightManager.resoutdata[i].score > 0 then
                                WinNode = self["PlayerNode_" .. a - 1]
                            end
                        end
                    end
                end
            end

            for i = 1, #LoseNode do
                for a = 1, 10 do
                    local gold = cc.Sprite:createWithSpriteFrameName("niuniu_img16.png")
                    self.Panel_1:addChild(gold)
                    gold:setScale(0.64)
                    gold:setPosition(LoseNode[i]:getPosition())
                    gold:setTag(i * 1000 + a)
                    gold:setOpacity(0)
                    local bezier = GameFightSceneHelp.GetBezier(cc.p(LoseNode[i]:getPositionX(), LoseNode[i]:getPositionY()), cc.p(WinNode:getPositionX(), WinNode:getPositionY()))
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
                    WinNode.FileNode_GoldAm.AnimateTimeLine:play("play", false)
                end)))
            end
        else
            --取得庄家的位置
            local bankerNode = nil
            local LoseNode = {}
            local WinNode = {}
            if #FightManager.resoutdata > 0 then
                for i = 1, #FightManager.resoutdata do
                    for a = 1, 6 do
                        if self["PlayerNode_" .. a - 1].seatNo ~= nil and self["PlayerNode_" .. a - 1].seatNo == FightManager.roomdata.banker then
                            bankerNode = self["PlayerNode_" .. a - 1] --庄家位置
                        end

                        if self["PlayerNode_" .. a - 1].seatNo ~= nil and self["PlayerNode_" .. a - 1].seatNo == FightManager.resoutdata[i].seatNo and self["PlayerNode_" .. a - 1].seatNo ~= FightManager.roomdata.banker then
                            if FightManager.resoutdata[i].score < 0 then
                                table.insert(LoseNode, self["PlayerNode_" .. a - 1]) --输家位置
                            elseif FightManager.resoutdata[i].score > 0 then
                                table.insert(WinNode, self["PlayerNode_" .. a - 1]) --赢家位置
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

    self.Panel_cards:runAction(cc.Sequence:create(cc.DelayTime:create(delayTime + 2),
        cc.CallFunc:create(function()
            self:refreshPlayerPoint()

            if self.schedulerID ~= nil then
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                self.schedulerID = nil
            end



            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                    self.Button_KS:setVisible(false)
                    self.Button_ZX:setVisible(false)
                    self.Button_YQ:setVisible(false)
                    self.Button_PG:setVisible(false)
                    self.Button_XJ:setVisible(false)
                    self.Button_card2:setVisible(false)
                end
            end




            print("==================下一局=status====" .. FightManager.roomdata.status)

            local JsTime = 10
            self.Image_tips:setVisible(true)

            self.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self, function(dt)
                JsTime = JsTime - 1
                self.Text_tip:setString("下一局即将开始:" .. JsTime)
                SoundHelper.playMusicSound(101, 0, false)
                FightManager.roomdata.status = 1
                if JsTime <= 0 then
                    self.Button_card1:setVisible(false)
                    self.Image_tips:setVisible(false)
                    if self.schedulerID ~= nil then
                        cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                        self.schedulerID = nil
                    end
                end
            end), 1, false)


            if FightManager.roomdata.round ~= FightManager.roomdata.totalRound then
                self.Button_XJ:setVisible(false)
                self.Button_card1:setVisible(true)
                self.Text_btncard1:setString("准备")
            else
                self.Button_card1:setVisible(false)
                self.Image_tips:setVisible(false)
                cc.Director:getInstance():getScheduler():unscheduleScriptEntry(self.schedulerID)
                self.schedulerID = nil
            end
        end)))
end

--整个游戏都结束了
function GameFightScene:GameEnd(data, roomNum, totalRound, baseScore, gameType)
    self.Button_card1:setVisible(false)
    self.Button_card2:setVisible(false)
    self.Image_tips:setVisible(false)
    self:CloseAll()
    require("app.views.UI.LayerGameEnd").new():Show():setData(data, roomNum, totalRound, baseScore, gameType)
end

function GameFightScene:updateGame(dt)

    --            下一行错误
    self.Text_10:setString(os.date("%H:%M")) --设置时间
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

    if dt ~= nil and self.VoiceCoolDown > 0 then
        self.VoiceCoolDown = self.VoiceCoolDown - dt
    end


    if FightManager.roomdata ~= nil and FightManager.roomdata.roomNo ~= nil then


        local IsGameOPEN = 0
        if tonumber(FightManager.roomdata.round) == 0 and FightManager.roomdata.status == GameStatus.WAITING then
            IsGameOPEN = 0
        else
            IsGameOPEN = 1
        end


        local MySD = 0
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName and FightManager.roomdata.seats[i].ready == true then
                MySD = 1
            end
        end


        if IsGameOPEN == 0 and #FightManager.roomdata.seats < 6 then
            self.Button_YQ:setVisible(true)
        else
            self.Button_YQ:setVisible(false)
        end


        if IsGameOPEN == 1 and MySD == 0 then
            if self.Button_ZX:getPositionX() ~= self.Panel_1:getCenter().x then
                self.Button_ZX:setPositionX(self.Panel_1:getCenter().x)
                self.Button_ZX:runAction(cc.Sequence:create(cc.MoveTo:create(0.5, cc.p(self.Panel_1:getCenter().x, self.Button_ZX:getPositionY())), cc.MoveTo:create(0, cc.p(self.Panel_1:getCenter().x, self.Button_ZX:getPositionY()))))
            end
        end



        --            是否显示开始按钮

        if FightManager.roomdata.roomOwner == PlayerManager.Player.userName then
            if IsGameOPEN == 1 then
                self.Button_KS:setVisible(false)
            else

                self.Button_KS:setVisible(true)
                if #FightManager.roomdata.seats > 1 then
                    self.Button_KS:setEnabled(true)
                else
                    self.Button_KS:setEnabled(false)
                end

                if MySD == 1 or #FightManager.roomdata.seats > 5 then
                    if self.Button_KS:getPositionX() ~= self.Panel_1:getCenter().x then
                        self.Button_KS:setPositionX(self.Panel_1:getCenter().x)
                        self.Button_KS:runAction(cc.Sequence:create(cc.MoveTo:create(0.1, cc.p(self.Panel_1:getCenter().x, self.Button_KS:getPositionY())), cc.MoveTo:create(0, cc.p(self.Panel_1:getCenter().x, self.Button_KS:getPositionY()))))
                    end

                else

                    if self.Button_KS:getPositionX() ~= self.Panel_1:getCenter().x - 100 then
                        self.Button_KS:setPositionX(self.Panel_1:getCenter().x)
                        self.Button_KS:runAction(cc.Sequence:create(cc.MoveTo:create(0, cc.p(self.Panel_1:getCenter().x, self.Button_KS:getPositionY())), cc.MoveTo:create(0.5, cc.p(self.Panel_1:getCenter().x - 100, self.Button_KS:getPositionY()))))
                    end

                    if self.Button_ZX:getPositionX() ~= self.Panel_1:getCenter().x + 100 then
                        self.Button_ZX:setPositionX(self.Panel_1:getCenter().x)
                        self.Button_ZX:runAction(cc.Sequence:create(cc.MoveTo:create(0, cc.p(self.Panel_1:getCenter().x, self.Button_ZX:getPositionY())), cc.MoveTo:create(0.5, cc.p(self.Panel_1:getCenter().x + 100, self.Button_ZX:getPositionY()))))
                    end
                end
            end
        end






        if IsGameOPEN == 0 then
            self.Image_tips:setVisible(true)
            if FightManager.roomdata.roomOwner == PlayerManager.Player.userName then
                if #FightManager.roomdata.seats > 1 then
                    if MySD == 0 and #FightManager.roomdata.seats > 5 then
                        self.Text_tip:setString("人数已满，您未参与游戏，请开始游戏")
                    else
                        self.Text_tip:setString("可以继续等待，也可以开始游戏")
                    end
                else
                    self.Text_tip:setString("等待其他玩家加入")
                end
            else
                if MySD == 0 then
                    if #FightManager.roomdata.seats < 6 then
                        self.Text_tip:setString("坐下后加入游戏")
                    else
                        self.Text_tip:setString("本房间人数已满")
                    end
                else
                    self.Text_tip:setString("等待房主开始游戏")
                end
            end
        end
    end
end

function GameFightScene:refreshPlayerNode(index, isVisible, seatNo)
    self["PlayerNode_" .. index]:setVisible(isVisible)
    self["PlayerNode_" .. index].seatNo = seatNo
end

function GameFightScene:readyPlayerNode(seatNo)
    for i = 1, 6 do
        if self["PlayerNode_" .. i - 1].seatNo == seatNo and self["PlayerNode_" .. i - 1].AnimateTimeLine:getCurrentFrame() < 50 then
            self["PlayerNode_" .. i - 1].AnimateTimeLine:play("ready", false)
            break
        end
    end
end

function GameFightScene:onEnterTransitionFinish()

    self.super.onEnterTransitionFinish(self)
    if SoundHelper.isMusicPlaying() then
        SoundHelper.stopMusic()
    end

    SoundHelper.playMusicSound(87, 0, true)

    local isCl = false --是否是重连进来的
    local cardCountS = 0

    if FightManager.roomdata.round > 0 then --玩家重连进来的
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                isCl = true
                cardCountS = FightManager.roomdata.seats[i].cards
                break
            end
        end

        if isCl == true then


            self:GameStartAgain()
            --判断当前有无庄家
            if FightManager.roomdata.banker ~= 0 then
                --设置庄家
                if self.Image_iconBanker:isVisible() == false then
                    self.Image_iconBanker:setVisible(true)
                end

                local bankerNode
                for i = 1, 6 do
                    if self["PlayerNode_" .. i - 1].seatNo == FightManager.roomdata.banker then
                        bankerNode = self["PlayerNode_" .. i - 1]
                        self.banker = FightManager.roomdata.banker
                        break
                    end
                end

                local pos = cc.p(bankerNode:getPositionX(), bankerNode:getPositionY())
                self.Image_iconBanker:setPosition(cc.p(pos.x + 100, pos.y + 50))
            end




            --根据游戏状态获取当前游戏进度
            if FightManager.roomdata.status == 1 then --准备
                self:Settlement(true)

            elseif FightManager.roomdata.status == 2 then --抢庄
                if FightManager.roomdata.gameType == 4 then
                    self:Licensing()
                end

            elseif FightManager.roomdata.status == 3 then --下注

                if FightManager.roomdata.gameType == 4 then
                    self:Licensing()
                end

                if table.getn(cardCountS) > 0 then
                    self:setBat()
                end
                for i = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[i].multiple > 0 then
                        self:putBet(FightManager.roomdata.seats[i].seatNo, FightManager.roomdata.seats[i].multiple)
                    end
                end

            elseif FightManager.roomdata.status == 4 and table.getn(cardCountS) > 0 then --亮牌

                self.YaoFP = true

                local time = self:Licensing()

                for i = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[i].opened == true then

                        self.Panel_cards:runAction(cc.Sequence:create(cc.DelayTime:create(time),
                            cc.CallFunc:create(function()
                                self:OpenCardAm(FightManager.roomdata.seats[i].seatNo, FightManager.roomdata.seats[i].sex)
                            end)))
                    end
                end
            elseif FightManager.roomdata.status == 5 then --比牌
            end
        end
    end
end

function GameFightScene:onEnter()
    self.super.onEnter(self)
    --收到有人进入消息
    MessageHandle.addHandle(Enum.ADD_ROOM_CLIENT, function(msgid, data)
        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.Seat()
        cmsg:ParseFromString(data)

        if cmsg.userName == PlayerManager.Player.userName then --是自己

            self.Button_ZX:setVisible(false)
            self.Button_PG:setVisible(false)

            if tonumber(FightManager.roomdata.round) == 0 then
                GameFightSceneHelp.GameReady()
                if tonumber(#FightManager.roomdata.seats) > 5 then
                    GameFightSceneHelp.GameStart()
                end

            else --中途加入的


                --                self.Image_tips:setVisible(true)

                self.JoinAtMiddle = true


                if FightManager.roomdata.status == 1 then
                    --                  self.Panel_cards:setVisible(false)
                    self.Button_XJ:setVisible(false)
                    self.Button_card1:setVisible(false)
                    --                    self.Text_btncard1:setString("准备")
                    self.Button_card2:setVisible(false)
                else
                    self.Button_PG:setVisible(false)
                    self.Button_XJ:setVisible(true)
                    self.Image_tips:setVisible(true)
                    self.Text_tip:setString("请耐心等待下一局")
                end
            end
        end






        --                            local IsMySD=0
        --                            for i=1,#FightManager.roomdata.seats do
        --                            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
        --                            IsMySD=1
        --                            end
        --                            end




        if #FightManager.roomdata.seats > 5 then
            self.Button_ZX:setVisible(false)
        end


        if FightManager.roomdata.roomOwner == PlayerManager.Player.userName and tonumber(FightManager.roomdata.round) > 0 then
            self.Button_KS:setVisible(false)
        end


        self:checkPlayerStuat()
    end, self)

    --收到有人离开消息
    MessageHandle.addHandle(Enum.EXIT_CLIENT, function(msgid, data)
        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.ExitResponse()
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


        local IsMySD = 0
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                IsMySD = 1
            end
        end


        if IsMySD == 0 and #FightManager.roomdata.seats < 6 then
            self.Button_ZX:setVisible(true)
        end






        self:checkPlayerStuat()
    end, self)

    --收到准备消息
    MessageHandle.addHandle(Enum.READY_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.ReadyResponse()
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
        if FightManager.roomdata.roomNo == nil then
            return
        end
        print("=================游戏开始")
        self:GameStart()
    end, self)

    --收到抢庄游戏消息
    MessageHandle.addHandle(Enum.GRAB_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.GrabResponse()
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

        local cmsg = game_pb.PlayResponse()
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

        local cmsg = game_pb.OpenCardResponse()
        cmsg:ParseFromString(data)
        self:OpenCardAm(cmsg.seatNo, GameFightSceneHelp.getsexByseatNo(cmsg.seatNo))
    end, self)

    --收到开始比牌游戏消息
    MessageHandle.addHandle(Enum.RESULT_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end

        self:Settlement()
    end, self)

    --收到游戏完结游戏消息
    MessageHandle.addHandle(Enum.OVER_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.GameOverResponse()
        cmsg:ParseFromString(data)
        local userContents = {}
        print("收到的结算详细结果长度:" .. #cmsg.userContents)
        for i = 1, #cmsg.userContents do
            local UserContent = {}
            UserContent.name = cmsg.userContents[i].name
            UserContent.head = cmsg.userContents[i].head
            UserContent.username = cmsg.userContents[i].username
            UserContent.totalScore = cmsg.userContents[i].totalScore
            table.insert(userContents, UserContent)
        end

        self:GameEnd(userContents, self.RoomNum, self.totalRound, self.baseScore, self.gameType, self.date)
    end, self)

    --收到解散游戏投票消息
    MessageHandle.addHandle(Enum.DELETE_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.DeleteResponse()
        cmsg:ParseFromString(data)
        require("app.views.UI.LayerDissolveRoom").new(cmsg.username):Show()
    end, self)
    --收到解散成功游戏消息
    MessageHandle.addHandle(Enum.DELETED_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.DeletedResponse()
        cmsg:ParseFromString(data)
        if cmsg.deleted == true and FightManager.roomdata.round == 0 then
            require("app.views.UI.LayerTips").new("房间已解散，如果牌局未开始不扣钻石", false):Show():SetCloseCallBack(function(isupdata)
                self:CloseAll()
                local pScene = require("app.views.Scenes.MainScene.MainScene"):new()
                cc.Director:getInstance():replaceScene(pScene)
            end)
        end
    end, self)

    --收到玩家互动消息
    MessageHandle.addHandle(Enum.INTERACTION_CLIENT, function(msgid, data)

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.InteractionResponse()
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

        if FightManager.roomdata.roomNo == nil then
            return
        end
        local cmsg = game_pb.ImgTextResponse()
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

    --房间列表信息
    MessageHandle.addHandle(Enum.ROOMS_CLIENT, function(msgid, data)
        local cmsg = hall_pb.RoomResponse()
        if data ~= null then
            cmsg:ParseFromString(data)
            for i = 1, #cmsg.rooms do

                if cmsg.rooms[i].roomNo == FightManager.roomdata.roomNo then
                    MessageTip.Show("游戏开始无法离开房间")
                else
                    local pScene = require("app.views.Scenes.MainScene.MainScene"):new()
                    cc.Director:getInstance():replaceScene(pScene)
                end
            end
        else
            local pScene = require("app.views.Scenes.MainScene.MainScene"):new()
            cc.Director:getInstance():replaceScene(pScene)
        end
    end, self)
end

function GameFightScene:CloseAll()
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

function GameFightScene:onExit()
    self.super.onExit(self)
    self:CloseAll()
end

return GameFightScene

--endregion
