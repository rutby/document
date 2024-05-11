---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/11/15 16:48
---

local GolloesTradeCheckTargetMessage = BaseClass("GolloesTradeCheckTargetMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, targetUid, name, pointId)
    base.OnCreate(self)
    self.sfsObj:PutUtfString("targetUid", targetUid)
    self.sfsObj:PutUtfString("name", name)
    self.sfsObj:PutInt("pointId", pointId)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        if t.overLimit then
            UIUtil.ShowTipsId(320267) 
        else
            self:ConfirmBeforeTrade(t.name, t.pointId)
        end
    end
end

local function ConfirmBeforeTrade(self, name, pointId)
    UIUtil.ShowMessage(Localization:GetString("320258", name),2,nil,nil,function ()
        self:StartTrade(pointId)
        SoundUtil.PlayEffect(GolloesSound[GolloesType.Trader])
        UIUtil.ShowTipsId(320331)
    end,nil,nil)
end

local function StartTrade(self, pointId)
    local canSendNum, formationUuids = DataCenter.GolloesCampManager:GetFreeFormationByGolloesType(GolloesType.Trader)
    --local worldMarch, formationInfo = DataCenter.GolloesCampManager:GetGolloesMarchByType(GolloesType.Trader)
    if canSendNum > 0 then
        local freeUuid = formationUuids[1]
        local marchTargetType = MarchTargetType.GOLLOES_TRADE
        local sfsObj = SFSObject.New()
        sfsObj:PutLong("uuid", freeUuid)
        local formationArray = SFSArray.New()
        sfsObj:PutSFSArray("formations", formationArray)
        local heroArray = SFSArray.New()
        sfsObj:PutSFSArray("heroInfos", heroArray)

        local dataObj = sfsObj
        local startPoint = LuaEntry.Player:GetMainWorldPos()
        --local buildList = DataCenter.BuildManager:GetAllBuildingByItemIdWithoutPickUp(BuildingTypes.FUN_BUILD_GROCERY_STORE)
        --if buildList~=nil and table.count(buildList) > 0 and buildList[1]~=nil then
        --    startPoint = buildList[1].pointId
        --end
        MarchUtil.StartMarch(marchTargetType, pointId, -1, -1, 0, freeUuid, 1, dataObj,startPoint)
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceMemberDetail)
    else
        UIUtil.ShowTipsId(320334)
    end
    
    --UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

GolloesTradeCheckTargetMessage.OnCreate = OnCreate
GolloesTradeCheckTargetMessage.HandleMessage = HandleMessage
GolloesTradeCheckTargetMessage.ConfirmBeforeTrade = ConfirmBeforeTrade
GolloesTradeCheckTargetMessage.StartTrade = StartTrade

return GolloesTradeCheckTargetMessage