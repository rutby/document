---
--- 荣耀之战联赛分组cell
--- Created by shimin.
--- DateTime: 2023/2/28 20:48
---
local UIGloryGroupCell = BaseClass("UIGloryGroupCell", UIBaseContainer)
local base = UIBaseContainer

local server_text_path = "server_layout/server_text"
local fight_text_path = "server_layout/fight_text"
local goto_btn_path = "goto_btn"
local goto_btn_text_path = "goto_btn/goto_btn_text"

function UIGloryGroupCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIGloryGroupCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIGloryGroupCell:OnEnable()
    base.OnEnable(self)
end

function UIGloryGroupCell:OnDisable()
    base.OnDisable(self)
end

function UIGloryGroupCell:ComponentDefine()
    self.server_text = self:AddComponent(UITextMeshProUGUIEx, server_text_path)
    self.fight_text = self:AddComponent(UITextMeshProUGUIEx, fight_text_path)
    self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
    self.goto_btn:SetOnClick(function()
        self:OnGotoClick()
    end)
    self.goto_btn_text = self:AddComponent(UITextMeshProUGUIEx, goto_btn_text_path)
end

function UIGloryGroupCell:ComponentDestroy()

end

function UIGloryGroupCell:DataDefine()
    self.param = {}
end

function UIGloryGroupCell:DataDestroy()
    self.param = {}
end

function UIGloryGroupCell:OnAddListener()
    base.OnAddListener(self)
end

function UIGloryGroupCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIGloryGroupCell:ReInit(param)
    self.param = param
    self.goto_btn_text:SetLocalText(GameDialogDefine.GOTO)
    self.server_text:SetLocalText(GameDialogDefine.PLANT_SOMEONE, self.param.serverId)
    if self.param.serverType == GlorySeverType.Self then
        --蓝色
        self.fight_text:SetActive(false)
        self.server_text:SetColor(DarkBlueColor)
    elseif self.param.serverType == GlorySeverType.Opponent then
        self.fight_text:SetActive(true)
        self.fight_text:SetLocalText(GameDialogDefine.PLANT_GLORY_OPPONENT_DES)
        self.server_text:SetColor(RedColor)
    elseif self.param.serverType == GlorySeverType.Other then
        self.fight_text:SetActive(false)
        self.server_text:SetColor(OrangeColor)
    end
end

function UIGloryGroupCell:OnGotoClick()
    local serverId = self.param.serverId
    GoToUtil.CloseAllWindows()
    GoToUtil.GotoWorldPos(SevenAllianceCityCenterWorldPos, GotoWorldLodOneMaxZoom, LookAtFocusTime, nil, serverId)
end

return UIGloryGroupCell