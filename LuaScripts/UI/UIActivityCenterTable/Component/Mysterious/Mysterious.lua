
local Mysterious = BaseClass("Mysterious", UIBaseView)
local base = UIBaseView
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local Localization = CS.GameEntry.Localization
local Setting = CS.GameEntry.Setting
local UIGray = CS.UIGray

local activityTitle_path = "RectView/Top/title"
local activitySubTitle_path = "RectView/Top/subTitle"
local remainTime_path = "RectView/Top/remainTime"
local infoBtn_path = "RectView/Top/title/infoBtn"

local skipBtn_path = "RectView/Right/skipBtn"
local skipTxt_path = "RectView/Right/skipBtn/skipTxt"
local skipMark_path = "RectView/Right/skipBtn/skipMark"

local scoreRoot_path = "RectView/ScoreRoot"
local scoreTxt1_path = "RectView/ScoreRoot/icon1/scoreTxt1"
local scoreTxt2_path = "RectView/ScoreRoot/icon2/scoreTxt2"
local scoreTxt3_path = "RectView/ScoreRoot/icon3/scoreTxt3"
local getStageRewardBtn_path = "RectView/ScoreRoot/getStageRewardBtn"
local fake_path = "RectView/ScoreRoot/fake"
local red_path = "RectView/ScoreRoot/red"

local curScoreTxt_path = "RectView/ScoreShowRoot/curScoreTxt"
local showScoreTxt1_path = "RectView/ScoreShowRoot/showScoreIcon1/showScoreTxt1"
local showScoreTxt2_path = "RectView/ScoreShowRoot/showScoreIcon2/showScoreTxt2"
local showScoreTxt3_path = "RectView/ScoreShowRoot/showScoreIcon3/showScoreTxt3"
local showScoreTxt4_path = "RectView/ScoreShowRoot/showScoreIcon4/showScoreTxt4"
local slider_path = "RectView/ScoreShowRoot/SliderProcessBar"
local scoreProcessTxt_path = "RectView/ScoreShowRoot/SliderProcessBar/scoreProcessTxt"

local oneDrawBtn_path = "RectView/Right/oneDrawBtn"
local oneDrawTxt_path = "RectView/Right/oneDrawBtn/Root/oneDrawTxt"
local oneDrawNumTxt_path = "RectView/Right/oneDrawBtn/Root/oneDrawNumTxt"
local oneDrawPropIconImg_path = "RectView/Right/oneDrawBtn/Root/oneDrawNumTxt/oneDrawPropIcon"
local oneDrawFreeRed_path = "RectView/Right/oneDrawBtn/Root/Img_FreeRed"
local tenDrawBtn_path = "RectView/Right/tenDrawBtn"
local tenDrawTxt_path = "RectView/Right/tenDrawBtn/Root/tenDrawTxt"
local tenDrawNumTxt_path = "RectView/Right/tenDrawBtn/Root/tenDrawNumTxt"
local tenDrawPropIconImg_path = "RectView/Right/tenDrawBtn/Root/tenDrawNumTxt/tenDrawPoropIcon"
local tenDrawFree_path = "RectView/Right/tenDrawBtn/Root/tenDrawFree"
local tenDrawDiscountTxt_path = "RectView/Right/tenDrawBtn/Root/tenDrawFree/tenDrawDiscountTxt"

local remainNumTxt_path = "RectView/Right/remainNumTxt"
local rewardPreviewBtn_path = "RectView/Right/rewardPreviewBtn"
local rewardPreviewTxt_path = "RectView/Right/rewardPreviewBtn/rewardPreviewTxt"
local rewardPreviewItem_path = "RectView/Right/rewardPreviewBtn/UICommonItem"
local resIconImg_path = "RectView/Right/NeedResRoot/resIcon"
local resNumTxt_path = "RectView/Right/NeedResRoot/resNum"
local rankBtn_path = "RectView/Right/rankBtn"
local rankTxt_path = "RectView/Right/rankBtn/rankTxt"
local rankNumTxt_path = "RectView/Right/rankBtn/rankNum"

