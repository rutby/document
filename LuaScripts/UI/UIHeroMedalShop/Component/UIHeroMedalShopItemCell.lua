-- 英雄勋章商店购买物品cell
-- 节点上一层：UIHeroMedalShopItem

local UIHeroMedalShopItemCell = BaseClass("UIHeroMedalShopItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local hero_img_path = "HeroImg"
local buy_button_path = "BuyButton"
local name_label_path = "NameLabel"
local hero_quality_bg1_path = "heroQualityBg1" --橙色
local hero_quality_bg2_path = "heroQualityBg2"  --紫色以及其他色
local button_img_path = "BuyButton/ButtonLayoutNode/ItemImg"
local button_label_path = "BuyButton/ButtonLayoutNode/BuyButtonLabel"
local hero_gray_cover_path = "heroGrayCover"
local hero_quality_bg1_2_path = "heroQualityBg1_2"
local hero_quality_bg2_2_path = "heroQualityBg2_2"
local click_hero_btn_path = "ClickHeroBtn"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self.hero_img = nil;
    self.buy_button = nil;
    self.button_label = nil;
    self.endTimeStamp = nil;
    self.name_label = nil;
    self.costType = nil
    self.costId = nil
    self.currency_num = nil
    self.cycle_times = nil
    self.hero = nil
    self.medalShopId = nil
    self.itemId = nil
    self.hero_quality_bg1 = nil
    self.hero_quality_bg2 = nil
    self.hero_gray_cover = nil
    self.hero_quality_bg1_2 = nil
    self.hero_quality_bg2_2 = nil
    self.click_hero_btn = nil

    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.hero_img = self:AddComponent(UIImage, hero_img_path)
    self.button_img = self:AddComponent(UIImage, button_img_path)
    self.buy_button = self:AddComponent(UIButton, buy_button_path)
    self.name_label = self:AddComponent(UITextMeshProUGUIEx, name_label_path)
    self.hero_quality_bg1 = self:AddComponent(UIBaseContainer, hero_quality_bg1_path)
    self.hero_quality_bg2 = self:AddComponent(UIBaseContainer, hero_quality_bg2_path)
    self.hero_quality_bg1_2 = self:AddComponent(UIImage, hero_quality_bg1_2_path)
    self.hero_quality_bg2_2 = self:AddComponent(UIImage, hero_quality_bg2_2_path)

    self.buy_button:SetOnClick(function ()
        -- 检查时间戳是否能够领奖
        self:OnBuyButtonClick()
    end)
    self.button_label = self:AddComponent(UITextMeshProUGUIEx, button_label_path);
    self.hero_gray_cover = self:AddComponent(UIBaseContainer, hero_gray_cover_path)
    self.click_hero_btn = self:AddComponent(UIButton, click_hero_btn_path)
    self.click_hero_btn:SetOnClick(function()
        self:OnHeroViewBtnClick()
    end)
end

local function SetData(self, data, endTimeStamp, medalShopId)
    --[[
        "buyTimes": 0,
        "currency_num": 3000,
        "goods_num": 1,
        "currency": "2;222021",
        "hero": "1006",
        "id": 110010,
        "cycle_times": 0,
        "order": 10
    ]]
    self.endTimeStamp = endTimeStamp
    -- 当前所属商店组的id
    self.medalShopId = medalShopId
    local splitTab = string.split(data.currency, ";")

    -- costType=1时表示消耗资源，costId为资源类型。 2表示消耗道具，costId为道具id
    self.costType = tonumber(splitTab[1])
    self.costId = tonumber(splitTab[2])
    -- 购买消耗数量
    self.currency_num = data.currency_num
    -- 商品可购买次数上限 0表示无上限
    self.cycle_times = data.cycle_times
    -- 已购买次数
    self.buyTimes = data.buyTimes

    if self.buyTimes ~= nil and self.cycle_times ~= nil and self.buyTimes >= self.cycle_times and self.cycle_times ~= 0 then
        --已达到购买上限
        self.button_img:SetActive(false)
        self.button_label:SetLocalText(320268)
        self.hero_gray_cover:SetActive(true)
    else
        self.button_label:SetText(string.GetFormattedSeperatorNum(self.currency_num))
        self.button_img:SetActive(true)
        self.hero_gray_cover:SetActive(false)
    end
    -- 英雄的Id
    self.hero = data.hero
    -- 兑换商店配置id
    self.itemId = data.id;
    
    self.name_label:SetText(HeroUtils.GetHeroNameByConfigId(self.hero))
    local rarity = GetTableData(HeroUtils.GetHeroXmlName(), self.hero, "rarity")
    --[[
        2紫色
        1橙色
        如果有其他的你先用默认紫色
    ]]
    if rarity then
        if rarity == 1 then
            self.hero_quality_bg1:SetActive(true)
            self.hero_quality_bg1_2:SetActive(true)
            self.hero_quality_bg2:SetActive(false)
            self.hero_quality_bg2_2:SetActive(false)
        else
            self.hero_quality_bg1:SetActive(false)
            self.hero_quality_bg1_2:SetActive(false)
            self.hero_quality_bg2:SetActive(true)
            self.hero_quality_bg2_2:SetActive(true)
        end
    end

    self.hero_img:LoadSprite(HeroUtils.GetHeroIconPath(self.hero, true))

    if self.costType == 1 then
        -- 消耗资源
        local resType = RewardToResType[self.costId]
        if resType ~= nil then
            self.button_img:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resType))
        end
    else
        -- 消耗道具
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.costId)
        if goods ~= nil then
            self.button_img:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
        end
    end
