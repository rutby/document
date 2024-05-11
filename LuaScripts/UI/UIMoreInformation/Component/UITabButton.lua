local UITabButton = BaseClass("UITabButton", UIBaseContainer)
local base = UIBaseContainer

local checkMark_path = "Background/Checkmark"
local this_path = ""
local selectName_path = "checkText"
local unselectName_path = "text"

-- 创建
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

-- 显示
local function OnEnable(self)
    base.OnEnable(self)
end

-- 隐藏
local function OnDisable(self)
    base.OnDisable(self)
end


--控件的定义
local function ComponentDefine(self)
    self.checkMark = self:AddComponent(UIImage, checkMark_path)
    self.btn = self:AddComponent(UIButton, this_path)
    self.selectName = self:AddComponent(UITextMeshProUGUIEx, selectName_path)
    self.unselectName = self:AddComponent(UITextMeshProUGUIEx, unselectName_path)
    self.btn:SetOnClick(function()
        CS.GameEntry.Sound:PlayEffect(SoundAssets.Music_Effect_common_switch)
        self:OnBtnClick()
    end)
end

--控件的销毁
local function ComponentDestroy(self)

end

--变量的定义
local function DataDefine(self)
    self.param = {}
end

--变量的销毁
local function DataDestroy(self)
    self.param = nil
end

-- 全部刷新
local function ReInit(self,param)
    self.param = param
    self:SetSelect(param.isSelect)
    self.selectName:SetLocalText(self.param.nameStr)
    self.unselectName:SetLocalText(self.param.nameStr)
end


local function OnBtnClick(self)
    if not self.param.isSelect then
        if self.param.callBack ~= nil then
            self.param.callBack(self.param.tabType)
        end
    end
end

local function SetSelect(self, value)
    self.param.isSelect = value
    if value then
        self.checkMark:SetActive(true)
        self.selectName:SetActive(true)
        self.unselectName:SetActive(false)
    else
        self.checkMark:SetActive(false)
        self.selectName:SetActive(false)
        self.unselectName:SetActive(true)
    end
end

UITabButton.OnCreate = OnCreate
UITabButton.OnDestroy = OnDestroy
UITabButton.OnEnable = OnEnable
UITabButton.OnDisable = OnDisable
UITabButton.ComponentDefine = ComponentDefine
UITabButton.ComponentDestroy = ComponentDestroy
UITabButton.DataDefine = DataDefine
UITabButton.DataDestroy = DataDestroy
UITabButton.ReInit = ReInit
UITabButton.OnBtnClick = OnBtnClick
UITabButton.SetSelect = SetSelect

return UITabButton