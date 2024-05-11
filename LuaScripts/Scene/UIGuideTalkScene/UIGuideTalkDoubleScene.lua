--- Created by shimin.
--- DateTime: 2021/9/14 18:20
--- 引导对话MPC场景模型

local UIGuideTalkDoubleScene = BaseClass("UIGuideTalkDoubleScene")
local UIGuideTalkSceneModel = require "Scene.UIGuideTalkScene.UIGuideTalkSceneModel"
local left_model_go_path = "Npc_scene/LeftModelGo"
local right_model_go_path = "Npc_scene/RightModelGo"
local ResourceManager = CS.GameEntry.Resource

--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
    --CS.SceneManager.World:DisablePostProcess()
end

-- 销毁
local function OnDestroy(self)
    --CS.SceneManager.World:EnablePostProcess()
    self:DestroyModel()
    self:ComponentDestroy()
    self:DataDestroy()
end

local function ComponentDefine(self)
    self.left_model_go = self.transform:Find(left_model_go_path)
    self.right_model_go = self.transform:Find(right_model_go_path)
    --self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
    --local mainCam = CS.UnityEngine.Camera.main
    --if mainCam ~= nil then
    --    local cameraStack = mainCam:GetComponent(typeof(CS.UnityEngine.Rendering.Universal.UniversalAdditionalCameraData)).cameraStack
    --    if not cameraStack:Contains(self.camera) then
    --        cameraStack:Add(self.camera)
    --    end
    --end
end

local function ComponentDestroy(self)
    self.left_model_go = nil
    self.right_model_go = nil
    --self.camera = nil
    self.gameObject = nil
    self.transform = nil
end


local function DataDefine(self)
    self.param = {}
    self.usePosition = nil
end

local function DataDestroy(self)
    self.param = nil
    self.usePosition = nil
end

local function ReInit(self,param)
    if param.modelPosition ~= nil then
        self.usePosition = param.modelPosition
        if self.param[self.usePosition] == nil then
            self.param[self.usePosition] = {}
        end
        self.param[self.usePosition].para = param
        self:ShowPanel()
    end
end

local function ShowPanel(self)
    local param = self.param[self.usePosition]
    if param.modelName == param.para.modelName then
        if param.model ~= nil then
            param.model:ReInit(param.para)
            if param.para.completed ~= nil then
                param.para.completed()
                self:StopOtherAnim()
            end
        end
    else
        param.modelName = param.para.modelName
        self:DestroyParamModel(param)
        if param.modelName ~= nil and param.modelName ~= "" then
            param.modelRequest = ResourceManager:InstantiateAsync(string.format(LoadPath.NPCModel,param.modelName))
            param.modelRequest:completed('+', function()
                if param.modelRequest.isError or param.modelRequest.gameObject == nil then
                    return
                end
                local go = param.modelRequest.gameObject
                go:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("GuideScene"))
                go:SetActive(true)
                if param.para.modelPosition == GuideNpcPosition.Left then
                    go.transform:SetParent(self.left_model_go.transform)
                elseif param.para.modelPosition == GuideNpcPosition.Right then
                    go.transform:SetParent(self.right_model_go.transform)
                end
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:Set_localPosition(0, 0, 0)
                local effect = UIGuideTalkSceneModel.New()
                effect:OnCreate(param.modelRequest)
                param.model = effect
                param.model:ReInit(param.para)
                if param.para.completed ~= nil then
                    param.para.completed()
                    self:StopOtherAnim()
                end
            end)
        end
    end
end

local function DestroyModel(self)
    if self.param ~= nil then
        for k,v in pairs(self.param) do
            if v.model ~= nil then
                v.model:OnDestroy()
                v.model = nil
            end
            if v.modelRequest ~= nil then
                v.modelRequest:Destroy()
                v.modelRequest = nil
            end
        end
    end
end

local function DestroyParamModel(self,param)
    if param.model ~= nil then
        param.model:OnDestroy()
        param.model = nil
    end
    if param.modelRequest ~= nil then
        param.modelRequest:Destroy()
        param.modelRequest = nil
    end
end

local function StopOtherAnim(self)
    for k,v in pairs(self.param) do
        if k ~= self.usePosition then
            if v.model ~= nil then
                v.model:Stop()
            end
        end
    end
end

UIGuideTalkDoubleScene.OnCreate = OnCreate
UIGuideTalkDoubleScene.OnDestroy = OnDestroy
UIGuideTalkDoubleScene.ComponentDefine = ComponentDefine
UIGuideTalkDoubleScene.ComponentDestroy = ComponentDestroy
UIGuideTalkDoubleScene.DataDefine = DataDefine
UIGuideTalkDoubleScene.DataDestroy = DataDestroy
UIGuideTalkDoubleScene.ReInit = ReInit
UIGuideTalkDoubleScene.ShowPanel = ShowPanel
UIGuideTalkDoubleScene.DestroyModel = DestroyModel
UIGuideTalkDoubleScene.DestroyParamModel = DestroyParamModel
UIGuideTalkDoubleScene.StopOtherAnim = StopOtherAnim

return UIGuideTalkDoubleScene