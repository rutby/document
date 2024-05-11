--- Created by shimin.
--- DateTime: 2023/11/7 10:36
--- 家具升级界面

local UIFurnitureUpgradeView = BaseClass("UIFurnitureUpgradeView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIFurnitureUpgradeFurniture = require "UI.UIFurnitureUpgrade.Component.UIFurnitureUpgradeFurniture"
local UIFurnitureUpgradeWork = require "UI.UIFurnitureUpgrade.Component.UIFurnitureUpgradeWork"
local UITaskInfoItem = require "UI.UIFurnitureUpgrade.Component.UITaskInfoItem"
local UICommonTabEx = require "UI.UICommonTab.UICommonTabEx"

local panel_btn_path = "panel"
local title_text_path = "Layout/BG/TitlePart/title_text"
local level_text_path = "Layout/BG/TitlePart/title_text/level_text"
local exp_slider_path = "Layout/BG/TitlePart/exp_slider"
local exp_slider_text_path = "Layout/BG/TitlePart/exp_slider/slider_text"
local upgrade_btn_path = "Layout/BG/TitlePart/upgrade_btn"
local upgrade_btn_text_path = "Layout/BG/TitlePart/upgrade_btn/btnText"
local upgrade_effect_go_path = "Layout/BG/TitlePart/upgrade_btn/upgrade_effect_go"
local furniture_go_path = "Layout/BG/furniture_go"
local work_go_path = "Layout/BG/work_go"
local tab_path = "Layout/TabList/Tab%s"
local tab_go_path = "Layout/TabList"
local tab2_red_path = "Layout/TabList/Tab2/Tab2Red"
local taskInfo_path = "Layout/TaskInfo"
local addBtnGo_path = "Layout/BG/work_go/CountBg/Add"
local this_path = ""
local info_btn_path = "Layout/BG/TitlePart/title_text/level_text/info_btn"
local exp_slider_btn_path = "Layout/BG/TitlePart/exp_slider/exp_slider_btn"

local EffectFlyTime = 0.5
local DestroyEffectTime = 2
local DestroyExpEffectTime = 0.6

--创建
function UIFurnitureUpgradeView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIFurnitureUpgradeView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIFurnitureUpgradeView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:Close(true)
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
    self.furniture_go = self:AddComponent(UIFurnitureUpgradeFurniture, furniture_go_path)
    self.work_go = self:AddComponent(UIFurnitureUpgradeWork, work_go_path)
    self.tabs = {}
    for _, tabType in pairs(UIFurnitureUpgradeTabType) do
        table.insert(self.tabs, self:AddComponent(UICommonTabEx, string.format(tab_path, tabType)))
    end
    self.upgrade_btn = self:AddComponent(UIButton, upgrade_btn_path)
    self.upgrade_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUpgradeBtnClick()
    end)
    self.exp_slider = self:AddComponent(UISlider, exp_slider_path)
    self.tab_go = self:AddComponent(UIBaseContainer, tab_go_path)
    self.tab2_red_go = self:AddComponent(UIBaseContainer, tab2_red_path)
    self.upgrade_effect_go = self:AddComponent(UIBaseContainer, upgrade_effect_go_path)
    self.upgrade_btn_text = self:AddComponent(UITextMeshProUGUIEx, upgrade_btn_text_path)
    self.exp_slider_text = self:AddComponent(UITextMeshProUGUIEx, exp_slider_text_path)

    self.taskInfo = self:AddComponent(UITaskInfoItem, taskInfo_path)
    self.addBtnGo = self:AddComponent(UIBaseContainer, addBtnGo_path)
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.info_btn = self:AddComponent(UIButton, info_btn_path)
    self.info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoBtnClick()
    end)
    self.exp_slider_btn = self:AddComponent(UIButton, exp_slider_btn_path)
    self.exp_slider_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnExpSliderBtnClick()
    end)
end

function UIFurnitureUpgradeView:ComponentDestroy()
   
end

