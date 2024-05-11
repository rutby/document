---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1020.
--- DateTime: 2023/5/23 14:33
---

local Mining = BaseClass("Mining", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting

local scoreIcon = "Assets/Main/Sprites/UI/UIMine/activit_mining_jifen.png"
local FlyModel = "Assets/_Art/Effect/prefab/ui/kuangchandaheng/Fly_Mining.prefab"

local activityTitle_path = "RectView/Top/title"
local activitySubTitle_path = "RectView/Top/subTitle"
local remainTime_path = "RectView/Top/remainTime"
local infoBtn_path = "RectView/Top/title/infoBtn"

local skipBtn_path = "RectView/Top/skipBtn"
local skipTxt_path = "RectView/Top/skipBtn/skipTxt"
local skipMark_path = "RectView/Top/skipBtn/skipMark"
local exploreBtn_path = "RectView/Right/exploreBtn"
local exploreTxt_path = "RectView/Right/exploreBtn/exploreTxt"
local scoreTxtBg_path = "RectView/Right/exploreBtn/Txt_BtnScoreBg"
local scoreTxt_path = "RectView/Right/exploreBtn/Txt_BtnScoreBg/Txt_BtnScore"

local exploreRed_path = "RectView/Right/exploreBtn/exploreRed"
local remainNumTxt_path = "RectView/Right/remainNumTxt"
local scrollView_path = "RectView/Right/ScrollView"
local content2_path = "RectView/Right/ScrollView/Viewport/Content"

local resIconImg_path = "RectView/Bottom/ResShow/resIcon"
local resNumTxt_path = "RectView/Bottom/ResShow/resNum"
local addResBtn_path = "RectView/Bottom/ResShow/rectAddRes/addResBtn"
local buyRoot_path = "RectView/Bottom/MiningCarRoot/buyRoot"
local buyBtn_path = "RectView/Bottom/MiningCarRoot/buyRoot/buyBtn"
local buyCostTxt_path = "RectView/Bottom/MiningCarRoot/buyRoot/buyBtn/buyCostTxt"
local buyDesTxt_path = "RectView/Bottom/MiningCarRoot/buyRoot/buyDesTxt"
local giftScore_path = "RectView/Bottom/MiningCarRoot/buyRoot/Txt_GiftScore"
local resShow_path = "RectView/Bottom/ResShow"

local flyStartRoot_path = "RectView/FlyStartRoot"
local anim1_path = "RectView/AnimRoot/Anim1"
local anim2_path = "RectView/AnimRoot/Anim2"

local RewardItem = require "UI/UIActivityCenterTable/Component/Mining/MiningRewardItem"

local miningCarNum = 4
local MiningCarItem = require "UI/UIActivityCenterTable/Component/Mining/MiningCarItem"
local miningCarItem_path = "RectView/Bottom/MiningCarRoot/MiningCarItem"

local toggle_path = "RectView/Bottom/Tab/Toggle"

local rect_progressPos_path = "RectView/Right/Rect_ProgressPos"
local allScore_txt_path = "RectView/Right/Txt_AllScore"
local buyGift_btn_path = "RectView/Right/Btn_BuyGift"
local price_txt_path = "RectView/Right/Btn_BuyGift/Txt_Price"

local visibleH = 77 --每格可见高度
local space = 10--每格之间间距
local toggleNum = 3
local rewardListCount = 0

function Mining : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function Mining : OnEnable()
    base.OnEnable(self)
end

function Mining : OnDestroy()
    if self.delayTime then
        self.delayTime:Stop()
    end
    if self.delayMatTime then
        self.delayMatTime:Stop()
    end
    if self.delayAnimTime1 then
        self.delayAnimTime1:Stop()
    end
    if self.delayAnimTime2 then
        self.delayAnimTime2:Stop()
    end
    if self.delayAnimTime3 then
        self.delayAnimTime3:Stop()
    end
    self.delayTime = nil
    self.delayMatTime = nil
    self.delayAnimTime1 = nil
    self.delayAnimTime2 = nil
    self.delayAnimTime3 = nil
    self:ClearScroll()
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function Mining  : DataDefine()
    self.isPlayAnim = false
    self.canExplore = true
    self.showNewCar = false
    self.skipAnim = false
    self.curQueueId = -1
    self.toggleList = {}
    self.miningCarList = {}
    self.rewardItemInfoList = {}
    self.animList = {}
    self.recordItemList = {}
    self.showRewardList = {}
    self.flyStartRootList = {}
end

function Mining : DataDestroy()
    self.isPlayAnim = nil
    self.canExplore = nil
    self.showNewCar = nil
    self.skipAnim = nil
    self.curQueueId = nil
    self.toggleList = nil
    self.miningCarList = nil
    self.rewardItemInfoList = nil
    self.animList = nil
    self.recordItemList = nil
    self.showRewardList = nil
    self.flyStartRootList = nil
end

function Mining : ComponentDefine()
    self.activityTitle = self:AddComponent(UIText, activityTitle_path)
    self.activitySubTitle = self:AddComponent(UIText, activitySubTitle_path)
    self.remainTimeTxt = self:AddComponent(UIText, remainTime_path)
    self.infoBtn = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtn:SetOnClick(function()
        self:OnClickInfoBtn()
    end)

    self.skipBtn = self:AddComponent(UIButton, skipBtn_path)
    self.skipBtn:SetOnClick(function()
        self:OnClickSkipBtn()
    end)
    self.skipTxt = self:AddComponent(UIText, skipTxt_path)
    self.skipTxt:SetLocalText(372228)
    self.skipMark = self:AddComponent(UIBaseContainer, skipMark_path)
    self.exploreBtn = self:AddComponent(UIButton, exploreBtn_path)
    self.exploreBtn:SetOnClick(function()
        self:OnClickExploreBtn()
    end)
    self.exploreTxt = self:AddComponent(UIText, exploreTxt_path)
    self.exploreTxt:SetLocalText(375002)
    self._scoreTxtBg_rect = self:AddComponent(UIBaseContainer,scoreTxtBg_path)
    self._scoreBtn_txt = self:AddComponent(UIText, scoreTxt_path)
    self.exploreRed = self:AddComponent(UIBaseContainer, exploreRed_path)
    self.remainNumTxt = self:AddComponent(UIText, remainNumTxt_path)
    
    self.ScrollView = self:AddComponent(UIScrollView, scrollView_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)

    self.content2 = self:AddComponent(UIBaseContainer, content2_path)

    self.resIconImg = self:AddComponent(UIImage, resIconImg_path)
    self.resNumTxt = self:AddComponent(UIText, resNumTxt_path)
    self.addResBtn = self:AddComponent(UIButton, addResBtn_path)
    self.addResBtn:SetOnClick(function()
        self:OnClickAddResBtn()
    end)
    self.buyRoot = self:AddComponent(UIBaseContainer, buyRoot_path)
    self.buyBtn = self:AddComponent(UIButton, buyBtn_path)
    self.buyBtn:SetOnClick(function()
        self:OnClickBuyBtn()
    end)

    self.buyCostTxt = self:AddComponent(UIText, buyCostTxt_path)
    self.buyDesTxt = self:AddComponent(UIText, buyDesTxt_path)
    self.buyDesTxt:SetLocalText(375007)
    
    self._giftScore_txt = self:AddComponent(UIText,giftScore_path)
    
    self.resShowBtn = self:AddComponent(UIButton, resShow_path)
    self.resShowBtn:SetOnClick(function()
        self:OnClickResShowBtn()
    end)
    
    for i = 1, miningCarNum do
        local miningCarItem = self:AddComponent(MiningCarItem, miningCarItem_path..i)
        miningCarItem:SetCallBack(function() self:SetProPos() end)
        table.insert(self.miningCarList, miningCarItem)
    end

    for i = 1, toggleNum do
        local tempPath = toggle_path .. i
        local toggle = self:AddComponent(UIToggle, tempPath)
        toggle:SetOnValueChanged(function(tf)
            if tf == true then
                self:OnClickToggle(i)
            end
        end)

        local newTog = {}
        newTog.toggle = toggle
        newTog.redPoint = toggle:AddComponent(UIBaseContainer, "Img_RedList")
        newTog.lockImg = toggle:AddComponent(UIBaseContainer, "lockImg")
        newTog.choose = toggle:AddComponent(UIBaseContainer, "Background/Checkmark")
        newTog.unselectName = toggle:AddComponent(UIText, "Txt_ListToggle")
        newTog.unselectName:SetText(Localization:GetString("375003", i))
        newTog.lock = true
        table.insert(self.toggleList, newTog)
    end

    local flyStartRoot1 = self:AddComponent(UIBaseContainer, flyStartRoot_path..1)
    local flyStartRoot2 = self:AddComponent(UIBaseContainer, flyStartRoot_path..2)
    table.insert(self.flyStartRootList, flyStartRoot1)
    table.insert(self.flyStartRootList, flyStartRoot2)
    
    local anim1 = self:AddComponent(UIAnimator, anim1_path)
    local anim2 = self:AddComponent(UIAnimator, anim2_path)
    table.insert(self.animList, anim1)
    table.insert(self.animList, anim2)
    
    self._progressPos_rect = self:AddComponent(UIBaseContainer,rect_progressPos_path)
    self._allScore_txt= self:AddComponent(UIText,allScore_txt_path)
    self._buyGift_btn = self:AddComponent(UIButton,buyGift_btn_path)
    self._buyGift_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickBuyGift()
    end)

    self._price_txt = self:AddComponent(UIText,price_txt_path)
