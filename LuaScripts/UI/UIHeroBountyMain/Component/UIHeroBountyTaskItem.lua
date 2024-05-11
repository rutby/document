---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/7/14 11:13
---
local BountyStar = require "UI.UIHeroBountyMain.Component.BountyStar"
local RewardItem = require "UI.UIWorldPoint.Component.WorldPointRewardItem"
local UIHeroBountyTaskItem = BaseClass("UIHeroBountyTaskItem",UIBaseContainer)
local base = UIBaseContainer

local name_txt_path = "mainContent/Text_name"
local quest_des_path = "mainContent/questDes"
local slider_path = "mainContent/Slider"
local slider_txt_path = "mainContent/Slider/TimeTxt"
local update_des_path = "mainContent/updateDes"
local get_reward_btn_path = "mainContent/GetReward"
local get_reward_txt_path = "mainContent/GetReward/GetRewardName"
local go_btn_path = "mainContent/GoBtn"
local go_txt_path = "mainContent/GoBtn/GoBtnName"
local main_obj_path = "mainContent"
local lock_obj_path = "LockObj"
local lock_des_path = "LockObj/lockDes"
local lock_img_path = "LockObj/img"
local special_text_path = "mainContent/SpecialText"
local reward_item_path = "mainContent/Bg/reward"
local Localization = CS.GameEntry.Localization

local showState = {
    None = 0,
    Finish = 1,--完成
    Idle = 2,--未领取
    Doing = 3,--进行中
    Wait = 4,--缓冲中
    Lock_Add_num = 5,--增加数量
    lock_add_rarity = 6,--提升品质
    lock_add_special_task = 7,--特殊任务
}
local function OnCreate(self)
    base.OnCreate(self)
    self.main_obj = self:AddComponent(UIBaseContainer,main_obj_path)
    self.lock_obj = self:AddComponent(UIBaseContainer,lock_obj_path)
    self.lock_des = self:AddComponent(UITextMeshProUGUIEx,lock_des_path)
    self.lock_img = self:AddComponent(UITextMeshProUGUIEx,lock_img_path)
    self.name_txt = self:AddComponent(UITextMeshProUGUIEx,name_txt_path)
    self.quest_des = self:AddComponent(UITextMeshProUGUIEx,quest_des_path)
    self.reward_item = self:AddComponent(RewardItem,reward_item_path)
    self.cur_star = self:AddComponent(BountyStar,"mainContent/NodeArrow")
    self.slider = self:AddComponent(UISlider,slider_path)
    self.slider_txt = self:AddComponent(UITextMeshProUGUIEx,slider_txt_path)
    self.update_des = self:AddComponent(UITextMeshProUGUIEx,update_des_path)
    self.get_reward_btn = self:AddComponent(UIButton,get_reward_btn_path)
    self.get_reward_btn:SetOnClick(function()
        self:OnGetRewardClick()
    end)
    self.get_reward_txt = self:AddComponent(UITextMeshProUGUIEx,get_reward_txt_path)
    self.go_btn = self:AddComponent(UIButton,go_btn_path)
    self.go_btn:SetOnClick(function()
        self:OnGotoClick()
    end)
    self.go_txt = self:AddComponent(UITextMeshProUGUIEx,go_txt_path)
    self.timer_action = function(temp)
        self:UpdateTime()
    end
    self.special_text = self:AddComponent(UITextMeshProUGUIEx,special_text_path)
end

local function OnDestroy(self)
    self:DeleteTimer()
    base.OnDestroy(self)
end
local function ReInit(self, data)
    self.data = data
    if self.data.state == showState.Doing or self.data.state == showState.Idle or self.data.state == showState.Finish then
        self.main_obj:SetActive(true)
        self.lock_obj:SetActive(false)
        self.name_txt:SetLocalText(self.data.name)
        if self.data.rewardStr~=nil then
            local reward = self.data.rewardStr[1]
            if reward~=nil then
                self.reward_item:RefreshData(reward)
            end
        end
        self.cur_star:SetData(tostring(self.data.rarity))
        self.name_txt:SetColor(HeroBountyRarityColor[self.data.rarity])
        self.get_reward_txt:SetLocalText(170004)
        self.go_txt:SetLocalText(390146)
        if self.data.rarity == HeroBountyRarity.Special then
            self.special_text:SetActive(true)
            self.special_text:SetLocalText(GameDialogDefine.SPECIAL)
        else
            self.special_text:SetActive(false)
        end
    else
        self.main_obj:SetActive(false)
        self.lock_obj:SetActive(true)
    end
    self:InitState()
