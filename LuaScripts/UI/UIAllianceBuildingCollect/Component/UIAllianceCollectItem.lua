-- AllianceCitySelectItem.lua

local UIAllianceCollectItem = BaseClass("UIAllianceCollectItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIAllianceHeroCell = require "UI.UIChatNew.Component.RadarAlarmCells.UIAllianceHeroCell"
local AllianceWarPlayerSoliderItem = require "UI.UIAlliance.UIAllianceAlertDetail.Component.AllianceAlertSoliderItem"
local name_path = "mainContent/nameTxt"
local cancel_btn_path ="mainContent/returnButton"
local playerHead_btn_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead"
local playerHead_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead/HeadIcon"
local playerHeadBg_path = "mainContent/leftIcon/PlayIcon/UIPlayerHead/Foreground"
local content_path = "armyContent"
local power_path = "mainContent/powerDesTxt/powerTxt"
local power_des_path = "mainContent/powerDesTxt"
local show_btn_path ="mainContent/showButton"
local close_img_path = "mainContent/ImgArrowNormal"
local open_img_path = "mainContent/ImgArrowSelect"
local _content_rect = "mainContent/Content"
local prog_path = "mainContent/ProgressSlider"
local needTime_path = "mainContent/ProgressSlider/tip"
local progNum_path = "mainContent/ProgressSlider/Txt_Progress"
-- 创建
local function OnCreate(self)
	base.OnCreate(self)
	self:DataDefine()
	self:ComponentDefine()
end

-- 销毁
local function OnDestroy(self)
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
local function OnEnable(self)
	base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
	base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
	self.playerHead_btn = self:AddComponent(UIButton,playerHead_btn_path)
	self.playerHead_btn:SetOnClick(function()
		self:OnClickPlayerHeadBtn()
	end)
	self.playerHead = self:AddComponent(UIPlayerHead, playerHead_path)
	self.playerHeadBg = self:AddComponent(UIImage, playerHeadBg_path)

	self.cancel_btn = self:AddComponent(UIButton, cancel_btn_path)
	self.cancel_btn:SetOnClick(function ()
		self:OnCancelClick()
	end)

	self.name = self:AddComponent(UIText,name_path)

	self.content = self:AddComponent(UIBaseContainer,content_path)

	self.power = self:AddComponent(UIText,power_path)
	self.power_des = self:AddComponent(UIText,power_des_path)
	self.power_des:SetText(Localization:GetString("130068")..": ")

	self.close_img = self:AddComponent(UIImage,close_img_path)
	self.open_img = self:AddComponent(UIImage,open_img_path)
	self.show_btn = self:AddComponent(UIButton, show_btn_path)
	self.show_btn:SetOnClick(function ()
		self:OnShowClick()
	end)
	self.progN = self:AddComponent(UISlider, prog_path)
	self.selfTimeN = self:AddComponent(UIText, needTime_path)
	self.selfResCountN = self:AddComponent(UIText, progNum_path)
	self._content_rect = self:AddComponent(UIBaseContainer,_content_rect)
	self.modelHero = {}
	self.timer_action_collect = function(temp)
		self:RefreshCollectTime()
	end
end

--控件的销毁
local function ComponentDestroy(self)
	self:DelCollectTime()
	self.iconN = nil
	self.levelN = nil
	self.nameN = nil
	self.posN = nil
	self.selectBtnN = nil
	self.selectBtnTxtN = nil
	self:SetAllCellDestroy()
	self:SetAllCellDestroyHero()
end

--变量的定义
local function DataDefine(self)
end

--变量的销毁
local function DataDestroy(self)
end

local function SetItem(self,march)
	self.marchInfo = march
	self.playerHead:SetData(march.ownerUid,march.pic,march.picVer)
	if march.headBg then
		self.playerHeadBg:SetActive(true)
	else
		self.playerHeadBg:SetActive(false)
	end

	if march.ownerUid == LuaEntry.Player.uid then
		self.cancel_btn:SetActive(true)
	else
		self.cancel_btn:SetActive(false)
	end
	self.name:SetText(self.marchInfo.ownerName)
	
	self.power:SetText(march:GetSoliderNum())
	
	self.open_img:SetActive(true)
	self.close_img:SetActive(false)
	self.content:SetActive(false)
	self.showSolider = false
	if self.marchInfo:GetMarchTargetType() == MarchTargetType.COLLECT_ALLIANCE_BUILD_RESOURCE and self.marchInfo:GetMarchStatus()== MarchStatus.COLLECTING  or self.marchInfo:GetMarchTargetType() == MarchTargetType.ASSISTANCE_COLLECT_ACT_ALLIANCE_MINE and self.marchInfo:GetMarchStatus()== MarchStatus.COLLECTING_ASSISTANCE then
		self.progN:SetActive(true)
		self:AddCollectTime()
		self:RefreshCollectTime()
	else
		self.progN:SetActive(false)
	end
	--self:ShowHero()
end

local function OnCancelClick(self)
	MarchUtil.OnBackHome(self.marchInfo.uuid)
	self.view.ctrl:CloseSelf()
end

local function ShowHero(self)
	self:SetAllCellDestroyHero()
	--英雄
	local list = self.marchInfo.armyInfos[1].HeroInfos
	if next(list) then
		table.sort(list, function(a,b)
			if a.heroQuality > b.heroQuality then
				return true
			elseif a.heroQuality == b.heroQuality then
				if a.heroLevel > b.heroLevel then
					return true
				end
				return false
			end
		end)
		for i = 1, table.length(list) do
			--复制基础prefab，每次循环创建一次
			self.modelHero[i] = self:GameObjectInstantiateAsync(UIAssets.AllianceHeroCell, function(request)
				if request.isError then 
					return
				end
				local go = request.gameObject;
				go:SetActive(true)
				go.transform:SetParent(self._content_rect.transform)
				go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
				NameCount = NameCount + 1
				local nameStr = tostring(NameCount)
				go.name = nameStr
				local cell = self._content_rect:AddComponent(UIAllianceHeroCell, go.name)
				cell:ReInit(list.heros[i])
			end)
		end
	end
end

local function SetAllCellDestroyHero(self)
	self._content_rect:RemoveComponents(UIAllianceHeroCell)
	if next(self.modelHero) then
		for k,v in pairs(self.modelHero) do
			if v ~= nil then
				self:GameObjectDestroy(v)
			end
		end
	end
	self.modelHero ={}
end



local function OnShowClick(self)
	self:SetAllCellDestroy()
	if self.showSolider then
		self.open_img:SetActive(true)
		self.close_img:SetActive(false)
		self.content:SetActive(false)
		self.showSolider =false
	else
		self.open_img:SetActive(false)
		self.close_img:SetActive(true)
		self.content:SetActive(true)
		self.showSolider =true
		self:SetAllCellDestroy()
		local list = self.marchInfo.armyInfos[1].Soldiers
		if next(list) then
			table.sort(list, function(a,b)
				local aData = DataCenter.ArmyTemplateManager:GetArmyTemplate(tonumber(a.armsId))
				local bData = DataCenter.ArmyTemplateManager:GetArmyTemplate(tonumber(b.armsId))
				if aData.level > bData.level then
					return true
				elseif aData.level == bData.level then
					if aData.arm > bData.arm then
						return true
					end
					return false
				end
			end)
			for i = 1, table.length(list) do
				--复制基础prefab，每次循环创建一次
				self.model[i] = self:GameObjectInstantiateAsync(UIAssets.AllianceWarPlayerSoliderItem, function(request)
					if request.isError then
						return
					end
					local go = request.gameObject;
					go:SetActive(true)
					go.transform:SetParent(self.content.transform)
					go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
					go.name = "item"..i
					local cell = self.content:AddComponent(AllianceWarPlayerSoliderItem,go.name)
					cell:SetData(list[i].armsId,list[i].total)
				end)
			end
		end
	end
end

local function SetAllCellDestroy(self)
	self.content:RemoveComponents(AllianceWarPlayerSoliderItem)
	if self.model and next(self.model) then
		for k,v in pairs(self.model) do
			if v ~= nil then
				self:GameObjectDestroy(v)
			end
		end
	end
	self.model ={}
end


local function AddCollectTime(self)
	if self.collectTimer == nil then
		self.collectTimer = TimerManager:GetInstance():GetTimer(1, self.timer_action_collect , self, false,false,false)
	end
	self.collectTimer:Start()
end

local function RefreshCollectTime(self)
	if self.marchInfo~=nil then
		local curTime = UITimeManager:GetInstance():GetServerTime()
		local remainTime = self.marchInfo.endTime - curTime
		local totalTime = self.marchInfo.endTime - self.marchInfo.startTime
		local curNum = (totalTime-remainTime)*self.marchInfo.collectSpd*0.001
		local totalNum = totalTime*self.marchInfo.collectSpd*0.001
		if remainTime > 0 then
			local percent = math.min((curNum/math.max(totalNum,1)),1)
			self.progN:SetValue(percent)
			self.selfResCountN:SetLocalText(150033,string.GetFormattedStr(math.floor(curNum)),string.GetFormattedStr(math.floor(totalNum)))
			self.selfTimeN:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(remainTime))
		else
			self.progN:SetValue(1)
			self.selfResCountN:SetLocalText(150033,string.GetFormattedStr(math.floor(totalNum)),string.GetFormattedStr(math.floor(totalNum)))
			self:DelCollectTime()
			self.selfTimeN:SetText("00:00:00")
		end
	end

