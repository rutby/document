---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1022.
--- DateTime: 2023/4/14 10:58
---定时暂停特效
local VFXBase = require("Scene.PVEBattleLevel.VFX.VFXBase")
local TimerPauseVFX = BaseClass("TimerPauseVFX",VFXBase)

function TimerPauseVFX:InitAsset()
    self:CheckStartPause()
end

function TimerPauseVFX:CheckStartPause()
    local time = tonumber(self.m_template.para1)
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self.timer:Stop()
        self:Pause()
        self:CheckEndPause()
    end,time)
end

function TimerPauseVFX:CheckEndPause()
    local time = tonumber(self.m_template.para2)
    self.timer = TimerManager:GetInstance():DelayInvoke(function()
        self.timer:Stop()
        self:Play()
    end,time)
end

function TimerPauseVFX:ClearTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function TimerPauseVFX:Destroy()
    VFXBase.Destroy(self)
    self:ClearTimer()
end


return TimerPauseVFX