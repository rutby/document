--- Created by shimin.
--- DateTime: 2020/8/17 15:18
--- 医院界面

local UIHospitalView = BaseClass("UIHospitalView", UIBaseView)
local base = UIBaseView

local UINeedResCell = require "UI.UIHospital.Component.UINeedResCell"
local UISoldierCell = require "UI.UIHospital.Component.UISoldierCell"
local UIRepairPanelTitleCell = require "UI.UIHospital.Component.UIRepairPanelTitleCell"
local UIHeroTipView = require "UI.UIHero2.UIHeroTip.View.UIHeroTipView"

local Localization = CS.GameEntry.Localization
local Sound = CS.GameEntry.Sound

local repair_Bg_path = "AnimGo/repairBg"
--local panel_path = "AnimGo/panel"
local close_btn_path = "UICommonFullTop/CloseBtn"
local title_text_path = "UICommonFullTop/imgTitle/Common_img_title/titleText"
local animator_path = "AnimGo"
local details_btn_path = "AnimGo/RightGo/RightScrollView/InfoBtn"
local repair_obj_path = "AnimGo/repair"
local max_range_text_path = "AnimGo/repair/MaxSoldierValue"
local max_range_name_path = "AnimGo/repair/MaxSoldierText"
local no_soldier_bg_path = "AnimGo/RightGo/NoSoldierBg"
local no_have_soldier_text_path = "AnimGo/RightGo/NoSoldierBg/NoSoldierText"
local scroll_view_path = "AnimGo/RightGo/RightScrollView"
local scroll_view_content_path = "AnimGo/RightGo/RightScrollView/Viewport/Content"
local cellTitle_text_path = "AnimGo/RightGo/RightScrollView/cellTitleBg/cellTitle"
local treating_slider_path = "AnimGo/RightGo/bottomBg/Common_bg_resource/TreatingSlider"
local treating_left_time_path = "AnimGo/RightGo/bottomBg/Common_bg_resource/TreatingSlider/slider_txt_long_new"
local immediately_btn_path = "AnimGo/RightGo/bottomBg/Common_btn_yellow_big"
local immediately_btn_name_path = "AnimGo/RightGo/bottomBg/Common_btn_yellow_big/GameObject/btnText"
local immediately_btn_count_path = "AnimGo/RightGo/bottomBg/Common_btn_yellow_big/GameObject/iconText"
local immediately_btn_icon_path = "AnimGo/RightGo/bottomBg/Common_btn_yellow_big/GameObject/icon_go/icon"
local treat_btn_path = "AnimGo/RightGo/bottomBg/Common_btn_green_big"
local treat_btn_name_path = "AnimGo/RightGo/bottomBg/Common_btn_green_big/btnTxt_green_mid_new/treat_name_text"
local treat_btn_count_path = "AnimGo/RightGo/bottomBg/Common_btn_green_big/btnTxt_green_mid_new/treat_time_text"
local add_speed_btn_name_path = "AnimGo/RightGo/bottomBg/Common_btn_green_big/btnTxt_green_big_new"
local need_res_content_path = "AnimGo/RightGo/bottomBg/Common_bg_resource"
local bottomBg_path = "AnimGo/RightGo/bottomBg"
local des_text_path = "AnimGo/DetailGo/InfoScrollView/Viewport/Content/DesText"
local back_btn_path = "AnimGo/DetailGo/BackBtn"
local dead_record_btn_path = "AnimGo/DeadRecordBtn"
local dead_record_red_dot_path = "AnimGo/DeadRecordBtn/DeadRecordRedDot"
local dead_record_btn_name_path = "AnimGo/DeadRecordBtn/DeadRecordBtnText"
local dead_record_btn_value_path = "AnimGo/DeadRecordBtn/DeadRecordBtnValue"
local max_detail_btn_path = "AnimGo/repair/btn_detail"

local SliderLength = 420

