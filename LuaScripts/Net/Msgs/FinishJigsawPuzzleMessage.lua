---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/8/18 21:53
---FinishJigsawPuzzleMessage

local FinishJigsawPuzzleMessage = BaseClass("FinishJigsawPuzzleMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self, activityId, jigsawId, costTime)
    base.OnCreate(self)
    self.sfsObj:PutInt("activityId", tonumber(activityId))
    self.sfsObj:PutInt("id", jigsawId)
    self.sfsObj:PutInt("useTime", costTime)
    local strContent = LuaEntry.Player.uid .. activityId .. jigsawId .. costTime
    local md5 = CS.StringUtils.GetMD5(strContent)
    self.sfsObj:PutUtfString("m", md5)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        if t["reward"] then
            for k,v in pairs(t["reward"]) do
                DataCenter.RewardManager:AddOneReward(v)
            end
        end
        DataCenter.JigsawPuzzleManager:OnrecvPuzzleFinish(t)
    end
    EventManager:GetInstance():Broadcast(EventId.OnJigsawPuzzleEnd)
end

FinishJigsawPuzzleMessage.OnCreate = OnCreate
FinishJigsawPuzzleMessage.HandleMessage = HandleMessage

return FinishJigsawPuzzleMessage