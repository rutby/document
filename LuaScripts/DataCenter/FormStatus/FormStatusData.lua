---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/1/9 15:12
---

local FormStatusData = BaseClass("FormStatusData")
local Localization = CS.GameEntry.Localization

local function __init(self)
    self.uuid = 0
    self.id = 0
    self.timeType = FormStatusType.TimeBase
    self.startTime = 0 -- 开始时间
    self.endTime = 0 -- 结束时间
    self.leftTimes = 0 -- 剩余次数
    self.fUuid = 0 -- 编队uuid
end

local function __delete(self)
    self.uuid = nil
    self.id = nil
    self.timeType = nil
    self.startTime = nil
    self.endTime = nil
    self.leftTimes = nil
    self.fUuid = nil
end

local function ParseServerData(self, serverData)
    self.uuid = serverData.uuid
    self.id = serverData.statusId
    self.timeType = serverData.timeType
    self.startTime = serverData.startTime
    self.endTime = serverData.endTime
    self.leftTimes = serverData.leftTimes
    self.fUuid = serverData.fUuid
end

local function GetDesc(self)
    local desc = ""
    local template = DataCenter.FormStatusManager:GetTemplate(self.id)
    if template.type2 == FormStatusType2.DirectAttackCity then
        desc = Localization:GetString(template.description)--[[ .. "\n\n" .. Localization:GetString("180222", self.leftTimes)]]
        local formName = FormationName[self:GetFormationIndex()]
        if formName then
            desc = desc .. "\n\n" .. Localization:GetString("180223") .. Localization:GetString(formName)
        end
    else
        desc = Localization:GetString(template.description) 
    end
    return desc
end

local function GetIcon(self)
    local icon = ""
    local template = DataCenter.FormStatusManager:GetTemplate(self.id)
    if template then
        icon = template:GetIcon()
    end
    return icon
end

local function GetFormationIndex(self)
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.fUuid)
    if formation ~= nil then
        return formation.index
    end
    return 0
end

FormStatusData.__init = __init
FormStatusData.__delete = __delete

FormStatusData.ParseServerData = ParseServerData
FormStatusData.GetDesc = GetDesc
FormStatusData.GetIcon = GetIcon
FormStatusData.GetFormationIndex = GetFormationIndex

return FormStatusData
