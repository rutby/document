local AllianceFlagItem = BaseClass("AllianceFlagItem", UIBaseContainer)
local base = UIBaseContainer
local DefaultAllianceFlagIcon = "1;1;1;1"

local flagBg_path = "mask/flagBg"
local flagFg_path = "flagFg"

-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
	self.flagBgN = self:AddComponent(UIImage, flagBg_path)
	self.flagFgN = self:AddComponent(UIImage, flagFg_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.flagBgN = nil
	self.flagFgN = nil
end

--变量的定义
local function DataDefine(self)
	self.icon = nil
end

--变量的销毁
local function DataDestroy(self)
	self.flagIcon = nil
end

local function SetData(self, icon)
	self.flagIcon = icon
	if string.IsNullOrEmpty(self.flagIcon) then
		self.flagIcon = DefaultAllianceFlagIcon
	end
	local tempTb = string.split(self.flagIcon, ";")
	local iconTb = {
		flagBgIcon = tonumber(tempTb[1]) or 1,
		flagBgColor = tonumber(tempTb[2]) or 1,
		flagFgIcon = tonumber(tempTb[3]) or 1,
		flagFgColor = tonumber(tempTb[4] or 1)
	}
	
	self:RefreshFlag(iconTb)
end

local function RefreshFlag(self, iconTb)
	self.flagBgN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIAllianceFlag/UIalliance_img_flagbg%s", iconTb.flagBgIcon))
	self.flagBgN:SetColor(AllianceFlagBgColor[iconTb.flagBgColor])
	self.flagFgN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIAllianceFlag/UIalliance_img_flagpattern%s_big", iconTb.flagFgIcon))
	self.flagFgN:SetColor(AllianceFlagFgColor[iconTb.flagFgColor])
end

AllianceFlagItem.OnCreate = OnCreate
AllianceFlagItem.OnDestroy = OnDestroy
AllianceFlagItem.RefreshFlag = RefreshFlag
AllianceFlagItem.ComponentDefine = ComponentDefine
AllianceFlagItem.ComponentDestroy = ComponentDestroy
AllianceFlagItem.DataDefine = DataDefine
AllianceFlagItem.DataDestroy = DataDestroy
AllianceFlagItem.SetData = SetData

return AllianceFlagItem