---
--- 邮件屏蔽页面
--- Created by shimin.
--- DateTime: 2020/9/27 17:55
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
local UISettingBlock = {
    Name = UIWindowNames.UISettingBlock,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetting.UISettingBlock.Controller.UISettingBlockCtrl",
    View = require "UI.UISetting.UISettingBlock.View.UISettingBlockView",
    PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UISettingBlock.prefab",
}

return {
    -- 配置
    UISettingBlock = UISettingBlock,
}