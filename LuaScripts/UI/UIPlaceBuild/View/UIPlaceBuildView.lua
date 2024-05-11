---
--- 放置建筑界面
--- Created by shimin.
--- DateTime: 2021/10/19 18:27
---
local UIPlaceBuildView = BaseClass("UIPlaceBuildView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local PlaceBuildGridManager = require "Scene.PlaceBuildGrid.PlaceBuildGridManager"
--local box_collider_path = "BoxCollider"
local confirm_btn_path = "BtnGo/common_btn_confirm"
local cancel_btn_path = "BtnGo/common_btn_cancel"
local reason_text_path = "common_bg3/reason_text"
local reason_red_text_path = "common_bg3/reason_red_text"

local btn_go_path = "BtnGo"

local build_icon_path = "common_bg3/build_icon"
local build_name_path = "common_bg3/build_name"
local build_des_path = "common_bg3/build_des"
local back_btn_path = "common_bg3/back_btn"

local wormHoleTips_img_path = "Img_WormHole"
local wormHoleTips_txt_path = "Img_WormHole/Txt_WormHoleTips"

local ShowTipDuringTime = 1000

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ClosePanel()
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
    self.confirm_img = self:AddComponent(UIImage, confirm_btn_path)
    self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
    self.reason_text = self:AddComponent(UIText, reason_text_path)
    self.build_icon = self:AddComponent(UIImage, build_icon_path)
    self.build_name = self:AddComponent(UIText, build_name_path)
    self.build_des = self:AddComponent(UIText, build_des_path)
    self.back_btn = self:AddComponent(UIButton, back_btn_path)
    self.reason_red_text = self:AddComponent(UIText, reason_red_text_path)
    self.AutoAdjustScreenPos = self.transform:Find(btn_go_path):GetComponent(typeof(CS.AutoAdjustScreenPos))
    self.confirm_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnConfirmBtnClick()
    end)
    self.cancel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnCancelBtnClick()
    end)
    self.back_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBackClick()
    end)
    self._wormHoleTips_img = self:AddComponent(UIBaseContainer,wormHoleTips_img_path)
    self._wormHoleTips_txt = self:AddComponent(UIText,wormHoleTips_txt_path)
    
end

local function ComponentDestroy(self)
    PlaceBuildGridManager:GetInstance():ResetGridData()
    self.confirm_btn = nil
    self.cancel_btn = nil
    self.reason_text = nil
    self.AutoAdjustScreenPos = nil
    self.confirm_img = nil
    self.build_icon = nil
    self.build_name = nil
    self.build_des = nil
    self.back_btn = nil
    self.reason_red_text = nil
end


local function DataDefine(self)
    self.param = nil
    self.isInGuide = false
    self.needMoveNewPos = false
    self.curIndex = 0--当前所在坐标点
    self.noPutPoint = {}--不可放置的点
    self.putState = BuildPutState.None
    self.needDoCancelFunction = true--放置外部关闭界面
    self.sendCount = 0
    self.allPoint = nil
    self.isSeasonBuild = false
    self.showReasonTime = 0
    self.reasonStr = ""
    RenderSetting.ToggleDepthTexture(true)
end

local function DataDestroy(self)
    --RenderSetting.ToggleDepthTexture(false)
    self:RemoveResourceZoneEffect()
    self:RemoveCanPutEffect()
    DataCenter.BuildManager:SetShowPutBuildFromPanel(nil)
    self.allPoint = nil
    self.param = nil
    self.isInGuide = nil
    self.needMoveNewPos = nil
    self.curIndex = nil
    self.noPutPoint = nil
    self.putState = nil
    self.needDoCancelFunction = false
    self.sendCount = nil
    self.isSeasonBuild = false
    self.showReasonTime = 0
    self.reasonStr = ""
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function Update(self)
end

