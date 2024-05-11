--- Created by shimin.
--- DateTime: 2024/3/12 20:15
--- 大本升级后光范围变化

local BaseBuildLightRangeScene = BaseClass("BaseBuildLightRangeScene")
local Resource = CS.GameEntry.Resource

local effect_go_path = "Eff_scene_qusan_02"

local WaitStartTime = 1.5
local DoScaleTime = 1

function BaseBuildLightRangeScene:__init()
    self:DataDefine()
end

function BaseBuildLightRangeScene:__delete()
    
end

function BaseBuildLightRangeScene:Destroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function BaseBuildLightRangeScene:DataDefine()
    self.param = {}
    self.gameObject = nil
    self.transform = nil
    self.req = nil
    self.timer_callback = function() 
        self:OnTimerCallBack()
    end
end

function BaseBuildLightRangeScene:DataDestroy()
    self:RemoveOneTime()
    self:DestroyReq()
end

function BaseBuildLightRangeScene:DestroyReq()
    if self.req ~= nil then
        self.req:Destroy()
        self.req = nil

        self.gameObject = nil
        self.transform = nil
    end
end

function BaseBuildLightRangeScene:ComponentDefine()
    self.effect_go = self.transform:Find(effect_go_path).gameObject
end

function BaseBuildLightRangeScene:ComponentDestroy()
end

function BaseBuildLightRangeScene:ReInit(param)
    self.param = param
    self:Create()
end

function BaseBuildLightRangeScene:Create()
    if self.req == nil then
        self.req = Resource:InstantiateAsync(UIAssets.BaseBuildLightRangeScene)
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

function BaseBuildLightRangeScene:Refresh()
    self.effect_go.transform:Set_localScale(self.param.startScale.x, self.param.startScale.y, self.param.startScale.z)
    self.transform.localPosition = ResetPosition
    self:AddOneTime()
end

function BaseBuildLightRangeScene:Pause()
end

function BaseBuildLightRangeScene:Resume()
end

function BaseBuildLightRangeScene:GetGuideTalkObject(id)
end

function BaseBuildLightRangeScene:AddOneTime()
    self:RemoveOneTime()
    self.timer = TimerManager:GetInstance():GetTimer(WaitStartTime, self.timer_callback, nil, true, false, false)
    self.timer:Start()
end

function BaseBuildLightRangeScene:RemoveOneTime()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function BaseBuildLightRangeScene:OnTimerCallBack()
    self:RemoveOneTime()
    self.effect_go.transform:DOScale(self.param.endScale, DoScaleTime):SetEase(CS.DG.Tweening.Ease.OutCubic):OnComplete(function()
        DataCenter.EffectSceneManager:DestroyOneScene(self.param.sceneType)
    end)
end

return BaseBuildLightRangeScene