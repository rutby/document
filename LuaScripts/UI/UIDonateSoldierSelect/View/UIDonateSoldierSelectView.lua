local UIDonateSoldierSelectView = BaseClass("UIDonateSoldierSelectView", UIBaseView)
local base = UIBaseView
local DonateSoldierChooseCell = require "UI.UIDonateSoldierSelect.Component.DonateSoldierChooseCell"

-- 页面标题
local view_title_label_path = "UICommonPopUpTitle/bg_mid/titleText"
-- 页面关闭按钮
local view_close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
-- 左侧滑动士兵
local soldier_scroll_view_path = "ImgBg/ScrollView"
-- 提示捐兵无法撤回文字
local soldier_donate_tip_label_path = "ImgBg/RightNode/AttentionNode/AttentionLabel"
-- 自己积分文本1
local self_score_label_1_path = "ImgBg/RightNode/SelfNode/SelfLabel"
-- 自己积分文本2(数值)
local self_score_label_2_path = "ImgBg/RightNode/SelfNode/SelfValueLabel"
-- 自己积分文本3(增加数值)
local self_score_label_3_path = "ImgBg/RightNode/SelfNode/SelfAddValueLabel"
-- 联盟积分文本1
local alliance_score_label_1_path = "ImgBg/RightNode/AllianceNode/AllianceLabel"
-- 联盟积分文本2(数值)
local alliance_score_label_2_path = "ImgBg/RightNode/AllianceNode/AllianceValueLabel"
-- 联盟积分文本3(增加数值)
local alliance_score_label_3_path = "ImgBg/RightNode/AllianceNode/AllianceAddValueLabel"
-- 等级文本1
local level_label_1_path = "ImgBg/RightNode/LevelNode/LevelLabel"
-- 等级文本2
local level_label_2_path = "ImgBg/RightNode/LevelNode/LevelValueLabel"
-- 等级文本3
local level_label_3_path = "ImgBg/RightNode/LevelNode/LevelAddValueLabel"
-- 奖励按钮
local reward_btn_path = "ImgBg/RightNode/RewardNode/RewardBtn"
-- 奖励按钮文字
local reward_btn_label_path = "ImgBg/RightNode/RewardNode/RewardBtnLabel"
-- 捐献按钮
local donate_btn_path = "ImgBg/RightNode/DonateBtn"
-- 捐献按钮文字
local donate_btn_label_path = "ImgBg/RightNode/DonateBtn/BtnBg/DonateBtnText"
--reward红点
local reward_redpt_path = "ImgBg/RightNode/RewardNode/redpt"
local reward_text_path = "ImgBg/RightNode/RewardNode/redpt/RewardText"
--捐满提示
local donate_full_tip_path = "ImgBg/RightNode/DonateFullTip"
--捐满多语言
local full_attention_label_path = "ImgBg/RightNode/DonateFullTip/FullAttentionLabel"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self.donate_full_tip:SetActive(false)
    self.ctrl:InitSoldierData()
    self:SetViewLabelText()
    self:RefreshAddNumLabel()
    self:ReloadScrollView()
    self:CheckRewardRedPt()
end

local function OnDisable(self)

    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.PushArmyInfoEvent, BindCallback(self.OnArmyNumChange))
    self:AddUIListener(EventId.DonateSoldier, BindCallback(self, self.CheckRewardRedPt))
    self:AddUIListener(EventId.ReceiveDonateArmyStageReward, BindCallback(self, self.CheckRewardRedPt))
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.PushArmyInfoEvent,  BindCallback(self.OnArmyNumChange))
    self:RemoveUIListener(EventId.DonateSoldier, BindCallback(self, self.CheckRewardRedPt))
    self:RemoveUIListener(EventId.ReceiveDonateArmyStageReward, BindCallback(self, self.CheckRewardRedPt))
    base.OnRemoveListener(self)
end

local function OnArmyNumChange(self)
    --当士兵数量有推送的时候 要刷新一下界面
    self.ctrl:RefreshCurrMaxSoldier()
    self:ReloadScrollView()
end

