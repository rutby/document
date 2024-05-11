

local ParkourJoystick = BaseClass("ParkourJoystick", UIBaseContainer)
local base = UIBaseContainer
local Touch = CS.BitBenderGames.TouchWrapper

local touch_path = "Touch"
local select_path = "Touch/TouchSelect"

local SelectRangeMax = 76
local Sensitivity = 1
local Epsilon = 0.01
local SqrEpsilon = 0.0001

function ParkourJoystick:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function ParkourJoystick:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function ParkourJoystick:ComponentDefine()
    self.touch_go = self:AddComponent(UIBaseContainer, touch_path)
    self.select_go = self:AddComponent(UIBaseContainer, select_path)
end

function ParkourJoystick:ComponentDestroy()
    self.touch_go = nil
    self.select_go = nil
end

function ParkourJoystick:DataDefine()
    self.fingers = {} -- Dict<fingerId, finger>
    self.curFinger = nil
    self.originX = 0
    self.originY = 0
    self.enabled = false
    local defaultScreenPos = Vector3.New(Screen.width*0.5,Screen.height*0.2,0) 
    self.defaultWorldPos = UIManager:GetInstance():GetUICamera():ScreenToWorldPoint(defaultScreenPos)--摇杆默认位置
end

function ParkourJoystick:DataDestroy()
    self.fingers = nil
    self.curFinger = nil
    self.originX = nil
    self.originY = nil
    self.enabled = nil
end

function ParkourJoystick:OnEnable()
    base.OnEnable(self)
end

function ParkourJoystick:OnDisable()
    base.OnDisable(self)
end

function ParkourJoystick:OnAddListener()
    base.OnAddListener(self)
end

function ParkourJoystick:OnRemoveListener()
    base.OnRemoveListener(self)
end

function ParkourJoystick:ReInit()
    self.enabled = true
    --self.touch_go:SetActive(false)
end

---- 清空手指，隐藏摇杆
--function ParkourJoystick:Clear()
--    self.fingers = {}
--    self.curFinger = nil
--    self.touch_go:SetActive(false)
--end

-- 清空手指，摇杆复位
function ParkourJoystick:Reset()
    self.fingers = {}
    self.curFinger = nil
    self.touch_go.transform.position=self.defaultWorldPos
    self.select_go.transform:Set_localPosition(0, 0, 0)
end

function ParkourJoystick:SetEnabled(enabled)
    self:Reset()
    self.enabled = enabled
    self.touch_go:SetActive(enabled)
end

function ParkourJoystick:GetEnabled()
    return self.enabled
end


-- 设置摇杆中心位置
-- 返回 Vx 和 Vz
function ParkourJoystick:TouchPos(pos)
    local x = pos.x - self.originX
    local y = pos.y - self.originY
    local sqrD = x * x + y * y
    if sqrD < SqrEpsilon then
        return 0, 0
    end
    local d = math.sqrt(sqrD)
    local cos = x / d
    local sin = y / d
    local selectRange = math.min(d, SelectRangeMax)
    self.select_go.transform:Set_localPosition(selectRange * cos, selectRange * sin, 0)
    return Sensitivity * cos, Sensitivity * sin
end

-- 更新手指数据
function ParkourJoystick:UpdateFingers()
    local usingFingers = {} -- Dict<fingerId, bool>

    if Touch.TouchCount > 0 then
        for i = 0, Touch.TouchCount - 1 do
            local touch = Touch.Touches[i]
            local id = touch.FingerId
            usingFingers[id] = true
            if self.fingers[id] == nil then
                -- 添加新手指
                self.fingers[id] =
                {
                    startPos = touch.Position,
                    position = touch.Position,
                    isDrag = false,
                    valid = true,
                    fingerId = id,
                }
                if self.curFinger == nil then
                    self.curFinger = self.fingers[id]
                    self.curFinger.isDrag = true
                end
            else
                -- 位置变化的手指
                local finger = self.fingers[id]
                finger.position = touch.Position
                if not finger.isDrag and finger.valid then
                    if Vector3.Distance(finger.position, finger.startPos) > 15 then
                        if self.curFinger ~= nil then
                            self.curFinger.valid = false
                        end
                        finger.isDrag = true
                        self.curFinger = finger
                    end
                end
            end
        end
    end

    -- 删除不用的手指
    for id, _ in pairs(self.fingers) do
        if usingFingers[id] == nil then
            self.fingers[id] = nil
            if self.curFinger ~= nil and self.curFinger.fingerId == id then
                self.curFinger = nil
            end
        end
    end
    
end

-- 每帧刷新
-- 摇杆背景的显示/隐藏和设置位置
-- 返回 Vx 和 Vz
function ParkourJoystick:OnUpdate()
    if not self.enabled then
        return 0, 0
    end
    local oldFingerId = self.curFinger ~= nil and self.curFinger.fingerId or nil
    self:UpdateFingers()
    if self.curFinger ~= nil and oldFingerId ~= self.curFinger.fingerId then
        self.originX = self.curFinger.startPos.x
        self.originY = self.curFinger.startPos.y
        self.touch_go:SetActive(true)
        self.touch_go.transform:Set_position(self.originX, self.originY, 0)
        self.select_go.transform:Set_localPosition(0, 0, 0)
    end
    if self.curFinger ~= nil then
        local vx, vz = self:TouchPos(self.curFinger.position)
        return vx, vz
    else
        --self.touch_go:SetActive(false)
        return 0, 0
    end
end

-- 手指按下
function ParkourJoystick:OnFingerDown()
    if not self.enabled then
        return
    end
    self:UpdateFingers()
    if self.curFinger ~= nil then
        self.originX = self.curFinger.startPos.x
        self.originY = self.curFinger.startPos.y
        self.touch_go:SetActive(true)
        local worldPos = UIManager:GetInstance():GetUICamera():ScreenToWorldPoint(self.curFinger.startPos)
        self.touch_go.transform:Set_position(worldPos.x, worldPos.y, 0)
        self.select_go.transform:Set_localPosition(0, 0, 0)
        self:TouchPos(self.curFinger.position)
    end
end

-- 手指抬起
function ParkourJoystick:OnFingerUp()
    if not self.enabled then
        return
    end
    self:Reset()
end



return ParkourJoystick