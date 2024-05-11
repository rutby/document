
local UIMysteriousRewardPreviewView = BaseClass("UIMysteriousRewardPreviewView", UIBaseView)
local base = UIBaseView
local Localization = CS.GameEntry.Localization
local MiningRewardPreviewItem = require "UI.UIMiningRewardPreview.Comp.MiningRewardPreviewItem"
local UICommonItem = require "UI.UICommonItem.UICommonItem"

local title_path = "UICommonPopUpTitle/bg_mid/titleText"
local Content = "ScrollView/Viewport/Content"
local finalTxt_path = "ScrollView/Viewport/Content/RectFinalReward/finalTxt"
local finalContent_path = "ScrollView/Viewport/Content/RectFinalReward/finalContent"
local rectFinal_path = "ScrollView/Viewport/Content/RectFinalReward"
local gearTxt_path = "ScrollView/Viewport/Content/RectGearReward/gearTxt"
local gearContent_path = "ScrollView/Viewport/Content/RectGearReward/gearContent"
local rectGear_path = "ScrollView/Viewport/Content/RectGearReward"
local commonTxt_path = "ScrollView/Viewport/Content/RectCommonReward/commonTxt"
local commonContent_path = "ScrollView/Viewport/Content/RectCommonReward/commonContent"
local rectCommon_path = "ScrollView/Viewport/Content/RectCommonReward"
local closeBtn_path = "UICommonPopUpTitle/bg_mid/CloseBtn"
local maskBtn_path = "UICommonPopUpTitle/panel"


function UIMysteriousRewardPreviewView:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function UIMysteriousRewardPreviewView:OnDestroy()
    self:SetAllCellDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function UIMysteriousRewardPreviewView:OnEnable()
    base.OnEnable(self)
    self.actId = tonumber(self:GetUserData())
    self.round = DataCenter.MysteriousManager:GetRoundByActId(self.actId)
    self:RefreshView()
end

function UIMysteriousRewardPreviewView:OnDisable()
    base.OnDisable(self)
end

function UIMysteriousRewardPreviewView:ComponentDefine()
    self.closeBtnN = self:AddComponent(UIButton, closeBtn_path)
    self.closeBtnN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.maskBtnN = self:AddComponent(UIButton, maskBtn_path)
    self.maskBtnN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.titleTxt = self:AddComponent(UIText, title_path)
    self.titleTxt:SetLocalText(302026)
    
    self.content = self:AddComponent(UIBaseContainer,Content)

    self.finalTxt = self:AddComponent(UIText, finalTxt_path)
    self.finalTxt:SetLocalText(375056)
    self.finalContent = self:AddComponent(UIBaseContainer, finalContent_path)
    self.rectFinal = self:AddComponent(UIBaseContainer, rectFinal_path)
    
    self.gearTxt = self:AddComponent(UIText,gearTxt_path)
    self.gearTxt:SetLocalText(375057)
    self.gearContent = self:AddComponent(UIBaseContainer, gearContent_path)
    self.rectGear = self:AddComponent(UIBaseContainer, rectGear_path)

    self.commonTxt = self:AddComponent(UIText,commonTxt_path)
    self.commonTxt:SetLocalText(375058)
    self.commonContent = self:AddComponent(UIBaseContainer, commonContent_path)
    self.rectCommon = self:AddComponent(UIBaseContainer, rectCommon_path)
end

function UIMysteriousRewardPreviewView:ComponentDestroy()
    self.createBtnTxtN = nil
    self.closeBtnN = nil
end

function UIMysteriousRewardPreviewView:DataDefine()
    self.modelFinalList = {}
    self.compFinalList = {}
    self.modelGearList = {}
    self.compGearList = {}
    self.modelCommonList = {}
    self.compCommonList = {}
end

function UIMysteriousRewardPreviewView:DataDestroy()
    self.modelFinalList = nil
    self.compFinalList = nil
    self.modelGearList = nil
    self.compGearList = nil
    self.modelCommonList = nil
    self.compCommonList = nil
end

