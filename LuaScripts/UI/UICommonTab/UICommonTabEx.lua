--- 新TextMeshProTab
--- Created by shimin.
--- DateTime: 2023/11/16 14:35

local UICommonTabEx = BaseClass("UICommonTabEx", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local on_path = "On"
local on_name_path = "On/OnName"
local off_path = "Off"
local off_name_path = "Off/OffName"

function UICommonTabEx:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UICommonTabEx:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UICommonTabEx:OnEnable()
    base.OnEnable(self)
end

function UICommonTabEx:OnDisable()
    base.OnDisable(self)
end

function UICommonTabEx:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_common_switch)
        self:OnClick()
    end)
    self.on_go = self:AddComponent(UIBaseContainer, on_path)
    self.on_name_text = self:AddComponent(UITextMeshProUGUIEx, on_name_path)
    self.off_go = self:AddComponent(UIBaseContainer, off_path)
    self.off_name_text = self:AddComponent(UITextMeshProUGUIEx, off_name_path)
end

function UICommonTabEx:ComponentDestroy()
end

function UICommonTabEx:DataDefine()
    self.param = {}
end
function UICommonTabEx:DataDestroy()
    self.param = {}
end

function UICommonTabEx:OnAddListener()
    base.OnAddListener(self)
end

function UICommonTabEx:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UICommonTabEx:ReInit(param)
    self.param = param
    self:Refresh()
end

function UICommonTabEx:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self.on_name_text:SetText(self.param.name)
        self.off_name_text:SetText(self.param.name)
        if self.param.select then
            self.on_go:SetActive(true)
            self.off_go:SetActive(false)
        else
            self.on_go:SetActive(false)
            self.off_go:SetActive(true)
        end
    else
        self:SetActive(false)
    end
end

function UICommonTabEx:SetName(name)
    self.param.name = name
    self:Refresh()
end

function UICommonTabEx:SetOnClick(onClick)
    self.param.callback = onClick
end

function UICommonTabEx:SetSelect(select)
    self.param.select = select
    self:Refresh()
end

function UICommonTabEx:OnClick()
    if (not self.param.select) and self.param.callback ~= nil then
        self.param.callback(self.param.index)
    end
end

return UICommonTabEx