---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/2/16 18:16
---

local UICommonItem_TextMeshPro = BaseClass("UICommonItem_TextMeshPro", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local item_bg_path = "clickBtn/item_bg"
local hero_quality_path = "clickBtn/HeroQuality"
local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local num_text_path = "clickBtn/NumText"
local flag_path = "clickBtn/FlagGo"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local this_path = "clickBtn"
local extra_path = "clickBtn/ImgExtra"
local camp_path = "clickBtn/ImgCamp"
local check_path = "clickBtn/ImgRece"
local check_ys_path = "clickBtn/ImgRece/ImgYs"
local img_firstKill = "clickBtn/Img_FirstKill"

local QualityBgToCircleType = {
    ["Common_img_quality_blue"] = "Assets/Main/Sprites/UI/UIPaidLottery/turntable_icon_blue.png",
    ["Common_img_quality_green"] = "Assets/Main/Sprites/UI/UIPaidLottery/turntable_icon_green.png",
    ["Common_img_quality_orange"] = "Assets/Main/Sprites/UI/UIPaidLottery/turntable_icon_orange.png",
    ["Common_img_quality_purple"] = "Assets/Main/Sprites/UI/UIPaidLottery/turntable_icon_purple.png",
}


-- 创建
function UICommonItem_TextMeshPro:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UICommonItem_TextMeshPro:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function UICommonItem_TextMeshPro:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function UICommonItem_TextMeshPro:OnDisable()
    base.OnDisable(self)
end


--控件的定义
function UICommonItem_TextMeshPro:ComponentDefine()
    self.item_bg = self:AddComponent(UIImage, item_bg_path)
    self.hero_quality = self:AddComponent(UIImage, hero_quality_path)
    self.item_quality = self:AddComponent(UIImage, item_quality_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
    self.flag_text = self:AddComponent(UITextMeshProUGUIEx, flag_text_path)
    self.btn = self:AddComponent(UIButton, this_path)
    self.flag = self:AddComponent(UIBaseContainer, flag_path)
    self.imgExtra = self:AddComponent(UIImage, extra_path)
    self.imgCamp = self:AddComponent(UIImage, camp_path)
    self.check_go = self:AddComponent(UIBaseContainer, check_path)
    self.check_ys = self:AddComponent(UIBaseContainer,check_ys_path)
    local imgObj = self.transform:Find(img_firstKill)
    if imgObj then
        self.img_firstKill = self:AddComponent(UIImage,img_firstKill)
    end
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
end

--控件的销毁
function UICommonItem_TextMeshPro:ComponentDestroy()
end

--变量的定义
function UICommonItem_TextMeshPro:DataDefine()
    self.param = {}
    self.flagText = nil
    self.flagActive = nil
    self.itemCount = nil
    self.itemCountActive = nil
    self.nameText = nil
end

--变量的销毁
function UICommonItem_TextMeshPro:DataDestroy()
    self.param = nil
    self.flagText = nil
    self.flagActive = nil
    self.itemCount = nil
    self.itemCountActive = nil
    self.nameText = nil
end

-- 全部刷新
function UICommonItem_TextMeshPro:ReInit(param)
    self.param = param
    if self.param.count == nil then
        self:SetItemCountActive(false)
    else
        self:SetItemCountActive(true)
        self:SetItemCount(self.param.count)
    end

    self.imgExtra:SetActive(false)
    self.imgCamp:SetActive(false)
    self.check_go:SetActive(false)
    if self.img_firstKill then
        self.img_firstKill:SetActive(false)
    end
    if self.param.rewardType == nil then
        self:SetFlagActive(false)
        self.item_bg:SetActive(false)
        self.item_quality:SetActive(false)
        self.hero_quality:SetActive(false)
        self:SetItemIconImage(string.format(LoadPath.CommonNewPath, self.param.itemIcon))
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
                    self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(tonumber(self.param.itemColor)))
                    self.num_text:SetText("")
                elseif self.param.heroConfigId ~= nil then
                    self:SetFlagActive(false)
                    local _heroConfigId = self.param.heroConfigId
                    self:SetItemIconImage(HeroUtils.GetHeroIconPath(_heroConfigId, false))
                    local rarity = GetTableData(HeroUtils.GetHeroXmlName(), _heroConfigId, "rarity")
                    self:SetItemQualityImage(HeroUtils.GetRarityIconPath(rarity, false))
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
                            self:SetItemQualityImage(tempJoin[2])
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
                        elseif itemType == 5 or itemType == GOODS_TYPE.GOODS_TYPE_112 then
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
                    if resourceType ~= nil and resourceType < 100 then
                        --资源
                        self:SetFlagActive(false)
                        self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
                        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
                    end
                end
            end
        elseif self.param.rewardType == RewardType.GOLD then
            self:SetFlagActive(false)
            self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
            local color = (self.param.count and self.param.count > 10) and ItemColor.PURPLE or ItemColor.BLUE
            self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(color))
            self:SetNameText(Localization:GetString("100183"))
        elseif self.param.rewardType == RewardType.ARM then
            self:SetFlagActive(false)
            local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.itemId)
            if army ~= nil then
                self:SetItemIconImage(string.format(LoadPath.SoldierIcons,army.icon))
                self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE))
                self:SetNameText(Localization:GetString(army.name))
            end
        elseif self.param.rewardType == RewardType.EQUIP then
            self:SetFlagActive(false)

            local xmlData = LocalController:instance():getLine("equip_info_new_equip", self.param.itemId)
            if xmlData ~= nil then
                self:SetItemIconImage(xmlData:GetString("icon"))
                local nColor = 0
                if xmlData:HasKey("color") then
                    nColor = tonumber(xmlData:GetString("color"))
                end

                if nColor < 0 then
                    nColor = 0
                end
                self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(nColor))
                self:SetNameText(Localization:GetString(xmlData:GetString("name")))
            end
        elseif self.param.rewardType == RewardType.HERO then
            self:SetFlagActive(false)
            self.heroTipsPos = nil
            local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param.itemId)
            if xmlData ~= nil then
                self:SetItemIconImage(LoadPath.HeroIconsSmallPath .. xmlData["hero_icon"])
                self.item_bg:SetActive(false)
                self.item_quality:SetActive(false)
                self.hero_quality:SetActive(true)
                local rarity = tonumber(xmlData["rarity"])
                self.hero_quality:LoadSprite(HeroUtils.GetRarityIconPath(rarity))
                self:SetNameText(Localization:GetString(xmlData["name"]))
                local camp = tonumber(xmlData["camp"])
                if camp~=-1 then
                    self.imgCamp:SetActive(true)
                    self.imgCamp:LoadSprite(HeroUtils.GetCampIconPath(camp))
                else
                    self.imgCamp:SetActive(false)
                end
            end
        elseif self.param.rewardType == RewardType.HONOR or self.param.rewardType == RewardType.ALLIANCE_POINT then
            self:SetFlagActive(false)
            self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType,self.param.itemId))
            self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType,self.param.itemId))
        elseif self.param.rewardType == RewardType.MATERIAL then
            self:SetFlagActive(false)
            local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
            if goods ~= nil then
                self:SetItemIconImage(goods.icon)
                self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(tonumber(goods.color)))
                self:SetNameText(DataCenter.ItemTemplateManager:GetName(self.param.itemId))
            end
        elseif self.param.rewardType == RewardType.Golloes then
            self:SetFlagActive(false)
            self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
            self:SetItemIconImage(string.format("Assets/Main/Sprites/UI/UIGolloesCamp/%s",GolloesShow[self.param.itemId].rewardIcon))
            self:SetNameText(Localization:GetString(GolloesShow[self.param.itemId].name))
        elseif self.param.rewardType == RewardType.EXP then
            self:SetFlagActive(false)
            self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.BLUE))
            self:SetItemIconImage(string.format(LoadPath.CommonNewPath, "Common_icon_exp"))
            self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
        elseif self.param.rewardType == RewardType.UnlockModule then
            self:SetFlagActive(false)
            self.item_bg:SetActive(false)
            self.item_quality:SetActive(false)
            self.hero_quality:SetActive(false)
            self:SetItemIconImage(string.format(LoadPath.CommonNewPath, self.param.itemIcon))
        elseif self.param.rewardType == RewardType.HERO_EXP then
            self:SetFlagActive(false)
            self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
            self:SetItemIconImage(string.format(LoadPath.CommonNewPath, "Common_icon_hero_exp"))
            self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
        elseif self.param.rewardType == RewardType.CAR_EQUIP then
            self:SetFlagActive(false)
            self:SetItemQualityImage(EquipmentUtil.GetEquipmentQualityBG(self.param.itemId))
            self:SetItemIconImage(EquipmentUtil.GetEquipmentIcon(self.param.itemId))
            self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
        elseif self.param.rewardType == RewardType.DECORATION then
            self:SetFlagActive(false)
            self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType, self.param.itemId))
            self:SetItemQualityImage(DataCenter.RewardManager:GetIconColorByRewardType(self.param.rewardType, self.param.itemId))
            self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType, self.param.itemId))
        else
            self:SetFlagActive(false)
            self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
            if self.param.rewardType == RewardType.FORMATION_STAMINA then
                self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
            else
                self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
            end
            self:SetNameText(DataCenter.RewardManager:GetNameByType(self.param.rewardType))
        end
    end
