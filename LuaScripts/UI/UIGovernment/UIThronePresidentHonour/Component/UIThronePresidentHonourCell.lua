--- Created by shimin
--- DateTime: 2023/3/21 16:28
--- 王座国王历史记录界面cell

local UIThronePresidentHonourCell = BaseClass("UIThronePresidentHonourCell", UIBaseContainer)
local base = UIBaseContainer

local player_head_btn_path = "go/flag/UIPlayerHead"
local player_head_icon_path = "go/flag/UIPlayerHead/HeadIcon"
local player_head_frame_path = "go/flag/UIPlayerHead/Foreground"
local name_text_path = "go/nameTxt"
local round_text_path = "levelTxt"
local time_text_path = "go/languageTxt"
local country_img_path = "go/country"
local go_path = "go"
local empty_text_path = "emptyText"

function UIThronePresidentHonourCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIThronePresidentHonourCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIThronePresidentHonourCell:OnEnable()
    base.OnEnable(self)
end

function UIThronePresidentHonourCell:OnDisable()
    base.OnDisable(self)
end

function UIThronePresidentHonourCell:ComponentDefine()
    self.player_head_btn = self:AddComponent(UIButton, player_head_btn_path)
    self.player_head_icon = self:AddComponent(UIPlayerHead, player_head_icon_path)
    self.player_head_frame = self:AddComponent(UIImage, player_head_frame_path)
    self.player_head_btn:SetOnClick(function()
        self:OnClickPlayerHead()
    end)
    self.name_text = self:AddComponent(UIText, name_text_path)
    self.round_text = self:AddComponent(UIText, round_text_path)
    self.time_text = self:AddComponent(UIText, time_text_path)
    self.country_img = self:AddComponent(UIImage, country_img_path)
    self.go = self:AddComponent(UIBaseContainer, go_path)
    self.empty_text = self:AddComponent(UIText, empty_text_path)
end

function UIThronePresidentHonourCell:ComponentDestroy()

end

function UIThronePresidentHonourCell:DataDefine()
    self.param = {}
end

function UIThronePresidentHonourCell:DataDestroy()
    self.param = {}
end

function UIThronePresidentHonourCell:OnAddListener()
    base.OnAddListener(self)
end

function UIThronePresidentHonourCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIThronePresidentHonourCell:ReInit(param)
    self.param = param
    if self.param.uid ~= nil and self.param.uid ~= "" then
        self.empty_text:SetActive(false)
        self.go:SetActive(true)

        local presidentName = ""
        if string.IsNullOrEmpty(self.param.allianceAbbr) then
            presidentName = self.param.name
        else
            presidentName = "[" .. self.param.allianceAbbr .. "] " .. self.param.name
        end
        self.name_text:SetText(presidentName)
        self.player_head_icon:SetData(self.param.uid, self.param.pic, self.param.picVer)
        local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.param.headSkinId, self.param.headSkinET)
        if headBgImg ~= nil then
            self.player_head_frame:SetActive(true)
            self.player_head_frame:LoadSprite(headBgImg)
        else
            self.player_head_frame:SetActive(false)
        end
        if LuaEntry.Player:IsHideCountryFlag() then
            self.country_img:SetActive(false)
        else
            self.country_img:SetActive(true)
            local countryConfig = nil
            if self.param.country ~= "" then
                countryConfig = DataCenter.NationTemplateManager:GetNationTemplate(self.param.country)
            else
                countryConfig = DataCenter.NationTemplateManager:GetNationTemplate(DefaultNation)
            end
            if countryConfig ~= nil then
                self.country_img:LoadSprite(countryConfig:GetNationFlagPath())
            end
        end
        self.time_text:SetText(UITimeManager:GetInstance():TimeStampToTimeForServer(self.param.beKingTime))
    else
        self.empty_text:SetActive(true)
        self.empty_text:SetLocalText(GameDialogDefine.NO_KINGS)
        self.go:SetActive(false)
    end
    self.round_text:SetLocalText(GameDialogDefine.THE_SOME_SESSION, self.param.round)
end

function UIThronePresidentHonourCell:OnClickPlayerHead()
    if self.param.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,{ anim = true, hideTop = true}, self.param.uid)
    end
end

return UIThronePresidentHonourCell