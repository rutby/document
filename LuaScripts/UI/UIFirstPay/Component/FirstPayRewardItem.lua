---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 17:23
---

local FirstPayRewardItem = BaseClass("FirstPayRewardItem", UIBaseContainer)
local base = UIBaseContainer

local function OnCreate(self)
    base.OnCreate(self)
    
    self.itemQualityN = self:AddComponent(UIImage, "UICommonItem/clickBtn/ImgQuality")
    self.itemIconN = self:AddComponent(UIImage, "UICommonItem/clickBtn/ItemIcon")
    self.itemNumN = self:AddComponent(UITextMeshProUGUIEx, "UICommonItem/clickBtn/NumText")
    self.flagGoN = self:AddComponent(UIBaseContainer, "UICommonItem/clickBtn/FlagGo")
    self.flagTxtN = self:AddComponent(UITextMeshProUGUIEx, "UICommonItem/clickBtn/FlagGo/FlagText")
    self.clickBtnN = self:AddComponent(UIButton, "UICommonItem/clickBtn")
    self.clickBtnN:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickItem()
    end)
end

local function OnDestroy(self)
    self.itemQualityN = nil
    self.itemIconN = nil
    self.itemNumN = nil
    self.flagGoN = nil
    self.flagTxtN = nil
    self.clickBtnN = nil
    base.OnDestroy(self)
end

local function SetItem(self, reward)--from UIGiftRewardCell
    self.param = reward
    
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId)
    if not reward then
        return
    end
    --icon
    local iconPath = self:GetIconPath(reward)
    self.itemIconN:LoadSprite(iconPath)
    --num
    self.itemNumN:SetText(string.GetFormattedStr(reward.itemCount))
    --quality
    local quality_name = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
    local join_method = -1
    local icon_join = nil
    if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
        join_method = goods.join_method
        icon_join = goods.icon_join
    end
    if join_method > 0 and icon_join ~= nil and icon_join ~= "" then
        --英雄
        local tempJoin = string.split(icon_join,";")
        if #tempJoin > 1 then
            quality_name = tempJoin[2]
        end
        if #tempJoin > 2 then
            quality_name = tempJoin[3]
        end
    end
    self.itemQualityN:LoadSprite(quality_name)
    --flag
    local flagtxt = ""
    if goods.type == 2 then
        if goods.para1 ~= nil and goods.para1 ~= "" then
            local para1 = goods.para1
            local temp = string.split(para1,';')
            if temp ~= nil and #temp > 1 then
                flagtxt = temp[1]..temp[2]
            end
        end
    elseif goods.type == 3 or goods.type == GOODS_TYPE.GOODS_TYPE_91 then
        local type2 = goods.type2
        if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
            local res_num = tonumber(goods.para)
            flagtxt = string.GetFormattedStr(res_num)
        end
    elseif goods.type == 5 then
        if goods.para3 ~= nil and goods.para3 ~= "" then
            local res_num = tonumber(goods.para3)
            flagtxt = string.GetFormattedStr(res_num)
        end
    end
    if not flagtxt or flagtxt == "" then
        self.flagGoN:SetActive(false)
    else
        self.flagGoN:SetActive(true)
        self.flagTxtN:SetText(flagtxt)
    end
end

local function GetIconPath(self, reward)
    local retIconPath = ""
    if reward.itemType == RewardType.GOODS then
        if reward.itemId == nil then
            --联盟道具
            if reward.iconName ~= nil and reward.itemColor ~= nil then
                retIconPath = reward.iconName
            end
        else
            --物品或英雄
            local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId)
            if goods ~= nil then
                --先判断是英雄碎片还是物品
                local join_method = -1
                local icon_join = nil
                if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
                    join_method = goods.join_method
                    icon_join = goods.icon_join
                end
                if join_method > 0 and icon_join ~= nil and icon_join ~= "" then
                    --英雄
                    local tempJoin = string.split(icon_join,";")
                    if #tempJoin > 1 then
                        retIconPath = tempJoin[2]
                    end
                    if #tempJoin > 2 then
                        retIconPath = tempJoin[3]
                    end
                else
                    if itemType == 9 then -- 装备
                        retIconPath = goods.icon
                    else
                        retIconPath = string.format(LoadPath.ItemPath, goods.icon)
                    end
                end
            else
                local resourceType = tonumber(reward.itemId)
                if resourceType < 100 then
                    --资源
                    retIconPath = DataCenter.ResourceManager:GetResourceIconByType(resourceType)
                end
            end
        end
    elseif reward.itemType == ResourceType.Gold then
        retIconPath = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
    elseif reward.itemType == RewardType.OIL or reward.itemType == RewardType.METAL
            or reward.itemType == RewardType.WATER
            or reward.itemType == RewardType.MONEY or reward.itemType == RewardType.ELECTRICITY then

        retIconPath = DataCenter.RewardManager:GetPicByType(reward.itemType)
    elseif reward.itemType == RewardType.ARM then
        local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(reward.itemId)
        if army ~= nil then
            retIconPath = string.format(LoadPath.SoldierIcons,army.icon)
        end
    --elseif reward.itemType == RewardType.EQUIP then
    --    local xmlData = LocalController:instance():getLine("equip_info_new_equip", reward.itemId)
    --    if xmlData ~= nil then
    --        retIconPath = xmlData["icon"]
    --    end
    elseif reward.itemType == RewardType.HERO then
        local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), reward.itemId)
        if xmlData ~= nil then
            retIconPath = xmlData["hero_icon"]
        end
    elseif reward.itemType == RewardType.HONOR or reward.itemType == RewardType.ALLIANCE_POINT then
        retIconPath = DataCenter.RewardManager:GetPicByType(reward.itemType,reward.itemId)
    elseif reward.itemType == RewardType.MATERIAL then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId)
        if goods ~= nil then
            retIconPath = goods.icon
        end
    elseif reward.itemType == RewardType.ITEM_EFFECT then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(reward.itemId)
        if goods ~= nil then
            retIconPath = string.format(LoadPath.ItemPath, goods.icon)
        end
    end
    return retIconPath
end

local function OnClickItem(self)
    local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
    if not goods then
        return
    end

    if self.param.itemId ~= nil then
        local param = {}
        param["itemId"] = self.param.itemId
        param["alignObject"] = self.itemIconN
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    end
    --
    --local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    --local position = self.transform.position + Vector3.New(0, 30, 0) * scaleFactor
    --
    --local param = UIHeroTipView.Param.New()
    --param.title = Localization:GetString(goods.name)
    --param.content = Localization:GetString(goods.description)
    --param.dir = UIHeroTipView.Direction.ABOVE
    --param.defWidth = 180
    --param.pivot = 0.5
    --param.position = position
    --UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end


FirstPayRewardItem.OnCreate = OnCreate
FirstPayRewardItem.OnDestroy = OnDestroy

FirstPayRewardItem.SetItem = SetItem
FirstPayRewardItem.Param = Param
FirstPayRewardItem.GetIconPath = GetIconPath
FirstPayRewardItem.OnClickItem = OnClickItem
return FirstPayRewardItem