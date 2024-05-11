---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/9/2 20:24
---
local RankListItem = BaseClass("RankListItem",UIBaseContainer)
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"
local UIHeroPluginUpgradePluginIcon = require "UI.UIHeroPluginUpgrade.Component.UIHeroPluginUpgradePluginIcon"
local base = UIBaseContainer

local bg_path = "Common_supple"
local first_name_path = "firstNameTxt"
local second_name_path = "secondNameTxt"
local power_path = "powerTxt" -- 右边那列
local power2_path = "power2Txt" -- 中间那列
local country_path = "country"
local num_path = "numTxt"
local first_flag_path = "firstImg"
local second_flag_path = "secondImg"
local third_flag_path = "thirdImg"
local player_flag_path = "playerFlag"
local alliance_flag_path ="allianceFlag"
local allianceFlagItem_path = "allianceFlag/AllianceFlag"
local player_icon_path="playerFlag/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "playerFlag/UIPlayerHead/Foreground"
local btn_path = "Button"
local default_icon_path="Assets/Main/Sprites/UI/Common/New/Common_icon_player_head_big.png"
local direction_icon_path = "powerTxt/direction_icon" -- 突破方向图片
local hero_plugin_path = "powerTxt/UIHeroPluginBtn" -- 插件
local player_btn_path="playerFlag/UIPlayerHead"

local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
    self.bgN = self:AddComponent(UIImage, bg_path)
    self.first_txt= self:AddComponent(UITextMeshProUGUIEx,first_name_path)
    self.second_txt = self:AddComponent(UITextMeshProUGUIEx,second_name_path)
    self.power_txt = self:AddComponent(UITextMeshProUGUIEx,power_path)
    self.power2_txt = self:AddComponent(UITextMeshProUGUIEx,power2_path)
	self.country_img = self:AddComponent(UIImage,country_path)
    self.num_txt = self:AddComponent(UITextMeshProUGUIEx,num_path)
    
    self.first_flag = self:AddComponent(UIBaseContainer,first_flag_path)
    self.second_flag = self:AddComponent(UIBaseContainer,second_flag_path)
    self.third_flag = self:AddComponent(UIBaseContainer,third_flag_path)
    
    self.player_flag = self:AddComponent(UIBaseContainer,player_flag_path)
    self.alliance_flag = self:AddComponent(UIBaseContainer,alliance_flag_path)
    self.allianceFlagItemN = self:AddComponent(AllianceFlagItem,allianceFlagItem_path)
	
	self.player_img =self:AddComponent(UIPlayerHead,player_icon_path)
    self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg_path)
    
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClick()
    end)
    self.direction_icon = self:AddComponent(UIImage, direction_icon_path)
    self.hero_plugin = self:AddComponent(UIHeroPluginUpgradePluginIcon, hero_plugin_path)
    self.player_btn =self:AddComponent(UIButton,player_btn_path)
    self.player_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnPlayerBtnClick()
    end)
end

