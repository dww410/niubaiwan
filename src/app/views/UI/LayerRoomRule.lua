--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 房间规则
--create by CongQin
--Date: 17/06/03

local LayerRoomRule = class("LayerRoomRule", require("app.views.UI.PopUI"))

function LayerRoomRule:ctor(data1,data2,data3,data4,data5)
    LayerRoomRule.super.ctor(self)
     self:BindNodes(self.WidgetNode,"Panel_1",
    "Panel_1.BG.Text_1","Panel_1.BG.Text_2","Panel_1.BG.Text_3","Panel_1.BG.Text_4","Panel_1.BG.Text_5",
    "Panel_1.Button_Close")

    self.Text_1:setString(data1)
    self.Text_2:setString(data2)
    self.Text_3:setString(data3)
    self.Text_4:setString(data4)
    self.Text_5:setString(data5)

    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)
end

function LayerRoomRule:getWidget()
    return "PopUIs/LayerRoomRule.csb"
end
function LayerRoomRule:onEnter()
    self.super.onEnter(self)
end

function LayerRoomRule:onExit()
    self.super.onExit(self)
end

return LayerRoomRule

--endregion
