---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime: 
---
local ActSevenLogin = BaseClass("ActSevenLogin",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local SevenLoginCell = require "UI.UIActivityCenterTable.Component.SevenLogin.SevenLoginCell"
function ActSevenLogin:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

function ActSevenLogin:ComponentDefine()
    ----标题
    self._name_txt = self:AddComponent(UITextMeshProUGUIEx,"RightView/TitleBg/Txt_ActName")
    ----倒计时
    self._time_txt = self:AddComponent(UITextMeshProUGUIEx,"RightView/TitleBg/Txt_ActTime/NotStarted/Txt_Time")
    self._desc_txt = self:AddComponent(UITextMeshProUGUIEx,"RightView/TitleBg/Txt_ActTime")

    self._rarity_img = self:AddComponent(UIImage,"RightView/RectSearch/bg/ImgRarity")
    self._heroName_txt = self:AddComponent(UITextMeshProUGUIEx,"RightView/RectSearch/bg/TextHeroName")
    --self._heroNick_txt = self:AddComponent(UITextMeshProUGUIEx,"RightView/TextNickName")

    self._getReward_btn = self:AddComponent(UIButton,"RightView/Btn_GetReward")
    self._getReward_txt = self:AddComponent(UITextMeshProUGUIEx,"RightView/Btn_GetReward/Txt_GetReward")
    self._getRewardGray_txt = self:AddComponent(UITextMeshProUGUIEx,"RightView/Btn_GetReward/Txt_GetRewardGray")
    self._getReward_btn:SetOnClick(function()
        self:OnClickReward()
    end)
    
    self.cell = {}
    for i = 1 ,7 do
        self.cell[i] = self:AddComponent(SevenLoginCell,"RightView/Rect_Reward/SevenLoginCell"..i)
    end
end

function ActSevenLogin:OnDestroy()
    self:ComponentDestroy()
    self:DeleteTimer()
    self.timer_action = nil
    base.OnDestroy(self)
end

function ActSevenLogin:ComponentDestroy()
    self._name_txt = nil
    self._time_txt = nil
end
function ActSevenLogin:OnEnable()
    base.OnEnable(self)
end

function ActSevenLogin:OnDisable()
    base.OnDisable(self)
end

function ActSevenLogin:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnRefreshSevenLogin, self.RefreshUI)
end

function ActSevenLogin:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnRefreshSevenLogin, self.RefreshUI)
end

function ActSevenLogin:SetData(activityId,actId)
    self.activityId = activityId
    self._heroName_txt:SetActive(tonumber(self.activityId) == 10000)
    --self._heroNick_txt:SetActive(tonumber(self.activityId) == 10000)
    self._rarity_img:SetActive(tonumber(self.activityId) == 10000)
    self.day = 0
    SFSNetwork.SendMessage(MsgDefines.GetSevenDayLoginInfo,toInt(self.activityId))
    local actListData = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(activityId))
    self._name_txt:SetLocalText(actListData.name)
    self._desc_txt:SetLocalText(actListData.desc_info)
    self.actData = actListData
end

function ActSevenLogin:RefreshUI()
    self.dayInfo =  DataCenter.ActSevenLoginData:GetInfoByActId(tonumber(self.activityId))
    if self.dayInfo and next(self.dayInfo) then
        local specialDay = GetTableData(TableName.ActivityPanel, toInt(self.activityId), "para2")
        local str = string.split(specialDay,";")
        if self.cell and next(self.cell) then
            for i = 1 ,7 do
                self.cell[i]:ReInit(self.dayInfo.loginReward[i],specialDay)
                for k = 1 ,table.count(str) do
                    if tonumber(str[k]) == i then
                        self.cell[i]:CreateEffect()
                    end
                end
            end 
        end
        self:RefreshBtn()
        self:RefreshTime()
        self:AddTimer()

        local heroId = nil
        for i ,v in pairs(self.dayInfo.loginReward) do
            if v.reward[1].rewardType == RewardType.HERO then
                heroId = v.reward[1].itemId
            end
        end
        if heroId then
            local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroId)
            if heroConfig ~= nil then
                local rarity = heroConfig["rarity"]
                --self.rarity_img:LoadSprite(HeroUtils.GetRarityIconName(rarity, true))
                self._heroName_txt:SetLocalText(heroConfig["name"])
                --self._heroNick_txt:SetLocalText(heroConfig["desc"])
                self._heroName_txt:SetColor(HeroUtils.GetHeroNameColorByRarity(rarity, false))
                --self._heroNick_txt:SetColor(HeroUtils.GetHeroNameColorByRarity(rarity, false))
            end
        end
        if self.day and self.day ~= 0 then
            --可领取的
            self.cell[self.day]:CreateReceiveEffect()
        end
    end
