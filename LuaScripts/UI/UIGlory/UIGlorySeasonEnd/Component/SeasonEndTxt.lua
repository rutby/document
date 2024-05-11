---
--- 
--- Created by 
--- DateTime: 
---
local SeasonEndTxt = BaseClass("SeasonEndTxt", UIBaseContainer)
local base = UIBaseContainer

function SeasonEndTxt:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function SeasonEndTxt:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function SeasonEndTxt:OnEnable()
    base.OnEnable(self)
end

function SeasonEndTxt:OnDisable()
    base.OnDisable(self)
end

function SeasonEndTxt:ComponentDefine()
    self._txt_dialog = self:AddComponent(UIText, "")
end

function SeasonEndTxt:ComponentDestroy()

end

function SeasonEndTxt:DataDefine()
    
end

function SeasonEndTxt:DataDestroy()
    
end

function SeasonEndTxt:ReInit(param)
    if param then
        self._txt_dialog:SetLocalText(param)
    end
end

return SeasonEndTxt