local MaxColor = Color.New(0.9882353,9647059,0.9294118,1)

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self.ctrl:InitData(self:GetUserData())
    self:ComponentDefine()
    self:DataDefine()
    self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    --self.btn = self:AddComponent(UIButton, panel_path)
    self.close_btn = self:AddComponent(UIButton, close_btn_path)
    self.title_text = self:AddComponent(UITextMeshProUGUIEx, title_text_path)
    self.cellTitle_text = self:AddComponent(UITextMeshProUGUIEx, cellTitle_text_path)
    self.animator = self:AddComponent(UIAnimator, animator_path)
    self.details_btn = self:AddComponent(UIButton, details_btn_path)
    self.max_range_text = self:AddComponent(UITextMeshProUGUIEx, max_range_text_path)
    self.scroll_view = self:AddComponent(UIBaseContainer, scroll_view_path)
    self.treating_slider = self:AddComponent(UISlider, treating_slider_path)
    self.treating_left_time = self:AddComponent(UITextMeshProUGUIEx, treating_left_time_path)
    self.need_res_content = self:AddComponent(UIBaseContainer, need_res_content_path)
    self.bottomBg = self:AddComponent(UIBaseContainer, bottomBg_path)
    self.immediately_btn = self:AddComponent(UIButton, immediately_btn_path)
    self.immediately_btn_name = self:AddComponent(UITextMeshProUGUIEx, immediately_btn_name_path)
    self.immediately_btn_count = self:AddComponent(UITextMeshProUGUIEx, immediately_btn_count_path)
    self.immediately_btn_icon = self:AddComponent(UIImage, immediately_btn_icon_path)
    self.repair_Bg = self:AddComponent(UIImage, repair_Bg_path)
    self.treat_btn = self:AddComponent(UIButton, treat_btn_path)
    self.treat_btn_name = self:AddComponent(UITextMeshProUGUIEx, treat_btn_name_path)
    self.treat_btn_count = self:AddComponent(UITextMeshProUGUIEx, treat_btn_count_path)
    self.no_have_soldier_text = self:AddComponent(UITextMeshProUGUIEx, no_have_soldier_text_path)
    self.des_text = self:AddComponent(UITextMeshProUGUIEx, des_text_path)
    self.back_btn = self:AddComponent(UIButton, back_btn_path)
    self.scroll_view_content = self:AddComponent(UIBaseContainer, scroll_view_content_path)
    self.no_soldier_bg = self:AddComponent(UIBaseContainer, no_soldier_bg_path)
    self.add_speed_btn_name = self:AddComponent(UITextMeshProUGUIEx, add_speed_btn_name_path)
    self.max_range_name = self:AddComponent(UITextMeshProUGUIEx, max_range_name_path)
    self.dead_record_btn = self:AddComponent(UIButton, dead_record_btn_path)
    self.dead_record_red_dot = self:AddComponent(UIBaseContainer, dead_record_red_dot_path)
    self.dead_record_btn_name = self:AddComponent(UITextMeshProUGUIEx, dead_record_btn_name_path)
    self.dead_record_btn_value = self:AddComponent(UITextMeshProUGUIEx, dead_record_btn_value_path)
    self.repair_obj = self:AddComponent(UIBaseContainer,repair_obj_path)
    if LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        self.repair_obj:SetActive(true)
    else
        self.repair_obj:SetActive(false)
    end
    self.dead_record_btn:SetOnClick(function()
        self:OnDeadRecordBtnClick()
    end)
    --self.btn:SetOnClick(function()  
    --    self.ctrl:CloseSelf()
    --end)

    self.close_btn:SetOnClick(function()  
        self.ctrl:CloseSelf()
    end)

    self.details_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:DetailsBtnClick()
    end)

    self.back_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:BackBtnClick()
    end)

    self.treat_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:GreenBtnClick()
    end)

    self.immediately_btn:SetOnClick(function()  
SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:YellowBtnClick()
    end)
    self.max_detail_btn = self:AddComponent(UIButton, max_detail_btn_path)
    self.max_detail_btn:SetOnClick(function()
        SoundUtil.PlayEffect(SoundAssets.Music_Effect_Button)
        self:OnMaxDetailBtnClick()
    end)
end

local function ComponentDestroy(self)
    self.btn = nil
    self.close_btn = nil
    self.title_text = nil
    self.cellTitle_text = nil
    self.animator = nil
    self.details_btn = nil
    self.max_range_text = nil
    self.scroll_view = nil
    self.treating_slider = nil
    self.treating_left_time = nil
    self.need_res_content = nil
    self.immediately_btn = nil
    self.immediately_btn_name = nil
    self.immediately_btn_count = nil
    self.immediately_btn_icon = nil
    self.treat_btn = nil
    self.treat_btn_name = nil
    self.treat_btn_count = nil
    self.no_have_soldier_text = nil
    self.des_text = nil
    self.back_btn = nil
    self.scroll_view_content = nil
    self.add_speed_btn_name = nil
    self.max_range_name = nil
end


local function DataDefine(self)
    self.queue = nil
    self.immediatelyBtnSpendText = nil
    self.immediatelyBtnSpendColor = nil
    self.treatNumText = nil
    self.laseTime = 0
    self.lastCurTime = 0
    self.treatingSliderValue = nil
    self.treatingLeftText = nil
    self.lackResource = {}
    self.needResourceCells = {}
    self.freeNeedResourceCells = {}
    self.needResource = {}
    self.hospitalSoldier = {}
    self.templates = {}
    self.soldierCells = {}
    self.stateType = nil
    self.selectSoldiers = {}
    self.allTime = 0
    self.spendGold = 0
    self.first = true
    self.treatingPerTime = {}
    self.treatingCellSlider = {} --每个正在治疗的Cell应该显示的slider值
    self.freeSoldierCells = {}
    self.titleCells = {}
    self.freeTitleCells = {}
    self.isLoading = {}
    self.showResourceTypeParam = {}
    self.curHospitalMaxSoldierWithoutOutRange = 0
end

local function DataDestroy(self)
    self.queue = nil
    self.immediatelyBtnSpendText = nil
    self.immediatelyBtnSpendColor = nil
    self.treatNumText = nil
    self.laseTime = nil
    self.lastCurTime = nil
    self.treatingSliderValue = nil
    self.treatingLeftText = nil
    self.lackResource = nil
    self.needResourceCells = nil
    self.freeNeedResourceCells = nil
    self.needResource = nil
    self.hospitalSoldier = nil
    self.templates = nil
    self.soldierCells = nil
    self.stateType = nil
    self.selectSoldiers = nil
    self.allTime = nil
    self.spendGold = nil
    self.first = nil
    self.treatingPerTime = nil
    self.treatingCellSlider = nil
    self.freeSoldierCells = nil
    self.titleCells = nil
    self.freeTitleCells = nil
    self.isLoading = nil
    self.showResourceTypeParam = nil
    self.curHospitalMaxSoldierWithoutOutRange = 0
