--- Created by shimin.
--- DateTime: 2021/9/10 20:20
--- 点击迷雾的二次确认框

local GotoMoveBubble = BaseClass("GotoMoveBubble")
local btn_path = "Go/Bg"
local anim_path = "Go"
local PositionDelta1 = Vector3.New(0,0,0)

local AnimName = 
{
    Hide = "HideBubble",
    Enter = "EnterBubble",
    Idle = "NormalBubble",
    Click = "V_dianjibubble"
}

--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
end

local function ComponentDefine(self)
    self.btn = self.transform:Find(btn_path):GetComponent(typeof(CS.UIEventTrigger))
    self.anim = self.transform:Find(anim_path):GetComponent(typeof(CS.SimpleAnimation))
    self.btn.onPointerClick = function()
        self:OnBtnClick()
    end
end

local function ComponentDestroy(self)
    self.btn.onPointerClick = nil
    self.btn = nil
    self.anim = nil
    self.gameObject = nil
    self.transform = nil
end


local function DataDefine(self)
    self.param = nil
    self.state = nil
    self.timer_action = function(temp)
        self:TimeCallBack()
    end
end

local function DataDestroy(self)
    self.param = nil
    self.state = nil
    self.timer_action = nil
    self:DeleteTimer()
end

local function ReInit(self,param)
    self.param = param
    self:ShowPanel()
end

local function ShowPanel(self)
    self.transform.position = SceneUtils.TileIndexToWorld(self.param.posIndex) + PositionDelta1
    self:PlayAnim(AnimName.Enter)
end

local function OnBtnClick(self)
    DataCenter.GotoMoveBubbleManager:OnClickCallBack(self.param)
end

local function GetGuideBtn(self) 
    return self.btn.gameObject
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function AddTimer(self,time)
    self:DeleteTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(time, self.timer_action , self, true,false,false)
    end
    self.timer:Start()
end

local function TimeCallBack(self)
    self:DeleteTimer()
    if self.state == AnimName.Enter then
        self:PlayAnim(AnimName.Idle)
    elseif self.state == AnimName.Hide then
        DataCenter.GotoMoveBubbleManager:DestroyUI()
    end
end

local function PlayAnim(self,name)
    if self.state ~= name then
        self.state = name
        local time = self.anim:GetClipLength(name)
        if time > 0 then
            self.anim:Play(name)
            self:AddTimer(time)
        end
    end
end

local function Hide(self) 
    self:PlayAnim(AnimName.Hide)
end

GotoMoveBubble.OnCreate = OnCreate
GotoMoveBubble.OnDestroy = OnDestroy
GotoMoveBubble.ComponentDefine = ComponentDefine
GotoMoveBubble.ComponentDestroy = ComponentDestroy
GotoMoveBubble.DataDefine = DataDefine
GotoMoveBubble.DataDestroy = DataDestroy
GotoMoveBubble.ReInit = ReInit
GotoMoveBubble.ShowPanel = ShowPanel
GotoMoveBubble.OnBtnClick = OnBtnClick
GotoMoveBubble.GetGuideBtn = GetGuideBtn
GotoMoveBubble.DeleteTimer = DeleteTimer
GotoMoveBubble.AddTimer = AddTimer
GotoMoveBubble.TimeCallBack = TimeCallBack
GotoMoveBubble.PlayAnim = PlayAnim
GotoMoveBubble.Hide = Hide

return GotoMoveBubble