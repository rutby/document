
---
--- Created by shimin.
--- DateTime: 2022/3/9 20:22
--- 联盟职业管理器
---
local AllianceCareerManager = BaseClass("AllianceCareerManager");

local function __init(self)
   
end

local function __delete(self)
   
end

local function Startup()
end

local function Enabled()
    return LuaEntry.DataConfig:CheckSwitch("alliance_career")
end

--设置联盟成员职业坑位
local function SendSetPos(self,list)
    if list ~= nil then
        for k,v in pairs(list) do
            local memberInfo = DataCenter.AllianceMemberDataManager:GetAllianceMemberByUid(k)
            if memberInfo ~= nil then
                memberInfo:SetCareerPos(v)
            end
        end
        local param = {}
        param.arr = list
        SFSNetwork.SendMessage(MsgDefines.SetAllianceCareerPos,param)
    end
end

local function IsCanSetCareer(self)
    if DataCenter.AllianceBaseDataManager:GetAllianceBaseData() == nil then
        return false
    end

    if not self:Enabled() then
        return false
    end
    
    local k4 = LuaEntry.DataConfig:TryGetStr("player_career", "k4")
    if k4 ~=nil and k4 ~= "" then
        local selfRank = DataCenter.AllianceBaseDataManager:GetSelfRank()
        local para = string.split_ii_array(k4,";")
        for k,v in ipairs(para) do
            if v == selfRank then
                return true
            end
        end
    end
    return false
end

local function GetAllianceMemberPosListByCareer(self,careerType)
    local list ={}
    local all = DataCenter.AllianceMemberDataManager:GetAllMember()
    if all ~= nil then
        for k,v in pairs(all) do
            if v.careerType == careerType and v.careerPos == AllianceCareerPosType.Yes then
                table.insert(list,v)
            end
        end

        table.sort(list, function(a, b)
            if a.careerLv ~= b.careerLv then
                return a.careerLv > b.careerLv
            else
                return a.uid < b.uid
            end
        end)
    end
    return list
end

local function GetAllianceMemberListByCareer(self,careerType)
    local list ={}
    local all = DataCenter.AllianceMemberDataManager:GetAllMember()
    if all ~= nil then
        for k,v in pairs(all) do
            if v.careerType == careerType then
                table.insert(list,v)
            end
        end

        table.sort(list, function(a, b)
            if a.careerPos ~= b.careerPos then
                return a.careerPos == AllianceCareerPosType.No
            elseif a.careerLv ~= b.careerLv then
                return a.careerLv > b.careerLv
            else
                return a.uid < b.uid
            end
        end)
    end
    return list
end

local function GetCareerMaxNum(self, careerType)
    local list = self:GetCareerMaxNumList()
    for _, v in ipairs(list) do
        if v.careerType == careerType then
            return v.max
        end
    end
    return 0
end

local function GetCareerMaxNumList(self)
    local result = {}
    local temp = LuaEntry.DataConfig:TryGetStr("player_career", "k3")
    if temp ~=nil and temp ~= "" then
        local para = string.split_ss_array(temp,"|")
        for k,v in ipairs(para) do
            local para1 = string.split_ii_array(v,";")
            if table.count(para1) > 1 then
                local param = {}
                param.careerType = para1[1]
                param.max = para1[2]
                table.insert(result,param)
            end
        end
    end
    return result
end

local function GetRedNum(self)
    local result = 0
    local list = self:GetCareerMaxNumList()
    if list ~= nil then
        local yesDic = {}
        local noDic = {}
        local all = DataCenter.AllianceMemberDataManager:GetAllMember()
        if all ~= nil then
            for k,v in pairs(all) do
                if v.careerPos == AllianceCareerPosType.Yes then
                    if yesDic[v.careerType] == nil then
                        yesDic[v.careerType] = 1
                    else
                        yesDic[v.careerType] = yesDic[v.careerType] + 1
                    end
                elseif v.careerPos == AllianceCareerPosType.No then
                    if noDic[v.careerType] == nil then
                        noDic[v.careerType] = 1
                    else
                        noDic[v.careerType] = noDic[v.careerType] + 1
                    end
                end
            end
        end
        for k,v in ipairs(list) do
            if noDic[v.careerType] ~= nil then
                local cur = yesDic[v.careerType] == nil and 0 or yesDic[v.careerType]
                local left = v.max - cur
                if left > 0 and noDic[v.careerType] > 0 then
                    result = result + (noDic[v.careerType] > left and left or noDic[v.careerType])
                end
            end
        end
    end
    return result
end

-- 打开联盟职务编辑时，应默认选中的职业类型
local function GetEditDefaultCareerType(self)
    local careerType = CareerType.Admiral
    local list = self:GetCareerMaxNumList()
    if list ~= nil then
        local yesDic = {}
        local noDic = {}
        local all = DataCenter.AllianceMemberDataManager:GetAllMember()
        if all ~= nil then
            for k,v in pairs(all) do
                if v.careerPos == AllianceCareerPosType.Yes then
                    if yesDic[v.careerType] == nil then
                        yesDic[v.careerType] = 1
                    else
                        yesDic[v.careerType] = yesDic[v.careerType] + 1
                    end
                elseif v.careerPos == AllianceCareerPosType.No then
                    if noDic[v.careerType] == nil then
                        noDic[v.careerType] = 1
                    else
                        noDic[v.careerType] = noDic[v.careerType] + 1
                    end
                end
            end
        end
        for k,v in ipairs(list) do
            if noDic[v.careerType] ~= nil then
                local cur = yesDic[v.careerType] == nil and 0 or yesDic[v.careerType]
                local left = v.max - cur
                if left > 0 and noDic[v.careerType] > 0 then
                    return v.careerType -- 如果有红点，优先红点
                elseif noDic[v.careerType] > 0 then
                    careerType = v.careerType -- 其次有空闲玩家的
                end
            end
        end
    end
    return careerType
end

AllianceCareerManager.__init = __init
AllianceCareerManager.__delete = __delete
AllianceCareerManager.Enabled = Enabled
AllianceCareerManager.SendSetPos = SendSetPos
AllianceCareerManager.IsCanSetCareer = IsCanSetCareer
AllianceCareerManager.GetAllianceMemberPosListByCareer = GetAllianceMemberPosListByCareer
AllianceCareerManager.GetAllianceMemberListByCareer = GetAllianceMemberListByCareer
AllianceCareerManager.Startup = Startup
AllianceCareerManager.GetCareerMaxNum = GetCareerMaxNum
AllianceCareerManager.GetCareerMaxNumList = GetCareerMaxNumList
AllianceCareerManager.GetRedNum = GetRedNum
AllianceCareerManager.GetEditDefaultCareerType = GetEditDefaultCareerType

return AllianceCareerManager
