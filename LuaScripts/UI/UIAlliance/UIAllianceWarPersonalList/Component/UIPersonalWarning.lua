--- Created by shimin.
--- DateTime: 2024/2/21 11:44
---
local UIPersonalWarning = BaseClass("UIPersonalWarning",UIBaseContainer)
local base = UIBaseContainer
local UIPersonalWarPlayerItem = require "UI.UIAlliance.UIAllianceWarPersonalList.Component.UIPersonalWarPlayerItem"

local left_pos_btn_path = "mainContent/left/layout/leftNameTxt/leftPosTxt/leftPosBtn"
local pos_txt_path = "mainContent/left/layout/leftNameTxt/leftPosTxt"
local left_name_path = "mainContent/left/layout/leftNameTxt"
local left_name_btn_path = "mainContent/left/layout/leftNameTxt/leftNameBtn"
local warningType_txt_path = "mainContent/left/WarningType_Txt"
local right_rect_path = "mainContent/right"
local right_pos_btn_path ="mainContent/right/rightNameTxt/rightPosBtn"
local right_pos_txt_path = "mainContent/right/rightPosTxt"
local right_name_path = "mainContent/right/rightNameTxt"
local right_endTime_path = "mainContent/right/Txt_EndTime"
local des_txt_path = "mainContent/left/layout/DesTxt"
local btn_prevent_path = "mainContent/Btn_prevent"
local btn_relieve_path = "mainContent/Btn_relieve"
local img_typeBg_path = "mainContent/type_ImgBg"
local see_btn_path = "mainContent/Btn_See"
local seeArmy_btn_path = "mainContent/Btn_SeeArmy"
local info_content_path = "info_content"
local info_bg_path = "info_bg"

function UIPersonalWarning:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIPersonalWarning:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPersonalWarning:ComponentDefine()
    self.bg_btn = self:AddComponent(UIButton, see_btn_path)
    self.bg_btn:SetOnClick(function ()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBgClick()
    end)
    self.left_pos_btn = self:AddComponent(UIButton, left_pos_btn_path)
    self.left_pos_btn:SetOnClick(function ()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnLeftPosClick()
    end)
    self.left_name = self:AddComponent(UITextMeshProUGUIEx, left_name_path)
    self.left_name_btn = self:AddComponent(UIButton, left_name_btn_path)
    self.left_name_btn:SetOnClick(function ()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnLeftPlayerInfoClick()
    end)
    self._warningType_txt = self:AddComponent(UITextMeshProUGUIEx, warningType_txt_path)
    self._pos_txt = self:AddComponent(UITextMeshProUGUIEx, pos_txt_path)
    self.right_rect = self:AddComponent(UIBaseContainer, right_rect_path)
    self.right_pos_btn = self:AddComponent(UIButton, right_pos_btn_path)
    self.right_pos_btn:SetOnClick(function ()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRightPosClick()
    end)
    self.right_name = self:AddComponent(UITextMeshProUGUIEx, right_name_path)
    self._right_endTime_txt = self:AddComponent(UITextMeshProUGUIEx, right_endTime_path)
    self.right_pos_txt = self:AddComponent(UITextMeshProUGUIEx, right_pos_txt_path)
    self._des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_path)
    self._btn_prevent = self:AddComponent(UIButton, btn_prevent_path)
    self._btn_prevent:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnHideWarning()
    end)
    self._btn_relieve = self:AddComponent(UIButton, btn_relieve_path)
    self._btn_relieve:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnShowWarning()
    end)
    self._typeBg_img = self:AddComponent(UIImage, img_typeBg_path)
    self._seeArmy_btn = self:AddComponent(UIButton, seeArmy_btn_path)
    self._seeArmy_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRightMarchPosClick()
    end)
    self.info_content = self:AddComponent(UIBaseContainer, info_content_path)
    self.info_bg = self:AddComponent(UIBaseContainer, info_bg_path)
end

function UIPersonalWarning:ComponentDestroy()
end

function UIPersonalWarning:DataDefine()
    self._timer_alliance = nil
    self._timer_action = function()
        self:UpdateAllianceTime()
    end
    self._timer_personal = nil
    self._timer_action_temp = function()
        self:UpdatePersonalTime()
    end
    self.dataInfo = nil
    self.data = nil
    self.showInfo = false
    self.model = {}
end

function UIPersonalWarning:DataDestroy()
    self:RemoveAllianceTimer()
    self:RemovePersonalTimer()
    self.dataInfo = nil
    self.data = nil
    self._timer_action = nil
    self._timer_action_temp = nil
    self.showInfo = false
    self.model = {}
end
function UIPersonalWarning:OnEnable()
    base.OnEnable(self)
