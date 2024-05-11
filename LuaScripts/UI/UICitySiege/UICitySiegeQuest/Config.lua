--- Created by shimin
--- DateTime: 2023/11/10 14:39
--- 暴风雪预览界面

local UICitySiegeQuest = {
    Name = UIWindowNames.UICitySiegeQuest,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UICitySiege.UICitySiegeQuest.Controller.UICitySiegeQuestCtrl",
    View = require "UI.UICitySiege.UICitySiegeQuest.View.UICitySiegeQuestView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UICitySiege/UICitySiegeQuest.prefab",
}

return {
    -- 配置
    UICitySiegeQuest = UICitySiegeQuest,
}