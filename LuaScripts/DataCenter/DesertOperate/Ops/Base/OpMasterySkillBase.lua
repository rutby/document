---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/27 21:54
---

local OpMasterySkillBase = BaseClass("OpMasterySkillBase", OpBase)
local base = OpBase
local Localization = CS.GameEntry.Localization

local function Init(self, uuid)
    base.Init(self, uuid)
    self.state, self.endTime = DataCenter.MasteryManager:GetSkillState(self.skill)
    self.template = DataCenter.MasteryManager:GetTemplateBySkill(self.skill)
    self.skillTemplate = DataCenter.MasteryManager:GetSkillTemplate(self.skill)
end

local function SetSkill(self, skill)
    self.skill = skill
end

local function CanShow(self)
    if self.template == nil or self.skillTemplate == nil then
        return false
    end
    if self.state == MasterySkillState.None or
       self.state == MasterySkillState.Locked or
       self.state == MasterySkillState.Closed or
       self.state == MasterySkillState.NoUse then
        return false
    end
    local location = self.skillTemplate:getValue("location")
    if location == MasterySkillLocation.WorldBuild then
        return self:IsBuilding() and self.buildTemplate:IsSeasonBuild()
    elseif location == MasterySkillLocation.WorldDesert then
        return self:IsDesert() and self.desertData.ownerUid == LuaEntry.Player.uid
    elseif location == MasterySkillLocation.WorldFormation then
        return self:IsFormation()
    end
    return false
end

local function GetOrder(self)
    return 1e6 + self.skill
end

local function GetIcon(self)
    return string.format(LoadPath.UIMastery .. self.template.tempData:getValue("icon"))
end

local function GetTitle(self)
    return Localization:GetString(self.template:GetName())
end

local function GetDesc(self)
    return DataCenter.MasteryManager:GetDescStr(self.template.id)
end

local function GetBtnText(self)
    local dialog = nil
    if self.state == MasterySkillState.Closed or self.state == MasterySkillState.NoUse then
        dialog = 120105
    elseif self.state == MasterySkillState.Normal then
        dialog = 110046
    elseif self.state == MasterySkillState.Locked then
        dialog = 130056
    end
    return dialog and Localization:GetString(dialog) or ""
end

local function GetBtnState(self)
    if self.state == MasterySkillState.Closed or self.state == MasterySkillState.NoUse then
        return DesertOperateBtnState.Gray
    elseif self.state == MasterySkillState.Normal then
        return DesertOperateBtnState.Green
    elseif self.state == MasterySkillState.Locked then
        return DesertOperateBtnState.Yellow
    elseif self.state == MasterySkillState.CD then
        return DesertOperateBtnState.Gray
    end
    return DesertOperateBtnState.None
end

local function GetMaskPercent(self)
    if self.state == MasterySkillState.Normal or self.state == MasterySkillState.Locked then
        return 0
    elseif self.state == MasterySkillState.CD then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local restTime = self.endTime - curTime
        if restTime >= 0 then
            local cd = self.skillTemplate:getValue("cd")
            local percent = restTime / (cd * 1000)
            return percent
        end
    else
        return 1
    end
end

local function GetMaskDesc(self)
    return Localization:GetString("100381")
end

local function TimerAction(self, view, item)
    if self.state == MasterySkillState.CD then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local restTime = self.endTime - curTime
        if restTime >= 0 then
            item:SetBtnText(UITimeManager:GetInstance():MilliSecondToFmtString(restTime))
        else
            self.state, self.endTime = DataCenter.MasteryManager:GetSkillState(self.skill)
            item:Refresh()
        end
    end
end

OpMasterySkillBase.Init = Init
OpMasterySkillBase.SetSkill = SetSkill
OpMasterySkillBase.CanShow = CanShow
OpMasterySkillBase.GetOrder = GetOrder
OpMasterySkillBase.GetIcon = GetIcon
OpMasterySkillBase.GetTitle = GetTitle
OpMasterySkillBase.GetDesc = GetDesc
OpMasterySkillBase.GetBtnText = GetBtnText
OpMasterySkillBase.GetBtnState = GetBtnState
OpMasterySkillBase.GetMaskPercent = GetMaskPercent
OpMasterySkillBase.GetMaskDesc = GetMaskDesc
OpMasterySkillBase.TimerAction = TimerAction

return OpMasterySkillBase