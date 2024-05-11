local UIAllianceCompeteMainView = BaseClass("UIAllianceCompeteMainView", UIBaseView)
local base = UIBaseView

local Localization = CS.GameEntry.Localization
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"
local AllianceFlagItem = require "UI.UIAlliance.UIAllianceFlag.Component.AllianceFlagItem"

local AllianceBatState =
{
    None = 0,
    --预告阶段
    PreOpenState = 1,
    --活动准备中
    Ready = 2,
    --活动开始中 
    Start = 3,
    --活动结算中
    Finish = 4,
    --活动开始中退盟时
    StartOut = 5,
};

local safeArea_path = "safeArea"
local redAllianceName_path = "safeArea/middleLayer/startGo/redGo/redAllianceGo/redAllianceNameTxt"
local ScoreTitle_path = "safeArea/middleLayer/startGo/middleGo/Image1/ScoreTitleTxt"
local redScoreNumTxt_path = "safeArea/middleLayer/startGo/redGo/redScoreGo/redScoreNumTxt"
local WinTitle_path = "safeArea/middleLayer/startGo/middleGo/Image2/WinTitleTxt"
local redWinNum_path = "safeArea/middleLayer/startGo/redGo/winGo/redWinNumTxt"
local MvpTitle_path = "safeArea/middleLayer/startGo/middleGo/Image3/MvpTitleTxt"
local redMvpNum_path = "safeArea/middleLayer/startGo/redGo/mvpGo/redMvpNumTxt"
local redMvpImg_path = "safeArea/middleLayer/startGo/redGo/mvpGo/redMvpBtn/RedHeadIcon"
local redMvpHeadBg_path = "safeArea/middleLayer/startGo/redGo/mvpGo/redMvpBtn/RedForeground"
local blueAllianceNameTxt_path = "safeArea/middleLayer/startGo/blueGo/blueAllianceGo/blueAllianceNameTxt"
--local blueScoreTitleTxt_path = "safeArea/middleLayer/startGo/blueGo/blueScoreGo/blueScoreTitleTxt"
local blueScoreNumTxt_path = "safeArea/middleLayer/startGo/blueGo/blueScoreGo/blueScoreNumTxt"
--local blueWinTitleTxt_path = "safeArea/middleLayer/startGo/blueGo/winGo/blueWinTitleTxt"
local blueWinNumTxt_path = "safeArea/middleLayer/startGo/blueGo/winGo/blueWinNumTxt"
local blueMvpImg_path = "safeArea/middleLayer/startGo/blueGo/mvpGo/blueMvpBtn/BlueHeadIcon"
local blueMvpHeadBg_path = "safeArea/middleLayer/startGo/blueGo/mvpGo/blueMvpBtn/BlueForeground"
local titleTxt_path = "safeArea/middleLayer/startGo/middleGo/titleTxt"
local desTxt_path = "safeArea/middleLayer/startGo/middleGo/desTxt"
local closeBtn_path = "safeArea1/topLeftLayer/closeBtn"
local infoBtn_path = "safeArea/rightLayer/infoBtn"
local rankBtn_path = "safeArea/rightLayer/rankEffectGo/rankBtn"
local rankBtnTxt_path = "safeArea/rightLayer/rankEffectGo/rankBtn/rankTxt"
local rewardBtn_path = "safeArea/rightLayer/rewardEffectGo/rewardBtn"
local rewardBtnTxt_path = "safeArea/rightLayer/rewardEffectGo/rewardBtn/rewawdTxt"
local viewBtn_path = "safeArea/rightLayer/viewEffectGo/viewBtn"
local viewBtnTxt_path = "safeArea/rightLayer/viewEffectGo/viewBtn/viewTxt"
--local blueMvpTitleTxt_path = "safeArea/middleLayer/startGo/blueGo/mvpGo/blueMvpTitleTxt"
local blueMvpNumTxt_path = "safeArea/middleLayer/startGo/blueGo/mvpGo/blueMvpNumTxt"
local redAllianceIcon_path = "safeArea/middleLayer/startGo/redGo/redAllianceIcon"
local blueAllianceIcon_path = "safeArea/middleLayer/startGo/blueGo/blueAllianceIcon"
local blueMvpBtn_path = "safeArea/middleLayer/startGo/blueGo/mvpGo/blueMvpBtn"
local redMvpBtn_path = "safeArea/middleLayer/startGo/redGo/mvpGo/redMvpBtn"
local redRatTxt_path = "safeArea/middleLayer/startGo/middleGo/progressGo/redRatTxt"
local blueTatTxt_path = "safeArea/middleLayer/startGo/middleGo/progressGo/blueTatTxt"
local slider_path = "safeArea/middleLayer/startGo/middleGo/progressGo/mask/redSlider"
local readyGo_path = "safeArea/middleLayer/readyGo"
local weekResultState_path = "safeArea/middleLayer/readyGo/weekResultState"
local readyState1_path = "safeArea/middleLayer/readyGo/readyState1"
local readyState2_path = "safeArea/middleLayer/readyGo/readyState2"
local seasonResultState_path = "safeArea/middleLayer/readyGo/seasonResultState"
local bottomContainer_path = "safeArea/bottomLayer"
local trial1Txt_path = "safeArea/bottomLayer/bottomGo/layout/trial1Txt"
local getBtn_path = "safeArea/bottomLayer/bottomGo/layout/getGo/getBtn"
local trial2Txt_path = "safeArea/bottomLayer/bottomGo/layout/trial2Txt"
local getTxt_path = "safeArea/bottomLayer/bottomGo/layout/getGo/getBtn/getTxt"
local cross_effect_path = "safeArea/rightLayer/crossGo/effect"
local crossBtn_path = "safeArea/rightLayer/crossGo/crossBtn"
local crossTxt_path = "safeArea/rightLayer/crossGo/crossBtn/crossTxt"
local ready1Title_path = "safeArea/middleLayer/readyGo/readyState1/ready1Title"
local ready1Desc_path = "safeArea/middleLayer/readyGo/readyState1/ready1Desc"
local ready2Title_path = "safeArea/middleLayer/readyGo/readyState2/ready2Title"
local ready2Desc1_path = "safeArea/middleLayer/readyGo/readyState2/ready2Desc1"
local ready2Cd_path = "safeArea/middleLayer/readyGo/readyState2/ready2Go/ready2Cd"
local ready2Desc2_path = "safeArea/middleLayer/readyGo/readyState2/ready2Desc2"
local infoDesc_path = "safeArea/rightLayer/infoBtn/infoPanel/Root/infoPanelbg/infoDesc"
local infoBgBtn_path = "safeArea/rightLayer/infoBtn/infoPanel/infoBgBtn"
local weekResultTitle_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultTitle"
local weekResultAllianceName_path = "safeArea/middleLayer/readyGo/weekResultState/Text_num"
local weekResultIcon_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultIcon"
local weekResultScoreTxt_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultName/weekResultScoreText"
local weekResultScore_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultName/weekResultScore"
local weekResultWin_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultName/weekResultWin"
local weekResultWinTxt_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultName/weekResultWinText"
local weekResultMvpName_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultName/weekResultMvpName"
local weekResultMvpNameTxt_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultName/weekResultMvpNameText"
local weekResultMvpImg_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultBtn/UIPlayerHead/HeadIcon"
local weekResultName_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultName"
local weekResultBtn_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultBtn/UIPlayerHead"
local weekResultContainer_path = "safeArea/middleLayer/readyGo/weekResultStateNew"
local weekResultAlNameL_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/alL/alNameL"
local weekResultAlNameR_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/alR/alNameR"
local weekResultAlScoreL_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/alL/ScoreL"
local weekResultAlScoreR_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/alR/ScoreR"
local weekResultMvpBtn_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/weekResultVip/GameObject/UIPlayerHead"
local weekResultMvpHeadIcon_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/weekResultVip/GameObject/UIPlayerHead/HeadIcon"
local weekResultMvpNameTxt_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/weekResultVip/weekResultMvpName"
local weekResultMvpIcon_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/weekResultVip/mvpIcon"
local weekResultMvpMask_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/weekResultVip/mvpMask"
local weekResultIconImg_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/weekResultVip/mvpIcon/resultIcon"
local weekResultTip_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/weekResultTip1"
local weekResultTip2_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/info/weekResultTip2"
local weekResultAnim_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim"
local weekResultBigIconBg_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/bigResultImgBg"
local weekResultBigIcon_path = "safeArea/middleLayer/readyGo/weekResultStateNew/offset/anim/bigResultImgBg/bigResultImg"
local bottomInfoBgBtn_path = "safeArea/bottomLayer/bottomGo/layout/bottomInfo/bottomInfoBgBtn"
local getGo_path = "safeArea/bottomLayer/bottomGo/layout/getGo"
local blueSliderGo_path = "safeArea/middleLayer/startGo/middleGo/progressGo/mask/blueSlider"
local get2Go_path = "safeArea/bottomLayer/bottomGo/layout/get2Go"
local get2Txt_path = "safeArea/bottomLayer/bottomGo/layout/get2Go/get2Btn/get2Txt"
local get2Btn_path = "safeArea/bottomLayer/bottomGo/layout/get2Go/get2Btn"
local blueSlider_path = "safeArea/middleLayer/startGo/middleGo/progressGo/mask/blueSlider"
local startGo_path = "safeArea/middleLayer/startGo"
local redRatEffect_path = "safeArea/middleLayer/startGo/middleGo/progressGo/redRatEffect" 
local blueRatEffect_path = "safeArea/middleLayer/startGo/middleGo/progressGo/blueRatEffect"
local weekResultCd_path = "safeArea/middleLayer/readyGo/weekResultState/weekResultGo/weekResultCd"
local ready1Cd_path = "safeArea/middleLayer/readyGo/readyState1/ready1Go/ready1Cd"
local cdTxt_path = "safeArea/middleLayer/startGo/middleGo/timeTxt/cdTxt"
local infoPanel_path = "safeArea/rightLayer/infoBtn/infoPanel"
local redWinBtn_path = "safeArea/middleLayer/startGo/redGo/winGo/redWinBtn"
local blueWinBtn_path = "safeArea/middleLayer/startGo/blueGo/winGo/blueWinBtn"
local redScoreBtn_path = "safeArea/middleLayer/startGo/redGo/redScoreGo/redScoreBtn"
local blueScoreBtn_path = "safeArea/middleLayer/startGo/blueGo/blueScoreGo/blueScoreBtn"
local redFlag_path = "safeArea/middleLayer/startGo/redGo/redAllianceIcon/AllianceFlagRed"
local blueFlag_path = "safeArea/middleLayer/startGo/blueGo/blueAllianceIcon/AllianceFlagBlue"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()

    self.safeArea:SetActive(false)
    self:Init()
    local actInfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if actInfo then
        SFSNetwork.SendMessage(MsgDefines.ActivityEventInfoGet,tostring(actInfo.activityId))
    end
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.safeArea = self:AddComponent(UIBaseContainer, safeArea_path)
    self.redAllianceName = self:AddComponent(UIText, redAllianceName_path)
    self.ScoreTitle = self:AddComponent(UIText, ScoreTitle_path)
    self.redScoreNumTxt = self:AddComponent(UIText, redScoreNumTxt_path)
    self.WinTitle = self:AddComponent(UIText, WinTitle_path)
    self.redWinNum = self:AddComponent(UIText, redWinNum_path)
    self.MvpTitle = self:AddComponent(UIText, MvpTitle_path)
    self.redMvpNum = self:AddComponent(UIText, redMvpNum_path)
    self.redMvpImg = self:AddComponent(UIPlayerHead, redMvpImg_path)
    self.redMvpHeadBg = self:AddComponent(UIImage, redMvpHeadBg_path)
    self.blueAllianceNameTxt = self:AddComponent(UIText, blueAllianceNameTxt_path)
    --self.blueScoreTitleTxt = self:AddComponent(UIText, blueScoreTitleTxt_path)
    self.blueScoreNumTxt = self:AddComponent(UIText, blueScoreNumTxt_path)
    --self.blueWinTitleTxt = self:AddComponent(UIText, blueWinTitleTxt_path)
    self.blueWinNumTxt = self:AddComponent(UIText, blueWinNumTxt_path)
    self.blueMvpImg = self:AddComponent(UIPlayerHead, blueMvpImg_path)
    self.blueMvpHeadBg = self:AddComponent(UIImage, blueMvpHeadBg_path)
    self.titleTxt = self:AddComponent(UIText, titleTxt_path)
    self.desTxt = self:AddComponent(UIText, desTxt_path)
    self.closeBtn = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoBtnClick()
    end)
    self.rankBtnTxtN = self:AddComponent(UIText, rankBtnTxt_path)
    self.rankBtnTxtN:SetLocalText(361055)
    self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
    self.rankBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickRankBtn()
    end)
    self.rewardBtnTxtN = self:AddComponent(UIText, rewardBtnTxt_path)
    self.rewardBtnTxtN:SetLocalText(361012)
    self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
    self.rewardBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickRewardBtn()
    end)
    self.viewBtnTxtN = self:AddComponent(UIText, viewBtnTxt_path)
    self.viewBtnTxtN:SetLocalText(361011)
    self.viewBtn = self:AddComponent(UIButton, viewBtn_path)
    self.viewBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickScheduleBtn()
    end)
    --self.blueMvpTitleTxt = self:AddComponent(UIText, blueMvpTitleTxt_path)
    self.blueMvpNumTxt = self:AddComponent(UIText, blueMvpNumTxt_path)
    self.redAllianceIcon = self:AddComponent(UIImage, redAllianceIcon_path)
    self.blueAllianceIcon = self:AddComponent(UIImage, blueAllianceIcon_path)
    self.blueMvpBtn = self:AddComponent(UIButton, blueMvpBtn_path)
    self.blueMvpBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBlueMvpBtn()
    end)
    self.redMvpBtn = self:AddComponent(UIButton, redMvpBtn_path)
    self.redMvpBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickRedMvpBtn()
    end)
    self.redRatTxt = self:AddComponent(UIText, redRatTxt_path)
    self.blueTatTxt = self:AddComponent(UIText, blueTatTxt_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.readyGo = self:AddComponent(UIBaseContainer, readyGo_path)
    --self.weekResultState = self:AddComponent(UIBaseContainer, weekResultState_path)
    self.readyState1 = self:AddComponent(UIBaseContainer, readyState1_path)
    self.readyState2 = self:AddComponent(UIBaseContainer, readyState2_path)
    self.seasonResultState = self:AddComponent(UIBaseContainer, seasonResultState_path)
    self.bottomContainer = self:AddComponent(UIBaseContainer, bottomContainer_path)
    self.trial1Txt = self:AddComponent(UIText, trial1Txt_path)
    self.getBtn = self:AddComponent(UIButton, getBtn_path)
    self.getBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickGetBtn()
    end)
    self.trial2Txt = self:AddComponent(UIText, trial2Txt_path)
    self.getTxt = self:AddComponent(UIText, getTxt_path)
    self.cross_effect = self:AddComponent(UIBaseContainer, cross_effect_path)
    self.cross_effect:SetActive(false)
    self.crossBtn = self:AddComponent(UIButton, crossBtn_path)
    self.crossBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickCrossBtn()
    end)
    self.crossTxt = self:AddComponent(UIText, crossTxt_path)
    self.ready1Title = self:AddComponent(UIText, ready1Title_path)
    self.ready1Desc = self:AddComponent(UIText, ready1Desc_path)
    self.ready2Title = self:AddComponent(UIText, ready2Title_path)
    self.ready2Desc1 = self:AddComponent(UIText, ready2Desc1_path)
    self.ready2Cd = self:AddComponent(UIText, ready2Cd_path)
    self.ready2Desc2 = self:AddComponent(UIText, ready2Desc2_path)
    self.infoDesc = self:AddComponent(UIText, infoDesc_path)
    self.infoBgBtn = self:AddComponent(UIButton, infoBgBtn_path)
    self.infoBgBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoBgBtnClick()
    end)
    --self.weekResultTitle = self:AddComponent(UIText, weekResultTitle_path)
    --self.weekResultAlName = self:AddComponent(UIText, weekResultAllianceName_path)
    --self.weekResultIcon = self:AddComponent(UIImage, weekResultIcon_path)
    --self.weekResultScore = self:AddComponent(UIText, weekResultScore_path)
    --self.weekResultWin = self:AddComponent(UIText, weekResultWin_path)
    --self.weekResultMvpName = self:AddComponent(UIText, weekResultMvpName_path)
    --self.weekResultMvpImg = self:AddComponent(UIPlayerHead, weekResultMvpImg_path)
    --self.weekResultName = self:AddComponent(UIText, weekResultName_path)
    --self.weekResultBtn = self:AddComponent(UIButton, weekResultBtn_path)
    --self.weekResultBtn:SetOnClick(function()
    --    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteRank, { anim = true })
    --end)
    self.bottomInfoBgBtn = self:AddComponent(UIButton, bottomInfoBgBtn_path)
    self.bottomInfoBgBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBottomInfoBtn()
    end)
    self.getGo = self:AddComponent(UIBaseContainer, getGo_path)
    self.blueSliderGo = self:AddComponent(UIBaseContainer, blueSliderGo_path)
    self.get2Go = self:AddComponent(UIBaseContainer, get2Go_path)
    self.get2Txt = self:AddComponent(UIText, get2Txt_path)
    self.get2Btn = self:AddComponent(UIButton, get2Btn_path)
    self.get2Btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickGet2Btn()
    end)
    self.blueSlider = self:AddComponent(UISlider, blueSlider_path)
    self.startGo = self:AddComponent(UIBaseContainer, startGo_path)
    self.redRatEffect = self:AddComponent(UIImage, redRatEffect_path)
    self.blueRatEffect = self:AddComponent(UIImage, blueRatEffect_path)
    self.weekResultCd = self:AddComponent(UIText, weekResultCd_path)
    self.cdTxt = self:AddComponent(UIText, cdTxt_path)
    self.ready1Cd = self:AddComponent(UIText, ready1Cd_path)
    self.infoPanel = self:AddComponent(UIBaseContainer, infoPanel_path)

    self.redWinBtn = self:AddComponent(UIButton, redWinBtn_path)
    self.redWinBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickRedWinBtn()
    end)
    self.blueWinBtn = self:AddComponent(UIButton, blueWinBtn_path)
    self.blueWinBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBlueWinBtn()
    end)
    self.redScoreBtn = self:AddComponent(UIButton, redScoreBtn_path)
    self.redScoreBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickRedScoreBtn()
    end)
    self.blueScoreBtn = self:AddComponent(UIButton, blueScoreBtn_path)
    self.blueScoreBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBlueScoreBtn()
    end)
    self.weekResultContainer = self:AddComponent(UIBaseContainer, weekResultContainer_path)
    self.weekResultAlNameL = self:AddComponent(UIText, weekResultAlNameL_path)
    self.weekResultAlNameR = self:AddComponent(UIText, weekResultAlNameR_path)
    self.weekResultAlScoreL = self:AddComponent(UIText, weekResultAlScoreL_path)
    self.weekResultAlScoreR = self:AddComponent(UIText, weekResultAlScoreR_path)
    self.weekResultMvpBtn = self:AddComponent(UIButton, weekResultMvpBtn_path)
    self.weekResultMvpBtn:SetOnClick(function()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteRank, { anim = true })
    end)
    self.weekResultMvpHeadIcon = self:AddComponent(UIPlayerHead, weekResultMvpHeadIcon_path)
    self.weekResultMvpNameTxt = self:AddComponent(UIText, weekResultMvpNameTxt_path)
    self.weekResultMvpMask = self:AddComponent(UIImage, weekResultMvpMask_path)
    self.weekResultMvpIcon = self:AddComponent(UIImage, weekResultMvpIcon_path)
    self.weekResultIconImg = self:AddComponent(UIImage, weekResultIconImg_path)
    self.weekResultTip = self:AddComponent(UIText, weekResultTip_path)
    self.weekResultTip2 = self:AddComponent(UIText, weekResultTip2_path)
    self.weekResultAnim = self:AddComponent(UIAnimator, weekResultAnim_path)
    self.weekResultBigIcon = self:AddComponent(UIImage, weekResultBigIcon_path)
    self.weekResultBigIconBg = self:AddComponent(UIImage, weekResultBigIconBg_path)
    
    self.redFlagN = self:AddComponent(AllianceFlagItem, redFlag_path)
    self.blueFlagN = self:AddComponent(AllianceFlagItem, blueFlag_path)
