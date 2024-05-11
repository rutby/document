--[[
礼包弹出View
--]]

local UIGiftRewardCell = require "UI.UIGiftPackageRewardGet.Component.UIGiftRewardCell"
local UIGetRewardView = BaseClass("UIGetRewardView", UIBaseView)
local base = UIBaseView
local UIGuidePioneerHeroExpCell = require "UI.UIPVE.UIPVEResult.Component.UIGuidePioneerHeroExpCell"
local panel_path = "UICommonRewardPopUp/Panel"
local title_name_path = "UICommonRewardPopUp/Panel/ImgTitleBg/TextTitle"
local layout_path = "layout"
local hero_list_path = "layout/heroList"
local scroll_view_path = "layout/CellList"
local skip_anim_btn_path = "SkipAnimButton"
local scroll_view_change_path = "CellListChange"
local rect_newchange_path = "Rect_NewChange"

local cellDelay = 0.125
local lineCount = 4

local Param = DataClass("Param", ParamData)
local ParamData =  {
    rewardType,
    itemId,
    count,
}

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self.param = self.ctrl:GetParam()
    if self.param.heroExp~=nil then
        self.heroList:SetActive(true)
    else
        self.heroList:SetActive(false)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate( self.layout.rectTransform)
end

-- 销毁
local function OnDestroy(self)
    if DataCenter.GuideManager:GetGuideType() == GuideType.ShowFakeHero then
        DataCenter.GuideManager:DoNext()
    end
    self:ClearScroll()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.btn = self:AddComponent(UIButton, panel_path)
    self.title_name = self:AddComponent(UITextMeshProUGUIEx, title_name_path)
    self.layout = self:AddComponent(UIBaseContainer, layout_path)
    self.heroList = self:AddComponent(UIBaseContainer, hero_list_path)
    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)

    self.btn:SetOnClick(function()
        EventManager:GetInstance():Broadcast(EventId.OnRewardGetPanelClose)
        self.ctrl:CloseSelf()
    end)

    self.skip_anim_btn = self:AddComponent(UIButton, skip_anim_btn_path)
    self.skip_anim_btn:SetOnClick(function()
        self:SkipCellAnim()
    end)

    self.scroll_view_change = self:AddComponent(UIScrollView, scroll_view_change_path)
    self.scroll_view_change:SetOnItemMoveIn(function(itemObj, index)
        self:OnCreateCell(itemObj, index)
    end)
    self.scroll_view_change:SetOnItemMoveOut(function(itemObj, index)
        self:OnDeleteCell(itemObj, index)
    end)
    self.rect_NewChangeObj = self:AddComponent(UIBaseContainer,rect_newchange_path)
    self.rect_NewChangeAnim = self:AddComponent(UIAnimator,rect_newchange_path)
end

local function ComponentDestroy(self)
    self.btn = nil
    self.title_name = nil
    self.scroll_view = nil
    self.scroll_view_change = nil
    self.skip_anim_btn = nil
end


local function DataDefine(self)
    self.param = nil
    self.nameText = nil
    self.cells = {}
    self.showAnim = true
end

local function DataDestroy(self)
    self.param = nil
    self.nameText = nil
    self.cells = nil
    self.showAnim = nil
end

local function OnEnable(self)
    base.OnEnable(self)
    self:ReInit()
end

local function OnDisable(self)
    local callback = self:GetUserData()
    if callback then
        callback()
    end
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end

local function ReInit(self)
    self:SetNameText(self.param.title)
    self:ShowCells()
    self.showAnim = true
end

local function ClearScroll(self)
    self.cells = {}
    if self.param and self.param.isUpChange then
        self.scroll_view_change:ClearCells()--清循环列表数据
        self.scroll_view_change:RemoveComponents(UIGiftRewardCell)--清循环列表gameObject
    else
        self.scroll_view:ClearCells()--清循环列表数据
        self.scroll_view:RemoveComponents(UIGiftRewardCell)--清循环列表gameObject
    end
    self.heroList:RemoveComponents(UIGuidePioneerHeroExpCell)
end

local function OnCreateCell(self,itemObj, index)
    itemObj.name = tostring(index)
    local cellItem
    if self.param.isUpChange then
        cellItem = self.scroll_view_change:AddComponent(UIGiftRewardCell, itemObj)
    else
        cellItem = self.scroll_view:AddComponent(UIGiftRewardCell, itemObj)
    end
    local rewardParam = self.param.rewardList[index]
    local param = UIGiftRewardCell.Param.New()
    param.rewardType = rewardParam.rewardType
    param.itemId = rewardParam.itemId
    param.count = rewardParam.count
    param.heroUuid = rewardParam.heroUuid
    param.isHeroBox = rewardParam.isHeroBox
    cellItem:ReInit(param)

    if self.showAnim then
        self.cells[index] = cellItem
        cellItem:Hide()
    else
        cellItem:Show(false)
    end
end

