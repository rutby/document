--- Created by shimin.
--- DateTime: 2023/12/14 00:17
--- 点击训练士兵属性页签弹窗
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
local UITrainDetailTip = {
    Name = UIWindowNames.UITrainDetailTip,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UITrainDetailTip.Controller.UITrainDetailTipCtrl",
    View = require "UI.UITrainDetailTip.View.UITrainDetailTipView",
    PrefabPath = "Assets/Main/Prefabs/UI/UITrain/UITrainDetailTip.prefab",
}

return {
    -- 配置
    UITrainDetailTip = UITrainDetailTip,
}