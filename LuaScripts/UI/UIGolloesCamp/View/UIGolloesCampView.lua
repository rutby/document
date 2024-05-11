---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---

local base = UIBaseView--Variable
local UIGolloesCampView = BaseClass("UIGolloesCampView", base)--Variable
local Localization = CS.GameEntry.Localization
local RewardUtil = require "Util.RewardUtil"
local GolloesCampItem = require "UI.UIGolloesCamp.Component.GolloesCampItem"
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local backBtn_path = "safeArea/backBtn"
local golloesContent_path = "safeArea/golloes"
--local lockedTipTxt_path = "safeArea/container/locked/Image/lockedTip"
--local monthCardBtn_path = "safeArea/container/locked/monthCardBtn"
--local monthCardBtnTxt_path = "safeArea/container/locked/monthCardBtn/goTxt"
local unlockedContainer_path = "safeArea/container/center"
local golloesInfoContainer_path = "safeArea/container/center/golloesInfo"
local golloesNameBg_path = "safeArea/container/center/golloesInfo/golloesName"
local golloesNameIcon_path = "safeArea/container/center/golloesInfo/golloesName/icon"
local golloesTypeName_path = "safeArea/container/center/golloesInfo/golloesName/golloesName"
local golloesDescTxt_path = "safeArea/container/center/golloesInfo/golloesDesc"
local golloesSendAnim_path = "safeArea/container/center/sendBtnAnim"
local golloesSendBtn_path = "safeArea/container/center/sendBtnAnim/sendBtn"
local golloesSendBtnTxt_path = "safeArea/container/center/sendBtnAnim/sendBtn/sendTxt"

local needMcContainer_path = "safeArea/container/center/golloes/mc"
local needMcTip_path = "safeArea/container/center/golloes/mc/mcTip"
local btnJumpToMc_path = "safeArea/container/center/golloes/mc/jumoToMc"
local remainTimeContainer_path = "safeArea/container/center/golloes/time"
local remainTimeTip_path = "safeArea/container/center/golloes/time/remainTimeTip"
local remainTimeTxt_path = "safeArea/container/center/golloes/time/remainTime"
local autoClaim_path = "BoxRewardView"
local autoClaimPanel_path = "BoxRewardView/panel"
local autoClaimAnim_path = "BoxRewardView/anim"


local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:InitUI()
end

