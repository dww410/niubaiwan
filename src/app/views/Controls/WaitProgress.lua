--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
-- User: CongQin
-- Date: 16/04/11
-- Time: 下午15:00
-- To change this template use File | Settings | File Templates.
--

local WaitProgressTag=9999999
local s = cc.Director:getInstance():getWinSize()

local PopUI=require('app.views.UI.PopUI')
local WaitProgress=class('WaitProgress',PopUI)

function WaitProgress:ctor()
    WaitProgress.super.ctor(self)
                
    local spLoading=cc.CSLoader:createNode('Animation/Am_pingming.csb')
    spLoading.AnimateTimeLine = cc.CSLoader:createTimeline('Animation/Am_pingming.csb')
    spLoading:runAction(spLoading.AnimateTimeLine)
    spLoading.AnimateTimeLine:play("play",true)
    
    spLoading:addTo(self):setPosition(cc.p(s.width/2,s.height/2))

end

function WaitProgress.Show(showTime)
    local currentScene = cc.Director:getInstance():getRunningScene()
    local node=currentScene:getChildByTag(WaitProgressTag)
    if node~=nil then
        return nil
    else
        local ui=WaitProgress.new()
        currentScene:addChild(ui,WaitProgressTag,WaitProgressTag)
        local time=checknumber(showTime)
        ui:runAction(cc.Sequence:create(cc.DelayTime:create(time>0 and time or 15),cc.CallFunc:create(function()
        WaitProgress.Close()
        end)))
        return ui
    end
end

function WaitProgress.Close()
    local currentScene = cc.Director:getInstance():getRunningScene()
    local node=currentScene:getChildByTag(WaitProgressTag)
    if node~=nil then
        node:removeFromParent()
    end
end

function WaitProgress:onEnter()
    self.super.onEnter(self)
end

function WaitProgress:onExit()
    self.super.onExit(self)
end

return WaitProgress

--endregion
