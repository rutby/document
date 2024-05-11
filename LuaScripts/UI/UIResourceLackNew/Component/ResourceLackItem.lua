--- Created by shimin.
--- DateTime: 2024/1/26 19:02
--- 获得更多cell
local ResourceLackItem = BaseClass("ResourceLackItem", UIBaseContainer)
local base = UIBaseContainer
local UIGiftPackagePoint = require "UI.UIGiftPackage.Component.UIGiftPackagePoint"
local UICommonItem = require "UI.UICommonItem.UICommonItem_TextMeshPro"

local recommend_path = "AddBtn/Recommend"
local item_icon_path = "AddBtn/iconBg/icon"
local item_iconBg_path = "AddBtn/iconBg"
local name_text_path = "AddBtn/Rect_Desc/Name_Txt"
local desc_text_path = "AddBtn/Rect_Desc/Desc_Txt"
local item_path = "AddBtn/UICommonItemSize"
local buy_text_path = "AddBtn/Txt_BuyNum"
local discount_rect_path = "AddBtn/discount"
local discount_txt_path = "AddBtn/discount/discountTxt"
local use_btn_path = "AddBtn/use_btn"
local yellow_btn_use_go_path = "AddBtn/use_btn/yellow_btn_use_go"
local yellow_btn_use_text_path = "AddBtn/use_btn/yellow_btn_use_go/yellow_btn_use_text"
local yellow_btn_icon_text_path = "AddBtn/use_btn/yellow_btn_use_go/yellow_btn_icon_text"
local yellow_btn_text_path = "AddBtn/use_btn/yellow_btn_text"
local blue_btn_use_go_path = "AddBtn/use_btn/blue_btn_use_go"
local blue_btn_use_text_path = "AddBtn/use_btn/blue_btn_use_go/blue_btn_use_text"
local blue_btn_icon_text_path = "AddBtn/use_btn/blue_btn_use_go/blue_btn_icon_text"
local blue_btn_text_path = "AddBtn/use_btn/blue_btn_text"
local point_path = "AddBtn/use_btn/UIGiftPackagePoint"
local more_btn_go_path = "AddBtn/more_btn_go"
local more_btn_path = "AddBtn/more_btn_go/more_btn"
local more_btn_yellow_use_text_path = "AddBtn/more_btn_go/more_btn/more_btn_yellow_use_go/more_btn_yellow_use_text"
local more_btn_yellow_icon_text_path = "AddBtn/more_btn_go/more_btn/more_btn_yellow_use_go/more_btn_yellow_icon_text"
local more_btn_yellow_use_go_path = "AddBtn/more_btn_go/more_btn/more_btn_yellow_use_go"
local more_btn_blue_text_path = "AddBtn/more_btn_go/more_btn/more_btn_blue_text"

function ResourceLackItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function ResourceLackItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function ResourceLackItem:OnEnable()
    base.OnEnable(self)
end

function ResourceLackItem:OnDisable()
    base.OnDisable(self)
end

function ResourceLackItem:ComponentDefine()
    self.recommend_rect = self:AddComponent(UIBaseContainer, recommend_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.item_iconBg = self:AddComponent(UIBaseContainer, item_iconBg_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.desc_text = self:AddComponent(UITextMeshProUGUIEx, desc_text_path)
    self._buy_text = self:AddComponent(UITextMeshProUGUIEx, buy_text_path)
    self.item = self:AddComponent(UICommonItem, item_path)
    self.point_rect = self:AddComponent(UIGiftPackagePoint, point_path)
    self.discount_rect = self:AddComponent(UIBaseContainer, discount_rect_path)
    self.discount_txt = self:AddComponent(UITextMeshProUGUIEx, discount_txt_path)
    self.use_btn = self:AddComponent(UIButton, use_btn_path)
    self.use_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUseBtnClick()
    end)
    self.yellow_btn_use_go = self:AddComponent(UIBaseContainer, yellow_btn_use_go_path)
    self.yellow_btn_use_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_use_text_path)
    self.yellow_btn_icon_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_icon_text_path)
    self.yellow_btn_text = self:AddComponent(UITextMeshProUGUIEx, yellow_btn_text_path)
    self.blue_btn_use_go = self:AddComponent(UIBaseContainer, blue_btn_use_go_path)
    self.blue_btn_use_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_use_text_path)
    self.blue_btn_icon_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_icon_text_path)
    self.blue_btn_text = self:AddComponent(UITextMeshProUGUIEx, blue_btn_text_path)
    self.more_btn_go = self:AddComponent(UIBaseContainer, more_btn_go_path)
    self.more_btn = self:AddComponent(UIButton, more_btn_path)
    self.more_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnMoreBtnClick()
    end)
    self.more_btn_yellow_use_text = self:AddComponent(UITextMeshProUGUIEx, more_btn_yellow_use_text_path)
    self.more_btn_yellow_icon_text = self:AddComponent(UITextMeshProUGUIEx, more_btn_yellow_icon_text_path)
    self.more_btn_yellow_use_go = self:AddComponent(UIBaseContainer, more_btn_yellow_use_go_path)
    self.more_btn_blue_text = self:AddComponent(UITextMeshProUGUIEx, more_btn_blue_text_path)
