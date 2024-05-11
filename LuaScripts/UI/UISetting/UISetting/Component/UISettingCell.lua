local UISettingCell = BaseClass("UISettingCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Resource = CS.GameEntry.Resource

local Param = DataClass("Param", ParamData)
local ParamData =  {
	settingType,
}

local this_path = ""
local btn_name_path = "BtnName"
local red_dot_path = "RedDot"
local foreIcon_path = "icon"

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
	self.btn_name = self:AddComponent(UITextMeshProUGUIEx, btn_name_path)
	self.btn = self:AddComponent(UIButton, this_path)
	self.icon = self:AddComponent(UIImage, this_path)
	self.red_dot = self:AddComponent(UIBaseComponent, red_dot_path)
	self.red_dot:SetActive(false)
	self.btn:SetOnClick(function()
		self:OnBtnClick()
	end)
	self.foreIconN = self:AddComponent(UIImage, foreIcon_path)
end

--控件的销毁
local function ComponentDestroy(self)
	self.btn_name = nil
	self.btn = nil
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
	self:SetIcon()
	self:SetName()
end


local function OnBtnClick(self)
	if self.param.settingType == SettingType.Notice then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingNotice, { anim = true })
	elseif self.param.settingType == SettingType.Setting then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingSet, { anim = true, isBlur = true })
	elseif self.param.settingType == SettingType.Account then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingAccount, { anim = true,isBlur = true })
	elseif self.param.settingType == SettingType.Description then
		--CS.UnityGameFramework.SDK.AIHelpManager.Instance:showHelpShiftFAQ()
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UISetting,{ anim = true ,isBlur = true})
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerInfo)
		if CS.SceneManager:IsInCity() then

		end
	elseif self.param.settingType == SettingType.Language then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingLanguage, { anim = true,isBlur = true })
	elseif self.param.settingType == SettingType.RedemptionCode then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingRedemptionCode, { anim = true })
	elseif self.param.settingType == SettingType.Ban then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingBlock,{anim = true,isBlur = true})
	elseif self.param.settingType == SettingType.Flag then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingFlag,{anim = true})
	elseif self.param.settingType == SettingType.GM then
		--CS.GameEntry.UI:OpenUIForm(CS.GameDefines.UIAssets.UISetGM, CS.GameDefines.UILayer.Normal, "GM");
	elseif self.param.settingType == SettingType.Service then
		CS.UnityGameFramework.SDK.HelpManager.Instance:showFAQ("45238")
	elseif self.param.settingType == SettingType.NewGame then
		DataCenter.AccountManager:OnHandleNewGame()
		--elseif self.param.settingType == SettingType.Vip then
		--	UIManager:GetInstance():OpenWindow(UIWindowNames.UIVip,{ anim = true, hideTop = true })
	elseif self.param.settingType == SettingType.ChangeId then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISettingChangeUid,{ anim = true })
	elseif self.param.settingType == SettingType.PVE then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIPVEEnterLevel)
	elseif self.param.settingType == SettingType.PVEFreeCamera then
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UISetting,{ anim = true ,isBlur = true})
		UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlayerInfo)
		DataCenter.BattleLevel:ToggleCameraFree()
	elseif self.param.settingType == SettingType.PlayerNation then
		local tempNation = LuaEntry.Player.countryFlag
		UIManager:GetInstance():OpenWindow(UIWindowNames.UISetPlayerNation,  { anim = true, isBlur = true}, {nation = tempNation, callback = function(tempSelected)
			SFSNetwork.SendMessage(MsgDefines.SetCountryFlag, tempSelected)
			ChatManager2:GetInstance().Net:SendSFSMessage(ChatMsgDefines.GetUserInfoMulti, {LuaEntry.Player.uid})
		end})
	elseif self.param.settingType == SettingType.AllowTracking then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIGotoAllowTracking)
		--elseif self.param.settingType == SettingType.Roles then
		--UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoles,{ anim = true, hideTop = true },0)
	elseif self.param.settingType == SettingType.ChangeScene then
		self:ChangeScene()
	elseif self.param.settingType == SettingType.GameNotice then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIMainNotice,{ anim = true})
	elseif self.param.settingType == SettingType.DeleteAccount then
		UIUtil.ShowMessage(Localization:GetString("208272"), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIAccountDeleteVerify)
		end)
	end
end

