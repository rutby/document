
local Resource = CS.GameEntry.Resource
local SimpleAnimationType = typeof(CS.SimpleAnimation)
local Sound = CS.GameEntry.Sound
local Const = require("Scene.PVEBattleLevel.Const")
local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)
local SuperTextMeshType = typeof(CS.SuperTextMesh)
local SpriteRendererType = typeof(CS.UnityEngine.SpriteRenderer)
local pairs = pairs
local Time = Time
---
--- 资源点表现
---
---@class Scene.PVEBattleLevel.CollectionObject
local CollectionObject = BaseClass("CollectionObject")
local CollectionBlood = require"Scene.PVEBattleLevel.CollectionBlood"

local CutStateCount = 6
local OutBuffMaxRadius = 1.2
local DigAnimName = "dig"
local DefaultColliderRadius = 1.3

local SoundEffectType = 
{
    Wood = "shu",
    Rock = "rock",
    Crystal = "crystal",
    Cactus = "cactus",
}

-- 获取字符串
local stateTable = { "state01", "state02", "state03", "state04", "state05", "state06"}
local function getStateString(k)
    if k>=1 and k<=#stateTable then
        return stateTable[k]
    end

    local modelPath = "state0" .. tostring(k)
    return modelPath
end

function CollectionObject:__init(cfg, collectionData, battleLevel)
    self.config = cfg
    self.battleLevel = battleLevel
    self.collectionData = collectionData
    self.tilePos = SceneUtils.WorldToTile(cfg.t)
    self.pointId =  SceneUtils.WorldToTileIndex(cfg.t)
    self.arrowPosId = battleLevel:GetPosId(SceneUtils.TileToWorld(self.tilePos)) 
    self.m_cutStateObj = {}
    self.m_cutStateAnim = {}
    self.visible = true
    -- 砍击特效
    self.flyParticles = {}
    -- +1 飘字
    self.flyTexts = {}
    -- 碎石列表
    self.m_blockList = {}
    self.collectionBlood = nil --血条obj
    self.index = nil
    self.soundType = nil
end

function CollectionObject:__delete()

end

function CollectionObject:Create()
    if self.config == nil or self.config.prefab == nil then
        return
    end

    self.inst = Resource:InstantiateAsync(self.config.prefab)
    self.inst:completed('+', function()
        self.gameObject = self.inst.gameObject
        self.gameObject.name = "CollectionObject_" .. tostring(self.config.id) 
        local transform = self.gameObject.transform
        local config = self.config
        local t, r, s = config.t, config.r, config.s
        transform:Set_position(t.x, t.y, t.z)
        transform:Set_eulerAngles(r.x, r.y, r.z)
        transform:Set_localScale(s.x, s.y, s.z)
        self.gameObject:SetActive(self.visible)
        self:InitModelAni()
        local collider = transform:Find("Collider")
        if collider ~= nil then
            collider.gameObject:SetActive(false)
        end
    end)
end

function CollectionObject:Destroy()
    self.battleLevel.collectionMgr:RemoveCutUpdate(self.config.id)
    
    if self.inst then
        self.inst:Destroy()
        self.inst = nil
    end

    if self.flyParticles then
        for p, t in pairs(self.flyParticles) do
            p:Destroy()
            t:Stop()
        end
        self.flyParticles = nil
    end
    if self.flyTexts then
        for p, t in pairs(self.flyTexts) do
            p:Destroy()
            t:Stop()
        end
        self.flyTexts = nil
    end
    if self.m_blockList then
        for p, _ in pairs(self.m_blockList) do
            p:Destroy()
        end
        self.m_blockList = nil
    end
    self:DestroyBlood()
end

function CollectionObject:OnUpdate()
    ---- 更新处理小碎块的旋转
    --for _,v in pairs(self.m_blockList) do
    --    local r = 1000*Time.deltaTime
    --    if v.transform then
    --        v.transform:Rotate(0, r, 0)
    --    end
    --end
    --for t, v in pairs(self.flyTexts) do
    --    if t.gameObject ~= nil then
    --        t.gameObject.transform.rotation = self.battleLevel:GetCameraRotation()
    --    end
    --end
    
    
end

function CollectionObject:SetVisible(visible)
    self.visible = visible
    if self.gameObject then
        self.gameObject:SetActive(visible)
    end
    if visible == false then
        self:DestroyBlood()
    end
end

function CollectionObject:GetTilePos()
    return self.tilePos
