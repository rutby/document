---
--- 引导箭头页面
--- Created by shimin.
--- DateTime: 2021/8/19 14:37
---
local UIGuideArrowView = BaseClass("UIGuideArrowView",UIBaseView)
local base = UIBaseView
local UIGuideArrowFingerType = require "UI.UIGuideArrow.Component.UIGuideArrowFingerType"

local hole_img_path = "HoleImg"
local mask_img_path = "HoleImg/MaskImg"
local during_img_path = "DuringImg"
local tip_go_path = "tip_go"
local tip_text_path = "tip_go/tip_bg/tip_text"
local tip_bg_path = "tip_go/tip_bg"

local RefreshPositionTime = 0.5--防止按钮有动画，移动
local WaitShowFinger = 0.3--等0.3s在显示手指
local InitAnimSpeed = 1
local TipsWidth = 350 + 40
local TipsDeltaY = 90

local ArrowPrefabName = {}
ArrowPrefabName[GuideArrowStyle.Finger] = "Assets/Main/Prefab_Dir/Guide/UIGuideArrowFingerType1.prefab"
ArrowPrefabName[GuideArrowStyle.Yellow] = "Assets/Main/Prefab_Dir/Guide/UIGuideArrowFingerType1.prefab"
ArrowPrefabName[GuideArrowStyle.Green] = "Assets/Main/Prefab_Dir/Guide/UIGuideArrowFingerType1.prefab"
ArrowPrefabName[GuideArrowStyle.ClickCallAirDrop] = "Assets/Main/Prefab_Dir/Guide/UIGuideArrowFingerType4.prefab"

local ArrowSize = {}
ArrowSize[GuideArrowStyle.Finger] = Vector2.New(80,80)
ArrowSize[GuideArrowStyle.Yellow] = Vector2.New(80,80)
ArrowSize[GuideArrowStyle.Green] = Vector2.New(80,80)
ArrowSize[GuideArrowStyle.ClickCallAirDrop] = Vector2.New(80,80)

local BuildSize = Vector2.New(160, 120)
local WorldYDelta = 80
local WorldYChangeDelta = 20

--按钮状态
local ArrowState = 
{
    Normal = 1,--正常状态
    Strength = 2,--加强状态
}

local ComponentType = 
{
    None = 0,
    Button = 1,
    Toggle = 2
}

--创建
function UIGuideArrowView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIGuideArrowView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGuideArrowView:ComponentDefine()
    self.hole_img = self:AddComponent(UIBaseContainer, hole_img_path)
    self.mask_img_btn = self:AddComponent(UIButton, mask_img_path)
    self.mask_img = self:AddComponent(UIImage, mask_img_path)
    self.during_img = self:AddComponent(UIButton, during_img_path)
    self.mask_img_btn:SetOnClick(function()
        self:OnMaskBtnClick()
    end)
    self.during_img:SetOnClick(function()
        self:OnDuringBtnClick()
    end)
    self.tip_go = self:AddComponent(UIBaseContainer, tip_go_path)
    self.tip_text = self:AddComponent(UITextMeshProUGUIEx, tip_text_path)
    self.tip_bg = self:AddComponent(UIBaseContainer, tip_bg_path)
end

function UIGuideArrowView:ComponentDestroy()
end


function UIGuideArrowView:DataDefine()
    self.onBtnClick = function()
        self:OnBtnClick()
    end
    self.onValueChanged = function(isOn)
        self:OnValueChanged(isOn)
    end
    self.lossyScaleX = self.transform.lossyScale.x
    if self.lossyScaleX <= 0 then
        self.lossyScaleX = 1
    end
    self.lossyScaleY = self.transform.lossyScale.y
    if self.lossyScaleY <= 0 then
        self.lossyScaleY = 1
    end
    self.maxSize =  Vector2.New(Screen.width / self.lossyScaleY,Screen.height / self.lossyScaleY)
    self.screenSize = Vector2.New(Screen.width ,Screen.height)
    self.tipMinX = TipsWidth / 2 * self.lossyScaleX
    self.tipMaxX = self.screenSize.x - TipsWidth / 2 * self.lossyScaleX
    self.tipDeltaY = TipsDeltaY * self.lossyScaleY
    self.arrowState = nil
    self.effect = {}
    self.refresh_position_action = function(temp)
        self:RefreshPositionTimerCallBack()
    end
    self.wait_show_finger_action = function(temp)
        self:WaitShowFingerTimerCallBack()
    end
    self.move_timer_action = function(temp)
        self:MoveTimerCallBack()
    end
    
    self.finger = {}
    self.isShowDuring = nil
    if CS.SceneManager.World ~= nil then
        CS.SceneManager.World.CanMoving = false
    end
    self.clickTime = 0
    self.holeSizeX = 0
    self.holeSizeY = 0
    self.param = nil
    self.componentType = ComponentType.None
    self.fingerPosition = Vector3.New(0,0,0)
    self.isShowFinger = true
