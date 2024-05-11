
local UIMiningSpeedUpView = BaseClass("UIMiningSpeedUpView", UIBaseView)
local base = UIBaseView
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local slider_path = "Bg/ProcessRoot/Slider"
local miningCarImg_path = "Bg/ProcessRoot/miningCarImg"
local score_txt_path = "Bg/ProcessRoot/Rect_BtnScoreBg/Txt_Score"
local leftTimeTxt_path = "Bg/ProcessRoot/leftTimeTxt"
local speedUpItem_path = "Bg/UIResourceBagCell/speedUpItem"
local des1Txt_path = "Bg/UIResourceBagCell/des1Txt"
local des2Txt_path = "Bg/UIResourceBagCell/des2Txt"
local useBtn_path = "Bg/UIResourceBagCell/useBtn"
local useTxt_path = "Bg/UIResourceBagCell/useBtn/useTxt"
local getBtn_path = "Bg/UIResourceBagCell/getBtn"
local getTxt_path = "Bg/UIResourceBagCell/getBtn/getTxt"
local moreBtn_path = "Bg/UIResourceBagCell/MoreBtn"
local useCountBtn_path = "Bg/UIResourceBagCell/MoreBtn/UseCountBtn"
local useCountBtnName_path = "Bg/UIResourceBagCell/MoreBtn/UseCountBtn/UseCountBtnName"
local panelBtn_path = "UICommonPopUpTitle/panel"

function UIMiningSpeedUpView : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIMiningSpeedUpView : OnDestroy()
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIMiningSpeedUpView : OnEnable()
    base.OnEnable(self)
    local param = self:GetUserData()
    self.activityId = tonumber(param.activityId)
	self.carId = tonumber(param.carId)
    self.speedUpItemId = tonumber(param.speedUpItemId)
    self.queueId = tonumber(param.queueId)
    self.remainTime = tonumber(param.remainTime)
    self.costTime = tonumber(param.costTime)
    self.speedUpTime = DataCenter.MiningManager:GetSpeedUpTime(self.activityId) * 1000

    local itemData = DataCenter.ItemData:GetItemById(self.speedUpItemId)
	if itemData then
		self.speedUpItemUuid = itemData.uuid
	end
    self:RefreshView()
end

function UIMiningSpeedUpView : DataDefine()
    self.speedUpTime = 1
end

function UIMiningSpeedUpView : DataDestroy()
    self.speedUpTime = nil
end

function UIMiningSpeedUpView : ComponentDestroy()

end

function UIMiningSpeedUpView : ComponentDefine()
    self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.panelBtn = self:AddComponent(UIButton, panelBtn_path)
    self.panelBtn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.leftTimeTxt = self:AddComponent(UIText, leftTimeTxt_path)
    self.miningCarImg = self:AddComponent(UIImage, miningCarImg_path)
    self.speedUpItem = self:AddComponent(UICommonItem, speedUpItem_path)
    self.des1Txt = self:AddComponent(UIText, des1Txt_path)
    self.des2Txt = self:AddComponent(UIText, des2Txt_path)
    self.useBtn = self:AddComponent(UIButton, useBtn_path)
    self.useBtn:SetOnClick(function()
        self:OnClickUseBtn()
    end)
    self.useTxt = self:AddComponent(UIText, useTxt_path)
    self.useTxt:SetLocalText(110046)
    self.getBtn = self:AddComponent(UIButton, getBtn_path)
    self.getBtn:SetOnClick(function()
        self.ctrl:OnClickGetBtn(self.speedUpItemId)
    end)
    self.getTxt = self:AddComponent(UIText, getTxt_path)
    self.getTxt:SetLocalText(100547)
    
    self.moreBtnN = self:AddComponent(UIBaseContainer, moreBtn_path)
    self.moreBtnN:SetActive(false)
    self.useCountBtn = self:AddComponent(UIButton, useCountBtn_path)
    self.useCountBtnName = self:AddComponent(UITextMeshProUGUIEx, useCountBtnName_path)
    self.useCountBtn:SetOnClick(function()
        self:OnClickUseCountBtn()
    end)
    
    self._score_txt = self:AddComponent(UIText,score_txt_path)
end

