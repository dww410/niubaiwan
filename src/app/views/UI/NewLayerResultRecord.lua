--region LayerResultRecord.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 战绩面板
--create by niyinguo
--Date: 2017/06/13

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
local platformMethod = require('app.Platform.platformMethod')

local NewLayerResultRecord = class("LayerResultRecord", require("app.views.UI.PopUI"))

function NewLayerResultRecord:ctor()
    NewLayerResultRecord.super.ctor(self)
    self:BindNodes(self.WidgetNode,
        "Panel_1.RoomMode",
        "Panel_1.GoldMode",
        "Panel_1.Panel_Record",
        "Panel_1.Panel_RecordDetailed")

    self.Panel_Record:BindNodes(self.Panel_Record, "ListView_Content", "Button_Close")
    self.Panel_RecordDetailed:BindNodes(self.Panel_RecordDetailed, "ScrollView_Content", "Button_Close", "Text_Round", "Text_1", "Text_2", "Text_3", "Text_4", "Text_5", "Text_6", "Text_Total_6", "Text_Total_5", "Text_Total_4", "Text_Total_3", "Text_Total_2", "Text_Total_1")

    self.ResultIDetailedtemCell = cc.CSLoader:createNode('PopUIs/ResultIDetailedtemCell.csb'):getChildByName("RecodeItem") --点击详细后 界面的cell
    self.ResultIDetailedtemCell:removeFromParent()
    self.ResultIDetailedtemCell:retain()
    self.ResultItemCell = cc.CSLoader:createNode('PopUIs/ResultItemCell.csb'):getChildByName("RecodeItem") --打开战绩面板的cell
    self.ResultItemCell:removeFromParent()
    self.ResultItemCell:retain()
    self.ResultRecordCell = cc.CSLoader:createNode('PopUIs/ResultRecordCell.csb'):getChildByName("RecodeItem") --打开战绩面板的cell的容器
    self.ResultRecordCell:removeFromParent()
    self.ResultRecordCell:retain()

    self.Panel_RecordDetailed:setVisible(false)
    self.Panel_Record:setVisible(true)

    self.ResultIDetailedtemCells = {}
    self.scrolllayout = ccui.Layout:create()
    self.scrolllayout:setContentSize(self.Panel_RecordDetailed.ScrollView_Content:getContentSize())
    self.Panel_RecordDetailed.ScrollView_Content:addChild(self.scrolllayout)

    UIHelper.BindClickByButtons({ self.Panel_Record.Button_Close, self.Panel_RecordDetailed.Button_Close }, function(sender, event)
        if self.Panel_Record.Button_Close == sender then
            self:Close()
        elseif self.Panel_RecordDetailed.Button_Close == sender then
            self.Panel_RecordDetailed:setVisible(false)
            self.Panel_Record:setVisible(true)
        end
    end)

    self.RoomMode:setVisible(false)
    self.RoomMode:setEnabled(false)
    self.GoldMode:setVisible(false)
    self.GoldMode:setEnabled(false)

    self.RoomMode:addEventListener(function(sender, event)
        self:showPanelIndex(1, self.RoomMode)
        SoundHelper.playMusicSound(65, 0, false)
    end)
    self.GoldMode:addEventListener(function(sender, event)
        self:showPanelIndex(2, self.GoldMode)
        SoundHelper.playMusicSound(65, 0, false)
    end)

    self.showIndex = -1

    self.ResultRecordCells = {}
    self.ResultRecordLastTag = 0
    self.ResultRecordLastPosY = 0

    self:initEvent()
end

function NewLayerResultRecord:initListView(listview, datas)
    listview:removeAllItems()
    if datas ~= nil then
        for i = 1, #datas do
            local layout = ccui.Layout:create()
            local cellP = 240

            if #datas[i].userContents < 4 then
                cellP = 75
                layout:setContentSize(cc.size(self.ResultRecordCell:getContentSize().width, self.ResultRecordCell:getContentSize().height / 2 + 20))
            else
                layout:setContentSize(self.ResultRecordCell:getContentSize())
            end

            layout:setTag(i)
            listview:pushBackCustomItem(layout)
        end
    end

    for i = 1, #self.ResultRecordCells do
        self.ResultRecordCells[i]:release()
    end
    self.ResultRecordCells = {}

    for i = 1, 5 do
        local cell = self:createResultRecordCell()
        table.insert(self.ResultRecordCells, cell)
        local item = listview:getItem(i - 1)
        if item ~= nil then
            item:addChild(cell)
            self:refreshCell(cell, i)
        end
    end
