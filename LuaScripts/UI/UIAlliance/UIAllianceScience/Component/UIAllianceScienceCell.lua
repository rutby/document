local UIAllianceScienceCell = BaseClass("UIAllianceScienceCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray

local this_path = ""
local icon_bg_path = "icon_bg"
local icon_path = "icon_bg/icon"
local level_text_path = "text_bg/level_text"
local name_text_path = "name_text"
local line1_path = "line1"
local line2_path = "line2"
local recommend_icon_path = "icon_bg/recommend_icon"
local upgrade_icon_path = "icon_bg/upgrade_icon"
local red_go_path = "icon_bg/RedDotWithoutNum"

local NormalColor = Color.New(1, 1, 1, 1)
local MaxColor = Color.New(0.9686275,0.882353,0.3843138,1)
local PositionDelta = 0

-- 创建
function UIAllianceScienceCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIAllianceScienceCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIAllianceScienceCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIAllianceScienceCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIAllianceScienceCell:ComponentDefine()
	self.btn = self:AddComponent(UIButton, this_path)
	self.btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
	self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
	self.icon = self:AddComponent(UIImage, icon_path)
	self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
	self.line1 = self:AddComponent(UIImage, line1_path)
	self.line2 = self:AddComponent(UIImage, line2_path)
	self.recommend_icon = self:AddComponent(UIBaseContainer, recommend_icon_path)
	self.upgrade_icon = self:AddComponent(UIBaseContainer, upgrade_icon_path)
	self.red_go = self:AddComponent(UIBaseContainer, red_go_path)
end

--控件的销毁
function UIAllianceScienceCell:ComponentDestroy()
end

--变量的定义
function UIAllianceScienceCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIAllianceScienceCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIAllianceScienceCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIAllianceScienceCell:Refresh()
	self.name_text:SetLocalText(GetTableData(TableName.AlScienceTab, self.param.scienceId,"name"))
	self.icon:LoadSprite(string.format(LoadPath.ScienceIcons, GetTableData(TableName.AlScienceTab, self.param.scienceId,"icon")))
	
	local curLevel = DataCenter.AllianceScienceDataManager:GetScienceLevel(self.param.scienceId)
	local maxLevel = GetTableData(TableName.AlScienceTab, self.param.scienceId,"max_lv")
	if maxLevel <= curLevel then
		self.level_text:SetLocalText(GameDialogDefine.MAX)
		self.level_text:SetColor(MaxColor)
		--self.icon_bg:LoadSprite(string.format(LoadPath.ScienceIcons, "science_icon_frame01"))
		UIGray.SetGray(self.icon_bg.transform, false, false)
	else
		self.level_text:SetText(curLevel.."/"..maxLevel)
		self.level_text:SetColor(NormalColor)
		if self:IsUnLockScience() then
			--self.icon_bg:LoadSprite(string.format(LoadPath.ScienceIcons, "science_icon_frame01"))
			UIGray.SetGray(self.icon_bg.transform, false, false)
		else
			--self.icon_bg:LoadSprite(string.format(LoadPath.UIScience, "science_img_mengban"))
			UIGray.SetGray(self.icon_bg.transform, true, false)
		end
	end
	self:RefreshCommend()
	self:RefreshRedAndUpgrade()
	local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(self.param.scienceId)
	if data ~= nil then
		--线
		local state1 = ScienceLineState.No
		local needScience = data.science_condition
		if needScience ~= nil and needScience[1] ~= nil then
			state1 = ScienceLineState.Dark
			for k,v in ipairs(needScience) do
				if DataCenter.AllianceScienceDataManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
					state1 = ScienceLineState.Light
					break
				end
			end
		end
		if state1 == ScienceLineState.No then
			self.line1:SetActive(false)
		else
			self.line1:SetActive(true)
			if state1 == ScienceLineState.Light then
				self.line1:LoadSprite(string.format(LoadPath.UIScience, "science_bar5_02"))
			elseif state1 == ScienceLineState.Dark then
				self.line1:LoadSprite(string.format(LoadPath.UIScience, "science_bar5_01"))
			end
		end

		local state2 = ScienceLineState.No
		local list = self.param.preAndNeed[self.param.scienceId]
		if list ~= nil and list[1] ~= nil then
			state2 = ScienceLineState.Dark
			for k,v in ipairs(list) do
				if v.needLevel <= curLevel then
					state2 = ScienceLineState.Light
					break
				end
			end
		end

		if state2 == ScienceLineState.No then
			self.line2:SetActive(false)
		else
			self.line2:SetActive(true)
			if state2 == ScienceLineState.Light then
				self.line2:LoadSprite(string.format(LoadPath.UIScience, "science_bar5_02"))
			elseif state2 == ScienceLineState.Dark then
				self.line2:LoadSprite(string.format(LoadPath.UIScience, "science_bar5_01"))
			end
		end
	end
end

function UIAllianceScienceCell:OnBtnClick()
	EventManager:GetInstance():Broadcast(EventId.StopSvAutoToCell)
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceScienceInfo, NormalBlurPanelAnim, self.param.scienceId)
end

