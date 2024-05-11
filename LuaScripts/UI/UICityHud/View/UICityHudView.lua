---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Beef.
--- DateTime: 2023/11/29 14:22
---

local UICityHud = BaseClass("UICityHud", UIBaseView)
local base = UIBaseView

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.layer_goes = {}
    for _, layer in pairs(CityHudLayer) do
        self.layer_goes[layer] = self:AddComponent(UIBaseContainer, layer)
    end
end

local function ComponentDestroy(self)
    
end

local function DataDefine(self)
    self.active = true
    self.screenX = CS.UnityEngine.Screen.width
    self.screenY = CS.UnityEngine.Screen.height
    self.itemDict = {} -- Dict<uuid, Dict<type, item>>
    self.reqDict = {} -- Dict<uuid, Dict<type, req>>
    self.camera = nil
    
    if self.update == nil then
        self.update = function() self:OnUpdate() end
        UpdateManager:GetInstance():AddUpdate(self.update)
    end
end

local function DataDestroy(self)
    self.active = false
    
    if self.update then
        UpdateManager:GetInstance():RemoveUpdate(self.update)
        self.update = nil
    end
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.SetBuildCanShowLevel, self.SetBuildCanShowLevelSignal)
    self:AddUIListener(EventId.SetBuildNoShowLevel, self.SetBuildNoShowLevelSignal)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.SetBuildCanShowLevel, self.SetBuildCanShowLevelSignal)
    self:RemoveUIListener(EventId.SetBuildNoShowLevel, self.SetBuildNoShowLevelSignal)
    base.OnRemoveListener(self)
end

local function TimerAction(self)
    if not self.active then
        return
    end
    for _, v in pairs(self.itemDict) do
        for _, item in pairs(v) do
            item:TimerAction()
        end
    end
end

local function GetHudItem(self, uuid, type)
    return self.itemDict[uuid] and self.itemDict[uuid][type]
end

local function GetHudItemByType(self, type)
    for _, v in pairs(self.itemDict) do
        for k, item in pairs(v) do
            if k == type then
                return item
            end
        end
    end
    return nil
end

local function GetCamera(self)
    if self.camera == nil then
        self.camera = CS.UnityEngine.Camera.main
    end
    return self.camera
end
--引导timeline特殊相机
function UICityHud:SetCamera(camera)
    self.camera = camera
end

local function SetLod(self, lod)
    if not self.active then
        return
    end
    for _, v in pairs(self.itemDict) do
        for _, item in pairs(v) do
            item:SetLod(lod)
        end
    end
end

local function SetVisible(self, visible)
    if self.visible == visible then
        return
    end
    for _, layer_go in pairs(self.layer_goes) do
        layer_go:SetActive(visible)
    end
end

local function Create(self, param)
    if not self.active then
        return
    end
    if param.layer == nil then
        param.layer = CityHudLayer.Root
    end
    local uuid = param.uuid
    local type = param.type
    if self.itemDict[uuid] and self.itemDict[uuid][type] then
        self.itemDict[uuid][type]:SetParam(param)
    else
        if self.reqDict[uuid] == nil then
            self.reqDict[uuid] = {}
        elseif self.reqDict[uuid][type] then
            self.reqDict[uuid][type]:Destroy()
        end
        param.prefab = string.format("Assets/Main/Prefab_Dir/UI/UICityHud/UICityHud%s.prefab", param.type)
        param.script = require(string.format("UI.UICityHud.Component.UICityHud%s", param.type))
        self.reqDict[uuid][type] = self:GameObjectInstantiateAsync(param.prefab, function(req)
            if self.itemDict[uuid] == nil then
                self.itemDict[uuid] = {}
            end
            
            local go = req.gameObject
            if param.unique then
                go.name = "UICityHud" .. param.type
            else
                go.name = "UICityHud" .. param.type .. "_" .. param.uuid
            end
            local tf = go.transform
            tf:SetParent(self.layer_goes[param.layer].transform)
            tf:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local item = self:AddComponent(param.script, param.layer .. "/" .. go.name)
            item:SetLod(DataCenter.CityHudManager.lod)
            item:SetParam(param)
            self.itemDict[uuid][type] = item
            self:UpdateItemPos(uuid, type)
        end)
    end
    return uuid
end

