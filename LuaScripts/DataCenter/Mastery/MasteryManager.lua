---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/6 15:54
---

local MasteryManager = BaseClass("MasteryManager")
local MasteryData = require "DataCenter.Mastery.MasteryData"
local Localization = CS.GameEntry.Localization

local RESET_ITEM_ID = 251110

local function __init(self)
    self.data = MasteryData.New()
    self.templateDict = {} -- Dict<id, MasteryTemplate>
    self.templateBySkillDict = {} -- Dict<skill, Dict<level, MasteryTemplate>>
    self.statusEndTimeDict = {} -- Dict<statusId, endTime>
    self.useSkillCallback = nil
    self.isTemplateDicInit = false
    
    self:AddListeners()
end

local function __delete(self)
    self:RemoveListeners()
end

local function AddListeners(self)
    
end

local function RemoveListeners(self)
    
end

local function Enabled(self)
    local season = DataCenter.SeasonDataManager:GetSeason() or 0
    local switchOn = LuaEntry.DataConfig:CheckSwitch("season_mastery")
    return season >= 1 and switchOn
end

local function IsHideEntrance(self)
    return LuaEntry.DataConfig:CheckSwitch("mastery_hide_entrance")
end

local function GetData(self)
    return self.data
end

local function GetPlan(self, index)
    return self.data:GetPlan(index)
end

local function GetCurPlan(self)
    if self.tempPlanIndex and self.tempPlanIndex ~= 0 and self.tempPlanIndex ~= self:GetCurPlanIndex() then
        return self.data:GetPlan(self.tempPlanIndex)
    end
    return self.data:GetCurPlan()
end

local function GetTemplate(self, group, lv)
    if self.isSkillDicInit == false then
        self:InitSkillDict()
    end
    lv = Mathf.Clamp(lv or 1, 1, MasteryLvCap - 1)
    local id = group * MasteryLvCap + lv
    return self:GetTemplateById(id)
end

local function InitTemplateDict(self)
    local nextsDict = {}
    LocalController:instance():visitTable(TableName.Mastery, function(id, line)
        local skill = line:getValue("linkSkill")
        local lv = line:getValue("Lv")
        local group = line:getValue("group")
        self.templateDict[id] = {}
        self.templateDict[id].group = group
        self.templateDict[id].skill = skill

        local priors = {}
        local condType = MasteryCondType.And
        local priorStr = line:getValue("priors") or ""
        if not string.IsNullOrEmpty(priorStr) then
            condType = string.contains(priorStr, "|") and MasteryCondType.Or or MasteryCondType.And
            for _, str in ipairs(string.split(tostring(priorStr), (condType == MasteryCondType.And) and ";" or "|")) do
                table.insert(priors, tonumber(str))
            end
        end
        local needPriorLv = {}
        local needTalentStr = line:getValue("needTalent") or ""
        if not string.IsNullOrEmpty(needTalentStr) then
            condType = string.contains(needTalentStr, "|") and MasteryCondType.Or or MasteryCondType.And
            for _, str in ipairs(string.split(tostring(needTalentStr), (condType == MasteryCondType.And) and ";" or "|")) do
                local spls = string.split(str, "_")
                if #spls > 0 then
                    needPriorLv[tonumber(spls[1])] = tonumber(spls[2]) or 1
                end
            end
        end
        self.templateDict[id].priors = priors
        self.templateDict[id].condType = condType
        self.templateDict[id].needPriorLv = needPriorLv
        if skill ~= 0 then
            if self.templateBySkillDict[skill] == nil then
                self.templateBySkillDict[skill] = {}
            end
            self.templateBySkillDict[skill][lv] = id
        end

        if lv == 1 then
            for _, prior in ipairs(priors) do
                nextsDict[prior] = nextsDict[prior] or {}
                table.insert(nextsDict[prior], group)
            end
        end
    end)

    for _, template in pairs(self.templateDict) do
        template.nexts = nextsDict[template.group] or {}
    end
    self.isTemplateDicInit = true
