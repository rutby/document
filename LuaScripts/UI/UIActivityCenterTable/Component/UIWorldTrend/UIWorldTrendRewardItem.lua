---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local UIWorldTrendRewardItem = BaseClass("UIWorldTrendRewardItem", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray
local ImgQuality = "UICommonResItem/clickBtn/ImgQuality"
local ItemIcon = "UICommonResItem/clickBtn/ItemIcon"
local FlagGo = "UICommonResItem/clickBtn/FlagGo"
local FlagText = "UICommonResItem/clickBtn/FlagGo/FlagText"
local NumText = "UICommonResItem/clickBtn/NumText"
local ImgExtra = "UICommonResItem/clickBtn/ImgExtra"
local Check = "UICommonResItem/Check"
local Mask = "UICommonResItem/Mask"
local clickBtn = "UICommonResItem/clickBtn"
-- local Rect_RewardEffect = "Rect_RewardEffect" --这个节点ui上已经没了
local anim_path = "UICommonResItem"

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
    self.item_quality = self:AddComponent(UIImage, ImgQuality)
    self.item_icon = self:AddComponent(UIImage, ItemIcon)
    self.flag = self:AddComponent(UIBaseContainer,FlagGo)
    self.flag_text = self:AddComponent(UITextMeshProUGUIEx, FlagText)
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, NumText)
    self.imgExtra = self:AddComponent(UIImage,ImgExtra)
    
    self.check = self:AddComponent(UIBaseContainer,Check)
    self.mask = self:AddComponent(UIBaseContainer,Mask)

    self.select_btn =self:AddComponent(UIButton,clickBtn)
    self.select_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
         self:OnBtnClick()
    end)
    
    --self._rewardEffect_rect = self:AddComponent(UIBaseContainer,Rect_RewardEffect)

    self.anim = self:AddComponent(UIAnimator,anim_path)
    self.anim:Play("V_ui_tubiaolingqu_default", 0, 0)
end 

--控件的销毁
local function ComponentDestroy(self)
    self.item_quality = nil
    self.item_icon = nil
    self.flag = nil
    self.flag_text = nil
    self.num_text = nil
    self.select_btn = nil
    self.check = nil
    self.mask = nil
end

--变量的定义
local function DataDefine(self)
    self.param = {}
end

--变量的销毁
local function DataDestroy(self)
    self.param = nil
    self.state = nil
end

-- 全部刷新
local function RefreshData(self,param)
    self.param = param
    self.imgExtra:SetActive(false)
    self.flag:SetActive(false)
    self.num_text:SetText(self.param.count)
    if self.param.rewardType == RewardType.GOODS then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
        local flagtxt = ""
        self.item_quality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))

        self:SetItemIconImage(string.format(LoadPath.ItemPath,goods.icon))
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
        self.flag:SetActive(flagtxt ~= "")
        self.flag_text:SetText(flagtxt)
        --self._name_txt:SetText(DataCenter.ItemTemplateManager:GetName(self.param .itemId))
    elseif self.param.rewardType == RewardType.GOLD then
        self:SetItemIconImage(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
        local color = (self.param.count and self.param.count > 10) and ItemColor.PURPLE or ItemColor.BLUE
        --self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(color))
    elseif self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL
            or self.param.rewardType == RewardType.WATER
            or self.param.rewardType == RewardType.MONEY or self.param.rewardType == RewardType.ELECTRICITY or self.param.rewardType == RewardType.WOOD then
        self.item_quality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
        self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
    elseif self.param.rewardType == RewardType.HERO then
        local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param.itemId) 
        if xmlData ~= nil then
            self:SetItemIconImage(xmlData["hero_icon"])
        end
    end
end

local function SetItemIconImage(self,imageName)
    self.item_icon:LoadSprite(imageName)
end

--根据任务奖励是否领取设置
local function SetRewardState(self,state)
    self.check:SetActive(state)
    self.mask:SetActive(state)
end

--根据任务开启状态设置
local function SetQuestState(self,state)
    if self.state ~= state then
        self.mask:SetActive(state)
        --UIGray.SetGray(self.transform,state, true)
        self.state = state
    end
end

--根据是否可领奖设置特效
local function SetReceiveState(self,state)
    --self._rewardEffect_rect:SetActive(state) 
    if state then
        self.anim:Play("V_ui_tubiaolingqu_huxi", 0, 0)
    else
        self.anim:Play("V_ui_tubiaolingqu_default", 0, 0)
    end
 
end

local function OnBtnClick(self)
    if self.param.rewardType == RewardType.GOODS then
        local param = {}
        param["itemId"] = self.param.itemId
        param["alignObject"] = self.item_icon
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    else
        local desc = DataCenter.RewardManager:GetDescByType(self.param.rewardType,self.param.itemId)
        local name = DataCenter.RewardManager:GetNameByType(self.param.rewardType,self.param.itemId)
        local param = {}
        param["itemName"] = name
        param["itemDesc"] = desc
        param["alignObject"] = self.item_icon
        param.isLocal = true
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    end
end

UIWorldTrendRewardItem.OnCreate = OnCreate
UIWorldTrendRewardItem.OnDestroy = OnDestroy
UIWorldTrendRewardItem.OnEnable = OnEnable
UIWorldTrendRewardItem.OnDisable = OnDisable
UIWorldTrendRewardItem.ComponentDefine = ComponentDefine
UIWorldTrendRewardItem.ComponentDestroy = ComponentDestroy
UIWorldTrendRewardItem.DataDefine = DataDefine
UIWorldTrendRewardItem.DataDestroy = DataDestroy
UIWorldTrendRewardItem.RefreshData = RefreshData
UIWorldTrendRewardItem.SetItemIconImage = SetItemIconImage
UIWorldTrendRewardItem.SetRewardState = SetRewardState
UIWorldTrendRewardItem.SetQuestState = SetQuestState
UIWorldTrendRewardItem.SetReceiveState = SetReceiveState
UIWorldTrendRewardItem.OnBtnClick = OnBtnClick

return UIWorldTrendRewardItem