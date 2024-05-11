--- Created by shimin
--- DateTime: 2023/7/17 15:31
--- 英雄插件详情界面品质cell

local UIHeroPluginQualityCell = BaseClass("UIHeroPluginQualityCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local icon_img_path = "icon_img"
local lock_go_path = "lock_img"

function UIHeroPluginQualityCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroPluginQualityCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginQualityCell:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginQualityCell:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginQualityCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.lock_go = self:AddComponent(UIBaseContainer, lock_go_path)
end

function UIHeroPluginQualityCell:ComponentDestroy()
end

function UIHeroPluginQualityCell:DataDefine()
    self.param = {}
end

function UIHeroPluginQualityCell:DataDestroy()
    self.param = {}
end

function UIHeroPluginQualityCell:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginQualityCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginQualityCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIHeroPluginQualityCell:Refresh()
    if self.param.data ~= nil and self.param.data.qualityParam ~= nil then
        self.icon_img:LoadSprite(DataCenter.HeroPluginManager:GetQualityIconName(self.param.data.qualityParam.level))
        if self.param.data.level >= self.param.data.qualityParam.level then
            --解锁
            self.lock_go:SetActive(false)
        else
            self.lock_go:SetActive(true)
        end
    end
end

function UIHeroPluginQualityCell:OnBtnClick()
    local param = {}
    param.qualityParam = self.param.data.qualityParam
    param.level = self.param.data.level
    param.pos = self.transform.position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginQualityTip, { anim = true, playEffect = false }, param)
end

return UIHeroPluginQualityCell