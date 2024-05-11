--- Created by shimin.
--- DateTime: 2021/7/29 3:59
--- 迁城界面

local WarFeverContent = BaseClass("WarFeverContent", UIBaseContainer)
local base = UIBaseContainer

local WarFeverItemCell   = require("UI.UICityManage.Component.WarFeverItemCell")

local Localization = CS.GameEntry.Localization


local des_txt_Path = "Viewport/Content/Text_Des"
local power_txt_Path = "Viewport/Content/Rect_Power/Text_power"
local powerDes_txt_Path = "Viewport/Content/Rect_Power/Text_power/Text_powerDes"
local state_txt_Path = "Viewport/Content/Text_State"
local cityLevel_txt_Path = "Viewport/Content/Image/ContentTitleBg/title_cityLevel"
local cityStatus_txt_Path = "Viewport/Content/Image/ContentTitleBg/title_cityStatus"
local content_path = "Viewport/Content/Image"


--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
   -- self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:SetAllCellDestroy()
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)


    self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_Path)
    self.power_txt = self:AddComponent(UITextMeshProUGUIEx, power_txt_Path)
    self.powerDes_txt = self:AddComponent(UITextMeshProUGUIEx, powerDes_txt_Path)
    self.state_txt = self:AddComponent(UITextMeshProUGUIEx, state_txt_Path)
    self.cityLevel_txt = self:AddComponent(UITextMeshProUGUIEx, cityLevel_txt_Path)
    self.cityStatus_txt = self:AddComponent(UITextMeshProUGUIEx, cityStatus_txt_Path)
    
    self.content = self:AddComponent(UIBaseContainer,content_path)
    
    self.itemList ={}
    self.cells = {}

    self.attackNum = warFeverAttackInit

end

local function ComponentDestroy(self)
    self.des_txt = nil
    self.power_txt = nil
    self.powerDes_txt = nil
    self.state_txt = nil
    self.cityLevel_txt = nil
    self.cityStatus_txt = nil


    self.itemList =nil
    self.cells = nil
    self.scroll_view = nil
    self.attackNum = nil
end


local function DataDefine(self)

end

local function DataDestroy(self)

end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)

end


local function OnRemoveListener(self)
    base.OnRemoveListener(self)

end

local function ReInit(self)
    
    self.des_txt:SetLocalText(129027) 
    self.power_txt:SetLocalText(129030) 
    local param = DataCenter.StatusManager:GetWarFeverStatusValue()
    self.itemList =self:MakeData()
    if param ~= nil then
        self.state_txt :SetText(Localization:GetString("129025") .."("..Localization:GetString("120204")..")") --激活状态
    else
        self.state_txt :SetText(Localization:GetString("129025").."("..Localization:GetString("130261")..")") ----未激活状态
    end
    self.cityLevel_txt:SetLocalText(130392) 
    self.cityStatus_txt:SetLocalText(300648) 
    self.powerDes_txt :SetText("+ "..self.attackNum.."%")
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.content.rectTransform)
   self:InitData()
end



local function InitData(self)
    self.model = {}
    for i = 1 ,table.count(self.itemList) do
        --复制基础prefab，每次循环创建一次
        self.model[i] = self:GameObjectInstantiateAsync(UIAssets.WarFeverItemCell, function(request)
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
            local cell = self.content:AddComponent(WarFeverItemCell,nameStr)
            cell:ReInit(self.itemList[i])
        end)
    end
end

local function SetAllCellDestroy(self)
    self.content:RemoveComponents(WarFeverItemCell)
    if self.model~=nil then
        for k,v in pairs(self.model) do
            if v ~= nil then
                self:GameObjectDestroy(v)
            end
        end
    end
end

-- 制造假数据
local function MakeData(self)
    local list = {}
    local tempList = DataCenter.StatusManager:GetWarFeverData()
    local feverList = {}
    self.attackNum = 0
    for k, v in pairs(tempList) do
      local statItem = LocalController:instance():getLine(TableName.StatusTab,tostring(v.status))
      local param = {}
        param.level = v.level
        param.status = statItem.time 
        table.insert( feverList ,param)
        -- 根据大本等级给攻击值赋值
        if param.level == DataCenter.BuildManager.MainLv then
            self.attackNum = tonumber(statItem.effect_num)
        elseif self.attackNum<=0 then
            self.attackNum = warFeverAttackInit
        end
    end

    local tempParam = {}
    tempParam.level = feverList[1].level
    tempParam.status = feverList[1].status
    local endLevel  = nil
    local endStatu = nil
    local isAdd = false
    for k, v in pairs(feverList) do
        isAdd = false
        if  v.status == tempParam.status then
            endLevel = v.level
            endStatu = v.status
            if k == #feverList then
                isAdd = true
            end
        else
            isAdd = true
        end

        if isAdd == true then
            local param = {}
            if endLevel ~= nil and endStatu ~= nil then
                param.level = tempParam.level .."~" .. endLevel
                param.statu = endStatu
            else
                param.level = tempParam.level
                param.statu = tempParam.status
            end

            endLevel = nil
            endStatu = nil
            tempParam.level = v.level
            tempParam.status = v.status
            table.insert(list,param)
        end
        
    end
    return list
end

WarFeverContent.OnCreate = OnCreate
WarFeverContent.OnDestroy = OnDestroy
WarFeverContent.OnEnable = OnEnable
WarFeverContent.OnDisable = OnDisable
WarFeverContent.ComponentDefine = ComponentDefine
WarFeverContent.ComponentDestroy = ComponentDestroy
WarFeverContent.DataDefine = DataDefine
WarFeverContent.DataDestroy = DataDestroy
WarFeverContent.OnAddListener = OnAddListener
WarFeverContent.OnRemoveListener = OnRemoveListener
WarFeverContent.ReInit = ReInit
WarFeverContent.InitData = InitData
WarFeverContent.MakeData = MakeData
WarFeverContent.SetAllCellDestroy = SetAllCellDestroy
return WarFeverContent