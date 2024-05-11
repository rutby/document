--- Created by shimin
--- DateTime: 2023/9/19 10:09
--- 英雄选择阵容页面

local UIHeroChooseCampView = BaseClass("UIHeroChooseCampView", UIBaseView)
local base = UIBaseView
local UIHeroChooseCampCell = require "UI.UIHeroChooseCamp.Component.UIHeroChooseCampCell"

local ChooseCampType =
{
    HeroCamp.MAFIA,
    HeroCamp.UNION,
    HeroCamp.ZELOT,
    HeroCamp.NEW_HUMAN,
}

local DeltaX = 20

local panel_btn_path = "Panel"
local title_text_path = "tips/common_img_tipsbg/desTxt"
local pos_go_path = "tips"
local camp_content_path = "tips/CampObj"

function UIHeroChooseCampView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIHeroChooseCampView:ComponentDefine()
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.pos_go = self:AddComponent(UIBaseContainer, pos_go_path)
    self.camp_content = self:AddComponent(UIBaseContainer, camp_content_path)
end

function UIHeroChooseCampView:ComponentDestroy()
end

function UIHeroChooseCampView:DataDefine()
    self.lossyScaleX = self.transform.lossyScale.x
    self.list = {}
    self.cells = {}
    self.callback = function(index) 
        self:CellCallBack(index)
    end
    self.tabType = 0
    self.param = {}
end

function UIHeroChooseCampView:DataDestroy()
    self.list = {}
    self.cells = {}
    self.tabType = 0
    self.param = {}
end

function UIHeroChooseCampView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIHeroChooseCampView:OnEnable()
    base.OnEnable(self)
end

function UIHeroChooseCampView:OnDisable()
    base.OnDisable(self)
end

function UIHeroChooseCampView:OnAddListener()
    base.OnAddListener(self)
end

function UIHeroChooseCampView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIHeroChooseCampView:ReInit()
    self.param = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.NEW_HUMAN_CHANGE_CAMP_TITLE)
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.heroUuid)
    if heroData ~= nil then
        heroData:SetCampNoRedDot()
        local chooseCamp = heroData.chooseCamp
        for k ,v in ipairs(ChooseCampType) do
            if v == chooseCamp then
                self.tabType = k
                break
            end
        end
    end
    
    self:ShowCells()
    self:RefreshPosition()
end

function UIHeroChooseCampView:InitList()
    self.list = {}
    for k ,v in ipairs(ChooseCampType) do
        local param = {}
        param.campType = v
        param.select = k == self.tabType
        param.callback = self.callback
        param.index = k
        table.insert(self.list, param)
    end
end


function UIHeroChooseCampView:ShowCells()
    self:InitList()
    for k, v in ipairs(self.list) do
        self:GameObjectInstantiateAsync(UIAssets.UIHeroChooseCampCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.camp_content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            local model = self.camp_content:AddComponent(UIHeroChooseCampCell, nameStr)
            model:ReInit(v)
            self.cells[k] = model
        end)
    end
end

function UIHeroChooseCampView:CellCallBack(index)
    --如果编队在出征不能修改
    local heroData = DataCenter.HeroDataManager:GetHeroByUuid(self.param.heroUuid)
    if heroData ~= nil then
        if heroData:IsInMarch() then
            UIUtil.ShowTipsId(GameDialogDefine.CUR_IN_MARCH_NO_DO_IT)
        else
            self:SetSelect(index)
            local selectParam = self.list[self.tabType]
            if selectParam ~= nil then
                DataCenter.HeroDataManager:SendHeroChooseCamp(self.param.heroUuid, selectParam.campType)
            end
        end
    end
end

function UIHeroChooseCampView:SetSelect(tabType)
    if self.tabType ~= tabType then
        self:RefreshCellSelect(self.tabType, false)
        self.tabType = tabType
        self:RefreshCellSelect(self.tabType, true)
    end
end

function UIHeroChooseCampView:RefreshCellSelect(tabType, isSelect)
    local param = self.list[tabType]
    if param ~= nil then
        param.select = isSelect
    end
    if self.cells[tabType] ~= nil then
        self.cells[tabType]:Select(isSelect)
    end
end

function UIHeroChooseCampView:RefreshPosition()
    self.pos_go:SetPositionXYZ(self.param.pos.x + DeltaX * self.lossyScaleX, self.param.pos.y, 0)
end

return UIHeroChooseCampView