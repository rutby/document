--- Created by shimin.
--- DateTime: 2024/1/18 10:13
--- 一键补充资源界面

local UIResourceReplenishView = BaseClass("UIResourceReplenishView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem_TextMeshPro"
local UITrainNeedResCell = require "UI.UITrain.Component.UITrainNeedResCell"

local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local des_text_path = "des_text"
local item_scroll_view_path = "item_scroll_view"
local resource_scroll_view_path = "resource_scroll_view"
local back_toggle_path = "backToggle"
local back_toggle_txt_path = "backToggle/backToggle_txt"
local red_btn_path = "btn_go/MidBtnRed"
local red_btn_text_path = "btn_go/MidBtnRed/red_btn_text"
local blue_btn_path = "btn_go/MidBtnBlue"
local blue_btn_text_path = "btn_go/MidBtnBlue/blue_btn_text"

--创建
function UIResourceReplenishView:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
function UIResourceReplenishView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIResourceReplenishView:ComponentDefine()
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.item_scroll_view = self:AddComponent(UIScrollView, item_scroll_view_path)
    self.item_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemCreateCell(itemObj, index)
    end)
    self.item_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemDeleteCell(itemObj, index)
    end)
    self.resource_scroll_view = self:AddComponent(UIScrollView, resource_scroll_view_path)
    self.resource_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnResourceCreateCell(itemObj, index)
    end)
    self.resource_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnResourceDeleteCell(itemObj, index)
    end)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.back_toggle = self:AddComponent(UIToggle, back_toggle_path)
    self.back_toggle_txt = self:AddComponent(UITextMeshProUGUIEx,back_toggle_txt_path)
    self.back_toggle:SetOnValueChanged(function(tf)
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:ToggleControlBorS(tf)
    end)
    self.red_btn = self:AddComponent(UIButton, red_btn_path)
    self.red_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRedBtnClick()
    end)
    self.red_btn_text = self:AddComponent(UITextMeshProUGUIEx, red_btn_text_path)
    self.blue_btn = self:AddComponent(UIButton, blue_btn_path)
    self.blue_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBlueBtnClick()
    end)
    self.blue_btn_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_text_path)
end

function UIResourceReplenishView:ComponentDestroy()
end

function UIResourceReplenishView:DataDefine()
    self.param = {}
    self.itemList = {}
    self.itemCells = {}
    self.resourceList = {}
    self.resourceCells = {}
    self.todayNoShow = false
end

function UIResourceReplenishView:DataDestroy()
    if self.todayNoShow then
        DataCenter.SecondConfirmManager:SetTodayNoShowSecondConfirm(TodayNoSecondConfirmType.ResourceReplenish, true)
    end
end

function UIResourceReplenishView:OnEnable()
    base.OnEnable(self)
end

function UIResourceReplenishView:OnDisable()
    base.OnDisable(self)
end

function UIResourceReplenishView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
end


function UIResourceReplenishView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
end

function UIResourceReplenishView:ReInit()
    self.param = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.REPLENISH_ALL)
    self.back_toggle_txt:SetLocalText(GameDialogDefine.TODAY_NO_SHOW)
    self.red_btn_text:SetLocalText(GameDialogDefine.CANCEL)
    self.blue_btn_text:SetLocalText(GameDialogDefine.CONFIRM)
    self:RefreshNoShow()
    self:Refresh()
end

function UIResourceReplenishView:Refresh()
    self:ShowItemCells()
    self:ShowResourceCells()
    self:RefreshDes()
end

function UIResourceReplenishView:GetItemDataList()
    self.itemList = DataCenter.ItemManager:GetReplenishUseResourceArr(self.param)
    self:SetShowItemList()
end

function UIResourceReplenishView:SetShowItemList()
    self.itemShowList = {} --展示道具组
    --合并相同id的道具
    local tempList = DeepCopy(self.itemList)
    local firstIndex = 0 --记录第一个重复的索引
    local firstItem = nil
    local mainLvItemList = {}  --临时存储自适应宝箱放在最后
    for i = 1, #tempList do
        if tempList[i].useOrder == ResLackResTypeOrder.Custom then --资源自选道具 需要叠加显示
            if firstIndex > 0 then
                firstItem.count = firstItem.count + tempList[i].count
            else
                firstIndex = i
                firstItem = tempList[i]
            end
        elseif tempList[i].useOrder == ResLackResTypeOrder.Adapt then --自适应箱子
            table.insert(mainLvItemList,tempList[i])
        else
            table.insert(self.itemShowList,tempList[i])
        end
    end
    if firstItem then
        table.insert(self.itemShowList,firstItem)
    end
    if mainLvItemList[1] ~= nil then
        for i = 1, #mainLvItemList do
            table.insert(self.itemShowList,mainLvItemList[i])
        end
    end
