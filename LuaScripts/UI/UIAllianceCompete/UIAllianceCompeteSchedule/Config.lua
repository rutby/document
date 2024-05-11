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
local UIAllianceCompeteSchedule = {
    Name = UIWindowNames.UIAllianceCompeteSchedule,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIAllianceCompete.UIAllianceCompeteSchedule.Controller.UIAllianceCompeteScheduleCtrl",
    View = require "UI.UIAllianceCompete.UIAllianceCompeteSchedule.View.UIAllianceCompeteScheduleView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIAllianceCompete/UIAllianceCompeteSchedule.prefab",
}

return {
    -- 配置
    UIAllianceCompeteSchedule = UIAllianceCompeteSchedule,
}
