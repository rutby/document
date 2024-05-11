---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/24 16:32
---
local ActWorldBoss = BaseClass("ActWorldBoss",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local txt_activityName_path = "rect/Txt_ActivityName"
local txt_time_path = "rect/Text_time"
local txt_des_path = "rect/Text_des"
local btn_tips_path = "rect/Btn_Tips"
local btn_list_path = "rect/Btn_list"
local btn_txt_path = "rect/Btn_list/btnTxt"
local goto_red_path = "rect/Btn_list/gotoRed"
local txt_time_des_path = "rect/Text_timeDes"
local txt_cur_time_path = "rect/Text_curTime"
local r1_txt_path = "rect/Text_r1"
local r2_txt_path = "rect/Text_r2"
local r3_txt_path = "rect/Text_r3"
local r4_txt_path = "rect/Text_r4"

local gain_bg_path = "rect/GainBg"
local gain_title_path = "rect/GainBg/GainTitle"
local gain_icon_path = "rect/GainBg/GainIcon"
local gain_desc_path = "rect/GainBg/GainDesc"
local reward_path = "rect/Reward"
local reward_text_path = "rect/Reward/RewardText"
local reward_red_path = "rect/Reward/RewardRed"
local archive_path = "rect/Archive"
local archive_text_path = "rect/Archive/ArchiveText"
local archive_red_path = "rect/Archive/ArchiveRed"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function ComponentDefine(self)
    self._activityName_txt = self:AddComponent(UITextMeshProUGUIEx,txt_activityName_path)
    self.txt_time = self:AddComponent(UITextMeshProUGUIEx,txt_time_path)
    self.r1_txt = self:AddComponent(UITextMeshProUGUIEx,r1_txt_path)
    self.r2_txt = self:AddComponent(UITextMeshProUGUIEx,r2_txt_path)
    self.r3_txt = self:AddComponent(UITextMeshProUGUIEx,r3_txt_path)
    self.r4_txt = self:AddComponent(UITextMeshProUGUIEx,r4_txt_path)
    self.btn = self:AddComponent(UIButton,btn_list_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:ClickBtn()
    end)
    self.btn_txt = self:AddComponent(UITextMeshProUGUIEx,btn_txt_path)
    self.btn_txt:SetLocalText(110003)
    self.goto_red = self:AddComponent(UIBaseContainer,goto_red_path)
    self.txt_des = self:AddComponent(UITextMeshProUGUIEx,txt_des_path)
    self.txt_des:SetLocalText(121274)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.txt_des.transform)
    self.txt_time_des = self:AddComponent(UITextMeshProUGUIEx,txt_time_des_path)
    self.txt_time_des:SetText("")
    self.world_time_text = self:AddComponent(UITextMeshProUGUIEx,txt_cur_time_path)
    self._tips_btn = self:AddComponent(UIButton, btn_tips_path)
    self._tips_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:ClickTip()
    end)
    self.worldText = Localization:GetString("450090")..": "
    self.timer = nil
    self.timer_action = function(temp)
        self:RefreshTime()
    end

    self.gain_bg_go = self:AddComponent(UIBaseContainer, gain_bg_path)
    self.gain_title_text = self:AddComponent(UITextMeshProUGUIEx, gain_title_path)
    self.gain_title_text:SetLocalText(302621)
    self.gain_icon_image = self:AddComponent(UIImage, gain_icon_path)
    self.gain_desc_text = self:AddComponent(UITextMeshProUGUIEx, gain_desc_path)
    self.reward_btn = self:AddComponent(UIButton, reward_path)
    self.reward_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRewardClick()
    end)
    self.reward_text = self:AddComponent(UITextMeshProUGUIEx, reward_text_path)
    self.reward_text:SetLocalText(302645)
    self.reward_red_go = self:AddComponent(UIBaseContainer, reward_red_path)
    self.archive_btn = self:AddComponent(UIButton, archive_path)
    self.archive_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnArchiveClick()
    end)
    self.archive_text = self:AddComponent(UITextMeshProUGUIEx, archive_text_path)
    self.archive_text:SetLocalText(302644)
    self.archive_red_go = self:AddComponent(UIBaseContainer, archive_red_path)
end

