---
--- 放置建筑界面
--- Created by shimin.
--- DateTime: 2021/10/19 18:27
---UIPlaceWorldBuildView.lua

local UIPlaceWorldBuildView = BaseClass("UIPlaceWorldBuildView",UIBaseView)
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
    self.curIndex = 0--当前所在坐标点
    self.noPutPoint = {}--不可放置的点
    self.useMainBuildGreen = {}
    self.freeMainBuildGreen = {}
    self.putState = BuildPutState.None
    self.buildTemplate = nil
    self.needPosFree = {}
    self.needDoCancelFunction = true--放置外部关闭界面
    self.sendCount = 0
    self.allPoint = nil
end

local function DataDestroy(self)
    WorldAlCenterSelectEffectManager:GetInstance():HidePos()
    PlaceAllianceCenterEffectManager:GetInstance():QuitPlaceAllianceCenterMode()
    DataCenter.BuildManager:SetShowPutBuildFromPanel(nil)
    self.allPoint = nil
    self.param = nil
    self.isInGuide = nil
    self.curIndex = nil
    self.noPutPoint = nil
    self.useMainBuildGreen = nil
    self.freeMainBuildGreen = nil
    self.putState = nil
    self.buildTemplate = nil
    self.needPosFree = nil
    self.needDoCancelFunction = false
    self.sendCount = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
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
        self.param.buildId = tonumber(buildId)
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
    
    self.allianceBuildTemplate = DataCenter.AllianceMineManager:GetAllianceMineTemplate(buildId)
    if self.allianceBuildTemplate then
        self.tile = self.allianceBuildTemplate.resSize
    end
    if (buildId == BuildingTypes.ALLIANCE_FLAG_BUILD or WorldAllianceBuildUtil.IsAllianceFrontGroup(buildId)) and self.allianceBuildTemplate~=nil then
        local name = Localization:GetString(self.allianceBuildTemplate.name)
        self._wormHoleTips_img:SetActive(true)
        self._wormHoleTips_txt:SetText(Localization:GetString("110540",name))
    elseif WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) and self.allianceBuildTemplate~=nil then
        self._wormHoleTips_img:SetActive(true)
        local name = Localization:GetString(self.allianceBuildTemplate.name)
        local level = ""
        local dic = table.keys(self.allianceBuildTemplate.place_ruin_dic)
        if dic~=nil and #dic>0 then
            level = dic[1]
        end
        if buildId == BuildingTypes.ALLIANCE_CENTER_1 then
            self._wormHoleTips_txt:SetText(Localization:GetString("110587",name,level))
        else
            self._wormHoleTips_txt:SetText(Localization:GetString("110588",name,level))
        end
    else
        self._wormHoleTips_img:SetActive(false)
        self._wormHoleTips_txt:SetText("")
    end
    

    local willPos = nil
    if point ~= nil and point > 0 then
        willPos = SceneUtils.TileIndexToWorld(point)
    else
        willPos = CS.SceneManager.World.CurTarget
    end
    self:ChangeIndex(SceneUtils.WorldToTileIndex(willPos))
    --if WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) then
    --    --zoom = CS.LookAtFocusState.MoveCity
        GoToUtil.GotoWorldPos(willPos + self:GetDeltaPosDelta(self.tile),31,LookAtFocusTime,function()
            CS.SceneManager.World:SetCameraMaxHeight(69)
        end,LuaEntry.Player:GetCurServerId())
    
    --else
    
    --end
    

    if WorldAllianceBuildUtil.IsAllianceCenterGroup(buildId) then
        if self.allianceBuildTemplate~=nil then
            local showEmpty = (buildId == BuildingTypes.ALLIANCE_CENTER_1)
            local list = self.allianceBuildTemplate.place_ruin_dic
            PlaceAllianceCenterEffectManager:GetInstance():EnterPlaceAllianceCenterMode(list,showEmpty)
        end
    end
    self:LoadBuildSelect()
    self:ChangeSelectBuild()
    self:SetBuildInfo()
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
    self:AddUIListener(EventId.UICreateFakePlaceAllianceBuild, self.UICreateFakePlaceBuildSignal)
    self:AddUIListener(EventId.UIPlaceAllianceBuildChangePos, self.UIPlaceBuildChangePosSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
    self:RemoveUIListener(EventId.UICreateFakePlaceAllianceBuild, self.UICreateFakePlaceBuildSignal)
    self:RemoveUIListener(EventId.UIPlaceAllianceBuildChangePos, self.UIPlaceBuildChangePosSignal)
end

local function SetBuildInfo(self)
    if self.allianceBuildTemplate then
        local buildIcon = self.allianceBuildTemplate:GetIconPath()
        self.build_icon:LoadSprite(buildIcon)
        self.build_name:SetLocalText(self.allianceBuildTemplate.name)
        self.build_des:SetLocalText(self.allianceBuildTemplate.desc)
    end
end

local function ClosePanel(self)
    EventManager:GetInstance():Broadcast(EventId.UpdateFakeBuildingPos)
    if CS.SceneManager.World ~= nil then
        CS.SceneManager.World:SetUseInput(true)
        CS.SceneManager.World:SetTouchInputControllerEnable(true)
        DataCenter.BuildBubbleManager:ShowBubbleNode()
        CS.SceneManager.World.touchPickablePos:Clear()
        CS.SceneManager.World.SelectBuild = nil
        CS.SceneManager.World:ResetCameraMaxHeight()
    end
end

local function OnConfirmBtnClick(self)
    EventManager:GetInstance():Broadcast(EventId.OnClickPlaceBuild)
    if self.param.topType == PlaceBuildType.Build then
        local serverId = LuaEntry.Player:GetCurServerId()
        SFSNetwork.SendMessage(MsgDefines.BuildAllianceMine, self.curIndex, self.param.buildId,serverId)
        CS.SceneManager.World:UIDestroyRreCreateAllianceBuild()
    end
    self.ctrl:CloseSelf()
end

local function OnCancelBtnClick(self)
    if self.param.topType ~= PlaceBuildType.Move and CS.SceneManager.World then
        CS.SceneManager.World:UIDestroyRreCreateAllianceBuild()
    end
    self.needDoCancelFunction = false
    self.ctrl:CloseSelf()
end

local function OnBackClick(self)
    local buildId = self.param.buildId
    local backToWindow = DataCenter.BuildManager:GetShowPutBuildFromPanel()
    self:OnCancelBtnClick()
    if backToWindow ~= nil and backToWindow ~= "" then
        UIManager:GetInstance():OpenWindow(backToWindow, buildId)
    end
end


local function LoadBuildSelect(self)
    --local model = string.format(UIAssets.BuildSelect,self.tile, self.tile)
    --if WorldAllianceBuildUtil.IsAllianceCenterGroup(self.param.buildId) == true then
    --    model =  "Assets/Main/Prefabs/Building/BuildSelectAllianceCity.prefab"
    --end
    --self:GameObjectInstantiateAsync(model, function(request)
    --    if request.isError then
    --        return
    --    end
    --    local go = request.gameObject
    --    if go ~= nil then
    --        go:SetActive(true)
    --        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
    --        self.buildSelect = go:GetComponent(typeof(CS.BuildSelect))
    --        self:RefreshBuildSelect()
    --    end
    --end)
end

local function RefreshBuildSelect(self)
    if self.buildSelect ~= nil then
		local v = SceneUtils.TileIndexToWorld(self.curIndex) + BlockPos
        self.buildSelect.transform:Set_position(v.x, v.y, v.z) 
        self.buildSelect:ChangeColor(self.putState == BuildPutState.Ok)
    end
    if WorldAllianceBuildUtil.IsAllianceCenterGroup(self.param.buildId) == true then
        WorldAlCenterSelectEffectManager:GetInstance():ShowPos(self.curIndex,self.putState)
    end
    
end

local function ChangeIndex(self,index)
    self.curIndex = index
    local lastPutState = self.putState
    self.putState = WorldAllianceBuildUtil.IsCanPutDownByAllianceBuild(self.param.buildId, index)
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
        elseif self.putState == BuildPutState.NotNearAlRuin then
            str = Localization:GetString(GameDialogDefine.NO_PUT_RANGE)
        elseif self.putState == BuildPutState.AlResNotEnough then
            str = Localization:GetString(GameDialogDefine.NO_PUT_RANGE)
        elseif self.putState == BuildPutState.OutBuildZone then
        elseif self.putState == BuildPutState.InBlackLandRange then
            str = Localization:GetString("250108")
        elseif self.putState == BuildPutState.NotConnectDesert then
            str = Localization:GetString("302739")
        elseif self.putState == BuildPutState.MoveCityNotInUnLockRange then
            str = Localization:GetString("111065")
        elseif self.putState == BuildPutState.CanNotPlaceEdenSubway then
            str = Localization:GetString("111067",
                    Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.param.buildId + 1,"name")))
        elseif self.putState == BuildPutState.AllianceBuildNotInBirthRange then
            str = Localization:GetString("111078")
        elseif self.putState == BuildPutState.AllianceMineNotInBirthRange then
            str = Localization:GetString("111069")
        elseif self.putState == BuildPutState.AllianceEdenMineCanNotReach then
            str = Localization:GetString("111265")
        elseif self.putState == BuildPutState.NoInAllianceCenterRange then
            str = Localization:GetString(GameDialogDefine.NO_PUT_RANGE)
            if self.buildTemplate ~= nil then
                local allianceCenterId = tonumber(self.buildTemplate.para1)
                if allianceCenterId~=nil and allianceCenterId>0 then
                    local template = DataCenter.AllianceMineManager:GetAllianceMineTemplate(allianceCenterId)
                    if template~=nil then
                        local buildName = Localization:GetString(template.name)
                        str = Localization:GetString("302740",buildName)
                    end
                end
            end
           
        end
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
end

