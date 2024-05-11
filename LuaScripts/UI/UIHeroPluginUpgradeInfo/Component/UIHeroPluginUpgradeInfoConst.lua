--- Created by shimin
--- DateTime: 2023/6/9 11:00
--- 英雄插件属性详情界面cell

local UIHeroPluginUpgradeInfoConst = BaseClass("UIHeroPluginUpgradeInfoConst", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local this_path = ""
local plugin_title_text_path = "Top/Text_0 (1)"
local plugin_des_text_path = "Text_uityhei20"
local attribute_text1_path = "AttributeBG/Text_uityheix20"
local attribute_text2_path = "AttributeBG/Text_uityheix20 (1)"
local attribute_text3_path = "AttributeBG/Text_uityheix20 (2)"

local AttributeDesList = {GameDialogDefine.HERO_PLUGIN_ATTRIBUTE_DES_1, GameDialogDefine.HERO_PLUGIN_ATTRIBUTE_DES_2,
                          GameDialogDefine.HERO_PLUGIN_ATTRIBUTE_DES_3, GameDialogDefine.HERO_PLUGIN_ATTRIBUTE_DES_4,
                          GameDialogDefine.HERO_PLUGIN_ATTRIBUTE_DES_5}

function UIHeroPluginUpgradeInfoConst:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginUpgradeInfoConst:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradeInfoConst:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradeInfoConst:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradeInfoConst:ComponentDefine()
    self.plugin_title_text = self:AddComponent(UIText, plugin_title_text_path)
    self.plugin_des_text = self:AddComponent(UIText, plugin_des_text_path)
    self.attribute_text1 = self:AddComponent(UIText, attribute_text1_path)
    self.attribute_text2 = self:AddComponent(UIText, attribute_text2_path)
    self.attribute_text3 = self:AddComponent(UIText, attribute_text3_path)
    self.content = self:AddComponent(UIBaseContainer, this_path)
end

function UIHeroPluginUpgradeInfoConst:ComponentDestroy()
end

function UIHeroPluginUpgradeInfoConst:DataDefine()
end

function UIHeroPluginUpgradeInfoConst:DataDestroy()
end

function UIHeroPluginUpgradeInfoConst:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUpgradeInfoConst:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUpgradeInfoConst:ReInit()
    self.plugin_title_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_ATTRIBUTE)
    local desStr = ""
    for k, v in ipairs(AttributeDesList) do
        if desStr == "" then
            desStr = Localization:GetString(v)
        else
            desStr = desStr .. "\n" .. Localization:GetString(v)
        end 
    end
    self.plugin_des_text:SetText(desStr)
    self.attribute_text1:SetLocalText(GameDialogDefine.HERO_PLUGIN_ATTRIBUTE)
    self.attribute_text2:SetLocalText(GameDialogDefine.HERO_PLUGIN_ATTRIBUTE_SHOW_LEVEL)
    self.attribute_text3:SetLocalText(GameDialogDefine.HERO_PLUGIN_ATTRIBUTE_ACTIVE_RANGE)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.transform)
end

return UIHeroPluginUpgradeInfoConst