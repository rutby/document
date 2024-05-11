--- Created by shimin
--- DateTime: 2023/11/23 22:41
--- 建筑建造界面

local UIBuildCreateView = BaseClass("UIBuildCreateView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIBuildCreateCell = require "UI.UIBuildCreate.Component.UIBuildCreateCell"
local UIDesCell = require "UI.UIBuildCreate.Component.UIDesCell"
local UITaskInfoItem = require "UI.UIFurnitureUpgrade.Component.UITaskInfoItem"
local UIGray = CS.UIGray

local close_btn_path = "panel"
local title_text_path = "bg/title_bg/title_text"
local attr_go_path = "bg/layout_go/attr_go"
local attr_name_text_path = "bg/layout_go/attr_go/attr_name_text"
local attr_empty_go_path = "bg/layout_go/attr_go/emptyBg"
local attr_empty_text_path = "bg/layout_go/attr_go/emptyBg/empty_text"
local need_name_text_path = "bg/layout_go/Tip/need_name_text"
local scroll_content_path = "bg/layout_go/Tip/scroll_view/Viewport/Content"
local upgrading_go_path = "bg/layout_go/upgrading_go"
local slider_path = "bg/layout_go/upgrading_go/slider"
local slider_text_path = "bg/layout_go/upgrading_go/slider/slider_text"
local time_text_path = "bg/layout_go/upgrading_go/slider/time_text"
local yellow_btn_path = "bg/btn_go/yellow_btn"
local yellow_btn_text_path = "bg/btn_go/yellow_btn/GameObject/yellow_btn_text"
local yellow_btn_cost_text_path = "bg/btn_go/yellow_btn/GameObject/ImmediatelyValue"
local yellow_btn_cost_icon_path = "bg/btn_go/yellow_btn/GameObject/icon_go/ImmediatelyIcon"
local blue_btn_path = "bg/btn_go/blue_btn"
local blue_btn_text_path = "bg/btn_go/blue_btn/blue_btn_text"
local blue_upgrade_name_text_path = "bg/btn_go/blue_btn/GameObject/upgrade_name_text"
local blue_cost_time_text_path = "bg/btn_go/blue_btn/GameObject/cost_time_text"
local blue_cost_icon_go_path = "bg/btn_go/blue_btn/GameObject/icon_go"
local cost_go_path = "bg/layout_go/Tip"
local taskInfo_path = "bg/TaskInfo"
local btnGo_path = "bg/btn_go"
local this_path = ""

local State =
{
    Create = 1,--建筑建造
    Upgrade = 2,--建筑升级
    Upgrading = 3--建筑正在升级
}

local SliderLength = 610

function UIBuildCreateView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIBuildCreateView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        if not self.param.noMoveCamera then
            self.moveCamera = true
        end
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.attr_go = self:AddComponent(UIBaseContainer, attr_go_path)
    self.attr_name_text = self:AddComponent(UITextMeshProUGUIEx, attr_name_text_path)
    self.need_name_text = self:AddComponent(UITextMeshProUGUIEx, need_name_text_path)
    self.upgrading_go = self:AddComponent(UIBaseContainer, upgrading_go_path)
    self.scroll_content = self:AddComponent(UIBaseContainer, scroll_content_path)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider_text = self:AddComponent(UITextMeshProUGUIEx, slider_text_path)
    self.time_text = self:AddComponent(UITextMeshProUGUIEx, time_text_path)
    self.yellow_btn = self:AddComponent(UIButton, yellow_btn_path)
    self.yellow_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnYellowBtnClick()
    end)
    self.yellow_btn_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_text_path)
    self.yellow_btn_cost_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_cost_text_path)
    self.yellow_btn_cost_icon = self:AddComponent(UIImage, yellow_btn_cost_icon_path)
    self.blue_btn = self:AddComponent(UIButton, blue_btn_path)
    self.blue_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBlueBtnClick()
    end)
    self.blue_btn_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_text_path)
    self.blue_upgrade_name_text = self:AddComponent(UITextMeshProUGUIEx, blue_upgrade_name_text_path)
    self.blue_cost_time_text = self:AddComponent(UITextMeshProUGUIEx, blue_cost_time_text_path)
    self.attr_empty_go = self:AddComponent(UIBaseContainer, attr_empty_go_path)
    self.attr_empty_text = self:AddComponent(UITextMeshProUGUIEx, attr_empty_text_path)
    self.blue_cost_icon_go = self:AddComponent(UIBaseContainer, blue_cost_icon_go_path)
    self.cost_go = self:AddComponent(UIBaseContainer, cost_go_path)

    self.taskInfo = self:AddComponent(UITaskInfoItem, taskInfo_path)
    self.btnGo = self:AddComponent(UIBaseContainer, btnGo_path)
    self.anim = self:AddComponent(UIAnimator, this_path)
end

function UIBuildCreateView:ComponentDestroy()
end

