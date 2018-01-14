--[[
    跑马灯
]]

local BulletinUI = class("BulletinUI", cc.Layer)

function BulletinUI:ctor()
    self:registerScriptHandler(function(state)
        if state == "enter" then
            self:onEnter()
        elseif state == "exit" then
            self:onExit()
        end
    end)


    --系统公告消息
    self.m_SystemText = {}
    --背景色
    self.m_BulletBackground = cc.LayerColor:create(cc.c3b(0, 0, 0, 200), display.width-300, 30)
    self.m_BulletBackground:setOpacity(0)

    local outerClipper = cc.ClippingNode:create()
    outerClipper:setContentSize(self.m_BulletBackground:getContentSize())
    outerClipper:setPosition(cc.p(150, cc.Director:getInstance():getOpenGLView():getVisibleSize().height - 150))
    outerClipper:addChild(self.m_BulletBackground)
    outerClipper:setStencil(self.m_BulletBackground)
    self:addChild(outerClipper)

    self.m_BulletinText = ccui.Text:create("", DEFAULTFONT, 24)
    self.m_BulletinText:setTextHorizontalAlignment(cc.TEXT_ALIGNMENT_LEFT)
    self.m_BulletinText:setAnchorPoint(cc.p(0, 0.5))
    self.m_BulletinText:setPosition(cc.p(self.m_BulletBackground:getContentSize().width, self.m_BulletBackground:getContentSize().height * 0.5))
    outerClipper:addChild(self.m_BulletinText)

    self.labasp = cc.Sprite:createWithSpriteFrameName("notice.png")
    self.labasp:setAnchorPoint(cc.p(0, 0.5))
    self.labasp:setPosition(cc.p(120, cc.Director:getInstance():getOpenGLView():getVisibleSize().height - 135))
    self:addChild(self.labasp)
    self.labasp:setOpacity(0)

    --刷新公告信息
    if not self.m_BulletinText:getActionByTag(1) or self.m_BulletinText:getActionByTag(1):isDone() then
        table.insert(self.m_SystemText, str)
        self:updateBulletin()
    end
end

function BulletinUI:onEnter()
    MessageHandle.addHandle(Enum.NOTICE_CLIENT, function(msg,data)
        table.insert(self.m_SystemText, GlobalData.Notice[1].title)
        --解析字符串
        if not self.m_BulletinText:getActionByTag(1) or self.m_BulletinText:getActionByTag(1):isDone() then
            self:updateBulletin()
        end
    end,self)
end

function BulletinUI:addBulletinStr(notice)
     table.insert(self.m_SystemText, notice)
     print("asdasdasdasd:"..notice)
     if not self.m_BulletinText:getActionByTag(1) or self.m_BulletinText:getActionByTag(1):isDone() then
            self:updateBulletin()
     end
end

function BulletinUI:onExit()
    MessageHandle.removeHandle(self)
end

function BulletinUI:updateBulletin()
    --print("asdasdasdasd去委屈委屈位请:"..#self.m_SystemText)
    if #self.m_SystemText > 0 then
        self.m_BulletBackground:runAction(cc.FadeTo:create(1, 100))
        self.labasp:runAction(cc.FadeTo:create(1, 255))
        self.m_BulletinText:setString(self.m_SystemText[1])

        local action = transition.sequence({
            cc.MoveTo:create((self.m_BulletBackground:getContentSize().width + self.m_BulletinText:getContentSize().width) / 70.0,
                 cc.p(0 - self.m_BulletinText:getContentSize().width, self.m_BulletinText:getPositionY())),
            cc.MoveTo:create(0, cc.p(self.m_BulletBackground:getContentSize().width, self.m_BulletinText:getPositionY())),
            cc.CallFunc:create(function()
                self:updateBulletin()
            end)
        })
        action:setTag(1)
        self.m_BulletinText:runAction(action)
        table.remove(self.m_SystemText, 1)
        --print("asdasdasdasd去委屈委屈位请:"..#self.m_SystemText)
    else
        self.m_BulletinText:setString("")
        self.m_BulletBackground:runAction(cc.FadeTo:create(1, 0))
        self.labasp:runAction(cc.FadeTo:create(1, 0))
    end
end

function BulletinUI:reset()
    self.m_BulletinText:setString("")
    self.m_BulletinText:stopAllActions()
    self.m_BulletinText:setPosition(cc.p(self.m_BulletBackground:getContentSize().width, self.m_BulletinText:getPositionY()))
    self.m_BulletBackground:setOpacity(0)
    self.labasp:setOpacity(0)
end

function BulletinUI.getInstance()
    if not BulletinUI.m_Instance then
        BulletinUI.m_Instance = BulletinUI.new()
        BulletinUI.m_Instance:retain()
    end
    return BulletinUI.m_Instance
end

return BulletinUI