end
-- 如果当前没解锁就显示满级，解锁就显示当前等级
local function GetTemplateBySkill(self, skill, level)
    if self.isTemplateDicInit ==false then
        self:InitTemplateDict()
    end
    if self.templateBySkillDict[skill] == nil then
        return nil
    end
    
    if level == nil then
        local plan = self:GetCurPlan()
        local template = self:GetTemplateBySkill(skill, 1)
        if template then
            level = plan:GetGroupLevel(template.group)
            if level == 0 then
                level = template.maxLv
            end
        end
    end
    local id = self.templateBySkillDict[skill][level or 1]
    return self:GetTemplateById(id)
end

local function GetTemplateById(self, id)
    if self.isTemplateDicInit ==false then
        self:InitTemplateDict()
    end

    local value = self.templateDict[id]
    if value~=nil then
        local data = LocalController:instance():getLine(TableName.Mastery,id)
        value.tempData = data
    end
    return value
end

local function GetSkillTemplate(self, skill)
    return LocalController:instance():getLine(TableName.MasterySkill,skill)
end

local function GetGroupsByHome(self, home)
    local groups = {}
    local rootGroups = {}
    for _, template in pairs(self.templateDict) do
        if template.tempData:getValue("Lv") == 1 and template.tempData:getValue("home") == home then
            table.insert(groups, template.group)
            if #template.priors == 0 then
                table.insert(rootGroups, template.group)
            end
        end
    end
    return groups, rootGroups
end

local function GetRestExpToMaxLevel(self)
    local data = self:GetData()
    local curLevel = data.level
    local maxLevel = self:GetMaxLevel()
    if curLevel >= maxLevel then
        return 0
    end
    
    local totalExp = 0
    for level = curLevel, maxLevel - 1 do
        totalExp = totalExp + self:GetLevelMaxExp(level)
    end
    return totalExp - data.exp
end

local function GetMaxLevel(self)
    local season = DataCenter.SeasonDataManager:GetSeason() or 0
    return self:GetSeasonMaxLevel(season)
end

local function GetSeasonMaxLevel(self, season)
    if self.seasonMaxLevelDict == nil then
        self.seasonMaxLevelDict = {}
        local k1 = LuaEntry.DataConfig:TryGetStr('season_mastery_config', 'k1')
        local strs = string.split(k1, "|")
        for _, str in ipairs(strs) do
            local spls = string.split(str, ";")
            if #spls == 2 then
                self.seasonMaxLevelDict[tonumber(spls[1])] = tonumber(spls[2])
            end
        end
    end
    return self.seasonMaxLevelDict[season] or 0
end

local function GetHomeViewConfig(self)
    if self.homeViewConfig == nil then
        local k3 = LuaEntry.DataConfig:TryGetStr('season_mastery_config', 'k3')
        local spls = string.split(k3, ";")
        local config = {}
        config.moveSensitivity = tonumber(spls[1]) or 1
        config.movePadding = tonumber(spls[2]) or 300
        config.scaleSensitivity = tonumber(spls[3]) or 1
        config.scaleMin = tonumber(spls[4]) or 0.75
        config.scaleMax = tonumber(spls[5]) or 1.5
        config.scaleInit = tonumber(spls[6]) or 1
        self.homeViewConfig = config
    end
    return self.homeViewConfig
end

--基础页数+额外页数，如果有礼包的话使用时额外加一页
local function GetMasteryMaxPage(self)
    local k1 = LuaEntry.DataConfig:TryGetNum('season_mastery_config', 'k2')
    if self.data.extraPageNum then
        return k1 + self.data.extraPageNum
    end
    return k1
end

local function GetRestPoint(self)
    local plan = self:GetCurPlan()
    return plan.restPoint
end

local function GetStatusDict(self, statusId)
    if self.statusEndTimeDict[statusId] then
        return self.statusEndTimeDict[statusId]
    end
    return 0
end

--这个地方用level做id读取exp字段，依据的前提是表中id字段内容 = level字段内容
local function GetLevelMaxExp(self, level)
    return GetTableData(TableName.MasteryExp,level, "Exp")
end

