local UIAllianceBossDamageRewardViewCell = BaseClass("UIAllianceBossDamageRewardViewCell", UIBaseContainer)
local base = UIBaseContainer
local UIAllianceBossDamageRewardViewCellItem = require "UI.UIAllianceBoss.UIAllianceBossDamageReward.Component.UIAllianceBossDamageRewardViewCellItem"

-- path define

local name_des_path = "nameDes"
local u_i_alliance_boss_damage_reward_view_cell_item_path = "UIAllianceBossDamageRewardViewCellItem"
local stage_txt_path = "Txt_Stage"

--path define end

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
end

local function OnDestroy(self)
    base.OnDestroy(self)
    self:ComponentDestroy()
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ComponentDefine(self)
    self.name_des = self:AddComponent(UITextMeshProUGUIEx, name_des_path)
    self.stage_txt = self:AddComponent(UITextMeshProUGUIEx,stage_txt_path)
    self.stage_txt:SetLocalText(373055)
    self.u_i_alliance_boss_damage_reward_view_cell_item = self:AddComponent(UIAllianceBossDamageRewardViewCellItem, u_i_alliance_boss_damage_reward_view_cell_item_path)
end

local function ComponentDestroy(self)
    self.name_des = nil
    self.u_i_alliance_boss_damage_reward_view_cell_item = nil
end

local function SetData(self, data,index)
    self.stage_txt:SetActive(false)
    self.name_des:SetLocalText(373007, tostring(data.damage))
    self.u_i_alliance_boss_damage_reward_view_cell_item:SetData(data)
    if self.view.stage and self.view.stage ~= 0 then
        if self.view.stage >= index then
            self.stage_txt:SetActive(true)
        end
    end
end

UIAllianceBossDamageRewardViewCell.OnCreate = OnCreate
UIAllianceBossDamageRewardViewCell.OnDestroy = OnDestroy
UIAllianceBossDamageRewardViewCell.OnEnable = OnEnable
UIAllianceBossDamageRewardViewCell.OnDisable = OnDisable
UIAllianceBossDamageRewardViewCell.ComponentDefine = ComponentDefine
UIAllianceBossDamageRewardViewCell.ComponentDestroy = ComponentDestroy
UIAllianceBossDamageRewardViewCell.SetData = SetData

return UIAllianceBossDamageRewardViewCell