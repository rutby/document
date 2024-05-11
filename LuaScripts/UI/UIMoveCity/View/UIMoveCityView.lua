---
--- 放置建筑界面
--- Created by shimin.
--- DateTime: 2021/10/19 18:27
---
local UIMoveCityView = BaseClass("UIMoveCityView",UIBaseView)
local EdenSpecialMoveItem = require "UI.UIMoveCity.Component.EdenSpecialMoveItem"
local base = UIBaseView
local Localization = CS.GameEntry.Localization
--local box_collider_path = "BoxCollider"
local confirm_btn_path = "BtnGo/common_btn_confirm"
local use_gold_path = "BtnGo/common_btn_confirm/Rect_BtnNameBg"
local gold_num_path = "BtnGo/common_btn_confirm/Rect_BtnNameBg/Txt_BtnName"
local cancel_btn_path = "BtnGo/common_btn_cancel"
local reason_text_path = "common_bg3/reason_text"
local reason_red_text_path = "common_bg3/reason_red_text"

local btn_go_path = "BtnGo"

local eden_move_item_path = "area"
local build_icon_path = "common_bg3/build_icon"
local build_name_path = "common_bg3/build_name"
local build_des_path = "common_bg3/build_des"
local back_btn_path = "common_bg3/back_btn"

local wormHoleTips_img_path = "Img_WormHole"
local wormHoleTips_txt_path = "Img_WormHole/Txt_WormHoleTips"

local TilePosDelta =
{
    Vector3.New(0,0,0),
    Vector3.New(-1,0,-1),
    Vector3.New(-2,0,-2)
}

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
    self.eden_move_item = self:AddComponent(EdenSpecialMoveItem,eden_move_item_path)
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
    self.use_gold = self:AddComponent(UIBaseContainer,use_gold_path)
    self.gold_num = self:AddComponent(UITextMeshProUGUIEx,gold_num_path)
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
    self.needMoveNewPos = false
    self.curIndex = 0--当前所在坐标点
    self.noPutPoint = {}--不可放置的点
    self.useMainBuildGreen = {}
    self.freeMainBuildGreen = {}
    self.putState = BuildPutState.None
    self.buildTemplate = nil
    self.needPosFree = {}
    self.needDoCancelFunction = true--放置外部关闭界面
    self.needGetGold = false
    self.selectItemId = ""
end

local function DataDestroy(self)
    DataCenter.BuildManager:SetShowPutBuildFromPanel(nil)
    self.param = nil
    self.isInGuide = nil
    self.needMoveNewPos = nil
    self.curIndex = nil
    self.noPutPoint = nil
    self.useMainBuildGreen = nil
    self.freeMainBuildGreen = nil
    self.putState = nil
    self.buildTemplate = nil
    self.needPosFree = nil
    self.needDoCancelFunction = false
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.needGetGold = false
    self.selectItemId = ""
    self.eden_move_item:RefreshData()
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
        DataCenter.BuildManager:SetOnMovingBuildUuid(self.param.buildUuid)
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
    
    self.tile= 3
    --self.buildTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(buildId)
    --if self.buildTemplate ~= nil then
    --    self.tile = self.buildTemplate.tiles
    --end
    self._wormHoleTips_img:SetActive(false)
    local willPos = CS.SceneManager.World.CurTarget
    self:ChangeIndex(SceneUtils.WorldToTileIndex(willPos))
    GoToUtil.GotoWorldPos(willPos+TilePosDelta[self.tile],150,LookAtFocusTime,function()
        CS.SceneManager.World:SetCameraMaxHeight(250)
    end,LuaEntry.Player:GetCurServerId())
    --CS.SceneManager.World:AutoFocus(willPos+TilePosDelta[self.tile],CS.LookAtFocusState.PlaceBuild, LookAtFocusTime, true, false, function()
    --end)
    DataCenter.BuildBubbleManager:HideBubbleNode()
    --DataCenter.GovernmentWorldBubbleManager:RemoveOneBubble(self.param.buildUuid)
    self:LoadBuildSelect()
    self:ChangeSelectBuild()
    self:SetBuildInfo()
    if self.buildTemplate ~= nil and self.buildTemplate.build_type == BuildType.Normal then
        EventManager:GetInstance():Broadcast(EventId.ShowCanBuildEffect)
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UIPlaceBuildChangePos, self.UIPlaceBuildChangePosSignal)
    self:AddUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UIPlaceBuildChangePos, self.UIPlaceBuildChangePosSignal)
    self:RemoveUIListener(EventId.UPDATE_POINTS_DATA, self.UpdatePointDataSignal)
