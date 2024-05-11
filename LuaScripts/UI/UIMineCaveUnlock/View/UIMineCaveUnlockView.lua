--- Created by shimin.
--- DateTime: 2020/8/17 15:18
--- UIMineCaveUnlockView.lua

local base = UIBaseView--Variable
local UIMineCaveUnlockView = BaseClass("UIMineCaveUnlockView", base)--Variable
local Localization = CS.GameEntry.Localization
local UICommonItem = require "UI.UICommonItem.UICommonItem"
local UIGray = CS.UIGray

local Pivot_Max = 0.9
local Pivot_Min = 0.1
local Pivot_Mid = 0.5
local arrow_path = "offset/imgArrow"
local offset_path = "offset"
local icon_path = "offset/cave/caveIcon"
local name_path = "offset/cave/caveName"
local resSpeed_path = "offset/res/resSpeedTxt/resSpeed"
local resTxtSpeed_path = "offset/res/resSpeedTxt"
local levelTxt_path = "offset/cave/caveLvTxt"
local resItem_path = "offset/res/resItem"
local bgBtn_path = "Panel"
local toUnlock_path = "offset/toUnlock"
local toUnlockTip_path = "offset/toUnlock/toUnlockTip"
local remain_path = "offset/remainLayout"
local remain_txt_path = "offset/remainLayout/remainTimes"
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
    self:DataDefine()
    self:RefreshAll()
end

local function OnDestroy(self)
    --self.offsetN.transform.position = Vector3.New(10000, 0, 0)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)
    self.offsetN = self:AddComponent(UIBaseContainer, offset_path)
    --self.offsetN.transform.position = Vector3.New(10000, 0, 0)
    self.arrowN = self:AddComponent(UIImage, arrow_path)
    self.iconN = self:AddComponent(UIImage, icon_path)
    self.nameN = self:AddComponent(UITextMeshProUGUIEx, name_path)
    self.levelTxtN = self:AddComponent(UITextMeshProUGUIEx, levelTxt_path)
    self.resItemN = self:AddComponent(UICommonItem, resItem_path)
    self.resSpeedN = self:AddComponent(UITextMeshProUGUIEx, resSpeed_path)
    self.resSpeedN:SetActive(false)
    self.resTxtSpeedN = self:AddComponent(UITextMeshProUGUIEx, resTxtSpeed_path)
    self.resTxtSpeedN:SetLocalText(302400)
    self.closeBtnN = self:AddComponent(UIButton, bgBtn_path)
    self.closeBtnN:SetOnClick(function()
        self.ctrl:CloseSelf()
    end)
    self.toUnlockN = self:AddComponent(UIBaseContainer, toUnlock_path)
    self.toUnlockTipN = self:AddComponent(UITextMeshProUGUIEx, toUnlockTip_path)
    self.remain =self:AddComponent(UIBaseContainer,remain_path)
    self.remain_txt = self:AddComponent(UITextMeshProUGUIEx,remain_txt_path)
end

local function ComponentDestroy(self)
    self.offsetN = nil
    self.arrowN = nil
    self.iconN = nil
    self.nameN = nil
    self.levelTxtN = nil
    self.resItemN = nil
    self.resProductLayoutN = nil
    self.resProductTxtN = nil
    self.attackBtnN = nil
    self.closeBtnN = nil
end

local function DataDefine(self)
    self.showType = nil
    self.mineConf = nil
    self.myCaveInfo = nil
    self.caveInfo = nil
end

local function DataDestroy(self)
    self.showType = nil
    self.mineConf = nil
    self.myCaveInfo = nil
    self.caveInfo = nil
end

--[[
local function OnAddListener(self)
    base.OnAddListener(self)
end

local function OnRemoveListener(self)
    base.OnRemoveListener(self)
end
--]]

--showType:1,预览；2，刷新到的矿洞；3，自己的矿洞；4，即将解锁的矿洞
local function RefreshAll(self)
    local showType, num, alignObject = self:GetUserData()
    self.showType = showType
    if showType == 1 then
        self.mineConf = DataCenter.MineCaveManager:GetMineConf(num)
    elseif showType == 2 then
        self.caveInfo = DataCenter.MineCaveManager:GetMineInfo(num)
        self.mineConf = DataCenter.MineCaveManager:GetMineConf(self.caveInfo.mineId)
    elseif showType == 3 then
        self.myCaveInfo = DataCenter.MineCaveManager:GetMyCaveInfo(num)
        self.mineConf = DataCenter.MineCaveManager:GetMineConf(self.myCaveInfo.mineId)
    elseif showType == 4 then
        self.mineConf = DataCenter.MineCaveManager:GetMineConf(num)
    end
    self.alignObject = alignObject

    self.productSpeed = self.mineConf:GetResSpeed(DataCenter.BuildManager.MainLv)
    

    local res = {
        rewardType = self.mineConf.rewardType,
        itemId = self.mineConf.rewardId,
        count = self.productSpeed
    }
    self.resItemN:ReInit(res)
    
    
    

    if self.showType == 1 then
        self:ShowPreview()
    elseif self.showType == 4 then
        local tempInfo = DataCenter.MineCaveManager:GetToUnlockMinesInfo()
        if tempInfo then
            self.toUnlockTipN:SetText(Localization:GetString("302328", tempInfo.score))
        else
            self.toUnlockTipN:SetText("")
        end
        self:ShowToUnlock(self)
    end
    CS.UnityEngine.UI.LayoutRebuilder.ForceRebuildLayoutImmediate(self.offsetN.rectTransform)
    self:CheckAlign()

