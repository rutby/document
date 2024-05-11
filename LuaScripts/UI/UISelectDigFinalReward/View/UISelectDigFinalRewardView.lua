---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---UISelectDigFinalRewardView.lua

local base = UIBaseView--Variable
local UISelectDigFinalRewardView = BaseClass("UISelectDigFinalRewardView", base)--Variable
local Localization = CS.GameEntry.Localization
local SelectDigFinalRewardItem = require "UI.UISelectDigFinalReward.Component.SelectDigFinalRewardItem"

local RewardType = {
    NormalReward = 1,
    SuperReward = 2,
}

local title_path = "ImgBg/titleText"
local closeBtn_path = "ImgBg/CloseBtn"
local toggle_path = "ImgBg/Tab/Toggle"
local confirmBtn_path = "ImgBg/Container/confirmBtn"
local confirmBtnTxt_path = "ImgBg/Container/confirmBtn/confirmTxt"
local svRewards_path = "ImgBg/Container/svRewards"
local content_path = "ImgBg/Container/svRewards/Content"
local selectTip_path = "ImgBg/Container/selectTip"

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:Init()
end

local function OnDestroy(self)
    self:ClearItemCell()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.titleN:SetLocalText(372229)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.togglesTbN = {}
    for i = 1, 2 do
        local tempPath = toggle_path .. i
        local tog = self:AddComponent(UIToggle, tempPath)
        tog:SetOnValueChanged(function(tf)
        if tf then
            self:ChangeShowType(i)
        end
    end)
        local newTog = {}
        newTog.toggleN = tog
        newTog.chooseN = tog:AddComponent(UIBaseContainer, "Choose")
        local notChooseTxtN = tog:AddComponent(UITextMeshProUGUIEx, "notChoose")
        local chooseTxtN = tog:AddComponent(UITextMeshProUGUIEx, "Choose/chooseTxt")
        local strTxt = i == RewardType.NormalReward and 372444 or 372445
        notChooseTxtN:SetLocalText(strTxt)
        chooseTxtN:SetLocalText(strTxt)
        newTog.tabType = i
        table.insert(self.togglesTbN, newTog)
    end
    self.svRewardsN = self:AddComponent(UIBaseContainer, svRewards_path)
    self.contentN = self:AddComponent(GridInfinityScrollView, content_path)
    local bindFunc1 = BindCallback(self, self.OnInitScroll)
    local bindFunc2 = BindCallback(self, self.OnUpdateScroll)
    local bindFunc3 = BindCallback(self, self.OnDestroyScrollItem)
    self.contentN:Init(bindFunc1,bindFunc2, bindFunc3)
    self.confirmBtnN = self:AddComponent(UIButton, confirmBtn_path)
    self.confirmBtnN:SetOnClick(function()
        self:OnClickConfirmBtn()
    end)
    self.confirmBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, confirmBtnTxt_path)
    self.confirmBtnTxtN:SetLocalText(110006)
    self.selectTipN = self:AddComponent(UITextMeshProUGUIEx, selectTip_path)
end

local function ComponentDestroy(self)
    self.titleN = nil
    self.closeBtnN = nil
    self.togglesTbN = nil
    self.svRewardsN = nil
    self.contentN = nil
    self.confirmBtnN = nil
end

local function DataDefine(self)
    self.listGO = {}
    self.curTogType = nil
    self.curSelectedIndex = nil
    self.curRewardsList = nil
    self.targetRewardType = nil
end

local function DataDestroy(self)
    self.listGO = nil
    self.curTogType = nil
    self.curSelectedIndex = nil
    self.curRewardsList = nil
    self.targetRewardType = nil
end


local function Init(self)
    self.activityId = self:GetUserData()
    self.digInfo = DataCenter.DigActivityManager:GetDigInfo(self.activityId)
    
    local tempIndex, isSuperLv = DataCenter.DigActivityManager:GetSelectedFinalRewardInfo(self.activityId, self.digInfo.finishedLv + 1)
    self.curSelectedIndex = tempIndex
    self.targetRewardType = isSuperLv and RewardType.SuperReward or RewardType.NormalReward
    
    self.normalFinalRewards, self.superFinalRewards = DataCenter.DigActivityManager:GetFinalRewards(self.activityId)
    
    self:ChangeShowType(self.targetRewardType)