end

local function DelCollectTime(self)
	if self.collectTimer ~= nil then
		self.collectTimer:Stop()
		self.collectTimer = nil
	end
end


UIAllianceCollectItem.OnCreate = OnCreate
UIAllianceCollectItem.OnDestroy = OnDestroy
UIAllianceCollectItem.OnEnable = OnEnable
UIAllianceCollectItem.OnDisable = OnDisable
UIAllianceCollectItem.ComponentDefine = ComponentDefine
UIAllianceCollectItem.ComponentDestroy = ComponentDestroy
UIAllianceCollectItem.DataDefine = DataDefine
UIAllianceCollectItem.DataDestroy = DataDestroy


UIAllianceCollectItem.SetItem = SetItem
UIAllianceCollectItem.OnCancelClick = OnCancelClick
UIAllianceCollectItem.OnShowClick = OnShowClick
UIAllianceCollectItem.SetAllCellDestroy = SetAllCellDestroy

UIAllianceCollectItem.ShowHero = ShowHero
UIAllianceCollectItem.SetAllCellDestroyHero = SetAllCellDestroyHero

UIAllianceCollectItem.AddCollectTime = AddCollectTime
UIAllianceCollectItem.RefreshCollectTime = RefreshCollectTime
UIAllianceCollectItem.DelCollectTime = DelCollectTime
return UIAllianceCollectItem