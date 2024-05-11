--- Created by shimin
--- DateTime: 2023/6/9 11:00
--- 英雄插件属性详情界面

local UIHeroPluginUpgradeInfoView = BaseClass("UIHeroPluginUpgradeInfoView", UIBaseView)
local base = UIBaseView

local UIHeroPluginUpgradeInfoCell = require "UI.UIHeroPluginUpgradeInfo.Component.UIHeroPluginUpgradeInfoCell"
local UIHeroPluginUpgradeInfoConst = require "UI.UIHeroPluginUpgradeInfo.Component.UIHeroPluginUpgradeInfoConst"

local panel_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local scroll_view_path = "ImgBg/LoopScroll"
local scroll_view_content_path = "ImgBg/LoopScroll/Viewport/Content"

function UIHeroPluginUpgradeInfoView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroPluginUpgradeInfoView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.scroll_view_content = self:AddComponent(UIBaseContainer, scroll_view_content_path)
    self.scroll_view = self:AddComponent(UILoopListView2, scroll_view_path)
    self.scroll_view:InitListView(0, function(loopView, index)
        return self:OnGetItemByIndex(loopView, index)
    end)
end

function UIHeroPluginUpgradeInfoView:ComponentDestroy()
    self:ClearScroll()
end

function UIHeroPluginUpgradeInfoView:DataDefine()
    self.list = {}
end

function UIHeroPluginUpgradeInfoView:DataDestroy()
    self.list = {}
end

function UIHeroPluginUpgradeInfoView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginUpgradeInfoView:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginUpgradeInfoView:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginUpgradeInfoView:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroPluginUpgradeInfoView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroPluginUpgradeInfoView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_TITLE)
    self:Refresh()
end

function UIHeroPluginUpgradeInfoView:Refresh()
    self:ShowCells()
end

function UIHeroPluginUpgradeInfoView:ShowCells()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetListItemCount(count + 1, false, false)
        self.scroll_view:RefreshAllShownItem()
    end
end

function UIHeroPluginUpgradeInfoView:ClearScroll()
    self.scroll_view_content:RemoveComponents(UIHeroPluginUpgradeInfoConst)
    self.scroll_view_content:RemoveComponents(UIHeroPluginUpgradeInfoCell)
    self.scroll_view:ClearAllItems()
end

function UIHeroPluginUpgradeInfoView:OnGetItemByIndex(loopScroll, index)
    --C#控件索引从0开始 
    if index == 0 then
        local item = loopScroll:NewListViewItem('UIHeroPluginUpgradeInfoConst')
        if item ~= nil then
            local script = self.scroll_view_content:GetComponent(item.gameObject.name, UIHeroPluginUpgradeInfoConst)
            if script == nil then
                local objectName = self:GetItemNameSequence()
                item.gameObject.name = objectName
                if (not item.IsInitHandlerCalled) then
                    item.IsInitHandlerCalled = true
                end
                script = self.scroll_view_content:AddComponent(UIHeroPluginUpgradeInfoConst, objectName)
            end
            script:SetActive(true)
            script:ReInit()
            return item
        end
    elseif self.list[index] ~= nil then
        --数据行
        local item = loopScroll:NewListViewItem('UIHeroPluginUpgradeInfoCell')
        if item ~= nil then
            local script = self.scroll_view_content:GetComponent(item.gameObject.name, UIHeroPluginUpgradeInfoCell)
            if script == nil then
                local objectName = self:GetItemNameSequence()
                item.gameObject.name = objectName
                if (not item.IsInitHandlerCalled) then
                    item.IsInitHandlerCalled = true
                end
                script = self.scroll_view_content:AddComponent(UIHeroPluginUpgradeInfoCell, objectName)
            end
            script:SetActive(true)
            script:ReInit(self.list[index])
            return item
        end
    end
    return nil
end

function UIHeroPluginUpgradeInfoView:GetItemNameSequence()
    NameCount = NameCount + 1
    return tostring(NameCount)
end

function UIHeroPluginUpgradeInfoView:GetDataList()
    self.list = {}
    local list = DataCenter.RandomPlugTemplateManager:GetAllRandomTemplate()
    if list ~= nil then
        for k, v in pairs(list) do
            if v:IsShowInDetail() then
                local param = {}
                param.showName = v:GetDescRange()
                param.showLv = v.unlock_lv
                param.activeType = v.type
                param.id = v.id
                param.quality = v.rarity
                param.isSpecial = v:IsSpecialShow()
                table.insert(self.list, param)
            end
        end
    end
    if self.list[2] ~= nil then
        table.sort(self.list, function(a, b)
            if a.showLv ~= b.showLv then
                return b.showLv < a.showLv
            elseif a.quality ~= b.quality then
                return b.quality < a.quality
            end
            return b.id < a.id
        end)
    end
end

return UIHeroPluginUpgradeInfoView