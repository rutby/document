---
--- Created by shimin.
--- DateTime: 2022/6/21 14:38
--- UIMain顶部资源条
---

local ResourceProgressItem = BaseClass("ResourceProgressItem", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local anim_path = "root"
local resource_icon_path = "root/resourceIcon"
local resource_num_path = "root/resourceNum"

local CountNumJumpTimes = 10--超过10个就10个数一变
local ChangePerTime = 100--多长时间变化一次
local DelayTime = 0.5--0.5秒后刷新资源数量，防止显示不正确
local PickUpEffectDestroyTime = 2.5
local DeleteTime = 3

local AnimName =
{
    Play = "Play",
    PickUp = "Play1",
    Idle = "Idle",
}


function ResourceProgressItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function ResourceProgressItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
function ResourceProgressItem:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.resource_icon = self:AddComponent(UIImage, resource_icon_path)
    self.anim = self:AddComponent(UIAnimator, anim_path)
    self.resource_num = self:AddComponent(UIText, resource_num_path)
    self.btn:SetOnClick(function()
        self.view.ctrl:OnClickResourceBtn(self.param.resourceType)
    end)
end

--控件的销毁
function ResourceProgressItem:ComponentDestroy()
    self.btn = nil
    self.resource_icon = nil
    self.anim = nil
    self.resource_num = nil
end

function ResourceProgressItem:DataDefine()
    self.param = {}
    self._resNumShow = 0 --现在显示的数值
    self._resNumTarget = 0 --目标显示的数值
    self._resNumDelta = 0
    self._lastSetTime = 0
    self.delay_timer_action = function()
        self:DelayRefreshTimerBallBack()
    end
    self.delete_timer_action = function()
        self:DeleteTimerBallBack()
    end
    self.deleteTimer = nil
    self.delayTimer = nil
    self.pickUpEffect = {}
end

function ResourceProgressItem:DataDestroy()
    self:DeleteTimer()
    self:RemoveAllPickUpEffect()
    self:DeleteDelayRefreshTimer()
    self.param = {}
    self._resNumShow = 0 --现在显示的数值
    self._resNumTarget = 0 --目标显示的数值
    self._resNumDelta = 0
    self._lastSetTime = 0
    self.delay_timer_action = nil
    self.delayTimer = nil
    self.delete_timer_action = nil
    self.deleteTimer = nil
    self.pickUpEffect = {}
end

function ResourceProgressItem:ReInit(param)
    self:DeleteTimer()
    self:RemoveAllPickUpEffect()
    self:DeleteDelayRefreshTimer()
    self.param = param
    self.resource_icon:LoadSprite(param.iconName)
    self._resNumShow = self.view.ctrl:GetCntByResType(self.param.resourceType)
    self._resNumTarget = self._resNumShow
    local numStr = self:FormatNum(self._resNumTarget, self.param.resourceType)
    self.resource_num:SetText(numStr)
    if self.param.showExpandAnimation then
        --这个时候要被删掉
        self.anim:SetTrigger(AnimName.Play)
        self:AddDeleteTimer()
        if self.param.showExpandParam ~= nil then
            self:AddOnePickEffect(self.param.showExpandParam)
        end
    else
        self.anim:Play(AnimName.Idle,0,0)
    end
    EventManager:GetInstance():Broadcast(EventId.RefreshTopResSuc)
end

--刷新显示
function ResourceProgressItem:Refresh()
    self:DoResNumChange()
end

function ResourceProgressItem:OnEnable()
    base.OnEnable(self)
end

function ResourceProgressItem:OnDisable()
    base.OnDisable(self)
end

--做资源改变数值滚动
function ResourceProgressItem:DoResNumChange()
    self._resNumTarget = self.view.ctrl:GetCntByResType(self.param.resourceType)
    if self._resNumShow ~= self._resNumTarget then
        self._resNumDelta = (self._resNumTarget - self._resNumShow) / CountNumJumpTimes
        if math.modf(self._resNumDelta) == 0 then
            self._resNumDelta = self._resNumDelta > 0 and 1 or -1
        else
            self._resNumDelta = math.modf(self._resNumDelta)
        end
        self._lastSetTime = UITimeManager:GetInstance():GetServerTime()
    else
        local numStr = self:FormatNum(self._resNumTarget, self.param.resourceType)
        self.resource_num:SetText(numStr)
    end
end

function ResourceProgressItem:Update()
    if self._resNumShow ~= self._resNumTarget then
        local tempT = UITimeManager:GetInstance():GetServerTime()
        if (tempT - self._lastSetTime) >= ChangePerTime then
            self._lastSetTime = tempT
            self._resNumShow = self._resNumShow + self._resNumDelta
            if self._resNumDelta > 0 and self._resNumShow > self._resNumTarget then
                self._resNumShow = self._resNumTarget
            elseif self._resNumDelta < 0 and self._resNumShow < self._resNumTarget then
                self._resNumShow = self._resNumTarget
            end
            self.resource_num:SetText(string.GetFormattedSeperatorNum(self._resNumShow))
            if self._resNumShow == self._resNumTarget then
                self:AddDelayRefreshTimer()
            end
        end
    end
end

function ResourceProgressItem:AddDelayRefreshTimer()
    self:DeleteDelayRefreshTimer()
    self.delayTimer = TimerManager:GetInstance():GetTimer(DelayTime, self.delay_timer_action , self, true, false,false)
    self.delayTimer:Start()
end

function ResourceProgressItem:DelayRefreshTimerBallBack()
    self:DeleteDelayRefreshTimer()
    local num = self.view.ctrl:GetCntByResType(self.param.resourceType)
    local numStr = self:FormatNum(num, self.param.resourceType)
    self.resource_num:SetText(numStr)
end

function ResourceProgressItem:DeleteDelayRefreshTimer()
    if self.delayTimer ~= nil then
        self.delayTimer:Stop()
        self.delayTimer = nil
    end
end

--得到资源的坐标
function ResourceProgressItem:GetResourcePos()
    return self.resource_icon.transform.position
end


--改变数据
function ResourceProgressItem:ChangeParam(param)
    self.param = param
    self:DeleteTimer()
    if self.param.showExpandAnimation then
        self.anim:SetTrigger(AnimName.PickUp)
        if self.param.showExpandParam ~= nil then
            self:AddOnePickEffect(self.param.showExpandParam)
        end
    else
        self.anim:Play(AnimName.Idle,0,0)
    end
    self:Refresh()
end

function ResourceProgressItem:AddOnePickEffect(param)
    local effectPath = ResourceTypePickUpEffectName{self.param.resourceType}
    if effectPath ~= nil then
        local id = NameCount
        NameCount = NameCount + 1
        self.pickUpEffect[id] = {}
        self.pickUpEffect[id].inst = self:GameObjectInstantiateAsync(effectPath, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            if param ~= nil then
                UIUtil.DoFly(param.rewardTyp, param.num, param.pic, param.screenPos, param.flyPos, 66, 66, nil, param.useTextFormat)
            end
            go:SetActive(true)
            go.transform:SetParent(self.resource_icon.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:Set_localPosition(ResetPosition.x, ResetPosition.y, ResetPosition.z)
            self.pickUpEffect[id].timer = TimerManager:GetInstance():DelayInvoke(function()
                self:RemoveOnePickEffect(id)
            end, PickUpEffectDestroyTime)

        end)
    end
end

function ResourceProgressItem:RemoveOnePickEffect(id)
    if self.pickUpEffect[id] ~= nil then
        if self.pickUpEffect[id].timer ~= nil then
            self.pickUpEffect[id].timer:Stop()
            self.pickUpEffect[id].timer = nil
        end
        if self.pickUpEffect[id].inst ~= nil then
            self:GameObjectDestroy(self.pickUpEffect[id].inst)
        end
        self.pickUpEffect[id] = nil
    end
end

function ResourceProgressItem:RemoveAllPickUpEffect()
    for k,v in pairs(self.pickUpEffect) do
        if v.timer ~= nil then
            v.timer:Stop()
            v.timer = nil
        end
        if v.inst ~= nil then
            self:GameObjectDestroy(v.inst)
        end
    end
    self.pickUpEffect = {}
end

--做完动画要删掉
function ResourceProgressItem:AddDeleteTimer()
    self:DeleteTimer()
    self.deleteTimer = TimerManager:GetInstance():GetTimer(DeleteTime, self.delete_timer_action , self, true, false,false)
    self.deleteTimer:Start()
end

function ResourceProgressItem:DeleteTimerBallBack()
    self:DeleteTimer()
    if self.param.parent ~= nil then
        self.param.parent:RemoveOneResourceCell(self.param.resourceType)
    end
end

function ResourceProgressItem:DeleteTimer()
    if self.deleteTimer ~= nil then
        self.deleteTimer:Stop()
        self.deleteTimer = nil
    end
end

function ResourceProgressItem:SetTextColor(color)
    if self.resource_num ~= nil then
        self.resource_num:SetColor(color)
    end
end

function ResourceProgressItem:FormatNum(num, type)
    if type == ResourceType.People then
        if num >= 10000 then
            return string.GetFormattedStr(num)
        else
            return string.GetFormattedSeperatorNum(num)
        end
    else
        return string.GetFormattedStr(num)
    end
end

return ResourceProgressItem