
local UIChampionBattleMainView = BaseClass("UIChampionBattleMainView", UIBaseView)
local ChampionBattleItem_strongest = require "UI.UIChampionBattleView.UIChampionBattleMainView.Component.ChampionBattleItem_strongest"
local ChampionBattleItem_strongest64 = require "UI.UIChampionBattleView.UIChampionBattleMainView.Component.ChampionBattleItem_strongest64"
local ChampionBattleItem_signUp = require "UI.UIChampionBattleView.UIChampionBattleMainView.Component.ChampionBattleItem_signUp"
local ChampionBattleItem_auditions = require "UI.UIChampionBattleView.UIChampionBattleMainView.Component.ChampionBattleItem_auditions"
local ResourceManager = CS.GameEntry.Resource

local base = UIBaseView
local Localization = CS.GameEntry.Localization
local bg_path = "bg"
local Group_signUp_path = "Group_signUp"
local Group_auditions_path = "Group_auditions"
local Group_strongest64_path = "Group_strongest64"
local Group_strongest_path = "Group_strongest"

local faqBtn_path = "Group_common/faqBtn"
local closeBtn_path = "Group_common/closeBtn"

local stageToggle1_path = "Group_common/ProcessList/stage1Btn"
local stageToggle1_text_path = "Group_common/ProcessList/stage1Btn/toggleLabel1"
local stageToggle1_state_text_path = "Group_common/ProcessList/stage1Btn/stateText1"

local stageToggle2_path = "Group_common/ProcessList/stage2Btn"
local stageToggle2_text_path = "Group_common/ProcessList/stage2Btn/toggleLabel2"
local stageToggle2_state_text_path = "Group_common/ProcessList/stage2Btn/stateText2"

local toggle2_redPot_path = "Group_common/ProcessList/stage2Btn/stage2RedPot"

local stageToggle3_path = "Group_common/ProcessList/stage3Btn"
local stageToggle3_text_path = "Group_common/ProcessList/stage3Btn/toggleLabel3"
local stageToggle3_state_text_path = "Group_common/ProcessList/stage3Btn/stateText3"

local stageToggle4_path = "Group_common/ProcessList/stage4Btn"
local stageToggle4_text_path = "Group_common/ProcessList/stage4Btn/toggleLabel4"
local stageToggle4_state_text_path = "Group_common/ProcessList/stage4Btn/stateText4"

local debugCdTxt_path = "Group_common/Image/debugCdTxt"

local betRecordBtn_path = "Group_common/Group_Button/betRecordBtn"
local betRecordBtn_text_path = "Group_common/Group_Button/betRecordBtn/betRecordBtn_text"

local recordBtn_path = "Group_common/Group_Button/recordBtn"
local recordBtnRedPoint_path = "Group_common/Group_Button/recordBtn/recordBtn_redPoint"
local recordBtn_text_path = "Group_common/Group_Button/recordBtn/recordBtn_text"

local rankBtn_path = "Group_common/Group_Button/rankBtn"
local rankBtn_text_path = "Group_common/Group_Button/rankBtn/rankBtn_text"

local rewardBtn_path = "Group_common/Group_Button/rewardBtn"
local rewardBtn_text_path = "Group_common/Group_Button/rewardBtn/rewardBtn_text"

local ruleBtn_path = "Group_common/Group_Button/ruleBtn"
local ruleBtn_text_path = "Group_common/Group_Button/ruleBtn/ruleBtn_text"

