---
--- Created by shimin.
--- DateTime: 2022/3/10 22:32
--- 联盟职业每一行cell
---

local UIAllianceCareerEditRow = BaseClass("UIAllianceCareerEditRow",UIBaseContainer)
local base = UIBaseContainer

local UIAllianceCareerChangeCell = require "UI.UIAlliance.UIAllianceCareer.Component.UIAllianceCareerChangeCell"
local UIAllianceCareerAddCell = require "UI.UIAlliance.UIAllianceCareer.Component.UIAllianceCareerAddCell"

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
    self.name_text = self:AddComponent(UIText, name_text_path)
    self.num_text = self:AddComponent(UIText, num_text_path)
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
    self.addCell = nil
    self.curNum = 0
    self.addCellReq = nil
end

local function DataDestroy(self)
    self.param = nil
    self.select = nil
    self.model = nil
    self.req = nil
    self.free = nil
    self.curNum = nil
    self.addCell = nil
    self.addCellReq = nil
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
            param.closeCallBack = function(info) 
                self:CloseCallBack(info)
            end
            param.editCallBack = function()
                self:EditCallBack()
            end
            if table.count(self.free) > 0 then
                local cell = table.remove(self.free)
                cell.gameObject:SetActive(true)
                cell:ReInit(param)
                cell.transform:SetAsLastSibling()
                self.model[v.uid] = cell
            else
                self.req[k] = self:GameObjectInstantiateAsync(UIAssets.UIAllianceCareerChangeCell, function(request)
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
                    local cell = self.career_content:AddComponent(UIAllianceCareerChangeCell,nameStr)
                    cell:ReInit(param)
                    self.model[v.uid] = cell
                    cell.transform:SetAsLastSibling()
                    if table.count(self.req) == 0 and self.addCell ~= nil then
                        self.addCell.transform:SetAsLastSibling()
                    end
                end)
                
            end
        end
        if self.curNum < self.param.max then
            if self.addCellReq == nil then
                local param = {}
                param.careerType = self.param.careerType
                param.editCallBack = function()
                    self:EditCallBack()
                end
                if self.addCell == nil then
                    self.addCellReq = self:GameObjectInstantiateAsync(UIAssets.UIAllianceCareerAddCell, function(request)
                        if request.isError then
                            return
                        end
                        self.addCellReq = nil
                        local go = request.gameObject
                        go.gameObject:SetActive(true)
                        go.transform:SetParent(self.career_content.transform)
                        go.transform:SetAsLastSibling()
                        go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                        local nameStr = tostring(NameCount)
                        go.name = nameStr
                        NameCount = NameCount + 1
                        self.addCell = self.career_content:AddComponent(UIAllianceCareerAddCell,nameStr)
                        self.addCell:ReInit(param)
                    end)
                else
                    self.addCell.gameObject:SetActive(true)
                    self.addCell.transform:SetAsLastSibling()
                    self.addCell:ReInit(param)
                end
            end
        else
            if self.addCellReq == nil then
                if self.addCell ~= nil then
                    self.addCell.gameObject:SetActive(false)
                end
            else
                self.addCellReq:Destroy()
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

local function CloseCallBack(self,info)
    if self.param.closeCallBack ~= nil then
        self.param.closeCallBack(info)
        if self.model[info.uid] ~= nil then
            self.model[info.uid].gameObject:SetActive(false)
            table.insert(self.free,self.model[info.uid])
            self.model[info.uid] = nil
        end
        self.curNum = self.curNum - 1
        self.num_text:SetText(self.curNum .. "/" .. self.param.max)
        self:RefreshPanel()
    end
end

local function EditCallBack(self)
    if self.param.editCallBack ~= nil then
        self.param.editCallBack(self.param.careerType)
    end
end

local function RefreshPanel(self)
    self:ShowCareerCells()
end



UIAllianceCareerEditRow.OnCreate = OnCreate
UIAllianceCareerEditRow.OnDestroy = OnDestroy
UIAllianceCareerEditRow.ComponentDefine = ComponentDefine
UIAllianceCareerEditRow.ComponentDestroy = ComponentDestroy
UIAllianceCareerEditRow.DataDefine = DataDefine
UIAllianceCareerEditRow.DataDestroy = DataDestroy
UIAllianceCareerEditRow.OnEnable = OnEnable
UIAllianceCareerEditRow.OnDisable = OnDisable
UIAllianceCareerEditRow.OnAddListener = OnAddListener
UIAllianceCareerEditRow.OnRemoveListener = OnRemoveListener
UIAllianceCareerEditRow.ReInit = ReInit
UIAllianceCareerEditRow.OnShowBtnClick = OnShowBtnClick
UIAllianceCareerEditRow.ShowCareerCells = ShowCareerCells
UIAllianceCareerEditRow.RefreshArrow = RefreshArrow
UIAllianceCareerEditRow.ClearReq = ClearReq
UIAllianceCareerEditRow.RemoveModel = RemoveModel
UIAllianceCareerEditRow.CloseCallBack = CloseCallBack
UIAllianceCareerEditRow.EditCallBack = EditCallBack
UIAllianceCareerEditRow.RefreshPanel = RefreshPanel

return UIAllianceCareerEditRow