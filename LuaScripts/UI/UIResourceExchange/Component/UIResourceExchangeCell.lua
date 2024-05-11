---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/2/16 18:16
---

local UIResourceExchangeCell = BaseClass("UIResourceExchangeCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local Param = DataClass("Param", ParamData)
local ParamData =  {
    rewardType,
    itemId,
    count,
    --联盟礼物
    iconName,
    itemColor,
    itemName,
    itemDes
}

local item_bg_path = "clickBtn/item_bg"
local hero_quality_path = "clickBtn/HeroQuality"
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local num_text_path = "clickBtn/NumText"
local flag_path = "clickBtn/FlagGo"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local this_path = "clickBtn"
--local name_text_path = "NameText"
local extra_path = "clickBtn/ImgExtra"
local camp_path = "clickBtn/ImgCamp"

-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
    self.item_bg = self:AddComponent(UIImage, item_bg_path)
    self.hero_quality = self:AddComponent(UIImage, hero_quality_path)
    self.item_quality = self:AddComponent(UIImage, item_quality_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
    self.flag_text = self:AddComponent(UITextMeshProUGUIEx, flag_text_path)
    self.btn = self:AddComponent(UIButton, this_path)
    --self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.flag = self:AddComponent(UIBaseContainer, flag_path)

    self.imgExtra = self:AddComponent(UIImage, extra_path)
    self.imgCamp = self:AddComponent(UIImage, camp_path)

    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
end

--控件的销毁
local function ComponentDestroy(self)
    self.item_bg = nil
    self.hero_quality = nil
    self.item_quality = nil
    self.item_icon = nil
    self.num_text = nil
    self.flag_text = nil
    self.btn = nil
    self.flag = nil
    --self.name_text = nil
    self.imgExtra = nil
    self.imgCamp = nil
end

--变量的定义
local function DataDefine(self)
    self.param = {}
    self.flagText = nil
    self.flagActive = nil
    self.itemCount = nil
    self.itemCountActive = nil
    self.nameText = nil
end

--变量的销毁
local function DataDestroy(self)
    self.param = nil
    self.flagText = nil
    self.flagActive = nil
    self.itemCount = nil
    self.itemCountActive = nil
    self.nameText = nil
end

-- 全部刷新
local function ReInit(self,param)
    self.param = param
    
    if self.param.count == nil then
        self:SetItemCountActive(false)
    else
        self:SetItemCountActive(true)
        self:SetItemCount(self.param.count)
    end
    self.imgExtra:SetActive(false)
    self.imgCamp:SetActive(false)

    if self.param.rewardType == nil then

    else
        if self.param.rewardType == RewardType.HERO then
            self.item_bg:SetActive(false)
            self.item_quality:SetActive(false)
            self.hero_quality:SetActive(true)
        else
            self.item_bg:SetActive(true)
            self.item_quality:SetActive(true)
            self.hero_quality:SetActive(false)
        end

        if self.param.rewardType == RewardType.GOODS then
            if self.param.itemId == nil then
                --联盟道具
                if self.param.iconName ~= nil and self.param.itemColor ~= nil then
                    self:SetFlagActive(false)
                    self:SetItemIconImage(self.param.iconName)
                    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(self.param.itemColor))
                end
            else
                --物品或英雄
                local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
                if goods ~= nil then
                    self:SetNameText(DataCenter.ItemTemplateManager:GetName(self.param.itemId))
                    --先判断是英雄碎片还是物品
                    local join_method = -1
                    local icon_join = nil
                    if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
                        join_method = goods.join_method
                        icon_join = goods.icon_join
                    end

                    if join_method > 0 and icon_join ~= nil and icon_join ~= "" then
                        --英雄
                        self:SetFlagActive(false)
                        local tempJoin = string.split(icon_join,";")
                        if #tempJoin > 1 then
                            elf:SetItemQualityImage(tempJoin[2])
                        end
                        if #tempJoin > 2 then
                            self:SetItemIconImage(tempJoin[3])
                        end
                    else
                        --物品
                        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
                        local itemType = goods.type
                        if itemType == 2 then -- SPD
                            if goods.para1 ~= nil and goods.para1 ~= "" then
                                local para1 = goods.para1
                                local temp = string.split(para1,';')
                                if temp ~= nil and #temp > 1 then
                                    self:SetFlagActive(true)
                                    self:SetFlagText(temp[1]..temp[2])
                                else
                                    self:SetFlagActive(false)
                                end
                            end
                        elseif itemType == 3 or goods.type == GOODS_TYPE.GOODS_TYPE_91 then -- USE
                            local type2 = goods.type2
                            if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" and tonumber(goods.para) > 1 then
                                local res_num = tonumber(goods.para)
                                self:SetFlagText(string.GetFormattedStr(res_num))
                                self:SetFlagActive(true)
                            else
                                self:SetFlagActive(false)
                            end
                        elseif itemType == 5 then
                            if goods.para3 ~= nil and goods.para3 ~= "" then
                                local res_num = tonumber(goods.para3)
                                self:SetFlagText(string.GetFormattedStr(res_num))
                                self:SetFlagActive(true)
                            else
                                self:SetFlagActive(false)
                            end
                        else
                            self:SetFlagActive(false)
                        end

                        self:SetItemIconImage(string.format(LoadPath.ItemPath, goods.icon))
                    end
                else
                    local resourceType = tonumber(self.param.itemId)
                    if resourceType < 100 then
                        --资源
                        self:SetFlagActive(false)
                        self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
                        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
                    end
                end
            end
        elseif self.param.rewardType == RewardType.GOLD then
            self:SetFlagActive(false)
            self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
            local color = (self.param.count and self.param.count > 10) and ItemColor.PURPLE or ItemColor.BLUE
            self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(color))
            self:SetNameText(Localization:GetString("100183"))
        elseif self.param.rewardType == RewardType.MATERIAL then
            self:SetFlagActive(false)
            local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
            if goods ~= nil then
                self:SetItemIconImage(goods.icon)
                self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(tonumber(goods.color)))
                self:SetNameText(DataCenter.ItemTemplateManager:GetName(self.param.itemId))
            end
        elseif self.param.rewardType == RewardType.MASTERY_POINT then
            self:SetFlagActive(false)
            self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.MasteryPoint))
            self.item_quality:SetActive(false)
            self.item_bg:SetActive(false)
        else
            self:SetFlagActive(false)
            self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
            self.item_quality:SetActive(false)
            self.item_bg:SetActive(false)
        end
    end
