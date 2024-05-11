---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2023/1/6 15:21
---
local SkillManager = BaseClass("SkillManager")
local Skill = require("Scene.PVEBattleLevel.Character.Skill.Skill")
local Messenger = require "Framework.Common.Messenger"

PveSkillEventId = {
    SkillComplete = "skill_complete_event"
}

function SkillManager:__init(owner)
    self.m_owner = owner
    self.m_skills = {}
    self.m_currentSkill = nil
    self.m_messenger = Messenger.New()
end

function SkillManager:OnUpdate(deltaTime)
    if self.m_currentSkill ~= nil then
        self.m_currentSkill:OnUpdate(deltaTime)
    end
end

function SkillManager:DoSkill(skillId,target)
    if self.m_currentSkill ~= nil then 
        return 
    end
    local skill = self:__createSkill(skillId)
    skill:Start()
    self.m_currentSkill = skill
end

function SkillManager:__createSkill(skillId)
    if IsNull(skillId) then
        return
    end
    
    local skill = self.m_skills[skillId]
    if skill == nil then
        skill = Skill.New(self.m_owner,skillId,function() self:OnSkillComplete() end)
        self.m_skills[skillId] = skill
    end
    
    return skill
end

function SkillManager:OnSkillComplete()
    self.m_currentSkill = nil
    self:Broadcast(PveSkillEventId.SkillComplete)
end

function SkillManager:AddListener( eventId, handler)
    if self.m_messenger ~= nil then
        self.m_messenger:AddListener(eventId, handler)
    end
end

function SkillManager:RemoveListener( eventId, handler)
    if self.m_messenger ~= nil then
        self.m_messenger:RemoveListener(eventId, handler)
    end
end

function SkillManager:Broadcast(eventId,userData)
    if self.m_messenger ~= nil then
        self.m_messenger:Broadcast(eventId, userData)
    end
end

function SkillManager:DestroySkillList()
    for _,v in pairs(self.m_skills) do
        v:Destroy()
    end
    self.m_skills = {}
end

function SkillManager:Destroy()
    self.m_owner = nil
    self.m_currentSkill = nil
    self.m_messenger:Cleanup()
    self.m_messenger = nil
    self:DestroySkillList()
end

return SkillManager