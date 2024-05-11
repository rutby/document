
local UIHeroRecruitReward = BaseClass("UIHeroRecruitReward", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local UITopItem = require "UI.UIHero2.UIHeroRecruit.Component.UITopItem"
local UIRewardItem = require "UI.UIHero2.UIHeroRecruitRewardNew.Component.UIRewardItem"

local TypeOfParticleSystem = typeof(CS.UnityEngine.ParticleSystem)

local cardPosDataList = {
    {x = 0, y = 434},
    {x = -219, y = 290},
    {x = 219, y = 290},
    {x = 0, y = 162},
    {x = -219, y = 26},
    {x = 219, y = 26},
    {x = 0, y = -101},
    {x = -219, y = -242},
    {x = 219, y = -242},
    {x = 0, y = -367},
} 

local openAni = "Eff_UIHeroRecruitRewardNew_chouka"
local openOneAni = "Eff_UIHeroRecruitRewardNew_fapai_danchou"
local openAniTimeSingle = 0.5
local openAniTimeTen = 1.1
local shockAniTime = 0.5
local openCardAniTime = 1
local autoWaitOpenTime = 0.1

local sendMsgTime = 0 -- 发抽卡消息不能连点

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    -- self:DataDefine()

    local lotteryId, message = self:GetUserData()
    local lotteryHeroData = message['lotteryHero']
    self.lotteryData = DataCenter.LotteryDataManager:GetLotteryDataById(lotteryId)
    self.lotteryHeroData = lotteryHeroData
    self.drawCardTime = 0
    self:OnOpen()
end

local function StopDelayTimer(self)
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
end

local function OnDestroy(self)
    StopDelayTimer(self)
    self:ComponentDestroy()
    -- self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)

    self.nodeRoot = self:AddComponent(UIBaseContainer, 'Root')
    self.rootAni = self:AddComponent(UIAnimator, "")
    self.rootAni:Enable(false)

    self.btnClose = self:AddComponent(UIButton, "Root/TopBar/closeBtn")
    self.btnClose:SetOnClick(function()
       self.ctrl:CloseSelf()
    end)

    self.topBar = self:AddComponent(UIBaseContainer, "Root/TopBar")
    self.textTitle = self:AddComponent(UITextMeshProUGUIEx, "Root/TopBar/TextTitle")
    self.textTitle:SetLocalText(110021) 
    self.itemBar = self:AddComponent(UITopItem, "Root/TopBar/TopBarList/ItemBar")

    self.content = self:AddComponent(UIButton, "Root/Continue")
    self.content:SetOnClick(function()
        self:OnContentClick()
    end)
    self.cardPosList = {}
    for i = 1,10 do
        local cardPosItemName = string.format("Root/Panel/cardPos%d", i)
        local cardPosItem = self:AddComponent(UIBaseContainer, cardPosItemName)
        cardPosItem.cardItem = cardPosItem:AddComponent(UIRewardItem, "UIHeroRecruitRewardCellNew")
        table.insert(self.cardPosList, cardPosItem)
    end

    self.nodeBottom = self:AddComponent(UIBaseContainer, 'Root/NodeBottom')
    self.clickText = self:AddComponent(UITextMeshProUGUIEx, 'Root/clickText')
    self.clickText:SetLocalText(129074)
    self.btnRecruit = self:AddComponent(UIButton, 'Root/NodeBottom/BtnRecruit')
    self.btnRecruit2 = self:AddComponent(UIButton, 'Root/NodeBottom/BtnRecruit2')
    self.textRecruit = self:AddComponent(UITextMeshProUGUIEx, 'Root/NodeBottom/BtnRecruit/TextRecruit')
    self.TextBtn2 = self:AddComponent(UITextMeshProUGUIEx, 'Root/NodeBottom/BtnRecruit2/TextBtn2')
    self.imgCost = self:AddComponent(UIImage, 'Root/NodeBottom/BtnRecruit2/ImgCost')
    self.textCost = self:AddComponent(UITextMeshProUGUIEx, 'Root/NodeBottom/BtnRecruit2/ImgCost/TextCost')
    
    self.btnRecruit:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
    self.btnRecruit2:SetOnClick(BindCallback(self, self.OnBtnRecruitClick))
end

local function ComponentDestroy(self)
    self.nodeRoot = nil
    self.rootAni = nil
    self.btnClose = nil
    self.topBar = nil
    self.textTitle = nil
    self.itemBar = nil
    self.content = nil
    self.cardPosList = nil
    self.nodeBottom = nil
    self.btnRecruit = nil
    self.textRecruit = nil
    self.imgCost = nil
    self.textCost = nil
