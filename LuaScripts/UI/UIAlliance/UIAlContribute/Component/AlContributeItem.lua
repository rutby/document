---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/22 12:03
--- AlContributeItem.lua


local AllianceQaItem = BaseClass("AllianceQaItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"

local icon_path = "Bg/Offset/Icon"
local name_path = "Bg/Offset/name"
local count_path = "Bg/Offset/score"
local infoBtn_path = "Bg/Offset/score/infoBtn"

-- 创建 
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
    self.iconN = self:AddComponent(UIImage, icon_path)
    self.nameN = self:AddComponent(UIText, name_path)
    self.countN = self:AddComponent(UIText, count_path)
    self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    
end

--控件的销毁
local function ComponentDestroy(self)
    self.iconN = nil
    self.nameN = nil
    self.countN = nil
    self.infoBtnN = nil
end

--变量的定义
local function DataDefine(self)
    
end

--变量的销毁
local function DataDestroy(self)
    
end


local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnUpdateAlLeaderCandidates, self.OnCandidateInfoUpdated)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnUpdateAlLeaderCandidates, self.OnCandidateInfoUpdated)
end

local function SetItem(self, contributeInfo)
    self.contributeInfo = contributeInfo
    
    self.iconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIAlContribute/%s.png", contributeInfo.pic))
    
    local name = contributeInfo.name
    local value = contributeInfo.value
    if value ~= nil and type(value) == "table" and value.Length > 0 then
        local valueLuaTable = {}
        for i = 1, value.Length do
            table.insert(valueLuaTable , value[i-1])
        end
        local descExpand = CommonUtil.GetNameByParams(name, valueLuaTable)
        self.nameN:SetText(descExpand)
    elseif contributeInfo.valueStr ~= nil then
        local valueArr = string.split(contributeInfo.valueStr , ",")
        local descExpand = CommonUtil.GetNameByParams(name, valueArr)
        self.nameN:SetText(descExpand)
    else
        self.nameN:SetLocalText(name,  value)
    end

    if string.IsNullOrEmpty(contributeInfo.tips) then
        self.countN:SetText("+" .. contributeInfo.points)
        self.infoBtnN:SetActive(false)
    else
        self.countN:SetLocalText(372756)
        self.infoBtnN:SetActive(true)
    end
end

local function OnClickInfoBtn(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.infoBtnN.transform.position + Vector3.New(-30, 0, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString(self.contributeInfo.tips)
    param.dir = UIHeroTipView.Direction.LEFT
    param.defWidth = 350
    param.pivot = 0.2
    param.position = position

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end


AllianceQaItem.OnCreate = OnCreate
AllianceQaItem.OnDestroy = OnDestroy
AllianceQaItem.OnEnable = OnEnable
AllianceQaItem.OnDisable = OnDisable
AllianceQaItem.ComponentDefine = ComponentDefine
AllianceQaItem.ComponentDestroy = ComponentDestroy
AllianceQaItem.DataDefine = DataDefine
AllianceQaItem.DataDestroy = DataDestroy
AllianceQaItem.OnAddListener = OnAddListener
AllianceQaItem.OnRemoveListener = OnRemoveListener

AllianceQaItem.SetItem = SetItem
AllianceQaItem.OnClickInfoBtn = OnClickInfoBtn


return AllianceQaItem