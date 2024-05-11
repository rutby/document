---------------------------------------------------------------------
-- aps_new (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2021-09-07 11:14:52
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class RewardUtil
local RewardUtil = {}
local function GetPic(rewardType,itemId)
	if rewardType ~= nil then
		if rewardType == RewardType.GOODS then
			if itemId == nil then

			else
				--物品或英雄
				local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
				if goods ~= nil then
					return string.format(LoadPath.ItemPath,goods.icon)
				else
					local resourceType = tonumber(itemId)
					if resourceType < 100 then
						return DataCenter.ResourceManager:GetResourceIconByType(resourceType)
					end
				end
			end
		end
		return DataCenter.RewardManager:GetPicByType(rewardType,itemId)
	end
	return ""
end

local function SortRewardList(rewardList)
	table.sort(rewardList, function(a,b)
		local color_A = RewardUtil.GetRewardColor(a)
		local color_B = RewardUtil.GetRewardColor(b)
		return color_A > color_B
	end)
end

local function GetRewardColor(data)
	local color = ItemColor.WHITE
	if data == nil then
		return color
	end
	if data.rewardType == RewardType.GOODS then
		local goods = DataCenter.ItemTemplateManager:GetItemTemplate(data.itemId)
		color = goods.color
	elseif data.rewardType == RewardType.GOLD then
		color = ItemColor.PURPLE
	else
		color = ItemColor.WHITE
	end
	return color
end

RewardUtil.GetPic =GetPic
RewardUtil.SortRewardList = SortRewardList
RewardUtil.GetRewardColor = GetRewardColor
return ConstClass("RewardUtil", RewardUtil)