end

local function SetBuildInfo(self)
    local level = 1
    local buildData = DataCenter.BuildManager:GetBuildingDataByUuid(self.param.buildUuid)
    if buildData ~= nil then
        level = buildData.level
    end
    local id = self.param.buildId + level
    self.build_icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId, level))
    if self.param.topType == PlaceBuildType.MoveCity or self.param.topType == PlaceBuildType.MoveCity_Al or self.param.topType == PlaceBuildType.MoveCity_Cmn then
        if self.useFreeAlMove then
            local tempCount = self.item and self.item.count or 0
            self.build_name:SetText(Localization:GetString("110228", tempCount) .. "(" .. Localization:GetString("121059") .. ")")
            self.build_des:SetText(Localization:GetString("110229"))
        elseif self.item then
            local strName = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), id,"name"))
            local strDesc = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), id,"description"))
            if self.item.itemId == SpecialItemId.ITEM_MOVE_CITY then
                local tempCount = self.item.count or 0
                strName = Localization:GetString("110230", tempCount)
                strDesc = Localization:GetString("110231")
            elseif self.item.itemId == SpecialItemId.ITEM_ALLIANCE_CITY_MOVE then
                local tempCount = self.item.count or 0
                strName = Localization:GetString("110228", tempCount)
                strDesc = Localization:GetString("110229")
            elseif self.item.itemId == SpecialItemId.ITEM_BLACK_DESERT_CITY_MOVE then
                local tempCount = self.item.count or 0
                strName = Localization:GetString("250138", tempCount)
                strDesc = Localization:GetString("250139")
            end
            self.build_name:SetText(strName)
            self.build_des:SetText(strDesc)
        elseif self.selectItemId~=nil and self.selectItemId~="" then
            local strName = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), id,"name"))
            local strDesc = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), id,"description"))
            if self.selectItemId == SpecialItemId.ITEM_MOVE_CITY then
                local tempCount =  0
                strName = Localization:GetString("110230", tempCount)
                strDesc = Localization:GetString("110231")
            elseif self.selectItemId == SpecialItemId.ITEM_ALLIANCE_CITY_MOVE then
                local tempCount =  0
                strName = Localization:GetString("110228", tempCount)
                strDesc = Localization:GetString("110229")
            elseif self.selectItemId == SpecialItemId.ITEM_BLACK_DESERT_CITY_MOVE then
                local tempCount =  0
                strName = Localization:GetString("250138", tempCount)
                strDesc = Localization:GetString("250139")
            end
            self.build_name:SetText(strName)
            self.build_des:SetText(strDesc)
        else
            if self.param.topType == PlaceBuildType.MoveCity_Al then
                self.build_name:SetText(Localization:GetString("110228", 0))
                self.build_des:SetText(Localization:GetString("110229"))
            else
                if SceneUtils.IsInBlackRange(self.curIndex) then
                    self.build_name:SetText(Localization:GetString("250138", 0))
                    self.build_des:SetText( Localization:GetString("250139"))
                else
                    self.build_name:SetText(Localization:GetString("110230", 0))
                    self.build_des:SetText(Localization:GetString("110231"))
                end

            end
        end
    else
        self.build_name:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), id,"name"))
        self.build_des:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), id,"description"))
    end
end

