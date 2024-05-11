---
--- 兑换码页面
--- Created by shimin.
--- DateTime: 2020/9/25 19:00
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
local UISettingRedemptionCode = {
    Name = UIWindowNames.UISettingRedemptionCode,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetting.UISettingRedemptionCode.Controller.UISettingRedemptionCodeCtrl",
    View = require "UI.UISetting.UISettingRedemptionCode.View.UISettingRedemptionCodeView",
    PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingRedemptionCode.prefab",
}

return {
    -- 配置
    UISettingRedemptionCode = UISettingRedemptionCode,
}