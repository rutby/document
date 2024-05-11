local ItemData = BaseClass("ItemData")
local Localization = CS.GameEntry.Localization
local ItemInfo = require "DataCenter.ItemData.ItemInfo"

local function __init(self)
	self.ItemInfos = {}--这里面存的是玩家的物品 uuid,itemInfo
	self.ItemIdAndUuid = {}--这里面存的是itemId和uuid的对应关系 方便用itemId来查找
	self.StatusItems = {}
	self.AllUseStatusItem = {}
end

local function __delete(self)
	self.ItemInfos = {}--这里面存的是玩家的物品 uuid,itemInfo
	self.ItemIdAndUuid = {}--这里面存的是itemId和uuid的对应关系 方便用itemId来查找
	self.StatusItems = {}
	self.AllUseStatusItem = {}
end

--通过itemId获取道具
local function GetItemById(self,numId)
	local id = tostring(numId)
	if self.ItemIdAndUuid ~= nil and self.ItemIdAndUuid[id] ~= nil then
		return self.ItemInfos[self.ItemIdAndUuid[id]]
	end
	return nil
end

--通过GOODS_TYPE获取道具
local function GetItemsByType(self,type)
	local list = DataCenter.ItemTemplateManager:GetTypeListByType(type)
	if list ~= nil then
		local result = {}
		for k,v in pairs(list) do
			local item = self:GetItemById(v.id)
			if item ~= nil then
				table.insert(result,item)
			end
		end
		return result
	end
	return nil
end

--获取装备的所有物品 原m_mateTools
local function GetMateToolsList(self) 
	return self:GetItemsByType(GOODS_TYPE.GOODS_TYPE_7)
end

--获取GOODS_TYPE_62所有物品 原m_type62
local function GetType62List(self)
	return self:GetItemsByType(GOODS_TYPE.GOODS_TYPE_62)
end

local function ParseItemData(self, items)
	self.ItemInfos = {}
	self.isNew = true
	if items ~= nil then
		for k,v in pairs(items) do
			--初始化时标记道具为旧道具
			self:UpdateOneItem(v)
		end
	end
	self.isNew = false
end

--更新一组item
local function UpdateItems(self, items)
	if items ~= nil then
		for k,v in pairs(items) do
			self:UpdateOneItem(v)
		end
		
	end
end
--更新一个item
local function UpdateOneItem(self, message, noSendSignal)
	local uuid = message["uuid"]
	if uuid ~= nil then
		local isNewGood = false
		if self.ItemInfos[uuid] == nil then
			isNewGood = true
			self.ItemInfos[uuid] = ItemInfo.New()
		end
		local item = self.ItemInfos[uuid]
		if item ~= nil then
			item:UpdateInfo(message)
			local itemId = item.itemId
			self.ItemIdAndUuid[itemId] = uuid
			if item.count <= 0 then
				self.ItemInfos[uuid] = nil
				self.ItemIdAndUuid[itemId] = nil
			else
				local template = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
				if template ~= nil then
					if template.important == 2 then
						if template.needCount and template.needCount <= item.count then
							item.redState = false
							EventManager:GetInstance():Broadcast(EventId.OnGoodsRedState,true)
						else
							item.redState = true
						end
					else
						local countState = self.isNew and true or not (item.count >= template.important)
						item.redState = (template.important == 0) and true or countState
					end
					--新道具
					if isNewGood and (template.important == 1) then
						if not self.isNew then
							EventManager:GetInstance():Broadcast(EventId.OnGoodsRedState,true)
						end
					end
				end
			end
		end
	else
		Logger.Log("item can not get uuid from server !!!!!")
		local id = nil
		if message["itemId"] ~= nil then
			id = message["itemId"]
		elseif message["goodsId"] ~= nil then
			id = message["goodsId"]
		end

		if id ~= nil and id ~= "" then
			if self.ItemIdAndUuid[id] ~= nil then
				local item = self.ItemInfos[self.ItemIdAndUuid[id]]
				if item ~= nil then
					item:UpdateInfo(message)
					if item.count <= 0 then
						self.ItemInfos[self.ItemIdAndUuid[id]] = nil
						self.ItemIdAndUuid[id] = nil
					end
				else
					self.ItemIdAndUuid[id] = nil
				end
			end
		end
	end
	if not noSendSignal then
		EventManager:GetInstance():Broadcast(EventId.RefreshItems, true)
	end
end

