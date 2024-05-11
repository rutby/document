---------------------------------------------------------------------
-- dr_client (C) CompanyName, All Rights Reserved
-- Created by: AuthorName
-- Date: 2024-03-22 15:39:27
---------------------------------------------------------------------

-- To edit this template in: Data/Config/Template.lua
-- To disable this template, check off menuitem: Options-Enable Template File

---@class HeroEquipManager
local HeroEquipManager = BaseClass("HeroEquipManager")
local HeroEquipModel = require "DataCenter.HeroEquipManager.HeroEquipModel"

function HeroEquipManager:__init()
	self.allEquip = {}
end

function HeroEquipManager:__delete()
	self.allEquip = {}
end

function HeroEquipManager:GetAllEquip()
	return self.allEquip
end

local function CompareEquipByConfig(equip1, equip2)
	local a = DataCenter.HeroEquipTemplateManager:GetTemplate(equip1.equipId)
	local b = DataCenter.HeroEquipTemplateManager:GetTemplate(equip2.equipId)
	if a ~= nil and b ~= nil then
		if a.quality > b.quality then
			return true
		elseif a.quality == b.quality then
			if equip1.promote > equip2.promote then
				return true
			elseif equip1.promote == equip2.promote then
				if equip1.level > equip2.level then
					return true
				elseif equip1.level == equip2.level then
					if equip1.equipId > equip2.equipId then
						return true
					elseif equip1.equipId == equip2.equipId then
						return false
					end
				end
			end
		end
	end
	return false
end

function HeroEquipManager:GetAllEquipSorted()
	local result = {}
	for k, v in pairs(self.allEquip) do
		table.insert(result, v)
	end
	table.sort(result, self.CompareEquipByConfig)
	return result
end

function HeroEquipManager:GetEquipByUuid(uuid)
	return self.allEquip[uuid]
end

function HeroEquipManager:InitData(message)
	if message["heroEquips"] then
		for _, v in ipairs(message["heroEquips"]) do
			self:UpdateOrAddEquip(v)
		end
	end
end

function HeroEquipManager:UpdateOrAddEquip(param)
	local uuid = param["uuid"]
	if uuid == nil then
		return
	end
	local data = self:GetEquipByUuid(uuid)
	if data == nil then
		data = HeroEquipModel.New()
		self.allEquip[uuid] = data
	end
	data:ParseData(param)
	return data
end

function HeroEquipManager:RemoveEquip(equipUid)
	for k, v in pairs(self.allEquip) do
		if k == equipUid then
			self.allEquip[k] = nil
		end
	end
end

function HeroEquipManager:GetWearEquipUuidListByHeroId(heroId)
	local result = {}
	for k, v in pairs(self.allEquip) do
		if v.heroId == heroId then
			table.insert(result, v.uuid)
		end
	end
	return result
end

function HeroEquipManager:GetEquipListBySlot(slot)
	local result = {}
	for k, v in pairs(self.allEquip) do
		local equipConfig = DataCenter.HeroEquipTemplateManager:GetTemplate(v.equipId)
		if equipConfig ~= nil and equipConfig.slot == slot then
			table.insert(result, v)
		end
	end
	table.sort(result, self.CompareEquipByConfig)
	return result
end

function HeroEquipManager:GetOtherEquipListBySlot(equipUuid, slot)
	local result = {}
	for k, v in pairs(self.allEquip) do
		local equipConfig = DataCenter.HeroEquipTemplateManager:GetTemplate(v.equipId)
		if equipConfig ~= nil and equipConfig.slot == slot then
			if equipUuid == nil then
				table.insert(result, v)
			else
				if k ~= equipUuid then
					table.insert(result, v)
				end
			end
		end
	end
	table.sort(result, self.CompareEquipByConfig)
	return result
end

function HeroEquipManager:GetUnEquipListBySlot(slot)
	local result = {}
	local list = self:GetEquipListBySlot(slot)
	for k, v in pairs(list) do
		if v.heroId == 0 then
			table.insert(result, v)
		end
	end
	table.sort(result, self.CompareEquipByConfig)
	return result
end

function HeroEquipManager:GetEquipByHeroIdAndSlot(heroId, slot)
	for k, v in pairs(self.allEquip) do
		if v.heroId == heroId then
			local equipConfig = DataCenter.HeroEquipTemplateManager:GetTemplate(v.equipId)
			if equipConfig ~= nil and equipConfig.slot == slot then
				return v
			end
		end
	end
end

