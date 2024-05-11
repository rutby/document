--- Created by shimin.
--- DateTime: 2023/11/7 10:36
--- 升级界面家具升级家具cell
local UIFurnitureUpgradeFurnitureCell = BaseClass("UIPveBuffCell", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local icon_path = "Icon"
local new_go_path = "new_go"
local level_go_path = "level_go"
local level_text_path = "level_go/level_text"
local bg_path = "bg"
local work_state_icon_path = "work_state_icon"

local AnimName =
{
    Select = "select",
    UnSelect = "unselect",
}

function UIFurnitureUpgradeFurnitureCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIFurnitureUpgradeFurnitureCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIFurnitureUpgradeFurnitureCell:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self.anim = self:AddComponent(UIAnimator, this_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.new_go = self:AddComponent(UIBaseContainer, new_go_path)
    self.level_go = self:AddComponent(UIImage, level_go_path)
    self.level_text = self:AddComponent(UITextMeshProUGUIEx, level_text_path)
    self.bg = self:AddComponent(UIImage, bg_path)
    self.work_state_icon = self:AddComponent(UIImage, work_state_icon_path)
    
end

function UIFurnitureUpgradeFurnitureCell:ComponentDestroy()
end

function UIFurnitureUpgradeFurnitureCell:DataDefine()
    self.param = {}
    self.selectBgName = ""
    self.useItem = false
end

function UIFurnitureUpgradeFurnitureCell:DataDestroy()
    self.param = {}
    self.selectBgName = ""
    self.useItem = false
end

function UIFurnitureUpgradeFurnitureCell:OnEnable()
    base.OnEnable(self)
end

function UIFurnitureUpgradeFurnitureCell:OnDisable()
    base.OnDisable(self)
end

function UIFurnitureUpgradeFurnitureCell:OnAddListener()
    base.OnAddListener(self)
end

function UIFurnitureUpgradeFurnitureCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIFurnitureUpgradeFurnitureCell:ReInit(param)
    self.param = param
    self:Refresh()
end


function UIFurnitureUpgradeFurnitureCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self.useItem = false
        local level = 0
        local data = DataCenter.FurnitureManager:GetFurnitureByBuildUuid(self.param.param.buildUuid, self.param.param.furnitureId, self.param.param.fIndex)
        if data == nil then
            --建造
            self.level_go:SetActive(false)
            local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.param.furnitureId, 0)
            if buildLevelTemplate ~= nil then
                self.selectBgName = "Common_bg_item3"
                local cost = buildLevelTemplate:GetNeedItem()
                if cost[1] == nil then
                    self.useItem = false
                else
                    self.useItem = true
                end

                if buildLevelTemplate ~= nil and buildLevelTemplate.need_worker > 0 then
                    self.work_state_icon:SetActive(true)
                    self.work_state_icon:LoadSprite(string.format(LoadPath.UIFurniture, "UIfurniture_work_state1"))
                else
                    self.work_state_icon:SetActive(false)
                end
            end
        else
            --升级
            self.level_go:SetActive(true)
            level = data.lv
            self.level_text:SetText(tostring(data.lv))
            if self.param.param.canUpgrade then
                self.level_go:LoadSprite(string.format(LoadPath.UIFurniture, "UIfurniture_itemnumbg2"))
            else
                self.level_go:LoadSprite(string.format(LoadPath.UIFurniture, "UIfurniture_itemnumbg3"))
            end

            local buildLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.param.furnitureId, data.lv)
            if buildLevelTemplate ~= nil and buildLevelTemplate.need_worker > 0 then
                self.work_state_icon:SetActive(true)
                local furnitureResidentDataList = DataCenter.VitaManager:GetResidentDataListByFurnitureUuid(data.uuid)
                if #furnitureResidentDataList < buildLevelTemplate.need_worker then
                    self.work_state_icon:LoadSprite(string.format(LoadPath.UIFurniture, "UIfurniture_work_state1"))
                else
                    self.work_state_icon:LoadSprite(string.format(LoadPath.UIFurniture, "UIfurniture_work_state2"))
                end
            else
                self.work_state_icon:SetActive(false)
            end
            if buildLevelTemplate ~= nil then
                self.selectBgName = "Common_bg_item2"
                local cost = buildLevelTemplate:GetNeedItem()
                if cost[1] == nil then
                    self.useItem = false
                else
                    self.useItem = true
                end
            end
        end
        self.icon:LoadSprite(string.format(LoadPath.Furniture,
                GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.param.param.furnitureId + level,"pic")))
        self.bg:LoadSprite(string.format(LoadPath.CommonNewPath, self.selectBgName))
        if self.param.param.isNew then
            self.new_go:SetActive(true)
        else
            self.new_go:SetActive(false)
        end

        self:SetUnSelect()
    else
        self:SetActive(false)
    end
end


function UIFurnitureUpgradeFurnitureCell:OnBtnClick()
    if self.param.param.callback ~= nil then
        self.param.param.callback(self.param.param.index)
    end
end

function UIFurnitureUpgradeFurnitureCell:SetSelect(go)
    go:SetActive(true)
    go.transform:SetParent(self.transform)
    go:SetLocalPosition(ResetPosition)
    go:SetLocalScale(ResetScale)
    self.anim:Play(AnimName.Select, 0, 0)
    if self.useItem then
        self.bg:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_bg_item4"))
    else
        self.bg:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_bg_item2"))
    end
end

function UIFurnitureUpgradeFurnitureCell:SetUnSelect()
    self.anim:Play(AnimName.UnSelect, 0, 0)
    self.bg:LoadSprite(string.format(LoadPath.CommonNewPath, self.selectBgName))
end

function UIFurnitureUpgradeFurnitureCell:GetIconPosition()
    return self.icon:GetPosition()
end


return UIFurnitureUpgradeFurnitureCell