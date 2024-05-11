---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 2021/11/3 18:02
---
local PushItemAddMessage = BaseClass("PushItemAddMessage", SFSBaseMessage)
local base = SFSBaseMessage
local Localization = CS.GameEntry.Localization

local function OnCreate(self,param)
    base.OnCreate(self)
end

local function HandleMessage(self, t)
    base.HandleMessage(self, t)
    local itemId = t["itemId"]
    local oldNum = DataCenter.ItemData:GetItemCount(itemId)
    DataCenter.ItemData:UpdateOneItem(t,false)
    local newNum = DataCenter.ItemData:GetItemCount(itemId)
    local dif = math.max(newNum - oldNum, 1)
    if itemId == SpecialItemId.ITEM_BLACK_DESERT_CITY_MOVE
            or itemId == SpecialItemId.ITEM_ALLIANCE_CITY_MOVE then
        if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIResourceLackNew) then
            UIManager:GetInstance():DestroyWindow(UIWindowNames.UIResourceLackNew)
            local mainBuild = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_MAIN)
            local level = mainBuild.level
            local id = BuildingTypes.FUN_BUILD_MAIN+level-1
            CS.SceneManager.World:UICreateBuilding(id, mainBuild.uuid,LuaEntry.Player:GetMainWorldPos(), PlaceBuildType.MoveCity)
        end
    elseif itemId == BuildingUtils.ITEM_SMELTING 
        or itemId == BuildingUtils.ITEM_MATERIAL  then
        local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
        if itemTemplate ~= nil then
            UIUtil.ShowTips(Localization:GetString(GameDialogDefine.GOT)
                    .. " "
                    .. Localization:GetString(itemTemplate.name)
                    .. "+"
                    .. dif)
        end
    end
end

PushItemAddMessage.OnCreate = OnCreate
PushItemAddMessage.HandleMessage = HandleMessage

return PushItemAddMessage