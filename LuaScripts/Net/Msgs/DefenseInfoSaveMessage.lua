---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/7 16:20
---
local DefenseInfoSaveMessage = BaseClass("DefenseInfoSaveMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,uuid,heroInfos)
    base.OnCreate(self)
    self.sfsObj:PutLong("uuid", uuid)
    local heroArray = SFSArray.New()
    table.walk(heroInfos,function (k,v)
        local obj = SFSObject.New()
        obj:PutLong("heroUuid",k)
        obj:PutInt("index", v)
        heroArray:AddSFSObject(obj)
    end)

    self.sfsObj:PutSFSArray("heroInfos", heroArray)

end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local errCode =  t["errorCode"]
    if errCode ~= nil then
        UIUtil.ShowTipsId(errCode) 
    else
        DataCenter.ArmyFormationDataManager:InitArmyFormationListData(t)
        --EventManager:GetInstance():Broadcast(EventId.ArmyFormatUpdate)
        UIUtil.ShowTipsId(300056) 
    end
end

DefenseInfoSaveMessage.OnCreate = OnCreate
DefenseInfoSaveMessage.HandleMessage = HandleMessage

return DefenseInfoSaveMessage