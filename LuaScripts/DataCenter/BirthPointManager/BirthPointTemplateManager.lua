---
--- Created by shimin.
--- DateTime: 2021/7/29 8:28
---
local BirthPointTemplateManager = BaseClass("BirthPointTemplateManager");

local function __init(self)
    self.allianceCityPos = {}
    self.startX = nil
    self.startY = nil
    self.spaceX = nil
    self.spaceY = nil
    self.genRadius = nil
    self.bornNew = true --新旧开关
    self.blackLandLeftUp = {}
    self.blackLandLeftUp.x = -1
    self.blackLandLeftUp.y = -1
    self.blackLandLeftDown = {}
    self.blackLandLeftDown.x = -1
    self.blackLandLeftDown.y = -1
    self.blackLandRightUp = {}
    self.blackLandRightUp.x = -1
    self.blackLandRightUp.y = -1
    self.blackLandRightDown = {}
    self.blackLandRightDown.x = -1
    self.blackLandRightDown.y = -1
    self.blackLandDecSpeedArr = {}
end

local function __delete(self)
    self.bornNew = nil
    self.allianceCityPos = nil
    self.startX = nil
    self.startY = nil
    self.spaceX = nil
    self.spaceY = nil
    self.genRadius = nil
end

local function InitAllBirthPoint(self)
    local mainRange = LuaEntry.DataConfig:TryGetNum("NPC_city_range", "k1")
    local otherRange = LuaEntry.DataConfig:TryGetNum("NPC_city_range", "k3")
    local chooseType = ServerType.NORMAL
    if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
        chooseType = ServerType.EDEN_SERVER
    end
    LocalController:instance():visitTable(TableName.WorldCity,function(id,lineData)
        local location = lineData:getValue("location")
        local size = lineData:getValue("size")
        local server_type = tonumber(lineData:getValue("server_type"))
        if server_type == nil then
            server_type = ServerType.NORMAL
        end
        --local city_type = tonumber(lineData:getValue("eden_city_type"))
        --if city_type ==nil then
        --    city_type = WorldCityType.AllianceCity
        --end
        
        if server_type == chooseType then
            if location~=nil and size~=nil then
                local tile = math.floor(size/2)
                local pos = string.split(location,"|")
                if #pos>1 then
                    local i = tonumber(pos[1])-tile
                    local j = tonumber(pos[2])-tile
                    local item = {}
                    item.x = i
                    item.y = j
                    item.size = otherRange
                    local level = lineData:getValue("level")
                    if tonumber(level) == 7 then
                        item.size = mainRange
                    end
                    table.insert(self.allianceCityPos,item)

                end
            end
        end
        
    end)
end

local function InitBornPointList(self)
    self.bornNew = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k6") == 1
    self.startX = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k1")
    self.startY = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k2")
    self.spaceX = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k3")
    self.spaceY = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k4")
    self.genRadius = LuaEntry.DataConfig:TryGetNum("gen_born_point_param", "k5")

    local rangeStr = LuaEntry.DataConfig:TryGetStr("wonder_rocky_ground", "k1")
    if rangeStr~=nil and rangeStr~="" then
        local arr = string.split(rangeStr,"|")
        if arr~=nil and #arr>=4 then
            local a = arr[1]
            local aArr = string.split(a,";")
            if aArr~=nil and #aArr>=2 then
                self.blackLandLeftUp.x = tonumber(aArr[1])
                self.blackLandLeftUp.y = tonumber(aArr[2])
            end
            local b = arr[2]
            local bArr = string.split(b,";")
            if bArr~=nil and #bArr>=2 then
                self.blackLandRightUp.x = tonumber(bArr[1])
                self.blackLandRightUp.y = tonumber(bArr[2])
            end
            local c = arr[3]
            local cArr = string.split(c,";")
            if cArr~=nil and #cArr>=2 then
                self.blackLandLeftDown.x = tonumber(cArr[1])
                self.blackLandLeftDown.y = tonumber(cArr[2])
            end
            local d = arr[4]
            local dArr = string.split(d,";")
            if dArr~=nil and #dArr>=2 then
                self.blackLandRightDown.x = tonumber(dArr[1])
                self.blackLandRightDown.y = tonumber(dArr[2])
            end
        end
    end

    local blackLandSpeed = LuaEntry.DataConfig:TryGetStr("wonder_rocky_ground", "k2")
    if blackLandSpeed~=nil and blackLandSpeed~="" then
        self.blackLandDecSpeedArr = {}
        local arr = string.split(blackLandSpeed,"|")
        if arr~=nil and #arr>=1 then
            for i=1,#arr do
                local str = arr[i]
                local serverArr = string.split(str,";")
                if serverArr~=nil and #serverArr>1 then
                    local serverStr = serverArr[1]
                    local speed = tonumber(serverArr[2])
                    local serverNumArr = string.split(serverStr,"-")
                    if serverNumArr~=nil and #serverNumArr>1 then
                        local min = tonumber(serverNumArr[1])
                        local max = tonumber(serverNumArr[2])
                        for j = min,max do
                            self.blackLandDecSpeedArr[j] = speed
                        end
                    end
                end
            end
        end
    end
