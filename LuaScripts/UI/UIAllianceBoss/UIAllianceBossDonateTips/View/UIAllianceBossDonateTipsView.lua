local UIAllianceBossDonateTipsView = BaseClass("UIAllianceBossDonateTipsView", UIBaseView)
local base = UIBaseView
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local title_text_path = "UICommonPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local panel_path = "UICommonPopUpTitle/panel"
local Txt_TipsOne = "ImgBg/ScrollView/Viewport/Content/Txt_TipsOne"
local Content = "ImgBg/ScrollView/Viewport/Content/Content"
local Txt_TipsTwo = "ImgBg/ScrollView/Viewport/Content/Txt_TipsTwo"

--path define end

function UIAllianceBossDonateTipsView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

function UIAllianceBossDonateTipsView:OnDestroy()
    base.OnDestroy(self)
    self:ComponentDestroy()
end

function UIAllianceBossDonateTipsView:OnEnable()
    base.OnEnable(self)
    self:CreateShowGoods()
end

function UIAllianceBossDonateTipsView:OnDisable()
    base.OnDisable(self)

end

function UIAllianceBossDonateTipsView:ComponentDefine()
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.title_text:SetLocalText(373054)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self.panel = self:AddComponent(UIButton, panel_path)
    self.panel:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)

    self._tipsOne_txt = self:AddComponent(UITextMeshProUGUIEx,Txt_TipsOne)
    self._tipsOne_txt:SetLocalText(373044)
    self._tipsTwo_txt = self:AddComponent(UITextMeshProUGUIEx, Txt_TipsTwo)
    self._tipsTwo_txt:SetLocalText(373045) --描述

    self.content = self:AddComponent(UIBaseContainer,Content)
end


function UIAllianceBossDonateTipsView:ComponentDestroy()

end


function UIAllianceBossDonateTipsView:CreateShowGoods()
    -- deleted
    self.dataList = DataCenter.AllianceBossManager:GetDonateItemArr()
    self:SetAllNeedCellDestroy()
    for i = 1, table.length(self.dataList) do
        --复制基础prefab，每次循环创建一次
        self.rewardModels[i] = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject;
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local cell = self.content:AddComponent(UICommonItem,nameStr)
            local para = {}
            para.rewardType = RewardType.GOODS
            para.itemId = tostring(self.dataList[i].itemId)
            cell:ReInit(para)
        end)
    end
end


function UIAllianceBossDonateTipsView:SetAllNeedCellDestroy()
    self.content:RemoveComponents(UICommonItem)
    if self.rewardModels~=nil then
        for k,v in pairs(self.rewardModels) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.rewardModels = {}
end


return UIAllianceBossDonateTipsView