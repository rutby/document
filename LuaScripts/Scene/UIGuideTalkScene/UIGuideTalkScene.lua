--- Created by shimin.
--- DateTime: 2021/9/14 18:20
--- 引导对话MPC场景模型

local UIGuideTalkScene = BaseClass("UIGuideTalkScene")
local UIGuideTalkSceneModel = require "Scene.UIGuideTalkScene.UIGuideTalkSceneModel"
local model_go_path = "Npc_scene/ModelGo"
local camera_path = "Npc_scene/Camera"
local ResourceManager = CS.GameEntry.Resource

--创建
function UIGuideTalkScene:OnCreate(go)
    if go ~= nil then
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIGuideTalkScene:OnDestroy()
    self:DestroyModel()
    self:ComponentDestroy()
    self:DataDestroy()
end

function UIGuideTalkScene:ComponentDefine()
    self.model_go = self.transform:Find(model_go_path)
    self.camera = self.transform:Find(camera_path):GetComponent(typeof(CS.UnityEngine.Camera))
end

function UIGuideTalkScene:ComponentDestroy()
    self.model_go = nil
    self.camera = nil
    self.gameObject = nil
    self.transform = nil
end


function UIGuideTalkScene:DataDefine()
    self.param = nil
    self.model = nil
    self.modelRequest = nil
    self.modelName = nil
end

function UIGuideTalkScene:DataDestroy()
    self.param = nil
    self.model = nil
    self.modelRequest = nil
    self.modelName = nil
end

function UIGuideTalkScene:ReInit(param)
    self.param = param
    self:ShowPanel()
end

function UIGuideTalkScene:ShowPanel()
    if self.modelName == self.param.modelName then
        if self.model ~= nil then
            self.model:ReInit(self.param)
            if self.param.callBack ~= nil then
                self.param.callBack()
            end
        end
    else
        self.modelName = self.param.modelName
        self:DestroyModel()
        if self.modelName ~= nil and self.modelName ~= "" then
            self.modelRequest = ResourceManager:InstantiateAsync(string.format(LoadPath.NPCModel,self.param.modelName))
            self.modelRequest:completed('+', function()
                if self.modelRequest.isError or self.modelRequest.gameObject == nil then
                    return
                end
                self.modelRequest.gameObject:SetLayerRecursively(CS.UnityEngine.LayerMask.NameToLayer("GuideScene"))
                self.modelRequest.gameObject:SetActive(true)
                self.modelRequest.gameObject.transform:SetParent(self.model_go.transform)
                self.modelRequest.gameObject.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                self.modelRequest.gameObject.transform:Set_localPosition(0, 0, 0)
                local effect = UIGuideTalkSceneModel.New()
                effect:OnCreate(self.modelRequest)
                self.model = effect
                self.model:ReInit(self.param)
                if self.param.callBack ~= nil then
                    self.param.callBack()
                end
            end)
        end
    end
end

function UIGuideTalkScene:DestroyModel()
    if self.model ~= nil then
        self.model:OnDestroy()
        self.model = nil
    end
    if self.modelRequest ~= nil then
        self.modelRequest:Destroy()
        self.modelRequest = nil
    end
end

---设置renderTexture
function UIGuideTalkScene:OnRenderTexture(renderTexture)
    self.camera.targetTexture = renderTexture
end

---释放renderTexture
function UIGuideTalkScene:ReleaseTexture()
    self.camera.targetTexture = nil
end

return UIGuideTalkScene