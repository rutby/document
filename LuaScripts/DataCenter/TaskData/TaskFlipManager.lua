--- Created by shimin.
--- DateTime: 2024/4/1 20:36
--- 章节任务翻页管理器

local TaskFlipManager = BaseClass("TaskFlipManager")

function TaskFlipManager:__init()
    self.needWait = false--需要在章节任务奖励领取之后弹出翻页页面
end

function TaskFlipManager:__delete()
    self.needWait = false
    self:RemoveListener()
end

function TaskFlipManager:Startup()
end

function TaskFlipManager:AddListener()
    if self.closeUISignal == nil then
        self.closeUISignal = function(param)
            self:CloseUISignal(param)
        end
        EventManager:GetInstance():AddListener(EventId.CloseUI, self.closeUISignal)
    end
end

function TaskFlipManager:RemoveListener()
    if self.closeUISignal ~= nil then
        EventManager:GetInstance():RemoveListener(EventId.CloseUI, self.closeUISignal)
        self.closeUISignal = nil
    end
end

--当点击章节任务领奖
function TaskFlipManager:OnClickChapterReward()
    self.needWait = true
    self:AddListener()
end

function TaskFlipManager:CloseUISignal(uiName)
    if self.needWait and uiName == UIWindowNames.UIGiftPackageRewardGet then
        self:RemoveListener()
        self.needWait = false
        if not DataCenter.GuideManager:InGuide() then
            local chapterId = DataCenter.ChapterTaskManager.chapterId
            local flip = GetTableData(DataCenter.ChapterTemplateManager:GetTableName(),  chapterId, "flip", 0)
            if flip == ChapterFlipType.Pre then
                self:PlayEffect(DataCenter.ChapterTaskManager.chapterId)
            end
        end
    end
end

function TaskFlipManager:PlayEffect(chapterId)
    if DataCenter.ChapterTaskManager:HasNextChapter() then
        local chapter_bg = GetTableData(DataCenter.ChapterTemplateManager:GetTableName(),  chapterId, "chapter_bg", "")
        if chapter_bg ~= nil and chapter_bg ~= "" then
            --播放飞行特效
            local param = {}
            param.chapterId = chapterId
            DataCenter.GuideManager:AddOneTempFlag(GuideTempFlagType.ChapterBg, param)
            DataCenter.GuideManager:SetWaitingMessage(WaitMessageFinishType.UITaskMainAnimBg, true)
            self:OpenUI()
        end
    end
end

function TaskFlipManager:OpenUI()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UITaskMain, HideBlurPanelAnim, TaskType.Chapter)
end



return TaskFlipManager
