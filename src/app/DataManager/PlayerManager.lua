-- User: liuy
-- Date: 16/04/08
require('app.Commnucation.MessageManager')

local PlayerManager = PlayerManager or { }
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
PlayerManager.Player=nil


function PlayerManager.ProcessMsg(msgid,strHex)
     if msgid == Enum.LOGIN_CLIENT then
        local cmsg = hall_pb.LoginResponse()
        cmsg:ParseFromString(strHex)
        PlayerManager.Player = {}
        PlayerManager.Player.userName = cmsg.userName
        PlayerManager.Player.lastLoginIP = cmsg.lastLoginIP
        PlayerManager.Player.head = cmsg.head
        PlayerManager.Player.parent = cmsg.parent
        PlayerManager.Player.name = cmsg.name
        PlayerManager.Player.money = cmsg.money
        PlayerManager.Player.sex = cmsg.sex
        PlayerManager.Player.inviteCode = cmsg.inviteCode
        PlayerManager.Player.gold = cmsg.gold
        PlayerManager.Player.days = cmsg.days --//
        PlayerManager.Player.reward = cmsg.reward --//
        PlayerManager.Player.benefit = cmsg.benefit --//
        PlayerManager.Player.totalGames = cmsg.totalGames --//
        PlayerManager.Player.area = cmsg.area --//
        PlayerManager.Player.createDate = cmsg.createDate --//

        GlobalData.CreateRoomSetData = {}
        for i = 1, #cmsg.rooms do
            local roomItem = {}
            roomItem.gameType = cmsg.rooms[i].gameType
            roomItem.status = cmsg.rooms[i].status
            roomItem.baseScore = {}
            for j = 1, #cmsg.rooms[i].baseScore do
                local baseScore = cmsg.rooms[i].baseScore[j]
                table.insert(roomItem.baseScore,baseScore)
            end

            roomItem.totalRound = {}
            for k = 1, #cmsg.rooms[i].totalRound do
                local totalRound = #cmsg.rooms[i].totalRound[k]
                table.insert(roomItem.totalRound,totalRound)
            end

            roomItem.payType = {}
            for l = 1, # cmsg.rooms[i].payType do
                local payType = #cmsg.rooms[i].payType[l]
                table.insert(roomItem.payType,payType)
            end

            roomItem.getBankerScore = {}
            for m = 1, # cmsg.rooms[i].getBankerScore do
                local getBankerScore = #cmsg.rooms[i].getBankerScore[m]
                table.insert(roomItem.getBankerScore,getBankerScore)
            end

            roomItem.maxGetBankerScore = {}
             for n = 1, # cmsg.rooms[i].maxGetBankerScore do
                local maxGetBankerScore = #cmsg.rooms[i].maxGetBankerScore[n]
                table.insert(roomItem.maxGetBankerScore,maxGetBankerScore)
            end

            roomItem.doubleBull = cmsg.rooms[i].doubleBull
            roomItem.straightBull = cmsg.rooms[i].straightBull
            roomItem.spottedBull = cmsg.rooms[i].spottedBull
            roomItem.suitBull = cmsg.rooms[i].suitBull
            roomItem.threetwoBull = cmsg.rooms[i].threetwoBull
            roomItem.bombBull = cmsg.rooms[i].bombBull
            roomItem.smallBull = cmsg.rooms[i].smallBull
            roomItem.playerPush = cmsg.rooms[i].playerPush
            roomItem.startedInto = cmsg.rooms[i].startedInto
            roomItem.disableTouchCard = cmsg.rooms[i].disableTouchCard

            table.insert(GlobalData.CreateRoomSetData,roomItem)
        end



        PlayerManager.Player.shop = cmsg.shop
        PlayerManager.Player.ratio = cmsg.ratio
    elseif msgid == Enum.USER_INFO_CLIENT then
        local cmsg = hall_pb.UserInfoResponse()
        cmsg:ParseFromString(strHex)
        PlayerManager.Player.userName = cmsg.userName
        PlayerManager.Player.lastLoginIP = cmsg.lastLoginIP
        PlayerManager.Player.head = cmsg.head
        PlayerManager.Player.parent = cmsg.parent
        PlayerManager.Player.name = cmsg.name
        PlayerManager.Player.money = cmsg.money
        PlayerManager.Player.sex = cmsg.sex
        PlayerManager.Player.inviteCode = cmsg.inviteCode
        PlayerManager.Player.gold = cmsg.gold
        PlayerManager.Player.days = cmsg.days --//
        PlayerManager.Player.reward = cmsg.reward --//
        PlayerManager.Player.benefit = cmsg.benefit --//
        PlayerManager.Player.totalGames = cmsg.totalGames --//
        PlayerManager.Player.area = cmsg.area --//
        PlayerManager.Player.createDate = cmsg.createDate --//
    end
end


function PlayerManager.getInfo()
    WaitProgress.Show()
end

cc.exports.PlayerManager=PlayerManager
return PlayerManager

--endregion