local function GetAllSkills(self, location)
    local plan = self:GetCurPlan()
    local templates = {}
    for _, template in pairs(self.templateDict) do
        if template.skill ~= 0 then
            local skillTemplate = DataCenter.MasteryManager:GetSkillTemplate(template.skill)
            if skillTemplate then
                local isLocation = (location == nil) or (skillTemplate:getValue("location") == location)
                if isLocation and not table.hasvalue(templates, template) then
                    table.insert(templates, template)
                end
            end
        end
    end
    table.sort(templates, function(templateA, templateB)
        local levelA = plan:GetGroupLevel(templateA.group)
        local levelB = plan:GetGroupLevel(templateB.group)
        local AisClosed = templateA.tempData:getValue("isClose")==1
        local AnoUse = templateA.tempData:getValue("nouse")==1
        local BisClosed = templateB.tempData:getValue("isClose")==1
        local BnoUse = templateB.tempData:getValue("nouse")==1
        if not (AisClosed or AnoUse) and (BisClosed or BnoUse) then
            return true
        elseif (AisClosed or AnoUse) and not (BisClosed or BnoUse) then
            return false
        elseif levelA > 0 and levelB <= 0 then
            return true
        elseif levelA <= 0 and levelB > 0 then
            return false
        else
            return templateA.group < templateB.group
        end
    end)
    local skills = {}
    for _, template in ipairs(templates) do
        if not table.hasvalue(skills, template.skill) then
            table.insert(skills, template.skill)
        end
    end
    return skills
end

local function GetSkillState(self, skill)
    local template = self:GetTemplateBySkill(skill)
    if template == nil or template.tempData:getValue("isClose")==1 then
        return MasterySkillState.Closed, 0
    end
    if template.noUse then
        return MasterySkillState.NoUse, 0
    end
    local data = self:GetData()
    local plan = self:GetCurPlan()
    local level = plan:GetGroupLevel(template.group)
    if level <= 0 then
        return MasterySkillState.Locked, 0
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local cdTime = data:GetSkillCdTime(skill)
    if curTime < cdTime then
        return MasterySkillState.CD, cdTime
    end
    return MasterySkillState.Normal, 0
end

--获取方案名称
local function GetPageName(self,index)
    return self.data:GetPageName(index)
end

--获取当前专精页
local function GetCurPlanIndex(self)
    return self.data.planIndex
end

local function CheckBeforeUse(self, skill)
    local template = self:GetTemplateBySkill(skill)
    local skillTemplate = self:GetSkillTemplate(skill)
    if template == nil or skillTemplate == nil then
        return false
    end
    local plan = self:GetCurPlan()
    local level = plan:GetGroupLevel(template.group)
    if level == 0 then
        return false
    end
    if skill == MasterySkill.Harvest then -- 丰收
        local production = 0
        for _, buildId in ipairs({ BuildingTypes.FUN_BUILD_OUT_WOOD, BuildingTypes.FUN_BUILD_OUT_STONE }) do
            local list = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(buildId)
            for _, buildData in ipairs(list) do
                local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, buildData.level)
                production = production + tonumber(buildLevelTemplate.local_num[1]) or 0
            end
        end
    end
    return true
end

local function TryUseSkill(self, skill, param, callback)
    local template = DataCenter.MasteryManager:GetTemplateBySkill(skill)
    local state = self:GetSkillState(skill)
    if state == MasterySkillState.Normal then
        if self:CheckBeforeUse(skill) then
            UIUtil.ShowMessage(Localization:GetString("110726", Localization:GetString(self:GetName(template.tempData:getValue("id")))), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                DataCenter.MasteryManager:SendUseSkill(skill, param, callback)
            end)
        end
    elseif state == MasterySkillState.Locked then
        GoToUtil.CloseAllWindows()
        DataCenter.MasteryManager:ShowHome(template.tempData:getValue("home"), template.group)
    end
end

