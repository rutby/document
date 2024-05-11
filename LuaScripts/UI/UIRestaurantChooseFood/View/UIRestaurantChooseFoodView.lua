--- Created by shimin.
--- DateTime: 2023/12/7 20:44
--- 餐厅选择食物界面

local UIRestaurantChooseFoodView = BaseClass("UIRestaurantChooseFoodView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIRestaurantChooseFoodCell = require "UI.UIRestaurantChooseFood.Component.UIRestaurantChooseFoodCell"

local txt_title_path ="UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local return_btn_path = "UICommonMidPopUpTitle/panel"
local des_text_path = "bg/des_text"
local scroll_view_path = "bg/ScrollView"

--创建
function UIRestaurantChooseFoodView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIRestaurantChooseFoodView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()      
    base.OnDestroy(self)
end

function UIRestaurantChooseFoodView:ComponentDefine()
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

function UIRestaurantChooseFoodView:ComponentDestroy()
end

function UIRestaurantChooseFoodView:DataDefine()
    self.list = {}
end

function UIRestaurantChooseFoodView:DataDestroy()
    self.list = {}
end

function UIRestaurantChooseFoodView:OnEnable()
    base.OnEnable(self)
end

function UIRestaurantChooseFoodView:OnDisable()
    base.OnDisable(self)
end

function UIRestaurantChooseFoodView:ReInit()
    self.txt_title:SetLocalText(GameDialogDefine.SELECT_RESTAURANT_TITLE_NAME)
    self.des_text:SetLocalText(GameDialogDefine.SELECT_RESTAURANT_TITLE_DES)
    self:Refresh()
end

function UIRestaurantChooseFoodView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.VitaDataUpdate, self.VitaDataUpdateSignal)
end

function UIRestaurantChooseFoodView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.VitaDataUpdate, self.VitaDataUpdateSignal)
end

function UIRestaurantChooseFoodView:ShowCells()
    self:ClearScroll()
    self:GetDataList()
    local count = table.count(self.list)
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIRestaurantChooseFoodView:ClearScroll()
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(UIRestaurantChooseFoodCell)--清循环列表gameObject
end

function UIRestaurantChooseFoodView:OnCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.scroll_view:AddComponent(UIRestaurantChooseFoodCell, itemObj)
    item:ReInit(self.list[index])
end

function UIRestaurantChooseFoodView:OnCellMoveOut(itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIRestaurantChooseFoodCell)
end

function UIRestaurantChooseFoodView:GetDataList()
    self.list = {}
    local list = DataCenter.VitaManager:GetConfig(VitaDefines.ConfigKey.Dinner)
    if list ~= nil then
        local curType = DataCenter.VitaManager:GetCurSelectFoodType()
        for k,v in ipairs(list) do
            local param = {}
            param.name = v.name
            param.desc = v.desc
            param.foodCost = v.foodCost
            param.addHunger = v.addHunger
            param.select = curType == k
            param.foodType = k
            param.icon = string.format(LoadPath.UIMain, v.icon)
            table.insert(self.list, param)
        end
    end
end

function UIRestaurantChooseFoodView:Refresh()
    self:ShowCells()
end

function UIRestaurantChooseFoodView:VitaDataUpdateSignal()
    self:Refresh()
end

return UIRestaurantChooseFoodView