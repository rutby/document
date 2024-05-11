
local UIArmyInfoView = BaseClass("UIArmyInfoView", UIBaseView)
local base = UIBaseView
local ForceContent = require("UI.UIArmyInfo.Component.ForceContent")

local Localization = CS.GameEntry.Localization

local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local title_txt_Path = "UICommonMidPopUpTitle/bg_mid/titleText"
local forceContent_path = "ForceContent"

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

    self.forceContent = self:AddComponent(ForceContent, forceContent_path)
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
end

local function ComponentDestroy(self)
    self.close_btn = nil
    self.return_btn = nil
    self.title_txt = nil
    self.forceContent = nil
end

local function DataDefine(self)

end

local function DataDestroy(self)

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
    self.uid = self:GetUserData()
    self.title_txt:SetLocalText(310141) 
    self.forceContent:ReInit()
end

UIArmyInfoView.OnCreate = OnCreate
UIArmyInfoView.OnDestroy = OnDestroy
UIArmyInfoView.OnEnable = OnEnable
UIArmyInfoView.OnDisable = OnDisable
UIArmyInfoView.ComponentDefine = ComponentDefine
UIArmyInfoView.ComponentDestroy = ComponentDestroy
UIArmyInfoView.DataDefine = DataDefine
UIArmyInfoView.DataDestroy = DataDestroy
UIArmyInfoView.OnAddListener = OnAddListener
UIArmyInfoView.OnRemoveListener = OnRemoveListener
UIArmyInfoView.ReInit = ReInit

return UIArmyInfoView