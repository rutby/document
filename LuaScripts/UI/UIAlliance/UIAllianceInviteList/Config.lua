---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/6/10 17:40
---
local UIAllianceInviteList = {
    Name = UIWindowNames.UIAllianceInviteList,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIAlliance.UIAllianceInviteList.Controller.UIAllianceInviteListCtrl",
    View = require "UI.UIAlliance.UIAllianceInviteList.View.UIAllianceInviteListView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/Alliance/UIAllianceInviteList.prefab",
}

return {
    -- 配置
    UIAllianceInviteList = UIAllianceInviteList
}