local function ResetPoint(self)
    local plan = self:GetCurPlan()
    local usePoint = plan:GetUsePoint()
    local itemData = DataCenter.ItemData:GetItemById(RESET_ITEM_ID)
    local itemCount = DataCenter.ItemData:GetItemCount(RESET_ITEM_ID)
    local itemCountStr = "<color=" .. (itemCount == 0 and "#F26A67" or "white") .. ">" .. itemCount .. "</color>/1"
    local dataList =
    {
        [1] =
        {
            rewardType = RewardType.GOODS,
            itemId = RESET_ITEM_ID,
            count = itemCountStr,
        }
    }
    local topDesc = Localization:GetString("110709", plan.index, usePoint)
    local onConfirm = function()
        if itemData and itemCount > 0 then
            SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = itemData.uuid, num = 1, useItemFromType = 0 })
        else
            UIUtil.ShowTipsId(120021)
        end
    end

    local param =
    {
        title = Localization:GetString("100378"),
        topDesc = topDesc,
        bottomDesc = "",
        dataList = dataList,
        onConfirm = onConfirm,
    }
    UIUtil.ShowUseItemTip(param)
end

local function IsHomeOpen(self, home)
    if self:IsHomeGray(home) then
        return false
    end
    local data = self:GetData()
    local template = self:GetTemplate(home)
    local needLv = template.tempData:getValue("needLv")
    return data.level >= needLv, needLv
end

local function IsHomeGray(self, home)
    -- k5 暂未开放
    local k5 = LuaEntry.DataConfig:TryGetStr('season_mastery_config', 'k5')
    if not string.IsNullOrEmpty(k5) then
        local spls = string.split(k5, ";")
        return table.hasvalue(spls, tostring(home))
    end
    return false
end

local function ShowHome(self, home, group, onClose)
    if self:IsHomeGray(home) then
        UIUtil.ShowTipsId(120105)
        return
    end
    local isOpen, needLv = self:IsHomeOpen(home)
    if isOpen then
        local tempPlanIndex = self:GetTempPlanIndex()
        local page = nil
        if tempPlanIndex and tempPlanIndex ~= 0 and tempPlanIndex ~= self:GetCurPlanIndex() then
            page = tempPlanIndex
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIMasteryHome, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, home, group, page, onClose)
    else
        UIUtil.ShowTips(Localization:GetString("110719", needLv))
    end
end

local function GetRedNum(self)
    if not self:Enabled() then
        return 0
    end
    return self:GetRestPoint()
end

local function HasLearntMastery(self, id)
    local group = id // MasteryLvCap
    local level = id % MasteryLvCap
    local template = self:GetTemplate(group, level)
    if template.tempData:getValue("isClose") == 1 or template.tempData:getValue("nouse") == 1 then
        return false
    end
    local plan = self:GetCurPlan()
    return plan:GetGroupLevel(group) >= level
end

local function ShowLearnTip(self, group, level)
    local template = self:GetTemplate(group, level)
    if template.skill~=0 or not template.tempData:getValue("overview") == 1 then
        local leftStr = "Lv." .. (level - 1)
        local rightStr = "Lv." .. level
        UIUtil.ShowStarTip(Localization:GetString(self:GetName(template.tempData:getValue("id"))), leftStr, rightStr)
    else
        local names, lefts, rights = {}, {}, {}
        for effectId, val in pairs(template.effectDict) do
            local type = GetTableData("effect_num_des", effectId, "type")
            local name = GetTableData("effect_num_des", effectId, "des")
            local totalVal = self:GetEffectVal(effectId)
            local left = totalVal - val
            local right = totalVal
            table.insert(names, Localization:GetString(name))
            table.insert(lefts, UIUtil.GetEffectNumByType(left, type))
            table.insert(rights, UIUtil.GetEffectNumByType(right, type))
        end
        UIUtil.ShowStarTip(string.join(names, "\n"), string.join(lefts, "\n"), string.join(rights, "\n"))
    end
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Ue_CombatPowerUp)
end

local function IsSkillActive(self, skill)
    local template = self:GetTemplateBySkill(skill)
    local skillTemplate = self:GetSkillTemplate(skill)
    if template == nil or skillTemplate == nil then
        return false
    end
    
    local plan = self:GetCurPlan()
    local level = plan:GetGroupLevel(template.group)
    local values = skillTemplate:getValue("value_1")
    local statusId = values[level]
    if statusId == nil then
        return false
    end
    
    local endTime = self.statusEndTimeDict[tonumber(statusId)] or 0
    return curTime < endTime
