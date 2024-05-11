---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2023/2/27 15:56
---

local SuitEffect = BaseClass("SuitEffect", UIBaseContainer)
local base = UIBaseContainer

local lock_path = "lock"
local btn_path = ""
local effect_path = "VFX_ui_bujian_jiesuo"
local icon_img_path = "icon"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.lock = self:AddComponent(UIImage, lock_path)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnEquipInfoClick()
    end)
    --self.unlock_effect = self:AddComponent(UIBaseContainer, effect_path)
    --self.unlock_effect:SetActive(true)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
end

local function ComponentDestroy(self)
    if self.delayTimer then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
end

local function DataDefine(self)

end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.GetLastSeasonHeroRecordInfoSuccess, self.OnEquipmentDataChange)
end

local function OnRemoveListener(self)
    --self:RemoveUIListener(EventId.GetLastSeasonHeroRecordInfoSuccess, self.OnEquipmentDataChange)
    base.OnRemoveListener(self)
end

local function SetData(self, data)
    local showEffect = self.data ~= nil and data ~= nil and self.data.isLocked and not data.isLocked and self.data.suitId == data.suitId
    self.data = data
    self:RefreshView(showEffect)
end

local function RefreshView(self, showEffect)
    self.lock:SetActive(self.data.isLocked or showEffect)
    --self.unlock_effect:SetActive(showEffect)
    if showEffect then
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
            if self.delayTimer then
                self.delayTimer:Stop()
                self.delayTimer = nil
            end
            self.lock:SetActive(self.data.isLocked)
        end, 0.7)
    end
    self.icon_img:LoadSprite(self.data.iconName)
end

local function OnEquipmentDataChange(self, para)
    if para ~= nil and self.data ~= nil then

    end
end

local function OnEquipInfoClick(self)
    local para = {}
    para.suitId = self.data.suitId
    para.index = self.data.index
    para.carIndex = self.data.carIndex
    para.lvNeed = self.data.lvNeed
    para.numNeed = self.data.numNeed
    para.hasNum = self.data.hasNum
    para.posX = self.transform.position.x
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIEquipmentSuitInfo, { anim = false, playEffect = false}, para)
end

SuitEffect.OnEquipInfoClick = OnEquipInfoClick
SuitEffect.OnAddListener = OnAddListener
SuitEffect.OnRemoveListener = OnRemoveListener
SuitEffect.OnCreate= OnCreate
SuitEffect.OnDestroy = OnDestroy
SuitEffect.ComponentDefine = ComponentDefine
SuitEffect.ComponentDestroy = ComponentDestroy
SuitEffect.DataDefine = DataDefine
SuitEffect.DataDestroy = DataDestroy
SuitEffect.SetData = SetData
SuitEffect.RefreshView = RefreshView
SuitEffect.OnEquipmentDataChange = OnEquipmentDataChange

return SuitEffect