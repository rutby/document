local UIGiftItemEx = BaseClass("UIGiftItemEx", UIBaseContainer)
local base = UIBaseContainer

local Param = DataClass("Param", ParamData)
local ParamData =  {
    itemId,
    count,
    --联盟礼物
    iconName,
    itemColor,
    itemName,
    itemDes
}

local item_quality_path = "clickBtn/ImgQuality"
local item_icon_path = "clickBtn/ItemIcon"
local flag_text_path = "clickBtn/FlagGo/FlagText"
local flag_go_path = "clickBtn/FlagGo"
local count_text_path = "clickBtn/NumText"
local btn_path = "clickBtn"
local imgExtra = "clickBtn/ImgExtra"


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
    self.item_quality = self:AddComponent(UIImage, item_quality_path)
    self.item_icon = self:AddComponent(UIImage, item_icon_path)
    self.flag_text = self:AddComponent(UITextMeshProUGUIEx, flag_text_path)
    self.flag_go = self:AddComponent(UIBaseContainer, flag_go_path)
    self.count_text = self:AddComponent(UITextMeshProUGUIEx, count_text_path)
    self.imgExtra = self:AddComponent(UIImage,imgExtra)
    self.btn = self:AddComponent(UIButton, btn_path)

    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
end

--控件的销毁
local function ComponentDestroy(self)
    self.item_quality = nil
    self.item_icon = nil
    self.flag_text = nil
    self.flag_go = nil
    self.count_text = nil
    self.btn = nil
end

--变量的定义
local function DataDefine(self)
    self.param = {}
    self.flagText = nil
    self.flagActive = nil
end

--变量的销毁
local function DataDestroy(self)
    self.param = nil
    self.flagText = nil
    self.flagActive = nil
end

-- 全部刷新
local function ReInit(self,param)
    self.param = param
    self.imgExtra:SetActive(false)
    if self.param.isSimple then
        -- 仅显示图片
        self:SetFlagActive(false)
        self:SetItemIconImage(self.param.iconName)
        self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.GREEN))
        self.count_text:SetText("")
    elseif self.param.itemId == nil then
        --联盟道具
        if self.param.iconName ~= nil and self.param.itemColor ~= nil then
            self:SetFlagActive(false)
            self:SetItemIconImage(self.param.iconName)
            self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(tonumber(self.param.itemColor)))
            self.count_text:SetText("")
        elseif self.param.heroConfigId ~= nil then
            self:SetFlagActive(false)
            local _heroConfigId = self.param.heroConfigId
            self:SetItemIconImage(HeroUtils.GetHeroIconPath(_heroConfigId, false))
            local rarity = GetTableData(HeroUtils.GetHeroXmlName(), _heroConfigId, "rarity")
            local qualityimg = HeroUtils.GetRarityIconPath(rarity, false)
            self:SetItemQualityImage(qualityimg)
        end
    else
        --物品或英雄
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(self.param.itemId)
        if goods ~= nil then
            --先判断是英雄碎片还是物品
            local join_method = -1
            local icon_join = nil
            if goods.join_method ~= nil and goods.join_method > 0 and goods.icon_join ~= nil and goods.icon_join ~= "" then
                join_method = goods.join_method
                icon_join = goods.icon_join
            end

            if join_method > 0 and icon_join ~= nil and icon_join ~= "" then
                --英雄
                self:SetFlagActive(false)
                local tempJoin = string.split(icon_join,";")
                if #tempJoin > 1 then
                    self:SetItemQualityImage(tempJoin[2])
                end
                if #tempJoin > 2 then
                    self:SetItemIconImage(tempJoin[3])
                end
            else
                --物品
                self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
                if (param.count ~= nil) then
                    self:SetCountText(param.count)
                else
                    self:SetCountText("")
                end
                local itemType = goods.type
                if itemType == 2 then -- SPD
                    if goods.para1 ~= nil and goods.para1 ~= "" then
                        local para1 = goods.para1
                        local temp = string.split(para1,';')
                        if temp ~= nil and #temp > 1 then
                            self:SetFlagActive(true)
                            self:SetFlagText(temp[1]..temp[2])
                        else
                            self:SetFlagActive(false)
                        end
                    end
                elseif itemType == 3 or itemType == GOODS_TYPE.GOODS_TYPE_91 then -- USE
                    local type2 = goods.type2
                    if type2 ~= 999 and goods.para ~= nil and goods.para ~= "" then
                        local res_num = tonumber(goods.para)
                        self:SetFlagText(string.GetFormattedStr(res_num))
                        self:SetFlagActive(true)
                    else
                        self:SetFlagActive(false)
                    end
                else
                    self:SetFlagActive(false)
                end

                local iconImg = string.format(LoadPath.ItemPath, goods.icon)
                self:SetItemIconImage(iconImg)
            end
        else
            local resourceType = tonumber(self.param.itemId)
            if resourceType < 100 then
                --资源
                self:SetFlagActive(false)
                self:SetItemIconImage(DataCenter.RewardManager:GetPicByType(resourceType))
                self:SetItemQualityImage(DataCenter.ItemTemplateManager:GetToolBgByColor(ItemColor.PURPLE))
                if (self.param.count ~= nil) then
                    self:SetCountText(self.param.count)
                else
                    self:SetCountText("")
                end
            end
        end
    end
end

local function OnBtnClick(self)
    --if self.param.type and self.param.type == ResourceType.Gold then
    --	return
    --end
    --local resourceType = tonumber(self.param.itemId)
    --if resourceType < 100 then
    --	return
    --end

    if self.param.itemId ~= nil then
        local param = {}
        param["itemId"] = self.param.itemId
        param["alignObject"] = self.item_icon
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    elseif self.param.iconName ~= nil then
        local param = {}
        param["itemName"] = self.param.itemName
        param["itemDesc"] = self.param.itemDes
        param["alignObject"] = self.item_icon
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)
    end
end

local function SetItemIconImage(self,imageName)
    self.item_icon:LoadSprite(imageName)
end

local function SetItemQualityImage(self,imageName)
    self.item_quality:LoadSprite(imageName)
end

local function SetFlagActive(self,value)
    if self.flagActive ~= value then
        self.flagActive = value
        self.flag_text.gameObject:SetActive(value)
        if self.flag_go ~= nil then
            self.flag_go:SetActive(value)
        end
    end
end

local function SetFlagText(self,value)
    if self.flagText ~= value then
        self.flagText = value
        self.flag_text:SetText(value)
    end
end

local function SetCountText(self,value)
    self.count_text:SetText(value)
end

UIGiftItemEx.OnCreate = OnCreate
UIGiftItemEx.OnDestroy = OnDestroy
UIGiftItemEx.Param = Param
UIGiftItemEx.OnBtnClick = OnBtnClick
UIGiftItemEx.OnEnable = OnEnable
UIGiftItemEx.OnDisable = OnDisable
UIGiftItemEx.ComponentDefine = ComponentDefine
UIGiftItemEx.ComponentDestroy = ComponentDestroy
UIGiftItemEx.DataDefine = DataDefine
UIGiftItemEx.DataDestroy = DataDestroy
UIGiftItemEx.ReInit = ReInit
UIGiftItemEx.SetItemIconImage = SetItemIconImage
UIGiftItemEx.SetItemQualityImage = SetItemQualityImage
UIGiftItemEx.SetFlagActive = SetFlagActive
UIGiftItemEx.SetFlagText = SetFlagText
UIGiftItemEx.SetCountText = SetCountText

return UIGiftItemEx