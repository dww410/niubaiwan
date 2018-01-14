--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--玩家信息
--create by niyinguo
--Date: 17/06/02
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerUserInfo = class("LayerUserInfo", require("app.views.UI.PopUI"))
function LayerUserInfo:ctor()
    LayerUserInfo.super.ctor(self)
     self.super.CloseType = 3
    self:BindNodes(self.WidgetNode,"Panel_1",
    "Panel_1.Image_3.HeadBg.Headimgae",
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
    "Panel_1.Image_3.Button_Close")

    if PlayerManager.Player.name then
        local name= PlayerManager.Player.name
        if Tool.SubStringGetTotalIndex(name)>4 then
            name=Tool.SubStringUTF8(name, 0, 4)..".."
        end
        self.NameText:setString(name)
    end

    if PlayerManager.Player.userName then
        self.IDText:setString("游戏ID "..PlayerManager.Player.userName)
    end

    self.IPText:setString("登录IP "..PlayerManager.Player.lastLoginIP)

    self.AreaText:setString(PlayerManager.Player.area)
    self.RegisterTime:setString(PlayerManager.Player.createDate)
    self.PlayTime:setString("游戏总局数 "..PlayerManager.Player.totalGames)

--    for i = 1, 5 do
--        self["Star_"..i-1]:setVisible(false)
--    end



   UIHelper.loadImgUrl(self.Headimgae,PlayerManager.Player.head,PlayerManager.Player.userName)
   if PlayerManager.Player.sex == "男" then
        self.SexTag:loadTexture("male.png",ccui.TextureResType.plistType)
    elseif PlayerManager.Player.sex == "女" then
        self.SexTag:loadTexture("famale.png",ccui.TextureResType.plistType)
    end
    self.SexTag:ignoreContentAdaptWithSize(true)

    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)
end

function LayerUserInfo:getWidget()
    return "PopUIs/LayerUserInfo.csb"
end
function LayerUserInfo:onEnter()
    self.super.onEnter(self)
end

function LayerUserInfo:onExit()
    self.super.onExit(self)
end
return LayerUserInfo
--endregion
