---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/13 17:10

--MK: DeleteAll
--[[
local AllianceMemberDetail = BaseClass("AllianceMemberDetail", UIBaseContainer)--UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceMember = require "UI.UIAlliance.UIAllianceMemberDetail.Component.AllianceMember"
local txt_title_path ="ImgBg/TxtTitle"
local close_btn_path = "ImgBg/BtnClose"
local return_btn_path = "Panel"
local alliance_member_path = "ImgBg/AllianceMember"
local function OnCreate(self)
    base.OnCreate(self)
    --local allianceBaseData =  DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    --self.allianceId = allianceBaseData.uid -- self:GetUserData()
    --self.view.ctrl:SetAllianceId(self.allianceId)
    --self.txt_title = self:AddComponent(UIText, txt_title_path)
    --self.txt_title:SetLocalText(390199) -- 联盟成
    self.alliance_member = self:AddComponent(AllianceMember,alliance_member_path)
--    self.close_btn = self:AddComponent(UIButton, close_btn_path)
--    self.close_btn:SetOnClick(function()  
--SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
--        self.view.ctrl:CloseSelf()
--    end)
--    self.return_btn = self:AddComponent(UIButton, return_btn_path)
--    self.return_btn:SetOnClick(function()  
--SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
--        self.view.ctrl:CloseSelf()
--    end)
end

local function OnDestroy(self)
    --self.allianceId = nil
    --self.txt_title = nil
    self.alliance_member = nil
    --self.close_btn = nil
    --self.return_btn = nil
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end


AllianceMemberDetail.OnCreate = OnCreate
AllianceMemberDetail.OnDestroy = OnDestroy
AllianceMemberDetail.OnEnable = OnEnable
AllianceMemberDetail.OnDisable = OnDisable
return AllianceMemberDetail
--]]