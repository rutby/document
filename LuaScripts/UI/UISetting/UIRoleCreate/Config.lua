---
--- Created by zzl
--- DateTime: 
--- 角色创建
-- 窗口配置
local UIRoleCreate = {
    Name = UIWindowNames.UIRoleCreate,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UISetting.UIRoleCreate.Controller.UIRoleCreateCtrl",
    View = require "UI.UISetting.UIRoleCreate.View.UIRoleCreateView",
    PrefabPath = "Assets/Main/Prefabs/UI/UISetting/UIRoleCreate.prefab",
}

return {
    -- 配置
    UIRoleCreate = UIRoleCreate,
}