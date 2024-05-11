
local ChampionBattleItem_signUp = BaseClass("ChampionBattleItem_signUp", UIBaseContainer)
local M = ChampionBattleItem_signUp
local base = UIBaseContainer
local UIHeroEtoileList = require "UI.UIHero2.Common.UIHeroEtoileList"

local title_text_path = "Group_singupGo/titleTxt"
local des1_text_path = "Group_singupGo/descTxt"

local overTrans_path = "Group_singupGo/overTrans"
local overTrans_text_path = "Group_singupGo/overTrans/overTxt"

local signUpBtn_path = "Group_singupGo/signUpBtn"
local signUpBtn_text_path = "Group_singupGo/signUpBtn/signUpTxt"
local signUpBtn_cd_text_path = "Group_singupGo/signUpBtn/cdTxt"

local teamGroupGo_path = "Group_singupGo/teamGroupGo"
local signUpSucessGo_path = "Group_singupGo/teamGroupGo/signUpSucessGo"
local signUpSucessGo_text_path = "Group_singupGo/teamGroupGo/signUpSucessGo/hasSignUpTxt"
local explainTxt2_text_path = "Group_singupGo/teamGroupGo/explainTxt2"

local team1_path = "Group_singupGo/teamGroupGo/team1Btn"
local quality1_path = "Group_singupGo/teamGroupGo/team1Btn/imgQuality1"
local imgQualityfg1_path = "Group_singupGo/teamGroupGo/team1Btn/imgQualityfg1"
local icon1_path = "Group_singupGo/teamGroupGo/team1Btn/iconMask/imgIcon1"
local addImg1_path = "Group_singupGo/teamGroupGo/team1Btn/addImg1"
local teamNameTxt1_path = "Group_singupGo/teamGroupGo/team1Btn/textName1"
local lock1_path = "Group_singupGo/teamGroupGo/team1Btn/lock1"
local lv1_path = "Group_singupGo/teamGroupGo/team1Btn/LVBg1"
local lv1_text_path = "Group_singupGo/teamGroupGo/team1Btn/LVBg1/textLevel1"
local StarBox1_path = "Group_singupGo/teamGroupGo/team1Btn/UIHeroEtoileList1"
local ImgRank1_path = "Group_singupGo/teamGroupGo/team1Btn/ImgRank1"
local imgCamp1_path = "Group_singupGo/teamGroupGo/team1Btn/imgCamp1"

local team2_path = "Group_singupGo/teamGroupGo/team2Btn"
local quality2_path = "Group_singupGo/teamGroupGo/team2Btn/imgQuality2"
local imgQualityfg2_path = "Group_singupGo/teamGroupGo/team2Btn/imgQualityfg2"
local icon2_path = "Group_singupGo/teamGroupGo/team2Btn/iconMask/imgIcon2"
local addImg2_path = "Group_singupGo/teamGroupGo/team2Btn/addImg2"
local teamNameTxt2_path = "Group_singupGo/teamGroupGo/team2Btn/textName2"
local lock2_path = "Group_singupGo/teamGroupGo/team2Btn/lock2"
local lv2_path = "Group_singupGo/teamGroupGo/team2Btn/LVBg2"
local lv2_text_path = "Group_singupGo/teamGroupGo/team2Btn/LVBg2/textLevel2"
local StarBox2_path = "Group_singupGo/teamGroupGo/team2Btn/UIHeroEtoileList2"
local ImgRank2_path = "Group_singupGo/teamGroupGo/team2Btn/ImgRank2"
local imgCamp2_path = "Group_singupGo/teamGroupGo/team2Btn/imgCamp2"

local team3_path = "Group_singupGo/teamGroupGo/team3Btn"
local quality3_path = "Group_singupGo/teamGroupGo/team3Btn/imgQuality3"
local imgQualityfg3_path = "Group_singupGo/teamGroupGo/team3Btn/imgQualityfg3"
local icon3_path = "Group_singupGo/teamGroupGo/team3Btn/iconMask/imgIcon3"
local addImg3_path = "Group_singupGo/teamGroupGo/team3Btn/addImg3"
local teamNameTxt3_path = "Group_singupGo/teamGroupGo/team3Btn/textName3"
local lock3_path = "Group_singupGo/teamGroupGo/team3Btn/lock3"
local lv3_path = "Group_singupGo/teamGroupGo/team3Btn/LVBg3"
local lv3_text_path = "Group_singupGo/teamGroupGo/team3Btn/LVBg3/textLevel3"
local StarBox3_path = "Group_singupGo/teamGroupGo/team3Btn/UIHeroEtoileList3"
local ImgRank3_path = "Group_singupGo/teamGroupGo/team3Btn/ImgRank3"
local imgCamp3_path = "Group_singupGo/teamGroupGo/team3Btn/imgCamp3"

