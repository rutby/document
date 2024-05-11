---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2022/1/6 14:33
---
local LackPowerItem = BaseClass("LackPowerItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local recommend_path = "AddBtn/Recommend"
local item_icon_path = "AddBtn/iconBg/icon"
local name_text_path = "AddBtn/Name_Txt"
local go_btn_path = "AddBtn/Btn_Go"
local go_txt_path = "AddBtn/Btn_Go/Txt_Go"
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
    self.recommend_rect = self:AddComponent(UIBaseContainer,recommend_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)

    self.go_btn = self:AddComponent(UIButton,go_btn_path)
    self.go_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self.go_txt = self:AddComponent(UITextMeshProUGUIEx,go_txt_path)
    
end

--控件的销毁
local function ComponentDestroy(self)
    self.recommend_rect = nil
    self.item_icon = nil
    self.name_text = nil
    self._add_btn = nil
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
    self:ShowRecommend(false)
    --self._add_btn:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_bg_item2"))
    self.item_icon:SetActive(true)
    self.item_icon:LoadSprite(string.format(LoadPath.ResLackIcons,self.param.pic))
    self.name_text:SetText(Localization:GetString(self.param.name))
    self.go_txt:SetActive(true)
    self.go_btn:SetActive(true)
    self.go_txt:SetText(param.btnName)
end

local function ShowRecommend(self,isRecommend)
    self.recommend_rect:SetActive(isRecommend)
end

local function OnBtnClick(self)
    if self.param~=nil then
        if self.param.selectType == FormationAddSoldierType.TrainSoldier then
            if self.param.buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
                GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK,WorldTileBtnType.City_TrainingInfantry)
            elseif self.param.buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
                GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK,WorldTileBtnType.City_TrainingAircraft)
            elseif self.param.buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
                GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_CAR_BARRACK,WorldTileBtnType.City_TrainingTank)
            end
            return
        elseif self.param.selectType == FormationAddSoldierType.TrainHighSoldier then
            if self.param.buildId == BuildingTypes.FUN_BUILD_INFANTRY_BARRACK then
                GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_INFANTRY_BARRACK,WorldTileBtnType.City_TrainingInfantry)
            elseif self.param.buildId == BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK then
                GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_AIRCRAFT_BARRACK,WorldTileBtnType.City_TrainingAircraft)
            elseif self.param.buildId == BuildingTypes.FUN_BUILD_CAR_BARRACK then
                GoToUtil.GotoCityByBuildId(BuildingTypes.FUN_BUILD_CAR_BARRACK,WorldTileBtnType.City_TrainingTank)
            end
            return
        elseif self.param.selectType == FormationAddSoldierType.HeroPowerAdd then
            local heroList = {}
            local heroUuid = self.param.heroUuid
            table.insert(heroList,heroUuid)
            self.view.ctrl:CloseSelf()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroInfo, 1, heroUuid, heroList)
            return
        elseif self.param.selectType == FormationAddSoldierType.GarageUpgrade then
            GoToUtil.GotoCityByBuildId(self.param.buildId,WorldTileBtnType.GarageRefit)
            return
        end
    end
end

LackPowerItem.OnCreate = OnCreate
LackPowerItem.OnDestroy = OnDestroy
LackPowerItem.OnBtnClick = OnBtnClick
LackPowerItem.OnEnable = OnEnable
LackPowerItem.OnDisable = OnDisable
LackPowerItem.ComponentDefine = ComponentDefine
LackPowerItem.ComponentDestroy = ComponentDestroy
LackPowerItem.DataDefine = DataDefine
LackPowerItem.DataDestroy = DataDestroy
LackPowerItem.ReInit = ReInit
LackPowerItem.ShowRecommend = ShowRecommend
return LackPowerItem