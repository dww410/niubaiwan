--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GameFightSceneCP2 = class("GameFightSceneCP2", require("app.views.UI.PopUI"))

function GameFightSceneCP2:ctor(cards)
    GameFightSceneCP2.super.ctor(self)
    self:BindNodes(self.WidgetNode,"Image_1","Button_Close"
    )

    self.carda=cards[1]
    self.cardb=cards[2]
    self.cardc=cards[3]
    self.cardd=cards[4]

    self.cards=cards[5]
    self:refresh()
    
    self.Updated=false
    
    self.s ={}
    self.s=cc.Director:getInstance():getWinSize()

    self.clipper = cc.ClippingNode:create()
	self.clipper:setContentSize(cc.size(410, 560))
	self.clipper:setAnchorPoint(cc.p(0.5, 0.5))
	self.clipper:setPosition(self.s.width/2 , self.s.height/2)
    self.clipper:setRotation(-90)
	self:addChild(self.clipper)

    self.stencil =cc.DrawNode:create()
    local rectangle={}
	rectangle[1] = cc.p(0, 0)
	rectangle[2] = cc.p(self.clipper:getContentSize().width, 0)
	rectangle[3] = cc.p(self.clipper:getContentSize().width, self.clipper:getContentSize().height)
	rectangle[4] = cc.p(0, self.clipper:getContentSize().height)

    local white=cc.c4b(1, 1, 1, 1)
	self.stencil:drawPolygon(rectangle, 4, white, 1, white)

	self.clipper:setStencil(self.stencil)

    self.back =cc.Sprite:createWithSpriteFrameName("3_fengmian.png")
	self.back:setAnchorPoint(cc.p(0.5, 0.5))
	self.back:setPosition(self.clipper:getContentSize().width/2, self.clipper:getContentSize().height/2)
	self.clipper:addChild(self.back)

	self.front = cc.Sprite:createWithSpriteFrameName("2_"..self.cards.cardColor .."_"..self.cards.value ..".png")
	self.front:setAnchorPoint(cc.p(0.5, 0.5))
	self.front:setPosition(-self.front:getContentSize().width/2, self.clipper:getContentSize().height/2)
	self.clipper:addChild(self.front)

    self.frontzhedang1=cc.LayerColor:create(cc.c4b(255, 255, 255, 255), 70, 182)
    self.frontzhedang1:setAnchorPoint(cc.p(0.5, 0.5))
    self.frontzhedang1:ignoreAnchorPointForPosition(false)
    self.front:addChild(self.frontzhedang1)
    self.frontzhedang1:setPosition(50, 445)

    self.frontzhedang2=cc.LayerColor:create(cc.c4b(255, 255, 255, 255), 70, 182)
    self.frontzhedang2:setAnchorPoint(cc.p(0.5, 0.5))
    self.frontzhedang2:ignoreAnchorPointForPosition(false)
    self.front:addChild(self.frontzhedang2 )
    self.frontzhedang2:setPosition(360, 115)

--	self.mask = cc.Sprite:createWithSpriteFrameName("alpha_mask.png")
--	self.mask:setAnchorPoint(cc.p(1, 0.5))
--	self.mask:setPosition(-self.mask:getContentSize().width/2 + 190, self.clipper:getContentSize().height/2)
--	self.clipper:addChild(self.mask)

    self.clipper:setVisible(false)
    self.Image_1:runAction(cc.Sequence:create(cc.DelayTime:create(0), cc.CallFunc:create(function()
        self.Image_1:setVisible(false)
        self.clipper:setVisible(true)
    end)))

    self._scrolling=false
    self._lastPoint={}
    self:initEvent()
end

function GameFightSceneCP2:getWidget()
    return "Scenes/GameFightSceneCP2.csb"
end

function GameFightSceneCP2:refresh()
    self.CloseType = 0

end

