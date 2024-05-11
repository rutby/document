---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 2021/12/14 16:22
---
local UIPersonalWarning = BaseClass("UIPersonalWarning",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local bg_btn_path = "mainContent/BgButton"
local left_pos_btn_path = "mainContent/left/layout/leftNameTxt/leftPosTxt/leftPosBtn"
local pos_txt_path = "mainContent/left/layout/leftNameTxt/leftPosTxt"
local left_name_path = "mainContent/left/layout/leftNameTxt"
local left_name_btn_path = "mainContent/left/layout/leftNameTxt/leftNameBtn"
local warningType_txt_path = "mainContent/left/WarningType_Txt"
--local distance_obj_path = "mainContent/left/Image"
--local left_playerHead_path = "mainContent/left/lefthead/LeftUIPlayerHead/LeftHeadIcon"
--local distance_txt_path = "mainContent/left/Image/distanceTxt"
local right_rect_path = "mainContent/right"
local right_pos_btn_path ="mainContent/right/rightNameTxt/rightPosBtn"
local right_pos_txt_path = "mainContent/right/rightPosTxt"
local right_name_path = "mainContent/right/rightNameTxt"
local right_endTime_path = "mainContent/right/Txt_EndTime"
local right_otherPos_path = "mainContent/right/Btn_OtherPos"
local des_txt_path = "mainContent/left/layout/DesTxt"
local btn_prevent_path = "mainContent/Btn_prevent"
local btn_relieve_path = "mainContent/Btn_relieve"
local img_typeBg_path = "mainContent/type_ImgBg"
local txt_typeIcon_path = "mainContent/type_ImgBg/type_imgIcon"
local see_btn_path = "mainContent/Btn_See"
local see_txt_path = "mainContent/Btn_See/Txt_See"
local seeArmy_btn_path = "mainContent/Btn_SeeArmy"
local npc_frame_bg_path = "mainContent/type_ImgBg/NpcFrameBg"


local function OnCreate(self)
    base.OnCreate(self)
    self.isUpdate =false
    self.bg_btn = self:AddComponent(UIButton, see_btn_path)
    self.see_txt = self:AddComponent(UIText,see_txt_path)
    self.see_txt:SetLocalText(110076)
    self.bg_btn:SetOnClick(function ()
        self:OnBgClick()
    end)
    self.left_pos_btn = self:AddComponent(UIButton,left_pos_btn_path)
    self.left_pos_btn:SetOnClick(function ()
        self:OnLeftPosClick()
    end)
    self.left_name = self:AddComponent(UIText,left_name_path)
    self.left_name_btn = self:AddComponent(UIButton,left_name_btn_path)
    self.left_name_btn:SetOnClick(function ()
        self:OnLeftPlayerInfoClick()
    end)
    self._warningType_txt = self:AddComponent(UIText,warningType_txt_path)
    self._pos_txt = self:AddComponent(UIText,pos_txt_path)
    --self.distance_obj = self:AddComponent(UIBaseContainer,distance_obj_path)
    --self.distance_txt = self:AddComponent(UIText,distance_txt_path)
    self.right_rect = self:AddComponent(UIBaseContainer,right_rect_path)
    self.right_pos_btn = self:AddComponent(UIButton, right_pos_btn_path)
    self.right_pos_btn:SetOnClick(function ()
        self:OnRightPosClick()
    end)
    self.right_name = self:AddComponent(UIText,right_name_path)
    self._right_endTime_txt = self:AddComponent(UIText,right_endTime_path)
    --self.right_otherPos = self:AddComponent(UIButton,right_otherPos_path)
    --self.right_otherPos:SetOnClick(function ()
    --    self:OnRightMarchPosClick()
    --end)
    self.right_pos_txt = self:AddComponent(UIText,right_pos_txt_path)

    --self.left_playerHead = self:AddComponent(UIPlayerHead, left_playerHead_path)
    
    self._des_txt = self:AddComponent(UIText,des_txt_path)
    
    --屏蔽
    self._btn_prevent = self:AddComponent(UIButton, btn_prevent_path)
    self._btn_prevent:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnHideWarning()
    end)
    --解除屏蔽
    self._btn_relieve = self:AddComponent(UIButton, btn_relieve_path)
    self._btn_relieve:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnShowWarning()
    end)

    self._typeBg_img = self:AddComponent(UIImage,img_typeBg_path)
    self._typeIcon_img = self:AddComponent(UIImage,txt_typeIcon_path)
    
    self._timer_alliance = nil
    self._timer_action = function(temp)
        self:UpdateAllianceTime()
    end
    
    self._timer_personal = nil
    self._timer_action_temp = function(temp)
        self:UpdatePersonalTime()
    end
    
    self._seeArmy_btn = self:AddComponent(UIButton,seeArmy_btn_path)
    self._seeArmy_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRightMarchPosClick()
    end)
    self.npc_frame_bg = self:AddComponent(UIImage,npc_frame_bg_path)
