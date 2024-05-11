---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 7/12/21 8:49 PM
---

local UIHeroRecruitReward = BaseClass("UIHeroRecruitReward", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UITopItem = require "UI.UIHero2.UIHeroRecruit.Component.UITopItem"


local UIRewardItem = require "UI.UIHero2.UIHeroRecruitReward.Component.UIRewardItem"

local CellHalfWidth = 88.5
local CellHalfHeight = 129
local CellPrefabPath = "Assets/Main/Prefabs/UI/UIHero/New/UIHeroRecruitRewardCell.prefab"


local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()

    local lotteryId, message = self:GetUserData()
    local lotteryHeroData = message['lotteryHero']
    self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
    self.lotteryHeroData = lotteryHeroData
    self:OnOpen()
end

local function OnDestroy(self)
    self:CleanCards()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function CleanCards(self)
    --清理cards
    self.directEnd = false
    self.isShowNewHero = false
    self.content:RemoveComponents(UIRewardItem)
    if self.cardRequestList ~=nil then
        for _,v in pairs(self.cardRequestList) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end

        self.cardRequestList = nil
    end

    self.nodeCards = nil
end

local function ComponentDefine(self)
    self.btnClose1 = self:AddComponent(UIButton, "Root/BtnClose")
    self.btnClose1:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.btnClose1:SetActive(false)
    self.btnClose = self:AddComponent(UIButton, "BtnClose1")

    self.btnClose:SetOnClick(BindCallback(self, self.OnBtnCloseClickDirect))
    
    self.nodeRoot = self:AddComponent(UIBaseContainer, 'Root')
    self.content = self:AddComponent(UIBaseContainer, "Root/Panel/Content10")
    
    self.uiTopItem = self:AddComponent(UITopItem, "Root/ItemBar")

    self.nodeBottom = self:AddComponent(UIBaseContainer, 'Root/NodeBottom')
    self.btnConfirm = self:AddComponent(UIButton, 'Root/NodeBottom/BtnConfirm')
    self.btnConfirm1 = self:AddComponent(UIButton, 'Root/NodeBottom/BtnConfirm_1')
    self.btnRecruit = self:AddComponent(UIButton, 'Root/NodeBottom/BtnRecruit')
    self.textConfirm = self:AddComponent(UITextMeshProUGUIEx, 'Root/NodeBottom/BtnConfirm/TextConfirm')
    self.textConfirm1 = self:AddComponent(UITextMeshProUGUIEx, 'Root/NodeBottom/BtnConfirm_1/TextConfirm_1')

    self.textRecruit = self:AddComponent(UITextMeshProUGUIEx, 'Root/NodeBottom/BtnRecruit/TextRecruit')
    self.imgCost = self:AddComponent(UIImage, 'Root/NodeBottom/ImgCost')
    self.textCost = self:AddComponent(UITextMeshProUGUIEx, 'Root/NodeBottom/ImgCost/TextCost')
    self.textPosterTips = self:AddComponent(UITextMeshProUGUIEx, 'Root/NodeBottom/TextPosterTips')
    self.lotteryLeftTime = self:AddComponent(UITextMeshProUGUIEx, "Root/leftTimeText")
    self.lotteryLeftTime:SetActive(false)

    self.btnConfirm:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
    self.btnConfirm1:SetOnClick(BindCallback(self, self.OnBtnCloseClick))
    self.btnRecruit:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
    self.textConfirm:SetLocalText(GameDialogDefine.CONFIRM)
    self.textConfirm1:SetLocalText(GameDialogDefine.CONFIRM)
    self.textPosterTips:SetLocalText(110114)
    local isInGuide = DataCenter.GuideManager:InGuide()
    self.btnConfirm1:SetActive(isInGuide)
    self.btnConfirm:SetActive(not isInGuide)
    self.imgCost:SetActive(not isInGuide)
    self.btnRecruit:SetActive(not isInGuide)
end

local function DataDefine(self)
    self.lotteryHeroData = nil
    self.nodeCards = {}
    self.cardRequestList = {}
    self.eventHandler = {}
    self.canClick = true
    self.directEnd = false
    self.isShowNewHero = false
    self.showNewHero = {}
end

local function DataDestroy(self)
    self.lotteryHeroData = nil
    self.nodeCards = nil
    self.cardRequestList = nil
    self.eventHandler = nil
    self.directEnd = nil
    self.isShowNewHero = false
    self.showNewHero = {}
    if self.delayShowNewHeroTimer then
        self.delayShowNewHeroTimer:Stop()
        self.delayShowNewHeroTimer = nil
    end
    self:RemoveFlipTimer()
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)

    local bindFunc = BindCallback(self, self.OnToggleRecruitScene)
    self.eventHandler[EventId.ToggleRecruitScene] = bindFunc
    
    EventManager:GetInstance():AddListener(EventId.ToggleRecruitScene, bindFunc)
    self:AddUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
    EventManager:GetInstance():RemoveListener(EventId.ToggleRecruitScene, self.eventHandler[EventId.ToggleRecruitScene])
    self.eventHandler[EventId.ToggleRecruitScene] = nil
    
    base.OnRemoveListener(self)
