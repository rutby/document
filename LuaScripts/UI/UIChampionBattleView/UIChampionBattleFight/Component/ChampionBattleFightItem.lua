local ChampionBattleFightItem = BaseClass("ChampionBattleFightItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local left_head_btn_path = "Left/headIconBg_left/Left_UIPlayerHead"
local left_icon_bg_path = "Left/headIconBg_left/Left_UIPlayerHead/Left_Foreground"
local left_icon_path = "Left/headIconBg_left/Left_UIPlayerHead/Left_HeadIcon"
local left_name_path = "Left/Name_left"
local left_Score_path = "Left/Score_left"
local icon_left_path = "Left/icon_left"
local Score_left_title_path = "Left/Score_left_title"
local right_head_btn_path = "Right/headIconBg_right/Right_UIPlayerHead"
local right_icon_bg_path = "Right/headIconBg_right/Right_UIPlayerHead/Right_Foreground"
local right_icon_path = "Right/headIconBg_right/Right_UIPlayerHead/Right_HeadIcon"
local right_name_path = "Right/Name_right"
local right_Score_path = "Right/Score_right"
local icon_light_left_path = "Left/icon_light_left"
local icon_light_right_path = "Right/icon_light_right"
local icon_right_path = "Right/icon_right"
local Score_right_title_path = "Right/Score_right_title"
local share_btn_path = "Right/btnShare"

local txtFightType_path = "Middle/txtFightType"
local txtFightRound_path = "Middle/txtFightRound"
local battleReport_btn_path = "Middle/btnBattleReport"
local battleReport_btn_text_path = "Middle/btnBattleReport/btnBattleReport_text"
local txtScore1_path = "Middle/txtScore1"
local txtScore2_path = "Middle/txtScore2"
local WinColor = Color.New(46/255, 100/255, 120/255, 1.0)
local LoseColor = Color.New(141/255, 68/255, 41/255, 1.0)
local Image_Bg_path = "Image_Bg"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.left_icon_bg = self:AddComponent(UIImage, left_icon_bg_path)
    self.left_icon = self:AddComponent(UIPlayerHead, left_icon_path)
    self.left_name = self:AddComponent(UIText, left_name_path)
    self.left_Score = self:AddComponent(UIText, left_Score_path)

    self.right_icon_bg = self:AddComponent(UIImage, right_icon_bg_path)
    self.right_icon = self:AddComponent(UIPlayerHead, right_icon_path)
    self.right_name = self:AddComponent(UIText, right_name_path)
    self.right_Score = self:AddComponent(UIText, right_Score_path)
    self.icon_light_left = self:AddComponent(UIImage, icon_light_left_path)
    self.icon_light_right = self:AddComponent(UIImage, icon_light_right_path)

    self.share_btn = self:AddComponent(UIButton, share_btn_path)
    self.share_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        --self:shareToRoom()
    end)
    
    self.txtFightType = self:AddComponent(UIText, txtFightType_path)
    self.txtFightRound = self:AddComponent(UIText, txtFightRound_path)
    self.battleReport_btn = self:AddComponent(UIButton, battleReport_btn_path)
    self.battleReport_btn_text = self:AddComponent(UIText, battleReport_btn_text_path)
    self.battleReport_btn_text:SetLocalText(310101)
    self.battleReport_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBattleReportClick()
    end)

    self.icon_left = self:AddComponent(UIImage, icon_left_path)
    self.icon_right = self:AddComponent(UIImage, icon_right_path)
    self.Image_Bg = self:AddComponent(UIImage, Image_Bg_path)
    self.txtScore1 = self:AddComponent(UIText, txtScore1_path)
    self.txtScore2 = self:AddComponent(UIText, txtScore2_path)
    self.left_head_btn = self:AddComponent(UIButton, left_head_btn_path)
    self.right_head_btn = self:AddComponent(UIButton, right_head_btn_path)
    self.Score_left_title = self:AddComponent(UIText, Score_left_title_path)
    self.Score_right_title = self:AddComponent(UIText, Score_right_title_path)
    self.Score_left_title:SetLocalText(302126)
    self.Score_right_title:SetLocalText(302126)

    self.left_head_btn:SetOnClick(function()
        if self._report == nil then
            return
        end
        local uid = self._report.winUid
        if self._report.loseUid == LuaEntry.Player.uid then
            uid = self._report.loseUid
        end
        if not string.IsNullOrEmpty(uid) then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self.view.ctrl:ShowPlayerInfo(uid)
        end
    end)

    self.right_head_btn:SetOnClick(function()
        if self._report == nil then
            return
        end
        local uid = self._report.loseUid
        if self._report.loseUid == LuaEntry.Player.uid then
            uid = self._report.winUid
        end
        if not string.IsNullOrEmpty(uid) then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
            self.view.ctrl:ShowPlayerInfo(uid)
        end
    end)