end

local function DataDefine(self)
    self.lotteryHeroData = nil
    self.nodeCards = {}
    self.cardRequestList = {}
    self.eventHandler = {}
    self.canClick = true
    self.directEnd = false
    self.delayTimer = nil
    self.touchCardEnable = true
end

local function DataDestroy(self)
    self.lotteryHeroData = nil
    self.nodeCards = nil
    self.cardRequestList = nil
    self.eventHandler = nil
    self.directEnd = nil
    self.touchCardEnable = true
end

local function OnEnable(self)
    base.OnEnable(self)
    SoundUtil.PlayEffect(SoundAssets.Effect_Recruit_Card_Befall)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)

    self:AddUIListener(EventId.ToggleRecruitScene, self.OnToggleRecruitScene)
    self:AddUIListener(EventId.RefreshItems, self.OnRefreshItems)
    self:AddUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.HeroicRecruitmentData, self.OnHandleRecruitResponse)
    self:RemoveUIListener(EventId.RefreshItems, self.OnRefreshItems)
    self:RemoveUIListener(EventId.ToggleRecruitScene, self.OnToggleRecruitScene)
    
    base.OnRemoveListener(self)
end

local function OnOpen(self)
    local isFirstPlayAni = self.drawCardTime == 0
    self.isMoreThanOne = table.count(self.lotteryHeroData) > 1
    self.isPlayingWaitAni = false

    if isFirstPlayAni then
        if self.isMoreThanOne then
            self.lotteryState = HeroRecruitState.PlayOpenAni
        else
            self.lotteryState = HeroRecruitState.PlayOpenAni
        end
    else
        self.lotteryState = HeroRecruitState.OpenWithoutAni
    end

    self.isWaitHeroExhibit = false
    
    --招募道具及消耗
    local costItems = self.lotteryData:GetCostItems()
    self.itemId = costItems[1].itemId
    self.recruitCost1 = tonumber(costItems[1].itemNum)
    if self.isMoreThanOne then
        if costItems[2] ~= nil then
            self.recruitCost2 = tonumber(costItems[2].itemNum)
        end
    end
    self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))

    self.openCardDict = {}
    self.openCardCount = 0
    self.heroShowUuidList = {}
    self.heroShowUuidExtraDataList = {}
    self.heroShowUuidListIndex = 1


    self:UpdateTopItemBar()
    self:RefreshNodeBottom()
    self:RefreshContentAtOpen()

    self:TryStateFunc()
end

local function RefreshNodeBottom(self)
    -- self.btnRecruit:SetActive(true)
    if self.lotteryState == HeroRecruitState.PlayOpenAni then
        self.nodeBottom:SetActive(false)
    elseif self.lotteryState == HeroRecruitState.Manual then
        if self.isMoreThanOne then
            self.nodeBottom:SetActive(true)

            -- self.btnRecruit:SetActive(true)
            self.btnRecruit2:SetActive(false)
            self.imgCost:SetActive(false)
            self.btnClose:SetActive(false)
            self.textRecruit:SetLocalText(321364)
        else
            self.nodeBottom:SetActive(false)
        end
    elseif self.lotteryState == HeroRecruitState.Auto then
        self.nodeBottom:SetActive(true)
        
        -- self.btnRecruit:SetActive(true)
        self.btnRecruit2:SetActive(false)
        self.imgCost:SetActive(false)
        self.btnClose:SetActive(false)
        self.textRecruit:SetLocalText(321365)
    elseif self.lotteryState == HeroRecruitState.All then
        self.nodeBottom:SetActive(false)
    elseif self.lotteryState == HeroRecruitState.OpenWithoutAni then
        self.nodeBottom:SetActive(false)
    elseif self.lotteryState == HeroRecruitState.QuicklyAuto then
        self.nodeBottom:SetActive(false)
    elseif self.lotteryState == HeroRecruitState.Fin then
        self.nodeBottom:SetActive(true)

        self.btnRecruit:SetActive(false)
        -- self.btnRecruit2:SetActive(true)
        self.imgCost:SetActive(true)
        self.btnClose:SetActive(true)

        local canFreeRecruit = false
        if not self.isMoreThanOne then
            canFreeRecruit = self.lotteryData:IsSupportFreeRecruit()
            if canFreeRecruit then
                canFreeRecruit = self.lotteryData:CanFreeRecruit()
            end
        end

        if canFreeRecruit then
            self.imgCost:SetActive(false)
        else
            -- modified by lvfeng. 小凡需求：招募结束后，如果招募道具数量不足，隐藏招募按钮
            local item = DataCenter.ItemData:GetItemById(tonumber(self.itemId))
            local itemCount = item and item.count or 0
            local needCount = self.isMoreThanOne and self.recruitCost2 or self.recruitCost1
            if itemCount >= needCount then
                self.imgCost:SetActive(true)
                self.imgCost:LoadSprite(string.format(LoadPath.ItemPath,
                    DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId).icon))
                self.textCost:SetText(string.GetFormattedSeperatorNum(self.isMoreThanOne and self.recruitCost2 or
                    self.recruitCost1))
            else
                self.imgCost:SetActive(true)
                self.imgCost:LoadSprite(string.format(LoadPath.ItemPath,
                    DataCenter.ItemTemplateManager:GetItemTemplate(self.itemId).icon))
                self.textCost:SetText(string.format("<color=#CD2626>%s</color>", needCount))
                self.btnRecruit:SetActive(false)
            end
        end

        self.TextBtn2:SetLocalText(self.isMoreThanOne and 110116 or 110115)
    end