end

function Mining : ComponentDestroy()
end

function Mining : SetData(activityId)
    self.activityId = activityId
    
    self.animList[1]:SetActive(false)
    self.animList[2]:SetActive(false)
    if not self.activityId then
        return
    end
    self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    if not self.activityInfo then
        return
    end
    --标题
    self.activityTitle:SetLocalText(self.activityInfo.name)
    self.activitySubTitle:SetLocalText(self.activityInfo.desc_info)
    self.curQueueId = 1
    --跳过按钮
    self.skipAnim = Setting:GetBool(SettingKeys.MINING_SKIP_ANIM, false)
    self.skipMark:SetActive(self.skipAnim)

    self._scoreBtn_txt:SetText(GetTableData("activity_mining_para",1, "score"))
    
    --剩余时间
    DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.activityId)
    self.endTime = self.activityInfo.endTime
    self:AddCountDownTimer()
    SFSNetwork.SendMessage(MsgDefines.GetMiningActParamInfo, self.activityId)
end

function Mining : RefreshRes()
    if self.actTemplateInfo then
        local icon = DataCenter.ItemTemplateManager:GetItemTemplate(self.actTemplateInfo.speedUpItemId).icon
        local path = string.format(LoadPath.ItemPath, icon)
        self.resIconImg:LoadSprite(path)
        local tempCount = DataCenter.ItemData:GetItemCount(self.actTemplateInfo.speedUpItemId)
        self.resNumTxt:SetText(string.GetFormattedSeperatorNum(tempCount))
    end