local function ReInit(self)
    self.sendCount = 0
    self.needDoCancelFunction = true
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIMain) then
        EventManager:GetInstance():Broadcast(EventId.UIMAIN_VISIBLE,false)
    else
        DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Hide)
    end
    local buildId,buildUuid,point,topType = self:GetUserData()
    self.param = {}
    if buildId ~= nil and buildId ~= "" then
        local buildingId = math.floor( tonumber(buildId) / 1000) * 1000
        self.param.buildId = buildingId
        buildId = buildingId
    else
        self.param.buildId = 0
    end
    if buildUuid ~= nil and buildUuid ~= "" then
        self.param.buildUuid = tonumber(buildUuid)
    else
        self.param.buildUuid = 0
    end
    if point ~= nil and point ~= "" then
        self.param.point = tonumber(point)
    else
        self.param.point = 0
    end
    if topType ~= nil and topType ~= "" then
        self.param.topType = tonumber(topType)
    else
        self.param.topType = 0
    end
    CS.SceneManager.World:SetUseInput(false)
    self.isSeasonBuild = false
    local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    if desTemplate ~= nil then
        self.tile = desTemplate.tiles
        self.isSeasonBuild = true
    end
    if SceneUtils.GetIsInWorld() and buildId == BuildingTypes.FUN_BUILD_MAIN then
        self.tile = LuaEntry.DataConfig:TryGetNum("worldmap_city", "k12")
    end
    if buildId == BuildingTypes.WORM_HOLE_CROSS or buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB then
        self._wormHoleTips_img:SetActive(true)
        local str = Localization:GetString("110213",Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), buildId + 1,"name")))
        self._wormHoleTips_txt:SetText(str)
    elseif BuildingUtils.IsInEdenSubwayGroup(buildId)== true then
        self._wormHoleTips_img:SetActive(true)
        local str = Localization:GetString("111066")
        self._wormHoleTips_txt:SetText(str)
    else
        self._wormHoleTips_img:SetActive(false)
    end
    if buildId == BuildingTypes.FUN_BUILD_MAIN then
        self:ShowMainBase()
    else
        local willPos = nil
        if point ~= nil and point > 0 then
            willPos = SceneUtils.TileIndexToWorld(point)
        else
            willPos = CS.SceneManager.World.CurTarget
        end
        self:ChangeIndex(SceneUtils.WorldToTileIndex(willPos))
        CS.SceneManager.World:AutoFocus(willPos,CS.LookAtFocusState.PlaceBuild,LookAtFocusTime,true,false,function ()
        end)
    end
    DataCenter.BuildBubbleManager:HideBubbleNode()
    self:LoadBuildSelect()
    self:ChangeSelectBuild()
    self:CheckInGuide()
    self:SetBuildInfo()
    if buildId ~= BuildingTypes.FUN_BUILD_MAIN and buildId~= BuildingTypes.APS_BUILD_WORMHOLE_SUB 
            and BuildingUtils.IsInEdenSubwayGroup(buildId)== false
            and buildId~=BuildingTypes.WORM_HOLE_CROSS and desTemplate.tab_type ~= UIBuildListTabType.SeasonBuild then
        self:ShowCityZoneEffect()
    end
    if buildId == BuildingTypes.FUN_BUILD_OUT_WOOD or buildId == BuildingTypes.FUN_BUILD_OUT_STONE then
        self:ShowResourceZoneEffect()
    end
    if desTemplate ~= nil and desTemplate.build_type == BuildType.Second then
        self:ShowCanPutEffect()
    end
   
    EventManager:GetInstance():Broadcast(EventId.ShowBuildTopUI,self.param.buildUuid)
    if self.param.topType == PlaceBuildType.Build then
        if buildId ~= nil and buildId > 0 then
            DataCenter.GuideManager:CheckDoTriggerGuide(GuideTriggerType.UIPlaceBuild, buildId .. ";" .. (DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(buildId) + 1))
        end
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.REGET_MAIN_POSITION, self.ReMainPosition)
    self:AddUIListener(EventId.UIPlaceBuildChangePos, self.UIPlaceBuildChangePosSignal)
    self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
    self:AddUIListener(EventId.UICreateFakePlaceBuild, self.UICreateFakePlaceBuildSignal)
    self:AddUIListener(EventId.UIPlaceBuildSendMessageBack, self.UIPlaceBuildSendMessageBackSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.REGET_MAIN_POSITION, self.ReMainPosition)
    self:RemoveUIListener(EventId.UIPlaceBuildChangePos, self.UIPlaceBuildChangePosSignal)
    self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
    self:RemoveUIListener(EventId.UICreateFakePlaceBuild, self.UICreateFakePlaceBuildSignal)
    self:RemoveUIListener(EventId.UIPlaceBuildSendMessageBack, self.UIPlaceBuildSendMessageBackSignal)
end

local function SetBuildInfo(self)
    local level = 1
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
    if buildData ~= nil then
        level = buildData.level
    end
    self.build_icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId, level))
    self.build_name:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.param.buildId + level,"name"))
    self.build_des:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.param.buildId + level,"description"))
