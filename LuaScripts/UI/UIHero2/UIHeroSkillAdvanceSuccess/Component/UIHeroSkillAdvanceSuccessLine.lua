
local UIHeroSkillAdvanceSuccessLine = BaseClass("UIHeroSkillAdvanceSuccessLine", UIBaseContainer)
local base = UIBaseContainer

local desc_path = "Desc"
local desc1_path = "Desc1"

local left_val_path = "LeftVal"
local right_val_path = "RightVal"
local right_val1_path = "RightVal1"
local arrow_path = "Arrow"
local function OnCreate(self)
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.desc_text = self:AddComponent(UIText, desc_path)
    self.desc1_text = self:AddComponent(UIText, desc1_path)
    self.arrow = self:AddComponent(UIImage, arrow_path)
    self.left_val_text = self:AddComponent(UIText, left_val_path)
    self.right_val_text = self:AddComponent(UIText, right_val_path)
    self.right_val1_text = self:AddComponent(UIText, right_val1_path)
end

local function ComponentDestroy(self)
    self.desc_text = nil
    self.left_val_text = nil
    self.right_val_text = nil
end

local function DataDefine(self)
    
end

local function DataDestroy(self)
    
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function SetData(self, desc, leftVal, rightVal)
    self.desc_text:SetActive(false)
    self.desc1_text:SetActive(false)
    self.arrow:SetActive(false)
    self.left_val_text:SetActive(false)
    self.right_val_text:SetActive(false)
    self.right_val1_text:SetActive(false)

    if leftVal == nil then
        self.desc1_text:SetText(desc)
        self.right_val1_text:SetText(rightVal)
        self.desc1_text:SetActive(true)
        self.right_val1_text:SetActive(true)

    else
        self.desc_text:SetActive(true)
        self.arrow:SetActive(true)
        self.left_val_text:SetActive(true)
        self.right_val_text:SetActive(true)

        self.desc_text:SetText(desc)
        self.left_val_text:SetText(leftVal)
        self.right_val_text:SetText(rightVal)
        self.right_val_text:SetColor(leftVal == rightVal and WhiteColor or LightGreenColor)
    end
end

UIHeroSkillAdvanceSuccessLine.OnCreate= OnCreate
UIHeroSkillAdvanceSuccessLine.OnDestroy = OnDestroy
UIHeroSkillAdvanceSuccessLine.ComponentDefine = ComponentDefine
UIHeroSkillAdvanceSuccessLine.ComponentDestroy = ComponentDestroy
UIHeroSkillAdvanceSuccessLine.DataDefine = DataDefine
UIHeroSkillAdvanceSuccessLine.DataDestroy = DataDestroy
UIHeroSkillAdvanceSuccessLine.OnEnable = OnEnable
UIHeroSkillAdvanceSuccessLine.OnDisable = OnDisable

UIHeroSkillAdvanceSuccessLine.SetData = SetData

return UIHeroSkillAdvanceSuccessLine