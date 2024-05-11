--- Created by shimin
--- DateTime: 2023/9/11
--- 去关卡界面

local ResLackItemBase = require "DataCenter.ResLackTips.ResLackItemBase"
local ResLackItem_GoStoryMain = BaseClass("ResLackItem_GoStoryMain", ResLackItemBase)

function ResLackItem_GoStoryMain:CheckIsOk( _resType, _needCnt)
    return not SceneUtils.GetIsInPve()
end

function ResLackItem_GoStoryMain:TodoAction()
    GoToUtil:CloseAllWindows()
    if not DataCenter.LandManager:TryJumpToNextBlock() then
        GoToUtil.GotoOpenView(UIWindowNames.UIJeepAdventureMain, { anim = true })
    end
end

return ResLackItem_GoStoryMain