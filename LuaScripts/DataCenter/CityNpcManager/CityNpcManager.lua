
--序章npc管理器
local CityNpcManager = BaseClass("CityNpcManager")

function CityNpcManager:__init()
    self.npc = {}
    self.protectNpc = {}
    self.talkDataDict = {}
    self.followCamera = nil
    self.visible = true
end

function CityNpcManager:__delete()
    self:RemoveAll(true)
    self.npc = {}
    self.protectNpc = {}
    self.talkDataDict = nil
    self.followCamera = nil
    self.visible = true
end

function CityNpcManager:AddOneNpc(modelName, posArr, aniName, angle, nextType, npcFuncType, moveType)
    --if self.npc[modelName] == nil then
    --    self.npc[modelName] = CityNpc.New()
    --end
    --local param = self.npc[modelName].param
    --param.modelName = modelName
    --param.posArr = posArr
    --param.animName = aniName
    --param.angle = angle
    --param.nextType = nextType
    --param.follow = (self.followCamera == modelName)
    --param.npcFuncType = npcFuncType
    --param.visible = self.visible
    --param.moveType = moveType or NpcMoveType.Normal
    --self.npc[modelName]:ReInit(param)
end

function CityNpcManager:RemoveOneNpc(modelName)
    if self.npc[modelName] ~= nil then
        self.npc[modelName]:Destroy()
        self.npc[modelName] = nil
    end
end

function CityNpcManager:SaveArchive()
end

function CityNpcManager:RemoveAll(includeProtect)
    for t, n in pairs(self.npc) do
        if includeProtect or not self.protectNpc[t] then
            self:RemoveOneNpc(t)
        end
    end
end

function CityNpcManager:ProtectNpc(modelName, protect)
    self.protectNpc[modelName] = protect
end

function CityNpcManager:GetNpcObjectByName(modelName)
    if self.npc[modelName] ~= nil then
        return self.npc[modelName].gameObject
    end
    return nil
end

function CityNpcManager:ToggleNpcTalkTrigger(modelName, t, data)
    if self.npc[modelName] ~= nil then
        local obj = self:GetNpcObjectByName(modelName)
        if obj ~= nil then
            local instanceId = obj:GetInstanceID()
            self.talkDataDict[instanceId] = data
        end
    end
end

function CityNpcManager:GetNpcTalkData(instanceId)
    return self.talkDataDict[instanceId]
end

function CityNpcManager:GetNpcPositionByName(modelName)
    if self.npc[modelName] ~= nil then
        return self.npc[modelName]:GetPosition()
    end
end

function CityNpcManager:SetFollowNpc(npcName)
    if self.followCamera ~= npcName then
        if self.followCamera ~= nil then
            if self.npc[self.followCamera] ~= nil then
                self.npc[self.followCamera]:SetFollow(false)
            end
        end
        if npcName ~= nil then
            if self.npc[npcName] ~= nil then
                self.npc[npcName]:SetFollow(true)
            end
        end
        self.followCamera = npcName
    end
end

function CityNpcManager:SetNpcVisible(visible)
    if self.visible ~= visible then
        self.visible = visible
        for k, v in pairs(self.npc) do
            v:SetVisible(visible)
            local param = {}
            param.target = v.transform
            param.visible = visible
            EventManager:GetInstance():Broadcast(EventId.RefreshNpcTalkBubbleActive, param)
        end
    end
end

return CityNpcManager