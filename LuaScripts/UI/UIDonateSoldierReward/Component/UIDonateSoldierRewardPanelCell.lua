local UIDonateSoldierRewardPanelCell = BaseClass("UIDonateSoldierRewardPanelCell", UIBaseContainer)
local base = UIBaseContainer
local UIDonateSoldierRewardPanelItemCell = require "UI.UIDonateSoldierReward.Component.UIDonateSoldierRewardPanelItemCell"


-- 联盟贡献label
local alliance_donate_power_label_path = "cellContent/AllianceDonatePower"
-- 个人贡献label
local player_donate_power_label_path = "cellContent/PlayerDonatePower"
-- 普通奖励cell
local normal_reward_content_path = "cellContent/NormalRewardContent"
-- 进阶奖励cell
local advance_reward_content_path = "cellContent/AdvanceRewardContent"
-- 普通奖励按钮
local normal_reward_click_btn_path = "cellContent/NormalCollectBtn"
-- 进阶奖励按钮
local advance_reward_click_btn_path = "cellContent/AdvanceCollectBtn"
-- local black_cover_path = "BlackCover"
local alliance_not_enough_path = "cellContent/AllianceNotEnough"
local alliance_not_enough_label_0_path = "cellContent/AllianceNotEnough/AllianceDonatePower1"
local alliance_not_enough_label_1_path = "cellContent/AllianceNotEnough/AllianceDonatePower2"
local player_not_enough_path = "cellContent/PlayerNotEnough"
local player_not_enough_label_0_path = "cellContent/PlayerNotEnough/PlayerDonatePower1"
local player_not_enough_label_1_path = "cellContent/PlayerNotEnough/PlayerDonatePower2"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self.dataInfo = {}
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ReceiveDonateArmyStageReward, BindCallback(self, self.OnReceiveDonateSoldierReward))
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.ReceiveDonateArmyStageReward, BindCallback(self, self.OnReceiveDonateSoldierReward))
    base.OnRemoveListener(self)
end

local function ComponentDefine(self)
    self.alliance_donate_power_label = self:AddComponent(UIText, alliance_donate_power_label_path)
    self.player_donate_power_label = self:AddComponent(UIText, player_donate_power_label_path)
    self.normal_reward_content = self:AddComponent(UIBaseContainer, normal_reward_content_path)
    self.advance_reward_content = self:AddComponent(UIBaseContainer, advance_reward_content_path)
    self.normal_reward_click_btn = self:AddComponent(UIButton, normal_reward_click_btn_path)
    self.normal_reward_click_btn:SetOnClick(function()
        self:OnRewardBtnClick(1)
    end)
    self.advance_reward_click_btn = self:AddComponent(UIButton, advance_reward_click_btn_path)
    self.advance_reward_click_btn:SetOnClick(function()
        self:OnRewardBtnClick(2)
    end)
    -- self.black_cover = self:AddComponent(UIBaseContainer, black_cover_path)
    self.alliance_not_enough = self:AddComponent(UIBaseContainer, alliance_not_enough_path)
    self.alliance_not_enough_label_0 = self:AddComponent(UIText, alliance_not_enough_label_0_path)
    self.alliance_not_enough_label_1 = self:AddComponent(UIText, alliance_not_enough_label_1_path)
    self.player_not_enough = self:AddComponent(UIBaseContainer, player_not_enough_path)
    self.player_not_enough_label_0 = self:AddComponent(UIText, player_not_enough_label_0_path)
    self.player_not_enough_label_1 = self:AddComponent(UIText, player_not_enough_label_1_path)
end

local function ComponentDestroy(self)
    self.alliance_donate_power_label = nil
    self.player_donate_power_label = nil
    self.normal_reward_content = nil
    self.advance_reward_content = nil
    self.normal_reward_click_btn = nil
    self.advance_reward_click_btn = nil
    self.alliance_not_enough = nil
    self.alliance_not_enough_label_0 = nil
    self.alliance_not_enough_label_1 = nil
    self.player_not_enough = nil
    self.player_not_enough_label_0 = nil
    self.player_not_enough_label_1 = nil
end

