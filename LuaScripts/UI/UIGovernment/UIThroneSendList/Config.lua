--- Created by shimin
--- DateTime: 2023/3/21 12:07
--- 王座嘉奖记录界面

local UIThroneSendList = {
    Name = UIWindowNames.UIThroneSendList,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIGovernment.UIThroneSendList.Controller.UIThroneSendListCtrl",
    View = require "UI.UIGovernment.UIThroneSendList.View.UIThroneSendListView",
    PrefabPath = "Assets/Main/Prefabs/UI/UIThrone/UIThroneSendList.prefab",
}

return {
    -- 配置
    UIThroneSendList = UIThroneSendList,
}