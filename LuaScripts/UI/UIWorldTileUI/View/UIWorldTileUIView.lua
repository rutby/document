--- Created by shimin.
--- DateTime: 2021/03/31 21:24
--- 时间点击建筑弹出按钮界面
local UIWorldTileUI = BaseClass("UIWorldTileUI", UIBaseView)
local base = UIBaseView
local UIWorldTileTopBtn = require "UI.UIWorldTileUI.Component.UIWorldTileTopBtn"
local UIWorldTileBuildBtn = require "UI.UIWorldTileUI.Component.UIWorldTileBuildBtn"
local Localization = CS.GameEntry.Localization

local BtnPosition = {} --从右向左
BtnPosition[1] = { Vector3.New(0,-23,0)}
BtnPosition[2] = { Vector3.New(110,-35,0),Vector3.New(-110,-35,0)}
BtnPosition[3] = { Vector3.New(184,21,0), Vector3.New(0,-23,0),Vector3.New(-184,21,0)}
BtnPosition[4] = { Vector3.New(180,0,0),Vector3.New(80,-110,0),
                   Vector3.New(-80,-110,0),Vector3.New(-180,0,0)}
BtnPosition[5] = { Vector3.New(191,28,0),Vector3.New(135,-92,0), 
                   Vector3.New(0,-131.5,0),Vector3.New(-135,-92,0),Vector3.New(-191,28,0)}
local BtnCellCircle = Vector3.New(0,140,0)--按钮的圆心

local AnimName = 
{
    Enter = "UIWorldTileUI_movein",--进入动画
    Exit = "UIWorldTileUI_moveout",--退出动画
    
}

local BtnAnim = {} --从右向左
BtnAnim[1] = { "5Right3"}
BtnAnim[2] = { "4Right2","4Right3"}
BtnAnim[3] = { "5Right2","5Right3","5Right4"}
BtnAnim[4] = { "4Right1","4Right2","4Right3","4Right4"}
BtnAnim[5] = { "5Right1","5Right2","5Right3","5Right4","5Right5"}

local BuildAdjust =
{
    left = 200,right = 200, top = 350,bottom = 100
}

local BuildZoneAdjust =
{
    left = 200,right = 200, top = 350,bottom = 260
}

local pos_go_path = "PosGo"
local name_text_path = "PosGo/message/common_bg3/NameText"
local name_go_path = "PosGo/message/common_bg3"
local slider_path = "PosGo/message/Slider"
local pos_text_path = "PosGo/message/common_bg3/PosText"
local top_btn_go_path = "PosGo/message/TopBtnGo"
local build_btn_go_path = "PosGo/BuildBtnScale/BuildBtnGo"
local this_path = ""
local level_text_path = "PosGo/message/LevelBg/LevelValue"
local slider_text_path = "PosGo/message/Slider/Num"
local info_panel_path =  "PosGo/message"
local circleSlider_path = "PosGo/message/circleSlide"
local circleSlider_icon_path = "PosGo/message/circleSlide/icon"
local circleSlider_progress_path = "PosGo/message/circleSlide/slider"
local circleSlider_effect_path = "PosGo/message/circleSlide/circleEffect"
local circleItem_path = "PosGo/message/circleItem"
local circleItem_capacity_path = "PosGo/message/circleItem/capacity_num"
local stamina_slider_path = "PosGo/message/List/StaminaSlider"
local stamina_btn_path = "PosGo/message/List/StaminaSlider/AddBtn"
local army_slider_path = "PosGo/message/ArmySlider"
local army_count_path = "PosGo/message/ArmySlider/ArmyCount"
local build_btn_scale_path = "PosGo/BuildBtnScale"

local WaitChangeAlphaTime = 5
local ChangeTime = 4000--亮-暗-亮
local WaitTime = 3000--亮持续时间，防止看不清

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    local pointId,needChangeCamera,worldTileBtnType,questTemplate = self:GetUserData()
    self.pointIndex = tonumber(pointId)
    if needChangeCamera ~=nil then
        self.needChangeCamera = needChangeCamera
    else
        self.needChangeCamera = false
    end
    self.questTemplate = questTemplate
    self.worldTileBtnType = tonumber(worldTileBtnType) or nil
    DataCenter.CityLabelManager:SetNoShowLevel()
end

