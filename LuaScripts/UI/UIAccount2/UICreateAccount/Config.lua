---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zhangliheng.
--- DateTime: 8/12/21 9:44 PM
---


local UICreateAccount = {
    Name = UIWindowNames.UICreateAccount,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIAccount2.UICreateAccount.Controller.UICreateAccountCtrl",
    View = require "UI.UIAccount2.UICreateAccount.View.UICreateAccount",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIAccount/UICreateAccount.prefab"
}

return {
    -- 配置
    UICreateAccount = UICreateAccount,
}