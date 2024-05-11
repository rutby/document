--- Created by shimin.
--- DateTime: 2022/3/30 21:43
--- 序章通用npc

local CityNpc = BaseClass("CityNpc")
local Resource = CS.GameEntry.Resource

local RotationAnimTime = 0.2
local MovePerGridSpeed = 4
local RotationAngleSpeed = 540 --原地旋转的速度

local RotationDeltaX = 0.8
local RotationDeltaY = 0.45

--桥3组点

local BridgeAngleMaxAngle = 25--左边坡度最大点角度
local BridgeAngleMaxHeight = 1--左边坡度最大点高度

local BridgeStopAngle = 13--上坡停住的点角度
local BridgeStopHeight = 0.9--上坡停住的点高度 

local BridgeHeightMaxAngle = 0--最高处角度
local BridgeHeightMaxHeight = 1.3--最高处高度


local AnimName =
{
    Idle = "idle",
    Walk = "walk",
    Cheer = "cheer"
}

local NpcFuncType =
{
    Task = 1,--任务
    Wounded = 2,--伤兵补偿
}

local CarNpc = "CityNpc_bridgecar"

function CityNpc:__init()
    self:DataDefine()
end

function CityNpc:Destroy()
    EventManager:GetInstance():Broadcast(EventId.HideTalkBubble, {target = self.transform})
    self:ComponentDestroy()
    self:DataDestroy()
end

function CityNpc:Create()
    --if self.req == nil then
    --    self.req = Resource:InstantiateAsync(string.format(LoadPath.CityScene, self:GetModelPath(self.param.modelName)))
    --    self.req:completed('+', function()
    --        self.gameObject = self.req.gameObject
    --        self.transform = self.req.gameObject.transform
    --        self:ComponentDefine()
    --        self.gameObject:SetActive(self.param.visible)
    --        self:Refresh()
    --        self:CheckDirectionAngle()
    --    end)
    --    if self.param ~= nil and self.param.posArr ~= nil then
    --        self.position = self:GetStartPosition()
    --    end
    --else
    --    self:Refresh()
    --end
end

function CityNpc:ComponentDefine()
    self.anim = self.transform:GetComponentInChildren(typeof(CS.SimpleAnimation), true)
end

function CityNpc:ComponentDestroy()
    self.gameObject = nil
    self.transform = nil
end

function CityNpc:DataDefine()
    self.param = {}
    self.isWalk = false
    self.walkIndex = 1
    self.__update_handle = function() self:Update() end
    UpdateManager:GetInstance():AddUpdate(self.__update_handle)
    self.isRotation = false
    self.startRotation = nil
    self.endRotation = nil
    self.rotationTime = 0
    self.effect = {}
    self.position = Vector3.New(0,0,0)
    self.lookPosition = Vector3.New(0,0,0)
    self.moveType = NpcMoveType.Normal
    self.startAngle = 0--(0-360)
    self.endAngle = 0--(0-360)
    self.effectSound = nil--小车特殊音效
end

function CityNpc:DataDestroy()
    self:StopAllEffectSound()
    self:DestroyModel()
    self:ClearEffect()
    self.param = {}
    self.isWalk = nil
    self.walkIndex = nil
    if self.__update_handle~=nil then
        UpdateManager:GetInstance():RemoveUpdate(self.__update_handle)
        self.__update_handle = nil
    end
    self.isRotation = nil
    self.startRotation = nil
    self.endRotation = nil
    self.rotationTime = nil
    self.effect = {}
    self.position = Vector3.New(0,0,0)
    self.lookPosition = Vector3.New(0,0,0)
    self.moveType = NpcMoveType.Normal
    self.startAngle = 0
    self.endAngle = 0
    self.effectSound = nil--小车特殊音效
end

function CityNpc:ReInit(param)
    self.param = param
    self:Create()
end

