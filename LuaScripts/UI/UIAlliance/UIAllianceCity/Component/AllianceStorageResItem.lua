local AllianceStorageResItem = BaseClass("AllianceStorageResItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local resName_path = "resName"
local resIcon_path = "resIcon"
local curCount_path = "resCount"
local addCount_path = "resAdd"
local slider_path = "Slider"
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
	self.resNameN = self:AddComponent(UITextMeshProUGUIEx, resName_path)
	self.resIconN = self:AddComponent(UIImage, resIcon_path)
	self.resCountN = self:AddComponent(UITextMeshProUGUIEx, curCount_path)
	self.addCountN = self:AddComponent(UITextMeshProUGUIEx, addCount_path)
	self.slider = self:AddComponent(UISlider,slider_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.resNameN = nil
	self.resIconN = nil
	self.resCountN = nil
	self.addCountN = nil
end

--变量的定义
local function DataDefine(self)
	self.curRewardType = nil
end

--变量的销毁
local function DataDestroy(self)
	self.curRewardType = nil
end

local function OnAddListener(self)
	base.OnAddListener(self)
	--self:AddUIListener(EventId.AllianceCityNameChange, self.OnChangeName)

end

local function OnRemoveListener(self)
	--self:RemoveUIListener(EventId.AllianceCityNameChange, self.OnChangeName)
	base.OnRemoveListener(self)
end

local function SetItem(self, rewardType)
	self.curRewardType = rewardType

	if self.curRewardType == RewardType.ALLIANCE_POINT then
		self.resNameN:SetLocalText(390964)
		self.resIconN:LoadSprite(string.format(LoadPath.ItemPath, "allianceCoin"))
		local ownCount = DataCenter.AllianceStorageManager:GetResCountByRewardType(self.curRewardType)
		self.resCountN:SetText(string.GetFormattedStr(ownCount))
		self.addCountN:SetText("")
		self.slider:SetActive(false)
	else
		self.resNameN:SetLocalText(390967)
		self.resIconN:LoadSprite(string.format(LoadPath.ItemPath, "allianceResource"))

		local strConf = LuaEntry.DataConfig:TryGetStr("union_resources", "k1")
		local strArr = string.split(strConf, ";")
		local baseAdd = tonumber(strArr[1])
		local maxNum = tonumber(strArr[2])
		local effNum = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_STORAGE_MAX)
		maxNum = math.modf(maxNum * (1 + effNum / 100))
		
		
		local maxEff = LuaEntry.Effect:GetGameEffect(EffectDefine.ALLIANCE_STORAGE_MAX)
		local addEff_percent = LuaEntry.Effect:GetGameEffect(EffectDefine.SAPPHIRE_PRODUCT_SPEED_PERCENT)
		local addEff_num = LuaEntry.Effect:GetGameEffect(EffectDefine.SAPPHIRE_PRODUCT_SPEED_NUM)
		local newAdd = (baseAdd * 3600 + addEff_num) * (1 + addEff_percent)
		local addPerH = newAdd
		--addPerH = addPerH - addPerH % 0.01
		--local newMax = maxNum * (1 + maxEff)
		
		local ownCount = DataCenter.AllianceStorageManager:GetResCountByRewardType(self.curRewardType)
		self.resCountN:SetText(string.GetFormattedStr(math.modf(ownCount)) .. "/" .. string.GetFormattedStr(maxNum))
		self.slider:SetActive(true)
		local percent = math.min(1,(ownCount/math.max(maxNum,1)))
		self.slider:SetValue(percent)
		self.addCountN:SetText(Localization:GetString("390968", string.GetFormattedStr(addPerH)))
	end
end


AllianceStorageResItem.OnCreate = OnCreate
AllianceStorageResItem.OnDestroy = OnDestroy
AllianceStorageResItem.ComponentDefine = ComponentDefine
AllianceStorageResItem.ComponentDestroy = ComponentDestroy
AllianceStorageResItem.DataDefine = DataDefine
AllianceStorageResItem.DataDestroy = DataDestroy
AllianceStorageResItem.OnAddListener = OnAddListener
AllianceStorageResItem.OnRemoveListener = OnRemoveListener
AllianceStorageResItem.SetItem = SetItem
return AllianceStorageResItem