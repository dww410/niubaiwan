--[[
    角色名称合法性检测

]]

local Tool = {}

Tool.feiFaStrArr = require("app.Config.illegitimateText")

--是否允许创建该角色
function Tool.isOkCreateName(playerName)
    if playerName ~= nil and playerName ~= "" then
        local strHeFa = Tool.isHeFa(playerName)
        local a=nil
        local isHeFa=nil
        a,isHeFa =  string.find(strHeFa,"xx") 
        if isHeFa ==nil then
            --是否合法-如果合法
           a,isHeFa = string.find(strHeFa, " ") --如果名字中有空格
            if isHeFa ~= nil then
                return false
            end

            return true
        else
            return false --否则不合法
        end
    else
        return false
    end
end

function Tool.isHeFa(str)
    
    for _, feiFaStr in ipairs(Tool.feiFaStrArr) do
        local a=nil
        local isHeFa=nil
        a,isHeFa = string.find(str, feiFaStr)
        if isHeFa ~= nil then
            str= (string.gsub(str, feiFaStr, "xx"))
            return str
        end
    end
    
    return str
end

function Tool.splistStr(str,v)
    str = str ..'#'
    local tab = {}
    local d = string.find(str,v)
    local ed = string.find(str,'#')

    while d~=nil do
        table.insert(tab,string.sub(str,1,d-1))

        str = string.sub(str,d+1,ed)
        d = string.find(str,v)
        ed = string.find(str,'#')
    end
    table.insert(tab,string.sub(str,1,ed-1))
    return tab
end

function Tool.release()
    Tool.feiFaStrArr = nil
end

function Tool.GetPreciseDecimal(nNum, n)
    if type(nNum) ~= "number" then
        return nNum;
    end
    
    n = n or 0;
    n = math.floor(n)
    local fmt = '%.' .. n .. 'f'
    local nRet = tonumber(string.format(fmt, nNum))

    return nRet;
end

function Tool.GetRounding(nNum)
    if type(nNum) ~= "number" then
        return nNum;
    end 

    local t1,t2 = math.modf(nNum)
    return t1
end

function Tool.getStr32()
    local xx={'a','b','c','d','e','f','0','1','2','3','4','5','6','7','8','9'}
    local str=""
    for i=1,32 do
        str=str..xx[math.random(1,16)]
    end
    return str
end


--截取中英混合的UTF8字符串，endIndex可缺省
function Tool.SubStringUTF8(str, startIndex, endIndex)
    if startIndex < 0 then
        startIndex = Tool.SubStringGetTotalIndex(str) + startIndex + 1;
    end

    if endIndex ~= nil and endIndex < 0 then
        endIndex = Tool.SubStringGetTotalIndex(str) + endIndex + 1;
    end

    if endIndex == nil then 
        return string.sub(str, Tool.SubStringGetTrueIndex(str, startIndex));
    else
        return string.sub(str, Tool.SubStringGetTrueIndex(str, startIndex), Tool.SubStringGetTrueIndex(str, endIndex + 1) - 1);
    end
end


--获取中英混合UTF8字符串的真实字符数量
function Tool.SubStringGetTotalIndex(str)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = Tool.SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(lastCount == 0);
    return curIndex - 1;
end

--返回当前字符实际占用的字符数
function Tool.SubStringGetByteCount(str, index)
    local curByte = string.byte(str, index)
    local byteCount = 1;
    if curByte == nil then
        byteCount = 0
    elseif curByte > 0 and curByte <= 127 then
        byteCount = 1
    elseif curByte>=192 and curByte<=223 then
        byteCount = 2
    elseif curByte>=224 and curByte<=239 then
        byteCount = 3
    elseif curByte>=240 and curByte<=247 then
        byteCount = 4
    end
    return byteCount;
end

function Tool.SubStringGetTrueIndex(str, index)
    local curIndex = 0;
    local i = 1;
    local lastCount = 1;
    repeat 
        lastCount = Tool.SubStringGetByteCount(str, i)
        i = i + lastCount;
        curIndex = curIndex + 1;
    until(curIndex >= index);
    return i - lastCount;
end

function Tool.GetAdd()
    local ip, resolved = socket.dns.toip(socket.dns.gethostname())
    local ListTab = {}
    for k, v in ipairs(resolved.ip) do
        table.insert(ListTab, v)
    end
    return unpack(ListTab)
end


function Tool.ChangeForMart(number)
    local tempNum = 0
    local tempStr = ""
    tempNum = number
    tempStr = tempNum..""
    if tempNum>10000 then
        tempNum = tempNum/10000
        tempStr = tempNum.."W"
    end
    return tempStr
end
return Tool