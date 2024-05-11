--- Created by shimin
--- DateTime: 2024/1/11 12:00
--- Vip界面cell
---
local UIVipCell = BaseClass("UIVipCell", UIBaseContainer)
local base = UIBaseContainer

local new_go_path = "new_go"
local des_text_path = "des_text"
local value_text_path = "value_text"

function UIVipCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIVipCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIVipCell:ComponentDefine()
    self.new_go = self:AddComponent(UIBaseContainer, new_go_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.value_text = self:AddComponent(UITextMeshProUGUIEx, value_text_path)
end

function UIVipCell:ComponentDestroy()
end

function UIVipCell:DataDefine()
    self.param = {}
end

function UIVipCell:DataDestroy()
    self.param = {}
end

function UIVipCell:OnEnable()
    base.OnEnable(self)
end

function UIVipCell:OnDisable()
    base.OnDisable(self)
end

function UIVipCell:OnAddListener()
    base.OnAddListener(self)
end

function UIVipCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIVipCell:ReInit(param)
    self.param = param
    self.des_text:SetLocalText(self.param.descID)
    self.value_text:SetText(DataCenter.VIPTemplateManager:GetFormatAffectValue(self.param))
    self.new_go:SetActive(self.param.isNew)
end

return UIVipCell