local function OnDestroy(self)
    self:DelTimer()
    self:DelAddGolloesTimer()
    if self.delayClaimTimer then
        self.delayClaimTimer:Stop()
        self.delayClaimTimer = nil
    end
    self:DelRewardBoxTimer()
    self:SetAllCellDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.backBtnN = self:AddComponent(UIButton, backBtn_path)
    self.backBtnN:SetOnClick(function()
        self:OnClickBackBtn()
    end)
    self.golloesContentN = self:AddComponent(UIBaseContainer, golloesContent_path)
    --self.lockedTipTxtN = self:AddComponent(UITextMeshProUGUIEx, lockedTipTxt_path)
    --self.lockedTipTxtN:SetLocalText(320205)
    --self.monthCardBtnN = self:AddComponent(UIButton, monthCardBtn_path)
    --self.monthCardBtnN:SetOnClick(function()
    --    self:OnClickMonthCardBtn()
    --end)
    --self.monthCardBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, monthCardBtnTxt_path)
    --self.monthCardBtnTxtN:SetLocalText(110076)
    self.unlockedContainerN = self:AddComponent(UIBaseContainer, unlockedContainer_path)
    self.golloesInfoContainerN = self:AddComponent(UIBaseContainer, golloesInfoContainer_path)
    self.golloesNameBgN = self:AddComponent(UIImage, golloesNameBg_path)
    self.golloesNameIconN = self:AddComponent(UIImage, golloesNameIcon_path)
    self.golloesNameTxtN = self:AddComponent(UITextMeshProUGUIEx, golloesTypeName_path)
    self.golloesDescTxtN = self:AddComponent(UITextMeshProUGUIEx, golloesDescTxt_path)
    self.golloesSendAnimN = self:AddComponent(UIButton, golloesSendAnim_path)
    self.golloesSendBtnN = self:AddComponent(UIButton, golloesSendBtn_path)
    self.golloesSendBtnN:SetOnClick(function()
        self:OnClickSendBtn()
    end)
    self.golloesSendBtnTxtN = self:AddComponent(UITextMeshProUGUIEx, golloesSendBtnTxt_path)
    self.golloesCells = {}
    
    self.needMcContainerN = self:AddComponent(UIBaseContainer, needMcContainer_path)
    self.needMcTipN = self:AddComponent(UITextMeshProUGUIEx, needMcTip_path)
    self.needMcTipN:SetLocalText(320335)
    self.remainTimeContainerN = self:AddComponent(UIBaseContainer, remainTimeContainer_path)
    self.remainTimeTipN = self:AddComponent(UITextMeshProUGUIEx, remainTimeTip_path)
    self.remainTimeTipN:SetLocalText(320336)
    self.remainTimeN = self:AddComponent(UITextMeshProUGUIEx, remainTimeTxt_path)
    self.btnJumpToMcN = self:AddComponent(UIButton, btnJumpToMc_path)
    self.btnJumpToMcN:SetOnClick(function()
        self:OnClickMonthCardBtn()
    end)
    self.autoClaimN = self:AddComponent(UIBaseContainer, autoClaim_path)
    self.autoClaimN:SetActive(false)
    self.autoClaimAnimN = self:AddComponent(UIAnimator, autoClaimAnim_path)
    self.autoClaimPanelN = self:AddComponent(UIButton, autoClaimPanel_path)

    self._giftBar_rect = self:AddComponent(UIButton,"safeArea/GiftBar")
    self._giftName_txt = self:AddComponent(UITextMeshProUGUIEx,"safeArea/GiftBar/Txt_GiftName")
    self._giftContent_rect = self:AddComponent(UIBaseContainer,"safeArea/GiftBar/Rect_GiftContentMask")
    self._giftContent_txt = self:AddComponent(UITextMeshProUGUIEx,"safeArea/GiftBar/Rect_GiftContentMask/Txt_GiftContent")
    self._giftBuy_btn = self:AddComponent(UIButton,"safeArea/GiftBar/BtnBuy")
    self._giftBuy_txt = self:AddComponent(UITextMeshProUGUIEx,"safeArea/GiftBar/BtnBuy/Txt_Buy")
    self.point_rect = self:AddComponent(UIGiftPackagePoint,"safeArea/GiftBar/BtnBuy/UIGiftPackagePoint")
    self._giftBuy_btn:SetOnClick(function()
        self:BuyGift()
    end)
    
    self._trader_btn = self:AddComponent(UIButton,"safeArea/container/center/Btn_Trader")
    self._trader_txt = self:AddComponent(UITextMeshProUGUIEx,"safeArea/container/center/Btn_Trader/Txt_Trader")
    self._trader_txt:SetLocalText(321107)
    self._traderRed_rect = self:AddComponent(UIBaseContainer,"safeArea/container/center/Btn_Trader/Rect_TraderRed")
    self._trader_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickCaravan()
    end)
end

local function ComponentDestroy(self)
    self.backBtnN = nil
    self.golloesContentN = nil
    self.lockedTipTxtN = nil
    self.monthCardBtnN = nil
    self.monthCardBtnTxtN = nil
    self.unlockedContainerN = nil
    self.golloesCountTxtN = nil
    self.golloesIconN = nil
    self.claimGolloesBtnN = nil
    self.golloesInfoContainerN = nil
    self.golloesNameTxtN = nil
    self.golloesDescTxtN = nil
    self.golloesSendBtnN = nil
    self.golloesSendBtnTxtN = nil
    self.remainTimeTxtN = nil
    self.golloesCells = nil
    self.needMcContainerN = nil
    self.needMcTipN = nil
    self.remainTimeContainerN = nil
    self.remainTimeTipN = nil
    self.remainTimeN = nil
