--- Created by shimin.
--- DateTime: 2023/12/19 18:35
--- 科技Tab界面

local UIScienceTabView = BaseClass("UIScienceTabView", UIBaseView)
local base = UIBaseView
local UIScienceTabRowCell = require "UI.UIScienceTab.Component.UIScienceTabRowCell"

local back_btn_path = "fullTop/CloseBtn"
local title_text_path = "fullTop/imgTitle/Common_img_title/titleText"
local gold_btn_path = "fullTop/gold_btn"
local gold_num_text_path = "fullTop/gold_btn/gold_num_text"
local scroll_view_path = "BgGo/MiddleBg/ScrollView"
local researching_go_path = "BgGo/MiddleBg/UITechnology_imgbg_study"
local researching_btn_path = "BgGo/MiddleBg/UITechnology_imgbg_study/speed_btn"
local researching_btn_name_path = "BgGo/MiddleBg/UITechnology_imgbg_study/speed_btn/speed_btn_text"
local researching_icon_path = "BgGo/MiddleBg/UITechnology_imgbg_study/icon_bg/icon"
local researching_name_path = "BgGo/MiddleBg/UITechnology_imgbg_study/slider_name"
local researching_slider_path = "BgGo/MiddleBg/UITechnology_imgbg_study/slider"
local researching_left_time_path = "BgGo/MiddleBg/UITechnology_imgbg_study/slider/slider_text"

local NewLine = 3
local SliderLength = 360

--创建
function UIScienceTabView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UIScienceTabView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIScienceTabView:ComponentDefine()
    self.back_btn = self:AddComponent(UIButton, back_btn_path)
    self.back_btn:SetOnClick(function()
        self.isClose = true
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.gold_btn = self:AddComponent(UIButton, gold_btn_path)
    self.gold_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGoldBtnClick()
    end)
    self.gold_num_text = self:AddComponent(UITextMeshProUGUIEx, gold_num_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.researching_go = self:AddComponent(UIBaseContainer, researching_go_path)
    self.researching_btn = self:AddComponent(UIButton, researching_btn_path)
    self.researching_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnResearchingBtnClick()
    end)
    self.researching_btn_name = self:AddComponent(UITextMeshProUGUIEx, researching_btn_name_path)
    self.researching_icon = self:AddComponent(UIImage, researching_icon_path)
    self.researching_name = self:AddComponent(UITextMeshProUGUIEx, researching_name_path)
    self.researching_slider = self:AddComponent(UISlider, researching_slider_path)
    self.researching_left_time = self:AddComponent(UITextMeshProUGUIEx, researching_left_time_path)
end

function UIScienceTabView:ComponentDestroy()
end


function UIScienceTabView:DataDefine()
    self.gotoTab = ScienceTab.Resource
    self.bUuid = 0
    self.rowCells = {}
    self.list = {}
    self.queue = {}
    self.SendFinishFlagList = {}
    self.reachingScienceList = {}
    self.laseTime = 0
    self.lastChangeTime = 0
    self.upgrade_effect = nil
    self.select = {}
    self.waitHelp = false
    self.isClose = false--正在关闭
end

function UIScienceTabView:DataDestroy()
    self.isClose = true--正在关闭
end

function UIScienceTabView:OnEnable()
    base.OnEnable(self)
end

function UIScienceTabView:OnDisable()
    base.OnDisable(self)
end

function UIScienceTabView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:AddUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
    self:AddUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
    self:AddUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
end


function UIScienceTabView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpdateScienceSignal)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:RemoveUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
    self:RemoveUIListener(EventId.OnScienceQueueResearch, self.OnScienceSearchingSignal)
    self:RemoveUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
end

function UIScienceTabView:ReInit()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Open_Science_Tab)
    local tab, bUuid = self:GetUserData()
    self.bUuid = bUuid
    if tab ~= nil and tab ~= "" then
        self.gotoTab = tonumber(tab)
    else
        self.gotoTab = ScienceTab.Resource
    end
    self.title_text:SetLocalText(GameDialogDefine.SCIENCE)
    self:ShowCells()
    self:RefreshGold()
    self:ShowResearching()
end

function UIScienceTabView:GetDataList()
    self.list = {}
    local allTabs = DataCenter.ScienceTemplateManager:GetCurShowTab(ScienceType.Build)
    if allTabs ~= nil then
        local count = 0
        for k, v in ipairs(allTabs) do
            if k % NewLine ~= 0 then
                count = count + 1
                local param = {}
                param.index = count
                param.list = {}
                table.insert(self.list, param)
            end
            table.insert(self.list[count].list, v)
        end
    end