end

local function GetShowStatusDataList(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local dataList = {}
    for statusId, statusEndTime in pairs(self.statusEndTimeDict) do
        if statusId then
            local endTime = statusEndTime or 0
            if curTime < endTime then
                local template = DataCenter.StatusTemplateManager:GetTemplate(statusId)
                if template~=nil and template.icon_show~=nil and template.icon_show~= "" then
                    local data = {}
                    data.statusId = statusId
                    data.endTime = endTime
                    data.name = template.name
                    data.icon = template:GetShowIcon()
                    data.des = template:GetDesc()
                    table.insert(dataList, data)
                end
                
            end
        end
    end
    return dataList
end

local function CheckShowBuildUnlock(self, group, level)
    local masteryId = group * MasteryLvCap + level
    local dict = nil
    if dict == nil then
        return
    end
    for _, u in pairs(dict) do
        for _, v in pairs(u) do
            local buildTemplate = v.buildTemplate
            if buildTemplate then
                local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildTemplate.id, 0)
                if buildLevelTemplate ~= nil then
                    if table.hasvalue(buildLevelTemplate.needMasteryList, masteryId) and
                            DataCenter.BuildManager:CheckBuildingUnlockWithPreBuildAndScience(buildTemplate.id)
                    then
                        local ok = true
                        for _, w in ipairs(buildLevelTemplate.needMasteryList) do
                            if not self:HasLearntMastery(w) then
                                ok = false
                                break
                            end
                        end
                        if ok then
                            EventManager:GetInstance():Broadcast(EventId.UnlockBuilding)
                            -- 解锁弹窗
                            if buildTemplate.building_show == 1 then
                                local icon = DataCenter.BuildManager:GetBuildIconPath(buildTemplate.id, 1)
                                UIUtil.ShowUnlockWindow(Localization:GetString("115636"), icon, Localization:GetString(buildTemplate.name), UnlockWindowType.Building)
                            end
                        end
                    end
                end
            end
        end
    end
end

local function FlyRewards(self, rewardList)
    for _, reward in ipairs(rewardList) do
        local buildDataList = {}
        local icon = ""
        if reward.type == RewardType.MONEY then
            buildDataList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_CONDOMINIUM)
        elseif reward.type == RewardType.ELECTRICITY then
         
        end
        icon = DataCenter.RewardManager:GetPicByType(reward.type)
        for _, buildData in ipairs(buildDataList) do
            local pos = CS.SceneManager.World:WorldToScreenPoint(buildData:GetCenterVec())
            UIUtil.DoFly(reward.type, 5, icon, pos, Vector3.zero)
        end
    end
end

local function GetBuildNeedDesc(self, buildId)
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildId, 0)
    local strs = {}
    for _, masteryId in ipairs(levelTemplate.needMasteryList) do
        local group = masteryId // MasteryLvCap
        local level = masteryId % MasteryLvCap
        local template = self:GetTemplate(group)
        local str = Localization:GetString(template.name)--[[ .. " Lv." .. level]]
        table.insert(strs, str)
    end
    return string.join(strs, ", ")
end

local function GetEffectVal(self, effectId)
    local val = 0
    local plan = DataCenter.MasteryManager:GetCurPlan()
    for group, level in pairs(plan:GetGroupLevelDict()) do
        local template = self:GetTemplate(group, level)
        val = val + (template.tempData:getValue("extraPara")[effectId] or 0)
    end
    return val
end

--预览专精页
local function SetMasteryTempPage(self,index)
    self.tempPlanIndex = index
end

local function GetTempPlanIndex(self)
    return self.tempPlanIndex
end

local function OnReset(self, itemEffectObj)
    local plan = self:GetPlan(itemEffectObj.resetPage)
    local serverData =
    {
        page = itemEffectObj.resetPage,
        pagePoints = itemEffectObj.resetPagePoints,
        talentPoint = itemEffectObj.talentPoint,
    }
    plan:ParseServerData(serverData)
    EventManager:GetInstance():Broadcast(EventId.MasteryReset)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

