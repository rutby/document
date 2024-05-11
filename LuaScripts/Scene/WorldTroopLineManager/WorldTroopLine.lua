---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 27/3/2024 上午11:32
---
local Const = require"Scene.WorldTroopManager.Const"
local Localization = CS.GameEntry.Localization
local ResourceManager = CS.GameEntry.Resource
local WorldTroopLine = BaseClass("WorldTroopLine")

function WorldTroopLine:__init()
    self.uuid = 0
    self.lineInst = nil
    self.line = nil
    self.pathStr = ""
    self.targetPos = 0
end

function WorldTroopLine:__delete()
    self.uuid = 0
    self.lineInst = nil
    self.line = nil
    self.pathStr = ""
    self.targetPos = 0
end

function WorldTroopLine:OnCreateMarchLine(marchUuid)
    self.uuid= marchUuid
    self.pathStr = ""
    self.targetPos = 0
    if self.lineInst~=nil then
        return
    end
    self.lineInst = ResourceManager:InstantiateAsync("Assets/Main/Prefabs/March/TroopLine.prefab")
    self.lineInst:completed('+',function()
        if self.lineInst.isError or self.lineInst.gameObject == nil then
            return
        end
        self.lineInst.gameObject.transform:SetParent(CS.SceneManager.World.DynamicObjNode)
        self.line = self.lineInst.gameObject.transform:GetComponent(typeof(CS.WorldTroopLine))
        self.line:Clear()
        self:SetColor()
    end)
end


function WorldTroopLine:Destroy()
    if self.lineInst~=nil then
        self.lineInst:Destroy()
    end
    self.lineInst = nil
    self.line = nil
    self.pathStr = ""
    self.targetPos = 0
end
function WorldTroopLine:SetColor()
    if self.line~=nil then
        self.line:SetColor(self:GetTroopLineColor())
    end
end
function WorldTroopLine:Clear()
    if self.line~=nil then
        self.line:Clear()
        
    end
end
function WorldTroopLine:GetTroopLineColor()
    local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(self.uuid)
    if marchInfo~=nil then
        local type = marchInfo:GetMarchType()
        if marchInfo.ownerUid == LuaEntry.Player.uid then
            return Const.MyTroopLineColor
        end
        if LuaEntry.Player:IsInAlliance() and marchInfo.allianceUid == LuaEntry.Player.allianceId then
            return Const.AllianceTroopLineColor
        end
        if DataCenter.WorldMarchDataManager:IsTargetForMine(marchInfo) then
            return Const.EnemyTroopLineColor
        end   
        if marchInfo.srcServer ~= LuaEntry.Player:GetSelfServerId() then
            return Const.EnemyTroopLineColor
        end
        if (DataCenter.WorldNewsDataManager:GetIsAttackerByUid(marchInfo.ownerUid) == true) or
                (DataCenter.GloryManager:GetIsFightServer(marchInfo.srcServer) == true) then
            return Const.EnemyTroopLineColor
        end
        if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
            if DataCenter.RobotWarsManager:GetSelfCamp()>0 and DataCenter.GloryManager:IsSameCampByAllianceId(marchInfo.allianceUid) then
                return Const.YellowTroopLineColor
            else
                return Const.EnemyTroopLineColor
            end
        end
    end
    return Const.OtherTroopLineColor
end

function WorldTroopLine:SetMovePath(pathStr,targetPos, realTargetPos,needRefresh)
    if self.pathStr~=pathStr or self.targetPos~=targetPos or needRefresh == true then
        if self.line~=nil then
            local march = DataCenter.WorldMarchDataManager:GetMarch(self.uuid)
            if march then
                self.line:StartMove(march.targetPos,march.path,march.speed,march.blackStartTime,march.blackEndTime,march.startTime,march.endTime,realTargetPos)
                self.pathStr = pathStr
                self.targetPos = targetPos
            end
        end
    end
    
end

return WorldTroopLine