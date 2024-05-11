---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---UIActivitySummaryView

local base = UIBaseView--Variable
local UIActivitySummaryView = BaseClass("UIActivitySummaryView", base)--Variable
local Localization = CS.GameEntry.Localization
local ActivitySummaryPanel = require "UI.UIActivitySummary.Component.ActivitySummary.ThemeActivitySummaryPanel"
local ThemeChristmasPanel = require "UI.UIActivitySummary.Component.Christmas.ThemeChristmasPanel"

local closeBtn_path = "BtnClose"
local panelContainer_path = "panelContainer"

local SubPanelConf = {
    [EnumActivity.ActivitySummary.Type] = {
        Asset = "ThemeActivitySummaryPanel",
        Script = ActivitySummaryPanel,
    },
    [EnumActivity.ThemeChristmas.Type] = {
        Asset = "ThemeChristmasPanel",
        Script = ThemeChristmasPanel,
    }
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitData()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.RefreshItems, self.RefreshResCount)
end


local function OnRemoveListener(self)
    --self:RemoveUIListener(EventId.RefreshItems, self.RefreshResCount)
    base.OnRemoveListener(self)
end

local function ComponentDefine(self)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.panelContainerN = self:AddComponent(UIBaseContainer, panelContainer_path)
    self.panelDic = {}--type:PanelN
end

local function ComponentDestroy(self)
    self.closeBtnN = nil
    self.panelContainerN = nil
    self.panelDic = nil
end

local function DataDefine(self)
    self.curActivityType = nil
    self.reqDic = {}
end

local function DataDestroy(self)
    self.curActivityType = nil
    self.reqDic = nil
end

local function InitData(self)
    self.curActivityType = self:GetUserData()
    self.activityInfo = DataCenter.ThemeActivityManager:GetThemeActivityInfo(self.curActivityType)
    if not self.activityInfo then
        return
    end
    
    self:ShowPanel()
end

local function ShowPanel(self)
    if not self.panelDic[self.curActivityType] then
        local prefabName = self.activityInfo.activity_pic
        if string.IsNullOrEmpty(prefabName) then
            if SubPanelConf[self.curActivityType] then
                prefabName = SubPanelConf[self.curActivityType].Asset
            else
                prefabName = "ActivitySummaryPanel"
            end
        end
        local assetFullPath = string.format("Assets/Main/Prefab_Dir/UI/UIActivitySummary/%s.prefab", prefabName)
        if self.reqDic[self.curActivityType] then
            return
        end
        self.reqDic[self.curActivityType] = self:GameObjectInstantiateAsync(assetFullPath, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject;
            go.transform:SetParent(self.panelContainerN.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local v3 = go.transform.position
            v3.x = 0
            v3.y = 0
            go.transform.position = v3
            local cell = self.panelContainerN:AddComponent(SubPanelConf[self.curActivityType].Script, go)
            cell:SetActive(true)
            cell:ShowPanel(self.activityInfo)
            self.panelDic[self.curActivityType] = cell
        end)
    else
        self.panelDic[self.curActivityType]:ShowPanel(self.activityInfo)
    end
end

local function OnClickPackageBtn(self, isShow)
    local tempPanel = self.panelDic[self.curActivityType]
    if tempPanel and tempPanel.ShowPackagePanel then
        tempPanel:ShowPackagePanel(isShow)
    end
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end


UIActivitySummaryView.OnCreate = OnCreate 
UIActivitySummaryView.OnDestroy = OnDestroy
UIActivitySummaryView.OnAddListener = OnAddListener
UIActivitySummaryView.OnRemoveListener = OnRemoveListener
UIActivitySummaryView.ComponentDefine = ComponentDefine
UIActivitySummaryView.ComponentDestroy = ComponentDestroy
UIActivitySummaryView.DataDefine = DataDefine
UIActivitySummaryView.DataDestroy = DataDestroy

UIActivitySummaryView.InitData = InitData
UIActivitySummaryView.ShowPanel = ShowPanel
UIActivitySummaryView.OnClickCloseBtn = OnClickCloseBtn
UIActivitySummaryView.OnClickPackageBtn = OnClickPackageBtn

return UIActivitySummaryView