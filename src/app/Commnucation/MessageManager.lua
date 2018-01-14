
package.path = package.path .. ";./?.lua;./msg/?.lua"
local msg=MSG or {}
local function loadMessages()
require('app.proto.game_pb')
require('app.proto.hall_pb')
require('app.proto.matching_pb')

end
loadMessages()
msg.AllMessages = {

}

local function getMessage(id, hex)
	if id==nil then
		print('getMessage arg #1 is nil ')
		return nil
	end
	if hex==nil or type(hex)~='string' then
		print('getMessageByHex arg #1 is nil or not a string')
		return nil
	end
    local posi = 1
    local data = msg.AllMessages[id]
    if (data == nil) then
    	print('msg:'..id..' is nil')
        return nil0
    else
        data, posi = msg.ReadRef(hex, posi,data)
    end
    return data
end

local function getMessageByHex(hex)
	if hex==nil or type(hex)~='string' then
		print('getMessageByHex arg #1 is nil or not a string')
		return nil
	end
	local posi=1
	local id,posi=msg.ReadInt(hex,posi)
	print('getMessageByHex:',id)

	local strHex=string.sub(hex,posi)
	--print(strHex)
	return getMessage(id,strHex)
	--return nil
end

msg.GetMessage=getMessage
msg.GetMessageByHex=getMessageByHex
cc.exports.MSG=msg

cc.exports.reloadMessages=function()
package.loaded['app.proto.game_pb']=nil
package.loaded['app.proto.hall_pb']=nil
package.loaded['app.proto.matching_pb']=nil

loadMessages()
end
