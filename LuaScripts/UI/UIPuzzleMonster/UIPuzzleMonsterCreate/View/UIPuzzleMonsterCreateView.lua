--- Created by shimin
--- DateTime: 2023/9/25 17:43
---

local UIPuzzleMonsterCreateView = BaseClass("UIPuzzleMonsterCreateView",UIBaseView)
local UIPuzzleMonsterCreateCell = require "UI.UIPuzzleMonster.UIPuzzleMonsterCreate.Component.UIPuzzleMonsterCreateCell"
local PuzzleRewardInfo = require "UI.UIPuzzleMonster.UIPuzzleMonsterCreate.Component.PuzzleRewardInfo"
local base = UIBaseView

local txt_title_path ="UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local scroll_path = "ImgBg/ScrollView"
local reward_content_path = "DetectEventInfoGo"
local trigger_path = "trigger"

function UIPuzzleMonsterCreateView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIPuzzleMonsterCreateView:ComponentDefine()
    self.txt_title = self:AddComponent(UIText, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.event_trigger = self:AddComponent(UIEventTrigger, trigger_path)
    self.event_trigger:OnPointerUp(function(eventData)
        self:HideRewardList()
    end)
    self.rewardInfoPanel = nil
end

function UIPuzzleMonsterCreateView:ComponentDestroy()
    self:HideRewardList()
end

function UIPuzzleMonsterCreateView:DataDefine()
    self.showDatalist ={}
 
end

function UIPuzzleMonsterCreateView:DataDestroy()
end

function UIPuzzleMonsterCreateView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPuzzleMonsterCreateView:OnEnable()
    base.OnEnable(self)
end

function UIPuzzleMonsterCreateView:OnDisable()
    base.OnDisable(self)
end

function UIPuzzleMonsterCreateView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnPuzzleMonsterDataRefresh, self.RefreshList)
end

function UIPuzzleMonsterCreateView:OnRemoveListener()
    self:RemoveUIListener(EventId.OnPuzzleMonsterDataRefresh, self.RefreshList)
    base.OnRemoveListener(self)
end

function UIPuzzleMonsterCreateView:ReInit()
    self.puzzleType = self:GetUserData()
    self:HideRewardList()
    self.txt_title:SetLocalText(372246)
    if self.puzzleType == PuzzleMonsterType.Activity then
        DataCenter.ActivityPuzzleDataManager:SendGetPuzzleBossMarch()
    else
        
    end
    self:RefreshList()
end

function UIPuzzleMonsterCreateView:RefreshList()
    self:ClearScroll()
    self.showDatalist = self.ctrl:GetPanelData(self.puzzleType)
    local count = #self.showDatalist
    if count > 0 then
        self.ScrollView:SetTotalCount(count)
        self.ScrollView:RefillCells()
    end
end

function UIPuzzleMonsterCreateView:ClearScroll()
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(UIPuzzleMonsterCreateCell)
    self.showDatalist = {}
end

function UIPuzzleMonsterCreateView:OnItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(UIPuzzleMonsterCreateCell, itemObj)
    cellItem:SetItemShow(self.showDatalist[index])
end

function UIPuzzleMonsterCreateView:OnItemMoveOut(itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, UIPuzzleMonsterCreateCell)
end

function UIPuzzleMonsterCreateView:ShowRewardInfo(rewardList, pos, isLeftArrow)
    if self.rewardInfoPanel == nil then
        self.rewardInfoPanel = self:AddComponent(PuzzleRewardInfo, reward_content_path)
    end
    self.rewardInfoPanel:SetData(rewardList, pos, isLeftArrow)
    self.rewardInfoPanel:SetActive(true)
    self.event_trigger:SetActive(true)
end

function UIPuzzleMonsterCreateView:HideRewardList()
    self.event_trigger:SetActive(false)
    if self.rewardInfoPanel ~= nil then
        self.rewardInfoPanel:SetActive(false)
    end
end

return UIPuzzleMonsterCreateView