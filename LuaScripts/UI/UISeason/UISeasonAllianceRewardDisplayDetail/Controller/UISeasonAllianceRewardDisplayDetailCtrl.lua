---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 24224.
--- DateTime: 2022/12/12 16:02
---
local UISeasonAllianceRewardDisplayDetailCtrl = BaseClass("UISeasonAllianceRewardDisplayDetailCtrl", UIBaseCtrl)
local Data = CS.GameEntry.Data
local Localization = CS.GameEntry.Localization
function UISeasonAllianceRewardDisplayDetailCtrl:CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UISeasonAllianceRewardDisplayDetail)
end

function UISeasonAllianceRewardDisplayDetailCtrl:Close()
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

function UISeasonAllianceRewardDisplayDetailCtrl:GetRewardMap(topIndex)
    return DataCenter.DesertDataManager:GetRewardMap(topIndex)
end
function UISeasonAllianceRewardDisplayDetailCtrl:GetStageData(stageType,subStageType,topIndex)
    local showList = {}
    local data = DataCenter.DesertDataManager:GetRewardByStageAndSubStage(stageType,subStageType,topIndex)
    if data~=nil then
        local list = data.packagesList
        for k,v in pairs(list) do
            showList[v.order] = v
        end
    end
    return showList
end

function UISeasonAllianceRewardDisplayDetailCtrl:GetRewardAllianceData(stageType,subStageType,topIndex)
    local showList = {}
    
    local data = DataCenter.DesertDataManager:GetRewardByStageAndSubStage(stageType,subStageType,topIndex)
    if data~=nil then
        showList = data.allianceList
    end
    return showList
end
function UISeasonAllianceRewardDisplayDetailCtrl:GetRewardConditionDes(stageType,subStageType,topIndex)
    local desStr =""
    local data = DataCenter.DesertDataManager:GetRewardByStageAndSubStage(stageType,subStageType,topIndex)
    if data~=nil then
        desStr = data.condition_des
    end
    return desStr
end

function UISeasonAllianceRewardDisplayDetailCtrl:GetRewards(rewardList)
    local reward = {}
    if rewardList == nil then
        return reward
    end
    table.walk(rewardList, function (_, v)
        local item = {}
        item.count = v.count
        item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE)
        item.rewardType = v.rewardType
        local desc = DataCenter.RewardManager:GetDescByType(v.rewardType, v.itemId)
        local name = DataCenter.RewardManager:GetNameByType(v.rewardType, v.itemId)
        item.itemName = name
        item.itemDesc = desc
        item.isLocal = true
        if v.rewardType == RewardType.GOODS then
            if v.itemId ~= nil then
                --物品或英雄
                --item.itemName = Localization:GetString(name)
                item.itemId = v.itemId
                local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
                if goods ~= nil then
                    if goods.icon_big~=nil and goods.icon_big~="" then
                        item.icon_big = goods.icon_big
                    end
                    local join_method = -1
                    local icon_join = nil
                    if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
                        join_method = goods.join_method
                        icon_join = goods.icon_join
                    end

                    if join_method > 0 and icon_join ~= nil and icon_join ~= "" then
                        local tempJoin = string.split(icon_join, ";")
                        if #tempJoin > 1 then
                            item.itemColor = tempJoin[2]
                        end
                        if #tempJoin > 2 then
                            item.iconName = tempJoin[3]
                        end
                    else
                        --物品
                        item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color)
                        local itemType = goods.type
                        item.goodsType = goods.type
                        item.para2 = goods.para2
                        if itemType == 2 then
                            -- SPD
                            if goods.para1 ~= nil and goods.para1 ~= "" then
                                local para1 = goods.para1
                                local temp = string.split(para1, ';')
                                if temp ~= nil and #temp > 1 then
                                    item.itemFlag = temp[1] .. temp[2]
                                end
                            end
                        elseif itemType == 3 then
                            -- USE
                            local type2 = goods.type2
                            if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                                local res_num = tonumber(goods.para)
                                item.itemFlag = string.GetFormattedStr(res_num)
                            end
                        end

                        item.iconName = string.format(LoadPath.ItemPath, goods.icon)
                    end
                    if goods.icon_value ~= nil and goods.icon_value ~= "" then
                        item.icon_value = goods.icon_value
                    end
                end
            end
        elseif v.rewardType == RewardType.GOLD then
            item.iconName = DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold)
            item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
        elseif v.rewardType == RewardType.OIL or v.rewardType == RewardType.METAL or v.rewardType == RewardType.FORMATION_STAMINA
                or v.rewardType == RewardType.WATER or v.rewardType == RewardType.PVE_POINT or v.rewardType == RewardType.DETECT_EVENT
                or v.rewardType == RewardType.MONEY or v.rewardType == RewardType.ELECTRICITY then
            item.iconName = DataCenter.RewardManager:GetPicByType(v.rewardType)
            item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE)
        elseif v.rewardType == RewardType.EXP then
            item.itemColor = DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN)
            item.iconName = "Assets/Main/Sprites/UI/Common/New/Common_icon_exp.png"
        end
        table.insert(reward, item)
    end)
    return reward
end
return UISeasonAllianceRewardDisplayDetailCtrl