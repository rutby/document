---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2024/4/9 18:57
---
local UIWelfareCenterCtrl = BaseClass("UIWelfareCenterCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UIWelfareCenterCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWelfareCenter)
end

function UIWelfareCenterCtrl:Close()
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIWelfareCenterCtrl:InitData()
    self:SetCurrentActivityId("")
end
function UIWelfareCenterCtrl:SetCurrentActivityId(id)
    self.activityId = id
end

function UIWelfareCenterCtrl:GetCurrentActivityId()
    return self.activityId
end

function UIWelfareCenterCtrl:GetCurrentActivity()
    local data = self:GetActivityDataById(self:GetCurrentActivityId())
    return data
end

function UIWelfareCenterCtrl:GetActivityDataById(id)
    local oneData = {}
    oneData.id =id
    local data = DataCenter.ActivityListDataManager:GetActivityDataById(id)
    if data~=nil then
        oneData.list_icon = data.list_icon
        if data.type == EnumActivity.RobotWars.Type then
            local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
            local actNameId = GetTableData(TableName.APS_Season, seasonId, 'subTitle')
            local icon = GetTableData(TableName.APS_Season, seasonId, 'season_list_icon')
            if icon and icon ~= "" then
                oneData.list_icon = icon
            end
            oneData.name = Localization:GetString(actNameId)
        elseif data.type == EnumActivity.LeadingQuest.Type and data.notice_info == EnumActivityNoticeInfo.EnumActivityNoticeInfo_Hero then
            local seasonId = DataCenter.SeasonDataManager:GetSeasonId() or 0
            if data.sub_type ~= ActivityEnum.ActivitySubType.ActivitySubType_1 then
                oneData.name = Localization:GetString(data.name, seasonId - 1)
            else
                oneData.name = Localization:GetString(data.name, seasonId)
            end
        elseif data.type == EnumActivity.LeadingQuest.Type and not string.IsNullOrEmpty(data.unlock_hero) then
            local seasonId = DataCenter.SeasonDataManager:GetSeasonId() or 0
            local toHeroId = DataCenter.HeroEvolveActivityManager:GetToHeroId()
            local heroData = DataCenter.HeroDataManager:GetHeroById(toInt(toHeroId))
            if heroData ~= nil then
                oneData.name = Localization:GetString(data.name, seasonId)
            else
                local rarity = GetTableData(HeroUtils.GetHeroXmlName(), toHeroId, "rarity")
                local desc = string.format("<color='%s'>%s</color>",HeroUtils.GetRarityColorStr(rarity), Localization:GetString(GetTableData(HeroUtils.GetHeroXmlName(), toHeroId, "desc")))
                oneData.name = Localization:GetString(361093, desc)
            end
        elseif data.type == ActivityEnum.ActivityType.GloryPreview then
            local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
            local template = DataCenter.SeasonGroupManager:GetTemplateById(data.groupId)
            if template then
                local actNameId = GetTableData(TableName.APS_Season, (template.season + 1), 'subTitle')
                local icon = GetTableData(TableName.APS_Season, seasonId + 1, 'season_list_icon')
                if icon and icon ~= "" then
                    oneData.list_icon = icon
                end
                oneData.name = Localization:GetString(actNameId)
            else
                oneData.name = Localization:GetString(data.name)
            end
        else
            oneData.name = Localization:GetString(data.name)
            --if not string.IsNullOrEmpty(data.unlock_hero) then
            --    local heroData = DataCenter.HeroDataManager:GetHeroById(toInt(data.unlock_hero))
            --    if heroData == nil then
            --        oneData.unlockStr = Localization:GetString(361093, HeroUtils.GetHeroNameByConfigId(data.unlock_hero))
            --    end
            --end
        end
        oneData.type = data.type
        oneData.canGet = DataCenter.ActivityListDataManager:GetRewardNumByTypeAndId(data.type,data.id)
        oneData.activityId = data.activityId == "" and  data.id or data.activityId
        oneData.tabGroup = data.tabGroup
        oneData.tabGroupOrder = data.tabGroupOrder
        if data.sub_type ~= nil then
            oneData.sub_type = data.sub_type
        end
        --elseif id == ActivityEnum.ActivityType.SevenDay then
        --    oneData.name = Localization:GetString("371007")
        --    oneData.canGet = DataCenter.ActivityListDataManager:GetDayActRedNum()
        --    oneData.activityId = ActivityEnum.ActivityType.SevenDay
        --    oneData.type = ActivityEnum.ActivityType.SevenDay
        --    oneData.list_icon = "activity_icon_js"
        --    oneData.tabGroup = "372340"
        --    oneData.tabGroupOrder = 1
        --    oneData.GetOrder = function()
        --        return 1
        --    end
    end
    return oneData
end

function UIWelfareCenterCtrl:GetTableGroupList(goId,sourceType)
    local dailyType = 10
    --if goId and sourceType and sourceType == 1 then
    --    local goActInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(goId))
    --    if goActInfo then
    --        dailyType = goActInfo.activity_daily
    --    end
    --end
    local list = DataCenter.ActivityListDataManager:GetWelfareActivity()
    local tempDic = {}
    if list ~= nil then
        for i, v in pairs(list) do
            if v.sourceType == ActivitySource.activity then
                if not dailyType or dailyType == v.activity_daily then
                    local isInsert = true
                    if v.type == ActivityEnum.ActivityType.Arms then
                        local curTime = UITimeManager:GetInstance():GetServerTime()
                        if v.endTime < curTime then
                            isInsert = false
                        elseif v.personalEventType and v.personalEventType == PersonalEventType.Permanent then  --常驻军备不单独显示
                            isInsert = false
                        end
                    end
                    if v.type == ActivityEnum.ActivityType.DonateSoldierActivity then
                        if LuaEntry.Player:IsInAlliance() == false then
                            --如果玩家不在联盟里则不显示捐兵活动页签
                            isInsert = false
                        else
                            local isInAlCompete = DataCenter.AllianceCompeteDataManager:CheckIfIsInCompete()
                            if isInAlCompete == false then
                                --如果玩家在联盟里但是联盟对决没有开则也不显示捐兵活动页签
                                isInsert = false
                            end
                        end
                    end
                    if v.type == ActivityEnum.ActivityType.ActNoOne then
                        isInsert = false
                    end
                    if v.type == ActivityEnum.ActivityType.StaminaBall then
                        isInsert = false
                    end
                    if v.type == EnumActivity.LeadingQuest.Type then
                        if not string.IsNullOrEmpty(v.activity_pic) and v.activity_pic == "lingtuzhizhan1" then
                            isInsert = false
                        end
                    end
                    if isInsert then
                        --local temp = {
                        --    
                        --}
                        --if not tempDic[v.tabGroup]  then
                        --    local newGroup = {}
                        --    newGroup.tabGroup = v.tabGroup
                        --    newGroup.tabGroupOrder = v.tabGroupOrder
                        --    newGroup.activityList = {}
                        --    tempDic[v.tabGroup] = newGroup
                        --end
                        table.insert(tempDic, v)
                    end
                end
            elseif v.sourceType == ActivitySource.shop then
                local temp = {
                    id = v
                }
                table.insert(tempDic, v)
            end
        end
    end
    return tempDic
