
local ChampionBattleItem_auditions = BaseClass("ChampionBattleItem_auditions", UIBaseContainer)
local M = ChampionBattleItem_auditions
local base = UIBaseContainer
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"

local Group_auditions_path = "Group_auditions"
local nextInfoTxt_path = "Group_auditions/nextInfoTxt"
local Localization  = CS.GameEntry.Localization

--Group_AgainstPlayers_path
local Group_AgainstPlayers_path = "Group_auditions/Group_AgainstPlayers"
local winTimesTxt_path = "Group_auditions/Group_AgainstPlayers/Image_GamesProcess/winTimesTxt"
local curRoundTxt_path = "Group_auditions/Group_AgainstPlayers/curRoundTxt"
local fail_btn_1_path = "Group_auditions/Group_AgainstPlayers/Image_GamesProcess/Text_Defeated/fail1Btn"
local fail_btn_1_session_path = "Group_auditions/Group_AgainstPlayers/Image_GamesProcess/Text_Defeated/fail1Btn/session1"
local fail_btn_2_path = "Group_auditions/Group_AgainstPlayers/Image_GamesProcess/Text_Defeated/fail2Btn"
local fail_btn_2_session_path = "Group_auditions/Group_AgainstPlayers/Image_GamesProcess/Text_Defeated/fail2Btn/session2"
local fail_btn_3_path = "Group_auditions/Group_AgainstPlayers/Image_GamesProcess/Text_Defeated/fail3Btn"
local fail_btn_3_session_path = "Group_auditions/Group_AgainstPlayers/Image_GamesProcess/Text_Defeated/fail3Btn/session3"

local player1_path = "Group_auditions/Group_AgainstPlayers/player1"
local player1_head_btn_path = "Group_auditions/Group_AgainstPlayers/player1/player1Head/UIPlayerHead1"
local player1_head_path = "Group_auditions/Group_AgainstPlayers/player1/player1Head/UIPlayerHead1/HeadIcon1"
local player1_head_Foreground_path = "Group_auditions/Group_AgainstPlayers/player1/player1Head/UIPlayerHead1/Foreground1"
local player1Server_path = "Group_auditions/Group_AgainstPlayers/player1/player1Server"
local player1Name_path = "Group_auditions/Group_AgainstPlayers/player1/player1Name"
local player1IntegralTitle_path = "Group_auditions/Group_AgainstPlayers/player1/player1IntegralTitle"
local player1Integral_path = "Group_auditions/Group_AgainstPlayers/player1/player1Integral"
local player1RankTitle_path = "Group_auditions/Group_AgainstPlayers/player1/player1RankTitle"
local player1Rank_path = "Group_auditions/Group_AgainstPlayers/player1/player1Rank"

local player2_path = "Group_auditions/Group_AgainstPlayers/player2"
local player2_head_btn_path = "Group_auditions/Group_AgainstPlayers/player2/Player2Head/UIPlayerHead2"
local player2_head_path = "Group_auditions/Group_AgainstPlayers/player2/Player2Head/UIPlayerHead2/HeadIcon2"
local player2_head_Foreground_path = "Group_auditions/Group_AgainstPlayers/player2/Player2Head/UIPlayerHead2/Foreground2"
local player2Server_path = "Group_auditions/Group_AgainstPlayers/player2/player2Server"
local player2Name_path = "Group_auditions/Group_AgainstPlayers/player2/player2Name"
local player2IntegralTitle_path = "Group_auditions/Group_AgainstPlayers/player2/player2IntegralTitle"
local player2Integral_path = "Group_auditions/Group_AgainstPlayers/player2/player2Integral"
local player2RankTitle_path = "Group_auditions/Group_AgainstPlayers/player2/player2RankTitle"
local player2Rank_path = "Group_auditions/Group_AgainstPlayers/player2/player2Rank"

local player_finish_path = "Group_auditions/Group_AgainstPlayers/playerFinish"
local playerFinish_head_btn_path = "Group_auditions/Group_AgainstPlayers/playerFinish/playerFinishHead/UIPlayerHeadFinish"
local playerFinish_head_path = "Group_auditions/Group_AgainstPlayers/playerFinish/playerFinishHead/UIPlayerHeadFinish/HeadIconFinish"
local playerFinish_head_Foreground_path = "Group_auditions/Group_AgainstPlayers/playerFinish/playerFinishHead/UIPlayerHeadFinish/ForegroundFinish"
local playerFinishServer_path = "Group_auditions/Group_AgainstPlayers/playerFinish/playerFinishServer"
local playerFinishName_path = "Group_auditions/Group_AgainstPlayers/playerFinish/playerFinishName"
local playerFinishIntegralTitle_path = "Group_auditions/Group_AgainstPlayers/playerFinish/playerFinishIntegralTitle"
local playerFinishIntegral_path = "Group_auditions/Group_AgainstPlayers/playerFinish/playerFinishIntegral"
local playerFinishRankTitle_path = "Group_auditions/Group_AgainstPlayers/playerFinish/playerFinishRankTitle"
local playerFinishRank_path = "Group_auditions/Group_AgainstPlayers/playerFinish/playerFinishRank"

--Group_Win_path
local Group_Win_path = "Group_auditions/Group_Win"
local playerIntegralTitle_path = "Group_auditions/Group_Win/playerIntegralTitle"
local playerIntegral_path = "Group_auditions/Group_Win/playerIntegral"
local playerRankTitle_path = "Group_auditions/Group_Win/playerRankTitle"
local playerRank_path = "Group_auditions/Group_Win/playerRank"
local Victory_Title_Txt_path = "Group_auditions/Group_Win/Image_Back/Victory_Title_Txt"
local VictoryTxt_path = "Group_auditions/Group_Win/VictoryTxt"
local RemainingTimes_path = "Group_auditions/Group_Win/RemainingTimes"
local win_player_head_btn_path = "Group_auditions/Group_Win/Image_PlayerBg/playerHead/UIPlayerHead_Win"

