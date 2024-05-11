--- Created by shimin
--- DateTime: 2023/7/20 14:28
--- 英雄兑换勋章/海报

local UIHeroMetalRedemptionMetal = BaseClass("UIHeroMetalRedemptionMetal", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local UIHeroMetalRedemptionMetalCell = require "UI.UIHeroMetalRedemption.Component.UIHeroMetalRedemptionMetalCell"
local UIHeroMetalRedemptionHeroCell = require "UI.UIHeroMetalRedemption.Component.UIHeroMetalRedemptionHeroCell"

local hero_page_scroll_view_path = "CellList"
local metal_scroll_view_path = "CellList2"
local empty_text_path = "EmptyTipText"
local desc_text_path = "DescText"
local dropdown_path = "HeroStateBg/Dropdown"
local confirm_btn_path = "BtnConfirm"
local confirm_btn_text_path = "BtnConfirm/btnTxt_green_big_new"
local check_btn_path = "check_btn"
local check_select_go_path = "check_btn/check_box/check_img"
local check_box_text_path = "check_btn/check_box_text"
local icon_img_path = "get_text/UIMainTopResourceCell/root/resourceIcon"
local get_num_text_path = "get_text/UIMainTopResourceCell/root/resourceNum"
local get_text_path = "get_text"

local SelectRange =
{
    Green = 3,--绿色
    Blue = 2,--蓝色及以下
    Purple = 1,--紫色及以下
    All = 0--全部
}

local SelectRangeHeroPageName =
{
    [SelectRange.Green] = GameDialogDefine.GREEN_HERO_PAGE,--绿色
    [SelectRange.Blue] = GameDialogDefine.BLUE_AND_DOWN,--蓝色及以下
    [SelectRange.Purple] = GameDialogDefine.PURPLE_AND_DOWN,--紫色及以下
    [SelectRange.All] = GameDialogDefine.ALL_HERO_PAGE,--全部
}

local SelectRangeMetalName =
{
    [SelectRange.Green] = GameDialogDefine.GREEN_METAL,--绿色
    [SelectRange.Blue] = GameDialogDefine.BLUE_AND_DOWN,--蓝色及以下
    [SelectRange.Purple] = GameDialogDefine.PURPLE_AND_DOWN,--紫色及以下
    [SelectRange.All] = GameDialogDefine.ALL_METAL,--全部
}

function UIHeroMetalRedemptionMetal:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIHeroMetalRedemptionMetal:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroMetalRedemptionMetal:OnEnable()
    base.OnEnable(self)
end

function UIHeroMetalRedemptionMetal:OnDisable()
    base.OnDisable(self)
end

function UIHeroMetalRedemptionMetal:ComponentDefine()
    self.hero_page_scroll_view = self:AddComponent(UIScrollView, hero_page_scroll_view_path)
    self.hero_page_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnHeroPageCellMoveIn(itemObj, index)
    end)
    self.hero_page_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnHeroPageCellMoveOut(itemObj, index)
    end)
    self.metal_scroll_view = self:AddComponent(UIScrollView, metal_scroll_view_path)
    self.metal_scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnMetalCellMoveIn(itemObj, index)
    end)
    self.metal_scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnMetalCellMoveOut(itemObj, index)
    end)
    self.empty_text = self:AddComponent(UIText, empty_text_path)
    self.desc_text = self:AddComponent(UIText, desc_text_path)
    self.dropdown = self:AddComponent(UIDropdown, dropdown_path)
    self.dropdown:SetOnValueChanged(function()
        self:OnValueChange()
    end)
    self.icon_img = self:AddComponent(UIImage, icon_img_path)
    self.get_text = self:AddComponent(UIText, get_text_path)
    self.confirm_btn = self:AddComponent(UIButton, confirm_btn_path)
    self.confirm_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnConfirmBtnClick()
    end)
    self.confirm_btn_text = self:AddComponent(UIText, confirm_btn_text_path)
    self.check_btn = self:AddComponent(UIButton, check_btn_path)
    self.check_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnCheckBtnClick()
    end)
    self.check_select_go = self:AddComponent(UIBaseContainer, check_select_go_path)
    self.check_box_text = self:AddComponent(UIText, check_box_text_path)
    self.get_num_text = self:AddComponent(UIText, get_num_text_path)
end

function UIHeroMetalRedemptionMetal:ComponentDestroy()
end

function UIHeroMetalRedemptionMetal:DataDefine()
    self.param = {}
    self.heroPageList = {}
    self.heroPageCells = {}
    self.metalList = {}
    self.metalCells = {}
    self.isSelectBox = false--是否选择复选框
    self.selectRange = SelectRange.Blue
    self.callback = function()  
        self:RefreshCount()
    end
    self.count = 0--可兑换数量
    self.saveHeroPageCount = {}
    self.saveMetalCount = {}
