--- Created by shimin.
--- DateTime: 2024/1/9 14:56
--- 联盟科技界面

local UIAllianceScienceView = BaseClass("UIAllianceScienceView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIAllianceScienceCell = require "UI.UIAlliance.UIAllianceScience.Component.UIAllianceScienceCell"
local UIAllianceScienceRowCell = require "UI.UIAlliance.UIAllianceScience.Component.UIAllianceScienceRowCell"
local UICommonToggleBtnTab = require "UI.UICommonTab.UICommonToggleBtnTab"

local back_btn_path = "fullTop/CloseBtn"
local title_text_path = "fullTop/imgTitle/Common_img_title/titleText"
local researching_go_path = "BgGo/MiddleBg/UITechnology_imgbg_study"
local researching_icon_path = "BgGo/MiddleBg/UITechnology_imgbg_study/icon_bg/icon"
local researching_name_path = "BgGo/MiddleBg/UITechnology_imgbg_study/slider_name"
local researching_slider_path = "BgGo/MiddleBg/UITechnology_imgbg_study/slider"
local researching_left_time_path = "BgGo/MiddleBg/UITechnology_imgbg_study/slider/slider_text"
local scroll_view_path = "BgGo/MiddleBg/ScrollView"
local toggle_btn_path = "BgGo/ToggleBtnGroup/ToggleBtn"
local detail_btn_path = "BgGo/detail_btn"
local gold_num_text_path = "fullTop/gold_btn/gold_num_text"

local SliderLength = 510
local ScreenCell = 4
local PositionYList = {Vector3.New(-200, 0, 0), Vector3.New(0, 0, 0), Vector3.New(200, 0, 0)}

local TabType =
{
    Develop = 1,
    Fight = 2,
    Rule = 3,
}

local TabTypeList =
{
    TabType.Develop, TabType.Fight, TabType.Rule
}

local TabNameType =
{
    [TabType.Develop] = 110716,
    [TabType.Fight] = 131005,
    [TabType.Rule] = 450054,
}


--创建
function UIAllianceScienceView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIAllianceScienceView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIAllianceScienceView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.back_btn = self:AddComponent(UIButton, back_btn_path)
    self.back_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.researching_go = self:AddComponent(UIBaseContainer, researching_go_path)
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
    self.toggle_btn = {}
    for i = 1, #TabTypeList, 1 do
        self.toggle_btn[i] = self:AddComponent(UICommonToggleBtnTab, toggle_btn_path .. i)
    end
    self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
    self.detail_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnDetailBtnClick()
    end)
    self.gold_num_text = self:AddComponent(UITextMeshProUGUIEx, gold_num_text_path)
end

function UIAllianceScienceView:ComponentDestroy()
end


function UIAllianceScienceView:DataDefine()
    self.tabList = {}
    self.tabIndex = 1
    self.on_tab_callback = function(tabType)
        self:OnTabClick(tabType)
    end
    
    self.scienceCells = {} --存scienceId
    self.rowCells = {}
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
    self.upgrade_effect = nil
    self.upgradeScience = nil
end

function UIAllianceScienceView:DataDestroy()
end

function UIAllianceScienceView:OnEnable()
    base.OnEnable(self)
end

function UIAllianceScienceView:OnDisable()
    base.OnDisable(self)
end

function UIAllianceScienceView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.AllianceTechnology, self.AllianceTechnologySignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.OnAlScienceRecommendChange, self.OnAlScienceRecommendChangeSignal)
end


function UIAllianceScienceView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.AllianceTechnology, self.AllianceTechnologySignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.OnAlScienceRecommendChange, self.OnAlScienceRecommendChangeSignal)
end
function UIAllianceScienceView:ReInit()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Open_Science_Tree)
    self.title_text:SetLocalText(GameDialogDefine.ALLIANCE_SCIENCE)
    self:GetTabList(TabType.Develop)
    for k, v in pairs(self.toggle_btn) do
        local tabParam = self.tabList[k]
        if tabParam == nil then
            v:SetActive(false)
        else
            v:ReInit(tabParam)
        end
    end
    self:Refresh()
    self:RefreshGold()
end

function UIAllianceScienceView:Refresh()
    self.tabLine = DataCenter.AllianceScienceDataManager:GetScienceRowList(TabTypeList[self.tabIndex])
    self:InitPreAndNeed()
    self:ShowCells()
    self:ShowResearching()
end

