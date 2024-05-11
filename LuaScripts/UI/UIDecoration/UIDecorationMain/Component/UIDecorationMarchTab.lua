--- Created by shimin
--- DateTime: 2023/8/23 21:44
--- 运兵车tab

local UIDecorationMarchTab = BaseClass("UIDecorationMarchTab", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local car_text_path = "car_text"
local select_go_path = "select_go"
local car_img_path = "car_img"
local car_num_bg_path = "car_num_bg"

local SelectColor = Color.New(1, 1, 1, 1)
local UnSelectColor = Color.New(0.6, 0.6, 0.6, 1)

function UIDecorationMarchTab:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIDecorationMarchTab:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIDecorationMarchTab:OnEnable()
    base.OnEnable(self)
end

function UIDecorationMarchTab:OnDisable()
    base.OnDisable(self)
end

function UIDecorationMarchTab:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnBtnClick()
    end)
    self.car_text = self:AddComponent(UITextMeshProUGUIEx, car_text_path)
    self.select_go = self:AddComponent(UIBaseContainer, select_go_path)
    self.car_img = self:AddComponent(UIImage, car_img_path)
    self.car_bg_img = self:AddComponent(UIImage, this_path)
    self.car_num_bg = self:AddComponent(UIImage, car_num_bg_path)
end

function UIDecorationMarchTab:ComponentDestroy()

end

function UIDecorationMarchTab:DataDefine()
    self.param = {}
end

function UIDecorationMarchTab:DataDestroy()
    self.param = {}
end

function UIDecorationMarchTab:OnAddListener()
    base.OnAddListener(self)
end

function UIDecorationMarchTab:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIDecorationMarchTab:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIDecorationMarchTab:Refresh()
    if self.param.visible then
        self:SetActive(true)
        self:Select(self.param.select)
        self.car_text:SetText(tostring(self.param.index))
        local currentSkinId = DataCenter.DecorationDataManager:GetCurrentSkinByType(DecorationType.DecorationType_MarchSkin, self.param.uuid)
        if currentSkinId ~= nil then
            local template = DataCenter.DecorationTemplateManager:GetTemplate(currentSkinId)
            if template ~= nil then
                self.car_img:LoadSprite(template.icon)
            end
        end
    else
        self:SetActive(false)
    end
end

function UIDecorationMarchTab:OnBtnClick()
    if not self.param.select then
        if self.param.onMarchTabBtnClick ~= nil then
            self.param.onMarchTabBtnClick(self.param.index, self.param.uuid)
        end
    end
end

function UIDecorationMarchTab:Select(select)
    self.param.select = select
    if select then
        self.select_go:SetActive(true)
        self.car_bg_img:SetColor(SelectColor)
        self.car_num_bg:SetColor(SelectColor)
        self.car_img:SetColor(SelectColor)
        self.car_text:SetColor(SelectColor)
    else
        self.select_go:SetActive(false)
        self.car_bg_img:SetColor(UnSelectColor)
        self.car_num_bg:SetColor(UnSelectColor)
        self.car_img:SetColor(UnSelectColor)
        self.car_text:SetColor(UnSelectColor)
    end
end

return UIDecorationMarchTab