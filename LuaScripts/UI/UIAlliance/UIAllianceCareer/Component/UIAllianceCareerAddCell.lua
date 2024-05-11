---
--- Created by shimin.
--- DateTime: 2022/3/11 15:28
--- 联盟职业每一个盟友cell
---

local UIAllianceCareerAddCell = BaseClass("UIAllianceCareerAddCell",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local name_text_path = "nameTxt"
local this_path = ""
local glow_path = "Glow"

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.name_text = self:AddComponent(UIText, name_text_path)
    self.edit_btn = self:AddComponent(UIButton, this_path)
    self.edit_btn:SetOnClick(function()
        self:OnEditBtnClick()
    end)
    self.glow_go = self:AddComponent(UIBaseContainer, glow_path)
end

local function ComponentDestroy(self)
    self.name_text = nil
    self.edit_btn = nil
    self.glow_go = nil
end


local function DataDefine(self)
    self.param = nil
end

local function DataDestroy(self)
    self.param = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self,param)
    self.param = param
    self.name_text:SetText(Localization:GetString(GameDialogDefine.MANAGER_CAREER))
    
    local totalList = DataCenter.AllianceCareerManager:GetAllianceMemberListByCareer(param.careerType)
    local posedList = DataCenter.AllianceCareerManager:GetAllianceMemberPosListByCareer(param.careerType)
    local maxNum = DataCenter.AllianceCareerManager:GetCareerMaxNum(param.careerType)
    self.glow_go:SetActive(maxNum > #posedList and #totalList > #posedList)
end

local function OnAddListener(self)
    base.OnAddListener(self)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)

end

local function OnEditBtnClick(self)
    if self.param.editCallBack ~= nil then
        self.param.editCallBack()
    end
end


UIAllianceCareerAddCell.OnCreate = OnCreate
UIAllianceCareerAddCell.OnDestroy = OnDestroy
UIAllianceCareerAddCell.ComponentDefine = ComponentDefine
UIAllianceCareerAddCell.ComponentDestroy = ComponentDestroy
UIAllianceCareerAddCell.DataDefine = DataDefine
UIAllianceCareerAddCell.DataDestroy = DataDestroy
UIAllianceCareerAddCell.OnEnable = OnEnable
UIAllianceCareerAddCell.OnDisable = OnDisable

UIAllianceCareerAddCell.OnAddListener = OnAddListener
UIAllianceCareerAddCell.OnRemoveListener = OnRemoveListener
UIAllianceCareerAddCell.ReInit = ReInit
UIAllianceCareerAddCell.OnEditBtnClick = OnEditBtnClick

return UIAllianceCareerAddCell