function UIMysteriousRewardPreviewView:RefreshView()
    local info = DataCenter.MysteriousManager:GetRewardPreviewInfo(self.actId)
    self:RefreshGearReward(info.gearRewardInfoList[self.round])
    self:RefreshFinalReward(info.finalRewardInfoList[self.round])
    self:RefreshCommonReward(info.commonRewardInfoList)
end

function UIMysteriousRewardPreviewView:SetAllCellDestroy()
    self.gearContent:RemoveComponents(UICommonItem)
    if self.modelGearList~=nil then
        for k,v in pairs(self.modelGearList) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.finalContent:RemoveComponents(MiningRewardPreviewItem)
    if self.modelFinalList~=nil then
        for k,v in pairs(self.modelFinalList) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.commonContent:RemoveComponents(UICommonItem)
    if self.modelCommonList~=nil then
        for k,v in pairs(self.modelCommonList) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

function UIMysteriousRewardPreviewView : RefreshFinalReward(rewardInfoList)
    if(rewardInfoList == nil or #rewardInfoList <= 0) then
        self.rectFinal:SetActive(false)
    else
        self.rectFinal:SetActive(true)
        for i = 1, #self.compFinalList do
            self.compFinalList[i]:SetActive(false)
        end
        for i = 1, table.count(rewardInfoList) do
            if(i > #self.modelFinalList)then
                --没有已创建的go,创建一次
                self.modelFinalList[i] = self:GameObjectInstantiateAsync(UIAssets.MiningRewardPreviewItem, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.finalContent.transform)
                    go.transform:Set_localScale(1,1,1)
                    go.name = "final"..i
                    local cell = self.finalContent:AddComponent(MiningRewardPreviewItem, go.name)
                    cell:ReInit(rewardInfoList[i])
                    self.compFinalList[i] = cell
                end)
            else
                self.compFinalList[i]:SetActive(true)
                self.compFinalList[i]:SetItem(rewardInfoList[i])
            end
        end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.finalContent.rectTransform)
end

function UIMysteriousRewardPreviewView : RefreshGearReward(rewardInfoList)
    if(rewardInfoList == nil or #rewardInfoList <= 0) then
        self.rectGear:SetActive(false)
    else
        self.rectGear:SetActive(true)
        for i = 1, #self.compGearList do
            self.compGearList[i]:SetActive(false)
        end
        for i = 1, table.count(rewardInfoList) do
            if(i > #self.modelGearList)then
                --没有已创建的go,创建一次
                self.modelGearList[i] = self:GameObjectInstantiateAsync(UIAssets.UIMysteriousRewardItem, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.gearContent.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    go.name = "gear"..i
                    local cell = self.gearContent:AddComponent(UICommonItem, go.name)
                    cell:ReInit(rewardInfoList[i])
                    self.compGearList[i] = cell
                end)
            else
                self.compGearList[i]:SetActive(true)
                self.compGearList[i]:ReInit(rewardInfoList[i])
            end
        end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.gearContent.rectTransform)
end

function UIMysteriousRewardPreviewView : RefreshCommonReward(rewardInfoList)
    if(rewardInfoList == nil or #rewardInfoList <= 0) then
        self.rectCommon:SetActive(false)
    else
        self.rectCommon:SetActive(true)
        for i = 1, #self.compCommonList do
            self.compCommonList[i]:SetActive(false)
        end
        for i = 1, table.count(rewardInfoList) do
            if(i > #self.modelCommonList)then
                --没有已创建的go,创建一次
                self.modelCommonList[i] = self:GameObjectInstantiateAsync(UIAssets.UIMysteriousRewardItem, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.commonContent.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    go.name = "common"..i
                    local cell = self.commonContent:AddComponent(UICommonItem, go.name)
                    cell:ReInit(rewardInfoList[i])
                    self.compCommonList[i] = cell
                end)
            else
                self.compCommonList[i]:SetActive(true)
                self.compCommonList[i]:ReInit(rewardInfoList[i])
            end
        end
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.commonContent.rectTransform)
end

return UIMysteriousRewardPreviewView