local singupNumTxt_text_path = "Group_singupGo/singupNumTxt"
local server1Txt_text_path = "Group_singupGo/serverTxt1"
local server2Txt_text_path = "Group_singupGo/serverTxt2"

local default_hed_bg = "Assets/Main/Sprites/UI/UIChampion/UIchampion_img_heroaddbg.png"

function M:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function M:ComponentDefine()
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.title_text:SetLocalText(302022)
    self.des1_text = self:AddComponent(UITextMeshProUGUIEx, des1_text_path)
    self.des1_text:SetLocalText(302023)

    self.overTrans = self:AddComponent(UIBaseContainer, overTrans_path)
    self.overTrans_text = self:AddComponent(UIText, overTrans_text_path)

    self.signUpBtn = self:AddComponent(UIButton, signUpBtn_path)
    self.signUpBtn_text = self:AddComponent(UIText, signUpBtn_text_path)
    self.signUpBtn_text:SetLocalText(302024)
    
    self.signUpBtn_cd_text = self:AddComponent(UIText, signUpBtn_cd_text_path)

    self.teamGroupGo = self:AddComponent(UIBaseContainer, teamGroupGo_path)
    self.signUpSucessGo = self:AddComponent(UIBaseContainer, signUpSucessGo_path)
    self.signUpSucessGo_text = self:AddComponent(UITextMeshProUGUIEx, signUpSucessGo_text_path)
    self.signUpSucessGo_text:SetLocalText(302036)
    self.explainTxt2_text = self:AddComponent(UITextMeshProUGUIEx, explainTxt2_text_path)
    self.explainTxt2_text:SetLocalText(302025)
    
    self.singupNumTxt_text = self:AddComponent(UIText, singupNumTxt_text_path)
    self.serverTxt1_text = self:AddComponent(UIText, server1Txt_text_path)
    self.serverTxt2_text = self:AddComponent(UIText, server2Txt_text_path)

    self.team1 = self:AddComponent(UIButton, team1_path)
    self.quality1 = self:AddComponent(UIImage, quality1_path)
    self.qualityfg1 = self:AddComponent(UIImage,imgQualityfg1_path)
    self.icon1 = self:AddComponent(UIImage, icon1_path)
    self.addImg1 = self:AddComponent(UIImage, addImg1_path)
    self.teamNameTxt1 = self:AddComponent(UITextMeshProUGUIEx, teamNameTxt1_path)
    self.lock1 = self:AddComponent(UIImage, lock1_path)
    self.lv1 = self:AddComponent(UIBaseContainer, lv1_path)
    self.lv1_text = self:AddComponent(UITextMeshProUGUIEx, lv1_text_path)
    self.StarBox1 = self:AddComponent(UIHeroEtoileList, StarBox1_path)
    self.ImgRank1 = self:AddComponent(UIImage, ImgRank1_path)
    self.imgCamp1 = self:AddComponent(UIImage, imgCamp1_path)

    self.team2 = self:AddComponent(UIButton, team2_path)
    self.quality2 = self:AddComponent(UIImage, quality2_path)
    self.qualityfg2 = self:AddComponent(UIImage,imgQualityfg2_path)
    self.icon2 = self:AddComponent(UIImage, icon2_path)
    self.addImg2 = self:AddComponent(UIImage, addImg2_path)
    self.teamNameTxt2 = self:AddComponent(UITextMeshProUGUIEx, teamNameTxt2_path)
    self.lock2 = self:AddComponent(UIImage, lock2_path)
    self.lv2 = self:AddComponent(UIBaseContainer, lv2_path)
    self.lv2_text = self:AddComponent(UITextMeshProUGUIEx, lv2_text_path)
    self.StarBox2 = self:AddComponent(UIHeroEtoileList, StarBox2_path)
    self.ImgRank2 = self:AddComponent(UIImage, ImgRank2_path)
    self.imgCamp2 = self:AddComponent(UIImage, imgCamp2_path)

    self.team3 = self:AddComponent(UIButton, team3_path)
    self.quality3 = self:AddComponent(UIImage, quality3_path)
    self.qualityfg3 = self:AddComponent(UIImage,imgQualityfg3_path)
    self.icon3 = self:AddComponent(UIImage, icon3_path)
    self.addImg3 = self:AddComponent(UIImage, addImg3_path)
    self.teamNameTxt3 = self:AddComponent(UITextMeshProUGUIEx, teamNameTxt3_path)
    self.lock3 = self:AddComponent(UIImage, lock3_path)
    self.lv3 = self:AddComponent(UIBaseContainer, lv3_path)
    self.lv3_text = self:AddComponent(UITextMeshProUGUIEx, lv3_text_path)
    self.StarBox3 = self:AddComponent(UIHeroEtoileList, StarBox3_path)
    self.ImgRank3 = self:AddComponent(UIImage, ImgRank3_path)
    self.imgCamp3 = self:AddComponent(UIImage, imgCamp3_path)

    self.teamNameTxt1:SetLocalText(302032)
    self.teamNameTxt2:SetLocalText(302033)
    self.teamNameTxt3:SetLocalText(302034)
    
    -- 注册控件事件
    self:RegisterUIEvent()
