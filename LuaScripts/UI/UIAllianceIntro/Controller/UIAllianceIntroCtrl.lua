local UIAllianceIntroCtrl = BaseClass("UIAllianceIntroCtrl", UIBaseCtrl)
local Localization = CS.GameEntry.Localization

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIAllianceIntro)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function OnClickCreateBtn(self)
	local needMainLv = LuaEntry.DataConfig:TryGetNum("alliance_cost", "k12")
	if DataCenter.BuildManager.MainLv < needMainLv then
		UIUtil.ShowTips(Localization:GetString("143579", needMainLv))
		return
	else
		local seasonId = DataCenter.SeasonDataManager:GetSeasonId()
		if seasonId == 5 then
			UIUtil.ShowTipsId(111095)
			return
		end
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIJoinOrCreateAlliance,2)
		self:CloseSelf()
	end
end

local function OnClickJoinBtn(self)
	UIManager:GetInstance():OpenWindow(UIWindowNames.UIJoinOrCreateAlliance,1)
	self:CloseSelf()
end

UIAllianceIntroCtrl.CloseSelf = CloseSelf
UIAllianceIntroCtrl.Close = Close
UIAllianceIntroCtrl.OnClickCreateBtn = OnClickCreateBtn
UIAllianceIntroCtrl.OnClickJoinBtn = OnClickJoinBtn
return UIAllianceIntroCtrl