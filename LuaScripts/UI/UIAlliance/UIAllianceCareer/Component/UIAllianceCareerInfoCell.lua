---
--- Created by shimin.
--- DateTime: 2022/3/11 15:28
--- 联盟职业每一个盟友cell
---

local UIAllianceCareerInfoCell = BaseClass("UIAllianceCareerInfoCell",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local playerHead_path = "head/UIPlayerHead/HeadIcon"
local playerHeadFg_path = "head/UIPlayerHead/Foreground"
local name_text_path = "GameObject/NameTxt"
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
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        self:OnCellClick()
    end)
end

local function ComponentDestroy(self)
    self.playerHead = nil
    self.playerHeadFg = nil
    self.name_text = nil
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

local function OnCellClick(self)
    if self.param.cellCallBack ~= nil then
        self.param.cellCallBack(self.param.data,self.playerHead.transform.position.x,self.playerHead.transform.position.y)
    end
end

UIAllianceCareerInfoCell.OnCreate = OnCreate
UIAllianceCareerInfoCell.OnDestroy = OnDestroy
UIAllianceCareerInfoCell.ComponentDefine = ComponentDefine
UIAllianceCareerInfoCell.ComponentDestroy = ComponentDestroy
UIAllianceCareerInfoCell.DataDefine = DataDefine
UIAllianceCareerInfoCell.DataDestroy = DataDestroy
UIAllianceCareerInfoCell.OnEnable = OnEnable
UIAllianceCareerInfoCell.OnDisable = OnDisable
UIAllianceCareerInfoCell.OnAddListener = OnAddListener
UIAllianceCareerInfoCell.OnRemoveListener = OnRemoveListener
UIAllianceCareerInfoCell.ReInit = ReInit
UIAllianceCareerInfoCell.OnCellClick = OnCellClick

return UIAllianceCareerInfoCell