local function SetIcon(self)
	self.foreIconN:SetActive(false)
	if self.param.settingType == SettingType.Notice then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_alliow.png")
	elseif self.param.settingType == SettingType.Setting then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_setting.png")
	elseif self.param.settingType == SettingType.Account then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_Account.png")
	elseif self.param.settingType == SettingType.Description then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_Q&A.png")
	elseif self.param.settingType == SettingType.Language then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_language.png")
	elseif self.param.settingType == SettingType.RedemptionCode then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_GiftExchange.png")
	elseif self.param.settingType == SettingType.Ban then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_shield.png")
	elseif self.param.settingType == SettingType.Flag then
		self.icon:LoadSprite("Assets/Main/Sprites/CountryFlag/" .. LuaEntry.Player.countryFlag .. ".png")
	elseif self.param.settingType == SettingType.GM then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_Lilith.png")
	elseif self.param.settingType == SettingType.Service then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/img_iconSettingFunction_Discord.png")
	elseif self.param.settingType == SettingType.NewGame then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
		--elseif self.param.settingType == SettingType.Vip then
		--	self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/UISet_btn2_setting.png")
	elseif self.param.settingType == SettingType.ChangeId then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
	elseif self.param.settingType == SettingType.PVE then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
	elseif self.param.settingType == SettingType.PVEFreeCamera then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
	elseif self.param.settingType == SettingType.AllowTracking then
		if CS.SDKManager.IS_IPhonePlayer() and
				not CS.GameEntry.Setting:GetBool(SettingKeys.ALLOW_TRACKING_CLICK, false) then
			self.red_dot:SetActive(true)
		end
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_IDFA.png")
	elseif self.param.settingType == SettingType.PlayerNation then
		self.foreIconN:SetActive(true)
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UIset_img_iconbg.png")
		local nationTemplate = DataCenter.NationTemplateManager:GetNationTemplate(LuaEntry.Player.countryFlag)
		local flagPath = nationTemplate:GetNationFlagPath()
		self.foreIconN:LoadSprite(flagPath)
	elseif	self.param.settingType == SettingType.ChangeScene then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
		--elseif self.param.settingType == SettingType.Roles then
		--self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_manager.png")
	elseif self.param.settingType == SettingType.GameNotice then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_gonggao.png")
	elseif self.param.settingType == SettingType.DeleteAccount then
		self.icon:LoadSprite("Assets/Main/Sprites/UI/UISet/New/UISet_btn2_newgame.png")
	end
end

local function SetName(self)
	if self.param.settingType == SettingType.Notice then
		self.btn_name:SetLocalText(100646)
	elseif self.param.settingType == SettingType.Setting then
		self.btn_name:SetLocalText(280170)
	elseif self.param.settingType == SettingType.Account then
		self.btn_name:SetLocalText(280039)
	elseif self.param.settingType == SettingType.Description then
		self.btn_name:SetLocalText(100171)
	elseif self.param.settingType == SettingType.Language then
		self.btn_name:SetLocalText(100101)
	elseif self.param.settingType == SettingType.RedemptionCode then
		self.btn_name:SetLocalText(110004)
	elseif self.param.settingType == SettingType.Ban then
		self.btn_name:SetLocalText(280013)
	elseif self.param.settingType == SettingType.Flag then
		self.btn_name:SetLocalText(390065)
	elseif self.param.settingType == SettingType.GM then
		self.btn_name:SetText("GM")
	elseif self.param.settingType == SettingType.Service then
		self.btn_name:SetLocalText(100331)
	elseif self.param.settingType == SettingType.NewGame then
		self.btn_name:SetLocalText(280045)
		--elseif self.param.settingType == SettingType.Vip then
		--	self.btn_name:SetText("Vip")
	elseif self.param.settingType == SettingType.ChangeId then
		self.btn_name:SetText("changeId")
	elseif self.param.settingType == SettingType.PVE then
		self.btn_name:SetText("PVE")
	elseif self.param.settingType == SettingType.PVEFreeCamera then
		self.btn_name:SetText("PVE FreeCamera")
	elseif self.param.settingType == SettingType.AllowTracking then
		self.btn_name:SetLocalText(208222)
	elseif self.param.settingType == SettingType.PlayerNation then
		self.btn_name:SetLocalText("143589")
	elseif self.param.settingType == SettingType.ChangeScene then
		self.btn_name:SetText("ChangeScene")
		--elseif self.param.settingType == SettingType.Roles then
		--self.btn_name:SetLocalText(208225)
	elseif self.param.settingType == SettingType.GameNotice then
		self.btn_name:SetLocalText(312082)
	elseif self.param.settingType == SettingType.DeleteAccount then
		self.btn_name:SetLocalText(208271)
	end
end

local function ChangeScene(self)
	
end

UISettingCell.OnCreate = OnCreate
UISettingCell.OnDestroy = OnDestroy
UISettingCell.Param = Param
UISettingCell.OnEnable = OnEnable
UISettingCell.OnDisable = OnDisable
UISettingCell.ComponentDefine = ComponentDefine
UISettingCell.ComponentDestroy = ComponentDestroy
UISettingCell.DataDefine = DataDefine
UISettingCell.DataDestroy = DataDestroy
UISettingCell.ReInit = ReInit
UISettingCell.OnBtnClick = OnBtnClick
UISettingCell.SetIcon = SetIcon
UISettingCell.SetName = SetName
UISettingCell.ChangeScene = ChangeScene
return UISettingCell