-- 销毁
local function OnDestroy(self)
    self:DataDestroy()
    self:ComponentDestroy()
    DataCenter.TalentDataManager:SetSpecialShowTalent(nil)

    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.auto_adjust = self.transform:Find(pos_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
    self.name_text = self:AddComponent(UITextMeshProUGUIEx,name_text_path)
    self.pos_text = self:AddComponent(UIText,pos_text_path)
    self.top_btn_go = self:AddComponent(UIBaseContainer,top_btn_go_path)
    self.build_btn_go = self:AddComponent(UIBaseContainer,build_btn_go_path)
    self.this_anim = self:AddComponent(UIAnimator,this_path)
    self.build_btn_anim = self:AddComponent(UIAnimator,build_btn_go_path)
    self.level_text = self:AddComponent(UITextMeshProUGUIEx,level_text_path)
    self.slider = self:AddComponent(UISlider,slider_path)
    self.name_go = self:AddComponent(UIBaseContainer,name_go_path)
    self.slider_text = self:AddComponent(UIText,slider_text_path)
    self.info_panel = self:AddComponent(UIBaseContainer,info_panel_path)
    self.circleSlider = self:AddComponent(UIBaseContainer,circleSlider_path)
    self.circleSlider_icon =  self:AddComponent(UIImage,circleSlider_icon_path)
    self.circleSlider_progress = self:AddComponent(UIImage,circleSlider_progress_path)
    self.circleSlider_effect = self:AddComponent(UIBaseContainer,circleSlider_effect_path)
    self.circleItem = self:AddComponent(UIBaseContainer,circleItem_path)
    self.circleItem_capacity = self:AddComponent(UIText,circleItem_capacity_path)
    self.staminaSlider = self:AddComponent(UISlider,stamina_slider_path)
    self.staminaBtn= self:AddComponent(UIButton,stamina_btn_path)
    self.staminaBtn:SetOnClick(function()
        self:OnStaminaBtnClick()
    end)
    self.army_slider = self:AddComponent(UISlider, army_slider_path)
    self.army_count_text = self:AddComponent(UIText, army_count_path)
end

local function ComponentDestroy(self)
   
end


local function DataDefine(self)
    self.startTime = 0
    self.endTime = nil
    self.color = self.slider_text:GetColor()
    self.color.a = 1
    self.slider_text:SetColor(self.color)
    self.timer_action = function(temp)
        self:RefreshTime()
    end
    self.timer_Gotoaction = function(temp)
        self:RefreshPos()
    end
    self.timer_GotoactionWait = function(temp)
        self:WaitPos()
    end
    self.pointIndex = nil
    self.worldTileBtnType = nil
    self.isDrag = nil
    self.buildTemplate = nil
    self.worldPos = nil
    self.screenPos = nil
    self.topBtnCells = {}
    self.buildBtnCells = {}
    self.info = nil
    self.freeTopBtnCells = {}
    self.freeBuildBtnCells = {}
    self.animIndex = 0
    self.Gototimer = nil
    self.GototimerWait = nil
    self.timer = nil
    self.closeTimer = nil
    self.dragEndTime = nil
    
    self.update_action = function()
        self:UpdateCell()
    end
    self.update_timer = nil

    self.update_collect_action = function()
        self:UpdateCollect()
    end
    self.update_collect_timer = nil

    self.showIndex = 1
    self.showListType = {}
    self.waitChangeAlpha = 0
    self.curTime = 0
    self.lastTime = 0
    self.targetBtnPos = 0
    self.timeParam = {}
    self.maxHp = 0
    self.isRuins = false
    self.isRecover = false
    self.needCloseArrow = false
end

local function DataDestroy(self)
    EventManager:GetInstance():Broadcast(EventId.HideMainUIExtraResource,UIWindowNames.UIWorldTileUI)
    self.startTime = 0
    self.color = nil
    self:DeleteTimer()
    self:DeleteGOToTimer()
    self:DeleteGOToTimerWait()
    if self.needCloseArrow then
        self.needCloseArrow = false
        DataCenter.ArrowManager:RemoveArrow()
    end
    self.endTime = nil
    self.timer_action = nil
    self.timer_Gotoaction = nil
    self.timer_GotoactionWait = nil
    self.update_action = nil
    self.update_collect_action = nil
    self.pointIndex = nil
    self.isDrag = nil
    self.buildTemplate = nil
    self.worldPos = nil
    self.screenPos = nil
    self.topBtnCells = nil
    self.buildBtnCells = nil
    self.info = nil
    self.freeTopBtnCells = nil
    self.freeBuildBtnCells = nil
    self.animIndex = nil
    self.timer = nil
    self.Gototimer = nil
    self.dragEndTime = nil
    self.update_timer= nil
    if self.closeTimer ~= nil then
        self.closeTimer:Stop()
        self.closeTimer = nil
    end

    self.showIndex = nil
    self.showListType = nil
    self.waitChangeAlpha = nil
    self.curTime = nil
    self.lastTime= nil
    self.timeParam = nil
    self.targetBtnPos =  nil
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    if self.info~=nil and self.info.uuid~=nil then
        EventManager:GetInstance():Broadcast(EventId.ShowBuildDetail,self.info.uuid)
    end
    self:DeleteCellTimer()
    self:DeleteCollectTimer()
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshUIWorldTileUI, self.RefreshUIWorldTileUISignal)
    self:AddUIListener(EventId.OnWorldInputDragBegin, self.OnWorldInputDragBeginSignal)
    self:AddUIListener(EventId.BuildUpgradeFinish, self.BuildUpgradeFinishSignal)
end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshUIWorldTileUI, self.RefreshUIWorldTileUISignal)
    self:RemoveUIListener(EventId.OnWorldInputDragBegin, self.OnWorldInputDragBeginSignal)
    self:RemoveUIListener(EventId.BuildUpgradeFinish, self.BuildUpgradeFinishSignal)
end

