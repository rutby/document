--- Created by shimin
--- DateTime: 2023/11/1 16:37
--- 自动参加集结点击德雷克弹出界面

local UIDrakeBossAutoJoinTipsView = BaseClass("UIDrakeBossAutoJoinTipsView", UIBaseView)
local base = UIBaseView

local panel_btn_path = "Panel"
local pos_go_path = "pos_go"
local des_text1_path = "pos_go/root_go/des_text1"
local des_text2_path = "pos_go/root_go/des_text2"

function UIDrakeBossAutoJoinTipsView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIDrakeBossAutoJoinTipsView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
    self.des_text1 = self:AddComponent(UITextMeshProUGUIEx, des_text1_path)
    self.des_text2 = self:AddComponent(UITextMeshProUGUIEx, des_text2_path)
end

function UIDrakeBossAutoJoinTipsView:ComponentDestroy()
end

function UIDrakeBossAutoJoinTipsView:DataDefine()
    self.param = {}
end

function UIDrakeBossAutoJoinTipsView:DataDestroy()
    self.param = {}
end

function UIDrakeBossAutoJoinTipsView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDrakeBossAutoJoinTipsView:OnEnable()
    base.OnEnable(self)
end

function UIDrakeBossAutoJoinTipsView:OnDisable()
    base.OnDisable(self)
end

function UIDrakeBossAutoJoinTipsView:OnAddListener()
    base.OnAddListener(self)
end

function UIDrakeBossAutoJoinTipsView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIDrakeBossAutoJoinTipsView:ReInit()
    self.param = self:GetUserData()
    self.des_text1:SetText(self.param.des1)
    self.des_text2:SetText(self.param.des2)
    self:RefreshPosition()
end

--刷新位置
function UIDrakeBossAutoJoinTipsView:RefreshPosition()
    self.pos_go:SetPosition(self.param.position)
end

return UIDrakeBossAutoJoinTipsView