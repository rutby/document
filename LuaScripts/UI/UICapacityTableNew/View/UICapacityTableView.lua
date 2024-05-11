---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guq.
--- DateTime: 2021/4/29 16:28
---
local PropRowItem = require "UI.UICapacityTableNew.Component.PropRowItem"
local UIHeroEquipInfoNode = require "UI.UIHeroEquipInfo.Component.UIHeroEquipInfoNode"

local UICapacityTableView = BaseClass("UICapacityTableView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization

local this_path = ""

local close_btn_path = "fullTop/CloseBtn"
local txt_title_path ="fullTop/imgTitle/Common_img_title/titleText"

local item_bg_go_path = "ItemInfo"
local item_name_path = "ItemInfo/ItemName"
local item_des_path = "ItemInfo/ItemDes"
local item_input_path = "ItemInfo/InputGo/DesBg/InputField"
local item_add_btn_path = "ItemInfo/InputGo/DesBg/AddBtn"
local item_add_btn_active_img_path = "ItemInfo/InputGo/DesBg/AddBtn/AddActiveImage"
local item_add_btn_inactive_img_path = "ItemInfo/InputGo/DesBg/AddBtn/AddInActiveImage"
local item_dec_btn_path = "ItemInfo/InputGo/DesBg/DecBtn"
local item_dec_btn_active_img_path = "ItemInfo/InputGo/DesBg/DecBtn/DecActiveImage"
local item_dec_btn_inactive_img_path = "ItemInfo/InputGo/DesBg/DecBtn/DecInActiveImage"
local item_use_path = "ItemInfo/Use"
local item_use_btn_path = "ItemInfo/Use/UseBtn"
local item_use_btn_name_path = "ItemInfo/Use/UseBtn/UseBtnName"
local item_slider_path = "ItemInfo/InputGo/DesBg/Slider"
local item_arrow_path = "ItemInfo/arrow"
local item_input_go_path = "ItemInfo/InputGo"
local equip_info_go_path = "ItemInfo/UIHeroEquipInfoNode"
local cell_select_path = "SelectGo"
local empty_text_path = "EmptyText"

local propScrollView_path = "scrollBg/propScrollView"
local toggle_path = "ToggleGroup/Toggle"

local toggleCount = 5
local rowItemCount = 4

local toggleIndexToType = 
{
    UIBagBtnType.Resource,
    UIBagBtnType.Buff,
    UIBagBtnType.War,
    UIBagBtnType.HeroEquip,
    UIBagBtnType.Other,
}

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self.curTabType = 1
    self.curCount = nil
    self.minCount = 1
    self.showInfoItemIndex = -1
    self.maxCount = 9999
    self.curSelectCell = nil
    self.selectId = nil
    self.jumpItemID = nil
    self.ctrl:InitData()
    self:ComponentDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    DataCenter.ItemManager:SetLastType(self.curType)
    if self.itemInfoGo~=nil then
        self.itemInfoGo.transform:SetParent(self.transform)
    end
    self.jumpItemID = nil
    self.curTabType = nil
    self.showInfoItemIndex = nil
    self:ExitResetRed()
    self:ClearPropScroll()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.toggle1 = self:AddComponent(UIToggle,toggle_path..1)
    self.toggle2 = self:AddComponent(UIToggle,toggle_path..2)
    self.toggle3 = self:AddComponent(UIToggle,toggle_path..3)
    self.toggle4 = self:AddComponent(UIToggle,toggle_path..4)
    self.toggle5 = self:AddComponent(UIToggle,toggle_path..5)
    self.toggle1:SetIsOn(true)
    self.toggle1:SetOnValueChanged(function(tf)
        if tf then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_common_switch)
            self:ToggleControlBorS(1)
        end
    end)
    self.toggle2:SetIsOn(false)
    self.toggle2:SetOnValueChanged(function(tf)
        if tf then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_common_switch)
            self:ToggleControlBorS(2)
        end
    end)
    self.toggle3:SetIsOn(false)
    self.toggle3:SetOnValueChanged(function(tf)
        if tf then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_common_switch)
            self:ToggleControlBorS(3)
        end
    end)
    self.toggle4:SetIsOn(false)
    self.toggle4:SetOnValueChanged(function(tf)
        if tf then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_common_switch)
            self:ToggleControlBorS(4)
        end
    end)
    self.toggle4:SetActive(HeroEquipUtil:CheckSwitch())
    self.toggle5:SetIsOn(false)
    self.toggle5:SetOnValueChanged(function(tf)
        if tf then
            SoundUtil.PlayEffect(SoundAssets.Music_Effect_common_switch)
            self:ToggleControlBorS(5)
        end
    end)
    self.toggleList = {}
    for i=1,toggleCount do
        local toggle = {}
        toggle.checkMark = self:AddComponent(UIImage, toggle_path..i.."/Background/Checkmark"..i)
        toggle.checkMark:SetActive(i == 1)
        toggle.text = self:AddComponent(UITextMeshProUGUIEx, toggle_path..i.."/text"..i)
        toggle.text:SetText(self.ctrl:GetItemTypeName(toggleIndexToType[i]))
        toggle.text:SetActive(i ~= 1)
        toggle.checkText = self:AddComponent(UITextMeshProUGUI, toggle_path..i.."/checkText"..i)
        toggle.checkText:SetText(self.ctrl:GetItemTypeName(toggleIndexToType[i]))
        toggle.checkText:SetActive(i == 1)
        table.insert(self.toggleList, toggle)
    end
    
    self.propScrollView = self:AddComponent(UIScrollView, propScrollView_path)
    self.propScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnPropItemMoveIn(itemObj, index)
    end)
    self.propScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnPropItemMoveOut(itemObj, index)
    end)
    
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.txt_title = self:AddComponent(UITextMeshProUGUIEx, txt_title_path)
    self.close_btn:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    
    self.itemInfoGo = self:AddComponent(UIBaseContainer, item_bg_go_path)
    self.itemInfoNameTxt = self:AddComponent(UITextMeshProUGUIEx, item_name_path)
    self.itemInfoDesTxt = self:AddComponent(UITextMeshProUGUIEx, item_des_path)
    self.itemInfoInput = self:AddComponent(UITMPInput, item_input_path)
    self.itemInfoAddBtn = self:AddComponent(UIButton, item_add_btn_path)
    self.itemInfoDecBtn = self:AddComponent(UIButton, item_dec_btn_path)
    self.itemInfoAddBtnActiveImg = self:AddComponent(UIImage, item_add_btn_active_img_path)
    self.itemInfoAddBtnInactiveImg = self:AddComponent(UIImage, item_add_btn_inactive_img_path)
    self.itemInfoDecBtnActiveImg = self:AddComponent(UIImage, item_dec_btn_active_img_path)
    self.itemInfoDecBtnInactiveImg = self:AddComponent(UIImage, item_dec_btn_inactive_img_path)
    self.itemInfoAddBtnInactiveImg:SetActive(false)
    self.itemInfoDecBtnInactiveImg:SetActive(false)
    self.itemInfoUseGo = self:AddComponent(UIBaseContainer, item_use_path)
    self.itemInfoUseBtn = self:AddComponent(UIButton, item_use_btn_path)
    self.itemInfoUseBtnNameTxt = self:AddComponent(UITextMeshProUGUIEx, item_use_btn_name_path)
    self.itemInfoSlider = self:AddComponent(UISlider, item_slider_path)
    self.itemInfoSlider:SetOnValueChanged(function(value)
        self:OnSliderValueChange(value)
    end)
    self.itemInfoArrow = self:AddComponent(UIBaseContainer, item_arrow_path)
    self.equipInfoNode = self:AddComponent(UIHeroEquipInfoNode, equip_info_go_path)
    self.selectGo = self:AddComponent(UIBaseContainer, cell_select_path)
    self.itemInfoInputGo = self:AddComponent(UIBaseContainer, item_input_go_path)
    self.empty_text = self:AddComponent(UITextMeshProUGUIEx, empty_text_path)
    self.empty_text:SetLocalText(GameDialogDefine.NO_ANY_GOODS)

    self.itemInfoAddBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Add)
        self:OnAddBtnClick()
    end)

    self.itemInfoDecBtn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Dec)
        self:OnDecBtnClick()
    end)

    self.itemInfoInput:SetOnEndEdit(function (value)
        self:InputListener(value)
    end)
    

    self.itemInfoUseBtn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnUseBtnClick()
    end)
    self.event_trigger = self:AddComponent(UIEventTrigger, this_path)

    self.event_trigger:OnPointerDown(function(eventData)
    end)

    self.thisRoot = self:AddComponent(UIBaseContainer, this_path)
    
    self.itemList ={}
    self.propItemDataList = {}
