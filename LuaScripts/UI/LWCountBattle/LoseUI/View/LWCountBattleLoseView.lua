local LWCountBattleLoseView = BaseClass("LWCountBattleLoseView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

function LWCountBattleLoseView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:RefreshView()
    self:Show()
    self.waitingForMsg = false
end

function LWCountBattleLoseView:OnDestroy()
    base.OnDestroy(self)
end

function LWCountBattleLoseView:ComponentDefine()
    self.canvasGroup = self.transform:Find("safearea").gameObject:GetComponent(typeof(CS.UnityEngine.CanvasGroup))
    self.canvasGroup.alpha = 0
    self.tryAgainBtn = self:AddComponent(UIButton, "safearea/btnLayout/TryAgainBtn")
    self.tryAgainBtn:SetOnClick(function()
        self:OnTryAgainBtnClick()
    end)
    self.tryAgainBtnText = self:AddComponent(UIText,"safearea/btnLayout/TryAgainBtn/TryAgainBtnText")
    self.tryAgainBtnText:SetText(Localization:GetString("134021"))--再来一次
    self.backBtn = self:AddComponent(UIButton, "safearea/btnLayout/BackBtn")
    self.backBtn:SetOnClick(function()
        self:OnBackBtnClick()
    end)
    self.backBtnText = self:AddComponent(UIText,"safearea/btnLayout/BackBtn/BackBtnText")
    self.backBtnText:SetText(Localization:GetString("800306"))--返回基地
    self.jumpBtn = self:AddComponent(UIButton, "safearea/btnLayout/JumpBtn")
    self.jumpBtn:SetOnClick(function()
        self:OnJumpBtnClick()
    end)
    self.jumpBtnText = self:AddComponent(UIText,"safearea/btnLayout/JumpBtn/JumpBtnText")
    self.jumpBtnText:SetLocalText("110171")--跳过
    self.defeatText = self:AddComponent(UIText,"safearea/BattleDefeatPanel_ani/DefeatGo/DefeatText")
    self.defeatText:SetText(Localization:GetString("311106"))
    
    self.levelText = self:AddComponent(UIText,"safearea/LevelText")
    self.timeText = self:AddComponent(UIText,"safearea/TimeText")
    self.killNumText = self:AddComponent(UIText,"safearea/KillNumText")

    local param = self:GetUserData()
    local stageId = param.stageId

    --self.backBtn:SetActive(not (DataCenter.LWGuideManager:GetCurGuideId() < GuideState.CityCopter))
    self.backBtn:SetActive(true)
    self.levelText:SetLocalText(GetTableData(LuaEntry.Player:GetABTestTableName(TableName.LW_Count_Stage), stageId,'name'),GetTableData(TableName.LW_Count_Stage, stageId,'order'))

end

function LWCountBattleLoseView:ComponentDestroy()
    self.back_btn = nil
end

function LWCountBattleLoseView:RefreshView()
    local param = self:GetUserData()
    local time = param.time
    local kill = param.kill
    local canSkip = param.canSkip
    self.killNumText:SetText( Localization:GetString("800303") .. " "..kill)
    self.timeText:SetText( Localization:GetString("800304").." "..UITimeManager:GetInstance():SecondToFmtStringWithoutHour(time))
    self.backBtn:SetActive(false)
    self.jumpBtn:SetActive(true)
end

function LWCountBattleLoseView:Show()
    TimerManager:GetInstance():DelayInvoke(function()
        self.canvasGroup:DOFade(1,0.2)
    end,1.5)
end

function LWCountBattleLoseView:OnBackBtnClick()
    if self.waitingForMsg then return end

    self.ctrl:CloseSelf()
    --承认失败并退出
    DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
    DataCenter.LWBattleManager:Exit(nil, "lose")
    --打点
    local myStageId = self:GetUserData().stageId
    --PostEventLog.Track(PostEventLog.Defines.BattleCountSkip,{stageId=myStageId,isSkip=2,})
end

function LWCountBattleLoseView:OnTryAgainBtnClick()
    if self.waitingForMsg then return end

    self.ctrl:CloseSelf()
    --承认失败并再战
    DataCenter.LWBattleManager:GetCurBattleLogic():NoticeLose()
    DataCenter.LWBattleManager:Restart()
    --打点
    local myStageId = self:GetUserData().stageId
    --PostEventLog.Track(PostEventLog.Defines.BattleCountSkip,{stageId=myStageId,isSkip=1,})
end

function LWCountBattleLoseView:OnJumpBtnClick()
    if self.waitingForMsg then return end

    self.waitingForMsg = true
    --强行胜利
    self:AddUIListener(EventId.PVEBattleVictoryConfirmed, self.OnJumpConfirmed)
    DataCenter.LWBattleManager:GetCurBattleLogic():NoticeWin()

    --打点
    local battleLogic = DataCenter.LWBattleManager:GetCurBattleLogic()
    local myStageId = tostring(battleLogic:GetStageId())
    --PostEventLog.Track(PostEventLog.Defines.BattleCountSkip,{stageId=myStageId,isSkip=0,})
end

function LWCountBattleLoseView:OnJumpConfirmed(pveType)
    if pveType == PVEType.Count then
        self:RemoveUIListener(EventId.PVEBattleVictoryConfirmed, self.OnJumpConfirmed)
        self.ctrl:CloseSelf()
        DataCenter.LWBattleManager:Exit(nil, "win")
    end
end

function LWCountBattleLoseView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function LWCountBattleLoseView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnKeyCodeEscape, self.OnKeyCodeEscape)
end

function LWCountBattleLoseView:OnKeyCodeEscape()
    TimerManager:GetInstance():DelayFrameInvoke(function()
        self:OnBackBtnClick()
    end, 1)
end

return LWCountBattleLoseView