end

function NewLayerResultRecord:createResultRecordCell()
    local cellParent = self.ResultRecordCell:clone()

    for i = 1, 6 do
        local cellItem = self.ResultItemCell:clone()
        local x_cell = (i - 1) % 3
        local y_cell, t2 = math.modf((i - 1) / 3)
        cellItem:setPositionX(148 + 256.5 * x_cell)
        cellItem:setPositionY(240 - 157.5 * y_cell)
        cellItem:setName("ResultItemCell_" .. i)
        cellItem:setVisible(false)
        cellParent:addChild(cellItem)
    end

    cellParent:setName("cell")
    cellParent:retain()
    return cellParent
end

function NewLayerResultRecord:initEvent()
    self.recordIndex = 0
    self.Panel_Record.ListView_Content:addScrollViewEventListener(function(list, event)
        local data = self.Panel_Record.ListView_Content:getCenterItemInCurrentView()
        if data ~= nil then
            local index = data:getTag()
            if self.recordIndex ~= index then
                self.recordIndex = index
                local isup = false
                if self.ResultRecordLastPosY < self.Panel_Record.ListView_Content:getInnerContainerPosition().y then
                    isup = false
                else
                    isup = true
                end

                self.ResultRecordLastPosY = self.Panel_Record.ListView_Content:getInnerContainerPosition().y

                if self.ResultRecordLastTag - self.recordIndex == 2 then
                    self:updateCell(isup, self.recordIndex + 1)
                end

                if self.recordIndex - self.ResultRecordLastTag == 2 then
                    self:updateCell(isup, self.recordIndex - 1)
                end
                self:updateCell(isup, self.recordIndex)
            end
        end
    end)
end

function NewLayerResultRecord:updateCell(isup, index)
    if self.ResultRecordLastTag ~= index then
        if isup == true and index < #GlobalData.GameRecord - 2 then --往上滑
            local despos = self.ResultRecordLastTag - 3 --目标位置
            local srcpos = self.ResultRecordLastTag + 2 --源位置
            if despos < 1 or srcpos > #GlobalData.GameRecord then
                return
            else
                local srcitem = self.Panel_Record.ListView_Content:getItem(srcpos - 1)
                local child = srcitem:getChildByName("cell")
                if child ~= nil then
                    child:removeFromParent()
                    local desitem = self.Panel_Record.ListView_Content:getItem(despos - 1)
                    desitem:addChild(child)
                    self:refreshCell(child, despos)
                end
            end
        elseif isup == false and index > 3 then --往下滑
            local despos = self.ResultRecordLastTag + 3 --目标位置
            local srcpos = self.ResultRecordLastTag - 2 --源位置
            if despos > #GlobalData.GameRecord or srcpos < 1 then
                return
            else
                local srcitem = self.Panel_Record.ListView_Content:getItem(srcpos - 1)
                local child = srcitem:getChildByName("cell")
                if child ~= nil then
                    child:removeFromParent()
                    local desitem = self.Panel_Record.ListView_Content:getItem(despos - 1)
                    desitem:addChild(child)
                    self:refreshCell(child, despos)
                end
            end
        end
    end
    self.ResultRecordLastTag = index
end

function NewLayerResultRecord:refreshCell(cell, i)
    cell:getChildByName("Image_1"):getChildByName("Text_RoomNum"):setString("房号:" .. i)
    if self.showIndex == 1 then
        self:setResultRecordCellData(cell, GlobalData.GameRecord[i])
    elseif self.showIndex == 2 then
        self:setResultRecordCellData(cell, GlobalData.GoldGameRecord[i])
    end
end

