---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/8/2 14:08
---
local GroupHonorListCellItem = BaseClass("GroupHonorListCellItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local normal_path = "Normal"
local normal_replay_btn_path = "Normal/Normal_Replay_Btn"
local normal_score_text1_path = "Normal/Normal_Score_Text1"
local normal_score_text2_path = "Normal/Normal_Score_Text2"
local normal_bet_btn_path = "Normal/Grid/NormalBetBtn"
local UIGray = CS.UIGray
local normal_head_left_path = "Normal/Normal_Head_Left/head/Normal_UIPlayerHead_Left"
local normal_head_img_left_path = "Normal/Normal_Head_Left/head/Normal_UIPlayerHead_Left/Normal_HeadIcon_left"
local normal_head_Foreground_left_path = "Normal/Normal_Head_Left/head/Normal_UIPlayerHead_Left/Normal_Foreground_left"
local normal_lose_img_left_path = "Normal/Normal_Head_Left/Normal_Image_Lose_Left"
local normal_win_img_left_path = "Normal/Normal_Head_Left/normal_win_left"
local normal_server_name_left_path = "Normal/Normal_Head_Left/Normal_ServerName_Left"
local normal_user_name_left_path = "Normal/Normal_Head_Left/playerNameBg/Normal_User_Name_Left"

local normal_head_right_path = "Normal/Normal_Head_Right/head/Normal_UIPlayerHead_Right"
local normal_head_img_right_path = "Normal/Normal_Head_Right/head/Normal_UIPlayerHead_Right/Normal_HeadIcon_right"
local normal_head_Foreground_right_path = "Normal/Normal_Head_Right/head/Normal_UIPlayerHead_Right/Normal_Foreground_right"

local normal_lose_img_right_path = "Normal/Normal_Head_Right/Normal_Image_Lose_Right"
local normal_win_img_right_path = "Normal/Normal_Head_Right/normal_win_right"
local normal_server_name_right_path = "Normal/Normal_Head_Right/Normal_ServerName_Right"
local normal_user_name_right_path = "Normal/Normal_Head_Right/playerNameBg/Normal_User_Name_Right"
--local normal_fighting_left_path = "Normal/VFX_battle_glow_bg"
--local normal_fighting_right_path = "Normal/VFX_battle_glow_bg_red"

local final_path = "Final"
local final_replay_btn_path = "Final/FinalReplayBtn"
local final_score_text_left_path = "Final/Score_Left"
local final_score_text_right_path = "Final/Score_Right"
local final_bet_btn_path = "Final/FinalBetbtn"

local final_head_left_path = "Final/Final_PlayerHead_Left/head/Final_UIPlayerHead_Left"
local final_empty_left_path = "Final/Final_PlayerHead_Left/head/Final_Head_empty_Left"
local final_empty_Txt_left_path = "Final/Final_PlayerHead_Left/head/Final_Head_empty_Left/Final_Txt_empty_Left"
local final_head_img_left_path = "Final/Final_PlayerHead_Left/head/Final_UIPlayerHead_Left/Final_HeadIcon_left"
local final_head_Foreground_left_path = "Final/Final_PlayerHead_Left/head/Final_UIPlayerHead_Left/Final_Foreground_left"
local final_lose_img_left_path = "Final/Final_PlayerHead_Left/Final_Lose_Image_Left"
local final_user_name_left_path = "Final/Final_PlayerHead_Left/Final_Name_Left"
local final_Image_1Win_left_path = "Final/Image_1Win"

local final_head_right_path = "Final/Final_PlayerHead_Right/head/Final_UIPlayerHead_Right"
local final_empty_right_path = "Final/Final_PlayerHead_Right/head/Final_Head_empty_Right"
local final_empty_Txt_right_path = "Final/Final_PlayerHead_Right/head/Final_Head_empty_Right/Final_Txt_empty_Right"
local final_head_img_right_path = "Final/Final_PlayerHead_Right/head/Final_UIPlayerHead_Right/Final_HeadIcon_right"
local final_head_Foreground_right_path = "Final/Final_PlayerHead_Right/head/Final_UIPlayerHead_Right/Final_Foreground_right"

local final_lose_img_right_path = "Final/Final_PlayerHead_Right/Final_Lose_Image_Right"
local final_user_name_right_path = "Final/Final_PlayerHead_Right/Final_Name_Right"
local final_Image_1Win_right_path = "Final/Image_2Win"
local winColor = (Color.New(252/255, 229/255, 203/255, 1))
local loseColor = (Color.New(255/255, 255/255, 255/255, 1))
local function OnCreate(self)
    base.OnCreate(self)

    self:DataDefine()
    self:ComponentDefine()
end

local function ComponentDefine(self)
    self.normal = self:AddComponent(UIBaseContainer, normal_path)
    self.normal_replay_btn = self:AddComponent(UIButton, normal_replay_btn_path)
    self.normal_score_text1 = self:AddComponent(UIText, normal_score_text1_path)
    self.normal_score_text2 = self:AddComponent(UIText, normal_score_text2_path)
    self.normal_bet_btn = self:AddComponent(UIButton, normal_bet_btn_path)

    self.normal_head_img_left = self:AddComponent(UIPlayerHead, normal_head_img_left_path)
    self.normal_lose_img_left = self:AddComponent(UIImage, normal_lose_img_left_path)
    self.normal_win_img_left = self:AddComponent(UIImage, normal_win_img_left_path)
    self.normal_head_Foreground_left = self:AddComponent(UIImage, normal_head_Foreground_left_path)
    self.normal_server_name_left = self:AddComponent(UIText, normal_server_name_left_path)
    self.normal_user_name_left = self:AddComponent(UIText, normal_user_name_left_path)

    self.normal_head_img_right = self:AddComponent(UIPlayerHead, normal_head_img_right_path)
    self.normal_lose_img_right = self:AddComponent(UIImage, normal_lose_img_right_path)
    self.normal_win_img_right = self:AddComponent(UIImage, normal_win_img_right_path)
    self.normal_head_Foreground_right = self:AddComponent(UIImage, normal_head_Foreground_right_path)
    self.normal_server_name_right = self:AddComponent(UIText, normal_server_name_right_path)
    self.normal_user_name_right = self:AddComponent(UIText, normal_user_name_right_path)
    --self.normal_fighting_left = self:AddComponent(UIBaseContainer, normal_fighting_left_path)
    --self.normal_fighting_right = self:AddComponent(UIBaseContainer, normal_fighting_right_path)

    self.final = self:AddComponent(UIBaseContainer, final_path)
    self.final_replay_btn = self:AddComponent(UIButton, final_replay_btn_path)
    self.final_score_text_left = self:AddComponent(UIText, final_score_text_left_path)
    self.final_score_text_right = self:AddComponent(UIText, final_score_text_right_path)
    self.final_bet_btn = self:AddComponent(UIButton, final_bet_btn_path)

    self.final_head_img_left = self:AddComponent(UIPlayerHead, final_head_img_left_path)
    self.final_head_Foreground_left = self:AddComponent(UIImage, final_head_Foreground_left_path)
    self.final_lose_img_left = self:AddComponent(UIImage, final_lose_img_left_path)
    self.final_user_name_left = self:AddComponent(UIText, final_user_name_left_path)

    self.final_head_img_right = self:AddComponent(UIPlayerHead, final_head_img_right_path)
    self.final_head_Foreground_right = self:AddComponent(UIImage, final_head_Foreground_right_path)
    self.final_lose_img_right = self:AddComponent(UIImage, final_lose_img_right_path)
    self.final_user_name_right = self:AddComponent(UIText, final_user_name_right_path)

    self.normal_head_left = self:AddComponent(UIButton, normal_head_left_path)
    self.normal_head_right = self:AddComponent(UIButton, normal_head_right_path)
    self.final_head_left = self:AddComponent(UIButton, final_head_left_path)
    self.final_empty_left = self:AddComponent(UIImage, final_empty_left_path)
    self.final_head_right = self:AddComponent(UIButton, final_head_right_path)
    self.final_empty_right = self:AddComponent(UIImage, final_empty_right_path)
    self.final_empty_Txt_right = self:AddComponent(UIText, final_empty_Txt_right_path)
    self.final_empty_Txt_Left = self:AddComponent(UIText, final_empty_Txt_left_path)

    self.final_Image_1Win_right = self:AddComponent(UIText, final_Image_1Win_right_path)
    self.final_Image_1Win_left = self:AddComponent(UIText, final_Image_1Win_left_path)

    self.normal_replay_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBattleReportClick()
    end)
    self.normal_bet_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBetClick()
    end)
    self.final_replay_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBattleReportClick()
    end)
    self.final_bet_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBetClick()
    end)

    self.normal_head_left:SetOnClick(function()
        if self.data ~= nil and not string.IsNullOrEmpty(self.data["uid1"]) then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self.view.ctrl:ShowPlayerInfo(self.data["uid1"])
        end
    end)
    self.normal_head_right:SetOnClick(function()
        if self.data ~= nil and not string.IsNullOrEmpty(self.data["uid2"]) then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self.view.ctrl:ShowPlayerInfo(self.data["uid2"])
        end
    end)
    self.final_head_left:SetOnClick(function()
        if self.data ~= nil and not string.IsNullOrEmpty(self.data["uid1"]) then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self.view.ctrl:ShowPlayerInfo(self.data["uid1"])
        end
    end)
    self.final_head_right:SetOnClick(function()
        if self.data ~= nil and not string.IsNullOrEmpty(self.data["uid2"]) then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self.view.ctrl:ShowPlayerInfo(self.data["uid2"])
        end
    end)

    self.normal_bet_btn:SetActive(false)
    self.final_bet_btn:SetActive(false)
