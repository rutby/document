--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIText
-- 使用方式：
-- self.xxx_text = self:AddComponent(UIInput, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
-- TODO：本地化支持
--]]

local UIText = BaseClass("UIText", UIBaseComponent)
local base = UIBaseComponent
local UnityText = typeof(CS.UnityEngine.UI.Text)

-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	-- Unity侧原生组件
	self.unity_text = self.gameObject:GetComponent(UnityText)
end

-- 获取文本
local function GetText(self)
	return self.unity_text.text
end

local function GetUnityText(self)
	return self.unity_text
end

-- 设置文本
local function SetText(self, text)
	self.unity_text.text = text
end

local function SetLocalText(self, dialogId, ...)
	self.unity_text:SetLocalText(dialogId, ...)
end

-- 销毁
local function OnDestroy(self)
	self.unity_text = nil
	base.OnDestroy(self)
end

local function SetColorRGBA(self,r,g,b,a)
	--self.unity_image.color = value
	self.unity_text:Set_color(r, g, b, a)
end

local function SetColor(self,value)
	self.unity_text:Set_color(value.r, value.g, value.b, value.a)
end

local function GetColor(self)
	local r,g,b,a = self:GetColorRGBA()
	return Color.New(r,g,b,a)
end

local function GetColorRGBA(self)
	return self.unity_text:Get_color()
end

local function GetWidth(self) 
	return self.unity_text.preferredWidth
end

local function GetHeight(self)
	return self.unity_text.preferredHeight
end


function UIText:SetAlignment( _alignment ) 
	self.unity_text.alignment = _alignment
end

local function SetPreferSize(self, value)
	self.rectTransform:Set_sizeDelta(value.x, value.y)
end

function UIText:SetFontSize( size )
	self.unity_text.fontSize = size
end


UIText.OnCreate = OnCreate
UIText.GetText = GetText
UIText.GetUnityText = GetUnityText
UIText.SetText = SetText
UIText.OnDestroy = OnDestroy
UIText.SetColor = SetColor
UIText.GetWidth = GetWidth
UIText.GetHeight = GetHeight
UIText.SetPreferSize = SetPreferSize
UIText.GetColor = GetColor
UIText.SetLocalText = SetLocalText
UIText.SetColorRGBA = SetColorRGBA
UIText.GetColorRGBA = GetColorRGBA


return UIText