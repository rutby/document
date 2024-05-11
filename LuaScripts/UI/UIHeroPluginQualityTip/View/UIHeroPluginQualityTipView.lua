--- Created by shimin
--- DateTime: 2023/7/17 20:38
--- 英雄插件品质详情界面

local UIHeroPluginQualityTipView = BaseClass("UIHeroPluginQualityTipView", UIBaseView)
local base = UIBaseView

local UIHeroPluginQualityTipCell = require "UI.UIHeroPluginQualityTip.Component.UIHeroPluginQualityTipCell"

local title_text_path = "Root/TextTitle"
local panel_btn_path = "Panel"
local des_text_path = "Root/des_text"
local unlock_go_path = "Root/unlock_go"
local need_level_text_path = "Root/unlock_go/need_level_text"
local pos_go_path = "Root"
local scroll_view_path = "Root/ScrollView"
local line_go_path = "Root/LineGo/Line"

local PanelWidth = 481
local BGSizeDelta = Vector2.New(50, 50)

function UIHeroPluginQualityTipView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroPluginQualityTipView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.unlock_go = self:AddComponent(UIBaseContainer, unlock_go_path)
    self.need_level_text = self:AddComponent(UIText, need_level_text_path)
    self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.line_go = self:AddComponent(UIBaseContainer, line_go_path)
end

function UIHeroPluginQualityTipView:ComponentDestroy()
end

function UIHeroPluginQualityTipView:DataDefine()
    self.param = 0
    self.cells = {}
    self.list = {}
    self.pos = Vector3.New(0, 0, 0)
    self.lossyScaleX = self.transform.lossyScale.x
    if self.lossyScaleX <= 0 then
        self.lossyScaleX = 1
    end
    self.lossyScaleY = self.transform.lossyScale.y
    if self.lossyScaleY <= 0 then
        self.lossyScaleY = 1
    end
    self.maxX = Screen.width - PanelWidth / 2 * self.lossyScaleX - BGSizeDelta.x * self.lossyScaleX
end

function UIHeroPluginQualityTipView:DataDestroy()
    self.param = 0
    self.cells = {}
    self.list = {}
end

function UIHeroPluginQualityTipView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroPluginQualityTipView:OnEnable()
    base.OnEnable(self)
end

function UIHeroPluginQualityTipView:OnDisable()
    base.OnDisable(self)
end

function UIHeroPluginQualityTipView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
end

function UIHeroPluginQualityTipView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshHeroPlugin, self.RefreshHeroPluginSignal)
end

function UIHeroPluginQualityTipView:ReInit()
    self.param = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.NEW_ATTRIBUTE)
    self:Refresh()
    self:RefreshPosition()
end

function UIHeroPluginQualityTipView:Refresh()
    if self.param.qualityParam ~= nil then
        if self.param.qualityParam.desc == nil then
            self.des_text:SetActive(false)
            self.line_go:SetActive(false)
            if self.param.level >= self.param.qualityParam.level then
                self.unlock_go:SetActive(false)
            else
                self.unlock_go:SetActive(true)
                self.need_level_text:SetLocalText(GameDialogDefine.NEED_HERO_PLUGIN_LEVEL_WITH, self.param.qualityParam.level)
            end
        else
            self.des_text:SetActive(true)
            self.des_text:SetLocalText(self.param.qualityParam.desc,
                    DataCenter.HeroPluginManager:GetQualityColorNameByLevel(self.param.qualityParam.level))
            if self.param.level >= self.param.qualityParam.level then
                self.unlock_go:SetActive(false)
                self.line_go:SetActive(true)
            else
                self.line_go:SetActive(false)
                self.unlock_go:SetActive(true)
                self.need_level_text:SetLocalText(GameDialogDefine.NEED_HERO_PLUGIN_LEVEL_WITH, self.param.qualityParam.level)
            end
        end
    end
    self:ShowCells()
end

function UIHeroPluginQualityTipView:RefreshHeroPluginSignal()
    self:Refresh()
end

function UIHeroPluginQualityTipView:RefreshPosition()
    if self.param.pos ~= nil then
        if self.param.pos.x > self.maxX then
            self.pos.x = self.maxX
        else
            self.pos.x = self.param.pos.x
        end
        self.pos.y = self.param.pos.y + BGSizeDelta.y * self.lossyScaleY
        self.pos_go:SetPosition(self.pos)
    end
end

function UIHeroPluginQualityTipView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIHeroPluginQualityTipView:ClearScroll()
    self.cells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIHeroPluginQualityTipCell)--清循环列表gameObject
end

function UIHeroPluginQualityTipView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIHeroPluginQualityTipCell, itemObj)
    item:ReInit(self.list[index])
    self.cells[index] = item
end

function UIHeroPluginQualityTipView:OnCellMoveOut(itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIHeroPluginQualityTipCell)
end

function UIHeroPluginQualityTipView:GetDataList()
    self.list = {}
    if self.param.qualityParam ~= nil then
        local list = self.param.qualityParam.list
        if list ~= nil then
            for k, v in ipairs(list) do
                local template = DataCenter.RandomPlugTemplateManager:GetTemplate(v)
                if template ~= nil then
                    local param = {}
                    param.showName = template:GetDescRange()
                    param.isSpecial = template:IsSpecialShow()
                    param.quality = template.rarity
                    param.showLine = false
                    table.insert(self.list, param)
                end
            end
        end
    end
end


return UIHeroPluginQualityTipView