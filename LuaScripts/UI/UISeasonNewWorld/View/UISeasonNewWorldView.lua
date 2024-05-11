--- Created by shimin.
--- DateTime: 2020/8/17 15:18
--- UISeasonNewWorldView.lua

local UISeasonNewWorldView = BaseClass("UISeasonNewWorldView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title1_path = "Top/title1"
local title3_path = "Top/title3"
local bgImg_path = "Bg1"
local seasonImg_path = "Top/seasonImg"
local closeBtn_path = "BtnClose"
local tip_path = "Top/tip"
local infoBtn_path = "Top/introBtn"
local infoBtnTxt_path = "Top/introBtn/introBtnTxt"
local heroBtn_path = "Top/heroBtn"
local heroBtnTxt_path = "Top/heroBtn/heroBtnTxt"
local seasonStartTip_path = "Top/Time/timeTip"
local seasonStartTime_path = "Top/Time/timeCD"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitData()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.title1N = self:AddComponent(UIText, title1_path)
    self.title1N:SetLocalText(110372)
    self.title1N:SetActive(false)
    self.title3N = self:AddComponent(UIText, title3_path)
    self.seasonImgN = self:AddComponent(UIImage, seasonImg_path)
    self.bgImgN = self:AddComponent(UIImage, bgImg_path)
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self:OnClickCloseBtn()
    end)
    self.tipN = self:AddComponent(UIText, tip_path)
    self.tipN:SetLocalText(110373)
    self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    self.infoBtnTxtN = self:AddComponent(UIText, infoBtnTxt_path)
    self.infoBtnTxtN:SetLocalText(302027)
    self.heroBtnN = self:AddComponent(UIButton, heroBtn_path)
    self.heroBtnN:SetOnClick(function()
        self:OnClickHeroBtn()
    end)
    self.heroBtnTxtN = self:AddComponent(UIText, heroBtnTxt_path)
    self.heroBtnTxtN:SetLocalText(100275)
    self.seasonStartTipN = self:AddComponent(UIText, seasonStartTip_path)
    self.seasonStartTipN:SetLocalText(372556)
    self.seasonStartTimeN = self:AddComponent(UIText, seasonStartTime_path)
    self.seasonStartTimeN:SetLocalText(372114)
end

local function ComponentDestroy(self)
    self.title1N = nil
    self.title3N = nil
    self.seasonImgN = nil
    self.closeBtnN = nil
    self.tipN = nil
    self.infoBtnN = nil
    self.infoBtnTxtN = nil
end


local function DataDefine(self)
    self.seasonIndex = 2
end

local function DataDestroy(self)
    self.seasonIndex = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function InitData(self)
    self.seasonIndex = DataCenter.SeasonDataManager:GetSeasonId()
    self.seasonIndex = self.seasonIndex + 1
    
    self:RefreshAll()
end

local function RefreshAll(self)
    local iconImg = GetTableData(TableName.APS_Season,self.seasonIndex, 'icon')
    if iconImg then
        self.seasonImgN:LoadSprite(string.format("Assets/Main/Sprites/UI/UISeasonRobots/%s.png", iconImg))
    end
    local bgImg = GetTableData(TableName.APS_Season,self.seasonIndex, 'bg')
    if bgImg then
        self.bgImgN:LoadSprite(string.format("Assets/Main/TextureEx/UIActivity/%s.png", bgImg))
    end

    local seasonName = GetTableData(TableName.APS_Season,self.seasonIndex, 'subTitle')
    if string.IsNullOrEmpty(seasonName) then
        self.title3N:SetText("")
    else
        self.title3N:SetLocalText(seasonName)
    end
end

local function OnClickCloseBtn(self)
    self.ctrl:CloseSelf()
end

local function OnClickInfoBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonIntro, { anim = true })
end

local function OnClickHeroBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UISeasonHeroPreview,{anim = false,UIMainAnim = UIMainAnimType.AllHide})
end

UISeasonNewWorldView.OnCreate = OnCreate
UISeasonNewWorldView.OnDestroy = OnDestroy
UISeasonNewWorldView.OnEnable = OnEnable
UISeasonNewWorldView.OnDisable = OnDisable
UISeasonNewWorldView.ComponentDefine = ComponentDefine
UISeasonNewWorldView.ComponentDestroy = ComponentDestroy
UISeasonNewWorldView.DataDefine = DataDefine
UISeasonNewWorldView.DataDestroy = DataDestroy

UISeasonNewWorldView.InitData = InitData
UISeasonNewWorldView.RefreshAll = RefreshAll
UISeasonNewWorldView.OnClickHeroBtn = OnClickHeroBtn
UISeasonNewWorldView.OnClickCloseBtn = OnClickCloseBtn
UISeasonNewWorldView.OnClickInfoBtn = OnClickInfoBtn

return UISeasonNewWorldView