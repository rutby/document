---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 2022/2/9 21:15
---
local UICapacityBoxSelectCtrl = BaseClass("UICapacityBoxSelectCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

function UICapacityBoxSelectCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UICapacityBoxSelect)
end

function UICapacityBoxSelectCtrl:InitData()

end

function UICapacityBoxSelectCtrl:UseItem(type,uuid,count,param)
    if type == GOODS_TYPE.GOODS_TYPE_102  then
        SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = uuid,num = count ,heroId = param})
    elseif type == GOODS_TYPE.GOODS_TYPE_59 or type == GOODS_TYPE.GOODS_TYPE_107 then
        SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = uuid,num = count ,para1 = tostring(param)})
    elseif type == GOODS_TYPE.GOODS_TYPE_122 or type == GOODS_TYPE.GOODS_TYPE_123 then
        SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = uuid,num = count ,armType = param})
    end
    self:CloseSelf()
end

--获取当前最高解锁等级兵种
function UICapacityBoxSelectCtrl:GetArmyList()
    local armyList = {}
    local lv_army1,id_army1 = DataCenter.ArmyManager:GetMaxUnLockId(BuildingTypes.FUN_BUILD_CAR_BARRACK)
    if id_army1 ~= "" then
        table.insert(armyList,id_army1)
    end
    local lv_army2,id_army2 = DataCenter.ArmyManager:GetMaxUnLockId(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK)
    if id_army2 ~= "" then
        table.insert(armyList,id_army2)
    end
    local lv_army3,id_army3 = DataCenter.ArmyManager:GetMaxUnLockId(BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK)
    if id_army3 ~= "" then
        table.insert(armyList,id_army3)
    end
    return armyList
end

--获取当前最高解锁等级雇佣兵兵种
function UICapacityBoxSelectCtrl:GetMercenaryArmyList()
    local armyList = {}
    local _, id1 = DataCenter.ArmyManager:GetMaxUnLockId(BuildingTypes.FUN_BUILD_CAR_BARRACK)
    if id1 ~= "" then
        local id = DataCenter.ArmyTemplateManager:ArmyToMercenaryId(id1)
        if id then
            table.insert(armyList, id)
        end
    end
    local _, id2 = DataCenter.ArmyManager:GetMaxUnLockId(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK)
    if id2 ~= "" then
        local id = DataCenter.ArmyTemplateManager:ArmyToMercenaryId(id2)
        if id then
            table.insert(armyList, id)
        end
    end
    local _, id3 = DataCenter.ArmyManager:GetMaxUnLockId(BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK)
    if id3 ~= "" then
        local id = DataCenter.ArmyTemplateManager:ArmyToMercenaryId(id3)
        if id then
            table.insert(armyList, id)
        end
    end
    return armyList
end

return UICapacityBoxSelectCtrl