end

function UIResourceReplenishView:ClearItemScroll()
    self.itemCells = {}
    self.item_scroll_view:ClearCells()--清循环列表数据
    self.item_scroll_view:RemoveComponents(UICommonItem)--清循环列表gameObject
end

function UIResourceReplenishView:OnItemCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.item_scroll_view:AddComponent(UICommonItem, itemObj)
    cell:ReInit(self.itemShowList[index])
    self.itemCells[index] = cell
end

function UIResourceReplenishView:OnItemDeleteCell(itemObj, index)
    self.itemCells[index] = nil
    self.item_scroll_view:RemoveComponent(itemObj.name, UICommonItem)
end

function UIResourceReplenishView:ShowItemCells()
    self:ClearItemScroll()
    self:GetItemDataList()
    local count = #self.itemShowList
    if count > 0 then
        self.item_scroll_view:SetTotalCount(count)
        self.item_scroll_view:RefillCells()
    end
end


function UIResourceReplenishView:GetResourceDataList()
    self.resourceList = {}
    for k, v in ipairs(self.param) do
        local param = {}
        param.visible = true
        param.cellType = CommonCostNeedType.Resource
        param.resourceType = v.resType
        param.count = v.need
        param.own = LuaEntry.Resource:GetCntByResType(param.resourceType)
        for k1, v1 in ipairs(self.itemList) do
            if v1.resType == v.resType then
                param.own = param.own + v1.count * v1.per
            end
        end
        if param.own < param.count then
            param.isRed = true
        else
            param.isRed = false
        end
        table.insert(self.resourceList, param)
    end
end

function UIResourceReplenishView:ClearResourceScroll()
    self.resourceCells = {}
    self.resource_scroll_view:ClearCells()--清循环列表数据
    self.resource_scroll_view:RemoveComponents(UITrainNeedResCell)--清循环列表gameObject
end

function UIResourceReplenishView:OnResourceCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.resource_scroll_view:AddComponent(UITrainNeedResCell, itemObj)
    cell:ReInit(self.resourceList[index])
    self.resourceCells[index] = cell
end

function UIResourceReplenishView:OnResourceDeleteCell(itemObj, index)
    self.resourceCells[index] = nil
    self.resource_scroll_view:RemoveComponent(itemObj.name, UITrainNeedResCell)
end

function UIResourceReplenishView:ShowResourceCells()
    self:ClearResourceScroll()
    self:GetResourceDataList()
    local count = #self.resourceList
    if count > 0 then
        self.resource_scroll_view:SetTotalCount(count)
        self.resource_scroll_view:RefillCells()
    end
end

function UIResourceReplenishView:ToggleControlBorS(noShow)
    if self.todayNoShow ~= noShow then
        self.todayNoShow = noShow
        self:RefreshNoShow()
    end
end

function UIResourceReplenishView:RefreshNoShow()
    self.back_toggle:SetIsOn(self.todayNoShow)
end

function UIResourceReplenishView:OnRedBtnClick()
    self.ctrl:CloseSelf()
end

function UIResourceReplenishView:OnBlueBtnClick()
    SFSNetwork.SendMessage(MsgDefines.UseResItemMulti, {goodsArr = self.itemList})
    self.ctrl:CloseSelf()
end

function UIResourceReplenishView:RefreshDes()
    local no = false
    for k,v in ipairs(self.resourceList) do
        if v.own < v.count then
            no = true
            break
        end
    end
    if no then
        self.des_text:SetText(string.format(TextColorStr, TextColorRed, Localization:GetString(GameDialogDefine.REPLENISH_ALL_NO)))
    else
        self.des_text:SetLocalText(GameDialogDefine.REPLENISH_ALL_YES)
    end
end

function UIResourceReplenishView:UpdateResourceSignal()
    self:Refresh()
end

return UIResourceReplenishView