--- Created by shimin
--- DateTime: 2023/6/7 14:56
--- 英雄插件交换界面选择英雄cell
---
local UIHeroPluginChangeSelectHeroCell = BaseClass("UIHeroPluginChangeSelectHeroCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellSmall"

local hero_path = "UIHeroCellSmall"
local select_obj_path = "selectObj"
local in_march_obj_path = "inMarchObj"
local in_march_des_path = "inMarchObj/inMarchDes"

function UIHeroPluginChangeSelectHeroCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginChangeSelectHeroCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginChangeSelectHeroCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginChangeSelectHeroCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginChangeSelectHeroCell:ComponentDefine()
    self.heroBase = self:AddComponent(UIHeroCell, hero_path)
    self.select_obj = self:AddComponent(UIBaseContainer, select_obj_path)
    self.in_march_obj = self:AddComponent(UIBaseContainer, in_march_obj_path)
    self.in_march_des = self:AddComponent(UIText, in_march_des_path)
end

function UIHeroPluginChangeSelectHeroCell:ComponentDestroy()
end

function UIHeroPluginChangeSelectHeroCell:DataDefine()
    self.param = {}
    self.onSelectClick = function()
        self:OnSelectClick()
    end
end

function UIHeroPluginChangeSelectHeroCell:DataDestroy()
    self.param = {}
end

function UIHeroPluginChangeSelectHeroCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginChangeSelectHeroCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginChangeSelectHeroCell:ReInit(param)
    self.param = param
    self.in_march_des:SetLocalText(GameDialogDefine.IN_MARCH)
    self:Refresh()
end

function UIHeroPluginChangeSelectHeroCell:Refresh()
    self.heroBase:SetData(self.param.uuid, self.onSelectClick, nil, true)
    self.in_march_obj:SetActive(self.param.isInMarch)
    self:RefreshSelect()
end

function UIHeroPluginChangeSelectHeroCell:Select(select)
    self.param.select = select
    self:RefreshSelect()
end

function UIHeroPluginChangeSelectHeroCell:RefreshSelect()
    if self.param.select then
        self.select_obj:SetActive(true)
    else
        self.select_obj:SetActive(false)
    end
end

function UIHeroPluginChangeSelectHeroCell:OnSelectClick()
    if self.param.isInMarch == false then
        if DataCenter.HeroPluginManager:IsUnlock(self.param.camp, self.param.uuid) then
            self.view:OnSelectClick(self.param.index)
        else
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.uuid)
            if heroData ~= nil then
                UIUtil.ShowTips(Localization:GetString(GameDialogDefine.NEW_HUMAN_NO_CHANGE_PLUGIN_TIP,  Localization:GetString(HeroUtils.GetHeroNameByConfigId(heroData.heroId))))
            end
        end
    end
end

return UIHeroPluginChangeSelectHeroCell