local function ClosePanel(self)
    DataCenter.BuildManager:SetOnMovingBuildUuid(0)
    if self.needDoCancelFunction then
        self:OnCancelBtnClick()
    end
    EventManager:GetInstance():Broadcast(EventId.FakeBuildingSelectLocation)
    EventManager:GetInstance():Broadcast(EventId.UpdateFakeBuildingPos)
    if self.param then
        EventManager:GetInstance():Broadcast(EventId.HideBuildTopUI,self.param.buildUuid)
    end
    EventManager:GetInstance():Broadcast(EventId.HideCanBuildEffect)
    if CS.SceneManager.World ~= nil then
        CS.SceneManager.World:SetUseInput(true)
        CS.SceneManager.World:ResetCameraMaxHeight()
        CS.SceneManager.World:SetTouchInputControllerEnable(true)
        DataCenter.BuildBubbleManager:ShowBubbleNode()
        CS.SceneManager.World.touchPickablePos:Clear()
        if CS.SceneManager.World.SelectBuild ~= nil then
            CS.SceneManager.World.SelectBuild.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("Default"))
        end
        CS.SceneManager.World.SelectBuild = nil
        CS.SceneManager.World:UIDestroyRreCreateBuild()
        if self.param and (self.param.topType == PlaceBuildType.MoveCity or self.param.topType == PlaceBuildType.MoveCity_Al
                or self.param.topType == PlaceBuildType.MoveCity_Cmn) then
            if CS.SceneManager.World ~= nil then
                local temp = CS.SceneManager.World:GetWorldBuildingByUuid(self.param.buildUuid)
                if temp ~= nil then
                    temp:SetMoveState(false)
                    --if self.needMoveNewPos then
                    --    temp.transform.position = SceneUtils.TileIndexToWorld(self.curIndex)
                    --end
                end
            end
        end
    end
end

local function OnConfirmBtnClick(self)
    EventManager:GetInstance():Broadcast(EventId.OnClickPlaceBuild)
    if self.param.topType == PlaceBuildType.MoveCity or self.param.topType == PlaceBuildType.MoveCity_Al
        or self.param.topType == PlaceBuildType.MoveCity_Cmn then
        if self.curIndex == self.param.point then
            self:OnCancelBtnClick()
            return
        end
        --if self.param and self.param.useItemId then
        --    self.item = DataCenter.ItemData:GetItemById(self.param.useItemId)
        --else
        --    self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
        --end
        if self.needGetGold then
            self.ctrl:CloseSelf()
            GoToUtil.GotoPayTips()
           return
        end
        if self.useFreeAlMove or (self.selectItemId~=nil and self.selectItemId~="") then
            local param = {}
            param.itemId = self.selectItemId
            param.pointId = self.curIndex
            param.freeAllianceMove = self.useFreeAlMove
            if LuaEntry.Player.serverType == ServerType.EDEN_SERVER and LuaEntry.DataConfig:CheckSwitch("eden_fight_area_broken_shield") then
                local pos = self.curIndex
                local areaId = CS.SceneManager.World:GetAreaIdByPosId(pos-1)
                local myAllow = true
                local areaTemp = DataCenter.EdenAreaTemplateManager:GetTemplate(areaId)
                if areaTemp~=nil then
                    if areaTemp.area_type ~= EdenAreaType.NORTH_BORN_AREA and areaTemp.area_type ~= EdenAreaType.SOUTH_BORN_AREA then
                        myAllow = false
                    end
                end
                if myAllow ==false then
                    local defenceWar = DataCenter.DefenceWallDataManager:GetDefenceWallData()
                    if defenceWar~=nil then
                        local protectEndTime = defenceWar.protectEndTime
                        local leftTime = protectEndTime - UITimeManager:GetInstance():GetServerTime()
                        if leftTime>0 then
                            UIUtil.ShowMessage(Localization:GetString("111234"),1,"110006",nil,function ()
                                SFSNetwork.SendMessage(MsgDefines.WorldMv,param)
                                self.needMoveNewPos = true
                                self.needDoCancelFunction = false
                                self.ctrl:CloseSelf()
                            end,function()
                                self.needMoveNewPos = true
                                self.needDoCancelFunction = false
                                self.ctrl:CloseSelf()
                            end,function()
                                self.needMoveNewPos = true
                                self.needDoCancelFunction = false
                                self.ctrl:CloseSelf()
                            end)
                            return
                        end
                    end
                end
            end
            SFSNetwork.SendMessage(MsgDefines.WorldMv,param)
            self.needMoveNewPos = true
            self.needDoCancelFunction = false
            self.ctrl:CloseSelf()
        else
            UIUtil.ShowTipsId(120021)
            self.ctrl:CloseSelf()
        end
    end