end

local function UpdateTopItemBar(self)
    self.itemBar:SetActive(true)
    self.itemBar:SetData(self.itemId)
end

local function RefreshItemViewByIndex(self, i)
    local lotteryId = self.lotteryData.id
    if self.lotteryHeroData[i] ~= nil then
        local data = self.lotteryHeroData[i]
        self.cardPosList[i].cardItem:SetData(lotteryId, i, data, function ()
            self:OnCardItemClick(i)
        end)
        if self.openCardDict[i] == nil then
            self.cardPosList[i].cardItem:SetCoverView()
        else
            self.cardPosList[i].cardItem:SetNormalView()
        end
    end 
end

local function RefreshContentAtOpen(self)
    if self.isMoreThanOne then
        -- 多抽
        for i = 1, 10 do
            if i <= #self.lotteryHeroData then
                self.cardPosList[i]:SetActive(true)
                self.cardPosList[i]:SetAnchoredPositionXY(cardPosDataList[i].x, cardPosDataList[i].y)
                self.cardPosList[i]:SetEulerAnglesXYZ(0,0,0)
                self.cardPosList[i]:SetLocalScaleXYZ(1,1,1)
                self:RefreshItemViewByIndex(i)
            else
                self.cardPosList[i]:SetActive(false)
            end
        end
    else 
        -- 单抽
        for i = 1,#self.cardPosList do
            if i == 1 then
                self.cardPosList[i]:SetActive(true)
                self.cardPosList[i]:SetAnchoredPositionXY(0,0)
                self.cardPosList[i]:SetEulerAnglesXYZ(0,0,0)
                self.cardPosList[i]:SetLocalScaleXYZ(1,1,1)
                self:RefreshItemViewByIndex(i)
            else
                self.cardPosList[i]:SetActive(false)
            end
        end
    end
end

