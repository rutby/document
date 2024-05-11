--- Created by shimin.
--- DateTime: 2024/2/21 21:19
--- UIMain建筑列表cell

local UIMainBuildCell = BaseClass("UIMainBuildCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""

function UIMainBuildCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIMainBuildCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

--控件的定义
function UIMainBuildCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self.icon = self:AddComponent(UIImage, this_path)
end

--控件的销毁
function UIMainBuildCell:ComponentDestroy()
end

function UIMainBuildCell:DataDefine()
    self.buildId = 0
end

function UIMainBuildCell:DataDestroy()
    self.buildId = 0
end

function UIMainBuildCell:ReInit(param)
    self.buildId = param
    self.icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(self.buildId, 1))
end

function UIMainBuildCell:OnEnable()
    base.OnEnable(self)
end

function UIMainBuildCell:OnDisable()
    base.OnDisable(self)
end

function UIMainBuildCell:OnBtnClick()
    GoToUtil.GotoCityByBuildId(self.buildId)
end


return UIMainBuildCell