local win_player_head_path = "Group_auditions/Group_Win/Image_PlayerBg/playerHead/UIPlayerHead_Win/HeadIcon3"
local win_player_head_Foreground_path = "Group_auditions/Group_Win/Image_PlayerBg/playerHead/UIPlayerHead_Win/Foreground3"

local win_player_server_path = "Group_auditions/Group_Win/Image_PlayerBg/playerServer"
local win_player_name_path = "Group_auditions/Group_Win/Image_PlayerBg/playerName"

local win_btn_1_path = "Group_auditions/Group_Win/Text_Defeated/win_fail1Btn"
local win_btn_1_session_path = "Group_auditions/Group_Win/Text_Defeated/win_fail1Btn/win_session1"
local win_btn_2_path = "Group_auditions/Group_Win/Text_Defeated/win_fail2Btn"
local win_btn_2_session_path = "Group_auditions/Group_Win/Text_Defeated/win_fail2Btn/win_session2"
local win_btn_3_path = "Group_auditions/Group_Win/Text_Defeated/win_fail3Btn"
local win_btn_3_session_path = "Group_auditions/Group_Win/Text_Defeated/win_fail3Btn/win_session3"

--Group_Lose_path
local Group_Lose_path = "Group_auditions/Group_Lose"
local fail_playerIntegralTitle_path = "Group_auditions/Group_Lose/fail_playerIntegralTitle"
local fail_playerIntegral_path = "Group_auditions/Group_Lose/fail_playerIntegral"
local fail_playerRankTitle_path = "Group_auditions/Group_Lose/fail_playerRankTitle"
local fail_playerRank_path = "Group_auditions/Group_Lose/fail_playerRank"
local lose_Title_Txt_path = "Group_auditions/Group_Lose/Image_Bg/lose_Title_Txt"

local loseTxt_path = "Group_auditions/Group_Lose/loseTxt"
local fail_RemainingTimes_path = "Group_auditions/Group_Lose/fail_RemainingTimes"
local fail_player_head_btn_path = "Group_auditions/Group_Lose/Image_PlayerBg/fail_playerHead/UIPlayerHead_Fail"

local fail_player_head_path = "Group_auditions/Group_Lose/Image_PlayerBg/fail_playerHead/UIPlayerHead_Fail/HeadIcon4"
local fail_player_head_Foreground_path = "Group_auditions/Group_Lose/Image_PlayerBg/fail_playerHead/UIPlayerHead_Fail/Foreground4"

local fail_player_server_path = "Group_auditions/Group_Lose/Image_PlayerBg/fail_playerServer"
local fail_player_name_path = "Group_auditions/Group_Lose/Image_PlayerBg/fail_playerName"

local result_fail_btn_1_path = "Group_auditions/Group_Lose/Text_Defeated/fail_fail1Btn"
local result_fail_btn_1_session_path = "Group_auditions/Group_Lose/Text_Defeated/fail_fail1Btn/fail_session1"
local result_fail_btn_2_path = "Group_auditions/Group_Lose/Text_Defeated/fail_fail2Btn"
local result_fail_btn_2_session_path = "Group_auditions/Group_Lose/Text_Defeated/fail_fail2Btn/fail_session2"
local result_fail_btn_3_path = "Group_auditions/Group_Lose/Text_Defeated/fail_fail3Btn"
local result_fail_btn_3_session_path = "Group_auditions/Group_Lose/Text_Defeated/fail_fail3Btn/fail_session3"

--Group_SliderReward
local Group_SliderReward_path = "Group_auditions/Group_SliderReward"
local slider_path = "Group_auditions/Group_SliderReward/imageSliderBg"
local imageSlider_path = "Group_auditions/Group_SliderReward/imageSliderBg/imageSlider"
local sliderEffect_path = "Group_auditions/Group_SliderReward/imageSliderBg/imageSlider/sliderEffect"

--Group_explain
local Group_explain_path = "Group_explain"
local explainTxt1_path = "Group_explain/explainTxt1"
local explainTxt2_path = "Group_explain/explainTxt2"
local explainTxt3_path = "Group_explain/explainTxt3"