end

local function ComponentDestroy(self)
    self.redAllianceName = nil
    self.ScoreTitle = nil
    self.redScoreNumTxt = nil
    self.WinTitle = nil
    self.redWinNum = nil
    self.MvpTitle = nil
    self.redMvpNum = nil
    self.redMvpImg = nil
    self.blueAllianceNameTxt = nil
    --self.blueScoreTitleTxt = nil
    self.blueScoreNumTxt = nil
    --self.blueWinTitleTxt = nil
    self.blueWinNumTxt = nil
    self.blueMvpImg = nil
    self.titleTxt = nil
    self.desTxt = nil
    self.closeBtn = nil
    self.infoBtn = nil
    self.rankBtn = nil
    self.rewardBtn = nil
    self.viewBtn = nil
    --self.blueMvpTitleTxt = nil
    self.blueMvpNumTxt = nil
    self.redAllianceIcon = nil
    self.blueAllianceIcon = nil
    self.blueMvpBtn = nil
    self.redMvpBtn = nil
    self.redRatTxt = nil
    self.blueTatTxt = nil
    self.slider = nil
    self.readyGo = nil
    --self.weekResultState = nil
    self.readyState1 = nil
    self.readyState2 = nil
    self.seasonResultState = nil
    self.trial1Txt = nil
    self.getBtn = nil
    self.trial2Txt = nil
    self.getTxt = nil
    self.winBtn = nil
    self.ready1Title = nil
    self.ready1Desc = nil
    self.ready2Title = nil
    self.ready2Desc1 = nil
    self.ready2Cd = nil
    self.ready2Desc2 = nil
    self.infoDesc = nil
    self.infoBgBtn = nil
    self.weekResultTitle = nil
    self.weekResultAlName = nil
    self.weekResultIcon = nil
    self.weekResultScore = nil
    self.weekResultWin = nil
    self.weekResultMvpName = nil
    self.weekResultMvpImg = nil
    self.weekResultName = nil
    self.weekResultBtn = nil
    self.bottomInfoBgBtn = nil
    self.getGo = nil
    self.blueSliderGo = nil
    self.get2Go = nil
    self.get2Txt = nil
    self.get2Btn = nil
    self.blueSlider = nil
    self.weekResultCd = nil
