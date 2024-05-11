---------------------------------------------------------------------
-- aps (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-08-13 12:10:11
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class UIHeadIconShow
local UIHeadIconShowView =BaseClass("UIHeadIconShowView", UIBaseView)
local base = UIBaseView
local _cp_btnBg = "safearea/butBg"
local _cp_img="safearea/headIcon"
local function OnCreate(self)
	base.OnCreate(self)
	self.head_img=self:AddComponent(UIPlayerHead, _cp_img)
	self._btnBg = self:AddComponent(UIButton, _cp_btnBg)
	self.uid = self:GetUserData()
    self:OnUpdateHeadPic()
	self._btnBg:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self.ctrl:CloseSelf()
	end)
end

local function OnDestroy(self)
	base.OnDestroy(self)
	self.head_img=nil
	self._btnBg=nil
	self.uid=nil

end
local function OnUpdateHeadPic(self)
	local uid = self.uid
	local userinfo = ChatInterface.getUserData(uid, true)
	if userinfo~=nil then
		local userPic = userinfo["headPic"] or ""
		local userPicVer = userinfo["headPicVer"] or 0
		self.head_img:SetData(uid, userPic, userPicVer, true)
	end
end
local function OnAddListener(self)
	base.OnAddListener(self)
	self:AddUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUpdateHeadPic)
end
local function OnRemoveListener(self)
	base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.UPDATE_MSG_USERINFO, self.OnUpdateHeadPic)
end
UIHeadIconShowView.OnUpdateHeadPic=OnUpdateHeadPic
UIHeadIconShowView.OnAddListener=OnAddListener
UIHeadIconShowView.OnRemoveListener=OnRemoveListener
UIHeadIconShowView.OnCreate = OnCreate
UIHeadIconShowView.OnDestroy = OnDestroy
return UIHeadIconShowView