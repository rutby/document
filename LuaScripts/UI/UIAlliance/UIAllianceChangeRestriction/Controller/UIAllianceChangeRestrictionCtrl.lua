---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/6/9 18:48
---
local UIAllianceChangeRestrictionCtrl = BaseClass("UIAllianceChangeRestrictionCtrl", UIBaseCtrl)
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceChangeRestriction)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function OnChangeRestrictionClick(self,levelValue,powerValue)
    local str = levelValue..";"..powerValue
    EventManager:GetInstance():Broadcast(EventId.AllianceRestriction,str)
    SFSNetwork.SendMessage(MsgDefines.AllianceChangeAttributes,"","",-1,"","",tostring(levelValue),tostring(powerValue))
    self:CloseSelf()
    
end

UIAllianceChangeRestrictionCtrl.CloseSelf =CloseSelf
UIAllianceChangeRestrictionCtrl.Close =Close
UIAllianceChangeRestrictionCtrl.OnChangeRestrictionClick =OnChangeRestrictionClick
return UIAllianceChangeRestrictionCtrl