---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 16/1/2024 下午9:27
---
local UIQueueList =
{
    Name = UIWindowNames.UIQueueList,
    Layer = UILayer.Normal,
    Ctrl = require "UI.UIQueueList.Controller.UIQueueListCtrl",
    View = require "UI.UIQueueList.View.UIQueueListView",
    PrefabPath = "Assets/Main/Prefab_Dir/UI/UIQueueList/UIQueueList.prefab",
}

return
{
    UIQueueList = UIQueueList,
}