end

local function DataDefine(self)
    self. _index = 0
    self._report = nil
    self._fighters = nil
    self._enemyName = nil
    self._leftPlayerUid = nil
    self._rightPlayerUid = nil
    self._isEnableBattleButton = nil
end

local function ComponentDestroy(self)
    self.left_icon_bg = nil
    self.left_icon = nil
    self.left_name = nil
    self.left_Score = nil

    self.right_icon_bg = nil
    self.right_icon = nil
    self.right_name = nil
    self.right_Score = nil

    self.share_btn = nil

    self.txtFightType = nil
    self.txtFightRound = nil
    self.battleReport_btn = nil
    self.battleReport_btn_text = nil
    self.txtScore1 = nil
    self.txtScore2 = nil
end

local function DataDestroy(self)
    self. _index = nil
    self._report = nil
    self._fighters = nil
    self._enemyName = nil
    self._leftPlayerUid = nil
    self._rightPlayerUid = nil
    self._isEnableBattleButton = nil
end

local function GetTotalScore(self)
    if self._report ~= nil then
        local score = self._report.score
        if not string.IsNullOrEmpty(score) then
            local vec = string.split(score, "_")
            if table.count(vec) == 2 then
                local s1 = toInt(vec[1])
                local s2 = toInt(vec[2])
                local winUid = self._report["winUid"]
                local uid1 = self._report["uid1"]
                if LuaEntry.Player.uid == winUid then
                    if uid1 == winUid then
                        return s1, s2
                    else
                        return s2, s1
                    end
                else
                    if uid1 == winUid then
                        return s2, s1
                    else
                        return s1, s2
                    end
                end
            end
        end
    end
    return nil
end

local function GetWinScore(self)
    local winRecord = self._report.winRecord
    if string.IsNullOrEmpty(winRecord) and self._report["phase"] ~= 0 then
        local reportData = DataCenter.ActChampionBattleManager:GetChampionBattleReportList()
        if reportData == nil or reportData.fightResult == nil then
            return 0, 0
        end
        for k, v in pairs(reportData.fightResult) do
            if v["phase"] == self._report["phase"] and not string.IsNullOrEmpty(v.winRecord) then
                winRecord = v.winRecord
                break
            end
        end
    end
    if string.IsNullOrEmpty(winRecord) then
        return 0, 0
    end
    local list = string.split(winRecord, ",")
    if list == nil then
        return 0, 0
    end
    local total = table.count(list)
    if total == 0 then
        return 0, 0
    end
    
    local round = self._report.round or 1
    round = math.min(total, math.max(1, round)) 
    local scoreString = list[round]
    local scoreList = string.split(scoreString, "_")
    
    local leftScore = scoreList[1] or 0
    local rightScore = scoreList[2] or 0
    local big = leftScore > rightScore and leftScore or rightScore
    local small = leftScore > rightScore and rightScore or leftScore
    return big, small
end

