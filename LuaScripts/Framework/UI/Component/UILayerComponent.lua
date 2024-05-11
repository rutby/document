--[[
-- added by wsh @ 2017-12-08
-- Lua侧UILayer
--]]

local UILayerComponent = BaseClass("UILayerComponent", UIBaseComponent)
local base = UIBaseComponent
local RectTransform = typeof(CS.UnityEngine.RectTransform)
local LayerMask = CS.UnityEngine.LayerMask

local function OnCreate(self, cfg)
	base.OnCreate(self)
	self.__name = self.__var_arg
	self.cfg = cfg

	self.gameObject.layer = LayerMask.NameToLayer("UI");
	local tfx = self.gameObject:GetComponent_RectTransform();
	--tfx.localScale = Vector3.one;
	--tfx.offsetMin = Vector3.zero;
	--tfx.offsetMax = Vector3.zero;
	--tfx.anchorMin = Vector2.zero;
	--tfx.anchorMax = Vector2.one;
	tfx:Set_localScale(1, 1, 1)
	tfx:Set_offsetMin(0, 0)
	tfx:Set_offsetMax(0, 0)
	tfx:Set_anchorMin(0, 0)
	tfx:Set_anchorMax(1, 1)
end

function UILayerComponent:GetConfig()
	return self.cfg
end

function UILayerComponent:GetOrderInLayer()
	return self.cfg and self.cfg.OrderInLayer or 0
end

local function GetActiveInHierarchy(self)
	return self.activeSelf
end

UILayerComponent.OnCreate = OnCreate
UILayerComponent.GetActiveInHierarchy = GetActiveInHierarchy

return UILayerComponent