end

local function OnCancelBtnClick(self)
    self.needMoveNewPos = false
    self.needDoCancelFunction = false
    if self.param then
        --DataCenter.GovernmentWorldBubbleManager:CheckAndOperateBubble(self.param.buildUuid)
    end
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

--显示白色地块
local function ShowBlock(self)
    if self.buildTemplate ~= nil and self.buildTemplate.build_type == BuildType.Second and table.count(self.useMainBuildGreen) > 0 then
        return
    end
    local needAdd = {}
    local use = {}
    local list = BuildingUtils.GetAllCanPutPointsByBuildId(self.curIndex,self.param.buildId,self.param.buildUuid,true)
    if list ~= nil and #list > 0 then
        for k,v in pairs(list) do
            local index = v
            if self.useMainBuildGreen[index] == nil then
                table.insert(needAdd,index)
            else
                use[index] = self.useMainBuildGreen[index]
                self.useMainBuildGreen[index] = nil
            end
        end
        self.needPosFree = self.useMainBuildGreen
        self.useMainBuildGreen = use
        for k,v in ipairs(needAdd) do
            self:ShowOneBlock(v)
        end
        if table.count(self.needPosFree) > 0 then
            for k1,v1 in pairs(self.needPosFree) do
                v1:SetActive(false)
                table.insert(self.freeMainBuildGreen,v1)
            end
            self.needPosFree = {}
        end
    else
        for k,v in pairs(self.useMainBuildGreen) do
            v:SetActive(false)
            table.insert(self.freeMainBuildGreen,v)
        end
        self.useMainBuildGreen = {}
    end
end

local function ShowOneBlock(self, index)
    if table.count(self.needPosFree) > 0 then
        local go = nil
        local useIndex = 0
        for k,v in pairs(self.needPosFree) do
            go = v
            useIndex = k
        end
        if go ~= nil then
            self.needPosFree[useIndex] = nil
            go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos
            self.useMainBuildGreen[index] = go
        end
    elseif table.count(self.freeMainBuildGreen) > 0 then
        local go = table.remove(self.freeMainBuildGreen)
        if go ~= nil then
            go:SetActive(true)
            go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos
            self.useMainBuildGreen[index] = go
        end
    else
        self:GameObjectInstantiateAsync(UIAssets.BuildBlock, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform.position = SceneUtils.TileIndexToWorld(index) + BlockPos
            self.useMainBuildGreen[index] = go

        end)
    end
end

