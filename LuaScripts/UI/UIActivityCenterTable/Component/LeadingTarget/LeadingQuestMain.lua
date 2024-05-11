---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2022/1/13 11:44
---

local LeadingQuestMain = BaseClass("LeadingQuestMain", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local LeadingQuestItem = require "UI.UIActivityCenterTable.Component.LeadingTarget.LeadingQuestItem"
local LastSeasonHeroInfo = require "UI.UIActivityCenterTable.Component.LeadingTarget.LastSeasonHeroInfo"
local EffectDesc = require "UI.UIDecoration.UIDecorationMain.Component.EffectDesc1"
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local Screen = CS.UnityEngine.Screen

local title_path = "RightView/Top/title"
local infoBtn_path = "RightView/Top/infoBtn"
local subTitle_path = "RightView/Top/subTitle"
local activtyTime_path = "RightView/Top/actTime"
local remainTime_path = "RightView/Top/time/Di/remainTime"
local time_icon_path = "RightView/Top/time/Di/time_icon"

local svQuest_path = "RightView/Rect_Bottom/ScrollView"
local hero_info_path = "RightView1"
local normal_path = "RightView"
local hero_info_bg_path = "Bg2"
local content_path = "RightView/Rect_Bottom/ScrollView/Viewport/Content"
local template_path = "templates(inactive)/LeadingQuestItem"
local bg1_path = "Bg1"
local bg2_path = "Bg1/Image (1)"
local hero_record_btn_path = "RightView/HeroRecordBtn"
local hero_record_btn_text_path = "RightView/HeroRecordBtn/HeroRecordBtnText"
local score_path = "RightView/Score"
local score_text_path = "RightView/Score/ScoreText"
local score_icon_path = "RightView/Score/ScoreImg"

local decoration_btn_path = "Effect/Decoration_Btn"
local decoration_btn_text_path = "Effect/Decoration_Btn/Decoration_Icon/Decoration_Text"

local decoration_effect_path = "Effect"

local slider_path = "RightView/Rect_Bottom/SliderProcessBar"
local processTxt_path = "RightView/Rect_Bottom/SliderProcessBar/scoreProcessTxt"
local upPowerBtn_path = "RightView/Rect_Bottom/SliderProcessBar/upPowerBtn"

local PlayerHeadArena = "RightView/PlayerHeadArena"
local arenaRank_rect_path = "RightView/PlayerHeadArena/UIPlayerHead"
local playerHead_path = "RightView/PlayerHeadArena/UIPlayerHead/HeadIcon"
local playerName_path = "RightView/PlayerHeadArena/Txt_PlayerName"
local arenaRank_path = "RightView/PlayerHeadArena/Txt_ArenaRank"
local giftBarContentMask_path = "RightView/GiftBar/Rect_GiftContentMask"
local giftBarContent_txt_path = "RightView/GiftBar/Rect_GiftContentMask/Txt_GiftContent"
local giftBar_rect_path = "RightView/GiftBar"
local giftBarName_txt_path = "RightView/GiftBar/Txt_GiftName"
local giftBarBuy_btn_path = "RightView/GiftBar/BtnBuy"
local giftBarPrice_txt_path = "RightView/GiftBar/BtnBuy/Txt_Buy"
local giftPoint_rect_path = "RightView/GiftBar/BtnBuy/UIGiftPackagePoint"


local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:DelCountDownTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.titleN = self:AddComponent(UITextMeshProUGUI, title_path)
    self.infoBtnN = self:AddComponent(UIButton, infoBtn_path)
    self.infoBtnN:SetOnClick(function()
        self:OnClickInfoBtn()
    end)
    self.subTitleN = self:AddComponent(UITextMeshProUGUI, subTitle_path)
    self.activityTimeN = self:AddComponent(UITextMeshProUGUI, activtyTime_path)
    self.remainTimeN = self:AddComponent(UITextMeshProUGUI, remainTime_path)
    self.svQuestsN = self:AddComponent(UIScrollView, svQuest_path)
    self.svQuestsN:SetOnItemMoveIn(function(itemObj, index)
        self:OnQuestItemMoveIn(itemObj, index)
    end)
    self.svQuestsN:SetOnItemMoveOut(function(itemObj, index)
        self:OnQuestItemMoveOut(itemObj, index)
    end)
    self.contentN = self:AddComponent(UIBaseContainer, content_path)
    --self.templateN = self:AddComponent(UIBaseContainer, template_path)
    --self.templateN.gameObject:GameObjectCreatePool()
    --self.bg1N = self:AddComponent(UIImage, bg1_path)
    --self.bg2N = self:AddComponent(UIImage, bg2_path)
    self.normal = self:AddComponent(UIBaseContainer, normal_path)
    self.normal:SetActive(true)
    self.time_icon = self:AddComponent(UIImage, time_icon_path)
end

local function ComponentDestroy(self)
    self:HideDecorationEffect()
    self:HideLastSeasonHeroInfo()
    if self.hero_record_btn then
        self.hero_record_btn:SetActive(false)
    end
    if self.score then
        self.score:SetActive(false)
    end
    if self.hero_info_bg ~= nil then
        self.hero_info_bg:SetActive(false)
    end

    self.score = nil
    self.hero_record_btn = nil
    self.titleN = nil
    self.subTitleN = nil
    self.activityTimeN = nil
    self.remainTimeN = nil
    self.contentN = nil
    self.templateN = nil
    self.bg1N = nil
    self.bg2N = nil
    if self._giftContent_txt and self.activityData and self.activityData.para1 == "gift" then
        DOTween.Kill(self._giftContent_txt.transform)
    end
end

local function DataDefine(self)
    self.activityId = nil
    self.activityData = nil
    self.CountDownTimerAction = nil
    self.countDownTimer = nil
    self._timer_loop = nil
    self._timer_loop_action = function(temp)
        self:RefreshGiftContent()
    end
    self.shownCellList = {}
end

local function DataDestroy(self)
    self.activityId = nil
    self.activityData = nil
    self.CountDownTimerAction = nil
    self.countDownTimer = nil
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
    self:DeleteTimer()
    self.shownCellList = nil
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnClaimRewardEffFinish, self.ShowTasks)
    self:AddUIListener(EventId.RefreshItems, self.RefreshScoreText)
    self:AddUIListener(EventId.UpdateGiftPackData, self.RefreshGiftBar)
    self:AddUIListener(EventId.OnUpdateArenaBaseInfo, self.OnRefreshArenaRank)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnClaimRewardEffFinish, self.ShowTasks)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshScoreText)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.RefreshGiftBar)
    self:RemoveUIListener(EventId.OnUpdateArenaBaseInfo, self.OnRefreshArenaRank)
    base.OnRemoveListener(self)
