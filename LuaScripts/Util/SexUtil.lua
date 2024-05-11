---
--- Created by shimin.
--- DateTime: 2023/11/12 13:03
--- 性别单元
---
local SexUtil = {}
local Localization = CS.GameEntry.Localization

--处理改变性别返回消息
local function UserModifySexHandle(message)
    local lastSex = LuaEntry.Player:GetSex()
    LuaEntry.Player:SetSexData(message)
    if message["lastUpdateTime"] ~= nil then
        LuaEntry.Player:SetLastUpdateTime(message["lastUpdateTime"])
    end
    if message["gold"] ~= nil then
        LuaEntry.Player.gold = message["gold"]
        EventManager:GetInstance():Broadcast(EventId.UpdateGold)
    end
    --if lastSex == SexType.None and LuaEntry.Player:GetSex() == SexType.Woman then
    --    --打开对话
    --    UIUtil.ShowMessage(Localization:GetString(GameDialogDefine.GET_WOMAN_SEX_COS_PLAY), 1, GameDialogDefine.GOTO, function()
    --    end, function()
    --        DecorationUtil.OpenDecorationPanel()
    --    end)
    --end
    EventManager:GetInstance():Broadcast(EventId.ChangeSex)
end

--发送改变性别
local function SendModifySexMessage(sex)
    SFSNetwork.SendMessage(MsgDefines.UserModifySex, {sex = sex})
end

--测试改变性别
local function TestSendChangeMessage()
    local lastSex = LuaEntry.Player:GetSex()
    if lastSex == SexType.Woman then
        SexUtil.SendModifySexMessage(SexType.Man)
    else
        SexUtil.SendModifySexMessage(SexType.Woman)
    end
end

local function GetModifySexCostNum(hasChangeCount)
    if hasChangeCount <= 0 then
        return 0
    else
        return LuaEntry.DataConfig:TryGetNum("gender_config", "k3")
    end
end

local function IsUnLockSex()
    local mainBuildLV = DataCenter.BuildManager.MainLv
    local needLv = LuaEntry.DataConfig:TryGetNum("gender_config", "k1")
    if mainBuildLV >= needLv then
        return true
    end
    return false
end

local function IsShowSexRed()
    local lastSex = LuaEntry.Player:GetSex()
    if lastSex == SexType.None then
        local mainBuildLV = DataCenter.BuildManager.MainLv
        local needLv = LuaEntry.DataConfig:TryGetNum("gender_config", "k2")
        if mainBuildLV >= needLv then
            return true
        end
    end
    return false
end

local function GetSexIconName(sex)
    if sex == SexType.Woman then
        return "Assets/Main/Sprites/UI/Common/New/Common_icon_female.png"
    elseif sex == SexType.Man then
        return "Assets/Main/Sprites/UI/Common/New/Common_icon_male.png"
    end
    return nil
end

SexUtil.UserModifySexHandle = UserModifySexHandle
SexUtil.SendModifySexMessage = SendModifySexMessage
SexUtil.TestSendChangeMessage = TestSendChangeMessage
SexUtil.GetModifySexCostNum = GetModifySexCostNum
SexUtil.IsUnLockSex = IsUnLockSex
SexUtil.IsShowSexRed = IsShowSexRed
SexUtil.GetSexIconName = GetSexIconName

return ConstClass("SexUtil", SexUtil)