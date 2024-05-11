---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 20/2/2024 下午3:28
---
local TroopQueueItem = BaseClass("TroopQueueItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local slider_path = "slider"
local slider_txt_path = "slider/slider_text"
local name_txt_path = "name_text"
local des_txt_path ="des_text"
local select_btn_path = "select_btn"
local icon_bg_path = "icon_bg"
local icon_path = "icon_bg/icon"
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:DeleteTimer()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
    self.icon_image = self:AddComponent(UIImage, icon_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_txt_path)
    self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_path)
    self.slider_txt = self:AddComponent(UITextMeshProUGUIEx, slider_txt_path)
    self.slider = self:AddComponent(UISlider,slider_path)
    self.select_btn = self:AddComponent(UIButton,select_btn_path)
    self.select_btn:SetOnClick(function()
        self:OnClickSelect()
    end)
    self.select_img = self:AddComponent(UIImage,select_btn_path)
    self.timer_action = function(temp)
        self:UpdateTime()
    end
end

local function ComponentDestroy(self)

end

local function DataDefine(self)
    self.startTime = 0
    self.endTime = 0
end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function SetUuid(self,uuid)
    self.uuid = uuid
end
local function RefreshData(self)
    if self.uuid == nil then
        return
    end
    self.startTime = 0
    self.endTime = 0
    self.isUpdate = false
    self:DeleteTimer()
    self.marchUuid = 0
    self.isLock = false
    local formation = DataCenter.ArmyFormationDataManager:GetOneArmyInfoByUuid(self.uuid)
    if formation~=nil then
        local march = DataCenter.WorldMarchDataManager:GetOwnerFormationMarch(LuaEntry.Player.uid, self.uuid,LuaEntry.Player.allianceId)
        if march~=nil then
            local stateImg = MarchUtil.GetMarchStateIconByType(march)
            self.icon_image:LoadSprite(stateImg)
            self.marchUuid = march.uuid
            local curTime = UITimeManager:GetInstance():GetServerTime()
            if march.endTime>curTime then
                self.name_text:SetText(Localization:GetString(self.view.ctrl:GetTargetDes(march:GetMarchTargetType())))
                self.startTime = march.startTime
                self.endTime =march.endTime
                self.isUpdate = true
                self.des_txt:SetText("")
                self.slider:SetActive(true)
                self:UpdateTime()
                self:AddTimer()
            else
                self.name_text:SetText(Localization:GetString("302254")..formation.index)
                self.slider:SetActive(false)
                self.des_txt:SetColorRGBA(1,1,1,1)
                self.des_txt:SetText(Localization:GetString(self.view.ctrl:GetTargetDes(march:GetMarchTargetType())))
                self.isUpdate = false
            end
            self.select_btn:SetActive(true)
        else
            self.icon_image:LoadSprite("Assets/Main/Sprites/UI/UIQueue/UIQueue_img_troop.png")
            self.name_text:SetText(Localization:GetString("302254")..formation.index)
            self.slider:SetActive(false)
            if formation.index == 4 then
                self.name_text:SetText(Localization:GetString("470099"))
                local hasMonthCard = DataCenter.MonthCardNewManager:CheckIfMonthCardActive()
                if hasMonthCard == false then
                    self.uuid = formation.index
                    self.des_txt:SetLocalText(120050)
                    self.des_txt:SetColorRGBA(0.95,0.345,0.345,1)
                    self.select_btn:SetActive(true)
                    self.isLock = true
                    return
                end
            end
            self.des_txt:SetColorRGBA(1,1,1,1)
            self.select_btn:SetActive(false)
            self.des_txt:SetLocalText(470007)
            
        end
    else
        self.icon_image:LoadSprite("Assets/Main/Sprites/UI/UIQueue/UIQueue_img_troop.png")
        self.isLock = true
        if self.uuid == 4 then
            self.name_text:SetText(Localization:GetString("470099"))
        else
            self.name_text:SetText(Localization:GetString("302254")..self.uuid)
        end
        
        self.slider:SetActive(false)
        self.des_txt:SetLocalText(120050)
        self.des_txt:SetColorRGBA(0.95,0.345,0.345,1)
        self.select_btn:SetActive(true)
    end
end

local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
        self.timer:Start()
    end
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function UpdateTime(self)
    if self.isUpdate == true then
        local totalTime = self.endTime - self.startTime
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.endTime - curTime
        local tempValue = 1 - math.min(1, (deltaTime / totalTime))
        self.slider:SetValue(tempValue)
        self.slider_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        if deltaTime < 0 then
            self.isUpdate = false
        end
    end
end

