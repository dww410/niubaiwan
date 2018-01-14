--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
-- User: CongQin
-- Date: 16/04/08
require('app.Commnucation.Message')
require('app.Commnucation.enum')
require('app.Commnucation.MessageManager')

local MessageHandle=MessageHandle or {}

MessageHandle.DataManager=require('app.DataManager.DataManager')
local hosts=hosts or {}
local handles=handles or {}
local autoRemoveHandles=autoRemoveHandles or {}



cc.exports.reciveMsg=function( msgid, strHex)
    
    handles[0]=handles[0] or {}

    if MessageHandle.DataManager then
	    MessageHandle.DataManager.ProcessMsg(msgid,strHex)
        print("message handle msgid:"..msgid)
    end
    local func=autoRemoveHandles[msgid]
	if func~=nil then
		--print('reciveMsg,invoke func',msg._ID,func,print(Table2String(msg)))
		func(msg)
        autoRemoveHandles[msgid]=nil
	end

    for i=1,#hosts do
        local host=hosts[i]
        local hostHandles=handles[host]
        if hostHandles then
	        local func=hostHandles[msgid]
	        if func~=nil then
		        --print('reciveMsg,invoke func',msg._ID,func,print(Table2String(msg)))
		        func(msg,strHex,timeStamp)
	        end
        end
    end
    local func=handles[0][msgid]
    if func~=nil then
	    func(msg)
        print("cc.exports.reciveMsg=function( msgid, strHex):"..msgid)
    end
	--msg=nil
	return 1
end


function MessageHandle.addHandle(id,func,autoRemoveOrHost)
    print("addHandle添加管理的消息:"..id)
    local host=autoRemoveOrHost or 0
	if id==nil then
		print('MessageHandle:addHandle arg #1 is nil')
		return 
	end
	if func==nil or type(func)~='function' then
		print('MessageHandle:addHandle arg #2 is not a function')
		return 
	end
    if autoRemoveOrHost and autoRemoveOrHost==true then
	    if autoRemoveHandles[id]~=nil then
		    autoRemoveHandles[id]=nil
	    end
	    autoRemoveHandles[id]=func
    else
        if handles[host]==nil then
		        handles[host]={}
	    end
        handles[host][id]=func
        if host~=0 then
            if not table.containt(hosts,host) then
                table.insert(hosts,host)
            end
        end
    end
end 

function MessageHandle.removeHandle(hostOrId)
    local host=hostOrId or 0
	handles[host]=nil
    if host ~=0 then
        table.removebyvalue(hosts,host)
    end
end

function MessageHandle.clearHandles()
	--print('MessageHandle.clearHandles')
	handles={}
end


cc.exports.MessageHandle=MessageHandle



--endregion
