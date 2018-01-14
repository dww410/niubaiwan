--
-- User: CongQin
-- Date: 16/04/06
-- Time: 上午10:05
--
local WaitProgress = require('app.views.Controls.WaitProgress')
local MessageTip = require('app.views.UI.MessageTip')
require('app.Commnucation.MessageHandle')
local targetPlatform    = cc.Application:getInstance():getTargetPlatform()
local SceneBase = class('SceneBase', cc.Scene)

function SceneBase:ctor()
    self.waitShowTips = self.waitShowTips or { }
    self.showingTips = self.showingTips or { }
    self.m_LoginAtOther = false
    self.m_AllowBackKey = true
    self:enableNodeEvents()


 
    -- (断网需要弹出对话框)与服务器断开连接
    if self.__cname ~= "LoadingScene" then
        onConnectionClosed1 = function(stuat)



            if GlobalData.isServer1connect==false then
            WaitProgress.Show()
            MessageTip.Show("网络中断重连中....")



            PauseStateToLua = function(sutat2)
                if sutat2==1 then
                    MessageTip.Show("重新连接成功")
                    WaitProgress.Close()
                    print("================大厅==连接成功")

                    if targetPlatform == cc.PLATFORM_OS_ANDROID or targetPlatform == cc.PLATFORM_OS_IPHONE then
                        local smsg = hall_pb.LoginRequest()
                        smsg.token= ServiceMessageManager.unionid
                        if PlayerManager.Player.sex=="男" then
                            smsg.sex=1
                        else
                            smsg.sex=2
                        end
                        smsg.headimgurl = PlayerManager.Player.head
                        smsg.name = PlayerManager.Player.name
                        smsg.platform=ServiceMessageManager.platform
                        local msgData = smsg:SerializeToString()
                        MSG.send(Enum.LOGIN_SERVER,msgData,1)
                    else
                        local smsg = hall_pb.LoginRequest()
                        smsg.token= PlayerManager.Player.name
                        smsg.sex = 1
                        smsg.headimgurl = ""
                        smsg.name = PlayerManager.Player.name
                        smsg.platform="pc"
                        local msgData = smsg:SerializeToString()
                        MSG.send(Enum.LOGIN_SERVER,msgData,1)                   
                    end
                    GlobalData.isServer1connect=true
                end
                PauseStateToLua= function() print('PauseStateToLua') end
            end
            Socket_SetServer(SERVER_NETGATE.ip1, SERVER_NETGATE.port1,1)
            Socket_Reconnect(1)



            if self.__cname == "GameFightScene" then
            PauseStateToLua2 = function(sutat2)
                if sutat2==1 then
                    print("================普通场==连接成功")
                    FightManager.GameRoomtype=1
                    local smsg = game_pb.IntoRequest()
                    smsg.username = PlayerManager.Player.userName -- 1; //用户名
                    smsg.roomNo = FightManager.roomdata.roomNo --2;  //房间号
                    local msgData = smsg:SerializeToString()
                    MSG.send(Enum.INTO_ROOM_SERVER,msgData,2)
                    GlobalData.isServer2connect=true
                    local pScene=require("app.views.Scenes.FightScene.GameFightScene"):new()
                    cc.Director:getInstance():replaceScene(pScene)
                end
                PauseStateToLua2= function() print('PauseStateToLua2') end
            end
            Socket_SetServer(SERVER_NETGATE.ip2, SERVER_NETGATE.port2,2)
            Socket_Reconnect(2)
          end


          if self.__cname == "GameFightScene2" then
            PauseStateToLua3 = function(sutat2)
                if sutat2==1 then
                    print("================金币场==连接成功")
                    FightManager.GameRoomtype=2
                    local smsg = matching_pb.IntoRequest()
                    smsg.username = PlayerManager.Player.userName -- 1; //用户名
                    smsg.baseScore = FightManager.roomdata.baseScore --2;  //底分
                    local msgData = smsg:SerializeToString()
                    MSG.send(Enum.INTO_ROOM_SERVER,msgData,3)
                    GlobalData.isServer3connect=true
