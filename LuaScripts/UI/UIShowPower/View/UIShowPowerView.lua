--- Created by shimin.
--- DateTime: 2023/12/20 19:08
--- 提升战力界面界面

local UIShowPowerView = BaseClass("UIShowPowerView", UIBaseView)
local base = UIBaseView
local UIShowPowerCell = require "UI.UIShowPower.Component.UIShowPowerCell"

--创建
function UIShowPowerView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UIShowPowerView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIShowPowerView:ComponentDefine()
end

function UIShowPowerView:ComponentDestroy()
end


function UIShowPowerView:DataDefine()
    self.param = {}
    self.reqList = {}
end

function UIShowPowerView:DataDestroy()
 
end

function UIShowPowerView:OnEnable()
    base.OnEnable(self)
end

function UIShowPowerView:OnDisable()
    base.OnDisable(self)
end

function UIShowPowerView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ShowPower, self.ShowPowerSignal)
end


function UIShowPowerView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ShowPower, self.ShowPowerSignal)
end

function UIShowPowerView:ReInit()
    local param = self:GetUserData()
    self:RefreshOne(param)
end

function UIShowPowerView:RefreshOne(param)
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Power_Up)
    local req = self:GameObjectInstantiateAsync(UIAssets.UIShowPowerCell, function(request)
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
        local model = self:AddComponent(UIShowPowerCell, nameStr)
        model:ReInit(param)
    end)
    self.reqList[param] = req
end

function UIShowPowerView:ShowPowerSignal(param)
    self:ClearAll()
    self:RefreshOne(param)
end

function UIShowPowerView:CloseOne()
    self.ctrl:CloseSelf()
end

function UIShowPowerView:ClearAll()
    for k,v in pairs(self.reqList) do
        self:GameObjectDestroy(v)
    end
    self.reqList = {}
end


return UIShowPowerView