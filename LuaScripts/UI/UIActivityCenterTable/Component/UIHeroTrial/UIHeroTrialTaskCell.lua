local UIHeroTrialTaskCell = BaseClass("UIHeroTrialTaskCell", UIBaseContainer)
local base = UIBaseContainer
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local RewardUtil = require "Util.RewardUtil"
local Localization = CS.GameEntry.Localization
local tipTxt_path = "rewardBg/Tip"
local content_path = "rewardBg/Rewards"
local pro_txt_path = "rewardBg/Txt_Pro"
local getReward_btn_path = "rewardBg/Btn_GetReward"
local getReward_txt_path = "rewardBg/Btn_GetReward/Txt_GetReward"
local go_btn_path = "rewardBg/Btn_Go"
local go_txt_path = "rewardBg/Btn_Go/btnText"
local completed_path = "rewardBg/Completed"
local gray_txt_path = "rewardBg/Btn_GetReward/Txt_Gray"
local UIGray = CS.UIGray

function UIHeroTrialTaskCell:OnCreate()
    base.OnCreate(self)

    self.rewardModels ={}
    self.rewardItemsList = {}

    self.tipN = self:AddComponent(UITextMeshProUGUIEx, tipTxt_path)
    self.contentN = self:AddComponent(UIBaseContainer, content_path)
    self._pro_txt = self:AddComponent(UITextMeshProUGUIEx,pro_txt_path)
    self._getReward_btn = self:AddComponent(UIButton,getReward_btn_path)
    self._getReward_btn:SetOnClick(function()
        self:GetRewardClick()
    end)
    self._getReward_txt = self:AddComponent(UITextMeshProUGUIEx,getReward_txt_path)
    self.go_btn = self:AddComponent(UIButton,go_btn_path)
    self.go_btn:SetOnClick(function()
        self:GoToTask()
    end)
    self.goto_txt = self:AddComponent(UITextMeshProUGUIEx,go_txt_path)
    self._completed = self:AddComponent(UIBaseContainer,completed_path)
    --self._gray_txt = self:AddComponent(UITextMeshProUGUIEx,gray_txt_path)
end

function UIHeroTrialTaskCell:OnDestroy()
    self.rewardModels = nil
    self.rewardItemsList = nil
    self._getReward_btn = nil
    self._getReward_txt = nil
    self.complete_btn = nil
    self._completed = nil
    self.go_btn = nil
    self.goto_txt = nil
    self._pro_txt = nil
    self.tipN = nil
    self.contentN = nil
    base.OnDestroy(self)
end

function UIHeroTrialTaskCell:ShowRewards(param,str)
    self.taskId = param.id
    --local template = string.split(str,";")
    self.taskValue = DataCenter.TaskManager:FindTaskInfo(self.taskId)
    self.template = LocalController:instance():getLine(DataCenter.QuestTemplateManager:GetTableName(), self.taskId)
    self.tipN:SetText(DataCenter.QuestTemplateManager:GetDesc(self.template))
    
    local completeNum = self.taskValue.num
    local maxNum = self.template.para2
    if (completeNum - maxNum) >= 0 then
        completeNum = maxNum
    end
    completeNum = string.GetFormattedSeperatorNum(completeNum)
    maxNum = string.GetFormattedSeperatorNum(maxNum)
    self._pro_txt:SetLocalText(150033,completeNum,maxNum)

    --local isGray = false
    --if self.taskValue.state == 2 and completeNum < maxNum then
    --    isGray = true
    --end
    --UIGray.SetGray(self._getReward_btn.transform, isGray,completeNum >= maxNum)
    --self._gray_txt:SetActive(isGray)
    --self._gray_txt:SetLocalText(self.taskValue.state == 0 and 371068 or 170004)
    self._completed:SetActive(self.taskValue.state == 2)
    -- self._completed_txt:SetLocalText(110461)
    self._getReward_btn:SetActive(self.taskValue.state == 1)
    self._getReward_txt:SetActive(self.taskValue.state == 1)
    self._getReward_txt:SetLocalText(371058)
    self.go_btn:SetActive(self.taskValue.state == 0)
    self.goto_txt:SetLocalText(110003)
    self:SetAllRewardsDestroy()
    self.rewardModelCount =0
    local list =  self.taskValue.rewardList
    if list~=nil and #list>0 then
        for i = 1, table.length(list) do
            --复制基础prefab，每次循环创建一次
            self.rewardModelCount= self.rewardModelCount+1
            self.rewardModels[self.rewardModelCount] = self:GameObjectInstantiateAsync(UIAssets.UICommonItemSize, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.contentN.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.contentN:AddComponent(UICommonItem,nameStr)
                cell:ReInit(list[i])
                table.insert(self.rewardItemsList,cell)
            end)
        end
    end
end

function UIHeroTrialTaskCell:GoToTask()
    GoToUtil.GoToByQuestId(self.template)
end

function UIHeroTrialTaskCell:SetAllRewardsDestroy()
    self.contentN:RemoveComponents(UICommonItem)
    if self.rewardModels~=nil then
        for k,v in pairs(self.rewardModels) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.rewardModels ={}
    self.rewardItemsList = {}
end

function UIHeroTrialTaskCell:GetForward()
    local desPos = UIUtil.GetUIMainSavePos(UIMainSavePosType.Goods)
    for i, v in ipairs(self.taskValue.rewardList) do
        local rewardType = v.rewardType
        local itemId = v.itemId
        local pic = RewardUtil.GetPic(v.rewardType,itemId)
        local rewardPos = self.rewardItemsList[i]
        if pic~="" then
            UIUtil.DoFly(tonumber(rewardType),1,pic,rewardPos.transform.position,desPos)
        end
    end
end

function UIHeroTrialTaskCell:GetRewardClick()
    if self.taskValue.state ~= 1 then
        return
    end 
    SFSNetwork.SendMessage(MsgDefines.TaskRewardGet,{id = self.taskId})
end

return UIHeroTrialTaskCell