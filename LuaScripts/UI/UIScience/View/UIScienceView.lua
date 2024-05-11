--- Created by shimin.
--- DateTime: 2020/7/21 15:29
--- 科技界面

local UIScienceView = BaseClass("UIScienceView", UIBaseView)
local base = UIBaseView

local ScienceCell = require "UI.UIScience.Component.ScienceCell"
local UIRowCell = require "UI.UIScience.Component.UIRowCell"

local back_btn_path = "fullTop/CloseBtn"
local title_text_path = "fullTop/imgTitle/Common_img_title/titleText"
local researching_go_path = "BgGo/MiddleBg/UITechnology_imgbg_study"
local researching_btn_path = "BgGo/MiddleBg/UITechnology_imgbg_study/speed_btn"
local researching_btn_name_path = "BgGo/MiddleBg/UITechnology_imgbg_study/speed_btn/speed_btn_text"
local researching_icon_path = "BgGo/MiddleBg/UITechnology_imgbg_study/icon_bg/icon"
local researching_name_path = "BgGo/MiddleBg/UITechnology_imgbg_study/slider_name"
local researching_slider_path = "BgGo/MiddleBg/UITechnology_imgbg_study/slider"
local researching_left_time_path = "BgGo/MiddleBg/UITechnology_imgbg_study/slider/slider_text"
local scroll_view_path = "BgGo/MiddleBg/ScrollView"
local close_all_btn_path = "fullTop/imgTitle/CloseAllBtn"

local SliderLength = 360
local ScreenCell = 4
local PositionYList = {Vector3.New(-200, 0, 0), Vector3.New(0, 0, 0), Vector3.New(200, 0, 0)}

--创建
function UIScienceView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIScienceView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIScienceView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.back_btn = self:AddComponent(UIButton, back_btn_path)
    self.back_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.isClose = true
        self.ctrl:CloseSelf()
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
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.close_all_btn = self:AddComponent(UIButton, close_all_btn_path)
    self.close_all_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.isClose = true
        GoToUtil.CloseAllWindows()
    end)
end

function UIScienceView:ComponentDestroy()
end


function UIScienceView:DataDefine()
    self.scienceCells = {} --存scienceId
    self.rowCells = {}
    self.bUuid = nil
    self.gotoTab = 0
    self.queue = nil
    self.tabLine = {}
    self.preAndNeed = {}
    
    
    self.researchingActive = nil
    self.laseTime = 0
    --self.lastCurTime = 0
    self.lastChangeTime = 0
    self.curSliderValue = nil
    self.curTimeValue = nil
    self.gotoId = nil
    self.gotoRow = nil
    self.reachingScienceList = {}
    self.SendFinishFlagList = {}--每次只能发一个
    self.upgrade_effect = nil
    self.upgradeScienceId = 0
    self.waitHelp = false
    self.isClose = false--正在关闭
end

function UIScienceView:DataDestroy()
    self.isClose = true
end

function UIScienceView:OnEnable()
    base.OnEnable(self)
end

function UIScienceView:OnDisable()
    base.OnDisable(self)
end

function UIScienceView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpgradeScienceDataSignal)
    self:AddUIListener(EventId.OnScienceQueueResearch, self.OnResearchingScienceInfoChange)
    self:AddUIListener(EventId.AddSpeedSuccess, self.OnResearchingScienceInfoChange)
    self:AddUIListener(EventId.GOTO_SCIENCE, self.GotoScienceSignal)
    self:AddUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
    self:AddUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
    self:AddUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
end


function UIScienceView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UPDATE_SCIENCE_DATA, self.UpgradeScienceDataSignal)
    self:RemoveUIListener(EventId.OnScienceQueueResearch, self.OnResearchingScienceInfoChange)
    self:RemoveUIListener(EventId.AddSpeedSuccess, self.OnResearchingScienceInfoChange)
    self:RemoveUIListener(EventId.GOTO_SCIENCE, self.GotoScienceSignal)
    self:RemoveUIListener(EventId.OnScienceQueueFinish, self.OnScienceQueueFinishSignal)
    self:RemoveUIListener(EventId.AllianceQueueHelpNew, self.AllianceQueueHelpNewSignal)
    self:RemoveUIListener(EventId.QUEUE_TIME_END, self.QueueTimeEndSignal)
