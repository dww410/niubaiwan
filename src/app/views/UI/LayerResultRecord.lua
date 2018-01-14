--region LayerResultRecord.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 战绩面板
--create by niyinguo
--Date: 2017/06/13

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
local platformMethod = require('app.Platform.platformMethod')

local LayerResultRecord = class("LayerResultRecord", require("app.views.UI.PopUI"))

function LayerResultRecord:ctor()
    LayerResultRecord.super.ctor(self)
     self:BindNodes(self.WidgetNode,
     "Panel_1.RoomMode",
     "Panel_1.GoldMode",
     "Panel_1.Panel_Record",
     "Panel_1.Panel_RecordDetailed"
     )

     self.Panel_Record:BindNodes( self.Panel_Record,"ListView_Content","Button_Close")
     self.Panel_RecordDetailed:BindNodes( self.Panel_RecordDetailed,"ListView_Content","Button_Close","Text_Round","Text_1","Text_2","Text_3","Text_4","Text_5","Text_6","Text_Total_6","Text_Total_5","Text_Total_4","Text_Total_3","Text_Total_2","Text_Total_1")

     self.ResultIDetailedtemCell = cc.CSLoader:createNode('PopUIs/ResultIDetailedtemCell.csb'):getChildByName("RecodeItem") --点击详细后 界面的cell
     self.ResultIDetailedtemCell:removeFromParent()
     self.ResultIDetailedtemCell:retain()
     self.ResultItemCell = cc.CSLoader:createNode('PopUIs/ResultItemCell.csb'):getChildByName("RecodeItem")--打开战绩面板的cell
     self.ResultItemCell:removeFromParent()
     self.ResultItemCell:retain()
     self.ResultRecordCell = cc.CSLoader:createNode('PopUIs/ResultRecordCell.csb'):getChildByName("RecodeItem")--打开战绩面板的cell的容器
     self.ResultRecordCell:removeFromParent()
     self.ResultRecordCell:retain()

     self.Panel_RecordDetailed:setVisible(false)
     self.Panel_Record:setVisible(true)

     UIHelper.BindClickByButtons({self.Panel_Record.Button_Close,self.Panel_RecordDetailed.Button_Close},function(sender,event)
        if self.Panel_Record.Button_Close == sender then
            self:Close()
        elseif self.Panel_RecordDetailed.Button_Close == sender then
            self.Panel_RecordDetailed:setVisible(false)
            self.Panel_Record:setVisible(true)
        end
     end)

      self.RoomMode:addEventListener(function(sender,event)
        self:showPanelIndex(1,self.RoomMode)
        SoundHelper.playMusicSound(65,0,false)
    end)
    self.GoldMode:addEventListener(function(sender,event)
        self:showPanelIndex(2,self.GoldMode)
        SoundHelper.playMusicSound(65,0,false)
    end)

    self.showIndex = -1
    self.GoldMode:setVisible(false)
    self.GoldMode:setEnabled(false)
end

function LayerResultRecord:showPanelIndex(index,checkBox)
    WaitProgress.Show()
    if self.showIndex == index then
        return
    end
    if checkBox == nil then
        checkBox = self.RoomMode
    end
    self.RoomMode:setSelected(false)
    self.GoldMode:setSelected(false)
    checkBox:setSelected(true)
    self.showIndex = index
    if self.showIndex == 1 then
        self:setData(GlobalData.GameRecord)
    elseif self.showIndex == 2 then
        self:setData(GlobalData.GoldGameRecord)
    end
    WaitProgress.Close()
end

function LayerResultRecord:getWidget()
    return "PopUIs/LayerResultRecord.csb"
end
function LayerResultRecord:onEnter()
    self.super.onEnter(self)
    MessageHandle.addHandle(Enum.GAME_RECORD_CLIENT,function(msgid,data)
        
    end,self)
end

function LayerResultRecord:onExit()
    self.super.onExit(self)
    self.ResultIDetailedtemCell:release()
    self.ResultItemCell:release()
    self.ResultRecordCell:release()
    MessageHandle.removeHandle(self)
end

