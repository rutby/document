--- Created by shimin
--- DateTime: 2023/12/19 14:06
---
local UIScienceInfoPreCell = BaseClass("UIScienceInfoPreCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local icon_path = "icon"
local science_bg_path = "science_bg"
local science_icon_path = "science_bg/science_icon"
local num_text_path = "num_text"
local go_btn_path = "go_btn"
local go_btn_text_path = "go_btn/go_btn_text"
local line_path = "line"

-- 创建
function UIScienceInfoPreCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIScienceInfoPreCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIScienceInfoPreCell:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function UIScienceInfoPreCell:OnDisable()
    base.OnDisable(self)
end

--控件的定义
function UIScienceInfoPreCell:ComponentDefine()
    self.icon = self:AddComponent(UIImage, icon_path)
    self.science_bg = self:AddComponent(UIBaseContainer, science_bg_path)
    self.science_icon = self:AddComponent(UIImage, science_icon_path)
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
    self.go_btn = self:AddComponent(UIButton, go_btn_path)
    self.go_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGoBtnClick()
    end)
    self.go_btn_text = self:AddComponent(UITextMeshProUGUIEx, go_btn_text_path)
    self.line = self:AddComponent(UIBaseContainer, line_path)
end

--控件的销毁
function UIScienceInfoPreCell:ComponentDestroy()
end

--变量的定义
function UIScienceInfoPreCell:DataDefine()
    self.param = {}
end

--变量的销毁
function UIScienceInfoPreCell:DataDestroy()
    self.param = {}
end

-- 全部刷新
function UIScienceInfoPreCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIScienceInfoPreCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        if self.param.cellType == CommonCostNeedType.Build then
            self.science_bg:SetActive(false)
            self.icon:SetActive(true)
            self.icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId, self.param.level))
            self.num_text:SetText(Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), 
                    self.param.buildId + self.param.level,"name")) .. " " .. Localization:GetString(GameDialogDefine.LEVEL_NUMBER,
                    self.param.level))

        elseif self.param.cellType == CommonCostNeedType.Science then
            self.science_bg:SetActive(true)
            self.icon:SetActive(false)
            local template = DataCenter.ScienceTemplateManager:GetScienceTemplate(self.param.scienceId, self.param.level)
            if template ~= nil then
                self.science_icon:LoadSprite(string.format(LoadPath.ScienceIcons, template.icon))
                self.num_text:SetText(Localization:GetString(template.name) .. " " .. Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.param.level))
            end
        end
        self.go_btn_text:SetLocalText(GameDialogDefine.GOTO)
        self.line:SetActive(not self.param.showLine)
    else
        self:SetActive(false)
    end
end

function UIScienceInfoPreCell:OnGoBtnClick()
    if self.param.cellType == CommonCostNeedType.Build then
        local buildId = self.param.buildId
        GoToUtil.CloseAllWindows()
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(buildId)
        if buildData ~= nil and buildData:IsUpgrading() then
            GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.City_SpeedUp)
        else
            GoToUtil.GotoCityByBuildId(buildId, WorldTileBtnType.City_Upgrade)
        end
    elseif self.param.cellType == CommonCostNeedType.Science then
        self.view:GotoScience(self.param.scienceId)
    end
end

return UIScienceInfoPreCell