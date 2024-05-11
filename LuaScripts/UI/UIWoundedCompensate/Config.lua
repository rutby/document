---
--- 任务页面
--- Created by zzl.
--- DateTime: 
---
-- 窗口配置
local UIMainTask = {
    Name = UIWindowNames.UIMainTask,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIWoundedCompensate.Controller.UIWoundedCompensateCtrl",
    View = require "UI.UIWoundedCompensate.View.UIWoundedCompensateView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIWoundedCompensate/UIWoundedCompensate.prefab",
}

return {
    -- 配置
    UIMainTask = UIMainTask,
}