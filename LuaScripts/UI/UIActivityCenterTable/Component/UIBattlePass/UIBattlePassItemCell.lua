---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/3/28 16:48
---

local UIBattlePassItemCell = BaseClass("UIBattlePassItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"
local lock_icon_path = "lock_icon"
local reward_get_icon_path = "reward_get_icon"
local icon_path = "ItemIcon"
local icon_bg_path = "ItemIconBg"
local num_text_path = "NumText"
local flag_text_path = "FlagGo/FlagText"
local flag_go_path = "FlagGo"
local btn_path = "btn"
local itemCover_path = "ItemCover"
local obj_path = ""
local bg_path = "Image (1)"
local privilege_path = "privilegeBg"
local privilegeIcon_path = "privilegeBg/privilegeIcon"
local privilegeMask_path = "privilegeBg/privilegeIcon/privilegeMask"
local privilegeTag_path = "privilegeTag"
local privilegeTagTxt_path = "privilegeTag/Bg/Text"
local heroIcon_path = "heroMask/heroIcon"
local heroMask_path = "heroMask"
local eff_path = "Eff"

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

--控件的定义
local function ComponentDefine(self)
    
    self.obj = self:AddComponent(UIBaseContainer,obj_path)

    self.lock_icon = self:AddComponent(UIImage, lock_icon_path)
    self.reward_get_icon = self:AddComponent(UIImage, reward_get_icon_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
    
    self.privilegeBgN = self:AddComponent(UIImage, privilege_path)
    self.privilegeIconN = self:AddComponent(UIImage, privilegeIcon_path)
    self.privilegeMaskN = self:AddComponent(UIImage, privilegeMask_path)
    self.privilegeTagN = self:AddComponent(UIBaseContainer, privilegeTag_path)
    self.privilegeTagN:SetActive(false)
    self.privilegeTagTxtN = self:AddComponent(UITextMeshProUGUIEx, privilegeTagTxt_path)
    self.privilegeTagTxtN:SetLocalText(100356)
    self.reward_effect = self:AddComponent(UIBaseContainer, eff_path)

    self.Itemcover = self:AddComponent(UIImage, itemCover_path)
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRewardClick()
    end)
    self.flag_text = self:AddComponent(UITextMeshProUGUIEx, flag_text_path)
    self.flag_go = self:AddComponent(UIBaseContainer, flag_go_path)
    
    self.heroIcon = self:AddComponent(UIImage, heroIcon_path)
    self.heroMask = self:AddComponent(UIImage, heroMask_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self.lock_icon = nil
    self.reward_get_icon = nil
    self.icon = nil
    self.reward = nil
    self.reward_effect = nil
    self.num_text = nil
end

--变量的定义
local function DataDefine(self)
    self.day = 1
end

--变量的销毁
local function DataDestroy(self)
    self.day = nil
end

local function SetData(self,param)
    self.param = param
    self:SetFlagActive(false)
    self.privilegeBgN:SetActive(false)
    self.icon_bg:SetActive(true)
    self.icon:SetActive(true)
    self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(param.reward.rewardType, param.reward.itemId))
    self.heroIcon:LoadSprite(DataCenter.RewardManager:GetPicByType(param.reward.rewardType, param.reward.itemId))
    self.heroMask:SetActive(param.reward.rewardType == RewardType.HERO)
    if param.reward.rewardType == RewardType.GOODS then
        if param.reward.isPrivilege then
            self.privilegeBgN:SetActive(true)
            self.privilegeIconN:LoadSprite(DataCenter.RewardManager:GetPicByType(param.reward.rewardType, param.reward.itemId))
            self.icon_bg:SetActive(false)
            self.icon:SetActive(false)
        end
        --物品或英雄
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.reward.itemId)
        if goods ~= nil then
            local itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
            self.icon_bg:LoadSprite(itemColor)
            if goods.type == 2 then -- SPD
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
            elseif goods.type == 3 then -- USE
                local type2 = goods.type2
                if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                    local res_num = tonumber(goods.para)
                    self:SetFlagText(string.GetFormattedStr(res_num))
                    self:SetFlagActive(true)
                else
                    self:SetFlagActive(false)
                end
            elseif goods.type == 5 then
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
        end
    elseif param.reward.rewardType == RewardType.OIL or param.reward.rewardType == RewardType.METAL
            or param.reward.rewardType == RewardType.WATER or param.reward.rewardType == RewardType.MONEY or param.reward.rewardType == RewardType.ELECTRICITY
            or param.reward.rewardType == RewardType.PVE_POINT or param.reward.rewardType == RewardType.GOLD or param.reward.rewardType == RewardType.WOOD then
        self:SetFlagActive(false)
        local itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
        self.icon_bg:LoadSprite(itemColor)
    elseif param.reward.rewardType == RewardType.EXP then
        self:SetFlagActive(false)
        local itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.BLUE)
        self.icon_bg:LoadSprite(itemColor)
    elseif param.reward.rewardType == RewardType.HERO then
        local rarity = GetTableData(HeroUtils.GetHeroXmlName(), param.reward.itemId, 'rarity')
        self.icon_bg:LoadSprite(HeroUtils.GetHeroBgByColor(tonumber(rarity)))
        self.icon:SetActive(false)
    end
    local numStr = "x"..string.GetFormattedSeperatorNum(param.reward.count)
    self.num_text:SetText(numStr)

    self.Itemcover:SetActive(false)
    self.privilegeMaskN:SetActive(false)
    self.privilegeTagN:SetActive(param.reward.isPrivilege)
    self.isGetReward = false
    if param.isTop then
        if param.state == 1 then    --领取过
            self.reward_get_icon:SetActive(true)
            self.lock_icon:SetActive(false)
            self.reward_effect:SetActive(false)
            if param.reward.isPrivilege then
                self.privilegeMaskN:SetActive(true)
            else
                self.Itemcover:SetActive(true)
            end
        else    --没领取过
            if param.locked then   --没解锁
                self.reward_get_icon:SetActive(false)
                self.lock_icon:SetActive(false)
                self.reward_effect:SetActive(false)
            else    --已解锁
                self.reward_effect:SetActive(true)
                self.reward_get_icon:SetActive(false)
                self.lock_icon:SetActive(false)
                self.isGetReward = true
            end
        end
    else
        if param.state == 1 then    --领取过
            self.reward_get_icon:SetActive(true)
            self.lock_icon:SetActive(false)
            self.reward_effect:SetActive(false)
            if param.reward.isPrivilege then
                self.privilegeMaskN:SetActive(true)
            else
                self.Itemcover:SetActive(true)
            end
        else    --没领取过的
            if param.unlock == 1 then
                if param.locked then
                    self.reward_get_icon:SetActive(false)
                    self.lock_icon:SetActive(false)
                    self.reward_effect:SetActive(false)
                else
                    self.reward_get_icon:SetActive(false)
                    self.lock_icon:SetActive(false)
                    self.reward_effect:SetActive(true)
                    self.isGetReward = true
                end
            else
                if param.locked then
                    self.reward_get_icon:SetActive(false)
                    self.lock_icon:SetActive(true)
                    self.reward_effect:SetActive(false)
                else
                    self.reward_get_icon:SetActive(false)
                    self.reward_effect:SetActive(false)
                end
            end
        end
    end