local function ReInit(self)
    self.endTime = nil
    self.startTime = 0
    self.curTime = 0
    self.maxHp = 0
    self.isRuins = false
    self.isRecover = false
    if CS.SceneManager:IsInCity() then
        self.info = {}
        local buildData = DataCenter.BuildManager:GetBuildingDataByPointId(self.pointIndex, false)
        if buildData ~= nil then
            self.info.uuid = buildData.uuid
            self.info.itemId = buildData.itemId
            self.info.level = buildData.level
            self.info.pointIndex = buildData.pointId
            self.info.ownerUid = LuaEntry.Player.uid
            self.pointIndex = self.info.pointIndex
        end
    end
    if self.info.itemId == BuildingTypes.FUN_BUILD_LIBRARY then
        local param = {}
        param.list = {ResourceType.People}
        param.uiName = UIWindowNames.UIWorldTileUI
        EventManager:GetInstance():Broadcast(EventId.ShowMainUIExtraResource,param)
    end
    --self.circleSlider_progress:SetFillAmount(0)
    if self.info ~= nil then
        EventManager:GetInstance():Broadcast(EventId.HideBuildDetail,self.info.uuid)
        local buildId = self.info.itemId
        if self.level_text~=nil then
            self.level_text:SetText(self.info.level)
        end
        self.buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
        self.circleItem:SetActive(false)
        self.army_slider:SetActive(false)
        local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.info.uuid)
        if buildData~=nil and self.info.itemId ~= BuildingTypes.FUN_BUILD_MAIN then
            --local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.info.itemId,self.info.level)
            --if buildLevelTemplate~=nil then
            --    self.maxHp = buildLevelTemplate:GetMaxHp()
            --    if buildData.destroyStartTime>0 then
            --        self.isRuins = true
            --        self.isRecover = false
            --    else
            --        self.isRuins = false
            --        local maxHp = buildLevelTemplate:GetMaxHp()
            --        if self.info.curHp~=nil and maxHp > self.info.curHp then
            --            local curTime = UITimeManager:GetInstance():GetServerTime()
            --            local deltaTime = curTime / 1000 - self.info.lastHpTime
            --            local recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2")
            --            local realBlood = math.min(deltaTime * recoverSpeed + self.info.curHp, maxHp)
            --            local deltaBlood = maxHp - realBlood
            --            if deltaBlood>0 then
            --                self.isRecover = true
            --            else
            --                self.isRecover = false
            --            end
            --            --local costMoney = LuaEntry.DataConfig:TryGetNum("building_attack", "k3")
            --        else
            --            self.isRecover = false
            --        end
            --    end
            --end
        end
        if self.isRecover == true then
            if self.info.itemId == BuildingTypes.WORM_HOLE_CROSS then
                self.staminaBtn:SetActive(false)
            else
                self.staminaBtn:SetActive(true)
            end
            self.staminaSlider:SetActive(true)
            self:StartTimer()
            self:DoRecover()
        else
            self.staminaSlider:SetActive(false)
            self:ShowArmyCount()
        end
        
        --if v == WorldTileBtnType.City_Repair then
        --    param.inCD =  false
        --    param.costNum = 0
        --    param.endCDTime =0
        --    local curTime = UITimeManager:GetInstance():GetServerTime()
        --    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.info.uuid)
        --    if buildData~=nil then
        --        local cdDeltaTime = LuaEntry.DataConfig:TryGetNum("building_attack", "k4")
        --        local endTime = buildData.lastCashCdTime + (cdDeltaTime*1000)
        --        if endTime>curTime then
        --            param.inCD = true
        --            param.endCDTime = endTime
        --            self.timeParam.endTime = endTime
        --            self.timeParam.startTime = buildData.lastCashCdTime
        --        else
        --            param.inCD = false
        --            local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.info.itemId,self.info.level)
        --            if buildLevelTemplate~=nil then
        --                local maxHp = buildLevelTemplate:GetMaxHp()
        --                if maxHp> self.info.curHp then
        --                    local deltaTime = curTime/1000 - self.info.lastHpTime
        --                    local recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2")
        --                    local realBlood  = math.min(deltaTime * recoverSpeed + self.info.curHp,maxHp)
        --                    local deltaBlood = maxHp - realBlood
        --                    local costMoney = LuaEntry.DataConfig:TryGetNum("building_attack", "k3")
        --                    param.costNum = math.ceil(deltaBlood * costMoney)
        --                end
        --            end
        --        end
        --    end
        --end
        if self.buildTemplate ~= nil then
            local state = false
            --兵营
            --for i, v in pairs(BarracksBuild) do
            --    if self.buildTemplate.id == v then
            --        local queueType = DataCenter.ArmyManager:GetArmyQueueTypeByBuildId(self.info.itemId)
            --        local Training = DataCenter.ArmyManager:GetArmyQueue(queueType):GetQueueState()
            --        state = (Training == NewQueueState.Work)
            --       if (Training == NewQueueState.Work) then
            --            local queue = DataCenter.QueueDataManager:GetQueueByType(queueType)
            --            if queue then
            --                self.timeParam = queue
            --                self:StartTimer()
            --                local template = DataCenter.ArmyManager:GetQueueArmyTemplate(queue.type)
            --                self.circleSlider_icon:LoadSprite(string.format(LoadPath.SoldierIcons,template.icon))
            --            end
            --       end
            --    end
            --end
            ----采集器
            --for i, v in pairs(CollectBuild) do
            --    if self.buildTemplate.id == v then
            --        self.top_btn_go:SetActive(false)
            --        self.pos_text:SetActive(false)
            --        state = true
            --        local resourceType = DataCenter.BuildManager:GetOutResourceTypeByBuildId(self.buildTemplate.id)
            --        self.circleSlider_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(resourceType))
            --        self:StarCollectTimer()
            --    end
            --end
            ----科技
            --if self.buildTemplate.id == BuildingTypes.FUN_BUILD_SCIENE then
            --    local queue =  DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.info.uuid)
            --    if queue ~= nil then
            --        --local state = queue:GetQueueState()
            --        state = (queue:GetQueueState() == NewQueueState.Work)
            --        self.timeParam = queue
            --        if queue:GetQueueState() == NewQueueState.Work then
            --            self:StartTimer()
            --            if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" then
            --                local id = tonumber(queue.itemId)
            --                local level = 1
            --                local science = DataCenter.ScienceDataManager:GetScienceById(id)
            --                if science ~= nil then
            --                    level = science.level + 1
            --                end
            --                local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(id,level)
            --                if template ~= nil then
            --                    self.circleSlider_icon:LoadSprite(string.format(LoadPath.ScienceIcons,template.icon))
            --                end
            --            end
            --        end
            --    end
            --end
            --if self.buildTemplate.id == BuildingTypes.FUN_BUILD_SCIENCE_PART then
            --    local queue =  DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.info.uuid)
            --    if queue ~= nil then
            --        --local state = queue:GetQueueState()
            --        state = (queue:GetQueueState() == NewQueueState.Work)
            --        self.timeParam = queue
            --        if queue:GetQueueState() == NewQueueState.Work then
            --            self:StartTimer()
            --            if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" then
            --                local id = tonumber(queue.itemId)
            --                local level = 1
            --                local science = DataCenter.ScienceDataManager:GetScienceById(id)
            --                if science ~= nil then
            --                    level = science.level + 1
            --                end
            --                local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(id,level)
            --                if template ~= nil then
            --                    self.circleSlider_icon:LoadSprite(string.format(LoadPath.ScienceIcons,template.icon))
            --                end
            --            end
            --        end
            --    end
            --end
            --if self.buildTemplate.id == BuildingTypes.FUN_BUILD_SCIENCE_1 then
            --    local queue =  DataCenter.QueueDataManager:GetQueueByBuildUuidForScience(self.info.uuid)
            --    if queue ~= nil then
            --        --local state = queue:GetQueueState()
            --        state = (queue:GetQueueState() == NewQueueState.Work)
            --        self.timeParam = queue
            --        if queue:GetQueueState() == NewQueueState.Work then
            --            self:StartTimer()
            --            if queue ~= nil and queue.itemId ~= nil and queue.itemId ~= "" then
            --                local id = tonumber(queue.itemId)
            --                local level = 1
            --                local science = DataCenter.ScienceDataManager:GetScienceById(id)
            --                if science ~= nil then
            --                    level = science.level + 1
            --                end
            --                local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(id,level)
            --                if template ~= nil then
            --                    self.circleSlider_icon:LoadSprite(string.format(LoadPath.ScienceIcons,template.icon))
            --                end
            --            end
            --        end
            --    end
            --end
            ----仓库
            --if self.buildTemplate.id == BuildingTypes.FUN_BUILD_COLD_STORAGE then
            --    state = false
            --    self.circleItem:SetActive(true)
            --    local curNum = 0
            --    local storageMax = 0
            --    self.circleItem_capacity:SetText(tostring(curNum).."/"..math.floor(storageMax))
            --end

            self.top_btn_go:SetActive(false)
            self.pos_text:SetActive(false)
            --self.circleSlider:SetActive(state)

            state = SceneUtils.GetIsInWorld()
            self.top_btn_go:SetActive(state)
            self.pos_text:SetActive(state)

            local horizontalLayoutGroup = self.info_panel.transform:GetComponent(typeof(CS.UnityEngine.UI.HorizontalLayoutGroup))
            horizontalLayoutGroup.spacing = state and 0 or 10
            
            if self.info.level > 0 or self.buildTemplate.id == BuildingTypes.APS_BUILD_WORMHOLE_SUB or BuildingUtils.IsInEdenSubwayGroup(self.buildTemplate.id)== true then
                self.info_panel:SetActive(true)
                self:InitShowText()
                local tilePos = SceneUtils.IndexToTilePos(self.info.pointIndex)
                self.pos_text:SetLocalText(GameDialogDefine.SHOW_POS, tilePos.x,  tilePos.y) 
                self:ShowTopBtn()
            else
                self.info_panel:SetActive(false)
            end
            local tile = self.buildTemplate.tiles
            self.worldPos = self.buildTemplate:GetPosition()
			local x,y = self.transform:Get_lossyScale()
			local lossyScale = y
            --local lossyScale = self.transform.lossyScale.y
            if lossyScale <= 0 then
                lossyScale = 1
            end
            if self.needChangeCamera ==false then
                if self:IsCanShowZone() then
                    UIUtil.ClickBuildAdjustCameraView(self.worldPos,BuildZoneAdjust,lossyScale)
                else
                    UIUtil.ClickBuildAdjustCameraView(self.worldPos,BuildAdjust,lossyScale)
                end
            end
            self.auto_adjust:Init(self.worldPos)
            self:ShowBtn()
        end
    end
