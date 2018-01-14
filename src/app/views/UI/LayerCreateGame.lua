--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--创建房间
--create by niyinguo
--Date: 17/06/02
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerCreateGame = class("LayerCreateGame", require("app.views.UI.PopUI"))

function LayerCreateGame:ctor()
    LayerCreateGame.super.ctor(self)
    self:BindNodes(self.WidgetNode, "Node",
        "Node.Panel_1",
        "Node.Panel_2",
        "Node.Panel_2.Button_0",
        "Node.Panel_2.Button_1",
        "Node.Panel_2.Button_2",
        "Node.Panel_2.Button_3",
        "Node.Panel_2.Button_4",
        "Node.Panel_2.Button_Close",
        "Node.Panel_2.Button_Create",
        "Node.Panel_2.Button_0.Text_1",
        "Node.Panel_2.Button_gjhelp",
        "Node.Panel_2.Button_payhelp",
        "Node.Panel_2.Image_Advance",
        "Node.Panel_2.Image_Pay",
        "Node.Panel_3",
        "Node.Panel_3.PointSet",
        "Node.Panel_3.FightTimeSet",
        "Node.Panel_3.NeedDimondSet",
        "Node.Panel_3.NormalRuleSet",
        "Node.Panel_3.SpaceilRuleSet",
        "Node.Panel_3.AdvanceSet",
        "Node.Panel_3.UpBankerPointSet",
        "Node.Panel_3.UpBankerMultSet",
        --底分
        "Node.Panel_3.PointSet.PointCheck_0",
        "Node.Panel_3.PointSet.PointCheck_0.PointCheckText0",
        "Node.Panel_3.PointSet.PointCheck_1",
        "Node.Panel_3.PointSet.PointCheck_1.PointCheckText1",
        "Node.Panel_3.PointSet.PointCheck_2",
        "Node.Panel_3.PointSet.PointCheck_2.PointCheckText2",
        "Node.Panel_3.PointSet.PointCheck_3",
        "Node.Panel_3.PointSet.PointCheck_3.PointCheckText3",
        --局数
        "Node.Panel_3.FightTimeSet.TimeCheck_0",
        "Node.Panel_3.FightTimeSet.TimeCheck_0.TimeCheckText0",
        "Node.Panel_3.FightTimeSet.TimeCheck_1",
        "Node.Panel_3.FightTimeSet.TimeCheck_1.TimeCheckText1",
        "Node.Panel_3.FightTimeSet.TimeCheck_2",
        "Node.Panel_3.FightTimeSet.TimeCheck_2.TimeCheckText2",
        --开房花费
        "Node.Panel_3.NeedDimondSet.DimondCheck_0",
        "Node.Panel_3.NeedDimondSet.DimondCheck_0.DimondCheckText0",
        "Node.Panel_3.NeedDimondSet.DimondCheck_1",
        "Node.Panel_3.NeedDimondSet.DimondCheck_1.DimondCheckText1",
        --特殊牌型倍数
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_0",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_0.SpaceilRuleCheckText0",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_1",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_1.SpaceilRuleCheckText1",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_2",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_2.SpaceilRuleCheckText2",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_3",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_3.SpaceilRuleCheckText3",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_4",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_4.SpaceilRuleCheckText4",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_5",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_5.SpaceilRuleCheckText5",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_6",
        "Node.Panel_3.SpaceilRuleSet.SpaceilRuleCheck_6.SpaceilRuleCheckText6",
        --高级设置
        "Node.Panel_3.AdvanceSet.AdvanceCheck_0",
        "Node.Panel_3.AdvanceSet.AdvanceCheck_0.AdvanceCheckText0",
        "Node.Panel_3.AdvanceSet.AdvanceCheck_1",
        "Node.Panel_3.AdvanceSet.AdvanceCheck_1.AdvanceCheckText1",
        "Node.Panel_3.AdvanceSet.AdvanceCheck_2",
        "Node.Panel_3.AdvanceSet.AdvanceCheck_2.AdvanceCheckText2",
        --上庄分数
        "Node.Panel_3.UpBankerPointSet.BankerPointPointCheck_0",
        "Node.Panel_3.UpBankerPointSet.BankerPointPointCheck_0.BankerPointCheckText0",
        "Node.Panel_3.UpBankerPointSet.BankerPointPointCheck_1",
        "Node.Panel_3.UpBankerPointSet.BankerPointPointCheck_1.BankerPointCheckText1",
        "Node.Panel_3.UpBankerPointSet.BankerPointPointCheck_2",
        "Node.Panel_3.UpBankerPointSet.BankerPointPointCheck_2.BankerPointCheckText2",
        "Node.Panel_3.UpBankerPointSet.BankerPointPointCheck_3",
        "Node.Panel_3.UpBankerPointSet.BankerPointPointCheck_3.BankerPointCheckText3",
        --最大抢庄
        "Node.Panel_3.UpBankerMultSet.BankerMultPointCheck_0",
        "Node.Panel_3.UpBankerMultSet.BankerMultPointCheck_0.BankerMultCheckText0",
        "Node.Panel_3.UpBankerMultSet.BankerMultPointCheck_1",
        "Node.Panel_3.UpBankerMultSet.BankerMultPointCheck_1.BankerMultCheckText1",
        "Node.Panel_3.UpBankerMultSet.BankerMultPointCheck_2",
        "Node.Panel_3.UpBankerMultSet.BankerMultPointCheck_2.BankerMultCheckText2",
        "Node.Panel_3.UpBankerMultSet.BankerMultPointCheck_3",
        "Node.Panel_3.UpBankerMultSet.BankerMultPointCheck_3.BankerMultCheckText3",
        --翻倍规则
        "Node.Panel_3.NormalRuleSet.Image_4.ruleSelect",
        "Node.Panel_3.NormalRuleSet.Image_4.Text_4",
        "Node.Panel_3.NormalRuleSet.Image_4.Image_11",
        "Node.Panel_3.NormalRuleSet.RuleSelectPanel",
        "Node.Panel_3.NormalRuleSet.RuleSelectPanel.Button_BG",
        "Node.Panel_3.NormalRuleSet.RuleSelectPanel.RuleSelectCheck_0",
        "Node.Panel_3.NormalRuleSet.RuleSelectPanel.RuleSelectCheck_1",
        "Node.Panel_3.NormalRuleSet.RuleSelectPanel.RuleSelectCheck_0.Button_Click0",
        "Node.Panel_3.NormalRuleSet.RuleSelectPanel.RuleSelectCheck_1.Button_Click1")

    self.radioButtonGroup = {}
    self.radioButtonGroup = ccui.RadioButtonGroup:create()
    self.Panel_2:addChild(self.radioButtonGroup)
    GlobalData.GetRoomData()

    self.SpaceilRuleCheckText3:setString("对子牛(4倍)");
    self.SpaceilRuleCheckText2:setString("快乐牛(10倍)");

    if cc.UserDefault:getInstance():getStringForKey("SinLoginType", "a") == "b" then
        self.NeedDimondSet:setVisible(false)
    end



    local btnTitle = { "牛牛上庄", "固定庄家", "自由抢庄", "明牌抢庄", "通比牛牛" }
    local gameSetStr = { "PointSet", "FightTimeSet", "NeedDimondSet", "NormalRuleSet", "SpaceilRuleSet", "AdvanceSet", "UpBankerPointSet", "UpBankerMultSet" }

    for i = 1, 5 do
        local radioButton = ccui.RadioButton:create("button_gametype0.png", "button_gametype1.png", "button_gametype1.png", "button_gametype0.png", "button_gametype0.png", ccui.TextureResType.plistType)
        radioButton:setPosition(self["Button_" .. (i - 1)]:getPosition())
        radioButton:setPositionX(radioButton:getPositionX())
        self["Button_" .. (i - 1)]:setVisible(false)
        self.radioButtonGroup:addRadioButton(radioButton)

        local text = self.Text_1:clone()
        text:setString(btnTitle[i])
        radioButton:addChild(text)
        self.Panel_2:addChild(radioButton)
    end
    self.radioButtonGroup:setSelectedButton(0)
    self.radioButtonGroup:addEventListener(function(radiobtn, index, event)
        self:selectGameType(index)
        SoundHelper.playMusicSound(65, 0, false)
    end)

    self.RuleSelectPanel:setVisible(false)
    self.RuleSelectCheck_0:setSelected(true)
    self.RuleSelectCheck_1:setSelected(false)
    self.Text_4:setString(self.Button_Click0:getTitleText())
    self.roomData = {}
    self.initstate = false



    self:setRoomSetting()
    self:initEvent()

    self.Image_11:runAction(cc.Sequence:create(cc.RotateTo:create(0.1, 180)))