function UIFurnitureUpgradeView:DataDefine()
    DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(nil)
    self.param = {}
    self.tabIndex = 1
    self.noRefreshSlider = false
    self.on_tab_callback = function(tabType) 
        self:OnTabClick(tabType)
    end
    self.tabList = {}
    self.trail_effect_callback = function()
        self:OnTrailEffectCallBack()
    end
    self.effectReqList = {}
    self.upgrade_btn_effect_timer_callback = function()
        self:OnUpgradeBtnEffectTimerCallBack()
    end
    self.arrow_timer_callback = function()
        self:OnArrowTimerCallBack()
    end
    self.enter = false
    self.enter_timer_callback = function()
        self:OnEnterTimerCallBack()
    end
    self.isBtnGray = false
    self.upgrade_exp_btn_effect_timer_callback = function() 
        self:OnUpgradeExpBtnEffectTimerCallBack()
    end
end

function UIFurnitureUpgradeView:DataDestroy()
    self:RemoveEnterTimer()
    self:RemoveArrowTimer()
    self:RemoveUpgradeBtnEffectTimer()
    self:RemoveUpgradeExpBtnEffectTimer()
    self.noRefreshSlider = false
    self.param = {}
    self.tabList = {}
    self.isBtnGray = false
end

function UIFurnitureUpgradeView:OnEnable()
    base.OnEnable(self)
    self:ReInit(self:GetUserData())
end

function UIFurnitureUpgradeView:OnDisable()
    base.OnDisable(self)
end

function UIFurnitureUpgradeView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:AddUIListener(EventId.RefreshFurniture, self.RefreshFurnitureSignal)
    self:AddUIListener(EventId.SetPanelVisible, self.SetPanelVisibleSignal)
    self:AddUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
    self:AddUIListener(EventId.VitaSetResidentWork, self.OnSetResidentWork)
    self:AddUIListener(EventId.VitaSetResidentWorkBatch, self.OnSetResidentWork)
    self:AddUIListener(EventId.FurnitureUpgrade, self.OnFurnitureUpgrade)
    self:AddUIListener(EventId.VitaDataUpdate, self.VitaDataUpdateSignal)
    self:AddUIListener(EventId.ChapterTask, self.RefreshTask)
    self:AddUIListener(EventId.MainTaskSuccess, self.RefreshTask)
    self:AddUIListener(EventId.DailyQuestLs, self.RefreshTask)
    self:AddUIListener(EventId.RefreshFurnitureProduct, self.RefreshFurnitureProductSignal)
end


function UIFurnitureUpgradeView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:RemoveUIListener(EventId.RefreshFurniture, self.RefreshFurnitureSignal)
    self:RemoveUIListener(EventId.SetPanelVisible, self.SetPanelVisibleSignal)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
    self:RemoveUIListener(EventId.VitaSetResidentWork, self.OnSetResidentWork)
    self:RemoveUIListener(EventId.VitaSetResidentWorkBatch, self.OnSetResidentWork)
    self:RemoveUIListener(EventId.FurnitureUpgrade, self.OnFurnitureUpgrade)
    self:RemoveUIListener(EventId.VitaDataUpdate, self.VitaDataUpdateSignal)
    self:RemoveUIListener(EventId.ChapterTask, self.RefreshTask)
    self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshTask)
    self:RemoveUIListener(EventId.DailyQuestLs, self.RefreshTask)
    self:RemoveUIListener(EventId.RefreshFurnitureProduct, self.RefreshFurnitureProductSignal)
end

function UIFurnitureUpgradeView:ReInit(param)
    self.param = param
    self:GetTabList(param.tabType or UIFurnitureUpgradeTabType.Furniture)
    self.noRefreshSlider = false
    self.enter = true
    self:MoveCamera()
    self:Refresh()
    for k, v in ipairs(self.tabs) do
        local tabParam = self.tabList[k]
        if tabParam == nil then
            v:SetActive(false)
        else
            v:ReInit(tabParam)
        end
    end
    if DataCenter.BuildManager:CanShowPower() then
        self.info_btn:SetActive(true)
    else
        self.info_btn:SetActive(false)
    end
    
    self:RefreshTask()
    self.enter = false
end