function HeroEquipManager:GetUnEquipListByQuality(quality)
	local result = {}
	for k, v in pairs(self.allEquip) do
		if v.heroId == 0 then
			local equipConfig = DataCenter.HeroEquipTemplateManager:GetTemplate(v.equipId)
			if equipConfig ~= nil and equipConfig.quality <= quality then
				table.insert(result, v)
			end
		end
	end
	table.sort(result,function(a,b)
		if a.equipId < b.equipId then
			return true
		end
		return false
	end)
	return result
end

function HeroEquipManager:HasBetterEquip(heroId, slot)
	local unEquipList = self:GetUnEquipListBySlot(slot)
	for i, v in pairs(unEquipList) do
		local curEquip = self:GetEquipByHeroIdAndSlot(heroId, slot)
		if self:CompareEquip(v, curEquip) then
			return true, v.uuid
		end
		break
	end
	return false
end

function HeroEquipManager:GetSuggestUnEquipUuidListByHeroId(heroId)
	local result = {}
	for k, slot in pairs(HeroEquipConst.Position) do
		local has, equipUuid = self:HasBetterEquip(heroId, slot)
		if has then
			table.insert(result, equipUuid)
		end
	end
	return result
end

function HeroEquipManager:CompareEquip(target, origin)
	if origin == nil then
		return true
	else
		if target ~= nil then
			if origin.uuid == target.uuid then
				return false
			else
				return self.CompareEquipByConfig(target, origin)
			end
		end
	end
	return false
end

function HeroEquipManager:CompareEquipByUuid(uuid1, uuid2)
	local origin = self:GetEquipByUuid(uuid1)
	local target = self:GetEquipByUuid(uuid2)
	return self:CompareEquip(origin, target)
end

function HeroEquipManager:PosHasRedDot(heroId, slot)
	local has, equipUuid = self:HasBetterEquip(heroId, slot)
	return has
end

function HeroEquipManager:IsEquipCanUpgrade(equipUid)
	local equipModel = self:GetEquipByUuid(equipUid)
	if equipModel ~= nil then
		local template = DataCenter.HeroEquipTemplateManager:GetTemplate(equipModel.equipId)
		if template ~= nil then
			return DataCenter.HeroEquipUpgradeTemplateManager:IsEnoughRes(template.slot, template.quality, equipModel.level)
		end
	end
	return false
end

function HeroEquipManager:IsEquipCanPromote(equipUid)
	local equipModel = self:GetEquipByUuid(equipUid)
	if equipModel ~= nil then
		local isMaxLevel = equipModel:IsMaxLevel()
		if isMaxLevel then
			return DataCenter.HeroEquipPromoteTemplateManager:IsEnoughRes(equipModel.promote)
		end
	end
	return false
end

function HeroEquipManager:GetEquipPower(equipUid)
	local equipModel = self:GetEquipByUuid(equipUid)
	if equipModel ~= nil then
		return equipModel:GetEquipPower()
	end
	return 0
end

function HeroEquipManager:GetAllEquipPower(heroId)
	local list = self:GetWearEquipUuidListByHeroId(heroId)
	local totalPower = 0
	local count = #list
	for i = 1, count do
		local power = self:GetEquipPower(list[i])
		totalPower = totalPower + power
	end
	return totalPower
end

function HeroEquipManager:GetEquipValueSumByHeroId(heroId, key)
	local sum = 0
	local equipUuids = DataCenter.HeroEquipManager:GetWearEquipUuidListByHeroId(heroId)
	for _, equipUuid in ipairs(equipUuids) do
		local equip = DataCenter.HeroEquipManager:GetEquipByUuid(equipUuid)
		if equip then
			local value = tonumber(GetTableData(TableName.EquipAttribute, equip.equipId, key)) or 0
			sum = sum + value
		end
	end
	return sum
end

--穿装备
function HeroEquipManager:HeroEquipInstall(heroId, equipUuids)
	if heroId == nil then
		UIUtil.ShowTips('heroId == nil')
	elseif equipUuids == nil or table.count(equipUuids) == 0 then
		UIUtil.ShowTips('equipUuids == nil')
	else
		SFSNetwork.SendMessage(MsgDefines.HeroEquipInstall, heroId, equipUuids)
	end
end

function HeroEquipManager:HeroEquipInstallHandler(message)
	local errCode =  message["errorCode"]
	if errCode ~= nil then
		UIUtil.ShowTipsId(errCode)
	else
		if message["updateEquips"] ~= nil then
			local power = 0
			local equipArr = message["updateEquips"]
			for _, equip in pairs(equipArr) do
				local model = self:UpdateOrAddEquip(equip)
				power = power + model:GetEquipPower()
			end

			GoToUtil.ShowPower({power = power})
			EventManager:GetInstance():Broadcast(EventId.HeroEquipInstall)
		end
	end
