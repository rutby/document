--- 手指管理器
--- Created by shimin.
--- DateTime: 2024/2/1 17:31
local ArrowManager = BaseClass("ArrowManager")

function ArrowManager:__init()
    self.secondParam = nil--里面存放List<param> 用于连续指向按钮的情况（英雄进阶任务指向4次）用一个移除一个，不存index
    self.next_timer_callback = function() 
        self:NextFrameTimeCallback()
    end
end

function ArrowManager:__delete()
    self:DeleteNextFrameTimer()
    self:RemoveArrow()
end

function ArrowManager:ShowArrow(param)
    if not DataCenter.GuideManager:InGuide() then
        if param.position ~= nil then
            if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIArrow) then
                EventManager:GetInstance():Broadcast(EventId.RefreshArrow, param)
            else
                UIManager:GetInstance():OpenWindow(UIWindowNames.UIArrow, {anim = true}, param)
            end
        end
    end
end

function ArrowManager:RemoveArrow()
    if UIManager:GetInstance():IsWindowOpen(UIWindowNames.UIArrow) then
        UIManager:GetInstance():DestroyWindow(UIWindowNames.UIArrow)
    end
end

--针对任务跳转等连续出现手指的情况
function ArrowManager:GetSecondArrowParam()
    if self.secondParam ~= nil then
        return self.secondParam[1]
    end
    return nil
end

--针对任务跳转等连续出现手指的情况
function ArrowManager:SetSecondArrowParam(param)
    self.secondParam = param
end

--针对任务跳转等连续出现手指的情况
function ArrowManager:CheckShowNext()
    --这里在打开界面时uiManager会把UIArrow先关闭,导致IsWindowOpen拿不到打开ui，所以先等一帧
    self:AddNextFrameTimer()
end

function ArrowManager:WaitShowNext()
    local param = self:GetSecondArrowParam()
    if param ~= nil and (not param.noAutoNext) then
        --检测是否需要群不删除(这里暂时没想好怎么做，先用判断下一个页面有没有打开的方法来算，没打开就全部删掉)
        local needStop = true
        local next = self.secondParam[2]
        if next ~= nil then
            if UIManager:GetInstance():IsWindowOpen(next.uiName) then
                needStop = false
            end
        end

        if needStop then
            self.secondParam = nil
        else
            table.remove(self.secondParam, 1)
        end
        EventManager:GetInstance():Broadcast(EventId.SecondArrow)
    end
end

function ArrowManager:AddNextFrameTimer()
    if self.next_timer == nil then
        self.next_timer = TimerManager:GetInstance():GetTimer(NextFrameTime, self.next_timer_callback, self, true, false, false)
    end
    self.next_timer:Start()
end

function ArrowManager:DeleteNextFrameTimer()
    if self.next_timer ~= nil then
        self.next_timer:Stop()
        self.next_timer = nil
    end
end

function ArrowManager:NextFrameTimeCallback()
    self:DeleteNextFrameTimer()
    self:WaitShowNext()
end


return ArrowManager
