--- Created by shimin
--- DateTime: 2023/11/23 22:41
--- 建筑建造界面cell
local UIBuildCreateCell = BaseClass("UIBuildCreateCell", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local num_text_path = "num_text"
local icon_path = "icon"
local state_icon_path = "state_icon"
local go_btn_path = "go_btn"
local go_btn_text_path = "go_btn/go_btn_text"
local line_go_path = "line"

local NormalIconScale = Vector3.New(0.35, 0.35, 0.35)

function UIBuildCreateCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIBuildCreateCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBuildCreateCell:ComponentDefine()
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
    self.icon = self:AddComponent(UIImage, icon_path)
    self.state_icon = self:AddComponent(UIImage, state_icon_path)
    self.go_btn_text = self:AddComponent(UITextMeshProUGUIEx, go_btn_text_path)
    self.go_btn = self:AddComponent(UIButton, go_btn_path)
    self.go_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGoBtnClick()
    end)
    self.line_go = self:AddComponent(UIImage, line_go_path)
end

function UIBuildCreateCell:ComponentDestroy()
end

function UIBuildCreateCell:DataDefine()
    self.param = {}
end

function UIBuildCreateCell:DataDestroy()
    self.param = {}
end

function UIBuildCreateCell:OnEnable()
    base.OnEnable(self)
end

function UIBuildCreateCell:OnDisable()
    base.OnDisable(self)
end

function UIBuildCreateCell:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.ResourceUpdated, self.Refresh)
end

function UIBuildCreateCell:OnRemoveListener()
    self:RemoveUIListener(EventId.ResourceUpdated, self.Refresh)
    base.OnRemoveListener(self)
end

function UIBuildCreateCell:ReInit(param)
    self.param = param
    self.go_btn_text:SetLocalText(GameDialogDefine.GOTO)
    self:Refresh()
end

function UIBuildCreateCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        
        local iconName = ""
        local scale = NormalIconScale
        if self.param.param.cellType == CommonCostNeedType.Resource then
            iconName = DataCenter.ResourceManager:GetResourceIconByType(self.param.param.resourceType)
        elseif self.param.param.cellType == CommonCostNeedType.Build then
            iconName = DataCenter.BuildManager:GetBuildIconPath(self.param.param.buildId, self.param.param.level)
        elseif self.param.param.cellType == CommonCostNeedType.Goods then
            iconName = DataCenter.ItemTemplateManager:GetIconPath(self.param.param.itemId)
        elseif self.param.param.cellType == CommonCostNeedType.Chapter then
            iconName = UIMainBtnIconName[UIMainFunctionInfo.Task]
        end

        -- self.icon:SetLocalScale(scale)
        self.icon:LoadSprite(iconName, nil, function()
            -- self.icon:SetNativeSize()
        end)

        if self.param.param.cellType == CommonCostNeedType.Build then
            local str = Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), 
                    self.param.param.buildId + self.param.param.level,"name")) .. " " 
                    .. Localization:GetString(GameDialogDefine.LEVEL_NUMBER, self.param.param.level)
            if self.param.param.isRed then
                self.num_text:SetText(string.format(TextColorStr, TextColorRed, str))
            else
                self.num_text:SetText(str)
            end
        elseif self.param.param.cellType == CommonCostNeedType.Chapter then
            self.num_text:SetText(string.format(TextColorStr, TextColorRed,
                    Localization:GetString(GameDialogDefine.FINISH_CHAPTER_TO_UNLOCK_WITH, self.param.param.chapterId)))
        else
            if self.param.param.isRed then
                self.num_text:SetLocalText(GameDialogDefine.SPLIT, string.format(TextColorStr, TextColorRed, 
                        string.GetFormattedStr(self.param.param.own)), string.GetFormattedStr(self.param.param.count))
            else
                self.num_text:SetLocalText(GameDialogDefine.SPLIT, string.GetFormattedStr(self.param.param.own), 
                        string.GetFormattedStr(self.param.param.count))
            end
        end

        self.state_icon:SetActive(true)
        if self.param.param.isRed then
            self.state_icon:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_img_select_no"))
            self.go_btn:SetActive(true)
        else
            self.state_icon:LoadSprite(string.format(LoadPath.CommonNewPath, "Common_img_select_yes"))
            self.go_btn:SetActive(false)
        end

        if self.param.param.isRed then
            self.go_btn:SetActive(true)
        else
            self.go_btn:SetActive(false)
        end
        if self.param.param.showLine then
            self.line_go:SetActive(true)
        else
            self.line_go:SetActive(false)
        end
    else
        self:SetActive(false)
    end
end

function UIBuildCreateCell:OnGoBtnClick()
    if self.param.param.cellType == CommonCostNeedType.Resource then
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Res
        param.id = self.param.param.resourceType
        param.targetNum = self.param.param.count
        table.insert(lackTab,param)
        GoToResLack.GoToItemResLackList(lackTab)
    elseif self.param.param.cellType == CommonCostNeedType.Goods then
        local lackTab = {}
        local param = {}
        param.type = ResLackType.Item
        param.id = self.param.param.itemId
        param.targetNum = self.param.param.count
        table.insert(lackTab,param)
        GoToResLack.GoToItemResLackList(lackTab)
    elseif self.param.param.cellType == CommonCostNeedType.Build then
        GoToUtil.InMoveCameraGotoBuild(self.param.param.buildId)
    elseif self.param.param.cellType == CommonCostNeedType.Chapter then
        GoToUtil.CloseAllWindows()
        UIManager:GetInstance():OpenWindow(UIWindowNames.UITaskMain, HideBlurPanelAnim, TaskType.Chapter)
        return
    end
end

function UIBuildCreateCell:GetBtn()
    return self.go_btn
end




return UIBuildCreateCell