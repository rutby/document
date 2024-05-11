---
--- Created by shimin.
--- DateTime: 2022/5/11 10:25
---

local UITalentChooseCtrl = BaseClass("UITalentChooseCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UITalentChoose)
end

local function GetPanelData(self)
    local list = DataCenter.TalentDataManager:GetTalentOptions()
    local recommondTalentId = "-1"
    local rate = -1
    local minOrder = -1
    for _, v in ipairs(list) do
        local template = DataCenter.TalentTemplateManager:GetTemplate(v)
        if template ~= nil and template.special_rate >= 0 then
            if rate < 0 or rate > template.special_rate then
                recommondTalentId = v
                rate = template.special_rate
                minOrder = template.order
            elseif rate == template.special_rate and minOrder > template.order then
                recommondTalentId = v
                rate = template.special_rate
                minOrder = template.order
            end
        end
    end

    if list == nil then
        list = {}
    end
    return list, recommondTalentId
end

local function DoWhenSubmit(self, talentId)
    local template = DataCenter.TalentTemplateManager:GetTemplate(talentId)
    local rsNeed = template.resourceNeed
    for k, v in pairs(rsNeed) do
        local hasRs = LuaEntry.Resource:GetCntByResType(k)
        if hasRs < v then
            local lackTab = {}
            local param = {}
            param.type = ResLackType.Res
            param.id = k
            param.targetNum = v
            table.insert(lackTab,param)
            GoToResLack.GoToItemResLackList(lackTab)
            return false
        end
    end
    DataCenter.TalentDataManager:TalentChoose(talentId)
    return true
end

--获得资源数量
local function GetCntByResType(self,resourceType)
    if DataCenter.ItemTemplateManager:GetItemTemplate(resourceType) ~= nil then
        local item = DataCenter.ItemData:GetItemById(resourceType)
        if item ~= nil then
            return item.count
        end
        return 0
    end
    return LuaEntry.Resource:GetCntByResType(resourceType)
end

local function OnClickResourceBtn(self, resourceType)

end

local function ResetAll(self)
    local resetNum = DataCenter.TalentDataManager:LeftRefreshTalentCount()
    local param = {}
    param.needDiamond = 0
    param.tip1 = 131016
    param.tip2 = Localization:GetString("120121")..": "..resetNum
    param.onResetClick = self.DoResetAll
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITalentResetConfirm, {anim = true,playEffect = false}, param)
end

local function DoResetAll(self)
    DataCenter.TalentDataManager:TalentChooseReset()

end

UITalentChooseCtrl.CloseSelf = CloseSelf
UITalentChooseCtrl.GetPanelData = GetPanelData
UITalentChooseCtrl.DoWhenSubmit = DoWhenSubmit
UITalentChooseCtrl.GetCntByResType = GetCntByResType
UITalentChooseCtrl.OnClickResourceBtn = OnClickResourceBtn
UITalentChooseCtrl.ResetAll = ResetAll
UITalentChooseCtrl.DoResetAll = DoResetAll

return UITalentChooseCtrl