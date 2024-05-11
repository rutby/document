local UINeedResCell = BaseClass("UINeedResCell", UIBaseContainer)
local base = UIBaseContainer

local img_path = "img"
local desc_path = "introTxt"

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

-- 显示
local function OnEnable(self)
	base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
	base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
	self.imgN = self:AddComponent(UIImage, img_path)
	self.descN = self:AddComponent(UIText, desc_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.imgN = nil
	self.descN = nil
end

--变量的定义
local function DataDefine(self)
	
end

--变量的销毁
local function DataDestroy(self)
	
end

local function SetData(self, intro)
	self.imgN:LoadSprite(intro.imgPath)
	self.descN:SetLocalText(intro.desc)
end

UINeedResCell.OnCreate = OnCreate
UINeedResCell.OnDestroy = OnDestroy
UINeedResCell.OnEnable = OnEnable
UINeedResCell.OnDisable = OnDisable
UINeedResCell.ComponentDefine = ComponentDefine
UINeedResCell.ComponentDestroy = ComponentDestroy
UINeedResCell.DataDefine = DataDefine
UINeedResCell.DataDestroy = DataDestroy
UINeedResCell.SetData = SetData

return UINeedResCell