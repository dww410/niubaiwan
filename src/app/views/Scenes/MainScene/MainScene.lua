--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--游戏大厅
-- User: CongQin
-- Date: 17/02/13
local MainScene = class("MainScene", require("app.views.Scenes.Common.SceneBase"))
local WaitProgress = require('app.views.Controls.WaitProgress')
local MessageTip = require('app.views.UI.MessageTip')
local platformMethod = require('app.Platform.platformMethod')
local BulletinUI = require("app.views.UI.BulletinUI")
local ServiceMessageManager = require('app.DataManager.ServiceMessageManager')

function MainScene:ctor()
    MainScene.super.ctor(self)
    self:loadSceneCSB('Scenes/MainScene.csb')

    self:BindNodes(self.root, "Panel_1",
        "Panel_1.Image_4",
        "Panel_1.Text_2",

        "Panel_1.Image_3",
        "Panel_1.Panel_2",
        "Panel_1.Image_3.roomlistbg_4",
        "Panel_1.Image_3.roomlistbg_4.RoomListView",
        "Panel_1.Image_3.CreateButton",
        "Panel_1.Image_3.JoinButton",
        "Panel_1.Image_3.GoldModeButton",
        "Panel_1.Notice",
        "Panel_1.Button_Agent",
        "Panel_1.Button_DaySign",
        --"Panel_1.Panel_2.Notice.laba",
        "Panel_1.Panel_2.HeadNode",
        "Panel_1.Panel_2.Btn_Invitationcode",
        "Panel_1.Panel_2.Btn_Record",
        "Panel_1.Panel_2.Btn_Info",
        "Panel_1.Panel_2.Btn_Share",
        "Panel_1.Panel_2.Btn_Menu",
        "Panel_1.Panel_2.otherFunc",
        "Panel_1.Panel_2.otherFunc.Btn_0_0",
        "Panel_1.Panel_2.otherFunc.Btn_0_1",
        "Panel_1.Panel_2.otherFunc.Btn_0_2",
        "Panel_1.Panel_2.otherFunc.Btn_0_3",
        "Panel_1.Panel_2.otherFunc.Btn_0_4",
        "Panel_1.Panel_2.HeadNode.Button_Head",
        "Panel_1.Panel_2.HeadNode.Button_Head.Head.HeadBg",
        "Panel_1.Panel_2.HeadNode.NameText",
        "Panel_1.Panel_2.HeadNode.IDText",
        "Panel_1.Panel_2.HeadNode.SexTag",
        "Panel_1.Panel_2.HeadNode.MoneyBg",
        "Panel_1.Panel_2.HeadNode.MoneyBg_0.MoneyGoldText",
        "Panel_1.Panel_2.HeadNode.MoneyBg_0.MoneyGoldBtn",
        "Panel_1.Panel_2.HeadNode.MoneyBg_0.RechargeGoldBtn",
        "Panel_1.Panel_2.HeadNode.MoneyBg.MoneyText",
        "Panel_1.Panel_2.HeadNode.MoneyBg.RechargeBtn",
        "Panel_1.Panel_2.HeadNode.MoneyBg.MoneyBtn")

    self:init()
    self:initEvent()
    self:refresh()

    if cc.UserDefault:getInstance():getStringForKey("SinLoginType", "a") == "b" then
        self.MoneyBtn:setVisible(false)
        self.MoneyText:setVisible(false)
        self.RechargeBtn:setVisible(false)
        self.MoneyGoldBtn:setVisible(false)
        self.MoneyGoldText:setVisible(false)
        self.RechargeGoldBtn:setVisible(false)
        self.Btn_Invitationcode:setVisible(false)
        self.GoldModeButton:setVisible(false)
        self.Button_DaySign:setVisible(false)
    else
        self.Notice:addChild(BulletinUI.getInstance(), 1000)
    end


    self.touchIndex = 0

    --    self.Image_4:setVisible(false)
    --    self.Text_2:setVisible(false)
    --    BulletinUI.getInstance():addBulletinStr("公告测试公告测试公告测试公告测试公告测试公告测试公告测试公告测试公告测试公告测试公告测试公告测试")

    local function onTouchBegan(touch, event)
        return self.otherFunc:isVisible()
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
        local v = self.Btn_Menu:convertToWorldSpace(cc.p(0.5, 0.5))
        local rect = cc.rect(v.x, v.y, self.Btn_Menu:getContentSize().width, self.Btn_Menu:getContentSize().height)
        if (cc.rectContainsPoint(rect, touch:getLocation())) == false then
            if self.otherFunc:isVisible() == true then
                self.otherFunc:setVisible(false)
            end
        end
    end

    self.listener1 = cc.EventListenerTouchOneByOne:create()
    self.listener1:setSwallowTouches(false)
    self.listener1:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener1:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    self.listener1:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener1, self.otherFunc)