end

function ResourceLackItem:ComponentDestroy()
end

function ResourceLackItem:DataDefine()
    self.param = {}
    self.perCost = 0
    self.moreCount = 0
    self.useColorBtnText = nil--刷新使用的btnText
    self.useColorMoreBtnText = nil--刷新使用的btnText
    self.useMoreBtnText = nil--刷新使用的btnText
end

function ResourceLackItem:DataDestroy()
    if self.useColorBtnText ~= nil then
        self.useColorBtnText:SetColor(WhiteColor)
    end
    if self.useColorMoreBtnText ~= nil then
        self.useColorMoreBtnText:SetColor(WhiteColor)
    end
end

-- 全部刷新
function ResourceLackItem:ReInit(param, distab, index)
    if param == nil then
        return 
    end
    self.param = param
    self.index = index
    self.lacktab = distab
    self:ShowRecommend(false)
    self.discount_rect:SetActive(false)
    self._buy_text:SetActive(false)
    self.desc_text:SetText(param:GetDesc())
    local tips = param:GetTips()
    self.tips = tips
    self.use_btn.gameObject:SetActive(true)
    if tips == ResLackGoToType.BuyGiftNew 
            or tips == ResLackGoToType.BuyGiftResNew then           --购买礼包
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.YellowSmall))
        self.blue_btn_text:SetActive(false)
        self.blue_btn_use_go:SetActive(false)
        self.yellow_btn_text:SetActive(true)
        self.yellow_btn_use_go:SetActive(false)
        self.yellow_btn_text:SetText(self.param:GetGiftPrice())
        self.more_btn_go:SetActive(false)
        self.item_iconBg:SetActive(false)
        self.name_text:SetText(self.param:GetGiftName())
        if tips == ResLackGoToType.BuyGiftResNew then
            if not param:CheckIsExist() then
                self:SetActive(false)
                return
            end
        end
        
        --积分
        self.point_rect:RefreshPoint(self.packageInfo)
        local list = self.param:GetCellsList()
        if list ~= nil and list[1] ~= nil then
            self.item:SetActive(true)
            self.item:ReInit(list[1])
        else
            self.item:SetActive(false)
        end
        self.discount_rect:SetActive(true)
        self.discount_txt:SetLocalText(320362, self.param:GetGiftPercent(index))
    elseif tips == ResLackGoToType.ResourceBagUse 
            or tips == ResLackGoToType.UseBuildGoods
            or tips == ResLackGoToType.ItemUseChoose
            or tips == ResLackGoToType.HeroEquipItemUse then
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.BlueSmall))
        self.name_text:SetText(self.param:GetName())
        self.more_btn_go:SetActive(true)
        self.useMoreBtnText = self.more_btn_blue_text
        self.more_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.BlueSmall))
        self.more_btn_yellow_use_go:SetActive(false)
        self.more_btn_blue_text:SetActive(true)
        self:RefreshMore() 
        self:SetBtnInfo()
        local item = self.param:GetConsume()
        if item ~= nil then
            self.item:SetActive(true)
            self.item:ReInit(item)
            self.item:SetItemCountActive(true)
            self.item:SetItemCount(item.count)
        end
        self.item_iconBg:SetActive(false)
    elseif tips == ResLackGoToType.BuyGiftGroup then
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.YellowSmall))
        self.blue_btn_text:SetActive(false)
        self.blue_btn_use_go:SetActive(false)
        self.yellow_btn_text:SetActive(true)
        self.yellow_btn_use_go:SetActive(false)
        self.yellow_btn_text:SetText(self.param:GetGiftPrice(index))
        self.item_iconBg:SetActive(false)
        self.name_text:SetText(self.param:GetGiftName(index))
        self.more_btn_go:SetActive(false)
        --积分
        self.point_rect:RefreshPoint(self.packageInfo)
        local list = self.param:GetCellsList(index)
        if list ~= nil and list[1] ~= nil then
            self.item:SetActive(true)
            self.item:ReInit(list[1])
        else
            self.item:SetActive(false)
        end
        self.discount_rect:SetActive(true)
        self.discount_txt:SetLocalText(320362,self.param:GetGiftPercent(index))
    elseif tips == ResLackGoToType.Build then
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.BlueSmall))
        self.item_iconBg:SetActive(true)
        local icon, scale = param:GetIcon()
        self.item_icon:SetLocalScale(scale)
        self.item_icon:LoadSprite(icon, nil, function()
            self.item_icon:SetNativeSize()
        end)
        self.item:SetActive(false)
        self.name_text:SetText(self.param:GetName())
        self.more_btn_go:SetActive(false)
        self:SetBtnInfo()
    elseif tips == ResLackGoToType.BuyPveStamina then
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.YellowSmall))
        self:CreateConsume(self.param:GetBuyNum())
        self.item_iconBg:SetActive(false)
        self.name_text:SetText(self.param:GetName())
        self.more_btn_go:SetActive(false)
        self.yellow_btn_text:SetActive(false)
        self.yellow_btn_use_go:SetActive(true)
        self.blue_btn_text:SetActive(false)
        self.blue_btn_use_go:SetActive(false)
        self.yellow_btn_use_text:SetLocalText(110080)
        local price, curIndex = self.param:GetBtnName()
        self.yellow_btn_icon_text:SetText(price)
        if curIndex ~= nil and curIndex == 1 then
            self.discount_rect:SetActive(true)
            self.discount_txt:SetLocalText(320556)
        end
        self._buy_text:SetActive(false)
    elseif tips == ResLackGoToType.ResourceBuyItem then
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.YellowSmall))
        local item = self.param:GetConsume()
        if item ~= nil then
            self.item:SetActive(true)
            self.item:ReInit(item)
            self.item:SetItemCountActive(false)
        end
        self.item_iconBg:SetActive(false)
        self.name_text:SetText(self.param:GetName())

        self.blue_btn_text:SetActive(false)
        self.blue_btn_use_go:SetActive(false)
        self.yellow_btn_text:SetActive(false)
        self.yellow_btn_use_go:SetActive(true)
        self.yellow_btn_use_text:SetLocalText(GameDialogDefine.BUY_AND_USE)
        
        self.perCost = self.param:GetPerCost()
        self.yellow_btn_icon_text:SetText(string.GetFormattedSeperatorNum(self.perCost))
        self.useColorBtnText = self.yellow_btn_icon_text
        self.useColorMoreBtnText = self.more_btn_yellow_icon_text
        self.more_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.YellowSmall))
        self.more_btn_yellow_use_go:SetActive(true)
        self.more_btn_blue_text:SetActive(false)
        self:RefreshMore()
    elseif tips == ResLackGoToType.BuildBuyItem then
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.YellowSmall))
        local item = self.param:GetConsume()
        if item ~= nil then
            self.item:SetActive(true)
            self.item:ReInit(item)
            self.item:SetItemCountActive(true)
        end
        self.item_iconBg:SetActive(false)
        self.name_text:SetText(self.param:GetName())
        self.more_btn_go:SetActive(false)
        self.yellow_btn_text:SetActive(false)
        self.yellow_btn_use_go:SetActive(true)
        self.blue_btn_text:SetActive(false)
        self.blue_btn_use_go:SetActive(false)
        self.yellow_btn_use_text:SetLocalText(GameDialogDefine.BUY)
        self.perCost = self.param:GetCostGoldNum()
        self.yellow_btn_icon_text:SetText(string.GetFormattedSeperatorNum(self.perCost))
        self.useColorBtnText = self.yellow_btn_icon_text
        self.discount_rect:SetActive(false)
        self._buy_text:SetActive(false)
        self:RefreshBtnColor(LuaEntry.Player.gold)
    elseif tips == ResLackGoToType.ActDaily then
        self.use_btn.gameObject:SetActive(false)
        self.item_iconBg:SetActive(true)
        --local icon, scale = param:GetIcon()
        --self.item_icon:SetLocalScale(scale)
        --self.item_icon:LoadSprite(icon, nil, function()
        --    self.item_icon:SetNativeSize()
        --end)
        self.item_icon:LoadSprite("Assets/Main/Sprites/UI/UIMain/UIMain_icon_activity")
        self.item:SetActive(false)
        self.name_text:SetText(self.param:GetName())
        self.more_btn_go:SetActive(false)
    else
        self.use_btn:LoadSprite(string.format(LoadPath.CommonNewPath, CommonBtnName.BlueSmall))
        self.item_iconBg:SetActive(true)
        local icon, scale = param:GetIcon()
        self.item_icon:SetLocalScale(scale)
        self.item_icon:LoadSprite(icon, nil, function()
            self.item_icon:SetNativeSize()
        end)
        self.item:SetActive(false)
        self.name_text:SetText(self.param:GetName())
        self.more_btn_go:SetActive(false)
        self:SetBtnInfo()
    end