end

local function OnStaminaBtnClick(self)
    if self.info~=nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIAddStamina,self.info.uuid)
    end
    self.ctrl:CloseSelf(true)
end
local function ShowTopBtn(self)
    for k,v in pairs(self.topBtnCells) do
        v:SetActive(false)
        self.freeTopBtnCells[k] = v
    end
    self.topBtnCells = {}
    
    for k,v in ipairs(UIWorldTileTopBtnSort) do
        local param = UIWorldTileTopBtn.Param.New()
        param.topBtnType = v
        param.index = self.pointIndex
        param.buildId = self.info.itemId
        param.server = LuaEntry.Player:GetCurServerId()
        local level = 0
        local data = DataCenter.BuildManager:GetBuildingDataByUuid(self.info.uuid)
        if data ~=nil then
            param.server = data.server
            level = data.level
        end
        param.name = GetTableData(DataCenter.BuildTemplateManager:GetTableName(), param.buildId + level,"name")
        if self.freeTopBtnCells[param.topBtnType] ~= nil then
            local temp = self.freeTopBtnCells[param.topBtnType]
            self.freeTopBtnCells[param.topBtnType] = nil
            if temp ~= nil then
                temp:SetActive(true)
                temp:ReInit(param)
                temp.transform:SetAsLastSibling()
                self.topBtnCells[v] = temp
            end
        else
            self:GameObjectInstantiateAsync(UIAssets.UIWorldTileTopBtn, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.top_btn_go.transform)
                --go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                --go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
					
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                self.topBtnCells[v] = self.top_btn_go:AddComponent(UIWorldTileTopBtn, nameStr)
                self.topBtnCells[v]:ReInit(param)
            end)
        end
    end