end

local function DataDefine(self)
    self.cacheGolloesCount = 0
    self.golloesMonthCard = nil
    self.timer = nil
    self.rewardBoxTimer = nil
    self.model = {}
    self.curSelectedGolloes = nil
    local strCost = LuaEntry.DataConfig:TryGetStr("golloes_dispatch_para", "k2")
    self.golloesCostTb = string.split(strCost, ";")
    self.isOpeningBox = nil
end

local function DataDestroy(self)
    self.cacheGolloesCount = nil
    self.golloesMonthCard = nil
    self.timer = nil
    self.rewardBoxTimer = nil
    self.model = nil
    self.curSelectedGolloes = nil
    self.golloesCostTb = nil
    self.isOpeningBox = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.MonthCardInfoUpdated, self.RefreshUI)
    self:AddUIListener(EventId.GolloesDataChange, self.RefreshUI)
    self:AddUIListener(EventId.MarchItemUpdateSelf, self.RefreshUI)
    self:AddUIListener(EventId.OnRewardGetPanelClose, self.HideAutoClaim)
    self:AddUIListener(EventId.ColloesCaravanRecord, self.CaravanRecordRefresh)
    self:AddUIListener(EventId.ColloesCaravanRed, self.ColloesCaravanRed)
    self:AddUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.MonthCardInfoUpdated, self.RefreshUI)
    self:RemoveUIListener(EventId.GolloesDataChange, self.RefreshUI)
    self:RemoveUIListener(EventId.MarchItemUpdateSelf, self.RefreshUI)
    self:RemoveUIListener(EventId.OnRewardGetPanelClose, self.HideAutoClaim)
    self:RemoveUIListener(EventId.ColloesCaravanRecord, self.CaravanRecordRefresh)
    self:RemoveUIListener(EventId.ColloesCaravanRed, self.ColloesCaravanRed)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
    base.OnRemoveListener(self)
end

local function InitUI(self)
    SFSNetwork.SendMessage(MsgDefines.GetGolloesCaravanRecord)
    self.golloesMonthCard = DataCenter.MonthCardNewManager:GetGolloesMonthCard()
    self:RefreshUI()
    self:TryClaimDailyGolloes()
    --local isBought = self.golloesMonthCard:IsBought()
    --if isBought then
    --end
end

local function RefreshUI(self)
    self:RefreshGridContent()
    self:RefreshContainer()
    self:TrySelectGolloes(self.curSelectedGolloes)
end