local function OnStatusUpdate(self, statusId, endTime)
    self.statusEndTimeDict[tonumber(statusId)] = endTime
    EventManager:GetInstance():Broadcast(EventId.MasteryStatusUpdate)
end

local function SendLearn(self, learnList,tempPage)
    SFSNetwork.SendMessage(MsgDefines.MasteryLearn, learnList,tempPage and tempPage or self:GetCurPlanIndex())
end

local function SendChangePlan(self, planIndex)
    SFSNetwork.SendMessage(MsgDefines.MasteryChangePlan, planIndex)
end

local function SendUseSkill(self, skill, param, callback)
    self.useSkillCallback = callback
    SFSNetwork.SendMessage(MsgDefines.MasteryUseSkill, skill, param)
end

local function SendResetDesertTalentOtherPage(self,page)
    SFSNetwork.SendMessage(MsgDefines.ResetDesertTalentOtherPage,page)
end

--登陆时init获取的信息
local function HandleInit(self, message)
    if message["desertTalent"] then
        self.data:ParseServerData(message["desertTalent"])
    end
    if message["effectState"] then
        for statusId, endTime in pairs(message["effectState"]) do
            self.statusEndTimeDict[tonumber(statusId)] = endTime
        end
        EventManager:GetInstance():Broadcast(EventId.MasteryStatusUpdate)
    end
end

local function HandleLearn(self, message)
    local data = self:GetData()
    local plan = self:GetCurPlan()
    if message["talentPoint"] then
        plan.restPoint = message["talentPoint"]
    end
    local groups = {}
    if message["learnPoints"] then
        for _, v in ipairs(message["learnPoints"]) do
            local group = tonumber(v.groupId)
            plan:SetGroupLevel(group, v.level)
            table.insert(groups, group)
            local showUnlock = self:CheckShowBuildUnlock(group, v.level)
            if not showUnlock then
                self:ShowLearnTip(group, v.level)
            end
        end
    end
    if message["talentSkill"] then
        for _, v in ipairs(message["talentSkill"]) do
            data:SetSkillCdTime(v.skillId, v.cdTime)
        end
    end
    EventManager:GetInstance():Broadcast(EventId.MasteryLearn, groups)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

local function HandleChangePlan(self, message)
    --EventManager:GetInstance():Broadcast(EventId.MasteryChangePlan)
    --EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    DataCenter.MasteryManager:HandleInit(message["changePageObj"])
    DataCenter.MasteryManager:SetMasteryTempPage(0)
    EventManager:GetInstance():Broadcast(EventId.MasteryUpdate)
end

local function HandleUseSkill(self, message)
    local data = self:GetData()
    if message["skillId"] and message["cdTime"] then
        local skill = tonumber(message["skillId"])
        data:SetSkillCdTime(skill, message["cdTime"])
        UIUtil.ShowTipsId(120089)
        EventManager:GetInstance():Broadcast(EventId.MasteryUseSkill, skill)

        local rewardList = {}
        if message["exeObj"] then
            local expObj = message["exeObj"]
            if expObj["resArr"] then
                local resDict = {}
                for _, v in ipairs(message["exeObj"]["resArr"]) do
                    resDict[v.t] = (resDict[v.t] or 0) + v.v
                end
                for resType, count in pairs(resDict) do
                    local reward = {}
                    reward.type = ResTypeToReward[resType]
                    reward.value = count
                    table.insert(rewardList, reward)
                end
            end
            local statusId = expObj["statusId"]
            if statusId ~= nil then
                --获得buff 显示技能结果
                local template = DataCenter.StatusTemplateManager:GetTemplate(statusId)
                if template ~= nil and template.name ~= "" and template.icon_show ~= "" and template.description ~= "" then
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMasterySkillUseResultShow, statusId)
                end
            end
        end
        if #rewardList > 0 then
            if skill == MasterySkill.Harvest then -- 丰收
                -- 切到主城飞奖励
                GoToUtil.CloseAllWindows()
                SceneUtils.ChangeToCity(function()
                    TimerManager:GetInstance():DelayInvoke(function()
                        self:FlyRewards(rewardList)
                    end, 0.5)
                end)
            else
                -- 奖励弹窗
                DataCenter.RewardManager:ShowCommonReward({ reward = rewardList })
            end
        end

        if self.useSkillCallback then
            self.useSkillCallback()
            self.useSkillCallback = nil
        end
    end
