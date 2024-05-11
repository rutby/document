---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 7/8/21 8:54 PM
---


local UITabCell = BaseClass("UITabCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self:AddComponent(UIButton, ""):SetOnClick(BindCallback(self, self.OnBtnClick))
    self.imgIcon    = self:AddComponent(UIImage, "")
    self.textName   = self:AddComponent(UITextMeshProUGUIEx, "TextName")
    self.nodeTime   = self:AddComponent(UITextMeshProUGUIEx, "ImgTimeBg")
    self.textTime   = self:AddComponent(UITextMeshProUGUIEx, "ImgTimeBg/TextTime")
    self.imgGray    = self:AddComponent(UITextMeshProUGUIEx, "ImgGray")
    self.imgSelect  = self:AddComponent(UIImage, "ImgSelect")
    self.redPoint   = self:AddComponent(UIBaseContainer, "RedPoint")
    self.arrowPoint = self:AddComponent(UIBaseContainer,"Rect_ArrowPoint")
    self.tabImgIcon    = self:AddComponent(UIImage, "ImgIcon")
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.lotteryId = nil
    self.lotteryData = nil
    self.idx = -1
    self.callBack = nil
end

local function DataDestroy(self)
    self.lotteryId = nil
    self.lotteryData = nil
    self.callBack = nil
    self.idx = nil
end

local function SetData(self, idx, lotteryData, callBack)
    self:SetHeroData(idx, lotteryData, callBack)
end

local function SetHeroData(self, idx, lotteryData, callBack)
    self.idx = idx
    self.lotteryId = lotteryData.id
    self.lotteryData = lotteryData
    self.callBack = callBack
    self.IsOpen = false
    if self.lotteryData ~= nil then
        self.IsOpen = self.lotteryData:IsOpen()
    end
    self.tabImgIcon:LoadSprite(self.lotteryData:GetIconName())
    self.tabImgIcon:SetNativeSize()
    self.textName:SetLocalText(GetTableData(TableName.HeroRecruit, self.lotteryId, 'name'))
    self.nodeTime:SetActive(self.lotteryData ~= nil and self.lotteryData:IsShowTime())
    self:OnTimer()
    self:UpdateRedPoint()
    self:UpdateSelect()

    local gray = self.lotteryData.startTime > UITimeManager:GetInstance():GetServerTime()
    UIGray.SetGray(self.transform, gray, true)
end

local function OnTimer(self)
    if self.lotteryData == nil or not self.lotteryData:IsShowTime() then
        self.nodeTime:SetActive(false)
        return
    end

    if self.lotteryData:IsOpen() then
        local now = UITimeManager:GetInstance():GetServerTime()
        local leftTime = math.max(0, self.lotteryData.endTime - now)
        self.textTime:SetLocalText(302012,  UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    else
        local curCampId = GetTableData(TableName.HeroRecruit, self.lotteryId, 'recruit_camp')
        local displayConfig = DataCenter.LotteryDataManager:GetDisplayConfig()
        local isNextCamp = curCampId == tostring(displayConfig:GetCampId(DataCenter.LotteryDataManager.nextCampLotteryId))
        if isNextCamp then
            self.textTime:SetLocalText(110125)
            self.nodeTime:SetActive(true)
        else
            self.textTime:SetText('')
            self.nodeTime:SetActive(false)
        end
    end
end

local function OnBtnClick(self)
    if self.callBack ~= nil then
        self.callBack(self.idx)
    end
end

local function UpdateSelect(self)
    self.imgSelect:SetActive(self.idx == self.view.currentTabIdx)
end

local function UpdateRedPoint(self)
    if self.lotteryData == nil or not self.lotteryData:IsOpen() then
        self.redPoint:SetActive(false)
        return
    end
    local visible = false
    if self.lotteryData:CanFreeRecruit() then
        visible = true
    else
        local costItems = self.lotteryData:GetCostItems()
        local itemId = costItems[2].itemId
        local itemNum = costItems[2].itemNum
        local have = DataCenter.ItemData:GetItemCount(itemId)
        if have >= itemNum then
            visible = true
        end
    end
    
    self.redPoint:SetActive(visible)
end

local function Update(self)
    if self.lotteryData ~= nil and self.lotteryData:IsOpen() then
        self:OnTimer()
    end
    if self.lotteryData ~= nil then
        local tmp = self.lotteryData:IsOpen()
        if self.IsOpen ~= tmp then
            self.IsOpen = tmp
            self.view.ctrl:GetDataFromServer()
        end
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.HeroicRecruitmentData, self.UpdateRedPoint)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.HeroicRecruitmentData, self.UpdateRedPoint)
    base.OnRemoveListener(self)
end

local function GetPosition(self)
    return self.arrowPoint.transform.position
end



UITabCell.OnCreate = OnCreate
UITabCell.OnDestroy = OnDestroy
UITabCell.OnEnable = OnEnable
UITabCell.OnDisable = OnDisable
UITabCell.ComponentDefine = ComponentDefine
UITabCell.ComponentDestroy = ComponentDestroy
UITabCell.DataDefine = DataDefine
UITabCell.DataDestroy = DataDestroy
UITabCell.SetData = SetData
UITabCell.SetHeroData = SetHeroData

UITabCell.OnTimer = OnTimer
UITabCell.Update = Update
UITabCell.OnBtnClick = OnBtnClick
UITabCell.UpdateSelect = UpdateSelect
UITabCell.UpdateRedPoint = UpdateRedPoint

UITabCell.OnAddListener = OnAddListener
UITabCell.OnRemoveListener = OnRemoveListener

UITabCell.GetPosition = GetPosition

return UITabCell
