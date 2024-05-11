--- Created by shimin.
--- DateTime: 2024/2/28 20:47
--- 敲钟后小人聚集,丧尸爬出来

local BellScene = BaseClass("BellScene")
local Resource = CS.GameEntry.Resource

local MoveSpeed = 2
local ZombiePrefabList = {2,2,2,2,2,2,2,2,2,1,3,4,1,3,4}  --4:1

local StateType =
{
    Show = 1,--僵尸出现
    BackLight = 2,--僵尸退到光边缘
    ResidentCome = 3,--小人跑到篝火旁
    ShowBoss = 4,--出现boss
    ShowBossAttackEffect = 5,--出现boss攻击特效
    Close = 6,--删除
}
local BackTime = 1
local AttackNameList = {CityResidentDefines.AnimName.Walk1, CityResidentDefines.AnimName.Attack1, CityResidentDefines.AnimName.Attack2}
local RemovePos = Vector3.New(-1000, 0, -1000)
local FakeResidentUuid = -1000

local BossAttackTime = 3.8--Boss攻击时间
local BeAttackAnimTime1 = 0.7
local BeAttackAnimTime2 = 1.2
local BuildHitEffectDestroyTime = 3

local BornZombie = 
{
    {bornWaitTime = 0, pos = {Vector3.New(96.91, 0, 101.53), Vector3.New(98.32239, 0, 101.347)}, backPos = Vector3.New(96.53732, 0, 101.5783)},
    {bornWaitTime = 0, pos = {Vector3.New(103.09, 0, 96.78), Vector3.New(102.1983, 0, 98.58047)}, backPos = Vector3.New(102.9972, 0, 96.96746)},
    {bornWaitTime = 0, pos = {Vector3.New(104.4, 0, 103.91), Vector3.New(103.0513, 0, 102.7556)}, backPos = Vector3.New(104.4188, 0, 103.9261)},
    {bornWaitTime = 0, pos = {Vector3.New(101.22, 0, 105.92), Vector3.New(101.1206, 0, 103.6973)}, backPos = Vector3.New(101.201, 0, 105.4955)},
    {bornWaitTime = 0, pos = {Vector3.New(100.19, 0, 96.49), Vector3.New(100.5227, 0, 98.34252)}, backPos = Vector3.New(100.2045, 0, 96.57087)},
    {bornWaitTime = 0, pos = {Vector3.New(97.15, 0, 98.98), Vector3.New(98.60911, 0, 99.74556)}, backPos = Vector3.New(97.01517, 0, 98.90926)},
    {bornWaitTime = 4, pos = {Vector3.New(102.38, 0, 105.61), Vector3.New(101.7743, 0, 103.5866)}, backPos = Vector3.New(102.2905, 0, 105.311)},
    {bornWaitTime = 4, pos = {Vector3.New(101.13, 0, 96.3), Vector3.New(101.0747, 0, 98.30103)}, backPos = Vector3.New(101.1244, 0, 96.50172)},
    {bornWaitTime = 4, pos = {Vector3.New(97.9, 0, 98.03), Vector3.New(99.05037, 0, 99.13213)}, backPos = Vector3.New(97.75062, 0, 97.88688)},
    {bornWaitTime = 4, pos = {Vector3.New(104.35, 0, 98.76), Vector3.New(103.2445, 0, 99.49922)}, backPos = Vector3.New(104.7408, 0, 98.4987)},
    {bornWaitTime = 4, pos = {Vector3.New(102.16, 0, 96.39), Vector3.New(101.6589, 0, 98.38162)}, backPos = Vector3.New(102.0981, 0, 96.63603)},
    {bornWaitTime = 4, pos = {Vector3.New(98, 0, 104.17), Vector3.New(99.14412, 0, 102.961)}, backPos = Vector3.New(97.90687, 0, 104.2684)},
    {bornWaitTime = 8, pos = {Vector3.New(98.61, 0, 97.37), Vector3.New(99.51524, 0, 98.7449)}, backPos = Vector3.New(98.52539, 0, 97.2415)},
    {bornWaitTime = 8, pos = {Vector3.New(104.05, 0, 97.32), Vector3.New(102.7229, 0, 98.92118)}, backPos = Vector3.New(103.8716, 0, 97.5353)},
    {bornWaitTime = 8, pos = {Vector3.New(104.93, 0, 102.98), Vector3.New(103.4113, 0, 102.2148)}, backPos = Vector3.New(105.0188, 0, 103.0247)},
    {bornWaitTime = 8, pos = {Vector3.New(100.32, 0, 105.46), Vector3.New(100.593, 0, 103.6692)}, backPos = Vector3.New(100.3217, 0, 105.4486)},
    {bornWaitTime = 8, pos = {Vector3.New(97.08, 0, 103.54), Vector3.New(98.73409, 0, 102.4682)}, backPos = Vector3.New(97.22349, 0, 103.447)},
    {bornWaitTime = 8, pos = {Vector3.New(99.33, 0, 96.99), Vector3.New(99.96198, 0, 98.50751)}, backPos = Vector3.New(99.26997, 0, 96.84585)},
    {bornWaitTime = 8, pos = {Vector3.New(97.07, 0, 99.97), Vector3.New(98.38821, 0, 100.3155)}, backPos = Vector3.New(96.64702, 0, 99.85915)},
    {bornWaitTime = 8, pos = {Vector3.New(103.49, 0, 104.32), Vector3.New(102.62, 0, 103.16)}, backPos = Vector3.New(103.7, 0, 104.6)},
    {bornWaitTime = 0, pos = {Vector3.New(105.09, 0, 99.91), Vector3.New(103.6089, 0, 100.3047)}, backPos = Vector3.New(105.3482, 0, 99.84118)},
    {bornWaitTime = 0, pos = {Vector3.New(105.1, 0, 100.4), Vector3.New(103.6715, 0, 100.609)}, backPos = Vector3.New(105.4526, 0, 100.3484)},
    {bornWaitTime = 4, pos = {Vector3.New(99.55, 0, 105.11), Vector3.New(100.1017, 0, 103.5462)}, backPos = Vector3.New(99.50285, 0, 105.2436)},
}