end

local function HandleUpdate(self, message)
    local data = self:GetData()
    if not data.inited then
        return
    end
    --local plan = self:GetCurPlan()
    local plan = self.data:GetCurPlan()
    local param = {}
    param.curLevel = data.level
    param.curExp = data.exp
    if message["level"] then
        data.level = message["level"]
    end
    if message["exp"] then
        data.exp = message["exp"]
    end
    if message["needExp"] then
        data.needExp = message["needExp"]
    end
    if message["talentPoint"] then
        plan.restPoint = message["talentPoint"]
    end
    param.toLevel = data.level
    param.toExp = data.exp
    data:UpdateOtherPage()
    if message["addExp"] then
        param.addExp = message["addExp"]
    end
    if param.curLevel and param.curExp and param.toLevel and param.toExp and param.addExp then
        EventManager:GetInstance():Broadcast(EventId.MasteryExpUpdate, param)
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMasteryExpTip) then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIMasteryExpTip, { anim = true }, param)
        end
    end
    
    EventManager:GetInstance():Broadcast(EventId.MasteryUpdate)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
end

local function HandleExtraPageNum(self, message)
    self.data:RefreshExtraPageNum(message)
end

local function HandleChangePageName(self, message)
    self.data:SetPageName(message)
    EventManager:GetInstance():Broadcast(EventId.MasteryChangeName)
end


local function HandleResetPage(self,message)
    self.data:SetPlan(message)
end

function MasteryManager:GetName(id)
    local template = self:GetTemplateById(id)
    if template~=nil and template.skill~=0 and template.tempData:getValue("use_skill_des") ==1 then
        local skillTemplate = DataCenter.MasteryManager:GetSkillTemplate(template.skill)
        return skillTemplate:getValue("name")
    end
    return template:getValue("name")
end

