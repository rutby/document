
local MiningRewardItem = BaseClass("MiningRewardItem", UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local UIMiningRewardCell = require "UI.UIActivityCenterTable.Component.Mining.UIMiningRewardCell"

-- 创建
function MiningRewardItem : OnCreate()
    base.OnCreate(self)
    self:DataDefine()
    self:ComponentDefine()
end

-- 销毁
function MiningRewardItem : OnDestroy()
    DOTween.Kill(self._progress_img.transform)
    self:ComponentDestroy()
    self:DataDestroy()
    base.OnDestroy(self)
end

function MiningRewardItem : DataDefine()

end

function MiningRewardItem : DataDestroy()

end

function MiningRewardItem : ComponentDefine()
    self.item1 = self:AddComponent(UIMiningRewardCell, "Reward1/UIMiningRewardCell1")
    self.item2 = self:AddComponent(UIMiningRewardCell, "Reward2/UIMiningRewardCell2")
    self.item1_Vfx = self:AddComponent(UIBaseContainer, "Reward1/VFX_Effect1")  --流光   
    self.item2_Vfx = self:AddComponent(UIBaseContainer, "Reward2/VFX_Effect2")
    self.item1_1_Vfx = self:AddComponent(UIBaseContainer, "Reward1/VFX_Effect1_1")  --扫光        
    self.item2_2_Vfx = self:AddComponent(UIBaseContainer, "Reward2/VFX_Effect2_2")
    self._needScore_txt = self:AddComponent(UIText,"Txt_NeedScore")
    self._progress_img = self:AddComponent(UIImage,"Img_Progress")

    self._glow_rect = self:AddComponent(UIImage,"Rect_Glow")
    self.glowMat = self._glow_rect:GetMaterial()
end

function MiningRewardItem : ComponentDestroy()

end

function MiningRewardItem : SetData(data,unlock,activityId,curScore,proTab)
    if data == nil then
        return
    end
    self._progress_img:SetMaterial(nil)
    self.item1:SetData(curScore,data,1)
    self.item2:SetData(curScore,data,2)
    self._needScore_txt:SetText(string.GetFormattedSeperatorNum(data.needScore))
    self.item1:ReInit(data.normalReward[1],activityId)
    self.item2:ReInit(data.specialReward[1],activityId)
    self.item1:SetCheckActive(false,false)
    self.item2:SetCheckActive(false,false)
    self.item2:SetCheckLock(unlock == 0)
    self.item1_Vfx:SetActive(false)
    self.item2_Vfx:SetActive(false)
    self.item1_1_Vfx:SetActive(false)
    self.item2_2_Vfx:SetActive(false)
    self.v1State = false
    self.v2State = false
    local activityInfo = DataCenter.ActivityListDataManager:GetActivityDataById(tostring(activityId))
    local str = {}
    if activityInfo.para7 and activityInfo.para7 ~= "" then
        str = string.split(activityInfo.para7,";")
    end
    for i = 1, table.count(str) do
        if data.normalReward[1].itemId and data.normalReward[1].itemId == str[i] then
            self.v1State = true
            break
        end
    end
    for i = 1, table.count(str) do
        if data.specialReward[1].itemId and data.specialReward[1].itemId == str[i] then
            self.v2State = true
            break
        end
    end


    if data.normalState == 0 and curScore >= data.needScore then    --可领奖
        self.item1_1_Vfx:SetActive(true)
    else
        if data.normalState == 1 then
            self.v1State = false
            self.item1:SetCheckActive(true,true)
        else
            self.item1:SetCheckActive(true,false)       --不可领奖
        end
    end
    self.item1_Vfx:SetActive(self.v1State)
    
    if unlock ~= 0 and data.specialState == 0 and curScore >= data.needScore then --可领奖
        self.item2_2_Vfx:SetActive(true)
    end
    if curScore >= data.needScore then
        if data.specialState == 1 then
            self.v2State = false
            self.item2:SetCheckActive(true,true)
        end
    else
        self.item2:SetCheckActive(true,false)
    end
    self.item2_Vfx:SetActive(self.v2State)
    
    --计算进度条长度
    if curScore >= data.needScore then
        self._progress_img:SetAnchorMinXY(0.5,1)
        self._progress_img:SetAnchorMaxXY(0.5,1)
        self._progress_img:SetAnchoredPositionXY(0,0)
        self._progress_img:SetPivotXY(0.5,1)
        self._progress_img:SetSizeDelta({x = 13,y = 130})
    else
        self._progress_img:SetAnchorMinXY(0.5,0)
        self._progress_img:SetAnchorMaxXY(0.5,0)
        self._progress_img:SetAnchoredPositionXY(0,-15)
        self._progress_img:SetPivotXY(0.5,0)
        if proTab[1] == (data.stage - 1) then
            local height = proTab[2]
            if height ~= 0 then
                height = height + 15
            end
            self._progress_img:SetSizeDelta({x = 13,y = height})
        else
            self._progress_img:SetSizeDelta({x = 13,y = 0})
        end
    end
end

function MiningRewardItem:RefreshData(data,unlock,curScore,proTab)
    self.item1:SetData(curScore,data,1)
    self.item2:SetData(curScore,data,2)
    self.item1:SetCheckActive(false,false)
    self.item2:SetCheckActive(false,false)
    self.item2:SetCheckLock(unlock == 0)
    self.item1_Vfx:SetActive(false)
    self.item2_Vfx:SetActive(false)
    self.item1_1_Vfx:SetActive(false)
    self.item2_2_Vfx:SetActive(false)
    
 
    if data.normalState == 0 and curScore >= data.needScore then    --可领奖
        self.item1_1_Vfx:SetActive(true)
    else
        if data.normalState == 1 then
            self.v1State = false
            self.item1:SetCheckActive(true,true)
        else
            self.item1:SetCheckActive(true,false)       --不可领奖
        end
    end
    self.item1_Vfx:SetActive(self.v1State)
    
  
    if unlock ~= 0 and data.specialState == 0 and curScore >= data.needScore then --可领奖
        self.item2_2_Vfx:SetActive(true)
    end
    if curScore >= data.needScore then
        if data.specialState == 1 then
            self.v2State = false
            self.item2:SetCheckActive(true,true)
        end
    else
        self.item2:SetCheckActive(true,false)
    end
    self.item2_Vfx:SetActive(self.v2State)
    
    --计算进度条长度
    if curScore >= data.needScore then
        self._progress_img:SetAnchorMinXY(0.5,1)
        self._progress_img:SetAnchorMaxXY(0.5,1)
        self._progress_img:SetAnchoredPositionXY(0,0)
        self._progress_img:SetPivotXY(0.5,1)
        self._progress_img:SetSizeDelta({x = 13,y = 130})
    else
        self._progress_img:SetAnchorMinXY(0.5,0)
        self._progress_img:SetAnchorMaxXY(0.5,0)
        self._progress_img:SetAnchoredPositionXY(0,-15)
        self._progress_img:SetPivotXY(0.5,0)
        if proTab[1] == (data.stage - 1) then
            local height = proTab[2]
            if height ~= 0 then
                height = height + 15
            end
            self._progress_img:SetSizeDelta({x = 13,y = height})
        else
            self._progress_img:SetSizeDelta({x = 13,y = 0})
        end
    end
end

function MiningRewardItem:ChangeMat()
    if self._progress_img.activeCached then
        self._progress_img:SetMaterial(self.glowMat)
        self.delayMatTime = TimerManager:GetInstance():DelayInvoke(function()
            if self._progress_img.activeCached then
                self._progress_img:SetMaterial(nil)
            end
        end, 0.2)
    end
end

function MiningRewardItem:CheckDoTween(data,curScore,proTab)
    local y = self._progress_img:GetSizeDelta().y
    if curScore >= data.needScore then
        if y ~= 130 then
           return 130
        end
    else
        if proTab[1] == (data.stage - 1) then
            local height = proTab[2]
            if height ~= 0 then
                height = height + 15
            end
            return height
        end
    end
    return 0
end

function MiningRewardItem:DoProTween(value,data,unlock,curScore,proTab,list,callback)
    if value == 130 then
        self._progress_img:SetAnchoredPositionXY(0,-25)
    end
    self._progress_img.rectTransform:DOSizeDelta(Vector2.New(13, value),0.5,true):OnComplete(function()
        if table.count(list) > 0 then
            table.remove(list,1)
        end
        if callback then
            callback(list)
        end
        self:RefreshData(data,unlock,curScore,proTab)
    end)
end

return MiningRewardItem