local SecondZombie =
{
    {pos = {Vector3.New(106.64, 0, 102.13), Vector3.New(104.4318, 0, 101.6876)}, backPos = Vector3.New(105.7065, 0, 101.943)},
    {pos = {Vector3.New(100.94, 0, 90.08), Vector3.New(100.9808, 0, 97.50005)}, backPos = Vector3.New(100.9736, 0, 96.20007)},
    {pos = {Vector3.New(100.74, 0, 113.43), Vector3.New(100.9268, 0, 104.4992)}, backPos = Vector3.New(100.8996, 0, 105.799)},
    {pos = {Vector3.New(102.63, 0, 112.37), Vector3.New(101.4967, 0, 104.4646)}, backPos = Vector3.New(101.6812, 0, 105.7514)},
    {pos = {Vector3.New(97.44, 0, 117.24), Vector3.New(100.2506, 0, 104.4188)}, backPos = Vector3.New(99.97219, 0, 105.6887)},
    {pos = {Vector3.New(99.1, 0, 90.08), Vector3.New(100.4, 0, 97.5518)}, backPos = Vector3.New(100.1772, 0, 96.27105)},
    {pos = {Vector3.New(112.58, 0, 104.11), Vector3.New(104.3802, 0, 101.9078)}, backPos = Vector3.New(105.6357, 0, 102.245)},
    {pos = {Vector3.New(98, 0, 92.2), Vector3.New(99.87064, 0, 97.68722)}, backPos = Vector3.New(99.45116, 0, 96.45675)},
    {pos = {Vector3.New(99.01, 0, 91.23), Vector3.New(100.3014, 0, 97.57042)}, backPos = Vector3.New(100.042, 0, 96.29658)},
    {pos = {Vector3.New(104.66, 0, 91.89), Vector3.New(102.3048, 0, 97.7523)}, backPos = Vector3.New(102.7894, 0, 96.54601)},
    {pos = {Vector3.New(96.46, 0, 102.19), Vector3.New(97.61437, 0, 101.8874)}, backPos = Vector3.New(96.35685, 0, 102.217)},
    {pos = {Vector3.New(95.77, 0, 98.48), Vector3.New(97.84693, 0, 99.48074)}, backPos = Vector3.New(96.67579, 0, 98.91644)},
    {pos = {Vector3.New(102.96, 0, 92), Vector3.New(101.7448, 0, 97.58015)}, backPos = Vector3.New(102.0214, 0, 96.30993)},
    {pos = {Vector3.New(106.3, 0, 94.55), Vector3.New(103.222, 0, 98.29583)}, backPos = Vector3.New(104.0474, 0, 97.29142)},
    {pos = {Vector3.New(107.39, 0, 96.01), Vector3.New(103.7585, 0, 98.84583)}, backPos = Vector3.New(104.7831, 0, 98.04572)},
    {pos = {Vector3.New(93.31, 0, 93.58), Vector3.New(98.48131, 0, 98.56974)}, backPos = Vector3.New(97.54579, 0, 97.66707)},
    {pos = {Vector3.New(93.88, 0, 104.47), Vector3.New(97.85376, 0, 102.5333)}, backPos = Vector3.New(96.68516, 0, 103.1029)},
    {pos = {Vector3.New(96.3, 0, 92.33), Vector3.New(99.33198, 0, 97.92303)}, backPos = Vector3.New(98.71243, 0, 96.78017)},
    {pos = {Vector3.New(95.79, 0, 99.26), Vector3.New(97.68024, 0, 99.89129)}, backPos = Vector3.New(96.4472, 0, 99.47948)},
    {pos = {Vector3.New(106.27, 0, 105.9), Vector3.New(103.5632, 0, 103.3833)}, backPos = Vector3.New(104.5153, 0, 104.2685)},
    {pos = {Vector3.New(103.71, 0, 111.98), Vector3.New(101.8387, 0, 104.398)}, backPos = Vector3.New(102.1502, 0, 105.6602)},
    {pos = {Vector3.New(98.9, 0, 116.65), Vector3.New(100.5345, 0, 104.4689)}, backPos = Vector3.New(100.3616, 0, 105.7574)},
    {pos = {Vector3.New(101.84, 0, 117.68), Vector3.New(101.176, 0, 104.4956)}, backPos = Vector3.New(101.2414, 0, 105.7939)},

}


