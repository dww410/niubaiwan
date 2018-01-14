--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

--加入房间
--create by niyinguo
--Date: 17/06/02
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerJoinGame = class("LayerJoinGame", require("app.views.UI.PopUI"))

function LayerJoinGame:ctor()
    LayerJoinGame.super.ctor(self)
    self:BindNodes(self.WidgetNode,"Node",
    "Node.Panel_2.Image_4_0.RoomNumText_0",
    "Node.Panel_2.Image_4_1.RoomNumText_1",
    "Node.Panel_2.Image_4_2.RoomNumText_2",
    "Node.Panel_2.Image_4_3.RoomNumText_3",
    "Node.Panel_2.Image_4_4.RoomNumText_4",
    "Node.Panel_2.Image_4_5.RoomNumText_5",
    "Node.Panel_2.Button_Close",
    "Node.Panel_2.Button_Join",
    "Node.Panel_2.Button_CS",
    "Node.Panel_2.Button_SC",
    "Node.Panel_2.Button_0",
    "Node.Panel_2.Button_1",
    "Node.Panel_2.Button_2",
    "Node.Panel_2.Button_3",
    "Node.Panel_2.Button_4",
    "Node.Panel_2.Button_5",
    "Node.Panel_2.Button_6",
    "Node.Panel_2.Button_7",
    "Node.Panel_2.Button_8",
    "Node.Panel_2.Button_9")

    for i = 1, 6 do
       self["RoomNumText_"..i-1]:setString("")
    end
    self.numIndex = 0
    self:initEvent()
end

function LayerJoinGame:initEvent()
   UIHelper.BindClickByButtons({self.Button_Close,self.Button_Join,self.Button_CS,self.Button_SC},function(sender,event)
      if sender == self.Button_Close then
         self:Close()
      elseif sender == self.Button_Join then
          local variable = self:checkRoomNum()
          print(variable)
          if variable ~= "" then
            PauseStateToLua2 = function(sutat)
                if sutat==1 then
                    print("连接 普通场 成功-1")
                    WaitProgress.Show()
                    FightManager.GameRoomtype=1
                    local smsg = game_pb.IntoRequest()
                    smsg.username = PlayerManager.Player.userName -- 1; //用户名
                    smsg.roomNo = tonumber(variable) --2;  //房间号
                    local msgData = smsg:SerializeToString()
                    MSG.send(Enum.INTO_ROOM_SERVER,msgData,2)
                    GlobalData.isServer2connect=true
                else
                    print("连接 普通场 失败-1")
                end
                PauseStateToLua2= function() print('PauseStateToLua2') end
            end
            -- 设置远端服务器
            Socket_SetServer( SERVER_NETGATE.ip2, SERVER_NETGATE.port2,2)
            -- 连接服务器
            Socket_Reconnect(2)
          end
      elseif sender == self.Button_CS then
         for i = 1, 6 do
            self["RoomNumText_"..i-1]:setString("")
         end
          self.numIndex = 0
      elseif sender == self.Button_SC then
          if self.numIndex == 0 then
             self.numIndex = 1
          end
          self["RoomNumText_"..self.numIndex-1]:setString("")
          self.numIndex = self.numIndex - 1
          if self.numIndex<=0 then
             self.numIndex = 0
          end
      end
   end)

   UIHelper.BindClickByButtons({self.Button_0,self.Button_1,self.Button_2,self.Button_3,self.Button_4,self.Button_5,self.Button_6,self.Button_7,self.Button_8,self.Button_9},function(sender,event)
       if  self.numIndex<6 then
          local btnName=sender:getName()
          local strTab = Tool.splistStr(btnName,"_")
          self["RoomNumText_"..self.numIndex]:setString(strTab[2])
          self.numIndex = self.numIndex +1
          if self.numIndex>=6 then
             self.numIndex = 6
          end
       end
   end)
end

function LayerJoinGame:checkRoomNum()
    local roomNum = ""
    for i = 1, 6 do
        if self["RoomNumText_"..i-1]:getString() == "" then
            roomNum = ""
            break
        end
        roomNum = roomNum..self["RoomNumText_"..i-1]:getString()
    end
    return roomNum
end

function LayerJoinGame:getWidget()
    return "PopUIs/LayerJoinGame.csb"
end

function LayerJoinGame:onEnter()
   self.super.onEnter() 
end

function LayerJoinGame:onExit()
    self.super.onExit(self)
end

return LayerJoinGame


--endregion
