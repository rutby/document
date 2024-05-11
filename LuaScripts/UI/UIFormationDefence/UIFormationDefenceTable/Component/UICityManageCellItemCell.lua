

local UICityManageCellItemCell = BaseClass("UICityManageCellItemCell", UIBaseContainer)
local base = UIBaseContainer


local Localization = CS.GameEntry.Localization

local Cell = "Common_btn_close"
local listClose_btn_path = "ListcloseBtn"
local arrowIcon_path = "ListcloseBtn/Common_btn_listclose"
local item_icon_path = "UICommonItem/clickBtn/ItemIcon"
local title_txt_path = "Vert/Text_title"
local des_txt_Path = "Vert/Text_des"

local slider_txt_Path = "Vert/Progress/TimeSlider_up/Text_lv"
local slider_Path = "Vert/Progress/TimeSlider_up"
local sliderParent_Path  = "Vert/Progress"


--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
   -- self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.cell_btn = self:AddComponent(UIButton, Cell)
    self.listClose_btn = self:AddComponent(UIButton, listClose_btn_path)
    self.arrowIcon = self:AddComponent(UIBaseContainer, arrowIcon_path)
    self.item_icon = self:AddComponent(UIImage,item_icon_path)
    self.title_txt = self:AddComponent(UITextMeshProUGUIEx, title_txt_path)
    self.des_txt = self:AddComponent(UITextMeshProUGUIEx, des_txt_Path)
    
    self.cell_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
       self:OnItemClick()
    end)
    self.listClose_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnItemClick()
    end)

    
    self.sliderParent = self:AddComponent(UIBaseContainer,sliderParent_Path)
    self.slider_txt = self:AddComponent(UITextMeshProUGUIEx, slider_txt_Path)
    self.slider = self:AddComponent(UISlider,slider_Path)

    self.showTimer = nil
    self.timer_action = function(temp)
        self:RefreshTime()
    end
end

local function ComponentDestroy(self)
    self.cell_btn = nil
    self.item_icon = nil
    self.title_txt = nil
    self.des_txt = nil
    self.slider_txt = nil
    self.slider = nil

    if self.showTimer ~= nil then
        self.showTimer:Stop()
        self.showTimer = nil
    end
    self.timer_action = nil
    self:DeleteTimer()
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

local function ReInit(self,param)
--    local point = self:GetUserData()

    self.param = param
    if self.param ~= nil then
        self.title_txt:SetLocalText(self.param.name) 
        self.item_icon:LoadSprite(string.format(LoadPath.ItemPath,self.param.icon))
        self.sliderParent.gameObject:SetActive(false)
        if self.param.endTime ~= nil  and self.param.totalTime ~= nil then
            self.sliderParent.gameObject:SetActive(true)
            self:AddTimer()
            self:RefreshTime()
        end
        self:SetDesc()
    end
    self.arrowIcon:SetActive(self:CanClick())
end

local function CanClick(self)
    if self.param.id == CityManageBuffType.GolloesGuard or
       self.param.id == CityManageBuffType.GolloesFever or
       self.param.id == CityManageBuffType.AlCompeteScoreAdd1 or
       self.param.id == CityManageBuffType.AlCompeteScoreAdd2 or
       self.param.id == CityManageBuffType.DirectAttackCity then
        return false
    end
    return true
end

local function OnItemClick(self)
    if self:CanClick() then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UICityManage,{ anim = true, hideTop = true,isBlur = true },self.param)
    end
end

--倒計時

local function RefreshTime(self)
    local now = UITimeManager:GetInstance():GetServerTime()
    if self.param.endTime ~= nil then
        local leftTime = self.param.endTime - now
        if self.param.lastTime ~= leftTime and self.slider_txt ~= nil then
            self.param.lastTime = leftTime
            if leftTime <= 0 then
                self.slider_txt:SetText( UITimeManager:GetInstance():MilliSecondToFmtString(0))
                self.slider:SetValue(1)
                 --移除状态
                LuaEntry.Effect:RemoveStatus(self.param.intKey)
                self.sliderParent.gameObject:SetActive(false)
            else
                self.slider_txt:SetText( UITimeManager:GetInstance():MilliSecondToFmtString(leftTime))
                local percent = 1 - leftTime/math.max(1,self.param.totalTime)
                self.slider:SetValue(percent)
            end
        end
    end
end
local function AddTimer(self)
    if self.timer == nil then
        self.timer = TimerManager:GetInstance():GetTimer(1, self.timer_action , self, false,false,false)
    end

    self.timer:Start()
end

local function DeleteTimer(self)
    if self.timer ~= nil then
        self.timer:Stop()
        self.timer = nil
    end
end

local function SetDesc(self)
    if self.param.id == CityManageBuffType.DirectAttackCity then
        local desc = Localization:GetString(self.param.des)
        local indexes, names = {}, {}
        local dataList = DataCenter.FormStatusManager:GetDataList()
        for _, data in ipairs(dataList) do
            local template = DataCenter.FormStatusManager:GetTemplate(data.id)
            if template and template.type2 == FormStatusType2.DirectAttackCity then
                table.insert(indexes, data:GetFormationIndex())
            end
        end
        table.sort(indexes)
        for _, index in ipairs(indexes) do
            local formName = FormationName[index]
            if formName then
                table.insert(names, Localization:GetString(formName))
            end
        end
        if #names > 0 then
            desc = desc .. "\n\n" .. Localization:GetString("180223") .. string.join(names, ", ")
        end
        self.des_txt:SetText(desc)
    else
        self.des_txt:SetLocalText(self.param.des)
    end
end

UICityManageCellItemCell.OnCreate = OnCreate
UICityManageCellItemCell.OnDestroy = OnDestroy
UICityManageCellItemCell.OnEnable = OnEnable
UICityManageCellItemCell.OnDisable = OnDisable
UICityManageCellItemCell.ComponentDefine = ComponentDefine
UICityManageCellItemCell.ComponentDestroy = ComponentDestroy
UICityManageCellItemCell.DataDefine = DataDefine
UICityManageCellItemCell.DataDestroy = DataDestroy
UICityManageCellItemCell.OnAddListener = OnAddListener
UICityManageCellItemCell.OnRemoveListener = OnRemoveListener
UICityManageCellItemCell.ReInit = ReInit
UICityManageCellItemCell.CanClick=CanClick
UICityManageCellItemCell.OnItemClick=OnItemClick
UICityManageCellItemCell.RefreshTime= RefreshTime
UICityManageCellItemCell.AddTimer= AddTimer
UICityManageCellItemCell.DeleteTimer= DeleteTimer
UICityManageCellItemCell.SetDesc= SetDesc

return UICityManageCellItemCell