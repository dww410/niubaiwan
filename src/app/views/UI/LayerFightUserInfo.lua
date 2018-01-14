--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--游戏中玩家互动界面
--create by CongQin
--Date: 17/06/19
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerFightUserInfo = class("LayerFightUserInfo", require("app.views.UI.PopUI"))
function LayerFightUserInfo:ctor(No)
    LayerFightUserInfo.super.ctor(self)
    self:BindNodes(self.WidgetNode,"Panel_1.Image_6",
    "Panel_1.Image_1",
    "Panel_1.Image_1.Button_stopvoice",
    "Panel_1.Image_3.SexTag",
    "Panel_1.Image_3.NameText",
    "Panel_1.Image_3.AreaText",
    "Panel_1.Image_3.PlayTime",
    "Panel_1.Image_3.IDText",
    "Panel_1.Image_3.IPText",
    "Panel_1.Image_3.RegisterTime",
    "Panel_1.Image_3.Star_0",
    "Panel_1.Image_3.Star_1",
    "Panel_1.Image_3.Star_2",
    "Panel_1.Image_3.Star_3",
    "Panel_1.Image_3.Star_4",
    "Panel_1.Image_3.Button_Close",
    "Panel_1.Image_3.HeadBg.Headimgae",
    "Panel_1.Image_6.ScrollView",
    "Panel_1.Image_6.ScrollView.Button_hd1","Panel_1.Image_6.ScrollView.Button_hd2","Panel_1.Image_6.ScrollView.Button_hd3","Panel_1.Image_6.ScrollView.Button_hd4"
    )
    self.seatNo=No
    self:initEvent()
    for i = 1, #FightManager.roomdata.seats do
        if self.seatNo == FightManager.roomdata.seats[i].seatNo then
           self:initLayer(FightManager.roomdata.seats[i])
           break
        end
    end
    

end

function LayerFightUserInfo:initLayer(roleData)
    if roleData.name then
        local name= roleData.name
        if Tool.SubStringGetTotalIndex(name)>4 then
            name=Tool.SubStringUTF8(name, 0, 4)..".."
        end
        self.NameText:setString(name)
    end
    
    self.IDText:setString("游戏ID "..roleData.userName)

    self.IPText:setString("登录IP "..roleData.lastLoginIP)

    self.AreaText:setString(roleData.area)
    self.RegisterTime:setString(roleData.createDate)
    self.PlayTime:setString("游戏总局数 "..roleData.totalGames)

--    for i = 1, 5 do
--        self["Star_"..i-1]:setVisible(false)
--    end

   UIHelper.loadImgUrl(self.Headimgae,roleData.headPic,roleData.userName)
   if roleData.sex == "男" then
        self.SexTag:loadTexture("male.png",ccui.TextureResType.plistType)
    elseif roleData.sex == "女" then
        self.SexTag:loadTexture("famale.png",ccui.TextureResType.plistType)
    end
    self.SexTag:ignoreContentAdaptWithSize(true)

    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)
end

function LayerFightUserInfo:initEvent()
    UIHelper.BindClickByButtons({self.Button_Close,self.Button_stopvoice}, function(sender, event)
        if sender == self.Button_Close then
            self:Close()
        elseif sender == self.Button_stopvoice then

        end
    end )

    UIHelper.BindClickByButtons({self.Button_hd1,self.Button_hd2,self.Button_hd3,self.Button_hd4}, function(sender, event)
        if FightManager.roomdata.roomNo~=nil  then
            for i=1,#FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo==self.seatNo and FightManager.roomdata.seats[i].userName==PlayerManager.Player.userName then
                    return
                end
            end
        end

        local smsg = game_pb.InteractionRequest()
        smsg.otherSeatNo=self.seatNo
        if sender == self.Button_hd1 then
            smsg.content=1
        elseif sender == self.Button_hd2 then
            smsg.content=2
        elseif sender == self.Button_hd3 then
            smsg.content=3
        elseif sender == self.Button_hd4 then
            smsg.content=4
        end
        local msgData = smsg:SerializeToString()
        MSG.send(Enum.INTERACTION_SERVER,msgData,FightManager.GameRoomtype+1)
        self:Close()
    end )

end
function LayerFightUserInfo:getWidget()
    return "PopUIs/LayerFightUserInfo.csb"
end
function LayerFightUserInfo:onEnter()
    self.super.onEnter(self)
end

function LayerFightUserInfo:onExit()
    self.super.onExit(self)
end

return LayerFightUserInfo

--endregion
