---
--- 箭头指示
--- Created by shimin.
--- DateTime: 2021/8/13 19:21
---
local UIArrowView = BaseClass("UIArrowView",UIBaseView)
local base = UIBaseView

local rotation_go_path = "RotationGo"
local return_path = "Panel"
local finger_go_path = "RotationGo/UIGuideArrowFingerType1/ui_effect_click"

--创建
function UIArrowView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIArrowView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

function UIArrowView:ComponentDefine()
    self.rotation_go = self:AddComponent(UIBaseContainer, rotation_go_path)
    self.finger_go = self:AddComponent(UIBaseContainer, finger_go_path)
    self.bg = self:AddComponent(UIButton,return_path)
    self.bg:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
end

function UIArrowView:ComponentDestroy()
end

function UIArrowView:DataDefine()
    self.param = nil
    self.modelHeight = nil
    self.arrow_timer = nil
    self.arrow_action = function(temp)
        self:RefreshArrowTimer(temp)
    end
end

function UIArrowView:DataDestroy()
    self:DeleteArrowTimer()
    DataCenter.ArrowManager:CheckShowNext()
end

function UIArrowView:OnEnable()
    base.OnEnable(self)
end

function UIArrowView:OnDisable()
    base.OnDisable(self)
end

function UIArrowView:ReInit()
    self.param = self:GetUserData()
    self:InitModelHeight()
    self:Refresh()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Finger)
end

function UIArrowView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshArrow, self.RefreshArrowSignal)
    self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.ChangeCameraPointSignal)
    self:AddUIListener(EventId.WorldTroopGameObjectCreateFinish, self.WorldTroopGameObjectCreateFinishSignal)
end

function UIArrowView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshArrow, self.RefreshArrowSignal)
    self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.ChangeCameraPointSignal)
    self:RemoveUIListener(EventId.WorldTroopGameObjectCreateFinish, self.WorldTroopGameObjectCreateFinishSignal)
end
function UIArrowView:Refresh()
    if self.param ~= nil then
        local screenPosition = nil
        if self.param.positionType == PositionType.World then
            screenPosition = CS.SceneManager.World:WorldToScreenPoint(self.param.position + self.modelHeight)
        elseif self.param.positionType == PositionType.Screen then
            screenPosition = self.param.position + self.modelHeight
        elseif self.param.positionType == PositionType.PointId then
            screenPosition = CS.SceneManager.World:WorldToScreenPoint(SceneUtils.TileIndexToWorld(self.param.pointId) + self.modelHeight)
        end
        if screenPosition ~= nil then
            self.rotation_go.transform.position = screenPosition
        end

        if self.param.isPanel == false then
            self.bg:SetActive(false)
        else
            self.bg:SetActive(true)
        end
        if self.param.isReversal then
            if self.param.YisReversal then
                self.rotation_go.transform.localRotation = Quaternion.Euler(0, 0, 0)
            else
                self.rotation_go.transform.localRotation = Quaternion.Euler(0, 0, 235)
            end
        else
            if self.param.YisReversal then
                self.rotation_go.transform.localRotation = Quaternion.Euler(0, 0, 90)
            else
                self.rotation_go.transform.localRotation = Quaternion.Euler(0, 0, 0)
            end
        end

        if self.param.isAutoClose then
            self:AddArrowTimer(self.param.isAutoClose)
        end

        if self.param.noShowFinger then
            self.finger_go:SetActive(false)
        else
            self.finger_go:SetActive(true)
        end
    end
end

function UIArrowView:RefreshArrowSignal(param)
    self.param = param
    self:InitModelHeight()
    self:Refresh()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Finger)
end

function UIArrowView:ChangeCameraPointSignal()
    self:Refresh()
end

function UIArrowView:WorldTroopGameObjectCreateFinishSignal(data)
    if data ~= nil then
        local marchUuid = tonumber(data)
        if self.param ~= nil and self.param.uuid == marchUuid then
            self:InitModelHeight()
            self:Refresh()
        end
    end
end
function UIArrowView:InitModelHeight()
    if self.modelHeight == nil then
        self.modelHeight = Vector3.New(0,0,0)
    end
    if self.param.arrowType == ArrowType.Monster then
        self.modelHeight.y = CS.SceneManager.World:GetModelHeight(self.param.uuid)
    elseif self.param.arrowType == ArrowType.Building then
        local pos = SceneUtils.WorldToTileIndex(self.param.position)
        self.modelHeight.y = CS.SceneManager.World:GetBuildingHeight(pos)
    elseif self.param.arrowType == ArrowType.BuildBox then
        if self.param.tiles == BuildTilesSize.One then
            self.modelHeight.y = 3
        elseif self.param.tiles == BuildTilesSize.Two then
            self.modelHeight.y = 4
        else
            self.modelHeight.y = 4
        end
    end
end

function UIArrowView:AddArrowTimer(closeTime)
    if self.arrow_timer == nil then
        self.arrow_timer = TimerManager:GetInstance():GetTimer(closeTime, self.arrow_action , self, true,false,false)
        self.arrow_timer:Start()
    end
end

function UIArrowView:RefreshArrowTimer()
    self:DeleteArrowTimer()
    self.ctrl:CloseSelf()
end

function UIArrowView:DeleteArrowTimer()
    if self.arrow_timer ~= nil then
        self.arrow_timer:Stop()
        self.arrow_timer = nil
        if self.param then
            if self.param.quest then
                EventManager:GetInstance():Broadcast(EventId.ChapterTaskOrWarningBall)
            end
        end
    end
end

return UIArrowView