end


local function DataDefine(self)
    
end

local function DataDestroy(self)
    --EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource)
    self.showTime = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.Nofity_Alliance_Battle_Week_Rusult_VS, self.RefreshWeekResultVSData)
    self:AddUIListener(EventId.RefreshAllianceArmsUI, self.Init)
    self:AddUIListener(EventId.OnUpdateActivityEventData, self.Init)
    self:AddUIListener(EventId.ShowCrossEffect,self.ShowCrossEffect)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.Nofity_Alliance_Battle_Week_Rusult_VS, self.RefreshWeekResultVSData)
    self:RemoveUIListener(EventId.RefreshAllianceArmsUI, self.Init)
    self:RemoveUIListener(EventId.OnUpdateActivityEventData, self.Init)
    self:RemoveUIListener(EventId.ShowCrossEffect,self.ShowCrossEffect)
end

local function ShowCrossEffect(self)
    self.cross_effect:SetActive(true)
end
local function Init(self)
    self:TextLocalization()
    self.allianceinfo = DataCenter.ActivityListDataManager:GetActivityDataById(EnumActivity.AllianceCompete.ActId)
    if self.allianceinfo ~= nil and self.allianceinfo.finish ~= nil then
        --printInfo("联盟对决进入周日结算阶段，请求结算数据")
        SFSNetwork.SendMessage(MsgDefines.AllianceCompeteWeekResult)
        return
    end
    self.safeArea:SetActive(true)

    if self.allianceinfo.preOpenTime ~= nil then
        --预告阶段
        self.state = AllianceBatState.PreOpenState
        self:RefreshReadyState()
        --self:RefreshTime()
        return
    end
    self.eventInfo = self.allianceinfo:GetEventInfo()
    if self.eventInfo == nil then
        --printInfo("未获取积分类活动的eventInfo")
        return
    end
    --当前联盟对决活动状态
    self.state = AllianceBatState.None
    self:Refersh()
    --self:RefreshTime()
