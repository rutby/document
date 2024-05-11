---
--- Created by zzl
--- DateTime: 
--- 角色管理
-- 窗口配置
local UIRoles = {
    Name = UIWindowNames.UIRoles,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetting.UIRoles.Controller.UIRolesCtrl",
    View = require "UI.UISetting.UIRoles.View.UIRolesView",
    PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UIRoles.prefab",
}

return {
    -- 配置
    UIRoles = UIRoles,
}