end

local function ComponentDestroy(self)
    if self.selectGo then
        self.selectGo.transform:SetParent(self.transform)
    end
    self.selectGo = nil
    self.close_btn = nil
    self.txt_title = nil
    self.itemList =nil
    self.propItemDataList =nil
    self.curCount = nil
    self.minCount = nil
    self.maxCount = nil
    self.curSelectCell = nil
    self.itemInfoNameTxt = nil
    self.itemInfoDesTxt = nil
    self.itemInfoInput = nil
    self.itemInfoAddBtn = nil
    self.itemInfoDecBtn = nil
    self.itemInfoUseBtn = nil
    self.itemInfoUseBtnNameTxt = nil
    self.empty_text = nil
    self.itemInfoInputGo = nil
    self.event_trigger = nil
    self.selectId = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ExitResetRed(self)
    if self.itemList and next(self.itemList) then
        for i = 1 ,#self.itemList do
            if self.itemList[i].template and self.itemList[i].template.important == 2 then
                DataCenter.ItemData:SetItemRed(self.itemList[i].data.uuid)
            end
        end
    end
end

function UICapacityTableView:OnDestroyScrollItem(go, index)
    --背包道具选中道具被移除时关闭选中框
    if index == self.curSelectCell then
        self.selectGo:SetActive(false)
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.RefreshItems, self.RefreshItemsToCell)
    self:AddUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:AddUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
    self:AddUIListener(EventId.VipDataRefresh, self.VipUpdate)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.RefreshItems, self.RefreshItemsToCell)
    self:RemoveUIListener(EventId.RefreshGuide, self.RefreshGuideSignal)
    self:RemoveUIListener(EventId.END_SEARCH, self.OnSearchCallBack)
    self:RemoveUIListener(EventId.VipDataRefresh, self.VipUpdate)
