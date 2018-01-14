--region *.lua
--Date
--此文件由[BabeLua]插件自动生成

local GameFightSceneHelp = GameFightSceneHelp or {}
local platformMethod = require('app.Platform.platformMethod')

--解散房间
function GameFightSceneHelp.DeleteRoom()
    MSG.send(Enum.DELETE_SERVER, "", FightManager.GameRoomtype + 1)
end

--离开房间
function GameFightSceneHelp.ExitRoom()
    MSG.send(Enum.EXIT_SERVER, "", FightManager.GameRoomtype + 1)
end

--开始游戏
function GameFightSceneHelp.GameStart()
    MSG.send(Enum.START_SERVER, "", FightManager.GameRoomtype + 1)
end

--抢庄
function GameFightSceneHelp.StartBanker(num)
    local smsg = game_pb.GrabRequest()
    smsg.grab = num
    local msgData = smsg:SerializeToString()
    MSG.send(Enum.GRAB_SERVER, msgData, FightManager.GameRoomtype + 1)
end

--坐下座位
function GameFightSceneHelp.Sitdown()
    MSG.send(Enum.SEAT_ROOM_SERVER, "", FightManager.GameRoomtype + 1)
end

--游戏准备
function GameFightSceneHelp.GameReady()
    MSG.send(Enum.READY_SERVER, "", FightManager.GameRoomtype + 1)
end

--下注
function GameFightSceneHelp.putBet(score)
    local smsg = game_pb.PlayRequest()
    smsg.playScore = score
    local msgData = smsg:SerializeToString()
    MSG.send(Enum.PLAY_SERVER, msgData, FightManager.GameRoomtype + 1)
end

--亮牌
function GameFightSceneHelp.showCard()
    MSG.send(Enum.OPEN_CARD_SERVER, "", FightManager.GameRoomtype + 1)
end

--发语音
function GameFightSceneHelp.sendVoice(file)
    local smsg = game_pb.VoiceRequest()
    smsg.content = file
    local msgData = smsg:SerializeToString()
    MSG.send(Enum.VOICE_SERVER, msgData, FightManager.GameRoomtype + 1)
end

--获得当庄时的最大赔率
function GameFightSceneHelp.getMaxGoldPay(pay)
    local gold = 0
    --参加人数
    local palyerNum = #FightManager.roomdata.seats - 1
    gold = FightManager.roomdata.baseScore * 4 * pay * 8 * palyerNum

    return gold
end

--动画匹配中
function GameFightSceneHelp.CreateAm_PPZ(parent, startPos)
    if parent:getChildByName("Am_FJPPZ") then
        local sprite = parent:getChildByName("Am_FJPPZ")
        sprite:removeFromParent()
    end

    local sprite = cc.CSLoader:createNode('Animation/Am_FJPPZ.csb')
    sprite.AnimateTimeLine = cc.CSLoader:createTimeline('Animation/Am_FJPPZ.csb')
    sprite:runAction(sprite.AnimateTimeLine)
    sprite.AnimateTimeLine:gotoFrameAndPause(0)

    parent:addChild(sprite)
    sprite:setPosition(startPos)
    sprite:setName("Am_FJPPZ")

    sprite.AnimateTimeLine:play("start", true)
end

--抢不抢庄 跟 几倍提示
function GameFightSceneHelp.CreateAm_QZ(parent, isqiang, beishu)
    if parent:getChildByName("Am_Qiang") then
        local sprite = parent:getChildByName("Am_Qiang")
        sprite:removeFromParent()
    end

    local sprite
    if isqiang == true then
        sprite = cc.Sprite:createWithSpriteFrameName("niuniu_img45.png")
    else
        sprite = cc.Sprite:createWithSpriteFrameName("niuniu_img46.png")
    end

    if beishu ~= nil and beishu > 0 and FightManager.roomdata.gameType ~= 3 then
        sprite = cc.Sprite:createWithSpriteFrameName("niuniu_bei" .. beishu .. ".png")
    end
    parent:addChild(sprite)
    sprite:setAnchorPoint(0.5, 0.5)
    sprite:setPosition(cc.p(parent:getCenter().x, parent:getCenter().y - 85))
    sprite:setName("Am_Qiang")
    sprite.beishu = beishu
end