end

local function SetData(self, activityId)
    self.activityId = activityId
    if not self.activityId then
        return
    end
    self.activityData = DataCenter.ActivityListDataManager:GetActivityDataById(self.activityId)
    self:RefreshAll()
    
    if self.activityData.type == EnumActivity.LeadingQuest.Type and self.activityData.notice_info == EnumActivityNoticeInfo.EnumActivityNoticeInfo_Hero 
    and not self:IsPreview() then
        if self.hero_record_btn == nil then
            self.hero_record_btn = self:AddComponent(UIButton, hero_record_btn_path)
            self.hero_record_btn:SetActive(true)
            self.hero_record_btn_text = self:AddComponent(UITextMeshProUGUI, hero_record_btn_text_path)
            local seasonId = DataCenter.SeasonDataManager:GetSeasonId() or 0
            self.hero_record_btn_text:SetLocalText(372558, seasonId - 1)
            self.hero_record_btn:SetOnClick(function()
                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
                self:OnRecordClick()
            end)
            
            self.score = self:AddComponent(UIBaseContainer, score_path)
            self.score_text = self:AddComponent(UITextMeshProUGUI, score_text_path)
            self.score_icon = self:AddComponent(UIImage, score_icon_path)
            self.score:SetActive(true)
            local itemId = toInt(self.activityData.para1)
            self.score_icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(itemId))
            self:RefreshScoreText()
        end
        local isNew = DataCenter.ActivityListDataManager:IsActivityNew(self.activityId)
        if isNew then
            self:ShowLastSeasonHeroInfo(isNew)
            self.hero_record_btn:SetActive(false)
        end
    end

    if self.activityData.para1 == "arena" then  --竞技场排行榜
        if self.PlayerHeadArena == nil then
            self.PlayerHeadArena = self:AddComponent(UIButton,PlayerHeadArena)
            self.PlayerHeadArena:SetOnClick(function()
                self:OnClickArenaRank()
            end)
            self.playerHeadN = self:AddComponent(UIPlayerHead, playerHead_path)
            self._playerName_txt = self:AddComponent(UITextMeshProUGUI,playerName_path)
            self._arenaRank_txt = self:AddComponent(UITextMeshProUGUI,arenaRank_path)
            self._arenaRank_txt:SetLocalText(372198)
        end
        if self.PlayerHeadArena then
            --检查是不是伊甸园赛季
            local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
            if seasonId >= 5 then
                if LuaEntry.Player.serverType ~= ServerType.EDEN_SERVER then
                    self.PlayerHeadArena:SetActive(false)
                else
                    self.PlayerHeadArena:SetActive(true)
                    SFSNetwork.SendMessage(MsgDefines.GetArenaInfo, 0)
                end
            else
                self.PlayerHeadArena:SetActive(true)
                SFSNetwork.SendMessage(MsgDefines.GetArenaInfo, 0)
            end
        end
    elseif self.activityData.para1 == "gift" then   --礼包
        if self._giftBar_rect == nil then
            self._giftBar_rect = self:AddComponent(UIButton,giftBar_rect_path)
            self._giftBar_rect:SetOnClick(function()
                self:GoWindowPackage()
            end)
            self._giftName_txt = self:AddComponent(UITextMeshProUGUI,giftBarName_txt_path)
            self._giftContent_rect = self:AddComponent(UIBaseContainer,giftBarContentMask_path)
            self._giftContent_txt = self:AddComponent(UITextMeshProUGUI,giftBarContent_txt_path)
            self._giftBuy_btn = self:AddComponent(UIButton,giftBarBuy_btn_path)
            self._giftBuy_btn:SetOnClick(function()
                self:OnBuyGift()
            end)
            self._giftPrice_txt = self:AddComponent(UITextMeshProUGUI,giftBarPrice_txt_path)
            self._giftPoint_rect = self:AddComponent(UIGiftPackagePoint,giftPoint_rect_path)
        end
        self:RefreshGiftBar()
    end
    
    CS.GameEntry.Setting:SetBool("OpenedLeadingQuestView_" .. LuaEntry.Player.uid, true)
    EventManager:GetInstance():Broadcast(EventId.RefreshActivityRedDot)

    self:ShowDecorationEffect()
