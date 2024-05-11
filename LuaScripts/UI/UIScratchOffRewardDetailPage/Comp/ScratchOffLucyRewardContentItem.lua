---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1020.
--- DateTime: 2023/5/23 14:47
---

local ScratchOffLucyRewardItem = BaseClass("ScratchOffLucyRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local desTxt_path = "desTxt"
local icon1_path = "icon1"
local icon2_path = "icon2"
local icon3_path = "icon3"

-- 创建
function ScratchOffLucyRewardItem : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function ScratchOffLucyRewardItem : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function ScratchOffLucyRewardItem : DataDefine()

end

function ScratchOffLucyRewardItem : DataDestroy()

end

function ScratchOffLucyRewardItem : ComponentDefine()
    self.desTxt = self:AddComponent(UIText, desTxt_path)
    self.icon1 = self:AddComponent(UIImage, icon1_path)
    self.icon2 = self:AddComponent(UIImage, icon2_path)
    self.icon3 = self:AddComponent(UIImage, icon3_path)
end

function ScratchOffLucyRewardItem : ComponentDestroy()
    
end

function ScratchOffLucyRewardItem : SetData(itemInfo)
    if itemInfo == nil then
        return
    end

    self.desTxt:SetText(Localization:GetString("372940", itemInfo.diamondProportion.."%"))
    self.icon1:LoadSprite(itemInfo.icon)
    self.icon2:LoadSprite(itemInfo.icon)
    self.icon3:LoadSprite(itemInfo.icon)
end

return ScratchOffLucyRewardItem