--  走状态逻辑
local function TryStateFunc(self)
    if self.lotteryState == HeroRecruitState.PlayOpenAni then
        self.clickText:SetActive(false)
        self:StopDelayTimer()
        self.rootAni:Enable(true)

        if self.isMoreThanOne then
            self.rootAni:Play(openAni, 0, 0) -- openOneAni
        else
            self.rootAni:Play(openOneAni, 0, 0)
        end
        
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
            if self ~= nil then
                self:StopDelayTimer()
                self.rootAni:Enable(false)
                self.lotteryState = HeroRecruitState.Auto
                self:UpdateTopItemBar()
                self:RefreshNodeBottom()
                self:RefreshContentAtOpen()
                self:TryStateFunc()
            end
        end, self.isMoreThanOne and openAniTimeTen or openAniTimeSingle)
    elseif self.lotteryState == HeroRecruitState.Manual then
        -- need hero exhibit
        if self.heroShowUuidList[self.heroShowUuidListIndex] ~= nil then
            if self.isWaitHeroExhibit == false then
                self.isWaitHeroExhibit = true
                self:StopDelayTimer()
                self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                    if self ~= nil then
                        self:StopDelayTimer()
                        self.isWaitHeroExhibit = false
                        local targetUuid = self.heroShowUuidList[self.heroShowUuidListIndex]
                        local extraData = self.heroShowUuidExtraDataList[self.heroShowUuidListIndex]
                        local showTip = extraData.isHero and "" or Localization:GetString(441004)
                        self.heroShowUuidListIndex = self.heroShowUuidListIndex + 1
                        UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, targetUuid)
                    end
                end, self.isMoreThanOne and openAniTimeTen or openAniTimeSingle)
            end
        elseif #self.lotteryHeroData == self.openCardCount then
            self.lotteryState = HeroRecruitState.Fin
            self:TryStateFunc()
        end
    elseif self.lotteryState == HeroRecruitState.Auto then
        self.clickText:SetActive(false)
        if self.heroShowUuidList[self.heroShowUuidListIndex] ~= nil then
            return
        elseif self.heroShowUuidList[self.heroShowUuidListIndex] == nil then
            if #self.lotteryHeroData > self.openCardCount then
                local getNextIndex = 1
                for i = 1,#self.lotteryHeroData do
                    if self.openCardDict[i] == nil then
                        getNextIndex = i
                        break
                    end
                end

                -- 没打开过
                if self.openCardDict[getNextIndex] == nil then
                    self.openCardDict[getNextIndex] = 1
                    self.openCardCount = self.openCardCount + 1
                    local targetUuid = self.cardPosList[getNextIndex].cardItem.heroUuid
                    -- if targetUuid == nil then
                    --     targetUuid = self.cardPosList[getNextIndex].cardItem.heroId
                    -- end
                    local isShowHeroExhibit = false
                    if targetUuid ~= nil then
                        isShowHeroExhibit = DataCenter.HeroDataManager:IsNewHero(targetUuid) and DataCenter.HeroDataManager:NeedShowNewHeroWindow(targetUuid)
                    end
                    local delayTime = 1
                    if isShowHeroExhibit then
                        table.insert(self.heroShowUuidList, targetUuid)
                        table.insert(self.heroShowUuidExtraDataList, {
                            index = getNextIndex,
                            isHero = self.cardPosList[getNextIndex].cardItem.heroUuid ~= nil,
                        })
                        self.cardPosList[getNextIndex].cardItem:PlayWaitingOpenAni()
                        if self.cardPosList[getNextIndex].cardItem.isPurpleCard then
                        elseif self.cardPosList[getNextIndex].cardItem.isOrangeCard then
                        else
                        end
                        delayTime = shockAniTime
                    else
                        self.cardPosList[getNextIndex].cardItem:PlayOpenAni()
                        delayTime = autoWaitOpenTime
                    end

                    self:StopDelayTimer()
                    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                        if self ~= nil then
                            self:StopDelayTimer()
                            if self.heroShowUuidList[self.heroShowUuidListIndex] ~= nil then
                                -- for i = 1,#self.lotteryHeroData do
                                --     if self.openCardDict[i] ~= nil then
                                --         self.cardPosList[i].cardItem:SetNormalView()
                                --     end
                                -- end
                                local targetUuid = self.heroShowUuidList[self.heroShowUuidListIndex]
                                local extraData = self.heroShowUuidExtraDataList[self.heroShowUuidListIndex]
                                local showTip = extraData.isHero and "" or Localization:GetString(441004)
                                self.heroShowUuidListIndex = self.heroShowUuidListIndex + 1
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, targetUuid)
                            else
                                self:TryStateFunc()
                            end
                        end
                    end, delayTime)
                end
            elseif #self.lotteryHeroData == self.openCardCount then
                self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                    self.lotteryState = HeroRecruitState.Fin
                    self:TryStateFunc()
                end, 0.5)
            end
        end
    elseif self.lotteryState == HeroRecruitState.All then
        if self.heroShowUuidList[self.heroShowUuidListIndex] ~= nil then
            return
        else
            if #self.lotteryHeroData > self.openCardCount then
                local delayTime = autoWaitOpenTime
                for i = 1,#self.lotteryHeroData do
                    if self.openCardDict[i] == nil then
                        -- 没打开过
                        if self.openCardDict[i] == nil then
                            self.openCardDict[i] = 1
                            self.openCardCount = self.openCardCount + 1
                            local targetUuid = self.cardPosList[i].cardItem.heroUuid
                            local isShowHeroExhibit = false
                            if targetUuid ~= nil then
                                isShowHeroExhibit = DataCenter.HeroDataManager:IsNewHero(targetUuid) and DataCenter.HeroDataManager:NeedShowNewHeroWindow(targetUuid)
                            end
                            
                            if isShowHeroExhibit then
                                table.insert(self.heroShowUuidList, targetUuid)
                                table.insert(self.heroShowUuidExtraDataList, {
                                    index = i,
                                    isHero = self.cardPosList[i].cardItem.heroUuid ~= nil,
                                })
                                self.cardPosList[i].cardItem:PlayWaitingOpenAni()
                                if self.cardPosList[i].cardItem.isPurpleCard then
                                elseif self.cardPosList[i].cardItem.isOrangeCard then
                                else
                                end
                                delayTime = shockAniTime
                            else
                                self.cardPosList[i].cardItem:PlayOpenAni()
                            end
                        end
                    end
                end
                if delayTime > 0 then
                    self:StopDelayTimer()
                    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                        if self ~= nil then
                            self:StopDelayTimer()
                            if self.heroShowUuidList[self.heroShowUuidListIndex] ~= nil then
                                local targetUuid = self.heroShowUuidList[self.heroShowUuidListIndex]
                                local extraData = self.heroShowUuidExtraDataList[self.heroShowUuidListIndex]
                                local showTip = extraData.isHero and "" or Localization:GetString(441004)
                                self.heroShowUuidListIndex = self.heroShowUuidListIndex + 1
                                UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, targetUuid)
                            else
                                self:TryStateFunc()
                            end
                        end
                    end, delayTime)
                end
            else
                self.lotteryState = HeroRecruitState.Fin
                self:TryStateFunc()
            end
        end
    elseif self.lotteryState == HeroRecruitState.Fin then
        self.clickText:SetActive(true)
        self:UpdateTopItemBar()
        self:RefreshNodeBottom()
    elseif self.lotteryState == HeroRecruitState.OpenWithoutAni then
        self:StopDelayTimer()
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
            self.lotteryState = HeroRecruitState.All
            self:TryStateFunc()
        end, 0.3)
    elseif self.lotteryState == HeroRecruitState.QuicklyAuto then

    end