local function RefreshGridContent(self)
    if self.golloesCells and table.count(self.golloesCells) == 4 then
        for i, v in pairs(self.golloesCells) do
            v:RefreshItem(i)
        end
        return
    else
        self:SetAllCellDestroy()
        for k,v in ipairs(GolloesTypeOrderList) do
            self.model[v] = self:GameObjectInstantiateAsync(UIAssets.GolloesCampItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(false)
                go.transform:SetParent(self.golloesContentN.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = self:GetGolloesTypeName(v)
                go.name = nameStr
                local cell = self.golloesContentN:AddComponent(GolloesCampItem,nameStr)
                cell:RefreshItem(v)
                cell:SetSelected(false)
                self.golloesCells[v] = cell
                TimerManager:GetInstance():DelayInvoke(function()
                    go.gameObject:SetActive(true)
                end, (k) * 0.1)
            end)
        end
    end
end
local function GetGolloesTypeName(self,golloesType)
    for k,v in pairs(GolloesType) do
        if v == golloesType then
            return k
        end
    end
end


local function SetAllCellDestroy(self)
    self.golloesContentN:RemoveComponents(GolloesCampItem)
    if self.model~=nil then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.model ={}
    self.golloesCells = {}
end

local function RefreshContainer(self)
    local isBought = self.golloesMonthCard:IsBought()
    if isBought then
        self.needMcContainerN:SetActive(false)
        self.remainTimeContainerN:SetActive(true)
        
        self:SetRemainTime()
        self:AddTimer()
        
    else
        self.needMcContainerN:SetActive(true)
        self.remainTimeContainerN:SetActive(false)
        self:DelTimer()
    end

    --[[
    if isBought then
        self.lockedContainerN:SetActive(false)
        self.unlockedContainerN:SetActive(true)
        
        local maxGolloesNum = LuaEntry.DataConfig:TryGetNum("golloes_dispatch_para", "k1")
        local myGolloesNum = DataCenter.GolloesCampManager:GetGolloesCount()

        self.golloesCountTxtN:SetText(myGolloesNum .. "/" .. maxGolloesNum)

        local todayClaimed = self.golloesMonthCard:IsTodayClaimed()
        if todayClaimed then
            self.unopenedBoxBtnN:SetActive(false)
            self.openedBoxBtnN:SetActive(true)
            self:DelRewardBoxTimer()
            --self.claimGolloesIconN:LoadSprite("Assets/Main/Sprites/UI/UIVip/UIVip_img_box3_2.png")
        else
            --self.claimGolloesIconN:LoadSprite("Assets/Main/Sprites/UI/UIVip/UIVip_img_box3_1.png")
            self.unopenedBoxBtnN:SetActive(true)
            self.openedBoxBtnN:SetActive(false)
            --self:AddRewardBoxTimer()--动画自动循环，不需要代码循环播放了
            self:ShowRewardBoxEff()
        end

        self:SetRemainTime()
        self:AddTimer()
    else
        self.lockedContainerN:SetActive(true)
        self.unlockedContainerN:SetActive(false)

        self:DelTimer()
        self.remainTimeTxtN:SetText("")
    end
    --]]
end

local function TryClaimDailyGolloes(self)
    local isBought = self.golloesMonthCard:IsBought()
    if isBought then
        local todayClaimed = self.golloesMonthCard:IsTodayClaimed()
        if not todayClaimed then
            self.autoClaimN:SetActive(true)
            self.autoClaimAnimN:Play("V_guluyuekabaoxiang_anim", 0, 0)
            self.delayClaimTimer = TimerManager:GetInstance():DelayInvoke(function()
                self.ctrl:ClaimDailyRewards(self.golloesMonthCard.monthCardId)
                self.delayClaimTimer = nil
                self.autoClaimPanelN:SetOnClick(function()
                    self:HideAutoClaim()
                end)
            end, 2)
            return
        end
    end
    
    local hasFree = DataCenter.GolloesCampManager:CheckIfCanClaimFreeGolloes()
    if hasFree then
        self.autoClaimN:SetActive(true)
        self.autoClaimAnimN:Play("V_guluyuekabaoxiang_anim", 0, 0)
        self.delayClaimTimer = TimerManager:GetInstance():DelayInvoke(function()
            self.ctrl:ClaimFreeRewards()
            self.delayClaimTimer = nil
            self.autoClaimPanelN:SetOnClick(function()
                self:HideAutoClaim()
            end)
        end, 2)
        return
    end

    self.autoClaimN:SetActive(false)
end

local function HideAutoClaim(self)
    self.autoClaimN:SetActive(false)
end

--Obsolete
local function ClaimDailyGolloes(self)
    
    self.delayClaimTimer = TimerManager:GetInstance():DelayInvoke(function()
        self.ctrl:ClaimDailyRewards(self.golloesMonthCard.monthCardId)
        self.delayClaimTimer = nil
    end, 1)--托底刷新

    self:StartOpenBoxAnim()
    

    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Common_GetReward)
end

