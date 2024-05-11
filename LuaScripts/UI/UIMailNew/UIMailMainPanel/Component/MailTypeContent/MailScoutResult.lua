local MailScoutResult = BaseClass("MailScoutResult", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIHeroTipsView = require "UI.UIHeroTips.View.UIHeroTipsView"

local MailScoutResourceItem = require "UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.ScoutType.MailScoutResourceItem"
local MailScoutTroopWave = require "UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.ScoutType.MailScoutTroopWave"
local MailScoutFortItem = require "UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.ScoutType.MailScoutFortItem"
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"

local main_title_path = "UIMailItemTitle/txtMainTitle"
local sub_title_path = "UIMailItemTitle/txtSubTitle"
local scout_time_path = "UIMailItemTitle/txtTime"

local base_title_path = "Title"
local base_infoBtn_path = "Title/infobtn"
local base_Player_IconBg_path = "BaseInfo/Info/ObjBattleHead/UIPlayerHead"
local base_player_Icon_path = "BaseInfo/Info/ObjBattleHead/UIPlayerHead/HeadIcon"
local base_city_iconBg_path = "BaseInfo/Info/ObjBattleHead/CityIconBg"
local base_city_icon_path = "BaseInfo/Info/ObjBattleHead/CityIconBg/CityIcon"
local base_player_name_path = "BaseInfo/Info/ObjBattleHead/Left/txtNameLeft"
local base_player_loc_path = "BaseInfo/Info/ObjBattleHead/Left/btnPos/txtPos"
local base_player_loc_btn_path = "BaseInfo/Info/ObjBattleHead/Left/btnPos"

local base_protect_root_path = "BaseInfo/Info/Protect"
local base_protect_icon_path = "BaseInfo/Info/Protect/Icon"
local base_protect_default_icon_path = "BaseInfo/Info/Protect/defaultIcon"
local base_protect_title_path = "BaseInfo/Info/Protect/Protection"
local base_protect_desc_path = "BaseInfo/Info/Protect/ProtectionInfo"
local base_protect_hp_fore_path = "BaseInfo/Info/Protect/BloodFore"
local base_protect_hp_txt_path = "BaseInfo/Info/Protect/blood"

local resource_root_path = "BaseInfo/ResourceInfo"
local resource_empty_path = "BaseInfo/ResourceInfo/Empty"
local resource_empty_txt_path = "BaseInfo/ResourceInfo/Empty/Txt"
local resource_title_path = "BaseInfo/ResourceInfo/ResourceTitle"
local resource_plunder_txt_path = "BaseInfo/ResourceInfo/Plunder"
local resource_plunder_btn_path = "BaseInfo/ResourceInfo/PlunderBtn"
local resource_items_path = "BaseInfo/ResourceInfo/List"

local enemy_root_path = "BaseInfo/Enemy"
local enemy_title_path = "BaseInfo/Enemy/EnemyTitle"
local enemy_total_num_path = "BaseInfo/Enemy/TotalNum"
local enemy_empty_path = "BaseInfo/Enemy/EnemyEmpty"
local enemy_empty_txt_path = "BaseInfo/Enemy/EnemyEmpty/Txt1"
local enemy_waves_path = "BaseInfo/Enemy/container"

local support_root_path = "BaseInfo/Support"
local support_empty_path = "BaseInfo/Support/SupportEmpty"
local support_empty_txt_path = "BaseInfo/Support/SupportEmpty/SupportEmptyTxt"
local support_title_path = "BaseInfo/Support/SupportTitle"
local support_total_num_path = "BaseInfo/Support/TotalNum1"
local support_waves_path = "BaseInfo/Support/SupportContainer"

local fort_root_path = "BaseInfo/Fort"
local fort_title_path = "BaseInfo/Fort/FortTitle"
local fort_empty_path = "BaseInfo/Fort/FortInfo/FortEmpty"
local fort_empty_txt_path = "BaseInfo/Fort/FortInfo/FortEmpty/FortTxt"
local fort_container_path = "BaseInfo/Fort/FortInfo/FortList"


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

local function OnAddListener(self)
	base.OnAddListener(self)
	self:AddUIListener(EventId.MailScoutReposition, self.RepositionAll)
	
end

local function OnRemoveListener(self)
	base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.MailScoutReposition,self.RepositionAll)
end