end

function UIPersonalWarning:OnDisable()
    base.OnDisable(self)
end

function UIPersonalWarning:SetBtnSeeState(state)
    if self.dataInfo ~= nil then
        --侦察关闭查看详情
        if self.dataInfo.type == WarningType.Scout or (self.dataInfo.monsterId ~= nil and self.dataInfo.monsterId ~= 0) then
            self.bg_btn:SetActive(false)
        else
            self.bg_btn:SetActive(state)
        end
    end
end

function UIPersonalWarning:RefreshData()
    self:HideInfo()
    self:RemovePersonalTimer()
    self:RemoveAllianceTimer()
    self.right_rect:SetActive(true)
    self._right_endTime_txt:SetActive(true)
    if self.data.isCross then
        self.right_rect:SetActive(false)
        self._btn_prevent:SetActive(false)
        self._btn_relieve:SetActive(false)
        self.bg_btn:SetActive(false)
        self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_junqing_attack_big"))
        self._warningType_txt:SetLocalText(110219,self.data.serverId)
        self._des_txt:SetText("")
    else
        self.bg_btn:SetActive(true)
        if self.data.isVirtual then
            self._pos_txt:SetActive(false)
            self._des_txt:SetText("")
            self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_help"))
            self._warningType_txt:SetText("")
            self._btn_prevent:SetActive(false)
            self._btn_relieve:SetActive(false)
            self:AddPersonalTimer()
            self:UpdatePersonalTime()
        elseif self.data.isNpc then
            self.bg_btn:SetActive(false)
            self._pos_txt:SetActive(true)
            local leftPos = SceneUtils.IndexToTilePos(self.data.leftPointId, ForceChangeScene.World)
            self._pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, leftPos.x, leftPos.y)
            self._des_txt:SetText("")
            self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_junqing_attack_big"))
            self._warningType_txt:SetLocalText(110143) --攻
            if DataCenter.GuideNeedLoadManager:IsFakeNpcMarchHide() then
                self._btn_relieve:SetActive(true)
                self._btn_prevent:SetActive(false)
            else
                self._btn_relieve:SetActive(false)
                self._btn_prevent:SetActive(true)
            end
            self._right_endTime_txt:SetActive(false)
        elseif self.data.monsterId ~= nil and self.data.monsterId ~= 0 then
            self._pos_txt:SetActive(false)
            self.dataInfo = self.view:GetBlackKnightData(self.data)
            if self.dataInfo == nil then
                self:RemovePersonalTimer()
                return
            end
            self._des_txt:SetText(self.dataInfo.soldierNum)
            self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_junqing_attack_big"))
            self._warningType_txt:SetLocalText(110143) --攻
            self:AddPersonalTimer()
            self:UpdatePersonalTime()
            if DataCenter.ActBlackKnightManager:IsShowWarning() then
                self._btn_relieve:SetActive(false)
                self._btn_prevent:SetActive(true)
            else
                self._btn_relieve:SetActive(true)
                self._btn_prevent:SetActive(false)
            end
        else
            if self.data.teamUuid ~= 0 then
                --集结
                self.bg_btn:SetActive(true)
                self.dataInfo = self.view:GetPersonalItemData(self.data.ownerFormationUuid)
                local leftPos = SceneUtils.IndexToTilePos(self.data.startPos, ForceChangeScene.World)
                self._pos_txt:SetActive(true)
                self._pos_txt:SetLocalText(GameDialogDefine.SHOW_POS, leftPos.x, leftPos.y)
                self:AddAllianceTimer()
                self:UpdateAllianceTime()
                self._btn_prevent:SetActive(not DataCenter.RadarAlarmDataManager:IsCancel(self.dataInfo.uuid))
                self._btn_relieve:SetActive(DataCenter.RadarAlarmDataManager:IsCancel(self.dataInfo.uuid))
                self._des_txt:SetText(self.dataInfo.soldierNum)
                if self.dataInfo.type == WarningType.Attack then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_junqing_attack_big"))
                elseif self.dataInfo.type == WarningType.Scout then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_junqing_zhencha_big"))
                elseif self.dataInfo.type == WarningType.Assistance then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_assemble"))
                elseif self.dataInfo.type == WarningType.ResourceAssistance then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_help"))
                end
            else
                self._pos_txt:SetActive(false)
                self.dataInfo = self.view:GetPersonalItemData(self.data.ownerFormationUuid)
                if not self.dataInfo then
                    self:RemovePersonalTimer()
                    return
                end
                self._des_txt:SetText(self.dataInfo.soldierNum)
                if self.dataInfo.type == WarningType.Attack then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_junqing_attack_big"))
                    self._warningType_txt:SetLocalText(110143) --攻
                elseif self.dataInfo.type == WarningType.Scout then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_junqing_zhencha_big"))
                    self._warningType_txt:SetLocalText(110142) --侦
                elseif self.dataInfo.type == WarningType.Assistance then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_assemble"))
                    self._warningType_txt:SetLocalText(110141) --增
                elseif self.dataInfo.type == WarningType.ResourceAssistance then
                    self._typeBg_img:LoadSprite(string.format(LoadPath.WarDetail,"UIalarm_icon_help"))
                end
                self:AddPersonalTimer()
                self:UpdatePersonalTime()
                self._btn_prevent:SetActive(not DataCenter.RadarAlarmDataManager:IsCancel(self.dataInfo.uuid))
                self._btn_relieve:SetActive(DataCenter.RadarAlarmDataManager:IsCancel(self.dataInfo.uuid))
            end
        end
    end
    if not self.data.isCross then
        if self.data.isVirtual then
            self.left_name:SetText(self.data.leftName)
            self.right_name:SetText(self.data.rightName)
        elseif self.data.isNpc then
            self.left_name:SetText(self.data.leftName)
            self.right_name:SetText(self.data.rightName)
        else
            self.left_name:SetText(self.dataInfo.leftName)
            self.right_name:SetText(self.dataInfo.rightName)
        end
    else
        self.left_name:SetText("")
        self.right_name:SetText("")
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.right_name.rectTransform)
    self:SetBtnSeeState(true)