function UIBuildCreateView:DataDefine()
    DataCenter.FurnitureManager:SetEnterPanelCameraNoQuitParam(nil)
    self.list = {}
    self.param = {}
    self.state = State.Upgrade
    self.desList = {}
    self.desCells = {}
    self.needList = {}
    self.needCells = {}
    self.lackList = {}
    self.endTime = 0
    self.startTime = 0
    self.lastChangeImageDeltaTime = 0
    self.lastChangeTextDeltaTime = 0
    self.showBtnTime = 0
    self.isFree = false
    self.spendGold = 0
    self.moveCamera = false
    self.enter_timer_callback = function()
        self:OnEnterTimerCallBack()
    end
    self.hasShowArrow = false
    self.isShowSecondMessage = false--是否显示二次确认框
end

function UIBuildCreateView:DataDestroy()
    if self.isShowSecondMessage then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UISellConfirm)
        self.isShowSecondMessage = false
    end
    self:RemoveEnterTimer()
    EventManager:GetInstance():Broadcast(EventId.SetPanelVisible, true)
    self:QuitCamera()
    self.list = {}
    self.param = {}
    self.state = State.Upgrade
    self.desList = {}
    self.desCells = {}
    self.needList = {}
    self.needCells = {}
    self.lackList = {}
    self.endTime = 0
    self.startTime = 0
    self.lastChangeImageDeltaTime = 0
    self.lastChangeTextDeltaTime = 0
    self.showBtnTime = 0
    self.isFree = false
    self.spendGold = 0
    if self.hasShowArrow then
        DataCenter.ArrowManager:RemoveArrow()
        self.hasShowArrow = false
    end
end

function UIBuildCreateView:OnDestroy()
    self:ClearArrow()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBuildCreateView:OnEnable()
    base.OnEnable(self)
end

function UIBuildCreateView:OnDisable()
    base.OnDisable(self)
end

function UIBuildCreateView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:AddUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.ChapterTask, self.RefreshTask)
    self:AddUIListener(EventId.MainTaskSuccess, self.RefreshTask)
    self:AddUIListener(EventId.DailyQuestLs, self.RefreshTask)
end

function UIBuildCreateView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.UpdateBuildDataSignal)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemsSignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.ChapterTask, self.RefreshTask)
    self:RemoveUIListener(EventId.MainTaskSuccess, self.RefreshTask)
    self:RemoveUIListener(EventId.DailyQuestLs, self.RefreshTask)
end

function UIBuildCreateView:ReInit()
    self.param = self:GetUserData()
    self.need_name_text:SetLocalText(GameDialogDefine.NEED)
    self.slider_text:SetLocalText(GameDialogDefine.BUILD_UPGRADING)
    self:Refresh()
    self:MoveCamera()
    self:RefreshTask()
    self:ShowIncreaseSpeedBtnArrow()
end

function UIBuildCreateView:Refresh()
    self.moveCamera = false
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
    if buildData == nil then
        self.state = State.Create
    elseif buildData:IsUpgrading() then
        self.state = State.Upgrading
    elseif buildData.level == 0 then
        self.state = State.Create
    else
        self.state = State.Upgrade
    end

    if self.state == State.Create then
        self.title_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.param.buildId,"name"))
        self.cost_go:SetActive(true)
        self:ShowNeedCells()
        self.upgrading_go:SetActive(false)
        self.endTime = 0
        self.startTime = 0
    elseif self.state == State.Upgrade then
        self.title_text:SetText(Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(),
                self.param.buildId + buildData.level,"name")) .. " "
                .. Localization:GetString(GameDialogDefine.LEVEL_NUMBER, buildData.level))
        self.cost_go:SetActive(true)
        self:ShowNeedCells()
        self.upgrading_go:SetActive(false)
        self.endTime = 0
        self.startTime = 0
    elseif self.state == State.Upgrading then
        self.title_text:SetText(Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(),
                self.param.buildId + buildData.level,"name")) .. " "
                .. Localization:GetString(GameDialogDefine.LEVEL_NUMBER, buildData.level))
        self.cost_go:SetActive(false)
        self.upgrading_go:SetActive(true)
        self.endTime = buildData.updateTime
        self.startTime = buildData.startTime
        self:UpdateSlider()
    end
    self:ShowDesCells()
    self:ShowBtn()
end

