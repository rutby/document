--- 获得更多界面
--- Created by shimin.
--- DateTime: 2024/1/17 15:18
local UIResourceLackNewView = BaseClass("UIResourceLackNewView",UIBaseView)
local UIHeroCellSmall = require "UI.UIHero2.Common.UIResourceLackNewView_HeroCellSmall"
local ResourceLackItem = require "UI.UIResourceLackNew.Component.ResourceLackItem"
local UISpeedGiftCell = require "UI.UISpeed.Component.UISpeedGiftCell"
local base = UIBaseView

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local return_btn_path = "UICommonPopUpTitle/panel"
local close_btn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local slider_path = "Root/ImgBg/SliderGo/Common_bg1/Slider"
local slider_txt_path = "Root/ImgBg/SliderGo/Common_bg1/LeftTime"
local slider_icon_path = "Root/ImgBg/SliderGo/iconBg/BuildIcon"
local icon_bg_path = "Root/ImgBg/SliderGo/iconBg"
local hero_cell_small_path = "Root/ImgBg/SliderGo/UIHeroCellSmall"
local restips_txt_path = "Root/ImgBg/Txt_ResTips"
local icon_text_path = "Root/ImgBg/SliderGo/Rect_Desc/Name_Txt"
local icon_desc_text_path = "Root/ImgBg/SliderGo/Rect_Desc/Desc_Txt"
local icon_desc_num_text_path = "Root/ImgBg/SliderGo/Rect_Desc/Desc_Txt/Desc_Num"
local slider_go_path = "Root/ImgBg/SliderGo/Common_bg1"
local slider_item_go_path = "Root/ImgBg/SliderGo/UICommonItem"
local slider_item_quality_path = "Root/ImgBg/SliderGo/UICommonItem/clickBtn/ImgQuality"
local slider_item_icon_path = "Root/ImgBg/SliderGo/UICommonItem/clickBtn/ItemIcon"
local scroll_view_path = "Root/ImgBg/ScrollView"
local blue_btn_path = "Root/ImgBg/BigBtnBlue"
local blue_btn_text_path = "Root/ImgBg/BigBtnBlue/btnText"
local gift_cell_path = "Root/ImgBg/gift_bg"

local DelayAnimTime = 0.4
local AnimTime = 0.3

local SpeedGiftType =
{
    Normal = 1,
    Build = 2,
    Science = 3,
    Solider = 4,
    Hospital = 5,
}

--创建
function UIResourceLackNewView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
function UIResourceLackNewView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIResourceLackNewView:ComponentDefine()
    self.title = self:AddComponent(UITextMeshProUGUIEx,title_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self:DoClosePanel()
    end)
    self.return_btn = self:AddComponent(UIButton, return_btn_path)
    self.return_btn:SetOnClick(function()
        self:DoClosePanel()
    end)
    self.slider = self:AddComponent(UISlider, slider_path)
    self.slider_icon = self:AddComponent(UIImage, slider_icon_path)
    self.heroCellSmall = self:AddComponent(UIHeroCellSmall, hero_cell_small_path)
    self.slider_txt = self:AddComponent(UITextMeshProUGUIEx, slider_txt_path)
    self.restips_txt = self:AddComponent(UITextMeshProUGUIEx,restips_txt_path)
    self.icon_bg = self:AddComponent(UIImage, icon_bg_path)
    self.icon_text = self:AddComponent(UITextMeshProUGUIEx, icon_text_path)
    self.slider_go = self:AddComponent(UIBaseContainer, slider_go_path)
    self.icon_desc_text = self:AddComponent(UITextMeshProUGUIEx, icon_desc_text_path)
    self.icon_desc_num_text = self:AddComponent(UITextMeshProUGUIEx, icon_desc_num_text_path)
    self.slider_item_go = self:AddComponent(UIBaseContainer, slider_item_go_path)
    self.slider_item_quality = self:AddComponent(UIImage, slider_item_quality_path)
    self.slider_item_icon = self:AddComponent(UIImage, slider_item_icon_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.blue_btn = self:AddComponent(UIButton, blue_btn_path)
    self.blue_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBlueBtnClick()
    end)
    self.blue_btn_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_text_path)

    self.gift_cell = self:AddComponent(UISpeedGiftCell, gift_cell_path)
