--- Created by shimin.
--- DateTime: 2020/8/17 15:18
--- 医院界面

local UIHospitalView = BaseClass("UIHospitalView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local RobotWarsIntroItem = require "UI.UIRobotWarsIntro.Component.RobotWarsIntroItem"

local scrollView_path = "intro/ScrollView"
local content_path = "intro/ScrollView/Viewport/Content"
local point_path = "intro/PointArea/point"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local bgBtn_path = "UICommonPopUpTitle/panel"
local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local origPoint_path = "intro/origPoint"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitUI()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.scrollViewN = self:AddComponent(UIScrollView, scrollView_path)
    self.scrollViewN:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scrollViewN:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.contentN = self:AddComponent(UIBaseContainer, content_path)
    self.eventTriggerN = self:AddComponent(UIEventTrigger, content_path)
    self.eventTriggerN:OnDrag(function(eventData)
        self:OnDrag(eventData)
    end)
    self.eventTriggerN:OnBeginDrag(function(eventData)
        self:OnBeginDrag(eventData)
    end)
    self.eventTriggerN:OnEndDrag(function(eventData)
        self:OnEndDrag(eventData)
    end)
    self.pointTbN = {}
    for i = 1, 8 do
        local tempP = self:AddComponent(UIBaseContainer, point_path .. i)
        local selected = tempP:AddComponent(UIBaseContainer, "selected")
        local newP = {}
        newP.pointN = tempP
        newP.selectedN = selected
        table.insert(self.pointTbN, newP)
    end
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.bgBtnN = self:AddComponent(UIButton, bgBtn_path)
    self.bgBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.titleN = self:AddComponent(UIText, title_path)
    self.titleN:SetLocalText(170001)
    self.origPointN = self:AddComponent(UIBaseContainer, origPoint_path)
end

local function ComponentDestroy(self)
    self.scrollViewN = nil
    self.contentN = nil
    self.pointTbN = nil
    self.closeBtnN = nil
    self.bgBtnN = nil
    self.titleN = nil
    self.origPointN = nil
end


local function DataDefine(self)
    self.curPageIndex = 1
    self.introItems = {}
    self.introList = {}
end

local function DataDestroy(self)
    self.curPageIndex = nil
    self.introItems = nil
    self.introList = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function InitUI(self)
    self.curPageIndex = 1
    self.introList = self.ctrl:GetIntroList()

    for i, v in ipairs(self.pointTbN) do
        if i <= #self.introList then
            v.pointN:SetActive(true)
        else
            v.pointN:SetActive(false)
        end
    end

    self:RefreshAll()
end

local function RefreshAll(self)
    if #self.introList > 0 then
        self.scrollViewN:SetTotalCount(#self.introList)
        self.scrollViewN:RefillCells(self.curPageIndex)
    end
    self:RefreshPoints()
end

local function RefreshPoints(self)
    for i = 1, #self.introList do
        self.pointTbN[i].selectedN:SetActive(i == self.curPageIndex)
    end
end


local function OnDrag(self, eventData)
    self.scrollViewN:OnDrag(eventData)
end

local function OnBeginDrag(self, eventData)
    self.scrollViewN:OnBeginDrag(eventData)
end

local function OnEndDrag(self, eventData)
    local tempItem = self.introItems[self.curPageIndex]
    if tempItem and not IsNull(tempItem.gameObject) then
        local scaleFactor = UIManager:GetInstance():GetScaleFactor()
        local origPos = self.origPointN.transform.position
        local tempPos = tempItem.transform.position
        local offset = (tempPos - origPos) * scaleFactor
        if offset.x < -20 and self.curPageIndex < #self.introList then
            self.curPageIndex = self.curPageIndex + 1
        elseif offset.x > 20 and self.curPageIndex > 1 then
            self.curPageIndex = self.curPageIndex - 1
        end
    end

    self.scrollViewN:StopMovement()
    self.scrollViewN:OnEndDrag(eventData)
    self.scrollViewN:ScrollToCell(self.curPageIndex, 5000)
    self:RefreshPoints()
end

local function ClearScroll(self)
    self.scrollViewN:ClearCells()
    self.scrollViewN:RemoveComponents(RobotWarsIntroItem)
end

local function OnCreateCell(self, itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scrollViewN:AddComponent(RobotWarsIntroItem, itemObj)
    item:SetData(self.introList[index])
    self.introItems[index] = item
end

local function OnDeleteCell(self, itemObj, index)
    self.scrollViewN:RemoveComponent(itemObj.name, RobotWarsIntroItem)
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

UIHospitalView.OnCreate = OnCreate
UIHospitalView.OnDestroy = OnDestroy
UIHospitalView.OnEnable = OnEnable
UIHospitalView.OnDisable = OnDisable
UIHospitalView.ComponentDefine = ComponentDefine
UIHospitalView.ComponentDestroy = ComponentDestroy
UIHospitalView.DataDefine = DataDefine
UIHospitalView.DataDestroy = DataDestroy

UIHospitalView.InitUI = InitUI
UIHospitalView.RefreshAll = RefreshAll
UIHospitalView.RefreshPoints = RefreshPoints
UIHospitalView.OnDrag = OnDrag
UIHospitalView.OnBeginDrag = OnBeginDrag
UIHospitalView.OnEndDrag = OnEndDrag
UIHospitalView.ClearScroll = ClearScroll
UIHospitalView.OnCreateCell = OnCreateCell
UIHospitalView.OnDeleteCell = OnDeleteCell
UIHospitalView.OnClickCloseBtn = OnClickCloseBtn

return UIHospitalView