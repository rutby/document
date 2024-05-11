local StatusManager = BaseClass("StatusManager")
local Localization = CS.GameEntry.Localization



local function __init(self)
    self.warFeverConfirmFlag = true
    self.warFeverData = {}
    
end

local function __delete(self)
    self.warFeverConfirmFlag = nil
    self.warFeverData = {}
end

local function GetAllStatusItem(self, param)

    return LuaEntry.Effect:GetStatusMap()
    --return self.AllUseStatusItem
end

-- 读item 配置表得到 战争狂热对应的等级和时间
local function GetWarFeverData(self)
    if self.warFeverData==nil or table.count(self.warFeverData)<=0 then
        local value = LuaEntry.DataConfig:TryGetStr("war_attack", "k2")
        self.warFeverData = {}
        if value ~= nil and value ~= "" then
            local vec = string.split(value, "|")
            for k, v in ipairs(vec) do
                local vec1 = string.split(v, ";")
                if #vec1 >= 2 then
                    local levelStr = vec1[1]
                    if levelStr~=nil and levelStr~=nil then
                        local arr = string.split(levelStr,"-")
                        if #arr>=2 then
                            local min = tonumber(arr[1])
                            local max = tonumber(arr[2])
                            if min~=nil and max~=nil and min<=max then
                                for i=min,max do
                                    local need = {}
                                    need.level = tonumber(i)
                                    need.status = tonumber(vec1[2])
                                    table.insert(self.warFeverData, need)
                                end
                            end
                        end
                    end
                    
                end
            end
        end
    end
    
    return self.warFeverData
end

--通过大本等级得到 战争狂热status
local function GetWarFeverStatusTemplateByLevel(self, level)
    local warFeverData = self:GetWarFeverData()
    for i, v in pairs(warFeverData) do
        if level == v.level then
            local statItem = LocalController:instance():getLine(TableName.StatusTab, tostring(v.status))
            return statItem
        end
    end
end

-- 进攻集结侦查时判断是否开启框热状态弹框
local function ShowTipForWarFever(self)
    local needBrokenProtect = false
    local needConfirm = false
    local isPop = self:GetWarFeverConfirmFlag() -- 是否再次弹出
    local isFeverStatu = self:GetWarFeverStatusValue()-- 是否处于狂热状态
    
    --通过大本等级去得到是否会有战争狂热阶段
    local statuData = DataCenter.StatusManager:GetWarFeverStatusTemplateByLevel(DataCenter.BuildManager.MainLv)
    local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
    local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
    local content
    local title
    if  isPop and statuData ~= nil and isFeverStatu == nil then
        needConfirm = true
        title = Localization:GetString("100378")
        local time = math.modf(statuData.time/60)
        local effectDes = statuData.effect_num.."%"
       -- local time = UITimeManager:GetInstance():SecondToFmtStringForCountdown(statuData.time)
        if leftTime > 0 then
            content = Localization:GetString("129033", effectDes, time)
        else
            content = Localization:GetString("129029", effectDes, time)
        end
        --[[        UIUtil.ShowSecondMessage(title, 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
        
                end, function()
                end)]]
        
    end
    if leftTime > 0 then
        needBrokenProtect = true
    end
    if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        needBrokenProtect = false
        needConfirm =false
    end
    return needConfirm,statuData,title ,content,needBrokenProtect
end

local function GetWarFeverConfirmFlag(self)
    return self.warFeverConfirmFlag
end

local function SetWarFeverConfirmFlag(self, value)
    self.warFeverConfirmFlag = value
end


--判断是否战争狂热是否处于激活状态
local function GetWarFeverStatusValue(self)
    local param = nil
    local effectStatus = DataCenter.StatusManager:GetAllStatusItem()
    local now = UITimeManager:GetInstance():GetServerTime()
    local warFeverData = self:GetWarFeverData()
    for i, v in pairs(warFeverData) do
        local statusId = v.status
        if effectStatus~=nil and effectStatus[statusId]~=nil and now< effectStatus[statusId] then
            local statusDataTemp = LocalController:instance():getLine(TableName.StatusTab, tostring(statusId))
            if statusDataTemp~=nil then
                param ={}
                param.effect_num = statusDataTemp.effect_num
                param.endTime = effectStatus[statusDataTemp.id]
                param.effect = statusDataTemp.effect
                return param
            end
            
        end
    end
    
    if statusDataTemp~=nil then
        
    end
    return param
end


local function GetBuffTimeInfo(self, buffId)
    local intBuffId = tonumber(buffId)
    local effectStatus = DataCenter.StatusManager:GetAllStatusItem()
    if effectStatus[intBuffId] then
        local statItem = LocalController:instance():getLine(TableName.StatusTab,intBuffId)
        local param = {}
        param.endTime = effectStatus[intBuffId]
        param.totalTime = statItem.time*1000
        param.intKey = intBuffId
        return param
    end
end

local function GetBuffPerformanceInfo(self, buffId)
    local info = { modelName = "", troopState = 0 }
    local line = LocalController:instance():getLine(TableName.StatusTab, buffId)
    if line ~= nil then
        info.modelName = line.model or ""
        info.troopState = line.troop_state or 0
        
    end
    return info
end

StatusManager.__init = __init
StatusManager.__delete = __delete
StatusManager.GetWarFeverData = GetWarFeverData
StatusManager.GetWarFeverStatusTemplateByLevel = GetWarFeverStatusTemplateByLevel
StatusManager.ShowTipForWarFever = ShowTipForWarFever
StatusManager.GetAllStatusItem = GetAllStatusItem
StatusManager.GetWarFeverConfirmFlag = GetWarFeverConfirmFlag
StatusManager.SetWarFeverConfirmFlag = SetWarFeverConfirmFlag
StatusManager.GetWarFeverStatusValue = GetWarFeverStatusValue
StatusManager.GetBuffTimeInfo = GetBuffTimeInfo
StatusManager.GetBuffPerformanceInfo = GetBuffPerformanceInfo

return StatusManager