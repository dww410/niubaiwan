-- User: CongQin
-- Date: 16/04/08

require('app.Commnucation.MessageManager')
local GlobalDataManager = GlobalDataManager or { }
local MessageTip = require('app.views.UI.MessageTip')
local WaitProgress = require('app.views.Controls.WaitProgress')
GlobalDataManager.account = 0

GlobalDataManager.sessionid = 0
GlobalDataManager.GameIp = 0
GlobalDataManager.GamePort = 0
GlobalDataManager.Notice={}
GlobalDataManager.popNotice = true
GlobalDataManager.GameRecord = {}
GlobalDataManager.GoldGameRecord = {}

GlobalDataManager.RecordOpenSignTime = -1
GlobalDataManager.RecordRoomSetdata = nil
GlobalDataManager.isShowQuit = false
GlobalDataManager.CreateRoomSetData = {}
GlobalDataManager.isServer1connect = false
GlobalDataManager.isServer2connect = false
GlobalDataManager.isServer3connect = false

function GlobalDataManager.ProcessMsg(msgid,strHex)
    if msgid==Enum.ERROR_CLIENT then
        local cmsg = hall_pb.ErrorResponse()
        cmsg:ParseFromString(strHex)
        
        if cmsg.errorCode==ErrorCode.ERROR_UNKNOWN then
            MessageTip.Show("未知错误")
        elseif cmsg.errorCode==ErrorCode.NO_FOUND then
            MessageTip.Show("数据不存在")
        elseif cmsg.errorCode==ErrorCode.SUCCESS then
            MessageTip.Show("处理成功")
        elseif cmsg.errorCode==ErrorCode.FAILURE then
            MessageTip.Show("处理失败")
        elseif cmsg.errorCode==ErrorCode.ERROR_DATA then
            MessageTip.Show("数据异常")
        elseif cmsg.errorCode==ErrorCode.AUTHENTICATION_FAILURE then
            MessageTip.Show("鉴权失败")
        elseif cmsg.errorCode==ErrorCode.ILLEGAL_ARGUMENT then
            MessageTip.Show("不合法参数")
        elseif cmsg.errorCode==ErrorCode.ERROR_DATA_NOT_FOUND then
            MessageTip.Show("相关数据没有找到")
        elseif cmsg.errorCode==ErrorCode.ERROR_ACCOUNT_LOCKED then
            MessageTip.Show("账户被禁用")
        elseif cmsg.errorCode==ErrorCode.ERROR_NO_LOGIN then
            MessageTip.Show("登录失败")
        elseif cmsg.errorCode==ErrorCode.ERROR_MONEY_NOT_ENOUGH then
            MessageTip.Show("余额不足")
        elseif cmsg.errorCode==ErrorCode.ERROR_NOT_ALLOW then
            MessageTip.Show("不允许的操作")
        elseif cmsg.errorCode==ErrorCode.ERROR_ACCOUNT_EXCEPTION then
            MessageTip.Show("账号异常")
        elseif cmsg.errorCode==ErrorCode.ERROR_MAINTENANCE then
            MessageTip.Show("服务器维护中")
        elseif cmsg.errorCode==ErrorCode.ERROR_INVITATIONMSG then
            MessageTip.Show("该邀请码已经使用")
        elseif cmsg.errorCode==ErrorCode.ERROR_INVITATIONONMSG then
            MessageTip.Show("已绑定邀请码")
        elseif cmsg.errorCode==ErrorCode.ERROR_ROOM_NOT_EXISTS then
            MessageTip.Show("房间不存在")
        elseif cmsg.errorCode==ErrorCode.ERROR_FULL then
            MessageTip.Show("房间人数已满")
        elseif cmsg.errorCode==ErrorCode.ERROR_DELETE_FREQUENT then
            MessageTip.Show("不能频繁解散")
        elseif cmsg.errorCode==ErrorCode.ERROR_USER_LITTLE then
            MessageTip.Show("人数太少，不能开始游戏")
        elseif cmsg.errorCode==ErrorCode.ERROR_ALREADY_STARTED then
            MessageTip.Show("游戏已经开始")
        elseif cmsg.errorCode==ErrorCode.ERROR_ALREADY_INGAME then
            MessageTip.Show("您已经在其它游戏中，先去结束游戏再来")
        elseif cmsg.errorCode==ErrorCode.ERROR_NOT_JOINGAME then
            MessageTip.Show("该房间游戏开始后禁止加入")
        elseif cmsg.errorCode==ErrorCode.ERROR_NOT_CODENOTFOUND then
            MessageTip.Show("邀请码不存在")
        end
        WaitProgress.Close()
    elseif msgid == Enum.NOTICE_CLIENT then
        GlobalDataManager.Notice = {}
        local cmsg = hall_pb.NoticeResponse()
        cmsg:ParseFromString(strHex)
        table.insert(GlobalDataManager.Notice,cmsg)
    elseif msgid == Enum.GAME_RECORD_CLIENT then
        GlobalDataManager.GameRecord = {}
        GlobalDataManager.GoldGameRecord = {}
        local msg = hall_pb.GameRecordResponse()
        msg:ParseFromString(strHex)
        for i = 1, #msg.gameRecord do
            local gameRecord = {}
            gameRecord.roomNo = msg.gameRecord[i].roomNo
            gameRecord.roomOwner = msg.gameRecord[i].roomOwner
            gameRecord.rule = msg.gameRecord[i].rule
            gameRecord.date = msg.gameRecord[i].date
            gameRecord.gameType = msg.gameRecord[i].gameType
            gameRecord.baseScore = msg.gameRecord[i].baseScore
            gameRecord.totalRound = msg.gameRecord[i].totalRound

            gameRecord.userContents = {}
            for j = 1, #msg.gameRecord[i].userContents do
                local userContent = {}
                userContent.name = msg.gameRecord[i].userContents[j].name
                userContent.head = msg.gameRecord[i].userContents[j].head
                userContent.username = msg.gameRecord[i].userContents[j].username
                userContent.totalScore = msg.gameRecord[i].userContents[j].totalScore
                table.insert(gameRecord.userContents,userContent)
            end

            gameRecord.gameItemContents = {}
            for j = 1, #msg.gameRecord[i].gameItemContents do
                local gameItemContent = {}
                for k = 1, #msg.gameRecord[i].gameItemContents[j].itemUsers do
                    local itemUser = {}
                    itemUser.username = msg.gameRecord[i].gameItemContents[j].itemUsers[k].username
                    itemUser.win = msg.gameRecord[i].gameItemContents[j].itemUsers[k].win
                    itemUser.cards = msg.gameRecord[i].gameItemContents[j].itemUsers[k].cards
                    itemUser.value = msg.gameRecord[i].gameItemContents[j].itemUsers[k].value
                    itemUser.played = msg.gameRecord[i].gameItemContents[j].itemUsers[k].played
                    itemUser.isBanker = msg.gameRecord[i].gameItemContents[j].itemUsers[k].isBanker
                    table.insert(gameItemContent,itemUser)
                end
                table.insert( gameRecord.gameItemContents,gameItemContent)
            end
            if gameRecord.gameType == 6 then
                table.insert(GlobalDataManager.GoldGameRecord,gameRecord)
            else
                table.insert(GlobalDataManager.GameRecord,gameRecord)
            end
        end
    end
