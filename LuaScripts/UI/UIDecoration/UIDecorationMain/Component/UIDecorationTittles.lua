---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1020.
--- DateTime: 2023/4/14 17:54
---

local UIDecorationTittles = BaseClass("UIDecorationTittles", UIBaseContainer)
local base = UIBaseContainer
local UIDecorationTittleItem = require "UI.UIDecoration.UIDecorationMain.Component.UIDecorationTittleItem"
local Localization = CS.GameEntry.Localization
local scroll_view_path = "OneColScrollView"
local unlock_btn_path = "UnlockBtn"
local unlock_btn_text_path = "UnlockBtn/UnlockBtnText"
local unlock_redDot_path = "UnlockBtn/UnlockBtnRedDot"

local remain_time_path = "RemainTime"
local remain_time_text_path = "RemainTime/RemainTimeText"
local remain_time_add_btn_path = "RemainTime/RemainTimeText/RemainTimeAddBtn"
local remain_time_add_btn_redDot_path = "RemainTime/RemainTimeText/RemainTimeAddBtn/RedDotWithoutNum"

local use_btn_path = "UseBtn"
local use_btn_text_path = "UseBtn/UseBtnText"

local in_use_btn_path = "InUseBtn"
local in_use_btn_text_path = "InUseBtn/InUseBtnText"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.unlock_btn = self:AddComponent(UIButton, unlock_btn_path)
    self.unlock_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUnlockClick()
    end)
    self.unlock_redDot = self:AddComponent(UIBaseContainer, unlock_redDot_path)
    self.unlock_redDot:SetActive(false)
    self.btn_text = self:AddComponent(UITextMeshProUGUIEx, unlock_btn_text_path)
    self.btn_text:SetLocalText(130056)

    self.remain_time = self:AddComponent(UIBaseContainer, remain_time_path)
    self.remain_time_text = self:AddComponent(UITextMeshProUGUIEx, remain_time_text_path)
    self.remain_time_add_btn = self:AddComponent(UIButton, remain_time_add_btn_path)
    self.remain_time_add_btn_redDot = self:AddComponent(UIImage, remain_time_add_btn_redDot_path)
    self.remain_time_add_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUnlockClick()
    end)

    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn_text = self:AddComponent(UITextMeshProUGUIEx, use_btn_text_path)
    self.use_btn_text:SetLocalText(110046)
    self.use_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUseClick()
    end)

    self.timer_action = function(temp)
        self:RefreshRemainTime()
    end

    self.in_use_btn = self:AddComponent(UIButton, in_use_btn_path)
    self.in_use_btn_text = self:AddComponent(UITextMeshProUGUIEx, in_use_btn_text_path)
    self.in_use_btn_text:SetLocalText(129001)
    CS.UIGray.SetGray(self.in_use_btn.transform, true, false)
    self:AddTimer()
end

local function ComponentDestroy(self)
    self:ClearScroll()
    self:DeleteTimer()
    self.scroll_view = nil
end

local function DataDefine(self)
    self.cells = {}
    self.index = 1
    self.onBtnClick = function(index)
        self:OnCellBtnClick(index)
    end
end

local function DataDestroy(self)
    self.cells = {}
    self.index = 1
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false,false,false)
    end

    self.timer:Start()
end

local function SetData(self, dataList, currentSelect)
    self.dataList = dataList
    self.index = self:GetSelectIndexBySkinId(currentSelect)
    self:RefreshScrollView()
    self:RefreshBtn()
    self:RefreshRemainTime()
end

local function RefreshScrollView(self)
    self:ClearScroll()
    local count = table.count(self.dataList)
    self.scroll_view:SetTotalCount(count)
    self.scroll_view:RefillCells()
end

local function OnCreateCell(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.scroll_view:AddComponent(UIDecorationTittleItem, itemObj)
    local param = {}
    param.data = self.dataList[index]
    param.select = index == self.index
    param.onBtnClick = self.onBtnClick
    param.index = index
    cellItem:ReInit(param)
    self.cells[index] = cellItem
end

local function OnDeleteCell(self,itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIDecorationTittleItem)
end

local function ClearScroll(self)
    self.cells = {}
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIDecorationTittleItem)
end

local function OnUnlockClick(self)
    self.view.ctrl:DoWhenClickUnlock(self:GetSelectSkinId())
end