function LayerResultRecord:setData(gamerecords)
    self.Panel_Record.ListView_Content:removeAllItems()
    self.Panel_Record:setVisible(true)
    self.Panel_RecordDetailed:setVisible(false)
    local records = gamerecords
    for i = 1, #records do
        local itemData = records[i]
        local cellParent = self.ResultRecordCell:clone()
        local bg = cellParent:getChildByName("Image_1")
        local button_Detailed = bg:getChildByName("Button_Detailed")
        local button_Share = bg:getChildByName("Button_Share")
        local roomText = bg:getChildByName("Text_RoomNum")
        local roundText = bg:getChildByName("Text_RoundNum")
        local basescoreText = bg:getChildByName("Text_BaseScore")
        local typeText = bg:getChildByName("Text_GameType")
        local timeText = bg:getChildByName("Text_GameTime")
        roomText:setString("房号:"..itemData.roomNo)
        roundText:setVisible(true)
        if itemData.gameType == 6 then
            roundText:setVisible(false)
        end
        roundText:setString("局数:"..itemData.totalRound)
        if itemData.gameType~=5 then
            basescoreText:setString("底分:"..itemData.baseScore.."/".. 2*itemData.baseScore)
        else
            basescoreText:setString("底分:"..itemData.baseScore)
        end
        typeText:setString(GameType[itemData.gameType])
        timeText:setString(itemData.date)

        local cellP = 240

        if #itemData.userContents<4 then
           cellP = 75
            
           cellParent:setContentSize(cc.size(cellParent:getContentSize().width,cellParent:getContentSize().height/2+20))
           bg:setContentSize(cc.size(bg:getContentSize().width,bg:getContentSize().height/2+20))
           bg:setPositionY(bg:getContentSize().height*0.5)
           button_Detailed:setPositionY(bg:getContentSize().height*0.98)
           button_Share:setPositionY(bg:getContentSize().height*0.98)
           roomText:setPositionY(bg:getContentSize().height*0.9)
           roundText:setPositionY(bg:getContentSize().height*0.9)
           roundText:setPositionY(bg:getContentSize().height*0.9)
           basescoreText:setPositionY(bg:getContentSize().height*0.9)
           typeText:setPositionY(bg:getContentSize().height*0.9)
           timeText:setPositionY(bg:getContentSize().height*0.9)
--           bg:getParent():requestDoLayout()
        end
        for n = 1, 6 do
            self.Panel_RecordDetailed["Text_"..n]:setVisible(false)
            self.Panel_RecordDetailed["Text_Total_"..n]:setVisible(false)
        end
        self:setResultData(cellParent,itemData.userContents,itemData.roomOwner,cellP)

        UIHelper.BindClickByButtons({button_Detailed,button_Share},function(sender,event)
            if sender == button_Detailed then
                self.Panel_RecordDetailed:setVisible(true)
                self.Panel_Record:setVisible(false)
                self:setDetailedData(itemData.gameItemContents,itemData.rule,itemData.userContents)
            elseif sender == button_Share then
               local fileName = cc.FileUtils:getInstance():getWritablePath().."printScreen.png"  
               -- 截屏  
               cc.utils:captureScreen(function(succeed, outputFile)  
                   if succeed then  
                       local winSize = cc.Director:getInstance():getWinSize()  
                       local sp = cc.Sprite:create(outputFile)  
                       self:addChild(sp, 0, 1001)  
                       sp:setPosition(winSize.width / 2, winSize.height / 2)  
                       sp:setScale(0.5) -- 显示缩放  
                   else  
                       cc.showTextTips("截屏失败")  
                   end  
                   WaitProgress.Close()

                   if succeed then  
                        PayStuate= function(sutat)
                            if targetPlatform == cc.PLATFORM_OS_ANDROID then
                                if sutat=="-4" or sutat=="-2" then
                                    MessageTip.Show("分享取消!")
                                elseif sutat=="-99" then
                                    MessageTip.Show("您没有安装微信,请先安装微信!")
                                else
                                    MessageTip.Show("微信分享成功")
                                end

                                self:removeChildByTag(1000)
                            else
                                 if sutat==0 then
                                    MessageTip.Show("微信分享成功")
                                 else
                                    MessageTip.Show("微信分享失败")
                                 end
                            end
                                 -- 移除纹理缓存  
                            cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)  
                            self:removeChildByTag(1001)   
                        end
                        platformMethod.weichatfenxiang(GAME_URL.downLoadUrl.."?RoomNum=0",APP_INFO.appname.."（仿真实战·手感搓牌）","激情斗牛，约上好友，明牌抢庄，炸弹带五花。大家都在玩，就等你了【点我下载】",outputFile,0,PayStuate,2)
                    end
                end,  fileName)
            end
        end)

        self.Panel_Record.ListView_Content:pushBackCustomItem(cellParent)
    end
end

