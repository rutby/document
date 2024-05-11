--- Created by shimin.
--- DateTime: 2021/7/29 3:59
--- 迁城界面

local UICityManageView = BaseClass("UICityManageView", UIBaseView)
local base = UIBaseView
local WarFeverContent = require("UI.UICityManage.Component.WarFeverContent")
local WarGuardContent = require("UI.UICityManage.Component.WarGuardContent")

local Localization = CS.GameEntry.Localization

local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local title_txt_Path = "UICommonMidPopUpTitle/bg_mid/titleText"
local warFever_content_path = "WarFeverContent"
local warGuard_content_path = "WarGuardContent"


--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_Path)
    self.warFever_content = self:AddComponent(WarFeverContent,warFever_content_path)
    self.warGuard_content = self:AddComponent(WarGuardContent,warGuard_content_path)
    
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseAll()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
end

local function ComponentDestroy(self)
    self.close_btn = nil
    self.return_btn = nil
    self.title_txt = nil
    self.itemList =nil
    self.cells = nil
    self.scroll_view = nil
end


local function DataDefine(self)
    self.directToTab = self:GetUserData()
end

local function DataDestroy(self)
    self.directToTab = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
end


local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UseItemSuccess, self.UseItemSuccessHandle)
    base.OnRemoveListener(self)
end



local function ReInit(self)
    self.curParam = self:GetUserData()
    self.title_txt:SetLocalText(129024)
    self:SwitchContent(self.curParam)
end


local function SwitchContent(self,param)
    self.warFever_content.gameObject:SetActive(false)
    self.warGuard_content.gameObject:SetActive(false)
    if param.id == CityManageBuffType.CityFever  then -- 战争狂热
        self.warFever_content.gameObject:SetActive(true)
        self.warFever_content:ReInit()
    else
        self.warGuard_content.gameObject:SetActive(true)
        self.warGuard_content:ReInit(param)
    end
end

local function UseItemSuccessHandle(self)
    if self.curParam and self.curParam.id == CityManageBuffType.WarGuard then
        self.warGuard_content:ItemUseRefresh(self.curParam)
    end
end

UICityManageView.OnCreate = OnCreate
UICityManageView.OnDestroy = OnDestroy
UICityManageView.OnEnable = OnEnable
UICityManageView.OnDisable = OnDisable
UICityManageView.ComponentDefine = ComponentDefine
UICityManageView.ComponentDestroy = ComponentDestroy
UICityManageView.DataDefine = DataDefine
UICityManageView.DataDestroy = DataDestroy
UICityManageView.OnAddListener = OnAddListener
UICityManageView.OnRemoveListener = OnRemoveListener
UICityManageView.ReInit = ReInit
UICityManageView.SwitchContent = SwitchContent
UICityManageView.UseItemSuccessHandle = UseItemSuccessHandle
return UICityManageView