end

local function OnEnable(self)
    base.OnEnable(self)
end

local function OnDisable(self)
    base.OnDisable(self)
end

local function OnAddListener(self)
    base.OnAddListener(self)
    self:AddUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:AddUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:AddUIListener(EventId.HospitaiStart, self.UpdatePanelSignal)
    self:AddUIListener(EventId.HospitalFinish, self.UpdatePanelSignal)
    self:AddUIListener(EventId.HospitalUpdate, self.UpdatePanelSignal)
    self:AddUIListener(EventId.AddSpeedSuccess, self.UpdatePanelSignal)
    self:AddUIListener(EventId.RefreshDeadArmyRecord, self.RefreshDeadArmyRecordSignal)
    self:AddUIListener(EventId.RefreshDeadArmyRecordRedDot, self.RefreshDeadArmyRecordRedDotSignal)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.UpdateGold, self.UpdateGoldSignal)
    self:RemoveUIListener(EventId.ResourceUpdated, self.UpdateResourceSignal)
    self:RemoveUIListener(EventId.HospitaiStart, self.UpdatePanelSignal)
    self:RemoveUIListener(EventId.HospitalFinish, self.UpdatePanelSignal)
    self:RemoveUIListener(EventId.HospitalUpdate, self.UpdatePanelSignal)
    self:RemoveUIListener(EventId.AddSpeedSuccess, self.UpdatePanelSignal)
    self:RemoveUIListener(EventId.RefreshDeadArmyRecord, self.RefreshDeadArmyRecordSignal)
    self:RemoveUIListener(EventId.RefreshDeadArmyRecordRedDot, self.RefreshDeadArmyRecordRedDotSignal)
end

local function ReInit(self)
    self.isArrow = self:GetUserData()
    self.title_text:SetLocalText(GameDialogDefine.BUILD_REPAIR) 
    self.immediately_btn_icon:LoadSprite(DataCenter.ResourceManager:GetResourceIconByType(ResourceType.Gold))
    self.des_text:SetLocalText(GameDialogDefine.TREAT_DES) 
    self.treat_btn_name:SetLocalText(GameDialogDefine.TREAT) 
    self.add_speed_btn_name:SetLocalText(GameDialogDefine.ADD_SPEED)
    self.dead_record_btn_name:SetLocalText(GameDialogDefine.RECENT_DEAD)
    self.dead_record_btn_value:SetLocalText(GameDialogDefine.CLICK_LOOK)
    self:ShowPanel()
    DataCenter.DeadArmyRecordManager:SendGetDeadArmyRecord()
end


local function ShowPanel(self)
    self.queue = self.ctrl:GetHospitalQueue()
    self.curHospitalMaxSoldier = DataCenter.HospitalManager:GetHospitalMaxCount()
    self.curHospitalSoldier = DataCenter.HospitalManager:GetHospitalCount()
    local curDeadSoldier = DataCenter.HospitalManager:GetTotalDeadCount()
    self.curHospitalMaxSoldierWithoutOutRange = DataCenter.HospitalManager:GetHospitalMaxCountWithoutAdd()
    if self.curHospitalSoldier > 0 then
        self.repair_Bg:LoadSprite("Assets/Main/Sprites/UI/UIRepair/Hospital_pic_01.png")

        self.bottomBg:SetActive(true)
        self.no_soldier_bg:SetActive(false)
        self.scroll_view:SetActive(true)
        -- self.need_res_content:SetActive(true)
        -- self.immediately_btn:SetActive(true)
        -- self.treat_btn:SetActive(true)
        self:ShowRightPanel()
    else
        self.repair_Bg:LoadSprite("Assets/Main/Sprites/UI/UIRepair/Hospital_pic_00.png")
        self.stateType = HospitalPanelStateType.NoSoldier 
        self.no_soldier_bg:SetActive(true)
        self.bottomBg:SetActive(false)
        self.scroll_view:SetActive(false)
        -- self.need_res_content:SetActive(false)
        -- self.immediately_btn:SetActive(false)
        -- self.treat_btn:SetActive(false)
        self.no_have_soldier_text:SetLocalText(GameDialogDefine.NO_NEED_TREAT_DES) 
    end
    self.max_range_text:SetText(string.GetFormattedSeperatorNum(curDeadSoldier).."/"..string.GetFormattedSeperatorNum(self.curHospitalMaxSoldier))
    self.max_range_name:SetLocalText(GameDialogDefine.SERIOUSLY_HURT_SOLIDER)
    self:RefreshHospitalMax()
    if self.isArrow and curDeadSoldier > 0 then
        local param = {}
        param.position = self.treat_btn.transform.position
        param.arrowType = ArrowType.Capacity
        param.positionType = PositionType.Screen
        DataCenter.ArrowManager:ShowArrow(param)
        self.isArrow = nil
    end
    self:RefreshDeadPanel()