local function TrySelectGolloes(self, golloesType)
    if not golloesType then
        self.golloesInfoContainerN:SetActive(false)
        self._giftBar_rect:SetActive(false)
        self._trader_btn:SetActive(false)
        self.golloesSendAnimN:SetActive(false)
    elseif self.curSelectedGolloes ~= golloesType then
        SoundUtil.PlayEffect(GolloesSound[golloesType])
        self.golloesInfoContainerN:SetActive(true)
        self.golloesSendAnimN:SetActive(true)
        if self.curSelectedGolloes then
            self.golloesCells[self.curSelectedGolloes]:SetSelected(false)
        end
        self.curSelectedGolloes = golloesType
        self.golloesCells[self.curSelectedGolloes]:SetSelected(true)

        local golloesShow = GolloesShow[self.curSelectedGolloes]
        self.golloesNameTxtN:SetLocalText(golloesShow.name)
        self.golloesNameBgN:LoadSprite(string.format(LoadPath.GolloesCampPath,golloesShow.nameBg))
        self.golloesNameIconN:LoadSprite(string.format(LoadPath.GolloesCampPath,golloesShow.costIcon))
        --self.golloesNameTxtN:SetColor(golloesShow.color)
        self.golloesDescTxtN:SetLocalText(golloesShow.desc)
        
        self:SetSendBtnState()

        if (golloesType == GolloesType.Worker or golloesType == GolloesType.Explorer) and self.ctrl:IsEasySend() then
            self.golloesSendBtnTxtN:SetLocalText(320928)
        else
            self.golloesSendBtnTxtN:SetLocalText(390146)
        end
        
        self._trader_btn:SetActive(golloesType == GolloesType.Trader)

        if golloesType == GolloesType.Worker then
            local isBought = self.golloesMonthCard:IsBought()
            if isBought then
                self.packageInfo = self.ctrl:GePackageInfo()
                if self.packageInfo then
                    self._giftBar_rect:SetActive(true)
                    self._giftName_txt:SetLocalText(self.packageInfo:getName())
                    self._giftContent_txt:SetText(self.packageInfo:getDescText())
                    local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
                    self._giftBuy_txt:SetText(price)
                    --积分
                    self.point_rect:RefreshPoint(self.packageInfo)
                end
            end
        else
            self._giftBar_rect:SetActive(false)
        end
    end
end

local function OnBuyPackageSucc(self)
    local isBought = self.golloesMonthCard:IsBought()
    if isBought then
        self.packageInfo = self.ctrl:GePackageInfo()
        if self.packageInfo then
            self._giftName_txt:SetLocalText(self.packageInfo:getName())
            self._giftContent_txt:SetText(self.packageInfo:getDescText())
            local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
            self._giftBuy_txt:SetText(price)
            --积分
            self.point_rect:RefreshPoint(self.packageInfo)
        else
            self._giftBar_rect:SetActive(false)
        end
    end
end

local function SetSendBtnState(self)
    local canSend = true
    local ownNum = DataCenter.GolloesCampManager:GetGolloesCount(self.curSelectedGolloes)
    local costNum = tonumber(self.golloesCostTb[self.curSelectedGolloes])
    if ownNum < costNum then
        canSend = false
    end
    
    CS.UIGray.SetGray(self.golloesSendBtnN.transform, not canSend, true)
    local sendTxtC = canSend and YellowBtnShadowLightColor or YellowBtnShadowGrayColor
end

local function StartOpenBoxAnim(self, t)
    self.boxEffAnimN:Play("V_ui_gulu_box_kaixiang", 0, 0)
    TimerManager:GetInstance():DelayInvoke(function()
        local tb = t or {}
        self:ShowClaimRewardEff(tb)
    end, 0.25)
end

