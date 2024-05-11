---
--- Created by shimin.
--- DateTime: 2021/7/5 20:12
---
local BuildQueueTalkManager = BaseClass("BuildQueueTalkManager");

local function __init(self)
    self.showStartTime = {}--该类型对话的开始时间
    self.showingTalk = nil
end

local function __delete(self)
    self.showStartTime = nil
    self.showingTalk = nil
end

--获取显示的对话
local function ShowTalk(self,type)
    if self.showingTalk == nil then
        local result = self:GetShouldShowTemplate(type)
        if result ~= nil then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            for k,v in pairs(self.showStartTime) do
                if k == type then
                    if v + result.dialog_cd * 1000 > curTime then
                        return
                    end
                else
                    if v + result.public_cd * 1000 > curTime then
                        return
                    end
                end
            end
            self.showStartTime[type] = curTime
            self.showingTalk = result
        end
    end
end

local function GetShouldShowTemplate(self,type)
    local list = DataCenter.UavDialogueTemplateManager:GetUavDialogueListByType(type)
    if list ~= nil then
        for k,v in ipairs(list) do
            local canAdd = true
            for k1,v1 in ipairs(v.building) do
                local listBuilds = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(v1.buildId)
                if listBuilds ~= nil and table.count(listBuilds) > 0 then
                    for k2,v2 in pairs(listBuilds) do
                        local level = v2.level
                        if level < v1.minLevel or level > v1.maxLevel then
                            canAdd = false
                        end
                    end
                else
                    canAdd = false
                end
            end
            if canAdd then
                return v
            end
        end
    end
    return nil
end

BuildQueueTalkManager.__init = __init
BuildQueueTalkManager.__delete = __delete
BuildQueueTalkManager.ShowTalk = ShowTalk
BuildQueueTalkManager.GetShouldShowTemplate = GetShouldShowTemplate

return BuildQueueTalkManager
