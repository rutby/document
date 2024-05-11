local ScienceCell = BaseClass("ScienceCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray

local this_path = ""
local icon_bg_path = "icon_bg"
local icon_path = "icon_bg/icon"
local level_text_path = "text_bg/level_text"
local name_text_path = "name_text"
local line1_path = "line1"
local line2_path = "line2"

local NormalColor = Color.New(1, 1, 1, 1)
local MaxColor = Color.New(0.9686275,0.882353,0.3843138,1)
local PositionDelta = 0

-- 创建
function ScienceCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function ScienceCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function ScienceCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function ScienceCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function ScienceCell:ComponentDefine()
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
end

--控件的销毁
function ScienceCell:ComponentDestroy()
end

--变量的定义
function ScienceCell:DataDefine()
	self.param = {}
end

--变量的销毁
function ScienceCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function ScienceCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function ScienceCell:Refresh()
	local template = DataCenter.ScienceManager:GetScienceTemplate(self.param.scienceId)
	if template ~= nil then
		self.name_text:SetLocalText(template.name)
		self.icon:LoadSprite(string.format(LoadPath.ScienceIcons, template.icon))
		local curLevel = DataCenter.ScienceManager:GetScienceLevel(self.param.scienceId)
		local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(self.param.scienceId)
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
		if self.param.isReaching then
		else
		end

		local baseTemplate = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.param.scienceId, 1)
		if baseTemplate ~= nil then
			--线
			local state1 = ScienceLineState.No
			local needScience = baseTemplate.science_condition
			if needScience ~= nil and needScience[1] ~= nil then
				state1 = ScienceLineState.Dark
				for k,v in ipairs(needScience) do
					if DataCenter.ScienceManager:HasScienceByIdAndLevel(CommonUtil.GetScienceBaseType(v), CommonUtil.GetScienceLv(v)) then
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
end

function ScienceCell:OnBtnClick()
	EventManager:GetInstance():Broadcast(EventId.StopSvAutoToCell)
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIScienceInfo, NormalBlurPanelAnim, self.param.scienceId, self.param.bUuid)
end

function ScienceCell:IsUnLockScience()
	local template = DataCenter.ScienceManager:GetScienceTemplate(self.param.scienceId)
	if template ~= nil then
		local needScience = template.science_condition
		if needScience ~= nil then
			for k,v in ipairs(needScience) do
				if not DataCenter.ScienceManager:HasScienceByIdAndLevel(CommonUtil.GetScienceBaseType(v), CommonUtil.GetScienceLv(v)) then
					return false
				end
			end
		end
		local buildingData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.bUuid)
		if buildingData~=nil then
			local needBuild = template:GetNeedBuild()
			if needBuild ~= nil then
				for k,v in ipairs(needBuild) do
					if not DataCenter.BuildManager:HasBuildByIdAndLevel(buildingData.itemId,v.level) then
						return false
					end
				end
			end
		end
	end
	
	return true
end

function ScienceCell:GetGuideBtn() 
	return self.btn.gameObject
end

function ScienceCell:SetUpgradeEffect(go)
	go.gameObject:SetActive(true)
	go.transform:SetParent(self.transform)
	go.transform:SetAsFirstSibling()
	go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
	go.transform.localPosition = ResetPosition
end



return ScienceCell