local block_path = "Block"
local box_glow_path = "RectView/ScoreRoot/VFX_ui_mysterious_xiangzi_light"
local glow1_path = "RectView/ScoreRoot/VFX_ui_mysterious_shuaxin"
local glow2_path = "RectView/ScoreRoot/getStageRewardBtn/VFX_ui_mysterious_shuaxin_xz_glow"
local glow3_path = "RectView/ScoreRoot/VFX_ui_mysterious_shuaxin_glow"
local slider_glow_path = "RectView/ScoreShowRoot/SliderProcessBar/VFX_ui_mysterious_tiao"
local slider_full_glow_path = "RectView/ScoreShowRoot/SliderProcessBar/VFX_ui_mysterious_tiao_wancheng"

local RoundAnimDelay = 0.3

local FlyScoreOffset = 72
local FlyDelay = 0.2
local SegmentCount = 20
local paths = CS.System.Array.CreateInstance(typeof(CS.UnityEngine.Vector3), SegmentCount)

function Mysterious : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function Mysterious : OnDestroy()
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function Mysterious  : DataDefine()
    self.remainNumCache = IntMaxValue
    self.skipAnim = false
    self.isShowingRoundAnim = false
    self.reqs = {}
    self.rewardCache = {}
end

function Mysterious : DataDestroy()
    self.remainNumCache = nil
    self.skipAnim = nil
    self.isShowingRoundAnim = nil
    for _, req in pairs(self.reqs) do
        req:Destroy()
    end
    self.reqs = {}
    self.rewardCache = {}
end

