---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/15 16:38
---UICollectRewardCtrl.lua
---
local UICollectRewardCtrl = BaseClass("UICollectRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager.Instance:DestroyWindow(UIWindowNames.UICollectReward)
end

local function Close(self)
    UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

UICollectRewardCtrl.CloseSelf = CloseSelf
UICollectRewardCtrl.Close = Close

return UICollectRewardCtrl