end

function UIResourceLackNewView:ComponentDestroy()
end

function UIResourceLackNewView:OnEnable()
    base.OnEnable(self)
end

function UIResourceLackNewView:OnDisable()
    base.OnDisable(self)
end

function UIResourceLackNewView:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:AddUIListener(EventId.RefreshItems, self.UseItemSuccessHandle)
    self:AddUIListener(EventId.BuyItemAndRes, self.UseItemSuccessHandle)
    self:AddUIListener(EventId.FormationStaminaUpdate, self.FormationStaminaUpdateSignal)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackDataSignal)
    self:AddUIListener(EventId.RefreshHeroEffectSkill, self.RefreshHeroEffectSkillSignal)
end

function UIResourceLackNewView:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:RemoveUIListener(EventId.RefreshItems, self.UseItemSuccessHandle)
    self:RemoveUIListener(EventId.BuyItemAndRes, self.UseItemSuccessHandle)
    self:RemoveUIListener(EventId.FormationStaminaUpdate, self.FormationStaminaUpdateSignal)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.UpdateGiftPackData, self.UpdateGiftPackDataSignal)
    self:RemoveUIListener(EventId.RefreshHeroEffectSkill, self.RefreshHeroEffectSkillSignal)
end

function UIResourceLackNewView:DataDefine()
    self.close = false
    self.list = {}
    self.cells = {}
    self.next_timer_callback = function()
        self:NextFrameTimeCallback()
    end
    self.lackWayList = {}
    self.lackTabList = {}
    self.speedType = 0
    self.toggleIndex = 1
    self.delay_anim_timer_callback = function()
        self:DelayAnimTimerCallback()
    end
    self.own = 0
    self.needAnim = false
    self.noClosePanel = false
end

function UIResourceLackNewView:DataDestroy()
    self:DeleteNextFrameTimer()
    self:DeleteDelayAnimTimer()
end

function UIResourceLackNewView:ReInit()
    self.lackWayList, self.lackTabList, self.speedType = self:GetUserData()
    self.close = false
    self.restips_txt:SetLocalText(143595)
    self.toggleIndex = 1
    self.own = 0
    self.needAnim = false
    self:Refresh()
    self.title:SetLocalText(129253)
    --一进来就超的，不关闭界面
    self.own = self:GetOwn(self.toggleIndex)
    local targetNum = self.lackTabList[self.toggleIndex].targetNum or 0
    if self.own >= targetNum then
        self.noClosePanel = true
    end
end