--
local vs_path = "Group_auditions/Group_AgainstPlayers/Group_VS"
local player_finish_text_path = "Group_auditions/Group_AgainstPlayers/Finish_Text"
--初始化面板--
function M:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function M:ComponentDefine()
    self.Group_auditions = self:AddComponent(UIBaseContainer, Group_auditions_path)
    self.nextInfoTxt = self:AddComponent(UIText, nextInfoTxt_path)
    
    --Group_AgainstPlayers_path
    self.Group_AgainstPlayers = self:AddComponent(UIBaseContainer, Group_AgainstPlayers_path)
    self.winTimesTxt = self:AddComponent(UIText, winTimesTxt_path)
    self.curRoundTxt = self:AddComponent(UITextMeshProUGUIEx, curRoundTxt_path)
    self.fail_btn_1 = self:AddComponent(UIButton, fail_btn_1_path)
    self.fail_btn_1_session = self:AddComponent(UIImage, fail_btn_1_session_path)
    self.fail_btn_2 = self:AddComponent(UIButton, fail_btn_2_path)
    self.fail_btn_2_session = self:AddComponent(UIImage, fail_btn_2_session_path)
    self.fail_btn_3 = self:AddComponent(UIButton, fail_btn_3_path)
    self.fail_btn_3_session = self:AddComponent(UIImage, fail_btn_3_session_path)

    self.player1 = self:AddComponent(UIBaseContainer, player1_path)
    self.player1_head = self:AddComponent(UIPlayerHead, player1_head_path)
    self.player1_head_Foreground = self:AddComponent(UIImage, player1_head_Foreground_path)
    self.player1Server = self:AddComponent(UITextMeshProUGUIEx, player1Server_path)
    self.player1Name = self:AddComponent(UITextMeshProUGUIEx, player1Name_path)
    self.player1IntegralTitle = self:AddComponent(UITextMeshProUGUIEx, player1IntegralTitle_path)
    self.player1IntegralTitle:SetLocalText(302042)
    self.player1Integral = self:AddComponent(UITextMeshProUGUIEx, player1Integral_path)
    self.player1RankTitle = self:AddComponent(UITextMeshProUGUIEx, player1RankTitle_path)
    self.player1RankTitle:SetLocalText(302043)
    self.player1Rank = self:AddComponent(UITextMeshProUGUIEx, player1Rank_path)

    self.player2 = self:AddComponent(UIBaseContainer, player2_path)
    self.player2_head_Foreground = self:AddComponent(UIImage, player2_head_Foreground_path)
    self.player2_head = self:AddComponent(UIPlayerHead, player2_head_path)

    self.player2Server = self:AddComponent(UITextMeshProUGUIEx, player2Server_path)
    self.player2Name = self:AddComponent(UITextMeshProUGUIEx, player2Name_path)
    self.player2IntegralTitle = self:AddComponent(UITextMeshProUGUIEx, player2IntegralTitle_path)
    self.player2IntegralTitle:SetLocalText(302042)
    self.player2Integral = self:AddComponent(UITextMeshProUGUIEx, player2Integral_path)
    self.player2RankTitle = self:AddComponent(UITextMeshProUGUIEx, player2RankTitle_path)
    self.player2RankTitle:SetLocalText(302043)
    self.player2Rank = self:AddComponent(UITextMeshProUGUIEx, player2Rank_path)

    self.vs = self:AddComponent(UIBaseContainer, vs_path)
    self.finish_text = self:AddComponent(UITextMeshProUGUIEx, player_finish_text_path)
    self.finish_text:SetLocalText(302725)
    self.playerFinish = self:AddComponent(UIBaseContainer, player_finish_path)
    self.playerFinish_head = self:AddComponent(UIPlayerHead, playerFinish_head_path)
    self.playerFinish_head_Foreground = self:AddComponent(UIImage, playerFinish_head_Foreground_path)
    self.playerFinishServer = self:AddComponent(UITextMeshProUGUIEx, playerFinishServer_path)
    self.playerFinishName = self:AddComponent(UITextMeshProUGUIEx, playerFinishName_path)
    self.playerFinishIntegralTitle = self:AddComponent(UITextMeshProUGUIEx, playerFinishIntegralTitle_path)
    self.playerFinishIntegralTitle:SetLocalText(302042)
    self.playerFinishIntegral = self:AddComponent(UITextMeshProUGUIEx, playerFinishIntegral_path)
    self.playerFinishRankTitle = self:AddComponent(UITextMeshProUGUIEx, playerFinishRankTitle_path)
    self.playerFinishRankTitle:SetLocalText(302043)
    self.playerFinishRank = self:AddComponent(UITextMeshProUGUIEx, playerFinishRank_path)

    --Group_Win_path
    self.Group_Win = self:AddComponent(UIBaseContainer, Group_Win_path)
    self.playerIntegralTitle = self:AddComponent(UITextMeshProUGUIEx, playerIntegralTitle_path)
    self.playerIntegralTitle:SetLocalText(302042)
    self.playerIntegral = self:AddComponent(UIText, playerIntegral_path)
    self.playerRankTitle = self:AddComponent(UIText, playerRankTitle_path)
    self.playerRankTitle:SetLocalText(302043)
    self.playerRank = self:AddComponent(UIText, playerRank_path)
    self.VictoryTxt = self:AddComponent(UIText, VictoryTxt_path)
    self.VictoryTxt:SetLocalText(302046)
    self.Victory_Title_Txt = self:AddComponent(UIText, Victory_Title_Txt_path)
    self.Victory_Title_Txt:SetLocalText(390186)
    self.RemainingTimes = self:AddComponent(UIText, RemainingTimes_path)

    self.win_player_head = self:AddComponent(UIPlayerHead, win_player_head_path)
    self.win_player_head_Foreground = self:AddComponent(UIImage, win_player_head_Foreground_path)
    self.win_player_server = self:AddComponent(UIText, win_player_server_path)
    self.win_player_name = self:AddComponent(UIText, win_player_name_path)

    self.win_btn_1 = self:AddComponent(UIButton, win_btn_1_path)
    self.win_btn_1_session = self:AddComponent(UIImage, win_btn_1_session_path)
    self.win_btn_2 = self:AddComponent(UIButton, win_btn_2_path)
    self.win_btn_2_session = self:AddComponent(UIImage, win_btn_2_session_path)
    self.win_btn_3 = self:AddComponent(UIButton, win_btn_3_path)
    self.win_btn_3_session = self:AddComponent(UIImage, win_btn_3_session_path)

    --Group_Lose_path
    self.Group_Lose = self:AddComponent(UIBaseContainer, Group_Lose_path)
    self.fail_playerIntegralTitle = self:AddComponent(UITextMeshProUGUIEx, fail_playerIntegralTitle_path)
    self.fail_playerIntegralTitle:SetLocalText(302042)
    self.fail_playerIntegral = self:AddComponent(UIText, fail_playerIntegral_path)
    self.fail_playerRankTitle = self:AddComponent(UIText, fail_playerRankTitle_path)
    self.fail_playerRankTitle:SetLocalText(302043)
    self.fail_playerRank = self:AddComponent(UIText, fail_playerRank_path)
    self.loseTxt = self:AddComponent(UIText, loseTxt_path)
    self.loseTxt:SetLocalText(302045)
    self.lose_Title_Txt = self:AddComponent(UIText, lose_Title_Txt_path)
    self.lose_Title_Txt:SetLocalText(390187)

    self.fail_RemainingTimes = self:AddComponent(UIText, fail_RemainingTimes_path)
    --self.fail_player_head = self:AddComponent(UIImage, fail_player_head_path)
    --self.fail_player_head_bg = self:AddComponent(UIImage, fail_player_head_bg_path)
    self.fail_player_head = self:AddComponent(UIPlayerHead, fail_player_head_path)
    self.fail_player_head_Foreground = self:AddComponent(UIImage, fail_player_head_Foreground_path)
    self.fail_player_server = self:AddComponent(UIText, fail_player_server_path)
    self.fail_player_name = self:AddComponent(UIText, fail_player_name_path)

    self.result_fail_btn_1 = self:AddComponent(UIButton, result_fail_btn_1_path)
    self.result_fail_btn_1_session = self:AddComponent(UIImage, result_fail_btn_1_session_path)
    self.result_fail_btn_2 = self:AddComponent(UIButton, result_fail_btn_2_path)
    self.result_fail_btn_2_session = self:AddComponent(UIImage, result_fail_btn_2_session_path)
    self.result_fail_btn_3 = self:AddComponent(UIButton, result_fail_btn_3_path)
    self.result_fail_btn_3_session = self:AddComponent(UIImage, result_fail_btn_3_session_path)

    self.Group_SliderReward = self:AddComponent(UIBaseContainer, Group_SliderReward_path)
    --self.imageSlider = self:AddComponent(UIImage, imageSlider_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.sliderEffect = self:AddComponent(UIBaseContainer, sliderEffect_path)

    self.boxBtn = {}
    self.box = {}
    self.boxOpen = {}
    self.boxText = {}
    for i = 1, 10 do
        local btnName = self:GetRewardBtnName(i)
        local boxName = self:GetRewardBoxName(i)
        local boxRewardEffectName = self:GetRewardEffectName(i)
        local boxRewardEffectName1 = self:GetRewardEffectName1(i)

        local boxOpenName = self:GetRewardBoxOpenName(i)
        local boxTexName = self:GetRewardBoxTextName(i)
        
        local btnPath = imageSlider_path.."/"..btnName
        local boxPath = btnPath.."/"..boxName
        local boxOpenPath = btnPath.."/"..boxOpenName
        local boxTextPath = btnPath.."/"..boxTexName
        local boxRewardEffectPath = btnPath.."/"..boxRewardEffectName
        local boxRewardEffect1Path = btnPath.."/"..boxRewardEffectName1

        self[btnName] = self:AddComponent(UIButton, btnPath)
        self[boxName] = self:AddComponent(UIBaseContainer, boxPath)
        self[boxOpenName] = self:AddComponent(UIImage, boxOpenPath)
        self[boxTexName] = self:AddComponent(UIText, boxTextPath)
        self[boxRewardEffectName] = self:AddComponent(UIBaseContainer, boxRewardEffectPath)
        self[boxRewardEffectName1] = self:AddComponent(UIBaseContainer, boxRewardEffect1Path)
    end

    self.Group_explain = self:AddComponent(UIBaseContainer, Group_explain_path)
    self.explainTxt1 = self:AddComponent(UIText, explainTxt1_path)
    self.explainTxt2 = self:AddComponent(UIText, explainTxt2_path)
    self.explainTxt2:SetLocalText(302040)
    self.explainTxt3 = self:AddComponent(UIText, explainTxt3_path)
    self:RegisterUIEvent()

    self.player1_head_btn = self:AddComponent(UIButton, player1_head_btn_path)
    self.player1_head_btn:SetOnClick(function()
        if self.championBattleInfo ~= nil and self.championBattleInfo.previewMatchObject ~= nil then
            local player = self.championBattleInfo.previewMatchObject.selfData
            if player ~= nil and not string.IsNullOrEmpty(player.uid) then
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
                self.view.ctrl:ShowPlayerInfo(player.uid)
            end
        end
    end)

    self.playerFinish_head_btn = self:AddComponent(UIButton, playerFinish_head_btn_path)
    self.playerFinish_head_btn:SetOnClick(function()
        if self.championBattleInfo ~= nil and self.championBattleInfo.previewMatchObject ~= nil then
            local player = self.championBattleInfo.previewMatchObject.selfData
            if player ~= nil and not string.IsNullOrEmpty(player.uid) then
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
                self.view.ctrl:ShowPlayerInfo(player.uid)
            end
        end
    end)

    self.player2_head_btn = self:AddComponent(UIButton, player2_head_btn_path)
    self.player2_head_btn:SetOnClick(function()
        if self.championBattleInfo ~= nil and self.championBattleInfo.previewMatchObject ~= nil then
            local player = self.championBattleInfo.previewMatchObject.opponentData
            if player ~= nil and not string.IsNullOrEmpty(player.uid) then
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
                self.view.ctrl:ShowPlayerInfo(player.uid)
            end
        end
    end)

    self.win_player_head_btn = self:AddComponent(UIButton, win_player_head_btn_path)
    self.win_player_head_btn:SetOnClick(function()
        if self.championBattleInfo ~= nil and self.championBattleInfo.previewMatchObject ~= nil then
            local player = self.championBattleInfo.previewMatchObject.selfData
            if player ~= nil and not string.IsNullOrEmpty(player.uid) then
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
                self.view.ctrl:ShowPlayerInfo(player.uid)
            end
        end
    end)

    self.fail_player_head_btn = self:AddComponent(UIButton, fail_player_head_btn_path)
    self.fail_player_head_btn:SetOnClick(function()
        if self.championBattleInfo ~= nil and self.championBattleInfo.previewMatchObject ~= nil then
            local player = self.championBattleInfo.previewMatchObject.selfData
            if player ~= nil and not string.IsNullOrEmpty(player.uid) then
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
                self.view.ctrl:ShowPlayerInfo(player.uid)
            end
        end
    end)
end

function M:GetRewardBtnName(index) 
    return "box"..index.."Btn"
end

function M:GetRewardBoxName(index)
    return "box"..index
end

function M:GetRewardEffectName(index)
    return "box"..index.."_reward"
end

function M:GetRewardEffectName1(index)
    return "box"..index.."_reward_1"
end

function M:GetRewardBoxOpenName(index)
    return "box_open"..index
end

function M:GetRewardBoxTextName(index)
    return "box"..index.."Txt"
end

function M:DataDefine()
    self.scoresStr = "10|20|30|40|50|60|70|80|90|100|110"
    self.firstSetSliderValue = true
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
    --self.rewardTipsGoUI.bgBtn.onClick:AddListener(BindCallback(self , self.OnClickCloseTips))
	for i = 1, 10 do
        --self.uiGroup_SliderReward["box"..i.."Btn"].onClick:AddListener(function()
        --    local rewardData = self.championBattleInfo.rewardBoxList[i]
        --    if rewardData == nil then
        --        --printError("同步奖励数据存在空，please check")
        --    end
        --    local boxState = rewardData.state
        --    if boxState == AuditionsBoxState.CanReceive then
        --        DataCenter.SendActChampionBattleRewardCmd:SendActChampionBattleRewardCmd(i-1)
        --    else
        --        local position = self.uiGroup_SliderReward["box"..i.."Btn"].transform.position
        --        self:OpenBoxRewardList(i , position)
        --    end
        --end)
        local btnName = self:GetRewardBtnName(i)
        if btnName ~= nil and self[btnName] ~= nil then
            self[btnName]:SetOnClick(function()
                local rewardData = self.championBattleInfo.rewardBoxList[i]
                if rewardData == nil then
                    --printError("同步奖励数据存在空，please check")
                    return
                end
                local boxState = rewardData.state
                if boxState == AuditionsBoxState.CanReceive then
                    DataCenter.ActChampionBattleManager:SendActChampionBattleRewardCmd(i - 1)
                else
                    local pos = self[btnName].transform.position
                    local x = pos.x
                    local y = pos.y
                    local offset = 50
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip, Localization:GetString("302026"), -1, x, y, false, i, offset)
                end
            end)
        end
    end
    
    --self.win_btn_1:SetOnClick(function()
    --    self:OnFailBtnClick(self.win_btn_1.transform.position)
    --end)
    --self.win_btn_2:SetOnClick(function()
    --    self:OnFailBtnClick(self.win_btn_2.transform.position)
    --end)
    --self.win_btn_3:SetOnClick(function()
    --    self:OnFailBtnClick(self.win_btn_3.transform.position)
    --end)
