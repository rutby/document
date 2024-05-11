---
--- Created by Beef.
--- DateTime: 2024/4/2 19:07
---

local UICitySiegeStart = {
    Name = UIWindowNames.UICitySiegeStart,
    Layer = UILayer.Guide,
    Ctrl = require "UI.UICitySiege.UICitySiegeStart.Controller.UICitySiegeStartCtrl",
    View = require "UI.UICitySiege.UICitySiegeStart.View.UICitySiegeStartView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UICitySiege/UICitySiegeStart.prefab",
}

return {
    -- 配置
    UICitySiegeStart = UICitySiegeStart,
}
