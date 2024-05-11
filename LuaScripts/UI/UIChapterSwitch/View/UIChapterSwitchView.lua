---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/12/14 17:38
---

local base = UIBaseView
local UIChapterSwitchView = BaseClass("UIChapterSwitchView", base)
local Localization = CS.GameEntry.Localization

local switchAnim_path = "anim"
local chapterIndex_path = "anim/chapterIndex"
local chapterName_path = "anim/chapterName"

local AutoCloseTime = 3

local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:ShowSwitchScreen()
end

local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.animatorN = self:AddComponent(UIAnimator, switchAnim_path)
    self.chapterIndexN = self:AddComponent(UIText, chapterIndex_path)
    self.chapterNameN = self:AddComponent(UIText, chapterName_path)
end

local function ComponentDestroy(self)
    self.switchAnimN = nil
    self.chapterIndexN = nil
    self.chapterNameN = nil
end

local function DataDefine(self)
    
end

local function DataDestroy(self)
    
end

local function ShowSwitchScreen(self)
    local chapterId = tonumber(self:GetUserData())
    self.chapterIndexN:SetText(Localization:GetString(GameDialogDefine.CHAPTER_TITLE, chapterId))
    local template = DataCenter.ChapterTemplateManager:GetChapterTemplate(chapterId)
    if template ~= nil then
        self.chapterNameN:SetLocalText(template.description)
    end
    TimerManager:GetInstance():DelayInvoke(function()
        self.ctrl:CloseSelf()
        self:CheckGuide()
    end, AutoCloseTime)
end

local function CheckGuide(self)
    if DataCenter.GuideManager:GetGuideType() == GuideType.ShowChapterAnim then
        DataCenter.GuideManager:DoNext()
    end
end

UIChapterSwitchView.OnCreate = OnCreate
UIChapterSwitchView.OnDestroy = OnDestroy
UIChapterSwitchView.ComponentDefine = ComponentDefine
UIChapterSwitchView.ComponentDestroy = ComponentDestroy
UIChapterSwitchView.DataDefine = DataDefine
UIChapterSwitchView.DataDestroy = DataDestroy

UIChapterSwitchView.ShowSwitchScreen = ShowSwitchScreen
UIChapterSwitchView.CheckGuide = CheckGuide

return UIChapterSwitchView