end
function UIScienceView:ReInit()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Open_Science_Tree)
    local tab,goId, isNeedScroll,bUuid = self:GetUserData()
    self.bUuid = bUuid
    self.needScroll = isNeedScroll
    if tab ~= nil and tab ~= "" then
        self.gotoTab = tonumber(tab)
    end
    if goId ~= nil and goId ~= "" then
        self.gotoId = tonumber(goId)
    end
    self.isSendFinish = false
    self.tabLine = DataCenter.ScienceTemplateManager:GetLineListByTab(self.gotoTab)
    self:InitPreAndNeed()
    self:ShowResearching()
    self:SetTitle()
    self:ShowCells()
end

function UIScienceView:SetTitle()
    local template = DataCenter.ScienceTemplateManager:GetScienceTabTemplate(self.gotoTab)
    if template ~= nil then
        self.title_text:SetLocalText(template.name) 
    end
end

function UIScienceView:ShowResearching()
    self.upgradeScienceId = 0
    self.queue = DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.bUuid)
    if self.queue == nil or self.queue:GetQueueState() == NewQueueState.Free or self.queue:GetQueueState() == NewQueueState.Finish then
        self.queue = nil
        self:SetResearchingActive(false)
    else
        if self.queue.itemId ~= nil and self.queue.itemId ~= "" then
            local scienceId = tonumber(self.queue.itemId)
            self.upgradeScienceId = scienceId
            self:SetResearchingActive(true)
            local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
            if template~= nil then
                self.researching_name:SetLocalText(template.name) 
                local curLevel = DataCenter.ScienceManager:GetScienceLevel(scienceId)
                local maxLevel = DataCenter.ScienceManager:GetScienceMaxLevel(scienceId)
                if maxLevel > curLevel then
                    self.researching_icon:LoadSprite(string.format(LoadPath.ScienceIcons,template.icon))
                end
            end
            self:RefreshResearchingBtnName()
        end
    end
  
    self.reachingScienceList = {}
    local queueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
    for k, v in ipairs(queueList) do
        if v:GetQueueState() ~= NewQueueState.Free then
            local scienceId = tonumber(v.itemId)
            local template = DataCenter.ScienceManager:GetScienceTemplate(scienceId)
            if template ~= nil then
                self.reachingScienceList[scienceId] = v
            end
        end
    end
    self:RefreshUpgradeEffect()
end

function UIScienceView:ClearScroll()
    self.rowCells = {}
    self:ClearScienceCells()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIRowCell)--清循环列表gameObject
end

function UIScienceView:OnCreateCell(itemObj, index)
    itemObj.name = "row_"..index
    local item = self.scroll_view:AddComponent(UIRowCell, itemObj)
    local rowParam = {}
    rowParam.index = index
    rowParam.lastList = self.tabLine[index - 1]
    rowParam.curList = self.tabLine[index]
    rowParam.preAndNeed = self.preAndNeed
    item:ReInit(rowParam)
    self.rowCells[index] = item
    local data = self.tabLine[index]
    if data ~= nil then
        for k, v in pairs(data) do
            local param = {}
            param.scienceId = v
            param.index = index
            param.y = k
            param.bUuid = self.bUuid
            param.pos = self:GetCellLocalPosition(k)
            param.preAndNeed = self.preAndNeed
            self.scienceCells[param.scienceId] = param
            self:AddOneScienceCells(param, item)
        end
    end
end

function UIScienceView:ClearScienceCells()
    for k, v in pairs(self.scienceCells) do
        self:GameObjectDestroy(v.req)
    end
    self.scienceCells = {}
end

function UIScienceView:OnDeleteCell(itemObj, index)
    self.rowCells[index] = nil
    local removeIds = {}
    for k, v in pairs(self.scienceCells) do
        if v.index == index then
            self:GameObjectDestroy(v.req)
            table.insert(removeIds, k)
        end
    end
    if removeIds[1] ~= nil then
        for k,v in ipairs(removeIds) do
            self.scienceCells[v] = nil
            if v == self.upgradeScienceId then
                self:RefreshUpgradeEffect()
            end
        end
    end
    self.scroll_view:RemoveComponent(itemObj.name, UIRowCell)
end