local PanelType = {
    PanelType_Null = 0,--未选中
    PanelType_SignUp = 1,--报名
    PanelType_Auditions = 2,--海选
    PanelType_Strongest_64 = 3,--64强赛
    PanelType_Strongest_8 = 4,--8强赛
}

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end
local SelectedColor = Color.New(192/255, 251/255, 77/255, 1.0)
local UnSelectedColor = Color.New(144/255, 220/255, 247/255, 1.0)
local function ComponentDefine(self)
    self.bg = self:AddComponent(UIImage, bg_path)
    self.Group_signUp = self:AddComponent(UIBaseContainer, Group_signUp_path)
    self.Group_auditions = self:AddComponent(UIBaseContainer, Group_auditions_path)
    self.Group_strongest = self:AddComponent(UIBaseContainer, Group_strongest_path)
    self.Group_strongest64 = self:AddComponent(UIBaseContainer, Group_strongest64_path)
    
    self.faqBtn = self:AddComponent(UIButton, faqBtn_path)
    self.closeBtn = self:AddComponent(UIButton, closeBtn_path)

    self.stageToggle1 = self:AddComponent(UIToggle, stageToggle1_path)
    self.stageToggle1_text = self:AddComponent(UIText, stageToggle1_text_path)
    self.stageToggle1_text:SetLocalText(302029)
    self.stageToggle1_state_text = self:AddComponent(UIText, stageToggle1_state_text_path)
    self.stageToggle2 = self:AddComponent(UIToggle, stageToggle2_path)
    self.stageToggle2_text = self:AddComponent(UIText, stageToggle2_text_path)
    self.stageToggle2_text:SetLocalText(302030)
    self.stageToggle2_state_text = self:AddComponent(UIText, stageToggle2_state_text_path)
    self.toggle2_redPot = self:AddComponent(UIBaseContainer, toggle2_redPot_path)
    self.toggle2_redPot:SetActive(false)
    self.stageToggle3 = self:AddComponent(UIToggle, stageToggle3_path)
    self.stageToggle3_text = self:AddComponent(UIText, stageToggle3_text_path)
    self.stageToggle3_text:SetLocalText(302612)
    self.stageToggle3_state_text = self:AddComponent(UIText, stageToggle3_state_text_path)
   
    self.stageToggle4 = self:AddComponent(UIToggle, stageToggle4_path)
    self.stageToggle4_text = self:AddComponent(UIText, stageToggle4_text_path)
    self.stageToggle4_text:SetLocalText(302031)
    self.stageToggle4_state_text = self:AddComponent(UIText, stageToggle4_state_text_path)

    self.debugCdTxt = self:AddComponent(UIText, debugCdTxt_path)

    self.betRecordBtn = self:AddComponent(UIButton, betRecordBtn_path)
    self.betRecordBtn_text = self:AddComponent(UITextMeshProUGUIEx, betRecordBtn_text_path)

    self.recordBtn = self:AddComponent(UIButton, recordBtn_path)
    self.recordBtn_text = self:AddComponent(UITextMeshProUGUIEx, recordBtn_text_path)
    self.recordBtnRedPoint = self:AddComponent(UIBaseContainer, recordBtnRedPoint_path)
    self.recordBtnRedPoint:SetActive(false)
    self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
    self.rankBtn_text = self:AddComponent(UITextMeshProUGUIEx, rankBtn_text_path)

    self.rewardBtn = self:AddComponent(UIButton, rewardBtn_path)
    self.rewardBtn_text = self:AddComponent(UITextMeshProUGUIEx, rewardBtn_text_path)
    self.ruleBtn = self:AddComponent(UIButton, ruleBtn_path)
    self.ruleBtn_text = self:AddComponent(UITextMeshProUGUIEx, ruleBtn_text_path)

    self.betRecordBtn_text:SetLocalText("--bet--")
    self.recordBtn_text:SetLocalText(302028)
    self.rankBtn_text:SetLocalText(390040)
    self.rewardBtn_text:SetLocalText(302026)
    self.ruleBtn_text:SetLocalText(302027)

    self.betRecordBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:onClick_betRecordBtn()
    end)
    self.recordBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:onClick_recordBtn()
    end)
    self.rankBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:onClick_rankBtn()
    end)
    self.rewardBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:onClick_rewardBtn()
    end)
    
    self.ruleBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:onClick_ruleBtn()
    end)

    self.stageToggle1:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS()
        end
    end)
    self.stageToggle2:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS()
        end
    end)
    self.stageToggle3:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS()
        end
    end)
    self.stageToggle4:SetOnValueChanged(function(tf)
        if tf then
            self:ToggleControlBorS()
        end
    end)

    self.closeBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.faqBtn:SetActive(false)
    self.faqBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:onClick_faqBtn()
    end)
