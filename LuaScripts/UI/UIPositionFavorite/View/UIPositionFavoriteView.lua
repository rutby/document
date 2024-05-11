---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Still4.
--- DateTime: 2021/7/1 11:46
---
local BookMarkItem = require "UI.UIPositionFavorite.Component.UIPositionFavoriteItem"
local UIPositionFavoriteView = BaseClass("UIPositionFavoriteView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local txt_title_path ="ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local scroll_path = "ImgBg/List/ScrollView"
local empty_txt_path = "ImgBg/List/TxtEmpty"
local toggle1_path= "ImgBg/Tab/toggle1"
local toggle2_path= "ImgBg/Tab/toggle2"
local toggle3_path= "ImgBg/Tab/toggle3"
local toggle4_path= "ImgBg/Tab/toggle4"
local toggle5_path= "ImgBg/Tab/toggle5"

local function OnCreate(self)
    base.OnCreate(self)
    self.txt_title = self:AddComponent(UIText, txt_title_path)
    self.txt_title:SetLocalText(100188) 
    self.empty_txt = self:AddComponent(UIText, empty_txt_path)
    -- 当前选中
    self.toggle = nil
    --全部
    self.toggle1 = self:AddComponent(UIToggle, toggle1_path)
    self.toggle1:SetIsOn(true)
    self.toggle1:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS()
        end
    end)
    self.toggle1.text = self.toggle1:AddComponent(UIText, "Text")
    self.toggle1.text:SetLocalText(150118) 
    --特殊
    self.toggle2 = self:AddComponent(UIToggle, toggle2_path)
    self.toggle2:SetIsOn(false)
    self.toggle2:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS()
        end
    end)
    self.toggle2.text = self.toggle2:AddComponent(UIText, "Text")
    self.toggle2.text:SetLocalText(100185) 
    --朋友
    self.toggle3 = self:AddComponent(UIToggle, toggle3_path)
    self.toggle3:SetIsOn(false)
    self.toggle3:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS()
        end
    end)
    self.toggle3.text = self.toggle3:AddComponent(UIText, "Text")
    self.toggle3.text:SetLocalText(100186) 
    --敌人
    self.toggle4 = self:AddComponent(UIToggle, toggle4_path)
    self.toggle4:SetIsOn(false)
    self.toggle4:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS()
        end
    end)
    self.toggle4.text = self.toggle4:AddComponent(UIText, "Text")
    self.toggle4.text:SetLocalText(GameDialogDefine.BOOKMARK_ENEMY) 
    --联盟
    self.toggle5 = self:AddComponent(UIToggle, toggle5_path)
    self.toggle5:SetIsOn(false)
    self.toggle5:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS()
        end
    end)
    self.toggle5.text = self.toggle5:AddComponent(UIText, "Text")
    self.toggle5.text:SetLocalText(GameDialogDefine.ALLIANCE) 
    
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.list ={}
    self.curTab =-1
end

local function OnDestroy(self)
    self.txt_title = nil
    self.empty_txt = nil
    self.close_btn =nil
    self.return_btn = nil
    self.ScrollView = nil
    self.toggle = nil
    self.toggle1.text = nil
    self.toggle1=nil
    self.toggle2.text = nil
    self.toggle2=nil
    self.toggle3.text = nil
    self.toggle3=nil
    self.toggle4.text = nil
    self.toggle4=nil
    self.toggle5.text = nil
    self.toggle5=nil
    self.list = nil
    base.OnDestroy(self)
end

local function RefreshMarkList(self)
    self:ClearScroll(self)
    self.list = self.ctrl:GetMarkListByTab(self.curTab)
    if #self.list > 0 then
        self.ScrollView:SetTotalCount(#self.list)
        self.ScrollView:RefillCells()
        self.empty_txt:SetText("")
    else
        if self.curTab == -1 then
            self.empty_txt:SetLocalText(128007) 
        else
            self.empty_txt:SetLocalText(300008,  self.toggle.text:GetText()) 
        end
    end
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ToggleControlBorS()
end

local function OnDisable(self)
    self:ClearScroll(self)
    base.OnDisable(self)

end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(BookMarkItem, itemObj)
    cellItem:SetItemShow(self.list[index])
end

local function OnItemMoveOut(self, itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, BookMarkItem)
end

local function ClearScroll(self)
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(BookMarkItem)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshBookmark, self.RefreshMarkList)
end

local function ToggleControlBorS(self)
    if self.toggle1:GetIsOn() then
        self.curTab =-1
        self.toggle = self.toggle1
    elseif self.toggle2:GetIsOn() then
        self.curTab = 0
        self.toggle = self.toggle2
    elseif self.toggle3:GetIsOn() then
        self.curTab = 1
        self.toggle = self.toggle3
    elseif self.toggle4:GetIsOn() then
        self.curTab = 2
        self.toggle = self.toggle4
    elseif self.toggle5:GetIsOn() then
        self.curTab = 3
        self.toggle = self.toggle5
    end
    self:RefreshMarkList()
end
UIPositionFavoriteView.OnCreate= OnCreate
UIPositionFavoriteView.OnDestroy = OnDestroy
UIPositionFavoriteView.RefreshMarkList = RefreshMarkList
UIPositionFavoriteView.OnEnable = OnEnable
UIPositionFavoriteView.OnDisable = OnDisable
UIPositionFavoriteView.OnItemMoveIn = OnItemMoveIn
UIPositionFavoriteView.OnItemMoveOut = OnItemMoveOut
UIPositionFavoriteView.ClearScroll = ClearScroll
UIPositionFavoriteView.OnAddListener = OnAddListener
UIPositionFavoriteView.OnRemoveListener = OnRemoveListener
UIPositionFavoriteView.ToggleControlBorS = ToggleControlBorS
return UIPositionFavoriteView