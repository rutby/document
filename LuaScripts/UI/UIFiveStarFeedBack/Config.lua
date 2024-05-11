

local UIFiveStarFeedBack = {
    Name = UIWindowNames.UIFiveStarFeedBack,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIFiveStarFeedBack.Controller.UIFiveStarFeedBackCtrl",
    View = require "UI.UIFiveStarFeedBack.View.UIFiveStarFeedBackView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIFiveStar/UIFiveStarFeedBack.prefab",
}

return {
    -- 配置
    UIFiveStarFeedBack = UIFiveStarFeedBack
}