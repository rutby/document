--- Created by shimin
--- DateTime: 2023/7/19 17:31
--- 英雄插件排行榜点击插件按钮弹出界面

local UIHeroPluginRankInfoView = BaseClass("UIHeroPluginRankInfoView", UIBaseView)
local base = UIBaseView

local UIHeroPluginUpgradePluginIcon = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginUpgradePluginIcon"
local UIHeroPluginQualityTipCell = require "UI.UIHeroPluginQualityTip.Component.UIHeroPluginQualityTipCell"
local UIHeroPluginDesConstCell = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginDesConstCell"

local QualityParam =
{
    [HeroPluginQualityType.White] = "Personnelcar_img_tips_character1",
    [HeroPluginQualityType.Green] = "Personnelcar_img_tips_character2",
    [HeroPluginQualityType.Blue] = "Personnelcar_img_tips_character3",
    [HeroPluginQualityType.Purple] = "Personnelcar_img_tips_character4",
    [HeroPluginQualityType.Orange] = "Personnelcar_img_tips_character5",
    [HeroPluginQualityType.Gold] = "Personnelcar_img_tips_character5",
}

local panel_btn_path = "panel"
local title_bg_path = "BG/TitleBG"
local hero_plugin_path = "BG/UIHeroPluginBtn"
local score_text_path = "BG/StateText"
local name_text_path = "BG/NameText"
local const_go_path = "BG/UIHeroPluginDesLayout/const_go"
local random_go_path = "BG/UIHeroPluginDesLayout/random_go"

function UIHeroPluginRankInfoView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroPluginRankInfoView:ComponentDefine()
    self.title_bg = self:AddComponent(UIImage, title_bg_path)
    self.hero_plugin = self:AddComponent(UIHeroPluginUpgradePluginIcon, hero_plugin_path)
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.score_text = self:AddComponent(UIText, score_text_path)
    self.name_text = self:AddComponent(UIText, name_text_path)
    self.const_go = self:AddComponent(UIBaseContainer, const_go_path)
    self.random_go = self:AddComponent(UIBaseContainer, random_go_path)
end

function UIHeroPluginRankInfoView:ComponentDestroy()
end

function UIHeroPluginRankInfoView:DataDefine()
    self.param = {}
    self.mainDesList = {}
    self.mainDesCells = {}
    self.randomDesList = {}
    self.randomDesCells = {}
end

function UIHeroPluginRankInfoView:DataDestroy()
    self.param = {}
    self.mainDesList = {}
    self.mainDesCells = {}
    self.randomDesList = {}
    self.randomDesCells = {}
end

function UIHeroPluginRankInfoView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginRankInfoView:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginRankInfoView:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginRankInfoView:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginRankInfoView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginRankInfoView:ReInit()
    self.param = self:GetUserData()
    self:Refresh()
end

function UIHeroPluginRankInfoView:Refresh()
    local param = {}
    param.level = self.param.lv
    param.camp = self.param.camp
    self.hero_plugin:ReInit(param)
    self.score_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_SCORE_WITH, string.GetFormattedSeperatorNum(self.param.score))
    self.name_text:SetText(DataCenter.HeroPluginManager:GetQualityNameByLevel(self.param.lv))
    local quality = DataCenter.HeroPluginManager:GetQuality(self.param.lv)
    if QualityParam[quality] ~= nil then
        self.title_bg:LoadSprite(string.format(LoadPath.UIGarageRefit,QualityParam[quality]))
    end
    self:ShowMainDesCells()
    self:ShowRandomDesCells()
end

function UIHeroPluginRankInfoView:ShowMainDesCells()
    self:InitMainDesList()
    local count = #self.mainDesList
    for k, v in ipairs(self.mainDesList) do
        if self.mainDesCells[k] == nil then
            local param = {}
            self.mainDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginRankConstCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.const_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.const_go:AddComponent(UIHeroPluginDesConstCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.mainDesCells[k].visible = true
            self.mainDesCells[k].data = v
            if self.mainDesCells[k].model ~= nil then
                self.mainDesCells[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.mainDesCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.mainDesCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIHeroPluginRankInfoView:InitMainDesList()
    self.mainDesList = {}
    local list = DataCenter.RandomPlugTemplateManager:GetMainTemplateByLevel(self.param.lv)
    if list ~= nil then
        for k, v in ipairs(list) do
            local param = {}
            param.showName = v:GetConstName()
            param.showValue = v:GetConstValue()
            table.insert(self.mainDesList, param)
        end
    end
end

function UIHeroPluginRankInfoView:ShowRandomDesCells()
    self:InitRandomDesList()
    local count = #self.randomDesList
    for k, v in ipairs(self.randomDesList) do
        if self.randomDesCells[k] == nil then
            local param = {}
            self.randomDesCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginRankRandomCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.random_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.random_go:AddComponent(UIHeroPluginQualityTipCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.randomDesCells[k].visible = true
            self.randomDesCells[k].data = v
            if self.randomDesCells[k].model ~= nil then
                self.randomDesCells[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.randomDesCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.randomDesCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIHeroPluginRankInfoView:InitRandomDesList()
    self.randomDesList = {}
    local list = self.param.plugin
    if list ~= nil then
        local maxNum = #list
        for k, v in ipairs(list) do
            local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
            if template ~= nil then
                local param = {}
                param.showName = template:GetDesc(v.level)
                param.isSpecial = template:IsSpecialShow()
                param.quality = template.rarity
                param.showLine = k ~= maxNum
                param.isMax = template:IsMax(v.level)
                table.insert(self.randomDesList, param)
            end
        end
    end
end

return UIHeroPluginRankInfoView