end

function UIScienceTabView:ClearScroll()
    self.rowCells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIScienceTabRowCell)--清循环列表gameObject
end

function UIScienceTabView:OnCreateCell(itemObj, index)
    itemObj.name = "row_"..index
    local cell = self.scroll_view:AddComponent(UIScienceTabRowCell, itemObj)
    cell:ReInit(self.list[index])
    self.rowCells[index] = cell
end

function UIScienceTabView:OnDeleteCell(itemObj, index)
    self.rowCells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, UIScienceTabRowCell)
end

function UIScienceTabView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = #self.list
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
        self.scroll_view:ScrollToCell(1, 2000)
    end
end

function UIScienceTabView:RefreshGold()
    self.gold_num_text:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

function UIScienceTabView:UpdateScienceSignal()
    if not self.isClose then
        self:RefreshCells()
        self:ShowResearching()
    end
end

function UIScienceTabView:RefreshCells()
    for k,v in pairs(self.rowCells) do
        v:Refresh()
    end
end

function UIScienceTabView:UpdateBuildDataSignal()
    if not self.isClose then
        self:RefreshCells()
    end
end

function UIScienceTabView:QueueTimeEndSignal(data)
    if not self.isClose then
        local queueType = data
        if queueType == NewQueueType.Science then
            if (not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceInfo))
                    and (not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScience)) then
                if table.count(self.SendFinishFlagList) > 0 then
                    for k,v in pairs(self.SendFinishFlagList) do
                        if not v then
                            local queue = DataCenter.QueueDataManager:GetQueueByUuid(k)
                            if queue ~= nil then
                                if DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(tonumber(queue.funcUuid)) then
                                    self.SendFinishFlagList[k] = true
                                end
                            end
                        end
                    end
                end
            end
            self:RefreshCells()
            self:ShowResearching()
        end
    end
end


function UIScienceTabView:OnScienceSearchingSignal()
    if not self.isClose then
        self:RefreshCells()
        self:ShowResearching()
    end
end

function UIScienceTabView:OnScienceQueueFinishSignal()
    if not self.isClose then
        self:RefreshCells()
        self:ShowResearching()
    end
end

function UIScienceTabView:UpdateGoldSignal()
    if not self.isClose then
        self:RefreshGold()
    end
end


function UIScienceTabView:ShowResearching()
    self.select = {}
    self.queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.bUuid)
    if self.queue == nil or self.queue:GetQueueState() == NewQueueState.Free or self.queue:GetQueueState() == NewQueueState.Finish then
        self.queue = nil
        self:SetResearchingActive(false)
    else
        if self.queue.itemId ~= nil and self.queue.itemId ~= "" then
            local scienceId = tonumber(self.queue.itemId)
            self:SetResearchingActive(true)
            local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
            if template~= nil then
                local isContinue = true
                for k,v in ipairs(self.list) do
                    for k1, v1 in ipairs(v) do
                        if v1.id == template.tab then
                            self.select.id = template.tab
                            self.select.index = k
                            self.select.modelIndex = k1
                            isContinue = false
                            break
                        end
                    end
                    if not isContinue then
                        break
                    end
                end
                self.researching_name:SetLocalText(template.name)
                local curLevel = DataCenter.ScienceManager:GetScienceLevel(scienceId)
                local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(scienceId)
                if maxLevel > curLevel then
                    self.researching_icon:LoadSprite(string.format(LoadPath.ScienceIcons,template.icon))
                end
            end
        end
        self:RefreshResearchingBtnName()
    end
    local queueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
    self.reachingScienceList = {}
    for k, v in ipairs(queueList) do
        if v:GetQueueState() ~= NewQueueState.Free then
            local scienceId = tonumber(v.itemId)
            local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
            if template ~= nil then
                self.reachingScienceList[scienceId] = v
            end
        end
    end
end


function UIScienceTabView:SetResearchingActive(value)
    if self.researchingActive ~= value then
        self.researchingActive = value
        self.researching_go:SetActive(value)
    end
end


function UIScienceTabView:Update()
    if not self.isClose then
        if table.count(self.reachingScienceList)>0 then
            self:UpdateLeftTime()
            for k, v in pairs(self.reachingScienceList) do
                if v:GetQueueState() == NewQueueState.Finish then
                    if (not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceInfo))
                            and (not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScience)) then
                        if not self.SendFinishFlagList[v.uuid] then
                            if DataCenter.ScienceManager:CheckResearchFinishByBuildUuid(tonumber(v.funcUuid)) then
                                self.SendFinishFlagList[v.uuid] = true
                            end
                        end
                    end
                end
            end
        end
    end
