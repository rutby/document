---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/3/20 21:45
---
local ThroneWarJoinItem = BaseClass("ThroneWarJoinItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local join_obj ="join"
local name_path = "join/nameTxt"
local join_btn_path = "joinButton"
local state_txt_path = "stateTxt"
local function OnCreate(self)
    base.OnCreate(self)
    self.join_obj = self:AddComponent(UIBaseContainer,join_obj)
    self.name = self:AddComponent(UITextMeshProUGUIEx,name_path)
    self.name:SetLocalText(250163)
    self.state = self:AddComponent(UITextMeshProUGUIEx,state_txt_path)
    --self.state:SetLocalText(GameDialogDefine.QUEUE_FULL)
    self.state:SetText("")
    self.join_btn = self:AddComponent(UIButton, join_btn_path)
    self.join_btn:SetOnClick(function ()
        self:OnJoinClick()
    end)
end

local function OnDestroy(self)
    self.join_obj =nil
    self.name = nil
    self.state = nil
    self.join_btn = nil
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnJoinClick(self)
    self.view:OnJoinClick()
end
ThroneWarJoinItem.OnCreate = OnCreate
ThroneWarJoinItem.OnDestroy = OnDestroy
ThroneWarJoinItem.OnEnable = OnEnable
ThroneWarJoinItem.OnDisable = OnDisable
ThroneWarJoinItem.OnJoinClick = OnJoinClick
return ThroneWarJoinItem