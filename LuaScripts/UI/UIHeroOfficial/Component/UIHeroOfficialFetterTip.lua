---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/7/28 14:30
---

local UIHeroOfficialFetterTip = BaseClass("UIHeroOfficialFetterTip", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroOfficialFetterItem = require "UI.UIHeroOfficial.Component.UIHeroOfficialFetterItem"

local close_path = "Close"
local root_path = "Root"
local title_path = "Root/Bg/Title"
local list_path = "Root/Bg/List"
local desc_path = "Root/Bg/Desc"
local arrow_path = "Root/Arrow"

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
    self.root_anim = self:AddComponent(UIAnimator, root_path)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function()
        self:OnCloseClick()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.list_go = self:AddComponent(UIBaseContainer, list_path)
    self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_path)
    self.arrow_go = self:AddComponent(UIBaseContainer, arrow_path)
end

local function ComponentDestroy(self)
    self.root_anim = nil
    self.close_btn = nil
    self.title_text = nil
    self.list_go = nil
    self.desc_text = nil
    self.arrow_go = nil
end

local function DataDefine(self)
    self.camp = 0
    self.pos = 0
    self.itemList = {}
end

local function DataDestroy(self)
    self.camp = nil
    self.pos = nil
    self.itemList = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function SetData(self, camp, pos)
    self.camp = camp
    self.pos = pos
    local template = DataCenter.HeroOfficialManager:GetTemplate(camp, pos)

    self.title_text:SetLocalText(template.name)

    local templateList = DataCenter.HeroOfficialManager:GetTemplateList(camp, pos)
    for i, t in ipairs(templateList) do
        self:SetItem(i, t)
    end
    --if #templateList < #self.itemList then
    --    for i = #templateList + 1, #self.itemList do
    --        self.itemList[i]:SetActive(false)
    --    end
    --end
    
    -- 杨波 2023/3/30
    self.target = 0
    local buildingLv = DataCenter.HeroOfficialManager:GetBuildingLv()
    for i, template in ipairs(templateList) do
        if buildingLv >= template.unlockLv then
            self.target = i
        end
    end
    local nextTemplate = templateList[self.target + 1]
    self.target = math.max(self.target, 1)
    for i = 1, #self.itemList do
        self.itemList[i]:SetActive(i == self.target)
    end
    if nextTemplate then
        local nextVal = nextTemplate.maxVal
        if nextTemplate:GetValType() == "1" then
            nextVal = nextVal .. "%"
        end
        self.desc_text:SetText(
            Localization:GetString("133006", nextTemplate.unlockLv) .. "\n" ..
            Localization:GetString(UIHeroOfficialFetterItem.CampDesc[nextTemplate.camp], nextVal))
    else
        self.desc_text:SetText("")
    end
end

local function SetItem(self, i, template)
    if self.itemList[i] ~= nil then
        self.itemList[i]:SetTemplate(template)
        self.itemList[i]:SetActive(true)
    else
        self:GameObjectInstantiateAsync(UIAssets.UIHeroOfficialFetterItem, function(req)
            if req.isError or self.list_go == nil or self.itemList[i] ~= nil then
                req:Destroy()
                return
            end
            local go = req.gameObject
            go.name = tostring(i)
            go.transform:SetParent(self.list_go.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local item = self.list_go:AddComponent(UIHeroOfficialFetterItem, go.name)
            item:SetTemplate(template)
            item:SetActive(i == self.target) -- 杨波 2023/3/30
            self.itemList[i] = item
        end)
    end
end

local function Show(self)
    self:SetActive(true)
    self.root_anim:Play("CommonPopup_movein", 0, 0)
end

local function OnCloseClick(self)
    self:SetActive(false)
end

UIHeroOfficialFetterTip.OnCreate= OnCreate
UIHeroOfficialFetterTip.OnDestroy = OnDestroy
UIHeroOfficialFetterTip.ComponentDefine = ComponentDefine
UIHeroOfficialFetterTip.ComponentDestroy = ComponentDestroy
UIHeroOfficialFetterTip.DataDefine = DataDefine
UIHeroOfficialFetterTip.DataDestroy = DataDestroy
UIHeroOfficialFetterTip.OnEnable = OnEnable
UIHeroOfficialFetterTip.OnDisable = OnDisable

UIHeroOfficialFetterTip.SetData = SetData
UIHeroOfficialFetterTip.SetItem = SetItem
UIHeroOfficialFetterTip.Show = Show
UIHeroOfficialFetterTip.OnCloseClick = OnCloseClick

return UIHeroOfficialFetterTip