end

local function ShowRightPanel(self)
    if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
        self.immediately_btn_name:SetLocalText(GameDialogDefine.IMMEDIATELY_ADD_SPEED) 
        self.treat_btn_name:SetActive(false)
        self.treat_btn_count:SetActive(false)
        self.add_speed_btn_name:SetActive(true)
        self.treating_slider:SetActive(true)
        self.hospitalSoldier = DataCenter.HospitalManager:GetTreatingHospital()
        self.stateType = HospitalPanelStateType.Treating
        for k,v in pairs(self.needResourceCells) do
            v:SetActive(false)
            table.insert(self.freeNeedResourceCells,v)
        end
        self.needResourceCells = {}
    else
        self.immediately_btn_name:SetLocalText(GameDialogDefine.IMMEDIATELY_TREAT) 
        if self:CheckGuide() then
            self.need_res_content:SetActive(false)
            self.add_speed_btn_name:SetLocalText(GameDialogDefine.FREE)
            self.add_speed_btn_name:SetActive(true)
            self.treat_btn_name:SetActive(false)
            self.treat_btn_count:SetActive(false)
        else
            self.add_speed_btn_name:SetActive(false)
            self.treat_btn_name:SetActive(true)
            self.treat_btn_count:SetActive(true)
        end
        self.treating_slider:SetActive(false)
        self.hospitalSoldier = DataCenter.HospitalManager:GetDeadHospital()
        self.stateType = HospitalPanelStateType.Select
    end
    self:GetAllTemplate()
    if self.first then
        self:PreShowCount()
        self.first = false
    end
    if self.stateType == HospitalPanelStateType.Select then
        self:RefreshSelectCount()
    elseif self.stateType == HospitalPanelStateType.Treating then
        self.laseTime = 0
        self:GetTreatingPerSoldierTime()
        local curTime = UITimeManager:GetInstance():GetServerTime()
        local changeTime = self.queue.endTime - curTime
        local maxTime = self.queue.endTime - self.queue.startTime
        self:UpdateTreatingCellSliderValue(1 - changeTime / maxTime)
    end
    self.cellTitle_text:SetText(Localization:GetString(GameDialogDefine.SERIOUSLY_HURT_SOLIDER))

    self:ShowCells()
end

local function ShowCells(self)
    for k,v in pairs(self.soldierCells) do
        v:SetActive(false)
        table.insert(self.freeSoldierCells,v)
    end
    self.soldierCells = {}
    for k,v in pairs(self.titleCells) do
        v:SetActive(false)
        table.insert(self.freeTitleCells,v)
    end
    self.titleCells = {}
    
    --if table.count(self.hospitalSoldier) > 0 then
    --    local param = UIRepairPanelTitleCell.Param.New()
    --    param.des = Localization:GetString(GameDialogDefine.SERIOUSLY_HURT_SOLIDER)
    --    self:AddOneTitleCells(param)
    --end
    
    for k,v in ipairs(self.hospitalSoldier) do
        local param = UISoldierCell.Param.New()
        if self.stateType == HospitalPanelStateType.Treating then
            param.allCount = v.heal
            param.count = self.treatingCellSlider[k] or 0
        elseif self.stateType == HospitalPanelStateType.Select then
            param.allCount = v.dead
            param.count = self.selectSoldiers[k] or 0
        end
        param.template = self.templates[k]
        param.callBack = function(index,count) self:CellsCallBack(index,count) end
        param.index = k
        param.stateType = self.stateType
        self:AddOneSoldierCells(param)
    end
end


local function AddOneSoldierCells(self,param)
    if #self.freeSoldierCells > 0 then
        local temp = table.remove(self.freeSoldierCells)
        if temp ~= nil then
            temp:SetActive(true)
            temp:ReInit(param)
            temp.transform:SetAsLastSibling()
            self.soldierCells[param.index] = temp
        end
    else
        self:GameObjectInstantiateAsync(UIAssets.UIRepairPanelCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.scroll_view_content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            self.soldierCells[param.index] = self.scroll_view_content:AddComponent(UISoldierCell, nameStr)
            self.soldierCells[param.index]:ReInit(param)
        end)
    end
end


local function AddOneTitleCells(self,param)
    if #self.freeTitleCells > 0 then
        local temp = table.remove(self.freeTitleCells)
        if temp ~= nil then
            temp:SetActive(true)
            temp:ReInit(param)
            temp.transform:SetAsLastSibling()
            self.titleCells[param.des] = temp
        end
    else
        self:GameObjectInstantiateAsync(UIAssets.UIRepairPanelTitleCell, function(request)
            if request.isError then
                return
            end
            local go = request.gameObject
            go:SetActive(true)
            go.transform:SetParent(self.scroll_view_content.transform)
            go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
            go.transform:SetAsLastSibling()
            local nameStr = tostring(NameCount)
            go.name = nameStr
            NameCount = NameCount + 1
            self.titleCells[param.des] = self.scroll_view_content:AddComponent(UIRepairPanelTitleCell, nameStr)
            self.titleCells[param.des]:ReInit(param)
        end)
    end
end

local function CellsCallBack(self,index,count) 
    self.selectSoldiers[index] = count
    self:RefreshSelectCount()
end