end

local function ShowBtn(self)
    self.buildBtnCells = {}
    self:SetAllCellDestroy()
    self.btnList = self.ctrl:GetBuildBtn(self.info)
    self.btnCount = #self.btnList
    if self.btnCount > 0 then
        self.build_btn_go:SetActive(true)
        for k,v in ipairs(self.btnList) do
            local param = UIWorldTileBuildBtn.Param.New()
            param.btnType = v
            param.info = self.info
            param.position = BtnPosition[self.btnCount][k] - BtnCellCircle
            self.model[k] = self:GameObjectInstantiateAsync(UIAssets.UICityTileBuildBtn, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                if go ==nil then
                    return
                end
                go:SetActive(true)
                go.transform:SetParent(self.build_btn_go.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:Set_localPosition(BtnCellCircle.x, BtnCellCircle.y, BtnCellCircle.z)
                local nameStr = self.view.ctrl:GetBuildBtnEnumName(v)

                --local nameStr = tostring(NameCount)
                go.name = nameStr
                --NameCount = NameCount + 1
                self.buildBtnCells[v] = self.build_btn_go:AddComponent(UIWorldTileBuildBtn, nameStr)
                self.buildBtnCells[v]:ReInit(param)
                self:CheckPlay()
            end)
        end
        self:CheckPlay()
    else
        self.build_btn_go:SetActive(false)
    end
    
    if self.worldTileBtnType ~= nil then
        local state,time =  self.build_btn_anim:GetAnimationReturnTime("BtnBg")
        self:AddGoToTimer(time + 0.3)
    end
end

local function SetAllCellDestroy(self)
    self.build_btn_go:RemoveComponents(UIWorldTileBuildBtn)
    if self.model~=nil then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.model ={}
end

local function DeleteGOToTimer(self)
    if self.Gototimer ~= nil then
        self.Gototimer:Stop()
        self.Gototimer = nil
    end
end

local function AddGoToTimer(self,time)
    if self.Gototimer == nil then
        self.Gototimer = TimerManager:GetInstance():GetTimer(time, self.timer_Gotoaction , self, false,false,false)
    end
    self.Gototimer:Start()
end

local function RefreshPos(self)
    self.Gototimer:Stop()
    self.Gototimer = nil
    self:AddGoToWaitTimer()
end

local function DeleteGOToTimerWait(self)
    if self.GototimerWait ~= nil then
        self.GototimerWait:Stop()
        self.GototimerWait = nil
    end
end

local function AddGoToWaitTimer(self)
    if self.GototimerWait == nil then
        self.GototimerWait = TimerManager:GetInstance():GetTimer(0.1, self.timer_GotoactionWait , self, false,false,false)
    end
    self.GototimerWait:Start()
end

local function WaitPos(self)
    for i, v in pairs(self.buildBtnCells) do
        if i == self.worldTileBtnType then
            local pos = v:GetPosition()
            if pos ~= self.targetBtnPos then
                self.targetBtnPos = pos
                break
            else
                self:DeleteGOToTimerWait()
                if not DataCenter.GuideManager:InGuide() then
                    local param = {}
                    param.position = v:GetPosition()
                    param.arrowType = ArrowType.Building
                    param.positionType = PositionType.Screen
                    param.isPanel = false
                    if param.position ~= nil then
                        self.needCloseArrow = true
                        DataCenter.ArrowManager:ShowArrow(param)
                    end
                end
                break
            end
        end
    end
end

local function RefreshUIWorldTileUISignal(self,data)
    self.pointIndex = tonumber(data)
    self.needChangeCamera = false
    if self.this_anim == nil then
        return
    end
    local ret,time = self.this_anim:PlayAnimationReturnTime(AnimName.Exit)
    if ret then
        if self.info~=nil and self.info.uuid~=nil then
            EventManager:GetInstance():Broadcast(EventId.ShowBuildDetail,self.info.uuid)
        end
        self.closeTimer = TimerManager:GetInstance():GetTimer(time, function()
            if self.closeTimer ~= nil then
                self.closeTimer:Stop()
                self.closeTimer = nil
            end
            self.this_anim:Play(AnimName.Enter,0,0)
            self:ReInit()
        end , self, true,false,false)
        self.closeTimer:Start()
    end
 
end

local function CheckPlay(self)
    if self.btnCount <= table.count(self.buildBtnCells) then
        self.animIndex = 1
        self:AddTimer()
    end
   
end
    
local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self)
    if self.timer == nil then
        local time = self.build_btn_anim:GetFloat("DuringTime")
        self.timer = TimerManager:GetInstance():GetTimer(time / 10, self.timer_action , self, false,false,false)
    end

    self.timer:Start()