local function LoadBuildSelect(self)
    self:GameObjectInstantiateAsync(string.format(UIAssets.BuildSelect,self.tile, self.tile) , function(request)
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
    local canMove, tempState = self:TryChangeUseItem()
    self.putState = canMove and BuildingUtils.IsCanPutDownByBuild(self.param.buildId, index,self.param.buildUuid,nil,true) or tempState
    self:RefreshNoReason(lastPutState ~= self.putState,lastPutState == BuildPutState.None or ((lastPutState == BuildPutState.Ok) ~= (self.putState == BuildPutState.Ok)),tempState == BuildPutState.ItemLack)
    self:RefreshBuildSelect()
    self:ShowBlock()
end

local function TryChangeUseItem(self)
    if not (self.param.topType == PlaceBuildType.MoveCity or self.param.topType == PlaceBuildType.MoveCity_Cmn or self.param.topType == PlaceBuildType.MoveCity_Al) then
        return true
    end
    self.selectItemId = ""
    self.useFreeAlMove = false
    local useItemId = nil
    if self.param.topType == PlaceBuildType.MoveCity_Al then
        useItemId = SpecialItemId.ITEM_ALLIANCE_CITY_MOVE
    elseif self.param.topType == PlaceBuildType.MoveCity_Cmn then
        useItemId = SpecialItemId.ITEM_MOVE_CITY
    end
    
    local hasAlTerritory = DataCenter.WorldAllianceCityDataManager:CheckIfHasAlCity()
    local isAlTerritory = DataCenter.WorldAllianceCityDataManager:CheckIfIsAlTerritory(self.curIndex)
    if useItemId then
        self.item = DataCenter.ItemData:GetItemById(useItemId)
        self.selectItemId = useItemId
        if useItemId == SpecialItemId.ITEM_ALLIANCE_CITY_MOVE then
            if  SceneUtils.IsInBlackRange(self.curIndex) then
                return false,BuildPutState.InBlackLandRange
            end
            if LuaEntry.Player:CheckIfHasFreeAlMove() then
                self.useFreeAlMove = true
            end
            if hasAlTerritory == false or isAlTerritory==false then
                if not DataCenter.AllianceBaseDataManager:CheckIfCanAlMove(self.curIndex,hasAlTerritory) then
                    self:SetBuildInfo()
                    return false, BuildPutState.NotInAlArea
                end
            end
        end
    else
        if hasAlTerritory and isAlTerritory then
            if  SceneUtils.IsInBlackRange(self.curIndex) then
                self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_BLACK_DESERT_CITY_MOVE)
                self.selectItemId = SpecialItemId.ITEM_BLACK_DESERT_CITY_MOVE
            else
                self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_ALLIANCE_CITY_MOVE)
                self.selectItemId = SpecialItemId.ITEM_ALLIANCE_CITY_MOVE
                if LuaEntry.Player:CheckIfHasFreeAlMove() then
                    self.useFreeAlMove = true
                end
                --如果没有联盟迁城，则自动改成高级迁城
                if not self.useFreeAlMove and (not self.item or self.item.count == 0) then
                    local tempItem = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
                    if (not tempItem or tempItem.count == 0) then

                    else
                        self.item = tempItem
                        self.selectItemId = SpecialItemId.ITEM_MOVE_CITY
                    end
                end
            end
            
        else
            if  SceneUtils.IsInBlackRange(self.curIndex) then
                self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_BLACK_DESERT_CITY_MOVE)
                self.selectItemId = SpecialItemId.ITEM_BLACK_DESERT_CITY_MOVE
                --if (not self.item or self.item.count == 0) then
                --    local tempItem = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
                --    if (not tempItem or tempItem.count == 0) then
                --
                --    else
                --        self.item = tempItem
                --        self.selectItemId = SpecialItemId.ITEM_MOVE_CITY
                --    end
                --end
            else
                if DataCenter.AllianceBaseDataManager:CheckIfCanAlMove(self.curIndex,hasAlTerritory) then
                    self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_ALLIANCE_CITY_MOVE)
                    self.selectItemId = SpecialItemId.ITEM_ALLIANCE_CITY_MOVE
                    if LuaEntry.Player:CheckIfHasFreeAlMove() then
                        self.useFreeAlMove = true
                    end
                    if not self.useFreeAlMove and (not self.item or self.item.count == 0) then
                        local tempItem = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
                        if (not tempItem or tempItem.count == 0) then

                        else
                            self.item = tempItem
                            self.selectItemId = SpecialItemId.ITEM_MOVE_CITY
                        end
                    end
                else
                    self.item = DataCenter.ItemData:GetItemById(SpecialItemId.ITEM_MOVE_CITY)
                    self.selectItemId = SpecialItemId.ITEM_MOVE_CITY
                end
            end
            
        end
    end
    self:SetBuildInfo()
    
    local hasItem = self.useFreeAlMove or (self.item and self.item.count > 0)
    if hasItem then
        return true
    else
        local configOpenState = LuaEntry.DataConfig:CheckSwitch("gem_teleport")
        if configOpenState then
            return true, BuildPutState.ItemLack
        else
            return false, BuildPutState.ItemLack
        end
        
    end
end

local function UIPlaceBuildChangePosSignal(self,data)
    if data ~= nil and data ~= "" then
        local pointId = tonumber(data)
        if self.curIndex ~= pointId then
            self:ChangeIndex(pointId)
        end
    end
end