end

function LayerCreateGame:setRoomSetting()
    local data = GlobalData.CreateRoomSetData
    for i = 1, #data do
        if tonumber(cc.UserDefault:getInstance():getIntegerForKey("createRoomGameType", 4)) == i then
            local item = data[i]
            self.radioButtonGroup:getRadioButtonByIndex(i - 1):setEnabled(item.status)
            self.radioButtonGroup:getRadioButtonByIndex(i - 1):setBright(item.status)
            if self.initstate == false and item.status then
                self.initstate = true
                self.radioButtonGroup:setSelectedButton(i - 1)
                self:selectGameType(i - 1)
            end
        end
    end
end

function LayerCreateGame:resetVisible()
    for i = 1, 3 do
        self["PointCheck_" .. (i - 1)]:setVisible(false)
        self["TimeCheck_" .. (i - 1)]:setVisible(false)
        self["AdvanceCheck_" .. (i - 1)]:setVisible(false)
    end
    self.DimondCheck_0:setVisible(false)
    self.DimondCheck_1:setVisible(false)
    for j = 1, 4 do
        self["SpaceilRuleCheck_" .. (j - 1)]:setVisible(false)
        self["BankerMultPointCheck_" .. (j - 1)]:setVisible(false)
        self["BankerPointPointCheck_" .. (j - 1)]:setVisible(false)
    end
    self.Button_Create:setEnabled(false)
