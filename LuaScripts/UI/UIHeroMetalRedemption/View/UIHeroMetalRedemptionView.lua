--- Created by shimin
--- DateTime: 2023/7/20 11:10
--- 英雄兑换勋章/海报/商店界面

local UIHeroMetalRedemptionView = BaseClass("UIHeroMetalRedemptionView", UIBaseView)
local base = UIBaseView

local UIHeroMetalRedemptionTab = require "UI.UIHeroMetalRedemption.Component.UIHeroMetalRedemptionTab"
local UIHeroMetalRedemptionMetal = require "UI.UIHeroMetalRedemption.Component.UIHeroMetalRedemptionMetal"
local UIHeroMetalRedemptionShop = require "UI.UIHeroMetalRedemption.Component.UIHeroMetalRedemptionShop"

local back_btn_path = "Root/BtnBack"
local title_txt_path = "Root/BtnBack/TitleText"
local tab_path = "Root/TopTab/UIHeroMetalRedemptionTab"
local info_btn_path = "Root/BtnInfo"
local item_icon_path = "Root/UIMainTopResourceCell/root/resourceIcon"
local item_num_text_path = "Root/UIMainTopResourceCell/root/resourceNum"
local metal_go_path = "Root/Right/go1"
local shop_go_path = "Root/Right/go3"

local TabName =
{
    GameDialogDefine.HERO_PAGE_REDEMPTION, GameDialogDefine.METAL_REDEMPTION, GameDialogDefine.SHOP
}

function UIHeroMetalRedemptionView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroMetalRedemptionView:ComponentDefine()
    self.back_btn = self:AddComponent(UIButton, back_btn_path)
    self.back_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    
    self._title_txt = self:AddComponent(UIText, title_txt_path)
    self.info_btn = self:AddComponent(UIButton, info_btn_path)
    self.info_btn:SetOnClick(function()
        self:OnInfoBtnClick()
    end)
    self.tab = {}
    for i = 1, table.count(UIHeroMetalRedemptionTabType), 1 do
        local tab = self:AddComponent(UIHeroMetalRedemptionTab, tab_path .. i)
        table.insert(self.tab, tab)
    end
    self.script = {}
    local metalScript = self:AddComponent(UIHeroMetalRedemptionMetal, metal_go_path)
    self.script[UIHeroMetalRedemptionTabType.HeroPage] = metalScript
    self.script[UIHeroMetalRedemptionTabType.Metal] = metalScript
    self.script[UIHeroMetalRedemptionTabType.Shop] = self:AddComponent(UIHeroMetalRedemptionShop, shop_go_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.item_num_text = self:AddComponent(UIText, item_num_text_path)
end

function UIHeroMetalRedemptionView:ComponentDestroy()
end

function UIHeroMetalRedemptionView:DataDefine()
    self.param = {}
    self.list = {}
    self.tabType = UIHeroMetalRedemptionTabType.HeroPage
    self.flyCallback = function(startPos, num)  
        self:FlyIcon(startPos, num)
    end
    self.flyEndCallback = function()
        self:FlyEndCallback()
    end
    self.canRefreshItem = true
end

function UIHeroMetalRedemptionView:DataDestroy()
    self.param = {}
    self.list = {}
    self.tabType = UIHeroMetalRedemptionTabType.HeroPage
    self.canRefreshItem = true
end

function UIHeroMetalRedemptionView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroMetalRedemptionView:OnEnable()
    base.OnEnable(self)
end

function UIHeroMetalRedemptionView:OnDisable()
    base.OnDisable(self)
end

function UIHeroMetalRedemptionView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.PosterExchangeSuccess, self.PosterExchangeSuccessSignal)
    self:AddUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
end

function UIHeroMetalRedemptionView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.PosterExchangeSuccess, self.PosterExchangeSuccessSignal)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
end

