--- Created by shimin
--- DateTime: 2023/5/29 21:50
--- 装饰建筑抽奖概率界面cell

local UIHeroPluginTipCell = BaseClass("UIHeroPluginTipCell", UIBaseContainer)
local base = UIBaseContainer

local show_text_path = "Text_uityhei20"
local show_value_path = "Text_lv18"
local line_path = "Line"

function UIHeroPluginTipCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginTipCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginTipCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginTipCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginTipCell:ComponentDefine()
    self.show_text = self:AddComponent(UIText, show_text_path)
    self.show_value = self:AddComponent(UIText, show_value_path)
    self.line = self:AddComponent(UIBaseContainer, line_path)
end

function UIHeroPluginTipCell:ComponentDestroy()
end

function UIHeroPluginTipCell:DataDefine()
    self.param = {}
end

function UIHeroPluginTipCell:DataDestroy()
    self.param = {}
end

function UIHeroPluginTipCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginTipCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginTipCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginTipCell:Refresh()
    if self.param.data ~= nil then
        self.show_text:SetText(self.param.data.showName)
        self.show_value:SetText(self.param.data.showValue)
        self.line:SetActive(self.param.data.showLine)
    end
end

return UIHeroPluginTipCell