local function RefreshBtn(self)
    local id = self:GetSelectSkinId()
    local data = DataCenter.DecorationDataManager:GetSkinDataById(id)
    local template = DataCenter.DecorationTemplateManager:GetTemplate(id)

    local showTime = false
    local showAdd = false
    local showUnlock = true
    local showAddRedDot = false
    if data == nil then
        if template:IsDefault() then
            showTime = true
            showUnlock = false
        end
    else
        if data:IsInExpireTime() then
            showUnlock = false
            showTime = true
        end
        showAdd = data.expireTime > 0
    end

    showAdd = showAdd and template.type_gain ~= DecorationGainType.DecorationGainType_Female
    self.unlock_btn:SetActive(showUnlock)
    local showUnlockRedDot = false
    for k, v in ipairs(self.dataList) do
        if v.id == id then
            showUnlockRedDot = v.showRedPoint
            showAddRedDot = v.showAddRedPoint
            break
        end
    end
    self.unlock_redDot:SetActive(showUnlockRedDot)
    self.remain_time:SetActive(showTime)

    self.remain_time_add_btn:SetActive(showAdd)
    self.remain_time_add_btn_redDot:SetActive(showAddRedDot)
    local showUse = false

    if template:IsDefault() then
        local currentUse = DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type)
        if currentUse ~= nil and currentUse ~= id then
            if data == nil or not data:IsWear() then
                showUse = true
            end
        end
    else
        showUse = data and not data:IsWear() and data:IsInExpireTime()
    end
    self.use_btn:SetActive(showUse)
    self.in_use_btn:SetActive(template.id == DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type))
end

local function RefreshRemainTime(self)
    if self.remain_time and self.remain_time:GetActive() then
        local id = self:GetSelectSkinId()
        local now = UITimeManager:GetInstance():GetServerTime()
        local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
        local restTimeStr = ""
        local data = DataCenter.DecorationDataManager:GetSkinDataById(id)
        if data ~= nil then
            local restTime = data.expireTime - now
            restTime = math.max(0, restTime)
            restTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(restTime)
            if data.expireTime <= 0 then
                restTimeStr = Localization:GetString("280098")
            end
        else
            if template:IsDefault() then
                restTimeStr = Localization:GetString("280098")
            end
        end
        self.remain_time_text:SetText(restTimeStr)
    end
end

local function OnUseClick(self)
    local id = self:GetSelectSkinId()
    local template = DataCenter.DecorationTemplateManager:GetTemplate(id)
    if template == nil then
        return
    end
    local lastSex = LuaEntry.Player:GetSex()
    if lastSex ~= SexType.Woman and template.type_gain == DecorationGainType.DecorationGainType_Female then
        UIUtil.ShowTipsId(320608)
        return
    end
    if template:IsDefault() then
        local currentUse = DataCenter.DecorationDataManager:GetCurrentSkinByType(template.type)
        if currentUse ~= id then
            DataCenter.DecorationDataManager:TakeOffSkin(currentUse)
        end
    else
        DataCenter.DecorationDataManager:WearSkin(id)
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function OnUserSkinUpdate(self)
    self:RefreshScrollView()
    self:RefreshBtn()
    self:RefreshRemainTime()
end

function UIDecorationTittles:OnCellBtnClick(index)
    if self.index ~= index then
        self:SetCellSelect(self.index, false)
        self.index = index
        self:SetCellSelect(self.index, true)
        self:RefreshBtn()
        self:RefreshRemainTime()
    end
end

function UIDecorationTittles:SetCellSelect(index, select)
    local cell = self.cells[index]
    if cell ~= nil then
        cell:Select(select)
    end
end

function UIDecorationTittles:GetSelectSkinId()
    local data = self.dataList[self.index]
    if data ~= nil then
        return data.id
    end
end
function UIDecorationTittles:GetSelectIndexBySkinId(skinId)
    local result = 1
    if self.dataList ~= nil then
        for k,v in ipairs(self.dataList) do
            if v.id == skinId then
                result = k
                break
            end
        end
    end
    return result
end

function UIDecorationTittles:SetSelectSkinById(skinId)
    self:OnCellBtnClick(self:GetSelectIndexBySkinId(skinId))
end

UIDecorationTittles.OnUserSkinUpdate = OnUserSkinUpdate
UIDecorationTittles.OnAddListener = OnAddListener
UIDecorationTittles.OnRemoveListener = OnRemoveListener
UIDecorationTittles.RefreshRemainTime = RefreshRemainTime
UIDecorationTittles.RefreshBtn = RefreshBtn
UIDecorationTittles.OnUnlockClick = OnUnlockClick
UIDecorationTittles.RefreshScrollView = RefreshScrollView
UIDecorationTittles.OnDeleteCell = OnDeleteCell
UIDecorationTittles.OnCreateCell = OnCreateCell
UIDecorationTittles.ClearScroll = ClearScroll
UIDecorationTittles.OnCreate = OnCreate
UIDecorationTittles.OnDestroy = OnDestroy
UIDecorationTittles.OnEnable = OnEnable
UIDecorationTittles.OnDisable = OnDisable
UIDecorationTittles.ComponentDefine = ComponentDefine
UIDecorationTittles.ComponentDestroy = ComponentDestroy
UIDecorationTittles.DataDefine = DataDefine
UIDecorationTittles.DataDestroy = DataDestroy
UIDecorationTittles.SetData = SetData
UIDecorationTittles.DeleteTimer = DeleteTimer
UIDecorationTittles.AddTimer = AddTimer
UIDecorationTittles.OnUseClick = OnUseClick

return UIDecorationTittles