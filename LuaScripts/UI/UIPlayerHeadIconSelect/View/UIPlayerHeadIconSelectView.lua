
local UIPlayerHeadIconSelectView = BaseClass("UIPlayerHeadIconSelect",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization


local txt_title_path ="UICommonMiniPopUpTitle/Bg_mid/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local headIcon_select_panel = "UICommonMiniPopUpTitle/panel"
local headIcon_select_cameraBtn = "CameraBtn"
local headIcon_select_photoBtn = "PhotoBtn"
local photo_description_path = "Photo_description"
local camera_description_path = "Camera_description"


local function OnCreate(self)
    base.OnCreate(self)
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.txt_title:SetLocalText(110055) 
    
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
	
    self.tip_return_btn = self:AddComponent(UIButton, headIcon_select_panel)
    self.tip_return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.tip_select_cameraBtn =self:AddComponent(UIButton, headIcon_select_cameraBtn)
    self.tip_select_cameraBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:OnCameraClick()
    end)
    
    self.tip_select_photoBtn =self:AddComponent(UIButton, headIcon_select_photoBtn)
    self.tip_select_photoBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:OnPhotoClick()
    end)
    self.photo_description = self:AddComponent(UITextMeshProUGUIEx, photo_description_path)
    self.camera_description = self:AddComponent(UITextMeshProUGUIEx, camera_description_path)
    self.photo_description:SetLocalText(110057) 
    self.camera_description:SetLocalText(110056) 
    
end

local function OnDestroy(self)

    self.txt_title = nil
    self.close_btn = nil
    self.tip_return_btn = nil
    self.tip_select_cameraBtn = nil
    self.tip_select_photoBtn = nil

    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)

end



UIPlayerHeadIconSelectView.OnCreate= OnCreate
UIPlayerHeadIconSelectView.OnDestroy = OnDestroy
UIPlayerHeadIconSelectView.OnEnable = OnEnable
UIPlayerHeadIconSelectView.OnDisable = OnDisable

return UIPlayerHeadIconSelectView