function NewLayerResultRecord:showPanelIndex(index, checkBox)
    WaitProgress.Show()
    if self.showIndex == index then
        WaitProgress.Close()
        checkBox:setSelected(true)
        return
    end
    if checkBox == nil then
        checkBox = self.RoomMode
    end
    if self.Panel_RecordDetailed:isVisible() == true then
        self.Panel_RecordDetailed:setVisible(false)
    end
    self.RoomMode:setSelected(false)
    self.GoldMode:setSelected(false)
    checkBox:setSelected(true)
    self.showIndex = index
    if self.showIndex == 1 then
        self:initListView(self.Panel_Record.ListView_Content, GlobalData.GameRecord)
    elseif self.showIndex == 2 then
        self:initListView(self.Panel_Record.ListView_Content, GlobalData.GoldGameRecord)
    end
    self.Panel_Record:setVisible(true)
    WaitProgress.Close()
end

function NewLayerResultRecord:getWidget()
    return "PopUIs/LayerResultRecord.csb"
end

function NewLayerResultRecord:onEnter()
    self.super.onEnter(self)
    MessageHandle.addHandle(Enum.GAME_RECORD_CLIENT, function(msgid, data)
    end, self)
end

function NewLayerResultRecord:onExit()
    self.super.onExit(self)
    self.ResultIDetailedtemCell:release()
    self.ResultItemCell:release()
    self.ResultRecordCell:release()
    for i = 1, #self.ResultRecordCells do
        self.ResultRecordCells[i]:release()
    end
    self.ResultRecordCells = {}
    MessageHandle.removeHandle(self)
end

function NewLayerResultRecord:setResultRecordCellData(cellParent, itemData)
    local bg = cellParent:getChildByName("Image_1")
    local button_Detailed = bg:getChildByName("Button_Detailed")
    local button_Share = bg:getChildByName("Button_Share")
    local roomText = bg:getChildByName("Text_RoomNum")
    local roundText = bg:getChildByName("Text_RoundNum")
    local basescoreText = bg:getChildByName("Text_BaseScore")
    local typeText = bg:getChildByName("Text_GameType")
    local timeText = bg:getChildByName("Text_GameTime")

    roomText:setString("房号:" .. itemData.roomNo)

    roundText:setVisible(true)
    if itemData.gameType == 6 then
        roundText:setVisible(false)
    end

    roundText:setString("局数:" .. itemData.totalRound)

    if itemData.gameType ~= 5 then
        basescoreText:setString("底分:" .. itemData.baseScore .. "/" .. 2 * itemData.baseScore)
    else
        basescoreText:setString("底分:" .. itemData.baseScore)
    end

    typeText:setString(GameType[itemData.gameType])
    timeText:setString(itemData.date)

    local cellP = 240

    if #itemData.userContents < 4 then
        cellP = 75

        bg:setContentSize(cc.size(self.ResultRecordCell:getContentSize().width, self.ResultRecordCell:getContentSize().height / 2 + 20))
        bg:setPositionY(bg:getContentSize().height * 0.5)
        button_Detailed:setPositionY(bg:getContentSize().height * 0.98)
        button_Share:setPositionY(bg:getContentSize().height * 0.98)
        roomText:setPositionY(bg:getContentSize().height * 0.9)
        roundText:setPositionY(bg:getContentSize().height * 0.9)
        roundText:setPositionY(bg:getContentSize().height * 0.9)
        basescoreText:setPositionY(bg:getContentSize().height * 0.9)
        typeText:setPositionY(bg:getContentSize().height * 0.9)
        timeText:setPositionY(bg:getContentSize().height * 0.9)
    else
        bg:setContentSize(cc.size(self.ResultRecordCell:getContentSize().width, self.ResultRecordCell:getContentSize().height))
        bg:setPositionY(bg:getContentSize().height * 0.5)
        button_Detailed:setPositionY(bg:getContentSize().height * 0.988)
        button_Share:setPositionY(bg:getContentSize().height * 0.988)
        roomText:setPositionY(bg:getContentSize().height * 0.967)
        roundText:setPositionY(bg:getContentSize().height * 0.967)
        roundText:setPositionY(bg:getContentSize().height * 0.967)
        basescoreText:setPositionY(bg:getContentSize().height * 0.967)
        typeText:setPositionY(bg:getContentSize().height * 0.967)
        timeText:setPositionY(bg:getContentSize().height * 0.967)
    end
    for n = 1, 6 do
        self.Panel_RecordDetailed["Text_" .. n]:setVisible(false)
        self.Panel_RecordDetailed["Text_Total_" .. n]:setVisible(false)
    end
    self:setResultData(cellParent, itemData.userContents, itemData.roomOwner, cellP)

    UIHelper.BindClickByButtons({ button_Detailed, button_Share }, function(sender, event)
        if sender == button_Detailed then
            self.Panel_RecordDetailed:setVisible(true)
            self.Panel_Record:setVisible(false)
            self:setDetailedData(itemData.gameItemContents, itemData.rule, itemData.userContents)
        elseif sender == button_Share then
            local fileName = cc.FileUtils:getInstance():getWritablePath() .. "printScreen.png"
            -- 截屏  
            cc.utils:captureScreen(function(succeed, outputFile)
                WaitProgress.Close()

                if succeed then
                    PayStuate = function(sutat)
                        if targetPlatform == cc.PLATFORM_OS_ANDROID then
                            if sutat == "-4" or sutat == "-2" then
                                MessageTip.Show("分享取消!")
                            elseif sutat == "-99" then
                                MessageTip.Show("请先安装微信!")
                            else
                                MessageTip.Show("微信分享成功")
                            end
                        else
                            if sutat == 0 then
                                MessageTip.Show("微信分享成功")
                            else
                                MessageTip.Show("微信分享失败")
                            end
                        end
                        -- 移除纹理缓存
                        cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)
                        --                            self:removeChildByTag(1001)
                    end
                    platformMethod.weichatfenxiang(GAME_URL.downLoadUrl .. "?RoomNum=0", APP_INFO.appname .. "（仿真实战·手感搓牌）", "激情斗牛，约上好友，明牌抢庄，炸弹带五花。大家都在玩，就等你了【点我下载】", outputFile, 0, PayStuate, 2)
                else
                    MessageTip.Show("截屏失败")
                end
            end, fileName)
        end
    end)
