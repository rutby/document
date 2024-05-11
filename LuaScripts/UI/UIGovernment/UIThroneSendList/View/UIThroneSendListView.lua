--- Created by shimin
--- DateTime: 2023/3/21 12:07
--- 王座嘉奖记录界面

local UIThroneSendListView = BaseClass("UIThroneSendListView", UIBaseView)
local base = UIBaseView
local UIThroneSendListCell = require "UI.UIGovernment.UIThroneSendList.Component.UIThroneSendListCell"

local title_txt_path ="UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local scroll_view_path = "ScrollView"
local empty_text_path = "emptyDes"

function UIThroneSendListView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIThroneSendListView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_txt = self:AddComponent(UIText, title_txt_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
    self.empty_text = self:AddComponent(UIText, empty_text_path)
end

function UIThroneSendListView:ComponentDestroy()
end

function UIThroneSendListView:DataDefine()
    self.list = {}
end

function UIThroneSendListView:DataDestroy()
    self.list = {}
end

function UIThroneSendListView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIThroneSendListView:OnEnable()
    base.OnEnable(self)
end

function UIThroneSendListView:OnDisable()
    base.OnDisable(self)
end

function UIThroneSendListView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.GovernmentPresentRecordRefresh, self.GovernmentPresentRecordRefreshSignal)
end

function UIThroneSendListView:OnRemoveListener()
    self:RemoveUIListener(EventId.GovernmentPresentRecordRefresh, self.GovernmentPresentRecordRefreshSignal)
    base.OnRemoveListener(self)
end

function UIThroneSendListView:ReInit()
    DataCenter.GovernmentManager:GetKingdomPresentRecord(LuaEntry.Player:GetSrcServerId())
    self.title_txt:SetLocalText(GameDialogDefine.REWARD_RECORD)
    self:ShowCells()
end

function UIThroneSendListView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.empty_text:SetActive(false)
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    else
        self.empty_text:SetActive(true)
        self.empty_text:SetLocalText(GameDialogDefine.NO_SEND_RECORD)
    end
end

function UIThroneSendListView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIThroneSendListCell)--清循环列表gameObject
end

function UIThroneSendListView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIThroneSendListCell, itemObj)
    item:ReInit(self.list[index])
end

function UIThroneSendListView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIThroneSendListCell)
end

function UIThroneSendListView:GetDataList()
    self.list = {}
    local record = DataCenter.GovernmentManager:GetRewardRecord()
    if record ~= nil then
        self.list = record.list
        if self.list[2] ~= nil then
            table.sort(self.list, function (a, b) 
                return b.sendTime < a.sendTime
            end)
        end
    end
end

function UIThroneSendListView:GovernmentPresentRecordRefreshSignal()
    self:ShowCells()
end

return UIThroneSendListView