end

function MainScene:setPlatformInfo()
end


function MainScene:init()
end


function MainScene:initEvent()
    UIHelper.BindClickByButtons({ self.CreateButton, self.JoinButton, self.GoldModeButton, self.Btn_Invitationcode, self.Btn_Record, self.Btn_Info, self.Btn_Share, self.Btn_Menu }, function(sender, event)


        local SinLoveJinBiRoom = cc.UserDefault:getInstance():getStringForKey("SinLoveJinBiRoom", "a")

        if sender == self.CreateButton then --创建房间


            --            if SinLoveJinBiRoom == "b" then
            --            MessageTip.Show("您在(金币-初级场)没有离开，请先进去离开游戏")
            --            return
            --            end
            --            if SinLoveJinBiRoom == "c" then
            --            MessageTip.Show("您在(金币-中级场)没有离开，请先进去离开游戏")
            --            return
            --            end
            --            if SinLoveJinBiRoom == "d" then
            --            MessageTip.Show("您在(金币-高级场)没有离开，请先进去离开游戏")
            --            return
            --            end


            require("app.views.UI.LayerCreateGame").new():Show()
            ServiceMessageManager.GetRoomList()
            MSG.send(Enum.USER_INFO_SERVER, "", 1)


        elseif sender == self.JoinButton then --加入房间

            --            if SinLoveJinBiRoom == "b" then
            --            MessageTip.Show("您在(金币-初级场)没有离开，请先进去离开游戏")
            --            return
            --            end
            --            if SinLoveJinBiRoom == "c" then
            --            MessageTip.Show("您在(金币-中级场)没有离开，请先进去离开游戏")
            --            return
            --            end
            --            if SinLoveJinBiRoom == "d" then
            --            MessageTip.Show("您在(金币-高级场)没有离开，请先进去离开游戏")
            --            return
            --            end


            require("app.views.UI.LayerJoinGame").new():Show()
            ServiceMessageManager.GetRoomList()
            MSG.send(Enum.USER_INFO_SERVER, "", 1)





        elseif sender == self.GoldModeButton then --匹配房间
            require("app.views.UI.LayerCreateGoldGame").new():Show()
            ServiceMessageManager.GetRoomList()
            MSG.send(Enum.USER_INFO_SERVER, "", 1)





        elseif sender == self.Btn_Invitationcode then --邀请码
            require("app.views.UI.LayerInvitation").new():Show()

        elseif sender == self.Btn_Record then --战绩
            ServiceMessageManager.GetGameRecode()
            WaitProgress.Show()

        elseif sender == self.Btn_Info then --消息
            require("app.views.UI.LayerNotice").new():Show()

        elseif sender == self.Btn_Share then --分享
            require("app.views.UI.LayerWeiChat").new():Show()

        elseif sender == self.Btn_Menu then --菜单

            if self.otherFunc:isVisible() == true then
                self.otherFunc:setVisible(false)
            else
                self.otherFunc:setVisible(true)
            end
        end
    end)

    UIHelper.BindClickByButtons({ self.RechargeBtn, self.MoneyGoldBtn, self.RechargeGoldBtn, self.MoneyBtn, self.Button_Head, self.Button_Agent, self.Button_DaySign }, function(sender, event)
        if sender == self.RechargeBtn then --充值钻石
            if PlayerManager.Player.shop then
                require("app.views.UI.LayerRecharge").new():Show():showPanelIndex(1)
            end
            MSG.send(Enum.USER_INFO_SERVER, "", 1)

        elseif sender == self.RechargeGoldBtn then --充值金币
            if PlayerManager.Player.shop then
                require("app.views.UI.LayerRecharge").new():Show():showPanelIndex(3)
            end
            MSG.send(Enum.USER_INFO_SERVER, "", 1)

        elseif sender == self.MoneyBtn then --刷新
            MSG.send(Enum.USER_INFO_SERVER, "", 1)

        elseif sender == self.MoneyGoldBtn then --刷新
            MSG.send(Enum.USER_INFO_SERVER, "", 1)

        elseif sender == self.Button_Head then --头像
            require("app.views.UI.LayerUserInfo").new():Show()

        elseif sender == self.Button_Agent then --代理
            require("app.views.UI.LayerAgent").new():Show()

        elseif sender == self.Button_DaySign then --签到
            require("app.views.UI.LayerGiftAndDaySign").new():Show()
        end
    end)

    UIHelper.BindClickByButtons({ self.Btn_0_0, self.Btn_0_1, self.Btn_0_2, self.Btn_0_3, self.Btn_0_4 }, function(sender, event)
        if sender == self.Btn_0_0 then --规则
            require("app.views.UI.LayerRule").new():Show()

        elseif sender == self.Btn_0_1 then --反馈
            require("app.views.UI.LayerCallWe").new():Show()

        elseif sender == self.Btn_0_2 then --代理
            local uuid = cc.UserDefault:getInstance():getStringForKey("UID", "null")
            cc.Application:getInstance():openURL(GAME_URL.helpUrl .. "?UKEY=" .. cc.UserDefault:getInstance():getStringForKey("SinLoveUkey", "a") .. "&ID=" .. PlayerManager.Player.userName .. "&uuid=" .. uuid)

        elseif sender == self.Btn_0_3 then --设置
            require("app.views.UI.LayerSetting").new():Show()

        elseif sender == self.Btn_0_4 then --退出
            require("app.views.UI.LayerOutGame").new():Show()
        end
    end)