local function RefreshSelectCount(self)
    self:ShowNeedResource()
    self:RefreshTreatTime()
    self:RefreshImmediatelyGold()
end

local function RefreshTreatTime(self)
    self.allTime = 0
    for k,v in ipairs(self.selectSoldiers) do
        if v > 0 then
            local temp = self.templates[k]
            if temp ~= nil then
                self.allTime = self.allTime + temp:GetTreatTime() * v
            end
        end
    end
    self.allTime = math.ceil(self.allTime)
    self:SetTreatNumText(UITimeManager:GetInstance():SecondToFmtString(self.allTime))
end

local function RefreshImmediatelyGold(self)
    self.spendGold = CommonUtil.GetTimeDiamondCost(self.allTime)
    if table.count(self.lackResource) > 0 then
        for k,v in pairs(self.lackResource) do
            self.spendGold = self.spendGold + CommonUtil.GetResGoldByType(k,v)
        end
    end
    if self:CheckGuide() then
        self.spendGold = 0
    end
    self:SetImmediatelyBtnSpendText(string.GetFormattedSeperatorNum(self.spendGold))
    local gold = LuaEntry.Player.gold
    if gold < self.spendGold then
        self:SetImmediatelyBtnSpendColor(ButtonRedTextColor)
    else
        self:SetImmediatelyBtnSpendColor(WhiteColor)
    end
end

local function GetNeedResourceAndNeedItem(self) 
    self.needResource = {}
    for k,v in ipairs(self.selectSoldiers) do
        if v > 0 then
            local temp = self.templates[k]
            if temp ~= nil then
                local tempRes = temp:GetTreatResource()
                for k1,v1 in ipairs(tempRes) do
                    if self.needResource[v1.resourceType] == nil then
                        self.needResource[v1.resourceType] = v1.count * v
                    else
                        self.needResource[v1.resourceType] = self.needResource[v1.resourceType] + v1.count * v
                    end
                end
            end
        end
    end
    local num1 = LuaEntry.Effect:GetGameEffect(EffectDefine.CURE_RESOURCE_REDUCE)
    local num2 = LuaEntry.Effect:GetGameEffect(EffectDefine.HEAL_MONEY_DEC)
    local percent = (1 - (num1 / 100)) * (1 - (num2 / 100))
    if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
        local num3 = LuaEntry.Effect:GetGameEffect(EffectDefine.GAME_EFFECT_30318)
        percent = (1 - (num3 / 100))
    end
    for k,v in pairs(self.needResource) do
		self.needResource[k] = v*percent
    end
end

local function SetImmediatelyBtnSpendText(self,value)
    if self.immediatelyBtnSpendText ~= value then
        self.immediatelyBtnSpendText = value
        self.immediately_btn_count:SetText(value)
    end
end
local function SetImmediatelyBtnSpendColor(self,value)
    if self.immediatelyBtnSpendColor ~= value then
        self.immediatelyBtnSpendColor = value
        self.immediately_btn_count:SetColor(value)
    end
end

local function SetTreatNumText(self,value)
    if self.treatNumText ~= value then
        self.treatNumText = value
        self.treat_btn_count:SetText(value)
    end
end

local function DetailsBtnClick(self)
    self.animator:Play("OnClickInfo",0,0)
end

local function BackBtnClick(self)
    self.animator:Play("OnClickBack",0,0)
end

local function Update(self)
    if self.queue ~= nil then
        if self.queue:GetQueueState() == NewQueueState.Work then
            self:UpdateLeftTime()
        elseif self.queue:GetQueueState() == NewQueueState.Finish then
            self.ctrl:CloseSelf()
        end
    end
end

local function UpdateLeftTime(self)
    local curTime = UITimeManager:GetInstance():GetServerTime()
    local changeTime = self.queue.endTime - curTime
    local maxTime = self.queue.endTime - self.queue.startTime
    if changeTime > 0 then
        local tempTimeSec = math.ceil(changeTime / 1000)
        if tempTimeSec ~= self.laseTime then
            self.laseTime = tempTimeSec
            local tempTimeValue = UITimeManager:GetInstance():MilliSecondToFmtString(changeTime)
            self:SetTreatingLeftText(tempTimeValue)
            --刷新钻石
            local spendGold = CommonUtil.GetTimeDiamondCost(math.ceil(tempTimeSec))
            self:SetImmediatelyBtnSpendText(string.GetFormattedSeperatorNum(spendGold))
            local gold = LuaEntry.Player.gold
            if gold < spendGold then
                self:SetImmediatelyBtnSpendColor(ButtonRedTextColor)
            else
                self:SetImmediatelyBtnSpendColor(WhiteColor)
            end

            self:UpdateTreatingCellSliderValue(1 - changeTime / maxTime)
            self:UpdateTreatingCellSlider()
        end

        if maxTime > 0 then
            local tempValue = 1 - changeTime / maxTime
            if TimeBarUtil.CheckIsNeedChangeBar(changeTime,self.queue.endTime - self.lastCurTime,maxTime,SliderLength) then
                self.lastCurTime = curTime
                self:SetTreatingSliderValue(tempValue)
            end
        end
    else
        self.laseTime = 0
        self:SetTreatingSliderValue(0)
        self:SetTreatingLeftText("")
    end
