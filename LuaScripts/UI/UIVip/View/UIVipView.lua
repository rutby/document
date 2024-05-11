--- Created by shimin
--- DateTime: 2024/1/11 10:25
--- Vip界面
local UIVipView = BaseClass("UIVipView",UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local UIVipCell = require "UI.UIVip.Component.UIVipCell"
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"

local close_btn_path = "UICommonFullTop/CloseBtn"
local title_text_path = "UICommonFullTop/imgTitle/Common_img_title/titleText"
local vip_img_path = "root/Ani/top_bg/vipImg"
local vip_level_text_path = "root/Ani/top_bg/vip_level_text"
local info_btn_path = "root/Ani/top_bg/info_btn"
local exp_slider_path = "root/Ani/top_bg/exp_slider"
local exp_slider_text_path = "root/Ani/top_bg/exp_slider/exp_slider_text"
local add_exp_btn_path = "root/Ani/top_bg/add_exp_btn"
local cur_level_text_path = "root/Ani/top_bg/cur_level_text"
local cur_day_des_text_path = "root/Ani/top_bg/cur_day_des_text"
local shop_btn_path = "root/Ani/top_bg/shop_btn"
local shop_btn_text_path = "root/Ani/top_bg/shop_btn/shop_btn_text"
local box_btn_path = "root/Ani/top_bg/box_btn"
local box_img_path = "root/Ani/top_bg/box_btn/box_img"
local box_btn_red_path = "root/Ani/top_bg/box_btn/box_btn_red"
local box_btn_text_path = "root/Ani/top_bg/box_btn/box_btn_text"
local left_btn_path = "root/Ani/left_btn"
local left_btn_red_path = "root/Ani/left_btn/left_btn_red"
local right_btn_path = "root/Ani/right_btn"
local right_btn_red_path = "root/Ani/right_btn/right_btn_red"
local privilege_text_path = "root/Ani/middle_go/privilege_text"
local privilege_scroll_view_path = "root/Ani/middle_go/privilege_scroll_view"
local free_btn_path = "root/Ani/bottom_go/free_bg/free_btn"
local free_btn_text_path = "root/Ani/bottom_go/free_bg/free_btn/free_btn_text"
local free_text_path = "root/Ani/bottom_go/free_bg/free_text"
local free_des_text_path = "root/Ani/bottom_go/free_bg/free_des_text"
local free_scroll_view_path = "root/Ani/bottom_go/free_bg/free_scroll_view"
local gift_btn_path = "root/Ani/bottom_go/gift_bg/gift_btn"
local gift_btn_text_path = "root/Ani/bottom_go/gift_bg/gift_btn/gift_btn_text"
local sold_go_path = "root/Ani/bottom_go/gift_bg/sold_go"
local sold_text_path = "root/Ani/bottom_go/gift_bg/sold_go/sold_text"
local gift_gold_text_path = "root/Ani/bottom_go/gift_bg/gift_gold_bg/gift_gold_text"
local gift_gold_go_path = "root/Ani/bottom_go/gift_bg/gift_gold_bg"
local gift_text_path = "root/Ani/bottom_go/gift_bg/gift_text"
local gift_des_text_path = "root/Ani/bottom_go/gift_bg/gift_des_text"
local discount_text_path = "root/Ani/bottom_go/gift_bg/discount_bg/discount_text"
local gift_scroll_view_path = "root/Ani/bottom_go/gift_bg/gift_scroll_view"
local gift_go_path = "root/Ani/bottom_go/gift_bg"
local get_btn_path = "root/getBtn"
local get_btn_txt_path = "root/getBtn/btnText"
local btn_red_path = "root/getBtn/btn_red"
function UIVipView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIVipView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.vip_img = self:AddComponent(UIImage,vip_img_path)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.vip_level_text = self:AddComponent(UITextMeshProUGUIEx, vip_level_text_path)
    self.info_btn = self:AddComponent(UIButton, info_btn_path)
    self.info_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnInfoBtnClick()
    end)
    self.exp_slider = self:AddComponent(UISlider, exp_slider_path)
    self.exp_slider_text = self:AddComponent(UITextMeshProUGUIEx, exp_slider_text_path)
    self.add_exp_btn = self:AddComponent(UIButton, add_exp_btn_path)
    self.add_exp_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnAddExpBtnClick()
    end)
    self.cur_level_text = self:AddComponent(UITextMeshProUGUIEx, cur_level_text_path)
    self.cur_day_des_text = self:AddComponent(UITextMeshProUGUIEx, cur_day_des_text_path)
    self.shop_btn = self:AddComponent(UIButton, shop_btn_path)
    self.shop_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnShopBtnClick()
    end)
    self.shop_btn_text = self:AddComponent(UITextMeshProUGUIEx, shop_btn_text_path)
    self.get_btn = self:AddComponent(UIButton, get_btn_path)
    self.get_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGetBtnClick()
    end)
    self.get_btn_txt = self:AddComponent(UITextMeshProUGUIEx, get_btn_txt_path)
    self.btn_red = self:AddComponent(UIBaseContainer,btn_red_path)
    self.box_btn = self:AddComponent(UIButton, box_btn_path)
    self.box_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBoxBtnClick()
    end)
    self.box_btn_text = self:AddComponent(UITextMeshProUGUIEx, box_btn_text_path)
    self.box_img = self:AddComponent(UIImage, box_img_path)
    self.left_btn = self:AddComponent(UIButton, left_btn_path)
    self.left_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnLeftBtnClick()
    end)
    self.left_btn_red = self:AddComponent(UIBaseContainer, left_btn_red_path)
    self.right_btn = self:AddComponent(UIButton, right_btn_path)
    self.right_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnRightBtnClick()
    end)
    self.right_btn_red = self:AddComponent(UIBaseContainer, right_btn_red_path)
    self.privilege_text = self:AddComponent(UITextMeshProUGUIEx, privilege_text_path)
    self.privilege_scroll_view = self:AddComponent(UIScrollView, privilege_scroll_view_path)
    self.privilege_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnPrivilegeCellMoveIn(itemObj, index)
    end)
    self.privilege_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnPrivilegeCellMoveOut(itemObj, index)
    end)
    self.free_btn = self:AddComponent(UIButton, free_btn_path)
    self.free_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnFreeBtnClick()
    end)
    self.free_btn_text = self:AddComponent(UITextMeshProUGUIEx, free_btn_text_path)
    self.free_text = self:AddComponent(UITextMeshProUGUIEx, free_text_path)
    self.free_scroll_view = self:AddComponent(UIScrollView, free_scroll_view_path)
    self.free_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnFreeCellMoveIn(itemObj, index)
    end)
    self.free_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnFreeCellMoveOut(itemObj, index)
    end)
    self.gift_btn = self:AddComponent(UIButton, gift_btn_path)
    self.gift_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGiftBtnClick()
    end)
    self.gift_btn_text = self:AddComponent(UITextMeshProUGUIEx, gift_btn_text_path)
    self.sold_go = self:AddComponent(UIBaseContainer, sold_go_path)
    self.sold_text = self:AddComponent(UITextMeshProUGUIEx, sold_text_path)
    self.gift_gold_text = self:AddComponent(UITextMeshProUGUIEx, gift_gold_text_path)
    self.gift_text = self:AddComponent(UITextMeshProUGUIEx, gift_text_path)
    self.discount_text = self:AddComponent(UITextMeshProUGUIEx, discount_text_path)
    self.gift_scroll_view = self:AddComponent(UIScrollView, gift_scroll_view_path)
    self.gift_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnGiftCellMoveIn(itemObj, index)
    end)
    self.gift_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnGiftCellMoveOut(itemObj, index)
    end)
    self.box_btn_red = self:AddComponent(UIBaseContainer, box_btn_red_path)
    self.gift_go = self:AddComponent(UIBaseContainer, gift_go_path)
    self.gift_des_text = self:AddComponent(UITextMeshProUGUIEx, gift_des_text_path)
    self.gift_gold_go = self:AddComponent(UIBaseContainer, gift_gold_go_path)
    self.free_des_text = self:AddComponent(UITextMeshProUGUIEx, free_des_text_path)