end

local function TextLocalization(self)
    self.ScoreTitle:SetLocalText(361029) 
    self.WinTitle:SetLocalText(361018) 
    self.MvpTitle:SetLocalText(361003)
    self.crossTxt:SetLocalText(143584)
    --self.blueScoreTitleTxt:SetText(Localization:GetString("361029"))
    --self.blueWinTitleTxt:SetText(Localization:GetString("361018"))
    --self.blueMvpTitleTxt:SetText(Localization:GetString("361003"))

    self.titleTxt:SetLocalText(361000) 
    local infoStr = Localization:GetString("361059").."\n\n"..Localization:GetString("361034").."\n\n"..Localization:GetString("361035").."\n\n"..Localization:GetString("361060")
    self.infoDesc:SetText(infoStr)
    --ready1
    self.ready1Title:SetLocalText(361000) 
    self.ready1Desc:SetLocalText(361062) 
    --ready2
    self.ready2Title:SetLocalText(361000) 
    -- self.ready2Desc1:SetLocalText(当前没有联盟，请加入联盟) 
    --确认任何状态下不显示此字段
    self.ready2Desc1.gameObject:SetActive(false)
    self.ready2Desc2:SetLocalText(361006) 
    self.ready2Cd:SetLocalText() 
    --self.weekResultTitle:SetLocalText(361000) 
end

