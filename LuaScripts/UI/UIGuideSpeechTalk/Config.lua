--- Created by shimin.
--- DateTime: 2023/11/28 14:45
--- 引导多组对话界面
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
local UIGuideSpeechTalk = {
    Name = UIWindowNames.UIGuideSpeechTalk,
    Layer = UILayer.Guide,
    Ctrl = require "UI.UIGuideSpeechTalk.Controller.UIGuideSpeechTalkCtrl",
    View = require "UI.UIGuideSpeechTalk.View.UIGuideSpeechTalkView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuideSpeechTalk.prefab",
}

return {
    -- 配置
    UIGuideSpeechTalk = UIGuideSpeechTalk,
}