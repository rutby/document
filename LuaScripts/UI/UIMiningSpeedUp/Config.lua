---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1020.
--- DateTime: 2023/5/23 15:22
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
local UIMiningSpeedUp = {
    Name = UIWindowNames.UIMiningSpeedUp,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIMiningSpeedUp.Ctrl.UIMiningSpeedUpCtrl",
    View = require "UI.UIMiningSpeedUp.View.UIMiningSpeedUpView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIMiningSpeedUp/UIMiningSpeedUp.prefab",
}

return {
    -- 配置
    UIMiningSpeedUp = UIMiningSpeedUp,
}