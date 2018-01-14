--region LayerInvitation.lua
--Date
--此文件由[BabeLua]插件自动生成

--功能: 绑定邀请码
--create by niyinguo
--Date: 2017/06/09

local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')

local LayerInvitation = class("LayerInvitation", require("app.views.UI.PopUI"))

function LayerInvitation:ctor()
    LayerInvitation.super.ctor(self)

    self:BindNodes(self.WidgetNode,"Panel_1",
    "Panel_1.Button_Close",
    "Panel_1.Button_Return",
    "Panel_1.Button_Bind",
    "Panel_1.Image_4.TextField_1")

    self.inviteCode = ""

    if PlayerManager.Player.inviteCode~= nil and string.len(PlayerManager.Player.inviteCode)>1 then
        self.TextField_1:setString(PlayerManager.Player.inviteCode)
        self.TextField_1:setEnabled(false)
        self.Button_Bind:setEnabled(false)
    end

    UIHelper.BindClickByButton(self.Button_Close,function(sender,event)
        self:Close()
    end)

    UIHelper.BindClickByButton(self.Button_Return,function(sender,event)
       self:Close()
    end)

    UIHelper.BindClickByButton(self.Button_Bind,function(sender,event)
        if string.len(self.TextField_1:getString())<1 then
            MessageTip.Show("邀请码不正确")
            return 
        end
            local msg = hall_pb.InviteRequest()
            self.inviteCode = self.TextField_1:getString()
            msg.inviteCode = self.inviteCode
            local msgData = msg:SerializeToString()
            MSG.send(Enum.INVITE_SERVER,msgData,1)
            WaitProgress.Show()
       
    end)

end

function LayerInvitation:getWidget()
    return "PopUIs/LayerInvitation.csb"
end
function LayerInvitation:onEnter()
    self.super.onEnter(self)
    
      MessageHandle.addHandle(Enum.INVITE_CLIENT, function(msg,data)
         PlayerManager.Player.inviteCode =  self.inviteCode
          self:Close()
          WaitProgress.Close()
      end,self)
end

function LayerInvitation:onExit()
    self.super.onExit(self)
    MessageHandle.removeHandle(self)
end

return LayerInvitation

--endregion
