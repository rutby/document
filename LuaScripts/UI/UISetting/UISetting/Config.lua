---
--- 任务页面
--- Created by shimin.
--- DateTime: 2020/9/14 10:20
---
--[[
-- 模块窗口配置，要使用还需要导出到UI.Config.UIConfig.lua
-- 一个模块可以对应多个窗口，每个窗口对应一个配置项
-- 使用范例：
-- 窗口配置表 ={
--		名字Name
--		UI层级Layer
-- 		控制器类Controller
--		模型类Model
--		视图类View
--		资源加载路径PrefabPath
-- } 
--]]

-- 窗口配置
local UISetting = {
    Name = UIWindowNames.UISetting,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetting.UISetting.Controller.UISettingCtrl",
    View = require "UI.UISetting.UISetting.View.UISettingView",
    PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISetting.prefab",
}

return {
    -- 配置
    UISetting = UISetting,
}