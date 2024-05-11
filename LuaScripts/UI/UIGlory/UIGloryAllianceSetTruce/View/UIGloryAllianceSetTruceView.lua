---
--- 荣耀之战设置休战时间
--- Created by shimin.
--- DateTime: 2023/3/2 15:01
---

local UIGloryAllianceSetTruceView = BaseClass("UIGloryAllianceSetTruceView", UIBaseView)
local base = UIBaseView
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local Localization = CS.GameEntry.Localization

local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local flag_path = "ImgBg/TopInfo/AllianceFlag"
local abbr_name_text_path = "ImgBg/TopInfo/nameBg/abbr_name_text"
local cur_truce_time_text_path = "ImgBg/TopInfo/layout/cur_truce_time_text"
local cur_truce_time_value_text_path = "ImgBg/TopInfo/layout/cur_truce_time_value_text"
local truce_hint_path = "ImgBg/TopInfo/layout/truce_hint"
local truce_change_time_text_path = "ImgBg/truce_change_time_text"
local truce_change_time_value_text_path = "ImgBg/truce_change_time_value_text"
local truce_des_text_path = "ImgBg/truce_des_text"
local truce_time_name_text_path = "ImgBg/truce_time_name_text"
local cur_game_time_text_path = "ImgBg/cur_game_time_text"
local truce_warning_des_text_path = "ImgBg/truce_warning_des_text"
local save_btn_path = "ImgBg/save_btn"
local save_btn_name_path = "ImgBg/save_btn/save_btn_name"
local toggle_path = "ImgBg/ToggleGroup/Toggle%s"

function UIGloryAllianceSetTruceView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

function UIGloryAllianceSetTruceView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryAllianceSetTruceView:OnEnable()
    base.OnEnable(self)
end

function UIGloryAllianceSetTruceView:OnDisable()
    base.OnDisable(self)
end

function UIGloryAllianceSetTruceView:ComponentDefine()
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.flagN = self:AddComponent(AllianceFlagItem, flag_path)
    self.abbr_name_text = self:AddComponent(UIText, abbr_name_text_path)
    self.cur_truce_time_text = self:AddComponent(UIText, cur_truce_time_text_path)
    self.cur_truce_time_value_text = self:AddComponent(UIText, cur_truce_time_value_text_path)
    self.truce_hint_text = self:AddComponent(UIText, truce_hint_path)
    self.truce_change_time_text = self:AddComponent(UIText, truce_change_time_text_path)
    self.truce_change_time_value_text = self:AddComponent(UIText, truce_change_time_value_text_path)
    self.truce_des_text = self:AddComponent(UIText, truce_des_text_path)
    self.truce_time_name_text = self:AddComponent(UIText, truce_time_name_text_path)
    self.cur_game_time_text = self:AddComponent(UIText, cur_game_time_text_path)
    self.truce_warning_des_text = self:AddComponent(UIText, truce_warning_des_text_path)
    self.save_btn_name = self:AddComponent(UIText, save_btn_name_path)
    self.save_btn = self:AddComponent(UIButton, save_btn_path)
    self.save_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnSaveBtnClick()
    end)
end

function UIGloryAllianceSetTruceView:ComponentDestroy()
  
end

function UIGloryAllianceSetTruceView:DataDefine()
    self.selectIndex = 0
    self.changeAvoidEndTime = 0
    self.useIndex = 0
    self.time_callback = function()
        self:RefreshTime()
    end
end

function UIGloryAllianceSetTruceView:DataDestroy()
    self:DeleteTimer()
    self.time_callback = nil
    self.selectIndex = 0
    self.changeAvoidEndTime = 0
    self.useIndex = 0
    self.toggle = {}
    self.list = {}
end

function UIGloryAllianceSetTruceView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.GlorySetAvoid, self.GlorySetAvoidSignal)
end

function UIGloryAllianceSetTruceView:OnRemoveListener()
    self:RemoveUIListener(EventId.GlorySetAvoid, self.GlorySetAvoidSignal)
    base.OnRemoveListener(self)
end

