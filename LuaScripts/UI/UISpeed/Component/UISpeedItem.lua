
local UISpeedItem = BaseClass("UISpeedItem", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local commonItem = "UICommonItemSize"
local select = "Select"
local btn = ""

-- 创建
function UISpeedItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UISpeedItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function UISpeedItem:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function UISpeedItem:OnDisable()
    base.OnDisable(self)
end

--控件的定义
function UISpeedItem:ComponentDefine()
    self.commonItem = self:AddComponent(UICommonItem,commonItem)
    self.select = self:AddComponent(UIBaseContainer,select)
    self.btn = self:AddComponent(UIButton,btn)
    self.btn:SetOnClick(function()
        self:clickSelectBtn()
    end)
end

--控件的销毁
function UISpeedItem:ComponentDestroy()
end

--变量的定义
function UISpeedItem:DataDefine()
    self.param = {}
end

--变量的销毁
function UISpeedItem:DataDestroy()
    self.param = {}
end

-- 全部刷新
function UISpeedItem:ReInit(param,index)
    self.clickCallBack = param.clickCallBack
    self.index = index
    local item = {
        rewardType = RewardType.GOODS,
        itemId = param.itemId,
        count = param.item.count,
    }
    self.commonItem:ReInit(item)
end

function UISpeedItem:clickSelectBtn()
    self.clickCallBack(self.index)
end

function UISpeedItem:refreshSelectState(value)
    self.select:SetActive(value)
end

return UISpeedItem