end

local function RefreshScoreText(self)
    if self.score_text == nil or self.activityData == nil then
        return
    end
    local itemId = toInt(self.activityData.para1)
    local itemNum = DataCenter.ItemData:GetItemCount(itemId)
    self.score_text:SetText(string.GetFormattedSeperatorNum(itemNum))
end

local function RefreshAll(self)
    if self.activityData.type == EnumActivity.LeadingQuest.Type and self.activityData.notice_info == EnumActivityNoticeInfo.EnumActivityNoticeInfo_Hero then
        local seasonId = DataCenter.SeasonDataManager:GetSeasonId() or 0
        if not self:IsPreview() then
            self.titleN:SetLocalText(self.activityData.name, seasonId - 1)
        else
            self.titleN:SetLocalText(self.activityData.name, seasonId)
        end
    elseif self.activityData.type == EnumActivity.LeadingQuest.Type and not string.IsNullOrEmpty(self.activityData.unlock_hero) then
        local seasonId = DataCenter.SeasonDataManager:GetSeasonId() or 0
        self.titleN:SetLocalText(self.activityData.name, seasonId)
    else
        self.titleN:SetText(Localization:GetString(self.activityData.name))
    end
    self.subTitleN:SetText(Localization:GetString(self.activityData.desc_info))
    if string.IsNullOrEmpty(self.activityData.story) then
        self.infoBtnN:SetActive(false)
    else
        self.infoBtnN:SetActive(true)
    end

    if not self:IsPreview() then
        local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.startTime)
        local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(self.activityData.endTime)
        self.activityTimeN:SetText(startT .. "-" .. endT)
        --local bgPath = "Assets/Main/TextureEx/UIActivity/%s.png"
        --local tempBg = self.activityData.activity_pic
        --self.bg1N:LoadSprite(string.format(bgPath, tempBg .. "_1"))
        --self.bg2N:LoadSprite(string.format(bgPath, tempBg .. "_2"))

        self:AddCountDownTimer()
        self:RefreshRemainTime()
        self.time_icon:SetActive(true)
    else
        self.activityTimeN:SetText("")
        self.time_icon:SetActive(false)
        self.remainTimeN:SetText("")
        self:DelCountDownTimer()
    end

    self:ShowTasks()