function UIAllianceScienceView:ShowResearching()
    self.upgradeScience = DataCenter.AllianceScienceDataManager:GetCurrentSearchScience()
    if self.upgradeScience == nil then
        self:SetResearchingActive(false)
    else
        self:SetResearchingActive(true)
        self.researching_name:SetLocalText(GetTableData(TableName.AlScienceTab, self.upgradeScience.scienceId,"name"))
        self.researching_icon:LoadSprite(string.format(LoadPath.ScienceIcons, GetTableData(TableName.AlScienceTab, self.upgradeScience.scienceId,"icon")))
    end
    self:RefreshUpgradeEffect()
end

function UIAllianceScienceView:ClearScroll()
    self.rowCells = {}
    self:ClearScienceCells()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIAllianceScienceRowCell)--清循环列表gameObject
end

function UIAllianceScienceView:OnCreateCell(itemObj, index)
    itemObj.name = "row_"..index
    local item = self.scroll_view:AddComponent(UIAllianceScienceRowCell, itemObj)
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
            param.pos = self:GetCellLocalPosition(k)
            param.preAndNeed = self.preAndNeed
            self.scienceCells[param.scienceId] = param
            self:AddOneScienceCells(param, item)
        end
    end
end

function UIAllianceScienceView:ClearScienceCells()
    for k, v in pairs(self.scienceCells) do
        self:GameObjectDestroy(v.req)
    end
    self.scienceCells = {}
end

function UIAllianceScienceView:OnDeleteCell(itemObj, index)
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
            if self.upgradeScience ~= nil and v == self.upgradeScience.scienceId then
                self:RefreshUpgradeEffect()
            end
        end
    end
    self.scroll_view:RemoveComponent(itemObj.name, UIAllianceScienceRowCell)
end

function UIAllianceScienceView:ShowCells()
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

function UIAllianceScienceView:AddOneScienceCells(param, parentTransform)
    param.req = self:GameObjectInstantiateAsync(UIAssets.UIAllianceScienceCell, 
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
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = parentTransform:AddComponent(UIAllianceScienceCell, nameStr)
                cell:ReInit(param)
                param.model = cell
                if self.upgradeScience ~= nil and self.upgradeScience.scienceId == param.scienceId then
                    self:RefreshUpgradeEffect()
                end
            end)
end

function UIAllianceScienceView:SetResearchingActive(value)
    if self.researchingActive ~= value then
        self.researchingActive = value
        self.researching_go:SetActive(value)
    end
end


function UIAllianceScienceView:RefreshAllScienceCells()
    for k, v in pairs(self.scienceCells) do
        if v.model ~= nil then
            v.model:Refresh()
        end
    end

    for k,v in pairs(self.rowCells) do
        v:Refresh()
    end
end

function UIAllianceScienceView:Update()
    if self.upgradeScience ~= nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.upgradeScience.finishTime - curTime
        local maxTime = self.upgradeScience.finishTime - self.upgradeScience.startTime
        if changeTime < maxTime and changeTime > 0 then
            local tempTimeSec = math.ceil(changeTime / 1000)
            if tempTimeSec ~= self.laseTime then
                self.laseTime = tempTimeSec
                local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
                self.researching_left_time:SetText(tempTimeValue)
            end

            if maxTime > 0 then
                local tempValue = 1 - changeTime / maxTime
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
            SFSNetwork.SendMessage(MsgDefines.AllScienceRefresh)
            self:ShowResearching()
            return
        end
    end
end


function UIAllianceScienceView:GetGotoScienceRow()
    self.gotoRow = 1

    --local researchingList = {}
    --local tempQueueList = DataCenter.QueueDataManager:GetAllQueueByType(NewQueueType.Science)
    --for i, v in ipairs(tempQueueList) do
    --    if v and not string.IsNullOrEmpty(v.itemId) then
    --        table.insert(researchingList, tonumber(v.itemId))
    --    end
    --end
    ----有需要跳转的就找升级的没有就找第一个未解锁的
    --if self.tabLine ~= nil then
    --    local isContinue = true
    --    for k,v in pairs(self.tabLine) do
    --        if isContinue then
    --            for k1,v1 in pairs(v) do
    --                if isContinue then
    --                    if self.gotoId ~= nil and self.gotoId > 0 then
    --                        if v1 == self.gotoId then
    --                            self.gotoRow = k
    --                            isContinue = false
    --                        end
    --                    else
    --                        --跳转到第一个未满级的科技
    --                        local isMaxLv = self.ctrl:IsScienceLvMax(v1)
    --                        
    --                        if not isMaxLv and not table.hasvalue(researchingList, v1) then
    --                            self.gotoRow = k
    --                            isContinue = false
    --                        end
    --                        --跳转到第一个未解锁的科技
    --                        --local state = self.ctrl:IsUnLockScience(v1)
    --                        --if not state then
    --                        --    self.gotoRow = k
    --                        --    isContinue = false
    --                        --end
    --                    end
    --                end
    --            end
    --        end
    --    end
    --    --self.gotoId = nil
    --end