end

local function GetBlackLandRange(self)
    return self.blackLandLeftUp,self.blackLandRightUp,self.blackLandLeftDown,self.blackLandRightDown
end

local function GetBlackLandSpeedByServerId(self,serverId)
    if LuaEntry.Player.serverType == ServerType.NORMAL and self.blackLandDecSpeedArr[serverId]~=nil then
        return self.blackLandDecSpeedArr[serverId]
    end
    return 1
end

local function IsBirthPointInMap(self,x,y,radius)
    local minX = x-radius
    local maxX = x+radius
    local minY = y-radius
    local maxY = y+radius
    return minX>=0 and maxX< WorldTileCount and  minY>=0 and maxY< WorldTileCount
end
local function IsBirthPoint(self,x,y)
    if self.bornNew then
        local realX = x - self.startX
        local realY = y - self.startY
        if realX >= 0 and realX % self.spaceX == 0 and realY >= 0 and realY % self.spaceY == 0 and self:IsBirthPointInMap(x, y, self.genRadius) then
            return true
        end
        return false
    end
    
    local xBlock = x % BlockSize
    local yBlock = y % BlockSize

    local realX = xBlock - self.startX
    local realY = yBlock - self.startY
    if realX >= 0 and realX % self.spaceX == 0 and realY >= 0 and realY % self.spaceY == 0 and self:IsBirthPointInMap(x, y, self.genRadius) then
        return true
    end
    return false
end

local function IsInAllianceCityRange(self,x,y)
    for k,v in pairs(self.allianceCityPos) do
        local circle = math.ceil((v.size - 1) / 2)
		local distanceX = math.abs(v.x - x)
		local distanceY = math.abs(v.y - y)
        if distanceX<=circle and distanceY<=circle then
            return true
        end
    end
    return false
end
--获取minX <= x <= maxX and minY <= y <= maxY范围内所有出生点
local function GetBirthPointsTemplateByRange(self,minX,maxX,minY,maxY)
    local result = {}
    if self.bornNew then
        local temp,durMinX,durMinY,durMaxX,durMaxY,realMinX,realMinY,realMaxX,realMaxY
        durMinX,temp = math.modf((minX - self.startX) / self.spaceX)
        durMinY,temp = math.modf((minY - self.startY) / self.spaceY)
        durMaxX,temp = math.modf((maxX - self.startX) / self.spaceX)
        durMaxY,temp = math.modf((maxY - self.startY) / self.spaceY)
        realMinX = self.startX + durMinX * self.spaceX
        realMinY = self.startY + durMinY * self.spaceY
        realMaxX = self.startX + durMaxX * self.spaceX
        realMaxY = self.startY + durMaxY * self.spaceY
        realMinX = realMinX >= minX and realMinX or (realMinX + self.spaceX)
        realMinY = realMinY >= minY and realMinY or (realMinY + self.spaceY)
        realMaxX = realMaxX <= maxX and realMaxX or (realMaxX - self.spaceX)
        realMaxY = realMaxY <= maxY and realMaxY or (realMaxY - self.spaceY)
        if realMinX <= realMaxX and realMinY <= realMaxY then
            for i = realMinX ,realMaxX ,self.spaceX do
                for j = realMinY ,realMaxY ,self.spaceY do
                    if self:IsBirthPoint(i,j) then
                        table.insert(result,{x = i,y = j})
                    end
                end
            end
        end
    else
        if minX <= maxX and minY <= maxY then
            for i = minX ,maxX ,1 do
                for j = minY ,maxY ,1 do
                    if self:IsBirthPoint(i,j) then
                        table.insert(result,{x = i,y = j})
                    end
                end
            end
        end
    end
   
    return result