function UIAllianceScienceCell:IsUnLockScience()
	local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(self.param.scienceId)
	if data ~= nil then
		local needScience = data.science_condition
		if needScience ~= nil and needScience[1] ~= nil then
			for k,v in ipairs(needScience) do
				if not DataCenter.AllianceScienceDataManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
					return false
				end
			end
		end
	end
	
	return true
end

function UIAllianceScienceCell:SetUpgradeEffect(go)
	go.gameObject:SetActive(true)
	go.transform:SetParent(self.transform)
	go.transform:SetAsFirstSibling()
	go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
	go.transform.localPosition = ResetPosition
end

function UIAllianceScienceCell:RefreshCommend()
	local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(self.param.scienceId)
	if data ~= nil then
		if data.state == AllianceScienceRecommendState.Yes then
			self.recommend_icon:SetActive(true)
		else
			self.recommend_icon:SetActive(false)
		end
	end
end

function UIAllianceScienceCell:RefreshRedAndUpgrade()
	local data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(self.param.scienceId)
	if data ~= nil then
		--能捐献显示红点
		local curTime = UITimeManager:GetInstance():GetServerTime()
		if data.finishTime > curTime then
			self.upgrade_icon:SetActive(false)
			self.red_go:SetActive(false)
		else
			local curLevel = DataCenter.AllianceScienceDataManager:GetScienceLevel(self.param.scienceId)
			local maxLevel = GetTableData(TableName.AlScienceTab, self.param.scienceId,"max_lv")
			if curLevel >= maxLevel then
				self.upgrade_icon:SetActive(false)
				self.red_go:SetActive(false)
			else
				local pre = false
				local needScience = data.science_condition
				if needScience ~= nil and needScience[1] ~= nil then
					for k,v in ipairs(needScience) do
						if not DataCenter.AllianceScienceDataManager:HasScienceByIdAndLevel(v.scienceId, v.level) then
							pre = true
							break
						end
					end
				end
				if pre then
					self.upgrade_icon:SetActive(false)
					self.red_go:SetActive(false)
				else
					if data.currentPro >= data.needPro then
						if DataCenter.AllianceBaseDataManager:IsR4orR5() then
							self.upgrade_icon:SetActive(true)
						else
							self.upgrade_icon:SetActive(false)
						end
						self.red_go:SetActive(false)
					else
						self.upgrade_icon:SetActive(false)
						--判断捐献次数是否足够
						local num = DataCenter.AllianceScienceDataManager:GetResDonateRestCount()
						if num >= AllianceScienceShowRedCount then
							self.red_go:SetActive(true)
						else
							self.red_go:SetActive(false)
						end
					end
				end
			end
		end
	end
end

return UIAllianceScienceCell