end

local function OnDestroy(self)
    self.bg_btn = nil
    self.left_pos_btn = nil
    self.left_name = nil
    self._warningType_txt = nil
    self._pos_txt = nil
    --self.distance_obj = nil
    --self.distance_txt = nil
    self.right_pos_btn = nil
    self.right_name = nil
    self.right_pos_txt = nil
    self.isUpdate = nil
    --self.left_playerHead = nil
    self._des_txt = nil
    if self._timer_alliance ~= nil then
        self._timer_alliance:Stop()
        self._timer_alliance = nil
    end
    if self._timer_personal ~= nil then
        self._timer_personal:Stop()
        self._timer_personal = nil
    end
    base.OnDestroy(self)
end

local function SetBtnSeeState(self,state)
    if self.dataInfo then
        --侦察关闭查看详情
        if self.dataInfo.type == WarningType.Scout then
            self.bg_btn:SetActive(false)
        else
            self.bg_btn:SetActive(state)
        end
    end
end

local function RefreshData(self)
    self.isUpdate =false
    self.right_rect:SetActive(true)
    self._right_endTime_txt:SetActive(true)
    self.npc_frame_bg:SetActive(false)
    --number时为集结或者跨服被打
    if type(self.data) == "number" then
        self.bg_btn:SetActive(true)
        self.dataInfo = self.view.ctrl:GetWarItemData(self.data)
        local leftPos = SceneUtils.IndexToTilePos(self.dataInfo.leftPointId,ForceChangeScene.World)
        --local rightPos = SceneUtils.IndexToTilePos(self.dataInfo.rightPointId)
        self._pos_txt:SetActive(true)
        self._pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, leftPos.x, leftPos.y)
        --self.right_pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, rightPos.x, rightPos.y)
        --self.distance_obj:SetActive(self.dataInfo.leftDistance>0)
        --self.distance_txt:SetText(self.dataInfo.leftDistance..Localization:GetString(GameDialogDefine.KILOMETRE))
        self:UpdateAllianceTime()
        self:AddAllianceTimer()
        self._btn_prevent:SetActive(DataCenter.AllianceWarDataManager:GetIgnoreList(self.dataInfo.uuid) == 1)
        self._btn_relieve:SetActive(DataCenter.AllianceWarDataManager:GetIgnoreList(self.dataInfo.uuid) ~= 1)
        local list  = self.view.ctrl:GetAllSoldiersInfo(self.data)
        local num = 0
        for i, v in pairs(list) do
            num = num + v
        end
        self._des_txt:SetLocalText(310160,string.GetFormattedSeperatorNum(num))
        self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_img_redbg"))
        self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_attack"))
    else
        if self.data.isCross then
            self.right_rect:SetActive(false)
            self._btn_prevent:SetActive(false)
            self._btn_relieve:SetActive(false)
            self.bg_btn:SetActive(false)
            self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_img_redbg"))
            self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_attack"))
            self._warningType_txt:SetLocalText(110219,self.data.serverId)
        else
            self.bg_btn:SetActive(true)
            if self.data.isVirtual~=nil and self.data.isVirtual == true then
                self._pos_txt:SetActive(false)
                self._des_txt:SetText("")
                self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_img_greenbg"))
                self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_help"))
                self._warningType_txt:SetText("")
                self._btn_prevent:SetActive(false)
                self._btn_relieve:SetActive(false)
                self:UpdatePersonalTime()
                self:AddPersonalTimer()
            elseif self.data.isNpc then
                self.bg_btn:SetActive(false)
                self._pos_txt:SetActive(true)
                local leftPos = SceneUtils.IndexToTilePos(self.data.leftPointId, ForceChangeScene.World)
                self._pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, leftPos.x, leftPos.y)
                self._des_txt:SetText("")
                self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_img_hero_purple"))
                self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_img_hero"))
                self.npc_frame_bg:SetActive(true)
                self._warningType_txt:SetLocalText(110143) --攻
                if DataCenter.GuideNeedLoadManager:IsFakeNpcMarchHide() then
                    self._btn_relieve:SetActive(true)
                    self._btn_prevent:SetActive(false)
                else
                    self._btn_relieve:SetActive(false)
                    self._btn_prevent:SetActive(true)
                end
                self._right_endTime_txt:SetActive(false)
            else
                self._pos_txt:SetActive(false)
                self.dataInfo = self.view.ctrl:GetPersonalItemData(self.data.ownerFormationUuid)
                if not self.dataInfo then
                    if self._timer_personal ~= nil then
                        self._timer_personal:Stop()
                        self._timer_personal = nil
                    end
                    return
                end
                self._des_txt:SetText(self.dataInfo.soldierNum)
                if self.dataInfo.type == WarningType.Attack then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_img_redbg"))
                    self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_attack"))
                    self._warningType_txt:SetLocalText(110143) --攻
                elseif self.dataInfo.type == WarningType.Scout then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_img_orangebg"))
                    self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_scout"))
                    self._warningType_txt:SetLocalText(110142) --侦
                elseif self.dataInfo.type == WarningType.Assistance then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_img_bluebg"))
                    self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_assemble"))
                    self._warningType_txt:SetLocalText(110141) --增
                elseif self.dataInfo.type == WarningType.ResourceAssistance then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_img_greenbg"))
                    self._typeIcon_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_help"))
                end
                self:UpdatePersonalTime()
                self:AddPersonalTimer()
                self._btn_prevent:SetActive(not DataCenter.RadarAlarmDataManager:IsCancel(self.dataInfo.uuid))
                self._btn_relieve:SetActive(DataCenter.RadarAlarmDataManager:IsCancel(self.dataInfo.uuid))
            end
        end
    end
    if type(self.data) ~= "number" then
        if not self.data.isCross then
            if self.data.isVirtual~=nil and self.data.isVirtual == true then
                self.left_name:SetText(self.data.leftName)
                self.right_name:SetText(self.data.rightName)
            elseif self.data.isNpc then
                self.left_name:SetText(self.data.leftName)
                self.right_name:SetText(self.data.rightName)
            else
                self.left_name:SetText(self.dataInfo.leftName)
                self.right_name:SetText(self.dataInfo.rightName)
            end
        end
    else
        self.left_name:SetText(self.dataInfo.leftName)
        self.right_name:SetText(self.dataInfo.rightName)
    end
    --self.left_playerHead:SetData(self.dataInfo.attackUid,self.dataInfo.attackIcon,self.dataInfo.ownerIconVer)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.right_name.rectTransform)