end

local function OnToggleRecruitScene(self, visible)
    if visible then
        for i = 1,#self.lotteryHeroData do
            if self.openCardDict[i] ~= nil then
                self.cardPosList[i].cardItem:SetNormalView()
            end
        end
        
        self:StopDelayTimer()
        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
            if self.heroShowUuidList[self.heroShowUuidListIndex] ~= nil then
                local targetUuid = self.heroShowUuidList[self.heroShowUuidListIndex]
                local extraData = self.heroShowUuidExtraDataList[self.heroShowUuidListIndex]
                local showTip = extraData.isHero and "" or Localization:GetString(441004)
                self.heroShowUuidListIndex = self.heroShowUuidListIndex + 1
                UIManager:GetInstance():OpenWindow(UIWindowNames.UINewHero, targetUuid)
            else
                self:TryStateFunc()
            end
        end, 0.1)
    end
end

local function OnContentClick(self)
    if self.lotteryState == HeroRecruitState.Manual then
        self:OnBtnRecruitClick()
    elseif self.lotteryState == HeroRecruitState.Auto then
        --self:OnBtnRecruitClick()
    elseif self.lotteryState == HeroRecruitState.Fin then
        self.ctrl:CloseSelf()
    end
end

local function OnBtnRecruitClick(self)
    if self.lotteryState == HeroRecruitState.PlayOpenAni then
        
    elseif self.lotteryState == HeroRecruitState.Manual then
        self.lotteryState = HeroRecruitState.Auto
        self:RefreshNodeBottom()
        self:TryStateFunc()
    elseif self.lotteryState == HeroRecruitState.Auto then
        self.lotteryState = HeroRecruitState.All
        self:RefreshNodeBottom()
        self:TryStateFunc()
    elseif self.lotteryState == HeroRecruitState.All then

    elseif self.lotteryState == HeroRecruitState.Fin then

        -- 防止连点
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if curTime < sendMsgTime + 1000 then
            return
        end
        sendMsgTime = curTime
        
        local canFreeRecruit = false
        if not self.isMoreThanOne then
            canFreeRecruit = self.lotteryData:IsSupportFreeRecruit()
            if canFreeRecruit then
                canFreeRecruit = self.lotteryData:CanFreeRecruit()
            end
        end

        if not canFreeRecruit then
            if not self.isMoreThanOne and self.itemHave < self.recruitCost1 then
                local lackTab = {}
                local param = {}
                param.type = ResLackType.Item
                param.id = tonumber(self.itemId)
                param.targetNum = self.recruitCost1
                table.insert(lackTab, param)
                GoToResLack.GoToItemResLackList(lackTab)
            elseif self.isMoreThanOne and self.itemHave < self.recruitCost2 then
                local lackTab = {}
                local param = {}
                param.type = ResLackType.Item
                param.id = tonumber(self.itemId)
                param.targetNum = self.recruitCost2
                table.insert(lackTab, param)
                GoToResLack.GoToItemResLackList(lackTab)
            elseif self.isMoreThanOne then
                --连抽
                if self.recruitCost2 and self.itemHave >= self.recruitCost2 then
                    SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 1, 0, self.itemId)
                end
            else
                --单抽
                if canFreeRecruit then
                    SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 0, 1, self.itemId)
                else
                    SFSNetwork.SendMessage(MsgDefines.LotteryHeroCard, self.lotteryData.id, 0, 0, self.itemId)
                end
            end
        end
    end
