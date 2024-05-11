--- Created by shimin.
--- DateTime: 2021/10/12 18:23
--- 镜头风沙

local CameraSand = BaseClass("CameraSand")
local anim_path = "VFX_CameraSand"
local ShowAnimName = "show"

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
    self.anim = self.transform:Find(anim_path):GetComponent(typeof(CS.SimpleAnimation))
end

local function ComponentDestroy(self)
    self.anim = nil
    self.gameObject = nil
    self.transform = nil
end


local function DataDefine(self)
    self.param = nil
end

local function DataDestroy(self)
    self.param = nil
end

local function ReInit(self,param)
    self.param = param
end

local function PlayShowAnim(self)
    self.anim:Play(ShowAnimName)
end

local function GetAnimTime(self)
    return self.anim:GetClipLength(ShowAnimName)
end

CameraSand.OnCreate = OnCreate
CameraSand.OnDestroy = OnDestroy
CameraSand.ComponentDefine = ComponentDefine
CameraSand.ComponentDestroy = ComponentDestroy
CameraSand.DataDefine = DataDefine
CameraSand.DataDestroy = DataDestroy
CameraSand.ReInit = ReInit
CameraSand.PlayShowAnim = PlayShowAnim
CameraSand.GetAnimTime = GetAnimTime

return CameraSand