end

local function ToggleControlBorS(self)
    if self.stageToggle1:GetIsOn() then
        self:onClickSwitchActState(PanelType.PanelType_SignUp)
        self.stageToggle1_state_text:SetColor(SelectedColor)
        self.stageToggle2_state_text:SetColor(UnSelectedColor)
        self.stageToggle3_state_text:SetColor(UnSelectedColor)
        self.stageToggle4_state_text:SetColor(UnSelectedColor)

        self.stageToggle1_text:SetColor(SelectedColor)
        self.stageToggle2_text:SetColor(UnSelectedColor)
        self.stageToggle3_text:SetColor(UnSelectedColor)
        self.stageToggle4_text:SetColor(UnSelectedColor)

    elseif self.stageToggle2:GetIsOn() then
        self:onClickSwitchActState(PanelType.PanelType_Auditions)
        self.stageToggle2_state_text:SetColor(SelectedColor)
        self.stageToggle1_state_text:SetColor(UnSelectedColor)
        self.stageToggle3_state_text:SetColor(UnSelectedColor)
        self.stageToggle4_state_text:SetColor(UnSelectedColor)

        self.stageToggle2_text:SetColor(SelectedColor)
        self.stageToggle1_text:SetColor(UnSelectedColor)
        self.stageToggle3_text:SetColor(UnSelectedColor)
        self.stageToggle4_text:SetColor(UnSelectedColor)

    elseif self.stageToggle3:GetIsOn() then
        self:onClickSwitchActState(PanelType.PanelType_Strongest_64)
        self.stageToggle3_text:SetColor(SelectedColor)
        self.stageToggle2_text:SetColor(UnSelectedColor)
        self.stageToggle1_text:SetColor(UnSelectedColor)
        self.stageToggle4_state_text:SetColor(UnSelectedColor)
        self.stageToggle4_text:SetColor(UnSelectedColor)
      
        self.stageToggle3_state_text:SetColor(SelectedColor)
        self.stageToggle1_state_text:SetColor(UnSelectedColor)
        self.stageToggle2_state_text:SetColor(UnSelectedColor)
       
    elseif self.stageToggle4:GetIsOn() then
        self:onClickSwitchActState(PanelType.PanelType_Strongest_8)
        self.stageToggle3_text:SetColor(UnSelectedColor)
        self.stageToggle2_text:SetColor(UnSelectedColor)
        self.stageToggle1_text:SetColor(UnSelectedColor)
        self.stageToggle4_text:SetColor(SelectedColor)
        self.stageToggle4_state_text:SetColor(SelectedColor)
       

        self.stageToggle3_state_text:SetColor(UnSelectedColor)
        self.stageToggle1_state_text:SetColor(UnSelectedColor)
        self.stageToggle2_state_text:SetColor(UnSelectedColor)
        
    end
end

local function DataDefine(self)
    self.curChooseTab = PanelType.PanelType_Null
    self.timer_action = function(temp)
        self:OnUpdate()
    end
    self.alreadyShow = false
    self.onFirstRefresh = true
    DataCenter.ActChampionBattleManager:SetEntranceRed()
    DataCenter.ActChampionBattleManager:SendActChampBattleDataRefreshCmd()

    self:AddTimer()

    local isArrow = self:GetUserData()
    if isArrow then
        self.delayTime = TimerManager:GetInstance():DelayInvoke(function()
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleReward)
        end, 0.5)
    end
    self:ToggleControlBorS()
end

