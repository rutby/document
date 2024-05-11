--- Created by shimin.
--- DateTime: 2020/5/11 11:47
--- 建筑可升级绿色箭头

local BuildCanUpgradeEffect = BaseClass("BuildCanUpgradeEffect")


--创建
local function OnCreate(self,go)
    if go ~= nil then
        self.request = go
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

end

local function ComponentDestroy(self)
    self.transform = nil
    self.gameObject = nil
end


local function DataDefine(self)
    self.param = nil
    self.index = nil
end

local function DataDestroy(self)
    self.param = nil
    self.index = nil
end

local function ReInit(self,param)
    self.param = param
    if self.param.posIndex ~= nil then
        self:UpdatePosition(self.param.posIndex)
    end
end

--更新位置
local function UpdatePosition(self,index)
    if self.index ~= index then
        self.index = index
        self.transform.position = BuildingUtils.GetBuildModelDownVec(index, self.param.tiles)
    end
end


BuildCanUpgradeEffect.OnCreate = OnCreate
BuildCanUpgradeEffect.OnDestroy = OnDestroy
BuildCanUpgradeEffect.ComponentDefine = ComponentDefine
BuildCanUpgradeEffect.ComponentDestroy = ComponentDestroy
BuildCanUpgradeEffect.DataDefine = DataDefine
BuildCanUpgradeEffect.DataDestroy = DataDestroy
BuildCanUpgradeEffect.ReInit = ReInit
BuildCanUpgradeEffect.UpdatePosition = UpdatePosition

return BuildCanUpgradeEffect