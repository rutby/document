---
--- 引导箭头移动指示界面
--- Created by shimin.
--- DateTime: 2021/8/25 21:22
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
local UIGuideMoveArrow = {
    Name = UIWindowNames.UIGuideMoveArrow,
    Layer = UILayer.Guide,
    Ctrl = require "UI.UIGuideMoveArrow.Controller.UIGuideMoveArrowCtrl",
    View = require "UI.UIGuideMoveArrow.View.UIGuideMoveArrowView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuideMoveArrow.prefab",
}

return {
    -- 配置
    UIGuideMoveArrow = UIGuideMoveArrow,
}