end

local function ReInit(self)
    local curTypeStr,jumpItemID = self:GetUserData()
    if curTypeStr then
        self.curType = tonumber(curTypeStr)
    else
        local last = DataCenter.ItemManager:GetLastType()
        if last then
            self.curType = last
        else
            self.curType = UICapacityTableTab.Item
        end
    end
    self.jumpItemID = jumpItemID
    
    self:RefreshList()
    self:RefreshTitleName()
end

local function RefreshList(self)
    self.itemInfoGo:SetActive(false)
    
    self.itemList,self.propItemDataList = self.view.ctrl:GetItemListByType(self.curType,toggleIndexToType[self.curTabType],self.selectId)
    local lastCount = 0
    for k,v in pairs(self.propItemDataList) do
        lastCount  = lastCount + #v
    end
    self.empty_text:SetActive(false)

    for i = 1, #self.itemList do
        if self.itemList[i].itemId == self.jumpItemID then
            self.curSelectCell = i
            break
        end
    end
    self.jumpItemID = nil
    if self.curType == UICapacityTableTab.Item then
        self.empty_text:SetActive(lastCount <= 0)
        if lastCount>0 then
            if self.curSelectCell and self.curSelectCell > 0 then
                local index = (self.curSelectCell+rowItemCount-1)/rowItemCount
                self:RefreshPropList(index, false)
            else
                self:RefreshPropList(1, true)
            end
        end
    end
end

--道具使用事件更新
local function RefreshItemsToCell(self,state)
    if not state then
        return
    end
    if self.curType ~= UICapacityTableTab.Item then
        return
    end
    self.itemList,self.propItemDataList = self.view.ctrl:GetItemListByType(self.curType,toggleIndexToType[self.curTabType],self.selectId)
    if #self.itemList>0 then
        self.empty_text:SetActive(false)
        self:RefreshPropList(-1, false)
    else
        self.empty_text:SetActive(true)
        self.propScrollView:SetActive(false)
        self:ItemBgClear()
    end
end

local function ItemBgClear(self)
    self.itemInfoNameTxt:SetText("")
    self.itemInfoDesTxt:SetText("")
    self.itemInfoInputGo:SetActive(false)
    self.itemInfoUseGo:SetActive(false)
