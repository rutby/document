---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1.
--- DateTime: 2021/9/13 22:09
---
local MailResSupport = BaseClass("MailResSupport", UIBaseContainer)
local base = UIBaseContainer
local rapidjson = require "rapidjson"
local Localization = CS.GameEntry.Localization
local MailResSupportItem = require "UI.UIMailNew.UIMailMainPanel.Component.MailTypeContent.MailResSupportItem"

local mailTitle_path = "UIMailItemTitle/txtMainTitle"
local mailSubTitle_path = "UIMailItemTitle/txtSubTitle"
local mailTime_path = "UIMailItemTitle/txtTime"
local mailContent_path = "supportMails"

local function OnCreate(self)
    base.OnCreate(self)
    self.MailItemsList = {}
    self.mailModelCount = 0
    
    self.mailTitleN = self:AddComponent(UITextMeshProUGUIEx, mailTitle_path)
    self.mailSubTitleN = self:AddComponent(UITextMeshProUGUIEx, mailSubTitle_path)
    self.mailTimeN = self:AddComponent(UITextMeshProUGUIEx, mailTime_path)
    self.mailContentN = self:AddComponent(UIBaseContainer, mailContent_path)
end

local function OnDestroy(self)
    self.mailTitleN = nil
    self.mailSubTitleN = nil
    self.mailTimeN = nil
    self.mailContentN = nil
    base.OnDestroy(self)
end

local function OnAddListener(self)
    self:AddUIListener(EventId.ContentLayoutReposition, self.RepositionAll)
end

local function OnRemoveListener(self)
    self:RemoveUIListener(EventId.ContentLayoutReposition, self.RepositionAll)
end

local function setData(self, mailData)
    self.virMailData = mailData
    self.mailTitleN:SetText(MailShowHelper.GetMainTitle(self.virMailData))
    self.mailSubTitleN:SetText(MailShowHelper.GetMailSubTitle(self.virMailData))
    self.mailTimeN:SetText(MailShowHelper.GetRelativeCreateTime(self.virMailData))

    local list = DataCenter.MailDataManager:GetGroupMailList(MailTypeToInternalGroup[mailData.type])
    
    self:SetAllMailItemDestroy()
    self.mailModelCount =0
    if list~=nil and #list>0 then
        for i = 1, table.length(list) do
            --复制基础prefab，每次循环创建一次
            self.mailModelCount= self.mailModelCount+1
            self.MailItemModels[self.mailModelCount] = self:GameObjectInstantiateAsync(UIAssets.MailResSupportItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.mailContentN.transform)
                CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mailContentN.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.mailContentN:AddComponent(MailResSupportItem,nameStr)
                cell:RefreshData(list[i])
                table.insert(self.MailItemsList,cell)
            end)
        end
    end
end

local function SetAllMailItemDestroy(self)
    self.mailContentN:RemoveComponents(MailResSupportItem)
    if self.MailItemModels~=nil then
        for k,v in pairs(self.MailItemModels) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.MailItemModels ={}
    self.MailItemsList = {}
end

local function RepositionAll(self)
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.mailContentN)
end

MailResSupport.OnCreate = OnCreate
MailResSupport.OnDestroy = OnDestroy
MailResSupport.OnAddListener = OnAddListener
MailResSupport.OnRemoveListener = OnRemoveListener
MailResSupport.setData = setData
MailResSupport.SetAllMailItemDestroy = SetAllMailItemDestroy
MailResSupport.RepositionAll = RepositionAll

return MailResSupport