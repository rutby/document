
--英雄委托气泡管理器
local HeroEntrustBubbleManager = BaseClass("HeroEntrustBubbleManager")
local Resource = CS.GameEntry.Resource
local HeroEntrustBubble = require "Scene.HeroEntrustBubble.HeroEntrustBubble"

function HeroEntrustBubbleManager:__init()
    self.bubbleDict = {}
    self.HideTalkBubble = function(param) 
        self:HideTalkBubbleSignal(param) 
    end
    self.RefreshNpcTalkBubbleActive = function(param)
        self:RefreshNpcTalkBubbleActiveSignal(param)
    end
    self.RefreshHeroEntrust = function()
        self:Refresh()
    end
    self.ResourceUpdated = function()
        self:Refresh()
    end
    self.RefreshItems = function()
        self:Refresh()
    end
    self:AddListener()
end

function HeroEntrustBubbleManager:__delete()
    self:RemoveAll()
    self.bubbleDict = {}
    self:RemoveListener()
    self.HideTalkBubble = nil
    self.RefreshNpcTalkBubbleActive = nil
    self.RefreshHeroEntrust = nil
    self.ResourceUpdated = nil
    self.RefreshItems = nil
end

function HeroEntrustBubbleManager:Startup()
end


function HeroEntrustBubbleManager:AddListener()
    EventManager:GetInstance():AddListener(EventId.HideTalkBubble, self.HideTalkBubble)
    EventManager:GetInstance():AddListener(EventId.RefreshNpcTalkBubbleActive, self.RefreshNpcTalkBubbleActive)
    EventManager:GetInstance():AddListener(EventId.RefreshHeroEntrust, self.RefreshHeroEntrust)
    EventManager:GetInstance():AddListener(EventId.ResourceUpdated, self.ResourceUpdated)
    EventManager:GetInstance():AddListener(EventId.RefreshItems, self.RefreshItems)
end

function HeroEntrustBubbleManager:RemoveListener()
    EventManager:GetInstance():RemoveListener(EventId.HideTalkBubble, self.HideTalkBubble)
    EventManager:GetInstance():RemoveListener(EventId.RefreshNpcTalkBubbleActive, self.RefreshNpcTalkBubbleActive)
    EventManager:GetInstance():RemoveListener(EventId.RefreshHeroEntrust, self.RefreshHeroEntrust)
    EventManager:GetInstance():RemoveListener(EventId.ResourceUpdated, self.ResourceUpdated)
    EventManager:GetInstance():RemoveListener(EventId.RefreshItems, self.RefreshItems)
end

function HeroEntrustBubbleManager:AddOneHeroEntrustBubble(param)
    local target = param.target
    local template = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(param.id)
    if template ~= nil and target ~= nil then
        if self.bubbleDict[target] == nil then
            self.bubbleDict[target] = {}
        end
        param.modelName = string.format(UIAssets.NpcTalkBubbleHeroEntrust, table.count(template.need))
        if self.bubbleDict[target].param ~= nil and
                self.bubbleDict[target].param.modelName ~= param.modelName then
            self:RemoveOneHeroEntrustBubble(target)
        end
        param.visible = not DataCenter.BattleLevel:IsInBattleLevel()
        self.bubbleDict[target].param = param
        if self.bubbleDict[target].inst == nil then
            self.bubbleDict[target].inst = Resource:InstantiateAsync(param.modelName)
            self.bubbleDict[target].inst:completed('+', function(request)
                local model = HeroEntrustBubble.New()
                model:OnCreate(request)
                model:ReInit(self.bubbleDict[target].param)
                self.bubbleDict[target].model = model
            end)
        elseif self.bubbleDict[target].model ~= nil then
            self.bubbleDict[target].model:ReInit(self.bubbleDict[target].param)
        end
    end
end

function HeroEntrustBubbleManager:RemoveOneHeroEntrustBubble(target)
    if self.bubbleDict[target] ~= nil then
        if self.bubbleDict[target].model ~= nil then
            self.bubbleDict[target].model:OnDestroy()
        end
		if self.bubbleDict[target].inst ~= nil then
        	self.bubbleDict[target].inst:Destroy()
		end
        self.bubbleDict[target] = nil
    end
end

function HeroEntrustBubbleManager:RemoveAll()
    if self.bubbleDict then
        for t, n in pairs(self.bubbleDict) do
            self:RemoveOneHeroEntrustBubble(t)
        end
        self.bubbleDict = {}
    end
end

function HeroEntrustBubbleManager:SetHeroEntrustBubbleActive(param)
    if param ~= nil and param.target ~= nil then
        local target = param.target
        if self.bubbleDict[target] ~= nil then
            self.bubbleDict[target].param.visible = param.visible
            if self.bubbleDict[target].model ~= nil then
                self.bubbleDict[target].model:SetActive(param.visible)
            end
        end
    end
end

function HeroEntrustBubbleManager:Refresh()
    for k, v in pairs(self.bubbleDict) do
        if v.model ~= nil then
            v.model:Refresh()
        end
    end
end

function HeroEntrustBubbleManager:HideTalkBubbleSignal(param)
    if param ~= nil then
        self:RemoveOneHeroEntrustBubble(param.target)
    end
end
function HeroEntrustBubbleManager:RefreshNpcTalkBubbleActiveSignal(param)
    self:SetHeroEntrustBubbleActive(param)
end

--通过英雄委托id获取委托气泡
function HeroEntrustBubbleManager:GetHeroEntrustBubbleById(id)
    for k, v in pairs(self.bubbleDict) do
        if v.model ~= nil and v.param ~= nil and v.param.id == id then
            return v.model:GetBubbleObj()
        end
    end
end

return HeroEntrustBubbleManager