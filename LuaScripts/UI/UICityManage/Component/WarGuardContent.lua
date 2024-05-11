--- Created by shimin.
--- DateTime: 2021/7/29 3:59
--- 迁城界面

local WarGuardContent = BaseClass("WarGuardContent", UIBaseContainer)
local base = UIBaseContainer
local WarGuardItemCell  = require("UI.UICityManage.Component.WarGuardItemCell")

local Localization = CS.GameEntry.Localization


--local des_txt_Path = "Text_Des"
--local power_txt_Path = "Text_power"
--local powerDes_txt_Path = "Text_power/Text_powerDes"
--local state_txt_Path = "Text_State"
--local cityLevel_txt_Path = "title_cityLevel"
--local cityStatus_txt_Path = "title_cityStatus"

local scroll_view_path = "ScrollView"


TabType =
{
    
}

--创建
local function OnCreate(self)
    base.OnCreate(self)
    self:ComponentDefine()
   -- self:ReInit()
end

-- 销毁
local function OnDestroy(self)
    self:ComponentDestroy()
    base.OnDestroy(self)
end

local function ComponentDefine(self)

    self.scroll_view = self:AddComponent(UIScrollView, scroll_view_path)
    self.scroll_view:SetOnItemMoveIn(function(itemObj, index)
        self:OnItemMoveIn(itemObj, index)
    end)
    self.scroll_view:SetOnItemMoveOut(function(itemObj, index)
        self:OnItemMoveOut(itemObj, index)
    end)
    self.itemList ={}
    self.cells = {}


    self.items = {}
    self.BuyItemList = {}
    self.buyItemNum = 0
    self.itemNum = 0
    self.moreIndex = 0

end

local function ComponentDestroy(self)
    self.itemList =nil
    self.cells = nil
    self.scroll_view = nil
    
    self.items = nil
    self.BuyItemList = nil
    self.buyItemNum = nil
    self.itemNum = nil
    self.moreIndex= nil
end


local function ReInit(self,param)
    if param ~= nil then
        --已有的item
        self.items = DataCenter.ItemData:GetItemList(tonumber(param.type),tonumber(param.type2))
        self.itemNum = #self.items
        --goods表里所有的items
       local allItemList = DataCenter.ItemTemplateManager:GetTypeListByTypes(tonumber(param.type),tonumber(param.type2))
        self.BuyItemList = {}
        for i, v in pairs(allItemList) do
            local isExist = false
            for j, v1 in pairs(self.items) do
                if v.id == v1.itemId then
                    isExist  = true
                end
            end
            if isExist == false and v.price > 0 then
                table.insert(self.BuyItemList, allItemList[i])
            end
        end
        
        self.buyItemNum = #self.BuyItemList
        self:InitData()

    end
end


local function InitData(self)
    self:ClearScroll(self)
    local count = self.itemNum + self.buyItemNum
    if count>0 then
        self.scroll_view:SetTotalCount(count)
        self.scroll_view:RefillCells()
    end
end


local function ClearScroll(self)
    self.cells = {}
    self.scroll_view:ClearCells()
    self.scroll_view:RemoveComponents(WarGuardItemCell)
end

local function OnItemMoveIn(self,itemObj, index)
    itemObj.name = tostring(index)
    self.cells[index] = self.scroll_view:AddComponent(WarGuardItemCell, itemObj)
    local param = {}
    if index > self.itemNum then -- 需要购买的item
        local item = self.BuyItemList[index - self.itemNum]
        param.name = DataCenter.ItemTemplateManager:GetName(item.id)
        param.description = item.description
        param.price = item.price
        param.icon = item.icon
        param.count  = 0
     else
        --通过itemid 得到在goods item 的信息
        local item = DataCenter.ItemTemplateManager:GetItemTemplate(self.items[index].itemId)
        param.name = DataCenter.ItemTemplateManager:GetName(item.id)
        param.description = item.description
        param.icon = item.icon
        param.count = self.items[index].count
        param.uuid = self.items[index].uuid
     end
    param.callBack = function(index) self:CellsCallBack(index) end
    param.index = index
    self.cells[index]:ReInit(param)
end

local function OnItemMoveOut(self, itemObj, index)
    self.cells[index] = nil
    self.scroll_view:RemoveComponent(itemObj.name, WarGuardItemCell)
end

