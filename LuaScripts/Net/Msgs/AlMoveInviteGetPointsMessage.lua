---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/11/22 18:44
---AlMoveInviteGetPointsMessage.lua


local AlMoveInviteGetPointsMessage = BaseClass("AlMoveInviteGetPointsMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        local allianceCityCenterPoint = t["allianceCityCenterPoint"]--int 联盟城聚集点坐标
        local leaderPoint = t["leaderPoint"]--int 盟主坐标
        local allianceBornPoint = t["allianceBornPoint"]--int 联盟出生点
        local actMineCenterPoint = t["actMineCenterPoint"]
        DataCenter.AllianceBaseDataManager:OnRecvAlMoveInvitePoints(allianceCityCenterPoint, leaderPoint, allianceBornPoint,actMineCenterPoint)
    end
end

AlMoveInviteGetPointsMessage.OnCreate = OnCreate
AlMoveInviteGetPointsMessage.HandleMessage = HandleMessage

return AlMoveInviteGetPointsMessage