function UIResourceLackNewView:Refresh()
    local param = self.lackTabList[self.toggleIndex]
    local way = DataCenter.ResLackManager:CheckResAddWay(param.id, param.targetNum, param.typeNew)
    if way ~= nil then
        self.lackWayList[self.toggleIndex] = way
    end
    
    self.heroCellSmall:SetActive(false)
    self.icon_bg:SetActive(true)
    self.icon_desc_text:SetActive(false)
    local showSlider = true
    local showBtn = false
    local tabParam = self.lackTabList[self.toggleIndex]
    if tabParam.type == ResLackType.Item then
        self.slider_item_go:SetActive(true)
        self.icon_bg:SetActive(false)
        self.slider_item_quality:LoadSprite(DataCenter.RewardManager:GetIconColorByRewardType(RewardType.GOODS, tabParam.id))
        self.slider_item_icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.GOODS, tabParam.id))
        self.icon_text:SetText(DataCenter.RewardManager:GetNameByType(RewardType.GOODS, tabParam.id))
    elseif tabParam.type == ResLackType.Speed then
        local SpeedLackItemId = 200203
        showSlider = false
        self.slider_item_go:SetActive(false)
        self.icon_bg:SetActive(true)
        self.icon_bg:LoadSprite(LackItemDefaultBg)
        self.icon_text:SetText(DataCenter.ItemTemplateManager:GetName(SpeedLackItemId))
        self.slider_icon:LoadSprite("Assets/Main/Sprites/ItemIcons/item200")
        self.icon_desc_text:SetActive(true)
        self.icon_desc_num_text:SetActive(false)
        self.icon_desc_text:SetText(DataCenter.ItemTemplateManager:GetDes(SpeedLackItemId))
    elseif tabParam.type == ResLackType.HeroExp then
        showSlider = false
        self.slider_item_go:SetActive(false)
        self.icon_bg:SetActive(true)
        self.icon_bg:LoadSprite(LackItemDefaultBg)
        self.slider_icon:SetLocalScale(Vector3.New(0.8, 0.8, 0.8))
        self.slider_icon:LoadSprite(DataCenter.RewardManager:GetPicByType(RewardType.HERO_EXP), nil, function()
            self.slider_icon:SetNativeSize()
        end)
        self.icon_text:SetText(DataCenter.RewardManager:GetNameByType(RewardType.HERO_EXP))
        self.icon_desc_text:SetActive(true)
        self.icon_desc_text:SetLocalText(GameDialogDefine.OWN, "")
        self.icon_desc_num_text:SetText(string.GetFormattedSeperatorNum(DataCenter.ItemData:GetHeroExpItemCount()))
    elseif tabParam.typeNew == ResLackType.HeroEquip then
        showSlider = false
        self.slider_item_go:SetActive(false)
        self.icon_bg:SetActive(true)
        self.icon_bg:LoadSprite(LackItemDefaultBg)
        self.slider_icon:LoadSprite(HeroEquipUtil:GetEquipmentIcon(HeroEquipConst.EQUIP_ICON))
        self.icon_text:SetLocalText(GameDialogDefine.HERO_EQUIP40)
        self.icon_desc_text:SetActive(true)
        self.icon_desc_num_text:SetActive(false)
        self.icon_desc_text:SetLocalText(GameDialogDefine.HERO_EQUIP41)
    else
        self.slider_item_go:SetActive(false)
        self.icon_bg:SetActive(true)
        self.slider_icon:SetLocalScale(Vector3.New(0.8, 0.8, 0.8))
        self.slider_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(tabParam.id), nil, function()
            self.slider_icon:SetNativeSize()
        end)
        self.icon_bg:LoadSprite(LackItemDefaultBg)
        self.icon_text:SetText(DataCenter.ResourceManager:GetResourceNameByType(tabParam.id))
        if self:NeedBtnResType(tabParam.id) then
            for k, v in ipairs(self.lackWayList[self.toggleIndex]) do
                if v:GetTips() == ResLackGoToType.ResourceBagUse then
                    showBtn = true
                    break
                end
            end
        end
    end

    if showSlider then
        self.slider_go:SetActive(true)
        self.own = self:GetOwn(self.toggleIndex)
        self:RefreshSliderText(self.own, tabParam.targetNum)
        if self.needAnim then
            self:AddDelayAnimTimer()
        else
            self.slider:SetValue(self.own / tabParam.targetNum)
        end
    else
        self.slider_go:SetActive(false)
    end

    if showBtn then
        self.blue_btn:SetActive(true)
        self.blue_btn_text:SetLocalText(GameDialogDefine.REPLENISH_ALL)
    else
        self.blue_btn:SetActive(false)
    end
    
    if self.lackWayList[self.toggleIndex][1] == nil then
        self.restips_txt:SetActive(true)
    else
        self.restips_txt:SetActive(false)
    end
    
    self:ShowCells()
end

function UIResourceLackNewView:SetPackage()
    if self.speedType == ItemSpdMenu.ItemSpdMenu_City then
        self.packageInfo = self:GetQuickPackageInfo(SpeedGiftType.Build)
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Science then
        self.packageInfo = self:GetQuickPackageInfo(SpeedGiftType.Science)
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Soldier then
        self.packageInfo = self:GetQuickPackageInfo(SpeedGiftType.Solider)
    elseif self.speedType == ItemSpdMenu.ItemSpdMenu_Heal then
        self.packageInfo = self:GetQuickPackageInfo(SpeedGiftType.Hospital)
        if not self.packageInfo then
            self.packageInfo = self:GetQuickPackageInfo(SpeedGiftType.Normal)
        end
    end
    if self.packageInfo then
        self.gift_cell:SetActive(true)
        self.gift_cell:ReInit(self.packageInfo)
    else
        self.gift_cell:SetActive(false)
    end