end

local function OnAddBtnClick(self)
    --英雄碎片特殊处理
    local curParam = self.itemList[self.curSelectCell]
    local itemTemplate = curParam.template or DataCenter.ItemTemplateManager:GetItemTemplate(curParam.itemId)
    
    local p = (itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99) and HeroUtils.GetJigsawCost(curParam.itemId) or self.minCount
    if itemTemplate.use_limit ~= "" then
        if self.curCount + p <= tonumber(itemTemplate.use_limit) then
            local isGray = self.curCount + p == tonumber(itemTemplate.use_limit)
            self:SetInputText(self.curCount + p,isGray)
        end
    else
        if self.curCount + p <= self.maxCount then
            self:SetInputText(self.curCount + p)
        end
    end
end

local function OnDecBtnClick(self)
    --英雄碎片特殊处理
    local curParam = self.itemList[self.curSelectCell]
    local itemTemplate = curParam.template or DataCenter.ItemTemplateManager:GetItemTemplate(curParam.itemId)

    local p = (itemTemplate.type == GOODS_TYPE.GOODS_TYPE_98 or itemTemplate.type == GOODS_TYPE.GOODS_TYPE_99) and HeroUtils.GetJigsawCost(curParam.itemId) or self.minCount

    if self.curCount > p then
        self:SetInputText(self.curCount - p)
    end
end

local function InputListener(self)
    local temp = self.itemInfoInput:GetText()
    if temp ~= nil and temp ~= "" then
        local inputCount = tonumber(temp)
        if inputCount <= self.minCount then
            self:SetInputText(self.minCount)
        elseif inputCount >= self.maxCount then
            self:SetInputText(self.maxCount)
        else
            self:SetInputText(inputCount)
        end
    end
end

local function OnUseBtnClick(self)
    local param = self.itemList[self.curSelectCell]
    if param.itemId ~= nil then
        self.ctrl:OnItemUse(DataCenter.ItemData:GetItemById(self.itemList[self.curSelectCell].itemId),self.curCount)
    end
    if param.equipUuid ~= nil then
        if param.heroId == 0 then
            self.ctrl:OnWearEquip()
        else
            self.ctrl:OnEquipUpgrade(param.equipUuid)
        end
    end
end

local function CellsCallBack(self,trans,index)
    self.itemInfoGo:SetActive(true)
    if self.curSelectCell ~= nil then
        local curRowIndex = (self.curSelectCell + rowItemCount - 1) / rowItemCount
        local newRowIndex = (index + rowItemCount - 1) / rowItemCount
        if curRowIndex ~= newRowIndex then
            self.itemInfoGo.transform:SetParent(trans.parent.parent)
            self.showInfoItemIndex = newRowIndex
        end
    else
        self.itemInfoGo.transform:SetParent(trans.parent.parent)
        self.showInfoItemIndex = 1
    end
    local param = {}
    param.x = trans.position.x
    param.y = self.itemInfoArrow.transform.position.y
    param.z = self.itemInfoArrow.transform.position.z
    self.itemInfoArrow.transform.position = param
    
    if self.curSelectCell ~= index then
        self.curSelectCell = index
        self.selectGo.transform:SetParent(trans:GetChild(0))
        if index == 1 then
            self.selectGo.transform:SetSiblingIndex(8)
        else
            self.selectGo.transform:SetSiblingIndex(8)
        end
        self.selectGo.transform:Set_localPosition(0,2,0)
        self.selectGo.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        self.selectGo:SetActive(true)
        self:RefreshItemInfo()
    else
        self:RefreshItemInfo()
    end
end

