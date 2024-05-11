---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/5/16 10:45
---
local AllianceActMineBloodTip = BaseClass("AllianceActMineBloodTip")
local hp_spr_path = "PosGo/Bg/Bg1/hp"
local hp_red_spr_path ="PosGo/Bg/Bg1/hpRed"
local blood_num_path = "PosGo/Bg/Bg1/bloodNum"
local icon_path = "PosGo/Bg/Bg1/headIcon"
local ResourceManager = CS.GameEntry.Resource
local Localization = CS.GameEntry.Localization
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
    self:RemoveTimer()
    self:SetHP(1,1)
    self:ComponentDestroy()
end

local function ComponentDefine(self)
    self.hp_spr = self.transform:Find(hp_spr_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.hp_spr_red = self.transform:Find(hp_red_spr_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    --self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.blood_num = self.transform:Find(blood_num_path):GetComponent(typeof(CS.SuperTextMesh))
    self.cacheHpImg = ""
    self.startBloodPercent = 0
    self.endBloodPercent = 0
    self.isDoAnim = false
    self.checkTime = 0
    self.__update_handle = function() self:Update() end
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
end

local function ComponentDestroy(self)
    self.hp_spr = nil
    self.icon = nil
    self.attack_name = nil
    self.blood_num = nil
    self.cacheHpImg = nil
    self.cacheBloodPercent =nil
end

local function RemoveTimer(self)
    UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
    self.__update_handle = nil
end



local function ShowBloodInfo(self,buildPointData,initHealth,curHealth)
    self.checkTime = 0
    local tileSize =3
    local detailInfo = PBController.ParsePbFromBytes(buildPointData.extraInfo, "protobuf.AllianceBuildingPointInfo")
    if detailInfo~=nil then
        local worldPos = BuildingUtils.GetBuildModelDownVec(buildPointData.mainIndex,tileSize)
        self.transform.position = worldPos
    end
    self:SetHP(curHealth,initHealth)
end



local function SetHP(self,hp,maxhp)
    if IsNull(self.gameObject) then
        return
    end
    local percent =  hp/math.max(maxhp,1)
    if percent<=0 then
        percent = 0
    elseif percent>=1 then
        percent = 1
    end
    self.blood_num.text = string.GetFormattedPercentStr(percent)
    self.curTime =0
    self.startBloodPercent = self.endBloodPercent
    self.endBloodPercent = percent
    if self.startBloodPercent~=0 then
        self.hp_spr_red.size = Vector2.New((self.startBloodPercent*2.81),0.4)
        self.deltaPro = self.endBloodPercent - self.startBloodPercent
        self.isDoAnim = true
        self:Update()
    end
    local spr = ""
    if percent<0.3 then
        spr ="Assets/Main/Sprites/UI/UIWorldBattle/UIWorldBattle_pro_monster_red.png"
    elseif percent>=0.3 and percent<0.7 then
        spr ="Assets/Main/Sprites/UI/UIWorldBattle/UIWorldBattle_pro_monster_yellow.png"
    elseif percent>=0.7 then
        spr ="Assets/Main/Sprites/UI/UIWorldBattle/UIWorldBattle_pro_monster_green.png"
    end
    if self.cacheHpImg~=spr then
        self.hp_spr:LoadSprite(spr)
        self.cacheHpImg =spr
    end
    self.hp_spr.size = Vector2.New((percent*2.81),0.4)
end

local function Update(self)
    if self.isDoAnim then
        self.checkTime = 0
        self.curTime = self.curTime+Time.deltaTime
        if self.curTime > 0.3 then
            if IsNull(self.gameObject) ==false then
                self.hp_spr_red.size = Vector2.New((self.endBloodPercent*2.81),0.4)
            end
            self.isDoAnim = false
        else
            local changePro = (self.curTime/0.3)
            local curPro = self.startBloodPercent + (changePro*self.deltaPro)
            if curPro<0 then
                curPro =0
            elseif curPro>=1 then
                curPro = 1
            end
            if IsNull(self.gameObject) ==false then
                self.hp_spr_red.size = Vector2.New((curPro*2.81),0.4)
            end
        end
    end
    if self.checkTime~=nil then
        self.checkTime = self.checkTime +Time.deltaTime
        if self.checkTime>=2 then
            self.checkTime =0
            AllianceActMineBloodManager:GetInstance():RemoveOneEffect(self.uuid)
        end
    end
end

AllianceActMineBloodTip.OnCreate = OnCreate
AllianceActMineBloodTip.OnDestroy = OnDestroy
AllianceActMineBloodTip.ComponentDefine = ComponentDefine
AllianceActMineBloodTip.ComponentDestroy = ComponentDestroy
AllianceActMineBloodTip.SetHP = SetHP
AllianceActMineBloodTip.ShowBloodInfo=ShowBloodInfo
AllianceActMineBloodTip.Update =Update
AllianceActMineBloodTip.RemoveTimer = RemoveTimer
return AllianceActMineBloodTip