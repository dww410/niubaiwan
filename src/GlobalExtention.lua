--region *.lua
--Date
--此文件由[BabeLua]插件自动生成
-- User: CongQin
-- Date: 16/04/06

cc.exports.uploadResout = function() print('uploadResout') end

cc.exports.AutoInRoom = function() print('AutoInRoom') end

cc.exports.StopRecodCallback = function() print('StopRecodCallback') end

--是否tab中包含v
table.containt = function(tab, val)
    if tab then
        for _, item in ipairs(tab) do
            if item == val then
                return true
            end
        end
    end
    return false
end


--绑定节点到node
cc.Node.BindNodes = function(self, root, ...)
    if not self then
        printError("self is nil in BindNodes")
    end
    if not root then
        printError("self is nil in BindNodes")
    end

    for i, v in ipairs({ ... }) do
        local tmpNode = root
        if type(v) == "string" then
            local path = string.split(v, ".")
            local curPath = ""
            local idx = 1
            for _, n in pairs(path) do
                if string.match(n, "%[%d+%]") then
                    n = string.sub(n, 2, string.len(n) - 2)
                    if self[n] then
                        tmpNode = self[n]
                    else
                        tmpNode = tmpNode:getChildByTag(n)
                    end
                    curPath = curPath .. "[" .. n .. "] "
                else
                    if self[n] then
                        tmpNode = self[n]
                    else
                        tmpNode = tmpNode:getChildByName(n)
                    end
                    curPath = curPath .. n .. " "
                end
                if not tmpNode then
                    printInfo("can not find node " .. curPath)
                    break
                elseif idx == table.getn(path) then
                    if self[n] then
                        printInfo(n .. " already in self")
                        break
                    else
                        self[n] = tmpNode
                    end
                end
                idx = idx + 1
            end
        else
            printError("args #" .. i .. " of BindNodes is not string")
        end
    end
end


--获取中心点
cc.Node.getCenter = function(node)
    return { x = node:getContentSize().width / 2, y = node:getContentSize().height / 2 }
end

--加载场景csb
cc.Node.loadSceneCSB = function(self, file)
    local csb = cc.CSLoader:createNode(file)
    csb:setContentSize(cc.Director:getInstance():getOpenGLView():getVisibleSize())
    ccui.Helper:doLayout(csb)
    csb:addTo(self)
    self.root = csb
    return csb
end

cc.Node.MyPrint = function(self, data, mytype)
    if mytype == 1 then
        print("MyPrint:" .. data)
    end
end

cc.Node.Print_t = function(t)
    if type(t) ~= "table" then
        print(t);
    else
        print('table\n{');
        for i, v in pairs(t) do
            if type(v) == "table" then
                print('[' .. i .. '] = ');
                print_t(v);
            elseif (v) then
                print('  [' .. i .. '] = ' .. v);
            end
        end
        print('}');
    end
end


cc.exports.PopsViewsNums = 0

--endregion
