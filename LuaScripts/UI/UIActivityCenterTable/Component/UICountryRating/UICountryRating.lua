--- Created by zzl
--- DateTime: 2023/10/18 18:36
--- 国家评分
local base = UIBaseContainer
local UICountryRating = BaseClass("UICountryRating", base)
local constValue = {0.16,0.36,0.56,0.76}--先快速实现先
local Localization = CS.GameEntry.Localization
local BgPath = {"UIrate_box_ban01","UIrate_box_ban02","UIrate_box_ban03"}
function UICountryRating:OnCreate()
    base.OnCreate(self)
    self:ComponentDefine()
end

function UICountryRating:ComponentDefine()
    self._title_txt = self:AddComponent(UIText, "RightView/Rect_Bottom/Top/title")
    self._title2_txt = self:AddComponent(UIText, "RightView/Rect_Bottom/Top/subTitle")
    self._actTime_txt = self:AddComponent(UIText, "RightView/Rect_Bottom/Top/actTime")
    self._slider_pro = self:AddComponent(UISlider, "RightView/Rect_Bottom/Slider")
    
    self._tips_txt = self:AddComponent(UIText,"RightView/Rect_Bottom/Txt_Tips")
    
    self._shop_btn = self:AddComponent(UIButton,"RightView/Rect_Bottom/Btn_Shop")
    self._shop_btn:SetOnClick(function()
        self:OnClickUrl()
    end)
    self._shop_txt = self:AddComponent(UIText,"RightView/Rect_Bottom/Btn_Shop/Txt_Shop")
    self._shop_txt:SetLocalText(121554)
    
    self.boxList = {}
    for i = 1, 5 do
        self.boxList[i] = {}
        self.boxList[i].btn = self:AddComponent(UIButton,"RightView/Rect_Bottom/Rect_Rating/BoxGo/Box"..i)
        self.boxList[i].btn:SetOnClick(function()
           self:OnClickGetReward(i)
        end)
        self.boxList[i].effect = self:AddComponent(UIBaseContainer,"RightView/Rect_Bottom/Rect_Rating/BoxGo/Box"..i.."/EffectGo"..i)
        self.boxList[i].icon1 = self:AddComponent(UIImage,"RightView/Rect_Bottom/Rect_Rating/BoxGo/Box"..i.."/Img_Icon"..i)
        self.boxList[i].red = self:AddComponent(UIImage,"RightView/Rect_Bottom/Rect_Rating/BoxGo/Box"..i.."/Img_Icon"..i.."/Rect_Red"..i)
        self.boxList[i].icon2 = self:AddComponent(UIImage,"RightView/Rect_Bottom/Rect_Rating/BoxGo/Box"..i.."/Img_Icon"..i.."_1")
        self.boxList[i].score = self:AddComponent(UIText,"RightView/Rect_Bottom/Rect_Rating/BoxGo/Box"..i.."/Txt_Score"..i)
    end
end

function UICountryRating:OnDestroy()
    base.OnDestroy(self)
end

function UICountryRating:OnEnable()
    base.OnEnable(self)
end

function UICountryRating:OnAddListener()
    base.OnAddListener(self)
    self:AddUIListener(EventId.StoreEvaluateInfo, self.RefreshUI)
    self:AddUIListener(EventId.StoreEvaluateReward, self.RefreshReward)
end

function UICountryRating:OnRemoveListener()
    base.OnRemoveListener(self)
    self:RemoveUIListener(EventId.StoreEvaluateInfo, self.RefreshUI)
    self:RemoveUIListener(EventId.StoreEvaluateReward, self.RefreshReward)
end

function UICountryRating:SetData(activityId)
    self.activityId = activityId
    local activityData = DataCenter.ActivityListDataManager:GetActivityDataById(activityId)
    self._title_txt:SetLocalText(activityData.name)
    self._title2_txt:SetLocalText(activityData.desc_info)
    local startT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityData.startTime)
    local endT = UITimeManager:GetInstance():TimeStampToDayForLocal(activityData.endTime - 1000)
    self._actTime_txt:SetText(startT .. "-" .. endT)
    self._tips_txt:SetLocalText(375076)
    SFSNetwork.SendMessage(MsgDefines.GetStoreEvaluateActivityInfo, tonumber(activityId))
end

function UICountryRating:RefreshUI()
    self.data = DataCenter.CountryRatingData:GetInfoByActId(tonumber(self.activityId))
    if not self.data then
        return
    end
    
    --满分5分
    if self.data.curScore then
        local stageArr = self.data.stageArr
        local starScore = 0 --起始分数
        local beforeScore = 0
        local afterScore = 0
        local curStage = 0
        if self.data.stageArr then
            for i = 1, #stageArr do
                self.boxList[i].score:SetText(stageArr[i].needScore)
                self.boxList[i].icon1:SetActive(stageArr[i].state == 0)
                self.boxList[i].icon2:SetActive(stageArr[i].state == 1)
                self.boxList[i].effect:SetActive(stageArr[i].state == 0 and self.data.curScore >= stageArr[i].needScore)
                self.boxList[i].red:SetActive(stageArr[i].state == 0 and self.data.curScore >= stageArr[i].needScore)
                if starScore == 0 and stageArr[i].stage == 1 then
                    starScore = stageArr[i].needScore
                end
                if self.data.curScore >= stageArr[i].needScore then
                    beforeScore = stageArr[i].needScore
                    curStage = stageArr[i].stage
                end
                if afterScore == 0 and self.data.curScore < stageArr[i].needScore then
                    afterScore =  stageArr[i].needScore
                end

                if stageArr[i].state == 1 then
                    self.boxList[i].btn:LoadSprite(string.format(LoadPath.UICountryRating,BgPath[1]))
                elseif stageArr[i].state == 0 and self.data.curScore >= stageArr[i].needScore then
                    self.boxList[i].btn:LoadSprite(string.format(LoadPath.UICountryRating,BgPath[2]))
                else
                    self.boxList[i].btn:LoadSprite(string.format(LoadPath.UICountryRating,BgPath[3]))
                end
            end
        end
        if curStage == 0 then
            self._slider_pro:SetValue(0)
        elseif curStage ~= 5 then
            self._slider_pro:SetValue(constValue[curStage] + ((afterScore - beforeScore)/self.data.curScore))
        else
            self._slider_pro:SetValue(1)
        end
    end
end

function UICountryRating:RefreshReward(stage)
    self.boxList[stage].icon1:SetActive(false)
    self.boxList[stage].icon2:SetActive(true)
    self.boxList[stage].effect:SetActive(false)
    self.boxList[stage].red:SetActive(false)
    self.data.stageArr[stage].stage = 1
    self.boxList[stage].btn:LoadSprite(string.format(LoadPath.UICountryRating,BgPath[1]))
end

function UICountryRating:OnClickGetReward(index)
    local stageArr = self.data.stageArr
    if stageArr[index].state == 0 and self.data.curScore >= stageArr[index].needScore then
        SFSNetwork.SendMessage(MsgDefines.ReceiveStoreEvaluateStageReward, tonumber(self.activityId),index)
    elseif stageArr[index].state ~= 1 then
        --打开tips
        local x = self.boxList[index].btn.transform.position.x
        local y = self.boxList[index].btn.transform.position.y
        local offset = 50
        UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip,Localization:GetString("370101",1),ActivityEnum.ActivityType.CountryRating,x,y,false,index,offset,self.activityId)
    end
end

function UICountryRating:OnClickUrl()
    CS.UnityEngine.Application.OpenURL(CS.GameEntry.GlobalData.downloadurl)
end

return UICountryRating