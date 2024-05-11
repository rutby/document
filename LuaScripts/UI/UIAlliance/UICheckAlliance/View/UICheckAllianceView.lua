local UICheckAllianceView = BaseClass("UICheckAllianceView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local AllianceJoin = require"UI.UIAlliance.UIJoinOrCreateAlliance.Component.AllianceJoin"
local close_btn_path = "fullTop/CloseBtn"
local txt_title_path ="fullTop/imgTitle/Common_img_title/titleText"
local join_obj_path = "allianceList"
local function OnCreate(self)
    base.OnCreate(self)
    self.curType = 1--0,加入联盟;1,联盟列表
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.txt_title:SetLocalText(390002)
    self.joinObj = self:AddComponent(AllianceJoin,join_obj_path)
    self.joinObj:SetShowType(self.curType)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
end

local function OnDestroy(self)
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

UICheckAllianceView.OnCreate= OnCreate
UICheckAllianceView.OnDestroy = OnDestroy
UICheckAllianceView.OnEnable = OnEnable
UICheckAllianceView.OnDisable = OnDisable
return UICheckAllianceView