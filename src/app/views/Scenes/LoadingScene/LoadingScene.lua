--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
--登陆加载界面
-- User: CongQin
-- Date: 17/02/10
require('app.Commnucation.MessageHandle')
local LoadingScene = class("LoadingScene", require("app.views.Scenes.Common.SceneBase"))
local WaitProgress = require('app.views.Controls.WaitProgress')
local MessageTip = require('app.views.UI.MessageTip')
local platformMethod = require('app.Platform.platformMethod')
local targetPlatform = cc.Application:getInstance():getTargetPlatform()
local socket = require("socket")

function LoadingScene:ctor()
    LoadingScene.super.ctor(self)
    platformMethod.GetDeviceID()
    self:loadSceneCSB('Scenes/LoadingScene.csb')
    self:BindNodes(self.root, "spLoadingBg",
        "uiProgress",
        "txtVersion",
        "Panel_button.Btn_Login",
        "Panel_button.Btn_Login_idle",
        "Panel_button.Btn_Agreement",
        "Panel_button.CheckBox_Agreement",
        "Panel_button",
        "Panel_Agreement",
        "Panel_Agreement.CloseBtn",
        "Panel_Agreement.ScrollView_Agreement")
    self.uiProgress:BindNodes(self.uiProgress, "txtProgress", "barProgress", 'parProgress')
    self.txtVersion:setString('Ver:' .. Version)
    self.txtVersion:setVisible(false)
    self:reloadScripts()
    self:initEvent()

    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
        self.editBox = ccui.EditBox:create(cc.size(150, 40), "")
        self.editBox:setContentSize(cc.size(150, 40))
        self.editBox:setPlaceholderFontSize(24)
        self.editBox:setPlaceholderFontColor(cc.c3b(102, 76, 150))
        self.editBox:setAnchorPoint(cc.p(0.5, 0.5))
        self.editBox:setPositionX(self.Btn_Login:getPositionX() + 100)
        self.editBox:setPositionY(self.Btn_Login:getPositionY() + 100)
        self.editBox:setText("q1")
        self.editBox:setFont(DEFAULTFONT, 24)
        self.editBox:setInputFlag(1)
        self.editBox:setFontColor(cc.c3b(102, 76, 150))
        self.editBox:setReturnType(1) --发送
        self.editBox:setInputMode(6) --不允许换行
        self:addChild(self.editBox)
    end
end

function LoadingScene:onEnterTransitionFinish()
    self.super.onEnterTransitionFinish(self)
    GlobalData.popNotice = true
    self:updateFinish()

    self:runAction(transition.sequence({
        cc.DelayTime:create(1), cc.CallFunc:create(function()
            --Socket_Deconnect()
        end)
    }))
end


function LoadingScene:reloadScripts()
    package.loaded['app.Commnucation.enum'] = nil
    package.loaded['app.Commnucation.Message'] = nil
    package.loaded['app.Commnucation.MessageHandle'] = nil
    package.loaded['app.Commnucation.MessageManager'] = nil

    package.loaded['app.DataManager.DataManager'] = nil
    package.loaded['app.DataManager.FightManager'] = nil
    package.loaded['app.DataManager.GlobalDataManager'] = nil
    package.loaded['app.DataManager.PlayerManager'] = nil
    package.loaded['app.DataManager.UnionManager'] = nil

    package.loaded['app.views.FightScene.CardHelp'] = nil
    package.loaded['app.views.FightScene.CardsAnalyzer'] = nil
    package.loaded['app.views.FightScene.GameddzHelp'] = nil
    package.loaded['app.views.FightScene.GamezjhHelp'] = nil
    package.loaded['app.views.FightScene.GameNiuniuHelp'] = nil

    package.loaded['GlobalExtention'] = nil
    package.loaded['Tool'] = nil
    package.loaded['Json'] = nil
    package.loaded['app.UIHelper'] = nil
    package.loaded['app.Language.Language'] = nil
    package.loaded['app.SoundHelper'] = nil
    package.loaded['config'] = nil
    package.loaded['s_sound'] = nil

    require("config")
    require "cocos.init"
    --require("GlobalExtention")

    require('app.Commnucation.MessageHandle')
    reloadMessages()
    cc.exports.UIHelper = require('app.UIHelper')
    cc.exports.SoundHelper = require('app.SoundHelper')
    cc.exports.Language = require('app.Language.Language')
    cc.exports.s_sound = require("app.Config.s_sound")
    cc.exports.Tool = require("Tool")
    cc.exports.Json = require("Json")
end