end

function UIVipView:ComponentDestroy()
end

function UIVipView:DataDefine()
    self.vipInfo = {}
    self.privilege_list = {}
    self.selectVipLevel = 0
    self.timer_action = function(temp)
        self:RefreshTime()
    end
    self.free_list = {}
    self.gift_list = {}
    self.isClick = false
    self.next_timer_callback = function() 
        self:NextFrameTimeCallback()
    end
    self.lastVipLevel = 0
end

function UIVipView:DataDestroy()
    self:DeleteNextFrameTimer()
    self:DeleteTimer()
end

function UIVipView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIVipView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.VipDataRefresh, self.VipDataRefreshSignal)
    self:AddUIListener(EventId.VipRefreshFree, self.VipRefreshFreeSignal)
    self:AddUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackDataSignal)
end

function UIVipView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.VipDataRefresh,self.VipDataRefreshSignal)
    self:RemoveUIListener(EventId.VipRefreshFree,self.VipRefreshFreeSignal)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackDataSignal)
end

function UIVipView:OnEnable()
    base.OnEnable(self)
end

function UIVipView:OnDisable()
    base.OnDisable(self)
end

function UIVipView:ReInit()
    local level = toInt(self:GetUserData())
    self.left_btn_red:SetActive(false)
    self.right_btn_red:SetActive(false)
    self.title_text:SetLocalText(GameDialogDefine.REASON_VIP)
    self.shop_btn_text:SetLocalText(GameDialogDefine.SHOP)
    DataCenter.VIPManager:GetAllVipData()--初始化表
    self.vipInfo = DataCenter.VIPManager:GetVipData()
    self.lastVipLevel = self.vipInfo.level
    self.selectVipLevel = self.vipInfo.level
    if level>0 then
        self.selectVipLevel = level
    end
    self:Refresh()
    self:AddTimer()
