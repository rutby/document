--- Created by shimin
--- DateTime: 2023/6/5 18:36
--- 英雄插件升级界面Tab

local UIHeroPluginUpgradeTab = BaseClass("UIHeroPluginUpgradeTab", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local icon_img_path = "Icon"
local select_text_path = "selectName"

local SelectIconName =
{
    [HeroPluginTabType.Upgrade] = "Common_btn_cj_up",
    [HeroPluginTabType.Refine] = "Common_btn_cj_change",
}

local UnselectIconName =
{
    [HeroPluginTabType.Upgrade] = "Common_btn_cj_up_unckecked",
    [HeroPluginTabType.Refine] = "Common_btn_cj_change_unckecked",
}

local SelectNameParam =
{
    Color = MoveTabColorSelect,
    LocalPosition = Vector3.New(14.5, -30, 0)
}

local UnSelectNameParam =
{
    Color = MoveTabColorUnSelect,
    LocalPosition = Vector3.New(16.5, -25, 0)
}

function UIHeroPluginUpgradeTab:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginUpgradeTab:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradeTab:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradeTab:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradeTab:ComponentDefine()
    self.select_btn = self:AddComponent(UIButton, this_path)
    self.select_btn:SetOnClick(function()
        self:OnSelectBtnClick()
    end)
    self.icon = self:AddComponent(UIImage, icon_img_path)
    self.tab_icon = self:AddComponent(UIImage, this_path)
    self.select_text = self:AddComponent(UIText, select_text_path)
end

function UIHeroPluginUpgradeTab:ComponentDestroy()

end

function UIHeroPluginUpgradeTab:DataDefine()
    self.param = {}
end

function UIHeroPluginUpgradeTab:DataDestroy()
    self.param = {}
end

function UIHeroPluginUpgradeTab:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUpgradeTab:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUpgradeTab:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginUpgradeTab:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self:Select(self.param.select)
        if self.param.tabType == HeroPluginTabType.Upgrade then
            self.select_text:SetLocalText(GameDialogDefine.UPGRADE)
        elseif self.param.tabType == HeroPluginTabType.Refine then
            self.select_text:SetLocalText(GameDialogDefine.REFINE)
        end
    else
        self:SetActive(false)
    end
end

function UIHeroPluginUpgradeTab:OnSelectBtnClick()
    if not self.param.select then
        self.view:SetSelect(self.param.tabType)
    end
end

function UIHeroPluginUpgradeTab:Select(select)
    self.param.select = select
    if select then
        self.tab_icon:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_tab_up"))
        self.icon:LoadSprite(string.format(LoadPath.HeroAdvancePath, SelectIconName[self.param.tabType]))
        self.select_text:SetColor(SelectNameParam.Color)
        self.select_text:SetLocalPosition(SelectNameParam.LocalPosition)
    else
        self.tab_icon:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_tab_down"))
        self.icon:LoadSprite(string.format(LoadPath.HeroAdvancePath, UnselectIconName[self.param.tabType]))
        self.select_text:SetColor(UnSelectNameParam.Color)
        self.select_text:SetLocalPosition(UnSelectNameParam.LocalPosition)
    end
end

return UIHeroPluginUpgradeTab