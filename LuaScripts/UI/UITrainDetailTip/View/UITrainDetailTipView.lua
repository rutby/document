--- Created by shimin.
--- DateTime: 2023/12/14 00:17
--- 点击训练士兵属性页签弹窗

local UITrainDetailTipView = BaseClass("UITrainDetailTipView", UIBaseView)
local base = UIBaseView

local return_btn_path = "panel"
local pos_go_path = "pos_go"
local des_text_path = "pos_go/des_text"
local arrow_go_path = "pos_go/arrow_go"

local DeltaY = 60
local TipsWidth = 400

--创建
function UITrainDetailTipView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UITrainDetailTipView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

function UITrainDetailTipView:ComponentDefine()
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.arrow_go = self:AddComponent(UIBaseContainer, arrow_go_path)
end

function UITrainDetailTipView:ComponentDestroy()
end

function UITrainDetailTipView:DataDefine()
    self.lossyScaleY = self.transform.lossyScale.y
    self.lossyScaleX = self.transform.lossyScale.x
    self.tipDeltaY = DeltaY * self.lossyScaleY
    self.tipMinX = TipsWidth / 2 * self.lossyScaleX
    self.tipMaxX = Screen.width - TipsWidth / 2 * self.lossyScaleX
    self.param = {}
end

function UITrainDetailTipView:DataDestroy()
    self.param = {}
end

function UITrainDetailTipView:OnEnable()
    base.OnEnable(self)
end

function UITrainDetailTipView:OnDisable()
    base.OnDisable(self)
end

function UITrainDetailTipView:ReInit()
    self.param = self:GetUserData()
    self.des_text:SetText(self.param.des)
    --判断边界情况
    if self.param.pos.x < self.tipMinX then
        self.pos_go:SetPositionXYZ(self.tipMinX, self.param.pos.y + self.tipDeltaY, 0)
    elseif self.param.pos.x > self.tipMaxX then
        self.pos_go:SetPositionXYZ(self.tipMaxX, self.param.pos.y + self.tipDeltaY, 0)
    else
        self.pos_go:SetPositionXYZ(self.param.pos.x, self.param.pos.y + self.tipDeltaY, 0)
    end
    self.arrow_go:SetPositionXYZ(self.param.pos.x, self.param.pos.y + self.tipDeltaY , 0)
end

function UITrainDetailTipView:OnAddListener()
    base.OnAddListener(self)
end

function UITrainDetailTipView:OnRemoveListener()
    base.OnRemoveListener(self)
end

return UITrainDetailTipView