end

local function SetTreatingSliderValue(self,value)
    if self.treatingSliderValue ~= value then
        self.treatingSliderValue = value
        self.treating_slider:SetValue(value)
    end
end

local function SetTreatingLeftText(self,value)
    if self.treatingLeftText ~= value then
        self.treatingLeftText = value
        self.treating_left_time:SetText(value)
    end
end

local function ShowNeedResource(self)
    self:GetNeedResourceAndNeedItem()
    self.lackResource = {}
    for k,v in pairs(self.needResourceCells) do
        v:SetActive(false)
        table.insert(self.freeNeedResourceCells,v)
    end
    self.needResourceCells = {}

    local resources = self.needResource
    if resources ~= nil then
        for k1,v1 in pairs(resources) do
            v1 = math.ceil(v1)
            if v1 > 0 then
                local param = {}
                param.resourceType = k1
                param.count = v1
                param.own = LuaEntry.Resource:GetCntByResType(k1)
                if param.own < v1 then
                    self.lackResource[k1] = v1
                    param.isRed = true
                else
                    param.isRed = false
                end
                self:AddOneNeedResourceCells(param)
            end
        end
    end
    if self:CheckGuide() then
        self.lackResource = {}
    end
end

local function AddOneNeedResourceCells(self,param)
    if #self.freeNeedResourceCells > 0 then
        local temp = table.remove(self.freeNeedResourceCells)
        if temp ~= nil then
            temp:SetActive(true)
            temp:ReInit(param)
            temp.transform:SetAsLastSibling()
            self.needResourceCells[param.resourceType] = temp
        end
    else
        if self.isLoading[param.resourceType] == nil then
            self.isLoading[param.resourceType] = true
            self:GameObjectInstantiateAsync(UIAssets.UIRepairNeedResCell, function(request)
                self.isLoading[param.resourceType] = nil
                if request.isError then
                    return
                end
                local go = request.gameObject
                go:SetActive(true)
                go.transform:SetParent(self.need_res_content.transform)
                go.transform:Set_localScale(ResetScale.x, ResetScale.y, ResetScale.z)
                go.transform:SetAsLastSibling()
                local nameStr = tostring(NameCount)
                go.name = nameStr
                NameCount = NameCount + 1
                self.needResourceCells[param.resourceType] = self.need_res_content:AddComponent(UINeedResCell, nameStr)
                self.needResourceCells[param.resourceType]:ReInit(param)
            end)
        end
    end
end

local function GetAllTemplate(self)
    for k,v in ipairs(self.hospitalSoldier) do
        self.templates[k] = DataCenter.ArmyTemplateManager:GetArmyTemplate(v.armyId)
    end
end

local function PreShowCount(self)
    self.selectSoldiers = {}
    local ownResource = {}
    local inGuide = self:CheckGuide()
    local num1 = LuaEntry.Effect:GetGameEffect(EffectDefine.CURE_RESOURCE_REDUCE)
    local num2 = LuaEntry.Effect:GetGameEffect(EffectDefine.HEAL_MONEY_DEC)
    local percent = (1 - (num1 / 100)) * (1 - (num2 / 100))
    for k,v in ipairs(self.hospitalSoldier) do
        local temp = self.templates[k]
        if temp ~= nil then
            local maxNum = v.dead
            local tempRes = temp:GetTreatResource()
            if not inGuide then
                for k1,v1 in ipairs(tempRes) do
                    local cost = math.ceil(v1.count*percent)
                    if ownResource[v1.resourceType] == nil then
                        ownResource[v1.resourceType] = LuaEntry.Resource:GetCntByResType(v1.resourceType)
                    end
                    local tempMax = math.floor(ownResource[v1.resourceType] /cost)
                    if maxNum > tempMax then
                        maxNum = tempMax
                    end
                end
            end
            
            self.selectSoldiers[k] = maxNum
            if maxNum > 0 and not inGuide then
                for k2,v2 in ipairs(tempRes) do
                    local cost = math.ceil(v2.count*percent)
                    ownResource[v2.resourceType] = ownResource[v2.resourceType] - (cost * maxNum)
                end
            end
        end
    end
end

local function GreenBtnClick(self)
    --建筑生在升级不能
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_HOSPITAL)
    if buildData ~= nil and buildData:IsUpgrading() then
        UIUtil.ShowTips(Localization:GetString(GameDialogDefine.THIS_UPGRADING,
                Localization:GetString(GetTableData(DataCenter.BuildTemplateManager:GetTableName(),
                        buildData.itemId + buildData.level,"name"))))
    else
        if self.stateType == HospitalPanelStateType.Select then
            self:TreatBtnClick()
        elseif self.stateType == HospitalPanelStateType.Treating then
            self:SpeedBtnClick()
        end
    end
end

local function YellowBtnClick(self)
    if self.stateType == HospitalPanelStateType.Select then
        self:ImmediatelyBtnClick()
    elseif self.stateType == HospitalPanelStateType.Treating then
        self:ImmediatelySpeedBtnClick()
    end
end

