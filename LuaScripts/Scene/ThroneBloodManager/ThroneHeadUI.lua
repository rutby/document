---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/3/24 15:55
---
local ThroneHeadUI = BaseClass("ThroneHeadUI")
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
    self.icon = self.transform:Find(icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
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



local function ShowBloodInfo(self,uuid,initHealth,curHealth)
    self.checkTime = 0
    self.uuid = uuid
    local info = DataCenter.WorldMarchDataManager:GetMarch(self.uuid)
    if info~=nil then
        --local posV3 = info.position
        local template = DataCenter.AllianceCityTemplateManager:GetTemplate(THRONE_ID)
        if template~=nil then
            local posV3 = SceneUtils.TileToWorld(template.center)
            self.transform.position = posV3
        end
        
        local armyInfo = info:GetFirstArmyInfo()
        if armyInfo~=nil and armyInfo.HeroInfos~=nil  then
            local heroData = armyInfo.HeroInfos[1]
            if heroData~=nil then
                local icon = HeroUtils.GetHeroIconRoundPath(heroData.heroId)
                self.icon:LoadSprite(icon)
            end
        end
    end
    self:SetHP(curHealth,initHealth)
end



local function SetHP(self,hp,maxhp)
    if IsNull(self.gameObject) then
        return
    end
    if hp>1 then
        self.blood_num.text = hp
    else
        self.blood_num.text = ""
    end
    local percent =  hp/math.max(maxhp,1)
    if percent<=0 then
        percent = 0
    elseif percent>=1 then
        percent = 1
    end
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
            ThroneBloodManager:GetInstance():RemoveOneEffect(self.uuid)
        end
    end
end

ThroneHeadUI.OnCreate = OnCreate
ThroneHeadUI.OnDestroy = OnDestroy
ThroneHeadUI.ComponentDefine = ComponentDefine
ThroneHeadUI.ComponentDestroy = ComponentDestroy
ThroneHeadUI.SetHP = SetHP
ThroneHeadUI.ShowBloodInfo=ShowBloodInfo
ThroneHeadUI.Update =Update
ThroneHeadUI.RemoveTimer = RemoveTimer
return ThroneHeadUI