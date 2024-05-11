--- Created by shimin.
--- DateTime: 2022/6/16 19:55
--- 英雄委托气泡

local HeroEntrustBubble = BaseClass("HeroEntrustBubble")

local bg_path = "Go/Bg"
local trigger_path = "Go/Bg/Trigger"
local go_path = "Go"
local cell_go_path = "Go/Bg/CellGo"
local cell_icon_path = ""
local cell_complete_go_path = "CompleteGo"

local AnimName =
{
    Enter = "EnterBubble",
    Hide = "HideBubble",
    Normal = "NormalBubble",
    Default = "Default",
}

--创建
function HeroEntrustBubble:OnCreate(go)
    if go ~= nil then
        self.gameObject = go.gameObject
        self.transform = go.gameObject.transform
    end
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
function HeroEntrustBubble:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
end

function HeroEntrustBubble:ComponentDefine()
    self.anim = self.transform:Find(go_path):GetComponent(typeof(CS.SimpleAnimation))
    self.bg = self.transform:Find(bg_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
    self.trigger = self.transform:Find(trigger_path):GetComponent(typeof(CS.TouchObjectEventTrigger))
    self.cell_go = self.transform:Find(cell_go_path).transform
    self.bg:Set_color_a(1.0)
    self.bg:Set_color_a(1.0)
    self.trigger.onPointerClick = function()
        self:OnBtnClick()
    end
    self.cell = {}
    local childCnt = self.cell_go.childCount
    for i = 0, childCnt-1, 1 do
        local child = self.cell_go:GetChild(i)
        local param = {}
        param.icon = child.transform:Find(cell_icon_path):GetComponent(typeof(CS.UnityEngine.SpriteRenderer))
        param.completeGo = child.transform:Find(cell_complete_go_path).gameObject
        self.cell[i + 1] = param
    end
end

function HeroEntrustBubble:ComponentDestroy()
    self.anim = nil
    self.bg = nil
    self.trigger = nil
    self.cell_go = nil
    self.cell = {}
end


function HeroEntrustBubble:DataDefine()
    self.param = {}
    self.offset = nil
    self.heroEntrustTemplate = nil
end

function HeroEntrustBubble:DataDestroy()
    self.param = {}
    self.offset = nil
    self.heroEntrustTemplate = nil
end

function HeroEntrustBubble:ReInit(param)
    self.param = param
    if param.offset == nil then
        self.offset = Vector3.zero
    else
        self.offset = param.offset
    end
    self:ShowCells()
    self:UpdatePos()
    self:Refresh()
    self:SetActive(param.visible)
end

--更新位置
function HeroEntrustBubble:UpdatePos()
    if self.param.target ~= nil then
        self.transform.position = self.param.target.position + self.offset
    end
end

function HeroEntrustBubble:OnBtnClick()
    SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroEntrust, self.param.id)
end

function HeroEntrustBubble:ShowCells()
    self.heroEntrustTemplate = DataCenter.HeroEntrustTemplateManager:GetHeroEntrustTemplate(self.param.id)
    if self.heroEntrustTemplate ~= nil then
        for k,v in ipairs(self.heroEntrustTemplate.need) do
            if self.cell[k] ~= nil then
                if v.needType == HeroEntrustNeedType.Resource then
                    self.cell[k].icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(v.needId))
                elseif v.needType == HeroEntrustNeedType.Goods then
                    local template = DataCenter.ItemTemplateManager:GetItemTemplate(v.needId)
                    if template ~= nil then
                        self.cell[k].icon:LoadSprite(string.format(LoadPath.ItemPath, template.icon))
                    end
                end
            end
        end
    end
end

function HeroEntrustBubble:Refresh()
    for k,v in ipairs(self.cell) do
        v.completeGo:SetActive(self.heroEntrustTemplate:HaveEnoughGoods(k))
    end
end

function HeroEntrustBubble:SetActive(active)
    if active then
        self.gameObject:SetActive(true)
        self.anim:Play(AnimName.Enter)
        self.anim:Play(AnimName.Normal)
    else
        self.gameObject:SetActive(false)
    end
end

--获取引导气泡对象
function HeroEntrustBubble:GetBubbleObj()
    return self.trigger
end

return HeroEntrustBubble