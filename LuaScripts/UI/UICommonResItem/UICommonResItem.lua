---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by admin.
--- DateTime: 2024/3/29 11:03
---

local UICommonResItem = BaseClass("UICommonResItem", UIBaseContainer)
local base = UIBaseContainer

local res_img_path = "ResIcon"
local res_text_path = "ResNum"

function UICommonResItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UICommonResItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICommonResItem:ComponentDefine()
    self.icon = self:AddComponent(UIImage, res_img_path)
    self.num = self:AddComponent(UITextMeshProUGUIEx, res_text_path)
end

function UICommonResItem:ComponentDestroy()

end

function UICommonResItem:DataDefine()

end

function UICommonResItem:DataDestroy()

end

function UICommonResItem:OnEnable()
    base.OnEnable(self)
end

function UICommonResItem:OnDisable()
    base.OnDisable(self)
end

function UICommonResItem:OnAddListener()
    base.OnAddListener(self)
end

function UICommonResItem:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UICommonResItem:SetData(param)
    local resType = param['resType']
    local itemId = param['itemId']
    if resType ~= nil then
        self:SetRes(param.resType, param.num)
    elseif itemId ~= nil then
        self:SetItem(param.itemId, param.num)
    end
end

function UICommonResItem:SetItem(id, num)
    local img = DataCenter.ItemTemplateManager:GetIconPath(id)
    self.icon:LoadSprite(img)
    local itemNum = DataCenter.ItemData:GetItemCount(id)
    local hasStr = string.GetFormattedStr(itemNum)
    local needStr = string.GetFormattedStr(num)
    if itemNum < num then
        self.num:SetText(string.format("<color=%s>%s</color>/%s", TextColorRed, hasStr, needStr))
    else
        self.num:SetText(string.format("%s/%s", hasStr, needStr))
    end
end

function UICommonResItem:SetRes(resType, num)
    local img = DataCenter.ResourceManager:GetResourceIconByType(resType)
    self.icon:LoadSprite(img)
    local resNum = LuaEntry.Resource:GetCntByResType(resType)
    local hasStr = string.GetFormattedStr(resNum)
    local needStr = string.GetFormattedStr(num)
    if resNum < num then
        self.num:SetText(string.format("<color=%s>%s</color>/%s", TextColorRed, hasStr, needStr))
    else
        self.num:SetText(string.format("%s/%s", hasStr, needStr))
    end
end

return UICommonResItem