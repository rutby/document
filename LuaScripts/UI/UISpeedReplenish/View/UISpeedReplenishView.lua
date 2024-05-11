--- Created by shimin.
--- DateTime: 2024/1/18 10:13
--- 一键补充资源界面

local UISpeedReplenishView = BaseClass("UISpeedReplenishView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem_TextMeshPro"

local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
local des_text_path = "des_text"
local item_scroll_view_path = "item_scroll_view"
local red_btn_path = "btn_go/MidBtnRed"
local red_btn_text_path = "btn_go/MidBtnRed/red_btn_text"
local blue_btn_path = "btn_go/MidBtnBlue"
local blue_btn_text_path = "btn_go/MidBtnBlue/blue_btn_text"
local back_toggle_path = "backToggle"
local back_toggle_txt_path = "backToggle/backToggle_txt"
local scrollTitle_text_path = "scrollTitle"
local remainTimeTitle_path = "remainContent/remainTimeTitle"
local remainTime_path = "remainContent/remainTime"

--创建
function UISpeedReplenishView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UISpeedReplenishView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UISpeedReplenishView:ComponentDefine()
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.item_scroll_view = self:AddComponent(UIScrollView, item_scroll_view_path)
    self.item_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemCreateCell(itemObj, index)
    end)
    self.item_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemDeleteCell(itemObj, index)
    end)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.red_btn = self:AddComponent(UIButton, red_btn_path)
    self.red_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRedBtnClick()
    end)
    self.red_btn_text = self:AddComponent(UITextMeshProUGUIEx, red_btn_text_path)
    self.blue_btn = self:AddComponent(UIButton, blue_btn_path)
    self.blue_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBlueBtnClick()
    end)
    self.blue_btn_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_text_path)
    self.back_toggle = self:AddComponent(UIToggle, back_toggle_path)
    self.back_toggle_txt = self:AddComponent(UITextMeshProUGUIEx,back_toggle_txt_path)
    self.back_toggle:SetOnValueChanged(function(tf)
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:ToggleControlBorS(tf)
    end)
    self.scrollTitleText = self:AddComponent(UITextMeshProUGUIEx,scrollTitle_text_path)
    self.remainTimeTitle = self:AddComponent(UITextMeshProUGUIEx,remainTimeTitle_path)
    self.remainTime = self:AddComponent(UITextMeshProUGUIEx,remainTime_path)
end

function UISpeedReplenishView:ComponentDestroy()
end

function UISpeedReplenishView:DataDefine()
    self.param = {}
    self.itemList = {}
    self.itemCells = {}
    self.timer_action = function(temp)
        self:RefreshTime()
    end
    self.close = false
    self.todayNoShow = false
end

function UISpeedReplenishView:DataDestroy()
    self:DeleteTimer()
    if self.todayNoShow then
        DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.SpeedReplenish, true)
    end
end

function UISpeedReplenishView:ToggleControlBorS(noShow)
    if self.todayNoShow ~= noShow then
        self.todayNoShow = noShow
        self:RefreshNoShow()
    end
end

function UISpeedReplenishView:RefreshNoShow()
    self.back_toggle:SetIsOn(self.todayNoShow)
end

function UISpeedReplenishView:OnEnable()
    base.OnEnable(self)
end

function UISpeedReplenishView:OnDisable()
    base.OnDisable(self)
end

function UISpeedReplenishView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.AddBuildSpeedSuccess, self.AddBuildSpeedSuccessSignal)
    self:AddUIListener(EventId.AddSpeedSuccess, self.AddSpeedSuccessSignal)
end


function UISpeedReplenishView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.AddBuildSpeedSuccess, self.AddBuildSpeedSuccessSignal)
    self:RemoveUIListener(EventId.AddSpeedSuccess, self.AddSpeedSuccessSignal)
end

function UISpeedReplenishView:ReInit()
    self.param = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.SPEED_REPLENISH_ALL)
    self.back_toggle_txt:SetLocalText(GameDialogDefine.TODAY_NO_SHOW)
    self.red_btn_text:SetLocalText(GameDialogDefine.CANCEL)
    self.blue_btn_text:SetLocalText(GameDialogDefine.CONFIRM)
    self.remainTimeTitle:SetLocalText(GameDialogDefine.LEFT_TIME)
    self.scrollTitleText:SetLocalText(441073)
    self:AddTimer()
    self:Refresh()
    self:RefreshNoShow()
end

function UISpeedReplenishView:Refresh()
    self:ShowItemCells()
    self:RefreshDes()
end

--一分钟刷一次（秒为0）
function UISpeedReplenishView:GetItemDataList()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.param.endTime - curTime
    self.itemList = DataCenter.ItemManager:GetReplenishUseSpeedArr(leftTime, self.param.list)