end

function NewLayerResultRecord:createDetailCell(index)
    local cell = {}
    if #self.ResultIDetailedtemCells >= index then
        cell = self.ResultIDetailedtemCells[index]
        --        cell:setContentSize(cell:getContentSize().width,60)
        --        cell:getChildByName("Image_1"):setPositionY(cell:getChildByName("Image_1"):getPositionY()-cell:getChildByName("Image_1"):getContentSize().height)
    else
        cell = self.ResultIDetailedtemCell:clone()
        table.insert(self.ResultIDetailedtemCells, cell)
        self.scrolllayout:addChild(cell)
    end
    return cell
end

--122 62 30
function NewLayerResultRecord:setDetailedData(data, rule, userData)
    if rule == nil then
        rule = 1
    end

    for i = 1, #userData do
        self.Panel_RecordDetailed["Text_Total_" .. i]:setVisible(true)
        self.Panel_RecordDetailed["Text_Total_" .. i]:setString(userData[i].totalScore)
        self.Panel_RecordDetailed["Text_" .. i]:setVisible(true)
        local name = userData[i].name
        if Tool.SubStringGetTotalIndex(name) > 4 then
            name = Tool.SubStringUTF8(name, 0, 4) .. ".."
        end
        self.Panel_RecordDetailed["Text_" .. i]:setString(name)
        if userData[i].username == PlayerManager.Player.userName then
            if userData[i].totalScore > 0 then
                self.Panel_RecordDetailed["Text_Total_" .. i]:setTextColor(cc.c4b(255, 0, 0, 255))
            elseif userData[i].totalScore < 0 then
                self.Panel_RecordDetailed["Text_Total_" .. i]:setTextColor(cc.c4b(0, 128, 0, 255))
            else
                self.Panel_RecordDetailed["Text_Total_" .. i]:setTextColor(cc.c4b(122, 62, 30, 255))
            end
            self.Panel_RecordDetailed["Text_" .. i]:setTextColor(cc.c4b(255, 0, 0, 255))
        else
            self.Panel_RecordDetailed["Text_" .. i]:setTextColor(cc.c4b(122, 62, 30, 255))
            self.Panel_RecordDetailed["Text_Total_" .. i]:setTextColor(cc.c4b(122, 62, 30, 255))
        end
    end

    for i = 1, #self.ResultIDetailedtemCells do
        self.ResultIDetailedtemCells[i]:setVisible(false)
    end


    --   self.Panel_RecordDetailed.ListView_Content:removeAllItems()
    --   self.scrolllayout:removeAllChildren()
    local gameItemContents = data
    local totalDataNum = #gameItemContents
    self.scrolllayout:setContentSize(cc.size(820, 60 * #gameItemContents))
    if self.scrolllayout:getContentSize().height < 360 then
        self.Panel_RecordDetailed.ScrollView_Content:setInnerContainerSize(cc.size(820, 360))
    else
        self.Panel_RecordDetailed.ScrollView_Content:setInnerContainerSize(self.scrolllayout:getContentSize())
    end

    for i = 1, #gameItemContents do
        local cell = self:createDetailCell(i)
        cell:setVisible(true)
        cell:setName("ResultIDetailedtemCell_" .. i)
        local textTable = {}
        local textParent = cell:getChildByName("Image_1")
        local Text_Round = textParent:getChildByName("Text_Round")
        local Text_1 = textParent:getChildByName("Text_first")
        local Text_2 = textParent:getChildByName("Text_scond")
        local Text_3 = textParent:getChildByName("Text_three")
        local Text_4 = textParent:getChildByName("Text_four")
        local Text_5 = textParent:getChildByName("Text_five")
        local Text_6 = textParent:getChildByName("Text_six")
        table.insert(textTable, Text_1)
        table.insert(textTable, Text_2)
        table.insert(textTable, Text_3)
        table.insert(textTable, Text_4)
        table.insert(textTable, Text_5)
        table.insert(textTable, Text_6)
        local Button_Drop = textParent:getChildByName("Button_Drop")
        local Image_Drop = Button_Drop:getChildByName("Image_Drop")
        Text_1:setVisible(false)
        Text_2:setVisible(false)
        Text_3:setVisible(false)
        Text_4:setVisible(false)
        Text_5:setVisible(false)
        Text_6:setVisible(false)
        Text_Round:setString("第" .. i .. "局")
        if i % 2 == 0 then
            textParent:loadTexture("xia.png", ccui.TextureResType.plistType)
        end

        local cardParent = cell:getChildByName("Image_Dropdown")

        for i = 1, 6 do
            UIHelper.getNode(cardParent, { "Panel_Card_" .. (i - 1) }):setVisible(false)
        end

        local totalPoint = 0

        --region 每个玩家 每局
        for j = 1, #gameItemContents[i] do
            local itemUser = gameItemContents[i][j]
            textTable[j]:setVisible(true)
            textTable[j]:setString(itemUser.win)
            if itemUser.username == PlayerManager.Player.userName then
                if itemUser.win > 0 then
                    textTable[j]:setTextColor(cc.c4b(255, 0, 0, 255))
                elseif itemUser.win < 0 then
                    textTable[j]:setTextColor(cc.c4b(0, 128, 0, 255))
                else
                    textTable[j]:setTextColor(cc.c4b(122, 62, 30, 255))
                end
            else
                textTable[j]:setTextColor(cc.c4b(122, 62, 30, 255))
            end

            --card
            UIHelper.getNode(cardParent, { "Panel_Card_" .. (j - 1) }):setVisible(true)
            for i = 1, 5 do
                local card = itemUser.cards[i].cardColor .. "_" .. itemUser.cards[i].value .. ".png"
                UIHelper.getNode(cardParent, { "Panel_Card_" .. (j - 1), "Image_card" .. (i - 1) }):loadTexture(card, ccui.TextureResType.plistType)
            end

            local niustr = "niuniu_cow_" .. itemUser.value .. ".png"
            UIHelper.getNode(cardParent, { "Panel_Card_" .. (j - 1), "Image_cardType" }):loadTexture(niustr, ccui.TextureResType.plistType)

            local cardMult = UIHelper.getNode(cardParent, { "Panel_Card_" .. (j - 1), "Image_cardMult" })
            cardMult:setVisible(false)

            if itemUser.isBanker == true then
                print(itemUser.username .. "下注:" .. itemUser.played .. "庄")
            else
                print(itemUser.username .. "下注:" .. itemUser.played .. "不是庄")
            end

            if itemUser.isBanker == true then
                UIHelper.getNode(cardParent, { "Panel_Card_" .. (j - 1), "Image_isBanker" }):setVisible(true)
                UIHelper.getNode(cardParent, { "Panel_Card_" .. (j - 1), "Image_Ship" }):setVisible(false)
            else
                UIHelper.getNode(cardParent, { "Panel_Card_" .. (j - 1), "Image_isBanker" }):setVisible(false)
                UIHelper.getNode(cardParent, { "Panel_Card_" .. (j - 1), "Image_Ship" }):setVisible(true)
                UIHelper.getNode(cardParent, { "Panel_Card_" .. (j - 1), "Image_Ship", "Text_Ship" }):setString(itemUser.played)
            end

            if itemUser.value < 6 + rule then
                cardMult:setVisible(false)
            else
                local multstr = ""
                if rule == 1 then
                    if itemUser.value == 7 then
                        multstr = "niuniu_mult_yellow_2.png"
                    elseif itemUser.value == 8 then
                        multstr = "niuniu_mult_yellow_2.png"
                    elseif itemUser.value == 9 then
                        multstr = "niuniu_mult_yellow_3.png"
                    elseif itemUser.value == 10 then
                        multstr = "niuniu_mult_red_4.png"
                    end
                elseif rule == 2 then
                    if itemUser.value == 8 then
                        multstr = "niuniu_mult_yellow_2.png"
                    elseif itemUser.value == 9 then
                        multstr = "niuniu_mult_yellow_2.png"
                    elseif itemUser.value == 10 then
                        multstr = "niuniu_mult_red_4.png"
                    end
                end

                if itemUser.value == 11 then
                    multstr = "niuniu_mult_red_4.png"
                elseif itemUser.value == 12 then
                    multstr = "niuniu_mult_red_5.png"
                elseif itemUser.value == 13 then
                    multstr = "niuniu_mult_red_6.png"
                elseif itemUser.value == 14 then
                    multstr = "niuniu_mult_red_8.png"
                end

                if multstr ~= "" then
                    cardMult:loadTexture(multstr, ccui.TextureResType.plistType)
                    cardMult:setVisible(true)
                end
            end
        end
        --endregion
        local selfIndex = 0
        selfIndex = j
        cardParent:setVisible(false)
        Image_Drop:runAction(cc.Sequence:create(cc.RotateTo:create(0.1, -90)))
        local dir = 0
        UIHelper.BindClickByButton(Button_Drop, function(sender, event)
            if cardParent:isVisible() == true then
                cardParent:setVisible(false)
                Image_Drop:runAction(cc.Sequence:create(cc.RotateTo:create(0.1, -90)))
                dir = -1
            else
                cardParent:setVisible(true)
                Image_Drop:runAction(cc.Sequence:create(cc.RotateTo:create(0.1, 0)))
                dir = 1
            end
            local cellName = cell:getName()
            local substring = string.sub(cellName, string.len("ResultIDetailedtemCell_") + 1, string.len(cellName))

            local index = tonumber(substring)



            local recordPY = self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerPosition().y
            print("重置布局之前:" .. self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerPosition().x .. "__" .. self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerPosition().y)
            self.scrolllayout:setContentSize(cc.size(820, self.scrolllayout:getContentSize().height + dir * 99))
            if self.scrolllayout:getContentSize().height < self.Panel_RecordDetailed.ScrollView_Content:getContentSize().height then
                self.Panel_RecordDetailed.ScrollView_Content:setInnerContainerSize(cc.size(820, 360))
            else
                self.Panel_RecordDetailed.ScrollView_Content:setInnerContainerSize(self.scrolllayout:getContentSize())
            end

            local openIndex = 0
            local isadd = 0
            for i = 1, totalDataNum do
                if i == 1 then
                    openIndex = self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerSize().height - 79.5
                else
                    openIndex = self.ResultIDetailedtemCells[i - 1]:getPositionY() - (60 + isadd * 99)
                end

                self.ResultIDetailedtemCells[i]:setPositionY(openIndex)
                local isOpen = self.ResultIDetailedtemCells[i]:getChildByName("Image_Dropdown"):isVisible()
                if isOpen then
                    isadd = 1
                else
                    isadd = 0
                end
            end

            print("重置布局之后:" .. self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerPosition().x .. "__" .. self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerPosition().y)
            --          if recordPY<self.Panel_RecordDetailed.ScrollView_Content:getContentSize().height- self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerSize().height then
            --             recordPY = self.Panel_RecordDetailed.ScrollView_Content:getContentSize().height- self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerSize().height
            --          end
            recordPY = recordPY - dir * self.ResultIDetailedtemCells[index]:getContentSize().height / 2
            if recordPY < 360 - self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerSize().height then
                recordPY = 360 - self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerSize().height
            end
            self.Panel_RecordDetailed.ScrollView_Content:setInnerContainerPosition(cc.p(0, recordPY))
            print("recordPY之后:" .. self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerPosition().x .. "__" .. self.Panel_RecordDetailed.ScrollView_Content:getInnerContainerPosition().y)
        end)
        local height = self.scrolllayout:getContentSize().height
        if height < 360 then
            height = 360
        end
        cell:setPositionY(height - (cell:getContentSize().height / 2) - 60 * (i - 1))
    end
end

function NewLayerResultRecord:setResultData(parent, data, roomOwner, cellP)
    local userContents = data
    local minUser = ""
    local maxUser = ""
    local minUserpoint = 0
    local maxUserpoint = 0
    local havesameMin = false
    local havesameMax = false
    for i = 1, #userContents do
        if userContents[i].totalScore > maxUserpoint then
            maxUserpoint = userContents[i].totalScore
            maxUser = userContents[i].username
            if havesameMax == true then
                havesameMax = false
            end
        end

        if userContents[i].totalScore < minUserpoint then
            minUserpoint = userContents[i].totalScore
            minUser = userContents[i].username
            if havesameMin == true then
                havesameMin = false
            end
        end

        if userContents[i].totalScore == maxUserpoint and maxUser ~= userContents[i].username then
            havesameMax = true
        end

        if userContents[i].totalScore == minUserpoint and minUser ~= userContents[i].username then
            havesameMin = true
        end
    end


    for i = 1, 6 do
        parent:getChildByName("ResultItemCell_" .. i):setVisible(false)
    end


    for i = 1, #userContents do
        local cell = parent:getChildByName("ResultItemCell_" .. i)
        local head = cell:getChildByName("Image_Head")
        local userNameText = cell:getChildByName("Text_UserName")
        local idText = cell:getChildByName("Text_ID")
        local pointText = cell:getChildByName("Text_Point")
        local leftMark = cell:getChildByName("Image_LeftMark")
        local rightMark = cell:getChildByName("Image_RightMark")
        --todo 头像
        UIHelper.loadImgUrl(head, userContents[i].head, userContents[i].username)
        local name = userContents[i].name
        if Tool.SubStringGetTotalIndex(name) > 4 then
            name = Tool.SubStringUTF8(name, 0, 4) .. ".."
        end
        userNameText:setString(name)
        idText:setString(userContents[i].username)

        if userContents[i].totalScore > 0 then
            pointText:setString(userContents[i].totalScore):setTextColor(cc.c4b(255, 0, 0, 255))
        elseif userContents[i].totalScore < 0 then
            pointText:setString(userContents[i].totalScore):setTextColor(cc.c4b(0, 128, 0, 255))
        else
            pointText:setString(userContents[i].totalScore):setTextColor(cc.c4b(122, 62, 30, 255))
        end

        if roomOwner == userContents[i].username then
            leftMark:setVisible(true)
        else
            leftMark:setVisible(false)
        end

        rightMark:setVisible(false)
        if havesameMax == false and maxUser == userContents[i].username then
            rightMark:setVisible(true)
            rightMark:loadTexture("image_winnermark.png", ccui.TextureResType.plistType)
        end
        if havesameMin == false and minUser == userContents[i].username then
            rightMark:setVisible(true)
            rightMark:loadTexture("image_tuhaomark.png", ccui.TextureResType.plistType)
        end
        --148 244.5 404.5 244.5 661 244.5
        --148 87    404.5 87    661 87
        local x_cell = (i - 1) % 3
        local y_cell, t2 = math.modf((i - 1) / 3)
        cell:setPositionX(148 + 256.5 * x_cell)
        cell:setPositionY(cellP - 157.5 * y_cell)
        cell:setVisible(true)
    end
end

return NewLayerResultRecord

--endregion