end

function ResourceLackItem:ShowRecommend(isRecommend)
    self.recommend_rect:SetActive(isRecommend)
end

function ResourceLackItem:SetBtnInfo()
    self.yellow_btn_text:SetActive(false)
    self.yellow_btn_use_go:SetActive(false)
    if self.param:GetBtnNameType() == 1 then
        self.blue_btn_text:SetActive(true)
        self.blue_btn_use_go:SetActive(false)
        self.blue_btn_text:SetText(self.param:GetBtnName())
    elseif self.param:GetBtnNameType() == 2 then
        self.blue_btn_text:SetActive(false)
        self.blue_btn_use_go:SetActive(true)
        self.blue_btn_use_text:SetLocalText(GameDialogDefine.BUY)
        if self.tips == ResLackGoToType.BuyPveStamina then
            local price, index = self.param:GetBtnName()
            self.blue_btn_icon_text:SetText(price)
            if index and index == 1 then
                self.discount_rect:SetActive(true)
                self.discount_txt:SetLocalText(320556)
            end
        else
            self.blue_btn_icon_text:SetText(self.param:GetBtnName())
        end
        self._buy_text:SetActive(true)
        self._buy_text:SetText(self.param:GetBuyNum())
    end
end

function ResourceLackItem:CreateConsume(useCount)
    if self.tips ~= ResLackGoToType.ResourceBagUse and self.tips ~= ResLackGoToType.UseBuildGoods 
            and self.tips ~= ResLackGoToType.ItemUseChoose 
            and self.tips ~= ResLackGoToType.BuyPveStamina then
        return
    end
    local list = self.param:GetConsume()
    if list[1] ~= nil then
        self.item_iconBg:SetActive(false)
        self.item:SetActive(true)
        self.item:ReInit(list[1])
        if useCount then
            self.item:SetItemCountActive(true)
            self.item:SetItemCount(useCount)
        else
            if list[1].rewardType == RewardType.GOODS then
                local ItemData = DataCenter.ItemData:GetItemById(list[1].itemId)
                if ItemData then
                    self.item:SetItemCountActive(true)
                    self.item:SetItemCount(ItemData.count)
                else
                    self.item:SetItemCountActive(false)
                end
            end
        end
    else
        self.item:SetActive(false)
        self.item_iconBg:SetActive(true)
    end
