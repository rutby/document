---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by mac.
--- DateTime: 8/2/21 3:40 PM
---
---任务页面
local MainTaskItem = BaseClass("MainTaskItem", UIBaseContainer)
local base = UIBaseContainer

local UIQuestCell = require "UI.UITaskMain.Comp.UIQuestCellNew"
local UIQuestCellNewPrefab = "Assets/Main/Prefab_Dir/UI/UITask/TaskItem.prefab"

local mainContent_path = "HaveTask/RectMain/mainContent"
local txt_main_path = "HaveTask/RectMain/TxtMain"
local viceContent_path = "HaveTask/RectVice/ScrollView/Viewport/viceContent"
local txt_vice_path = "HaveTask/RectVice/TxtVice"
local rectMain_path = "HaveTask/RectMain"

-- 创建
function MainTaskItem : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function MainTaskItem : OnDestroy()
    self:CloseMainTaskAnimTimer()
    self:CloseSideTaskAnimTimer()
    self:SetAllCellDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

-- 显示
function MainTaskItem : OnEnable()
    base.OnEnable(self)
end

--控件的定义
function MainTaskItem : ComponentDefine()
    self.mainContent = self:AddComponent(UIBaseContainer,mainContent_path)
    self.txt_main = self:AddComponent(UITextMeshProUGUIEx,txt_main_path)
    self.viceContent = self:AddComponent(UIBaseContainer,viceContent_path)
    self.txt_vice = self:AddComponent(UITextMeshProUGUIEx,txt_vice_path)
    self.txt_main:SetLocalText(170014)
    self.txt_vice:SetLocalText(170016)
    
    self.rectMain = self:AddComponent(UIBaseContainer, rectMain_path)
end

--控件的销毁
function MainTaskItem : ComponentDestroy()

end

--变量的定义
function MainTaskItem : DataDefine()
    self.mainTask = nil
    self.mainTaskList = {}
    self.sideTaskList = {}
    self.sideModelList = {}
    self.sideCellList = {}
    self.hasInit = false
    self.isAnim = false
    self.toRefresh = false
end

--变量的销毁
function MainTaskItem : DataDestroy()
    self.mainTask = nil
    self.mainTaskList = nil
    self.sideTaskList = nil
    self.sideModelList = nil
    self.sideCellList = nil
    self.hasInit = false
    self.isAnim = false
    self.toRefresh = false
end

function MainTaskItem : SetAllCellDestroy()
    self.viceContent:RemoveComponents(UIQuestCell)
    if self.sideModelList~=nil then
        for k,v in pairs(self.sideModelList) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

function MainTaskItem : ShowSelf()
    if not self.hasInit then
        self.hasInit = true
        self:RefreshAll()
    end
end

-- 全部刷新
function MainTaskItem : RefreshAll(taskId)
    self.mainTaskList,self.sideTaskList = DataCenter.TaskManager:GetMainAndSideTaskList()
    
    self:RefreshMainTask()
    self:RefreshViceTask()
end

