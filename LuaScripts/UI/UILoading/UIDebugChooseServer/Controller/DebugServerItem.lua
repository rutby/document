---------------------------------------------------------------------
-- aps (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-07-29 17:03:09
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class DebugServerItem
local DebugServerItem = BaseClass("DebugServerItem",UIBaseContainer)
local base = UIBaseContainer
local txt = "Text"
local function OnCreate(self,param)
	base.OnCreate(self)
	self.Text = self:AddComponent(UITextMeshProUGUIEx, txt)
	self.Text:SetText(param.Data.name);
	self.Toggle = self:AddComponent(UIToggle, "")
	self.Toggle.isOn =param.isOn
	self.param=param
	self.Toggle:SetOnValueChanged(function ()
	      self.param.ChooseServer(param)
	end)
end

local function OnEnable(self)

	base.OnEnable(self)
end
local function OnDisable(self)
	base.OnDisable(self)
	
end
local function OnDestroy(self)
	base.OnDestroy(self)
	self.Text=nil
	self.Toggle=nil
	self.param=nil
end

DebugServerItem.OnCreate= OnCreate
DebugServerItem.OnDestroy = OnDestroy
DebugServerItem.OnEnable = OnEnable
DebugServerItem.OnDisable = OnDisable
return DebugServerItem