function CityNpc:Refresh()
    self.moveArr = {}
    if self.param.posArr ~= nil then
        local count = table.count(self.param.posArr)
        if count <= 1 then
            self.isWalk = false
            self:CheckNext()
        else
            if count == 2 then
                local startPos = SceneUtils.TileToWorld(self.param.posArr[1])
                local endPos = SceneUtils.TileToWorld(self.param.posArr[2])
                local rotation,startNearPos,endNearPos, endAngle = self:GetPathVec(startPos,endPos)
                local posVec = {}
                posVec.startPos = startPos
                posVec.endPos = endPos
                posVec.startRotation = rotation
                posVec.endRotation = rotation
                posVec.startAngle = endAngle
                posVec.endAngle = endAngle
                posVec.time = Vector3.Distance(posVec.startPos,posVec.endPos) / MovePerGridSpeed
                table.insert(self.moveArr,posVec)
            else
                local lastVec = nil
                local lastPos = nil
                for k, v in ipairs(self.param.posArr) do
                    local curPos = SceneUtils.TileToWorld(v)
                    local posVec = {}
                    if k == 1 then
                        posVec.startPos = curPos
                        table.insert(self.moveArr,posVec)
                    elseif k == count then
                        local rotation,startNearPos,endNearPos, endAngle = self:GetPathVec(lastPos,curPos)
                        lastVec.endPos = startNearPos
                        lastVec.endRotation = rotation
                        lastVec.endAngle = endAngle

                        posVec.startPos = startNearPos
                        posVec.endPos = endNearPos
                        posVec.startRotation = rotation
                        posVec.endRotation = rotation
                        posVec.startAngle = endAngle
                        posVec.endAngle = endAngle
                        posVec.time = Vector3.Distance(posVec.startPos,posVec.endPos) / MovePerGridSpeed
                        table.insert(self.moveArr,posVec)
                    elseif k == 2 then
                        local rotation,startNearPos,endNearPos, endAngle = self:GetPathVec(lastPos,curPos)
                        lastVec.endPos = endNearPos
                        lastVec.startRotation = rotation
                        lastVec.endRotation = rotation
                        lastVec.startAngle = endAngle
                        lastVec.endAngle = endAngle
                        lastVec.time = Vector3.Distance(lastVec.startPos,lastVec.endPos) / MovePerGridSpeed

                        posVec.startPos = endNearPos
                        posVec.startRotation = rotation
                        posVec.time = RotationAnimTime
                        posVec.startAngle = endAngle
                        table.insert(self.moveArr,posVec)
                    else
                        local rotation,startNearPos,endNearPos, endAngle = self:GetPathVec(lastPos,curPos)
                        lastVec.endPos = startNearPos
                        lastVec.endRotation = rotation
                        lastVec.endAngle = endAngle

                        local movePosVec = {}
                        movePosVec.startPos = startNearPos
                        movePosVec.endPos = endNearPos
                        movePosVec.startRotation = rotation
                        movePosVec.endRotation = rotation
                        movePosVec.startAngle = endAngle
                        movePosVec.endAngle = endAngle
                        movePosVec.time = Vector3.Distance(movePosVec.startPos,movePosVec.endPos) / MovePerGridSpeed
                        table.insert(self.moveArr,movePosVec)

                        posVec.startPos = endNearPos
                        posVec.startRotation = rotation
                        posVec.startAngle = endAngle
                        posVec.time = RotationAnimTime
                        table.insert(self.moveArr,posVec)
                    end
                    lastVec = posVec
                    lastPos = curPos
                end
            end
            self.curTime = 0
            self.walkIndex = 1
            self.transform.rotation = self:GetMoveAngle(self.moveArr[self.walkIndex].startAngle, self.moveArr[self.walkIndex].endAngle, 0)
            self.isWalk = true
        end
        if self.param ~= nil then
            self.position = self:GetStartPosition()
            self.transform.position = self.position
        end
    end
    if self.param ~= nil then
        if self.param.angle ~= nil then
            self.curTime = 0
            self.isRotation = true
            self.startRotation = self.transform.rotation
            self.startAngle = self.transform.rotation.eulerAngles.y
            self.endRotation = Quaternion.Euler(0,self.param.angle,0)
            self.endAngle = self.param.angle
            if self.param.angle < 0 then
                self.endAngle = self.param.angle + 360
            else
                self.endAngle = self.param.angle
            end
            self.rotationTime = math.abs((self.endAngle - self.startAngle) / RotationAngleSpeed)
        else
            self.startAngle = self.transform.rotation.eulerAngles.y
            self.endAngle = self.startAngle
            self.isRotation = false
        end
        if self.moveArr[1] == nil and self.param.moveType ~= NpcMoveType.Normal then
            self.transform.rotation = self:GetMoveAngle(self.startAngle, self.endAngle, 1)
        end
        self:RefreshAnim()
        self:CheckShowBubble()
        if self.param.npcFuncType == NpcFuncType.Wounded then
            self:CheckShowWoundedBubble()
        end
    end