local function GetItemStatusArrayByType(self,type,bAlive,onlyType)
	local list = DataCenter.ItemTemplateManager:GetTypeListByType(type)
	if list ~= nil and bAlive then
		return list
	end
	
	local mainLv = DataCenter.BuildManager.MainLv
	local result = {}
	if type == 120 then
		list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_3)
		if list ~= nil then
			for k,v in pairs(list) do
				if v.type2 == type then
					table.insert(result,v)
				end
			end
		end
	elseif type == 100 then
		list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_4)
		if list ~= nil then
			for k,v in pairs(list) do
				if v.type2 == type and v.lv <= mainLv and (bAlive or v.price ~= 0) then
					table.insert(result,v)
				end
			end
		end
	else
		list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_4)
		if list ~= nil then
			for k,v in pairs(list) do
				if v.type2 == type and v.lv <= mainLv then
					if type == 18 then
						if self:GetItemById(v.id) ~= nil then
							table.insert(result,v)
						end
					else
						table.insert(result,v)
					end
				end
			end
		end

		list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_16)
		if list ~= nil then
			local haveLeftTime = self.StatusItems[18] ~= nil
			for k,v in pairs(list) do
				if v.type2 == type and v.lv <= mainLv then
					if haveLeftTime or self:GetItemById(v.id) ~= nil then
						table.insert(result,v)
					end
				end
			end
		end

		list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_50)
		if list ~= nil then
			local haveLeftTime = self.StatusItems[38] ~= nil
			for k,v in pairs(list) do
				if v.type2 == type and v.lv <= mainLv then
					if haveLeftTime or self:GetItemById(v.id) ~= nil then
						table.insert(result,v)
					end
				end
			end
		end

		list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_57)
		if list ~= nil then
			local haveLeftTime = self.StatusItems[38] ~= nil
			for k,v in pairs(list) do
				if v.type2 == type and v.lv <= mainLv then
					if haveLeftTime or self:GetItemById(v.id) ~= nil then
						table.insert(result,v)
					end
				end
			end
		end
	end
	if #result > 0 then
		table.sort(result,function(a,b)
			return a.order > b.order
		end)
	end
	return result
end

local function UpdateEffectList(status)
	for i, v in ipairs(status) do
		LuaEntry.Effect:UpdateEffectStatus(tonumber(v.effVal),tonumber(v.effNum),tonumber(v.stateId),tonumber(v.endTime))
	end
end

local function OnUseRet(self,message)
	local template = DataCenter.ItemTemplateManager:GetItemTemplate(message["itemId"])
	if template ~= nil then
		local itemEffectObj = message["itemEffectObj"]
		if itemEffectObj ~= nil then
			if itemEffectObj.status ~= nil then
				UpdateEffectList(itemEffectObj.status)
			end
			if  itemEffectObj["oldStatus"] ~= nil then
				local reStatusId = itemEffectObj["oldStatus"]
				LuaEntry.Effect:RemoveStatus(reStatusId);
			end
			local stateObj = itemEffectObj["effectState"]
			if stateObj ~= nil then
			
				local type = template.type
				local type2 = template.type2
				for k,v in pairs(stateObj) do
					local intKey = tonumber(k)
					local numValue = tonumber(v)
					if k ~= "startTime" then
						if intKey >= EffectStateDefine.PLAYER_PROTECTED_TIME1 and intKey <= EffectStateDefine.PLAYER_PROTECTED_TIME5 then
							LuaEntry.Player.ProtectTimeStamp = numValue
						end
						local temp = {}
						local param = {}
						param.intKey = intKey
						param.numValue = numValue
						--table.insert(temp,param)
						temp[intKey] = numValue
						self:SetAllStatusItem(temp)
						LuaEntry.Effect:AddStatus(intKey,numValue)
					end
					
					if type == GOODS_TYPE.GOODS_TYPE_4 or type == GOODS_TYPE.GOODS_TYPE_22 or type == GOODS_TYPE.GOODS_TYPE_50 
							or type == GOODS_TYPE.GOODS_TYPE_55 or type == GOODS_TYPE.GOODS_TYPE_57 then
						local dic = self.StatusItems[type2]
						if dic == nil then
							dic = StatusItem.New()
							if k ~= "startTime" then
								dic.stateId = intKey
								dic.endTime = numValue
							else
								dic.StartTime = numValue
							end
							self.StatusItems[type2] = dic
						else
							if k ~= "startTime" then
								dic.stateId = intKey
								dic.endTime = numValue
								dic.StartTime = UITimeManager:GetInstance():GetServerTime()
							else
								dic.StartTime = numValue
							end
						end
					end
				end
				EventManager:GetInstance():Broadcast(EventId.UpdateWorldMapInfo)
				if type == GOODS_TYPE.GOODS_TYPE_4 or type == GOODS_TYPE.GOODS_TYPE_22 or type == GOODS_TYPE.GOODS_TYPE_50
						or type == GOODS_TYPE.GOODS_TYPE_55 or type == GOODS_TYPE.GOODS_TYPE_57 then
					EventManager:GetInstance():Broadcast(EventId.MSG_ITME_STATUS_TIME_CHANGE,type2)
					--type2 == 1 是8小时守护罩
					if type2 == 1 then
						local dic = self.StatusItems[type2]
						local tempTime = 0
						if dic ~= nil then
							tempTime = dic.endTime - UITimeManager:GetInstance():GetServerTime()
						end
						if tempTime > 0 then
							--CS.PushManager.Instance:pushNotice(20160428, tempTime - (30 * 60), Localization:GetString("300030"), "0", "28", PushType.NOT_CHECK);
						end
					end
				end
			end
		end
	end
