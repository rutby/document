local UIRolesCell = BaseClass("UIRolesCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local unSColor = Color.New(244/255, 233/255, 217/255, 1.0)
local SColor = Color.New(240/255, 204/255, 135/255, 1.0)

-- 创建
function UIRolesCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIRolesCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIRolesCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIRolesCell:OnDisable()
	base.OnDisable(self)
end


--控件的定义
function UIRolesCell:ComponentDefine()
	self.btn = self:AddComponent(UIButton, "")
	self.btn:SetOnClick(function()
		self:OnBtnClick()
	end)
	self._server_txt 		= self:AddComponent(UITextMeshProUGUIEx, "Rect_Normal/Txt_Server")
	self._name_txt 			= self:AddComponent(UITextMeshProUGUIEx, "Rect_Normal/Txt_Name")
	self._power_txt 		= self:AddComponent(UITextMeshProUGUIEx, "Rect_Normal/layout/powerDi/Force")
	self.headIconN 			= self:AddComponent(UIPlayerHead, "Rect_Normal/UIPlayerHead/HeadIcon")
	self.headFgN 		  	= self:AddComponent(UIImage, "Rect_Normal/UIPlayerHead/Foreground")
	self._curAccount_img 	= self:AddComponent(UIImage,"Rect_Normal/Img_CurAccount")
	self._bg 	            = self:AddComponent(UIImage,"Rect_Normal/bg")
	self._powerDi        	= self:AddComponent(UIImage,"Rect_Normal/layout/powerDi")
	self._levelDi 			= self:AddComponent(UIImage,"Rect_Normal/layout/levelDi")
	self._normal_rect 		= self:AddComponent(UIBaseContainer,"Rect_Normal")
	
	self._createNew_rect 	= self:AddComponent(UIBaseContainer,"Rect_CreateNew")
	self._createNew_txt 	= self:AddComponent(UITextMeshProUGUIEx,"Rect_CreateNew/Txt_CreateNew")
	self._createNewTips_txt = self:AddComponent(UITextMeshProUGUIEx,"Rect_CreateNew/Txt_CreateNewTips")
	
end

--控件的销毁
function UIRolesCell:ComponentDestroy()
	self.btn = nil
	self._server_txt = nil
	self._name_txt = nil
	self._power_txt = nil
	self.headIconN = nil
	self.headFgN = nil
	self._curAccount_img = nil
	self._createNew_rect = nil
	self._createNew_txt = nil
	self._createNewTips_txt = nil
end

--变量的定义
function UIRolesCell:DataDefine()
	self.param = {}
end

--变量的销毁
function UIRolesCell:DataDestroy()
	self.param = nil
end

-- 全部刷新
function UIRolesCell:ReInit(param)
	self.param = param
	if param.isEmpty then
		self._createNew_rect:SetActive(true)
		self._normal_rect:SetActive(false)
		self._createNew_txt:SetLocalText(208226)
		local num = LuaEntry.DataConfig:TryGetNum("server_population", "k1")
		self._createNewTips_txt:SetLocalText(208227,num)
	else
		self._createNew_rect:SetActive(false)
		self._normal_rect:SetActive(true)
		if param.alAbbr~=nil and param.alAbbr~="" then
			self._name_txt:SetText("["..param.alAbbr.."]"..param.gameUserName)
		else
			self._name_txt:SetText(param.gameUserName)
		end
		
		self._server_txt:SetLocalText(208236,param.id)
		self._power_txt:SetLocalText(100392,string.GetFormattedSeperatorNum(param.power))
		self.headIconN:SetData(param.gameUid,param.pic,param.picVer)
		--	local curTime = UITimeManager:GetInstance():GetServerSeconds()
		--self.playerHeadFg:SetActive(self.data.mCardET > curTime)
		self._curAccount_img:SetActive(param.gameUid == LuaEntry.Player.uid)
		self._bg:SetColor(param.gameUid == LuaEntry.Player.uid and SColor or unSColor)
		self._powerDi:SetColor(param.gameUid == LuaEntry.Player.uid and SColor or unSColor)
		self._levelDi:SetColor(param.gameUid == LuaEntry.Player.uid and SColor or unSColor)

	end
end


function UIRolesCell:OnBtnClick()
	if self.param.gameUid == LuaEntry.Player.uid then
		return
	end
	if self.param.isEmpty then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIChooseServer,{ anim = true })
		return
	end

	UIManager:GetInstance():OpenWindow(UIWindowNames.UIRoleLogin,{ anim = true},self.param)
end

return  UIRolesCell