end

function UISpeedReplenishView:ClearItemScroll()
    self.itemCells = {}
    self.item_scroll_view:ClearCells()--清循环列表数据
    self.item_scroll_view:RemoveComponents(UICommonItem)--清循环列表gameObject
end

function UISpeedReplenishView:OnItemCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.item_scroll_view:AddComponent(UICommonItem, itemObj)
    cell:ReInit(self.itemList[index])
    self.itemCells[index] = cell
end

function UISpeedReplenishView:OnItemDeleteCell(itemObj, index)
    self.itemCells[index] = nil
    self.item_scroll_view:RemoveComponent(itemObj.name, UICommonItem)
end

function UISpeedReplenishView:ShowItemCells()
    self:ClearItemScroll()
    self:GetItemDataList()
    local count = #self.itemList
    if count > 0 then
        self.item_scroll_view:SetTotalCount(count)
        self.item_scroll_view:RefillCells()
    end
end

function UISpeedReplenishView:OnRedBtnClick()
    self.ctrl:CloseSelf()
end

function UISpeedReplenishView:OnBlueBtnClick()
    local itemStr = ""
    for k,v in ipairs(self.itemList) do
        if itemStr == "" then
            itemStr = v.itemId .. ";" .. v.count
        else
            itemStr = itemStr .. "|" .. v.itemId .. ";" .. v.count
        end
    end
    if self.param.speedType == ItemSpdMenu.ItemSpdMenu_City then
        SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, { bUUID = self.param.uuid, itemIDs = itemStr, isFixRuins = false})
    elseif self.param.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
        SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, { bUUID = self.param.uuid, itemIDs = itemStr,isFixRuins = true})
    elseif self.param.speedType == ItemSpdMenu.ItemSpdMenu_Heal then
        local hType = MarchArmsType.Free
        if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            hType = MarchArmsType.CROSS_DRAGON
        end
        SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.param.uuid, itemIDs = itemStr, isGold = IsGold.NoUseGold }, nil ,hType)
    else
        SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.param.uuid, itemIDs = itemStr, isGold = IsGold.NoUseGold })
    end
    self.close = true
    self.ctrl:CloseSelf()
end

function UISpeedReplenishView:RefreshDes()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local leftTime = self.param.endTime - curTime
    local time = 0
    for k,v in ipairs(self.itemList) do
        time = time + v.per * v.count
    end
    if leftTime > time then
        --红色  GameDialogDefine.ALL_SPEED_TIME_WITH
        self.des_text:SetText("<color=#fb3b3b>"..Localization:GetString(441072, "<size=+2>"..UITimeManager:GetInstance():MilliSecondToFmtString(time)))
    else
        --绿色
        self.des_text:SetText("<color=#5A9142>"..Localization:GetString(441072, "<size=+2>"..UITimeManager:GetInstance():MilliSecondToFmtString(time)))
    end
end

function UISpeedReplenishView:AddBuildSpeedSuccessSignal()
    if not self.close then
        self:RefreshEndTime()
        self:Refresh()
    end
end

function UISpeedReplenishView:AddSpeedSuccessSignal()
    if not self.close then
        self:RefreshEndTime()
        self:Refresh()
    end
end

function UISpeedReplenishView:RefreshEndTime()
    if self.param.speedType == ItemSpdMenu.ItemSpdMenu_City then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
        if buildData ~= nil then
            self.param.endTime = self.param.endTime - self.param.originalEndTime + buildData.updateTime
        end
    elseif self.param.speedType == ItemSpdMenu.ItemSpdMenu_Fix_Ruins then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.uuid)
        if buildData ~= nil then
            self.param.endTime = self.param.endTime - self.param.originalEndTime + buildData.destroyEndTime
        end
    else
        local queue = DataCenter.QueueDataManager:GetQueueByUuid(self.param.uuid)
        if queue ~= nil then
            self.param.endTime = self.param.endTime - self.param.originalEndTime + queue.endTime
        end
    end
end

function UISpeedReplenishView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UISpeedReplenishView:AddTimer()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.param.endTime - curTime
    self.remainTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(changeTime))
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false, false, false)
        self.timer:Start()
    end
end

function UISpeedReplenishView:RefreshTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.param.endTime - curTime
    self.remainTime:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(changeTime))
    if changeTime > 0 then
        local tempTimeSec = math.ceil(changeTime / 1000)
        if tempTimeSec % 60 == 0 then
            self:Refresh()
        end
    else
        self.param.endTime = 0
        self.close = true
        self.ctrl:CloseSelf()
    end
end


return UISpeedReplenishView