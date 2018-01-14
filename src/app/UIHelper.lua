local UIHelper=UIHelper or {}

local LogIsOpen = false

--绑定按钮点击事件
function UIHelper.BindClickByButton( btn,func,eventall,voicename)
	if btn==nil or func==nil then
		return
	end
    
	btn:addTouchEventListener(function(btn, event)
        if event==TOUCH_EVENT_BEGAN  then
            btn:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,0.9)))
            if eventall==true then
                func(btn, event)
            end
        elseif event==TOUCH_EVENT_ENDED then
            local action=cc.Sequence:create(cc.ScaleTo:create(0.2,1.1),cc.ScaleTo:create(0.2,1.0),cc.CallFunc:create( function()
            end ))
            action:setTag(1)
            btn:runAction(action)
            local btnsound=func(btn, event)
            local name= voicename or btnsound or  s_sound[65].resouce
            SoundHelper.playMusicSound(65,0,false)
        elseif event==TOUCH_EVENT_CANCELED then
            local action=cc.Sequence:create(cc.ScaleTo:create(0.2,1.1),cc.ScaleTo:create(0.2,1.0),cc.CallFunc:create( function()
            end ))
            action:setTag(1)
            btn:runAction(action)
        end
    end)
end

--绑定多个按钮点击事件
function UIHelper.BindClickByButtons( btns,func,eventall,voicename)
	if btns==nil or func==nil then
		return
	end
    for _,btn in pairs(btns) do
        if btn.addTouchEventListener then
	        btn:addTouchEventListener(function(btn, event)
                if event==TOUCH_EVENT_BEGAN  then
                    btn:runAction(cc.Sequence:create(cc.ScaleTo:create(0.2,0.9)))
                    if eventall==true then
                        func(btn, event)
                    end
                elseif event==TOUCH_EVENT_ENDED then
                    local action=cc.Sequence:create(cc.ScaleTo:create(0.2,1.1),cc.ScaleTo:create(0.2,1.0),cc.CallFunc:create( function()
                    end ))
                    action:setTag(1)
                    btn:runAction(action)
                    local btnsound=func(btn, event)
                    local name= voicename or btnsound or  s_sound[65].resouce
                    SoundHelper.playMusicSound(65,0,false)
                elseif event==TOUCH_EVENT_CANCELED then
                    local action=cc.Sequence:create(cc.ScaleTo:create(0.2,1.1),cc.ScaleTo:create(0.2,1.0),cc.CallFunc:create( function()
                    end ))
                    action:setTag(1)
                    btn:runAction(action)
                end
            end)
        end
    end
end

--绑定多个复选框点击事件
function UIHelper.BindClickByCheckBoxs(checkBoxs, func)
    if checkBoxs==nil or func==nil then
		return
	end
    for _,checkBox in pairs(checkBoxs) do
        if checkBox.addEventListener then
	        checkBox:addEventListener(func)
        end
    end
end

--绑定复选框点击事件
function UIHelper.BindClickByCheckBox(checkBox, func,textfeild)
    if checkBox==nil or func==nil then
		return
	end

	checkBox:addEventListener(function(sender,event)
        func(checkBox,event)
    end)

    if textfeild~=nil then
       local layout = ccui.Layout:create()
       layout:setContentSize(textfeild:getContentSize())
       layout:setPosition(textfeild:getPosition())
       layout:setAnchorPoint(textfeild:getAnchorPoint())
       layout:setTouchEnabled(true)
       checkBox:addChild(layout)
       if layout.addTouchEventListener then
            layout:addTouchEventListener(function(layout, event)
                if event==TOUCH_EVENT_BEGAN  then
                elseif event==TOUCH_EVENT_ENDED then
                    if checkBox:isSelected() then
                       checkBox:setSelected(false)
                    else
                       checkBox:setSelected(true)
                    end
                    func(checkBox, event)
                elseif event==TOUCH_EVENT_CANCELED then
                end
            end)
       end
    end
end

--绑定按钮动作
function UIHelper.bindButtonAction(root, btnName, actionObj, times)
    if root == nil or actionObj == nil then
        return
    end

    local btnNode = root:getChildByName(btnName)
    if btnNode==nil then
        print("Can not find "..btnName.. " from csb")
    else
	    btnNode:addClickEventListener(func)
    end
    if times < 0 then
        btnNode:runAction(cc.RepeatForever:create(actionObj))    
    elseif times == 0 then
        btnNode:runAction(actionObj)
    elseif times > 0 then
        btnNode:runAction(cc.Repeat:create(actionObj, times))
    end
end

