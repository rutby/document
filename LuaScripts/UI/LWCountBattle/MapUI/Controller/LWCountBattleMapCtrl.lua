
local LWCountBattleMapCtrl = BaseClass("LWCountBattleMapCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.LWCountBattleMap)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetCurrentStageId(self)
    return DataCenter.CountBattleManager.curStageId
end

LWCountBattleMapCtrl.CloseSelf = CloseSelf
LWCountBattleMapCtrl.Close = Close
LWCountBattleMapCtrl.GetCurrentStageId = GetCurrentStageId


return LWCountBattleMapCtrl