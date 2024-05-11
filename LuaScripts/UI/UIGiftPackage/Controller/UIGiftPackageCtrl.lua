

local UIGiftPackageCtrl = BaseClass("UIGiftPackageCtrl", UIBaseCtrl)

local function CloseSelf(self)
	UIManager.Instance:DestroyWindow(UIWindowNames.UIGiftPackage)
end

local function Close(self)
	UIManager.Instance:DestroyWindowByLayer(UILayer.Normal, false)
end

local function BuyGift(self,info,selectedCombineIndex)
     local vec = string.split(info:getItem2Str(),"@",0,true)
     local combinationData = ""
     if vec ~= nil and selectedCombineIndex ~= nil and selectedCombineIndex < #vec then
         combinationData = vec[self.model.selectedCombineIndex]
     end
    
    
    DataCenter.PayManager:CallPayment(info, "GoldExchangeView", combinationData)
	--self:CloseSelf()
end



local function GetTypeButtonList(self)
    
    -- 添加特殊礼包和超值礼包
    local tagInfos = WelfareController.getShowTagInfos()
    local realInfo = {}
    for i = 1, #tagInfos do
        local activity_dailyType = tagInfos[i]:getDailyType()
        if tonumber(activity_dailyType) ~= ActivityShowLocation.welfareCenter  then
            table.insert(realInfo,tagInfos[i])
        end
    end
    return realInfo

    
    
    
    
    --local resultList = {}
    --local resultNameList = {}
    --table.insert(resultList,UIGiftTypeButtonType.Hot)
    --table.insert(resultList,UIGiftTypeButtonType.Diamond)
    --resultNameList[UIGiftTypeButtonType.Hot] = Localization:GetString("100073")
    --resultNameList[UIGiftTypeButtonType.Diamond] = Localization:GetString("320012")
    --local mainLv = DataCenter.BuildManager.MainLv
    --local tableTemplate = DataTable:GetAllCsvDataRows("exchange_page")
    --if tableTemplate ~= nil then
    --    for k,v in pairs(tableTemplate) do
    --        local id = v:GetString("id")
    --        if GiftPackageData:GetInstance():CheckPackageAvailable("22", id) then
    --            local condition = v:GetString("condition")
    --            local name = v:GetString("name")
    --            if condition == nil or condition == "" then
    --                table.insert(resultList,id)
    --                resultNameList[id] = Localization:GetString(name)
    --            else
    --                local con = string.split(condition,";")
    --                if con ~= nil and #con > 1 and mainLv >= tonumber(con[2]) then
    --                    table.insert(resultList,id)
    --                    resultNameList[id] = Localization:GetString(name)
    --                end
    --            end
    --        end
    --    end
    --end
    --return resultList,resultNameList
end

--获取钻石列表和价格对应id(图标显示)
local function GetDiamondList(self) 
    local list = {}
    local replaceList = {}
    local result = {}
    local resultDollar = {}
    local all = GiftPackageData:GetInstance().GiftPackageDict
    if all ~= nil then
        for k,v in pairs(all) do
            if v:GetIsShowType() == 0 and v.type == "1" and GiftPackageData:GetInstance():IsSpecialExchange(v.id) then
                table.insert(list,v)
                resultDollar[v.dollar] = v.id
            end
            if v.bought == false and v.popup_image ~= "new_recharge" and GiftPackageData:GetInstance():IsSpecialExchange(v.id) 
                    and (v.type == "2" or (v.type == "3" and v.popup_image == "close")) then
                local temp = replaceList[v.dollar]
                if temp == nil then
                    local lis = {}
                    table.insert(lis,v)
                    replaceList[v.dollar] = lis
                else
                    table.insert(replaceList[v.dollar],v)
                end
            end
        end
        
        --替换
        for k,v in pairs(list) do
            local temp = replaceList[v.dollar]
            if temp ~= nil then
                local popup = tonumber(v.popup)
                local continue = true
                for k1,v1 in ipairs(temp) do
                    if continue and tonumber(v1.popup) > popup then
                        table.insert(result,v1)
                        continue = false
                    end
                end
            else
                table.insert(result,v)
            end
        end
    end
    if #result > 0 then
        table.sort(result,function (a,b)
            return tonumber(a.dollar) < tonumber(b.dollar)
        end)
    end
    return result,resultDollar
end

UIGiftPackageCtrl.CloseSelf = CloseSelf
UIGiftPackageCtrl.Close = Close
UIGiftPackageCtrl.BuyGift = BuyGift
UIGiftPackageCtrl.GetTypeButtonList = GetTypeButtonList
UIGiftPackageCtrl.GetDiamondList = GetDiamondList

return UIGiftPackageCtrl