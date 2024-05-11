---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/8 12:04
---
local FormationHeroSelectCell = BaseClass("FormationHeroSelectCell",UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellSmall"
local hero_path = "UIHeroCellSmall"
local select_obj_path = "selectObj"
local in_march_obj_path = "inMarchObj"
local lock_obj_path = "lockObj"
local in_march_des_path = "inMarchObj/inMarchDes"
local form_obj_path = "inFormBg"
local form_index_num_path ="inFormBg/indexNum"
local champion_in_diff_formation_cover_path = "champion_in_diff_formation_cover"
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
    self.heroBase = self:AddComponent(UIHeroCell,hero_path)
    self.select_obj = self:AddComponent(UIBaseContainer,select_obj_path)
    self.in_march_obj = self:AddComponent(UIBaseContainer,in_march_obj_path)
    self.lock_obj = self:AddComponent(UIBaseContainer,lock_obj_path)
    self.in_march_des = self:AddComponent(UITextMeshProUGUIEx,in_march_des_path)
    self.in_march_des:SetLocalText(300506)
    self.form_obj = self:AddComponent(UIBaseContainer,form_obj_path)
    self.form_index_num = self:AddComponent(UITextMeshProUGUIEx,form_index_num_path)
    self.champion_in_diff_formation_cover = self:AddComponent(UIImage, champion_in_diff_formation_cover_path)
end

local function SetItemShow(self, data)
    self.uuid = data
    self.heroBase:SetData(self.uuid,function()
        self:OnSelectClick()
    end)
    self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
    self.heroId = self.data.heroId
    self.in_march_obj:SetActive(self.data.isInMarch)
    if self.data.isInMarch == false then
        self.select_obj:SetActive(self.data.isSelect)
        self.lock_obj:SetActive(self.data.isLock)
    else
        self.select_obj:SetActive(false)
        self.lock_obj:SetActive(false)
    end
    self.form_obj:SetActive(self.data.formIndex>0)
    self.form_index_num:SetText(self.data.formIndex)
    self.champion_in_diff_formation_cover:SetActive(self.data.inDiffFormation == true)
end

local function OnSelectClick(self)
    --inDiffFormation 这个目前只在冠军对局里面设置了
    if self.data.inDiffFormation == true then
        return
    end
    if self.data.isInMarch == false then
        self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
        if self.data.isSelect == false and self.data.isLock == false then
            self.view.ctrl:SelectHeroByUuid(self.uuid)
            --self.select_obj:SetActive(true)
            self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
            if self.data.index>0 then
                self.view:OnSelectHeroFinish(self.data.index)
            end
        elseif self.data.isSelect == true then
            if self.data.index~=nil then
                local index = self.data.index
                self.view.ctrl:OnDeleteHeroByIndex(index)
                self.select_obj:SetActive(false)
                self.view:OnSelectHeroFinish(index)
            end
        end
    end
    
end
local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.OnCancelHeroSelect, self.RefreshState)
    self:AddUIListener(EventId.OnSelectHeroSelect, self.RefreshSelectState)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.OnSelectHeroSelect, self.RefreshSelectState)
    self:RemoveUIListener(EventId.OnCancelHeroSelect, self.RefreshState)
end

local function RefreshState(self,data)
    if self.heroId == data then
        self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
        self.select_obj:SetActive(self.data.isSelect)
        self.lock_obj:SetActive(self.data.isLock)
    end
end

local function RefreshSelectState(self,data)
    if self.heroId == data then
        self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
        self.select_obj:SetActive(self.data.isSelect)
        self.lock_obj:SetActive(self.data.isLock)
    end
end

local function GetAddObj(self)
    return self.heroBase.gameObject
end

function FormationHeroSelectCell:GetGuideObj()
    return self.heroBase.btn_go.gameObject
end


FormationHeroSelectCell.OnCreate = OnCreate
FormationHeroSelectCell.SetItemShow = SetItemShow
FormationHeroSelectCell.OnSelectClick =OnSelectClick
FormationHeroSelectCell.RefreshState= RefreshState
FormationHeroSelectCell.OnAddListener =OnAddListener
FormationHeroSelectCell.OnRemoveListener= OnRemoveListener
FormationHeroSelectCell.RefreshSelectState = RefreshSelectState
FormationHeroSelectCell.GetAddObj =GetAddObj
return FormationHeroSelectCell