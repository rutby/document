---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/5/15 16:25
---
local AllianceActMineTip = BaseClass("AllianceActMineTip", UIBaseContainer)
local AllianceActMineTipItem = require "UI.UIActivityCenterTable.Component.AllianceActMine.AllianceActMineTipItem"
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local title_path = "Root/img/TextTitle"
local title_level_path = "Root/img/TextLevel"
local title_num_path = "Root/img/TextNum"
local root_path ="Root"
local item1_path ="Root/Content/checkItem1"
local item2_path ="Root/Content/checkItem2"
local item3_path ="Root/Content/checkItem3"

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
    self.title = self:AddComponent(UIText,title_path)
    self.title:SetLocalText(374010)
    self.txt_level = self:AddComponent(UIText,title_level_path)
    self.txt_level:SetLocalText(374008)
    self.txt_num = self:AddComponent(UIText,title_num_path)
    self.txt_num:SetLocalText(374009)
    self.root = self:AddComponent(UIBaseContainer,root_path)
    self.item1 = self:AddComponent(AllianceActMineTipItem,item1_path)
    self.item2 = self:AddComponent(AllianceActMineTipItem,item2_path)
    self.item3 = self:AddComponent(AllianceActMineTipItem,item3_path)
    self.close_btn = self:AddComponent(UIButton, "Panel")
    self.close_btn:SetOnClick(function()
        self:HideTips()
    end)

end

local function ComponentDestroy(self)
    self.title = nil
    self.name = nil
    self.num = nil
end

local function DataDefine(self)
end

local function DataDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function RefreshCondition(self,parent)
    self.parent = parent
    if self.parent.data~=nil and self.parent.data.type == ActivityEnum.ActivityType.EdenAllianceActMine then
        self.item1:SetData(BuildingTypes.EDEN_ALLIANCE_ACT_RES_1)
        self.item2:SetData(BuildingTypes.EDEN_ALLIANCE_ACT_RES_2)
        self.item3:SetData(BuildingTypes.EDEN_ALLIANCE_ACT_RES_3)
    elseif self.parent.data~=nil and self.parent.data.type == ActivityEnum.ActivityType.EdenAllianceCrossActMine then
        self.item1:SetData(BuildingTypes.EDEN_CROSS_ALLIANCE_ACT_RES_1)
        self.item2:SetData(BuildingTypes.EDEN_CROSS_ALLIANCE_ACT_RES_2)
        self.item3:SetData(BuildingTypes.EDEN_CROSS_ALLIANCE_ACT_RES_3)
    else
        self.item1:SetData(BuildingTypes.ALLIANCE_ACT_RES_1)
        self.item2:SetData(BuildingTypes.ALLIANCE_ACT_RES_2)
        self.item3:SetData(BuildingTypes.ALLIANCE_ACT_RES_3)
    end
    
end

local function OnSetPos(self,pos)
    --self.root.transform.position = pos
end

local function HideTips(self)
    if self.parent~=nil then
        self.parent:HideTips()
    end
end

AllianceActMineTip.OnCreate= OnCreate
AllianceActMineTip.OnDestroy = OnDestroy
AllianceActMineTip.ComponentDefine = ComponentDefine
AllianceActMineTip.ComponentDestroy = ComponentDestroy
AllianceActMineTip.DataDefine = DataDefine
AllianceActMineTip.DataDestroy = DataDestroy
AllianceActMineTip.OnEnable = OnEnable
AllianceActMineTip.OnDisable = OnDisable
AllianceActMineTip.RefreshCondition = RefreshCondition
AllianceActMineTip.OnSetPos = OnSetPos
AllianceActMineTip.HideTips =HideTips
return AllianceActMineTip