end

function M:DataDefine()

end

function M:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function M:ComponentDestroy()
    self:StopTimer()
    self:UnregisterUIEvent()
end

function M:DataDestroy()

end

-- 控件事件
function M:RegisterUIEvent()
    self.signUpBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:onClick_signUpBtn()
    end)
    self:AddUIListener(EventId.OnUpdateTeamDataEvent, self.OnRefreshTeam)
    self.team1:SetOnClick(function()
        local isOpen = DataCenter.ActChampionBattleManager:GetFormationIsOpen(1)
        if isOpen then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleFormation, 1)
        end
    end)

    self.team2:SetOnClick(function()
        local isOpen = DataCenter.ActChampionBattleManager:GetFormationIsOpen(2)
        if isOpen then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleFormation, 2)
        end
    end)

    self.team3:SetOnClick(function()
        local isOpen = DataCenter.ActChampionBattleManager:GetFormationIsOpen(3)
        if isOpen then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleFormation, 3)
        end
    end)
end

function M:UnregisterUIEvent()
    self:RemoveUIListener(EventId.OnUpdateTeamDataEvent, self.OnRefreshTeam)
end

function M:RefreshServerTxt()
    if self.championBattleInfo ~= nil then
        local serverName1 = ""
        local serverName2 = ""
        if not string.IsNullOrEmpty(self.championBattleInfo.serverId1) then
            serverName1 = self.championBattleInfo.serverId1
        end
        if not string.IsNullOrEmpty(self.championBattleInfo.serverId2) then
            serverName2 = self.championBattleInfo.serverId2
        else
            serverName2 = serverName1
        end
        --self.serverTxt_text:SetLocalText(302305, serverName)
        self.serverTxt1_text:SetLocalText(208236, serverName1)
        self.serverTxt2_text:SetLocalText(208236, serverName2)
    else
        --self.serverTxt_text:SetText("")
        self.serverTxt1_text:SetText("")
        self.serverTxt2_text:SetText("")
    end
end

function M:SetData(info)
    self:StopTimer()
    self.championBattleInfo = info
    if self.championBattleInfo == nil then
        return
    end

    local maxSingUpNum = LuaEntry.DataConfig:TryGetStr("champ_battle", "k5")
    --maxSingUpNum = 100
    self.singupNumTxt_text:SetLocalText(302035, (self.championBattleInfo.currNum.."/"..maxSingUpNum))
    local curIndexState = self.championBattleInfo:GetCurState()
    if curIndexState == Activity_ChampionBattle_Stage_State.SingUp then
        local hasSingUp = self.championBattleInfo.hasSingUp
        if hasSingUp == 0 then
            self.signUpBtn:SetActive(true)
            self.overTrans:SetActive(false)
            self.teamGroupGo:SetActive(false)
        else
            if hasSingUp == 1 then
                self.teamGroupGo:SetActive(true)
                self.signUpSucessGo:SetActive(true)
                self.overTrans:SetActive(false)            
            elseif hasSingUp == -1 then
                self.overTrans_text:SetLocalText(302038)
                self.teamGroupGo:SetActive(false)
                self.signUpSucessGo:SetActive(false)
                self.overTrans:SetActive(true)            
            end            
            self.signUpBtn:SetActive(false)
        end
    else
        self.overTrans_text:SetLocalText(302037)
        self.signUpBtn:SetActive(false)
        self.overTrans:SetActive(true)
        self.teamGroupGo:SetActive(true)
    end
    if self.championBattleInfo.hasSingUp == 0 or self.championBattleInfo.hasSingUp == -1 or self.championBattleInfo.auditionsState == -1 or self.championBattleInfo.strongObsolete == true then
        self.teamGroupGo:SetActive(false)
        self.signUpSucessGo:SetActive(false)
    else
        self.teamGroupGo:SetActive(true)
        self.signUpSucessGo:SetActive(true)
    end
    --self.teamGroupGo:SetActive(true)

    self:RefreshTime()
    self:SetTeam()
    self:RefreshServerTxt()