end

function ActSevenLogin:RefreshBtn()
    local isGray = false
    self.day = 0
    local day = self.dayInfo:CheckToday()
    if day then
        --今天领取过
        if day == 0 then
            isGray =  true
            self._getReward_txt:SetActive(false)
            self._getRewardGray_txt:SetActive(true)
            self._getRewardGray_txt:SetLocalText(302602)
        else
            self._getReward_txt:SetActive(true)
            self._getReward_txt:SetLocalText(170004)
            self._getRewardGray_txt:SetActive(false)
            self.day = day
        end
    else
        isGray =  true
        --过期
        self._getReward_txt:SetActive(false)
        self._getRewardGray_txt:SetActive(true)
        self._getRewardGray_txt:SetLocalText(371068)
    end
    UIGray.SetGray(self._getReward_btn.transform, isGray, not isGray)
end

--{{{弃用
function ActSevenLogin:RefreshBtns()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local time = curTime - self.actData.startTime
    local secs,delta = math.modf(time/1000)
    if delta > 0 then
        secs = secs + 1
    end
    self.day = 0
    local isGray = false
    --如果是同一天
    if UITimeManager:GetInstance():IsSameDayForServer(curTime/1000,self.actData.startTime/1000) then
        --检查第一个
        if self.dayInfo.loginReward[1].state == 0 then
            self._getReward_txt:SetActive(true)
            self._getReward_txt:SetLocalText(371058)
            self._getRewardGray_txt:SetActive(false)
            self.day = 1
        else
            isGray =  true
            self._getReward_txt:SetActive(false)
            self._getRewardGray_txt:SetActive(true)
            self._getRewardGray_txt:SetLocalText(302602)
        end
    else
        --如果不是同一天，但是相差时间小于OneDayTime，检查第二个
        if secs < OneDayTime then
            if self.dayInfo.loginReward[2].state == 0 then
                self._getReward_txt:SetActive(true)
                self._getReward_txt:SetLocalText(371058)
                self._getRewardGray_txt:SetActive(false)
                self.day = 2
            else
                isGray =  true
                self._getReward_txt:SetActive(false)
                self._getRewardGray_txt_txt:SetActive(true)
                self._getRewardGray_txt_txt:SetLocalText(302602)
            end
        else
            local secs1,delta1 = math.modf(secs / OneDayTime)
            if self.dayInfo.loginReward[secs1 + 1] and self.dayInfo.loginReward[secs1 + 1].state == 0 then
                self._getReward_txt:SetLocalText(371058)
                self._getReward_txt:SetActive(true)
                self._getRewardGray_txt:SetActive(false)
                self.day = secs1 + 1
            else
                isGray =  true
                --过期
                self._getReward_txt:SetActive(false)
                self._getRewardGray_txt:SetActive(true)
                if self.dayInfo.loginReward[secs1 + 1] then
                    self._getRewardGray_txt:SetLocalText(302602)
                else
                    self._getRewardGray_txt:SetLocalText(371068)
                end
            end
        end
    end
    UIGray.SetGray(self._getReward_btn.transform, isGray, not isGray)
end
--}}}

function ActSevenLogin:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function ActSevenLogin:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

--刷新时间
function ActSevenLogin:RefreshTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    self:RefreshBtn()
    if self.actData.endTime < curTime then
        self:DeleteTimer()
    else
        self._time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.actData.endTime - curTime))
    end
end

function ActSevenLogin:OnClickReward()
    if self.dayInfo and next(self.dayInfo) and self.day and self.day ~= 0 then
        self:DeleteTimer()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        SFSNetwork.SendMessage(MsgDefines.ReceiveSevenDayLoginReward,toInt(self.activityId),self.day)
    end
end


return ActSevenLogin