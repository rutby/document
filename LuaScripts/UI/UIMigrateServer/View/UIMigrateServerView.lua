---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/4/17 23:04
---
local UIMigrateServerView = BaseClass("UIMigrateServerView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local title_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local intro_path = "Scroll View/Viewport/Content/Intro"
local close_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local return_path = "UICommonMidPopUpTitle/panel"
local buyBtn_path = "offset/buyBtn"
local buyCost_path = "offset/buyBtn/cost"
local buyBtnTxt_path = "offset/buyBtn/cost/buyTxt"
local costItemIcon_path = "offset/buyBtn/cost/buyPrice/consumeIcon"
local costItemCount_path = "offset/buyBtn/cost/buyPrice"
local total_num_path = "sliderBg/totalNum"
local migrate_icon_path = "sliderBg/BuildIcon"
local function OnCreate(self)
    base.OnCreate(self)
    local itemId, itemNum,serverId = self:GetUserData()
    self.itemId = itemId
    self.itemNum = itemNum
    self.serverId = serverId
    if serverId~=nil then
        SFSNetwork.SendMessage(MsgDefines.FindMainBuildInitPosition,serverId)
    end
    
    self.title_text = self:AddComponent(UITextMeshProUGUIEx,title_path)
    self.title_text:SetLocalText(250300)
    self.intro_text = self:AddComponent(UIText, intro_path)
    self.close_btn = self:AddComponent(UIButton, close_path)
    self.close_btn:SetOnClick(function() self.ctrl:CloseSelf() end)
    self.return_btn = self:AddComponent(UIButton, return_path)
    self.return_btn:SetOnClick(function() self.ctrl:CloseSelf() end)
    self.buyBtnN = self:AddComponent(UIButton, buyBtn_path)
    self.buyBtnN:SetOnClick(function()
        self:OnClickBuyBtn()
    end)
    self.buyCostN = self:AddComponent(UIBaseContainer, buyCost_path)
    self.buyBtnTxtN = self:AddComponent(UIText, buyBtnTxt_path)
    self.buyBtnTxtN:SetLocalText(250329)
    self.consumeIconN = self:AddComponent(UIImage, costItemIcon_path)
    self.migrate_icon = self:AddComponent(UIImage, migrate_icon_path)
    self.costCountN = self:AddComponent(UIText, costItemCount_path)
    self.intro_text:SetLocalText(250320,serverId)
    self.total_num = self:AddComponent(UIText, total_num_path)
end

local function OnDestroy(self)
    self.title_text = nil
    self.intro_text = nil
    self.close_btn = nil
    self.return_btn = nil
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:RefreshData()
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnGetMigratePoint, self.GetPoint)
    self:AddUIListener(EventId.RefreshItems, self.RefreshData)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnGetMigratePoint, self.GetPoint)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshData)
end

local function GetPoint(self,data)
    self.pointId = tonumber(data)
end
local function RefreshData(self)
    self.costEnough = false
    local good = DataCenter.ItemData:GetItemById(self.itemId)
    self.consumeIconN:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(self.itemId))
    self.migrate_icon:LoadSprite(DataCenter.ItemTemplateManager:GetIconPath(self.itemId))
    local num = good and good.count or 0
    self.total_num:SetText(num)
    if num>=self.itemNum then
        self.costEnough = true
    end
    local costColor2 = self.costEnough and WhiteColor or RedColor
    local outlineColor = self.costEnough and YellowBtnShadowLightColor or Color.New(1, 1, 1, 0)
    self.costCountN:SetText(self.itemNum)
    self.costCountN:SetColor(costColor2)
end

local function OnClickBuyBtn(self)
    if self.costEnough == true and self.pointId~=nil then
        local serverId = self.serverId
        local pointId = self.pointId
        local serverName = "<color=#FF0000>"..Localization:GetString("208236",serverId).."</color>"
        UIUtil.ShowMessage(Localization:GetString("250395",serverName), 1, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
            EventManager:GetInstance():Broadcast(EventId.OnSetMigratingUI,UIMigrateType.Open)
            SFSNetwork.SendMessage(MsgDefines.MigrateToServer,serverId,0)
        end)
    else
        if self.costEnough == false then
            local lackTab = {}
            local param = {}
            param.type = ResLackType.Item
            param.id = tonumber(self.itemId)
            param.targetNum = self.itemNum
            table.insert(lackTab,param)
            GoToResLack.GoToItemResLackList(lackTab)
        end
    end
end
UIMigrateServerView.OnCreate = OnCreate
UIMigrateServerView.OnDestroy = OnDestroy
UIMigrateServerView.OnEnable = OnEnable
UIMigrateServerView.OnDisable = OnDisable
UIMigrateServerView.RefreshData =RefreshData
UIMigrateServerView.OnClickBuyBtn =OnClickBuyBtn
UIMigrateServerView.GetPoint =GetPoint
UIMigrateServerView.OnAddListener = OnAddListener
UIMigrateServerView.OnRemoveListener = OnRemoveListener
return UIMigrateServerView