---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/2/28 21:34
---
local UIPoliceStationCtrl = BaseClass("UIPoliceStationCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPoliceStation)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetPoliceArmyList(self)
    local param = {}
    local armyUnit = DataCenter.DefenceWallDataManager:GetGuardArmyInfo()
    local soldier = armyUnit.soldiers
    if soldier~=nil then
        local num= 0
        for k,v in pairs(soldier) do
            if num<3 then
                local oneData = {}
                oneData.key = tonumber(v.armsId)
                oneData.value = v.total
                num = num+1
                table.insert(param,oneData)
            end
        end
    end
    return param
end
UIPoliceStationCtrl.CloseSelf = CloseSelf
UIPoliceStationCtrl.Close = Close
UIPoliceStationCtrl.GetPoliceArmyList = GetPoliceArmyList
return UIPoliceStationCtrl