--控件的定义
local function ComponentDefine(self)
	self.MainTitleN = self:AddComponent(UITextMeshProUGUIEx, main_title_path)
	self.SubTitleN = self:AddComponent(UITextMeshProUGUIEx, sub_title_path)
	self.ScoutTimeN = self:AddComponent(UITextMeshProUGUIEx, scout_time_path)
	
	self.BaseTitleN = self:AddComponent(UITextMeshProUGUIEx, base_title_path) 
	self.BaseInfoBtnN = self:AddComponent(UIButton, base_infoBtn_path)
	self.BaseInfoBtnN:SetOnClick(function()
		self:OnClickInfoBtn()
	end)
	self.BasePlayerIconBgN = self:AddComponent(UIBaseContainer, base_Player_IconBg_path)
	self.BasePlayerIconN = self:AddComponent(UIPlayerHead, base_player_Icon_path)
	self.BaseBuildIconBgN = self:AddComponent(UIBaseContainer, base_city_iconBg_path)
	self.BaseBuildIconN = self:AddComponent(UIImage, base_city_icon_path)
	
	self.BasePlayerNameN = self:AddComponent(UITextMeshProUGUIEx, base_player_name_path)
	self.BasePlayerLocN = self:AddComponent(UITextMeshProUGUIEx, base_player_loc_path)
	self.BasePlayerJumpBtnN = self:AddComponent(UIButton, base_player_loc_btn_path)
	self.BasePlayerJumpBtnN:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnJumpClick()
	end)
	self.BaseProtectRootN = self:AddComponent(UIBaseContainer, base_protect_root_path)
	self.BaseProtectIconN = self:AddComponent(UIImage, base_protect_icon_path)
	self.BaseProtectDefaultIconN = self:AddComponent(UIBaseContainer, base_protect_default_icon_path)
	self.BaseProtectTitleN = self:AddComponent(UITextMeshProUGUIEx, base_protect_title_path)
	self.BaseProtectDescN = self:AddComponent(UITextMeshProUGUIEx, base_protect_desc_path)
	self.BaseProtectHpForeN = self:AddComponent(UIImage, base_protect_hp_fore_path)
	self.BaseProtectHpTxtN = self:AddComponent(UITextMeshProUGUIEx, base_protect_hp_txt_path)
	
	self.ResourceRootN = self:AddComponent(UIBaseContainer, resource_root_path)
	self.ResourceTitleN = self:AddComponent(UITextMeshProUGUIEx, resource_title_path)
	self.ResourceEmptyN = self:AddComponent(UIBaseContainer, resource_empty_path)
	self.ResourceEmptyTxtN = self:AddComponent(UITextMeshProUGUIEx, resource_empty_txt_path)
	self.ResourceItemContainerN = self:AddComponent(UIBaseContainer, resource_items_path)
	self.ResourcePlunderTxtN = self:AddComponent(UITextMeshProUGUIEx, resource_plunder_txt_path)
	self.ResourcePlunderBtnN = self:AddComponent(UIButton, resource_plunder_btn_path)
	self.ResourcePlunderBtnN:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnPlunderClick()
	end)
	
	self.EnemyRootN = self:AddComponent(UIBaseContainer, enemy_root_path)
	self.EnemyTitleN = self:AddComponent(UITextMeshProUGUIEx, enemy_title_path)
	self.EnemyTotalNumN = self:AddComponent(UITextMeshProUGUIEx, enemy_total_num_path)
	self.EnemyEmptyN = self:AddComponent(UIBaseContainer, enemy_empty_path)
	self.EnemyEmptyTxtN = self:AddComponent(UITextMeshProUGUIEx, enemy_empty_txt_path)
	self.EnemyWavesContainerN = self:AddComponent(UIBaseContainer, enemy_waves_path)
	
	self.SupportRootN = self:AddComponent(UIBaseContainer, support_root_path)
	self.SupportTitleN = self:AddComponent(UITextMeshProUGUIEx, support_title_path)
	self.SupportTotalNumN = self:AddComponent(UITextMeshProUGUIEx, support_total_num_path)
	self.SupportEmptyN = self:AddComponent(UIBaseContainer, support_empty_path)
	self.SupportEmptyTxtN = self:AddComponent(UITextMeshProUGUIEx, support_empty_txt_path)
	self.SupportWavesContainerN = self:AddComponent(UIBaseContainer, support_waves_path)
	
	self.FortRootN = self:AddComponent(UIBaseContainer, fort_root_path)
	self.FortRootN:SetActive(false)
	self.FortTitleN = self:AddComponent(UITextMeshProUGUIEx, fort_title_path)
	self.FortEmptyN = self:AddComponent(UIBaseContainer, fort_empty_path)
	self.FortEmptyTxtN = self:AddComponent(UITextMeshProUGUIEx, fort_empty_txt_path)
	self.FortContainerN = self:AddComponent(UIBaseContainer, fort_container_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.MainTitleN = nil
	self.SubTitleN = nil
	self.ScoutTimeN = nil

	self.BaseTitleN = nil
	self.BasePlayerIconN = nil
	self.BaseBuildIconN = nil
	self.BasePlayerNameN = nil
	self.BasePlayerLocN = nil
	self.BaseProtectTitleN = nil
	self.BaseProtectDescN = nil
	self.BaseProtectHpForeN = nil
	self.BasePlayerJumpBtnN = nil

	self.ResourceRootN = nil
	self.ResourceTitleN = nil
	self.ResourceEmptyN = nil
	self.ResourceItemContainerN = nil
	self.ResourcePlunderTxtN = nil
	self.ResourcePlunderBtnN = nil
	self.ResourceItemN = nil

	self.EnemyRootN = nil
	self.EnemyTitleN = nil
	self.EnemyTotalNumN = nil
	self.EnemyEmptyN = nil
	self.EnemyWavesContainerN = nil
	self.EnemyWavesContainerN = nil
	self.EnemyWaveItemN = nil

	self.SupportRootN = nil
	self.SupportTitleN = nil
	self.SupportTotalNumN = nil
	self.SupportEmptyN = nil
	self.SupportWavesContainerN = nil
	self.SupportWavesContainerN = nil
	self.SupportWaveItemN = nil

	self.FortRootN = nil
	self.FortEmptyN = nil
	self.FortContainerN = nil
	self.FortContentN = nil
	self.FortItemN = nil
	
end

--变量的定义
local function DataDefine(self)
	self.MailBaseInfo = {}
	self.MailScoutInfo = {}
	
	self.ResourceModels ={}
	self.ResourceItemsList = {}
	
	self.EnemyWaveModels = {}
	self.EnemyWaveItemsList = {}
	
	self.FortModels ={}
	self.FortItemsList = {}
	
	self.requestCount = 0
end

--变量的销毁
local function DataDestroy(self)
	self.MailBaseInfo = nil
	self.MailScoutInfo = nil

	self.ResourceModels = nil
	self.ResourceItemsList = nil

	self.EnemyWaveModels = nil
	self.EnemyWaveItemsList = nil

	self.FortModels = nil
	self.FortItemsList = nil

	self.requestCount = nil
end

local function setData(self, tempMailInfo)
	self.MailBaseInfo = tempMailInfo
	self.MailScoutInfo = tempMailInfo:GetMailExt():GetExtData()
	
	self.requestCount = 0

	self.BaseProtectRootN:SetActive(false)
	self.ResourceRootN:SetActive(false)
	self.EnemyRootN:SetActive(false)
	self.SupportRootN:SetActive(false)
	--self.FortRootN:SetActive(false)
	
	self:RefreshBaseInfo()
	self:RefreshResourceInfo()
	self:RefreshEnemyInfo()
	self:RefreshSupportInfo()
	--self:RefreshFortInfo()

	self:CheckRequestsComplete()
end

local function RefreshBaseInfo(self)
	self.MainTitleN:SetText(MailShowHelper.GetMainTitle(self.MailBaseInfo))-- Localization:GetString("300617"))
	self.SubTitleN:SetText(MailShowHelper.GetMailSubTitle(self.MailBaseInfo))--Localization:GetString("300618", targetPlayerInfo.abbr, targetPlayerInfo.name))
	self.ScoutTimeN:SetText(MailShowHelper.GetRelativeCreateTime(self.MailBaseInfo))
	
	self.BaseTitleN:SetText(self.MailBaseInfo:GetMailMessage())--Localization:GetString("300619", targetPlayerInfo.abbr, targetPlayerInfo.name, "???"))
	
	if self.MailScoutInfo.targetType == "ALLIANCE_CITY" then
		local targetInfo = self.MailScoutInfo.targetAllianceCity
		local cityId = targetInfo.city_id.value
		local name = targetInfo.cityName
		if name==nil or name=="" then
			name = GetTableData(TableName.WorldCity, cityId, 'name')
			name = Localization:GetString(name)
		end
		self.BaseBuildIconBgN:SetActive(true)
		self.BasePlayerIconBgN:SetActive(false)
		local buildIcon = GetTableData(TableName.WorldCity, cityId, 'monster_icon')
		self.BaseBuildIconN:LoadSprite("Assets/Main/Sprites/HeroIconsSmall/" .. buildIcon)
		if targetInfo.abbr~=nil  and targetInfo.abbr~= "" then
			self.BasePlayerNameN:SetText('['.. targetInfo.abbr .. ']' .. name)
		else
			self.BasePlayerNameN:SetText(name) 
		end
		local strPos = Localization:GetString("310137", targetInfo.point.x.value, targetInfo.point.y.value)
		self.BasePlayerLocN:SetText(strPos)
		if self.MailScoutInfo.allianceCityWall and (cityId~=THRONE_ID or LuaEntry.Player.serverType ~= ServerType.NORMAL) then
			if self.MailScoutInfo.allianceCityWall.visible.value == ScoutReportVisibleState.NOT_MATCH then
				self.baseProtectRootActive = false
				return
			elseif self.MailScoutInfo.allianceCityWall.visible.value == ScoutReportVisibleState.DISABLE then
				self.baseProtectRootActive = false
				return
			elseif self.MailScoutInfo.allianceCityWall.visible.value == ScoutReportVisibleState.ENABLE then
				self.baseProtectRootActive = true
			end
		else
			self.baseProtectRootActive = false
			return
		end
		self.BaseProtectDefaultIconN:SetActive(true)
		self.BaseProtectIconN:SetActive(false)
		self.BaseProtectTitleN:SetLocalText(104189) 
		self.BaseProtectHpForeN:SetFillAmount(self.MailScoutInfo.allianceCityWall.hp.value / self.MailScoutInfo.allianceCityWall.hpMax.value)
		self.BaseProtectHpTxtN:SetText(string.GetFormattedStr(self.MailScoutInfo.allianceCityWall.hp.value) ..  '/' .. string.GetFormattedStr(self.MailScoutInfo.allianceCityWall.hpMax.value))
		self.BaseProtectDescN:SetActive(false)--不显示状态了
	elseif self.MailScoutInfo.targetType == "DESERT" then
		local desertInfo = self.MailScoutInfo.targetDesert
		local targetPlayerInfo = self.MailScoutInfo.targetUser
		local des_id = desertInfo.des_id.value

		local nameId = GetTableData(TableName.Desert, des_id, "desert_name")
		local desertName = Localization:GetString(nameId)
		local level = GetTableData(TableName.Desert, des_id, "desert_level")
		if level and level>0 then
			desertName = "Lv."..level..desertName
		else
			desertName = Localization:GetString("110245")
		end
		if not string.IsNullOrEmpty(targetPlayerInfo.uid) then
			desertName = "[" .. targetPlayerInfo.abbr .. "]" .. targetPlayerInfo.name .. "(" .. desertName .. ")"
		end
		self.BasePlayerNameN:SetText(desertName)
		self.BaseBuildIconBgN:SetActive(true)
		self.BasePlayerIconBgN:SetActive(false)
		self.BaseBuildIconN:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_blank_tips.png")
		local strPos = Localization:GetString("310137", desertInfo.point.x.value, desertInfo.point.y.value)
		self.BasePlayerLocN:SetText(strPos)
	elseif self.MailScoutInfo.targetType == "ALLIANCE_BULID" then
		local targetInfo = self.MailScoutInfo.targetAllianceBuild
		local buildId = targetInfo.buildId.value
		local name = ""
		local icon = ""
		local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
		if template~=nil then
			name = Localization:GetString(template.name)
			icon = template:GetCircleIconPath()
		end
		self.BaseBuildIconBgN:SetActive(true)
		self.BasePlayerIconBgN:SetActive(false)
		--local buildIcon = GetTableData(TableName.WorldCity, cityId, 'monster_icon')
		self.BaseBuildIconN:LoadSprite(icon)
		if targetInfo.abbr~=nil  and targetInfo.abbr~= "" then
			self.BasePlayerNameN:SetText('['.. targetInfo.abbr .. ']' .. name)
		else
			self.BasePlayerNameN:SetText(name)
		end
		local strPos = Localization:GetString("310137", targetInfo.point.x.value, targetInfo.point.y.value)
		self.BasePlayerLocN:SetText(strPos)
		if self.MailScoutInfo.allianceBuildWall then
			if self.MailScoutInfo.allianceBuildWall.visible.value == ScoutReportVisibleState.NOT_MATCH then
				self.baseProtectRootActive = false
				return
			elseif self.MailScoutInfo.allianceBuildWall.visible.value == ScoutReportVisibleState.DISABLE then
				self.baseProtectRootActive = false
				return
			elseif self.MailScoutInfo.allianceBuildWall.visible.value == ScoutReportVisibleState.ENABLE then
				self.baseProtectRootActive = true
			end
		else
			self.baseProtectRootActive = false
			return
		end
		self.BaseProtectDefaultIconN:SetActive(true)
		self.BaseProtectIconN:SetActive(false)
		self.BaseProtectTitleN:SetLocalText(104189)
		self.BaseProtectHpForeN:SetFillAmount(self.MailScoutInfo.allianceBuildWall.hp.value / self.MailScoutInfo.allianceBuildWall.hpMax.value)
		self.BaseProtectHpTxtN:SetText(string.GetFormattedStr(self.MailScoutInfo.allianceBuildWall.hp.value) ..  '/' .. string.GetFormattedStr(self.MailScoutInfo.allianceBuildWall.hpMax.value))
		self.BaseProtectDescN:SetActive(false)--不显示状态了
	elseif self.MailScoutInfo.targetType == "DRAGON_BUILDING" then
		local targetInfo = self.MailScoutInfo.targetDragonBuilding
		local buildId = targetInfo.buildId.value
		local name = ""
		local icon = ""
		local template = DataCenter.DragonBuildTemplateManager:GetTemplate(buildId)
		if template~=nil then
			name = Localization:GetString(template.name)
			icon = template:GetCircleIconPath()
		end
		self.BaseBuildIconBgN:SetActive(true)
		self.BasePlayerIconBgN:SetActive(false)
		--local buildIcon = GetTableData(TableName.WorldCity, cityId, 'monster_icon')
		self.BaseBuildIconN:LoadSprite(icon)
		if targetInfo.abbr~=nil  and targetInfo.abbr~= "" then
			self.BasePlayerNameN:SetText('['.. targetInfo.abbr .. ']' .. name)
		else
			self.BasePlayerNameN:SetText(name)
		end
		local strPos = Localization:GetString("310137", targetInfo.point.x.value, targetInfo.point.y.value)
		self.BasePlayerLocN:SetText(strPos)
		if self.MailScoutInfo.allianceBuildWall then
			if self.MailScoutInfo.allianceBuildWall.visible.value == ScoutReportVisibleState.NOT_MATCH then
				self.baseProtectRootActive = false
				return
			elseif self.MailScoutInfo.allianceBuildWall.visible.value == ScoutReportVisibleState.DISABLE then
				self.baseProtectRootActive = false
				return
			elseif self.MailScoutInfo.allianceBuildWall.visible.value == ScoutReportVisibleState.ENABLE then
				self.baseProtectRootActive = true
			end
		else
			self.baseProtectRootActive = false
			return
		end
		self.BaseProtectDefaultIconN:SetActive(true)
		self.BaseProtectIconN:SetActive(false)
		self.BaseProtectTitleN:SetLocalText(104189)
		self.BaseProtectHpForeN:SetFillAmount(self.MailScoutInfo.allianceBuildWall.hp.value / self.MailScoutInfo.allianceBuildWall.hpMax.value)
		self.BaseProtectHpTxtN:SetText(string.GetFormattedStr(self.MailScoutInfo.allianceBuildWall.hp.value) ..  '/' .. string.GetFormattedStr(self.MailScoutInfo.allianceBuildWall.hpMax.value))
		self.BaseProtectDescN:SetActive(false)--不显示状态了
	else
		local posX, posY = 0, 0
		local careerType, careerLv = 0, 0
		if self.MailScoutInfo.targetUser then
			local targetPlayerInfo = self.MailScoutInfo.targetUser
			self.BasePlayerIconN:SetData(targetPlayerInfo.uid, targetPlayerInfo.pic, targetPlayerInfo.picVer.value)
			if targetPlayerInfo.abbr and targetPlayerInfo.abbr ~= "" then
				self.BasePlayerNameN:SetText('['.. targetPlayerInfo.abbr .. ']' .. targetPlayerInfo.name)
			else
				self.BasePlayerNameN:SetText(targetPlayerInfo.name)
			end
			posX = self.MailScoutInfo.targetUser.point.x.value
			posY = self.MailScoutInfo.targetUser.point.y.value
			careerType = targetPlayerInfo.careerType
			careerLv = targetPlayerInfo.careerLv
		end

		self.BaseBuildIconBgN:SetActive(false)
		self.BasePlayerIconBgN:SetActive(true)
		local strPos = Localization:GetString("310137", posX, posY)
		self.BasePlayerLocN:SetText(strPos)
		if self.MailScoutInfo.userWall then
			if self.MailScoutInfo.userWall.visible.value == ScoutReportVisibleState.NOT_MATCH then
				self.baseProtectRootActive = false
				return
			elseif self.MailScoutInfo.userWall.visible.value == ScoutReportVisibleState.DISABLE then
				self.baseProtectRootActive = false
				return
			elseif self.MailScoutInfo.userWall.visible.value == ScoutReportVisibleState.ENABLE then
				self.baseProtectRootActive = true
			end
		else
			self.baseProtectRootActive = false
			return
		end
		local targetBuildId = self.MailScoutInfo.userWall.buildingId
		if targetBuildId and targetBuildId ~= "" then
			self.BaseProtectDefaultIconN:SetActive(false)
			self.BaseProtectIconN:SetActive(true)
			self.BaseProtectIconN:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(targetBuildId,1))
			local buildID = tonumber(self.MailScoutInfo.userWall.buildingId)
			self.BaseProtectTitleN:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildID,"name")) 
		else
			self.BaseProtectDefaultIconN:SetActive(true)
			self.BaseProtectIconN:SetActive(false)
			self.BaseProtectTitleN:SetLocalText(140307) 
			--self.BaseProtectIconN:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(buildID,1))
		end
		self.BaseProtectHpForeN:SetFillAmount(self.MailScoutInfo.userWall.hp.value / self.MailScoutInfo.userWall.hpMax.value)
		self.BaseProtectHpTxtN:SetText(string.GetFormattedStr(self.MailScoutInfo.userWall.hp.value) ..  '/' .. string.GetFormattedStr(self.MailScoutInfo.userWall.hpMax.value))
		self.BaseProtectDescN:SetActive(false)--不显示状态了
	end
	
	
	--if self.MailScoutInfo.userWall.hp.value < self.MailScoutInfo.userWall.hpMax.value then
	--	self.BaseProtectDescN:SetLocalText(GameDialogDefine.DOME_DURABILITY_DESTROY) 
	--else
	--	self.BaseProtectDescN:SetLocalText(GameDialogDefine.DOME_DURABILITY_FULL) 
	--end