end

function GlobalDataManager.GetRoomData()
      GlobalData.RecordRoomSetdata = {}
      GlobalData.RecordRoomSetdata.gameType             = cc.UserDefault:getInstance():getIntegerForKey("createRoomGameType",4)                  --;//游戏类型1.2.3.4.5
      GlobalData.RecordRoomSetdata.baseScore            = cc.UserDefault:getInstance():getIntegerForKey("createRoomBaseScore",1)                 --; //底分 1.2.3
      GlobalData.RecordRoomSetdata.count                = cc.UserDefault:getInstance():getIntegerForKey("createRoomCount",10)                    --; //局数10/20
      GlobalData.RecordRoomSetdata.payType              = cc.UserDefault:getInstance():getIntegerForKey("createRoomPayType",1)                   --; //支付方式1/2
      GlobalData.RecordRoomSetdata.rule                 = cc.UserDefault:getInstance():getIntegerForKey("createRoomRule",1)                      --; //规则1/2
      GlobalData.RecordRoomSetdata.getBankerScore       = cc.UserDefault:getInstance():getIntegerForKey("createRoomgetBankerScore",0)            --; //上庄分数
      GlobalData.RecordRoomSetdata.maxGetBankerScore    = cc.UserDefault:getInstance():getIntegerForKey("createRoommaxGetBankerScore",4)         --; //最大抢庄
      GlobalData.RecordRoomSetdata.doubleBull           = cc.UserDefault:getInstance():getBoolForKey("createRoomdoubleBull",false)               --; //对子牛
      GlobalData.RecordRoomSetdata.straightBull          = cc.UserDefault:getInstance():getBoolForKey("createRoomstraightBull",true)               --; //顺子牛
      GlobalData.RecordRoomSetdata.spottedBull          = cc.UserDefault:getInstance():getBoolForKey("createRoomspottedBull",true)               --; //五花牛
      GlobalData.RecordRoomSetdata.suitBull          = cc.UserDefault:getInstance():getBoolForKey("createRoomsuitBull",true)                     --; //同花牛
      GlobalData.RecordRoomSetdata.threetwoBull          = cc.UserDefault:getInstance():getBoolForKey("createRoomthreetwoBull",true)                     --; //
      GlobalData.RecordRoomSetdata.bombBull             = cc.UserDefault:getInstance():getBoolForKey("createRoombombBull",true)                  --; //炸弹牛
      GlobalData.RecordRoomSetdata.smallBull            = cc.UserDefault:getInstance():getBoolForKey("createRoomsmallBull",true)                 --; //五小牛
      GlobalData.RecordRoomSetdata.playerPush           = cc.UserDefault:getInstance():getBoolForKey("createRoomplayerPush",true)                --; //闲家推注
      GlobalData.RecordRoomSetdata.startedInto          = cc.UserDefault:getInstance():getBoolForKey("createRoomstartedInto",false)              --; //游戏开始后加入
      GlobalData.RecordRoomSetdata.disableTouchCard     = cc.UserDefault:getInstance():getBoolForKey("createRoomdisableTouchCard",false)         --; //禁止搓牌