local function ComponentDefine(self)
    -- 页面标题
    self.view_title_label = self:AddComponent(UIText, view_title_label_path);
    self.view_title_label:SetLocalText(372782)
    -- 页面关闭按钮
    self.view_close_btn = self:AddComponent(UIButton, view_close_btn_path);
    self.view_close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    -- 左侧滑动士兵
    self.soldier_scroll_view = self:AddComponent(UIScrollView, soldier_scroll_view_path);
    self.soldier_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnDonateSoldierCellMoveIn(itemObj, index)
    end)

    self.soldier_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDonateSoldierCellMoveOut(itemObj, index)
    end)
    -- 提示捐兵无法撤回文字
    self.soldier_donate_tip_label = self:AddComponent(UIText, soldier_donate_tip_label_path);
    self.soldier_donate_tip_label:SetLocalText(372784)
    -- 自己积分文本1
    self.self_score_label_1 = self:AddComponent(UIText, self_score_label_1_path);
    -- 自己积分文本2(数值)
    self.self_score_label_2 = self:AddComponent(UIText, self_score_label_2_path);
    -- 自己积分文本3(增加数值)
    self.self_score_label_3 = self:AddComponent(UIText, self_score_label_3_path);
    -- 联盟积分文本1
    self.alliance_score_label_1 = self:AddComponent(UIText, alliance_score_label_1_path);
    -- 联盟积分文本2(数值)
    self.alliance_score_label_2 = self:AddComponent(UIText, alliance_score_label_2_path);
    -- 联盟积分文本3(增加数值)
    self.alliance_score_label_3 = self:AddComponent(UIText, alliance_score_label_3_path);
    -- 等级文本1
    self.level_label_1 = self:AddComponent(UIText, level_label_1_path);
    -- 等级文本2
    self.level_label_2 = self:AddComponent(UIText, level_label_2_path);
    -- 等级文本3
    self.level_label_3 = self:AddComponent(UIText, level_label_3_path);
    -- 奖励按钮
    self.reward_btn = self:AddComponent(UIButton, reward_btn_path);
    self.reward_btn:SetOnClick(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIDonateSoldierReward)
    end)
    -- 奖励按钮文字
    self.reward_btn_label = self:AddComponent(UIText, reward_btn_label_path);
    self.reward_btn_label:SetLocalText(372781)
    -- 捐献按钮
    self.donate_btn = self:AddComponent(UIButton, donate_btn_path);
    self.donate_btn:SetOnClick(function() 
        self.ctrl:OnDonateBtnClick()
    end)
    -- 捐献按钮文字
    self.donate_btn_label = self:AddComponent(UIText, donate_btn_label_path);
    self.donate_btn_label:SetLocalText(372788)
    self.reward_redpt = self:AddComponent(UIBaseContainer, reward_redpt_path)
    self.reward_text = self:AddComponent(UIText, reward_text_path)
    self.donate_full_tip = self:AddComponent(UIBaseContainer, donate_full_tip_path)
    self.full_attention_label = self:AddComponent(UIText, full_attention_label_path)
    self.full_attention_label:SetLocalText("372836")
end

local function ComponentDestroy(self)
    self.view_title_label = nil
    self.view_close_btn = nil
    self.soldier_scroll_view = nil
    self.soldier_donate_tip_label = nil
    self.self_score_label_1 = nil
    self.self_score_label_2 = nil
    self.self_score_label_3 = nil
    self.alliance_score_label_1 = nil
    self.alliance_score_label_2 = nil
    self.alliance_score_label_3 = nil
    self.level_label_1 = nil
    self.level_label_2 = nil
    self.level_label_3 = nil
    self.reward_btn = nil
    self.reward_btn_label = nil
    self.donate_btn = nil
    self.donate_btn_label =nil
    self.reward_redpt = nil
    self.reward_text = nil
    self.donate_full_tip = nil
    self.full_attention_label = nil

end

local function ReloadScrollView(self)
    self:OnClearScrollCells()
    local soldierList = self.ctrl:GetSoldierList()
    local count = 0
    for _,__ in pairs(soldierList) do
        count = count + 1
    end
    if count == 0 then
        -- 0个兵
        return
    end

    self.soldier_scroll_view:SetTotalCount(count)
    self.soldier_scroll_view:RefillCells()
end