end

function UIHeroMetalRedemptionMetal:DataDestroy()
    self.param = {}
    self.heroPageList = {}
    self.heroPageCells = {}
    self.metalList = {}
    self.metalCells = {}
    self.isSelectBox = false
    self.selectRange = SelectRange.Blue
    self.count = 0--可兑换数量
    self.saveHeroPageCount = {}
    self.saveMetalCount = {}
end

function UIHeroMetalRedemptionMetal:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroMetalRedemptionMetal:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroMetalRedemptionMetal:ReInit(param)
    self.param = param
    if self.param.itemId ~= 0 then
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
        if goods ~= nil then
            local iconName = string.format(LoadPath.ItemPath, goods.icon)
            self.icon_img:LoadSprite(iconName)
        end
    end
    self.confirm_btn_text:SetLocalText(GameDialogDefine.REDEMPTION)
    self.check_box_text:SetLocalText(GameDialogDefine.ALL_SELECT)
    self.get_text:SetText(Localization:GetString(GameDialogDefine.MAY_GET))
    self:Refresh()
end

function UIHeroMetalRedemptionMetal:Refresh()
    if self.param.select then
        self:SetActive(true)
        self.isSelectBox = false
        self:RefreshCheckBox()
        if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
            self.hero_page_scroll_view:SetActive(true)
            self.metal_scroll_view:SetActive(false)
            self:ShowHeroPageCells()
            self.desc_text:SetLocalText(GameDialogDefine.SELECT_HERO_PAGE_REDEMPTION)
        elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
            self.hero_page_scroll_view:SetActive(false)
            self.metal_scroll_view:SetActive(true)
            self:ShowMetalCells()
            self.desc_text:SetLocalText(GameDialogDefine.SELECT_METAL_REDEMPTION)
        end
        self:RefreshCount()
        self:RefreshDropdown()
    else
        self:SaveSaveCount()
        self:SetActive(false)
    end
end

function UIHeroMetalRedemptionMetal:Select(tabType, select)
    self.param.tabType = tabType
    if self.param.select ~= select then
        self.param.select = select
        self:Refresh()
    end
end

function UIHeroMetalRedemptionMetal:ShowHeroPageCells()
    self:ClearHeroPageScroll()
    self:GetHeroPageDataList()
    local count = table.count(self.heroPageList)
    if count > 0 then
        self.empty_text:SetActive(false)
        self.hero_page_scroll_view:SetTotalCount(count)
        self.hero_page_scroll_view:RefillCells()
    else
        self.empty_text:SetActive(true)
        self.empty_text:SetLocalText(GameDialogDefine.NO_HERO_PAGE)
    end
end

function UIHeroMetalRedemptionMetal:ClearHeroPageScroll()
    self.heroPageCells = {}
    self.hero_page_scroll_view:ClearCells()--清循环列表数据
    self.hero_page_scroll_view:RemoveComponents(UIHeroMetalRedemptionHeroCell)--清循环列表gameObject
end

function UIHeroMetalRedemptionMetal:OnHeroPageCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.hero_page_scroll_view:AddComponent(UIHeroMetalRedemptionHeroCell, itemObj)
    item:ReInit(self.heroPageList[index])
    self.heroPageCells[index] = item
end

function UIHeroMetalRedemptionMetal:OnHeroPageCellMoveOut(itemObj, index)
    self.heroPageCells[index] = nil
    self.hero_page_scroll_view:RemoveComponent(itemObj.name, UIHeroMetalRedemptionHeroCell)
end

function UIHeroMetalRedemptionMetal:GetHeroPageDataList()
    self.heroPageList = {}
    local list = DataCenter.HeroDataManager:GetAllHeroPosters()
    for k, v in ipairs(list) do
        if self:CanShowHeroPage(v.rarity, v.quality) then
            local param = {}
            if self.isSelectBox then
                param.num = v.count
            else
                local saveNum = self:GetSaveHeroPageCount(v.heroId, v.quality)
                if saveNum <= v.count then
                    param.num = saveNum
                else
                    param.num = 0
                end
            end
            param.uuidList = v.uuidList
            param.count = v.count
            param.heroId = v.heroId
            param.quality = v.quality
            param.camp = GetTableData(HeroUtils.GetHeroXmlName(), v.heroId, "camp")
            param.rarity = v.rarity
            param.callback = self.callback
            param.useSelect = true
            table.insert(self.heroPageList, param)
        end
    end
    --排序
    if self.heroPageList[2] ~= nil then
        --颜色 星级 数量 id
        table.sort(self.heroPageList, function(a, b)
            if a.rarity ~= b.rarity then
                return a.rarity < b.rarity
            elseif a.quality ~= b.quality then
                return b.quality < a.quality
            elseif a.count ~= b.count then
                return b.count < a.count
            elseif a.heroId ~= b.heroId then
                return a.heroId < b.heroId
            end
            return false
        end)
    end
