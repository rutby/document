---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/3/21 17:31
---

local UICrossWormSoldier = BaseClass("UICrossWormSoldier", UIBaseContainer)
local base = UIBaseContainer
local UICrossWormLeft = require "UI.CrossWorm.UICrossWorm.Component.UICrossWormLeft"
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local Localization = CS.GameEntry.Localization

local top_path = "Top"
local top_desc_path = "Top/TopDesc"
local info_path = "Top/TopDesc/Info"
local slider_path = "Top/Slider"
local count_path = "Top/Slider/Count"
local send_btn_path = "Top/Send"
local send_text_path = "Top/Send/SendText"

local bottom_path = "Bottom"
local bottom_desc_path = "Bottom/Viewport/Content/BottomDesc"

local left_path = "UICrossWormLeft"

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
    self.top_go = self:AddComponent(UIBaseContainer, top_path)
    self.bottom_go = self:AddComponent(UIBaseContainer, bottom_path)
    self.left = self:AddComponent(UICrossWormLeft, left_path)
    self.top_desc_text = self:AddComponent(UIText, top_desc_path)
    self.top_desc_text:SetLocalText(143647)
    self.bottom_desc_text = self:AddComponent(UIText, bottom_desc_path)
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(function()
        self:OnInfoClick()
    end)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.count_text = self:AddComponent(UIText, count_path)
    self.send_btn = self:AddComponent(UIButton, send_btn_path)
    self.send_btn:SetOnClick(function()
        self:OnSendClick()
    end)
    self.send_text = self:AddComponent(UIText, send_text_path)
    self.send_text:SetLocalText(143648)
end

local function ComponentDestroy(self)
    self.top_go = nil
    self.bottom_go = nil
    self.left = nil
    self.top_desc_text = nil
    self.bottom_desc_text = nil
    self.info_btn = nil
    self.slider = nil
    self.count_text = nil
    self.send_btn = nil
    self.send_text = nil
end

local function DataDefine(self)
    self.buildData = nil
end

local function DataDestroy(self)
    self.buildData = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.CrossWormSaveArmy, self.OnCrossWormSaveArmy)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.CrossWormSaveArmy, self.OnCrossWormSaveArmy)
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
    local cur = DataCenter.CrossWormManager:GetCurArmyNum()
    local max = DataCenter.CrossWormManager:GetMaxArmyNum()
    self.count_text:SetText(string.GetFormattedSeperatorNum(cur) .. "/" .. string.GetFormattedSeperatorNum(max))
    self.slider:SetValue(cur / max)
    self.bottom_desc_text:SetLocalText(143646, DataCenter.CrossWormManager:GetAddArmyMinCount())
end

local function SaveArmy(self, armyDict)
    local total = 0
    for _, count in pairs(armyDict) do
        total = total + count
    end
    
    if self.view.isPlace then
        local minCount = DataCenter.CrossWormManager:GetAddArmyMinCount()
        if total < minCount then
            UIUtil.ShowTips(Localization:GetString("143662", minCount))
            return
        end
        
        DataCenter.CrossWormManager:SetArmyToPlace(armyDict)
        BuildingUtils.ShowPutBuild(BuildingTypes.WORM_HOLE_CROSS, PlaceBuildType.Build, 0, SceneUtils.WorldToTileIndex(CS.SceneManager.World.CurTarget))
        self.view.ctrl:CloseSelf()
    else
        DataCenter.CrossWormManager:SendSaveArmy(armyDict)
    end
end

local function OnInfoClick(self)
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("143661", DataCenter.CrossWormManager:GetAddArmyMinCount())
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 300
    param.pivot = 0.5
    param.position = self.info_btn.transform.position + Vector3.New(0, -15, 0)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnSendClick(self)
    local restTimes = DataCenter.CrossWormManager:GetAddArmyRestTimes()
    local formation = DataCenter.CrossWormManager:GetDefenceFormation()
    local cur = DataCenter.CrossWormManager:GetCurArmyNum()
    local max = DataCenter.CrossWormManager:GetMaxArmyNum()
    
    if not self.view.isPlace then
        if self.buildData == nil then
            UIUtil.ShowTipsId(104273)
            return
        end
        
        if restTimes <= 0 then
            UIUtil.ShowTipsId(143667)
            return
        end

        if formation and formation.state == ArmyFormationState.March then
            UIUtil.ShowTipsId(143669)
            return
        end

        if cur >= max then
            UIUtil.ShowTipsId(143670)
            return
        end
    end
    
    local freeDict = DataCenter.ArmyFormationDataManager:GetArmyUnFormationList()
    local param = {}
    param.maxArmyCount = max - cur
    param.goText = Localization:GetString("143654")
    param.descText = ""
    param.armyDict = freeDict
    param.initFillArmyCount = DataCenter.CrossWormManager:GetAddArmyMinCount()
    param.onConfirm = function(armyDict)
        self:SaveArmy(armyDict)
    end
    param.onHide = function()
        self.view:MovePanel(false, false)
    end
    if Setting:GetPrivateInt(SettingKeys.CROSS_WORM_ADD_ARMY_NO_TIP, 0) == 0 then
        param.confirmSecondTip = Localization:GetString("143668")
        param.onCheck = function(isCheck)
            Setting:SetPrivateInt(SettingKeys.CROSS_WORM_ADD_ARMY_NO_TIP, isCheck and 1 or 0)
        end
    end
    UIUtil.ShowSelectArmy(param)
    self.view:MovePanel(true, false)
end

local function OnCrossWormSaveArmy(self)
    self:Refresh()
end

UICrossWormSoldier.OnCreate = OnCreate
UICrossWormSoldier.OnDestroy = OnDestroy
UICrossWormSoldier.ComponentDefine = ComponentDefine
UICrossWormSoldier.ComponentDestroy = ComponentDestroy
UICrossWormSoldier.DataDefine = DataDefine
UICrossWormSoldier.DataDestroy = DataDestroy
UICrossWormSoldier.OnAddListener = OnAddListener
UICrossWormSoldier.OnRemoveListener = OnRemoveListener
UICrossWormSoldier.OnEnable = OnEnable
UICrossWormSoldier.OnDisable = OnDisable

UICrossWormSoldier.Refresh = Refresh
UICrossWormSoldier.SaveArmy = SaveArmy

UICrossWormSoldier.OnInfoClick = OnInfoClick
UICrossWormSoldier.OnSendClick = OnSendClick

UICrossWormSoldier.OnCrossWormSaveArmy = OnCrossWormSaveArmy

return UICrossWormSoldier