local function OnDeleteCell(self,itemObj, index)
    if self.param.isUpChange then
        self.scroll_view_change:RemoveComponent(itemObj.name, UIGiftRewardCell)
    else
        self.scroll_view:RemoveComponent(itemObj.name, UIGiftRewardCell)
    end

end

local function ShowCells(self)
    self:ClearScroll()
    if self.param.heroExp~=nil then
        for _, heroExpInfo in ipairs(self.param.heroExp) do
            self:AddHeroExpObj(heroExpInfo)
        end
    end
    local count = #self.param.rewardList
    if self.param.isUpChange then
        self.scroll_view:SetActive(false)
        if count > 0 then
            self.scroll_view_change:SetActive(true)
            self.scroll_view_change:SetTotalCount(count)
            self.scroll_view_change:RefillCells()
        else
            self.scroll_view_change:SetActive(false)
        end
    else
        self.scroll_view_change:SetActive(false)
        if count > 0 then
            self.scroll_view:SetActive(true)
            self.scroll_view:SetTotalCount(#self.param.rewardList)
            self.scroll_view:RefillCells()
        else
            self.scroll_view:SetActive(false)
        end
    end

    self:PlayCellAnim()
    self.skip_anim_btn:SetActive(count > 0)
end
local function AddHeroExpObj(self, heroExpInfo)
    self:GameObjectInstantiateAsync("Assets/Main/Prefab_Dir/Guide/UIGuidePioneerHeroExpCell.prefab", function(request)
        if request.isError then
            return
        end
        local go = request.gameObject
        go:SetActive(true)
        go.transform:SetParent(self.heroList.transform)
        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
        go.transform:SetAsLastSibling()
        go.name = tostring(heroExpInfo.heroUuid)
        local itemObj = self.heroList:AddComponent(UIGuidePioneerHeroExpCell, go.name)
        itemObj:InitData(heroExpInfo)
    end)
end
local function PlayCellAnim(self)

    local seq = DOTween.Sequence()
    for index = 1, #self.param.rewardList do
        seq:AppendInterval(cellDelay):AppendCallback(function()
            if self.showAnim then
                local cell = self.cells[index]
                if index > lineCount * 2 and #self.param.rewardList > lineCount * 2 then
                    if self.param.isUpChange then
                        self.scroll_view_change:ScrollToCell(index - lineCount, 750)
                    else
                        self.scroll_view:ScrollToCell(index - lineCount, 750)
                    end
                end
                cell:Show(true)
                if index == #self.param.rewardList then
                    self.skip_anim_btn:SetActive(false)
                    self.showAnim = false
                end
            end
        end)
    end
    if self.param.isUpChange then
        self.rect_NewChangeObj:SetActive(true)
        self.rect_NewChangeAnim:Play("V_ui_jiesuo_wupin", 0, 0)
    else
        self.rect_NewChangeObj:SetActive(false)
    end
end

local function SkipCellAnim(self)
    self.showAnim = false
    self.skip_anim_btn:SetActive(false)
    self:ClearScroll()
    if self.param.isUpChange then
        self.scroll_view_change:SetTotalCount(#self.param.rewardList)
        self.scroll_view_change:RefillCells()
        if #self.param.rewardList > lineCount * 2 then
            self.scroll_view_change:ScrollToCell(#self.param.rewardList - lineCount, 20000)
        end
    else
        self.scroll_view:SetTotalCount(#self.param.rewardList)
        self.scroll_view:RefillCells()
        if #self.param.rewardList > lineCount * 2 then
            self.scroll_view:ScrollToCell(#self.param.rewardList - lineCount, 20000)
        end
    end
    if self.param.isUpChange then
        self.rect_NewChangeObj:SetActive(true)
        self.rect_NewChangeAnim:Play("V_ui_jiesuo_wupin", 0, 1)
    else
        self.rect_NewChangeObj:SetActive(false)
    end
end

local function SetNameText(self,value)
    if self.nameText ~= value then
        self.nameText = value
        self.title_name:SetText(value)
    end
end

UIGetRewardView.OnCreate = OnCreate
UIGetRewardView.OnDestroy = OnDestroy
UIGetRewardView.OnEnable = OnEnable
UIGetRewardView.OnDisable = OnDisable
UIGetRewardView.ComponentDefine = ComponentDefine
UIGetRewardView.ComponentDestroy = ComponentDestroy
UIGetRewardView.DataDefine = DataDefine
UIGetRewardView.DataDestroy = DataDestroy
UIGetRewardView.OnAddListener = OnAddListener
UIGetRewardView.OnRemoveListener = OnRemoveListener

UIGetRewardView.ReInit = ReInit
UIGetRewardView.OnDeleteCell = OnDeleteCell
UIGetRewardView.ShowCells = ShowCells
UIGetRewardView.OnCreateCell = OnCreateCell
UIGetRewardView.ClearScroll = ClearScroll
UIGetRewardView.SetNameText = SetNameText

UIGetRewardView.PlayCellAnim = PlayCellAnim
UIGetRewardView.SkipCellAnim = SkipCellAnim
UIGetRewardView.AddHeroExpObj = AddHeroExpObj
return UIGetRewardView