end

function LayerCreateGame:setSelectTypeSetting(gametype)
    self:resetVisible()
    local data = GlobalData.CreateRoomSetData
    for i = 1, #data do
        if gametype == data[i].gameType then
            for j = 1, #data[i].baseScore do
                if j <= 4 then
                    self["PointCheck_" .. (j - 1)]:setVisible(true)
                else
                    MessageTip.Show("游戏类型:" .. gametype .. " baseScore(底分) 数据超限")
                    print("游戏类型:" .. gametype .. " baseScore(底分) 数据超限")
                end
            end
            for j = 1, #data[i].totalRound do
                if j <= 3 then
                    self["TimeCheck_" .. (j - 1)]:setVisible(true)
                else
                    MessageTip.Show("游戏类型:" .. gametype .. " totalRound(局数) 数据超限")
                    print("游戏类型:" .. gametype .. " totalRound(局数) 数据超限")
                end
            end
            for j = 1, #data[i].payType do
                if j <= 2 then
                    self["DimondCheck_" .. (j - 1)]:setVisible(true)
                else
                    MessageTip.Show("游戏类型:" .. gametype .. " payType(支付方式) 数据超限")
                    print("游戏类型:" .. gametype .. " payType(支付方式) 数据超限")
                end
            end
            for j = 1, #data[i].getBankerScore do
                if j <= 4 then
                    self["BankerPointPointCheck_" .. (j - 1)]:setVisible(true)
                else
                    MessageTip.Show("游戏类型:" .. gametype .. " getBankerScore(上庄分数) 数据超限")
                    print("游戏类型:" .. gametype .. " getBankerScore(上庄分数) 数据超限")
                end
            end
            for j = 1, #data[i].maxGetBankerScore do
                if j <= 4 then
                    self["BankerMultPointCheck_" .. (j - 1)]:setVisible(true)
                else
                    MessageTip.Show("游戏类型:" .. gametype .. " maxGetBankerScore(上庄倍数) 数据超限")
                    print("游戏类型:" .. gametype .. " maxGetBankerScore(上庄倍数) 数据超限")
                end
            end
            self.SpaceilRuleCheck_0:setVisible(data[i].spottedBull)
            self.SpaceilRuleCheck_1:setVisible(data[i].bombBull)
            self.SpaceilRuleCheck_2:setVisible(data[i].smallBull)
            self.SpaceilRuleCheck_3:setVisible(data[i].doubleBull)
            self.SpaceilRuleCheck_4:setVisible(data[i].straightBull)
            self.SpaceilRuleCheck_5:setVisible(data[i].suitBull)
            self.SpaceilRuleCheck_6:setVisible(data[i].threetwoBull)
            self.AdvanceCheck_0:setVisible(data[i].playerPush)
            self.AdvanceCheck_1:setVisible(data[i].startedInto)
            self.AdvanceCheck_2:setVisible(data[i].disableTouchCard)
            self.Button_Create:setEnabled(data[i].status)
        end
    end
end