local function SetItemShow(self, data)
    self.data = data
    self.alliance_flag:SetActive(self.data.isAlliance==true)
    if self.data.isAlliance then
        self.allianceFlagItemN:SetData(self.data.icon)
    end
    self.player_flag:SetActive(self.data.isAlliance == false)
    self.first_flag:SetActive(self.data.rank ==1)
    self.third_flag:SetActive(self.data.rank ==3)
    self.second_flag:SetActive(self.data.rank ==2)

    self.num_txt:SetText(self.data.rank)
    if self.data.rank>3 then
        self.bgN:LoadSprite("Assets/Main/Sprites/UI/UIArena/arena_img_columns04")
        self.num_txt:SetActive(true)
        --self.num_txt:SetColor(Color.New(1,0.73,0.19,1))
    else
        self.num_txt:SetActive(false)
        self.bgN:LoadSprite("Assets/Main/Sprites/UI/UIArena/arena_img_columns0" .. self.data.rank)
        --self.num_txt:SetColor(WhiteColor)
    end
    self.first_txt:SetText(self.data.firstName)
	local secondName = self.data.secondName
	if secondName=="" then
		secondName="-"
	end
	if self.data.isAlliance then
		--self.second_txt:SetText(Localization:GetString("390020")..secondName)
        self.second_txt:SetText(secondName)
	else
		self.second_txt:SetText(secondName)
	end

    self.power_txt:SetText(self.data.power)
    if not string.IsNullOrEmpty(self.data.power2) then
        self.power2_txt:SetActive(true)
        self.power2_txt:SetText(self.data.power2)
    else
        self.power2_txt:SetActive(false)
    end
    --如果有图标那么power_txt要改成左描点
    if self.data.pivotType ~= nil then
        self.power_txt.rectTransform.pivot = self.data.pivotType
    else
        self.power_txt.rectTransform.pivot = PivotType.Center
    end
    if self.data.directionIcon ~= nil and self.data.directionIcon ~= "" then
        self.direction_icon:SetActive(true)
        self.direction_icon:LoadSprite(self.data.directionIcon)
    else
        self.direction_icon:SetActive(false)
    end
    if self.data.noUseBtn then
        self.btn:SetActive(false)
    else
        self.btn:SetActive(true)
    end
   
    if self.data.plugin ~= nil then
        self.hero_plugin:SetActive(true)
        local param = {}
        param.level = self.data.lv
        param.camp = self.data.camp
        param.callback = function()
            local uiParam = {}
            uiParam.plugin = self.data.plugin
            uiParam.lv = self.data.lv
            uiParam.camp = self.data.camp
            uiParam.score = self.data.power
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginRankInfo, { anim = true, playEffect = false }, uiParam)
        end
        self.hero_plugin:ReInit(param)
    else
        self.hero_plugin:SetActive(false)
    end
    
	--if LuaEntry.Player.uid == self.data.uid then
	--	self.player_img:LoadSprite(LuaEntry.Player:GetFullPic())
	--else
    if not self.data.isAlliance then
        self.player_img:SetData(self.data.uid, self.data.pic, self.data.picVer)
    end
    if self.data.headBg then
        self.playerHeadFg:SetActive(true)
        self.playerHeadFg:LoadSprite(self.data.headBg)
    else
        self.playerHeadFg:SetActive(false)
    end
		--self.player_img:LoadSprite(default_icon_path)
	--end

	if LuaEntry.Player:IsHideCountryFlag() then
		self.country_img:SetActive(false)
	else
		self.country_img:SetActive(true)
		if self.data.country == "" then
			self.country_img:LoadSprite(DataCenter.NationTemplateManager:GetNationTemplate(DefaultNation))
		else
			self.country_img:LoadSprite(self.data.country:GetNationFlagPath())
		end
	end
end

local function OnClick(self)
    if self.data.type == RankType.CommanderBase or self.data.type == RankType.CommanderKill or self.data.type == RankType.CommanderPower or self.data.type == RankType.SeasonForce then
        self.view:OnPlayerDetailClick(self.data.uid)
    elseif self.data.type == RankType.AllianceKill or self.data.type == RankType.AlliancePower or self.data.type == RankType.OtherServerAlliancePower then
        self.view:OnAllianceDetailClick(self.data.uid,self.data.allianceName)
    elseif self.data.type == RankType.HeroPluginRank then
        local uiParam = {}
        uiParam.plugin = self.data.plugin
        uiParam.lv = self.data.lv
        uiParam.camp = self.data.camp
        uiParam.score = self.data.power
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroPluginRankInfo, { anim = true, playEffect = false }, uiParam)
    end
end
local function OnDestroy(self)
	self.first_txt= nil
	self.second_txt = nil
	self.power_txt = nil
	self.power2_txt = nil
	self.num_txt = nil

	self.first_flag = nil
	self.second_flag = nil
	self.third_flag = nil

	self.player_flag = nil
	self.alliance_flag =nil

	self.player_img =nil

	self.btn = nil
    base.OnDestroy(self)
end

function RankListItem:OnPlayerBtnClick()
    self.view.ctrl:OnPlayerDetailClick(self.data.uid)
end

RankListItem.OnCreate = OnCreate
RankListItem.SetItemShow = SetItemShow
RankListItem.OnClick = OnClick
RankListItem.OnDestroy =OnDestroy
return RankListItem