end

local function OnBuyButtonClick(self)
    -- 判断是否在购买时间
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime > self.endTimeStamp then
        -- 如果已经过期就不让购买 一般来说已经过期就会把cell刷掉 不太可能进这里
        return
    end

    -- 判断是否到达购买上限
    if self.cycle_times > 0 then
        if self.buyTimes >= self.cycle_times then
            -- 已达到购买上限
            return
        end
    end

    -- 判断消耗的资源是否足够
    if self.costType == 1 then
        -- 消耗资源
        -- local resType = RewardToResType[self.costId]
        -- if resType ~= nil then
        --     self.button_img:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resType))
        -- end
        -- 暂无消耗资源的途径
        return;
    else
        -- 消耗道具
        local haveNum = DataCenter.ItemData:GetItemCount(self.costId)
        if self.currency_num > haveNum then
            -- 道具不足
            UIUtil.ShowTipsId(120021)

            local lackTab = {}
            local param = {}
            param.type = ResLackType.Item
            param.id = tonumber(self.costId)
            param.targetNum = self.currency_num
            table.insert(lackTab, param)
            GoToResLack.GoToItemResLackList(lackTab)

            return
        end
    end

    -- local resType = RewardToResType[self.goodsConf.currencyType]
    -- if resType and DataCenter.ResourceManager:GetResourceIconByType(resType) then
    --     self.consumeIconN:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(RewardToResType[self.goodsConf.currencyType]))
    -- else
    --     local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.goodsConf.currencyId)
    --     self.consumeIconN:LoadSprite(string.format(LoadPath.ItemPath, goods.icon))
    -- end

    local param = {}
    param["medalShopId"] = self.medalShopId
    param["id"] = self.itemId
    param["num"] = 1

    -- 英雄纪念章
    local useItemNum = tostring(self.currency_num)
    local itemName = Localization:GetString("320813")
    local heroName = HeroUtils.GetHeroNameByConfigId(self.hero)
    local fulldes = Localization:GetString("170391", useItemNum, itemName, heroName)

    UIUtil.ShowSecondMessage(Localization:GetString("100378"), fulldes, 2, "", "", function()
        DataCenter.HeroMedalShopDataManager:OnBuyHeroDedalShopItem(param)
    end, nil)
end

-- 预览英雄
local function OnHeroViewBtnClick(self)
    local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), tonumber(self.hero))
    local param = UIHeroTipsView.Param.New()
    param.heroId = self.hero
    param.title = Localization:GetString(heroConfig.name)
    param.content = Localization:GetString(heroConfig.brief_desc)
    param.dir = UIHeroTipsView.Direction.ABOVE
    param.defWidth = 300
    param.pivot = 0.5
    param.position = self.transform.position + Vector3.New(0, 75, 0)
    param.bindObject = self.gameObject
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

UIHeroMedalShopItemCell.OnCreate = OnCreate
UIHeroMedalShopItemCell.OnDestroy = OnDestroy
UIHeroMedalShopItemCell.ComponentDefine = ComponentDefine
UIHeroMedalShopItemCell.SetData = SetData
UIHeroMedalShopItemCell.OnBuyButtonClick = OnBuyButtonClick
UIHeroMedalShopItemCell.OnHeroViewBtnClick = OnHeroViewBtnClick


return UIHeroMedalShopItemCell