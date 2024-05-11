--- Created by shimin
--- DateTime: 2023/3/21 10:51
--- 王座发奖界面cell

local UIThroneRewardSelectMemberCell = BaseClass("UIThroneRewardSelectMemberCell", UIBaseContainer)
local base = UIBaseContainer

local player_head_btn_path = "head/UIPlayerHead"
local player_head_icon_path = "head/UIPlayerHead/HeadIcon"
local player_head_frame_path = "head/UIPlayerHead/Foreground"
local show_btn_path = "showBtn"
local power_text_path = "power"
local sex_node_path = "NameLayoutGo/SexNode"
local sex_img_path = "NameLayoutGo/SexNode/SexImg"
local player_name_text_path = "NameLayoutGo/NameTxt"
local check_box_path = "checkBox"
local select_path = "checkBox/select"

function UIThroneRewardSelectMemberCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIThroneRewardSelectMemberCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIThroneRewardSelectMemberCell:OnEnable()
    base.OnEnable(self)
end

function UIThroneRewardSelectMemberCell:OnDisable()
    base.OnDisable(self)
end

function UIThroneRewardSelectMemberCell:ComponentDefine()
    self.player_name_text = self:AddComponent(UIText, player_name_text_path)
    self.power_text = self:AddComponent(UIText, power_text_path)
    self.sex_node = self:AddComponent(UIBaseContainer, sex_node_path)
    self.sex_img = self:AddComponent(UIImage, sex_img_path)
    self.check_box = self:AddComponent(UIBaseContainer, check_box_path)
    self.select = self:AddComponent(UIBaseContainer, select_path)
    self.player_head_btn = self:AddComponent(UIButton, player_head_btn_path)
    self.player_head_icon = self:AddComponent(UIPlayerHead, player_head_icon_path)
    self.player_head_frame = self:AddComponent(UIImage, player_head_frame_path)
    self.player_head_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnClickPlayerHead()
    end)
    self.show_btn = self:AddComponent(UIButton, show_btn_path)
    self.show_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnShowBtnClick()
    end)
end

function UIThroneRewardSelectMemberCell:ComponentDestroy()

end

function UIThroneRewardSelectMemberCell:DataDefine()
    self.param = {}
end

function UIThroneRewardSelectMemberCell:DataDestroy()
    self.param = {}
end

function UIThroneRewardSelectMemberCell:OnAddListener()
    base.OnAddListener(self)
end

function UIThroneRewardSelectMemberCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIThroneRewardSelectMemberCell:ReInit(param)
    self.param = param
    self:Refresh()
end

function UIThroneRewardSelectMemberCell:Refresh()
    if self.param.visible then
        self:SetActive(true)
        if self.param.info ~= nil then
            self.power_text:SetText(string.GetFormattedSeperatorNum(math.floor(self.param.info.power)))
            self.player_head_icon:SetData(self.param.info.uid, self.param.info.pic, self.param.info.picVer)
            local headBgImg = DataCenter.DecorationDataManager:GetHeadFrame(self.param.info.headSkinId, self.param.info.headSkinET)
            if headBgImg ~= nil then
                self.player_head_frame:SetActive(true)
                self.player_head_frame:LoadSprite(headBgImg)
            else
                self.player_head_frame:SetActive(false)
            end
            if self.param.info.abbr ~= nil and self.param.info.abbr ~= "" then
                self.player_name_text:SetText("[" .. self.param.info.abbr .. "]" .. self.param.info.name)
            else
                self.player_name_text:SetText(self.param.info.name)
            end
            self:UpdateSex(self.param.info.sex)
            if DataCenter.GovernmentManager:IsGetReward(self.param.info.uid) then
                self.check_box:SetActive(false)
                self.show_btn:SetActive(false)
            else
                self.check_box:SetActive(true)
                self.show_btn:SetActive(true)
                self:RefreshSelect()
            end
        end
    else
        self:SetActive(false)
    end
end

function UIThroneRewardSelectMemberCell:OnClickPlayerHead()
    if self.param.info.uid ~= LuaEntry.Player.uid then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIOtherPlayerInfo,{ anim = true, hideTop = true}, self.param.info.uid)
    end
end

function UIThroneRewardSelectMemberCell:UpdateSex(sex)
    local iconName = SexUtil.GetSexIconName(sex)
    if iconName ~= nil and iconName ~= "" then
        self.sex_node:SetActive(true)
        self.sex_img:LoadSprite(iconName)
    else
        self.sex_node:SetActive(false)
    end
end

function UIThroneRewardSelectMemberCell:RefreshSelect()
    if self.param.select then
        self.select:SetActive(true)
    else
        self.select:SetActive(false)
    end
end

function UIThroneRewardSelectMemberCell:OnShowBtnClick()
    if not self.param.select and not self.view:CanSelect() then
        UIUtil.ShowTipsId(GameDialogDefine.GIFT_LEFT_NO_ENOUGH)
    else
        self.param.select = not self.param.select
        self:RefreshSelect()
        self.view:Select(self.param.info.uid)
    end
end

return UIThroneRewardSelectMemberCell