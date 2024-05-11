--- Created by shimin.
--- DateTime: 2024/4/17 11:16
--- 地块翻地烟尘

local LandLockSmokeEffect = BaseClass("LandLockSmokeEffect")
local Resource = CS.GameEntry.Resource

local WaitDestroyTime = 1.5

function LandLockSmokeEffect:__init()
    self:DataDefine()
end

function LandLockSmokeEffect:__delete()
    
end

function LandLockSmokeEffect:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function LandLockSmokeEffect:DataDefine()
    self.param = {}
    self.gameObject = nil
    self.transform = nil
    self.req = nil
    self.timer_callback = function() 
        self:OnTimerCallBack()
    end
end

function LandLockSmokeEffect:DataDestroy()
    self:RemoveOneTime()
    self:DestroyReq()
end

function LandLockSmokeEffect:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function LandLockSmokeEffect:ComponentDefine()
end

function LandLockSmokeEffect:ComponentDestroy()
end

function LandLockSmokeEffect:ReInit(param)
    self.param = param
    self:Create()
end

function LandLockSmokeEffect:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.LandLockSmokeEffect)
        self.req:completed('+', function()
            self.gameObject = self.req.gameObject
            self.transform = self.req.gameObject.transform
            self:ComponentDefine()
            self:Refresh()
        end)
    elseif self.gameObject ~= nil then
        self:Refresh()
    end
end

function LandLockSmokeEffect:Refresh()
    self.transform.position = self.param.position
    self:AddOneTime()
end

function LandLockSmokeEffect:Pause()
end

function LandLockSmokeEffect:Resume()
end

function LandLockSmokeEffect:GetGuideTalkObject(id)
end

function LandLockSmokeEffect:AddOneTime()
    self:RemoveOneTime()
    self.timer = TimerManager:GetInstance():GetTimer(WaitDestroyTime, self.timer_callback, nil, true, false, false)
    self.timer:Start()
end

function LandLockSmokeEffect:RemoveOneTime()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function LandLockSmokeEffect:OnTimerCallBack()
    self:RemoveOneTime()
    if self.param.callback ~= nil then
        self.param.callback()
    end
end

return LandLockSmokeEffect