function UIHeroMetalRedemptionView:ReInit()
    self.param = self:GetUserData()
    self._title_txt:SetLocalText(GameDialogDefine.HERO_PLUGIN_SHOP_NAME)
    self.info_btn:SetActive(false)
    self.tabType = self.param.enterTab or UIHeroMetalRedemptionTabType.HeroPage
    for k, v in ipairs(self.tab) do
        local param = {}
        if TabName[k] == nil then
            param.visible = false
        else
            param.visible = true
            param.tab = k
            param.select = self.tabType == k
            param.nameDialog = TabName[k]
        end
        v:ReInit(param)
    end
    self.canRefreshItem = true

    local itemId = DataCenter.HeroMedalRedemptionManager:GetRedemptionItemId()
    if itemId ~= 0 then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        if goods ~= nil then
            local iconName = string.format(LoadPath.ItemPath, goods.icon)
            self.item_icon:LoadSprite(iconName)
        end
    end
   
    for k, v in pairs(self.script) do
        if k == UIHeroMetalRedemptionTabType.HeroPage or k == UIHeroMetalRedemptionTabType.Metal then
            if k == UIHeroMetalRedemptionTabType.HeroPage then
                --只初始化一次
                local param = {}
                param.select = self.tabType == UIHeroMetalRedemptionTabType.HeroPage or self.tabType == UIHeroMetalRedemptionTabType.Metal
                param.tabType = self.tabType
                param.itemId = itemId
                param.flyCallback = self.flyCallback
                v:ReInit(param)
            end
        else
            local param = {}
            param.select = self.tabType == k
            param.itemId = itemId
            v:ReInit(param)
        end
    end
    self:Refresh()
    self:RefreshItemCount()
end

function UIHeroMetalRedemptionView:Refresh()
end

function UIHeroMetalRedemptionView:OnInfoBtnClick()
end

function UIHeroMetalRedemptionView:SetSelect(tabType)
    if self.tabType ~= tabType then
        self:RefreshCellSelect(self.tabType, false)
        self.tabType = tabType
        self:RefreshCellSelect(self.tabType, true)
        self:Refresh()
    end
end

function UIHeroMetalRedemptionView:RefreshCellSelect(tabType, isSelect)
    if self.tab[tabType] ~= nil then
        self.tab[tabType]:Select(isSelect)
    end
    if self.script[tabType] ~= nil then
        self.script[tabType]:Select(tabType, isSelect)
    end
end

function UIHeroMetalRedemptionView:PosterExchangeSuccessSignal()
    if self.script[self.tabType] ~= nil then
        self.script[self.tabType]:Refresh()
    end
end

function UIHeroMetalRedemptionView:RefreshItemsSignal()
    if self.canRefreshItem then
        self:RefreshItemCount()
    end
end

function UIHeroMetalRedemptionView:RefreshItemCount()
    local itemId = DataCenter.HeroMedalRedemptionManager:GetRedemptionItemId()
    if itemId ~= 0 then
        local ownCount = DataCenter.ItemData:GetItemCount(itemId)
        self.item_num_text:SetText(string.GetFormattedSeperatorNum(ownCount))
    end
end

--显示飞资源
function UIHeroMetalRedemptionView:FlyIcon(startPos, num)
    self.canRefreshItem = false
    local rewardType = RewardType.GOODS
    local itemId = DataCenter.HeroMedalRedemptionManager:GetRedemptionItemId()
    local pic = DataCenter.RewardManager:GetPicByType(rewardType, itemId)
    local endPos = self.item_icon.transform.position
    local showNum = num > ShowGreenMaxNum and ShowGreenMaxNum or num
    UIUtil.DoFly(rewardType, showNum, pic, startPos, endPos, nil, nil, self.flyEndCallback)
end

function UIHeroMetalRedemptionView:FlyEndCallback()
    self.canRefreshItem = true
    self:RefreshItemCount()
end



return UIHeroMetalRedemptionView