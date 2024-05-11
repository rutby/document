---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 23/1/2024 下午7:12
---
local UIFormationAddView = BaseClass("UIFormationAddView", UIBaseView)
local base = UIBaseView
local FormationAddItem = require "UI.UIFormation.UIFormationAdd.Component.FormationAddItem"
local Localization = CS.GameEntry.Localization

local txt_title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local scroll_view_path = "bg/ScrollView"


local function OnCreate(self)
    base.OnCreate(self)
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.txt_title:SetLocalText(121004)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
end

local function OnDestroy(self)
    self:ClearScroll()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:RefreshData()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function RefreshData(self)
    self:ClearScroll()
    self.list = self.ctrl:GetShowList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

local function ClearScroll(self)
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(FormationAddItem)--清循环列表gameObject
    self.list = {}
end

local function OnCellMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(FormationAddItem, itemObj)
    item:Refresh(self.list[index])
end

local function OnCellMoveOut(self,itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, FormationAddItem)
end

UIFormationAddView.OnCreate= OnCreate
UIFormationAddView.OnDestroy = OnDestroy
UIFormationAddView.OnEnable= OnEnable
UIFormationAddView.OnDisable = OnDisable
UIFormationAddView.ClearScroll =ClearScroll
UIFormationAddView.RefreshData = RefreshData
UIFormationAddView.OnCellMoveIn =OnCellMoveIn
UIFormationAddView.OnCellMoveOut = OnCellMoveOut
return UIFormationAddView