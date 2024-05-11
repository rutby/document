
local WorldAlMoveMessage = BaseClass("WorldAlMoveMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, forCalc)
    base.OnCreate(self)
    self.sfsObj:PutInt("forCalc", forCalc)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)

    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        local pointId = t["pointId"]
        local forCalc = t["forCalc"]
        local centerPointId = t["allianceCenterPoint"]
        DataCenter.AllianceBaseDataManager:OnRecvAlPoints(pointId, centerPointId, forCalc)
    end
end

WorldAlMoveMessage.OnCreate = OnCreate
WorldAlMoveMessage.HandleMessage = HandleMessage

return WorldAlMoveMessage