local function OnDestroy(self)
    if self.delayTime ~= nil then
        self.delayTime:Stop()
        self.delayTime = nil
    end
    DataCenter.DailyActivityManager:UpdateActViewHistory(4)
    self:ComponentDestroy()
    self:DataDestroy()
    DataCenter.ActChampionBattleManager:SaveLastRecordRound()
    base.OnDestroy(self)
end

local function ComponentDestroy(self)
    if self.lua_group_singUp ~= nil then
        self.lua_group_singUp = nil
    end
    if self.lua_group_auditions ~= nil then
        self.lua_group_auditions = nil
    end
    if self.lua_group_strongest ~= nil then
        self.lua_group_strongest = nil
    end
    if self.lua_group_strongest64 ~= nil then
        self.lua_group_strongest64 = nil
    end

    if self.delayPosterInvoke ~= nil then
        self.delayPosterInvoke:Stop()
        self.delayPosterInvoke = nil
    end

    if self.requestStrongest ~= nil then
        self.requestStrongest:Destroy()
        self.requestStrongest = nil
    end
    if self.requestStrongest64 ~= nil then
        self.requestStrongest64:Destroy()
        self.requestStrongest64 = nil
    end

    if self.requestAuditions ~= nil then
        self.requestAuditions:Destroy()
        self.requestAuditions = nil
    end
    if self.requestSingUp ~= nil then
        self.requestSingUp:Destroy()
        self.requestSingUp = nil
    end

    self.bg = nil
    self.Group_signUp = nil
    self.Group_auditions = nil
    self.Group_strongest = nil
    self.Group_strongest64 = nil
    self.faqBtn = nil
    self.closeBtn = nil
    self.recordBtnRedPoint = nil
    self.stageToggle1 = nil
    self.stageToggle1_text = nil
    self.stageToggle1_state_text = nil

    self.stageToggle2 = nil
    self.stageToggle2_text = nil
    self.stageToggle2_state_text = nil

    self.stageToggle3 = nil
    self.stageToggle3_text = nil
    self.stageToggle3_state_text = nil

    self.debugCdTxt = nil

    self.betRecordBtn = nil
    self.betRecordBtn_text = nil

    self.recordBtn = nil
    self.recordBtn_text = nil

    self.rankBtn = nil
    self.rankBtn_text = nil

    self.rewardBtn = nil
    self.rewardBtn_text = nil

    self.ruleBtn = nil
    self.ruleBtn_text = nil
    self:RemoveTimer()
    self.timer_action = nil
end

local function DataDestroy(self)
    self.timer_action = nil
    self.championBattleInfo = nil
    self.alreadyShow = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.ChampionBattleDataRefresh, self.OnrefreshData)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.ChampionBattleDataRefresh, self.OnrefreshData)
    base.OnRemoveListener(self)
end
local function OnrefreshData(self)
    self.championBattleInfo = DataCenter.ActChampionBattleManager:GetChampionBattleInfo()
    if self.championBattleInfo == nil then
        return
    end
    self.toggle2_redPot:SetActive(DataCenter.ActChampionBattleManager:HasRewardNotReceive())
    if self.onFirstRefresh ==true then
        self.curChooseTab = self:GetTabType()
        self.onFirstRefresh = false
    end
    
    if self.curChooseTab == PanelType.PanelType_SignUp then
        if self.stageToggle1:GetIsOn() then
            self:onClickSwitchActState(self.curChooseTab)
        else
            self.stageToggle1:SetIsOn(true)
        end
    elseif self.curChooseTab == PanelType.PanelType_Auditions then
        if self.stageToggle2:GetIsOn() then
            self:onClickSwitchActState(self.curChooseTab)
        else
            self.stageToggle2:SetIsOn(true)
        end
    elseif self.curChooseTab == PanelType.PanelType_Strongest_64 then
        if self.stageToggle3:GetIsOn() then
            self:onClickSwitchActState(self.curChooseTab)
        else
            self.stageToggle3:SetIsOn(true)
        end
    elseif self.curChooseTab == PanelType.PanelType_Strongest_8 then
        if self.stageToggle4:GetIsOn() then
            self:onClickSwitchActState(self.curChooseTab)
        else
            self.stageToggle4:SetIsOn(true)
        end
    end
    self:ShowBattleResultHint()
