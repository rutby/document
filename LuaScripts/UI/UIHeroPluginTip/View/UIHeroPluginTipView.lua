--- Created by shimin
--- DateTime: 2023/6/2 14:58
--- 英雄界面点击插件按钮弹出界面

local UIHeroPluginTipView = BaseClass("UIHeroPluginTipView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local UIHeroPluginTipCell = require "UI.UIHeroPluginTip.Component.UIHeroPluginTipCell"

local title_text_path = "Root/TextTitle"
local panel_btn_path = "Panel"
local unlock_content_path = "Root/Content"
local lock_content_path = "Root/Content2"
local lock_des_text_path = "Root/Content2/Text_0"
local upgrade_btn_path = "Root/BtnExchange"
local upgrade_btn_text_path = "Root/BtnExchange/TextBtnExchange"

local State =
{
    Lock = 1,--锁住
    Upgrade = 2,--升级
    Refine = 3,--随机
}

function UIHeroPluginTipView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroPluginTipView:ComponentDefine()
    self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
    self.upgrade_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUpgradeBtnClick()
    end)
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.unlock_content = self:AddComponent(UIBaseContainer, unlock_content_path)
    self.upgrade_btn_text = self:AddComponent(UIText, upgrade_btn_text_path)
    self.lock_content = self:AddComponent(UIBaseContainer, lock_content_path)
    self.lock_des_text = self:AddComponent(UIText, lock_des_text_path)
end

function UIHeroPluginTipView:ComponentDestroy()
end

function UIHeroPluginTipView:DataDefine()
    self.uuid = 0
    self.desList = {}
    self.state = State.Lock
    self.desCells = {}
end

function UIHeroPluginTipView:DataDestroy()
    self.uuid = 0
    self.desList = {}
    self.state = State.Lock
    self.desCells = {}
end

function UIHeroPluginTipView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginTipView:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginTipView:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginTipView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
end

function UIHeroPluginTipView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
end

function UIHeroPluginTipView:ReInit()
    self.uuid = self:GetUserData()
    self:Refresh()
end

function UIHeroPluginTipView:Refresh()
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.uuid)
    if heroData ~= nil then
        local campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
        if DataCenter.HeroPluginManager:IsUnlock(campType, self.uuid) then
            self.unlock_content:SetActive(true)
            self.lock_content:SetActive(false)
            if heroData.plugin ~= nil then
                local maxLevel = DataCenter.HeroPluginManager:GetCurMaxLevel(campType)
                if maxLevel <= heroData.plugin.lv then
                    self.state = State.Refine
                    self.upgrade_btn_text:SetLocalText(GameDialogDefine.REFINE)
                else
                    self.state = State.Upgrade
                    self.upgrade_btn_text:SetLocalText(GameDialogDefine.UPGRADE)
                end
                self.title_text:SetText(Localization:GetString(GameDialogDefine.HERO_PLUGIN_TITLE) .. " " .. Localization:GetString(GameDialogDefine.LEVEL_NUMBER, heroData.plugin.lv))
            else
                self.state = State.Upgrade
                self.title_text:SetText(Localization:GetString(GameDialogDefine.HERO_PLUGIN_TITLE) .. " " .. Localization:GetString(GameDialogDefine.LEVEL_NUMBER, 0))
                self.upgrade_btn_text:SetLocalText(GameDialogDefine.UPGRADE)
            end
            self:ShowDesCells()
        else
            self.state = State.Lock
            self.unlock_content:SetActive(false)
            self.lock_content:SetActive(true)
            self.title_text:SetText(Localization:GetString(GameDialogDefine.HERO_PLUGIN_TITLE) .. "(" .. Localization:GetString(GameDialogDefine.LOCK) ..")")
            self.upgrade_btn_text:SetLocalText(GameDialogDefine.GOTO)
            self.lock_des_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_LOCK_DES)
        end
    end
end

function UIHeroPluginTipView:ShowDesCells()
    self:InitDesList()
    local count = #self.desList
    for k, v in ipairs(self.desList) do
        if self.desCells[k] == nil then
            local param = {}
            self.desCells[k] = param
            param.visible = true
            param.data = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIHeroPluginTipCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.unlock_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.unlock_content:AddComponent(UIHeroPluginTipCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.desCells[k].visible = true
            self.desCells[k].data = v
            if self.desCells[k].model ~= nil then
                self.desCells[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.desCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.desCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIHeroPluginTipView:InitDesList()
    self.desList = {}
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.uuid)
    if heroData ~= nil and heroData.plugin ~= nil then
        local list = heroData.plugin.plugin
        if list ~= nil then
            local maxNum = #list
            for k, v in ipairs(list) do
                local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v.id)
                if template ~= nil then
                    local param = {}
                    param.showName = template:GetDesc(v.level)
                    param.showValue = ""
                    param.showLine = k ~= maxNum
                    table.insert(self.desList, param)
                end
            end
        end
    end
end

function UIHeroPluginTipView:OnUpgradeBtnClick()
    if self.state == State.Lock then
        --去解锁科技
        local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.uuid)
        if heroData ~= nil then
            local campType = GetTableData(HeroUtils.GetHeroXmlName(), heroData.heroId, "camp")
            local scienceId = DataCenter.HeroPluginManager:GetUnlockScienceId(campType)
            GoToUtil.GotoScience(scienceId)
        end
    elseif self.state == State.Upgrade then
        --去升级
        local param = {}
        param.uuid = self.uuid
        param.tabType = HeroPluginTabType.Upgrade
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginUpgrade, { anim = true, playEffect = false }, param)
    elseif self.state == State.Refine then
        --去随机
        local param = {}
        param.uuid = self.uuid
        param.tabType = HeroPluginTabType.Refine
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginUpgrade, { anim = true, playEffect = false }, param)
    end
    if self.ctrl ~= nil then
        self.ctrl:CloseSelf()
    end
end

function UIHeroPluginTipView:RefreshHeroPluginSignal()
    self:Refresh()
end

return UIHeroPluginTipView