local function SetData(self, report, fighters)
    self._report = report;
    self._fighters = fighters;

    --标题
    local langId = "302047";
    local fightType = report["phase"];

    if fightType == Activity_ChampionBattle_Elite_Stage_State.GROUP_QUARTER_PHASE then
        langId = "308048";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.GROUP_SEMI_PHASE then
        langId = "308049";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.GROUP_FINAL_PHASE then
        langId = "308050";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.QUARTER_PHASE then
        langId = "302031";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.SEMI_PHASE then
        langId = "302067";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.FINAL_PHASE then
        langId = "302068";
    end
    self.txtFightType:SetLocalText(langId)

    --第N场
    --printError("round => "..report["round"]);
    self.txtFightRound:SetLocalText(302069, report["round"])
    self.share_btn:SetActive(false)
    --自己的比賽顯示分享按鈕,否則不顯示
    local isHaveMyseft = false;
    local isMyselfWinner = true;
    self._isEnableBattleButton = false;
    
    if report["winUid"] ~= nil and LuaEntry.Player.uid == report["winUid"] then
        isMyselfWinner = true;
        isHaveMyseft = true;
    elseif report["loseUid"] ~= nil and LuaEntry.Player.uid == report["loseUid"] then
        isMyselfWinner = false;
        isHaveMyseft = true;
    else
        isHaveMyseft = false;
    end
    local big, small = self:GetWinScore()
    -- 自己永远在左侧
    if isHaveMyseft and isMyselfWinner == false then
        self._leftPlayerUid = report["loseUid"];
        self._rightPlayerUid = report["winUid"];
        
        --失败者
        local serverName1, unionName1, playerName1, pic1, picVer1, headFrame1, headSkinId1, headSkinET1 = self:GetFighterInfo(report["loseUid"]);
        --printError("winner: name => "..name1..", pic => "..pic1..", picVer => "..picVer1);
        if playerName1 ~= nil and playerName1 ~= "" then
            --玩家名称
            self.left_name:SetText(serverName1..unionName1..playerName1);
            
            --玩家头像
            self.view.ctrl:SetHeadImg(self.left_icon, self.left_icon_bg, report["loseUid"], pic1, picVer1, headFrame1, headSkinId1, headSkinET1)
        else
            self._isEnableBattleButton = true;

            --玩家名称
            self.right_name:SetLocalText(312059)
            --頭像顯示問號
            self.view.ctrl:SetHeadImg(self.left_icon, self.left_icon_bg, "", pic1, picVer1, 0, nil, nil)
        end
        
        -- 积分
        self.txtScore1:SetText(tostring(small))
        self.txtScore2:SetText(tostring(big))
        
        --胜利者
        local serverName2, unionName2, playerName2, pic2, picVer2, headFrame2, headSkinId2, headSkinET2 = self:GetFighterInfo(report["winUid"]);
        --printError("loser: name => "..name2..", pic => "..pic2..", picVer => "..picVer2);
        if playerName2 ~= nil and playerName2 ~= "" then
            --玩家名称
            self.right_name:SetText(serverName2..unionName2..playerName2);
            --玩家头像
            self.view.ctrl:SetHeadImg(self.right_icon, self.right_icon_bg, report["winUid"], pic2, picVer2, headFrame2, headSkinId2, headSkinET2)
        else
            self._isEnableBattleButton = true;

            --玩家名称
            self.right_Score:SetLocalText(312059)
            --頭像顯示問號
            self.view.ctrl:SetHeadImg(self.right_icon, self.right_icon_bg, "", pic2, picVer2, 0, nil, nil)
        end
        
        --背景图片翻转显示
        self.Image_Bg.transform.localScale = Vector3.New(-1,1,1);
        --
        self.icon_left:LoadSprite("Assets/Main/Sprites/UI/UIChampion/UIchampion_img_lose")
        self.icon_right:LoadSprite("Assets/Main/Sprites/UI/UIChampion/UIchampion_img_win")
        self.icon_light_left:SetActive(false);
        self.icon_light_right:SetActive(true);
        self.left_name:SetColor(LoseColor)
        self.right_name:SetColor(WinColor)
        self.Score_left_title:SetColor(LoseColor)
        self.Score_right_title:SetColor(WinColor)
        --self.share_btn:SetActive(not string.IsNullOrEmpty(self._leftPlayerUid) and not string.IsNullOrEmpty(self._rightPlayerUid))

    else
        self._leftPlayerUid = report["winUid"];
        self._rightPlayerUid = report["loseUid"];
        --self.share_btn:SetActive(false)

        --胜利者
        local serverName1, unionName1, playerName1, pic1, picVer1, headFrame1, headSkinId1, headSkinET1 = self:GetFighterInfo(report["winUid"]);
        if playerName1 ~= nil and playerName1 ~= "" then
            --玩家名称
            self.left_name:SetText(serverName1..unionName1..playerName1);
            --玩家头像
            self.view.ctrl:SetHeadImg(self.left_icon, self.left_icon_bg, report["winUid"], pic1, picVer1, headFrame1, headSkinId1, headSkinET1)
        else
            self._isEnableBattleButton = true;

            --玩家名称
            self.right_name:SetLocalText(312059);
            --頭像顯示問號
            self.view.ctrl:SetHeadImg(self.left_icon, self.left_icon_bg, "", pic1, picVer1, 0, nil, nil)
        end
        
        -- 积分
        --if fightType == 0 then
        --    self.left_Score:SetLocalText(302066, "+"..report["winScore"])
        --    self.left_Score:SetColorRGBA(191/255, 211/255, 231/255, 1)
        --end
        -- 积分
        self.txtScore1:SetText(tostring(big))
        self.txtScore2:SetText(tostring(small))

        --失败者
        local serverName2, unionName2, playerName2, pic2, picVer2, headFrame2, headSkinId2, headSkinET2 = self:GetFighterInfo(report["loseUid"]);
        if playerName2 ~= nil and playerName2 ~= "" then
            --玩家名称
            self.right_name:SetText(serverName2..unionName2..playerName2);
            --玩家头像
            self.view.ctrl:SetHeadImg(self.right_icon, self.right_icon_bg, report["loseUid"], pic2, picVer2, headFrame2, headSkinId2, headSkinET2)
        else
            self._isEnableBattleButton = true;

            --玩家名称
            self.right_name:SetLocalText(312059)
            --頭像顯示問號
            self.view.ctrl:SetHeadImg(self.right_icon, self.right_icon_bg, "", pic2, picVer2, 0, nil, nil)
        end

        --海选赛显示积分, 否则不显示
        --self.right_Score:SetActive(fightType == 0);
        
        --背景图片翻转显示UI_img_AllianceShowdown_win_small
        self.Image_Bg.transform.localScale = Vector3.one;

        self.icon_left:LoadSprite("Assets/Main/Sprites/UI/UIChampion/UIchampion_img_win")
        self.icon_right:LoadSprite("Assets/Main/Sprites/UI/UIChampion/UIchampion_img_lose")
        self.icon_light_left:SetActive(true);
        self.icon_light_right:SetActive(false);
        self.left_name:SetColor(WinColor)
        self.right_name:SetColor(LoseColor)
        self.Score_left_title:SetColor(WinColor)
        self.Score_right_title:SetColor(LoseColor)
    end
    local score1, score2 = self:GetTotalScore()
    if score1 == nil then
        self.Score_left_title:SetActive(false)
        self.Score_right_title:SetActive(false)
        self.right_Score:SetActive(false)
        self.left_Score:SetActive(false)
    else
        self.Score_left_title:SetActive(true)
        self.Score_right_title:SetActive(true)
        self.right_Score:SetActive(true)
        self.left_Score:SetActive(true)

        self.left_Score:SetText(score1)
        self.right_Score:SetText(score2)
    end
    --self.txtScore1:SetText("")
    --self.txtScore2:SetText("")
    UIGray.SetGray(self.battleReport_btn.transform, self._isEnableBattleButton, not self._isEnableBattleButton)