end

local function ClosePanel(self)
    if self.needDoCancelFunction then
        self:OnCancelBtnClick()
    end
    if self.param and self.param.topType == PlaceBuildType.Move then
        if CS.SceneManager.World ~= nil then
            local temp = CS.SceneManager.World:GetBuildingByPoint(self.param.point)
            if temp ~= nil then
                temp:refeshDate()
                if self.needMoveNewPos then
                    temp.transform.position = SceneUtils.TileIndexToWorld(self.curIndex)
                end
            end
        end
    end
    EventManager:GetInstance():Broadcast(EventId.FakeBuildingSelectLocation)
    EventManager:GetInstance():Broadcast(EventId.UpdateFakeBuildingPos)
    if self.param then
        EventManager:GetInstance():Broadcast(EventId.HideBuildTopUI,self.param.buildUuid)
    end
    --EventManager:GetInstance():Broadcast(EventId.HideCanBuildEffect)
    if CS.SceneManager.World ~= nil then
        CS.SceneManager.World:SetUseInput(true)
        CS.SceneManager.World:SetTouchInputControllerEnable(true)
        DataCenter.BuildBubbleManager:ShowBubbleNode()
        CS.SceneManager.World.touchPickablePos:Clear()
        self:ChangeSelectLayer(true)
        CS.SceneManager.World.SelectBuild = nil
    end
end

