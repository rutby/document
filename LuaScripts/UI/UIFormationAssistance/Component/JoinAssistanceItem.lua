---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/29 12:00
---
local JoinAssistanceItem = BaseClass("JoinAssistanceItem",UIBaseContainer)
local base = UIBaseContainer

-- local join_obj ="join"
local name_path = "joinButton/joinTxt"
local join_btn_path = "joinButton"
local state_txt_path = "stateTxt"

local function OnCreate(self)
    base.OnCreate(self)
    self.name = self:AddComponent(UITextMeshProUGUIEx,name_path)
    self.name:SetLocalText(GameDialogDefine.CLICK_TO_JOIN)
    self.join_btn = self:AddComponent(UIButton, join_btn_path)
    self.join_btn:SetOnClick(function ()
        self:OnJoinClick()
    end)
    self.alreadyHave = false
end

local function OnDestroy(self)
    -- self.join_obj =nil
    self.name = nil
    self.join_btn = nil
    base.OnDestroy(self)
end

local function SetState(self, canJoin, alreadyHave, isUnLock)
    if isUnLock then
        self.join_btn:SetActive(true)
        if canJoin then
            self.name:SetLocalText(GameDialogDefine.CLICK_TO_JOIN)
            CS.UIGray.SetGray(self.join_btn.transform, false, true)
        else
            self.name:SetLocalText(GameDialogDefine.QUEUE_FULL)
            CS.UIGray.SetGray(self.join_btn.transform, true, true)
        end
    else
        self.join_btn:SetActive(false)
    end
    self.alreadyHave = alreadyHave
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnJoinClick(self)
    if self.alreadyHave == false then
        self.view:OnJoinClick()
    else
        UIUtil.ShowTipsId(121219)
    end
end

JoinAssistanceItem.OnCreate = OnCreate
JoinAssistanceItem.OnDestroy = OnDestroy
JoinAssistanceItem.OnEnable = OnEnable
JoinAssistanceItem.OnDisable = OnDisable
JoinAssistanceItem.SetState = SetState
JoinAssistanceItem.OnJoinClick = OnJoinClick
return JoinAssistanceItem