end

function UIGuideArrowView:DataDestroy()
    if CS.SceneManager.World ~= nil then
        CS.SceneManager.World.CanMoving = true
    end
    self:DeleteRefreshPositionTimer()
    self:DeleteWaitShowFingerTimer()
    self:DeleteMoveCameraTimer()
    self:RemoveBtnClick()
    self.onBtnClick = nil
    self.onValueChanged = nil
    self.arrowState = nil
    self.effect = {}
    self.refresh_position_action = nil
    self.wait_show_finger_action = nil
    self.move_timer_action = nil
    self.finger = {}
    self.isShowDuring = nil
    self.clickTime = 0
    self.holeSizeX = 0
    self.holeSizeY = 0
    self.param = nil
    self.componentType = ComponentType.None
    self.isShowFinger = true
end

function UIGuideArrowView:OnEnable()
    base.OnEnable(self)
    self:ReInit()--打开界面时就关闭，不能在create
end

function UIGuideArrowView:OnDisable()
    base.OnDisable(self)
end

function UIGuideArrowView:ReInit()
    self.param = self:GetUserData()
    if self.param.arrowType == GuideArrowStyle.Finger then
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Guide_Finger)
    end
    self.screenPosition = Vector3.New(0,0,0)
    self.mask_img.rectTransform.sizeDelta = self.maxSize
    self:Refresh()
end

function UIGuideArrowView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
    self:AddUIListener(EventId.OnWorldInputPointUp, self.OnWorldInputPointUpSignal)
end

function UIGuideArrowView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
    self:RemoveUIListener(EventId.OnWorldInputPointUp, self.OnWorldInputPointUpSignal)
end

function UIGuideArrowView:Refresh()
    if self.param.fingerOffset == nil then
        self.param.fingerOffset = Vector3.New(0,0, 0)
    end
    self.clickTime = 0
    self:DeleteRefreshPositionTimer()
    self:DeleteWaitShowFingerTimer()
    self:DeleteMoveCameraTimer()
    self:RemoveBtnClick()
    if self:IsShowType() then
        self.screenPosition.x = -1
        self.screenPosition.y = -1
        self:AddBtnClick()
        self:CheckDuringShow()
        self:AddWaitShowFingerTimer()
        self:LoadFinger()
        if self.param.moveCamera then
            self:MoveCamera()
        end
        if self.param.des ~= nil then
            self.tip_text:SetText(self.param.des)
        end
    else
        self.ctrl:CloseSelf()
    end
end

function UIGuideArrowView:RefreshGuideSignal()
    self.clickTime = 0
    if DataCenter.GuideManager:IsGuideArrowType() then
        self:DeleteRefreshPositionTimer()
        self:DeleteWaitShowFingerTimer()
        self:DeleteMoveCameraTimer()
        self:RemoveBtnClick()
        self:SetShowDuring(true)
    else
        self.ctrl:CloseSelf()
    end
end

function UIGuideArrowView:RefreshGuideAnimSignal(param)
    self.param = param
    self:Refresh()
end

function UIGuideArrowView:OnBtnClick()
    self:SetShowDuring(true)
    DataCenter.GuideManager:HasClick(self.param.obj)
end

function UIGuideArrowView:OnMaskBtnClick()
    self:OnJumpClick()
    --OnJumpClick后变为空
    if self.param ~= nil then
        if self.param.forceType == GuideForceType.Soft then
            self.ctrl:CloseSelf()
            DataCenter.GuideManager:SetCurGuideId(GuideEndId)
            DataCenter.GuideManager:DoGuide()
        end
    end