end

function UIWelfareCenterCtrl:GetDefaultSelectTabId(tabList)
    for i, v in ipairs(tabList) do
        if v.sourceType == ActivitySource.activity then
            if DataCenter.ActivityListDataManager:GetActivityRedDotCount(v.id) > 0 then
               return v.id,i
            end
        elseif v.sourceType == ActivitySource.shop then
            local welfareData = self:GetWelfareDataByWelfareId(v.id)
            local redNum = welfareData:getRedDotNum()
            if redNum > 0 then
                return v.id,i
            end
        end
    end
    return tabList[1].id,1
end

function UIWelfareCenterCtrl:GetWelfareList()
    return  WelfareController.getShowTagInfos()
end

function UIWelfareCenterCtrl:GetGotoMallData(type)
    local dataList = self:GetWelfareList()
    for i = 1, #dataList do
		if dataList[i]:getDailyType() ~= ActivityShowLocation.welfareCenter then
			return dataList[i]
		end
        --if dataList[i]:getType() ~= type then
        --   
        --end
    end
end

function UIWelfareCenterCtrl:GetWelfareIndexByWelfareId(rechargeId)
    local dataList = self:GetWelfareList()
    for i = 1, #dataList do
        if dataList[i]:getID() == rechargeId then
            return i
        end
    end
    return 0
end

function UIWelfareCenterCtrl:GetWelfareDataByWelfareId(shopId)
    local dataList = self:GetWelfareList()
    for i = 1, #dataList do
        if dataList[i]:getID() == shopId then
            return dataList[i]
        end
    end
    return nil
end

return UIWelfareCenterCtrl