local function Refersh(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()-- CSLuaInterfaceCommon.GetServerTime()
    local endTime = self.eventInfo.weekEndTime
    local startTime = self.allianceinfo.startTime
    local readyTime = self.allianceinfo.readyTime
    local preOpenTime = self.allianceinfo.preOpenTime
    if readyTime <= curTime and endTime> 0 then
        if startTime > curTime then
            --准备阶段    
            self.state = AllianceBatState.Ready

            self:RefreshOpenState()
        elseif endTime < curTime then
            --结束--不会走到这个阶段
            --endTime<curTime不会同步
            self.state = AllianceBatState.None
        else
            --开启阶段
            self.state = AllianceBatState.Start
            self:RefreshOpenState()
        end
    end
end

local function RefreshOpenState(self)
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    local myAllianceId = LuaEntry.Player:GetAllianceUid()
    if not hasAlliance or myAllianceId == nil then
        --活动中退盟，显示状态与预告阶段一样，但刷新时间和底部文字描述不同
        --printInfo("自己的联盟id=nil, 没有加入联盟=myAllianceId="..myAllianceId)
        self.state = AllianceBatState.StartOut
        self:RefreshReadyState()
        return
    end
    -- printInfo("a自己的联盟id=nil, 没有加入联盟=myAllianceId="..myAllianceId)	
    if self.eventInfo == nil or self.eventInfo.vsAllianceList == nil then
        --printInfo("联盟对决同步数据vsAllianceList=nil")
        --有联盟，但所在联盟条件不足不能参加
        self.state = AllianceBatState.StartOut
        self:RefreshReadyState()
        return
    end

    self:SetLeftBtnState(true)
    self:ShowState(3 , false)
    --bottom部分刷新
    self.bottomContainer:SetActive(true)
    self.bottomInfoBgBtn.gameObject:SetActive(false)
    self.trial2Txt.gameObject:SetActive(false)
    self.trial1Txt.gameObject:SetActive(false)
    self.getGo:SetActive(false)
    self.get2Go:SetActive(true)
    self.trial1Txt:SetLocalText(361004) 
    self.get2Txt:SetLocalText(361005) 

    local myScore , otherScore = 0 , 0
    local allianceList = self.eventInfo.vsAllianceList
    table.walk(allianceList , function(k,v)
        local name = string.format("#%s [%s] %s" , v.serverId, v.abbr,v.alName)
        local winTimes = (v.winScore == 0 or v.winScore == nil) and "0" or v.winScore
        if k == myAllianceId then
            self.redAllianceName:SetText(name)
            --local lastAlScore = self:GetAllianceBattleLastAlScore("red")
            self.redScoreNumTxt:SetText(string.GetFormattedSeperatorNum(v.alScore))
            -- printInfo("1打印出来效果值="..lastAlScore)
            self.redWinNum:SetText(winTimes)
            self.redFlagN:SetData(v.icon)
            --CSSetSpriteOfImage(self.redAllianceIcon, AtlasAssets.AllianceFlag, v.icon)
            if v.mvpPlayer == nil then
                self.redMvpNum:SetLocalText(140042) 
                self.redMvpBtn.gameObject:SetActive(false)
            else
                self.redMvpNum:SetText(v.mvpPlayer.name)
                self.redMvpImg:SetData(v.mvpPlayer.uid, v.mvpPlayer.pic, v.mvpPlayer.picVer)
                
                local tempFg = v.mvpPlayer:GetHeadBgImg()
                if tempFg then
                    self.redMvpHeadBg:SetActive(true)
                else
                    self.redMvpHeadBg:SetActive(false)
                end
                --self.redMvpImg:LoadSprite("Assets/Main/Sprites/UI/UIHeadIcon/" .. v.mvpPlayer.pic, DefaultUserHead)
                --CSLoadHeadEx(v.mvpPlayer.uid , v.mvpPlayer.pic, v.mvpPlayer.picVer, self.redMvpImg)
                self.redMvpBtn.gameObject:SetActive(true)
            end
            myScore = tonumber(v.alScore)
        else
            self.blueAllianceNameTxt:SetText(name)
            --local lastAlScore =  self:GetAllianceBattleLastAlScore("blue")
            self.blueScoreNumTxt:SetText(string.GetFormattedSeperatorNum(v.alScore))
            self.blueWinNumTxt:SetText(winTimes)
            self.blueFlagN:SetData(v.icon)
            --CSSetSpriteOfImage(self.blueAllianceIcon, AtlasAssets.AllianceFlag, v.icon)
            if v.mvpPlayer == nil then
                self.blueMvpNumTxt:SetLocalText(140042) 
                self.blueMvpBtn.gameObject:SetActive(false)
            else
                self.blueMvpNumTxt:SetText(v.mvpPlayer.name)
                --self.blueMvpImg:LoadSprite("Assets/Main/Sprites/UI/UIHeadIcon/" .. v.mvpPlayer.pic, DefaultUserHead)
                self.blueMvpImg:SetData(v.mvpPlayer.uid, v.mvpPlayer.pic, v.mvpPlayer.picVer)

                local tempFg = v.mvpPlayer:GetHeadBgImg()
                if tempFg then
                    self.blueMvpHeadBg:SetActive(true)
                else
                    self.blueMvpHeadBg:SetActive(false)
                end
                --CSLoadHeadEx(v.mvpPlayer.uid , v.mvpPlayer.pic, v.mvpPlayer.picVer, self.blueMvpImg)
                self.blueMvpBtn.gameObject:SetActive(true)
            end
            otherScore = tonumber(v.alScore)
        end
    end)
    local rate = 0
    self.desTxt:SetLocalText(361033,  Localization:GetString(self.allianceinfo.activityName)) 
    --local lastRate = self:GetAllianceBattleLastRate()
    local myRateScore = myScore
    if myScore < 0 then
        myRateScore = 0
    end
    local otherRateScore = otherScore
    if otherScore < 0 then
        otherRateScore = 0
    end
    if myRateScore == otherRateScore then
        rate = 0.5
        self.slider:SetValue(rate)
        self.redRatTxt:SetText("50%")
        self.blueTatTxt:SetText("50%")
    else
        local total = myRateScore + otherRateScore
        rate = tonumber(myRateScore/total)
        self.slider:SetValue(rate)
        local redRate = math.floor(rate*100+0.5)
        local blueRate = math.floor((1-rate)*100+0.5)
        self.redRatTxt:SetText(redRate .. "%")
        self.blueTatTxt:SetText(blueRate .. "%")
    end

    --if self.redRatEffect then
    --    self.redRatEffect.fillAmount = lastRate
    --    self.blueRatEffect.fillAmount = 1 - rate
    --end
    --
    --if self.slider and self.slider.gameObject then
    --    self.slider.gameObject:SetActive(true)
    --    self.blueSliderGo:SetActive(true)
    --    self.redRatEffect.gameObject:SetActive(false)
    --    self.blueRatEffect.gameObject:SetActive(false)
    --    self.slider.value = lastRate
    --    self.blueSlider.value = 1 - lastRate
    --end
    -- printInfo("打印出来=="..rate..",myscore="..myScore..",total="..(myScore + otherScore))
--[[
    self.invokeParam1 = Invoke:DelayCall(function()
        if self.redRatEffect == nil then
            return
        end
        CSLuaInterfaceCommon.DoTweenFloatTo(0, lastRate, 0.5, function(x)
            self.redRatEffect.fillAmount = x
        end, function(x) end)
        local blueRate = 1- rate
        CSLuaInterfaceCommon.DoTweenFloatTo(0, blueRate, 0.5, function(x)
            self.blueRatEffect.fillAmount = x
        end, function(x) end)
    end, 0.56)
    self.invokeParam2 = Invoke:DelayCall(function()
        if self.slider == nil or self.slider.gameObject == nil then
            return
        end
        self.slider.gameObject:SetActive(true)
        self.blueSliderGo:SetActive(true)
        self.effect_ui_LFAllianceBattleActView_004:SetActive(true)
        self.redRatEffect.gameObject:SetActive(false)
        self.blueRatEffect.gameObject:SetActive(false)

        self.slider.value = lastRate
        self.blueSlider.value = 1 - lastRate
    end, 1)
    self.invokeParam3 = Invoke:DelayCall(function()
        if self.slider == nil or self.slider.gameObject == nil then
            return
        end
        self:SetAllianceBattleLastRate(rate)
        local fromValue = lastRate
        local toValue = rate
        -- printInfo("打印进度显示="..fromValue..",tovalue="..toValue..",lastRate="..lastRate..",rate="..rate)
        CSLuaInterfaceCommon.DoTweenFloatTo(fromValue, toValue , 1, function(x)
            self.slider.value = x
        end, function(x) end)
        CSLuaInterfaceCommon.DoTweenFloatTo(1-fromValue, 1-toValue , 1, function(x)
            self.blueSlider.value = x
        end, function(x) end)
        -- printInfo("2打印出来效果值="..myScore..",otherScore="..otherScore)
        self:SetAlScroeEffect("red" , myScore)
        self:SetAlScroeEffect("blue" , otherScore)
    end, 1.6)
--]]
end

local function RefreshReadyState(self)
    self:SetLeftBtnState(false)
    self.startGo:SetActive(false)
    self.readyGo:SetActive(true)
    if self.state == AllianceBatState.Ready then
        self.ready1Desc:SetLocalText(361062) 
    elseif self.state == AllianceBatState.Start or self.state == AllianceBatState.StartOut then
        self.ready1Desc:SetLocalText(361073) 
    end
    if LuaEntry.Player:IsInAlliance() then
        -- printInfo("联盟myAllianceId="..myAllianceId)
        --有联盟		
        self:ShowState(1 , true)
        self.trial2Txt.gameObject:SetActive(true)
        self.trial1Txt.gameObject:SetActive(false)

        -- self.getBtn.gameObject:SetActive(false)
        self.getGo:SetActive(false)
        self.get2Go:SetActive(false)
        if self.eventInfo ~= nil and self.eventInfo.vsAllianceList == nil then--活动已开始有联盟但未匹配上
            self.trial2Txt:SetLocalText(361075) 
        else
            self.trial2Txt:SetLocalText(361063) 
        end
    else
        -- printInfo("联盟myAllianceId=无联盟")
        --无联盟
        self:ShowState(1 , false)
        self.trial2Txt.gameObject:SetActive(false)
        self.trial1Txt.gameObject:SetActive(true)

        self.getGo:SetActive(true)
        self.get2Go:SetActive(false)
        self.trial1Txt:SetLocalText(361007) 
        self.getTxt:SetLocalText(110037) 
    end
    self.bottomInfoBgBtn.gameObject:SetActive(true)
end

local function SetLeftBtnState(self, state)
    self.rankBtn.gameObject:SetActive(state)
    self.rewardBtn.gameObject:SetActive(state)
    self.viewBtn.gameObject:SetActive(state)
    --没有赛季，不显示赛季按钮
    if CrossServerUtil:CanPlaceCrossSubway() then
        self.crossBtn:SetActive(state)
    else
        self.crossBtn:SetActive(false)
    end
end

local function RefreshWeekResultVSData(self)
    self.safeArea:SetActive(true)
    self.state = AllianceBatState.Finish
    --self:RefreshFinishState()
    self:RefreshFinishStateNew()
    --self:RefreshTime()
end

local function RefreshFinishStateNew(self)
    self:ShowState(2, false)
    local data = DataCenter.AllianceCompeteDataManager:GetVSAllianceList()
    if not data then
        return
    end
    local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local hasAlliance = LuaEntry.Player:IsInAlliance()
    local myAllianceId = LuaEntry.Player.allianceId
    if hasAlliance then
        local otherAlName = ""
        table.walk(data, function(k, v)
            local name = string.format("#%s [%s] %s" , v.serverId, v.abbr,v.alName)
            local winTimes = (v.winScore == 0 or v.winScore == null) and "0" or v.winScore
            if k == myAllianceId then
                self.weekResultAlNameL:SetText(name)
                self.weekResultAlScoreL:SetText(winTimes)--v.alScore)
            else
                otherAlName = v.alName
                self.weekResultAlNameR:SetText(name)
                self.weekResultAlScoreR:SetText(winTimes)--v.alScore)
            end
        end)

        local mvpPlayer = DataCenter.AllianceCompeteDataManager.vsAllianceList_mvpPlayer
        if mvpPlayer == nil then
            self.weekResultMvpNameTxt:SetLocalText(140042)
            self.weekResultMvpHeadIcon:SetActive(false)
        else
            self.weekResultMvpNameTxt:SetText(mvpPlayer.name)
            self.weekResultMvpHeadIcon:SetData(mvpPlayer.uid, mvpPlayer.pic, mvpPlayer.picVer)
            --CSSetSpriteOfImage(self.weekResultMvpImg, AtlasAssets.PlayerHead, mvpPlayer.pic)
            self.weekResultMvpHeadIcon:SetActive(true)
        end

        local isWin = DataCenter.AllianceCompeteDataManager.vsAllianceList_isWin
        if isWin ~= nil then
            if isWin == 1 then
                self.weekResultIconImg:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/UI_img_AllianceShowdown_win_small")
                self.weekResultMvpMask:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/UI_AllianceShowdown_img_mvpwin_bg")
                self.weekResultMvpIcon:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/imag_Alliance Showdown_mvpwin")
                self.weekResultBigIcon:LoadSprite("Assets/Main/TextureEx/UIActivity/UI_img_AllianceShowdown_win.png")
                self.weekResultBigIconBg:LoadSprite("Assets/Main/TextureEx/UIActivity/UI_img_AllianceShowdown_win_light.png")
                self.weekResultTip:SetLocalText(361064)
                self.weekResultTip2:SetLocalText(372168)
            else
                self.weekResultIconImg:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/UI_img_AllianceShowdown_defeat_small")
                self.weekResultMvpMask:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/UI_AllianceShowdown_img_mvpdefeat_bg")
                self.weekResultMvpIcon:LoadSprite("Assets/Main/Sprites/UI/UIAllianceCompete/imag_Alliance Showdown_mvpdefeat")
                self.weekResultBigIcon:LoadSprite("Assets/Main/TextureEx/UIActivity/UI_img_AllianceShowdown_defeat.png")
                self.weekResultBigIconBg:LoadSprite("Assets/Main/TextureEx/UIActivity/UI_img_AllianceShowdown_defeat_light.png")
                self.weekResultTip:SetLocalText(361065)
                self.weekResultTip2:SetLocalText(372167)
            end
        end
    end
    
    local serverT = UITimeManager:GetInstance():GetServerTime()
    local strToday = UITimeManager:GetInstance():TimeStampToDayForLocal(serverT)
    local strKey = "AlCompeteResult_" .. LuaEntry.Player.uid .. "_" .. strToday
    local isFirstEnter = CS.GameEntry.Setting:GetInt(strKey, 0)
    if isFirstEnter == 0 then
        self.weekResultAnim:Play("AlCompeteResult", 0, 0)
        CS.GameEntry.Setting:SetInt(strKey, 1)
        EventManager:GetInstance():Broadcast(EventId.FirstPayStatusChange)
    end

    self.bottomContainer:SetActive(false)
    self:SetLeftBtnState(false)
