

local ChapterTaskItem = BaseClass("ChapterTaskItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIGray = CS.UIGray
local TaskItem = require "UI.UITaskMain.Comp.UITaskItem"
local TaskLockItem = require "UI.UITaskMain.Comp.UITaskLockItem"
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local TaskRewardItem = require "UI.UITaskMain.Comp.TaskRewardItem"
local RewardUtil = require "Util.RewardUtil"

local TaskItemPrefab = "Assets/Main/Prefab_Dir/UI/UITask/TaskItem.prefab"
local TaskLockItemPrefab = "Assets/Main/Prefab_Dir/UI/UITask/TaskLockItem.prefab"

local taskName_path = "ChapterProgress/TaskName"
local progressText_path = "ChapterProgress/ProgressBar/SlideArea/ProgressTip/progressText"
local progressSlider_path = "ChapterProgress/ProgressBar"
local titleText_path = "TitlePart/title"
local getRewardBtn_path = "ChapterProgress/getRewardBtn"
local getRewardTxt_path = "ChapterProgress/getRewardBtn/Txt_GetReward"
local getRewardGrayTxt_path = "ChapterProgress/getRewardBtn/Txt_GetRewardGray"
local scroll_view_content_path = "InfoPart/ScrollView/Viewport/Content"
local chapterRewardScrollView_path = "ChapterProgress/ScrollView"
local chapterRewardContent_path = "ChapterProgress/ScrollView/Viewport/rewardContent"
local bg_img_path = "bg_img"
local des_text_path = "TitlePart/title2"

--创建
function ChapterTaskItem : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function ChapterTaskItem : OnDestroy()
    self:SetAllCellDestroy()
    self:ClearChapterRewardList()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function ChapterTaskItem : ComponentDefine()
    self.taskNameText = self:AddComponent(UITextMeshProUGUIEx, taskName_path)
    self.progressText = self:AddComponent(UITextMeshProUGUIEx, progressText_path)
    self.progressSlider = self:AddComponent(UISlider, progressSlider_path)
    self.titleText = self:AddComponent(UITextMeshProUGUIEx, titleText_path)
    
    self.content = self:AddComponent(UIBaseContainer, scroll_view_content_path)
    self.content.transform:Set_anchoredPosition(0, 0)
    
    self.getRewardBtn = self:AddComponent(UIButton, getRewardBtn_path)
    self.getRewardBtn:SetOnClick(function()
        self:OnClickChapterReward()
    end)
    self.getRewardGray_txt = self:AddComponent(UITextMeshProUGUIEx, getRewardGrayTxt_path)
    self.getReward_txt = self:AddComponent(UITextMeshProUGUIEx, getRewardTxt_path)
    self.getRewardGray_txt:SetLocalText(170004)
    self.getReward_txt:SetLocalText(170004)
    
    self.chapterRewardScrollView = self:AddComponent(UIScrollView, chapterRewardScrollView_path)
    self.chapterRewardScrollView:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.chapterRewardScrollView:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.rewardContent = self:AddComponent(UIBaseContainer, chapterRewardContent_path)
    self.needRefreshGuide = false

    self.bg_img = self:AddComponent(UIImage, bg_img_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
end

function ChapterTaskItem : ComponentDestroy()

end

function ChapterTaskItem : DataDefine()
    self.itemInfoList = {}
    self.checkedChapterIdList = {}
    self.hasInit = false
    self.rewardInfoList = {}
    self.modelList = {}
    self.cellList = {}
    self.isAnim = false
    self.toRefreshList = false
    self.needRefreshGuide = false
    self.isRefreshList = false
end

function ChapterTaskItem : DataDestroy()
    self.itemInfoList = nil
    self.checkedChapterIdList = nil
    self.hasInit = false
    self.rewardInfoList = nil
    self.modelList = nil
    self.cellList = nil
    self.isAnim = false
    self.toRefreshList = false
    self.isRefreshList = false
end

-- 显示
function ChapterTaskItem : OnEnable()
    base.OnEnable(self)
end

function ChapterTaskItem : OnDisable()
    base.OnDisable(self)
end

function ChapterTaskItem : OnAddListener()
    base.OnAddListener(self)
end

function ChapterTaskItem : OnRemoveListener()
    base.OnRemoveListener(self)
end

function ChapterTaskItem : ShowSelf()
    if not self.hasInit then
        self.hasInit = true
        self:RefreshAll()
    end
end

function ChapterTaskItem : RefreshAll()
    self:RefreshList()
    self:RefreshChapter()
end

function ChapterTaskItem : RefreshChapter()
    local chapterId = DataCenter.ChapterTaskManager:GetCurChapterId()
    local template = DataCenter.ChapterTemplateManager:GetChapterTemplate(chapterId)
    if template ~= nil then
        --local titleText = Localization:GetString("170012",chapterId).." "..Localization:GetString(template.description)
        --local titleText = Localization:GetString(template.description)
        self.titleText:SetLocalText("170012",chapterId)
        self.taskNameText:SetLocalText(template.dialogue)
        local character = GetTableData(DataCenter.ChapterTemplateManager:GetTableName(),  chapterId, "character")
        self.bg_img:LoadSprite(string.format(LoadPath.UIChapterBgTexture, chapterId, character))
        self.des_text:SetLocalText(template.name)
    end

    local allNum = DataCenter.ChapterTaskManager:GetAllNum()
    local finishedNum = DataCenter.ChapterTaskManager:GetChapterFinishTaskCount()
    self.progressSlider:SetValue(finishedNum/allNum)
    self.progressText:SetText(finishedNum.."/"..allNum)

    local isGray = finishedNum < allNum
    UIGray.SetGray(self.getRewardBtn.transform, isGray, not isGray)
    self.getReward_txt:SetActive(not isGray)
    self.getRewardGray_txt:SetActive(isGray)
    
    self:RefreshChapterRewardList()
end

--章节领奖
function ChapterTaskItem : OnClickChapterReward()
    local chapterId = DataCenter.ChapterTaskManager.chapterId
    for k,v in pairs(self.checkedChapterIdList) do
        if v == chapterId then
            return
        end
    end
    table.insert(self.checkedChapterIdList, chapterId)
    local param = {}
    param.chapterId = DataCenter.ChapterTaskManager.chapterId
    local flag = DataCenter.GuideManager:GetSaveGuideValue(SaveNoShowGarbage)
    if flag == SaveGuideDoneValue then
        param.garbageRefresh = false
    end
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Chapter_Reward)
    SFSNetwork.SendMessage(MsgDefines.ChapterTask,param)
    self.view:OnClickChapterRewardCallBack()
end

function ChapterTaskItem : GetChapterBtnByTaskId(id)
    self.needRefreshGuide = true
    local go = nil
    for k,v in pairs(self.cellList) do
        if v:GetTaskId() == id then
            go = v:GetBtnGo()
            return go
        end
    end
    return go
end

function ChapterTaskItem : RefreshChapterRewardList()
    self:ClearChapterRewardList()
    
    self.rewardInfoList = DataCenter.ChapterTaskManager:GetChapterReward()
    RewardUtil.SortRewardList(self.rewardInfoList)
    if self.rewardInfoList and #self.rewardInfoList >= 0 then
        self.chapterRewardScrollView:SetTotalCount(#self.rewardInfoList)
        self.chapterRewardScrollView:RefillCells()
        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.rewardContent.rectTransform)
    end
end

function ChapterTaskItem : OnItemMoveIn(itemObj, index)
    itemObj.name = tostring(index)
    local cellItem = self.chapterRewardScrollView:AddComponent(TaskRewardItem, itemObj)
    cellItem:ReInit(self.rewardInfoList[index])
end

function ChapterTaskItem : OnItemMoveOut(itemObj, index)
    self.chapterRewardScrollView:RemoveComponent(itemObj.name, TaskRewardItem)
end


function ChapterTaskItem : ClearChapterRewardList()
    self.chapterRewardScrollView:ClearCells()
    self.chapterRewardScrollView:RemoveComponents(TaskRewardItem)
    self.rewardInfoList = {}
end

function ChapterTaskItem : RefreshListData()
    local originList = DataCenter.ChapterTaskManager:GetAllChapterTask(true)
    if originList == nil then
        return
    end
    self.itemInfoList = originList
    for k,v in pairs(self.itemInfoList) do
        if v.rewardList then
            RewardUtil.SortRewardList(v.rewardList)
        end
    end
    -- 添加未解锁任务
    local insertIndex = 1
    for k,v in ipairs(originList) do
        if v.state == 2 then
            break
        else
            insertIndex = insertIndex + 1
        end
    end
    local allNum = DataCenter.ChapterTaskManager:GetAllNum()
    local unlockNum = allNum - #self.itemInfoList
    for i = 1, unlockNum do
        local param = {}
        param.state = TaskState.Lock
        param.id = "lockedItem"..i
        table.insert(self.itemInfoList, insertIndex, param)
    end
end

function ChapterTaskItem : SetAllCellDestroy()
    self.content:RemoveComponents(TaskItem)
    self.content:RemoveComponents(TaskLockItem)
    if self.modelList~=nil then
        for k,v in pairs(self.modelList) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

function ChapterTaskItem : RefreshList()
    if self.isRefreshList then
        self.toRefreshList = true
        return
    end
    self.isRefreshList = true
    self:RefreshListData()
    self.content:RemoveComponents(TaskItem)
    self.content:RemoveComponents(TaskLockItem)
    for i = 1,#self.itemInfoList do
        if self.modelList[i] then
            local newItemState = self.itemInfoList[i].state
            local oldItemState = self.cellList[i]:GetItemState()
            if newItemState == oldItemState or (newItemState ~= TaskState.Lock and oldItemState ~= TaskState.Lock) then -- 状态一致或都不是未解锁状态时，不需要更换item，直接刷新数据
                local name = tostring(self.itemInfoList[i].id)
                self.modelList[i].gameObject.name = name
                self.modelList[i].gameObject.transform:SetSiblingIndex(i-1)
                local item
                if self.itemInfoList[i].state == TaskState.Lock then
                    item = TaskLockItem
                else
                    item = TaskItem
                end
                self.cellList[i] = self.content:AddComponent(item, name)
                local param = self.itemInfoList[i]
                param.index = i
                param.callBack = function(index)
                    self:ReceiveTaskCallBack(index)
                end
                self.cellList[i]:SetData(param)
                self.cellList[i]:SetActive(true)

                if i == #self.itemInfoList then
                    self.isRefreshList = false
                    if self.toRefreshList then
                        self.toRefreshList = false
                        self:RefreshList()
                    end
                end
            else
                for k = #self.modelList,i,-1 do
                    self:GameObjectDestroy(self.modelList[k])
                    table.remove(self.modelList, k)
                    table.remove(self.cellList, k)
                end
                local prefab
                if self.itemInfoList[i].state == TaskState.Lock then
                    prefab = TaskLockItemPrefab
                else
                    prefab = TaskItemPrefab
                end
                self.modelList[i] = self:GameObjectInstantiateAsync(prefab, function(request)
                    if request.isError or request.gameObject == nil then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.content.transform)
                    go.transform:SetSiblingIndex(i-1)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    go.name = self.itemInfoList[i].id
                    local item
                    if self.itemInfoList[i].state == TaskState.Lock then
                        item = TaskLockItem
                    else
                        item = TaskItem
                    end
                    local cell = self.content:AddComponent(item, go.name)
                    local param = self.itemInfoList[i]
                    param.index = i
                    param.callBack = function(index)
                        self:ReceiveTaskCallBack(index)
                    end
                    cell:SetData(param)
                    cell:SetActive(true)
                    self.cellList[i] = cell

                    if i == #self.itemInfoList then
                        self.isRefreshList = false
                        if self.toRefreshList then
                            self.toRefreshList = false
                            self:RefreshList()
                        end
                    end
                end)
            end
        else
            local prefab
            if self.itemInfoList[i].state == TaskState.Lock then
                prefab = TaskLockItemPrefab
            else
                prefab = TaskItemPrefab
            end
            self.modelList[i] = self:GameObjectInstantiateAsync(prefab, function(request)
                if request.isError or request.gameObject == nil then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:SetSiblingIndex(i-1)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name = self.itemInfoList[i].id
                local item
                if self.itemInfoList[i].state == TaskState.Lock then
                    item = TaskLockItem
                else
                    item = TaskItem
                end
                local cell = self.content:AddComponent(item, go.name)
                local param = self.itemInfoList[i]
                param.index = i
                param.callBack = function(index)
                    self:ReceiveTaskCallBack(index)
                end
                cell:SetData(param)
                cell:SetActive(true)
                self.cellList[i] = cell

                if i == #self.itemInfoList then
                    self.isRefreshList = false
                    if self.toRefreshList then
                        self.toRefreshList = false
                        self:RefreshList()
                    end
                end
            end)
        end
    end
end

function ChapterTaskItem : ReceiveTaskCallBack(index)
end

function ChapterTaskItem : OnChapterTask()
    self:RefreshAll()
end

return ChapterTaskItem