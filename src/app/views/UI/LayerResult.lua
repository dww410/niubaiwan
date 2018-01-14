--region LayerResult.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 结算详情
--create by niyinguo
--Date: 2017/06/21

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
local platformMethod = require('app.Platform.platformMethod')

local LayerResult = class("LayerResult", require("app.views.UI.PopUI"))

function LayerResult:ctor()
    LayerResult.super.ctor(self)
    self:BindNodes(self.WidgetNode,
    "Panel_1.Button_Close",
    "Panel_1.Button_Quit",
    "Panel_1.Button_Share",
    "Panel_1.Image_Bg.Image_StaticItemBg_0",
    "Panel_1.Image_Bg.Image_StaticItemBg_1",
    "Panel_1.Image_Bg.Image_StaticItemBg_2",
    "Panel_1.Image_Bg.Image_StaticItemBg_3",
    "Panel_1.Image_Bg.Image_StaticItemBg_4",
    "Panel_1.Image_Bg.Image_StaticItemBg_5",
    "Panel_1.Image_Bg.Image_StaticItemBg_0.RecodeItem_0",
    "Panel_1.Image_Bg.Image_StaticItemBg_1.RecodeItem_1",
    "Panel_1.Image_Bg.Image_StaticItemBg_2.RecodeItem_2",
    "Panel_1.Image_Bg.Image_StaticItemBg_3.RecodeItem_3",
    "Panel_1.Image_Bg.Image_StaticItemBg_4.RecodeItem_4",
    "Panel_1.Image_Bg.Image_StaticItemBg_5.RecodeItem_5",
    "Panel_1.Image_Bg.Text_RoomNum",
    "Panel_1.Image_Bg.Text_RoundNum",
    "Panel_1.Image_Bg.Text_BaseScore",
    "Panel_1.Image_Bg.Text_GameType",
    "Panel_1.Image_Bg.Text_GameTime"
    )

    self:initEvent()
    self:initItem()
end

function LayerResult:initItem()
    for i = 1, 6 do
       self["RecodeItem_"..(i-1)]:getChildByName("Image_Head"):setVisible(false)
       self["RecodeItem_"..(i-1)]:getChildByName("Text_UserName"):setString("")
       self["RecodeItem_"..(i-1)]:getChildByName("Text_ID"):setString("")
       self["RecodeItem_"..(i-1)]:getChildByName("Text_Point"):setString("")
       self["RecodeItem_"..(i-1)]:getChildByName("Image_LeftMark"):setVisible(false)
       self["RecodeItem_"..(i-1)]:getChildByName("Image_RightMark"):setVisible(false)
       self["RecodeItem_"..(i-1)]:setVisible(false)
    end
    
end

function LayerResult:setData(userContents,roomNum,totalRound,baseScore,gameType)

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



   self.Text_RoomNum:setString("房号:"..roomNum)


   self.Text_RoundNum:setVisible(true)
   self.Text_BaseScore:setVisible(true)
   self.Text_GameType:setVisible(true)
   self.Text_GameTime:setVisible(true)


    if gameType == 6 then
        self.Text_RoundNum:setVisible(false)
    end

    

   self.Text_RoundNum:setString("局数:"..totalRound)

   

   if gameType~=5 then
        self.Text_BaseScore:setString("底分:"..baseScore.."/".. baseScore*2)
    else
        self.Text_BaseScore:setString("底分:"..baseScore)
    end

    

   self.Text_GameType:setString(GameType[gameType])
   self.Text_GameTime:setString(os.date("%Y/%M/%M %H:%M"))
   


    for i = 1, #userContents do
       self["RecodeItem_"..(i-1)]:getChildByName("Image_Head"):setVisible(true)
       UIHelper.loadImgUrl(self["RecodeItem_"..(i-1)]:getChildByName("Image_Head"),userContents[i].head,userContents[i].username)
       local name = userContents[i].name
       if Tool.SubStringGetTotalIndex(name)>4 then
             name=Tool.SubStringUTF8(name, 0, 4)..".."
       end
       self["RecodeItem_"..(i-1)]:getChildByName("Text_UserName"):setString(name)
       self["RecodeItem_"..(i-1)]:getChildByName("Text_ID"):setString(userContents[i].username)

       if userContents[i].totalScore>0 then
               self["RecodeItem_"..(i-1)]:getChildByName("Text_Point"):setString(userContents[i].totalScore):setTextColor(cc.c4b(255,0,0,255))
       elseif userContents[i].totalScore<0 then 
               self["RecodeItem_"..(i-1)]:getChildByName("Text_Point"):setString(userContents[i].totalScore):setTextColor(cc.c4b(0,128,0,255))
       else
               self["RecodeItem_"..(i-1)]:getChildByName("Text_Point"):setString(userContents[i].totalScore):setTextColor(cc.c4b(122,62,30,255))
       end
       



       self["RecodeItem_"..(i-1)]:getChildByName("Image_LeftMark"):setVisible(false)
       if FightManager.roomdata.roomOwner == userContents[i].username then
          self["RecodeItem_"..(i-1)]:getChildByName("Image_LeftMark"):setVisible(true)
       else
          self["RecodeItem_"..(i-1)]:getChildByName("Image_LeftMark"):setVisible(false)
       end

       self["RecodeItem_"..(i-1)]:getChildByName("Image_RightMark"):setVisible(false)
       if havesameMax == false and maxUser == userContents[i].username then
           self["RecodeItem_"..(i-1)]:getChildByName("Image_RightMark"):setVisible(true)
           self["RecodeItem_"..(i-1)]:getChildByName("Image_RightMark"):loadTexture("image_winnermark.png",ccui.TextureResType.plistType)
       end 
       if havesameMin == false and minUser == userContents[i].username then
           self["RecodeItem_"..(i-1)]:getChildByName("Image_RightMark"):setVisible(true)
           self["RecodeItem_"..(i-1)]:getChildByName("Image_RightMark"):loadTexture("image_tuhaomark.png",ccui.TextureResType.plistType)
       end

       self["RecodeItem_"..(i-1)]:setVisible(true)
    end
end

function LayerResult:initEvent()
     UIHelper.BindClickByButtons({self.Button_Close,self.Button_Quit,self.Button_Share}, function(sender, event)
        if sender == self.Button_Share then
            local fileName = cc.FileUtils:getInstance():getWritablePath().."printScreen.png"  
               -- 截屏  
            cc.utils:captureScreen(function(succeed, outputFile)  
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
                        else
                                if sutat==0 then
                                MessageTip.Show("微信分享成功")
                                else
                                MessageTip.Show("微信分享失败")
                                end
                        end
                                -- 移除纹理缓存  
                        cc.Director:getInstance():getTextureCache():removeTextureForKey(fileName)  
--                        self:removeChildByTag(1001)   
                    end
                    platformMethod.weichatfenxiang(GAME_URL.downLoadUrl.."?RoomNum=0",APP_INFO.appname.."（仿真实战·手感搓牌）","激情斗牛，约上好友，明牌抢庄，炸弹带五花。大家都在玩，就等你了【点我下载】",outputFile,0,PayStuate,2)
                else
                    MessageTip.Show("截屏失败")  
                end
            end,  fileName)
        else
            local pScene=require("app.views.Scenes.MainScene.MainScene"):new()
            cc.Director:getInstance():replaceScene(pScene)
        end
    end )

end

function LayerResult:getWidget()
    return "PopUIs/LayerResult.csb"
end
function LayerResult:onEnter()
    self.super.onEnter(self)
end

function LayerResult:onExit()
    self.super.onExit(self)
end

return LayerResult

--endregion