end

function MainScene:refresh()
end

function MainScene:onEnterTransitionFinish()
    self.super.onEnterTransitionFinish(self)
    if SoundHelper.isMusicPlaying() then
        SoundHelper.stopMusic()
    end
    SoundHelper.playMusicSound(64, 0, true)

    AutoInRoom = function(roomid)
        PauseStateToLua2 = function(sutat)
            if sutat == 1 then
                print("连接 普通场 成功-2")
                WaitProgress.Show()
                FightManager.GameRoomtype = 1
                local data = string.sub(roomid, 15, string.len(roomid))
                local smsg = game_pb.IntoRequest()
                smsg.username = PlayerManager.Player.userName -- 1; //用户名
                smsg.roomNo = tonumber(data) --2;  //房间号
                local msgData = smsg:SerializeToString()
                MSG.send(Enum.INTO_ROOM_SERVER, msgData, 2)
                GlobalData.isServer2connect = true
            else
                print("连接 普通场 失败-2")
            end
            PauseStateToLua2 = function() print('PauseStateToLua2') end
        end
        -- 设置远端服务器
        Socket_SetServer(SERVER_NETGATE.ip2, SERVER_NETGATE.port2, 2)
        -- 连接服务器
        Socket_Reconnect(2)
    end
    platformMethod.AutoInRoom(AutoInRoom)

    ServiceMessageManager.GetNotice()
    ServiceMessageManager.GetRoomList()
    ServiceMessageManager.GetSystemSet()
    --刷新用户信息
    MSG.send(Enum.USER_INFO_SERVER, "", 1)
end

