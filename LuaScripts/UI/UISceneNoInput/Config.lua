---
--- 遮挡场景点击UI界面
--- Created by shimin.
--- DateTime: 2021/12/13 11:19
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
local UISceneNoInput = {
    Name = UIWindowNames.UINoInput,
    Layer = UILayer.Scene,
    Ctrl = require "UI.UISceneNoInput.Controller.UISceneNoInputCtrl",
    View = require "UI.UISceneNoInput.View.UISceneNoInputView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UINoInput.prefab",
}

return {
    -- 配置
    UISceneNoInput = UISceneNoInput,
}