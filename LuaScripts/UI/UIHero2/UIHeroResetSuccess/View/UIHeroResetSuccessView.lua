---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 2021/6/28 下午6:48
---


local UIHeroResetSuccessView = BaseClass("UIHeroResetSuccessView", UIBaseView)
local base = UIBaseView

local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"
local UIItemCell = require "UI.UIHero2.Common.UIItemCell"

local MaxItemNum = 15

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    
    local heroUuid, retItems, bAdvance = self:GetUserData()
    self.heroCell:SetActive(not bAdvance)
    if not bAdvance then
        self.heroCell:SetData(heroUuid, nil, nil, true)
    end
    self.textTitle:SetLocalText(bAdvance and 129115 or 150138)
    self.textAdvanceTip:SetActive(bAdvance)

    for k=1, MaxItemNum do
        local itemNode = self.nodeItems[k]
        local itemData = retItems[k]
        itemNode:SetActive(itemData ~= nil)
        if itemData ~= nil then
            itemNode:SetData(itemData["id"], itemData["add"])
        end
    end
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)

    self.callback = nil
end

local function ComponentDefine(self)
    self.textTitle = self:AddComponent(UIText, "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle")
    self.textTitle:SetLocalText(150138)
    self.textAdvanceTip = self:AddComponent(UIText, 'Root/TextAdvanceTip')
    self.textAdvanceTip:SetLocalText(129116)
    
    local btnClose = self:AddComponent(UIButton, "UICommonRewardPopUp/Panel")
    btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))

    self.heroCell = self:AddComponent(UIHeroCellSmall, "Root/Content/UIHeroCellSmall")
    self.nodeItems = {}
    for k=1, MaxItemNum do
        local node = self:AddComponent(UIItemCell, "Root/Content/UIItem" .. k)
        table.insert(self.nodeItems, node)
    end
end

local function ComponentDestroy(self)
    self.heroCell = nil
    self.nodeItems = nil
end

UIHeroResetSuccessView.OnCreate= OnCreate
UIHeroResetSuccessView.OnDestroy = OnDestroy
UIHeroResetSuccessView.ComponentDefine = ComponentDefine
UIHeroResetSuccessView.ComponentDestroy = ComponentDestroy

return UIHeroResetSuccessView