end

local function RefreshFinishState(self)
    self:ShowState(2 , false)
    local data = DataCenter.AllianceCompeteDataManager:GetVSAllianceList()
    if data == nil then
        --printInfo("请求的周结果数据没有")
        return
    end
    local allianceBase = DataCenter.AllianceBaseDataManager:GetAllianceBaseData()
    local myAllianceId =  allianceBase.uid
    if myAllianceId ~= nil and myAllianceId ~= "" then
        table.walk(data , function(k,v)
            local name = string.format("#%s [%s] %s" , v.serverId, v.abbr,v.alName)
            local alScore = tonumber(v.alScore)
            local symbol = ""
            if alScore < 0 then
                symbol = "-"
                alScore = math.abs(alScore)
            end
            local score = v.alScore
            local winTimes = (v.winScore == 0 or v.winScore == nil) and "-" or v.winScore

            local scoreStr = symbol..string.GetFormattedSeperatorNum(score)
            if k == myAllianceId then
                self.weekResultName:SetText(name)
                self.weekResultScore:SetText(scoreStr)
                 self.weekResultWin:SetText(winTimes)
                --CSSetSpriteOfImage(self.weekResultIcon, AtlasAssets.AllianceFlag, v.icon)
            end
        end)
    end
    local mvpPlayer = DataCenter.AllianceCompeteDataManager.vsAllianceList_mvpPlayer
    if mvpPlayer == nil then
        self.redMvpNum:SetLocalText(140042) 
        self.weekResultBtn.gameObject:SetActive(false)
    else
        self.weekResultMvpName:SetText(mvpPlayer.name)
        self.weekResultMvpImg:SetData(mvpPlayer.uid, mvpPlayer.pic, mvpPlayer.picVer)
        --CSSetSpriteOfImage(self.weekResultMvpImg, AtlasAssets.PlayerHead, mvpPlayer.pic)
        self.weekResultBtn.gameObject:SetActive(true)
    end
    self.trial1Txt.gameObject:SetActive(false)
    self.trial2Txt.gameObject:SetActive(true)
    self.getGo:SetActive(false)
    self.get2Go:SetActive(false)
    local isWin = DataCenter.AllianceCompeteDataManager.vsAllianceList_isWin
    if isWin ~= nil then
        if isWin == 1 then
            self.trial2Txt:SetLocalText(361064) 
        else
            self.trial2Txt:SetLocalText(361065) 
        end
    end
    self:SetLeftBtnState(false)
