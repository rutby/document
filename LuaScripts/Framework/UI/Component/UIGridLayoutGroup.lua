local UIGridLayoutGroup = BaseClass("UIGridLayoutGroup", UIBaseContainer)
local base = UIBaseContainer
local UnityGridLayoutGroup = typeof(CS.UnityEngine.UI.GridLayoutGroup)

local function OnCreate(self, ...)
	base.OnCreate(self)
	self.unity_gridLayoutGroup = self.gameObject:GetComponent(UnityGridLayoutGroup)
end

local function OnDestroy(self)
	self.unity_gridLayoutGroup = nil
	base.OnDestroy(self)
end

local function GetPadding(self) 
	return self.unity_gridLayoutGroup.padding
end

local function GetSpacing(self)
	return self.unity_gridLayoutGroup.spacing
end

local function SetSpacing(self,value)
	self.unity_gridLayoutGroup.spacing = value
end

local function SetPaddingLeft(self,value)
	self.unity_gridLayoutGroup.padding.left = value
end

local function SetPaddingRight(self,value)
	self.unity_gridLayoutGroup.padding.right = value
end

local function SetPaddingTop(self,value)
	self.unity_gridLayoutGroup.padding.top = value
end

local function SetPaddingBottom(self,value)
	self.unity_gridLayoutGroup.padding.bottom = value
end

local function GetCellSize(self)
	return self.unity_gridLayoutGroup.cellSize
end

local function SetCellSize(self,value)
	self.unity_gridLayoutGroup.cellSize = value
end



UIGridLayoutGroup.OnCreate = OnCreate
UIGridLayoutGroup.OnDestroy = OnDestroy
UIGridLayoutGroup.GetPadding = GetPadding
UIGridLayoutGroup.GetSpacing = GetSpacing
UIGridLayoutGroup.SetSpacing = SetSpacing
UIGridLayoutGroup.SetPaddingLeft = SetPaddingLeft
UIGridLayoutGroup.SetPaddingRight = SetPaddingRight
UIGridLayoutGroup.SetPaddingTop = SetPaddingTop
UIGridLayoutGroup.SetPaddingBottom = SetPaddingBottom
UIGridLayoutGroup.GetCellSize = GetCellSize
UIGridLayoutGroup.SetCellSize = SetCellSize


return UIGridLayoutGroup