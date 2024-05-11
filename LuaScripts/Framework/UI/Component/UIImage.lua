--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIImage
--]]

local UIImage = BaseClass("UIImage", UIBaseComponent)
local base = UIBaseComponent
local UnityImage = typeof(CS.UnityEngine.UI.Image)

-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self.unity_image = self.gameObject:GetComponent(UnityImage)
end

local function LoadSprite(self, sprite_path, default_sprite, callback)
	if self.spritePath == sprite_path then
		if callback ~= nil then
			callback()
		end
		return
	end
	self.spritePath = sprite_path
	if CommonUtil.GetIsUseLoadAsync() == true then
		self.unity_image:LoadSprite(sprite_path, default_sprite, callback)
	else
		self.unity_image:LoadSprite(sprite_path, default_sprite)
		if callback ~= nil then
			callback()
		end
	end

end

--加载头像
local function LoadHeadEx(self, uid, pic, picVer, default_sprite, callback)
	self.unity_image:LoadHeadEx(uid, pic, picVer, default_sprite, callback)
end

-- 销毁
local function OnDestroy(self)
	self.unity_image = nil
	base.OnDestroy(self)
end

local function SetFillAmount(self,value)
	self.unity_image.fillAmount = value
end

local function GetFillAmount(self)
	return self.unity_image.fillAmount
end

local function SetMaterial(self,value)
	self.unity_image.material = value
end

local function GetMaterial(self)
	return self.unity_image.material
end

local function GetImage(self)
	return self.unity_image.sprite
end

local function SetImage(self,value)
	self.unity_image.sprite = value
end

local function SetColor(self,value)
	--self.unity_image.color = value
	self.unity_image:Set_color(value.r, value.g, value.b, value.a)
end

local function SetColorRGBA(self,r,g,b,a)
	--self.unity_image.color = value
	self.unity_image:Set_color(r, g, b, a)
end

local function GetColorRGBA(self)
	return self.unity_image:Get_color()
end

local function GetColor(self)
	local r,g,b,a = self:GetColorRGBA()
	return Color.New(r,g,b,a)
end

local function SetAlpha(self,value)
	local color = self:GetColor()
	self:SetColorRGBA(color.r,color.g,color.b,value)
end

local function SetNativeSize(self)
	self.unity_image:SetNativeSize()
end

local function SetEnable(self,enable)
	self.unity_image.enabled = enable
end

local function SetRaycastTarget(self,raycastTarget)
	self.unity_image.raycastTarget = raycastTarget
end

UIImage.OnCreate = OnCreate
UIImage.LoadSprite = LoadSprite
UIImage.OnDestroy = OnDestroy
UIImage.SetFillAmount = SetFillAmount
UIImage.GetFillAmount = GetFillAmount
UIImage.SetMaterial = SetMaterial
UIImage.GetMaterial = GetMaterial
UIImage.GetImage = GetImage
UIImage.SetImage = SetImage
UIImage.LoadHeadEx = LoadHeadEx
UIImage.SetColor = SetColor
UIImage.SetColorRGBA = SetColorRGBA
UIImage.GetColorRGBA = GetColorRGBA
UIImage.GetColor = GetColor
UIImage.SetAlpha = SetAlpha
UIImage.SetNativeSize = SetNativeSize
UIImage.SetEnable = SetEnable
UIImage.SetRaycastTarget = SetRaycastTarget
return UIImage