end
function GlobalDataManager.SetRoomData()
      cc.UserDefault:getInstance():setIntegerForKey("createRoomGameType",GlobalData.RecordRoomSetdata.gameType)                                  --;//游戏类型1.2.3.4.5
      cc.UserDefault:getInstance():setIntegerForKey("createRoomBaseScore",self.roomData.baseScore)                                --; //低分 1.2.3
      cc.UserDefault:getInstance():setIntegerForKey("createRoomCount",GlobalData.RecordRoomSetdata.count)                                        --; //局数10/20
      cc.UserDefault:getInstance():setIntegerForKey("createRoomPayType",GlobalData.RecordRoomSetdata.payType)                                    --; //支付方式1/2
      cc.UserDefault:getInstance():setIntegerForKey("createRoomRule",GlobalData.RecordRoomSetdata.rule)                                          --; //规则1/2
      cc.UserDefault:getInstance():setIntegerForKey("createRoomgetBankerScore",GlobalData.RecordRoomSetdata.getBankerScore)                      --; //上庄分数
      cc.UserDefault:getInstance():setIntegerForKey("createRoommaxGetBankerScore",GlobalData.RecordRoomSetdata.maxGetBankerScore)                --; //最大抢庄
      cc.UserDefault:getInstance():setBoolForKey("createRoomdoubleBull",GlobalData.RecordRoomSetdata.doubleBull)                                 --; //对子牛
      cc.UserDefault:getInstance():setBoolForKey("createRoomstraightBull",GlobalData.RecordRoomSetdata.straightBull)                               --; //五花
      cc.UserDefault:getInstance():setBoolForKey("createRoomspottedBull",GlobalData.RecordRoomSetdata.spottedBull)                               --; //五花
      cc.UserDefault:getInstance():setBoolForKey("createRoomsuitBull",GlobalData.RecordRoomSetdata.suitBull)                               --; //五花
      cc.UserDefault:getInstance():setBoolForKey("createRoomthreetwoBull",GlobalData.RecordRoomSetdata.threetwoBull)                               --; //五花
      cc.UserDefault:getInstance():setBoolForKey("createRoombombBull",GlobalData.RecordRoomSetdata.bombBull)                                     --; //炸弹牛
      cc.UserDefault:getInstance():setBoolForKey("createRoomsmallBull",GlobalData.RecordRoomSetdata.smallBull)                                   --; //五小牛
      cc.UserDefault:getInstance():setBoolForKey("createRoomplayerPush",GlobalData.RecordRoomSetdata.playerPush)                                 --; //闲家推注
      cc.UserDefault:getInstance():setBoolForKey("createRoomstartedInto",GlobalData.RecordRoomSetdata.startedInto)                               --; //游戏开始后加入
      cc.UserDefault:getInstance():setBoolForKey("createRoomdisableTouchCard",GlobalData.RecordRoomSetdata.disableTouchCard)                     --; //禁止搓牌
end
cc.exports.GlobalData=GlobalDataManager
return GlobalDataManager
