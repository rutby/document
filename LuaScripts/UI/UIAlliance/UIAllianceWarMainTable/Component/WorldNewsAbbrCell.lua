---
--- 火星情报界面
--- Created by shimin
--- DateTime:2023/2/28 11:51
---
local WorldNewsAbbrCell = BaseClass("WorldNewsAbbrCell",UIBaseContainer)
local base = UIBaseContainer

local this_path = ""

function WorldNewsAbbrCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function WorldNewsAbbrCell:ComponentDefine()
    self.abbr_text = self:AddComponent(UIText, this_path)
end

function WorldNewsAbbrCell:ComponentDestroy()

end

function WorldNewsAbbrCell:DataDefine()
    self.param = {}
end

function WorldNewsAbbrCell:DataDestroy()
    self.param = {}
end

function WorldNewsAbbrCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function WorldNewsAbbrCell:OnEnable()
    base.OnEnable(self)
end

function WorldNewsAbbrCell:OnDisable()
    base.OnDisable(self)
end

function WorldNewsAbbrCell:ReInit(param)
    self.param = param
    self:Refresh()
end


function WorldNewsAbbrCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self.abbr_text:SetText(self.param.abbrText)
    else
        self:SetActive(false)
    end
end

return WorldNewsAbbrCell