local function TreatBtnClick(self)
    if self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
        UIUtil.ShowTipsId(GameDialogDefine.QUEUE_FULL) 
    elseif self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Free then
        if self.lackResource ~= nil and table.count(self.lackResource) > 0 then
            local lackTab = {}
            for k ,v in pairs(self.lackResource) do
                local param = {}
                param.type = ResLackType.Res
                param.id = k
                param.targetNum = v
                table.insert(lackTab,param)
            end
            GoToResLack.GoToItemResLackList(lackTab)
        else
            local tempArr = {}
            for k,v in ipairs(self.selectSoldiers) do
                if v > 0 then
                    tempArr[self.hospitalSoldier[k].armyId] = v
                end
            end
            if table.count(tempArr) > 0 then
                local hType = MarchArmsType.Free
                if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
                    hType = MarchArmsType.CROSS_DRAGON
                end
                SFSNetwork.SendMessage(MsgDefines.HospitalCure, { gold = IsGold.NoUseGold,arr = tempArr,hospitalType = hType})
                self.ctrl:CloseSelf()
            else
                UIUtil.ShowTipsId(GameDialogDefine.UNSELECT_HOSPITAL_NO_REPAIRE)
            end
        end
    end
end

local function ImmediatelyBtnClick(self)
    if self.immediatelyBtnSpendColor == RedColor then
        GoToUtil.GotoPayTips()
    else
        local tempArr = {}
        for k,v in ipairs(self.selectSoldiers) do
            if v > 0 then
                tempArr[self.hospitalSoldier[k].armyId] = v
            end
        end
        if table.count(tempArr) > 0 then
            local hType = MarchArmsType.Free
            if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
                hType = MarchArmsType.CROSS_DRAGON
            end
            UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond,Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
                SFSNetwork.SendMessage(MsgDefines.HospitalCure, { gold = IsGold.UseGold,arr = tempArr,hospitalType = hType})
            end, function()
            end)
        else
            UIUtil.ShowTipsId(GameDialogDefine.UNSELECT_HOSPITAL_NO_REPAIRE) 
        end
    end
end

local function ImmediatelySpeedBtnClick(self)
    if self.immediatelyBtnSpendColor == RedColor then
        GoToUtil.GotoPayTips()
    elseif self.queue ~= nil and self.queue:GetQueueState() == NewQueueState.Work then
        local hType = MarchArmsType.Free
        if LuaEntry.Player.serverType == ServerType.DRAGON_BATTLE_FIGHT_SERVER then
            hType = MarchArmsType.CROSS_DRAGON
        end
        UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.UpgradeUseDiamond,Localization:GetString(GameDialogDefine.USE_GOLF_TIP_DES), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL,function()
            SFSNetwork.SendMessage(MsgDefines.QueueCcdMNew, { qUUID = self.queue.uuid,itemIDs = "",isGold = IsGold.UseGold },nil,hType)
        end, function()
        end)
    end
end

local function SpeedBtnClick(self)
    local buildData = DataCenter.BuildManager:GetFunbuildByItemID(BuildingTypes.FUN_BUILD_HOSPITAL)
    if buildData ~= nil then
        UIManager:GetInstance():OpenWindow(UIWindowNames.UISpeed,{anim = true,isBlur = true}, ItemSpdMenu.ItemSpdMenu_Heal, self.queue.uuid)
    end
end

local function UpdateResourceSignal(self)
    if self.stateType == HospitalPanelStateType.Select then
        self:ShowNeedResource()
    end
end

local function UpdateGoldSignal(self)
    if self.stateType == HospitalPanelStateType.Select or self.stateType == HospitalPanelStateType.Treating then
        self:RefreshImmediatelyGold()
    end
end
local function UpdatePanelSignal(self)
    table.walk(self.selectSoldiers, function (k, v)
        self.selectSoldiers[k] = 0
    end)
    self:ShowPanel()
end

local function GetTreatingPerSoldierTime(self)
    self.allTime = 0
    self.treatingPerTime = {}
    for k,v in ipairs(self.hospitalSoldier) do
        if v.heal > 0 then
            local temp = self.templates[k]
            if temp ~= nil then
                local perTime = temp:GetTreatTime() * v.heal
                self.treatingPerTime[k] = perTime
                self.allTime = self.allTime + perTime
            end
        end
    end
    self.allTime = math.ceil(self.allTime)
end
local function UpdateTreatingCellSliderValue(self,value)
    self.treatingCellSlider = {}
    local leftTime = self.allTime * value
    --计算每一个cell显示值
    for k,v in ipairs(self.treatingPerTime) do
        if leftTime <= 0 then
            self.treatingCellSlider[k] = 0
        else
            if leftTime > v then
                self.treatingCellSlider[k] = 1
            else
                self.treatingCellSlider[k] = leftTime / v
                
            end
            leftTime = leftTime - v
        end
    end
end

local function UpdateTreatingCellSlider(self)
    for k,v in ipairs(self.treatingCellSlider) do
        local temp = self.soldierCells[k]
        if temp ~= nil then
            temp:UpdateSlider(v)
        end
    end
end

local function CheckGuide(self)
    return DataCenter.GuideManager:InGuide()
end

--刷新士兵死亡记录
function UIHospitalView:RefreshDeadArmyRecordSignal()
    self:RefreshDeadPanel()
end

--刷新士兵死亡记录红点
function UIHospitalView:RefreshDeadArmyRecordRedDotSignal()
    self:RefreshDeadRedDot()
