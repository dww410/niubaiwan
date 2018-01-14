--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
require("GlobalExtention")
local GameMain = class("GameMain", cc.load("mvc").ViewBase)
local platformMethod = require('app.Platform.platformMethod')

function GameMain:onCreate()
    self:loadSceneCSB('Scenes/LoadingScene.csb')
    self:BindNodes(self.root,"uiProgress","txtVersion","Panel_button.Btn_Agreement","Panel_button.Btn_Login","Panel_button")
    self.uiProgress:BindNodes(self.uiProgress, "txtProgress", "barProgress",'parProgress')
    self.txtVersion:setString(" ")
    self.txtVersion:setVisible(false)


    local isX32=platformMethod.GetStstemVersion()
    platformMethod.GetDeviceID()
    local am
    if isX32=="32"then
        am = cc.AssetsManagerEx:create('Manifest/project32.manifest', cc.FileUtils:getInstance():getWritablePath() .. 'update')
    else
        am = cc.AssetsManagerEx:create('Manifest/project64.manifest', cc.FileUtils:getInstance():getWritablePath() .. 'update')
    end

    am:retain()
    self:loadAudio()
    if not am:getLocalManifest():isLoaded() then
        print("Fail to update assets, step skipped.")
        self.uiProgress.txtProgress:setString("更新失败")

        local pScene=require("app.views.Scenes.LoadingScene.LoadingScene"):new()
        cc.Director:getInstance():replaceScene(pScene)
    else
        local function onUpdateEvent(event)
                --dump(event)
            local eventCode = event:getEventCode()
                print('update eventCode:'..eventCode)
            if eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_NO_LOCAL_MANIFEST then
                print("No local manifest file found, skip assets update.")
                self.uiProgress.txtProgress:setString("找不到本地版本配置")

                local pScene=require("app.views.Scenes.LoadingScene.LoadingScene"):new()
                cc.Director:getInstance():replaceScene(pScene)

            elseif eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_PROGRESSION then
                local assetId = event:getAssetId()
                local percent = event:getPercent()
                local strInfo = ""

                if assetId == cc.AssetsManagerExStatic.VERSION_ID then
                    strInfo = string.format("Version file: %d%%", percent)
                elseif assetId == cc.AssetsManagerExStatic.MANIFEST_ID then
                    strInfo = string.format("Manifest file: %d%%", percent)
                else
                    strInfo = string.format("正在更新%d%%", percent)
                    self.uiProgress.barProgress:setPercent(percent)
                    self.uiProgress.txtProgress:setString(strInfo)
                    self.uiProgress.parProgress:move(355+percent/100 *(self.uiProgress.barProgress:getContentSize().width-20),34.94)
                end
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_DOWNLOAD_MANIFEST or
                eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_PARSE_MANIFEST then
                print("Fail to download manifest file, update skipped.")
                self.uiProgress.txtProgress:setString('获取版本信息失败')

                local pScene=require("app.views.Scenes.LoadingScene.LoadingScene"):new()
                cc.Director:getInstance():replaceScene(pScene)

            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ALREADY_UP_TO_DATE or
                eventCode == cc.EventAssetsManagerEx.EventCode.UPDATE_FINISHED then
                self.uiProgress.txtProgress:setString('更新完成')
                self:runAction(cc.Sequence:create(
                    cc.DelayTime:create(0.4),
                    cc.CallFunc:create(function()
                        local pScene=require("app.views.Scenes.LoadingScene.LoadingScene"):new()
                        cc.Director:getInstance():replaceScene(pScene)
                     end)
                ))
                am:release()
            elseif eventCode == cc.EventAssetsManagerEx.EventCode.ERROR_UPDATING then
                    print("Asset ", event:getAssetId(), ", ", event:getMessage())
            end
        end

        self.listener1 = cc.EventListenerAssetsManagerEx:create(am, onUpdateEvent)
        cc.Director:getInstance():getEventDispatcher():addEventListenerWithFixedPriority(self.listener1, 1)

       self:runAction(transition.sequence({cc.DelayTime:create(0.5),cc.CallFunc:create(function() am:update() end)}))
       --self:runAction(transition.sequence({cc.DelayTime:create(0.5),cc.CallFunc:create(function() self:updateFinish() end)}))
    end

   
   
end


function GameMain:onEnterTransitionFinish()
    -- 设置远端服务器
    Socket_Init( SERVER_NETGATE.ip1, SERVER_NETGATE.port1,1)
end

function GameMain:updateFinish()
    -- 设置远端服务器
    local pScene=require("app.views.Scenes.LoadingScene.LoadingScene"):new()
    cc.Director:getInstance():replaceScene(pScene)
    self:loadAudio()
end

function GameMain:loadAudio()
    cc.exports.SoundHelper = require('app.SoundHelper')
    local music = cc.UserDefault:getInstance():getIntegerForKey("isMusic",100)
    local sound = cc.UserDefault:getInstance():getIntegerForKey("isEffect",100)
    local isNomusic =cc.UserDefault:getInstance():getIntegerForKey("isNoMusic",100)
    local isNosound =cc.UserDefault:getInstance():getIntegerForKey("isNoSound",100)

    if isNomusic == 0 then
        SoundHelper.setMusicVolume(0)
    else
        SoundHelper.setMusicVolume(music)
    end

    if isNosound == 0 then
        SoundHelper.setEffectsVolume(0)
    else
        SoundHelper.setEffectsVolume(sound)
    end
end

function GameMain:onEnter()
    
end

function GameMain:onExit()
    cc.Director:getInstance():getEventDispatcher():removeEventListener(self.listener1)

end

return GameMain


--endregion
