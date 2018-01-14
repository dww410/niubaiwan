--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GameFightSceneCP = class("GameFightSceneCP", require("app.views.UI.PopUI"))

function GameFightSceneCP:ctor(cards)
    GameFightSceneCP.super.ctor(self)
    self:BindNodes(self.WidgetNode,"Image_1","Image_2","Image_3","Image_4","Image_5","Button_Close"
    )
    self.cards={}
    self.cards=cards
    self:refresh()
    self:initEvent()
    self.Updated=false
end

function GameFightSceneCP:getWidget()
    return "Scenes/GameFightSceneCP.csb"
end

function GameFightSceneCP:refresh()
    self.CloseType = 0
    for i=1,5 do
        self["Image_"..i]:loadTexture("3_"..self.cards[i].cardColor .."_"..self.cards[i].value ..".png",ccui.TextureResType.plistType)
    end
end

function GameFightSceneCP:initEvent()
    local eventDispatcher = self:getEventDispatcher()
    self.touchPoint={}
    local function onTouchBegan(touch, event)
        local target=event:getCurrentTarget()
        local locationInNode ={} 
        locationInNode=target:convertToNodeSpace(touch:getLocation())
        local s ={}
        s=target:getContentSize()
        local rect = cc.rect(0, 0, s.width, s.height)
        
        if (cc.rectContainsPoint(rect,locationInNode)) then
            target:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,2.1)))
            self.touchPoint=cc.p(target:getPositionX()-touch:getLocation().x,target:getPositionY()-touch:getLocation().y)
            return true
        end
        return false
    end

    local function onTouchMoved(touch, event)
        local target=event:getCurrentTarget()

        target:setPosition(cc.p(self.touchPoint.x+touch:getLocation().x,self.touchPoint.y+touch:getLocation().y))
    end

    local function onTouchEnded(touch, event)
        local btn=event:getCurrentTarget()
        btn:runAction(cc.Sequence:create(cc.ScaleTo:create(0.1,2.0)))
        self:CheckMoveState()
    end

    local listener = cc.EventListenerTouchOneByOne:create()
    listener:setSwallowTouches(true)
    listener:registerScriptHandler(onTouchBegan,cc.Handler.EVENT_TOUCH_BEGAN )
    listener:registerScriptHandler(onTouchMoved,cc.Handler.EVENT_TOUCH_MOVED )
    listener:registerScriptHandler(onTouchEnded,cc.Handler.EVENT_TOUCH_ENDED )
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener:clone(), self["Image_1"])
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener:clone(), self["Image_2"])
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener:clone(), self["Image_3"])
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener:clone(), self["Image_4"])
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener:clone(), self["Image_5"])
    UIHelper.BindClickByButtons({self.Button_Close}, function(sender, event)
        if sender==self.Button_Close then
            self.Button_Close:setVisible(false)
            self:CloseAm()
        end
    end )
end

function GameFightSceneCP:CheckMoveState()
    local CanClose=true
    local pos={[1]=cc.p(542,220),[2]=cc.p(555,220),[3]=cc.p(568,220),[4]=cc.p(581,220),[5]=cc.p(594,220)}
    for i=1,5 do
        if math.floor( self["Image_"..i]:getPositionX() ) == pos[i].x and math.floor(self["Image_"..i]:getPositionY())== pos[i].y and i~=1 then
            CanClose=false
        end
    end

    if CanClose==true then
        self:CloseAm()
    end
end

function GameFightSceneCP:CloseAm()
    for i=1,5 do
        self["Image_"..i]:runAction(cc.Sequence:create(cc.MoveTo:create(0.5,cc.p(568,-200))))
    end

    self:runAction(cc.Sequence:create(cc.DelayTime:create(1),cc.CallFunc:create(function()
        self.Updated=true
        self:Close()
    end)))
    
end

function GameFightSceneCP:onEnter()
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

function GameFightSceneCP:onExit()
    MessageHandle.removeHandle(self)
    self.super.onExit(self)
end

return GameFightSceneCP
