---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by 1020.
--- DateTime: 2023/5/23 15:32
---

local UIScratchOffRecordPageCtrl = BaseClass("UIScratchOffRecordPageCtrl", UIBaseCtrl)

function UIScratchOffRecordPageCtrl : CloseSelf()
    UIManager:GetInstance():DestroyWindow(UIWindowNames.ScratchOffRecordPage)
end

function UIScratchOffRecordPageCtrl : GetItemInfoList(activityId)
    local itemInfoList = {}
    local recordInfoList = DataCenter.ScratchOffGameManager:GetRewardRecordInfoListByActId(activityId)
	local listNum = #recordInfoList
    if recordInfoList and listNum > 0 then
        for k,v in ipairs(recordInfoList) do
            local itemInfo = {}
            itemInfo.uid = v.uid
            itemInfo.serverId = tonumber(v.serverId)
            itemInfo.pic = v.pic
            itemInfo.picVer = v.picVer
            itemInfo.playerName = v.name
            itemInfo.time = v.time
            itemInfo.lottery = v.diamond
            itemInfo.lotteryRank = DataCenter.ScratchOffGameManager:GetScratchOffRankBySpecialId(v.specialItemId)
            itemInfo.lotteryIcon = DataCenter.ScratchOffGameManager:GetScratchOffLuckyIconBySpecialId(v.specialItemId)

            table.insert(itemInfoList, itemInfo)
        end
    end
    
    return itemInfoList
end

return UIScratchOffRecordPageCtrl