end

--获得礼包信息
function UIResourceLackNewView:GetQuickPackageInfo(speedType)
    local list = GiftPackageData.GetAddTimePacks(speedType)
    if list ~= nil then
        return list[1]
    end
    return nil
end

function UIResourceLackNewView:UseItemSuccessHandle()
    self:CheckRefresh(true)
    if not self.close then
        self.needAnim = true
        self:Refresh()
    end
end

function UIResourceLackNewView:DoClosePanel()
    self.close = true
    self.ctrl:CloseSelf(true)
end

function UIResourceLackNewView:FormationStaminaUpdateSignal()
    self:CheckRefresh(true)
    if not self.close then
        self.needAnim = true
        self:Refresh()
    end
end

function UIResourceLackNewView:RefreshSliderText(own, need)
    if own >= need then
        self.slider_txt:SetText(string.GetFormattedSeperatorNum(own) .."/"..string.GetFormattedSeperatorNum(need))
    else
        self.slider_txt:SetText(string.format(TextColorStr, TextColorRed, string.GetFormattedSeperatorNum(own))
                .. "/" .. string.GetFormattedSeperatorNum(need))
    end
end

function UIResourceLackNewView:GetDataList()
    self.list = {}
    self.packageInfo = nil
    local temp = self.lackWayList[self.toggleIndex]
    for i, v in pairs(temp) do
        if v.packageInfo then
            self.packageInfo = v.packageInfo
        else
            table.insert(self.list, v)
        end
    end

    self:SetPackage()
end

function UIResourceLackNewView:ClearScroll()
    self.cells = {}
    self.scroll_view:ClearCells()--清循环列表数据
    self.scroll_view:RemoveComponents(ResourceLackItem)--清循环列表gameObject
end

function UIResourceLackNewView:OnCreateCell(itemObj, index)
    itemObj.name = tostring(index)
    local cell = self.scroll_view:AddComponent(ResourceLackItem, itemObj)
    cell:ReInit(self.list[index], self.lackTabList[self.toggleIndex], index)
    if index == 1 then
        cell:ShowRecommend(true)
    end
    self.cells[index] = cell
end

function UIResourceLackNewView:OnDeleteCell(itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, ResourceLackItem)
end

function UIResourceLackNewView:ShowCells()
    self:AddNextFrameTimer()
end

function UIResourceLackNewView:RefreshCells()
    self:ClearScroll()
    self:GetDataList()
    local count = #self.list
    if count > 0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end

function UIResourceLackNewView:AddNextFrameTimer()
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(NextFrameTime, self.next_timer_callback,self, true, false, false)
    end
    self.timer:Start()
end

function UIResourceLackNewView:DeleteNextFrameTimer()
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

function UIResourceLackNewView:NextFrameTimeCallback()
    self:DeleteNextFrameTimer()
    self:RefreshCells()
end

function UIResourceLackNewView:OnBlueBtnClick()
    local list = {}
    local isSwitch = DataCenter.ResLackManager:GetIsShowMoreResSwitch()
    for k, v in ipairs(self.lackWayList) do
        local resType = self.lackTabList[k].id
        if self:NeedBtnResType(resType) then
            local need = self.lackTabList[k].targetNum
            local own = LuaEntry.Resource:GetCntByResType(resType)
            if own < need then
                if isSwitch then
                    local para1 = {}
                    para1.resType = resType
                    para1.need = need
                    para1.itemArr = {}
                    for k1, v1 in ipairs(v) do
                        if v1:GetTips() == ResLackGoToType.ResourceBagUse then
                            for _, arr in pairs(v1.itemArr) do
                                table.insert(para1.itemArr,arr)
                            end
                        end
                    end
                    table.insert(list, para1)
                else
                    for k1, v1 in ipairs(v) do
                        if v1:GetTips() == ResLackGoToType.ResourceBagUse then
                            local para1 = {}
                            para1.resType = resType
                            para1.need = need
                            para1.itemArr = v1.itemArr
                            table.insert(list, para1)
                            break
                        end
                    end
                end
            end
        end
    end

    if list[1] ~= nil then
        --打开界面
        local needShow = DataCenter.SecondConfirmManager:GetTodayCanShowSecondConfirm(TodayNoSecondConfirmType.ResourceReplenish)
        if needShow then
            UIManager:GetInstance():OpenWindow(UIWindowNames.UIResourceReplenish, NormalBlurPanelAnim, list)
        else
            --一键使用
            local result = DataCenter.ItemManager:GetReplenishUseResourceArr(list)
            if result[1] ~= nil then
                SFSNetwork.SendMessage(MsgDefines.UseResItemMulti, {goodsArr = result})
                self.ctrl:CloseSelf()
            end
        end
    end
