--- Toggle改成Button的组件
--- Created by shimin.
--- DateTime: 2024/1/9 15:22

local UICommonToggleBtnTab = BaseClass("UICommonToggleBtnTab", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local on_path = "Background/Checkmark"
local on_name_path = "on_text"
local off_name_path = "off_text"
local red_go_path = "RedPointNum"
local red_num_text_path = "RedPointNum/red_num_text"

function UICommonToggleBtnTab:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UICommonToggleBtnTab:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICommonToggleBtnTab:OnEnable()
    base.OnEnable(self)
end

function UICommonToggleBtnTab:OnDisable()
    base.OnDisable(self)
end

function UICommonToggleBtnTab:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_common_switch)
        self:OnClick()
    end)
    self.on_go = self:AddComponent(UIBaseContainer, on_path)
    self.on_name_text = self:AddComponent(UITextMeshProUGUIEx, on_name_path)
    self.off_name_text = self:AddComponent(UITextMeshProUGUIEx, off_name_path)
    self.red_go = self:AddComponent(UIBaseContainer, red_go_path)
    self.red_num_text = self:AddComponent(UITextMeshProUGUIEx, red_num_text_path)
end

function UICommonToggleBtnTab:ComponentDestroy()
end

function UICommonToggleBtnTab:DataDefine()
    self.param = {}
end
function UICommonToggleBtnTab:DataDestroy()
    self.param = {}
end

function UICommonToggleBtnTab:OnAddListener()
    base.OnAddListener(self)
end

function UICommonToggleBtnTab:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UICommonToggleBtnTab:ReInit(param)
    self.param = param
    self:Refresh()
end

function UICommonToggleBtnTab:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self.on_name_text:SetText(self.param.name)
        self.off_name_text:SetText(self.param.name)
        if self.param.select then
            self.on_go:SetActive(true)
            self.on_name_text:SetActive(true)
            self.off_name_text:SetActive(false)
        else
            self.on_go:SetActive(false)
            self.on_name_text:SetActive(false)
            self.off_name_text:SetActive(true)
        end
        self:RefreshRed()
    else
        self:SetActive(false)
    end
end

function UICommonToggleBtnTab:SetName(name)
    self.param.name = name
    self:Refresh()
end

function UICommonToggleBtnTab:SetOnClick(onClick)
    self.param.callback = onClick
end

function UICommonToggleBtnTab:SetSelect(select)
    self.param.select = select
    self:Refresh()
end

function UICommonToggleBtnTab:OnClick()
    if (not self.param.select) and self.param.callback ~= nil then
        self.param.callback(self.param.index)
    end
end

function UICommonToggleBtnTab:SetRedNum(isShowRed, num)
    self.param.isShowRed = isShowRed
    self.param.redNum = num
    self:RefreshRed()
end

function UICommonToggleBtnTab:RefreshRed()
    if self.param.isShowRed then
        self.red_go:SetActive(true)
        if self.param.redNum ~= nil and self.param.redNum > 0 then
            self.red_num_text:SetActive(true)
            self.red_num_text:SetText(tonumber(self.param.redNum))
        else
            self.red_num_text:SetActive(false)
        end
    else
        self.red_go:SetActive(false)
    end
end

return UICommonToggleBtnTab