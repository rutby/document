---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local WorldTrendWeekCell = BaseClass("WorldTrendWeekCell", UIBaseContainer)
local base = UIBaseContainer
local lockColor = Color32.New(152/255.0, 152/255.0, 152/255.0, 1)
local defaultColor = Color32.New(1,1,1,1)
-- 创建
function WorldTrendWeekCell:OnCreate()
    base.OnCreate(self)
    self._self_btn    = self:AddComponent(UIButton,"")
    self._self_btn:SetOnClick(function()
        self:OnClickWeek()
    end)
    self._select_rect   = self:AddComponent(UIBaseContainer,"Select")
    self._title_txt     = self:AddComponent(UIText,"Select/Txt_WeekTitle")
    self._icon_img      = self:AddComponent(UIImage,"Img_TitleIcon")
    self._selectBg_rect = self:AddComponent(UIBaseContainer,"Rect_SelectBg")
    self._complete_rect = self:AddComponent(UIBaseContainer,"Rect_Complete")
    self._lock_rect     = self:AddComponent(UIBaseContainer,"Rect_Lock")
    self._red_rect      = self:AddComponent(UIImage,"Rect_Red")
end

-- 销毁
function WorldTrendWeekCell:OnDestroy()
    base.OnDestroy(self)
end

-- 显示
function WorldTrendWeekCell:OnEnable()
    base.OnEnable(self)
end

-- 隐藏
function WorldTrendWeekCell:OnDisable()
    base.OnDisable(self)
end

-- 全部刷新
function WorldTrendWeekCell:ReInit(list,index,callBack)
    local data = list[1]
    local showType = data.show_type
    self.callBack = callBack
    self.index = index
    self.isLock = false
    local str = string.split(showType,";")
    self._title_txt:SetLocalText(str[2])
    self._icon_img:LoadSprite(string.format(LoadPath.UIGlory,str[3]))
    self._select_rect:SetActive(false)
    self:SetLock(data)
    self:CheckRed(list)
    self:CheckIsGray(list)
end

function WorldTrendWeekCell:SetSelect(state)
    self._selectBg_rect:SetActive(state)
    self._select_rect:SetActive(state)
    if state then
        self._self_btn:SetLocalScaleXYZ(1.1,1.1,1.1)
    else
        self._self_btn:SetLocalScaleXYZ(1,1,1)
    end
end

function WorldTrendWeekCell:SetLock(data)
    if data.status >= DataCenter.WorldTrendManager.ServerTrendsStatus.Ongoing then
        self._icon_img:SetColor(defaultColor)
        self._lock_rect:SetActive(false)
        self.isLock = false
    else
        self._icon_img:SetColor(lockColor)
        self._lock_rect:SetActive(true)
        self.isLock = true
    end
end

function WorldTrendWeekCell:CheckRed(list)
    local isShowRed = false
    for i = 1, #list do
        if list[i].rewardStatus == DataCenter.WorldTrendManager.ServerTrendsRewardStatus.Unreceived then
            if DataCenter.BuildManager.MainLv and list[i].levelLimit <= DataCenter.BuildManager.MainLv then
                isShowRed = true
            end
        end
    end
    self._red_rect:SetActive(isShowRed)
end

function WorldTrendWeekCell:CheckIsGray(list)
    local isGray = false
    for i = 1, #list do
        --找到最后一个检查时间
        if i == table.count(list) then
            local curTime = UITimeManager:GetInstance():GetServerTime()
            if curTime > list[i].endTime then
                isGray = true
            end
        end
    end
    if isGray then
        self._icon_img:SetColor(lockColor)
        self._complete_rect:SetActive(true)
    else
        if not self.isLock then
            self._icon_img:SetColor(defaultColor)
            self._complete_rect:SetActive(false)
        end
    end
end

function WorldTrendWeekCell:OnClickWeek(targetIndex)
    if self.callBack then
        self.callBack(self.index,targetIndex)
    end
end

return WorldTrendWeekCell