end

function UIPersonalWarning:SetData(data)
    self.data = data
end

function UIPersonalWarning:OnLeftPosClick()
    if self.data.isVirtual then
        return
    elseif self.data.isNpc then
        self:GotoFakeNpcPos()
        return
    end
    self.view.ctrl:OnClickPosBtn(self.dataInfo.leftPointId,false,nil,self.dataInfo.serverId,self.dataInfo.worldId)
end

function UIPersonalWarning:OnRightPosClick()
    if self.data.isVirtual then
        return
    elseif self.data.isNpc then
        self.view.ctrl:OnClickPosBtn(self.data.rightPointId,false,nil,self.data.serverId)
        GoToUtil.CloseAllWindows()
        return
    end
    --当前在哪个服就查看哪个服
    self.view.ctrl:OnClickPosBtn(self.dataInfo.rightPointId,false,nil,self.dataInfo.serverId,self.dataInfo.worldId)
end

--查看敌方部队现在位置
function UIPersonalWarning:OnRightMarchPosClick()
    --如果是跨服直接跳转
    if self.data.serverId == LuaEntry.Player:GetCurServerId() then
        if self.data.isVirtual then
            return
        elseif self.data.isNpc then
            self:GotoFakeNpcPos()
            return
        end
        local pos = self.data:GetMarchCurPos()
        if self.data.status == MarchStatus.WAIT_RALLY then
            self.view.ctrl:OnClickPosBtn(pos,true,nil,self.data.serverId,self.data.worldId)
        else
            self.view.ctrl:OnClickPosBtn(pos,true,self.data.uuid,self.data.serverId,self.data.worldId)
        end
    else
        local serverId = self.data.serverId
        local position = nil
        if self.data.alarm == nil then
            position = SceneUtils.TileIndexToWorld(self.data.pointId, ForceChangeScene.World)
        else
            position = self.data.alarm:GetTargetPos()
        end
        GoToUtil.CloseAllWindows()
        GoToUtil.GotoWorldPos(position,CS.SceneManager.World.InitZoom,nil,function()
        end, serverId)
    end
end

function UIPersonalWarning:GetSelfData()
    return self.dataInfo
end

function UIPersonalWarning:OnBgClick()
    if self.showInfo then
        self:HideInfo()
    else
        if self.data.isVirtual then
            return
        elseif self.data.isNpc then
            self:GotoFakeNpcPos()
            return
        end
        if self.dataInfo.type and self.dataInfo.type == WarningType.Scout then
            return
        end
        self:ShowInfo()
    end
end

function UIPersonalWarning:SetRelieve()
    self._btn_relieve:SetActive(true)
    self._btn_prevent:SetActive(false)
end