function UIGloryAllianceSetTruceView:ReInit()
    self.title_text:SetLocalText(GameDialogDefine.REST_TIME)
    self.cur_truce_time_text:SetLocalText(GameDialogDefine.CUR_TRUCE_TIME)
    self.truce_change_time_text:SetLocalText(GameDialogDefine.NEXT_CHANGE_TRUCE_TIME)
    self.truce_des_text:SetLocalText(GameDialogDefine.TRUCE_DES)
    self.truce_time_name_text:SetLocalText(GameDialogDefine.SELECT_TIME)
    self.truce_warning_des_text:SetLocalText(GameDialogDefine.TRUCE_WARNING_DES)
    self.save_btn_name:SetLocalText(GameDialogDefine.SAVE)
    
    local showAvoid = self:RefreshAvoidTime()
    local allianceData = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    if allianceData ~= nil then
        self.flagN:SetData(allianceData.icon)
        self.abbr_name_text:SetText('[' .. allianceData.abbr ..']' .. allianceData.allianceName)
    end

    self.toggle = {}
    self.list = DataCenter.GloryManager:GetAllShowAvoidTime()
    for k,v in ipairs(self.list) do
        local toggle = self:AddComponent(UIToggle, string.format(toggle_path, k))
        if toggle ~= nil then
            toggle:SetOnValueChanged(function(tf)
                if tf then
                    self:ToggleControlBorS(k)
                end
            end)
            toggle.showName = toggle:AddComponent(UIText, "Text_num")
            if k == 1 then
                toggle.showName:SetText(Localization:GetString(GameDialogDefine.FIRST_TURN) .. " ("  .. v.showTime .. ") ")
            elseif k == 2 then
                toggle.showName:SetText(Localization:GetString(GameDialogDefine.SECOND_TURN) .. " ("  .. v.showTime .. ") ")
            else
                toggle.showName:SetText(v.showTime)
            end
            self.toggle[k] = toggle
        end
        if showAvoid == v.showTime then
            self.useIndex = k
            self.selectIndex = self.useIndex
        end
    end
    if self.toggle[self.useIndex] ~= nil then
        self.toggle[self.useIndex]:SetIsOn(true)
    end
    self:AddTimer()
    self:RefreshTime()

    local period = DataCenter.GloryManager:GetPeriod()
    if period == GloryPeriod.Start then
        self.truce_hint_text:SetLocalText(303004)
    else
        self.truce_hint_text:SetLocalText(303005)
    end
end

function UIGloryAllianceSetTruceView:RefreshTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self.cur_game_time_text:SetText(Localization:GetString(GameDialogDefine.CUR_GAME_TIME) ..": " .. 
            UITimeManager:GetInstance():TimeStampToTimeForServer(curTime))
    if curTime >= self.changeAvoidEndTime then
        --self.truce_change_time_value_text:SetLocalText(GameDialogDefine.CAN_ADJUST)
        --self.truce_change_time_value_text:SetColor(DetectEventGreenColor)
        self.truce_change_time_text:SetActive(false)
        self.truce_change_time_value_text:SetActive(false)
        self.save_btn:SetActive(true)
        --self.save_btn:SetInteractable(true)
    else
        self.truce_change_time_value_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.changeAvoidEndTime - curTime))
        self.truce_change_time_value_text:SetColor(WhiteColor)
        self.truce_change_time_text:SetActive(true)
        self.truce_change_time_value_text:SetActive(true)
        self.save_btn:SetActive(false)
        --self.save_btn:SetInteractable(false)
    end
end

function UIGloryAllianceSetTruceView:OnSaveBtnClick()
    --宣战期间不能设置休战时间
    if DataCenter.GloryManager:GetPeriod() == GloryPeriod.Start then
        UIUtil.ShowTipsId(GameDialogDefine.CANT_SET_TRUCE_RESAON_TIPS)
    else
        local todayRestTimeS = UITimeManager:GetInstance():GetResSecondsTo24()
        if todayRestTimeS <= OneHourTime then
            UIUtil.ShowTipsId(GameDialogDefine.CANT_SET_TRUCE_RESAON_TIPS)
        else
            if self.useIndex ~= self.selectIndex and self.list[self.selectIndex] ~= nil then
                DataCenter.GloryManager:SendSetAvoid(self.list[self.selectIndex].index)
                UIUtil.ShowTipsId(GameDialogDefine.SUCCESS_SET_TRUCE_TIPS)
            end
        end
    end
end

function UIGloryAllianceSetTruceView:ToggleControlBorS(index)
    self.selectIndex = index
end

function UIGloryAllianceSetTruceView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIGloryAllianceSetTruceView:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.time_callback ,self, false, false, false)
    end
    self.timer:Start()
end

function UIGloryAllianceSetTruceView:GlorySetAvoidSignal()
    self:RefreshAvoidTime()
    self:RefreshTime()
end


function UIGloryAllianceSetTruceView:RefreshAvoidTime()
    local showAvoid = ""
    local warData = DataCenter.GloryManager:GetWarData()
    if warData ~= nil then
        showAvoid = warData:GetShowAvoidTime()
        self.cur_truce_time_value_text:SetText(showAvoid)
        self.changeAvoidEndTime = warData:GetChangeAvoidEndTime()
    end
    return showAvoid
end



return UIGloryAllianceSetTruceView