--玩家互动动画
function GameFightSceneHelp.CreateAm_Hd(parent, startPos, endPos, seatNo, otherSeatNo, content, sex)
    print("sex:" .. sex)
    if parent:getChildByName("Hd" .. seatNo .. "_" .. otherSeatNo) then
        local sprite = parent:getChildByName("Hd" .. seatNo .. "_" .. otherSeatNo)
        if sprite.AnimateTimeLine:getCurrentFrame() == 60 then
            sprite:removeFromParent()
        else
            return
        end
    end

    local sprite = cc.CSLoader:createNode('Animation/Am_Hd' .. content .. '.csb')
    sprite.AnimateTimeLine = cc.CSLoader:createTimeline('Animation/Am_Hd' .. content .. '.csb')
    sprite:runAction(sprite.AnimateTimeLine)
    sprite.AnimateTimeLine:gotoFrameAndPause(0)

    parent:addChild(sprite)
    sprite:setPosition(startPos)
    sprite:setName("Hd" .. seatNo .. "_" .. otherSeatNo)

    SoundHelper.playMusicSound(94 + content, sex, false)
    sprite:runAction(cc.Sequence:create(cc.MoveTo:create(0.75, cc.p(endPos.x - 40, endPos.y)),
        cc.CallFunc:create(function()
            sprite.AnimateTimeLine:play("start", false)
            SoundHelper.playMusicSound(15 + content, 0, false)
        end),
        cc.DelayTime:create(2),
        cc.CallFunc:create(function()
            sprite:removeFromParent()
        end)))
end

--玩家表情动画
function GameFightSceneHelp.CreateAm_BQ(parent, startPos, seatNo, content)
    if parent:getChildByName("BQ" .. seatNo) then
        local sprite = parent:getChildByName("BQ" .. seatNo)
        if sprite.AnimateTimeLine:getCurrentFrame() == 85 then
            sprite:removeFromParent()
        else
            return
        end
    end

    local sprite = cc.CSLoader:createNode('Animation/Am_BQ.csb')
    sprite.AnimateTimeLine = cc.CSLoader:createTimeline('Animation/Am_BQ.csb')
    sprite:runAction(sprite.AnimateTimeLine)
    sprite.AnimateTimeLine:gotoFrameAndPause(0)

    UIHelper.getNode(sprite, { "Image_1" }):loadTexture("biaoqin" .. content .. ".png", ccui.TextureResType.plistType)

    parent:addChild(sprite)
    sprite:setPosition(cc.p(startPos.x - 55, startPos.y))
    sprite:setName("BQ" .. seatNo)

    sprite:runAction(cc.Sequence:create(cc.CallFunc:create(function()
        sprite.AnimateTimeLine:play("start", false)
    end),
        cc.DelayTime:create(85 / 40),
        cc.CallFunc:create(function()
            sprite:removeFromParent()
        end)))
end

--玩家提示语动画
function GameFightSceneHelp.CreateAm_TSY(parent, startPos, seatNo, content)
    if parent:getChildByName("TSY" .. seatNo) then
        local sprite = parent:getChildByName("TSY" .. seatNo)
        if sprite.AnimateTimeLine:getCurrentFrame() == 180 then
            sprite:removeFromParent()
        else
            return
        end
    end

    local sprite = cc.CSLoader:createNode('Animation/Am_TSY.csb')
    sprite.AnimateTimeLine = cc.CSLoader:createTimeline('Animation/Am_TSY.csb')
    sprite:runAction(sprite.AnimateTimeLine)
    sprite.AnimateTimeLine:gotoFrameAndPause(0)

    UIHelper.getNode(sprite, { "Image_1", "Text_1" }):setString(GAMETSY[content])

    parent:addChild(sprite)
    sprite:setPosition(cc.p(startPos.x, startPos.y + 75))
    sprite:setName("TSY" .. seatNo)

    sprite:runAction(cc.Sequence:create(cc.CallFunc:create(function()
        sprite.AnimateTimeLine:play("Open", false)
    end),
        cc.DelayTime:create(3),
        cc.CallFunc:create(function()
            sprite:removeFromParent()
        end)))
end