end

function UICommonItem_TextMeshPro:OnBtnClick()
    if self.param.rewardType == RewardType.GOODS then
        if self.param.showSpecialHeroRecruitItemTip == true and DataCenter.LotteryDataManager:IsShowRecruitItemIntro(tostring(self.param.itemId)) then
            local para = DeepCopy(self.param)
            para.item_icon = self.item_icon
            UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonRecruitItemIntro, tostring(self.param.itemId), para)
            return
        end
        if self.param.itemId ~= nil then
            local param = {}
            param["itemId"] = self.param.itemId
            param["alignObject"] = self.item_icon
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
        elseif self.param.iconName ~= nil then
            local param = {}
            param["itemName"] = self.param.itemName
            if self.param.itemDesc then
                param["itemDesc"] = self.param.itemDesc
                param["alignObject"] = self.item_icon
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
            end
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
        local offset = Vector3.New(0, 75, 0)
        if self.heroTipsPos then
            offset = self.heroTipsPos
        end
        param.position = self.transform.position + offset
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


function UICommonItem_TextMeshPro:SetItemIconImage(imageName)
    self.loadIconPath = imageName
    self.item_icon:LoadSprite(imageName)
end

function UICommonItem_TextMeshPro:SetItemQualityImage(imageName)
    if self.param and self.param.useCircle then
        local pathArr = string.split(imageName, "/")
        local rectName = pathArr[#pathArr]
        pathArr = string.split(rectName, ".")
        rectName = pathArr[1]
        local circleName = QualityBgToCircleType[rectName]
        if circleName then
            imageName = circleName
        end
    end

    self.item_quality:LoadSprite(imageName)
end

function UICommonItem_TextMeshPro:SetItemCountActive(value)
    if self.itemCountActive ~= value then
        self.itemCountActive = value
        self.num_text.gameObject:SetActive(value)
    end
end

function UICommonItem_TextMeshPro:SetItemCount(value)
    if self.itemCount ~= value then
        self.itemCount = value
        if type(value) == "number" then
            if value >= 100000 then
                self.num_text:SetText(string.GetFormattedStr(value))
            else
                self.num_text:SetText(string.GetFormattedSeperatorNum(value))
            end
        else
            self.num_text:SetText(value)
        end
    end
end

function UICommonItem_TextMeshPro:SetItemCountColor(value)
    self.num_text:SetColor(value)
end

function UICommonItem_TextMeshPro:SetFlagActive(value)
    if self.flagActive ~= value then
        self.flagActive = value
        self.flag:SetActive(value)
    end
end

function UICommonItem_TextMeshPro:SetCheckActive(value1,value2)
    self.check_go:SetActive(value1)
    self.check_ys:SetActive(value2)
end

function UICommonItem_TextMeshPro:SetFlagText(value)
    if self.flagText ~= value then
        self.flagText = value
        self.flag_text:SetText(value)
    end
end

function UICommonItem_TextMeshPro:SetNameText(value)
    self.nameText = value
end

function UICommonItem_TextMeshPro:SetHeroTypeTipPos(position)
    self.heroTipsPos = position
end

function UICommonItem_TextMeshPro:GetResName()
    return self.nameText and self.nameText or ""
end

function UICommonItem_TextMeshPro:GetPosition()
    return self.btn.rectTransform.position
end

function UICommonItem_TextMeshPro:GetIconPath()
    return self.loadIconPath
end

return UICommonItem_TextMeshPro