function Mysterious : ComponentDefine()
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
    
    self.scoreRootAnim = self:AddComponent(UIAnimator, scoreRoot_path)
    self.scoreTxt1 = self:AddComponent(UIText, scoreTxt1_path)
    self.scoreTxt2 = self:AddComponent(UIText, scoreTxt2_path)
    self.scoreTxt3 = self:AddComponent(UIText, scoreTxt3_path)
    self.scoreAnim1 = self:AddComponent(UIAnimator, scoreTxt1_path)
    self.scoreAnim2 = self:AddComponent(UIAnimator, scoreTxt2_path)
    self.scoreAnim3 = self:AddComponent(UIAnimator, scoreTxt3_path)
    self.getStageRewardBtn = self:AddComponent(UIButton, getStageRewardBtn_path)
    self.getStageRewardBtn:SetOnClick(function()
        self:OnClickGetStageRewardBtn()
    end)
    self.fakeImg = self:AddComponent(UIImage, fake_path)
    self.fakeAnim = self:AddComponent(UIAnimator, fake_path)
    self.red_go = self:AddComponent(UIBaseContainer, red_path)
    
    self.curScoreTxt = self:AddComponent(UIText, curScoreTxt_path)
    self.curScoreTxt:SetLocalText(100105)
    self.showScoreTxt1 = self:AddComponent(UIText, showScoreTxt1_path)
    self.showScoreTxt2 = self:AddComponent(UIText, showScoreTxt2_path)
    self.showScoreTxt3 = self:AddComponent(UIText, showScoreTxt3_path)
    self.showScoreTxt4 = self:AddComponent(UIText, showScoreTxt4_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.scoreProcessTxt = self:AddComponent(UIText, scoreProcessTxt_path)

    self.oneDrawBtn = self:AddComponent(UIButton, oneDrawBtn_path)
    self.oneDrawBtn:SetOnClick(function()
        self:OnClickDrawBtn(0)
    end)
    self.oneDrawTxt = self:AddComponent(UIText, oneDrawTxt_path)
    self.oneDrawTxt:SetLocalText(375025)
    self.oneDrawNumTxt = self:AddComponent(UIText, oneDrawNumTxt_path)
   
    self.oneDrawFreeRed = self:AddComponent(UIBaseContainer, oneDrawFreeRed_path)

    self.tenDrawBtn = self:AddComponent(UIButton, tenDrawBtn_path)
    self.tenDrawBtn:SetOnClick(function()
        self:OnClickDrawBtn(1)
    end)
    self.tenDrawTxt = self:AddComponent(UIText, tenDrawTxt_path)
    self.tenDrawTxt:SetLocalText(375026)
    self.tenDrawNumTxt = self:AddComponent(UIText, tenDrawNumTxt_path)
    
    self.tenDrawPropIconImg = self:AddComponent(UIImage, tenDrawPropIconImg_path)
    self.tenDrawFree = self:AddComponent(UIBaseContainer, tenDrawFree_path)
    self.tenDrawDiscountTxt = self:AddComponent(UIText, tenDrawDiscountTxt_path)
    
    self.remainNumTxt = self:AddComponent(UIText, remainNumTxt_path)
    self.rewardPreviewBtn = self:AddComponent(UIButton, rewardPreviewBtn_path)
    self.rewardPreviewBtn:SetOnClick(function()
        self:OnClickRewardPreviewBtn()
    end)
    self.rewardPreviewTxt = self:AddComponent(UIText, rewardPreviewTxt_path)
    self.rewardPreviewTxt:SetLocalText(375055)
    self.rewardPreviewItem = self:AddComponent(UICommonItem, rewardPreviewItem_path)
    self.rewardPreviewItem:SetActive(false)
    self.resIconImg = self:AddComponent(UIImage, resIconImg_path)
    self.resNumTxt = self:AddComponent(UIText, resNumTxt_path)
    self.rankBtn = self:AddComponent(UIButton, rankBtn_path)
    self.rankBtn:SetOnClick(function()
        self:OnClickRankBtn()
    end)
    self.rankTxt = self:AddComponent(UIText, rankTxt_path)
    self.rankTxt:SetLocalText(390040)
    self.rankNumTxt = self:AddComponent(UIText, rankNumTxt_path)
    
    self.blockGo = self:AddComponent(UIBaseContainer, block_path)
    self.boxGlowGo = self:AddComponent(UIBaseContainer, box_glow_path)
    self.glow1Go = self:AddComponent(UIBaseContainer, glow1_path)
    self.glow2Go = self:AddComponent(UIBaseContainer, glow2_path)
    self.glow3Go = self:AddComponent(UIBaseContainer, glow3_path)
    self.sliderGlowGo = self:AddComponent(UIBaseContainer, slider_glow_path)
    self.sliderFullGlowGo = self:AddComponent(UIBaseContainer, slider_full_glow_path)
end

function Mysterious : ComponentDestroy()
    
end

function Mysterious : SetData(id)
    self.activityId = id

    if not self.activityId then
        return
    end
    self.activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(self.activityId))
    if not self.activityInfo then
        return
    end
    
    local isNew = DataCenter.MysteriousManager:IsNew(id)
    if isNew then
        Setting:SetPrivateBool(SettingKeys.MYSTERIOUS_VISIT .. self.activityInfo.startTime, true)
        EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)
    end
    
    -- 标题和活动描述
    self.activityTitle:SetLocalText(self.activityInfo.name)
    self.activitySubTitle:SetLocalText(self.activityInfo.desc_info)

    --跳过按钮
    self.skipAnim = Setting:GetPrivateBool(SettingKeys.MYSTERIOUS_SKIP_ANIM, false)
    self.skipMark:SetActive(self.skipAnim)
    
    --剩余时间
    DataCenter.ActivityListDataManager:SetActivityVisitedEndTime(self.activityId)
    self.endTime = self.activityInfo.endTime
    self:AddCountDownTimer()
    
    SFSNetwork.SendMessage(MsgDefines.GetMysteriousActParamInfo, self.activityId)
    SFSNetwork.SendMessage(MsgDefines.GetMysteriousRankInfo, self.activityId)
    self:ShowRoundAnim(false)
    self:ShowBoxGlow(false)
    self:ShowSliderGlow(false)
    self:ShowSliderFullGlow(false)
end