end

local function DataDefine(self)
    
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    
    base.OnDestroy(self)
end

local function ComponentDestroy(self)

end

local function DataDestroy(self)
    self.param = nil
end

local function SetData(self, param, index, type, info) 
    self.data = param
    self.type = type
    self.index = index
    self.info = info
    self:Refresh()
end

local function Refresh(self)
    if self.index == 1 then
        self:RefreshFinal()
    else
        self:RefreshNormal()
    end
end

local function RefreshNormal(self)
    self.final:SetActive(false)
    self.normal:SetActive(true)
    local leftPlayer = nil
    local rightPlayer = nil

    if self.data == nil or self.info == nil then
        self.normal_replay_btn:SetActive(false)
        self.normal_score_text1:SetActive(false)
        self.normal_score_text2:SetActive(false)
        --self.normal_bet_btn:SetActive(false)

        self.normal_lose_img_left:SetActive(false)
        self.normal_win_img_left:SetActive(false)
        self.normal_server_name_left:SetText("")
        self.normal_user_name_left:SetText("TBD")
        self.normal_head_left:SetActive(false)
        --self.normal_head_img_left
        self.view.ctrl:SetHeadImg(self.normal_head_img_left, self.normal_head_Foreground_left, "", "", 0, 0)
        --self.normal_fighting_left:SetActive(false)
        --self.normal_fighting_right:SetActive(false)

        self.normal_lose_img_right:SetActive(false)
        self.normal_win_img_right:SetActive(false)
        
        self.normal_server_name_right:SetText("")
        self.normal_user_name_right:SetText("TBD")
        self.normal_head_right:SetActive(false)
        --self.normal_head_img_right
        self.view.ctrl:SetHeadImg(self.normal_head_img_right, self.normal_head_Foreground_right, "", "", 0, 0)

    else
        leftPlayer = self.info:GetPlayerMsgByUid(self.data["uid1"])
        rightPlayer = self.info:GetPlayerMsgByUid(self.data["uid2"])
        local loseUid = self.data["loseUid"]
        self.normal_head_left:SetActive(true)
        self.normal_head_right:SetActive(true)

        self.normal_lose_img_left:SetActive(loseUid == self.data["uid1"])
        self.normal_lose_img_right:SetActive(loseUid == self.data["uid2"])
        self.normal_win_img_left:SetActive(loseUid == self.data["uid2"])
        self.normal_win_img_right:SetActive(loseUid == self.data["uid1"])
        self.normal_replay_btn:SetActive(self.info.strongestType >= self.type)
        self.normal_score_text1:SetActive(true)
        self.normal_score_text2:SetActive(true)
        self.normal_score_text1:SetText(self.data.score1)
        self.normal_score_text2:SetText(self.data.score2)

        if leftPlayer ~= nil then
            self.normal_server_name_left:SetText("#"..leftPlayer.serverId)
            self.normal_user_name_left:SetText("#"..leftPlayer.serverId..self.view.ctrl:GetNameStr(leftPlayer.abbr, leftPlayer.name))
            self.view.ctrl:SetHeadImg(self.normal_head_img_left, self.normal_head_Foreground_left, leftPlayer.uid, leftPlayer.pic, leftPlayer.picver, leftPlayer.headFrame)
        else
            self.normal_server_name_left:SetText("")
            self.normal_user_name_left:SetText("TBD")
            self.view.ctrl:SetHeadImg(self.normal_head_img_left, self.normal_head_Foreground_left, "", "", 0, 0)
        end
        
        if rightPlayer ~= nil then
            self.normal_server_name_right:SetText("#"..rightPlayer.serverId)
            self.normal_user_name_right:SetText("#"..rightPlayer.serverId..self.view.ctrl:GetNameStr(rightPlayer.abbr, rightPlayer.name))
            self.view.ctrl:SetHeadImg(self.normal_head_img_right, self.normal_head_Foreground_right, rightPlayer.uid, rightPlayer.pic, rightPlayer.picver, rightPlayer.headFrame)
        else
            self.normal_server_name_right:SetText("")
            self.normal_user_name_right:SetText("TBD")
            self.view.ctrl:SetHeadImg(self.normal_head_img_right, self.normal_head_Foreground_right, "", "", 0, 0)

        end
    end