end

--------------------------------------------------

-----------------start---状态动态切换显示
local function InitGroup_SingUp(self)
    if self.lua_group_singUp == nil then
        if self.requestSingUp == nil  then
            self.requestSingUp = ResourceManager:InstantiateAsync(UIAssets.ResChampionBattleItem_signUp)
            self.requestSingUp:completed('+', function()
                if self.requestSingUp.isError or self.requestSingUp.gameObject == nil then
                    return
                end
                self.requestSingUp.gameObject:SetActive(true)
                self.requestSingUp.gameObject.name = "ChampionBattleItem_signUp"
                self.requestSingUp.gameObject.transform:SetParent(self.Group_signUp.transform)
                self.requestSingUp.gameObject.transform.localPosition = ResetPosition
                self.requestSingUp.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

                self.lua_group_singUp = self.Group_signUp:AddComponent(ChampionBattleItem_signUp, "ChampionBattleItem_signUp")
                self.lua_group_singUp:SetData(self.championBattleInfo)
            end)
        end
    else
        self.lua_group_singUp:SetData(self.championBattleInfo)
    end
end

local function InitGroup_Auditions(self)
    if self.lua_group_auditions == nil then
        if self.requestAuditions == nil then
            self.requestAuditions = ResourceManager:InstantiateAsync(UIAssets.ResChampionBattleItem_auditions)
            self.requestAuditions:completed('+', function()
                if self.requestAuditions.isError or self.requestAuditions.gameObject == nil then
                    return
                end
                self.requestAuditions.gameObject:SetActive(true)
                self.requestAuditions.gameObject.name = "ChampionBattleItem_auditions"
                self.requestAuditions.gameObject.transform:SetParent(self.Group_auditions.transform)
                self.requestAuditions.gameObject.transform.localPosition = ResetPosition
                self.requestAuditions.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

                self.lua_group_auditions = self.Group_auditions:AddComponent(ChampionBattleItem_auditions, "ChampionBattleItem_auditions")
                self.lua_group_auditions:SetData(self.championBattleInfo)
            end)
        end
    else
        self.lua_group_auditions:SetData(self.championBattleInfo)
    end
end

local function InitGroup_Strongest(self)
    if self.lua_group_strongest == nil then
        if self.requestStrongest == nil then
            self.requestStrongest = ResourceManager:InstantiateAsync(UIAssets.ResChampionBattleItem_strongest)
            self.requestStrongest:completed('+', function()
                if self.requestStrongest.isError and self.requestStrongest.gameObject ~= nil then
                    return
                end
                self.requestStrongest.gameObject:SetActive(true)
                self.requestStrongest.gameObject.name = "ChampionBattleItem_strongest"
                self.requestStrongest.gameObject.transform:SetParent(self.Group_strongest.transform)
                self.requestStrongest.gameObject.transform.localPosition = ResetPosition
                self.requestStrongest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

                self.lua_group_strongest = self.Group_strongest:AddComponent(ChampionBattleItem_strongest, "ChampionBattleItem_strongest")
                self.lua_group_strongest:SetData(self.championBattleInfo)
            end)
        end
    else
        self.lua_group_strongest:SetData(self.championBattleInfo)
    end
end

