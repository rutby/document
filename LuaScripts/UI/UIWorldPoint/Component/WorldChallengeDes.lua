---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime:
---
local RewardItem = require "UI.UIWorldPoint.Component.WorldPointRewardItem"
local WorldChallengeDes = BaseClass("WorldChallengeDes", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local main_obj_path = "BuildInfo"
local des_obj_path = "BuildDetails"
local content_path = "BuildInfo/ScrollView/Viewport/Content"
local time_obj_path = "BuildInfo/time"
local time_txt_path = "BuildInfo/time/timeLabel"
local tips_path = "BuildInfo/tips"
local challenge_txt_path = "BuildInfo/tips/Rect_Challenge/Txt_Challenge"
local challengeName_txt_path = "BuildInfo/tips/Rect_Challenge/Txt_ChallengeName"
local challengeType_txt_path = "BuildInfo/tips/Rect_ChallengeType/Txt_ChallengeType"
local challengeTypeName_txt_path = "BuildInfo/tips/Rect_ChallengeType/Txt_ChallengeTypeName"
local des_txt_path = "BuildDetails/desTxt"
local power_rect_path = "BuildInfo/powerRecommend"
local power_txt_path = "BuildInfo/powerRecommend/Recommend_Power"
local animator_path = ""
-- 创建
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

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    self:OnReturnClick()
    self:DeleteTimer()
    base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
    self.animator = self:AddComponent(UIAnimator, animator_path)
    self.main_obj = self:AddComponent(UIBaseContainer,main_obj_path)
    self.des_obj = self:AddComponent(UIBaseContainer,des_obj_path)
    self.main_obj_canvas = self:AddComponent(UICanvasGroup,main_obj_path)
    self.des_obj_canvas = self:AddComponent(UICanvasGroup,des_obj_path)
    self.main_obj_canvas:SetAlpha(1)
    self.des_obj_canvas:SetAlpha(1)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    self.time_obj = self:AddComponent(UIBaseContainer,time_obj_path)
    self.time_txt = self:AddComponent(UITextMeshProUGUIEx,time_txt_path)
    
    self._challenge_txt = self:AddComponent(UITextMeshProUGUIEx,challenge_txt_path)
    self._challengeName_txt = self:AddComponent(UITextMeshProUGUIEx,challengeName_txt_path)
    self._challengeType_txt = self:AddComponent(UITextMeshProUGUIEx,challengeType_txt_path)
    self._challengeTypeName_txt = self:AddComponent(UITextMeshProUGUIEx,challengeTypeName_txt_path)
    self.des_txt = self:AddComponent(UITextMeshProUGUIEx,des_txt_path)
    self.power_rect = self:AddComponent(UIBaseContainer,power_rect_path)
    self.power_txt = self:AddComponent(UITextMeshProUGUIEx,power_txt_path)
    self.tips_path = self:AddComponent(UIBaseContainer,tips_path)
end

--控件的销毁
local function ComponentDestroy(self)
    self.btn = nil
    self.btnImage = nil
    self.power_txt = nil
    self.power_rect = nil
end

--变量的定义
local function DataDefine(self)
    self.data = nil
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

--变量的销毁
local function DataDestroy(self)
    self.data = nil
end

local function SetAllCellDestroy(self)
    self.content:RemoveComponents(RewardItem)
    if self.model~=nil then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.model ={}
end
local function RefreshData(self,param)
    self.data = param
    --self.des_txt:SetLocalText(self.data.des)
   
    self.tips_path:SetActive(true)
    self.power_rect:SetActive(false)
    self.time_obj:SetActive(true)
    self._challenge_txt:SetLocalText(100184)
    self._challengeName_txt:SetText(self.data.ownerName)
    self._challengeType_txt:SetLocalText(372429)
    if param.callHelp == 0 then
        self._challengeTypeName_txt:SetLocalText(372430)
    else
        self._challengeTypeName_txt:SetLocalText(372431)
    end
    self:AddTimer()
    self:RefreshTime()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.tips_path.rectTransform)
    self:SetAllCellDestroy()
    local list = self.data.rewardStr
    if list~=nil then
        local num =0
        for i = 1, table.length(list) do
            --复制基础prefab，每次循环创建一次
            num = num+1
            self.model[i] = self:GameObjectInstantiateAsync(UIAssets.WorldPointRewardItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.content:AddComponent(RewardItem,nameStr)
                cell:RefreshData(list[i])
            end)
        end
    end
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
    if self.data == nil then
        return
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.data.refreshTime - curTime
    if self.data~=nil and deltaTime>0 then
        self.time_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
        self.time_obj:SetActive(false)
        self.time_txt:SetText("")
        self:DeleteTimer()
    end
end

local function OnInfoClick(self)
    self.animator:Enable(true)
    self.animator:Play("switchEnter",0,0)
end
--返回
local function OnReturnClick(self)
    self.animator:Enable(true)
    self.animator:Play("switchOut",0,0)
end

local function RefreshServerData(self,serverData)
    local ownerName = serverData.ownerName
    self._challengeName_txt:SetText(ownerName)
end

WorldChallengeDes.OnCreate = OnCreate
WorldChallengeDes.OnDestroy = OnDestroy
WorldChallengeDes.OnEnable = OnEnable
WorldChallengeDes.OnDisable = OnDisable
WorldChallengeDes.ComponentDefine = ComponentDefine
WorldChallengeDes.ComponentDestroy = ComponentDestroy
WorldChallengeDes.DataDefine = DataDefine
WorldChallengeDes.DataDestroy = DataDestroy
WorldChallengeDes.AddTimer = AddTimer
WorldChallengeDes.DeleteTimer = DeleteTimer
WorldChallengeDes.RefreshTime = RefreshTime
WorldChallengeDes.RefreshData = RefreshData
WorldChallengeDes.SetAllCellDestroy = SetAllCellDestroy
WorldChallengeDes.OnReturnClick =OnReturnClick
WorldChallengeDes.OnInfoClick = OnInfoClick
WorldChallengeDes.RefreshServerData = RefreshServerData
return WorldChallengeDes