function Mysterious : Refresh(param)
    local actParamInfo = DataCenter.MysteriousManager:GetActParamInfoByActId(self.activityId)
    
    self.scoreTxt1:SetText(param.nums[1])
    self.scoreTxt2:SetText(param.nums[2])
    self.scoreTxt3:SetText(param.nums[3])
    self.showScoreTxt1:SetText(param.nums[1])
    self.showScoreTxt2:SetText(param.nums[2])
    self.showScoreTxt3:SetText(param.nums[3])
    self.showScoreTxt4:SetText(param.score)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.showScoreTxt4.transform.parent)

    local rewardPreviewInfo = DataCenter.MysteriousManager:GetRewardPreviewInfo(self.activityId)
    if not table.IsNullOrEmpty(rewardPreviewInfo.finalRewardInfoList[param.round]) then
        self.rewardPreviewItem:ReInit(rewardPreviewInfo.finalRewardInfoList[param.round][1].rewardItemInfo)
        self.rewardPreviewItem:SetActive(true)
    end
    
    local stageInfo = DataCenter.MysteriousManager:GetStageInfo(self.activityId, param.round, param.stage)
    local pic = string.format(LoadPath.UIMysterious, stageInfo.pic .. "_big")
    self.getStageRewardBtn:LoadSprite(pic)
    self.lastPic = pic
    
    local actTemplate = DataCenter.MysteriousManager:GetActTemplate(self.activityId)
    self.resIconImg:LoadSprite(actTemplate.costItemIconPath)
    if tonumber(actTemplate.costItemType) == 1 then --资源
        local count = LuaEntry.Player.gold
        self.resNumTxt:SetText(string.GetFormattedSeperatorNum(count))
    elseif tonumber(actTemplate.costItemType) == 2 then --道具
        local count = DataCenter.ItemData:GetItemCount(tonumber(actTemplate.costItemId))
        self.resNumTxt:SetText(string.GetFormattedSeperatorNum(count))
    end
    
    local maxScore = DataCenter.MysteriousManager:GetRoundMaxScore(self.activityId, actParamInfo.round)
    local curScore = actParamInfo.numbers[1] * actParamInfo.numbers[2] * actParamInfo.numbers[3]
    local canDraw = curScore <= maxScore
    
    self.oneDrawNumTxt:SetText(actTemplate.oneDrawCostNum)
    self.oneDrawPropIconImg:LoadSprite(actTemplate.costItemIconPath)
    UIGray.SetGray(self.oneDrawBtn.transform, not canDraw, canDraw)
   
    self.tenDrawNumTxt:SetText(actTemplate.tenDrawCostNum)
    self.tenDrawPropIconImg:LoadSprite(actTemplate.costItemIconPath)
    UIGray.SetGray(self.tenDrawBtn.transform, not canDraw, canDraw)
    
    local needScore = DataCenter.MysteriousManager:CheckRoundStageNeedScore(self.activityId, param.round, param.stage)
    local isFull = param.score >= needScore
    self.scoreProcessTxt:SetText(param.score .."/"..needScore)
    self.slider:SetValue(param.score / needScore)
    self:ShowBoxGlow(isFull)
    self:ShowSliderFullGlow(isFull)
    self.red_go:SetActive(isFull)
    
    if param.remainNum < self.remainNumCache then
        self.remainNumTxt:SetText(Localization:GetString("302213", param.remainNum))
        self.remainNumCache = param.remainNum
    end
end

function Mysterious : OnClickInfoBtn()
    UIUtil.ShowIntro(Localization:GetString(self.activityInfo.name), Localization:GetString("100239"),Localization:GetString(self.activityInfo.story))
end

function Mysterious : OnClickDrawBtn(drawType)
    local actTemplate = DataCenter.MysteriousManager:GetActTemplate(self.activityId)
    local actParamInfo = DataCenter.MysteriousManager:GetActParamInfoByActId(self.activityId)
    local remainNum = actParamInfo:GetRemainLotteryCount()
    --判断抽取次数是否足够
    if drawType == 0 and remainNum < 1 then
        UIUtil.ShowTipsId(372304)
        return
    elseif drawType == 1 and remainNum < 10 then
        UIUtil.ShowTipsId(372304)
        return
    end
    --判断抽取花费道具是否足够
    if tonumber(actTemplate.costItemType) == 1 then   --资源
        local count = LuaEntry.Player.gold
        if drawType == 0 and count < actTemplate.oneDrawCostNum then
            GoToUtil.GotoPayTips()
            return
        elseif drawType == 1 and count < actTemplate.tenDrawCostNum then
            GoToUtil.GotoPayTips()
            return
        end
    elseif tonumber(actTemplate.costItemType) == 2 then --道具
        local itemId = tonumber(actTemplate.costItemId)
        local count = DataCenter.ItemData:GetItemCount(itemId)
        if drawType == 0 and count < actTemplate.oneDrawCostNum then
            UIUtil.ShowTipsId(120021)
            local lackTab = {}
            local param = {}
            param.type = ResLackType.Item
            param.id = itemId
            param.targetNum = actTemplate.oneDrawCostNum
            table.insert(lackTab, param)
            GoToResLack.GoToItemResLackList(lackTab)
            return
        elseif drawType == 1 and count < actTemplate.tenDrawCostNum then
            UIUtil.ShowTipsId(120021)
            local lackTab = {}
            local param = {}
            param.type = ResLackType.Item
            param.id = self.costItemId
            param.targetNum = actTemplate.tenDrawCostNum
            table.insert(lackTab, param)
            GoToResLack.GoToItemResLackList(lackTab)
            return
        end
    end
    
    SFSNetwork.SendMessage(MsgDefines.GetMysteriousLotteryRes, self.activityId, drawType)