end

local function SetData(self,data)
    --uuid为集结，table为个人marhch
    self.data = data
end

local function AddAllianceTimer(self)
    if self._timer_alliance == nil then
        self._timer_alliance = TimerManager:GetInstance():GetTimer(1, self._timer_action , self, false,false,false)
        self._timer_alliance:Start()
    end
end

--刷新集结时间
local function UpdateAllianceTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local deltaTime =0
    local maxTime =0
    local dialog = 141032
    if self.dataInfo.waitTime > curTime then
        self.isUpdate =true
        deltaTime = self.dataInfo.waitTime - curTime
        --maxTime = self.dataInfo.waitTime - self.dataInfo.createTime
        dialog = 141032
        self._warningType_txt:SetLocalText(141037)
    elseif self.dataInfo.marchTime > curTime then
        self.isUpdate =true
        deltaTime = self.dataInfo.marchTime - curTime
        --maxTime = self.dataInfo.marchTime - self.dataInfo.createTime
        dialog = 390789
        self._warningType_txt:SetLocalText(141039)
    else
        self.isUpdate =false
    end
    if not self.isUpdate then
        --当部队出发后，队长的结束时间为达到目的地时间
        if self.dataInfo.marchendTime > curTime then
            dialog = 141033
        else
            dialog = 141029
        end
        self._warningType_txt:SetLocalText(141038)
    end
    if self.isUpdate then
        self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
        if dialog == 141033 then
            self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.dataInfo.marchendTime - curTime))
        else
            self._right_endTime_txt:SetLocalText(dialog)
        end
    end
end

local function AddPersonalTimer(self)
    if self._timer_personal == nil then
        self._timer_personal = TimerManager:GetInstance():GetTimer(1, self._timer_action_temp , self, false,false,false)
        self._timer_personal:Start()
    end
end