function UIScienceView:ShowCells()
    self:ClearScroll()
    self:GetGotoScienceRow()
    local count = self:GetCellCount()
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        --保证在最中间
        local min = math.floor( ScreenCell/2)
        local max = count - ScreenCell + 1
        local showIndex = self.gotoRow
        if showIndex <= min then
            showIndex = 1
        elseif showIndex > max then
            showIndex = max
        else
            showIndex = showIndex - min
        end
        local startRow = min
        if self.needScroll then
            if showIndex > 3 then
                startRow = showIndex - 3 
            end
            self.scroll_view:RefillCells(startRow)
            self.scroll_view:ScrollToCell(showIndex, 2000)
        else
            self.scroll_view:RefillCells(showIndex)
            self.scroll_view:ScrollToCell(showIndex, 2000)
        end
    end
end

function UIScienceView:AddOneScienceCells(param, parentTransform)
    param.req = self:GameObjectInstantiateAsync(UIAssets.UIScienceCell, 
            function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                local go_tf = go.transform
                go:SetActive(true)
                go_tf:SetParent(parentTransform.transform)
                go_tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go_tf:Set_anchoredPosition(param.pos.x, param.pos.y, param.pos.z)
                local nameStr = tostring(param.scienceId)
                go.name = nameStr
                local cell = parentTransform:AddComponent(ScienceCell, nameStr)
                cell:ReInit(param)
                param.model = cell
                if self.upgradeScienceId == param.scienceId then
                    self:RefreshUpgradeEffect()
                end
                if self.gotoId ~= nil and self.gotoId == param.scienceId then
                    local pa = {}
                    pa.position = go.transform.position
                    pa.arrowType = ArrowType.Capacity
                    pa.positionType = PositionType.Screen
                    pa.isPanel = true
                    pa.isAutoClose = 3
                    DataCenter.ArrowManager:ShowArrow(pa)
                end
            end)
end

function UIScienceView:SetResearchingActive(value)
    if self.researchingActive ~= value then
        self.researchingActive = value
        self.researching_go:SetActive(value)
    end
end


function UIScienceView:UpgradeScienceDataSignal()
    self:ShowResearching()
    self:RefreshAllScienceCells()
end

function UIScienceView:RefreshAllScienceCells()
    for k, v in pairs(self.scienceCells) do
        if v.model ~= nil then
            v.model:Refresh()
        end
    end

    for k,v in pairs(self.rowCells) do
        v:Refresh()
    end
end

function UIScienceView:OnResearchingScienceInfoChange()
    self:ShowResearching()
    self:RefreshAllScienceCells()
end

function UIScienceView: QueueTimeEndSignal(data)
    local queueType = data
    if queueType == NewQueueType.Science then
        if not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceInfo) then
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
    end
end

function UIScienceView:Update()
    if not self.isClose then
        if table.count(self.reachingScienceList)>0 then
            self:UpdateLeftTime()
            for k, v in pairs(self.reachingScienceList) do
                if v:GetQueueState() == NewQueueState.Finish then
                    if (not UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIScienceInfo)) then
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

function UIScienceView:UpdateLeftTime(forceRefresh)
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
                --if TimeBarUtil.CheckIsNeedChangeBar(changeTime,self.queue.endTime - self.lastCurTime,maxTime,SliderLength) then
                if TimeBarUtil.CheckIsNeedChangeBar(changeTime,self.lastChangeTime,maxTime,SliderLength) then
                    --self.lastCurTime = curTime
                    self.lastChangeTime = changeTime
                    self.researching_slider:SetValue(tempValue)
                end
            end
        else
            self.laseTime = 0
            self.researching_slider:SetValue(0)
            self.researching_left_time:SetText("")
            --self:ShowResearching()
            return
        end
    end
end


function UIScienceView:GetGotoScienceRow()
    self.gotoRow = 1

    local researchingList = {}
    local tempQueueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
    for i, v in ipairs(tempQueueList) do
        if v and not string.IsNullOrEmpty(v.itemId) then
            table.insert(researchingList, tonumber(v.itemId))
        end
    end
    --有需要跳转的就找升级的没有就找第一个未解锁的
    if self.tabLine ~= nil then
        local isContinue = true
        for k,v in pairs(self.tabLine) do
            if isContinue then
                for k1,v1 in pairs(v) do
                    if isContinue then
                        if self.gotoId ~= nil and self.gotoId > 0 then
                            if v1 == self.gotoId then
                                self.gotoRow = k
                                isContinue = false
                            end
                        else
                            --跳转到第一个未满级的科技
                            local isMaxLv = self.ctrl:IsScienceLvMax(v1)
                            
                            if not isMaxLv and not table.hasvalue(researchingList, v1) then
                                self.gotoRow = k
                                isContinue = false
                            end
                            --跳转到第一个未解锁的科技
                            --local state = self.ctrl:IsUnLockScience(v1)
                            --if not state then
                            --    self.gotoRow = k
                            --    isContinue = false
                            --end
                        end
                    end
                end
            end
        end
        --self.gotoId = nil
    end
