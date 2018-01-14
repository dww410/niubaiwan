--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local MessageTip=class("MessageTip",function()
    local layout=cc.CSLoader:createNode('Animation/Am_tip.csb')
    return layout
end)


function MessageTip:ctor()
    self:BindNodes(self,"content")
    self.AnimateTimeLine = cc.CSLoader:createTimeline('Animation/Am_tip.csb')
end

function MessageTip:play()
    self.AnimateTimeLine:play("TipAnimate",false)
end

function MessageTip.Show(content,pos)
    if type(content)~='string' then
        print("MessageTip.Show is args error")
        return
    end
    local msgUI=MessageTip.new()
    msgUI.content:setString(content)
    local pos=pos or cc.p(display.width/2,display.height/2)
    msgUI:setPosition(pos)
    msgUI:runAction(msgUI.AnimateTimeLine)
    msgUI:runAction(cc.Sequence:create(cc.DelayTime:create(2),cc.FadeOut:create(1),cc.CallFunc:create(function() 
                        msgUI:removeMessageTip()
    end)))
    msgUI:setTag(1000)
    msgUI:play()
    msgUI:addMessageTip()
end


function MessageTip:addMessageTip()
    local scene=display.getRunningScene()
    self:removeMessageTip(scene)
    scene:addChild(self,1000,1000)
    
end

function MessageTip:removeMessageTip()
    local scene=display.getRunningScene()
    if scene:getChildByTag(1000) ~=nil then
        scene:removeChildByTag(1000)
    end
end


return MessageTip

--endregion
