---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 17:23
---UIChatReportItem.lua

local UIChatReportItem = BaseClass("UIChatReportItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local selectBtn_path = "selectBtn"
local selectIcon_path = "Checkmark"
local reasonTxt_path = "name"

local function OnCreate(self)
    base.OnCreate(self)
    self.selectBtnN = self:AddComponent(UIButton, selectBtn_path)
    self.selectBtnN:SetOnClick(function()
        self:OnClickSelectBtn()
    end)
    self.selectIconN = self:AddComponent(UIImage, selectIcon_path)
    self.reasonTxtN = self:AddComponent(UITextMeshProUGUIEx, reasonTxt_path)
end

local function OnDestroy(self)
    self.selectBtnN = nil
    self.selectIconN = nil
    self.reasonTxtN = nil
    base.OnDestroy(self)
end

local function SetItem(self, report)
    self.reportConf = report
    
    self.reasonTxtN:SetLocalText(self.reportConf.Dialog)
    self.selectIconN:SetActive(false)
end

local function GetReportConf(self)
    return self.reportConf
end

local function OnClickSelectBtn(self)
    self.view:OnSelectOne(self)
    self.selectIconN:SetActive(true)
end

local function SetSelected(self, isSelected)
    self.selectIconN:SetActive(isSelected)
end


UIChatReportItem.OnCreate = OnCreate
UIChatReportItem.OnDestroy = OnDestroy

UIChatReportItem.SetItem = SetItem
UIChatReportItem.GetReportConf = GetReportConf
UIChatReportItem.SetSelected = SetSelected
UIChatReportItem.OnClickSelectBtn = OnClickSelectBtn
return UIChatReportItem