---
--- 通用设置页面
--- Created by shimin.
--- DateTime: 2020/9/25 14:50
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
local UISettingSet = {
    Name = UIWindowNames.UISettingSet,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetting.UISettingSet.Controller.UISettingSetCtrl",
    View = require "UI.UISetting.UISettingSet.View.UISettingSetView",
    PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingSet.prefab",
}

return {
    -- 配置
    UISettingSet = UISettingSet,
}