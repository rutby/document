---
--- 联盟个人情报拆出来的单独界面
--- Created by shimin.
--- DateTime: 2023/3/3 17:14
---
local UIAllianceWarPersonalList = {
    Name = UIWindowNames.UIAllianceWarPersonalList,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIAlliance.UIAllianceWarPersonalList.Controller.UIAllianceWarPersonalListCtrl",
    View = require "UI.UIAlliance.UIAllianceWarPersonalList.View.UIAllianceWarPersonalListView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/Alliance/UIAllianceWarPersonalList.prefab",
}

return {
    -- 配置
    UIAllianceWarPersonalList = UIAllianceWarPersonalList
}