function MasteryManager:GetDescStr(id)
    local template = self:GetTemplateById(id)
    if template~=nil and template.skill~=0 and template.tempData:getValue("use_skill_des") ==1 then
        local level = template.tempData:getValue("Lv")
        local skillTemplate = DataCenter.MasteryManager:GetSkillTemplate(template.skill)
        local durStr = ""
        if skillTemplate~=nil then
            local duration = skillTemplate:getValue("time")
            if duration >= 60 then
                durStr = (duration // 60) .. "min"
            else
                durStr = duration .. "s"
            end
            local descValues = skillTemplate:getValue("des_value")
            local desc = skillTemplate:getValue("description")
            local cdShow = skillTemplate:getValue("cd_time")
            local vals = descValues[level] or {}
            if #vals > 0 then
                durStr = Localization:GetString(desc, durStr, cdShow, table.unpack(vals))
            else
                durStr = Localization:GetString(desc, durStr, cdShow)
            end
        end
        return durStr
    end

    local lines = {}
    local descList = template.tempData:getValue("description")
    local descValuesList = template.tempData:getValue("des_value")
    for i, desc in pairs(descList) do
        local line = ""
        local values = descValuesList[i] or {}
        local strs = {}
        local dialog = desc[1]
        local desType = desc[2]
        for _, value in pairs(values) do
            if desType ~= EffectLocalType.Dialog then
                local str = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(value, desType)
                table.insert(strs, str)
            else
                table.insert(strs, value)
            end
        end
        if #strs > 0 then

            if string.contains(Localization:GetString(dialog), "{") then
                line = Localization:GetString(dialog, table.unpack(strs))
            else
                line = Localization:GetString(dialog) .. " <color=green>" .. table.unpack(strs) .. "</color>"
            end
        else
            line = Localization:GetString(dialog)
        end
        table.insert(lines, line)
    end
    if #lines > 0 then
        return string.join(lines, "\n")
    else
        return ""
    end
end

function MasteryManager:GetPriorsShowInTip(id)
    local list = {}
    local template = self:GetTemplateById(id)
    if template~=nil then
        for _, priorGroup in ipairs(template.priors) do
            local priorTemplate = DataCenter.MasteryManager:GetTemplate(priorGroup)
            if priorTemplate and not (priorTemplate.tempData:getValue("default")==1) then
                table.insert(list, priorGroup)
            end
        end
    end
    return list
end

MasteryManager.__init = __init
MasteryManager.__delete = __delete
MasteryManager.AddListeners = AddListeners
MasteryManager.RemoveListeners = RemoveListeners

MasteryManager.Enabled = Enabled
MasteryManager.IsHideEntrance = IsHideEntrance
MasteryManager.GetData = GetData
MasteryManager.GetPlan = GetPlan
MasteryManager.GetCurPlan = GetCurPlan
MasteryManager.InitTemplateDict = InitTemplateDict
MasteryManager.GetTemplate = GetTemplate
MasteryManager.GetTemplateBySkill = GetTemplateBySkill
MasteryManager.GetTemplateById = GetTemplateById
MasteryManager.GetSkillTemplate = GetSkillTemplate
MasteryManager.GetGroupsByHome = GetGroupsByHome
MasteryManager.GetRestExpToMaxLevel = GetRestExpToMaxLevel
MasteryManager.GetMaxLevel = GetMaxLevel
MasteryManager.GetSeasonMaxLevel = GetSeasonMaxLevel
MasteryManager.GetHomeViewConfig = GetHomeViewConfig
MasteryManager.GetMasteryMaxPage = GetMasteryMaxPage
MasteryManager.GetRestPoint = GetRestPoint
MasteryManager.GetStatusDict = GetStatusDict
MasteryManager.GetLevelMaxExp = GetLevelMaxExp
MasteryManager.GetAllSkills = GetAllSkills
MasteryManager.GetSkillState = GetSkillState
MasteryManager.GetPageName = GetPageName
MasteryManager.GetCurPlanIndex = GetCurPlanIndex
MasteryManager.CheckBeforeUse = CheckBeforeUse
MasteryManager.TryUseSkill = TryUseSkill
MasteryManager.ResetPoint = ResetPoint
MasteryManager.IsHomeOpen = IsHomeOpen
MasteryManager.IsHomeGray = IsHomeGray
MasteryManager.ShowHome = ShowHome
MasteryManager.GetRedNum = GetRedNum
MasteryManager.HasLearntMastery = HasLearntMastery
MasteryManager.ShowLearnTip = ShowLearnTip
MasteryManager.IsSkillActive = IsSkillActive
MasteryManager.GetShowStatusDataList = GetShowStatusDataList
MasteryManager.CheckShowBuildUnlock = CheckShowBuildUnlock
MasteryManager.FlyRewards = FlyRewards
MasteryManager.GetBuildNeedDesc = GetBuildNeedDesc
MasteryManager.GetEffectVal = GetEffectVal
MasteryManager.SetMasteryTempPage = SetMasteryTempPage
MasteryManager.GetTempPlanIndex = GetTempPlanIndex

MasteryManager.OnReset = OnReset
MasteryManager.OnStatusUpdate = OnStatusUpdate

MasteryManager.SendLearn = SendLearn
MasteryManager.SendChangePlan = SendChangePlan
MasteryManager.SendUseSkill = SendUseSkill
MasteryManager.SendResetDesertTalentOtherPage = SendResetDesertTalentOtherPage

MasteryManager.HandleInit = HandleInit
MasteryManager.HandleLearn = HandleLearn
MasteryManager.HandleChangePlan = HandleChangePlan
MasteryManager.HandleUseSkill = HandleUseSkill
MasteryManager.HandleUpdate = HandleUpdate
MasteryManager.HandleChangePageName = HandleChangePageName
MasteryManager.HandleExtraPageNum = HandleExtraPageNum
MasteryManager.HandleResetPage = HandleResetPage

return MasteryManager