local function RefreshItemInfo(self)
    local param = self.itemList[self.curSelectCell]
    if param.itemId ~= nil then
        self.itemInfoDesTxt:SetActive(true)
        self:SetInputGoActive(true)
        self.equipInfoNode:SetActive(false)
        local itemData = DataCenter.ItemTemplateManager:GetItemTemplate(param.itemId)
        if itemData ~= nil then
            self:SetItemNameText(DataCenter.ItemTemplateManager:GetName(param.itemId))
            self:SetItemDesText(DataCenter.ItemTemplateManager:GetDes(param.itemId))
            local item = DataCenter.ItemData:GetItemById(param.itemId)

            --英雄碎片
            local isHeroJigsaw = itemData.type == GOODS_TYPE.GOODS_TYPE_98 or itemData.type == GOODS_TYPE.GOODS_TYPE_99
            self.itemInfoInput:SetInteractable(not isHeroJigsaw)
            if isHeroJigsaw then
                self:SetInputText(math.min(HeroUtils.GetJigsawCost(param.itemId), item.count))
            else
                self:SetInputText(self.minCount)
            end

            self:SetUseBtnNameText(Localization:GetString("110046"))

            if item ~= nil then
                self.maxCount = item.count

                -- 专精经验
                local maxCount = UIUtil.GetMasteryExpItemMaxCount(param.itemId)
                if self.maxCount > maxCount then
                    self.maxCount = maxCount
                end
                self.itemInfoSlider:SetValue(self.curCount / self.maxCount)
                self:SetAddAndDecBtnState()
                local useAll =  itemData.useall
                if useAll ~= nil and useAll == 1 then
                    self:SetInputGoActive(true)
                else
                    self:SetInputGoActive(false)
                end

                if itemData.use ~= nil then
                    if itemData.use ~= 1 then
                        self:SetUseBtnActive(false)
                    else
                        self:SetUseBtnActive(true)
                    end
                else
                    local strGoto = itemData.go_to
                    if strGoto ~= nil and string.len(strGoto) > 0 and tonumber(strGoto) == 7 then
                        self:SetUseBtnActive(true)
                    else
                        self:SetUseBtnActive(false)
                    end
                end

                local type = itemData.type
                local type2 = itemData.type2

                if type == 3 and type2 == 999 then
                    self:SetUseBtnNameText(Localization:GetString("110081"))
                else
                    self:SetUseBtnNameText(Localization:GetString("110046"))
                end

                local para = itemData.para
                local paras = {}
                if para ~= nil and para ~= "" then
                    paras = string.split(para,";")
                end
                local isNeedOtherBtn = false
                local strOtherText = Localization:GetString("110029")
                if type == 45 or type == 79 then
                    strOtherText = Localization:GetString("180057")
                    isNeedOtherBtn = true
                elseif type == 13 and paras ~= nil and paras[4] ~= nil then
                    if string.len(paras[4]) > 0 then
                        isNeedOtherBtn = true
                    else
                        isNeedOtherBtn = false
                    end
                elseif type == 16 and item.para ~= "-1" then
                    isNeedOtherBtn = true
                elseif type == 23 and paras ~= nil and paras[4] ~= nil and paras[3] ~= nil and string.len(paras[4]) > 0 and string.len(paras[3]) > 0 then
                    isNeedOtherBtn = true
                elseif param.itemId == "200070" then -- 限时招募券
                    isNeedOtherBtn = true
                elseif param.itemId == CS.FBDrawActController.Instance.m_outToolId then
                    isNeedOtherBtn = true
                else
                    isNeedOtherBtn = false
                end

                if isNeedOtherBtn then
                    self:SetUseBtnActive(true)
                    self:SetUseBtnNameText(strOtherText)
                end

            end
        end
    end
    if param.equipUuid ~= nil then
        self.itemInfoDesTxt:SetActive(false)
        self:SetInputGoActive(false)
        self.equipInfoNode:SetActive(true)
		self:SetUseBtnActive(true)
        
        param.equipUuid = self.itemList[self.curSelectCell].equipUuid
        self.equipInfoNode:SetData(param.equipUuid)
        local equip = DataCenter.HeroEquipManager:GetEquipByUuid(param.equipUuid)
        if equip ~= nil then
            local template = DataCenter.HeroEquipTemplateManager:GetTemplate(equip.equipId);
            if template ~= nil then
                self:SetItemNameText(Localization:GetString(template.name))
            end
           
            if param.heroId == 0 then
                self:SetUseBtnNameText(Localization:GetString(GameDialogDefine.HERO_EQUIP28))
            else
                self:SetUseBtnNameText(Localization:GetString(GameDialogDefine.HERO_EQUIP37))
            end
        end
    end
end

local function SetItemNameText(self,value)
    self.itemInfoNameTxt:SetText(value)
end