end

local function ShowState(self, state , hasAlliance)
    if state == 1 then
        if hasAlliance then
            self.readyState1:SetActive(true)
            self.readyState2:SetActive(false)
        else
            self.readyState1:SetActive(false)
            self.readyState2:SetActive(true)
        end
        self.readyGo:SetActive(true)
        --self.weekResultState:SetActive(false)
        self.weekResultContainer:SetActive(false)
        self.seasonResultState:SetActive(false)
        self.startGo:SetActive(false)
    elseif state == 2 then
        self.readyGo:SetActive(true)
        self.readyState1:SetActive(false)
        self.readyState2:SetActive(false)
        --self.weekResultState:SetActive(true)
        self.weekResultContainer:SetActive(true)
        self.seasonResultState:SetActive(false)
        self.startGo:SetActive(false)
    elseif  state == 3 then
        self.readyGo:SetActive(false)
        self.readyState1:SetActive(false)
        self.readyState2:SetActive(false)
        --self.weekResultState:SetActive(false)
        self.weekResultContainer:SetActive(false)
        self.seasonResultState:SetActive(false)
        self.startGo:SetActive(true)
    end
end

local function Update(self)
    self:RefreshTime()
end

local function RefreshTime(self)
    if self.eventInfo == nil then
        return
    end
    
    local curTime = UITimeManager:GetInstance():GetServerTime()-- CSLuaInterfaceCommon.GetServerTime()
    --结算阶段
    if self.state == AllianceBatState.Finish then
        local finishTime = DataCenter.AllianceCompeteDataManager:GetFinishTime()-- AllianceBattleActManager.vsAllianceList_finishTime
        if finishTime ~= nil then
            local leftTime = finishTime - curTime
            self.weekResultCd:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
            return
        end
    end
    --预告阶段
    if self.allianceinfo ~= nil and self.allianceinfo.preOpenTime ~= nil then
        local preOpenTime = self.allianceinfo.preOpenTime
        local leftTime = preOpenTime - curTime
		local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
        self.ready1Cd:SetText(leftTimeStr)
        self.ready2Cd:SetText(leftTimeStr)
        return
    end

    if self.allianceinfo == nil then
        self.cdTxt:SetText("")
        return;
    end

    local endTime = self.allianceinfo.endTime
    if self.eventInfo ~= nil then
        endTime = self.eventInfo.weekEndTime
    end

    local startTime = self.allianceinfo.startTime
    local readyTime = self.allianceinfo.readyTime
    local leftTime = endTime - curTime 
    --printInfo("a*************"..startTime..",endTime="..endTime..",readyTime="..readyTime..",curTime="..curTime..",leftTime="..leftTime)
    if startTime < curTime and leftTime > 0 then--活动已开启
		local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
        self.cdTxt:SetText(leftTimeStr)
        self.weekResultCd:SetText(leftTimeStr)
        self.ready1Cd:SetText(leftTimeStr)
        self.ready2Cd:SetText(leftTimeStr)
    elseif startTime > curTime and (curTime > readyTime) then--活动准备中		
        local leftTime = endTime - curTime
		local leftTimeStr = UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)
        if self.state == AllianceBatState.PreOpenState or self.state == AllianceBatState.StartOut then
            self.ready1Cd:SetText(leftTimeStr)
            self.ready2Cd:SetText(leftTimeStr)
        else
            self.cdTxt:SetText(leftTimeStr)
        end
    else--活动结束
        self.cdTxt:SetLocalText(370100)
    end
end

local function SetAllianceBattleLastRate(self, rate)
    return 0.5
    --GameEntry.Setting:SetPrivateFloat("LFAllianceBattleActView_LastRate", rate);
end
---@return number
local function GetAllianceBattleLastRate(self)
    return 0.5
    --return GameEntry.Setting:GetPrivateFloat("LFAllianceBattleActView_LastRate", 0);
end
---
local function SetAllianceBattleLastAlScore(self, type, scoreStr)
    return 0.5
    --GameEntry.Setting:SetPrivateString("LFAllianceBattleActView_LastAlScore_"..type, scoreStr);
end
--
local function GetAllianceBattleLastAlScore(self, type)
    return 0.5--MK
    --return GameEntry.Setting:GetPrivateString("LFAllianceBattleActView_LastAlScore_"..type, "-");
end


local function OnInfoBtnClick(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.infoBtn.transform.position + Vector3.New(-20, 0, 0) * scaleFactor
    local infoStr = Localization:GetString("361059").."\n\n"..Localization:GetString("361034").."\n\n"..Localization:GetString("361035").."\n\n"..Localization:GetString("361060")
    
    local param = UIHeroTipView.Param.New()
    param.content = infoStr
    param.dir = UIHeroTipView.Direction.LEFT
    param.defWidth = 400
    param.pivot = 0.86
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
    
    --self.infoPanel:SetActive(true)
end

local function OnInfoBgBtnClick(self)
    self.infoPanel:SetActive(false)
end

local function OnClickRedMvpBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteRank, { anim = true })
end

