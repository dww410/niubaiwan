--region *.lua
--Date
--此文件由[BabeLua]插件自动生成


--牛牛结算界面
-- User: CongQin
-- Date: 17/06/12
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerGameEnd = class("LayerGameEnd", require("app.views.UI.PopUI"))
function LayerGameEnd:ctor()
    LayerGameEnd.super.ctor(self)
    self:BindNodes(self.WidgetNode, "Button_1", "Button_2")
    self:refresh()
    self:initEvent()
    self.CloseType = 0
    self.overData = {}
    self.roomNum = 0
end

function LayerGameEnd:getWidget()
    return "PopUIs/LayerGameEnd.csb"
end

function LayerGameEnd:refresh()
end

function LayerGameEnd:setData(data, roomNum, totalRound, baseScore, gameType)
    self.overData = data
    self.roomNum = roomNum
    self.totalRound = totalRound
    self.baseScore = baseScore
    self.gameType = gameType
end

function LayerGameEnd:initEvent()
    UIHelper.BindClickByButtons({ self.Button_1, self.Button_2 }, function(sender, event)
        if sender == self.Button_1 then
            require("app.views.UI.LayerResult").new():Show():setData(self.overData, self.roomNum, self.totalRound, self.baseScore, self.gameType)
        elseif sender == self.Button_2 then
            local pScene = require("app.views.Scenes.MainScene.MainScene"):new()
            cc.Director:getInstance():replaceScene(pScene)
        end
    end)
end

function LayerGameEnd:onEnter()
    self.super.onEnter(self)
end

function LayerGameEnd:onExit()
    self.super.onExit(self)
    self.overData = {}
end

return LayerGameEnd
--endregion
