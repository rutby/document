---
--- Created by shimin.
--- DateTime: 2022/3/11 15:28
--- 联盟职业每一个盟友cell
---

local UIAllianceCareerChangeCell = BaseClass("UIAllianceCareerChangeCell",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local playerHead_path = "head/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "head/UIPlayerHead/Foreground"
local name_text_path = "GameObject/NameTxt"
local close_btn_path = "CloseBtn"
local edit_btn_path = ""


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
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        self:OnCloseBtnClick()
    end)
    self.edit_btn = self:AddComponent(UIButton, edit_btn_path)
    self.edit_btn:SetOnClick(function()
        self:OnEditBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.playerHead = nil
    self.playerHeadFg = nil
    self.name_text = nil
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

local function OnCloseBtnClick(self)
    if self.param.closeCallBack ~= nil then
        self.param.closeCallBack(self.param.data)
    end
end
local function OnEditBtnClick(self)
    if self.param.editCallBack ~= nil then
        self.param.editCallBack()
    end
end


UIAllianceCareerChangeCell.OnCreate = OnCreate
UIAllianceCareerChangeCell.OnDestroy = OnDestroy
UIAllianceCareerChangeCell.ComponentDefine = ComponentDefine
UIAllianceCareerChangeCell.ComponentDestroy = ComponentDestroy
UIAllianceCareerChangeCell.DataDefine = DataDefine
UIAllianceCareerChangeCell.DataDestroy = DataDestroy
UIAllianceCareerChangeCell.OnEnable = OnEnable
UIAllianceCareerChangeCell.OnDisable = OnDisable

UIAllianceCareerChangeCell.OnAddListener = OnAddListener
UIAllianceCareerChangeCell.OnRemoveListener = OnRemoveListener
UIAllianceCareerChangeCell.ReInit = ReInit
UIAllianceCareerChangeCell.OnCloseBtnClick = OnCloseBtnClick
UIAllianceCareerChangeCell.OnEditBtnClick = OnEditBtnClick

return UIAllianceCareerChangeCell