function UIBuildCreateView:OnBlueBtnClick()
    if self.state == State.Upgrading then
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
        if buildData ~= nil then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed,{anim = true,isBlur = true}, ItemSpdMenu.ItemSpdMenu_City, buildData.uuid)
        end
    else
        if self.lackList[1] ~= nil then
            local lackTab = {}
            for k, v in ipairs(self.lackList) do
                if v.cellType == CommonCostNeedType.Build then
                    GoToUtil.InMoveCameraGotoBuild(v.buildId)
                    return
                elseif v.cellType == CommonCostNeedType.Resource then
                    local param = {}
                    param.type = ResLackType.Res
                    param.id = v.resourceType
                    param.targetNum = v.count
                    table.insert(lackTab,param)
                elseif v.cellType == CommonCostNeedType.Goods then
                    local param = {}
                    param.type = ResLackType.Item
                    param.id = v.itemId
                    param.targetNum = v.count
                    table.insert(lackTab,param)
                elseif v.cellType == CommonCostNeedType.Chapter then
                    self.moveCamera = true
                    GoToUtil.CloseAllWindows()
                    UIManager:GetInstance():OpenWindow(UIWindowNames.UITaskMain, HideBlurPanelAnim, TaskType.Chapter)
                    return
                end
            end
            GoToResLack.GoToItemResLackList(lackTab)

        else
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
            if buildData == nil then
                local param = {}
                param.robotUuid = 0
                param.buildingId = self.param.buildId
                param.itemUuid = ""
                local needPathTime = 0
                param.pathTime = needPathTime
                param.targetServerId = LuaEntry.Player:GetCurServerId()
                if DataCenter.BuildQueueManager:IsCanUpgrade(self.param.buildId, 0) then
                    local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, 0)
                    if curLevelTemplate.no_queue == BuildNoQueue.No then
                        local useTime = curLevelTemplate:GetBuildTime()
                        if useTime > 0 then
                            local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
                            local robot = DataCenter.BuildQueueManager:GetFreeQueue(buildTemplate:IsSeasonBuild())
                            if robot ~= nil then
                                param.robotUuid = robot.uuid
                            end
                        end
                    end
                    SFSNetwork.SendMessage(MsgDefines.FreeBuildingPlaceNew, param)
                    self.moveCamera = true
                    GoToUtil.CloseAllWindows()
                else
                    local buildQueueParam = {}
                    buildQueueParam.enterType = UIBuildQueueEnterType.Build
                    buildQueueParam.messageParam = param
                    buildQueueParam.buildId = self.param.buildId
                    GoToUtil.GotoOpenBuildQueueWindow(buildQueueParam)
                end
            else
                if self.spendGold == 0 and self.isFree then
                    --免费
                    local param = {}
                    param.uuid = tostring(buildData.uuid)
                    param.gold = BuildUpgradeUseGoldType.Free
                    param.upLevel = buildData.level + 1
                    param.clientParam = ""
                    param.truckId = 0
                    param.pathTime = 0
                    param.robotUuid =0
                    SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew,param)
                    local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.BUILD_TIME_REDUCE)
                    local name
                    if heroData then
                        local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
                        name = Localization:GetString(heroConfig["name"])
                    else
                        name = Localization:GetString("100315")
                    end
                    local freeTime = Mathf.Ceil(BuildingUtils.GetDroneFreeTimeForBuild(buildData.itemId)/60)
                    local time
                    if self.showBtnTime then
                        if self.showBtnTime < (BuildingUtils.GetDroneFreeTimeForBuild(buildData.itemId) * 1000) then
                            if self.showBtnTime > 60000 then
                                local min = Mathf.Floor(self.showBtnTime/60000)
                                time = min..Localization:GetString("100165")
                            else
                                time = Localization:GetString("130076",math.ceil(self.showBtnTime / 1000))
                            end
                        else
                            time = freeTime..Localization:GetString("100165")
                        end
                    else
                        time = freeTime..Localization:GetString("100165")
                    end
                    local str = Localization:GetString("110201",name,time,Localization:GetString("310148"))
                    TimerManager:GetInstance():DelayInvoke(function()
                        UIUtil.ShowTips(str,nil,nil,heroData)
                    end, 1)
                    self.moveCamera = true
                    GoToUtil.CloseAllWindows()
                else
                    local needPathTime = 0
                    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, 0)
                    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
                    if levelTemplate.scan == BuildScanAnim.Play then
                        --needPathTime = DataCenter.BuildManager:GetPathTimeFromDroneToBuildTarget(buildData.pointId, buildTemplate.tiles)
                    end
                    local nextLevel = buildData.level + 1
                    local param = {}
                    param.uuid = tostring(buildData.uuid)
                    param.gold = BuildUpgradeUseGoldType.No
                    param.upLevel = nextLevel
                    param.clientParam = ""
                    param.truckId = 0
                    param.pathTime = needPathTime
                    param.robotUuid = 0
                    if DataCenter.BuildQueueManager:IsCanUpgrade(buildData.itemId, buildData.level) then
                        local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
                        if curLevelTemplate.no_queue == BuildNoQueue.No then
                            local useTime = curLevelTemplate:GetBuildTime() + needPathTime
                            if useTime > 0 then
                                local robot = DataCenter.BuildQueueManager:GetFreeQueue(buildTemplate:IsSeasonBuild())
                                if robot~=nil then
                                    param.robotUuid = robot.uuid
                                end
                            end
                        end
                        if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN and self:CheckShowBrokenTips(nextLevel) then
                            UIUtil.ShowMessage(Localization:GetString("110165", nextLevel), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                                SoundUtil.PlayEffect(SoundAssets.Music_Effect_Build_Upgrade)
                                SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew,param)
                                self.moveCamera = true
                                GoToUtil.CloseAllWindows()
                            end, function()
                            end)
                        else
                            self.isClick = true
                            SoundUtil.PlayEffect(SoundAssets.Music_Effect_Build_Upgrade)
                            SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew,param)
                            self.moveCamera = true
                            GoToUtil.CloseAllWindows()
                        end
                    else
                        local buildQueueParam = {}
                        buildQueueParam.enterType = UIBuildQueueEnterType.Upgrade
                        buildQueueParam.uuid = self.param.buildUuid
                        buildQueueParam.messageParam = param
                        buildQueueParam.buildId = buildData.itemId
                        GoToUtil.GotoOpenBuildQueueWindow(buildQueueParam)
                    end
                end
            end
        end
    end
