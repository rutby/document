

local UITaskLockItem = BaseClass("UITaskLockItem", UIBaseContainer)
local base = UIBaseContainer

local txt_path = "Lock/txt"

--创建
function UITaskLockItem : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function UITaskLockItem : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UITaskLockItem : ComponentDefine()
    self.txt = self:AddComponent(UITextMeshProUGUIEx, txt_path)
    self.txt:SetLocalText("240668")
end

function UITaskLockItem : ComponentDestroy()

end

function UITaskLockItem : DataDefine()
    self.isAnim = false
end

function UITaskLockItem : DataDestroy()
    self.isAnim = false
end

function UITaskLockItem : SetData(param)
    self.param = param
end

function UITaskLockItem : GetItemState()
    return self.param.state
end

function UITaskLockItem : SetIsAnim(value)
    self.isAnim = value
end

function UITaskLockItem : GetTaskId()
    return -1
end

function UITaskLockItem : GetBtnGo()
    return -1
end

function UITaskLockItem : PlayAnim(animName)
end





return UITaskLockItem