end

function UIResourceLackNewView:NeedBtnResType(resType)
    return  resType == ResourceType.Food or resType == ResourceType.Plank
            or resType == ResourceType.Electricity or resType == ResourceType.Steel
end

function UIResourceLackNewView:UpdateResourceSignal()
    self:CheckRefresh()
end

function UIResourceLackNewView:AddDelayAnimTimer()
    self:DeleteDelayAnimTimer()
    if self.delay_anim_timer == nil then
        self.delay_anim_timer = TimerManager:GetInstance():GetTimer(DelayAnimTime, self.delay_anim_timer_callback, self, true, false, false)
    end
    self.delay_anim_timer:Start()
end

function UIResourceLackNewView:DeleteDelayAnimTimer()
    if self.delay_anim_timer ~= nil then
        self.delay_anim_timer:Stop()
        self.delay_anim_timer = nil
    end
end

function UIResourceLackNewView:DelayAnimTimerCallback()
    self:DeleteDelayAnimTimer()
    self.slider:DOValue(self.own / self.lackTabList[self.toggleIndex].targetNum, AnimTime,
            function()
                self.slider:SetValue(self.own / self.lackTabList[self.toggleIndex].targetNum)
                self.needAnim = false
            end)
end

function UIResourceLackNewView:GetOwn(index)
    local own = 0
    local tabParam = self.lackTabList[index]
    if tabParam.type == ResLackType.Item then
        own = DataCenter.ItemData:GetItemCount(tabParam.id)
    else
        if tabParam.id == ResourceType.FORMATION_STAMINA then
            own = math.ceil(LuaEntry.Player:GetCurPveStamina())
        elseif tabParam.id == ResourceType.MasteryPoint then
            own = DataCenter.MasteryManager:GetRestPoint()
        else
            own = LuaEntry.Resource:GetCntByResType(tabParam.id)
        end
    end
    return own
end

function UIResourceLackNewView:CheckRefresh(noRefresh)
    local tabParam = self.lackTabList[self.toggleIndex]
    if tabParam.targetNum ~= nil then
        --英雄经验不刷新
        local own = self:GetOwn(self.toggleIndex)
        if own < tabParam.targetNum then
            self.needAnim = true
            self.own = own
            self:RefreshSliderText(self.own, tabParam.targetNum)
            self:AddDelayAnimTimer()
            self:RefreshCellsMore()
        else
            --没有就关闭界面
            local needClose = true
            for k, v in ipairs(self.lackTabList) do
                own = self:GetOwn(k)
                if own < v.targetNum then
                    self.toggleIndex = k
                    if not noRefresh then
                        self:Refresh()
                    end
                    needClose = false
                    break
                end
            end
            if needClose then
                if self.noClosePanel then
                    self.needAnim = true
                else
                    self:DoClosePanel()
                end
            end
        end
    end
end

function UIResourceLackNewView:UpdateGoldSignal()
    local ownGold = LuaEntry.Player.gold
    for k, v in pairs(self.cells) do
        v:RefreshBtnColor(ownGold)
    end
end

function UIResourceLackNewView:RefreshCellsMore()
    for k, v in pairs(self.cells) do
        v:RefreshMore()
    end
end

function UIResourceLackNewView:UpdateGiftPackDataSignal()
    self:Refresh()
end

function UIResourceLackNewView:RefreshHeroEffectSkillSignal()
    self:Refresh()
end

return UIResourceLackNewView