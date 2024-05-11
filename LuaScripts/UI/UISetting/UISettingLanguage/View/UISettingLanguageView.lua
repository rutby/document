---
--- 设置语言界面
--- Created by shimin.
--- DateTime: 2020/9/22 11:28
---
local UISettingLanguageCell = require "UI.UISetting.UISettingLanguage.Component.UISettingLanguageCell"
local UISettingLanguageView = BaseClass("UISettingLanguageView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local txt_title_path ="UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local scroll_view_path = "ImgBg/ScrollView"
--local conform_btn_path = "ImgBg/ConfirmBtn"
--local conform_name_path = "ImgBg/ConfirmBtn/ConfirmBtnName"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:SetAllCellsDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
   -- self.conform_btn = self:AddComponent(UIButton, conform_btn_path)
   -- self.conform_name = self:AddComponent(UITextMeshProUGUIEx, conform_name_path)
    
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)

    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    --self.conform_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
    --    self:OnConfirmBtnClick()
    --end)
end

local function ComponentDestroy(self)
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self.scroll_view = nil
    self.conform_btn = nil
    self.conform_name = nil
end


local function DataDefine(self)
    self.list = {}
    self.cells = {}
    self.selectIndex = nil
    self.initLanguage = nil
end

local function DataDestroy(self)
    self.list = nil
    self.cells = nil
    self.selectIndex = nil
    self.initLanguage = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.txt_title:SetLocalText(100101) 
   -- self.conform_name:SetLocalText(GameDialogDefine.CONFIRM) 
    self.initLanguage =  Localization:GetLanguage()
    self:ShowCells()
end

-- 表现销毁
local function SetAllCellsDestroy(self)
    self:ClearScroll()
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ShowCells(self)
    self:ClearScroll()
    self.list = self:GetShowList()
    local tempCount = table.count(self.list)
    if tempCount > 0 then
        self.scroll_view:SetTotalCount(tempCount)
        self.scroll_view:RefillCells()
    end
end

local function OnCellMoveIn(self,itemObj, index)
    local tempType = self.list[index]
    itemObj.name = tempType
    local cellItem = self.scroll_view:AddComponent(UISettingLanguageCell, itemObj)
    local param = UISettingLanguageCell.Param.New()
    param.index = index
    param.name = SuportedLanguagesName[tempType]
    param.isSelect = self.selectIndex == index
    param.callBack = function(tempIndex) self:CellCallBack(tempIndex) end
    param.languageIndex = tempType
    cellItem:ReInit(param)
    self.cells[index] = cellItem
end


local function OnCellMoveOut(self,itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UISettingLanguageCell)
end

local function ClearScroll(self)
    self.cells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UISettingLanguageCell)--清循环列表gameObject
end

local function GetShowList(self)
    local list = {}
    for k,v in ipairs(SuportedLanguages) do
        if v == Language.ChineseSimplified then
            if LuaEntry.Player:GetGMFlag() > 0 or CS.CommonUtils.IsDebug() then
                table.insert(list,v)
            end
        else
            table.insert(list,v)
        end
        if v == self.initLanguage then
            self.selectIndex = k
        end
    end
    return list
end

local function OnConfirmBtnClick(self)
    local temp = self.list[self.selectIndex]
    if temp == self.initLanguage then
        self.ctrl:CloseSelf()
    else
        UIUtil.ShowMessage(Localization:GetString("280075", Localization:GetString(SuportedLanguagesLocalName[temp])), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            Localization:SetLanguage(temp)
            CS.ApplicationLaunch.Instance:ReStartGame()
        end)
    end
end

local function CellCallBack(self,index)
    if self.selectIndex ~= index then
        self:SetCellsSelect(self.selectIndex,false)
         self:SetCellsSelect(index,true)
        self.selectIndex = index
    end
end

local function SetCellsSelect(self,index,value)
    local temp = self.cells[index]
    if temp ~= nil then
        temp:SetSelect(value)
    end
end


UISettingLanguageView.OnCreate= OnCreate
UISettingLanguageView.OnDestroy = OnDestroy
UISettingLanguageView.OnEnable = OnEnable
UISettingLanguageView.OnDisable = OnDisable
UISettingLanguageView.OnAddListener = OnAddListener
UISettingLanguageView.OnRemoveListener = OnRemoveListener
UISettingLanguageView.ComponentDefine = ComponentDefine
UISettingLanguageView.ComponentDestroy = ComponentDestroy
UISettingLanguageView.DataDefine = DataDefine
UISettingLanguageView.DataDestroy = DataDestroy
UISettingLanguageView.ReInit = ReInit
UISettingLanguageView.SetAllCellsDestroy = SetAllCellsDestroy
UISettingLanguageView.ShowCells = ShowCells
UISettingLanguageView.OnCellMoveIn = OnCellMoveIn
UISettingLanguageView.OnCellMoveOut = OnCellMoveOut
UISettingLanguageView.ClearScroll = ClearScroll
UISettingLanguageView.GetShowList = GetShowList
UISettingLanguageView.OnConfirmBtnClick = OnConfirmBtnClick
UISettingLanguageView.CellCallBack = CellCallBack
UISettingLanguageView.SetCellsSelect = SetCellsSelect

return UISettingLanguageView