local function CellsCallBack(self, index)
    if  SceneUtils.IsInBlackRange(LuaEntry.Player:GetMainWorldPos()) then
        UIUtil.ShowTipsId(250136)
        return 
    end
    local curTime = UITimeManager:GetInstance():GetServerTime()
    --local startTime = DataCenter.DefenceWallDataManager:GetEdenProtectTime()
    --if LuaEntry.Player.serverType == ServerType.EDEN_SERVER then
    --    local pos = LuaEntry.Player:GetMainWorldPos()
    --    local areaId = CS.SceneManager.World:GetAreaIdByPosId(pos-1)
    --    local myAllow = true
    --    local areaTemp = DataCenter.EdenAreaTemplateManager:GetTemplate(areaId)
    --    if areaTemp~=nil then
    --        if areaTemp.area_type ~= EdenAreaType.NORTH_BORN_AREA and areaTemp.area_type ~= EdenAreaType.SOUTH_BORN_AREA then
    --            myAllow = false
    --        end
    --    end
    --    if myAllow ==false and LuaEntry.DataConfig:CheckSwitch("eden_fight_area_broken_shield") then
    --        UIUtil.ShowTipsId(111233)
    --        return
    --    end
    --    
    --    local coldDownTime = LuaEntry.DataConfig:TryGetNum("eden_protect_cd", "k1")
    --    local deltaTime = startTime+coldDownTime*1000-curTime
    --    if deltaTime>0 then
    --        local str = Localization:GetString("111099",UITimeManager:GetInstance():MilliSecondToFmtString(deltaTime))
    --        UIUtil.ShowTips(str)
    --        return
    --    end
    --end
    --判断是否使用同类的buff
    local protectEndTime = DataCenter.DefenceWallDataManager:GetDefenceWallData().protectEndTime
    local leftTime = protectEndTime - curTime
    if leftTime > 0 then
        UIUtil.ShowMessage(Localization:GetString("129043"),2,"","", function()
            if index > self.itemNum then
                local template = self.BuyItemList[index - self.itemNum]
                if LuaEntry.Player.gold >= template.price then
                    UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog,Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING,
                            string.GetFormattedSeperatorNum(template.price),Localization:GetString(GameDialogDefine.DIAMOND),
                            DataCenter.ItemTemplateManager:GetName(template.id)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                        self:ConfirmBuy(template, time)
                    end)
                else
                    GoToUtil.GotoPayTips()
                end
            else
                self.moreIndex = index
                local item = self.items[index]
                self:ConfirmUse(item)
            end

        end, function()
        end)
    else
        if index > self.itemNum then
            local template = self.BuyItemList[index - self.itemNum]
            if LuaEntry.Player.gold >= template.price then
                UIUtil.ShowUseDiamondConfirm(TodayNoSecondConfirmType.BuyUseDialog,Localization:GetString(GameDialogDefine.SPEND_SOMETHING_BUY_SOMETHING,
                        string.GetFormattedSeperatorNum(template.price),Localization:GetString(GameDialogDefine.DIAMOND),
                        DataCenter.ItemTemplateManager:GetName(template.id)), 2, GameDialogDefine.CONFIRM, GameDialogDefine.CANCEL, function()
                    self:ConfirmBuy(template, time)

                end)
            else
                GoToUtil.GotoPayTips()
            end
        else
            self.moreIndex = index
            local item = self.items[index]
            self:ConfirmUse(item)
        end

    end
end

local function ConfirmUse(self,item)
    SFSNetwork.SendMessage(MsgDefines.ItemUse, { uuid = item.uuid,num = 1  })
end

local function ConfirmBuy(self,template)
    SFSNetwork.SendMessage(MsgDefines.ItemBuyAndUse, { itemId = tostring(template.id),num = 1 })
    --self.view:DoWhenUseProtectItem()
end

local function ItemUseRefresh(self,param)
    --已有的item
    self.items = DataCenter.ItemData:GetItemList(tonumber(param.type),tonumber(param.type2))
    self.itemNum = #self.items
    --goods表里所有的items
    local allItemList = DataCenter.ItemTemplateManager:GetTypeListByTypes(tonumber(param.type),tonumber(param.type2))
    self.BuyItemList = {}
    for i, v in pairs(allItemList) do
        local isExist = false
        for j, v1 in pairs(self.items) do
            if v.id == v1.itemId then
                isExist  = true
            end
        end
        if isExist == false and v.price > 0 then
            table.insert(self.BuyItemList, allItemList[i])
        end
    end
    self.scroll_view:RefillCells()
end

WarGuardContent.OnCreate = OnCreate
WarGuardContent.OnDestroy = OnDestroy
WarGuardContent.ComponentDefine = ComponentDefine
WarGuardContent.ComponentDestroy = ComponentDestroy
WarGuardContent.ReInit = ReInit
WarGuardContent.InitData = InitData
WarGuardContent.ClearScroll = ClearScroll
WarGuardContent.OnItemMoveIn = OnItemMoveIn
WarGuardContent.OnItemMoveOut = OnItemMoveOut
WarGuardContent.CellsCallBack = CellsCallBack
WarGuardContent.ConfirmUse = ConfirmUse
WarGuardContent.ConfirmBuy = ConfirmBuy
WarGuardContent.ItemUseRefresh = ItemUseRefresh

return WarGuardContent