end

function UIGuideArrowView:RemoveBtnClick()
    if self.btn ~= nil then
        if self.componentType == ComponentType.Button then
            self.btn.onClick:RemoveListener(self.onBtnClick)
            local ref = UIButton.DecRef(self.btn)
            if ref <= 0 then
                pcall(function() self.btn.onClick:Clear() end)
            end
        elseif self.componentType == ComponentType.Toggle then
            self.btn.onValueChanged:RemoveListener(self.onValueChanged)
            local ref = UIToggle.DecRef(self.btn)
            if ref <= 0 then
                pcall(function() self.btn.onValueChanged:Clear() end)
            end
        end
        self.btn = nil
    end
end

function UIGuideArrowView:AddBtnClick()
    if self.param.obj ~= nil and not self.param.noAddClick then
        if not IsNull(self.param.obj) then
            local objGame = self.param.obj.gameObject
            local have, component = objGame:TryGetComponent(typeof(CS.UnityEngine.UI.Button))
            if have then
                self.componentType = ComponentType.Button
                self.btn = component
                UIButton.AddRef(self.btn)
                self.btn.onClick:AddListener(self.onBtnClick)
            else
                have, component = objGame:TryGetComponent(typeof(CS.UnityEngine.UI.Toggle))
                if have then
                    self.componentType = ComponentType.Toggle
                    self.btn = component
                    UIToggle.AddRef(self.btn)
                    self.btn.onValueChanged:AddListener(self.onValueChanged)
                end
            end
        end
    end
end

function UIGuideArrowView:RefreshObjPosition(screenPosition)
    if screenPosition ~= nil then
        local screenX = screenPosition.x
        local screenY = screenPosition.y
        if screenX < 0 or screenX > self.screenSize.x or screenY < 0 or screenY > self.screenSize.y then
            --移动屏幕避免卡死
            self:MoveCamera()
        else
            if self.screenPosition.x ~= screenX or self.screenPosition.y ~= screenY then
                self.screenPosition.x = screenX
                self.screenPosition.y = screenY
                self.hole_img.transform.position = self.screenPosition
                self.mask_img.transform.localPosition = -self.hole_img.transform.localPosition
                local finger = self:GetCurFinger()
                if finger ~= nil then
                    finger:SetPosition(self:GetFingerPosition())
                end
                self.tip_go.transform.position = self.screenPosition
                --判断边界情况
                if screenX < self.tipMinX then
                    self.tip_bg:SetPositionXYZ(self.tipMinX, screenY + self.tipDeltaY, 0)
                elseif screenX > self.tipMaxX then
                    self.tip_bg:SetPositionXYZ(self.tipMaxX, screenY + self.tipDeltaY, 0)
                else
                    self.tip_bg:SetPositionXYZ(screenX, screenY + self.tipDeltaY, 0)
                end
                self:SetShowDuring(false)
            end
        end
    end
end

function UIGuideArrowView:DeleteRefreshPositionTimer()
    if self.refreshPositionTimer ~= nil then
        self.refreshPositionTimer:Stop()
        self.refreshPositionTimer = nil
    end
end

function UIGuideArrowView:AddRefreshPositionTimer()
    self:DeleteRefreshPositionTimer()
    if self.refreshPositionTimer == nil then
        self.refreshPositionTimer = TimerManager:GetInstance():GetTimer(RefreshPositionTime, self.refresh_position_action , self, true,false,false)
        self.refreshPositionTimer:Start()
    end
end

function UIGuideArrowView:RefreshPositionTimerCallBack()
    self:DeleteRefreshPositionTimer()
    self:ChangeHoleSize()
    self:AddRefreshPositionTimer()
    self:CheckGuideJump()
end

function UIGuideArrowView:CheckDuringShow()
    self:SetShowDuring(false)
    self:ChangeHoleSize()
    self:AddRefreshPositionTimer()
end
function UIGuideArrowView:OnDuringBtnClick()
    self:OnJumpClick()
    if self.param ~= nil then
        if self.param.forceType == GuideForceType.Soft then
            
            self.ctrl:CloseSelf()
            DataCenter.GuideManager:SetCurGuideId(GuideEndId)
            DataCenter.GuideManager:DoGuide()
        end
    end
