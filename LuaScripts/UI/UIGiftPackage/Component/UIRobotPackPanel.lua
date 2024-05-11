--[[
    Robot Pack Panel
--]]

local UIRobotPackPanel = BaseClass("UIRobotPackPanel", UIBaseView)
local base = UIBaseView
local UIRobotPackContent = require "UI.UIRobotPack.Component.UIRobotPackContent"

local content_path = "UIRobotPackContent"

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

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.content = self:AddComponent(UIRobotPackContent, content_path)
end

local function ComponentDestroy(self)
    self.content = nil
end

local function DataDefine(self)

end

local function DataDestroy(self)

end

local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self, pack, view)
    self.content:SetData(pack, view)
end

UIRobotPackPanel.OnCreate = OnCreate
UIRobotPackPanel.OnDestroy = OnDestroy
UIRobotPackPanel.OnEnable = OnEnable
UIRobotPackPanel.OnDisable = OnDisable
UIRobotPackPanel.ComponentDefine = ComponentDefine
UIRobotPackPanel.ComponentDestroy = ComponentDestroy
UIRobotPackPanel.DataDefine = DataDefine
UIRobotPackPanel.DataDestroy = DataDestroy
UIRobotPackPanel.OnAddListener = OnAddListener
UIRobotPackPanel.OnRemoveListener = OnRemoveListener

UIRobotPackPanel.ReInit = ReInit

return UIRobotPackPanel