end
--脱装备
function HeroEquipManager:HeroEquipUninstall(heroId, equipUuids)
	if heroId == nil then
		UIUtil.ShowTips('heroId == nil')
	elseif equipUuids == nil or table.count(equipUuids) == 0 then
		UIUtil.ShowTips('equipUuids == nil')
	else
		SFSNetwork.SendMessage(MsgDefines.HeroEquipUninstall, heroId, equipUuids)
	end
end

function HeroEquipManager:HeroEquipUninstallHandler(message)
	local errCode =  message["errorCode"]
	if errCode ~= nil then
		UIUtil.ShowTipsId(errCode)
	else
		if message["updateEquips"] ~= nil then
			local equipArr = message["updateEquips"]
			for _, equip in pairs(equipArr) do
				self:UpdateOrAddEquip(equip)
			end
			EventManager:GetInstance():Broadcast(EventId.HeroEquipUninstall)
		end
	end
end
--装备升级
function HeroEquipManager:HeroEquipUpgrade(uuid)
	if uuid == nil then
		UIUtil.ShowTips('uuid == nil')
		return
	end
	local enoughRes, lack = self:IsEquipCanUpgrade(uuid)
	if enoughRes == false then
		GoToResLack.GoToItemResLackList({lack})
		return
	end
	SFSNetwork.SendMessage(MsgDefines.HeroEquipUpgrade, uuid)
end

function HeroEquipManager:HeroEquipUpgradeHandler(message)
	local errCode =  message["errorCode"]
	if errCode ~= nil then
		UIUtil.ShowTipsId(errCode)
	else
		local equipMsg = message["equip"]
		if equipMsg ~= nil then
			local oldModel = self:GetEquipByUuid(equipMsg.uuid)
			local oldPower = oldModel:GetEquipPower() or 0
			local newModel = self:UpdateOrAddEquip(equipMsg)
			local newPower = newModel:GetEquipPower() or 0
			EventManager:GetInstance():Broadcast(EventId.HeroEquipUpgrade)

			if newPower > oldPower then
				GoToUtil.ShowPower({power = newPower - oldPower})
			end
		end
	end
end
--装备晋升
function HeroEquipManager:HeroEquipPromote(uuid)
	if uuid == nil then
		UIUtil.ShowTips('uuid == nil')
		return
	end
	local enoughRes, lack = self:IsEquipCanPromote(uuid)
	if enoughRes == false then
		GoToResLack.GoToItemResLackList({lack})
		return
	end
	SFSNetwork.SendMessage(MsgDefines.HeroEquipPromoteUp, uuid)
end

function HeroEquipManager:HeroEquipPromoteHandler(message)
	local errCode =  message["errorCode"]
	if errCode ~= nil then
		UIUtil.ShowTipsId(errCode)
	else
		local equipMsg = message["equip"]
		if equipMsg ~= nil then
			local oldModel = self:GetEquipByUuid(equipMsg.uuid)
			local oldPower = oldModel:GetEquipPower() or 0
			local newModel = self:UpdateOrAddEquip(equipMsg)
			local newPower = newModel:GetEquipPower() or 0
			EventManager:GetInstance():Broadcast(EventId.HeroEquipPromotion)

			if newPower > oldPower then
				GoToUtil.ShowPower({power = newPower - oldPower})
			end
		end
	end
end
--装备生产
function HeroEquipManager:HeroEquipStartProduct(queueUuid, equipId)
	if queueUuid == nil or equipId == nil then
		UIUtil.ShowTips('queueUuid == nil || equipId == nil')
		return
	end

	local enoughRes, lack = DataCenter.HeroEquipTemplateManager:IsEnoughRes(equipId)
	if enoughRes == false then
		GoToResLack.GoToItemResLackList({lack})
		return
	end 
	SFSNetwork.SendMessage(MsgDefines.StartProductHeroEquip, queueUuid, equipId)
end

function HeroEquipManager:HeroEquipStartProductHandler(message)
	local errCode =  message["errorCode"]
	if errCode ~= nil then
		UIUtil.ShowTipsId(errCode)
	else
		if message["queue"] ~= nil then
			DataCenter.QueueDataManager:UpdateQueueData(message["queue"])
			EventManager:GetInstance():Broadcast(EventId.HeroEquipStartProduct)
		end
	end
end

function HeroEquipManager:HeroEquipCollect(queueUuid, equipId)
	if queueUuid == nil then
		UIUtil.ShowTips('queueUuid == nil')
		return
	end
	SFSNetwork.SendMessage(MsgDefines.QueueFinish, { uuid = queueUuid })
	
	self:ShowEquipReward(equipId)