--屏蔽
function UIPersonalWarning:OnHideWarning()
    if self.data.isVirtual then
        return
    elseif self.data.isNpc then
        DataCenter.GuideNeedLoadManager:SetFakeNpcMarchHide(true)
        EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch,true)
        self._btn_relieve:SetActive(true)
        self._btn_prevent:SetActive(false)
    elseif self.data.monsterId ~= nil and self.data.monsterId ~= 0 then
        DataCenter.ActBlackKnightManager:CloseWarning()
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
function UIPersonalWarning:OnShowWarning()
    if self.data.isVirtual then
        return
    elseif self.data.isNpc then
        DataCenter.GuideNeedLoadManager:SetFakeNpcMarchHide(false)
        EventManager:GetInstance():Broadcast(EventId.IgnoreTargetForMineMarch,false)
        self._btn_relieve:SetActive(false)
        self._btn_prevent:SetActive(true)
    elseif self.data.monsterId ~= nil and self.data.monsterId ~= 0 then
        DataCenter.ActBlackKnightManager:OpenWarning()
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
function UIPersonalWarning:OnLeftPlayerInfoClick()
    if self.data.isVirtual then
        return
    elseif self.data.isNpc then
        self:GotoFakeNpcPos()
        return
    end
    if self.data.monsterId ~= nil and self.data.monsterId ~= 0 then
        self:OnRightMarchPosClick()
    else
        self.view.ctrl:OnLeftPlayerInfoClick(self.data.ownerUid)
    end
end

function UIPersonalWarning:GotoFakeNpcPos()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(self.data.leftPointId, ForceChangeScene.World),CS.SceneManager.World.InitZoom,nil,function()
    end,self.data.serverId)
    if self.view.ctrl ~= nil then
        self.view.ctrl:CloseSelf()
    end
end

function UIPersonalWarning:AddPersonalTimer()
    if self._timer_personal == nil then
        self._timer_personal = TimerManager:GetInstance():GetTimer(1, self._timer_action_temp, self, false, false, false)
        self._timer_personal:Start()
    end
end

function UIPersonalWarning:RemovePersonalTimer()
    if self._timer_personal ~= nil then
        self._timer_personal:Stop()
        self._timer_personal = nil
    end
end

--刷新个人攻击时间
function UIPersonalWarning:UpdatePersonalTime()
    if self.data.isVirtual then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.data.endTime - curTime
        if deltaTime <= 0 then
            self._right_endTime_txt:SetText("00:00:00")
            self:RemovePersonalTimer()
        else
            self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        end
    else
        if self.dataInfo.status == MarchStatus.MOVING or self.dataInfo.status == MarchStatus.CHASING then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            local deltaTime = self.dataInfo.endTime - curTime
            if deltaTime <= 0 then
                self._right_endTime_txt:SetLocalText(100150)
                self:RemovePersonalTimer()
            else
                self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
            end
        else
            self._right_endTime_txt:SetText("00:00:00")
        end
    end
end

function UIPersonalWarning:AddAllianceTimer()
    if self._timer_alliance == nil then
        self._timer_alliance = TimerManager:GetInstance():GetTimer(1, self._timer_action, self, false, false, false)
        self._timer_alliance:Start()
    end
end

function UIPersonalWarning:RemoveAllianceTimer()
    if self._timer_alliance ~= nil then
        self._timer_alliance:Stop()
        self._timer_alliance = nil
    end
end

--刷新集结时间
function UIPersonalWarning:UpdateAllianceTime()
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if self.data.status == MarchStatus.WAIT_RALLY then
        local deltaTime = self.data.endTime - curTime
        self._warningType_txt:SetLocalText(141037)
        self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    else
        --当部队出发后，队长的结束时间为达到目的地时间
        if self.data.endTime > curTime then
            self._right_endTime_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(self.data.endTime - curTime))
        else
            self._right_endTime_txt:SetLocalText(141029)
        end
        self._warningType_txt:SetLocalText(141038)
    end
end

function UIPersonalWarning:ShowInfo()
    self.showInfo = true
    self.info_content:SetActive(true)
    self.info_bg:SetActive(true)
    self:SetAllCellDestroy()
    --个人
    if self.data.armyInfos[1] ~= nil then
        for k,v in ipairs(self.data.armyInfos) do
            local req = self:GameObjectInstantiateAsync(UIAssets.UIPersonalWarPlayerItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.info_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.info_content:AddComponent(UIPersonalWarPlayerItem,nameStr)
                if v.uuid == self.data.uuid then
                    cell:ShowHeroAndSolider(self.data, v)
                else
                    cell:ShowHeroAndSolider(nil, v)
                end
            end)
            table.insert(self.model, req)
        end
    end
end

function UIPersonalWarning:HideInfo()
    self.showInfo = false
    self:SetAllCellDestroy()
    self.info_content:SetActive(false)
    self.info_bg:SetActive(false)
end

function UIPersonalWarning:SetAllCellDestroy()
    self.info_content:RemoveComponents(UIPersonalWarPlayerItem)
    if self.model[1] ~= nil then
        for k,v in ipairs(self.model) do
            self:GameObjectDestroy(v)
        end
        self.model = {}
    end
end
return UIPersonalWarning