end

function UIScienceView:GotoScienceSignal(param)
    if param ~= nil then
        self.needScroll = false
        if param.scienceId ~= nil then
            local scienceTem = DataCenter.ScienceTemplateManager:GetScienceTemplate(param.scienceId)
            if scienceTem ~= nil then
                self.gotoTab = scienceTem.tab
                self.gotoId = temp
                self.tabLine = DataCenter.ScienceTemplateManager:GetLineListByTab(self.gotoTab)
                self:SetTitle()
                self:ShowCells()
            end
        elseif param.tab ~= nil then
            --为科技tab
            self.gotoTab = param.tab
            self.gotoId = nil
            self.tabLine = DataCenter.ScienceTemplateManager:GetLineListByTab(self.gotoTab)
            self:SetTitle()
            self:ShowCells()
        end
    end
end

function UIScienceView:RefreshResearchingBtnName()
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

function UIScienceView:OnResearchingBtnClick()
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

function UIScienceView:IsUseHeroFreeAddTime()
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

function UIScienceView:OnScienceQueueFinishSignal(queueUuid)
    self.SendFinishFlagList[tonumber(queueUuid)] = false
    self:OnResearchingScienceInfoChange()
end

function UIScienceView:AllianceQueueHelpNewSignal()
    self:RefreshResearchingBtnName()
end

function UIScienceView:GetCellCount() 
    local result = 0
    --取X最大值 ,有可能有空的
    if self.tabLine ~= nil then
        for k,v in pairs(self.tabLine) do
            if k > result then
                result = k
            end
        end
    end
    return result
end

function UIScienceView:GetCellLocalPosition(positionY)
    return PositionYList[positionY] or PositionYList[2]
end

function UIScienceView:GetScienceGuideBtn(scienceId)
    if self.gotoId ~= scienceId then
        self:GotoScienceSignal(scienceId)
    end
    if self.scienceCells[scienceId] ~= nil and self.scienceCells[scienceId].model ~= nil then
        return self.scienceCells[scienceId].model:GetGuideBtn()
    end
end

function UIScienceView:InitPreAndNeed()
    self.preAndNeed = {}
    local template = nil
    for k,v in pairs(self.tabLine) do
        for k1, v1 in pairs(v) do
            template = DataCenter.ScienceTemplateManager:GetScienceTemplate(v1, 1)
            if template ~= nil then
                local needScience = template.science_condition
                if needScience ~= nil then
                    for k2, v2 in ipairs(needScience) do
                        local scienceId = CommonUtil.GetScienceBaseType(v2)
                        local level = CommonUtil.GetScienceLv(v2)
                        local param = {}
                        if self.preAndNeed[scienceId] == nil then
                            self.preAndNeed[scienceId] = {}
                        end
                        table.insert(self.preAndNeed[scienceId], param)
                        param.needLevel = level
                        param.scienceId = v1
                        param.x = k
                        param.y = k1
                    end
                end
            end
        end
    end
end

function UIScienceView:RefreshUpgradeEffect()
    if self.upgradeScienceId ~= 0 then
        if self.upgrade_effect == nil then
            self.upgrade_effect = self:GameObjectInstantiateAsync(UIAssets.UIScienceUpgradeEffect,
                    function(request)
                        if request.isError then
                            return
                        end
                        self:RefreshUpgradeEffect()
                    end)
        elseif self.upgrade_effect.gameObject ~= nil then
            local cell = self.scienceCells[self.upgradeScienceId]
            if cell ~= nil and cell.model ~= nil then
                cell.model:SetUpgradeEffect(self.upgrade_effect.gameObject)
            else
                self:ResetUpgradeEffect()
            end
        end
    else
        self:ResetUpgradeEffect()
    end
end

function UIScienceView:ResetUpgradeEffect()
    if self.upgrade_effect ~= nil and self.upgrade_effect.gameObject ~= nil then
        self.upgrade_effect.gameObject.transform:SetParent(self.transform)
        self.upgrade_effect.gameObject:SetActive(false)
    end
end

return UIScienceView