end

local function GetFighterInfo(self, fightersId)
    local serverName = "";
    local unionName = " ";
    local playerName = "";
    local pic = "";
    local picVer = 0;
    local headFrame = 0
    local headSkinId = nil
    local headSkinET = nil

    for i = 1, #self._fighters do
        if self._fighters[i]["uid"] == fightersId then
            if self._fighters[i]["name"] ~= nil then
                playerName = self._fighters[i]["name"];
            end

            if self._fighters[i]["serverId"] ~= nil then
                serverName = "#"..self._fighters[i]["serverId"];
            end

            if self._fighters[i]["headFrame"] ~= nil then
                headFrame = self._fighters[i]["headFrame"];
            end

            if self._fighters[i]["abbr"] ~= nil and self._fighters[i]["abbr"] ~= "" then
                unionName = "["..self._fighters[i]["abbr"].."]";
            end

            if self._fighters[i]["pic"] ~= nil then
                pic = self._fighters[i]["pic"];
            end

            if self._fighters[i]["picver"] ~= nil then
                picVer = self._fighters[i]["picver"];
            end
            if self._fighters[i]["headSkinId"] ~= nil then
                headSkinId = self._fighters[i]["headSkinId"];
            end
            if self._fighters[i]["headSkinET"] ~= nil then
                headSkinET = self._fighters[i]["headSkinET"];
            end

            break;
        end
    end
    return serverName, unionName, playerName, pic, picVer, headFrame, headSkinId, headSkinET;
