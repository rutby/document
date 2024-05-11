-- 新联盟捐兵主界面 包括捐兵和战斗两个模块

local UIActivityALVSMain = BaseClass("UIActivityALVSMain", UIBaseView)
local base = UIBaseView
local DonateSoldierScript = require "UI.UIActivityCenterTable.Component.UIActivityALVSDonateSoldier.UIActivityALVSDonateSoldier"
local UIActivityALVSBattleScript = require "UI.UIActivityCenterTable.Component.UIActivityALVSDonateSoldier.UIActivityALVSBattle"
local Localization = CS.GameEntry.Localization

--path define
local bg_donate_path = "BgDonate"
local donate_state_safe_area_path = "DonateStateSafeArea"
local bg_attack_path = "BgAttack"
local attack_state_safe_area_path = "AttackStateSafeArea"
local donate_parent_path = "DonateParent"
local attack_parent_path = "AttackParent"


--path define end

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end


local function ComponentDefine(self)
    self.bg_donate = self:AddComponent(UIImage, bg_donate_path)
    -- 捐兵模块
    -- self.donate_state_safe_area = self:AddComponent(DonateSoldierScript, donate_state_safe_area_path)
    self.bg_attack = self:AddComponent(UIImage, bg_attack_path)
    -- 战斗模块
    -- self.attack_state_safe_area = self:AddComponent(UIActivityALVSBattleScript, attack_state_safe_area_path)
    self.donate_parent = self:AddComponent(UIBaseContainer, donate_parent_path)
    self.attack_parent = self:AddComponent(UIBaseContainer, attack_parent_path)
    
    self.timer_action = function()
        self:Update1000ms()
    end
end

local function ComponentDestroy(self)
    self.bg_donate = nil
    self.donate_state_safe_area = nil
    self.bg_attack = nil
    self.attack_state_safe_area = nil    
    self.donate_parent = nil
    self.attack_parent = nil
end
local function OnEnable(self)
    self.inited = false
    base.OnEnable(self)
    self:AddTimer()
end

local function OnDisable(self)
    self:DeleteTimer()
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.GetALVSDonateArmyActivityInfo, self.OnActivityInfoReturn)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.GetALVSDonateArmyActivityInfo, self.OnActivityInfoReturn)
    base.OnRemoveListener(self)

end

local function SetData(self,activityId,id)
    self.activityId = activityId
    self.curr_state = -1
    self.inited = false
    --进界面先发请求 获取新数据
    DataCenter.ActivityALVSDonateSoldierManager:OnGetALVSDonateSoldierActivityInfo(false)
end

local function OnActivityInfoReturn(self)
    -- 活动数据返回
    self.inited = true
    self:Update1000ms()
end

-- 在准备和进攻时期 显示一个界面
-- 在捐兵时期 显示另一个界面
-- 此方法只负责界面的切换 界面内部的状态切换在界面的OnUpdate1000ms里面处理
local function CheckShowView(self)
    local now = UITimeManager:GetInstance():GetServerTime()
    -- 准备期结束时间
    local prepareEndTime = DataCenter.ActivityALVSDonateSoldierManager:GetPrepareEndTimeStamp()
    local donateEndTime = DataCenter.ActivityALVSDonateSoldierManager:GetDonateEndTimeStamp()

    local state = -1
    if LuaEntry.Player:IsInAlliance() == false then
        state = 0
    elseif now > prepareEndTime and now <= donateEndTime then
        -- 处于捐献期
        state = 1
    elseif now < prepareEndTime then
        --假如在准备期已经有了匹配的对手 则直接进入捐献期
        local vsAlliance = DataCenter.ActivityALVSDonateSoldierManager:GetVsAllianceInfo()
        if vsAlliance ~= nil then
            state = 1
        else
            state = 0
        end
    else
        -- 处于非捐献期
        state = 0
    end

    if state ~= self.curr_state then
        self.curr_state = state
        --状态变化了 需要更新显示
        if self.curr_state == 0 then
            -- 攻击或准备阶段 或者玩家没有联盟 隐藏捐兵部分 显示攻击部分
            self.bg_donate:SetActive(false)
            self.bg_attack:SetActive(true)
            self:ShowBattlePrefab()
        else
            -- 捐兵阶段 隐藏攻击部分 显示捐兵部分
            self.bg_donate:SetActive(true)
            self.bg_attack:SetActive(false)
            self:ShowDonatePrefab()
        end

        --切换阶段刷新红点 任务红点需要被隐藏掉
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
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
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false,false,false)
    end
    self.timer:Start()
end

