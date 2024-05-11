---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/9/12 17:42
---
local EdenGroupCell = BaseClass("EdenGroupCell", UIBaseContainer)
local base = UIBaseContainer

local server_text_path = "server_layout/server_text"
local fight_text_path = "server_layout/fight_text"
local goto_btn_path = "goto_btn"
local goto_btn_text_path = "goto_btn/goto_btn_text"

function EdenGroupCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function EdenGroupCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function EdenGroupCell:OnEnable()
    base.OnEnable(self)
end

function EdenGroupCell:OnDisable()
    base.OnDisable(self)
end

function EdenGroupCell:ComponentDefine()
    self.server_text = self:AddComponent(UIText, server_text_path)
    self.fight_text = self:AddComponent(UIText, fight_text_path)
    self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
    self.goto_btn:SetOnClick(function()
        self:OnGotoClick()
    end)
    self.goto_btn_text = self:AddComponent(UIText, goto_btn_text_path)
end

function EdenGroupCell:ComponentDestroy()

end

function EdenGroupCell:DataDefine()
    self.param = {}
end

function EdenGroupCell:DataDestroy()
    self.param = {}
end

function EdenGroupCell:OnAddListener()
    base.OnAddListener(self)
end

function EdenGroupCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function EdenGroupCell:ReInit(param)
    self.param = param
    self.goto_btn_text:SetLocalText(GameDialogDefine.GOTO)
    self.server_text:SetLocalText(GameDialogDefine.PLANT_SOMEONE, self.param.serverId)
    if self.param.serverId == LuaEntry.Player:GetSrcServerId() or self.param.serverId == LuaEntry.Player:GetSelfServerId() then
        --蓝色
        self.fight_text:SetActive(false)
        self.server_text:SetColor(DarkBlueColor)
        self.goto_btn:SetActive(false)
    else
        self.goto_btn:SetActive(self.param.showBtn)
        self.fight_text:SetActive(false)
        self.server_text:SetColor(OrangeColor)
    end
end

function EdenGroupCell:OnGotoClick()
    local serverId = self.param.serverId
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIAlCompeteTips,serverId,4)
end

return EdenGroupCell