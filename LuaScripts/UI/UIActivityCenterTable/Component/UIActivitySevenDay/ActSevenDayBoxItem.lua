---
--- Generated by EmmyLua(https://github.com/EmmyLua)
--- Created by zzl.
--- DateTime: 
---
local ActSevenDayBoxItem = BaseClass("ActSevenDayBoxItem",UIBaseContainer)
local base = UIBaseContainer
local Localization = CS.GameEntry.Localization
local ItemIcon = "ItemIcon"
local ImgQuality = "ImgQuality"
local NumText = "NumText"
local ImgRece = "ImgRece"
local path = ""
function ActSevenDayBoxItem:OnCreate()
    base.OnCreate(self)
    
    self._icon_img = self:AddComponent(UIImage,ItemIcon)
    self._item_quality = self:AddComponent(UIImage, ImgQuality)
    self._num_txt = self:AddComponent(UITextMeshProUGUI,NumText)
    self._img_rece = self:AddComponent(UIImage,ImgRece)
    self._box_btn = self:AddComponent(UIButton,path)
    self._box_btn:SetOnClick(function()
        self:OnClickGo()
    end)
end

function ActSevenDayBoxItem:OnDestroy()
   -- self._icon_img = nil
    base.OnDestroy(self)
end

function ActSevenDayBoxItem:OnEnable()
    base.OnEnable(self)
end

function ActSevenDayBoxItem:OnDisable()

    base.OnDisable(self)
end

function ActSevenDayBoxItem:RefreshData(index,data,curscore,effect,actId)
    self.rewardData = data
    self.effect = effect
    --宝箱状态 0未领取,  1已领取
    self.state = self.rewardData.rewardFlag
    --当前分数
    self.curscore = curscore
    self.index = index
    self.actId = actId
    self:RefreshBox()
    self:RefreshBoxState()
end

function ActSevenDayBoxItem:RefreshBox()
    if not next(self.rewardData.reward) then
        return
    end
    table.walk(self.rewardData.reward,function (k,v)
        local id = v.itemId
        local goods = DataCenter.ItemTemplateManager:GetItemTemplate(id)
        if goods~=nil then
            self._icon_img:LoadSprite(string.format(LoadPath.ItemPath,goods.icon))
            self.itemName = goods.name
            self.itemDesc = goods.description
            self._item_quality:LoadSprite(DataCenter.ItemTemplateManager:GetToolBgByColor(goods.color))
            self._num_txt:SetText(v.count)
        end
    end)
end

--盒子状态
function ActSevenDayBoxItem:RefreshBoxState()
    self._img_rece:SetActive(self.state == 1)
    if self.state == 0 then
        if self.curscore >= self.rewardData.needScore then
            self.effect:SetActive(true)
            self.effect:Enable(true)
        end
    end
end


function ActSevenDayBoxItem:OnClickReward()
    local x = self.transform.position.x
    local y = self.transform.position.y
    local offset = 50
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIActivityRewardTip,Localization:GetString("370101"),ActivityEventType.PERSONAL,x,y,false,self.eventInfo.rewardScoreIndexArr[index],offset)
end

function ActSevenDayBoxItem:OnClickGo()
    if self.state == 0 then
        if self.curscore >= self.rewardData.needScore then
            SFSNetwork.SendMessage(MsgDefines.ReceiveSevenDayActReward,self.actId,self.index)
            return
        end
    end

    local param = {}
    param["itemName"] = self.itemName
    param["itemDesc"] = self.itemDesc
    param["alignObject"] = self._icon_img
    UIManager:GetInstance():OpenWindow(UIWindowNames.UIItemTips,{anim = true}, param)

end

return ActSevenDayBoxItem