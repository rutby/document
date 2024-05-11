local UIALVSDonateSoldierRewardView = BaseClass("UIALVSDonateSoldierRewardView", UIBaseView)
local base = UIBaseView
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local Localization = CS.GameEntry.Localization
local UIALVSDonateSoldierRewardPanelCell = require "UI.UIALVSDonateSoldier.UIALVSDonateSoldierReward.Component.UIALVSDonateSoldierRewardPanelCell"
local UIGray = CS.UIGray

-- 页面标题
local view_title_label_path = "UICommonPopUpTitle/bg_mid/titleText"
-- 页面关闭按钮
local view_close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
-- 礼包节点
local gift_pack_container_path = "ImgBg/LayoutGroup/packageContainer"
-- 礼包名字
local gift_pack_name_label_path = "ImgBg/LayoutGroup/packageContainer/package/packageName"
-- 礼包描述
local gift_pack_des_label_path = "ImgBg/LayoutGroup/packageContainer/package/packageDesc"
-- 礼包购买按钮
local gift_pack_buy_btn_path = "ImgBg/LayoutGroup/packageContainer/package/buyBtn"
-- 礼包购买按钮文字
local gift_pack_buy_btn_label_path = "ImgBg/LayoutGroup/packageContainer/package/buyBtn/buyBtnTxt"
-- 礼包购买奖励点数节点
local gift_pack_buy_point_path = "ImgBg/LayoutGroup/packageContainer/package/buyBtn/UIGiftPackagePoint"
-- 滑动节点
local scroll_view_path = "ImgBg/LayoutGroup/ScrollView"
-- 滑动区域标题1
local scroll_title_1_label_path = "ImgBg/LayoutGroup/TItleNode/TitleLabelContainer/Title1"
-- 滑动区域标题2
local scroll_title_2_label_path = "ImgBg/LayoutGroup/TItleNode/TitleLabelContainer/Title2"
-- 滑动区域标题3
local scroll_title_3_label_path = "ImgBg/LayoutGroup/TItleNode/TitleLabelContainer/Title3"
-- 滑动区域标题4
local scroll_title_4_label_path = "ImgBg/LayoutGroup/TItleNode/TitleLabelContainer/Title4"
-- scrollview的view
local scroll_view_viewport_path = "ImgBg/LayoutGroup/ScrollView/View"
-- 领取全部普通奖励按钮
local get_normal_reward_btn_path = "ImgBg/LayoutGroup/btnNode/BtnGetNormalReward"
-- 领取全部普通奖励按钮文字
local get_normal_reward_btn_label_path = "ImgBg/LayoutGroup/btnNode/BtnGetNormalReward/NormalBtnLabel"
-- 领取全部高级奖励按钮
local get_advance_reward_btn_path = "ImgBg/LayoutGroup/btnNode/BtnGetAdvanceReward"
-- 领取全部高级奖励按钮文字
local get_advance_reward_btn_label_path = "ImgBg/LayoutGroup/btnNode/BtnGetAdvanceReward/AdvanceBtnLabel"
local layout_group_path = "ImgBg/LayoutGroup"

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:SetStaticLocalText()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function OnEnable(self)
    base.OnEnable(self)
    self:TryShowPackage()
    self:CheckBtnState()
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.layout_group.transform)

    self:OnPanelRefresh()

    --要跳转到目前可以领取普通奖励的第一个cell
    local jumpToIndex = 0
    for k,v in ipairs(self.datalist) do
        if v.normalState == 0 then
            jumpToIndex = k
            break
        end
    end
    
    if jumpToIndex > 0 then
        self.scroll_view:StopMovement()
        self.scroll_view:ScrollToCell(jumpToIndex, 1000)
    end
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
    self:AddUIListener(EventId.GetALVSDonateArmyActivityInfo, self.OnPanelRefresh)
    self:AddUIListener(EventId.ReceiveALVSDonateArmyStageReward, self.CheckBtnState)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.OnBuyPackageSucc)
    self:RemoveUIListener(EventId.GetALVSDonateArmyActivityInfo, self.OnPanelRefresh)
    self:RemoveUIListener(EventId.ReceiveALVSDonateArmyStageReward, self.CheckBtnState)
    base.OnRemoveListener(self)
end