end


local function ShowPreview(self)
    self.iconN:SetActive(true)
    self.iconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s3", self.mineConf.picture))
    self.nameN:SetLocalText(self.mineConf.name)
    self.levelTxtN:SetLocalText(302220, self.mineConf.level)
    self.remain:SetActive(true)
    self.remain_txt:SetText(UITimeManager:GetInstance():SecondToFmtString(self.mineConf.occupyTime))
    self.toUnlockN:SetActive(false)
end


local function ShowToUnlock(self)
    self.iconN:SetActive(true)
    self.iconN:LoadSprite(string.format("Assets/Main/Sprites/UI/UIMineCave/%s3", self.mineConf.picture))
    self.nameN:SetLocalText(self.mineConf.name)
    self.levelTxtN:SetLocalText(302220, self.mineConf.level)
    self.remain:SetActive(false)
    self.toUnlockN:SetActive(true)
end




local function CheckAlign(self)
    local _arrowX = 0
    local _arrowY = 0
    local ScreenSize = CS.UnityEngine.Screen
    local ScreenWidth = ScreenSize.width

    local scale = ScreenWidth / 750.0
    local _rect = self.offsetN.rectTransform.rect
    local BgWidth = _rect.width * scale
    local BgHeight = _rect.height * scale
    local alignObject = self.alignObject
    local aboveValue = 1 --1表示箭头向上，-1表示箭头向下
    -- 目前这个先不做成自适应的了,回头有需求的再改吧
    -- 获取当前的屏幕坐标
    local _screenPos = PosConverse.WorldToScreenPos(alignObject.transform.position)
    local objWidth = alignObject.rectTransform.rect.width * scale
    local objHeight = alignObject.rectTransform.rect.height
    local pivot = Vector2.New(0.5, 0.5)
    if (_screenPos.y - objHeight*0.5 - BgHeight <0) then
        pivot.y = Pivot_Min
        _arrowY = -BgHeight / scale *0.5-3
        aboveValue = -1
    else
        pivot.y = Pivot_Max
        _arrowY = BgHeight / scale * 0.5+3
        aboveValue = 1
    end
    if (_screenPos.x - BgWidth *0.5 <=1) then
        pivot.x = Pivot_Min
        _arrowX = -BgWidth / scale*0.5*0.8
    elseif (_screenPos.x + BgWidth*0.5 > ScreenWidth-1) then
        pivot.x = Pivot_Max
        _arrowX = BgWidth / scale*0.5*0.8
    else
        pivot.x = Pivot_Mid
        _arrowX = 0
    end

    self.arrowN.rectTransform.anchoredPosition = Vector2.New(_arrowX, _arrowY)

    self.offsetN.rectTransform.pivot = pivot
    
    self.offsetN.transform.position = self.alignObject.transform.position+Vector3.New(0,-(objHeight*0.5*aboveValue),0)
end

local function OnClickAttackBtn(self)
    DataCenter.MineCaveManager:CacheTargetMineInfo(self.caveInfo)
    EventManager:GetInstance():Broadcast(EventId.MineCaveShowDispatch, true)
    self.ctrl:CloseSelf()

    --local id = MineCavePveLevelId--tonumber(self.mineConf.monsterId)
    --local pveTemplate = DataCenter.PveLevelTemplateManager:GetTemplate(id)
    --if pveTemplate ~= nil then
    --    self.ctrl:CloseSelf()
    --    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIActivityCenterTable)
    --    local param = {}
    --    param.pveEntrance = PveEntrance.MineCave
    --    param.levelId = id
    --    param.isStart = true
    --    Logger.Log("UIMineCaveUnlockView StartPve|", id)
    --    DataCenter.BattleLevel:Enter(param)
    --end
end


UIMineCaveUnlockView.OnCreate = OnCreate
UIMineCaveUnlockView.OnDestroy = OnDestroy
--UIMineCaveUnlockView.OnAddListener = OnAddListener
--UIMineCaveUnlockView.OnRemoveListener = OnRemoveListener
UIMineCaveUnlockView.ComponentDefine = ComponentDefine
UIMineCaveUnlockView.ComponentDestroy = ComponentDestroy
UIMineCaveUnlockView.DataDefine = DataDefine
UIMineCaveUnlockView.DataDestroy = DataDestroy

UIMineCaveUnlockView.RefreshAll = RefreshAll
UIMineCaveUnlockView.ShowPreview = ShowPreview
UIMineCaveUnlockView.ShowToUnlock = ShowToUnlock
UIMineCaveUnlockView.CheckAlign = CheckAlign

return UIMineCaveUnlockView