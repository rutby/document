---
--- Created by shimin.
--- DateTime: 2022/5/11 10:25
---

local UITalentInfoCtrl = BaseClass("UITalentInfoCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
local Num_Per_Line = 7

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UITalentInfo)
end

local function GetPanelData(self, highLightTalentId)
    local result = {}
    local showTalentChoose = DataCenter.TalentDataManager:HasTalentToChoose()
    local allChoosed = DataCenter.TalentDataManager:GetAllChooseTalent()
    local showReset = (allChoosed ~= nil and table.count(allChoosed) > 0)
    local allTalentType = table.values(DataCenter.TalentTypeTemplateManager:GetAllTemplate()) 
    table.sort(allTalentType, function (k, v)
        return k.order < v.order
    end)
    local allTalents = table.values(DataCenter.TalentTemplateManager:GetAllTemplate())
    table.walk(allTalentType, function (_, talentType)
        local titleParam = {}
        titleParam.type = 1
        local openNum = 0
        local totalNum = 0
        
        local tmpVec = {}
        table.walk(allTalents, function (_, v)
            local group = v.group
            if v.type ~= talentType.id then
                return
            end
            local data = tmpVec[group]
            if data == nil then
                data = {}
                data.group = v.group
                local lv, id, order = DataCenter.TalentDataManager:GetMaxOpenedTalentByGroup(data.group)
                data.level = lv
                
                if lv > 0 then
                    data.id = id
                    data.order = order
                else
                    local minTemplate = DataCenter.TalentDataManager:GetMinLvTemplateByGroup(data.group)
                    if minTemplate ~= nil then
                        data.id = minTemplate.id
                        data.order = minTemplate.order
                        data.forceHighLight = data.forceHighLight or data.id == highLightTalentId
                    end
                end
                
                local template = DataCenter.TalentTemplateManager:GetTemplate(data.id)
                if template ~= nil then
                    data.icon = template.icon
                end
                tmpVec[group] = data
            end
            if DataCenter.TalentDataManager:IsTalentOpen(v.id) then
                openNum = openNum + 1
            end
            totalNum = totalNum + 1
        end)
        titleParam.typeStr = tostring(talentType.id)
        titleParam.totalNum = totalNum
        titleParam.openNum = openNum
        titleParam.name = talentType.name
        table.insert(result, titleParam)

        local group = table.values(tmpVec)
        table.sort(group, function (k, v)
            return k.order < v.order
        end)
        local lineData
        for index, data in ipairs(group) do
            if index % Num_Per_Line == 1 then
                lineData = {}
                lineData.type = 2
                lineData.talents = {}
                table.insert(result, lineData)
            end
            data.index = (index - 1) % Num_Per_Line
            data.total = Num_Per_Line
            table.insert(lineData.talents, data)
        end
    end)
    return result, showTalentChoose, showReset
end

local function GetGroupPanelData(self, group)
    local allTalents = table.values(DataCenter.TalentTemplateManager:GetAllTemplate())
    local result = {}

    local lv, id, order = DataCenter.TalentDataManager:GetMaxOpenedTalentByGroup(group) 
    
    table.walk(allTalents, function (_, v)
        if v.group == group then
            local param = {}
            param.id = v.id
            param.level = v.lv
            param.currentOpenLv = lv

            param.name = Localization:GetString("300665", v.lv).." "..v.name
            param.gray = false
            if param.currentOpenLv < param.level then
                param.name = param.name.."("..Localization:GetString("120050")..")"
                param.gray = true
            end
            param.des = v.description
            param.order = v.order
            table.insert(result, param)
        end
    end)
    table.sort(result, function (k, v)
        return k.level < v.level
    end)
    return result
end

local function ResetAll(self)
    local resetNum, goldResetCount = DataCenter.TalentDataManager:GetResetInfo()
    local needGold = 0
    if resetNum <= 0 then
        local costStr = LuaEntry.DataConfig:TryGetStr("base_talent", "k4")
        local costVec = string.split(costStr, ";")
        needGold =  toInt(costVec[goldResetCount + 1] or costVec[table.count(costVec)])
    end
    
    local param = {}
    param.needDiamond = needGold
    param.tip1 = 131010
    if resetNum > 0 then
        param.tip2 = Localization:GetString("110134", resetNum)
    end
    param.onResetClick = self.DoResetAll
    
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITalentResetConfirm, {anim = true,playEffect = false}, param)
end

local function DoResetAll(self)
    local resetNum, goldResetCount = DataCenter.TalentDataManager:GetResetInfo()
    local resetType = 1
    if resetNum <= 0 then
        resetType = 2
    end

    local DoReset = function(resetType)
        DataCenter.TalentDataManager:TalentReset(resetType)
    end

    if resetType == 2 then
        local gold = LuaEntry.Player.gold
        local costStr = LuaEntry.DataConfig:TryGetStr("base_talent", "k4")
        local costVec = string.split(costStr, ";")
        local cost =  toInt(costVec[goldResetCount + 1] or costVec[table.count(costVec)])

        if gold < cost then
            GoToUtil.GotoPayTips()
            return
        else
            DoReset(resetType)
        end
    else
        DoReset(resetType)
    end
end

local function GetDisplayPackage(self)
    local giftPack = GiftPackageData.GetTalentPackage()
    return giftPack
end

local function BuyGift(self,info)
    DataCenter.PayManager:CallPayment(info, UIWindowNames.UITalentInfo)
end


UITalentInfoCtrl.CloseSelf = CloseSelf
UITalentInfoCtrl.GetPanelData = GetPanelData
UITalentInfoCtrl.GetGroupPanelData = GetGroupPanelData
UITalentInfoCtrl.ResetAll = ResetAll
UITalentInfoCtrl.DoResetAll = DoResetAll
UITalentInfoCtrl.BuyGift = BuyGift
UITalentInfoCtrl.GetDisplayPackage = GetDisplayPackage

return UITalentInfoCtrl