--提示牛牛动画效果
function GameFightSceneHelp.CreateAm_TSNIUNIU(parent, cardstype, isBanker)
    if cardstype ~= 0 then
        local star = cc.CSLoader:createNode('Animation/Am_stars.csb')
        parent:addChild(star)

        star.AnimateTimeLine = cc.CSLoader:createTimeline("Animation/Am_stars.csb")
        star:runAction(star.AnimateTimeLine)
        star.AnimateTimeLine:play("play", true)

        --添加粒子
        local Particle = cc.ParticleSystemQuad:create("particle/particle_texture.plist")
        parent:addChild(Particle)
    end
    local scatto = parent:getScale()
    parent:runAction(cc.Sequence:create(cc.ScaleTo:create(0, 0.5), cc.EaseElasticOut:create(cc.ScaleTo:create(0.5, scatto))))
end

--搓牌中的动画
function GameFightSceneHelp.CreateAm_CPZ(parent)
    if parent:getChildByName("Am_CPZ") then
        local sprite = parent:getChildByName("Am_CPZ")
        sprite:removeFromParent()
    end

    local sprite = cc.CSLoader:createNode('Animation/Am_CPZ.csb')
    sprite.AnimateTimeLine = cc.CSLoader:createTimeline('Animation/Am_CPZ.csb')
    sprite:runAction(sprite.AnimateTimeLine)
    sprite.AnimateTimeLine:gotoFrameAndPause(0)

    parent:addChild(sprite)
    sprite:setPosition(parent:getCenter())
    sprite:setName("Am_CPZ")

    sprite.AnimateTimeLine:play("start", true)
end

--获取贝塞尔坐标
function GameFightSceneHelp.GetBezier(starPos, endPos)
    local width = endPos.x - starPos.x
    local height = endPos.y - starPos.y

    local bezier = {
        cc.p(starPos.x + (width / 4 * 1) + math.random(1, width / 4), starPos.y + (height / 4 * 1) + math.random(1, height / 4)),
        cc.p(starPos.x + (width / 4 * 3) - math.random(1, width / 4), starPos.y + (height / 4 * 3) - math.random(1, height / 4)),
        endPos,
    }
    return bezier
end

--玩家播放声音动画
function GameFightSceneHelp.CreateAm_VoiceF(parent, startPos, seatNo, time)
    if parent:getChildByName("Am_VoiceF" .. seatNo) then
        local sprite = parent:getChildByName("Am_VoiceF" .. seatNo)
        sprite:removeFromParent()
    end

    local sprite = cc.CSLoader:createNode('Animation/Am_VoiceF.csb')
    sprite.AnimateTimeLine = cc.CSLoader:createTimeline('Animation/Am_VoiceF.csb')
    sprite:runAction(sprite.AnimateTimeLine)
    sprite.AnimateTimeLine:gotoFrameAndPause(0)

    parent:addChild(sprite)
    sprite:setPosition(cc.p(startPos.x + 130, startPos.y + 50))
    sprite:setName("Am_VoiceF" .. seatNo)

    sprite:runAction(cc.Sequence:create(cc.CallFunc:create(function()
        sprite.AnimateTimeLine:play("play", true)
    end),
        cc.DelayTime:create(time),
        cc.CallFunc:create(function()
            sprite:removeFromParent()
        end)))
end

--玩家录语音动画
function GameFightSceneHelp.CreateAm_LY(parent, startPos, seatNo, StopRecodCallback)
    if parent:getChildByName("voice" .. seatNo) then
        local sprite = parent:getChildByName("voice" .. seatNo)
        if sprite.AnimateTimeLine:getCurrentFrame() == 300 then
            sprite:removeFromParent()
            --停止录制
            platformMethod.StopRecordSound(StopRecodCallback)
        else
            return
        end
    end

    local node = cc.CSLoader:createNode('Animation/Am_Voice.csb')
    node.AnimateTimeLine = cc.CSLoader:createTimeline('Animation/Am_Voice.csb')
    node:runAction(node.AnimateTimeLine)
    node.AnimateTimeLine:gotoFrameAndPause(0)

    local sprite = cc.Sprite:createWithSpriteFrameName("niuniu_img32.png")
    local left = cc.ProgressTimer:create(sprite)
    left:setType(kCCProgressTimerTypeRadial)
    left:setMidpoint(cc.p(0.5, 0.5))
    node:addChild(left)
    left:runAction(cc.Sequence:create(cc.ProgressTo:create(0, 100), cc.ProgressTo:create(5, 0)))


    parent:addChild(node)
    node:setPosition(cc.p(startPos.x, startPos.y))
    node:setName("voice" .. seatNo)

    node:runAction(cc.Sequence:create(cc.CallFunc:create(function()
        node.AnimateTimeLine:play("play", false)
    end),
        cc.DelayTime:create(5),
        cc.CallFunc:create(function()
            node:removeFromParent()
            --停止录制
            platformMethod.StopRecordSound(StopRecodCallback)
        end)))