end

local function RefreshResourceInfo(self)
	self.ResourceTitleN:SetLocalText(300622) 
	
	if not self.MailScoutInfo.resource or self.MailScoutInfo.targetType == "ALLIANCE_CITY" then
		self.resourceRootActive = false
		return
	elseif self.MailScoutInfo.resource.visible.value == ScoutReportVisibleState.NOT_MATCH 
		or self.MailScoutInfo.resource.visible.value == ScoutReportVisibleState.DISABLE then
		self.resourceRootActive = true
		self.ResourceEmptyN:SetActive(true)
		self.ResourceItemContainerN:SetActive(false)
		self.ResourceEmptyTxtN:SetLocalText(300790)
		return
	elseif self.MailScoutInfo.resource.visible.value == ScoutReportVisibleState.ENABLE then
		self.resourceRootActive = true
		self.ResourceEmptyN:SetActive(false)
		self.ResourceItemContainerN:SetActive(true)
	end

	local plunderResRate = self.MailScoutInfo.resource.plunderResRate and self.MailScoutInfo.resource.plunderResRate.value
	if plunderResRate == nil then
		self.ResourcePlunderBtnN:SetActive(false)
		self.ResourcePlunderTxtN:SetActive(false)
	else
		self.ResourcePlunderBtnN:SetActive(true)
		self.ResourcePlunderTxtN:SetActive(true)
		self.ResourcePlunderTxtN:SetLocalText(300132, plunderResRate)
	end
	
	local list = {}
	local dataList = self.MailScoutInfo.resource.data
	if dataList then
		for _, data in ipairs(dataList) do
			table.insert(list, data)
		end
	end
	
	local resourceItemCount = self.MailScoutInfo.resource.resourceItemCount and self.MailScoutInfo.resource.resourceItemCount.value
	if resourceItemCount then
		local data = {}
		data.type = ResourceType.FarmBox
		data.value = resourceItemCount
		table.insert(list, data)
	end

	if not list or table.length(list) == 0 then
		self.ResourceEmptyN:SetActive(true)
		self.ResourceEmptyTxtN:SetLocalText(300683) 
		self.ResourceItemContainerN:SetActive(false)
		return
	end

	self:SetAllResourceItemDestroy()
	self.resourceModelCount =0
	if list~=nil and #list>0 then
		self.requestCount = self.requestCount + #list
		for i = 1, table.length(list) do
			--复制基础prefab，每次循环创建一次
			self.resourceModelCount= self.resourceModelCount+1
			self.ResourceModels[self.resourceModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
				self.requestCount = self.requestCount - 1
				if request.isError then
					return
				end
				local go = request.gameObject;
				go.gameObject:SetActive(true)
				go.transform:SetParent(self.ResourceItemContainerN.transform)
				if self.resourceModelCount == #list then
					self:CheckRequestsComplete()
				end
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				local nameStr = tostring(NameCount)
				go.name = nameStr
				NameCount = NameCount + 1
				local cell = self.ResourceItemContainerN:AddComponent(MailScoutResourceItem,nameStr)
				cell:RefreshData(list[i])
				table.insert(self.ResourceItemsList,cell)
			end)
		end
	end