end

function Mining : RefreshAll(toggleIndex,isFly)
    if IsNull(self.gameObject) then
        return
    end

    self.actTemplateInfo = DataCenter.MiningManager:GetActTemplateInfoByActId(self.activityId)
    self.actParamInfo = DataCenter.MiningManager:GetActParamInfoByActId(self.activityId)

    local unLockQueueIndexList = {}
    if self.actTemplateInfo then
        self:RefreshRes()

        for k,v in ipairs(self.actTemplateInfo.queueInfoList) do
            if v.isFree then
                table.insert(unLockQueueIndexList, v.queueId)
            end
        end
    end
    if self.actParamInfo then
        local remainLotteryCount = DataCenter.MiningManager:GetRemainExploreCountByActId(self.activityId)
        self.remainNumTxt:SetText(Localization:GetString(375009, remainLotteryCount))

        for k,v in pairs(self.actParamInfo.unlockQueues) do
            table.insert(unLockQueueIndexList, tonumber(v))
        end
        for i = 1, #self.actParamInfo.queueInfoList do
            local hasCanTakeReward = self.actParamInfo.queueInfoList[i]:HasCanTakeReward()
            self.toggleList[i].redPoint:SetActive(hasCanTakeReward)
        end
        self.rewardList = {}
        if self.actParamInfo.stageArr and next(self.actParamInfo.stageArr) then
            for i = #self.actParamInfo.stageArr ,1,-1 do
                table.insert(self.rewardList,self.actParamInfo.stageArr[i])
            end
            rewardListCount = table.count(self.rewardList)
            if not isFly then
                self:RewardHandle()
            end
        end
        
        self._buyGift_btn:SetActive(self.actParamInfo.unlock == 0)
        
        self._allScore_txt:SetText(Localization:GetString("100105")..string.GetFormattedSeperatorNum(self.actParamInfo.score))
    end
    
    --付费解锁高级奖励
    self.giftId = self.activityInfo.para4
    DataCenter.MiningManager:SetGiftId(self.giftId)
    self.packageInfo = GiftPackageData.get(self.giftId)
    if self.packageInfo then
        local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
        self._price_txt:SetText(price)
    end

    for k,v in pairs(unLockQueueIndexList) do
        self.toggleList[v].lockImg:SetActive(false)
        self.toggleList[v].lock = false
    end

    if toggleIndex then
        self:ChangeToggle(tonumber(toggleIndex))
    else
        self:ChangeToggle(self.curQueueId)
    end

    local hasSpace = DataCenter.MiningManager:CheckHasSpaceCar(self.activityId)
    self.exploreRed:SetActive(hasSpace)