function UIFurnitureUpgradeView:Refresh()
    DataCenter.FurnitureObjectManager:CancelSelectObject()
    DataCenter.FurnitureObjectManager:DestroyOneFakeObj()
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
    if buildData ~= nil then
        self.title_text:SetText(Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), 
                buildData.itemId + buildData.level,"name")))
        self.level_text:SetLocalText(GameDialogDefine.LEVEL_NUMBER, buildData.level)
    end
    local tabType = self:GetCurTabType()
    if tabType == UIFurnitureUpgradeTabType.Furniture then
        self.work_go:SetActive(false)
        self.furniture_go:SetActive(true)
        self.furniture_go:ReInit(self.param, self.enter)
    elseif tabType == UIFurnitureUpgradeTabType.Work then
        self.furniture_go:SetActive(false)
        self.work_go:SetActive(true)
        self.work_go:SetData(self.param.buildUuid)
    end
    
    local showCount = 0
    for k, v in ipairs(self.tabs) do
        local param = self.tabList[k]
        if param ~= nil then
            if self:CanShowTab(param.tabType) then
                v:SetActive(true)
                showCount = showCount + 1
            else
                v:SetActive(false)
            end
            v:SetSelect(self.tabIndex == k)
        end
    end
    if showCount > 0 then
        self.tab_go:SetActive(true)
        self:RefreshTabRed()
    else
        self.tab_go:SetActive(false)
    end
    self:RefreshBuildExp()
end

function UIFurnitureUpgradeView:RefreshTabRed()
    self.tab2_red_go:SetActive(DataCenter.FurnitureManager:HasCanSetWorkFurnitureByBUuid(self.param.buildUuid))
end

function UIFurnitureUpgradeView:UpdateBuildDataSignal(uuid)
    if uuid == self.param.buildUuid then
        self:Refresh()
    end
end

function UIFurnitureUpgradeView:UpdateResourceSignal()
    local tabType = self:GetCurTabType()
    if tabType == UIFurnitureUpgradeTabType.Furniture then
        self.furniture_go:UpdateResourceSignal()
    end
end

function UIFurnitureUpgradeView:MoveCamera()
    self.buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
    if self.buildData ~= nil then
        local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.buildData.itemId)
        if buildTemplate ~= nil then
            DataCenter.FurnitureManager:SetEnterPanelCameraParam()
            local tabType = self:GetCurTabType()
            if tabType ~= UIFurnitureUpgradeTabType.Furniture then
                local pos = buildTemplate:GetPosition()
                local camParam = DataCenter.FurnitureManager:GetCameraParamByTiles(pos)
                if camParam ~= nil then
                    pos.z = pos.z + camParam.constDeltaPosY
                    CS.SceneManager.World:SetCameraMinHeight(camParam.zoom)
                    GoToUtil.GotoCityPos(pos, camParam.zoom, camParam.time)
                    self:AddEnterTimer(camParam.time * BuildAutoMoveEnterTime)
                end
            end
        end
    end
end

function UIFurnitureUpgradeView:QuitCamera()
    if self.param ~= nil then
        EventManager:GetInstance():Broadcast(EventId.HideFurniture, self.param.buildUuid)
        local enterParam = DataCenter.FurnitureManager:GetEnterPanelCameraParam()
        if enterParam.zoom ~= nil and (not enterParam.noQuit) then
            if CS.SceneManager.World ~= nil then
                DataCenter.CityCameraManager:UpdateCamera()--恢复正常限制
                local endFun = function()
                    DataCenter.CityLabelManager:SetNoResetHideBuildMark(false)
                end
                if enterParam.pos == nil then
                    CS.SceneManager.World:AutoZoom(enterParam.zoom, enterParam.quitTime, endFun)
                else
                    GoToUtil.GotoCityPos(enterParam.pos, enterParam.zoom, enterParam.quitTime, endFun)
                end
            end
            DataCenter.FurnitureManager:ClearEnterPanelCameraParam()
            DataCenter.CityLabelManager:SetNoResetHideBuildMark(true)
        end
        DataCenter.CityLabelManager:AddOneHideBuildMark(self.param.buildUuid)
    end
end

function UIFurnitureUpgradeView:RefreshFurnitureSignal()
    self:RefreshBuildExp()
    local tabType = self:GetCurTabType()
    if tabType == UIFurnitureUpgradeTabType.Furniture then
        self.furniture_go:RefreshFurnitureSignal()
    elseif tabType == UIFurnitureUpgradeTabType.Work then
        self.work_go:Refresh()
    end