end

--------------------------------------------------
function ChampionBattleFightItem:onClick_btnBattleReport(self)
    if self._isEnableBattleButton == true then 
        return
    end
    
    if self._report == nil then
        return
    end
end

function ChampionBattleFightItem:onClick_btnShare(self)
    if self._report == nil then
        return;
    end

    if self._report["type"] == nil or self._report["reportId"] == nil then
        return;
    end
end

function ChampionBattleFightItem:onClick_btnLeftHeadIcon(self)
	if string.IsNullOrEmpty(self._leftPlayerUid) then 
        return
    end
	--AccountManager.showPlayerInfoView(self._leftPlayerUid);
end

function ChampionBattleFightItem:onClick_btnRightHeadIcon(self)
    if string.IsNullOrEmpty(self._rightPlayerUid) then
        return
    end
    
	--AccountManager.showPlayerInfoView(self._rightPlayerUid);
end

local function GetShareMsg(self)
    local langId = "302047"
    local fightType = self._report["phase"]
    if fightType == Activity_ChampionBattle_Elite_Stage_State.GROUP_QUARTER_PHASE then
        langId = "308048";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.GROUP_SEMI_PHASE then
        langId = "308049";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.GROUP_FINAL_PHASE then
        langId = "308050";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.QUARTER_PHASE then
        langId = "302031";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.SEMI_PHASE then
        langId = "302067";
    elseif fightType == Activity_ChampionBattle_Elite_Stage_State.FINAL_PHASE then
        langId = "302068";
    end

    local str = Localization:GetString("302114", Localization:GetString(langId)).."\n"
    local serverName1, unionName1, playerName1, pic1, picVer1, headFrame1, headSkinId1, headSkinET1 = self:GetFighterInfo(self._report["winUid"])
    local serverName2, unionName2, playerName2, pic2, picVer2, headFrame2, headSkinId2, headSkinET2 = self:GetFighterInfo(self._report["loseUid"])
    local GetNameStr = function(abbr, name)
        if string.IsNullOrEmpty(abbr) then
            return name
        end
        return abbr..name
    end
    local name1
    local name2
    if self._report["winUid"] ~= nil and LuaEntry.Player.uid == self._report["winUid"] then
        name1 = GetNameStr(unionName1, playerName1)
        name2 = self.right_name:GetText(unionName2, playerName2)
        str = str..Localization:GetString("302115", GetNameStr(unionName1, playerName1), self.right_name:GetText(unionName2, playerName2))
    else
        name1 = GetNameStr(unionName2, playerName2)
        name2 = self.right_name:GetText(unionName1, playerName1)

        str = str..Localization:GetString("302115", GetNameStr(unionName2, playerName2), self.right_name:GetText(unionName1, playerName1))
    end

    return str, "302114", langId, "302115", name1, name2
end