end

local function OnClickArenaRank(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.LeadingQuestArenaRank)
end


local function OnRefreshArenaRank(self)
    local rankList = DataCenter.ArenaManager:GetRankList()
    if rankList and table.count(rankList) > 0 and self.activityData.para1 == "arena" then
        self.playerHeadN:SetData(rankList[1].uid, rankList[1].pic, rankList[1].picVer)
        local tempAbbr = not string.IsNullOrEmpty(rankList[1].abbr) and "[" .. rankList[1].abbr .. "]" or ""
        self._playerName_txt:SetText(tempAbbr .. rankList[1].name)
    end
end

--{{{礼包相关
local function RefreshGiftBar(self)
    if self._giftBar_rect then
        self._giftBar_rect:SetActive(false)
        if self.activityId and self.activityData and self.activityData.para1 == "gift" then
            local packList = GiftPackageData.GetActByIdPacks(self.activityId)
            if packList and #packList > 0 then
                self.packageInfo = packList[1]
                self._giftBar_rect:SetActive(true)
                self._giftName_txt:SetLocalText(self.packageInfo:getName())
                local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
                self._giftPrice_txt:SetText(price)
                self._giftContent_txt:SetText(self.packageInfo:getDescText())
                CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self._giftContent_txt.rectTransform)
                self._giftContent_txt:SetAnchoredPositionXY(-80,0)
                if self._giftContent_txt:GetSizeDelta().x > self._giftContent_rect:GetSizeDelta().x then
                    self:AddTimer()
                    if self.delayTimer == nil then
                        self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
                            self:RefreshGiftContent()
                        end, 1)
                    end
                end
            end
        end
        --积分
        self._giftPoint_rect:RefreshPoint(self.packageInfo)
    end
end


local function AddTimer(self)
    if self._timer_loop == nil then
        local time = 15
        local width = self._giftContent_txt:GetSizeDelta().x
        if width > 900 then
            time = 24
        elseif width > 700 then
            time = 21
        elseif width > 500 then
            time = 10
        end
        self._timer_loop = TimerManager:GetInstance():GetTimer(time, self._timer_loop_action , self, false,false,false)
        self._timer_loop:Start()
    end
end

local function DeleteTimer(self)
    if self._timer_loop ~= nil then
        self._timer_loop:Stop()
        self._timer_loop = nil
    end
end


local function RefreshGiftContent(self)
    if self._giftContent_txt == nil then
        return
    end
    local time = 6
    local offset = self._giftContent_txt:GetSizeDelta().x
    if offset > 900 then
        time = 15
    elseif offset > 700 then
        time = 12
    elseif offset > 500 then
        time = 9
    end
    local curPos = self._giftContent_txt:GetAnchoredPosition()
    self._giftContent_txt.rectTransform:DOAnchorPosX( curPos.x - offset - 10, time,true):OnComplete(function()
        self._giftContent_txt:SetAnchoredPositionXY(80,curPos.y)
        self._giftContent_txt.rectTransform:DOAnchorPosX(curPos.x, 3)
    end):SetEase(CS.DG.Tweening.Ease.Linear)
end

local function GoWindowPackage(self)
    if self.packageInfo then
        GoToUtil.GotoGiftPackView(self.packageInfo)
    end
end

local function OnBuyGift(self)
    if self.packageInfo then
        DataCenter.PayManager:CallPayment(self.packageInfo)
    end
end
--}}}


local function GetItemBgPath(self)
    local bgPath = "Assets/Main/TextureEx/UIActivity/%s.png"
    local tempBg = self.activityData.activity_pic
    return string.format(bgPath, tempBg .. "_3")
