---
--- Created by shimin.
--- DateTime: 2022/3/28 21:06
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
local UIItemPurchases = {
    Name = UIWindowNames.UIItemPurchases,
    Layer = UILayer.Background,
    Ctrl = require "UI.UIItemPurchases.Controller.UIItemPurchasesCtrl",
    View = require "UI.UIItemPurchases.View.UIItemPurchasesView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIItem/UIItemPurchases.prefab",
}

return {
    -- 配置
    UIItemPurchases = UIItemPurchases,
}