end

function UIAllianceScienceView:GetCellCount() 
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

function UIAllianceScienceView:GetCellLocalPosition(positionY)
    return PositionYList[positionY] or PositionYList[2]
end

function UIAllianceScienceView:InitPreAndNeed()
    self.preAndNeed = {}
    local data = nil
    for k,v in pairs(self.tabLine) do
        for k1, v1 in pairs(v) do
            data = DataCenter.AllianceScienceDataManager:GetOneAllianceScienceById(v1)
            if data ~= nil then
                local needScience = data.science_condition
                if needScience ~= nil then
                    for k2, v2 in ipairs(needScience) do
                        local param = {}
                        if self.preAndNeed[v2.scienceId] == nil then
                            self.preAndNeed[v2.scienceId] = {}
                        end
                        table.insert(self.preAndNeed[v2.scienceId], param)
                        param.needLevel = v2.level
                        param.scienceId = v1
                        param.x = k
                        param.y = k1
                    end
                end
            end
        end
    end
end

function UIAllianceScienceView:RefreshUpgradeEffect()
    if self.upgradeScience ~= nil and self.upgradeScience.scienceId ~= 0 then
        if self.upgrade_effect == nil then
            self.upgrade_effect = self:GameObjectInstantiateAsync(UIAssets.UIScienceUpgradeEffect,
                    function(request)
                        if request.isError then
                            return
                        end
                        self:RefreshUpgradeEffect()
                    end)
        elseif self.upgrade_effect.gameObject ~= nil then
            local cell = self.scienceCells[self.upgradeScience.scienceId]
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

function UIAllianceScienceView:ResetUpgradeEffect()
    if self.upgrade_effect ~= nil and self.upgrade_effect.gameObject ~= nil then
        self.upgrade_effect.gameObject.transform:SetParent(self.transform)
        self.upgrade_effect.gameObject:SetActive(false)
    end
end


function UIAllianceScienceView:GetTabList(selectTabType)
    self.tabList = {}
    local index = 0
    for _, tabType in ipairs(TabTypeList) do
        index = index + 1
        local tabParam = {}
        tabParam.index = index
        if selectTabType == tabType then
            tabParam.select = true
            self.tabIndex = index
        else
            tabParam.select = false
        end
        tabParam.tabType = tabType
        tabParam.visible = true
        tabParam.callback = self.on_tab_callback
        tabParam.name = Localization:GetString(TabNameType[tabType])
        table.insert(self.tabList, tabParam)
    end
end

function UIAllianceScienceView:OnTabClick(tabIndex)
    if self.tabIndex == tabIndex then
        return
    end
    self:RefreshTabSelect(self.tabIndex, false)
    self.tabIndex = tabIndex
    self:RefreshTabSelect(self.tabIndex, true)
    self:Refresh()
end

function UIAllianceScienceView:RefreshTabSelect(tabType, isSelect)
    if self.toggle_btn[tabType] ~= nil then
        self.toggle_btn[tabType]:SetSelect(isSelect)
    end
end

function UIAllianceScienceView:AllianceTechnologySignal()
    self:RefreshAllScienceCells()
    self:ShowResearching()
end

function UIAllianceScienceView:OnDetailBtnClick()
    UIUtil.ShowIntro(Localization:GetString("390148"), Localization:GetString("302027"), Localization:GetString("391101"))
end

function UIAllianceScienceView:RefreshGold()
    self.gold_num_text:SetText(string.GetFormattedSeperatorNum(LuaEntry.Player.gold))
end

function UIAllianceScienceView:UpdateGoldSignal()
    self:RefreshGold()
end

function UIAllianceScienceView:OnAlScienceRecommendChangeSignal()
    for k, v in pairs(self.scienceCells) do
        if v.model ~= nil then
            v.model:RefreshCommend()
        end
    end
end

return UIAllianceScienceView