end

local function RefreshFinal(self)
    self.final:SetActive(true)
    self.normal:SetActive(false)
    local leftPlayer = nil
    local rightPlayer = nil
    self.final_empty_right:SetActive(false)
    self.final_empty_left:SetActive(false)
    self.final_head_right:SetActive(true)
    self.final_head_left:SetActive(true)
    if self.data == nil or self.info == nil then
        self.final_score_text_left:SetText("")
        self.final_score_text_right:SetText("")
        --self.final_bet_btn:SetActive(false)
        self.final_replay_btn:SetActive(false)
        self.final_Image_1Win_right:SetActive(false)
        self.final_Image_1Win_left:SetActive(false)

        --self.final_head_img_left = self:AddComponent(UIImage, final_head_img_left_path)
        --self.final_lose_img_left:SetActive(false)
        self.final_empty_left:SetActive(true)
        self.final_head_left:SetActive(false)
        self.final_user_name_left:SetText("")

        --self.final_head_img_right = self:AddComponent(UIImage, final_head_img_right_path)
        --self.final_lose_img_right:SetActive(false)
        self.final_head_right:SetActive(false)
        self.final_empty_right:SetActive(true)
        UIGray.SetGray(self.final_empty_right.transform,false,false)
        UIGray.SetGray(self.final_empty_left.transform,false,false)
        self.final_empty_Txt_right:SetColor(winColor)
        self.final_empty_Txt_Left:SetColor(winColor)
        self.final_user_name_right:SetText("")
        self.view.ctrl:SetHeadImg(self.final_head_img_left, self.final_head_Foreground_left, "", "", 0, 0)
        self.view.ctrl:SetHeadImg(self.final_head_img_right, self.final_head_Foreground_right, "", "", 0, 0)
    else
        leftPlayer = self.info:GetPlayerMsgByUid(self.data["uid1"])
        rightPlayer = self.info:GetPlayerMsgByUid(self.data["uid2"])
        local loseUid = self.data["loseUid"]
        local lose_right = loseUid == self.data["uid2"]
        local lose_left = loseUid == self.data["uid1"]
        UIGray.SetGray(self.final_empty_right.transform,lose_right,false)
        UIGray.SetGray(self.final_empty_left.transform,lose_left,false)
        self.final_empty_Txt_right:SetColor(lose_right and loseColor or winColor)
        self.final_empty_Txt_Left:SetColor(lose_left and loseColor or winColor)

        self.final_replay_btn:SetActive(self.info.strongestType >= self.type)

        self.final_score_text_left:SetText(self.data.score1)
        self.final_score_text_right:SetText(self.data.score2)
        if leftPlayer ~= nil then
            self.final_user_name_left:SetText(leftPlayer.name)
            self.final_user_name_left:SetText("#"..leftPlayer.serverId..self.view.ctrl:GetNameStr(leftPlayer.abbr, leftPlayer.name))
            self.view.ctrl:SetHeadImg(self.final_head_img_left, self.final_head_Foreground_left, leftPlayer.uid, leftPlayer.pic, leftPlayer.picver, leftPlayer.headFrame, leftPlayer.headSkinId, leftPlayer.headSkinET)
        else
            self.final_score_text_left:SetText("")
            self.final_head_left:SetActive(false)
            self.final_empty_left:SetActive(true)
            self.final_user_name_left:SetText("")
            self.view.ctrl:SetHeadImg(self.final_head_img_left, self.final_head_Foreground_left, "", "", 0, 0)
        end

        if rightPlayer ~= nil then
            self.final_user_name_right:SetText("#"..rightPlayer.serverId..self.view.ctrl:GetNameStr(rightPlayer.abbr, rightPlayer.name))
            self.view.ctrl:SetHeadImg(self.final_head_img_right, self.final_head_Foreground_right, rightPlayer.uid, rightPlayer.pic, rightPlayer.picver, rightPlayer.headFrame, rightPlayer.headSkinId, rightPlayer.headSkinET)
        else
            self.final_head_right:SetActive(false)
            self.final_empty_right:SetActive(true)
            self.final_user_name_right:SetText("")
            self.view.ctrl:SetHeadImg(self.final_head_img_right, self.final_head_Foreground_right, "", "", 0, 0)
        end
    end
end

local function OnBetClick(self)
    
end

local function OnBattleReportClick(self)
    if self.data == nil or (self.data.score1 == 0 and self.data.score2 == 0) then
        UIUtil.ShowTips(Localization:GetString("302116"));
        return
    end
    local group
    if self.info then
        group = self.info.group
    end
    DataCenter.ActChampionBattleManager:SendActChampionStrongestReportDescCmd(self.data.phase, self.data.location, group)
end

GroupHonorListCellItem.RefreshNormal = RefreshNormal
GroupHonorListCellItem.RefreshFinal = RefreshFinal
GroupHonorListCellItem.OnCreate = OnCreate
GroupHonorListCellItem.OnDestroy = OnDestroy
GroupHonorListCellItem.ComponentDefine = ComponentDefine
GroupHonorListCellItem.ComponentDestroy = ComponentDestroy
GroupHonorListCellItem.SetData = SetData
GroupHonorListCellItem.DataDefine = DataDefine
GroupHonorListCellItem.DataDestroy = DataDestroy
GroupHonorListCellItem.Refresh = Refresh
GroupHonorListCellItem.OnBetClick = OnBetClick
GroupHonorListCellItem.OnBattleReportClick = OnBattleReportClick

return GroupHonorListCellItem