end

function UIHeroMetalRedemptionMetal:ShowMetalCells()
    self:ClearMetalScroll()
    self:GetMetalDataList()
    local count = table.count(self.metalList)
    if count > 0 then
        self.empty_text:SetActive(false)
        self.metal_scroll_view:SetTotalCount(count)
        self.metal_scroll_view:RefillCells()
    else
        self.empty_text:SetActive(true)
        self.empty_text:SetLocalText(GameDialogDefine.NO_METAL)
    end
end

function UIHeroMetalRedemptionMetal:ClearMetalScroll()
    self.metalCells = {}
    self.metal_scroll_view:ClearCells()--清循环列表数据
    self.metal_scroll_view:RemoveComponents(UIHeroMetalRedemptionMetalCell)--清循环列表gameObject
end

function UIHeroMetalRedemptionMetal:OnMetalCellMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local item = self.metal_scroll_view:AddComponent(UIHeroMetalRedemptionMetalCell, itemObj)
    item:ReInit(self.metalList[index])
    self.metalCells[index] = item
end

function UIHeroMetalRedemptionMetal:OnMetalCellMoveOut(itemObj, index)
    self.metalCells[index] = nil
    self.metal_scroll_view:RemoveComponent(itemObj.name, UIHeroMetalRedemptionMetalCell)
end

function UIHeroMetalRedemptionMetal:GetMetalDataList()
    self.metalList = {}
    local list = DataCenter.ItemData:GetAllHeroPageList()
    for k, v in ipairs(list) do
        local template = DataCenter.ItemTemplateManager:GetItemTemplate(v.itemId)
        if template ~= nil then
            if self:CanShowMetal(template.color) then
                local param = {}
                if self.isSelectBox then
                    param.num = v.count
                else
                    local saveNum = self:GetSaveMetalCount(v.itemId)
                    if saveNum <= v.count then
                        param.num = saveNum
                    else
                        param.num = 0
                    end
                end
                param.itemId = v.itemId
                param.count = v.count
                param.template = template
                param.callback = self.callback
                param.color = template.color
                param.useSelect = true
                table.insert(self.metalList, param)
            end
        end
    end
    --排序
    if self.metalList[2] ~= nil then
        --颜色 数量 id
        table.sort(self.metalList, function(a, b)
            if a.color ~= b.color then
                return b.color < a.color
            elseif a.count ~= b.count then
                return b.count < a.count
            elseif a.itemId ~= b.itemId then
                return a.itemId < b.itemId
            end
            return false
        end)
    end
end

function UIHeroMetalRedemptionMetal:RefreshCheckBox()
    if self.isSelectBox then
        self.check_select_go:SetActive(true)
    else
        self.check_select_go:SetActive(false)
    end
end

function UIHeroMetalRedemptionMetal:OnCheckBtnClick()
    self.isSelectBox = not self.isSelectBox
    self:RefreshCheckBox()
    self:RefreshBoxSelectCells()
    self:RefreshCount()
end

function UIHeroMetalRedemptionMetal:RefreshBoxSelectCells()
    if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
        for k,v in pairs(self.heroPageCells) do
            if self.isSelectBox then
                v:SetSelectNum(v.param.count)
            else
                v:SetSelectNum(0)
            end
        end
        for k,v in ipairs(self.heroPageList) do
            if self.isSelectBox then
                v.num = v.count
            else
                v.num = 0
            end
        end
    elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
        for k,v in pairs(self.metalCells) do
            if self.isSelectBox then
                v:SetSelectNum(v.param.count)
            else
                v:SetSelectNum(0)
            end
        end
        for k,v in ipairs(self.metalList) do
            if self.isSelectBox then
                v.num = v.count
            else
                v.num = 0
            end
        end
    end
end

--点击兑换
function UIHeroMetalRedemptionMetal:OnConfirmBtnClick()
    if self.count > 0 then
        local param = {}
        param.itemId = self.param.itemId
        param.count = self.count
        param.tabType = self.param.tabType
        param.flyCallback = self.param.flyCallback

        if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
            local heroArr = {}
            for k,v in ipairs(self.heroPageList) do
                if v.num > 0 then
                    for i = 1, v.num, 1 do
                        if v.uuidList[i] ~= nil then
                            table.insert(heroArr, v.uuidList[i])
                        end
                    end
                end
            end
            if heroArr[1] ~= nil then
                param.heroArr = heroArr
            end
        elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
            local costGoods = {}
            for k,v in ipairs(self.metalList) do
                if v.num > 0 then
                    local goodsParam = {}
                    goodsParam.goodsId = v.itemId
                    goodsParam.count = v.num
                    table.insert(costGoods, goodsParam)
                end
            end
            if costGoods[1] ~= nil then
                param.costGoods = costGoods
            end
        end
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroMetalRedemptionConfirm,{ anim = true, playEffect = true}, param)
    end
