--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerNotice = class("LayerNotice", require("app.views.UI.PopUI"))
function LayerNotice:ctor()
    LayerNotice.super.ctor(self)
    self:BindNodes(self.WidgetNode,"common_popBg.Image_1","common_popBg.Image_1.noticeLabel","common_popBg.btnSure","common_popBg.Image_1.PageViewBg")

    self.noticeLabel:setVisible(false)
    self:buttonEvent()
    self:addData()
end
function LayerNotice:buttonEvent()
    UIHelper.BindClickByButtons({self.btnSure}, function(sender, event)
       if sender==self.btnSure then
            self:Close()
--            if not PlayerManager.Player.alipayNo and not PlayerManager.Player.phoneNo then
--                require("app.views.UI.LayerTips").new("亲爱的玩家,您好.为了您的账号安全请尽快绑定您的账号！"):Show():SetCloseCallBack(function(isupdata)
--                    if isupdata==true then
--                        require("app.views.UI.LayerUserInfo").new():Show()
--                    end
--                end)
--            end
       end
    end )

end
function LayerNotice:addData()
    local data = GlobalData.Notice
    --for i=1,5 do
    for i=1,#data do
        local layout = ccui.ScrollView:create()
        layout:setBounceEnabled(true)
        layout:setDirection(ccui.ScrollViewDir.vertical)
        layout:setScrollBarEnabled(false)
        layout:setTouchEnabled(true)
        layout:setContentSize(self.noticeLabel:getContentSize())
        layout:setPosition(self.noticeLabel:getPosition())
        local size= self.noticeLabel:getContentSize()
        local label = cc.Label:createWithTTF("",DEFAULTFONT,26)
        label:setWidth(size.width)
        label:setAlignment(cc.TEXT_ALIGNMENT_LEFT)
        local pageInfo = data[i].content
        label:setString(pageInfo)
        label:setLineBreakWithoutSpace(true)
        label:setTextColor(self.noticeLabel:getTextColor())
        label:setAnchorPoint(cc.p(0.5,0.5))
        label:setPosition(self.noticeLabel:getPosition())
        label:setPositionY(layout:getPositionY()-15)
        layout:addChild(label)
        local heiNum = label:getContentSize().height*1
        local num = self.noticeLabel:getContentSize().height
        if label:getContentSize().height > self.noticeLabel:getContentSize().height then
            layout:setContentSize(cc.size(self.noticeLabel:getContentSize().width,heiNum))
            label:setPositionY(layout:getPositionY()+label:getContentSize().height/2-self.noticeLabel:getContentSize().height/2)
        else
            label:setHeight(size.height)
        end
        self.PageViewBg:addPage(layout)
    end
end
function LayerNotice:getWidget()
    return "PopUIs/LayerNotice.csb"
end
function LayerNotice:onEnter()
    self.super.onEnter(self)
end

function LayerNotice:onExit()
    self.PageViewBg:removeAllChildren()
    self.super.onExit(self)
end
return LayerNotice
--endregion