local function ShowClaimRewardEff(self, t)
    local rewards = t["reward"]
    local golloesNum = t["golloes"]

    if rewards and #rewards > 0 then
        for i, v in ipairs(rewards) do
            local tempType = v.type
            local tempId = v.itemId
            local pic =RewardUtil.GetPic(tempType,tempId)
            UIUtil.DoFly(tonumber(tempType),5,pic,self.unopenedBoxBtnN.transform.position,Vector3.New(0,0,0), 40, 40)
        end
    end
    if golloesNum and golloesNum > 0 then
        local targetPos = self.golloesIconN.transform.position
        local golloesIcon = "Assets/Main/Sprites/UI/UIGolloesCamp/UI_dispatch_head.png"
        UIUtil.DoFly(-1,golloesNum,golloesIcon,self.unopenedBoxBtnN.transform.position,targetPos, 40, 40, function()
            self:ShowAddGolloesEff()
        end)
    end
    
    self.unopenedBoxBtnN:SetActive(false)
    self.openedBoxBtnN:SetActive(true)
    self.openBoxEffAnimN:Play("V_ui_gulu_boxopened", 0, 0)
    self.openBoxParticleN:SetActive(true)
    
    self.isOpeningBox = false
end

local function ShowAddGolloesEff(self)
    self:AddAddGolloesTimer()
end

--  [[
local function AddAddGolloesTimer(self)
    self.AddGolloesTimerAction = function()
        self:SetGolloesCount()
    end
    
    if self.addGolloesTimer == nil then
        self.addGolloesTimer = TimerManager:GetInstance():GetTimer(0.1, self.AddGolloesTimerAction , self, false,false,false)
    end
    self.addGolloesTimer:Start()
end

local function SetGolloesCount(self)
    local golloesNum = DataCenter.GolloesCampManager:GetGolloesCount(self.curSelectedGolloes)
    if golloesNum > self.cacheGolloesCount then
        self.cacheGolloesCount = self.cacheGolloesCount + 1
        
        local maxGolloesNum = LuaEntry.DataConfig:TryGetNum("golloes_dispatch_para", "k1")
        self.golloesCountTxtN:SetText(self.cacheGolloesCount .. "/" .. maxGolloesNum)
        self.golloesNumAnimN:Play("V_ui_levelbg", 0, 0)
    else
        local golloesNum = DataCenter.GolloesCampManager:GetGolloesCount(self.curSelectedGolloes)
        local maxGolloesNum = LuaEntry.DataConfig:TryGetNum("golloes_dispatch_para", "k1")
        self.golloesCountTxtN:SetText(golloesNum .. "/" .. maxGolloesNum)
        
        self.isOpeningBox = false
        self:RefreshUI()
    end
end

local function DelAddGolloesTimer(self)
    if self.addGolloesTimer ~= nil then
        self.addGolloesTimer:Stop()
        self.addGolloesTimer = nil
    end
end

--]]


local function AddTimer(self)
    self.TimerAction = function()
        self:SetRemainTime()
    end
    
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.TimerAction , self, false,false,false)
    end
    self.timer:Start()
end

local function SetRemainTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.golloesMonthCard.endTime - curTime
    if remainTime > 0 then
        self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self:DelTimer()
    end
end

local function DelTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end


local function AddRewardBoxTimer(self)
    self.BoxTimerAction = function()
        self:ShowRewardBoxEff()
    end
    
    if self.rewardBoxTimer == nil then
        self.rewardBoxTimer = TimerManager:GetInstance():GetTimer(3, self.BoxTimerAction , self, false,false,false)
    end
    self.rewardBoxTimer:Start()
end

local function ShowRewardBoxEff(self)
    self.boxEffAnimN:Play("V_ui_gulu_box",0,0)
end

local function DelRewardBoxTimer(self)
    if self.rewardBoxTimer ~= nil then
        self.rewardBoxTimer:Stop()
        self.rewardBoxTimer = nil
    end
end




local function OnClickBackBtn(self)
    self.ctrl:CloseSelf()
end

local function OnClickMonthCardBtn(self)
    self.ctrl:OpenMonthCardPanel()
end