end

function M:OnFailBtnClick(btnPos)
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = btnPos + Vector3.New(-10, -30, 0) * scaleFactor

    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString("312079")
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 210
    param.pivot = 0.85-- * index
    param.position = position

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
    self:SetDetectEventLvInfoShowState(false)
    self.view:SetCurrentSelectItemId(nil)
end


function M:UnregisterUIEvent()
    --for i = 1, 10 do
    --    self.uiGroup_SliderReward["box"..i.."Btn"].onClick:RemoveAllListeners()
    --end
    --self.rewardTipsGoUI.bgBtn.onClick:RemoveAllListeners()
    --for i = 1, 3 do
    --    self["fail"..i.."Btn"].onClick:RemoveAllListeners()
    --    self.uiGroup_Win["fail"..i.."Btn"].onClick:RemoveAllListeners()
    --    self.uiGroup_Lose["fail"..i.."Btn"].onClick:RemoveAllListeners()
    --end
end

-----------------start---海选赛状态下显示

function M:SetData(info)
    self:StopTimer()
    self.championBattleInfo = info
    
    if self.championBattleInfo == nil then
        --printError("ChampionBattleItem_auditions:championBattleInfo == nil")
        return
    end
    
    local curIndexState = self.championBattleInfo:GetCurState()
    if curIndexState >= Activity_ChampionBattle_Stage_State.Auditions and self.championBattleInfo.hasSingUp == 1 then
        if self.championBattleInfo.auditionsState == 0  then
            if self.championBattleInfo.winRound  + self.championBattleInfo.loseRound == self.championBattleInfo.totalRound then
                self:SetWaitFinish()
            else
                self:SetTwoPlayerData()
            end
        elseif self.championBattleInfo.auditionsState == 1  then
            self:SetWinPlayerData()
        elseif self.championBattleInfo.auditionsState == -1  then
            self:SetLosePlayerData()
        end
        self:RefreshAuditionData()
        self.Group_auditions:SetActive(true)
        self.Group_SliderReward:SetActive(true)
        self.Group_explain:SetActive(false)
    else
        if self.championBattleInfo.hasSingUp == 1 then
            self.explainTxt1:SetLocalText(302039)
        elseif self.championBattleInfo.hasSingUp == 0 then
            self.explainTxt1:SetLocalText(302038)
        end
        self.Group_auditions:SetActive(false)
        self.Group_explain:SetActive(true)
    end
    self:RefreshTime()