end


function UIBuildCreateView:MoveCamera()
    if self.param~=nil and self.param.noMoveCamera == true then
        self:PlayAnim(UIBuildAnimName.Enter)
        return
    end
    local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
    if buildTemplate ~= nil then
        DataCenter.FurnitureManager:SetEnterPanelCameraParam()
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


function UIBuildCreateView:QuitCamera()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIBuildOpenFire) or UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIFurnitureUpgrade) or (not self.moveCamera) then
        return
    end
    local enterParam = DataCenter.FurnitureManager:GetEnterPanelCameraParam()
    if enterParam.zoom ~= nil and (not enterParam.noQuit) then
        if CS.SceneManager.World ~= nil then
            DataCenter.CityCameraManager:UpdateCamera()--恢复正常限制
            if enterParam.pos == nil then
                CS.SceneManager.World:AutoZoom(enterParam.zoom, enterParam.quitTime)
            else
                GoToUtil.GotoCityPos(enterParam.pos, enterParam.zoom, enterParam.quitTime)
            end
        end
        DataCenter.FurnitureManager:ClearEnterPanelCameraParam()
    end
end


function UIBuildCreateView:ShowDesCells()
    self:GetDesList()
    local count = #self.desList
    if count > 0 then
        self.attr_name_text:SetLocalText(GameDialogDefine.HERO_PLUGIN_ATTRIBUTE_UPGRADE)
        self.attr_empty_go:SetActive(false)
        self.attr_go:SetActive(true)
        for k, v in ipairs(self.desList) do
            if self.desCells[k] == nil then
                local param = {}
                self.desCells[k] = param
                param.visible = true
                param.param = v
                param.req = self:GameObjectInstantiateAsync(UIAssets.UIBuildCreateDesCell, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject
                    go:SetActive(true)
                    go.transform:SetParent(self.attr_go.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    go.transform:SetAsLastSibling()
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local model = self.attr_go:AddComponent(UIDesCell, nameStr)
                    model:ReInit(param)
                    param.model = model
                end)
            else
                self.desCells[k].visible = true
                self.desCells[k].param = v
                if self.desCells[k].model ~= nil then
                    self.desCells[k].model:Refresh()
                end
            end
        end
    else
        if self.state == State.Create then
            self.attr_go:SetActive(true)
            self.attr_empty_go:SetActive(true)
            self.attr_name_text:SetLocalText(GameDialogDefine.BUILD_INFO)
            self.attr_empty_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.param.buildId,"description"))
        else
            self.attr_go:SetActive(false)
            self.attr_empty_go:SetActive(false)
        end
    end
    local cellCount = #self.desCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.desCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIBuildCreateView:GetDesList()
    self.desList = {}
    if self.state ~= State.Create then
        local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
        if desTemplate ~= nil then
            local curLevelTemplate = nil
            local nextLevelTemplate = nil
            local maxCount = #desTemplate.effect_local
            local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
            if buildData ~= nil then
                curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, buildData.level)
                if maxCount > 0 then
                    if curLevelTemplate.local_num[maxCount] == nil then
                        maxCount = #curLevelTemplate.local_num
                    end
                end
                nextLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, buildData.level + 1)
                if maxCount > 0 then
                    if nextLevelTemplate.local_num[maxCount] == nil then
                        maxCount = #nextLevelTemplate.local_num
                    end
                end
            end

            if maxCount > 0 then
                for i = 1, maxCount, 1 do
                    local showParam = desTemplate:GetShowLocalEffect(i)
                    if showParam ~= nil then
                        local param = {}
                        param.name = Localization:GetString(showParam[1])
                        local type = showParam[2]
                        local needAdd = true
                        if type == EffectLocalType.Dialog then
                            if nextLevelTemplate == nil then
                                if curLevelTemplate ~= nil then
                                    local val = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(curLevelTemplate.local_num[i], type)
                                    if val == nil or val == "" then
                                        needAdd = false
                                    end
                                    param.curValue = val
                                end
                            else
                                local val = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(nextLevelTemplate.local_num[i], type)
                                if val == nil or val == "" then
                                    needAdd = false
                                end
                                if curLevelTemplate == nil then
                                    param.curValue = val
                                else
                                    param.addValue = val
                                end
                            end
                        else
                            local cur = 0
                            if curLevelTemplate ~= nil then
                                cur = tonumber(curLevelTemplate.local_num[i]) or 0
                                if cur ~= 0 then
                                    param.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(tonumber(curLevelTemplate.local_num[i]) or 0, type)
                                else
                                    param.curValue = cur
                                end
                            end
                            if nextLevelTemplate ~= nil then
                                if nextLevelTemplate.local_num[i] ~= nil then
                                    local add = tonumber(nextLevelTemplate.local_num[i]) - cur
                                    if curLevelTemplate == nil then
                                        if add > 0 then
                                            param.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(add, type)
                                        elseif add < 0 then
                                            param.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(-add, type)
                                        end
                                    else
                                        if add > 0 then
                                            param.addValue = " + " .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(add, type)
                                        elseif add < 0 then
                                            param.addValue = " - " .. DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(-add, type)
                                        end
                                    end
                                end
                            end
                        end
                        if needAdd then
                            if param.curValue ~= param.addValue then
                                table.insert(self.desList, param)
                            end
                        end
                    end
                end
            end

            if DataCenter.BuildManager:CanShowPower() then
                local param = {}
                param.name = Localization:GetString(GameDialogDefine.POWER)
                local cur = 0
                local add = 0
                if curLevelTemplate ~= nil then
                    cur = curLevelTemplate.power
                    param.curValue = cur
                end
                if nextLevelTemplate ~= nil then
                    add = nextLevelTemplate.power - cur
                    if curLevelTemplate == nil then
                        param.curValue = add
                    else
                        param.addValue = " + " .. add
                    end

                end
                if add ~= 0 then
                    table.insert(self.desList, param)
                end
            end
        end
    end
