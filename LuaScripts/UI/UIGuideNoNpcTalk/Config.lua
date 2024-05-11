---
--- Created by shimin.
--- DateTime: 2022/6/20 21:54
--  引导旁白对话
---



local UIGuideNoNpcTalk = {
    Name = UIWindowNames.UIHeroEntrust,
    Layer = UILayer.Guide,
    Ctrl = require "UI.UIGuideNoNpcTalk.Controller.UIGuideNoNpcTalkCtrl",
    View = require "UI.UIGuideNoNpcTalk.View.UIGuideNoNpcTalkView",
    PrefabPath = "Assets/Main/Prefab_Dir/Guide/UIGuideNoNpcTalk.prefab",
}

return {
    -- 配置
    UIGuideNoNpcTalk = UIGuideNoNpcTalk,
}
