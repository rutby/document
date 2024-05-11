---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by guqu.
--- DateTime: 2020/11/16 20:45
---
local RankItemShow =
{
    type = RankType.None,
    uid ="",
    firstName ="",
    secondName = "",
    rank =-1,
    donation = "", 
    alliance_honor =""
}
local OneData = DataClass("OneData", RankItemShow)
local UIAllianceRankDetailListCtrl = BaseClass("UIAllianceRankDetailListCtrl", UIBaseCtrl)
local function CloseSelf(self)
    UIManager:GetInstance():DestroyWindow(UIWindowNames.UIAllianceRankDetailList)
end

local function Close(self)
    UIManager:GetInstance():DestroyWindowByLayer(UILayer.Normal)
end

local function GetSelfData(self,type)
    local oneData = OneData.New()
    oneData.type =type
    local data = DataCenter.AllianceDonateRankDataManager:GetSelfRankDataByType(type)
    if  data~=nil then
        oneData.uid = data.uid
        oneData.rank = data.rank
        oneData.firstName = data.name
        oneData.secondName = ""
        oneData.donation = string.GetFormattedSeperatorNum(data.donation)
        oneData.alliance_honor = string.GetFormattedSeperatorNum(data.alliance_honor)
    else
        oneData.uid = ""
        oneData.rank = -1
        oneData.firstName = ""
        oneData.secondName = ""
        oneData.donation = 0
        oneData.alliance_honor = 0
    end
    return oneData
end

local function GetOneDataShow(self,type,item)
    local oneData = OneData.New()
    oneData.type =type
    if item ~=nil then
        oneData.uid = item.uid
        oneData.rank = item.rank
        oneData.firstName = item.name
        oneData.secondName = ""
        oneData.donation = string.GetFormattedSeperatorNum(item.donation)
        oneData.alliance_honor = string.GetFormattedSeperatorNum(item.alliance_honor)
    else
        oneData.uid = ""
        oneData.rank = -1
        oneData.firstName = ""
        oneData.secondName = ""
        oneData.donation = 0
        oneData.alliance_honor = 0
    end
    return oneData
end

local function GetRankList(self,type)
    local showList = {}
    showList.refreshTime = DataCenter.AllianceDonateRankDataManager:GetAllianceRefreshTimeByType(type)
    showList.rankList ={}
    local list = DataCenter.AllianceDonateRankDataManager:GetAllianceRankListByType(type)
    table.walk(list,function (k,v)
        local oneData = self:GetOneDataShow(type,v)
        if oneData~=nil then
            table.insert(showList.rankList,oneData)
        end
    end)
    return showList
end


UIAllianceRankDetailListCtrl.CloseSelf = CloseSelf
UIAllianceRankDetailListCtrl.Close = Close
UIAllianceRankDetailListCtrl.GetSelfData = GetSelfData
UIAllianceRankDetailListCtrl.GetOneDataShow = GetOneDataShow
UIAllianceRankDetailListCtrl.GetRankList = GetRankList

return UIAllianceRankDetailListCtrl