end

function HeroEquipManager:ShowEquipReward(equipId)
	local template = DataCenter.HeroEquipTemplateManager:GetTemplate(equipId)
	if template ~= nil then
		local result = {}
		local list = {}
		local temp = {}
		temp["type"] = RewardType.HERO_EQUIP
		local value = {}
		value["id"] = equipId
		value["num"] = 1
		temp["value"] = value
		table.insert(list, temp)
		result["reward"] = list
		DataCenter.RewardManager:ShowCommonReward(result)
	end
end
--装备分解
function HeroEquipManager:HeroEquipDecompose(equipUuids)
	if equipUuids == nil or table.count(equipUuids) == 0 then
		UIUtil.ShowTipsId(GameDialogDefine.HERO_EQUIP6)
		return 
	end
	SFSNetwork.SendMessage(MsgDefines.HeroEquipDecompose, equipUuids)
end

function HeroEquipManager:HeroEquipDecomposeHandler(message)
	local errCode =  message["errorCode"]
	if errCode ~= nil then
		UIUtil.ShowTipsId(errCode)
	else
		if message["equipUuids"] ~= nil then
			local equipArr = message["equipUuids"]
			for _, equip in pairs(equipArr) do
				self:RemoveEquip(equip)
			end
			EventManager:GetInstance():Broadcast(EventId.HeroEquipDecompose)
		end
		if message["goodsArr"] ~= nil then
			local result = {}
			local temp = {}
			local goodsArr = message["goodsArr"]
			for _, item in pairs(goodsArr) do
				local param = {}
				param["type"] = RewardType.GOODS
				param["value"] = item
				table.insert(temp, param)
			end
			result["reward"] = temp
			DataCenter.RewardManager:ShowCommonReward(result)
		end
	end
end
--新装备推送
function HeroEquipManager:HeroEquipAddPushHandler(message)
	if message["newEquips"] ~= nil then
		for _, v in ipairs(message["newEquips"]) do
			self:UpdateOrAddEquip(v)
		end

		EventManager:GetInstance():Broadcast(EventId.HeroEquipModelUpdate)
	end
end

--材料合成
function HeroEquipManager:HeroEquipMaterialCompose(costId, exchangeNum)
	if costId == nil then
		UIUtil.ShowTips('costId == nil')
	elseif exchangeNum == nil then
		UIUtil.ShowTips('exchangeNum == nil')
	else
		SFSNetwork.SendMessage(MsgDefines.HeroEquipMaterialCompose, costId, exchangeNum)
	end
end

function HeroEquipManager:HeroEquipMaterialComposeHandler(message)
	local errorCode = message["errorCode"]
	if errorCode == nil then
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		if message["goodsArr"] ~= nil then
			local result = {}
			local temp = {}
			local goodsArr = message["goodsArr"]
			for _, item in pairs(goodsArr) do
				local param = {}
				param["type"] = RewardType.GOODS
				param["value"] = item
				table.insert(temp, param)
			end
			result["reward"] = temp
			DataCenter.RewardManager:ShowCommonReward(result)
		end

		EventManager:GetInstance():Broadcast(EventId.HeroEquipMaterialCompose)
	else
		UIUtil.ShowTipsId(errorCode)
	end
end
--材料分解
function HeroEquipManager:HeroEquipMaterialDecompose(costId, costNum)
	if costId == nil then
		UIUtil.ShowTips('costId == nil')
	elseif costNum == nil then
		UIUtil.ShowTips('costNum == nil')
	else
		SFSNetwork.SendMessage(MsgDefines.HeroEquipMaterialDecompose, costId, costNum)
	end
end

function HeroEquipManager:HeroEquipMaterialDecomposeHandler(message)
	local errorCode = message["errorCode"]
	if errorCode == nil then
		if message["resource"] ~= nil then
			LuaEntry.Resource:UpdateResource(message["resource"])
		end
		if message["goodsArr"] ~= nil then
			local result = {}
			local temp = {}
			local goodsArr = message["goodsArr"]
			for _, item in pairs(goodsArr) do
				local param = {}
				param["type"] = RewardType.GOODS
				param["value"] = item
				table.insert(temp, param)
			end
			result["reward"] = temp
			DataCenter.RewardManager:ShowCommonReward(result)
		end

		EventManager:GetInstance():Broadcast(EventId.HeroEquipMaterialDecompose)
	else
		UIUtil.ShowTipsId(errorCode)
	end
end

HeroEquipManager.CompareEquipByConfig = CompareEquipByConfig

return HeroEquipManager