end

function M:RefreshAuditionData()
    if self.championBattleInfo.rewardBoxList == nil then
        --printError("ChampionBattleItem_auditions: server synchronization 'rewardBoxList' is nil, 同步数据错误")
    end
    for i = 1, 10 do        
        local boxState = self.championBattleInfo.rewardBoxList[i].state
        -- printInfo(i.."***---宝箱状态scoreReward.scoreRewardState="..boxState)
        local btnStr = self:GetRewardBtnName(i)
        local openBoxStr = self:GetRewardBoxOpenName(i)
        local boxStr = self:GetRewardBoxName(i)
        local rewardEffectStr = self:GetRewardEffectName(i)
        local rewardEffectStr1 = self:GetRewardEffectName1(i)

        local btn = self[btnStr]
        local openIcon = self[openBoxStr]
        local icon = self[boxStr]
        local rewardEffect = self[rewardEffectStr]
        local rewardEffect1 = self[rewardEffectStr1]

        if boxState == AuditionsBoxState.NotStart then
            --btn:SetInteractable(false)
            openIcon:SetActive(false)
            icon:SetActive(true)
            rewardEffect:SetActive(false)
            rewardEffect1:SetActive(false)
            --self.uiGroup_SliderReward["box"..i.."Btn"].reloadInteractable = true
            --self.uiGroup_SliderReward["box"..i.."Effect"]:SetActive(false)
            --self.uiGroup_SliderReward["box"..i.."Animator"].gameObject:SetActive(true)
            --self.uiGroup_SliderReward["box"..i.."Animator"].enabled = false
        elseif boxState == AuditionsBoxState.CanReceive then
            --self.uiGroup_SliderReward["box"..i.."Effect"]:SetActive(true)
            --self.uiGroup_SliderReward["box"..i.."Btn"].reloadInteractable = true
            --self.uiGroup_SliderReward["box"..i.."Animator"].gameObject:SetActive(true)
            --self.uiGroup_SliderReward["box"..i.."Animator"].enabled = true
            btn:SetInteractable(true)
            openIcon:SetActive(false)
            icon:SetActive(true)
            rewardEffect:SetActive(true)
            rewardEffect1:SetActive(true)

        elseif boxState == AuditionsBoxState.HasReceived then
            --self.uiGroup_SliderReward["box"..i.."Btn"].reloadInteractable = false
            --self.uiGroup_SliderReward["box"..i.."Effect"]:SetActive(false)
            --self.uiGroup_SliderReward["box"..i.."Animator"].enabled = false
            --self.uiGroup_SliderReward["box"..i.."Animator"].gameObject:SetActive(false)
            --btn:SetInteractable(false)
            openIcon:SetActive(true)
            icon:SetActive(false)
            rewardEffect:SetActive(false)
            rewardEffect1:SetActive(false)

            --2021.12.27策划优化，不再有置灰状态，依次显示胜场的宝箱
        elseif boxState == AuditionsBoxState.Fail then
            --self.uiGroup_SliderReward["box"..i.."Btn"].reloadInteractable = true
            --CS.LF.LuaInterfaceCommon.SetGray(self.uiGroup_SliderReward["box"..i.."Animator"].transform, true)
            --self.uiGroup_SliderReward["box"..i.."Effect"]:SetActive(false)
            --self.uiGroup_SliderReward["box"..i.."Animator"].enabled = false
            --btn:SetInteractable(false)
            openIcon:SetActive(false)
            icon:SetActive(true)
            rewardEffect:SetActive(false)
            rewardEffect1:SetActive(false)

        end
    end

    local joinRound = self.championBattleInfo.winRound
    
    local rate = (joinRound - 1) / (self.championBattleInfo.totalRound - 1)
    rate = math.max(0, math.min(rate, 1))
    -- self.uiGroup_SliderReward.boxSlider.value = rate
    --joinRound = math.random(8,11)
    local curScore = joinRound*10
    --printInfo(joinRound.."curScore============="..curScore)
    self.sliderEffect:SetActive(false)
    --self.imageSlider:SetFillAmount(rate)
    self.slider:SetValue(rate)
    if self.firstSetSliderValue then
        --self.firstSetSliderValue = false
        --self.imageSlider:SetCurScore(curScore , false)    
        --local curScore = self.uiGroup_SliderReward.imageSlider:GetCurScore()    
        -- self.sliderEffect.anchoredPosition = Vector2.New(curScore*1110, 0)       
        -- self.sliderEffect:SetActive(true)
    else
        --self.imageSlider:SetCurScore(curScore, true , function(toRate)
            --local curScore = self.uiGroup_SliderReward.imageSlider:GetCurScore()    
            -- self.sliderEffect.anchoredPosition = Vector2.New(curScore*1110, 0)       
            -- self.sliderEffect:SetActive(true)
        --end)
    end