local function SetData(self, info)
    Logger.Log(tostring(info))
    self.dataInfo = info

    local selfScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(0)
    local allianceScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(1)

    local reachScore = true
    if self.dataInfo.needUserScore > selfScore or self.dataInfo.needAllianceScore > allianceScore then
        -- 未达到领取条件
        reachScore = false
    end
    
    self.alliance_donate_power_label:SetText(tostring(self.dataInfo.needAllianceScore))
    self.player_donate_power_label:SetText(tostring(self.dataInfo.needUserScore))
    --普通奖励遮罩 不可领取和已领取都显示
    local normalShowMask = self.dataInfo.normalState ~= 0 or not reachScore
    --普通奖励特效 可领取(达到分数并且没有领取)时显示
    local normalShowEffect = self.dataInfo.normalState == 0 and reachScore
    --普通奖励已领取标志 （已领取时显示）
    local normalShowCheckmark = self.dataInfo.normalState ~= 0

    self:AddRewardItem(self.dataInfo.normalReward, self.normal_reward_content,  normalShowMask, normalShowEffect, normalShowCheckmark)


    -- 进阶奖励遮罩 不可领取和已领取都显示
    local advanceShowMask = self.dataInfo.specialState ~= 0 or not reachScore
    -- 进阶奖励特效 不显示
    local advanceShowEffect = false
    --进阶奖励领取标志 已领取时显示
    local advanceShowCheckmark = self.dataInfo.specialState ~= 0 

    self:AddRewardItem(self.dataInfo.specialReward, self.advance_reward_content,advanceShowMask, advanceShowEffect, advanceShowCheckmark)
    self:RefreshClickState()

    -- 是否可以领取
    local selfScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(0)
    local allianceScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(1)

    if self.dataInfo.needUserScore > selfScore or self.dataInfo.needAllianceScore > allianceScore then
        -- 未达到领取条件
        -- self.black_cover:SetActive(true)
        if self.dataInfo.needUserScore > selfScore then
            --自己分数未达到
            self.player_not_enough:SetActive(true)
            self.player_not_enough_label_0:SetText(string.GetFormattedSeperatorNum(selfScore))
            self.player_not_enough_label_1:SetText(string.GetFormattedSeperatorNum(self.dataInfo.needUserScore))
            self.player_donate_power_label:SetActive(false)
        else
            self.player_not_enough:SetActive(false)
            self.player_donate_power_label:SetActive(true)
        end

        if self.dataInfo.needAllianceScore > allianceScore then
            --联盟分数未达到
            self.alliance_not_enough:SetActive(true)
            self.alliance_not_enough_label_0:SetText(string.GetFormattedSeperatorNum(allianceScore))
            self.alliance_not_enough_label_1:SetText(string.GetFormattedSeperatorNum(self.dataInfo.needAllianceScore))
            self.alliance_donate_power_label:SetActive(false)
        else
            self.alliance_not_enough:SetActive(false)
            self.alliance_donate_power_label:SetActive(true)
        end
    else
        self.player_not_enough:SetActive(false)
        self.alliance_not_enough:SetActive(false)
        self.player_donate_power_label:SetActive(true)
        self.player_donate_power_label:SetText(string.GetFormattedSeperatorNum(self.dataInfo.needUserScore))
        self.alliance_donate_power_label:SetActive(true)
        self.alliance_donate_power_label:SetText(string.GetFormattedSeperatorNum(self.dataInfo.needAllianceScore))
    end
end