end

function Mining:RewardHandle()
    local curStage,before,after = DataCenter.MiningManager:GetCurStage(self.activityId)
    local offset = 0
    
    --计算当前积分在第几阶段
    if after - self.actParamInfo.score > 0 then
        offset = (self.actParamInfo.score - before) / (after - before)
    end
    local proOffset = visibleH*offset
    if offset ~= 0 then
        proOffset = proOffset + space
    end
    self.proTab = {curStage,proOffset}
    if self.showRewardList and next(self.showRewardList) then
        for i, v in pairs(self.showRewardList) do
            if self.rewardList[i] then
                self.showRewardList[i]:RefreshData(self.rewardList[i],self.actParamInfo.unlock,self.actParamInfo.score,self.proTab)
            end
        end
    else
        self.ScrollView:SetTotalCount(rewardListCount)
        local targetIndex = rewardListCount - curStage - 2
        if targetIndex > rewardListCount - 3 then
            targetIndex = rewardListCount - 3
        end
        self.ScrollView:RefillCells(targetIndex)
    end
end

function Mining:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(RewardItem, itemObj)
    local data =  self.rewardList[index]
    cellItem:SetData(data,self.actParamInfo.unlock,self.activityId,self.actParamInfo.score,self.proTab)
    self.showRewardList[index] = cellItem
end

function Mining:OnDeleteCell(itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, RewardItem)
    self.showRewardList[index] = nil
end

function Mining:ClearScroll()
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(RewardItem)
end

function Mining:SetProPos()
    if self.proTab[1] then
        self.ScrollView:RefillCells(rewardListCount - self.proTab[1] - 2)
    end
end

--领取小车奖励飞动画
function Mining:OnFlyScore(starPos)
    self.canExplore = true
    local rewardList = self.showRewardList
    UIUtil.DoFly(RewardType.SEVENDAY_SCORE,1,scoreIcon,starPos,self._progressPos_rect.transform.position,43,45,function()
        for i, v in pairs(rewardList) do
            if v.activeCached then
                v:ChangeMat()
            end
        end
        local curStage,before,after = DataCenter.MiningManager:GetCurStage(self.activityId)
        local offset = 0
        
        --计算当前积分在第几阶段
        if after - self.actParamInfo.score > 0 then
            offset = (self.actParamInfo.score - before) / (after - before)
        end
        local proOffset = visibleH*offset
        if offset ~= 0 then
            proOffset = proOffset + space
        end
         self.proTab = {curStage,proOffset}
        --进度条开始上涨
        local list = {}
        for i, v in pairs(rewardList) do
            if self.rewardList[i] then
                --这里可能会夸阶段，所以要记录下要上涨的数
                local value = rewardList[i]:CheckDoTween(self.rewardList[i],self.actParamInfo.score,self.proTab)
                if value and value ~= 0 then
                    local param = {}
                    param.value = value
                    param.index = i
                    table.insert(list,param)
                end
            end
        end
        table.sort(list, function(a,b)
            if a.index > b.index then
                return true
            end
            return false
        end)
        self:DoProTween(list)
    end,nil,1)