end

--开始录音
function GameFightSceneHelp.startRecording(seatNo)
    local fullFileName = cc.FileUtils:getInstance():getWritablePath() .. "update/" .. FightManager.roomdata.roomNo .. "_" .. seatNo .. ".wav"
    platformMethod.RecordSound(fullFileName)
end

--根据座位号获取卡牌
function GameFightSceneHelp.getcardsByseatNo(seatNo)
    local cards = {}
    for i = 1, #FightManager.roomdata.seats do
        if FightManager.roomdata.seats[i].seatNo == seatNo then
            return FightManager.roomdata.seats[i].cards
        end
    end
    return cards
end

function GameFightSceneHelp.getsexByseatNo(seatNo)
    for i = 1, #FightManager.roomdata.seats do
        if FightManager.roomdata.seats[i].seatNo == seatNo then
            if FightManager.roomdata.seats[i].sex == "男" then
                return 1
            elseif FightManager.roomdata.seats[i].sex == "女" then
                return 2
            end
        end
    end
    return 1
end

function GameFightSceneHelp.getniuniuTypenum(value, smallBull, bombBull, threetwoBull, suitBull, spottedBull, straightBull, doubleBull, rule)
    if rule == 1 then
        if value == 7 or value == 8 then
            return "niuniu_mult_yellow_2.png"
        end

        if value == 9 then
            return "niuniu_mult_yellow_3.png"
        end

        if value == 10 then
            return "niuniu_mult_red_4.png"
        end
    elseif rule == 2 then
        if value == 8 or value == 9 then
            return "niuniu_mult_yellow_2.png"
        end

        if value == 10 then
            return "niuniu_mult_red_3.png"
        end
    end

    if doubleBull and value == 11 then
        return "niuniu_mult_red_4.png"
    end

    if straightBull and value == 12 then
        return "niuniu_mult_red_5.png"
    end

    if spottedBull and value == 13 then
        return "niuniu_mult_red_5.png"
    end

    if suitBull and value == 14 then
        return "niuniu_mult_red_6.png"
    end

    if threetwoBull and value == 15 then
        return "niuniu_mult_red_7.png"
    end

    if bombBull and value == 16 then
        return "niuniu_mult_red_8.png"
    end

    if smallBull and value == 17 then
        return "niuniu_mult_red_10.png"
    end

    return nil
end


