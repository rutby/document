---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/2/14 15:46
---

local UIGrowthPlanItem = BaseClass("UIGrowthPlanItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local btnReceive_path = "Root/btnReceive"
local txtReceive_path = "Root/btnReceive/btnText"
local arrow_path = "arrow"
local txtLv_path = "Root/txtLv"
local txtReward_path = "Root/txtReward"
local txtNum_path = "Root/txtReward/txtNum"
local check_path = "Root/Check"
local icon_path = "Root/icon"

local CellPos =
{
    Top = 1,
    Bottom = 2,
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
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.btnReceive = self:AddComponent(UIButton, btnReceive_path)
    self.btnReceive:SetOnClick(function()
        self:OnCellClick()
    end)
    self.txtReceive = self:AddComponent(UITextMeshProUGUIEx, txtReceive_path)
    self.txtReceive:SetLocalText(470063)
    self.txtLv = self:AddComponent(UITextMeshProUGUIEx, txtLv_path)
    self.txtReward = self:AddComponent(UITextMeshProUGUIEx, txtReward_path)
    self.txtReward:SetLocalText(470062)
    self.txtNum = self:AddComponent(UITextMeshProUGUIEx, txtNum_path)
    self.check = self:AddComponent(UIBaseContainer, check_path)
    self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
    self.icon = self:AddComponent(UIImage , icon_path)
end

local function ComponentDestroy(self)
    self.slider_ball_go = nil
end

local function DataDefine(self)
    self.view = nil
    self.data = nil
    self.onClick = nil
end

local function DataDestroy(self)
    self.view = nil
    self.data = nil
    self.onClick = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetData(self, data, view)
    self.view = view
    self.data = data

    local name = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), 400030,"name")
    local text = Localization:GetString("470061", Localization:GetString(name), data.needLevel)
    self.txtLv:SetText(text)
    if type(data.specialReward[1].value) == "table" then
        self.txtNum:SetText(string.GetFormattedSeperatorNum(data.specialReward[1].value.num))
    elseif type(data.specialReward[1].value) == "number" then
        self.txtNum:SetText(string.GetFormattedSeperatorNum(data.specialReward[1].value))
    end
    
    if #data.specialReward > 0 then
        local locked = DataCenter.BuildManager.MainLv < data.needLevel
        local checked = data.specialState == 1
        
        self.check:SetActive(checked)
        self.btnReceive:SetActive(not checked)
        CS.UIGray.SetGray(self.btnReceive.transform, locked, not locked)
    end
    
    self:RefreshIcon()
end

local function SetOnClick(self, onClick)
    self.onClick = onClick
end

local function OnCellClick(self)
    if self.onClick then
        self.onClick()
    end
end

local function RefreshIcon(self)
    local lv = self.data.needLevel
    if lv <= 10 then
        self.icon:LoadSprite("Assets/Main/Sprites/UI/UIGrowthPlan/fund_icon_01.png")
    elseif lv <= 20 then
        self.icon:LoadSprite("Assets/Main/Sprites/UI/UIGrowthPlan/fund_icon_02.png")
    else
        self.icon:LoadSprite("Assets/Main/Sprites/UI/UIGrowthPlan/fund_icon_03.png")
    end
end

UIGrowthPlanItem.OnCreate = OnCreate
UIGrowthPlanItem.OnDestroy = OnDestroy
UIGrowthPlanItem.OnEnable = OnEnable
UIGrowthPlanItem.OnDisable = OnDisable
UIGrowthPlanItem.ComponentDefine = ComponentDefine
UIGrowthPlanItem.ComponentDestroy = ComponentDestroy
UIGrowthPlanItem.DataDefine = DataDefine
UIGrowthPlanItem.DataDestroy = DataDestroy
UIGrowthPlanItem.OnAddListener = OnAddListener
UIGrowthPlanItem.OnRemoveListener = OnRemoveListener

UIGrowthPlanItem.CellPos = CellPos
UIGrowthPlanItem.SetData = SetData
UIGrowthPlanItem.SetBlank = SetBlank
UIGrowthPlanItem.SetOnClick = SetOnClick
UIGrowthPlanItem.OnCellClick = OnCellClick
UIGrowthPlanItem.RefreshIcon = RefreshIcon

return UIGrowthPlanItem