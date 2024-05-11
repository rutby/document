
local PlayerIconItem = require "UI.UIPlayerChangeHeadIcon.Component.PlayerIconItem"
local UIPlayerInfoView = BaseClass("UIPlayerChangeHeadIcon",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local txt_title_path ="UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonPopUpTitle/panel"
--left
local headicon_path = "Content/UIPlayerHead/HeadIcon"
local foreground_path = "Content/UIPlayerHead/Foreground"

local use_btn_path = "Content/BtnUse"
local use_btn_txt_path = "Content/BtnUse/Text"

--Right
local head_content_path = "Content/Right/ScrollView/Viewport/Content"
local select_btn_headIcon_path = "Content/Right/Cell/PhotoBtn"
local scroll_path = "Content/Right/ScrollView"
local canUseTxt_path = "Content/CanUseTxt"

local picName=""

local frame_btn_path = "Content/BtnFrame"
local frame_btn_txt_path = "Content/BtnFrame/BtnFrameText"

local function OnCreate(self)
    base.OnCreate(self)

    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.txt_title:SetLocalText(110084) 
    
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)

    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    --left
    self.head_icon = self:AddComponent(UIPlayerHead, headicon_path)
    self.head_img = self:AddComponent(CircleImage, headicon_path)
    
    self.imgUploading = self:AddComponent(UIImage, 'Content/ImgUploading')
    self.textUploading = self:AddComponent(UITextMeshProUGUIEx, 'Content/ImgUploading/TextUploading')
    self.textUploading:SetLocalText(280181)
    
    self.use_btn_txt = self:AddComponent(UITextMeshProUGUIEx,use_btn_txt_path)
	self.use_btn_txt:SetLocalText(110046) 
	
    self.use_btn = self:AddComponent(UIButton,use_btn_path)
    self.use_btn:SetOnClick(function()  
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        --使用头像
        self.ctrl:OnUseClick(picName)
    end)
	self.use_btn:SetActive(false)
    --循环列表
    self.ScrollView = self:AddComponent(UIScrollView, scroll_path)
    self.ScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.ScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.apply_list ={}

    self.canUseTxt = self:AddComponent(UITextMeshProUGUIEx,canUseTxt_path)
    self.canUseTxt:SetLocalText(129001)

    self.frame_btn = self:AddComponent(UIButton, frame_btn_path)
    self.frame_btn_txt = self:AddComponent(UITextMeshProUGUIEx, frame_btn_txt_path)
    self.frame_btn_txt:SetLocalText(320558)
    self.foreground = self:AddComponent(UIImage, foreground_path)
    self.frame_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        --使用头像
        self.ctrl:OnFrameClick()
    end)
    if CS.CommonUtils.IsDebug() then
        --CS.UIGray.SetGray(self.frame_btn.transform, true, false)
    else
        CS.UIGray.SetGray(self.frame_btn.transform, true, false)
    end
    self:OnRefreshPlayerIcon()
    self:OnUserSkinUpdate()
end

local function OnDestroy(self)
    self.txt_title = nil
    self.headicon_content = nil
    self.close_btn = nil
    self.return_btn = nil
    self.ScrollView = nil
    self.apply_list =nil
    base.OnDestroy(self)
end


local function OnSelect(self,pic)
	picName=pic
	--if pic~=LuaEntry.Player:GetPic() then
	--	self.use_btn:SetActive(true)
    --    self.canUseTxt:SetActive(false)
	--else
	--	self.use_btn:SetActive(false)
    --    self.canUseTxt:SetActive(true)
	--end
    local uid = LuaEntry.Player:GetUid()
    local picVer = LuaEntry.Player.picVer
    local canShowUseBtn = pic ~= nil and pic ~= LuaEntry.Player:GetPic()
    self.head_icon:SetData(uid, pic, picVer)
    self.use_btn:SetActive(canShowUseBtn)
    self.canUseTxt:SetActive(not canShowUseBtn and pic ~= nil)
end

local function OnRefreshPlayerIcon(self)
    local uid = LuaEntry.Player:GetUid()
    local pic = LuaEntry.Player:GetPic()
    local picVer = LuaEntry.Player.picVer

    --如果设置自定义头像 加个状态提示
    if pic == "" then
        self.textUploading:SetLocalText(280182) --加载中
        self.imgUploading:SetActive(true)
        self.head_icon:SetCustomLoadCallback(function()
            self.imgUploading:SetActive(false)
            self.head_icon:SetCustomLoadCallback(nil)
        end)
    end
    
    self.head_icon:SetData(uid, pic, picVer)
    
    self:OnSelect(pic)
