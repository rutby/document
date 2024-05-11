---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2021/7/20 14:52
---
local FormationHeroSelectItem = BaseClass("FormationHeroSelectItem",UIBaseContainer)
local base = UIBaseContainer
local UIHeroCell = require "UI.UIHero2.Common.UIHeroCellSmall"
local hero_path = "UIHeroCellSmall"
local select_obj_path = "selectObj"
local in_march_obj_path = "inMarchObj"
local lock_obj_path = "lockObj"
local in_march_des_path = "inMarchObj/inMarchDes"
local form_obj_path = "inFormBg"
local Localization = CS.GameEntry.Localization

local function OnCreate(self)
    base.OnCreate(self)
    self.heroBase = self:AddComponent(UIHeroCell,hero_path)
    self.select_obj = self:AddComponent(UIBaseContainer,select_obj_path)
    self.in_march_obj = self:AddComponent(UIBaseContainer,in_march_obj_path)
    self.lock_obj = self:AddComponent(UIBaseContainer,lock_obj_path)
    self.in_march_des = self:AddComponent(UITextMeshProUGUIEx,in_march_des_path)
    self.in_march_des:SetLocalText(120166)
    self.form_obj = self:AddComponent(UIBaseContainer,form_obj_path)
    self.form_obj:SetActive(false)
end

local function SetItemShow(self,data)
    self.uuid = data
    self.heroBase:SetData(self.uuid,function()
        self:OnSelectClick()
    end)
    self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
    self.heroId = self.data.heroId
    if self.data.isInMarch then
        self.in_march_obj:SetActive(true)
        self.select_obj:SetActive(false)
        self.lock_obj:SetActive(false)
        self.in_march_des:SetLocalText(120166) 
    elseif self.data.isInSelectFormationIndex>0 then
        self.in_march_obj:SetActive(true)
        self.in_march_des:SetLocalText(GameDialogDefine.DEFENCE_FORMATION) 
        self.select_obj:SetActive(false)
        self.lock_obj:SetActive(false)
    elseif self.data.isSelect then
        self.in_march_obj:SetActive(false)
        self.select_obj:SetActive(true)
        self.lock_obj:SetActive(false)
    elseif self.data.isLock then
        self.in_march_obj:SetActive(false)
        self.select_obj:SetActive(false)
        self.lock_obj:SetActive(true)
    else
        self.in_march_obj:SetActive(false)
        self.select_obj:SetActive(false)
        self.lock_obj:SetActive(false)
    end

end

local function OnSelectClick(self)
    if  self.data.isInSelectFormationIndex<=0 and self.data.isLock==false then
        self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
        if self.data.isSelect == false and self.data.isInMarch == false then
            self.view.ctrl:SelectHeroByUuid(self.uuid)
            self.data = self.view.ctrl:GetHeroDataByUuid(self.uuid)
            if self.data.index>0 then
                self.view:OnSelectHeroFinish(self.data.index)
            end
        elseif self.data.isSelect == true or self.data.isInMarch ==true then
            if self.data.index > 0 then
                local index = self.data.index
                self.view.ctrl:OnDeleteHeroByIndex(index)
                self.select_obj:SetActive(false)
                self.view:OnSelectHeroFinish(index)
            end
        end
    elseif self.data.isInSelectFormationIndex>0 and self.data.isInMarch == false then
        UIUtil.ShowTips(Localization:GetString("300509",self.data.isInSelectFormationIndex))
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

FormationHeroSelectItem.OnCreate = OnCreate
FormationHeroSelectItem.SetItemShow = SetItemShow
FormationHeroSelectItem.OnSelectClick =OnSelectClick
FormationHeroSelectItem.RefreshState= RefreshState
FormationHeroSelectItem.OnAddListener =OnAddListener
FormationHeroSelectItem.OnRemoveListener= OnRemoveListener
FormationHeroSelectItem.RefreshSelectState = RefreshSelectState
return FormationHeroSelectItem