end

local function RefreshTime(self)
    if self.animIndex > 0 then
        if self.btnCount >= self.animIndex then
            local temp = self.buildBtnCells[self.btnList[self.animIndex]]
            if temp ~= nil then
                temp:PlayAnim(BtnAnim[self.btnCount][self.animIndex])
            end
            self.animIndex = self.animIndex + 1
        else
            self.animIndex = 0
            self:DeleteTimer()
        end
    end
end

local function StarCollectTimer(self)
    self.circleSlider_effect:SetActive(true)
    local now = UITimeManager:GetInstance():GetServerTime()
    local data = DataCenter.BuildManager:GetBuildingDataByUuid(self.info.uuid)
    if data.unavailableTime > 0 and now > data.unavailableTime then
        now = data.unavailableTime
    end
    if data.produceEndTime > 0 and now > data.produceEndTime then
        now = data.produceEndTime
    end
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId,data.level)
    if levelTemplate ~= nil then
        local curValue = (now - data.lastCollectTime) * (levelTemplate:GetCollectSpeed() / 1000) / levelTemplate:GetCollectMax()
        local baseLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, 0)
        local maxColorValue = baseLevelTemplate:GetOutResourceMaxColorPercent()
        if curValue >= maxColorValue then
            self.circleSlider_progress:SetFillAmount(1)
            self.circleSlider_effect:SetActive(false)
            self.circleSlider_progress:LoadSprite(string.format(LoadPath.UIBuildBtns,"UIBuildname_img_line_full"))
        else
            self.circleSlider_progress:SetFillAmount(curValue/maxColorValue)
            self.circleSlider_progress:LoadSprite(string.format(LoadPath.UIBuildBtns,"UIBuildname_img_line"))
        end
    end
    if self.update_collect_timer ==nil then
        self.update_collect_timer = TimerManager:GetInstance():GetTimer(1, self.update_collect_action , self, false,false,false)
    end
    self.update_collect_timer:Start()
end

local function DeleteCollectTimer(self)
    if self.update_collect_timer ~= nil then
        self.update_collect_timer:Stop()
        self.update_collect_timer = nil
    end
end

local function UpdateCollect(self)
    local now = UITimeManager:GetInstance():GetServerTime()
    local data = DataCenter.BuildManager:GetBuildingDataByUuid(self.info.uuid)
    if data.unavailableTime > 0 and now > data.unavailableTime then
        now = data.unavailableTime
    end
    if data.produceEndTime > 0 and now > data.produceEndTime then
        now = data.produceEndTime
    end
    local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId,data.level)
    if levelTemplate ~= nil then
        local curValue = (now - data.lastCollectTime) * (levelTemplate:GetCollectSpeed() / 1000) / levelTemplate:GetCollectMax()
        local baseLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(data.itemId, 0)
        local maxColorValue = baseLevelTemplate:GetOutResourceMaxColorPercent()
        if curValue >= maxColorValue then
            self.circleSlider_progress:SetFillAmount(1)
            self.circleSlider_effect:SetActive(false)
            self.circleSlider_progress:LoadSprite(string.format(LoadPath.UIBuildBtns,"UIBuildname_img_line_full"))
            self:DeleteCollectTimer()
        else
            self.circleSlider_progress:SetFillAmount(curValue/maxColorValue)
        end
    end
end