end

--vip信息更新
function UIVipView:Refresh()
    self.isClick = false
    self.endTime = 0
    self.vipInfo = DataCenter.VIPManager:GetVipData()
    if self.vipInfo == nil then
        return
    end
    self.endTime = self.vipInfo.endTime
    local curTime = UITimeManager:GetInstance():GetServerTime()
    if curTime>=self.endTime then
        self.endTime = 0
    end
    if self.lastVipLevel ~= self.vipInfo.level then
        self.lastVipLevel = self.vipInfo.level
        self.selectVipLevel = self.vipInfo.level
    end

    local nextVipInfo = DataCenter.VIPManager:GetNextVipData()
    if nextVipInfo ~= nil then
        self.exp_slider:SetValue(self.vipInfo.score / nextVipInfo.point)
        self.exp_slider_text:SetLocalText(GameDialogDefine.SPLIT, string.GetFormattedSeperatorNum(self.vipInfo.score), 
                string.GetFormattedSeperatorNum(nextVipInfo.point))
    else
        self.exp_slider:SetValue(1)
        self.exp_slider_text:SetLocalText(GameDialogDefine.MAX)
    end
    self.cur_level_text:SetLocalText(GameDialogDefine.CUR_LEVEL_VIP_WITH, self.vipInfo.level)
    self.vip_level_text:SetText(Localization:GetString(GameDialogDefine.REASON_VIP) .. self.vipInfo.level)
    if self.endTime>0 then
        self.vip_img:LoadSprite("Assets/Main/Sprites/UI/Common/New/UIPlayerInfo_icon_vip.png")
        self.btn_red:SetActive(false)
        self:RefreshTime()
        
    else
        self.vip_img:LoadSprite("Assets/Main/Sprites/UI/Common/New/UIPlayerInfo_icon_vip1.png")
        local items = DataCenter.ItemData:GetItemsByType(GOODS_TYPE.GOODS_TYPE_202)
        self.btn_red:SetActive(items~=nil and table.count(items)>0)
        self.get_btn_txt:SetLocalText(120204)
    end
    if DataCenter.VIPManager:CanGetDailyPoint() then
        self.cur_day_des_text:SetLocalText(GameDialogDefine.CONTINUE_LOGIN_TODAY_REWARD_VIP_WITH, 
                self.vipInfo:GetLoginDays(), DataCenter.VIPManager:TodayPoint())
        self.box_btn_red:SetActive(true)
        self.box_btn_text:SetLocalText(GameDialogDefine.GET_REWARD)
        self.box_img:LoadSprite(string.format(LoadPath.UIVipPath, "vip_icon_box1"))
        self.box_btn:SetInteractable(true)
    else
        self.cur_day_des_text:SetLocalText(GameDialogDefine.CONTINUE_LOGIN_TOMORROW_REWARD_VIP_WITH, 
                self.vipInfo:GetLoginDays(), DataCenter.VIPManager:TomorrowPoint())
        self.box_btn_red:SetActive(false)
        self:RefreshTime()
        self.box_img:LoadSprite(string.format(LoadPath.UIVipPath, "vip_icon_box2"))
        self.box_btn:SetInteractable(false)
    end
    
    self:RefreshCurPrivilege()
