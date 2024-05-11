--- Created by shimin
--- DateTime: 2023/4/10 18:12
--- 专精技能使用后显示结果界面

local UIMasterySkillUseResultShow = {
    Name = UIWindowNames.UIMasterySkillUseResultShow,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIMasterySkillUseResultShow.Controller.UIMasterySkillUseResultShowCtrl",
    View = require "UI.UIMasterySkillUseResultShow.View.UIMasterySkillUseResultShowView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIMastery/UIMasterySkillUseResultShow.prefab",
}

return {
    -- 配置
    UIMasterySkillUseResultShow = UIMasterySkillUseResultShow,
}