local function InitGroup_Strongest64(self)
    if self.lua_group_strongest64 == nil then
        if self.requestStrongest64 == nil then
            self.requestStrongest64 = ResourceManager:InstantiateAsync(UIAssets.ResChampionBattleItem_strongest64)
            self.requestStrongest64:completed('+', function()
                if self.requestStrongest64.isError and self.requestStrongest64.gameObject ~= nil then
                    return
                end
                self.requestStrongest64.gameObject:SetActive(true)
                self.requestStrongest64.gameObject.name = "ChampionBattleItem_strongest64"
                self.requestStrongest64.gameObject.transform:SetParent(self.Group_strongest64.transform)
                self.requestStrongest64.gameObject.transform.localPosition = ResetPosition
                self.requestStrongest64.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)

                self.lua_group_strongest64 = self.Group_strongest64:AddComponent(ChampionBattleItem_strongest64, "ChampionBattleItem_strongest64")
                self.lua_group_strongest64:SetData(self.championBattleInfo)
            end)
        end
    else
        self.lua_group_strongest64:SetData(self.championBattleInfo)
    end
end

-----------------end---状态动态切换显示
-----------------start---统用状态下显示
--设置背景图
local function SetBgByChild(self, bgUrl)
    self.bg:LoadSprite(bgUrl)
    --if bgUrl ~= nil then
    --    self.bg:LoadAsync(bgUrl,"",function()
    --        if not self.bg.gameObject:IsNull() then
    --            self.bg.gameObject:SetActive(true)
    --        end
    --    end)
    --end
end
local function RefreshCurStage(self, tab)
    local curIndexState = self.championBattleInfo:GetCurState()
    if curIndexState == Activity_ChampionBattle_Stage_State.SingUp then
        self.stageToggle1_state_text:SetLocalText(302049)
        self.stageToggle2_state_text:SetLocalText(302614)
        self.stageToggle3_state_text:SetLocalText(302064)
        self.stageToggle4_state_text:SetLocalText(302065)
    elseif curIndexState == Activity_ChampionBattle_Stage_State.Auditions then
        self.stageToggle1_state_text:SetLocalText(302048)
        self.stageToggle2_state_text:SetLocalText(302049)
        self.stageToggle3_state_text:SetLocalText(302064)
        self.stageToggle4_state_text:SetLocalText(302065)
    elseif curIndexState == Activity_ChampionBattle_Stage_State.Strongest_64 then
        self.stageToggle1_state_text:SetLocalText(302048)
        self.stageToggle2_state_text:SetLocalText(302048)
        self.stageToggle3_state_text:SetLocalText(302049)
        self.stageToggle4_state_text:SetLocalText(302065)
    elseif curIndexState == Activity_ChampionBattle_Stage_State.Strongest then
        self.stageToggle1_state_text:SetLocalText(302048)
        self.stageToggle2_state_text:SetLocalText(302048)
        self.stageToggle3_state_text:SetLocalText(302048)
        self.stageToggle4_state_text:SetLocalText(302049)
    end

    local bgUrl = nil
    if curIndexState == Activity_ChampionBattle_Stage_State.SingUp then
        if tab == Activity_ChampionBattle_Stage_State.Auditions then
            bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k4")
        elseif tab == Activity_ChampionBattle_Stage_State.Strongest then
            bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k5")
        else
            bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k"..tab)
        end
    elseif curIndexState == Activity_ChampionBattle_Stage_State.Auditions then
        if tab == Activity_ChampionBattle_Stage_State.Strongest then
            bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k5")
        else
            bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k"..tab)
        end
    elseif curIndexState == Activity_ChampionBattle_Stage_State.Strongest_64 then
        if tab == Activity_ChampionBattle_Stage_State.Strongest then
            bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k5")
        elseif tab == Activity_ChampionBattle_Stage_State.Strongest_64 then
            bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k2")
        else
            bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k"..tab)
        end
    else
        bgUrl = LuaEntry.DataConfig:TryGetStr("champ_battle_background", "k"..tab)
    end
    
    bgUrl = "Assets/Main/TextureEx/UIActivity/"..bgUrl
    self:SetBgByChild(bgUrl)
    if tab == PanelType.PanelType_SignUp then
        self.Group_signUp:SetActive(true)
        self.Group_auditions:SetActive(false)
        self.Group_strongest:SetActive(false)
        self.Group_strongest64:SetActive(false)
        self:InitGroup_SingUp()
    elseif tab == PanelType.PanelType_Auditions then
        self.Group_signUp:SetActive(false)
        self.Group_auditions:SetActive(true)
        self.Group_strongest:SetActive(false)
        self.Group_strongest64:SetActive(false)
        self:InitGroup_Auditions()
    elseif tab == PanelType.PanelType_Strongest_64 then
        self.Group_signUp:SetActive(false)
        self.Group_auditions:SetActive(false)
        self.Group_strongest64:SetActive(true)
        self.Group_strongest:SetActive(false)
        self:InitGroup_Strongest64()
    elseif tab == PanelType.PanelType_Strongest_8 then
        self.Group_signUp:SetActive(false)
        self.Group_auditions:SetActive(false)
        self.Group_strongest64:SetActive(false)
        self.Group_strongest:SetActive(true)
        self:InitGroup_Strongest()
    end
    self:ShowButtonGroup()