end

function UIGuideArrowView:DeleteWaitShowFingerTimer()
    if self.waitShowFingerTimer ~= nil then
        self.waitShowFingerTimer:Stop()
        self.waitShowFingerTimer = nil
    end
end

function UIGuideArrowView:AddWaitShowFingerTimer()
    self.isShowFinger = false
    self:RefreshFinger()
    self:DeleteWaitShowFingerTimer()
    if self.waitShowFingerTimer == nil then
        self.waitShowFingerTimer = TimerManager:GetInstance():GetTimer(WaitShowFinger, self.wait_show_finger_action , self, true,false,false)
        self.waitShowFingerTimer:Start()
    end
end

function UIGuideArrowView:WaitShowFingerTimerCallBack()
    self:DeleteWaitShowFingerTimer()
    self.isShowFinger = true
    self:RefreshFinger()
end

function UIGuideArrowView:AdjustCamera()
    if self.param.objPositionType == PositionType.World then
        local IsInBattleLevel = DataCenter.BattleLevel:IsInBattleLevel()
        local pos = nil
        if self.param.obj ~= nil then
            pos = self.param.obj.transform.position
        elseif self.param.objWorldPos ~= nil then
            pos = self.param.objWorldPos
        end
        if pos ~= nil then
            if IsInBattleLevel then
                DataCenter.BattleLevel:AutoLookat(pos, DataCenter.BattleLevel:GetCameraZoom() ,LookAtFocusTime)
            else
                GoToUtil.GotoPos(pos, CS.SceneManager.World.InitZoom, LookAtFocusTime)
            end
        end
      
    end
end

function UIGuideArrowView:DeleteMoveCameraTimer()
    if self.moveTimer ~= nil then
        self.moveTimer:Stop()
        self.moveTimer = nil
    end
end

function UIGuideArrowView:AddMoveTimerTimer()
    self:DeleteMoveCameraTimer()
    if self.moveTimer == nil then
        self.moveTimer = TimerManager:GetInstance():GetTimer(LookAtFocusTime, self.move_timer_action , self, true,false,false)
        self.moveTimer:Start()
    end
end

function UIGuideArrowView:MoveTimerCallBack()
    self:DeleteMoveCameraTimer()
    self.screenPosition.x = -1
    self.screenPosition.y = -1
    self:ChangeHoleSize()
    self:AddRefreshPositionTimer()
end

function UIGuideArrowView:MoveCamera()
    if self.moveTimer == nil then
        self:AdjustCamera()
        self:SetShowDuring(true)
        self:AddMoveTimerTimer()
    end
end

function UIGuideArrowView:LoadFinger()
    for k,v in pairs(self.finger) do
        v:SetActive(false)
    end
    local prefabName = ArrowPrefabName[self.param.arrowType]
    local param = {}
    param.arrowDirection = self.param.arrowDirection
    param.animSpeed = self.param.animSpeed or InitAnimSpeed
    param.position = self:GetFingerPosition()
    if self.finger[prefabName] == nil then
        self:GameObjectInstantiateAsync(prefabName, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            param.position = self:GetFingerPosition()
            self.finger[prefabName] = self:AddComponent(UIGuideArrowFingerType, nameStr)
            self.finger[prefabName]:ReInit(param)
            self:RefreshFinger()
        end)
    else
        self.finger[prefabName]:ReInit(param)
        self:RefreshFinger()
    end
end

function UIGuideArrowView:SetShowDuring(isShow)
    if self.isShowDuring ~= isShow then
        self.isShowDuring = isShow
        if isShow then
            self.during_img:SetActive(true)
            self.hole_img:SetActive(false)
        else
            self.during_img:SetActive(false)
            self.hole_img:SetActive(true)
        end
        self:RefreshFinger()
    end
end

function UIGuideArrowView:GetCurFinger()
    if self.param.arrowType ~= nil then
        return self.finger[ArrowPrefabName[self.param.arrowType]]
    end
end