local function OnClickBlueMvpBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteRank, { anim = true })
end

local function OnClickRankBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteRank, { anim = true })
end

local function OnClickRewardBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteReward, { anim = true })
end

local function OnClickScheduleBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceCompeteSchedule, { anim = true })
end

local function OnClickGetBtn(self)
    if self.state == AllianceBatState.PreOpenState then
        self.ctrl:CloseSelf()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
        
    elseif self.state == AllianceBatState.StartOut then
        self.ctrl:CloseSelf()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAllianceIntro,{ anim = true,isBlur = true})
        
    elseif self.state == AllianceBatState.Ready or self.state == AllianceBatState.Start then
        self.ctrl:CloseSelf()
        
    end
end

local function OnClickBottomInfoBtn(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.bottomInfoBgBtn.transform.position + Vector3.New(0, 20, 0) * scaleFactor

    local k2Str = LuaEntry.DataConfig:TryGetStr("alliance_legend", "k2")
    local k1 = LuaEntry.DataConfig:TryGetStr("alliance_legend", "k1")
    local keys = {}
    local k1List = {}
    if k1 ~= nil then
        k1List = string.split(k1, ";")
    end
    local k1_1 = string.GetFormattedSeperatorNum(k1List[1])
    local k1_2 = string.GetFormattedSeperatorNum(tostring(k1List[2]))
    local k2 = string.GetFormattedSeperatorNum(tostring(k2Str))
    local content = Localization:GetString("361076").."\n\n"..Localization:GetString("361077",k1_1,k1_2).."\n\n"..Localization:GetString("361078",k2).."\n\n"..Localization:GetString("361079")
    
    local param = UIHeroTipView.Param.New()
    param.content = content
    --param.title = "helloworld"
    param.dir = UIHeroTipView.Direction.ABOVE
    param.defWidth = 300
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnClickRedWinBtn(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.redWinBtn.transform.position + Vector3.New(70, 0, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.title = Localization:GetString("361018")
    param.content = Localization:GetString("361067")
    param.dir = UIHeroTipView.Direction.RIGHT
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnClickBlueWinBtn(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.blueWinBtn.transform.position + Vector3.New(-70, 0, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.title = Localization:GetString("361018")
    param.content = Localization:GetString("361067")
    param.dir = UIHeroTipView.Direction.LEFT
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnClickRedScoreBtn(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.redScoreBtn.transform.position + Vector3.New(70, 0, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.title = Localization:GetString("361029")
    param.content = Localization:GetString("361068")
    param.dir = UIHeroTipView.Direction.RIGHT
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnClickBlueScoreBtn(self)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.blueScoreBtn.transform.position + Vector3.New(-70, 0, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.title = Localization:GetString("361029")
    param.content = Localization:GetString("361068")
    param.dir = UIHeroTipView.Direction.LEFT
    param.defWidth = 180
    param.pivot = 0.5
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

local function OnClickGet2Btn(self)
    --self.ctrl:CloseSelf()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityCenterTable, { anim = true, UIMainAnim = UIMainAnimType.AllHide }, tonumber(EnumActivity.AllianceCompete.ActId))-- self.allianceinfo.activityId)
end

local function OnClickCrossBtn(self)
    self.cross_effect:SetActive(false)
    local fightServerId = DataCenter.AllianceCompeteDataManager:GetFightServerId()
    if fightServerId>0 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlCompeteTips,fightServerId)
    end
end

UIAllianceCompeteMainView.OnCreate = OnCreate
UIAllianceCompeteMainView.OnCreate = OnCreate
UIAllianceCompeteMainView.OnDestroy = OnDestroy
UIAllianceCompeteMainView.OnEnable = OnEnable
UIAllianceCompeteMainView.OnDisable = OnDisable
UIAllianceCompeteMainView.ComponentDefine = ComponentDefine
UIAllianceCompeteMainView.ComponentDestroy = ComponentDestroy
UIAllianceCompeteMainView.DataDefine = DataDefine
UIAllianceCompeteMainView.DataDestroy = DataDestroy
UIAllianceCompeteMainView.OnAddListener = OnAddListener
UIAllianceCompeteMainView.OnRemoveListener = OnRemoveListener

UIAllianceCompeteMainView.Init = Init
UIAllianceCompeteMainView.Refersh = Refersh
UIAllianceCompeteMainView.RefreshReadyState = RefreshReadyState
UIAllianceCompeteMainView.RefreshOpenState = RefreshOpenState
UIAllianceCompeteMainView.RefreshWeekResultVSData = RefreshWeekResultVSData
UIAllianceCompeteMainView.RefreshFinishState = RefreshFinishState
UIAllianceCompeteMainView.RefreshFinishStateNew = RefreshFinishStateNew
UIAllianceCompeteMainView.SetLeftBtnState = SetLeftBtnState
UIAllianceCompeteMainView.ShowState = ShowState
UIAllianceCompeteMainView.SetAllianceBattleLastRate = SetAllianceBattleLastRate
UIAllianceCompeteMainView.GetAllianceBattleLastRate = GetAllianceBattleLastRate
UIAllianceCompeteMainView.SetAllianceBattleLastAlScore = SetAllianceBattleLastAlScore
UIAllianceCompeteMainView.GetAllianceBattleLastAlScore = GetAllianceBattleLastAlScore
UIAllianceCompeteMainView.TextLocalization = TextLocalization
UIAllianceCompeteMainView.RefreshTime = RefreshTime
UIAllianceCompeteMainView.Update = Update
UIAllianceCompeteMainView.OnInfoBtnClick = OnInfoBtnClick
UIAllianceCompeteMainView.OnInfoBgBtnClick = OnInfoBgBtnClick
UIAllianceCompeteMainView.OnClickRedMvpBtn = OnClickRedMvpBtn
UIAllianceCompeteMainView.OnClickBlueMvpBtn = OnClickBlueMvpBtn
UIAllianceCompeteMainView.OnClickRankBtn = OnClickRankBtn
UIAllianceCompeteMainView.OnClickRewardBtn = OnClickRewardBtn
UIAllianceCompeteMainView.OnClickScheduleBtn = OnClickScheduleBtn
UIAllianceCompeteMainView.OnClickGetBtn = OnClickGetBtn
UIAllianceCompeteMainView.OnClickBottomInfoBtn = OnClickBottomInfoBtn
UIAllianceCompeteMainView.OnClickRedWinBtn = OnClickRedWinBtn
UIAllianceCompeteMainView.OnClickBlueWinBtn = OnClickBlueWinBtn
UIAllianceCompeteMainView.OnClickRedScoreBtn = OnClickRedScoreBtn
UIAllianceCompeteMainView.OnClickBlueScoreBtn = OnClickBlueScoreBtn
UIAllianceCompeteMainView.OnClickGet2Btn = OnClickGet2Btn
UIAllianceCompeteMainView.OnClickCrossBtn = OnClickCrossBtn
UIAllianceCompeteMainView.ShowCrossEffect = ShowCrossEffect
return UIAllianceCompeteMainView