--根据牛牛规则给卡牌 排序
--smallBull 五小牛
--spottedBull 五花牛
--bombBull 炸弹牛
--doubleBull 对子牛
function GameFightSceneHelp.orderByRule(seatNo, smallBull, bombBull, threetwoBull, suitBull, spottedBull, straightBull, doubleBull)


    local cardtype = 0
    local cards = GameFightSceneHelp.getcardsByseatNo(seatNo)
    table.sort(cards, function(d1, d2)
        return d1.value > d2.value
    end)

    if smallBull then
        local flag = true
        for i = 1, #cards - 1 do
            if cards[i].cardColor ~= cards[i + 1].cardColor then
                flag = false
                break
            end
        end
        if flag then
            if cards[1].value == 13 and cards[2].value == 12 and cards[3].value == 11 and cards[4].value == 10 and cards[5].value  == 1 then
                flag = true
            else
                for i = 1, #cards - 1 do
                    if cards[i].value ~= cards[i + 1].value + 1  then
                        flag = false
                        break
                    end
                end
            end
        end
        if flag then
            local newcards = {}
            newcards = cards
            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                    break
                end
            end
            return 17
        end
    end


    if bombBull then
        local newcards = {}
        newcards = cards
        if cards[1].value == cards[4].value then
            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                    break
                end
            end
            return 16
        elseif cards[2].value == cards[5].value then
            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                    break
                end
            end
            return 16
        end
    end

    if threetwoBull then
        local newcards = {}
        newcards = cards
        if cards[1].value == cards[3].value and cards[4].value == cards[5].value then
            for i = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[i].seatNo == seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                    break
                end
            end
            return 15
        elseif cards[1].value == cards[2].value and cards[3].value == cards[5].value then
            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                    break
                end
            end
            return 15
        end
    end

    if suitBull then
        local flag = true
        for i = 1, #cards - 1 do
            if cards[i].cardColor ~= cards[i + 1].cardColor then
                flag = false
                break
            end
        end
        if flag then
            local newcards = {}
            newcards = cards
            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                    break
                end
            end
            return 14
        end
    end


    if spottedBull then
        local spottedBull = true
        for i = 1, #cards do
            if cards[i].value < 10 then
                spottedBull = false
                break
            end
        end
        if spottedBull then
            local newcards = {}
            newcards = cards
            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                    break
                end
            end
            return 13
        end
    end

    if straightBull then
        local flag = true
        if cards[1].value == 13 and cards[2].value == 12 and cards[3].value == 11 and cards[4].value == 10 and cards[5].value  == 1 then
            flag = true
        else
            for i = 1, #cards - 1 do
                if cards[i].value ~= cards[i + 1].value + 1 then
                    flag = false
                    break
                end
            end
        end
        if flag then
            local newcards = {}
            newcards = cards
            for i = 1, #FightManager.roomdata.seats do
                if FightManager.roomdata.seats[i].seatNo == seatNo then
                    FightManager.roomdata.seats[i].cards = {}
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                    table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                    break
                end
            end
            return 12
        end
    end



    if doubleBull then

        local num = 0
        local newcards = {}
        newcards = cards
        if cards[1].value == cards[2].value then
            num = 0
            if cards[3].value > 10 then
                num = num + 10
            else
                num = num + cards[3].value
            end

            if cards[4].value > 10 then
                num = num + 10
            else
                num = num + cards[4].value
            end

            if cards[5].value > 10 then
                num = num + 10
            else
                num = num + cards[5].value
            end
            if num ~= 0 and num % 10 == 0 then
                for i = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[i].seatNo == seatNo then
                        FightManager.roomdata.seats[i].cards = {}
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                        break
                    end
                end
                return 11
            end
        end

        if cards[2].value == cards[3].value then
            num = 0
            if cards[1].value > 10 then
                num = num + 10
            else
                num = num + cards[1].value
            end

            if cards[4].value > 10 then
                num = num + 10
            else
                num = num + cards[4].value
            end

            if cards[5].value > 10 then
                num = num + 10
            else
                num = num + cards[5].value
            end
            if num ~= 0 and num % 10 == 0 then
                for i = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[i].seatNo == seatNo then
                        FightManager.roomdata.seats[i].cards = {}
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                        break
                    end
                end
                return 11
            end
        end

        if cards[3].value == cards[4].value then
            num = 0
            if cards[1].value > 10 then
                num = num + 10
            else
                num = num + cards[1].value
            end

            if cards[2].value > 10 then
                num = num + 10
            else
                num = num + cards[2].value
            end

            if cards[5].value > 10 then
                num = num + 10
            else
                num = num + cards[5].value
            end
            if num ~= 0 and num % 10 == 0 then
                for i = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[i].seatNo == seatNo then
                        FightManager.roomdata.seats[i].cards = {}
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                        break
                    end
                end
                return 11
            end
        end

        if cards[4].value == cards[5].value then
            num = 0
            if cards[1].value > 10 then
                num = num + 10
            else
                num = num + cards[1].value
            end

            if cards[2].value > 10 then
                num = num + 10
            else
                num = num + cards[2].value
            end

            if cards[3].value > 10 then
                num = num + 10
            else
                num = num + cards[3].value
            end
            if num ~= 0 and num % 10 == 0 then
                for i = 1, #FightManager.roomdata.seats do
                    if FightManager.roomdata.seats[i].seatNo == seatNo then
                        FightManager.roomdata.seats[i].cards = {}
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[1])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[2])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[3])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[4])
                        table.insert(FightManager.roomdata.seats[i].cards, newcards[5])
                        break
                    end
                end
                return 11
            end
        end
    end


    local IsNiu = 0

    local count1 = cards[1].value
    local count2 = cards[2].value
    local count3 = cards[3].value
    local count4 = cards[4].value
    local count5 = cards[5].value

    if count1 > 10 then
        count1 = 10
    end
    if count2 > 10 then
        count2 = 10
    end
    if count3 > 10 then
        count3 = 10
    end
    if count4 > 10 then
        count4 = 10
    end
    if count5 > 10 then
        count5 = 10
    end


    if (count1 + count2 + count3) % 10 == 0 then
        IsNiu = (count4 + count5) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end

    elseif (count1 + count2 + count4) % 10 == 0 then
        IsNiu = (count3 + count5) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == seatNo then
                FightManager.roomdata.seats[i].cards = {}
                table.insert(FightManager.roomdata.seats[i].cards, cards[1])
                table.insert(FightManager.roomdata.seats[i].cards, cards[2])
                table.insert(FightManager.roomdata.seats[i].cards, cards[4])
                table.insert(FightManager.roomdata.seats[i].cards, cards[3])
                table.insert(FightManager.roomdata.seats[i].cards, cards[5])
                break
            end
        end


    elseif (count1 + count2 + count5) % 10 == 0 then
        IsNiu = (count3 + count4) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == seatNo then
                FightManager.roomdata.seats[i].cards = {}
                table.insert(FightManager.roomdata.seats[i].cards, cards[1])
                table.insert(FightManager.roomdata.seats[i].cards, cards[2])
                table.insert(FightManager.roomdata.seats[i].cards, cards[5])
                table.insert(FightManager.roomdata.seats[i].cards, cards[3])
                table.insert(FightManager.roomdata.seats[i].cards, cards[4])
                break
            end
        end


    elseif (count1 + count3 + count4) % 10 == 0 then
        IsNiu = (count2 + count5) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == seatNo then
                FightManager.roomdata.seats[i].cards = {}
                table.insert(FightManager.roomdata.seats[i].cards, cards[1])
                table.insert(FightManager.roomdata.seats[i].cards, cards[3])
                table.insert(FightManager.roomdata.seats[i].cards, cards[4])
                table.insert(FightManager.roomdata.seats[i].cards, cards[2])
                table.insert(FightManager.roomdata.seats[i].cards, cards[5])
                break
            end
        end

    elseif (count1 + count3 + count5) % 10 == 0 then
        IsNiu = (count2 + count4) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == seatNo then
                FightManager.roomdata.seats[i].cards = {}
                table.insert(FightManager.roomdata.seats[i].cards, cards[1])
                table.insert(FightManager.roomdata.seats[i].cards, cards[3])
                table.insert(FightManager.roomdata.seats[i].cards, cards[5])
                table.insert(FightManager.roomdata.seats[i].cards, cards[2])
                table.insert(FightManager.roomdata.seats[i].cards, cards[4])
                break
            end
        end

    elseif (count1 + count4 + count5) % 10 == 0 then
        IsNiu = (count2 + count3) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == seatNo then
                FightManager.roomdata.seats[i].cards = {}
                table.insert(FightManager.roomdata.seats[i].cards, cards[1])
                table.insert(FightManager.roomdata.seats[i].cards, cards[4])
                table.insert(FightManager.roomdata.seats[i].cards, cards[5])
                table.insert(FightManager.roomdata.seats[i].cards, cards[2])
                table.insert(FightManager.roomdata.seats[i].cards, cards[3])
                break
            end
        end


    elseif (count2 + count3 + count4) % 10 == 0 then
        IsNiu = (count1 + count5) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == seatNo then
                FightManager.roomdata.seats[i].cards = {}
                table.insert(FightManager.roomdata.seats[i].cards, cards[2])
                table.insert(FightManager.roomdata.seats[i].cards, cards[3])
                table.insert(FightManager.roomdata.seats[i].cards, cards[4])
                table.insert(FightManager.roomdata.seats[i].cards, cards[1])
                table.insert(FightManager.roomdata.seats[i].cards, cards[5])
                break
            end
        end

    elseif (count2 + count3 + count5) % 10 == 0 then
        IsNiu = (count1 + count4) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == seatNo then
                FightManager.roomdata.seats[i].cards = {}
                table.insert(FightManager.roomdata.seats[i].cards, cards[2])
                table.insert(FightManager.roomdata.seats[i].cards, cards[3])
                table.insert(FightManager.roomdata.seats[i].cards, cards[5])
                table.insert(FightManager.roomdata.seats[i].cards, cards[1])
                table.insert(FightManager.roomdata.seats[i].cards, cards[4])
                break
            end
        end

    elseif (count2 + count4 + count5) % 10 == 0 then
        IsNiu = (count1 + count3) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == seatNo then
                FightManager.roomdata.seats[i].cards = {}
                table.insert(FightManager.roomdata.seats[i].cards, cards[2])
                table.insert(FightManager.roomdata.seats[i].cards, cards[4])
                table.insert(FightManager.roomdata.seats[i].cards, cards[5])
                table.insert(FightManager.roomdata.seats[i].cards, cards[1])
                table.insert(FightManager.roomdata.seats[i].cards, cards[3])
                break
            end
        end


    elseif (count3 + count4 + count5) % 10 == 0 then
        IsNiu = (count1 + count2) % 10
        if IsNiu == 0 then
            IsNiu = 10;
        end
        for i = 1, #FightManager.roomdata.seats do
            if FightManager.roomdata.seats[i].seatNo == seatNo then
                FightManager.roomdata.seats[i].cards = {}
                table.insert(FightManager.roomdata.seats[i].cards, cards[3])
                table.insert(FightManager.roomdata.seats[i].cards, cards[4])
                table.insert(FightManager.roomdata.seats[i].cards, cards[5])
                table.insert(FightManager.roomdata.seats[i].cards, cards[1])
                table.insert(FightManager.roomdata.seats[i].cards, cards[2])
                break
            end
        end
    end

    print("=============seatNo=====" .. seatNo)
    print("=============IsNiu=====" .. IsNiu)


    return IsNiu