end

function Mining:DoProTween(list)
    if table.count(list) > 0 then
        for i, v in ipairs(list) do
            if self.showRewardList[v.index] then
                self.showRewardList[v.index]:DoProTween(v.value,self.rewardList[v.index],self.actParamInfo.unlock,self.actParamInfo.score,self.proTab, list,function(param) self:DoProTween(param) end)
                break
            end
        end
    else
       -- self.canExplore = true
    end
end

function Mining : ChangeToggle(index)
    if index == self.curQueueId then
        self:RefreshMiningCarRoot()
    else
        for i =1,#self.toggleList do
            self.toggleList[i].toggle:SetIsOn(i == index)
        end
    end
end

function Mining : OnClickInfoBtn()
    UIUtil.ShowIntro(Localization:GetString(self.activityInfo.name), Localization:GetString("100239"),Localization:GetString(self.activityInfo.story))
end

function Mining : OnClickExploreBtn()
    if not self.canExplore then
        return
    end
    
    --判断抽取次数是否足够
    local remainLotteryCount = DataCenter.MiningManager:GetRemainExploreCountByActId(self.activityId)
    if remainLotteryCount < 1 then
        UIUtil.ShowTipsId(372304)
        return
    end
    
    --判断矿车车位是否足够
    local enough = DataCenter.MiningManager:CheckHasSpaceCar(self.activityId)
    if not enough then
        UIUtil.ShowTipsId(375004)
        return
    end

    self.canExplore = false
    self:SetProPos()
    SFSNetwork.SendMessage(MsgDefines.GetMiningLotteryResInfo, self.activityId)
end

function Mining : OnClickSkipBtn()
    self.skipAnim = not self.skipAnim
    self.skipMark:SetActive(self.skipAnim)
    Setting:SetBool(SettingKeys.MINING_SKIP_ANIM, self.skipAnim)
end

function Mining : OnClickAddResBtn()
    local lackTab = {}
    local param = {}
    param.type = ResLackType.Item
    param.id = self.actTemplateInfo.speedUpItemId
    param.targetNum = 1
    table.insert(lackTab, param)
    GoToResLack.GoToItemResLackList(lackTab)
end

function Mining : OnClickBuyBtn()
    local giftId = self.actTemplateInfo.queueInfoList[self.curQueueId].giftNum
    local packageInfo = GiftPackageData.get(tostring(giftId))
    if packageInfo ~= nil then
        self:SetProPos()
        DataCenter.PayManager:BuyGift(packageInfo)
    end
end

function Mining : OnClickToggle(index)
    local isOn = self.toggleList[index].toggle:GetIsOn()
    if isOn and self.curQueueId ~= index then
        self.curQueueId = index
        self:RefreshMiningCarRoot()
    end
end

function Mining : RefreshMiningCarRoot()
    local lock = self.toggleList[self.curQueueId].lock
    self.buyRoot:SetActive(lock)
    if self.actTemplateInfo and lock then
        local giftId = self.actTemplateInfo.queueInfoList[self.curQueueId].giftNum
        local packageInfo = GiftPackageData.get(tostring(giftId))
        if packageInfo then
            self.buyCostTxt:SetText(DataCenter.PayManager:GetDollarText(packageInfo:getPrice(), packageInfo:getProductID()))
        end
        if self.actTemplateInfo.queueInfoList[self.curQueueId].giftScore then
            self._giftScore_txt:SetText(self.actTemplateInfo.queueInfoList[self.curQueueId].giftScore)
        end
    end
    
    if self.actParamInfo then
        local carStateInfoList = self.actParamInfo.queueInfoList[self.curQueueId]:GetAllMiningCarStateInfo()
        for i = 1, miningCarNum do
            local carIndex = i - 1
            local speedUpItemId = self.actTemplateInfo.speedUpItemId
            local showNew = self.showNewCar and carStateInfoList ~= nil and i == #carStateInfoList
            if showNew then
                self.showNewCar = false
                self.miningCarList[i]:SetData(nil, self.activityId, carIndex, speedUpItemId, false)
            else
                self.miningCarList[i]:SetData(carStateInfoList[i], self.activityId, carIndex, speedUpItemId, false)
            end
        end
    end
