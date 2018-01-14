--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 提示语表情
--create by CongQin
--Date: 17/06/20
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerFightBQ = class("LayerFightBQ", require("app.views.UI.PopUI"))

function LayerFightBQ:ctor()
    LayerFightBQ.super.ctor(self)
     self:BindNodes(self.WidgetNode,"Panel_BQ","Panel_BQ.Button_KJY","Panel_BQ.Button_BQ","Panel_BQ.ScrollView1","Panel_BQ.ScrollView2",
     "Panel_BQ.Button_KJY.Text_KJY","Panel_BQ.Button_BQ.Text_BQ",
     "Panel_BQ.ScrollView1.Button_bq_1","Panel_BQ.ScrollView1.Button_bq_2","Panel_BQ.ScrollView1.Button_bq_3",
     "Panel_BQ.ScrollView1.Button_bq_4","Panel_BQ.ScrollView1.Button_bq_5","Panel_BQ.ScrollView1.Button_bq_6",
     "Panel_BQ.ScrollView1.Button_bq_7","Panel_BQ.ScrollView1.Button_bq_8","Panel_BQ.ScrollView1.Button_bq_9",
     "Panel_BQ.ScrollView1.Button_bq_10","Panel_BQ.ScrollView1.Button_bq_11","Panel_BQ.ScrollView1.Button_bq_12",
     "Panel_BQ.ScrollView1.Button_bq_13","Panel_BQ.ScrollView1.Button_bq_14","Panel_BQ.ScrollView1.Button_bq_15",

     "Panel_BQ.ScrollView2.Button_tsy_1","Panel_BQ.ScrollView2.Button_tsy_2","Panel_BQ.ScrollView2.Button_tsy_3",
     "Panel_BQ.ScrollView2.Button_tsy_4","Panel_BQ.ScrollView2.Button_tsy_5","Panel_BQ.ScrollView2.Button_tsy_6",
     "Panel_BQ.ScrollView2.Button_tsy_7","Panel_BQ.ScrollView2.Button_tsy_8","Panel_BQ.ScrollView2.Button_tsy_9",
     "Panel_BQ.ScrollView2.Button_tsy_10","Panel_BQ.ScrollView2.Button_tsy_11","Panel_BQ.ScrollView2.Button_tsy_12",
     "Panel_BQ.ScrollView2.Button_tsy_13"
    )

    self.Updated=0
    self:initEvent()
    self.WidgetNode:setPositionX(965)
    self:removeChildByName("BG")
    self.Button_KJY:loadTextureNormal("niuniubtn18.png",ccui.TextureResType.plistType)
    self.Button_KJY:loadTexturePressed("niuniubtn18.png",ccui.TextureResType.plistType)

    self.Button_BQ:loadTextureNormal("niuniubtn19.png",ccui.TextureResType.plistType)
    self.Button_BQ:loadTexturePressed("niuniubtn19.png",ccui.TextureResType.plistType)

    self.Text_KJY:enableOutline(cc.c4b(55,154,198,255),1)
    self.Text_BQ:enableOutline(cc.c4b(220,148,14,255),1)
    self.ScrollView1:setVisible(true)
    self.ScrollView2:setVisible(false)
end

function LayerFightBQ:initEvent()
    UIHelper.BindClickByButtons({self.Button_KJY,self.Button_BQ}, function(sender, event)
        if sender == self.Button_KJY then
            self.Updated=0
            self.Button_KJY:loadTextureNormal("niuniubtn17.png",ccui.TextureResType.plistType)
            self.Button_KJY:loadTexturePressed("niuniubtn17.png",ccui.TextureResType.plistType)

            self.Button_BQ:loadTextureNormal("niuniubtn20.png",ccui.TextureResType.plistType)
            self.Button_BQ:loadTexturePressed("niuniubtn20.png",ccui.TextureResType.plistType)

            self.Text_KJY:enableOutline(cc.c4b(220,148,14,255),1)
            self.Text_BQ:enableOutline(cc.c4b(55,154,198,255),1)
            self.ScrollView1:setVisible(false)
            self.ScrollView2:setVisible(true)
        elseif sender == self.Button_BQ then
            self.Button_KJY:loadTextureNormal("niuniubtn18.png",ccui.TextureResType.plistType)
            self.Button_KJY:loadTexturePressed("niuniubtn18.png",ccui.TextureResType.plistType)

            self.Button_BQ:loadTextureNormal("niuniubtn19.png",ccui.TextureResType.plistType)
            self.Button_BQ:loadTexturePressed("niuniubtn19.png",ccui.TextureResType.plistType)

            self.Text_KJY:enableOutline(cc.c4b(55,154,198,255),1)
            self.Text_BQ:enableOutline(cc.c4b(220,148,14,255),1)
            self.ScrollView1:setVisible(true)
            self.ScrollView2:setVisible(false)
        end
            
    end )

    UIHelper.BindClickByButtons({self.Button_bq_1,self.Button_bq_2,self.Button_bq_3,self.Button_bq_4,self.Button_bq_5,self.Button_bq_6,self.Button_bq_7,self.Button_bq_8,self.Button_bq_9,
    self.Button_bq_10,self.Button_bq_11,self.Button_bq_12,self.Button_bq_13,self.Button_bq_14,self.Button_bq_15}, function(sender, event)
        local smsg = game_pb.ImgTextRequest()
        smsg.img=true
        for i=1,15 do
            if sender==self["Button_bq_"..i] then
                smsg.content=i
            end
        end
        local msgData = smsg:SerializeToString()
        MSG.send(Enum.IMG_TEXT_SERVER,msgData,FightManager.GameRoomtype+1)
        self:Close()
    end )

    UIHelper.BindClickByButtons({self.Button_tsy_1,self.Button_tsy_2,self.Button_tsy_3,self.Button_tsy_4,self.Button_tsy_5,self.Button_tsy_6,self.Button_tsy_7,self.Button_tsy_8,self.Button_tsy_9,
    self.Button_tsy_10,self.Button_tsy_11,self.Button_tsy_12,self.Button_tsy_13}, function(sender, event)
        local smsg = game_pb.ImgTextRequest()
        smsg.img=false
        for i=1,13 do
            if sender==self["Button_tsy_"..i] then
                smsg.content=i
            end
        end
        local msgData = smsg:SerializeToString()
        MSG.send(Enum.IMG_TEXT_SERVER,msgData,FightManager.GameRoomtype+1)
        self:Close()
    end )
end

function LayerFightBQ:getWidget()
    return "PopUIs/LayerFightBQ.csb"
end
function LayerFightBQ:onEnter()
    self.super.onEnter(self)
end

function LayerFightBQ:onExit()
    self.super.onExit(self)
end

return LayerFightBQ

--endregion
