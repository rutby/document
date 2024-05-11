local UIDropdown = BaseClass("UIDropdown", UIBaseContainer)
local base = UIBaseContainer
local UnityDropdown = typeof(CS.UnityEngine.UI.Dropdown)
local List_String = CS.System.Collections.Generic.List(CS.System.String)

local function OnCreate(self, ...)
	base.OnCreate(self)
	self.unity_dropdown = self.gameObject:GetComponent(UnityDropdown)
end

local function OnDestroy(self)
	if self.__onvaluechanged ~= nil then
		self.unity_dropdown.onValueChanged:RemoveListener(self.__onvaluechanged)
	end
	pcall(function() self.unity_dropdown.onValueChanged:Clear() end)
	pcall(function() self.unity_dropdown.options:Clear() end)
	self.unity_dropdown = nil
	self.__onvaluechanged = nil
	base.OnDestroy(self)
end

local function SetText(self,value)
	self.unity_dropdown.captionText.text = value
end

local function GetText(self)
	return self.unity_dropdown.captionText.text
end

local function Clear(self)
	self.unity_dropdown.options:Clear()
end

local function Add(self,value)
	self.unity_dropdown.options:Add(value)
end

local function AddList(self,value)
	if value ~= nil and value[1] ~= nil then
		local list3 = List_String()
		for k, v in ipairs(value) do
			list3:Add(v)
		end
		self.unity_dropdown:AddOptions(list3)
	end
end

local function SetOnValueChanged(self, action)
	if action then
		if self.__onvaluechanged then
			self.unity_dropdown.onValueChanged:RemoveListener(self.__onvaluechanged)
		end
		self.__onvaluechanged = action
		self.unity_dropdown.onValueChanged:AddListener(self.__onvaluechanged)
	elseif self.__onvaluechanged then
		self.unity_dropdown.onValueChanged:RemoveListener(self.__onvaluechanged)
		self.__onvaluechanged = nil
	end
end

local function SetValue(self,value)
	self.unity_dropdown.value = value
end

local function GetValue(self)
	return self.unity_dropdown.value
end

UIDropdown.OnCreate = OnCreate
UIDropdown.OnDestroy = OnDestroy
UIDropdown.SetText = SetText
UIDropdown.GetText = GetText
UIDropdown.Clear = Clear
UIDropdown.Add = Add
UIDropdown.SetOnValueChanged = SetOnValueChanged
UIDropdown.SetValue = SetValue
UIDropdown.GetValue = GetValue
UIDropdown.AddList = AddList

return UIDropdown