function MainScene:setRoleInfo()
    self.NameText:setString(PlayerManager.Player.name)
    self.IDText:setString("ID:" .. PlayerManager.Player.userName)
    self.MoneyText:setString(PlayerManager.Player.money)
    self.MoneyGoldText:setString(PlayerManager.Player.gold)
    UIHelper.loadImgUrl(self.HeadBg, PlayerManager.Player.head, PlayerManager.Player.userName)
    if PlayerManager.Player.sex == "男" then
        self.SexTag:loadTexture("male.png", ccui.TextureResType.plistType)
    elseif PlayerManager.Player.sex == "女" then
        self.SexTag:loadTexture("famale.png", ccui.TextureResType.plistType)
    end
end

function MainScene:onEnter()
    self.super.onEnter(self)
    print("MainScene:onEnter")
    self:setRoleInfo()
    --UI更新前端界面
    MessageHandle.addHandle(Enum.USER_INFO_CLIENT, function(msgid, data)
        WaitProgress.Close()
        --更新金币
        self.MoneyGoldText:setString(PlayerManager.Player.gold)
        --更新钻石
        self.MoneyText:setString(PlayerManager.Player.money)
    end, self)
    MessageHandle.addHandle(Enum.RECHARGE_PAY_RESUILT_CLIENT, function(msgid, data)
        --更新钻石
        self.MoneyText:setString(PlayerManager.Player.money)
    end, self)

    --收到创建房间消息
    MessageHandle.addHandle(Enum.GET_ROOM_CLIENT, function(msgid, data)
        --        WaitProgress.Close()
        local cmsg = hall_pb.GetRoomResponse()
        cmsg:ParseFromString(data)
        PauseStateToLua2 = function(sutat)
            if sutat == 1 then
                print("连接 普通场 成功-3")
                FightManager.GameRoomtype = 1
                local smsg = game_pb.IntoRequest()
                smsg.username = PlayerManager.Player.userName -- 1; //用户名
                smsg.roomNo = cmsg.roomNo --2;  //房间号
                local msgData = smsg:SerializeToString()
                MSG.send(Enum.INTO_ROOM_SERVER, msgData, 2)
                GlobalData.isServer2connect = true
            else
                print("连接 普通场 失败-3")
            end
            PauseStateToLua2 = function() print('PauseStateToLua2') end
        end
        Socket_SetServer(SERVER_NETGATE.ip2, SERVER_NETGATE.port2, 2)
        Socket_Reconnect(2)
    end, self)

    --收到进入房间消息
    MessageHandle.addHandle(Enum.INTO_ROOM_CLIENT, function(msgid, data)
        resumeGame_roomid = nil
        local pScene = require("app.views.Scenes.FightScene.GameFightScene"):new()
        cc.Director:getInstance():replaceScene(pScene)
        WaitProgress.Close()
    end, self)

    MessageHandle.addHandle(Enum.GAME_RECORD_CLIENT, function(msgid, data)
        WaitProgress.Close()
        require("app.views.UI.NewLayerResultRecord").new():Show():showPanelIndex(1)
    end, self)







    MessageHandle.addHandle(Enum.ROOMS_CLIENT, function(msgid, data)

        local cmsg = hall_pb.RoomResponse()
        if data ~= null then

            cmsg:ParseFromString(data)

            if tonumber(#cmsg.rooms) > 0 then
                self.RoomListView:removeAllItems()

                for i = 1, #cmsg.rooms do

                    local cell = cc.CSLoader:createNode('PopUIs/RoomCell.csb'):getChildByName("RecodeItem")
                    local roomnumLabel = cell:getChildByName("roomnum")
                    local roompointLabel = cell:getChildByName("roompoint")
                    local roomtimeLabel = cell:getChildByName("roomtime")
                    local roompeopleLabel = cell:getChildByName("roompeople")
                    local roomInvitationBtn = cell:getChildByName("Button_Invitation")
                    local item = cmsg.rooms[i]
                    roomnumLabel:setString(item.roomNo)
                    roompointLabel:setString(item.baseScore)
                    roomtimeLabel:setString(item.round)
                    roompeopleLabel:setString(item.count)


                    UIHelper.BindClickByButton(roomInvitationBtn, function(sender, event)
                        local shareStr = ""
                        if item.gameType == 5 then
                            shareStr = "底分：" .. item.baseScore
                        else
                            shareStr = "底分：" .. item.baseScore .. "/" .. item.baseScore * 2
                        end
                        shareStr = shareStr .. "、" .. item.round .. "局，让我们一起斗起来!"
                        ServiceMessageManager.WeChatShare(item.roomNo, APP_INFO.appname .. "◆房间号【" .. item.roomNo .. "】", shareStr, "", 0, 5)
                    end)


                    UIHelper.BindClickByButton(cell, function(sender, event)

                        local SinLoveJinBiRoom = cc.UserDefault:getInstance():getStringForKey("SinLoveJinBiRoom", "a")


                        PauseStateToLua2 = function(sutat)
                            if sutat == 1 then
                                print("连接 普通场 成功-5")
                                WaitProgress.Show()
                                FightManager.GameRoomtype = 1
                                local smsg = game_pb.IntoRequest()
                                smsg.username = PlayerManager.Player.userName -- 1; //用户名
                                smsg.roomNo = tonumber(roomnumLabel:getString()) --2;  //房间号
                                local msgData = smsg:SerializeToString()
                                MSG.send(Enum.INTO_ROOM_SERVER, msgData, 2)
                                GlobalData.isServer2connect = true
                            else
                                print("连接 普通场 失败-5")
                            end
                            PauseStateToLua2 = function() print('PauseStateToLua2') end
                        end
                        Socket_SetServer(SERVER_NETGATE.ip2, SERVER_NETGATE.port2, 2)
                        Socket_Reconnect(2)
                    end)
                    cell:removeFromParent()
                    self.RoomListView:pushBackCustomItem(cell)
                end



                if resumeGame_roomid ~= nil then
                    FightManager.GameRoomtype = 1
                    local smsg = game_pb.IntoRequest()
                    smsg.username = PlayerManager.Player.userName -- 1; //用户名
                    smsg.roomNo = resumeGame_roomid --2;  //房间号
                    local msgData = smsg:SerializeToString()
                    MSG.send(Enum.INTO_ROOM_SERVER, msgData, 2)
                    GlobalData.isServer2connect = true
                end
            end
        else
            print("数据data解析为空")
        end
    end, self)





    MessageHandle.addHandle(Enum.RECEIVE_GOLD_CLIENT, function(msgid, data)
        local cmsg = hall_pb.ReceiveGoldResponse()
        cmsg:ParseFromString(data)
        PlayerManager.Player.gold = PlayerManager.Player.gold + cmsg.gold
        self.MoneyGoldText:setString(PlayerManager.Player.gold)
    end, self)

    MessageHandle.addHandle(Enum.RECEIVE_BENEFIT_CLIENT, function(msgid, data)

        local cmsg = hall_pb.ReceiveBenefitResponse()
        cmsg:ParseFromString(data)
        PlayerManager.Player.gold = PlayerManager.Player.gold + cmsg.gold
        self.MoneyGoldText:setString(PlayerManager.Player.gold)
    end, self)

    MessageHandle.addHandle(Enum.LOGIN_CLIENT, function(msgid, data)
        --登录成功
        ServiceMessageManager.GetNotice()
        ServiceMessageManager.GetRoomList()
        ServiceMessageManager.GetSystemSet()
        --刷新用户信息
        MSG.send(Enum.USER_INFO_SERVER, "", 1)
    end, self)

    MessageHandle.addHandle(Enum.ERROR_CLIENT, function(msgid, data)

        local cmsg = hall_pb.ErrorResponse()
        cmsg:ParseFromString(data)

        if cmsg.errorCode == ErrorCode.ERROR_ROOM_NOT_EXISTS then
            self.RoomListView:removeAllItems()
        end
    end, self)
end


function MainScene:onExit()
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListener(self.listener1)
    self.super.onExit(self)
    MessageHandle.removeHandle(self)
end

return MainScene
