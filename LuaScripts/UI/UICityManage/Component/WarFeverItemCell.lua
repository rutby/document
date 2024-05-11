--- Created by shimin.
--- DateTime: 2021/7/29 3:59
--- 迁城界面

local WarFeverItemCell = BaseClass("WarFeverItemCell", UIBaseContainer)
local base = UIBaseContainer


local Localization = CS.GameEntry.Localization



local cityLevel_txt_Path = "Text_level"
local cityStatus_txt_Path = "Text_Statu"




--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
   -- self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)


    self.cityLevel_txt = self:AddComponent(UITextMeshProUGUIEx, cityLevel_txt_Path)
    self.cityStatus_txt = self:AddComponent(UITextMeshProUGUIEx, cityStatus_txt_Path)


end

local function ComponentDestroy(self)

    self.cityLevel_txt = nil
    self.cityStatus_txt = nil

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

local function OnAddListener(self)
    base.OnAddListener(self)

end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)

end

local function ReInit(self,param)
    self.param = param
    if self.param  ~=nil then
        self.cityLevel_txt :SetText(self.param .level)
       -- self.cityStatus_txt :SetText(self.param .statu)
        self.cityStatus_txt :SetText( UITimeManager:GetInstance():SecondToFmtStringForCountdownByDialog(self.param .statu))
    end
    
end



WarFeverItemCell.OnCreate = OnCreate
WarFeverItemCell.OnDestroy = OnDestroy
WarFeverItemCell.OnEnable = OnEnable
WarFeverItemCell.OnDisable = OnDisable
WarFeverItemCell.ComponentDefine = ComponentDefine
WarFeverItemCell.ComponentDestroy = ComponentDestroy
WarFeverItemCell.DataDefine = DataDefine
WarFeverItemCell.DataDestroy = DataDestroy
WarFeverItemCell.OnAddListener = OnAddListener
WarFeverItemCell.OnRemoveListener = OnRemoveListener
WarFeverItemCell.ReInit = ReInit



return WarFeverItemCell