end

--输赢数字
function GameFightSceneHelp.getnumber(num)
    local node = nil
    local spritestr = ""
    if num > 0 then
        node = cc.Sprite:createWithSpriteFrameName("niuniu_img22.png")
        spritestr = "mathyello_"
    else
        node = cc.Sprite:createWithSpriteFrameName("niuniu_img21.png")
        spritestr = "mathblue_"
    end

    local width = 0
    local sprite0 = cc.Sprite:createWithSpriteFrameName(spritestr .. "10.png")
    node:addChild(sprite0)
    sprite0:setAnchorPoint(cc.p(0, 0.5))


    local absnum = math.abs(num)
    if absnum >= 1000000 then
        width = -22
    elseif absnum >= 100000 then
        width = -11
    elseif absnum >= 10000 then
        width = 0
    elseif absnum >= 1000 then
        width = 11
    elseif absnum >= 100 then
        width = 22
        sprite0:setPosition(cc.p(width + 0, node:getContentSize().height / 2))
    elseif absnum >= 10 then
        width = 33
    else
        width = 44
    end

    sprite0:setPosition(cc.p(width + 0, node:getContentSize().height / 2))
    for i = 1, string.len(absnum .. "") do
        local sprite = cc.Sprite:createWithSpriteFrameName(spritestr .. math.floor(absnum / math.pow(10, string.len(absnum .. "") - i)) % 10 .. ".png")
        sprite:setAnchorPoint(cc.p(0, 0.5))
        node:addChild(sprite)
        sprite:setPosition(cc.p(width + 22 * i, node:getContentSize().height / 2))
        sprite:setScale(0.9)
    end

    return node