end

local function InitState(self)
    self.sendMessage = false
    if self.data.state == showState.Finish then
        self.slider:SetActive(true)
        self.slider:SetValue(1)
        self.slider_txt:SetText(Localization:GetString("110009"))
        self.get_reward_btn:SetActive(true)
        CS.UIGray.SetGray(self.get_reward_btn.transform, self.sendMessage, true)
        local shadow = self.get_reward_txt.transform:GetComponent(typeof(CS.UnityEngine.UI.Shadow))
        if shadow then
            shadow.enabled = not self.sendMessage
        end
        self.go_btn:SetActive(false)
        self.quest_des:SetActive(false)
        self.update_des:SetText("")
        self:DeleteTimer()
    elseif self.data.state == showState.Doing then
        self.slider:SetActive(true)
        self.get_reward_btn:SetActive(false)
        self.go_btn:SetActive(false)
        self.quest_des:SetActive(false)
        self.update_des:SetText(Localization:GetString("132223"))
        self:AddTimer()
        self:UpdateTime()
    elseif self.data.state == showState.Idle then
        self.slider:SetActive(false)
        self.get_reward_btn:SetActive(false)
        self.go_btn:SetActive(true)
        self.quest_des:SetActive(true)
        self.quest_des:SetText(Localization:GetString("132216",self.data.taskTime))
        self.update_des:SetText("")
        self:DeleteTimer()
    elseif self.data.state == showState.Wait then
        self.lock_img:SetActive(false)
        self.quest_des:SetActive(false)
        self:AddTimer()
        self:UpdateTime()
    elseif self.data.state == showState.Lock_Add_num then
        self.quest_des:SetActive(false)
        self.lock_img:SetActive(true)
        self.lock_des:SetText(Localization:GetString("132203",self.data.buildLv))
        self:DeleteTimer()
    elseif self.data.state == showState.lock_add_rarity then
        self.quest_des:SetActive(false)
        self.lock_img:SetActive(false)
        self.lock_des:SetText(Localization:GetString("132204",self.data.buildLv))
        self:DeleteTimer()
    elseif self.data.state == showState.lock_add_special_task then
        self.lock_img:SetActive(false)
        self.quest_des:SetActive(false)
        self.lock_des:SetLocalText(GameDialogDefine.HERO_BOUNTY_RARITY_UNLOCK_SPECIAL_DES ,self.data.buildLv)
        self:DeleteTimer()
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function UpdateTime(self)
	if self.data==nil then
		return
	end
    if self.data.state == showState.Wait then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.data.waitEndTime-curTime
        if deltaTime>0 then
            self.lock_des:SetText(Localization:GetString("132213",UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime)))
        else
            self:DeleteTimer()
        end
    elseif self.data.state ==  showState.Doing then
        local totalTime = self.data.endTime-self.data.startTime
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.data.endTime-curTime
        if deltaTime>0 then
            local percent = math.min(1,(deltaTime/math.max(1,totalTime)))
            self.slider:SetValue(1-percent)
            self.slider_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        else
            self.slider:SetValue(1)
            self.slider_txt:SetText(Localization:GetString("110009"))
            self.view:RefreshList()
            
        end
    end
end

local function OnGotoClick(self)
    if self.data.index~=0 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroBountyTask,{ isBlur = true } ,self.data.index)
    end
end
local function OnGetRewardClick(self)
    if self.data.index~=0 and self.sendMessage == false then
        DataCenter.HeroBountyDataManager:SendReceiveMessage(self.data.index)
        self.sendMessage = true
        CS.UIGray.SetGray(self.get_reward_btn.transform, self.sendMessage, true)
        local shadow = self.get_reward_txt.transform:GetComponent(typeof(CS.UnityEngine.UI.Shadow))
        if shadow then
            shadow.enabled = not self.sendMessage
        end
    end
end
UIHeroBountyTaskItem.OnCreate = OnCreate
UIHeroBountyTaskItem.InitState = InitState
UIHeroBountyTaskItem.OnDestroy =OnDestroy
UIHeroBountyTaskItem.AddTimer = AddTimer
UIHeroBountyTaskItem.DeleteTimer =  DeleteTimer
UIHeroBountyTaskItem.UpdateTime = UpdateTime
UIHeroBountyTaskItem.ReInit = ReInit
UIHeroBountyTaskItem.OnGotoClick = OnGotoClick
UIHeroBountyTaskItem.OnGetRewardClick = OnGetRewardClick
return UIHeroBountyTaskItem