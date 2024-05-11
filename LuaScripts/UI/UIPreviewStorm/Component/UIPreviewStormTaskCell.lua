--- Created by shimin.
--- DateTime: 2023/11/10 16:03
--- 暴风雪预览界面任务cell
local UIPreviewStormTaskCell = BaseClass("UIPreviewStormTaskCell", UIBaseContainer)
local base = UIBaseContainer

local des_text_path = "des_text"
local goto_btn_path = "goto_btn"
local goto_btn_text_path = "goto_btn/goto_btn_text"
local finish_text_path = "finish_text"

function UIPreviewStormTaskCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function UIPreviewStormTaskCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIPreviewStormTaskCell:ComponentDefine()
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
    self.goto_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGotoBtnClick()
    end)
    self.goto_btn_text = self:AddComponent(UITextMeshProUGUIEx, goto_btn_text_path)
    self.finish_text = self:AddComponent(UITextMeshProUGUIEx, finish_text_path)
end

function UIPreviewStormTaskCell:ComponentDestroy()
end

function UIPreviewStormTaskCell:DataDefine()
    self.param = {}
end

function UIPreviewStormTaskCell:DataDestroy()
    self.param = {}
end

function UIPreviewStormTaskCell:OnEnable()
    base.OnEnable(self)
end

function UIPreviewStormTaskCell:OnDisable()
    base.OnDisable(self)
end

function UIPreviewStormTaskCell:OnAddListener()
    base.OnAddListener(self)
end

function UIPreviewStormTaskCell:OnRemoveListener()
    base.OnRemoveListener(self)
end

function UIPreviewStormTaskCell:ReInit(param)
    self.goto_btn_text:SetLocalText(GameDialogDefine.GOTO)
    self.finish_text:SetLocalText(GameDialogDefine.FINISHED)
    self.param = param
    self:Refresh()
end


function UIPreviewStormTaskCell:OnGotoBtnClick()
    if self.view:CanClick() then
        GoToUtil.GoToByQuestId(LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), self.param.taskId))
    end
end

function UIPreviewStormTaskCell:Refresh()
    local cur = 0
    local task = DataCenter.TaskManager:FindTaskInfo(self.param.taskId)
    if task ~= nil then
        cur = task.num
        if task.state == TaskState.NoComplete then
            self.finish_text:SetActive(false)
            self.goto_btn:SetActive(true)
        else
            self.finish_text:SetActive(true)
            self.goto_btn:SetActive(false)
        end
    else
        self.finish_text:SetActive(false)
        self.goto_btn:SetActive(true)
    end
    local all = GetTableData(DataCenter.QuestTemplateManager:GetTableName(), self.param.taskId, "para2",  0)
    if cur > all then
        cur = all
    end
    self.des_text:SetText(DataCenter.QuestTemplateManager:GetDesc(
            LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), self.param.taskId)) 
            .. " (" .. (string.GetFormattedSeperatorNum(cur) .. "/" .. string.GetFormattedSeperatorNum(all)) .. ")")
    
end

return UIPreviewStormTaskCell