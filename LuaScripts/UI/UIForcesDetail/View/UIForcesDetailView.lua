
local UIForcesDetailView = BaseClass("UIForcesDetailView", UIBaseView)
local base = UIBaseView
local PlayerContent = require("UI.UIForcesDetail.Component.PlayerContent")
local ForceContent = require("UI.UIForcesDetail.Component.ForceContent")

local Localization = CS.GameEntry.Localization

local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local goback_btn_path = "UICommonMidPopUpTitle/Btn_GoBack"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local title_txt_Path = "UICommonMidPopUpTitle/bg_mid/titleText"

-- tab 
local playerDetailTab_btn_path = "TabContent/PlayerDetailTab"
local forceDetailTab_btn_path = "TabContent/ForceDetailTab"
--content 
local playerContent_path ="PlayerContent"
local forceContent_path = "ForceContent"

--tabimg
local playerTab_img_path = "TabContent/PlayerDetailTab"
local plyaerTab_icon_path = "TabContent/PlayerDetailTab/playerIcon"
local forceTab_img_path = "TabContent/ForceDetailTab"
local forceTab_icon_path="TabContent/ForceDetailTab/forceIcon"


local  TabType =
{
    PlayerDetail =1,
    FroceDetail  =2
}

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)

    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.goback_btn = self:AddComponent(UIButton, goback_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_Path)

    self.playerContent =self:AddComponent(PlayerContent, playerContent_path)
    self.forceContent =self:AddComponent(ForceContent, forceContent_path)
    self.playerDetailTab_btn = self:AddComponent(UIButton, playerDetailTab_btn_path)
    self.forceDetailTab_btn = self:AddComponent(UIButton, forceDetailTab_btn_path)
    self.playerTab_img = self:AddComponent(UIImage, playerTab_img_path)
    self.plyaerTab_icon = self:AddComponent(UIImage, plyaerTab_icon_path)
    self.forceTab_img = self:AddComponent(UIImage, forceTab_img_path)
    self.forceTab_icon = self:AddComponent(UIImage, forceTab_icon_path)
    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    self.goback_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)
    
    self.playerDetailTab_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:TabClick(TabType.PlayerDetail)
    end)
    self.forceDetailTab_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
       self:TabClick(TabType.FroceDetail)
    end)
    
    
end

local function ComponentDestroy(self)
    self.close_btn = nil
    self.return_btn = nil
    self.title_txt = nil
    self.gobacl_btn = nil
end


local function DataDefine(self)
    self.uid = nil

end

local function DataDestroy(self)
    self.uid = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.PlayerMessageInfo, self.OnPlayerDataCallBack)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.PlayerMessageInfo, self.OnPlayerDataCallBack);
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self.uid = self:GetUserData()
    self.title_txt:SetLocalText(100092) 
    self:TabClick(TabType.PlayerDetail)
    --if  self.uid == LuaEntry.Player.uid then
    --    self.forceDetailTab_btn.gameObject:SetActive(true)
    --else
    self.playerDetailTab_btn:SetActive(false)
        self.forceDetailTab_btn.gameObject:SetActive(false)
    --end
end

local function TabClick(self,tabType)
    if tabType == TabType.PlayerDetail then
        self.playerTab_img:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_tab_up"))
        self.plyaerTab_icon:LoadSprite(string.format(LoadPath.CommonNewPath,"UIForcesDetail_btn_player"))
        self.forceTab_img:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_tab_down"))
        self.forceTab_icon:LoadSprite(string.format(LoadPath.CommonNewPath,"UIForcesDetail_btn_detail_unchecked"))
        self.playerContent.gameObject:SetActive(true)
        self.forceContent.gameObject:SetActive(false)
        self.playerContent:ReInit(self.uid)
    elseif tabType == TabType.FroceDetail then
        self.playerTab_img:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_tab_down"))
        self.plyaerTab_icon:LoadSprite(string.format(LoadPath.CommonNewPath,"UIForcesDetail_btn_player_unchecked"))
        self.forceTab_img:LoadSprite(string.format(LoadPath.CommonNewPath,"Common_btn_tab_up"))
        self.forceTab_icon:LoadSprite(string.format(LoadPath.CommonNewPath,"UIForcesDetail_btn_detail"))
        self.playerContent.gameObject:SetActive(false)
        self.forceContent.gameObject:SetActive(true)
        self.forceContent:ReInit()
    end
    
end

local function OnPlayerDataCallBack(self)
    self.playerContent:OnPlayerDataCallBack()
end

UIForcesDetailView.OnCreate = OnCreate
UIForcesDetailView.OnDestroy = OnDestroy
UIForcesDetailView.OnEnable = OnEnable
UIForcesDetailView.OnDisable = OnDisable
UIForcesDetailView.ComponentDefine = ComponentDefine
UIForcesDetailView.ComponentDestroy = ComponentDestroy
UIForcesDetailView.DataDefine = DataDefine
UIForcesDetailView.DataDestroy = DataDestroy
UIForcesDetailView.OnAddListener = OnAddListener
UIForcesDetailView.OnRemoveListener = OnRemoveListener
UIForcesDetailView.ReInit = ReInit
UIForcesDetailView.TabClick = TabClick
UIForcesDetailView.OnPlayerDataCallBack = OnPlayerDataCallBack
return UIForcesDetailView