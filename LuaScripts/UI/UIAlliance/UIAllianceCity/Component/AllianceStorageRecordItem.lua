local AllianceStorageRecordItem = BaseClass("AllianceStorageRecordItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local headIcon_path = "UIPlayerHead/HeadIcon"
local headFg_path = "UIPlayerHead/Foreground"
local playerName_path = "recordTitle"
local costItem_path = "cost/costItem"
local time_path = "time"
local recordIndex_path = "time (1)"

local LogType =
{
	RESEARCH_SCIENCE = 1,
	BUILD_ALLIANCE_BUILDING = 2,
	DECLARE_WAR = 3,
	RANDOM_DECLARE_ENEMY = 4,
}

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
	self.headIconN = self:AddComponent(UIPlayerHead, headIcon_path)
	self.headFgN = self:AddComponent(UIImage, headFg_path)
	self.playerNameN = self:AddComponent(UITextMeshProUGUIEx, playerName_path)
	self.costItemsTb = {}
	for i = 1, 4 do
		local costItem = self:AddComponent(UIBaseContainer, costItem_path .. i)
		local newCost = {}
		newCost.rootN = costItem
		newCost.iconN = costItem:AddComponent(UIImage, "costIcon")
		newCost.countN = costItem:AddComponent(UITextMeshProUGUIEx, "costNum")
		table.insert(self.costItemsTb, newCost)
	end
	self.timeN = self:AddComponent(UITextMeshProUGUIEx, time_path)
	self.recordIndexN = self:AddComponent(UITextMeshProUGUIEx, recordIndex_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.headIconN = nil
	self.headFgN = nil
	self.playerNameN = nil
	self.costItemsTb = nil
	self.timeN = nil
end

--变量的定义
local function DataDefine(self)
	self.recordInfo = nil
end

--变量的销毁
local function DataDestroy(self)
	self.recordInfo = nil
end

local function OnAddListener(self)
	base.OnAddListener(self)
	--self:AddUIListener(EventId.AllianceCityNameChange, self.OnChangeName)

end

local function OnRemoveListener(self)
	--self:RemoveUIListener(EventId.AllianceCityNameChange, self.OnChangeName)
	base.OnRemoveListener(self)
end

local function SetItem(self, recordInfo, index)
	self.recordInfo = recordInfo
	
	self.recordIndexN:SetText(index)
	self.headIconN:SetData(recordInfo.uid, recordInfo.pic, recordInfo.picVer)
	local tempFg = self.recordInfo:GetHeadBgImg()
	if tempFg then
		self.headFgN:SetActive(true)
		self.headFgN:LoadSprite(tempFg)
	else
		self.headFgN:SetActive(false)
	end

	if self.recordInfo.type == LogType.RESEARCH_SCIENCE then
		-- 研究科技
		local scienceId = tonumber(self.recordInfo.param)
		local temp = math.modf(scienceId / 100) * 100
		local lv = scienceId % 100
		--local scienceInfo = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(self.recordInfo.param)
		--local tempLv = scienceInfo and scienceInfo.curLevel or 0
		self.playerNameN:SetText(Localization:GetString("390970", self.recordInfo.userName, Localization:GetString(GetTableData(TableName.AlScienceTab, temp,"name")), lv))

	elseif self.recordInfo.type == LogType.BUILD_ALLIANCE_BUILDING then
		-- 建造联盟建筑
		local allianceResourceId = tonumber(self.recordInfo.param)
		local allianceMineTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceResourceId)
		if allianceMineTemplate then
			self.playerNameN:SetText(Localization:GetString("302932", self.recordInfo.userName, Localization:GetString(allianceMineTemplate.name)))
		else
			self.playerNameN:SetText("")
		end
	elseif self.recordInfo.type == LogType.DECLARE_WAR then
		-- 宣战
		self.playerNameN:SetText(Localization:GetString("302931", self.recordInfo.userName))
	elseif self.recordInfo.type == LogType.RANDOM_DECLARE_ENEMY then
		-- 匹配
		self.playerNameN:SetText(Localization:GetString("302933", self.recordInfo.userName))
	end
	
	for i, v in ipairs(self.costItemsTb) do
		if i <= #self.recordInfo.cost then
			v.rootN:SetActive(true)
			v.iconN:LoadSprite(self:GetIcon(self.recordInfo.cost[i].rewardType))
			v.countN:SetText("-" .. string.GetFormattedStr(self.recordInfo.cost[i].count))
		else
			v.rootN:SetActive(false)
		end
	end
	
	local strTime = UITimeManager:GetInstance():GetTimeToMD(math.modf(self.recordInfo.time / 1000))
	self.timeN:SetText(strTime)
end

local function GetIcon(self, rewardType)
	if rewardType == RewardType.SAPPHIRE then
		return string.format(LoadPath.ItemPath, "allianceResource")
	elseif rewardType == RewardType.ALLIANCE_POINT then
		return string.format(LoadPath.ItemPath, "allianceCoin")
	end
end



AllianceStorageRecordItem.OnCreate = OnCreate
AllianceStorageRecordItem.OnDestroy = OnDestroy
AllianceStorageRecordItem.ComponentDefine = ComponentDefine
AllianceStorageRecordItem.ComponentDestroy = ComponentDestroy
AllianceStorageRecordItem.DataDefine = DataDefine
AllianceStorageRecordItem.DataDestroy = DataDestroy
AllianceStorageRecordItem.OnAddListener = OnAddListener
AllianceStorageRecordItem.OnRemoveListener = OnRemoveListener
AllianceStorageRecordItem.SetItem = SetItem
AllianceStorageRecordItem.GetIcon = GetIcon
return AllianceStorageRecordItem