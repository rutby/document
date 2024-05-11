

local UIOfflineRewardPanelView = BaseClass("UIOfflineRewardPanelView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local RewardItem = require "UI.UIOfflineRewardPanel.Comp.RewardItem"

local bgCloseBtn_path = "BgCloseBtn"
local offlineTxt_path = "Bg/offlineTxt"
local maxTimeTxt_path = "Bg/BarPart/ProgressBar/maxTimeText"
local timeSlider_path = "Bg/BarPart/ProgressBar"
local timeTxt_path = "Bg/BarPart/ProgressBar/SlideArea/Tip/Image/timeTxt"
local desTxt_path = "Bg/DesText"
local desTitle_path = "Bg/DesTitle"
local scrollView_path = "Bg/ScrollView"
local confirmBtn_path = "Bg/ConfirmBtn"
local confirmTxt_path = "Bg/ConfirmBtn/confirmTxt"
local titleTxt_path = "Bg/titleTxt"

--创建
function UIOfflineRewardPanelView : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:RefreshAll()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Offline_Reward)
end

-- 销毁
function UIOfflineRewardPanelView : OnDestroy()
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIOfflineRewardPanelView : ComponentDefine()
    self.bgCloseBtn = self:AddComponent(UIButton, bgCloseBtn_path)
    self.bgCloseBtn:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.offlineTxt = self:AddComponent(UITextMeshProUGUIEx, offlineTxt_path)
    self.offlineTxt:SetLocalText(441007)
    self.maxTimeTxt = self:AddComponent(UITextMeshProUGUIEx, maxTimeTxt_path)
    local str = nil
    local maxRealTime = self.maxTime*3600*1000
    if self.param.offlineTime<maxRealTime then
        str = UITimeManager:GetInstance():MilliSecondToFmtString(self.param.offlineTime)
    else
        str = Localization:GetString("150072").." "..UITimeManager:GetInstance():MilliSecondToFmtString(maxRealTime)
    end
    self.maxTimeTxt:SetText(str)
    self.timeSlider = self:AddComponent(UISlider, timeSlider_path)
    self.timeSlider:SetValue(self.param.offlineTime / 1000 / 3600 / self.maxTime)
    self.timeTxt = self:AddComponent(UITextMeshProUGUIEx, timeTxt_path)
    self.timeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.param.offlineTime))
    self.desTitle = self:AddComponent(UITextMeshProUGUIEx, desTitle_path)
    self.desTitle:SetLocalText(441061)
    self.desTxt = self:AddComponent(UITextMeshProUGUIEx, desTxt_path)
    self.desTxt:SetText(Localization:GetString("441008", self.maxTime))
    self.scrollView = self:AddComponent(UIScrollView, scrollView_path)
    self.scrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.confirmBtn = self:AddComponent(UIButton, confirmBtn_path)
    self.confirmBtn:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.confirmTxt = self:AddComponent(UITextMeshProUGUIEx, confirmTxt_path)
    self.confirmTxt:SetLocalText(110006)
    self.titleTxt = self:AddComponent(UITextMeshProUGUIEx, titleTxt_path)
    self.titleTxt:SetLocalText(441006)
end

function UIOfflineRewardPanelView : ComponentDestroy()

end

function UIOfflineRewardPanelView : DataDefine()
    self.itemInfoList = {}
    self.maxTime = tonumber(LuaEntry.DataConfig:TryGetNum("people_work_config", "k9")) / 3600
    self.param = self:GetUserData()
end

function UIOfflineRewardPanelView : DataDestroy()
    self.param = nil
    self.itemInfoList = nil
end

function UIOfflineRewardPanelView : RefreshAll()
    self:RefreshScrollView()
end

function UIOfflineRewardPanelView : RefreshScrollView()
    self:ClearScroll()
    
    self.itemInfoList = {}
    for _, v in ipairs(self.param.resourceArr) do
        if v.rt ~= ResourceType.Meal then
            table.insert(self.itemInfoList, v)
        end
    end
    if self.itemInfoList then
        local count = #self.itemInfoList
        if count > 0 then
            self.scrollView:SetTotalCount(count)
            self.scrollView:RefillCells()
        end
    end
end

function UIOfflineRewardPanelView : OnItemMoveIn(itemObj, index)
    itemObj.name = index
    local item = self.scrollView:AddComponent(RewardItem, itemObj)
    item:SetData(self.itemInfoList[index])
end

function UIOfflineRewardPanelView : OnItemMoveOut(itemObj, index)
    self.scrollView:RemoveComponent(itemObj.name, RewardItem)
end

function UIOfflineRewardPanelView : ClearScroll()
    self.scrollView:ClearCells()
    self.scrollView:RemoveComponents(RewardItem)
end

function UIOfflineRewardPanelView : OnClickCloseBtn()
    self.ctrl:CloseSelf()
end

return UIOfflineRewardPanelView