end

function UIFurnitureUpgradeView:CanShowTab(tabType)
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
    if buildData ~= nil then
        if buildData:IsUpgrading() then
            return false
        end
        if tabType == UIFurnitureUpgradeTabType.Furniture then
            return true
        elseif tabType == UIFurnitureUpgradeTabType.Work then
            local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
            local needWorker = levelTemplate.need_worker > 0
            return needWorker
        end
    end
    
    return false
end

function UIFurnitureUpgradeView:OnTabClick(tabIndex)
    if self.tabIndex == tabIndex then
        return
    end
    self.tabIndex = tabIndex
    self:Refresh()
end

function UIFurnitureUpgradeView:CheckShowArrow()
    if self.param.arrowType ~= nil then
        local param = {}
        local showArrow = true
        if self.param.arrowType == UIFurnitureUpgradeArrowType.AddWork then
            param.position = self.work_go:GetAddBtnPosition()
        elseif self.param.arrowType == UIFurnitureUpgradeArrowType.UpgradeFurniture then
            param.position = self.furniture_go:GetUpgradeBtnPosition()
        elseif self.param.arrowType == UIFurnitureUpgradeArrowType.UpgradeBuild then
            if self.isBtnGray then
                showArrow = false
                self:AddOneUpgradeExpBtnEffect()
            else
                param.position = self:GetBuildUpgradeBtnPosition()
            end
        end
        if showArrow then
            param.positionType = PositionType.Screen
            param.isPanel = true
            param.isAutoClose = 3
            DataCenter.ArrowManager:ShowArrow(param)
        end
    end
end

--刷新建筑经验
function UIFurnitureUpgradeView:RefreshBuildExp()
    self.isBtnGray = false
    if not self.noRefreshSlider then
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
        if buildData ~= nil then
            local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
            if template ~= nil then
                local all = template.levelup_exp
                local cur = DataCenter.FurnitureManager:GetBuildCurExp(self.param.buildUuid)
                local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
                if desTemplate ~= nil then
                    if desTemplate:GetBuildMaxLevel() > buildData.level then
                        self.upgrade_btn:SetActive(true)
                        if cur >= all then
                            --显示升级按钮
                            self.upgrade_btn:SetActive(true)
                            self.upgrade_btn_text:SetLocalText(GameDialogDefine.UPGRADE)
                            CS.UIGray.SetGray(self.upgrade_btn.transform, false, true)
                            self.upgrade_effect_go:SetActive(false)
                            self.exp_slider:SetActive(false)
                        else
                            --显示经验进度条
                            self.isBtnGray = true
                            self.upgrade_btn:SetActive(false)
                            self.upgrade_effect_go:SetActive(false)
                            self.exp_slider:SetActive(true)
                            local lastExp = 0
                            if buildData.level > 1 then
                                local lastTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level - 1)
                                if lastTemplate ~= nil then
                                    lastExp = lastTemplate.levelup_exp
                                end
                            end
                            local value = (cur - lastExp) / (all - lastExp)
                            if value < 0 then
                                value = 0
                            elseif value > 1 then
                                value = 1
                            end
                            self.exp_slider:SetValue(value)
                            self.exp_slider_text:SetText(math.floor(value * 100) .. "%")
                        end
                    else
                        self.upgrade_btn:SetActive(true)
                        self.upgrade_btn_text:SetLocalText(GameDialogDefine.MAX)
                        CS.UIGray.SetGray(self.upgrade_btn.transform, true, false)
                        self.exp_slider:SetActive(false)
                        self.isBtnGray = true
                    end
                end
            end
        end
    end
end

function UIFurnitureUpgradeView:OnUpgradeBtnClick()
    --打开升级界面
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
    if buildData ~= nil then
        EventManager:GetInstance():Broadcast(EventId.SetPanelVisible, false)
        local param = {}
        param.buildId = buildData.itemId
        param.noMoveCamera = true
        param.questId = self.param.questId
        GoToUtil.GotoOpenBuildCreateWindow(UIWindowNames.UIBuildCreate, NormalPanelAnim, param)
    end
end

function UIFurnitureUpgradeView:GetBuildUpgradeBtnPosition()
    return self.upgrade_btn:GetPosition()
end