function LoadingScene:updateFinish() --游戏更新完成后调用
    -- 加载资源
    local needLoadImagesIdx = {
        2, 3, 4, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16
    }
    self.uiProgress.txtProgress:setString('资源加载中')
    local resCount = 1
    table.foreach(needLoadImagesIdx, function(k, v)
        local strPng = "image/Images" .. v .. ".png"
        local strPlist = "image/Images" .. v .. ".plist"

        cc.Director:getInstance():getTextureCache():addImageAsync(strPng, function()
            cc.SpriteFrameCache:getInstance():addSpriteFrames(strPlist, strPng)
            print("load image " .. strPlist .. "  " .. strPng)

            self.uiProgress.txtProgress:setString('资源加载中' .. math.ceil(resCount / #needLoadImagesIdx * 100) .. '%')
            self.uiProgress.barProgress:setPercent(resCount / #needLoadImagesIdx * 100)
            self.uiProgress.parProgress:move(355 + resCount / #needLoadImagesIdx * (self.uiProgress.barProgress:getContentSize().width - 20), 34.94)
            if resCount == #needLoadImagesIdx then
                self.uiProgress.barProgress:setPercent(100)
                self:runAction(transition.sequence({
                    cc.DelayTime:create(0.3),
                    cc.CallFunc:create(function()
                        self.uiProgress.txtProgress:setString('声音加载中')
                    end),
                    cc.DelayTime:create(0.3),
                    cc.CallFunc:create(function()
                        self:loadAudio()
                        self.uiProgress:setVisible(false)
                        --WaitProgress.Show()
                        --self:connect()
                        self.Panel_button:setVisible(true)
                    end),
                    cc.DelayTime:create(0.1),
                    cc.CallFunc:create(function()
                        local access_token = ServiceMessageManager.LoadUserAccessToken()
                        local openid = ServiceMessageManager.LoadUserOpenId()
                        if access_token ~= "NoToken" and openid ~= "NoToken" then
                            ServiceMessageManager.WeChatCheckToken(access_token, openid)
                        end
                    end)
                }))
            end
            resCount = resCount + 1
        end)
    end)
end

function LoadingScene:loadAudio()
    if SoundHelper.isMusicPlaying() then
        SoundHelper.stopMusic()
    end
    --预加载音效资源
    table.foreach(s_sound, function(k, v)
        if v.sencetype == 5 and v.effecttype == 2 then
            if v.effecttype == 1 then
                SoundHelper.preloadEffect("sound/NiuNiu/music" .. v.resouce)
            elseif v.effecttype == 2 then
                SoundHelper.preloadEffect("sound/NiuNiu/man" .. v.resouce)
                SoundHelper.preloadEffect("sound/NiuNiu/woman" .. v.resouce)
            end
        elseif v.restype == 4 then
        end
    end)

    SoundHelper.preloadEffect(s_sound[65].resouce)
    SoundHelper.playMusicSound(64, 0, true)


    cc.UserDefault:getInstance():setStringForKey("SinLoginType", "a")
    cc.UserDefault:getInstance():setStringForKey("SinLoveUkey", "a")

    self.Btn_Login:setVisible(false)
    self.Btn_Login_idle:setVisible(false)

    if cc.Application:getInstance():getTargetPlatform() == cc.PLATFORM_OS_WINDOWS then
        self.Btn_Login:setVisible(false)
        self.Btn_Login_idle:setVisible(true)
    else

--        local xhr = MSG.newXMLHttpRequest()

--        MSG.getHttp(xhr, "http://down.nn.14339.com/xhn/api/LoginCheck.asp?S=&V=108", function()
--            if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then

--                local fileData = json.decode(xhr.response)
--                if fileData.code == 1 then
--                    self.Btn_Login:setVisible(false)
--                    self.Btn_Login_idle:setVisible(true)
--                    cc.UserDefault:getInstance():setStringForKey("SinLoginType", "b")
--               else
--                    self.Btn_Login_idle:setVisible(false)
--                    self.Btn_Login:setVisible(true)
--                    local refresh_token = ServiceMessageManager.LoadUserRefreshToken()
--                    if refresh_token ~= "NoToken" then
--                        ServiceMessageManager.WeChatRefreshToken(refresh_token)
--                    end
--                end
--                cc.UserDefault:getInstance():setStringForKey("SinLoveUkey", fileData.SinLoveUkey)
--            else

--                self.Btn_Login_idle:setVisible(false)
--                self.Btn_Login:setVisible(true)
--                local refresh_token = ServiceMessageManager.LoadUserRefreshToken()
--                if refresh_token ~= "NoToken" then
--                    ServiceMessageManager.WeChatRefreshToken(refresh_token)
--                end
--            end
--            WaitProgress.Close()
--       end)
    end

    local hasWeixin = platformMethod.isWXAppInstalled()
    if hasWeixin == "true"  then
        print("@@@@@@@@@@@@@@  has we chat")
        self.Btn_Login:setVisible(true)
        self.Btn_Login_idle:setVisible(false)
        local refresh_token = ServiceMessageManager.LoadUserRefreshToken()
        if refresh_token ~= "NoToken" then
            ServiceMessageManager.WeChatRefreshToken(refresh_token)
        end
    else
        print("@@@@@@@@@@@@@@  has no chat")
        self.Btn_Login:setVisible(false)
        self.Btn_Login_idle:setVisible(true)
    end
    WaitProgress.Close()
end

function LoadingScene:initEvent()
    UIHelper.BindClickByButtons({ self.Btn_Login, self.Btn_Login_idle, self.Btn_Agreement, self.CloseBtn }, function(sender, event)
        if sender == self.Btn_Agreement then
            self.Panel_Agreement:setVisible(true)
        elseif sender == self.Btn_Login then

            if self.CheckBox_Agreement:isSelected() == true then

                WaitProgress.Show()
                if targetPlatform == cc.PLATFORM_OS_ANDROID or targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
                    LoginStuate = function(code)
                        if code == "-4" then
                            MessageTip.Show("您拒绝了授权")
                            WaitProgress.Close()
                        elseif code == "-2" then
                            MessageTip.Show("您已取消")
                            WaitProgress.Close()
                        elseif code == "-98" then
                            MessageTip.Show("您已取消")
                            WaitProgress.Close()
                        elseif code == "-99" then
                            MessageTip.Show("请先安装微信")
                            WaitProgress.Close()
                        else
                            ServiceMessageManager.WeChatLogin(code)
                        end
                    end


                    local access_token = ServiceMessageManager.LoadUserAccessToken()
                    local openid = ServiceMessageManager.LoadUserOpenId()
                    if access_token == "NoToken" or openid == "NoToken" then
                        platformMethod.weichatlogin(LoginStuate)
                    else
                        ServiceMessageManager.WeChatCheckToken(access_token, openid)
                    end


                elseif targetPlatform == cc.PLATFORM_OS_WINDOWS then
                    self:login(self.editBox:getText(), 1, self.editBox:getText(), "", "pc")
                else
                    self:login(self.editBox:getText(), 1, self.editBox:getText(), "", "pc")
                end




            else
                MessageTip.Show("请先同意用户协议！")
            end


        elseif sender == self.Btn_Login_idle then --游客登录

            local uuid = cc.UserDefault:getInstance():getStringForKey("UID", "null")
            ServiceMessageManager.unionid = uuid
            if targetPlatform == cc.PLATFORM_OS_ANDROID then
                self:login(uuid, 1, uuid, "", "android")
                ServiceMessageManager.platform = "android"
            elseif targetPlatform == cc.PLATFORM_OS_IPHONE or targetPlatform == cc.PLATFORM_OS_IPAD then
                self:login(uuid, 1, uuid, "", "ios")
                ServiceMessageManager.platform = "ios"
            else
                self:login(self.editBox:getText(), 1, self.editBox:getText(), "", "pc")
            end
        elseif sender == self.CloseBtn then
            self.Panel_Agreement:setVisible(false)
        end
    end)
end

function LoadingScene:login(unionid, sex, nickname, headimgurl, data)
    PauseStateToLua = function(sutat)
        if sutat == 1 then
            print("连接 大厅服务器 成功-2")
            local smsg = hall_pb.LoginRequest()
            smsg.token = unionid
            smsg.sex = sex
            smsg.headimgurl = headimgurl
            smsg.name = nickname
            smsg.platform = data
            local msgData = smsg:SerializeToString()
            print("name" .. smsg.name)
            MSG.send(Enum.LOGIN_SERVER, msgData, 1)
            GlobalData.isServer1connect = true
        else
            print("连接 大厅服务器 失败-2")
        end
        PauseStateToLua = function() print('PauseStateToLua') end
    end
    -- 连接服务器
    Socket_Reconnect(1)
end

function LoadingScene:onEnter()
    self.super.onEnter(self)
    --收到登录成功消息
    MessageHandle.addHandle(Enum.LOGIN_CLIENT, function(msgid, data)
        WaitProgress.Close()
        local cmsg = hall_pb.LoginResponse()
        cmsg:ParseFromString(data)

        local pScene = require("app.views.Scenes.MainScene.MainScene"):new()
        cc.Director:getInstance():replaceScene(pScene)
        MessageHandle.DataManager.sendHeart()
    end, self)
end


function LoadingScene:onExit()
    self.super.onExit(self)
    MessageHandle.removeHandle(self)
end

return LoadingScene

--endregion
