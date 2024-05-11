local UISettingSliderCell = BaseClass("UISettingSliderCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local Sound = CS.GameEntry.Sound
local rapidjson = require "rapidjson"

local Param = DataClass("Param", ParamData)
local ParamData =  {
	setType,
}

local push_name_path = "PushName"
local push_des_path = "PushDes"
local slider_path = "Slider"
local btn_path = "SwitchBtn"

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
	self.push_name = self:AddComponent(UITextMeshProUGUIEx, push_name_path)
	self.push_des = self:AddComponent(UITextMeshProUGUIEx, push_des_path)
	self.slider = self:AddComponent(UISlider, slider_path)
	self.btn = self:AddComponent(UIButton, btn_path)
	self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
end

--控件的销毁
local function ComponentDestroy(self)
	self.push_name = nil
	self.push_des = nil
	self.slider = nil
	self.btn = nil
end

--变量的定义
local function DataDefine(self)
	self.param = {}
	self.isOn = nil
end

--变量的销毁
local function DataDestroy(self)
	self.param = nil
	self.isOn = nil
end

-- 全部刷新
local function ReInit(self,param)
	self.param = param
	self:SetName()
	self:SetIsOn()
	
end


local function OnBtnClick(self)
	self.isOn = not self.isOn
	self:SetIsOn()
	if self.param.setType == SettingSetType.Effect then
		if self.isOn then
			Setting:SetBool(SettingKeys.EFFECT_MUSIC_ON, true)
			Sound:SetSoundGroupMute(SoundGround.Effect, false)
			Sound:SetSoundGroupMute(SoundGround.Dub, false)
			self.push_des:SetLocalText(280022) 
			UIUtil.ShowTipsId(280022) 
		else
			Setting:SetBool(SettingKeys.EFFECT_MUSIC_ON, false)
			Sound:SetSoundGroupMute(SoundGround.Effect, true)
			Sound:SetSoundGroupMute(SoundGround.Dub, true)
			self.push_des:SetLocalText(280019) 
			UIUtil.ShowTipsId(280019) 
		end
	elseif self.param.setType == SettingSetType.Sound then
		if self.isOn then
			Setting:SetBool(SettingKeys.BG_MUSIC_ON, true)
			Sound:SetSoundGroupMute(SoundGround.Music, false)
			self.push_des:SetLocalText(280021) 
			UIUtil.ShowTipsId(280021) 
		else
			Setting:SetBool(SettingKeys.BG_MUSIC_ON, false)
			Sound:SetSoundGroupMute(SoundGround.Music, true)
			self.push_des:SetLocalText(280018) 
			UIUtil.ShowTipsId(280018) 
		end
	elseif self.param.setType == SettingSetType.Diamond then
		if self.isOn then
			Setting:SetBool(SettingKeys.SHOW_USE_DIAMOND_ALERT, true)
			self.push_des:SetLocalText(129077) 
			UIUtil.ShowTipsId(129077) 
		else
			Setting:SetBool(SettingKeys.SHOW_USE_DIAMOND_ALERT, false)
			self.push_des:SetLocalText(129078) 
			UIUtil.ShowTipsId(129078) 
		end
	elseif self.param.setType == SettingSetType.Task then
		if self.isOn then
			Setting:SetBool(SettingKeys.TASK_TIPS_ON, true)
			UIUtil.ShowTipsId(280023) 
		else
			Setting:SetBool(SettingKeys.TASK_TIPS_ON, false)
			UIUtil.ShowTipsId(280020) 
		end
	elseif self.param.setType == SettingSetType.Question then
		if self.isOn then
			Setting:SetBool(SettingKeys.TOUCH_SP_FUN, true)
			UIUtil.ShowTipsId(120068) 
		else
			Setting:SetBool(SettingKeys.TOUCH_SP_FUN, false)
			UIUtil.ShowTipsId(120067) 
		end
	elseif self.param.setType == SettingSetType.Position then
		if self.isOn then
			Setting:SetBool(SettingKeys.COORDINATE_ON_SHOW, true)
			UIUtil.ShowTipsId(120068) 
		else
			Setting:SetBool(SettingKeys.COORDINATE_ON_SHOW, false)
			UIUtil.ShowTipsId(120067) 
		end
	elseif self.param.setType == SettingSetType.DebugChooseServer then
		if self.isOn then
			Setting:SetBool(SettingKeys.SHOW_DEBUG_CHOOSE_SERVER, true)
			UIUtil.ShowTipsId(120068) 
		else
			Setting:SetBool(SettingKeys.SHOW_DEBUG_CHOOSE_SERVER, false)
			UIUtil.ShowTipsId(120067) 
		end
	elseif self.param.setType == SettingSetType.SceneParticles then
		if self.isOn then
			Setting:SetBool(SettingKeys.SCENE_PARTICLES, true)
			UIUtil.ShowTipsId(120068) 
		else
			Setting:SetBool(SettingKeys.SCENE_PARTICLES, false)
			UIUtil.ShowTipsId(120067) 
		end
	elseif self.param.setType == SettingSetType.Surface then  -- 性能分析：地表开关
		if self.isOn then
			Setting:SetBool(SettingKeys.SCENE_SURFACE, true)
			UIUtil.ShowTipsId(120068) 
		else
			Setting:SetBool(SettingKeys.SCENE_SURFACE, false)
			UIUtil.ShowTipsId(120067) 
		end

		if CS.SceneManager.World then
			CS.SceneManager.World:ProfileToggleTerrain()
		end
	elseif self.param.setType == SettingSetType.Build then  -- 性能分析：建筑开发
		if self.isOn then
			Setting:SetBool(SettingKeys.SCENE_BUILD, true)
			UIUtil.ShowTipsId(120068) 
		else
			Setting:SetBool(SettingKeys.SCENE_BUILD, false)
			UIUtil.ShowTipsId(120067) 
		end
		
		if CS.SceneManager.World then
			CS.SceneManager.World:ProfileToggleBuilding()
		end
	elseif self.param.setType == SettingSetType.Decorations then  -- 性能分析：装饰物、山石
		if self.isOn then
			Setting:SetBool(SettingKeys.SCENE_DECORATIONS, true)
			UIUtil.ShowTipsId(120068) 
		else
			Setting:SetBool(SettingKeys.SCENE_DECORATIONS, false)
			UIUtil.ShowTipsId(120067) 
		end
		
		if CS.SceneManager.World then
			CS.SceneManager.World:ProfileToggleStatic()
		end
	elseif self.param.setType == SettingSetType.Monster then  -- 性能分析：野怪
		if self.isOn then
			Setting:SetBool(SettingKeys.SCENE_MONSTER, true)
			UIUtil.ShowTipsId(120068) 
		else
			Setting:SetBool(SettingKeys.SCENE_MONSTER, false)
			UIUtil.ShowTipsId(120067) 
		end
		if CS.SceneManager.World then
			CS.SceneManager.World:ProfileToggleMarch()
		end
		if self.isOn then
			UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
		end
	elseif self.param.setType == SettingSetType.ShowTroopName then
		if self.isOn then
			Setting:SetBool("ShowTroopName", true)
			UIUtil.ShowTipsId(120068)
		else
			Setting:SetBool("ShowTroopName", false)
			UIUtil.ShowTipsId(120067)
		end
		EventManager:GetInstance():Broadcast(EventId.ChangeShowTroopNameState)
	elseif self.param.setType == SettingSetType.ShowTroopHead then
		if self.isOn then
			Setting:SetBool("ShowTroopHead", true)
			UIUtil.ShowTipsId(120068)
		else
			Setting:SetBool("ShowTroopHead", false)
			UIUtil.ShowTipsId(120067)
		end
		EventManager:GetInstance():Broadcast(EventId.ChangeShowTroopHeadState)
	elseif self.param.setType == SettingSetType.ShowTroopDestroyIcon then
		if self.isOn then
			Setting:SetBool("ShowTroopDestroyIcon", true)
			UIUtil.ShowTipsId(120068)
		else
			Setting:SetBool("ShowTroopDestroyIcon", false)
			UIUtil.ShowTipsId(120067)
		end
		EventManager:GetInstance():Broadcast(EventId.ChangeShowTroopDestroyIconState)
	elseif self.param.setType == SettingSetType.ShowTroopBloodNum then
		if self.isOn then
			Setting:SetPrivateBool("ShowTroopBloodNum", true)
			UIUtil.ShowTipsId(120068)
		else
			Setting:SetPrivateBool("ShowTroopBloodNum", false)
			UIUtil.ShowTipsId(120067)
		end
		EventManager:GetInstance():Broadcast(EventId.ChangeShowTroopBloodNumState)
	elseif self.param.setType == SettingSetType.ShowTroopAttackEffect then
		if self.isOn then
			Setting:SetPrivateBool("ShowTroopAttackEffect", true)
			UIUtil.ShowTipsId(120068)
		else
			Setting:SetPrivateBool("ShowTroopAttackEffect", false)
			UIUtil.ShowTipsId(120067)
		end
		EventManager:GetInstance():Broadcast(EventId.ChangeShowTroopAttackEffectState)
	elseif self.param.setType == SettingSetType.ShowTroopGunAttackEffect then
		if self.isOn then
			Setting:SetPrivateBool("ShowTroopGunAttackEffect", true)
			UIUtil.ShowTipsId(120068)
		else
			Setting:SetPrivateBool("ShowTroopGunAttackEffect", false)
			UIUtil.ShowTipsId(120067)
		end
		EventManager:GetInstance():Broadcast(EventId.ChangeShowTroopGunAttackEffectState)
	elseif self.param.setType == SettingSetType.ShowTroopDamageAttackEffect then
		if self.isOn then
			Setting:SetPrivateBool("ShowTroopDamageAttackEffect", true)
			UIUtil.ShowTipsId(120068)
		else
			Setting:SetPrivateBool("ShowTroopDamageAttackEffect", false)
			UIUtil.ShowTipsId(120067)
		end
		EventManager:GetInstance():Broadcast(EventId.ChangeShowTroopDamageAttackEffectState)
	elseif self.param.setType == SettingSetType.SendNotice then
		Logger.LogError("send notice")
		if CS.GameEntry.Sdk.Send_FireBase_LogCustomEvent~=nil then
			local str = string.format("test_fireBase|uid,string,%s",LuaEntry.Player.uid)
			CS.GameEntry.Sdk:Send_FireBase_LogCustomEvent(str)
		end
	elseif self.param.setType == SettingSetType.UseLuaLoading then
		if self.isOn then
			Setting:SetBool("UseLuaLoading",true)
		else
			Setting:SetBool("UseLuaLoading",false)
		end
	elseif self.param.setType == SettingSetType.SetGoogleAdsReward then
		print("send GAds_adsRewardedAd")
		if CS.SDKManager.IS_UNITY_ANDROID() then
			
			DataCenter.GoogleAdsManager:ShowRewarded("ca-app-pub-6412147225625279/2094081842","testId")
		elseif CS.SDKManager.IS_UNITY_IPHONE() then
			DataCenter.GoogleAdsManager:ShowRewarded("ca-app-pub-6412147225625279/6110166716","testId")
		end
	elseif self.param.setType == SettingSetType.SetUnityAdsReward then
		print("send UAds_adsRewardedAd")
		if CS.SDKManager.IS_UNITY_ANDROID() then
			DataCenter.UnityAdsManager:ShowRewarded("QR_APS_Rewarded_AN-2023-10-24","testId")
		elseif CS.SDKManager.IS_UNITY_IPHONE() then
			DataCenter.UnityAdsManager:ShowRewarded("QR_APS_Rewarded_IOS-2023-10-24","testId")
		end
	elseif self.param.setType == SettingSetType.SetUseContentSizeFitter then
		if self.isOn then
			Setting:SetPrivateBool("UseContentSizeFitter",true)
		else
			Setting:SetPrivateBool("UseContentSizeFitter",false)
		end
	elseif self.param.setType == SettingSetType.SkyBox then  -- 天空盒
		if self.isOn then
			UIUtil.ShowTipsId(120068) 
		else
			UIUtil.ShowTipsId(120067) 
		end
		if CS.SceneManager.World then
			CS.SceneManager.World:ProfileToggleHeightFog()
		end
	elseif self.param.setType == SettingSetType.Vibrate then
		if self.isOn then
			self.push_des:SetLocalText(208221)
			UIUtil.ShowTipsId(120068)
			Setting:SetBool(SettingKeys.VIBRATE, true)
			CS.MoreMountains.NiceVibrations.MMVibrationManager.SetHapticsActive(true)
		else
			self.push_des:SetLocalText(208220)
			UIUtil.ShowTipsId(120067)
			Setting:SetBool(SettingKeys.VIBRATE, false)
			CS.MoreMountains.NiceVibrations.MMVibrationManager.SetHapticsActive(false)
		end
	elseif self.param.setType == SettingSetType.FullScreen then
		if self.isOn then
			if CS.WindowsTool~=nil and CS.WindowsTool.Instance ~= nil then
				CS.WindowsTool.Instance:EnterFullScreen()
			end
			UIUtil.ShowTipsId(120068)
			self.view:OnScreenResolutionRefresh()
		else
			if CS.WindowsTool~=nil and CS.WindowsTool.Instance ~= nil then
				CS.WindowsTool.Instance:QuitFullScreen()
			end
			UIUtil.ShowTipsId(120067)
			self.view:OnScreenResolutionRefresh()
		end
	elseif self.param.setType == SettingSetType.PveShowHp then
		if self.isOn then
			Setting:SetPrivateBool("PVE_SHOW_HP", true)
		else
			Setting:SetPrivateBool("PVE_SHOW_HP", false)
		end
	elseif self.param.setType == SettingSetType.PveOldDetect then
		if self.isOn then
			Setting:SetPrivateBool("PVE_OLD_DETECT", true)
		else
			Setting:SetPrivateBool("PVE_OLD_DETECT", false)
		end
	end
	
end

local function SetName(self)
	if self.param.setType == SettingSetType.Effect then
		self.push_name:SetLocalText(280035) 
		self.isOn = Setting:GetBool(SettingKeys.EFFECT_MUSIC_ON, true)
		if self.isOn then
			self.push_des:SetLocalText(280022) 
		else
			self.push_des:SetLocalText(280019) 
		end
	elseif self.param.setType == SettingSetType.Sound then
		self.push_name:SetLocalText(110111) 
		self.isOn = Setting:GetBool(SettingKeys.BG_MUSIC_ON, true)
		if self.isOn then
			self.push_des:SetLocalText(280021) 
		else
			self.push_des:SetLocalText(280018) 
		end
	elseif self.param.setType == SettingSetType.Diamond then
		self.push_name:SetLocalText(129075) 
		self.isOn = Setting:GetBool(SettingKeys.SHOW_USE_DIAMOND_ALERT, true)
		if self.isOn then
			self.push_des:SetLocalText(129077) 
		else
			self.push_des:SetLocalText(129078) 
		end
	elseif self.param.setType == SettingSetType.Task then
		self.push_name:SetLocalText(280017) 
		self.push_des:SetLocalText(280016) 
		self.isOn = Setting:GetBool(SettingKeys.TASK_TIPS_ON, true)
	elseif self.param.setType == SettingSetType.Question then
		self.push_name:SetLocalText(390524) 
		self.push_des:SetLocalText(390525) 
		self.isOn = Setting:GetBool(SettingKeys.TOUCH_SP_FUN, true)
	elseif self.param.setType == SettingSetType.Position then
		self.push_name:SetLocalText(390058) 
		self.push_des:SetLocalText(110091) 
		self.isOn = Setting:GetBool(SettingKeys.COORDINATE_ON_SHOW, true)
	elseif self.param.setType == SettingSetType.DebugChooseServer then
		self.push_name:SetText(Localization:GetString("ES100013"))
		self.push_des:SetText(Localization:GetString("ES100013"))
		self.isOn = Setting:GetBool(SettingKeys.SHOW_DEBUG_CHOOSE_SERVER, true)
	elseif self.param.setType == SettingSetType.SceneParticles then
		self.push_name:SetLocalText(280009) 
		self.push_des:SetLocalText(280007) 
		self.isOn = Setting:GetBool(SettingKeys.SCENE_PARTICLES, true)
	elseif self.param.setType == SettingSetType.Surface then
		self.push_name:SetLocalText(100256) 
		self.push_des:SetLocalText(280007) 
		--self.isOn = Setting:GetBool(SettingKeys.SCENE_SURFACE, true)
		if CS.SceneManager.World then
			self.isOn = CS.SceneManager.World:GetProfileTerrainSwitch()
		end
	elseif self.param.setType == SettingSetType.Build then
		self.push_name:SetLocalText(100441) 
		self.push_des:SetLocalText(280007) 
		--self.isOn = Setting:GetBool(SettingKeys.SCENE_BUILD, true)

		if CS.SceneManager.World then
			self.isOn = CS.SceneManager.World:GetProfileBuildingSwitch()
		end
	elseif self.param.setType == SettingSetType.Decorations then
		self.push_name:SetLocalText(100440) 
		self.push_des:SetLocalText(280007) 
		--self.isOn = Setting:GetBool(SettingKeys.SCENE_DECORATIONS, true)
		if CS.SceneManager.World then
			self.isOn = CS.SceneManager.World:GetProfileStaticSwitch()
		end
	elseif self.param.setType == SettingSetType.Monster then
		self.push_name:SetLocalText(280005) 
		self.push_des:SetLocalText(280007) 
		--self.isOn = Setting:GetBool(SettingKeys.SCENE_MONSTER, true)
		if CS.SceneManager.World then
			self.isOn = CS.SceneManager.World:GetGraphySwitch()
		end
	elseif self.param.setType == SettingSetType.SendNotice then
		self.push_name:SetText("SendNotice")
		self.push_des:SetText("")
		self.isOn = false
	elseif self.param.setType == SettingSetType.SetGoogleAdsReward then
		self.push_name:SetText("SetGoogleAdsReward")
		self.push_des:SetText("")
		self.isOn = false
	elseif self.param.setType == SettingSetType.SetUseContentSizeFitter then
		self.push_name:SetText("SetUseContentSizeFitter")
		self.push_des:SetText("")
		self.isOn = Setting:GetPrivateBool("UseContentSizeFitter",true)
	elseif self.param.setType == SettingSetType.UseLuaLoading then
		self.push_name:SetText("UseLuaLoading")
		self.push_des:SetText("")
		self.isOn = Setting:GetBool("UseLuaLoading",false)
	elseif self.param.setType == SettingSetType.SetUnityAdsReward then
		self.push_name:SetText("SetUnityAdsReward")
		self.push_des:SetText("")
		self.isOn = false
	elseif self.param.setType == SettingSetType.ShowTroopName then
		self.push_name:SetText("ShowTroopName")
		self.push_des:SetText("")
		self.isOn = Setting:GetBool("ShowTroopName", true)
	elseif self.param.setType == SettingSetType.ShowTroopHead then
		self.push_name:SetText("ShowTroopHead")
		self.push_des:SetText("")
		self.isOn = Setting:GetBool("ShowTroopHead", true)
	elseif self.param.setType == SettingSetType.ShowTroopDestroyIcon then
		self.push_name:SetText("ShowTroopDestroyIcon")
		self.push_des:SetText("")
		self.isOn = Setting:GetBool("ShowTroopDestroyIcon", true)
	elseif self.param.setType == SettingSetType.ShowTroopBloodNum then
		self.push_name:SetText("ShowTroopBloodNum")
		self.push_des:SetText("")
		self.isOn = Setting:GetPrivateBool("ShowTroopBloodNum", true)
	elseif self.param.setType == SettingSetType.ShowTroopAttackEffect then
		self.push_name:SetText("ShowTroopAttackEffect")
		self.push_des:SetText("")
		self.isOn = Setting:GetPrivateBool("ShowTroopAttackEffect", true)
	elseif self.param.setType == SettingSetType.ShowTroopDamageAttackEffect then
		self.push_name:SetText("ShowTroopDamageAttackEffect")
		self.push_des:SetText("")
		self.isOn = Setting:GetPrivateBool("ShowTroopDamageAttackEffect", true)
	elseif self.param.setType == SettingSetType.ShowTroopGunAttackEffect then
		self.push_name:SetText("ShowTroopGunAttackEffect")
		self.push_des:SetText("")
		self.isOn = Setting:GetPrivateBool("ShowTroopGunAttackEffect", true)
	elseif self.param.setType == SettingSetType.SkyBox then
		self.push_name:SetLocalText(100104) 
		self.push_des:SetLocalText(280007)
		if CS.SceneManager.World then
			self.isOn = CS.SceneManager.World:GetHeightFogSwitch()
		end
	elseif self.param.setType == SettingSetType.Vibrate then
		self.push_name:SetLocalText(208219)
		self.isOn = Setting:GetBool(SettingKeys.VIBRATE, true)
		if self.isOn then
			self.push_des:SetLocalText(208221)
		else
			self.push_des:SetLocalText(208220)
		end
	elseif self.param.setType == SettingSetType.FullScreen then
		self.push_name:SetText("Full Screen")
		self.isOn = true
		if CS.WindowsTool~=nil and CS.WindowsTool.Instance ~= nil then
			self.isOn = CS.WindowsTool.Instance:GetIsFullScreen()
		end
	elseif self.param.setType == SettingSetType.PveShowHp then
		self.push_name:SetText("PVE Show Hp")
		self.push_des:SetText("")
		self.isOn = Setting:GetPrivateBool("PVE_SHOW_HP", true)
	elseif self.param.setType == SettingSetType.PveOldDetect then
		self.push_name:SetText("PVE Use Old Detect Method")
		self.push_des:SetText("Force to detect collisions with the old method which uses physics collider instead of area matrix in PVE.")
		self.isOn = Setting:GetPrivateBool("PVE_OLD_DETECT", false)
	end
end

local function SetIsOn(self)
	if self.isOn then
		self.slider:SetValue(1)
	else
		self.slider:SetValue(0)
	end
end


UISettingSliderCell.OnCreate = OnCreate
UISettingSliderCell.OnDestroy = OnDestroy
UISettingSliderCell.Param = Param
UISettingSliderCell.OnEnable = OnEnable
UISettingSliderCell.OnDisable = OnDisable
UISettingSliderCell.ComponentDefine = ComponentDefine
UISettingSliderCell.ComponentDestroy = ComponentDestroy
UISettingSliderCell.DataDefine = DataDefine
UISettingSliderCell.DataDestroy = DataDestroy
UISettingSliderCell.ReInit = ReInit
UISettingSliderCell.OnBtnClick = OnBtnClick
UISettingSliderCell.SetName = SetName
UISettingSliderCell.SetIsOn = SetIsOn


return UISettingSliderCell