local ThirdZombie =
{
    {pos = {Vector3.New(93.25, 0, 106.29), Vector3.New(97.28329, 0, 103.5369)}, backPos = Vector3.New(96.87033, 0, 103.8188)},
    {pos = {Vector3.New(97.65, 0, 90.82), Vector3.New(99.59336, 0, 96.72549)}, backPos = Vector3.New(99.43707, 0, 96.25055)},
    {pos = {Vector3.New(93.79, 0, 115.18), Vector3.New(98.96043, 0, 105.0113)}, backPos = Vector3.New(98.73381, 0, 105.4569)},
    {pos = {Vector3.New(106.08, 0, 114.76), Vector3.New(102.5585, 0, 105.2215)}, backPos = Vector3.New(102.7317, 0, 105.6906)},
    {pos = {Vector3.New(90.69, 0, 101.97), Vector3.New(96.51978, 0, 101.4215)}, backPos = Vector3.New(96.02198, 0, 101.4684)},
    {pos = {Vector3.New(106.56, 0, 93.42), Vector3.New(103.6616, 0, 97.37148)}, backPos = Vector3.New(103.9573, 0, 96.96832)},
    {pos = {Vector3.New(95.6, 0, 101.29), Vector3.New(96.50648, 0, 101.2413)}, backPos = Vector3.New(96.00719, 0, 101.2681)},
    {pos = {Vector3.New(105.87, 0, 93.59), Vector3.New(103.4715, 0, 97.23946)}, backPos = Vector3.New(103.7461, 0, 96.82162)},
    {pos = {Vector3.New(109.34, 0, 99.93), Vector3.New(105.4634, 0, 100.4274)}, backPos = Vector3.New(105.9594, 0, 100.3637)},
    {pos = {Vector3.New(107.86, 0, 97.09), Vector3.New(104.9095, 0, 98.77167)}, backPos = Vector3.New(105.3439, 0, 98.52408)},
    {pos = {Vector3.New(92.89, 0, 98.21), Vector3.New(96.74477, 0, 99.53612)}, backPos = Vector3.New(96.27196, 0, 99.37346)},
    {pos = {Vector3.New(93.22, 0, 97.26), Vector3.New(96.94428, 0, 99.05034)}, backPos = Vector3.New(96.49365, 0, 98.83371)},
    {pos = {Vector3.New(93, 0, 96.39), Vector3.New(97.10103, 0, 98.75322)}, backPos = Vector3.New(96.66781, 0, 98.50358)},
    {pos = {Vector3.New(102.57, 0, 90.41), Vector3.New(101.6599, 0, 96.54865)}, backPos = Vector3.New(101.7333, 0, 96.05406)},
    {pos = {Vector3.New(109.78, 0, 102.72), Vector3.New(105.4161, 0, 101.8651)}, backPos = Vector3.New(105.9067, 0, 101.9612)},
    {pos = {Vector3.New(108.36, 0, 95.54), Vector3.New(104.6141, 0, 98.31889)}, backPos = Vector3.New(105.0157, 0, 98.021)},
    {pos = {Vector3.New(92.55, 0, 105.81), Vector3.New(97.08921, 0, 103.2261)}, backPos = Vector3.New(96.65468, 0, 103.4735)},
    {pos = {Vector3.New(101.51, 0, 90.94), Vector3.New(101.2278, 0, 96.50577)}, backPos = Vector3.New(101.2532, 0, 96.00642)},
    {pos = {Vector3.New(91.46, 0, 98.9), Vector3.New(96.60522, 0, 100.0326)}, backPos = Vector3.New(96.11691, 0, 99.92511)},
    {pos = {Vector3.New(105.96, 0, 105.29), Vector3.New(104.4035, 0, 103.9438)}, backPos = Vector3.New(104.7817, 0, 104.2709)},
    {pos = {Vector3.New(103.59, 0, 113.41), Vector3.New(101.9193, 0, 105.4051)}, backPos = Vector3.New(102.0215, 0, 105.8945)},
    {pos = {Vector3.New(98.57, 0, 112.73), Vector3.New(100.0872, 0, 105.4064)}, backPos = Vector3.New(99.98573, 0, 105.896)},
    {pos = {Vector3.New(99.78, 0, 113.69), Vector3.New(100.5694, 0, 105.4793)}, backPos = Vector3.New(100.5215, 0, 105.9771)},
}

