--- Created by shimin.
--- DateTime: 2024/1/16 16:25
--- 气泡界面

local UIBubbleView = BaseClass("UIBubbleView", UIBaseView)
local base = UIBaseView
local UIBubbleBuildCell = require "UI.UIBubble.Component.UIBubbleBuildCell"

local root_path = "root"

local Padding = 40

--创建
function UIBubbleView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UIBubbleView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBubbleView:ComponentDefine()
    self.root = self:AddComponent(UIBaseContainer, root_path)
end

function UIBubbleView:ComponentDestroy()
end

function UIBubbleView:DataDefine()
    self.cells = {}
    self.screenX = CS.UnityEngine.Screen.width
    self.screenY = CS.UnityEngine.Screen.height
end

function UIBubbleView:DataDestroy()
    self.root:RemoveComponents(UIBubbleBuildCell)
end

function UIBubbleView:OnEnable()
    base.OnEnable(self)
end

function UIBubbleView:OnDisable()
    base.OnDisable(self)
end

function UIBubbleView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ShowOneBuildBubble, self.ShowOneBuildBubbleSignal)
    self:AddUIListener(EventId.RemoveOneBuildBubble, self.RemoveOneBuildBubbleSignal)
    self:AddUIListener(EventId.RefreshBubbleActive, self.RefreshBubbleActiveSignal)
end


function UIBubbleView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ShowOneBuildBubble, self.ShowOneBuildBubbleSignal)
    self:RemoveUIListener(EventId.RemoveOneBuildBubble, self.RemoveOneBuildBubbleSignal)
    self:RemoveUIListener(EventId.RefreshBubbleActive, self.RefreshBubbleActiveSignal)
end

function UIBubbleView:ReInit()
    self:RefreshBubbleActive()
end

function UIBubbleView:ShowOneBuildBubble(param)
    local key = param.bUuid
    if self.cells[key] == nil then
        self.cells[key] = param
        param.visible = true
        param.req = self:GameObjectInstantiateAsync(UIAssets.UIBubbleBuildCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.root.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            self.cells[key].nameStr = self.cells[key].buildId .. "_" .. self.cells[key].buildBubbleType
            go.name = self.cells[key].nameStr
            local model = self.root:AddComponent(UIBubbleBuildCell, self.cells[key].nameStr)
            model:ReInit(self.cells[key])
            self.cells[key].model = model
            self:CheckBubbleInView(key)
        end)
    else
        param.req = self.cells[key].req
        param.model = self.cells[key].model
        param.nameStr = self.cells[key].nameStr
        self.cells[key] = param
        param.visible = true
        if param.model ~= nil then
            param.model:ReInit(param)
            self:CheckBubbleInView(key)
        end
    end
end

function UIBubbleView:RemoveOneBuildBubble(key)
    if self.cells[key] ~= nil then
        if self.cells[key].model ~= nil then
            self.cells[key].model:OnDestroy()
        end
        self.root:RemoveComponent(self.cells[key].nameStr, UIBubbleBuildCell)
        self:GameObjectDestroy(self.cells[key].req)
        self.cells[key] = nil
    end
end

function UIBubbleView:ShowOneBuildBubbleSignal(param)
    self:ShowOneBuildBubble(param)
end

function UIBubbleView:RemoveOneBuildBubbleSignal(bUuid)
    self:RemoveOneBuildBubble(bUuid)
end

function UIBubbleView:RefreshBubbleActiveSignal()
    self:RefreshBubbleActive()
end

function UIBubbleView:RefreshBubbleActive()
    if DataCenter.BuildBubbleManager:CanShowBubble() then
        self.root:SetActive(true)
    else
        self.root:SetActive(false)
    end
end

function UIBubbleView:GetObjByBuildUuid(bUuid)
    if self.cells[bUuid] ~= nil then
        return self.cells[bUuid].model
    end
    return nil
end

function UIBubbleView:Update()
    if self.cells == nil then
        return
    end
    for bUuid, _ in pairs(self.cells) do
        self:CheckBubbleInView(bUuid)
    end
end

function UIBubbleView:CheckBubbleInView(bUuid)
    local cell = self.cells[bUuid]
    if cell == nil or IsNull(cell.model) then
        return
    end

    local screenPos = cell.model.transform.position
    if screenPos.x > -Padding and
       screenPos.x < self.screenX + Padding and
       screenPos.y > -Padding and
       screenPos.y < self.screenY + Padding
    then
        cell.model:SetInView(true)
    else
        cell.model:SetInView(false)
    end
end

return UIBubbleView