end

local function SetAllResourceItemDestroy(self)
	self.ResourceItemContainerN:RemoveComponents(MailScoutResourceItem)
	if self.ResourceModels~=nil then
		for k,v in pairs(self.ResourceModels) do
			if v ~= nil then
				self:GameObjectDestroy(v)
			end
		end
	end
	self.ResourceModels ={}
	self.ResourceItemsList = {}
end


local function RefreshEnemyInfo(self)
	self.enemyRootActive = false
	self.EnemyTotalNumN:SetActive(false)
	self.EnemyEmptyN:SetActive(false)
	self.EnemyWavesContainerN:SetActive(false)
	
	self.EnemyTitleN:SetLocalText(130068)
	local cityId = 0
	if self.MailScoutInfo.targetType == "ALLIANCE_CITY" then
		local targetInfo = self.MailScoutInfo.targetAllianceCity
		cityId = targetInfo.city_id.value
		if cityId == THRONE_ID then
			return
		end
	end
	
	if  self.MailScoutInfo.army.targetTotal and self.MailScoutInfo.army.targetTotal.visible.value == ScoutReportVisibleState.ENABLE then
		self.EnemyTotalNumN:SetLocalText(300625,  string.GetFormattedStr(self.MailScoutInfo.army.targetTotal.total.value)) 
		self.enemyRootActive = true
		self.EnemyTotalNumN:SetActive(true)
	else
		self.EnemyTotalNumN:SetText("")
	end

	local target = self.MailScoutInfo.army.target
	if not target or target.visible.value == ScoutReportVisibleState.NOT_MATCH then
		return
	elseif target.visible.value == ScoutReportVisibleState.DISABLE then
		self.enemyRootActive = true
		self.EnemyEmptyN:SetActive(true)
		self.EnemyEmptyTxtN:SetLocalText(300680) 
		return
	elseif target.visible.value == ScoutReportVisibleState.ENABLE then
		self.enemyRootActive = true
		self.EnemyWavesContainerN:SetActive(true)
	end

	local tempList = target.formation
	local list = {}
	if tempList~=nil then
		for i= 1,#tempList do
			local formation = tempList[i]
			if formation~=nil and formation.soldierTotal~=nil and formation.soldierTotal.value>0 then
				table.insert(list,formation)
			end
		end
	end

	if not list or table.length(list) == 0 then
		self.EnemyEmptyN:SetActive(true)
		self.EnemyEmptyTxtN:SetLocalText(300630) 
		self.EnemyWavesContainerN:SetActive(false)
		return
	end
	
	self:SetAllEnemyTroopDestroy()
	self.enemyWaveModelCount =0
	if list~=nil and #list>0 then
		self.requestCount = self.requestCount + #list
		for i = 1, table.length(list) do
			--复制基础prefab，每次循环创建一次
			self.enemyWaveModelCount= self.enemyWaveModelCount+1
			self.EnemyWaveModels[self.enemyWaveModelCount] = self:GameObjectInstantiateAsync(UIAssets.MailScoutTroopWave, function(request)
				self.requestCount = self.requestCount - 1
				if request.isError then
					return
				end
				local go = request.gameObject;
				go.gameObject:SetActive(true)
				go.transform:SetParent(self.EnemyWavesContainerN.transform)
				if self.enemyWaveModelCount == #list then
					self:CheckRequestsComplete()
				end
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				local nameStr = tostring(NameCount)
				go.name = nameStr
				NameCount = NameCount + 1
				local cell = self.EnemyWavesContainerN:AddComponent(MailScoutTroopWave,nameStr)
				cell:RefreshData(list[i], nil, i, self.MailScoutInfo.targetType)
				table.insert(self.EnemyWaveItemsList,cell)
			end)
		end
	end