end

local function GetTaskListSorted(self)
    if not self.activityData then
        return {}
    end
    
    local tasks = {}
    local taskGroups = self.activityData:GetTaskGroups()
    for i, taskList in ipairs(taskGroups) do
        for m, taskId in ipairs(taskList) do
            local taskInfo = DataCenter.TaskManager:FindTaskInfo(taskId)
            if not taskInfo or taskInfo.state == 1 or taskInfo.state == 0 or m == #taskList then
                table.insert(tasks, taskId)
                break
            end
        end
    end
    
    table.sort(tasks, function(a, b)
        local taskValueA = DataCenter.TaskManager:FindTaskInfo(a)
        local taskValueB = DataCenter.TaskManager:FindTaskInfo(b)
        if not taskValueA then
            return false
        elseif not taskValueB then
            return true
        else
            if taskValueA.state ~= taskValueB.state then
                if taskValueA.state == 1 then
                    return true
                elseif taskValueB.state == 1 then
                    return false
                elseif taskValueA.state == 2 then
                    return false
                elseif taskValueB.state == 2 then
                    return true
                end
            else
                return tonumber(a) < tonumber(b)
            end
        end
    end)
    return tasks
end

local function ShowTasks(self)
    self.taskList = self:GetTaskListSorted()
    if #self.taskList>0 then
        self.svQuestsN:SetTotalCount(#self.taskList)
        self.svQuestsN:RefillCells()

        self:RefreshProcessBar()
    end
    
    
    --self.contentN:RemoveComponents(LeadingQuestItem)
    --self.templateN.gameObject:GameObjectRecycleAll()
    --
    --local list = taskList
    --if list~=nil and #list>0 then
    --    for i = 1, table.length(list) do
    --        local item = self.templateN.gameObject:GameObjectSpawn(self.contentN.transform)
    --        item.name = "task_" .. i
    --        local obj = self.contentN:AddComponent(LeadingQuestItem,item.name)
    --        obj:SetItem(list[i])
    --    end
    --end
end

local function RefreshProcessBar(self)
    self.taskList = self:GetTaskListSorted()
    if #self.taskList>0 and self.processTxt and self.slider then
        --进度条刷新
        local curValue = LuaEntry.Player.buildingPower + LuaEntry.Player.heroPower + LuaEntry.Player.armyPower + LuaEntry.Player.sciencePower
        local maxValue = self:GetMaxValue()
        self.processTxt:SetText(string.GetFormattedSeperatorNum(curValue).."/"..string.GetFormattedSeperatorNum(maxValue))
        self.slider:SetValue(tonumber(curValue)/tonumber(maxValue))
    end
end

local function AddCountDownTimer(self)
    self.CountDownTimerAction = function()
        self:RefreshRemainTime()
    end

    if self.countDownTimer == nil then
        self.countDownTimer = TimerManager:GetInstance():GetTimer(1, self.CountDownTimerAction , self, false,false,false)
    end
    self.countDownTimer:Start()
end

local function RefreshRemainTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local remainTime = self.activityData.endTime - curTime
    if remainTime > 0 then
        if self.activityData:CheckIfIsToEnd() then
            self.remainTimeN:SetColorRGBA(0.91, 0.26, 0.26, 1)
        end
        self.remainTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
    else
        self.remainTimeN:SetText("")
        self:DelCountDownTimer()
    end
end

local function DelCountDownTimer(self)
    if self.countDownTimer ~= nil then
        self.countDownTimer:Stop()
        self.countDownTimer = nil
    end
end

local function OnQuestItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.svQuestsN:AddComponent(LeadingQuestItem, itemObj)
    --local bgPath = self:GetItemBgPath()
    cellItem:SetItem(self.taskList[index], nil, Bind(self, self.GetFlyPos), self:IsPreview(),false,self.activityData)
    self.shownCellList[index] = cellItem
end

local function OnQuestItemMoveOut(self, itemObj, index)
    self.svQuestsN:RemoveComponent(itemObj.name, LeadingQuestItem)
    if self.shownCellList and index <= #self.shownCellList then
        table.remove(self.shownCellList, index)
    end
end

local function ClearScroll(self)
    self.svQuestsN:ClearCells()
    self.svQuestsN:RemoveComponents(LeadingQuestItem)
end


local function OnClickInfoBtn(self)
    if self.activityData and self.activityData.story then
        UIUtil.ShowIntro(Localization:GetString(self.activityData.name), Localization:GetString("100239"), Localization:GetString(self.activityData.story))
    end
end

local function ShowLastSeasonHeroInfo(self, isNew)
    if self.lastSeasonInfo == nil then
        self.lastSeasonInfo = self:AddComponent(LastSeasonHeroInfo, hero_info_path)
        self.lastSeasonInfo:SetClickFun(Bind(self, self.HideLastSeasonHeroInfo))
    end
    if self.hero_info_bg == nil then
        self.hero_info_bg = self:AddComponent(UIImage, hero_info_bg_path)
    end
    self.hero_info_bg:SetActive(true)
    self.lastSeasonInfo:SetActive(true)
    self.lastSeasonInfo:RefreshView(self.activityData.name, isNew)
    self.normal:SetActive(false)
end

local function HideLastSeasonHeroInfo(self)
    if self.lastSeasonInfo ~= nil then
        self.lastSeasonInfo:SetActive(false)
    end
    self.normal:SetActive(true)
    if self.hero_info_bg ~= nil then
        self.hero_info_bg:SetActive(false)
    end

    if self.hero_record_btn and not self.hero_record_btn:GetActive() then
        self.hero_record_btn:SetActive(true)
        local endPos = self.hero_record_btn.transform.position
        local scaleFactor = UIManager:GetInstance():GetScaleFactor()
        self.hero_record_btn.transform.position = Vector3.New(Screen.width * scaleFactor / 2, Screen.height * scaleFactor / 2, 0)
        self.hero_record_btn.transform:DOMove(endPos, 0.7):SetEase(CS.DG.Tweening.Ease.OutCubic)
    end
end

local function OnRecordClick(self)
    if self.lastSeasonInfo == nil or not self.lastSeasonInfo:GetActive() then
        self:ShowLastSeasonHeroInfo()
    else
        self:HideLastSeasonHeroInfo()
    end
end

local function GetFlyPos(self, itemId, srcPos)
    if self.activityData and self.score_icon and self.score:GetActive() and toInt(self.activityData.para1) == toInt(itemId) then
        local pos = self.score_icon.transform.position
        srcPos.x = pos.x
        srcPos.y = pos.y
    end
end

local function IsPreview(self)
    if not string.IsNullOrEmpty(self.activityData.unlock_hero) then
        --local heroData = DataCenter.HeroDataManager:GetHeroById(toInt(self.activityData.unlock_hero))
        local toHeroId = DataCenter.HeroEvolveActivityManager:GetToHeroId()
        if toHeroId == 0 or string.IsNullOrEmpty(DataCenter.HeroDataManager:GetHeroById(toHeroId)) then
            return true
        end

        --if heroData == nil then
        --    return true
        --end
        return false
    end
    return self.activityData.sub_type == ActivityEnum.ActivitySubType.ActivitySubType_1
end

local function OnDecorationClick(self)
    if self.activityData == nil then
        return
    end
    local decorationId = toInt(self.activityData.para2)
    local decorationTemplate = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    if decorationTemplate then
        DecorationUtil.OpenDecorationPanel(decorationTemplate.type, decorationTemplate.id, self.activityId)
    end
end

local function ShowDecorationEffect(self)
    if self.activityData == nil then
        return
    end
    local decorationId = toInt(self.activityData.para2)
    local decorationConfig = DataCenter.DecorationTemplateManager:GetTemplate(decorationId)
    if decorationConfig ~= nil then
        if self.decorationEffect == nil then
            self.decorationEffect = self:AddComponent(EffectDesc, decoration_effect_path)
            self.decoration_btn = self:AddComponent(UIButton, decoration_btn_path)
            self.decoration_btn:SetOnClick(function()
                self:OnDecorationClick()
            end)
            self.decoration_btn_text = self:AddComponent(UITextMeshProUGUI, decoration_btn_text_path)
            self.decoration_btn_text:SetLocalText(110036)
        end
        self.decorationEffect:SetActive(true)
        local effectData = DecorationUtil.GetEffectDesc(decorationId)
        self.decorationEffect:ReInit(effectData,self.activityData.activity_pic)

        --该类活动进度条
        if not self.slider then
            self.slider = self:AddComponent(UISlider, slider_path)
            self.processTxt = self:AddComponent(UITextMeshProUGUI, processTxt_path)
            self.upPowerBtn = self:AddComponent(UIButton, upPowerBtn_path)
            self.upPowerBtn:SetOnClick(function()
                self:OnClickUpPowerBtn()
            end)
        end
        local isSwitchOn = LuaEntry.DataConfig:CheckSwitch("promote_power_tips")
        self.upPowerBtn:SetActive(isSwitchOn)
        self:RefreshProcessBar()
    end
end

local function HideDecorationEffect(self)
    if self.decorationEffect ~= nil then
        self.decorationEffect:SetActive(false)
    end
end

local function OnClickUpPowerBtn(self)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIUpPower,{anim = true,isBlur = true})
end

