--- Created by shimin.
--- DateTime: 2022/2/22 14:33
--- 联盟盟友特效

local GuideAllianceMemberEffect = BaseClass("GuideAllianceMemberEffect")

local normal_effect_path = "Go/VFX_mengyoutishi_glow"
local leader_effect_path = "Go/VFX_mengyoutishi_glow_zi"
local enemy_effect_path = "Go/VFX_mengyoutishi_glow_red"

--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
end

local function ComponentDefine(self)
    self.normal_effect = self.transform:Find(normal_effect_path)
    self.leader_effect = self.transform:Find(leader_effect_path)
    self.enemy_effect = self.transform:Find(enemy_effect_path)
end

local function ComponentDestroy(self)
    self.normal_effect = nil
    self.leader_effect = nil
    self.enemy_effect = nil
    self.gameObject = nil
    self.transform = nil
end


local function DataDefine(self)
    self.param = nil
end

local function DataDestroy(self)
    self.param = nil
end

local function ReInit(self,param)
    self.param = param
    if param.enemy then
        self.enemy_effect.gameObject:SetActive(true)
    else
        self.normal_effect.gameObject:SetActive(not param.isLeader)
        self.leader_effect.gameObject:SetActive(param.isLeader)
        self.enemy_effect.gameObject:SetActive(false)
    end
end

GuideAllianceMemberEffect.OnCreate = OnCreate
GuideAllianceMemberEffect.OnDestroy = OnDestroy
GuideAllianceMemberEffect.ComponentDefine = ComponentDefine
GuideAllianceMemberEffect.ComponentDestroy = ComponentDestroy
GuideAllianceMemberEffect.DataDefine = DataDefine
GuideAllianceMemberEffect.DataDestroy = DataDestroy
GuideAllianceMemberEffect.ReInit = ReInit

return GuideAllianceMemberEffect