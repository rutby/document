local UIScienceTabCell = BaseClass("UIScienceTabCell", UIBaseContainer)
local base = UIBaseContainer
local UIGray = CS.UIGray

local btn_path = "btn"
local icon_path = "btn/Ani/icon"
local name_text_path = "btn/Ani/name_text"
local percent_text_path = "btn/Ani/percent_text"

local NormalColor = Color.New(1, 1, 1, 1)
local MaxColor = Color.New(0.9686275,0.882353,0.3843138,1)

-- 创建
function UIScienceTabCell:OnCreate()
	base.OnCreate(self)
	self:ComponentDefine()
	self:DataDefine()
end

-- 销毁
function UIScienceTabCell:OnDestroy()
	self:ComponentDestroy()
	self:DataDestroy()
	base.OnDestroy(self)
end

-- 显示
function UIScienceTabCell:OnEnable()
	base.OnEnable(self)
end

-- 隐藏
function UIScienceTabCell:OnDisable()
	base.OnDisable(self)
end

--控件的定义
function UIScienceTabCell:ComponentDefine()
	self.btn = self:AddComponent(UIButton, btn_path)
	self.btn:SetOnClick(function()
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		self:OnBtnClick()
	end)
	self.icon = self:AddComponent(UIImage, icon_path)
	self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
	self.percent_text = self:AddComponent(UITextMeshProUGUIEx, percent_text_path)
end

--控件的销毁
function UIScienceTabCell:ComponentDestroy()
end

--变量的定义
function UIScienceTabCell:DataDefine()
	self.param = {}
	self.state = ScienceTabState.Lock
end

--变量的销毁
function UIScienceTabCell:DataDestroy()
	self.param = {}
end

-- 全部刷新
function UIScienceTabCell:ReInit(param)
	self.param = param
	self:Refresh()
end

function UIScienceTabCell:Refresh()
	local lockedTip = ""
	self.state, lockedTip = DataCenter.ScienceTemplateManager:GetTabState(self.param.id, self.view.bUuid)
	local iconName = ""
	if self.state == ScienceTabState.UnLock or self.state == ScienceTabState.Lock
			or self.state == ScienceTabState.LockShow or self.state == ScienceTabState.CanUnlock then
		self.percent_text:SetActive(true)
		self.name_text:SetActive(true)
		self.name_text:SetLocalText(self.param.name)
		local pro = DataCenter.ScienceTemplateManager:GetScienceTabPro(self.param.id)
		if pro >= 1 then
			self.percent_text:SetLocalText(GameDialogDefine.MAX)
			self.percent_text:SetColor(MaxColor)
		else
			self.percent_text:SetColor(NormalColor)
			if pro>0 and pro< 0.01 then
				self.percent_text:SetText(math.ceil(pro * 100).."%")
			else
				self.percent_text:SetText(math.floor(pro * 100).."%")
			end
		end
		iconName = string.format(LoadPath.UIScience, self.param.icon)
		UIGray.SetGray(self.transform, false, true)
	elseif self.state == ScienceTabState.UnLock or self.state == ScienceTabState.Lock
			or self.state == ScienceTabState.LockShow or self.state == ScienceTabState.CanUnlock then
		self.percent_text:SetActive(false)
		self.name_text:SetLocalText(self.param.name)
		self.name_text:SetActive(true)
		iconName = string.format(LoadPath.UIScience, self.param.icon)
		UIGray.SetGray(self.transform, true, true)
	elseif self.state == ScienceTabState.Lock then
		self.percent_text:SetActive(false)
		self.name_text:SetActive(false)
		iconName = string.format(LoadPath.UIScience, "UITechnology_img_bg_gray")
		UIGray.SetGray(self.transform, true, false)
	end
	self.icon:LoadSprite(iconName)
end

function UIScienceTabCell:OnBtnClick()
	if self.state == ScienceTabState.UnLock then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience,{ anim = true, hideTop = true},self.param.id, nil, false,self.view.bUuid)
	elseif self.state == ScienceTabState.CanUnlock then
		UIManager:GetInstance():OpenWindow(UIWindowNames.UIScience,{ anim = true, hideTop = true},self.param.id, nil, false,self.view.bUuid)
		DataCenter.ScienceTemplateManager:SetScienceTabSetting(self.param.id)
		self:Refresh()
	end
end

function UIScienceTabCell:SetUpgradeEffect(go)
	go.gameObject:SetActive(true)
	go.transform:SetParent(self.icon)
	go.transform:SetAsFirstSibling()
	go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
	go.transform.localPosition = ResetPosition
end

return UIScienceTabCell