end

local function OnOpen(self)
    local rarity = HeroUtils.RarityType.C
    table.walk(self.lotteryHeroData, function (_, v)
        if v.type == 0 then
            local heroData = DataCenter.HeroDataManager:GetHeroByUuid(v.uuid)
            if heroData ~= nil and rarity > heroData.rarity then
                rarity = heroData.rarity
            end
        end
    end)
    --rarity = math.random(1, 4)
    --self.sceneHolder:SetLotteryId(self.lotteryData.id, rarity)
    self.flipIdx = 1
    --self.nodeRoot.transform:Set_localScale(0, 0, 0)
    --self.btnClose:SetInteractable(false)
    self.nodeBottom:SetActive(false)
    self.btnClose:SetActive(true)
    self.btnClose1:SetActive(false)
    --招募道具及消耗
    local costItems = self.lotteryData:GetCostItems()
    self.itemId = costItems[1].itemId
    self.recruitCost1 = tonumber(costItems[1].itemNum)
    self.recruitCost2 = tonumber(costItems[2].itemNum)
    self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
    self.uiTopItem:SetData(self.itemId,costItems)

    self:RefreshNodeBottom()
    self:GenerateCards()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_hero_box_open)
end

local function RefreshNodeBottom(self)
    self.imgCost:LoadSprite(string.format(LoadPath.ItemPath, DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId).icon))
    
    local hasLimit = DataCenter.LotteryDataManager:HasLotteryLimit(self.lotteryData)
    local limitLeft = 0
    if hasLimit then
        limitLeft = DataCenter.LotteryDataManager:GetLotteryTimesLeft(self.lotteryData)
        local btnText = self.itemHave >= self.recruitCost2 and 110116 or 110115
        if limitLeft < self.recruitCost2 then
            btnText = 110115
        end
        self.textRecruit:SetLocalText(btnText)
        
        local costText = string.GetFormattedSeperatorNum(self.itemHave >= self.recruitCost2 and self.recruitCost2 or self.recruitCost1)
        if limitLeft < self.recruitCost2 then
            costText = string.GetFormattedSeperatorNum(self.recruitCost1)
        end

        local isCn = LuaEntry.Player:IsInCnServer()
        if isCn and LuaEntry.DataConfig:CheckSwitch("cn_HeroreCruits_limit_switch") then
            self.lotteryLeftTime:SetActive(true)
            self.lotteryLeftTime:SetLocalText(121508, limitLeft)
        end

        self.textCost:SetText(costText)
    else
        self.textRecruit:SetLocalText(self.itemHave >= self.recruitCost2 and 110116 or 110115)
        self.textCost:SetText(string.GetFormattedSeperatorNum(self.itemHave >= self.recruitCost2 and self.recruitCost2 or self.recruitCost1))
        self.lotteryLeftTime:SetActive(false)
    end
    
    local gray = ((self.itemHave < self.recruitCost1) or self.canClick == false)
    --UIGray.SetGray(self.btnRecruit.transform, gray, true)
    local shadow = self.textRecruit.transform:GetComponent(typeof(CS.UnityEngine.UI.Shadow))
    if shadow then
        shadow.enabled = not gray
    end

    local outlines = self.textRecruit.gameObject:GetComponents(typeof(CS.UnityEngine.UI.Outline))
    for i=0, outlines.Length -1 do
        outlines[i].effectColor = gray and Color.black or Color.New(142/255, 62/255, 24/255)
        outlines[i].enabled = true
    end
end

---生成卡片
local function GenerateCards(self)
    local lotteryId = self.lotteryData.id
    self.cardRequestList = {}
    self.nodeCards = {}
    
    for idx, data in pairs(self.lotteryHeroData) do
        local req = self:GameObjectInstantiateAsync(CellPrefabPath, function(request)
            if request.isError then
                return
            end
            
            local go = request.gameObject
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.content:AddComponent(UIRewardItem, nameStr, lotteryId, idx, data)
            --Logger.LogError("GenerateCards___"..nameStr)
            table.insert(self.nodeCards, cell)
            if self.directEnd then
                if self.isShowNewHero ~= true then
                    cell:StopAllAnimation()
                end
            end
        end)
        
        table.insert(self.cardRequestList, req)
    end
