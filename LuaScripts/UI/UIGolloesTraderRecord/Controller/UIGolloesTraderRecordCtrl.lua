local UIGolloesTraderRecordCtrl = BaseClass("UIGolloesTraderRecordCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIGolloesTraderRecord)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function OpenMonthCardPanel(self)
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIGiftPackage, { anim = true },
			{
				welfareTagType = WelfareTagType.MonthCard,
				--curRechargeId = rechargeId,
			})
	self:CloseSelf()
end

UIGolloesTraderRecordCtrl.CloseSelf = CloseSelf
UIGolloesTraderRecordCtrl.Close = Close
UIGolloesTraderRecordCtrl.OpenMonthCardPanel = OpenMonthCardPanel
return UIGolloesTraderRecordCtrl