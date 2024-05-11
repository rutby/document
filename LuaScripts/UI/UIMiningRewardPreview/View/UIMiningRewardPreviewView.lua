---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl
--- DateTime:
--- 
local UIMiningRewardPreviewView = BaseClass("UIMiningRewardPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MiningRewardPreviewItem = require "UI.UIMiningRewardPreview.Comp.MiningRewardPreviewItem"
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local Content = "ScrollView/Viewport/Content"
local itemRewardTxt_path = "ScrollView/Viewport/Content/RectItemReward/itemRewardTxt"
local RectItemContent_path = "ScrollView/Viewport/Content/RectItemReward/RectItemContent"
local giftRewardTxt_path = "ScrollView/Viewport/Content/RectGiftReward/giftRewardTxt"
local RectGiftContent_path = "ScrollView/Viewport/Content/RectGiftReward/RectGiftContent"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local maskBtn_path = "UICommonPopUpTitle/panel"


function UIMiningRewardPreviewView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UIMiningRewardPreviewView:OnDestroy()
    self:SetAllCellDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIMiningRewardPreviewView:OnEnable()
    base.OnEnable(self)
    self.actId = tonumber(self:GetUserData())
    self:RefreshView()
end

function UIMiningRewardPreviewView:OnDisable()
    base.OnDisable(self)
end

function UIMiningRewardPreviewView:ComponentDefine()
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
    self.maskBtnN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.titleTxt = self:AddComponent(UIText, title_path)
    self.titleTxt:SetLocalText(375006)
    
    self.content = self:AddComponent(UIBaseContainer,Content)
    
    self.itemRewardTxt = self:AddComponent(UIText,itemRewardTxt_path)
    self.itemRewardTxt:SetLocalText(372512)
    self.rectItemContent = self:AddComponent(UIBaseContainer, RectItemContent_path)

    self.giftRewardTxt = self:AddComponent(UIText, giftRewardTxt_path)
    self.giftRewardTxt:SetLocalText(375006)
    self.rectGiftContent = self:AddComponent(UIBaseContainer, RectGiftContent_path)
end

function UIMiningRewardPreviewView:ComponentDestroy()
    self.createBtnTxtN = nil
    self.closeBtnN = nil
end

function UIMiningRewardPreviewView:DataDefine()

end

function UIMiningRewardPreviewView:DataDestroy()
    
end

function UIMiningRewardPreviewView:RefreshView()
    local info = DataCenter.MiningManager:GetRewardPreviewInfo(self.actId)
    self:SetAllCellDestroy()
    self:RefreshItemReward(info.itemRewardInfoList)
    self:RefreshBoxReward(info.miningCarRewardInfoList)
end

--道具奖励
function UIMiningRewardPreviewView:RefreshItemReward(listReward)
    self.modelItem = {}
    if listReward then
        for i = 1, table.count(listReward) do
            --复制基础prefab，每次循环创建一次
            self.modelItem[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.rectItemContent.transform)
                go.transform:Set_localScale(0.75,0.75,0.75)
                go.name ="itemReward" .. i
                local cell = self.rectItemContent:AddComponent(UICommonItem, go.name)
                cell:ReInit(listReward[i])
                --CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
            end)
        end
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
    end
end

function UIMiningRewardPreviewView:SetAllCellDestroy()
    self.rectItemContent:RemoveComponents(UICommonItem)
    if self.modelItem~=nil then
        for k,v in pairs(self.modelItem) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.rectGiftContent:RemoveComponents(MiningRewardPreviewItem)
    if self.modelGift~=nil then
        for k,v in pairs(self.modelGift) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

function UIMiningRewardPreviewView:RefreshBoxReward(giftReward)
    if giftReward then
        self.modelGift = {}
        for i = 1, table.count(giftReward) do
            --复制基础prefab，每次循环创建一次
            self.modelGift[i] = self:GameObjectInstantiateAsync(UIAssets.MiningRewardPreviewItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.rectGiftContent.transform)
                go.transform:Set_localScale(1,1,1)
                go.name ="itemGift" .. i
                local cell = self.rectGiftContent:AddComponent(MiningRewardPreviewItem,go.name)
                cell:ReInit(giftReward[i])
                --CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
            end)
        end
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
    end
end

return UIMiningRewardPreviewView