end

local function onClickSwitchActState(self, tab)
    if self.championBattleInfo == nil then
        return
    end
    self.curChooseTab = tab
    self:RefreshCurStage(tab)
end
--下方按钮组显隐逻辑
local function ShowButtonGroup(self)
    local curIndexState = self.championBattleInfo:GetCurState()
    if curIndexState == Activity_ChampionBattle_Stage_State.Auditions or 
            curIndexState == Activity_ChampionBattle_Stage_State.Strongest_64 or
            curIndexState == Activity_ChampionBattle_Stage_State.Strongest then
        self.recordBtn:SetActive(true)
        self.rankBtn:SetActive(true)
    else
        self.recordBtn:SetActive(false)
        self.rankBtn:SetActive(false)
    end
    self:RefreshRecordRedPoint()
end

local function onClick_closeBtn(self)
    self.ctrl:CloseSelf()
end

--点击打开奖励预览
local function onClick_rewardBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleReward,{anim = true,isBlur = true})
end
--点击打开活动规则界面
local function onClick_ruleBtn(self)
    local strTitle = Localization:GetString("302022")
    local subTitle = Localization:GetString("100239")
    local strContent = Localization:GetString("302062")
    UIUtil.ShowIntro(strTitle, subTitle, strContent)
end
--点击我的编队
local function onClick_rankBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleRankView)
end
--点击查看交战纪录
local function onClick_recordBtn(self)
    DataCenter.ActChampionBattleManager:SendActChampionBattleReportListCmd()
    DataCenter.ActChampionBattleManager:ResetNeedShowRecord()
    self:RefreshRecordRedPoint()
end
--点击查看押注纪录
local function onClick_betRecordBtn(self)
    --OpenGameUI("LFChampionBattleBettingrecord")
end
--
local function onClick_faqBtn(self)
    --local FAQ_ID = "40008"
    --if FAQ_ID ~= nil then
    --    printInfo("打印出来fabId="..FAQ_ID)
    --    CS.CommonUtils.ShowFAQ(FAQ_ID)
    --end
end
-----------------end---统用状态下显示
---界面打开时，整点需要客户端主动请求一次，做数据刷新
local function SendCmdForClock(self)
    local oneHour = 3600
    local leftTime = UITimeManager:GetInstance():GetResSecondsTo24()
    local fmodValue = math.fmod(leftTime, oneHour)
    if fmodValue == 0 then
        DataCenter.ActChampionBattleManager:SendActChampBattleDataRefreshCmd()
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action, self, false,false,false)
    end
    self.timer:Start()
    self:OnUpdate()

end

local function RemoveTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
    end
    self.timer = nil
end