end

function Mysterious : OnClickSkipBtn()
    self.skipAnim = not self.skipAnim
    self.skipMark:SetActive(self.skipAnim)
    Setting:SetPrivateBool(SettingKeys.MYSTERIOUS_SKIP_ANIM, self.skipAnim)
end

function Mysterious : AddCountDownTimer()
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
    self:RefreshRemainTime()
end

function Mysterious : RefreshRemainTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.endTime - curTime
    if remainTime >= 0 then
        self.remainTimeTxt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.remainTimeTxt:SetText("")
    end
end

function Mysterious : DelCountDownTimer()
    self.CountDownTimerAction = nil
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

function Mysterious : OnEnable()
    base.OnEnable(self)
    self.active = true
    self.isShowingRoundAnim = false
    self.flyCount = 0
end

function Mysterious : OnDisable()
    self:TryShowRewardCache()
    for _, req in pairs(self.reqs) do
        req:Destroy()
    end
    self.active = false
    self.flyCount = 0
    base.OnDisable(self)
end

function Mysterious : OnClickRewardPreviewBtn()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMysteriousRewardPreview, self.activityId)
end

function Mysterious : OnClickGetStageRewardBtn()
    if self.flyCount > 0 then
        return
    end
    if self.isShowingRoundAnim then
        return
    end
    local actParamInfo = DataCenter.MysteriousManager:GetActParamInfoByActId(self.activityId)
    local round = actParamInfo.round
    local stage = actParamInfo.rewardStage + 1
    local score = actParamInfo.numbers[1] * actParamInfo.numbers[2] * actParamInfo.numbers[3]
    local needScore = DataCenter.MysteriousManager:CheckRoundStageNeedScore(self.activityId, round, stage)
    if score >= needScore then
        SFSNetwork.SendMessage(MsgDefines.GetMysteriousRewardRes, self.activityId, stage)
    else
        local rewardPreviewInfo = DataCenter.MysteriousManager:GetRewardPreviewInfo(self.activityId)
        local reward = rewardPreviewInfo.gearRewardInfoList[round][stage]
        local icon = ""
        if reward then
            local stageInfo = DataCenter.MysteriousManager:GetStageInfo(self.activityId, round, stage)
            icon = string.format(LoadPath.UIMysterious, stageInfo.pic)
        else
            local list = rewardPreviewInfo.finalRewardInfoList[round]
            if list then
                local info = list[1]
                reward = info.rewardItemInfo
                icon = info.pic
            end
        end
        if reward then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIMysteriousBoxReward, { anim = true }, icon, reward)
        end
    end
end

function Mysterious : OnClickRankBtn()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIMysteriousRank, self.activityId)
end

function Mysterious : OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.MysteriousActParamUpdate, self.OnParamUpdate)
    self:AddUIListener(EventId.MysteriousLotteryUpdate, self.OnLotteryUpdate)
    self:AddUIListener(EventId.GetMysteriousStageReward, self.OnGetStageReward)
    self:AddUIListener(EventId.MysteriousRankInfoUpdate, self.OnRankUpdate)
end

function Mysterious : OnRemoveListener()
    self:RemoveUIListener(EventId.MysteriousActParamUpdate, self.OnParamUpdate)
    self:RemoveUIListener(EventId.MysteriousLotteryUpdate, self.OnLotteryUpdate)
    self:RemoveUIListener(EventId.GetMysteriousStageReward, self.OnGetStageReward)
    self:RemoveUIListener(EventId.MysteriousRankInfoUpdate, self.OnRankUpdate)
    base.OnRemoveListener(self)
end

function Mysterious : RefreshClean()
    local actParamInfo = DataCenter.MysteriousManager:GetActParamInfoByActId(self.activityId)
    local param = {}
    param.round = actParamInfo.round
    param.stage = actParamInfo.rewardStage + 1
    param.nums = actParamInfo.numbers
    param.score = param.nums[1] * param.nums[2] * param.nums[3]
    param.remainNum = actParamInfo:GetRemainLotteryCount()
    self:Refresh(param)
