---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by jinpeng.
--- DateTime: 2023/6/19 12:21
---
local DispatchStartMessage = BaseClass("DispatchStartMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

---@param uuid number 任务id
---@param heroList table 英雄uuid的number数组
function DispatchStartMessage:OnCreate(uuid, heroList, marchDuration)
    base.OnCreate(self)
    self.sfsObj:PutLong("uuid", uuid)
    local heroArr = SFSArray.New()
    for i, heroUuid in ipairs(heroList) do
        heroArr:AddLong(heroUuid)
    end
    self.sfsObj:PutSFSArray("heroUuidList", heroArr)
    self.sfsObj:PutLong("marchTime", marchDuration+500)
end

function DispatchStartMessage:HandleMessage(message)
    base.HandleMessage(self, message)
    local errCode =  message["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode)
    else
        if message["mission"] then
            DataCenter.ActDispatchTaskDataManager:UpdateOneSingleTask(message["mission"], true)
            -- 添加去的虚假行军
            DataCenter.ActDispatchTaskFakeMarchManager:AddMarchIndex(message["mission"].pointId, LuaEntry.Player:GetMainWorldPos(), false)
            local mission = message["mission"]
            if mission~=nil then
                local uuid = mission.uuid
                local mgr = DataCenter.ActDispatchTaskDataManager
                local dispatchTask = mgr:GetSingleTaskByUuid(uuid)
                if dispatchTask~=nil then
                    local heroList  =dispatchTask.heroList
                    if heroList~=nil and #heroList>0 then
                        local heroUuid = heroList[1]
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationDispatchTip,{anim = true},heroUuid)
                    end
                end
                
            end
            
        end
    end
end

return DispatchStartMessage