local function OnConfirmBtnClick(self)
    EventManager:GetInstance():Broadcast(EventId.OnClickPlaceBuild)
    local guideContinue = true
    if self.isInGuide then
        local nextGuideType = DataCenter.GuideManager:GetNextGuideTemplateParam("type")
        if nextGuideType == GuideType.BuildPlace then
            DataCenter.GuideManager:DoNext()
        else
            guideContinue = false;
        end
    end
    local needContinue = guideContinue and (self.param.topType == PlaceBuildType.Build or self.param.topType == PlaceBuildType.Replace)
            and BuildingUtils.IsCanBuildNext(self.param.buildId, self.sendCount)
    if self.param.topType == PlaceBuildType.Build then
        local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, 0)
        if self.param.buildId == BuildingTypes.FUN_BUILD_MAIN then
            local now = UITimeManager:GetInstance():GetServerTime()
            CS.GameEntry.BuildAnimatorManager:AddOneBuild(self.curIndex, now, now + levelTemplate:GetBuildTime())
            SFSNetwork.SendMessage(MsgDefines.FreeBuildingPlaceMainBuilding,{pointId = self.curIndex})
            CS.SceneManager.World:UIChangeBuilding(self.curIndex)
        else
            local needPathTime = 0
            local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
            if desTemplate.build_type ~= BuildType.Second and levelTemplate.scan == BuildScanAnim.Play then
                needPathTime = DataCenter.BuildManager:GetPathTimeFromDroneToBuildTarget(self.curIndex, self.tile)
            end
            local now = UITimeManager:GetInstance():GetServerTime()
            local useTime = levelTemplate:GetBuildTime() + needPathTime
            CS.GameEntry.BuildAnimatorManager:AddOneBuild(self.curIndex, now, now + useTime)
            local param = {}
            param.buildingId = self.param.buildId
            param.pointId = self.curIndex
            param.itemUuid = ""
            param.pathTime = needPathTime
            param.robotUuid = 0
            param.targetServerId = LuaEntry.Player:GetCurServerId()
            if useTime > 0 then
                local robot = DataCenter.BuildQueueManager:GetFreeQueue(desTemplate:IsSeasonBuild())
                if robot~=nil then
                    param.robotUuid = robot.uuid
                end
            end
            local lackItem = false
            local needItem = levelTemplate:GetNeedItem()
            if needItem ~= nil then
                for k1,v1 in ipairs(needItem) do
                    if lackItem == false then
                        local itemData = DataCenter.ItemData:GetItemById(v1[1])
                        if itemData == nil or (itemData.count < v1[2]) then
                            lackItem  = true
                        else
                            param.itemUuid = itemData.uuid
                        end
                    end
                end
            end
            if lackItem ==true then
                Logger.LogError("placeBuild no item"..self.param.buildId)
                return
            end
            self.sendCount = self.sendCount + 1
            if not DataCenter.GuideManager:IsSendBuildPlace() then
                DataCenter.GuideCityAnimManager:SetBuildParam(param)
                DataCenter.GuideManager:SetCanShowBuild(false)
            end
            
            if self.param.buildId == BuildingTypes.WORM_HOLE_CROSS then
                param.armyDict = DataCenter.CrossWormManager:GetArmyToPlace()
            end
            
            SFSNetwork.SendMessage(MsgDefines.FreeBuildingPlaceNew,param)
        end
        CS.SceneManager.World:UIChangeBuilding(self.curIndex)
    elseif self.param.topType == PlaceBuildType.Replace then
        local param = {}
        param.buildUuid = self.param.buildUuid
        param.pointId = self.curIndex
        self.sendCount = self.sendCount + 1
        SFSNetwork.SendMessage(MsgDefines.FreeBuildingReplaceNew,param)
        local tempBuild = CS.SceneManager.World.preCreateBuild
        CS.SceneManager.World:UIChangeBuilding(self.curIndex)
        if tempBuild ~= nil and tempBuild.city ~= nil then
            tempBuild.city:DoBuildPlaceAnim()
        end
    elseif self.param.topType == PlaceBuildType.Move then
        if self.curIndex == self.param.point then
            self:OnCancelBtnClick()
            return
        end
        if self.param.buildId == BuildingTypes.APS_BUILD_WORMHOLE_SUB or self.param.buildId == BuildingTypes.WORM_HOLE_CROSS or BuildingUtils.IsInEdenSubwayGroup(self.param.buildId)==true then
            UIUtil.ShowTipsId(104275)
            self:OnCancelBtnClick()
            return
        elseif self.param.buildId == BuildingTypes.APS_BUILD_WORMHOLE_MAIN then
            local aNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(BuildingTypes.APS_BUILD_WORMHOLE_SUB)
            local bNum = DataCenter.BuildManager:GetHaveBuildNumWithOutFoldUpByBuildId(BuildingTypes.WORM_HOLE_CROSS)
            if aNum>0 or bNum>0 then
                UIUtil.ShowTipsId(104275)
                self:OnCancelBtnClick()
                return
            end
        end
        local param = {}
        param.uuid = self.param.buildUuid
        param.pointId = self.curIndex
        param.lastIndex = self.param.point
        SFSNetwork.SendMessage(MsgDefines.BuildWorldMoveNew,param)
        self.needMoveNewPos = true
    end
    if needContinue then
        local point = 0
        local points = BuildingUtils.GetBuildTileIndex(self.param.buildId, self.curIndex)
        local noPintPoint = {}
        for k,v in ipairs(points) do
            noPintPoint[v] = true
        end
        if self.isInGuide then
            local para2 = DataCenter.GuideManager:GetGuideTemplateParam("para2")
            if para2 ~= nil and para2 ~= "" then
                local spl = string.split(para2,",")
                if table.count(spl) > 1 then
                    local mainPos = DataCenter.BuildManager.main_city_pos
                    local vec2 = CS.UnityEngine.Vector2Int(mainPos.x + tonumber(spl[1]),mainPos.y + tonumber(spl[2]))
                    point = SceneUtils.TilePosToIndex(vec2)
                end
            end
        else
            point = BuildingUtils.GetPointByBuildCanPut(self.param.buildId, self.curIndex,noPintPoint)
        end

        local foldList = DataCenter.BuildManager:GetFoldUpAndNotFixBuildByBuildId(self.param.buildId)
        local buildTopType = PlaceBuildType.Build
        local tempUuid = 0
        if foldList ~= nil and table.count(foldList) > self.sendCount then
            buildTopType = PlaceBuildType.Replace
            tempUuid = foldList[self.sendCount + 1].uuid
        end
        self:ChangeSelectLayer(true)
        local id = self.param.buildId
        if self.param.buildId == BuildingTypes.FUN_BUILD_MAIN then
            local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(tempUuid)
            if buildData ~= nil then
                id = BuildingTypes.FUN_BUILD_MAIN+buildData.level-1
            end
        end
        BuildingUtils.ShowPutBuild(id,buildTopType,tempUuid,point,noPintPoint)
        self.param.topType = buildTopType
        self.param.point = point
        self.param.buildUuid = tempUuid
        self:ChangeIndex(point)
    else
        self.needDoCancelFunction = false
        self.ctrl:CloseSelf()
    end
end