end

function Mysterious : OnParamUpdate()
    if not self.active then
        return
    end
    self:RefreshClean()
end

function Mysterious : OnLotteryUpdate(message)
    if not self.active then
        return
    end
    
    if message["reward"] then
        for _, v in ipairs(message["reward"]) do
            table.insert(self.rewardCache, v)
        end
    end
    
    local lotteryArr = message["lotteryArr"]
    local mysteriousInfo = message["mysteriousInfo"]
    local actParamInfo = DataCenter.MysteriousManager:GetActParamInfoByActId(self.activityId)
    local param = {}
    param.round = mysteriousInfo.round
    param.stage = mysteriousInfo.rewardStage + 1
    param.nums = {}
    param.remainNum = actParamInfo:GetRemainLotteryCount()
    
    if self.skipAnim then
        param.nums = actParamInfo.numbers
        param.score = param.nums[1] * param.nums[2] * param.nums[3]
        local scoreGlowed = {}
        for _, v in ipairs(lotteryArr) do
            if not scoreGlowed[v.index] then
                scoreGlowed[v.index] = true
                self:PlayScoreAnim(v.index)
            end
        end
        self:ShowSliderGlow(true, param)
        self:RefreshClean()
        self:TryShowRewardCache()
    else
        for i, v in ipairs(lotteryArr) do
            local delay = i * FlyDelay
            self.flyCount = self.flyCount + 1
            self:FlyScore(v.index, v.number, delay, function()
                if self.active then
                    self.flyCount = math.max(self.flyCount - 1, 0)
                    param.nums[1] = tonumber(self.scoreTxt1:GetText())
                    param.nums[2] = tonumber(self.scoreTxt2:GetText())
                    param.nums[3] = tonumber(self.scoreTxt3:GetText())
                    param.nums[v.index] = param.nums[v.index] + v.number
                    param.score = param.nums[1] * param.nums[2] * param.nums[3]
                    self:PlayScoreAnim(v.index)
                    self:ShowSliderGlow(true, param)
                    if self.flyCount == 0 then
                        self:RefreshClean()
                        self:TryShowRewardCache()
                    else
                        self:Refresh(param)
                    end
                end
            end)
        end
    end
end

function Mysterious : OnGetStageReward(message)
    if not self.active then
        return
    end
    local actParamInfo = DataCenter.MysteriousManager:GetActParamInfoByActId(self.activityId)
    local mysteriousInfo = message["mysteriousInfo"]
    if mysteriousInfo == nil then
        return
    end

    local numbers = string.split(mysteriousInfo.numbers, ";")
    local param = {}
    param.round = mysteriousInfo.round
    param.stage = mysteriousInfo.rewardStage + 1
    param.nums = {}
    param.nums[1] = tonumber(numbers[1])
    param.nums[2] = tonumber(numbers[2])
    param.nums[3] = tonumber(numbers[3])
    param.score = param.nums[1] * param.nums[2] * param.nums[3]
    param.remainNum = actParamInfo:GetRemainLotteryCount()

    if param.stage == 1 then
        DataCenter.RewardManager:ShowCommonReward(message, nil, nil, nil, nil, nil, nil, nil, function()
            if self.active then
                self.isShowingRoundAnim = true
                self:ShowRoundAnim(true)
                TimerManager:GetInstance():DelayInvoke(function()
                    if self.active then
                        self.fakeImg:LoadSprite(self.lastPic)
                        self.fakeAnim:Play("V_ui_xiangzi_tihuan", 0, 0)
                        self:Refresh(param)
                        self.isShowingRoundAnim = false
                    end
                end, RoundAnimDelay + 0.16)
            end
        end)
    else
        DataCenter.RewardManager:ShowCommonReward(message)
        self:Refresh(param)
    end
end

function Mysterious : ShowScoreGlow(pos)
    local i = #self.reqs + 1
    self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.UIMysteriousScoreGlow, function(req)
        if req.isError then
            return
        end
        local transform = req.gameObject.transform
        transform:SetParent(self.scoreRootAnim.transform)
        transform.position = pos
        TimerManager:GetInstance():DelayInvoke(function()
            if self.reqs and self.reqs[i] then
                self.reqs[i]:Destroy()
            end
        end, 2)
    end)