end

local function SetAllEnemyTroopDestroy(self)
	self.EnemyWavesContainerN:RemoveComponents(MailScoutTroopWave)
	if self.EnemyWaveModels~=nil then
		for k,v in pairs(self.EnemyWaveModels) do
			if v ~= nil then
				self:GameObjectDestroy(v)
			end
		end
	end
	self.EnemyWaveModels ={}
	self.EnemyWaveItemsList = {}
end

local function RefreshSupportInfo(self)
	local supports = self.MailScoutInfo.army.help

	self.SupportTitleN:SetLocalText(300634) 
	self.SupportTotalNumN:SetText("")

	if not supports or supports.visible.value == ScoutReportVisibleState.NOT_MATCH then
		self.supportRootActive = false
		return
	elseif supports.visible.value == ScoutReportVisibleState.DISABLE then
		self.supportRootActive = true
		self.SupportEmptyN:SetActive(true)
		self.SupportWavesContainerN:SetActive(false)
		self.SupportEmptyTxtN:SetLocalText(300681) 
		return
	elseif supports.visible.value == ScoutReportVisibleState.ENABLE then
		self.supportRootActive = true
		self.SupportEmptyN:SetActive(false)
		if self.MailScoutInfo.targetType == "ALLIANCE_CITY" then
			local targetInfo = self.MailScoutInfo.targetAllianceCity
			local cityId = targetInfo.city_id.value
			if cityId == THRONE_ID then
				self.SupportTitleN:SetLocalText(250159)
			end
		end
		self.SupportWavesContainerN:SetActive(true)
	end


	local list = supports.formation
	if not list or table.length(list) == 0 then
		self.SupportEmptyN:SetActive(true)
		self.SupportEmptyTxtN:SetLocalText(300632) 
		self.SupportWavesContainerN:SetActive(false)
		return
	else
		self.SupportEmptyN:SetActive(false)
		self.SupportWavesContainerN:SetActive(true)
	end

	self:SetAllSupportTroopDestroy()
	self.supportsModelCount =0
	if list~=nil and #list>0 then
		self.requestCount = self.requestCount + #list
		for i = 1, table.length(list) do
			--复制基础prefab，每次循环创建一次
			self.supportsModelCount= self.supportsModelCount+1
			self.SupportWaveModels[self.supportsModelCount] = self:GameObjectInstantiateAsync(UIAssets.MailScoutTroopWave, function(request)
				self.requestCount = self.requestCount - 1
				if request.isError then
					return
				end
				local go = request.gameObject;
				go.gameObject:SetActive(true)
				go.transform:SetParent(self.SupportWavesContainerN.transform)
				if self.supportsModelCount == #list then
					self:CheckRequestsComplete()
				end
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				local nameStr = tostring(NameCount)
				go.name = nameStr
				NameCount = NameCount + 1
				local cell = self.SupportWavesContainerN:AddComponent(MailScoutTroopWave,nameStr)
				cell:RefreshData(list[i].formation, list[i].user, nil)
				table.insert(self.SupportWaveItemsList,cell)
			end)
		end
	end
