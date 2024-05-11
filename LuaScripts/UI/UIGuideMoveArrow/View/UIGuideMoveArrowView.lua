---
--- 引导移动箭头页面
--- Created by shimin.
--- DateTime: 2021/8/25 21:24
---
local UIGuideMoveArrowView = BaseClass("UIGuideMoveArrowView",UIBaseView)
local base = UIBaseView
local UIGuideArrowFingerType = require "UI.UIGuideArrow.Component.UIGuideArrowFingerType"

local arrow_rotation_go_path = "ArrowRotationGo"
local img_path = "ArrowRotationGo/Img"
local no_input_path = "NoInput"

local RefreshPositionTime = 0.5--防止按钮有动画，移动
local ImgSizeDelta = 0.8--图片整体缩放

local ArrowPrefabName = {}
ArrowPrefabName[GuideArrowStyle.Finger] = "Assets/Main/Prefab_Dir/Guide/UIGuideArrowFingerType1.prefab"
ArrowPrefabName[GuideArrowStyle.Yellow] = "Assets/Main/Prefab_Dir/Guide/UIGuideArrowFingerType1.prefab"
ArrowPrefabName[GuideArrowStyle.Green] = "Assets/Main/Prefab_Dir/Guide/UIGuideArrowFingerType1.prefab"
ArrowPrefabName[GuideArrowStyle.ClickCallAirDrop] = "Assets/Main/Prefab_Dir/Guide/UIGuideArrowFingerType4.prefab"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.AutoDoMovePos = self.transform:Find(arrow_rotation_go_path):GetComponent(typeof(CS.AutoDoMovePos))
    self.img = self:AddComponent(UIImage, img_path)
    self.no_input = self:AddComponent(UIBaseContainer, no_input_path)
end

local function ComponentDestroy(self)
    self.AutoDoMovePos = nil
    self.img = nil
    self.no_input = nil
end


local function DataDefine(self)
    self.refresh_position_action = function(temp)
        self:RefreshPositionTimerCallBack()
    end
    self.strPath = nil
    self.finger = {}
    self.endFlag = nil
    self.param = nil
end

