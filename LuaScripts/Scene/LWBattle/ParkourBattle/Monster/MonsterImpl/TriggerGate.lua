--门型trigger，效果为获得buff

local base = require "Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerBase"
---@class Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerGate : Scene.LWBattle.ParkourBattle.Monster.MonsterImpl.TriggerBase
local TriggerGate = BaseClass("TriggerGate",base)
local SpriteRenderer = CS.UnityEngine.SpriteRenderer
local SuperTextMesh = CS.SuperTextMesh
local TriggerEnum = require("Scene.LWBattle.ParkourBattle.TriggerEvent.TriggerEnum")


function TriggerGate:Init(logic,mgr,guid,x,y,monsterMeta)
    base.Init(self,logic,mgr,guid,x,y,monsterMeta)
    self:PreSelectHeroUuid()
end

function TriggerGate:DestroyData()
    self.preSelectHeroUuid=nil
    self.triggerType=nil
    base.DestroyData(self)
end

function TriggerGate:PreSelectHeroUuid()
    if self.preSelectHeroUuid then
        return
    end
    if not self.triggerMeta then
        return
    end
    
    local triggerType = self.triggerMeta.type
    self.triggerType = triggerType
    if triggerType == TriggerEnum.EventType.AddSingleHeroSkill 
            or triggerType == TriggerEnum.EventType.AddSingleHeroBuff 
            or triggerType == TriggerEnum.EventType.ReplaceSingleHeroNormalAttack then

        local heroes = DataCenter.LWBattleManager.logic.team.teamInitUnitIds
        if heroes then
            self.preSelectHeroUuid = heroes[math.random(#heroes)]
        end
    elseif triggerType == TriggerEnum.EventType.AddSingleHeroIdBuff then
        local para = self.triggerMeta.para
        if not string.IsNullOrEmpty(para) then
            local paraList = string.split(para, "|")
            if #paraList == 2 then
                self.preSelectHeroUuid = tonumber(paraList[1]) or 0
            end
        end
    elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdNormalAttack then
        local para = self.triggerMeta.para
        if not string.IsNullOrEmpty(para) then
            local paraList = string.split(para, "|")
            if #paraList == 2 then
                self.preSelectHeroUuid = tonumber(paraList[1]) or 0
            end
        end
    elseif triggerType == TriggerEnum.EventType.ReplaceHeroIdAppearance then
        local para = self.triggerMeta.para
        if not string.IsNullOrEmpty(para) then
            local paraList = string.split(para, "|")
            if #paraList == 2 then
                self.preSelectHeroUuid = tonumber(paraList[1]) or 0
            end
        end
        
    elseif triggerType == TriggerEnum.EventType.ThreeChoices then
        local triggerCount = self.triggerMeta.paraArray and #self.triggerMeta.paraArray or 0
        local heroes = DataCenter.LWBattleManager.logic.team.teamInitUnitIds
        if triggerCount > 0 and heroes then
            self.preSelectHeroUuid = {}
            for i = 1, triggerCount do
                table.insert(self.preSelectHeroUuid, heroes[math.random(#heroes)])
            end
        end
    end
end

--override trigger的渲染表现
function TriggerGate:InitView()
    self.gameObject.name = "TriggerGate"..self.guid
    local iconAsset = self.triggerMeta.icon
    local headIcon = nil
    
    if self.triggerType == TriggerEnum.EventType.AddSingleHeroSkill 
            or self.triggerType == TriggerEnum.EventType.AddSingleHeroBuff 
            or self.triggerType == TriggerEnum.EventType.ReplaceSingleHeroNormalAttack then
        
        --需要显示选中英雄的头像
        if self.preSelectHeroUuid then
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.preSelectHeroUuid)
            assert(heroData ~= nil, "TriggerGate.InitView heroData is nil ! heroUuid : ".. self.preSelectHeroUuid)
            headIcon = HeroUtils.GetHeroIconPath(heroData.modelId)
        end
    elseif self.triggerType == TriggerEnum.EventType.AddSingleHeroIdBuff then
        --需要显示选中英雄的头像
        if self.preSelectHeroUuid then
            local meta = DataCenter.HeroTemplateManager:GetTemplate(self.preSelectHeroUuid)
            if meta ~= nil then
                headIcon = HeroUtils.GetHeroIconPath(meta.appearance)
            end
            
        end
        
    end
    
    local text = self.triggerMeta.text
    local trans1 = self.transform:Find("tubiao/txt")
    if not IsNull(trans1) then
        local txt = trans1:GetComponent(typeof(SuperTextMesh))
        txt.text = text
    end
    local trans2 = self.transform:Find("tubiao/tubiao")
    if not IsNull(trans2) then
        local sr = trans2:GetComponent(typeof(SpriteRenderer))
        sr:LoadSprite(iconAsset)
    end
    
    local head = self.transform:Find("tubiao/headIcon")
    if not IsNull(head) then
        local sr = head:GetComponent(typeof(SpriteRenderer))
        if not string.IsNullOrEmpty(headIcon) then
            sr:LoadSprite(headIcon)
            head.gameObject:SetActive(true)
        else
            head.gameObject:SetActive(false)
        end
    end
end


--override trigger的触发效果
function TriggerGate:Trigger(colliderComponentCnt, colliderComponentArray )
    if self.battleMgr.lastTriggerZ == self.metaY then return end
    for i = 0, colliderComponentCnt-1 do
        local otherObj = colliderComponentArray[i]
        local trigger = otherObj:GetComponent(typeof(CS.CitySpaceManTrigger))
        if trigger~=nil and trigger.ObjectId~=0 then
            local obj = DataCenter.LWBattleManager.logic:GetUnit(trigger.ObjectId)
            if obj and obj.guid ~= self.guid then
                self.battleMgr.lastTriggerZ = self.metaY
                self:TriggerEvent(self.deathEvent, self.preSelectHeroUuid)
                self:Death()
                self:ShowDissolveEffect()
                break
            end
        end
    end
end


return TriggerGate