end


function GameFightSceneHelp.BankerAm(data, data2)
    if #data == 2 then
        action = cc.Sequence:create(GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.CallFunc:create(function()
                data[2]:setOpacity(0)
                data2.AnimateTimeLine:play("banker", false)
            end))
    elseif #data == 3 then
        action = cc.Sequence:create(GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.CallFunc:create(function()
                data[2]:setOpacity(0)
                data2.AnimateTimeLine:play("banker", false)
            end))
    elseif #data == 4 then
        action = cc.Sequence:create(GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.CallFunc:create(function()
                data[2]:setOpacity(0)
                data2.AnimateTimeLine:play("banker", false)
            end))
    elseif #data == 5 then
        action = cc.Sequence:create(GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.CallFunc:create(function()
                data[2]:setOpacity(0)
                data2.AnimateTimeLine:play("banker", false)
            end))
    elseif #data == 6 then
        action = cc.Sequence:create(GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 6),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 6),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.15),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 6),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.075),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 6),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.0375),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 3),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 5),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 1),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 6),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 4),
            cc.DelayTime:create(0.018),
            GameFightSceneHelp.getBankerfunc(data, 2),
            cc.CallFunc:create(function()
                data[2]:setOpacity(0)
                data2.AnimateTimeLine:play("banker", false)
            end))
    end

    return action
end

function GameFightSceneHelp.getBankerfunc(data, index)
    local func = cc.CallFunc:create(function()
        for i = 1, #data do
            data[i]:setOpacity(0)
        end
        data[index]:setOpacity(255)
    end)
    return func
end

return GameFightSceneHelp

--endregion