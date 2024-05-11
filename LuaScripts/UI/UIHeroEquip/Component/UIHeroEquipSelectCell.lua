local UIHeroEquipSelectCell = BaseClass("UIHeroEquipSelectCell",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local UIHeroEquipCell = require "UI.UIHeroEquip.Component.UIHeroEquipCell"

local equip_path = "UIHeroEquipCell"
local select_obj_path = "selectObj"
local select_obj2_path = "selectObj2"
local lock_obj_path = "lockObj"
local work_obj_path = "workObj"

local State =
{
    None = 0,
    Lock = 1,
    Work = 2,
}

function UIHeroEquipSelectCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UIHeroEquipSelectCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroEquipSelectCell:ComponentDefine()
    self.equipCell = self:AddComponent(UIHeroEquipCell,equip_path)
    self.select_obj = self:AddComponent(UIBaseContainer,select_obj_path)
    self.select_obj2 = self:AddComponent(UIBaseContainer,select_obj2_path)
    self.lock_obj = self:AddComponent(UIBaseContainer,lock_obj_path)
    self.work_obj = self:AddComponent(UIBaseContainer,work_obj_path)
end

function UIHeroEquipSelectCell:ComponentDestroy()

end

function UIHeroEquipSelectCell:DataDefine()
    self.equip = {}
    self.equipId = 0
    self.index = 0
    self.viewTag = ''
end

function UIHeroEquipSelectCell:DataDestroy()
    self.equip = {}
    self.equipId = 0
    self.index = 0
    self.viewTag = ''
end

function UIHeroEquipSelectCell:SetData(equip, index, viewTag)
    self.equip = equip
    self.index = index
    self.viewTag = viewTag
    self.select_obj:SetActive(false)
    self.select_obj2:SetActive(self.view.ctrl.takePartMultiSelectList[self.index])
    self.equipCell:SetData(equip, function()
        self:OnSelectClick()
    end)
end

function UIHeroEquipSelectCell:SetConfigData(equipId, index, viewTag)
    self.equipId = equipId
    self.index = index
    self.viewTag = viewTag
    self.select_obj:SetActive(false)
    self.select_obj2:SetActive(false)
    self.equipCell:SetConfigData(equipId, function()
        self:OnSelectClick()
    end)

    self:Refresh()
end

function UIHeroEquipSelectCell:OnSelectClick()
    if self.viewTag == "UIHeroEquipMake" then
        EventManager:GetInstance():Broadcast(EventId.OnSelectMakePartEquip, self.index)
    elseif self.viewTag == "UIHeroEquipTakePart" then
        if self.view.ctrl.takePartMultiSelectList[self.index] == nil
        or self.view.ctrl.takePartMultiSelectList[self.index] == false 
        then
            self.view.ctrl.takePartMultiSelectList[self.index] = true
        else
            self.view.ctrl.takePartMultiSelectList[self.index] = false
        end

        EventManager:GetInstance():Broadcast(EventId.OnSelectTakePartEquip)
    end
end

function UIHeroEquipSelectCell:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnSelectMakePartEquip, self.RefreshSelectState)
    self:AddUIListener(EventId.OnSelectTakePartEquip, self.RefreshMultiSelectState)
    self:AddUIListener(EventId.HeroEquipStartProduct, self.Refresh)
    self:AddUIListener(EventId.AddSpeedSuccess, self.Refresh)
    self:AddUIListener(EventId.HeroEquipQueueFinish, self.Refresh)
end

function UIHeroEquipSelectCell:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnSelectMakePartEquip, self.RefreshSelectState)
    self:RemoveUIListener(EventId.OnSelectTakePartEquip, self.RefreshMultiSelectState)
    self:RemoveUIListener(EventId.HeroEquipStartProduct, self.Refresh)
    self:RemoveUIListener(EventId.AddSpeedSuccess, self.Refresh)
    self:RemoveUIListener(EventId.HeroEquipQueueFinish, self.Refresh)
end

function UIHeroEquipSelectCell:Refresh()
    local unlock, unlockLevel = DataCenter.HeroEquipTemplateManager:IsEquipUnlock(self.equipId)
    if unlock == true then
        self.lock_obj:SetActive(false)
        local queue = DataCenter.QueueDataManager:GetQueueByType(NewQueueType.ProductEquip)
        local queueState = queue:GetQueueState()
        if tonumber(queue.itemId) == self.equipId then
            if queueState == NewQueueState.Work or queueState == NewQueueState.Finish then
                self.work_obj:SetActive(true)
            else
                self.work_obj:SetActive(false)
            end
        else
            self.work_obj:SetActive(false)
        end
    else
        self.lock_obj:SetActive(true)
    end
end

function UIHeroEquipSelectCell:RefreshSelectState(index)
    if self.viewTag ~= "UIHeroEquipMake" then
        return
    end
    self.select_obj:SetActive(index == self.index)
end

function UIHeroEquipSelectCell:RefreshMultiSelectState()
    if self.viewTag ~= "UIHeroEquipTakePart" then
        return
    end
    self.select_obj2:SetActive(self.view.ctrl.takePartMultiSelectList[self.index])
end

return UIHeroEquipSelectCell