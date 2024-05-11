---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/28 14:44
---

local UICrossWormLeft = BaseClass("UICrossWormLeft", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local go_btn_path = "Go"
local go_text_path = "Go/GoText"
local yes_path = "State/Yes"
local no_path = "State/No"
local delete_path = "Delete"

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
    self.go_btn = self:AddComponent(UIButton, go_btn_path)
    self.go_btn:SetOnClick(function()
        self:OnGoClick()
    end)
    self.go_text = self:AddComponent(UIText, go_text_path)
    self.go_text:SetLocalText(110003)
    self.yes_text = self:AddComponent(UIText, yes_path)
    self.yes_text:SetLocalText(143641)
    self.no_text = self:AddComponent(UIText, no_path)
    self.no_text:SetLocalText(143642)
    self.delete_btn = self:AddComponent(UIButton, delete_path)
    self.delete_btn:SetOnClick(function()
        self:OnDeleteClick()
    end)
end

local function ComponentDestroy(self)
    self.go_btn = nil
    self.go_text = nil
    self.yes_text = nil
    self.no_text = nil
    self.delete_btn = nil
end

local function DataDefine(self)
    
end

local function DataDestroy(self)
    
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:Refresh()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function Refresh(self)
    self.buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
    self.go_btn:SetActive(SceneUtils.GetIsInCity())
    self.yes_text:SetActive(self.buildData ~= nil)
    self.no_text:SetActive(self.buildData == nil)
    self.delete_btn:SetActive(self.buildData ~= nil)
end

local function OnGoClick(self)
    if self.buildData == nil then
        UIUtil.ShowTipsId(104273)
        return
    end
    
    GoToUtil.GotoCrossWorm()
end

local function OnDeleteClick(self)
    local plunderData = DataCenter.CrossWormManager:GetPlunderData()
    if not plunderData:IsEmpty() then
        UIUtil.ShowTipsId(143671)
        return
    end
    
    UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.BUILD_PUCK_UP_CONFIRM_DES), 2, nil, nil, function()
        self.view.ctrl:CloseSelf()
        SFSNetwork.SendMessage(MsgDefines.FreeBuildingFoldUpNew, { buildUuid = self.buildData.uuid })
    end)
end

UICrossWormLeft.OnCreate = OnCreate
UICrossWormLeft.OnDestroy = OnDestroy
UICrossWormLeft.ComponentDefine = ComponentDefine
UICrossWormLeft.ComponentDestroy = ComponentDestroy
UICrossWormLeft.DataDefine = DataDefine
UICrossWormLeft.DataDestroy = DataDestroy
UICrossWormLeft.OnAddListener = OnAddListener
UICrossWormLeft.OnRemoveListener = OnRemoveListener
UICrossWormLeft.OnEnable = OnEnable
UICrossWormLeft.OnDisable = OnDisable

UICrossWormLeft.Refresh = Refresh

UICrossWormLeft.OnGoClick = OnGoClick
UICrossWormLeft.OnDeleteClick = OnDeleteClick

return UICrossWormLeft