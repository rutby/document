
local UIHeroAdvanceOneKeySuccessView = BaseClass("UIHeroAdvanceOneKeySuccessView", UIBaseView)
local base = UIBaseView

local UIHeroCellSmall = require "UI.UIHero2.Common.UIHeroCellSmall"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.textTitle = self:AddComponent(UIText, "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle")
    self.textTitle:SetLocalText(150137)
    
    local btnClose = self:AddComponent(UIButton, "UICommonRewardPopUp/Panel")
    btnClose:SetOnClick(BindCallback(self.ctrl, self.ctrl.CloseSelf))

    self.scroll_view = self:AddComponent(UIScrollView, "Root/ScrollView")
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)

    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self:ShowScroll()
end

local function ShowScroll(self)
    self:ClearScroll()

    self.dataList = self.view.ctrl:GetPanelData(self:GetUserData())
    local count = table.count(self.dataList)

    if count <= 0 then
        return
    end

    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells(1)
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIHeroCellSmall)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(UIHeroCellSmall, itemObj)
    local data = self.dataList[index]
    cellItem:SetData(data.uuid, false, nil, true)
end

local function OnDeleteCell(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIHeroCellSmall)
end

local function ComponentDestroy(self)
    self:ClearScroll()
end

UIHeroAdvanceOneKeySuccessView.OnCreate= OnCreate
UIHeroAdvanceOneKeySuccessView.OnDestroy = OnDestroy
UIHeroAdvanceOneKeySuccessView.ComponentDefine = ComponentDefine
UIHeroAdvanceOneKeySuccessView.ComponentDestroy = ComponentDestroy
UIHeroAdvanceOneKeySuccessView.ShowScroll = ShowScroll
UIHeroAdvanceOneKeySuccessView.ClearScroll = ClearScroll
UIHeroAdvanceOneKeySuccessView.OnCreateCell = OnCreateCell
UIHeroAdvanceOneKeySuccessView.OnDeleteCell = OnDeleteCell

return UIHeroAdvanceOneKeySuccessView