--                    local pScene=require("app.views.Scenes.MainScene.MainScene"):new()
--                    cc.Director:getInstance():replaceScene(pScene)                 
                end
                PauseStateToLua3 = function() print('PauseStateToLua3') end
            end
            Socket_SetServer(SERVER_NETGATE.ip3, SERVER_NETGATE.port3,3)
            Socket_Reconnect(3)
        end




            end

            --等3秒在重连
            self:runAction(transition.sequence({cc.DelayTime:create(3),cc.CallFunc:create(function()
                if onConnectionClosed1 then
                    onConnectionClosed1(1)
                end
            end)}))
        end
    end



    
    if self.__cname == "GameFightScene" then
        onConnectionClosed2 = function(stuat)
            if GlobalData.isServer2connect==false then
            WaitProgress.Show()
            MessageTip.Show("网络中断重连中....")




            PauseStateToLua = function(sutat2)
                if sutat2==1 then
                    MessageTip.Show("重新连接成功")
                    WaitProgress.Close()
                    print("================大厅==连接成功")
                    if targetPlatform == cc.PLATFORM_OS_ANDROID or targetPlatform == cc.PLATFORM_OS_IPHONE then
                        local smsg = hall_pb.LoginRequest()
                        smsg.token= ServiceMessageManager.unionid
                        if PlayerManager.Player.sex=="男" then
                            smsg.sex=1
                        else
                            smsg.sex=2
                        end
                        smsg.headimgurl = PlayerManager.Player.head
                        smsg.name = PlayerManager.Player.name
                        smsg.platform=ServiceMessageManager.platform
                        local msgData = smsg:SerializeToString()
                        MSG.send(Enum.LOGIN_SERVER,msgData,1)
                    else
                        local smsg = hall_pb.LoginRequest()
                        smsg.token= PlayerManager.Player.name
                        smsg.sex = 1
                        smsg.headimgurl = ""
                        smsg.name = PlayerManager.Player.name
                        smsg.platform="pc"
                        local msgData = smsg:SerializeToString()
                        MSG.send(Enum.LOGIN_SERVER,msgData,1)                   
                    end
                    GlobalData.isServer1connect=true
                end
                PauseStateToLua= function() print('PauseStateToLua') end
            end
            Socket_SetServer(SERVER_NETGATE.ip1, SERVER_NETGATE.port1,1)
            Socket_Reconnect(1)




            PauseStateToLua2 = function(sutat2)
                if sutat2==1 then
                    print("================普通场==连接成功")
                    FightManager.GameRoomtype=1
                    local smsg = game_pb.IntoRequest()
                    smsg.username = PlayerManager.Player.userName -- 1; //用户名
                    smsg.roomNo = FightManager.roomdata.roomNo --2;  //房间号
                    local msgData = smsg:SerializeToString()
                    MSG.send(Enum.INTO_ROOM_SERVER,msgData,2)
                    GlobalData.isServer2connect=true
                    local pScene=require("app.views.Scenes.FightScene.GameFightScene"):new()
                    cc.Director:getInstance():replaceScene(pScene)
                end
                PauseStateToLua2= function() print('PauseStateToLua2') end
            end
            Socket_SetServer(SERVER_NETGATE.ip2, SERVER_NETGATE.port2,2)
            Socket_Reconnect(2)







            end



            --等3秒在重连
            self:runAction(transition.sequence({cc.DelayTime:create(3),cc.CallFunc:create(function()
                if onConnectionClosed2 then
                    onConnectionClosed2(1)
                end
            end)}))
        end
    else
        onConnectionClosed2=nil
    end




    if self.__cname == "GameFightScene2" then
        onConnectionClosed3 = function(stuat)
            if GlobalData.isServer3connect==false then
            WaitProgress.Show()
            MessageTip.Show("网络中断重连中....")



            PauseStateToLua = function(sutat2)
                if sutat2==1 then
                    MessageTip.Show("重新连接成功")
                    WaitProgress.Close()
                    print("================大厅==连接成功")
                    if targetPlatform == cc.PLATFORM_OS_ANDROID or targetPlatform == cc.PLATFORM_OS_IPHONE then
                        local smsg = hall_pb.LoginRequest()
                        smsg.token= ServiceMessageManager.unionid
                        if PlayerManager.Player.sex=="男" then
                            smsg.sex=1
                        else
                            smsg.sex=2
                        end
                        smsg.headimgurl = PlayerManager.Player.head
                        smsg.name = PlayerManager.Player.name
                        smsg.platform=ServiceMessageManager.platform
                        local msgData = smsg:SerializeToString()
                        MSG.send(Enum.LOGIN_SERVER,msgData,1)
                    else
                        local smsg = hall_pb.LoginRequest()
                        smsg.token= PlayerManager.Player.name
                        smsg.sex = 1
                        smsg.headimgurl = ""
                        smsg.name = PlayerManager.Player.name
                        smsg.platform="pc"
                        local msgData = smsg:SerializeToString()
                        MSG.send(Enum.LOGIN_SERVER,msgData,1)                   
                    end
                    GlobalData.isServer1connect=true
                end
                PauseStateToLua= function() print('PauseStateToLua') end
            end
            Socket_SetServer(SERVER_NETGATE.ip1, SERVER_NETGATE.port1,1)
            Socket_Reconnect(1)



            PauseStateToLua3 = function(sutat2)
                if sutat2==1 then
                    print("================金币场==连接成功")
                    FightManager.GameRoomtype=2
                    local smsg = matching_pb.IntoRequest()
                    smsg.username = PlayerManager.Player.userName -- 1; //用户名
                    smsg.baseScore = FightManager.roomdata.baseScore --2;  //底分
                    local msgData = smsg:SerializeToString()
                    MSG.send(Enum.INTO_ROOM_SERVER,msgData,3)
                    GlobalData.isServer3connect=true
