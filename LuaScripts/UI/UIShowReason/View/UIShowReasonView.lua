--- Created by shimin.
--- DateTime: 2023/12/25 17:41
--- 点击原始时间界面

local UIShowReasonView = BaseClass("UIShowReasonView", UIBaseView)
local base = UIBaseView
local UIShowReasonCell = require "UI.UIShowReason.Component.UIShowReasonCell"

local panel_path = "panel"
local root_path = "root"
local title_des_text_path = "root/title_des_text"
local title_value_text_path = "root/title_des_text/title_value_text"
local cell_content_path = "root/CellBg"
local arrow_img_path = "root/imgArrow"

local TopDeltaY = 40
local TipsWidth = 450

--创建
function UIShowReasonView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UIShowReasonView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIShowReasonView:ComponentDefine()
    self.btn = self:AddComponent(UIButton, panel_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.root = self:AddComponent(UIBaseContainer, root_path)
    self.title_des_text = self:AddComponent(UITextMeshProUGUIEx, title_des_text_path)
    self.title_value_text = self:AddComponent(UITextMeshProUGUIEx, title_value_text_path)
    self.cell_content = self:AddComponent(UIBaseContainer, cell_content_path)
    self.arrow_img = self:AddComponent(UIBaseContainer, arrow_img_path)
end

function UIShowReasonView:ComponentDestroy()
end


function UIShowReasonView:DataDefine()
    self.lossyScaleX = self.transform.lossyScale.x
    if self.lossyScaleX <= 0 then
        self.lossyScaleX = 1
    end
    self.lossyScaleY = self.transform.lossyScale.y
    if self.lossyScaleY <= 0 then
        self.lossyScaleY = 1
    end
    self.screenSize = Vector2.New(Screen.width ,Screen.height)
    self.tipMinX = TipsWidth / 2 * self.lossyScaleX
    self.tipMaxX = self.screenSize.x - TipsWidth / 2 * self.lossyScaleX
    self.tipDeltaY = TopDeltaY * self.lossyScaleY
    self.param = {}
    self.reqList = {}
end

function UIShowReasonView:DataDestroy()
 
end

function UIShowReasonView:OnEnable()
    base.OnEnable(self)
end

function UIShowReasonView:OnDisable()
    base.OnDisable(self)
end

function UIShowReasonView:OnAddListener()
    base.OnAddListener(self)
end


function UIShowReasonView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIShowReasonView:ReInit()
    self.param = self:GetUserData()
    self.title_des_text:SetText(self.param.totalDes)
    self.title_value_text:SetText(self.param.totalValue)
    self:ShowCells()
    self:RefreshPosition()
end

function UIShowReasonView:ShowCells()
    if self.param.cellParams ~= nil then
        for k, v in ipairs(self.param.cellParams) do
            self:GameObjectInstantiateAsync(UIAssets.UIShowReasonDesCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.cell_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.cell_content:AddComponent(UIShowReasonCell, nameStr)
                model:ReInit(v)
            end)
        end
    end
end

function UIShowReasonView:RefreshPosition()
    local pos = Vector3.New(self.param.pos.x, self.param.pos.y + self.tipDeltaY, 0)
    if pos.x < self.tipMinX then
        pos.x = self.tipMinX
    elseif pos.x > self.tipMaxX then
        pos.x = self.tipMaxX
    end

    self.root.transform.position = pos
    self.arrow_img.transform.position = Vector3.New(self.param.pos.x, self.param.pos.y + self.tipDeltaY + 7, 0)
end


return UIShowReasonView