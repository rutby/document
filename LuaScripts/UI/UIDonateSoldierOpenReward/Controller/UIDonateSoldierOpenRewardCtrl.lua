local UIDonateSoldierOpenRewardCtrl = BaseClass("UIDonateSoldierOpenRewardCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIDonateSoldierOpenReward)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function CreateGoodsMap(self, stageArr)
    local idArr = {}
    local goodsMap = {}
	local mergeArr = {}
    for _,v in ipairs(stageArr) do
        if v.specialState == 0 then
            if idArr[v.id] == nil then
                idArr[v.id] = 1
            end

            if goodsMap[v.goodsId] == nil then
                goodsMap[v.goodsId] = v.goodsNum
            else
                goodsMap[v.goodsId] = goodsMap[v.goodsId] + v.goodsNum
            end

            for _,rewardObj in ipairs(v.specialReward) do
                if mergeArr[rewardObj.value.id] == nil then
                    mergeArr[rewardObj.value.id] = rewardObj.value.num
                else
                    mergeArr[rewardObj.value.id] = mergeArr[rewardObj.value.id] + rewardObj.value.num
                end
            end
        end
    end

	return idArr, goodsMap, mergeArr
end

UIDonateSoldierOpenRewardCtrl.CloseSelf = CloseSelf
UIDonateSoldierOpenRewardCtrl.Close = Close
UIDonateSoldierOpenRewardCtrl.OnReceiveStageReward = OnReceiveStageReward
UIDonateSoldierOpenRewardCtrl.CreateGoodsMap = CreateGoodsMap


return UIDonateSoldierOpenRewardCtrl