local function OnClearScrollCells(self)
    self.soldier_scroll_view:ClearCells()
    self.soldier_scroll_view:RemoveComponents(DonateSoldierChooseCell)
end

local function OnDonateSoldierCellMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local soldierList = self.ctrl:GetSoldierList()
    local soldierData = soldierList[index]
    local soldierCell = self.soldier_scroll_view:AddComponent(DonateSoldierChooseCell, itemObj)
    soldierCell:InitData(soldierData.armyId, BindCallback(self, self.ReachMaxCheckFunc))
end

local function OnDonateSoldierCellMoveOut(self, itemObj, index)
    self.soldier_scroll_view:RemoveComponent(itemObj.name, DonateSoldierChooseCell);
end

local function SetViewLabelText(self)
    --当前分数和等级
    local currLevel = self.ctrl.GetCurrLevelNum()
    local currPlayerScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(0)
    local currAllianceScore = DataCenter.ActivityDonateSoldierManager:GetScoreNumberByType(1)

    self.alliance_score_label_1:SetLocalText(372786)
    self.alliance_score_label_2:SetText(string.GetFormattedSeperatorNum(currAllianceScore))
    self.self_score_label_1:SetLocalText(372785)
    self.self_score_label_2:SetText(string.GetFormattedSeperatorNum(currPlayerScore))
    self.level_label_1:SetLocalText(372787)
    self.level_label_2:SetText(string.GetFormattedSeperatorNum(currLevel))
end

-- *** warning 勿删勿改名 cell里面有调用 *** --
local function UpdateViewState(self)
    self:RefreshAddNumLabel()
end

local function RefreshAddNumLabel(self)
    local addScore, addLevel = self.ctrl:GetAddScoreAndLevelNum()
    self.self_score_label_3:SetText("+" .. string.GetFormattedSeperatorNum(addScore))
    self.alliance_score_label_3:SetText("+" .. string.GetFormattedSeperatorNum(addScore))
    self.level_label_3:SetText("+" .. string.GetFormattedSeperatorNum(addLevel))
end

--判断红点是否应该显示
local function CheckRewardRedPt(self)
    local canShowRedPtNum = DataCenter.ActivityDonateSoldierManager:GetIsCurrRewardCanReceiveNum()
    if canShowRedPtNum > 0 then
        self.reward_redpt:SetActive(true)
        self.reward_text:SetText(tostring(canShowRedPtNum))
    else
        self.reward_redpt:SetActive(false)
    end
end

local function ReachMaxCheckFunc(self, reachMax)
    if reachMax then
        self.donate_full_tip:SetActive(true)
    else
        self.donate_full_tip:SetActive(false)
    end
end

UIDonateSoldierSelectView.OnCreate = OnCreate
UIDonateSoldierSelectView.OnDestroy = OnDestroy
UIDonateSoldierSelectView.OnEnable = OnEnable
UIDonateSoldierSelectView.OnDisable = OnDisable
UIDonateSoldierSelectView.ComponentDefine = ComponentDefine
UIDonateSoldierSelectView.ComponentDestroy = ComponentDestroy
UIDonateSoldierSelectView.OnClearScrollCells = OnClearScrollCells
UIDonateSoldierSelectView.OnDonateSoldierCellMoveIn = OnDonateSoldierCellMoveIn
UIDonateSoldierSelectView.OnDonateSoldierCellMoveOut = OnDonateSoldierCellMoveOut
UIDonateSoldierSelectView.ReloadScrollView = ReloadScrollView
UIDonateSoldierSelectView.OnAddListener = OnAddListener
UIDonateSoldierSelectView.OnRemoveListener = OnRemoveListener
UIDonateSoldierSelectView.OnArmyNumChange = OnArmyNumChange
UIDonateSoldierSelectView.SetViewLabelText = SetViewLabelText
UIDonateSoldierSelectView.UpdateViewState = UpdateViewState
UIDonateSoldierSelectView.RefreshAddNumLabel = RefreshAddNumLabel
UIDonateSoldierSelectView.CheckRewardRedPt = CheckRewardRedPt
UIDonateSoldierSelectView.ReachMaxCheckFunc = ReachMaxCheckFunc


return UIDonateSoldierSelectView