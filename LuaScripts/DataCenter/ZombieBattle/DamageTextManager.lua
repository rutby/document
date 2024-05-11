---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by w.
--- DateTime: 2022/12/14 11:21
---

---@class DataCenter.ZombieBattle.DamageTextManager
local DamageTextManager = BaseClass("DamageTextManager")
local DamageText = require "DataCenter.ZombieBattle.DamageText"
local Resource = CS.GameEntry.Resource

local DamageFlyText = "Assets/Main/Prefabs/LWBattle/DamageFlyText.prefab"
local BuffFlyText = "Assets/Main/Prefabs/LWBattle/BuffFlyText.prefab"

local InitPreHeatCount = 64
local HidePos = Vector3.New(-1000, 0, -1000)

function DamageTextManager:__init()

end

function DamageTextManager:__delete()
    self:Destroy()
end

function DamageTextManager:Init()
    self.index = 0
    self.preHeatCount = InitPreHeatCount
    self.flyTexts = {} -- Dict<index, DamageText>
    self.activeFlyTexts = {} -- Dict<index, DamageText>
    self.inactiveFlyTexts = {} -- Dict<index, DamageText>
end

function DamageTextManager:Destroy()
    if self.flyTexts then
        for _, t in pairs(self.flyTexts) do
            t:Destroy()
        end
    end
    self.flyTexts = {}
    self.activeFlyTexts = {}
    self.inactiveFlyTexts = {}
end

function DamageTextManager:GenText(damage, position, style, damageType, isCritical)
    local prefabPath
    if style == DamageTextType.GetBuff then
        prefabPath = BuffFlyText
    else
        prefabPath = DamageFlyText
    end
    
    self:Spawn(prefabPath, false, function(t)
        t:SetData(damage, position, style, damageType, isCritical)
        t.time = 1
    end)
end

function DamageTextManager:Spawn(prefabPath, mustInstantiate, callback)
    if not mustInstantiate then
        for index, t in pairs(self.inactiveFlyTexts) do
            if t.prefabPath == prefabPath then
                self.activeFlyTexts[index] = t
                self.inactiveFlyTexts[index] = nil
                if callback then
                    callback(t)
                end
                return
            end
        end
    end
    
    local index = self.index + 1
    self.index = index
    
    local t = DamageText.New()
    t.prefabPath = prefabPath
    t.req = Resource:InstantiateAsync(prefabPath)
    t.req:completed('+', function()
        self.activeFlyTexts[index] = t
        t:Create()
        t.gameObject.name = "DamageText_" .. index
        if callback then
            callback(t)
        end
    end)
    
    self.flyTexts[index] = t
    if index > self.preHeatCount then
        self.preHeatCount = self.preHeatCount * 2
    end
end

function DamageTextManager:Kill(index)
    local t = self.activeFlyTexts[index]
    t.transform.position = HidePos
    self.activeFlyTexts[index] = nil
    self.inactiveFlyTexts[index] = t
end

function DamageTextManager:OnUpdate()
    if self.index < self.preHeatCount then
        self:Spawn(DamageFlyText, true, function(t)
            t.time = 0
            t.transform.position = HidePos
        end)
    end
    local deltaTime = Time.deltaTime
    for index, t in pairs(self.activeFlyTexts) do
        if t.time < 0 then
            self:Kill(index)
        else
            t.time = t.time - deltaTime
        end
    end
    --print("beef active " .. table.count(self.activeFlyTexts))
    --print("beef inactive " .. table.count(self.inactiveFlyTexts))
    --print("beef total " .. table.count(self.flyTexts))
    --print("beef ---------------")
end

return DamageTextManager