end



local function CheckUseStateTool(self,template,yesCallback)
	local temp = self.StatusItems[template.type2]
	if temp ~= nil and temp.endTime > UITimeManager:GetInstance():GetServerTime() then
		UIUtil.ShowMessage(Localization:GetString("120015"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, yesCallback)
		return false
	end
	return true
end

--使用道具，减少道具数量为0 删除 有可能连续使用多个 道具。这里不发送刷新道具事件
local function UseTool(self,itemId,num)
	local item = self:GetItemById(itemId)
	if item ~= nil then
		if item.count <= num then
			item.count = 0
			self.ItemInfos[item.uuid] = nil
			self.ItemIdAndUuid[itemId] = nil
		else
			item.count = item.count - num
		end
	end
end

--获取加速道具
local function GetSpeedItem(self,type2)
	local list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_2)
	if list ~= nil then
		local result = {}
		for k,v in pairs(list) do
			if v.type2 == ItemSpdMenu.ItemSpdMenu_ALL or v.type2 == type2 then
				local item = self:GetItemById(v.id)
				if item ~= nil and item.count > 0 then
					table.insert(result, item)
				end
			end
		end
		return result
	end
	return nil
end

--获取已有道具通过type1，type2
local function GetItemList(self,type,type2)
	local list = DataCenter.ItemTemplateManager:GetTypeListByType(type)
	if list ~= nil then
		local result = {}
		for k,v in pairs(list) do
			if  v.type2 == type2 then
				local item = self:GetItemById(v.id)
				if item ~= nil then
					table.insert(result,item)
				end
			end
		end
		return result
	end
	return nil
end

--通过uuid获取item
local function GetItemByUuid(self,uuid) 
	return self.ItemInfos[uuid]  
end

--通过uuid设置道具数量
local function SetItemCountByUuid(self,uuid,count)
	local item = self:GetItemByUuid(uuid)
	if count <= 0 then
		if item ~= nil then
			item.count = 0
			self.ItemIdAndUuid[item.itemId] = nil
			self.ItemInfos[uuid] = nil
		end
	else
		if item == nil then
			self.ItemInfos[uuid] = ItemInfo.New()
		end
		item.count = count
	end
end

local function SetItemRed(self,uuid)
	local item = self:GetItemByUuid(uuid)
	if item then
		self.ItemInfos[uuid].redState = true
	end
end

--获取英雄升级经验道具
-- 已弃用，现在升级用资源
local function GetHeroExpItem(self)
	local list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_91)
	if list == nil then
		return nil
	end
	
	local result = {}
	for _,v in pairs(list) do
		local item = self:GetItemById(v.id)
		if item ~= nil then
			local param = {}
			param.item = item
			param.order = v.order
			param.template = v
			param.id = tonumber(v.id)
			param.addNum = tonumber(v.para)
			if param.addNum == 1 then -- 扬骋的规则 2024/3/12
				table.insert(result, param)
			end
		end
	end
	
	return result
end

--通过类型获取状态道具
local function GetStatusItem(self,type) 
	return self.StatusItems[type]
end

local function GetItemCount(self, itemConfigId)
	local itemData = self:GetItemById(tostring(itemConfigId))
	return itemData and itemData.count or 0
end

local function SetAllStatusItem(self,param)
	for k, v in pairs(param) do
		if self.AllUseStatusItem[k] == nil then
			self.AllUseStatusItem[k] = v
		end
	end
end

--获取道具(赛季专精)
local function GetMasteryPointItem(self)
	local list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_48)
	if list ~= nil then
		local result = {}
		local buyResult = {}
		for k,v in pairs(list) do
			local item = self:GetItemById(v.id)
			if item ~= nil and item.count>0 then
				table.insert(result,item)
			else
				table.insert(buyResult,v)
			end
		end
		
		return buyResult,result
	end
	return nil
end

