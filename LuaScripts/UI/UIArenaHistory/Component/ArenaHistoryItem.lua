---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/6/7 18:43
---
---
local ArenaHistoryItem = BaseClass("ArenaHistoryItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local playerHead_path = "rankInfo/playerFlag/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "rankInfo/playerFlag/UIPlayerHead/Foreground"
local playerName_path = "rankInfo/playerName"
local playerHeadBtn_path = "rankInfo/playerFlag/UIPlayerHead"
local addScore_path = "rankInfo/addScore"
local fightBtn_path = "rankInfo/layout/fightBtn"
local fightBtnTxt_path = "rankInfo/layout/fightBtn/layout/fightBtnTxt"
local costTicket_path = "rankInfo/layout/fightBtn/layout/fightCost"
local costTicketNum_path = "rankInfo/layout/fightBtn/layout/fightCost/costTicketNum"
local resultWin_path = "rankInfo/win_bg"
local resultWinText_path = "rankInfo/win_bg/result_win"
local resultlose_path = "rankInfo/lose_bg"
local resultloseText_path = "rankInfo/lose_bg/result_lose"
local replay_btn_path = "rankInfo/layout/btnRelay"
local replay_txt_path = "rankInfo/layout/btnRelay/btnRelayTxt"
local power_path = "rankInfo/power"
-- 创建
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
local function ComponentDefine(self)
    self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
    self.playerHeadFgN = self:AddComponent(UIImage, playerHeadFg_path)
    self.playerNameN = self:AddComponent(UITextMeshProUGUIEx, playerName_path)
    self.playerHeadBtnN = self:AddComponent(UIButton, playerHeadBtn_path)
    self.playerHeadBtnN:SetOnClick(function()
        self:OnClickPlayerHeadBtn()
    end)
    self.addScoreN = self:AddComponent(UITextMeshProUGUIEx, addScore_path)
    self.fightBtnN = self:AddComponent(UIButton, fightBtn_path)
    self.fightBtnN:SetOnClick(function()
        self:OnClickChallengeBtn()
    end)
    self.fightBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, fightBtnTxt_path)
    self.fightBtnTxtN:SetLocalText(372264)
    self.powerN = self:AddComponent(UITextMeshProUGUIEx, power_path)
    self.costTicketN = self:AddComponent(UIBaseContainer, costTicket_path)
    self.costTicketNumN = self:AddComponent(UITextMeshProUGUIEx, costTicketNum_path)
    self.resultWinN = self:AddComponent(UIBaseContainer, resultWin_path)
    self.resultloseN = self:AddComponent(UIBaseContainer, resultlose_path)
    self.resultWinTextN = self:AddComponent(UITextMeshProUGUIEx, resultWinText_path)
    self.resultloseTextN = self:AddComponent(UITextMeshProUGUIEx, resultloseText_path)
    self.replay_btn = self:AddComponent(UIButton, replay_btn_path)
    self.replay_btn:SetOnClick(function()
        self:OnClickRePlayBtn()
    end)
    self.replay_txt = self:AddComponent(UITextMeshProUGUIEx, replay_txt_path)
    self.replay_txt:SetLocalText(100092)
end

--控件的销毁
local function ComponentDestroy(self)
end

--变量的定义
local function DataDefine(self)
    self.rankInfo = nil
    self.heroItems = {}
    self.isShowHeroes = false
end

--变量的销毁
local function DataDestroy(self)
    self.rankInfo = nil
    self.heroItems = {}
    self.isShowHeroes = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    --self:AddUIListener(EventId.OnClaimRewardEffFinish, self.RefreshNeed)

end

local function OnRemoveListener(self)
    --self:RemoveUIListener(EventId.OnClaimRewardEffFinish, self.RefreshNeed)
    base.OnRemoveListener(self)
end


--param = {showChallenge = false,}
local function SetItem(self, rankInfo, params)
    self.rankInfo = rankInfo
    self.index = params and params.index or 1
    self.isShowHeroes = params and params.isShowHeroes or false
    self.showHeroesCallBack = params and params.callback or nil
    if not self.rankInfo then
        return
    end
    
    self:RefreshAll()
end

