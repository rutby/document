---
--- 居民订单页面
--- Created by shimin.
--- DateTime: 2021/3/10 17:14
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
local UIBuildUpgradeAddDes = {
    Name = UIWindowNames.UIBuildUpgradeAddDes,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIBuildUpgradeAddDes.Controller.UIBuildUpgradeAddDesCtrl",
    View = require "UI.UIBuildUpgradeAddDes.View.UIBuildUpgradeAddDesView",
    PrefabPath = "Assets/Main/Prefabs/UI/Build/UIBuildUpgradeAddDes.prefab",
}

return {
    -- 配置
    UIBuildUpgradeAddDes = UIBuildUpgradeAddDes,
}