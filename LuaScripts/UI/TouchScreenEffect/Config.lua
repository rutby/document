
local TouchScreenEffect = {
    Name = UIWindowNames.TouchScreenEffect,
    Layer = UILayer.TopMost,
    Ctrl = require "UI.TouchScreenEffect.Controller.TouchScreenEffectCtrl",
    View = require "UI.TouchScreenEffect.View.TouchScreenEffectView",
    PrefabPath = "Assets/Main/Prefabs/UI/TouchScreenEffect.prefab",
}

return {
    TouchScreenEffect = TouchScreenEffect,
}