--刷新个人攻击时间
local function UpdatePersonalTime(self)
    if self.data.isVirtual~=nil and self.data.isVirtual==true then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.data.endTime-curTime
        if deltaTime<=0 then
            self._right_endTime_txt:SetText("00:00:00")
            if self._timer_personal ~= nil then
                self._timer_personal:Stop()
                self._timer_personal = nil
                return
            end
        end
        self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
        if self.dataInfo.status == MarchStatus.MOVING or self.dataInfo.status == MarchStatus.CHASING then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            local deltaTime = self.dataInfo.endTime - curTime
            if deltaTime <= 0 then
                self._right_endTime_txt:SetLocalText(100150)
                if self._timer_personal ~= nil then
                    self._timer_personal:Stop()
                    self._timer_personal = nil
                end
            end
            self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        else
            self._right_endTime_txt:SetText("00:00:00")
        end
    end
end

local function OnLeftPosClick(self)
    if type(self.data) ~= "number" then
        if self.data.isVirtual~=nil and self.data.isVirtual==true then
            return
        elseif self.data.isNpc then
            self:GotoFakeNpcPos()
            return
        end
    end
    self.view.ctrl:OnClickPosBtn(self.dataInfo.leftPointId,false,nil,self.dataInfo.serverId,self.dataInfo.worldId)
end

local function OnRightPosClick(self)
    if type(self.data)~= "number" then
        if self.data.isVirtual~=nil and self.data.isVirtual==true then
            return
        elseif self.data.isNpc then
            self.view.ctrl:OnClickPosBtn(self.data.rightPointId,false,nil,self.data.serverId)
            GoToUtil.CloseAllWindows()
            return
        end
    end
    --当前在哪个服就查看哪个服
    self.view.ctrl:OnClickPosBtn(self.dataInfo.rightPointId,false,nil,self.dataInfo.serverId,self.dataInfo.worldId)
end

--查看敌方部队现在位置
local function OnRightMarchPosClick(self)
    if type(self.data) ~= "number" then
        --如果是跨服直接跳转
        if self.data.isCross then
            GoToUtil.CloseAllWindows()
            local position = SceneUtils.TileIndexToWorld(LuaEntry.Player:GetMainWorldPos(),ForceChangeScene.World)
            if self.data.serverId ~= LuaEntry.Player:GetSelfServerId() then
                local crossBuildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.WORM_HOLE_CROSS)
                if crossBuildData~=nil then
                    local targetServerId = crossBuildData.server
                    local pointId = crossBuildData.pointId
                    if pointId>0 then
                        position = SceneUtils.TileIndexToWorld(pointId,ForceChangeScene.World)
                        position.x = position.x-1
                        position.y = position.y
                        position.z = position.z-1
                    end
                end
            end
            GoToUtil.GotoWorldPos(position,CS.SceneManager.World.InitZoom,nil,function()
                --SFSNetwork.SendMessage(MsgDefines.GetAllianceWarList,LuaEntry.Player:GetCurServerId())
                --DataCenter.AllianceWarDataManager:ClearCrossServer(self.data.serverId)
            end,self.data.serverId)
        else
            if self.data.isVirtual~=nil and self.data.isVirtual==true then
                return
            elseif self.data.isNpc then
                self:GotoFakeNpcPos()
                return
            end
            local pos = self.data:GetMarchCurPos()
            self.view.ctrl:OnClickPosBtn(pos,true,self.data.uuid,self.data.serverId,self.data.worldId)
        end
    else
        local info = DataCenter.WorldMarchDataManager:GetMarch(self.dataInfo.leaderMarchUuid)
        if info then
            if info:GetMarchStatus() == MarchStatus.WAIT_RALLY then
                self.view.ctrl:OnClickPosBtn(self.dataInfo.leftPointId,false,nil,self.dataInfo.serverId)
            else
                local v3 = {}
                v3.x = info.position.x
                v3.y = info.position.y
                v3.z = info.position.z
                self.view.ctrl:OnClickPosBtn(v3,true,nil,self.dataInfo.serverId)
            end
        else
            --直接回大本
            self.view.ctrl:OnClickPosBtn(SceneUtils.TileToWorld(LuaEntry.Player:GetMainWorldPos()),true,nil,LuaEntry.Player:GetSelfServerId())
        end
    end
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function GetSelfData(self)
    return self.dataInfo
end

local function OnBgClick(self)
    --被攻击方是自己时不可查看
    --if self.dataInfo.targetUid == LuaEntry.Player.uid then
    --    return
    --end
    if type(self.data)~= "number" then
        if self.data.isVirtual~=nil and self.data.isVirtual==true then
            return
        elseif self.data.isNpc then
            self:GotoFakeNpcPos()
            return
        end
    end

    if self.dataInfo.type and self.dataInfo.type == WarningType.Scout then
        return
    end
    
    self.view.ctrl:OnOpenClick(self.data,false)