end

function CollectionObject:RefreshCurState()
    local _modelIndex = self:GetCurModelIndex()
    if _modelIndex ~= self.index then
        if self.index ~= nil then
            if self.m_cutStateObj[self.index] ~= nil then
                self.m_cutStateObj[self.index]:SetActive(false)
            end
        end
        self.index = _modelIndex
        if self.m_cutStateObj[self.index] ~= nil then
            self.m_cutStateObj[self.index]:SetActive(true)
        end
    end
    if (_modelIndex <= CutStateCount and self.m_cutStateAnim[_modelIndex] ~= nil) then
        if self.m_cutStateAnim[_modelIndex]:GetState(DigAnimName) ~= nil then
            if self.m_cutStateAnim[_modelIndex]:IsPlaying(DigAnimName) then
                self.m_cutStateAnim[_modelIndex]:Rewind(DigAnimName)
            else
                self.m_cutStateAnim[_modelIndex]:Play(DigAnimName)
            end
        end
    end
end

-- 获取对应模型和动画
function CollectionObject:InitModelAni()
    self.index = self:GetCurModelIndex()
    local transform = self.gameObject.transform
    for k = 1, CutStateCount do
        local modelPath = getStateString(k)
        local trans = transform:Find(modelPath)
        if (trans ~= nil) then
            self.m_cutStateObj[k] = trans.gameObject
            local simpleAnimation = trans:GetComponentInChildren(SimpleAnimationType)
            if (simpleAnimation ~= nil) then
                self.m_cutStateAnim[k] = simpleAnimation
            end
            if (k == self.index) then
                self.m_cutStateObj[k]:SetActive(true)
                if simpleAnimation ~= nil then
                    local nameStr = simpleAnimation.gameObject.name
                    for k1,v1 in pairs(SoundEffectType) do
                        if string.contains(nameStr, v1) then
                            self.soundType = v1
                            break
                        end
                    end
                end
            else
                self.m_cutStateObj[k]:SetActive(false)
            end
        end
    end
end

-- 获取当前对应的模型index。这个地方有一个需要注意的模型是从 1，2，3 ...这样排列的
function CollectionObject:GetCurModelIndex()
    local maxBlood = self.collectionData:GetMaxBlood()
    local curBlood = self.collectionData:GetCurBlood()
    if self.battleLevel:IsSkillLevel() then
        if curBlood > 0 then
            return 1
        end
        return 0
    end
    local cutBlood = maxBlood - curBlood
    local _index = math.floor((cutBlood / maxBlood) * (table.count(self.m_cutStateObj) - 1)) + 1
    return _index
end

function CollectionObject:OnCutOnce(attack)
    if self.visible then
        self.battleLevel.collectionMgr:AddCutUpdate(self.config.id, self)

        local out = self.collectionData:GetOutGoods()
        if table.count(out) > 0 then
            for k,v in pairs(out) do
                if self.battleLevel:IsCarryType(k) then
                    for i = 1, v, 1 do
                        self.battleLevel:CarryOneObject(k)
                    end
                    self.battleLevel:AddOneFlyRes(k,v)
                elseif not self.battleLevel:IsResourceType(k) then
                    self.battleLevel:ChangeResItem(k,v)
                    self.battleLevel:AddOneFlyRes(k,v)
                end
            end
        end

        self:RefreshCurState()
        -- 飞石
        --self:ShowFlyBox()
        -- 播放资源声音
        self:PlayResSound()
        -- 播放碎石特效
        self:FlyParticle()
        -- 砍最后一刀报buff
        self:OutBuff()
        if self.battleLevel:CanShowBlood() then
            -- 飞攻击血量
            self.battleLevel:AddOneFlyBlood(attack, self:GetPosition())
            --血条
            self:CheckCollectionBlood()
        end
        --闪白
        self:ShowShakeWhite()
        local curBlood = self.collectionData:GetCurBlood()
        if curBlood == 0 then
            self.battleLevel:RemoveOneArrowById(self.arrowPosId)
        end
    end
end

-- 被丧尸攻击
function CollectionObject:BeAttack(hurt)
    if self.visible then
        self.battleLevel.collectionMgr:AddCutUpdate(self.config.id, self)
        -- 刷新模型显示
        self:RefreshCurState()
        -- 播放资源声音
        self:PlayResSound()
        -- 播放碎石特效
        self:FlyParticle()
    end
end

