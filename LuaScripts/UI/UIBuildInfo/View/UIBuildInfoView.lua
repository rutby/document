--- Created by shimin
--- DateTime: 2024/01/08 17:06
--- 建筑信息界面

local UIBuildInfoView = BaseClass("UIBuildInfoView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local UIDesCell = require "UI.UIBuildCreate.Component.UIDesCell"

local panel_btn_path = "UICommonMidPopUpTitle/panel"
local title_text_path = "UICommonMidPopUpTitle/bg_mid/titleText"
local close_btn_path = "UICommonMidPopUpTitle/bg_mid/CloseBtn"
local build_icon_path = "build_icon"
local build_level_text_path = "build_level_text"
local attr_go_path = "scroll_view/Viewport/Content/attr_go"
local attr_name_text_path = "scroll_view/Viewport/Content/attr_go/attr_name_text"
local des_title_text_path = "scroll_view/Viewport/Content/des_go/des_title_text"
local des_text_path = "scroll_view/Viewport/Content/des_go/des_bg/des_text"
local detail_btn_path = "MidBtnYellow"
local detail_btn_text_path = "MidBtnYellow/btnText"


function UIBuildInfoView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

function UIBuildInfoView:ComponentDefine()
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.close_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.panel_btn = self:AddComponent(UIButton, panel_btn_path)
    self.panel_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self.ctrl:CloseSelf()
    end)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.attr_go = self:AddComponent(UIBaseContainer, attr_go_path)
    self.attr_name_text = self:AddComponent(UITextMeshProUGUIEx, attr_name_text_path)
    self.build_icon = self:AddComponent(UIImage, build_icon_path)
    self.build_level_text = self:AddComponent(UITextMeshProUGUIEx, build_level_text_path)
    self.des_title_text = self:AddComponent(UITextMeshProUGUIEx, des_title_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
    self.detail_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnDetailBtnClick()
    end)
    self.detail_btn_text = self:AddComponent(UITextMeshProUGUIEx, detail_btn_text_path)
end

function UIBuildInfoView:ComponentDestroy()
end

function UIBuildInfoView:DataDefine()
    self.list = {}
    self.param = {}
    self.desList = {}
    self.desCells = {}
end

function UIBuildInfoView:DataDestroy()
    self.list = {}
    self.param = {}
    self.desList = {}
    self.desCells = {}
end

function UIBuildInfoView:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIBuildInfoView:OnEnable()
    base.OnEnable(self)
end

function UIBuildInfoView:OnDisable()
    base.OnDisable(self)
end

function UIBuildInfoView:OnAddListener()
    base.OnAddListener(self)
end

function UIBuildInfoView:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIBuildInfoView:ReInit()
    self.param = self:GetUserData()
    self.attr_name_text:SetLocalText(GameDialogDefine.ADDITION)
    self.des_title_text:SetLocalText(GameDialogDefine.BUILD_INFO)
    self.detail_btn_text:SetLocalText(GameDialogDefine.BUILD_INFO)
    self:Refresh()
end

function UIBuildInfoView:Refresh()
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
    if buildData ~= nil then
        self.title_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.param.buildId + buildData.level,"name"))
        self.build_level_text:SetLocalText(GameDialogDefine.LEVEL_NUMBER, buildData.level)
        self.build_icon:LoadSprite(DataCenter.BuildManager:GetBuildIconPath(self.param.buildId, buildData.level))
        self.des_text:SetLocalText(GetTableData(DataCenter.BuildTemplateManager:GetTableName(), self.param.buildId + buildData.level,"description"))
    end
    self:ShowDesCells()
end

function UIBuildInfoView:OnDetailBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIBuildDetail, NormalBlurPanelAnim, self.param.buildId)
end

function UIBuildInfoView:ShowDesCells()
    self:GetDesList()
    local count = #self.desList
    if count > 0 then
        for k, v in ipairs(self.desList) do
            if self.desCells[k] == nil then
                local param = {}
                self.desCells[k] = param
                param.visible = true
                param.param = v
                param.req = self:GameObjectInstantiateAsync(UIAssets.UIBuildUpgradeDesCell, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject
                    go:SetActive(true)
                    go.transform:SetParent(self.attr_go.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    go.transform:SetAsLastSibling()
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local model = self.attr_go:AddComponent(UIDesCell, nameStr)
                    model:ReInit(param)
                    param.model = model
                end)
            else
                self.desCells[k].visible = true
                self.desCells[k].param = v
                if self.desCells[k].model ~= nil then
                    self.desCells[k].model:Refresh()
                end
            end
        end
    end
    local cellCount = #self.desCells
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.desCells[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:Refresh()
                end
            end
        end
    end
end

function UIBuildInfoView:GetDesList()
    self.desList = {}
    local desTemplate = DataCenter.BuildTemplateManager:GetBuildingDesTemplate(self.param.buildId)
    if desTemplate ~= nil then
        local maxCount = #desTemplate.effect_local
        local buildData = DataCenter.BuildManager:GetFunbuildByItemID(self.param.buildId)
        if buildData ~= nil then
            local curLevelTemplate = DataCenter.BuildTemplateManager:GetBuildingLevelTemplate(self.param.buildId, buildData.level)
            if maxCount > 0 then
                if curLevelTemplate.local_num[maxCount] == nil then
                    maxCount = #curLevelTemplate.local_num
                end
            end
            if curLevelTemplate ~= nil then
                if maxCount > 0 then
                    for i = 1, maxCount, 1 do
                        local showParam = desTemplate:GetShowLocalEffect(i)
                        if showParam ~= nil then
                            local param = {}
                            param.name = Localization:GetString(showParam[1])
                            local type = showParam[2]
                            if type == EffectLocalType.Dialog then
                                param.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(curLevelTemplate.local_num[i], type) or ""
                            else
                                local cur = tonumber(curLevelTemplate.local_num[i]) or 0
                                if cur ~= 0 then
                                    param.curValue = DataCenter.BuildManager:GetEffectNumWithoutSymbolByType(tonumber(curLevelTemplate.local_num[i]) or 0, type)
                                else
                                    param.curValue = cur
                                end
                            end
                            if param.curValue ~= "" then
                                table.insert(self.desList, param)
                            end
                        end
                    end
                end

                if DataCenter.BuildManager:CanShowPower() then
                    local param = {}
                    param.name = Localization:GetString(GameDialogDefine.POWER)
                    local cur = curLevelTemplate.power
                    param.curValue = cur
                    table.insert(self.desList, param)
                end
            end
        end
    end
end

return UIBuildInfoView