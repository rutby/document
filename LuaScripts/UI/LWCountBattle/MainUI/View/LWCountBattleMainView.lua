local Const = require("Scene.LWBattle.Const")
local LWCountBattleMainView = BaseClass("LWCountBattleMainView",UIBaseView)
local base = UIBaseView

function LWCountBattleMainView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

function LWCountBattleMainView:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

function LWCountBattleMainView:ComponentDefine()
    if CS.CommonUtils.IsDebug() then
        self.GMText = self:AddComponent(UIText,"GmWinBtn/GMText")
        self.GMText:SetText(DataCenter.LWBattleManager:GetCurBattleLogic():GetStageId())
        self.gm_win_btn = self:AddComponent(UIButton, "GmWinBtn")
        self.gm_win_btn:SetOnClick(function()
            DataCenter.LWBattleManager:GetCurBattleLogic().playerGroupProxy.group.DisableLogic = true
            DataCenter.LWBattleManager:GetCurBattleLogic():OnBattleWin()
        end)
        self.jump_guide_btn = self:AddComponent(UIButton,"Guide/jumpGuide")
        self.jump_guide_btn:SetOnClick(function()
            DataCenter.LWGuideManager:ClearData()
            DataCenter.LWBattleManager:SetGamePause(false)
            DataCenter.LWBattleManager:GetCurBattleLogic():OnBattleWin()
            local CanvasNormal = UIManager:GetInstance():GetLayer(UILayer["Scene"]["Name"])
            if CanvasNormal then
                CanvasNormal.gameObject:SetActive(true)
            end
            SFSNetwork.SendMessage(MsgDefines.LWSaveGuide,GuideState.Over)
        end
        )
    else
        self.transform:Find("Guide/jumpGuide").gameObject:SetActive(false)
        self.transform:Find("GmWinBtn").gameObject:SetActive(false)
    end

    self.winConditionNode = self:AddComponent(UIBaseComponent,"WinCondition")
    self.winConditionNode:SetActive(false)
    self.winConditionArea = self.transform:Find("WinCondition")
    self.winConditionIcon = self:AddComponent(UIImage,"WinCondition/WinIcon")
    self.winConditionSlider = self:AddComponent(UISlider,"WinCondition/Slider")
    self.winConditionSliderEff = self:AddComponent(UIBaseComponent,"WinCondition/Slider/Eff_ui_beizengmen_guanka_jindu")
    self.winConditionSliderEff:SetActive(false)
    self.winConditionBarImg = self:AddComponent(UIImage,"WinCondition/Slider/FillArea/Fill")
    self.winConditionText = self:AddComponent(UIText,"WinCondition/WinBarText")
    self.winConditionIconView = self:AddComponent(UIBaseContainer, "WinCondition/WinIconList")
    self.winConditionIconListHolder = self.transform:Find( "WinCondition/WinIconList/List")
    self.winConditionIconListCell = {}
    
    if self.winConditionIconListHolder then
        for _, transform in pairs(self.winConditionIconListHolder) do
            transform.gameObject:Destroy()
        end
    end
    
    self.animator = self:AddComponent(UIAnimator,"")

    self.winBanner = self:AddComponent(UIBaseComponent, "WinBanner")
    self.winBanner:SetActive(false)
    self.winBannerTxt = self:AddComponent(UIText, "WinBanner/WinBannerText")
    self.winBannerTxt:SetLocalText(GameDialogDefine.MISSION_COMPLETE)

    self.back_btn = self:AddComponent(UIButton, "BackBtn")
    self.back_btn:SetActive(true)
    self.back_btn:SetOnClick(function()
        self:OnExitBtnClick()
    end)

    self.startGame_Btn = self:AddComponent(UIButton, "Guide/btnContent/startGameBtn")
    self.startGame_text = self:AddComponent(UIText, "Guide/btnContent/startGameBtn/Text")
    self.startGame_text:SetLocalText(100833)
    self.startGame_Btn:SetOnClick(function ()
        self:OnStartGameClick()
    end)

    self.loginGameBtn = self:AddComponent(UIButton, "Guide/btnContent/loginGameBtn")
    self.loginBtnText = self:AddComponent(UIText, "Guide/btnContent/loginGameBtn/loginBtnText")
    self.loginBtnText:SetLocalText(110008)
    self.loginGameBtn:SetOnClick(function ()
        self:OnLoginGameClick()
    end)
    local state = DataCenter.AccountManager:GetAccountBindState()
    self.loginGameBtn:SetActive(state ~= AccountBandState.Band)
    
    if CS.GameEntry.Setting.IsReview then
        self.loginGameBtn:SetActive(false)
    end

    local param = self:GetUserData()
    self.guide = self.transform:Find("Guide").gameObject
    self.guide:SetActive(param.showGuide)
    self.back_btn:SetActive(not param.showGuide)
    self.punchOK=0
