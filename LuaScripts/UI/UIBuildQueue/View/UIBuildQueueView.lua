--- Created by shimin.
--- DateTime: 2023/12/20 15:26
--- 建筑队列界面

local UIBuildQueueView = BaseClass("UIBuildQueueView", UIBaseView)
local base = UIBaseView
local UIBuildQueueCell = require "UI.UIBuildQueue.Component.UIBuildQueueCell"

local txt_title_path = "UICommonMiniPopUpTitle/Bg_mid/titleText"
local return_btn_path = "UICommonMiniPopUpTitle/panel"
local close_btn_path = "UICommonMiniPopUpTitle/Bg_mid/CloseBtn"
local des_text_path = "bg/des_text"
local scroll_view_path = "bg/ScrollView"

--创建
function UIBuildQueueView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIBuildQueueView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBuildQueueView:ComponentDefine()
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
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
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCellMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnCellMoveOut(itemObj, index)
    end)
end

function UIBuildQueueView:ComponentDestroy()
end

function UIBuildQueueView:DataDefine()
    self.list = {}
end

function UIBuildQueueView:DataDestroy()
    self.list = {}
end

function UIBuildQueueView:OnEnable()
    base.OnEnable(self)
end

function UIBuildQueueView:OnDisable()
    base.OnDisable(self)
end

function UIBuildQueueView:ReInit()
    self.txt_title:SetLocalText(GameDialogDefine.BUILD_QUEUE_TITLE)
    self.des_text:SetLocalText(GameDialogDefine.BUILD_QUEUE_DES)
    self.param = self:GetUserData()
    self:Refresh()
end

function UIBuildQueueView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.BuildUpgradeFinish, self.OnBuildUpgradeFinishSignal)
    self:AddUIListener(EventId.UPDATE_BUILD_DATA, self.OnBuildUpdateSignal)
    self:AddUIListener(EventId.AllianceBuildHelpNew, self.OnBuildUpdateSignal)
end

function UIBuildQueueView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.BuildUpgradeFinish, self.OnBuildUpgradeFinishSignal)
    self:RemoveUIListener(EventId.UPDATE_BUILD_DATA, self.OnBuildUpdateSignal)
    self:RemoveUIListener(EventId.AllianceBuildHelpNew, self.OnBuildUpdateSignal)
end

function UIBuildQueueView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIBuildQueueView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIBuildQueueCell)--清循环列表gameObject
end

function UIBuildQueueView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIBuildQueueCell, itemObj)
    item:ReInit(self.list[index])
end

function UIBuildQueueView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIBuildQueueCell)
end

function UIBuildQueueView:GetDataList()
    self.list = {}
    local list = DataCenter.BuildQueueManager:GetOwnBuildQueueList()
    if list ~= nil and list[1] ~= nil then
        if list[2] ~= nil then
            table.sort(list, function(a, b) 
                return a.index < b.index
            end)
        end
        for k, v in ipairs(list) do
            local param = {}
            param.queueData = v
            param.enterParam = self.param
            table.insert(self.list, param)
        end
    end
end

function UIBuildQueueView:Refresh()
    self:ShowCells()
end

function UIBuildQueueView:OnBuildUpgradeFinishSignal()
    self:Refresh()
end

function UIBuildQueueView:OnBuildUpdateSignal()
    self:Refresh()
end

return UIBuildQueueView