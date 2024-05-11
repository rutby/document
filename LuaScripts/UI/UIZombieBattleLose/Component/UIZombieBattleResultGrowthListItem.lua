
---@class UIZombieBattleResultGrowthListItem : UIBaseContainer
local UIZombieBattleResultGrowthListItem = BaseClass("UIZombieBattleResultGrowthListItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization

local title_path = "Title"
local goto_btn_path = "GotoBtn"
local arrow_btn_path = "arrow"
-- local btn_text_path = "GotoBtn/BtnText"

-- 创建
function UIZombieBattleResultGrowthListItem:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

-- 销毁
function UIZombieBattleResultGrowthListItem:OnDestroy()
    self:ComponentDestroy()
    base.OnDestroy(self)
end

-- 显示
function UIZombieBattleResultGrowthListItem:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function UIZombieBattleResultGrowthListItem:OnDisable()
    base.OnDisable(self)
end

function UIZombieBattleResultGrowthListItem:ComponentDefine()
    self.title = self:AddComponent(UITextMeshProUGUIEx, title_path)
    self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
    self.arrow_btn = self:AddComponent(UIButton, arrow_btn_path)
    -- self.btn_text = self:AddComponent(UITextMeshProUGUIEx, btn_text_path)
end

function UIZombieBattleResultGrowthListItem:ComponentDestroy()
    self.title    = nil
    self.goto_btn = nil
    self.btn_text = nil
end

function UIZombieBattleResultGrowthListItem:RefreshView(title, btnText, obj, action)
    self.title:SetText(title)
    -- self.btn_text:SetLocalText(btnText)
    self.goto_btn:SetOnClick(BindCallback(obj, action))
    self.arrow_btn:SetOnClick(BindCallback(obj, action))
end

return UIZombieBattleResultGrowthListItem