local function DataDestroy(self)
    self:DeleteRefreshPositionTimer()
    self.refresh_position_action = nil
    self.strPath = nil
    self.finger = nil
    self.endFlag = nil
    self.param = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self)
    self.param = self:GetUserData()
    self:Refresh()
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:AddUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.ChangeWorldPointSignal)
    self:AddUIListener(EventId.GuideMoveArrowPlayAnim, self.GuideMoveArrowPlayAnimSignal)
    self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
    self:AddUIListener(EventId.OnWorldInputDragBegin, self.OnWorldInputDragBeginSignal)
    self:AddUIListener(EventId.OnWorldInputDragEnd, self.OnWorldInputDragEndSignal)
    self:AddUIListener(EventId.CloseGuideMoveArrow, self.CloseGuideMoveArrowSignal)
    self:AddUIListener(EventId.SetGuideMoveArrowShow, self.SetGuideMoveArrowShowSignal)
    self:AddUIListener(EventId.SetGuideMoveArrowHide, self.SetGuideMoveArrowHideSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:RemoveUIListener(EventId.WORLD_CAMERA_CHANGE_POINT, self.ChangeWorldPointSignal)
    self:RemoveUIListener(EventId.GuideMoveArrowPlayAnim, self.GuideMoveArrowPlayAnimSignal)
    self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
    self:RemoveUIListener(EventId.OnWorldInputDragBegin, self.OnWorldInputDragBeginSignal)
    self:RemoveUIListener(EventId.OnWorldInputDragEnd, self.OnWorldInputDragEndSignal)
    self:RemoveUIListener(EventId.CloseGuideMoveArrow, self.CloseGuideMoveArrowSignal)
    self:RemoveUIListener(EventId.SetGuideMoveArrowShow, self.SetGuideMoveArrowShowSignal)
    self:RemoveUIListener(EventId.SetGuideMoveArrowHide, self.SetGuideMoveArrowHideSignal)
end


local function Refresh(self)
    self.gameObject:SetActive(true)
    local needTimer = nil
    if self.param ~= nil and self.param.pointList ~= nil then
        local strPath = ""
        local endPosition = nil
        local endType = nil
        for k,v in ipairs(self.param.pointList) do
            if v.pointObj ~= nil then
                needTimer = true
                v.pointPosition = v.pointObj.transform.position
            end
            if k ~= 1 then
                strPath = strPath .. "|"
            end
            strPath = strPath .. v.pointPosition.x .. ";"..v.pointPosition.y .. ";" .. v.pointPosition.z .. ";" .. v.pointType
            endPosition = v.pointPosition
            endType = v.pointType
        end
        if self.strPath ~= strPath then
            self.strPath = strPath
            self:LoadFinger()
            self.AutoDoMovePos:Init(strPath)

            self.AutoDoMovePos.enabled = true
            self:LoadEndFlag(endType,endPosition)
        end
    end
    self.img:SetActive(false)
    if self.param.sprite ~= nil then
        self.img:SetImage(self.param.sprite)
        --local size = self.img:GetSizeDelta()
        --size.x = size.x * ImgSizeDelta
        --size.y = size.y * ImgSizeDelta
        --self.img:SetSizeDelta(size)
    end
    if self.param.spriteSize ~= nil then
        self.img:SetSizeDelta(self.param.spriteSize)
    end

    if needTimer then
        self:AddRefreshPositionTimer()
    end
    if self.param.waitAnimType == UIGuideMoveArrowNeedWaitType.Yes then
        self.no_input:SetActive(true)
    else
        self.no_input:SetActive(false)
    end
end

local function RefreshGuideSignal(self)
    if not(self.param ~= nil and self.param.isRecommend == true) then
        self.ctrl:CloseSelf()
    end
end

local function RefreshGuideAnimSignal(self,param)
    self.param = param
    self:Refresh()
end

local function DeleteRefreshPositionTimer(self)
    if self.refreshPositionTimer ~= nil then
        self.refreshPositionTimer:Stop()
        self.refreshPositionTimer = nil
    end
end

local function AddRefreshPositionTimer(self)
    self:DeleteRefreshPositionTimer()
    if self.refreshPositionTimer == nil then
        self.refreshPositionTimer = TimerManager:GetInstance():GetTimer(RefreshPositionTime, self.refresh_position_action , self, true,false,false)
        self.refreshPositionTimer:Start()
    end
end

local function RefreshPositionTimerCallBack(self)
    self:DeleteRefreshPositionTimer()
    self:RefreshObjPosition()
    self:AddRefreshPositionTimer()
end

local function RefreshObjPosition(self)
    if self.param ~= nil and self.param.pointList ~= nil then
        for k,v in ipairs(self.param.pointList) do
            if v.pointObj ~= nil and v.pointPosition ~= v.pointObj.position then
                local pos = v.pointObj.transform.position
                if v.pointPosition.x ~= pos.x or v.pointPosition.y ~= pos.y or v.pointPosition.z ~= pos.z then
                    self:Refresh()
                end
            end
        end
    end
end

local function ChangeWorldPointSignal(self)
    self:Refresh()
end

local function GuideMoveArrowPlayAnimSignal(self,animType)
    if animType ~= nil then
        local numType = tonumber(animType)
        if numType == GuideMoveArrowPlayAnimName.Down then
            local finger = self:GetCurFinger()
            if finger ~= nil then
                finger:PlayDown()
                if self.param.sprite ~= nil then
                    self.img:SetActive(true)
                end
            end
        elseif numType == GuideMoveArrowPlayAnimName.Up then
            local finger = self:GetCurFinger()
            if finger ~= nil then
                finger:PlayUp()
                self.img:SetActive(false)
            end
            self.no_input:SetActive(false)
        end
    end
end

local function LoadFinger(self)
    for k,v in pairs(self.finger) do
        v:SetActive(false)
    end
    local prefabName = ArrowPrefabName[self.param.arrowtype]
    local param = {}
    param.arrowDirection = self.param.arrowdirection
    if self.finger[prefabName] == nil then
        self:GameObjectInstantiateAsync(prefabName, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.AutoDoMovePos.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            self.finger[prefabName] = self:AddComponent(UIGuideArrowFingerType, arrow_rotation_go_path.. "/"..nameStr)
            self.finger[prefabName]:ReInit(param)
            self.finger[prefabName]:PlayUp()
        end)
    else
        self.finger[prefabName]:SetActive(true)
        self.finger[prefabName]:ReInit(param)
        self.finger[prefabName]:PlayUp()
    end
end

local function GetCurFinger(self)
    if self.param.arrowtype ~= nil then
        return self.finger[ArrowPrefabName[self.param.arrowtype]]
    end
end

local function LoadEndFlag(self,endType,endPosition)
    if endType == PositionType.Screen then
        if self.endFlag ~= nil then
            self.endFlag.gameObject:SetActive(false)
        end
    elseif endType == PositionType.World then
        if not self.param.notUseEndFlag then
            if self.endFlag == nil then
                self:GameObjectInstantiateAsync(UIAssets.UIGuideMoveEndFlag, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject
                    go:SetActive(true)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    go.transform:SetAsLastSibling()
                    self.endFlag = go
                    self.endFlag.transform.position = endPosition
                end)

            else
                if self.endFlag ~= nil then
                    self.endFlag.gameObject:SetActive(true)
                    self.endFlag.transform.position = endPosition
                end
            end
        end
    end
end

local function OnWorldInputDragBeginSignal(self)
    self:HideFinger()
end

local function OnWorldInputDragEndSignal(self)
    self:ShowFinger()
end

local function CloseGuideMoveArrowSignal(self)
    self.ctrl:CloseSelf()
end

function UIGuideMoveArrowView:SetGuideMoveArrowShowSignal()
    self:ShowFinger()
end

function UIGuideMoveArrowView:SetGuideMoveArrowHideSignal()
    self:HideFinger()
end

function UIGuideMoveArrowView:HideFinger()
    if not self.no_input.activeSelf then
        local finger = self:GetCurFinger()
        if finger ~= nil then
            self.AutoDoMovePos.enabled = false
            finger:SetActive(false)
            self.img:SetActive(false)
        end
    end
end

function UIGuideMoveArrowView:ShowFinger()
    if not self.no_input.activeSelf then
        local finger = self:GetCurFinger()
        if finger ~= nil then
            finger:SetActive(true)
            self.AutoDoMovePos:Init(self.strPath)
            self.AutoDoMovePos.enabled = true
            if self.param.sprite ~= nil then
                self.img:SetActive(true)
            end
        end
    end
end


UIGuideMoveArrowView.OnCreate= OnCreate
UIGuideMoveArrowView.OnDestroy = OnDestroy
UIGuideMoveArrowView.OnEnable = OnEnable
UIGuideMoveArrowView.OnDisable = OnDisable
UIGuideMoveArrowView.OnAddListener = OnAddListener
UIGuideMoveArrowView.OnRemoveListener = OnRemoveListener
UIGuideMoveArrowView.ComponentDefine = ComponentDefine
UIGuideMoveArrowView.ComponentDestroy = ComponentDestroy
UIGuideMoveArrowView.DataDefine = DataDefine
UIGuideMoveArrowView.DataDestroy = DataDestroy
UIGuideMoveArrowView.ReInit = ReInit
UIGuideMoveArrowView.Refresh = Refresh
UIGuideMoveArrowView.RefreshGuideSignal = RefreshGuideSignal
UIGuideMoveArrowView.DeleteRefreshPositionTimer = DeleteRefreshPositionTimer
UIGuideMoveArrowView.AddRefreshPositionTimer = AddRefreshPositionTimer
UIGuideMoveArrowView.RefreshPositionTimerCallBack = RefreshPositionTimerCallBack
UIGuideMoveArrowView.RefreshObjPosition = RefreshObjPosition
UIGuideMoveArrowView.ChangeWorldPointSignal = ChangeWorldPointSignal
UIGuideMoveArrowView.GuideMoveArrowPlayAnimSignal = GuideMoveArrowPlayAnimSignal
UIGuideMoveArrowView.LoadFinger = LoadFinger
UIGuideMoveArrowView.GetCurFinger = GetCurFinger
UIGuideMoveArrowView.LoadEndFlag = LoadEndFlag
UIGuideMoveArrowView.RefreshGuideAnimSignal = RefreshGuideAnimSignal
UIGuideMoveArrowView.OnWorldInputDragBeginSignal = OnWorldInputDragBeginSignal
UIGuideMoveArrowView.OnWorldInputDragEndSignal = OnWorldInputDragEndSignal
UIGuideMoveArrowView.CloseGuideMoveArrowSignal = CloseGuideMoveArrowSignal

return UIGuideMoveArrowView