function UIGuideArrowView:ChangeHoleSize()
    local screenPosition = nil
    local sizeX = 0
    local sizeY = 0
    local lossyScaleX = 1
    local lossyScaleY = 1
    if self.btn ~= nil then
        if not IsNull(self.btn) then
            local rectTransform = self.btn.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
            if rectTransform ~= nil then
                local orSize = rectTransform.rect.size
                --这里是为了处理父物体缩放 正常是1
                lossyScaleX = self.btn.transform.lossyScale.x
                lossyScaleY = self.btn.transform.lossyScale.y
                sizeX = orSize.x * lossyScaleX / self.lossyScaleX
                sizeY = orSize.y * lossyScaleY / self.lossyScaleY
            end
        end
    elseif self.param.obj ~= nil then
        if not IsNull(self.param.obj) then
            local have,rectTransform = self.param.obj.gameObject:TryGetComponent(typeof(CS.UnityEngine.Collider))
            if have then
                local orSize = rectTransform.bounds.extents
                local worldPos = rectTransform.bounds.center
                local otherPos = worldPos + orSize
                screenPosition = self:GetScreenPoint(worldPos)
                local otherScreenPos = self:GetScreenPoint(otherPos)
                sizeX = (otherScreenPos.x - screenPosition.x) * 2
                sizeY = (otherScreenPos.y - screenPosition.y) * 2
                --有倾斜角度 
                if sizeY > WorldYDelta then
                    sizeY = sizeY - WorldYChangeDelta
                end
            else
                local collider = self.param.obj.transform:GetComponentInChildren(typeof(CS.UnityEngine.Collider), true)
                if collider == nil then
                    have,rectTransform = self.param.obj.gameObject:TryGetComponent(typeof(CS.UnityEngine.RectTransform))
                    if have then
                        local orSize = rectTransform.rect.size
                        lossyScaleX = self.param.obj.transform.lossyScale.x
                        lossyScaleY = self.param.obj.transform.lossyScale.y
                        sizeX = orSize.x * lossyScaleX / self.lossyScaleX
                        sizeY = orSize.y * lossyScaleY / self.lossyScaleY
                    else
                        have,rectTransform = self.param.obj.gameObject:TryGetComponent(typeof(CS.UnityEngine.Renderer))
                        if have then
                            local orSize = rectTransform.bounds.size
                            local worldPos = self.param.obj.transform.position
                            local otherPos = Vector3.New(worldPos.x + orSize.x / 2, worldPos.y + orSize.y / 2, worldPos.z)
                            local screenPos = self:GetScreenPoint(worldPos)
                            local otherScreenPos = self:GetScreenPoint(otherPos)
                            sizeX = (otherScreenPos.x - screenPos.x) * 2
                            sizeY = (otherScreenPos.y - screenPos.y) * 2
                        else
                            sizeX,sizeY = self:GetSpecialSize()
                        end
                    end
                else
                    local orSize = collider.bounds.extents
                    local worldPos = rectTransform.bounds.center
                    local otherPos = worldPos + orSize
                    screenPosition = self:GetScreenPoint(worldPos)
                    local otherScreenPos = self:GetScreenPoint(otherPos)
                    sizeX = (otherScreenPos.x - screenPosition.x) * 2
                    sizeY = (otherScreenPos.y - screenPosition.y) * 2
                    --有倾斜角度 
                    if sizeY > WorldYDelta then
                        sizeY = sizeY - WorldYChangeDelta
                    end
                end
            end
        end
    else
        sizeX,sizeY = self:GetSpecialSize()
    end
    if self.holeSizeX ~= sizeX or self.holeSizeY ~= sizeY then
        self.holeSizeX = sizeX
        self.holeSizeY = sizeY
        self.hole_img.rectTransform:Set_sizeDelta(self.holeSizeX,self.holeSizeY)
    end
    if screenPosition == nil then
        if self.param.objPositionType == PositionType.Screen then
            if self.param.obj ~= nil then
                if not IsNull(self.param.obj) then
                    --描点千奇百怪 这里适配
                    local rectTransform = self.param.obj.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
                    if rectTransform ~= nil then
                        local pivot = rectTransform.pivot
                        --这里比较复杂，处理描点比较好理解，后面乘以 self.param.obj.transform.lossyScale.x是为了取self.param.obj.transform.position.x时是最外层有长宽屏幕缩放
                        --此时sizeX 就不对了 要 * self.param.obj.transform.lossyScale.x 才是最外层实际坐标
                        screenPosition = Vector3.New(self.param.obj.transform.position.x + (0.5 - pivot.x) * sizeX * lossyScaleX,
                                self.param.obj.transform.position.y + (0.5 - pivot.y) * sizeY * lossyScaleY,
                                0)
                    else
                        screenPosition = self.param.obj.transform.position
                    end
                end
            elseif self.param.objWorldPos ~= nil then
                screenPosition = self.param.objWorldPos
            end
        elseif self.param.objPositionType == PositionType.World then
            if self.param.obj ~= nil then
                if not IsNull(self.param.obj) then
                    screenPosition = self:GetScreenPoint(self.param.obj.transform.position)
                end
            elseif self.param.objWorldPos ~= nil then
                screenPosition = self:GetScreenPoint(self.param.objWorldPos)
            end
        end
    end
    self:RefreshObjPosition(screenPosition)