local function GetMaxValue(self)
    local maxValue = 0
    if #self.taskList > 0 then
        for k,v in pairs(self.taskList) do
            local para2 = GetTableData(DataCenter.QuestTemplateManager:GetTableName(), v, "para2",  0)
            if para2 > maxValue then
                maxValue = para2
            end
        end
    end
    return maxValue
end

LeadingQuestMain.OnCreate = OnCreate
LeadingQuestMain.OnDestroy = OnDestroy
LeadingQuestMain.ComponentDefine = ComponentDefine
LeadingQuestMain.ComponentDestroy = ComponentDestroy
LeadingQuestMain.DataDefine = DataDefine
LeadingQuestMain.DataDestroy = DataDestroy
LeadingQuestMain.OnAddListener = OnAddListener
LeadingQuestMain.OnRemoveListener = OnRemoveListener

LeadingQuestMain.SetData = SetData
LeadingQuestMain.RefreshAll = RefreshAll
LeadingQuestMain.ShowTasks = ShowTasks
LeadingQuestMain.AddCountDownTimer = AddCountDownTimer
LeadingQuestMain.RefreshRemainTime = RefreshRemainTime
LeadingQuestMain.DelCountDownTimer = DelCountDownTimer
LeadingQuestMain.GetTaskListSorted = GetTaskListSorted
LeadingQuestMain.OnQuestItemMoveIn = OnQuestItemMoveIn
LeadingQuestMain.OnQuestItemMoveOut = OnQuestItemMoveOut
LeadingQuestMain.ClearScroll = ClearScroll
LeadingQuestMain.GetItemBgPath = GetItemBgPath
LeadingQuestMain.OnClickInfoBtn = OnClickInfoBtn
LeadingQuestMain.ShowLastSeasonHeroInfo = ShowLastSeasonHeroInfo
LeadingQuestMain.HideLastSeasonHeroInfo = HideLastSeasonHeroInfo
LeadingQuestMain.OnRecordClick = OnRecordClick
LeadingQuestMain.RefreshScoreText = RefreshScoreText
LeadingQuestMain.GetFlyPos = GetFlyPos
LeadingQuestMain.IsPreview = IsPreview
LeadingQuestMain.OnClickArenaRank = OnClickArenaRank
LeadingQuestMain.RefreshGiftBar = RefreshGiftBar
LeadingQuestMain.OnBuyGift = OnBuyGift
LeadingQuestMain.OnRefreshArenaRank = OnRefreshArenaRank

LeadingQuestMain.AddTimer = AddTimer
LeadingQuestMain.DeleteTimer = DeleteTimer
LeadingQuestMain.RefreshGiftContent = RefreshGiftContent
LeadingQuestMain.GoWindowPackage = GoWindowPackage

LeadingQuestMain.OnDecorationClick = OnDecorationClick
LeadingQuestMain.ShowDecorationEffect = ShowDecorationEffect
LeadingQuestMain.HideDecorationEffect = HideDecorationEffect
LeadingQuestMain.OnClickUpPowerBtn = OnClickUpPowerBtn
LeadingQuestMain.GetMaxValue = GetMaxValue
LeadingQuestMain.RefreshProcessBar = RefreshProcessBar

return LeadingQuestMain