end

function UIVipView:RefreshCurPrivilege()
    --当前页签
    local str = Localization:GetString("320225",self.selectVipLevel)
    if self.endTime<=0 then
        str = str.."("..Localization:GetString("130261")..")"
    end
    self.privilege_text:SetText(str)
    self:ShowPrivilegeCells()
    self.left_btn:SetActive(self.selectVipLevel ~= 0)
    self.right_btn:SetActive(self.selectVipLevel ~= DataCenter.VIPTemplateManager.maxLevel)
    self:RefreshFreeGo()
    self:RefreshGiftGo()
end

function UIVipView:ShowPrivilegeCells()
    self:AddNextFrameTimer()
end

function UIVipView:RefreshPrivilegeCells()
    self:ClearPrivilegeScroll()
    self:GetPrivilegeDataList()
    local count = table.count(self.privilege_list)
    if count > 0 then
        self.privilege_scroll_view:SetTotalCount(count)
        self.privilege_scroll_view:RefillCells()
    end
end


function UIVipView:ClearPrivilegeScroll()
    self.privilege_scroll_view:ClearCells()--清循环列表数据
    self.privilege_scroll_view:RemoveComponents(UIVipCell)--清循环列表gameObject
end

function UIVipView:OnPrivilegeCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.privilege_scroll_view:AddComponent(UIVipCell, itemObj)
    item:ReInit(self.privilege_list[index])
end

function UIVipView:OnPrivilegeCellMoveOut(itemObj, index)
    self.privilege_scroll_view:RemoveComponent(itemObj.name, UIVipCell)
end

function UIVipView:GetPrivilegeDataList()
    self.privilege_list = {}
    local template = DataCenter.VIPTemplateManager:GetTemplate(self.selectVipLevel)
    if template ~= nil then
        if template.effect[1] ~= nil then
            for k,v in ipairs(template.effect) do
                table.insert(self.privilege_list, v)
            end
        end
    end
end

function UIVipView:AddNextFrameTimer()
    if self.next_timer == nil then
        self.next_timer = TimerManager:GetInstance():GetTimer(NextFrameTime, self.next_timer_callback,self, true, false, false)
    end
    self.next_timer:Start()
end

function UIVipView:DeleteNextFrameTimer()
    if self.next_timer ~= nil then
        self.next_timer:Stop()
        self.next_timer = nil
    end
end

function UIVipView:NextFrameTimeCallback()
    self:DeleteNextFrameTimer()
    self:RefreshPrivilegeCells()
end

function UIVipView:DeleteTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIVipView:AddTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end
    self.timer:Start()
end

