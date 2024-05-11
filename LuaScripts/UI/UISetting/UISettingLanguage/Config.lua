---
--- 设置语言页面
--- Created by shimin.
--- DateTime: 2020/9/22 21:52
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
local UISettingLanguage = {
    Name = UIWindowNames.UISettingLanguage,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetting.UISettingLanguage.Controller.UISettingLanguageCtrl",
    View = require "UI.UISetting.UISettingLanguage.View.UISettingLanguageView",
    PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingLanguage.prefab",
}

return {
    -- 配置
    UISettingLanguage = UISettingLanguage,
}