end

local function SetFlagActive(self,value)
    self.flag_go:SetActive(value)
end

local function SetFlagText(self,value)
    self.flag_text:SetText(value)
end

local function SetBuyData(self,param)
    self.isGetReward = false
    self.param = {}
    self:SetFlagActive(false)
    self.param.reward = param
    self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(param.rewardType, param.itemId))
    self.heroIcon:LoadSprite(DataCenter.RewardManager:GetPicByType(param.rewardType, param.itemId))
    self.heroMask:SetActive(param.rewardType == RewardType.HERO)
    if param.rewardType == RewardType.GOODS then
        --物品或英雄
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
        if goods ~= nil then
            local itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
            self.icon_bg:LoadSprite(itemColor)
            if goods.type == 2 then -- SPD
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
            elseif goods.type == 3 then -- USE
                local type2 = goods.type2
                if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                    local res_num = tonumber(goods.para)
                    self:SetFlagText(string.GetFormattedStr(res_num))
                    self:SetFlagActive(true)
                else
                    self:SetFlagActive(false)
                end
            else
                self:SetFlagActive(false)
            end
        end
    elseif param.rewardType == RewardType.OIL or param.rewardType == RewardType.METAL
            or param.rewardType == RewardType.WATER or param.rewardType == RewardType.MONEY or param.rewardType == RewardType.ELECTRICITY
            or param.rewardType == RewardType.PVE_POINT or param.rewardType == RewardType.GOLD or param.rewardType == RewardType.WOOD then
        self:SetFlagActive(false)
        local itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
        self.icon_bg:LoadSprite(itemColor)
    elseif param.rewardType == RewardType.EXP then
        self:SetFlagActive(false)
        local itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.BLUE)
        self.icon_bg:LoadSprite(itemColor)
    elseif param.reward.rewardType == RewardType.HERO then
        local rarity = GetTableData(HeroUtils.GetHeroXmlName(), param.reward.itemId, 'rarity')
        self.icon_bg:LoadSprite(HeroUtils.GetHeroBgByColor(tonumber(rarity)))
        self.icon:SetActive(false)
    end
    local numStr = "x"..string.GetFormattedSeperatorNum(param.count)
    self.num_text:SetText(numStr)
    self.reward_get_icon:SetActive(false)
    self.lock_icon:SetActive(false)
    self.reward_effect:SetActive(false)
    self.Itemcover:SetActive(false)