local function Update1000ms(self)
    if self.inited ~= true then
        return
    end

    self:CheckShowView()
    -- 哪个模块显示就走哪个update
    if self.donate_state_safe_area ~= nil and self.donate_state_safe_area:GetActive() then
        self.donate_state_safe_area:OnUpdate1000ms(0)
    elseif self.attack_state_safe_area ~= nil and self.attack_state_safe_area:GetActive() then
        self.attack_state_safe_area:OnUpdate1000ms(0)
    end
end

local function ShowBattlePrefab(self)
    self.donate_parent:RemoveComponents(DonateSoldierScript)
    if self.donate_req ~= nil then
        self:GameObjectDestroy(self.donate_req)
        self.donate_req = nil
        self.donate_state_safe_area = nil
    end

    if self.attack_state_safe_area then
        self.attack_state_safe_area:SetActive(true)
        self.attack_state_safe_area:SetData(self.activityId)
        return
    end

    if self.battle_req ~= nil then
        return
    end

    self.battle_req = self:GameObjectInstantiateAsync(UIAssets.ALVSBattlePrefabPath, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject;
        go.transform:SetParent(self.attack_parent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go:SetActive(true)

        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.attack_parent.transform)
        self.attack_state_safe_area = self.attack_parent:AddComponent(UIActivityALVSBattleScript,go.name)
        self.attack_state_safe_area:SetLocalPositionXYZ(0, 0, 0)
        self.attack_state_safe_area:SetData(self.activityId)
        self.attack_state_safe_area:SetOffsetMaxXY(0, 0)
        self.attack_state_safe_area:SetOffsetMinXY(230, 0)
        self.attack_state_safe_area:OnUpdate1000ms(0)
    end)
end

local function ShowDonatePrefab(self)
    self.attack_parent:RemoveComponents(UIActivityALVSBattleScript)
    if self.battle_req ~= nil then
        self:GameObjectDestroy(self.battle_req)
        self.battle_req = nil
        self.attack_state_safe_area = nil
    end
        
    if self.donate_state_safe_area then
        self.donate_state_safe_area:SetActive(true)
        self.donate_state_safe_area:SetData(self.activityId)
        return
    end

    if self.donate_req ~= nil then
        return
    end

    self.donate_req = self:GameObjectInstantiateAsync(UIAssets.ALVSDonatePrefabPath, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject;
        go.transform:SetParent(self.donate_parent.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go:SetActive(true)

        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.donate_parent.transform)
        self.donate_state_safe_area = self.donate_parent:AddComponent(DonateSoldierScript,go.name)
        self.donate_state_safe_area:SetLocalPositionXYZ(0, 0, 0)
        self.donate_state_safe_area:SetData(self.activityId)
        self.donate_state_safe_area:SetOffsetMaxXY(0, 0)
        self.donate_state_safe_area:SetOffsetMinXY(230, 0)
        self.donate_state_safe_area:OnUpdate1000ms(0)
    end)
end

local function DestroySelf(self)
    self.attack_parent:RemoveComponents(UIActivityALVSBattleScript)
    if self.battle_req ~= nil then
        self:GameObjectDestroy(self.battle_req)
        self.battle_req = nil
        self.attack_state_safe_area = nil
    end
    
    self.donate_parent:RemoveComponents(DonateSoldierScript)
    if self.donate_req ~= nil then
        self:GameObjectDestroy(self.donate_req)
        self.donate_req = nil
        self.donate_state_safe_area = nil
    end
end

UIActivityALVSMain.OnCreate = OnCreate
UIActivityALVSMain.OnDestroy = OnDestroy
UIActivityALVSMain.ComponentDefine = ComponentDefine
UIActivityALVSMain.ComponentDestroy = ComponentDestroy
UIActivityALVSMain.OnEnable = OnEnable
UIActivityALVSMain.OnDisable = OnDisable
UIActivityALVSMain.OnAddListener = OnAddListener
UIActivityALVSMain.OnRemoveListener = OnRemoveListener
UIActivityALVSMain.SetData = SetData
UIActivityALVSMain.CheckShowView = CheckShowView
UIActivityALVSMain.DeleteTimer = DeleteTimer
UIActivityALVSMain.AddTimer = AddTimer
UIActivityALVSMain.Update1000ms = Update1000ms
UIActivityALVSMain.OnActivityInfoReturn = OnActivityInfoReturn
UIActivityALVSMain.ShowBattlePrefab = ShowBattlePrefab
UIActivityALVSMain.ShowDonatePrefab = ShowDonatePrefab
UIActivityALVSMain.DestroySelf = DestroySelf


return UIActivityALVSMain