function UIFurnitureUpgradeView:SetPanelVisibleSignal(visible)
    if visible then
        self.gameObject:SetActive(true)
        self:PlayAnim(UIBuildAnimName.Show)
    else
        self.gameObject:SetActive(false)
    end
end

function UIFurnitureUpgradeView:RefreshItemsSignal()
    local tabType = self:GetCurTabType()
    if tabType == UIFurnitureUpgradeTabType.Furniture then
        self.furniture_go:RefreshItemsSignal()
    end
end

function UIFurnitureUpgradeView:OnSetResidentWork()
    self:RefreshTabRed()
end

function UIFurnitureUpgradeView:OnFurnitureUpgrade()
    self:RefreshTabRed()
end

function UIFurnitureUpgradeView:GetTabList(selectTabType)
    self.tabList = {}
    local index = 0
    for _, tabType in pairs(UIFurnitureUpgradeTabType) do
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
        tabParam.visible = self:CanShowTab(tabParam.tabType)
        tabParam.callback = self.on_tab_callback
        if tabType == UIFurnitureUpgradeTabType.Furniture then
            tabParam.name = Localization:GetString(GameDialogDefine.FURNITURE_NAME)
        elseif tabType == UIFurnitureUpgradeTabType.Work then
            tabParam.name = Localization:GetString(GameDialogDefine.WORK_NAME)
        end
        table.insert(self.tabList, tabParam)
    end
end

function UIFurnitureUpgradeView:GetCurTabType()
    if self.tabList[self.tabIndex] ~= nil then
        return self.tabList[self.tabIndex].tabType
    end
end

function UIFurnitureUpgradeView:VitaDataUpdateSignal()
    local tabType = self:GetCurTabType()
    if tabType == UIFurnitureUpgradeTabType.Furniture then
        self.furniture_go:VitaDataUpdateSignal()
    end
end

function UIFurnitureUpgradeView:OnTrailEffectCallBack()
    self.noRefreshSlider = false
    self:RefreshBuildExp()
end

function UIFurnitureUpgradeView:ShowEffect(startPos)
    local endPos = self.exp_slider:GetPosition()
    self.noRefreshSlider = true
    DataCenter.FurnitureEffectManager:ShowOneFurnitureTrailEffect(startPos, endPos, EffectFlyTime, self.trail_effect_callback)
end

function UIFurnitureUpgradeView:ShowUpgradeBtnEffect()
    local endPos = self.exp_slider:GetPosition()
    self.noRefreshSlider = true
    DataCenter.FurnitureEffectManager:ShowOneFurnitureTrailEffect(startPos, endPos, EffectFlyTime, self.trail_effect_callback)
end


function UIFurnitureUpgradeView:AddOneUpgradeBtnEffect()
    self:OnUpgradeBtnEffectTimerCallBack()
    local req = self:GameObjectInstantiateAsync(UIAssets.UIFurnitureUpgradeBtnEffect, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.upgrade_btn.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end)
    table.insert(self.effectReqList, req)
    self:AddUpgradeBtnEffectTimer()
end


function UIFurnitureUpgradeView:AddUpgradeBtnEffectTimer()
    if self.upgrade_btn_effect_timer == nil then
        self.upgrade_btn_effect_timer = TimerManager:GetInstance():GetTimer(DestroyEffectTime, self.upgrade_btn_effect_timer_callback, self, true, false, false)
        self.upgrade_btn_effect_timer:Start()
    end
end

function UIFurnitureUpgradeView:RemoveUpgradeBtnEffectTimer()
    if self.upgrade_btn_effect_timer ~= nil then
        self.upgrade_btn_effect_timer:Stop()
        self.upgrade_btn_effect_timer = nil
    end
end

function UIFurnitureUpgradeView:OnUpgradeBtnEffectTimerCallBack()
    self:RemoveUpgradeBtnEffectTimer()
    if self.effectReqList[1] ~= nil then
        local req = table.remove(self.effectReqList, 1)
        if req ~= nil then
            req:Destroy()
        end
    end
end

function UIFurnitureUpgradeView : RefreshTask()
    self.taskInfo:Refresh(self.param.questId)
end