end

function CityNpc:ChangeAnim(animName)
    self.param.animName = animName
    self:RefreshAnim()
end

function CityNpc:RefreshAnim()
    if self.isWalk then
        self.anim:Play(AnimName.Walk)
        if self.effectSound == nil then
            local soundName = self:GetMoveSound()
            if soundName ~= nil and soundName ~= "" then
                self.effectSound = SoundUtil.PlayEffect(soundName)
            end
        end
    elseif self.isRotation then
        self.anim:Play(AnimName.Idle)
    elseif self.param.animName ~= nil and self.param.animName ~= "" then
        if self.param.animName == AnimName.Cheer then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Get_New_Hero)
            self:ShowOneEffect()
        end
        self.anim:Play(self.param.animName)
        self.anim:PlayQueued(AnimName.Idle)
    else
        self.anim:Play(AnimName.Idle)
        self:StopAllEffectSound()
    end
end

--模型默认向下
function CityNpc:GetPathVec(startPos,endPos)
    if endPos.x == startPos.x then
        if endPos.z > startPos.z then
            --向上
            return Quaternion.Euler(0,180,0), {x = startPos.x, y = 0,z = startPos.z + RotationDeltaX}, {x = startPos.x, y = 0,z = endPos.z - RotationDeltaY},
            180
        else
            --向下
            return Quaternion.Euler(0,0,0), {x = startPos.x, y = 0,z = startPos.z - RotationDeltaX}, {x = startPos.x, y = 0,z = endPos.z + RotationDeltaY},
            0
        end
    else
        if endPos.x > startPos.x then
            --向右
            return Quaternion.Euler(0,-90,0), {x = startPos.x + RotationDeltaX, y = 0,z = startPos.z}, {x = endPos.x - RotationDeltaY, y = 0,z = startPos.z},
            -90
        else
            --向左
            return Quaternion.Euler(0,90,0), {x = startPos.x - RotationDeltaX, y = 0,z = startPos.z}, {x = endPos.x + RotationDeltaY, y = 0,z = startPos.z},
            90
        end
    end
end

function CityNpc:Update()
    if self.isWalk then
        self.curTime = self.curTime + Time.deltaTime
        local percent = self.curTime / self.moveArr[self.walkIndex].time
        if percent >= 1 then
            self.curTime = 0
            self.position = self:GetMovePosition(self.moveArr[self.walkIndex].startPos, self.moveArr[self.walkIndex].endPos, 1)
            self.transform.position = self.position
            self.transform.rotation = self:GetMoveAngle(self.moveArr[self.walkIndex].startAngle, self.moveArr[self.walkIndex].endAngle, 1)
            if self.walkIndex + 1 > table.count(self.moveArr) then
                self.isWalk = false
                self:RefreshAnim()
                if self.isRotation then
                    self.startRotation = self.transform.rotation
                    self.endRotation = Quaternion.Euler(0,self.param.angle,0)
                    if self.param.angle < 0 then
                        self.rotationTime = math.abs((self.param.angle + 360 - self.transform.rotation.eulerAngles.y) / RotationAngleSpeed)
                    else
                        self.rotationTime = math.abs((self.param.angle - self.transform.rotation.eulerAngles.y) / RotationAngleSpeed)
                    end
                else
                    self:CheckNext()
                end
            else
                self.walkIndex = self.walkIndex + 1
            end
        else
            self.position = self:GetMovePosition(self.moveArr[self.walkIndex].startPos, self.moveArr[self.walkIndex].endPos, percent)
            self.transform.position = self.position
            if self.moveArr[self.walkIndex].startRotation ~= self.moveArr[self.walkIndex].endRotation or self.param.moveType ~= NpcMoveType.Normal then
                self.transform.rotation = self:GetMoveAngle(self.moveArr[self.walkIndex].startAngle, self.moveArr[self.walkIndex].endAngle, percent)
            end
        end
    elseif self.isRotation then
        self.curTime = self.curTime + Time.deltaTime
        local percent = self.curTime / self.rotationTime
        if percent >= 1 then
            self.curTime = 0
            self.transform.rotation = self:GetMoveAngle(self.startAngle, self.endAngle, 1)
            self.isRotation = false
            self:RefreshAnim()
            self:CheckNext()
        else
            self.transform.rotation = self:GetMoveAngle(self.startAngle, self.endAngle, percent)
        end
    end
    if self.param.follow then
        if self.lookPosition.x ~= self.position.x or self.lookPosition.z ~= self.position.z then
            self.lookPosition.x = self.position.x
            self.lookPosition.z = self.position.z
            CS.SceneManager.World:Lookat(self.position)
        end
    end