function GameFightSceneCP2:initEvent()



    local eventDispatcher = self:getEventDispatcher()

    local listener = cc.EventListenerTouchOneByOne:create()

    local function onTouchBegan(touch, event)

        if self.clipper:isVisible()==false then
            return
        end

        local point = self.clipper:convertToNodeSpace(cc.Director:getInstance():convertToGL(touch:getLocationInView()))

	    local rect = cc.rect(-190, -100, self.clipper:getContentSize().width+100, self.clipper:getContentSize().height+190)

	    self._scrolling = cc.rectContainsPoint(rect,point)

	    self._lastPoint = point

        if self._scrolling then
            return true
        end

        return false

    end




    local function onTouchMoved(touch, event)

	    local point ={}
        point = self.clipper:convertToNodeSpace(cc.Director:getInstance():convertToGL(touch:getLocationInView()))
	    local diff =cc.p(point.x - self._lastPoint.x,point.y - self._lastPoint.y)

	    local startfrontposx = -self.front:getContentSize().width/2
	    local endfrontposx = -self.front:getContentSize().width/2  + self.clipper:getContentSize().width

	    if self.front:getPositionX() + diff.x < startfrontposx or self.front:getPositionX() + diff.x > endfrontposx then

	    else
		    self.front:setPositionX(self.front:getPositionX() + diff.x)
		    self.stencil:setPositionX(self.stencil:getPositionX() + diff.x / 2)
--		    self.mask:setPositionX(self.mask:getPositionX()  + diff.x)
	    end

	    self._lastPoint = point
    end

    local function onTouchEnded(touch, event)
        if self._scrolling==false then
            return
        end
	    self._scrolling = false

        if self.front:getPositionX() > self.clipper:getContentSize().width/2 - 300 then
            self.front:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(self.clipper:getContentSize().width/2, self.clipper:getContentSize().height/2))))
	        self.back:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(-self.back:getContentSize().width/2, self.clipper:getContentSize().height/2))))
	        self.stencil:runAction(cc.Sequence:create(cc.MoveTo:create(0.3,cc.p(0,0))))
--	        self.mask:runAction(cc.Sequence:create(cc.FadeOut:create(1)))
--          self.mask:runAction(cc.Sequence:create(cc.MoveTo:create(1,cc.p(410,self.mask:getPositionY()))))
            self.frontzhedang2:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.FadeOut:create(0.5)))
            self.frontzhedang1:runAction(cc.Sequence:create(cc.DelayTime:create(0),cc.FadeOut:create(0.5)))
	        self.clipper:runAction(cc.Sequence:create(cc.ScaleTo:create(0.5,1.1), cc.ScaleTo:create(0.5, 1),cc.DelayTime:create(0.1),cc.CallFunc:create(function()
                self.Button_Close:setVisible(false)
                self:CloseAm()
            end)))

            eventDispatcher:removeEventListener(listener)
        else
            self.front:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, cc.p(-self.front:getContentSize().width/2, self.clipper:getContentSize().height/2))))
	        self.stencil:runAction(cc.Sequence:create(cc.MoveTo:create(0.3, ccp(0, 0))))
--            self.mask:runAction(cc.Sequence:create(cc.MoveTo:create(0.3,cc.p(-self.mask:getContentSize().width/2 + 190,self.mask:getPositionY()))))
        end
	    
    end

    
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )

    eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self.clipper)

    UIHelper.BindClickByButtons({self.Button_Close}, function(sender, event)
        if sender==self.Button_Close then
            self.Button_Close:setVisible(false)
            self:CloseAm()

        end
    end )
end

function GameFightSceneCP2:CloseAm()
    self.Updated=true
    self:Close()
end

function GameFightSceneCP2:onEnter()
    self.super.onEnter(self)

    --收到亮牌游戏消息
    MessageHandle.addHandle(Enum.OPEN_CARD_CLIENT, function(msgid,data)
        if FightManager.roomdata.roomNo==nil then
            return
        end
        local cmsg = game_pb.OpenCardResponse()
        cmsg:ParseFromString(data)

        --自动亮牌 需要关闭该界面
        for i=1,#FightManager.roomdata.seats do 
            if FightManager.roomdata.seats[i].userName==PlayerManager.Player.userName and FightManager.roomdata.seats[i].seatNo==cmsg.seatNo then
                self.Updated=false
                self:Close()
                break
            end
        end

    end,self)
end

function GameFightSceneCP2:onExit()
    MessageHandle.removeHandle(self)
    self.super.onExit(self)
end

return GameFightSceneCP2

--endregion