end

function ResourceLackItem:OnUseBtnClick()
    local isRefresh = false
    if self.tips == ResLackGoToType.ResourceBagUse or self.tips == ResLackGoToType.UseBuildGoods or self.tips == ResLackGoToType.ItemUseChoose  then      --背包使用道具
        isRefresh = true
    end
    self.param:TodoAction(self.use_btn.transform.position, isRefresh, self.lacktab, self.index)
end

function ResourceLackItem:OnMoreBtnClick()
    if self.param.TodoMoreAction ~= nil then
        self.param:TodoMoreAction()
    end
end

function ResourceLackItem:RefreshBtnColor(ownGold)
    if self.useColorBtnText ~= nil then
        if ownGold < self.perCost then
            self.useColorBtnText:SetColor(RedColor)
        else
            self.useColorBtnText:SetColor(WhiteColor)
        end
    end
    
    if self.useColorMoreBtnText ~= nil then
        if ownGold < (self.moreCount * self.perCost) then
            self.useColorMoreBtnText:SetColor(RedColor)
        else
            self.useColorMoreBtnText:SetColor(WhiteColor)
        end
    end
end

function ResourceLackItem:RefreshMore()
    if self.useColorMoreBtnText ~= nil then
        self.moreCount = self.param:GetMoreCount()
        if self.moreCount <= 1 then
            self.more_btn_go:SetActive(false)
        else
            self.more_btn_go:SetActive(true)
            self.more_btn_yellow_use_text:SetText("x" .. string.GetFormattedSeperatorNum(self.moreCount))
            self.more_btn_yellow_icon_text:SetText(string.GetFormattedSeperatorNum(self.moreCount * self.perCost))
        end
        self:RefreshBtnColor(LuaEntry.Player.gold)
    elseif self.useMoreBtnText ~= nil then
        self.moreCount = self.param:GetMoreCount()
        if self.moreCount <= 1 then
            self.more_btn_go:SetActive(false)
        else
            self.more_btn_go:SetActive(true)
            self.useMoreBtnText:SetText("x" .. string.GetFormattedSeperatorNum(self.moreCount))
        end
    end
end


return ResourceLackItem