local function AddRewardItem(self, reward, parent, showMask, showEffect, showCheckmark)
    parent:RemoveComponents(UIDonateSoldierRewardPanelItemCell)
    parent:DestroyChildNode()
    -- 
    for i, v in pairs(reward) do
        if not string.IsNullOrEmpty(v) then
            self:GameObjectInstantiateAsync(UIAssets.DonateSoldierRewardItemCover, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(parent.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local resComp = parent:AddComponent(UIDonateSoldierRewardPanelItemCell, nameStr)
                local param = {}
                param.rewardType = RewardType.GOODS-- v.rewardType
                param.itemId = tonumber(v.value.id)-- rewardParam.itemId
                param.count = v.value.num
                resComp:SetData(param, showMask, showEffect, showCheckmark)
            end)
        end
    end
end

local function OnReceiveDonateSoldierReward(self)
    local selfScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(0)
    local allianceScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(1)

    local reachScore = true
    if self.dataInfo.needUserScore > selfScore or self.dataInfo.needAllianceScore > allianceScore then
        -- 未达到领取条件
        reachScore = false
    end
    
    -- 重新添加奖励cell
    --普通奖励遮罩 不可领取和已领取都显示
    local normalShowMask = self.dataInfo.normalState ~= 0 or not reachScore
    --普通奖励特效 可领取(达到分数并且没有领取)时显示
    local normalShowEffect = self.dataInfo.normalState == 0 and reachScore
    --普通奖励已领取标志 （已领取时显示）
    local normalShowCheckmark = self.dataInfo.normalState ~= 0
    self:AddRewardItem(self.dataInfo.normalReward, self.normal_reward_content, normalShowMask, normalShowEffect, normalShowCheckmark)

    -- 进阶奖励遮罩 只有已领取的时候显示
    local advanceShowMask = self.dataInfo.specialState ~= 0  or not reachScore
    -- 进阶奖励特效 不显示
    local advanceShowEffect = false
    --进阶奖励领取标志 已领取时显示
    local advanceShowCheckmark = self.dataInfo.specialState ~= 0 

    self:AddRewardItem(self.dataInfo.specialReward, self.advance_reward_content, advanceShowMask, advanceShowEffect, advanceShowCheckmark)
    -- 刷新奖励cell点击
    self:RefreshClickState()
end

local function RefreshClickState(self)
    local selfScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(0)
    local allianceScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(1)

    local reachScore = true
    if self.dataInfo.needUserScore > selfScore or self.dataInfo.needAllianceScore > allianceScore then
        -- 未达到领取条件
        reachScore = false
    end
    
    self.normal_reward_click_btn:SetActive(self.dataInfo.normalState == 0 and reachScore)
    self.advance_reward_click_btn:SetActive(self.dataInfo.specialState == 0)--and reachScore and advanceItemEnough)
end

local function OnRewardBtnClick(self, type)
    -- 判断是否可以领取当前奖励
    local selfScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(0)
    local allianceScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(1)

    if type == 1 then
        if self.dataInfo.needUserScore > selfScore or self.dataInfo.needAllianceScore > allianceScore then
            -- 未达到领取条件
            return
        end
        DataCenter.ActivityDonateSoldierManager:OnReceiveStageReward(type, {self.dataInfo.id})
    elseif type == 2 then
        local scoreReach = true
        if self.dataInfo.needUserScore > selfScore or self.dataInfo.needAllianceScore > allianceScore then
            -- 未达到领取条件
            scoreReach = false
        end

        UIManager.Instance:OpenWindow(UIWindowNames.UIDonateSoldierOpenReward, {anim = true}, {{self.dataInfo}, scoreReach})
    end
end

UIDonateSoldierRewardPanelCell.OnCreate = OnCreate
UIDonateSoldierRewardPanelCell.OnDestroy = OnDestroy
UIDonateSoldierRewardPanelCell.OnEnable = OnEnable
UIDonateSoldierRewardPanelCell.OnDisable = OnDisable
UIDonateSoldierRewardPanelCell.OnAddListener = OnAddListener
UIDonateSoldierRewardPanelCell.OnRemoveListener = OnRemoveListener
UIDonateSoldierRewardPanelCell.ComponentDefine = ComponentDefine
UIDonateSoldierRewardPanelCell.ComponentDestroy = ComponentDestroy
UIDonateSoldierRewardPanelCell.SetData = SetData
UIDonateSoldierRewardPanelCell.AddRewardItem = AddRewardItem
UIDonateSoldierRewardPanelCell.OnReceiveDonateSoldierReward = OnReceiveDonateSoldierReward
UIDonateSoldierRewardPanelCell.RefreshClickState = RefreshClickState
UIDonateSoldierRewardPanelCell.OnRewardBtnClick = OnRewardBtnClick

return UIDonateSoldierRewardPanelCell