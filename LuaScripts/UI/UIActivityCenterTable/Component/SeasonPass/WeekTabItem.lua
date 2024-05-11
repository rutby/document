--- Created by shimin
--- DateTime: 2023/3/24 10:57
--- 赛季通行证每周页签cell

local WeekTabItem = BaseClass("WeekTabItem", UIBaseContainer)
local base = UIBaseContainer

local this_path = ""
local selected_img_path = "selected"
local unselected_img_path = "unselected"
local selected_text_path = "selected/weekTxt"
local unselected_text_path = "unselected/weekTxt1"
local red_dot_path = "weekRed"
local lock_go_path = "lock"

function WeekTabItem:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function WeekTabItem:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function WeekTabItem:OnEnable()
    base.OnEnable(self)
end

function WeekTabItem:OnDisable()
    base.OnDisable(self)
end

function WeekTabItem:ComponentDefine()
    self.btn = self:AddComponent(UIButton, this_path)
    self.btn:SetOnClick(function()
        self:OnBtnClick()
    end)
    self.selected_img = self:AddComponent(UIImage, selected_img_path)
    self.unselected_img = self:AddComponent(UIImage, unselected_img_path)
    self.selected_text = self:AddComponent(UIText, selected_text_path)
    self.unselected_text = self:AddComponent(UIText, unselected_text_path)
    self.red_dot = self:AddComponent(UIBaseContainer, red_dot_path)
    self.lock_go = self:AddComponent(UIBaseContainer, lock_go_path)
end

function WeekTabItem:ComponentDestroy()

end

function WeekTabItem:DataDefine()
    self.param = {}
end

function WeekTabItem:DataDestroy()
    self.param = {}
end

function WeekTabItem:OnAddListener()
    base.OnAddListener(self)
end

function WeekTabItem:OnRemoveListener()
    base.OnRemoveListener(self)
end

function WeekTabItem:ReInit(param)
    self.param = param
    if self.param.index == 1 then
        self.selected_img:LoadSprite("Assets/Main/Sprites/UI/UISeasonPass/UIbattlepass_btn01_chosen.png")
        self.unselected_img:LoadSprite("Assets/Main/Sprites/UI/UISeasonPass/UIbattlepass_btn01.png")
    else
        self.selected_img:LoadSprite("Assets/Main/Sprites/UI/UISeasonPass/UIbattlepass_btn02_choser.png")
        self.unselected_img:LoadSprite("Assets/Main/Sprites/UI/UISeasonPass/UIbattlepass_btn02.png")
    end
    if param.isEarly then
        self.selected_text:SetLocalText(320936)
        self.unselected_text:SetLocalText(320936)
    else
        self.selected_text:SetLocalText(GameDialogDefine.THE_WEEK_WITH, self.param.index)
        self.unselected_text:SetLocalText(GameDialogDefine.THE_WEEK_WITH, self.param.index)
    end
    self:RefreshLock(self.param.isLock)
    self:Select(self.param.select)
    self:RefreshRed(self.param.isRed)
end

function WeekTabItem:OnBtnClick()
    if self.param.onClick ~= nil then
        self.param.onClick(self.param.index)
    end
end

function WeekTabItem:Select(isSelect)
    self.param.select = isSelect
    if isSelect then
        self.selected_img:SetActive(true)
        self.unselected_img:SetActive(false)
    else
        self.selected_img:SetActive(false)
        self.unselected_img:SetActive(true)
    end
end

function WeekTabItem:RefreshRed(isShow)
    self.param.isRed = isShow
    if isShow then
        self.red_dot:SetActive(true)
    else
        self.red_dot:SetActive(false)
    end
end

function WeekTabItem:RefreshLock(isLock)
    self.param.isLock = isLock
    if isLock then
        self.lock_go:SetActive(true)
    else
        self.lock_go:SetActive(false)
    end
end


return WeekTabItem