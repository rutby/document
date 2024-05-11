
local PlayerIconItem = BaseClass("PlayerIconItem",UIBaseContainer)
local base = UIBaseContainer
local img_path = "PhotoBtn/PhotoBg"
local img_bg_path = "PhotoBtn/headBg"
local head_red_pot_path = "PhotoBtn/ModifyHeadRedPot"
local img_btn_path = ""
local img_select_path="Select"
local use_select_txt="Bg/Desc"
local use_select_bg="Bg"
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local function OnCreate(self,data)
    base.OnCreate(self)
    self.img = self:AddComponent(CircleImage,img_path)
    self.img_bg = self:AddComponent(UIImage,img_bg_path)
    self.btn = self:AddComponent(UIButton, img_btn_path)
	self.selectImg = self:AddComponent(UIImage, img_select_path)
	self.useTxt = self:AddComponent(UITextMeshProUGUIEx, use_select_txt)
	self.useBg = self:AddComponent(UIImage, use_select_bg)
	self.head_red_pot = self:AddComponent(UIBaseContainer, head_red_pot_path)
	self.useBg:SetActive(false);
	
end

local function SetItemShow(self, data)
    self.itemData = data
    self.btn:SetOnClick(function()  
		SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
		local itemID = self.itemData.id;
		if itemID==1 then
			self.view.ctrl:OnGotoClick(self.itemData.id)
			Setting:SetInt(LuaEntry.Player.uid..LuaEntry.Player.pushMark..SettingKeys.FIRST_PAY_BUY_CLICK, 0)
			EventManager:GetInstance():Broadcast(EventId.PlayerChangeHeadRedPot)
			self.head_red_pot:SetActive(LuaEntry.Player:ShowPlayerChangeHeadRedPot() == true)
		end
		
		EventManager:GetInstance():Broadcast(EventId.ChangeNameIcon_Select, itemID ~= 1 and self.itemData.picName or nil)
	end)
	local useIcon = "Assets/Main/Sprites/UI/UIHeadIcon/"..self.itemData.picName..".png"
    ---1 代表相机
    if self.itemData.id == 1 then
		--self:SetActive(false)
        --self.img_bg:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_bg_player.png")
		--UIGray.SetGray(self.img_bg.transform, true,true)
        self.img:LoadSprite("Assets/Main/Sprites/UI/UISet/New/Common_head_photo.png")
		self.head_red_pot:SetActive(LuaEntry.Player:ShowPlayerChangeHeadRedPot() == true)
		--return
    else
		--UIGray.SetGray(self.img_bg.transform, false,true)
        --self.img_bg:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_bg_player.png")
        self.img:LoadSprite(useIcon)
		self.head_red_pot:SetActive(false)
    end
	local pic = LuaEntry.Player:GetFullPic()
	if pic == useIcon then
		self.selectImg:SetActive(true)
		self.useBg:SetActive(true);
		self.useTxt:SetLocalText(129001) 
	end
  
end

local function OnEnable(self)
    base.OnEnable(self)
	
end

local function OnCancelSelect(self, picName)
	if self.itemData.id==1 then
		self.selectImg:SetActive(picName == nil or picName == "")
		return
	end
	
	self.selectImg:SetActive(picName == self.itemData.picName)
end
local function OnDisable(self)
	if self.selectImg~=nil then
		self.selectImg:SetActive(false)
	end
    base.OnDisable(self)
end
local function OnDestroy(self)
	--EventManager:GetInstance():RemoveListener(EventId.ChangeNameIcon_Select, self.CancelSelect)
    self.itemData = nil
    self.img = nil
    self.btn = nil
    base.OnDestroy(self)
end
local function OnRefreshPlayerIcon(self,pic)
	self.useBg:SetActive(self.itemData.picName == pic)
end
local function OnAddListener(self)
	self:AddUIListener(EventId.ChangeNameIcon_Select,self.OnCancelSelect)
	self:AddUIListener(EventId.UpdatePlayerHeadIcon,self.OnRefreshPlayerIcon)
	base.OnAddListener(self)
	
end
local function OnRemoveListener(self)
	self:RemoveUIListener(EventId.ChangeNameIcon_Select,self.OnCancelSelect)
	self:RemoveUIListener(EventId.UpdatePlayerHeadIcon,self.OnRefreshPlayerIcon)
	base.OnRemoveListener(self)
end

PlayerIconItem.OnCreate= OnCreate
PlayerIconItem.OnDestroy = OnDestroy
PlayerIconItem.OnEnable = OnEnable
PlayerIconItem.OnDisable = OnDisable
PlayerIconItem.SetItemShow = SetItemShow
PlayerIconItem.OnAddListener=OnAddListener
PlayerIconItem.OnRemoveListener=OnRemoveListener
PlayerIconItem.OnCancelSelect=OnCancelSelect
PlayerIconItem.OnRefreshPlayerIcon=OnRefreshPlayerIcon
return PlayerIconItem