end

function UIBuildCreateView:ShowNeedCells()
    self:GetNeedList()
    local count = #self.needList
    for k,v in ipairs(self.needList) do
        if self.needCells[k] == nil then
            local param = {}
            self.needCells[k] = param
            param.visible = true
            param.param = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.UIBuildCreateCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.scroll_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.scroll_content:AddComponent(UIBuildCreateCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.needCells[k].visible = true
            self.needCells[k].param = v
            if self.needCells[k].model ~= nil then
                self.needCells[k].model:Refresh()
            end
        end
    end
    local cellCount = #self.needCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.needCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIBuildCreateView:GetNeedList()
    self.needList = {}
    self.lackList = {}
    
    local level = 0
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
    if buildData ~= nil then
        level = buildData.level
    end
    local curCount = 0
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, level)
    if levelTemplate ~= nil then
        local need_chapter = levelTemplate.need_chapter or 0
        if need_chapter > 0 and not DataCenter.ChapterTaskManager:IsReachChapter(need_chapter) then
            curCount = curCount + 1
            local param = {}
            param.cellType = CommonCostNeedType.Chapter
            param.chapterId = need_chapter
            param.isRed = true
            param.showLine = curCount % 2 == 0
            table.insert(self.lackList, param)
            table.insert(self.needList, param)
        end
        
        local list = levelTemplate:GetPreBuild()
        if list ~= nil and list[1] ~= nil then
            for _, v in ipairs(list) do
                if not DataCenter.BuildManager:IsExistBuildByTypeLv(v[1], v[2]) then
                    curCount = curCount + 1
                    local param = {}
                    param.cellType = CommonCostNeedType.Build
                    param.buildId = v[1]
                    param.level = v[2]
                    param.isRed = true
                    param.showLine = curCount % 2 == 0
                    table.insert(self.lackList, param)
                    table.insert(self.needList, param)
                end
            end
        end
        
        list = levelTemplate:GetNeedResource()
        if list ~= nil and list[1] ~= nil then
            for _, v in ipairs(list) do
                curCount = curCount + 1
                local param = {}
                param.cellType = CommonCostNeedType.Resource
                param.resourceType = v.resourceType
                param.count = v.count
                param.own = LuaEntry.Resource:GetCntByResType(v.resourceType)
                if param.own < param.count then
                    param.isRed = true
                    table.insert(self.lackList, param)
                else
                    param.isRed = false
                end
                param.showLine = curCount % 2 == 0
                table.insert(self.needList, param)
            end
        end

        list = levelTemplate:GetNeedItem()
        if list ~= nil and list[1] ~= nil then
            for _, v in ipairs(list) do
                curCount = curCount + 1
                local param = {}
                param.cellType = CommonCostNeedType.Goods
                param.itemId = v[1]
                param.count = v[2]
                param.own = DataCenter.ItemData:GetItemCount(param.itemId)
                if param.own < param.count then
                    param.isRed = true
                    table.insert(self.lackList, param)
                else
                    param.isRed = false
                end
                param.showLine = curCount % 2 == 0
                table.insert(self.needList, param)
            end
        end
    end
end


function UIBuildCreateView:Update()
    if self.endTime > 0 then
        self:UpdateSlider()
    end
end

