---
--- 引导 佩戴耳机提醒
--- Created by GaoFei.
--- DateTime: 2024/04/24 10:44
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
local UIGuideWearHeadphones = {
    Name = UIWindowNames.UIGuideWearHeadphones,
    Layer = UILayer.Guide,
    Ctrl = require "UI.UIGuideWearHeadphones.Controller.UIGuideWearHeadphonesCtrl",
    View = require "UI.UIGuideWearHeadphones.View.UIGuideWearHeadphonesView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuideWearHeadphones.prefab",
}

return {
    -- 配置
    UIGuideWearHeadphones = UIGuideWearHeadphones,
}