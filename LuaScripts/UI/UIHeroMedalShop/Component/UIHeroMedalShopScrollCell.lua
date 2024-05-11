-- 英雄勋章商店带倒计时的标题title cell
-- 和UIHeroMedalShopItem平级

local UIHeroMedalShopScrollCell = BaseClass("UIHeroMedalShopScrollCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local title_label_path = "TitleInfo/TitleText"
local count_label_path = "TitleInfo/timeLayout/CountDownText"
local empty_label_path = "TitleInfo/EmptyLabel"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function ComponentDefine(self)
    self.title_label = self:AddComponent(UITextMeshProUGUIEx, title_label_path)
    self.count_title_label = self:AddComponent(UITextMeshProUGUIEx, count_label_path)
    self.empty_label = self:AddComponent(UITextMeshProUGUIEx, empty_label_path)
    self.empty_label:SetLocalText(320904)
end

local function OnDestroy(self)
    self.title_label = nil
    self.count_title_label = nil
    self.empty_label = nil

    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:AddTimer()
end

local function OnDisable(self)
    base.OnDisable(self)
    self:DeleteTimer()
end

local function AddTimer(self)
    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.UpdateTime , self, false,false,false)
    end
    self.countDownTimer:Start()
end

local function DeleteTimer(self)
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

local function SetData(self, cellInfo)
    self.cellInfo = cellInfo
    self.title_label:SetText(Localization:GetString(cellInfo.titleName))
    self.count_title_label:SetText("00:00:00")

    -- 记录当前状态
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime < self.cellInfo.startTime then
        -- 还没到开启时间
        self.state = 0
    elseif curTime > self.cellInfo.endTime then
        -- 已经结束
        self.state = 2
    else
        -- 正在进行
        self.state = 1
    end

    self:UpdateTime()
end

local function UpdateTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.state == 0 then
        -- 还没开始
        if curTime > self.cellInfo.startTime then
            self:TryRefreshPanel()
        end

        local deltaTime = self.cellInfo.startTime - curTime
        local timeStr = Localization:GetString("302786", UITimeManager:GetInstance():SecondToFmtString(deltaTime / 1000))
        self.count_title_label:SetText(timeStr)
    elseif self.state == 1 then
        -- 正在进行
        local deltaTime = self.cellInfo.endTime - curTime
        local timeStr = UITimeManager:GetInstance():SecondToFmtString(deltaTime / 1000)
        self.count_title_label:SetText(timeStr)
    else
        -- 已经结束
        if curTime > self.cellInfo.endTime then
            self:TryRefreshPanel()
        end
    end
end

-- 有的商店时间结束或者有的商店到开启时间的时候 刷新界面
local function TryRefreshPanel(self)
    
end

UIHeroMedalShopScrollCell.OnCreate = OnCreate
UIHeroMedalShopScrollCell.OnDestroy = OnDestroy
UIHeroMedalShopScrollCell.OnEnable = OnEnable
UIHeroMedalShopScrollCell.OnDisable = OnDisable
UIHeroMedalShopScrollCell.AddTimer = AddTimer
UIHeroMedalShopScrollCell.DeleteTimer = DeleteTimer

UIHeroMedalShopScrollCell.ComponentDefine = ComponentDefine
UIHeroMedalShopScrollCell.SetData = SetData
UIHeroMedalShopScrollCell.UpdateTime = UpdateTime
UIHeroMedalShopScrollCell.TryRefreshPanel = TryRefreshPanel

return UIHeroMedalShopScrollCell