--                    local pScene=require("app.views.Scenes.MainScene.MainScene"):new()
--                    cc.Director:getInstance():replaceScene(pScene)
                end
                PauseStateToLua3= function() print('PauseStateToLua3') end
            end
            Socket_SetServer(SERVER_NETGATE.ip3, SERVER_NETGATE.port3,3)
            Socket_Reconnect(3)





            end

             --等3秒在重连
            self:runAction(transition.sequence({cc.DelayTime:create(3),cc.CallFunc:create(function()
                if onConnectionClosed3 then
                    onConnectionClosed3(1)
                end
            end)}))
        end
    else
        onConnectionClosed3=nil
    end
    




--    MessageHandle.addHandle(Enum.REPEAT_LOGIN_CLIENT, function(msgid,data,timeStamp)
--        require("app.views.UI.LayerTips").new("您的账号已在其它地方登录",false):Show():SetCloseCallBack(function(isupdata)
--            local scene = require("app.views.Scenes.LoadingScene.LoadingScene"):new()
--            cc.Director:getInstance():replaceScene(scene)
--        end)
--    end)

    if self.onEnterCallback~=nil then
        self.onEnterCallback()
    end
    local function onrelease(code,event)
        if code == cc.KeyCode.KEY_BACK then
            print("你点击了返回键")
            if isShowQuit==false  and self.__cname == 'MainScene'or isShowQuit==false  and self.__cname == 'LoadingScene' then
                isShowQuit = true
                require("app.views.UI.LayerOutGame").new():Show():SetCloseCallBack(function(isupdate)
                    isShowQuit = false
                end)
            end
            
        elseif code == cc.KeyCode.KEY_HOME then
            print("你点击了HOME键")
        end
    end
    local listener = cc.EventListenerKeyboard:create()
    listener:registerScriptHandler(onrelease, cc.Handler.EVENT_KEYBOARD_RELEASED)
    --lua中得回调，分清谁绑定，监听谁，事件类型是什么
    local eventDispatcher =self:getEventDispatcher()
    eventDispatcher:addEventListenerWithSceneGraphPriority(listener,self)
end
function SceneBase:onEnter()  
end

function SceneBase:onExit()
    MessageHandle.removeHandle(self)
end

function SceneBase:onEnterTransitionFinish()
--    if self.__cname == 'GameFightScene' then
--        onpauseGame = function()
--            cc.exports.resumeGame_roomid = FightManager.roomdata.roomNo
--            local pScene=require("app.views.Scenes.MainScene.MainScene"):new()
--            cc.Director:getInstance():replaceScene(pScene)
--        end
--    else
        onpauseGame=nil
--    end


--    if self.__cname == 'MainScene' and resumeGame_roomid~=nil then

--    else
        onresumeGame=nil
--    end
end

function SceneBase:onExitTransitionStart()
    
end

function SceneBase:SetonEnterTransitionFinishCallback(func)
    self.onEnterCallback=func
    return self
end


cc.exports.DTDisconnected = function(sutat)
    GlobalData.isServer1connect=false
    if onConnectionClosed1 then
        onConnectionClosed1(sutat)
    end
    return 1
end

cc.exports.FTNormalDisconnected = function(sutat)
    GlobalData.isServer2connect=false
    if onConnectionClosed2 then
        onConnectionClosed2(sutat)
    end
    return 1
end

cc.exports.FTGoldDisconnected = function(sutat)
    GlobalData.isServer3connect=false
    if onConnectionClosed3 then
        onConnectionClosed3(sutat)
    end
    return 1
end

cc.exports.pauseGame = function(sutat)
    if onpauseGame then
        onpauseGame()
    end
    return 1
end

cc.exports.resumeGame = function(sutat)
    if onresumeGame then
        onresumeGame()
    end
    return 1
end

return SceneBase