function LayerCreateGame:selectGameType(args)
    GlobalData.GetRoomData()

    self.roomData.gameType = args + 1
    self.roomData.baseScore = GlobalData.RecordRoomSetdata.baseScore --; //低分 1.2.3
    self.roomData.count = GlobalData.RecordRoomSetdata.count --; //局数10/20
    self.roomData.payType = GlobalData.RecordRoomSetdata.payType --; //支付方式1/2
    self.roomData.rule = GlobalData.RecordRoomSetdata.rule --; //规则1/2
    self.roomData.getBankerScore = GlobalData.RecordRoomSetdata.getBankerScore --; //上庄分数
    self.roomData.maxGetBankerScore = GlobalData.RecordRoomSetdata.maxGetBankerScore --; //最大抢庄
    self.roomData.doubleBull = GlobalData.RecordRoomSetdata.doubleBull --; //对子牛
    self.roomData.straightBull = GlobalData.RecordRoomSetdata.straightBull --; //顺子牛
    self.roomData.spottedBull = GlobalData.RecordRoomSetdata.spottedBull --; //五花牛
    self.roomData.suitBull = GlobalData.RecordRoomSetdata.suitBull --; //同花牛
    self.roomData.threetwoBull = GlobalData.RecordRoomSetdata.threetwoBull --; //
    self.roomData.bombBull = GlobalData.RecordRoomSetdata.bombBull --; //炸弹牛
    self.roomData.smallBull = GlobalData.RecordRoomSetdata.smallBull --; //五小牛
    self.roomData.playerPush = GlobalData.RecordRoomSetdata.playerPush --; //闲家推注
    self.roomData.startedInto = GlobalData.RecordRoomSetdata.startedInto --; //游戏开始后加入
    self.roomData.disableTouchCard = GlobalData.RecordRoomSetdata.disableTouchCard --; //禁止搓牌

    self:setSelectTypeSetting(self.roomData.gameType)
    cc.UserDefault:getInstance():setIntegerForKey("createRoomGameType", self.roomData.gameType)

    --//五花牛 //炸弹牛 //五小牛//对子牛
    if self.roomData.spottedBull == true then
        self.SpaceilRuleCheck_0:setSelected(true)
        self.SpaceilRuleCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.SpaceilRuleCheck_0:setSelected(false)
        self.SpaceilRuleCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    if self.roomData.bombBull == true then
        self.SpaceilRuleCheck_1:setSelected(true)
        self.SpaceilRuleCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.SpaceilRuleCheck_1:setSelected(false)
        self.SpaceilRuleCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    if self.roomData.smallBull == true then
        self.SpaceilRuleCheck_2:setSelected(true)
        self.SpaceilRuleCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.SpaceilRuleCheck_2:setSelected(false)
        self.SpaceilRuleCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    if self.roomData.doubleBull == true then
        self.SpaceilRuleCheck_3:setSelected(true)
        self.SpaceilRuleCheckText3:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.SpaceilRuleCheck_3:setSelected(false)
        self.SpaceilRuleCheckText3:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    if self.roomData.straightBull == true then
        self.SpaceilRuleCheck_4:setSelected(true)
        self.SpaceilRuleCheckText4:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.SpaceilRuleCheck_4:setSelected(false)
        self.SpaceilRuleCheckText4:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    if self.roomData.suitBull == true then
        self.SpaceilRuleCheck_5:setSelected(true)
        self.SpaceilRuleCheckText5:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.SpaceilRuleCheck_5:setSelected(false)
        self.SpaceilRuleCheckText5:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    if self.roomData.threetwoBull == true then
        self.SpaceilRuleCheck_6:setSelected(true)
        self.SpaceilRuleCheckText6:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.SpaceilRuleCheck_6:setSelected(false)
        self.SpaceilRuleCheckText6:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    --//闲家推注//游戏开始后加入//禁止搓牌
    if self.roomData.playerPush then
        self.AdvanceCheck_0:setSelected(true)
        self.AdvanceCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.AdvanceCheck_0:setSelected(false)
        self.AdvanceCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    if self.roomData.startedInto then
        self.AdvanceCheck_1:setSelected(true)
        self.AdvanceCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.AdvanceCheck_1:setSelected(false)
        self.AdvanceCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    if self.roomData.disableTouchCard then
        self.AdvanceCheck_2:setSelected(true)
        self.AdvanceCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
    else
        self.AdvanceCheck_2:setSelected(false)
        self.AdvanceCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
    end

    --规则1/2
    if self.roomData.rule == 1 then
        self.RuleSelectCheck_0:setSelected(true)
        self.RuleSelectCheck_1:setSelected(false)
    else
        self.RuleSelectCheck_0:setSelected(false)
        self.RuleSelectCheck_1:setSelected(true)
    end

    self.Text_4:setString(self["Button_Click" .. (self.roomData.rule - 1)]:getTitleText())

    --底分
    if self.roomData.baseScore == 1 then
        self.PointCheck_0:setSelected(true)
        self:pointCheckBoxFunc(self.PointCheck_0)
        self.PointCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
    elseif self.roomData.baseScore == 2 then
        self.PointCheck_1:setSelected(true)
        self:pointCheckBoxFunc(self.PointCheck_1)
        self.PointCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
    elseif self.roomData.baseScore == 4 then
        self.PointCheck_2:setSelected(true)
        self:pointCheckBoxFunc(self.PointCheck_2)
        self.PointCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
    elseif self.roomData.baseScore == 8 then
        self.PointCheck_3:setSelected(true)
        self:pointCheckBoxFunc(self.PointCheck_3)
        self.PointCheckText3:setTextColor(cc.c4b(255, 0, 0, 255))
    end


    --局数
    if self.roomData.count == 5 then
        self.TimeCheck_0:setSelected(true)
        self.TimeCheck_1:setSelected(false)
        self.TimeCheck_2:setSelected(false)
        self.TimeCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
        self.TimeCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
        self.TimeCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
        self.DimondCheckText0:setString("房主支付(   3)")
        self.DimondCheckText1:setString("AA支付(每人  1)")
    elseif self.roomData.count == 10 then
        self.TimeCheck_0:setSelected(false)
        self.TimeCheck_1:setSelected(true)
        self.TimeCheck_2:setSelected(false)
        self.TimeCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
        self.TimeCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
        self.TimeCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
        self.DimondCheckText0:setString("房主支付(   6)")
        self.DimondCheckText1:setString("AA支付(每人  2)")
    elseif self.roomData.count == 20 then
        self.TimeCheck_0:setSelected(false)
        self.TimeCheck_1:setSelected(false)
        self.TimeCheck_2:setSelected(true)
        self.TimeCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
        self.TimeCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
        self.TimeCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
        self.DimondCheckText0:setString("房主支付(   12)")
        self.DimondCheckText1:setString("AA支付(每人  4)")
    end

    --开房花费

    if self.roomData.payType == 1 then
        self.DimondCheck_0:setSelected(true)
        self.DimondCheck_1:setSelected(false)
        self.DimondCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
        self.DimondCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
    elseif self.roomData.payType == 2 then
        self.DimondCheck_0:setSelected(false)
        self.DimondCheck_1:setSelected(true)
        self.DimondCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
        self.DimondCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
    end


    --上庄分数
    if self.roomData.getBankerScore == 0 then
        self.BankerPointPointCheck_0:setSelected(true)
        self:pointUpBankerCheckBoxFunc(self.BankerPointPointCheck_0)
        self.BankerPointCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
    elseif self.roomData.getBankerScore == 400 then
        self.BankerPointPointCheck_1:setSelected(true)
        self:pointUpBankerCheckBoxFunc(self.BankerPointPointCheck_1)
        self.BankerPointCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
    elseif self.roomData.getBankerScore == 600 then
        self.BankerPointPointCheck_2:setSelected(true)
        self:pointUpBankerCheckBoxFunc(self.BankerPointPointCheck_2)
        self.BankerPointCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
    elseif self.roomData.getBankerScore == 800 then
        self.BankerPointPointCheck_3:setSelected(true)
        self:pointUpBankerCheckBoxFunc(self.BankerPointPointCheck_3)
        self.BankerPointCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
    end

    --最大抢庄
    if self.roomData.maxGetBankerScore == 1 then
        self.BankerMultPointCheck_0:setSelected(true)
        self:multUpBankerCheckBoxFunc(self.BankerMultPointCheck_0)
        self.BankerMultCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
    elseif self.roomData.maxGetBankerScore == 2 then
        self.BankerMultPointCheck_1:setSelected(true)
        self:multUpBankerCheckBoxFunc(self.BankerMultPointCheck_1)
        self.BankerMultCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
    elseif self.roomData.maxGetBankerScore == 3 then
        self.BankerMultPointCheck_2:setSelected(true)
        self:multUpBankerCheckBoxFunc(self.BankerMultPointCheck_2)
        self.BankerMultCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
    elseif self.roomData.maxGetBankerScore == 4 then
        self.BankerMultPointCheck_3:setSelected(true)
        self:multUpBankerCheckBoxFunc(self.BankerMultPointCheck_3)
        self.BankerMultCheckText3:setTextColor(cc.c4b(255, 0, 0, 255))
    end


    if args == 0 then
        self.UpBankerPointSet:setVisible(false)
        self.UpBankerMultSet:setVisible(false)
    elseif args == 1 then
        self.UpBankerPointSet:setVisible(true)
        self.UpBankerMultSet:setVisible(false)
    elseif args == 2 then
        self.UpBankerPointSet:setVisible(false)
        self.UpBankerMultSet:setVisible(false)
    elseif args == 3 then
        self.UpBankerPointSet:setVisible(false)
        self.UpBankerMultSet:setVisible(true)
    elseif args == 4 then
        self.UpBankerPointSet:setVisible(false)
        self.UpBankerMultSet:setVisible(false)
    end

    if args == 4 then
        self.PointCheckText0:setString("1")
        self.PointCheckText1:setString("2")
        self.PointCheckText2:setString("4")
        self.PointCheckText3:setString("8")
    else
        self.PointCheckText0:setString("1/2")
        self.PointCheckText1:setString("2/4")
        self.PointCheckText2:setString("4/8")
        self.PointCheckText3:setString("8/16")
    end