local function ComponentDestroy(self)
    self.timer_action = nil
    self:DeleteTimer()
    self.worldText = nil
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnActBossDataRefresh, self.OnActBossDataRefresh)
    self:AddUIListener(EventId.QuestRewardSuccess, self.Refresh)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnActBossDataRefresh, self.OnActBossDataRefresh)
    self:RemoveUIListener(EventId.QuestRewardSuccess, self.Refresh)
    base.OnRemoveListener(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self.actBossData = nil
    SFSNetwork.SendMessage(MsgDefines.UserGetActBossMarch)
    self:AddTimer()
    self:RefreshTime()
end

local function OnDisable(self)
    self:DeleteTimer()
    base.OnDisable(self)
end


local function ReInit(self,activityId)
    self.activityId = activityId
    DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(activityId)
    self:Refresh()
end

local function Refresh(self)
    self.data = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    if self.data~=nil then
        self._activityName_txt:SetText(Localization:GetString(self.data.name))
        --self.txt_time:SetText(Localization:GetString("302173")..": "..UITimeManager:GetInstance():GetTimeToMD(self.data.actBossStartTime/1000).."~"..UITimeManager:GetInstance():GetTimeToMD(self.data.actBossEndTime/1000))
        local r1 = UITimeManager:GetInstance():TimeStampToTimeForServerOnlyHour(self.data.r1StartTime*1000)
        local r2 = UITimeManager:GetInstance():TimeStampToTimeForServerOnlyHour(self.data.r2StartTime*1000)
        local r3 = UITimeManager:GetInstance():TimeStampToTimeForServerOnlyHour(self.data.r3StartTime*1000)
        local r4 = UITimeManager:GetInstance():TimeStampToTimeForServerOnlyHour(self.data.r4StartTime*1000)
        self.txt_time:SetText(Localization:GetString("302247",r1,r2,r3,r4))
        --self.r1_txt:SetText(Localization:GetString("302174")..": "..UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.r1StartTime*1000).."~"..UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.r1EndTime*1000))
        --self.r2_txt:SetText(Localization:GetString("302175")..": "..UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.r2StartTime*1000).."~"..UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.r2EndTime*1000))
        --self.r3_txt:SetText(Localization:GetString("302237")..": "..UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.r3StartTime*1000).."~"..UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.r3EndTime*1000))
        --self.r4_txt:SetText(Localization:GetString("302238")..": "..UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.r4StartTime*1000).."~"..UITimeManager:GetInstance():TimeStampToTimeForServer(self.data.r4EndTime*1000))
    else
        self.txt_time:SetText("")
        self.r1_txt:SetText("")
        self.r2_txt:SetText("")
        self.r3_txt:SetText("")
        self.r4_txt:SetText("")
    end
    self.reward_red_go:SetActive(DataCenter.ActBossDataManager:GetRewardRedNum() > 0)
    self.archive_red_go:SetActive(DataCenter.ActBossDataManager:GetArchiveRedNum() > 0)
    self.goto_red:SetActive(DataCenter.ActBossDataManager:GetCanAttackBossNum() > 0)
    local curTime = time or UITimeManager:GetInstance():GetServerTime()
    local weekDay = UITimeManager:GetInstance():GetWeekdayIndex(curTime)
    local k24 = LuaEntry.DataConfig:TryGetStr("ship_boss", "k24")
    local k24Strs = string.split(k24, ";")

    local camp = tonumber(k24Strs[weekDay]) or 0
    if camp == 1 then
        self.gain_bg_go:SetActive(true)
        self.gain_icon_image:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/ui_camp_1")
        self.gain_desc_text:SetLocalText(302622)
    elseif camp == 2 then
        self.gain_bg_go:SetActive(true)
        self.gain_icon_image:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/ui_camp_2")
        self.gain_desc_text:SetLocalText(302624)
    elseif camp == 3 then
        self.gain_bg_go:SetActive(true)
        self.gain_icon_image:LoadSprite("Assets/Main/Sprites/UI/UIHeroList/ui_camp_3")
        self.gain_desc_text:SetLocalText(302623)
    else
        self.gain_bg_go:SetActive(false)
    end
end

local function OnActBossDataRefresh(self)
    self.actBossData = DataCenter.ActBossDataManager:GetOneActBossData()
end

local function ClickTip(self)
    UIUtil.ShowIntro(Localization:GetString(self.data.name), Localization:GetString("100239"), Localization:GetString("302196"))
end

local function ClickBtn(self)
    local dataList = DataCenter.ActBossDataManager:GetActBossDataList()
    if dataList~=nil then
        for k,v in pairs(dataList) do
            local pos = v.startPos
            GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(pos,ForceChangeScene.World))
            GoToUtil.CloseAllWindows()
            return
        end
    end
    UIUtil.ShowTipsId(302243)
    --if self.data~=nil then
    --    UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldBossTroop)
    --end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end

    self.timer:Start()
end

local function RefreshTime(self)
    self.world_time_text:SetText(self.worldText..UITimeManager:GetInstance():TimeStampToTimeForServer(UITimeManager:GetInstance():GetServerTime()))
end

local function OnRewardClick(self)
    if self.actBossData then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldBossRank,{anim = true,isBlur = true}, self.actBossData.uuid, false)
    end
end

local function OnArchiveClick(self)
    if self.actBossData then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIWorldBossRank,{anim = true,isBlur = true}, self.actBossData.uuid, true)
    end
end

ActWorldBoss.OnCreate = OnCreate
ActWorldBoss.OnDestroy = OnDestroy
ActWorldBoss.OnAddListener = OnAddListener
ActWorldBoss.OnRemoveListener = OnRemoveListener
ActWorldBoss.OnEnable = OnEnable
ActWorldBoss.OnDisable = OnDisable
ActWorldBoss.ComponentDefine =ComponentDefine
ActWorldBoss.ComponentDestroy =ComponentDestroy
ActWorldBoss.ReInit =ReInit
ActWorldBoss.Refresh =Refresh
ActWorldBoss.OnActBossDataRefresh = OnActBossDataRefresh
ActWorldBoss.ClickTip = ClickTip
ActWorldBoss.ClickBtn = ClickBtn
ActWorldBoss.DeleteTimer =DeleteTimer
ActWorldBoss.AddTimer =AddTimer
ActWorldBoss.RefreshTime =RefreshTime
ActWorldBoss.OnRewardClick = OnRewardClick
ActWorldBoss.OnArchiveClick = OnArchiveClick

return ActWorldBoss