end

---播放散开动画
local function PlaySpreadAnimation(self)
    Logger.Log("#RecruitScene# step in PlaySpreadAnimation!")
    if self.directEnd then
        local isShowSkipNewHero = table.count(self.showNewHero) > 0 or self.isShowNewHero == true
        for _, card in ipairs(self.nodeCards) do
            if isShowSkipNewHero then
                card:PlaySpreadAnimation(1000)
            else
                card:StopAllAnimation()
            end
        end
        if not isShowSkipNewHero then
            self:OnAllFlipComplete()
        end
        return
    end
    
    for k, card in ipairs(self.nodeCards) do
        card:PlaySpreadAnimation(HeroUtils.AniConfig.appearDuration * (k-1))
    end
    self:RemoveFlipTimer()
    local duration = HeroUtils.AniConfig.appearDuration + HeroUtils.AniConfig.firstFlipDelay
    self.flipTimer = TimerManager:GetInstance():DelayInvoke(BindCallback(self, self.FlipNextCell), duration)
end

local function RemoveFlipTimer(self)
    if self.flipTimer ~= nil then
        self.flipTimer:Stop()
        self.flipTimer = nil
    end
end

local function FlipNextCell(self)
    if self.directEnd then
        return
    end
    if self.flipIdx > #self.nodeCards then
        --TimerManager:GetInstance():DelayInvoke(BindCallback(self, self.OnAllFlipComplete), 0.1)
        self:OnAllFlipComplete()
        return
    end
    
    local isLast = self.flipIdx == #self.nodeCards
    self.nodeCards[self.flipIdx]:DoFlip(isLast, function()
        self:FlipNextCell()
    end)
    self.flipIdx = self.flipIdx + 1
end

local function OnTimeLineEvent(self, playableName, event)
    Logger.Log("#RecruitScene# UIHeroRecruitReward OnTimeLineEvent TimeLine:[" .. playableName .. "] event:" .. event)
    if string.contains(playableName, 'open') then
        if event == 'stop' then
            self.nodeRoot.transform:Set_localScale(1, 1, 1)
            self:PlaySpreadAnimation()
            --self.btnClose:SetInteractable(true)

            Logger.Log("#RecruitScene# UIHeroRecruitReward OnTimeLineEvent 1")
        end
    else
        if event == 'stop' then
            self.ctrl:CloseSelf()
            Logger.Log("#RecruitScene# UIHeroRecruitReward OnTimeLineEvent 2")
        end
    end
end

local function OnToggleRecruitScene(self, visible)
    if visible and self:ShowSkipAnimationNewHero(true)  then
        return
    end
    self.nodeRoot.transform.localScale = visible and Vector3.one or Vector3.zero
    --self.sceneHolder:ToggleLight(visible)
    if visible then
        self:FlipNextCell()
    end
end

local function OnAllFlipComplete(self)
    --manual close
    self:RemoveFlipTimer()
    self.nodeBottom:SetActive(true)
    self.btnClose:SetActive(false)
    self.btnClose1:SetActive(true)
    for _, card in pairs(self.nodeCards) do
        card:SetTouchEnabled(true)
    end
end

local function OnBtnCloseClick(self)
    self.ctrl:CloseSelf()
    
    --[[
    local hasNoTurned = false
    for _, v in pairs(self.nodeCards) do
        if not v:IsFlipped() then
            hasNoTurned = true
            v:DoFlip()
            break
        end
    end

    if hasNoTurned then
        --self.btnClose:SetInteractable(false)
        TimerManager:GetInstance():DelayInvoke(function()
            --self.btnClose:SetInteractable(true)
        end, 1)
        
        return
    end
    
    self.nodeRoot.transform:Set_localScale(0, 0, 0)
    --self.sceneHolder:PlayCloseTimeLine()
    --]]
end

