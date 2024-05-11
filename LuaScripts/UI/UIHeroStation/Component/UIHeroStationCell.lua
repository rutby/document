---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2022/1/17 20:17
---

local UIHeroStationCell = BaseClass("UIHeroStationCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local hero_path = "Hero"
local quality_path = "Hero/Quality"
local top_path = "Hero/Top"
local effect_path = "Hero/Effect"
local value_path = "Hero/Value"
local level_path = "Hero/Level"
local level_up_path = "Hero/LevelUp"
local level_up_glow_path = "Hero/LevelUp/LevelUpGlow"
local portrait_path = "Hero/Mask/Portrait"
local delete_path = "Hero/DeleteBtn"
local delete_image_path = "Hero/DeleteBtn/DeleteImage"
local star_list_path = "Hero/StarList"
local star_path = "Hero/StarList/Star_%s"
local rank_path = "Hero/Rank"
local add_path = "Add"
local add_bg_path = "Add/Bg"
local add_glow_path = "Add/AddBg/AddGlow"
local lock_path = "Lock"
local locked_bg_path = "Lock/Bg"
local select_path = "SelectBtn"

local STAR_COUNT = 3

local State =
{
    Lock = 1,
    Add = 2,
    Hero = 3,
}

local QualityColor =
{
    [2] = "blue",
    [3] = "blue",
    [4] = "pur",
    [5] = "pur",
    [6] = "org",
    [7] = "org",
    [8] = "red",
    [9] = "red",
    [10] = "gold",
    [11] = "gold",
    [12] = "col",
    [13] = "col",
    [14] = "col",
    [15] = "col",
}

local QualityStarCount =
{
    [2] = 0,
    [3] = 1,
    [4] = 0,
    [5] = 1,
    [6] = 0,
    [7] = 1,
    [8] = 0,
    [9] = 1,
    [10] = 0,
    [11] = 1,
    [12] = 0,
    [13] = 1,
    [14] = 2,
    [15] = 3,
}

local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.hero_go = self:AddComponent(UIBaseContainer, hero_path)
    self.quality_image = self:AddComponent(UIImage, quality_path)
    self.top_image = self:AddComponent(UIImage, top_path)
    self.effect_image = self:AddComponent(UIImage, effect_path)
    self.value_text = self:AddComponent(UIText, value_path)
    self.level_text = self:AddComponent(UIText, level_path)
    self.level_up_btn = self:AddComponent(UIButton, level_up_path)
    self.level_up_btn:SetOnClick(function() self:OnLevelUpClick() end)
    self.level_up_glow_go = self:AddComponent(UIBaseContainer, level_up_glow_path)
    self.portrait_image = self:AddComponent(UIImage, portrait_path)
    self.delete_btn = self:AddComponent(UIButton, delete_path)
    self.delete_btn:SetOnClick(function() self:OnDeleteClick() end)
    self.delete_image = self:AddComponent(UIImage, delete_image_path)
    self.star_list_go = self:AddComponent(UIBaseContainer, star_list_path)
    self.stars = {}
    for i = 1, STAR_COUNT do
        self.stars[i] = self:AddComponent(UIBaseContainer, string.format(star_path, i))
    end
    self.rank_image = self:AddComponent(UIImage, rank_path)
    self.add_go = self:AddComponent(UIBaseContainer, add_path)
    self.add_bg_go = self:AddComponent(UIBaseContainer, add_bg_path)
    self.add_glow_go = self:AddComponent(UIBaseContainer, add_glow_path)
    self.locked_go = self:AddComponent(UIBaseContainer, lock_path)
    self.locked_bg_go = self:AddComponent(UIImage, locked_bg_path)
    self.select_btn = self:AddComponent(UIButton, select_path)
    self.select_btn:SetOnClick(function() self:OnSelectClick() end)
    --默认状态
    self.locked_go:SetActive(false)
    self.add_go:SetActive(true)
    self.hero_go:SetActive(false)
end

local function ComponentDestroy(self)
    self.anim = nil
    self.hero_go = nil
    self.quality_image = nil
    self.effect_image = nil
    self.value_text = nil
    self.level_text = nil
    self.level_up_btn = nil
    self.level_up_glow_go = nil
    self.portrait_image = nil
    self.delete_btn = nil
    self.delete_image = nil
    self.star_list_go = nil
    self.stars = nil
    self.rank_image = nil
    self.add_go = nil
    self.add_bg_go = nil
    self.add_glow_go = nil
    self.locked_go = nil
    self.locked_bg_go = nil
    self.select_btn = nil
end

local function DataDefine(self)
    self.state = nil
    self.data = nil
    self.onSelectClick = nil
    self.onDeleteClick = nil
    self.onLevelUpClick = nil
end

local function DataDestroy(self)
    self.state = nil
    self.data = nil
    self.onSelectClick = nil
    self.onDeleteClick = nil
    self.onLevelUpClick = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function SetState(self, state)
    self.state = state
    self.locked_go:SetActive(state == State.Lock)
    self.add_go:SetActive(state == State.Add)
    self.hero_go:SetActive(state == State.Hero)
end

local function SetData(self, data)
    self.data = data
    self:Refresh()
end

local function Refresh(self)
    local data = self.data
    if data == nil then
        return
    end
    
    local heroUuid = data.heroUuid
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(heroUuid)
    local colorStr = QualityColor[heroData.quality]
    self.quality_image:LoadSprite("Assets/Main/Sprites/UI/UIHeroStation/UIappoint_img_herobg_" .. colorStr .. "01")
    self.top_image:LoadSprite("Assets/Main/Sprites/UI/UIHeroStation/UIappoint_img_herobg_" .. colorStr .. "02")
    self.delete_image:LoadSprite("Assets/Main/Sprites/UI/UIHeroStation/UIappoint_btn_off" .. colorStr)
    self.effect_image:LoadSprite(data.effectIcon, nil, function()
        self.effect_image:SetNativeSize()
    end)
    self.value_text:SetText(data.valueText)
    self.level_text:SetText("Lv." .. heroData.level)
    self.level_up_btn:SetActive(heroData.level < heroData:GetFinalLevel())
    --self.portrait_image:LoadSprite("Assets/Main/Sprites/HeroBody/" .. HeroUtils.GetHeroBodyByHeroId(heroData.heroId))
    self.portrait_image:LoadSprite(HeroUtils.GetHeroIconPath(heroData.heroId))
    for i = 1, STAR_COUNT do
        self.stars[i]:SetActive(i <= QualityStarCount[heroData.quality])
    end
    self.rank_image:SetActive(heroData.curMilitaryRankId > 1)
    self.rank_image:LoadSprite(HeroUtils.GetMilitaryRankIcon(heroData.curMilitaryRankId))
end

local function SetOnSelectClick(self, func)
    self.onSelectClick = func
end

local function SetOnDeleteClick(self, func)
    self.onDeleteClick = func
end

local function SetOnLevelUpClick(self, func)
    self.onLevelUpClick = func
end

local function OnSelectClick(self)
    if self.onSelectClick then
        self.onSelectClick()
    end
end

local function OnDeleteClick(self)
    if self.onDeleteClick then
        self.onDeleteClick()
    end
end

local function OnLevelUpClick(self)
    if self.onLevelUpClick then
        self.onLevelUpClick()
    end
end

local function GetLvUpPos(self)
    return self.level_up_btn.transform.position    
end

--只获取空闲，使用addB_go位置
local function GetValuePos(self)
    local pos = self.add_bg_go.transform.position
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    pos.y = pos.y + self.add_bg_go:GetSizeDelta().y*0.5*scaleFactor
    return pos
end

local function GetLockPos(self)
    local pos = self.locked_bg_go.transform.position
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    pos.y = pos.y + self.locked_bg_go:GetSizeDelta().y*0.5*scaleFactor
    return pos
end

local function ShowAddGlow(self, show)
    self.add_glow_go:SetActive(show)
end

local function ShowLevelUpGlow(self, show)
    self.level_up_glow_go:SetActive(show)
end

local function PlayAnim(self, animName)
    self.anim:Play(animName, 0, 0)
end

UIHeroStationCell.OnCreate= OnCreate
UIHeroStationCell.OnDestroy = OnDestroy
UIHeroStationCell.ComponentDefine = ComponentDefine
UIHeroStationCell.ComponentDestroy = ComponentDestroy
UIHeroStationCell.DataDefine = DataDefine
UIHeroStationCell.DataDestroy = DataDestroy
UIHeroStationCell.OnEnable = OnEnable
UIHeroStationCell.OnDisable = OnDisable

UIHeroStationCell.State = State
UIHeroStationCell.SetState = SetState
UIHeroStationCell.SetData = SetData
UIHeroStationCell.Refresh = Refresh
UIHeroStationCell.SetOnSelectClick = SetOnSelectClick
UIHeroStationCell.SetOnDeleteClick = SetOnDeleteClick
UIHeroStationCell.SetOnLevelUpClick = SetOnLevelUpClick
UIHeroStationCell.OnSelectClick = OnSelectClick
UIHeroStationCell.OnDeleteClick = OnDeleteClick
UIHeroStationCell.OnLevelUpClick = OnLevelUpClick
UIHeroStationCell.GetLvUpPos = GetLvUpPos
UIHeroStationCell.GetValuePos = GetValuePos
UIHeroStationCell.GetLockPos = GetLockPos
UIHeroStationCell.ShowAddGlow = ShowAddGlow
UIHeroStationCell.ShowLevelUpGlow = ShowLevelUpGlow
UIHeroStationCell.PlayAnim = PlayAnim

return UIHeroStationCell