local function ComponentDefine(self)
    -- 页面标题
    self.view_title_label = self:AddComponent(UIText, view_title_label_path)
    -- 页面关闭按钮
    self.view_close_btn = self:AddComponent(UIButton, view_close_btn_path);
    self.view_close_btn:SetOnClick(function() 
        self.ctrl:CloseSelf()
    end)
    -- 礼包节点
    self.gift_pack_container = self:AddComponent(UIBaseContainer, gift_pack_container_path)
    -- 礼包名字
    self.gift_pack_name_label = self:AddComponent(UIText, gift_pack_name_label_path)
    -- 礼包描述
    self.gift_pack_des_label = self:AddComponent(UIText, gift_pack_des_label_path)
    -- 礼包购买按钮
    self.gift_pack_buy_btn = self:AddComponent(UIButton, gift_pack_buy_btn_path)
    self.gift_pack_buy_btn:SetOnClick(function()
        if self.packageInfo then
            self.ctrl:BuyGift(self.packageInfo)
        end
    end)
    -- 礼包购买按钮文字
    self.gift_pack_buy_btn_label = self:AddComponent(UIText, gift_pack_buy_btn_label_path)
    -- 礼包购买奖励点数节点
    self.gift_pack_buy_point = self:AddComponent(UIGiftPackagePoint, gift_pack_buy_point_path)
    -- 滑动节点
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index) 
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.scroll_title_1 = self:AddComponent(UIText, scroll_title_1_label_path)
    self.scroll_title_2 = self:AddComponent(UIText, scroll_title_2_label_path)
    self.scroll_title_3 = self:AddComponent(UIText, scroll_title_3_label_path)
    self.scroll_title_4 = self:AddComponent(UIText, scroll_title_4_label_path)
    self.scroll_view_viewport = self:AddComponent(UIBaseContainer, scroll_view_viewport_path);
    -- 奖励列表数据
    -- self.timer = TimerManager:GetInstance():GetTimer(0.1, self.ReloadScrollview,self, true,false,false)
	-- self.timer:Start()

    self.layout_group = self:AddComponent(UIBaseContainer, layout_group_path)

    self.get_normal_reward_btn = self:AddComponent(UIButton, get_normal_reward_btn_path)
    self.get_normal_reward_btn:SetOnClick(function() 
        self:OnGetAllianceNormalRewardClick()
    end)
    self.get_normal_reward_btn_label = self:AddComponent(UIText, get_normal_reward_btn_label_path)
    self.get_normal_reward_btn_label:SetLocalText(310104)
    self.get_advance_reward_btn = self:AddComponent(UIButton, get_advance_reward_btn_path)
    self.get_advance_reward_btn:SetOnClick(function()
        self:OnGetAllAdvanceRewardClick()
    end)
    self.get_advance_reward_btn_label = self:AddComponent(UIText, get_advance_reward_btn_label_path)
    self.get_advance_reward_btn_label:SetLocalText(372792)

    self.datalist = self.ctrl:GetRewardList()
end

local function ComponentDestroy(self)
    -- self.timer:Stop()
    -- self.timer = nil
    self.view_title_label = nil
    self.view_close_btn = nil
    self.gift_pack_container = nil
    self.gift_pack_name_label = nil
    self.gift_pack_des_label = nil
    self.gift_pack_buy_btn = nil
    self.gift_pack_buy_btn_label = nil
    self.gift_pack_buy_point = nil
    self.scroll_view = nil
    self.scroll_title_1 = nil
    self.scroll_title_2 = nil
    self.scroll_title_3 = nil
    self.scroll_title_4 = nil
    self.scroll_view_viewport = nil
    self.get_normal_reward_btn = nil
    self.get_normal_reward_btn_label = nil
    self.get_advance_reward_btn = nil
    self.get_advance_reward_btn_label = nil
    self.layout_group = nil
end

local function SetStaticLocalText(self)
    self.view_title_label:SetLocalText(372781)
    self.scroll_title_1:SetLocalText(372791)
    self.scroll_title_2:SetLocalText(372790)
    self.scroll_title_3:SetLocalText(320465)
    self.scroll_title_4:SetLocalText(200527)
end