local ResidentPos =
{
    [7] = {pos = {Vector3.New(103.1, 0, 106.47), Vector3.New(101.72, 0, 101.77)}, angle = 30},
    [5] = {pos = {Vector3.New(106.2, 0, 103.94), Vector3.New(102.26, 0, 100.62)}, angle = 90},
    [3] = {pos = {Vector3.New(104.08, 0, 97.78), Vector3.New(101.62, 0, 99.81)}, angle = 160},
    [1] = {pos = {Vector3.New(99.93, 0, 99.39), Vector3.New(100.61, 0, 99.75)}, angle = -160},
    [4] = {pos = {Vector3.New(97.38, 0, 105.28), Vector3.New(99.91, 0, 100.58)}, angle = -130},
    [6] = {pos = {Vector3.New(97.69, 0, 107.08), Vector3.New(100, 0, 101.51)}, angle = -50},
}

local build_anim_path = "ModelGo/Normal"
local HitAnimName = "hit"

function BellScene:__init()
    self:DataDefine()
end

function BellScene:__delete()
    
end

function BellScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function BellScene:DataDefine()
    self.param = {}
    DataCenter.BuildBubbleManager:HideBubbleNode()
    --DataCenter.CityHudManager:SetVisible(false)
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Hide)
    DataCenter.CityResidentManager:RemoveAllByType(CityResidentDefines.Type.Zombie)
    --大本升级条不隐藏
    local excludeList = {}
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
    if buildData ~= nil then
        excludeList[buildData.uuid] = true
    end
    DataCenter.CityHudManager:DestroyAll(excludeList)
    self.req = nil
    self.zombieList = {}
    self.timer_callback = function() 
        self:OnTimerCallBack()
    end
    DataCenter.CityResidentManager:SetCanSpawnZombie(false)
    self.timers = {}--暂停使用
    self.fakeResident = {}
    DataCenter.BuildCanCreateManager:SetCanShowEffect(false)
    self.be_attack_all_timer = nil
    self.be_attack_timer1 = nil
    self.be_attack_timer2 = nil
    self.be_attack_anim_timer_callback1 = function()
        self:OnBeAttackTimer1CallBack()
    end
    self.be_attack_anim_timer_callback2 = function()
        self:OnBeAttackTimer2CallBack()
    end
    self.be_attack_all_timer_callback = function()
        self:OnBeAttackAllTimerCallBack()
    end
end

function BellScene:DataDestroy()
    DataCenter.BuildCanCreateManager:SetCanShowEffect(true)
    self:DeleteAllTimer()
    self:DestroyZombie()
    self:DestroyFakeResident()
    self:RemoveOneTime()
    self:RemoveBeAttackAllTime()
    self:RemoveBeAttackTime1()
    self:RemoveBeAttackTime2()
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Show)
    DataCenter.BuildBubbleManager:ShowBubbleNode()
    DataCenter.CityResidentManager:SetCanSpawnZombie(true)
    DataCenter.CityResidentMovieManager:Play(CityResidentDefines.Movie.ReleaseResident)
    --DataCenter.CityHudManager:SetVisible(true)
    self:DestroyReq()