local function OnCancelBtnClick(self)
    if self.param.buildId == BuildingTypes.FUN_BUILD_MAIN then
        self.cancel_btn:SetInteractable(false)
        SFSNetwork.SendMessage(MsgDefines.FindMainBuildInitPosition)
    else
        if self.param.topType ~= PlaceBuildType.Move and CS.SceneManager.World then
            CS.SceneManager.World:UIDestroyRreCreateBuild()
        else
            self.needMoveNewPos = false
        end
        self.needDoCancelFunction = false
        self.ctrl:CloseSelf()
    end
end

local function OnBackClick(self)
    local buildId = self.param.buildId
    local backToWindow = DataCenter.BuildManager:GetShowPutBuildFromPanel()
    self:OnCancelBtnClick()
    if backToWindow ~= nil and backToWindow ~= "" then
        UIManager:GetInstance():OpenWindow(backToWindow, buildId)
    end
end

local function ShowMainBase(self)
    local index = DataCenter.BuildManager.showPoint
    local vecPos = SceneUtils.TileIndexToWorld(index)
    CS.SceneManager.World:AutoFocus(vecPos, CS.LookAtFocusState.PlaceBuild,0)
    if CS.SceneManager.World.SelectBuild ~= nil then
        CS.SceneManager.World.SelectBuild.transform.position = vecPos
    end
    self.cancel_btn:SetInteractable(true)
    CS.SceneManager.World:SetTouchInputControllerEnable(false)
    self.putState = BuildPutState.None
    self:ChangeIndex(index)
end

local function ReMainPosition(self) 
    self:ShowMainBase()
end

local function LoadBuildSelect(self)
    self:GameObjectInstantiateAsync(string.format(UIAssets.BuildSelect, self.tile, self.tile) , function(request)
        if request.isError then
            return
        end
        local go = request.gameObject
        if go ~= nil then
            go:SetActive(true)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            self.buildSelect = go:GetComponent(typeof(CS.BuildSelect))
            self:RefreshBuildSelect()
        end
    end)
end

local function RefreshBuildSelect(self)
    if self.buildSelect ~= nil then
		local v = SceneUtils.TileIndexToWorld(self.curIndex) + BlockPos
        self.buildSelect.transform:Set_position(v.x, v.y, v.z) 
        self.buildSelect:ChangeColor(self.putState == BuildPutState.Ok)
    end
end

local function ChangeIndex(self,index)
    self.curIndex = index
    local lastPutState = self.putState
    self.putState = BuildingUtils.IsCanPutDownByBuild(self.param.buildId, index,self.param.buildUuid)
    self:RefreshNoReason(lastPutState ~= self.putState,lastPutState == BuildPutState.None or ((lastPutState == BuildPutState.Ok) ~= (self.putState == BuildPutState.Ok)))
    self:RefreshBuildSelect()
end

local function UIPlaceBuildChangePosSignal(self,data)
    if data ~= nil and data ~= "" then
        local pointId = tonumber(data)
        if self.curIndex ~= pointId then
            self:ChangeIndex(pointId)
        end
    end
end