end

function Mining : AddCountDownTimer()
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false, false, false)
    end
    self.countDownTimer:Start()
    self:RefreshRemainTime()
end

function Mining : RefreshRemainTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if remainTime >= 0 then
        self.remainTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.remainTimeTxt:SetText("")
    end
end

function Mining : DelCountDownTimer()
    self.CountDownTimerAction = nil
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

function Mining : OnDisable()
    base.OnDisable(self)
end

local hitTime1 = 1
local hitTime2 = 2 -- 1.415
--挖矿返回
function Mining : OnMiningLotteryResInfoUpdate()
    --播放敲击动画
    if not self.skipAnim and not self.isPlayAnim then
        local index = math.random(1,2)
        self.animList[index]:SetActive(true)
        local ret1,time1 = self.animList[index]:PlayAnimationReturnTime("V_ui_kcdh_futou")
        self.isPlayAnim = true
        self.delayAnimTime1 = TimerManager:GetInstance():DelayInvoke(function()
            self.isPlayAnim = false
            self.animList[index]:SetActive(false)
        end, time1)

        local Sound
        if index == 1 then
            Sound = SoundAssets.Music_Effect_Mining01
        else
            Sound = SoundAssets.Music_Effect_Mining02
        end
        self.delayAnimTime2 = TimerManager:GetInstance():DelayInvoke(function()
            SoundUtil.PlayEffect(Sound)
        end, hitTime1)
        self.delayAnimTime3 = TimerManager:GetInstance():DelayInvoke(function()
            SoundUtil.PlayEffect(Sound)
            self:ShowRewardAndTuoWei(index)
        end, hitTime2)
    else
        self:ShowRewardAndTuoWei()
    end
    self.actParamInfo = DataCenter.MiningManager:GetActParamInfoByActId(self.activityId)
    --更新剩余次数
    if self.actParamInfo then
        local remainLotteryCount = DataCenter.MiningManager:GetRemainExploreCountByActId(self.activityId)
        self.remainNumTxt:SetText(Localization:GetString(375009, remainLotteryCount))
        local hasSpace = DataCenter.MiningManager:CheckHasSpaceCar(self.activityId)
        self.exploreRed:SetActive(hasSpace)
        self._allScore_txt:SetText(Localization:GetString("100105")..string.GetFormattedSeperatorNum(self.actParamInfo.score))
    end
end

function Mining : ShowRewardAndTuoWei(flyStartRootIndex)
    --奖励展示和拖尾动画
    local info = DataCenter.MiningManager:GetMiningLotteryResInfo(self.activityId)
    local itemId = info.itemId
    local lineData = LocalController:instance():getLine("activity_mining_para", itemId)
    local type = tonumber(lineData:getValue("type"))    -- 0 = 免费奖励，1 = 矿车奖励
    if type == 1 then
        local queueInfo = info.queueInfo
        self:GetCarReward(queueInfo, flyStartRootIndex)
    else
        --飞到进度条
        self:OnFlyScore(self._scoreTxtBg_rect.transform.position)
    end
end