end

function BellScene:DestroyReq()
    self:DeleteLightReq()
    if self.bossEffectReq ~= nil then
        self.bossEffectReq:Destroy()
        self.bossEffectReq = nil
    end
end

function BellScene:ComponentDefine()
end

function BellScene:ComponentDestroy()
    self.buildSimpleAnim = nil
end

function BellScene:ReInit(param)
    self.param = param
    self:Create()
end

function BellScene:Create()
    if self.param.state == StateType.Show then
        self:Show()
    elseif self.param.state == StateType.BackLight then
        self:CreateLightEffect()
    elseif self.param.state == StateType.ResidentCome then
        self:ResidentCome()
    elseif self.param.state == StateType.ShowBoss then
        self:ShowBoss()
    elseif self.param.state == StateType.ShowBossAttackEffect then
        self:CreateAttackBossEffect(self:GetBossEndPos())
    elseif self.param.state == StateType.Close then
        DataCenter.GuideCityAnimManager:DestroyOneScene(self.param.sceneType)
    end
end

function BellScene:Refresh()
end

function BellScene:Show()
    --播放敲钟声音
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Zombie_Sing)
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
    if buildTemplate ~= nil then
        local centerPos = buildTemplate:GetPosition()
        for k,v in ipairs(BornZombie) do
            local uuid = DataCenter.CityResidentManager:GetNextZombieUuid()
            local timer = TimerManager:GetInstance():DelayInvoke(function()
                self.timers[uuid]:Stop()
                self.timers[uuid] = nil
                local param = {}
                param.prefabPath = string.format("Assets/Main/Prefab_Dir/Home/Zombie/A_Zombie_Home_%d.prefab", ZombiePrefabList[math.random(1, #ZombiePrefabList)])
                param.isRedEye = true
                DataCenter.CityResidentManager:AddData(uuid, CityResidentDefines.Type.Zombie, param, function()
                    local data = DataCenter.CityResidentManager:GetData(uuid)
                    if data ~= nil then
                        data:SetGuideControl(true)
                        data.atBUuid = 0
                        data:Idle()
                        data:SetPos(v.pos[1])
                        -- 指定动作
                        data:PlayAnim(CityResidentDefines.AnimName.Born1)
                        data:SetAutoAnim(false)
                        data:WaitForFinish(3.1)
                        data.onFinish = function()
                            data:PlayAnim(CityResidentDefines.AnimName.Walk1)
                            data:SetSpeed(0.1)
                            data:SetAutoAnim(false)
                            data:GoToPosDirectly(v.pos[2])
                            data.onFinish = function()
                                data:Idle()
                                data:LookAt(centerPos)
                                self:EnterIdleAttackState(data)
                            end
                        end

                        local zombieParam = {}
                        zombieParam.uuid = uuid
                        zombieParam.backPos = v.backPos
                        table.insert(self.zombieList, zombieParam)
                    end
                end)
            end, v.bornWaitTime)
            self.timers[uuid] = timer
        end

        for k,v in ipairs(SecondZombie) do
            local uuid = DataCenter.CityResidentManager:GetNextZombieUuid()
            local param = {}
            param.prefabPath = string.format("Assets/Main/Prefab_Dir/Home/Zombie/A_Zombie_Home_%d.prefab", ZombiePrefabList[math.random(1, #ZombiePrefabList)])
            param.isRedEye = true
            DataCenter.CityResidentManager:AddData(uuid, CityResidentDefines.Type.Zombie, param, function()
                local data = DataCenter.CityResidentManager:GetData(uuid)
                if data ~= nil then
                    data:SetGuideControl(true)
                    data.atBUuid = 0
                    data:Idle()
                    data:SetPos(v.pos[1])
                    -- 指定动作
                    data:PlayAnim(CityResidentDefines.AnimName.Walk1)
                    data:SetSpeed(0.2)
                    data:SetAutoAnim(false)
                    data:GoToPosDirectly(v.pos[2])
                    data.onFinish = function()
                        data:Idle()
                        data:LookAt(centerPos)
                        self:EnterIdleAttackState(data)
                    end

                    local zombieParam = {}
                    zombieParam.uuid = uuid
                    zombieParam.backPos = v.backPos
                    table.insert(self.zombieList, zombieParam)
                end
            end)
        end

        for k,v in ipairs(ThirdZombie) do
            local uuid = DataCenter.CityResidentManager:GetNextZombieUuid()
            local param = {}
            param.prefabPath = string.format("Assets/Main/Prefab_Dir/Home/Zombie/A_Zombie_Home_%d.prefab", ZombiePrefabList[math.random(1, #ZombiePrefabList)])
            param.isRedEye = true
            DataCenter.CityResidentManager:AddData(uuid, CityResidentDefines.Type.Zombie, param, function()
                local data = DataCenter.CityResidentManager:GetData(uuid)
                if data ~= nil then
                    data:SetGuideControl(true)
                    data.atBUuid = 0
                    data:Idle()
                    data:SetPos(v.pos[1])
                    -- 指定动作
                    data:PlayAnim(CityResidentDefines.AnimName.Walk1)
                    data:SetSpeed(0.2)
                    data:SetAutoAnim(false)
                    data:GoToPosDirectly(v.pos[2])
                    data.onFinish = function()
                        data:Idle()
                        data:LookAt(centerPos)
                        self:EnterIdleAttackState(data)
                    end

                    local zombieParam = {}
                    zombieParam.uuid = uuid
                    zombieParam.backPos = v.backPos
                    table.insert(self.zombieList, zombieParam)
                end
            end)
        end
    end
end

function BellScene:Pause()
    for k,v in pairs(self.timers) do
        v:Pause()
    end
    self:SetTimerPause()
end

function BellScene:Resume()
    for k,v in pairs(self.timers) do
        v:Resume()
    end
    self:SetTimerResume()
end

function BellScene:GetRandomNearMainPos(centerPos, minRadius, radius, angle)
    local index = minRadius + math.random() * radius
    local rad = angle or self:GetRandomAngle()
    local pos = centerPos + Vector3.New(math.cos(rad), 0, math.sin(rad)) * index
    return pos
end

function BellScene:GetRandomAngle()
    return math.random() * math.pi * 2
end

function BellScene:BackLight()
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
    if buildTemplate ~= nil then
        local centerPos = buildTemplate:GetPosition()
        for k,v in ipairs(self.zombieList) do
            local data = DataCenter.CityResidentManager:GetData(v.uuid)
            if data ~= nil then
                data:ClearWaitForFinish()
                local endPos = v.backPos
                -- 指定动作
                data:Idle()
                data:PlayAnim(CityResidentDefines.AnimName.Walk1)
                data:SetSpeed(3)
                data:SetAutoAnim(false)
                data:GoToPosDirectly(endPos)
                data.onFinish = function()
                    data:Idle()
                    data:LookAt(centerPos)
                    self:EnterIdleAttackState(data)
                end
            end
        end
    end
end

function BellScene:CreateLightEffect()
    self:DeleteLightReq()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.BuildMainGuideLight)
        self.req:completed('+', function()
            local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
            if buildTemplate ~= nil then
                local centerPos = buildTemplate:GetPosition()
                self.req.gameObject.transform:Set_position(centerPos.x, centerPos.y, centerPos.z)
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Zombie_Build_Upgrade)
            end
            self:AddOneTime()
        end)
    end
end

function BellScene:AddOneTime()
    self:RemoveOneTime()
    self.timer = TimerManager:GetInstance():GetTimer(BackTime, self.timer_callback, nil, true, false, false)
    self.timer:Start()
end

function BellScene:RemoveOneTime()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function BellScene:OnTimerCallBack()
    self:RemoveOneTime()
    self:BackLight()
end

function BellScene:ShowBoss()
    --显示boss
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Zombie_Boss_Show)
    local uuid = DataCenter.CityResidentManager:GetNextZombieUuid()
    local param = {}
    param.prefabPath = "Assets/Main/Prefab_Dir/Home/Zombie/A_Zombie_Home_Guide_Boss.prefab"
    DataCenter.CityResidentManager:AddData(uuid, CityResidentDefines.Type.Zombie, param, function()
        local data = DataCenter.CityResidentManager:GetData(uuid)
        if data ~= nil then
            local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
            if buildTemplate ~= nil then
                local centerPos = buildTemplate:GetPosition()
                data:SetGuideControl(true)
                data.isInvincible = true
                data.atBUuid = 0
                local startPos = centerPos + Vector3.New(0, 0, -1) * 13
                data:SetPos(startPos)

                -- 指定动作
                data:PlayAnim("run")
                data:SetSpeed(3)
                data:SetAutoAnim(false)
                data:GoToPosDirectly(self:GetBossEndPos())
                data.onFinish = function()
                    data.onFinish = nil
                    data:Idle()
                    data:PlayAnim("attack")
                    data:LookAt(centerPos)
                    --卡时间播放大本被攻击动画
                    self:DoBuildBeAttackAnim()
                end
            end
        end
    end)
    local zombieParam = {}
    zombieParam.uuid = uuid
    table.insert(self.zombieList, zombieParam)
end

function BellScene:CreateAttackBossEffect(endPos)
    if self.bossEffectReq == nil then
        self.bossEffectReq = Resource:InstantiateAsync(UIAssets.Eff_dafuw_jiaozhan_X)
        self.bossEffectReq:completed('+', function()
            self.bossEffectReq.gameObject.transform:Set_position(endPos.x, endPos.y, endPos.z)
        end)
    end
end

function BellScene:DeleteLightReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil
    end
end

function BellScene:EnterIdleAttackState(data)
    local name = AttackNameList[math.random(1, #AttackNameList)]
    data:PlayAnim(AttackNameList[math.random(1, #AttackNameList)])
    local animTime = 1
    if name == CityResidentDefines.AnimName.Attack1 then
        animTime = 1
    elseif name == CityResidentDefines.AnimName.Attack2 then
        animTime = 1.5
    end
    data:WaitForFinish(animTime)
    data.onFinish = function()
        data:PlayAnim(CityResidentDefines.AnimName.Idle)
        local time = math.random() * 2
        data:WaitForFinish(time)
        data.onFinish = function()
           self:EnterIdleAttackState(data)
        end
    end
end

function BellScene:DestroyZombie()
    for k,v in ipairs(self.zombieList) do
        DataCenter.CityResidentManager:RemoveData(v.uuid)
    end
    self.zombieList = {}
end

function BellScene:DestroyFakeResident()
    for k,v in ipairs(self.fakeResident) do
        DataCenter.CityResidentManager:RemoveData(v)
    end
    self.fakeResident = {}
end

function BellScene:DeleteAllTimer()
    for k,v in pairs(self.timers) do
        v:Stop()
    end
    self.timers = {}
end

function BellScene:ResidentCome()
    --居民走向火堆
    local list = DataCenter.CityResidentManager:GetDataListByType(CityResidentDefines.Type.Resident)
    for k,v in ipairs(list) do
        v:SetGuideControl(true)
        local data = ResidentPos[v.residentData.id]
        if data == nil then
            v.atBUuid = 0
            v:Idle()
            v:SetPos(RemovePos)
        else
            -- 指定动作
            v.atBUuid = 0
            v:Idle()
            if v.residentData.id ~= 1 then
                --摇铃人特殊处理
                v:SetPos(data.pos[1])
            end
            v:PlayAnim(CityResidentDefines.AnimName.Run)
            v:SetSpeed(MoveSpeed)
            v:SetAutoAnim(false)
            v:GoToCityPos(data.pos[2])
            v.onFinish = function()
                v.onFinish = nil
                v:Idle()
                v:PlayAnim(CityResidentDefines.AnimName.Shiver)
                v:SetRot(Quaternion.Euler(0, data.angle, 0))
            end
        end
    end
    
    self.fakeResident = {}
    local resUuid = FakeResidentUuid
    for k,v in pairs(ResidentPos) do
        local residentData = DataCenter.CityResidentManager:GetDataById(CityResidentDefines.Type.Resident, k)
        if residentData == nil then
            resUuid = resUuid - 1
            local param = {}
            param.uuid = resUuid
            param.id = k
            DataCenter.CityResidentManager:AddData(resUuid, CityResidentDefines.Type.Resident, param, function()
                local data = DataCenter.CityResidentManager:GetData(param.uuid)
                if data ~= nil then
                    -- 指定动作
                    data:SetGuideControl(true)
                    data.atBUuid = 0
                    data:Idle()
                    data:SetPos(v.pos[1])
                    data:PlayAnim(CityResidentDefines.AnimName.Run)
                    data:SetSpeed(MoveSpeed)
                    data:SetAutoAnim(false)
                    data:GoToCityPos(v.pos[2])
                    data.onFinish = function()
                        data.onFinish = nil
                        data:Idle()
                        data:PlayAnim(CityResidentDefines.AnimName.Shiver)
                        data:SetRot(Quaternion.Euler(0, v.angle, 0))
                    end
                end
            end)
            table.insert(self.fakeResident, resUuid)
        end
    end
end

function BellScene:GetBossEndPos()
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
    if buildTemplate ~= nil then
        local centerPos = buildTemplate:GetPosition()
        return centerPos + Vector3.New(0, 0, -1) * 3.5
    end
end

function BellScene:DoBuildBeAttackAnim()
    self:GetAnimGo()
    --一个3.8秒大循环计时器中套两个小的单次计时器
    self:AddBeAttackAllTime()
    self:AddBeAttackTime1()
    self:AddBeAttackTime2()
end

function BellScene:GetAnimGo()
    if self.buildSimpleAnim == nil then
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
        if buildData ~= nil then
            local city = CS.SceneManager.World:GetBuildingByPoint(buildData.pointId)
            if city ~= nil then
                local transform = city:GetTransform()
                if transform ~= nil then
                    self.buildSimpleAnim = transform:Find(build_anim_path):GetComponentInChildren(typeof(CS.SimpleAnimation))
                end
            end
        end
    end
end

function BellScene:DoBuildAnim()
    if self.buildSimpleAnim ~= nil then
        self.buildSimpleAnim:Rewind(HitAnimName)
        self.buildSimpleAnim:Play(HitAnimName)
    end
    --播放特效
    local req = Resource:InstantiateAsync(UIAssets.BuildHitEffect)
    req:completed('+', function()
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(BuildingTypes.FUN_BUILD_MAIN)
        if buildTemplate ~= nil then
            local centerPos = buildTemplate:GetPosition()
            req.gameObject.transform:Set_position(centerPos.x, centerPos.y, centerPos.z)
        end
        DataCenter.WaitTimeManager:AddOneWait(BuildHitEffectDestroyTime, function()
            req:Destroy()
        end)
    end)
end

function BellScene:AddBeAttackAllTime()
    self:RemoveBeAttackAllTime()
    self.be_attack_all_timer = TimerManager:GetInstance():GetTimer(BossAttackTime, self.be_attack_all_timer_callback, nil, false, false, false)
    self.be_attack_all_timer:Start()
end

function BellScene:RemoveBeAttackAllTime()
    if self.be_attack_all_timer ~= nil then
        self.be_attack_all_timer:Stop()
        self.be_attack_all_timer = nil
    end
end

function BellScene:OnBeAttackAllTimerCallBack()
    self:AddBeAttackTime1()
    self:AddBeAttackTime2()
end

function BellScene:AddBeAttackTime1()
    self:RemoveBeAttackTime1()
    self.be_attack_timer1 = TimerManager:GetInstance():GetTimer(BeAttackAnimTime1, self.be_attack_anim_timer_callback1, nil, true, false, false)
    self.be_attack_timer1:Start()
end

function BellScene:RemoveBeAttackTime1()
    if self.be_attack_timer1 ~= nil then
        self.be_attack_timer1:Stop()
        self.be_attack_timer1 = nil
    end
end

function BellScene:OnBeAttackTimer1CallBack()
    self:RemoveBeAttackTime1()
    self:DoBuildAnim()
end

function BellScene:AddBeAttackTime2()
    self:RemoveBeAttackTime2()
    self.be_attack_timer2 = TimerManager:GetInstance():GetTimer(BeAttackAnimTime2, self.be_attack_anim_timer_callback2, nil, true, false, false)
    self.be_attack_timer2:Start()
end

function BellScene:RemoveBeAttackTime2()
    if self.be_attack_timer2 ~= nil then
        self.be_attack_timer2:Stop()
        self.be_attack_timer2 = nil
    end
end

function BellScene:OnBeAttackTimer2CallBack()
    self:RemoveBeAttackTime2()
    self:DoBuildAnim()
end

function BellScene:SetTimerPause()
    if self.be_attack_all_timer ~= nil then
        self.be_attack_all_timer:Pause()
    end
    if self.be_attack_timer1 ~= nil then
        self.be_attack_timer1:Pause()
    end
    if self.be_attack_timer2 ~= nil then
        self.be_attack_timer2:Pause()
    end
end

function BellScene:SetTimerResume()
    if self.be_attack_all_timer ~= nil then
        self.be_attack_all_timer:Resume()
    end
    if self.be_attack_timer1 ~= nil then
        self.be_attack_timer1:Resume()
    end
    if self.be_attack_timer2 ~= nil then
        self.be_attack_timer2:Resume()
    end
end

return BellScene