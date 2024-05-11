---
--- 角色创建
--- Created by zzl.
--- DateTime: 
---
local UIRoleCreateView = BaseClass("UIRoleCreateView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local txt_title_path ="UICommonMiniPopUpTitle/Bg_mid/titleText"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local createTips_txt = "UICommonMiniPopUpTitle/Txt_CreateTips"
local server_txt_path = "UICommonMiniPopUpTitle/Txt_Server"
local left_btn_path = "UICommonMiniPopUpTitle/BtnGo/LeftBtn"
local left_txt_path = "UICommonMiniPopUpTitle/BtnGo/LeftBtn/LeftBtnName"
local right_btn_path = "UICommonMiniPopUpTitle/BtnGo/RightBtn"
local right_txt_path = "UICommonMiniPopUpTitle/BtnGo/RightBtn/RightBtnName"

--创建
function UIRoleCreateView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIRoleCreateView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIRoleCreateView:ComponentDefine()
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)

    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)

    self.return_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)

    self._createTips_txt =  self:AddComponent(UITextMeshProUGUIEx,createTips_txt)
    self._server_txt       =  self:AddComponent(UITextMeshProUGUIEx,server_txt_path)
    
    self._left_btn = self:AddComponent(UIButton,left_btn_path)
    self._right_btn = self:AddComponent(UIButton,right_btn_path)
    self._left_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self._right_btn:SetOnClick(function()
        self:OnClickLogin()
    end)
    self._left_txt = self:AddComponent(UITextMeshProUGUIEx,left_txt_path)
    self._right_txt = self:AddComponent(UITextMeshProUGUIEx,right_txt_path)
    --self._serverState_img   = self:AddComponent(UIImage,"Txt_Server/Image")
end

function UIRoleCreateView:ComponentDestroy()
    self.txt_title = nil
    self.close_btn = nil
    self.return_btn = nil
    self._createTips_txt = nil
    self._server_txt = nil

    self._left_btn = nil
    self._right_btn = nil
    self._left_txt = nil
    self._right_txt = nil
end

function UIRoleCreateView:DataDefine()
end

function UIRoleCreateView:DataDestroy()
end

function UIRoleCreateView:OnEnable()
    base.OnEnable(self)
end

function UIRoleCreateView:OnDisable()
    base.OnDisable(self)
end

function UIRoleCreateView:ReInit()
    local param = self:GetUserData()
    self.param = param
    self._left_txt:SetLocalText(100289)
    self._right_txt:SetLocalText(100288)
    
    self.txt_title:SetLocalText(208230)
    self._createTips_txt:SetLocalText(208235)
    self._server_txt:SetText(Localization:GetString("208236",param.id))
    --local curTime = UITimeManager:GetInstance():GetServerTime()
    --local openTime = param.openTime
    --local deltaTime = curTime - openTime
    --local k1 = LuaEntry.DataConfig:TryGetNum("server_population", "k2")
    --local checkTime = k1*24*60*60*1000
    --if deltaTime<checkTime then
    --    self._serverState_img:LoadSprite("Assets/Main/Sprites/UI/Common/New/Common_img_green_dot.png")
    --else
    --    self._serverState_img:LoadSprite("Assets/Main/Sprites/UI/UIBuild/UIBuild_red dot.png")
    --end
end

function UIRoleCreateView:OnClickLogin()
    SFSNetwork.SendMessage(MsgDefines.NewAccount,{confirm = 2,specify = 1,targetServer = self.param.id})
end

return UIRoleCreateView