-- 播放收集资源的声音
function CollectionObject:PlayResSound()
    if self.soundType == SoundEffectType.Rock then
        Sound:PlayEffect(table.randomArrayValue(EnumPioneerRock))
    elseif self.soundType == SoundEffectType.Crystal then
        Sound:PlayEffect(table.randomArrayValue(EnumPioneerSulphur))
    elseif self.soundType == SoundEffectType.Cactus then
        Sound:PlayEffect(table.randomArrayValue(EnumPioneerCactus))
    elseif self.soundType == SoundEffectType.Wood then
        Sound:PlayEffect(table.randomArrayValue(EnumPioneerWood))
    end
end


function CollectionObject:ShowFlyBox()
    local restype = self.collectionData:GetType()
    local resPath = Const.ResTypeFlyPrefabPath[restype]
    if (string.IsNullOrEmpty(resPath)) then
        return
    end
    local boxInst = Resource:InstantiateAsync(resPath)
    boxInst:completed('+', function(req)
        local _go = req.gameObject
        if (_go == nil) then
            return
        end

        local go_transform = _go.transform
        go_transform.position = self.gameObject.transform.position
        go_transform:Set_localScale(2.5, 2.5, 2.5)
        self.m_blockList[boxInst].transform = go_transform
        
        local obj = self.battleLevel:GetPlayer():GetInstantiateObj()
        if (obj ~= nil) then
            local desPosPath = "A_soldie_ben/sold_point"
            local destPos = obj.transform:Find(desPosPath)
            if destPos ~= nil then
                local flyControl = _go:GetComponent(typeof(CS.UIGoodsFly))
                flyControl:DoAnimBox(1, 1, go_transform.position, destPos.transform.position, function ()
                    boxInst:Destroy()
                    self.m_blockList[boxInst] = nil
                end)
            else
                boxInst:Destroy()
                self.m_blockList[boxInst] = nil
            end
        else
            boxInst:Destroy()
            self.m_blockList[boxInst] = nil
        end
        
    end)
    self.m_blockList[boxInst] = { inst = boxInst, transform = nil }

end

function CollectionObject:GetFlyNode()
    if (self.m_flyNode == nil) then
        local nodePath = "flynode"
        local nodeObject = self.gameObject.transform:Find(nodePath)
        if nodeObject then
            self.m_flyNode = nodeObject.gameObject
        end
    end

    return self.m_flyNode;
end

function CollectionObject:ShowFlyResAnim(resType,num)
    local modelName = UIAssets.CitySpaceManFlyText
    local flyTextInst = Resource:InstantiateAsync(modelName)
    flyTextInst:completed('+', function(req)
        local flyNode = self:GetFlyNode()
        if flyNode then
            local req_trans = req.gameObject.transform
            req_trans.position = flyNode.transform.position + Vector3.New(0,1,0)
            req_trans.rotation = self.battleLevel:GetCameraRotation()
            local numText = req_trans:Find("num"):GetComponent(SuperTextMeshType)
            numText.text = "+" .. num
            local spr = req_trans:Find("num/icon"):GetComponent(SpriteRendererType)
            
            local icon = nil
            local resourceType = DataCenter.PveAtomTemplateManager:GetResType(resType)
            if resourceType ~= nil then
                icon = Const.ResTypeIconPath[resourceType]
            end
            local resItemId = DataCenter.PveAtomTemplateManager:GetResItemId(resType)
            if resItemId ~= nil then
                icon = DataCenter.ResourceItemDataManager:GetIconPath(resItemId)
            end
            spr:LoadSprite(icon or Const.ResTypeIconPath[Const.CityCutResType.Stone])
        end
    end)

    local destroyTimer = TimerManager:GetInstance():GetTimer(0.8, function()
        flyTextInst:Destroy()
        self.flyTexts[flyTextInst] = nil
    end, nil, true, false, false)
    destroyTimer:Start()

    self.flyTexts[flyTextInst] = destroyTimer
end

