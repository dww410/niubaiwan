-- User: CongQin
-- Date: 16/04/08
local DataManager=DataManager or {}
local manager={              
    require('app.DataManager.PlayerManager'),
    require('app.DataManager.FightManager'),
    require('app.DataManager.UnionManager'),
    require('app.DataManager.GlobalDataManager'),
    require('app.DataManager.SystemDataManager'),
    require('app.DataManager.ServiceMessageManager'),
}
DataManager.schedulerID = nil

function DataManager.ProcessMsg(msgid,strHex)
    if strHex==nil then
        printError("ProcessMsg nil")
        return
    end
	table.foreach(manager,function(k,v) 
		if type(v.ProcessMsg)=='function' then
            v.ProcessMsg(msgid, strHex ,timeStamp)
		end
	end)
    if msgid == Enum.HEART_CLIENT then
        DataManager.sendHeart()
    elseif msgid == Enum.RECHARGE_PAY_CLIENT then
         local cmsg = hall_pb.ReChargeWeChatResponse()
         cmsg:ParseFromString(strHex)
         ServiceMessageManager.SendWeChatPay(cmsg.prepayid,cmsg.noncestr,cmsg.sign,cmsg.orderid)
    elseif msgid == Enum.RECHARGE_PAY_RESUILT_CLIENT then
        local cmsg = hall_pb.ReChargeWeChatResultResponse()
        cmsg:ParseFromString(strHex)
        if cmsg.isSucess then
            PlayerManager.Player.money = cmsg.gold
        end
    end
end


function DataManager.sendHeart()
    local time=10
    DataManager.schedulerID = cc.Director:getInstance():getScheduler():scheduleScriptFunc(handler(self,function(dt)
        time=time-1
        if time<=0 and DataManager.schedulerID~=nil then
            cc.Director:getInstance():getScheduler():unscheduleScriptEntry(DataManager.schedulerID)
            DataManager.schedulerID=nil
            MSG.send(Enum.HEART_SERVER,"",1)
            --print("GlobalDataManager.sendHeart countdown:"..time)
        end
    end),1,false)
end


return DataManager