end
local function OnAddListener(self)
	self:AddUIListener(EventId.ChangeNameIcon_Select,self.OnSelect)
	self:AddUIListener(EventId.UpdatePlayerHeadIcon,self.OnRefreshPlayerIcon)
    
    self:AddUIListener(EventId.UploadHead_Start, self.OnUploadHeadStart)
    self:AddUIListener(EventId.UploadHead_End, self.OnUploadHeadEnd)
    self:AddUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)
    base.OnAddListener(self)
end

local function OnUserSkinUpdate(self)
    local frame = DataCenter.DecorationDataManager:GetSelfHeadFrame()
    if string.IsNullOrEmpty(frame) then
        self.foreground:SetActive(false)
    else
        self.foreground:SetActive(true)
        self.foreground:LoadSprite(frame)
    end
end

local function RefreshApplyList(self)
    self:ClearScroll(self)
--[[    self.ScrollView:SetTotalCount(40)
    self.ScrollView:RefillCells()]]
    self.apply_list =  self.ctrl:GetAllHeadIconInfo()
    if #self.apply_list > 0 then
        self.ScrollView:SetTotalCount(#self.apply_list)
        self.ScrollView:RefillCells()
    else
     end
end

local function OnEnable(self)
    base.OnEnable(self)
    self:RefreshApplyList()
    
    local isUploading = LuaEntry.Player:IsPicUploading()
    self.imgUploading:SetActive(isUploading)
end

local function OnDisable(self)
    self:ClearScroll(self)
    base.OnDisable(self)

end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.ScrollView:AddComponent(PlayerIconItem, itemObj)
    cellItem:SetItemShow(self.apply_list[index])
end

local function OnItemMoveOut(self, itemObj, index)
    self.ScrollView:RemoveComponent(itemObj.name, PlayerIconItem)
end

local function ClearScroll(self)
    self.ScrollView:ClearCells()
    self.ScrollView:RemoveComponents(PlayerIconItem)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
	self:RemoveUIListener(EventId.ChangeNameIcon_Select,self.OnSelect)
--    self:RemoveUIListener(EventId.PlayerMessageInfo,self.OnPlayerDataCallBack)
   -- self:RemoveUIListener(EventId.NickNameChangeEvent, self.OnPlayerDataCallBack)
	self:RemoveUIListener(EventId.UpdatePlayerHeadIcon,self.OnRefreshPlayerIcon)
    self:RemoveUIListener(EventId.UploadHead_Start, self.OnUploadHeadStart)
    self:RemoveUIListener(EventId.UploadHead_End, self.OnUploadHeadEnd)
    self:RemoveUIListener(EventId.UserSkinUpdate, self.OnUserSkinUpdate)

end

local function OnUploadHeadStart(self)
    self.textUploading:SetLocalText(280181) --上传中
    self.imgUploading:SetActive(true)
end

local function OnUploadHeadEnd(self)
    self.imgUploading:SetActive(false)
end


UIPlayerInfoView.OnCreate= OnCreate
UIPlayerInfoView.OnDestroy = OnDestroy
UIPlayerInfoView.OnEnable = OnEnable
UIPlayerInfoView.OnDisable = OnDisable
UIPlayerInfoView.RefreshApplyList = RefreshApplyList
UIPlayerInfoView.OnItemMoveIn = OnItemMoveIn
UIPlayerInfoView.OnItemMoveOut = OnItemMoveOut
UIPlayerInfoView.ClearScroll = ClearScroll
UIPlayerInfoView.OnSelect=OnSelect
UIPlayerInfoView.OnAddListener=OnAddListener
UIPlayerInfoView.OnRemoveListener=OnRemoveListener
UIPlayerInfoView.OnRefreshPlayerIcon=OnRefreshPlayerIcon
UIPlayerInfoView.OnUploadHeadStart=OnUploadHeadStart
UIPlayerInfoView.OnUploadHeadEnd=OnUploadHeadEnd
UIPlayerInfoView.OnUserSkinUpdate = OnUserSkinUpdate

return UIPlayerInfoView