end

function UIScienceTabView:UpdateLeftTime(forceRefresh)
    if self.queue~=nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.queue.endTime - curTime
        local maxTime = self.queue.endTime - self.queue.startTime
        if changeTime < maxTime and changeTime > 0 then
            local tempTimeSec = math.ceil(changeTime / 1000)
            if tempTimeSec ~= self.laseTime or forceRefresh then
                self.laseTime = tempTimeSec
                local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
                self.researching_left_time:SetText(tempTimeValue)
            end

            if maxTime > 0 then
                local tempValue = 1 - changeTime / maxTime
                if TimeBarUtil.CheckIsNeedChangeBar(changeTime,self.lastChangeTime,maxTime,SliderLength) then
                    self.lastChangeTime = changeTime
                    self.researching_slider:SetValue(tempValue)
                end
            end
        else
            self.laseTime = 0
            self.researching_slider:SetValue(0)
            self.researching_left_time:SetText("")
            return
        end
    end
end

function UIScienceTabView:RefreshResearchingBtnName()
    self.waitHelp = false
    if LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
        self.researching_btn_name:SetLocalText(GameDialogDefine.ALLIANCE_HELP)
        self.researching_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_green71"))
    else
        self.researching_btn:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_btn_blue_samll"))
        if self:IsUseHeroFreeAddTime() then
            self.researching_btn_name:SetLocalText(GameDialogDefine.FREE)
        else
            self.researching_btn_name:SetLocalText(GameDialogDefine.ADD_SPEED)
        end
    end
end

function UIScienceTabView:OnResearchingBtnClick()
    if self:IsUseHeroFreeAddTime() then
        SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.queue.uuid,itemIDs = "",isGold = IsGold.NoUseGold })
    else
        if (not self.waitHelp)  and LuaEntry.Player:IsInAlliance() and self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work and self.queue.isHelped == 0 then
            --联盟帮助
            self.waitHelp = true
            SFSNetwork.SendMessage(MsgDefines.AllianceCallHelp,self.queue.uuid,AllianceHelpType.Queue,NewQueueType.Science,self.queue.itemId)
            if self:IsUseHeroFreeAddTime() then
                self.researching_btn_name:SetLocalText(GameDialogDefine.FREE)
            else
                self.researching_btn_name:SetLocalText(GameDialogDefine.ADD_SPEED)
            end
        else
            --打开加速界面
            UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed, NormalBlurPanelAnim, ItemSpdMenu.ItemSpdMenu_Science, self.queue.uuid)
        end
    end
end

function UIScienceTabView:IsUseHeroFreeAddTime()
    local isUseFreeTime = DataCenter.HeroDataManager:GetFreeAddTimeHero(ItemSpdMenu.ItemSpdMenu_Science)
    local freeTime = LuaEntry.Effect:GetGameEffect(EffectDefine.RESEARCH_TIME_REDUCE)
    if isUseFreeTime or freeTime > 0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        if self.queue.endTime - curTime <= freeTime*SecToMilSec then
            return true
        end
    end
    return false
end

function UIScienceTabView:OnScienceQueueFinishSignal(queueUuid)
    if not self.isClose then
        self.SendFinishFlagList[queueUuid] = false
        self:ShowResearching()
    end
end

function UIScienceTabView:AllianceQueueHelpNewSignal()
    if not self.isClose then
        self:RefreshResearchingBtnName()
    end
end


function UIScienceTabView:RefreshUpgradeEffect()
    if self.select.id ~= nil then
        if self.upgrade_effect == nil then
            self.upgrade_effect = self:GameObjectInstantiateAsync(UIAssets.UIScienceTabUpgradeEffect,
                    function(request)
                        if request.isError then
                            return
                        end
                        self:RefreshUpgradeEffect()
                    end)
        elseif self.upgrade_effect.gameObject ~= nil then
            local cell = self.rowCells[self.select.index]
            if cell ~= nil then
                cell:SetUpgradeEffect(self.select.modelIndex, self.upgrade_effect.gameObject)
            else
                self:ResetUpgradeEffect()
            end
        end
    else
        self:ResetUpgradeEffect()
    end
end

function UIScienceTabView:ResetUpgradeEffect()
    if self.upgrade_effect ~= nil and self.upgrade_effect.gameObject ~= nil then
        self.upgrade_effect.gameObject.transform:SetParent(self.transform)
        self.upgrade_effect.gameObject:SetActive(false)
    end
end


return UIScienceTabView