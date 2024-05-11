--- Created by shimin
--- DateTime: 2023/6/9 11:00
--- 英雄插件属性详情界面cell

local UIHeroPluginUpgradeInfoCell = BaseClass("UIHeroPluginUpgradeInfoCell", UIBaseContainer)
local base = UIBaseContainer

local show_text_path = "show_text"
local show_special_text_path = "show_special_text"
local show_lv_text_path = "Text_lv"
local active_text_path = "Text_uityhei20"
local rhombus_img_path = "rhombus_go/rhombus_img"

function UIHeroPluginUpgradeInfoCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginUpgradeInfoCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradeInfoCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradeInfoCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradeInfoCell:ComponentDefine()
    self.show_text = self:AddComponent(UIText, show_text_path)
    self.show_lv_text = self:AddComponent(UIText, show_lv_text_path)
    self.active_text = self:AddComponent(UIText, active_text_path)
    self.show_special_text = self:AddComponent(UIText, show_special_text_path)
    self.rhombus_img = self:AddComponent(UIImage, rhombus_img_path)
end

function UIHeroPluginUpgradeInfoCell:ComponentDestroy()
end

function UIHeroPluginUpgradeInfoCell:DataDefine()
    self.param = {}
end

function UIHeroPluginUpgradeInfoCell:DataDestroy()
    self.param = {}
end

function UIHeroPluginUpgradeInfoCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUpgradeInfoCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUpgradeInfoCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginUpgradeInfoCell:Refresh()
    if self.param.isSpecial then
        self.show_text:SetActive(false)
        self.show_special_text:SetActive(true)
        self.show_special_text:SetText(self.param.showName)
    else
        self.show_text:SetActive(true)
        self.show_text:SetText(self.param.showName)
        self.show_special_text:SetActive(false)
    end
    self.rhombus_img:LoadSprite(DataCenter.HeroPluginManager:GetRhombusNameByQuality(self.param.quality), nil, function()
        self.rhombus_img:SetNativeSize()
    end)
    
    self.show_text:SetText(self.param.showName)
    self.show_lv_text:SetText(tostring(self.param.showLv))
    if self.param.activeType == HeroPluginActiveType.Army then
        self.active_text:SetLocalText(GameDialogDefine.ACTIVE_MARCH)
    elseif self.param.activeType == HeroPluginActiveType.Self then
        self.active_text:SetLocalText(GameDialogDefine.ACTIVE_HERO_SELF)
    end
end

return UIHeroPluginUpgradeInfoCell