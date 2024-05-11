---
--- Created by Terry.
--- DateTime: 2021/12/08 15:17
--- 冠军对决-请求战报列表
---
local ActChampionBattleReportListMessage = BaseClass("ActChampionBattleReportListMessage", SFSBaseMessage)
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
    DataCenter.ActChampionBattleManager:RefreshChampionBattleReportList(message)
end

ActChampionBattleReportListMessage.OnCreate = OnCreate
ActChampionBattleReportListMessage.HandleMessage = HandleMessage

return ActChampionBattleReportListMessage