end

function Mysterious : GetScoreComponents(index)
    local scoreTxt, scoreAnim
    if index == 1 then
        scoreTxt = self.scoreTxt1
        scoreAnim = self.scoreAnim1
    elseif index == 2 then
        scoreTxt = self.scoreTxt2
        scoreAnim = self.scoreAnim2
    elseif index == 3 then
        scoreTxt = self.scoreTxt3
        scoreAnim = self.scoreAnim3
    end
    return scoreTxt, scoreAnim
end

function Mysterious : PlayScoreAnim(index)
    local scoreTxt, scoreAnim = self:GetScoreComponents(index)
    if scoreTxt == nil or scoreAnim == nil then
        return
    end
    self:ShowScoreGlow(scoreTxt.transform.position)
    scoreAnim:Play("V_ui_shuzi_fangda", 0, 0)
end

function Mysterious : FlyScore(index, number, delay, callback)
    local scoreTxt, scoreAnim = self:GetScoreComponents(index)
    if scoreTxt == nil or scoreAnim == nil then
        return
    end
    local startPos = self.oneDrawBtn.transform.position + Vector3.up * FlyScoreOffset
    local endPos = scoreTxt.transform.position
    local duration = 1
    local content = "+" .. number
    
    local i = #self.reqs + 1
    self.reqs[i] = self:GameObjectInstantiateAsync(UIAssets.UIMysteriousScoreFly, function(req)
        if req.isError then
            return
        end
        
        local transform = req.gameObject.transform
        transform:SetParent(self.transform)
        transform.position = startPos
        
        local text = transform:Find("scoreTxt2"):GetComponent(typeof(CS.UnityEngine.UI.Text))
        text.text = content
        
        local controlPos = (startPos + endPos) * 0.5
        controlPos.y = controlPos.y - 150
        DataCenter.FlyController.Bezier2PathNonAlloc(paths, startPos, controlPos, endPos)
        
        transform:DOPath(paths, duration):SetDelay(delay):OnComplete(function()
            if req then
                req:Destroy()
            end
            if callback ~= nil then
                callback()
            end
        end)
    end)
end

function Mysterious : ShowRoundAnim(show)
    self.glow1Go:SetActive(false)
    self.glow2Go:SetActive(false)
    self.glow3Go:SetActive(false)
    if show then
        self.glow1Go:SetActive(true)
        self.glow2Go:SetActive(true)
        self.glow3Go:SetActive(true)
        TimerManager:GetInstance():DelayInvoke(function()
            if self.active then
                self.scoreRootAnim:Play("V_ui_scoreroot_chongzhi", 0, 0)
                self.scoreAnim1:Play("V_ui_shuzi_chongzhi", 0, 0)
                self.scoreAnim2:Play("V_ui_shuzi_chongzhi", 0, 0)
                self.scoreAnim3:Play("V_ui_shuzi_chongzhi", 0, 0)
            end
        end, RoundAnimDelay)
    end
end

function Mysterious : ShowBoxGlow(show)
    self.boxGlowGo:SetActive(false)
    if show then
        self.boxGlowGo:SetActive(true)
    end
end

function Mysterious : ShowSliderGlow(show, param)
    self.sliderGlowGo:SetActive(false)
    if show then
        local needScore = DataCenter.MysteriousManager:CheckRoundStageNeedScore(self.activityId, param.round, param.stage)
        local percent = math.min(param.score / needScore, 1)
        self.sliderGlowGo.transform:Set_localScale(percent, 1, 1)
        self.sliderGlowGo:SetActive(true)
    end
end

function Mysterious : ShowSliderFullGlow(show)
    self.sliderFullGlowGo:SetActive(false)
    if show then
        self.sliderFullGlowGo:SetActive(true)
    end
end

function Mysterious : TryShowRewardCache()
    if table.IsNullOrEmpty(self.rewardCache) then
        return
    end
    DataCenter.RewardManager:ShowCommonReward({ reward = self.rewardCache })
    self.rewardCache = {}
end

function Mysterious : OnRankUpdate()
    local rankInfo = DataCenter.MysteriousManager:GetRankInfoByActId(self.activityId)
    if rankInfo.selfRank > 0 then
        self.rankNumTxt:SetText(rankInfo.selfRank)
    else
        self.rankNumTxt:SetText("-")
    end
end

return Mysterious