---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/2/15 11:54
---

local UIHeroIntensifyContent = BaseClass("UIHeroIntensifyContent", UIBaseContainer)
local base = UIBaseContainer
local UIHeroIntensifyItem = require "UI.UIHeroIntensify.Component.UIHeroIntensifyItem"
local Localization = CS.GameEntry.Localization

local info_path = "Info"
local content_path = "ScrollView/Viewport/Content"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.info_btn = self:AddComponent(UIButton, info_path)
    self.info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoClick()
    end)
    self.content_go = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
    self.info_btn = nil
    self.content_go = nil
end

local function DataDefine(self)
    self.camp = -1
    self.reqs = {}
    self.items = {}
    self.lineReqs = {}
end

local function DataDestroy(self)
    self.content_go:RemoveComponents(UIHeroIntensifyItem)
    for _, req in pairs(self.reqs) do
        req:Destroy()
    end
    for _, req in pairs(self.lineReqs) do
        req:Destroy()
    end
    self.reqs = {}
    self.items = {}
    self.lineReqs = {}
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self:Refresh()
end

local function Refresh(self)
    if self.camp == -1 then
        return
    end
    
    DataCenter.HeroIntensifyManager.isUnlocking = false
    local ids = DataCenter.HeroIntensifyManager:GetShowIds(self.camp)
    local count = #ids + 1
    local yMax = 0
    for i = 1, count do
        local x, y = self:GetItemPos(i)
        yMax = math.max(yMax, math.abs(y))
        local id = ids[i]
        if self.items[i] then
            self.items[i]:SetCamp(self.camp)
            self.items[i]:SetData(id)
            self.items[i]:SetIndex(i)
            self.items[i]:ShowLine(i < count)
        else
            if self.reqs[i] then
                self.reqs[i]:Destroy()
            end
            self.reqs[i] = self:GameObjectInstantiateAsync("Assets/Main/Prefab_Dir/UI/UIHeroIntensify/UIHeroIntensifyItem.prefab", function(req)
                if req.isError then
                    return
                end
                local go = req.gameObject
                go.transform:SetParent(self.content_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:Set_localPosition(x, y, 0)
                go.name = "Item_" .. i
                local item = self.content_go:AddComponent(UIHeroIntensifyItem, go.name)
                item:SetCamp(self.camp)
                item:SetData(id)
                item:SetIndex(i)
                item:ShowLine(i < count)
                self.items[i] = item
            end)
        end
    end

    self.content_go.rectTransform:Set_sizeDelta(0, yMax + 150)
end

local function SetCamp(self, camp)
    self.camp = camp
    self:Refresh()
end

local function GetItemPos(self, index)
    local x, y = 0, 0
    if index == 1 then
        x = 193.5
        y = -260
    else
        local q = (index - 2) // 6 -- quotient
        local r = (index - 2) % 6 -- remainder
        if r == 0 then
            x = 434
            y = -100.5
        elseif r == 1 then
            x = 781.5
            y = -100.5
        elseif r == 2 then
            x = 971
            y = -260.5
        elseif r == 3 then
            x = 737.5
            y = -445
        elseif r == 4 then
            x = 386.5
            y = -445
        elseif r == 5 then
            x = 193.5
            y = -604
        end
        y = y - q * 690
    end
    return x, y
end

local function OnInfoClick(self)
    UIUtil.ShowIntro(Localization:GetString("136000"), "", Localization:GetString("136003", DataCenter.HeroIntensifyManager:GetUnlockSeason() + 1))
end

UIHeroIntensifyContent.OnCreate= OnCreate
UIHeroIntensifyContent.OnDestroy = OnDestroy
UIHeroIntensifyContent.ComponentDefine = ComponentDefine
UIHeroIntensifyContent.ComponentDestroy = ComponentDestroy
UIHeroIntensifyContent.DataDefine = DataDefine
UIHeroIntensifyContent.DataDestroy = DataDestroy
UIHeroIntensifyContent.OnEnable = OnEnable
UIHeroIntensifyContent.OnDisable = OnDisable
UIHeroIntensifyContent.OnAddListener = OnAddListener
UIHeroIntensifyContent.OnRemoveListener = OnRemoveListener

UIHeroIntensifyContent.ReInit = ReInit
UIHeroIntensifyContent.Refresh = Refresh
UIHeroIntensifyContent.SetCamp = SetCamp
UIHeroIntensifyContent.GetItemPos = GetItemPos
UIHeroIntensifyContent.OnInfoClick = OnInfoClick

return UIHeroIntensifyContent