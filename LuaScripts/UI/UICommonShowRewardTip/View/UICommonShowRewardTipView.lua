--- Created by shimin
--- DateTime: 2023/8/29 19:12
--- 点击未领取奖励箱子弹出道具列表界面

local UICommonShowRewardTipView = BaseClass("UICommonShowRewardTipView", UIBaseView)
local base = UIBaseView
local UICommonShowRewardTipCell = require "UI.UICommonShowRewardTip.Component.UICommonShowRewardTipCell"

local panel_btn_path = "Panel"
local pos_go_path = "pos_go"
local root_go_path = "pos_go/root_go"
local title_text_path = "pos_go/root_go/title_text"
local scroll_view_path = "pos_go/root_go/ScrollView"
local arrow_img_path = "pos_go/arrow_img"

local PivotXLeft = 1.005
local PivotXRight = -0.005

function UICommonShowRewardTipView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UICommonShowRewardTipView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.arrow_img = self:AddComponent(UIBaseContainer, arrow_img_path)
    self.root_go = self:AddComponent(UIBaseContainer, root_go_path)
end

function UICommonShowRewardTipView:ComponentDestroy()
end

function UICommonShowRewardTipView:DataDefine()
    self.list = {}
    self.param = {}
    self.pivot = Vector2.New(0.5, 0.5)
end

function UICommonShowRewardTipView:DataDestroy()
    self.list = {}
    self.param = {}
end

function UICommonShowRewardTipView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICommonShowRewardTipView:OnEnable()
    base.OnEnable(self)
end

function UICommonShowRewardTipView:OnDisable()
    base.OnDisable(self)
end

function UICommonShowRewardTipView:OnAddListener()
    base.OnAddListener(self)
end

function UICommonShowRewardTipView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UICommonShowRewardTipView:ReInit()
    self.param = self:GetUserData()
    if self.param.titleName == nil then
        self.title_text:SetLocalText(GameDialogDefine.REWARD)
    else
        self.title_text:SetText(self.param.titleName)
    end
    self:ShowCells()
    self:RefreshPosition()
end


function UICommonShowRewardTipView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UICommonShowRewardTipView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UICommonShowRewardTipCell)--清循环列表gameObject
end

function UICommonShowRewardTipView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UICommonShowRewardTipCell, itemObj)
    item:ReInit(self.list[index])
end

function UICommonShowRewardTipView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UICommonShowRewardTipCell)
end

function UICommonShowRewardTipView:GetDataList()
    self.list = {}
    if self.param.rewardList ~= nil then
        for k,v in ipairs(self.param.rewardList) do
            table.insert(self.list, v)
        end
    end
end

--刷新位置
function UICommonShowRewardTipView:RefreshPosition()
    self.pos_go:SetPosition(self.param.position)
    if self.param.pivot == nil then
        self.pivot.y = 0.5
    else
        self.pivot.y = self.param.pivot
    end
  
    if self.param.isLeft then
        --左边
        self.arrow_img:SetEulerAnglesXYZ(0, 0, 180)
        self.pivot.x = PivotXLeft
    else
        --右边
        self.arrow_img:SetEulerAnglesXYZ(0, 0, 0)
        self.pivot.x = PivotXRight
    end
    self.root_go.rectTransform.pivot = self.pivot
    self.root_go:SetAnchoredPositionXY(0, 0)
end


return UICommonShowRewardTipView