function UIBuildCreateView:UpdateSlider()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime = self.endTime - curTime
    local maxTime = 0
    if deltaTime > 0 then
        maxTime = self.endTime - self.startTime
        if TimeBarUtil.CheckIsNeedChangeBar(deltaTime, self.lastChangeImageDeltaTime, maxTime, SliderLength) then
            self.lastChangeImageDeltaTime = deltaTime
            local tempValue = 1 - deltaTime / maxTime
            self.slider:SetValue(tempValue)
        end

        if TimeBarUtil.CheckIsNeedChangeText(deltaTime, self.lastChangeTextDeltaTime) then
            self.lastChangeTextDeltaTime = deltaTime
            self.time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
            local freeTime = BuildingUtils.GetDroneFreeTimeForBuild(self.param.buildId) * 1000
            local costGold = CommonUtil.GetTimeDiamondCost(math.floor((deltaTime - freeTime) / 1000))
            if costGold ~= self.spendGold then
                self.spendGold = costGold
                self.yellow_btn_cost_text:SetText(string.GetFormattedSeperatorNum(self.spendGold))
                self:RefreshGoldColor()
            end
        end
    else
        self.endTime = 0
        self.moveCamera = true
        DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(nil)
        GoToUtil.CloseAllWindows()
    end
end

function UIBuildCreateView:ShowBtn()
    if self.state == State.Upgrading then
        if DataCenter.BuildManager:CanShowSpeed() then
            self.blue_upgrade_name_text:SetActive(false)
            self.blue_cost_time_text:SetActive(false)
            self.blue_cost_icon_go:SetActive(false)
            self.blue_btn_text:SetActive(true)
            self.blue_btn_text:SetLocalText(GameDialogDefine.ADD_SPEED)
            self.blue_btn:SetActive(true)
            UIGray.SetGray(self.blue_btn.transform, false, true)
        else
            self.blue_btn:SetActive(false)
        end
        self.yellow_btn:SetActive(true)
        UIGray.SetGray(self.yellow_btn.transform, false, true)
        self.yellow_btn_text:SetLocalText(GameDialogDefine.IMMEDIATELY_ADD_SPEED)
    elseif self.state == State.Create then
        self.yellow_btn:SetActive(false)
        self.blue_upgrade_name_text:SetActive(false)
        self.blue_cost_time_text:SetActive(false)
        self.blue_cost_icon_go:SetActive(false)
        self.blue_btn_text:SetActive(true)
        self.blue_btn_text:SetLocalText(GameDialogDefine.BUILD)
        self.blue_btn:SetActive(true)
        local showGray = false
        if self.lackList[1] ~= nil then
            for k, v in ipairs(self.lackList) do
                if v.cellType == CommonCostNeedType.Build or v.cellType == CommonCostNeedType.Chapter then
                    showGray = true
                    break
                end
            end
        end
        UIGray.SetGray(self.blue_btn.transform, showGray, not showGray)
    else
        self.blue_btn:SetActive(true)
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
        if buildData ~= nil then
            local buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildData.itemId)
            local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
            if curLevelTemplate ~= nil and buildTemplate ~= nil then
                local nTime = curLevelTemplate:GetBuildTime()
                local needPathTime = 0
                if curLevelTemplate.scan == BuildScanAnim.Play then
                    --needPathTime = DataCenter.BuildManager:GetPathTimeFromDroneToBuildTarget(buildData.pointId, buildTemplate.tiles)
                end
                self.showBtnTime = nTime + needPathTime
                local needTime = nTime + needPathTime
                local freeTime = BuildingUtils.GetDroneFreeTimeForBuild(buildData.itemId) * 1000
                local haveFreeTime = freeTime > 0 and freeTime >= nTime
                self.isFree = haveFreeTime and self.lackList[1] == nil
                if self.isFree then
                    self.spendGold = 0
                    self.yellow_btn:SetActive(false)
                    self.blue_upgrade_name_text:SetActive(false)
                    self.blue_cost_time_text:SetActive(false)
                    self.blue_cost_icon_go:SetActive(false)
                    self.blue_btn_text:SetActive(true)
                    self.blue_btn_text:SetLocalText(GameDialogDefine.FREE)
                    UIGray.SetGray(self.blue_btn.transform, false, true)
                    --self.free_rect:SetActive(true)
                    --local hero = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.BUILD_TIME_REDUCE)
                    --if hero then
                    --    if LuaEntry.DataConfig:CheckSwitch("ABtest_aps_new_heroes") then
                    --        self.free_img:LoadSprite(string.format(LoadPath.UIBuild, "building_upgrade_secretary"))
                    --    else
                    --        self.free_img:LoadSprite(string.format(LoadPath.UIBuild, "UIBuild_icon_build"))
                    --    end
                    --else
                    --    self.free_img:LoadSprite(string.format(LoadPath.UIBuild, "UIBuild_icon_KZT"))
                    --end
                else
                    self.blue_upgrade_name_text:SetActive(true)
                    self.blue_cost_time_text:SetActive(true)
                    self.blue_cost_icon_go:SetActive(true)
                    self.blue_btn_text:SetActive(false)
                    self.blue_upgrade_name_text:SetLocalText(GameDialogDefine.UPGRADE)
                    self.blue_cost_time_text:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(needTime))
                    local showGray = false
                    if self.lackList[1] ~= nil then
                        for k, v in ipairs(self.lackList) do
                            if v.cellType == CommonCostNeedType.Build or v.cellType == CommonCostNeedType.Chapter then
                                showGray = true
                                break
                            end
                        end
                    end
                    UIGray.SetGray(self.blue_btn.transform, showGray, not showGray)

                    if DataCenter.BuildManager:IsShowDiamond() then
                        self.yellow_btn:SetActive(true)
                        self.yellow_btn_text:SetLocalText(GameDialogDefine.IMMEDIATELY_UPGRADE)
                        self.spendGold = CommonUtil.GetTimeDiamondCost(math.floor((nTime - freeTime) / 1000))
                        local grayBtn = false
                        for k, v in ipairs(self.lackList) do
                            if v.cellType == CommonCostNeedType.Resource then
                                self.spendGold = self.spendGold + CommonUtil.GetResGoldByType(v.resourceType, v.count - LuaEntry.Resource:GetCntByResType(v.resourceType))
                            elseif v.cellType == CommonCostNeedType.Goods then
                                local itemTemplate = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
                                if itemTemplate == nil or itemTemplate.price <= 0 then
                                    grayBtn = true
                                else
                                    self.spendGold = self.spendGold + CommonUtil.GetItemGoldByItemId(v.itemId,v.count - DataCenter.ItemData:GetItemCount(v.itemId))
                                end
                            elseif v.cellType == CommonCostNeedType.Build then
                                grayBtn = true
                            elseif v.cellType == CommonCostNeedType.Chapter then
                                grayBtn = true
                            end
                        end
                        self.yellow_btn_cost_text:SetText(string.GetFormattedSeperatorNum(self.spendGold))
                        self:RefreshGoldColor()
                        if grayBtn then
                            UIGray.SetGray(self.yellow_btn.transform, true, false)
                        else
                            UIGray.SetGray(self.yellow_btn.transform, false, true)
                        end
                        
                    else
                        self.yellow_btn:SetActive(false)
                    end
                    --self.free_rect:SetActive(false)
                end
            end
        end
    end
