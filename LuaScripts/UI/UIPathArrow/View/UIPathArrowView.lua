--- UI配路径黄色箭头
--- Created by shimin.
--- DateTime: 2022/11/9 18:22

local UIPathArrowView = BaseClass("UIPathArrowView", UIBaseView)
local base = UIBaseView

local arrow_path = "ArrowGo"

local RefreshPositionTime = 0.5--防止按钮有动画，移动

--创建
function UIPathArrowView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIPathArrowView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPathArrowView:ComponentDefine()
    self.arrow = self:AddComponent(UIBaseContainer, arrow_path)
end

function UIPathArrowView:ComponentDestroy()
end

function UIPathArrowView:DataDefine()
    self.lossyScaleX = self.transform.lossyScale.x
    if self.lossyScaleX <= 0 then
        self.lossyScaleX = 1
    end
    self.lossyScaleY = self.transform.lossyScale.y
    if self.lossyScaleY <= 0 then
        self.lossyScaleY = 1
    end
    self.refresh_position_action = function(temp)
        self:RefreshPositionTimerCallBack()
    end
    self.param = nil
end

function UIPathArrowView:DataDestroy()
    self:DeleteRefreshPositionTimer()
    self.refresh_position_action = nil
    self.param = nil
end

function UIPathArrowView:OnEnable()
    base.OnEnable(self)
    self:ReInit()
end

function UIPathArrowView:OnDisable()
    base.OnDisable(self)
end

function UIPathArrowView:ReInit()
    self.param = self:GetUserData()
    self.screenPosition = Vector3.New(0,0,0)
    self:Refresh()
end

function UIPathArrowView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIPathArrowView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshGuideAnim, self.RefreshGuideAnimSignal)
end

function UIPathArrowView:Refresh()
    self:RefreshPositionTimerCallBack()
end

function UIPathArrowView:RefreshGuideAnimSignal(param)
    if param ~= nil and param.obj ~= nil then
        self.param = param
        self:Refresh()
    end
end

function UIPathArrowView:RefreshObjPosition(screenPosition)
    if screenPosition ~= nil then
        local screenX = screenPosition.x
        local screenY = screenPosition.y
        if self.screenPosition.x ~= screenX or self.screenPosition.y ~= screenY then
            self.screenPosition.x = screenX
            self.screenPosition.y = screenY
            self.arrow:SetPosition(self.screenPosition)
            self.arrow:SetEulerAngles(self.param.rotation)
        end
    end
end

function UIPathArrowView:DeleteRefreshPositionTimer()
    if self.refreshPositionTimer ~= nil then
        self.refreshPositionTimer:Stop()
        self.refreshPositionTimer = nil
    end
end

function UIPathArrowView:AddRefreshPositionTimer()
    self:DeleteRefreshPositionTimer()
    if self.refreshPositionTimer == nil then
        self.refreshPositionTimer = TimerManager:GetInstance():GetTimer(RefreshPositionTime, self.refresh_position_action , self, true,false,false)
        self.refreshPositionTimer:Start()
    end
end

function UIPathArrowView:RefreshPositionTimerCallBack()
    self:DeleteRefreshPositionTimer()
    self:ChangeHoleSize()
    self:AddRefreshPositionTimer()
end

function UIPathArrowView:ChangeHoleSize()
    if self.param.obj ~= nil then
        local rectTransform = self.param.obj.gameObject:GetComponent(typeof(CS.UnityEngine.RectTransform))
        if rectTransform ~= nil then
            local orSize = rectTransform.rect.size
            local lossyScaleX = self.param.obj.transform.lossyScale.x
            local lossyScaleY = self.param.obj.transform.lossyScale.y
            local sizeX = orSize.x * lossyScaleX / self.lossyScaleX
            local sizeY = orSize.y * lossyScaleY / self.lossyScaleY
            local pivot = rectTransform.pivot
            --这里的偏移在使用绝对位置self.param.obj.transform.position.y后，要乘以lossyScaleY才对
            local screenPosition = Vector3.New(self.param.obj.transform.position.x + (0.5 - pivot.x) * sizeX * lossyScaleX 
                    + self.param.extraPosition.x * self.lossyScaleX, 
                    self.param.obj.transform.position.y + (0.5 - pivot.y) * sizeY * lossyScaleY
                            + self.param.extraPosition.y * self.lossyScaleY, 
                    0)
            self:RefreshObjPosition(screenPosition)
        end
    end
end

return UIPathArrowView