function MainTaskItem : RefreshMainTask()
    if self.isRefreshMainTask then
        self.toRefreshMainTask = true
        return
    end
    if self.mainTaskList == nil or #self.mainTaskList <= 0 then
        self.rectMain:SetActive(false)
        return
    else
        self.rectMain:SetActive(true)
    end 
    
    self.isRefreshMainTask = true
    if self.mainTask == nil then
        if self.mainTaskList == nil or #self.mainTaskList <= 0 then
            return
        end
        self:GameObjectInstantiateAsync(UIQuestCellNewPrefab, function(request)
            if request.isError or request.gameObject == nil then
                return
            end
            local go = request.gameObject;
            go.gameObject:SetActive(true)
            go.transform:SetParent(self.mainContent.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.name = self.mainTaskList[1].id
            self.mainTask = self:AddComponent(UIQuestCell, mainContent_path.."/"..go.name)
            local param = {}
            param.id = self.mainTaskList[1].id
            param.index = i
            param.taskType = self.mainTaskList[1].taskType
            param.rewardList = self.mainTaskList[1].rewardList
            param.callBack = function(isMainTask, index)
                self:ReceiveTaskCallBack(isMainTask, index)
            end
            self.mainTask:ReInit(param)
            
            self.isRefreshMainTask = false
            if self.toRefreshMainTask then
                self.toRefreshMainTask = false
                self:RefreshMainTask()
            end
        end)
    else
        if self.mainTaskList and #self.mainTaskList > 0 then
            self.mainTask.gameObject.name = self.mainTaskList[1].id
            local param = {}
            param.id = self.mainTaskList[1].id
            param.index = 1
            param.taskType = self.mainTaskList[1].taskType
            param.rewardList = self.mainTaskList[1].rewardList
            param.callBack = function(isMainTask, index)
                self:ReceiveTaskCallBack(isMainTask, index)
            end
            self.mainTask:ReInit(param)

            self.isRefreshMainTask = false
            if self.toRefreshMainTask then
                self.toRefreshMainTask = false
                self:RefreshMainTask()
            end
        end
    end
end

function MainTaskItem : RefreshViceTask()
    if self.isRefreshViceTask then
        self.toRefreshViceTask = true
        return
    end
    self.isRefreshViceTask = true
    self.viceContent:RemoveComponents(UIQuestCell)
    for i = 1,#self.sideTaskList do
        if self.sideModelList[i] then
            self.sideModelList[i].gameObject.name = self.sideTaskList[i].id
            local cell = self.viceContent:AddComponent(UIQuestCell, self.sideTaskList[i].id)
            local param = {}
            param.id = self.sideTaskList[i].id
            param.index = i
            param.taskType = self.sideTaskList[i].taskType
            param.rewardList = self.sideTaskList[i].rewardList
            param.callBack = function(isMainTask, index)
                self:ReceiveTaskCallBack(isMainTask, index)
            end
            cell:ReInit(param)
            cell:SetActive(true)
            self.sideCellList[i] = cell

            if i == #self.sideTaskList then
                self.isRefreshViceTask = false
                if self.toRefreshViceTask then
                    self:RefreshViceTask()
                end
            end
        else
            self.sideModelList[i] = self:GameObjectInstantiateAsync(UIQuestCellNewPrefab, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.viceContent.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.name =self.sideTaskList[i].id
                local cell = self.viceContent:AddComponent(UIQuestCell,go.name)
                local param = {}
                param.id = self.sideTaskList[i].id
                param.index = i
                param.taskType = self.sideTaskList[i].taskType
                param.rewardList = self.sideTaskList[i].rewardList
                param.callBack = function(isMainTask, index)
                    self:ReceiveTaskCallBack(isMainTask, index)
                end
                cell:ReInit(param)
                self.sideCellList[i] = cell

                if i == #self.sideTaskList then
                    self.isRefreshViceTask = false
                    if self.toRefreshViceTask then
                        self:RefreshViceTask()
                    end
                end
            end)
        end
    end
end

function MainTaskItem : ReceiveTaskCallBack(isMainTask, index)

end

function MainTaskItem : DoAnimReceiveMainTask()
    self:RefreshAll()
end

function MainTaskItem : CloseMainTaskAnimTimer()
    if self.mainTaskAnimTimer1 ~= nil then
        self.mainTaskAnimTimer1:Stop()
        self.mainTaskAnimTimer1 = nil
    end
    if self.mainTaskAnimTimer2 ~= nil then
        self.mainTaskAnimTimer2:Stop()
        self.mainTaskAnimTimer2 = nil
    end
end

function MainTaskItem : DoAnimReceiveSideTask(index)
    for k,v in pairs(self.sideCellList) do
        v:SetIsAnim(true)
    end

    self:RefreshAll()
end

function MainTaskItem : CloseSideTaskAnimTimer()
    if self.sideTaskAnimTimer ~= nil then
        self.sideTaskAnimTimer:Stop()
        self.sideTaskAnimTimer = nil
    end
end

function MainTaskItem : OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.MainTaskSuccess, self.OnMainTaskSuccess)
end

function MainTaskItem : OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.MainTaskSuccess, self.OnMainTaskSuccess)
end

function MainTaskItem : OnMainTaskSuccess()
    --if self.isAnim == true then
    --    self.toRefresh = true
    --else
    --    self:RefreshAll()
    --end

    self:RefreshAll()
end

return MainTaskItem