local function OnUpdate(self)
    if self.championBattleInfo == nil or self.debugCdTxt == nil then
        return
    end
    self:SendCmdForClock()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local endTime = self.championBattleInfo.endTime
    local startTime = self.championBattleInfo.startTime

    local leftTime = endTime - curTime
    if startTime < curTime and leftTime > 0 then--活动开启
        self.debugCdTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
    end
end

local function ShowBattleResultHint(self)
    if self.alreadyShow ~= true then
        if DataCenter.ActChampionBattleManager:NeedShowRecord() then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIChampionBattleResultHintView)
        end
    end
    self.alreadyShow = true
end

local function RefreshRecordRedPoint(self)
    self.recordBtnRedPoint:SetActive(DataCenter.ActChampionBattleManager:GetNeedShowRecord())
end

local function GetTabType(self)
    local tabType = PanelType.PanelType_SignUp
    local curIndexState = self.championBattleInfo:GetCurState()
    if curIndexState == Activity_ChampionBattle_Stage_State.SingUp then
        tabType = PanelType.PanelType_SignUp
    elseif curIndexState == Activity_ChampionBattle_Stage_State.Auditions then
        tabType = PanelType.PanelType_Auditions
    elseif curIndexState == Activity_ChampionBattle_Stage_State.Strongest_64 then
        tabType = PanelType.PanelType_Strongest_64
    elseif curIndexState == Activity_ChampionBattle_Stage_State.Strongest then
        tabType = PanelType.PanelType_Strongest_8
    end
    return tabType
end

UIChampionBattleMainView.AddTimer = AddTimer
UIChampionBattleMainView.RemoveTimer = RemoveTimer
UIChampionBattleMainView.OnUpdate = OnUpdate
UIChampionBattleMainView.OnCreate = OnCreate
UIChampionBattleMainView.ComponentDefine = ComponentDefine
UIChampionBattleMainView.DataDefine = DataDefine
UIChampionBattleMainView.OnDestroy = OnDestroy
UIChampionBattleMainView.ComponentDestroy = ComponentDestroy
UIChampionBattleMainView.OnAddListener = OnAddListener
UIChampionBattleMainView.OnRemoveListener = OnRemoveListener
UIChampionBattleMainView.SendCmdForClock = SendCmdForClock
UIChampionBattleMainView.onClick_faqBtn = onClick_faqBtn
UIChampionBattleMainView.onClick_betRecordBtn = onClick_betRecordBtn
UIChampionBattleMainView.onClick_recordBtn = onClick_recordBtn
UIChampionBattleMainView.onClick_rankBtn = onClick_rankBtn
UIChampionBattleMainView.onClick_ruleBtn = onClick_ruleBtn
UIChampionBattleMainView.onClick_rewardBtn = onClick_rewardBtn
UIChampionBattleMainView.onClick_closeBtn = onClick_closeBtn
UIChampionBattleMainView.ShowButtonGroup = ShowButtonGroup
UIChampionBattleMainView.onClickSwitchActState = onClickSwitchActState
UIChampionBattleMainView.RefreshCurStage = RefreshCurStage
UIChampionBattleMainView.SetBgByChild = SetBgByChild
UIChampionBattleMainView.ToggleControlBorS = ToggleControlBorS
UIChampionBattleMainView.OnrefreshData = OnrefreshData
UIChampionBattleMainView.InitGroup_SingUp = InitGroup_SingUp
UIChampionBattleMainView.InitGroup_Auditions = InitGroup_Auditions
UIChampionBattleMainView.InitGroup_Strongest = InitGroup_Strongest
UIChampionBattleMainView.InitGroup_Strongest64 = InitGroup_Strongest64
UIChampionBattleMainView.ShowBattleResultHint = ShowBattleResultHint
UIChampionBattleMainView.RefreshRecordRedPoint = RefreshRecordRedPoint
UIChampionBattleMainView.GetTabType = GetTabType
UIChampionBattleMainView.DataDestroy = DataDestroy

return UIChampionBattleMainView