-- type = nil 时删除该 uuid 的所有 hud
local function Destroy(self, uuid, type)
    if not self.active then
        return
    end
    if type then
        if self.itemDict[uuid] then
            local item = self.itemDict[uuid][type]
            if item then
                self:RemoveComponent(item.gameObject.name, item.param.script)
                self.itemDict[uuid][type] = nil
            end
            if next(self.itemDict[uuid]) == nil then
                self.itemDict[uuid] = nil
            end
        end
        if self.reqDict[uuid] then
            local req = self.reqDict[uuid][type]
            if req then
                req:Destroy()
                self.reqDict[uuid][type] = nil
            end
            if next(self.reqDict[uuid]) == nil then
                self.reqDict[uuid] = nil
            end
        end
    else
        if self.itemDict[uuid] then
            for _, item in pairs(self.itemDict[uuid]) do
                self:RemoveComponent(item.gameObject.name, item.param.script)
            end
            self.itemDict[uuid] = nil
        end
        if self.reqDict[uuid] then
            for _, req in pairs(self.reqDict[uuid]) do
                req:Destroy()
            end
            self.reqDict[uuid] = nil
        end
    end
end

local function DestroyAll(self, excludeList)
    if not self.active then
        return
    end
    for uuid, _ in pairs(self.reqDict) do
        if excludeList == nil or (not excludeList[uuid]) then
            self:Destroy(uuid)
        end
    end
end

local function OnUpdate(self)
    -- 每帧
    if not self.active then
        return
    end
    for uuid, v in pairs(self.itemDict) do
        for type, item in pairs(v) do
            if item.param.updateEveryFrame then
                self:UpdateItemPos(uuid, type)
            end
        end
    end
end

local function UpdateItemPos(self, uuid, type)
    if self.itemDict[uuid] == nil then
        self.itemDict[uuid] = {}
    end
    local item = self.itemDict[uuid][type]
    if item then
        local worldPos = VecZero
        if item.param.pos then
            worldPos = item.param.pos
        elseif item.param.GetPos then
            worldPos = item.param.GetPos()
        end
        if item.param.worldOffset then
            worldPos = worldPos + item.param.worldOffset
        end
        local screenPos = self:GetCamera():WorldToScreenPoint(worldPos)
        screenPos.z = 0
        if item.posCache ~= screenPos then
            if screenPos.x > -CityResidentDefines.HudPadding and
               screenPos.x < self.screenX + CityResidentDefines.HudPadding and
               screenPos.y > -CityResidentDefines.HudPadding and
               screenPos.y < self.screenY + CityResidentDefines.HudPadding
            then
                item:SetInView(true)
                item:SetPos(screenPos)
            else
                item:SetInView(false)
            end
        end
    end
end

local function OnCameraChange(self)
    if not self.active then
        return
    end
    for uuid, v in pairs(self.itemDict) do
        for type, _ in pairs(v) do
            self:UpdateItemPos(uuid, type)
        end
    end
end

local function OnWorldInputDragBegin(self)
    if not self.active then
        return
    end
    for _, v in pairs(self.itemDict) do
        for _, item in pairs(v) do
            item:OnWorldInputDragBegin()
        end
    end
end

local function OnWorldInputDragEnd(self)
    if not self.active then
        return
    end
    for _, v in pairs(self.itemDict) do
        for _, item in pairs(v) do
            item:OnWorldInputDragEnd()
        end
    end
end

function UICityHud:SetBuildCanShowLevelSignal()
    self:SetBuildLevelActive(true)
end

function UICityHud:SetBuildNoShowLevelSignal()
    self:SetBuildLevelActive(false)
end

function UICityHud:SetBuildLevelActive(isActive)
    if not self.active then
        return
    end
    for uuid, v in pairs(self.itemDict) do
        local go = v[CityHudType.BuildLevel]
        if go ~= nil then
            go:SetRootActive(isActive)
        end
    end
end

function UICityHud:SetLayerVisible(layerName, visible)
    if self.layer_goes[layerName] ~= nil then
        self.layer_goes[layerName]:SetActive(visible)
    end
end

UICityHud.OnCreate = OnCreate
UICityHud.OnDestroy = OnDestroy
UICityHud.ComponentDefine = ComponentDefine
UICityHud.ComponentDestroy = ComponentDestroy
UICityHud.DataDefine = DataDefine
UICityHud.DataDestroy = DataDestroy
UICityHud.OnEnable = OnEnable
UICityHud.OnDisable = OnDisable
UICityHud.OnAddListener = OnAddListener
UICityHud.OnRemoveListener = OnRemoveListener

UICityHud.TimerAction = TimerAction
UICityHud.GetHudItem = GetHudItem
UICityHud.GetHudItemByType = GetHudItemByType
UICityHud.GetCamera = GetCamera
UICityHud.SetLod = SetLod
UICityHud.SetVisible = SetVisible
UICityHud.Create = Create
UICityHud.Destroy = Destroy
UICityHud.DestroyAll = DestroyAll
UICityHud.OnUpdate = OnUpdate
UICityHud.UpdateItemPos = UpdateItemPos
UICityHud.OnCameraChange = OnCameraChange
UICityHud.OnWorldInputDragBegin = OnWorldInputDragBegin
UICityHud.OnWorldInputDragEnd = OnWorldInputDragEnd

return UICityHud