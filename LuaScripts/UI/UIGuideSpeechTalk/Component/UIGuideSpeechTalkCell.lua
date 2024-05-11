--- Created by shimin.
--- DateTime: 2023/11/28 14:45
--- 引导多组对话界面

local UIGuideSpeechTalkCell = BaseClass("UIGuideSpeechTalkCell", UIBaseContainer)
local base = UIBaseContainer

local pic_icon_path = "pic_icon"
local des_text_path = "des_bg/des_text"
local name_text_path = "name_bg/name_text"

function UIGuideSpeechTalkCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIGuideSpeechTalkCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGuideSpeechTalkCell:OnEnable()
    base.OnEnable(self)
end

function UIGuideSpeechTalkCell:OnDisable()
    base.OnDisable(self)
end

function UIGuideSpeechTalkCell:ComponentDefine()
    self.pic_icon = self:AddComponent(UIImage, pic_icon_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
end

function UIGuideSpeechTalkCell:ComponentDestroy()
end

function UIGuideSpeechTalkCell:DataDefine()
    self.param = {}
end

function UIGuideSpeechTalkCell:DataDestroy()
    self.param = {}
end

function UIGuideSpeechTalkCell:OnAddListener()
    base.OnAddListener(self)
end

function UIGuideSpeechTalkCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGuideSpeechTalkCell:ReInit(param)
    self.param = param
    self.pic_icon:LoadSprite(string.format(LoadPath.Guide, self.param.icon), nil, function()
        self.pic_icon:SetNativeSize()
    end)
    self.des_text:SetText(self.param.des)
    self.name_text:SetText(self.param.name or "")
    if self.param.dub ~= nil or self.param.dub ~= "" then
        DataCenter.GuideManager:PlayDub(self.param.dub)
    end
end

return UIGuideSpeechTalkCell