---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 17:23
---

local FirstPayRewardItem = BaseClass("FirstPayRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local selectBtn_path = "Bg/selectBtn"
local selectedImg_path = "Bg/selectBtn/Background/Checkmark"
local nationIcon_path = "Bg/flag"
local nationName_path = "Bg/name"

local function OnCreate(self)
    base.OnCreate(self)
    
    self.selectBtnN = self:AddComponent(UIButton, selectBtn_path)
    self.selectBtnN:SetOnClick(function()
        self:OnClickSelectBtn()
    end)
    self.selectedImgN = self:AddComponent(UIImage, selectedImg_path)
    self.selectedImgN:SetActive(false)
    self.nationFlagN = self:AddComponent(UIImage, nationIcon_path)
    self.nationNameN = self:AddComponent(UITextMeshProUGUIEx, nationName_path)
end

local function OnDestroy(self)
    self.selectBtnN = nil
    self.selectedImgN = nil
    self.nationFlagN = nil
    self.nationNameN = nil
    base.OnDestroy(self)
end

local function SetItem(self, nationInfo, selectedType)--from UIGiftRewardCell
    self.nationTemplate = nationInfo
    self:RefreshSelectStatus(selectedType)
    
    local flagPath = self.nationTemplate:GetNationFlagPath()
    self.nationFlagN:LoadSprite(flagPath)
    self.nationNameN:SetText(self.nationTemplate:GetNationName())
end

local function RefreshSelectStatus(self, selectedType)
    if self.nationTemplate and self.nationTemplate.nation == selectedType then
        self.selectedImgN:SetActive(true)
    else
        self.selectedImgN:SetActive(false)
    end
end

local function OnClickSelectBtn(self)
    self.view:OnSelectNation(self.nationTemplate.nation)
end

FirstPayRewardItem.OnCreate = OnCreate
FirstPayRewardItem.OnDestroy = OnDestroy

FirstPayRewardItem.SetItem = SetItem
FirstPayRewardItem.RefreshSelectStatus = RefreshSelectStatus
FirstPayRewardItem.OnClickSelectBtn = OnClickSelectBtn
return FirstPayRewardItem