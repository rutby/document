---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 
--- DateTime: 
---
local CityCell = BaseClass("CityCell",UIBaseContainer)
local base = UIBaseContainer
function CityCell:OnCreate()
    base.OnCreate(self)
	self.bg = self:AddComponent(UIImage,"")
    self._left_txt = self:AddComponent(UITextMeshProUGUI,"Txt_Left")
    self._right_txt = self:AddComponent(UITextMeshProUGUI,"Txt_Right")
end

function CityCell:OnDestroy()
    base.OnDestroy(self)
end

function CityCell:SetData(param,index)
	self._left_txt:SetLocalText(372908,param.lv)
	self._right_txt:SetLocalText(372909,param.actScore)

	if index % 2 == 0 then
		self.bg:SetAlpha(0)
	else
		self.bg:SetAlpha(1)
	end
end


return CityCell