--122 62 30 
function LayerResultRecord:setDetailedData(data,rule,userData)
   if rule == nil then
      rule = 1
   end

   for i = 1, #userData do
       self.Panel_RecordDetailed["Text_Total_"..i]:setVisible(true)
       self.Panel_RecordDetailed["Text_Total_"..i]:setString(userData[i].totalScore)
       self.Panel_RecordDetailed["Text_"..i]:setVisible(true)
       self.Panel_RecordDetailed["Text_"..i]:setString(userData[i].name) 
       if userData[i].username ==PlayerManager.Player.userName  then
           if userData[i].totalScore>0 then
               self.Panel_RecordDetailed["Text_Total_"..i]:setTextColor(cc.c4b(255,0,0,255))
           elseif userData[i].totalScore<0 then 
               self.Panel_RecordDetailed["Text_Total_"..i]:setTextColor(cc.c4b(0,128,0,255))
           else
               self.Panel_RecordDetailed["Text_Total_"..i]:setTextColor(cc.c4b(122,62,30,255))
           end
           self.Panel_RecordDetailed["Text_"..i]:setTextColor(cc.c4b(255,0,0,255))
       else
           self.Panel_RecordDetailed["Text_"..i]:setTextColor(cc.c4b(122,62,30,255))
           self.Panel_RecordDetailed["Text_Total_"..i]:setTextColor(cc.c4b(122,62,30,255))
       end  
   end
   


   self.Panel_RecordDetailed.ListView_Content:removeAllItems()
   local gameItemContents = data
   
   for i = 1, #gameItemContents do
       local cell = self.ResultIDetailedtemCell:clone()

       local textTable = {}
       local textParent = cell:getChildByName("Image_1")
       local Text_Round = textParent:getChildByName("Text_Round")
       local Text_1 = textParent:getChildByName("Text_first")
       local Text_2 = textParent:getChildByName("Text_scond")
       local Text_3 = textParent:getChildByName("Text_three")
       local Text_4 = textParent:getChildByName("Text_four")
       local Text_5 = textParent:getChildByName("Text_five")
       local Text_6 = textParent:getChildByName("Text_six")
       table.insert(textTable,Text_1)
       table.insert(textTable,Text_2)
       table.insert(textTable,Text_3)
       table.insert(textTable,Text_4)
       table.insert(textTable,Text_5)
       table.insert(textTable,Text_6)
       local Button_Drop = textParent:getChildByName("Button_Drop")
       local Image_Drop = Button_Drop:getChildByName("Image_Drop")
       Text_1:setVisible(false)
       Text_2:setVisible(false)
       Text_3:setVisible(false)
       Text_4:setVisible(false)
       Text_5:setVisible(false)
       Text_6:setVisible(false)
       Text_Round:setString("第"..i.."局")
       if i%2 == 0 then
            textParent:loadTexture("xia.png",ccui.TextureResType.plistType)
       end

       local cardParent = cell:getChildByName("Image_Dropdown")

       for i = 1, 6 do
           UIHelper.getNode(cardParent,{"Panel_Card_"..(i-1)}):setVisible(false)
       end
       
       local totalPoint = 0
       
       --region 每个玩家 每局
       for j = 1, #gameItemContents[i] do
           local itemUser = gameItemContents[i][j]
           textTable[j]:setVisible(true)
           textTable[j]:setString(itemUser.win)
           if itemUser.username == PlayerManager.Player.userName then
              if itemUser.win>0 then
                  textTable[j]:setTextColor(cc.c4b(255,0,0,255))
              elseif itemUser.win<0 then 
                  textTable[j]:setTextColor(cc.c4b(0,128,0,255))
              else
                  textTable[j]:setTextColor(cc.c4b(122,62,30,255))
              end 
           end

           --card
           UIHelper.getNode(cardParent,{"Panel_Card_"..(j-1)}):setVisible(true)
           for i = 1, 5 do
               local card = itemUser.cards[i].cardColor .."_" ..itemUser.cards[i].value .. ".png"
               UIHelper.getNode(cardParent,{"Panel_Card_"..(j-1),"Image_card"..(i-1)}):loadTexture(card,ccui.TextureResType.plistType)
           end
           
           local niustr = "niuniu_cow_"..itemUser.value..".png"
           UIHelper.getNode(cardParent,{"Panel_Card_"..(j-1),"Image_cardType"}):loadTexture(niustr,ccui.TextureResType.plistType)

           local cardMult = UIHelper.getNode(cardParent,{"Panel_Card_"..(j-1),"Image_cardMult"})
           cardMult:setVisible(false)

           if itemUser.played == 0 then
              UIHelper.getNode(cardParent,{"Panel_Card_"..(j-1),"Image_isBanker"}):setVisible(true)
              UIHelper.getNode(cardParent,{"Panel_Card_"..(j-1),"Image_Ship"}):setVisible(false)
           else
              UIHelper.getNode(cardParent,{"Panel_Card_"..(j-1),"Image_isBanker"}):setVisible(false)
              UIHelper.getNode(cardParent,{"Panel_Card_"..(j-1),"Image_Ship"}):setVisible(true)
              UIHelper.getNode(cardParent,{"Panel_Card_"..(j-1),"Image_Ship","Text_Ship"}):setString(itemUser.played)
           end

           if itemUser.value<6+rule then
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
                 multstr = "niuniu_mult_red_5.png"
              elseif itemUser.value == 14 then
                 multstr = "niuniu_mult_red_6.png"
              elseif itemUser.value == 15 then
                 multstr = "niuniu_mult_red_7.png"
              elseif itemUser.value == 16 then
                 multstr = "niuniu_mult_red_8.png"
              elseif itemUser.value == 17 then
                 multstr = "niuniu_mult_red_10.png"
              end

              if multstr ~= "" then
                 cardMult:loadTexture(multstr,ccui.TextureResType.plistType)
                 cardMult:setVisible(true)
              end
           end
       end
       --endregion
       local selfIndex = 0
       selfIndex = j
       cell:setContentSize(cell:getContentSize().width,60)
       cardParent:setVisible(false)
       Image_Drop:runAction(cc.Sequence:create(cc.RotateTo:create(0.1,-90)))
       textParent:setPositionY(textParent:getPositionY()-cardParent:getContentSize().height)
       UIHelper.BindClickByButton(Button_Drop,function(sender,event)
          if cardParent:isVisible() == true then
             cardParent:setVisible(false)
             cell:setContentSize(cell:getContentSize().width,60)
             Image_Drop:runAction(cc.Sequence:create(cc.RotateTo:create(0.1,-90)))
             textParent:setPositionY(textParent:getPositionY()-cardParent:getContentSize().height)
          else
             cardParent:setVisible(true)
             cell:setContentSize(cell:getContentSize().width,159)
             Image_Drop:runAction(cc.Sequence:create(cc.RotateTo:create(0.1,0)))
             textParent:setPositionY(textParent:getPositionY()+cardParent:getContentSize().height)
          end 
          local btn = sender 
          self.Panel_RecordDetailed.ListView_Content:requestDoLayout()

       end)

       self.Panel_RecordDetailed.ListView_Content:pushBackCustomItem(cell)
   end
   
