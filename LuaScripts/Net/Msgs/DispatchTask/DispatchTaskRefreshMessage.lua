local DispatchTaskRefreshMessage = BaseClass("DispatchTaskRefreshMessage", SFSBaseMessage)
local base = SFSBaseMessage

-- | 字段     | 是否必填 | 类型 | 解释                  | 备注  |
--| -------- | -------- | ---- | -------------------- | ----- |
--| costType | 否       | int  | 0 使用道具，1 使用钻石 | 默认 0 |
function DispatchTaskRefreshMessage:OnCreate(costType)
    base.OnCreate(self)
    self.sfsObj:PutInt("costType", costType)
end

function DispatchTaskRefreshMessage:HandleMessage(t)
    base.HandleMessage(self, t)
    local errCode = t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
        return
    end
    if t then
        DataCenter.ActDispatchTaskDataManager:UpdateAllSingleTasks(t)
    end
end

return DispatchTaskRefreshMessage