function UIVipView:RefreshTime()
    if self.endTime>0 then
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local deltaTime = self.endTime-curTime
        if deltaTime<=0 then
            self.endTime = 0
            self:Refresh()
        else
            self.get_btn_txt:SetText(UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
        end
    end
    local resTime = UITimeManager:GetInstance():GetResSecondsTo24()
    if resTime == 0 then
        DataCenter.VIPManager:RequestLatestVipInfo()
        self:DeleteTimer()
    else
        if not DataCenter.VIPManager:CanGetDailyPoint() then
            self.box_btn_text:SetText(UITimeManager:GetInstance():SecondToFmtString(resTime))
        end
        if not DataCenter.VIPManager:FreeGoodCanGet(self.vipInfo.level) and self.vipInfo.level == self.selectVipLevel then
            self.free_des_text:SetText(UITimeManager:GetInstance():SecondToFmtString(resTime))
        end
    end
end

function UIVipView:RefreshFreeGo()
    if self.vipInfo.level ~= self.selectVipLevel then
        self.free_des_text:SetActive(true)
        self.free_des_text:SetText(Localization:GetString(GameDialogDefine.NEED_VIP_UNLOCK_WITH, self.selectVipLevel))
        self.free_btn:SetActive(false)
        self.free_btn_text:SetLocalText(GameDialogDefine.GET_REWARD)
        self.free_text:SetLocalText(GameDialogDefine.VIP_CAN_GIFT_WITH, self.selectVipLevel)
    elseif DataCenter.VIPManager:FreeGoodCanGet(self.vipInfo.level) then
        --可以领取
        self.free_des_text:SetActive(false)
        self.free_btn:SetActive(true)
        if self.endTime~=nil and self.endTime>0 then
            UIGray.SetGray(self.free_btn.transform, false, true)
            self.free_btn_text:SetLocalText(GameDialogDefine.GET_REWARD)
        else
            UIGray.SetGray(self.free_btn.transform, true, false)
            self.free_btn_text:SetLocalText(120050)
        end
        self.free_text:SetLocalText(GameDialogDefine.DAILY_FREE)
    else
        self.free_des_text:SetActive(true)
        self.free_btn:SetActive(false)
        self.free_btn_text:SetLocalText(GameDialogDefine.GET_REWARD)
        self.free_text:SetLocalText(GameDialogDefine.DAILY_FREE)
        self:RefreshTime()
    end
    self:ShowFreeCells()
end

function UIVipView:ShowFreeCells()
    self:ClearFreeScroll()
    self:GetFreeDataList()
    local count = table.count(self.free_list)
    if count > 0 then
        self.free_scroll_view:SetTotalCount(count)
        self.free_scroll_view:RefillCells()
    end
end

function UIVipView:ClearFreeScroll()
    self.free_scroll_view:ClearCells()--清循环列表数据
    self.free_scroll_view:RemoveComponents(UICommonItem)--清循环列表gameObject
end

function UIVipView:OnFreeCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.free_scroll_view:AddComponent(UICommonItem, itemObj)
    item:ReInit(self.free_list[index])
end

function UIVipView:OnFreeCellMoveOut(itemObj, index)
    self.free_scroll_view:RemoveComponent(itemObj.name, UICommonItem)
end

function UIVipView:GetFreeDataList()
    self.free_list = self.vipInfo.boxRewardArr[self.selectVipLevel]
end

function UIVipView:RefreshGiftGo()
    local isShow = false
    local giftId = nil
    local template = DataCenter.VIPTemplateManager:GetTemplate(self.selectVipLevel)
    if template ~= nil then
        giftId = template.reward2
        if giftId ~= nil and giftId ~= "root/Ani/" then
            local packs = GiftPackManager.get(giftId)
            if packs ~= nil then
                isShow = true
                self.gift_list = packs:GetRewardList(true) or {}
                self.discount_text:SetText(packs:getPercent() .. "%")
            end
        end
    end

    if isShow then
        self.gift_go:SetActive(true)
        self.gift_text:SetLocalText(GameDialogDefine.VIP_GIFT_WITH, self.selectVipLevel)
        self.gift_des_text:SetLocalText(GameDialogDefine.GIFT_LIMIT_BUY_WITH, 1)
        self.gift_btn_text:SetText(GiftPackageData.getPackPrice(giftId))
        self:ShowGiftCells()
        --付费礼包状态
        local state = DataCenter.VIPManager:AnalyzePayGoodState(self.selectVipLevel, giftId)
        if state == VipPayGoodState.Lock then
            --Vip等级不够
            self.sold_go:SetActive(false)
            self.gift_btn:SetActive(true)
            UIGray.SetGray(self.gift_btn.transform, true, false)
            self.gift_gold_go:SetActive(false)
        elseif state == VipPayGoodState.CanBuy then
            --能购买
            self.sold_go:SetActive(false)
            self.gift_btn:SetActive(true)
            UIGray.SetGray(self.gift_btn.transform, false, true)
            self.gift_gold_go:SetActive(false)
        elseif state == VipPayGoodState.HasGet or VipPayGoodState.CanGet then
            --已经购买
            self.sold_go:SetActive(true)
            self.sold_text:SetLocalText(GameDialogDefine.SOLD_OUT)
            self.gift_btn:SetActive(false)
            self.gift_gold_go:SetActive(false)
        end
    else
        self.gift_go:SetActive(false)
    end
end

function UIVipView:ShowGiftCells()
    self:ClearGiftScroll()
    local count = table.count(self.gift_list)
    if count > 0 then
        self.gift_scroll_view:SetTotalCount(count)
        self.gift_scroll_view:RefillCells()
    end
end

function UIVipView:ClearGiftScroll()
    self.gift_scroll_view:ClearCells()--清循环列表数据
    self.gift_scroll_view:RemoveComponents(UICommonItem)--清循环列表gameObject
end

function UIVipView:OnGiftCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.gift_scroll_view:AddComponent(UICommonItem, itemObj)
    item:ReInit(self.gift_list[index])
end

function UIVipView:OnGiftCellMoveOut(itemObj, index)
    self.gift_scroll_view:RemoveComponent(itemObj.name, UICommonItem)
end

function UIVipView:OnInfoBtnClick()
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.info_btn.transform.position - Vector3.New(0, 40, 0) * scaleFactor
    local param = UIHeroTipView.Param.New()
    param.content = Localization:GetString(GameDialogDefine.VIP_INFO_DES)
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 350
    param.pivot = 0.1
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

function UIVipView:OnAddExpBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipPurchase, NormalBlurPanelAnim)
end

