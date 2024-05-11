

local UIGiftPackageRewardGetCtrl = BaseClass("UIGiftPackageRewardGetCtrl", UIBaseCtrl)

local function CloseSelf(self)
	self:ClearParam()
	local nextParam = DataCenter.RewardManager:GetParam()
	if nextParam == nil then
		UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftPackageRewardGet)
		EventManager:GetInstance():Broadcast(EventId.ActGolloesCardFlipAll,1)
		local param = DataCenter.RewardManager:GetViewParam()
		if param then
			if param.name then
				local isGoto = true
				UIManager:GetInstance():OpenWindow(param.name, param.extra,isGoto)
			end
		end
		DataCenter.RewardManager:ClearViewParam()
	else
		UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftPackageRewardGet)
		DataCenter.RewardManager:ShowCommonReward(nextParam,nil,nil,nil,nil,nil, nil, nil,nil,false)
	end
end

local function Close(self)
	self:ClearParam()
	local nextParam = DataCenter.RewardManager:GetParam()
	if nextParam == nil then
		DataCenter.RewardManager:ClearViewParam()
		UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
	else
		UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
		DataCenter.RewardManager:ShowCommonReward(nextParam,nil,nil,nil,nil,nil, nil, nil,nil,false)
	end
end

local function GetParam(self)
	local param = {}
	local reward = DataCenter.RewardManager:GetParam()
	if reward.isUpChange then
		local count = 0
		if reward.isUpChange == RewardType.GOODS then	--道具
			local item = DataCenter.ItemData:GetItemById(reward.rewardList[1].itemId)
			if item then
				count = item.count
			end
		elseif reward.isUpChange == RewardType.ARM then	--士兵
			local armyInfo = DataCenter.ArmyManager:FindArmy(reward.rewardList[1].itemId)
			if armyInfo then
				count = armyInfo.free
			end
		elseif reward.isUpChange == RewardType.PVE_POINT then
			if DataCenter.ItemTemplateManager:GetItemTemplate(RewardToResType[reward.isUpChange]) ~= nil then
				local item = DataCenter.ItemData:GetItemById(RewardToResType[reward.isUpChange])
				if item ~= nil then
					count =  item.count
				end
			else
				count = LuaEntry.Resource:GetCntByResType(RewardToResType[reward.isUpChange])
			end
		end
		param.rewardType = reward.rewardList[1].rewardType
		param.itemId = reward.rewardList[1].itemId
		param.count = count - reward.rewardList[1].count
		if param.count < 0 then
			param.count = 0
		end
		param.heroUuid = reward.rewardList[1].heroUuid
		param.isHeroBox = reward.rewardList[1].isHeroBox
		param.isArmyFly = reward.isArmyFly
		table.insert(reward.rewardList,1,param)
		reward.rewardList[2].count = count
	end
	return reward
end

local function ClearParam(self)
	DataCenter.RewardManager:ClearParam()
end


UIGiftPackageRewardGetCtrl.CloseSelf = CloseSelf
UIGiftPackageRewardGetCtrl.Close = Close
UIGiftPackageRewardGetCtrl.GetParam = GetParam
UIGiftPackageRewardGetCtrl.ClearParam = ClearParam

return UIGiftPackageRewardGetCtrl