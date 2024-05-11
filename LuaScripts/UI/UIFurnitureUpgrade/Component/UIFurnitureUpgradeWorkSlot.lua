---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/9 16:11
---

local UIFurnitureUpgradeWorkSlot = BaseClass("UIFurnitureUpgradeWorkSlot", UIBaseContainer)
local base = UIBaseContainer

local bgImage_path = "bgImage"
local icon_path = "Icon"
local name_path = "Name"
local lock_path = "Lock"
local empty_path = "Empty"
local add_path = "Add"

local Type =
{
    Lock = 1,
    Empty = 2,
    Worker = 3,
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self.active = true
end

local function OnDisable(self)
    self.active = false
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.icon_image = self:AddComponent(UIImage, icon_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_path)
    self.bgImage = self:AddComponent(UIBaseContainer, bgImage_path)
    self.lock_btn = self:AddComponent(UIButton, lock_path)
    self.lock_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Add)
        self:OnLockClick()
    end)
    self.empty_go = self:AddComponent(UIBaseContainer, empty_path)
    self.add_btn = self:AddComponent(UIButton, add_path)
    self.add_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Add)
        self:OnAddClick()
    end)
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.data = {}
end

local function DataDestroy(self)
    self.data = {}
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, data)
    self.data = data
    if data.type == Type.Lock then
        self.lock_btn:SetActive(true)
        self.empty_go:SetActive(false)
        self.icon_image:SetActive(false)
        self.name_text:SetActive(false)
        self.bgImage:SetActive(false)
        self.add_btn:SetActive(false)
    elseif data.type == Type.Empty then
        self.lock_btn:SetActive(false)
        self.empty_go:SetActive(true)
        self.icon_image:SetActive(false)
        self.name_text:SetActive(true)
        self.name_text:SetLocalText(130409)
        self.bgImage:SetActive(false)
        self.add_btn:SetActive(data.canAdd)
    elseif data.type == Type.Worker then
        self.lock_btn:SetActive(false)
        self.empty_go:SetActive(false)
        self.icon_image:SetActive(true)
        self.name_text:SetActive(true)
        self.bgImage:SetActive(true)
        local icon = GetTableData(TableName.VitaResident, data.residentData.id, "icon")
        local name = GetTableData(TableName.VitaResident, data.residentData.id, "name")
        self.icon_image:LoadSprite(string.format(LoadPath.Resident, icon))
        self.name_text:SetLocalText(name)
        self.add_btn:SetActive(false)
    end
end

local function OnLockClick(self)
    UIUtil.ShowTips(self.data.showTips)
end

local function OnAddClick(self)
    self.data.onAddClick()
end

UIFurnitureUpgradeWorkSlot.OnCreate = OnCreate
UIFurnitureUpgradeWorkSlot.OnDestroy = OnDestroy
UIFurnitureUpgradeWorkSlot.OnEnable = OnEnable
UIFurnitureUpgradeWorkSlot.OnDisable = OnDisable
UIFurnitureUpgradeWorkSlot.ComponentDefine = ComponentDefine
UIFurnitureUpgradeWorkSlot.ComponentDestroy = ComponentDestroy
UIFurnitureUpgradeWorkSlot.DataDefine = DataDefine
UIFurnitureUpgradeWorkSlot.DataDestroy = DataDestroy
UIFurnitureUpgradeWorkSlot.OnAddListener = OnAddListener
UIFurnitureUpgradeWorkSlot.OnRemoveListener = OnRemoveListener

UIFurnitureUpgradeWorkSlot.Type = Type
UIFurnitureUpgradeWorkSlot.SetData = SetData
UIFurnitureUpgradeWorkSlot.OnLockClick = OnLockClick
UIFurnitureUpgradeWorkSlot.OnAddClick = OnAddClick

return UIFurnitureUpgradeWorkSlot