local function SetItemDesText(self,value)
    self.itemInfoDesTxt:SetText(value)
end

local function SetInputText(self,value,isGray)
    self.itemInfoSlider:SetValue(value / self.maxCount)
    local currentText = self.itemInfoInput:GetText()
    if self.curCount ~= value or currentText ~= tostring(value) then
        self.curCount = value
        self.itemInfoInput:SetText(value)
    end
    self:SetAddAndDecBtnState(isGray)
end

local function SetAddAndDecBtnState(self,isGray)
    self.itemInfoDecBtn:SetInteractable (self.curCount > self.minCount)
    self.itemInfoAddBtn:SetInteractable(self.curCount < self.maxCount)
    self.itemInfoAddBtnActiveImg:SetActive(self.curCount < self.maxCount)
    self.itemInfoAddBtnInactiveImg:SetActive(isGray and isGray or (self.curCount >= self.maxCount))
    self.itemInfoDecBtnActiveImg:SetActive(self.curCount > self.minCount)
    self.itemInfoDecBtnInactiveImg:SetActive(self.curCount <= self.minCount)
end


local function SetInputGoActive(self,value)
    if self.inputGoActive ~= value then
        self.inputGoActive = value
        self.itemInfoInputGo:SetActive(value)
    end
end

local function SetUseBtnActive(self,value)
    if self.useBtnActive ~= value then
        self.useBtnActive = value
        self.itemInfoUseGo:SetActive(value)
    end
end

local function SetUseBtnNameText(self,value)
    if self.useBtnName ~= value then
        self.useBtnName = value
        self.itemInfoUseBtnNameTxt:SetText(value)
    end
end

local function RefreshTitleName(self)
    if self.curType == UICapacityTableTab.Resource then
        self.txt_title:SetLocalText(GameDialogDefine.RESOURCE) 
    elseif self.curType == UICapacityTableTab.Farming then
        self.txt_title:SetLocalText(GameDialogDefine.CLOD_BUILD)
    elseif self.curType == UICapacityTableTab.Item then
        self.txt_title:SetLocalText(GameDialogDefine.GOODS)
    elseif self.curType == UICapacityTableTab.HeroEquip then
        self.txt_title:SetLocalText(GameDialogDefine.HERO_EQUIP23)
    end
end

local function CheckGuide(self)
    if DataCenter.GuideManager:InGuide() then
        local guideTemplate =  DataCenter.GuideManager:GetCurTemplate()
        if guideTemplate ~= nil and guideTemplate.para3 ~= nil and guideTemplate.para3 ~= "" and guideTemplate.type == GuideType.ClickButton then
            self.selectId = guideTemplate.para3
            self:RefreshList()
        end
    end
end

local function RefreshGuideSignal(self)
    self:CheckGuide()
end

local function OnSearchCallBack(self, param)
    if param ~= nil then
        self.ctrl:OnSearchEnd(param.pointId, param.uuid)
    end
end

local function VipUpdate(self,param)
    self.ctrl:VipUpdate(param)
end

function UICapacityTableView : ClearPropScroll()
    self.propScrollView:ClearCells()
    self.propScrollView:RemoveComponents(PropRowItem)
end

function UICapacityTableView : OnPropItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.propScrollView:AddComponent(PropRowItem, itemObj)
    cellItem:ReInit(self.propItemDataList[index], index)
    self.propItemList[index] = cellItem
    self.itemInfoGo:SetActive(index == self.showInfoItemIndex)
end

function UICapacityTableView : OnPropItemMoveOut(itemObj, index)
    self.propScrollView:RemoveComponent(itemObj.name, PropRowItem)
end

