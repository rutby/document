local UIServerItemCell = BaseClass("UIServerItemCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
-- 创建
function UIServerItemCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIServerItemCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIServerItemCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIServerItemCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIServerItemCell:ComponentDefine()
	self.btn = self:AddComponent(UIButton, "")
	self.btn:SetOnClick(function()
		self:OnBtnClick()
	end)
	self._serverName_txt 		= self:AddComponent(UITextMeshProUGUIEx, "layout/Txt_ServerName")
	self._serverState_img    	= self:AddComponent(UIImage,"Img_ServerState")
	self._new_img               = self:AddComponent(UIBaseContainer,"NewDot")
	self.head_obj = self:AddComponent(UIBaseContainer, "UIPlayerHead")
	self.headIconN 			= self:AddComponent(UIPlayerHead, "UIPlayerHead/HeadIcon")
	self.headFgN 		  	= self:AddComponent(UIImage, "UIPlayerHead/Foreground")
end

--控件的销毁
function UIServerItemCell:ComponentDestroy()
	self.btn = nil
	self._serverName_txt = nil
	self._serverState_img = nil
end

--变量的定义
function UIServerItemCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIServerItemCell:DataDestroy()
	self.param = nil
end

-- 全部刷新
function UIServerItemCell:ReInit(param)
	self.param = param
	self.season = param.season
	if self.season~=nil and self.season>0 then
		
	end
	self._serverName_txt:SetText(Localization:GetString("208236",param.id))
	local curTime = UITimeManager:GetInstance():GetServerTime()
	local openTime = param.openTime
	local deltaTime = curTime - openTime
	local k1 = LuaEntry.DataConfig:TryGetNum("server_population", "k2")
	local checkTime = k1*24*60*60*1000
	if deltaTime<checkTime then
		self._new_img:SetActive(true)
		self._serverState_img:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_img_green_dot.png")
	else
		self._new_img:SetActive(false)
		self._serverState_img:LoadSprite("Assets/Main/Sprites/UI/Common/New/UIBuild_red dot.png")
	end
	local playerParam = nil
	local list = DataCenter.AccountManager:GetRolesList()
	self.uidList = {}
	if list~=nil then
		for k,v in pairs(list) do
			if playerParam ==nil and tostring(v.id) == tostring(param.id) then
				playerParam= v
			end
			if v~=nil and v.gameUid~=nil and v.gameUid~=""then
				self.uidList[tostring(v.id)] =  v.gameUid
			end
		end
	end
	if playerParam~=nil then
		self.head_obj:SetActive(true)
		self.headIconN:SetData(playerParam.gameUid,playerParam.pic,playerParam.picVer)
	else
		self.head_obj:SetActive(false)
	end
	
end


function UIServerItemCell:OnBtnClick()
	if tonumber(self.param.status) ~= 0 then
		UIUtil.ShowTipsId(129012)
		return
	end
	if self.season~=nil and self.season>0 then
		UIUtil.ShowTipsId(208256)
		return
	end
	if LuaEntry.Player.gmFlag == 1 then
		if self.param~=nil then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoleCreate,{ anim = true},self.param)
		end
	else
		local num = LuaEntry.DataConfig:TryGetNum("server_population", "k1")
		local value = self.uidList[tostring(self.param.id)]
		if self.param~=nil and (value == nil or table.count(value)<num) then
			UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoleCreate,{ anim = true},self.param)
		else
			UIUtil.ShowTipsId(120624)
		end
	end
	
	--CS.GameEntry.Data.Player:OnCrossServerId(tonumber(self.param.id))
end

return  UIServerItemCell
