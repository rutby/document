local UIBPTaskRewardCell = BaseClass("UIBPTaskRewardCell", UIBaseContainer)
local base = UIBaseContainer

local num_text_path = "NumText"
local icon_path = "IconImg"

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

-- 显示
local function OnEnable(self)
	base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
	base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
	self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
	self.icon = self:AddComponent(UIImage, icon_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.num_text = nil
	self.icon = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	self.icon:SetActive(true)
	self.num_text:SetText("x"..string.GetFormattedSeperatorNum(param.count))
	if self.param.rewardType ~= nil then
		if self.param.rewardType == RewardType.GOODS then
			if self.param.itemId == nil then

			else
				--物品或英雄
				local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
				if goods ~= nil then
					self.icon:LoadSprite(string.format(LoadPath.ItemPath,goods.icon))
				else
					local resourceType = tonumber(self.param.itemId)
					if resourceType < 100 then
						--资源
						self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
					end
				end
			end
		elseif self.param.rewardType == RewardType.GOLD then
			self.icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
		elseif self.param.rewardType == RewardType.OIL or self.param.rewardType == RewardType.METAL
				or self.param.rewardType == RewardType.WATER
				or self.param.rewardType == RewardType.MONEY or self.param.rewardType == RewardType.ELECTRICITY or self.param.rewardType == RewardType.WOOD then
			self.icon:LoadSprite(DataCenter.RewardManager:GetPicByType(self.param.rewardType))
		elseif self.param.rewardType == RewardType.ARM then
			local army = DataCenter.ArmyTemplateManager:GetArmyTemplate(self.param.itemId)
			if army ~= nil then
				self.icon:LoadSprite(string.format(LoadPath.SoldierIcons,army.icon))
			end
		elseif self.param.rewardType == RewardType.EQUIP then
			
		elseif self.param.rewardType == RewardType.HERO then
			local xmlData = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), self.param.itemId)
			if xmlData ~= nil then
				self:SetItemIconImage(xmlData["hero_icon"])
			end
		end
	end
end

UIBPTaskRewardCell.OnCreate = OnCreate
UIBPTaskRewardCell.OnDestroy = OnDestroy
UIBPTaskRewardCell.Param = Param
UIBPTaskRewardCell.OnEnable = OnEnable
UIBPTaskRewardCell.OnDisable = OnDisable
UIBPTaskRewardCell.ComponentDefine = ComponentDefine
UIBPTaskRewardCell.ComponentDestroy = ComponentDestroy
UIBPTaskRewardCell.DataDefine = DataDefine
UIBPTaskRewardCell.DataDestroy = DataDestroy
UIBPTaskRewardCell.ReInit = ReInit

return UIBPTaskRewardCell