end

function LWCountBattleMainView:ComponentDestroy()
    self.back_btn = nil
    if self.winConditionIconListHolder then
        for _, transform in pairs(self.winConditionIconListHolder) do
            transform.gameObject:Destroy()
        end
    end
end

function LWCountBattleMainView:SetWinConditionBar(percent)
    if not self.transform then return end
    self.winConditionSlider:SetValue(Mathf.Clamp(percent, 0, 1))
    if percent>=1 then
        self.winConditionSliderEff:SetActive(true)
    end
end

function LWCountBattleMainView:SetWinConditionText(txt, punch)
    if not self.transform then return end
    if self.winConditionText and self.winConditionText:GetText() ~= txt then
        self.winConditionText:SetText(txt)
        if punch then
            local now = UITimeManager:GetInstance():GetServerTime()
            if self.punchOK < now then
                self.punchOK=now+PUNCH_CD*1000
                self.winConditionText.transform:DOKill()
                self.winConditionText.transform:Set_localScale(1,1,1)
                self.winConditionText.transform:DOPunchScale(Vector3.New(1,1,1),PUNCH_CD,1,0.4)
            end
        end
    end
end

function LWCountBattleMainView:OnAddListener()
    base.OnAddListener(self)
end

function LWCountBattleMainView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function LWCountBattleMainView:OnStartGameClick()
    DataCenter.LWSoundManager:PlaySound(10002)
    self.guide:SetActive(false)
    DataCenter.LWGuideManager:GuideStartGame()
end

function LWCountBattleMainView:OnLoginGameClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseSwitchAccount, 110008)
end

function LWCountBattleMainView:OnExitBtnClick()
    if DataCenter.LWBattleManager.logic.winTimer or DataCenter.LWBattleManager.gameOver then
        return
    end
    self:OnExit()
end

function LWCountBattleMainView:OnExit()
    --中途退出打点
    --PostEventLog.BattleResultLog(PVEType.Count, 2)
    self.ctrl:CloseSelf()
    DataCenter.LWBattleManager:Exit(nil, "quit")
end

function LWCountBattleMainView:OnBattleWin()
    self.back_btn:SetActive(false)
    self.winBanner:SetActive(true)
    self.animator:Play("Eff_ui_beizengmen_mubiao_wancheng", 0, 0)
    TimerManager:GetInstance():DelayInvoke(function()
        if self.winBanner then
            self.winBanner:SetActive(false)
        end
        if self.winConditionNode then
            self.winConditionNode:SetActive(false)
        end
    end, 1.8)
end

function LWCountBattleMainView:OnBattleLose()
    self.back_btn:SetActive(false)
end

function LWCountBattleMainView:UpdateEndType2Condition(total, curr)
    if curr == 0 then
        self.winConditionNode:SetActive(true)
        self.winConditionIcon:LoadSprite("Assets/Main/Sprites/UI/UIZombieBattleMain/guanqia_cfm_tubiao_1")
        self.winConditionBarImg:LoadSprite("Assets/Main/Sprites/UI/UIZombieBattleMain/guanqia_cfm_tubiao_jindutiao_2")
    end
    self:SetWinConditionBar(math.max(0, total-curr)/total)
    self:SetWinConditionText(string.format("%d",math.max(0, total-curr)), true)
end

return LWCountBattleMainView