end

local function SetAllSupportTroopDestroy(self)
	self.SupportWavesContainerN:RemoveComponents(MailScoutTroopWave)
	if self.SupportWaveModels~=nil then
		for k,v in pairs(self.SupportWaveModels) do
			if v ~= nil then
				self:GameObjectDestroy(v)
			end
		end
	end
	self.SupportWaveModels ={}
	self.SupportWaveItemsList = {}
end

local function RefreshFortInfo(self)
	local towerInfo = self.MailScoutInfo.tower
	
	self.FortTitleN:SetLocalText(300626) 
	
	if not towerInfo or towerInfo.visible.value == ScoutReportVisibleState.NOT_MATCH then
		self.fortRootActive = false
		return
	elseif towerInfo.visible.value == ScoutReportVisibleState.DISABLE then
		self.fortRootActive = true
		self.FortEmptyN:SetActive(true)
		self.FortContainerN:SetActive(false)
		self.FortEmptyTxtN:SetLocalText(300682) 
		return
	elseif towerInfo.visible.value == ScoutReportVisibleState.ENABLE then
		self.fortRootActive = true
		self.FortEmptyN:SetActive(false)
		self.FortContainerN:SetActive(true)
	end

	local towerList = towerInfo.tower
	if towerList and table.length(towerList) > 0 then
		self.FortEmptyN:SetActive(false)
		self.FortContainerN:SetActive(true)
	else
		self.FortEmptyN:SetActive(true)
		self.FortEmptyTxtN:SetLocalText(300633) 
		self.FortContainerN:SetActive(false)
		return
	end

	local list = towerList
	self:SetAllFortItemDestroy()
	self.fortModelCount =0
	if list~=nil and #list>0 then
		self.requestCount = self.requestCount + #list
		for i = 1, table.length(list) do
			--复制基础prefab，每次循环创建一次
			self.fortModelCount= self.fortModelCount+1
			self.FortModels[self.fortModelCount] = self:GameObjectInstantiateAsync(UIAssets.MailScoutFortItem, function(request)
				self.requestCount = self.requestCount - 1
				if request.isError then
					return
				end
				local go = request.gameObject;
				go.gameObject:SetActive(true)
				go.transform:SetParent(self.FortContainerN.transform)
				if self.fortModelCount == #list then
					self:CheckRequestsComplete()
				end
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				local nameStr = tostring(NameCount)
				go.name = nameStr
				NameCount = NameCount + 1
				local cell = self.FortContainerN:AddComponent(MailScoutFortItem,nameStr)
				cell:RefreshData(list[i])
				table.insert(self.FortItemsList,cell)
			end)
		end
	end
