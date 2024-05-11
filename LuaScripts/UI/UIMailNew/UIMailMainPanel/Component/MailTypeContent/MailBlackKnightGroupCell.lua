---
--- 黑骑士战报组cell
--- Created by shimin.
--- DateTime: 2023/3/9 16:17
---
local MailBlackKnightGroupCell = BaseClass("MailBlackKnightGroupCell", UIBaseContainer)
local base = UIBaseContainer

local result_text_path = "txtMainTitle"
local win_text_path = "TextWin"
local lose_text_path = "TextLose"
local des_text_path = "txtSubTitle"
local detail_btn_path = ""
local round_text_path = "round_text"
local score_text_path = "score_text"
local score_name_path = "score_name"
local help_other_go_path = "help_other_go"

function MailBlackKnightGroupCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function MailBlackKnightGroupCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function MailBlackKnightGroupCell:OnEnable()
    base.OnEnable(self)
end

function MailBlackKnightGroupCell:OnDisable()
    base.OnDisable(self)
end

function MailBlackKnightGroupCell:ComponentDefine()
    self.result_text = self:AddComponent(UITextMeshProUGUIEx, result_text_path)
    self.win_text = self:AddComponent(UITextMeshProUGUIEx, win_text_path)
    self.lose_text = self:AddComponent(UITextMeshProUGUIEx, lose_text_path)
    self.detail_btn = self:AddComponent(UIButton, detail_btn_path)
    self.detail_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnDetailBtnClick()
    end)
    self.round_text = self:AddComponent(UITextMeshProUGUIEx, round_text_path)
    self.score_name = self:AddComponent(UITextMeshProUGUIEx, score_name_path)
    self.score_text = self:AddComponent(UITextMeshProUGUIEx, score_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.help_other_go = self:AddComponent(UIBaseContainer, help_other_go_path)
end

function MailBlackKnightGroupCell:ComponentDestroy()

end

function MailBlackKnightGroupCell:DataDefine()
    self.param = {}
end

function MailBlackKnightGroupCell:DataDestroy()
    self.param = {}
end

function MailBlackKnightGroupCell:OnAddListener()
    base.OnAddListener(self)
end

function MailBlackKnightGroupCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function MailBlackKnightGroupCell:ReInit(param)
    self.param = param
    self.score_name:SetLocalText(GameDialogDefine.GET_SCORE_WITH, "")
    self:Refresh()
end

function MailBlackKnightGroupCell:Refresh()
    if self.param ~= nil then
        self.result_text:SetText(MailShowHelper.GetMainTitle(self.param))
        self.win_text:SetText(MailShowHelper.GetMainTitle(self.param))
        self.lose_text:SetText(MailShowHelper.GetMainTitle(self.param))
        self.result_text:SetActive(false)
        self.win_text:SetActive(false)
        self.lose_text:SetActive(false)
        self.des_text:SetText(MailShowHelper.GetMailSummary(self.param, true, self.param.senderUid))
        self.score_text:SetText(MailShowHelper.GetScore(self.param, LuaEntry.Player.uid))
        local ext = self.param:GetMailExt()
        if ext ~= nil then
            self.round_text:SetLocalText(GameDialogDefine.TURN_WITH, MailShowHelper.GetBlackKnightRoundName(self.param, false))
            local resultState = ext:GetBattleResultStatus()
            if resultState == FightResult.SELF_WIN then
                -- self.result_text:SetColor(Const_Color_Green)
                self.win_text:SetActive(true)
            elseif resultState == FightResult.OTHER_WIN then
                -- self.result_text:SetColor(WhiteColor)
                self.lose_text:SetActive(true)
            else
                self.result_text:SetActive(true)
                -- self.result_text:SetColor(Const_Color_Red)
            end
            self.help_other_go:SetActive(ext:IsHelpOther(self.param.toUser))
        end
    end
end

function MailBlackKnightGroupCell:OnDetailBtnClick()
    if self.param ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIShareMail, NormalBlurPanelAnim, self.param)
    end
end

return MailBlackKnightGroupCell