local function OnClickSendBtn(self)
    --数量
    local ownNum = DataCenter.GolloesCampManager:GetGolloesCount(self.curSelectedGolloes)
    local costNum = tonumber(self.golloesCostTb[self.curSelectedGolloes])
    if ownNum < costNum then
        local isBought = self.golloesMonthCard:IsBought()
        if isBought then
            UIUtil.ShowTipsId(320255)
            return
        else
            UIUtil.ShowMessage(Localization:GetString("320338"), 1, 110003, "", function()
                self.ctrl:OpenMonthCardPanel()
            end, nil);
            return
        end
    end

    if LuaEntry.Player:GetMainWorldPos()<=0 then
        UIUtil.ShowTipsId(320536)
        return
    end
    
    
    self.view.ctrl:ActiveGolloesFunc(self.curSelectedGolloes)
end

local function BuyGift(self)
    if self.packageInfo then
        DataCenter.PayManager:CallPayment(self.packageInfo, UIWindowNames.UIGolloesCamp)
    end
end

local function CaravanRecordRefresh(self)
    local isShowRed = DataCenter.MonthCardNewManager:CheckIsShowRed()
    self._traderRed_rect:SetActive(isShowRed)
end

local function ColloesCaravanRed(self)
    self._traderRed_rect:SetActive(false)
end

local function OnClickCaravan(self)
    self._traderRed_rect:SetActive(false)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIGolloesTraderRecord)
end


UIGolloesCampView.OnCreate = OnCreate 
UIGolloesCampView.OnDestroy = OnDestroy
UIGolloesCampView.OnAddListener = OnAddListener
UIGolloesCampView.OnRemoveListener = OnRemoveListener
UIGolloesCampView.ComponentDefine = ComponentDefine
UIGolloesCampView.ComponentDestroy = ComponentDestroy
UIGolloesCampView.DataDefine = DataDefine
UIGolloesCampView.DataDestroy = DataDestroy

UIGolloesCampView.InitUI = InitUI
UIGolloesCampView.RefreshUI = RefreshUI
UIGolloesCampView.RefreshGridContent = RefreshGridContent
UIGolloesCampView.RefreshContainer = RefreshContainer
UIGolloesCampView.TrySelectGolloes = TrySelectGolloes
UIGolloesCampView.TryClaimDailyGolloes = TryClaimDailyGolloes
UIGolloesCampView.SetSendBtnState = SetSendBtnState
UIGolloesCampView.ClaimDailyGolloes = ClaimDailyGolloes
UIGolloesCampView.OnClickBackBtn = OnClickBackBtn
UIGolloesCampView.OnClickMonthCardBtn = OnClickMonthCardBtn
UIGolloesCampView.AddTimer = AddTimer
UIGolloesCampView.DelTimer = DelTimer
UIGolloesCampView.SetRemainTime = SetRemainTime
UIGolloesCampView.AddRewardBoxTimer = AddRewardBoxTimer
UIGolloesCampView.ShowRewardBoxEff = ShowRewardBoxEff
UIGolloesCampView.DelRewardBoxTimer = DelRewardBoxTimer
UIGolloesCampView.ShowClaimRewardEff = ShowClaimRewardEff
UIGolloesCampView.SetAllCellDestroy = SetAllCellDestroy
UIGolloesCampView.OnClickSendBtn = OnClickSendBtn
UIGolloesCampView.StartOpenBoxAnim = StartOpenBoxAnim
UIGolloesCampView.ShowAddGolloesEff = ShowAddGolloesEff
UIGolloesCampView.AddAddGolloesTimer = AddAddGolloesTimer
UIGolloesCampView.SetGolloesCount = SetGolloesCount
UIGolloesCampView.DelAddGolloesTimer = DelAddGolloesTimer
UIGolloesCampView.HideAutoClaim = HideAutoClaim
UIGolloesCampView.GetGolloesTypeName = GetGolloesTypeName

UIGolloesCampView.BuyGift = BuyGift
UIGolloesCampView.CaravanRecordRefresh = CaravanRecordRefresh
UIGolloesCampView.ColloesCaravanRed = ColloesCaravanRed
UIGolloesCampView.OnClickCaravan = OnClickCaravan
UIGolloesCampView.OnBuyPackageSucc = OnBuyPackageSucc

return UIGolloesCampView