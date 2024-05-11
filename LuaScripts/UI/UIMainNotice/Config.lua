---
--- 
--- Created by zzl.
--- DateTime: 
---
-- 窗口配置
local UIMainNotice = {
    Name = UIWindowNames.UIMainNotice,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIMainNotice.Controller.UIMainNoticeCtrl",
    View = require "UI.UIMainNotice.View.UIMainNoticeView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIMainNotice/UIMainNotice.prefab",
}

return {
    -- 配置
    UIMainNotice = UIMainNotice,
}