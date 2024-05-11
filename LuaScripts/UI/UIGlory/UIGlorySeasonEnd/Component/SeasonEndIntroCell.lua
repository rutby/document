---
--- 
--- Created by 
--- DateTime: 
---
local SeasonEndIntroCell = BaseClass("SeasonEndIntroCell", UIBaseContainer)
local base = UIBaseContainer
local SeasonEndTxt = require "UI.UIGlory.UIGlorySeasonEnd.Component.SeasonEndTxt"
function SeasonEndIntroCell:OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

function SeasonEndIntroCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function SeasonEndIntroCell:OnEnable()
    base.OnEnable(self)
end

function SeasonEndIntroCell:OnDisable()
    base.OnDisable(self)
end

function SeasonEndIntroCell:ComponentDefine()
    self._txt_leftTitle = self:AddComponent(UIText, "Txt_LeftTitle")
    self._txt_rightContent = self:AddComponent(UIBaseContainer, "Txt_RightContent")
end

function SeasonEndIntroCell:ComponentDestroy()

end

function SeasonEndIntroCell:DataDefine()
    
end

function SeasonEndIntroCell:DataDestroy()
    
end

function SeasonEndIntroCell:ReInit(param)
    if param then
        local intro = string.split(param,";")
        if intro[1] then
            self._txt_leftTitle:SetLocalText(intro[1])
        end
        if intro[2] then
            local list = string.split(intro[2],",")
            self:SetCellDestroy()
            for i = 1, table.length(list) do
                --复制基础prefab，每次循环创建一次
                self.modelFirst[i] = self:GameObjectInstantiateAsync(UIAssets.SeasonEndTxt, function(request)
                    if request.isError then
                        return
                    end
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self._txt_rightContent.transform)
                    go.name ="itemTxt" .. i
                    local cell = self._txt_rightContent:AddComponent(SeasonEndTxt,go.name)
                    cell:ReInit(list[i])
                    if i ==  table.length(list) then
                        CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.view.content.rectTransform)
                    end
                end)
            end
        end
    end
end

function SeasonEndIntroCell:SetCellDestroy()
    self._txt_rightContent:RemoveComponents(SeasonEndTxt)
    if self.modelFirst~=nil then
        for k,v in pairs(self.modelFirst) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
    self.modelFirst = {}
end

return SeasonEndIntroCell