function UIMiningSpeedUpView : RefreshView()
    local name = DataCenter.ItemTemplateManager:GetName(self.speedUpItemId)
    self.des1Txt:SetText(name)
    local des = DataCenter.ItemTemplateManager:GetDes(self.speedUpItemId)
    self.des2Txt:SetText(des)
    
    self._score_txt:SetText(DataCenter.MiningManager:GetMiningCarScore(self.carId))
    
    local lineData = LocalController:instance():getLine("activity_mining_para", self.carId)
    local icon = string.format(LoadPath.UIMiningCarImg, lineData:getValue("reward_icon"))
    self.miningCarImg:LoadSprite(icon)
    
    local speedUpItemInfo = {}
    speedUpItemInfo.rewardType = RewardType.GOODS
    speedUpItemInfo.itemId = self.speedUpItemId
    speedUpItemInfo.count = DataCenter.ItemData:GetItemCount(self.speedUpItemId)
    self.speedUpItem:ReInit(speedUpItemInfo)
    
    local speedUpItemCount = DataCenter.ItemData:GetItemCount(self.speedUpItemId)
    self.useBtn:SetActive(speedUpItemCount > 0)
    self.getBtn:SetActive(speedUpItemCount <= 0)
    
    if (self.moreBtnN:GetActive()) then
        local count = math.floor( self.remainTime / self.speedUpTime)
        local itemCount = DataCenter.ItemData:GetItemCount(self.speedUpItemId)
        local useItemCount = math.min(count, itemCount)
        if useItemCount <= 0 then
            self.moreBtnN:SetActive(false)
        else
            self.useCountBtnName:SetText("x"..tostring(useItemCount))
        end
    end
    
    self:AddCountDownTimer()
end

function UIMiningSpeedUpView : AddCountDownTimer()
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false, false, false)
        self.countDownTimer:Start()
        self:RefreshRemainTime()
    end
end

function UIMiningSpeedUpView : RefreshRemainTime()
    local remainTime = self.remainTime
    if remainTime >= 0 then
        self.leftTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
        self.remainTime = self.remainTime - 1000
        self.slider:SetValue((self.costTime - self.remainTime) / self.costTime)
    else
        self.leftTimeTxt:SetText("")
        self.slider:SetValue(1)
        self.ctrl:CloseSelf()
    end
end

function UIMiningSpeedUpView : DelCountDownTimer()
    self.CountDownTimerAction = nil
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

function UIMiningSpeedUpView : OnMiningQueueSpeedUp()
    --local speedUpTime = DataCenter.MiningManager:GetSpeedUpTime(self.activityId)
    self.remainTime = self.remainTime - self.speedUpTime * self.useItemCount
    if self.remainTime <= 0 then
        self.ctrl:CloseSelf()
    else
		self.leftTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.remainTime))
		self.slider:SetValue((self.costTime - self.remainTime) / self.costTime)
        if (self.moreBtnN:GetActive()) then
            local count = math.floor( self.remainTime / self.speedUpTime)
            local itemCount = DataCenter.ItemData:GetItemCount(self.speedUpItemId)
            self.useItemCount = math.min(count, itemCount)
            if self.useItemCount <= 0 then
                self.moreBtnN:SetActive(false)
            else
                self.useCountBtnName:SetText("x"..tostring(self.useItemCount))
            end
        end
    end
end

function UIMiningSpeedUpView : OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.MiningQueueSpeedUp, self.OnMiningQueueSpeedUp)
    self:AddUIListener(EventId.RefreshItems, self.RefreshView)
end

function UIMiningSpeedUpView : OnRemoveListener()
    self:RemoveUIListener(EventId.MiningQueueSpeedUp, self.OnMiningQueueSpeedUp)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshView)

    base.OnRemoveListener(self)
end

function UIMiningSpeedUpView : OnClickUseBtn()
    if (not self.moreBtnN:GetActive()) then
        local count = math.floor( self.remainTime / self.speedUpTime)
        local itemCount = DataCenter.ItemData:GetItemCount(self.speedUpItemId)
        self.useItemCount = math.min(count, itemCount)
        if self.useItemCount <= 0 then
            self.useItemCount = 1
            self.ctrl:OnClickUseBtn(self.speedUpItemUuid, self.activityId, self.queueId, 1)
        else
            self.moreBtnN:SetActive(true)
            self.useCountBtnName:SetText("x"..tostring(self.useItemCount))
        end
    else
        self.useItemCount = 1
        self.ctrl:OnClickUseBtn(self.speedUpItemUuid, self.activityId, self.queueId, 1)
    end
end

function UIMiningSpeedUpView : OnClickUseCountBtn()
    self.ctrl:OnClickUseBtn( self.speedUpItemUuid, self.activityId, self.queueId, self.useItemCount)
end

return UIMiningSpeedUpView