function Mining : GetCarReward(queueInfo, flyStartRootIndex)
    local function FlyCallback()
        local carStateInfoList = self.actParamInfo.queueInfoList[self.curQueueId]:GetAllMiningCarStateInfo()
        local carIndex = self.newCarIndex - 1
        local speedUpItemId = self.actTemplateInfo.speedUpItemId
        self.miningCarList[self.newCarIndex]:SetData(carStateInfoList[self.newCarIndex], self.activityId, carIndex, speedUpItemId, true)
        self.canExplore = true
    end
    
    if self.actParamInfo then
        local carStateInfoList = self.actParamInfo.queueInfoList[queueInfo.queueId]:GetAllMiningCarStateInfo()
        if carStateInfoList and #carStateInfoList > 0 then
            self.newCarIndex = #carStateInfoList
            if self.skipAnim then
                local carIndex = self.newCarIndex - 1
                local speedUpItemId = self.actTemplateInfo.speedUpItemId
                self.miningCarList[self.newCarIndex]:SetData(carStateInfoList[self.newCarIndex], self.activityId, carIndex, speedUpItemId, false)
                self.canExplore = true
            else
                self.showNewCar = true
                if not flyStartRootIndex then
                    flyStartRootIndex = 1
                end
                self:DoFly(self.flyStartRootList[flyStartRootIndex].transform.position, self.miningCarList[self.newCarIndex].transform.position, FlyCallback)
            end
        end
    end
    
    self:RefreshAll(queueInfo.queueId)
end

function Mining : DoFly(srcPos, destPos, callback)
    UIUtil.DoFlyCustom(nil, nil, 1, srcPos, destPos, nil, nil, callback, FlyModel)
end

function Mining : OnClickResShowBtn()
    local param = {}
    param["itemId"] = self.actTemplateInfo.speedUpItemId
    param["rewardType"] = RewardType.GOODS
    param["alignObject"] = self.addResBtn
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
end

function Mining : OnMiningActParamInfoUpdate()
	local index = 0
	if self.curQueueId > 0 then
		index = self.curQueueId
	else
		index = 1
	end
    self:RefreshAll(index)
end

--领取矿车奖励
function Mining : OnTakeMiningCarReward()
    if self.miningCarList and self.miningCarList[1] then
        self:OnFlyScore(self.miningCarList[1]:GetPos())
    end
    local isFly = true
    self:RefreshAll(nil,isFly)
end

function Mining : OnMiningQueueSpeedUp()
    self:RefreshAll()
end

--新队列解锁
function Mining : OnMiningQueueUnlock()
    self:OnFlyScore(self._giftScore_txt.transform.position)
    local isFly = true
    self:RefreshAll(nil,isFly)
end

function Mining : OnMiningCarCompleted()
    self:RefreshAll()
end

function Mining:OnClickBuyGift()
    if self.packageInfo then
        DataCenter.PayManager:CallPayment(self.packageInfo)
    end
end

function Mining : OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.MiningActParamInfoUpdate, self.OnMiningActParamInfoUpdate)
    self:AddUIListener(EventId.MiningLotteryResInfoUpdate, self.OnMiningLotteryResInfoUpdate)
    self:AddUIListener(EventId.TakeMiningCarReward, self.OnTakeMiningCarReward)
    self:AddUIListener(EventId.MiningQueueSpeedUp, self.OnMiningQueueSpeedUp)
    self:AddUIListener(EventId.MiningQueueUnlock, self.OnMiningQueueUnlock)
    self:AddUIListener(EventId.MiningCarCompleted, self.OnMiningCarCompleted)
    self:AddUIListener(EventId.RefreshItems, self.RefreshRes)
end

function Mining : OnRemoveListener()
    self:RemoveUIListener(EventId.MiningActParamInfoUpdate, self.OnMiningActParamInfoUpdate)
    self:RemoveUIListener(EventId.MiningLotteryResInfoUpdate, self.OnMiningLotteryResInfoUpdate)
    self:RemoveUIListener(EventId.TakeMiningCarReward, self.OnTakeMiningCarReward)
    self:RemoveUIListener(EventId.MiningQueueSpeedUp, self.OnMiningQueueSpeedUp)
    self:RemoveUIListener(EventId.MiningQueueUnlock, self.OnMiningQueueUnlock)
    self:RemoveUIListener(EventId.MiningCarCompleted, self.OnMiningCarCompleted)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshRes)
    
    base.OnRemoveListener(self)
end

return Mining