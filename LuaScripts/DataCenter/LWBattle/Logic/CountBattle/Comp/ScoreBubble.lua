local ScoreBubble = {}
ScoreBubble.__index = ScoreBubble

local Resource = CS.GameEntry.Resource
local BUBBLE_PREFAB_MAP =
{
    ["BLUE"] = "Assets/Main/Prefabs/LWCountBattle/Huds/GroupBubbleBlue.prefab",
    ["RED"] = "Assets/Main/Prefabs/LWCountBattle/Huds/GroupBubbleRed.prefab",
}

function ScoreBubble.Create(resType, offset, score, visible, parent)
    local copy = {}
    setmetatable(copy, ScoreBubble)
    copy:Init(resType, offset, score, visible, parent)
    return copy
end

function ScoreBubble:Init(resType, offset, score, visible, parent)
    self.score = score
    self.visible = visible
    self.offset = offset
    self.parent = parent
    self.handle = Resource:InstantiateAsync(BUBBLE_PREFAB_MAP[resType])
    self.handle:completed('+', function(handle)
        local gameObject = handle.gameObject
        gameObject:SetActive(self.visible)
        local transform = gameObject.transform
        transform:Set_eulerAngles(45, 0, 0)
        transform:Set_localScale(1, 1, 1)
        self.transform = transform
        self.txtScore = gameObject:GetComponentInChildren(typeof(CS.SuperTextMesh))
        self.txtScore.text = tostring(self.score)
        self:SyncView()
    end)
    self.autoAnim = false
end

function ScoreBubble:Dispose()
    if self.bubbleTween then
        self.bubbleTween:Kill()
    end
    
    if not IsNull(self.handle) then
        self.handle:Destroy()
    end
    self.handle = nil
    self.transform = nil
    self.txtScore = nil
end

function ScoreBubble:SyncView()
    if IsNull(self.transform) then return end
    if IsNull(self.parent) then return end

    local px, py, pz = self.parent:Get_position()
    self.transform:Set_position(px + self.offset.x, py + self.offset.y, pz + self.offset.z)
end

function ScoreBubble:SetScore(score)
    if self.score ~= score then
        if not IsNull(self.txtScore) then
            self.txtScore.text = tostring(score)
        end
        if self.autoAnim then
            if self.score < score then
                self:ExpandAnim()
            else
                self:ShrinkAnim()
            end
        end
        self.score = score
    end
end

function ScoreBubble:ExpandAnim()
    if self.bubbleTween then
        self.bubbleTween:Kill()
    end
    if not IsNull(self.transform) then
        self.transform:Set_localScale(1, 1, 1)
        self.bubbleTween = self.transform:DOScale(Vector3(1.2, 1.2, 1), 0.1):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo):SetEase(CS.DG.Tweening.Ease.Linear)
    end
end

function ScoreBubble:ShrinkAnim()
    if self.bubbleTween then
        self.bubbleTween:Kill()
    end
    if not IsNull(self.transform) then
        self.transform:Set_localScale(1, 1, 1)
        self.bubbleTween = self.transform:DOScale(Vector3(0.8, 0.8, 1), 0.1):SetLoops(2, CS.DG.Tweening.LoopType.Yoyo):SetEase(CS.DG.Tweening.Ease.Linear)
    end
end

function ScoreBubble:SetVisible(visible)
    self.visible = visible
    if not IsNull(self.handle) and not IsNull(self.handle.gameObject) then
        self.handle.gameObject:SetActive(self.visible)
    end
end

return ScoreBubble