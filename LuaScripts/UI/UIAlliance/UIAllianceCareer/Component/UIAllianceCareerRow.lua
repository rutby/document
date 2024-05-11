---
--- Created by shimin.
--- DateTime: 2022/3/10 22:32
--- 联盟职业每一行cell
---

local UIAllianceCareerRow = BaseClass("UIAllianceCareerRow",UIBaseContainer)
local base = UIBaseContainer

local UIAllianceCareerInfoCell = require "UI.UIAlliance.UIAllianceCareer.Component.UIAllianceCareerInfoCell"

local name_text_path = "mainContent/nameTxt"
local num_text_path = "mainContent/people"
local arrow_img_path = "mainContent/ImgArrowNormal"
local show_btn_path = "mainContent"
local career_content_path = "CareerContent"

local Normal = Vector3.New(0, 0, 0)
local Select = Vector3.New(0, 0, -90)

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.name_text = self:AddComponent(UITextMeshProUGUIEx, name_text_path)
    self.num_text = self:AddComponent(UITextMeshProUGUIEx, num_text_path)
    self.arrow_img = self:AddComponent(UIBaseContainer, arrow_img_path)
    self.career_content = self:AddComponent(UIBaseContainer, career_content_path)
    self.show_btn = self:AddComponent(UIButton, show_btn_path)
    self.show_btn:SetOnClick(function()
        self:OnShowBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.name_text = nil
    self.num_text = nil
    self.arrow_img = nil
    self.career_content = nil
    self.show_btn = nil
end


local function DataDefine(self)
    self.param = nil
    self.select = false
    self.model = {}
    self.req = {}
    self.free = {}
    self.curNum = 0
end

local function DataDestroy(self)
    self.param = nil
    self.select = nil
    self.model = nil
    self.req = nil
    self.free = nil
    self.curNum = nil
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function ReInit(self,param)
    self.param = param
    self:ShowCareerCells()
    self.select = true
    self:RefreshArrow()
end

local function OnAddListener(self)
    base.OnAddListener(self)

end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)

end

local function OnShowBtnClick(self)
    self.select = not self.select
    self:RefreshArrow()
end

local function RefreshArrow(self)
    if self.select then
        self.arrow_img.transform.localRotation = Select
        self.career_content:SetActive(true)
    else
        self.arrow_img.transform.localRotation = Normal
        self.career_content:SetActive(false)
    end
end


local function ShowCareerCells(self)
    self:ClearReq()
    self:RemoveModel()
    local list = DataCenter.AllianceCareerManager:GetAllianceMemberPosListByCareer(self.param.careerType)
    if list ~= nil then
        self.curNum = table.count(list)
        self.num_text:SetText(self.curNum .. "/" .. self.param.max)
        for k,v in ipairs(list) do
            local param = {}
            param.data = v
            param.cellCallBack = self.param.cellCallBack
            if table.count(self.free) > 0 then
                local cell = table.remove(self.free)
                cell.gameObject:SetActive(true)
                cell:ReInit(param)
                self.model[v.uid] = cell
                cell.transform:SetAsLastSibling()
            else
                self.req[k] = self:GameObjectInstantiateAsync(UIAssets.UIAllianceCareerInfoCell, function(request)
                    if request.isError then
                        return
                    end
                    self.req[k] = nil
                    local go = request.gameObject;
                    go.gameObject:SetActive(true)
                    go.transform:SetParent(self.career_content.transform)
                    go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                    local nameStr = tostring(NameCount)
                    go.name = nameStr
                    NameCount = NameCount + 1
                    local cell = self.career_content:AddComponent(UIAllianceCareerInfoCell,nameStr)
                    cell:ReInit(param)
                    cell.transform:SetAsLastSibling()
                    self.model[v.uid] = cell
                end)
                
            end
        end
    end
end

local function ClearReq(self)
    if self.req ~= nil then
        for k,v in pairs(self.req) do
            v:Destroy()
        end
    end
    self.req = {}
end

local function RemoveModel(self)
    for k,v in pairs(self.model) do
        v.gameObject:SetActive(false)
        table.insert(self.free,v)
    end
    self.model = {}
end

local function RefreshPanel(self) 
    self:ShowCareerCells()
end

UIAllianceCareerRow.OnCreate = OnCreate
UIAllianceCareerRow.OnDestroy = OnDestroy
UIAllianceCareerRow.ComponentDefine = ComponentDefine
UIAllianceCareerRow.ComponentDestroy = ComponentDestroy
UIAllianceCareerRow.DataDefine = DataDefine
UIAllianceCareerRow.DataDestroy = DataDestroy
UIAllianceCareerRow.OnEnable = OnEnable
UIAllianceCareerRow.OnDisable = OnDisable
UIAllianceCareerRow.OnAddListener = OnAddListener
UIAllianceCareerRow.OnRemoveListener = OnRemoveListener
UIAllianceCareerRow.ReInit = ReInit
UIAllianceCareerRow.OnShowBtnClick = OnShowBtnClick
UIAllianceCareerRow.ShowCareerCells = ShowCareerCells
UIAllianceCareerRow.RefreshArrow = RefreshArrow
UIAllianceCareerRow.ClearReq = ClearReq
UIAllianceCareerRow.RemoveModel = RemoveModel
UIAllianceCareerRow.RefreshPanel = RefreshPanel

return UIAllianceCareerRow