function UIVipView:OnShopBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UICommonShop, NormalPanelAnim, CommonShopType.Vip)
end

function UIVipView:OnBoxBtnClick()
    if not self.isClick then
        self.isClick = true
        DataCenter.VIPManager:RequestVipGetDailyPoint()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIVIPRewardPopUp, NormalBlurPanelAnim)
    end
end

function UIVipView:OnLeftBtnClick()
    self.selectVipLevel = self.selectVipLevel - 1
    self:RefreshCurPrivilege()
end

function UIVipView:OnRightBtnClick()
    self.selectVipLevel = self.selectVipLevel + 1
    self:RefreshCurPrivilege()
end

function UIVipView:OnFreeBtnClick()
    if not self.isClick then
        self.isClick = true
        DataCenter.VIPManager:ReceiveFreeReward()
    end
end

function UIVipView:OnGiftBtnClick()
    if not self.isClick then
        local template = DataCenter.VIPTemplateManager:GetTemplate(self.selectVipLevel)
        if template ~= nil then
            local giftId = template.reward2
            if giftId ~= nil and giftId ~= "root/Ani/" then
                local packs = GiftPackManager.get(giftId)
                if packs ~= nil then
                    self.isClick = true
                    DataCenter.PayManager:CallPayment(packs, "GoldExchangeView", "")
                end
            end
        end
    end
end

function UIVipView:VipDataRefreshSignal()
    self.isClick = false
    self:Refresh()
end

function UIVipView:VipRefreshFreeSignal()
    self.isClick = false
    self:RefreshFreeGo()
end

function UIVipView:UpdateGiftPackDataSignal()
    self.isClick = false
    self:RefreshGiftGo()
end

function UIVipView:OnGetBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIVipAddTime, {anim = true,isBlur = true})
end
return UIVipView