-- User: liuy
-- Date: 16/04/08
require('app.Commnucation.MessageManager')
local FightManager = FightManager or {}
FightManager.roomdata = {}
FightManager.resoutdata = {}
FightManager.bipaidata = {}
FightManager.vipInfo = {}
FightManager.GameRoomtype = 0
function FightManager.ProcessMsg(msgid, strHex)
    print("########################game room type:" .. FightManager.GameRoomtype .. ",msgid :" .. msgid)
    if FightManager.GameRoomtype == 1 then    --//房卡模式
        if msgid == Enum.INTO_ROOM_CLIENT then
            local cmsg = game_pb.IntoResponse()
            cmsg:ParseFromString(strHex)
            FightManager.roomdata = {}
            FightManager.roomdata.roomNo = cmsg.roomNo --1; //
            FightManager.roomdata.roomOwner = cmsg.roomOwner --2; //
            FightManager.roomdata.banker = cmsg.banker --3; //
            FightManager.roomdata.seats = {} --4; //
            FightManager.roomdata.status = cmsg.status --5; //
            FightManager.roomdata.gameType = cmsg.gameType --6; //
            FightManager.roomdata.baseScore = cmsg.baseScore --7; //
            FightManager.roomdata.totalRound = cmsg.totalRound --8; //
            FightManager.roomdata.round = cmsg.round --9; //
            FightManager.roomdata.payType = cmsg.payType --10; //
            FightManager.roomdata.rule = cmsg.rule --11; //
            FightManager.roomdata.getBankerScore = cmsg.getBankerScore --12; //
            FightManager.roomdata.maxGetBankerScore = cmsg.maxGetBankerScore --13; //
            FightManager.roomdata.doubleBull = cmsg.doubleBull --14; //对子牛
            FightManager.roomdata.straightBull = cmsg.straightBull --15; //顺子牛
            FightManager.roomdata.spottedBull = cmsg.spottedBull --15; //五花牛
            FightManager.roomdata.suitBull = cmsg.suitBull --15; //同花牛
            FightManager.roomdata.threetwoBull = cmsg.threetwoBull --15; //
            FightManager.roomdata.bombBull = cmsg.bombBull --16; //
            FightManager.roomdata.smallBull = cmsg.smallBull --17; //
            FightManager.roomdata.playerPush = cmsg.playerPush --18; //
            FightManager.roomdata.startedInto = cmsg.startedInto --18; //
            FightManager.roomdata.disableTouchCard = cmsg.disableTouchCard --18; //
            for i = 1, #cmsg.seats do

                local data = {}
                data.seatNo = cmsg.seats[i].seatNo --1; //
                data.userName = cmsg.seats[i].userName --2; //
                data.name = cmsg.seats[i].name --3; //
                data.headPic = cmsg.seats[i].headPic --4; //
                data.gold = cmsg.seats[i].gold --5; //
                data.cards = {} --6; //
                data.grab = cmsg.seats[i].grab --7; //
                data.multiple = cmsg.seats[i].multiple --8; //
                data.ready = cmsg.seats[i].ready --9; //׼
                data.grabed = cmsg.seats[i].grabed --10; //
                data.opened = cmsg.seats[i].opened --11; //
                data.push = cmsg.seats[i].push --//
                data.totalGames = cmsg.seats[i].totalGames --//
                data.sex = cmsg.seats[i].sex --//
                data.lastLoginIP = cmsg.seats[i].lastLoginIP --//
                data.area = cmsg.seats[i].area --//
                data.createDate = cmsg.seats[i].createDate --//

                for a = 1, #cmsg.seats[i].cards do
                    local card = {}
                    card.cardColor = cmsg.seats[i].cards[a].cardColor
                    card.value = cmsg.seats[i].cards[a].value
                    table.insert(data.cards, card)
                end
                table.insert(FightManager.roomdata.seats, data)
            end
        elseif msgid == Enum.ADD_ROOM_CLIENT then --//

            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = game_pb.Seat()
            cmsg:ParseFromString(strHex)

            FightManager.roomdata.round = cmsg.round --//
            FightManager.roomdata.banker = cmsg.banker --//

            local data = {}
            data.seatNo = cmsg.seatNo --1; //
            data.userName = cmsg.userName --2; //
            data.name = cmsg.name --3; //
            data.headPic = cmsg.headPic --4; //
            data.gold = cmsg.gold --5; //
            data.cards = {} --6; //
            data.grab = cmsg.grab --7; //ׯ
            data.multiple = cmsg.multiple --8; //
            data.ready = cmsg.ready --9; //
            data.grabed = cmsg.grabed --10; //
            data.opened = cmsg.opened --11; //
            data.push = cmsg.push --//
            data.totalGames = cmsg.totalGames --//
            data.sex = cmsg.sex --//
            data.lastLoginIP = cmsg.lastLoginIP --//
            data.area = cmsg.area --//
            data.createDate = cmsg.createDate --//

            for a = 1, #cmsg.cards do
                local card = {}
                card.cardColor = cmsg.cards[a].cardColor
                card.value = cmsg.cards[a].value
                table.insert(data.cards, card)
            end
            table.insert(FightManager.roomdata.seats, data)
        elseif msgid == Enum.EXIT_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = game_pb.ExitResponse()
            cmsg:ParseFromString(strHex)
            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    table.removebyvalue(FightManager.roomdata.seats, FightManager.roomdata.seats[i])
                    break
                end
            end
        elseif msgid == Enum.READY_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = game_pb.ReadyResponse()
            cmsg:ParseFromString(strHex)

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    FightManager.roomdata.seats[i].ready = true
                end
            end
        elseif msgid == Enum.START_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end

            FightManager.roomdata.round = FightManager.roomdata.round + 1
            if FightManager.roomdata.gameType == 1 then
                FightManager.roomdata.status = 3 --//
            elseif FightManager.roomdata.gameType == 2 then
                FightManager.roomdata.status = 3 --//
            elseif FightManager.roomdata.gameType == 3 then
                FightManager.roomdata.status = 2 --//
            elseif FightManager.roomdata.gameType == 4 then
                FightManager.roomdata.status = 2 --//ׯ
            elseif FightManager.roomdata.gameType == 5 then
                FightManager.roomdata.status = 4 --//
            end


        elseif msgid == Enum.GRAB_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = game_pb.GrabResponse()
            cmsg:ParseFromString(strHex)

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    FightManager.roomdata.seats[i].grab = cmsg.grab
                    if cmsg.grab ~= nil and cmsg.grab > 0 then
                        FightManager.roomdata.seats[i].grabed = true
                    else
                        FightManager.roomdata.seats[i].grabed = false
                    end
                end
            end

        elseif msgid == Enum.SET_BANKER_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end


            local cmsg = game_pb.SetBankerResponse()
            cmsg:ParseFromString(strHex)

            FightManager.roomdata.banker = cmsg.seatNo --//

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    FightManager.roomdata.seats[i].grab = cmsg.grab
                    break
                end
            end
        elseif msgid == Enum.PLAY_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            FightManager.roomdata.status = 3
            local cmsg = game_pb.PlayResponse()
            cmsg:ParseFromString(strHex)

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then

                    FightManager.roomdata.seats[i].multiple = cmsg.playScore
                    break
                end
            end
        elseif msgid == Enum.DEAL_CARD_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                print("############### deal card room no is nil")
                return
            end


            local cmsg = game_pb.DealCardResponse()
            cmsg:ParseFromString(strHex)


            print("############ room seats:" .. #FightManager.roomdata.seats)
            for i = 1, #FightManager.roomdata.seats do --//
                if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then

                    --                    if FightManager.roomdata.gameType==4 and #FightManager.roomdata.seats[i].cards==4 then

                    --                    else
                    --                        FightManager.roomdata.seats[i].cards={}
                    --                    end

                    print("############ room seats cards size:" .. #cmsg.cards)
                    for a = 1, #cmsg.cards do
                        local card = {}
                        card.cardColor = cmsg.cards[a].cardColor
                        card.value = cmsg.cards[a].value
                        print("############## card value" .. cmsg.cards[a].value)
                        table.insert(FightManager.roomdata.seats[i].cards, card)
                    end

                    if #FightManager.roomdata.seats[i].cards == 5 then
                        FightManager.roomdata.status = 4
                    end
                    break
                end
            end

        elseif msgid == Enum.OPEN_CARD_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = game_pb.OpenCardResponse()
            cmsg:ParseFromString(strHex)

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].userName ~= PlayerManager.Player.userName and FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    for a = 1, #cmsg.cards do
                        local card = {}
                        card.cardColor = cmsg.cards[a].cardColor
                        card.value = cmsg.cards[a].value
                        table.insert(FightManager.roomdata.seats[i].cards, card)
                    end
                    break
                end
            end
        elseif msgid == Enum.RESULT_CLIENT then --//
            FightManager.roomdata.status = 5

            if FightManager.roomdata.roomNo == nil then
                return
            end


            local cmsg = game_pb.ResultResponse()
            cmsg:ParseFromString(strHex)
            FightManager.resoutdata = {}

            for i = 1, #cmsg.result do
                local result = {}
                result.seatNo = cmsg.result[i].seatNo --1; //
                result.score = cmsg.result[i].score --2; //
                result.cards = {} --3; //

                for a = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[a].seatNo == result.seatNo then
                        result.cards = FightManager.roomdata.seats[a].cards
                        result.sex = FightManager.roomdata.seats[a].sex
                        break
                    end
                end
                --                for a=1,#cmsg.result[i].cards do
                --                    local card={}
                --                    card.cardColor= cmsg.result[i].cards[a].cardColor
                --                    card.value= cmsg.result[i].cards[a].value
                --                    table.insert(result.cards,card)
                --                end

                result.value = cmsg.result[i].value --4; //
                --
                for b = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[b].seatNo == cmsg.result[i].seatNo then
                        FightManager.roomdata.seats[b].push = cmsg.result[i].push
                        FightManager.roomdata.seats[b].gold = FightManager.roomdata.seats[b].gold + cmsg.result[i].score
                        break
                    end
                end
                table.insert(FightManager.resoutdata, result)
            end
        end

    elseif FightManager.GameRoomtype == 2 then   --// 金币模式

        if msgid == Enum.INTO_ROOM_CLIENT then
            local cmsg = matching_pb.IntoResponse()
            cmsg:ParseFromString(strHex)
            FightManager.roomdata = {}
            FightManager.roomdata.roomNo = cmsg.roomNo --1; //
            FightManager.roomdata.banker = cmsg.banker --3; //
            FightManager.roomdata.seats = {} --4; //
            FightManager.roomdata.status = cmsg.status --5; //
            FightManager.roomdata.baseScore = cmsg.baseScore --7; //

            for i = 1, #cmsg.seats do
                local data = {}
                data.seatNo = cmsg.seats[i].seatNo --1; //
                data.userName = cmsg.seats[i].userName --2; //
                data.name = cmsg.seats[i].name --3; //
                data.headPic = cmsg.seats[i].headPic --4; //
                data.gold = cmsg.seats[i].gold --5; //
                data.cards = {} --6; //
                data.grab = cmsg.seats[i].grab --7; //
                data.multiple = cmsg.seats[i].multiple --8; //
                data.ready = cmsg.seats[i].ready --9; //
                data.grabed = cmsg.seats[i].grabed --10; //
                data.opened = cmsg.seats[i].opened --11; //
                data.totalGames = cmsg.seats[i].totalGames --//
                data.sex = cmsg.seats[i].sex --//
                data.lastLoginIP = cmsg.seats[i].lastLoginIP --//
                data.area = cmsg.seats[i].area --//
                data.createDate = cmsg.seats[i].createDate --//

                for a = 1, #cmsg.seats[i].cards do
                    local card = {}
                    card.cardColor = cmsg.seats[i].cards[a].cardColor
                    card.value = cmsg.seats[i].cards[a].value
                    table.insert(data.cards, card)
                end
                table.insert(FightManager.roomdata.seats, data)
            end
        elseif msgid == Enum.ADD_ROOM_CLIENT then --//

            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = matching_pb.Seat()
            cmsg:ParseFromString(strHex)
            local data = {}
            data.seatNo = cmsg.seatNo --1; //
            data.userName = cmsg.userName --2; //
            data.name = cmsg.name --3; //
            data.headPic = cmsg.headPic --4; //
            data.gold = cmsg.gold --5; //
            data.cards = {} --6; //
            data.grab = cmsg.grab --7; //
            data.multiple = cmsg.multiple --8; //
            data.ready = cmsg.ready --9; //
            data.grabed = cmsg.grabed --10; //
            data.opened = cmsg.opened --11; //
            data.totalGames = cmsg.totalGames --//
            data.sex = cmsg.sex --//
            data.lastLoginIP = cmsg.lastLoginIP --//
            data.area = cmsg.area --//
            data.createDate = cmsg.createDate --//

            for a = 1, #cmsg.cards do
                local card = {}
                card.cardColor = cmsg.cards[a].cardColor
                card.value = cmsg.cards[a].value
                table.insert(data.cards, card)
            end
            table.insert(FightManager.roomdata.seats, data)
        elseif msgid == Enum.EXIT_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = matching_pb.ExitResponse()
            cmsg:ParseFromString(strHex)
            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    table.removebyvalue(FightManager.roomdata.seats, FightManager.roomdata.seats[i])
                    break
                end
            end
        elseif msgid == Enum.READY_CLIENT then  --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = matching_pb.ReadyResponse()
            cmsg:ParseFromString(strHex)

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    FightManager.roomdata.seats[i].ready = true
                end
            end
        elseif msgid == Enum.START_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end


        elseif msgid == Enum.GRAB_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = matching_pb.GrabResponse()
            cmsg:ParseFromString(strHex)

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    FightManager.roomdata.seats[i].grab = cmsg.grab
                    if cmsg.grab ~= nil and cmsg.grab > 0 then
                        FightManager.roomdata.seats[i].grabed = true
                    else
                        FightManager.roomdata.seats[i].grabed = false
                    end
                end
            end

        elseif msgid == Enum.SET_BANKER_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end


            local cmsg = matching_pb.SetBankerResponse()
            cmsg:ParseFromString(strHex)

            FightManager.roomdata.banker = cmsg.seatNo --//

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    FightManager.roomdata.seats[i].grab = cmsg.grab
                    break
                end
            end
        elseif msgid == Enum.PLAY_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            FightManager.roomdata.status = 3
            local cmsg = matching_pb.PlayResponse()
            cmsg:ParseFromString(strHex)

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    FightManager.roomdata.seats[i].multiple = cmsg.playScore
                    break
                end
            end
        elseif msgid == Enum.DEAL_CARD_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end


            local cmsg = matching_pb.DealCardResponse()
            cmsg:ParseFromString(strHex)
            for i = 1, #FightManager.roomdata.seats do --//
                if FightManager.roomdata.seats[i].userName == PlayerManager.Player.userName then
                    --                    if #FightManager.roomdata.seats[i].cards==4 then

                    --                    else
                    --                        FightManager.roomdata.seats[i].cards={}
                    --                    end
                    --                print("==================B"..#cmsg.cards)
                    for a = 1, #cmsg.cards do
                        local card = {}
                        card.cardColor = cmsg.cards[a].cardColor
                        card.value = cmsg.cards[a].value
                        table.insert(FightManager.roomdata.seats[i].cards, card)
                    end

                    if #FightManager.roomdata.seats[i].cards == 5 then
                        FightManager.roomdata.status = 4
                    end

                    break
                end
            end

        elseif msgid == Enum.OPEN_CARD_CLIENT then --//
            if FightManager.roomdata.roomNo == nil then
                return
            end
            local cmsg = matching_pb.OpenCardResponse()
            cmsg:ParseFromString(strHex)

            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].userName ~= PlayerManager.Player.userName and FightManager.roomdata.seats[i].seatNo == cmsg.seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    for a = 1, #cmsg.cards do
                        local card = {}
                        card.cardColor = cmsg.cards[a].cardColor
                        card.value = cmsg.cards[a].value
                        table.insert(FightManager.roomdata.seats[i].cards, card)
                    end
                    break
                end
            end
        elseif msgid == Enum.RESULT_CLIENT then --//

            if FightManager.roomdata.roomNo == nil then
                return
            end

            FightManager.roomdata.status = 5
            local cmsg = matching_pb.ResultResponse()
            cmsg:ParseFromString(strHex)
            FightManager.resoutdata = {}

            for i = 1, #cmsg.result do
                local result = {}
                result.seatNo = cmsg.result[i].seatNo --1; //
                result.score = cmsg.result[i].score --2; //
                result.cards = {} --3; //
                for a = 1, #cmsg.result[i].cards do
                    local card = {}
                    card.cardColor = cmsg.result[i].cards[a].cardColor
                    card.value = cmsg.result[i].cards[a].value
                    table.insert(result.cards, card)
                end
                result.value = cmsg.result[i].value --4; //ֵ
                --//
                for b = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[b].seatNo == cmsg.result[i].seatNo then
                        FightManager.roomdata.seats[b].push = cmsg.result[i].push
                        FightManager.roomdata.seats[b].gold = FightManager.roomdata.seats[b].gold + cmsg.result[i].score
                        result.sex = FightManager.roomdata.seats[b].sex
                        --//
                        if FightManager.roomdata.seats[b].userName == PlayerManager.Player.userName then
                            PlayerManager.Player.gold = FightManager.roomdata.seats[b].gold
                        end

                        break
                    end
                end
                table.insert(FightManager.resoutdata, result)
            end
        end
    end
end


cc.exports.FightManager = FightManager
return FightManager

--endregion
