---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/6/8 10:12
---
local UIDragonAllianceSelectMemberCtrl = BaseClass("UIDragonAllianceSelectMemberCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization
function UIDragonAllianceSelectMemberCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIDragonAllianceSelectMember)
end

function UIDragonAllianceSelectMemberCtrl:Close()
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UIDragonAllianceSelectMemberCtrl:GetAllMemberList(isRevert)
    local showList = {}
    local list = DataCenter.ActDragonManager:GetPlayerList()
    for k,v in pairs(list) do
        local oneData = {}
        oneData.uid = v.uid
        oneData.power = v.power
        oneData.name = v.name
        oneData.headBg = v:GetHeadBgImg()
        oneData.pic = v.pic
        oneData.picVer = v.picVer
        oneData.state = v.state
        table.insert(showList,oneData)
    end
    if isRevert == true then
        table.sort(showList,function(a,b)
            return a.power<b.power
        end)
    else
        table.sort(showList,function(a,b)
            return a.power>b.power
        end)
    end
    
    return showList
end

return UIDragonAllianceSelectMemberCtrl