end

function CityNpc:GetPosition()
    return self.position
end

function CityNpc:CheckNext()
    if self.param.nextType == GuideNpcDoNextType.WaitWalk then
        local template = DataCenter.GuideManager:GetCurTemplate()
        if template ~= nil then
            if template.type == GuideType.PrologueShowNpc and template.para2 == self.param.modelName then
                DataCenter.GuideManager:DoNext()
            end
        end
    elseif self.param.nextType == GuideNpcDoNextType.WaitWalkDelete then
        DataCenter.CityNpcManager:RemoveOneNpc(self.param.modelName)
    end
end

function CityNpc:CheckShowBubble()
    local info = DataCenter.HeroEntrustManager:GetHeroEntrustByNpcName(self.param.modelName)
    if info ~= nil and not info:IsAllComplete() then
        local talkParam = {}
        talkParam.talkType = NpcTalkType.HeroEntrust
        talkParam.target = self.transform
        talkParam.offset = Vector3.New(0, 1, 0)
        talkParam.id = info.id
        DataCenter.HeroEntrustBubbleManager:AddOneHeroEntrustBubble(talkParam)
    end
end

function CityNpc:CheckShowWoundedBubble()
    if self.param.npcFuncType == NpcFuncType.Wounded then
        local param  = {}
        param.target = self.transform
        param.offset = Vector3.New(0, 1, 0)
        DataCenter.WoundedCompensateManager:UpdateWoundedBubble(param)
    end
end

function CityNpc:ShowOneEffect()
    local id = NameCount
    NameCount = NameCount + 1
    local param = {}
    self.effect[id] = param
    param.timer = TimerManager:DelayInvoke(function()
        param.timer:Stop()
        self.effect[id] = nil
        param.request:Destroy()
    end, 5)
end

function CityNpc:ClearEffect()
    for k,v in pairs(self.effect) do
        v.timer:Stop()
        v.request:Destroy()
    end
    self.effect = {}
end

function CityNpc:GetModelPath(modelName)
    if LuaEntry.Player:IsUseNewABan() and string.contains(modelName, "CityNpc_ben")  then
        return modelName .. "_new"
    end
    return modelName
end

function CityNpc:DestroyModel()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil
    end
end

function CityNpc:SetVisible(visible)
    if self.param.visible ~= visible then
        self.param.visible = visible
        if self.gameObject ~= nil then
            self.gameObject:SetActive(visible)
        end
    end
end

function CityNpc:SetFollow(follow)
    if self.param.follow ~= follow then
        self.param.follow = follow
    end
end

function CityNpc:CheckDirectionAngle()
    if not self.isWalk and self.isRotation then
        self.isRotation = false
        self.transform.rotation = self:GetMoveAngle(self.startAngle, self.endAngle, 1)
    end
end

