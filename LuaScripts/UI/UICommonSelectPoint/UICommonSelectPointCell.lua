
local UICommonSelectPointCell = BaseClass("UIPveBuffCell", UIBaseContainer)
local base = UIBaseContainer

local select_path = "Select"

function UICommonSelectPointCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UICommonSelectPointCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICommonSelectPointCell:ComponentDefine()
    self.select = self:AddComponent(UIBaseContainer, select_path)
end

function UICommonSelectPointCell:ComponentDestroy()

end

function UICommonSelectPointCell:DataDefine()
    self.param = {}
end

function UICommonSelectPointCell:DataDestroy()
    self.param = {}
end

function UICommonSelectPointCell:OnEnable()
    base.OnEnable(self)
end

function UICommonSelectPointCell:OnDisable()
    base.OnDisable(self)
end

function UICommonSelectPointCell:OnAddListener()
    base.OnAddListener(self)
end

function UICommonSelectPointCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UICommonSelectPointCell:ReInit(param)
    self.param = param
    self:Refresh()
end


function UICommonSelectPointCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self:SetSelect(self.param.select)
    else
        self:SetActive(false)
    end
end

function UICommonSelectPointCell:SetSelect(select)
    self.param.select = select
    self.select:SetActive(select)
end



return UICommonSelectPointCell