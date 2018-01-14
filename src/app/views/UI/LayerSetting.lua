--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerSetting = class("LayerSetting", require("app.views.UI.PopUI"))
function LayerSetting:ctor(comefrom)
    LayerSetting.super.ctor(self)
    self:BindNodes(self.WidgetNode,
    "Panel_1",
    "Panel_1.Button_Close",
    "Panel_1.Button_Sure",
    "Panel_1.Button_ChangeAcc",
    "Panel_1.Slider_Music",
    "Panel_1.Slider_Sound",
    "Panel_1.Button_1",
    "Panel_1.Button_2")
    if comefrom=="game" then
        self.Button_ChangeAcc:setVisible(false)
        self.Button_Sure:setPositionX(self.Panel_1:getCenter().x)
    end

    self.isNomusic =cc.UserDefault:getInstance():getIntegerForKey("isNoMusic",0)
    self.isNosound =cc.UserDefault:getInstance():getIntegerForKey("isNoSound",0)

    self.music = cc.UserDefault:getInstance():getIntegerForKey("isMusic",60)
    self.sound = cc.UserDefault:getInstance():getIntegerForKey("isEffect",60)

    if self.isNomusic == 0 then
        self.Slider_Music:setPercent(0)
    else
        self.Slider_Music:setPercent(self.music)
    end
    if self.isNosound == 0 then
        self.Slider_Sound:setPercent(0)
    else
        self.Slider_Sound:setPercent(self.sound)
    end
    
    self:buttonEvent()
end
function LayerSetting:buttonEvent()
    UIHelper.BindClickByButtons({self.Button_Close,self.Button_Sure,self.Button_ChangeAcc,self.Button_1,self.Button_2}, function(sender, event)
       if sender==self.Button_Close then
            self:Close()
       elseif sender == self.Button_1 then
           if self.isNomusic == 0 then
--               cc.UserDefault:getInstance():setIntegerForKey("isNoMusic",1)
               self.isNomusic = 1
               if self.music == 0 then
                    SoundHelper.setMusicVolume(60)
                    self.Slider_Music:setPercent(60)
                    self.music = 60
               else
                    SoundHelper.setMusicVolume(self.music)
                    self.Slider_Music:setPercent(self.music)
               end
               
           else
--               cc.UserDefault:getInstance():setIntegerForKey("isNoMusic",0)
               self.isNomusic = 0
               SoundHelper.setMusicVolume(0)
               self.Slider_Music:setPercent(0)
           end
       elseif sender == self.Button_2 then
           if self.isNosound == 0 then
--               cc.UserDefault:getInstance():setIntegerForKey("isNoSound",1)
               self.isNosound = 1
               if self.sound == 0 then
                    SoundHelper.setEffectsVolume(60)
                    self.Slider_Sound:setPercent(60)
                    self.sound = 60
               else
                    SoundHelper.setEffectsVolume(self.sound)
                    self.Slider_Sound:setPercent(self.sound)
               end
               
           else
--               cc.UserDefault:getInstance():setIntegerForKey("isNoSound",0)
               self.isNosound = 0
               SoundHelper.setEffectsVolume(0)
               self.Slider_Sound:setPercent(0)
           end
       elseif sender == self.Button_Sure then
           if self.isNomusic ~= 0 then
                cc.UserDefault:getInstance():setIntegerForKey("isMusic",self.music)
           end
           if self.isNosound ~= 0 then
                cc.UserDefault:getInstance():setIntegerForKey("isEffect",self.sound)
           end
           cc.UserDefault:getInstance():setIntegerForKey("isNoMusic",self.isNomusic)
           cc.UserDefault:getInstance():setIntegerForKey("isNoSound",self.isNosound)
           self:Close()
       elseif sender == self.Button_ChangeAcc then
            local layer=require("app.views.UI.LayerTips").new("是否确定更换账号",true):Show():SetCloseCallBack(function(isupdata)
                if isupdata==true then
                    local scene = require("app.views.Scenes.LoadingScene.LoadingScene"):new()
                    cc.Director:getInstance():replaceScene(scene)
                    ServiceMessageManager.SaveUserAccessToken("NoToken")
                    ServiceMessageManager.SaveUserRefreshToken("NoToken")
                    ServiceMessageManager.SaveUserOpenId("NoToken")
                end
            end)
       end
    end )

    self.Slider_Music:addEventListener(function(sender,event)
        local value = self.Slider_Music:getPercent()
        print("Slider_Music"..value)
        self.music = value
        self.isNomusic = value
        SoundHelper.setMusicVolume(value)
    end)

    self.Slider_Sound:addEventListener(function(sender,event)
        local value = self.Slider_Sound:getPercent()
        self.sound = value
        self.isNosound = value
        print("Slider_Sound"..value)
        SoundHelper.setEffectsVolume(value)
    end)
end

function LayerSetting:getWidget()
    return "PopUIs/LayerSetting.csb"
end

function LayerSetting:onEnter()
    self.super.onEnter(self)
end

function LayerSetting:onExit()
    self.super.onExit(self)
    --region 只要关闭就保存设置 。。。。(额外增加)
    if self.isNomusic ~= 0 then
        cc.UserDefault:getInstance():setIntegerForKey("isMusic",self.music)
    end
    if self.isNosound ~= 0 then
        cc.UserDefault:getInstance():setIntegerForKey("isEffect",self.sound)
    end
    cc.UserDefault:getInstance():setIntegerForKey("isNoMusic",self.isNomusic)
    cc.UserDefault:getInstance():setIntegerForKey("isNoSound",self.isNosound)
    --endregion
    self.isNomusic =cc.UserDefault:getInstance():getIntegerForKey("isNoMusic",1)
    self.isNosound =cc.UserDefault:getInstance():getIntegerForKey("isNoSound",1)

    self.music = cc.UserDefault:getInstance():getIntegerForKey("isMusic",60)
    self.sound = cc.UserDefault:getInstance():getIntegerForKey("isEffect",60)

    if self.isNomusic == 0 then
        self.Slider_Music:setPercent(0)
    else
        self.Slider_Music:setPercent(self.music)
    end
    if self.isNosound == 0 then
        self.Slider_Sound:setPercent(0)
    else
        self.Slider_Sound:setPercent(self.sound)
    end

    SoundHelper.setMusicVolume(self.Slider_Music:getPercent())
    SoundHelper.setEffectsVolume(self.Slider_Sound:getPercent())
end
return LayerSetting
--endregion