local function RefreshNoReason(self,isChangeReason,isChangeOk)
    if isChangeOk then
        if self.putState == BuildPutState.Ok then
            self.confirm_btn:SetInteractable(true)
            self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm")
        else
            self.confirm_btn:SetInteractable(false)
            self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
        end
    end
       
    if isChangeReason or self.isSeasonBuild then
        if isChangeReason then
            local str = ""
            if self.putState == BuildPutState.Ok then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.CAN_PUT)
            elseif self.putState == BuildPutState.Building then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_BUILDING)
            elseif self.putState == BuildPutState.WorldBoss then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.MONSTER)
            elseif self.putState == BuildPutState.WorldMonster then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.MONSTER)
            elseif self.putState == BuildPutState.Collect then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUD_MINEPOINT)
            elseif self.putState == BuildPutState.CollectRange then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_MINERANGE_POINT)
            elseif self.putState == BuildPutState.OtherCollectRange then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.INCLUDE_OTHER_MINERANGE_POINT)
            elseif self.putState == BuildPutState.NoCollectRange then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.RESOURCE_BUILD_PUT_MINERANGE_POINT)
            elseif self.putState == BuildPutState.StaticPoint then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_RANGE)
            elseif self.putState == BuildPutState.OutMyRange then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.OUT_MYBASE_RANGE)
            elseif self.putState == BuildPutState.InOtherBaseRange then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.IN_OTHERBASE_RANGE)
            elseif self.putState == BuildPutState.OutUnlockRange then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.OUT_UNLOCK_RANGE_REASON)
            elseif self.putState == BuildPutState.CollectTimeOver then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.COLLECT_RESOURCE_DESTROY)
            elseif self.putState == BuildPutState.OutMyInside then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ONLY_IN_INSIDE)
            elseif self.putState == BuildPutState.OutMainSubRange then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ONLY_IN_MAIN_INSIDE)
            elseif self.putState == BuildPutState.OnWorldResource then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NOT_BUILD_ON_WORLD_RESOURCE)
            elseif self.putState == BuildPutState.MONSTER_REWARD then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_MONSTER_REWARD)
            elseif self.putState == BuildPutState.OnGarbage then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.NO_PUT_GARBAGE)
            elseif self.putState == BuildPutState.InMyInside then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.ONLY_OUT_INSIDE)
            elseif self.putState == BuildPutState.OnDesert then
                str = DataCenter.BuildManager:ShowBuildErrorCode(GameDialogDefine.LOCK)
            elseif self.putState == BuildPutState.MoveCityNotInUnLockRange then
                str = Localization:GetString("111065")
            elseif self.putState == BuildPutState.CanNotPlaceEdenSubway then
                str = Localization:GetString("111067",
                        Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.param.buildId + 1,"name")))
            elseif self.putState == BuildPutState.AllianceBuildNotInBirthRange then
                str = Localization:GetString("111078")
            elseif self.putState == BuildPutState.AllianceMineNotInBirthRange then
                str = Localization:GetString("111069")
            elseif self.putState == BuildPutState.OutBuildZone then
            elseif self.putState == BuildPutState.AlCityBuilding then
                local zoneId = CS.SceneManager.World:GetZoneIdByPosId(self.curIndex-1)
                local template = DataCenter.AllianceCityTemplateManager:GetTemplate(zoneId)
                if template ~= nil then
                    str = Localization:GetString(GameDialogDefine.INCLUDE_AL_CITY_BUILDING, (template:GetAllianceCityRange() - template.size) / 2)
                end
            elseif self.putState == BuildPutState.NotConnectDesert then
                str = Localization:GetString("302739")
            elseif self.putState == BuildPutState.InBlackLandRange then
                str = Localization:GetString("250108")
            elseif self.putState == BuildPutState.NoInAllianceCenterRange then
                str = Localization:GetString(GameDialogDefine.NO_PUT_RANGE)
                local levelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, 0)
                if levelTemplate ~= nil then
                    local allianceCenterId = tonumber(levelTemplate.para1)
                    if allianceCenterId~=nil and allianceCenterId>0 then
                        local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
                        if template~=nil then
                            local buildName = Localization:GetString(template.name)
                            str = Localization:GetString("302740",buildName)
                        end
                    end
                end
            end
            self.reasonStr = str
            if self.putState == BuildPutState.Ok then
                self.reason_text:SetText(str)
                self.reason_text:SetActive(true)
                self.reason_red_text:SetActive(false)
            else
                self.reason_red_text:SetText(str)
                self.reason_text:SetActive(false)
                self.reason_red_text:SetActive(true)
            end
        end
        
        if self.isSeasonBuild and self.putState ~= BuildPutState.Ok then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            if curTime - self.showReasonTime > ShowTipDuringTime and self.reasonStr ~= "" then
                self.showReasonTime = curTime
                UIUtil.ShowTips(self.reasonStr)
            end
        end
    end
end

local function UpdatePointDataSignal(self)
    if UIManager:GetInstance():IsPanelLoadingComplete(UIWindowNames.UIPlaceBuild) then
        self:ChangeIndex(self.curIndex)
    end
end

local function CheckInGuide(self)
    self.isInGuide = false
    if DataCenter.GuideManager:InGuide() then
        local guideTemplate = DataCenter.GuideManager:GetCurTemplate()
        if guideTemplate ~= nil then
            if guideTemplate.type == GuideType.BuildPlace then
                self.isInGuide = true
                if guideTemplate.para2 ~= nil and guideTemplate.para2 ~= "" then
                    CS.SceneManager.World:SetTouchInputControllerEnable(false)
                else
                    CS.SceneManager.World:SetTouchInputControllerEnable(true)
                end
            elseif guideTemplate.type == GuideType.ClickButton and guideTemplate.para2 ~= nil and guideTemplate.para2 ~= "" then
                if string.contains(guideTemplate.para2,UIWindowNames.UIPlaceBuild) then
                    self.isInGuide = true
                    if guideTemplate.forcetype == GuideForceType.Force then
                        CS.SceneManager.World:SetTouchInputControllerEnable(false)
                    else
                        CS.SceneManager.World:SetTouchInputControllerEnable(true)
                    end
                end
            end
        end
    end