end

local function SetRelieve(self,state)
    self._btn_relieve:SetActive(true)
    self._btn_prevent:SetActive(false)
end

--屏蔽
local function OnHideWarning(self)
    --number时为集结
    if type(self.data) == "number" then
        DataCenter.AllianceWarDataManager:SetIgnoreList(self.dataInfo.uuid,2)
        EventManager:GetInstance():Broadcast(EventId.IgnoreAllianceMarch,false)
        self._btn_relieve:SetActive(true)
        self._btn_prevent:SetActive(false)
    elseif self.data.isVirtual~=nil and self.data.isVirtual==true then
        return
    elseif self.data.isNpc then
        DataCenter.GuideNeedLoadManager:SetFakeNpcMarchHide(true)
        EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch,true)
        self._btn_relieve:SetActive(true)
        self._btn_prevent:SetActive(false)
    else
        DataCenter.RadarAlarmDataManager:AddToCancelList(self.dataInfo.uuid)
        EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch,true)
        self._btn_relieve:SetActive(true)
        self._btn_prevent:SetActive(false)
    end
    UIUtil.ShowTipsId(141026)
end
--解除屏蔽
local function OnShowWarning(self)
    if type(self.data) == "number" then
        DataCenter.AllianceWarDataManager:SetIgnoreList(self.dataInfo.uuid,1)
        EventManager:GetInstance():Broadcast(EventId.IgnoreAllianceMarch,true)
        self._btn_relieve:SetActive(false)
        self._btn_prevent:SetActive(true)
    elseif self.data.isVirtual~=nil and self.data.isVirtual==true then
        return
    elseif self.data.isNpc then
        DataCenter.GuideNeedLoadManager:SetFakeNpcMarchHide(false)
        EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch,false)
        self._btn_relieve:SetActive(false)
        self._btn_prevent:SetActive(true)
    else
        DataCenter.RadarAlarmDataManager:RemoveToCancelList(self.dataInfo.uuid, true)
        EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch,false)
        self._btn_relieve:SetActive(false)
        self._btn_prevent:SetActive(true)
    end
    UIUtil.ShowTipsId(141027)
end

--查看敌人信息
local function OnLeftPlayerInfoClick(self)
    if type(self.data) ~= "number" then
        if self.data.isVirtual~=nil and self.data.isVirtual==true then
            return
        elseif self.data.isNpc then
            self:GotoFakeNpcPos()
            return
        end
        self.view.ctrl:OnLeftPlayerInfoClick(self.data.ownerUid)
    else
        self.view.ctrl:OnLeftPlayerInfoClick(self.dataInfo.attackUid)
    end
end

function UIPersonalWarning:GotoFakeNpcPos()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(self.data.leftPointId, ForceChangeScene.World),CS.SceneManager.World.InitZoom,nil,function()
    end,self.data.serverId)
    if self.view.ctrl ~= nil then
        self.view.ctrl:CloseSelf()
    end
end

UIPersonalWarning.OnCreate = OnCreate
UIPersonalWarning.OnDestroy = OnDestroy
UIPersonalWarning.SetBtnSeeState = SetBtnSeeState
UIPersonalWarning.OnEnable = OnEnable
UIPersonalWarning.OnDisable = OnDisable
UIPersonalWarning.RefreshData = RefreshData
UIPersonalWarning.OnLeftPosClick =OnLeftPosClick
UIPersonalWarning.OnRightPosClick =OnRightPosClick
UIPersonalWarning.OnRightMarchPosClick = OnRightMarchPosClick
UIPersonalWarning.SetData =SetData
UIPersonalWarning.OnBgClick =OnBgClick
UIPersonalWarning.AddAllianceTimer = AddAllianceTimer
UIPersonalWarning.UpdateAllianceTime = UpdateAllianceTime
UIPersonalWarning.AddPersonalTimer = AddPersonalTimer
UIPersonalWarning.UpdatePersonalTime = UpdatePersonalTime
UIPersonalWarning.GetSelfData = GetSelfData
UIPersonalWarning.SetRelieve = SetRelieve
UIPersonalWarning.OnHideWarning = OnHideWarning
UIPersonalWarning.OnShowWarning = OnShowWarning
UIPersonalWarning.OnLeftPlayerInfoClick = OnLeftPlayerInfoClick
return UIPersonalWarning