local function StartTimer(self)
    if self.timeParam.endTime~=nil and self.timeParam.startTime~=nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local leftTime = math.ceil(curTime - self.timeParam.startTime)
        self.circleSlider_progress:SetFillAmount(leftTime/(self.timeParam.endTime - self.timeParam.startTime))
        self.circleSlider_effect:SetActive(true)
        if curTime >= self.timeParam.endTime then
            self.circleSlider_progress:LoadSprite(string.format(LoadPath.UIBuildBtns,"UIBuildname_img_line_full"))
        else
            self.circleSlider_progress:LoadSprite(string.format(LoadPath.UIBuildBtns,"UIBuildname_img_line"))
        end
    end
    if self.update_timer ==nil then
        self.update_timer = TimerManager:GetInstance():GetTimer(1, self.update_action , self, false,false,false)
    end
    self.update_timer:Start()
end

local function DeleteCellTimer(self)
    if self.update_timer ~= nil then
        self.update_timer:Stop()
        self.update_timer = nil
    end
end

local function UpdateCell(self)
    --if self.buildBtnCells[WorldTileBtnType.City_Repair]~=nil then
    --    self.buildBtnCells[WorldTileBtnType.City_Repair]:UpdateTime()
    --end
    if self.isRecover== true then
        self:DoRecover()
    end
    if self.timeParam.endTime~=nil and self.timeParam.startTime~=nil then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local leftTime = math.ceil(curTime - self.timeParam.startTime)
        self.circleSlider_progress:SetFillAmount(leftTime/(self.timeParam.endTime - self.timeParam.startTime))
        if curTime >= self.timeParam.endTime then
            self.circleSlider_effect:SetActive(false)
            self.circleSlider_progress:LoadSprite(string.format(LoadPath.UIBuildBtns,"UIBuildname_img_line_full"))
        end
    end
end
local function DoRecover(self)
    if self.info~=nil and self.info.curHp~=nil and self.maxHp>0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = curTime / 1000 - self.info.lastHpTime
        local recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2")
        local realBlood = math.min(deltaTime * recoverSpeed + self.info.curHp, self.maxHp)
        local deltaBlood = self.maxHp - realBlood
        if deltaBlood>0 then
            local percent = math.min((1-(deltaBlood/self.maxHp)),1)
            self.staminaSlider:SetValue(percent)
            return
        end
    end
    self.isRecover =false
    self.staminaSlider:SetActive(false)
    self:ShowArmyCount()
end
local function ChangeShowTime(self)
    self.showIndex = self.showIndex + 1
    if table.count(self.showListType) < self.showIndex then
        self.showIndex = 1
    end
end

local function ShowText(self)
    if self.showListType[self.showIndex].showType == UIBuildTimeTextShowType.Time then
        local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(self.lastTime * 1000)
        self.slider_text:SetText(tempTimeValue)
    elseif self.showListType[self.showIndex].showType == UIBuildTimeTextShowType.Des then
        self.slider_text:SetText(self.showListType[self.showIndex].des)
    end
end

local function RefreshUpdate(self,isAddAlpha,alphaValue)
    if table.count(self.showListType) > 1 then
        if self.isAddAlpha ~= isAddAlpha then
            self.isAddAlpha = isAddAlpha
            if self.isAddAlpha then
                self:ChangeShowTime()
                self:ShowText()
            end
        end
        self.waitChangeAlpha = self.waitChangeAlpha + 1
        if self.waitChangeAlpha > WaitChangeAlphaTime then
            self.waitChangeAlpha = 0
            self.color.a = alphaValue
            self.slider_text:SetColor(self.color)
        end
    end
end

local function Update(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.endTime ~= nil and self.endTime > 0 then
        local changeTime = self.endTime - curTime
        if changeTime <= 0 then
            self:InitShowText()
        else
            local maxTime = self.endTime - self.startTime
            local tempValue = 1 - changeTime / maxTime
            self:RefreshSlider(tempValue)
            local tempTimeSec = math.ceil(changeTime / 1000)
            if tempTimeSec ~= self.lastTime then
                self:RefreshShowTime(tempTimeSec)
            end
        end
    end
    if table.count(self.showListType) > 1 then
        local changeDelta = curTime - self.curTime
        local half = ChangeTime / 2
        local isAddAlpha = false
        if changeDelta > (ChangeTime + WaitTime) then
            self.curTime = curTime
            isAddAlpha = false
        elseif changeDelta > ChangeTime then
            isAddAlpha = nil
        elseif changeDelta > half then
            isAddAlpha = true
        else
            isAddAlpha = false
        end

        if isAddAlpha ~= nil then
            if isAddAlpha then
                self:RefreshUpdate(isAddAlpha,(changeDelta - half)/half)
            else
                self:RefreshUpdate(isAddAlpha,(half - changeDelta) / half)
            end
        end
    end
end

local function RefreshShowTime(self,value)
    self.lastTime = value
    self:ShowText()
end

local function InitShowText(self)
    self.endTime = nil
    self.startTime = 0
    self.showIndex = 1
    self.showListType = {}
    local param1 = {}
    param1.showType = UIBuildTimeTextShowType.Des
    
    local buildName = ""
    param1.des = buildName
    table.insert(self.showListType,param1)
    local showSlider = false
    if self.info ~= nil then
        local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.info.itemId,self.info.level)
        buildName = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.info.itemId + self.info.level,"name"))
        param1.des = buildName

        if self.info.destroyStartTime~=nil and self.info.destroyStartTime>0 then
            buildName = buildName.."("..Localization:GetString("104202")..")"
            param1.des = buildName
        end
        if buildLevelTemplate~=nil and self.info.curHp~=nil then
            local maxHp = buildLevelTemplate:GetMaxHp()
            local curTime = UITimeManager:GetInstance():GetServerTime()
            local deltaTime = curTime/1000 - self.info.lastHpTime
            local recoverSpeed = LuaEntry.DataConfig:TryGetNum("building_attack", "k2")
            local realBlood  = math.min(deltaTime * recoverSpeed + self.info.curHp,maxHp)
            local percent = math.min(realBlood/maxHp,1)
            if percent<1 then
                showSlider = true
                local param2 = {}
                param2.showType = UIBuildTimeTextShowType.Des
                param2.des = string.GetFormattedSeperatorNum(math.floor(realBlood)).."/"..string.GetFormattedSeperatorNum(math.floor(maxHp))
                table.insert(self.showListType,param2)
                self:RefreshSlider(percent)
            end
        end
    end
    

    if self.showListType[self.showIndex].showType == UIBuildTimeTextShowType.Des then
        self.name_text:SetText(self.showListType[self.showIndex].des)
    end

    
    self:ShowText()
