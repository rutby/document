---
--- Created by yixing.
--- DateTime: 2021/12/04 11:35
---冠军对决-奖励预览
local ActChampBattleRewardPreviewMessage = BaseClass("ActChampBattleRewardPreviewMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self)
    base.OnCreate(self)
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message.errorCode ~= nil then
        UIUtil.ShowTipsId(message.errorCode)
        return
    end
    --获取奖励预览数据
    EventManager:GetInstance():Broadcast(EventId.ChampionBattleRewardPreviewBack, message)    
end

ActChampBattleRewardPreviewMessage.OnCreate = OnCreate
ActChampBattleRewardPreviewMessage.HandleMessage = HandleMessage

return ActChampBattleRewardPreviewMessage