-- 刷新列表信息
function UICapacityTableView : RefreshPropList(scrollToIndex, showAnim)
    self:ClearPropScroll()
    self.propScrollView:SetActive(true)
    if #self.propItemDataList>0 then
        self.propItemList = {}
        self.propScrollView:SetTotalCount(#self.propItemDataList)
        self.propScrollView:RefillCells()
        if scrollToIndex ~= nil and scrollToIndex > 1 then
            self.propScrollView:ScrollToCell(scrollToIndex, 5000)
        end

        if showAnim and showAnim == true then
            self:ShowRowItems()
        end
    end
end

-- 逐行显示
function UICapacityTableView : ShowRowItems()
    for k,v in ipairs(self.propItemList) do
        v:ShowSelf()
    end
end

--页签切换
function UICapacityTableView : ToggleControlBorS(index)
    if self.curTabType == index then
        return
    end
    self.curTabType = index
    for i=1,toggleCount do
        local toggle = self.toggleList[i]
        toggle.checkMark:SetActive(i == index)
        toggle.text:SetActive(i ~= index)
        toggle.checkText:SetActive(i == index)
    end
    if index == 4 then
        self.curType = UICapacityTableTab.HeroEquip
    else
        self.curType = UICapacityTableTab.Item
    end

    self.curSelectCell = nil
    self.selectGo:SetActive(false)
    self.showInfoItemIndex = -1
    self.itemInfoGo:SetActive(false)
    self.itemInfoGo.transform:SetParent(self.thisRoot.transform)
    self.itemList,self.propItemDataList = self.view.ctrl:GetItemListByType(self.curType,toggleIndexToType[index],self.selectId)
    if #self.itemList>0 then
        self:RefreshPropList(1,true)
        self.empty_text:SetActive(false)
    else
        self.empty_text:SetActive(true)
        self.propScrollView:SetActive(false)
        self:ItemBgClear()
    end
end

local function OnSliderValueChange(self, value)
    local num = Mathf.Round(value * self.maxCount)
    if num < self.minCount then
        num = self.minCount
    end
    self.curCount = num
    self:SetInputText(num)
end

local function RedReference(self,tabType,index)
    if tabType == UICapacityTableTab.Item then
        --self.redNum = self.redNum - 1
        self.itemList[index].redState = true
        local rowIndex = math.floor((index + rowItemCount - 1) / rowItemCount)
        local itemIndex = index % rowItemCount
        if itemIndex == 0 then
            itemIndex = rowItemCount
        end
        self.propItemDataList[rowIndex][itemIndex].redState = true
        DataCenter.ItemData:SetItemRed(self.itemList[index].data.uuid)
        --if self.redNum <= 0 then
        --    self.tabCells[UICapacityTableTab.Item]:RedRefresh(false)
        --end
    end
end

UICapacityTableView.OnCreate = OnCreate
UICapacityTableView.OnDestroy = OnDestroy
UICapacityTableView.OnEnable = OnEnable
UICapacityTableView.OnDisable = OnDisable
UICapacityTableView.ComponentDefine = ComponentDefine
UICapacityTableView.ComponentDestroy = ComponentDestroy
UICapacityTableView.OnAddListener = OnAddListener
UICapacityTableView.OnRemoveListener = OnRemoveListener
UICapacityTableView.ReInit = ReInit
UICapacityTableView.RefreshList =RefreshList
UICapacityTableView.RefreshTitleName= RefreshTitleName
UICapacityTableView.RefreshItemsToCell = RefreshItemsToCell
UICapacityTableView.OnAddBtnClick= OnAddBtnClick
UICapacityTableView.OnDecBtnClick= OnDecBtnClick
UICapacityTableView.InputListener= InputListener
UICapacityTableView.OnUseBtnClick = OnUseBtnClick
UICapacityTableView.CellsCallBack= CellsCallBack
UICapacityTableView.RefreshItemInfo= RefreshItemInfo
UICapacityTableView.SetItemNameText= SetItemNameText
UICapacityTableView.SetItemDesText= SetItemDesText
UICapacityTableView.SetInputText= SetInputText
UICapacityTableView.SetAddAndDecBtnState= SetAddAndDecBtnState
UICapacityTableView.SetInputGoActive= SetInputGoActive
UICapacityTableView.SetUseBtnActive= SetUseBtnActive
UICapacityTableView.SetUseBtnNameText= SetUseBtnNameText
UICapacityTableView.ItemBgClear= ItemBgClear
UICapacityTableView.CheckGuide = CheckGuide
UICapacityTableView.RefreshGuideSignal = RefreshGuideSignal
UICapacityTableView.OnSearchCallBack = OnSearchCallBack
UICapacityTableView.VipUpdate = VipUpdate
UICapacityTableView.ExitResetRed = ExitResetRed
UICapacityTableView.OnSliderValueChange = OnSliderValueChange
UICapacityTableView.RedReference = RedReference

return UICapacityTableView