end

local function ChangeShowType(self, tempType)
    if self.curTogType ~= tempType then
        self.curTogType = tempType
        for i, v in ipairs(self.togglesTbN) do
            local iType = self.togglesTbN[i].tabType
            self.togglesTbN[i].chooseN:SetActive(iType == tempType)
        end
        self:RefreshAll()
    end
end

local function RefreshAll(self)
    --local strTitle = self.curTogType == RewardType.NormalReward  and 372444 or 372445
    --self.titleN:SetLocalText(strTitle)
    local canSelect = self:CheckIfCanSelect()
    if canSelect then
        self.confirmBtnN:SetActive(true)
        self.selectTipN:SetActive(false)
    else
        self.confirmBtnN:SetActive(false)
        self.selectTipN:SetActive(true)
        self.selectTipN:SetLocalText(self.targetRewardType == RewardType.SuperReward and 372447 or 372446)
    end
    
    self.curRewardsList = self.curTogType == RewardType.NormalReward and self.normalFinalRewards or self.superFinalRewards
    self.contentN:SetItemCount(#self.curRewardsList)
end

local function GetFinalRewardGotTimes(self, index)
    local isSuperLv = self.curTogType == RewardType.SuperReward
    return DataCenter.DigActivityManager:GetFinalRewardGotTimes(self.activityId, isSuperLv, index)
end

local function SelectReward(self, tempIndex)
    self.curSelectedIndex = tempIndex
    for i, v in pairs(self.listGO) do
        if v then
            v:SetAsSelected(tempIndex)
        end
    end
end


local function OnInitScroll(self,go,index)
    local item = self.svRewardsN:AddComponent(SelectDigFinalRewardItem, go)
    self.listGO[go] = item
end

local function OnUpdateScroll(self,go,index)
    go.name = tostring(index)
    local cellItem = self.listGO[go]
    if not cellItem then
        return
    end
    local luaIndex = index + 1
    cellItem:SetItem(self.curRewardsList[luaIndex], luaIndex, self.curSelectedIndex)
end

local function OnDestroyScrollItem(self,go, index)

end

local function ClearItemCell(self)
    self.svRewardsN:RemoveComponents(SelectDigFinalRewardItem)
    self.contentN:DestroyChildNode()
end

local function CheckIfCanSelect(self)
    return self.curTogType == self.targetRewardType
end

local function OnClickConfirmBtn(self)
    if not self.curSelectedIndex or self.curSelectedIndex == 0 then
        UIUtil.ShowTips(Localization:GetString("372449"))
        return
    end
    DataCenter.DigActivityManager:RequestSelectFinalReward(self.activityId, self.curSelectedIndex)
    self.ctrl:CloseSelf()
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end


UISelectDigFinalRewardView.OnCreate = OnCreate 
UISelectDigFinalRewardView.OnDestroy = OnDestroy
--UISelectDigFinalRewardView.OnAddListener = OnAddListener
--UISelectDigFinalRewardView.OnRemoveListener = OnRemoveListener
UISelectDigFinalRewardView.ComponentDefine = ComponentDefine
UISelectDigFinalRewardView.ComponentDestroy = ComponentDestroy
UISelectDigFinalRewardView.DataDefine = DataDefine
UISelectDigFinalRewardView.DataDestroy = DataDestroy

UISelectDigFinalRewardView.Init = Init
UISelectDigFinalRewardView.RefreshAll = RefreshAll
UISelectDigFinalRewardView.GetFinalRewardGotTimes = GetFinalRewardGotTimes
UISelectDigFinalRewardView.SelectReward = SelectReward
UISelectDigFinalRewardView.OnInitScroll = OnInitScroll
UISelectDigFinalRewardView.OnUpdateScroll = OnUpdateScroll
UISelectDigFinalRewardView.OnDestroyScrollItem = OnDestroyScrollItem
UISelectDigFinalRewardView.ClearItemCell = ClearItemCell
UISelectDigFinalRewardView.ChangeShowType = ChangeShowType
UISelectDigFinalRewardView.CheckIfCanSelect = CheckIfCanSelect
UISelectDigFinalRewardView.OnClickConfirmBtn = OnClickConfirmBtn
UISelectDigFinalRewardView.OnClickCloseBtn = OnClickCloseBtn

return UISelectDigFinalRewardView