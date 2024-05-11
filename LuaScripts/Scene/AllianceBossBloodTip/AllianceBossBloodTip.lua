---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/4/25 14:44
---
local AllianceBossBloodTip = BaseClass("AllianceBossBloodTip")
local soldier_num_text_path = "PosGo/Bg/Bg1/soldierNum"
local soldier_slider_A_path = "PosGo/Bg/Bg1/solidierSliderA"
local soldier_slider_B_path = "PosGo/Bg/Bg1/solidierSliderB"
local soldier_slider_Mid_path = "PosGo/Bg/Bg1/solidierSliderMid"
local box_num_path = "PosGo/Bg/Bg1/BoxNum"
local soldier_icon_path = "PosGo/Bg/Bg1/headIcon"
local title_path = "PosGo/Bg/Bg1/Title"

local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
local SliderSoliderLength = Vector2.New(2.6,0.26)
local BloodColorList = {"UIActivityPirates_pro1","UIActivityPirates_pro1.2","UIActivityPirates_pro1.3","UIActivityPirates_pro1.4"}

--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.request = go
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
end

local function ComponentDefine(self)
    self.soldier_num_text = self.transform:Find(soldier_num_text_path):GetComponent(typeof(CS.SuperTextMesh))
    self.box_num_text = self.transform:Find(box_num_path):GetComponent(typeof(CS.SuperTextMesh))
    self.soldier_slider_A = self.transform:Find(soldier_slider_A_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.soldier_slider_B = self.transform:Find(soldier_slider_B_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.soldier_slider_Mid = self.transform:Find(soldier_slider_Mid_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.title = self.transform:Find(title_path):GetComponent(typeof(CS.SuperTextMesh))
    self.title.text = Localization:GetString("302180")
    
    self.curSoldierSize = Vector2.New(SliderSoliderLength.x,SliderSoliderLength.y)
    self.cacheHpAImg =""
    self.cacheHpBImg =""
    self.isDoSoldierAnim = false
    self.lastPercent = 0
    self.targetPercent = 0
    self.deltaPercent = 0
    self.curSoldierTime = 0
    self.__update_handle = function() self:Update() end
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end

local function ComponentDestroy(self)
    self:RemoveTimer()
end

local function RemoveTimer(self)
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
end


local function ShowMarchInfo(self,marchInfo)
    self.data = marchInfo
    self.oneBloodSize = LuaEntry.DataConfig:TryGetNum("ship_boss", "k8")
    local monsterInfo = PBController.ParsePbFromBytes(self.data.extraInfo, "protobuf.WorldPointMonster")
    if monsterInfo~=nil and monsterInfo.type == NewMarchType.PUZZLE_BOSS then
        self.oneBloodSize = LuaEntry.DataConfig:TryGetNum("activity_puzzle", "k5")
    end
    self.soliderCurValue = 500000000
    self.soldierValue = 500000000
    self.totalCount = math.floor(self.soldierValue/math.max(self.oneBloodSize,100))
    
    --self:UpdatePosition()
    self:RefreshSoldierSlider(false)
end

local function UpdatePosition(self)
    if IsNull(self.gameObject) then
        return
    end
    local worldPos = self.data:GetMarchCurPos()
    self.transform.position = worldPos
end

local function RefreshSoldierSlider(self, useAnim)
    if IsNull(self.gameObject) then
        return
    end

    local currDamage = DataCenter.AllianceBossManager:GetCurrBossSelfDamage()
    if currDamage == nil then
        currDamage = 0
    end

    local damageShowArr = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
    --上一级的最大伤害量
    local lastLevelDamage = 0
    --当前等级的最大伤害量
    local currLevelDeltaDamage = 0

    local targetLv = 1
    local targetDamage = 0

    for k,v in ipairs(damageShowArr) do 
        currLevelDeltaDamage = v.damage - lastLevelDamage
        if v.damage > currDamage then
            break
        end
        targetLv = k
        lastLevelDamage = v.damage
    end

    --当前等级内的伤害量
    local curLevelDamage = currDamage - lastLevelDamage
    targetDamage = curLevelDamage

    if useAnim == true then
        self.targetLv = targetLv
        self.targetDamage = targetDamage
        self.isDoSoldierAnim = true
    else
        --不使用动画 直接设置当前伤害量和伤害等级
        self.curLv = targetLv
        self.targetLv = targetLv
        self.curDamage = targetDamage
        self.targetDamage = targetDamage

        local damageLevelInfo = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
        local delta = self.targetDamage - self.curDamage
        local lerpValue = delta / 10
        if lerpValue < 1 then
            lerpValue = 1
        end

        local curLvMaxDamage = damageLevelInfo[self.curLv].damage
        local curFrameDamage = self.curDamage + lerpValue
        if curFrameDamage > self.targetDamage then
            curFrameDamage = self.targetDamage
        end

        if curFrameDamage > curLvMaxDamage then
            curFrameDamage = curLvMaxDamage
        end

        local progressBarPercent = curFrameDamage / curLvMaxDamage

        self.curSoldierSize.x = SliderSoliderLength.x * progressBarPercent
        self.soldier_slider_B.size = self.curSoldierSize
        self.curDamage = curFrameDamage
        self.soldier_num_text.text = tostring(math.floor(curFrameDamage)) .. "/" .. tostring(math.floor(curLvMaxDamage))
    end
  
end

local function RefreshSoldierData(self)

    self:RefreshSoldierSlider(true)
end

local function Update(self)
    if self.targetLv > self.curLv then
        -- 要到下一级 按固定速度增长
        local damageLevelInfo = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
        local curLvMaxDamage = damageLevelInfo[self.curLv].damage
        local increasePerFrame = curLvMaxDamage / 10 -- 

        --当前帧要移动到的经验值
        local curFrameDamage = self.curDamage + increasePerFrame
        if curFrameDamage >= curLvMaxDamage then
            -- 判断是否达到了最大等级
            local isMaxLv = damageLevelInfo[self.curLv] == nil
            if isMaxLv then
                curFrameDamage = curLvMaxDamage
                self.curDamage = curLvMaxDamage
            else
                curFrameDamage = curLvMaxDamage
                self.curLv = self.curLv + 1
                
                self.curDamage = 0
            end
        else
            self.curDamage = curFrameDamage
        end

        local progressBarPercent = curFrameDamage / curLvMaxDamage
        self.curSoldierSize.x = SliderSoliderLength.x * progressBarPercent
        self.soldier_slider_B.size = self.curSoldierSize
        self.soldier_num_text.text = tostring(math.floor(curFrameDamage)) .. "/" .. tostring(math.floor(curLvMaxDamage))
        self.box_num_text.text = tostring("x" .. self.curLv)
    else
        -- 已经在目标等级 判断目标经验是否更高
        if self.targetDamage > self.curDamage then
            -- 插值
            local damageLevelInfo = DataCenter.AllianceBossManager:GetDamageRewardCellsData()
            local delta = self.targetDamage - self.curDamage
            local lerpValue = delta / 10
            if lerpValue < 1 then
                lerpValue = 1
            end

            local curLvMaxDamage = damageLevelInfo[self.curLv].damage
            local curFrameDamage = self.curDamage + lerpValue
            if curFrameDamage > self.targetDamage then
                curFrameDamage = self.targetDamage
            end

            if curFrameDamage > curLvMaxDamage then
                curFrameDamage = curLvMaxDamage
            end

            local progressBarPercent = curFrameDamage / curLvMaxDamage
            -- self.soldier_slider_B:SetValue(progressBarPercent)
            self.curSoldierSize.x = SliderSoliderLength.x * progressBarPercent
            self.soldier_slider_B.size = self.curSoldierSize
            self.curDamage = curFrameDamage
            self.soldier_num_text.text = tostring(math.floor(curFrameDamage)) .. "/" .. tostring(math.floor(curLvMaxDamage))
            self.box_num_text.text = tostring("x" .. self.curLv)
        end
    end
end




AllianceBossBloodTip.OnCreate = OnCreate
AllianceBossBloodTip.OnDestroy = OnDestroy
AllianceBossBloodTip.ComponentDefine = ComponentDefine
AllianceBossBloodTip.ComponentDestroy = ComponentDestroy
AllianceBossBloodTip.ShowMarchInfo =ShowMarchInfo
AllianceBossBloodTip.UpdatePosition =UpdatePosition
AllianceBossBloodTip.RefreshSoldierSlider =RefreshSoldierSlider
AllianceBossBloodTip.RefreshSoldierData =RefreshSoldierData
AllianceBossBloodTip.Update =Update
AllianceBossBloodTip.RemoveTimer = RemoveTimer
return AllianceBossBloodTip