--获取所有英雄勋章（通用 + 英雄）
function ItemData:GetAllHeroPageList()
	local result = {}
	local list = self:GetItemsByType(GOODS_TYPE.GOODS_TYPE_62)--通用
	if list ~= nil then
		for k, v in ipairs(list) do
			table.insert(result, v)
		end
	end
	list = self:GetItemsByType(GOODS_TYPE.GOODS_TYPE_93)--普通英雄
	if list ~= nil then
		for k, v in ipairs(list) do
			table.insert(result, v)
		end
	end
	return result
end

--获取背包红点数量
function ItemData:GetStorageRedNum()
	local result = 0
	if self.ItemInfos ~= nil then
		for k,v in pairs(self.ItemInfos) do
			local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
			if goods ~= nil and v.count > 0 and goods.page >= 0 then
				if not v.redState then
					result = result + 1
				end
			end
		end
	end
	return result
end

--是否有背包红点
function ItemData:HasStorageRed()
	if self.ItemInfos ~= nil then
		for k,v in pairs(self.ItemInfos) do
			local goods = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
			if goods ~= nil and v.count > 0 and goods.page >= 0 then
				if not v.redState then
					return true
				end
			end
		end
	end
	return false
end

--获取英雄升级经验道具
function ItemData:GetHeroExpItemCount()
	-- 现在使用肉了 2024/4/9
	return LuaEntry.Resource:GetCntByResType(ResourceType.Food)
	--local result = 0
	--local list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_91)
	--if list ~= nil then
	--	for _,v in pairs(list) do
	--		local item = self:GetItemById(v.id)
	--		if item ~= nil then
	--			local per = tonumber(v.para)
	--			if per == 1 then -- 扬骋的规则 2024/3/12
	--				result = result + per * item.count
	--			end
	--		end
	--	end
	--end
	--return result
end

--获取英雄升级需要的消耗的经验道具
function ItemData:GetCostHeroExpItem(needExp)
	local result = {}
	local list = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_91)
	if list ~= nil then
		local per = 0
		local use = 0
		local count = 0
		for _,v in pairs(list) do
			local item = self:GetItemById(v.id)
			if item ~= nil then
				per = tonumber(v.para)
				if per == 1 then -- 扬骋的规则 2024/3/12
					use = per * item.count
					count = item.count
					if use > needExp then
						count = math.ceil(needExp / per)
						use = per * count
					end
					needExp = needExp - use
					table.insert(result, {uuid = item.uuid, count = count})
					if needExp <= 0 then
						return result
					end
				end
			end
		end
	end
	return result
end

local function GetPosterItemIdsByRarity(self, camp, rarity)
	local itemIds = {}
	local typeList = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_201)
	for _, template in ipairs(typeList) do
		local heroId = tonumber(template.para1)
		local heroCamp = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "camp")
		local heroRarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
		if heroCamp == camp and heroRarity == rarity then
			table.insert(itemIds, template.id)
		end
	end
	return itemIds
end

local function GetPosterCountByCampRarity(self, camp, rarity)
	local count = 0
	local typeList = DataCenter.ItemTemplateManager:GetTypeListByType(GOODS_TYPE.GOODS_TYPE_201)
	for _, template in ipairs(typeList) do
		local heroId = tonumber(template.para1)
		local heroCamp = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "camp")
		local heroRarity = GetTableData(HeroUtils.GetHeroXmlName(), heroId, "rarity")
		if heroCamp == camp and heroRarity == rarity then
			count = count + self:GetItemCount(template.id)
		end
	end
	return count
end

ItemData.ParseItemData = ParseItemData
ItemData.__init = __init
ItemData.__delete = __delete
ItemData.GetItemById = GetItemById
ItemData.GetItemsByType = GetItemsByType
ItemData.GetMateToolsList = GetMateToolsList
ItemData.GetType62List = GetType62List
ItemData.UpdateOneItem = UpdateOneItem
ItemData.GetItemStatusArrayByType = GetItemStatusArrayByType
ItemData.OnUseRet = OnUseRet
ItemData.CheckUseStateTool = CheckUseStateTool
ItemData.UseTool = UseTool
ItemData.GetItemByUuid = GetItemByUuid
ItemData.GetSpeedItem = GetSpeedItem
ItemData.UpdateItems = UpdateItems
ItemData.SetItemCountByUuid = SetItemCountByUuid
ItemData.GetHeroExpItem = GetHeroExpItem
ItemData.GetStatusItem = GetStatusItem
ItemData.GetItemCount = GetItemCount
ItemData.SetAllStatusItem = SetAllStatusItem
ItemData.GetItemList = GetItemList
ItemData.SetItemRed = SetItemRed
ItemData.GetMasteryPointItem = GetMasteryPointItem
ItemData.GetPosterItemIdsByRarity = GetPosterItemIdsByRarity
ItemData.GetPosterCountByCampRarity = GetPosterCountByCampRarity

return ItemData