end

local function SetAllFortItemDestroy(self)
	self.FortContainerN:RemoveComponents(MailScoutFortItem)
	if self.FortModels~=nil then
		for k,v in pairs(self.FortModels) do
			if v ~= nil then
				self:GameObjectDestroy(v)
			end
		end
	end
	self.FortModels ={}
	self.FortItemsList = {}
end

local function RepositionAll(self)
	CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.transform)
end

local function OnJumpClick(self)
	local pos = nil
	if self.MailScoutInfo.targetType == "ALLIANCE_CITY" then
		pos = self.MailScoutInfo.targetAllianceCity.point
	elseif self.MailScoutInfo.targetType == "DESERT" then
		pos = self.MailScoutInfo.targetDesert.point
	elseif self.MailScoutInfo.targetType == "ALLIANCE_BULID" then
		pos = self.MailScoutInfo.targetAllianceBuild.point
	elseif self.MailScoutInfo.targetType == ScoutMailTargetType.DRAGON_BUILDING then
		pos = self.MailScoutInfo.targetDragonBuilding.point
	else
		if self.MailScoutInfo.targetUser then
			pos = self.MailScoutInfo.targetUser.point
		end
	end
	if pos == nil then
		return
	end
	local v2 = CS.UnityEngine.Vector2Int(pos.x.value,pos.y.value)
	local posIndex = SceneUtils.TilePosToIndex(v2, ForceChangeScene.World)
	local serverId = pos.server.value or LuaEntry.Player:GetCurServerId()
	local worldId = 0
	if pos.worldId~=nil then
		worldId = pos.worldId.value or 0
	end
 	--local v3Pos = Vector3.New(pos.x.value, 0, pos.y.value)
	--local posIndex = SceneUtils.WorldToTileIndex(v3Pos)
	--local retPos = SceneUtils.TileIndexToWorld(posIndex)
	self.view.ctrl:OnClickPosBtn(posIndex,serverId,worldId)
