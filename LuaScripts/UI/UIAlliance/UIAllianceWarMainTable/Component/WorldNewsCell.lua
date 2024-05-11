---
--- 火星情报界面
--- Created by shimin
--- DateTime:2023/2/28 11:51
---
local WorldNewsCell = BaseClass("WorldNewsCell",UIBaseContainer)
local base = UIBaseContainer
local WorldNewsAbbrCell = require "UI.UIAlliance.UIAllianceWarMainTable.Component.WorldNewsAbbrCell"

local title_text_path = "Text_title"
local time_text_path = "timeLabel"
local pos_text_path = "posText"
local des_text_path = "desText"
local alliance_content_path = "allianceContent"
local empty_text_path = "emptyText"
local goto_btn_path = "GotoBtn"
local goto_btn_text_path = "GotoBtn/btnTxt"

function WorldNewsCell:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

function WorldNewsCell:ComponentDefine()
    self.title_text = self:AddComponent(UIText, title_text_path)
    self.time_text = self:AddComponent(UIText, time_text_path)
    self.pos_text = self:AddComponent(UIText, pos_text_path)
    self.alliance_content = self:AddComponent(UIBaseContainer, alliance_content_path)
    self.empty_text = self:AddComponent(UIText, empty_text_path)
    self.goto_btn_text = self:AddComponent(UIText, goto_btn_text_path)
    self.des_text = self:AddComponent(UIText, des_text_path)
    self.goto_btn = self:AddComponent(UIButton, goto_btn_path)
    self.goto_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnGotoBtnClick()
    end)
end

function WorldNewsCell:ComponentDestroy()

end

function WorldNewsCell:DataDefine()
    self.param = {}
    self.abbrCell = {}
end

function WorldNewsCell:DataDestroy()
    self.param = {}
    self.abbrCell = {}
end

function WorldNewsCell:OnDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function WorldNewsCell:OnEnable()
    base.OnEnable(self)
end

function WorldNewsCell:OnDisable()
    base.OnDisable(self)
end

function WorldNewsCell:ReInit(param)
    self.param = param
    self.title_text:SetLocalText(302152)
    self.goto_btn_text:SetLocalText(110088)
    self.des_text:SetLocalText(302145)
    local pos = SceneUtils.IndexToTilePos(self.param.pointId, ForceChangeScene.World)
    self.pos_text:SetText("(" .. pos.x .. "," .. pos.y .. ")")
    self.time_text:SetText(UITimeManager:GetInstance():TimeStampToTimeForServerMinute(self.param.time*1000))
    if #self.param.allianceAbbrList>0 then
        self.empty_text:SetActive(false)
    else
        self.empty_text:SetLocalText(302156)
        self.empty_text:SetActive(true)
    end
    self:ShowAbbrCells()
end

function WorldNewsCell:OnGotoBtnClick()
    GoToUtil.GotoWorldPos(SceneUtils.TileIndexToWorld(self.param.pointId, ForceChangeScene.World), 32, LookAtFocusTime)
    GoToUtil.CloseAllWindows()
end

function WorldNewsCell:ShowAbbrCells()
    local count = #self.param.allianceAbbrList
    for k,v in ipairs(self.param.allianceAbbrList) do
        if self.abbrCell[k] == nil then
            local param = {}
            self.abbrCell[k] = param
            param.visible = true
            param.abbrText = v
            param.req = self:GameObjectInstantiateAsync(UIAssets.WorldNewsAbbrCell, function(request)
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.alliance_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                local model = self.alliance_content:AddComponent(WorldNewsAbbrCell, nameStr)
                model:ReInit(param)
                param.model = model
            end)
        else
            self.abbrCell[k].visible = true
            self.abbrCell[k].abbrText = v
            if self.abbrCell[k].model ~= nil then
                self.abbrCell[k].model:ReInit(self.abbrCell[k])
            end
        end
    end
    local cellCount = #self.abbrCell
    if cellCount > count then
        for i = count + 1, cellCount, 1 do
            local cell = self.abbrCell[i]
            if cell ~= nil then
                cell.visible = false
                if cell.model ~= nil then
                    cell.model:ReInit(cell)
                end
            end
        end
    end
end

return WorldNewsCell