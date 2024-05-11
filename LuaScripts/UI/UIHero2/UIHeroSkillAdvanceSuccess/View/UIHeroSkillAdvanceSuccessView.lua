---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/3/9 19:19
---

local UIHeroSkillAdvanceSuccessView = BaseClass("UIHeroSkillAdvanceSuccessView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource
local UIHeroSkillAdvanceSuccessLine = require "UI.UIHero2.UIHeroSkillAdvanceSuccess.Component.UIHeroSkillAdvanceSuccessLine"
local UIHeroMilitarySkillIcon = require "UI.UIHero2.UIHeroMilitaryRank.Component.UIHeroMilitarySkillIcon"

local title_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local next_path = "UIGarageRefitUpgrade/UICommonRewardPopUp/Panel"
local root_path = "UIGarageRefitUpgrade/Root"
local item_path = "UIGarageRefitUpgrade/Root/UIGarageRefitItem/HeroSkillIcon"
local content_path = "UIGarageRefitUpgrade/Root/Content"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.title_text = self:AddComponent(UIText, title_path)
    self.title_text:SetLocalText(120062)
    self.next_btn = self:AddComponent(UIButton, next_path)
    self.next_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.root_anim = self:AddComponent(UIAnimator, root_path)
    self.skillIcon = self:AddComponent(UIHeroMilitarySkillIcon, item_path)
    self.content_go = self:AddComponent(UIBaseContainer, content_path)
end

local function ComponentDestroy(self)
    self:ClearItems()
    self.title_text = nil
    self.next_btn = nil
    self.root_anim = nil
    self.skillIcon = nil
    self.item_anim = nil
    self.content_go = nil
end

local function DataDefine(self)
    self.reqs = {}
    self.active = false
    self.levels = nil
    self.typeList = {}
    self.onClose = nil
end

local function DataDestroy(self)
    self.reqs = nil
    self.active = nil
    self.levels = nil
    self.typeList = nil
    self.onClose = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    self.active = true
end

local function OnDisable(self)
    self.active = false
    base.OnDisable(self)
end

local function ReInit(self)
    self.heroUuid, self.skillId = self:GetUserData()
    self:Show()
end

local function Show(self)
    if self.root_anim ~= nil then
        self.root_anim:Play("V_ui_bujianshengji_01_anim", 0, 0)
    end

    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.heroUuid)
    if heroData ~= nil then
        local currentSkillLv = heroData:GetSkillLevel(self.skillId) - 1
        local nextSkillLv = currentSkillLv + 1
        if currentSkillLv == 0 then
            self.title_text:SetLocalText(100213)
        end
        self.skillIcon:SetData(self.skillId, nextSkillLv, false, 0.8, true)
        local effectStr = GetTableData(TableName.SkillTab, self.skillId, 'effect_num_des')
        local effectNumStr = GetTableData(TableName.SkillTab, self.skillId, 'effect_des')
        
        local effectVec = string.split(effectStr, "|")
        local effectValueVec = string.split(effectNumStr, "|")

        local currentEffectValue = nil
        if currentSkillLv >= 1 then
            currentEffectValue = string.split(effectValueVec[currentSkillLv], ";")
        end
        local nextEffectValue = string.split(effectValueVec[nextSkillLv], ";")

        if currentEffectValue == nil or (table.count(effectVec) == table.count(currentEffectValue) and table.count(effectVec) == table.count(nextEffectValue)) then
            local index = 1
            local total = table.count(effectVec)
            while index <= total do
                local effectId = effectVec[index]
                local nameStr = GetTableData(TableName.EffectNumDesc, effectId, 'des')
                local current = nil
                if currentEffectValue ~= nil then
                    current = currentEffectValue[index]
                end
                local next = nextEffectValue[index]
                local curIndex = index
                local req = Resource:InstantiateAsync(UIAssets.UISkillAdvanceSuccessCell)
                req:completed('+', function()
                    if req.isError then
                        return
                    end

                    if not self.gameObject or not self.active then
                        req:Destroy()
                        return
                    end

                    local go = req.gameObject
                    go:SetActive(true)
                    go.name = "Line_" .. tostring(curIndex)

                    local tf = go.transform
                    tf:SetParent(self.content_go.transform)
                    tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

                    local item = self.content_go:AddComponent(UIHeroSkillAdvanceSuccessLine, go)
                    item:SetData(Localization:GetString(nameStr), current, next)
                    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content_go.transform)

                    self.reqs[curIndex] = req
                end)
                index = index + 1
            end
        end
    end
end

local function ClearItems(self)
    self.content_go:RemoveComponents(UIHeroSkillAdvanceSuccessLine)
    for _, req in pairs(self.reqs) do
        req:Destroy()
    end
end

UIHeroSkillAdvanceSuccessView.OnCreate= OnCreate
UIHeroSkillAdvanceSuccessView.OnDestroy = OnDestroy
UIHeroSkillAdvanceSuccessView.ComponentDefine = ComponentDefine
UIHeroSkillAdvanceSuccessView.ComponentDestroy = ComponentDestroy
UIHeroSkillAdvanceSuccessView.DataDefine = DataDefine
UIHeroSkillAdvanceSuccessView.DataDestroy = DataDestroy
UIHeroSkillAdvanceSuccessView.OnEnable = OnEnable
UIHeroSkillAdvanceSuccessView.OnDisable = OnDisable
UIHeroSkillAdvanceSuccessView.ReInit = ReInit
UIHeroSkillAdvanceSuccessView.ClearItems = ClearItems
UIHeroSkillAdvanceSuccessView.Show = Show

return UIHeroSkillAdvanceSuccessView