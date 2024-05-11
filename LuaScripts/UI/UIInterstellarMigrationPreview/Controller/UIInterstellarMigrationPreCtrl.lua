---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime:
---
local UIInterstellarMigrationPreCtrl = BaseClass("UIInterstellarMigrationPreCtrl", UIBaseCtrl)

local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIInterstellarMigrationPreview)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

UIInterstellarMigrationPreCtrl.CloseSelf = CloseSelf
UIInterstellarMigrationPreCtrl.Close = Close
return UIInterstellarMigrationPreCtrl