end

function LayerResultRecord:setResultData(parent,data,roomOwner,cellP)
   local userContents = data
   local minUser = ""
   local maxUser = ""
   local minUserpoint = 0
   local maxUserpoint = 0
   local havesameMin = false
   local havesameMax = false
   for i = 1, #userContents do
       if userContents[i].totalScore>maxUserpoint then
          maxUserpoint = userContents[i].totalScore
          maxUser = userContents[i].username
          if havesameMax == true then
             havesameMax = false
          end
       end

       if userContents[i].totalScore< minUserpoint then
          minUserpoint = userContents[i].totalScore
          minUser = userContents[i].username
          if havesameMin == true then
             havesameMin = false
          end
       end

       if userContents[i].totalScore ==  maxUserpoint and  maxUser ~= userContents[i].username then
          havesameMax = true
       end

       if userContents[i].totalScore ==  minUserpoint and minUser ~= userContents[i].username then
          havesameMin = true
       end
   end
   

   for i = 1, #userContents do
       local cell = self.ResultItemCell:clone()
       local head = cell:getChildByName("Image_Head")
       local userNameText = cell:getChildByName("Text_UserName")
       local idText = cell:getChildByName("Text_ID")
       local pointText = cell:getChildByName("Text_Point")
       local leftMark = cell:getChildByName("Image_LeftMark")
       local rightMark = cell:getChildByName("Image_RightMark")
       --todo 头像
       UIHelper.loadImgUrl(head,userContents[i].head,userContents[i].username)
       userNameText:setString(userContents[i].name)
       idText:setString(userContents[i].username)


--       if userContents[i].totalScore>0 then
--                  pointText:setString("+"..userContents[i].totalScore):setTextColor(cc.c4b(255,0,0,255))
--       elseif userContents[i].totalScore<0 then 
--                  pointText:setString(userContents[i].totalScore):setTextColor(cc.c4b(0,128,0,255))
--       else
--                  pointText:setString(userContents[i].totalScore):setTextColor(cc.c4b(122,62,30,255))
--       end 


       if userContents[i].totalScore>0 then
          pointText:setString("+"..userContents[i].totalScore)
       else
          pointText:setString(userContents[i].totalScore)
       end
 
       if roomOwner == userContents[i].username then
          leftMark:setVisible(true)
       else
          leftMark:setVisible(false)
       end

       rightMark:setVisible(false)
       if havesameMax == false and maxUser == userContents[i].username then
          rightMark:setVisible(true)
          rightMark:loadTexture("image_winnermark.png",ccui.TextureResType.plistType)
       end 
       if havesameMin == false and minUser == userContents[i].username then
          rightMark:setVisible(true)
          rightMark:loadTexture("image_tuhaomark.png",ccui.TextureResType.plistType)
       end
       --148 244.5 404.5 244.5 661 244.5
       --148 87    404.5 87    661 87
       local x_cell = (i-1)%3
       local y_cell, t2 = math.modf((i-1)/3)
       cell:setPositionX(148+256.5*x_cell)
       cell:setPositionY(cellP - 157.5*y_cell)
       parent:addChild(cell)
   end
   
end

return LayerResultRecord

--endregion
