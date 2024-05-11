
local UIDailyHeroItem = BaseClass("UIDailyHeroItem", UIBaseContainer)
local base = UIBaseContainer

local btn_path = ""
local qualityMask_path = "qualityMask"
local icon_path = "qualityMask/icon"
local imgCamp_path = "ImgCamp"
local imgYes_path = "ImgYes"

function UIDailyHeroItem : OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UIDailyHeroItem : ComponentDefine()
    self.btn = self:AddComponent(UIButton, btn_path)
    self.btn:SetOnClick(function()
        self:OnClickHero()
    end)
    self.qualityMask = self:AddComponent(UIImage, qualityMask_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.imgCamp = self:AddComponent(UIImage, imgCamp_path)
    self.imgYes = self:AddComponent(UIBaseContainer, imgYes_path)
    self.imgYes:SetActive(false)
end

function UIDailyHeroItem : ComponentDestroy()
end

function UIDailyHeroItem : DataDefine()

end

function UIDailyHeroItem : DataDestroy()

end

function UIDailyHeroItem : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDailyHeroItem : OnEnable()
    base.OnEnable(self)
end

function UIDailyHeroItem : OnDisable()
    base.OnDisable(self)
end

function UIDailyHeroItem : OnAddListener()
    base.OnAddListener(self)
end

function UIDailyHeroItem : OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIDailyHeroItem : ReInit(itemId)
    self.itemId = itemId
    local heroId = GetTableData("custom_dailypackage",itemId, "hero")
    if heroId~=nil then
        local picPath = HeroUtils.GetHeroIconPath(heroId)
        self.icon:LoadSprite(picPath)
        local camp = HeroUtils.GetCampByHeroId(heroId)
        self.imgCamp:LoadSprite(HeroUtils.GetCampIconPath(camp))
    end
    self:OnRefreshSelect()
end

function UIDailyHeroItem:OnClickHero()
    self.view:SetSelectHeroId(self.itemId)
end
function UIDailyHeroItem:OnRefreshSelect()
    self.imgYes:SetActive(self.itemId == self.view:GetSelectHeroId())
end
return UIDailyHeroItem