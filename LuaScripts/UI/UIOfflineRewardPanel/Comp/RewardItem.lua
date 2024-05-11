

local RewardItem = BaseClass("RewardItem", UIBaseContainer)
local base = UIBaseContainer

local icon_path = "clickBtn/ItemIcon"
local ImgQuality_path = "clickBtn/ImgQuality"
local numTxt_path = "clickBtn/NumText"
local FlagGo_path = "clickBtn/FlagGo"

--创建
function RewardItem : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function RewardItem : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function RewardItem : ComponentDefine()
    self.icon = self:AddComponent(UIImage, icon_path)
    self.ImgQuality = self:AddComponent(UIImage, ImgQuality_path)
    self.numTxt = self:AddComponent(UITextMeshProUGUIEx, numTxt_path)
    self.FlagGo = self:AddComponent(UIBaseContainer, FlagGo_path)
    self.FlagGo:SetActive(false)
end

function RewardItem : ComponentDestroy()

end

function RewardItem : DataDefine()
    
end

function RewardItem : DataDestroy()
    
end

function RewardItem : SetData(param)
    self.param = param
    local iconPath = DataCenter.ResourceManager:GetResourceIconByType(param.rt)
    self.icon:LoadSprite(iconPath)
    self.ImgQuality:LoadSprite("Assets/Main/Sprites/ItemIcons/Common_img_quality_empty.png")
    self.numTxt:SetText(string.GetFormattedOfflineNum(param.v))
end


return RewardItem