end


function UIGuideArrowView:OnWorldInputPointUpSignal()
    if CS.SceneManager.World ~= nil then
        CS.SceneManager.World.CanMoving = false
    end
end

function UIGuideArrowView:GetSpecialSize()
    if self.param.isBuild then
        if self.param.buildId == BuildingTypes.FUN_BUILD_MAIN then
            local screenPosition = self:GetScreenPoint(self.param.objWorldPos)
            local MaxScreenPosition = self:GetScreenPoint(self.param.objWorldPos + Vector3.New(1, 0, 1))
            local delta = MaxScreenPosition - screenPosition
            --这里数据是最外层的屏幕坐标，要转成750*1334的屏幕坐标
            return delta.x * 2 / self.lossyScaleX, delta.y * 2 / self.lossyScaleY
        end
        return BuildSize.x , BuildSize.y
    end
    return ArrowSize[self.param.arrowType].x , ArrowSize[self.param.arrowType].y
end

function UIGuideArrowView:OnJumpClick()
    self.clickTime = self.clickTime + 1
    if self.clickTime >= GuideClickAutoStopTime then
        self.clickTime = 0
        DataCenter.GuideManager:ClickMuchStop()
    end
end

function UIGuideArrowView:IsShowType()
    if self.param ~= nil and (not self.param.useGuide or DataCenter.GuideManager:IsGuideArrowType()) then
        return true
    end
    return false
end

function UIGuideArrowView:OnValueChanged(isOn)
    DataCenter.GuideManager:HasClick(self.param.obj)
end

function UIGuideArrowView:GetScreenPoint(worldPos)
    if DataCenter.BattleLevel:IsInBattleLevel() then
        return DataCenter.BattleLevel:WorldToScreenPoint(worldPos)
    else
        return CS.SceneManager.World:WorldToScreenPoint(worldPos)
    end
end

function UIGuideArrowView:GetFingerPosition()
    self.fingerPosition.x = self.screenPosition.x + self.param.fingerOffset.x * self.lossyScaleX
    self.fingerPosition.y = self.screenPosition.y + self.param.fingerOffset.y * self.lossyScaleY
    return self.fingerPosition
end

function UIGuideArrowView:RefreshFinger()
    local show = (not self.isShowDuring) and self.isShowFinger
    local finger = self:GetCurFinger()
    if finger ~= nil then
        finger:SetActive(show)
    end
    if show then
        if self.param.des ~= nil then
            self.tip_go:SetActive(true)
        end
    else
        self.tip_go:SetActive(false)
    end 
end

function UIGuideArrowView:CheckGuideJump()
    if DataCenter.GuideManager:InGuide() then
        local guideId = DataCenter.GuideManager:GetGuideId()
        if DataCenter.GuideManager:GetCanDoGuideState(guideId) == GuideCanDoType.No then
            --这里走跳过
            local jumpid = GetTableData(DataCenter.GuideTemplateManager:GetTableName(), guideId, "jumpid", 0)
            if jumpid ~= 0 then
                DataCenter.GuideManager:SetCurGuideId(jumpid)
            else
                DataCenter.GuideManager:SetCurGuideId(GuideEndId)
            end
            DataCenter.GuideManager:DoGuide()
        end
    end
end

return UIGuideArrowView