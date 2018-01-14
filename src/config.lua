-- 0 - disable debug info, 1 - less debug info, 2 - verbose debug info
DEBUG = 2

-- use framework, will disable all deprecated API, false - use legacy API
CC_USE_FRAMEWORK = true

-- show FPS on screen
CC_SHOW_FPS = false

-- disable create unexpected global variable
CC_DISABLE_GLOBAL = false

-- for module display
CC_DESIGN_RESOLUTION = {
    width = 1136,
    height = 640,
    autoscale = "EXACT_FIT",
    callback = function(framesize)
        local ratio = framesize.width / framesize.height
        if ratio <= 1.34 then
            return { autoscale = "EXACT_FIT" }
        end
    end
}

local defaultFont = "MINIJIAN.TTF"
if cc and cc.exports then
    cc.exports.DEFAULTFONT = defaultFont
else
    DEFAULTFONT = defaultFont
end

local gameName = " "
if cc and cc.exports then
    cc.exports.GAME_NAME = gameName
else
    GAME_NAME = gameName
end


local version = "1.0.3"

if cc and cc.exports then
    cc.exports.Version = version
else
    Version = version
end


local versionID = 3

if cc and cc.exports then
    cc.exports.ClientVerID = versionID
else
    ClientVerID = versionID
end

if cc and cc.exports then
    cc.exports.isShowQuit = false
    cc.exports.haveWeChat = "false"
else
    isShowQuit = false
    haveWeChat = "false"
end

local serverGate =
{
    port1 = 10001,
    port2 = 10002,
    port3 = 10003,
    ip1 = GetIPByHost("47.104.8.10"),
    ip2 = GetIPByHost("47.104.8.10"),
    ip3 = GetIPByHost("47.104.8.10")
}


local httpurl =
{
    url = GetIPByHost("nn.niubaiwan.vip") or GetIPByHost("nn.niubaiwan.vip")
}
if cc and cc.exports then
    cc.exports.HTTPURL = httpurl
else
    HTTPURL = httpurl
end

local appInfo =
{
    appname = "牛百万",
    appid = "wx37ace77253349582",
    appsecret = "b85edd3735e84201ebd86b0f65c3b16b",
    apppayid = "1486633122",
    apppayecret = "19c9aa5d8b951ec1b0b9b44886d81ba6"
}

local gameHelpUrl =
{
    helpUrl = "https://fir.im/xgsf",
    downLoadUrl = "https://fir.im/xgsf"
}

if cc and cc.exports then
    cc.exports.SERVER_NETGATE = serverGate
    cc.exports.GAME_URL = gameHelpUrl
    cc.exports.APP_INFO = appInfo
else
    SERVER_NETGATE = serverGate
    GAME_URL = gameHelpUrl
    APP_INFO = appInfo
end

function platformMethodJavaCall(str)
    print("platformMethod.javaCall:" .. str)
    require('app.views.UI.MessageTip').Show(str)
    return 1
end

function platformMethodHaveWeChat(str)
    cc.exports.haveWeChat = str
    return 1
end

--if not serverGate.ip then
--    serverGate.ip=GetIPByHost(serverGate.url)
--    print('convert host:'..serverGate.url..'to ip:'..serverGate.ip)
--end