function CollectionObject:FlyParticle()
    local particlePath = ""
    local type = self.collectionData:GetType()
    if type == Const.CityCutResType.Stone then
        particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_shitoucaiji.prefab"
    elseif type == Const.CityCutResType.Crystal then
        particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_tuohuang_shuijingcaiji.prefab"
    elseif type == Const.CityCutResType.GreenCrystal then
        particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_tuohuang_shuijingcaiji.prefab"
    elseif type == Const.CityCutResType.Cactus then
        particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_shihuang_shouge.prefab"
    elseif type == Const.CityCutResType.Wood then
        particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_shihuang_shouge.prefab"
    end
    if (particlePath == "") then
        local type2 = DataCenter.PveAtomTemplateManager:GetResType(type)
        if type2 == Const.PveResType.Stone then
            particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_shitoucaiji.prefab"
        elseif type2 == Const.PveResType.Wood then
            particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_shihuang_shouge.prefab"
        end
    end
    if (particlePath == "") then
        local type3 = DataCenter.PveAtomTemplateManager:GetResItemId(type)
        if type3 == Const.CityCutResType.ResourceItemWood then
            particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_shihuang_shouge.prefab"
        elseif type3 == Const.CityCutResType.ResourceItemStone then
            particlePath = "Assets/_Art/Effect/prefab/scene/xinshou/VFX_xinshou_shitoucaiji.prefab"
        end
    end
    if (particlePath == "") then
        return
    end
    local particleInst = Resource:InstantiateAsync(particlePath)
    particleInst:completed('+', function(req)
        local p = self.gameObject.transform.position
        req.gameObject.transform:Set_position(p.x, p.y, p.z)
        local particle = req.gameObject:GetComponent(TypeOfParticleSystem)
        particle:Simulate(0)
        particle:Play()
    end)
    local destroyTimer = TimerManager:GetInstance():GetTimer(0.6, function()
        particleInst:Destroy()
        self.flyParticles[particleInst] = nil
    end, nil, true, false, false)
    destroyTimer:Start()
    self.flyParticles[particleInst] = destroyTimer
end

function CollectionObject:OutBuff()
    if (self.collectionData:GetCurBlood() == 0) then
        DataCenter.BattleLevel:OnCutCollection(1)
        if self.collectionData.buffId ~= nil and self.collectionData.buffId > 0 and self.collectionData.outBuffRate > 0 then
            --随机掉落buff
            local result = math.random()
            if result <= self.collectionData.outBuffRate then
                --圆内随机一个点  先随机半径 在随机弧度
                local radius = math.random() * OutBuffMaxRadius
                local angle = math.random() *  2 * Mathf.PI
                local pos = self.gameObject.transform.position + Vector3.New(radius * Mathf.Cos(angle),0,radius * Mathf.Sin(angle))
                DataCenter.BattleLevel:AddOneDropBuff(self.collectionData.buffId,pos)
            end
        end
    end
end

function CollectionObject:CheckCollectionBlood()
    local curBlood = self.collectionData:GetCurBlood()
    if curBlood == 0 then
        self:DestroyBlood()
    else
        if self.collectionBlood == nil then
            local param = {}
            param.curBlood = curBlood
            param.maxBlood = self.collectionData:GetMaxBlood()
            param.rotation = self.battleLevel:GetCameraRotation()
            param.visible = true
            param.pos = self.gameObject.transform.position
            self.collectionBlood = CollectionBlood.New(param)
        else
            self.collectionBlood:RefreshBlood(curBlood, self.collectionData:GetMaxBlood())
        end
    end
end

function CollectionObject:RefreshCameraRotation(rotation)
    if self.collectionBlood ~= nil then
        self.collectionBlood:RefreshCameraRotation(rotation)
    end
end

function CollectionObject:ShowShakeWhite()

end

function CollectionObject:GetNeedPveStamina()
    if self.collectionData ~= nil then
        return self.collectionData:GetNeedPveStamina()
    end
    return 0
end

function CollectionObject:GetResType()
    return self.collectionData:GetType()
end

function CollectionObject:GetObjId()
    return self.collectionData:GetObjId()
end

function CollectionObject:GetPointId()
    return self.collectionData:GetObjId()
end

function CollectionObject:CanCollect()
    return self.visible and self.gameObject ~= nil and self.collectionData:GetCurBlood() > 0
end

function CollectionObject:NeedCheckCollider()
    return self.visible and self.gameObject ~= nil and self.collectionData:GetCurBlood() > 0
end

function CollectionObject:GetPosition()
    return self.config.t
end

--获取碰撞体大小（每种树不一样）
function CollectionObject:GetCollectRadius()
    return DefaultColliderRadius
end

function CollectionObject:DestroyBlood()
    if self.collectionBlood ~= nil then
        self.collectionBlood:Destroy()
        self.collectionBlood = nil
    end
end

return CollectionObject