end

function LayerCreateGame:initEvent()
    UIHelper.BindClickByButtons({ self.Button_Close, self.Button_Create, self.ruleSelect, self.Button_BG, self.Button_Click0, self.Button_Click1, self.Button_gjhelp, self.Button_payhelp }, function(sender, event)
        if sender == self.Button_Close then
            self:Close()
        elseif sender == self.Button_Create then

            WaitProgress.Show()

            local smsg = hall_pb.GetRoomRequest()
            smsg.gameType = self.roomData.gameType --;//游戏类型1.2.3.4.5
            smsg.baseScore = self.roomData.baseScore --; //低分 1.2.3
            smsg.count = self.roomData.count --; //局数10/20
            smsg.payType = self.roomData.payType --; //支付方式1/2
            smsg.rule = self.roomData.rule --; //规则1/2
            smsg.getBankerScore = self.roomData.getBankerScore --; //上庄分数
            smsg.maxGetBankerScore = self.roomData.maxGetBankerScore --; //最大抢庄
            smsg.doubleBull = self.roomData.doubleBull --; //对子牛
            smsg.straightBull = self.roomData.straightBull --; //顺子牛
            smsg.spottedBull = self.roomData.spottedBull --; //五花牛
            smsg.suitBull = self.roomData.suitBull --; //同花牛
            smsg.threetwoBull = self.roomData.threetwoBull --; //
            smsg.bombBull = self.roomData.bombBull --; //炸弹牛
            smsg.smallBull = self.roomData.smallBull --; //五小牛
            smsg.playerPush = self.roomData.playerPush --; //闲家推注
            smsg.startedInto = self.roomData.startedInto --; //游戏开始后加入
            smsg.disableTouchCard = self.roomData.disableTouchCard --; //禁止搓牌
            local msgData = smsg:SerializeToString()
            MSG.send(Enum.GET_ROOM_SERVER, msgData, 1)

        elseif sender == self.ruleSelect then
            self.RuleSelectPanel:setVisible(true)
            self.Image_11:runAction(cc.Sequence:create(cc.RotateTo:create(0.1, 0)))

        elseif sender == self.Button_BG then
            self.RuleSelectPanel:setVisible(false)
            self.Image_11:runAction(cc.Sequence:create(cc.RotateTo:create(0.1, 180)))

        elseif sender == self.Button_Click0 then
            self.Text_4:setString(sender:getTitleText())
            self.RuleSelectCheck_0:setSelected(true)
            self.RuleSelectCheck_1:setSelected(false)
            self.roomData.rule = 1

        elseif sender == self.Button_Click1 then
            self.Text_4:setString(sender:getTitleText())
            self.RuleSelectCheck_0:setSelected(false)
            self.RuleSelectCheck_1:setSelected(true)
            self.roomData.rule = 2

        elseif sender == self.Button_gjhelp then
            self.Image_Advance:setVisible(true)

        elseif sender == self.Button_payhelp then
            self.Image_Pay:setVisible(true)
        end
    end)



    UIHelper.BindClickByCheckBox(self.RuleSelectCheck_0, function(sender, event)
        self.RuleSelectCheck_1:setSelected(false)
        self.Text_4:setString(self.Button_Click0:getTitleText())
        self.roomData.rule = 1
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomRule", self.roomData.rule)
    end)
    UIHelper.BindClickByCheckBox(self.RuleSelectCheck_1, function(sender, event)
        self.RuleSelectCheck_0:setSelected(false)
        self.Text_4:setString(self.Button_Click1:getTitleText())
        self.roomData.rule = 2
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomRule", self.roomData.rule)
    end)


    --底分
    UIHelper.BindClickByCheckBox(self.PointCheck_0, function(sender, event)
        self:pointCheckBoxFunc(sender)
        self.roomData.baseScore = 1
        self.PointCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomBaseScore", self.roomData.baseScore)
    end, self.PointCheckText0)
    UIHelper.BindClickByCheckBox(self.PointCheck_1, function(sender, event)
        self:pointCheckBoxFunc(sender)
        self.roomData.baseScore = 2
        self.PointCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomBaseScore", self.roomData.baseScore)
    end, self.PointCheckText1)
    UIHelper.BindClickByCheckBox(self.PointCheck_2, function(sender, event)
        self:pointCheckBoxFunc(sender)
        self.roomData.baseScore = 4
        self.PointCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomBaseScore", self.roomData.baseScore)
    end, self.PointCheckText2)
    UIHelper.BindClickByCheckBox(self.PointCheck_3, function(sender, event)
        self:pointCheckBoxFunc(sender)
        self.roomData.baseScore = 8
        self.PointCheckText3:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomBaseScore", self.roomData.baseScore)
    end, self.PointCheckText3)


    --局数
    UIHelper.BindClickByCheckBox(self.TimeCheck_0, function(sender, event) --5局
        self.roomData.count = 5
        self.TimeCheck_0:setSelected(true)
        self.TimeCheck_1:setSelected(false)
        self.TimeCheck_2:setSelected(false)
        self.TimeCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
        self.TimeCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
        self.TimeCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
        self.DimondCheckText0:setString("房主支付(   3)")
        self.DimondCheckText1:setString("AA支付(每人  1)")
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomCount", self.roomData.count)
    end, self.TimeCheckText0)
    UIHelper.BindClickByCheckBox(self.TimeCheck_1, function(sender, event) --10局
        self.roomData.count = 10
        self.TimeCheck_0:setSelected(false)
        self.TimeCheck_1:setSelected(true)
        self.TimeCheck_2:setSelected(false)
        self.TimeCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
        self.TimeCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
        self.TimeCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
        self.DimondCheckText0:setString("房主支付(   6)")
        self.DimondCheckText1:setString("AA支付(每人  2)")
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomCount", self.roomData.count)
    end, self.TimeCheckText1)
    UIHelper.BindClickByCheckBox(self.TimeCheck_2, function(sender, event) --20局
        self.roomData.count = 20
        self.TimeCheck_0:setSelected(false)
        self.TimeCheck_1:setSelected(false)
        self.TimeCheck_2:setSelected(true)
        self.TimeCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
        self.TimeCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
        self.TimeCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
        self.DimondCheckText0:setString("房主支付(   12)")
        self.DimondCheckText1:setString("AA支付(每人  4)")
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomCount", self.roomData.count)
    end, self.TimeCheckText2)


    --开房花费
    UIHelper.BindClickByCheckBox(self.DimondCheck_0, function(sender, event)
        self.DimondCheck_0:setSelected(true)
        self.DimondCheck_1:setSelected(false)
        self.roomData.payType = 1
        self.DimondCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
        self.DimondCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomPayType", self.roomData.payType)
    end, self.DimondCheckText0)
    UIHelper.BindClickByCheckBox(self.DimondCheck_1, function(sender, event)
        self.DimondCheck_0:setSelected(false)
        self.DimondCheck_1:setSelected(true)
        self.roomData.payType = 2
        self.DimondCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
        self.DimondCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomPayType", self.roomData.payType)
    end, self.DimondCheckText1)

    --特殊牌型倍数
    UIHelper.BindClickByCheckBox(self.SpaceilRuleCheck_0, function(sender, event)
        self.roomData.spottedBull = sender:isSelected()
        if self.roomData.spottedBull == true then
            self.SpaceilRuleCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.SpaceilRuleCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoomspottedBull", self.roomData.spottedBull)
    end, self.SpaceilRuleCheckText0)
    UIHelper.BindClickByCheckBox(self.SpaceilRuleCheck_1, function(sender, event)
        self.roomData.bombBull = sender:isSelected()
        if self.roomData.bombBull == true then
            self.SpaceilRuleCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.SpaceilRuleCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoombombBull", self.roomData.bombBull)
    end, self.SpaceilRuleCheckText1)
    UIHelper.BindClickByCheckBox(self.SpaceilRuleCheck_2, function(sender, event)
        self.roomData.smallBull = sender:isSelected()
        if self.roomData.smallBull == true then
            self.SpaceilRuleCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.SpaceilRuleCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoomsmallBull", self.roomData.smallBull)
    end, self.SpaceilRuleCheckText2)
    UIHelper.BindClickByCheckBox(self.SpaceilRuleCheck_3, function(sender, event)
        self.roomData.doubleBull = sender:isSelected()
        if self.roomData.doubleBull == true then
            self.SpaceilRuleCheckText3:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.SpaceilRuleCheckText3:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoomdoubleBull", self.roomData.doubleBull)
    end, self.SpaceilRuleCheckText3)
    UIHelper.BindClickByCheckBox(self.SpaceilRuleCheck_4, function(sender, event)
        self.roomData.straightBull = sender:isSelected()
        if self.roomData.straightBull == true then
            self.SpaceilRuleCheckText4:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.SpaceilRuleCheckText4:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoomdoubleBull", self.roomData.straightBull)
    end, self.SpaceilRuleCheckText4)
    UIHelper.BindClickByCheckBox(self.SpaceilRuleCheck_5, function(sender, event)
        self.roomData.suitBull = sender:isSelected()
        if self.roomData.suitBull == true then
            self.SpaceilRuleCheckText5:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.SpaceilRuleCheckText5:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoomdoubleBull", self.roomData.suitBull)
    end, self.SpaceilRuleCheckText5)
    UIHelper.BindClickByCheckBox(self.SpaceilRuleCheck_6, function(sender, event)
        self.roomData.threetwoBull = sender:isSelected()
        if self.roomData.threetwoBull == true then
            self.SpaceilRuleCheckText6:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.SpaceilRuleCheckText6:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoomdoubleBull", self.roomData.threetwoBull)
    end, self.SpaceilRuleCheckText6)

    --高级设置
    UIHelper.BindClickByCheckBox(self.AdvanceCheck_0, function(sender, event)
        self.roomData.playerPush = sender:isSelected()
        if self.roomData.playerPush == true then
            self.AdvanceCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.AdvanceCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoomplayerPush", self.roomData.playerPush)
    end, self.AdvanceCheckText0)
    UIHelper.BindClickByCheckBox(self.AdvanceCheck_1, function(sender, event)
        self.roomData.startedInto = sender:isSelected()
        if self.roomData.startedInto == true then
            self.AdvanceCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.AdvanceCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoomstartedInto", self.roomData.startedInto)
    end, self.AdvanceCheckText1)
    UIHelper.BindClickByCheckBox(self.AdvanceCheck_2, function(sender, event)
        self.roomData.disableTouchCard = sender:isSelected()
        if self.roomData.disableTouchCard == true then
            self.AdvanceCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.AdvanceCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
        end
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setBoolForKey("createRoomdisableTouchCard", self.roomData.disableTouchCard)
    end, self.AdvanceCheckText2)



    --上庄分数
    UIHelper.BindClickByCheckBox(self.BankerPointPointCheck_0, function(sender, event)
        self:pointUpBankerCheckBoxFunc(sender)
        self.roomData.getBankerScore = 0
        self.BankerPointCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomgetBankerScore", self.roomData.getBankerScore)
    end, self.BankerPointCheckText0)
    UIHelper.BindClickByCheckBox(self.BankerPointPointCheck_1, function(sender, event)
        self:pointUpBankerCheckBoxFunc(sender)
        self.roomData.getBankerScore = 400
        self.BankerPointCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomgetBankerScore", self.roomData.getBankerScore)
    end, self.BankerPointCheckText1)
    UIHelper.BindClickByCheckBox(self.BankerPointPointCheck_2, function(sender, event)
        self:pointUpBankerCheckBoxFunc(sender)
        self.roomData.getBankerScore = 600
        self.BankerPointCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
        cc.UserDefault:getInstance():setIntegerForKey("createRoomgetBankerScore", self.roomData.getBankerScore)
        SoundHelper.playMusicSound(65, 0, false)
    end, self.BankerPointCheckText2)
    UIHelper.BindClickByCheckBox(self.BankerPointPointCheck_3, function(sender, event)
        self:pointUpBankerCheckBoxFunc(sender)
        self.roomData.getBankerScore = 800
        self.BankerPointCheckText3:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoomgetBankerScore", self.roomData.getBankerScore)
    end, self.BankerPointCheckText3)
    --最大抢庄
    UIHelper.BindClickByCheckBox(self.BankerMultPointCheck_0, function(sender, event)
        self:multUpBankerCheckBoxFunc(sender)
        self.roomData.maxGetBankerScore = 1
        self.BankerMultCheckText0:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoommaxGetBankerScore", self.roomData.maxGetBankerScore)
    end, self.BankerMultCheckText0)
    UIHelper.BindClickByCheckBox(self.BankerMultPointCheck_1, function(sender, event)
        self:multUpBankerCheckBoxFunc(sender)
        self.roomData.maxGetBankerScore = 2
        self.BankerMultCheckText1:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoommaxGetBankerScore", self.roomData.maxGetBankerScore)
    end, self.BankerMultCheckText1)
    UIHelper.BindClickByCheckBox(self.BankerMultPointCheck_2, function(sender, event)
        self:multUpBankerCheckBoxFunc(sender)
        self.roomData.maxGetBankerScore = 3
        self.BankerMultCheckText2:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoommaxGetBankerScore", self.roomData.maxGetBankerScore)
    end, self.BankerMultCheckText2)
    UIHelper.BindClickByCheckBox(self.BankerMultPointCheck_3, function(sender, event)
        self:multUpBankerCheckBoxFunc(sender)
        self.roomData.maxGetBankerScore = 4
        self.BankerMultCheckText3:setTextColor(cc.c4b(255, 0, 0, 255))
        SoundHelper.playMusicSound(65, 0, false)
        cc.UserDefault:getInstance():setIntegerForKey("createRoommaxGetBankerScore", self.roomData.maxGetBankerScore)
    end, self.BankerMultCheckText3)

    local function onTouchBegan(touch, event)
        return true
    end

    local function onTouchMoved(touch, event)
    end

    local function onTouchEnded(touch, event)
        if self.Image_Advance:isVisible() == true then
            self.Image_Advance:setVisible(false)
        end
        if self.Image_Pay:isVisible() == true then
            self.Image_Pay:setVisible(false)
        end
    end

    self.listener1 = cc.EventListenerTouchOneByOne:create()
    self.listener1:setSwallowTouches(false)
    self.listener1:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
    self.listener1:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
    self.listener1:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(self.listener1, self.Panel_2)
