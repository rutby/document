local PveDiffFightMessage = BaseClass("PveDiffFightMessage", SFSBaseMessage)
local Localization = CS.GameEntry.Localization

local base = SFSBaseMessage

local function OnCreate(self, levelId, triggerId, heroes, monsterGroupIndex, monsterId, armies)
    base.OnCreate(self)
    self.sfsObj:PutInt("level", levelId)
    self.sfsObj:PutInt("trigger", triggerId)
    local sfsHeroes = SFSArray.New()
    for _, v in pairs(heroes) do
        local index = v["index"]
        local uuid = v["uuid"]
        local obj = SFSObject.New()
        obj:PutInt("index",index)
        obj:PutLong("uuid", uuid)
        sfsHeroes:AddSFSObject(obj)
    end
    self.sfsObj:PutSFSArray("heroes", sfsHeroes)
    self.sfsObj:PutInt("monsterGroupIndex", monsterGroupIndex - 1)
    self.sfsObj:PutInt("monsterId", monsterId)
    local formationArray = SFSArray.New()
    for k, v in pairs(armies) do
        local obj = SFSObject.New()
        obj:PutUtfString("armyId",tostring(k))
        obj:PutInt("count", tonumber(v))
        formationArray:AddSFSObject(obj)
    end
    self.sfsObj:PutSFSArray("formations", formationArray)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
        PveActorMgr:GetInstance():Leave()
        return
    end
    if (t == nil) then
        return
    end
    local battleContent = ""
    if (t["battleContent"] ~= nil) then
        battleContent = t["battleContent"]
    elseif t["battleContentArr"] ~= nil then
        local tabCnt = table.count(t["battleContentArr"])
        if (tabCnt > 0) then
            for i = 1, tabCnt do
                battleContent = battleContent .. t["battleContentArr"][i]
            end
        end
    end

    local detailContent = ""
    if (t["detailContent"] ~= nil) then
        detailContent = t["detailContent"]
    elseif t["detailContentArr"] ~= nil then
        local tabCnt = table.count(t["detailContentArr"])
        if (tabCnt > 0) then
            for i = 1, tabCnt do
                detailContent = detailContent .. t["detailContentArr"][i]
            end
        end
    end

    local expContent = t["heroExpReward"]
    
    PveActorMgr:GetInstance():ParseData(battleContent, detailContent, expContent)
    
    DataCenter.BattleLevel:OnBattleMessage(t)
end

PveDiffFightMessage.OnCreate = OnCreate
PveDiffFightMessage.HandleMessage = HandleMessage

return PveDiffFightMessage