local function OnItemMoveIn(self, itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.scroll_view:AddComponent(UIALVSDonateSoldierRewardPanelCell, itemObj)
    cell:SetData(self.datalist[index])
end

local function OnItemMoveOut(self, itemObj, index)
    self.scroll_view:RemoveComponent(itemObj.name, UIALVSDonateSoldierRewardPanelCell)
end

local function ClearScrollview(self)
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(UIALVSDonateSoldierRewardPanelCell)
end

local function OnPanelRefresh(self)
    --为了防止数据出问题 这里加个刷新界面
    self.datalist = self.ctrl:GetRewardList()
    self:ReloadScrollview()
    self:CheckBtnState()
end

-- 检查按钮的置灰状态
local function CheckBtnState(self)
    local allNormalRewardStage = DataCenter.ActivityALVSDonateSoldierManager:GetAllCanRecieveNormalReward()
    local idList = {}
    for k,v in ipairs(allNormalRewardStage) do
        table.insert(idList, v.id)
    end

    if #idList == 0 then
        -- 没有可领的普通奖励
        UIGray.SetGray(self.get_normal_reward_btn.transform, true,true)
    else
        UIGray.SetGray(self.get_normal_reward_btn.transform, false,true)
    end

    local allAdvanceRewardStage = DataCenter.ActivityALVSDonateSoldierManager:GetAllCanRecieveAdvanceReward()
    idList = {}
    for k,v in ipairs(allAdvanceRewardStage) do
        table.insert(idList, v.id)
    end
    if #idList == 0 then
        -- 没有可领的普通奖励
        UIGray.SetGray(self.get_advance_reward_btn.transform, true,true)
    else
        UIGray.SetGray(self.get_advance_reward_btn.transform, false,true)
    end
end

local function ReloadScrollview(self)
    self:ClearScrollview()
    if #self.datalist > 0 then
        self.scroll_view:SetTotalCount(#self.datalist)
        self.scroll_view:RefillCells()
    end
end

-- 领取所有普通奖励
local function OnGetAllianceNormalRewardClick(self)
    local allRewardStage = DataCenter.ActivityALVSDonateSoldierManager:GetAllCanRecieveNormalReward()
    local idList = {}
    for k,v in ipairs(allRewardStage) do
        table.insert(idList, v.id)
    end

    if #idList > 0 then
        --有可领取的普通奖励才领
        DataCenter.ActivityALVSDonateSoldierManager:OnReceiveStageReward(1, idList)
    end
end

--领取所有进阶奖励（实际上是打开一个面板）
local function OnGetAllAdvanceRewardClick(self)
    local allRewardStage = DataCenter.ActivityALVSDonateSoldierManager:GetAllCanRecieveAdvanceReward()
    
    if #allRewardStage > 0 then
        UIManager.Instance:OpenWindow(UIWindowNames.UIALVSDonateSoldierOpenReward, {anim = true}, {allRewardStage, true})
    end
end

local function OnBuyPackageSucc(self)
    self:TryShowPackage()
    self:ReloadScrollview()
end

local function TryShowPackage(self)
    self.packageInfo = self.ctrl:GetQuickPackageInfo()
    if self.packageInfo then
        self.gift_pack_container:SetActive(true)
        self.gift_pack_name_label:SetLocalText(self.packageInfo:getName())
        self.gift_pack_des_label:SetText(self.packageInfo:getDescText())
        local price = DataCenter.PayManager:GetDollarText(self.packageInfo:getPrice(), self.packageInfo:getProductID())
        self.gift_pack_buy_btn_label:SetText(price)
        --积分
        self.gift_pack_buy_point:RefreshPoint(self.packageInfo)
    else
        self.gift_pack_container:SetActive(false)
    end
end

UIALVSDonateSoldierRewardView.OnCreate = OnCreate
UIALVSDonateSoldierRewardView.OnDestroy = OnDestroy
UIALVSDonateSoldierRewardView.OnEnable = OnEnable
UIALVSDonateSoldierRewardView.OnDisable = OnDisable
UIALVSDonateSoldierRewardView.OnRemoveListener = OnRemoveListener
UIALVSDonateSoldierRewardView.OnAddListener = OnAddListener
UIALVSDonateSoldierRewardView.ComponentDefine = ComponentDefine
UIALVSDonateSoldierRewardView.ComponentDestroy = ComponentDestroy
UIALVSDonateSoldierRewardView.SetStaticLocalText = SetStaticLocalText
UIALVSDonateSoldierRewardView.OnItemMoveIn = OnItemMoveIn
UIALVSDonateSoldierRewardView.OnItemMoveOut = OnItemMoveOut
UIALVSDonateSoldierRewardView.ReloadScrollview = ReloadScrollview
UIALVSDonateSoldierRewardView.ClearScrollview = ClearScrollview
UIALVSDonateSoldierRewardView.OnGetAllAdvanceRewardClick = OnGetAllAdvanceRewardClick
UIALVSDonateSoldierRewardView.OnGetAllianceNormalRewardClick = OnGetAllianceNormalRewardClick
UIALVSDonateSoldierRewardView.OnBuyPackageSucc = OnBuyPackageSucc
UIALVSDonateSoldierRewardView.TryShowPackage = TryShowPackage
UIALVSDonateSoldierRewardView.OnPanelRefresh = OnPanelRefresh
UIALVSDonateSoldierRewardView.CheckBtnState = CheckBtnState

return UIALVSDonateSoldierRewardView