end

local function UICreateFakePlaceBuildSignal(self)
    self:ChangeSelectBuild()
end

local function ChangeSelectBuild(self)
    if CS.SceneManager.World.SelectBuild ~= nil then
        self.AutoAdjustScreenPos:Init(CS.SceneManager.World.SelectBuild.transform, Vector3.New(-self.tile/2, 0, -self.tile/2))
        self:ChangeSelectLayer(false)
    end
end

local function UIPlaceBuildSendMessageBackSignal(self)
    self.sendCount = self.sendCount - 1
    if self.sendCount < 0 then
        self.sendCount = 0
    end
end

local function ShowCityZoneEffect(self)
    self:ChangeSelectLayer(false)
end


local function ShowResourceZoneEffect(self)
    if self.curIndex == nil then
        return
    end
    
    DataCenter.MineRootPlaceEffectManager:AddPlaceEffectsAround(self.curIndex, self.param.buildId, self.param.buildUuid)
end

local function RemoveResourceZoneEffect(self)
    DataCenter.MineRootPlaceEffectManager:RemoveAllEffects()
end

local function ChangeSelectLayer(self, isReset)
    --if CS.SceneManager.World.SelectBuild ~= nil then
    --    if isReset then
    --        CS.SceneManager.World.SelectBuild.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("Default"))
    --    else
    --        CS.SceneManager.World.SelectBuild.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("Hud3D"))
    --    end
    --end
end

function UIPlaceBuildView:ShowCanPutEffect()
    
end

function UIPlaceBuildView:RemoveCanPutEffect()
  
end

UIPlaceBuildView.OnCreate= OnCreate
UIPlaceBuildView.OnDestroy = OnDestroy
UIPlaceBuildView.OnEnable = OnEnable
UIPlaceBuildView.OnDisable = OnDisable
UIPlaceBuildView.OnAddListener = OnAddListener
UIPlaceBuildView.OnRemoveListener = OnRemoveListener
UIPlaceBuildView.ComponentDefine = ComponentDefine
UIPlaceBuildView.ComponentDestroy = ComponentDestroy
UIPlaceBuildView.DataDefine = DataDefine
UIPlaceBuildView.DataDestroy = DataDestroy
UIPlaceBuildView.ReInit = ReInit
UIPlaceBuildView.ClosePanel = ClosePanel
UIPlaceBuildView.OnConfirmBtnClick = OnConfirmBtnClick
UIPlaceBuildView.OnCancelBtnClick = OnCancelBtnClick
UIPlaceBuildView.ShowMainBase = ShowMainBase
UIPlaceBuildView.ReMainPosition = ReMainPosition
UIPlaceBuildView.RefreshBuildSelect = RefreshBuildSelect
UIPlaceBuildView.LoadBuildSelect = LoadBuildSelect
UIPlaceBuildView.UIPlaceBuildChangePosSignal = UIPlaceBuildChangePosSignal
UIPlaceBuildView.ChangeIndex = ChangeIndex
UIPlaceBuildView.RefreshNoReason = RefreshNoReason
UIPlaceBuildView.UpdatePointDataSignal = UpdatePointDataSignal
UIPlaceBuildView.CheckInGuide = CheckInGuide
UIPlaceBuildView.UICreateFakePlaceBuildSignal = UICreateFakePlaceBuildSignal
UIPlaceBuildView.ChangeSelectBuild = ChangeSelectBuild
UIPlaceBuildView.UIPlaceBuildSendMessageBackSignal = UIPlaceBuildSendMessageBackSignal
UIPlaceBuildView.SetBuildInfo = SetBuildInfo
UIPlaceBuildView.OnBackClick = OnBackClick
UIPlaceBuildView.ShowCityZoneEffect = ShowCityZoneEffect
UIPlaceBuildView.ShowResourceZoneEffect = ShowResourceZoneEffect
UIPlaceBuildView.RemoveResourceZoneEffect = RemoveResourceZoneEffect
UIPlaceBuildView.Update = Update
UIPlaceBuildView.ChangeSelectLayer = ChangeSelectLayer

return UIPlaceBuildView