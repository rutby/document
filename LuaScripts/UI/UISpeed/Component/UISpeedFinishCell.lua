--- Created by shimin.
--- DateTime: 2024/1/19 16:05
--- 加速界面一键补充cell

local UISpeedFinishCell = BaseClass("UISpeedFinishCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local name_text_path = "name_text"
local des_text_path = "layout/des_text"
local use_btn_path = "use_btn"
local use_btn_text_path = "use_btn/yellow_btn_go/yellow_btn_text"
local yellow_btn_icon_text_path = "use_btn/yellow_btn_go/yellow_btn_icon_text"

function UISpeedFinishCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

function UISpeedFinishCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

function UISpeedFinishCell:OnEnable()
	base.OnEnable(self)
end

function UISpeedFinishCell:OnDisable()
	base.OnDisable(self)
end

function UISpeedFinishCell:ComponentDefine()
	self.use_btn = self:AddComponent(UIButton, use_btn_path)
	self.use_btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnUseBtnClick()
	end)
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
	self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
	self.use_btn_text = self:AddComponent(UITextMeshProUGUIEx, use_btn_text_path)
	self.yellow_btn_cost_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_icon_text_path)
end

function UISpeedFinishCell:ComponentDestroy()
end

function UISpeedFinishCell:DataDefine()
	self.param = {}
	self.spendGold = 0
end

function UISpeedFinishCell:DataDestroy()
end

function UISpeedFinishCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UISpeedFinishCell:Refresh()
	self.name_text:SetLocalText(GameDialogDefine.IMMEDIATELY_ADD_SPEED)
	self.use_btn_text:SetLocalText(GameDialogDefine.BUY_AND_USE)
	self:RefreshTime()
end

--父类驱动一分钟刷一次（秒为0）
function UISpeedFinishCell:RefreshTime()
	local curTime = UITimeManager:GetInstance():GetServerTime()
	local leftTime = self.param.endTime - curTime
	local costGold = CommonUtil.GetTimeDiamondCost(math.floor(leftTime / 1000))
	self.des_text:SetLocalText(GameDialogDefine.USE_GOLD_SPEED_WITH,
			string.format(TextColorStr, TextColorGreen, UITimeManager:GetInstance():MilliSecondToFmtString(leftTime)))
	if costGold ~= self.spendGold then
		self.spendGold = costGold
		self.yellow_btn_cost_text:SetText(string.GetFormattedSeperatorNum(self.spendGold))
		self:RefreshGoldColor()
	end
end

function UISpeedFinishCell:OnUseBtnClick()
	if LuaEntry.Player.gold < self.spendGold then
		GoToUtil.GotoPayTips()
	else
		--先发送已使用的加速，在发送使用钻石
		UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond, Localization:GetString(GameDialogDefine.USE_GOLF_ADD_SPEED_TIP_DES),
				2, string.GetFormattedSeperatorNum(self.spendGold), Localization:GetString(GameDialogDefine.CANCEL),function()
					local param = self.param
					self.view.close = true
					self.view.ctrl:CloseSelf()
					if param.speedType == ItemSpdMenu.ItemSpdMenu_City then
						SFSNetwork.SendMessage(MsgDefines.BuildCcdMNew, { bUUID = param.uuid,itemIDs = "",isFixRuins = false, useGold = true})
					else
						local queue = DataCenter.QueueDataManager:GetQueueByUuid(param.uuid)
						if queue ~= nil then
							SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = param.uuid, itemIDs = "",isGold = IsGold.UseGold })
						end
					end
				end, function()
				end,nil,nil,true, DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold),nil)
	end
end

function UISpeedFinishCell:RefreshGoldColor()
	local gold = LuaEntry.Player.gold
	if gold < self.spendGold then
		self.yellow_btn_cost_text:SetColor(ButtonRedTextColor)
	else
		self.yellow_btn_cost_text:SetColor(WhiteColor)
	end
end

return UISpeedFinishCell