local function GetShareTitle(self)
    local selfWin = false
    if self._report["winUid"] ~= nil and LuaEntry.Player.uid == self._report["winUid"] then
        selfWin = true;
    end

    local str = ""
    local big, small = self:GetWinScore()
    local dialog1 = ""
    if selfWin == false then
        dialog1 = "390187"
        str = Localization:GetString("390187")
    else
        dialog1 = "390186"
        str = Localization:GetString("390186")
    end
    str = str..Localization:GetString("302113")
    local score1 = big
    local score2 = small
    if selfWin == true then
        str = str..tostring(big)..": "..tostring(small)
    else
        score1 = small
        score2 = big
        str = str..tostring(small)..": "..tostring(big)
    end
    return str, dialog1, "302113", score1, score2
end

local function shareToRoom(self)
    local para = {}
    para.type = self._report["type"]
    para.reportId = self._report["reportId"]
    para.msg = self:GetShareMsg()
    para.title = self:GetShareTitle()
    para.isWin = LuaEntry.Player.uid == self._report["winUid"]
    local share_param = {}
    share_param.name = ""
    share_param.para = para
    share_param.postType = PostType.Text_ChampionBattleReportShare
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIPositionShare, {anim = true}, share_param)
end

local function OnBattleReportClick(self)
    if self._isEnableBattleButton == true then
        return
    end
    if self.isSendReport == true then
        return 
    end
    self.isSendReport = true

    DataCenter.ActChampionBattleManager:SendActChampionBattleReportDescCmd(self._report["type"], self._report["reportId"])
    self:AddUIListener(EventId.ChampionBattleReportDataBack, self.OnChampionBattleReportDataBack)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    if self.isSendReport == true then
        self:RemoveUIListener(EventId.ChampionBattleReportDataBack,self.OnChampionBattleReportDataBack)
    end
end

local function OnChampionBattleReportDataBack(self, data)
    local share_param = nil
    self.isSendReport = false
    self:RemoveUIListener(EventId.ChampionBattleReportDataBack,self.OnChampionBattleReportDataBack)
    if data == nil then
        return
    end
    if not string.IsNullOrEmpty(self._leftPlayerUid) and not string.IsNullOrEmpty(self._rightPlayerUid) then
        local para = {}
        para.type = self._report["type"]
        para.reportId = self._report["reportId"]
        para.msg, para.contentDialogId1, para.contentDialogId2, para.contentDialogId3, para.contentName1, para.contentName2 = self:GetShareMsg()
        para.title, para.titleDialogId1, para.titleDialogId2, para.score1, para.score2 = self:GetShareTitle()
        para.isWin = LuaEntry.Player.uid == self._report["winUid"]
        share_param = {}
        share_param.name = ""
        share_param.para = para
        share_param.postType = PostType.Text_ChampionBattleReportShare
    end

    UIManager:GetInstance():OpenWindow(UIWindowNames.UIShareMail, NormalBlurPanelAnim, data, share_param)
end
--------------------------------------------------
ChampionBattleFightItem.OnCreate = OnCreate
ChampionBattleFightItem.OnDestroy = OnDestroy
ChampionBattleFightItem.OnAddListener = OnAddListener
ChampionBattleFightItem.OnRemoveListener = OnRemoveListener

ChampionBattleFightItem.ComponentDefine = ComponentDefine
ChampionBattleFightItem.DataDefine = DataDefine
ChampionBattleFightItem.ComponentDestroy = ComponentDestroy
ChampionBattleFightItem.DataDestroy = DataDestroy
ChampionBattleFightItem.SetData = SetData
ChampionBattleFightItem.GetFighterInfo = GetFighterInfo
ChampionBattleFightItem.OnBattleReportClick = OnBattleReportClick
ChampionBattleFightItem.shareToRoom = shareToRoom
ChampionBattleFightItem.GetShareMsg = GetShareMsg
ChampionBattleFightItem.GetShareTitle = GetShareTitle
ChampionBattleFightItem.GetWinScore = GetWinScore
ChampionBattleFightItem.GetTotalScore = GetTotalScore
ChampionBattleFightItem.OnChampionBattleReportDataBack = OnChampionBattleReportDataBack

return ChampionBattleFightItem