end

function UIHospitalView:RefreshDeadPanel()
    self.dead_record_btn:SetActive(false)
    --if DataCenter.DeadArmyRecordManager:HasDeadArmyRecord() and LuaEntry.Player.serverType ~= ServerType.DRAGON_BATTLE_FIGHT_SERVER then
    --    self.dead_record_btn:SetActive(true)
    --    self:RefreshDeadRedDot()
    --else
    --    self.dead_record_btn:SetActive(false)
    --end
end

function UIHospitalView:RefreshDeadRedDot()
    self.dead_record_red_dot:SetActive(DataCenter.DeadArmyRecordManager:IsShowRedDot())
end

function UIHospitalView:OnDeadRecordBtnClick()
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIDeadArmyRecord)
end

function UIHospitalView:OnMaxDetailBtnClick()
    local scaleFactor = UIManager:GetInstance():GetScaleFactor()
    local position = self.max_detail_btn.transform.position --+ Vector3.New(0, 15, 0) * scaleFactor
    local param = {}
    param.content = Localization:GetString("111226").."\n"..Localization:GetString("111227")..": "..string.GetFormattedPercentStr((LuaEntry.Effect:GetGameEffect(EffectDefine.HOS_MAX_ADD)/100)).."\n".."\n"..Localization:GetString("140251")
    param.dir = UIHeroTipView.Direction.BELOW
    param.defWidth = 300
    param.pivot = 0.9
    param.position = position
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIHeroTip, { anim = false }, param)
end

--刷新医院最大上限显示
function UIHospitalView:RefreshHospitalMax()
    if self.curHospitalMaxSoldier > self.curHospitalMaxSoldierWithoutOutRange then
        self.max_range_text:SetColor(LightGreenColor)
        self.max_detail_btn:SetActive(true)
    else
        self.max_range_text:SetColor(MaxColor)
        self.max_detail_btn:SetActive(false)
    end
end

UIHospitalView.OnCreate = OnCreate
UIHospitalView.OnDestroy = OnDestroy
UIHospitalView.OnEnable = OnEnable
UIHospitalView.OnDisable = OnDisable
UIHospitalView.ComponentDefine = ComponentDefine
UIHospitalView.ComponentDestroy = ComponentDestroy
UIHospitalView.DataDefine = DataDefine
UIHospitalView.DataDestroy = DataDestroy
UIHospitalView.OnAddListener = OnAddListener
UIHospitalView.OnRemoveListener = OnRemoveListener
UIHospitalView.ReInit = ReInit
UIHospitalView.SetImmediatelyBtnSpendText = SetImmediatelyBtnSpendText
UIHospitalView.SetImmediatelyBtnSpendColor = SetImmediatelyBtnSpendColor
UIHospitalView.SetTreatNumText = SetTreatNumText
UIHospitalView.ShowPanel = ShowPanel
UIHospitalView.DetailsBtnClick = DetailsBtnClick
UIHospitalView.BackBtnClick = BackBtnClick
UIHospitalView.ShowRightPanel = ShowRightPanel
UIHospitalView.Update = Update
UIHospitalView.UpdateLeftTime = UpdateLeftTime
UIHospitalView.SetTreatingLeftText = SetTreatingLeftText
UIHospitalView.SetTreatingSliderValue = SetTreatingSliderValue
UIHospitalView.ShowNeedResource = ShowNeedResource
UIHospitalView.AddOneNeedResourceCells = AddOneNeedResourceCells
UIHospitalView.ShowCells = ShowCells
UIHospitalView.AddOneSoldierCells = AddOneSoldierCells
UIHospitalView.CellsCallBack = CellsCallBack
UIHospitalView.RefreshSelectCount = RefreshSelectCount
UIHospitalView.RefreshTreatTime = RefreshTreatTime
UIHospitalView.RefreshImmediatelyGold = RefreshImmediatelyGold
UIHospitalView.GetNeedResourceAndNeedItem = GetNeedResourceAndNeedItem
UIHospitalView.GetAllTemplate = GetAllTemplate
UIHospitalView.PreShowCount = PreShowCount
UIHospitalView.TreatBtnClick = TreatBtnClick
UIHospitalView.ImmediatelyBtnClick = ImmediatelyBtnClick
UIHospitalView.ImmediatelySpeedBtnClick = ImmediatelySpeedBtnClick
UIHospitalView.SpeedBtnClick = SpeedBtnClick
UIHospitalView.UpdateResourceSignal = UpdateResourceSignal
UIHospitalView.UpdateGoldSignal = UpdateGoldSignal
UIHospitalView.UpdatePanelSignal = UpdatePanelSignal
UIHospitalView.GetTreatingPerSoldierTime = GetTreatingPerSoldierTime
UIHospitalView.UpdateTreatingCellSliderValue = UpdateTreatingCellSliderValue
UIHospitalView.UpdateTreatingCellSlider = UpdateTreatingCellSlider
UIHospitalView.GreenBtnClick = GreenBtnClick
UIHospitalView.YellowBtnClick = YellowBtnClick
UIHospitalView.CheckGuide = CheckGuide
UIHospitalView.AddOneTitleCells = AddOneTitleCells

return UIHospitalView