end

function M:OnRefreshTeam()
    self:SetTeam()
end

function M:SetTeam()
    for i = 1, 3 do
        --local iconStr = GameEntry.Data.Team:GetFirstHeroHeadIcon(i)
        --local iconStr = DataCenter.ActChampionBattleManager:GetFormationHeroPic(i)
        local iconStr, lv, quality, rankIcon, campIcon, qualityIcon, rarity ,heroData = self.view.ctrl:GetHeroInfo(i)
        if iconStr == nil then 
            --没有编队
            self["addImg"..i]:SetActive(true)
            self["icon"..i]:SetActive(false)
            self["lv"..i]:SetActive(false)
            --self["StarBox"..i]:SetActive(false)
            self["StarBox"..i]:SetActive(false)

            self["ImgRank"..i]:SetActive(false)
            self["imgCamp"..i]:SetActive(false)
            self["quality"..i]:LoadSprite(default_hed_bg)
        else
            self["addImg"..i]:SetActive(false)
            self["icon"..i]:SetActive(true)
            self["lv"..i]:SetActive(true)
            self["StarBox"..i]:SetActive(true)
            --local param = {}
            --param.showStarNum = quality
            --param.maxStarNum = HeroUtils.GetMaxStarByRarity(rarity)
            local fgIcon = HeroUtils.GetRarityFgIconPath(rarity)
            self["qualityfg"..i]:LoadSprite(fgIcon)
            local curRankId = heroData:GetCurMilitaryRankId()
            self["StarBox"..i]:SetRankId(curRankId)

            self["ImgRank"..i]:SetActive(not string.IsNullOrEmpty(rankIcon))
            self["imgCamp"..i]:SetActive(true)

            self["icon"..i]:LoadSprite(iconStr)
            self["lv"..i.."_text"]:SetLocalText(300665, lv)
            --self["StarBox"..i.."_star1"]:SetActive(star >= 1)
            --self["StarBox"..i.."_star2"]:SetActive(star >= 2)
            --self["StarBox"..i.."_star3"]:SetActive(star >= 3)
            if not string.IsNullOrEmpty(rankIcon) then
                self["ImgRank"..i]:LoadSprite(rankIcon)
            end
            self["imgCamp"..i]:LoadSprite(campIcon)
            self["quality"..i]:LoadSprite(qualityIcon)
        end
        local isOpen = DataCenter.ActChampionBattleManager:GetFormationIsOpen(i)
        if isOpen == true then
            self["lock"..i]:SetActive(false)
        else
            self["lock"..i]:SetActive(true)
            self["addImg"..i]:SetActive(false)
            self["icon"..i]:SetActive(false)
        end
    end
end

--------------------------------------------------
function M:onClick_signUpBtn()
    DataCenter.ActChampionBattleManager:SendActChampionBattleSingUpCmd()
end

--------------------------------------------------

function M:RefreshTime()
    self:StopTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.OnTimer, self, false,false,false)
    end

    self.timer:Start()
    self:OnTimer()
end

function M:StopTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function M:OnTimer()
	if self.signUpBtn_cd_text == nil or self.championBattleInfo == nil then
		return
	end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.championBattleInfo.auditionsST
    if endTime > curTime then
        self.signUpBtn_cd_text:SetLocalText(302130, UITimeManager:GetInstance():MilliSecondToFmtString(endTime - curTime))
        self.signUpBtn_cd_text:SetActive(true)
    else
        self.signUpBtn_cd_text:SetActive(false)
        self:StopTimer()
    end
end

return M
