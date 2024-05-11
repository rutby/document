--- 出世界/联盟迁城遮罩
--- Created by shimin.
--- DateTime: 2022/7/18 16:12
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
local UIGuideLoadMask = {
    Name = UIWindowNames.UIGuideLoadMask,
    Layer = UILayer.Guide,
    Ctrl = require "UI.UIGuideLoadMask.Controller.UIGuideLoadMaskCtrl",
    View = require "UI.UIGuideLoadMask.View.UIGuideLoadMaskView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuideLoadMask.prefab",
}

return {
    -- 配置
    UIGuideLoadMask = UIGuideLoadMask,
}