end

local function OnRewardClick(self)
    if self.isGetReward then
        if self.param.callBack() then
            UIUtil.ShowTipsId(370100)
            return
        end
        local type = 0
        if self.param.isTop then
            type = 0
        else
            type = 1
        end
        self.isGetReward = false
        if self.param.claimCallback then
            self.param.claimCallback(self.param.lv,type)
        else
            SFSNetwork.SendMessage(MsgDefines.ReceiveBattlePassStageReward,self.param.actId,self.param.lv,type)
        end
        return
    end
    if self.param.state == 0 then
        if self.param.isTop then
            UIUtil.ShowTips(Localization:GetString("320443",self.param.lv))
        else
            if self.param.unlock == 0 then                                          --未解锁
                UIUtil.ShowTips(Localization:GetString("320442"))
                if self.param.callBack() then
                    UIUtil.ShowTipsId(370100)
                    return
                end
                --UIManager:GetInstance():OpenWindow(UIWindowNames.UIBattlePassGiftPackagePopUp, self.param.actId)
                --return
            else                                                                    --解锁
                UIUtil.ShowTips(Localization:GetString("320443",self.param.lv))
            end
        end
    end
    if self.param.reward.rewardType == RewardType.GOODS then
        if self.param.reward.itemId ~= nil then
            local param = {}
            param["itemId"] = self.param.reward.itemId
            param["alignObject"] = self.param.reward.isPrivilege and self.privilegeIconN or self.icon
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
        end
    elseif self.param.reward.rewardType == RewardType.HERO then
        local heroId = self.param.reward.itemId
        local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), tonumber(heroId))
        local param = UIHeroTipsView.Param.New()
        param.heroId = heroId
        param.title = Localization:GetString(heroConfig.name)
        param.content = Localization:GetString(heroConfig.brief_desc)
        param.dir = UIHeroTipsView.Direction.ABOVE
        param.defWidth = 300
        param.pivot = 0.5
        param.position = self.transform.position + Vector3.New(0, 45, 0)
        param.bindObject = self.gameObject
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
    else
        local desc = DataCenter.RewardManager:GetDescByType(self.param.reward.rewardType, self.param.reward.itemId)
        local name = DataCenter.RewardManager:GetNameByType(self.param.reward.rewardType, self.param.reward.itemId)
        local param = {}
        param["itemName"] = name
        param["itemDesc"] = desc
        param["alignObject"] = self.icon
        param.isLocal = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    end
end


UIBattlePassItemCell.OnCreate = OnCreate
UIBattlePassItemCell.OnDestroy = OnDestroy
UIBattlePassItemCell.ComponentDefine = ComponentDefine
UIBattlePassItemCell.ComponentDestroy = ComponentDestroy
UIBattlePassItemCell.DataDefine = DataDefine
UIBattlePassItemCell.DataDestroy = DataDestroy
UIBattlePassItemCell.SetItem = SetItem
UIBattlePassItemCell.SetData = SetData
UIBattlePassItemCell.SetBuyData = SetBuyData
UIBattlePassItemCell.OnRewardClick = OnRewardClick
UIBattlePassItemCell.SetFlagActive = SetFlagActive
UIBattlePassItemCell.SetFlagText = SetFlagText
return UIBattlePassItemCell