function UIFurnitureUpgradeView:AddArrowTimer()
    if self.arrow_timer == nil then
        self.arrow_timer = TimerManager:GetInstance():GetTimer(PanelArrowTime, self.arrow_timer_callback, self, true, false, false)
        self.arrow_timer:Start()
    end
end

function UIFurnitureUpgradeView:RemoveArrowTimer()
    if self.arrow_timer ~= nil then
        self.arrow_timer:Stop()
        self.arrow_timer = nil
    end
end

function UIFurnitureUpgradeView:OnArrowTimerCallBack()
    self:RemoveArrowTimer()
    self:CheckShowArrow()
end

function UIFurnitureUpgradeView:PlayAnim(animName)
    self.anim:Play(animName, 0, 0)
end

function UIFurnitureUpgradeView:AddEnterTimer(time)
    if self.enter_timer == nil then
        self.enter_timer = TimerManager:GetInstance():GetTimer(time, self.enter_timer_callback, self, true, false, false)
        self.enter_timer:Start()
    end
end

function UIFurnitureUpgradeView:RemoveEnterTimer()
    if self.enter_timer ~= nil then
        self.enter_timer:Stop()
        self.enter_timer = nil
    end
end

function UIFurnitureUpgradeView:OnEnterTimerCallBack()
    self:RemoveEnterTimer()
    self:PlayAnim(UIBuildAnimName.Enter)
    self:AddArrowTimer()
end

function UIFurnitureUpgradeView:OnInfoBtnClick()
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
    if buildData ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildDetail, NormalBlurPanelAnim, buildData.itemId)
    end
end

function UIFurnitureUpgradeView:OnExpSliderBtnClick()
    --本次升级的家具显示特效（building_exp不为空并且当前可升级）
    local tabType = self:GetCurTabType()
    if tabType == UIFurnitureUpgradeTabType.Furniture then
        self.furniture_go:AddCanAddExpEffect()
    end
end


function UIFurnitureUpgradeView:AddOneUpgradeExpBtnEffect()
    local req = self:GameObjectInstantiateAsync(UIAssets.UIFurnitureUpgradeExpEffect, function(request)
        if request.isError then
            return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.exp_slider_btn.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
    end)
    table.insert(self.effectReqList, req)
    self:AddUpgradeExpBtnEffectTimer()
end


function UIFurnitureUpgradeView:AddUpgradeExpBtnEffectTimer()
    if self.upgrade_exp_btn_effect_timer == nil then
        self.upgrade_exp_btn_effect_timer = TimerManager:GetInstance():GetTimer(DestroyExpEffectTime, self.upgrade_exp_btn_effect_timer_callback, self, true, false, false)
        self.upgrade_exp_btn_effect_timer:Start()
    end
end

function UIFurnitureUpgradeView:RemoveUpgradeExpBtnEffectTimer()
    if self.upgrade_exp_btn_effect_timer ~= nil then
        self.upgrade_exp_btn_effect_timer:Stop()
        self.upgrade_exp_btn_effect_timer = nil
    end
end

function UIFurnitureUpgradeView:OnUpgradeExpBtnEffectTimerCallBack()
    self:RemoveUpgradeExpBtnEffectTimer()
    if self.effectReqList[1] ~= nil then
        local req = table.remove(self.effectReqList, 1)
        if req ~= nil then
            req:Destroy()
        end
    end

    --判断当前页签
    local tabType = self:GetCurTabType()
    if tabType == UIFurnitureUpgradeTabType.Furniture then
        local param = {}
        param.position = self.furniture_go:GetUpgradeBtnPosition()
        param.positionType = PositionType.Screen
        param.isPanel = true
        param.isAutoClose = 3
        DataCenter.ArrowManager:ShowArrow(param)
    end
end

function UIFurnitureUpgradeView:RefreshFurnitureProductSignal(fUuid)
    local tabType = self:GetCurTabType()
    if tabType == UIFurnitureUpgradeTabType.Furniture then
        self.furniture_go:RefreshFurnitureProductSignal(fUuid)
    end
end

function UIFurnitureUpgradeView:Close(isMovingCamera)
    if isMovingCamera == nil or isMovingCamera == true then
        self:QuitCamera()
    end
    self.ctrl:CloseSelf()
end

return UIFurnitureUpgradeView