local function OnBtnRecruitClick(self)
    if table.count(self.showNewHero) > 0 then
        return
    end
    if self.canClick == false then
        return
    end
    if self.itemHave < self.recruitCost1 then
        UIUtil.ShowTips(Localization:GetString("120021")) --道具不足
        return
    end

    local hasLimit = DataCenter.LotteryDataManager:HasLotteryLimit(self.lotteryData)
    local limitLeft = 0
    if hasLimit then
        limitLeft = DataCenter.LotteryDataManager:GetLotteryTimesLeft(self.lotteryData)
        if limitLeft <= 0 then
            UIUtil.ShowTipsId(129285)
            return
        end
    end

    --连抽
    if self.itemHave >= self.recruitCost2 then
        if hasLimit then
            if limitLeft >= self.recruitCost2 then
                self.canClick = false
                SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 1, 0, self.itemId)
                return
            end
        else
            self.canClick = false
            SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 1, 0, self.itemId)
            return
        end
    end
    
    --单抽
    self.canClick = false
    SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 0, 0, self.itemId)
end

local function OnHandleRecruitResponse(self, message)
    self.canClick = true
    local lotteryHeroData = message['lotteryHero']
    self.lotteryHeroData = lotteryHeroData
    self:CleanCards()
    self:OnOpen()
    --self.sceneHolder:PlayTimeLine(HeroUtils.RecruitTimeOpenPath)
end

local function OnBtnClose1Click(self)
    GoToUtil.CloseAllWindows()
end

local function OnBtnCloseClickDirect(self)
    self.showNewHero = {}

    for k, v in ipairs(self.lotteryHeroData) do
        if v.type == 0 then
            local needShowCg = DataCenter.HeroDataManager:IsNewHero(v.uuid) and DataCenter.HeroDataManager:NeedShowNewHeroWindow(v.uuid)
            needShowCg = needShowCg
            if needShowCg then
                table.insert(self.showNewHero, v.uuid)
            end
        end
    end
    self.directEnd = true
    self:RemoveFlipTimer()
    --self.sceneHolder:GotoEnd()
    self:ShowSkipAnimationNewHero(true)
end

local function ShowSkipAnimationNewHero(self, delayShow)
    if table.count(self.showNewHero) > 0 then
        local heroUuid = self.showNewHero[1]
        self.isShowNewHero = true
        table.remove(self.showNewHero, 1)
        local ShowNewWindow = function(uuid)
            UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, heroUuid)
        end
        if delayShow then
            self.delayShowNewHeroTimer = TimerManager:GetInstance():DelayInvoke(function()
                if self.delayShowNewHeroTimer then
                    self.delayShowNewHeroTimer:Stop()
                    self.delayShowNewHeroTimer = nil
                end
                ShowNewWindow(heroUuid)
            end, 0.3)
        else
            ShowNewWindow(heroUuid)
        end
        return true
    else
        for _, card in ipairs(self.nodeCards) do
            card:StopAllAnimation()
        end
        self:OnAllFlipComplete()
    end
    return false
end

UIHeroRecruitReward.OnCreate= OnCreate
UIHeroRecruitReward.OnDestroy = OnDestroy
UIHeroRecruitReward.OnEnable = OnEnable
UIHeroRecruitReward.OnDisable = OnDisable
UIHeroRecruitReward.OnAddListener = OnAddListener
UIHeroRecruitReward.OnRemoveListener = OnRemoveListener
UIHeroRecruitReward.ComponentDefine = ComponentDefine
UIHeroRecruitReward.DataDefine = DataDefine
UIHeroRecruitReward.DataDestroy = DataDestroy
UIHeroRecruitReward.ShowSkipAnimationNewHero = ShowSkipAnimationNewHero
UIHeroRecruitReward.OnOpen = OnOpen
UIHeroRecruitReward.RefreshNodeBottom = RefreshNodeBottom
UIHeroRecruitReward.GenerateCards = GenerateCards
UIHeroRecruitReward.PlaySpreadAnimation = PlaySpreadAnimation
UIHeroRecruitReward.OnTimeLineEvent = OnTimeLineEvent
UIHeroRecruitReward.OnToggleRecruitScene = OnToggleRecruitScene
UIHeroRecruitReward.OnBtnCloseClick = OnBtnCloseClick
UIHeroRecruitReward.OnBtnClose1Click = OnBtnClose1Click
UIHeroRecruitReward.OnBtnRecruitClick = OnBtnRecruitClick
UIHeroRecruitReward.OnBtnCloseClickDirect = OnBtnCloseClickDirect

UIHeroRecruitReward.CleanCards = CleanCards
UIHeroRecruitReward.FlipNextCell = FlipNextCell
UIHeroRecruitReward.OnAllFlipComplete = OnAllFlipComplete
UIHeroRecruitReward.OnHandleRecruitResponse = OnHandleRecruitResponse
UIHeroRecruitReward.RemoveFlipTimer = RemoveFlipTimer

return UIHeroRecruitReward
