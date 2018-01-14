--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
-- User: CongQin
-- Date: 16/04/11
-- Time: 下午14：54
-- To change this template use File | Settings | File Templates.
--

local root
local s = cc.Director:getInstance():getWinSize()

cc.exports.popuis={}

local PopUI = class("PopUI", cc.Layer)

function PopUI:ctor()
    --触摸关闭方法 0:触摸不关闭 1:触摸空白关闭 2:触摸框提关闭 3:触摸任意处关闭
    self.CloseType = 1
    --状态  0:已创建 1:准备显示  2:显示中 3:关闭中
    self.Status=0
    self.WidgetNode=nil
    self.AnimateTimeLine=nil
    self.listenner=nil
    local layBG = cc.LayerColor:create(cc.c4b(35, 35, 35, 100), s.width, s.height)
    layBG:setAnchorPoint(cc.p(0.5, 0.5))
    layBG:ignoreAnchorPointForPosition(false)
    layBG:setPosition(cc.p(s.width / 2, s.height / 2))
    layBG:setName("BG")
    layBG:addTo(self)

    local this = self
    self.listenner= cc.EventListenerTouchOneByOne:create()
    self.listenner:setSwallowTouches(true)
    self.listenner:registerScriptHandler( function(touch, event)
        if not self.touchCount then
            self.touchCount=1
        else
            self.touchCount=self.touchCount+1
        end
        self.moved=cc.p(0,0)
        return true
    end , cc.Handler.EVENT_TOUCH_BEGAN)
    self.listenner:registerScriptHandler( function(touch, event)
        self.moved=cc.p(self.moved.x+touch:getDelta().x,self.moved.y+touch:getDelta().y)
    end , cc.Handler.EVENT_TOUCH_MOVED)
    self.listenner:registerScriptHandler( function(touch, event)
        if not self.touchCount then
            self.touchCount=0
        else
            self.touchCount=self.touchCount-1
        end
        if self.touchCount and self.touchCount>0 then
            return
        end
        if self.moved and cc.pGetLength(self.moved)>8 then 
            return 
        end
        local x, y = touch:getLocation().x, touch:getLocation().y
        if self.WidgetNode~=nil and self.CloseType~=0 then
            if (self.CloseType==1 and not cc.rectContainsPoint(self.WidgetNode:getBoundingBox(), cc.p(x, y)))
            or (self.CloseType==2 and cc.rectContainsPoint(self.WidgetNode:getBoundingBox(), cc.p(x, y)))
            or self.CloseType==3 then
                if self.OnClosing() then
                    self:Close()
                    return true--false
                end
            end
        end
    end , cc.Handler.EVENT_TOUCH_ENDED)

    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listenner, self)
    
    local uiname = self:getWidget()
    if uiname ~= nil then
        local this=self;
        self.WidgetNode = cc.CSLoader:createNode(uiname)
        self.AnimateTimeLine = cc.CSLoader:createTimeline(uiname)
        if self.loadedCSBCallFunc then
            self:loadedCSBCallFunc(self.WidgetNode)
        else
            --自动缩放
            local rate= cc.Director:getInstance():getVisibleSize().width/960
            if rate<=0.8 then
                self.WidgetNode:setScale(rate+0.2)
            elseif rate>=1.2 then
                self.WidgetNode:setScale(1.2)
            end
        end
        self.WidgetNode:setAnchorPoint(cc.p(0.5, 0.5))
        self.WidgetNode:setPosition(cc.p(s.width / 2, s.height /2))
        self.WidgetNode:addTo(self)
        self.Status=2
        self.WidgetNode:runAction(self.AnimateTimeLine)
        self.AnimateTimeLine:play("Open",false)
    end

    local function onNodeEvent(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        elseif event == "enterTransitionFinish" then
            self:onEnterTransitionFinish()
        end
    end

    self:registerScriptHandler(onNodeEvent)
    --print("PopUI:onCreate")
end

function PopUI:getWidget()
    --print("PopUI:getWidget")
    return nil
end

function PopUI:OnClosing()
    return true
end

function PopUI:onEnter()

end
function PopUI:onEnterTransitionFinish()

end
function PopUI:onExit()
    self:getEventDispatcher():removeEventListener(self.listenner)
    self.listenner=nil
end

function PopUI:Show()
    PopsViewsNums = PopsViewsNums + 1

    self.Status=1
    local currentScene = cc.Director:getInstance():getRunningScene()
    if self ~= nil then
        self:setTag(PopsViewsNums + 100)
        currentScene:addChild(self,PopsViewsNums + 100)
        table.insert(popuis,self)
    end
    return self
end

function PopUI:SetCloseCallBack(func)
    self.onClosed=func
    return self
end

function PopUI:Close()
    PopsViewsNums = PopsViewsNums - 1
    PopsViewsNums = PopsViewsNums < 0 and 0 or PopsViewsNums

    if self.onClosed ~= nil then
	    self.onClosed(self.Updated)
    end
    self.Status=3
    table.removebyvalue(popuis,self)
    self:removeFromParent()
end

function PopUI.getPopUI(cname)
    table.foreach(popuis,function(i,v)
        if v.__cname==cname then
            return v
        end
    end)
end

return PopUI

--endregion