end

local function OnCardItemClick(self, index)
    -- 手动翻卡
    if self.lotteryState == HeroRecruitState.Manual then
        -- 没打开过
        if self.openCardDict[index] == nil then
            self.openCardDict[index] = 1
            self.openCardCount = self.openCardCount + 1
            local targetUuid = self.cardPosList[index].cardItem.heroUuid
            local isShowHeroExhibit = false
            if targetUuid ~= nil then
                isShowHeroExhibit = DataCenter.HeroDataManager:IsNewHero(targetUuid) and DataCenter.HeroDataManager:NeedShowNewHeroWindow(targetUuid)
            end
            if isShowHeroExhibit then
                table.insert(self.heroShowUuidList, targetUuid)
                table.insert(self.heroShowUuidExtraDataList, {
                    index = index,
                    isHero = self.cardPosList[index].cardItem.heroUuid ~= nil,
                })
                self.cardPosList[index].cardItem:PlayWaitingOpenAni()
                if self.cardPosList[index].cardItem.isPurpleCard then
                elseif self.cardPosList[index].cardItem.isOrangeCard then
                else
                end
            else
                self.cardPosList[index].cardItem:PlayOpenAni()
            end

            self:TryStateFunc()
        end
    end
end

local function OnHandleRecruitResponse(self, message)
    local lotteryHeroData = message['lotteryHero']
    self.lotteryHeroData = lotteryHeroData
    self.drawCardTime = self.drawCardTime + 1
    self:OnOpen()
end

local function OnRefreshItems(self)
    local costItems = self.lotteryData:GetCostItems()
    self.itemId = costItems[1].itemId
    self.recruitCost1 = tonumber(costItems[1].itemNum)
    if self.isMoreThanOne then
        if costItems[2] ~= nil then
            self.recruitCost2 = tonumber(costItems[2].itemNum)
        end
    end
    self.itemHave = CommonUtil.GetResOrItemCount(tonumber(self.itemId))
    
    self:UpdateTopItemBar()
    self:RefreshNodeBottom()
end


UIHeroRecruitReward.OnCreate= OnCreate
UIHeroRecruitReward.OnDestroy = OnDestroy
UIHeroRecruitReward.OnEnable = OnEnable
UIHeroRecruitReward.OnDisable = OnDisable
UIHeroRecruitReward.OnAddListener = OnAddListener
UIHeroRecruitReward.OnRemoveListener = OnRemoveListener
UIHeroRecruitReward.ComponentDefine = ComponentDefine
UIHeroRecruitReward.ComponentDestroy = ComponentDestroy
UIHeroRecruitReward.DataDefine = DataDefine
UIHeroRecruitReward.DataDestroy = DataDestroy

UIHeroRecruitReward.OnOpen = OnOpen
UIHeroRecruitReward.RefreshNodeBottom = RefreshNodeBottom
UIHeroRecruitReward.UpdateTopItemBar = UpdateTopItemBar
UIHeroRecruitReward.RefreshContentAtOpen = RefreshContentAtOpen
UIHeroRecruitReward.RefreshItemViewByIndex = RefreshItemViewByIndex
UIHeroRecruitReward.OnToggleRecruitScene = OnToggleRecruitScene
UIHeroRecruitReward.OnContentClick = OnContentClick
UIHeroRecruitReward.OnBtnRecruitClick = OnBtnRecruitClick
UIHeroRecruitReward.OnHandleRecruitResponse = OnHandleRecruitResponse
UIHeroRecruitReward.OnRefreshItems = OnRefreshItems
UIHeroRecruitReward.OnCardItemClick = OnCardItemClick
UIHeroRecruitReward.TryStateFunc = TryStateFunc
UIHeroRecruitReward.StopDelayTimer = StopDelayTimer

return UIHeroRecruitReward