end


--刷新进度条
local function RefreshSlider(self,value)
    if value >= 0 and value <= 1 then
        self.slider:SetValue(value)
    end
end

local function IsCanShowZone(self)
    if self.buildTemplate == nil then
        return false
    end
    if self.buildTemplate.zoneMainType == BuildZoneMainType.Main then
        return true
    end
    
    return false
end

local function ShowArmyCount(self)
    if self.info.itemId == BuildingTypes.WORM_HOLE_CROSS and DataCenter.CrossWormManager:IsNewWormTrain() and LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        self.army_slider:SetActive(true)
        local cur = DataCenter.CrossWormManager:GetCurArmyNum()
        local max = DataCenter.CrossWormManager:GetMaxArmyNum()
        self.army_count_text:SetText(string.GetFormattedSeperatorNum(cur) .. "/" .. string.GetFormattedSeperatorNum(max))
        self.army_slider:SetValue(cur / max)
    end
end

function UIWorldTileUI:OnWorldInputDragBeginSignal()
    self.ctrl:CloseSelf()
end

function UIWorldTileUI:BuildUpgradeFinishSignal(bUuid)
    if self.info.uuid == bUuid then
        self.ctrl:CloseSelf()
    end
end


UIWorldTileUI.OnCreate = OnCreate
UIWorldTileUI.OnDestroy = OnDestroy
UIWorldTileUI.OnEnable = OnEnable
UIWorldTileUI.OnDisable = OnDisable
UIWorldTileUI.ComponentDefine = ComponentDefine
UIWorldTileUI.ComponentDestroy = ComponentDestroy
UIWorldTileUI.DataDefine = DataDefine
UIWorldTileUI.DataDestroy = DataDestroy
UIWorldTileUI.OnAddListener = OnAddListener
UIWorldTileUI.OnRemoveListener = OnRemoveListener
UIWorldTileUI.ReInit = ReInit
UIWorldTileUI.ShowTopBtn = ShowTopBtn
UIWorldTileUI.ShowBtn = ShowBtn
UIWorldTileUI.RefreshUIWorldTileUISignal = RefreshUIWorldTileUISignal
UIWorldTileUI.CheckPlay = CheckPlay
UIWorldTileUI.DeleteTimer = DeleteTimer
UIWorldTileUI.AddTimer = AddTimer
UIWorldTileUI.RefreshTime = RefreshTime
UIWorldTileUI.UpdateCell =UpdateCell
UIWorldTileUI.DeleteCellTimer = DeleteCellTimer
UIWorldTileUI.StartTimer = StartTimer
UIWorldTileUI.Update = Update
UIWorldTileUI.InitShowText = InitShowText
UIWorldTileUI.RefreshShowTime = RefreshShowTime
UIWorldTileUI.RefreshUpdate = RefreshUpdate
UIWorldTileUI.ShowText = ShowText
UIWorldTileUI.ChangeShowTime = ChangeShowTime
UIWorldTileUI.RefreshSlider = RefreshSlider
UIWorldTileUI.AddGoToTimer = AddGoToTimer
UIWorldTileUI.AddGoToWaitTimer = AddGoToWaitTimer
UIWorldTileUI.DeleteGOToTimer = DeleteGOToTimer
UIWorldTileUI.DeleteGOToTimerWait = DeleteGOToTimerWait
UIWorldTileUI.RefreshPos = RefreshPos
UIWorldTileUI.WaitPos = WaitPos
UIWorldTileUI.StarCollectTimer = StarCollectTimer
UIWorldTileUI.DeleteCollectTimer = DeleteCollectTimer
UIWorldTileUI.UpdateCollect = UpdateCollect
UIWorldTileUI.IsCanShowZone = IsCanShowZone
UIWorldTileUI.DoRecover = DoRecover
UIWorldTileUI.OnStaminaBtnClick = OnStaminaBtnClick
UIWorldTileUI.SetAllCellDestroy =SetAllCellDestroy
UIWorldTileUI.ShowArmyCount = ShowArmyCount

return UIWorldTileUI