end

local function OnBtnClick(self)
    if self.param.rewardType == RewardType.GOODS then
        if self.param.itemId ~= nil then
            local param = {}
            param["itemId"] = self.param.itemId
            param["alignObject"] = self.item_icon
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
        elseif self.param.iconName ~= nil then
            local param = {}
            param["itemName"] = self.param.itemName
            param["itemDesc"] = self.param.itemDesc
            param["alignObject"] = self.item_icon
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
        end
    elseif self.param.rewardType == RewardType.HERO then
        local heroId = self.param.itemId
        local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), tonumber(heroId))
        local param = UIHeroTipsView.Param.New()
        param.heroId = heroId
        param.title = Localization:GetString(heroConfig.name)
        param.content = Localization:GetString(heroConfig.brief_desc)
        param.dir = UIHeroTipsView.Direction.ABOVE
        param.defWidth = 300
        param.pivot = 0.5
        param.position = self.transform.position + Vector3.New(0, 75, 0)
        param.bindObject = self.gameObject
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
        --local param = {}
        --param["itemId"] = self.param.itemId
        --param["rewardType"] = RewardType.HERO
        --param["alignObject"] = self.item_icon
        --UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    elseif self.param.rewardType == RewardType.UnlockModule then
        local param = {}
        param.itemName = self.param.itemName
        param.itemDesc = self.param.itemDesc
        param["alignObject"] = self.item_icon
        param.isLocal = false
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    else
        local desc = DataCenter.RewardManager:GetDescByType(self.param.rewardType, self.param.itemId)
        local name = DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId)
        local param = {}
        param["itemName"] = name
        param["itemDesc"] = desc
        param["alignObject"] = self.item_icon
        param.isLocal = true

        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    end
end


local function SetItemIconImage(self,imageName)
    self.item_icon:LoadSprite(imageName)
end

local function SetItemQualityImage(self,imageName)
    self.item_quality:LoadSprite(imageName)
end

local function SetItemCountActive(self,value)
    if self.itemCountActive ~= value then
        self.itemCountActive = value
        self.num_text.gameObject:SetActive(value)
    end
end

local function SetItemCount(self,value)
    if self.itemCount ~= value then
        self.itemCount = value
        self.num_text:SetText(value)
    end
end

local function SetItemCountColor(self,value)
    self.num_text:SetColor(value)
end

local function SetFlagActive(self,value)
    if self.flagActive ~= value then
        self.flagActive = value
        self.flag:SetActive(value)
    end
end

local function SetFlagText(self,value)
    if self.flagText ~= value then
        self.flagText = value
        self.flag_text:SetText(value)
    end
end

local function SetNameText(self,value)
    --if self.nameText ~= value then
    --    self.nameText = value
    --    self.name_text:SetText(value)
    --end
end

UIResourceExchangeCell.OnCreate = OnCreate
UIResourceExchangeCell.OnDestroy = OnDestroy
UIResourceExchangeCell.Param = Param
UIResourceExchangeCell.OnBtnClick = OnBtnClick
UIResourceExchangeCell.OnEnable = OnEnable
UIResourceExchangeCell.OnDisable = OnDisable
UIResourceExchangeCell.ComponentDefine = ComponentDefine
UIResourceExchangeCell.ComponentDestroy = ComponentDestroy
UIResourceExchangeCell.DataDefine = DataDefine
UIResourceExchangeCell.DataDestroy = DataDestroy
UIResourceExchangeCell.ReInit = ReInit
UIResourceExchangeCell.SetItemIconImage = SetItemIconImage
UIResourceExchangeCell.SetItemQualityImage = SetItemQualityImage
UIResourceExchangeCell.SetItemCountActive = SetItemCountActive
UIResourceExchangeCell.SetItemCount = SetItemCount
UIResourceExchangeCell.SetItemCountColor = SetItemCountColor
UIResourceExchangeCell.SetFlagActive = SetFlagActive
UIResourceExchangeCell.SetFlagText = SetFlagText
UIResourceExchangeCell.SetNameText = SetNameText

return UIResourceExchangeCell