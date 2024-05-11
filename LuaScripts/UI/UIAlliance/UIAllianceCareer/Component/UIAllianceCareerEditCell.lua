---
--- Created by shimin.
--- DateTime: 2022/3/11 15:28
--- 联盟职业每一个盟友cell
---

local UIAllianceCareerEditCell = BaseClass("UIAllianceCareerEditCell",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local playerHead_path = "head/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "head/UIPlayerHead/Foreground"
local name_text_path = "GameObject/NameTxt"
local select_go_path = "selectObj"
local this_path = ""

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
    self.playerHead = self:AddComponent(UIPlayerHead, playerHead_path)
    self.playerHeadFg = self:AddComponent(UIImage, playerHeadFg_path)
    self.name_text = self:AddComponent(UIText, name_text_path)
    self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        self:OnBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.playerHead = nil
    self.playerHeadFg = nil
    self.name_text = nil
    self.select_go = nil
    self.btn = nil
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
    self.playerHead:SetData(self.param.data.uid,self.param.data.pic,self.param.data.picVer)
    self.name_text:SetText(self.param.data.name)
    local tempFg = self.param.data:GetHeadBgImg()
    if tempFg then
        self.playerHeadFg:SetActive(true)
        self.playerHeadFg:LoadSprite(tempFg)
    else
        self.playerHeadFg:SetActive(false)
    end
    self:SetSelect(self.param.data.careerPos == AllianceCareerPosType.Yes)
    if self.param.data.uid == LuaEntry.Player.uid then
        self.name_text:SetColor(AllianceCareerSelfColor)
    else
        self.name_text:SetColor(description1_color)
    end
end

local function OnAddListener(self)
    base.OnAddListener(self)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)

end

local function OnBtnClick(self)
    if self.param.selectCallBack ~= nil then
        self.param.selectCallBack(self.param.index)
    end
end

local function SetSelect(self,isSelect)
    self.select_go:SetActive(isSelect)
end


UIAllianceCareerEditCell.OnCreate = OnCreate
UIAllianceCareerEditCell.OnDestroy = OnDestroy
UIAllianceCareerEditCell.ComponentDefine = ComponentDefine
UIAllianceCareerEditCell.ComponentDestroy = ComponentDestroy
UIAllianceCareerEditCell.DataDefine = DataDefine
UIAllianceCareerEditCell.DataDestroy = DataDestroy
UIAllianceCareerEditCell.OnEnable = OnEnable
UIAllianceCareerEditCell.OnDisable = OnDisable
UIAllianceCareerEditCell.OnAddListener = OnAddListener
UIAllianceCareerEditCell.OnRemoveListener = OnRemoveListener
UIAllianceCareerEditCell.ReInit = ReInit
UIAllianceCareerEditCell.OnBtnClick = OnBtnClick
UIAllianceCareerEditCell.SetSelect = SetSelect

return UIAllianceCareerEditCell