local function OnClickSelect(self)
    if self.isLock == true then
        self.view.ctrl:CloseSelf()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIFormationAdd,{anim = true,isBlur = true})
        return
    end
    local marchInfo = DataCenter.WorldMarchDataManager:GetMarch(self.marchUuid)
    if marchInfo~=nil then
        if marchInfo:GetMarchStatus() == MarchStatus.IN_WORM_HOLE or marchInfo:GetMarchStatus() == MarchStatus.CROSS_SERVER then
            self.view.ctrl:CloseSelf()
            GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(marchInfo.startPos,ForceChangeScene.World),nil,nil,nil,marchInfo.serverId)
        elseif marchInfo:GetMarchType() == NewMarchType.EXPLORE then
            self.view.ctrl:CloseSelf()
            local troop = WorldTroopManager:GetInstance():GetTroop(marchInfo.uuid)
            if troop~=nil then
                GoToUtil.GotoWorldPos(troop:GetPosition(),nil,nil,nil,marchInfo.serverId)
            else
                GoToUtil.GotoWorldPos(marchInfo:GetMarchCurPos(),nil,nil,nil,marchInfo.serverId)
            end
        elseif marchInfo:GetMarchStatus()== MarchStatus.COLLECTING then
            self.view.ctrl:CloseSelf()
            GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(marchInfo.startPos,ForceChangeScene.World))
            local position = SceneUtils.TileIndexToWorld(marchInfo.startPos,ForceChangeScene.World)
            WorldArrowManager:GetInstance():ShowArrowEffect(0,position,ArrowType.Building)
        elseif marchInfo:GetMarchStatus()== MarchStatus.ASSISTANCE then
            self.view.ctrl:CloseSelf()
            GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(marchInfo.startPos,ForceChangeScene.World),nil,nil,nil,marchInfo.serverId)
            local position = SceneUtils.TileIndexToWorld(marchInfo.startPos,ForceChangeScene.World)
            position.x = position.x-1
            position.y = position.y
            position.z = position.z-1
            WorldArrowManager:GetInstance():ShowArrowEffect(0,position,ArrowType.Building)
        elseif marchInfo:GetMarchStatus()== MarchStatus.WAIT_RALLY then
            self.view.ctrl:CloseSelf()
            GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(marchInfo.startPos,ForceChangeScene.World),nil,nil,nil,marchInfo.serverId)
            local position = SceneUtils.TileIndexToWorld(marchInfo.startPos,ForceChangeScene.World)
            position.x = position.x-1
            position.y = position.y
            position.z = position.z-1
            WorldArrowManager:GetInstance():ShowArrowEffect(0,position,ArrowType.Building)
        elseif marchInfo:GetMarchStatus()== MarchStatus.IN_TEAM then
            self.view.ctrl:CloseSelf()
            local teamMarch = DataCenter.WorldMarchDataManager:GetAllianceMarchesInTeam(LuaEntry.Player.allianceId, marchInfo.teamUuid)
            if teamMarch~=nil then
                if teamMarch:GetMarchStatus() == MarchStatus.WAIT_RALLY then
                    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(teamMarch.startPos,ForceChangeScene.World),nil,nil,nil,marchInfo.serverId)
                    local position = SceneUtils.TileIndexToWorld(teamMarch.startPos,ForceChangeScene.World)
                    position.x = position.x-1
                    position.y = position.y
                    position.z = position.z-1
                    WorldArrowManager:GetInstance():ShowArrowEffect(0,position,ArrowType.Building)
                else
                    GoToUtil.GotoWorldPos(teamMarch:GetMarchCurPos(),nil,nil,function()
                        DataCenter.WorldMarchDataManager:TrackMarch(teamMarch.uuid)
                        WorldMarchTileUIManager:GetInstance():ShowTroop(teamMarch.uuid)
                    end,marchInfo.serverId)
                end
            end
        else
            self.view.ctrl:CloseSelf()
            GoToUtil.GotoWorldPos(marchInfo:GetMarchCurPos(),nil,nil,function()
                DataCenter.WorldMarchDataManager:TrackMarch(marchInfo.uuid)
                WorldMarchTileUIManager:GetInstance():ShowTroop(marchInfo.uuid)
            end,marchInfo.serverId)
        end
    end
end

TroopQueueItem.OnCreate = OnCreate
TroopQueueItem.OnDestroy = OnDestroy
TroopQueueItem.OnEnable = OnEnable
TroopQueueItem.OnDisable = OnDisable
TroopQueueItem.ComponentDefine = ComponentDefine
TroopQueueItem.ComponentDestroy = ComponentDestroy
TroopQueueItem.DataDefine = DataDefine
TroopQueueItem.DataDestroy = DataDestroy
TroopQueueItem.OnAddListener = OnAddListener
TroopQueueItem.OnRemoveListener = OnRemoveListener
TroopQueueItem.SetUuid = SetUuid
TroopQueueItem.UpdateTime = UpdateTime
TroopQueueItem.DeleteTimer =DeleteTimer
TroopQueueItem.AddTimer =AddTimer
TroopQueueItem.RefreshData = RefreshData
TroopQueueItem.OnClickSelect = OnClickSelect
TroopQueueItem.RefreshByBuildUuid = RefreshByBuildUuid
return TroopQueueItem