local function RefreshAll(self)
    if self.rankInfo.type == 0 then
        self.playerNameN:SetLocalText(100184)
        self.powerN:SetText(string.GetFormattedStr(self.rankInfo.power))
    else
        self.playerHeadN:SetData(self.rankInfo.uid, self.rankInfo.pic, self.rankInfo.picVer)
        local tempAbbr = not string.IsNullOrEmpty(self.rankInfo.abbr) and "[" .. self.rankInfo.abbr .. "]" or ""
        self.playerNameN:SetText(tempAbbr .. self.rankInfo.name)
        self.powerN:SetText(string.GetFormattedStr(self.rankInfo.power))
    end
    self.resultloseN:SetActive(false)
    self.resultWinN:SetActive(false)
    if self.rankInfo.addScore > 0 then
        self.addScoreN:SetText("+" .. self.rankInfo.addScore)
        self.addScoreN:SetColor(Color.New(136/255, 228/255, 55/255,1))
        self.resultWinTextN:SetLocalText(390186)
        --self.resultN:LoadSprite("Assets/Main/TextureEx/UIArena/img_arena_win.png")--:SetLocalText(390186)
        self.fightBtnN:SetActive(false)
        self.resultWinN:SetActive(true)
    else
        self.resultloseTextN:SetLocalText(390187)
        self.addScoreN:SetText(self.rankInfo.addScore)
        self.addScoreN:SetColor(Color.New(221/255, 40/255, 40/255,1))
        --self.resultN:LoadSprite("Assets/Main/TextureEx/UIArena/img_arena_lose.png")
        self.resultloseN:SetActive(true)

        self.fightBtnN:SetActive(true)
        local selfInfo = DataCenter.ArenaManager:GetSelfInfo()
        local maxChallengeTimes = LuaEntry.DataConfig:TryGetNum("arena","k2")
        local remainTimes = maxChallengeTimes - selfInfo.fightTimes
        if remainTimes > 0 then
            self.costTicketN:SetActive(false)
            --self.costTicketNumN:SetLocalText(130126)
            CS.UIGray.SetGray(self.fightBtnN.transform, false, true)
        else
            local good = DataCenter.ItemData:GetItemById(ArenaTicketId)
            local num = good and good.count or 0
            if num > 0 then
                self.costTicketN:SetActive(false)
                --self.costTicketNumN:SetText("x1")
                CS.UIGray.SetGray(self.fightBtnN.transform, false, true)
            else
                self.costTicketN:SetActive(false)
                CS.UIGray.SetGray(self.fightBtnN.transform, true, false)
            end
        end
    end
end

local function OnClickChallengeBtn(self)
    local canFight, tipId = DataCenter.ArenaManager:CheckIfCanChallenge()
    if not canFight then
        UIUtil.ShowTipsId(tipId)
        return
    end

    self.view.ctrl:CloseSelf()
    self.view.ctrl:CloseSelf()
    DataCenter.ArenaManager:CacheUIName(UIWindowNames.UIArenaChallenge)
    DataCenter.ArenaManager:SetTargetEnemyInfo(self.rankInfo)
    local param = {}
    param.scene = "PveScene1"
    param.pveEntrance = PveEntrance.ArenaBattle
    DataCenter.BattleLevel:Enter(param)
end

local function OnClickPlayerHeadBtn(self)
    if self.rankInfo and self.rankInfo.type == 1 then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,self.rankInfo.uid)
    end
end

local function OnClickRePlayBtn(self)
    if self.rankInfo and self.rankInfo.uuid~=0 then
        SFSNetwork.SendMessage(MsgDefines.UserGetArenaReport,self.rankInfo.uuid)
    end
end

ArenaHistoryItem.OnCreate = OnCreate
ArenaHistoryItem.OnDestroy = OnDestroy
ArenaHistoryItem.ComponentDefine = ComponentDefine
ArenaHistoryItem.ComponentDestroy = ComponentDestroy
ArenaHistoryItem.DataDefine = DataDefine
ArenaHistoryItem.DataDestroy = DataDestroy
ArenaHistoryItem.OnAddListener = OnAddListener
ArenaHistoryItem.OnRemoveListener = OnRemoveListener

ArenaHistoryItem.SetItem = SetItem
ArenaHistoryItem.RefreshAll = RefreshAll
ArenaHistoryItem.OnClickChallengeBtn = OnClickChallengeBtn
ArenaHistoryItem.OnClickPlayerHeadBtn = OnClickPlayerHeadBtn
ArenaHistoryItem.OnClickRePlayBtn =OnClickRePlayBtn
return ArenaHistoryItem