function CityNpc:GetMovePosition(startPos, endPos, percent)
    local moveType = self.param.moveType
    local pos = Vector3.Lerp(startPos, endPos, percent)
    if moveType == NpcMoveType.EnterBridge then
        if percent > 0.8 then
            pos.y = Mathf.Lerp(BridgeAngleMaxHeight, BridgeStopHeight, (percent - 0.8) / 0.2)
        else
            pos.y = Mathf.Lerp(0, BridgeAngleMaxHeight, percent)
        end
    elseif moveType == NpcMoveType.ExitBridge then
        if percent > 0.6 then
            --下坡后半段
            pos.y = Mathf.Lerp(BridgeAngleMaxHeight, 0, (percent - 0.6) / 0.4)
        elseif percent > 0.2 then
            --下坡前半段
            pos.y = Mathf.Lerp(BridgeHeightMaxHeight, BridgeAngleMaxHeight, (percent - 0.2) / 0.4)
        else
            --上坡段
            pos.y = Mathf.Lerp(BridgeStopHeight, BridgeHeightMaxHeight, percent / 0.2)
        end
    elseif moveType == NpcMoveType.CrossBridge then
        if percent > 0.75 then
            --下坡后半段
            pos.y = Mathf.Lerp(BridgeAngleMaxHeight, 0, (percent - 0.75) / 0.25)
        elseif percent > 0.5 then
            --下坡前半段
            pos.y = Mathf.Lerp(BridgeHeightMaxHeight, BridgeAngleMaxHeight, (percent - 0.5) / 0.25)
        elseif percent > 0.25 then
            --上坡后半段
            pos.y = Mathf.Lerp(BridgeAngleMaxHeight, BridgeHeightMaxHeight, (percent - 0.25) / 0.25)
        else
            --上坡前半段
            pos.y = Mathf.Lerp(0, BridgeAngleMaxHeight, percent / 0.25)
        end
    end
    return pos
end

function CityNpc:GetMoveAngle(startAngle, endAngle, percent)
    local moveType = self.param.moveType
    local xAngle = 0
    local yAngle = Mathf.Lerp(startAngle, endAngle, percent)
    if moveType == NpcMoveType.Normal then

    elseif moveType == NpcMoveType.EnterBridge then
        if percent > 0.8 then
            xAngle = Mathf.Lerp(BridgeAngleMaxAngle, BridgeStopAngle, (percent - 0.8) / 0.2)
        else
            xAngle = Mathf.Lerp(0, BridgeAngleMaxAngle, percent)
        end
    elseif moveType == NpcMoveType.ExitBridge then
        if percent > 0.6 then
            --下坡后半段
            xAngle = Mathf.Lerp(-BridgeAngleMaxAngle, 0, (percent - 0.6) / 0.4)
        elseif percent > 0.2 then
            --下坡前半段
            xAngle = Mathf.Lerp(BridgeHeightMaxAngle, -BridgeAngleMaxAngle, (percent - 0.2) / 0.4)
        else
            --上坡段
            xAngle = Mathf.Lerp(BridgeStopAngle, BridgeHeightMaxAngle, percent / 0.2)
        end
    elseif moveType == NpcMoveType.CrossBridge then
        if percent > 0.75 then
            --下坡后半段
            xAngle = Mathf.Lerp(-BridgeAngleMaxAngle, 0, (percent - 0.75) / 0.25)
        elseif percent > 0.5 then
            --下坡前半段
            xAngle = Mathf.Lerp(BridgeHeightMaxAngle, -BridgeAngleMaxAngle, (percent - 0.5) / 0.25)
        elseif percent > 0.25 then
            --上坡后半段
            xAngle = Mathf.Lerp(BridgeAngleMaxAngle, BridgeHeightMaxAngle, (percent - 0.25) / 0.25)
        else
            --上坡前半段
            xAngle = Mathf.Lerp(0, BridgeAngleMaxAngle, percent / 0.25)
        end
    end
    return Quaternion.Euler(xAngle, yAngle, 0)
end

function CityNpc:GetStartPosition()
    local moveType = self.param.moveType
    local pos = SceneUtils.TileToWorld(self.param.posArr[1])
    if self.param.posArr[2] == nil then
        if moveType == NpcMoveType.EnterBridge then
            pos.y = BridgeStopHeight
        end
    else
        if moveType == NpcMoveType.ExitBridge then
            pos.y = BridgeStopHeight
        elseif moveType == NpcMoveType.CrossBridge then
            pos.y = BridgeStopHeight
        end
    end
    return pos
end

function CityNpc:GetMoveSound()
    if self.param.modelName == CarNpc then
        return SoundAssets.Music_Effect_Car_Move
    end
    return nil
end

function CityNpc:StopAllEffectSound()
    if self.effectSound ~= nil then
        CS.GameEntry.Sound:StopSound(self.effectSound)
        self.effectSound = nil
    end
end



return CityNpc