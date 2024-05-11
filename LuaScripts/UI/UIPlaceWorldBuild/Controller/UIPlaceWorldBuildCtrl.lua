---
--- Created by shimin.
--- DateTime: 2021/10/19 18:24
---UIPlaceWorldBuildCtrl.lua

local UIPlaceWorldBuildCtrl = BaseClass("UIPlaceWorldBuildCtrl", UIBaseCtrl)

local function CloseSelf(self)
    --DataCenter.GuideManager:SetNoShowUIMain(false)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlaceWorldBuild,{anim = true,UIMainAnim = UIMainAnimType.ChangeAllShow})
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIWorldPointJump)
    if CS.SceneManager.World then
        CS.SceneManager.World:QuitFocus(LookAtFocusTime)
    end
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIPlaceWorldBuildCtrl.CloseSelf = CloseSelf
UIPlaceWorldBuildCtrl.Close = Close

return UIPlaceWorldBuildCtrl