local function UpdatePointDataSignal(self)
    self:ChangeIndex(self.curIndex)
end


local function UICreateFakePlaceBuildSignal(self)
    self:ChangeSelectBuild()
end

local function ChangeSelectBuild(self)
    if CS.SceneManager.World.SelectBuild ~= nil then
        self.AutoAdjustScreenPos:Init(CS.SceneManager.World.SelectBuild.transform, self:GetDeltaPosDelta(self.tile))
    end
end


local function GetDeltaPosDelta(self, tile)
    local temp = (tile - 1)  / 2
    return  Vector3.New(-temp,0,-temp)
end



UIPlaceWorldBuildView.OnCreate= OnCreate
UIPlaceWorldBuildView.OnDestroy = OnDestroy
UIPlaceWorldBuildView.OnEnable = OnEnable
UIPlaceWorldBuildView.OnDisable = OnDisable
UIPlaceWorldBuildView.OnAddListener = OnAddListener
UIPlaceWorldBuildView.OnRemoveListener = OnRemoveListener
UIPlaceWorldBuildView.ComponentDefine = ComponentDefine
UIPlaceWorldBuildView.ComponentDestroy = ComponentDestroy
UIPlaceWorldBuildView.DataDefine = DataDefine
UIPlaceWorldBuildView.DataDestroy = DataDestroy
UIPlaceWorldBuildView.ReInit = ReInit
UIPlaceWorldBuildView.ClosePanel = ClosePanel
UIPlaceWorldBuildView.OnConfirmBtnClick = OnConfirmBtnClick
UIPlaceWorldBuildView.OnCancelBtnClick = OnCancelBtnClick
UIPlaceWorldBuildView.RefreshBuildSelect = RefreshBuildSelect
UIPlaceWorldBuildView.LoadBuildSelect = LoadBuildSelect
UIPlaceWorldBuildView.UIPlaceBuildChangePosSignal = UIPlaceBuildChangePosSignal
UIPlaceWorldBuildView.ChangeIndex = ChangeIndex
UIPlaceWorldBuildView.RefreshNoReason = RefreshNoReason
UIPlaceWorldBuildView.UpdatePointDataSignal = UpdatePointDataSignal
UIPlaceWorldBuildView.UICreateFakePlaceBuildSignal = UICreateFakePlaceBuildSignal
UIPlaceWorldBuildView.ChangeSelectBuild = ChangeSelectBuild
UIPlaceWorldBuildView.SetBuildInfo = SetBuildInfo
UIPlaceWorldBuildView.OnBackClick = OnBackClick
UIPlaceWorldBuildView.GetDeltaPosDelta = GetDeltaPosDelta

return UIPlaceWorldBuildView