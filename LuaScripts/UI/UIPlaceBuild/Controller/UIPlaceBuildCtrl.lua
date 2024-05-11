---
--- Created by shimin.
--- DateTime: 2021/10/19 18:24
---

local UIPlaceBuildCtrl = BaseClass("UIPlaceBuildCtrl", UIBaseCtrl)

local function CloseSelf(self)
    DataCenter.GuideManager:SetNoShowUIMain(GuideSetUIMainAnim.Show)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIPlaceBuild,{anim = true,UIMainAnim = UIMainAnimType.ChangeAllShow})
    if CS.SceneManager.World then
        CS.SceneManager.World:QuitFocus(LookAtFocusTime)
    end
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end


UIPlaceBuildCtrl.CloseSelf = CloseSelf
UIPlaceBuildCtrl.Close = Close

return UIPlaceBuildCtrl