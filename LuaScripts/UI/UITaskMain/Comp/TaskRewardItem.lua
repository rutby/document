

local TaskRewardItem = BaseClass("TaskRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local commonItem_path = "UICommonItem"
local imgQuality_path = "UICommonItem/clickBtn/ImgQuality"
local icon_path = "UICommonItem/clickBtn/ItemIcon"
local flagGo_path = "UICommonItem/clickBtn/FlagGo"
local numTxt_path = "UICommonItem/clickBtn/NumText"

--创建
function TaskRewardItem : OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function TaskRewardItem : OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function TaskRewardItem : ComponentDefine()
    self.item = self:AddComponent(UICommonItem, commonItem_path)
    self.imgQuality = self:AddComponent(UIImage, imgQuality_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.flagGo = self:AddComponent(UIBaseContainer, flagGo_path)
    self.numTxt = self:AddComponent(UITextMeshProUGUIEx, numTxt_path)
end

function TaskRewardItem : ComponentDestroy()

end

function TaskRewardItem : DataDefine()
    self.param = {}
end

function TaskRewardItem : DataDestroy()
    self.param = nil
end

function TaskRewardItem : ReInit(param)
    self.param = param
    self.item:ReInit(self.param)
end

function TaskRewardItem : ShowEveryDayScoreItem(score)
    self.item.btn:SetOnClick(function()
        local desc = Localization:GetString("240667")
        local name = Localization:GetString("240666")
        local param = {}
        param["itemName"] = name
        param["itemDesc"] = desc
        param["alignObject"] = self.icon
        param.isLocal = true

        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    end)
    self.imgQuality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.WHITE))
    --self.icon:LoadSprite("Assets/Main/Sprites/UI/UITaskMain/task_icon_huoyue.png")
    self.flagGo:SetActive(false)
    self.numTxt:SetText(string.GetFormattedSeperatorNum(score))
end

return TaskRewardItem