--设置按钮状态(normal or pressed or disabled)
function UIHelper.setButtonStatus(btn, isenbale,children)
    if btn==nil then
        print("btn is nil")
        return
    end

    btn:setEnabled(isenbale)
    --btn:setBright(isenbale)

    if children~=nil and isenbale==false then
        children:getVirtualRenderer():setState(1)
    elseif children~=nil and isenbale==true  then
        children:getVirtualRenderer():setState(0)
    end
end

--设置按钮状态(normal or pressed or disabled)
function UIHelper.setButtonStatusByName(root, btnName, status)
    if root == nil then
        return
    end

    if type(status) ~= "string" then
        status = "normal"
    end

    local btn = root:getChildByName(btnName)
    if btn==nil then
        print("Can not find "..btnName.. " from csb")
        return
    end
    if status == "normal" then
        btn:setEnabled(true)
        btn:setBright(true)
    elseif status == "pressed" then
        btn:setEnabled(true)
        btn:setBright(true)
    elseif status == "disabled" then
        btn:setEnabled(false)
        btn:setBright(false)
    end
end

--查找UI节点
function UIHelper.getNode(node,path)
    local result=nil
    if not node then
        print("node is nil in UIHelper.getNode")
        return result
    end

    local tmpNode=node
    local currPath=""
    local pathtable=path

    table.foreach(pathtable,function(_,v)
        if type(v)=="string" then
            tmpNode=tmpNode:getChildByName(v)
            if tmpNode then 
                currPath=currPath.."["..v.."] "
            else
                printError("get a nil node in path:"..currPath)
                return nil
            end
        elseif type(v)=="number" then
            tmpNode=tmpNode:getChildByTag(v)
            if tmpNode then 
                currPath=currPath..v.." "
            else
                printError("get a nil node in path:"..currPath)
                return nil
            end
        else
            printError("Unknow path node type in "..currPath)
            return nil
        end
        result=tmpNode
    end)
    return result
end

function UIHelper.checkboxGroup(container,id,func,...)
    local chbs={...}
    container["chbs__"..id]=chbs
    local onCheckEvent=function(sender,event)
            if event==0 then                
                table.foreach(chbs,function(i,v) 
                    v:setSelected(v==sender)
                    if v==sender and func then
                        func(sender,event)
                    end
                end)
            end
        end
    table.foreach(chbs,function(i,v) 
        v:addEventListener(onCheckEvent)
    end)

end

function UIHelper.packButtonAction(root, btnName, isEnabled)
    if root == nil then
        return
    end
    isEnabled = isEnabled or false

    local btn = root:getChildByName(btnName)
    if btn==nil then
        print("Can not find "..btnName.. " from csb")
        return
    end
    if not btn then
        printError("can not find button "..btnName.."in UIHelper.packButtonAction")
        return
    end
    btn:setPressedActionEnabled(isEnabled)
end

--转换LoadingBar为ProgressTimer
function UIHelper.ConvertLoadingBar2ProgressTimer(bar)
    local lastPercent=bar:getPercent()
    bar:setPercent(100)
    local timeBar = cc.ProgressTimer:create(bar:getVirtualRenderer():getSprite())
    timeBar:setType(kCCProgressTimerTypeBar)
    timeBar:setPercentage(lastPercent)
    --timeBar:setContentSize(bar:getContentSize())
    if bar:getDirection()==0 then
        --left
        timeBar:setMidpoint(cc.p(0, 0))
        timeBar:setBarChangeRate(cc.p(1, 0))
    else
        timeBar:setMidpoint(cc.p(1, 0))
        timeBar:setBarChangeRate(cc.p(-1, 0))
    end
    bar:getParent():addChild(timeBar)
    timeBar:setPosition(bar:getPosition())
    timeBar:setAnchorPoint(bar:getAnchorPoint())
    bar:removeFromParent()
    return timeBar
end

function UIHelper.ConvertTextField2EditBox(node)
    local editBox=ccui.EditBox:create(node:getContentSize(),"")
    editBox:setContentSize(node:getContentSize())
    editBox:setPlaceHolder(node:getPlaceHolder())
    editBox:setPlaceholderFontSize(node:getFontSize())
    editBox:setPlaceholderFontColor(cc.c3b(102,76,150))
    editBox:setAnchorPoint(node:getAnchorPoint())
    editBox:setPosition(node:getPosition())
    editBox:setText(node:getString())
    editBox:setFont(DEFAULTFONT,node:getFontSize())
    editBox:setInputFlag(1)
    editBox:setFontColor(cc.c3b(102,76,150))
    node:getParent():addChild(editBox)
    node:removeFromParent()
    editBox.setString=editBox.setText
    editBox.getString=editBox.getText
    editBox:setReturnType(1) --发送
    editBox:setInputMode(6) --不允许换行
    return editBox