end

function UIHeroMetalRedemptionMetal:CanShowHeroPage(rarity, quality)
    if DataCenter.HeroMedalRedemptionManager:GetRedemptionNumByHeroPage(quality, rarity, 1) > 0 then
        if self.selectRange == SelectRange.Green then
            if rarity == HeroUtils.RarityType.C then
                return true
            end
        elseif self.selectRange == SelectRange.Blue then
            if rarity >= HeroUtils.RarityType.B then
                return true
            end
        elseif self.selectRange == SelectRange.Purple then
            if rarity >= HeroUtils.RarityType.A then
                return true
            end
        elseif self.selectRange == SelectRange.All then
            return true
        end
        return false
    end
end

function UIHeroMetalRedemptionMetal:CanShowMetal(color)
    if self.selectRange == SelectRange.Green then
        if color == ItemColor.GREEN then
            return true
        end
    elseif self.selectRange == SelectRange.Blue then
        if color <= ItemColor.BLUE and color >= ItemColor.GREEN then
            return true
        end
    elseif self.selectRange == SelectRange.Purple then
        if color <= ItemColor.PURPLE and color >= ItemColor.GREEN then
            return true
        end
    elseif self.selectRange == SelectRange.All then
        if color >= ItemColor.GREEN then
            return true
        end
    end
    return false
end

--刷新获取数量显示
function UIHeroMetalRedemptionMetal:RefreshCount()
    local count = 0
    if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
        for k,v in ipairs(self.heroPageList) do
            if v.num > 0 then
                count = count + DataCenter.HeroMedalRedemptionManager:GetRedemptionNumByHeroPage(v.quality, v.rarity, v.num)
            end
        end
    elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
        for k,v in ipairs(self.metalList) do
            if v.num > 0 then
                count = count + DataCenter.HeroMedalRedemptionManager:GetRedemptionNumByMetal(v.color, v.num)
            end
        end
    end
    self.count = count
    self.get_num_text:SetText(string.GetFormattedSeperatorNum(count))
    
end

function UIHeroMetalRedemptionMetal:RefreshDropdown()
    self.dropdown:Clear()
    if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
        local list = {}
        for i = 0, #SelectRangeHeroPageName, 1 do
            table.insert(list, Localization:GetString(SelectRangeHeroPageName[i]))
        end
        self.dropdown:AddList(list)
    elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
        local list = {}
        for i = 0, #SelectRangeMetalName, 1 do
            table.insert(list, Localization:GetString(SelectRangeMetalName[i]))
        end
        self.dropdown:AddList(list)
    end
    self.dropdown:SetValue(self.selectRange)
end

function UIHeroMetalRedemptionMetal:OnValueChange()
    self.selectRange = self.dropdown:GetValue()
    self.isSelectBox = false
    self:RefreshCheckBox()
    if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
        self:ShowHeroPageCells()
    elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
        self:ShowMetalCells()
    end
    self:RefreshCount()
end

--保存选择的数量
function UIHeroMetalRedemptionMetal:SaveSaveCount()
    if self.param.tabType == UIHeroMetalRedemptionTabType.HeroPage then
        self.saveHeroPageCount = {}
        for k,v in ipairs(self.heroPageList) do
            if v.num > 0 then
                if self.saveHeroPageCount[v.heroId] == nil then
                    self.saveHeroPageCount[v.heroId] = {}
                end
                self.saveHeroPageCount[v.heroId][v.quality] = v.num
            end
        end
    elseif self.param.tabType == UIHeroMetalRedemptionTabType.Metal then
        self.saveMetalCount = {}
        for k,v in ipairs(self.metalList) do
            if v.num > 0 then
                self.saveMetalCount[v.itemId] = v.num
            end
        end
    end
end

--获取海报保存选择的数量
function UIHeroMetalRedemptionMetal:GetSaveHeroPageCount(heroId, quality)
    if self.saveHeroPageCount[heroId] ~= nil and self.saveHeroPageCount[heroId][quality] ~= nil then
        return self.saveHeroPageCount[heroId][quality]
    end
    return 0
end

--获取勋章保存选择的数量
function UIHeroMetalRedemptionMetal:GetSaveMetalCount(itemId)
    if self.saveMetalCount[itemId] ~= nil then
        return self.saveMetalCount[itemId]
    end
    return 0
end

return UIHeroMetalRedemptionMetal