local function RefreshNoReason(self,isChangeReason,isChangeOk,needBuyItem)
    if isChangeOk then
        self.needGetGold = false
        if self.putState == BuildPutState.Ok then
            self.confirm_btn:SetInteractable(true)
            self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm")
            local configOpenState = LuaEntry.DataConfig:CheckSwitch("gem_teleport")
            if configOpenState and needBuyItem and self.selectItemId~=nil and self.selectItemId~="" then
                local itemId = self.selectItemId
                local goods = DataCenter.ItemTemplateManager:GetItemTemplate(itemId)
                if goods~=nil and goods.price~=nil and goods.price>0 then
                    self.use_gold:SetActive(true)
                    local cost = goods.price
                    self.gold_num:SetText(string.GetFormattedSeperatorNum(toInt(cost)))
                    if LuaEntry.Player.gold >= cost then
                        self.gold_num:SetColor(WhiteColor)
                    else
                        self.gold_num:SetColor(RedColor)
                        self.needGetGold = true
                    end
                else
                    self.use_gold:SetActive(false)
                end
                
            else
                self.use_gold:SetActive(false)
            end
        else
            self.confirm_btn:SetInteractable(false)
            self.confirm_img:LoadSprite("Assets/Main/Sprites/UI/UIBuildBtns/uibuild_btn_confirm_gray")
        end
    end

    if isChangeReason then
        local str = Localization:GetString("130013")
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
        elseif self.putState == BuildPutState.ItemLack then
            str = Localization:GetString("120021")
        elseif self.putState == BuildPutState.NotInAlArea then
            str = Localization:GetString("120294")
        elseif self.putState == BuildPutState.MoveCityNotInUnLockRange then
            str = Localization:GetString("111065")
        elseif self.putState == BuildPutState.CanNotPlaceEdenSubway then
            str = Localization:GetString("111067",Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), 
                    self.param.buildId + 1,"name")))
        elseif self.putState == BuildPutState.AllianceBuildNotInBirthRange then
            str = Localization:GetString("111078")
        elseif self.putState == BuildPutState.AllianceMineNotInBirthRange then
            str = Localization:GetString("111069")
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



local function ChangeSelectBuild(self)
    if CS.SceneManager.World.SelectBuild ~= nil then
        self.AutoAdjustScreenPos:Init(CS.SceneManager.World.SelectBuild.transform,TilePosDelta[self.tile])
    end
end



UIMoveCityView.OnCreate= OnCreate
UIMoveCityView.OnDestroy = OnDestroy
UIMoveCityView.OnEnable = OnEnable
UIMoveCityView.OnDisable = OnDisable
UIMoveCityView.OnAddListener = OnAddListener
UIMoveCityView.OnRemoveListener = OnRemoveListener
UIMoveCityView.ComponentDefine = ComponentDefine
UIMoveCityView.ComponentDestroy = ComponentDestroy
UIMoveCityView.DataDefine = DataDefine
UIMoveCityView.DataDestroy = DataDestroy
UIMoveCityView.ReInit = ReInit
UIMoveCityView.ClosePanel = ClosePanel
UIMoveCityView.OnConfirmBtnClick = OnConfirmBtnClick
UIMoveCityView.OnCancelBtnClick = OnCancelBtnClick
UIMoveCityView.ShowBlock = ShowBlock
UIMoveCityView.RefreshBuildSelect = RefreshBuildSelect
UIMoveCityView.LoadBuildSelect = LoadBuildSelect
UIMoveCityView.UIPlaceBuildChangePosSignal = UIPlaceBuildChangePosSignal
UIMoveCityView.ChangeIndex = ChangeIndex
UIMoveCityView.TryChangeUseItem = TryChangeUseItem
UIMoveCityView.RefreshNoReason = RefreshNoReason
UIMoveCityView.UpdatePointDataSignal = UpdatePointDataSignal
UIMoveCityView.ShowOneBlock = ShowOneBlock
UIMoveCityView.ChangeSelectBuild = ChangeSelectBuild
UIMoveCityView.SetBuildInfo = SetBuildInfo
UIMoveCityView.OnBackClick = OnBackClick

return UIMoveCityView