---
--- Created by Terry.
--- DateTime: 2021/12/08 15:17
--- 冠军对决-请求战报列表
---
local ActChampionStrongestReportListMessage = BaseClass("ActChampionStrongestReportListMessage", SFSBaseMessage)
local base = SFSBaseMessage

local function OnCreate(self, phase, location, group)
    base.OnCreate(self)

    self.sfsObj:PutLong("phase", phase)
    self.sfsObj:PutLong("location", location)
    if group then
        self.sfsObj:PutLong("group", group)
    end
end

local function HandleMessage(self, message)
    base.HandleMessage(self, message)
    if message.errorCode ~= nil then
        UIUtil.ShowTipsId(message.errorCode)
        return
    end

    DataCenter.ActChampionBattleManager:RefreshChampionBattleReportList(message)
end

ActChampionStrongestReportListMessage.OnCreate = OnCreate
ActChampionStrongestReportListMessage.HandleMessage = HandleMessage

return ActChampionStrongestReportListMessage