end

function UIBuildCreateView:RefreshGoldColor()
    local gold = LuaEntry.Player.gold
    if gold < self.spendGold then
        self.yellow_btn_cost_text:SetColor(ButtonRedTextColor)
    else
        self.yellow_btn_cost_text:SetColor(WhiteColor)
    end
end

function UIBuildCreateView:CheckShowBrokenTips(targetLv)
    local checkObj = LuaEntry.DataConfig:GetObj("shield_base_2")
    if checkObj~=nil then
        local checkLevel = tonumber(checkObj)
        if targetLv == checkLevel then
            return true
        end
    end
    return false
end

function UIBuildCreateView:OnYellowBtnClick()
    local gold = LuaEntry.Player.gold
    if gold < self.spendGold then
        GoToUtil.GotoPayTips()
    else
        if DataCenter.GuideManager:InGuide() then
            self:ConfirmUseGold()
        else
            self.isShowSecondMessage = true
            UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, Localization:GetString(GameDialogDefine.USE_GOLF_UPGRADE_TIP_DES),
                    2, string.GetFormattedSeperatorNum(self.spendGold), Localization:GetString(GameDialogDefine.CANCEL),function()
                        self.isShowSecondMessage = false
                        self:ConfirmUseGold()
                    end, function()
                    end,nil,nil,true, DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold),nil)
        end
    end
end

function UIBuildCreateView:ConfirmUseGold()
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
    if buildData ~= nil then
        if self.state == State.Upgrading then
            SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, { bUUID = buildData.uuid,itemIDs = "",isFixRuins = false, useGold = true})
            self.moveCamera = true
            DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(nil)
            GoToUtil.CloseAllWindows()
        else
            local nextLevel = buildData.level + 1
            if buildData.itemId == BuildingTypes.FUN_BUILD_MAIN and self:CheckShowBrokenTips(nextLevel) then
                UIUtil.ShowMessage(Localization:GetString("110165",nextLevel), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                    local param = {}
                    param.uuid = tostring(buildData.uuid)
                    param.gold = BuildUpgradeUseGoldType.Yes
                    param.upLevel = nextLevel
                    param.clientParam = ""
                    param.truckId = 0
                    param.pathTime = 0
                    param.robotUuid =0
                    SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew,param)
                    self.moveCamera = true
                    DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(nil)
                    GoToUtil.CloseAllWindows()
                end, function()
                end)
            else
                local param = {}
                param.uuid = tostring(buildData.uuid)
                param.gold = BuildUpgradeUseGoldType.Yes
                param.upLevel = nextLevel
                param.clientParam = ""
                param.truckId = 0
                param.pathTime = 0
                param.robotUuid = 0
                SFSNetwork.SendMessage(MsgDefines.FreeBuildingUpNew,param)
                local heroData = DataCenter.HeroDataManager:GetFreeAddTimeHero(EffectDefine.BUILD_TIME_REDUCE)
                if heroData then
                    local heroConfig = LocalController:instance():getLine(HeroUtils.GetHeroXmlName(), heroData.heroId)
                    local name = Localization:GetString(heroConfig["name"])
                    local freeTime = Mathf.Ceil(BuildingUtils.GetDroneFreeTimeForBuild(buildData.itemId)/60)
                    if freeTime == 0 then
                        self.moveCamera = true
                        DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(nil)
                        GoToUtil.CloseAllWindows()
                        return
                    end
                    local time
                    if self.showBtnTime then
                        if self.showBtnTime < (BuildingUtils.GetDroneFreeTimeForBuild(buildData.itemId) * 1000) then
                            if self.showBtnTime > 60000 then
                                local min = Mathf.Floor(self.showBtnTime/60000)
                                time = min..Localization:GetString("100165")
                            else
                                time = Localization:GetString("130076",math.ceil(self.showBtnTime / 1000))
                            end
                        else
                            time = freeTime..Localization:GetString("100165")
                        end
                    else
                        time = freeTime..Localization:GetString("100165")
                    end
                    local str = Localization:GetString("110201",name,time,Localization:GetString("310148"))
                    TimerManager:GetInstance():DelayInvoke(function()
                        UIUtil.ShowTips(str,nil,nil,heroData)
                    end, 1)
                end
                self.moveCamera = true
                DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(nil)
                GoToUtil.CloseAllWindows()
            end
        end
    end
