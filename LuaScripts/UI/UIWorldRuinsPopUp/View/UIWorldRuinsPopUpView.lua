---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/12/10 16:59
---
local UIWorldRuinsPopUpView= BaseClass("UIWorldRuinsPopUpView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local return_btn_path = "UICommonPanel"
local click_txt_path = "offset/clicktxt"
local des_txt_path ="offset/Goal"
local function OnCreate(self)
    base.OnCreate(self)
    self.str = self:GetUserData()
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.click_txt = self:AddComponent(UITextMeshProUGUIEx, click_txt_path)
    self.click_txt:SetText(Localization:GetString("321366"))
    self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_path)
   
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
end

local function OnDestroy(self)
    self.return_btn = nil
    self.enter_btn = nil
    self.cancel_btn = nil
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
    self.des_txt:SetText(self.str)
end


UIWorldRuinsPopUpView.OnCreate = OnCreate
UIWorldRuinsPopUpView.OnDestroy = OnDestroy
UIWorldRuinsPopUpView.OnEnable = OnEnable
UIWorldRuinsPopUpView.OnDisable = OnDisable
UIWorldRuinsPopUpView.RefreshData =RefreshData
return UIWorldRuinsPopUpView