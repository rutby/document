
local PushCommonNotice = BaseClass("PushCommonNotice", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
end
local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local data = t["d"]
    local str = self:BuildData(data)
    if str and str ~= "" then
        UIUtil.ShowTips(str)
    end
end

local function BuildData(self, t)
    if t["o"] == 0 then
        return self:BuildText(t)
    end
    if t["o"] == 1 then
        return self:BuildDialog(t)
    end
end

local function BuildText(self, t)
    -- {"t":"Survivor01313","o":0}
    local text = t["t"]
    return text
end

local function BuildDialog(self, t)
    -- {"p":[{"t":"Survivor01313","o":0}],"d":"128132","o":1}
    local dialog = t["d"]
    local params = {}
    if not table.IsNullOrEmpty(t["p"]) then
        for _, v in pairs(t["p"]) do
            local param = self:BuildData(v)
            if not string.IsNullOrEmpty(param) then
                table.insert(params, param)
            else 
                table.insert(params, "")
            end
        end
    end
    if not table.IsNullOrEmpty(params) then
        return Localization:GetString(dialog, SafeUnpack(params))
    else
        return Localization:GetString(dialog)
    end
end

PushCommonNotice.OnCreate = OnCreate
PushCommonNotice.HandleMessage = HandleMessage
PushCommonNotice.BuildData = BuildData
PushCommonNotice.BuildText = BuildText
PushCommonNotice.BuildDialog = BuildDialog

return PushCommonNotice