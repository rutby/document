--[[
-- added by wsh @ 2017-12-08
-- Lua侧UIButton
-- 注意：
-- 1、按钮一般会带有其他的组件，如带一个UIText、或者一个UIImange标识说明按钮功能，所以这里是一个容器类
-- 2、UIButton组件必须挂载在根节点，其下某个子节点有个Unity侧原生Button即可，如果有多个，需要指派相对路径
-- 使用方式：
-- self.xxx_btn = self:AddComponent(UIButton, var_arg)--添加孩子，各种重载方式查看UIBaseContainer
--]]

local UIButton = BaseClass("UIButton", UIBaseContainer)
local base = UIBaseContainer
local UnityButton = typeof(CS.UnityEngine.UI.Button)
local UnityImage = typeof(CS.UnityEngine.UI.Image)
local ButtonRef = {}

function UIButton.AddRef(btn)
	local ref = (ButtonRef[btn] or 0) + 1
	ButtonRef[btn] = ref
	return ref
end

function UIButton.DecRef(btn)
	local ref = (ButtonRef[btn] or 0) - 1
	if ref <= 0 then
		ref = 0
		ButtonRef[btn] = nil
	else
		ButtonRef[btn] = ref
	end
	return ref
end

-- 创建
function UIButton:OnCreate(relative_path)
	base.OnCreate(self)
	-- Unity侧原生组件
	self.unity_uibutton = self.gameObject:GetComponent(UnityButton)
	self.unity_image = self.gameObject:GetComponent(UnityImage)

	if self.unity_uibutton then
		local ref = UIButton.AddRef(self.unity_uibutton)
	end

	-- 记录点击回调
	self.__onclick = nil
end

-- 虚拟点击
function UIButton:Click()
	if self.__onclick  ~= nil then
		self.__onclick()
	end
end

-- 设置回调
function UIButton:SetOnClick(action)
	if action then
		if self.__onclick then
			self.unity_uibutton.onClick:RemoveListener(self.__onclick)
		end
		local interAction = function()
			action(self.param)
		end
		self.__onclick = interAction
		self.unity_uibutton.onClick:AddListener(self.__onclick)
	elseif self.__onclick then
		self.unity_uibutton.onClick:RemoveListener(self.__onclick)
		self.__onclick = nil
	end
end

-- 资源释放
function UIButton:OnDestroy()
	if self.__onclick ~= nil and self.unity_uibutton ~= nil then
		self.unity_uibutton.onClick:RemoveListener(self.__onclick)
	end
	if self.unity_uibutton then
		local ref = UIButton.DecRef(self.unity_uibutton)
		if ref <= 0 then
			pcall(function() self.unity_uibutton.onClick:Clear() end)
		end
	end

	self.unity_uibutton = nil
	self.unity_image = nil
	self.spritePath = nil
	self.__onclick = nil
	base.OnDestroy(self)
end

function UIButton:SetInteractable(value)
	self.unity_uibutton.interactable = value
end

function UIButton:SetSprite(spr)
	local btnImage = self.unity_uibutton.transform:GetComponent(typeof(CS.UnityEngine.UI.Image))
	if (btnImage ~= nil) then
		btnImage.sprite = spr
	end
end

function UIButton:SetMaterial(value)
	local btnImage = self.unity_uibutton.transform:GetComponent(typeof(CS.UnityEngine.UI.Image))
	if (btnImage ~= nil) then
		btnImage.material = value
	end
end

function UIButton:LoadSprite(sprite_path, default_sprite, callback)
	if self.spritePath == sprite_path then
		return
	end
	self.spritePath = sprite_path
	if self.unity_image~=nil then
		if CommonUtil.GetIsUseLoadAsync() == true then
			if self.unity_image~=nil then
				self.unity_image:LoadSprite(sprite_path, default_sprite, callback)
			end

		else
			if self.unity_image~=nil then
				self.unity_image:LoadSprite(sprite_path, default_sprite)
				if callback ~= nil then
					callback()
				end
			end
		end
	end
end

function UIButton:SetNativeSize()
	if self.unity_image~=nil then
		self.unity_image:SetNativeSize()
	end
end

function UIButton:SetParam(param)
	self.param = param
end

function UIButton:GetParam()
	return self.param
end

return UIButton