end

function LayerCreateGame:pointCheckBoxFunc(sender)
    self.PointCheck_0:setSelected(false)
    self.PointCheck_1:setSelected(false)
    self.PointCheck_2:setSelected(false)
    self.PointCheck_3:setSelected(false)
    self.PointCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
    self.PointCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
    self.PointCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
    self.PointCheckText3:setTextColor(cc.c4b(122, 54, 19, 255))
    sender:setSelected(true)
end

function LayerCreateGame:pointUpBankerCheckBoxFunc(sender)
    self.BankerPointPointCheck_0:setSelected(false)
    self.BankerPointPointCheck_1:setSelected(false)
    self.BankerPointPointCheck_2:setSelected(false)
    self.BankerPointPointCheck_3:setSelected(false)
    self.BankerPointCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
    self.BankerPointCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
    self.BankerPointCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
    self.BankerPointCheckText3:setTextColor(cc.c4b(122, 54, 19, 255))
    sender:setSelected(true)
end

function LayerCreateGame:multUpBankerCheckBoxFunc(sender)
    self.BankerMultPointCheck_0:setSelected(false)
    self.BankerMultPointCheck_1:setSelected(false)
    self.BankerMultPointCheck_2:setSelected(false)
    self.BankerMultPointCheck_3:setSelected(false)
    self.BankerMultCheckText0:setTextColor(cc.c4b(122, 54, 19, 255))
    self.BankerMultCheckText1:setTextColor(cc.c4b(122, 54, 19, 255))
    self.BankerMultCheckText2:setTextColor(cc.c4b(122, 54, 19, 255))
    self.BankerMultCheckText3:setTextColor(cc.c4b(122, 54, 19, 255))
    sender:setSelected(true)
end

function LayerCreateGame:getWidget()
    return "PopUIs/LayerCreateGame.csb"
end

function LayerCreateGame:onEnter()
    self.super.onEnter()
end

function LayerCreateGame:onExit()
    local eventDispatcher = self:getEventDispatcher()
    eventDispatcher:removeEventListener(self.listener1)
    self.super.onExit(self)
end

return LayerCreateGame
--endregion
