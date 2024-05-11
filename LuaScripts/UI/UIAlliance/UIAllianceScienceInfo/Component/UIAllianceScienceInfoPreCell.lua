--- Created by shimin
--- DateTime: 2023/12/19 14:06
---
local UIAllianceScienceInfoPreCell = BaseClass("UIAllianceScienceInfoPreCell", UIBaseContainer)
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
function UIAllianceScienceInfoPreCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function UIAllianceScienceInfoPreCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIAllianceScienceInfoPreCell:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function UIAllianceScienceInfoPreCell:OnDisable()
    base.OnDisable(self)
end

--控件的定义
function UIAllianceScienceInfoPreCell:ComponentDefine()
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
function UIAllianceScienceInfoPreCell:ComponentDestroy()
end

--变量的定义
function UIAllianceScienceInfoPreCell:DataDefine()
    self.param = {}
end

--变量的销毁
function UIAllianceScienceInfoPreCell:DataDestroy()
    self.param = {}
end

-- 全部刷新
function UIAllianceScienceInfoPreCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIAllianceScienceInfoPreCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        if self.param.cellType == CommonCostNeedType.Science then
            self.science_bg:SetActive(true)
            self.icon:SetActive(false)
            self.num_text:SetText(Localization:GetString(GetTableData(TableName.AlScienceTab, self.param.scienceId,"name")) .. " " .. Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.param.level))
            self.science_icon:LoadSprite(string.format(LoadPath.ScienceIcons, GetTableData(TableName.AlScienceTab, self.param.scienceId,"icon")))
        end
        self.go_btn_text:SetLocalText(GameDialogDefine.GOTO)
        self.line:SetActive(not self.param.showLine)
    else
        self:SetActive(false)
    end
end

function UIAllianceScienceInfoPreCell:OnGoBtnClick()
    if self.param.cellType == CommonCostNeedType.Science then
        self.view:GotoScience(self.param.scienceId)
    end
end

return UIAllianceScienceInfoPreCell