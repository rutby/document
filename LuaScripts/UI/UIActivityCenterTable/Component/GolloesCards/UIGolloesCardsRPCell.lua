---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/28 16:48
---

local UIGolloesCardsRPCell = BaseClass("UIGolloesCardsRPCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local UIGray = CS.UIGray
-- 创建
function UIGolloesCardsRPCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

-- 销毁
function UIGolloesCardsRPCell:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

--控件的定义
function UIGolloesCardsRPCell:ComponentDefine()
    
    self.obj = self:AddComponent(UIBaseContainer,"")
    self.icon = self:AddComponent(UIImage, "UICommonItem/clickBtn/ItemIcon")
    self.icon_bg = self:AddComponent(UIImage, "UICommonItem/clickBtn/ImgQuality")
    self.btn = self:AddComponent(UIButton, "UICommonItem/clickBtn")
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRewardClick()
    end)
    self.flag_text = self:AddComponent(UITextMeshProUGUIEx, "UICommonItem/clickBtn/FlagGo/FlagText")
    self.flag_go = self:AddComponent(UIBaseContainer, "UICommonItem/clickBtn/FlagGo")
    self.count = self:AddComponent(UITextMeshProUGUIEx,"UICommonItem/clickBtn/NumText")
end

--控件的销毁
function UIGolloesCardsRPCell:ComponentDestroy()
    self.icon = nil
    self.icon_bg = nil
    self.btn = nil
    self.flag_text = nil
    self.flag_go = nil
end

function UIGolloesCardsRPCell:SetData(param)
    self.param = param
    self:SetFlagActive(false)
    self.count:SetText(param.count)
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
    if goods ~= nil then
        self.icon:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
        self.icon_bg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
        local flagtxt = ""
        if goods.type == 2 then
            if goods.para1 ~= nil and goods.para1 ~= "" then
                local para1 = goods.para1
                local temp = string.split(para1,';')
                if temp ~= nil and #temp > 1 then
                    flagtxt = temp[1]..temp[2]
                end
            end
        elseif goods.type == 3 or goods.type == GOODS_TYPE.GOODS_TYPE_91 then
            local type2 = goods.type2
            if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                local res_num = tonumber(goods.para)
                flagtxt = string.GetFormattedStr(res_num)
            end
        elseif goods.type == 5 then
            if goods.para3 ~= nil and goods.para3 ~= "" then
                local res_num = tonumber(goods.para3)
                flagtxt = string.GetFormattedStr(res_num)
            end
        end
        self.flag_go:SetActive(flagtxt ~= "")
        self.flag_text:SetText(flagtxt)
    else
        local resourceType = tonumber(param.itemId)
        if resourceType < 100 then
            if  DataCenter.ResourceManager:GetResourceIconByType(resourceType) then
                self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
                self.icon_bg:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
            end
        end
    end
    
end

function UIGolloesCardsRPCell:SetFlagActive(value)
    self.flag_go:SetActive(value)
end

function UIGolloesCardsRPCell:SetFlagText(value)
    self.flag_text:SetText(value)
end

function UIGolloesCardsRPCell:OnRewardClick()
    if self.param.itemId ~= nil then
        local param = {}
        param["itemId"] = self.param.itemId
        param["alignObject"] = self.icon
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    end
end

return UIGolloesCardsRPCell