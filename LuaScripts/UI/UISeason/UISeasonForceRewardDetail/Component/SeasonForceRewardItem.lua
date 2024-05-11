---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/1/16 10:57
---
local RewardItem = require "UI.UIWorldPoint.Component.WorldPointRewardItem"
local SeasonForceRewardItem = BaseClass("SeasonForceRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization 
-- 创建
function SeasonForceRewardItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function SeasonForceRewardItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function SeasonForceRewardItem:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function SeasonForceRewardItem:OnDisable()
    base.OnDisable(self)
end


--控件的定义
function SeasonForceRewardItem:ComponentDefine()
    self._des_txt = self:AddComponent(UIText, "Txt_Des")
    self.money_obj = self:AddComponent(RewardItem,"money_obj")
    self.goods_obj = self:AddComponent(RewardItem,"goods_obj")
    self.time_des = self:AddComponent(UIText,"Txt_time")
    self.state_des = self:AddComponent(UIText,"Txt_state")
    self.image = self:AddComponent(UIImage,"bg")
end

--控件的销毁
function SeasonForceRewardItem:ComponentDestroy()
    self._des_txt = nil
    self.money_obj = nil
    self.goods_obj = nil
    self.time_des = nil
    self.state_des = nil
end

--变量的定义
function SeasonForceRewardItem:DataDefine()
    self.param = {}
end

--变量的销毁
function SeasonForceRewardItem:DataDestroy()
    self.param = nil
end

-- 全部刷新
function SeasonForceRewardItem:ReInit(data)
    self.data = data
    local rewardParam = self.data.moneyData
    if rewardParam~=nil then
        self.money_obj:SetActive(true)
        self.money_obj:RefreshData(rewardParam)
    else
        self.money_obj:SetActive(false)
    end
    local rewardGoodsParam = self.data.goodsData
    if rewardGoodsParam~=nil then
        self.goods_obj:SetActive(true)
        self.goods_obj:RefreshData(rewardGoodsParam)
    else
        self.goods_obj:SetActive(false)
    end
    if self.data.isNormal == true then
        local des = Localization:GetString("110453")..": "..self.data.force
        self._des_txt:SetText(des)
    else
        self._des_txt:SetText(Localization:GetString("110473"))
    end
    self.time_des:SetText(UITimeManager:GetInstance():GetMailShowTime(self.data.createTime),true)
    if self.data.status == SeasonForceRewardStatus.NOT_RECEIVE then
        if self.data.isOver == true then
            self.state_des:SetText(Localization:GetString("390843"))
            self.image:LoadSprite("Assets/Main/Sprites/UI/UISeasonRobots/UIcompetition_bg_panel02.png")
        else
            self.state_des:SetText(Localization:GetString("110462"))
            self.image:LoadSprite("Assets/Main/Sprites/UI/UISeasonRobots/UIcompetition_bg_panel01.png")
        end
        
    else
        self.state_des:SetText(Localization:GetString("110461"))
        self.image:LoadSprite("Assets/Main/Sprites/UI/UISeasonRobots/UIcompetition_bg_panel02.png")
    end
end


return  SeasonForceRewardItem