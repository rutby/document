--CollectRewardItem.lua

local CollectRewardItem = BaseClass("CollectRewardItem", UIBaseContainer)
local base = UIBaseContainer

local UICollectRewardCell = require "UI.UICollectReward.Component.UICollectRewardCell"
local monsterIcon_path = "UIPlayerHead/HeadIcon"
local monsterLv_path = "monsterLv"
local firstImage_path = "firstImage"
local firstText_path = "firstImage/firstText"
local monsterName_path = "monsterLv/monsterName"
local rewardContainer_path = "ScrollView/Viewport/Content"

-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end


--控件的定义
local function ComponentDefine(self)
	self.monsterIconN = self:AddComponent(CircleImage, monsterIcon_path)
	self.monsterLvN = self:AddComponent(UITextMeshProUGUIEx, monsterLv_path)
	self.monsterNameN = self:AddComponent(UITextMeshProUGUIEx, monsterName_path)
	self.firstTextN = self:AddComponent(UITextMeshProUGUIEx, firstText_path)
	self.firstTextN:SetLocalText(450086)
	self.rewardContainerN = self:AddComponent(UIBaseContainer, rewardContainer_path)
	self.firstImageN = self:AddComponent(UIBaseContainer, firstImage_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.monsterIconN = nil
	self.monsterLvN = nil
	self.monsterNameN = nil
	self.rewardContainerN = nil
end

--变量的定义
local function DataDefine(self)
	self.rewardItems = {}
end

--变量的销毁
local function DataDestroy(self)
	self.rewardItems = nil
end

local function SetItem(self, collectRewardData)
	local monsterTemplate = DataCenter.MonsterTemplateManager:GetMonsterTemplate(collectRewardData.contentId)
	local list = collectRewardData.rewardList
	local nfirst = false
	if monsterTemplate then
		local icon = LoadPath.HeroIconsSmallPath .. monsterTemplate:getValue("pic_name")
		self.monsterIconN:LoadSprite(icon)
		self.monsterNameN:SetLocalText(monsterTemplate:getValue("name"))
		self.monsterLvN:SetLocalText(300665, monsterTemplate:getValue("level"))
		local firstReward = DataCenter.MonsterTemplateManager:GetFirstShowReward(collectRewardData.contentId)
		local firstList = string.split(firstReward,"|")
		for k = 1, table.count(list) do
			list[k].firstKill = false
			for i = 1, table.count(firstList) do
				local strVec = string.split(firstList[i],";")
				if #strVec>2 then
					if list[k].rewardType == tonumber(strVec[2]) and list[k].itemId == strVec[1] then
						list[k].firstKill = true
						nfirst = true
					end
				end
			end
		end
	else
		local name = GetTableData(TableName.Desert, tonumber(collectRewardData.contentId), "desert_name")
		if name then
			local level = GetTableData(TableName.Desert, tonumber(collectRewardData.contentId), "desert_level")
			local icon = GetTableData(TableName.Desert, tonumber(collectRewardData.contentId), "icon")
			self.monsterNameN:SetLocalText(name)
			if level == 0 then
				self.monsterLvN:SetText("")
			else
				self.monsterLvN:SetLocalText(300665, level)
			end
			
			self.monsterIconN:LoadSprite(string.format(LoadPath.SeasonDesert,icon))
		end
	end
	self.firstImageN:SetActive(nfirst)
	self:SetAllCellDestroy()
	self.models = {}
	if list ~= nil then
		for i = 1, table.length(list) do
			--复制基础prefab，每次循环创建一次
			self.models[i] = self:GameObjectInstantiateAsync(UIAssets.UICollectRewardCell, function(request)
				if request.isError then
					return
				end
				local go = request.gameObject;
				--go.gameObject:SetActive(true)
				go.transform:SetParent(self.rewardContainerN.transform)
				go.transform:Set_localScale(1,1,1)
				go.name ="item" .. i
				local cell = self.rewardContainerN:AddComponent(UICollectRewardCell,go.name)
				cell:SetAnchoredPositionXY(0, 0)
				cell:ReInit(list[i])
			end)
		end
	end
end


local function SetAllCellDestroy(self)
	self.rewardContainerN:RemoveComponents(UICollectRewardCell)
	if self.models~=nil then
		for k,v in pairs(self.models) do
			if v ~= nil then
				self:GameObjectDestroy(v)
			end
		end
	end
	self.models = nil
end


CollectRewardItem.OnCreate = OnCreate
CollectRewardItem.OnDestroy = OnDestroy
CollectRewardItem.ComponentDefine = ComponentDefine
CollectRewardItem.ComponentDestroy = ComponentDestroy
CollectRewardItem.DataDefine = DataDefine
CollectRewardItem.DataDestroy = DataDestroy

CollectRewardItem.SetItem = SetItem
CollectRewardItem.SetAllCellDestroy = SetAllCellDestroy

return CollectRewardItem