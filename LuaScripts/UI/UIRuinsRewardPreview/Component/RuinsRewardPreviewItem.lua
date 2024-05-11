---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by Imaginaerum.
--- DateTime: 2023/10/9 16:42
---
local RuinRewardItem = require "UI.UIRuinsRewardPreview.Component.RuinRewardItem"
local RuinsRewardPreviewItem = BaseClass("RuinsRewardPreviewItem",UIBaseContainer)
local base = UIBaseContainer

local score_path = "codeTxt"
local rank_path = "numTxt"
local content_path ="Content"
local Localization = CS.GameEntry.Localization
local function OnCreate(self)
    base.OnCreate(self)
    self.rank = self:AddComponent(UITextMeshProUGUIEx,rank_path)
    self.score = self:AddComponent(UITextMeshProUGUIEx,score_path)
    self.content = self:AddComponent(UIBaseContainer,content_path)
    self.model = {}
end

local function SetItemShow(self, data)
    self.data = data
    self.rank:SetText(self.data.index)
    self.score:SetText(string.GetFormattedSeperatorNum(math.floor(self.data.score)))
    self:SetAllCellDestroy()
    local list = self.data.rewards
    if list~=nil then
        for i = 1, table.length(list) do
            self.model[i] = self:GameObjectInstantiateAsync(UIAssets.RuinsRewardItem, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject;
                go.gameObject:SetActive(true)
                go.transform:SetParent(self.content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local cell = self.content:AddComponent(RuinRewardItem,nameStr)
                cell:RefreshData(list[i])
            end)
        end
    end

end


local function OnDestroy(self)
    self:SetAllCellDestroy()
    base.OnDestroy(self)
end

local function SetAllCellDestroy(self)
    self.content:RemoveComponents(RuinRewardItem)
    if self.model~=nil then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.model ={}
end


RuinsRewardPreviewItem.OnCreate = OnCreate
RuinsRewardPreviewItem.SetItemShow = SetItemShow
RuinsRewardPreviewItem.OnDestroy =OnDestroy
RuinsRewardPreviewItem.SetAllCellDestroy =SetAllCellDestroy
return RuinsRewardPreviewItem