end

function UIHelper.ShowLevelNum(level)
     
    local node =  cc.Node:create()

    if level > 10 then
        local sprite1 =  cc.Sprite:createWithSpriteFrameName(""..math.floor(level/10)..".png")
        local sprite2 =  cc.Sprite:createWithSpriteFrameName(""..(level%10)..".png")
        sprite1:setAnchorPoint(cc.p(0,0.5))
        sprite2:setAnchorPoint(cc.p(1,0.5))
        node:addChild(sprite1)
        node:addChild(sprite2)
        sprite1:setScale(0.3)
        sprite2:setScale(0.3)
    else
       local sprite1 =  cc.Sprite:createWithSpriteFrameName(""..level..".png")
       node:addChild(sprite1)
       sprite1:setScale(0.3)
    end

    return node
end

function UIHelper.getCreateTime2(overtime)
    --比赛时间
    local time= overtime
    local str = ""
    local day= math.floor( time/(3600*24) )
	local hour = math.floor( time/3600 ) - day * 24
	local minute = math.floor( time/60 ) - day * 24 *60 - hour * 60
	local second = time - day * 24 *60*60 - hour * 60 * 60 - minute * 60

    if day>0 then
        str= day .."天 "
    end

    if hour>0 then
        str=str.. hour.."小时 "
    end

    if minute>0 then
        str=str..minute.."分钟"
    end
    if hour>0 then
        str=str..""
    else
        str=str.." "..second.."秒"
    end
    
    return str
end

function UIHelper:escape(w)  
    pattern="[^%w%d%._%-%* ]"  
    s=string.gsub(w,pattern,function(c)  
        local c=string.format("%%%02X",string.byte(c))  
        return c  
    end)  
    s=string.gsub(s," ","+")  
    return s  
end

function UIHelper:detail_escape(w)  
    local t={}  
    for i=1,#w do  
        c = string.sub(w,i,i)  
        b,e = string.find(c,"[%w%d%._%-'%* ]")  
        if not b then  
            t[#t+1]=string.format("%%%02X",string.byte(c))  
        else  
            t[#t+1]=c  
        end  
    end  
    s = table.concat(t)  
    s = string.gsub(s," ","+")  
    return s  
end  
  
function UIHelper:unescape(w)  
    s=string.gsub(w,"+"," ")  
    s,n = string.gsub(s,"%%(%x%x)",function(c)  
        return string.char(tonumber(c,16))  
    end)  
    return s  
end    

function UIHelper.loadImgUrl(perant, imgUrl,username)
    local fullFileName = cc.FileUtils:getInstance():getWritablePath() .. "update/"..username..".png"
    local file = io.open(fullFileName,"r")

    if file==nil then --没有这张图片就需要下载
        if imgUrl == nil or imgUrl == "" then
            perant:loadTexture("10001.png",ccui.TextureResType.plistType)
        else
           local xhr=MSG.newXMLHttpRequest()
           print("没有头像,去微信上下载头像,地址:"..imgUrl)
           imgUrl = string.sub(imgUrl,1,-2)
           imgUrl = imgUrl.."132"
           --print(imgUrl)
           MSG.getHttp(xhr,imgUrl, function()
               --print("头像下载xhr.readyState is:", xhr.readyState, "头像下载xhr.status is: ", xhr.status)
               if xhr.readyState == 4 and (xhr.status >= 200 and xhr.status < 207) then
                  local fileData = xhr.response
                  file = io.open(fullFileName,"wb")
                  file:write(fileData)
                  file:close()
                  local sprite=cc.Sprite:create(fullFileName)
                  if sprite~=nil then
                    sprite:setScale(perant:getContentSize().width/132)
                    perant:addChild(sprite)
                    sprite:setPosition(perant:getContentSize().width/2,perant:getContentSize().height/2)
                  end
                  --print("头像下载完成,保存路径:"..fullFileName)
               end
           end)
        end
    else
        --print(fullFileName)
        local sprite=cc.Sprite:create(fullFileName)
        sprite:setScale(perant:getContentSize().width/132)
        perant:addChild(sprite)
        sprite:setPosition(perant:getContentSize().width/2,perant:getContentSize().height/2)
    end
end

--local uiItemPool = {}
--function UIHelper.saveItem(itemPoolName,item)

--end

--function UIHelper.getItem(itemPoolName)

--end

return UIHelper