end

--获取大本范围内八方向大本坐标(共9个点，包括自己)
local function GetPointInMyBaseRange(self,x,y)
    return self:GetBirthPointsTemplateByRange(x - self.spaceX,x + self.spaceX,y - self.spaceY,y + self.spaceY)
end

--获取以出生点x y为中心-offsetX到offsetX -offsetY到offsetY的所有出生点
local function GetAllPointsByOffset(self,x,y,offsetX,offsetY)
    if self:IsBirthPoint(x,y) then
        local result = {}
        local curX = x
        local curY = y
        for i = -offsetX, offsetX, 1 do
            curX = x + i * self.spaceX
            for j = -offsetY, offsetY, 1 do
                curY = y + j * self.spaceY
                table.insert(result,{x = curX,y = curY})
            end
        end
        return result
    end
    
end

--引导获取最近的敌人的假点
local function GetPointByFakePlayer(self)
    local moveDistanceX = 10
    local moveTrueDistanceX = 6
    local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if mainBuild ~= nil then
        local vec2 = SceneUtils.IndexToTilePos(mainBuild.pointId)
        local x = vec2.x
        local y = vec2.y
        local isRight = self:IsBirthPoint(x + self.spaceX * moveDistanceX, y)
        local isTop = self:IsBirthPoint(x, y + self.spaceY * moveDistanceX)
        local isDown = self:IsBirthPoint(x, y - self.spaceY * moveDistanceX)
        
        if isRight then
            if isTop and isDown then
                return SceneUtils.TileToWorld({x = x + self.spaceX * moveTrueDistanceX , y = y})
            elseif isTop then
                return SceneUtils.TileToWorld({x = x + self.spaceX * moveTrueDistanceX , y = y + self.spaceY * moveTrueDistanceX})
            else
                return SceneUtils.TileToWorld({x = x + self.spaceX * moveTrueDistanceX , y = y - self.spaceY * moveTrueDistanceX})
            end
        else
            if isTop and isDown then
                return SceneUtils.TileToWorld({x = x - self.spaceX * moveTrueDistanceX , y = y})
            elseif isTop then
                return SceneUtils.TileToWorld({x = x - self.spaceX * moveTrueDistanceX , y = y + self.spaceY * moveTrueDistanceX})
            else
                return SceneUtils.TileToWorld({x = x - self.spaceX * moveTrueDistanceX , y = y - self.spaceY * moveTrueDistanceX})
            end
        end
    end
end

BirthPointTemplateManager.__init = __init
BirthPointTemplateManager.__delete = __delete
BirthPointTemplateManager.InitAllBirthPoint = InitAllBirthPoint
BirthPointTemplateManager.IsBirthPoint = IsBirthPoint
BirthPointTemplateManager.GetBirthPointsTemplateByRange = GetBirthPointsTemplateByRange
BirthPointTemplateManager.IsInAllianceCityRange= IsInAllianceCityRange
BirthPointTemplateManager.GetPointInMyBaseRange= GetPointInMyBaseRange
BirthPointTemplateManager.IsBirthPointInMap =IsBirthPointInMap
BirthPointTemplateManager.InitBornPointList =InitBornPointList
BirthPointTemplateManager.GetAllPointsByOffset =GetAllPointsByOffset
BirthPointTemplateManager.GetPointByFakePlayer =GetPointByFakePlayer
BirthPointTemplateManager.GetBlackLandRange= GetBlackLandRange
BirthPointTemplateManager.GetBlackLandSpeedByServerId = GetBlackLandSpeedByServerId
return BirthPointTemplateManager