end

local function OnPlunderClick(self)
	local param = UIHeroTipView.Param.New()
	param.content = Localization:GetString("300144")
	param.dir = UIHeroTipView.Direction.LEFT
	param.defWidth = 550
	param.pivot = 0.5
	param.position = self.ResourcePlunderBtnN.transform.position + Vector3.New(-35, 0, 0)
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function CheckRequestsComplete(self)
	if self.requestCount == 0 then
		--self:RepositionAll()
		self.BaseProtectRootN:SetActive(self.baseProtectRootActive)
		self.ResourceRootN:SetActive(self.resourceRootActive)
		self.EnemyRootN:SetActive(self.enemyRootActive)
		self.SupportRootN:SetActive(self.supportRootActive)
		--self.FortRootN:SetActive(self.fortRootActive)
	end
end

local function OnClickInfoBtn(self)
	local scaleFactor = UIManager:GetInstance():GetScaleFactor()
	local position = self.BaseInfoBtnN.transform.position + Vector3.New(-10, 0, 0) * scaleFactor

	local param = UIHeroTipsView.Param.New()
	param.content = Localization:GetString(300016)
	param.dir = UIHeroTipsView.Direction.LEFT
	param.defWidth = 400
	param.pivot = 0.5
	param.position = position
	param.bindObject = self.BaseInfoBtnN.gameObject
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTips, { anim = false }, param)
end

MailScoutResult.OnCreate = OnCreate
MailScoutResult.OnDestroy = OnDestroy
MailScoutResult.OnEnable = OnEnable
MailScoutResult.OnDisable = OnDisable
MailScoutResult.ComponentDefine = ComponentDefine
MailScoutResult.ComponentDestroy = ComponentDestroy
MailScoutResult.DataDefine = DataDefine
MailScoutResult.DataDestroy = DataDestroy

MailScoutResult.setData = setData
MailScoutResult.RefreshBaseInfo = RefreshBaseInfo
MailScoutResult.RefreshResourceInfo = RefreshResourceInfo
MailScoutResult.RefreshEnemyInfo = RefreshEnemyInfo

MailScoutResult.RefreshSupportInfo = RefreshSupportInfo
MailScoutResult.RefreshFortInfo = RefreshFortInfo
MailScoutResult.SetAllResourceItemDestroy = SetAllResourceItemDestroy
MailScoutResult.SetAllEnemyTroopDestroy = SetAllEnemyTroopDestroy
MailScoutResult.SetAllSupportTroopDestroy = SetAllSupportTroopDestroy
MailScoutResult.SetAllFortItemDestroy = SetAllFortItemDestroy
MailScoutResult.RepositionAll = RepositionAll
MailScoutResult.OnAddListener = OnAddListener
MailScoutResult.OnRemoveListener = OnRemoveListener
MailScoutResult.OnJumpClick = OnJumpClick
MailScoutResult.OnPlunderClick = OnPlunderClick
MailScoutResult.CheckRequestsComplete = CheckRequestsComplete
MailScoutResult.OnClickInfoBtn = OnClickInfoBtn
			   
return MailScoutResult