end

function UIBuildCreateView:UpdateBuildDataSignal()
    local close = false
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
    local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
    if buildData ~= nil and desTemplate ~= nil and (not buildData:IsUpgrading()) then
        if desTemplate:GetBuildMaxLevel() <= buildData.level then
            close = true
        else
            local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, 0)
            if levelTemplate ~= nil and levelTemplate:IsFurnitureBuild() then
                local template = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(buildData.itemId, buildData.level)
                if template ~= nil then
                    local all = template.levelup_exp
                    local cur = DataCenter.FurnitureManager:GetBuildCurExp(buildData.uuid)
                    if cur < all then
                        close = true
                    end
                end
            end
        end
    end
    
    if close then
        self.moveCamera = true
        DataCenter.FurnitureManager:SetEnterPanelCameraPosParam(nil)
        GoToUtil.CloseAllWindows()
    else
        self:Refresh()
    end
end

function UIBuildCreateView:RefreshItemsSignal()
    if self.state == State.Create or self.state == State.Upgrade then
        self:ShowNeedCells()
        self:ShowBtn()
    end
end

function UIBuildCreateView:UpdateResourceSignal()
    if self.state == State.Create or self.state == State.Upgrade then
        self:ShowNeedCells()
        self:ShowBtn()
    end
end

function UIBuildCreateView:UpdateGoldSignal()
    self:RefreshGoldColor()
end

function UIBuildCreateView : RefreshTask()
    self.taskInfo:Refresh(self.param.questId)
end

function UIBuildCreateView : ShowIncreaseSpeedBtnArrow()
    if self.param.questId == nil and (not self.param.arrowUpgrade) then
        return
    end
    if self.param.arrowUpgrade then
    else
        local questTemplate = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), self.param.questId)
        local goType = tonumber(questTemplate.gotype2) -- 跳转类型
        if goType ~= QuestGoType.BuildBtn and goType ~= QuestGoType.GoUpgradeFurnitureBuild
                and goType ~= QuestGoType.GoUpgradeFurniture and goType ~= QuestGoType.BuildList then
            return
        end
    end
    self.delayTimer = TimerManager:GetInstance():DelayInvoke(function()
        local param = {}
        param.positionType = PositionType.Screen
        local btn = nil
        for k,v in pairs(self.needCells) do
            if v.visible and v.model ~= nil and v.param ~= nil and  v.param.isRed then
                if v.param.cellType == CommonCostNeedType.Build or v.param.cellType == CommonCostNeedType.Chapter then
                    btn = v.model:GetBtn()
                    break
                end
            end
        end
        if btn == nil then
            if self.blue_btn.activeSelf then
                btn = self.blue_btn
            else
                btn = self.yellow_btn
            end
        end
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.btnGo)
        param.position = btn.transform.position
        param.position.y = param.position.y
        param.isReversal = false
        param.YisReversal = true
        param.isAutoClose = 5
        DataCenter.ArrowManager:ShowArrow(param)
        self.hasShowArrow = true
    end, 0.3)
end

function UIBuildCreateView : ClearArrow()
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
end

function UIBuildCreateView:PlayAnim(animName)
    self.anim:Play(animName, 0, 0)
end

function UIBuildCreateView:AddEnterTimer(time)
    if self.enter_timer == nil then
        self.enter_timer = TimerManager:GetInstance():GetTimer(time, self.enter_timer_callback, self, true, false, false)
        self.enter_timer:Start()
    end
end

function UIBuildCreateView:RemoveEnterTimer()
    if self.enter_timer ~= nil then
        self.enter_timer:Stop()
        self.enter_timer = nil
    end
end

function UIBuildCreateView:OnEnterTimerCallBack()
    self:RemoveEnterTimer()
    self:PlayAnim(UIBuildAnimName.Enter)
end


return UIBuildCreateView