end

--打开宝箱奖励列表
function M:OpenBoxRewardList(boxIndex,pos)
	--self.rewardTipsGo.transform.position = pos
	--self.rewardTipsGo:SetActive(true)  
	--
    --local rewards = self.championBattleInfo.rewardBoxList[boxIndex].reward
    ---- printInfo("打印出来。。。。="..boxIndex..",aa="..#rewards)
    --self.rewardTipsGoUI.rewardMultiScroller.DataCount = self:GetRewardItemCount(boxIndex)
	--self.rewardTipsGoUI.rewardMultiScroller:ResetScroller(true)
    --self.rewardTipsGoUI.rewardMultiScroller.OnItemCreate = function(index , go)
    --    local data = rewards[index+1]
    --    if data == nil then
    --        printInfo("item data is null , the index = " .. index)
    --        return
    --    end
	--	local itemIcon = go.transform:GetComponent(typeof(CS.UIItemIcon))
	--	if itemIcon ~= nil then
	--		self:SetItemIconData(itemIcon , data)
	--	end		
    --end
    --self.rewardTipsGoUI.rewardMultiScroller:ResetScroller()
end
--显示单个道具
function M:SetItemIconData(itemIcon, reward)
	local type = reward["type"]
    
    local type, itemId , num = ItemUtil.getIconDataFromMsgReward(type ,reward)
	itemIcon:SetData(type, itemId, num)           
	itemIcon:SetSize(46)	
	itemIcon:SetTipObjPoint(Vector3.New(0,-46,0))
    itemIcon:SetTipsToward(true)
    itemIcon:SetTouchEnable(true)
	itemIcon.gameObject:SetActive(true)
end

function M:GetRewardItemCount(index)
    local count = 0 
    if self.championBattleInfo ~= nil and self.championBattleInfo.rewardBoxList ~= nil then
        count = #self.championBattleInfo.rewardBoxList[index].reward
        --printInfo(index.."冠军活动数据长度=rewards="..count)
    end
    return count
end

function M:SetWaitFinish()
    self.Group_Win:SetActive(false)
    self.Group_Lose:SetActive(false)
    self.Group_explain:SetActive(false)
    self.Group_AgainstPlayers:SetActive(true)
    self.vs:SetActive(false)
    self.curRoundTxt:SetText("")
    self.player1:SetActive(false)
    self.player2:SetActive(false)
    self.playerFinish:SetActive(true)
    self.finish_text:SetActive(true)
    local player = self.championBattleInfo.previewMatchObject.selfData
    if player ~= nil then
        self.view.ctrl:SetHeadImg(self.playerFinish_head, self.playerFinish_head_Foreground, player.uid, player.pic, player.picver, player.headFrame, player.headSkinId, player.headSkinET)
        self.playerFinishServer:SetText(tostring(player.serverId))
        self.playerFinishName:SetText(self.view.ctrl:GetNameStr(player.abbr, player.name))
        self.playerFinishIntegral:SetText(tostring(player.score))
        self.playerFinishRank:SetText(DataCenter.ActChampionBattleManager:SetRankIndexFormat(player.rank))
        self.winTimesTxt:SetLocalText(302041, self.championBattleInfo.winRound.."/"..self.championBattleInfo.totalRound)
    else
        self.playerFinish:SetActive(false)
    end
end

--海选比赛中匹配的两玩家显示内容
function M:SetTwoPlayerData()
    self.Group_Win:SetActive(false)
    self.Group_Lose:SetActive(false)
    self.Group_explain:SetActive(false)
    self.Group_AgainstPlayers:SetActive(true)
    --self.winTimesTxt.text = _lang("361002").." "..self.championBattleInfo.winRound
    --self.winTimesTxt:SetLocalText(302041, self.championBattleInfo.winRound)
    --self.curRoundTxt.text = _lang("312046", self.championBattleInfo.curRound.."/".. self.championBattleInfo.totalRound)
    self.winTimesTxt:SetLocalText(302041, self.championBattleInfo.winRound.."/"..self.championBattleInfo.totalRound)
    self.curRoundTxt:SetLocalText(302069, tostring(self.championBattleInfo.curRound))
    self.player1:SetActive(true)
    self.player2:SetActive(true)
    self.vs:SetActive(true)
    self.finish_text:SetActive(false)
    self.playerFinish:SetActive(false)
    local loseTime = self.championBattleInfo.loseRound
    for i = 1, 3 do
        local sessionName = "fail_btn_"..i.."_session"
        if self[sessionName] ~= nil then
            if loseTime >= i then
                self[sessionName]:SetActive(false)
            else
                self[sessionName]:SetActive(true)
            end
        end
    end
    if self.championBattleInfo.previewMatchObject == nil then
        --printError("ChampionBattleItem_auditions.SetTwoPlayerData: server synchronization 'previewMatchObject' is nil, 同步数据错误")
        return
    end
    local playerListData = {self.championBattleInfo.previewMatchObject.selfData , self.championBattleInfo.previewMatchObject.opponentData}
    for i = 1, 2 do
        local uuid = nil
        local player = playerListData[i] --GameEntry.Data.Player --测试
    
        if player ~= nil then
            --local heroImg = self.uiGroup_AgainstPlayers["player"..i.."HeadImg"]
            --CS.CommonUtils.LoadHeadEx(player.uid, player.pic, player.picver, heroImg)
            self.view.ctrl:SetHeadImg(self["player"..i.."_head"], self["player"..i.."_head_Foreground"], player.uid, player.pic, player.picver, player.headFrame, player.headSkinId, player.headSkinET)
            --self["player"..i.."_head"]:SetData(player.uid, player.pic, player.picver)
            self["player"..i.."Server"]:SetLocalText(tostring(player.serverId))
            self["player"..i.."Name"]:SetLocalText(self.view.ctrl:GetNameStr(player.abbr, player.name))
            self["player"..i.."Integral"]:SetLocalText(tostring(player.score))
            self["player"..i.."Rank"]:SetLocalText(DataCenter.ActChampionBattleManager:SetRankIndexFormat(player.rank))
            --local playerUid = player.uid        
            --if playerUid ~= GameEntry.Data.Player.Uid then            
            --    self.uiGroup_AgainstPlayers["player"..i.."Head"].onClick:RemoveAllListeners()
            --    self.uiGroup_AgainstPlayers["player"..i.."Head"].onClick:AddListener(function()                
            --        if string.IsNullOrEmpty(playerUid) then return end
            --        AccountManager.showPlayerInfoView(playerUid)
            --    end)
            --end  
        else
            --local heroImg = self.uiGroup_AgainstPlayers["player"..i.."HeadImg"]
            --heroImg:LoadAsync("default_sp")
            self["player"..i.."Server"]:SetLocalText("")
            self["player"..i.."Name"]:SetLocalText(312059)
            self["player"..i.."Integral"]:SetLocalText("0")
            self["player"..i.."Rank"]:SetLocalText("0")
        end
    end

end
--海选比赛结束赢的玩家显示内容
function M:SetWinPlayerData()
    self.Group_Win:SetActive(true)
    self.Group_Lose:SetActive(false)
    self.Group_explain:SetActive(false)
    self.Group_AgainstPlayers:SetActive(false)
    self.nextInfoTxt.gameObject:SetActive(false)

    local loseTime = self.championBattleInfo.loseRound
    for i = 1, 3 do
        local sessionName = "win_btn_"..i.."_session"
        if self[sessionName] ~= nil then
            if loseTime >= i then
                self[sessionName]:SetActive(false)
            else
                self[sessionName]:SetActive(true)
            end
        end
    end
    if self.championBattleInfo.previewMatchObject == nil then
        --printError("ChampionBattleItem_auditions.SetWinPlayerData: server synchronization 'previewMatchObject' is nil, 同步数据错误")
        return
    end
    local player = self.championBattleInfo.previewMatchObject.selfData
    --local heroImg = self.uiGroup_Win["playerHeadImg"]
    --CS.CommonUtils.LoadHeadEx(player.uid, player.pic, player.picver, heroImg)
    --self.win_player_head:SetData(player.uid, player.pic, player.picver)
    self.view.ctrl:SetHeadImg(self.win_player_head, self.win_player_head_Foreground, player.uid, player.pic, player.picver, player.headFrame, player.headSkinId, player.headSkinET)

    self.win_player_server:SetText("#"..player.serverId)
    self.win_player_name:SetText(self.view.ctrl:GetNameStr(player.abbr, player.name))
    self.playerIntegral:SetText(tostring(player.score))
    self.playerRank:SetText(DataCenter.ActChampionBattleManager:SetRankIndexFormat(player.rank))
    self.sliderEffect:SetActive(false)
end
--海选比赛结束输的玩家显示内容
function M:SetLosePlayerData()
    self.Group_Win:SetActive(false)
    self.Group_Lose:SetActive(true)
    self.Group_explain:SetActive(false)
    self.Group_AgainstPlayers:SetActive(false)
    self.nextInfoTxt.gameObject:SetActive(false)

    if self.championBattleInfo.previewMatchObject == nil then
        --printError("ChampionBattleItem_auditions.SetLosePlayerData: server synchronization 'previewMatchObject' is nil, 同步数据错误")
        return
    end
    local player = self.championBattleInfo.previewMatchObject.selfData
    
    --local heroImg = self.uiGroup_Lose["playerHeadImg"]
    --CS.CommonUtils.LoadHeadEx(player.uid, player.pic, player.picver, heroImg)    
    --self.uiGroup_Lose["playerServer"].text = "#"..player.serverId
    --self.uiGroup_Lose["playerName"].text = player.name
    --self.uiGroup_Lose["playerIntegral"].text = player.score
    --self.uiGroup_Lose["playerRank"].text = ActivityControllerInst:SetRankIndexFormat(player.rank)
    --self.sliderEffect:SetActive(false)
    -- self.uiGroup_Lose["player"..i.."Integral"].text = ""
    -- self.uiGroup_Lose["player"..i.."Rank"].text = ""
    --self.fail_player_head:SetData(player.uid, player.pic, player.picver)
    self.view.ctrl:SetHeadImg(self.fail_player_head, self.fail_player_head_Foreground, player.uid, player.pic, player.picver, player.headFrame, player.headSkinId, player.headSkinET)

    self.fail_player_server:SetText("#"..player.serverId)
    self.fail_player_name:SetText(self.view.ctrl:GetNameStr(player.abbr, player.name))
    self.fail_playerIntegral:SetText(tostring(player.score))
    self.fail_playerRank:SetText(DataCenter.ActChampionBattleManager:SetRankIndexFormat(player.rank))
    self.sliderEffect:SetActive(false)
end

function M:OnClickCloseTips()
    --if self.rewardTipsGo ~= nil then
    --    self.rewardTipsGo:SetActive(false)
    --end
end

-----------------end---海选赛状态下显示

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
	if self.nextInfoTxt == nil or self.championBattleInfo == nil then
		return
	end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    
    --距离海选阶段开启时间
    local endTime = self.championBattleInfo.auditionsST
    if endTime > curTime then
        if self.championBattleInfo.hasSingUp == 1 then
            self.explainTxt3:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(endTime - curTime))
        elseif self.championBattleInfo.hasSingUp == 0 then
            self.explainTxt3:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(endTime - curTime))
        end
        self.explainTxt3:SetActive(true)
        self.explainTxt2:SetActive(true)

    else
        self.explainTxt3:SetActive(false)
        self.explainTxt2:SetActive(false)

        --self:StopTimer()

        if self.championBattleInfo.auditionsState == 0 then
            --海选中显示 距离下一局开始时间
            local nextRoundST = self.championBattleInfo.nextRoundST
            if nextRoundST > curTime then
                self.nextInfoTxt:SetLocalText(302044, UITimeManager:GetInstance():MilliSecondToFmtString(nextRoundST - curTime))
                --self.nextInfoTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(endTime - curTime))
                self.nextInfoTxt:SetActive(true)
            else
                --self.nextInfoTxt.text = "" 
                self.nextInfoTxt:SetText("")
            end
        else
            self.nextInfoTxt:SetActive(false)
        end
    end
end

return M
